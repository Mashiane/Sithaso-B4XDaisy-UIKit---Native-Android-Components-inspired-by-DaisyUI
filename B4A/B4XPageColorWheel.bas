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
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	' Color Wheel Instances
	Private cwBasic As B4XDaisyColorWheel
	Private cwLarge As B4XDaisyColorWheel
	Private cwProgrammatic As B4XDaisyColorWheel
	Private cwInModal As B4XDaisyColorWheel

	' Buttons for programmatic control
	Private btnSetRed As B4XDaisyButton
	Private btnSetBlue As B4XDaisyButton
	Private btnShowModal As B4XDaisyButton
    
	' Modal Dialog
	Private modalCW As B4XDaisyModal

	' Example 5: Color Input & Sheet Modal
	Private inpColor As B4XDaisyInput
	Private sheetCW As B4XDaisySheetModal
	Private nbSheet As B4XDaisyNavbar
	Private cwInSheet As B4XDaisyColorWheel
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

	' Initialize PageScroll Host
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
	BuildModals(Root.Width, Root.Height)
End Sub
#End Region

Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' -------------------------------------------------------------
	' Example 1: Basic Color Wheel (Medium-Thin Donut)
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("1. Medium-Thin Donut (16dip thickness)", y, False)
    
	cwBasic.Initialize(Me, "cwBasic")
	cwBasic.AddToParent(pnlHost, padding, y, 180dip, 212dip)
	cwBasic.setWheelThickness(16dip)
	cwBasic.setHandleSize(16dip)
    
	y = y + 220dip + gap

	' -------------------------------------------------------------
	' Example 2: Large Scaled Wheel (Thick Donut with Saturation Reflection)
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("2. Large Thick Donut (Reflects Saturation)", y, False)
    
	cwLarge.Initialize(Me, "cwLarge")
	cwLarge.AddToParent(pnlHost, padding, y, 240dip, 272dip)
	cwLarge.setColor(B4XDaisyVariants.GetTokenColor("--color-success", xui.Color_RGB(34, 197, 94)))
	cwLarge.setWheelThickness(32dip)
	cwLarge.setHandleDiameter(32dip)
	cwLarge.setWheelReflectsSaturation(True)
    
	y = y + 280dip + gap
 
	' -------------------------------------------------------------
	' Example 3: Programmatic API Control (Very Thick Donut)
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("3. Programmatic Control (Hex & HSL)", y, False)
    
	cwProgrammatic.Initialize(Me, "cwProgrammatic")
	cwProgrammatic.AddToParent(pnlHost, padding, y, 180dip, 212dip)
	cwProgrammatic.setWheelThickness(40dip)
	cwProgrammatic.setHandleDiameter(40dip)
    
	' Setup Action Buttons (Placed side-by-side below the color wheel)
	btnSetRed.Initialize(Me, "btnSetRed")
	btnSetRed.AddToParent(pnlHost, padding, y + 220dip, 85dip, 36dip)
	btnSetRed.Text = "Set Red"
	btnSetRed.Variant = "error"
    
	btnSetBlue.Initialize(Me, "btnSetBlue")
	btnSetBlue.AddToParent(pnlHost, padding + 95dip, y + 220dip, 85dip, 36dip)
	btnSetBlue.Text = "Set Blue"
	btnSetBlue.Variant = "info"
 
	y = y + 266dip + gap
 
	' -------------------------------------------------------------
	' Example 4: Modal Color Wheel (Centered on Parent)
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("4. Modal Color Picker (Centered on Parent)", y, False)
    
	btnShowModal.Initialize(Me, "btnShowModal")
	btnShowModal.AddToParent(pnlHost, padding, y, 180dip, 40dip)
	btnShowModal.Text = "Choose Color"
	btnShowModal.Variant = "primary"
    
	y = y + 50dip + gap

	' -------------------------------------------------------------
	' Example 5: Color Input with Sheet Modal
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("5. Color Input with Sheet Modal", y, False)
    
	inpColor.Initialize(Me, "inpColor")
	inpColor.InputType = "color"
	inpColor.LabelAbove = "Color"
	' Default color is black until the user picks a color via the sheet.
	inpColor.Text = "#000000"
	inpColor.AddToParent(pnlHost, padding, y, maxW, 56dip)
    
	y = y + 70dip + gap

	' Trigger calculation of the scrolling inner heights
	pageScroll.AutoFit
End Sub

Private Sub BuildModals(Width As Int, Height As Int)
	Dim w As Int = Width
	If w <= 0 Then w = 100%x
	Dim h As Int = Height
	If h <= 0 Then h = 100%y

	' Initialize Modal for Example 4
	modalCW.Initialize(Me, "modalCW")
	modalCW.AddToParent(Root, 0, 0, w, h)
	modalCW.Title = "Select Color"
	modalCW.ClickOutsideToClose = True
	modalCW.ShowCloseButton = True
	modalCW.Visible = False
    
	Dim mBody As B4XView = modalCW.getBodyContainer
	cwInModal.Initialize(Me, "cwInModal")
	cwInModal.AddToParent(mBody, 0, 0, 180dip, 212dip)
	cwInModal.setCenterOnParent(True)
	mBody.Height = 220dip
    
	modalCW.AddActionButton("btnCancelColor", "Cancel", "ghost")
	modalCW.AddActionButton("btnApplyColor", "Apply", "primary")
	modalCW.Refresh

	' Initialize Sheet Modal for Example 5
	sheetCW.Initialize(Me, "sheetCW")
	sheetCW.AddToParent(Root, 0, 0, w, h)
	sheetCW.setHeight("h-[360px]")
	sheetCW.setBreakpoints("0,1.0")
	sheetCW.setInitialBreakpoint(1.0)
	sheetCW.setHandle(True)
	sheetCW.Dismiss(Null, "")
    
	nbSheet.Initialize(Me, "nbSheet")
	Dim nbView As B4XView = nbSheet.CreateView(w, 44dip)
	nbSheet.setHeight("44dip")
	nbSheet.Title = "Select Color"
	nbSheet.TitlePosition = "center"
	nbSheet.AddButtonToStart("btnCancelSheet", "Cancel", "neutral", 0, 0, True)
	nbSheet.AddButtonToEnd("btnApplySheet", "Apply", "success", 0, 0, True)
	sheetCW.AddBoxView(nbView, 0, 0, w, 44dip)
    
	cwInSheet.Initialize(Me, "cwInSheet")
	cwInSheet.AddToParent(sheetCW.getContentView, (w - 200dip) / 2, 4dip, 200dip, 232dip)
	cwInSheet.setCenterOnParent(True)
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	If modalCW.IsInitialized And modalCW.View.IsInitialized Then modalCW.AddToParent(Root, 0, 0, Width, Height)
	If sheetCW.IsInitialized And sheetCW.View.IsInitialized Then sheetCW.AddToParent(Root, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	If modalCW.IsInitialized Then modalCW.Close
	If sheetCW.IsInitialized Then sheetCW.Dismiss(Null, "")
End Sub
#End Region

#Region Component Events
Private Sub cwBasic_Changed(Color As Int)
End Sub

Private Sub cwLarge_Changed(Color As Int)
End Sub

Private Sub cwProgrammatic_Changed(Color As Int)
End Sub

' Programmatic Button Triggers
Private Sub btnSetRed_Click(Tag As Object)
	cwProgrammatic.setColor(B4XDaisyVariants.GetTokenColor("--color-error", xui.Color_RGB(239, 68, 68)))
	B4XPages.MainPage.ShowToastSuccess("Changed to Red programmatically", False)
End Sub

Private Sub btnSetBlue_Click(Tag As Object)
	cwProgrammatic.setColor(B4XDaisyVariants.GetTokenColor("--color-info", xui.Color_RGB(59, 130, 246)))
	B4XPages.MainPage.ShowToastSuccess("Changed to Blue programmatically", False)
End Sub

' Event 4: Button triggers modal opening
Private Sub btnShowModal_Click(Tag As Object)
	modalCW.Show
End Sub

' Cancel color button clicked in modal
Private Sub btnCancelColor_Click(Tag As Object)
	modalCW.Close
End Sub

' Apply color button clicked in modal
Private Sub btnApplyColor_Click(Tag As Object)
	Dim selectedColor As Int = cwInModal.getColor
	btnShowModal.setBackgroundColor(selectedColor)
	modalCW.Close
	B4XPages.MainPage.ShowToastSuccess("Applied color to button background", False)
End Sub

' Event 5: Color Input & Sheet Modal
Private Sub inpColor_Click(Tag As Object)
	OpenColorPickerSheet
End Sub

Private Sub inpColor_AppendClick
	OpenColorPickerSheet
End Sub

Private Sub inpColor_FocusChanged(HasFocus As Boolean)
	If HasFocus Then OpenColorPickerSheet
End Sub

Private Sub OpenColorPickerSheet
	If sheetCW.IsInitialized Then
		Dim currentHex As String = inpColor.Text.Trim
		If currentHex.Length > 0 Then
			Try
				cwInSheet.setHex(currentHex)
			Catch
				Log("B4XPageColorWheel.OpenColorPickerSheet: " & LastException.Message)
			End Try
		End If
		sheetCW.Present
	End If
End Sub

Private Sub btnCancelSheet_Click(Tag As Object)
	sheetCW.Dismiss(Null, "cancel")
End Sub

Private Sub btnApplySheet_Click(Tag As Object)
	Dim selectedHex As String = cwInSheet.getHex
	inpColor.Text = selectedHex
	inpColor.setAppendColor(cwInSheet.getColor)
	sheetCW.Dismiss(Null, "apply")
	B4XPages.MainPage.ShowToastSuccess("Applied color: " & selectedHex, False)
End Sub
#End Region
