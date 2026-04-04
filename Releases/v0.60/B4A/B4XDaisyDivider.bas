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

#IgnoreWarnings:12
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
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
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

	ApplyDesignerProps(Props)
	mBase.Visible = mVisible
	EnsureHostSizeForBoxModel
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(Props, "Direction", "vertical"))
	mPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(Props, "Placement", "default"))
	mText = B4XDaisyVariants.NormalizeSingleLineText(B4XDaisyVariants.GetPropString(Props, "Text", ""))
	mTextSize = NormalizeTextSizeToken(B4XDaisyVariants.GetPropString(Props, "TextSize", "text-sm"))
	mTextSizeDip = ResolveTextSizeDip(mTextSize)
	mGap = ResolveSpacingValue(B4XDaisyVariants.GetPropObject(Props, "Gap", "4"), 16dip)
	mLineThickness = Max(1dip, ResolveSpacingValue(B4XDaisyVariants.GetPropObject(Props, "LineThickness", "0.5"), 2dip))
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "none"))
	mBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", xui.Color_Transparent)
	mTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", xui.Color_Transparent)
	mPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "")
	Dim marginSpec As String = B4XDaisyVariants.GetPropString(Props, "Margin", "")
	If marginSpec = Null Then marginSpec = ""
	mMarginExplicit = (marginSpec.Trim.Length > 0)
	If mMarginExplicit Then
		mMargin = marginSpec
	Else
		mMargin = ResolveDefaultMargin(mDirection)
	End If
	mDebugBorders = B4XDaisyVariants.GetPropBool(Props, "DebugBorders", False)
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)

	mWidthExplicit = IsExplicitSizeProp(Props, "Width")
	mHeightExplicit = IsExplicitSizeProp(Props, "Height")
	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(Props, "Width", ResolveDefaultWidth(0)))
	mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(Props, "Height", ResolveDefaultHeight(0)))

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

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map = BuildRuntimeProps(Width, Height)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty

	Dim w As Int = Width
	Dim h As Int = Height
	If w <= 0 Then w = ResolveDefaultWidth(Parent.Width)
	If h <= 0 Then h = ResolveDefaultHeight(Parent.Height)
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
	Parent.AddView(mBase, Left, Top, mBase.Width, mBase.Height)
	Refresh
	Return mBase
End Sub

Private Sub BuildRuntimeProps(Width As Int, Height As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(Width))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(Height))
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

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return

	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, Width), Max(1dip, Height))
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)

	Dim contentRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutDivider(contentRect)
End Sub

Private Sub LayoutDivider(ContentRect As B4XRect)
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
		LayoutHorizontalDivider(ContentRect, hasText, gapDip, thickness)
	Else
		LayoutVerticalDivider(ContentRect, hasText, gapDip, thickness)
	End If
End Sub

Private Sub LayoutVerticalDivider(ContentRect As B4XRect, HasText As Boolean, GapDip As Int, Thickness As Int)
	Dim yLine As Int = ContentRect.Top + (ContentRect.Height - Thickness) / 2
	Dim place As String = NormalizePlacement(mPlacement)

	Dim beforeEnabled As Boolean = (place <> "start")
	Dim afterEnabled As Boolean = (place <> "end")
	If HasText = False Then
		beforeEnabled = (place <> "start")
		afterEnabled = (place <> "end")
		If place = "default" Then
			beforeEnabled = True
			afterEnabled = True
		End If
	End If

	Dim textW As Int = 0
	Dim textH As Int = 0
	Dim textTop As Int = ContentRect.Top
	If HasText Then
		textW = MeasureSingleLineWidth(lblContent.Text, mTextSizeDip)
		textH = MeasureSingleLineHeight(mTextSizeDip)
		textTop = ContentRect.Top + (ContentRect.Height - textH) / 2
	End If
	Dim effectiveGap As Int = GapDip
	If HasText Then
		Dim minSegW As Int = 8dip
		Dim maxGap As Int = Max(0, (ContentRect.Width - textW - (minSegW * 2)) / 2)
		effectiveGap = Min(GapDip, maxGap)
	End If

	If HasText Then
		If beforeEnabled And afterEnabled Then
			Dim freeW As Int = Max(0, ContentRect.Width - textW - (effectiveGap * 2))
			Dim beforeW As Int = freeW / 2
			Dim afterW As Int = freeW - beforeW
			LineBefore.SetLayoutAnimated(0, ContentRect.Left, yLine, beforeW, Thickness)
			lblContent.SetLayoutAnimated(0, ContentRect.Left + beforeW + effectiveGap, textTop, textW, textH)
			LineAfter.SetLayoutAnimated(0, lblContent.Left + lblContent.Width + effectiveGap, yLine, afterW, Thickness)
		Else If beforeEnabled = False And afterEnabled Then
			Dim tailW As Int = Max(0, ContentRect.Width - textW - effectiveGap)
			lblContent.SetLayoutAnimated(0, ContentRect.Left, textTop, textW, textH)
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, lblContent.Left + lblContent.Width + effectiveGap, yLine, tailW, Thickness)
		Else If beforeEnabled And afterEnabled = False Then
			Dim headW As Int = Max(0, ContentRect.Width - textW - effectiveGap)
			LineBefore.SetLayoutAnimated(0, ContentRect.Left, yLine, headW, Thickness)
			lblContent.SetLayoutAnimated(0, ContentRect.Left + headW + effectiveGap, textTop, textW, textH)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
			lblContent.SetLayoutAnimated(0, ContentRect.Left + (ContentRect.Width - textW) / 2, textTop, textW, textH)
		End If
	Else
		lblContent.SetLayoutAnimated(0, 0, 0, 0, 0)
		If beforeEnabled And afterEnabled Then
			Dim halfW As Int = ContentRect.Width / 2
			LineBefore.SetLayoutAnimated(0, ContentRect.Left, yLine, halfW, Thickness)
			LineAfter.SetLayoutAnimated(0, ContentRect.Left + halfW, yLine, ContentRect.Width - halfW, Thickness)
		Else If beforeEnabled Then
			LineBefore.SetLayoutAnimated(0, ContentRect.Left, yLine, ContentRect.Width, Thickness)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, ContentRect.Left, yLine, ContentRect.Width, Thickness)
		End If
	End If

	lblContent.Visible = HasText
	LineBefore.Visible = LineBefore.Width > 0 And LineBefore.Height > 0
	LineAfter.Visible = LineAfter.Width > 0 And LineAfter.Height > 0
End Sub

Private Sub LayoutHorizontalDivider(ContentRect As B4XRect, HasText As Boolean, GapDip As Int, Thickness As Int)
	Dim xLine As Int = ContentRect.Left + (ContentRect.Width - Thickness) / 2
	Dim place As String = NormalizePlacement(mPlacement)
	Dim textInset As Int = 2dip
	Dim usableTop As Int = ContentRect.Top + textInset
	Dim usableH As Int = Max(0, ContentRect.Height - (textInset * 2))

	Dim beforeEnabled As Boolean = (place <> "start")
	Dim afterEnabled As Boolean = (place <> "end")
	If HasText = False Then
		beforeEnabled = (place <> "start")
		afterEnabled = (place <> "end")
		If place = "default" Then
			beforeEnabled = True
			afterEnabled = True
		End If
	End If

	Dim textH As Int = 0
	Dim textW As Int = 0
	If HasText Then
		textH = MeasureSingleLineHeight(mTextSizeDip)
		textW = MeasureSingleLineWidth(lblContent.Text, mTextSizeDip)
	End If
	Dim effectiveGap As Int = GapDip
	If HasText Then
		Dim minSegH As Int = 8dip
		Dim maxGap As Int = Max(0, (usableH - textH - (minSegH * 2)) / 2)
		effectiveGap = Min(GapDip, maxGap)
	End If
	Dim textX As Int = ContentRect.Left + (ContentRect.Width - textW) / 2
	Dim textCenteredTop As Int = usableTop + (usableH - textH) / 2

	If HasText Then
		If beforeEnabled And afterEnabled Then
			Dim freeH As Int = Max(0, usableH - textH - (effectiveGap * 2))
			Dim beforeH As Int = freeH / 2
			Dim afterH As Int = freeH - beforeH
			Dim textTop As Int = usableTop + beforeH + effectiveGap
			If freeH = 0 And effectiveGap = 0 Then textTop = textCenteredTop
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, Thickness, beforeH)
			lblContent.SetLayoutAnimated(0, textX, textTop, textW, textH)
			LineAfter.SetLayoutAnimated(0, xLine, lblContent.Top + lblContent.Height + effectiveGap, Thickness, afterH)
		Else If beforeEnabled = False And afterEnabled Then
			Dim tailH As Int = Max(0, usableH - textH - effectiveGap)
			lblContent.SetLayoutAnimated(0, textX, usableTop, textW, textH)
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, xLine, lblContent.Top + lblContent.Height + effectiveGap, Thickness, tailH)
		Else If beforeEnabled And afterEnabled = False Then
			Dim headH As Int = Max(0, usableH - textH - effectiveGap)
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, Thickness, headH)
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
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, Thickness, halfH)
			LineAfter.SetLayoutAnimated(0, xLine, usableTop + halfH, Thickness, usableH - halfH)
		Else If beforeEnabled Then
			LineBefore.SetLayoutAnimated(0, xLine, usableTop, Thickness, usableH)
			LineAfter.SetLayoutAnimated(0, 0, 0, 0, 0)
		Else
			LineBefore.SetLayoutAnimated(0, 0, 0, 0, 0)
			LineAfter.SetLayoutAnimated(0, xLine, usableTop, Thickness, usableH)
		End If
	End If

	lblContent.Visible = HasText
	LineBefore.Visible = LineBefore.Width > 0 And LineBefore.Height > 0
	LineAfter.Visible = LineAfter.Width > 0 And LineAfter.Height > 0
End Sub

Private Sub ApplyLineVisual(Target As B4XView, ColorValue As Int, Thickness As Int)
	Dim radius As Float = 0dip
	If DEBUG_DIVIDER_BOUNDS Or mDebugBorders Then
		Target.SetColorAndBorder(ColorValue, 1dip, 0xFFFF0000, radius)
	Else
		Target.SetColorAndBorder(ColorValue, 0dip, xui.Color_Transparent, radius)
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

Private Sub ResolveDefaultWidth(ParentWidth As Int) As Int
	If mDirection = "horizontal" Then
		Return 16dip
	End If
	If ParentWidth > 0 Then Return ParentWidth
	Return 160dip
End Sub

Private Sub ResolveDefaultHeight(ParentHeight As Int) As Int
	If mDirection = "horizontal" Then
		If ParentHeight > 0 Then Return ParentHeight
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

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, mWidth + ResolveMarginTotalX), mBase.Height)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, Max(1dip, mHeight + ResolveMarginTotalY))
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setDirection(Value As String)
	mDirection = NormalizeDirection(Value)
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

Public Sub setPlacement(Value As String)
	mPlacement = NormalizePlacement(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPlacement As String
	Return mPlacement
End Sub

Public Sub setText(Value As String)
	mText = B4XDaisyVariants.NormalizeSingleLineText(Value)
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

Public Sub setTextSize(Value As String)
	mTextSize = NormalizeTextSizeToken(Value)
	mTextSizeDip = ResolveTextSizeDip(mTextSize)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextSize As String
	Return mTextSize
End Sub

Public Sub setGap(Value As Object)
	mGap = ResolveSpacingValue(Value, mGap)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getGap As Float
	Return mGap
End Sub

Public Sub setLineThickness(Value As Object)
	mLineThickness = Max(1dip, ResolveSpacingValue(Value, mLineThickness))
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getLineThickness As Float
	Return mLineThickness
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	mBackgroundColor = xui.Color_Transparent
	mTextColor = xui.Color_Transparent
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
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

Public Sub setPadding(Value As String)
	mPadding = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	Dim s As String = IIf(Value = Null, "", Value)
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

Public Sub setDebugBorders(Value As Boolean)
	mDebugBorders = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDebugBorders As Boolean
	Return mDebugBorders
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setLeft(Value As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, Value, mBase.Top, mBase.Width, mBase.Height)
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Left
End Sub

Public Sub setTop(Value As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, Value, mBase.Width, mBase.Height)
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Top
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, Width)
	Dim targetH As Int = Max(1dip, Height)
	mWidth = Max(1dip, targetW - ResolveMarginTotalX)
	mHeight = Max(1dip, targetH - ResolveMarginTotalY)
	mWidthExplicit = True
	mHeightExplicit = True
	mBase.SetLayoutAnimated(Duration, Left, Top, Max(1dip, mWidth + ResolveMarginTotalX), Max(1dip, mHeight + ResolveMarginTotalY))
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

Private Sub NormalizeTextSizeToken(Value As String) As String
	If Value = Null Then Return "text-sm"
	Dim s As String = Value.ToLowerCase.Trim
	If s.Length = 0 Then Return "text-sm"
	If s.StartsWith("text-") Then Return s
	Return "text-sm"
End Sub

Private Sub ResolveTextSizeDip(Token As String) As Float
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(Token, 14, 20)
	Return Max(1, tm.GetDefault("font_size", 14))
End Sub

Private Sub NormalizeDirection(Value As String) As String
	If Value = Null Then Return "vertical"
	Dim s As String = Value.ToLowerCase.Trim
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

Private Sub NormalizePlacement(Value As String) As String
	If Value = Null Then Return "default"
	Dim s As String = Value.ToLowerCase.Trim
	s = s.Replace("divider-", "")
	Select Case s
		Case "start", "end"
			Return s
		Case Else
			Return "default"
	End Select
End Sub



Private Sub MeasureSingleLineWidth(Text As String, FontSize As Float) As Int
	Dim t As String = B4XDaisyVariants.NormalizeSingleLineText(Text)
	If t.Length = 0 Then Return 0
	If lblContent.IsInitialized Then
		Try
			Dim l As Label = lblContent
			Dim c As Canvas
			c.Initialize(l)
			Dim w As Float = c.MeasureStringWidth(t, l.Typeface, FontSize)
			Dim extraPad As Int = Max(6dip, Min(24dip, t.Length * 3dip))
			Return Max(1dip, Ceil(w) + extraPad)
		Catch
		End Try 'ignore
	End If
	Dim fallbackPad As Int = Max(6dip, Min(24dip, t.Length * 3dip))
	Return Max(1dip, Ceil(t.Length * FontSize * 0.7) + fallbackPad)
End Sub

Private Sub ResolveHorizontalTextMinWidth As Int
	If mDirection <> "horizontal" Then Return 0
	Dim txt As String = B4XDaisyVariants.NormalizeSingleLineText(mText)
	If txt.Length = 0 Then Return 0
	Return Max(1dip, MeasureSingleLineWidth(txt, mTextSizeDip) + 4dip)
End Sub

Private Sub MeasureSingleLineHeight(FontSize As Float) As Int
	Dim probe As String = "Ag"
	If lblContent.IsInitialized Then
		Try
			Dim l As Label = lblContent
			Dim c As Canvas
			c.Initialize(l)
			Dim h As Float = c.MeasureStringHeight(probe, l.Typeface, FontSize)
			Dim extraPad As Int = Max(4dip, Ceil(FontSize * 0.35))
			Return Max(1dip, Ceil(h) + extraPad)
		Catch
		End Try 'ignore
	End If
	Return Max(1dip, Ceil(FontSize * 1.8) + 4dip)
End Sub

Private Sub AlphaColor(ColorValue As Int, Alpha01 As Float) As Int
	Dim a As Int = Max(0, Min(255, Round(255 * Max(0, Min(1, Alpha01)))))
	Dim r As Int = Bit.And(Bit.ShiftRight(ColorValue, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(ColorValue, 8), 0xFF)
	Dim b As Int = Bit.And(ColorValue, 0xFF)
	Return xui.Color_ARGB(a, r, g, b)
End Sub


Private Sub ResolveSpacingValue(Value As Object, DefaultDip As Float) As Float
	If Value = Null Then Return Max(0dip, DefaultDip)
	If Value Is String Then
		Dim s As String = Value
		Return Max(0dip, B4XDaisyVariants.TailwindSpacingToDip(s, DefaultDip))
	End If
	If IsNumber(Value) Then Return Max(0dip, Value)
	Return Max(0dip, B4XDaisyVariants.TailwindSpacingToDip(Value, DefaultDip))
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



Private Sub ResolveDefaultMargin(Direction As String) As String
	If NormalizeDirection(Direction) = "horizontal" Then Return "mx-4"
	Return "my-4"
End Sub
