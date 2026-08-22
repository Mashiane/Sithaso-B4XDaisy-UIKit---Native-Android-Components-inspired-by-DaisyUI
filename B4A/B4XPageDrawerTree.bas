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
	
	' Page-level Fullscreen Drawer
	Private mainDrawer As B4XDaisyDrawer
	Private topNavbar As B4XDaisyNavbar
	Private sideMenu As B4XDaisyMenu
	
	' Standard DaisyUI Scroll Container
	Private pageScroll As B4XDaisyPageScroll
	Private pnlContent As B4XView
	
	' Dimension Tokens
	Private NAVBAR_HEIGHT As Int = 56dip
	Private SIDEBAR_WIDTH As Int = 300dip
	Private PAGE_PAD As Int = 14dip
	
	' Interactive controls
	Private btnToggleDrawer As B4XDaisyButton
	Private btnExpandAll As B4XDaisyButton
	Private btnCollapseAll As B4XDaisyButton
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
	B4XPages.SetTitle(Me, "Tree Drawer")

	RenderFullPageDrawer(Root.Width, Root.Height)
End Sub
#End Region

#Region Layout & Rendering
Private Sub RenderFullPageDrawer(Width As Int, Height As Int)
	Root.RemoveAllViews

	' -
	' 1. FULLSCREEN ROOT DRAWER
	' -
	mainDrawer.Initialize(Me, "mainDrawer")
	mainDrawer.AddToParent(Root, 0, 0, Width, Height)

	' -
	' 2. LEFT SIDEBAR TREE MENU (Inside mainDrawer.LeftPanel)
	' -
	BuildLeftTreeSidebar(mainDrawer.LeftPanel, SIDEBAR_WIDTH, Height)

	' -
	' 3. TOP NAVBAR (Inside mainDrawer.CenterPanel)
	' -
	topNavbar.Initialize(Me, "topNavbar")
	topNavbar.AddToParent(mainDrawer.CenterPanel, 0, 0, Width, NAVBAR_HEIGHT)
	topNavbar.Variant = "base-100"
	topNavbar.Shadow = "sm"
	topNavbar.Title = "DaisyUI Tree Drawer"
	topNavbar.TitlePosition = "center"
	topNavbar.HamburgerVisible = True

	' -
	' 4. CENTER SCROLL CONTAINER
	' -
	Dim contentH As Int = Max(1dip, Height - NAVBAR_HEIGHT)
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(mainDrawer.CenterPanel, 0, NAVBAR_HEIGHT, Width, contentH)
	pageScroll.Transparent = True
	pnlContent = pageScroll.Panel

	PopulateCenterContent(Width, contentH)
End Sub

Private Sub PopulateCenterContent(Width As Int, Height As Int)
	pnlContent.RemoveAllViews

	Dim maxW As Int = Min(Width - (PAGE_PAD * 2), 540dip)
	Dim contentLeft As Int = Max(PAGE_PAD, (Width - maxW) / 2)
	Dim y As Int = PAGE_PAD

	' --- Card 1: Interactive Tree Drawer Controls ---
	Dim cardControls As B4XDaisyCard
	cardControls.Initialize(Me, "cardControls")
	Dim vControls As B4XView = cardControls.AddToParent(pnlContent, contentLeft, y, maxW, 0)
	cardControls.Title = "Tree Drawer Controls"
	cardControls.Style = "border"
	cardControls.Shadow = "sm"
	cardControls.LayoutMode = "none"

	Dim cardBody As B4XView = cardControls.BodyContainer
	cardBody.RemoveAllViews
	Dim innerY As Int = 0
	Dim innerW As Int = maxW - 48dip
	Dim innerLeft As Int = 0

	Dim descText As B4XDaisyText
	descText.Initialize(Me, "")
	descText.AddToParent(cardBody, innerLeft, innerY, innerW, 0)
	descText.Text = "This drawer uses a hierarchical tree menu with parent categories and rounded component avatar previews for every child item."
	descText.TextSize = 13
	descText.TextColor = xui.Color_RGB(100, 116, 139)
	descText.SingleLine = False
	innerY = innerY + descText.GetComputedHeight + 14dip

	' Button Row 1: Toggle & Collapse
	Dim btnW As Int = (innerW - 10dip) / 2
	btnToggleDrawer.Initialize(Me, "btnToggleDrawer")
	btnToggleDrawer.AddToParent(cardBody, innerLeft, innerY, btnW, 40dip)
	btnToggleDrawer.Text = "Toggle Drawer"
	btnToggleDrawer.Variant = "primary"

	btnCollapseAll.Initialize(Me, "btnCollapseAll")
	btnCollapseAll.AddToParent(cardBody, innerLeft + btnW + 10dip, innerY, btnW, 40dip)
	btnCollapseAll.Text = "Collapse All"
	btnCollapseAll.Variant = "neutral"
	innerY = innerY + 46dip

	' Button Row 2: Expand All
	btnExpandAll.Initialize(Me, "btnExpandAll")
	btnExpandAll.AddToParent(cardBody, innerLeft, innerY, innerW, 40dip)
	btnExpandAll.Text = "Expand All Categories"
	btnExpandAll.Variant = "secondary"
	innerY = innerY + 48dip

	' Status Label
	Dim lbl As Label
	lbl.Initialize("")
	lbl.Text = "Ready - Open drawer or tap a tree item"
	lbl.TextColor = xui.Color_RGB(100, 116, 139)
	lbl.TextSize = 12
	lbl.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(240, 242, 245))
	lblStatus = lbl
	lblStatus.SetTextAlignment("CENTER", "LEFT")
	cardBody.AddView(lblStatus, innerLeft, innerY, innerW, 28dip)
	innerY = innerY + 36dip

	cardControls.Refresh
	y = y + vControls.Height + 16dip

	' --- Card 2: Tree Structure Summary ---
	Dim cardSummary As B4XDaisyCard
	cardSummary.Initialize(Me, "cardSummary")
	Dim vSummary As B4XView = cardSummary.AddToParent(pnlContent, contentLeft, y, maxW, 0)
	cardSummary.Title = "Component Avatar Tree"
	cardSummary.Style = "border"
	cardSummary.Shadow = "sm"
	cardSummary.LayoutMode = "none"

	Dim summaryBody As B4XView = cardSummary.BodyContainer
	summaryBody.RemoveAllViews
	Dim sumY As Int = 0
	Dim sumW As Int = maxW - 48dip

	Dim summaryText As B4XDaisyText
	summaryText.Initialize(Me, "")
	summaryText.AddToParent(summaryBody, 0, sumY, sumW, 0)
	summaryText.Text = "Categories & Preview Avatars:" & CRLF & _
		"- Account (Team avatars)" & CRLF & _
		"- Actions (button, dropdown, modal, swap, theme)" & CRLF & _
		"- Data Display (accordion, avatar, badge, card, etc.)" & CRLF & _
		"- Data Input (checkbox, file-input, radio, range, etc.)" & CRLF & _
		"- Layout (divider, drawer, footer, hero, stack, etc.)" & CRLF & _
		"- Navigation (breadcrumbs, dock, link, menu, navbar, etc.)" & CRLF & _
		"- Feedback (alert, loading, progress, toast, etc.)" & CRLF & _
		"- Mockup (browser, code, phone, window)"
	summaryText.TextSize = 13
	summaryText.TextColor = xui.Color_RGB(71, 85, 105)
	summaryText.SingleLine = False

	cardSummary.Refresh
	y = y + vSummary.Height + 20dip

	pnlContent.Height = Max(Height, y + PAGE_PAD)
End Sub

' -
' SIDEBAR TREE BUILDER (Rounded WebP Avatars for Children)
' -
Private Sub BuildLeftTreeSidebar(SidePanel As B4XView, Width As Int, Height As Int)
	SidePanel.RemoveAllViews

	sideMenu.Initialize(Me, "sideMenu")
	sideMenu.AutoResize = False
	sideMenu.Dividers = True
	sideMenu.DividerGap = "1"
	sideMenu.Padding = "p-3"
	sideMenu.BeginUpdate

	' --- Section 0: Account / Team ---
	sideMenu.AddItemParent("", "cat-account", "Account & Team", "user-group-solid.svg")
	sideMenu.AddAvatarBadgeChildItem("cat-account", "acc-anele", "Anele Mbanga", "mashymain.jpg", "rounded", "Admin", "primary")
	sideMenu.AddAvatarBadgeChildItem("cat-account", "acc-anna", "Anna Smith", "face_anna.jpg", "rounded", "Online", "success")
	sideMenu.AddAvatarChildItem("cat-account", "acc-marcus", "Marcus Vance", "face_marcus.jpg", "rounded")

	' --- Section 1: Actions ---
	sideMenu.AddItemParent("", "cat-actions", "Actions", "bolt-solid.svg")
	sideMenu.AddAvatarChildItem("cat-actions", "button", "Button", "button.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-actions", "dropdown", "Dropdown", "dropdown.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-actions", "modal", "Modal", "modal.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-actions", "swap", "Swap", "swap.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-actions", "theme-controller", "Theme Controller", "theme-controller.webp", "rounded")

	' --- Section 2: Data Display ---
	sideMenu.AddItemParent("", "cat-display", "Data Display", "table-cells-solid.svg")
	sideMenu.AddAvatarChildItem("cat-display", "accordion", "Accordion", "accordion.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "avatar", "Avatar", "avatar.webp", "rounded")
	sideMenu.AddAvatarBadgeChildItem("cat-display", "badge", "Badge", "badge.webp", "rounded", "New", "primary")
	sideMenu.AddAvatarChildItem("cat-display", "card", "Card", "card.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "carousel", "Carousel", "carousel.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "chat-bubble", "Chat bubble", "chat.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "collapse", "Collapse", "collapse.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "countdown", "Countdown", "countdown.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "diff", "Diff", "diff.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "kbd", "Kbd", "kbd.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "stat", "Stat", "stat.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "table", "Table", "table.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-display", "timeline", "Timeline", "timeline.webp", "rounded")

	' --- Section 3: Data Input ---
	sideMenu.AddItemParent("", "cat-input", "Data Input", "pen-to-square-solid.svg")
	sideMenu.AddAvatarChildItem("cat-input", "checkbox", "Checkbox", "checkbox.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "file-input", "File input", "file-input.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "radio", "Radio", "radio.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "range", "Range", "range.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "dualrange", "Dual Range", "range.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "rating", "Rating", "rating.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "select", "Select", "select.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "text-input", "Text input", "input.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "textarea", "Textarea", "textarea.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-input", "toggle", "Toggle", "toggle.webp", "rounded")

	' --- Section 4: Layout ---
	sideMenu.AddItemParent("", "cat-layout", "Layout", "layer-group-solid.svg")
	sideMenu.AddAvatarChildItem("cat-layout", "divider", "Divider", "divider.webp", "rounded")
	sideMenu.AddAvatarBadgeChildItem("cat-layout", "drawer-tree", "Tree Drawer", "drawer.webp", "rounded", "Active", "success")
	sideMenu.AddAvatarChildItem("cat-layout", "footer", "Footer", "footer.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-layout", "hero", "Hero", "hero.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-layout", "indicator", "Indicator", "indicator.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-layout", "join", "Join", "join.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-layout", "mask", "Mask", "mask.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-layout", "stack", "Stack", "stack.webp", "rounded")

	' --- Section 5: Navigation ---
	sideMenu.AddItemParent("", "cat-nav", "Navigation", "compass-solid.svg")
	sideMenu.AddAvatarChildItem("cat-nav", "breadcrumbs", "Breadcrumbs", "breadcrumbs.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "dock", "Dock Navigation", "dock.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "link", "Link", "link.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "menu", "Menu", "menu.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "navbar", "Navbar", "navbar.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "pagination", "Pagination", "pagination.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "steps", "Steps", "steps.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-nav", "tab", "Tab", "tab.webp", "rounded")

	' --- Section 6: Feedback ---
	sideMenu.AddItemParent("", "cat-feedback", "Feedback", "circle-info-solid.svg")
	sideMenu.AddAvatarChildItem("cat-feedback", "alert", "Alert", "alert.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-feedback", "loading", "Loading", "loading.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-feedback", "progress", "Progress", "progress.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-feedback", "radial-progress", "Radial progress", "radial-progress.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-feedback", "skeleton", "Skeleton", "skeleton.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-feedback", "toast", "Toast", "toast.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-feedback", "tooltip", "Tooltip", "tooltip.webp", "rounded")

	' --- Section 7: Mockup ---
	sideMenu.AddItemParent("", "cat-mockup", "Mockup", "laptop-solid.svg")
	sideMenu.AddAvatarChildItem("cat-mockup", "browser", "Browser", "mockup-browser.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-mockup", "code", "Code", "mockup-code.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-mockup", "phone", "Phone", "mockup-phone.webp", "rounded")
	sideMenu.AddAvatarChildItem("cat-mockup", "window", "Window", "mockup-window.webp", "rounded")

	' Auto-expand Layout category by default
	sideMenu.SetItemOpen("cat-layout", True)
	sideMenu.SetItemActive("drawer-tree", True)
	sideMenu.EndUpdate

	sideMenu.AddToParent(SidePanel, 0, 0, Width, Height)
End Sub
#End Region

#Region Events & Navigation
Private Sub topNavbar_Opened
	mainDrawer.Open
End Sub

Private Sub topNavbar_Closed
	mainDrawer.Close
End Sub

Private Sub btnToggleDrawer_Click
	mainDrawer.Toggle
End Sub

Private Sub btnCollapseAll_Click
	sideMenu.CloseParents
	UpdateStatus("Collapsed all categories")
End Sub

Private Sub btnExpandAll_Click
	sideMenu.OpenParents
	UpdateStatus("Expanded all categories")
End Sub

Private Sub sideMenu_ItemClick (Tag As Object, Text As String)
	Dim tagStr As String = Tag
	If tagStr.StartsWith("cat-") Then
		UpdateStatus("Toggled category: " & Text)
		Return
	End If
	
	mainDrawer.Close
	UpdateStatus("Selected item: " & Text & " (" & Tag & ")")
	#If B4A
	ToastMessageShow("Tree Item: " & Text, False)
	#End If
End Sub

Private Sub UpdateStatus(Msg As String)
	If lblStatus.IsInitialized Then
		lblStatus.Text = Msg
	End If
End Sub

Private Sub mainDrawer_Opened
	If topNavbar.IsInitialized And topNavbar.HamburgerChecked = False Then
		topNavbar.HamburgerChecked = True
	End If
End Sub

Private Sub mainDrawer_Closed
	If topNavbar.IsInitialized And topNavbar.HamburgerChecked = True Then
		topNavbar.HamburgerChecked = False
	End If
End Sub
#End Region

#Region Base Lifecycle
Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If mainDrawer.IsInitialized Then mainDrawer.Resize(Width, Height)
	If topNavbar.IsInitialized Then topNavbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_HEIGHT)
	If pageScroll.IsInitialized Then
		Dim contentH As Int = Max(1dip, Height - NAVBAR_HEIGHT)
		pageScroll.SetLayoutAnimated(0, 0, NAVBAR_HEIGHT, Width, contentH)
		PopulateCenterContent(Width, contentH)
	End If
End Sub
#End Region
