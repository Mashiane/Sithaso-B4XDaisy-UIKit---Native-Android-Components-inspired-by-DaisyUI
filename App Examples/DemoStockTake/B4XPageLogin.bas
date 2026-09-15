B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.70
@EndOfDesignText@
#IgnoreWarnings:12,9
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	Private txtTitle As B4XDaisyText
	Private txtSubtitle As B4XDaisyText
	Private inpEmail As B4XDaisyInput
	Private inpPass As B4XDaisyInput
	Private btnLogin As B4XDaisyButton
	Private alInfo As B4XDaisyAlert
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel
	RenderPage(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height)
		RenderPage(Width, Height)
	End If
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub RenderPage(W As Int, H As Int)
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim maxW As Int = pageScroll.UsableWidth
	Dim y As Int = pad

	txtTitle.Initialize(Me, "txtTitle")
	txtTitle.AddToParent(pnlHost, pad, y, maxW, 0)
	txtTitle.Text = "Demo StockTake"
	txtTitle.TextSize = "text-3xl"
	txtTitle.FontBold = True
	txtTitle.HAlign = "CENTER"
	y = y + txtTitle.GetComputedHeight + 4dip

	txtSubtitle.Initialize(Me, "txtSubtitle")
	txtSubtitle.AddToParent(pnlHost, pad, y, maxW, 0)
	txtSubtitle.Text = "Mobile Inventory & Barcode Counting"
	txtSubtitle.TextSize = "text-sm"
	txtSubtitle.TextColor = xui.Color_Gray
	txtSubtitle.HAlign = "CENTER"
	y = y + txtSubtitle.GetComputedHeight + gap * 2

	inpEmail.Initialize(Me, "inpEmail")
	inpEmail.AddToParent(pnlHost, pad, y, maxW, 60dip)
	inpEmail.LabelAbove = "Email / User ID"
	inpEmail.Placeholder = "auditor@warehouse.com"
	inpEmail.InputType = "email"
	inpEmail.Text = "auditor@warehouse.com"
	inpEmail.Required = True
	y = y + inpEmail.GetComputedHeight + gap

	inpPass.Initialize(Me, "inpPass")
	inpPass.AddToParent(pnlHost, pad, y, maxW, 60dip)
	inpPass.LabelAbove = "Password"
	inpPass.Placeholder = "••••••••"
	inpPass.InputType = "password"
	inpPass.Text = "password123"
	inpPass.Required = True
	y = y + inpPass.GetComputedHeight + gap

	btnLogin.Initialize(Me, "btnLogin")
	btnLogin.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnLogin.Text = "Sign In to Count"
	btnLogin.Variant = "primary"
	y = y + btnLogin.GetComputedHeight + gap

	alInfo.Initialize(Me, "alInfo")
	alInfo.AddToParent(pnlHost, pad, y, maxW, 60dip)
	alInfo.SetText("Ready for warehouse stock audit.")
	alInfo.SetVariant("info")
	y = y + alInfo.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub btnLogin_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("dashboard")
End Sub

