# ⚡ B4XDaisyUIKit v0.93

> **The premier 100% native Android UI & Component Suite for B4A (Basic4Android), inspired by DaisyUI and Tailwind CSS design tokens.**

[![B4X Forum Thread](https://img.shields.io/badge/B4X_Forum-Thread_#171762-007ACC?style=flat&logo=android)](https://www.b4x.com/android/forum/threads/ai-skills-b4xdaisyuikit-skills-supercharge-claude-to-code-b4xdaisyuikit-instantly-beta.171762/)
[![GitHub Release](https://img.shields.io/badge/Release-v0.93-blue.svg)](https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Components](https://img.shields.io/badge/Components-104_Native_Classes-brightgreen.svg)](https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI)
[![Demo Pages](https://img.shields.io/badge/Demo_Screens-89_B4XPages-orange.svg)](https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI)

---

## 🌟 Highlights of Release v0.93

**B4XDaisyUIKit v0.93** delivers a comprehensive stability, resilience, and performance upgrade across all **104 native component classes**:

* 🛡️ **Defensive Error Handling Across All 104 Modules**: 100% structured `Try ... Catch ... End Try` error logging (`<Component>.<Sub>: ...`) eliminating silent swallows.
* 🏷️ **Strict Type-Based Hungarian Variable Standards**: All method parameters and local variables adhere to strict type prefixes (`sText`, `iLeft`, `bVisible`, `vTarget`, `lstItems`, `mapProps`), preventing compiler shadowing and name collisions.
* 👆 **Smart Gesture Routing (`DisallowParentIntercept`)**: Built-in Android view-tree climbing for touch-drag controls (`ColorWheel`, `DualRange`, `Range`, `Carousel`, `Picker`) to prevent parent `ScrollView` / `HorizontalScrollView` from stealing user drag touches.
* 📱 **Tablet & Landscape Responsive Grids**: Built-in breakpoint math ($\ge 600\text{dip}$) for dynamic single-column (phone) vs. dual-column (tablet/landscape) page layouts.
* 🎨 **30+ Pre-Configured Semantic DaisyUI Themes**: Full native token palette support (`light`, `dark`, `cupcake`, `synthwave`, `cyberpunk`, `dracula`, `luxury`, `corporate`, `emerald`, `retro`, etc.).
* 📦 **Complete Ready-to-Run Distribution**: Includes pre-compiled `B4XDaisyUIKit.b4xlib`, all companion dependencies in `Libraries/`, full demo source in `B4A/`, and `B4XDaisyUIKitDist.apk`.

---

## 📥 Getting Started & B4A Installation Guide

B4A (Basic4Android) is **100% free** and provides a rapid, high-performance native Android development environment.

### Step 1: Download & Install B4A (Free Full Version)
1. Download the B4A installer from the official website:  
   👉 **[https://www.b4x.com/b4a.html](https://www.b4x.com/b4a.html)**
2. Run the installer and install B4A to your Windows PC (default: `C:\Program Files\Anywhere Software\B4A`).

### Step 2: Install Java OpenJDK & Android SDK
1. Follow the official 2-step setup instructions on the B4X forum:  
   👉 **[B4A Installation & SDK Setup Guide](https://www.b4x.com/android/forum/threads/b4a-installation-instructions.124497/)**
2. Download and extract the ready-to-use **Java JDK + Android SDK bundle** provided on that page (recommended location: `C:\Android` or `C:\b4a\sdk`).

### Step 3: Configure Paths in the B4A IDE
1. Open the B4A IDE.
2. Navigate to **Tools $\rightarrow$ Configure Paths**.
3. Set your local paths:
   * **`javac.exe`**: `C:\Android\jdk-19\bin\javac.exe` (or your JDK `bin\javac.exe`).
   * **`android.jar`**: `C:\Android\platforms\android-34\android.jar` (or your platform `android.jar`).
   * **`Additional Libraries`**: Create a folder (e.g., `C:\b4a\AdditionalLibraries` or `C:\Android\AdditionalLibraries`) and set it here.

### Step 4: Install `B4XDaisyUIKit.b4xlib` and Dependencies
1. Open the **`Libraries/`** folder in this release.
2. Copy **`B4XDaisyUIKit.b4xlib`** along with all accompanying `.b4xlib`, `.jar`, `.xml`, and `.aar` files into your configured **`Additional Libraries`** folder.

### Step 5: (Optional) Verify ADB in System PATH
To enable one-click deployment to attached devices or emulators:
* Add `C:\Android\platform-tools` (or your SDK `platform-tools` folder) to your Windows **System Environment Variable `PATH`**.
* Open terminal and verify:
  ```powershell
  adb devices
  ```

---

## 🚀 Running the Included Demo

### Option A: Install Pre-Built Demo APK on Device / Emulator
Sideload the included `B4XDaisyUIKitDist.apk` directly via ADB:
```powershell
adb install -r B4XDaisyUIKitDist.apk
```
Or transfer `B4XDaisyUIKitDist.apk` to your Android device and tap to install.

### Option B: Open and Compile from B4A IDE
1. Open the B4A IDE.
2. Open the demo project: `B4A/B4XDaisyUIKit.b4a`.
3. Press **F5** (or click the Run button) to compile and launch the full 89-screen showcase on your connected device or emulator.

---

## 💻 Quick Code Example

Creating a modern, reactive card with an input field and action button using native B4X code:

```vb
' In B4XPage_Created(Root1 As B4XView)
Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
    
    ' 1. Initialize Root Scroll Container
    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
    
    Dim pad As Int = pageScroll.PagePadding
    Dim gap As Int = pageScroll.YGap
    Dim maxW As Int = pageScroll.UsableWidth
    Dim y As Int = pad
    
    ' 2. Section Header
    y = pageScroll.AddSectionTitle("User Feedback", y, False) + gap
    
    ' 3. DaisyUI Card Hosting an Input Form
    Dim card As B4XDaisyCard
    card.Initialize(Me, "card")
    card.Title = "Submit Survey"
    card.Border = True
    card.Shadow = "shadow-lg"
    card.AddToParent(pageScroll.Content, pad, y, maxW, 260dip)
    
    ' 4. DaisyUI Input
    Dim txtEmail As B4XDaisyInput
    txtEmail.Initialize(Me, "txtEmail")
    txtEmail.Label = "Email Address"
    txtEmail.Placeholder = "name@example.com"
    txtEmail.Required = True
    txtEmail.AddToParent(card.Body, 16dip, 40dip, maxW - 32dip, 56dip)
    
    ' 5. DaisyUI Primary Button
    Dim btnSubmit As B4XDaisyButton
    btnSubmit.Initialize(Me, "btnSubmit")
    btnSubmit.Text = "Submit Feedback"
    btnSubmit.Variant = "primary"
    btnSubmit.Rounded = "rounded-box"
    btnSubmit.AddToParent(card.Body, 16dip, 110dip, maxW - 32dip, 48dip)
    
    y = y + 260dip + gap
    pageScroll.AutoFit
End Sub

' 6. Event Handler
Private Sub btnSubmit_Click
    B4XPages.MainPage.ShowToast("Thank you for your submission!", True)
End Sub
```

---

## 📦 What's Included in this Release

| Directory / File | Description |
|---|---|
| **`Libraries/`** | Contains `B4XDaisyUIKit.b4xlib` plus all required third-party `.jar`, `.xml`, `.aar`, and `.b4xlib` dependencies ready to drop into your `Additional Libraries` folder. |
| **`B4A/`** | Complete native Basic4Android source code including all 89 `B4XPage` reference implementations, layouts, and assets. |
| **`B4XDaisyUIKitDist.apk`** | Pre-compiled native release APK for instant testing on any Android device or emulator. |
| **`CHANGELOG v0.93.md`** | Detailed list of modified modules and resource assets. |

---

## 🙏 Third-Party Credits & Acknowledgments

B4XDaisyUIKit is built on top of the vibrant B4X ecosystem. Sincere gratitude to Anywhere Software and the creators of the bundled support libraries:

* `B4XPages`, `XUI`, `XUI Views`, `BitmapCreator`, `JSON`, `Core` — *Anywhere Software*
* `xCustomListView` — *Erel*
* `Pdfium` & `android-pdf-viewer`
* `ac_leafletview` & `ac_nativedialogs`
* `ShineButton`
* `FusedLocationProvider`, `GPS`, `Geocoder`
* `OkHttpUtils2` & `jPocketBase`

---

## 💬 Community, Support & Links

* 🌐 **B4X Forum Community Thread:** [AI Skills & B4XDaisyUIKit Discussion](https://www.b4x.com/android/forum/threads/ai-skills-b4xdaisyuikit-skills-supercharge-claude-to-code-b4xdaisyuikit-instantly-beta.171762/)
* 📦 **Main GitHub Repository:** [Mashiane/Sithaso-B4XDaisy-UIKit](https://github.com/Mashiane/Sithaso-B4XDaisy-UIKit---Native-Android-Components-inspired-by-DaisyUI)
* ☁️ **Google Drive Library & APK Archive:** [Downloads & Release Backups](https://drive.google.com/drive/folders/1Ccr4SiPYugPCsN0juwwwqAZGewMW-xZj?usp=sharing)
* 🤖 **AI Skills for Claude Code & Antigravity:** [Mashiane/B4XDaisyUIKit-Skills](https://github.com/Mashiane/B4XDaisyUIKit-Skills)

---

## 📄 License

B4XDaisyUIKit is open source software licensed under the **[MIT License](https://opensource.org/licenses/MIT)**.
