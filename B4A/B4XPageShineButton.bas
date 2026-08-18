B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12,9

Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	' DaisyUI ShineButtons for Size Showcase (xs, sm, md, lg, xl)
	Private dsbXs As B4XDaisyShineButton
	Private dsbSm As B4XDaisyShineButton
	Private dsbMd As B4XDaisyShineButton
	Private dsbLg As B4XDaisyShineButton
	Private dsbXl As B4XDaisyShineButton

	' Standard Shapes
	Private dsbHeart As B4XDaisyShineButton
	Private dsbLike As B4XDaisyShineButton
	Private dsbSmile As B4XDaisyShineButton
	Private dsbStar As B4XDaisyShineButton
	Private dsbSvgCustom As B4XDaisyShineButton

	' Buttons
	Private btnToggleHeart As B4XDaisyButton
	Private btnTriggerBurst As B4XDaisyButton

	' Event log view
	Private txtLog As B4XDaisyText
	Private eventLogs As List
End Sub

Public Sub Initialize
	eventLogs.Initialize
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(248, 250, 252)

	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	BuildForm
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
End Sub

Private Sub BuildForm
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim y As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap

	' -
	' 1. Size Scale Showcase (xs, sm, md, lg, xl)
	' -
	y = pageScroll.AddSectionTitle("1. Size Scale Showcase (xs, sm, md, lg, xl)", y, False)

	Dim pnlSizes As B4XView = CreateCardPanel(padding, y, maxW, 220dip)

	' --- Row 1: xs, sm, md, lg ---
	' xs: 28dip
	dsbXs.Initialize(Me, "dsbXs")
	dsbXs.AddToParent(pnlSizes, 16dip, 26dip, 28dip, 28dip)
	dsbXs.Shape = "heart"
	dsbXs.Size = "xs"
	dsbXs.Variant = "error"
	dsbXs.AllowRandomColor = True
	dsbXs.ApplyAllProperties

	Dim lblXs As Label = CreateMiniLabel("XS (28dip)")
	pnlSizes.AddView(lblXs, 8dip, 60dip, 44dip, 20dip)

	' sm: 36dip
	dsbSm.Initialize(Me, "dsbSm")
	dsbSm.AddToParent(pnlSizes, 76dip, 20dip, 36dip, 36dip)
	dsbSm.Shape = "like"
	dsbSm.Size = "sm"
	dsbSm.Variant = "primary"
	dsbSm.AllowRandomColor = True
	dsbSm.ApplyAllProperties

	Dim lblSm As Label = CreateMiniLabel("SM (36dip)")
	pnlSizes.AddView(lblSm, 68dip, 60dip, 52dip, 20dip)

	' md: 48dip (Default)
	dsbMd.Initialize(Me, "dsbMd")
	dsbMd.AddToParent(pnlSizes, 144dip, 12dip, 48dip, 48dip)
	dsbMd.Shape = "smile"
	dsbMd.Size = "md"
	dsbMd.Variant = "warning"
	dsbMd.AllowRandomColor = True
	dsbMd.ApplyAllProperties

	Dim lblMd As Label = CreateMiniLabel("MD (48dip)")
	pnlSizes.AddView(lblMd, 138dip, 64dip, 60dip, 20dip)

	' lg: 64dip
	dsbLg.Initialize(Me, "dsbLg")
	dsbLg.AddToParent(pnlSizes, 224dip, 4dip, 64dip, 64dip)
	dsbLg.Shape = "star"
	dsbLg.Size = "lg"
	dsbLg.Variant = "success"
	dsbLg.AllowRandomColor = True
	dsbLg.ApplyAllProperties

	Dim lblLg As Label = CreateMiniLabel("LG (64dip)")
	pnlSizes.AddView(lblLg, 224dip, 72dip, 64dip, 20dip)

	' --- Row 2: xl (80dip) ---
	dsbXl.Initialize(Me, "dsbXl")
	dsbXl.AddToParent(pnlSizes, 16dip, 105dip, 80dip, 80dip)
	dsbXl.Size = "xl"
	dsbXl.SetSvgAsset("palette-solid-full.svg")
	dsbXl.Variant = "secondary"
	dsbXl.AllowRandomColor = True
	dsbXl.ApplyAllProperties

	Dim lblXl As Label = CreateMiniLabel("XL (80dip)")
	pnlSizes.AddView(lblXl, 16dip, 190dip, 80dip, 20dip)

	Dim lblXlDesc As Label = CreateCardDesc("Extra large 80dip shine button with custom SVG icon ('palette-solid-full.svg') and purple starburst animation.")
	pnlSizes.AddView(lblXlDesc, 110dip, 115dip, Max(100dip, pnlSizes.Width - 126dip), 68dip)

	y = y + 220dip + gap

	' -
	' 2. Heart Shine Button (Error / Red Burst)
	' -
	y = pageScroll.AddSectionTitle("2. Heart Shine Button (Flashing & Rainbow)", y, False)

	Dim pnlHeart As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	dsbHeart.Initialize(Me, "dsbHeart")
	dsbHeart.AddToParent(pnlHeart, 20dip, 20dip, 60dip, 60dip)
	dsbHeart.Shape = "heart"
	dsbHeart.Variant = "error"
	dsbHeart.AllowRandomColor = True
	dsbHeart.EnableFlashing = True
	dsbHeart.BigShineColor = xui.Color_RGB(251, 191, 36)
	dsbHeart.SmallShineColor = xui.Color_RGB(34, 197, 94)
	dsbHeart.ApplyAllProperties

	Dim lblDesc1 As Label = CreateCardDesc("Heart shape from File.DirAssets with flashing animations, yellow big shine, green small shine, and rainbow bursts.")
	pnlHeart.AddView(lblDesc1, 90dip, 16dip, Max(100dip, pnlHeart.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -
	' 3. Like (Thumbs Up) Shine Button (Primary / Blue)
	' -
	y = pageScroll.AddSectionTitle("3. Like (Thumbs Up) Shine Button", y, False)

	Dim pnlLike As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	dsbLike.Initialize(Me, "dsbLike")
	dsbLike.AddToParent(pnlLike, 20dip, 20dip, 60dip, 60dip)
	dsbLike.Shape = "like"
	dsbLike.Variant = "primary"
	dsbLike.AllowRandomColor = True
	dsbLike.BigShineColor = xui.Color_RGB(34, 197, 94)
	dsbLike.SmallShineColor = xui.Color_RGB(234, 179, 8)
	dsbLike.ApplyAllProperties

	Dim lblDesc2 As Label = CreateCardDesc("Thumbs up shape from File.DirAssets with blue fill color, green big shine, and yellow small shine.")
	pnlLike.AddView(lblDesc2, 90dip, 16dip, Max(100dip, pnlLike.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -
	' 4. Smile Shine Button (Warning / Yellow)
	' -
	y = pageScroll.AddSectionTitle("4. Smile Shine Button", y, False)

	Dim pnlSmile As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	dsbSmile.Initialize(Me, "dsbSmile")
	dsbSmile.AddToParent(pnlSmile, 20dip, 20dip, 60dip, 60dip)
	dsbSmile.Shape = "smile"
	dsbSmile.Variant = "warning"
	dsbSmile.AllowRandomColor = True
	dsbSmile.BigShineColor = xui.Color_RGB(239, 68, 68)
	dsbSmile.SmallShineColor = xui.Color_RGB(34, 197, 94)
	dsbSmile.ApplyAllProperties

	Dim lblDesc3 As Label = CreateCardDesc("Smile shape from File.DirAssets with yellow fill color, red big shine, and green small shine.")
	pnlSmile.AddView(lblDesc3, 90dip, 16dip, Max(100dip, pnlSmile.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -
	' 5. Star Shine Button (Success / Green)
	' -
	y = pageScroll.AddSectionTitle("5. Star Shine Button", y, False)

	Dim pnlStar As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	dsbStar.Initialize(Me, "dsbStar")
	dsbStar.AddToParent(pnlStar, 20dip, 20dip, 60dip, 60dip)
	dsbStar.Shape = "star"
	dsbStar.Variant = "success"
	dsbStar.AllowRandomColor = True
	dsbStar.EnableFlashing = True
	dsbStar.BigShineColor = xui.Color_RGB(236, 72, 153)
	dsbStar.SmallShineColor = xui.Color_RGB(239, 68, 68)
	dsbStar.ApplyAllProperties

	Dim lblDesc4 As Label = CreateCardDesc("Star shape from File.DirAssets with green fill color, magenta big shine, and red small shine.")
	pnlStar.AddView(lblDesc4, 90dip, 16dip, Max(100dip, pnlStar.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -
	' 6. Custom SVG Icon (Loaded via File.DirAssets)
	' -
	y = pageScroll.AddSectionTitle("6. Custom SVG Icon (File.DirAssets)", y, False)

	Dim pnlSvg As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	dsbSvgCustom.Initialize(Me, "dsbSvgCustom")
	dsbSvgCustom.AddToParent(pnlSvg, 20dip, 20dip, 60dip, 60dip)
	dsbSvgCustom.SetSvgAsset("palette-solid-full.svg")
	dsbSvgCustom.Variant = "secondary"
	dsbSvgCustom.AllowRandomColor = True
	dsbSvgCustom.EnableFlashing = True
	dsbSvgCustom.BigShineColor = xui.Color_RGB(236, 72, 153)
	dsbSvgCustom.SmallShineColor = xui.Color_RGB(59, 130, 246)
	dsbSvgCustom.ApplyAllProperties

	Dim lblDesc5 As Label = CreateCardDesc("Custom SVG dynamically rendered from File.DirAssets ('palette-solid-full.svg') with purple fill and multi-particle bursts.")
	pnlSvg.AddView(lblDesc5, 90dip, 16dip, Max(100dip, pnlSvg.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -
	' 7. Programmatic API Control
	' -
	y = pageScroll.AddSectionTitle("7. Programmatic API Control", y, False)

	Dim btnW As Int = (maxW - 12dip) / 2

	btnToggleHeart.Initialize(Me, "btnToggleHeart")
	btnToggleHeart.Text = "Toggle Heart"
	btnToggleHeart.Variant = "secondary"
	btnToggleHeart.Style = "solid"
	btnToggleHeart.AddToParent(pnlHost, padding, y, btnW, 44dip)

	btnTriggerBurst.Initialize(Me, "btnTriggerBurst")
	btnTriggerBurst.Text = "Trigger Shine"
	btnTriggerBurst.Variant = "primary"
	btnTriggerBurst.Style = "solid"
	btnTriggerBurst.AddToParent(pnlHost, padding + btnW + 12dip, y, btnW, 44dip)

	y = y + 44dip + gap

	' -
	' 8. Event Log
	' -
	y = pageScroll.AddSectionTitle("8. Event Log", y, False)

	Dim pnlLog As B4XView = CreateCardPanel(padding, y, maxW, 160dip)
	pnlLog.Color = xui.Color_RGB(30, 41, 59)

	Dim lblLogHeader As Label
	lblLogHeader.Initialize("")
	lblLogHeader.Text = "Recent Interaction Events"
	lblLogHeader.TextColor = xui.Color_RGB(148, 163, 184)
	lblLogHeader.TextSize = 13
	pnlLog.AddView(lblLogHeader, 12dip, 8dip, maxW - 24dip, 20dip)

	txtLog.Initialize(Me, "txtLog")
	txtLog.Text = "Tap any shine button to test interactions..."
	txtLog.TextColor = xui.Color_White
	txtLog.TextSize = 11
	txtLog.AddToParent(pnlLog, 12dip, 30dip, maxW - 24dip, 120dip)

	y = y + 160dip + 32dip

	pageScroll.AutoFit
End Sub

Private Sub CreateCardPanel(Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_White
	b.SetLayoutAnimated(0, Left, Top, Width, Height)
	b.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 16dip)
	pnlHost.AddView(b, Left, Top, Width, Height)
	Return b
End Sub

Private Sub CreateCardDesc(Text As String) As Label
	Dim lbl As Label
	lbl.Initialize("")
	lbl.Text = Text
	lbl.TextColor = xui.Color_RGB(71, 85, 105)
	lbl.TextSize = 13
	Return lbl
End Sub

Private Sub CreateMiniLabel(Text As String) As Label
	Dim lbl As Label
	lbl.Initialize("")
	lbl.Text = Text
	lbl.TextColor = xui.Color_RGB(100, 116, 139)
	lbl.TextSize = 9
	lbl.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL, Gravity.TOP)
	Return lbl
End Sub

Private Sub btnToggleHeart_Click(Tag As Object)
	dsbHeart.Checked = Not(dsbHeart.Checked)
	LogEvent("Programmatic toggle: Heart.Checked = " & dsbHeart.Checked)
End Sub

Private Sub btnTriggerBurst_Click(Tag As Object)
	dsbHeart.TriggerShine
	dsbSvgCustom.TriggerShine
	LogEvent("Programmatic burst: Heart & SVG shine triggered")
End Sub

' Event Callbacks

Private Sub dsbXs_CheckChanged (Checked As Boolean)
	LogEvent("dsbXs (XS Heart) CheckChanged = " & Checked)
End Sub

Private Sub dsbSm_CheckChanged (Checked As Boolean)
	LogEvent("dsbSm (SM Like) CheckChanged = " & Checked)
End Sub

Private Sub dsbMd_CheckChanged (Checked As Boolean)
	LogEvent("dsbMd (MD Smile) CheckChanged = " & Checked)
End Sub

Private Sub dsbLg_CheckChanged (Checked As Boolean)
	LogEvent("dsbLg (LG Star) CheckChanged = " & Checked)
End Sub

Private Sub dsbXl_CheckChanged (Checked As Boolean)
	LogEvent("dsbXl (XL SVG) CheckChanged = " & Checked)
End Sub

Private Sub dsbHeart_CheckChanged (Checked As Boolean)
	LogEvent("dsbHeart CheckChanged = " & Checked)
End Sub

Private Sub dsbLike_CheckChanged (Checked As Boolean)
	LogEvent("dsbLike CheckChanged = " & Checked)
End Sub

Private Sub dsbSmile_CheckChanged (Checked As Boolean)
	LogEvent("dsbSmile CheckChanged = " & Checked)
End Sub

Private Sub dsbStar_CheckChanged (Checked As Boolean)
	LogEvent("dsbStar CheckChanged = " & Checked)
End Sub

Private Sub dsbSvgCustom_CheckChanged (Checked As Boolean)
	LogEvent("dsbSvgCustom (SVG Palette) CheckChanged = " & Checked)
End Sub

Private Sub LogEvent(Msg As String)
	Dim timestamp As String = DateTime.Time(DateTime.Now)
	Dim line As String = "[" & timestamp & "] " & Msg
	eventLogs.InsertAt(0, line)
	If eventLogs.Size > 12 Then
		eventLogs.RemoveAt(eventLogs.Size - 1)
	End If

	Dim sb As StringBuilder
	sb.Initialize
	For Each item As String In eventLogs
		If sb.Length > 0 Then sb.Append(CRLF)
		sb.Append(item)
	Next

	If txtLog.IsInitialized Then
		txtLog.Text = sb.ToString
	End If
End Sub
