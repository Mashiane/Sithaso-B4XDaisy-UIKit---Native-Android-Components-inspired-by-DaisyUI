B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12,9
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private pageScroll As B4XDaisyPageScroll
    Private pnlHost As B4XView

    ' Spinners
    Private spinnerXS As B4XDaisyCanvasSpinner
    Private spinnerSM As B4XDaisyCanvasSpinner
    Private spinnerMD As B4XDaisyCanvasSpinner
    Private spinnerLG As B4XDaisyCanvasSpinner
    Private customizerSpinner As B4XDaisyCanvasSpinner
    Private overlaySpinner As B4XDaisyCanvasSpinner
    Private cardSpinner As B4XDaisyCanvasSpinner

    ' Customizer controls
    Private sliderSize As B4XDaisyRange
    Private sliderStroke As B4XDaisyRange
    Private lblSizeVal As B4XView
    Private lblStrokeVal As B4XView
    Private btnPrimaryPreset As B4XDaisyButton
    Private btnWarmPreset As B4XDaisyButton
    Private btnCoolPreset As B4XDaisyButton

    ' Overlay trigger
    Private btnTriggerOverlay As B4XDaisyButton

    ' Local card trigger
    Private pnlCard As B4XView
    Private lblCardDesc As B4XView
    Private btnTriggerCard As B4XDaisyButton
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

    ' Initialize PageScroll Host
    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
    pnlHost = pageScroll.Panel

    ' Pre-initialize the overlay loader
    overlaySpinner.Initialize(Me, "overlaySpinner")
    overlaySpinner.setOverlayColor(xui.Color_Black)
    overlaySpinner.setOverlayOpacity(0.5)
    overlaySpinner.setColor1(xui.Color_Yellow)
    overlaySpinner.setColor2(xui.Color_Red)
    overlaySpinner.setColor3(xui.Color_Cyan)

    RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
    If overlaySpinner.IsInitialized And overlaySpinner.View.IsInitialized Then
        overlaySpinner.Resize(Width, Height)
    End If
    RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    ' Restart spinner animations when page appears
    If spinnerXS.IsInitialized Then spinnerXS.Show(Null)
    If spinnerSM.IsInitialized Then spinnerSM.Show(Null)
    If spinnerMD.IsInitialized Then spinnerMD.Show(Null)
    If spinnerLG.IsInitialized Then spinnerLG.Show(Null)
    If customizerSpinner.IsInitialized Then customizerSpinner.Show(Null)
End Sub

Private Sub B4XPage_Disappear
    ' Stop timers/animations to release resources when page is inactive
    If spinnerXS.IsInitialized And spinnerXS.Visible Then spinnerXS.Hide
    If spinnerSM.IsInitialized And spinnerSM.Visible Then spinnerSM.Hide
    If spinnerMD.IsInitialized And spinnerMD.Visible Then spinnerMD.Hide
    If spinnerLG.IsInitialized And spinnerLG.Visible Then spinnerLG.Hide
    If customizerSpinner.IsInitialized And customizerSpinner.Visible Then customizerSpinner.Hide
    If overlaySpinner.IsInitialized And overlaySpinner.Visible Then overlaySpinner.Hide
    If cardSpinner.IsInitialized And cardSpinner.Visible Then cardSpinner.Hide
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pageScroll.Clear

    Dim maxW As Int = pageScroll.UsableWidth
    Dim padding As Int = pageScroll.PagePadding
    Dim gap As Int = pageScroll.YGap
    Dim y As Int = padding

    ' -
    ' Section 1: Sizes & Colors Gallery
    ' -
    y = pageScroll.AddSectionTitle("1. Spinner Sizes & Themes", y, False)

    Dim rowH As Int = 100dip
    Dim spinnerSpacing As Int = 15dip

    ' Spinner XS: 24dip
    spinnerXS.Initialize(Me, "spinnerXS")
    spinnerXS.AddToParent(pnlHost, padding, y + (rowH - 24dip)/2, 24dip, 24dip)
    spinnerXS.setColor1(B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3FC3EE))
    spinnerXS.setColor2(B4XDaisyVariants.GetTokenColor("--color-secondary", 0xFFF27474))
    spinnerXS.setColor3(B4XDaisyVariants.GetTokenColor("--color-accent", 0xFFF8BB86))
    spinnerXS.setStrokeWidth(2dip)
    spinnerXS.Show(Null)

    ' Spinner SM: 40dip
    Dim x2 As Int = padding + 24dip + spinnerSpacing
    spinnerSM.Initialize(Me, "spinnerSM")
    spinnerSM.AddToParent(pnlHost, x2, y + (rowH - 40dip)/2, 40dip, 40dip)
    spinnerSM.setColor1(B4XDaisyVariants.GetTokenColor("--color-success", 0xFF22C55E))
    spinnerSM.setColor2(B4XDaisyVariants.GetTokenColor("--color-warning", 0xFFEAB308))
    spinnerSM.setColor3(B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444))
    spinnerSM.setStrokeWidth(3dip)
    spinnerSM.Show(Null)

    ' Spinner MD: 64dip
    Dim x3 As Int = x2 + 40dip + spinnerSpacing
    spinnerMD.Initialize(Me, "spinnerMD")
    spinnerMD.AddToParent(pnlHost, x3, y + (rowH - 64dip)/2, 64dip, 64dip)
    spinnerMD.setColor1(B4XDaisyVariants.GetTokenColor("--color-info", 0xFF3B82F6))
    spinnerMD.setColor2(B4XDaisyVariants.GetTokenColor("--color-secondary", 0xFFD946EF))
    spinnerMD.setColor3(B4XDaisyVariants.GetTokenColor("--color-neutral", 0xFF1F2937))
    spinnerMD.setStrokeWidth(4dip)
    spinnerMD.Show(Null)

    ' Spinner LG: 96dip
    Dim x4 As Int = x3 + 64dip + spinnerSpacing
    spinnerLG.Initialize(Me, "spinnerLG")
    spinnerLG.AddToParent(pnlHost, x4, y + (rowH - 96dip)/2, 96dip, 96dip)
    spinnerLG.setColor1(0xFF39FF14) ' Neon Green
    spinnerLG.setColor2(0xFFFF007F) ' Neon Pink
    spinnerLG.setColor3(0xFF00FFFF) ' Cyan
    spinnerLG.setStrokeWidth(6dip)
    spinnerLG.Show(Null)

    y = y + rowH + gap

    ' -
    ' Section 2: Live Property Customizer
    ' -
    y = pageScroll.AddSectionTitle("2. Live Customizer", y, False)

    Dim previewSize As Int = 80dip
    Dim previewX As Int = padding + (maxW - previewSize) / 2
    customizerSpinner.Initialize(Me, "customizerSpinner")
    customizerSpinner.AddToParent(pnlHost, previewX, y, previewSize, previewSize)
    customizerSpinner.setStrokeWidth(4dip)
    customizerSpinner.Show(Null)

    y = y + previewSize + 16dip

    ' Size Slider Label
    Dim lblSize As B4XDaisyText
    lblSize.Initialize(Me, "")
    lblSize.AddToParent(pnlHost, padding, y, 100dip, 20dip)
    lblSize.Text = "Spinner Size:"
    lblSize.TextSize = 14
    lblSize.TextColor = xui.Color_DarkGray

    Dim lSizeVal As Label
    lSizeVal.Initialize("")
    lblSizeVal = lSizeVal
    lblSizeVal.Text = "80 px"
    lblSizeVal.TextColor = xui.Color_Black
    lblSizeVal.TextSize = 14
    pnlHost.AddView(lblSizeVal, padding + 110dip, y, 60dip, 20dip)

    y = y + 24dip

    ' Size Slider
    sliderSize.Initialize(Me, "sliderSize")
    sliderSize.AddToParent(pnlHost, padding, y, maxW, 24dip)
    sliderSize.MinValue = 40
    sliderSize.MaxValue = 150
    sliderSize.Value = 80

    y = y + 32dip

    ' Stroke Width Slider Label
    Dim lblStroke As B4XDaisyText
    lblStroke.Initialize(Me, "")
    lblStroke.AddToParent(pnlHost, padding, y, 110dip, 20dip)
    lblStroke.Text = "Stroke Width:"
    lblStroke.TextSize = 14
    lblStroke.TextColor = xui.Color_DarkGray

    Dim lStrokeVal As Label
    lStrokeVal.Initialize("")
    lblStrokeVal = lStrokeVal
    lblStrokeVal.Text = "4 px"
    lblStrokeVal.TextColor = xui.Color_Black
    lblStrokeVal.TextSize = 14
    pnlHost.AddView(lblStrokeVal, padding + 120dip, y, 60dip, 20dip)

    y = y + 24dip

    ' Stroke Width Slider
    sliderStroke.Initialize(Me, "sliderStroke")
    sliderStroke.AddToParent(pnlHost, padding, y, maxW, 24dip)
    sliderStroke.MinValue = 2
    sliderStroke.MaxValue = 15
    sliderStroke.Value = 4

    y = y + 32dip

    ' Color Presets Label
    Dim lblPresets As B4XDaisyText
    lblPresets.Initialize(Me, "")
    lblPresets.AddToParent(pnlHost, padding, y, maxW, 20dip)
    lblPresets.Text = "Color Schemes:"
    lblPresets.TextSize = 14
    lblPresets.TextColor = xui.Color_DarkGray

    y = y + 24dip

    ' Preset Buttons side-by-side
    Dim btnW As Int = (maxW - 16dip) / 3

    btnPrimaryPreset.Initialize(Me, "btnPrimaryPreset")
    btnPrimaryPreset.AddToParent(pnlHost, padding, y, btnW, 36dip)
    btnPrimaryPreset.Text = "DaisyUI"
    btnPrimaryPreset.Variant = "primary"
    btnPrimaryPreset.Size = "sm"

    btnWarmPreset.Initialize(Me, "btnWarmPreset")
    btnWarmPreset.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
    btnWarmPreset.Text = "Sunset"
    btnWarmPreset.Variant = "warning"
    btnWarmPreset.Size = "sm"

    btnCoolPreset.Initialize(Me, "btnCoolPreset")
    btnCoolPreset.AddToParent(pnlHost, padding + (btnW + 8dip) * 2, y, btnW, 36dip)
    btnCoolPreset.Text = "Cool Mint"
    btnCoolPreset.Variant = "info"
    btnCoolPreset.Size = "sm"

    y = y + 44dip + gap

    ' -
    ' Section 3: Full-Screen Loading Overlay
    ' -
    y = pageScroll.AddSectionTitle("3. Full-Screen Loading Overlay", y, False)

    Dim descOverlay As B4XDaisyText
    descOverlay.Initialize(Me, "")
    descOverlay.AddToParent(pnlHost, padding, y, maxW, 40dip)
    descOverlay.Text = "Show a full-screen semi-transparent backdrop loader that blocks all user touches for 3 seconds."
    descOverlay.TextColor = xui.Color_DarkGray
    descOverlay.TextSize = 13

    y = y + 44dip

    btnTriggerOverlay.Initialize(Me, "btnTriggerOverlay")
    btnTriggerOverlay.AddToParent(pnlHost, padding, y, maxW, 40dip)
    btnTriggerOverlay.Text = "Activate Overlay Loader"
    btnTriggerOverlay.Variant = "secondary"

    y = y + 48dip + gap

    ' -
    ' Section 4: Local Container Card Loading
    ' -
    y = pageScroll.AddSectionTitle("4. Local Container Card Loading", y, False)

    ' Create a container card panel
    Dim pCard As Panel
    pCard.Initialize("")
    pnlCard = pCard
    pnlCard.SetColorAndBorder(B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White), 1dip, B4XDaisyVariants.GetTokenColor("--color-base-300", 0xFFE2E8F0), 12dip)
    pnlHost.AddView(pnlCard, padding, y, maxW, 160dip)

    ' Card Content: Title
    Dim lblCardTitle As Label
    lblCardTitle.Initialize("")
    Dim xCardTitle As B4XView = lblCardTitle
    xCardTitle.Text = "Monthly Sales Summary"
    xCardTitle.TextColor = xui.Color_RGB(30, 41, 59)
    xCardTitle.TextSize = 16
    #If B4A
    Dim jo As JavaObject = xCardTitle
    jo.RunMethod("setTypeface", Array(Typeface.DEFAULT_BOLD))
    #End If
    pnlCard.AddView(xCardTitle, 16dip, 16dip, maxW - 32dip, 24dip)

    ' Card Content: Description / Data
    Dim lCardDesc As Label
    lCardDesc.Initialize("")
    lblCardDesc = lCardDesc
    lblCardDesc.Text = "Total Revenue: $24,850.00 (+12% vs last month)" & CRLF & "Total Sales: 382 items"
    lblCardDesc.TextColor = xui.Color_DarkGray
    lblCardDesc.TextSize = 14
    pnlCard.AddView(lblCardDesc, 16dip, 48dip, maxW - 32dip, 48dip)

    ' Refresh button
    btnTriggerCard.Initialize(Me, "btnTriggerCard")
    btnTriggerCard.AddToParent(pnlCard, 16dip, 108dip, 120dip, 36dip)
    btnTriggerCard.Text = "Reload Data"
    btnTriggerCard.Variant = "neutral"
    btnTriggerCard.Size = "sm"

    ' Setup spinner inside card but set it invisible initially
    cardSpinner.Initialize(Me, "cardSpinner")
    cardSpinner.AddToParent(pnlCard, 0, 0, maxW, 160dip)
    cardSpinner.setOverlayColor(xui.Color_White)
    cardSpinner.setOverlayOpacity(0.7)
    cardSpinner.setColor1(B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3FC3EE))
    cardSpinner.setColor2(B4XDaisyVariants.GetTokenColor("--color-secondary", 0xFFF27474))
    cardSpinner.setColor3(B4XDaisyVariants.GetTokenColor("--color-accent", 0xFFF8BB86))
    cardSpinner.Hide

    y = y + 160dip + gap

    ' AutoFit scroll
    pageScroll.AutoFit
End Sub

' -
' Event Handlers
' -

' Customizer Size Slider changed
Private Sub sliderSize_Changed(Value As Int)
    If lblSizeVal.IsInitialized Then lblSizeVal.Text = Value & " px"
    If customizerSpinner.IsInitialized Then customizerSpinner.setSize(Value & "dip")
End Sub

' Customizer Stroke Slider changed
Private Sub sliderStroke_Changed(Value As Int)
    If lblStrokeVal.IsInitialized Then lblStrokeVal.Text = Value & " px"
    If customizerSpinner.IsInitialized Then customizerSpinner.setStrokeWidth(Value * 1dip)
End Sub

' Customizer Color Schemes
Private Sub btnPrimaryPreset_Click(Tag As Object)
    If customizerSpinner.IsInitialized Then
        customizerSpinner.setColor1(B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3FC3EE))
        customizerSpinner.setColor2(B4XDaisyVariants.GetTokenColor("--color-secondary", 0xFFF27474))
        customizerSpinner.setColor3(B4XDaisyVariants.GetTokenColor("--color-accent", 0xFFF8BB86))
    End If
End Sub

Private Sub btnWarmPreset_Click(Tag As Object)
    If customizerSpinner.IsInitialized Then
        customizerSpinner.setColor1(0xFFEA580C) ' Orange
        customizerSpinner.setColor2(0xFFF43F5E) ' Rose
        customizerSpinner.setColor3(0xFFEAB308) ' Yellow
    End If
End Sub

Private Sub btnCoolPreset_Click(Tag As Object)
    If customizerSpinner.IsInitialized Then
        customizerSpinner.setColor1(0xFF0D9488) ' Teal
        customizerSpinner.setColor2(0xFF10B981) ' Emerald
        customizerSpinner.setColor3(0xFF06B6D4) ' Cyan
    End If
End Sub

' Full-screen Loader Trigger
Private Sub btnTriggerOverlay_Click(Tag As Object)
    If overlaySpinner.IsInitialized Then
        overlaySpinner.Show(Root)
        B4XPages.MainPage.ShowToastSuccess("Loading overlay active for 3 seconds", False)
        Sleep(3000)
        overlaySpinner.Hide
    End If
End Sub

' Card Refresh Trigger
Private Sub btnTriggerCard_Click(Tag As Object)
    If cardSpinner.IsInitialized Then
        cardSpinner.Show(pnlCard)
        Sleep(2000)
        cardSpinner.Hide
        ' Simulate random data reload
        Dim sales As Int = Rnd(20000, 35000)
        Dim growth As Int = Rnd(5, 25)
        Dim items As Int = Rnd(350, 600)
        If lblCardDesc.IsInitialized Then
            lblCardDesc.Text = "Total Revenue: $" & NumberFormat(sales, 1, 0) & ".00 (+" & growth & "% vs last month)" & CRLF & "Total Sales: " & items & " items"
        End If
    End If
End Sub

