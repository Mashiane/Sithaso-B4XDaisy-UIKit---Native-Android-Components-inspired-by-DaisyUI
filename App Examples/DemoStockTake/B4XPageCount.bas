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
	Private alItem As B4XDaisyAlert
	Private rg As B4XDaisyRange
	Private inpQty As B4XDaisyInput
	Private btnSave As B4XDaisyButton
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
	navbar.Title = "Physical Count"
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

	alItem.Initialize(Me, "alItem")
	alItem.AddToParent(pnlHost, pad, y, maxW, 60dip)
	alItem.SetText("Industrial Valve 1/2 in (Expected: 15)")
	alItem.SetVariant("info")
	y = y + alItem.GetComputedHeight + gap

	rg.Initialize(Me, "rg")
	rg.AddToParent(pnlHost, pad, y, maxW, 36dip)
	rg.MinValue = 0
	rg.MaxValue = 50
	rg.Value = 12
	y = y + rg.GetComputedHeight + gap

	inpQty.Initialize(Me, "inpQty")
	inpQty.AddToParent(pnlHost, pad, y, maxW, 60dip)
	inpQty.LabelAbove = "Counted Quantity"
	inpQty.InputType = "number"
	inpQty.Text = "12"
	inpQty.Required = True
	y = y + inpQty.GetComputedHeight + gap

	btnSave.Initialize(Me, "btnSave")
	btnSave.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnSave.Text = "Save Count & Reconcile"
	btnSave.Variant = "primary"
	y = y + btnSave.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub navbar_Back (oTag As Object)
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("dashboard")
End Sub

Private Sub rg_Change(iVal As Int)
	If inpQty.IsInitialized Then
		inpQty.Text = iVal
	End If
End Sub

Private Sub btnSave_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("variance")
End Sub
