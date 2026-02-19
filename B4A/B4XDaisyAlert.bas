B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)
#Event: ActionClick (Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 20rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 12, Description: Tailwind size token or CSS size (eg 12, 80px, 5rem)
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|info|success|warning|error|primary|secondary|accent|neutral, Description: Daisy variant used for alert colors
#DesignerProperty: Key: AlertStyle, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash, Description: Alert visual style
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Horizontal or vertical layout
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue:, Description: Optional title text
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: 12 unread messages. Tap to see., Description: Main alert message
#DesignerProperty: Key: Description, DisplayName: Description, FieldType: String, DefaultValue:, Description: Optional secondary description
#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: SVG file name from assets (empty uses variant default icon)
#DesignerProperty: Key: IconSize, DisplayName: Icon Size, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size for icon
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Use rounded corners similar to Daisy rounded-box
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 1, Description: Border width in dip
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level
#DesignerProperty: Key: ActionSpacing, DisplayName: Action Spacing, FieldType: Int, DefaultValue: 6, Description: Spacing in dip between action views

Sub Class_Globals
	' Core cross-platform helper and base references.
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' Public-facing runtime properties mirrored by getters/setters.
	Private mWidth As Float = 100%x
	Private mHeight As Float = 48dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mVariant As String = "none"
	Private mStyle As String = "solid"
	Private mDirection As String = "horizontal"
	Private mTitle As String = ""
	Private mText As String = "12 unread messages. Tap to see."
	Private mDescription As String = ""
	Private mRoundedBox As Boolean = True
	Private mIconVisible As Boolean = True
	Private mIconAsset As String = ""
	Private mIconSize As Float = 24dip
	Private mBorderWidth As Float = 1dip
	Private mActionSpacing As Float = 6dip
	Private mShadow As String = "none"
	Private mIconColorOverride As Int = 0
	Private mBackgroundColorOverride As Int = 0
	Private mTextColorOverride As Int = 0
	Private mBorderColorOverride As Int = 0

	' Active and default variant palettes used to resolve visual colors.
	Private VariantPalette As Map
	Private DefaultVariantPalette As Map
	Private UsingCustomVariantPalette As Boolean = False
	Private BorderWidthFromTheme As Boolean = True

	' Internal view tree references.
	Private Surface As B4XView
	Private TextHost As B4XView
	Private ActionsHost As B4XView
	Private lblTitle As B4XView
	Private lblText As B4XView
	Private lblDescription As B4XView
	Private IconComp As B4XDaisySvgIcon
	Private IconView As B4XView

	' Internal spacing/layout tokens in dip.
	Private ContentPaddingH As Float = 16dip
	Private ContentPaddingV As Float = 12dip
	Private ContentGap As Float = 8dip
	Private TextGap As Float = 2dip
	Private tu As StringUtils
	' Detached copy of designer/runtime properties.
	Private CustProps As Map
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	' Store callback/event contract and load default palette/property state.
	mCallBack = Callback
	mEventName = EventName
	InitializePalette
	SetDefaults
End Sub

'Public Sub CreateView(Width As Int, Height As Int) As B4XView
'	' Programmatic creation path that mirrors DesignerCreateView usage.
'	Dim p As Panel
'	p.Initialize("")
'	Dim b As B4XView = p
'	b.Color = xui.Color_Transparent
'	b.SetLayoutAnimated(0, 0, 0, Width, Height)
'	Dim dummy As Label
'	DesignerCreateView(b, dummy, CreateMap())
'	mWidth = Width
'	mHeight = Height
'	Return mBase
'End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	' Build visual hierarchy once, then apply properties and first layout pass.
	mBase = Base
	mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("surface")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	Dim ic As B4XDaisySvgIcon
	ic.Initialize(Me, "icon")
	IconComp = ic
	IconView = IconComp.AddToParent(Surface, 0, 0, 24dip, 24dip)

	Dim pText As Panel
	pText.Initialize("surface")
	TextHost = pText
	TextHost.Color = xui.Color_Transparent
	Surface.AddView(TextHost, 0, 0, 10dip, 10dip)

	Dim tmTitle As Map = B4XDaisyVariants.TailwindTextMetrics("text-sm", 14, 20)
	Dim tmBody As Map = B4XDaisyVariants.TailwindTextMetrics("text-sm", 14, 20)
	Dim tmDesc As Map = B4XDaisyVariants.TailwindTextMetrics("text-xs", 12, 16)
	lblTitle = CreateLabel("surface", tmTitle.GetDefault("font_size", 14), True)
	lblText = CreateLabel("surface", tmBody.GetDefault("font_size", 14), False)
	lblDescription = CreateLabel("surface", tmDesc.GetDefault("font_size", 12), False)
	TextHost.AddView(lblTitle, 0, 0, 1dip, 1dip)
	TextHost.AddView(lblText, 0, 0, 1dip, 1dip)
	TextHost.AddView(lblDescription, 0, 0, 1dip, 1dip)

	Dim pActions As Panel
	pActions.Initialize("surface")
	ActionsHost = pActions
	ActionsHost.Color = xui.Color_Transparent
	Surface.AddView(ActionsHost, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub CreateLabel(EventName As String, Size As Float, Bold As Boolean) As B4XView
	' Shared label factory used for title/body/description labels.
	Dim l As Label
	l.Initialize(EventName)
	l.SingleLine = False
	Dim v As B4XView = l
	v.Color = xui.Color_Transparent
	If Bold Then
		v.Font = xui.CreateDefaultBoldFont(Size)
	Else
		v.Font = xui.CreateDefaultFont(Size)
	End If
	Return v
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	' Read all supported properties from map into internal runtime fields.
	If CustProps.IsInitialized = False Then SetDefaults
	SetProperties(Props)
	Dim p As Map = Props
	If p.IsInitialized = False Then
		p.Initialize
	End If
	mWidthExplicit = p.ContainsKey("Width")
	mHeightExplicit = p.ContainsKey("Height")
	mWidth = Max(1dip, GetPropSizeDip(p, "Width", ResolveWidthBase(mWidth)))
	mHeight = Max(1dip, GetPropSizeDip(p, "Height", ResolveHeightBase(mHeight)))
	mVariant = NormalizeAlertVariant(GetPropString(p, "Variant", mVariant))
	mStyle = NormalizeStyle(GetPropString(p, "AlertStyle", mStyle))
	mDirection = NormalizeDirection(GetPropString(p, "Direction", mDirection))
	mTitle = GetPropString(p, "Title", mTitle)
	mText = GetPropString(p, "Text", mText)
	mDescription = GetPropString(p, "Description", mDescription)
	mRoundedBox = GetPropBool(p, "RoundedBox", mRoundedBox)
	mIconAsset = GetPropString(p, "IconAsset", mIconAsset).Trim
	If mIconAsset.Length > 0 Then mIconVisible = True
	mIconSize = Max(12dip, GetPropSizeDip(p, "IconSize", mIconSize))
	If p.ContainsKey("BorderWidth") Then
		mBorderWidth = Max(0, GetPropDip(p, "BorderWidth", mBorderWidth))
		BorderWidthFromTheme = False
	End If
	mActionSpacing = Max(0, GetPropDip(p, "ActionSpacing", mActionSpacing))
	mShadow = B4XDaisyVariants.NormalizeShadow(GetPropString(p, "Shadow", mShadow))
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	' Main layout entry point used by page resize and property refresh.
	If mBase.IsInitialized = False Then Return
	If Surface.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, w, h)
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
	ApplyVisualStyle(box)
	Dim contentLocalRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutContent(contentLocalRect)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	' Snapshot current properties, create view, and attach to parent bounds.
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim targetW As Int = Width
	Dim targetH As Int = Height
	If targetW <= 0 Then
		If Parent.Width > 0 Then
			targetW = Parent.Width
		Else
			targetW = mWidth
		End If
	End If
	If targetH <= 0 Then
		targetH = mHeight
	End If
	Dim w As Int = Max(1dip, targetW)
	Dim h As Int = Max(1dip, targetH)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim snap As Map = GetProperties
	Dim props As Map
	props.Initialize
	For Each k As String In snap.Keys
		props.Put(k, snap.Get(k))
	Next
	If mWidthExplicit = False Then props.Put("Width", ResolvePxSizeSpec(w))
	If mHeightExplicit = False Then props.Put("Height", ResolvePxSizeSpec(h))
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Parent.AddView(mBase, Left, Top, w, h)
	Return mBase
End Sub

Public Sub View As B4XView
	' Safe accessor for root component view.
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	' Allow callers to append arbitrary action/content views at runtime.
	If ActionsHost.IsInitialized = False Then Return
	If ChildView.IsInitialized = False Then Return
	ChildView.RemoveViewFromParent
	ActionsHost.AddView(ChildView, Left, Top, Max(1dip, Width), Max(1dip, Height))
	Refresh
End Sub

Public Sub ClearActions
	' Remove all dynamic action children from actions container.
	If ActionsHost.IsInitialized = False Then Return
	ActionsHost.RemoveAllViews
	Refresh
End Sub

Public Sub GetContentPanel As B4XView
	Dim empty As B4XView
	If ActionsHost.IsInitialized = False Then Return empty
	Return ActionsHost
End Sub

Public Sub AddActionButton(Text As String, Tag As Object) As B4XView
	Dim b As Button
	b.Initialize("actionbtn")
	Dim xb As B4XView = b
	xb.Text = Text
	xb.Tag = Tag
	xb.TextSize = 12
	xb.SetColorAndBorder(xui.Color_Transparent, 1dip, xui.Color_Gray, 6dip)
	AddViewToContent(xb, 0, 0, 78dip, 32dip)
	Return xb
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And Surface.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	box.Put("padding_left", ContentPaddingH)
	box.Put("padding_right", ContentPaddingH)
	box.Put("padding_top", ContentPaddingV)
	box.Put("padding_bottom", ContentPaddingV)
	Dim bw As Float = Max(0, IIf(BorderWidthFromTheme, B4XDaisyVariants.GetBorderDip(1dip), mBorderWidth))
	If mStyle = "outline" Or mStyle = "dash" Then bw = Max(1dip, bw)
	box.Put("border_width", bw)
	box.Put("radius", IIf(mRoundedBox, B4XDaisyVariants.GetRadiusBoxDip(8dip), 0))
	Return box
End Sub

Private Sub ResolveContentLocalRect(OuterRect As B4XRect, Box As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(OuterRect, Box)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, Box)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, OuterRect)
End Sub

Private Sub LayoutContent(ContentRect As B4XRect)
	Dim colorState As Map
	colorState = ResolveVisualColors
	Dim iconWanted As Boolean = mIconVisible
	Dim iconAsset As String = ResolveIconAsset
	If iconAsset.Trim.Length = 0 Then iconWanted = False
	RefreshIcon(colorState, iconAsset, iconWanted)

	Dim actionSize As Map = MeasureActions
	Dim actionW As Int = actionSize.Get("w")
	Dim actionH As Int = actionSize.Get("h")
	LayoutActionChildren

	Dim isVertical As Boolean = (mDirection = "vertical")
	Dim iconSpace As Int = IIf(iconWanted, Max(16dip, mIconSize), 0)
	Dim actionSpace As Int = IIf(actionW > 0, actionW, 0)
	Dim baseLeft As Int = ContentRect.Left
	Dim baseTop As Int = ContentRect.Top
	Dim innerW As Int = Max(1dip, ContentRect.Width)
	Dim innerH As Int = Max(1dip, ContentRect.Height)
	Dim y As Int

	If isVertical Then
		Dim contentW As Int = innerW
		y = baseTop
		If iconWanted Then
			Dim ix As Int = baseLeft + (contentW - iconSpace) / 2
			IconView.Visible = True
			IconView.SetLayoutAnimated(0, ix, y, iconSpace, iconSpace)
			y = y + iconSpace + ContentGap
		Else
			IconView.Visible = False
		End If

		Dim textH As Int = LayoutTextLabels(contentW, True)
		TextHost.SetLayoutAnimated(0, baseLeft, y, contentW, textH)
		y = y + textH

		If actionW > 0 And actionH > 0 Then
			y = y + ContentGap
			Dim ax As Int = baseLeft + (contentW - actionW) / 2
			ActionsHost.SetLayoutAnimated(0, ax, y, actionW, actionH)
		Else
			ActionsHost.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	Else
		Dim actionSlot As Int = IIf(actionSpace > 0, actionSpace + ContentGap, 0)
		Dim iconSlot As Int = IIf(iconWanted, iconSpace + ContentGap, 0)
		Dim textW As Int = Max(1dip, innerW - actionSlot - iconSlot)
		Dim textH As Int = LayoutTextLabels(textW, False)
		Dim blockH As Int = Max(textH, Max(iconSpace, actionH))
		y = baseTop + Max(0, (innerH - blockH) / 2)

		Dim cursorX As Int = baseLeft
		If iconWanted Then
			IconView.Visible = True
			IconView.SetLayoutAnimated(0, cursorX, y + (blockH - iconSpace) / 2, iconSpace, iconSpace)
			cursorX = cursorX + iconSpace + ContentGap
		Else
			IconView.Visible = False
		End If

		TextHost.SetLayoutAnimated(0, cursorX, y + (blockH - textH) / 2, textW, textH)

		If actionW > 0 And actionH > 0 Then
			Dim ax As Int = baseLeft + innerW - actionW
			ActionsHost.SetLayoutAnimated(0, ax, y + (blockH - actionH) / 2, actionW, actionH)
		Else
			ActionsHost.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	End If
End Sub

Private Sub LayoutTextLabels(AvailableWidth As Int, CenterAligned As Boolean) As Int
	Dim w As Int = Max(1dip, AvailableWidth)
	Dim y As Int = 0
	Dim align As String = IIf(CenterAligned, "CENTER", "LEFT")

	Dim titleText As String = mTitle.Trim
	Dim bodyText As String = mText.Trim
	Dim descText As String = mDescription.Trim

	lblTitle.Visible = titleText.Length > 0
	lblText.Visible = bodyText.Length > 0
	lblDescription.Visible = descText.Length > 0

	If lblTitle.Visible Then
		lblTitle.Text = titleText
		lblTitle.SetTextAlignment("TOP", align)
		Dim hTitle As Int = MeasureLabelHeight(lblTitle, titleText, w)
		lblTitle.SetLayoutAnimated(0, 0, y, w, hTitle)
		y = y + hTitle
	End If

	If lblText.Visible Then
		If y > 0 Then y = y + TextGap
		lblText.Text = bodyText
		lblText.SetTextAlignment("TOP", align)
		Dim hText As Int = MeasureLabelHeight(lblText, bodyText, w)
		lblText.SetLayoutAnimated(0, 0, y, w, hText)
		y = y + hText
	End If

	If lblDescription.Visible Then
		If y > 0 Then y = y + TextGap
		lblDescription.Text = descText
		lblDescription.SetTextAlignment("TOP", align)
		Dim hDesc As Int = MeasureLabelHeight(lblDescription, descText, w)
		lblDescription.SetLayoutAnimated(0, 0, y, w, hDesc)
		y = y + hDesc
	End If

	If y <= 0 Then
		lblTitle.SetLayoutAnimated(0, 0, 0, 0, 0)
		lblText.SetLayoutAnimated(0, 0, 0, 0, 0)
		lblDescription.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
	Return y
End Sub

Private Sub MeasureLabelHeight(v As B4XView, Text As String, Width As Int) As Int
	Dim l As Label = v
	l.Width = Max(1dip, Width)
	Dim h As Int = tu.MeasureMultilineTextHeight(l, Text)
	Return Max(1dip, h)
End Sub

Private Sub MeasureActions As Map
	Dim totalW As Int = 0
	Dim maxH As Int = 0
	If ActionsHost.IsInitialized = False Then Return CreateMap("w": 0, "h": 0)
	For i = 0 To ActionsHost.NumberOfViews - 1
		Dim v As B4XView = ActionsHost.GetView(i)
		Dim w As Int = Max(1dip, v.Width)
		Dim h As Int = Max(1dip, v.Height)
		If totalW > 0 Then totalW = totalW + mActionSpacing
		totalW = totalW + w
		If h > maxH Then maxH = h
	Next
	Return CreateMap("w": totalW, "h": maxH)
End Sub

Private Sub LayoutActionChildren
	If ActionsHost.IsInitialized = False Then Return
	If ActionsHost.NumberOfViews = 0 Then Return
	Dim cursorX As Int = 0
	For i = 0 To ActionsHost.NumberOfViews - 1
		Dim v As B4XView = ActionsHost.GetView(i)
		Dim w As Int = Max(1dip, v.Width)
		Dim h As Int = Max(1dip, v.Height)
		Dim y As Int = Max(0, (ActionsHost.Height - h) / 2)
		v.SetLayoutAnimated(0, cursorX, y, w, h)
		cursorX = cursorX + w + mActionSpacing
	Next
End Sub

Private Sub ApplyVisualStyle(Box As Map)
	If Surface.IsInitialized = False Then Return
	Dim colorState As Map
	colorState = ResolveVisualColors
	Dim bg As Int = colorState.Get("back")
	Dim fg As Int = colorState.Get("text")
	Dim muted As Int = colorState.Get("muted")
	Dim border As Int = colorState.Get("border")
	Dim bw As Int = Max(0, Box.GetDefault("border_width", 0))
	Dim radius As Float = Max(0, Box.GetDefault("radius", 0))

	lblTitle.TextColor = fg
	lblText.TextColor = fg
	lblDescription.TextColor = muted

	#If B4A
	Try
		Dim dashW As Float = 0
		Dim dashGap As Float = 0
		If mStyle = "dash" Then
			dashW = Max(4dip, bw * 3)
			dashGap = Max(3dip, bw * 2)
		End If
		ApplyStrokeNative(Surface, bg, border, bw, radius, dashW, dashGap)
	Catch
		Surface.SetColorAndBorder(bg, bw, border, radius)
	End Try
	#Else
	Surface.SetColorAndBorder(bg, bw, border, radius)
	#End If

	ApplyShadow
End Sub

Private Sub ResolveVisualColors As Map
	InitializePalette
	Dim theme As Map = B4XDaisyVariants.GetActiveTokens

	Dim neutralBack As Int = theme.GetDefault("--color-neutral", xui.Color_RGB(63, 64, 77))
	Dim neutralText As Int = theme.GetDefault("--color-neutral-content", xui.Color_RGB(248, 248, 249))
	Dim neutralBorder As Int = neutralBack
	Dim base100 As Int = theme.GetDefault("--color-base-100", xui.Color_White)

	Dim variant As String = NormalizeAlertVariant(mVariant)
	Dim effectiveVariant As String = IIf(variant = "none", "neutral", variant)
	Dim accent As Int = B4XDaisyVariants.ResolveVariantColor(VariantPalette, effectiveVariant, "back", neutralBack)

	Dim back As Int = neutralBack
	Dim text As Int = neutralText
	Dim border As Int = neutralBorder

	If variant <> "none" Then
		back = B4XDaisyVariants.ResolveVariantColor(VariantPalette, variant, "back", neutralBack)
		text = B4XDaisyVariants.ResolveVariantColor(VariantPalette, variant, "text", neutralText)
		Dim fallbackText As Int = IIf(IsColorLight(back), xui.Color_RGB(15, 23, 42), xui.Color_White)
		text = ResolveReadableTextColor(back, text, fallbackText)
		border = B4XDaisyVariants.Blend(back, xui.Color_Black, 0.14)
	End If

	Select Case mStyle
		Case "soft"
			back = B4XDaisyVariants.Blend(accent, base100, 0.88)
			text = accent
			border = B4XDaisyVariants.Blend(accent, base100, 0.8)
		Case "outline", "dash"
			back = xui.Color_Transparent
			text = accent
			border = accent
	End Select

	If mBackgroundColorOverride <> 0 Then back = mBackgroundColorOverride
	If mTextColorOverride <> 0 Then text = mTextColorOverride
	If mBorderColorOverride <> 0 Then border = mBorderColorOverride
	Dim muted As Int = B4XDaisyVariants.Blend(text, xui.Color_Gray, 0.45)
	Return CreateMap("back": back, "text": text, "muted": muted, "border": border, "accent": accent)
End Sub

Private Sub ResolveReadableTextColor(BackColor As Int, PreferredColor As Int, FallbackColor As Int) As Int
	Dim prefScore As Float = ContrastScore(BackColor, PreferredColor)
	Dim fallbackScore As Float = ContrastScore(BackColor, FallbackColor)
	If prefScore >= 125 Or prefScore >= fallbackScore Then Return PreferredColor
	Return FallbackColor
End Sub

Private Sub IsColorLight(Color As Int) As Boolean
	Return RelativeBrightness(Color) >= 150
End Sub

Private Sub ContrastScore(c1 As Int, c2 As Int) As Float
	Return Abs(RelativeBrightness(c1) - RelativeBrightness(c2))
End Sub

Private Sub RelativeBrightness(Color As Int) As Float
	Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
	Dim b As Int = Bit.And(Color, 0xFF)
	Return (r * 299 + g * 587 + b * 114) / 1000
End Sub

Private Sub RefreshIcon(ColorMap As Map, AssetPath As String, ShowIcon As Boolean)
	If IconComp.IsInitialized = False Or IconView.IsInitialized = False Then Return
	If ShowIcon = False Then
		IconView.Visible = False
		Return
	End If
	IconView.Visible = True
	IconComp.SetSvgAsset(AssetPath)
	IconComp.SetPreserveOriginalColors(False)
	Dim iconColor As Int = ColorMap.Get("text")
	If mIconColorOverride <> 0 Then iconColor = mIconColorOverride
	IconComp.SetColor(iconColor)
	IconComp.SetSize(mIconSize)
	IconComp.ResizeToParent(IconView)
End Sub

Private Sub ResolveIconAsset As String
	If mIconAsset.Trim.Length > 0 Then Return mIconAsset.Trim
	Select Case NormalizeAlertVariant(mVariant)
		Case "success"
			Return "check-solid.svg"
		Case "error"
			Return "xmark-solid.svg"
		Case "warning"
			Return "circle-question-regular.svg"
		Case Else
			Return "circle-question-regular.svg"
	End Select
End Sub

Private Sub InitializePalette
	DefaultVariantPalette = B4XDaisyVariants.GetVariantPalette
	If VariantPalette.IsInitialized = False Or UsingCustomVariantPalette = False Then
		VariantPalette = DefaultVariantPalette
	End If
End Sub

Private Sub ApplyShadow
	Dim level As String = mShadow
	If mStyle <> "solid" Then level = "none"
	Dim e As Float = B4XDaisyVariants.ResolveShadowElevation(level)
	#If B4A
	Dim p As Panel = Surface
	p.Elevation = e
	#End If
End Sub

Private Sub NormalizeAlertVariant(Value As String) As String
	Dim n As String = B4XDaisyVariants.NormalizeVariant(Value)
	If n.Length = 0 Then Return "none"
	Return n
End Sub

Private Sub NormalizeStyle(Value As String) As String
	If Value = Null Then Return "solid"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "solid", "soft", "outline", "dash"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

Private Sub NormalizeDirection(Value As String) As String
	If Value = Null Then Return "horizontal"
	Dim s As String = Value.ToLowerCase.Trim
	If s = "vertical" Then Return "vertical"
	Return "horizontal"
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

Private Sub GetPropDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, DefaultDipValue / 1dip) * 1dip
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

Public Sub SetDefaults
	CustProps.Initialize
	CustProps.Put("Width", ResolvePxSizeSpec(mWidth))
	CustProps.Put("Height", ResolvePxSizeSpec(mHeight))
	CustProps.Put("Variant", mVariant)
	CustProps.Put("AlertStyle", mStyle)
	CustProps.Put("Direction", mDirection)
	CustProps.Put("Title", mTitle)
	CustProps.Put("Text", mText)
	CustProps.Put("Description", mDescription)
	CustProps.Put("RoundedBox", mRoundedBox)
	CustProps.Put("IconVisible", mIconVisible)
	CustProps.Put("IconAsset", mIconAsset)
	CustProps.Put("IconSize", ResolvePxSizeSpec(mIconSize))
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("Shadow", mShadow)
	CustProps.Put("ActionSpacing", mActionSpacing)
End Sub

Public Sub SetProperties(Props As Map)
	If Props.IsInitialized = False Then Return
	Dim src As Map
	src.Initialize
	For Each k As String In Props.Keys
		src.Put(k, Props.Get(k))
	Next
	CustProps.Initialize
	For Each k As String In src.Keys
		CustProps.Put(k, src.Get(k))
	Next
End Sub

Public Sub GetProperties As Map
	CustProps.Initialize
	CustProps.Put("Width", ResolvePxSizeSpec(mWidth))
	CustProps.Put("Height", ResolvePxSizeSpec(mHeight))
	CustProps.Put("Variant", mVariant)
	CustProps.Put("AlertStyle", mStyle)
	CustProps.Put("Direction", mDirection)
	CustProps.Put("Title", mTitle)
	CustProps.Put("Text", mText)
	CustProps.Put("Description", mDescription)
	CustProps.Put("RoundedBox", mRoundedBox)
	CustProps.Put("IconVisible", mIconVisible)
	CustProps.Put("IconAsset", mIconAsset)
	CustProps.Put("IconSize", ResolvePxSizeSpec(mIconSize))
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("Shadow", mShadow)
	CustProps.Put("ActionSpacing", mActionSpacing)
	CustProps.Put("Tag", mTag)
	Return CustProps
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub GetPreferredHeight(AvailableWidth As Int) As Int
	If lblText.IsInitialized = False Then Return Max(40dip, mHeight)
	Dim w As Int = Max(120dip, AvailableWidth)
	Dim box As Map = BuildBoxModel
	Dim actionSize As Map = MeasureActions
	Dim actionW As Int = actionSize.Get("w")
	Dim actionH As Int = actionSize.Get("h")
	Dim iconPath As String = ResolveIconAsset
	Dim iconVisible As Boolean = mIconVisible And iconPath.Trim.Length > 0
	Dim iconSize As Int = IIf(iconVisible, Max(16dip, mIconSize), 0)
	Dim textW As Int
	Dim textH As Int
	Dim padL As Float = box.GetDefault("padding_left", 0)
	Dim padR As Float = box.GetDefault("padding_right", 0)
	Dim borderW As Float = box.GetDefault("border_width", 0)
	Dim contentW As Int = Max(1dip, w - (padL + padR) - (borderW * 2))
	If mDirection = "vertical" Then
		textW = contentW
		textH = LayoutTextLabels(textW, True)
		Dim h As Int = textH
		If iconVisible Then h = h + iconSize + ContentGap
		If actionW > 0 And actionH > 0 Then h = h + ContentGap + actionH
		Return Max(40dip, B4XDaisyBoxModel.ExpandContentHeight(h, box))
	Else
		Dim actionSlot As Int = IIf(actionW > 0, actionW + ContentGap, 0)
		Dim iconSlot As Int = IIf(iconVisible, iconSize + ContentGap, 0)
		textW = Max(1dip, contentW - actionSlot - iconSlot)
		textH = LayoutTextLabels(textW, False)
		Dim blockH As Int = Max(textH, Max(iconSize, actionH))
		Return Max(40dip, B4XDaisyBoxModel.ExpandContentHeight(blockH, box))
	End If
End Sub

Private Sub surface_Click
	RaiseClick
End Sub

Private Sub actionbtn_Click
	Dim v As B4XView = Sender
	RaiseActionClick(v.Tag)
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

Public Sub RaiseActionClick(Tag As Object)
	If xui.SubExists(mCallBack, mEventName & "_ActionClick", 1) Then
		CallSub2(mCallBack, mEventName & "_ActionClick", Tag)
	End If
End Sub

' Native dashed stroke helper used for alert-dash style.
#If B4A
Private Sub ApplyStrokeNative(Target As B4XView, FillColor As Int, StrokeColor As Int, StrokeWidth As Int, Radius As Float, DashWidth As Float, DashGap As Float)
	Dim gd As JavaObject = CreateSolidDrawable(FillColor, Radius)
	If StrokeWidth > 0 Then
		If DashWidth > 0 And DashGap > 0 Then
			gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor, DashWidth, DashGap))
		Else
			gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor))
		End If
	End If
	SetNativeBackground(Target, gd)
End Sub

Private Sub CreateSolidDrawable(FillColor As Int, Radius As Float) As JavaObject
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setShape", Array(0)) 'RECTANGLE
	gd.RunMethod("setColor", Array(FillColor))
	gd.RunMethod("setCornerRadius", Array(Radius))
	Return gd
End Sub

Private Sub SetNativeBackground(Target As B4XView, Drawable As JavaObject)
	Dim jo As JavaObject = Target
	jo.RunMethod("setBackground", Array(Drawable))
End Sub
#End If

'========================
' Public API
'========================

Public Sub setWidth(Value As Object)
	' Width setter: convert Tailwind/CSS-like size to dip and relayout when ready.
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Int = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, targetH)
	Base_Resize(mWidth, targetH)
End Sub

Public Sub getWidth As Float
	' Return cached width in dip.
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	' Height setter: convert Tailwind/CSS-like size to dip and relayout when ready.
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mHeight)
	Base_Resize(targetW, mHeight)
End Sub

Public Sub getHeight As Float
	' Return cached height in dip.
	Return mHeight
End Sub

Public Sub setVariant(Value As String)
	' Update alert variant token and refresh styles.
	mVariant = NormalizeAlertVariant(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	' Return normalized variant token.
	Return mVariant
End Sub

Public Sub setStyle(Value As String)
	' Update style token (solid/soft/outline/dash) and refresh.
	mStyle = NormalizeStyle(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getStyle As String
	' Return normalized style token.
	Return mStyle
End Sub

Public Sub setAlertStyle(Value As String)
	' Alias setter for style to keep designer/runtime naming compatible.
	mStyle = NormalizeStyle(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAlertStyle As String
	Return mStyle
End Sub

Public Sub setDirection(Value As String)
	' Update content layout direction (horizontal/vertical).
	mDirection = NormalizeDirection(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDirection As String
	' Return normalized direction token.
	Return mDirection
End Sub

Public Sub setTitle(Value As String)
	' Update optional title text.
	If Value = Null Then Value = ""
	mTitle = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTitle As String
	' Return title text.
	Return mTitle
End Sub

Public Sub setText(Value As String)
	' Update main message text.
	If Value = Null Then Value = ""
	mText = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getText As String
	' Return main message text.
	Return mText
End Sub

Public Sub setMessage(Value As String)
	' Alias for setText.
	setText(Value)
End Sub

Public Sub getMessage As String
	' Alias for getText.
	Return mText
End Sub

Public Sub setDescription(Value As String)
	' Update optional secondary description text.
	If Value = Null Then Value = ""
	mDescription = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDescription As String
	' Return secondary description text.
	Return mDescription
End Sub

Public Sub setIconVisible(Value As Boolean)
	' Toggle icon host visibility.
	mIconVisible = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconVisible As Boolean
	' Return current icon visibility flag.
	Return mIconVisible
End Sub

Public Sub setIconAsset(Path As String)
	' Update SVG asset path; non-empty value auto-enables icon visibility.
	If Path = Null Then Path = ""
	mIconAsset = Path.Trim
	If mIconAsset.Length > 0 Then mIconVisible = True
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconAsset As String
	' Return current icon asset path.
	Return mIconAsset
End Sub

Public Sub setIconSize(Value As Object)
	' Update icon size from Tailwind/CSS-like value with a minimum of 12dip.
	mIconSize = Max(12dip, B4XDaisyVariants.TailwindSizeToDip(Value, mIconSize))
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconSize As Float
	' Return icon size in dip.
	Return mIconSize
End Sub

Public Sub setIconColor(Value As Object)
	' Accept explicit color ints or theme color token names for icon tint override.
	Dim shouldRefresh As Boolean = False
	If Value = Null Then
		mIconColorOverride = 0
		shouldRefresh = True
	Else If IsNumber(Value) Then
		mIconColorOverride = Value
		shouldRefresh = True
	Else
		Dim s As String = Value
		s = s.Trim
		If s.Length = 0 Then
			mIconColorOverride = 0
			shouldRefresh = True
		Else
			Dim k As String = s.ToLowerCase
			If k = "auto" Or k = "default" Or k = "none" Then
				mIconColorOverride = 0
				shouldRefresh = True
			Else
				Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(k)
				If token.Length > 0 Then
					Dim fallback As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
					mIconColorOverride = B4XDaisyVariants.GetTokenColor(token, fallback)
					shouldRefresh = True
				End If
			End If
		End If
	End If
	If mBase.IsInitialized = False Then Return
	If shouldRefresh Then Refresh
End Sub

Public Sub getIconColor As Int
	' Return resolved icon color override (0 means auto/theme).
	Return mIconColorOverride
End Sub

Public Sub setRoundedBox(Value As Boolean)
	' Toggle rounded-corner style on alert surface.
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRoundedBox As Boolean
	' Return rounded-box flag.
	Return mRoundedBox
End Sub

Public Sub setBorderWidth(Value As Float)
	' Set explicit border width and disable theme-driven border width mode.
	mBorderWidth = Max(0, Value)
	BorderWidthFromTheme = False
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderWidth As Float
	' Return active border width (theme-derived or explicit override).
	If BorderWidthFromTheme Then Return B4XDaisyVariants.GetBorderDip(1dip)
	Return mBorderWidth
End Sub

Public Sub resetBorderWidthToTheme
	' Restore border width resolution back to active theme value.
	BorderWidthFromTheme = True
	mBorderWidth = B4XDaisyVariants.GetBorderDip(1dip)
	Refresh
End Sub

Public Sub setShadow(Value As String)
	' Update shadow token and refresh component.
	mShadow = B4XDaisyVariants.NormalizeShadow(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	' Return normalized shadow token.
	Return mShadow
End Sub

Public Sub setActionSpacing(Value As Float)
	' Update spacing between action views/buttons in dip.
	mActionSpacing = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getActionSpacing As Float
	' Return action spacing in dip.
	Return mActionSpacing
End Sub

Public Sub setVariantPalette(Palette As Map)
	' Replace palette map for variant resolution; Null restores defaults.
	InitializePalette
	If Palette.IsInitialized Then
		VariantPalette = Palette
		UsingCustomVariantPalette = True
	Else
		VariantPalette = DefaultVariantPalette
		UsingCustomVariantPalette = False
	End If
	Refresh
End Sub

Public Sub getVariantPalette As Map
	' Return currently active variant palette map.
	InitializePalette
	Return VariantPalette
End Sub

Public Sub applyActiveTheme
	' Re-resolve theme-sensitive values after global theme/color mode change.
	InitializePalette
	If BorderWidthFromTheme Then mBorderWidth = B4XDaisyVariants.GetBorderDip(1dip)
	Refresh
End Sub

Public Sub setBackgroundColor(Color As Int)
	' Set explicit background color override.
	mBackgroundColorOverride = Color
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	' Return background color override.
	Return mBackgroundColorOverride
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
	' Resolve and apply background color from a palette variant key.
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(VariantPalette, VariantName, "back", mBackgroundColorOverride)
	setBackgroundColor(c)
End Sub

Public Sub setTextColor(Color As Int)
	' Set explicit text color override.
	mTextColorOverride = Color
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	' Return text color override.
	Return mTextColorOverride
End Sub

Public Sub setTextColorVariant(VariantName As String)
	' Resolve and apply text color from a palette variant key.
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(VariantPalette, VariantName, "text", mTextColorOverride)
	setTextColor(c)
End Sub

Public Sub setBorderColor(Color As Int)
	' Set explicit border color override.
	mBorderColorOverride = Color
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	' Return border color override.
	Return mBorderColorOverride
End Sub

Public Sub setBorderColorVariant(VariantName As String)
	' Resolve and apply border color from a palette variant key.
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(VariantPalette, VariantName, "border", mBorderColorOverride)
	setBorderColor(c)
End Sub

Public Sub setTag(Value As Object)
	' Store caller tag object for event correlation.
	mTag = Value
End Sub

Public Sub getTag As Object
	' Return caller tag object.
	Return mTag
End Sub
