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
	Private ActiveAlert As B4XDaisyAlert

	' App pages
	Public HomePage As B4XPageSleepDashboard
	Public SmartAlarmPage As B4XPageSmartAlarm
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
	B4XPages.GetManager.TransitionAnimationDuration = 0
End Sub

Private Sub B4XPage_Created (vRoot1 As B4XView)
	Root = vRoot1
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
	Wait For (ShowSplashScreen) Complete (bUnused As Boolean)

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

Private Sub B4XPage_Resize (iWidth As Int, iHeight As Int)
	If AppLoader.IsInitialized Then AppLoader.Resize(iWidth, iHeight)
	If SweetAlert.IsInitialized Then SweetAlert.Base_Resize(iWidth, iHeight)
End Sub

Sub ShowSplashScreen As ResumableSub
	#If B4i
		Main.NavControl.NavigationBarVisible = False
	#End If

	HomePage.Initialize
	SmartAlarmPage.Initialize

	B4XPages.AddPage("home", HomePage)
	B4XPages.AddPage("smart_alarm", SmartAlarmPage)

	Return True
End Sub

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

Public Sub Activity_KeyPress (iKeyCode As Int) As Boolean
	If iKeyCode = KeyCodes.KEYCODE_BACK Then
		Return B4XPages.Delegate.Activity_KeyPress(iKeyCode)
	End If
	B4XPages.GetManager.RaiseEvent(B4XPages.GetManager.GetTopPage, "B4XPage_KeyPress", Array(iKeyCode))
	Return False
End Sub

Public Sub ShowPageWithLoader(sPageId As String)
	Try
		Dim pInStack As Boolean = PageInStack(sPageId)
		If pInStack Then
			Log($"Page Already In Stack: ${sPageId}"$)
		End If
		AppLoader.Show(Root.Parent)
		Sleep(150)
		B4XPages.ShowPage(sPageId)
		Dim iStacked As Int = CountStackedPages
		Log($"Stacked Pages Count: ${iStacked}"$)
	Catch
		Log("B4XMainPage.ShowPageWithLoader: " & LastException.Message)
		#If B4A
		Dim jo As JavaObject = LastException
		jo.RunMethod("printStackTrace", Null)
		#End If
		If AppLoader.IsInitialized Then AppLoader.Hide
	End Try
End Sub

Public Sub ClosePageWithLoader(oPage As Object)
	Try
		AppLoader.Show(Root.Parent)
		Sleep(150)
		B4XPages.ClosePage(oPage)
	Catch
		Log("B4XMainPage.ClosePageWithLoader: " & LastException.Message)
		#If B4A
		Dim jo As JavaObject = LastException
		jo.RunMethod("printStackTrace", Null)
		#End If
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

Public Sub ShowSwalAlert(sTitle As String, sText As String, sIcon As String, bAllowOutside As Boolean) As ResumableSub
	Dim TopPage As B4XPageInfo = B4XPages.GetManager.GetTopPage
	If TopPage <> Null And TopPage.Root.IsInitialized Then
		SweetAlert.Parent = TopPage.Root
	Else If Root.Parent.IsInitialized Then
		SweetAlert.Parent = Root.Parent
	Else
		SweetAlert.Parent = Root
	End If
	SweetAlert.Title = sTitle
	SweetAlert.Text = sText
	SweetAlert.Icon = sIcon
	SweetAlert.AllowOutsideClick = bAllowOutside
	SweetAlert.ShowConfirmButton = True
	SweetAlert.ConfirmButtonText = "OK"
	SweetAlert.ShowCancelButton = False
	SweetAlert.ShowDenyButton = False
	SweetAlert.TimerMs = 0
	Wait For (SweetAlert.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
	Return Result
End Sub

Public Sub ShowSwalConfirm(sTitle As String, sText As String, sConfirmText As String, sCancelText As String) As ResumableSub
	Dim TopPage As B4XPageInfo = B4XPages.GetManager.GetTopPage
	If TopPage <> Null And TopPage.Root.IsInitialized Then
		SweetAlert.Parent = TopPage.Root
	Else If Root.Parent.IsInitialized Then
		SweetAlert.Parent = Root.Parent
	Else
		SweetAlert.Parent = Root
	End If
	SweetAlert.Title = sTitle
	SweetAlert.Text = sText
	SweetAlert.Icon = "question"
	SweetAlert.AllowOutsideClick = False
	SweetAlert.ShowConfirmButton = True
	SweetAlert.ConfirmButtonText = sConfirmText
	SweetAlert.ShowCancelButton = True
	SweetAlert.CancelButtonText = sCancelText
	SweetAlert.ShowDenyButton = False
	SweetAlert.TimerMs = 0
	Wait For (SweetAlert.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
	Return Result
End Sub

Public Sub ShowToastAlert(sTitle As String, sText As String, sAlertVariant As String, iDurationMs As Int, sPosition As String) As B4XDaisyAlert
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
	alert.SetTitle(sTitle)
	alert.SetText(sText)
	alert.SetVariant(sAlertVariant)
	alert.SetStyle("solid")
	alert.SetIconVisible(True)
	alert.SetIconSize("6")
	alert.SetShadow("md")
	alert.SetRoundedBox(True)
	alert.Tag = alert

	Dim alertWidth As Int
	Dim alertLeft As Int
	Dim alertTop As Int = 16dip

	Dim pos As String = sPosition.ToLowerCase
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

	If iDurationMs > 0 Then
		DismissAlertAfterDelay(alert, iDurationMs)
	End If

	Return alert
End Sub

Public Sub ShowToast(sMessage As String, bLongDuration As Boolean) As B4XDaisyAlert
	Dim iDuration As Int
	If bLongDuration Then iDuration = 3500 Else iDuration = 2500
	Return ShowToastAlert("", sMessage, "info", iDuration, "bottom-center")
End Sub

Public Sub ShowToastError(sMessage As String, bLongDuration As Boolean) As B4XDaisyAlert
	Dim iDuration As Int
	If bLongDuration Then iDuration = 3500 Else iDuration = 2500
	Return ShowToastAlert("Error", sMessage, "error", iDuration, "bottom-center")
End Sub

Public Sub ShowToastSuccess(sMessage As String, bLongDuration As Boolean) As B4XDaisyAlert
	Dim iDuration As Int
	If bLongDuration Then iDuration = 3500 Else iDuration = 2500
	Return ShowToastAlert("Success", sMessage, "success", iDuration, "bottom-center")
End Sub

Public Sub ShowToastWarning(sMessage As String, bLongDuration As Boolean) As B4XDaisyAlert
	Dim iDuration As Int
	If bLongDuration Then iDuration = 3500 Else iDuration = 2500
	Return ShowToastAlert("Warning", sMessage, "warning", iDuration, "bottom-center")
End Sub

Private Sub DismissAlertAfterDelay(vAlert1 As B4XDaisyAlert, iDelayMs As Int)
	Sleep(iDelayMs)
	Try
		If vAlert1 = ActiveAlert Then
			vAlert1.RemoveViewFromParent
			ActiveAlert = Null
		End If
	Catch
		Log("B4XMainPage.DismissAlertAfterDelay: " & LastException.Message)
	End Try
End Sub

Private Sub GlobalAlert_Click(oTag As Object)
	Dim alert As B4XDaisyAlert = oTag
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

Public Sub PageInStack(sPageID As String) As Boolean
	Dim idxPOs As Int = B4XPages.GetManager.mStackOfPageIds.AsList.IndexOf(sPageID)
	If idxPOs = -1 Then
		Return False
	End If
	Return True
End Sub
