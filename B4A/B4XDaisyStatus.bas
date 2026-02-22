B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue:, Description: Optional width token (Tailwind/CSS). Leave empty to use Size token.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue:, Description: Optional height token (Tailwind/CSS). Leave empty to use Size token.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy status size token.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy semantic status color.
#DesignerProperty: Key: Animation, DisplayName: Animation, FieldType: String, DefaultValue: none, List: none|pulse|bounce, Description: Built-in status animation.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Optional padding utility token(s).
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue: 1, Description: Optional margin utility token(s).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide status view.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private mWidth As Float = 8dip
	Private mHeight As Float = 8dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mSize As String = "md"
	Private mVariant As String = "none"
	Private mAnimation As String = "none"
	Private mPadding As String = ""
	Private mMargin As String = "1"
	Private mVisible As Boolean = True

	Private mBackgroundColor As Int = 0
	Private mTextColor As Int = 0
	Private mDepth As Float = -1

	Private Surface As B4XView
	Private ShadowHost As B4XView
	Private DotHost As B4XView
	Private RingHost As B4XView
	Private HighlightHost As B4XView
	Private AnimTimer As Timer
	Private mAnimStartedAt As Long = 0
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	If AnimTimer.IsInitialized = False Then
		AnimTimer.Initialize("animtimer", 33)
		AnimTimer.Enabled = False
	End If
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)
	DisableClipping(mBase)
	DisableClipping(Surface)

	Dim pShadow As Panel
	pShadow.Initialize("")
	ShadowHost = pShadow
	ShadowHost.Enabled = False
	ShadowHost.Color = xui.Color_Transparent
	Surface.AddView(ShadowHost, 0, 0, 1dip, 1dip)

	Dim pDot As Panel
	pDot.Initialize("")
	DotHost = pDot
	DotHost.Color = xui.Color_Transparent
	Surface.AddView(DotHost, 0, 0, 1dip, 1dip)

	Dim pHighlight As Panel
	pHighlight.Initialize("")
	HighlightHost = pHighlight
	HighlightHost.Enabled = False
	HighlightHost.Color = xui.Color_Transparent
	DotHost.AddView(HighlightHost, 0, 0, 1dip, 1dip)

	Dim pRing As Panel
	pRing.Initialize("")
	RingHost = pRing
	RingHost.Enabled = False
	RingHost.Color = xui.Color_Transparent
	DotHost.AddView(RingHost, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(Props)
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
	UpdateAnimationState
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mSize = NormalizeSize(GetPropString(Props, "Size", mSize))
	mVariant = B4XDaisyVariants.NormalizeVariant(GetPropString(Props, "Variant", mVariant))
	mAnimation = NormalizeAnimation(GetPropString(Props, "Animation", mAnimation))
	mPadding = GetPropString(Props, "Padding", mPadding)
	mMargin = GetPropString(Props, "Margin", mMargin)
	mVisible = GetPropBool(Props, "Visible", mVisible)

	mWidthExplicit = IsExplicitSizeProp(Props, "Width")
	mHeightExplicit = IsExplicitSizeProp(Props, "Height")
	
	Dim sz As Map = ResolveSizeSpec
	Dim defSize As Float = sz.GetDefault("size", 8dip)
	
	mWidth = Max(1dip, GetPropSizeDip(Props, "Width", mWidth))
	mHeight = Max(1dip, GetPropSizeDip(Props, "Height", mHeight))
	
	If mWidthExplicit = False Then mWidth = defSize
	If mHeightExplicit = False Then mHeight = defSize
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







Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)

	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, w, h)

	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)

	Dim contentRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutStatusDot(contentRect)
	ApplyAnimationFrame(DateTime.Now)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	DisableClipping(Parent)

	Dim autoW As Boolean = (Width <= 0)
	Dim autoH As Boolean = (Height <= 0)
	Dim w As Int = Width
	Dim h As Int = Height
	If w <= 0 Then w = ResolveRequiredOuterWidth
	If h <= 0 Then h = ResolveRequiredOuterHeight

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
	EnsureHostSizeForBoxModel
	Dim finalLeft As Int = Left
	Dim finalTop As Int = Top
	If autoW And Parent.Width > 0 Then finalLeft = Left + (Parent.Width - mBase.Width) / 2
	If autoH And Parent.Height > 0 Then finalTop = Top + (Parent.Height - mBase.Height) / 2
	Parent.AddView(mBase, finalLeft, finalTop, mBase.Width, mBase.Height)
	Return mBase
End Sub

Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Return AddToParent(Parent, Left, Top, Width, Height)
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And Surface.IsInitialized
End Sub

' Centers this status view inside the given parent (or current parent when omitted).
Public Sub CenterInParent(Parent As B4XView)
	If mBase.IsInitialized = False Then Return
	Dim host As B4XView
	If Parent.IsInitialized Then
		host = Parent
	Else If mBase.Parent.IsInitialized Then
		host = mBase.Parent
	End If
	If host.IsInitialized = False Then Return
	Dim l As Int = (host.Width - mBase.Width) / 2
	Dim t As Int = (host.Height - mBase.Height) / 2
	mBase.SetLayoutAnimated(0, l, t, mBase.Width, mBase.Height)
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, mPadding, mMargin)
	box.Put("border_width", 0dip)
	box.Put("radius", ResolveSelectorRadius)
	Return box
End Sub

Private Sub ApplySpacingSpecToBox(Box As Map, PaddingSpec As String, MarginSpec As String)
	Dim rtl As Boolean = False
	Dim p As String = IIf(PaddingSpec = Null, "", PaddingSpec.Trim)
	Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
	If p.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(p, Array As String("p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-")) Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(Box, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			Box.Put("padding_left", pv)
			Box.Put("padding_right", pv)
			Box.Put("padding_top", pv)
			Box.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
			B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			Box.Put("margin_left", mv)
			Box.Put("margin_right", mv)
			Box.Put("margin_top", mv)
			Box.Put("margin_bottom", mv)
		End If
	End If
End Sub

Private Sub ResolveContentLocalRect(OuterRect As B4XRect, Box As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(OuterRect, Box)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, Box)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, OuterRect)
End Sub

Private Sub LayoutStatusDot(ContentRect As B4XRect)
	Dim side As Int = Max(1dip, Min(ContentRect.Width, ContentRect.Height))
	Dim dotX As Int = ContentRect.Left + (ContentRect.Width - side) / 2
	Dim dotY As Int = ContentRect.Top + (ContentRect.Height - side) / 2
	DotHost.SetLayoutAnimated(0, dotX, dotY, side, side)

	Dim colorsMap As Map = ResolveVisualColors
	Dim backColor As Int = colorsMap.Get("back")
	Dim textColor As Int = colorsMap.Get("text")
	Dim radius As Float = side / 2
	LayoutShadow(side, dotX, dotY, backColor)
	ApplyDotFill(backColor, radius)
	LayoutRing(side, backColor)
	ApplyDepthShadow(textColor)
	LayoutHighlight(side)
End Sub

Private Sub LayoutShadow(Side As Int, DotLeft As Int, DotTop As Int, BackColor As Int)
	If ShadowHost.IsInitialized = False Then Return
	Dim shadowSide As Int = Max(Side + 2dip, Side * 1.3)
	Dim left As Int = DotLeft - (shadowSide - Side) / 2
	Dim top As Int = DotTop - (shadowSide - Side) / 2
	Dim depth As Float = ResolveDepth
	Dim alpha01 As Float = 0.18 + Min(0.16, depth * 0.08)
	Dim softColor As Int = AlphaColor(B4XDaisyVariants.Blend(BackColor, xui.Color_Black, 0.15), alpha01)
	ShadowHost.Visible = True
	ShadowHost.SetLayoutAnimated(0, left, top, shadowSide, shadowSide)
	ShadowHost.SetColorAndBorder(softColor, 0dip, xui.Color_Transparent, shadowSide / 2)
End Sub

Private Sub LayoutRing(Side As Int, BackColor As Int)
	If RingHost.IsInitialized = False Then Return
	Dim ringStroke As Int = 1dip
	Dim ringColor As Int = AlphaColor(B4XDaisyVariants.Blend(BackColor, xui.Color_White, 0.35), 0.45)
	RingHost.Visible = True
	RingHost.SetLayoutAnimated(0, 0, 0, Side, Side)
	RingHost.SetColorAndBorder(xui.Color_Transparent, ringStroke, ringColor, Side / 2)
End Sub

Private Sub LayoutHighlight(Side As Int)
	Dim depth As Float = ResolveDepth
	Dim alpha01 As Float = 0.20
	If depth > 0 Then alpha01 = Min(0.55, 0.20 + (depth * 0.20))
	If alpha01 <= 0 Then
		HighlightHost.Visible = False
		HighlightHost.SetLayoutAnimated(0, 0, 0, 0, 0)
		Return
	End If

	Dim glowSize As Int = Max(1dip, Side * 0.62)
	Dim cx As Float = Side * 0.35
	Dim cy As Float = Side * 0.30
	Dim left As Int = Round(cx - glowSize / 2)
	Dim top As Int = Round(cy - glowSize / 2)
	HighlightHost.Visible = True
	HighlightHost.SetLayoutAnimated(0, left, top, glowSize, glowSize)
	HighlightHost.SetColorAndBorder(AlphaColor(xui.Color_White, alpha01), 0dip, xui.Color_Transparent, glowSize / 2)
End Sub

Private Sub ApplyDotFill(BackColor As Int, Radius As Float)
	#If B4A
	Try
		Dim topColor As Int = B4XDaisyVariants.Blend(BackColor, xui.Color_White, 0.22)
		Dim bottomColor As Int = B4XDaisyVariants.Blend(BackColor, xui.Color_Black, 0.10)
		Dim orientation As JavaObject
		orientation.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(1)) ' OVAL
		gd.RunMethod("setOrientation", Array(orientation.GetField("TL_BR")))
		Dim midColor As Int = B4XDaisyVariants.Blend(BackColor, topColor, 0.35)
		Dim gradientColors() As Int = Array As Int(topColor, midColor, bottomColor)
		gd.RunMethod("setColors", Array(gradientColors))
		SetNativeBackground(DotHost, gd)
	Catch
		DotHost.SetColorAndBorder(BackColor, 0dip, xui.Color_Transparent, Radius)
	End Try
	#Else
	DotHost.SetColorAndBorder(BackColor, 0dip, xui.Color_Transparent, Radius)
	#End If
End Sub

Private Sub ResolveVisualColors As Map
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette

	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(63, 64, 77))
	Dim defaultBack As Int = AlphaColor(baseContent, 0.2)
	Dim defaultText As Int = AlphaColor(xui.Color_Black, 0.3)

	Dim backColor As Int = defaultBack
	Dim textColor As Int = defaultText
	Dim keyVariant As String = B4XDaisyVariants.NormalizeVariant(mVariant)
	If keyVariant <> "none" Then
		backColor = B4XDaisyVariants.ResolveVariantColor(palette, keyVariant, "back", backColor)
		textColor = B4XDaisyVariants.ResolveVariantColor(palette, keyVariant, "text", defaultText)
	End If

	If mBackgroundColor <> 0 Then backColor = mBackgroundColor
	If mTextColor <> 0 Then textColor = mTextColor
	Return CreateMap("back": backColor, "text": textColor)
End Sub

Private Sub ApplyDepthShadow(ShadowColor As Int)
	Dim depth As Float = ResolveDepth
	#If B4A
	Dim p As Panel = DotHost
	Dim effectiveDepth As Float = Max(0.35, depth)
	p.Elevation = Max(0, effectiveDepth * 2dip)
	Dim ignoreShadow As Int = ShadowColor
	#Else
	Dim ignoreView As B4XView = DotHost
	Dim ignoreDepth As Float = depth
	Dim ignoreShadow As Int = ShadowColor
	#End If
End Sub

Private Sub ResolveDepth As Float
	If mDepth >= 0 Then Return mDepth
	Return Max(0, B4XDaisyVariants.GetTokenNumber("--depth", 0))
End Sub

Private Sub ResolveSizeSpec As Map
	Select Case NormalizeSize(mSize)
		Case "xs"
			Return CreateMap("size": 2dip)
		Case "sm"
			Return CreateMap("size": 4dip)
		Case "lg"
			Return CreateMap("size": 12dip)
		Case "xl"
			Return CreateMap("size": 16dip)
		Case Else
			Return CreateMap("size": 8dip)
	End Select
End Sub

Private Sub NormalizeSize(Value As String) As String
	If Value = Null Then Return "md"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "xs", "sm", "md", "lg", "xl"
			Return s
		Case Else
			Return "md"
	End Select
End Sub

Private Sub ResolveSelectorRadius As Float
	' Status is always rounded-full.
	Return 9999dip
End Sub

#If B4A
Private Sub SetNativeBackground(Target As B4XView, Drawable As JavaObject)
	Dim jo As JavaObject = Target
	jo.RunMethod("setBackground", Array(Drawable))
End Sub
#End If

Private Sub AlphaColor(ColorValue As Int, Alpha01 As Float) As Int
	Dim a As Int = Max(0, Min(255, Round(255 * Max(0, Min(1, Alpha01)))))
	Dim r As Int = Bit.And(Bit.ShiftRight(ColorValue, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(ColorValue, 8), 0xFF)
	Dim b As Int = Bit.And(ColorValue, 0xFF)
	Return xui.Color_ARGB(a, r, g, b)
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub IsExplicitSizeProp(Props As Map, Key As String) As Boolean
	If Props.IsInitialized = False Then Return False
	If Props.ContainsKey(Key) = False Then Return False
	Dim raw As Object = Props.Get(Key)
	If raw = Null Then Return False
	Dim s As String = raw
	s = s.Trim
	If s.Length = 0 Then Return False
	Return True
End Sub

Private Sub ResolveWidthBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Width > 0 Then Return parent.Width
		If mBase.Width > 0 Then Return mBase.Width
	End If
	Return DefaultValue
End Sub

Private Sub ResolveHeightBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Height > 0 Then Return parent.Height
		If mBase.Height > 0 Then Return mBase.Height
	End If
	Return DefaultValue
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
	UpdateAnimationState
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Int = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, targetH)
	Base_Resize(mWidth, targetH)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mHeight)
	Base_Resize(targetW, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(Value As String)
	mSize = NormalizeSize(Value)
	If mWidthExplicit = False Or mHeightExplicit = False Then
		Dim sz As Map = ResolveSizeSpec
		Dim side As Int = Max(1dip, sz.GetDefault("size", 8dip))
		If mWidthExplicit = False Then mWidth = side
		If mHeightExplicit = False Then mHeight = side
		If mBase.IsInitialized And mWidthExplicit = False And mHeightExplicit = False Then
			EnsureHostSizeForBoxModel
		End If
	End If
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ResolveWidthPropValue As String
	If mWidthExplicit Then Return ResolvePxSizeSpec(mWidth)
	Return ""
End Sub

Private Sub ResolveHeightPropValue As String
	If mHeightExplicit Then Return ResolvePxSizeSpec(mHeight)
	Return ""
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setAnimation(Value As String)
	mAnimation = NormalizeAnimation(Value)
	If mBase.IsInitialized = False Then Return
	UpdateAnimationState
End Sub

Public Sub getAnimation As String
	Return mAnimation
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	' Reset manual overrides to ensure variant colors take full effect.
	mBackgroundColor = 0
	mTextColor = 0
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setPadding(Value As String)
	mPadding = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	UpdateAnimationState
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackgroundColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(VariantName, mBackgroundColor)
	setBackgroundColor(c)
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(VariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setDepth(Value As Float)
	mDepth = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDepth As Float
	Return mDepth
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized = False Then Return
	mBase.Tag = Me
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Private Sub EnsureHostSizeForBoxModel
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = mBase.Width
	Dim targetH As Int = mBase.Height
	If mWidthExplicit = False Then targetW = Max(targetW, ResolveRequiredOuterWidth)
	If mHeightExplicit = False Then targetH = Max(targetH, ResolveRequiredOuterHeight)
	If targetW <> mBase.Width Or targetH <> mBase.Height Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
	End If
End Sub

Private Sub ResolveRequiredOuterWidth As Int
	Dim box As Map = BuildBoxModel
	Dim contentW As Float = Max(1dip, mWidth)
	Return Max(1dip, Ceil(B4XDaisyBoxModel.ExpandContentWidth(contentW, box)))
End Sub

Private Sub ResolveRequiredOuterHeight As Int
	Dim box As Map = BuildBoxModel
	Dim contentH As Float = Max(1dip, mHeight)
	Return Max(1dip, Ceil(B4XDaisyBoxModel.ExpandContentHeight(contentH, box)))
End Sub

Private Sub NormalizeAnimation(Value As String) As String
	If Value = Null Then Return "none"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "none", "pulse", "bounce"
			Return s
		Case Else
			Return "none"
	End Select
End Sub

Private Sub UpdateAnimationState
	If AnimTimer.IsInitialized = False Then Return
	Dim shouldRun As Boolean = mBase.IsInitialized And mVisible And (mAnimation <> "none")
	If shouldRun Then
		If AnimTimer.Enabled = False Then
			mAnimStartedAt = DateTime.Now
			AnimTimer.Enabled = True
		End If
		ApplyAnimationFrame(DateTime.Now)
	Else
		AnimTimer.Enabled = False
		ResetAnimationTransforms
	End If
End Sub

Private Sub animtimer_Tick
	ApplyAnimationFrame(DateTime.Now)
End Sub

Private Sub ApplyAnimationFrame(NowMs As Long)
	If DotHost.IsInitialized = False Then Return
	If mAnimation = "none" Then
		ResetAnimationTransforms
		Return
	End If
	If mAnimStartedAt <= 0 Then mAnimStartedAt = NowMs
	Dim elapsed As Long = Max(0, NowMs - mAnimStartedAt)

	Select Case mAnimation
		Case "pulse"
			' Tailwind-like ping: scale up while fading out.
			Dim phase As Float = (elapsed Mod 1000) / 1000
			Dim scaleValue As Float = 1 + (phase * 1.25)
			Dim alphaValue As Float = Max(0, 1 - phase)
			SetNativeAlpha(DotHost, alphaValue)
			SetNativeScale(DotHost, scaleValue, scaleValue)
			SetNativeTranslationY(DotHost, 0)
		Case "bounce"
			' Softer/slower bounce than the default utility feel.
			Dim phaseB As Float = (elapsed Mod 1400) / 1400
			Dim amp As Float = Max(1dip, DotHost.Height * 0.16)
			Dim wave As Float = Abs(Sin(phaseB * cPI * 2))
			Dim yOffset As Float = -(wave * wave) * amp
			SetNativeAlpha(DotHost, 1)
			SetNativeScale(DotHost, 1, 1)
			SetNativeTranslationY(DotHost, yOffset)
		Case Else
			ResetAnimationTransforms
	End Select
End Sub

Private Sub ResetAnimationTransforms
	If DotHost.IsInitialized = False Then Return
	SetNativeAlpha(DotHost, 1)
	SetNativeScale(DotHost, 1, 1)
	SetNativeTranslationY(DotHost, 0)
End Sub

Private Sub SetNativeScale(v As B4XView, sx As Float, sy As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setScaleX", Array As Object(sx))
	jo.RunMethod("setScaleY", Array As Object(sy))
	#Else
	Dim ignore As Object = v
	Dim ignoreX As Float = sx
	Dim ignoreY As Float = sy
	#End If
End Sub

Private Sub SetNativeAlpha(v As B4XView, alphaValue As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setAlpha", Array As Object(alphaValue))
	#Else
	Dim ignore As Object = v
	Dim ignoreAlpha As Float = alphaValue
	#End If
End Sub

Private Sub SetNativeTranslationY(v As B4XView, yOffset As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setTranslationY", Array As Object(yOffset))
	#Else
	Dim ignore As Object = v
	Dim ignoreY As Float = yOffset
	#End If
End Sub

Private Sub DisableClipping(v As B4XView)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setClipChildren", Array(False))
	jo.RunMethod("setClipToPadding", Array(False))
	#Else
	Dim ignore As Object = v
	#End If
End Sub



Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
