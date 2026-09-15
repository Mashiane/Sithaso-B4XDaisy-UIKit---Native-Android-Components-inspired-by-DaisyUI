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
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
	B4XPages.SetTitle(Me, "Drawer")

	RenderFullPageDrawer(Root.Width, Root.Height)
End Sub
#End Region

#Region Layout & Rendering
Private Sub RenderFullPageDrawer(Width As Int, Height As Int)
	Root.RemoveAllViews

	' -
	' 1. FULLSCREEN ROOT DRAWER (Left side only, AlwaysOpen = False by default)
	' -
	mainDrawer.Initialize(Me, "mainDrawer")
	mainDrawer.AddToParent(Root, 0, 0, Width, Height)

	' -
	' 2. LEFT SIDEBAR MENU (Inside mainDrawer.LeftPanel)
	' -
	BuildLeftSidebar(mainDrawer.LeftPanel, SIDEBAR_WIDTH, Height)

	' -
	' 3. TOP NAVBAR (Inside mainDrawer.CenterPanel)
	' -
	topNavbar.Initialize(Me, "topNavbar")
	topNavbar.AddToParent(mainDrawer.CenterPanel, 0, 0, Width, NAVBAR_HEIGHT)
	topNavbar.Variant = "base-100"
	topNavbar.Shadow = "sm"
	topNavbar.Title = "DaisyUI Drawer"
	topNavbar.TitlePosition = "center"

	' Enable built-in Hamburger menu button (Toggles the drawer)
	topNavbar.HamburgerVisible = True

	' -
	' 4. CENTER DAISYUI PAGE SCROLL CONTAINER
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

	' --- Card 1: Interactive Drawer Controls ---
	Dim cardControls As B4XDaisyCard
	cardControls.Initialize(Me, "cardControls")
	Dim vControls As B4XView = cardControls.AddToParent(pnlContent, contentLeft, y, maxW, 0)
	cardControls.Title = "Drawer Controls"
	cardControls.Style = "border"
	cardControls.Shadow = "sm"
	cardControls.LayoutMode = "none"

	cardControls.CardBody.RemoveAllViews

	Dim descTxt As B4XDaisyText
	descTxt.Initialize(Me, "")
	descTxt.AddToParent(cardControls.CardBody, 0, 0, maxW - 48dip, 0)
	descTxt.Text = "Tap the button below or the navbar hamburger icon to toggle the full navigation drawer."
	descTxt.TextSize = 13
	descTxt.TextColor = xui.Color_RGB(71, 85, 105)
	descTxt.AutoResize = True

	btnToggleDrawer.Initialize(Me, "btnToggleDrawer")
	btnToggleDrawer.Text = "=  Toggle Drawer"
	btnToggleDrawer.Variant = "primary"
	btnToggleDrawer.Size = "md"
	cardControls.AddAction(btnToggleDrawer)

	cardControls.Refresh
	y = y + vControls.Height + 14dip

	' --- Card 2: Live Features Info ---
	Dim cardInfo As B4XDaisyCard
	cardInfo.Initialize(Me, "cardInfo")
	Dim vInfo As B4XView = cardInfo.AddToParent(pnlContent, contentLeft, y, maxW, 0)
	cardInfo.Title = "Drawer Features"
	cardInfo.Style = "border"
	cardInfo.Shadow = "sm"
	cardInfo.LayoutMode = "none"

	cardInfo.CardBody.RemoveAllViews

	Dim featuresTxt As B4XDaisyText
	featuresTxt.Initialize(Me, "")
	featuresTxt.AddToParent(cardInfo.CardBody, 0, 0, maxW - 48dip, 0)
	featuresTxt.Text = "- Left panel contains daisyUI component catalog" & CRLF & _
	                    "- Full-height smooth internal scrolling" & CRLF & _
	                    "- Swipe from left screen edge to drag open" & CRLF & _
	                    "- Smooth fade and slide animation on backdrop tap"
	featuresTxt.TextSize = 13
	featuresTxt.TextColor = xui.Color_RGB(71, 85, 105)
	featuresTxt.AutoResize = True

	cardInfo.Refresh
	y = y + vInfo.Height + 14dip

	' Trigger AutoFit calculation on pageScroll
	pageScroll.AutoFit
End Sub

' -
' SIDEBAR BUILDER (Menu only, full height)
' -
Private Sub BuildLeftSidebar(SidePanel As B4XView, Width As Int, Height As Int)
	SidePanel.RemoveAllViews

	sideMenu.Initialize(Me, "sideMenu")
	sideMenu.AutoResize = False
	sideMenu.Dividers = False
	sideMenu.Padding = "p-3"
	sideMenu.BeginUpdate

	' --- Actions ---
	sideMenu.AddTitle("Actions")
	sideMenu.AddItem("button", "Button")
	sideMenu.AddItem("dropdown", "Dropdown")
	sideMenu.AddItem("modal", "Modal")
	sideMenu.AddItem("swap", "Swap")
	sideMenu.AddItem("theme-controller", "Theme Controller")

	' --- Data Display ---
	sideMenu.AddTitle("Data display")
	sideMenu.AddItem("accordion", "Accordion")
	sideMenu.AddItem("avatar", "Avatar")
	sideMenu.AddBadgeItem("badge", "Badge", "New", "primary")
	sideMenu.AddItem("card", "Card")
	sideMenu.AddItem("carousel", "Carousel")
	sideMenu.AddItem("chat-bubble", "Chat bubble")
	sideMenu.AddItem("collapse", "Collapse")
	sideMenu.AddItem("countdown", "Countdown")
	sideMenu.AddItem("diff", "Diff")
	sideMenu.AddItem("kbd", "Kbd")
	sideMenu.AddItem("stat", "Stat")
	sideMenu.AddItem("table", "Table")
	sideMenu.AddItem("timeline", "Timeline")

	' --- Data Input ---
	sideMenu.AddTitle("Data input")
	sideMenu.AddItem("checkbox", "Checkbox")
	sideMenu.AddItem("file-input", "File input")
	sideMenu.AddItem("radio", "Radio")
	sideMenu.AddItem("range", "Range")
	sideMenu.AddItem("dualrange", "Dual Range")
	sideMenu.AddItem("rating", "Rating")
	sideMenu.AddItem("select", "Select")
	sideMenu.AddItem("text-input", "Text input")
	sideMenu.AddItem("textarea", "Textarea")
	sideMenu.AddItem("toggle", "Toggle")

	' --- Layout ---
	sideMenu.AddTitle("Layout")
	sideMenu.AddItem("artboard", "Artboard")
	sideMenu.AddItem("divider", "Divider")
	sideMenu.AddItem("drawer", "Drawer")
	sideMenu.SetItemActive("drawer", True)
	sideMenu.AddItem("drawerrail", "Drawer (Mini-Rail)")
	sideMenu.AddItem("drawertree", "Drawer (Tree)")
	sideMenu.AddItem("footer", "Footer")
	sideMenu.AddItem("hero", "Hero")
	sideMenu.AddItem("indicator", "Indicator")
	sideMenu.AddItem("join", "Join")
	sideMenu.AddItem("mask", "Mask")
	sideMenu.AddItem("stack", "Stack")

	' --- Navigation ---
	sideMenu.AddTitle("Navigation")
	sideMenu.AddItem("breadcrumbs", "Breadcrumbs")
	sideMenu.AddItem("bottom-navigation", "Bottom navigation")
	sideMenu.AddItem("link", "Link")
	sideMenu.AddItem("menu", "Menu")
	sideMenu.AddItem("navbar", "Navbar")
	sideMenu.AddItem("pagination", "Pagination")
	sideMenu.AddItem("steps", "Steps")
	sideMenu.AddItem("tab", "Tab")

	' --- Feedback ---
	sideMenu.AddTitle("Feedback")
	sideMenu.AddItem("alert", "Alert")
	sideMenu.AddItem("loading", "Loading")
	sideMenu.AddItem("progress", "Progress")
	sideMenu.AddItem("radial-progress", "Radial progress")
	sideMenu.AddItem("skeleton", "Skeleton")
	sideMenu.AddItem("toast", "Toast")
	sideMenu.AddItem("tooltip", "Tooltip")

	' --- Mockup ---
	sideMenu.AddTitle("Mockup")
	sideMenu.AddItem("browser", "Browser")
	sideMenu.AddItem("code", "Code")
	sideMenu.AddItem("phone", "Phone")
	sideMenu.AddItem("window", "Window")
	sideMenu.EndUpdate

	sideMenu.AddToParent(SidePanel, 0, 0, Width, Height)
End Sub
#End Region

#Region Events & Navigation
' Built-in Hamburger toggle events from topNavbar
Private Sub topNavbar_Opened
	mainDrawer.Open
End Sub

Private Sub topNavbar_Closed
	mainDrawer.Close
End Sub

Private Sub btnToggleDrawer_Click
	mainDrawer.Toggle
End Sub

Private Sub sideMenu_ItemClick (Tag As Object, Text As String)
	mainDrawer.Close
	#If B4A
	ToastMessageShow("Selected: " & Text, False)
	#End If
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
