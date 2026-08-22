B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#Region Events
#End Region

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	Private swalText As B4XDaisySweetAlert
	Private swalPassword As B4XDaisySweetAlert
	Private swalTextarea As B4XDaisySweetAlert
	Private swalNumber As B4XDaisySweetAlert
	Private swalTel As B4XDaisySweetAlert
	Private swalRange As B4XDaisySweetAlert
	Private swalRating As B4XDaisySweetAlert
	Private swalSelect As B4XDaisySweetAlert
	Private swalRadioGroup As B4XDaisySweetAlert
	Private swalCheckGroup As B4XDaisySweetAlert
	Private swalToggleGroup As B4XDaisySweetAlert
	Private swalCheckSingle As B4XDaisySweetAlert
	Private swalToggleMulti As B4XDaisySweetAlert

	Private btnText As B4XDaisyButton
	Private btnPassword As B4XDaisyButton
	Private btnTextarea As B4XDaisyButton
	Private btnNumber As B4XDaisyButton
	Private btnTel As B4XDaisyButton
	Private btnRange As B4XDaisyButton
	Private btnRating As B4XDaisyButton
	Private btnSelect As B4XDaisyButton
	Private btnRadioGroup As B4XDaisyButton
	Private btnCheckGroup As B4XDaisyButton
	Private btnToggleGroup As B4XDaisyButton
	Private btnCheckSingle As B4XDaisyButton
	Private btnToggleMulti As B4XDaisyButton
End Sub
#End Region

#Region Initialization
Public Sub Initialize
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	Dim y As Int = pageScroll.PagePadding
	y = BuildSingleInputsSection(y)
	y = BuildGroupInputsSection(y)
	y = BuildMultipleSection(y)
	pageScroll.AutoFit
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region UI Builders
Private Sub BuildSingleInputsSection(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart

	y = pageScroll.AddSectionTitle("1. Single Input Prompts", y, False)

	btnText.Initialize(Me, "btnText")
	btnText.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnText.setText("Show Text Input Prompt")
	btnText.setVariant("primary")
	y = y + 40dip + gap

	btnPassword.Initialize(Me, "btnPassword")
	btnPassword.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnPassword.setText("Show Required Password Prompt")
	btnPassword.setVariant("secondary")
	y = y + 40dip + gap

	btnTextarea.Initialize(Me, "btnTextarea")
	btnTextarea.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnTextarea.setText("Show Textarea Prompt")
	btnTextarea.setVariant("neutral")
	y = y + 40dip + gap

	btnNumber.Initialize(Me, "btnNumber")
	btnNumber.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnNumber.setText("Show Number Prompt")
	btnNumber.setVariant("info")
	y = y + 40dip + gap

	btnTel.Initialize(Me, "btnTel")
	btnTel.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnTel.setText("Show Telephone Prompt")
	btnTel.setVariant("success")
	y = y + 40dip + gap

	btnRange.Initialize(Me, "btnRange")
	btnRange.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnRange.setText("Show Range Prompt")
	btnRange.setVariant("warning")
	y = y + 40dip + gap

	btnRating.Initialize(Me, "btnRating")
	btnRating.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnRating.setText("Show Rating Prompt")
	btnRating.setVariant("accent")
	y = y + 40dip + gap

	btnSelect.Initialize(Me, "btnSelect")
	btnSelect.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnSelect.setText("Show Select Dropdown Prompt")
	btnSelect.setVariant("accent")
	y = y + 40dip + gap

	Return y
End Sub

Private Sub BuildGroupInputsSection(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart

	y = pageScroll.AddSectionTitle("2. Group Selection Prompts", y, False)

	btnRadioGroup.Initialize(Me, "btnRadioGroup")
	btnRadioGroup.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnRadioGroup.setText("Show Radio Group Prompt")
	btnRadioGroup.setVariant("info")
	y = y + 40dip + gap

	btnCheckGroup.Initialize(Me, "btnCheckGroup")
	btnCheckGroup.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnCheckGroup.setText("Show Checkbox Group Prompt")
	btnCheckGroup.setVariant("success")
	y = y + 40dip + gap

	btnToggleGroup.Initialize(Me, "btnToggleGroup")
	btnToggleGroup.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnToggleGroup.setText("Show Toggle Group Prompt")
	btnToggleGroup.setVariant("warning")
	y = y + 40dip + gap

	Return y
End Sub

Private Sub BuildMultipleSection(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart

	y = pageScroll.AddSectionTitle("3. Multiple Flag (Single vs Multi Select)", y, False)

	btnCheckSingle.Initialize(Me, "btnCheckSingle")
	btnCheckSingle.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnCheckSingle.setText("Show Single-Select Checkbox Prompt")
	btnCheckSingle.setVariant("primary")
	y = y + 40dip + gap

	btnToggleMulti.Initialize(Me, "btnToggleMulti")
	btnToggleMulti.AddToParent(pnlHost, pad, y, maxW, 40dip)
	btnToggleMulti.setText("Show Multi-Select Toggle Prompt")
	btnToggleMulti.setVariant("secondary")
	y = y + 40dip + gap

	Return y
End Sub
#End Region

#Region Button Events
Private Sub btnText_Click(Tag As Object)
	swalText.Initialize(Me, Root, "swalText")
	swalText.setTitle("What is your name?")
	swalText.setIcon("question")
	swalText.setInputType("text")
	swalText.setInputPlaceholder("Enter full name...")
	swalText.setShowCancelButton(True)

	Wait For (swalText.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Hello, " & res.Value & "!")
	Else
		ShowToast("Cancelled text prompt.")
	End If
End Sub

Private Sub btnPassword_Click(Tag As Object)
	swalPassword.Initialize(Me, Root, "swalPassword")
	swalPassword.setTitle("Enter Password")
	swalPassword.setIcon("warning")
	swalPassword.setInputType("password")
	swalPassword.setInputPlaceholder("Password...")
	swalPassword.setInputRequired(True)
	swalPassword.setInputErrorMessage("Password cannot be empty!")
	swalPassword.setShowCancelButton(True)

	Wait For (swalPassword.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Password confirmed: " & res.Value)
	Else
		ShowToast("Password prompt cancelled.")
	End If
End Sub

' Textarea: multi-line text input. Demonstrates the textarea InputType with a
' custom error message (InputErrorMessage) shown when required and left empty.
Private Sub btnTextarea_Click(Tag As Object)
	swalTextarea.Initialize(Me, Root, "swalTextarea")
	swalTextarea.setTitle("Tell us about yourself")
	swalTextarea.setIcon("info")
	swalTextarea.setInputType("textarea")
	swalTextarea.setInputPlaceholder("Write your bio here...")
	swalTextarea.setInputRequired(True)
	swalTextarea.setInputErrorMessage("Bio cannot be empty!")
	swalTextarea.setShowCancelButton(True)

	Wait For (swalTextarea.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Bio: " & res.Value)
	Else
		ShowToast("Textarea prompt cancelled.")
	End If
End Sub

' Number: numeric text input. setInputValue pre-fills the field.
Private Sub btnNumber_Click(Tag As Object)
	swalNumber.Initialize(Me, Root, "swalNumber")
	swalNumber.setTitle("How many tickets?")
	swalNumber.setIcon("question")
	swalNumber.setInputType("number")
	swalNumber.setInputPlaceholder("e.g. 2")
	swalNumber.setInputValue("2")
	swalNumber.setInputRequired(True)
	swalNumber.setInputErrorMessage("Please enter a number.")
	swalNumber.setShowCancelButton(True)

	Wait For (swalNumber.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Tickets: " & res.Value)
	Else
		ShowToast("Number prompt cancelled.")
	End If
End Sub

' Telephone: tel-typed text input.
Private Sub btnTel_Click(Tag As Object)
	swalTel.Initialize(Me, Root, "swalTel")
	swalTel.setTitle("Contact Number")
	swalTel.setIcon("info")
	swalTel.setInputType("tel")
	swalTel.setInputPlaceholder("+27 82 000 0000")
	swalTel.setInputRequired(True)
	swalTel.setInputErrorMessage("Phone number is required.")
	swalTel.setShowCancelButton(True)

	Wait For (swalTel.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Phone: " & res.Value)
	Else
		ShowToast("Telephone prompt cancelled.")
	End If
End Sub

' Range: slider input. setInputValue pre-sets the thumb position.
Private Sub btnRange_Click(Tag As Object)
	swalRange.Initialize(Me, Root, "swalRange")
	swalRange.setTitle("Set Volume")
	swalRange.setIcon("info")
	swalRange.setInputType("range")
	swalRange.setInputMin(0)
	swalRange.setInputMax(100)
	swalRange.setInputStep(5)
	swalRange.setInputValue(50)
	swalRange.setShowCancelButton(True)

	Wait For (swalRange.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Volume: " & res.Value)
	Else
		ShowToast("Range prompt cancelled.")
	End If
End Sub

' Rating: star rating input. setInputValue pre-sets the star count.
Private Sub btnRating_Click(Tag As Object)
	swalRating.Initialize(Me, Root, "swalRating")
	swalRating.setTitle("Rate your experience")
	swalRating.setIcon("question")
	swalRating.setInputType("rating")
	swalRating.setInputValue(3)
	swalRating.setShowCancelButton(True)

	Wait For (swalRating.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Rating: " & res.Value & " stars")
	Else
		ShowToast("Rating prompt cancelled.")
	End If
End Sub

Private Sub btnSelect_Click(Tag As Object)
	swalSelect.Initialize(Me, Root, "swalSelect")
	swalSelect.setTitle("Choose Theme")
	swalSelect.setIcon("info")
	swalSelect.setInputType("select")
	swalSelect.setInputPlaceholder("Pick a theme...")

	Dim options As Map = CreateMap("light": "Light Mode", "dark": "Dark Mode", "cupcake": "Cupcake", "cyberpunk": "Cyberpunk")
	swalSelect.setInputOptions(options)
	swalSelect.setShowCancelButton(True)

	Wait For (swalSelect.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Selected theme: " & res.Value)
	Else
		ShowToast("Select prompt cancelled.")
	End If
End Sub

Private Sub btnRadioGroup_Click(Tag As Object)
	swalRadioGroup.Initialize(Me, Root, "swalRadioGroup")
	swalRadioGroup.setTitle("Shipping Method")
	swalRadioGroup.setIcon("question")
	swalRadioGroup.setInputType("radiogroup")

	Dim options As Map = CreateMap("std": "Standard Shipping (3-5 days)", "exp": "Express Shipping (1-2 days)", "same": "Same Day Delivery")
	swalRadioGroup.setInputOptions(options)
	swalRadioGroup.setShowCancelButton(True)

	Wait For (swalRadioGroup.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Radio selected: " & res.Value)
	Else
		ShowToast("Radio prompt cancelled.")
	End If
End Sub

Private Sub btnCheckGroup_Click(Tag As Object)
	swalCheckGroup.Initialize(Me, Root, "swalCheckGroup")
	swalCheckGroup.setTitle("Select Topics")
	swalCheckGroup.setIcon("info")
	swalCheckGroup.setInputType("checkboxgroup")
	swalCheckGroup.setInputMultiple(True)

	Dim options As Map = CreateMap("mobile": "Mobile Development", "web": "Web Design", "ai": "AI & Machine Learning", "cloud": "Cloud Computing")
	swalCheckGroup.setInputOptions(options)
	swalCheckGroup.setShowCancelButton(True)

	Wait For (swalCheckGroup.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Checkbox group selected: " & JoinList(res.Value))
	Else
		ShowToast("Checkbox group cancelled.")
	End If
End Sub

Private Sub btnToggleGroup_Click(Tag As Object)
	swalToggleGroup.Initialize(Me, Root, "swalToggleGroup")
	swalToggleGroup.setTitle("Layout View")
	swalToggleGroup.setIcon("info")
	swalToggleGroup.setInputType("togglegroup")

	Dim options As Map = CreateMap("grid": "Grid View", "list": "List View", "card": "Card View")
	swalToggleGroup.setInputOptions(options)
	swalToggleGroup.setShowCancelButton(True)

	Wait For (swalToggleGroup.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Toggle view: " & res.Value)
	Else
		ShowToast("Toggle prompt cancelled.")
	End If
End Sub

' Single-select checkbox group: Multiple=False (default) makes a checkbox
' group behave like a radio - only one item checked at a time. Result.Value
' is the selected option key (String), not a List.
Private Sub btnCheckSingle_Click(Tag As Object)
	swalCheckSingle.Initialize(Me, Root, "swalCheckSingle")
	swalCheckSingle.setTitle("Pick One Language")
	swalCheckSingle.setIcon("question")
	swalCheckSingle.setInputType("checkboxgroup")
	swalCheckSingle.setInputMultiple(False)
	swalCheckSingle.setInputRequired(True)
	swalCheckSingle.setInputErrorMessage("Please pick one language.")

	Dim options As Map = CreateMap("en": "English", "fr": "Francais", "es": "Espanol", "de": "Deutsch")
	swalCheckSingle.setInputOptions(options)
	swalCheckSingle.setShowCancelButton(True)

	Wait For (swalCheckSingle.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Single checkbox selected: " & res.Value)
	Else
		ShowToast("Single checkbox prompt cancelled.")
	End If
End Sub

' Multi-select toggle group: Multiple=True lets the user check several
' toggles at once. Result.Value is a List of selected option keys.
Private Sub btnToggleMulti_Click(Tag As Object)
	swalToggleMulti.Initialize(Me, Root, "swalToggleMulti")
	swalToggleMulti.setTitle("Select Notifications")
	swalToggleMulti.setIcon("info")
	swalToggleMulti.setInputType("togglegroup")
	swalToggleMulti.setInputMultiple(True)
	swalToggleMulti.setInputRequired(True)
	swalToggleMulti.setInputErrorMessage("Pick at least one notification.")

	Dim options As Map = CreateMap("email": "Email", "push": "Push", "sms": "SMS", "inapp": "In-App")
	swalToggleMulti.setInputOptions(options)
	swalToggleMulti.setShowCancelButton(True)

	Wait For (swalToggleMulti.ShowAsync) Complete (res As B4XDaisySweetAlertResult)
	If res.IsConfirmed Then
		ShowToast("Multi toggle selected: " & JoinList(res.Value))
	Else
		ShowToast("Multi toggle prompt cancelled.")
	End If
End Sub
#End Region

#Region Helpers
Private Sub ShowToast(Msg As String)
	B4XPages.MainPage.ShowToast(Msg, False)
End Sub

' Joins a List of selected option keys into a comma-separated string for
' display. Handles the multi-select (Multiple=True) SweetAlert result.
Private Sub JoinList(Val As Object) As String
	If Val = Null Then Return "(none)"
	If Val Is List Then
		Dim l As List = Val
		Dim sb As StringBuilder
		sb.Initialize
		For i = 0 To l.Size - 1
			If i > 0 Then sb.Append(", ")
			sb.Append("" & l.Get(i))
		Next
		Return sb.ToString
	End If
	Return "" & Val
End Sub
#End Region
