B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private PAGE_PAD As Int = 12dip
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	y = AddSectionTitle("1. Basic message", y, maxW)
	y = AddExampleButton("Basic Message", "btnBasic", y, maxW)

	y = AddSectionTitle("2. Title with text under", y, maxW)
	y = AddExampleButton("Title & Text", "btnTitleText", y, maxW)

	y = AddSectionTitle("3. Error icon + footer", y, maxW)
	y = AddExampleButton("Error Dialog", "btnError", y, maxW)

	y = AddSectionTitle("4. Dialog with three buttons", y, maxW)
	y = AddExampleButton("Three Buttons", "btnThree", y, maxW)

	y = AddSectionTitle("5. Auto close timer", y, maxW)
	y = AddExampleButton("Timed Alert", "btnTimer", y, maxW)

	y = AddSectionTitle("6. AJAX Loading state", y, maxW)
	y = AddExampleButton("Loading Alert", "btnLoading", y, maxW)

	y = AddSectionTitle("7. Close button + footer", y, maxW)
	y = AddExampleButton("Close + Footer", "btnCloseFooter", y, maxW)

	y = AddSectionTitle("8. Warning message", y, maxW)
	y = AddExampleButton("Warning Alert", "btnWarning", y, maxW)

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
	Dim title As B4XDaisyText
	title.Initialize(Me, "")
	title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
	title.Text = Text
	title.TextColor = xui.Color_RGB(30, 41, 59)
	title.TextSize = 16
	title.FontBold = True
	Return Y + 34dip
End Sub

Private Sub AddExampleButton(Text As String, Tag As String, Y As Int, Width As Int) As Int
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "DemoAction")
	btn.AddToParent(pnlHost, PAGE_PAD, Y, Width, 44dip)
	btn.Text = Text
	btn.Tag = Tag
	btn.Variant = "primary"
	btn.Style = "outline"
	Return Y + 56dip
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

' -
' SWEETALERT 2 DEMOS
' -
Private Sub DemoAction_Click(Tag As Object)
	Dim action As String = Tag
	Dim swal As B4XDaisySweetAlert
	swal.Initialize(Me, Root, "swal")
	
	Select Case action
		Case "btnBasic"
			swal.Title = "Any fool can use a computer"
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			B4XPages.MainPage.ShowToast("Basic alert dismissed", False)
			
		Case "btnTitleText"
			swal.Title = "The Internet?"
			swal.Text = "That thing is still around?"
			swal.Icon = "question"
			swal.ShowCancelButton = True
			swal.ConfirmButtonText = "Yes"
			swal.CancelButtonText = "No"
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			If Result.IsConfirmed Then
				B4XPages.MainPage.ShowToast("User clicked: Yes", False)
			Else
				B4XPages.MainPage.ShowToast("User clicked: No", False)
			End If			
		Case "btnError"
			swal.Icon = "error"
			swal.Title = "Oops..."
			swal.Text = "Something went wrong!"
			swal.ShowCancelButton = True
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			If Result.IsConfirmed Then
				B4XPages.MainPage.ShowToast("Confirmed error dialog", False)
			Else
				B4XPages.MainPage.ShowToast("Error dialog dismissed/cancelled", False)
			End If
			
		Case "btnThree"
			swal.Title = "Do you want to save the changes?"
			swal.ShowDenyButton = True
			swal.ShowCancelButton = True
			swal.ConfirmButtonText = "Save"
			swal.DenyButtonText = "Don't save"
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			
			If Result.IsConfirmed Then
				Dim swalSuccess As B4XDaisySweetAlert
				swalSuccess.Initialize(Me, Root, "swal")
				swalSuccess.Title = "Saved!"
				swalSuccess.Icon = "success"
				Wait For (swalSuccess.ShowAsync) Complete (Res2 As B4XDaisySweetAlertResult)
				B4XPages.MainPage.ShowToast("Saved success dismissed", False)
			Else If Result.IsDenied Then
				Dim swalInfo As B4XDaisySweetAlert
				swalInfo.Initialize(Me, Root, "swal")
				swalInfo.Title = "Changes are not saved"
				swalInfo.Icon = "info"
				Wait For (swalInfo.ShowAsync) Complete (Res3 As B4XDaisySweetAlertResult)
				B4XPages.MainPage.ShowToast("Changes info dismissed", False)
			Else
				B4XPages.MainPage.ShowToast("Three-button dialog cancelled", False)
			End If
			
		Case "btnTimer"
			swal.Title = "Auto close alert!"
			swal.Text = "I will close in 2 seconds."
			swal.TimerMs = 2000
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			
			If Result.Dismiss = "timer" Then
				B4XPages.MainPage.ShowToast("Closed by the timer", False)
			Else
				B4XPages.MainPage.ShowToast($"Timed alert closed by: ${Result.Dismiss}"$, False)
			End If
			
		Case "btnLoading"
			' Emulates the AJAX Request Example
			swal.Initialize(Me, Root, "swalLoading")
			swal.showLoading
			swal.Title = "Fetching data..."
			swal.Text = "Please wait while we process this."
			
			' Start background simulation
			SimulateLoading(swal)
			
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			B4XPages.MainPage.ShowToast("Loading demo alert finished", False)
 
		Case "btnCloseFooter"
			swal.Title = "Terms of service"
			swal.Text = "Do you accept the terms?"
			swal.ShowCloseButton = True
			swal.Footer = "Read our full terms"
			swal.ShowCancelButton = True
			swal.ConfirmButtonText = "Accept"
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			If Result.IsConfirmed Then
				B4XPages.MainPage.ShowToast("Terms accepted", False)
			Else
				B4XPages.MainPage.ShowToast($"Terms dismissed/cancelled by: ${Result.Dismiss}"$, False)
			End If
			
		Case "btnWarning"
			swal.Icon = "warning"
			swal.Title = "Warning"
			swal.Text = "You are about to delete this file!"
			swal.ShowCancelButton = True
			swal.ConfirmButtonText = "Delete it!"
			swal.CancelButtonText = "Cancel"
			Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
			If Result.IsConfirmed Then
				B4XPages.MainPage.ShowToast("File deleted", False)
			Else
				B4XPages.MainPage.ShowToast("Cancelled", False)
			End If
	End Select
End Sub

Private Sub SimulateLoading(swal As B4XDaisySweetAlert)
	Sleep(2000)
	swal.hideLoading
	swal.Icon = "success"
	swal.Title = "Success!"
	swal.Text = "Data fetched successfully."
End Sub
