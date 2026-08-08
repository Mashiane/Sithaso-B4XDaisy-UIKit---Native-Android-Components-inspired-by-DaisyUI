B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	Private sb1 As ShineButton
	Private sb2 As ShineButton
	Private sb3 As ShineButton
	Private sb4 As ShineButton
	Private mbHeartChecked As Boolean = False
	Private mbRendered As Boolean = False

	Private btnToggleHeart As B4XDaisyButton
	Private btnAnimHeart As B4XDaisyButton

	Private lblStatus As Label
	Private pnlEvents As B4XView
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	If Width <= 0 Then Width = Root.Width
	If Height <= 0 Then Height = Root.Height
	If Width <= 0 Then Return

	pnlHost.RemoveAllViews

	Dim maxW As Int = pageScroll.UsableWidth
	If maxW <= 0 Then maxW = Width - 24dip
	Dim padding As Int = pageScroll.PagePadding
	If padding <= 0 Then padding = 12dip
	Dim gap As Int = pageScroll.YGap
	If gap <= 0 Then gap = 12dip
	Dim y As Int = padding

	' -------------------------------------------------------------
	' 1. Heart Shine Button
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("1. Heart Shine Button (Flashing & Random Colors)", y, False)

	Dim pnlCard1 As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	sb1.Initialize("sb1")
	pnlCard1.AddView(sb1, 20dip, 20dip, 60dip, 60dip)
	sb1.ShapeResource = "heart"
	sb1.BtnColor = xui.Color_Gray
	sb1.BtnFillColor = xui.Color_Red
	sb1.AllowRandomColor = True
	sb1.EnableFlashing = True
	sb1.BigShineColor = xui.Color_Yellow
	sb1.ClickAnimDuration = 200
	sb1.AnimDuration = 1000
	sb1.ShineTurnAngle = 180
	sb1.SmallShineColor = xui.Color_Green

	Dim lblDesc1 As Label
	lblDesc1.Initialize("")
	lblDesc1.Text = "Heart shape with flashing animations, yellow big shine, green small shine, and random color bursts."
	lblDesc1.TextColor = xui.Color_RGB(71, 85, 105)
	lblDesc1.TextSize = 13
	pnlCard1.AddView(lblDesc1, 90dip, 16dip, Max(100dip, pnlCard1.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -------------------------------------------------------------
	' 2. Like (Thumbs Up) Shine Button
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("2. Like (Thumbs Up) Shine Button", y, False)

	Dim pnlCard2 As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	sb2.Initialize("sb2")
	pnlCard2.AddView(sb2, 20dip, 20dip, 60dip, 60dip)
	sb2.ShapeResource = "like"
	sb2.BtnColor = xui.Color_Gray
	sb2.BtnFillColor = xui.Color_Blue
	sb2.AllowRandomColor = True
	sb2.EnableFlashing = True
	sb2.BigShineColor = xui.Color_Green
	sb2.ClickAnimDuration = 200
	sb2.AnimDuration = 1000
	sb2.ShineTurnAngle = 180
	sb2.SmallShineColor = xui.Color_Yellow

	Dim lblDesc2 As Label
	lblDesc2.Initialize("")
	lblDesc2.Text = "Thumbs up shape with blue fill color, green big shine, and yellow small shine."
	lblDesc2.TextColor = xui.Color_RGB(71, 85, 105)
	lblDesc2.TextSize = 13
	pnlCard2.AddView(lblDesc2, 90dip, 16dip, Max(100dip, pnlCard2.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -------------------------------------------------------------
	' 3. Smile Shine Button
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("3. Smile Shine Button", y, False)

	Dim pnlCard3 As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	sb3.Initialize("sb3")
	pnlCard3.AddView(sb3, 20dip, 20dip, 60dip, 60dip)
	sb3.ShapeResource = "smile"
	sb3.BtnColor = xui.Color_Gray
	sb3.BtnFillColor = xui.Color_Yellow
	sb3.AllowRandomColor = True
	sb3.EnableFlashing = True
	sb3.BigShineColor = xui.Color_Red
	sb3.ClickAnimDuration = 200
	sb3.AnimDuration = 1000
	sb3.ShineTurnAngle = 180
	sb3.SmallShineColor = xui.Color_Green

	Dim lblDesc3 As Label
	lblDesc3.Initialize("")
	lblDesc3.Text = "Smile shape with yellow fill color, red big shine, and green small shine."
	lblDesc3.TextColor = xui.Color_RGB(71, 85, 105)
	lblDesc3.TextSize = 13
	pnlCard3.AddView(lblDesc3, 90dip, 16dip, Max(100dip, pnlCard3.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -------------------------------------------------------------
	' 4. Star Shine Button
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("4. Star Shine Button", y, False)

	Dim pnlCard4 As B4XView = CreateCardPanel(padding, y, maxW, 100dip)
	sb4.Initialize("sb4")
	pnlCard4.AddView(sb4, 20dip, 20dip, 60dip, 60dip)
	sb4.ShapeResource = "star"
	sb4.BtnColor = xui.Color_Gray
	sb4.BtnFillColor = xui.Color_Green
	sb4.AllowRandomColor = True
	sb4.EnableFlashing = True
	sb4.BigShineColor = xui.Color_Magenta
	sb4.ClickAnimDuration = 200
	sb4.AnimDuration = 1000
	sb4.ShineTurnAngle = 180
	sb4.SmallShineColor = xui.Color_Red

	Dim lblDesc4 As Label
	lblDesc4.Initialize("")
	lblDesc4.Text = "Star shape with green fill color, magenta big shine, and red small shine."
	lblDesc4.TextColor = xui.Color_RGB(71, 85, 105)
	lblDesc4.TextSize = 13
	pnlCard4.AddView(lblDesc4, 90dip, 16dip, Max(100dip, pnlCard4.Width - 106dip), 68dip)

	y = y + 100dip + gap

	' -------------------------------------------------------------
	' 5. Programmatic API Control
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("5. Programmatic API Control", y, False)

	btnToggleHeart.Initialize(Me, "btnToggleHeart")
	btnToggleHeart.AddToParent(pnlHost, padding, y, 140dip, 40dip)
	btnToggleHeart.Text = "Toggle Heart"
	btnToggleHeart.Variant = "primary"

	btnAnimHeart.Initialize(Me, "btnAnimHeart")
	btnAnimHeart.AddToParent(pnlHost, padding + 150dip, y, 140dip, 40dip)
	btnAnimHeart.Text = "Trigger Shine"
	btnAnimHeart.Variant = "accent"

	y = y + 50dip + gap

	' -------------------------------------------------------------
	' 6. Event Log Panel
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("6. Event Log", y, False)

	pnlEvents = xui.CreatePanel("")
	pnlEvents.SetColorAndBorder(xui.Color_RGB(30, 41, 59), 1dip, xui.Color_RGB(51, 65, 85), 16dip)
	pnlHost.AddView(pnlEvents, padding, y, maxW, 160dip)

	Dim lblEventsTitle As Label
	lblEventsTitle.Initialize("")
	lblEventsTitle.Text = "Recent Interaction Events"
	lblEventsTitle.TextColor = xui.Color_RGB(148, 163, 184)
	lblEventsTitle.TextSize = 14
	lblEventsTitle.Typeface = Typeface.DEFAULT_BOLD
	pnlEvents.AddView(lblEventsTitle, 16dip, 12dip, pnlEvents.Width - 32dip, 20dip)

	lblStatus.Initialize("")
	lblStatus.Text = "Tap any shine button above to trigger events..."
	lblStatus.TextColor = xui.Color_RGB(226, 232, 240)
	lblStatus.TextSize = 12
	pnlEvents.AddView(lblStatus, 16dip, 38dip, pnlEvents.Width - 32dip, pnlEvents.Height - 50dip)

	y = y + 160dip + gap

	pageScroll.AutoFit
	mbRendered = True
End Sub

Private Sub CreateCardPanel(Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 16dip)
	pnlHost.AddView(p, Left, Top, Width, Height)
	Return p
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If Width <= 0 Or Height <= 0 Then Return
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	If mbRendered = False Then RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	If mbRendered = False Then RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Component Events
Private Sub sb1_check_changed (check As Boolean)
	mbHeartChecked = check
	Log("Button sb1 status = " & check)
	LogEvent("sb1 (Heart) check_changed = " & check)
End Sub

Private Sub sb1_button_clicked
	Log("sb1 clicked")
	LogEvent("sb1 (Heart) button_clicked")
End Sub

Private Sub sb2_check_changed (check As Boolean)
	Log("Button sb2 status = " & check)
	LogEvent("sb2 (Like) check_changed = " & check)
End Sub

Private Sub sb2_button_clicked
	Log("sb2 clicked")
	LogEvent("sb2 (Like) button_clicked")
End Sub

Private Sub sb3_check_changed (check As Boolean)
	Log("Button sb3 status = " & check)
	LogEvent("sb3 (Smile) check_changed = " & check)
End Sub

Private Sub sb3_button_clicked
	Log("sb3 clicked")
	LogEvent("sb3 (Smile) button_clicked")
End Sub

Private Sub sb4_check_changed (check As Boolean)
	Log("Button sb4 status = " & check)
	LogEvent("sb4 (Star) check_changed = " & check)
End Sub

Private Sub sb4_button_clicked
	Log("sb4 clicked")
	LogEvent("sb4 (Star) button_clicked")
End Sub

Private Sub btnToggleHeart_Click(Tag As Object)
	If sb1.IsInitialized Then
		mbHeartChecked = Not(mbHeartChecked)
		sb1.Checked = mbHeartChecked
		B4XPages.MainPage.ShowToastSuccess("Heart checked: " & mbHeartChecked, False)
	End If
End Sub

Private Sub btnAnimHeart_Click(Tag As Object)
	If sb1.IsInitialized Then
		sb1.showAnim
		B4XPages.MainPage.ShowToastSuccess("Triggered Heart shine animation", False)
	End If
End Sub

Private Sub LogEvent(Msg As String)
	If lblStatus.IsInitialized Then
		Dim timestamp As String = DateTime.Time(DateTime.Now)
		lblStatus.Text = "[" & timestamp & "] " & Msg & CRLF & lblStatus.Text
	End If
End Sub
#End Region
