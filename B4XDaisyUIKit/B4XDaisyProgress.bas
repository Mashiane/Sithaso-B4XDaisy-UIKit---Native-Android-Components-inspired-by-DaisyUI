B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Changed (Value As Float)

#DesignerProperty: Key: Value, DisplayName: Value, FieldType: Int, DefaultValue: 0, Description: Current progress value.
#DesignerProperty: Key: MaxValue, DisplayName: Max Value, FieldType: Int, DefaultValue: 100, Description: Maximum progress bound.
#DesignerProperty: Key: Variant, DisplayName: Variant/Color, FieldType: String, DefaultValue: neutral, List: none|primary|secondary|accent|info|success|warning|error|neutral
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: Width, DisplayName: CSS Width, FieldType: String, DefaultValue: w-full
#DesignerProperty: Key: Height, DisplayName: CSS Height, FieldType: String, DefaultValue: h-2
#DesignerProperty: Key: ShowTooltip, DisplayName: Show Tooltip, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: TooltipPosition, DisplayName: Tooltip Position, FieldType: String, DefaultValue: top, List: top|bottom|left|right
#DesignerProperty: Key: Indeterminate, DisplayName: Indeterminate, FieldType: Boolean, DefaultValue: False, Description: Shows animated repeating-gradient progress (no value needed).
#DesignerProperty: Key: ShowNumberInline, DisplayName: Show Number Inline, FieldType: Boolean, DefaultValue: False, Description: Displays the percentage text between the reached and unreached areas (NumberProgressBar style).
#DesignerProperty: Key: NumberTextColor, DisplayName: Number Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override color for the inline number (0 = variant color).
#DesignerProperty: Key: Animated, DisplayName: Animated, FieldType: Boolean, DefaultValue: False, Description: Animate value changes.
#DesignerProperty: Key: Duration, DisplayName: Animation Duration, FieldType: Int, DefaultValue: 1000, Description: Animation duration in milliseconds.
#DesignerProperty: Key: IconLeft, DisplayName: Icon Left, FieldType: String, DefaultValue:, Description: Left-side SVG icon asset name.
#DesignerProperty: Key: IconRight, DisplayName: Icon Right, FieldType: String, DefaultValue:, Description: Right-side SVG icon asset name.
#DesignerProperty: Key: MinValue, DisplayName: Min Value, FieldType: Float, DefaultValue: 0, Description: Minimum progress value.
#DesignerProperty: Key: StepValue, DisplayName: Step Value, FieldType: Float, DefaultValue: 1, Description: Step increment/decrement amount.
#DesignerProperty: Key: IconSize, DisplayName: Icon Size, FieldType: Int, DefaultValue: 0, Description: Icon size in dip. 0 = auto-scale based on Size.
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: String, DefaultValue:, Description: Label text displayed above the progress bar.
#DesignerProperty: Key: LabelVisible, DisplayName: Label Visible, FieldType: Boolean, DefaultValue: False, Description: Whether the label above is visible.
#DesignerProperty: Key: TooltipOpen, DisplayName: Tooltip Open, FieldType: Boolean, DefaultValue: True, Description: When True, tooltip stays permanently visible. When False, tooltip shows briefly on value change then fades out.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private mEventName As String
	Private mCallBack As Object
	Public mBase As B4XView
	Private xui As XUI
	Private mTag As Object

	Private pnlTrack As B4XView
	Private pnlValue As B4XView

	Private mValue As Float = 0
	Private mMaxValue As Float = 100
	Private mVariant As String = "neutral"
	Private mSize As String = "none"

	Private mWidth As String = "w-full"
	Private mHeight As String = "h-2"
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mVisible As Boolean = True
	Private mShowTooltip As Boolean = False
	Private mTooltipPosition As String = "top"
	Private mbIndeterminate As Boolean = False
	Private tipTooltip As B4XDaisyTooltip
	Private tipBase As B4XView
	Private tipAnchor As B4XView
	
	' Animation state
	Private AnimationTimer As Timer
	Private indeterminateTimer As Timer
	Private TargetValue As Float
	Private StartValue As Float
	Private AnimStartTime As Long
	Private AnimDuration As Long
	
	' Inline number state
	Private mbShowNumberInline As Boolean = False
	Private mcNumberTextColor As Int = 0
	Private lblInlineNumber As B4XView
	Private mThickness As Float = 4dip
	Private mAnimationIndex As Int = 0
	Private Anim As B4XDaisyAnimation
	Private mbAnimated As Boolean = False
	Private miDuration As Int = 1000
	
	' Volume indicator state
	Private msIconLeft As String = ""
	Private msIconRight As String = ""
	Private mfMinValue As Float = 0
	Private mfStepValue As Float = 1
	Private miIconSizeProp As Int = 0
	Private miIconSize As Int = 24dip
	
	Private svgLeftIcon As B4XDaisySvgIcon
	Private svgRightIcon As B4XDaisySvgIcon
	
	' Label Above state
	Private msLabelAbove As String = ""
	Private mbLabelVisible As Boolean = False
	Private pnlLabelAbove As B4XView
	Private lblLabelAbove As B4XView
	
	' Tooltip transient state
	Private mbTooltipOpen As Boolean = True
	Private tooltipHideTimer As Timer
	Private tooltipFadeTimer As Timer
	Private mTooltipFadingIn As Boolean = True
	Private mFadeStartTime As Long
	Private mTooltipAutoHideAfterFadeIn As Boolean = True	' False during animation
	Private inResize As Boolean = False
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mEventName = sEventName
	mCallBack = oCallback
End Sub



Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	
	Dim pt As Panel
	pt.Initialize("pnlTrack")
	pnlTrack = pt
	pnlTrack.Color = xui.Color_Transparent
	mBase.AddView(pnlTrack, 0, 0, mBase.Width, mBase.Height)
	
	Dim pv As Panel
	pv.Initialize("")
	pnlValue = pv
	pnlValue.Color = xui.Color_Transparent
	mBase.AddView(pnlValue, 0, 0, mBase.Width, mBase.Height)

	' Initialize internal sub-components
	Dim pa As Panel
	pa.Initialize("")
	tipAnchor = pa
	tipAnchor.Color = xui.Color_Transparent
	mBase.AddView(tipAnchor, 0, 0, 1dip, 1dip)
	
	' Initialize inline label
	Dim l As Label
	l.Initialize("")
	lblInlineNumber = l
	mBase.AddView(lblInlineNumber, 0, 0, mBase.Width, mBase.Height)
	lblInlineNumber.SetTextAlignment("CENTER", "CENTER")
	#If B4A
	l.Typeface = Typeface.DEFAULT_BOLD
	l.SingleLine = True
	#End If
	
	' Initialize animation helper
	Anim.Initialize
	
	tipTooltip.Initialize(Me, "tipTooltip")
	Dim ptp As Panel
	ptp.Initialize("")
	tipBase = ptp
	tipBase.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	tipTooltip.DesignerCreateView(tipBase, Null, CreateMap("Position": "top", "Visible": False, "ShowArrow": True))

	' Initialize icons
	svgLeftIcon.Initialize(Me, "svgLeftIcon")
	svgRightIcon.Initialize(Me, "svgRightIcon")

	' Initialize Label Above sub-components
	Dim p As Panel
	p.Initialize("")
	pnlLabelAbove = p
	pnlLabelAbove.Color = xui.Color_Transparent
	mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)
	
	Dim la As Label
	la.Initialize("")
	lblLabelAbove = la
	lblLabelAbove.Color = xui.Color_Transparent
	lblLabelAbove.SetTextAlignment("CENTER", "LEFT")
	#If B4A
	la.SingleLine = True
	#End If
	pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

	' Initialize tooltip transient timers
	tooltipHideTimer.Initialize("tooltipHideTimer", 1500)
	tooltipHideTimer.Enabled = False
	tooltipFadeTimer.Initialize("tooltipFadeTimer", 16)
	tooltipFadeTimer.Enabled = False

	ApplyDesignerProps(mProps)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mValue = B4XDaisyVariants.GetPropFloat(mProps, "Value", mValue)
	mMaxValue = B4XDaisyVariants.GetPropFloat(mProps, "MaxValue", mMaxValue)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mSize = B4XDaisyVariants.GetPropString(mProps, "Size", mSize)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mWidth = B4XDaisyVariants.GetPropString(mProps, "Width", mWidth)
	mHeight = B4XDaisyVariants.GetPropString(mProps, "Height", mHeight)
	mShowTooltip = B4XDaisyVariants.GetPropBool(mProps, "ShowTooltip", mShowTooltip)
	mTooltipPosition = B4XDaisyVariants.GetPropString(mProps, "TooltipPosition", mTooltipPosition)
	mbIndeterminate = B4XDaisyVariants.GetPropBool(mProps, "Indeterminate", mbIndeterminate)
	mbShowNumberInline = B4XDaisyVariants.GetPropBool(mProps, "ShowNumberInline", mbShowNumberInline)
	mcNumberTextColor = B4XDaisyVariants.GetPropColor(mProps, "NumberTextColor", mcNumberTextColor)
	mbAnimated = B4XDaisyVariants.GetPropBool(mProps, "Animated", mbAnimated)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
	msIconLeft = B4XDaisyVariants.GetPropString(mProps, "IconLeft", msIconLeft)
	msIconRight = B4XDaisyVariants.GetPropString(mProps, "IconRight", msIconRight)
	mfMinValue = B4XDaisyVariants.GetPropFloat(mProps, "MinValue", mfMinValue)
	mfStepValue = B4XDaisyVariants.GetPropFloat(mProps, "StepValue", mfStepValue)
	miIconSizeProp = B4XDaisyVariants.GetPropInt(mProps, "IconSize", miIconSizeProp)
	msLabelAbove = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", msLabelAbove)
	mbLabelVisible = B4XDaisyVariants.GetPropBool(mProps, "LabelVisible", mbLabelVisible)
	mbTooltipOpen = B4XDaisyVariants.GetPropBool(mProps, "TooltipOpen", mbTooltipOpen)
	
	If mBase.IsInitialized Then
		mBase.Visible = mVisible
		If tipTooltip.IsInitialized Then tipTooltip.mBase.Visible = False ' Hide by default
		
		' Add icons to parent if properties are present
		If msIconLeft <> "" And svgLeftIcon.mBase.IsInitialized = False Then
			svgLeftIcon.AddToParent(mBase, 0, 0, 24dip, 24dip)
		End If
		If msIconRight <> "" And svgRightIcon.mBase.IsInitialized = False Then
			svgRightIcon.AddToParent(mBase, 0, 0, 24dip, 24dip)
		End If
		
		ApplyVisual
	End If
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Value", mValue)
	props.Put("MaxValue", mMaxValue)
	props.Put("Variant", mVariant)
	props.Put("Size", mSize)
	props.Put("Visible", mVisible)
	props.Put("ShowTooltip", mShowTooltip)
	props.Put("TooltipPosition", mTooltipPosition)
	props.Put("Indeterminate", mbIndeterminate)
	props.Put("ShowNumberInline", mbShowNumberInline)
	props.Put("NumberTextColor", mcNumberTextColor)
	props.Put("Animated", mbAnimated)
	props.Put("Duration", miDuration)
	props.Put("IconLeft", msIconLeft)
	props.Put("IconRight", msIconRight)
	props.Put("MinValue", mfMinValue)
	props.Put("StepValue", mfStepValue)
	props.Put("IconSize", miIconSizeProp)
	props.Put("LabelAbove", msLabelAbove)
	props.Put("LabelVisible", mbLabelVisible)
	props.Put("TooltipOpen", mbTooltipOpen)
	Return props
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

Private Sub ApplyVisual
	If mBase.IsInitialized = False Then Return
	
	' Calculate labelAboveH
	Dim labelAboveH As Int = 0
	If mbLabelVisible And msLabelAbove <> "" Then
		#If B4A
		Dim tf As Typeface = Typeface.DEFAULT
		#Else
		Dim tf As Object = Null
		#End If
		Dim labelAboveTextSize As Int = 14
		Select Case mSize
			Case "xs": labelAboveTextSize = 12
			Case "sm": labelAboveTextSize = 14
			Case "md", "none", "", "default": labelAboveTextSize = 16
			Case "lg": labelAboveTextSize = 20
			Case "xl": labelAboveTextSize = 24
		End Select
		Dim measuredLabelH As Int = B4XDaisyVariants.MeasureTextHeightSafe(msLabelAbove, labelAboveTextSize, tf, mBase.Width - 4dip, 4dip)
		labelAboveH = measuredLabelH + 4dip
	End If

	' Handle explicit Sizing matching range track scale
	Dim targetHeight As Int = mBase.Height
	If mbShowNumberInline Then
		Select Case mSize
			Case "xs": targetHeight = 24dip
			Case "sm": targetHeight = 26dip
			Case "md", "none", "", "default": targetHeight = 28dip
			Case "lg": targetHeight = 32dip
			Case "xl": targetHeight = 40dip
		End Select
	Else
		Select Case mSize
			Case "xs": targetHeight = 8dip
			Case "sm": targetHeight = 10dip
			Case "md", "none", "", "default": targetHeight = 12dip
			Case "lg": targetHeight = 16dip
			Case "xl": targetHeight = 20dip
		End Select
	End If
	
	If mSize <> "none" And mSize <> "" Then
		mBase.Height = labelAboveH + targetHeight
	End If
	
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	
	Dim fallbackContent As Int = tokens.GetDefault("--color-base-content", xui.Color_Black)
	Dim barColor As Int = fallbackContent
	
	Dim variantKey As String = B4XDaisyVariants.NormalizeVariant(mVariant)
	If variantKey <> "none" Then
		barColor = B4XDaisyVariants.ResolveVariantColor(palette, variantKey, "back", fallbackContent)
	End If
	
	' Track is 20% opacity of the bar color to match DaisyUI CSS `bg-current/20`
	Dim alpha20 As Int = Bit.And(barColor, 0x00FFFFFF)
	alpha20 = Bit.Or(alpha20, 0x33000000) ' 20% alpha (51)
	
	pnlTrack.Color = xui.Color_Transparent
	pnlValue.Color = xui.Color_Transparent
	
	' Dynamic pill rounding based on height
	Dim radius As Float = Max(1dip, mBase.Height / 2)
	pnlTrack.SetColorAndBorder(alpha20, 0, 0, radius)
	pnlValue.SetColorAndBorder(barColor, 0, 0, radius)
	
	If tipTooltip.IsInitialized Then
		tipTooltip.setVariant(mVariant)
		tipTooltip.setPosition(mTooltipPosition)
	End If
	
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub SetValueColor(iColor As Int)
	pnlValue.Color = iColor
End Sub

Public Sub SetTrackColor(iColor As Int)
	pnlTrack.Color = iColor
End Sub

Public Sub Base_Resize (dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	
	' Calculate labelAboveH
	Dim labelAboveH As Int = 0
	Dim measuredLabelH As Int = 0
	If mbLabelVisible And msLabelAbove <> "" Then
		#If B4A
		Dim tf As Typeface = Typeface.DEFAULT
		#Else
		Dim tf As Object = Null
		#End If
		Dim labelAboveTextSize As Int = 14
		Select Case mSize
			Case "xs": labelAboveTextSize = 12
			Case "sm": labelAboveTextSize = 14
			Case "md", "none", "", "default": labelAboveTextSize = 16
			Case "lg": labelAboveTextSize = 20
			Case "xl": labelAboveTextSize = 24
		End Select
		measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(msLabelAbove, labelAboveTextSize, tf, w - 4dip, 4dip)
		labelAboveH = measuredLabelH + 4dip
	End If

	' Handle Label Above visibility and layout
	If labelAboveH > 0 Then
		pnlLabelAbove.Visible = True
		pnlLabelAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
		lblLabelAbove.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, measuredLabelH)
		lblLabelAbove.Text = msLabelAbove
		
		' Set text size based on component size
		Dim labelAboveTextSize As Int = 14
		Select Case mSize
			Case "xs": labelAboveTextSize = 12
			Case "sm": labelAboveTextSize = 14
			Case "md", "none", "", "default": labelAboveTextSize = 16
			Case "lg": labelAboveTextSize = 20
			Case "xl": labelAboveTextSize = 24
		End Select
		lblLabelAbove.TextSize = labelAboveTextSize
		
		' Match text color to label style
		Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
		Dim labelAboveColor As Int = tokens.GetDefault("--color-base-content", xui.Color_Black)
		lblLabelAbove.TextColor = labelAboveColor
	Else
		If pnlLabelAbove.IsInitialized Then pnlLabelAbove.Visible = False
	End If
	
	Dim progressH As Int = h - labelAboveH

	' Resolve icon size
	If miIconSizeProp > 0 Then
		miIconSize = miIconSizeProp * 1dip
	Else
		Select Case mSize
			Case "xs": miIconSize = 16dip
			Case "sm": miIconSize = 18dip
			Case "md", "none", "", "default": miIconSize = 24dip
			Case "lg": miIconSize = 32dip
			Case "xl": miIconSize = 40dip
		End Select
	End If

	Dim leftMargin As Int = 0
	Dim rightMargin As Int = 0
	
	' Handle left icon visibility and layout
	If msIconLeft <> "" Then
		If svgLeftIcon.mBase.IsInitialized = False Then
			svgLeftIcon.AddToParent(mBase, 0, 0, miIconSize, miIconSize)
		End If
		svgLeftIcon.mBase.Visible = True
		svgLeftIcon.mBase.SetLayoutAnimated(0, 0, labelAboveH + (progressH - miIconSize) / 2, miIconSize, miIconSize)
		svgLeftIcon.SvgAsset = msIconLeft
		
		' Apply variant color to icon
		Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
		Dim fallbackContent As Int = tokens.GetDefault("--color-base-content", xui.Color_Black)
		Dim iconCol As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, fallbackContent)
		svgLeftIcon.Color = iconCol
		
		leftMargin = miIconSize + 8dip
	Else
		If svgLeftIcon.mBase.IsInitialized Then svgLeftIcon.mBase.Visible = False
	End If
	
	' Handle right icon visibility and layout
	If msIconRight <> "" Then
		If svgRightIcon.mBase.IsInitialized = False Then
			svgRightIcon.AddToParent(mBase, 0, 0, miIconSize, miIconSize)
		End If
		svgRightIcon.mBase.Visible = True
		svgRightIcon.mBase.SetLayoutAnimated(0, w - miIconSize, labelAboveH + (progressH - miIconSize) / 2, miIconSize, miIconSize)
		svgRightIcon.SvgAsset = msIconRight
		
		' Apply variant color to icon
		Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
		Dim fallbackContent As Int = tokens.GetDefault("--color-base-content", xui.Color_Black)
		Dim iconCol As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, fallbackContent)
		svgRightIcon.Color = iconCol
		
		rightMargin = miIconSize + 8dip
	Else
		If svgRightIcon.mBase.IsInitialized Then svgRightIcon.mBase.Visible = False
	End If
	
	If mbShowNumberInline And mbIndeterminate = False Then
		lblInlineNumber.Visible = True
		
		Select Case mSize
			Case "xs"
				mThickness = 8dip
				lblInlineNumber.TextSize = 12
			Case "sm"
				mThickness = 10dip
				lblInlineNumber.TextSize = 14
			Case "md", "none", ""
				mThickness = 12dip
				lblInlineNumber.TextSize = 16
			Case "lg"
				mThickness = 16dip
				lblInlineNumber.TextSize = 20
			Case "xl"
				mThickness = 20dip
				lblInlineNumber.TextSize = 24
		End Select
		
		Dim range As Float = Max(0.0001, mMaxValue - mfMinValue)
		Dim pct As Float = (mValue - mfMinValue) / range
		If IsNumber(pct) = False Then pct = 0
		pct = Max(0, Min(1, pct))
		
		lblInlineNumber.Text = Round(pct * 100) & "%"
		
		' Resolve text color
		Dim textCol As Int = mcNumberTextColor
		If textCol = 0 Then
			Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
			Dim fallbackContent As Int = tokens.GetDefault("--color-base-content", xui.Color_Black)
			textCol = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, fallbackContent)
		End If
		lblInlineNumber.TextColor = textCol
		
		#If B4A
		Dim tf As Typeface = Typeface.DEFAULT_BOLD
		#Else
		Dim tf As Object = Null
		#End If
		
		Dim measuredW As Int = B4XDaisyVariants.MeasureTextWidthSafe(lblInlineNumber.Text, lblInlineNumber.TextSize, tf, 0)
		Dim TextWidth As Int = measuredW + 16dip
		Dim TotalTrackWidth As Int = Max(0, w - leftMargin - rightMargin - TextWidth)
		Dim ReachedWidth As Int = Round(TotalTrackWidth * pct)
		Dim UnreachedWidth As Int = TotalTrackWidth - ReachedWidth
		
		lblInlineNumber.SetLayoutAnimated(0, leftMargin + ReachedWidth, labelAboveH, TextWidth, progressH)
		
		Dim yPos As Int = labelAboveH + (progressH - mThickness) / 2
		pnlValue.SetLayoutAnimated(0, leftMargin, yPos, ReachedWidth, mThickness)
		pnlTrack.SetLayoutAnimated(0, leftMargin + ReachedWidth + TextWidth, yPos, UnreachedWidth, mThickness)
		
		tipAnchor.SetLayoutAnimated(0, leftMargin + ReachedWidth, yPos, 1dip, mThickness)
		
		' Ensure rounding stays perfectly pill-shaped for inline height
		Dim radius As Float = Max(1dip, mThickness / 2)
		pnlTrack.SetColorAndBorder(pnlTrack.Color, 0, 0, radius)
		pnlValue.SetColorAndBorder(pnlValue.Color, 0, 0, radius)
	Else
		lblInlineNumber.Visible = False
		
		Dim TotalTrackWidth As Int = w - leftMargin - rightMargin
		pnlTrack.SetLayoutAnimated(0, leftMargin, labelAboveH, TotalTrackWidth, progressH)
		
		' DaisyUI CSS uses simple width scaling for the value bar.
		Dim range As Float = Max(0.0001, mMaxValue - mfMinValue)
		Dim pct As Float = (mValue - mfMinValue) / range
		' Safety check for NaN or Infinity
		If IsNumber(pct) = False Then pct = 0
		pct = Max(0, Min(1, pct))

		' In indeterminate mode, skip value-based width - timer handles animation.
		Dim barW As Int
		If mbIndeterminate = False Then
			' Make sure the progress value doesn't look cut off unrounded at the end if it's very small.
			barW = Round(TotalTrackWidth * pct)
			' Enforce minimum width to respect the radius correctly if > 0
			If pct > 0 And barW < progressH Then barW = progressH
			If pct = 0 Then barW = 0
			pnlValue.SetLayoutAnimated(0, leftMargin, labelAboveH, Max(0, barW), progressH)
		Else
			barW = Round(TotalTrackWidth * 0.3)
			StartIndeterminateAnimation
		End If
		tipAnchor.SetLayoutAnimated(0, leftMargin + Max(0, barW), labelAboveH, 1dip, progressH)
		
		' Ensure rounding stays perfectly pill-shaped if resized dynamically
		Dim radius As Float = Max(1dip, progressH / 2)
		pnlTrack.SetColorAndBorder(pnlTrack.Color, 0, 0, radius)
		pnlValue.SetColorAndBorder(pnlValue.Color, 0, 0, radius)
	End If
	
	' Sync tooltip if needed
	If mShowTooltip And tipTooltip.IsInitialized Then
		tipTooltip.AttachTo(tipAnchor)
		
		Dim msg As String
		If mMaxValue > 100 Then
			msg = NumberFormat(mValue / 1000, 1, 1) & "s"
		Else
			msg = Round(mValue) & "%"
		End If
		
		tipTooltip.setMessage(msg)
		tipTooltip.setVariant(mVariant)
		tipTooltip.setPosition(mTooltipPosition)
		
		If mbTooltipOpen Then
			' Permanent mode - always visible (original behaviour)
			tipTooltip.mBase.Alpha = 1
			tipTooltip.Show
		End If
		' Transient mode (TooltipOpen=False): shown via ShowTooltipTransient on value change
	Else If tipTooltip.IsInitialized Then
		tipTooltip.Hide
	End If
	inResize = False
End Sub

Public Sub setVariant(sVariantName As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sVariantName)
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setValue(fValue As Float)
	Dim boundedValue As Float = Min(mMaxValue, Max(mfMinValue, fValue))
	If mbAnimated Then
		SetValueAnimated(boundedValue, miDuration)
	Else
		mValue = boundedValue
		If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
		If mbTooltipOpen = False Then ShowTooltipTransient
	End If
End Sub

Public Sub getValue As Float
	Return mValue
End Sub

Private Sub SetValueAnimated(fValue As Float, iDuration As Int)
	Dim boundedValue As Float = Min(mMaxValue, Max(mfMinValue, fValue))
	mAnimationIndex = mAnimationIndex + 1
	Dim myIndex As Int = mAnimationIndex
	
	TargetValue = boundedValue
	StartValue = mValue
	AnimDuration = iDuration
	AnimStartTime = DateTime.Now
	
	If mBase.IsInitialized = False Then 
		mValue = boundedValue
		Return
	End If
	
	If AnimationTimer.IsInitialized Then AnimationTimer.Enabled = False
	
	If iDuration > 0 Then
		Dim elapsed As Long = 0
		Do While elapsed < iDuration
			If myIndex <> mAnimationIndex Then Return
			elapsed = DateTime.Now - AnimStartTime
			If elapsed >= iDuration Then Exit
			
			Dim currentValue As Float = Anim.easeOutCubic(elapsed, StartValue, TargetValue - StartValue, iDuration)
			mValue = currentValue
			
			If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
			
			Sleep(0)
		Loop
	End If

	' Tooltip: show before yielding control back for the final frame check
	If mbTooltipOpen = False And myIndex = mAnimationIndex Then ShowTooltipFadeIn
	
	If myIndex = mAnimationIndex Then
		mValue = boundedValue
		If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
		If mbTooltipOpen = False And mShowTooltip And tipTooltip.IsInitialized Then
			' Animation complete - stop any fade-in still running and schedule hide
			tooltipFadeTimer.Enabled = False
			tipTooltip.mBase.Alpha = 1
			tooltipHideTimer.Enabled = True
		End If
	End If
End Sub

Public Sub StartTimer(iDurationMs As Int)
	setMaxValue(iDurationMs)
	mValue = iDurationMs
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
	SetValueAnimated(0, iDurationMs)
End Sub

Public Sub setMaxValue(fMaxValue As Float)
	mMaxValue = fMaxValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMaxValue As Float
	Return mMaxValue
End Sub

Public Sub setSize(sSize As String)
	mSize = sSize
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setShowTooltip(bValue As Boolean)
	mShowTooltip = bValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getShowTooltip As Boolean
	Return mShowTooltip
End Sub

Public Sub setTooltipPosition(sValue As String)
	mTooltipPosition = sValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getTooltipPosition As String
	Return mTooltipPosition
End Sub

Public Sub setIndeterminate(bValue As Boolean)
	mbIndeterminate = bValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getIndeterminate As Boolean
	Return mbIndeterminate
End Sub

Public Sub setShowNumberInline(bValue As Boolean)
	mbShowNumberInline = bValue
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getShowNumberInline As Boolean
	Return mbShowNumberInline
End Sub

Public Sub setNumberTextColor(iC As Int)
	mcNumberTextColor = iC
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getNumberTextColor As Int
	Return mcNumberTextColor
End Sub

Public Sub setAnimated(bValue As Boolean)
	mbAnimated = bValue
End Sub

Public Sub getAnimated As Boolean
	Return mbAnimated
End Sub

Public Sub setDuration(iValue As Int)
	miDuration = iValue
End Sub

Public Sub getDuration As Int
	Return miDuration
End Sub

Private Sub StartIndeterminateAnimation
	StopIndeterminateAnimation
	indeterminateTimer.Initialize("indeterminateTimer", 16)
End Sub

Private Sub StopIndeterminateAnimation
	If indeterminateTimer.IsInitialized Then indeterminateTimer.Enabled = False
End Sub

Private Sub indeterminateTimer_Tick
	If pnlValue.IsInitialized = False Then Return
	Dim maxW As Int = pnlTrack.Width
	Dim barW As Int = Max(20dip, Round(maxW * 0.3))
	Dim indPos As Float = (DateTime.Now Mod 2000) / 2000.0
	Dim xPos As Int = Round(indPos * (maxW + barW) - barW / 2)
	Dim leftOffset As Int = pnlTrack.Left
	Dim topOffset As Int = pnlTrack.Top
	pnlValue.SetLayoutAnimated(0, leftOffset + xPos, topOffset, barW, pnlValue.Height)
End Sub

Public Sub setTag(oTag As Object)
	mTag = oTag
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setLabelAbove(sValue As String)
	msLabelAbove = sValue
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getLabelAbove As String
	Return msLabelAbove
End Sub

Public Sub setLabelVisible(bValue As Boolean)
	mbLabelVisible = bValue
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getLabelVisible As Boolean
	Return mbLabelVisible
End Sub

Public Sub setIconLeft(sValue As String)
	msIconLeft = sValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getIconLeft As String
	Return msIconLeft
End Sub

Public Sub setIconRight(sValue As String)
	msIconRight = sValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getIconRight As String
	Return msIconRight
End Sub

Public Sub setMinValue(fV As Float)
	mfMinValue = fV
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMinValue As Float
	Return mfMinValue
End Sub

Public Sub setStepValue(fV As Float)
	mfStepValue = fV
End Sub

Public Sub getStepValue As Float
	Return mfStepValue
End Sub

Public Sub setIconSize(iV As Int)
	miIconSizeProp = iV
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getIconSize As Int
	Return miIconSizeProp
End Sub

Private Sub svgLeftIcon_Click (oTag As Object)
	Dim newVal As Float = Max(mfMinValue, mValue - mfStepValue)
	setValue(newVal)
	RaiseChanged
End Sub

Private Sub svgRightIcon_Click (oTag As Object)
	Dim newVal As Float = Min(mMaxValue, mValue + mfStepValue)
	setValue(newVal)
	RaiseChanged
End Sub

' Internal tap: show tooltip transiently when ShowTooltip=True and TooltipOpen=False
Private Sub pnlTrack_Click
	If mShowTooltip And mbTooltipOpen = False Then
		ShowTooltipTransient
	End If
End Sub

Private Sub RaiseChanged
	If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", mValue)
	Else If xui.SubExists(mCallBack, mEventName & "_Changed", 0) Then
		CallSub(mCallBack, mEventName & "_Changed")
	End If
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

' -------------------------------------------------------------
' B4A Raw Label Drop-In Equivalency Methods
' -------------------------------------------------------------

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

Public Sub SetLayoutAnimated(iDuration As Int, iLeftPos As Int, iTopPos As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeftPos, iTopPos, Max(1dip, iWidth), Max(1dip, iHeight))
	If iWidth > 0 And iHeight > 0 Then Base_Resize(iWidth, iHeight)
End Sub

Public Sub StopAnimation
	mAnimationIndex = mAnimationIndex + 1
	If AnimationTimer.IsInitialized Then
		AnimationTimer.Enabled = False
	End If
	If tooltipHideTimer.IsInitialized Then tooltipHideTimer.Enabled = False
	If tooltipFadeTimer.IsInitialized Then tooltipFadeTimer.Enabled = False
End Sub

' -- Transient Tooltip (TooltipOpen = False) ---------------------------------

' Show the tooltip with a fade-in, then auto-hide with a fade-out after a delay
' Show tooltip with fade-in, then auto-hide after hold (instant/non-animated path)
Private Sub ShowTooltipTransient
	If mShowTooltip = False Or tipTooltip.IsInitialized = False Then Return
	If mbTooltipOpen Then Return	' permanent mode - handled in Base_Resize

	' Cancel any pending hide or fade
	tooltipHideTimer.Enabled = False
	tooltipFadeTimer.Enabled = False

	' Auto-hide after fade-in completes
	mTooltipAutoHideAfterFadeIn = True

	' If already fully visible, just restart the hold timer
	If tipTooltip.getVisible And tipTooltip.mBase.Alpha >= 1 Then
		tooltipHideTimer.Enabled = True
		Return
	End If

	' Start fade-in: alpha 0 -> 1 over 150 ms
	tipTooltip.mBase.Alpha = 0
	tipTooltip.Show
	mTooltipFadingIn = True
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

' Show tooltip with fade-in only - no auto-hide (used at animation start)
Private Sub ShowTooltipFadeIn
	If mShowTooltip = False Or tipTooltip.IsInitialized = False Then Return
	If mbTooltipOpen Then Return

	' Cancel any pending hide - we want to stay visible during animation
	tooltipHideTimer.Enabled = False

	' If tooltip is already fully visible, just cancel the hide and stay visible
	If tipTooltip.getVisible And tipTooltip.mBase.Alpha >= 1 Then
		tooltipFadeTimer.Enabled = False
		Return
	End If

	' Not yet visible or still fading - start fade-in without auto-hide
	tooltipFadeTimer.Enabled = False
	mTooltipAutoHideAfterFadeIn = False	' animation will schedule the hide
	tipTooltip.mBase.Alpha = 0
	tipTooltip.Show
	mTooltipFadingIn = True
	mFadeStartTime = DateTime.Now
	tooltipFadeTimer.Enabled = True
End Sub

Private Sub tooltipHideTimer_Tick
	tooltipHideTimer.Enabled = False
	If tipTooltip.IsInitialized = False Then Return
	' Start fade-out: alpha 1 -> 0 over 250 ms
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
		' Fade in over 150 ms
		Dim progress As Float = Min(1.0, elapsed / 150)
		tipTooltip.mBase.Alpha = progress
		If progress >= 1.0 Then
			tooltipFadeTimer.Enabled = False
			If mTooltipAutoHideAfterFadeIn Then
				' Schedule auto-hide after 1500 ms
				tooltipHideTimer.Enabled = True
			End If
			' If mTooltipAutoHideAfterFadeIn=False, animation will schedule the hide
		End If
	Else
		' Fade out over 250 ms
		Dim progress As Float = Min(1.0, elapsed / 250)
		tipTooltip.mBase.Alpha = 1.0 - progress
		If progress >= 1.0 Then
			tooltipFadeTimer.Enabled = False
			tipTooltip.Hide
			tipTooltip.mBase.Alpha = 1.0	' Reset alpha for next transient show
		End If
	End If
End Sub

' -- TooltipOpen property -----------------------------------------------------

Public Sub setTooltipOpen(bValue As Boolean)
	mbTooltipOpen = bValue
	If mBase.IsInitialized = False Then Return
	If bValue = False Then
		' Transient mode: hide immediately if currently shown by permanent mode
		If tooltipHideTimer.IsInitialized Then tooltipHideTimer.Enabled = False
		If tooltipFadeTimer.IsInitialized Then tooltipFadeTimer.Enabled = False
		If tipTooltip.IsInitialized Then tipTooltip.Hide
	Else
		' Permanent mode: show immediately if ShowTooltip is on
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getTooltipOpen As Boolean
	Return mbTooltipOpen
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub


Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
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

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region
