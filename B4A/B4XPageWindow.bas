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


Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub


Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If scvContent.IsInitialized = False Then Return
	scvContent.SetLayoutAnimated(0, 0, 0, Width, Height)
	pnlContent.Width = Width
End Sub

Private Sub AddTitle(Text As String)
	Dim lbl As B4XDaisyText
	lbl.Initialize(Me, "")
	lbl.AddToParent(pnlContent, 12dip, currentY, Root.Width - 24dip, 28dip)
	lbl.Text = Text
	lbl.TextSize = 18
	lbl.FontBold = True
	lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	currentY = currentY + lbl.GetComputedHeight + 6dip
End Sub

Private Sub AddSimpleWindow
	Dim win As B4XDaisyWindow
	win.Initialize(Me, "win_simple")

	Dim boxW As Int = Min(Root.Width - 24dip, 360dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 230dip)
	win.setContentPadding("p-3")

	Dim lbl As B4XDaisyText
	lbl.Initialize(Me, "")
	lbl.AddToParent(win.Content, 0, 0, win.ContentWidth, win.ContentHeight)
	lbl.Text = "Hello!"
	lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
	lbl.TextSize = 30
	lbl.HAlign = "CENTER"
	lbl.VAlign = "CENTER"
	win.RefreshContent

	currentY = currentY + v.Height + gap
End Sub

Private Sub AddComposableWindow
	Dim win As B4XDaisyWindow
	win.Initialize(Me, "win_composable")

	Dim boxW As Int = Min(Root.Width - 24dip, 360dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 260dip)
	win.setContentPadding("p-3")

	Dim contentY As Int = 0
	Dim itemGap As Int = 6dip

	Dim titleLbl As B4XDaisyText
	titleLbl.Initialize(Me, "")
	titleLbl.AddToParent(win.Content, 0, contentY, win.ContentWidth, 32dip)
	titleLbl.Text = "Drop any component here"
	titleLbl.FontBold = True
	titleLbl.HAlign = "LEFT"
	titleLbl.VAlign = "CENTER"
	titleLbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	contentY = contentY + titleLbl.GetComputedHeight + itemGap

	Dim note As B4XDaisyText
	note.Initialize(Me, "")
	note.AddToParent(win.Content, 0, contentY, win.ContentWidth, 28dip)
	note.Text = "This content area is plain and composable."
	note.TextSize = "text-sm"
	note.HAlign = "LEFT"
	note.TextColor = B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray), 170)
	contentY = contentY + note.GetComputedHeight + itemGap

	Dim badge As B4XDaisyBadge
	badge.Initialize(Me, "")
	badge.AddToParent(win.Content, 0, contentY, Min(120dip, win.ContentWidth), 32dip)
	badge.Text = "B4XDaisyBadge"
	badge.Variant = "primary"
	badge.Style = "solid"
	badge.Rounded = "rounded-full"
	badge.setHeight("8")
	win.RefreshContent

	currentY = currentY + v.Height + gap
End Sub

Private Sub AddBrowserWindow
	Dim win As B4XDaisyWindow
	win.Initialize(Me, "win_browser")

	Dim boxW As Int = Min(Root.Width - 24dip, 420dip)
	Dim left As Int = 12dip
	If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

	Dim v As B4XView = win.AddToParent(pnlContent, left, currentY, boxW, 240dip)
	win.setContentPadding("p-3")
	win.setHeaderHeight(30)
	win.setShowControls(True)
	win.setToolBarTitle("https://daisyui.com")

	Dim lbl As B4XDaisyText
	lbl.Initialize(Me, "")
	lbl.AddToParent(win.Content, 0, 0, win.ContentWidth, win.ContentHeight)
	lbl.Text = "Hello!"
	lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
	lbl.TextSize = 28
	lbl.HAlign = "CENTER"
	lbl.VAlign = "CENTER"
	win.RefreshContent

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
		win.setContentPadding("p-3")
		win.setHeaderHeight(24)
		win.setShadow(shadowValue)

		Dim contentY As Int = 0
		Dim itemGap As Int = 6dip

		Dim lblName As B4XDaisyText
		lblName.Initialize(Me, "")
		lblName.AddToParent(win.Content, 0, contentY, win.ContentWidth, 28dip)
		lblName.Text = "shadow-" & shadowValue
		lblName.TextSize = 18
		lblName.FontBold = True
		lblName.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
		lblName.HAlign = "LEFT"
		lblName.VAlign = "CENTER"
		contentY = contentY + lblName.GetComputedHeight + itemGap

		Dim lblDesc As B4XDaisyText
		lblDesc.Initialize(Me, "")
		lblDesc.AddToParent(win.Content, 0, contentY, win.ContentWidth, 56dip)
		lblDesc.Text = "Use this elevation when visual hierarchy needs " & shadowValue & " depth."
		lblDesc.TextSize = 13
		lblDesc.TextColor = B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray), 180)
		lblDesc.HAlign = "LEFT"
		lblDesc.VAlign = "TOP"
		win.RefreshContent

		currentY = currentY + v.Height + 14dip
	Next
End Sub
