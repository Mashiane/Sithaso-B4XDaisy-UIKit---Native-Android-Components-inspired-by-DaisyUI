B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
    
	' Layout
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	' Pickers
	Private pickerBasic As B4XDaisyPicker
	Private pickerSlots As B4XDaisyPicker
	Private pickerThemed As B4XDaisyPicker
	Private pickerInModal As B4XDaisyPicker
	Private pickerDate As B4XDaisyPicker
	Private pickerTime As B4XDaisyPicker
	Private pickerDateTime As B4XDaisyPicker
	Private pickerMulti As B4XDaisyPicker
	Private pickerHighlight As B4XDaisyPicker
	Private pickerTime12 As B4XDaisyPicker
	Private pickerRounded As B4XDaisyPicker
	Private pickerShadow As B4XDaisyPicker
	Private pickerSetGet As B4XDaisyPicker
	Private pickerDisplay As B4XDaisyPicker
	Private btnSetRandom As B4XDaisyButton
	Private btnGetValue As B4XDaisyButton
    
	' Modal & Triggers
	Private modalContainer As B4XDaisyModal
	Private btnOpenModal As B4XDaisyButton

	' Date Picker Sheet Modal
	Private smDatePicker As B4XDaisySheetModal
	Private pickerDateSheet As B4XDaisyPicker
	Private btnPickDate As B4XDaisyButton
	Private activeDateTrigger As B4XDaisyButton

	' SetOptionDisabled demo
	Private btnDisableCat As B4XDaisyButton
	Private catDisabled As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the demo page.
''' </summary>
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	' Setup PageScroller
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	' Toast migrated to B4XMainPage central methods
    
	' Setup Modal Container as a dedicated full-screen overlay panel on Root.
	' IMPORTANT: do NOT pass Root as the modal base - setVisible(False) would hide
	' the entire page. AddToParent gives the modal its own panel (see B4XPageModal).
	modalContainer.Initialize(Me, "modalContainer")
	modalContainer.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	modalContainer.Title = "Select Ingredient"
	modalContainer.ClickOutsideToClose = True
	modalContainer.Visible = False
	RenderExamples(Root.Width, Root.Height)
	BuildDatePickerSheet
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders the UI and layout using PageScroll.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' ----------------------------------------------------
	' 1. Basic Inline Picker
	' Demonstrates standard inline rendering with multiple columns.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("1. Basic Inline Picker", y, False)
    
	' Inline picker sized to its computed height (VisibleItems * item height) so no row is clipped.
	pickerBasic.Initialize(Me, "pickerBasic")
	pickerBasic.AddToParent(pnlHost, padding, y, maxW, pickerBasic.GetComputedHeight)
	pickerBasic.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
	pickerBasic.AddColumn("pets", "", "", False)
	pickerBasic.AddOption("pets", "Dog", "dog")
	pickerBasic.AddOption("pets", "Cat", "cat")
	pickerBasic.AddOption("pets", "Bird", "bird")
	pickerBasic.AddOption("pets", "Lizard", "lizard")
	pickerBasic.AddOption("pets", "Chinchilla", "chinchilla")
	pickerBasic.Refresh
    
	y = y + pickerBasic.GetComputedHeight + gap

	btnDisableCat.Initialize(Me, "btnDisableCat")
	btnDisableCat.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnDisableCat.Text = "Disable 'Cat' option"
	btnDisableCat.Variant = "secondary"
	y = y + btnDisableCat.GetComputedHeight + gap

	' ----------------------------------------------------
	' 2. Picker inside a Modal
	' Mimics the legacy popup dialog by wrapping the inline picker in a modal.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("2. Open Picker in a Modal", y, False)
    
	btnOpenModal.Initialize(Me, "btnOpenModal")
	btnOpenModal.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnOpenModal.Text = "Open Modal Picker"
	btnOpenModal.Variant = "primary"
    
	' Render the internal modal content
	BuildModalContent
    
	y = y + btnOpenModal.GetComputedHeight + gap

	' ----------------------------------------------------
	' 3. Prefix & Suffix Content
	' Demonstrates injecting text slots on either side of the option wheel.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("3. Prefix & Suffix Content", y, False)
    
	pickerSlots.Initialize(Me, "pickerSlots")
	pickerSlots.AddToParent(pnlHost, padding, y, maxW, pickerSlots.GetComputedHeight)
	pickerSlots.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
	' Add column with a '$' Prefix and 'USD' Suffix
	pickerSlots.AddColumn("currency", "$", "USD", False)
	pickerSlots.AddOption("currency", "1", 1)
	pickerSlots.AddOption("currency", "2", 2)
	pickerSlots.AddOption("currency", "3", 3)
	pickerSlots.AddOption("currency", "4", 4)
	pickerSlots.AddOption("currency", "5", 5)
	pickerSlots.Refresh
    
	y = y + pickerSlots.GetComputedHeight + gap

	' ----------------------------------------------------
	' 4. Themed Picker
	' Customizing highlight and fade overlays.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("4. Themed Picker", y, False)
    
	pickerThemed.Initialize(Me, "pickerThemed")
	' Override CSS variables equivalent to --fade-background-rgb and --highlight-background
	pickerThemed.FadeBackground = 0xFFFEE2E2
	pickerThemed.HighlightBackground = 0x4DFCA5A5
	pickerThemed.HighlightRadius = 12
	pickerThemed.AddToParent(pnlHost, padding, y, maxW, pickerThemed.GetComputedHeight)
	pickerThemed.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
	pickerThemed.AddColumn("color", "", "", False)
	pickerThemed.AddOption("color", "Red", "red")
	pickerThemed.AddOption("color", "Blue", "blue")
	pickerThemed.AddOption("color", "Green", "green")
	pickerThemed.Refresh
    
	y = y + pickerThemed.GetComputedHeight + gap

	' ----------------------------------------------------
	' 5. Date Picker (auto columns from InputFormat)
	' PickerType=auto + InputFormat="Y-m-d" generates Year/Month/Day columns; GetValue returns Y-m-d.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("5. Date Picker (Y-m-d)", y, False)
    
	pickerDate.Initialize(Me, "pickerDate")
	pickerDate.PickerType = "auto"
	pickerDate.InputFormat = "Y-m-d"
	pickerDate.AddToParent(pnlHost, padding, y, maxW, pickerDate.GetComputedHeight)
	pickerDate.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
    
	y = y + pickerDate.GetComputedHeight + gap

	' ----------------------------------------------------
	' 6. Time Picker (auto columns from InputFormat)
	' PickerType=auto + InputFormat="H:i" generates Hour/Minute columns; GetValue returns HH:MM.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("6. Time Picker (H:i)", y, False)
    
	pickerTime.Initialize(Me, "pickerTime")
	pickerTime.PickerType = "auto"
	pickerTime.InputFormat = "H:i"
	pickerTime.AddToParent(pnlHost, padding, y, maxW, pickerTime.GetComputedHeight)
	pickerTime.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
    
	y = y + pickerTime.GetComputedHeight + gap

	' ----------------------------------------------------
	' 7. Date-Time Picker (auto columns from InputFormat)
	' PickerType=auto + InputFormat="Y-m-d H:i" generates Year/Month/Day/Hour/Minute; GetValue returns Y-m-d H:i.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("7. Date-Time Picker (Y-m-d H:i)", y, False)
    
	pickerDateTime.Initialize(Me, "pickerDateTime")
	pickerDateTime.PickerType = "auto"
	pickerDateTime.InputFormat = "Y-m-d H:i"
	pickerDateTime.AddToParent(pnlHost, padding, y, maxW, pickerDateTime.GetComputedHeight)
	pickerDateTime.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
    
	y = y + pickerDateTime.GetComputedHeight + gap

	' ----------------------------------------------------
	' 8. Multi-Column with ColumnDelimiter (default type)
	' Two user-defined columns; GetValue joins values with the delimiter, e.g. "red-md".
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("8. Multi-Column (delimiter: -)", y, False)
    

	pickerMulti.Initialize(Me, "pickerMulti")
	pickerMulti.ColumnDelimiter = "-"
	pickerMulti.AddToParent(pnlHost, padding, y, maxW, pickerMulti.GetComputedHeight)
	pickerMulti.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
	' Column 1: Color
	pickerMulti.AddColumn("color", "", "", False)
	pickerMulti.AddOption("color", "Red", "red")
	pickerMulti.AddOption("color", "Green", "green")
	pickerMulti.AddOption("color", "Blue", "blue")
	' Column 2: Size
	pickerMulti.AddColumn("size", "", "", False)
	pickerMulti.AddOption("size", "Small", "sm")
	pickerMulti.AddOption("size", "Medium", "md")
	pickerMulti.AddOption("size", "Large", "lg")
	pickerMulti.Refresh
	' Per-column variant colors: tint each wheel with a DaisyUI variant.
	pickerMulti.SetColumnColorVariant("color", "primary")
	pickerMulti.SetColumnColorVariant("size", "secondary")
    
	y = y + pickerMulti.GetComputedHeight + gap

	' ----------------------------------------------------
	' 9. Primary Highlight (HighlightVariant)
	' The selected-item band uses the DaisyUI primary variant color.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("9. Primary Highlight", y, False)
    
	pickerHighlight.Initialize(Me, "pickerHighlight")
	pickerHighlight.HighlightVariant = "primary"
	pickerHighlight.AddToParent(pnlHost, padding, y, maxW, pickerHighlight.GetComputedHeight)
	pickerHighlight.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
	pickerHighlight.AddColumn("day", "", "", False)
	pickerHighlight.AddOption("day", "Monday", "Mon")
	pickerHighlight.AddOption("day", "Tuesday", "Tue")
	pickerHighlight.AddOption("day", "Wednesday", "Wed")
	pickerHighlight.AddOption("day", "Thursday", "Thu")
	pickerHighlight.AddOption("day", "Friday", "Fri")
	pickerHighlight.AddOption("day", "Saturday", "Sat")
	pickerHighlight.AddOption("day", "Sunday", "Sun")
	pickerHighlight.Refresh
    
	y = y + pickerHighlight.GetComputedHeight + gap

	' ----------------------------------------------------
	' 10. 12-Hour Time with AM/PM (flatpickr tokens h:i K)
	' h = 12-hour wheel, i = minutes, K = AM/PM wheel. GetValue returns e.g. 02:30 PM.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("10. 12-Hour Time (h:i K)", y, False)
    
	pickerTime12.Initialize(Me, "pickerTime12")
	pickerTime12.PickerType = "auto"
	pickerTime12.InputFormat = "h:i K"
	pickerTime12.AddToParent(pnlHost, padding, y, maxW, pickerTime12.GetComputedHeight)
	pickerTime12.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)
    
	y = y + pickerTime12.GetComputedHeight + gap

	' ----------------------------------------------------
	' 11. Rounded Corners (Rounded property)
	' The DaisyUI rounded token controls the corner radius of the picker root panel.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("11. Rounded Corners", y, False)
	
	pickerRounded.Initialize(Me, "pickerRounded")
	pickerRounded.Rounded = "rounded-2xl"
	pickerRounded.AddToParent(pnlHost, padding, y, maxW, pickerRounded.GetComputedHeight)
	' Paint a background that follows the same resolved corner radius.
	pickerRounded.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), pickerRounded.GetRoundedRadius)
	pickerRounded.AddColumn("shape", "", "", False)
	pickerRounded.AddOption("shape", "Circle", "circle")
	pickerRounded.AddOption("shape", "Square", "square")
	pickerRounded.AddOption("shape", "Triangle", "triangle")
	pickerRounded.AddOption("shape", "Hexagon", "hexagon")
	pickerRounded.AddOption("shape", "Star", "star")
	pickerRounded.Refresh
	
	y = y + pickerRounded.GetComputedHeight + gap

	' ----------------------------------------------------
	' 12. Shadow Elevation (Shadow property)
	' The DaisyUI shadow token casts an elevation shadow under the picker root panel.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("12. Shadow Elevation", y, False)
	
	pickerShadow.Initialize(Me, "pickerShadow")
	pickerShadow.Rounded = "rounded-xl"
	pickerShadow.Shadow = "lg"
	pickerShadow.AddToParent(pnlHost, padding, y, maxW, pickerShadow.GetComputedHeight)
	pickerShadow.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), pickerShadow.GetRoundedRadius)
	pickerShadow.AddColumn("level", "", "", False)
	pickerShadow.AddOption("level", "Low", "low")
	pickerShadow.AddOption("level", "Medium", "medium")
	pickerShadow.AddOption("level", "High", "high")
	pickerShadow.AddOption("level", "Maximum", "max")
	pickerShadow.AddOption("level", "Extreme", "extreme")
	pickerShadow.Refresh
	
	y = y + pickerShadow.GetComputedHeight + gap

	' ----------------------------------------------------
	' 13. Set & Get Values (Runtime, List-based)
	' SetValueList takes a B4X List of values (index 0 -> first column, 1 -> second, ...);
	' GetValueList returns the current selection as a List. The "Set Random" button builds
	' a random List from the picker's own option values, "Get Value" reads the List back.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("13. Set & Get Values (Runtime)", y, False)
	
	pickerSetGet.Initialize(Me, "pickerSetGet")
	pickerSetGet.AddToParent(pnlHost, padding, y, maxW, pickerSetGet.GetComputedHeight)
	pickerSetGet.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), pickerSetGet.GetRoundedRadius)
	pickerSetGet.AddColumn("color", "", "", False)
	pickerSetGet.AddOption("color", "Red", "red")
	pickerSetGet.AddOption("color", "Green", "green")
	pickerSetGet.AddOption("color", "Blue", "blue")
	pickerSetGet.AddColumn("size", "", "", False)
	pickerSetGet.AddOption("size", "Small", "sm")
	pickerSetGet.AddOption("size", "Medium", "md")
	pickerSetGet.AddOption("size", "Large", "lg")
	pickerSetGet.Refresh
	
	y = y + pickerSetGet.GetComputedHeight + gap

	btnSetRandom.Initialize(Me, "btnSetRandom")
	btnSetRandom.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnSetRandom.Text = "Set Random Value"
	btnSetRandom.Variant = "primary"
	
	y = y + btnSetRandom.GetComputedHeight + gap

	btnGetValue.Initialize(Me, "btnGetValue")
	btnGetValue.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnGetValue.Text = "Get Value"
	btnGetValue.Variant = "secondary"
	
	y = y + btnGetValue.GetComputedHeight + gap

	' ----------------------------------------------------
	' 12. Date Picker in a Sheet Modal
	' A button opens a bottom Sheet Modal with a toolbar (Cancel left / Apply right)
	' and a 3-column date picker: Year (4-digit), Month (short name), Day (2-digit).
	' Apply reads the picker and writes the date back to the activating button.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("12. Date Picker in a Sheet Modal", y, False)

	btnPickDate.Initialize(Me, "btnPickDate")
	btnPickDate.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnPickDate.Text = "Pick a date"
	btnPickDate.Variant = "primary"
	' Tag carries the activating button so Apply can write the date back to it.
	btnPickDate.Tag = btnPickDate

	y = y + btnPickDate.GetComputedHeight + gap

	' ----------------------------------------------------
	' 13. Display Format (auto picker)
	' InputFormat controls the RETURNED value ("Y-m-d" -> 2026-07-05);
	' DisplayFormat controls how the wheels DISPLAY each value ("F j" -> full month
	' name "July", day without leading zero "5"), independent of the returned value.
	' ----------------------------------------------------
	y = pageScroll.AddSectionTitle("13. Display Format (auto picker)", y, False)

	pickerDisplay.Initialize(Me, "pickerDisplay")
	pickerDisplay.PickerType = "auto"
	pickerDisplay.InputFormat = "Y-m-d"
	' Wheels show full month name + no-leading-zero day; GetValue still returns 2026-07-05.
	pickerDisplay.DisplayFormat = "F j"
	pickerDisplay.AddToParent(pnlHost, padding, y, maxW, pickerDisplay.GetComputedHeight)
	pickerDisplay.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 8dip)

	y = y + pickerDisplay.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

Private Sub BuildModalContent
	' RenderExamples re-runs on resize, so clear any previous modal content first
	' to avoid stacking duplicate picker bodies / action buttons.
	modalContainer.ClearActions
	modalContainer.ClearBody

	' Add the picker directly to the modal body container (pageModal pattern),
	' sized to the body width. No host panel needed.
	Dim body As B4XView = modalContainer.getBodyContainer
	Dim bodyW As Int = Max(1dip, body.Width)
		pickerInModal.Initialize(Me, "pickerInModal")
	Dim bodyH As Int = pickerInModal.GetComputedHeight
	pickerInModal.AddToParent(body, 0, 0, bodyW, bodyH)
	pickerInModal.AddColumn("ingredients", "", "", False)
	pickerInModal.AddOption("ingredients", "Tomato", "tomato")
	pickerInModal.AddOption("ingredients", "Avocado", "avocado")
	pickerInModal.AddOption("ingredients", "Onion", "onion")
	pickerInModal.AddOption("ingredients", "Potato", "potato")
	pickerInModal.AddOption("ingredients", "Artichoke", "artichoke")
	pickerInModal.Refresh

	' Action buttons (Confirm / Cancel) in the modal footer
	' Using the built-in AddActionButton helper: (eventName, label, variant)
	modalContainer.AddActionButton("modal_confirm", "Confirm", "primary")
	modalContainer.AddActionButton("modal_cancel", "Cancel", "ghost")

	modalContainer.Refresh
End Sub

Private Sub BuildDatePickerSheet
	' Bottom Sheet Modal hosting a 3-column date picker (Year / Month / Day).
	smDatePicker.Initialize(Me, "smDatePicker")
	smDatePicker.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smDatePicker.Breakpoints = "0.0,1.0"
	smDatePicker.InitialBreakpoint = 1.0
	smDatePicker.Handle = False
	smDatePicker.HandleBehavior = "none"
	smDatePicker.BackdropOpacity = 40
	smDatePicker.Rounded = "lg"
	smDatePicker.AutoHeight = True
	smDatePicker.Animated = True
	smDatePicker.AnimationTime = 400

	' Toolbar (44px): Cancel on the left, Apply on the right.
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nbDatePicker")
	Dim nbHost As B4XView = xui.CreatePanel("")
	nb.AddToParent(nbHost, 0, 0, Root.Width, 44dip)
	nb.setHeight("h-[44px]")
	nb.Variant = "none"
	nb.BackgroundColor = xui.Color_RGB(247, 247, 247)
	nb.Shadow = "md"
	Dim btnCancel As B4XDaisyButton = nb.AddButtonToStart("btnDateCancel", "Cancel", "none", 84dip, 32dip, True)
	Dim btnApply As B4XDaisyButton = nb.AddButtonToEnd("btnDateApply", "Apply", "primary", 84dip, 32dip, False)
	smDatePicker.AddBoxView(nb.View, 0, 0, Root.Width, 44dip)

	' Date picker built with the picker's own date-column helpers (AddColumnDay/
	' AddColumnMonth/AddColumnYear) so no option loops live outside the picker.
	' InputFormat = VALUE format (Y-m-d -> 2027-01-01); DisplayFormat = DISPLAY format
	' (d M Y -> 01 Jan 2027). The month wheel shows Jan..Dec via the M token.
	pickerDateSheet.Initialize(Me, "pickerDateSheet")
	pickerDateSheet.InputFormat = "Y-m-d"
	pickerDateSheet.DisplayFormat = "d M Y"
	Dim pickerH As Int = pickerDateSheet.GetComputedHeight
	pickerDateSheet.AddToParent(smDatePicker.getContentView, 0, 0, Root.Width, pickerH)
	pickerDateSheet.AddColumnDay("day")
	pickerDateSheet.AddColumnMonth("month")
	pickerDateSheet.AddColumnYear("year", 1950, 2050)
	pickerDateSheet.Refresh

	' Demonstrate the IN formatting: SetValue parses the InputFormat value.
	' (AddColumnDay/Month/Year already default to today, so this is redundant but
	' shows SetValue works with the Y-m-d value format.)
	Dim today As Long = DateTime.Now
	pickerDateSheet.SetValue(NumberFormat2(DateTime.GetYear(today), 4, 0, 0, False) & "-" & NumberFormat2(DateTime.GetMonth(today), 2, 0, 0, False) & "-" & NumberFormat2(DateTime.GetDayOfMonth(today), 2, 0, 0, False))
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	If modalContainer.View.IsInitialized Then modalContainer.AddToParent(Root, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	' Ensure the modal is closed whenever the page appears
	If modalContainer.View.IsInitialized Then modalContainer.Close
End Sub
#End Region

#Region Actions & Handlers
' Opens the modal picker when the trigger button is pressed
Private Sub btnOpenModal_Click(Tag As Object)
	modalContainer.Show
End Sub

' Action button inside the modal footer (Confirm)
Private Sub modal_confirm_Click(Tag As Object)
	Dim selectedVal As Object = pickerInModal.GetColumnValue("ingredients")
	B4XPages.MainPage.ShowToastSuccess("Confirmed: " & selectedVal, True)
	modalContainer.Close
End Sub

' Action button inside the modal footer (Cancel)
Private Sub modal_cancel_Click(Tag As Object)
	modalContainer.Close
End Sub

' --- Date Picker Sheet Modal handlers ---
' Trigger button opens the Sheet Modal. Tag carries the activating button.
Private Sub btnPickDate_Click(Tag As Object)
	activeDateTrigger = Tag
	smDatePicker.Present
End Sub

' Apply: read the picker date and write it back to the activating button.
Private Sub btnDateApply_Click(Tag As Object)
	' The trigger button shows the VALUE via GetValue (InputFormat Y-m-d -> 2027-01-01).
	' DisplayFormat only drives the wheel labels/order; the button shows the value.
	Dim valueStr As String = pickerDateSheet.GetValue
	If activeDateTrigger.IsInitialized Then activeDateTrigger.Text = valueStr
	smDatePicker.Dismiss(Null, "apply")
End Sub

' Cancel: just close the Sheet Modal.
Private Sub btnDateCancel_Click(Tag As Object)
	smDatePicker.Dismiss(Null, "cancel")
End Sub

' Listeners for inline state changes 
Private Sub pickerBasic_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Basic Picker Selected: " & Value, False)
End Sub

Private Sub pickerSlots_Changed(ColumnName As String, Value As Object)
End Sub

Private Sub pickerThemed_Changed(ColumnName As String, Value As Object)
End Sub

Private Sub pickerDate_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Date: " & pickerDate.GetValue, False)
End Sub

Private Sub pickerTime_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Time: " & pickerTime.GetValue, False)
End Sub

Private Sub pickerDateTime_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Date-Time: " & pickerDateTime.GetValue, False)
End Sub

Private Sub pickerMulti_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Selection: " & pickerMulti.GetValue, False)
End Sub

Private Sub pickerHighlight_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Day: " & Value, False)
End Sub

Private Sub pickerTime12_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Time: " & pickerTime12.GetValue, False)
End Sub

Private Sub pickerRounded_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Shape: " & Value, False)
End Sub

Private Sub pickerDisplay_Changed(ColumnName As String, Value As Object)
	' GetValue uses InputFormat -> "2026-07-05", while the wheels show "July" / "5".
	B4XPages.MainPage.ShowToastSuccess("Returned: " & pickerDisplay.GetValue, False)
End Sub

Private Sub pickerShadow_Changed(ColumnName As String, Value As Object)
	B4XPages.MainPage.ShowToastSuccess("Level: " & Value, False)
End Sub

' Builds a random "<color>-<size>" string from the picker's own option values, then
' calls SetValue to programmatically select those columns (mirrors GetValue output).
Private Sub btnSetRandom_Click(Tag As Object)
	Dim colorList As List = pickerSetGet.GetColumnOptionValues("color")
	Dim sizeList As List = pickerSetGet.GetColumnOptionValues("size")
	' Build a B4X List of random values (index 0 -> color column, 1 -> size column).
	Dim vals As List
	vals.Initialize
	vals.Add(colorList.Get(Rnd(0, colorList.Size)))
	vals.Add(sizeList.Get(Rnd(0, sizeList.Size)))
	pickerSetGet.SetValueList(vals)
	B4XPages.MainPage.ShowToastSuccess("Set: " & JoinList(vals, "-"), False)
End Sub

' Reads the current selection back as a List (GetValueList) and shows it.
Private Sub btnGetValue_Click(Tag As Object)
	Dim vals As List = pickerSetGet.GetValueList
	B4XPages.MainPage.ShowToastSuccess("Get: " & JoinList(vals, "-"), False)
End Sub

' Programmatic SetValueList fires ColumnChanged per column; log only so the Set/Get
' buttons own the user-facing toasts.
Private Sub pickerSetGet_Changed(ColumnName As String, Value As Object)
End Sub

' Joins a List of values into a single string using Delimiter (for toast display).
Private Sub JoinList(Items As List, Delimiter As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To Items.Size - 1
		If i > 0 Then sb.Append(Delimiter)
		sb.Append("" & Items.Get(i))
	Next
	Return sb.ToString
End Sub

' Toggles the 'Cat' option in the Basic picker to demonstrate SetOptionDisabled.
Private Sub btnDisableCat_Click(Tag As Object)
	catDisabled = Not(catDisabled)
	pickerBasic.SetOptionDisabled("pets", "cat", catDisabled)
	btnDisableCat.Text = IIf(catDisabled, "Enable 'Cat' option", "Disable 'Cat' option")
	B4XPages.MainPage.ShowToastSuccess(IIf(catDisabled, "'Cat' disabled", "'Cat' enabled"), False)
End Sub
#End Region
