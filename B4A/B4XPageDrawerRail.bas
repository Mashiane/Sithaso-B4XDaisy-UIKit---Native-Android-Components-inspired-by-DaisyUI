B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	
	' Core Containers
	Private mainDrawer As B4XDaisyDrawer
	Private topNavbar As B4XDaisyNavbar
	Private sideMenu As B4XDaisyMenu
	Private pageScroll As B4XDaisyPageScroll
	Private pnlContent As B4XView
	
	' Dynamic Dimensions & Sizing Properties
	Private NAVBAR_HEIGHT As Int = 56dip
	Public RailWidth As String = "60dip"
	Public ExpandedWidth As String = "240dip"
	Private PAGE_PAD As Int = 12dip
	
	' State Variables
	Private isRailCollapsed As Boolean = True
	Private isDockedSplit As Boolean = True
	Private currentSection As String = "home"
	
	' Interactive Controls
	Private btnToggleRail As B4XDaisyButton
	Private btnToggleDock As B4XDaisyButton
	Private lblStatus As B4XView
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
	B4XPages.SetTitle(Me, "Mini-Rail Drawer")

	RenderFullPageDrawer(Root.Width, Root.Height)
End Sub
#End Region

#Region Layout & Construction
Private Sub RenderFullPageDrawer(Width As Int, Height As Int)
	Root.RemoveAllViews

	' -
	' 1. FULLSCREEN ROOT DRAWER
	' -
	mainDrawer.Initialize(Me, "mainDrawer")
	mainDrawer.AddToParent(Root, 0, 0, Width, Height)
	mainDrawer.setSide("left")
	mainDrawer.setAlwaysOpen(isDockedSplit)
	mainDrawer.setLeftSideBackgroundColor("base-200")
	mainDrawer.setContentBackgroundColor("none")
	mainDrawer.setCollapseWidth(RailWidth)
	mainDrawer.setNormalWidth(ExpandedWidth)
	mainDrawer.setIsCollapsed(isRailCollapsed)
	
	' Dynamically resolve initial sidebar width from drawer properties
	Dim initialSideW As Int = IIf(isRailCollapsed, _
		B4XDaisyVariants.ResolveSizeSpec(mainDrawer.CollapseWidth, Width, 60dip), _
		B4XDaisyVariants.ResolveSizeSpec(mainDrawer.NormalWidth, Width, 240dip))

	' -
	' 2. LEFT SIDEBAR MENU (Takes SidePanel.Width dynamically, initialized ONCE)
	' -
	BuildSidebarMenu(mainDrawer.LeftPanel, initialSideW, Height)

	' -
	' 3. TOP NAVBAR (Inside mainDrawer.CenterPanel)
	' -
	topNavbar.Initialize(Me, "topNavbar")
	topNavbar.AddToParent(mainDrawer.CenterPanel, 0, 0, Width, NAVBAR_HEIGHT)
	topNavbar.Variant = "base-100"
	topNavbar.Shadow = "sm"
	topNavbar.Title = "Mini-Rail Drawer"
	topNavbar.TitlePosition = "start"
	topNavbar.HamburgerVisible = True
	topNavbar.HamburgerChecked = Not(isRailCollapsed)
	topNavbar.BringToFront

	' -
	' 4. CENTER PAGE SCROLL CONTAINER
	' -
	Dim contentH As Int = Max(1dip, Height - NAVBAR_HEIGHT)
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(mainDrawer.CenterPanel, 0, NAVBAR_HEIGHT, Width, contentH)
	pageScroll.Transparent = True
	pnlContent = pageScroll.Panel

	PopulateCenterContent(Width, contentH)
End Sub

' Initializes the sidebar menu ONCE with full items, badges, and icons
Private Sub BuildSidebarMenu(SidePanel As B4XView, Width As Int, Height As Int)
	SidePanel.RemoveAllViews

	sideMenu.Initialize(Me, "sideMenu")
	sideMenu.AutoResize = False
	sideMenu.Dividers = True
	sideMenu.DividerGap = "1"
	sideMenu.Padding = "p-2"
	sideMenu.Size = "md"
	sideMenu.RightBorder = True
	sideMenu.BeginUpdate
	
	sideMenu.AddIconItem("home", "Homepage", "house-solid.svg")
	sideMenu.AddIconBadgeItem("analytics", "Analytics", "table-cells-solid.svg", "Pro", "secondary")
	sideMenu.AddIconBadgeItem("messages", "Messages", "envelope-solid.svg", "4", "primary")
	sideMenu.AddIconItem("calendar", "Schedule", "calendar-solid.svg")
	sideMenu.AddIconItem("team", "Team & Profile", "user-solid.svg")
	sideMenu.AddIconItem("settings", "Settings", "gear.svg")
	
	sideMenu.SetItemActive(currentSection, True)
	sideMenu.EndUpdate

	' Set rail mode BEFORE mounting so the first Refresh inside AddToParent renders correctly
	If isRailCollapsed Then
		sideMenu.setRailMode(True, Width)
	End If
	
	' Mount to parent using parent's actual width
	sideMenu.AddToParent(SidePanel, 0, 0, Width, Height)
End Sub
#End Region

#Region Center Content Rendering
Private Sub PopulateCenterContent(Width As Int, Height As Int)
	pnlContent.RemoveAllViews

	Dim maxW As Int = Max(1dip, Width - (PAGE_PAD * 2))
	Dim contentLeft As Int = PAGE_PAD
	Dim y As Int = PAGE_PAD

	' -
	' Card 1: Interactive Mini-Rail & Responsive Drawer Controller
	' -
	Dim cardControls As B4XDaisyCard
	cardControls.Initialize(Me, "cardControls")
	Dim vControls As B4XView = cardControls.AddToParent(pnlContent, contentLeft, y, maxW, 0)
	cardControls.Title = "DaisyUI Collapsible Rail Pattern"
	cardControls.Style = "border"
	cardControls.Shadow = "sm"
	cardControls.LayoutMode = "none"

	Dim bodyControls As B4XView = cardControls.BodyContainer
	bodyControls.RemoveAllViews
	Dim cy As Int = 0
	Dim cw As Int = maxW - 48dip

	Dim txtDesc As B4XDaisyText
	txtDesc.Initialize(Me, "")
	txtDesc.AddToParent(bodyControls, 0, cy, cw, 0)
	txtDesc.Text = "Inspired by DaisyUI's responsive drawer pattern (" & _
		"is-drawer-close:w-14 is-drawer-open:w-64 with lg:drawer-open)." & CRLF & _
		"The sidebar views are initialized ONCE. Toggling switches text label visibility (" & _
		"is-drawer-close:hidden) and centers icons dynamically with zero view recreation overhead."
	txtDesc.TextSize = 13
	txtDesc.TextColor = xui.Color_RGB(71, 85, 105)
	txtDesc.AutoResize = True
	cy = cy + txtDesc.GetComputedHeight + 14dip

	' Action Button 1: Toggle Rail Width
	btnToggleRail.Initialize(Me, "btnToggleRail")
	btnToggleRail.AddToParent(bodyControls, 0, cy, cw, 40dip)
	If isRailCollapsed Then
		btnToggleRail.Text = "Expand Rail"
		btnToggleRail.Variant = "primary"
	Else
		btnToggleRail.Text = "Collapse Rail"
		btnToggleRail.Variant = "neutral"
	End If
	cy = cy + 48dip

	' Action Button 2: Toggle Docking Mode (Split vs Modal Overlay)
	btnToggleDock.Initialize(Me, "btnToggleDock")
	btnToggleDock.AddToParent(bodyControls, 0, cy, cw, 40dip)
	If isDockedSplit Then
		btnToggleDock.Text = "Mode: Docked Split"
		btnToggleDock.Variant = "secondary"
	Else
		btnToggleDock.Text = "Mode: Slide Overlay"
		btnToggleDock.Variant = "accent"
	End If
	cy = cy + 48dip

	' Status Label Display
	Dim lbl As Label
	lbl.Initialize("")
	Dim currentW As Int = IIf(isRailCollapsed, _
		B4XDaisyVariants.ResolveSizeSpec(RailWidth, Width, 60dip), _
		B4XDaisyVariants.ResolveSizeSpec(ExpandedWidth, Width, 240dip))
	Dim dockModeName As String = IIf(isDockedSplit, "Persistent Split", "Slide Overlay")
	lbl.Text = "Width: " & currentW & "px | " & dockModeName & " | Active: " & currentSection.ToUpperCase
	lbl.TextColor = xui.Color_RGB(51, 65, 85)
	lbl.TextSize = 12
	lbl.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(241, 245, 249))
	lblStatus = lbl
	lblStatus.SetTextAlignment("CENTER", "LEFT")
	bodyControls.AddView(lblStatus, 0, cy, cw, 30dip)
	cy = cy + 38dip

	cardControls.Refresh
	y = y + vControls.Height + 16dip

	' -
	' Card 2: Dynamic Section Showcase (Changes on rail selection)
	' -
	Select Case currentSection
		Case "analytics"
			y = AddAnalyticsSection(contentLeft, y, maxW)
		Case "messages"
			y = AddMessagesSection(contentLeft, y, maxW)
		Case "settings"
			y = AddSettingsSection(contentLeft, y, maxW)
		Case Else ' "home", "calendar", "team"
			y = AddDashboardSection(contentLeft, y, maxW)
	End Select

	' -
	' Card 3: Performance & Architecture Highlights
	' -
	Dim cardFeatures As B4XDaisyCard
	cardFeatures.Initialize(Me, "cardFeatures")
	Dim vFeatures As B4XView = cardFeatures.AddToParent(pnlContent, contentLeft, y, maxW, 0)
	cardFeatures.Title = "Zero-Allocation Architecture"
	cardFeatures.Style = "border"
	cardFeatures.Shadow = "sm"
	cardFeatures.LayoutMode = "none"

	Dim bodyFeatures As B4XView = cardFeatures.BodyContainer
	bodyFeatures.RemoveAllViews
	Dim fy As Int = 0
	Dim fw As Int = maxW - 48dip

	Dim txtFeatures As B4XDaisyText
	txtFeatures.Initialize(Me, "")
	txtFeatures.AddToParent(bodyFeatures, 0, fy, fw, 0)
	txtFeatures.Text = "- Zero view recreation: Menu items are constructed once" & CRLF & _
		"- Internal RailMode: sideMenu.RailMode handles label visibility & icon centering" & CRLF & _
		"- Dynamic sizing: Adapts to RailWidth (" & RailWidth & ") and ExpandedWidth (" & ExpandedWidth & ")" & CRLF & _
		"- Smooth 60fps sliding via SetSideWidthAnimated" & CRLF & _
		"- Perfectly replicates DaisyUI 5 is-drawer-close:hidden"
	txtFeatures.TextSize = 13
	txtFeatures.TextColor = xui.Color_RGB(71, 85, 105)
	txtFeatures.AutoResize = True

	cardFeatures.Refresh
	y = y + vFeatures.Height + 20dip

	pnlContent.Height = Max(Height, y + PAGE_PAD)
	pageScroll.AutoFit
End Sub

Private Sub AddDashboardSection(Left As Int, Top As Int, Width As Int) As Int
	Dim card As B4XDaisyCard
	card.Initialize(Me, "")
	Dim vCard As B4XView = card.AddToParent(pnlContent, Left, Top, Width, 0)
	card.Title = "Dashboard Overview"
	card.Style = "border"
	card.Shadow = "sm"
	card.LayoutMode = "none"

	Dim body As B4XView = card.BodyContainer
	body.RemoveAllViews
	Dim y As Int = 0
	Dim w As Int = Width - 48dip

	' Quick Stat 1: Total Revenue
	Dim stat1 As B4XDaisyStat
	stat1.Initialize(Me, "")
	stat1.AddToParent(body, 0, y, w, 1dip)
	Dim sItem1 As B4XDaisyStatItem
	sItem1.Initialize(Me, "item1")
	sItem1.Title = "Monthly Revenue"
	sItem1.Value = "$48,290"
	sItem1.Description = "-> 14% higher than last month"
	stat1.AddItem(sItem1)
	stat1.Refresh
	If stat1.ContentWidth > 0 Then stat1.SetLayoutAnimated(0, 0, y, w, stat1.ContentHeight)
	y = y + stat1.ContentHeight + 10dip

	' Quick Stat 2: Active Users
	Dim stat2 As B4XDaisyStat
	stat2.Initialize(Me, "")
	stat2.AddToParent(body, 0, y, w, 1dip)
	Dim sItem2 As B4XDaisyStatItem
	sItem2.Initialize(Me, "item2")
	sItem2.Title = "Active Subscribers"
	sItem2.Value = "12,450"
	sItem2.Description = "-> 82 new users today"
	stat2.AddItem(sItem2)
	stat2.Refresh
	If stat2.ContentWidth > 0 Then stat2.SetLayoutAnimated(0, 0, y, w, stat2.ContentHeight)
	y = y + stat2.ContentHeight + 12dip

	card.Refresh
	Return Top + vCard.Height + 16dip
End Sub

Private Sub AddAnalyticsSection(Left As Int, Top As Int, Width As Int) As Int
	Dim card As B4XDaisyCard
	card.Initialize(Me, "")
	Dim vCard As B4XView = card.AddToParent(pnlContent, Left, Top, Width, 0)
	card.Title = "Analytics & Performance"
	card.Style = "border"
	card.Shadow = "sm"
	card.LayoutMode = "none"

	Dim body As B4XView = card.BodyContainer
	body.RemoveAllViews
	Dim y As Int = 0
	Dim w As Int = Width - 48dip

	Dim txt As B4XDaisyText
	txt.Initialize(Me, "")
	txt.AddToParent(body, 0, y, w, 0)
	txt.Text = "System Traffic & Resource Utilization"
	txt.TextSize = 14
	txt.FontBold = True
	y = y + txt.GetComputedHeight + 8dip

	Dim prog1 As B4XDaisyProgress
	prog1.Initialize(Me, "")
	prog1.AddToParent(body, 0, y, w, 12dip)
	prog1.Value = 76
	prog1.Variant = "primary"
	y = y + 20dip

	Dim statA As B4XDaisyStat
	statA.Initialize(Me, "")
	statA.AddToParent(body, 0, y, w, 1dip)
	Dim itemA As B4XDaisyStatItem
	itemA.Initialize(Me, "itemA")
	itemA.Title = "Server Uptime"
	itemA.Value = "99.98%"
	itemA.Description = "Zero downtime recorded this week"
	statA.AddItem(itemA)
	statA.Refresh
	If statA.ContentWidth > 0 Then statA.SetLayoutAnimated(0, 0, y, w, statA.ContentHeight)
	y = y + statA.ContentHeight + 10dip

	card.Refresh
	Return Top + vCard.Height + 16dip
End Sub

Private Sub AddMessagesSection(Left As Int, Top As Int, Width As Int) As Int
	Dim card As B4XDaisyCard
	card.Initialize(Me, "")
	Dim vCard As B4XView = card.AddToParent(pnlContent, Left, Top, Width, 0)
	card.Title = "Direct Messages"
	card.Style = "border"
	card.Shadow = "sm"
	card.LayoutMode = "none"

	Dim body As B4XView = card.BodyContainer
	body.RemoveAllViews
	Dim y As Int = 0
	Dim w As Int = Width - 48dip

	Dim txtMsg As B4XDaisyText
	txtMsg.Initialize(Me, "")
	txtMsg.AddToParent(body, 0, y, w, 0)
	txtMsg.Text = "- Sarah Connor: 'The deployment pipeline passed all tests.'" & CRLF & CRLF & _
		"- Marcus Vance: 'Updated the rail navigation icon assets.'" & CRLF & CRLF & _
		"- Anna Smith: 'Ready for the release review today.'"
	txtMsg.TextSize = 13
	txtMsg.TextColor = xui.Color_RGB(71, 85, 105)
	txtMsg.AutoResize = True

	card.Refresh
	Return Top + vCard.Height + 16dip
End Sub

Private Sub AddSettingsSection(Left As Int, Top As Int, Width As Int) As Int
	Dim card As B4XDaisyCard
	card.Initialize(Me, "")
	Dim vCard As B4XView = card.AddToParent(pnlContent, Left, Top, Width, 0)
	card.Title = "Application Settings"
	card.Style = "border"
	card.Shadow = "sm"
	card.LayoutMode = "none"

	Dim body As B4XView = card.BodyContainer
	body.RemoveAllViews
	Dim y As Int = 0
	Dim w As Int = Width - 48dip

	Dim txtSet As B4XDaisyText
	txtSet.Initialize(Me, "")
	txtSet.AddToParent(body, 0, y, w, 0)
	txtSet.Text = "Configure responsive drawer behavior and theme tokens."
	txtSet.TextSize = 13
	txtSet.TextColor = xui.Color_RGB(71, 85, 105)
	txtSet.AutoResize = True
	y = y + txtSet.GetComputedHeight + 14dip

	Dim tog1 As B4XDaisyToggle
	tog1.Initialize(Me, "togAutoCollapse")
	tog1.AddToParent(body, 0, y, w, 36dip)
	tog1.Text = "Auto-Collapse on Select"
	tog1.Checked = True
	tog1.Variant = "primary"
	y = y + 42dip

	Dim tog2 As B4XDaisyToggle
	tog2.Initialize(Me, "togSmoothAnim")
	tog2.AddToParent(body, 0, y, w, 36dip)
	tog2.Text = "Smooth Animation"
	tog2.Checked = True
	tog2.Variant = "secondary"
	y = y + 42dip

	card.Refresh
	Return Top + vCard.Height + 16dip
End Sub
#End Region

#Region Interactive Events
' Toggle between mini-rail and full sidebar
Private Sub btnToggleRail_Click
	ToggleRailState
End Sub

' Hamburger in Top Navbar toggles rail state
Private Sub topNavbar_Opened
	If isRailCollapsed Then ToggleRailState
End Sub

Private Sub topNavbar_Closed
	If isRailCollapsed = False Then ToggleRailState
End Sub

Private Sub topNavbar_HamburgerClick
	ToggleRailState
End Sub

Private Sub ToggleRailState
	isRailCollapsed = Not(isRailCollapsed)
	
	' 1. Setting IsCollapsed on mainDrawer smoothly animates sidebar width to CollapseWidth (or NormalWidth)
	mainDrawer.setIsCollapsed(isRailCollapsed)
	
	' 2. Internal menu RailMode handles label hiding, icon centering, and right border
	Dim targetWidth As Int = IIf(isRailCollapsed, _
		B4XDaisyVariants.ResolveSizeSpec(mainDrawer.CollapseWidth, Root.Width, 60dip), _
		B4XDaisyVariants.ResolveSizeSpec(mainDrawer.NormalWidth, Root.Width, 240dip))
	sideMenu.SetLayoutAnimated(0, 0, 0, targetWidth, Root.Height)
	sideMenu.setRailMode(isRailCollapsed, targetWidth)

	If topNavbar.IsInitialized Then
		topNavbar.HamburgerChecked = Not(isRailCollapsed)
		topNavbar.BringToFront
	End If
End Sub

' Toggle between persistent split layout and slide-over overlay mode
Private Sub btnToggleDock_Click
	isDockedSplit = Not(isDockedSplit)
	mainDrawer.setAlwaysOpen(isDockedSplit)
	
	If isDockedSplit = False Then
		mainDrawer.Open
	End If

	' Re-render layout
	B4XPage_Resize(Root.Width, Root.Height)
End Sub

' Sidebar navigation item click handler
Private Sub sideMenu_ItemClick (Tag As Object, Text As String)
	Dim selectedTag As String = Tag
	currentSection = selectedTag
	
	' If in slide-over overlay mode, close drawer upon selection
	If isDockedSplit = False Then
		mainDrawer.Close
	Else
		' If expanded in docked rail mode, close drawer to collapsed rail width upon item selection
		If isRailCollapsed = False Then
			ToggleRailState
		End If
	End If

	' Update sidebar active indicator
	sideMenu.SetItemActive(currentSection, True)

	' Update center page title and content
	If topNavbar.IsInitialized Then
		topNavbar.Title = "Mini-Rail: " & currentSection.ToUpperCase
		topNavbar.BringToFront
	End If

	Dim contentH As Int = Max(1dip, Root.Height - NAVBAR_HEIGHT)
	PopulateCenterContent(mainDrawer.CenterPanel.Width, contentH)

	#If B4A
	ToastMessageShow("Navigated to " & Text, False)
	#End If
End Sub
#End Region

#Region Base Lifecycle
Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If mainDrawer.IsInitialized Then
		mainDrawer.Resize(Width, Height)
	End If
	
	Dim currentSideW As Int = IIf(isRailCollapsed, _
		B4XDaisyVariants.ResolveSizeSpec(mainDrawer.CollapseWidth, Width, 60dip), _
		B4XDaisyVariants.ResolveSizeSpec(mainDrawer.NormalWidth, Width, 240dip))
		
	If sideMenu.IsInitialized Then
		sideMenu.SetLayoutAnimated(0, 0, 0, currentSideW, Height)
		sideMenu.setRailMode(isRailCollapsed, currentSideW)
	End If

	Dim contentH As Int = Max(1dip, Height - NAVBAR_HEIGHT)

	If topNavbar.IsInitialized Then
		topNavbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_HEIGHT)
		topNavbar.BringToFront
	End If
	
	If pageScroll.IsInitialized Then
		pageScroll.SetLayoutAnimated(0, 0, NAVBAR_HEIGHT, Width, contentH)
		PopulateCenterContent(Width, contentH)
	End If
End Sub
#End Region
