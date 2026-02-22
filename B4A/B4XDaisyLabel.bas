B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size (eg 6, 24px, 1.5rem)
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Label text.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Text color.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, Description: Number in dip or Tailwind token (eg 12, text-sm, text-lg).
#DesignerProperty: Key: FontBold, DisplayName: Font Bold, FieldType: Boolean, DefaultValue: False, Description: Use bold font.
#DesignerProperty: Key: SingleLine, DisplayName: Single Line, FieldType: Boolean, DefaultValue: True, Description: Single line text.
#DesignerProperty: Key: HAlign, DisplayName: Horizontal Align, FieldType: String, DefaultValue: LEFT, List: LEFT|CENTER|RIGHT, Description: Text horizontal alignment.
#DesignerProperty: Key: VAlign, DisplayName: Vertical Align, FieldType: String, DefaultValue: CENTER, List: TOP|CENTER|BOTTOM, Description: Text vertical alignment.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in dip.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Use rounded-box radius.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Border width in dip.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: IsSkeleton, DisplayName: Is Skeleton, FieldType: Boolean, DefaultValue: False, Description: Show skeleton loading state.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Private mWidth As Float = 40dip
	Private mHeight As Float = 24dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	
	Private mText As String = ""
	Private mTextColor As Int = 0xFF000000
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mBorderColor As Int = xui.Color_Transparent
	Private mTextColorOverride As Int = 0
	Private mBackgroundColorOverride As Int = 0
	Private mBorderColorOverride As Int = 0

	Private mTextSize As Float = 14dip 'resolved from text-sm
	Private mFontBold As Boolean = False
	Private mSingleLine As Boolean = True
	Private mHAlign As String = "LEFT"
	Private mVAlign As String = "CENTER"
	Private mPadding As Float = 0dip
	Private mMargin As String = ""
	Private mRoundedBox As Boolean = False
	Private mBorderWidth As Float = 0dip
	
	Private mVisible As Boolean = True
	Private mEnabled As Boolean = True
	Private lblContent As B4XView

	'Skeleton Support
	Private mIsSkeleton As Boolean = False
	Private mVariant As String = "none"
	Private pnlSkeleton As B4XView
	Private cvs As B4XCanvas
	
	Private mAnimProgress As Float = 1.5
	Private mAnimTimer As Timer
	Private mAnimDuration As Long = 1800
	Private mAnimStartTime As Long
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	mAnimTimer.Initialize("AnimTimer", 16)
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("base")
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

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mTag = mBase.Tag
	mBase.Tag = Me

	Dim l As Label
	l.Initialize("lblContent")
	l.SingleLine = True
	lblContent = l
	mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)

	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mWidth = Max(1dip, GetPropSizeDip(Props, "Width", mWidth))
	mHeight = Max(1dip, GetPropSizeDip(Props, "Height", mHeight))
	mWidthExplicit = Props.IsInitialized And Props.ContainsKey("Width")
	mHeightExplicit = Props.IsInitialized And Props.ContainsKey("Height")
	mText = GetPropString(Props, "Text", mText)
	mTextColor = GetPropColor(Props, "TextColor", mTextColor)
	mBackgroundColor = GetPropColor(Props, "BackgroundColor", mBackgroundColor)
	mTextSize = ResolveTextSize(GetPropObject(Props, "TextSize", mTextSize), mTextSize)
	mFontBold = GetPropBool(Props, "FontBold", mFontBold)
	mSingleLine = GetPropBool(Props, "SingleLine", mSingleLine)
	mHAlign = NormalizeHAlign(GetPropString(Props, "HAlign", mHAlign))
	mVAlign = NormalizeVAlign(GetPropString(Props, "VAlign", mVAlign))
	mPadding = Max(0, GetPropFloat(Props, "Padding", mPadding / 1dip) * 1dip)
	mMargin = GetPropString(Props, "Margin", mMargin)
	mRoundedBox = GetPropBool(Props, "RoundedBox", mRoundedBox)
	mBorderWidth = Max(0, GetPropFloat(Props, "BorderWidth", mBorderWidth / 1dip) * 1dip)
	mBorderColor = GetPropColor(Props, "BorderColor", mBorderColor)
	mVisible = GetPropBool(Props, "Visible", mVisible)
	mEnabled = GetPropBool(Props, "Enabled", mEnabled)
	mIsSkeleton = GetPropBool(Props, "IsSkeleton", mIsSkeleton)
	mVariant = B4XDaisyVariants.NormalizeVariant(GetPropString(Props, "Variant", mVariant))
	If mVariant <> "none" Then ApplyVariantColors
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	
	If pnlSkeleton.IsInitialized Then
		pnlSkeleton.SetLayoutAnimated(0, 0, 0, w, h)
		cvs.Resize(w, h)
	End If
	
	ApplyVisual
End Sub

Private Sub ApplyVisual
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim radius As Float = IIf(mRoundedBox, B4XDaisyVariants.GetRadiusBoxDip(8dip), 0)
	mBase.SetColorAndBorder(mBackgroundColor, mBorderWidth, mBorderColor, radius)

	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	lblContent.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	lblContent.Text = mText
	lblContent.TextColor = mTextColor
	lblContent.TextSize = mTextSize
	lblContent.SetTextAlignment(mVAlign, mHAlign)
	Dim l As Label = lblContent
	l.SingleLine = mSingleLine
	If mFontBold Then
		lblContent.Font = xui.CreateDefaultBoldFont(mTextSize)
	Else
		lblContent.Font = xui.CreateDefaultFont(mTextSize)
	End If
	mBase.Visible = mVisible
	lblContent.Enabled = mEnabled
	ApplySkeletonVisual
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	box.Put("padding_left", mPadding)
	box.Put("padding_right", mPadding)
	box.Put("padding_top", mPadding)
	box.Put("padding_bottom", mPadding)
	ApplyMarginSpecToBox(box, mMargin)
	Return box
End Sub

Private Sub ApplyMarginSpecToBox(Box As Map, MarginSpec As String)
	Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
	If m.Length = 0 Then Return
	Dim rtl As Boolean = False
	If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
		B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
	Else
		Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
		Box.Put("margin_left", mv)
		Box.Put("margin_right", mv)
		Box.Put("margin_top", mv)
		Box.Put("margin_bottom", mv)
	End If
End Sub







Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim p As Panel
	p.Initialize("base")
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

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And lblContent.IsInitialized
End Sub

Private Sub lblContent_Click
	RaiseClick
End Sub

Private Sub base_Click
	RaiseClick
End Sub

Private Sub RaiseClick
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub

Private Sub NormalizeHAlign(Value As String) As String
	Dim s As String = Value.ToUpperCase.Trim
	Select Case s
		Case "LEFT", "CENTER", "RIGHT"
			Return s
		Case Else
			Return "LEFT"
	End Select
End Sub

Private Sub NormalizeVAlign(Value As String) As String
	Dim s As String = Value.ToUpperCase.Trim
	Select Case s
		Case "TOP", "CENTER", "BOTTOM"
			Return s
		Case Else
			Return "CENTER"
	End Select
End Sub

Private Sub ResolveTextSize(Value As Object, DefaultSize As Float) As Float
	If Value = Null Then Return DefaultSize
	If IsNumber(Value) Then Return Max(1, Value)
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultSize
	If IsNumber(s) Then Return Max(1, s)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(s, DefaultSize, DefaultSize * 1.4)
	Return Max(1, tm.GetDefault("font_size", DefaultSize))
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.IsInitialized = False Then Return DefaultDipValue
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.TailwindSizeToDip(Props.Get(Key), DefaultDipValue)
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub GetPropFloat(Props As Map, Key As String, DefaultValue As Float) As Float
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, DefaultValue)
End Sub

Private Sub GetPropObject(Props As Map, Key As String, DefaultValue As Object) As Object
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Return Props.Get(Key)
End Sub

Public Sub setText(Value As String)
	mText = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mWidth, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setTextColor(Value As Int)
	mTextColorOverride = Value
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub



Public Sub setBackgroundColor(Value As Int)
	mBackgroundColorOverride = Value
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(VariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	' Reset manual colors to ensure variant colors take full effect. (Last one wins)
	mTextColorOverride = 0
	mBackgroundColorOverride = 0
	mBorderColorOverride = 0
	If mBase.IsInitialized = False Then Return
	ApplyVariantColors
	ApplyVisual
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Private Sub ApplyVariantColors
	' Start with theme defaults if no overrides
	Dim p As Map = B4XDaisyVariants.GetVariantPalette
	If mVariant = "none" Then
		mBackgroundColor = xui.Color_Transparent
		mTextColor = 0xFF000000
		mBorderColor = xui.Color_Transparent
	Else
		mBackgroundColor = B4XDaisyVariants.ResolveVariantColor(p, mVariant, "back", xui.Color_Transparent)
		mTextColor = B4XDaisyVariants.ResolveVariantColor(p, mVariant, "text", 0xFF000000)
		mBorderColor = B4XDaisyVariants.ResolveBorderColorVariantFromPalette(p, mVariant, xui.Color_Transparent)
	End If
	
	' Apply overrides if set
	If mBackgroundColorOverride <> 0 Then mBackgroundColor = mBackgroundColorOverride
	If mTextColorOverride <> 0 Then mTextColor = mTextColorOverride
	If mBorderColorOverride <> 0 Then mBorderColor = mBorderColorOverride
End Sub

Public Sub setTextSize(Value As Object)
	mTextSize = ResolveTextSize(Value, mTextSize)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextSize As Object
	Return mTextSize
End Sub

Public Sub setFontBold(Value As Boolean)
	mFontBold = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getFontBold As Boolean
	Return mFontBold
End Sub

Public Sub setSingleLine(Value As Boolean)
	mSingleLine = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getSingleLine As Boolean
	Return mSingleLine
End Sub

Public Sub setHAlign(Value As String)
	mHAlign = NormalizeHAlign(Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getHAlign As String
	Return mHAlign
End Sub

Public Sub setVAlign(Value As String)
	mVAlign = NormalizeVAlign(Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVAlign As String
	Return mVAlign
End Sub

Public Sub setPadding(Value As Float)
	mPadding = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getPadding As Float
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setBorderWidth(Value As Float)
	mBorderWidth = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderWidth As Float
	Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
	mBorderColorOverride = Value
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub



Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setEnabled(Value As Boolean)
	mEnabled = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Private Sub ApplySkeletonVisual
	If mIsSkeleton Then
		EnsureSkeletonPanel
		pnlSkeleton.Visible = True
		pnlSkeleton.BringToFront
		lblContent.Visible = False
		StartAnimation
	Else
		StopAnimation
		If pnlSkeleton.IsInitialized Then
			pnlSkeleton.Visible = False
		End If
		lblContent.Visible = mVisible
	End If
End Sub

Private Sub EnsureSkeletonPanel
	If pnlSkeleton.IsInitialized And pnlSkeleton.Parent.IsInitialized Then
		Return
	End If
	If pnlSkeleton.IsInitialized Then pnlSkeleton.RemoveViewFromParent
	
	Dim p As Panel
	p.Initialize("")
	pnlSkeleton = p
	pnlSkeleton.Visible = False
	mBase.AddView(pnlSkeleton, 0, 0, mBase.Width, mBase.Height)
	cvs.Initialize(pnlSkeleton)
End Sub

Public Sub StartAnimation
    mAnimStartTime = DateTime.Now
    mAnimTimer.Enabled = True
End Sub

Public Sub StopAnimation
    mAnimTimer.Enabled = False
End Sub

Private Sub AnimTimer_Tick
    ' Calculate progress using ease-in-out timing
    Dim elapsed As Long = DateTime.Now - mAnimStartTime
    Dim t As Float = (elapsed Mod mAnimDuration) / mAnimDuration
    
    ' Ease-in-out cubic
    If t < 0.5 Then
        t = 4 * t * t * t
    Else
        t = 1 - Power(-2 * t + 2, 3) / 2
    End If
    
    ' Map progress: -0.5 (-50%) -> 1.5 (150%) (Left to Right)
    mAnimProgress = -0.5 + (t * 2.0)
    
    DrawSkeleton
End Sub

Private Sub DrawSkeleton
    If pnlSkeleton.IsInitialized = False Then Return
    Dim w As Float = pnlSkeleton.Width
    Dim h As Float = pnlSkeleton.Height
    If w <= 0 Or h <= 0 Then Return
    
    cvs.ClearRect(cvs.TargetRect)
    DrawTextSkeleton(w, h)
    cvs.Invalidate
End Sub

Public Sub setIsSkeleton(Value As Boolean)
	If mIsSkeleton = Value Then Return
	mIsSkeleton = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getIsSkeleton As Boolean
	Return mIsSkeleton
End Sub

Private Sub SetAlpha (Color As Int, Alpha As Int) As Int
    Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
    Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
    Dim b As Int = Bit.And(Color, 0xFF)
    Return Bit.Or(Bit.ShiftLeft(Alpha, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub


Private Sub DrawTextSkeleton (w As Float, h As Float)
    If mText.Length = 0 Then Return
    
    ' Resolve layout (same as ApplyVisual)
	Dim host As B4XRect : host.Initialize(0, 0, w, h)
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    
	Dim fnt As B4XFont
    If mFontBold Then
        fnt = xui.CreateDefaultBoldFont(mTextSize)
    Else
        fnt = xui.CreateDefaultFont(mTextSize)
    End If
    
	Dim cx As Float, cy As Float
	Dim halign As String = mHAlign
	Dim valign As String = mVAlign

	Select Case halign
		Case "LEFT": cx = contentRect.Left
		Case "CENTER": cx = contentRect.CenterX
		Case "RIGHT": cx = contentRect.Right
	End Select
	
	Dim Bounds As B4XRect = cvs.MeasureText(mText, fnt)
	Select Case valign
		Case "TOP": cy = contentRect.Top + Bounds.Height
		Case "CENTER": cy = contentRect.CenterY - (Bounds.Top + Bounds.Bottom) / 2
		Case "BOTTOM": cy = contentRect.Bottom - Bounds.Bottom
	End Select

    ' Base text color with low opacity (20%)
    Dim baseAlpha As Int = 51  '255 * 0.2
    Dim baseTextColor As Int = SetAlpha(mTextColor, baseAlpha)
    
    ' Draw base faded text
    cvs.DrawText(mText, cx, cy, fnt, baseTextColor, halign)
    
    ' Define shimmer region
    Dim shimmerCenter As Float = mAnimProgress * w
    Dim shimmerWidth As Float = w * 0.3
    Dim skew As Float = h
    
    ' ---- NATIVE CLIPPING for the bright text strip ----
    #If B4A
    Dim jo As JavaObject = cvs
    Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")
    Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas")
    
    Dim clipPath As JavaObject
    clipPath.InitializeNewInstance("android.graphics.Path", Null)
    
    Dim stripX As Float = shimmerCenter - shimmerWidth
    ' Define slanted strip points (/)
    clipPath.RunMethod("moveTo", Array(stripX + skew, 0.0f))
    clipPath.RunMethod("lineTo", Array(stripX + skew + shimmerWidth, 0.0f))
    clipPath.RunMethod("lineTo", Array(stripX + shimmerWidth, h))
    clipPath.RunMethod("lineTo", Array(stripX, h))
    clipPath.RunMethod("close", Null)
    
    nativeCanvas.RunMethod("save", Null)
    nativeCanvas.RunMethod("clipPath", Array(clipPath))
    #End If
    
    ' Draw bright text (only the part inside the clipPath will show)
    cvs.DrawText(mText, cx, cy, fnt, mTextColor, halign)
    
    #If B4A
    nativeCanvas.RunMethod("restore", Null)
    #End If
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

Public Sub setColor(BackgroundColor As Int)
    setBackgroundColor(BackgroundColor)
End Sub

Public Sub getColor As Int
	Return mBackgroundColor
End Sub

Public Sub SetTextAlignment(Vertical As String, Horizontal As String)
    setVAlign(Vertical)
    setHAlign(Horizontal)
End Sub

Public Sub SetLayoutAnimated(Duration As Int, LeftPos As Int, TopPos As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(Duration, LeftPos, TopPos, Max(1dip, Width), Max(1dip, Height))
    If Width > 0 And Height > 0 Then Base_Resize(Width, Height)
End Sub

Public Sub SetColorAndBorder(CBackgroundColor As Int, CBorderW As Float, CBorderC As Int, CornerRadius As Float)
    mBackgroundColor = CBackgroundColor
    mBorderWidth = CBorderW
    mBorderColor = CBorderC
    mRoundedBox = (CornerRadius > 0)
    If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub