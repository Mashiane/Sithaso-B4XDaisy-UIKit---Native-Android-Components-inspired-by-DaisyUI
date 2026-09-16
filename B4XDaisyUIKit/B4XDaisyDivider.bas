B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue:, Description: Optional width token (Tailwind/CSS). Leave empty for direction-based auto sizing.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue:, Description: Optional height token (Tailwind/CSS). Leave empty for direction-based auto sizing.
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: vertical, List: vertical|horizontal, Description: vertical = classic divider line; horizontal = side divider.
#DesignerProperty: Key: Placement, DisplayName: Placement, FieldType: String, DefaultValue: default, List: default|start|end, Description: Push text to start / center / end.
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Optional divider label.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, List: text-xs|text-sm|text-base|text-lg|text-xl|text-2xl|text-3xl|text-4xl|text-5xl|text-6xl|text-7xl|text-8xl|text-9xl, Description: Tailwind text size token (for example: text-sm, text-lg, text-2xl).
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: String, DefaultValue: 4, Description: Gap between text and lines (Tailwind spacing token or size).
#DesignerProperty: Key: LineThickness, DisplayName: Line Thickness, FieldType: String, DefaultValue: 0.5, Description: Divider stroke thickness (Tailwind spacing token or size).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy semantic divider color variant.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override divider line color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override divider text color.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Optional padding utility token(s).
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Optional margin utility token(s). Empty uses direction defaults: my-4 (vertical), mx-4 (horizontal).
#DesignerProperty: Key: DebugBorders, DisplayName: Debug Borders, FieldType: Boolean, DefaultValue: False, Description: Draw red debug borders around divider parts and text.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide divider.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private mWidth As Float = 0
	Private mHeight As Float = 0
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False

	Private mDirection As String = "vertical"
	Private mPlacement As String = "default"
	Private mText As String = ""
	Private mTextSize As String = "text-sm"
	Private mTextSizeDip As Float = 14
	Private mGap As Float = 16dip
	Private mLineThickness As Float = 2dip
	Private mVariant As String = "none"
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mTextColor As Int = xui.Color_Transparent
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mMarginExplicit As Boolean = False
	Private mDebugBorders As Boolean = False
	Private mVisible As Boolean = True

	Private Surface As B4XView
	Private LineBefore As B4XView
	Private LineAfter As B4XView
	Private lblContent As B4XView
	Private Const DEBUG_DIVIDER_BOUNDS As Boolean = False
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
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	Dim pBefore As Panel
	pBefore.Initialize("part")
	LineBefore = pBefore
	LineBefore.Color = xui.Color_Transparent
	Surface.AddView(LineBefore, 0, 0, 0, 0)

	Dim l As Label
	l.Initialize("part")
	lblContent = l
	lblContent.SetTextAlignment("CENTER", "CENTER")
	lblContent.Color = xui.Color_Transparent
	Surface.AddView(lblContent, 0, 0, 0, 0)

	Dim pAfter As Panel
	pAfter.Initialize("part")
	LineAfter = pAfter
	LineAfter.Color = xui.Color_Transparent
	Surface.AddView(LineAfter, 0, 0, 0, 0)

	B4XDaisyVariants.DisableClipping(mBase)
	B4XDaisyVariants.DisableClipping(Surface)
	If mBase.Parent.IsInitialized Then B4XDaisyVariants.DisableClipping(mBase.Parent)

	ApplyDesignerProps(mProps)
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(mProps, "Direction", mDirection))
	mPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(mProps, "Placement", mPlacement))
	mText = B4XDaisyVariants.NormalizeSingleLineText(B4XDaisyVariants.GetPropString(mProps, "Text", mText))
	mTextSize = NormalizeTextSizeToken(B4XDaisyVariants.GetPropString(mProps, "TextSize", mTextSize))
	mTextSizeDip = ResolveTextSizeDip(mTextSize)
	mGap = ResolveSpacingValue(B4XDaisyVariants.GetPropObject(mProps, "Gap", "4"), 16dip)
	mLineThickness = Max(1dip, ResolveSpacingValue(B4XDaisyVariants.GetPropObject(mProps, "LineThickness", "0.5"), 2dip))
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", xui.Color_Transparent)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", xui.Color_Transparent)
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	Dim marginSpec As String = B4XDaisyVariants.GetPropString(mProps, "Margin", "")
	If marginSpec = Null Then marginSpec = ""
	mMarginExplicit = (marginSpec.Trim.Length > 0)
	If mMarginExplicit Then
		mMargin = marginSpec
	Else
		mMargin = ResolveDefaultMargin(mDirection)
	End If
	mDebugBorders = B4XDaisyVariants.GetPropBool(mProps, "DebugBorders", mDebugBorders)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)

	mWidthExplicit = IsExplicitSizeProp(mProps, "Width")
	mHeightExplicit = IsExplicitSizeProp(mProps, "Height")
	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", ResolveDefaultWidth(0)))
	mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", ResolveDefaultHeight(0)))

	If mWidthExplicit = False Then
		Dim marginX As Int = ResolveMarginTotalX
		If mBase.IsInitialized And mBase.Width > 0 Then
			mWidth = Max(1dip, mBase.Width - marginX)
		Else
			mWidth = ResolveDefaultWidth(0)
		End If
		If mDirection = "horizontal" Then mWidth = Max(mWidth, ResolveHorizontalTextMinWidth)
	End If
	If mHeightExplicit = False Then
		Dim marginY As Int = ResolveMarginTotalY
		If mBase.IsInitialized And mBase.Height > 0 Then
			mHeight = Max(1dip, mBase.Height - marginY)
		Else
			mHeight = ResolveDefaultHeight(0)
		End If
	End If
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

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty

	Dim w As Int = iWidth
	Dim h As Int = iHeight
	If w <= 0 Then w = ResolveDefaultWidth(vParent.Width)
	If h <= 0 Then h = ResolveDefaultHeight(vParent.Height)
	w = Max(1dip, w)
	h = Max(1dip, h)

	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)

	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, mBase.Width, mBase.Height)
	Refresh
	Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Direction", mDirection)
	props.Put("Placement", mPlacement)
	props.Put("Text", mText)
	props.Put("TextSize", mTextSize)
	props.Put("Gap", mGap)
	props.Put("LineThickness", mLineThickness)
	props.Put("Variant", mVariant)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("DebugBorders", mDebugBorders)
	props.Put("Visible", mVisible)
	Return props
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return

	If inResize Then Return
	inResize = True
	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, dWidth), Max(1dip, dHeight))
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)

	Dim contentRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutDivider(contentRect)
	inResize = False
End Sub

Private Sub LayoutDivider(rcContentRect As B4XRect)
	Dim colorsMap As Map = ResolveVisualColors
	Dim lineColor As Int = colorsMap.GetDefault("line", xui.Color_ARGB(26, 63, 64, 77))
	Dim labelColor As Int = colorsMap.GetDefault("text", xui.Color_RGB(63, 64, 77))
	Dim txt As String = B4XDaisyVariants.NormalizeSingleLineText(mText)
	Dim hasText As Boolean = txt.Length > 0
	Dim gapDip As Int = IIf(hasText, Max(0dip, mGap), 0)
	Dim thickness As Int = Max(1dip, mLineThickness)

	lblContent.Text = txt
	lblContent.TextColor = labelColor
	lblContent.TextSize = mTextSizeDip
	ApplyTextVisual

	ApplyLineVisual(LineBefore, lineColor, thickness)
	ApplyLineVisual(LineAfter, lineColor, thickness)

	If mDirection = "horizontal" Then
		LayoutHorizontalDivider(rcContentRect, hasText, gapDip, thickness)
	Else
		LayoutVerticalDivider(rcContentRect, hasText, gapDip, thickness)
	End If
End Sub

Private Sub LayoutVerticalDivider(rcContentRect As B4XRect, bHasText As Boolean, iGapDip As Int, iThickness As Int)
	Dim yLine As Int = rcContentRect.Top + (rcContentRect.Height - iThickness) / 2
	Dim place As String = NormalizePlacement(mPlacement)

	Dim beforeEnabled As Boolean = (place <> "start")
	Dim afterEnabled As Boolean = (place <> "end")
	If bHasText = False Then
		beforeEnabled = (place <> "start")
		afterEnabled = (place <> "end")
		If place = "default" Then
			beforeEnabled = True
			afterEnabled = True
		End If
	End If

	Dim textW As Int = 0
	Dim textH As Int = 0
	Dim textTop As Int = rcContentRect.Top
	If bHasText Then
		textW = MeasureSingleLineWidth(lblContent.Text, mTextSizeDip)
		textH = MeasureSingleLineHeight(mTextSizeDip)
		textTop = rcContentRect.Top + (rcContentRect.Height - textH) / 2
	End If
	Dim effectiveGap As Int = iGapDip
	If bHasText Then
		Dim minSegW As Int = 8dip
		Dim maxGap As Int = Max(0, (rcContentRect.Width - textW - (minSegW * 2)) / 2)
		effectiveGap = Min(iGapDip, maxGap)
	End If

	If bHasText Then
		If beforeEnabled And afterEnabled Then
			Dim freeW As Int = Max(0, rcContentRect.Width - textW - (effectiveGap * 2))
			Dim beforeW As Int = freeW / 2
			Dim afterW As Int = freeW - beforeW
			LineBefore.SetLayoutAnimated(0, rcContentRect.Left, yLine, beforeW, iThickness)
			lblContent.SetLayoutAnimated(0, rcContentRect.Left + beforeW + effectiveGap, textTop, textW, textH)
			LineAfter.SetLayoutAnimated(0, lblContent.Left + lblContent.Width + effectiveGap, yLine, afterW, iThickness)
		Else If beforeEnabled = False And afterEnabled Then
			Dim tailW As Int = Max(0, rcContentRect.Width - textW - effectiveGap)
			lblContent.SetLayoutAnimated(0, rcContentRect.Left, textTop, textW, textH)
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, lblContent.Left + lblContent.Width + effectiveGap, yLine, tailW, iThickness)
		Else If beforeEnabled And afterEnabled = False Then
			Dim headW As Int = Max(0, rcContentRect.Width - textW - effectiveGap)
			LineBefore.SetLayoutAnimated(0, rcContentRect.Left, yLine, headW, iThickness)
			lblContent.SetLayoutAnimated(0, rcContentRect.Left + headW + effectiveGap, textTop, textW, textH)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
			lblContent.SetLayoutAnimated(0, rcContentRect.Left + (rcContentRect.Width - textW) / 2, textTop, textW, textH)
		End If
	Else
		lblContent.SetLayoutAnimated(0, 0, 0, 0, 0)
		If beforeEnabled And afterEnabled Then
			Dim halfW As Int = rcContentRect.Width / 2
			LineBefore.SetLayoutAnimated(0, rcContentRect.Left, yLine, halfW, iThickness)
			LineAfter.SetLayoutAnimated(0, rcContentRect.Left + halfW, yLine, rcContentRect.Width - halfW, iThickness)
		Else If beforeEnabled Then
			LineBefore.SetLayoutAnimated(0, rcContentRect.Left, yLine, rcContentRect.Width, iThickness)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, rcContentRect.Left, yLine, rcContentRect.Width, iThickness)
		End If
	End If

	lblContent.Visible = bHasText
	LineBefore.Visible = LineBefore.Width > 0 And LineBefore.Height > 0
	LineAfter.Visible = LineAfter.Width > 0 And LineAfter.Height > 0
End Sub

Private Sub LayoutHorizontalDivider(rcContentRect As B4XRect, bHasText As Boolean, iGapDip As Int, iThickness As Int)
	Dim xLine As Int = rcContentRect.Left + (rcContentRect.Width - iThickness) / 2
	Dim place As String = NormalizePlacement(mPlacement)
	Dim textInset As Int = 2dip
	Dim usableTop As Int = rcContentRect.Top + textInset
	Dim usableH As Int = Max(0, rcContentRect.Height - (textInset * 2))

	Dim beforeEnabled As Boolean = (place <> "start")
	Dim afterEnabled As Boolean = (place <> "end")
	If bHasText = False Then
		beforeEnabled = (place <> "start")
		afterEnabled = (place <> "end")
		If place = "default" Then
			beforeEnabled = True
			afterEnabled = True
		End If
	End If

	Dim textH As Int = 0
	Dim textW As Int = 0
	If bHasText Then
		textH = MeasureSingleLineHeight(mTextSizeDip)
		textW = MeasureSingleLineWidth(lblContent.Text, mTextSizeDip)
	End If
	Dim effectiveGap As Int = iGapDip
	If bHasText Then
		Dim minSegH As Int = 8dip
		Dim maxGap As Int = Max(0, (usableH - textH - (minSegH * 2)) / 2)
		effectiveGap = Min(iGapDip, maxGap)
	End If
	Dim textX As Int = rcContentRect.Left + (rcContentRect.Width - textW) / 2
	Dim textCenteredTop As Int = usableTop + (usableH - textH) / 2

	If bHasText Then
		If beforeEnabled And afterEnabled Then
			Dim freeH As Int = Max(0, usableH - textH - (effectiveGap * 2))
			Dim beforeH As Int = freeH / 2
			Dim afterH As Int = freeH - beforeH
			Dim textTop As Int = usableTop + beforeH + effectiveGap
			If freeH = 0 And effectiveGap = 0 Then textTop = textCenteredTop
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, iThickness, beforeH)
			lblContent.SetLayoutAnimated(0, textX, textTop, textW, textH)
			LineAfter.SetLayoutAnimated(0, xLine, lblContent.Top + lblContent.Height + effectiveGap, iThickness, afterH)
		Else If beforeEnabled = False And afterEnabled Then
			Dim tailH As Int = Max(0, usableH - textH - effectiveGap)
			lblContent.SetLayoutAnimated(0, textX, usableTop, textW, textH)
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, xLine, lblContent.Top + lblContent.Height + effectiveGap, iThickness, tailH)
		Else If beforeEnabled And afterEnabled = False Then
			Dim headH As Int = Max(0, usableH - textH - effectiveGap)
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, iThickness, headH)
			lblContent.SetLayoutAnimated(0, textX, usableTop + headH + effectiveGap, textW, textH)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
			lblContent.SetLayoutAnimated(0, textX, textCenteredTop, textW, textH)
		End If
	Else
		lblContent.SetLayoutAnimated(0, 0, 0, 0, 0)
		If beforeEnabled And afterEnabled Then
			Dim halfH As Int = usableH / 2
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, iThickness, halfH)
			LineAfter.SetLayoutAnimated(0, xLine, usableTop + halfH, iThickness, usableH - halfH)
		Else If beforeEnabled Then
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, iThickness, usableH)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, xLine, usableTop, iThickness, usableH)
		End If
	End If

	lblContent.Visible = bHasText
	LineBefore.Visible = LineBefore.Width > 0 And LineBefore.Height > 0
	LineAfter.Visible = LineAfter.Width > 0 And LineAfter.Height > 0
End Sub

Private Sub ApplyLineVisual(vTarget As B4XView, iColorValue As Int, iThickness As Int)
	Dim radius As Float = 0dip
	If DEBUG_DIVIDER_BOUNDS Or mDebugBorders Then
		vTarget.SetColorAndBorder(iColorValue, 1dip, 0xFFFF0000, radius)
	Else
		vTarget.SetColorAndBorder(iColorValue, 0dip, xui.Color_Transparent, radius)
	End If
End Sub

Private Sub ApplyTextVisual
	If DEBUG_DIVIDER_BOUNDS Or mDebugBorders Then
		lblContent.SetColorAndBorder(xui.Color_Transparent, 1dip, 0xFFFF0000, 2dip)
	Else
		lblContent.SetColorAndBorder(xui.Color_Transparent, 0dip, xui.Color_Transparent, 0dip)
	End If
End Sub

Private Sub ResolveVisualColors As Map
	Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(63, 64, 77))
	Dim lineColor As Int = AlphaColor(baseContent, 0.1)
	Dim labelColor As Int = baseContent

	If mVariant <> "none" Then
		Dim palette As Map = B4XDaisyVariants.GetVariantPalette
		Dim variantColor As Int = B4XDaisyVariants.ResolveVariantColor(palette, mVariant, "back", lineColor)
		lineColor = variantColor
	End If

	If mBackgroundColor <> xui.Color_Transparent Then lineColor = mBackgroundColor
	If mTextColor <> xui.Color_Transparent Then labelColor = mTextColor

	Return CreateMap("line": lineColor, "text": labelColor)
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, mPadding, mMargin)
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

Private Sub ResolveMarginTotalX As Int
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, "", mMargin)
	Dim ml As Float = Max(0, box.GetDefault("margin_left", 0))
	Dim mr As Float = Max(0, box.GetDefault("margin_right", 0))
	Return Max(0dip, ml + mr)
End Sub

Private Sub ResolveMarginTotalY As Int
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, "", mMargin)
	Dim mt As Float = Max(0, box.GetDefault("margin_top", 0))
	Dim mb As Float = Max(0, box.GetDefault("margin_bottom", 0))
	Return Max(0dip, mt + mb)
End Sub

Private Sub ResolveDefaultWidth(iParentWidth As Int) As Int
	If mDirection = "horizontal" Then
		Return 16dip
	End If
	If iParentWidth > 0 Then Return iParentWidth
	Return 160dip
End Sub

Private Sub ResolveDefaultHeight(iParentHeight As Int) As Int
	If mDirection = "horizontal" Then
		If iParentHeight > 0 Then Return iParentHeight
		Return 120dip
	End If
	Return 16dip
End Sub

Private Sub EnsureHostSizeForBoxModel
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mWidth + ResolveMarginTotalX)
	Dim targetH As Int = Max(1dip, mHeight + ResolveMarginTotalY)
	If targetW <> mBase.Width Or targetH <> mBase.Height Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
	End If
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	B4XDaisyVariants.DisableClipping(mBase)
	B4XDaisyVariants.DisableClipping(Surface)
	If mBase.Parent.IsInitialized Then B4XDaisyVariants.DisableClipping(mBase.Parent)
	If mWidthExplicit = False Then
		Dim parentW As Int = IIf(mBase.Parent.IsInitialized, mBase.Parent.Width, 0)
		mWidth = IIf(mBase.Width > 0, Max(1dip, mBase.Width - ResolveMarginTotalX), ResolveDefaultWidth(parentW))
		If mDirection = "horizontal" Then mWidth = Max(mWidth, ResolveHorizontalTextMinWidth)
	End If
	If mHeightExplicit = False Then
		Dim parentH As Int = IIf(mBase.Parent.IsInitialized, mBase.Parent.Height, 0)
		mHeight = IIf(mBase.Height > 0, Max(1dip, mBase.Height - ResolveMarginTotalY), ResolveDefaultHeight(parentH))
	End If
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setWidth(oValue As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, mWidth))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, mWidth + ResolveMarginTotalX), mBase.Height)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(oValue As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, mHeight))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, Max(1dip, mHeight + ResolveMarginTotalY))
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setDirection(sValue As String)
	mDirection = NormalizeDirection(sValue)
	If mMarginExplicit = False Then mMargin = ResolveDefaultMargin(mDirection)
	If mBase.IsInitialized = False Then Return
	If mWidthExplicit = False Or mHeightExplicit = False Then
		Dim parentW As Int = IIf(mBase.Parent.IsInitialized, mBase.Parent.Width, 0)
		Dim parentH As Int = IIf(mBase.Parent.IsInitialized, mBase.Parent.Height, 0)
		If mWidthExplicit = False Then mWidth = ResolveDefaultWidth(parentW)
		If mHeightExplicit = False Then mHeight = ResolveDefaultHeight(parentH)
		If mWidthExplicit = False Or mHeightExplicit = False Then
			Dim targetW As Int = IIf(mWidthExplicit, mBase.Width, Max(1dip, mWidth + ResolveMarginTotalX))
			Dim targetH As Int = IIf(mHeightExplicit, mBase.Height, Max(1dip, mHeight + ResolveMarginTotalY))
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
		End If
	End If
	Refresh
End Sub

Public Sub getDirection As String
	Return mDirection
End Sub

Public Sub setPlacement(sValue As String)
	mPlacement = NormalizePlacement(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPlacement As String
	Return mPlacement
End Sub

Public Sub setText(sValue As String)
	mText = B4XDaisyVariants.NormalizeSingleLineText(sValue)
	If mBase.IsInitialized = False Then Return
	If mDirection = "horizontal" And mWidthExplicit = False Then
		mWidth = ResolveDefaultWidth(IIf(mBase.Parent.IsInitialized, mBase.Parent.Width, 0))
		mWidth = Max(mWidth, ResolveHorizontalTextMinWidth)
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, mWidth + ResolveMarginTotalX), mBase.Height)
	End If
	Refresh
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setTextSize(sValue As String)
	mTextSize = NormalizeTextSizeToken(sValue)
	mTextSizeDip = ResolveTextSizeDip(mTextSize)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextSize As String
	Return mTextSize
End Sub

Public Sub setGap(oValue As Object)
	mGap = ResolveSpacingValue(oValue, mGap)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getGap As Float
	Return mGap
End Sub

Public Sub setLineThickness(oValue As Object)
	mLineThickness = Max(1dip, ResolveSpacingValue(oValue, mLineThickness))
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getLineThickness As Float
	Return mLineThickness
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	mBackgroundColor = xui.Color_Transparent
	mTextColor = xui.Color_Transparent
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
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

Public Sub setPadding(sValue As String)
	mPadding = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	Dim s As String = IIf(sValue = Null, "", sValue)
	If s.Trim.Length = 0 Then
		mMarginExplicit = False
		mMargin = ResolveDefaultMargin(mDirection)
	Else
		mMarginExplicit = True
		mMargin = s
	End If
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setDebugBorders(bValue As Boolean)
	mDebugBorders = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDebugBorders As Boolean
	Return mDebugBorders
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, iValue, mBase.Top, mBase.Width, mBase.Height)
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Left
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, iValue, mBase.Width, mBase.Height)
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Top
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, iWidth)
	Dim targetH As Int = Max(1dip, iHeight)
	mWidth = Max(1dip, targetW - ResolveMarginTotalX)
	mHeight = Max(1dip, targetH - ResolveMarginTotalY)
	mWidthExplicit = True
	mHeightExplicit = True
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, mWidth + ResolveMarginTotalX), Max(1dip, mHeight + ResolveMarginTotalY))
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub IsReady As Boolean
	Return mBase.IsInitialized And Surface.IsInitialized
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' <summary>
''' Returns the full rendered height of the divider host view in pixels.
''' Identical to GetComputedHeight; provided for API consistency with other B4XDaisy components.
''' </summary>
Public Sub GetActualHeight As Int
	Return GetComputedHeight
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Private Sub part_Click
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

Private Sub NormalizeTextSizeToken(sValue As String) As String
	If sValue = Null Then Return "text-sm"
	Dim s As String = sValue.ToLowerCase.Trim
	If s.Length = 0 Then Return "text-sm"
	If s.StartsWith("text-") Then Return s
	Return "text-sm"
End Sub

Private Sub ResolveTextSizeDip(sToken As String) As Float
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(sToken, 14, 20)
	Return Max(1, tm.GetDefault("font_size", 14))
End Sub

Private Sub NormalizeDirection(sValue As String) As String
	If sValue = Null Then Return "vertical"
	Dim s As String = sValue.ToLowerCase.Trim
	s = s.Replace("divider-", "")
	Select Case s
		Case "vertical", "v"
			Return "vertical"
		Case "horizontal", "h"
			Return "horizontal"
		Case Else
			Return "vertical"
	End Select
End Sub

Private Sub NormalizePlacement(sValue As String) As String
	If sValue = Null Then Return "default"
	Dim s As String = sValue.ToLowerCase.Trim
	s = s.Replace("divider-", "")
	Select Case s
		Case "start", "end"
			Return s
		Case Else
			Return "default"
	End Select
End Sub



Private Sub MeasureSingleLineWidth(sT As String, fFontSize As Float) As Int
	If sT.Length = 0 Then Return 0
	If lblContent.IsInitialized Then
		Try
			Dim l As Label = lblContent
			' Use a generous extra pad so short labels like "OR" always get full width.
			' Min: 20dip so even a 1-char label has room; scales at 8dip per character.
			Dim extraPad As Int = Max(20dip, Min(48dip, sT.Length * 8dip))
			Return B4XDaisyVariants.MeasureTextWidthSafe(sT, fFontSize, l.Typeface, extraPad)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyDivider.MeasureSingleLineWidth: " & LastException.Message)
		End Try 'ignore
	End If
	' Fallback (no canvas): use a full-width multiplier and generous pad.
	Dim fallbackPad As Int = Max(20dip, Min(48dip, sT.Length * 8dip))
	Return Max(1dip, Ceil(sT.Length * fFontSize * 1.0) + fallbackPad)
End Sub

Private Sub ResolveHorizontalTextMinWidth As Int
	If mDirection <> "horizontal" Then Return 0
	Dim txt As String = B4XDaisyVariants.NormalizeSingleLineText(mText)
	If txt.Length = 0 Then Return 0
	Return Max(1dip, MeasureSingleLineWidth(txt, mTextSizeDip) + 4dip)
End Sub

Private Sub MeasureSingleLineHeight(fFontSize As Float) As Int
	Dim probe As String = "Ag"
	If lblContent.IsInitialized Then
		Try
			Dim l As Label = lblContent
			Dim extraPad As Int = Max(4dip, Ceil(fFontSize * 0.35))
			Return B4XDaisyVariants.MeasureTextHeightSafe(probe, fFontSize, l.Typeface, 2000dip, extraPad)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyDivider.MeasureSingleLineHeight: " & LastException.Message)
		End Try 'ignore
	End If
	Return Max(1dip, Ceil(fFontSize * 1.8) + 4dip)
End Sub

Private Sub AlphaColor(iColorValue As Int, fAlpha01 As Float) As Int
	Dim a As Int = Max(0, Min(255, Round(255 * Max(0, Min(1, fAlpha01)))))
	Dim r As Int = Bit.And(Bit.ShiftRight(iColorValue, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iColorValue, 8), 0xFF)
	Dim b As Int = Bit.And(iColorValue, 0xFF)
	Return xui.Color_ARGB(a, r, g, b)
End Sub


Private Sub ResolveSpacingValue(oValue As Object, fDefaultDip As Float) As Float
	If oValue = Null Then Return Max(0dip, fDefaultDip)
	If oValue Is String Then
		Dim s As String = oValue
		Return Max(0dip, B4XDaisyVariants.TailwindSpacingToDip(s, fDefaultDip))
	End If
	If IsNumber(oValue) Then Return Max(0dip, oValue)
	Return Max(0dip, B4XDaisyVariants.TailwindSpacingToDip(oValue, fDefaultDip))
End Sub

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



Private Sub ResolveDefaultMargin(sDirection As String) As String
	If NormalizeDirection(sDirection) = "horizontal" Then Return "mx-4"
	Return "my-4"
End Sub

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
