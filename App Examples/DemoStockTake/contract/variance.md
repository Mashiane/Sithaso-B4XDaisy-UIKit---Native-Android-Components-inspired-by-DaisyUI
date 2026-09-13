# Screen Contract — B4XDaisyUIKit (Phase 3 Gate)

One contract per screen/page. Fill before generating code. Orchestrator blocks `generate` if this file is missing.

---

## 0. Identity
- **Screen ID:** `home | login | stock_take | variance | ...` (matches `B4XPages.AddPage` id)
- **Class Name:** `B4XPageHome` (PascalCase, one file per screen)
- **Route:** `B4XPages.ShowPage("home")` / entry screen `true|false`

## 1. User Goal (one sentence)
> e.g. "Count physical stock for a location, reconcile vs system, resolve variances."

## 2. Actions
- **Primary (1 per viewport, `primary` variant):** e.g. `Submit Count`
- **Secondary (neutral/ghost/outline):** e.g. `Save Draft`, `Scan Barcode`
- **Destructive (separated ≥16dip, `error` + SweetAlert):** e.g. `Void Stock Count`

## 3. Information Hierarchy (top → thumb zone)
1. Top context `B4XDaisyNavbar` (title, back, overflow)
2. Scroll body `B4XDaisyPageScroll` (ordered list of components)
3. Bottom thumb zone `B4XDaisyDock` / `B4XDaisyFab` (≤5 items, Hick's Law)

List body components in mount order with verified APIs:
| # | Component | Props / Variant | Demo ref |
|---|---|---|---|
| 1 | `B4XDaisyStat` | `setOrientation(horizontal)` + `StatItem(s)` | `B4XPageStat.bas` |
| 2 | `B4XDaisyInput` | `SingleLine=True, InputType=text` | `B4XPageInput.bas` |
| ... | | | |

Every entry must exist in `references/component-manifest.md`. No invented members (`RULE-ANTI-002`).

## 4. Navigation & Architecture
- **Page Architecture:** `ARCH-01 NavScrollDock | ARCH-02 Auth | ARCH-03 Dashboard | ARCH-04 Form | ARCH-05 Master-Detail | ARCH-06 Stock-Take | ARCH-07 Wizard` (`references/page-architectures.md`)
- **Inset:** `pageScroll` inset `NAVBAR_H=56dip` / `DOCK_H=64dip` vs full-screen
- **Back behavior:** `B4XPage_CloseRequest` `true|false` if unsaved changes

## 5. Density
- **Level:** `High (telemetry, YGap=8dip) | Comfortable (form, YGap=12dip) | Spacious (hero, YGap=20dip)` (`creative-director.md:36`)
- **Metrics:** `pad=pageScroll.PagePadding`, `gap=pageScroll.YGap`, `maxW=pageScroll.UsableWidth`, `y` cursor, `AutoFit` last

## 6. Required States (Pillar 3, RULE-STATE-001)
- [ ] **Loading:** `B4XDaisyLoading` or `B4XDaisyDivision.IsSkeleton=True` or `AppLoader.Show`
- [ ] **Populated:** component hierarchy above
- [ ] **Empty:** `B4XDaisyHero`/`B4XDaisyCard` + SVG + `No items found` + `Create New` CTA
- [ ] **Error:** `B4XDaisyAlert error` + `Retry` + `pageScroll.AutoFit` after Validate
- [ ] **Confirmation:** `B4XDaisySweetAlert` for destructive (`Wait For swal.ShowAsync`)

## 7. Interaction Constraints
- **Touch target:** ≥48dip per interactive view (`RULE-INTERACT-003`, verified at build by `build-watch.ps1`)
- **Nav bounds:** ≤5 dock items (`RULE-INTERACT-004`)
- **Touch conflict:** `DisallowParentIntercept` if `ColorWheel|Range|DualRange|Carousel` inside scroll (`RULE-INTERACT-002`)
- **Navbar:** `navbar.BringToFront` direct, not `getView.BringToFront` (`RULE-INTERACT-001`)

## 8. Accessibility (WCAG 2.2 AA)
- [ ] Semantic roles only (`primary` once per viewport)
- [ ] Contrast not claimed from screenshot (verified via `ux-review.md` + `build-watch` content-desc)
- [ ] All interactive views have `content-desc` or `text` (build-watch gate)

## 9. Acceptance & Release Gates
- [ ] `pre-scan.ps1` PASS (no web tech, no Flex/Grid)
- [ ] `verify-conformance.ps1` PASS (conformance + wiring + AutoFit/BringToFront)
- [ ] `./install.ps1` builds, `build-watch.ps1` — 0 Errors (crash/ClassNotFound/ResourceNotFound)
- [ ] `capture-screens.ps1` → `ux-review/screens/*.png` exists
- [ ] `ux-review.md` full pass — 0 `Severity ≥4`, `Sign-off` checked, re-ran static gate after fixes

## 10. Rule Trace (cite IDs you will honor)
- `RULE-SETUP-004, RULE-LAYOUT-001, RULE-LAYOUT-003, RULE-INTERACT-001, RULE-STATE-001, RULE-CODE-002, RULE-ANTI-002`

---
**Fill this file as `<AppFolder>/contract/<ScreenId>.md` before invoking `b4xdaisyuikit` generation. Orchestrator enforces it (`L5`).**
