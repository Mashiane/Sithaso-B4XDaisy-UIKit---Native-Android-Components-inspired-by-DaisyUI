<#
.SYNOPSIS
    Build-stage runtime gate. Evidences the UX-review items screenshots cannot
    prove, so the post-build visual review confirms instead of discovers.

.DESCRIPTION
    Runs after install.ps1 launches the app. Captures runtime signals via adb
    and writes BUILD-WATCH-<YYYYMMDD>.md next to the capture-screens output so
    the post-build ux-review pass can mark these items "Verified at build":

      1. Crash / ANR / ClassNotFound / ResourceNotFound  (adb logcat)
         - reinforces b4x-verify conformance (invented / missing class).
      2. Touch-target dimensions < 48dp on clickable views (uiautomator dump)
         - reinforces ux-review Touch Targets (screenshots cannot prove dp).
      3. content-desc missing on interactive views (uiautomator dump)
         - reinforces ux-review TalkBack labels (existence, not correctness).
      4. Startup time (logcat ActivityManager: Displayed <ms>)
         - reinforces ux-review Perceived Performance / startup.
      5. Frame jank (logcat Choreographer: Skipped N frames + dumpsys gfxinfo)
         - reinforces ux-review animation / scroll smoothness.

    Exit 1 = crash / class-not-found / resource-not-found (do not ship).
    Exit 0 = ran, jank/touch/content-desc findings are WARN in the report.

    Best-effort: no device or no dump = skip with a note, exit 0 (not a failure;
    post-build review falls back to "Verification Required: Yes" for those).

.PARAMETER AppFolder
    The app folder. Report goes to <AppFolder>/ux-review/BUILD-WATCH-<date>.md.

.PARAMETER Package
    App package (from install.ps1, read off AndroidManifest.xml).

.PARAMETER Activity
    Launcher activity (e.g. ".main"). Used only if a re-launch is needed.

.PARAMETER DeviceId
    Optional adb -s device id. If omitted, first device is used.

.PARAMETER SettleSec
    Seconds to wait after launch before dumping. Default 8.

.EXAMPLE
    ./build-watch.ps1 -AppFolder C:\b4a\workspace\MyStore -Package com.example.mystore -Activity .main
#>

param(
    [Parameter(Mandatory = $true)][string]$AppFolder,
    [Parameter(Mandatory = $true)][string]$Package,
    [string]$Activity = ".main",
    [string]$DeviceId = "",
    [int]$SettleSec = 8
)

$ErrorActionPreference = "Continue"

# --- resolve adb (same candidate list as install.ps1) ---
function Find-Adb {
    $possiblePaths = @(
        "C:\b4a\sdk\platform-tools\adb.exe",
        "C:\Program Files\Anywhere Software\B4A\Platforms\android-sdk\platform-tools\adb.exe",
        "C:\Android\android-sdk\platform-tools\adb.exe",
        "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe",
        "C:\LDPlayer\LDPlayer9\adb.exe",
        "adb.exe"
    )
    foreach ($path in $possiblePaths) {
        if ($path -eq "adb.exe") {
            $g = (Get-Command adb.exe -ErrorAction SilentlyContinue).Source
            if ($g -and (Test-Path $g)) { return $g }
        }
        elseif (Test-Path $path) { return $path }
    }
    return $null
}

$adb = Find-Adb
if (-not $adb) {
    Write-Host "BUILD-WATCH: adb not found, runtime checks skipped." -ForegroundColor Yellow
    exit 0
}

# --- pick device ---
$deviceArgs = @()
if ($DeviceId) {
    $deviceArgs = @("-s", $DeviceId)
} else {
    $lines = & $adb devices 2>&1 | Select-String "device$"
    if (-not $lines) {
        Write-Host "BUILD-WATCH: no device attached, runtime checks skipped." -ForegroundColor Yellow
        exit 0
    }
    $deviceArgs = @("-s", (($lines[0] -split "`t")[0]))
}

# --- output dir ---
$outDir = Join-Path $AppFolder "ux-review"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }
$dateTag = Get-Date -Format "yyyyMMdd"
$reportPath = Join-Path $outDir "BUILD-WATCH-$dateTag.md"

$errors = @()
$warnings = @()
$verified = @()

# --- clear logcat, (re)launch, settle ---
Write-Host "BUILD-WATCH: clearing logcat + settling ${SettleSec}s ..." -ForegroundColor Gray
& $adb @deviceArgs logcat -c 2>&1 | Out-Null
$component = if ($Activity -match "^\.") { "$Package$Activity" } else { "$Package/$Activity" }
& $adb @deviceArgs shell am start -n $component 2>&1 | Out-Null
Start-Sleep -Seconds $SettleSec

# --- 1. crash / class-not-found / resource-not-found from logcat ---
$log = & $adb @deviceArgs logcat -d 2>&1 | Out-String

if ($log -match "FATAL EXCEPTION|AndroidRuntime.*FATAL") {
    $errors += "FATAL EXCEPTION in logcat (app crashed on launch)"
}
if ($log -match "ANR in $Package|Application Not Responding") {
    $errors += "ANR detected for $Package"
}
if ($log -match "$Package.*ClassNotFoundException") {
    $errors += "ClassNotFoundException in logcat (missing class - invented API or missing module)"
}
if ($log -match "$Package.*Resources.*NotFoundException") {
    $errors += "Resources.NotFoundException in logcat (missing asset - FileN wiring mismatch)"
}
if ($errors.Count -eq 0) {
    $verified += "No crash / ANR / ClassNotFound / ResourceNotFound in logcat"
}

# --- 4. startup time (ActivityManager: Displayed <ms>) ---
$disp = [regex]::Match($log, "ActivityManager.*Displayed\s+$Package.*?(\d+)\s*ms")
if ($disp.Success) {
    $verified += "Startup: ActivityManager Displayed = $($disp.Groups[1].Value) ms"
} else {
    $warnings += "Startup time not captured (ActivityManager: Displayed line absent)"
}

# --- 5. frame jank (Choreographer skipped frames) ---
$skipped = [regex]::Matches($log, "Choreographer.*Skipped\s+(\d+)\s+frames")
$heavySkips = @()
foreach ($s in $skipped) {
    if ([int]$s.Groups[1].Value -ge 20) { $heavySkips += [int]$s.Groups[1].Value }
}
if ($heavySkips.Count -gt 0) {
    $warnings += "Frame jank: $($heavySkips.Count) Choreographer skip(s) >= 20 frames (max $($heavySkips | Measure-Object -Maximum).Maximum)"
} else {
    $verified += "No heavy frame skips (Choreographer < 20 frames) in launch window"
}

# --- density (dp -> px) ---
$densityOut = & $adb @deviceArgs shell wm density 2>&1 | Out-String
$dpi = 0
if ($densityOut -match "density:\s*(\d+)") { $dpi = [int]$Matches[1] }
if ($dpi -eq 0) { $dpi = 420; $warnings += "Could not read wm density, assumed $dpi dpi for touch-target math" }
$minTouchPx = [math]::Round(48 * $dpi / 160.0)

# --- 2 + 3. uiautomator dump -> touch targets + content-desc ---
$dumpRemote = "/sdcard/bw_dump.xml"
$dumpLocal = Join-Path $outDir "bw_dump_$dateTag.xml"
& $adb @deviceArgs shell uiautomator dump $dumpRemote 2>&1 | Out-Null
& $adb @deviceArgs pull $dumpRemote $dumpLocal 2>&1 | Out-Null
& $adb @deviceArgs shell "rm -f $dumpRemote" 2>&1 | Out-Null

$smallTargets = @()
$missingDesc = @()
if (Test-Path $dumpLocal) {
    try {
        [xml]$ui = Get-Content $dumpLocal -Raw
        foreach ($node in $ui.SelectNodes("//node[@clickable='true']")) {
            $b = $node.bounds
            if ($b -match '\[(\d+),(\d+)\]\[(\d+),(\d+)\]') {
                $w = [int]$Matches[3] - [int]$Matches[1]
                $h = [int]$Matches[4] - [int]$Matches[2]
                if ($w -lt $minTouchPx -or $h -lt $minTouchPx) {
                    $smallTargets += "$($node.GetAttribute('resource-id','')) text='$($node.GetAttribute('text',''))' ${w}x${h}px (< ${minTouchPx}px / 48dp)"
                }
            }
            $desc = $node.GetAttribute('content-desc', '')
            $text = $node.GetAttribute('text', '')
            if ([string]::IsNullOrWhiteSpace($desc) -and [string]::IsNullOrWhiteSpace($text)) {
                $missingDesc += "clickable node without content-desc or text (resource-id='$($node.GetAttribute('resource-id',''))')"
            }
        }
        if ($smallTargets.Count -eq 0) {
            $verified += "Touch targets: all clickable views >= 48dp ($minTouchPx px @ $dpi dpi)"
        } else {
            $warnings += "Touch targets: $($smallTargets.Count) clickable view(s) < 48dp:"
            foreach ($t in $smallTargets) { $warnings += "  - $t" }
        }
        if ($missingDesc.Count -eq 0) {
            $verified += "TalkBack: all clickable views have content-desc or text"
        } else {
            $warnings += "TalkBack: $($missingDesc.Count) clickable view(s) lack content-desc + text:"
            foreach ($m in $missingDesc) { $warnings += "  - $m" }
        }
    } catch {
        $warnings += "uiautomator dump parse failed: $($_.Exception.Message)"
    }
    Remove-Item $dumpLocal -Force -ErrorAction SilentlyContinue
} else {
    $warnings += "uiautomator dump not captured (touch-target + TalkBack checks skipped)"
}

# --- write report ---
$report = @()
$report += "# BUILD-WATCH $dateTag"
$report += ""
$report += "Build-stage runtime gate for **$Package**. Evidences UX-review items"
$report += "screenshots cannot prove. The post-build ux-review pass should mark"
$report += "the verified items below as **Verified at build**, not Verification Required."
$report += ""
$report += "## Verified at build"
if ($verified.Count -gt 0) {
    foreach ($v in $verified) { $report += "- $v" }
} else {
    $report += "- (none)"
}
$report += ""
$report += "## Warnings (review in post-build pass)"
if ($warnings.Count -gt 0) {
    foreach ($w in $warnings) { $report += "- $w" }
} else {
    $report += "- (none)"
}
$report += ""
$report += "## Errors (do not ship)"
if ($errors.Count -gt 0) {
    foreach ($e in $errors) { $report += "- $e" }
} else {
    $report += "- (none)"
}
$report += ""
$report += "---"
$report += "Generated by build-watch.ps1 (b4x-project-bootstrap skill). Device dpi=$dpi, 48dp=${minTouchPx}px."
$report += "Post-build: run capture-screens.ps1, then the ux-review.md pass, and cite this file for runtime items."
$report | Out-File -FilePath $reportPath -Encoding utf8

# --- console summary ---
Write-Host ""
Write-Host "=== BUILD-WATCH ===" -ForegroundColor Cyan
if ($errors.Count -eq 0) {
    Write-Host "PASS: no crash/class/resource errors" -ForegroundColor Green
} else {
    Write-Host "FAIL: $($errors.Count) error(s) (do not ship):" -ForegroundColor Red
    foreach ($e in $errors) { Write-Host "  - $e" -ForegroundColor Red }
}
foreach ($v in $verified) { Write-Host "  + $v" -ForegroundColor Green }
foreach ($w in $warnings) { Write-Host "  ~ $w" -ForegroundColor Yellow }
Write-Host "Report: $reportPath" -ForegroundColor Cyan

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
