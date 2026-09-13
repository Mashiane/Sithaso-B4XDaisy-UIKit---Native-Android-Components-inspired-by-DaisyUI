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
	Private lst As B4XDaisyList
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
	navbar.Title = "Audit History"
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

	lst.Initialize(Me, "lst")
	lst.Rounded = "rounded-box"
	lst.Shadow = "shadow-md"
	lst.BackgroundColor = "base-100"
	lst.RowHeight = 64dip
	lst.AutoHeight = True
	lst.AddToParent(pnlHost, pad, y, maxW, 320dip)
	
	lst.AddHeader("Recent Stock Audit Batches")
	lst.AddRowData(CreateMap("Tag": "b1042", "title": "Batch #1042 (2026-08-28)", "subtitle": "100% Matched - Zero Variance", "status": "MATCHED", "variant": "success"))
	lst.AddRowData(CreateMap("Tag": "b1041", "title": "Batch #1041 (2026-08-25)", "subtitle": "3 Variances Reconciled", "status": "RESOLVED", "variant": "warning"))
	lst.AddRowData(CreateMap("Tag": "b1040", "title": "Batch #1040 (2026-08-20)", "subtitle": "Completed by Lead Auditor", "status": "PASSED", "variant": "info"))
	lst.AddRowData(CreateMap("Tag": "b1039", "title": "Batch #1039 (2026-08-15)", "subtitle": "Quarterly Floor Stocktake", "status": "ARCHIVED", "variant": "neutral"))
	
	y = y + lst.GetComputedHeight + gap
	pageScroll.AutoFit
End Sub

Private Sub lst_CreateRowContent(Index As Int)
	Dim pnlRow As B4XView = lst.GetCurrentRowPanel
	Dim data As Map = lst.GetCurrentRowData
	If pnlRow = Null Or pnlRow.IsInitialized = False Or data = Null Or data.IsInitialized = False Then Return
	
	Dim isHeader As Boolean = data.GetDefault("_header", False)
	If isHeader Then
		Dim txtHeader As B4XDaisyText
		txtHeader.Initialize(Me, "")
		txtHeader.AddToParent(pnlRow, 16dip, 0, pnlRow.Width - 32dip, pnlRow.Height)
		txtHeader.Text = data.GetDefault("title", "")
		txtHeader.TextSize = 12
		txtHeader.TextColor = xui.Color_ARGB(160, 0, 0, 0)
		txtHeader.UpperCase = True
		txtHeader.FontBold = True
		txtHeader.VAlign = "CENTER"
		Return
	End If
	
	Dim txtTitle As B4XDaisyText
	txtTitle.Initialize(Me, "")
	txtTitle.AddToParent(pnlRow, 16dip, 10dip, pnlRow.Width - 110dip, 22dip)
	txtTitle.Text = data.GetDefault("title", "")
	txtTitle.TextSize = 14
	txtTitle.FontBold = True
	txtTitle.SingleLine = True
	
	Dim txtSub As B4XDaisyText
	txtSub.Initialize(Me, "")
	txtSub.AddToParent(pnlRow, 16dip, 32dip, pnlRow.Width - 110dip, 20dip)
	txtSub.Text = data.GetDefault("subtitle", "")
	txtSub.TextSize = 11
	txtSub.TextColor = xui.Color_ARGB(150, 0, 0, 0)
	txtSub.SingleLine = True
	
	Dim badge As B4XDaisyBadge
	badge.Initialize(Me, "")
	badge.SetVariant(data.GetDefault("variant", "info"))
	badge.SetStyle("soft")
	badge.SetSize("sm")
	badge.SetText(data.GetDefault("status", ""))
	badge.AddToParent(pnlRow, pnlRow.Width - 92dip, (pnlRow.Height - 24dip) / 2, 76dip, 24dip)
End Sub

Private Sub navbar_Back (oTag As Object)
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ClosePageWithLoader(Me)
End Sub
