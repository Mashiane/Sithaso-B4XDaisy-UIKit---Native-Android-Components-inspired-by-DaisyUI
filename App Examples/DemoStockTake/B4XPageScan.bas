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
	Private navbar As B4XDaisyNavbar
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	Private inpScan As B4XDaisyInput
	Private btnScan As B4XDaisyButton
	Private alStatus As B4XDaisyAlert
	Private btnProceed As B4XDaisyButton
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	
	Dim navH As Int = 56dip
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, navH)
	navbar.Title = "Scan SKU"
	navbar.Variant = "primary"
	navbar.BackVisible = True
	navbar.TitlePosition = "center"
	
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, navH, Root.Width, Root.Height - navH)
	pnlHost = pageScroll.Panel
	RenderPage(Root.Width, Root.Height - navH)
	navbar.BringToFront
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If navbar.IsInitialized Then
		Dim navH As Int = 56dip
		navbar.Base_Resize(Width, navH)
		If pageScroll.IsInitialized Then
			pageScroll.Base_Resize(Width, Height - navH)
			RenderPage(Width, Height - navH)
		End If
		navbar.BringToFront
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

	inpScan.Initialize(Me, "inpScan")
	inpScan.AddToParent(pnlHost, pad, y, maxW, 60dip)
	inpScan.LabelAbove = "Scan or Type Barcode / SKU"
	inpScan.Placeholder = "789123456012"
	inpScan.Text = "789123456012"
	inpScan.InputType = "text"
	inpScan.Required = True
	y = y + inpScan.GetComputedHeight + gap

	btnScan.Initialize(Me, "btnScan")
	btnScan.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnScan.Text = "Simulate Barcode Scan"
	btnScan.Variant = "primary"
	y = y + btnScan.GetComputedHeight + gap

	alStatus.Initialize(Me, "alStatus")
	alStatus.AddToParent(pnlHost, pad, y, maxW, 80dip)
	alStatus.SetText("Item: Industrial Valve 1/2 in - Expected: 15")
	alStatus.SetVariant("success")
	y = y + alStatus.GetComputedHeight + gap

	btnProceed.Initialize(Me, "btnProceed")
	btnProceed.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnProceed.Text = "Proceed to Count (15 expected)"
	btnProceed.Variant = "accent"
	y = y + btnProceed.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub navbar_Back (oTag As Object)
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("dashboard")
End Sub

Private Sub btnScan_Click
	alStatus.SetText("Item: Industrial Valve 1/2 in - Expected: 15")
	alStatus.SetVariant("success")
End Sub

Private Sub btnProceed_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("count")
End Sub
