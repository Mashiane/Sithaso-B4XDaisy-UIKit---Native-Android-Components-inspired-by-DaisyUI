B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.70
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	ShowDeleteDialog
End Sub

Private Sub ShowDeleteDialog
	Dim swal As B4XDaisySweetAlert
	swal.Initialize(Me, Root, "swal")
	swal.Title = "Delete item?"
	swal.Text = "This action cannot be undone. Are you sure you want to proceed?"
	swal.Icon = "warning"
	swal.ShowCancelButton = True
	swal.ConfirmButtonText = "Delete"
	swal.CancelButtonText = "Cancel"
	swal.AllowOutsideClick = True

	Wait For (swal.ShowAsync) Complete (Result As B4XDaisySweetAlertResult)
	If Result.IsConfirmed Then
		Log("Item deleted")
	End If
End Sub
