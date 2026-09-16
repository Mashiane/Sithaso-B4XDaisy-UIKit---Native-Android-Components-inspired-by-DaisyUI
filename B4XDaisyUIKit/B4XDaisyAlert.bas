B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)
#Event: ActionClick (Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 20rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-12, Description: Tailwind size token or CSS size (eg h-12, 80px, 5rem)
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|info|success|warning|error|primary|secondary|accent|neutral, Description: Daisy variant used for alert colors
#DesignerProperty: Key: AlertStyle, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash, Description: Alert visual style
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Horizontal or vertical layout
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue:, Description: Optional title text
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: 12 unread messages. Tap to see., Description: Main alert message
#DesignerProperty: Key: Description, DisplayName: Description, FieldType: String, DefaultValue:, Description: Optional secondary description
#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: SVG file name from assets (empty uses variant default icon)
#DesignerProperty: Key: IconSize, DisplayName: Icon Size, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size for icon
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius token.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 1, Description: Border width in dip
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level
#DesignerProperty: Key: ActionSpacing, DisplayName: Action Spacing, FieldType: Int, DefaultValue: 6, Description: Spacing in dip between action views
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize height to fit content.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override border color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override label text color.
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override icon color.
#DesignerProperty: Key: IconVisible, DisplayName: Icon Visible, FieldType: Boolean, DefaultValue: True, Description: Set icon visibility.

#IgnoreWarnings:12
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
	Private mRounded As String = "rounded-box"
	Private mIconVisible As Boolean = True
	Private mIconAsset As String = ""
	Private mIconSize As Float = 24dip
	Private mBorderWidth As Float = 1dip
	Private mActionSpacing As Float = 6dip
	Private mShadow As String = "none"
	Private mIconColor As Int = 0
	Private mBackgroundColor As Int = 0
	Private mTextColor As Int = 0
	Private mBorderColor As Int = 0
	Private mbAutoResize As Boolean = True

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
	Private ContentGap As Float = 16dip
	Private TextGap As Float = 2dip
	Private tu As StringUtils
	' Detached copy of designer/runtime properties.
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	' Store callback/event contract and load default palette/property state.
	mCallBack = oCallback
	mEventName = sEventName
	mBase = xui.CreatePanel("")
	InitializePalette
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	' Programmatic creation path that mirrors DesignerCreateView usage.
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



Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	' Build visual hierarchy once, then apply properties and first layout pass.
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
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
	IconComp.SetClickable(False)

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

	ApplyDesignerProps(mProps)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub CreateLabel(sEventName As String, fSize As Float, bBold As Boolean) As B4XView
	' Shared label factory used for title/body/description labels.
	Dim l As Label
	l.Initialize(sEventName)
	l.SingleLine = False
	Dim v As B4XView = l
	v.Color = xui.Color_Transparent
	If bBold Then
		v.Font = xui.CreateDefaultBoldFont(fSize)
	Else
		v.Font = xui.CreateDefaultFont(fSize)
	End If
	Return v
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mWidthExplicit = mProps.ContainsKey("Width")
	mHeightExplicit = mProps.ContainsKey("Height")
	mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
	If mbAutoResize Then mHeightExplicit = False
	' use TailwindSizeToDip so "full" is interpreted relative to parent dimensions
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip( _
		B4XDaisyVariants.GetPropString(mProps, "Width", "full"), _
		B4XDaisyVariants.ResolveWidthBase(mBase, mWidth) _
	))
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip( _
		B4XDaisyVariants.GetPropString(mProps, "Height", "h-12"), _
		B4XDaisyVariants.ResolveHeightBase(mBase, mHeight) _
	))
	mVariant = B4XDaisyVariants.NormalizeAlertVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "AlertStyle", mStyle))
	mDirection = B4XDaisyVariants.NormalizeDirection(B4XDaisyVariants.GetPropString(mProps, "Direction", mDirection))
	mTitle = B4XDaisyVariants.GetPropString(mProps, "Title", mTitle)
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mDescription = B4XDaisyVariants.GetPropString(mProps, "Description", mDescription)
	mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)

	' Backward compatibility: migrate legacy RoundedBox=True designer prop
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
	        mRounded = "rounded-box"
	    End If
	End If
	mIconAsset = B4XDaisyVariants.GetPropString(mProps, "IconAsset", mIconAsset).Trim
	If mIconAsset.Length > 0 Then mIconVisible = True
	mIconSize = Max(12dip, B4XDaisyVariants.GetPropSizeDip(mProps, "IconSize", "6"))
	If mProps.ContainsKey("BorderWidth") Then
		mBorderWidth = Max(0, B4XDaisyVariants.GetPropDip(mProps, "BorderWidth", 1))
		BorderWidthFromTheme = False
	End If
	mActionSpacing = Max(0, B4XDaisyVariants.GetPropDip(mProps, "ActionSpacing", 6))
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mBorderColor)
	mIconVisible = B4XDaisyVariants.GetPropBool(mProps, "IconVisible", mIconVisible)
	mIconColor = B4XDaisyVariants.GetPropColor(mProps, "IconColor", mIconColor)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	' Main layout entry point used by page resize and property refresh.
	If mBase.IsInitialized = False Then Return
	If Surface.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, w, h)
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
	ApplyVisualStyle(box)
	Dim contentLocalRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutContent(contentLocalRect)
	DoAutoResize
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	' Snapshot current properties, create view, and attach to parent bounds.
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim targetW As Int = iWidth
	Dim targetH As Int = iHeight
	If targetW <= 0 Then
		If vParent.Width > 0 Then
			targetW = vParent.Width
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
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	
	' If requested width/height was 0 or negative, we automatically size to fit or use defaults
	If iHeight <= 0 Then
		SizeToFit(w)
	End If
	
	Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	' Preserve runtime property state when recreating through DesignerCreateView.
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Variant", mVariant)
	props.Put("AlertStyle", mStyle)
	props.Put("Direction", mDirection)
	props.Put("Title", mTitle)
	props.Put("Text", mText)
	props.Put("Description", mDescription)
	props.Put("IconAsset", mIconAsset)
	props.Put("IconSize", B4XDaisyVariants.ResolvePxSizeSpec(mIconSize))
	props.Put("Rounded", mRounded)
	props.Put("BorderWidth", Max(0, Round(mBorderWidth / 1dip)))
	props.Put("Shadow", mShadow)
	props.Put("ActionSpacing", Max(0, Round(mActionSpacing / 1dip)))
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("BorderColor", mBorderColor)
	props.Put("AutoResize", mbAutoResize)
	Return props
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub AddViewToContent(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	' Allow callers to append arbitrary action/content views at runtime.
	If ActionsHost.IsInitialized = False Then Return
	If vChildView.IsInitialized = False Then Return
	vChildView.RemoveViewFromParent
	ActionsHost.AddView(vChildView, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
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

Public Sub AddActionButton(sText As String, oTag As Object) As B4XView
	Dim b As Button
	b.Initialize("actionbtn")
	Dim xb As B4XView = b
	xb.Text = sText
	xb.Tag = oTag
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
	box.Put("radius", IIf(mRounded = "rounded-box" Or mRounded = "theme", B4XDaisyVariants.GetRadiusBoxDip(8dip), 0))
	Return box
End Sub

Private Sub ResolveContentLocalRect(rcOuterRect As B4XRect, mBox As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(rcOuterRect, mBox)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, mBox)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, rcOuterRect)
End Sub

Private Sub LayoutContent(rcContentRect As B4XRect)
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
	Dim baseLeft As Int = rcContentRect.Left
	Dim baseTop As Int = rcContentRect.Top
	Dim innerW As Int = Max(1dip, rcContentRect.Width)
	Dim innerH As Int = Max(1dip, rcContentRect.Height)
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

Private Sub LayoutTextLabels(iAvailableWidth As Int, bCenterAligned As Boolean) As Int
	Dim w As Int = Max(1dip, iAvailableWidth)
	Dim y As Int = 0
	Dim align As String = IIf(bCenterAligned, "CENTER", "LEFT")

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

Private Sub MeasureLabelHeight(vView As B4XView, sText As String, iWidth As Int) As Int
	Dim l As Label = vView
	l.Width = Max(1dip, iWidth)
	Dim h As Int = tu.MeasureMultilineTextHeight(l, sText)
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

Private Sub ApplyVisualStyle(mBox As Map)
	If Surface.IsInitialized = False Then Return
	Dim colorState As Map
	colorState = ResolveVisualColors
	Dim bg As Int = colorState.Get("back")
	Dim fg As Int = colorState.Get("text")
	Dim muted As Int = colorState.Get("muted")
	Dim border As Int = colorState.Get("border")
	Dim bw As Int = Max(0, mBox.GetDefault("border_width", 0))
	Dim radius As Float = Max(0, mBox.GetDefault("radius", 0))

	lblTitle.TextColor = fg
	lblText.TextColor = fg
	lblDescription.TextColor = muted

	' border and width were accidentally swapped, fixed to match ApplyDashedBorder signature
	B4XDaisyVariants.ApplyDashedBorder(Surface, bg, bw, border, radius, mStyle)

	ApplyShadow
End Sub

' Returns the resolved colors for the current variant and style.
Public Sub GetVisualColors As Map
	Return ResolveVisualColors
End Sub

Private Sub ResolveVisualColors As Map
	InitializePalette
	Dim theme As Map = B4XDaisyVariants.GetActiveTokens

	Dim neutralBack As Int = theme.GetDefault("--color-neutral", xui.Color_RGB(63, 64, 77))
	Dim neutralText As Int = theme.GetDefault("--color-neutral-content", xui.Color_RGB(248, 248, 249))
	Dim neutralBorder As Int = neutralBack
	Dim base100 As Int = theme.GetDefault("--color-base-100", xui.Color_White)

	Dim variant As String = B4XDaisyVariants.NormalizeAlertVariant(mVariant)
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

	If mBackgroundColor <> 0 Then back = mBackgroundColor
	If mTextColor <> 0 Then text = mTextColor
	If mBorderColor <> 0 Then border = mBorderColor
	Dim muted As Int = B4XDaisyVariants.Blend(text, xui.Color_Gray, 0.45)
	Return CreateMap("back": back, "text": text, "muted": muted, "border": border, "accent": accent)
End Sub

Private Sub ResolveReadableTextColor(iBackColor As Int, iPreferredColor As Int, iFallbackColor As Int) As Int
	Dim prefScore As Float = ContrastScore(iBackColor, iPreferredColor)
	Dim fallbackScore As Float = ContrastScore(iBackColor, iFallbackColor)
	If prefScore >= 125 Or prefScore >= fallbackScore Then Return iPreferredColor
	Return iFallbackColor
End Sub

Private Sub IsColorLight(iColor As Int) As Boolean
	Return RelativeBrightness(iColor) >= 150
End Sub

Private Sub ContrastScore(iC1 As Int, iC2 As Int) As Float
	Return Abs(RelativeBrightness(iC1) - RelativeBrightness(iC2))
End Sub

Private Sub RelativeBrightness(iColor As Int) As Float
	Dim r As Int = Bit.And(Bit.ShiftRight(iColor, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iColor, 8), 0xFF)
	Dim b As Int = Bit.And(iColor, 0xFF)
	Return (r * 299 + g * 587 + b * 114) / 1000
End Sub

Private Sub RefreshIcon(mColorMap As Map, sAssetPath As String, bShowIcon As Boolean)
	If IconComp.IsInitialized = False Or IconView.IsInitialized = False Then Return
	If bShowIcon = False Then
		IconView.Visible = False
		Return
	End If
	IconView.Visible = True
	IconComp.SetSvgAsset(sAssetPath)
	IconComp.SetPreserveOriginalColors(False)
	Dim iconColor As Int = mColorMap.Get("text")
	If mIconColor <> 0 Then iconColor = mIconColor
	IconComp.SetColor(iconColor)
	IconComp.SetSize(mIconSize)
	IconComp.ResizeToParent(IconView)
End Sub

Private Sub ResolveIconAsset As String
	If mIconAsset.Trim.Length > 0 Then Return mIconAsset.Trim
	Select Case B4XDaisyVariants.NormalizeAlertVariant(mVariant)
		Case "success"
			Return "check-solid.svg"
		Case "info"
			Return "circle-info-solid.svg"
		Case "error"
			Return "xmark-solid.svg"
		Case "warning"
			Return "triangle-exclamation-solid.svg"
		Case Else
			Return "circle-question-regular.svg"
	End Select
End Sub

Private Sub InitializePalette
	DefaultVariantPalette = B4XDaisyVariants.GetVariantPalette
	If VariantPalette = Null Then
		VariantPalette = DefaultVariantPalette
	Else If VariantPalette.IsInitialized = False Or UsingCustomVariantPalette = False Then
		VariantPalette = DefaultVariantPalette
	End If
End Sub

Private Sub ApplyShadow
	Dim level As String = mShadow
	If mStyle <> "solid" Then level = "none"
	B4XDaisyVariants.ApplyElevation(Surface, level)
End Sub








Private Sub Refresh

	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

' Resizes the alert to the preferred height based on its current content and provided width.
Public Sub SizeToFit(iAvailableWidth As Int)
	If mBase.IsInitialized = False Then Return
	' Safety check for width
	Dim aw As Int = Max(4dip, iAvailableWidth)
	Dim h As Int = GetPreferredHeight(aw)
	mBase.Height = h
	Base_Resize(mBase.Width, h)
End Sub

Private Sub GetPreferredHeight(iAvailableWidth As Int) As Int
	If lblText.IsInitialized = False Then Return Max(40dip, mHeight)
	Dim w As Int = Max(120dip, iAvailableWidth)
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
		Dim hActual As Int = textH
		If iconVisible Then hActual = hActual + iconSize + ContentGap
		If actionW > 0 And actionH > 0 Then hActual = hActual + ContentGap + actionH
		hActual = Max(40dip, B4XDaisyBoxModel.ExpandContentHeight(hActual, box))
		' Log values for debugging
		' Log("Alert.GetPreferredHeight: w=" & AvailableWidth & " -> h=" & hActual)
		Return hActual
	Else
		Dim actionSlot As Int = IIf(actionW > 0, actionW + ContentGap, 0)
		Dim iconSlot As Int = IIf(iconVisible, iconSize + ContentGap, 0)
		textW = Max(1dip, contentW - actionSlot - iconSlot)
		textH = LayoutTextLabels(textW, False)
		Dim blockH As Int = Max(textH, Max(iconSize, actionH))
		Return Max(40dip, B4XDaisyBoxModel.ExpandContentHeight(blockH, box))
	End If
End Sub

Private Sub DoAutoResize
	If mbAutoResize = False Then Return
	If mHeightExplicit Then Return
	If mBase.IsInitialized = False Then Return
	Dim h As Int = GetPreferredHeight(mBase.Width)
	If h <> mBase.Height Then
		mBase.Height = h
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

Public Sub RaiseActionClick(oTag As Object)
	If xui.SubExists(mCallBack, mEventName & "_ActionClick", 1) Then
		CallSub2(mCallBack, mEventName & "_ActionClick", oTag)
	End If
End Sub

'-
' Public API
'-

Public Sub setWidth(oValue As Object)
	' Width setter: convert Tailwind/CSS-like size to dip and relayout when ready.
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
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

Public Sub setHeight(oValue As Object)
	' Height setter: convert Tailwind/CSS-like size to dip and relayout when ready.
	mbAutoResize = False
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
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

Public Sub setAutoResize(bValue As Boolean)
	mbAutoResize = bValue
	If mbAutoResize Then mHeightExplicit = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub

Public Sub setVariant(sValue As String)
	' Update alert variant token and refresh styles.
	mVariant = B4XDaisyVariants.NormalizeAlertVariant(sValue)
	' Reset manual colors to ensure variant colors take full effect.
	mBackgroundColor = 0
	mTextColor = 0
	mBorderColor = 0
	mIconColor = 0
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	' Return normalized variant token.
	Return mVariant
End Sub

Public Sub setStyle(sValue As String)
	' Sets alert style (solid, soft, outline, dash, ghost, link).
	mStyle = B4XDaisyVariants.NormalizeStyle(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getStyle As String
	' Return normalized style token.
	Return mStyle
End Sub

Public Sub setAlertStyle(sValue As String)
	' Alias for setStyle.
	mStyle = B4XDaisyVariants.NormalizeStyle(sValue)
End Sub

Public Sub getAlertStyle As String
	Return mStyle
End Sub

Public Sub setDirection(sValue As String)
	' Update content layout direction (horizontal/vertical).
	mDirection = B4XDaisyVariants.NormalizeDirection(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDirection As String
	' Return normalized direction token.
	Return mDirection
End Sub

Public Sub setTitle(sValue As String)
	' Update optional title text.
	If sValue = Null Then sValue = ""
	mTitle = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTitle As String
	' Return title text.
	Return mTitle
End Sub

Public Sub setText(sValue As String)
	' Update main message text.
	If sValue = Null Then sValue = ""
	mText = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getText As String
	' Return main message text.
	Return mText
End Sub

Public Sub setMessage(sValue As String)
	' Alias for setText.
	setText(sValue)
End Sub

Public Sub getMessage As String
	' Alias for getText.
	Return mText
End Sub

Public Sub setDescription(sValue As String)
	' Update optional secondary description text.
	If sValue = Null Then sValue = ""
	mDescription = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDescription As String
	' Return secondary description text.
	Return mDescription
End Sub

Public Sub setIconVisible(bValue As Boolean)
	' Toggle icon host visibility.
	mIconVisible = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconVisible As Boolean
	' Return current icon visibility flag.
	Return mIconVisible
End Sub

Public Sub setIconAsset(sPath As String)
	' Update SVG asset path; non-empty value auto-enables icon visibility.
	If sPath = Null Then sPath = ""
	mIconAsset = sPath.Trim
	If mIconAsset.Length > 0 Then mIconVisible = True
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconAsset As String
	' Return current icon asset path.
	Return mIconAsset
End Sub

Public Sub setIconSize(oValue As Object)
	' Update icon size from Tailwind/CSS-like value with a minimum of 12dip.
	mIconSize = Max(12dip, B4XDaisyVariants.TailwindSizeToDip(oValue, mIconSize))
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconSize As Float
	' Return icon size in dip.
	Return mIconSize
End Sub

Public Sub setIconColor(oValue As Object)
	' Accept explicit color ints or theme color token names for icon tint.
	Dim shouldRefresh As Boolean = False
	If oValue = Null Then
		mIconColor = 0
		shouldRefresh = True
	Else If IsNumber(oValue) Then
		mIconColor = oValue
		shouldRefresh = True
	Else
		Dim s As String = oValue
		s = s.Trim
		If s.Length = 0 Then
			mIconColor = 0
			shouldRefresh = True
		Else
			Dim k As String = s.ToLowerCase
			If k = "auto" Or k = "default" Or k = "none" Then
				mIconColor = 0
				shouldRefresh = True
			Else
				Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(k)
				If token.Length > 0 Then
					Dim fallback As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
					mIconColor = B4XDaisyVariants.GetTokenColor(token, fallback)
					shouldRefresh = True
				End If
			End If
		End If
	End If
	If mBase.IsInitialized = False Then Return
	If shouldRefresh Then Refresh
End Sub

Public Sub getIconColor As Int
	' Return current icon color (0 means auto/theme).
	Return mIconColor
End Sub

Public Sub setRounded(sValue As String)
	mRounded = IIf(sValue = Null, "rounded-box", sValue.ToLowerCase.Trim)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	' Return rounded-box flag.
	Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setBorderWidth(fValue As Float)
	' Set explicit border width and disable theme-driven border width mode.
	mBorderWidth = Max(0, fValue)
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

Public Sub setShadow(sValue As String)
	' Update shadow token and refresh component.
	mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	' Return normalized shadow token.
	Return mShadow
End Sub

Public Sub setActionSpacing(fValue As Float)
	' Update spacing between action views/buttons in dip.
	mActionSpacing = Max(0, fValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getActionSpacing As Float
	' Return action spacing in dip.
	Return mActionSpacing
End Sub

Public Sub setVariantPalette(mPalette As Map)
	' Replace palette map for variant resolution; Null restores defaults.
	InitializePalette
	If mPalette <> Null Then
		If mPalette.IsInitialized Then
			VariantPalette = mPalette
			UsingCustomVariantPalette = True
		Else
			VariantPalette = DefaultVariantPalette
			UsingCustomVariantPalette = False
		End If
	Else
		VariantPalette = DefaultVariantPalette
		UsingCustomVariantPalette = False
	End If
	If mBase.IsInitialized Then Refresh
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

Public Sub setBackgroundColor(iColor As Int)
	' Set explicit background color.
	mBackgroundColor = iColor
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	' Return background color.
	Return mBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
	' Resolve and apply background color from a palette variant key.
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(VariantPalette, sVariantName, mBackgroundColor)
	setBackgroundColor(c)
End Sub

Public Sub setTextColor(iColor As Int)
	' Set explicit text color.
	mTextColor = iColor
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	' Return text color.
	Return mTextColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	' Resolve and apply text color from a palette variant key.
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(VariantPalette, sVariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setBorderColor(iColor As Int)
	' Set explicit border color.
	mBorderColor = iColor
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	' Return border color.
	Return mBorderColor
End Sub

Public Sub setBorderColorVariant(sVariantName As String)
	' Resolve and apply border color from a palette variant key.
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveBorderColorVariantFromPalette(VariantPalette, sVariantName, mBorderColor)
	setBorderColor(c)
End Sub

Public Sub setTag(oValue As Object)
	' Store caller tag object for event correlation.
	mTag = oValue
End Sub

Public Sub getTag As Object
	' Return caller tag object.
	Return mTag
End Sub



Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	Try
		If mBase.IsInitialized Then mBase.RemoveViewFromParent
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAlert.RemoveViewFromParent: " & LastException.Message)
	End Try
End Sub