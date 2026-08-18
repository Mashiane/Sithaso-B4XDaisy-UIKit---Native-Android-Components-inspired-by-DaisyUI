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
	Public InfoCardPage As B4XPageInfoCard
	Public CarouselPage As B4XPageCarousel
	Public OverlayPage As B4XPageOverlay
	Public CollapsePage As B4XPageCollapse
	Public AccordionPage As B4XPageAccordion
	Public CountdownPage As B4XPageCountdown
	Public DiffPage As B4XPageDiff
	Public ListPage As B4XPageList
	Public List1KPage As B4XPageList1K
	Public CanvasSpinner As B4XPageCanvasSpinner
	Public AuraPage As B4XPageAura
	Public EasingPage As B4XPageEasing
	Public TextRotatePage As B4XPageTextRotate
	Public TimelinePage As B4XPageTimeline
	Public Hover3dPage As B4XPageHover3d
	Private AppLoader As B4XDaisyCanvasSpinner
	Public SweetAlert As B4XDaisySweetAlert
	Public FabPage As B4XPageFab
	Public FabNavbarPage As B4XPageFabNavbar
	Public FabFlowerPage As B4XPageFabFlower
	Public BoomMenuPage As B4XPageBoomMenu
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
	Public DualRangePage As B4XPageDualRange
	Public RatingPage As B4XPageRating
	Public TextareaPage As B4XPageTextarea
	Public SelectPage As B4XPageSelect
	Public PickerPage As B4XPagePicker
	Public RadioGroupPage As B4XPageRadioGroup
	Public CheckboxGroupPage As B4XPageCheckboxGroup
	Public ToggleGroupPage As B4XPageToggleGroup
	Public IconButtonPage As B4XPageIconButton
	Public FileInputPage As B4XPageFileInput
	Public MediaPickerPage As B4XPageMediaPicker
	Public SweetAlertPage As B4XPageSweetAlert
	Public SweetAlertInputsPage As B4XPageSweetAlertInputs
	Public FilterPage As B4XPageFilter
	Public PageScrollDemo As B4XPageScrollDemo
	Public NavScrollDockPage As B4XPageNavScrollDock
	Public EnjoyHintPage As B4XPageEnjoyHint
	Public ShineButtonPage As B4XPageShineButton
	Public TagSpherePage As B4XPageTagSphere
	Public PDFViewPage As B4XPagePDFView
	Private ActiveAlert As B4XDaisyAlert
	Private FabBasicPage As B4XPageFabBasic
	Public DrawerPage As B4XPageDrawer
	Public DrawerTreePage As B4XPageDrawerTree
	Public DrawerRailPage As B4XPageDrawerRail
	Public NativeDialogsPage As B4XPageNativeDialogs
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = False
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

	'Show pdfview as the app start page.
	ShowPageWithLoader("dashboard")
	'just check if animations are enabled
	Dim bHasAnimation As Boolean = B4XDaisyVariants.AreSystemAnimationsEnabled
	Log($"Animation Enabled: ${bHasAnimation}"$)
	If bHasAnimation = False Then
		'ensure animation is turned on
		B4XDaisyVariants.ForceAnimatorDurationScale(1)
	End If
End Sub


Private Sub B4XPage_Appear
	If PendingDashboardOnReopen Then
		PendingDashboardOnReopen = False
		ShowPageWithLoader("dashboard")
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
	InfoCardPage.Initialize
	FabPage.Initialize
	FabBasicPage.Initialize
	FabNavbarPage.Initialize
	FabFlowerPage.Initialize
	BoomMenuPage.Initialize
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
	MediaPickerPage.Initialize
	FilterPage.Initialize
	DrawerPage.Initialize
	DrawerTreePage.Initialize
	DrawerRailPage.Initialize

	NativeDialogsPage.Initialize
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
	AuraPage.Initialize
	EasingPage.Initialize
	TextRotatePage.Initialize
	TimelinePage.Initialize
	Hover3dPage.Initialize
	SweetAlertPage.Initialize
	SweetAlertInputsPage.Initialize
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
	EnjoyHintPage.Initialize
	ShineButtonPage.Initialize
	TagSpherePage.Initialize
	PDFViewPage.Initialize
	DualRangePage.Initialize
	'KM01LeafletMapPage.Initialize
	'KM01PhysicalAddressesPage.Initialize

	'B4XPages.AddPage("KM01LeafletMap", KM01LeafletMapPage)
	B4XPages.AddPage("stat", StatPage)
	B4XPages.AddPage("infocard", InfoCardPage)
	B4XPages.AddPage("chat", ChatPage)
	B4XPages.AddPage("alert", AlertPage)
	B4XPages.AddPage("avatar", AvatarPage)
	B4XPages.AddPage("badge", BadgePage)
	B4XPages.AddPage("card", CardPage)
	B4XPages.AddPage("Drawer", DrawerPage)
	B4XPages.AddPage("drawertree", DrawerTreePage)
	B4XPages.AddPage("DrawerTree", DrawerTreePage)
	B4XPages.AddPage("drawerrail", DrawerRailPage)
	B4XPages.AddPage("DrawerRail", DrawerRailPage)
	B4XPages.AddPage("filter", FilterPage)
	B4XPages.AddPage("file-input", FileInputPage)
	B4XPages.AddPage("media-picker", MediaPickerPage)
	B4XPages.AddPage("checkbox-group", CheckboxGroupPage)
	B4XPages.AddPage("toggle-group", ToggleGroupPage)
	B4XPages.AddPage("radio-group", RadioGroupPage)
	B4XPages.AddPage("select", SelectPage)
	B4XPages.AddPage("picker", PickerPage)
	B4XPages.AddPage("rating", RatingPage)
	B4XPages.AddPage("textarea", TextareaPage)
	B4XPages.AddPage("range", RangePage)
	B4XPages.AddPage("dualrange", DualRangePage)
	B4XPages.AddPage("DualRange", DualRangePage)
	B4XPages.AddPage("toggle", TogglePage)
	B4XPages.AddPage("radio", RadioPage)
	B4XPages.AddPage("checkbox", CheckboxPage)
	B4XPages.AddPage("input", InputPage)
	B4XPages.AddPage("otp", OTPPage)
	B4XPages.AddPage("typography", TextPage)
	B4XPages.AddPage("tab", TabPage)
	B4XPages.AddPage("steps", StepsPage)
	B4XPages.AddPage("dock", DockPage)
	B4XPages.AddPage("pagination", PaginationPage)
	B4XPages.AddPage("breadcrumbs", BreadcrumbsPage)
	B4XPages.AddPage("link", LinkPage)
	B4XPages.AddPage("modal", ModalPage)
	B4XPages.AddPage("dropdown", DropdownPage)
	B4XPages.AddPage("menu", MenuPage)
	B4XPages.AddPage("menu_runtime", MenuRuntimePage)
	B4XPages.AddPage("menu_runtime2", MenuRuntime2Page)
	B4XPages.AddPage("fab", FabPage)
	B4XPages.AddPage("fab_basic", FabBasicPage)
	B4XPages.AddPage("fab_navbar", FabNavbarPage)
	B4XPages.AddPage("fab_flower", FabFlowerPage)
	B4XPages.AddPage("boommenu", BoomMenuPage)
	B4XPages.AddPage("diff", DiffPage)
	B4XPages.AddPage("list", ListPage)
	B4XPages.AddPage("list1k", List1KPage)
	B4XPages.AddPage("dashboard", DashboardPage)
	B4XPages.AddPage("actionsheet", ActionSheetPage)
	B4XPages.AddPage("sheetmodal", SheetModalPage)
	B4XPages.AddPage("skeleton", SkeletonPage)
	B4XPages.AddPage("hero", HeroPage)
	B4XPages.AddPage("button", ButtonPage)
	B4XPages.AddPage("kbd", KbdPage)
	B4XPages.AddPage("divider", DividerPage)
	B4XPages.AddPage("indicator", IndicatorPage)
	B4XPages.AddPage("status", StatusPage)
	B4XPages.AddPage("loading", LoadingPage)
	B4XPages.AddPage("mask", MaskPage)
	B4XPages.AddPage("stack", StackPage)
	B4XPages.AddPage("svg_icon", SvgIconPage)
	B4XPages.AddPage("swap", SwapPage)
	B4XPages.AddPage("radialprogress", RadialProgressPage)
	B4XPages.AddPage("progress", ProgressPage)
	B4XPages.AddPage("toast", ToastPage)
	B4XPages.AddPage("tooltip", TooltipPage)
	B4XPages.AddPage("segment", SegmentPage)
	B4XPages.AddPage("colorwheel", ColorWheelPage)
	B4XPages.AddPage("signaturepad", SignaturePadPage)
	B4XPages.AddPage("navbar", NavbarPage)
	B4XPages.AddPage("window", WindowPage)
	B4XPages.AddPage("fieldset", FieldSetPage)
	B4XPages.AddPage("carousel", CarouselPage)
	B4XPages.AddPage("overlay", OverlayPage)
	B4XPages.AddPage("collapse", CollapsePage)
	B4XPages.AddPage("accordion", AccordionPage)
	B4XPages.AddPage("countdown", CountdownPage)
	B4XPages.AddPage("cspinner", CanvasSpinner)
	B4XPages.AddPage("aura", AuraPage)
	B4XPages.AddPage("easing", EasingPage)
	B4XPages.AddPage("textrotate", TextRotatePage)
	B4XPages.AddPage("timeline", TimelinePage)
	B4XPages.AddPage("hover3d", Hover3dPage)
	B4XPages.AddPage("iconbutton", IconButtonPage)
	B4XPages.AddPage("sweetalert", SweetAlertPage)
	B4XPages.AddPage("sweetalertinputs", SweetAlertInputsPage)
	B4XPages.AddPage("pdfview", PDFViewPage)
	B4XPages.AddPage("pagescrolldemo", PageScrollDemo)
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
	B4XPages.AddPage("navscrolldock", NavScrollDockPage)
	B4XPages.AddPage("enjoyhint", EnjoyHintPage)
	B4XPages.AddPage("shinebutton", ShineButtonPage)
	B4XPages.AddPage("tagsphere", TagSpherePage)

	B4XPages.AddPage("nativedialogs", NativeDialogsPage)
	Return True
End Sub

'Return True to close, False to cancel

Private Sub B4XPage_CloseRequest As ResumableSub
	Dim sf As Object = ShowSwalConfirm("Close B4XDaisyUIKit?", "Are you sure you want to close the application?", "Yes", "No")
	Wait For (sf) Complete (Result As B4XDaisySweetAlertResult)
	If Result.IsConfirmed Then
		PendingDashboardOnReopen = True
		Return True
	End If
	ShowPageWithLoader("dashboard")
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
		Sleep(150)
		B4XPages.ShowPage(PageId)
		'how many stacked pages are there
		Dim iStacked As Int = CountStackedPages
		Log($"Stacked Pages Count: ${iStacked}"$)
	Catch
		Log("B4XMainPage.ShowPageWithLoader: " & LastException.Message)
		#If B4A
		Dim jo As JavaObject = LastException
		jo.RunMethod("printStackTrace", Null)
		#End If
		Log("B4XMainPage.ShowPageWithLoader: " & LastException.Message)
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
		Sleep(150)
		B4XPages.ClosePage(Page)
	Catch
		Log("B4XMainPage.ClosePageWithLoader: " & LastException.Message)
		#If B4A
		Dim jo As JavaObject = LastException
		jo.RunMethod("printStackTrace", Null)
		#End If
		Log("B4XMainPage.ClosePageWithLoader: " & LastException.Message)
		If AppLoader.IsInitialized Then AppLoader.Hide
	End Try
End Sub

Sub PagePause
	If AppLoader.IsInitialized Then AppLoader.Show(Root.Parent)
End Sub

Sub PageResume
	If AppLoader.IsInitialized Then AppLoader.Hide
End Sub

Public Sub Page_Ready
	If AppLoader.IsInitialized Then AppLoader.Hide
End Sub

' Displays a simple status/information Sweet Alert.
Public Sub ShowSwalAlert(Title As String, Text As String, Icon As String, AllowOutside As Boolean) As ResumableSub
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
Public Sub ShowSwalConfirm(Title As String, Text As String, ConfirmText As String, CancelText As String) As ResumableSub
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
Public Sub ShowToastAlert(Title As String, Text As String, AlertVariant As String, DurationMs As Int, Position As String) As B4XDaisyAlert
	If ActiveAlert <> Null Then
		Try
			ActiveAlert.RemoveViewFromParent
		Catch
			Log("B4XMainPage.ShowToastAlert: " & LastException.Message)
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
		Case "middle-center", "top-center", "bottom-center"
			alertWidth = Min(320dip, TopPage.Root.Width - 32dip)
			alertLeft = (TopPage.Root.Width - alertWidth) / 2
		Case Else
			alertWidth = TopPage.Root.Width - 32dip
			alertLeft = 16dip
	End Select
	
	alert.AddToParent(TopPage.Root, alertLeft, alertTop, alertWidth, 0)
	
	Dim alertHeight As Int = alert.GetComputedHeight
	Select Case pos
		Case "bottom-right", "bottom-left", "bottom-center"
			alertTop = TopPage.Root.Height - alertHeight - 16dip
			alert.View.Top = alertTop
		Case "middle-center"
			alertTop = (TopPage.Root.Height - alertHeight) / 2
			alert.View.Top = alertTop
	End Select
	
	alert.View.BringToFront
	
	ActiveAlert = alert
	
	If DurationMs > 0 Then
		DismissAlertAfterDelay(alert, DurationMs)
	End If
	
	Return alert
End Sub

Public Sub ShowToast(Message As String, LongDuration As Boolean) As B4XDaisyAlert
	Dim duration As Int
	If LongDuration Then duration = 3500 Else duration = 2500
	Return ShowToastAlert("", Message, "info", duration, "bottom-center")
End Sub

Public Sub ShowToastError(Message As String, LongDuration As Boolean) As B4XDaisyAlert
	Dim duration As Int
	If LongDuration Then duration = 3500 Else duration = 2500
	Return ShowToastAlert("Error", Message, "error", duration, "bottom-center")
End Sub

Public Sub ShowToastSuccess(Message As String, LongDuration As Boolean) As B4XDaisyAlert
	Dim duration As Int
	If LongDuration Then duration = 3500 Else duration = 2500
	Return ShowToastAlert("Success", Message, "success", duration, "bottom-center")
End Sub

Public Sub ShowToastWarning(Message As String, LongDuration As Boolean) As B4XDaisyAlert
	Dim duration As Int
	If LongDuration Then duration = 3500 Else duration = 2500
	Return ShowToastAlert("Warning", Message, "warning", duration, "bottom-center")
End Sub

Private Sub DismissAlertAfterDelay(Alert1 As B4XDaisyAlert, DelayMs As Int)
	Sleep(DelayMs)
	Try
		If Alert1 = ActiveAlert Then
			Alert1.RemoveViewFromParent
			ActiveAlert = Null
		End If
	Catch
		Log("B4XMainPage.DismissAlertAfterDelay: " & LastException.Message)
	End Try
End Sub

Private Sub GlobalAlert_Click(Tag As Object)
	Dim alert As B4XDaisyAlert = Tag
	Try
		alert.RemoveViewFromParent
		If ActiveAlert = alert Then ActiveAlert = Null
	Catch
		Log("B4XMainPage.GlobalAlert_Click: " & LastException.Message)
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
