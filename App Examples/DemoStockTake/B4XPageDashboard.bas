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
	Private stat As B4XDaisyStat
	Private prog As B4XDaisyProgress
	Private btnScan As B4XDaisyButton
	Private btnCount As B4XDaisyButton
	Private btnVariance As B4XDaisyButton
	Private btnHistory As B4XDaisyButton
	Private btnSettings As B4XDaisyButton
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
	navbar.Title = "StockTake Dashboard"
	navbar.Variant = "primary"
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

	stat.Initialize(Me, "stat")
	stat.AddToParent(pnlHost, pad, y, maxW, 110dip)
	stat.Orientation = "horizontal"
	
	Dim s1 As B4XDaisyStatItem
	s1.Initialize(Me, "s1")
	s1.Title = "Counted"
	s1.Value = "1,240"
	s1.Description = "+12% today"
	s1.FigureType = "svg"
	s1.FigureSource = "check-solid.svg"
	s1.FigureColor = "success"
	stat.AddItem(s1)
	
	Dim s2 As B4XDaisyStatItem
	s2.Initialize(Me, "s2")
	s2.Title = "Variances"
	s2.Value = "8"
	s2.Description = "Needs recount"
	s2.FigureType = "svg"
	s2.FigureSource = "triangle-exclamation-solid.svg"
	s2.FigureColor = "warning"
	stat.AddItem(s2)
	
	stat.Refresh
	y = y + stat.GetComputedHeight + gap

	prog.Initialize(Me, "prog")
	prog.AddToParent(pnlHost, pad, y, maxW, 24dip)
	prog.Value = 68
	prog.Variant = "primary"
	y = y + prog.GetComputedHeight + gap

	btnScan.Initialize(Me, "btnScan")
	btnScan.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnScan.Text = "Scan Barcode / SKU"
	btnScan.Variant = "primary"
	y = y + btnScan.GetComputedHeight + gap

	btnCount.Initialize(Me, "btnCount")
	btnCount.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnCount.Text = "Physical Count Entry"
	btnCount.Variant = "secondary"
	y = y + btnCount.GetComputedHeight + gap

	btnVariance.Initialize(Me, "btnVariance")
	btnVariance.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnVariance.Text = "Review Variances (8)"
	btnVariance.Variant = "warning"
	y = y + btnVariance.GetComputedHeight + gap

	btnHistory.Initialize(Me, "btnHistory")
	btnHistory.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnHistory.Text = "Audit History"
	btnHistory.Variant = "neutral"
	y = y + btnHistory.GetComputedHeight + gap

	btnSettings.Initialize(Me, "btnSettings")
	btnSettings.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnSettings.Text = "Settings"
	btnSettings.Variant = "ghost"
	y = y + btnSettings.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub btnScan_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("scan")
End Sub

Private Sub btnCount_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("count")
End Sub

Private Sub btnVariance_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("variance")
End Sub

Private Sub btnHistory_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("history")
End Sub

Private Sub btnSettings_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("settings")
End Sub
