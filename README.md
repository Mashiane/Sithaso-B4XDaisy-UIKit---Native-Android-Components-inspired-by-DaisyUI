# âš¡ B4XDaisyUIKit

> **Native Android UI components for B4A (Basic4Android) â€” inspired by DaisyUI & Tailwind CSS semantics. 104 native classes, zero WebView, pure B4A.**

[![B4A](https://img.shields.io/badge/B4A-13.70%2B-blue.svg)](https://www.b4x.com/b4a.html)
[![Library](https://img.shields.io/badge/Library-v0.94-brightgreen.svg)](https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI/releases)
[![Components](https://img.shields.io/badge/Components-104_Classes-success.svg)](#-component-catalog)
[![Skills](https://img.shields.io/badge/Skills-v1.2.3-purple.svg)](https://github.com/Mashiane/B4XDaisyUIKit-Skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![B4X Forum](https://img.shields.io/badge/B4X_Forum-Thread_171762-007ACC.svg)](https://www.b4x.com/android/forum/threads/ai-skills-b4xdaisyuikit-skills-supercharge-claude-to-code-b4xdaisyuikit-instantly-beta.171762/)

---

## ðŸ“– Overview

**B4XDaisyUIKit** is a production-grade B4A library that brings **DaisyUI/Tailwind design semantics** to fully native Android views. Every component is a real `B4XView` â€” no HTML, no CSS, no WebView â€” with Tailwind tokens (rounded-box, primary/error/warning, shadow) mapped to native properties.

| | |
|---|---|
| **Target** | B4A Android only |
| **Artifact** | `B4XDaisyUIKit.b4xlib` â†’ drop in `Additional Libraries` |
| **Components** | 104 native `B4XDaisy*` classes |
| **Demos** | 89 live `B4XPage*.bas` reference pages (B4A) |
| **Themes** | 30+ DaisyUI themes + light/dark at runtime |
| **AI Skills** | [`B4XDaisyUIKit-Skills v1.2.3`](https://github.com/Mashiane/B4XDaisyUIKit-Skills) â€” Claude/Codex orchestration |

---

## ðŸš€ Quick Start

### 1. Get B4A (Free)

Download B4A + JDK/SDK bundle: **https://www.b4x.com/b4a.html** â†’ follow [installation guide](https://www.b4x.com/android/forum/threads/b4a-installation-instructions.124497/)

### 2. Install the Library

Download the latest `B4XDaisyUIKit.b4xlib` from:

- **GitHub Releases** â†’ [Sithaso-B4XDaisy-UIKit Releases](https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI/releases)
- **Google Drive Archive** â†’ [B4XDaisyUIKit Downloads](https://drive.google.com/drive/folders/1Ccr4SiPYugPCsN0juwwwqAZGewMW-xZj?usp=sharing)

Copy `B4XDaisyUIKit.b4xlib` into your **Additional Libraries** folder (Tools â†’ Configure Paths).

### 3. Use a Component

```vb
' In B4XPage_Created
Dim card As B4XDaisyCard
card.Initialize(Me, "card")
card.AddToParent(Root, 16dip, 16dip, Root.Width - 32dip, 180dip)
card.Title = "Stock Count"
card.Variant = "neutral"
```

Browse verified recipes: `B4A/B4XPage*.bas` (89 pages, B4A) + `b4xdaisyuikit-skills/components/<name>.md`

---

## ðŸ§© Component Catalog

104 classes â€” full list in [`b4xdaisyuikit-skills/skills/b4xdaisyuikit/references/component-manifest.md`](b4xdaisyuikit-skills/skills/b4xdaisyuikit/references/component-manifest.md).

**Core UI:** Avatar Â· Badge Â· Button Â· Card Â· Checkbox Â· Radio Â· Toggle Â· Input Â· Select Â· Textarea Â· Range Â· RadialProgress Â· Progress Â· Loading Â· Alert Â· Hero Â· Stat Â· Timeline Â· Steps Â· Divider Â· List Â· Pagination Â· Drawer Â· Dock Â· Navbar Â· FAB Â· Carousel Â· Collapse Â· Tabs Â· Table Â· Calendar Â· ChatBubble Â· ThemeController Â· Countdown Â· ColorWheel Â· Signature Â· PdfView Â· CodeBlock Â· FileInput Â· OTP Â· Rating Â· Skeleton Â· and 60+ more.

> Includes 4 **banned** layout primitives (FlexItem/FlexLayout/FlexPanel/Grid) â€” blocked by `b4x-verify` negative guardrails; use `B4XDaisyPageScroll` + `y` cursor instead.

---

## ðŸ¤– AI Skills â€” Build via Prompts

Pair with **[B4XDaisyUIKit-Skills](https://github.com/Mashiane/B4XDaisyUIKit-Skills)** to let Claude Code / Codex / Cursor generate native B4A apps:

```bash
/plugin marketplace add Mashiane/B4XDaisyUIKit-Skills
/plugin install b4xdaisyuikit-skills@b4xdaisyuikit-skills
```

Orchestrated loop: `bootstrap â†’ b4xdaisyuikit â†’ b4x-verify (pre-scan â†’ verify-conformance) â†’ install.ps1 â†’ build-watch â†’ capture â†’ ux-review`

---

## ðŸ“¦ Releases

| Version | Date | Highlights | Download |
|---------|------|------------|----------|
| **v0.94** | 2026-08-29 | `B4XDaisyVariants.bas` update Â· Skills `v1.2.3` sync | [b4xlib](Releases/v0.94/Libraries/B4XDaisyUIKit.b4xlib) Â· [APK](Releases/v0.94/B4XDaisyUIKitDist.apk) Â· [Changelog](Releases/v0.94/CHANGELOG%20v0.94.md) |
| v0.93 | 2026-08-22 | Full corpus rebuild | [Changelog](Releases/v0.93/CHANGELOG%20v0.93.md) |
| v0.92â€“v0.1 | â€” | See `Releases/v0.xx/` folders | `Releases/` |

Full changelogs: [`Releases/v0.94/CHANGELOG v0.94.md`](Releases/v0.94/CHANGELOG%20v0.94.md) Â· [`Releases/v0.93/CHANGELOG v0.93.md`](Releases/v0.93/CHANGELOG%20v0.93.md)

> ðŸ“¦ Mirrors: [Google Drive Archive](https://drive.google.com/drive/folders/1Ccr4SiPYugPCsN0juwwwqAZGewMW-xZj?usp=sharing) Â· ðŸ¤– Skills: [B4XDaisyUIKit-Skills](https://github.com/Mashiane/B4XDaisyUIKit-Skills)

---

## ðŸ“š Links

- ðŸ’¬ **B4X Forum Thread:** [AI Skills â€” Supercharge Claude to Code B4XDaisyUIKit](https://www.b4x.com/android/forum/threads/ai-skills-b4xdaisyuikit-skills-supercharge-claude-to-code-b4xdaisyuikit-instantly-beta.171762/)
- ðŸ§  **Skills Repo:** https://github.com/Mashiane/B4XDaisyUIKit-Skills
- ðŸ“¦ **Library Repo (this repo):** https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI
- â˜ï¸ **Downloads:** https://drive.google.com/drive/folders/1Ccr4SiPYugPCsN0juwwwqAZGewMW-xZj?usp=sharing

---

## ðŸ“„ License

MIT â€” see [LICENSE](LICENSE).
