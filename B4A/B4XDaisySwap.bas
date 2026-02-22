B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (State As String, Checked As Boolean)
#Event: Changed (State As String, Checked As Boolean)

#DesignerProperty: Key: SwapType, DisplayName: Swap Type, FieldType: String, DefaultValue: text, List: text|svg|avatar, Description: Slot content type. For svg/avatar, On/Off/Indeterminate text values are file paths.
#DesignerProperty: Key: SwapStyle, DisplayName: Swap Style, FieldType: String, DefaultValue: none, List: none|rotate|flip, Description: Visual effect style
#DesignerProperty: Key: State, DisplayName: State, FieldType: String, DefaultValue: off, List: off|on|indeterminate, Description: Swap state
#DesignerProperty: Key: OnText, DisplayName: On Text, FieldType: String, DefaultValue: ON, Description: Text shown in swap-on slot
#DesignerProperty: Key: OffText, DisplayName: Off Text, FieldType: String, DefaultValue: OFF, Description: Text shown in swap-off slot
#DesignerProperty: Key: IndeterminateText, DisplayName: Indeterminate Text, FieldType: String, DefaultValue: , Description: Text shown in indeterminate slot
#DesignerProperty: Key: OnColor, DisplayName: On Color, FieldType: Color, DefaultValue: 0x00000000, Description: On slot text/icon color (0 = theme base-content)
#DesignerProperty: Key: OffColor, DisplayName: Off Color, FieldType: Color, DefaultValue: 0x00000000, Description: Off slot text/icon color (0 = theme base-content)
#DesignerProperty: Key: IndeterminateColor, DisplayName: Indeterminate Color, FieldType: Color, DefaultValue: 0x00000000, Description: Indeterminate slot text/icon color (0 = theme base-content)
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, Description: Tailwind text size token (eg text-xs, text-sm, text-lg, text-9xl, text-sm/6)
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 12, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 12, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: AnimationMs, DisplayName: Animation Ms, FieldType: Int, DefaultValue: 200, Description: Visibility animation in milliseconds

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private mWidth As Float = 48dip
	Private mHeight As Float = 48dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mState As String = "off"
	Private mThreeState As Boolean = False
	Private mAutoToggle As Boolean = True
	Private mStyle As String = "none"
	Private mAnimationMs As Int = 200
	Private mSwapType As String = "text"
	Private mTextSize As String = "text-sm"
	Private mTextLineHeightDip As Float = 20dip

	Private mOnText As String = "ON"
	Private mOffText As String = "OFF"
	Private mIndText As String = ""
	Private mOnColor As Int = 0
	Private mOffColor As Int = 0
	Private mIndColor As Int = 0

	Private Surface As B4XView
	Private OnLayer As B4XView
	Private OffLayer As B4XView
	Private IndLayer As B4XView

	Private lblOn As B4XView
	Private lblOff As B4XView
	Private lblInd As B4XView
	Private OnContent As B4XView
	Private OffContent As B4XView
	Private IndContent As B4XView
	Private Anim As B4XAnimation
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	Anim.Initialize
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

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mBase.RemoveAllViews ' Safety: clear any previous internal views
	' Preserve a tag that was set before view creation (programmatic use).
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("surface")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	OnLayer = CreateLayer
	OffLayer = CreateLayer
	IndLayer = CreateLayer
	' Let touch/click events reach Surface; layers are visual-only.
	OnLayer.Enabled = False
	OffLayer.Enabled = False
	IndLayer.Enabled = False
	Surface.AddView(OnLayer, 0, 0, 1dip, 1dip)
	Surface.AddView(OffLayer, 0, 0, 1dip, 1dip)
	Surface.AddView(IndLayer, 0, 0, 1dip, 1dip)

	lblOn = CreateSlotLabel
	lblOff = CreateSlotLabel
	lblInd = CreateSlotLabel
	OnLayer.AddView(lblOn, 0, 0, 1dip, 1dip)
	OffLayer.AddView(lblOff, 0, 0, 1dip, 1dip)
	IndLayer.AddView(lblInd, 0, 0, 1dip, 1dip)
	OnContent = lblOn
	OffContent = lblOff
	IndContent = lblInd

	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub CreateLayer As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim v As B4XView = p
	v.Color = xui.Color_Transparent
	Return v
End Sub

Private Sub CreateSlotLabel As B4XView
	Dim l As Label
	l.Initialize("")
	l.SingleLine = False
	Dim v As B4XView = l
	v.Color = xui.Color_Transparent
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(ResolveTextSizeToken, 14, 20)
	v.TextSize = tm.GetDefault("font_size", 14)
	mTextLineHeightDip = tm.GetDefault("line_height_dip", 20dip)
	v.Font = xui.CreateDefaultFont(v.TextSize)
	v.SetTextAlignment("CENTER", "CENTER")
	Return v
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mWidthExplicit = Props.IsInitialized And Props.ContainsKey("Width")
	mHeightExplicit = Props.IsInitialized And Props.ContainsKey("Height")
	mWidth = Max(1dip, GetPropSizeDip(Props, "Width", ResolveWidthBase(mWidth)))
	mHeight = Max(1dip, GetPropSizeDip(Props, "Height", ResolveHeightBase(mHeight)))
	mState = NormalizeState(B4XDaisyVariants.GetPropString(Props, "State", mState))
	mStyle = NormalizeStyle(B4XDaisyVariants.GetPropString(Props, "SwapStyle", mStyle))
	mAnimationMs = Max(0, B4XDaisyVariants.GetPropInt(Props, "AnimationMs", mAnimationMs))
	mSwapType = NormalizeSwapType(B4XDaisyVariants.GetPropString(Props, "SwapType", mSwapType))
	mTextSize = NormalizeTextSize(B4XDaisyVariants.GetPropString(Props, "TextSize", "text-sm"))
	SyncTextSizeBySwapType
	mOnText = B4XDaisyVariants.GetPropString(Props, "OnText", mOnText)
	mOffText = B4XDaisyVariants.GetPropString(Props, "OffText", mOffText)
	mIndText = B4XDaisyVariants.GetPropString(Props, "IndeterminateText", mIndText)
	mOnColor = B4XDaisyVariants.GetPropInt(Props, "OnColor", mOnColor)
	mOffColor = B4XDaisyVariants.GetPropInt(Props, "OffColor", mOffColor)
	mIndColor = B4XDaisyVariants.GetPropInt(Props, "IndeterminateColor", mIndColor)
	SyncThreeState

	ApplyTextSizeStyle
	RebuildSlotsByType
	AdjustSizeForSwapType(False)
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
	ApplySurfaceStyle(box)
	Dim contentRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutLayers(contentRect)
	ApplyStateVisual(False)
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And Surface.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	Return box
End Sub

Private Sub ResolveContentLocalRect(OuterRect As B4XRect, Box As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(OuterRect, Box)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, Box)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, OuterRect)
End Sub

Private Sub LayoutLayers(ContentRect As B4XRect)
	Dim l As Int = ContentRect.Left
	Dim t As Int = ContentRect.Top
	Dim w As Int = Max(1dip, ContentRect.Width)
	Dim h As Int = Max(1dip, ContentRect.Height)

	OnLayer.SetLayoutAnimated(0, l, t, w, h)
	OffLayer.SetLayoutAnimated(0, l, t, w, h)
	IndLayer.SetLayoutAnimated(0, l, t, w, h)

	LayoutSlotContent(OnLayer, OnContent)
	LayoutSlotContent(OffLayer, OffContent)
	LayoutSlotContent(IndLayer, IndContent)
End Sub

Private Sub LayoutSlotContent(Layer As B4XView, Content As B4XView)
	If Layer.IsInitialized = False Or Content.IsInitialized = False Then Return
	If Content Is Label Then
		Content.SetLayoutAnimated(0, 0, 0, Layer.Width, Layer.Height)
		Content.SetTextAlignment("CENTER", "CENTER")
		If mSwapType = "text" Then FitLabelTextToBounds(Content, Layer.Width, Layer.Height)
		If Content.Tag <> Null And xui.SubExists(Content.Tag, "Base_Resize", 2) Then
			CallSub3(Content.Tag, "Base_Resize", Layer.Width, Layer.Height)
		End If
		Return
	End If

	If Content.NumberOfViews = 0 Then
		Content.SetLayoutAnimated(0, 0, 0, Layer.Width, Layer.Height)
		If Content.Tag <> Null And xui.SubExists(Content.Tag, "Base_Resize", 2) Then
			CallSub3(Content.Tag, "Base_Resize", Layer.Width, Layer.Height)
		End If
		Return
	End If

	Dim child As B4XView = Content.GetView(0)
	Dim baseW As Int = child.Width
	Dim baseH As Int = child.Height
	' When created before attach, child views can report ~1dip; fall back to layer size.
	If baseW <= 1dip Then baseW = Layer.Width
	If baseH <= 1dip Then baseH = Layer.Height
	Dim cw As Int = Max(1dip, Min(Layer.Width, baseW))
	Dim ch As Int = Max(1dip, Min(Layer.Height, baseH))
	Dim cx As Int = Max(0, (Layer.Width - cw) / 2)
	Dim cy As Int = Max(0, (Layer.Height - ch) / 2)
	Content.SetLayoutAnimated(0, 0, 0, Layer.Width, Layer.Height)
	child.SetLayoutAnimated(0, cx, cy, cw, ch)
	If child.Tag <> Null And xui.SubExists(child.Tag, "Base_Resize", 2) Then
		CallSub3(child.Tag, "Base_Resize", cw, ch)
	Else If Content.Tag <> Null And xui.SubExists(Content.Tag, "Base_Resize", 2) Then
		CallSub3(Content.Tag, "Base_Resize", Layer.Width, Layer.Height)
	End If
End Sub

Private Sub FitLabelTextToBounds(Lbl As B4XView, MaxWidth As Int, MaxHeight As Int)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(ResolveTextSizeToken, 14, 20)
	Dim baseFont As Float = tm.GetDefault("font_size", 14)
	Dim baseLine As Float = tm.GetDefault("line_height_dip", 20dip)
	Dim target As Float = baseFont
	Dim t As String = Lbl.Text
	If t = Null Then t = ""
	Dim availW As Float = Max(1dip, MaxWidth)
	Dim availH As Float = Max(1dip, MaxHeight)
	For i = 0 To 24
		Dim lineH As Float = Max(1dip, baseLine * (target / Max(1, baseFont)))
		Dim textW As Float = EstimateFitWidthDip(t, target)
		If textW <= availW And lineH <= availH Then Exit
		target = target * 0.92
		If target <= 8 Then
			target = 8
			Exit
		End If
	Next
	Lbl.TextSize = target
	Lbl.Font = xui.CreateDefaultFont(target)
End Sub

Private Sub EstimateFitWidthDip(Text As String, FontSize As Float) As Float
	Dim t As String = Text
	If t = Null Then t = ""
	t = t.Trim
	If t.Length = 0 Then Return FontSize
	Dim chars As Int = Max(1, t.Length)
	Dim factor As Float = 0.62
	If IsLikelyEmojiText(t) Then factor = 1.05
	Dim widthPx As Float = (chars * FontSize * factor) + (FontSize * 0.9)
	Return Max(12dip, widthPx)
End Sub

Private Sub IsLikelyEmojiText(Value As String) As Boolean
	If Value = Null Then Return False
	Dim s As String = Value.Trim
	If s.Length = 0 Then Return False
	If s.Length > 4 Then Return False
	Return Regex.IsMatch(".*[^\x00-\x7F].*", s)
End Sub

Private Sub ApplySurfaceStyle(Box As Map)
	Dim textColor As Int = ResolveBaseContentColor
	Dim onColor As Int = ResolveOnColor(textColor)
	Dim offColor As Int = ResolveOffColor(textColor)
	Dim indColor As Int = ResolveIndeterminateColor(textColor)

	lblOn.TextColor = onColor
	lblOff.TextColor = offColor
	lblInd.TextColor = indColor
	ApplySlotTint(onColor, offColor, indColor)

	Surface.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
End Sub

Private Sub ApplySlotTint(OnColor As Int, OffColor As Int, IndColor As Int)
	If mSwapType <> "svg" Then Return
	TintSlot(OnContent, OnColor)
	TintSlot(OffContent, OffColor)
	TintSlot(IndContent, IndColor)
End Sub

Private Sub TintSlot(Content As B4XView, ColorValue As Int)
	If Content.IsInitialized = False Then Return
	If Content.NumberOfViews = 0 Then
		If Content.Tag <> Null And xui.SubExists(Content.Tag, "SetColor", 1) Then
			CallSub2(Content.Tag, "SetColor", ColorValue)
		End If
		Return
	End If
	Dim child As B4XView = Content.GetView(0)
	If child.Tag <> Null And xui.SubExists(child.Tag, "SetColor", 1) Then
		CallSub2(child.Tag, "SetColor", ColorValue)
	End If
End Sub

Private Sub ResolveBaseContentColor As Int
	Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(63, 64, 77))
End Sub

Private Sub ResolveOnColor(DefaultColor As Int) As Int
	If mOnColor <> 0 Then Return mOnColor
	Return DefaultColor
End Sub

Private Sub ResolveOffColor(DefaultColor As Int) As Int
	If mOffColor <> 0 Then Return mOffColor
	Return DefaultColor
End Sub

Private Sub ResolveIndeterminateColor(DefaultColor As Int) As Int
	If mIndColor <> 0 Then Return mIndColor
	Return DefaultColor
End Sub

Private Sub ApplyStateVisual(Animate As Boolean)
	If OnLayer.IsInitialized = False Then Return
	Dim st As String = DisplayState
	Dim showOn As Boolean = (st = "on")
	Dim showOff As Boolean = (st = "off")
	Dim showInd As Boolean = (st = "indeterminate")

	Dim rotOn As Float = 0
	Dim rotOff As Float = 0
	Dim rotInd As Float = 0
	Dim rotYOn As Float = 0
	Dim rotYOff As Float = 0
	Dim rotYInd As Float = 0

	Select Case mStyle
		Case "rotate"
			rotOn = IIf(showOn, 0, 45)
			rotOff = IIf(showOff, 0, -45)
			rotInd = IIf(showInd, 0, 45)
		Case "flip"
			rotYOn = IIf(showOn, 0, 180)
			rotYOff = IIf(showOff, 0, -180)
			rotYInd = IIf(showInd, 0, 180)
	End Select

	ApplyLayerVisual(OnLayer, showOn, rotOn, rotYOn, Animate)
	ApplyLayerVisual(OffLayer, showOff, rotOff, rotYOff, Animate)
	ApplyLayerVisual(IndLayer, showInd, rotInd, rotYInd, Animate)

	If showOn Then OnLayer.BringToFront
	If showOff Then OffLayer.BringToFront
	If showInd Then IndLayer.BringToFront
End Sub

Private Sub ApplyLayerVisual(v As B4XView, IsVisible As Boolean, Rotation As Float, RotationY As Float, Animate As Boolean)
	If v.IsInitialized = False Then Return
	#If B4A
	v.Visible = True
	If mStyle = "flip" Then Anim.SetNativeCameraDistance(v, 20000)
	If Animate And mAnimationMs > 0 Then
		Anim.AnimateLayerNative(v, IIf(IsVisible, 1, 0), Rotation, RotationY, mAnimationMs)
	Else
		Anim.SetNativeAlpha(v, IIf(IsVisible, 1, 0))
		Anim.SetNativeRotation(v, Rotation)
		Anim.SetNativeRotationY(v, RotationY)
	End If
	#Else
	If Animate And mAnimationMs > 0 Then
		v.SetVisibleAnimated(mAnimationMs, IsVisible)
	Else
		v.Visible = IsVisible
	End If
	#End If
End Sub

Private Sub DisplayState As String
	Return mState
End Sub

Private Sub SyncThreeState
	mThreeState = IsIndeterminateEnabled(mIndText)
	If mThreeState = False And mState = "indeterminate" Then mState = "off"
End Sub

Private Sub SyncTextSizeBySwapType
	If mSwapType = "text" Then
		If ResolveTextSizeToken.Length = 0 Then mTextSize = "text-md"
	Else
		mTextSize = ""
	End If
End Sub

Private Sub ResolveTextSizeToken As String
	If mTextSize = Null Then Return ""
	Return mTextSize.Trim
End Sub

Private Sub IsIndeterminateEnabled(Value As String) As Boolean
	If Value = Null Then Return False
	Return Value.Trim.Length > 0
End Sub

Private Sub NormalizeState(Value As String) As String
	If Value = Null Then Return "off"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "on", "off", "indeterminate"
			Return s
		Case Else
			Return "off"
	End Select
End Sub

Private Sub NormalizeStyle(Value As String) As String
	If Value = Null Then Return "none"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "none", "rotate", "flip"
			Return s
		Case Else
			Return "none"
	End Select
End Sub


Private Sub NormalizeSwapType(Value As String) As String
	If Value = Null Then Return "text"

	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "text", "svg", "avatar"
			Return s

		Case Else
			Return "text"
	End Select

End Sub


Private Sub NormalizeTextSize(Value As String) As String
	Dim defaultSize As String = "text-sm"

	If Value = Null Then Return defaultSize
	Dim s As String = Value.Trim
	If s.Length = 0 Then Return defaultSize
	Return s
End Sub

Private Sub ApplyTextSizeStyle
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(ResolveTextSizeToken, 14, 20)
	Dim fontSize As Float = tm.GetDefault("font_size", 14)
	mTextLineHeightDip = tm.GetDefault("line_height_dip", 20dip)
	lblOn.TextSize = fontSize
	lblOff.TextSize = fontSize
	lblInd.TextSize = fontSize
	lblOn.Font = xui.CreateDefaultFont(fontSize)
	lblOff.Font = xui.CreateDefaultFont(fontSize)
	lblInd.Font = xui.CreateDefaultFont(fontSize)
End Sub

Private Sub RebuildSlotsByType
	If lblOn.IsInitialized = False Then Return
	Select Case mSwapType
		Case "svg"
			ReplaceSlotContent("on", CreateSvgSlotView(mOnText))
			ReplaceSlotContent("off", CreateSvgSlotView(mOffText))
			ReplaceSlotContent("indeterminate", CreateSvgSlotView(mIndText))
		Case "avatar"
			ReplaceSlotContent("on", CreateAvatarSlotView(mOnText))
			ReplaceSlotContent("off", CreateAvatarSlotView(mOffText))
			ReplaceSlotContent("indeterminate", CreateAvatarSlotView(mIndText))
		Case Else
			lblOn.Text = mOnText
			lblOff.Text = mOffText
			lblInd.Text = mIndText
			ReplaceSlotContent("on", lblOn)
			ReplaceSlotContent("off", lblOff)
			ReplaceSlotContent("indeterminate", lblInd)
	End Select
End Sub

Private Sub CreateSvgSlotView(AssetPath As String) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim host As B4XView = p
	host.Color = xui.Color_Transparent
	Dim path As String = AssetPath
	If path = Null Then path = ""
	path = path.Trim
	If path.Length = 0 Then Return host

	Dim icon As B4XDaisySvgIcon
	icon.Initialize(Me, "")
	Dim sizeDip As Float = ResolveMediaSlotSizeDip
	Dim iconView As B4XView = icon.AddToParent(host, 0, 0, sizeDip, sizeDip)
	icon.SetSvgAsset(path)
	icon.SetPreserveOriginalColors(False)
	icon.SetColor(ResolveBaseContentColor)
	icon.SetSize(ResolvePxSizeSpec(sizeDip))
	iconView.Tag = icon
	Return host
End Sub

Private Sub CreateAvatarSlotView(ImagePath As String) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim host As B4XView = p
	host.Color = xui.Color_Transparent
	Dim path As String = ImagePath
	If path = Null Then path = ""
	path = path.Trim
	If path.Length = 0 Then Return host

	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "")
	Dim aw As Float = Max(16dip, mWidth)
	Dim ah As Float = Max(16dip, mHeight)
	Dim avView As B4XView = av.AddToParent(host, 0, 0, aw, ah)
	av.SetImage(path)
	av.setAvatarMask("rounded-full")
	av.setCenterOnParent(True)
	av.setWidth(ResolvePxSizeSpec(aw))
	av.setHeight(ResolvePxSizeSpec(ah))
	avView.Tag = av
	Return host
End Sub

Private Sub ResolveMediaSlotSizeDip As Float
	Dim baseSize As Float = Min(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	If baseSize <= 1dip Then baseSize = Min(mWidth, mHeight)
	Return Max(16dip, baseSize * 0.72)
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Private Sub AdjustSizeForSwapType(ApplyToBase As Boolean)
	Select Case mSwapType
		Case "text"
			AdjustSizeForTextType(ApplyToBase)
		Case "svg"
			AdjustSizeForSvgType(ApplyToBase)
		Case "avatar"
			AdjustSizeForAvatarType(ApplyToBase)
	End Select
End Sub

Private Sub AdjustSizeForTextType(ApplyToBase As Boolean)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(ResolveTextSizeToken, 14, 20)
	Dim fontSize As Float = tm.GetDefault("font_size", 14)
	Dim lineH As Float = tm.GetDefault("line_height_dip", 20dip)
	If mWidthExplicit And mHeightExplicit Then
		ApplySwapSize(Max(24dip, mWidth), Max(24dip, mHeight), ApplyToBase)
		Return
	End If
	Dim maxTextW As Float = Max(EstimateTextWidthDip(mOnText, fontSize), Max(EstimateTextWidthDip(mOffText, fontSize), EstimateTextWidthDip(mIndText, fontSize)))
	Dim targetW As Float = Max(24dip, maxTextW)
	Dim targetH As Float = Max(24dip, lineH)
	If mWidthExplicit Then targetW = Max(24dip, mWidth)
	If mHeightExplicit Then targetH = Max(24dip, mHeight)
	ApplySwapSize(targetW, targetH, ApplyToBase)
End Sub

Private Sub AdjustSizeForSvgType(ApplyToBase As Boolean)
	Dim targetW As Float = Max(24dip, mWidth)
	Dim targetH As Float = Max(24dip, mHeight)
	ApplySwapSize(targetW, targetH, ApplyToBase)
End Sub

Private Sub AdjustSizeForAvatarType(ApplyToBase As Boolean)
	Dim aw As Float = Max(24dip, mWidth)
	Dim ah As Float = Max(24dip, mHeight)
	Dim targetW As Float = Max(24dip, aw)
	Dim targetH As Float = Max(24dip, ah)
	ApplySwapSize(targetW, targetH, ApplyToBase)
End Sub

Private Sub ApplySwapSize(WidthDip As Float, HeightDip As Float, ApplyToBase As Boolean)
	mWidth = WidthDip
	mHeight = HeightDip
	If ApplyToBase And mBase.IsInitialized Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, mHeight)
	End If
End Sub

Private Sub EstimateTextWidthDip(Text As String, FontSize As Float) As Float
	Dim t As String = Text
	If t = Null Then t = ""
	t = t.Trim
	Dim chars As Int = Max(1, t.Length)
	Dim widthPx As Float = (chars * FontSize * 0.62) + (FontSize * 0.9)
	Return Max(12dip, widthPx)
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
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

Private Sub Refresh
	' Redraw helper used by runtime setters after state/property changes.
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Toggle
	' Cycle state in the same order used by Daisy swap semantics.
	Dim current As String = mState
	If mThreeState Then
		Select Case current
			Case "off"
				mState = "on"
			Case "on"
				mState = "indeterminate"
			Case Else
				mState = "off"
		End Select
	Else
		If current = "on" Then
			mState = "off"
		Else
			mState = "on"
		End If
	End If
	ApplyStateVisual(True)
	RaiseChanged
End Sub

Private Sub surface_Click
	' Surface is the click target; layers are visual-only.
	If mAutoToggle Then Toggle
	RaiseClick
End Sub

Private Sub RaiseChanged
	' Raise optional Changed event with both state token and boolean checked flag.
	Dim st As String = DisplayState
	Dim checked As Boolean = (st = "on")
	If xui.SubExists(mCallBack, mEventName & "_Changed", 2) Then
		CallSub3(mCallBack, mEventName & "_Changed", st, checked)
	Else If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", st)
	End If
End Sub

Private Sub RaiseClick
	' Raise optional Click event with both state token and boolean checked flag.
	Dim st As String = DisplayState
	Dim checked As Boolean = (st = "on")
	If xui.SubExists(mCallBack, mEventName & "_Click", 2) Then
		CallSub3(mCallBack, mEventName & "_Click", st, checked)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", st)
	End If
End Sub

Public Sub SetOnView(v As B4XView)
	' Replace the on-slot content with a caller-provided custom view.
	ReplaceSlotContent("on", v)
End Sub

Public Sub SetOffView(v As B4XView)
	' Replace the off-slot content with a caller-provided custom view.
	ReplaceSlotContent("off", v)
End Sub

Public Sub SetIndeterminateView(v As B4XView)
	' Replace the indeterminate-slot content with a caller-provided custom view.
	ReplaceSlotContent("indeterminate", v)
End Sub

Private Sub ReplaceSlotContent(Slot As String, v As B4XView)
	' Safe content swap: detach old view, mount new view, then relayout that slot.
	If v.IsInitialized = False Then Return
	Dim layer As B4XView = GetSlotLayer(Slot)
	If layer.IsInitialized = False Then Return
	v.RemoveViewFromParent
	layer.RemoveAllViews
	layer.AddView(v, 0, 0, Max(1dip, layer.Width), Max(1dip, layer.Height))
	Select Case NormalizeState(Slot)
		Case "on"
			OnContent = v
		Case "off"
			OffContent = v
		Case "indeterminate"
			IndContent = v
	End Select
	LayoutSlotContent(layer, v)
End Sub

Private Sub GetSlotLayer(Slot As String) As B4XView
	' Map normalized slot token to its owning layer panel.
	Dim s As String = NormalizeState(Slot)
	Select Case s
		Case "on"
			Return OnLayer
		Case "off"
			Return OffLayer
		Case Else
			Return IndLayer
	End Select
End Sub

Public Sub getOnPanel As B4XView
	' Expose on-layer panel for advanced scenarios.
	Return OnLayer
End Sub

Public Sub getOffPanel As B4XView
	' Expose off-layer panel for advanced scenarios.
	Return OffLayer
End Sub

Public Sub getIndeterminatePanel As B4XView
	' Expose indeterminate-layer panel for advanced scenarios.
	Return IndLayer
End Sub

Public Sub setOnText(Value As String)
	' Setter pattern: write state first, then skip UI work until component exists.
	mOnText = Value
	If mBase.IsInitialized = False Then Return
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getOnText As String
	' Return current on text token/content.
	Return mOnText
End Sub

Public Sub setOffText(Value As String)
	' Setter pattern: write state first, then skip UI work until component exists.
	mOffText = Value
	If mBase.IsInitialized = False Then Return
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getOffText As String
	' Return current off text token/content.
	Return mOffText
End Sub

Public Sub setIndeterminateText(Value As String)
	' Enables/disables three-state mode based on whether value is blank/non-blank.
	mIndText = Value
	SyncThreeState
	If mBase.IsInitialized = False Then Return
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getIndeterminateText As String
	' Return current indeterminate text token/content.
	Return mIndText
End Sub

Public Sub setState(Value As String)
	' Set explicit visual state; invalid values are normalized safely.
	Dim n As String = NormalizeState(Value)
	If mThreeState = False And n = "indeterminate" Then n = "off"
	Dim wasSame As Boolean = (mState = n)
	mState = n
	If mBase.IsInitialized = False Then Return
	If wasSame Then Return
	ApplyStateVisual(True)
	RaiseChanged
End Sub

Public Sub getState As String
	' Return current state token: off/on/indeterminate.
	Return mState
End Sub

Public Sub setChecked(Value As Boolean)
	' Convenience boolean setter mapped to off/on states.
	Dim target As String = IIf(Value, "on", "off")
	Dim wasSame As Boolean = (mState = target)
	mState = target
	If mBase.IsInitialized = False Then Return
	If wasSame Then Return
	ApplyStateVisual(True)
	RaiseChanged
End Sub

Public Sub getChecked As Boolean
	' True only when current display state is "on".
	Return DisplayState = "on"
End Sub

Public Sub setSwapStyle(Value As String)
	' Update animation transform style (none/rotate/flip).
	mStyle = NormalizeStyle(Value)
	If mBase.IsInitialized = False Then Return
	ApplyStateVisual(False)
End Sub

Public Sub getSwapStyle As String
	' Return normalized style token.
	Return mStyle
End Sub

Public Sub setSwapType(Value As String)
	' Update content mode (text/svg/avatar) and rebuild slot controls accordingly.
	mSwapType = NormalizeSwapType(Value)
	SyncTextSizeBySwapType
	If mBase.IsInitialized = False Then Return
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getSwapType As String
	' Return normalized swap type token.
	Return mSwapType
End Sub

Public Sub setTextSize(Value As String)
	' Update Tailwind token used to compute font size/line-height for text mode.
	mTextSize = NormalizeTextSize(Value)
	SyncTextSizeBySwapType
	If mBase.IsInitialized = False Then Return
	ApplyTextSizeStyle
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getTextSize As String
	' Return normalized Tailwind text size token.
	Return mTextSize
End Sub

Public Sub getTextLineHeightDip As Float
	' Expose resolved line-height dip used by current text token.
	Return mTextLineHeightDip
End Sub

Public Sub setAnimationMs(Value As Int)
	' Update fade/transform animation duration used by ApplyLayerVisual.
	mAnimationMs = Max(0, Value)
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getAnimationMs As Int
	' Return animation duration in milliseconds.
	Return mAnimationMs
End Sub

Public Sub setWidth(Value As Object)
	' Width accepts Tailwind token/CSS-like value and is converted to dip.
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Int = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, targetH)
	Base_Resize(mWidth, targetH)
End Sub

Public Sub getWidth As Float
	' Return cached width value in dip.
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	' Height accepts Tailwind token/CSS-like value and is converted to dip.
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mHeight)
	Base_Resize(targetW, mHeight)
End Sub

Public Sub getHeight As Float
	' Return cached height value in dip.
	Return mHeight
End Sub

Public Sub setOnColor(Value As Object)
	' On color supports numeric color or theme token name.
	mOnColor = ResolveColorValue(Value, 0)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getOnColor As Int
	' Return resolved on color override (0 means use theme fallback).
	Return mOnColor
End Sub

Public Sub setOnColorVariant(VariantName As String)
	' Resolve and apply on color using a daisy variant name.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", mOnColor)
	setOnColor(c)
End Sub

Public Sub setOnTextColorVariant(VariantName As String)
	' Resolve and apply on text/content color using variant content token.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "text", mOnColor)
	setOnColor(c)
End Sub

Public Sub setOffColor(Value As Object)
	' Off color supports numeric color or theme token name.
	mOffColor = ResolveColorValue(Value, 0)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getOffColor As Int
	' Return resolved off color override (0 means use theme fallback).
	Return mOffColor
End Sub

Public Sub setOffColorVariant(VariantName As String)
	' Resolve and apply off color using a daisy variant name.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", mOffColor)
	setOffColor(c)
End Sub

Public Sub setOffTextColorVariant(VariantName As String)
	' Resolve and apply off text/content color using variant content token.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "text", mOffColor)
	setOffColor(c)
End Sub

Public Sub setIndeterminateColor(Value As Object)
	' Indeterminate color supports numeric color or theme token name.
	mIndColor = ResolveColorValue(Value, 0)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIndeterminateColor As Int
	' Return resolved indeterminate color override (0 means use theme fallback).
	Return mIndColor
End Sub

Public Sub setIndeterminateColorVariant(VariantName As String)
	' Resolve and apply indeterminate color using a daisy variant name.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", mIndColor)
	setIndeterminateColor(c)
End Sub

Public Sub setIndeterminateTextColorVariant(VariantName As String)
	' Resolve and apply indeterminate text/content color using variant content token.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "text", mIndColor)
	setIndeterminateColor(c)
End Sub

Public Sub setTag(Value As Object)
	' Persist caller tag object; forwarded to events as needed.
	mTag = Value
	If mBase.IsInitialized = False Then Return
End Sub



Public Sub getTag As Object
	' Return caller tag object.
	Return mTag
End Sub

Private Sub ResolveColorValue(Value As Object, DefaultColor As Int) As Int
	' Resolve numeric colors directly; string values are interpreted as theme tokens.
	If Value = Null Then Return DefaultColor
	If IsNumber(Value) Then Return Value
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, DefaultColor)
	Return DefaultColor
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
