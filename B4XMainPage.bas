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

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private PendingDashboardOnReopen As Boolean
	Public ChatPage As B4xPageChat
	Public AvatarPage As B4xPageAvatar
	Public MaskPage As B4xPageMask
	Public StackPage As B4XPageStack
	Public StackPhotosPage As B4XPageStackPhotos
	Public SvgIconPage As B4xPageSvgIcon
	Public DashboardPage As B4XPageDashboard
	Private B4XGifView1 As B4XGifView
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
	B4XPages.GetManager.TransitionAnimationDuration = 0
'	DashboardPage.Initialize
'	B4XPages.AddPage("Dashboard", DashboardPage)
'	B4XPages.ShowPage("Dashboard")
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
	AvatarPage.Initialize
	MaskPage.Initialize
	StackPage.Initialize
	StackPhotosPage.Initialize
	SvgIconPage.Initialize
	DashboardPage.Initialize
	
	B4XPages.AddPageAndCreate("Chat", ChatPage)
	B4XPages.AddPageAndCreate("Avatar", AvatarPage)
	B4XPages.AddPageAndCreate("Mask", MaskPage)
	B4XPages.AddPageAndCreate("Stack", StackPage)
	B4XPages.AddPageAndCreate("Stack Photos", StackPhotosPage)
	B4XPages.AddPageAndCreate("SVG Icon", SvgIconPage)
	B4XPages.AddPageAndCreate("Dashboard", DashboardPage)
	'	
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