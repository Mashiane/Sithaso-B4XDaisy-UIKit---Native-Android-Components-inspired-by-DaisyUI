B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
'B4XDaisyDiv.bas
'Versatile container component inspired by HTML div + Tailwind utility classes.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Background color of the container.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Color of the text content.
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Text to display in the container.
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Apply 16px rounded corners.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Shadow depth (elevation).
#DesignerProperty: Key: PlaceContentCenter, DisplayName: Place Content Center, FieldType: Boolean, DefaultValue: False, Description: Center content horizontally and vertically.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Border width in dips.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Border color.
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: solid, List: none|hidden|solid|double|dashed|dotted|groove|ridge|inset|outset, Description: HTML-like border style token.
#DesignerProperty: Key: BorderReliefStrength, DisplayName: Relief Strength, FieldType: Int, DefaultValue: 55, Description: 0-100 strength for groove/ridge/inset/outset shading.
#DesignerProperty: Key: AutoReliefByStyle, DisplayName: Auto Relief By Style, FieldType: Boolean, DefaultValue: True, Description: Use built-in per-style relief presets for groove/ridge/inset/outset.

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI
	
	Private mWidth As Float = 40dip
	Private mHeight As Float = 40dip
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mTextColor As Int = xui.Color_Black
	Private mText As String = ""
	Private mRoundedBox As Boolean = False
	Private mShadow As String = "none"
	Private mPlaceContentCenter As Boolean = False
	Private mBorderWidth As Int = 0
	Private mBorderColor As Int = xui.Color_Black
	Private mBorderStyle As String = "solid"
	Private mBorderReliefStrength As Int = 55
	Private mAutoReliefByStyle As Boolean = True
	Private Const RELIEF_PRESET_INSET_OUTSET As Int = 46
	Private Const RELIEF_PRESET_GROOVE_RIDGE As Int = 68
	Private mTag As Object
	
	Private lblContent As B4XView
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim dummy As Label
	DesignerCreateView(b, dummy, CreateMap())
	mWidth = Width
	mHeight = Height
	Return mBase
End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mTag = mBase.Tag
	mBase.Tag = Me
    
    ' Create internal label for text content
    Dim lblInternal As Label
    lblInternal.Initialize("lblContent")
    lblContent = lblInternal
    lblContent.SetTextAlignment("CENTER", "CENTER") 
    mBase.AddView(lblContent, 0, 0, 0, 0) 
    
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mWidth = B4XDaisyVariants.TailwindSizeToDip("10", 40dip)
    mHeight = B4XDaisyVariants.TailwindSizeToDip("10", 40dip)
    mBackgroundColor = xui.Color_Transparent
    mTextColor = xui.Color_Black
    mText = ""
    mRoundedBox = False
    mShadow = "none"
     mPlaceContentCenter = False
     mBorderWidth = 0
     mBorderColor = xui.Color_Black
     mBorderStyle = "solid"
     mBorderReliefStrength = 55
     mAutoReliefByStyle = True
     
     If Props.IsInitialized = False Then Return
    
    mWidth = Max(1dip, GetPropSizeDip(Props, "Width", mWidth))
    mHeight = Max(1dip, GetPropSizeDip(Props, "Height", mHeight))
    mBackgroundColor = GetPropColor(Props, "BackgroundColor", mBackgroundColor)
    mTextColor = GetPropColor(Props, "TextColor", mTextColor)
    mText = GetPropString(Props, "Text", mText)
    mRoundedBox = GetPropBool(Props, "RoundedBox", mRoundedBox)
    mShadow = B4XDaisyVariants.NormalizeShadow(GetPropString(Props, "Shadow", mShadow))
     mPlaceContentCenter = GetPropBool(Props, "PlaceContentCenter", mPlaceContentCenter)
     mBorderWidth = GetPropInt(Props, "BorderWidth", mBorderWidth)
     mBorderColor = GetPropColor(Props, "BorderColor", mBorderColor)
     mBorderStyle = NormalizeBorderStyle(GetPropString(Props, "BorderStyle", mBorderStyle))
     mBorderReliefStrength = ClampReliefStrength(GetPropInt(Props, "BorderReliefStrength", mBorderReliefStrength))
     mAutoReliefByStyle = GetPropBool(Props, "AutoReliefByStyle", mAutoReliefByStyle)
     
     ApplyStyle
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    
    ApplyStyle
    
    ' Layout children
    For i = 0 To mBase.NumberOfViews - 1
        Dim v As B4XView = mBase.GetView(i)
        
        If v = lblContent Then
            v.Visible = True
            v.SetLayoutAnimated(0, 0, 0, Width, Height)
            If mPlaceContentCenter Then
                v.SetTextAlignment("CENTER", "CENTER")
            Else
                v.SetTextAlignment("TOP", "LEFT")
            End If
        Else
            'Other children
            If mPlaceContentCenter Then
                 v.SetLayoutAnimated(0, (Width - v.Width) / 2, (Height - v.Height) / 2, v.Width, v.Height)
            End If
        End If
    Next
End Sub

Public Sub AddToParent(Parent As B4XView)
	AddToParentAt(Parent, 0, 0, Parent.Width, Parent.Height)
End Sub

Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If Parent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim v As B4XView = CreateView(w, h)
	Parent.AddView(v, Left, Top, w, h)
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(ChildView, Left, Top, Width, Height)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Private Sub ApplyStyle
    lblContent.TextColor = mTextColor
    lblContent.Text = mText
    ApplyBorderVisual
    ApplyShadow
End Sub

Private Sub ApplyBorderVisual
	Dim bw As Int = Max(0, mBorderWidth)
	Dim radius As Float
	If mRoundedBox Then
		radius = 8dip
	Else
		radius = 0
	End If
	Dim style As String = NormalizeBorderStyle(mBorderStyle)
	
	If style = "none" Or style = "hidden" Or bw = 0 Then
		mBase.SetColorAndBorder(mBackgroundColor, 0, xui.Color_Transparent, radius)
		Return
	End If
	
	#If B4A
	Try
		Select Case style
			Case "solid"
				ApplySingleStrokeNative(bw, mBorderColor, radius, 0, 0)
				Return
			Case "dashed"
				ApplySingleStrokeNative(bw, mBorderColor, radius, Max(4dip, bw * 3), Max(3dip, bw * 2))
				Return
			Case "dotted"
				Dim dotW As Int = Max(1dip, bw)
				ApplySingleStrokeNative(dotW, mBorderColor, radius, dotW, Max(2dip, dotW * 1.5))
				Return
			Case "double"
				If ApplyDoubleBorderNative(bw, mBorderColor, radius) Then Return
			Case "groove"
				If ApplyGrooveRidgeNative(True, bw, mBorderColor, radius) Then Return
			Case "ridge"
				If ApplyGrooveRidgeNative(False, bw, mBorderColor, radius) Then Return
			Case "inset"
				If ApplyInsetOutsetNative(True, bw, mBorderColor, radius) Then Return
			Case "outset"
				If ApplyInsetOutsetNative(False, bw, mBorderColor, radius) Then Return
		End Select
		'Fallback branch for unknown style token on B4A
		ApplySingleStrokeNative(bw, mBorderColor, radius, 0, 0)
		Return
	Catch
		Log("B4XDaisyDiv.ApplyBorderVisual fallback: " & LastException.Message)
	End Try
	#End If
	
	mBase.SetColorAndBorder(mBackgroundColor, bw, mBorderColor, radius)
End Sub

#If B4A
Private Sub ApplySingleStrokeNative(StrokeWidth As Int, StrokeColor As Int, Radius As Float, DashWidth As Float, DashGap As Float)
	Dim gd As JavaObject = CreateSolidDrawable(mBackgroundColor, Radius, 0, 0)
	If DashWidth > 0 And DashGap > 0 Then
		gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor, DashWidth, DashGap))
	Else
		gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor))
	End If
	SetNativeBackground(gd)
End Sub

Private Sub ApplyDoubleBorderNative(BorderWidth As Int, BorderColor As Int, Radius As Float) As Boolean
	If BorderWidth <= 1dip Then
		ApplySingleStrokeNative(BorderWidth, BorderColor, Radius, 0, 0)
		Return True
	End If
	Dim lineW As Int = Max(1dip, BorderWidth / 3)
	Dim gapW As Int = Max(1dip, BorderWidth - (lineW * 2))
	Dim innerInset As Int = lineW + gapW

	Dim baseFill As JavaObject = CreateSolidDrawable(mBackgroundColor, Radius, 0, 0)
	Dim outerStroke As JavaObject = CreateSolidDrawable(xui.Color_Transparent, Radius, lineW, BorderColor)
	Dim innerRadius As Float = Max(0, Radius - innerInset)
	Dim innerStroke As JavaObject = CreateSolidDrawable(xui.Color_Transparent, innerRadius, lineW, BorderColor)

	Dim layers(3) As Object
	layers(0) = baseFill
	layers(1) = outerStroke
	layers(2) = innerStroke
	Dim ld As JavaObject
	ld.InitializeNewInstance("android.graphics.drawable.LayerDrawable", Array(layers))
	ld.RunMethod("setLayerInset", Array(2, innerInset, innerInset, innerInset, innerInset))
	SetNativeBackground(ld)
	Return True
End Sub

Private Sub ApplyInsetOutsetNative(IsInset As Boolean, BorderWidth As Int, BorderColor As Int, Radius As Float) As Boolean
	Dim styleName As String
	If IsInset Then
		styleName = "inset"
	Else
		styleName = "outset"
	End If
	Dim factors As Map = ResolveReliefFactors(styleName, False)
	Dim dark As Int = ShiftColor(BorderColor, factors.Get("dark"))
	Dim light As Int = ShiftColor(BorderColor, factors.Get("light"))
	Dim c1 As Int
	Dim c2 As Int
	If IsInset Then
		c1 = dark : c2 = light
	Else
		c1 = light : c2 = dark
	End If

	Dim outerGrad As JavaObject = CreateGradientFillDrawable(c1, c2, Radius)
	Dim innerRadius As Float = Max(0, Radius - BorderWidth)
	Dim innerFill As JavaObject = CreateSolidDrawable(mBackgroundColor, innerRadius, 0, 0)

	Dim layers(2) As Object
	layers(0) = outerGrad
	layers(1) = innerFill
	Dim ld As JavaObject
	ld.InitializeNewInstance("android.graphics.drawable.LayerDrawable", Array(layers))
	ld.RunMethod("setLayerInset", Array(1, BorderWidth, BorderWidth, BorderWidth, BorderWidth))
	SetNativeBackground(ld)
	Return True
End Sub

Private Sub ApplyGrooveRidgeNative(IsGroove As Boolean, BorderWidth As Int, BorderColor As Int, Radius As Float) As Boolean
	If BorderWidth <= 1dip Then
		ApplySingleStrokeNative(BorderWidth, BorderColor, Radius, 0, 0)
		Return True
	End If

	Dim styleName As String
	If IsGroove Then
		styleName = "groove"
	Else
		styleName = "ridge"
	End If
	Dim factors As Map = ResolveReliefFactors(styleName, True)
	Dim dark As Int = ShiftColor(BorderColor, factors.Get("dark"))
	Dim light As Int = ShiftColor(BorderColor, factors.Get("light"))
	Dim outerA As Int
	Dim outerB As Int
	Dim innerA As Int
	Dim innerB As Int
	If IsGroove Then
		outerA = dark : outerB = light
		innerA = light : innerB = dark
	Else
		outerA = light : outerB = dark
		innerA = dark : innerB = light
	End If

	Dim outerW As Int = Max(1dip, BorderWidth / 2)
	Dim innerW As Int = Max(1dip, BorderWidth - outerW)
	Dim totalInset As Int = outerW + innerW

	Dim outerGrad As JavaObject = CreateGradientFillDrawable(outerA, outerB, Radius)
	Dim innerRadius As Float = Max(0, Radius - outerW)
	Dim innerGrad As JavaObject = CreateGradientFillDrawable(innerA, innerB, innerRadius)
	Dim fillRadius As Float = Max(0, Radius - totalInset)
	Dim centerFill As JavaObject = CreateSolidDrawable(mBackgroundColor, fillRadius, 0, 0)

	Dim layers(3) As Object
	layers(0) = outerGrad
	layers(1) = innerGrad
	layers(2) = centerFill
	Dim ld As JavaObject
	ld.InitializeNewInstance("android.graphics.drawable.LayerDrawable", Array(layers))
	ld.RunMethod("setLayerInset", Array(1, outerW, outerW, outerW, outerW))
	ld.RunMethod("setLayerInset", Array(2, totalInset, totalInset, totalInset, totalInset))
	SetNativeBackground(ld)
	Return True
End Sub

Private Sub CreateSolidDrawable(FillColor As Int, Radius As Float, StrokeWidth As Int, StrokeColor As Int) As JavaObject
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setShape", Array(0)) 'RECTANGLE
	gd.RunMethod("setColor", Array(FillColor))
	gd.RunMethod("setCornerRadius", Array(Radius))
	If StrokeWidth > 0 Then gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor))
	Return gd
End Sub

Private Sub CreateGradientFillDrawable(ColorStart As Int, ColorEnd As Int, Radius As Float) As JavaObject
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setShape", Array(0)) 'RECTANGLE
	Dim orient As JavaObject
	orient.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
	gd.RunMethod("setOrientation", Array(orient.GetField("TL_BR")))
	Dim cols(2) As Int
	cols(0) = ColorStart
	cols(1) = ColorEnd
	gd.RunMethod("setColors", Array(cols))
	gd.RunMethod("setCornerRadius", Array(Radius))
	Return gd
End Sub

Private Sub SetNativeBackground(Drawable As JavaObject)
	Dim jo As JavaObject = mBase
	jo.RunMethod("setBackground", Array(Drawable))
End Sub
#End If

Private Sub ApplyShadow
    Dim e As Float = B4XDaisyVariants.ResolveShadowElevation(mShadow)
    #If B4A
    Dim p As Panel = mBase
    p.Elevation = e
    #End If
End Sub

'Getters and Setters

Public Sub setWidth(Value As Object)
    mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As Float
    Return mWidth
End Sub

Public Sub setHeight(Value As Object)
    mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As Float
    Return mHeight
End Sub

Public Sub setBackgroundColor(Color As Int)
    mBackgroundColor = Color
    ApplyStyle
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setTextColor(Color As Int)
    mTextColor = Color
    ApplyStyle
End Sub

Public Sub getTextColor As Int
    Return mTextColor
End Sub

Public Sub setText(Text As String)
    mText = Text
    ApplyStyle
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getText As String
    Return mText
End Sub

Public Sub setRoundedBox(Value As Boolean)
    mRoundedBox = Value
    ApplyStyle
End Sub

Public Sub getRoundedBox As Boolean
    Return mRoundedBox
End Sub

Public Sub setShadow(Value As String)
    mShadow = B4XDaisyVariants.NormalizeShadow(Value)
    ApplyStyle
End Sub

Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setPlaceContentCenter(Value As Boolean)
    mPlaceContentCenter = Value
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPlaceContentCenter As Boolean
    Return mPlaceContentCenter
End Sub

Public Sub setBorderWidth(Value As Int)
    mBorderWidth = Value
    ApplyStyle
End Sub

Public Sub getBorderWidth As Int
    Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
    mBorderColor = Value
    ApplyStyle
End Sub

Public Sub getBorderColor As Int
    Return mBorderColor
End Sub

Public Sub setBorderStyle(Value As String)
	mBorderStyle = NormalizeBorderStyle(Value)
	ApplyStyle
End Sub

Public Sub getBorderStyle As String
	Return mBorderStyle
End Sub

Public Sub setBorderReliefStrength(Value As Int)
	mBorderReliefStrength = ClampReliefStrength(Value)
	ApplyStyle
End Sub

Public Sub getBorderReliefStrength As Int
	Return mBorderReliefStrength
End Sub

Public Sub setAutoReliefByStyle(Value As Boolean)
	mAutoReliefByStyle = Value
	ApplyStyle
End Sub

Public Sub getAutoReliefByStyle As Boolean
	Return mAutoReliefByStyle
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

' Helpers

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
    If Props.ContainsKey(Key) = False Then Return DefaultDipValue
    Dim o As Object = Props.Get(Key)
    Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
End Sub

Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
    If Props.ContainsKey(Key) = False Then Return DefaultValue
    Return xui.PaintOrColorToColor(Props.Get(Key))
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
    Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
    Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
    Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub NormalizeBorderStyle(Value As String) As String
	If Value = Null Then Return "solid"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "none", "hidden", "solid", "double", "dashed", "dotted", "groove", "ridge", "inset", "outset"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

Private Sub ClampReliefStrength(Value As Int) As Int
	Return Max(0, Min(100, Value))
End Sub

Private Sub ResolveReliefFactors(StyleName As String, Strong As Boolean) As Map
	Dim effectiveStrength As Int = EffectiveReliefStrength(StyleName, Strong)
	Dim t As Float = ClampReliefStrength(effectiveStrength) / 100
	If Strong = False Then t = t * 0.82
	Dim darkFactor As Float = 1 - (0.42 * t)
	Dim lightFactor As Float = 1 + (0.34 * t)
	Return CreateMap("dark": darkFactor, "light": lightFactor)
End Sub

Private Sub EffectiveReliefStrength(StyleName As String, Strong As Boolean) As Int
	Dim manual As Int = ClampReliefStrength(mBorderReliefStrength)
	If mAutoReliefByStyle = False Then Return manual
	
	Dim s As String = NormalizeBorderStyle(StyleName)
	Select Case s
		Case "inset", "outset"
			Return RELIEF_PRESET_INSET_OUTSET
		Case "groove", "ridge"
			Return RELIEF_PRESET_GROOVE_RIDGE
		Case Else
			If Strong Then
				Return Max(manual, RELIEF_PRESET_GROOVE_RIDGE)
			Else
				Return Max(manual, RELIEF_PRESET_INSET_OUTSET)
			End If
	End Select
End Sub

Private Sub ShiftColor(Color As Int, Factor As Float) As Int
	Dim a As Int = Bit.And(Bit.ShiftRight(Color, 24), 0xFF)
	Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
	Dim b As Int = Bit.And(Color, 0xFF)
	r = Max(0, Min(255, r * Factor))
	g = Max(0, Min(255, g * Factor))
	b = Max(0, Min(255, b * Factor))
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Private Sub lblContent_Click
	RaiseClick
End Sub

Private Sub RaiseClick
	Dim payload As Object = mTag
	If payload = Null Then payload = mBase
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", payload)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub
