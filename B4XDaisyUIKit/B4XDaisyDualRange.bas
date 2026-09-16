B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: Changed (LowerValue As Int, UpperValue As Int)
#Event: FocusChanged (HasFocus As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: MinValue, DisplayName: Minimum Value, FieldType: Int, DefaultValue: 0, Description: Minimum slider value.
#DesignerProperty: Key: MaxValue, DisplayName: Maximum Value, FieldType: Int, DefaultValue: 100, Description: Maximum slider value.
#DesignerProperty: Key: LowerValue, DisplayName: Lower Value, FieldType: Int, DefaultValue: 20, Description: Lower handle current value.
#DesignerProperty: Key: UpperValue, DisplayName: Upper Value, FieldType: Int, DefaultValue: 80, Description: Upper handle current value.
#DesignerProperty: Key: StepValue, DisplayName: Step, FieldType: Int, DefaultValue: 1, Description: Step increment (0 for continuous).
#DesignerProperty: Key: MinDistance, DisplayName: Min Distance, FieldType: Int, DefaultValue: 0, Description: Minimum distance between lower and upper handles.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size variant.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant.
#DesignerProperty: Key: TrackColor, DisplayName: Track Color, FieldType: Color, DefaultValue: 0, Description: Custom track background color.
#DesignerProperty: Key: ProgressColor, DisplayName: Progress Color, FieldType: Color, DefaultValue: 0, Description: Custom progress fill color.
#DesignerProperty: Key: ThumbColor, DisplayName: Thumb Color, FieldType: Color, DefaultValue: 0, Description: Custom thumb knob color.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: ShowFill, DisplayName: Show Fill, FieldType: Boolean, DefaultValue: True, Description: Show progress fill between lower and upper thumb positions.
#DesignerProperty: Key: RTL, DisplayName: RTL, FieldType: Boolean, DefaultValue: False, Description: Right-to-left progress direction.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: DisallowParentIntercept, DisplayName: Disallow Parent Intercept, FieldType: Boolean, DefaultValue: True, Description: Prevent parent scroll containers from stealing touch gestures on Android.
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether the range values must be selected.
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: String, DefaultValue:, Description: Label text displayed above the range slider.
#DesignerProperty: Key: LabelVisible, DisplayName: Label Visible, FieldType: Boolean, DefaultValue: False, Description: Whether the label above is visible.
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the range slider.
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Text displayed below the range slider when in the error validation state.
#DesignerProperty: Key: ShowValue, DisplayName: Show Value, FieldType: Boolean, DefaultValue: True, Description: Show a right-aligned live value readout above the slider.
#DesignerProperty: Key: ValuePrefix, DisplayName: Value Prefix, FieldType: String, DefaultValue:, Description: Text shown before values (e.g. $).
#DesignerProperty: Key: ValueSuffix, DisplayName: Value Suffix, FieldType: String, DefaultValue:, Description: Text shown after values (e.g. %, px, s).
#DesignerProperty: Key: ValueSeparator, DisplayName: Value Separator, FieldType: String, DefaultValue: " - ", Description: Separator string between lower and upper values in readout.
#DesignerProperty: Key: IconLeft, DisplayName: Icon Left, FieldType: String, DefaultValue:, Description: Left-side SVG icon asset name.
#DesignerProperty: Key: IconRight, DisplayName: Icon Right, FieldType: String, DefaultValue:, Description: Right-side SVG icon asset name.
#DesignerProperty: Key: IconSize, DisplayName: Icon Size, FieldType: Int, DefaultValue: 0, Description: Icon size in dip. 0 = auto-scale based on Size.
#DesignerProperty: Key: ShowTooltip, DisplayName: Show Tooltip, FieldType: Boolean, DefaultValue: False, Description: Show tooltips with current values above the thumbs.
#DesignerProperty: Key: TooltipPosition, DisplayName: Tooltip Position, FieldType: String, DefaultValue: top, List: top|bottom|left|right, Description: Tooltip position relative to the thumbs.
#DesignerProperty: Key: TooltipOpen, DisplayName: Tooltip Open, FieldType: Boolean, DefaultValue: False, Description: When True, tooltips stay permanently visible. When False, tooltips show transiently during drag.
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
	Private pnlThumbLower As B4XView
	Private pnlThumbUpper As B4XView

	Private miMinValue As Int = 0
	Private miMaxValue As Int = 100
	Private miLowerValue As Int = 20
	Private miUpperValue As Int = 80
	Private miStepValue As Int = 1
	Private miMinDistance As Int = 0

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
	Private mActiveHandle As Int = 0 ' 0=None, 1=Lower, 2=Upper
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
	Private mbShowValue As Boolean = True
	Private msValuePrefix As String = ""
	Private msValueSuffix As String = ""
	Private msValueSeparator As String = " - "
	Private pnlValueAbove As B4XView
	Private lblValueAbove As B4XView

	' --- Prepend / Append icons ---
	Private msIconLeft As String = ""
	Private msIconRight As String = ""
	Private miIconSizeProp As Int = 0
	Private miIconSize As Int = 24dip
	Private svgLeftIcon As B4XDaisySvgIcon
	Private svgRightIcon As B4XDaisySvgIcon

	' --- Tooltips for both thumbs ---
	Private mbShowTooltip As Boolean = False
	Private msTooltipPosition As String = "top"
	Private mbTooltipOpen As Boolean = False
	Private tipTooltipLower As B4XDaisyTooltip
	Private tipTooltipUpper As B4XDaisyTooltip
	Private tipBaseLower As B4XView
	Private tipBaseUpper As B4XView
	Private tipAnchorLower As B4XView
	Private tipAnchorUpper As B4XView
	Private mbTipAttachedLower As Boolean = False
	Private mbTipAttachedUpper As Boolean = False
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
''' Initializes the dual range component.
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

	' 3. Create progress overlay (connected span between lower and upper thumbs)
	Dim pProgress As Panel
	pProgress.Initialize("")
	pnlProgress = pProgress
	pnlProgress.Color = xui.Color_Transparent
	pnlSurface.AddView(pProgress, 0, 0, 1dip, 1dip)

	' 4. Create Lower thumb knob
	Dim pThumbL As Panel
	pThumbL.Initialize("")
	pnlThumbLower = pThumbL
	pnlThumbLower.Color = xui.Color_Transparent
	pnlSurface.AddView(pThumbL, 0, 0, 1dip, 1dip)

	' 5. Create Upper thumb knob
	Dim pThumbU As Panel
	pThumbU.Initialize("")
	pnlThumbUpper = pThumbU
	pnlThumbUpper.Color = xui.Color_Transparent
	pnlSurface.AddView(pThumbU, 0, 0, 1dip, 1dip)

	' 6. Create label-above chrome (lives in mBase, outside pnlSurface)
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

	' 7. Create hint/error text chrome below the slider
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

	' 8. Create right-aligned value readout chrome (top-right, shares the label row)
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

	' 9. Create tooltip anchors for both lower and upper thumbs
	Dim pAnchorL As Panel
	pAnchorL.Initialize("")
	tipAnchorLower = pAnchorL
	tipAnchorLower.Color = xui.Color_Transparent
	mBase.AddView(tipAnchorLower, 0, 0, 1dip, 1dip)

	Dim pAnchorU As Panel
	pAnchorU.Initialize("")
	tipAnchorUpper = pAnchorU
	tipAnchorUpper.Color = xui.Color_Transparent
	mBase.AddView(tipAnchorUpper, 0, 0, 1dip, 1dip)

	' 10. Initialize tooltips for both thumbs
	tipTooltipLower.Initialize(Me, "tipTooltipLower")
	Dim pTipL As Panel
	pTipL.Initialize("")
	tipBaseLower = pTipL
	tipBaseLower.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	tipTooltipLower.DesignerCreateView(tipBaseLower, Null, CreateMap("Position": "top", "Visible": False, "ShowArrow": True))

	tipTooltipUpper.Initialize(Me, "tipTooltipUpper")
	Dim pTipU As Panel
	pTipU.Initialize("")
	tipBaseUpper = pTipU
	tipBaseUpper.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	tipTooltipUpper.DesignerCreateView(tipBaseUpper, Null, CreateMap("Position": "top", "Visible": False, "ShowArrow": True))

	' 11. Initialize prepend/append SVG icons
	svgLeftIcon.Initialize(Me, "svgLeftIcon")
	svgRightIcon.Initialize(Me, "svgRightIcon")

	' 12. Initialize tooltip transient timers
	tooltipHideTimer.Initialize("tooltipHideTimer", 1200)
	tooltipHideTimer.Enabled = False
	tooltipFadeTimer.Initialize("tooltipFadeTimer", 16)
	tooltipFadeTimer.Enabled = False

	ApplyDesignerProps(mProps)
	#If B4A
		Dim jo As JavaObject = pnlSurface
		jo.RunMethod("setFocusable", Array(True))
	#End If
	mBase.Visible = mVisible
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	miMinValue = B4XDaisyVariants.GetPropInt(mProps, "MinValue", miMinValue)
	miMaxValue = B4XDaisyVariants.GetPropInt(mProps, "MaxValue", miMaxValue)
	miLowerValue = B4XDaisyVariants.GetPropInt(mProps, "LowerValue", miLowerValue)
	miUpperValue = B4XDaisyVariants.GetPropInt(mProps, "UpperValue", miUpperValue)
	miStepValue = B4XDaisyVariants.GetPropInt(mProps, "StepValue", miStepValue)
	miMinDistance = B4XDaisyVariants.GetPropInt(mProps, "MinDistance", miMinDistance)
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
	msValueSeparator = B4XDaisyVariants.GetPropString(mProps, "ValueSeparator", msValueSeparator)
	msIconLeft = B4XDaisyVariants.GetPropString(mProps, "IconLeft", msIconLeft)
	msIconRight = B4XDaisyVariants.GetPropString(mProps, "IconRight", msIconRight)
	miIconSizeProp = B4XDaisyVariants.GetPropInt(mProps, "IconSize", miIconSizeProp)
	mbShowTooltip = B4XDaisyVariants.GetPropBool(mProps, "ShowTooltip", mbShowTooltip)
	msTooltipPosition = B4XDaisyVariants.GetPropString(mProps, "TooltipPosition", msTooltipPosition)
	mbTooltipOpen = B4XDaisyVariants.GetPropBool(mProps, "TooltipOpen", mbTooltipOpen)

	ClampValues
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("MinValue", miMinValue)
	props.Put("MaxValue", miMaxValue)
	props.Put("LowerValue", miLowerValue)
	props.Put("UpperValue", miUpperValue)
	props.Put("StepValue", miStepValue)
	props.Put("MinDistance", miMinDistance)
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
	props.Put("ValueSeparator", msValueSeparator)
	props.Put("IconLeft", msIconLeft)
	props.Put("IconRight", msIconRight)
	props.Put("IconSize", miIconSizeProp)
	props.Put("ShowTooltip", mbShowTooltip)
	props.Put("TooltipPosition", msTooltipPosition)
	props.Put("TooltipOpen", mbTooltipOpen)
	Return props
End Sub

Private Sub ClampValues
	miLowerValue = Max(miMinValue, Min(miLowerValue, miMaxValue))
	miUpperValue = Max(miMinValue, Min(miUpperValue, miMaxValue))
	If miLowerValue > miUpperValue - miMinDistance Then
		miLowerValue = Max(miMinValue, miUpperValue - miMinDistance)
	End If
	If miUpperValue < miLowerValue + miMinDistance Then
		miUpperValue = Min(miMaxValue, miLowerValue + miMinDistance)
	End If
End Sub
#End Region

#Region Public API
''' <summary>
''' Sets the minimum value of the slider range.
''' </summary>
Public Sub setMinValue(iValue As Int)
	miMinValue = iValue
	ClampValues
	If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Gets the minimum value.
''' </summary>
Public Sub getMinValue As Int
	Return miMinValue
End Sub

''' <summary>
''' Sets the maximum value of the slider range.
''' </summary>
Public Sub setMaxValue(iValue As Int)
	miMaxValue = iValue
	ClampValues
	If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Gets the maximum value.
''' </summary>
Public Sub getMaxValue As Int
	Return miMaxValue
End Sub

''' <summary>
''' Sets the lower handle value.
''' </summary>
Public Sub setLowerValue(iValue As Int)
	miLowerValue = Max(miMinValue, Min(iValue, miUpperValue - miMinDistance))
	If mBase.IsInitialized = False Then Return
	Refresh
	If mbShowTooltip And mbTooltipOpen = False Then ShowTooltipTransient
End Sub

''' <summary>
''' Gets the lower handle value.
''' </summary>
Public Sub getLowerValue As Int
	Return miLowerValue
End Sub

''' <summary>
''' Alias for LowerValue.
''' </summary>
Public Sub setValue1(iValue As Int)
	setLowerValue(iValue)
End Sub

Public Sub getValue1 As Int
	Return miLowerValue
End Sub

''' <summary>
''' Sets the upper handle value.
''' </summary>
Public Sub setUpperValue(iValue As Int)
	miUpperValue = Max(miLowerValue + miMinDistance, Min(iValue, miMaxValue))
	If mBase.IsInitialized = False Then Return
	Refresh
	If mbShowTooltip And mbTooltipOpen = False Then ShowTooltipTransient
End Sub

''' <summary>
''' Gets the upper handle value.
''' </summary>
Public Sub getUpperValue As Int
	Return miUpperValue
End Sub

''' <summary>
''' Alias for UpperValue.
''' </summary>
Public Sub setValue2(iValue As Int)
	setUpperValue(iValue)
End Sub

Public Sub getValue2 As Int
	Return miUpperValue
End Sub

''' <summary>
''' Convenience method to set both lower and upper values simultaneously.
''' </summary>
Public Sub setValues(iLowerVal As Int, iUpperVal As Int)
	miLowerValue = iLowerVal
	miUpperValue = iUpperVal
	ClampValues
	If mBase.IsInitialized = False Then Return
	Refresh
	If mbShowTooltip And mbTooltipOpen = False Then ShowTooltipTransient
End Sub

''' <summary>
''' Gets both values as an Int array: Array As Int(LowerValue, UpperValue).
''' </summary>
Public Sub getValues As Int()
	Return Array As Int(miLowerValue, miUpperValue)
End Sub

''' <summary>
''' Backward-compatible single Value setter (maps to LowerValue).
''' </summary>
Public Sub setValue(iValue As Int)
	setLowerValue(iValue)
End Sub

Public Sub getValue As Int
	Return miLowerValue
End Sub

''' <summary>
''' Sets the step increment (0 for continuous).
''' </summary>
Public Sub setStepValue(iValue As Int)
	miStepValue = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getStepValue As Int
	Return miStepValue
End Sub

''' <summary>
''' Sets the minimum distance between lower and upper handles.
''' </summary>
Public Sub setMinDistance(iValue As Int)
	miMinDistance = Max(0, iValue)
	ClampValues
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getMinDistance As Int
	Return miMinDistance
End Sub

''' <summary>
''' Sets the Size (xs, sm, md, lg, xl).
''' </summary>
Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

''' <summary>
''' Sets the Variant (primary, secondary, accent, success, warning, error, info, neutral).
''' </summary>
Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

''' <summary>
''' Sets the Enabled state.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
	mEnabled = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

''' <summary>
''' Sets whether the connected span fill between thumbs is shown.
''' </summary>
Public Sub setShowFill(bValue As Boolean)
	mbShowFill = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowFill As Boolean
	Return mbShowFill
End Sub

''' <summary>
''' Sets the custom track background color.
''' </summary>
Public Sub setTrackColor(iValue As Int)
	mcTrackColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTrackColor As Int
	Return mcTrackColor
End Sub

''' <summary>
''' Sets the custom progress fill color.
''' </summary>
Public Sub setProgressColor(iValue As Int)
	mcProgressColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getProgressColor As Int
	Return mcProgressColor
End Sub

''' <summary>
''' Sets the custom thumb knob color.
''' </summary>
Public Sub setThumbColor(iValue As Int)
	mcThumbColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getThumbColor As Int
	Return mcThumbColor
End Sub

''' <summary>
''' Sets the label text displayed above the range slider.
''' </summary>
Public Sub setLabelAbove(sValue As String)
	If sValue = Null Then sValue = ""
	msLabelAbove = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelAbove As String
	Return msLabelAbove
End Sub

Public Sub setLabelVisible(bValue As Boolean)
	mbLabelVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelVisible As Boolean
	Return mbLabelVisible
End Sub

Public Sub setHintText(sValue As String)
	If sValue = Null Then sValue = ""
	msHintText = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHintText As String
	Return msHintText
End Sub

''' <summary>
''' Sets whether the live readout (e.g. "$20 - $80") is shown above the slider.
''' </summary>
Public Sub setShowValue(bValue As Boolean)
	mbShowValue = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowValue As Boolean
	Return mbShowValue
End Sub

Public Sub setValuePrefix(sValue As String)
	If sValue = Null Then sValue = ""
	msValuePrefix = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getValuePrefix As String
	Return msValuePrefix
End Sub

Public Sub setValueSuffix(sValue As String)
	If sValue = Null Then sValue = ""
	msValueSuffix = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getValueSuffix As String
	Return msValueSuffix
End Sub

Public Sub setValueSeparator(sValue As String)
	If sValue = Null Then sValue = " - "
	msValueSeparator = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getValueSeparator As String
	Return msValueSeparator
End Sub

Public Sub setIconLeft(sValue As String)
	If sValue = Null Then sValue = ""
	msIconLeft = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconLeft As String
	Return msIconLeft
End Sub

Public Sub setIconRight(sValue As String)
	If sValue = Null Then sValue = ""
	msIconRight = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconRight As String
	Return msIconRight
End Sub

Public Sub setIconSize(iValue As Int)
	miIconSizeProp = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconSize As Int
	Return miIconSizeProp
End Sub

Public Sub setShowTooltip(bValue As Boolean)
	mbShowTooltip = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowTooltip As Boolean
	Return mbShowTooltip
End Sub

Public Sub setTooltipPosition(sValue As String)
	msTooltipPosition = sValue.ToLowerCase
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTooltipPosition As String
	Return msTooltipPosition
End Sub

Public Sub setTooltipOpen(bValue As Boolean)
	mbTooltipOpen = bValue
	If mBase.IsInitialized = False Then Return
	If bValue = False Then
		If tooltipHideTimer.IsInitialized Then tooltipHideTimer.Enabled = False
		If tooltipFadeTimer.IsInitialized Then tooltipFadeTimer.Enabled = False
		If tipTooltipLower.IsInitialized Then tipTooltipLower.Hide
		If tipTooltipUpper.IsInitialized Then tipTooltipUpper.Hide
	Else
		Refresh
	End If
End Sub

Public Sub getTooltipOpen As Boolean
	Return mbTooltipOpen
End Sub

Public Sub setWidth(sValue As String)
	If mBase.IsInitialized Then
		mBase.Width = B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Width)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getWidth As String
	If mBase.IsInitialized Then Return mBase.Width & "dip"
	Return "0dip"
End Sub

Public Sub setHeight(sValue As String)
	If mBase.IsInitialized Then
		mBase.Height = B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Height)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getHeight As String
	If mBase.IsInitialized Then Return mBase.Height & "dip"
	Return "0dip"
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub getRole As String
	Return "dual-range"
End Sub

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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub getComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
End Sub

Public Sub RequestFocus
	If pnlSurface.IsInitialized Then pnlSurface.RequestFocus
End Sub

Public Sub setFocus(bValue As Boolean)
	If pnlSurface.IsInitialized = False Then Return
	#If B4A
		Dim jo As JavaObject = pnlSurface
		If bValue Then jo.RunMethod("requestFocus", Null) Else jo.RunMethod("clearFocus", Null)
	#End If
End Sub

Public Sub ReceiveFocus
	If msErrorText.Length > 0 And mbProgrammaticError = False Then
		msErrorText = ""
	End If
	If mBase.IsInitialized Then Refresh
End Sub

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
	
	' Value readout (e.g. "$20 - $80")
	Dim valueText As String = ""
	Dim valueW As Int = 0
	Dim measuredValueH As Int = 0
	If mbShowValue Then
		valueText = ResolveValueText
		valueW = B4XDaisyVariants.MeasureTextWidthSafe(valueText, aboveTextSize, Typeface.DEFAULT, 4dip)
		measuredValueH = B4XDaisyVariants.MeasureTextHeightSafe(valueText, aboveTextSize, Typeface.DEFAULT, Max(1dip, valueW), 4dip)
		labelAvailW = Max(1dip, w - valueW - 8dip - 4dip)
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

	' --- Resolve icon size ---
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

	' --- Touch surface occupies the slider band ---
	Dim surfaceW As Int = Max(1dip, w - leftMargin - rightMargin)
	pnlSurface.SetLayoutAnimated(0, leftMargin, surfaceY, surfaceW, surfaceH)

	Dim thumbSize As Float = ResolveThumbSizeDip
	Dim trackH As Float = thumbSize * 0.5
	Dim sliderW As Float = surfaceW - thumbSize
	If sliderW < 0 Then sliderW = 0

	' Calculate percentage for lower and upper handles
	Dim pctLower As Float = 0
	Dim pctUpper As Float = 1.0
	If miMaxValue > miMinValue Then
		pctLower = (miLowerValue - miMinValue) / (miMaxValue - miMinValue)
		pctUpper = (miUpperValue - miMinValue) / (miMaxValue - miMinValue)
	End If
	pctLower = Max(0, Min(pctLower, 1.0))
	pctUpper = Max(0, Min(pctUpper, 1.0))

	Dim lowerLeft As Float = pctLower * sliderW
	Dim upperLeft As Float = pctUpper * sliderW
	Dim trackTop As Float = (surfaceH - trackH) / 2
	Dim thumbTop As Float = (surfaceH - thumbSize) / 2

	If mRTL Then
		Dim tempLower As Float = sliderW - upperLeft
		Dim tempUpper As Float = sliderW - lowerLeft
		lowerLeft = tempLower
		upperLeft = tempUpper
	End If

	' Progress bar fills the connected span between lower and upper thumb
	Dim progressLeft As Float = lowerLeft
	Dim progressWidth As Float = Max(0, (upperLeft + thumbSize) - lowerLeft)

	pnlTrack.SetLayoutAnimated(0, 0, trackTop, surfaceW, trackH)
	If mbShowFill Then
		pnlProgress.Visible = True
		pnlProgress.SetLayoutAnimated(0, progressLeft, thumbTop, progressWidth, thumbSize)
	Else
		pnlProgress.Visible = False
	End If

	pnlThumbLower.SetLayoutAnimated(0, lowerLeft, thumbTop, thumbSize, thumbSize)
	pnlThumbUpper.SetLayoutAnimated(0, upperLeft, thumbTop, thumbSize, thumbSize)

	UpdateVisuals(trackH, thumbSize)

	' --- Tooltip anchors for both thumbs ---
	Dim anchorLowerX As Int = leftMargin + lowerLeft + thumbSize / 2
	Dim anchorUpperX As Int = leftMargin + upperLeft + thumbSize / 2
	Dim anchorY As Int = surfaceY + thumbTop
	Dim tipPos As String = msTooltipPosition.ToLowerCase.Trim
	Select Case tipPos
		Case "bottom"
			anchorY = surfaceY + thumbTop + thumbSize
		Case "left"
			anchorLowerX = leftMargin + lowerLeft
			anchorUpperX = leftMargin + upperLeft
		Case "right"
			anchorLowerX = leftMargin + lowerLeft + thumbSize
			anchorUpperX = leftMargin + upperLeft + thumbSize
	End Select

	tipAnchorLower.SetLayoutAnimated(0, anchorLowerX, anchorY, 1dip, 1dip)
	tipAnchorUpper.SetLayoutAnimated(0, anchorUpperX, anchorY, 1dip, 1dip)

	SyncTooltips

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

	Dim trackRadius As Float = fTrackH / 2
	Dim thumbRadius As Float = fThumbSize / 2
	Dim progressRadius As Float = thumbRadius

	ApplyPanelStyle(pnlTrack, trackBack, 0, 0, trackRadius)
	ApplyPanelStyle(pnlProgress, progressBack, 0, 0, progressRadius)

	Dim borderPx As Float = 4dip
	ApplyPanelStyle(pnlThumbLower, thumbBack, borderPx, thumbBorder, thumbRadius)
	ApplyPanelStyle(pnlThumbUpper, thumbBack, borderPx, thumbBorder, thumbRadius)

	Dim depth As Float = B4XDaisyVariants.GetTokenNumber("--depth", 0)
	#If B4A
	If depth > 0 Then
		B4XDaisyVariants.ApplyElevation(pnlThumbLower, "sm")
		B4XDaisyVariants.ApplyElevation(pnlThumbUpper, "sm")
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

	Dim trackBack As Int = B4XDaisyVariants.AlphaColor(progressBack, 0.1)

	If mcTrackColor <> 0 Then trackBack = mcTrackColor
	If mcProgressColor <> 0 Then
		progressBack = mcProgressColor
		thumbBorder = mcProgressColor
	End If
	If mcThumbColor <> 0 Then thumbBack = mcThumbColor

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
	If mEnabled = False Then Return B4XDaisyVariants.AlphaColor(c, 0.2)
	Return c
End Sub

Private Sub ResolveRequiredStarColor(iNormalColor As Int) As Int
	If mEnabled = False Then Return iNormalColor
	Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
End Sub

Private Sub ResolveValueText As String
	Return msValuePrefix & miLowerValue & msValueSuffix & msValueSeparator & msValuePrefix & miUpperValue & msValueSuffix
End Sub

Private Sub ResolveValueColor As Int
	Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	If mEnabled = False Then Return B4XDaisyVariants.AlphaColor(c, 0.2)
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
			If basePart.Length > 0 Then cs.Append(basePart)
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
Private Sub SyncTooltips
	If mBase.IsInitialized = False Then Return
	If tipTooltipLower.IsInitialized = False Or tipTooltipUpper.IsInitialized = False Then Return

	If mbShowTooltip = False Then
		tipTooltipLower.Hide
		tipTooltipUpper.Hide
		Return
	End If

	If mbTipAttachedLower = False Then
		tipTooltipLower.AttachTo(tipAnchorLower)
		mbTipAttachedLower = True
	Else
		tipTooltipLower.Refresh
	End If

	If mbTipAttachedUpper = False Then
		tipTooltipUpper.AttachTo(tipAnchorUpper)
		mbTipAttachedUpper = True
	Else
		tipTooltipUpper.Refresh
	End If

	Dim vKey As String = ""
	If mVariant <> Null Then vKey = mVariant.ToLowerCase.Trim
	If vKey <> mTipVariantApplied Then
		tipTooltipLower.setVariant(mVariant)
		tipTooltipUpper.setVariant(mVariant)
		mTipVariantApplied = vKey
	End If
	Dim pKey As String = msTooltipPosition.ToLowerCase.Trim
	If pKey <> mTipPositionApplied Then
		tipTooltipLower.setPosition(msTooltipPosition)
		tipTooltipUpper.setPosition(msTooltipPosition)
		mTipPositionApplied = pKey
	End If

	tipTooltipLower.setMessage(msValuePrefix & Round(miLowerValue) & msValueSuffix)
	tipTooltipUpper.setMessage(msValuePrefix & Round(miUpperValue) & msValueSuffix)

	If mbTooltipOpen Then
		tipTooltipLower.mBase.Alpha = 1
		tipTooltipLower.Show
		tipTooltipUpper.mBase.Alpha = 1
		tipTooltipUpper.Show
	End If
End Sub

Private Sub ShowTooltipTransient
	If mbShowTooltip = False Or tipTooltipLower.IsInitialized = False Then Return
	If mbTooltipOpen Then Return

	tooltipHideTimer.Enabled = False
	tooltipFadeTimer.Enabled = False
	mTooltipAutoHideAfterFadeIn = True

	If tipTooltipLower.getVisible And tipTooltipLower.mBase.Alpha >= 1 Then
		tooltipHideTimer.Enabled = True
		Return
	End If

	tipTooltipLower.mBase.Alpha = 0
	tipTooltipLower.Show
	tipTooltipUpper.mBase.Alpha = 0
	tipTooltipUpper.Show
	mTooltipFadingIn = True
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

Private Sub ShowTooltipFadeIn
	If mbShowTooltip = False Or tipTooltipLower.IsInitialized = False Then Return
	If mbTooltipOpen Then Return

	tooltipHideTimer.Enabled = False
	If tipTooltipLower.getVisible And tipTooltipLower.mBase.Alpha >= 1 Then
		tooltipFadeTimer.Enabled = False
		Return
	End If

	tooltipFadeTimer.Enabled = False
	mTooltipAutoHideAfterFadeIn = False
	tipTooltipLower.mBase.Alpha = 0
	tipTooltipLower.Show
	tipTooltipUpper.mBase.Alpha = 0
	tipTooltipUpper.Show
	mTooltipFadingIn = True
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

Private Sub ScheduleTooltipHide
	If mbShowTooltip = False Or tipTooltipLower.IsInitialized = False Then Return
	If mbTooltipOpen Then Return
	tooltipFadeTimer.Enabled = False
	tooltipHideTimer.Enabled = True
End Sub

Private Sub tooltipHideTimer_Tick
	tooltipHideTimer.Enabled = False
	If tipTooltipLower.IsInitialized = False Then Return
	mTooltipFadingIn = False
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

Private Sub tooltipFadeTimer_Tick
	If tipTooltipLower.IsInitialized = False Then
		tooltipFadeTimer.Enabled = False
		Return
	End If
	Dim elapsed As Long = DateTime.Now - mFadeStartTime
	If mTooltipFadingIn Then
		Dim progress As Float = Min(1.0, elapsed / 150)
		tipTooltipLower.mBase.Alpha = progress
		tipTooltipUpper.mBase.Alpha = progress
		If progress >= 1.0 Then
			tooltipFadeTimer.Enabled = False
			If mTooltipAutoHideAfterFadeIn Then
				tooltipHideTimer.Enabled = True
			End If
		End If
	Else
		Dim progress As Float = Min(1.0, elapsed / 250)
		tipTooltipLower.mBase.Alpha = 1.0 - progress
		tipTooltipUpper.mBase.Alpha = 1.0 - progress
		If progress >= 1.0 Then
			tooltipFadeTimer.Enabled = False
			tipTooltipLower.Hide
		tipTooltipUpper.Hide
		tipTooltipLower.mBase.Alpha = 1.0
		tipTooltipUpper.mBase.Alpha = 1.0
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
			If mbShowTooltip And mbTooltipOpen = False Then ShowTooltipFadeIn
			
			Dim thumbSize As Float = ResolveThumbSizeDip
			Dim lowerLeft As Float = CalculateThumbLeft(miLowerValue)
			Dim upperLeft As Float = CalculateThumbLeft(miUpperValue)
			
			Dim distLower As Float = Abs(fX - (lowerLeft + thumbSize / 2))
			Dim distUpper As Float = Abs(fX - (upperLeft + thumbSize / 2))

			If distLower < distUpper Then
				mActiveHandle = 1
			Else If distUpper < distLower Then
				mActiveHandle = 2
			Else
				' Equal distance (thumbs touching)
				If fX < lowerLeft + thumbSize / 2 Then
					mActiveHandle = 1
				Else
					mActiveHandle = 2
				End If
			End If

			Dim targetLeft As Float
			If mActiveHandle = 1 Then targetLeft = lowerLeft Else targetLeft = upperLeft

			If fX >= targetLeft - 12dip And fX <= targetLeft + thumbSize + 12dip Then
				mDragOffsetX = fX - targetLeft
			Else
				mDragOffsetX = thumbSize / 2
				UpdateActiveHandleFromX(fX - mDragOffsetX)
			End If

		Case mBase.TOUCH_ACTION_MOVE
			If mbDragging And mActiveHandle > 0 Then
				UpdateActiveHandleFromX(fX - mDragOffsetX)
			End If

		Case Else
			If mbDragging Then
				mbDragging = False
				mActiveHandle = 0
				If mbShowTooltip And mbTooltipOpen = False Then ScheduleTooltipHide
			End If
	End Select
End Sub

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

Private Sub UpdateActiveHandleFromX(fLeft As Float)
	Dim thumbSize As Float = ResolveThumbSizeDip
	Dim trackWidth As Float = pnlSurface.Width - thumbSize
	If trackWidth <= 0 Then Return

	Dim pct As Float = fLeft / trackWidth
	If mRTL Then pct = 1.0 - pct
	pct = Max(0, Min(pct, 1.0))
	
	Dim rawVal As Float = miMinValue + pct * (miMaxValue - miMinValue)
	Dim steppedVal As Int
	If miStepValue > 0 Then
		Dim steps As Int = Round((rawVal - miMinValue) / miStepValue)
		steppedVal = miMinValue + steps * miStepValue
	Else
		steppedVal = Round(rawVal)
	End If

	Dim changed As Boolean = False
	If mActiveHandle = 1 Then
		' Lower thumb
		Dim maxAllowed As Int = miUpperValue - miMinDistance
		Dim newVal As Int = Max(miMinValue, Min(steppedVal, maxAllowed))
		If newVal <> miLowerValue Then
			miLowerValue = newVal
			changed = True
		End If
	Else If mActiveHandle = 2 Then
		' Upper thumb
		Dim minAllowed As Int = miLowerValue + miMinDistance
		Dim newVal As Int = Max(minAllowed, Min(steppedVal, miMaxValue))
		If newVal <> miUpperValue Then
			miUpperValue = newVal
			changed = True
		End If
	End If

	If changed Then
		Refresh
		RaiseChanged(miLowerValue, miUpperValue)
	End If
End Sub

Private Sub RaiseChanged(iLowerVal As Int, iUpperVal As Int)
	If xui.SubExists(mCallBack, mEventName & "_Changed", 2) Then
		CallSub3(mCallBack, mEventName & "_Changed", iLowerVal, iUpperVal)
	Else If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", iLowerVal)
	End If
End Sub

' --- Prepend / Append icon tap handlers ---
Private Sub svgLeftIcon_Click (oTag As Object)
	If mEnabled = False Then Return
	Dim v As Int = Max(miMinValue, miLowerValue - miStepValue)
	setLowerValue(v)
	RaiseChanged(miLowerValue, miUpperValue)
End Sub

Private Sub svgRightIcon_Click (oTag As Object)
	If mEnabled = False Then Return
	Dim v As Int = Min(miMaxValue, miUpperValue + miStepValue)
	setUpperValue(v)
	RaiseChanged(miLowerValue, miUpperValue)
End Sub
#End Region

Private Sub pnlSurface_FocusChanged(bHasFocus As Boolean)
	If bHasFocus Then
		ReceiveFocus
	Else
		Blur
	End If
	If xui.SubExists(mCallBack, mEventName & "_FocusChanged", 1) Then
		CallSub2(mCallBack, mEventName & "_FocusChanged", bHasFocus)
	End If
End Sub

#Region Cleanup & Validation
Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	If mBase.IsInitialized Then Refresh
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

Public Sub ShowError(sErrorMessage As String)
	msErrorText = sErrorMessage
	mbProgrammaticError = True
	If mBase.IsInitialized Then Refresh
End Sub

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
	Else If miUpperValue > miLowerValue Then
		mbProgrammaticError = False
		msErrorText = ""
		ok = True
	Else
		mbValidationTouched = True
		If msErrorText.Length = 0 Then msErrorText = "Please select a valid range."
		ok = False
	End If
	If mBase.IsInitialized Then Refresh
	Return ok
End Sub

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
	tipTooltipLower = Null
	tipTooltipUpper = Null
	tipAnchorLower = Null
	tipAnchorUpper = Null
	tipBaseLower = Null
	tipBaseUpper = Null
End Sub
#End Region

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
