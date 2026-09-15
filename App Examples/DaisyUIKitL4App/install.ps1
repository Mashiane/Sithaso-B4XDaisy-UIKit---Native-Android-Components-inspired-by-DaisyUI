<#
.SYNOPSIS
    Build and install script for a B4XDaisyUIKit app project.

.DESCRIPTION
    Builds the B4A project in this folder via B4ABuilder and installs the APK
    to connected Android device(s). The project file is auto-discovered as the
    single *.b4a in the folder (folder name MUST match the .b4a file name).
    Package name is read from the built AndroidManifest.xml.

    Per project guidelines: use this script for build+install to device. Never
    invoke B4ABuilder.exe or adb directly.

.PARAMETER DeviceId
    Optional. Specifies the Android device ID to install the APK to.
    If not specified, installs to all connected devices.
#>

param(
    [string]$DeviceId
)

$ErrorActionPreference = "Continue"

$AppName = "B4XDaisyUIKit App"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  $AppName - Build & Install" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$appFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$objectsFolder = Join-Path $appFolder "Objects"
$builderPath = "C:\Program Files\Anywhere Software\B4A\B4ABuilder.exe"

# Discover the project file (single *.b4a in the folder).
$projectFile = Get-ChildItem -Path $appFolder -Filter "*.b4a" -File -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $projectFile) {
    Write-Host "ERROR: No .b4a project file found in $appFolder" -ForegroundColor Red
    exit 1
}
$appProject = $projectFile.FullName

# ADB Discovery
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
        if (Test-Path $path) { return $path }
    }
    return $null
}

$adbPath = Find-Adb
if ($null -eq $adbPath) {
    Write-Host "ERROR: adb.exe not found." -ForegroundColor Red
    exit 1
}

# Check devices
Write-Host "Checking for connected Android devices..." -ForegroundColor Gray
$devicesOutput = & $adbPath devices 2>$null
$devices = @($devicesOutput | Where-Object { $_ -match "\tdevice$" } | ForEach-Object { ($_ -split "\t")[0] })

if ($devices.Count -eq 0) {
    Write-Host "ERROR: No connected Android device found." -ForegroundColor Red
    exit 1
}

if (-not [string]::IsNullOrWhiteSpace($DeviceId)) {
    $devices = @($devices | Where-Object { $_ -eq $DeviceId })
    if ($devices.Count -eq 0) {
        Write-Host "ERROR: Specified device '$DeviceId' not found." -ForegroundColor Red
        exit 1
    }
}

Write-Host "Connected devices:" -ForegroundColor Gray
foreach ($dev in $devices) {
    Write-Host "  - $dev" -ForegroundColor Green
}

# Clean Objects folder
if (Test-Path $objectsFolder) {
    Write-Host "Cleaning Objects folder (clean project)..." -ForegroundColor Yellow
    try {
        Remove-Item $objectsFolder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Objects folder deleted" -ForegroundColor Green
    }
    catch {
        Write-Host "WARNING: could not delete Objects: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Build Project
Write-Host ""
Write-Host "Building project..." -ForegroundColor Cyan
Write-Host "Project: $appProject" -ForegroundColor Gray

if (-not (Test-Path $builderPath)) {
    Write-Host "ERROR: B4ABuilder.exe not found at $builderPath" -ForegroundColor Red
    exit 1
}

$buildOutput = & $builderPath -task=Build "-BaseFolder=$appFolder" "-Project=$appProject" 2>&1
foreach ($line in $buildOutput) {
    $lineStr = [string]$line
    if ($lineStr -match "Error|ERROR|error") {
        Write-Host "  $lineStr" -ForegroundColor Red
    }
    elseif ($lineStr -match "Completed successfully") {
        Write-Host "  $lineStr" -ForegroundColor Green
    }
    else {
        Write-Host "  $lineStr" -ForegroundColor Gray
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

$apkFile = Get-ChildItem -Path $objectsFolder -Filter "*.apk" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($null -eq $apkFile) {
    Write-Host "ERROR: APK file not found after build." -ForegroundColor Red
    exit 1
}

Write-Host "APK built: $($apkFile.FullName)" -ForegroundColor Green
Write-Host "  Size: $([math]::Round($apkFile.Length / 1MB, 2)) MB" -ForegroundColor Gray

# Extract package name and launcher activity from manifest
$manifestPath = Join-Path $objectsFolder "AndroidManifest.xml"
$packageName = "com.example.myapp"
$launcherActivity = ".main"

if (Test-Path $manifestPath) {
    $manifest = Get-Content $manifestPath -Raw
    if ($manifest -match 'package="([^"]+)"') { $packageName = $Matches[1] }
    $launcherBlock = [regex]::Match($manifest, '(?s)<activity[^>]*android:name="([^"]+)"[^>]*>.*?android.intent.category.LAUNCHER.*?</activity>')
    if ($launcherBlock.Success) { $launcherActivity = $launcherBlock.Groups[1].Value }
}

# Install & Launch
Write-Host ""
Write-Host "Installing app to device(s)..." -ForegroundColor Cyan
Write-Host "APK file: $($apkFile.FullName)" -ForegroundColor Gray
Write-Host "Target device(s): $($devices -join ', ')" -ForegroundColor Gray

foreach ($dev in $devices) {
    Write-Host "Installing to $dev..." -ForegroundColor Gray

    # Uninstall stale app
    Write-Host "  Uninstalling stale $packageName on $dev..." -ForegroundColor Gray
    $null = & $adbPath -s $dev uninstall $packageName 2>$null

    # Install APK
    $installOutput = & $adbPath -s $dev install -r $apkFile.FullName 2>&1
    $installSuccess = $false
    foreach ($outLine in $installOutput) {
        if ($outLine -match "Success") {
            $installSuccess = $true
            Write-Host "  Success: $dev" -ForegroundColor Green
        }
    }

    if (-not $installSuccess) {
        Write-Host "  Install output: $($installOutput -join ' ')" -ForegroundColor Yellow
    }

    # Refresh launcher
    try {
        $null = & $adbPath -s $dev shell am broadcast -a android.intent.action.MAIN -c android.intent.category.HOME 2>$null
    } catch {}

    # Launch app
    Write-Host "  Launching $packageName/$launcherActivity ..." -ForegroundColor Gray
    $launchOutput = & $adbPath -s $dev shell am start -n "$packageName/$launcherActivity" 2>&1
    Write-Host "  $($launchOutput -join ' ')" -ForegroundColor Gray
}

# --- Build-stage runtime gate (auto). Evidences UX-review items screenshots
# cannot prove (crash, touch-target dp, TalkBack labels, startup time, jank)
# so the post-build ux-review pass confirms instead of discovers.
# Sibling build-watch.ps1 is dropped from the bootstrap skill alongside
# install.ps1. If absent (older scaffold), skip silently.
$buildWatch = Join-Path $appFolder "build-watch.ps1"
if (Test-Path $buildWatch) {
    Write-Host ""
    Write-Host "Running build-watch.ps1 (build-stage runtime gate)..." -ForegroundColor Cyan
    $firstDev = if ($devices.Count -gt 0) { $devices[0] } else { "" }
    & $buildWatch -AppFolder $appFolder -Package $packageName -Activity $launcherActivity -DeviceId $firstDev
    if ($LASTEXITCODE -ne 0) {
        Write-Host "build-watch.ps1 reported runtime errors (see ux-review\BUILD-WATCH-*.md). Do not ship." -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "build-watch.ps1 not found in project folder; build-stage runtime gate skipped." -ForegroundColor Gray
    Write-Host "  (Drop build-watch.ps1 from the b4x-project-bootstrap skill to enable crash/touch/jank checks.)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""