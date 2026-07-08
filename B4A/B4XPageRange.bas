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
#End Region