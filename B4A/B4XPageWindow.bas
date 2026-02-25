B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=1
@EndOfDesignText@

Sub Class_Globals
	Private xui As XUI
	Private Root As B4XView
	Private scvContent As ScrollView
	Private pnlContent As B4XView
	Private currentY As Int = 20dip
	Private gap As Int = 26dip
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 245, 246))

	scvContent.Initialize(0)
	Root.AddView(scvContent, 0, 0, Root.Width, Root.Height)
	pnlContent = scvContent.Panel
	pnlContent.Color = Root.Color
	pnlContent.Width = Root.Width

	AddTitle("Window mockup")
	AddSimpleWindow

	AddTitle("Window with components")
	AddComposableWindow

	AddTitle("Browser mockup")
	AddBrowserWindow

	AddTitle("Shadow levels")
	AddShadowShowcase

	pnlContent.Height = currentY + 32dip
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If scvContent.IsInitialized = False Then Return
	scvContent.SetLayoutAnimated(0, 0, 0, Width, Height)
	pnlContent.Width = Width
End Sub

Private Sub AddTitle(Text As String)
	Dim lbl As Label
	lbl.Initialize("")
	Dim xlbl As B4XView = lbl
	xlbl.Text = Text
	xlbl.Font = xui.CreateDefaultBoldFont(18)
	xlbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	pnlContent.AddView(xlbl, 12dip, currentY, Root.Width - 24dip, 28dip)
	currentY = currentY + 34dip
End Sub

Private Sub AddSimpleWindow
	Dim win As B4XDaisyWindow
	win.Initialize(Me, "win_simple")

	Dim boxW As Int = Min(Root.Width - 24dip, 360dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 230dip)
	win.setBackgroundColor("bg-base-100")
	win.setBorderColor("border-base-300")
	win.setBorderSize(1)
	win.setContentPadding(12)
	win.setHeaderHeight(24)

	Dim lbl As Label
	lbl.Initialize("")
	Dim xLbl As B4XView = lbl
	xLbl.Text = "Hello!"
	xLbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
	xLbl.Font = xui.CreateDefaultFont(30)
	xLbl.SetTextAlignment("CENTER", "CENTER")
	win.AddContentView(xLbl, 0, 0, win.GetContentPanel.Width, win.GetContentPanel.Height)

	currentY = currentY + v.Height + gap
End Sub

Private Sub AddComposableWindow
	Dim win As B4XDaisyWindow
	win.Initialize(Me, "win_composable")

	Dim boxW As Int = Min(Root.Width - 24dip, 360dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 260dip)
	win.setBackgroundColor("bg-base-100")
	win.setBorderColor("border-base-300")
	win.setBorderSize(1)
	win.setContentPadding(12)
	win.setHeaderHeight(24)

	Dim titleLbl As B4XDaisyText
	titleLbl.Initialize(Me, "")
	titleLbl.AddToParent(win.GetContentPanel, 0, 0, win.GetContentPanel.Width, 32dip)
	titleLbl.Text = "Drop any component here"
	titleLbl.FontBold = True
	titleLbl.HAlign = "LEFT"
	titleLbl.VAlign = "CENTER"
	titleLbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	titleLbl.BackgroundColor = xui.Color_Transparent

	Dim note As B4XDaisyText
	note.Initialize(Me, "")
	note.AddToParent(win.GetContentPanel, 0, 34dip, win.GetContentPanel.Width, 28dip)
	note.Text = "This content area is plain and composable."
	note.TextSize = "text-sm"
	note.HAlign = "LEFT"
	note.TextColor = B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray), 170)
	note.BackgroundColor = xui.Color_Transparent

	Dim badge As B4XDaisyBadge
	badge.Initialize(Me, "")
	badge.AddToParent(win.GetContentPanel, 0, 72dip, 120dip, 32dip)
	badge.Text = "B4XDaisyBadge"
	badge.Variant = "primary"
	badge.Style = "solid"
	badge.Rounded = "rounded-full"
	badge.setHeight("8")

	Dim indicator As B4XDaisyIndicator
	indicator.Initialize(Me, "")
	indicator.AddToParent(win.GetContentPanel, 132dip, 66dip, 128dip, 44dip)
	indicator.Text = "Live"
	indicator.Variant = "success"

	currentY = currentY + v.Height + gap
End Sub

Private Sub AddBrowserWindow
	Dim win As B4XDaisyWindow
	win.Initialize(Me, "win_browser")

	Dim boxW As Int = Min(Root.Width - 24dip, 420dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 240dip)
	win.setBackgroundColor("bg-base-100")
	win.setBorderColor("border-base-300")
	win.setBorderSize(1)
	win.setContentPadding(12)
	win.setHeaderHeight(30)
	win.setShowControls(True)

	Dim headerSlot As B4XView = win.GetHeaderPanel
	Dim barW As Int = Min(Max(140dip, headerSlot.Width - 20dip), 280dip)
	Dim barH As Int = Max(18dip, headerSlot.Height - 4dip)
	Dim barLeft As Int = Max(0, (headerSlot.Width - barW) / 2)
	Dim barTop As Int = Max(0, (headerSlot.Height - barH) / 2)

	Dim pAddress As Panel
	pAddress.Initialize("")
	Dim addressBar As B4XView = pAddress
	addressBar.Color = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
	addressBar.SetColorAndBorder(addressBar.Color, 1dip, B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(220, 220, 224)), 4dip)

	Dim lblUrl As Label
	lblUrl.Initialize("")
	Dim xUrl As B4XView = lblUrl
	xUrl.Text = "https://daisyui.com"
	xUrl.Font = xui.CreateDefaultFont(12)
	xUrl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	xUrl.SetTextAlignment("CENTER", "LEFT")
	addressBar.AddView(xUrl, 10dip, 0, Max(0, barW - 20dip), barH)

	win.AddHeaderView(addressBar, barLeft, barTop, barW, barH)

	Dim lbl As Label
	lbl.Initialize("")
	Dim xLbl As B4XView = lbl
	xLbl.Text = "Hello!"
	xLbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
	xLbl.Font = xui.CreateDefaultFont(28)
	xLbl.SetTextAlignment("CENTER", "CENTER")
	win.AddContentView(xLbl, 0, 0, win.GetContentPanel.Width, win.GetContentPanel.Height)

	currentY = currentY + v.Height + gap
End Sub

Private Sub AddShadowShowcase
	Dim boxW As Int = Min(Root.Width - 24dip, 360dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim shadowValues As List
	shadowValues.Initialize
	shadowValues.AddAll(Array As String("none", "xs", "sm", "md", "lg", "xl"))

	For Each shadowValue As String In shadowValues
		Dim win As B4XDaisyWindow
		win.Initialize(Me, "win_shadow")

		Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 140dip)
		win.setBackgroundColor("bg-base-100")
		win.setBorderColor("border-base-300")
		win.setBorderSize(1)
		win.setContentPadding(12)
		win.setHeaderHeight(24)
		win.setShadow(shadowValue)

		Dim lblName As Label
		lblName.Initialize("")
		Dim xName As B4XView = lblName
		xName.Text = "shadow-" & shadowValue
		xName.Font = xui.CreateDefaultBoldFont(18)
		xName.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
		xName.SetTextAlignment("LEFT", "CENTER")
		win.AddContentView(xName, 0, 0, win.GetContentPanel.Width, 28dip)

		Dim lblDesc As Label
		lblDesc.Initialize("")
		Dim xDesc As B4XView = lblDesc
		xDesc.Text = "Use this elevation when visual hierarchy needs " & shadowValue & " depth."
		xDesc.Font = xui.CreateDefaultFont(13)
		xDesc.TextColor = B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray), 180)
		xDesc.SetTextAlignment("LEFT", "TOP")
		win.AddContentView(xDesc, 0, 34dip, win.GetContentPanel.Width, 56dip)

		currentY = currentY + v.Height + 14dip
	Next
End Sub

Private Sub win_simple_ControlClick(Index As Int)
	#If B4A
	ToastMessageShow("Window control " & Index, False)
	#End If
End Sub

Private Sub win_composable_ControlClick(Index As Int)
	#If B4A
	ToastMessageShow("Window control " & Index, False)
	#End If
End Sub

Private Sub win_browser_ControlClick(Index As Int)
	#If B4A
	ToastMessageShow("Browser control " & Index, False)
	#End If
End Sub

Private Sub win_shadow_ControlClick(Index As Int)
	#If B4A
	ToastMessageShow("Shadow demo control " & Index, False)
	#End If
End Sub
