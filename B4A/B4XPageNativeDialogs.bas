B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	
	' Date and Time inputs
	Private inpDateDefault As B4XDaisyInput
	Private inpDateCustom As B4XDaisyInput
	Private inpDateRestricted As B4XDaisyInput
	Private inpTime24 As B4XDaisyInput
	Private inpTime12 As B4XDaisyInput
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear

	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' 1. Date Pickers
	y = pageScroll.AddSectionTitle("DaisyInput Date Pickers", y, False)

	inpDateDefault.Initialize(Me, "inpDateDefault")
	inpDateDefault.AddToParent(pnlHost, padding, y, maxW, 0)
	inpDateDefault.LabelAbove = "Birth Date (Default yyyy-MM-dd)"
	inpDateDefault.Placeholder = "Select a date..."
	inpDateDefault.InputType = "date"
	inpDateDefault.DateFormat = "yyyy-MM-dd"
	inpDateDefault.Variant = "primary"
	y = y + inpDateDefault.GetActualHeight + gap

	inpDateCustom.Initialize(Me, "inpDateCustom")
	inpDateCustom.AddToParent(pnlHost, padding, y, maxW, 0)
	inpDateCustom.LabelAbove = "Appointment Date (dd/MM/yyyy)"
	inpDateCustom.Placeholder = "dd/MM/yyyy"
	inpDateCustom.InputType = "date"
	inpDateCustom.DateFormat = "dd/MM/yyyy"
	inpDateCustom.Variant = "secondary"
	y = y + inpDateCustom.GetActualHeight + gap

	inpDateRestricted.Initialize(Me, "inpDateRestricted")
	inpDateRestricted.AddToParent(pnlHost, padding, y, maxW, 0)
	inpDateRestricted.LabelAbove = "Event Date (Restricted to 2026)"
	inpDateRestricted.Placeholder = "Select date in 2026..."
	inpDateRestricted.InputType = "date"
	inpDateRestricted.DateFormat = "yyyy-MM-dd"
	inpDateRestricted.MinDate = "2026-01-01"
	inpDateRestricted.MaxDate = "2026-12-31"
	inpDateRestricted.Variant = "accent"
	y = y + inpDateRestricted.GetActualHeight + gap + 8dip

	' 2. Time Pickers
	y = pageScroll.AddSectionTitle("DaisyInput Time Pickers", y, False)

	inpTime24.Initialize(Me, "inpTime24")
	inpTime24.AddToParent(pnlHost, padding, y, maxW, 0)
	inpTime24.LabelAbove = "Meeting Time (24-Hour)"
	inpTime24.Placeholder = "HH:mm"
	inpTime24.InputType = "time"
	inpTime24.Is24Hours = True
	inpTime24.Variant = "info"
	y = y + inpTime24.GetActualHeight + gap

	inpTime12.Initialize(Me, "inpTime12")
	inpTime12.AddToParent(pnlHost, padding, y, maxW, 0)
	inpTime12.LabelAbove = "Reminder Time (12-Hour AM/PM)"
	inpTime12.Placeholder = "hh:mm AM/PM"
	inpTime12.InputType = "time"
	inpTime12.Is24Hours = False
	inpTime12.Variant = "success"
	y = y + inpTime12.GetActualHeight + gap

	pageScroll.AutoFit
End Sub
#End Region

#Region Event Handlers
Private Sub inpDateDefault_DateSelected (DateTick As Long, FormattedDate As String)
	B4XPages.MainPage.ShowToastSuccess("Selected Date: " & FormattedDate, False)
End Sub

Private Sub inpDateCustom_DateSelected (DateTick As Long, FormattedDate As String)
	B4XPages.MainPage.ShowToastSuccess("Custom Date: " & FormattedDate, False)
End Sub

Private Sub inpDateRestricted_DateSelected (DateTick As Long, FormattedDate As String)
	B4XPages.MainPage.ShowToastSuccess("Restricted Date: " & FormattedDate, False)
End Sub

Private Sub inpTime24_TimeSelected (Hour As Int, Minute As Int)
	B4XPages.MainPage.ShowToast("24h Time: " & NumberFormat(Hour, 2, 0) & ":" & NumberFormat(Minute, 2, 0), False)
End Sub

Private Sub inpTime12_TimeSelected (Hour As Int, Minute As Int)
	Dim ampm As String = IIf(Hour < 12, "AM", "PM")
	Dim h12 As Int = Hour Mod 12
	If h12 = 0 Then h12 = 12
	B4XPages.MainPage.ShowToast("12h Time: " & NumberFormat(h12, 2, 0) & ":" & NumberFormat(Minute, 2, 0) & " " & ampm, False)
End Sub
#End Region
