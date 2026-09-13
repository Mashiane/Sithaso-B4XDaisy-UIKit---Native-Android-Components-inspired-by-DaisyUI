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
	Private stp As B4XDaisySteps
	Private tl As B4XDaisyTimeline
	Private btnRecount As B4XDaisyButton
	Private btnFinish As B4XDaisyButton
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
	navbar.Title = "Variance Audit"
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

	stp.Initialize(Me, "stp")
	stp.AddToParent(pnlHost, pad, y, maxW, 50dip)
	stp.AddStep("Scan", "neutral")
	stp.AddStep("Variance", "warning")
	stp.AddStep("Resolve", "neutral")
	stp.ActiveStep = 1
	y = y + stp.GetComputedHeight + gap

	tl.Initialize(Me, "tl")
	tl.AddToParent(pnlHost, pad, y, maxW, 160dip)
	tl.AddItem("v1", "09:30", "SKU-89214: Variance -3 units")
	tl.AddItem("v2", "11:15", "SKU-44102: Variance +2 units")
	tl.Refresh
	y = y + tl.GetComputedHeight + gap

	btnRecount.Initialize(Me, "btnRecount")
	btnRecount.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnRecount.Text = "Recount Selected SKU"
	btnRecount.Variant = "warning"
	y = y + btnRecount.GetComputedHeight + gap

	btnFinish.Initialize(Me, "btnFinish")
	btnFinish.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnFinish.Text = "Approve & Log Audit Batch"
	btnFinish.Variant = "success"
	y = y + btnFinish.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub navbar_Back (oTag As Object)
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("dashboard")
End Sub

Private Sub btnRecount_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("count")
End Sub

Private Sub btnFinish_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("history")
End Sub
