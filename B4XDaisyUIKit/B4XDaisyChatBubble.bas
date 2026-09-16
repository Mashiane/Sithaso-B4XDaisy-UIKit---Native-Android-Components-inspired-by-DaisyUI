B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
'B4XChatBubble.bas
'Chat bubble inspired by daisyUI chat component, native XUI + cached drawing

#Event: AvatarClick (Payload As Object)
#Event: BubbleClick (Tag As Object)

#DesignerProperty: Key: AvatarMask, DisplayName: Avatar Mask, FieldType: String, DefaultValue: squircle, List: circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2, Description: Mask shape used for the bubble avatar
#DesignerProperty: Key: AvatarSize, DisplayName: Avatar Size, FieldType: Int, DefaultValue: 40, Description: Avatar size in dip
#DesignerProperty: Key: Id, DisplayName: Id, FieldType: String, DefaultValue:, Description: Message author id
#DesignerProperty: Key: FromId, DisplayName: From Id, FieldType: String, DefaultValue:, Description: Current user id used to resolve outgoing side
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: neutral, List: neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant for bubble colors
#DesignerProperty: Key: Side, DisplayName: Side, FieldType: String, DefaultValue: start, List: start|end, Description: Bubble alignment when id-based side is not used
#DesignerProperty: Key: BubbleStyle, DisplayName: Bubble Style, FieldType: String, DefaultValue: rounded, List: rounded|block, Description: Bubble visual style
#DesignerProperty: Key: MaxWidthPercent, DisplayName: Max Width %, FieldType: Int, DefaultValue: 90, Description: Maximum bubble width as a percent of row width
#DesignerProperty: Key: UseFromToColors, DisplayName: Use From/To Colors, FieldType: Boolean, DefaultValue: False, Description: Use explicit from/to colors instead of variant defaults
#DesignerProperty: Key: FromBackgroundColor, DisplayName: From Background, FieldType: Color, DefaultValue: 0xFFE5E7EB, Description: Background color for outgoing (from) bubbles
#DesignerProperty: Key: FromTextColor, DisplayName: From Text, FieldType: Color, DefaultValue: 0xFF111827, Description: Text color for outgoing (from) bubbles
#DesignerProperty: Key: ToBackgroundColor, DisplayName: To Background, FieldType: Color, DefaultValue: 0xFFDBEAFE, Description: Background color for incoming (to) bubbles
#DesignerProperty: Key: ToTextColor, DisplayName: To Text, FieldType: Color, DefaultValue: 0xFF1E3A8A, Description: Text color for incoming (to) bubbles
#DesignerProperty: Key: ShowOnline, DisplayName: Show Online Indicator, FieldType: Boolean, DefaultValue: True, Description: Show avatar online/offline indicator
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind/spacing padding utilities (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object

	'Layout tokens
	Private Gap As Float = 2dip
	Private OuterMargin As Float = 10dip
	Private PaddingH As Float = 16dip
	Private PaddingV As Float = 8dip
	Private RowPadY As Float = 4dip
	Private RowMetaGapY As Float = 4dip
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mAvatarSize As Float = 40dip
	Private TailSize As Float = 11dip
	Private Corner As Float = 18dip
	Private MaxWidthPct As Float = 0.90
	Private MinBubbleWidth As Int = 44dip   'requested minimum width
	Private MinBubbleHeight As Int = 32dip  '2rem-ish
	Private mBubbleStyle As String = "rounded" 'rounded|block

	'Options
	Private mSide As String = "start" 'start|end
	Private mVariant As String = "neutral"
	Private ShowOutline As Boolean = False
	Private OutlineColor As Int = 0
	Private OutlineWidth As Float = 1dip
	Private BubbleId As String = ""
	Private BubbleFromId As String = ""

	Private AvatarVisible As Boolean = True
	Private AvatarBmp As B4XBitmap
	Private AvatarTag As Object
	Private AvatarStatus As String = "none" 'none|online|offline
	Private AvatarBorderWidth As Float = 1.2dip
	Private AvatarBorderInset As Float = 1.5dip
	Private AvatarBorderColor As Int = 0xFFF5F5F5
	Private mAvatarMask As String = "squircle" 'circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2
	Private OnlineIndicatorVisible As Boolean = True
	Private AvatarOnlineColor As Int = 0xFF2ECC71
	Private AvatarOfflineColor As Int = 0xFFB4B4B4
	
	Private mUseFromToColors As Boolean = False
	Private mFromBackgroundColor As Int = 0xFFE5E7EB
	Private mFromTextColor As Int = 0xFF111827
	Private mToBackgroundColor As Int = 0xFFDBEAFE
	Private mToTextColor As Int = 0xFF1E3A8A
	Private VariantPalette As Map
	Private DefaultVariantPalette As Map

	Private HeaderText As String = ""
	Private HeaderTimeText As String = ""
	Private FooterText As String = ""
	Private MessageText As String = ""
	Private HeaderVisible As Boolean = True
	Private HeaderNameVisible As Boolean = True
	Private HeaderTimeVisible As Boolean = True
	Private FooterVisible As Boolean = True
	Private BubbleVisible As Boolean = True

	'Status
	Private StatusMode As String = "none" 'none|sent|delivered|read
	Private StatusText As String = ""     'optional extra text

	'Overrides
	Private OverrideBackColor As Int = 0
	Private OverrideTextColor As Int = 0
	Private OverrideMutedColor As Int = 0

	'Views
	Private pnlRow As B4XView
	Private ivAvatar As B4XView
	Private ChatAvatar As B4XDaisyAvatar
	Private pnlBubble As B4XView
	Private ivBubbleBg As B4XView

	Private lblHeaderName As B4XView
	Private lblHeaderTime As B4XView
	Private lblFooter As B4XView

	'Content slot
	Private pnlContent As B4XView
	Private lblMessage As B4XView
	Private ivContent As B4XView
	Private CustomContent As B4XView
	Private ContentMode As String = "text" 'text|image|custom
	Private ContentImage As B4XBitmap
	Private ContentImageMaxH As Int = 220dip
	Private DebugBorders As Boolean = False

	'Drawing cache
	Private cvs As B4XCanvas
	Private CanvasReady As Boolean = False
	Private LastW As Int = -1, LastH As Int = -1
	Private LastBack As Int = 0
	Private LastSide As String = ""
	Private LastTail As Boolean = True
	Private LastOutline As Boolean = False
	Private LastOutlineColor As Int = 0
	Private LastOutlineWidth As Int = 0
	Private LastStyle As String = ""

	Private tu As StringUtils
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	InitializeDefaultPalette
End Sub

'Programmatic creation path (without loading from Designer)
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim pp As Panel
	pp.Initialize("")
	Dim p As B4XView = pp
	p.Color = xui.Color_Transparent
	p.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(p, dummy, BuildRuntimeProps(iWidth, iHeight))
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView)
	AddToParentAt(vParent, 0, 0, vParent.Width, vParent.Height)
End Sub

Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If vParent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim v As B4XView = CreateView(w, h)
	vParent.AddView(v, iLeft, iTop, w, h)
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub AddViewToContent(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If pnlContent.IsInitialized Then
		pnlContent.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
		Return
	End If
	If mBase.IsInitialized Then mBase.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And pnlRow.IsInitialized And mBase.Width > 0
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBase.Color = xui.Color_Transparent

	Dim pRow As Panel
	pRow.Initialize("")
	pnlRow = pRow
	pnlRow.Color = xui.Color_Transparent
	mBase.AddView(pnlRow, 0, 0, mBase.Width, mBase.Height)

	'Avatar (shared Daisy avatar renderer)
	Dim da As B4XDaisyAvatar
	da.Initialize(Me, "chatavatar")
	ChatAvatar = da
	ivAvatar = ChatAvatar.CreateView(mAvatarSize, mAvatarSize)
	ivAvatar.Color = xui.Color_Transparent
	pnlRow.AddView(ivAvatar, 0, 0, mAvatarSize, mAvatarSize)

	'Bubble
	Dim pBubble As Panel
	pBubble.Initialize("")
	pnlBubble = pBubble
	pnlBubble.Color = xui.Color_Transparent
	pnlRow.AddView(pnlBubble, 0, 0, 100dip, 50dip)

	Dim pBg As Panel
	pBg.Initialize("")
	ivBubbleBg = pBg
	ivBubbleBg.Color = xui.Color_Transparent
	pnlBubble.AddView(ivBubbleBg, 0, 0, pnlBubble.Width, pnlBubble.Height)

	'Header / Footer
	lblHeaderName = CreateLabel(11, False, True)
	lblHeaderTime = CreateLabel(11, False, True)
	lblFooter = CreateLabel(11, False, True)

	pnlRow.AddView(lblHeaderName, 0, 0, 10dip, 10dip)
	pnlRow.AddView(lblHeaderTime, 0, 0, 10dip, 10dip)
	pnlRow.AddView(lblFooter, 0, 0, 10dip, 10dip)

	'Content slot panel
	Dim pContent As Panel
	pContent.Initialize("")
	pnlContent = pContent
	pnlContent.Color = xui.Color_Transparent
	pnlBubble.AddView(pnlContent, 0, 0, 10dip, 10dip)

	'Text content
	lblMessage = CreateLabel(14, False, False)
	lblMessage.SetTextAlignment("TOP", "LEFT")
	pnlContent.AddView(lblMessage, 0, 0, 10dip, 10dip)

	'Image content
	Dim iv3 As ImageView
	iv3.Initialize("")
	ivContent = iv3
	pnlContent.AddView(ivContent, 0, 0, 10dip, 10dip)
	ivContent.Visible = False
	
	ApplyDesignerProps(mProps)

	setVariant(mVariant)
	setSide(mSide)

	'Soft elevation where supported (keep subtle)
	ApplyElevation(2dip)
End Sub

Private Sub CreateLabel(fSize As Float, bBold As Boolean, bSingleLine As Boolean) As B4XView
	Dim l As Label
	l.Initialize("")
	l.SingleLine = bSingleLine
	Dim v As B4XView = l
	v.Color = xui.Color_Transparent
	Dim f As B4XFont
	If bBold Then f = xui.CreateDefaultBoldFont(fSize) Else f = xui.CreateDefaultFont(fSize)
	v.Font = f
	Return v
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	
	mAvatarMask = B4XDaisyVariants.NormalizeMask(B4XDaisyVariants.GetPropString(mProps, "AvatarMask", mAvatarMask))
	mAvatarSize = Max(16dip, B4XDaisyVariants.GetPropDip(mProps, "AvatarSize", 40))
	setSide(B4XDaisyVariants.GetPropString(mProps, "Side", mSide))
	setBubbleStyle(B4XDaisyVariants.GetPropString(mProps, "BubbleStyle", mBubbleStyle))
	Dim mwp As Float = B4XDaisyVariants.GetPropFloat(mProps, "MaxWidthPercent", 90)
	If mwp > 1 Then mwp = mwp / 100
	setMaxWidthPercent(mwp)
	'Backward compatibility with older designer keys.
	If mProps.ContainsKey("AvatarWidth") Then mAvatarSize = Max(16dip, B4XDaisyVariants.GetPropDip(mProps, "AvatarWidth", mAvatarSize))
	If mProps.ContainsKey("AvatarHeight") Then mAvatarSize = Max(16dip, B4XDaisyVariants.GetPropDip(mProps, "AvatarHeight", mAvatarSize))
	OnlineIndicatorVisible = B4XDaisyVariants.GetPropBool(mProps, "ShowOnline", True)
	
	mUseFromToColors = B4XDaisyVariants.GetPropBool(mProps, "UseFromToColors", mUseFromToColors)
	mFromBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "FromBackgroundColor", mFromBackgroundColor)
	mFromTextColor = B4XDaisyVariants.GetPropInt(mProps, "FromTextColor", mFromTextColor)
	mToBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "ToBackgroundColor", mToBackgroundColor)
	mToTextColor = B4XDaisyVariants.GetPropInt(mProps, "ToTextColor", mToTextColor)
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	BubbleId = B4XDaisyVariants.GetPropString(mProps, "Id", "")
	BubbleFromId = B4XDaisyVariants.GetPropString(mProps, "FromId", "")
	setVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("AvatarMask", mAvatarMask)
	props.Put("AvatarSize", mAvatarSize / 1dip)
	props.Put("Side", mSide)
	props.Put("BubbleStyle", mBubbleStyle)
	props.Put("MaxWidthPercent", Round(MaxWidthPct * 100))
	props.Put("ShowOnline", OnlineIndicatorVisible)
	props.Put("UseFromToColors", mUseFromToColors)
	props.Put("FromBackgroundColor", mFromBackgroundColor)
	props.Put("FromTextColor", mFromTextColor)
	props.Put("ToBackgroundColor", mToBackgroundColor)
	props.Put("ToTextColor", mToTextColor)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("Id", BubbleId)
	props.Put("FromId", BubbleFromId)
	props.Put("Variant", mVariant)
	Return props
End Sub



Private Sub ResolveContentRectForBounds(fWidth As Float, fHeight As Float) As B4XRect
	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, fWidth), Max(1dip, fHeight))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Return B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
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

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If pnlRow.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim contentRect As B4XRect = ResolveContentRectForBounds(dWidth, dHeight)
	pnlRow.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	LayoutNow(contentRect.Width, contentRect.Height)
	inResize = False
End Sub

Public Sub setId(sValue As String)
	If sValue = Null Then
		BubbleId = ""
	Else
		BubbleId = sValue
	End If
End Sub

Public Sub getId As String
	Return BubbleId
End Sub

Public Sub setFromId(sValue As String)
	If sValue = Null Then
		BubbleFromId = ""
	Else
		BubbleFromId = sValue
	End If
End Sub

Public Sub getFromId As String
	Return BubbleFromId
End Sub

Public Sub GetUsedHeight As Int
	Dim w As Int = 320dip
	If mBase.IsInitialized And mBase.Width > 0 Then w = mBase.Width
	Return MeasureHeight(w)
End Sub

'-
' Public API (daisy-like)
'-

Public Sub setSide(sValue As String)
	If sValue <> "start" And sValue <> "end" Then sValue = "start"
	mSide = sValue
End Sub

Public Sub getSide As String
	Return mSide
End Sub

Public Sub setVariant(sV As String)
	If sV = Null Then
		mVariant = "neutral"
		Return
	End If
	mVariant = sV.ToLowerCase.Trim
	If mVariant.Length = 0 Then mVariant = "neutral"
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setBubbleStyle(sStyleName As String)
	Dim s As String = sStyleName.ToLowerCase.Trim
	If s <> "block" Then s = "rounded"
	mBubbleStyle = s
End Sub

Public Sub SetOutline(bEnabled As Boolean, iColor As Int, fWidth As Float)
	ShowOutline = bEnabled
	OutlineColor = iColor
	OutlineWidth = fWidth
End Sub

Public Sub getBubbleStyle As String
	Return mBubbleStyle
End Sub

Public Sub setMaxWidthPercent(fP As Float)
	If fP < 0.3 Then fP = 0.3
	If fP > 0.95 Then fP = 0.95
	MaxWidthPct = fP
End Sub

Public Sub getMaxWidthPercent As Float
	Return MaxWidthPct
End Sub

Public Sub setPadding(sValue As String)
	mPadding = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
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

Public Sub SetAvatarVisible(bValue As Boolean)
	AvatarVisible = bValue
End Sub

Public Sub SetAvatarBitmap(bmpBmp As B4XBitmap, oTag As Object)
	AvatarBmp = bmpBmp
	AvatarTag = oTag
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarStatus(sMode As String)
	Dim m As String = sMode.ToLowerCase
	If m <> "online" And m <> "offline" Then m = "none"
	AvatarStatus = m
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarStatusColors(iOnlineColor As Int, iOfflineColor As Int)
	If iOnlineColor <> 0 Then AvatarOnlineColor = iOnlineColor
	If iOfflineColor <> 0 Then AvatarOfflineColor = iOfflineColor
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub GetAvatarOnlineColor As Int
	Return AvatarOnlineColor
End Sub

Public Sub GetAvatarOfflineColor As Int
	Return AvatarOfflineColor
End Sub

Public Sub SetAvatarBorder(iColor As Int, fWidth As Float)
	AvatarBorderColor = iColor
	AvatarBorderWidth = Max(0, fWidth)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarBorderInset(fInset As Float)
	AvatarBorderInset = Max(0, fInset)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setAvatarMask(sMaskName As String)
	mAvatarMask = B4XDaisyVariants.NormalizeMask(sMaskName)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarMask As String
	Return mAvatarMask
End Sub

Public Sub SetGlobalMask(sMaskName As String)
	setAvatarMask(sMaskName)
End Sub

Public Sub setAvatarSize(fSize As Float)
	mAvatarSize = Max(16dip, fSize)
End Sub

Public Sub SetAvatarWidth(fWidth As Float)
	mAvatarSize = Max(16dip, fWidth)
End Sub

Public Sub SetAvatarHeight(fHeight As Float)
	mAvatarSize = Max(16dip, fHeight)
End Sub

Public Sub GetAvatarWidth As Float
	Return mAvatarSize
End Sub

Public Sub GetAvatarHeight As Float
	Return mAvatarSize
End Sub

Public Sub getAvatarSize As Float
	Return mAvatarSize
End Sub

Public Sub setShowOnline(bShow As Boolean)
	OnlineIndicatorVisible = bShow
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShowOnline As Boolean
	Return OnlineIndicatorVisible
End Sub

Public Sub setFromBackgroundColor(iColor As Int)
	mFromBackgroundColor = iColor
	mUseFromToColors = True
End Sub

Public Sub getFromBackgroundColor As Int
	Return mFromBackgroundColor
End Sub

Public Sub setFromTextColor(iColor As Int)
	mFromTextColor = iColor
	mUseFromToColors = True
End Sub

Public Sub getFromTextColor As Int
	Return mFromTextColor
End Sub

Public Sub setToBackgroundColor(iColor As Int)
	mToBackgroundColor = iColor
	mUseFromToColors = True
End Sub

Public Sub getToBackgroundColor As Int
	Return mToBackgroundColor
End Sub

Public Sub setToTextColor(iColor As Int)
	mToTextColor = iColor
	mUseFromToColors = True
End Sub

Public Sub getToTextColor As Int
	Return mToTextColor
End Sub

Public Sub SetFromToColors(iFromBack As Int, iFromText As Int, iToBack As Int, iToText As Int)
	mFromBackgroundColor = iFromBack
	mFromTextColor = iFromText
	mToBackgroundColor = iToBack
	mToTextColor = iToText
	mUseFromToColors = True
End Sub

Public Sub setUseFromToColors(bEnabled As Boolean)
	mUseFromToColors = bEnabled
End Sub

Public Sub getUseFromToColors As Boolean
	Return mUseFromToColors
End Sub

Public Sub SetVariantPalette(mPalette As Map)
	InitializeDefaultPalette
	If mPalette.IsInitialized Then
		VariantPalette = mPalette
	Else
		VariantPalette = DefaultVariantPalette
	End If
End Sub

Public Sub GetVariantPalette As Map
	InitializeDefaultPalette
	Return VariantPalette
End Sub

Public Sub SetColors(iBackOverride As Int, iTextOverride As Int, iMutedOverride As Int)
	OverrideBackColor = iBackOverride
	OverrideTextColor = iTextOverride
	OverrideMutedColor = iMutedOverride
End Sub

Public Sub SetHeader(sText As String)
	HeaderText = sText
End Sub

Public Sub SetHeaderTime(sText As String)
	HeaderTimeText = sText
End Sub

Public Sub SetHeaderParts(sNameText As String, sTimeText As String)
	HeaderText = sNameText
	HeaderTimeText = sTimeText
End Sub

Public Sub SetHeaderVisible(bValue As Boolean)
	HeaderVisible = bValue
End Sub

Public Sub SetHeaderNameVisible(bValue As Boolean)
	HeaderNameVisible = bValue
End Sub

Public Sub SetHeaderTimeVisible(bValue As Boolean)
	HeaderTimeVisible = bValue
End Sub

Public Sub SetFooter(sText As String)
	FooterText = sText
End Sub

Public Sub SetFooterVisible(bValue As Boolean)
	FooterVisible = bValue
End Sub

Public Sub SetMessage(sText As String)
	MessageText = sText
	ContentMode = "text"
End Sub

Public Sub SetBubbleVisible(bValue As Boolean)
	BubbleVisible = bValue
End Sub

Public Sub SetDebugBorders(bEnabled As Boolean)
	DebugBorders = bEnabled
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub GetDebugBorders As Boolean
	Return DebugBorders
End Sub

Public Sub SetStatus(sMode As String, sExtraText As String)
	'Mode: none|sent|delivered|read
	StatusMode = NormalizeStatusMode(sMode)
	StatusText = sExtraText
End Sub

Private Sub NormalizeStatusMode(sMode As String) As String
	If sMode = Null Then Return "none"
	Dim m As String = sMode.ToLowerCase.Trim
	Select Case m
		Case "sent", "delivered", "read"
			Return m
		Case Else
			Return "none"
	End Select
End Sub

'Content slot: image
Public Sub SetImage(bmpBmp As B4XBitmap, iMaxHeight As Int)
	ContentImage = bmpBmp
	If iMaxHeight > 0 Then ContentImageMaxH = iMaxHeight
	ContentMode = "image"
End Sub

'Content slot: custom view
Public Sub SetCustomContent(vView As B4XView)
	CustomContent = vView
	ContentMode = "custom"
End Sub

'Convenience: set all in one go
Public Sub SetContentAll(sHeader As String, sBody As String, sFooter As String, sSideNow As String, sVariantNow As String)
	SetHeader(sHeader)
	SetMessage(sBody)
	SetFooter(sFooter)
	setSide(sSideNow)
	setVariant(sVariantNow)
End Sub

'CLV: measure row height given available row width
Public Sub MeasureHeight(iAvailableWidth As Int) As Int
	Dim sideEff As String = EffectiveSide
	Dim bubbleW As Int = ComputeBubbleWidth(iAvailableWidth)
	Dim tailLeft As Int = IIf(sideEff="start", TailSize, 0)
	Dim tailRight As Int = IIf(sideEff="end", TailSize, 0)
	Dim contentW As Int = bubbleW - (PaddingH*2) - tailLeft - tailRight
	If contentW < 80dip Then contentW = 80dip
	Dim bubbleBodyW As Int = bubbleW - tailLeft - tailRight
	If bubbleBodyW < 80dip Then bubbleBodyW = 80dip

	Dim showHeaderName As Boolean = HeaderVisible And HeaderNameVisible And HeaderText.Length > 0
	Dim showHeaderTime As Boolean = HeaderVisible And HeaderTimeVisible And HeaderTimeText.Length > 0
	Dim headerLayout As Map = ResolveHeaderLayoutWidths(bubbleBodyW, showHeaderName, showHeaderTime)
	Dim nameW As Int = headerLayout.Get("name_w")
	Dim timeW As Int = headerLayout.Get("time_w")
	Dim hh As Int = 0
	If showHeaderName Or showHeaderTime Then
		Dim hName As Int = IIf(showHeaderName, MeasureSingleLineHeight(lblHeaderName), 0)
		Dim hTime As Int = IIf(showHeaderTime, MeasureSingleLineHeight(lblHeaderTime), 0)
		hh = Max(hName, hTime)
	End If

	Dim bodyH As Int
	If BubbleVisible Then
		Select Case ContentMode
			Case "text"
				bodyH = MeasureLabelHeight(lblMessage, MessageText, contentW)
			Case "image"
				bodyH = MeasureImageHeight(contentW)
			Case "custom"
				bodyH = 60dip 'fallback; custom content should be sized by caller
		End Select
	Else
		bodyH = 0
	End If

	Dim footerCombined As String = FooterComposite
	Dim fh As Int = 0
	If FooterVisible And footerCombined.Length > 0 Then
		fh = MeasureSingleLineHeight(lblFooter)
	End If

	Dim minVisualBubbleH As Int = Max(44dip, IIf(AvatarVisible, mAvatarSize, 0))
	Dim bubbleH As Int = IIf(BubbleVisible, Max(Max(MinBubbleHeight, minVisualBubbleH), PaddingV + bodyH + PaddingV), 0)
	Dim rowH As Int = (RowPadY * 2) + IIf(hh > 0, hh + RowMetaGapY, 0) + bubbleH + IIf(fh > 0, RowMetaGapY + fh, 0)
	rowH = Max(rowH, (RowPadY * 2) + IIf(hh > 0, hh + RowMetaGapY, 0) + IIf(AvatarVisible, mAvatarSize, 0))
	Return rowH
End Sub

'-
' Layout & drawing
'-

Private Sub LayoutNow(iRowW As Int, iRowH As Int)
	Dim sideEff As String = EffectiveSide
	'Colors (theme + overrides)
	Dim cmap As Map
	cmap = ResolveColors
	Dim back As Int = cmap.Get("back")
	Dim txt As Int = cmap.Get("text")
	Dim muted As Int = cmap.Get("muted")
	Dim metaMuted As Int = xui.Color_RGB(120, 120, 120)

	Dim bubbleW As Int = ComputeBubbleWidth(iRowW)
	Dim tailLeft As Int = IIf(sideEff="start", TailSize, 0)
	Dim tailRight As Int = IIf(sideEff="end", TailSize, 0)
	Dim contentW As Int = bubbleW - (PaddingH*2) - tailLeft - tailRight
	If contentW < 80dip Then contentW = 80dip
	Dim bubbleBodyW As Int = bubbleW - tailLeft - tailRight
	If bubbleBodyW < 80dip Then bubbleBodyW = 80dip
	Dim contentX As Int = PaddingH + tailLeft

	Dim showHeaderName As Boolean = HeaderVisible And HeaderNameVisible And HeaderText.Length > 0
	Dim showHeaderTime As Boolean = HeaderVisible And HeaderTimeVisible And HeaderTimeText.Length > 0
	Dim headerLayout As Map = ResolveHeaderLayoutWidths(bubbleBodyW, showHeaderName, showHeaderTime)
	Dim nameW As Int = headerLayout.Get("name_w")
	Dim timeW As Int = headerLayout.Get("time_w")
	Dim gapW As Int = headerLayout.Get("gap_w")
	Dim hh As Int = 0
	Dim hName As Int = IIf(showHeaderName And nameW > 0, MeasureSingleLineHeight(lblHeaderName), 0)
	Dim hTime As Int = IIf(showHeaderTime And timeW > 0, MeasureSingleLineHeight(lblHeaderTime), 0)
	If showHeaderName Or showHeaderTime Then hh = Max(hName, hTime)
	
	Dim footerCombined As String = FooterComposite
	Dim fh As Int = 0
	lblFooter.Visible = FooterVisible And (footerCombined.Length > 0)
	lblFooter.TextColor = metaMuted
	If lblFooter.Visible Then
		lblFooter.Text = footerCombined
		fh = MeasureSingleLineHeight(lblFooter)
	End If
	
	Dim topY As Int = RowPadY
	Dim bubbleY As Int = topY + IIf(hh > 0, hh + RowMetaGapY, 0)

	'Measure content body height
	Dim bodyH As Int
	If BubbleVisible Then
		Select Case ContentMode
			Case "text"
				bodyH = MeasureLabelHeight(lblMessage, MessageText, contentW)
			Case "image"
				bodyH = MeasureImageHeight(contentW)
			Case "custom"
				If CustomContent.IsInitialized Then
					bodyH = Max(1dip, CustomContent.Height)
				Else
					bodyH = 60dip
				End If
		End Select
	Else
		bodyH = 0
	End If
	Dim minVisualBubbleH As Int = Max(44dip, IIf(AvatarVisible, mAvatarSize, 0))
	Dim bubbleH As Int = IIf(BubbleVisible, Max(Max(MinBubbleHeight, minVisualBubbleH), PaddingV + bodyH + PaddingV), 0)

	Dim aW As Int = 0
	Dim bubbleX As Int
	If sideEff = "start" Then
		If AvatarVisible Then aW = mAvatarSize
		bubbleX = OuterMargin + IIf(AvatarVisible, aW + Gap, 0)
	Else
		If AvatarVisible Then aW = mAvatarSize
		bubbleX = iRowW - OuterMargin - bubbleW - IIf(AvatarVisible, aW + Gap, 0)
	End If
	
	'Avatar aligned with bubble block (not header/footer)
	If AvatarVisible Then
		ivAvatar.Visible = True
		Dim avatarX As Int = IIf(sideEff = "start", OuterMargin, iRowW - OuterMargin - mAvatarSize)
		' Align avatar bottom edge with the chat bubble bottom edge (never below bubble bottom).
		Dim avatarY As Int = IIf(BubbleVisible, bubbleY + bubbleH - mAvatarSize, bubbleY)
		ivAvatar.SetLayoutAnimated(0, avatarX, avatarY, mAvatarSize, mAvatarSize)
		DrawAvatar
	Else
		ivAvatar.Visible = False
	End If
	
	pnlBubble.Visible = BubbleVisible
	If BubbleVisible Then
		pnlBubble.SetLayoutAnimated(0, bubbleX, bubbleY, bubbleW, bubbleH)
		ivBubbleBg.SetLayoutAnimated(0, 0, 0, bubbleW, bubbleH)
	Else
		pnlBubble.SetLayoutAnimated(0, bubbleX, bubbleY, 0, 0)
	End If
	
	Dim headerX As Int = bubbleX + tailLeft
	Dim footerX As Int = headerX
	Dim renderHeaderName As Boolean = showHeaderName And nameW > 0
	Dim renderHeaderTime As Boolean = showHeaderTime And timeW > 0
	lblHeaderName.Visible = renderHeaderName
	lblHeaderTime.Visible = renderHeaderTime
	lblHeaderName.TextColor = xui.Color_Black
	lblHeaderTime.TextColor = metaMuted
	lblHeaderName.SetTextAlignment("CENTER", "LEFT")
	lblHeaderTime.SetTextAlignment("CENTER", "LEFT")
	lblFooter.SetTextAlignment("CENTER", IIf(sideEff = "start", "LEFT", "RIGHT"))
	Dim nameX As Int = headerX
	Dim timeX As Int = headerX
	If renderHeaderName And renderHeaderTime Then
		If sideEff = "end" Then
			Dim groupW As Int = nameW + gapW + timeW
			nameX = headerX + bubbleBodyW - groupW
		End If
		timeX = nameX + nameW + gapW
	Else If renderHeaderName Then
		If sideEff = "end" Then nameX = headerX + bubbleBodyW - nameW
	Else If renderHeaderTime Then
		If sideEff = "end" Then timeX = headerX + bubbleBodyW - timeW
	End If
	If renderHeaderName Then
		lblHeaderName.Text = FitSingleLineText(lblHeaderName, HeaderText, nameW)
		lblHeaderName.SetLayoutAnimated(0, nameX, topY, nameW, hh)
	End If
	If renderHeaderTime Then
		lblHeaderTime.Text = FitSingleLineText(lblHeaderTime, HeaderTimeText, timeW)
		lblHeaderTime.SetLayoutAnimated(0, timeX, topY, timeW, hh)
	End If
	If lblFooter.Visible Then
		lblFooter.Text = FitSingleLineText(lblFooter, footerCombined, bubbleBodyW)
		lblFooter.SetLayoutAnimated(0, footerX, bubbleY + bubbleH + RowMetaGapY, bubbleBodyW, fh)
	End If

	'Content slot inside bubble
	If BubbleVisible Then
		Dim contentY As Int = Max(PaddingV, (bubbleH - bodyH) / 2)
		pnlContent.SetLayoutAnimated(0, contentX, contentY, contentW, bodyH)
	Else
		pnlContent.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If

	If BubbleVisible Then
		Select Case ContentMode
			Case "text"
				ivContent.Visible = False
				If CustomContent.IsInitialized Then CustomContent.RemoveViewFromParent
				lblMessage.Visible = True
				lblMessage.Text = MessageText
				lblMessage.TextColor = txt
				lblMessage.SetLayoutAnimated(0, 0, 0, contentW, bodyH)

			Case "image"
				lblMessage.Visible = False
				If CustomContent.IsInitialized Then CustomContent.RemoveViewFromParent
				ivContent.Visible = True
				If ContentImage.IsInitialized Then ivContent.SetBitmap(ContentImage)
				ivContent.SetLayoutAnimated(0, 0, 0, contentW, bodyH)

			Case "custom"
				lblMessage.Visible = False
				ivContent.Visible = False
				If CustomContent.IsInitialized Then
					If CustomContent.Parent.IsInitialized = False Then pnlContent.AddView(CustomContent, 0, 0, contentW, 60dip)
					CustomContent.SetLayoutAnimated(0, 0, 0, contentW, bodyH)
				Else
					'Fallback
					lblMessage.Visible = True
					lblMessage.Text = ""
					lblMessage.SetLayoutAnimated(0, 0, 0, contentW, 1dip)
				End If
		End Select
	Else
		lblMessage.Visible = False
		ivContent.Visible = False
	End If

	'Bubble background draw (cached)
	If BubbleVisible Then
		If OutlineColor = 0 Then OutlineColor = Blend(back, xui.Color_Black, 0.25)
		DrawBubbleIfNeeded(bubbleW, bubbleH, back, sideEff, True, ShowOutline, OutlineColor, OutlineWidth, mBubbleStyle)
	End If

End Sub

Private Sub DrawAvatar
	If ChatAvatar.IsInitialized = False Then Return
	If ivAvatar.IsInitialized = False Or ivAvatar.Visible = False Then Return
	ChatAvatar.SetChatImage(True)
	ChatAvatar.SetShadow("none")
	ChatAvatar.SetCenterOnParent(False)
	ChatAvatar.SetVariant("none")
	ChatAvatar.SetUseVariantStatusColors(False)
	ChatAvatar.SetAvatarMask(mAvatarMask)
	ChatAvatar.SetAvatarStatus(AvatarStatus)
	ChatAvatar.SetAvatarStatusColors(AvatarOnlineColor, AvatarOfflineColor)
	ChatAvatar.SetShowOnline(OnlineIndicatorVisible)
	ChatAvatar.SetAvatarBorder(AvatarBorderColor, AvatarBorderWidth)
	ChatAvatar.SetAvatarBorderInset(AvatarBorderInset)
	Dim effectiveStatus As String = AvatarStatus
	If OnlineIndicatorVisible = False Then effectiveStatus = "none"
	Dim statusColor As Int = 0
	If effectiveStatus = "online" Then statusColor = AvatarOnlineColor
	If effectiveStatus = "offline" Then statusColor = AvatarOfflineColor
	Dim ringColor As Int = IIf(statusColor <> 0, statusColor, AvatarBorderColor)
	ChatAvatar.SetRingColor(ringColor)
	ChatAvatar.SetAvatarBitmap(AvatarBmp, AvatarTag)
	ChatAvatar.ResizeToParent(ivAvatar)
End Sub

Private Sub FooterComposite As String
	Dim ticks As String = ""
	Select Case StatusMode
		Case "sent"      : ticks = " ?"
		Case "delivered" : ticks = " ??"
		Case "read"      : ticks = " ??"
		Case Else        : ticks = ""
	End Select
	Dim extra As String = ""
	If StatusText.Length > 0 Then extra = " ? " & StatusText
	
	If FooterText.Length = 0 And ticks.Length = 0 And extra.Length = 0 Then Return ""
	Return FooterText & ticks & extra
End Sub

Private Sub MeasureImageHeight(iContentW As Int) As Int
	If ContentImage.IsInitialized = False Then Return 120dip
	Dim iw As Int = ContentImage.Width
	Dim ih As Int = ContentImage.Height
	If iw <= 0 Or ih <= 0 Then Return 120dip
	Dim scaledH As Int = ih * (iContentW / iw)
	If scaledH > ContentImageMaxH Then scaledH = ContentImageMaxH
	If scaledH < 80dip Then scaledH = 80dip
	Return scaledH
End Sub

Private Sub MeasureLabelHeight(vView As B4XView, sText As String, iWidth As Int) As Int
	Dim l As Label = vView
	l.Width = Max(1dip, iWidth)
	Dim h As Int = tu.MeasureMultilineTextHeight(l, sText)
	Return Max(1dip, h)
End Sub

Private Sub MeasureSingleLineHeight(vView As B4XView) As Int
	Dim l As Label = vView
	Dim oldW As Int = l.Width
	l.Width = Max(120dip, oldW)
	Dim h As Int = tu.MeasureMultilineTextHeight(l, "Ag")
	l.Width = oldW
	Return Max(1dip, h)
End Sub

Private Sub MeasureSingleLineWidth(vView As B4XView, sText As String) As Int
	If sText.Length = 0 Then Return 0
	Dim cleaned As String = sText.Replace(CRLF, Chr(10))
	Dim lines() As String = Regex.Split(Chr(10), cleaned)
	Dim l As Label = vView
	Dim maxW As Float = 0
	For Each ln As String In lines
		Dim w As Float = B4XDaisyVariants.MeasureTextWidthSafe(ln, l.TextSize, l.Typeface, 0)
		If w > maxW Then maxW = w
	Next
	Return Max(1dip, Ceil(maxW) + 2dip)
End Sub

Private Sub FitSingleLineText(vView As B4XView, sText As String, iMaxWidth As Int) As String
	If iMaxWidth <= 0 Then Return ""
	Dim normalized As String = sText.Replace(CRLF, " ").Replace(Chr(10), " ").Trim
	If normalized.Length = 0 Then Return ""
	If MeasureSingleLineWidth(vView, normalized) <= iMaxWidth Then Return normalized
	Dim dots As String = "..."
	If MeasureSingleLineWidth(vView, dots) > iMaxWidth Then Return ""
	Dim lo As Int = 0
	Dim hi As Int = normalized.Length
	Do While lo < hi
		Dim mid As Int = (lo + hi + 1) / 2
		Dim candidate As String = normalized.SubString2(0, mid) & dots
		If MeasureSingleLineWidth(vView, candidate) <= iMaxWidth Then
			lo = mid
		Else
			hi = mid - 1
		End If
	Loop
	If lo <= 0 Then Return dots
	Return normalized.SubString2(0, lo) & dots
End Sub

Private Sub ResolveHeaderLayoutWidths(iBubbleBodyW As Int, bShowHeaderName As Boolean, bShowHeaderTime As Boolean) As Map
	Dim result As Map
	result.Initialize
	Dim minTimeW As Int = 20dip
	Dim preferredGapW As Int = 4dip
	Dim gapW As Int = preferredGapW
	Dim nameW As Int = 0
	Dim timeW As Int = 0
	Dim desiredNameW As Int = 0
	Dim desiredTimeW As Int = 0
	
	If bShowHeaderName Then
		desiredNameW = Min(iBubbleBodyW, MeasureSingleLineWidth(lblHeaderName, HeaderText))
	End If
	If bShowHeaderTime Then
		desiredTimeW = Min(iBubbleBodyW, Max(minTimeW, MeasureSingleLineWidth(lblHeaderTime, HeaderTimeText)))
	End If
	
	If bShowHeaderName And bShowHeaderTime Then
		Dim fullHeaderW As Int = desiredNameW + preferredGapW + desiredTimeW
		If fullHeaderW <= iBubbleBodyW Then
			'Everything fits in one row: render full name + time (no name truncation).
			nameW = desiredNameW
			timeW = desiredTimeW
			gapW = preferredGapW
		Else
			'Overflow: preserve time width and let name be ellipsized to remaining space.
			timeW = Min(desiredTimeW, iBubbleBodyW)
			Dim remaining As Int = iBubbleBodyW - timeW
			If remaining <= 0 Then
				nameW = 0
				gapW = 0
			Else
				gapW = IIf(remaining > preferredGapW, preferredGapW, 0)
				nameW = Max(0, remaining - gapW)
			End If
		End If
	Else If bShowHeaderName Then
		nameW = iBubbleBodyW
	Else If bShowHeaderTime Then
		timeW = Min(iBubbleBodyW, Max(minTimeW, desiredTimeW))
	End If
	
	result.Put("name_w", nameW)
	result.Put("time_w", timeW)
	result.Put("gap_w", gapW)
	Return result
End Sub

Private Sub MaxBubbleWidth(iRowW As Int) As Int
	Dim avatarSlot As Int = IIf(AvatarVisible, mAvatarSize + Gap, 0)
	Dim hardMax As Int = iRowW - (OuterMargin * 2) - avatarSlot
	Dim pctMax As Int = iRowW * MaxWidthPct
	Dim m As Int = Min(hardMax, pctMax)
	Return Max(MinBubbleWidth, m)
End Sub

Private Sub EstimateDesiredContentWidth(iMaxContentW As Int) As Int
	Dim desired As Int = 1dip
	
	If BubbleVisible Then
		Select Case ContentMode
			Case "text"
				desired = Max(desired, MeasureSingleLineWidth(lblMessage, MessageText))
			Case "image"
				If ContentImage.IsInitialized Then
					desired = Max(desired, Min(iMaxContentW, Max(44dip, ContentImage.Width)))
				End If
			Case "custom"
				If CustomContent.IsInitialized Then
					desired = Max(desired, CustomContent.Width)
				End If
		End Select
	End If

	If desired > iMaxContentW Then desired = iMaxContentW
	Return Max(1dip, desired)
End Sub

Private Sub ComputeBubbleWidth(iRowW As Int) As Int
	Dim sideEff As String = EffectiveSide
	Dim maxBubble As Int = MaxBubbleWidth(iRowW)
	Dim tailLeft As Int = IIf(sideEff="start", TailSize, 0)
	Dim tailRight As Int = IIf(sideEff="end", TailSize, 0)
	Dim chrome As Int = (PaddingH * 2) + tailLeft + tailRight
	Dim maxContentW As Int = Max(1dip, maxBubble - chrome)
	Dim desiredContentW As Int = EstimateDesiredContentWidth(maxContentW)
	Dim w As Int = chrome + desiredContentW
	If w > maxBubble Then w = maxBubble
	If w < MinBubbleWidth Then w = MinBubbleWidth
	Return w
End Sub

Private Sub ResolveColors As Map
	InitializeDefaultPalette
	Dim sideEff As String = EffectiveSide
	Dim pal As Map
	If VariantPalette.IsInitialized Then
		pal = VariantPalette
	Else
		pal = DefaultVariantPalette
	End If
	Dim vm As Map
	If pal.IsInitialized And pal.ContainsKey(mVariant) Then
		vm = pal.Get(mVariant)
	Else If pal.IsInitialized And pal.ContainsKey("neutral") Then
		vm = pal.Get("neutral")
	Else
		vm = BuildVariantMap(0xFFE5E7EB, 0xFF111827)
	End If

	Dim back As Int
	Dim txt As Int
	Dim muted As Int
	back = GetMapIntSafe(vm, "back", 0xFFE5E7EB)
	txt = GetMapIntSafe(vm, "text", 0xFF111827)
	muted = GetMapIntSafe(vm, "muted", Blend(txt, xui.Color_Gray, 0.35))
	
	If mUseFromToColors Then
		If sideEff = "start" Then
			back = mFromBackgroundColor
			txt = mFromTextColor
		Else
			back = mToBackgroundColor
			txt = mToTextColor
		End If
		muted = Blend(txt, xui.Color_Gray, 0.35)
	End If

	If OverrideBackColor <> 0 Then back = OverrideBackColor
	If OverrideTextColor <> 0 Then txt = OverrideTextColor
	If OverrideMutedColor <> 0 Then muted = OverrideMutedColor
	
	Dim result As Map
	result.Initialize
	result.Put("back", back)
	result.Put("text", txt)
	result.Put("muted", muted)
	Return result
End Sub

Private Sub GetMapIntSafe(mMap As Map, sKey As String, iDefaultValue As Int) As Int
	If mMap.IsInitialized = False Then Return iDefaultValue
	If mMap.ContainsKey(sKey) = False Then Return iDefaultValue
	Dim o As Object = mMap.Get(sKey)
	If o = Null Then Return iDefaultValue
	Return o
End Sub

Private Sub InitializeDefaultPalette
	If DefaultVariantPalette.IsInitialized Then
		If VariantPalette.IsInitialized = False Then VariantPalette = DefaultVariantPalette
		Return
	End If
	DefaultVariantPalette = BuildDefaultPalette
	VariantPalette = DefaultVariantPalette
End Sub

Private Sub BuildDefaultPalette As Map
	Dim m As Map
	m.Initialize
	m.Put("neutral", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(241,245,249)), B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)))
	m.Put("primary", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-primary", xui.Color_RGB(219,234,254)), B4XDaisyVariants.GetTokenColor("--color-primary-content", xui.Color_RGB(30,64,175))))
	m.Put("secondary", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-secondary", xui.Color_RGB(243,232,255)), B4XDaisyVariants.GetTokenColor("--color-secondary-content", xui.Color_RGB(88,28,135))))
	m.Put("accent", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-accent", xui.Color_RGB(204,251,241)), B4XDaisyVariants.GetTokenColor("--color-accent-content", xui.Color_RGB(19,78,74))))
	m.Put("info", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-info", xui.Color_RGB(224,242,254)), B4XDaisyVariants.GetTokenColor("--color-info-content", xui.Color_RGB(12,74,110))))
	m.Put("success", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-success", xui.Color_RGB(220,252,231)), B4XDaisyVariants.GetTokenColor("--color-success-content", xui.Color_RGB(20,83,45))))
	m.Put("warning", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-warning", xui.Color_RGB(254,249,195)), B4XDaisyVariants.GetTokenColor("--color-warning-content", xui.Color_RGB(113,63,18))))
	m.Put("error", BuildVariantMap(B4XDaisyVariants.GetTokenColor("--color-error", xui.Color_RGB(254,226,226)), B4XDaisyVariants.GetTokenColor("--color-error-content", xui.Color_RGB(127,29,29))))
	Return m
End Sub

Private Sub EffectiveSide As String
	Dim s As String = mSide
	If B4XDaisyVariants.IsRtl Then
		If s = "start" Then
			s = "end"
		Else If s = "end" Then
			s = "start"
		End If
	End If
	Return s
End Sub

Private Sub BuildVariantMap(iBack As Int, iText As Int) As Map
	Dim vm As Map
	vm.Initialize
	vm.Put("back", iBack)
	vm.Put("text", iText)
	vm.Put("muted", Blend(iText, xui.Color_Gray, 0.35))
	Return vm
End Sub

Private Sub DrawBubbleIfNeeded(iW As Int, iH As Int, iBack As Int, sSideNow As String, bTail As Boolean, bOutline As Boolean, iOColor As Int, fOWidth As Float, sStyleNow As String)
	If iW <= 0 Or iH <= 0 Then Return
	Dim ow As Int = Max(0, fOWidth)
	If iW = LastW And iH = LastH And iBack = LastBack And sSideNow = LastSide And bTail = LastTail And bOutline = LastOutline And iOColor = LastOutlineColor And ow = LastOutlineWidth And sStyleNow = LastStyle Then Return

	LastW = iW : LastH = iH : LastBack = iBack : LastSide = sSideNow
	LastTail = bTail : LastOutline = bOutline : LastOutlineColor = iOColor : LastOutlineWidth = ow
	LastStyle = sStyleNow
	
	If CanvasReady Then cvs.Release
	cvs.Initialize(ivBubbleBg)
	CanvasReady = True
	cvs.ClearRect(cvs.TargetRect)
	
	Dim tailPadLeft As Float = IIf(sSideNow="start" And bTail, TailSize, 0)
	Dim tailPadRight As Float = IIf(sSideNow="end" And bTail, TailSize, 0)
	
	Dim rr As B4XRect
	rr.Initialize(tailPadLeft, 0, iW - tailPadRight, iH)
	Dim fieldRadius As Float = B4XDaisyVariants.GetRadiusFieldDip(Corner)
	Dim useCorner As Float = IIf(sStyleNow = "block", 9dip, fieldRadius)
	Dim bubblePath As B4XPath
	bubblePath.InitializeRoundedRect(rr, useCorner)
	
	'Fill
	cvs.DrawPath(bubblePath, iBack, True, 0)
	'chat-start/end behavior: remove one bottom corner radius like daisyUI rounded-es/ee-none.
	Dim cornerFix As B4XRect
	Dim cornerFixW As Float = Max(useCorner, TailSize + 1dip)
	If sSideNow = "start" Then
		cornerFix.Initialize(rr.Left, rr.Bottom - useCorner, rr.Left + cornerFixW, rr.Bottom)
	Else
		cornerFix.Initialize(rr.Right - cornerFixW, rr.Bottom - useCorner, rr.Right, rr.Bottom)
	End If
	cvs.DrawRect(cornerFix, iBack, True, 0)
	
	'Tail
	If bTail Then
		'Anchor tail to bottom edge for a smoother silhouette.
		'Keep tail baseline flush with bubble bottom edge.
		Dim bottomY As Float = iH
		Dim attachTopY As Float
		If sStyleNow = "block" Then
			attachTopY = Max(useCorner, bottomY - TailSize * 0.85)
		Else
			attachTopY = Max(useCorner, bottomY - TailSize * 0.75)
		End If
		Dim p As B4XPath
		If sSideNow="start" Then
			p.Initialize(0, bottomY)
			p.LineTo(TailSize, attachTopY)
			p.LineTo(TailSize, bottomY)
			p.LineTo(0, bottomY)
		Else
			p.Initialize(iW, bottomY)
			p.LineTo(iW - TailSize, attachTopY)
			p.LineTo(iW - TailSize, bottomY)
			p.LineTo(iW, bottomY)
		End If
		cvs.DrawPath(p, iBack, True, 0)
	End If

	'Outline (optional)
	If bOutline Then
		cvs.DrawPath(bubblePath, iOColor, False, OutlineWidth)
		If bTail Then
			Dim bottomY2 As Float = iH
			Dim attachTopY2 As Float
			If sStyleNow = "block" Then
				attachTopY2 = Max(useCorner, bottomY2 - TailSize * 0.85)
			Else
				attachTopY2 = Max(useCorner, bottomY2 - TailSize * 0.75)
			End If
			Dim p2 As B4XPath
			If sSideNow="start" Then
				p2.Initialize(0, bottomY2)
				p2.LineTo(TailSize, attachTopY2)
				p2.LineTo(TailSize, bottomY2)
				p2.LineTo(0, bottomY2)
			Else
				p2.Initialize(iW, bottomY2)
				p2.LineTo(iW - TailSize, attachTopY2)
				p2.LineTo(iW - TailSize, bottomY2)
				p2.LineTo(iW, bottomY2)
			End If
			cvs.DrawPath(p2, iOColor, False, OutlineWidth)
		End If
	End If

	cvs.Invalidate
End Sub

Private Sub ApplyElevation(fE As Float)
	'No-op by default. Native elevation is platform / API dependent.
End Sub

Private Sub Blend(iC1 As Int, iC2 As Int, dT As Double) As Int
	Dim r1 As Int = Bit.And(Bit.ShiftRight(iC1, 16), 0xFF)
	Dim g1 As Int = Bit.And(Bit.ShiftRight(iC1, 8), 0xFF)
	Dim b1 As Int = Bit.And(iC1, 0xFF)
	Dim r2 As Int = Bit.And(Bit.ShiftRight(iC2, 16), 0xFF)
	Dim g2 As Int = Bit.And(Bit.ShiftRight(iC2, 8), 0xFF)
	Dim b2 As Int = Bit.And(iC2, 0xFF)
	Return xui.Color_RGB(r1 + (r2-r1)*dT, g1 + (g2-g1)*dT, b1 + (b2-b1)*dT)
End Sub

'-
' Events
'-

Private Sub chatavatar_AvatarClick(oPayload As Object)
	If xui.SubExists(mCallBack, mEventName & "_AvatarClick", 1) Then
		CallSub2(mCallBack, mEventName & "_AvatarClick", oPayload)
	End If
End Sub

Public Sub RaiseBubbleClick(oTag As Object)
	If xui.SubExists(mCallBack, mEventName & "_BubbleClick", 1) Then
		CallSub2(mCallBack, mEventName & "_BubbleClick", oTag)
	End If
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

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region
