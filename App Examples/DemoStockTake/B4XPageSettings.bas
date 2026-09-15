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
	Private togDark As B4XDaisyToggle
	Private selLang As B4XDaisySelect
	Private btnLogout As B4XDaisyButton
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
	navbar.Title = "Settings"
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

	togDark.Initialize(Me, "togDark")
	togDark.AddToParent(pnlHost, pad, y, maxW, 48dip)
	togDark.Text = "Dark Mode"
	togDark.Checked = False
	y = y + togDark.GetComputedHeight + gap

	selLang.Initialize(Me, "selLang")
	selLang.AddToParent(pnlHost, pad, y, maxW, 60dip)
	selLang.LabelAbove = "App Language"
	selLang.AddItem("en", "English")
	selLang.AddItem("es", "Espanol")
	selLang.AddItem("fr", "Francais")
	selLang.Value = "en"
	y = y + selLang.GetComputedHeight + gap

	btnLogout.Initialize(Me, "btnLogout")
	btnLogout.AddToParent(pnlHost, pad, y, maxW, 48dip)
	btnLogout.Text = "Logout of StockTake"
	btnLogout.Variant = "error"
	y = y + btnLogout.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub navbar_Back (oTag As Object)
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("dashboard")
End Sub

Private Sub btnLogout_Click
	Dim pgMain As B4XMainPage = B4XPages.MainPage
	pgMain.ShowPageWithLoader("login")
End Sub
