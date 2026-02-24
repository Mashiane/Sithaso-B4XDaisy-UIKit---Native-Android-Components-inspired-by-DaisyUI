B4A=true
Group=Main
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

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private PendingDashboardOnReopen As Boolean
	Public ChatPage As B4xPageChat
	Public AlertPage As B4XPageAlert
	Public AvatarPage As B4xPageAvatar
	Public AvatarGroupPage As B4XPageAvatarGroup
	Public BadgePage As B4XPageBadge
	Public IndicatorPage As B4XPageIndicator
	Public StatusPage As B4XPageStatus
	Public LoadingPage As B4XPageLoading
	Public MaskPage As B4xPageMask
	Public StackPage As B4XPageStack
	Public StackPhotosPage As B4XPageStackPhotos
	Public SvgIconPage As B4xPageSvgIcon
	Public SwapPage As B4XPageSwap
	Public RadialProgressPage As B4XPageRadialProgress
	Public ProgressPage As B4XPageProgress
	Public DashboardPage As B4XPageDashboard
	Public SkeletonPage As B4XPageSkeleton
	Public ToastPage As B4XPageToast
	Public TooltipPage As B4XPageTooltip
	Public NavbarPage As B4XPageNavbar
	Private WindowPage As B4XPageWindow
	Private B4XGifView1 As B4XGifView
	Private FieldSetPage As B4XPageFieldset
	Private BadgeGroupSelectPage As B4XPageBadgeGroupSelect
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
'	Root.RemoveAllViews
	B4XPages.SetTitle(Me, "B4XDaisy UIKit")
	'Show dashboard once at startup. Avoid reopening it on every MainPage appear.
	B4XPages.ShowPage("Dashboard")
End Sub

Private Sub B4XPage_Appear
	If PendingDashboardOnReopen Then
		PendingDashboardOnReopen = False
		B4XPages.ShowPage("Dashboard")
	End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
End Sub

Sub ShowSplashScreen As ResumableSub
	#If B4i
	Main.NavControl.NavigationBarVisible = False
	#End If	
	'
	ChatPage.Initialize
	AlertPage.Initialize
	AvatarPage.Initialize
	AvatarGroupPage.Initialize
	BadgePage.Initialize
	IndicatorPage.Initialize
	StatusPage.Initialize
	LoadingPage.Initialize
	MaskPage.Initialize
	StackPage.Initialize
	StackPhotosPage.Initialize
	SvgIconPage.Initialize
	SwapPage.Initialize
	RadialProgressPage.Initialize
	ProgressPage.Initialize
	DashboardPage.Initialize
	SkeletonPage.Initialize
	ToastPage.Initialize
	TooltipPage.Initialize
	NavbarPage.Initialize
	WindowPage.Initialize
	FieldSetPage.Initialize 
	BadgeGroupSelectPage.Initialize
	
	B4XPages.AddPageAndCreate("Chat", ChatPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Alert", AlertPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Avatar", AvatarPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Avatar Group", AvatarGroupPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Badge", BadgePage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Indicator", IndicatorPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Status", StatusPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Loading", LoadingPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Mask", MaskPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Stack", StackPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Stack Photos", StackPhotosPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("SVG Icon", SvgIconPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Swap", SwapPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Radial Progress", RadialProgressPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Progress", ProgressPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Dashboard", DashboardPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Skeleton", SkeletonPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Toast", ToastPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Tooltip", TooltipPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Navbar", NavbarPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Window", WindowPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("FieldSet", FieldSetPage)
	Sleep(0)
	B4XPages.AddPageAndCreate("Badge Group Select", BadgeGroupSelectPage)
	Return True
End Sub

'Return True to close, False to cancel
Private Sub B4XPage_CloseRequest As ResumableSub
	Dim sf As Object = xui.Msgbox2Async("Are you sure you want to close the application?", "Close B4XDaisyUI Kit?", "Yes", "", "No", Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		PendingDashboardOnReopen = True
		Return True
	End If
	B4XPages.ShowPage("Dashboard")
	Return False
End Sub

'Sub RemoveActivityFromForeground
'    
'    '*** Below code moves the task containing this activity to the back of the activity stack.***
'    '*** It's a quick way to remove your activity, more or less like "bring to back"
'    Dim jo As JavaObject
'    jo.InitializeContext
'    jo.RunMethod("moveTaskToBack", Array(True))
'    '********************************************************************************************
'    
'End Sub


'Public Sub SetStatusBarState(Show As Boolean)
'	Dim p As Phone
'	If p.SdkVersion < 30 Then Return 'android 10-
'	Dim t As JavaObject
'	t.InitializeStatic("android.view.WindowInsets.Type")
'	Dim ctxt As JavaObject
'	ctxt.InitializeContext
'	ctxt.RunMethodJO("getWindow", Null).RunMethodJO("getDecorView", Null).RunMethodJO("getWindowInsetsController", Null).RunMethod( _
'		IIf(Show, "show", "hide"), Array(t.RunMethod("statusBars", Null)))
'End Sub
