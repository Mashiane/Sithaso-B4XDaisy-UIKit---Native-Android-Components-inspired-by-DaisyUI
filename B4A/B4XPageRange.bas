B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private PAGE_PAD As Int = 12dip
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the demo page class.
''' </summary>
Public Sub Initialize As Object
	Return Me
End Sub

''' <summary>
''' Called when the page is created.
''' Sets up the ScrollView host container.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Range")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders the range slider component examples in a linear layout.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	''' Example 1: Base Range Slider
	''' Demonstrates a standard range slider with default properties.
	y = AddSectionTitle("Base Range Slider", y, maxW)
	Dim r1 As B4XDaisyRange
	r1.Initialize(Me, "range1")
	r1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	r1.MinValue = 0
	r1.MaxValue = 100
	r1.Value = 40
	r1.Tag = "base-range"
	y = y + 40dip

	''' Example 2: Step Increments
	''' Demonstrates a discrete step-snapping slider with step = 25.
	y = AddSectionTitle("Step Increments (Step = 25)", y, maxW)
	Dim r2 As B4XDaisyRange
	r2.Initialize(Me, "range2")
	r2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	r2.MinValue = 0
	r2.MaxValue = 100
	r2.Value = 25
	r2.StepValue = 25
	r2.Tag = "step-range"
	y = y + 40dip

	''' Example 3: Sizing - Extra Small
	''' Demonstrates the 'xs' size slider.
	y = AddSectionTitle("Size: Extra Small (xs)", y, maxW)
	Dim rSizeXS As B4XDaisyRange
	rSizeXS.Initialize(Me, "rangeSizeXS")
	rSizeXS.AddToParent(pnlHost, PAGE_PAD, y, maxW, 16dip)
	rSizeXS.Size = "xs"
	rSizeXS.Value = 50
	rSizeXS.Tag = "size-xs"
	y = y + 40dip

	''' Example 4: Sizing - Small
	''' Demonstrates the 'sm' size slider.
	y = AddSectionTitle("Size: Small (sm)", y, maxW)
	Dim rSizeSM As B4XDaisyRange
	rSizeSM.Initialize(Me, "rangeSizeSM")
	rSizeSM.AddToParent(pnlHost, PAGE_PAD, y, maxW, 20dip)
	rSizeSM.Size = "sm"
	rSizeSM.Value = 50
	rSizeSM.Tag = "size-sm"
	y = y + 40dip

	''' Example 5: Sizing - Medium
	''' Demonstrates the default 'md' size slider.
	y = AddSectionTitle("Size: Medium (md)", y, maxW)
	Dim rSizeMD As B4XDaisyRange
	rSizeMD.Initialize(Me, "rangeSizeMD")
	rSizeMD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rSizeMD.Size = "md"
	rSizeMD.Value = 50
	rSizeMD.Tag = "size-md"
	y = y + 40dip

	''' Example 6: Sizing - Large
	''' Demonstrates the 'lg' size slider.
	y = AddSectionTitle("Size: Large (lg)", y, maxW)
	Dim rSizeLG As B4XDaisyRange
	rSizeLG.Initialize(Me, "rangeSizeLG")
	rSizeLG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
	rSizeLG.Size = "lg"
	rSizeLG.Value = 50
	rSizeLG.Tag = "size-lg"
	y = y + 40dip

	''' Example 7: Sizing - Extra Large
	''' Demonstrates the 'xl' size slider.
	y = AddSectionTitle("Size: Extra Large (xl)", y, maxW)
	Dim rSizeXL As B4XDaisyRange
	rSizeXL.Initialize(Me, "rangeSizeXL")
	rSizeXL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 32dip)
	rSizeXL.Size = "xl"
	rSizeXL.Value = 50
	rSizeXL.Tag = "size-xl"
	y = y + 40dip

	''' Example 8: Color Variant - Primary
	''' Demonstrates the primary color variant theme-resolved styling.
	y = AddSectionTitle("Variant: Primary", y, maxW)
	Dim rVarPrimary As B4XDaisyRange
	rVarPrimary.Initialize(Me, "rangeVarPrimary")
	rVarPrimary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rVarPrimary.Variant = "primary"
	rVarPrimary.Value = 60
	rVarPrimary.Tag = "variant-primary"
	y = y + 40dip

	''' Example 9: Color Variant - Secondary
	''' Demonstrates the secondary color variant theme-resolved styling.
	y = AddSectionTitle("Variant: Secondary", y, maxW)
	Dim rVarSecondary As B4XDaisyRange
	rVarSecondary.Initialize(Me, "rangeVarSecondary")
	rVarSecondary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rVarSecondary.Variant = "secondary"
	rVarSecondary.Value = 60
	rVarSecondary.Tag = "variant-secondary"
	y = y + 40dip

	''' Example 10: Color Variant - Accent
	''' Demonstrates the accent color variant theme-resolved styling.
	y = AddSectionTitle("Variant: Accent", y, maxW)
	Dim rVarAccent As B4XDaisyRange
	rVarAccent.Initialize(Me, "rangeVarAccent")
	rVarAccent.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rVarAccent.Variant = "accent"
	rVarAccent.Value = 60
	rVarAccent.Tag = "variant-accent"
	y = y + 40dip

	''' Example 11: Color Variant - Success
	''' Demonstrates the success color variant theme-resolved styling.
	y = AddSectionTitle("Variant: Success", y, maxW)
	Dim rVarSuccess As B4XDaisyRange
	rVarSuccess.Initialize(Me, "rangeVarSuccess")
	rVarSuccess.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rVarSuccess.Variant = "success"
	rVarSuccess.Value = 60
	rVarSuccess.Tag = "variant-success"
	y = y + 40dip

	''' Example 12: Color Variant - Warning
	''' Demonstrates the warning color variant theme-resolved styling.
	y = AddSectionTitle("Variant: Warning", y, maxW)
	Dim rVarWarning As B4XDaisyRange
	rVarWarning.Initialize(Me, "rangeVarWarning")
	rVarWarning.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rVarWarning.Variant = "warning"
	rVarWarning.Value = 60
	rVarWarning.Tag = "variant-warning"
	y = y + 40dip

	''' Example 13: Color Variant - Error
	''' Demonstrates the error color variant theme-resolved styling.
	y = AddSectionTitle("Variant: Error", y, maxW)
	Dim rVarError As B4XDaisyRange
	rVarError.Initialize(Me, "rangeVarError")
	rVarError.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rVarError.Variant = "error"
	rVarError.Value = 60
	rVarError.Tag = "variant-error"
	y = y + 40dip

	''' Example 14: Disabled State
	''' Demonstrates the range slider in a disabled state.
	y = AddSectionTitle("Disabled State", y, maxW)
	Dim rDisabled As B4XDaisyRange
	rDisabled.Initialize(Me, "rangeDisabled")
	rDisabled.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rDisabled.Enabled = False
	rDisabled.Value = 30
	rDisabled.Tag = "range-disabled"
	y = y + 40dip

	''' Example 15: Custom Colors
	''' Demonstrates custom track, thumb, and progress colors.
	y = AddSectionTitle("Custom Colors", y, maxW)
	Dim rCustomColors As B4XDaisyRange
	rCustomColors.Initialize(Me, "rangeCustomColors")
	rCustomColors.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rCustomColors.MinValue = 0
	rCustomColors.MaxValue = 100
	rCustomColors.Value = 40
	rCustomColors.TrackColor = xui.Color_RGB(255, 165, 0) ' Orange
	rCustomColors.ThumbColor = xui.Color_Blue
	rCustomColors.ProgressColor = xui.Color_RGB(147, 197, 253) ' Light Blue (text-blue-300)
	rCustomColors.Tag = "range-custom-colors"
	y = y + 40dip

	''' Example 16: No Fill (--range-fill:0 parity)
	''' Demonstrates hiding the progress fill so only track and thumb are visible.
	y = AddSectionTitle("No Fill (range-fill:0)", y, maxW)
	Dim rNoFill As B4XDaisyRange
	rNoFill.Initialize(Me, "rangeNoFill")
	rNoFill.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rNoFill.MinValue = 0
	rNoFill.MaxValue = 100
	rNoFill.Value = 40
	rNoFill.ShowFill = False
	rNoFill.Tag = "range-no-fill"
	y = y + 40dip

	''' Example 17: RTL (--range-dir:-1 parity)
	''' Demonstrates right-to-left progress direction.
	y = AddSectionTitle("RTL Direction", y, maxW)
	Dim rRTL As B4XDaisyRange
	rRTL.Initialize(Me, "rangeRTL")
	rRTL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rRTL.MinValue = 0
	rRTL.MaxValue = 100
	rRTL.Value = 60
	rRTL.RTL = True
	rRTL.Tag = "range-rtl"
	y = y + 40dip

	''' Example 18: Label Above
	''' Demonstrates a caption rendered above the slider (LabelAbove + LabelVisible).
	y = AddSectionTitle("Label Above", y, maxW)
	Dim rLabel As B4XDaisyRange
	rLabel.Initialize(Me, "rangeLabel")
	rLabel.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rLabel.LabelAbove = "Volume"
	rLabel.LabelVisible = True
	rLabel.Value = 60
	rLabel.Tag = "range-label-above"
	y = y + rLabel.GetComputedHeight + 12dip

	''' Example 19: Hint Text
	''' Demonstrates helper text rendered below the slider.
	y = AddSectionTitle("Hint Text", y, maxW)
	Dim rHint As B4XDaisyRange
	rHint.Initialize(Me, "rangeHint")
	rHint.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rHint.LabelAbove = "Brightness"
	rHint.LabelVisible = True
	rHint.HintText = "Drag to adjust screen brightness."
	rHint.Value = 75
	rHint.Tag = "range-hint"
	y = y + rHint.GetComputedHeight + 12dip

	''' Example 20: Required (red star)
	''' Demonstrates the Required flag rendering a red asterisk on the label.
	y = AddSectionTitle("Required (red star)", y, maxW)
	Dim rRequired As B4XDaisyRange
	rRequired.Initialize(Me, "rangeRequired")
	rRequired.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rRequired.LabelAbove = "Acceptance Level"
	rRequired.LabelVisible = True
	rRequired.Required = True
	rRequired.MinValue = 0
	rRequired.MaxValue = 100
	rRequired.Value = 40
	rRequired.HintText = "Value must be greater than the minimum."
	rRequired.Tag = "range-required"
	y = y + rRequired.GetComputedHeight + 12dip

	''' Example 21: Validation For A Value
	''' Required range starting at the minimum (invalid). Tap Validate to check;
	''' the error text renders below in red. Dragging clears the transient error.
	y = AddSectionTitle("Validation For A Value", y, maxW)
	Dim rValid As B4XDaisyRange
	rValid.Initialize(Me, "rangeValid")
	rValid.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rValid.LabelAbove = "Quantity"
	rValid.LabelVisible = True
	rValid.Required = True
	rValid.MinValue = 0
	rValid.MaxValue = 100
	rValid.Value = 0
	rValid.HintText = "Select a quantity greater than 0, then tap Validate."
	rValid.Tag = "range-valid"
	y = y + rValid.GetComputedHeight + 8dip

	Dim btnValidate As B4XDaisyButton
	btnValidate.Initialize(Me, "btnValidateRange")
	btnValidate.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	btnValidate.Text = "Validate Quantity"
	btnValidate.Tag = rValid
	y = y + 48dip

	''' Example 22: Prepend/Append Icons (Volume)
	''' Demonstrates left/right SVG icons that step the value on tap, with a
	''' transient tooltip that fades in on drag / icon tap and fades out after release.
	y = AddSectionTitle("Icon Controls (tap icons to step)", y, maxW)
	Dim rIconVol As B4XDaisyRange
	rIconVol.Initialize(Me, "rangeIconVol")
	rIconVol.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rIconVol.LabelAbove = "Volume"
	rIconVol.LabelVisible = True
	rIconVol.IconLeft = "volume-low-solid-full.svg"
	rIconVol.IconRight = "volume-high-solid-full.svg"
	rIconVol.MinValue = 0
	rIconVol.MaxValue = 100
	rIconVol.StepValue = 10
	rIconVol.Value = 50
	rIconVol.ShowValue = True
	rIconVol.ValueSuffix = "%"
	rIconVol.Variant = "primary"
	rIconVol.ShowTooltip = True
	rIconVol.TooltipOpen = False
	rIconVol.Tag = "range-icon-volume"
	y = y + rIconVol.GetComputedHeight + 12dip

	''' Example 23: Permanent Tooltip
	''' Demonstrates a tooltip that stays permanently visible above the thumb
	''' (TooltipOpen = True). Useful for live-readout sliders.
	y = AddSectionTitle("Permanent Tooltip (always visible)", y, maxW)
	Dim rPermTip As B4XDaisyRange
	rPermTip.Initialize(Me, "rangePermTip")
	rPermTip.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rPermTip.MinValue = 0
	rPermTip.MaxValue = 100
	rPermTip.Value = 65
	rPermTip.Variant = "secondary"
	rPermTip.ShowTooltip = True
	rPermTip.TooltipOpen = True
	rPermTip.TooltipPosition = "top"
	rPermTip.Tag = "range-perm-tooltip"
	y = y + 40dip

	''' Example 24: Icons + Tooltip + Chrome (Brightness)
	''' Combines prepend/append icons, a transient tooltip, label above and hint
	''' text below - the full composite range surface.
	y = AddSectionTitle("Icons + Tooltip + Label + Hint", y, maxW)
	Dim rBright As B4XDaisyRange
	rBright.Initialize(Me, "rangeBright")
	rBright.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rBright.LabelAbove = "Brightness"
	rBright.LabelVisible = True
	rBright.HintText = "Drag the slider or tap the moon/sun to adjust brightness."
	rBright.IconLeft = "nightmoon.svg"
	rBright.IconRight = "daysun.svg"
	rBright.MinValue = 0
	rBright.MaxValue = 100
	rBright.StepValue = 5
	rBright.Value = 40
	rBright.ShowValue = True
	rBright.ValueSuffix = "%"
	rBright.Variant = "accent"
	rBright.ShowTooltip = True
	rBright.TooltipOpen = False
	rBright.Tag = "range-brightness"
	y = y + rBright.GetComputedHeight + 12dip
	''' Example 25: Sizes + Label Above + Show Value (neutral)
	''' Demonstrates the range across all sizes, each with a left-aligned label
	''' and a right-aligned live value readout, in the neutral color variant.
	''' This showcases how the label / value chrome scales with Size.
	y = AddSectionTitle("Sizes + Label + Value (neutral)", y, maxW)

	Dim rSV_XS As B4XDaisyRange
	rSV_XS.Initialize(Me, "rangeSVXS")
	rSV_XS.AddToParent(pnlHost, PAGE_PAD, y, maxW, 16dip)
	rSV_XS.Size = "xs"
	rSV_XS.Variant = "neutral"
	rSV_XS.LabelAbove = "Extra Small (xs)"
	rSV_XS.LabelVisible = True
	rSV_XS.ShowValue = True
	rSV_XS.ValueSuffix = "%"
	rSV_XS.MinValue = 0
	rSV_XS.MaxValue = 100
	rSV_XS.Value = 50
	rSV_XS.Tag = "range-sv-xs"
	y = y + rSV_XS.GetComputedHeight + 10dip

	Dim rSV_SM As B4XDaisyRange
	rSV_SM.Initialize(Me, "rangeSVSM")
	rSV_SM.AddToParent(pnlHost, PAGE_PAD, y, maxW, 20dip)
	rSV_SM.Size = "sm"
	rSV_SM.Variant = "neutral"
	rSV_SM.LabelAbove = "Small (sm)"
	rSV_SM.LabelVisible = True
	rSV_SM.ShowValue = True
	rSV_SM.ValueSuffix = "%"
	rSV_SM.MinValue = 0
	rSV_SM.MaxValue = 100
	rSV_SM.Value = 50
	rSV_SM.Tag = "range-sv-sm"
	y = y + rSV_SM.GetComputedHeight + 10dip

	Dim rSV_MD As B4XDaisyRange
	rSV_MD.Initialize(Me, "rangeSVMD")
	rSV_MD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 24dip)
	rSV_MD.Size = "md"
	rSV_MD.Variant = "neutral"
	rSV_MD.LabelAbove = "Medium (md)"
	rSV_MD.LabelVisible = True
	rSV_MD.ShowValue = True
	rSV_MD.ValueSuffix = "%"
	rSV_MD.MinValue = 0
	rSV_MD.MaxValue = 100
	rSV_MD.Value = 50
	rSV_MD.Tag = "range-sv-md"
	y = y + rSV_MD.GetComputedHeight + 10dip

	Dim rSV_LG As B4XDaisyRange
	rSV_LG.Initialize(Me, "rangeSVLG")
	rSV_LG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
	rSV_LG.Size = "lg"
	rSV_LG.Variant = "neutral"
	rSV_LG.LabelAbove = "Large (lg)"
	rSV_LG.LabelVisible = True
	rSV_LG.ShowValue = True
	rSV_LG.ValueSuffix = "%"
	rSV_LG.MinValue = 0
	rSV_LG.MaxValue = 100
	rSV_LG.Value = 50
	rSV_LG.Tag = "range-sv-lg"
	y = y + rSV_LG.GetComputedHeight + 10dip

	Dim rSV_XL As B4XDaisyRange
	rSV_XL.Initialize(Me, "rangeSVXL")
	rSV_XL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 32dip)
	rSV_XL.Size = "xl"
	rSV_XL.Variant = "neutral"
	rSV_XL.LabelAbove = "Extra Large (xl)"
	rSV_XL.LabelVisible = True
	rSV_XL.ShowValue = True
	rSV_XL.ValueSuffix = "%"
	rSV_XL.MinValue = 0
	rSV_XL.MaxValue = 100
	rSV_XL.Value = 50
	rSV_XL.Tag = "range-sv-xl"
	y = y + rSV_XL.GetComputedHeight + 12dip
	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Spawns a stylized section header for the demo page.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
	Dim title As B4XDaisyText
	title.Initialize(Me, "lblTitle")
	title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
	title.Text = Text
	title.TextColor = xui.Color_RGB(30, 41, 59)
	title.TextSize = 14
	title.FontBold = True
	Return Y + 32dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub range1_Changed(Value As Int)
End Sub

Private Sub btnValidateRange_Click (Tag As Object)
	If Tag Is B4XDaisyRange Then
		Dim r As B4XDaisyRange = Tag
		Dim ok As Boolean = r.Validate
		If ok Then
			B4XPages.MainPage.ShowToastSuccess("Valid: value is greater than the minimum.", False)
		Else
			Dim msg As String = r.ErrorText
			If msg.Length = 0 Then msg = "This field is required."
			B4XPages.MainPage.ShowToastError("Invalid: " & msg, False)
		End If
	End If
End Sub

Private Sub rangeIconVol_Changed(Value As Int)
	Log("rangeIconVol Changed: " & Value)
End Sub

Private Sub rangePermTip_Changed(Value As Int)
	Log("rangePermTip Changed: " & Value)
End Sub

Private Sub rangeBright_Changed(Value As Int)
	Log("rangeBright Changed: " & Value)
End Sub
#End Region