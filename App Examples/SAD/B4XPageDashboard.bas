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

	Private pageScroll  As B4XDaisyPageScroll
	Private pnlHost    As B4XView
	Private navbar     As B4XDaisyNavbar
	Private dock       As B4XDaisyDock
	Private statRow    As B4XDaisyStat
	Private progTarget As B4XDaisyProgress
	Private timeline   As B4XDaisyTimeline
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
	' Reset the dock indicator to this page's own item. A dock item tap sets
	' miActiveIndex on the source dock before navigating away; without a reset
	' here, returning to the page leaves the dock highlighting the wrong item.
	If dock.IsInitialized Then dock.ActiveIndex = 0
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
	navbar.Title = "SaaS Analytics"
	navbar.Variant = "primary"
End Sub

Private Sub BuildDock
	dock.Initialize(Me, "dock")
	dock.Size = "md"
	dock.ActivePosition = "top"
	dock.ActiveIndex = 0
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

	statRow.Initialize(Me, "statRow")
	statRow.Orientation = "vertical"
	statRow.Width = "w-content"
	statRow.AddToParent(pnlHost, pad, y, maxW, 1dip)
	statRow.Shadow = "md"
	statRow.Rounded = "box"

	Dim s1 As B4XDaisyStatItem
	s1.Initialize(Me, "s1")
	s1.Title = "Monthly Revenue"
	s1.Value = "$32,450"
	s1.Description = "+22% vs last month"
	s1.FigureType = "svg"
	s1.FigureSource = "bolt-solid.svg"
	s1.FigureColor = "success"
	statRow.AddItem(s1)

	Dim s2 As B4XDaisyStatItem
	s2.Initialize(Me, "s2")
	s2.Title = "Active Users"
	s2.Value = "2,840"
	s2.Description = "142 online now"
	s2.FigureType = "radial"
	s2.FigureSource = "82"
	s2.FigureColor = "primary"
	statRow.AddItem(s2)

	statRow.Refresh
	' Fit-content width + center horizontally (mirrors B4XPageStat Example 4)
	If statRow.ContentWidth > 0 And statRow.ContentHeight > 0 Then
		Dim cx As Int = pad + (maxW - statRow.ContentWidth) / 2
		statRow.SetLayoutAnimated(0, cx, y, statRow.ContentWidth, statRow.ContentHeight)
	End If
	y = y + statRow.GetComputedHeight + gap

	y = pageScroll.AddSectionTitle("Quarterly Target Progress (78%)", y, False) + gap
	progTarget.Initialize(Me, "progTarget")
	progTarget.AddToParent(pnlHost, pad, y, maxW, 24dip)
	progTarget.Variant = "primary"
	progTarget.Value = 78
	y = y + progTarget.GetComputedHeight + gap

	y = pageScroll.AddSectionTitle("Recent Activity", y, False) + gap
	timeline.Initialize(Me, "timeline")
	timeline.Orientation = "vertical"
	timeline.AddToParent(pnlHost, pad, y, maxW, 180dip)
	timeline.MarkerColor = "primary"
	timeline.AddItem("t1", "09:45", "New Enterprise Plan Subscribed ($499/mo)")
	timeline.AddItem("t2", "11:20", "Automated DB Backup Completed")
	timeline.AddItem("t3", "14:10", "System Health Check Passed 100%")
	timeline.Refresh
	' Size the frame to the measured content so the timeline never scrolls
	' internally; the page scroll reveals the rest. Re-Refresh so the inner
	' scrollview matches the resized frame.
	Dim contentH As Int = timeline.GetContentHeight
	If contentH > 0 Then
		timeline.SetLayoutAnimated(0, pad, y, maxW, contentH)
		timeline.Refresh
	End If
	y = y + timeline.GetContentHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub dock_ItemClick(ItemId As String)
	Select Case ItemId
		Case "settings"
			B4XPages.MainPage.ShowPageWithLoader("settings")
	End Select
End Sub

Private Sub navbar_Back(Tag As Object)
	B4XPages.MainPage.ClosePageWithLoader(Me)
End Sub