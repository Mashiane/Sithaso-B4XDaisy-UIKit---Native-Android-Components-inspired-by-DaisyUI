B4A=true
Group=Default Group\DaisyUIKit
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
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-12, Description: Tailwind size token or CSS size (eg w-12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-12, Description: Tailwind size token or CSS size (eg h-12, 80px, 4em, 5rem)
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, Description: Visibility animation in milliseconds

#IgnoreWarnings:12,9
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
	Private miDuration As Int = 300
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
	Private Anim As B4XDaisyAnimation
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	Anim.Initialize
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

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
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

	ApplyDesignerProps(mProps)
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

Private Sub ApplyDesignerProps(mProps As Map)
	mWidthExplicit = mProps.IsInitialized And mProps.ContainsKey("Width")
	mHeightExplicit = mProps.IsInitialized And mProps.ContainsKey("Height")
	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", "w-12"))
	mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", "h-12"))
	mState = NormalizeState(B4XDaisyVariants.GetPropString(mProps, "State", mState))
	mStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "SwapStyle", mStyle))
	miDuration = Max(0, B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration)))
	mSwapType = NormalizeSwapType(B4XDaisyVariants.GetPropString(mProps, "SwapType", mSwapType))
	mTextSize = NormalizeTextSize(B4XDaisyVariants.GetPropString(mProps, "TextSize", mTextSize))
	SyncTextSizeBySwapType
	mOnText = B4XDaisyVariants.GetPropString(mProps, "OnText", mOnText)
	mOffText = B4XDaisyVariants.GetPropString(mProps, "OffText", mOffText)
	mIndText = B4XDaisyVariants.GetPropString(mProps, "IndeterminateText", mIndText)
	mOnColor = B4XDaisyVariants.GetPropInt(mProps, "OnColor", mOnColor)
	mOffColor = B4XDaisyVariants.GetPropInt(mProps, "OffColor", mOffColor)
	mIndColor = B4XDaisyVariants.GetPropInt(mProps, "IndeterminateColor", mIndColor)
	SyncThreeState

	ApplyTextSizeStyle
	RebuildSlotsByType
	AdjustSizeForSwapType(False)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(iWidth))
	props.Put("Height", ResolvePxSizeSpec(iHeight))
	props.Put("SwapType", mSwapType)
	props.Put("SwapStyle", mStyle)
	props.Put("State", mState)
	props.Put("OnText", mOnText)
	props.Put("OffText", mOffText)
	props.Put("IndeterminateText", mIndText)
	props.Put("OnColor", mOnColor)
	props.Put("OffColor", mOffColor)
	props.Put("IndeterminateColor", mIndColor)
	props.Put("TextSize", mTextSize)
	props.Put("Duration", miDuration)
	Return props
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
	ApplySurfaceStyle(box)
	Dim contentRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutLayers(contentRect)
	ApplyStateVisual(False)
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
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

Private Sub ResolveContentLocalRect(rcOuterRect As B4XRect, mBox As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(rcOuterRect, mBox)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, mBox)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, rcOuterRect)
End Sub

Private Sub LayoutLayers(rcContentRect As B4XRect)
	Dim l As Int = rcContentRect.Left
	Dim t As Int = rcContentRect.Top
	Dim w As Int = Max(1dip, rcContentRect.Width)
	Dim h As Int = Max(1dip, rcContentRect.Height)

	OnLayer.SetLayoutAnimated(0, l, t, w, h)
	OffLayer.SetLayoutAnimated(0, l, t, w, h)
	IndLayer.SetLayoutAnimated(0, l, t, w, h)

	LayoutSlotContent(OnLayer, OnContent)
	LayoutSlotContent(OffLayer, OffContent)
	LayoutSlotContent(IndLayer, IndContent)
End Sub

Private Sub LayoutSlotContent(vLayer As B4XView, vContent As B4XView)
	If vLayer.IsInitialized = False Or vContent.IsInitialized = False Then Return
	Try
		If vContent Is Label Then
			vContent.SetLayoutAnimated(0, 0, 0, vLayer.Width, vLayer.Height)
			vContent.SetTextAlignment("CENTER", "CENTER")
			If mSwapType = "text" Then FitLabelTextToBounds(vContent, vLayer.Width, vLayer.Height)
			If vContent.Tag <> Null And xui.SubExists(vContent.Tag, "Base_Resize", 2) Then
				CallSub3(vContent.Tag, "Base_Resize", vLayer.Width, vLayer.Height)
			End If
			Return
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySwap.LayoutSlotContent: " & LastException.Message)
		' Not a Label - skip
	End Try

	If vContent.NumberOfViews = 0 Then
		vContent.SetLayoutAnimated(0, 0, 0, vLayer.Width, vLayer.Height)
		If vContent.Tag <> Null And xui.SubExists(vContent.Tag, "Base_Resize", 2) Then
			CallSub3(vContent.Tag, "Base_Resize", vLayer.Width, vLayer.Height)
		End If
		Return
	End If

	Dim child As B4XView = vContent.GetView(0)
	Dim baseW As Int = child.Width
	Dim baseH As Int = child.Height
	' When created before attach, child views can report ~1dip; fall back to layer size.
	If baseW <= 1dip Then baseW = vLayer.Width
	If baseH <= 1dip Then baseH = vLayer.Height
	Dim cw As Int = Max(1dip, Min(vLayer.Width, baseW))
	Dim ch As Int = Max(1dip, Min(vLayer.Height, baseH))
	Dim cx As Int = Max(0, (vLayer.Width - cw) / 2)
	Dim cy As Int = Max(0, (vLayer.Height - ch) / 2)
	vContent.SetLayoutAnimated(0, 0, 0, vLayer.Width, vLayer.Height)
	child.SetLayoutAnimated(0, cx, cy, cw, ch)
	If child.Tag <> Null And xui.SubExists(child.Tag, "Base_Resize", 2) Then
		CallSub3(child.Tag, "Base_Resize", cw, ch)
	Else If vContent.Tag <> Null And xui.SubExists(vContent.Tag, "Base_Resize", 2) Then
		CallSub3(vContent.Tag, "Base_Resize", vLayer.Width, vLayer.Height)
	End If
End Sub

Private Sub FitLabelTextToBounds(vLbl As B4XView, iMaxWidth As Int, iMaxHeight As Int)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(ResolveTextSizeToken, 14, 20)
	Dim baseFont As Float = tm.GetDefault("font_size", 14)
	Dim baseLine As Float = tm.GetDefault("line_height_dip", 20dip)
	Dim target As Float = baseFont
	Dim t As String = vLbl.Text
	If t = Null Then t = ""
	Dim availW As Float = Max(1dip, iMaxWidth)
	Dim availH As Float = Max(1dip, iMaxHeight)
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
	vLbl.TextSize = target
	vLbl.Font = xui.CreateDefaultFont(target)
End Sub

Private Sub EstimateFitWidthDip(sText As String, fFontSize As Float) As Float
	Dim t As String = sText
	If t = Null Then t = ""
	t = t.Trim
	If t.Length = 0 Then Return fFontSize
	Dim chars As Int = Max(1, t.Length)
	Dim factor As Float = 0.62
	If IsLikelyEmojiText(t) Then factor = 1.05
	Dim widthPx As Float = (chars * fFontSize * factor) + (fFontSize * 0.9)
	Return Max(12dip, widthPx)
End Sub

Private Sub IsLikelyEmojiText(sValue As String) As Boolean
	If sValue = Null Then Return False
	Dim s As String = sValue.Trim
	If s.Length = 0 Then Return False
	If s.Length > 4 Then Return False
	Return Regex.IsMatch(".*[^\x00-\x7F].*", s)
End Sub

Private Sub ApplySurfaceStyle(mBox As Map)
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

Private Sub ApplySlotTint(iOnColor As Int, iOffColor As Int, iIndColor As Int)
	If mSwapType <> "svg" Then Return
	TintSlot(OnContent, iOnColor)
	TintSlot(OffContent, iOffColor)
	TintSlot(IndContent, iIndColor)
End Sub

Private Sub TintSlot(vContent As B4XView, iColorValue As Int)
	If vContent.IsInitialized = False Then Return
	If vContent.NumberOfViews = 0 Then
		If vContent.Tag <> Null And xui.SubExists(vContent.Tag, "SetColor", 1) Then
			CallSub2(vContent.Tag, "SetColor", iColorValue)
		End If
		Return
	End If
	Dim child As B4XView = vContent.GetView(0)
	If child.Tag <> Null And xui.SubExists(child.Tag, "SetColor", 1) Then
		CallSub2(child.Tag, "SetColor", iColorValue)
	End If
End Sub

Private Sub ResolveBaseContentColor As Int
	Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(63, 64, 77))
End Sub

Private Sub ResolveOnColor(iDefaultColor As Int) As Int
	If mOnColor <> 0 Then Return mOnColor
	Return iDefaultColor
End Sub

Private Sub ResolveOffColor(iDefaultColor As Int) As Int
	If mOffColor <> 0 Then Return mOffColor
	Return iDefaultColor
End Sub

Private Sub ResolveIndeterminateColor(iDefaultColor As Int) As Int
	If mIndColor <> 0 Then Return mIndColor
	Return iDefaultColor
End Sub

Private Sub ApplyStateVisual(bAnimate As Boolean)
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

	ApplyLayerVisual(OnLayer, showOn, rotOn, rotYOn, bAnimate)
	ApplyLayerVisual(OffLayer, showOff, rotOff, rotYOff, bAnimate)
	ApplyLayerVisual(IndLayer, showInd, rotInd, rotYInd, bAnimate)

	If showOn Then OnLayer.BringToFront
	If showOff Then OffLayer.BringToFront
	If showInd Then IndLayer.BringToFront
End Sub

Private Sub ApplyLayerVisual(vView As B4XView, bIsVisible As Boolean, fRotation As Float, fRotationY As Float, bAnimate As Boolean)
	If vView.IsInitialized = False Then Return
	#If B4A
	vView.Visible = True
	If mStyle = "flip" Then Anim.SetNativeCameraDistance(vView, 20000)
	If bAnimate And miDuration > 0 Then
		Anim.AnimateLayerNative(vView, IIf(bIsVisible, 1, 0), fRotation, fRotationY, miDuration)
	Else
		Anim.SetNativeAlpha(vView, IIf(bIsVisible, 1, 0))
		Anim.SetNativeRotation(vView, fRotation)
		Anim.SetNativeRotationY(vView, fRotationY)
	End If
	#Else
	If bAnimate And miDuration > 0 Then
		vView.SetVisibleAnimated(miDuration, bIsVisible)
	Else
		vView.Visible = bIsVisible
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
		If ResolveTextSizeToken.Length = 0 Then mTextSize = "text-sm"
	Else
		mTextSize = ""
	End If
End Sub

Private Sub ResolveTextSizeToken As String
	If mTextSize = Null Then Return ""
	Return mTextSize.Trim
End Sub

Private Sub IsIndeterminateEnabled(sValue As String) As Boolean
	If sValue = Null Then Return False
	Return sValue.Trim.Length > 0
End Sub

Private Sub NormalizeState(sValue As String) As String
	If sValue = Null Then Return "off"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "on", "off", "indeterminate"
			Return s
		Case Else
			Return "off"
	End Select
End Sub




Private Sub NormalizeSwapType(sValue As String) As String
	If sValue = Null Then Return "text"

	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "text", "svg", "avatar"
			Return s

		Case Else
			Return "text"
	End Select

End Sub


Private Sub NormalizeTextSize(sValue As String) As String
	Dim defaultSize As String = "text-sm"

	If sValue = Null Then Return defaultSize
	Dim s As String = sValue.Trim
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

Private Sub CreateSvgSlotView(sAssetPath As String) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim host As B4XView = p
	host.Color = xui.Color_Transparent
	Dim path As String = sAssetPath
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
	icon.SetClickable(False)
	iconView.Tag = icon
	Return host
End Sub

Private Sub CreateAvatarSlotView(sImagePath As String) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim host As B4XView = p
	host.Color = xui.Color_Transparent
	Dim path As String = sImagePath
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
	av.SetClickable(False)
	avView.Tag = av
	Return host
End Sub

Private Sub ResolveMediaSlotSizeDip As Float
	Dim baseSize As Float = Min(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	If baseSize <= 1dip Then baseSize = Min(mWidth, mHeight)
	Return Max(16dip, baseSize * 0.72)
End Sub

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

Private Sub AdjustSizeForSwapType(bApplyToBase As Boolean)
	Select Case mSwapType
		Case "text"
			AdjustSizeForTextType(bApplyToBase)
		Case "svg"
			AdjustSizeForSvgType(bApplyToBase)
		Case "avatar"
			AdjustSizeForAvatarType(bApplyToBase)
	End Select
End Sub

Private Sub AdjustSizeForTextType(bApplyToBase As Boolean)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(ResolveTextSizeToken, 14, 20)
	Dim fontSize As Float = tm.GetDefault("font_size", 14)
	Dim lineH As Float = tm.GetDefault("line_height_dip", 20dip)
	If mWidthExplicit And mHeightExplicit Then
		ApplySwapSize(Max(24dip, mWidth), Max(24dip, mHeight), bApplyToBase)
		Return
	End If
	Dim maxTextW As Float = Max(EstimateTextWidthDip(mOnText, fontSize), Max(EstimateTextWidthDip(mOffText, fontSize), EstimateTextWidthDip(mIndText, fontSize)))
	Dim targetW As Float = Max(24dip, maxTextW)
	Dim targetH As Float = Max(24dip, lineH)
	If mWidthExplicit Then targetW = Max(24dip, mWidth)
	If mHeightExplicit Then targetH = Max(24dip, mHeight)
	ApplySwapSize(targetW, targetH, bApplyToBase)
End Sub

Private Sub AdjustSizeForSvgType(bApplyToBase As Boolean)
	Dim targetW As Float = Max(24dip, mWidth)
	Dim targetH As Float = Max(24dip, mHeight)
	ApplySwapSize(targetW, targetH, bApplyToBase)
End Sub

Private Sub AdjustSizeForAvatarType(bApplyToBase As Boolean)
	Dim aw As Float = Max(24dip, mWidth)
	Dim ah As Float = Max(24dip, mHeight)
	Dim targetW As Float = Max(24dip, aw)
	Dim targetH As Float = Max(24dip, ah)
	ApplySwapSize(targetW, targetH, bApplyToBase)
End Sub

Private Sub ApplySwapSize(fWidthDip As Float, fHeightDip As Float, bApplyToBase As Boolean)
	mWidth = fWidthDip
	mHeight = fHeightDip
	If bApplyToBase And mBase.IsInitialized Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, mHeight)
	End If
End Sub

Private Sub EstimateTextWidthDip(sText As String, fFontSize As Float) As Float
	Dim t As String = sText
	If t = Null Then t = ""
	t = t.Trim
	Dim chars As Int = Max(1, t.Length)
	Dim widthPx As Float = (chars * fFontSize * 0.62) + (fFontSize * 0.9)
	Return Max(12dip, widthPx)
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

Public Sub SetOnView(vView As B4XView)
	' Replace the on-slot content with a caller-provided custom view.
	ReplaceSlotContent("on", vView)
End Sub

Public Sub SetOffView(vView As B4XView)
	' Replace the off-slot content with a caller-provided custom view.
	ReplaceSlotContent("off", vView)
End Sub

Public Sub SetIndeterminateView(vView As B4XView)
	' Replace the indeterminate-slot content with a caller-provided custom view.
	ReplaceSlotContent("indeterminate", vView)
End Sub

Private Sub ReplaceSlotContent(sSlot As String, vView As B4XView)
	' Safe content swap: detach old view, mount new view, then relayout that slot.
	If vView.IsInitialized = False Then Return
	Dim layer As B4XView = GetSlotLayer(sSlot)
	If layer.IsInitialized = False Then Return
	vView.RemoveViewFromParent
	layer.RemoveAllViews
	layer.AddView(vView, 0, 0, Max(1dip, layer.Width), Max(1dip, layer.Height))
	Select Case NormalizeState(sSlot)
		Case "on"
			OnContent = vView
		Case "off"
			OffContent = vView
		Case "indeterminate"
			IndContent = vView
	End Select
	LayoutSlotContent(layer, vView)
	EnsureContentNonClickable(vView)
End Sub

Private Sub EnsureContentNonClickable(vView As B4XView)
	' Slot content must never steal the click that belongs to Surface.
	If vView.IsInitialized = False Then Return
	TryDisableClickable(vView.Tag)
	' Only ViewGroup hosts (Panel) expose children. Labels/ImageViews are not
	' ViewGroups and would throw 'Type does not match' on NumberOfViews.
	If vView Is Panel Then
		If vView.NumberOfViews > 0 Then TryDisableClickable(vView.GetView(0).Tag)
	End If
End Sub

Private Sub TryDisableClickable(oTagObj As Object)
	' If the slot content (or its child) is a clickable Daisy component, force it
	' passive so touches fall through to Surface and the swap toggles.
	If oTagObj = Null Then Return
	If xui.SubExists(oTagObj, "setClickable", 1) Then CallSub2(oTagObj, "setClickable", False)
End Sub

Private Sub GetSlotLayer(sSlot As String) As B4XView
	' Map normalized slot token to its owning layer panel.
	Dim s As String = NormalizeState(sSlot)
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

Public Sub setOnText(sValue As String)
	' Setter pattern: write state first, then skip UI work until component exists.
	mOnText = sValue
	If mBase.IsInitialized = False Then Return
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getOnText As String
	' Return current on text token/content.
	Return mOnText
End Sub

Public Sub setOffText(sValue As String)
	' Setter pattern: write state first, then skip UI work until component exists.
	mOffText = sValue
	If mBase.IsInitialized = False Then Return
	RebuildSlotsByType
	AdjustSizeForSwapType(True)
	Refresh
End Sub

Public Sub getOffText As String
	' Return current off text token/content.
	Return mOffText
End Sub

Public Sub setIndeterminateText(sValue As String)
	' Enables/disables three-state mode based on whether value is blank/non-blank.
	mIndText = sValue
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

Public Sub setState(sValue As String)
	' Set explicit visual state; invalid values are normalized safely.
	Dim n As String = NormalizeState(sValue)
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

Public Sub setChecked(bValue As Boolean)
	' Convenience boolean setter mapped to off/on states.
	Dim target As String = IIf(bValue, "on", "off")
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

Public Sub setSwapStyle(sValue As String)
	' Update animation transform style (none/rotate/flip).
	mStyle = B4XDaisyVariants.NormalizeStyle(sValue)
	If mBase.IsInitialized = False Then Return
	ApplyStateVisual(False)
End Sub

Public Sub getSwapStyle As String
	' Return normalized style token.
	Return mStyle
End Sub

Public Sub setSwapType(sValue As String)
	' Update content mode (text/svg/avatar) and rebuild slot controls accordingly.
	mSwapType = NormalizeSwapType(sValue)
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

Public Sub setTextSize(sValue As String)
	' Update Tailwind token used to compute font size/line-height for text mode.
	mTextSize = NormalizeTextSize(sValue)
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

Public Sub setDuration(iValue As Int)
	' Update fade/transform animation duration used by ApplyLayerVisual.
	miDuration = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getDuration As Int
	' Return animation duration in milliseconds.
	Return miDuration
End Sub



Public Sub setWidth(oValue As Object)
	' Width accepts Tailwind token/CSS-like value and is converted to dip.
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
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

Public Sub setHeight(oValue As Object)
	' Height accepts Tailwind token/CSS-like value and is converted to dip.
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
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

Public Sub setOnColor(oValue As Object)
	' On color supports numeric color or theme token name.
	mOnColor = ResolveColorValue(oValue, 0)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getOnColor As Int
	' Return resolved on color override (0 means use theme fallback).
	Return mOnColor
End Sub

Public Sub setOnColorVariant(sVariantName As String)
	' Resolve and apply on color using a daisy variant name.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "back", mOnColor)
	setOnColor(c)
End Sub

Public Sub setOnTextColorVariant(sVariantName As String)
	' Resolve and apply on text/content color using variant content token.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "text", mOnColor)
	setOnColor(c)
End Sub

Public Sub setOffColor(oValue As Object)
	' Off color supports numeric color or theme token name.
	mOffColor = ResolveColorValue(oValue, 0)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getOffColor As Int
	' Return resolved off color override (0 means use theme fallback).
	Return mOffColor
End Sub

Public Sub setOffColorVariant(sVariantName As String)
	' Resolve and apply off color using a daisy variant name.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "back", mOffColor)
	setOffColor(c)
End Sub

Public Sub setOffTextColorVariant(sVariantName As String)
	' Resolve and apply off text/content color using variant content token.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "text", mOffColor)
	setOffColor(c)
End Sub

Public Sub setIndeterminateColor(oValue As Object)
	' Indeterminate color supports numeric color or theme token name.
	mIndColor = ResolveColorValue(oValue, 0)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIndeterminateColor As Int
	' Return resolved indeterminate color override (0 means use theme fallback).
	Return mIndColor
End Sub

Public Sub setIndeterminateColorVariant(sVariantName As String)
	' Resolve and apply indeterminate color using a daisy variant name.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "back", mIndColor)
	setIndeterminateColor(c)
End Sub

Public Sub setIndeterminateTextColorVariant(sVariantName As String)
	' Resolve and apply indeterminate text/content color using variant content token.
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "text", mIndColor)
	setIndeterminateColor(c)
End Sub

Public Sub setTag(oValue As Object)
	' Persist caller tag object; forwarded to events as needed.
	mTag = oValue
	If mBase.IsInitialized = False Then Return
End Sub



Public Sub getTag As Object
	' Return caller tag object.
	Return mTag
End Sub

Private Sub ResolveColorValue(oValue As Object, iDefaultColor As Int) As Int
	' Resolve numeric colors directly; string values are interpreted as theme tokens.
	If oValue = Null Then Return iDefaultColor
	If IsNumber(oValue) Then Return oValue
	Dim s As String = oValue
	s = s.Trim
	If s.Length = 0 Then Return iDefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, iDefaultColor)
	Return iDefaultColor
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region
