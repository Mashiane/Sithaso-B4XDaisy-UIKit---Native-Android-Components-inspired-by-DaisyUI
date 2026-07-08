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
'LibDownloader: ide://run?file=%JAVABIN%\java.exe&Args=-jar&Args=%ADDITIONAL%\..\B4X\libget-non-ui.jar&Args=%PROJECT%&Args=true
'Export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

'https://github.com/users/Mashiane/projects/1
'https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/

#IgnoreWarnings:12,9

Sub Class_Globals
	Public MapFrom As String
	Private Root As B4XView
	Private xui As XUI
	Private PendingDashboardOnReopen As Boolean
	'Public KM01SignInPage As KM01SignIn
	'Public KM01TypeOfUserPage As KM01TypeOfUser
	'Public KM01ClientProfilePage As KM01ClientProfile
	'Public KM01KYCPage As KM01KYC
	'Public KM01NewProfilePage As KM01NewProfile
	'Public KM01CompanyRepresentativePage As KM01CompanyRepresentative
	'Public KM01LocationDetailsPage As KM01LocationDetails
	'Public KM01IDDetailsPage As KM01IDDetails
	'Public KM01CongratulationsPage As KM01Congratulations
	'Public KM01OnboardingPage As KM01Onboarding
	'Public KM01LeafletMapPage As KM01LeafletMap
	'Public KM01PhysicalAddressesPage As KM01PhysicalAddresses
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
	Public ActionSheetPage As B4XPageActionSheet
	Public ToastPage As B4XPageToast
	Public TooltipPage As B4XPageTooltip
	Public SegmentPage As B4XPageSegment
	Public ColorWheelPage As B4XPageColorWheel
	Public SignaturePadPage As B4XPageSignaturePad
	Public SheetModalPage As B4XPageSheetModal
	
	Public NavbarPage As B4XPageNavbar
	Private WindowPage As B4XPageWindow
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
	Public List1KPage As B4XPageList1K
	Public CanvasSpinner As B4XPageCanvasSpinner
	Public TextRotatePage As B4XPageTextRotate
	Public TimelinePage As B4XPageTimeline
	Public Hover3dPage As B4XPageHover3d
	Private AppLoader As B4XDaisyCanvasSpinner
	Public SweetAlert As B4XDaisySweetAlert
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
	Public TextPage As B4XPageText
	Public InputPage As B4XPageInput
	Public OTPPage As B4XPageOTP
	Public CheckboxPage As B4XPageCheckbox
	Public RadioPage As B4XPageRadio
	Public TogglePage As B4XPageToggle
	Public RangePage As B4XPageRange
	Public RatingPage As B4XPageRating
	Public TextareaPage As B4XPageTextarea
	Public SelectPage As B4XPageSelect
	Public PickerPage As B4XPagePicker
	Public RadioGroupPage As B4XPageRadioGroup
	Public CheckboxGroupPage As B4XPageCheckboxGroup
	Public ToggleGroupPage As B4XPageToggleGroup
	Public IconButtonPage As B4XPageIconButton
	Public FileInputPage As B4XPageFileInput
	Public SweetAlertPage As B4XPageSweetAlert
	Public FilterPage As B4XPageFilter
	Public PageScrollDemo As B4XPageScrollDemo
	Public NavScrollDockPage As B4XPageNavScrollDock
	Private ActiveAlert As B4XDaisyAlert
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
	B4XPages.GetManager.TransitionAnimationDuration = 0
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	PendingDashboardOnReopen = False
	
	'Initialize global loader unconditionally to prevent NullPointerExceptions
	AppLoader.Initialize(Me, "AppLoader")
	SweetAlert.Initialize(Me, Root, "SweetAlert")

	Sleep(0)
	'Attach and show global loader during ShowSplashScreen initialization
	If Root.Parent.IsInitialized Then
		AppLoader.Show(Root.Parent)
	End If

	'load the other pages
	Wait For (ShowSplashScreen) Complete (Unused As Boolean)

	'Show the Dashboard as the app start page.
	ShowPageWithLoader("Dashboard")
End Sub


Private Sub B4XPage_Appear
	If PendingDashboardOnReopen Then
		PendingDashboardOnReopen = False
		ShowPageWithLoader("Dashboard")
	End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If AppLoader.IsInitialized Then AppLoader.Resize(Width, Height)
	If SweetAlert.IsInitialized And SweetAlert.Visible Then
		SweetAlert.SetLayoutAnimated(0, 0, 0, Width, Height)
		SweetAlert.Refresh
	End If
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
	List1KPage.Initialize
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
	TextPage.Initialize
	InputPage.Initialize
	OTPPage.Initialize
	CheckboxPage.Initialize
	RadioPage.Initialize
	TogglePage.Initialize
	RangePage.Initialize
	RatingPage.Initialize
	TextareaPage.Initialize
	SelectPage.Initialize
	PickerPage.Initialize
	RadioGroupPage.Initialize
	CheckboxGroupPage.Initialize
	ToggleGroupPage.Initialize
	IconButtonPage.Initialize
	FileInputPage.Initialize
	FilterPage.Initialize
	DashboardPage.Initialize
	ActionSheetPage.Initialize
	ToastPage.Initialize
	TooltipPage.Initialize
	SegmentPage.Initialize
	ColorWheelPage.Initialize
	SignaturePadPage.Initialize
	SheetModalPage.Initialize
	NavbarPage.Initialize
	WindowPage.Initialize
	FieldSetPage.Initialize
	CanvasSpinner.Initialize
	TextRotatePage.Initialize
	TimelinePage.Initialize
	Hover3dPage.Initialize
	SweetAlertPage.Initialize
	PageScrollDemo.Initialize
	'KM01SignInPage.Initialize
	'KM01TypeOfUserPage.Initialize
	'KM01ClientProfilePage.Initialize
	'KM01KYCPage.Initialize
	'KM01NewProfilePage.Initialize
	'KM01CompanyRepresentativePage.Initialize
	'KM01LocationDetailsPage.Initialize
	'KM01IDDetailsPage.Initialize
	'KM01CongratulationsPage.Initialize
	'KM01OnboardingPage.Initialize
	NavScrollDockPage.Initialize
	'KM01LeafletMapPage.Initialize
	'KM01PhysicalAddressesPage.Initialize

	'B4XPages.AddPage("KM01LeafletMap", KM01LeafletMapPage)
	B4XPages.AddPage("Stat", StatPage)
	B4XPages.AddPage("Chat", ChatPage)
	B4XPages.AddPage("Alert", AlertPage)
	B4XPages.AddPage("Avatar", AvatarPage)
	B4XPages.AddPage("Badge", BadgePage)
	B4XPages.AddPage("Card", CardPage)
	B4XPages.AddPage("Filter", FilterPage)
	B4XPages.AddPage("File Input", FileInputPage)
	B4XPages.AddPage("Checkbox Group", CheckboxGroupPage)
	B4XPages.AddPage("Toggle Group", ToggleGroupPage)
	B4XPages.AddPage("Radio Group", RadioGroupPage)
	B4XPages.AddPage("Select", SelectPage)
	B4XPages.AddPage("Picker", PickerPage)
	B4XPages.AddPage("Rating", RatingPage)
	B4XPages.AddPage("Textarea", TextareaPage)
	B4XPages.AddPage("Range", RangePage)
	B4XPages.AddPage("Toggle", TogglePage)
	B4XPages.AddPage("Radio", RadioPage)
	B4XPages.AddPage("Checkbox", CheckboxPage)
	B4XPages.AddPage("Input", InputPage)
	B4XPages.AddPage("Input OTP", OTPPage)
	B4XPages.AddPage("Typography", TextPage)
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
	B4XPages.AddPage("List 1K", List1KPage)
	B4XPages.AddPage("Dashboard", DashboardPage)
	B4XPages.AddPage("ActionSheet", ActionSheetPage)
	B4XPages.AddPage("SheetModal", SheetModalPage)
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
	B4XPages.AddPage("Segment", SegmentPage)
	B4XPages.AddPage("ColorWheel", ColorWheelPage)
	B4XPages.AddPage("SignaturePad", SignaturePadPage)
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
	B4XPages.AddPage("Icon Button", IconButtonPage)
	B4XPages.AddPage("SweetAlert2", SweetAlertPage)
	B4XPages.AddPage("PageScrollDemo", PageScrollDemo)
	'B4XPages.AddPage("KM01SignIn", KM01SignInPage)
	'B4XPages.AddPage("KM01TypeOfUser", KM01TypeOfUserPage)
	'B4XPages.AddPage("KM01ClientProfile", KM01ClientProfilePage)
	'B4XPages.AddPage("KM01KYC", KM01KYCPage)
	'B4XPages.AddPage("KM01NewProfile", KM01NewProfilePage)
	'B4XPages.AddPage("KM01CompanyRepresentative", KM01CompanyRepresentativePage)
	'B4XPages.AddPage("KM01LocationDetails", KM01LocationDetailsPage)
	'B4XPages.AddPage("KM01IDDetails", KM01IDDetailsPage)
	'B4XPages.AddPage("KM01Congratulations", KM01CongratulationsPage)
	'B4XPages.AddPage("KM01Onboarding", KM01OnboardingPage)
	'B4XPages.AddPage("KM01PhysicalAddresses", KM01PhysicalAddressesPage)
	B4XPages.AddPage("NavScrollDock", NavScrollDockPage)
	Return True
End Sub

'Return True to close, False to cancel

Private Sub B4XPage_CloseRequest As ResumableSub
	Dim sf As Object = ShowConfirm("Close B4XDaisyUIKit?", "Are you sure you want to close the application?", "Yes", "No")
	Wait For (sf) Complete (Result As B4XDaisySweetAlertResult)
	If Result.IsConfirmed Then
		PendingDashboardOnReopen = True
		Return True
	End If
	ShowPageWithLoader("Dashboard")
	Return False
End Sub


Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode = KeyCodes.KEYCODE_BACK Then
		Return B4XPages.Delegate.Activity_KeyPress(KeyCode)
	End If
	B4XPages.GetManager.RaiseEvent(B4XPages.GetManager.GetTopPage, "B4XPage_KeyPress", Array(KeyCode))
	Return False
End Sub

'/**
'* Shows the page loader, waits a bit, and then shows the target page.
'*/

Public Sub ShowPageWithLoader(PageId As String)
	Try
		Dim pInStack As Boolean = PageInStack(PageId)
		If pInStack Then
			Log($"Page Already In Stack: ${PageId}"$)
		End If
		AppLoader.Show(Root.Parent)
		Sleep(500)
		Sleep(0)
		B4XPages.ShowPage(PageId)
		AppLoader.Show(Root.Parent)
		Sleep(0)
		'how many stacked pages are there
		Dim iStacked As Int = CountStackedPages
		Log($"Stacked Pages Count: ${iStacked}"$)
	Catch
		Log("ERROR: ShowPageWithLoader crashed for page '" & PageId & "': " & LastException.Message)
		#If B4A
		Dim jo As JavaObject = LastException
		jo.RunMethod("printStackTrace", Null)
		#End If
			ToastMessageShow("Error loading " & PageId & ": " & LastException.Message, True)
			If AppLoader.IsInitialized Then AppLoader.Hide
	End Try
End Sub

'/**
'* Closes the given page (removing it from the B4XPages navigation stack via
'* B4XPages.ClosePage) while showing the transition loader, then lets the
'* B4XPages manager reveal the previous page. Use this from a page's
'* navbar_Back instead of ShowPageWithLoader so back navigation actually pops
'* the page from mStackOfPageIds and the page collection does not keep growing.
'*/
Public Sub ClosePageWithLoader(Page As Object)
	Try
		AppLoader.Show(Root.Parent)
		Sleep(500)
		Sleep(0)
		B4XPages.ClosePage(Page)
		AppLoader.Show(Root.Parent)
		Sleep(0)
	Catch
		Log("ERROR: ClosePageWithLoader crashed: " & LastException.Message)
		#If B4A
		Dim jo As JavaObject = LastException
		jo.RunMethod("printStackTrace", Null)
		#End If
			ToastMessageShow("Error closing page: " & LastException.Message, True)
			If AppLoader.IsInitialized Then AppLoader.Hide
	End Try
End Sub

Sub PagePause
	If AppLoader.IsInitialized Then AppLoader.Show(Root.Parent)
End Sub

Sub PageResume
	If AppLoader.IsInitialized Then AppLoader.Hide
End Sub

Private Sub Page_Ready
	If AppLoader.IsInitialized Then AppLoader.Hide
End Sub

' Displays a simple status/information Sweet Alert.
Public Sub ShowAlert(Title As String, Text As String, Icon As String, AllowOutside As Boolean) As ResumableSub
	Dim TopPage As B4XPageInfo = B4XPages.GetManager.GetTopPage
	If TopPage <> Null And TopPage.Root.IsInitialized Then
		SweetAlert.Parent = TopPage.Root
	Else If Root.Parent.IsInitialized Then
		SweetAlert.Parent = Root.Parent
	Else
		SweetAlert.Parent = Root
	End If
	SweetAlert.Title = Title
	SweetAlert.Text = Text
	SweetAlert.Icon = Icon
	SweetAlert.AllowOutsideClick = AllowOutside
	SweetAlert.ShowConfirmButton = True
	SweetAlert.ConfirmButtonText = "OK"
	SweetAlert.ShowCancelButton = False
	SweetAlert.ShowDenyButton = False
	SweetAlert.TimerMs = 0
	Wait For (SweetAlert.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
	Return Result
End Sub

' Displays a confirmation Sweet Alert with backdrop clicks disabled (AllowOutsideClick = False).
' Returns an integer matching xui.DialogResponse_Positive (-1), xui.DialogResponse_Cancel (-2) or xui.DialogResponse_Negative (-3).
Public Sub ShowConfirm(Title As String, Text As String, ConfirmText As String, CancelText As String) As ResumableSub
	Dim TopPage As B4XPageInfo = B4XPages.GetManager.GetTopPage
	If TopPage <> Null And TopPage.Root.IsInitialized Then
		SweetAlert.Parent = TopPage.Root
	Else If Root.Parent.IsInitialized Then
		SweetAlert.Parent = Root.Parent
	Else
		SweetAlert.Parent = Root
	End If
	SweetAlert.Title = Title
	SweetAlert.Text = Text
	SweetAlert.Icon = "question"
	SweetAlert.AllowOutsideClick = False
	SweetAlert.ShowConfirmButton = True
	SweetAlert.ConfirmButtonText = ConfirmText
	SweetAlert.ShowCancelButton = True
	SweetAlert.CancelButtonText = CancelText
	SweetAlert.ShowDenyButton = False
	SweetAlert.TimerMs = 0
	Wait For (SweetAlert.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
	Return Result
End Sub

' Displays a floating DaisyUI alert notification on the active page.
' Position supports: "top-right", "top-left", "top-center", "bottom-left", "bottom-right", "middle-center" (default "top-right").
' The alert automatically dismisses after DurationMs. If DurationMs is 0, it stays until tapped.
Public Sub ShowAlertNotification(Title As String, Text As String, AlertVariant As String, DurationMs As Int, Position As String) As B4XDaisyAlert
	If ActiveAlert <> Null Then
		Try
			ActiveAlert.RemoveViewFromParent
		Catch
			Log("B4XMainPage.ShowAlertNotification: " & LastException.Message)
		End Try
		ActiveAlert = Null
	End If

	Dim TopPage As B4XPageInfo = B4XPages.GetManager.GetTopPage
	If TopPage = Null Or TopPage.Root.IsInitialized = False Then Return Null

	Dim alert As B4XDaisyAlert
	alert.Initialize(Me, "GlobalAlert")
	alert.SetTitle(Title)
	alert.SetText(Text)
	alert.SetVariant(AlertVariant)
	alert.SetStyle("solid")
	alert.SetIconVisible(True)
	alert.SetIconSize("6")
	alert.SetShadow("md")
	alert.SetRoundedBox(True)
	alert.Tag = alert
	
	Dim alertWidth As Int
	Dim alertLeft As Int
	Dim alertTop As Int = 16dip
	
	Dim pos As String = Position.ToLowerCase
	If pos = "" Then pos = "top-right"
	
	Select Case pos
		Case "top-right", "bottom-right"
			alertWidth = Min(320dip, TopPage.Root.Width - 32dip)
			alertLeft = TopPage.Root.Width - alertWidth - 16dip
		Case "top-left", "bottom-left"
			alertWidth = Min(320dip, TopPage.Root.Width - 32dip)
			alertLeft = 16dip
		Case "middle-center"
			alertWidth = Min(320dip, TopPage.Root.Width - 32dip)
			alertLeft = (TopPage.Root.Width - alertWidth) / 2
		Case Else '"top-center" or any other value
			alertWidth = TopPage.Root.Width - 32dip
			alertLeft = 16dip
	End Select
	
	alert.AddToParent(TopPage.Root, alertLeft, alertTop, alertWidth, 0)
	
	Dim alertHeight As Int = alert.GetComputedHeight
	Select Case pos
		Case "bottom-right", "bottom-left"
			alertTop = TopPage.Root.Height - alertHeight - 16dip
			alert.setTop(alertTop)
		Case "middle-center"
			alertTop = (TopPage.Root.Height - alertHeight) / 2
			alert.setTop(alertTop)
	End Select
	
	alert.BringToFront
	
	ActiveAlert = alert
	
	If DurationMs > 0 Then
		DismissAlertAfterDelay(alert, DurationMs)
	End If
	
	Return alert
End Sub

Private Sub DismissAlertAfterDelay(Alert1 As B4XDaisyAlert, DelayMs As Int)
	Sleep(DelayMs)
	Try
		If Alert1 = ActiveAlert Then
			Alert1.RemoveViewFromParent
			ActiveAlert = Null
		End If
	Catch
		Log("Failed to dismiss alert: " & LastException.Message)
	End Try
End Sub

Private Sub GlobalAlert_Click(Tag As Object)
	Dim alert As B4XDaisyAlert = Tag
	Try
		alert.RemoveViewFromParent
		If ActiveAlert = alert Then ActiveAlert = Null
	Catch
		Log("Failed to dismiss alert on click: " & LastException.Message)
	End Try
End Sub

Sub CountStackedPages As Int
	Return B4XPages.GetManager.mStackOfPageIds.Size 
End Sub

Sub PageInStack(pageID As String) As Boolean
	Dim idxPOs As Int = B4XPages.GetManager.mStackOfPageIds.AsList.IndexOf(pageID)
	If idxPOs = -1 Then
		Return False 
	End If
	Return True
End Sub