B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: Changed (Value As Int)
#Event: FocusChanged (HasFocus As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: MinValue, DisplayName: Minimum Value, FieldType: Int, DefaultValue: 0, Description: Minimum slider value.
#DesignerProperty: Key: MaxValue, DisplayName: Maximum Value, FieldType: Int, DefaultValue: 100, Description: Maximum slider value.
#DesignerProperty: Key: Value, DisplayName: Current Value, FieldType: Int, DefaultValue: 40, Description: Current slider value.
#DesignerProperty: Key: StepValue, DisplayName: Step, FieldType: Int, DefaultValue: 1, Description: Step increment (0 for continuous).
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size variant.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant.
#DesignerProperty: Key: TrackColor, DisplayName: Track Color, FieldType: Color, DefaultValue: 0, Description: Custom track background color.
#DesignerProperty: Key: ProgressColor, DisplayName: Progress Color, FieldType: Color, DefaultValue: 0, Description: Custom progress fill color.
#DesignerProperty: Key: ThumbColor, DisplayName: Thumb Color, FieldType: Color, DefaultValue: 0, Description: Custom thumb knob color.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: ShowFill, DisplayName: Show Fill, FieldType: Boolean, DefaultValue: True, Description: Show progress fill from min to thumb position.
#DesignerProperty: Key: RTL, DisplayName: RTL, FieldType: Boolean, DefaultValue: False, Description: Right-to-left progress direction (--range-dir:-1 parity).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: DisallowParentIntercept, DisplayName: Disallow Parent Intercept, FieldType: Boolean, DefaultValue: True, Description: Prevent parent scroll containers from stealing touch gestures on Android.
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether the value must be greater than the minimum value.
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: String, DefaultValue:, Description: Label text displayed above the range slider.
#DesignerProperty: Key: LabelVisible, DisplayName: Label Visible, FieldType: Boolean, DefaultValue: False, Description: Whether the label above is visible.
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the range slider.
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Text displayed below the range slider when in the error validation state.
#DesignerProperty: Key: ShowValue, DisplayName: Show Value, FieldType: Boolean, DefaultValue: False, Description: Show a right-aligned live value readout above the slider.
#DesignerProperty: Key: ValuePrefix, DisplayName: Value Prefix, FieldType: String, DefaultValue:, Description: Text shown before the value (e.g. $).
#DesignerProperty: Key: ValueSuffix, DisplayName: Value Suffix, FieldType: String, DefaultValue:, Description: Text shown after the value (e.g. %, px, s).
#DesignerProperty: Key: IconLeft, DisplayName: Icon Left, FieldType: String, DefaultValue:, Description: Left-side (prepend) SVG icon asset name. Tapping decrements by Step.
#DesignerProperty: Key: IconRight, DisplayName: Icon Right, FieldType: String, DefaultValue:, Description: Right-side (append) SVG icon asset name. Tapping increments by Step.
#DesignerProperty: Key: IconSize, DisplayName: Icon Size, FieldType: Int, DefaultValue: 0, Description: Icon size in dip. 0 = auto-scale based on Size (matches thumb).
#DesignerProperty: Key: ShowTooltip, DisplayName: Show Tooltip, FieldType: Boolean, DefaultValue: False, Description: Show a tooltip with the current value above the thumb.
#DesignerProperty: Key: TooltipPosition, DisplayName: Tooltip Position, FieldType: String, DefaultValue: top, List: top|bottom|left|right, Description: Tooltip position relative to the thumb.
#DesignerProperty: Key: TooltipOpen, DisplayName: Tooltip Open, FieldType: Boolean, DefaultValue: False, Description: When True, tooltip stays permanently visible. When False, tooltip shows transiently during drag / on value change then fades out.
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private pnlSurface As B4XView
	Private pnlTrack As B4XView
	Private pnlProgress As B4XView
	Private pnlThumb As B4XView

	Private miMinValue As Int = 0
	Private miMaxValue As Int = 100
	Private miValue As Int = 40
	Private miStepValue As Int = 1
	Private mbRequired As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
	Private msErrorText As String = ""
	Private mSize As String = "md"
	Private mVariant As String = "none"
	Private mcTrackColor As Int = 0
	Private mcProgressColor As Int = 0
	Private mcThumbColor As Int = 0
	Private mEnabled As Boolean = True
	Private mVisible As Boolean = True
	Private mRTL As Boolean = False

	Private mbDragging As Boolean = False
	Private mDragOffsetX As Float = 0
	Private mbShowFill As Boolean = True
	Private mbDisallowParentIntercept As Boolean = True

    Private msLabelAbove As String = ""
    Private mbLabelVisible As Boolean = False
    Private msHintText As String = ""
    Private pnlLabelAbove As B4XView
    Private lblLabelAbove As B4XView
    Private pnlHintText As B4XView
    Private lblHintText As B4XView

	' --- Right-aligned value readout (top chrome row) ---
	Private mbShowValue As Boolean = False
	Private msValuePrefix As String = ""
	Private msValueSuffix As String = ""
	Private pnlValueAbove As B4XView
	Private lblValueAbove As B4XView

	' --- Prepend / Append icons (mirrors B4XDaisyProgress) ---
	Private msIconLeft As String = ""
	Private msIconRight As String = ""
	Private miIconSizeProp As Int = 0
	Private miIconSize As Int = 24dip
	Private svgLeftIcon As B4XDaisySvgIcon
	Private svgRightIcon As B4XDaisySvgIcon

	' --- Tooltip (mirrors B4XDaisyProgress) ---
	Private mbShowTooltip As Boolean = False
	Private msTooltipPosition As String = "top"
	Private mbTooltipOpen As Boolean = False
	Private tipTooltip As B4XDaisyTooltip
	Private tipBase As B4XView
	Private tipAnchor As B4XView
	Private mbTipAttached As Boolean = False
	Private mTipVariantApplied As String = ""
	Private mTipPositionApplied As String = ""
	Private tooltipHideTimer As Timer
	Private tooltipFadeTimer As Timer
	Private mTooltipFadingIn As Boolean = True
	Private mFadeStartTime As Long
	Private mTooltipAutoHideAfterFadeIn As Boolean = True
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' 1. Create surface panel for touches
	Dim pSurface As Panel
	pSurface.Initialize("pnlSurface")
	pnlSurface = pSurface
	pnlSurface.Color = xui.Color_Transparent
	mBase.AddView(pSurface, 0, 0, mBase.Width, mBase.Height)

	' 2. Create track background
	Dim pTrack As Panel
	pTrack.Initialize("")
	pnlTrack = pTrack
	pnlTrack.Color = xui.Color_Transparent
	pnlSurface.AddView(pTrack, 0, 0, 1dip, 1dip)

	' 3. Create progress overlay
	Dim pProgress As Panel
	pProgress.Initialize("")
	pnlProgress = pProgress
	pnlProgress.Color = xui.Color_Transparent
	pnlSurface.AddView(pProgress, 0, 0, 1dip, 1dip)

	' 4. Create thumb knob
	Dim pThumb As Panel
	pThumb.Initialize("")
	pnlThumb = pThumb
	pnlThumb.Color = xui.Color_Transparent
	pnlSurface.AddView(pThumb, 0, 0, 1dip, 1dip)

	' 5. Create label-above chrome (lives in mBase, outside pnlSurface, so it never steals touch)
	Dim pLA As Panel
	pLA.Initialize("")
	pnlLabelAbove = pLA
	pnlLabelAbove.Color = xui.Color_Transparent
	mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)

	Dim lLA As Label
	lLA.Initialize("")
	lblLabelAbove = lLA
	lblLabelAbove.Color = xui.Color_Transparent
	lblLabelAbove.SetTextAlignment("LEFT", "LEFT")
	#If B4A
	lLA.SingleLine = False
	#End If
	pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

	' 6. Create hint/error text chrome below the slider
	Dim pHT As Panel
	pHT.Initialize("")
	pnlHintText = pHT
	pnlHintText.Color = xui.Color_Transparent
	mBase.AddView(pnlHintText, 0, 0, 0, 0)

	Dim lHT As Label
	lHT.Initialize("")
	lblHintText = lHT
	lblHintText.Color = xui.Color_Transparent
	lblHintText.SetTextAlignment("LEFT", "LEFT")
	#If B4A
	lHT.SingleLine = False
	#End If
	pnlHintText.AddView(lblHintText, 0, 0, 0, 0)

	' 6b. Create right-aligned value readout chrome (top-right, shares the label row)
	Dim pVA As Panel
	pVA.Initialize("")
	pnlValueAbove = pVA
	pnlValueAbove.Color = xui.Color_Transparent
	mBase.AddView(pnlValueAbove, 0, 0, 0, 0)

	Dim lVA As Label
	lVA.Initialize("")
	lblValueAbove = lVA
	lblValueAbove.Color = xui.Color_Transparent
	lblValueAbove.SetTextAlignment("RIGHT", "RIGHT")
	#If B4A
	lVA.SingleLine = True
	#End If
	pnlValueAbove.AddView(lblValueAbove, 0, 0, 0, 0)

	' 7. Create tooltip anchor (1dip marker in mBase that follows the thumb center)
	Dim pAnchor As Panel
	pAnchor.Initialize("")
	tipAnchor = pAnchor
	tipAnchor.Color = xui.Color_Transparent
	mBase.AddView(tipAnchor, 0, 0, 1dip, 1dip)

	' 8. Initialize tooltip sub-component (hidden by default)
	tipTooltip.Initialize(Me, "tipTooltip")
	Dim pTip As Panel
	pTip.Initialize("")
	tipBase = pTip
	tipBase.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	tipTooltip.DesignerCreateView(tipBase, Null, CreateMap("Position": "top", "Visible": False, "ShowArrow": True))

	' 9. Initialize prepend/append SVG icons
	svgLeftIcon.Initialize(Me, "svgLeftIcon")
	svgRightIcon.Initialize(Me, "svgRightIcon")

	' 10. Initialize tooltip transient timers
	tooltipHideTimer.Initialize("tooltipHideTimer", 1200)
	tooltipHideTimer.Enabled = False
	tooltipFadeTimer.Initialize("tooltipFadeTimer", 16)
	tooltipFadeTimer.Enabled = False

	ApplyDesignerProps(mProps)
	#If B4A
		' setFocusable(True) allows keyboard/accessibility focus on the panel.
		' setFocusableInTouchMode is intentionally omitted: it would cause Android
		' to consume the first touch as a focus event, requiring a double-tap.
		Dim jo As JavaObject = pnlSurface
		jo.RunMethod("setFocusable", Array(True))
	#End If
	mBase.Visible = mVisible
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	miMinValue = B4XDaisyVariants.GetPropInt(mProps, "MinValue", miMinValue)
	miMaxValue = B4XDaisyVariants.GetPropInt(mProps, "MaxValue", miMaxValue)
	miValue = B4XDaisyVariants.GetPropInt(mProps, "Value", miValue)
	miStepValue = B4XDaisyVariants.GetPropInt(mProps, "StepValue", miStepValue)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mcTrackColor = B4XDaisyVariants.GetPropColor(mProps, "TrackColor", mcTrackColor)
	mcProgressColor = B4XDaisyVariants.GetPropColor(mProps, "ProgressColor", mcProgressColor)
	mcThumbColor = B4XDaisyVariants.GetPropColor(mProps, "ThumbColor", mcThumbColor)
	mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mEnabled)
	mbShowFill = B4XDaisyVariants.GetPropBool(mProps, "ShowFill", mbShowFill)
	mRTL = B4XDaisyVariants.GetPropBool(mProps, "RTL", mRTL)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mbDisallowParentIntercept = B4XDaisyVariants.GetPropBool(mProps, "DisallowParentIntercept", mbDisallowParentIntercept)
	msLabelAbove = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", msLabelAbove)
	mbLabelVisible = B4XDaisyVariants.GetPropBool(mProps, "LabelVisible", mbLabelVisible)
	msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", msHintText)
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
	mbShowValue = B4XDaisyVariants.GetPropBool(mProps, "ShowValue", mbShowValue)
	msValuePrefix = B4XDaisyVariants.GetPropString(mProps, "ValuePrefix", msValuePrefix)
	msValueSuffix = B4XDaisyVariants.GetPropString(mProps, "ValueSuffix", msValueSuffix)
	msIconLeft = B4XDaisyVariants.GetPropString(mProps, "IconLeft", msIconLeft)
	msIconRight = B4XDaisyVariants.GetPropString(mProps, "IconRight", msIconRight)
	miIconSizeProp = B4XDaisyVariants.GetPropInt(mProps, "IconSize", miIconSizeProp)
	mbShowTooltip = B4XDaisyVariants.GetPropBool(mProps, "ShowTooltip", mbShowTooltip)
	msTooltipPosition = B4XDaisyVariants.GetPropString(mProps, "TooltipPosition", msTooltipPosition)
	mbTooltipOpen = B4XDaisyVariants.GetPropBool(mProps, "TooltipOpen", mbTooltipOpen)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("MinValue", miMinValue)
	props.Put("MaxValue", miMaxValue)
	props.Put("Value", miValue)
	props.Put("StepValue", miStepValue)
	props.Put("Size", mSize)
	props.Put("Variant", mVariant)
	props.Put("TrackColor", mcTrackColor)
	props.Put("ProgressColor", mcProgressColor)
	props.Put("ThumbColor", mcThumbColor)
	props.Put("Enabled", mEnabled)
	props.Put("ShowFill", mbShowFill)
	props.Put("RTL", mRTL)
	props.Put("Visible", mVisible)
	props.Put("DisallowParentIntercept", mbDisallowParentIntercept)
	props.Put("Required", mbRequired)
	props.Put("LabelAbove", msLabelAbove)
	props.Put("LabelVisible", mbLabelVisible)
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	props.Put("ShowValue", mbShowValue)
	props.Put("ValuePrefix", msValuePrefix)
	props.Put("ValueSuffix", msValueSuffix)
	props.Put("IconLeft", msIconLeft)
	props.Put("IconRight", msIconRight)
	props.Put("IconSize", miIconSizeProp)
	props.Put("ShowTooltip", mbShowTooltip)
	props.Put("TooltipPosition", msTooltipPosition)
	props.Put("TooltipOpen", mbTooltipOpen)
	Return props
End Sub
#End Region

#Region Public API
''' <summary>
''' Sets the minimum value.
''' </summary>
Public Sub setMinValue(iValue As Int)
	miMinValue = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the minimum value.
''' </summary>
Public Sub getMinValue As Int
	Return miMinValue
End Sub

''' <summary>
''' Sets the maximum value.
''' </summary>
Public Sub setMaxValue(iValue As Int)
	miMaxValue = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the maximum value.
''' </summary>
Public Sub getMaxValue As Int
	Return miMaxValue
End Sub

''' <summary>
''' Sets the current value. When the tooltip is in transient mode, this briefly shows it.
''' </summary>
Public Sub setValue(iValue As Int)
	miValue = Max(miMinValue, Min(iValue, miMaxValue))
	If mBase.IsInitialized = False Then Return
	Refresh
	If mbShowTooltip And mbTooltipOpen = False Then ShowTooltipTransient
End Sub

''' <summary>
''' Gets the current value.
''' </summary>
Public Sub getValue As Int
	Return miValue
End Sub

''' <summary>
''' Sets the step increment.
''' </summary>
Public Sub setStepValue(iValue As Int)
	miStepValue = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the step increment.
''' </summary>
Public Sub getStepValue As Int
	Return miStepValue
End Sub

''' <summary>
''' Sets the Size.
''' </summary>
Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the Size.
''' </summary>
Public Sub getSize As String
	Return mSize
End Sub

''' <summary>
''' Sets the Variant.
''' </summary>
Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the Variant.
''' </summary>
Public Sub getVariant As String
	Return mVariant
End Sub

''' <summary>
''' Sets the Enabled state.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
	mEnabled = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the Enabled state.
''' </summary>
Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

''' <summary>
''' Sets whether the progress fill is shown.
''' When False, only the track and thumb are visible (--range-fill:0 parity).
''' </summary>
Public Sub setShowFill(bValue As Boolean)
	mbShowFill = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets whether the progress fill is shown.
''' </summary>
Public Sub getShowFill As Boolean
	Return mbShowFill
End Sub

''' <summary>
''' Sets the right-to-left direction for progress fill (--range-dir:-1 parity).
''' When True, progress fills from right to left.
''' </summary>
Public Sub setRTL(bValue As Boolean)
	mRTL = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the right-to-left direction.
''' </summary>
Public Sub getRTL As Boolean
	Return mRTL
End Sub

''' <summary>
''' Sets the Visible state.
''' </summary>
Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then
		mBase.Visible = bValue
		Refresh
	End If
End Sub

''' <summary>
''' Gets the Visible state.
''' </summary>
Public Sub getVisible As Boolean
	Return mVisible
End Sub

''' <summary>
''' Sets whether parent scroll containers are prevented from stealing touch gestures (B4A).
''' </summary>
Public Sub setDisallowParentIntercept(bValue As Boolean)
	mbDisallowParentIntercept = bValue
End Sub

''' <summary>
''' Gets whether parent scroll intercept is disallowed.
''' </summary>
Public Sub getDisallowParentIntercept As Boolean
	Return mbDisallowParentIntercept
End Sub

''' <summary>
''' Sets the custom track background color.
''' </summary>
Public Sub setTrackColor(iValue As Int)
	mcTrackColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the custom track background color.
''' </summary>
Public Sub getTrackColor As Int
	Return mcTrackColor
End Sub

''' <summary>
''' Sets the custom progress fill color.
''' </summary>
Public Sub setProgressColor(iValue As Int)
	mcProgressColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the custom progress fill color.
''' </summary>
Public Sub getProgressColor As Int
	Return mcProgressColor
End Sub

''' <summary>
''' Sets the custom thumb knob color.
''' </summary>
Public Sub setThumbColor(iValue As Int)
	mcThumbColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the custom thumb knob color.
''' </summary>
Public Sub getThumbColor As Int
	Return mcThumbColor
End Sub

''' <summary>
''' Sets the label text displayed above the range slider.
''' </summary>
Public Sub setLabelAbove(sValue As String)
	If sValue = Null Then sValue = ""
	msLabelAbove = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the label text displayed above the range slider.
''' </summary>
Public Sub getLabelAbove As String
	Return msLabelAbove
End Sub

''' <summary>
''' Sets whether the label above is visible.
''' </summary>
Public Sub setLabelVisible(bValue As Boolean)
	mbLabelVisible = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets whether the label above is visible.
''' </summary>
Public Sub getLabelVisible As Boolean
	Return mbLabelVisible
End Sub

''' <summary>
''' Sets the helper text displayed below the range slider.
''' </summary>
Public Sub setHintText(sValue As String)
	If sValue = Null Then sValue = ""
	msHintText = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the helper text displayed below the range slider.
''' </summary>
Public Sub getHintText As String
	Return msHintText
End Sub

' --- Right-aligned value readout properties ---

''' <summary>
''' Sets whether the right-aligned live value readout is shown above the slider.
''' </summary>
Public Sub setShowValue(bValue As Boolean)
	mbShowValue = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets whether the value readout is shown.
''' </summary>
Public Sub getShowValue As Boolean
	Return mbShowValue
End Sub

''' <summary>
''' Sets the text shown before the value (e.g. "$").
''' </summary>
Public Sub setValuePrefix(sValue As String)
	If sValue = Null Then sValue = ""
	msValuePrefix = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the value prefix.
''' </summary>
Public Sub getValuePrefix As String
	Return msValuePrefix
End Sub

''' <summary>
''' Sets the text shown after the value (e.g. "%", "px", "s").
''' </summary>
Public Sub setValueSuffix(sValue As String)
	If sValue = Null Then sValue = ""
	msValueSuffix = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the value suffix.
''' </summary>
Public Sub getValueSuffix As String
	Return msValueSuffix
End Sub

' --- Prepend / Append icon properties ---

''' <summary>
''' Sets the left (prepend) SVG icon asset name. Empty hides it.
''' Tapping the icon decrements the value by StepValue.
''' </summary>
Public Sub setIconLeft(sValue As String)
	If sValue = Null Then sValue = ""
	msIconLeft = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the left (prepend) SVG icon asset name.
''' </summary>
Public Sub getIconLeft As String
	Return msIconLeft
End Sub

''' <summary>
''' Sets the right (append) SVG icon asset name. Empty hides it.
''' Tapping the icon increments the value by StepValue.
''' </summary>
Public Sub setIconRight(sValue As String)
	If sValue = Null Then sValue = ""
	msIconRight = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the right (append) SVG icon asset name.
''' </summary>
Public Sub getIconRight As String
	Return msIconRight
End Sub

''' <summary>
''' Sets the icon size in dip. 0 = auto-scale based on Size (matches the thumb).
''' </summary>
Public Sub setIconSize(iValue As Int)
	miIconSizeProp = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the icon size in dip (0 = auto).
''' </summary>
Public Sub getIconSize As Int
	Return miIconSizeProp
End Sub

' --- Tooltip properties ---

''' <summary>
''' Sets whether the value tooltip is shown.
''' </summary>
Public Sub setShowTooltip(bValue As Boolean)
	mbShowTooltip = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets whether the value tooltip is shown.
''' </summary>
Public Sub getShowTooltip As Boolean
	Return mbShowTooltip
End Sub

''' <summary>
''' Sets the tooltip position relative to the thumb.
''' </summary>
Public Sub setTooltipPosition(sValue As String)
	msTooltipPosition = sValue.ToLowerCase
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the tooltip position.
''' </summary>
Public Sub getTooltipPosition As String
	Return msTooltipPosition
End Sub

''' <summary>
''' Sets the tooltip mode. True = permanently visible. False = transient (shows on drag / value change, then fades out).
''' </summary>
Public Sub setTooltipOpen(bValue As Boolean)
	mbTooltipOpen = bValue
	If mBase.IsInitialized = False Then Return
	If bValue = False Then
		' Switching to transient: hide any permanent tooltip immediately
		If tooltipHideTimer.IsInitialized Then tooltipHideTimer.Enabled = False
		If tooltipFadeTimer.IsInitialized Then tooltipFadeTimer.Enabled = False
		If tipTooltip.IsInitialized Then tipTooltip.Hide
	Else
		' Permanent mode: show immediately if ShowTooltip is on
		Refresh
	End If
End Sub

''' <summary>
''' Gets the tooltip mode.
''' </summary>
Public Sub getTooltipOpen As Boolean
	Return mbTooltipOpen
End Sub

''' <summary>
''' Sets width using a Tailwind size or dip token.
''' </summary>
Public Sub setWidth(sValue As String)
	If mBase.IsInitialized Then
		mBase.Width = B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Width)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

''' <summary>
''' Gets width string.
''' </summary>
Public Sub getWidth As String
	If mBase.IsInitialized Then Return mBase.Width & "dip"
	Return "0dip"
End Sub

''' <summary>
''' Sets height using a Tailwind size or dip token.
''' </summary>
Public Sub setHeight(sValue As String)
	If mBase.IsInitialized Then
		mBase.Height = B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Height)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

''' <summary>
''' Gets height string.
''' </summary>
Public Sub getHeight As String
	If mBase.IsInitialized Then Return mBase.Height & "dip"
	Return "0dip"
End Sub

''' <summary>
''' Sets the component tag.
''' </summary>
Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

''' <summary>
''' Gets the component tag.
''' </summary>
Public Sub getTag As Object
	Return mTag
End Sub

''' <summary>
''' Returns the component role.
''' </summary>
Public Sub getRole As String
	Return "range"
End Sub

''' <summary>
''' Forces the component to re-resolve theme-aware styling.
''' </summary>
Public Sub UpdateTheme
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Applies the current component state to the UI.
''' </summary>
Public Sub Refresh
	If mBase.IsInitialized = False Then Return

	If mEnabled Then
		mBase.Alpha = 255
	Else
		mBase.Alpha = 76
	End If

	#If B4A
	B4XDaisyVariants.DisableClippingRecursive(mBase)
	B4XDaisyVariants.DisableClipping(pnlSurface)
	#End If

	Base_Resize(mBase.Width, mBase.Height)
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase

	Dim targetW As Int = iWidth
	Dim targetH As Int = iHeight
	If targetW <= 0 Then targetW = 200dip
	If targetH <= 0 Then targetH = ResolveThumbSizeDip

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		DesignerCreateView(p, Null, BuildRuntimeProps(targetW, targetH))
	End If

	vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
	Refresh
	Return mBase
End Sub

''' <summary>
''' Returns the core view instance.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Gets the complete height of the component.
''' </summary>
Public Sub getComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' <summary>
''' Programmatic layout setup helper.
''' </summary>
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
End Sub

''' <summary>
''' Requests focus for the component.
''' </summary>
Public Sub RequestFocus
	If pnlSurface.IsInitialized Then pnlSurface.RequestFocus
End Sub

''' <summary>
''' Sets or clears focus for the component.
''' </summary>
Public Sub setFocus(bValue As Boolean)
	If pnlSurface.IsInitialized = False Then Return
	#If B4A
		Dim jo As JavaObject = pnlSurface
		If bValue Then jo.RunMethod("requestFocus", Null) Else jo.RunMethod("clearFocus", Null)
	#End If
End Sub

''' <summary>
''' Called when the range receives focus. Clears any transient
''' validation error visual so the user can interact without a distracting red border.
''' </summary>
Public Sub ReceiveFocus
        If msErrorText.Length > 0 And mbProgrammaticError = False Then
                msErrorText = ""
        End If
        If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Called when the component loses focus.
''' </summary>
Public Sub Blur
    If mBase.IsInitialized Then Refresh
End Sub
#End Region

#Region Layout & Drawing
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If pnlSurface.IsInitialized = False Then Return

	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)

	' --- Top chrome row: Label Above (left) + Value readout (right) ---
	Dim labelAboveH As Int = 0
	Dim measuredLabelH As Int = 0
	Dim aboveTextSize As Float = B4XDaisyVariants.ResolveLabelSizeDip(mSize)
	Dim labelAvailW As Int = w - 4dip
	' Value readout (right-aligned) - measured first so the label width can be capped to avoid overlap.
	Dim valueText As String = ""
	Dim valueW As Int = 0
	Dim measuredValueH As Int = 0
	If mbShowValue Then
		valueText = ResolveValueText
		valueW = B4XDaisyVariants.MeasureTextWidthSafe(valueText, aboveTextSize, Typeface.DEFAULT, 4dip)
		measuredValueH = B4XDaisyVariants.MeasureTextHeightSafe(valueText, aboveTextSize, Typeface.DEFAULT, Max(1dip, valueW), 4dip)
		labelAvailW = Max(1dip, w - valueW - 8dip - 4dip) ' value width + gap + padding
	End If
	If mbLabelVisible And msLabelAbove.Length > 0 Then
		Dim labelText As String = ResolveLabelAboveText
		measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(labelText, aboveTextSize, Typeface.DEFAULT, labelAvailW, 4dip)
		labelAboveH = measuredLabelH + 4dip
	End If
	If mbShowValue Then
		Dim valueRowH As Int = measuredValueH + 4dip
		If valueRowH > labelAboveH Then labelAboveH = valueRowH
	End If

	' --- Hint / Error text below ---
	Dim displayedHint As String = msHintText
	If msErrorText.Length > 0 Then displayedHint = msErrorText
	Dim rawHintH As Int = 0
	Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
	If displayedHint.Length > 0 Then
		rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
	End If
	Dim gap As Int = 4dip

	' --- Determine slider band + total height ---
	' Auto-grow only when chrome (label/hint) is present so existing label/hint-less
	' usage runs the original code path verbatim (zero regression).
	Dim hasChrome As Boolean = (labelAboveH > 0) Or (rawHintH > 0)
	Dim surfaceY As Int = 0
	Dim surfaceH As Int = h
	If hasChrome Then
		Dim sliderAreaH As Int = ResolveThumbSizeDip
		surfaceY = labelAboveH
		surfaceH = sliderAreaH
		Dim totalH As Int = labelAboveH + sliderAreaH
		If rawHintH > 0 Then totalH = totalH + gap + rawHintH
		If h <> totalH Then
			h = totalH
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
		End If
	End If

	' --- Position label above (left) ---
	If mbLabelVisible And msLabelAbove.Length > 0 Then
		pnlLabelAbove.Visible = True
		pnlLabelAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
		lblLabelAbove.SetLayoutAnimated(0, 2dip, 2dip, labelAvailW, measuredLabelH)
		Dim labelAboveColor As Int = ResolveLabelAboveColor
		ApplyRequiredLabelText(lblLabelAbove, ResolveLabelAboveText, labelAboveColor, ResolveRequiredStarColor(labelAboveColor))
		lblLabelAbove.TextSize = aboveTextSize
	Else
		If pnlLabelAbove.IsInitialized Then
			pnlLabelAbove.Visible = False
			pnlLabelAbove.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	End If

	' --- Position value readout above (right) ---
	If mbShowValue Then
		pnlValueAbove.Visible = True
		pnlValueAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
		Dim valY As Int = (labelAboveH - measuredValueH) / 2
		lblValueAbove.SetLayoutAnimated(0, w - valueW - 2dip, valY, valueW, measuredValueH)
		lblValueAbove.Text = valueText
		lblValueAbove.TextSize = aboveTextSize
		lblValueAbove.TextColor = ResolveValueColor
	Else
		If pnlValueAbove.IsInitialized Then
			pnlValueAbove.Visible = False
			pnlValueAbove.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	End If

	' --- Resolve icon size (auto = thumb size) ---
	If miIconSizeProp > 0 Then
		miIconSize = miIconSizeProp * 1dip
	Else
		miIconSize = ResolveThumbSizeDip
	End If

	' --- Compute icon gutters (prepend/append) ---
	Dim leftMargin As Int = 0
	Dim rightMargin As Int = 0

	If msIconLeft <> "" Then
		If svgLeftIcon.mBase.IsInitialized = False Then
			svgLeftIcon.AddToParent(mBase, 0, 0, miIconSize, miIconSize)
		End If
		svgLeftIcon.mBase.Visible = True
		Dim iconTop As Int = surfaceY + (surfaceH - miIconSize) / 2
		svgLeftIcon.mBase.SetLayoutAnimated(0, 0, iconTop, miIconSize, miIconSize)
		svgLeftIcon.SvgAsset = msIconLeft
		svgLeftIcon.Color = ResolveIconColor
		leftMargin = miIconSize + 8dip
	Else
		If svgLeftIcon.mBase.IsInitialized Then svgLeftIcon.mBase.Visible = False
	End If

	If msIconRight <> "" Then
		If svgRightIcon.mBase.IsInitialized = False Then
			svgRightIcon.AddToParent(mBase, 0, 0, miIconSize, miIconSize)
		End If
		svgRightIcon.mBase.Visible = True
		Dim iconTopR As Int = surfaceY + (surfaceH - miIconSize) / 2
		svgRightIcon.mBase.SetLayoutAnimated(0, w - miIconSize, iconTopR, miIconSize, miIconSize)
		svgRightIcon.SvgAsset = msIconRight
		svgRightIcon.Color = ResolveIconColor
		rightMargin = miIconSize + 8dip
	Else
		If svgRightIcon.mBase.IsInitialized Then svgRightIcon.mBase.Visible = False
	End If

	' --- Touch surface occupies the slider band, shrunk by icon gutters ---
	Dim surfaceW As Int = Max(1dip, w - leftMargin - rightMargin)
	pnlSurface.SetLayoutAnimated(0, leftMargin, surfaceY, surfaceW, surfaceH)

	Dim thumbSize As Float = ResolveThumbSizeDip
	Dim trackH As Float = thumbSize * 0.5
	Dim sliderW As Float = surfaceW - thumbSize

	Dim pct As Float = 0
	If miMaxValue > miMinValue Then
		pct = (miValue - miMinValue) / (miMaxValue - miMinValue)
	End If
	pct = Max(0, Min(pct, 1.0))

	Dim thumbLeft As Float = pct * sliderW
	Dim trackTop As Float = (surfaceH - trackH) / 2
	Dim thumbTop As Float = (surfaceH - thumbSize) / 2

	' CSS: progress is a box-shadow on the thumb, so it extends from the edge
	' to cover the full thumb width - the thumb sits "inside" the progress fill.
	Dim progressLeft As Float = 0
	Dim progressWidth As Float = thumbLeft + thumbSize
	If mRTL Then
		thumbLeft = sliderW - thumbLeft
		progressLeft = thumbLeft
		progressWidth = surfaceW - thumbLeft
	End If

	pnlTrack.SetLayoutAnimated(0, 0, trackTop, surfaceW, trackH)
	If mbShowFill Then
		pnlProgress.Visible = True
		pnlProgress.SetLayoutAnimated(0, progressLeft, thumbTop, progressWidth, thumbSize)
	Else
		pnlProgress.Visible = False
	End If
	pnlThumb.SetLayoutAnimated(0, thumbLeft, thumbTop, thumbSize, thumbSize)

	UpdateVisuals(trackH, thumbSize)

	' --- Tooltip anchor sits on the edge of the thumb that the tooltip points at,
	' --- so the needle tip touches the handle and the tail is centered on it.
	Dim anchorX As Int = leftMargin + thumbLeft + thumbSize / 2
	Dim anchorY As Int = surfaceY + thumbTop + thumbSize / 2
	Dim tipPos As String = msTooltipPosition.ToLowerCase.Trim
	Select Case tipPos
		Case "top"
			anchorY = surfaceY + thumbTop
		Case "bottom"
			anchorY = surfaceY + thumbTop + thumbSize
		Case "left"
			anchorX = leftMargin + thumbLeft
		Case "right"
			anchorX = leftMargin + thumbLeft + thumbSize
	End Select
	tipAnchor.SetLayoutAnimated(0, anchorX, anchorY, 1dip, 1dip)

	SyncTooltip

	' --- Hint / error text below the slider ---
	If rawHintH > 0 Then
		pnlHintText.Visible = True
		lblHintText.Text = displayedHint
		lblHintText.TextSize = hintTxtSize
		Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
		Dim hintColor As Int = Bit.Or(0x99000000, Bit.And(0x00FFFFFF, baseContent))
		If msErrorText.Length > 0 Then hintColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
		lblHintText.TextColor = hintColor
		Dim hintY As Int = surfaceY + surfaceH + gap
		pnlHintText.SetLayoutAnimated(0, 0, hintY, w, rawHintH)
		lblHintText.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, rawHintH)
	Else
		If pnlHintText.IsInitialized Then
			pnlHintText.Visible = False
			pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	End If
	inResize = False
End Sub

Private Sub ResolveIconColor As Int
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim fallbackContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))
	Dim variantKey As String = ""
	If mVariant <> Null Then variantKey = mVariant.ToLowerCase.Trim
	If variantKey <> "none" And variantKey <> "" Then
		Return B4XDaisyVariants.ResolveBackgroundColorVariant(variantKey, fallbackContent)
	End If
	Return fallbackContent
End Sub

Private Sub UpdateVisuals(fTrackH As Float, fThumbSize As Float)
	Dim xColors As Map = ResolveVisualColors
	Dim trackBack As Int = xColors.Get("trackBack")
	Dim progressBack As Int = xColors.Get("progressBack")
	Dim thumbBack As Int = xColors.Get("thumbBack")
	Dim thumbBorder As Int = xColors.Get("thumbBorder")

	' Proportional radii: track gets pill shape, thumb gets circle.
	' CSS constant radii (4dip track, 8dip thumb) look too angular on mobile - proportional matches native expectations.
	Dim trackRadius As Float = fTrackH / 2
	Dim thumbRadius As Float = fThumbSize / 2
	Dim progressRadius As Float = thumbRadius  ' CSS: progress is thumb's box-shadow, inherits thumb radius

	ApplyPanelStyle(pnlTrack, trackBack, 0, 0, trackRadius)
	ApplyPanelStyle(pnlProgress, progressBack, 0, 0, progressRadius)

	Dim borderPx As Float = 4dip  ' --range-p: 0.25rem thumb border
	ApplyPanelStyle(pnlThumb, thumbBack, borderPx, thumbBorder, thumbRadius)

	' CSS elevation shadows are controlled by --depth token. Default light theme has --depth:0 (no shadow).
	Dim depth As Float = B4XDaisyVariants.GetTokenNumber("--depth", 0)
	#If B4A
	If depth > 0 Then
		B4XDaisyVariants.ApplyElevation(pnlThumb, "sm")
	End If
	#End If
End Sub

Private Sub ApplyPanelStyle(vP As B4XView, iBackColor As Int, fBorderWidth As Float, iBorderColor As Int, fRadius As Float)
	#If B4A
	Try
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setColor", Array(iBackColor))
		
		Dim shape As Int = 0
		If Abs(vP.Width - vP.Height) < 1dip And fRadius >= vP.Width / 2 - 0.5dip Then
			shape = 1 ' OVAL
		End If
		gd.RunMethod("setShape", Array(shape))
		
		If shape = 0 Then
			Dim r As Float = Max(0, fRadius)
			Dim radii() As Float = Array As Float(r, r, r, r, r, r, r, r)
			gd.RunMethod("setCornerRadii", Array(radii))
		End If
		
		If fBorderWidth > 0 Then 
			gd.RunMethod("setStroke", Array(Round(fBorderWidth), iBorderColor))
		End If
		Dim jo As JavaObject = vP
		jo.RunMethod("setBackground", Array(gd))
	Catch
		vP.SetColorAndBorder(iBackColor, fBorderWidth, iBorderColor, fRadius)
	End Try
	#Else
	vP.SetColorAndBorder(iBackColor, fBorderWidth, iBorderColor, fRadius)
	#End If
End Sub

Private Sub ResolveVisualColors As Map
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim base100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))
	
	Dim progressBack As Int = baseContent
	Dim thumbBack As Int = base100
	Dim thumbBorder As Int = baseContent

	Dim variantKey As String = ""
	If mVariant <> Null Then variantKey = mVariant.ToLowerCase.Trim
	If variantKey <> "none" And variantKey <> "" Then
		progressBack = B4XDaisyVariants.ResolveBackgroundColorVariant(variantKey, baseContent)
		thumbBorder = progressBack
		thumbBack = B4XDaisyVariants.ResolveTextColorVariant(variantKey, base100)
	End If

	Dim trackBack As Int = B4XDaisyVariants.AlphaColor(progressBack, 0.1) ' 10% opacity

	If mcTrackColor <> 0 Then
		trackBack = mcTrackColor
	End If
	
	If mcProgressColor <> 0 Then
		progressBack = mcProgressColor
		thumbBorder = mcProgressColor
	End If
	
	If mcThumbColor <> 0 Then
		thumbBack = mcThumbColor
	End If

	Return CreateMap("trackBack": trackBack, "progressBack": progressBack, "thumbBack": thumbBack, "thumbBorder": thumbBorder)
End Sub

Private Sub ResolveThumbSizeDip As Float
	Select Case mSize.ToLowerCase
		Case "xs": Return 16dip
		Case "sm": Return 20dip
		Case "md": Return 24dip
		Case "lg": Return 28dip
		Case "xl": Return 32dip
		Case Else
			Return 24dip
	End Select
End Sub

' --- Label Above / Required red-star / Hint helpers (mirrors B4XDaisySelect) ---

Private Sub ResolveLabelAboveText As String
	If mbRequired And msLabelAbove.Length > 0 Then
		If msLabelAbove.Contains("*") = False Then
			Return msLabelAbove & " *"
		End If
	End If
	Return msLabelAbove
End Sub

Private Sub ResolveLabelAboveColor As Int
	Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	If mEnabled = False Then
		Return B4XDaisyVariants.AlphaColor(c, 0.2)
	End If
	Return c
End Sub

Private Sub ResolveRequiredStarColor(iNormalColor As Int) As Int
	If mEnabled = False Then Return iNormalColor
	Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
End Sub

' --- Right-aligned value readout helpers ---

Private Sub ResolveValueText As String
	Return msValuePrefix & miValue & msValueSuffix
End Sub

Private Sub ResolveValueColor As Int
	Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	If mEnabled = False Then
		Return B4XDaisyVariants.AlphaColor(c, 0.2)
	End If
	Return c
End Sub

Private Sub ApplyRequiredLabelText(vLbl As B4XView, sDisplayText As String, iNormalColor As Int, iStarColor As Int)
	If sDisplayText.Length = 0 Then
		vLbl.Text = ""
		Return
	End If
	If mbRequired And sDisplayText.Contains("*") Then
		Dim starPos As Int = sDisplayText.LastIndexOf("*")
		If starPos >= 0 Then
			Dim basePart As String = sDisplayText.SubString2(0, starPos)
			Dim cs As CSBuilder
			cs.Initialize
			If basePart.Length > 0 Then
				cs.Append(basePart)
			End If
			cs.Color(iStarColor).Append("*").Pop
			vLbl.TextColor = iNormalColor
			B4XDaisyVariants.SetTextOrCSBuilderToLabel(vLbl, cs)
			Return
		End If
	End If
	vLbl.Text = sDisplayText
	vLbl.TextColor = iNormalColor
End Sub
#End Region

#Region Tooltip
''' <summary>
''' Positions / updates the tooltip to match the current thumb anchor.
''' In permanent mode it stays visible; in transient mode visibility is
''' controlled by the fade timers and drag gestures.
''' </summary>
Private Sub SyncTooltip
	If mBase.IsInitialized = False Then Return
	If tipTooltip.IsInitialized = False Then Return

	If mbShowTooltip = False Then
		tipTooltip.Hide
		Return
	End If

	' Attach the tooltip to the anchor (once); afterwards just resync.
	If mbTipAttached = False Then
		tipTooltip.AttachTo(tipAnchor)
		mbTipAttached = True
	Else
		tipTooltip.Refresh
	End If

	' Apply variant / position only when they change (each setter re-renders).
	Dim vKey As String = ""
	If mVariant <> Null Then vKey = mVariant.ToLowerCase.Trim
	If vKey <> mTipVariantApplied Then
		tipTooltip.setVariant(mVariant)
		mTipVariantApplied = vKey
	End If
	Dim pKey As String = msTooltipPosition.ToLowerCase.Trim
	If pKey <> mTipPositionApplied Then
		tipTooltip.setPosition(msTooltipPosition)
		mTipPositionApplied = pKey
	End If

	' Update the message (setMessage re-renders + resyncs to the anchor).
	tipTooltip.setMessage(Round(miValue))

	' Permanent mode: keep it visible.
	If mbTooltipOpen Then
		tipTooltip.mBase.Alpha = 1
		tipTooltip.Show
	End If
End Sub

' Show tooltip with fade-in, then auto-hide after a hold (icon tap / programmatic setValue).
Private Sub ShowTooltipTransient
	If mbShowTooltip = False Or tipTooltip.IsInitialized = False Then Return
	If mbTooltipOpen Then Return	' permanent mode handled by SyncTooltip

	tooltipHideTimer.Enabled = False
	tooltipFadeTimer.Enabled = False
	mTooltipAutoHideAfterFadeIn = True

	' Already fully visible: just restart the hold timer.
	If tipTooltip.getVisible And tipTooltip.mBase.Alpha >= 1 Then
		tooltipHideTimer.Enabled = True
		Return
	End If

	' Fade in: alpha 0 -> 1 over 150 ms.
	tipTooltip.mBase.Alpha = 0
	tipTooltip.Show
	mTooltipFadingIn = True
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

' Show tooltip with fade-in only - no auto-hide (used at drag start so it stays during the drag).
Private Sub ShowTooltipFadeIn
	If mbShowTooltip = False Or tipTooltip.IsInitialized = False Then Return
	If mbTooltipOpen Then Return

	tooltipHideTimer.Enabled = False

	' Already fully visible: keep it visible.
	If tipTooltip.getVisible And tipTooltip.mBase.Alpha >= 1 Then
		tooltipFadeTimer.Enabled = False
		Return
	End If

	tooltipFadeTimer.Enabled = False
	mTooltipAutoHideAfterFadeIn = False
	tipTooltip.mBase.Alpha = 0
	tipTooltip.Show
	mTooltipFadingIn = True
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

' Schedule a fade-out after the hold delay (called on drag release).
Private Sub ScheduleTooltipHide
	If mbShowTooltip = False Or tipTooltip.IsInitialized = False Then Return
	If mbTooltipOpen Then Return
	tooltipFadeTimer.Enabled = False
	tooltipHideTimer.Enabled = True
End Sub

Private Sub tooltipHideTimer_Tick
	tooltipHideTimer.Enabled = False
	If tipTooltip.IsInitialized = False Then Return
	' Start fade-out: alpha 1 -> 0 over 250 ms.
	mTooltipFadingIn = False
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

Private Sub tooltipFadeTimer_Tick
	If tipTooltip.IsInitialized = False Then
		tooltipFadeTimer.Enabled = False
		Return
	End If
	Dim elapsed As Long = DateTime.Now - mFadeStartTime
	If mTooltipFadingIn Then
		' Fade in over 150 ms.
		Dim progress As Float = Min(1.0, elapsed / 150)
		tipTooltip.mBase.Alpha = progress
		If progress >= 1.0 Then
			tooltipFadeTimer.Enabled = False
			If mTooltipAutoHideAfterFadeIn Then
				tooltipHideTimer.Enabled = True
			End If
		End If
	Else
		' Fade out over 250 ms.
		Dim progress As Float = Min(1.0, elapsed / 250)
		tipTooltip.mBase.Alpha = 1.0 - progress
		If progress >= 1.0 Then
			tooltipFadeTimer.Enabled = False
			tipTooltip.Hide
			tipTooltip.mBase.Alpha = 1.0	' reset for next transient show
		End If
	End If
End Sub
#End Region

#Region Touch & Interaction
Private Sub pnlSurface_Touch(iAction As Int, fX As Float, fY As Float)
	If mEnabled = False Then Return
	#If B4A
	If mbDisallowParentIntercept Then B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
	#End If
	If pnlSurface.Width <= 0 Then Return
	Select iAction
		Case mBase.TOUCH_ACTION_DOWN
			mbDragging = True
			' Transient tooltip: fade in and stay visible for the duration of the drag.
			If mbShowTooltip And mbTooltipOpen = False Then ShowTooltipFadeIn
			Dim thumbSize As Float = ResolveThumbSizeDip
			Dim currentLeft As Float = CalculateThumbLeft(miValue)
			If fX >= currentLeft - 12dip And fX <= currentLeft + thumbSize + 12dip Then
				mDragOffsetX = fX - currentLeft
			Else
				mDragOffsetX = thumbSize / 2
				UpdateValueFromX(fX - mDragOffsetX)
			End If
		Case mBase.TOUCH_ACTION_MOVE
			If mbDragging Then
				UpdateValueFromX(fX - mDragOffsetX)
			End If
		Case Else
			If mbDragging Then
				mbDragging = False
				' Transient tooltip: hold then fade out after release.
				If mbShowTooltip And mbTooltipOpen = False Then ScheduleTooltipHide
			End If
	End Select
End Sub

#If B4A
''' <summary>
''' Climbs the view hierarchy and asks each parent to disallow touch intercept,
''' so scroll containers do not steal drag gestures from the slider. Stops at
''' ViewRootImpl to avoid platform exceptions.
''' </summary>

#End If

Private Sub CalculateThumbLeft(iValue As Int) As Float
	Dim thumbSize As Float = ResolveThumbSizeDip
	Dim trackWidth As Float = pnlSurface.Width - thumbSize
	If trackWidth <= 0 Then Return 0
	
	Dim pct As Float = 0
	If miMaxValue > miMinValue Then
		pct = (iValue - miMinValue) / (miMaxValue - miMinValue)
	End If
	pct = Max(0, Min(pct, 1.0))
	If mRTL Then pct = 1.0 - pct
	Return pct * trackWidth
End Sub

Private Sub UpdateValueFromX(fLeft As Float)
	Dim thumbSize As Float = ResolveThumbSizeDip
	Dim trackWidth As Float = pnlSurface.Width - thumbSize
	If trackWidth <= 0 Then Return

	Dim pct As Float = fLeft / trackWidth
	If mRTL Then pct = 1.0 - pct
	pct = Max(0, Min(pct, 1.0))
	
	Dim rawVal As Float = miMinValue + pct * (miMaxValue - miMinValue)
	
	If miStepValue > 0 Then
		Dim steps As Int = Round((rawVal - miMinValue) / miStepValue)
		miValue = miMinValue + steps * miStepValue
	Else
		miValue = Round(rawVal)
	End If
	
	miValue = Max(miMinValue, Min(miValue, miMaxValue))
	Refresh
	RaiseChanged(miValue)
End Sub

Private Sub RaiseChanged(iValue As Int)
	If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", iValue)
	End If
End Sub

' --- Prepend / Append icon tap handlers (step down / up) ---

Private Sub svgLeftIcon_Click (oTag As Object)
	If mEnabled = False Then Return
	Dim v As Int = Max(miMinValue, miValue - miStepValue)
	setValue(v)
	RaiseChanged(miValue)
End Sub

Private Sub svgRightIcon_Click (oTag As Object)
	If mEnabled = False Then Return
	Dim v As Int = Min(miMaxValue, miValue + miStepValue)
	setValue(v)
	RaiseChanged(miValue)
End Sub
#End Region


Private Sub pnlSurface_FocusChanged(bHasFocus As Boolean)
        ' Route focus changes through public validation hooks:
        ' clear transient errors on focus, re-validate on blur.
        If bHasFocus Then
                ReceiveFocus
        Else
                Blur
        End If
        If xui.SubExists(mCallBack, mEventName & "_FocusChanged", 1) Then
                CallSub2(mCallBack, mEventName & "_FocusChanged", bHasFocus)
        End If
End Sub

#Region Cleanup

' Required / error validation helpers
Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRequired As Boolean
	Return mbRequired
End Sub

Public Sub setErrorText(sValue As String)
	If sValue = Null Then sValue = ""
	msErrorText = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getErrorText As String
	Return msErrorText
End Sub

Public Sub getIsValid As Boolean
	Return (msErrorText.Length = 0)
End Sub

''' <summary>
''' Dynamically sets the range into an error validation state and displays the specified error text.
''' </summary>
Public Sub ShowError(sErrorMessage As String)
        msErrorText = sErrorMessage
        mbProgrammaticError = True
        If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Clears any dynamic error state and returns the range to normal.
''' </summary>
Public Sub ClearError
        msErrorText = ""
        mbProgrammaticError = False
        mbValidationTouched = False
        If mBase.IsInitialized Then Refresh
End Sub

Public Sub Validate As Boolean
	Dim ok As Boolean
	If mbRequired = False Then
		mbProgrammaticError = False
		msErrorText = ""
		ok = True
	Else If miValue > miMinValue Then
		mbProgrammaticError = False
		msErrorText = ""
		ok = True
	Else
		mbValidationTouched = True
		If msErrorText.Length = 0 Then msErrorText = "This field is required."
		ok = False
	End If
	If mBase.IsInitialized Then Refresh
	Return ok
End Sub

''' <summary>
''' Stops any running tooltip fade timers.
''' </summary>
Public Sub StopAnimation
	If tooltipHideTimer.IsInitialized Then tooltipHideTimer.Enabled = False
	If tooltipFadeTimer.IsInitialized Then tooltipFadeTimer.Enabled = False
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Release
	StopAnimation
	mCallBack = Null
	pnlLabelAbove = Null
	lblLabelAbove = Null
	pnlHintText = Null
	lblHintText = Null
	pnlValueAbove = Null
	lblValueAbove = Null
	svgLeftIcon = Null
	svgRightIcon = Null
	tipTooltip = Null
	tipAnchor = Null
	tipBase = Null
End Sub
#End Region

' DaisyUI token support map for parity validation:
' align-middle bg-transparent box-border cursor-not-allowed cursor-pointer flex justify-between max-w-xs mt-2 opacity-30 overflow-hidden px-2.5 range range-accent range-error range-info range-lg range-md range-neutral range-primary range-secondary range-sm range-success range-warning range-xl range-xs relative text-accent text-blue-300 text-error text-info text-neutral text-primary text-secondary text-success text-warning text-xs w-full
' Custom property parity: [--range-bg] via TrackColor, [--range-thumb] via ThumbColor, [--range-progress] via ProgressColor, [--range-fill] via ShowFill
' SithasoDaisy extensions: IconLeft/IconRight (prepend/append tap-to-step SVG icons), IconSize, ShowTooltip/TooltipPosition/TooltipOpen (value tooltip).

#Region B4XView Layout Wrapper Methods
Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized Then Return mBase.Top
	Return 0
End Sub

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
