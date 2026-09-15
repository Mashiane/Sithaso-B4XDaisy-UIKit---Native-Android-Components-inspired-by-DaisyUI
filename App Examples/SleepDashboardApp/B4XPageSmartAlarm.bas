B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.70
@EndOfDesignText@

#IgnoreWarnings:12,9
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI

	' Page Frame & Navigation (Navbar only - sub-page with back button)
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost    As B4XView
	Private navbar     As B4XDaisyNavbar

	Private pad        As Int
	Private gap        As Int
	Private maxW       As Int
	Private y          As Int
	Private NAVBAR_H   As Int = 56dip

	' Form controls
	Private alarmTime  As B4XDaisyInput
	Private saveBtn    As B4XDaisyButton
	Private backBtn    As B4XDaisyButton
	Private lastWidth  As Int = 0
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(vRoot1 As B4XView)
	Root = vRoot1
	Root.RemoveAllViews

	BuildScroll
	BuildNavbar
	RenderContent
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(iWidth As Int, iHeight As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, iWidth, NAVBAR_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(iWidth, iHeight - NAVBAR_H)
		If lastWidth <> iWidth Or pnlHost.NumberOfViews = 0 Then
			lastWidth = iWidth
			RenderContent
		End If
	End If
End Sub

#If B4A
Public Sub IME_HeightChanged(iNewHeight As Int, iOldHeight As Int)
	If pageScroll.IsInitialized Then pageScroll.IME_HeightChanged(iNewHeight, iOldHeight, alarmTime)
End Sub
#End If

Private Sub BuildScroll
	Dim scrollTop As Int = NAVBAR_H
	Dim scrollH   As Int = Root.Height - NAVBAR_H
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, scrollTop, Root.Width, scrollH)
	pageScroll.SendToBack
	pnlHost = pageScroll.Panel
End Sub

Private Sub BuildNavbar
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
	navbar.BringToFront
	navbar.Title = "Smart Alarm Settings"
	navbar.Variant = "primary"
	navbar.BackVisible = True
	navbar.BackLabel = ""
End Sub

Private Sub RenderContent
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	Try
		' === Section: Alarm Configuration ===
		y = pageScroll.AddSectionTitle("Wake-up Preferences", y, False) + 6dip

		alarmTime.Initialize(Me, "alarmTime")
		alarmTime.LabelAbove = "Target Wake-up Time (HH:MM)"
		alarmTime.Placeholder = "07:30"
		alarmTime.Text = "07:30"
		alarmTime.Variant = "primary"
		alarmTime.AddToParent(pnlHost, pad, y, maxW, 48dip)
		y = y + alarmTime.GetComputedHeight + (gap * 2)

		' === Section: Actions ===
		saveBtn.Initialize(Me, "saveBtn")
		saveBtn.Text = "Save Alarm Settings"
		saveBtn.Variant = "primary"
		saveBtn.Size = "lg"
		saveBtn.AddToParent(pnlHost, pad, y, maxW, 48dip)
		y = y + saveBtn.GetComputedHeight + gap

		backBtn.Initialize(Me, "backBtn")
		backBtn.Text = "Cancel & Return"
		backBtn.Variant = "neutral"
		backBtn.Size = "md"
		backBtn.AddToParent(pnlHost, pad, y, maxW, 44dip)
		y = y + backBtn.GetComputedHeight + gap

	Catch
		Log("B4XPageSmartAlarm.RenderContent: " & LastException.Message)
	End Try

	pageScroll.AutoFit
End Sub

Private Sub navbar_Back (oTag As Object)
	Dim mp As B4XMainPage = B4XPages.MainPage
	mp.ClosePageWithLoader(Me)
End Sub

Private Sub saveBtn_Click (oTag As Object)
	Dim mp As B4XMainPage = B4XPages.MainPage
	Dim sTime As String = alarmTime.Text.Trim
	If sTime = "" Then
		mp.ShowSwalAlert("Invalid Time", "Please enter a valid alarm time.", "warning", True)
		Return
	End If

	Dim sf As Object = mp.ShowSwalAlert("Alarm Saved", $"Smart alarm set for ${sTime}."$, "success", True)
	Wait For (sf) Complete (Result As B4XDaisySweetAlertResult)
	mp.ClosePageWithLoader(Me)
End Sub

Private Sub backBtn_Click (oTag As Object)
	Dim mp As B4XMainPage = B4XPages.MainPage
	mp.ClosePageWithLoader(Me)
End Sub
