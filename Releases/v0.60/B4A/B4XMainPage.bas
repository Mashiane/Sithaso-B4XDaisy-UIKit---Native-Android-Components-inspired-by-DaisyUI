B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region
' LibDownloader: ide://run?file=%JAVABIN%\java.exe&Args=-jar&Args=%ADDITIONAL%\..\B4X\libget-non-ui.jar&Args=%PROJECT%&Args=true
' Export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

'https://github.com/users/Mashiane/projects/1
'https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/

#IgnoreWarnings:12
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private PendingDashboardOnReopen As Boolean
	Public ChatPage As B4XPageChat
	Public AlertPage As B4XPageAlert
	Public AvatarPage As B4XPageAvatar
	Public BadgePage As B4XPageBadge
	Public CardPage As B4XPageCard
	Public KbdPage As B4XPageKbd
	Public DividerPage As B4XPageDivider
	Public IndicatorPage As B4XPageIndicator
	Public StatusPage As B4XPageStatus
	Public LoadingPage As B4XPageLoading
	Public MaskPage As B4XPageMask
	Public StackPage As B4XPageStack
	Public SvgIconPage As B4XPageSvgIcon
	Public SwapPage As B4XPageSwap
	Public RadialProgressPage As B4XPageRadialProgress
	Public ProgressPage As B4XPageProgress
	Public DashboardPage As B4XPageDashboard
	Public ToastPage As B4XPageToast
	Public TooltipPage As B4XPageTooltip
	Public NavbarPage As B4XPageNavbar
	Private WindowPage As B4XPageWindow
	Private B4XGifView1 As B4XGifView
	Private FieldSetPage As B4XPageFieldset
	Public ButtonPage As B4XPageButton
	Public HeroPage As B4XPageHero
	Public SkeletonPage As B4XPageSkeleton
	Public StatPage As B4XPageStat
	Public CarouselPage As B4XPageCarousel
	Public OverlayPage As B4XPageOverlay
	Public CollapsePage As B4XPageCollapse
	Public AccordionPage As B4XPageAccordion
	Public CountdownPage As B4XPageCountdown
	Public DiffPage As B4XPageDiff
	Public ListPage As B4XPageList
	Public CanvasSpinner As B4XPageCanvasSpinner
	Public TextRotatePage As B4XPageTextRotate
	Public TimelinePage As B4XPageTimeline
	Public Hover3dPage As B4XPageHover3d
	Private AppOverlay As B4XDaisyOverlay
	Private AppLoader As B4XDaisyCanvasSpinner
	Public FabPage As B4XPageFab
	Public FabBasicPage As B4XPageFabBasic
	Public FabNavbarPage As B4XPageFabNavbar
	Public FabFlowerPage As B4XPageFabFlower
	Public MenuPage As B4XPageMenu
	Public MenuRuntimePage As B4XPageMenuRuntime
	Public MenuRuntime2Page As B4XPageMenuRuntime2
	Public DropdownPage As B4XPageDropdown
	Public ModalPage As B4XPageModal
	Public LinkPage As B4XPageLink
	Public BreadcrumbsPage As B4XPageBreadcrumbs
	Public DockPage As B4XPageDock
	Public PaginationPage As B4XPagePagination
	Public StepsPage As B4XPageSteps
	Public TabPage As B4XPageTab
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
	B4XPages.GetManager.TransitionAnimationDuration = 0
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1	
	PendingDashboardOnReopen = False
	'show the splash screen
	Root.LoadLayout("Splash")
	B4XGifView1.SetGif(File.DirAssets, "jendigitalart-cat-133_256.gif")
	Sleep(0)
	'load the other pages
	Wait For (ShowSplashScreen) Complete (Unused As Boolean)
	
	' Initialize global loader after initial layout is loaded - avoids interference
	AppOverlay.Initialize(Me, "AppOverlay")
	AppOverlay.OverlayColor = xui.Color_White
	AppOverlay.Opacity = 0
	If Root.Parent.IsInitialized Then
		AppOverlay.AttachTo(Root.Parent)
		AppOverlay.Visible = False
		
		AppLoader.Initialize(Me, "AppLoader")
		AppLoader.AttachTo(AppOverlay.GetHostView)
		AppLoader.Hide
	End If
	
	
'	Root.RemoveAllViews
	B4XPages.SetTitle(Me, "B4XDaisy UIKit")
	B4XPages.ShowPage("Dashboard")
End Sub

Private Sub B4XPage_Appear
	If PendingDashboardOnReopen Then
		PendingDashboardOnReopen = False
		B4XPages.ShowPage("Dashboard")
	End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If AppOverlay.IsInitialized Then AppOverlay.Resize(Width, Height)
	If AppLoader.IsInitialized Then AppLoader.Resize(Width, Height)
End Sub

Sub ShowSplashScreen As ResumableSub
	#If B4i
	Main.NavControl.NavigationBarVisible = False
	#End If	
	'
	ChatPage.Initialize
	AlertPage.Initialize
	AvatarPage.Initialize
	BadgePage.Initialize
	CardPage.Initialize
	KbdPage.Initialize
	DividerPage.Initialize
	IndicatorPage.Initialize
	StatusPage.Initialize
	LoadingPage.Initialize
	MaskPage.Initialize
	StackPage.Initialize
	SvgIconPage.Initialize
	SwapPage.Initialize
	RadialProgressPage.Initialize
	ProgressPage.Initialize
	ButtonPage.Initialize
	HeroPage.Initialize
	CarouselPage.Initialize
	OverlayPage.Initialize
	CollapsePage.Initialize
	AccordionPage.Initialize
	CountdownPage.Initialize
	DiffPage.Initialize
	ListPage.Initialize
	SkeletonPage.Initialize
	StatPage.Initialize
	FabPage.Initialize
	FabBasicPage.Initialize
	FabNavbarPage.Initialize
	FabFlowerPage.Initialize
	MenuPage.Initialize
	MenuRuntimePage.Initialize
	MenuRuntime2Page.Initialize
	DropdownPage.Initialize
	ModalPage.Initialize
	LinkPage.Initialize
	BreadcrumbsPage.Initialize
	DockPage.Initialize
	PaginationPage.Initialize
	StepsPage.Initialize
	TabPage.Initialize
	DashboardPage.Initialize
	ToastPage.Initialize
	TooltipPage.Initialize
	NavbarPage.Initialize
	WindowPage.Initialize
	FieldSetPage.Initialize 
	CanvasSpinner.Initialize
	TextRotatePage.Initialize
	TimelinePage.Initialize
	Hover3dPage.Initialize
	
	B4XPages.AddPage("Stat", StatPage)
	B4XPages.AddPage("Chat", ChatPage)
	B4XPages.AddPage("Alert", AlertPage)
	B4XPages.AddPage("Avatar", AvatarPage)
	B4XPages.AddPage("Badge", BadgePage)
	B4XPages.AddPage("Card", CardPage)
	B4XPages.AddPage("Tab", TabPage)
	B4XPages.AddPage("Steps", StepsPage)
	B4XPages.AddPage("Dock", DockPage)
	B4XPages.AddPage("Pagination", PaginationPage)
	B4XPages.AddPage("Breadcrumbs", BreadcrumbsPage)
	B4XPages.AddPage("Link", LinkPage)
	B4XPages.AddPage("Modal", ModalPage)
	B4XPages.AddPage("Dropdown", DropdownPage)
	B4XPages.AddPage("Menu", MenuPage)
	B4XPages.AddPage("Menu Runtime", MenuRuntimePage)
	B4XPages.AddPage("Menu Runtime 2", MenuRuntime2Page)
	B4XPages.AddPage("Fab", FabPage)
	B4XPages.AddPage("Fab Basic", FabBasicPage)
	B4XPages.AddPage("Fab Navbar", FabNavbarPage)
	B4XPages.AddPage("Fab Flower", FabFlowerPage)
	B4XPages.AddPage("Diff", DiffPage)
	B4XPages.AddPage("List", ListPage)
	B4XPages.AddPage("Dashboard", DashboardPage)
	B4XPages.AddPage("Skeleton", SkeletonPage)
	B4XPages.AddPage("Hero", HeroPage)
	B4XPages.AddPage("Button", ButtonPage)
	B4XPages.AddPage("Kbd", KbdPage)
	B4XPages.AddPage("Divider", DividerPage)
	B4XPages.AddPage("Indicator", IndicatorPage)
	B4XPages.AddPage("Status", StatusPage)
	B4XPages.AddPage("Loading", LoadingPage)
	B4XPages.AddPage("Mask", MaskPage)
	B4XPages.AddPage("Stack", StackPage)
	B4XPages.AddPage("SVG Icon", SvgIconPage)
	B4XPages.AddPage("Swap", SwapPage)
	B4XPages.AddPage("Radial Progress", RadialProgressPage)
	B4XPages.AddPage("Progress", ProgressPage)
	B4XPages.AddPage("Toast", ToastPage)
	B4XPages.AddPage("Tooltip", TooltipPage)
	B4XPages.AddPage("Navbar", NavbarPage)
	B4XPages.AddPage("Window", WindowPage)
	B4XPages.AddPage("FieldSet", FieldSetPage)
	B4XPages.AddPage("Carousel", CarouselPage)
	B4XPages.AddPage("Overlay", OverlayPage)
	B4XPages.AddPage("Collapse", CollapsePage)
	B4XPages.AddPage("Accordion", AccordionPage)
	B4XPages.AddPage("Countdown", CountdownPage)
	B4XPages.AddPage("CanvasSpinner", CanvasSpinner)
	B4XPages.AddPage("TextRotate", TextRotatePage)
	B4XPages.AddPage("Timeline", TimelinePage)
	B4XPages.AddPage("Hover3d", Hover3dPage)
	Return True
End Sub

'Return True to close, False to cancel
Private Sub B4XPage_CloseRequest As ResumableSub
	Dim sf As Object = xui.Msgbox2Async("Are you sure you want to close the application?", "Close B4XDaisy UI Kit?", "Yes", "", "No", Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		PendingDashboardOnReopen = True
		Return True
	End If
	B4XPages.ShowPage("Dashboard")
	Return False
End Sub

' /**
'  * Shows the page loader, waits a bit, and then shows the target page.
'  */
public Sub ShowPageWithLoader(PageId As String)
	Try
		AppOverlay.Open
		AppLoader.Show
		AppOverlay.Resize(Root.Width, Root.Height)
		AppLoader.Resize(Root.Width, Root.Height)
		Sleep(500)
		Sleep(0)
		B4XPages.ShowPage(PageId)
		AppOverlay.Open
		AppLoader.Show
		Sleep(0)
	Catch
		Log("ERROR: ShowPageWithLoader crashed: " & LastException.Message)
	End Try
End Sub

Private Sub Page_Ready
	AppLoader.Hide
	AppOverlay.Close
End Sub