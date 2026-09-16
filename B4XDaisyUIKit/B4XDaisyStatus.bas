B4A=true
Group=Default Group\DaisyUIKit
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
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: When False, touch events pass through to parent (useful inside clickable list rows)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override text color.
#DesignerProperty: Key: Depth, DisplayName: Depth, FieldType: Float, DefaultValue: -1, Description: Three-dimensional shadow depth.

#IgnoreWarnings:12
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
	Private mClickable As Boolean = True
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	If AnimTimer.IsInitialized = False Then
		AnimTimer.Initialize("animtimer", 33)
		AnimTimer.Enabled = False
	End If
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)
	B4XDaisyVariants.DisableClipping(mBase)
	B4XDaisyVariants.DisableClipping(Surface)

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

	ApplyDesignerProps(mProps)
	' Apply clickable state to native views
	If mClickable = False Then
		#If B4A
		Dim joClickable As JavaObject = mBase
		joClickable.RunMethod("setClickable", Array(False))
		If Surface.IsInitialized Then
			Dim joS As JavaObject = Surface
			joS.RunMethod("setClickable", Array(False))
		End If
		#Else If B4J
		mBase.Enabled = False
		If Surface.IsInitialized Then Surface.Enabled = False
		#Else If B4i
		mBase.Enabled = False
		If Surface.IsInitialized Then Surface.Enabled = False
		#End If
	End If
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
	UpdateAnimationState
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mAnimation = B4XDaisyVariants.NormalizeAnimation(B4XDaisyVariants.GetPropString(mProps, "Animation", mAnimation))
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)

	mWidthExplicit = IsExplicitSizeProp(mProps, "Width")
	mHeightExplicit = IsExplicitSizeProp(mProps, "Height")
	
	Dim sz As Map = ResolveSizeSpec
	Dim defSize As Float = sz.GetDefault("size", 8dip)
	
	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", ""))
	mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", ""))
	
	If mWidthExplicit = False Then mWidth = defSize
	If mHeightExplicit = False Then mHeight = defSize
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mDepth = B4XDaisyVariants.GetPropFloat(mProps, "Depth", mDepth)
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







Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)

	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, w, h)

	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)

	Dim contentRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutStatusDot(contentRect)
	ApplyAnimationFrame(DateTime.Now)
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	B4XDaisyVariants.DisableClipping(vParent)

	Dim autoW As Boolean = (iWidth <= 0)
	Dim autoH As Boolean = (iHeight <= 0)
	Dim w As Int = iWidth
	Dim h As Int = iHeight
	If w <= 0 Then w = ResolveRequiredOuterWidth
	If h <= 0 Then h = ResolveRequiredOuterHeight

	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)

	Dim props As Map = BuildRuntimeProps(w, h)

	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	EnsureHostSizeForBoxModel
	Dim finalLeft As Int = iLeft
	Dim finalTop As Int = iTop
	If autoW And vParent.Width > 0 Then finalLeft = iLeft + (vParent.Width - mBase.Width) / 2
	If autoH And vParent.Height > 0 Then finalTop = iTop + (vParent.Height - mBase.Height) / 2
	vParent.AddView(mBase, finalLeft, finalTop, mBase.Width, mBase.Height)
	Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	' Preserve runtime settings when recreating through DesignerCreateView.
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(iWidth))
	props.Put("Height", ResolvePxSizeSpec(iHeight))
	props.Put("Size", mSize)
	props.Put("Variant", mVariant)
	props.Put("Animation", mAnimation)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("Visible", mVisible)
	props.Put("TextColor", mTextColor)
	props.Put("BackgroundColor", mBackgroundColor)
	Return props
End Sub

Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Return AddToParent(vParent, iLeft, iTop, iWidth, iHeight)
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
Public Sub CenterInParent(vParent As B4XView)
	If mBase.IsInitialized = False Then Return
	Dim host As B4XView
	If vParent.IsInitialized Then
		host = vParent
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

Private Sub ApplySpacingSpecToBox(mBox As Map, sPaddingSpec As String, sMarginSpec As String)
	Dim rtl As Boolean = False
	Dim p As String = IIf(sPaddingSpec = Null, "", sPaddingSpec.Trim)
	Dim m As String = IIf(sMarginSpec = Null, "", sMarginSpec.Trim)
	If p.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(p, Array As String("p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-")) Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(mBox, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			mBox.Put("padding_left", pv)
			mBox.Put("padding_right", pv)
			mBox.Put("padding_top", pv)
			mBox.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
			B4XDaisyBoxModel.ApplyMarginUtilities(mBox, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			mBox.Put("margin_left", mv)
			mBox.Put("margin_right", mv)
			mBox.Put("margin_top", mv)
			mBox.Put("margin_bottom", mv)
		End If
	End If
End Sub

Private Sub ResolveContentLocalRect(rcOuterRect As B4XRect, mBox As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(rcOuterRect, mBox)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, mBox)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, rcOuterRect)
End Sub

Private Sub LayoutStatusDot(rcContentRect As B4XRect)
	Dim side As Int = Max(1dip, Min(rcContentRect.Width, rcContentRect.Height))
	Dim dotX As Int = rcContentRect.Left + (rcContentRect.Width - side) / 2
	Dim dotY As Int = rcContentRect.Top + (rcContentRect.Height - side) / 2
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

Private Sub LayoutShadow(iSide As Int, iDotLeft As Int, iDotTop As Int, iBackColor As Int)
	If ShadowHost.IsInitialized = False Then Return
	Dim shadowSide As Int = Max(iSide + 2dip, iSide * 1.3)
	Dim left As Int = iDotLeft - (shadowSide - iSide) / 2
	Dim top As Int = iDotTop - (shadowSide - iSide) / 2
	Dim depth As Float = ResolveDepth
	Dim alpha01 As Float = 0.18 + Min(0.16, depth * 0.08)
	Dim softColor As Int = B4XDaisyVariants.AlphaColor(B4XDaisyVariants.Blend(iBackColor, xui.Color_Black, 0.15), alpha01)
	ShadowHost.Visible = True
	ShadowHost.SetLayoutAnimated(0, left, top, shadowSide, shadowSide)
	ShadowHost.SetColorAndBorder(softColor, 0dip, xui.Color_Transparent, shadowSide / 2)
End Sub

Private Sub LayoutRing(iSide As Int, iBackColor As Int)
	If RingHost.IsInitialized = False Then Return
	Dim ringStroke As Int = 1dip
	Dim ringColor As Int = B4XDaisyVariants.AlphaColor(B4XDaisyVariants.Blend(iBackColor, xui.Color_White, 0.35), 0.45)
	RingHost.Visible = True
	RingHost.SetLayoutAnimated(0, 0, 0, iSide, iSide)
	RingHost.SetColorAndBorder(xui.Color_Transparent, ringStroke, ringColor, iSide / 2)
End Sub

Private Sub LayoutHighlight(iSide As Int)
	Dim depth As Float = ResolveDepth
	Dim alpha01 As Float = 0.20
	If depth > 0 Then alpha01 = Min(0.55, 0.20 + (depth * 0.20))
	If alpha01 <= 0 Then
		HighlightHost.Visible = False
		HighlightHost.SetLayoutAnimated(0, 0, 0, 0, 0)
		Return
	End If

	Dim glowSize As Int = Max(1dip, iSide * 0.62)
	Dim cx As Float = iSide * 0.35
	Dim cy As Float = iSide * 0.30
	Dim left As Int = Round(cx - glowSize / 2)
	Dim top As Int = Round(cy - glowSize / 2)
	HighlightHost.Visible = True
	HighlightHost.SetLayoutAnimated(0, left, top, glowSize, glowSize)
	HighlightHost.SetColorAndBorder(B4XDaisyVariants.AlphaColor(xui.Color_White, alpha01), 0dip, xui.Color_Transparent, glowSize / 2)
End Sub

Private Sub ApplyDotFill(iBackColor As Int, fRadius As Float)
	#If B4A
	Try
		Dim topColor As Int = B4XDaisyVariants.Blend(iBackColor, xui.Color_White, 0.22)
		Dim bottomColor As Int = B4XDaisyVariants.Blend(iBackColor, xui.Color_Black, 0.10)
		Dim orientation As JavaObject
		orientation.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(1)) ' OVAL
		gd.RunMethod("setOrientation", Array(orientation.GetField("TL_BR")))
		Dim midColor As Int = B4XDaisyVariants.Blend(iBackColor, topColor, 0.35)
		Dim gradientColors() As Int = Array As Int(topColor, midColor, bottomColor)
		gd.RunMethod("setColors", Array(gradientColors))
		SetNativeBackground(DotHost, gd)
	Catch
		DotHost.SetColorAndBorder(iBackColor, 0dip, xui.Color_Transparent, fRadius)
	End Try
	#Else
	DotHost.SetColorAndBorder(iBackColor, 0dip, xui.Color_Transparent, fRadius)
	#End If
End Sub

Private Sub ResolveVisualColors As Map
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette

	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(63, 64, 77))
	Dim defaultBack As Int = B4XDaisyVariants.AlphaColor(baseContent, 0.2)
	Dim defaultText As Int = B4XDaisyVariants.AlphaColor(xui.Color_Black, 0.3)

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

Private Sub ApplyDepthShadow(iShadowColor As Int)
	Dim depth As Float = ResolveDepth
	#If B4A
	Dim p As Panel = DotHost
	Dim effectiveDepth As Float = Max(0.35, depth)
	p.Elevation = Max(0, effectiveDepth * 2dip)
'	Dim ignoreShadow As Int = iShadowColor
	#Else
	Dim ignoreView As B4XView = DotHost
	Dim ignoreDepth As Float = depth
	Dim ignoreShadow As Int = iShadowColor
	#End If
End Sub

Private Sub ResolveDepth As Float
	If mDepth >= 0 Then Return mDepth
	Return Max(0, B4XDaisyVariants.GetTokenNumber("--depth", 0))
End Sub

Private Sub ResolveSizeSpec As Map
	Select Case B4XDaisyVariants.NormalizeSize(mSize)
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



Private Sub ResolveSelectorRadius As Float
	' Status is always rounded-full.
	Return 9999dip
End Sub

#If B4A
Private Sub SetNativeBackground(vTarget As B4XView, joDrawable As JavaObject)
	Dim jo As JavaObject = vTarget
	jo.RunMethod("setBackground", Array(joDrawable))
End Sub
#End If



Private Sub IsExplicitSizeProp(mProps As Map, sKey As String) As Boolean
	If mProps.IsInitialized = False Then Return False
	If mProps.ContainsKey(sKey) = False Then Return False
	Dim raw As Object = mProps.Get(sKey)
	If raw = Null Then Return False
	Dim s As String = raw
	s = s.Trim
	If s.Length = 0 Then Return False
	Return True
End Sub





Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
	UpdateAnimationState
End Sub

Public Sub setWidth(oValue As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Int = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, targetH)
	Base_Resize(mWidth, targetH)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(oValue As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mHeight)
	Base_Resize(targetW, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
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

Public Sub setAnimation(sValue As String)
	mAnimation = B4XDaisyVariants.NormalizeAnimation(sValue)
	If mBase.IsInitialized = False Then Return
	UpdateAnimationState
End Sub

Public Sub getAnimation As String
	Return mAnimation
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	' Reset manual overrides to ensure variant colors take full effect.
	mBackgroundColor = 0
	mTextColor = 0
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setPadding(sValue As String)
	mPadding = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	mMargin = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	UpdateAnimationState
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(sVariantName, mBackgroundColor)
	setBackgroundColor(c)
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(sVariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setDepth(fValue As Float)
	mDepth = Max(0, fValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDepth As Float
	Return mDepth
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
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

Private Sub ApplyAnimationFrame(lNowMs As Long)
	If DotHost.IsInitialized = False Then Return
	If mAnimation = "none" Then
		ResetAnimationTransforms
		Return
	End If
	If mAnimStartedAt <= 0 Then mAnimStartedAt = lNowMs
	Dim elapsed As Long = Max(0, lNowMs - mAnimStartedAt)

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

Private Sub SetNativeScale(vView As B4XView, fSx As Float, fSy As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setScaleX", Array As Object(fSx))
	jo.RunMethod("setScaleY", Array As Object(fSy))
	#Else
	Dim ignore As Object = vView
	Dim ignoreX As Float = fSx
	Dim ignoreY As Float = fSy
	#End If
End Sub

Private Sub SetNativeAlpha(vView As B4XView, fAlphaValue As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setAlpha", Array As Object(fAlphaValue))
	#Else
	Dim ignore As Object = vView
	Dim ignoreAlpha As Float = fAlphaValue
	#End If
End Sub

Private Sub SetNativeTranslationY(vView As B4XView, fYOffset As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setTranslationY", Array As Object(fYOffset))
	#Else
	Dim ignore As Object = vView
	Dim ignoreY As Float = fYOffset
	#End If
End Sub



Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' Sets whether the status indicator intercepts touch events.
''' When False, touches pass through to the parent view (e.g. a list row).
''' When True, the status indicator handles clicks normally.
Public Sub setClickable(bValue As Boolean)
	mClickable = bValue
	#If B4A
	If mBase.IsInitialized Then
		Dim joBase As JavaObject = mBase
		joBase.RunMethod("setClickable", Array(bValue))
		If Surface.IsInitialized Then
			Dim joS As JavaObject = Surface
			joS.RunMethod("setClickable", Array(bValue))
		End If
	End If
	#Else If B4J
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If Surface.IsInitialized Then Surface.Enabled = bValue
	End If
	#Else If B4i
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If Surface.IsInitialized Then Surface.Enabled = bValue
	End If
	#End If
End Sub

''' Gets whether the status indicator is clickable.
Public Sub getClickable As Boolean
	Return mClickable
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
