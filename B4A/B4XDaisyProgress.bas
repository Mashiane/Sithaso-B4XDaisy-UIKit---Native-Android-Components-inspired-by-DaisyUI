B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Value, DisplayName: Value, FieldType: Int, DefaultValue: 0, Description: Current progress value.
#DesignerProperty: Key: MaxValue, DisplayName: Max Value, FieldType: Int, DefaultValue: 100, Description: Maximum progress bound.
#DesignerProperty: Key: Variant, DisplayName: Variant/Color, FieldType: String, DefaultValue: none, List: none|primary|secondary|accent|info|success|warning|error|neutral
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: Width, DisplayName: CSS Width, FieldType: String, DefaultValue: w-full
#DesignerProperty: Key: Height, DisplayName: CSS Height, FieldType: String, DefaultValue: h-2
#DesignerProperty: Key: ShowTooltip, DisplayName: Show Tooltip, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: TooltipPosition, DisplayName: Tooltip Position, FieldType: String, DefaultValue: top, List: top|bottom|left|right

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
	Private mVariant As String = "none"
	Private mSize As String = "none"

	Private mWidth As String = "w-full"
	Private mHeight As String = "h-2"
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mVisible As Boolean = True
	Private mShowTooltip As Boolean = False
	Private mTooltipPosition As String = "top"
	Private tipTooltip As B4XDaisyTooltip
	Private tipBase As B4XView
	Private tipAnchor As B4XView
	
	' Animation state
	Private AnimationTimer As Timer
	Private TargetValue As Float
	Private StartValue As Float
	Private AnimStartTime As Long
	Private AnimDuration As Long
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub



Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	
	Dim pt As Panel
	pt.Initialize("")
	pnlTrack = pt
	pnlTrack.Color = xui.Color_Transparent
	mBase.AddView(pnlTrack, 0, 0, mBase.Width, mBase.Height)
	
	Dim pv As Panel
	pv.Initialize("")
	pnlValue = pv
	pnlValue.Color = xui.Color_Transparent
	pnlTrack.AddView(pnlValue, 0, 0, mBase.Width, mBase.Height)

	' Initialize internal sub-components
	Dim pa As Panel
	pa.Initialize("")
	tipAnchor = pa
	tipAnchor.Color = xui.Color_Transparent
	pnlTrack.AddView(tipAnchor, 0, 0, 1dip, 1dip)
	
	tipTooltip.Initialize(Me, "tipTooltip")
	Dim ptp As Panel
	ptp.Initialize("")
	tipBase = ptp
	tipBase.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	tipTooltip.DesignerCreateView(tipBase, Null, CreateMap("Position": "top", "Visible": False, "ShowArrow": True))

	ApplyDesignerProps(Props)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mValue = B4XDaisyVariants.GetPropFloat(Props, "Value", mValue)
	mMaxValue = B4XDaisyVariants.GetPropFloat(Props, "MaxValue", mMaxValue)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", mVariant))
	mSize = B4XDaisyVariants.GetPropString(Props, "Size", mSize)
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
	mWidth = B4XDaisyVariants.GetPropString(Props, "Width", mWidth)
	mHeight = B4XDaisyVariants.GetPropString(Props, "Height", mHeight)
	mShowTooltip = B4XDaisyVariants.GetPropBool(Props, "ShowTooltip", mShowTooltip)
	mTooltipPosition = B4XDaisyVariants.GetPropString(Props, "TooltipPosition", mTooltipPosition)
	
	If mBase.IsInitialized Then
		mBase.Visible = mVisible
		If tipTooltip.IsInitialized Then tipTooltip.mBase.Visible = False ' Hide by default
		ApplyVisual
	End If
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(Width))
	props.Put("Height", ResolvePxSizeSpec(Height))
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Private Sub ApplyVisual
	If mBase.IsInitialized = False Then Return
	
	' Handle explicit Sizing matching range track scale
	Dim targetHeight As Int = mBase.Height
	Select Case mSize
		Case "xs": targetHeight = 8dip
		Case "sm": targetHeight = 10dip
		Case "md": targetHeight = 12dip
		Case "lg": targetHeight = 16dip
		Case "xl": targetHeight = 20dip
	End Select
	If mSize <> "none" And mSize <> "" Then
		mBase.Height = targetHeight
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

Public Sub SetValueColor(Color As Int)
	pnlValue.Color = Color
End Sub

Public Sub SetTrackColor(Color As Int)
	pnlTrack.Color = Color
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	pnlTrack.SetLayoutAnimated(0, 0, 0, w, h)
	
	' DaisyUI CSS uses simple width scaling for the value bar.
	Dim range As Float = Max(0.0001, mMaxValue)
	Dim pct As Float = Max(0, Min(1, mValue / range))
	
	' Make sure the progress value doesn't look cut off unrounded at the end if it's very small.
	Dim barW As Int = Round(w * pct)
	' Enforce minimum width to respect the radius correctly if > 0
	If pct > 0 And barW < h Then barW = h
	If pct = 0 Then barW = 0
	
	pnlValue.SetLayoutAnimated(0, 0, 0, barW, h)
	tipAnchor.SetLayoutAnimated(0, barW, 0, 1dip, h)
	
	' Sync tooltip if needed
	If mShowTooltip And tipTooltip.IsInitialized Then
		tipTooltip.AttachToTarget(tipAnchor)
		
		Dim msg As String
		If mMaxValue > 100 Then
			msg = NumberFormat(mValue / 1000, 1, 1) & "s"
		Else
			msg = Round(mValue) & "%"
		End If
		
		tipTooltip.setMessage(msg)
		tipTooltip.setVariant(mVariant)
		tipTooltip.setPosition(mTooltipPosition)
		tipTooltip.Show
	Else If tipTooltip.IsInitialized Then
		tipTooltip.Hide
	End If
	
	' Ensure rounding stays perfectly pill-shaped if resized dynamically
	Dim radius As Float = Max(1dip, h / 2)
	pnlTrack.SetColorAndBorder(pnlTrack.Color, 0, 0, radius)
	pnlValue.SetColorAndBorder(pnlValue.Color, 0, 0, radius)
End Sub

Public Sub setVariant(VariantName As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(VariantName)
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setValue(Value As Float)
	mValue = Value
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getValue As Float
	Return mValue
End Sub

Public Sub SetValueAnimated(Value As Float, Duration As Int)
	TargetValue = Value
	StartValue = mValue
	AnimDuration = Duration
	AnimStartTime = DateTime.Now
	
	If mBase.IsInitialized = False Then 
		mValue = Value
		Return
	End If
	
	If Duration > 0 Then
		If AnimationTimer.IsInitialized = False Then AnimationTimer.Initialize("AnimationTimer", 16)
		AnimationTimer.Enabled = True
	Else
		mValue = Value
		If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub StartTimer(DurationMs As Int)
	setMaxValue(DurationMs)
	mValue = DurationMs
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
	SetValueAnimated(0, DurationMs)
End Sub

Private Sub AnimationTimer_Tick
	Dim elapsed As Long = DateTime.Now - AnimStartTime
	If elapsed >= AnimDuration Then
		AnimationTimer.Enabled = False
		mValue = TargetValue
	Else
		Dim progress As Float = elapsed / (AnimDuration * 1.0)
		mValue = StartValue + (TargetValue - StartValue) * progress
	End If
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setMaxValue(MaxValue As Float)
	mMaxValue = MaxValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMaxValue As Float
	Return mMaxValue
End Sub

Public Sub setSize(Size As String)
	mSize = Size
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setShowTooltip(b As Boolean)
	mShowTooltip = b
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getShowTooltip As Boolean
	Return mShowTooltip
End Sub

Public Sub setTooltipPosition(s As String)
	mTooltipPosition = s
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getTooltipPosition As String
	Return mTooltipPosition
End Sub

Public Sub setTag(Tag As Object)
	mTag = Tag
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(w))
	props.Put("Height", ResolvePxSizeSpec(h))
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Parent.AddView(mBase, Left, Top, w, h)
	Return mBase
End Sub

' -------------------------------------------------------------
' B4A Raw Label Drop-In Equivalency Methods
' -------------------------------------------------------------

Public Sub setLeft(Value As Int)
	If mBase.IsInitialized Then mBase.Left = Value
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub setTop(Value As Int)
	If mBase.IsInitialized Then mBase.Top = Value
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized Then Return mBase.Top
	Return 0
End Sub

Public Sub SetLayoutAnimated(Duration As Int, LeftPos As Int, TopPos As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(Duration, LeftPos, TopPos, Max(1dip, Width), Max(1dip, Height))
	If Width > 0 And Height > 0 Then Base_Resize(Width, Height)
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
