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
	Private toast As B4XDaisyToast

	' Color Wheel Instances
	Private cwBasic As B4XDaisyColorWheel
	Private cwLarge As B4XDaisyColorWheel
	Private cwProgrammatic As B4XDaisyColorWheel
	Private cwInModal As B4XDaisyColorWheel

	' Color Preview Panels
	Private pnlPreviewBasic As B4XView
	Private pnlPreviewLarge As B4XView
	Private pnlPreviewProgrammatic As B4XView

	' Buttons for programmatic control
	Private btnSetRed As B4XDaisyButton
	Private btnSetBlue As B4XDaisyButton
	Private btnShowModal As B4XDaisyButton
    
	' Modal Dialog
	Private modalCW As B4XDaisyModal
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

	' Initialize Toast for click feedback
	toast.Initialize(Me, "toast")
	toast.CreateView
	toast.SetRoot(Root)
	toast.SetPosition("end", "bottom")

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' ─────────────────────────────────────────────────────────────
	' Example 1: Basic Color Wheel (Medium-Thin Donut)
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("1. Medium-Thin Donut (16dip thickness)", y, False)
    
	cwBasic.Initialize(Me, "cwBasic")
	cwBasic.AddToParent(pnlHost, padding, y, 180dip, 180dip)
	cwBasic.setWheelThickness(16dip)
	cwBasic.setHandleSize(16dip)
    
	' Color Preview Box (Placed below the color wheel)
	Dim p1 As Panel
	p1.Initialize("")
	pnlPreviewBasic = p1
	pnlPreviewBasic.SetColorAndBorder(cwBasic.getColor, 1dip, xui.Color_Gray, 8dip)
	pnlHost.AddView(pnlPreviewBasic, padding, y + 190dip, 180dip, 30dip)
    
	y = y + 230dip + gap

	' ─────────────────────────────────────────────────────────────
	' Example 2: Large Scaled Wheel (Thick Donut with Saturation Reflection)
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("2. Large Thick Donut (Reflects Saturation)", y, False)
    
	cwLarge.Initialize(Me, "cwLarge")
	cwLarge.AddToParent(pnlHost, padding, y, 240dip, 240dip)
	cwLarge.setColor(B4XDaisyVariants.GetTokenColor("--color-success", xui.Color_RGB(34, 197, 94)))
	cwLarge.setWheelThickness(32dip)
	cwLarge.setHandleDiameter(32dip)
	cwLarge.setWheelReflectsSaturation(True)
    
	' Color Preview Box (Placed below the color wheel)
	Dim p2 As Panel
	p2.Initialize("")
	pnlPreviewLarge = p2
	pnlPreviewLarge.SetColorAndBorder(cwLarge.getColor, 1dip, xui.Color_Gray, 8dip)
	pnlHost.AddView(pnlPreviewLarge, padding, y + 250dip, 240dip, 30dip)
    
	y = y + 290dip + gap
 
	' ─────────────────────────────────────────────────────────────
	' Example 3: Programmatic API Control (Very Thick Donut)
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("3. Programmatic Control (Hex & HSL)", y, False)
    
	cwProgrammatic.Initialize(Me, "cwProgrammatic")
	cwProgrammatic.AddToParent(pnlHost, padding, y, 180dip, 180dip)
	cwProgrammatic.setWheelThickness(40dip)
	cwProgrammatic.setHandleDiameter(40dip)
    
	' Color Preview Box (Placed below the color wheel)
	Dim p3 As Panel
	p3.Initialize("")
	pnlPreviewProgrammatic = p3
	pnlPreviewProgrammatic.SetColorAndBorder(cwProgrammatic.getColor, 1dip, xui.Color_Gray, 8dip)
	pnlHost.AddView(pnlPreviewProgrammatic, padding, y + 190dip, 180dip, 30dip)
    
	' Setup Action Buttons (Placed side-by-side below the preview box)
	btnSetRed.Initialize(Me, "btnSetRed")
	btnSetRed.AddToParent(pnlHost, padding, y + 230dip, 85dip, 36dip)
	btnSetRed.Text = "Set Red"
	btnSetRed.Variant = "error"
    
	btnSetBlue.Initialize(Me, "btnSetBlue")
	btnSetBlue.AddToParent(pnlHost, padding + 95dip, y + 230dip, 85dip, 36dip)
	btnSetBlue.Text = "Set Blue"
	btnSetBlue.Variant = "info"
 
	y = y + 276dip + gap
 
	' ─────────────────────────────────────────────────────────────
	' Example 4: Modal Color Wheel (Centered on Parent)
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("4. Modal Color Picker (Centered on Parent)", y, False)
    
	btnShowModal.Initialize(Me, "btnShowModal")
	btnShowModal.AddToParent(pnlHost, padding, y, 180dip, 40dip)
	btnShowModal.Text = "Choose Color"
	btnShowModal.Variant = "primary"
    
	' Initialize Modal
	modalCW.Initialize(Me, "modalCW")
	modalCW.AddToParent(Root, 0, 0, Width, Height)
	modalCW.Title = "Select Color"
	modalCW.ClickOutsideToClose = True
	modalCW.ShowCloseButton = True
	modalCW.Visible = False
    
	' Configure and add Color Wheel inside the Modal Body Container
	Dim mBody As B4XView = modalCW.getBodyContainer
	cwInModal.Initialize(Me, "cwInModal")
	cwInModal.AddToParent(mBody, 0, 0, 180dip, 180dip)
	cwInModal.setCenterOnParent(True)
    
	' Explicitly size the modal body to fit the color wheel height
	mBody.Height = 180dip
    
	' Add Action buttons in the footer
	modalCW.AddActionButton("btnCancelColor", "Cancel", "ghost")
	modalCW.AddActionButton("btnApplyColor", "Apply", "primary")
	modalCW.Refresh
    
	y = y + 50dip + gap

	' Trigger calculation of the scrolling inner heights
	pageScroll.AutoFit
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	If toast.IsInitialized Then toast.Base_Resize(Width, Height)
	If modalCW.IsInitialized And modalCW.getView.IsInitialized Then modalCW.AddToParent(Root, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	If modalCW.IsInitialized Then modalCW.Close
End Sub
#End Region

#Region Component Events
' Event 1: Basic
Private Sub cwBasic_ColorChanged(Color As Int)
	If pnlPreviewBasic.IsInitialized Then pnlPreviewBasic.Color = Color
End Sub

' Event 2: Large
Private Sub cwLarge_ColorChanged(Color As Int)
	If pnlPreviewLarge.IsInitialized Then pnlPreviewLarge.Color = Color
End Sub

' Event 3: Programmatic (Triggers locally when touched)
Private Sub cwProgrammatic_ColorChanged(Color As Int)
	If pnlPreviewProgrammatic.IsInitialized Then pnlPreviewProgrammatic.Color = Color
End Sub

' Programmatic Button Triggers
Private Sub btnSetRed_Click(Tag As Object)
	cwProgrammatic.setColor(B4XDaisyVariants.GetTokenColor("--color-error", xui.Color_RGB(239, 68, 68)))
	cwProgrammatic_ColorChanged(cwProgrammatic.getColor) ' Instantly update the preview block
	toast.SuccessWithDuration("Changed to Red programmatically", 2000)
End Sub

Private Sub btnSetBlue_Click(Tag As Object)
	cwProgrammatic.setColor(B4XDaisyVariants.GetTokenColor("--color-info", xui.Color_RGB(59, 130, 246)))
	cwProgrammatic_ColorChanged(cwProgrammatic.getColor) ' Instantly update the preview block
	toast.SuccessWithDuration("Changed to Blue programmatically", 2000)
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
	toast.SuccessWithDuration("Applied color to button background", 2000)
End Sub
#End Region