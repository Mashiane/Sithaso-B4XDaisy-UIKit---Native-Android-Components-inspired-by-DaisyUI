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
    
	' Page Layout
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	' Buttons
	Private btnOnline As B4XDaisyButton
	Private btnBreakpoints As B4XDaisyButton
	Private btnCycle As B4XDaisyButton
	Private btnBackdrop As B4XDaisyButton
	Private btnAuto As B4XDaisyButton
	Private btnCard As B4XDaisyButton

	' Sheet Modals
	Private smOnline As B4XDaisySheetModal
	Private smBreakpoints As B4XDaisySheetModal
	Private smCycle As B4XDaisySheetModal
	Private smBackdrop As B4XDaisySheetModal
	Private smAuto As B4XDaisySheetModal
	Private smCard As B4XDaisySheetModal
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	' Initialize PageScroller
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
	BuildSheetModals
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' 1. Online Modal
	y = pageScroll.AddSectionTitle("1. Online Modal", y, False)
	btnOnline.Initialize(Me, "btnOnline")
	btnOnline.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnOnline.Text = "Online Modal"
	btnOnline.Variant = "primary"
	y = y + btnOnline.GetComputedHeight + gap

	' 2. Snapping Breakpoints
	y = pageScroll.AddSectionTitle("2. Snapping Breakpoints", y, False)
	btnBreakpoints.Initialize(Me, "btnBreakpoints")
	btnBreakpoints.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnBreakpoints.Text = "Show Snapping Breakpoints"
	btnBreakpoints.Variant = "secondary"
	y = y + btnBreakpoints.GetComputedHeight + gap

	' 3. Cycling Breakpoints
	y = pageScroll.AddSectionTitle("3. Cycling Breakpoints", y, False)
	btnCycle.Initialize(Me, "btnCycle")
	btnCycle.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnCycle.Text = "Show Cycling Breakpoints"
	btnCycle.Variant = "info"
	y = y + btnCycle.GetComputedHeight + gap

	' 4. Backdrop Scrim Configuration
	y = pageScroll.AddSectionTitle("4. Backdrop Scrim Config", y, False)
	btnBackdrop.Initialize(Me, "btnBackdrop")
	btnBackdrop.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnBackdrop.Text = "Show Custom Backdrop Sheet"
	btnBackdrop.Variant = "warning"
	y = y + btnBackdrop.GetComputedHeight + gap

	' 5. Auto-Height Sheet Modal
	y = pageScroll.AddSectionTitle("5. Auto-Height Sheet Modal", y, False)
	btnAuto.Initialize(Me, "btnAuto")
	btnAuto.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnAuto.Text = "Show Auto-Height Sheet"
	btnAuto.Variant = "success"
	y = y + btnAuto.GetComputedHeight + gap

	' 6. Card Modal (Presenting Element)
	y = pageScroll.AddSectionTitle("6. Card Modal (Presenting Element)", y, False)
	btnCard.Initialize(Me, "btnCard")
	btnCard.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnCard.Text = "Show Card Modal"
	btnCard.Variant = "accent"
	y = y + btnCard.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Sheet Modal Initialization
Private Sub BuildSheetModals
	' 1. Online Modal
	smOnline.Initialize(Me, "smOnline")
	smOnline.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smOnline.Breakpoints = "0.0,1.0"
	smOnline.InitialBreakpoint = 1.0
	smOnline.Handle = False
	smOnline.HandleBehavior = "none"
	smOnline.BackdropOpacity = 40
	smOnline.Rounded = "lg"
	smOnline.AutoHeight = False
	smOnline.Height = "h-full"
	smOnline.Animated = True
	smOnline.AnimationTime = 600

	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nbOnline")
	Dim nbHost As B4XView = xui.CreatePanel("")
	nb.AddToParent(nbHost, 0, 0, Root.Width, 44dip)
	nb.setHeight("h-[44px]")
	nb.Variant = "none"
	nb.BackgroundColor = xui.Color_RGB(247, 247, 247)
	nb.Shadow = "md"

	Dim btnCancel As B4XDaisyButton = nb.AddButtonToStart("smOnlineCancel", "Cancel", "none", 80dip, 32dip, True)
	nb.AddTitleToCenter("Welcome")
	Dim btnConfirm As B4XDaisyButton = nb.AddButtonToEnd("smOnlineConfirm", "Confirm", "primary", 80dip, 32dip, True)

	smOnline.AddBoxView(nb.getView, 0, 0, Root.Width, 44dip)

	Dim inp As B4XDaisyInput
	inp.Initialize(Me, "smOnlineInput")
	inp.AddToParent(smOnline.getContentView, 16dip, 16dip, Root.Width - 32dip, 56dip)
	inp.LabelAbove = "First Name"
	inp.Placeholder = "Enter your name"

	' 2. Snapping Breakpoints
	smBreakpoints.Initialize(Me, "smBreakpoints")
	smBreakpoints.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smBreakpoints.Breakpoints = "0.0,0.25,0.5,0.75,1.0"
	smBreakpoints.InitialBreakpoint = 0.5
	smBreakpoints.Handle = True
	smBreakpoints.HandleBehavior = "none"
	smBreakpoints.BackdropOpacity = 40
	smBreakpoints.Rounded = "lg"
	smBreakpoints.AutoHeight = False
	smBreakpoints.Height = "h-[450px]"

	Dim pnl2 As B4XView = xui.CreatePanel("")
	pnl2.Color = xui.Color_Transparent
	Dim lbl2 As Label
	lbl2.Initialize("")
	Dim xlbl2 As B4XView = lbl2
	xlbl2.Text = "This modal snaps to 25%, 50%, 75%, or 100% of the screen height. Swipe up or down to snap."
	xlbl2.TextColor = xui.Color_RGB(70, 70, 70)
	xlbl2.TextSize = 16
	pnl2.AddView(xlbl2, 16dip, 40dip, Root.Width - 32dip, 80dip)

	Dim btnClose2 As B4XDaisyButton
	btnClose2.Initialize(Me, "closeBreakpoints")
	btnClose2.AddToParent(pnl2, 16dip, 140dip, Root.Width - 32dip, 40dip)
	btnClose2.Text = "Dismiss Snapping Modal"
	btnClose2.Variant = "error"

	smBreakpoints.AddContentView(pnl2, 0, 0, Root.Width, 450dip)

	' 3. Cycling Breakpoints
	smCycle.Initialize(Me, "smCycle")
	smCycle.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smCycle.Breakpoints = "0.0,0.25,0.5,1.0"
	smCycle.InitialBreakpoint = 0.25
	smCycle.Handle = True
	smCycle.HandleBehavior = "cycle"
	smCycle.BackdropOpacity = 40
	smCycle.Rounded = "lg"
	smCycle.AutoHeight = False
	smCycle.Height = "h-[400px]"

	Dim pnl3 As B4XView = xui.CreatePanel("")
	pnl3.Color = xui.Color_Transparent
	Dim lbl3 As Label
	lbl3.Initialize("")
	Dim xlbl3 As B4XView = lbl3
	xlbl3.Text = "Tapping the drag handle pill at the top of the sheet cycles forward between 25%, 50%, and 100% breakpoints."
	xlbl3.TextColor = xui.Color_RGB(70, 70, 70)
	xlbl3.TextSize = 16
	pnl3.AddView(xlbl3, 16dip, 40dip, Root.Width - 32dip, 80dip)

	Dim btnClose3 As B4XDaisyButton
	btnClose3.Initialize(Me, "closeCycle")
	btnClose3.AddToParent(pnl3, 16dip, 140dip, Root.Width - 32dip, 40dip)
	btnClose3.Text = "Dismiss Cycling Modal"
	btnClose3.Variant = "error"

	smCycle.AddContentView(pnl3, 0, 0, Root.Width, 400dip)

	' 4. Backdrop Scrim Configuration
	smBackdrop.Initialize(Me, "smBackdrop")
	smBackdrop.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smBackdrop.Breakpoints = "0.0,0.5,1.0"
	smBackdrop.InitialBreakpoint = 0.5
	smBackdrop.BackdropBreakpoint = 0.5
	smBackdrop.Handle = True
	smBackdrop.HandleBehavior = "none"
	smBackdrop.BackdropOpacity = 70
	smBackdrop.Rounded = "lg"
	smBackdrop.AutoHeight = False
	smBackdrop.Height = "h-[500px]"

	Dim pnl4 As B4XView = xui.CreatePanel("")
	pnl4.Color = xui.Color_Transparent
	Dim lbl4 As Label
	lbl4.Initialize("")
	Dim xlbl4 As B4XView = lbl4
	xlbl4.Text = "The backdrop is configured to only activate/fade in once the sheet is dragged above 50% breakpoint. Scrim max opacity is set to 70%."
	xlbl4.TextColor = xui.Color_RGB(70, 70, 70)
	xlbl4.TextSize = 16
	pnl4.AddView(xlbl4, 16dip, 40dip, Root.Width - 32dip, 100dip)

	Dim btnClose4 As B4XDaisyButton
	btnClose4.Initialize(Me, "closeBackdrop")
	btnClose4.AddToParent(pnl4, 16dip, 160dip, Root.Width - 32dip, 40dip)
	btnClose4.Text = "Dismiss Backdrop Modal"
	btnClose4.Variant = "error"

	smBackdrop.AddContentView(pnl4, 0, 0, Root.Width, 500dip)

	' 5. Auto-Height Sheet Modal
	smAuto.Initialize(Me, "smAuto")
	smAuto.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smAuto.Breakpoints = "0.0,1.0"
	smAuto.InitialBreakpoint = 1.0
	smAuto.Handle = True
	smAuto.HandleBehavior = "none"
	smAuto.BackdropOpacity = 40
	smAuto.Rounded = "lg"
	smAuto.AutoHeight = True

	Dim pnl5 As B4XView = xui.CreatePanel("")
	pnl5.Color = xui.Color_Transparent
	Dim lbl5 As Label
	lbl5.Initialize("")
	Dim xlbl5 As B4XView = lbl5
	xlbl5.Text = "This sheet modal automatically derives its height from its child views recursive bottom bounds. It fits the views perfectly."
	xlbl5.TextColor = xui.Color_RGB(70, 70, 70)
	xlbl5.TextSize = 16
	pnl5.AddView(xlbl5, 16dip, 40dip, Root.Width - 32dip, 80dip)

	Dim btnAction5 As B4XDaisyButton
	btnAction5.Initialize(Me, "btnAction")
	btnAction5.AddToParent(pnl5, 16dip, 140dip, Root.Width - 32dip, 45dip)
	btnAction5.Text = "Save Settings"
	btnAction5.Variant = "success"

	Dim btnClose5 As B4XDaisyButton
	btnClose5.Initialize(Me, "closeAuto")
	btnClose5.AddToParent(pnl5, 16dip, 195dip, Root.Width - 32dip, 45dip)
	btnClose5.Text = "Cancel"
	btnClose5.Variant = "error"

	smAuto.AddContentView(pnl5, 0, 0, Root.Width, 260dip)

	' 6. Card Modal (Presenting Element)
	smCard.Initialize(Me, "smCard")
	smCard.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	smCard.Breakpoints = "0.0,1.0"
	smCard.InitialBreakpoint = 1.0
	smCard.Handle = False
	smCard.BackdropOpacity = 0
	smCard.Rounded = "lg"
	smCard.AutoHeight = False
	smCard.Height = "h-[92%]"
	smCard.Animated = True
	smCard.AnimationTime = 500
	smCard.ScaleBackground = True
	smCard.PresentingView = pageScroll.mBase
	smCard.BackgroundScale = 0.94
	smCard.BackgroundCornerRadius = smCard.CornerRadius
	smCard.BackgroundTranslateY = 14dip
	smCard.BackgroundDim = 0.08
	smCard.BackgroundShadow = True

	Dim pnl6 As B4XView = xui.CreatePanel("")
	pnl6.Color = xui.Color_White
	Dim lbl6 As Label
	lbl6.Initialize("")
	Dim xlbl6 As B4XView = lbl6
	xlbl6.Text = "Card Modal"
	xlbl6.TextColor = xui.Color_RGB(70, 70, 70)
	xlbl6.TextSize = 20
	pnl6.AddView(xlbl6, 16dip, 16dip, Root.Width - 32dip, 40dip)

	Dim inp6 As B4XDaisyInput
	inp6.Initialize(Me, "smCardInput")
	inp6.AddToParent(pnl6, 16dip, 70dip, Root.Width - 32dip, 56dip)
	inp6.LabelAbove = "Email"
	inp6.Placeholder = "you@example.com"

	smCard.AddContentView(pnl6, 0, 0, Root.Width, 200dip)
End Sub
#End Region

#Region Sheet Modal Examples
' ----------------------------------------------------
' 1. Online Modal
' ----------------------------------------------------
Private Sub btnOnline_Click(Tag As Object)
	smOnline.Present
End Sub

Private Sub smOnlineCancel_Click(Tag As Object)
	smOnline.Dismiss(Null, "cancel")
End Sub

Private Sub smOnlineConfirm_Click(Tag As Object)
	smOnline.Dismiss(Null, "confirm")
End Sub

' ----------------------------------------------------
' 2. Snapping Breakpoints
' ----------------------------------------------------
Private Sub btnBreakpoints_Click(Tag As Object)
	smBreakpoints.Present
End Sub

Private Sub closeBreakpoints_Click(Tag As Object)
	smBreakpoints.Dismiss(Null, "cancel")
End Sub

Private Sub smBreakpoints_BreakpointDidChange(Breakpoint As Float)
	B4XPages.MainPage.ShowToastAlert("Breakpoint Change", "Snapped to: " & (Breakpoint * 100) & "%", "info", 1500, "top-right")
End Sub

' ----------------------------------------------------
' 3. Cycling Breakpoints
' ----------------------------------------------------
Private Sub btnCycle_Click(Tag As Object)
	smCycle.Present
End Sub

Private Sub closeCycle_Click(Tag As Object)
	smCycle.Dismiss(Null, "cancel")
End Sub

' ----------------------------------------------------
' 4. Backdrop Scrim Configuration
' ----------------------------------------------------
Private Sub btnBackdrop_Click(Tag As Object)
	smBackdrop.Present
End Sub

Private Sub closeBackdrop_Click(Tag As Object)
	smBackdrop.Dismiss(Null, "cancel")
End Sub

' ----------------------------------------------------
' 5. Auto-Height Sheet Modal
' ----------------------------------------------------
Private Sub btnAuto_Click(Tag As Object)
	smAuto.Present
End Sub

Private Sub closeAuto_Click(Tag As Object)
	smAuto.Dismiss(Null, "cancel")
End Sub

Private Sub btnAction_Click(Tag As Object)
	smAuto.Dismiss(Null, "submit")
	B4XPages.MainPage.ShowToastAlert("Auto Height", "Settings saved successfully!", "success", 2000, "top-right")
End Sub

' ----------------------------------------------------
' 6. Card Modal (Presenting Element)
' ----------------------------------------------------
Private Sub btnCard_Click(Tag As Object)
	smCard.Present
End Sub

Private Sub smOnline_DragMove(Data As Map)
End Sub

Private Sub smOnline_DragEnd(Data As Map)
End Sub
#End Region
