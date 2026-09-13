B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.70
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
	Private PendingReopen As Boolean
	Private ReopenPageId As String
	' Global overlays accessible from all pages via B4XPages.MainPage
	Private AppLoader As B4XDaisyCanvasSpinner
	Public SweetAlert As B4XDaisySweetAlert
	Public HomePage As B4XPageHome
	Public ProductListPage As B4XPageProductList
	Public ProductDetailPage As B4XPageProductDetail
	Private ActiveAlert As B4XDaisyAlert
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
	B4XPages.GetManager.TransitionAnimationDuration = 0
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	PendingReopen = False
	ReopenPageId = ""

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

	ShowPageWithLoader("home")
	'just check if animations are enabled
	Dim bHasAnimation As Boolean = B4XDaisyVariants.AreSystemAnimationsEnabled
	Log($"Animation Enabled: ${bHasAnimation}"$)
	If bHasAnimation = False Then
		'ensure animation is turned on
		B4XDaisyVariants.ForceAnimatorDurationScale(1)
	End If
End Sub


Private Sub B4XPage_Appear
	If PendingReopen Then
		PendingReopen = False
		If ReopenPageId <> "" Then ShowPageWithLoader(ReopenPageId)
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
	HomePage.Initialize
	B4XPages.AddPage("home", HomePage)
	ProductListPage.Initialize
	B4XPages.AddPage("products", ProductListPage)
	ProductDetailPage.Initialize
	B4XPages.AddPage("productdetail", ProductDetailPage)
	Return True
End Sub

'Return True to close, False to cancel

Private Sub B4XPage_CloseRequest As ResumableSub
	Dim sf As Object = ShowSwalConfirm("Close app?", "Are you sure you want to close the application?", "Yes", "No")
	Wait For (sf) Complete (Result As B4XDaisySweetAlertResult)
	If Result.IsConfirmed Then
		PendingReopen = True
		ReopenPageId = "home"
		Return True
	End If
	ShowPageWithLoader("home")
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