B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)

#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: SVG icon asset file name.
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override icon color (0 = auto from variant).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: default, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Semantic color variant.
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost|link, Description: Daisy button style.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy button size token.
#DesignerProperty: Key: CustomSize, DisplayName: Custom Size, FieldType: Int, DefaultValue: 0, Description: Custom width/height in dip. When > 0, overrides the Size token.
#DesignerProperty: Key: Shape, DisplayName: Shape, FieldType: String, DefaultValue: square, List: square|circle, Description: Icon button shape (square uses Rounded for corners; circle is always rounded-full).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius for square shape. Ignored when Shape=circle.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind padding utility tokens.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind margin utility tokens.
#DesignerProperty: Key: Loading, DisplayName: Loading, FieldType: Boolean, DefaultValue: False, Description: Shows loading spinner and disables button.
#DesignerProperty: Key: Disabled, DisplayName: Disabled, FieldType: Boolean, DefaultValue: False, Description: Applies disabled behavior.
#DesignerProperty: Key: Active, DisplayName: Active, FieldType: Boolean, DefaultValue: False, Description: Applies btn-active behavior.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override border color.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide component.
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: When False, touch events pass through to parent.

#IgnoreWarnings:12,9

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private iconComp As B4XDaisySvgIcon
	Private iconView As B4XView
	Private loadingComp As B4XDaisyLoading
	Private loadingView As B4XView

	Private mIconAsset As String = ""
	Private mIconColor As Int = xui.Color_Transparent
	Private mVariant As String = "default"
	Private mStyle As String = "solid"
	Private mSize As String = "md"
	Private mCustomSize As Int = 0
	Private mShape As String = "square"
	Private mRounded As String = "theme"
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mLoading As Boolean = False
	Private mDisabled As Boolean = False
	Private mActive As Boolean = False
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mBorderColor As Int = xui.Color_Transparent
	Private mVisible As Boolean = True
	Private mClickable As Boolean = True
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me

	Dim icon As B4XDaisySvgIcon
	icon.Initialize(Me, "ibicon")
	iconComp = icon
	iconView = iconComp.AddToParent(mBase, 0, 0, 1dip, 1dip)
	iconComp.Clickable = False
	iconView.Visible = False

	Dim ld As B4XDaisyLoading
	ld.Initialize(Me, "ibloading")
	loadingComp = ld
	loadingView = loadingComp.AddToParent(mBase, 0, 0, 1dip, 1dip)
	loadingComp.Clickable = False
	loadingView.Visible = False

	ApplyDesignerProps(mProps)

	' Apply clickable state
	#If B4A
	If mClickable = False Then
		Dim joClickable As JavaObject = mBase
		joClickable.RunMethod("setClickable", Array(False))
	Else
		Dim joClickable As JavaObject = mBase
		joClickable.RunMethod("setClickable", Array(True))
	End If
	#Else If B4J
	mBase.Enabled = mClickable
	#Else If B4i
	mBase.Enabled = mClickable
	#End If

	Refresh
End Sub

Public Sub CreateView(iSizeDip As Int) As B4XView
	If iSizeDip <= 0 Then iSizeDip = ResolveButtonSizeDip
	Dim w As Int = iSizeDip
	Dim h As Int = iSizeDip
	Dim p As Panel
	p.Initialize("mBase")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim dummy As Label
	dummy.Initialize("")
	DesignerCreateView(b, dummy, BuildRuntimeProps)
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		DesignerCreateView(p, Null, BuildRuntimeProps)
	End If

	Dim controlSize As Int = ResolveButtonSizeDip
	Dim mg As Map = ResolveMargin
	iLeft = iLeft + mg.Get("l")
	iTop = iTop + mg.Get("t")
	Dim w As Int = iWidth - mg.Get("l") - mg.Get("r")
	Dim h As Int = iHeight - mg.Get("t") - mg.Get("b")
	If w <= 0 Then w = controlSize
	If h <= 0 Then h = controlSize
	w = Max(w, controlSize)
	h = Max(h, controlSize)

	vParent.AddView(mBase, iLeft, iTop, w, h)
	Base_Resize(mBase.Width, mBase.Height)
	Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
	Return CreateMap( _
	"IconAsset": mIconAsset, _
	"IconColor": mIconColor, _
	"Variant": mVariant, _
	"Style": mStyle, _
	"Size": mSize, _
	"CustomSize": mCustomSize, _
	"Shape": mShape, _
	"Rounded": mRounded, _
	"Padding": mPadding, _
	"Margin": mMargin, _
	"Loading": mLoading, _
	"Disabled": mDisabled, _
	"Active": mActive, _
	"BackgroundColor": mBackgroundColor, _
	"BorderColor": mBorderColor, _
	"Visible": mVisible, _
	"Clickable": mClickable)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mIconAsset = B4XDaisyVariants.GetPropString(mProps, "IconAsset", mIconAsset)
	mIconColor = B4XDaisyVariants.GetPropColor(mProps, "IconColor", mIconColor)
	mVariant = NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "Style", mStyle))
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mCustomSize = B4XDaisyVariants.GetPropInt(mProps, "CustomSize", mCustomSize)
	mShape = NormalizeShape(B4XDaisyVariants.GetPropString(mProps, "Shape", mShape))
	mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mLoading = B4XDaisyVariants.GetPropBool(mProps, "Loading", mLoading)
	mDisabled = B4XDaisyVariants.GetPropBool(mProps, "Disabled", mDisabled)
	mActive = B4XDaisyVariants.GetPropBool(mProps, "Active", mActive)
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mBorderColor)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return

	If inResize Then Return
	inResize = True
	Dim controlSize As Int = ResolveButtonSizeDip
	Dim targetW As Int = Max(controlSize, Max(1dip, dWidth))
	Dim targetH As Int = Max(controlSize, Max(1dip, dHeight))
	Dim targetLeft As Int = mBase.Left
	Dim mg As Map = ResolveMargin

	' Shape enforces equal dimensions
	targetW = controlSize
	targetH = controlSize

	If targetW <> dWidth Or targetH <> dHeight Or targetLeft <> mBase.Left Then
		mBase.SetLayoutAnimated(0, targetLeft, mBase.Top, targetW, targetH)
		dWidth = targetW
		dHeight = targetH
	End If

	Dim p As Map = ResolvePadding
	Dim pl As Int = p.Get("l")
	Dim pt As Int = p.Get("t")
	Dim pr As Int = p.Get("r")
	Dim pb As Int = p.Get("b")

	Dim contentW As Int = Max(1dip, dWidth - pl - pr)
	Dim contentH As Int = Max(1dip, dHeight - pt - pb)

	Dim indicatorW As Int = Max(12dip, ResolveIconSizeDip)

	If mLoading Then
		loadingView.Visible = True
		iconView.Visible = False
		' Size loading view to fill the content area so the spinner has room
		loadingView.SetLayoutAnimated(0, pl, pt, contentW, contentH)
		iconView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
		If loadingComp.IsInitialized Then
			loadingComp.setSize(mSize)
			loadingComp.Base_Resize(loadingView.Width, loadingView.Height)
		End If
		B4XDaisyVariants.DisableClipping(loadingView)
	Else If mIconAsset.Trim.Length > 0 Then
		loadingView.Visible = False
		iconView.Visible = True
		iconView.SetLayoutAnimated(0, pl + (contentW - indicatorW) / 2, pt + (contentH - indicatorW) / 2, indicatorW, indicatorW)
		If iconComp.IsInitialized Then
			iconComp.setWidth(iconView.Width)
			iconComp.setHeight(iconView.Height)
			iconComp.ResizeToParent(iconView)
		End If
		loadingView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	Else
		loadingView.Visible = False
		iconView.Visible = False
		loadingView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
		iconView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	End If

	' Force background drawable bounds for shadow rendering
	#If B4A
	If mBase.Width > 0 And mBase.Height > 0 Then
		Try
			Dim joMB As JavaObject = mBase
			Dim bgDraw As JavaObject = joMB.RunMethod("getBackground", Null)
			If bgDraw.IsInitialized Then
				bgDraw.RunMethod("setBounds", Array(0, 0, mBase.Width, mBase.Height))
				joMB.RunMethod("invalidateOutline", Null)
			End If
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyIconButton.Base_Resize: " & LastException.Message)
		End Try
	End If
	#End If
	inResize = False
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return

	Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	Dim base100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
	Dim base200 As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(229, 231, 235))
	Dim primaryBack As Int = B4XDaisyVariants.ResolveBackgroundColorVariant("primary", xui.Color_RGB(59, 130, 246))

	Dim variantBack As Int = ResolveVariantBackColor(base200)
	Dim variantText As Int = ResolveVariantTextColor(baseContent)

	Dim bg As Int = variantBack
	Dim fg As Int = variantText
	Dim br As Int = B4XDaisyVariants.Blend(bg, xui.Color_Black, 0.10)

	Select Case B4XDaisyVariants.NormalizeStyle(mStyle)
		Case "soft"
			bg = B4XDaisyVariants.Blend(base100, variantBack, 0.08)
			br = B4XDaisyVariants.Blend(base100, variantBack, 0.10)
			If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
				fg = baseContent
			Else
				fg = variantBack
			End If
		Case "outline", "dash"
			bg = xui.Color_Transparent
			br = ResolveOutlineColor(baseContent, variantBack)
			fg = br
		Case "ghost"
			bg = xui.Color_Transparent
			br = xui.Color_Transparent
			fg = ResolveOutlineColor(baseContent, variantBack)
		Case "link"
			bg = xui.Color_Transparent
			br = xui.Color_Transparent
			If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
				fg = primaryBack
			Else
				fg = variantBack
			End If
		Case Else
			' solid default
	End Select

	If NormalizeVariant(mVariant) = "warning" And B4XDaisyVariants.NormalizeStyle(mStyle) = "solid" Then
		fg = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	End If

	If mActive And bg <> xui.Color_Transparent Then
		bg = B4XDaisyVariants.Blend(bg, xui.Color_Black, 0.07)
		br = B4XDaisyVariants.Blend(br, xui.Color_Black, 0.07)
	End If

	If mDisabled Then
		Dim faded As Int = ToAlphaColor(baseContent, 51)
		fg = faded
		If B4XDaisyVariants.NormalizeStyle(mStyle) <> "ghost" And B4XDaisyVariants.NormalizeStyle(mStyle) <> "link" Then
			bg = ToAlphaColor(baseContent, 26)
			br = xui.Color_Transparent
		Else
			bg = xui.Color_Transparent
			br = xui.Color_Transparent
		End If
		mBase.Enabled = False
	Else
		mBase.Enabled = True
	End If

	If mBackgroundColor <> xui.Color_Transparent Then bg = mBackgroundColor
	If mBorderColor <> xui.Color_Transparent Then br = mBorderColor

	' Icon
	If iconComp.IsInitialized Then
		If mIconAsset.Trim.Length > 0 Then
			Dim preserveIconColors As Boolean = IsTransparentColor(mIconColor)
			iconComp.setSvgAsset(mIconAsset)
			iconComp.setPreserveOriginalColors(preserveIconColors)
			iconComp.setColor(IIf(preserveIconColors, fg, mIconColor))
			iconComp.setRoundedBox(False)
		End If
	End If

	' Loading spinner - configure properties; layout is finalized in Base_Resize
	If loadingComp.IsInitialized Then
		loadingComp.setStyle("spinner")
		loadingComp.setSize(mSize)
		loadingComp.setColor(fg)
		loadingComp.setVisible(mLoading)
	End If

	' Border radius: circle always forces rounded-full
	Dim radius As Int = ResolveRadiusDip(IIf(mShape.ToLowerCase = "circle", "rounded-full", mRounded))

	Dim borderW As Int = ResolveBorderDip
	Select Case B4XDaisyVariants.NormalizeStyle(mStyle)
		Case "ghost", "link"
			If mBorderColor <> xui.Color_Transparent Then
				borderW = Max(1dip, borderW)
			Else
				borderW = 0
			End If
		Case "dash"
			borderW = Max(2dip, borderW)
		Case "outline"
			borderW = Max(1dip, borderW)
		Case Else
			' solid / soft ? keep resolved border width
	End Select

	' Apply background, border and radius
	If B4XDaisyVariants.NormalizeStyle(mStyle) = "dash" Then
		B4XDaisyVariants.ApplyDashedBorder(mBase, bg, borderW, br, radius, "dashed")
	Else
		mBase.SetColorAndBorder(bg, borderW, br, radius)
	End If

	B4XDaisyVariants.ApplyElevation(mBase, "xs")
	B4XDaisyVariants.DisableClipping(mBase)

	EnsureShadowVisibility
	Base_Resize(mBase.Width, mBase.Height)
End Sub

' - Color Resolution -

Private Sub ResolveVariantBackColor(iFallback As Int) As Int
	If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
		Return B4XDaisyVariants.GetTokenColor("--color-base-200", iFallback)
	End If
	Return B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, iFallback)
End Sub

Private Sub ResolveVariantTextColor(iFallback As Int) As Int
	If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
		Return iFallback
	End If
	Return B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, mVariant, iFallback)
End Sub

Private Sub ResolveOutlineColor(iBaseContent As Int, iVariantBack As Int) As Int
	If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
		Return B4XDaisyVariants.Blend(iBaseContent, xui.Color_White, 0.25)
	End If
	Return iVariantBack
End Sub

' - Size Resolution -

Private Sub ResolveButtonSizeDip As Int
	If mCustomSize > 0 Then Return mCustomSize * 1dip
	Select Case B4XDaisyVariants.NormalizeSize(mSize)
		Case "xs"
			Return 24dip
		Case "sm"
			Return 32dip
		Case "md"
			Return 40dip
		Case "lg"
			Return 48dip
		Case "xl"
			Return 56dip
		Case Else
			Return 40dip
	End Select
End Sub

Private Sub ResolveIconSizeDip As Int
	If mCustomSize > 0 Then
		Dim scaled As Int = Round(mCustomSize * 0.4) * 1dip
		Return Max(12dip, scaled)
	End If
	Select Case B4XDaisyVariants.NormalizeSize(mSize)
		Case "xs"
			Return 12dip
		Case "sm"
			Return 14dip
		Case "md"
			Return 16dip
		Case "lg"
			Return 18dip
		Case "xl"
			Return 20dip
		Case Else
			Return 16dip
	End Select
End Sub

Private Sub ResolveBorderDip As Int
	Return Max(0dip, B4XDaisyVariants.GetBorderDip(1dip))
End Sub

Private Sub ResolveRadiusDip(sRoundedToken As String) As Int
	Dim s As String = IIf(sRoundedToken = Null, "theme", sRoundedToken.ToLowerCase.Trim)
	Select Case s
		Case "theme", ""
			Return Max(0dip, B4XDaisyVariants.GetRadiusFieldDip(8dip))
		Case Else
			Return Max(0dip, B4XDaisyVariants.TailwindBorderRadiusToDip(s, B4XDaisyVariants.GetRadiusFieldDip(8dip)))
	End Select
End Sub

Private Sub ResolvePadding As Map
	Dim defaultPad As Int = 4dip
	Dim left As Int = defaultPad
	Dim top As Int = defaultPad
	Dim right As Int = defaultPad
	Dim bottom As Int = defaultPad

	If mPadding.Trim.Length > 0 Then
		Dim tokens() As String = Regex.Split("\s+", mPadding.Trim)
		For Each tok As String In tokens
			Dim t As String = tok.ToLowerCase.Trim
			If t.Length = 0 Then Continue
			If t.StartsWith("p-") Then
				Dim v As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(2), 0)
				left = v : right = v : top = v : bottom = v
			Else If t.StartsWith("px-") Then
				Dim v2 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
				left = v2 : right = v2
			Else If t.StartsWith("py-") Then
				Dim v3 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
				top = v3 : bottom = v3
			End If
		Next
	End If

	Return CreateMap("l": Max(0dip, left), "t": Max(0dip, top), "r": Max(0dip, right), "b": Max(0dip, bottom))
End Sub

Private Sub ResolveMargin As Map
	Dim left As Int = 0dip
	Dim top As Int = 0dip
	Dim right As Int = 0dip
	Dim bottom As Int = 0dip

	If mMargin.Trim.Length > 0 Then
		Dim tokens() As String = Regex.Split("\s+", mMargin.Trim)
		For Each tok As String In tokens
			Dim t As String = tok.ToLowerCase.Trim
			If t.Length = 0 Then Continue
			If t.StartsWith("m-") Then
				Dim v As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(2), 0)
				left = v : right = v : top = v : bottom = v
			Else If t.StartsWith("mx-") Then
				Dim v2 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
				left = v2 : right = v2
			Else If t.StartsWith("my-") Then
				Dim v3 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
				top = v3 : bottom = v3
			Else If t.StartsWith("mt-") Then
				top = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
			Else If t.StartsWith("mr-") Then
				right = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), right)
			Else If t.StartsWith("mb-") Then
				bottom = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), bottom)
			Else If t.StartsWith("ml-") Then
				left = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
			End If
		Next
	End If

	Return CreateMap("l": Max(0dip, left), "t": Max(0dip, top), "r": Max(0dip, right), "b": Max(0dip, bottom))
End Sub

Private Sub NormalizeVariant(sValue As String) As String
	If sValue = Null Then Return "default"
	Dim v As String = sValue.ToLowerCase.Trim
	If v.StartsWith("btn-") Then v = v.Replace("btn-", "")
	Select Case v
		Case "default", "none", "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
			Return v
		Case Else
			Return "default"
	End Select
End Sub

Private Sub NormalizeShape(sValue As String) As String
	If sValue = Null Then Return "square"
	Dim s As String = sValue.ToLowerCase.Trim
	If s = "circle" Then Return "circle"
	Return "square"
End Sub

Private Sub IsTransparentColor(iValue As Int) As Boolean
	Return Bit.And(Bit.ShiftRight(iValue, 24), 0xFF) = 0
End Sub

Private Sub ToAlphaColor(iBase As Int, iAlpha As Int) As Int
	Dim a As Int = Bit.ShiftLeft(iAlpha, 24)
	Dim rgb As Int = Bit.And(iBase, 0x00FFFFFF)
	Return Bit.Or(a, rgb)
End Sub

Private Sub EnsureShadowVisibility
	B4XDaisyVariants.DisableClippingChain(mBase, 4)
End Sub

' - Public API -

Public Sub setIconAsset(sValue As String)
	mIconAsset = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconAsset As String
	Return mIconAsset
End Sub

Public Sub setIconColor(iValue As Int)
	mIconColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconColor As Int
	Return mIconColor
End Sub

Public Sub setVariant(sValue As String)
	mVariant = NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setStyle(sValue As String)
	mStyle = B4XDaisyVariants.NormalizeStyle(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getStyle As String
	Return mStyle
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setCustomSize(iValue As Int)
	mCustomSize = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCustomSize As Int
	Return mCustomSize
End Sub

Public Sub setShape(sValue As String)
	mShape = NormalizeShape(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShape As String
	Return mShape
End Sub

Public Sub setRounded(sValue As String)
	mRounded = IIf(sValue = Null, "theme", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
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
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setLoading(bValue As Boolean)
	mLoading = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getLoading As Boolean
	Return mLoading
End Sub

Public Sub setDisabled(bValue As Boolean)
	mDisabled = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDisabled As Boolean
	Return mDisabled
End Sub

Public Sub setActive(bValue As Boolean)
	mActive = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getActive As Boolean
	Return mActive
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setBorderColor(iValue As Int)
	mBorderColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setClickable(bValue As Boolean)
	mClickable = bValue
	#If B4A
	If mBase.IsInitialized Then
		Dim joBase As JavaObject = mBase
		joBase.RunMethod("setClickable", Array(bValue))
	End If
	#Else If B4J
	If mBase.IsInitialized Then mBase.Enabled = bValue
	#Else If B4i
	If mBase.IsInitialized Then mBase.Enabled = bValue
	#End If
End Sub

Public Sub getClickable As Boolean
	Return mClickable
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub GetComputedWidth As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Width
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Release
	If loadingComp.IsInitialized Then
		loadingComp.StopAnimation
	End If
	If iconComp.IsInitialized Then
		iconComp.RemoveViewFromParent
	End If
	If loadingComp.IsInitialized Then
		loadingComp.RemoveViewFromParent
	End If
	mCallBack = Null
End Sub

Private Sub ibicon_Click(oTag As Object)
	' Icon click is not forwarded; the button itself handles clicks via mBase_Click
End Sub

Private Sub ibloading_Click(oTag As Object)
	' Loading spinner click is not forwarded; the button itself handles clicks via mBase_Click
End Sub

Private Sub mBase_Click
	If mClickable = False Then Return
	If mDisabled Then Return
	If mLoading Then Return
	Dim payload As Object = mTag
	If payload = Null Then payload = mBase
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", payload)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

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

#End Region
