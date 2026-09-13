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
	Private pnlHost   As B4XView
	Private navbar     As B4XDaisyNavbar
	Private dock       As B4XDaisyDock
	Private togNotify  As B4XDaisyToggle
	Private togDark    As B4XDaisyToggle
	Private btnLogout  As B4XDaisyButton
	Private pad        As Int
	Private gap        As Int
	Private maxW       As Int
	Private y          As Int
	Private NAVBAR_H   As Int
	Private DOCK_H     As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	NAVBAR_H = 56dip
	DOCK_H   = 64dip

	BuildScroll
	BuildNavbar
	BuildDock
	RenderContent
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	' Reset the dock indicator to this page's own item (see B4XPageDashboard note).
	If dock.IsInitialized Then dock.ActiveIndex = 1
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_H)
	If dock.IsInitialized Then dock.View.SetLayoutAnimated(0, 0, Height - DOCK_H, Width, DOCK_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height - NAVBAR_H - DOCK_H)
		RenderContent
	End If
End Sub

Private Sub BuildScroll
	Dim scrollTop As Int = NAVBAR_H
	Dim scrollH   As Int = Root.Height - NAVBAR_H - DOCK_H
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, scrollTop, Root.Width, scrollH)
	pageScroll.SendToBack
	pnlHost = pageScroll.Panel
End Sub

Private Sub BuildNavbar
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
	navbar.BackVisible = True
	navbar.BackSize = 40dip
	navbar.BringToFront
	navbar.Title = "Settings"
	navbar.Variant = "primary"
End Sub

Private Sub BuildDock
	dock.Initialize(Me, "dock")
	dock.Size = "md"
	dock.ActivePosition = "top"
	dock.ActiveIndex = 1
	dock.AddToParent(Root, 0, Root.Height - DOCK_H, Root.Width, DOCK_H)
	dock.AddItem("dash",     "Analytics", "chart-bar-solid.svg")
	dock.AddItem("settings", "Settings",  "cog-6-tooth-solid.svg")
End Sub

Private Sub RenderContent
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	y = pageScroll.AddSectionTitle("App Preferences", y, False) + gap

	togNotify.Initialize(Me, "togNotify")
	togNotify.AddToParent(pnlHost, pad, y, maxW, 40dip)
	togNotify.Text = "Email Notifications"
	togNotify.Checked = True
	y = y + togNotify.GetComputedHeight + gap

	togDark.Initialize(Me, "togDark")
	togDark.AddToParent(pnlHost, pad, y, maxW, 40dip)
	togDark.Text = "Dark Theme Mode"
	togDark.Checked = False
	y = y + togDark.GetComputedHeight + gap * 2

	btnLogout.Initialize(Me, "btnLogout")
	btnLogout.AddToParent(pnlHost, pad, y, maxW, 44dip)
	btnLogout.Text = "Sign Out of Account"
	btnLogout.Variant = "error"
	btnLogout.Block = True
	y = y + btnLogout.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub dock_ItemClick(ItemId As String)
	Select Case ItemId
		Case "dash"
			B4XPages.MainPage.ShowPageWithLoader("dashboard")
	End Select
End Sub

Private Sub btnLogout_Click(Tag As Object)
	B4XPages.MainPage.ShowPageWithLoader("login")
End Sub

Private Sub navbar_Back(Tag As Object)
	B4XPages.MainPage.ClosePageWithLoader(Me)
End Sub