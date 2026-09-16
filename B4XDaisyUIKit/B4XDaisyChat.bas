B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: AvatarClick (Tag As Object)

#DesignerProperty: Key: AvatarMask, DisplayName: Avatar Mask, FieldType: String, DefaultValue: squircle, List: circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2, Description: Mask shape used for message avatars
#DesignerProperty: Key: AvatarSize, DisplayName: Avatar Size, FieldType: Int, DefaultValue: 40, Description: Avatar size in dip for each message row
#DesignerProperty: Key: FromBackgroundColor, DisplayName: From Background, FieldType: Color, DefaultValue: 0xFF4338CA, Description: Background color for outgoing (from) bubbles
#DesignerProperty: Key: FromTextColor, DisplayName: From Text, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Text color for outgoing (from) bubbles
#DesignerProperty: Key: ToBackgroundColor, DisplayName: To Background, FieldType: Color, DefaultValue: 0xFF0EA5E9, Description: Background color for incoming (to) bubbles
#DesignerProperty: Key: ToTextColor, DisplayName: To Text, FieldType: Color, DefaultValue: 0xFF082F49, Description: Text color for incoming (to) bubbles
#DesignerProperty: Key: UseFromToColors, DisplayName: Use From/To Colors, FieldType: Boolean, DefaultValue: True, Description: Use explicit from/to colors instead of theme defaults
#DesignerProperty: Key: Theme, DisplayName: Theme, FieldType: String, DefaultValue: light, List: light|default, Description: Theme preset used for default chat colors
#DesignerProperty: Key: DateTimeFormat, DisplayName: Date Time Format, FieldType: String, DefaultValue: D, j M Y H:i, Description: Accepts Java DateFormat or flatpickr tokens (eg H:i, Y-m-d H:i)
#DesignerProperty: Key: UseTimeAgo, DisplayName: Use Time Ago, FieldType: Boolean, DefaultValue: False, Description: Show relative timestamps (for example, 5m ago)
#DesignerProperty: Key: ShowTimeAgoForToday, DisplayName: Time Ago For Today, FieldType: Boolean, DefaultValue: True, Description: When enabled and UseTimeAgo is true, today's times show as time-ago while older dates use DateTimeFormat
#DesignerProperty: Key: VerticalGap, DisplayName: Vertical Gap, FieldType: Int, DefaultValue: 8, Description: Vertical spacing in dip between message rows
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: Int, DefaultValue: 0, Description: Explicit chat width in dip (0 uses base width)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: Int, DefaultValue: 0, Description: Explicit chat height in dip (0 uses base height)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind/spacing padding utilities (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)

'B4XDaisyChat
'Self-contained chat component that manages bubble list, rendering, and runtime updates.
'https://flatpickr.js.org/formatting/
#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private sv As ScrollView
	Private pnlContent As B4XView
	Private ItemPanels As List
	Private BubbleById As Map
	Private RowById As Map
	Private MessageById As Map
	Private BubbleIds As List
	Private BubbleIndex As Int

	Private AvatarFiles As List
	Private AvatarCache As Map 'filename -> B4XBitmap

	Private mAvatarMask As String = "squircle"
	Private mAvatarSize As Float = 40dip
	Private mFromBackgroundColor As Int = 0xFF4338CA
	Private mFromTextColor As Int = 0xFFFFFFFF
	Private mToBackgroundColor As Int = 0xFF0EA5E9
	Private mToTextColor As Int = 0xFF082F49
	Private mUseFromToColors As Boolean = True
	Private Themes As Map
	Private CurrentTheme As String = "light"
	Private mDateTimeFormat As String = "D, j M Y H:i"
	Private mUseTimeAgo As Boolean = False
	Private mShowTimeAgoForToday As Boolean = True
	Private OnlineIndicatorsVisible As Boolean = True
	Private mVerticalGap As Int = 8dip
	Private ChatWidth As Int = 0
	Private ChatHeight As Int = 0
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private AvatarOnlineColor As Int = 0xFF2ECC71
	Private AvatarOfflineColor As Int = 0xFFB4B4B4
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	InitializeThemes
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
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	sv.Initialize(0)
	mBase.AddView(sv, 0, 0, mBase.Width, mBase.Height)
	pnlContent = sv.Panel
	pnlContent.Color = xui.Color_Transparent

	ItemPanels.Initialize
	BubbleById.Initialize
	RowById.Initialize
	MessageById.Initialize
	BubbleIds.Initialize
	BubbleIndex = 1
	AvatarFiles.Initialize
	AvatarCache.Initialize
	InitializeThemes

	ApplyDesignerProps(mProps)
	ApplyComponentSize
End Sub

Public Sub Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If sv.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
	ChatWidth = dWidth
	ChatHeight = dHeight
	Dim contentRect As B4XRect = ResolveContentRectForBounds(dWidth, dHeight)
	sv.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	RelayoutAll
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If sv.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	ChatWidth = dWidth
	ChatHeight = dHeight
	Dim contentRect As B4XRect = ResolveContentRectForBounds(dWidth, dHeight)
	sv.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	RelayoutAll
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView)
	AddToParentAt(vParent, 0, 0, vParent.Width, vParent.Height)
End Sub

Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If vParent.IsInitialized = False Then Return
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
	Return mBase.IsInitialized And sv.IsInitialized And mBase.Width > 0
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mAvatarMask = B4XDaisyVariants.NormalizeMask(B4XDaisyVariants.GetPropString(mProps, "AvatarMask", mAvatarMask))
	mAvatarSize = Max(16dip, B4XDaisyVariants.GetPropFloat(mProps, "AvatarSize", mAvatarSize / 1dip) * 1dip)
	mFromBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "FromBackgroundColor", mFromBackgroundColor)
	mFromTextColor = B4XDaisyVariants.GetPropInt(mProps, "FromTextColor", mFromTextColor)
	mToBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "ToBackgroundColor", mToBackgroundColor)
	mToTextColor = B4XDaisyVariants.GetPropInt(mProps, "ToTextColor", mToTextColor)
	mUseFromToColors = B4XDaisyVariants.GetPropBool(mProps, "UseFromToColors", mUseFromToColors)
	setTheme(B4XDaisyVariants.GetPropString(mProps, "Theme", CurrentTheme))
	mDateTimeFormat = B4XDaisyVariants.NormalizeDateTimeFormat(B4XDaisyVariants.GetPropString(mProps, "DateTimeFormat", mDateTimeFormat), "D, j M Y H:i")
	mUseTimeAgo = B4XDaisyVariants.GetPropBool(mProps, "UseTimeAgo", mUseTimeAgo)
	mShowTimeAgoForToday = B4XDaisyVariants.GetPropBool(mProps, "ShowTimeAgoForToday", mShowTimeAgoForToday)
	mVerticalGap = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "VerticalGap", mVerticalGap / 1dip) * 1dip)
	ChatWidth = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "Width", 0) * 1dip)
	ChatHeight = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "Height", 0) * 1dip)
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	
	AvatarOnlineColor = B4XDaisyVariants.GetPropInt(mProps, "OnlineColor", AvatarOnlineColor)
	AvatarOfflineColor = B4XDaisyVariants.GetPropInt(mProps, "OfflineColor", AvatarOfflineColor)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("AvatarMask", mAvatarMask)
	props.Put("AvatarSize", mAvatarSize / 1dip)
	props.Put("FromBackgroundColor", mFromBackgroundColor)
	props.Put("FromTextColor", mFromTextColor)
	props.Put("ToBackgroundColor", mToBackgroundColor)
	props.Put("ToTextColor", mToTextColor)
	props.Put("UseFromToColors", mUseFromToColors)
	props.Put("Theme", CurrentTheme)
	props.Put("DateTimeFormat", mDateTimeFormat)
	props.Put("UseTimeAgo", mUseTimeAgo)
	props.Put("ShowTimeAgoForToday", mShowTimeAgoForToday)
	props.Put("VerticalGap", mVerticalGap / 1dip)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("OnlineColor", AvatarOnlineColor)
	props.Put("OfflineColor", AvatarOfflineColor)
	Return props
End Sub








Public Sub setTag(oValue As Object)
	mTag = oValue
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
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

Private Sub ApplyComponentSize
	If mBase.IsInitialized = False Then Return
	Dim w As Int = IIf(ChatWidth > 0, ChatWidth, mBase.Width)
	Dim h As Int = IIf(ChatHeight > 0, ChatHeight, mBase.Height)
	If w <= 0 Then w = 1dip
	If h <= 0 Then h = 1dip
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	Resize(w, h)
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

' removed local getProp helpers; use B4XDaisyVariants.* directly


Private Sub ListWidth As Int
	If mBase.IsInitialized = False Then Return 320dip
	Dim w As Int = mBase.Width
	If w <= 0 Then w = 320dip
	Return w
End Sub

Public Sub Clear
	If ItemPanels.IsInitialized Then
		For Each row As B4XView In ItemPanels
			row.RemoveViewFromParent
		Next
		ItemPanels.Clear
	End If
	If BubbleById.IsInitialized Then BubbleById.Clear
	If RowById.IsInitialized Then RowById.Clear
	If MessageById.IsInitialized Then MessageById.Clear
	If BubbleIds.IsInitialized Then BubbleIds.Clear
	BubbleIndex = 1
	If pnlContent.IsInitialized Then pnlContent.Height = IIf(sv.IsInitialized, sv.Height, 0)
	If sv.IsInitialized Then sv.ScrollPosition = 0
End Sub

Public Sub setConversations(lstMessages As List)
	Clear
	If lstMessages.IsInitialized = False Then Return
	For Each m As Map In lstMessages
		AddMessage(m, False)
	Next
End Sub

Public Sub ClearConversations
	Clear
End Sub

Public Sub AppendMessage(mMessage As Map) As String
	Return AddMessage(mMessage, False)
End Sub

Public Sub AppendMessageAndScroll(mMessage As Map, bSmooth As Boolean) As String
	Dim id As String = AddMessage(mMessage, False)
	If bSmooth Then
		SmoothScrollToMessage(id, 450)
	Else
		ScrollToMessage(id)
	End If
	Return id
End Sub

Public Sub ScrollToMessage(sBubbleId As String)
	If RowById.IsInitialized = False Or sv.IsInitialized = False Then Return
	If RowById.ContainsKey(sBubbleId) = False Then Return
	Dim row As B4XView = RowById.Get(sBubbleId)
	Dim target As Int = ClampScrollPosition(row.Top)
	sv.ScrollPosition = target
End Sub

Public Sub ScrollToTop
	If sv.IsInitialized = False Then Return
	sv.ScrollPosition = 0
End Sub

Public Sub ScrollToBottom
	If sv.IsInitialized = False Then Return
	sv.ScrollPosition = MaxScrollPosition
End Sub

Public Sub SmoothScrollToTop(iDurationMs As Int) As ResumableSub
	Wait For (SmoothScrollToPosition(0, iDurationMs)) Complete (ok As Boolean)
	Return ok
End Sub

Public Sub SmoothScrollToBottom(iDurationMs As Int) As ResumableSub
	Wait For (SmoothScrollToPosition(MaxScrollPosition, iDurationMs)) Complete (ok As Boolean)
	Return ok
End Sub

Public Sub SmoothScrollToMessage(sBubbleId As String, iDurationMs As Int) As ResumableSub
	If RowById.IsInitialized = False Or RowById.ContainsKey(sBubbleId) = False Then Return False
	Dim row As B4XView = RowById.Get(sBubbleId)
	Wait For (SmoothScrollToPosition(row.Top, iDurationMs)) Complete (ok As Boolean)
	Return ok
End Sub

Public Sub SmoothScrollToPosition(iTarget As Int, iDurationMs As Int) As ResumableSub
	If sv.IsInitialized = False Then Return False
	Dim targetClamped As Int = ClampScrollPosition(iTarget)
	Dim startPos As Int = sv.ScrollPosition
	If iDurationMs <= 0 Or startPos = targetClamped Then
		sv.ScrollPosition = targetClamped
		Return True
	End If
	Dim frameMs As Int = 16
	Dim steps As Int = Max(1, iDurationMs / frameMs)
	Dim stepDelay As Int = Max(10, iDurationMs / steps)
	For i = 1 To steps
		Dim t As Double = i / steps
		Dim eased As Double = t * t * (3 - 2 * t)
		Dim pos As Int = startPos + (targetClamped - startPos) * eased
		sv.ScrollPosition = pos
		Sleep(stepDelay)
	Next
	sv.ScrollPosition = targetClamped
	Return True
End Sub

Public Sub getMessageById(sBubbleId As String) As Map
	Dim result As Map
	result.Initialize
	If MessageById.IsInitialized = False Then Return result
	If MessageById.ContainsKey(sBubbleId) = False Then Return result
	Return CloneMap(MessageById.Get(sBubbleId))
End Sub

Public Sub getMessage(sBubbleId As String) As Map
	Return GetMessageById(sBubbleId)
End Sub

Public Sub UpdateMessageById(sBubbleId As String, mFields As Map) As Boolean
	If MessageById.IsInitialized = False Or MessageById.ContainsKey(sBubbleId) = False Then Return False
	If mFields.IsInitialized = False Then Return False
	Dim merged As Map = CloneMap(MessageById.Get(sBubbleId))
	For Each k As String In mFields.Keys
		merged.Put(k, mFields.Get(k))
	Next
	Return ReplaceMessageById(sBubbleId, merged)
End Sub

Public Sub UpdateMessage(mMessage As Map) As Boolean
	If mMessage.IsInitialized = False Then Return False
	Dim bubbleId As String = ResolveMessageId(mMessage)
	If bubbleId.Length = 0 Then Return False
	Dim fields As Map = CloneMap(mMessage)
	If fields.ContainsKey("id") Then fields.Remove("id")
	If fields.ContainsKey("Id") Then fields.Remove("Id")
	If fields.Size = 0 Then Return MessageById.IsInitialized And MessageById.ContainsKey(bubbleId)
	Return UpdateMessageById(bubbleId, fields)
End Sub

Public Sub UpdateHeaderById(sBubbleId As String, sHeaderName As String, sHeaderTime As String) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("header", sHeaderName)
	m.Put("header_time", sHeaderTime)
	Return UpdateMessageById(sBubbleId, m)
End Sub

Public Sub UpdateFooterById(sBubbleId As String, sFooterText As String) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("footer", sFooterText)
	Return UpdateMessageById(sBubbleId, m)
End Sub

Public Sub UpdateAvatarById(sBubbleId As String, bmpAvatarBitmap As B4XBitmap) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("avatar_bitmap", bmpAvatarBitmap)
	m.Put("avatar", "")
	Return UpdateMessageById(sBubbleId, m)
End Sub

Public Sub UpdateOnlineStatusById(sBubbleId As String, sStatus As String, iOnlineColor As Int) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("avatar_status", sStatus)
	If iOnlineColor <> 0 Then m.Put("avatar_online_color", iOnlineColor)
	Return UpdateMessageById(sBubbleId, m)
End Sub

Public Sub ReplaceMessageById(sBubbleId As String, mMessage As Map) As Boolean
	If BubbleById.IsInitialized = False Or BubbleById.ContainsKey(sBubbleId) = False Then Return False
	If mMessage.IsInitialized = False Then Return False
	Dim bubble As B4XDaisyChatBubble = BubbleById.Get(sBubbleId)
	Dim source As Map = CloneMap(mMessage)
	source.Put("id", sBubbleId)
	ConfigureBubbleFromMessage(bubble, source)
	MessageById.Put(sBubbleId, source)
	RelayoutAll
	Return True
End Sub

Public Sub DeleteMessageById(sBubbleId As String) As Boolean
	If BubbleIds.IsInitialized = False Then Return False
	Dim idx As Int = IndexOfBubbleId(sBubbleId)
	If idx = -1 Then Return False
	Dim row As B4XView = ItemPanels.Get(idx)
	row.RemoveViewFromParent
	ItemPanels.RemoveAt(idx)
	BubbleIds.RemoveAt(idx)
	If BubbleById.IsInitialized Then BubbleById.Remove(sBubbleId)
	If RowById.IsInitialized Then RowById.Remove(sBubbleId)
	If MessageById.IsInitialized Then MessageById.Remove(sBubbleId)
	RelayoutAll
	Return True
End Sub

Public Sub AddMessage(mMessage As Map, bScrollTo As Boolean) As String
	If mMessage.IsInitialized = False Then mMessage = CreateMap()
	Dim source As Map = CloneMap(mMessage)
	
	Dim bubble As B4XDaisyChatBubble
	bubble.Initialize(Me, "bubble")
	bubble.CreateView(ListWidth, 10dip)
	ConfigureBubbleFromMessage(bubble, source)
	Dim bubbleId As String = AddBubbleRow(bubble, ResolveMessageId(source))
	source.Put("id", bubbleId)
	MessageById.Put(bubbleId, source)
	If bScrollTo Then ScrollToMessage(bubbleId)
	Return bubbleId
End Sub

Private Sub ConfigureBubbleFromMessage(bubble As B4XDaisyChatBubble, mMessage As Map)
	Dim side As String = GetMapString(mMessage, "side", "start")
	If side <> "end" Then side = "start"
	Dim variantRaw As String = GetMapString(mMessage, "variant", "")
	Dim hasVariant As Boolean = variantRaw.Trim.Length > 0
	Dim variant As String = "neutral"
	If hasVariant Then variant = variantRaw
	Dim text As String = GetMapString(mMessage, "text", "")
	Dim header As String = GetMapString(mMessage, "header", "")
	Dim headerTimeRaw As String = GetMapString(mMessage, "header_time", "")
	Dim headerTime As String = ResolveHeaderTime(mMessage, headerTimeRaw)
	Dim footer As String = GetMapString(mMessage, "footer", "")
	Dim statusMode As String = NormalizeBubbleStatusMode(GetMapString(mMessage, "status_mode", "none"))
	Dim statusText As String = GetMapString(mMessage, "status_text", "")
	Dim localUseFromTo As Boolean = mUseFromToColors
	If hasVariant Then localUseFromTo = False
	If mMessage.ContainsKey("use_from_to_colors") Then localUseFromTo = GetMapBool(mMessage, "use_from_to_colors", localUseFromTo)
	Dim messageTheme As String = GetMapString(mMessage, "theme", "")
	Dim messagePalette As Map = GetMapMap(mMessage, "theme_palette")
	Dim resolvedPalette As Map
	If messagePalette.IsInitialized Then
		resolvedPalette = messagePalette
	Else
		resolvedPalette = ResolvePalette(messageTheme)
	End If
	Dim showHeader As Boolean
	If mMessage.ContainsKey("show_header") Then
		showHeader = getMapBool(mMessage, "show_header", False)
	Else
		showHeader = (header.Length > 0 Or headerTime.Length > 0)
	End If
	Dim showFooter As Boolean
	If mMessage.ContainsKey("show_footer") Then
		showFooter = getMapBool(mMessage, "show_footer", False)
	Else
		showFooter = (footer.Length > 0 Or statusMode <> "none" Or statusText.Length > 0)
	End If
	Dim avatarStatus As String = getMapString(mMessage, "avatar_status", "none")
	If avatarStatus = "" Then avatarStatus = "none"
	Dim onlineColor As Int = getMapInt(mMessage, "avatar_online_color", AvatarOnlineColor)
	Dim offlineColor As Int = getMapInt(mMessage, "avatar_offline_color", AvatarOfflineColor)
	Dim avatarMaskNow As String = getMapString(mMessage, "avatar_mask", mAvatarMask)
	Dim backOverride As Int = getMapInt(mMessage, "back_color", 0)
	Dim textOverride As Int = getMapInt(mMessage, "text_color", 0)
	Dim mutedOverride As Int = getMapInt(mMessage, "muted_color", 0)
	
	bubble.SetSide(side)
	bubble.SetVariant(variant)
	bubble.SetBubbleStyle("block")
	bubble.SetAvatarSize(mAvatarSize)
	bubble.SetGlobalMask(avatarMaskNow)
	bubble.SetShowOnline(OnlineIndicatorsVisible)
	bubble.SetAvatarStatusColors(onlineColor, offlineColor)
	bubble.SetVariantPalette(resolvedPalette)
	bubble.SetFromToColors(mFromBackgroundColor, mFromTextColor, mToBackgroundColor, mToTextColor)
	bubble.SetUseFromToColors(localUseFromTo)
	bubble.SetColors(backOverride, textOverride, mutedOverride)
	bubble.SetHeaderVisible(showHeader)
	If showHeader Then
		bubble.SetHeaderParts(header, headerTime)
	Else
		bubble.SetHeaderParts("", "")
	End If
	bubble.SetMessage(text)
	bubble.SetFooter(footer)
	bubble.SetStatus(statusMode, statusText)
	bubble.SetFooterVisible(showFooter)
	
	Dim abmp As B4XBitmap = getAvatarBitmapFromMessage(mMessage)
	Dim hasAvatar As Boolean = abmp.IsInitialized
	bubble.SetAvatarVisible(hasAvatar)
	If hasAvatar Then
		bubble.SetAvatarBitmap(abmp, getMapObject(mMessage, "avatar_tag", Null))
		If OnlineIndicatorsVisible Then bubble.SetAvatarStatus(avatarStatus) Else bubble.SetAvatarStatus("none")
	Else
		bubble.SetAvatarStatus("none")
	End If
End Sub

Private Sub getAvatarBitmapFromMessage(mMessage As Map) As B4XBitmap
	Dim empty As B4XBitmap
	If mMessage.ContainsKey("avatar_bitmap") Then
		Dim bmp As B4XBitmap = mMessage.Get("avatar_bitmap")
		If bmp.IsInitialized Then Return bmp
	End If
	Dim fileName As String = GetMapString(mMessage, "avatar", "")
	If fileName.Trim.Length = 0 Then Return empty
	Return AvatarByFile(fileName)
End Sub

Private Sub AddBubbleRow(bubble As B4XDaisyChatBubble, sPreferredId As String) As String
	Dim pp As Panel
	pp.Initialize("")
	Dim row As B4XView = pp
	row.Color = xui.Color_Transparent
	Dim bubbleId As String = sPreferredId
	If bubbleId.Trim.Length = 0 Then
		bubbleId = "msg_" & BubbleIndex
		BubbleIndex = BubbleIndex + 1
	End If
	If BubbleById.ContainsKey(bubbleId) Then
		Dim n As Int = 2
		Dim baseId As String = bubbleId
		Do While BubbleById.ContainsKey(baseId & "_" & n)
			n = n + 1
		Loop
		bubbleId = baseId & "_" & n
	End If
	
	Dim rowW As Int = ListWidth
	Dim rowH As Int = bubble.MeasureHeight(rowW)
	row.AddView(bubble.mBase, 0, 0, rowW, rowH)
	bubble.Base_Resize(rowW, rowH)
	Dim actualH As Int = Max(rowH, bubble.GetUsedHeight)
	If actualH <> rowH Then
		rowH = actualH
		row.SetLayoutAnimated(0, 0, 0, rowW, rowH)
		bubble.mBase.SetLayoutAnimated(0, 0, 0, rowW, rowH)
		bubble.Base_Resize(rowW, rowH)
	End If
	
	Dim y As Int = 0
	If ItemPanels.Size > 0 Then
		Dim prev As B4XView = ItemPanels.Get(ItemPanels.Size - 1)
		y = prev.Top + prev.Height + mVerticalGap
	End If
	row.Tag = bubble
	bubble.SetId(bubbleId)
	bubble.mBase.Tag = bubbleId
	pnlContent.AddView(row, 0, y, rowW, rowH)
	ItemPanels.Add(row)
	BubbleById.Put(bubbleId, bubble)
	RowById.Put(bubbleId, row)
	BubbleIds.Add(bubbleId)
	UpdateContentHeight
	Return bubbleId
End Sub

Private Sub ResolveMessageId(mMessage As Map) As String
	Dim id As String = GetMapString(mMessage, "id", "")
	Return id.Trim
End Sub

Private Sub RelayoutAll
	If ItemPanels.IsInitialized = False Then Return
	Dim y As Int = 0
	Dim rowW As Int = ListWidth
	For Each row As B4XView In ItemPanels
		Dim bubble As B4XDaisyChatBubble = row.Tag
		Dim rowH As Int = bubble.MeasureHeight(rowW)
		row.SetLayoutAnimated(0, 0, y, rowW, rowH)
		bubble.mBase.SetLayoutAnimated(0, 0, 0, rowW, rowH)
		bubble.Base_Resize(rowW, rowH)
		Dim actualH As Int = Max(rowH, bubble.GetUsedHeight)
		If actualH <> rowH Then
			rowH = actualH
			row.SetLayoutAnimated(0, 0, y, rowW, rowH)
			bubble.mBase.SetLayoutAnimated(0, 0, 0, rowW, rowH)
			bubble.Base_Resize(rowW, rowH)
		End If
		y = y + rowH + mVerticalGap
	Next
	UpdateContentHeight
End Sub

Private Sub UpdateContentHeight
	Dim h As Int = 0
	If ItemPanels.Size > 0 Then
		Dim last As B4XView = ItemPanels.Get(ItemPanels.Size - 1)
		h = last.Top + last.Height + mVerticalGap
	End If
	If sv.IsInitialized Then h = Max(h, sv.Height)
	pnlContent.Height = h
End Sub

Private Sub MaxScrollPosition As Int
	If sv.IsInitialized = False Or pnlContent.IsInitialized = False Then Return 0
	Return Max(0, pnlContent.Height - sv.Height)
End Sub

Private Sub ClampScrollPosition(iValue As Int) As Int
	Return Max(0, Min(iValue, MaxScrollPosition))
End Sub

Private Sub getMapString(mMap As Map, sKey As String, sDefaultValue As String) As String
	If mMap.ContainsKey(sKey) = False Then Return sDefaultValue
	Dim o As Object = mMap.Get(sKey)
	If o = Null Then Return sDefaultValue
	Return o
End Sub

Private Sub NormalizeBubbleStatusMode(sMode As String) As String
	If sMode = Null Then Return "none"
	Dim m As String = sMode.ToLowerCase.Trim
	Select Case m
		Case "sent", "delivered", "read"
			Return m
		Case Else
			Return "none"
	End Select
End Sub

Private Sub getMapBool(mMap As Map, sKey As String, bDefaultValue As Boolean) As Boolean
	If mMap.ContainsKey(sKey) = False Then Return bDefaultValue
	Dim o As Object = mMap.Get(sKey)
	If o = Null Then Return bDefaultValue
	Return o
End Sub

Private Sub getMapInt(mMap As Map, sKey As String, iDefaultValue As Int) As Int
	If mMap.ContainsKey(sKey) = False Then Return iDefaultValue
	Dim o As Object = mMap.Get(sKey)
	If o = Null Then Return iDefaultValue
	Return o
End Sub

Private Sub getMapObject(mMap As Map, sKey As String, oDefaultValue As Object) As Object
	If mMap.ContainsKey(sKey) = False Then Return oDefaultValue
	Dim o As Object = mMap.Get(sKey)
	If o = Null Then Return oDefaultValue
	Return o
End Sub

Private Sub getMapMap(mMap As Map, sKey As String) As Map
	Dim result As Map
	If mMap.ContainsKey(sKey) = False Then Return result
	Dim o As Object = mMap.Get(sKey)
	If o = Null Then Return result
	result = o
	Return result
End Sub

Private Sub CloneMap(mSource As Map) As Map
	Dim result As Map
	result.Initialize
	If mSource.IsInitialized = False Then Return result
	For Each k As Object In mSource.Keys
		result.Put(k, mSource.Get(k))
	Next
	Return result
End Sub

Private Sub IndexOfBubbleId(sBubbleId As String) As Int
	If BubbleIds.IsInitialized = False Then Return -1
	For i = 0 To BubbleIds.Size - 1
		If BubbleIds.Get(i) = sBubbleId Then Return i
	Next
	Return -1
End Sub

Private Sub ResolveHeaderTime(mMessage As Map, sHeaderTimeText As String) As String
	Dim explicitText As String = sHeaderTimeText.Trim
	Dim explicitMillis As Long = ParseTimeMillis(explicitText)
	Dim messageMillis As Long = ExtractMessageTimeMillis(mMessage)
	Dim resolvedMillis As Long = IIf(explicitMillis > 0, explicitMillis, messageMillis)
	If mUseTimeAgo Then
		If resolvedMillis > 0 Then
			If mShowTimeAgoForToday Then
				If IsSameDeviceDate(resolvedMillis, DateTime.Now) Then
					Return FormatTimeAgo(resolvedMillis)
				Else
					Return FormatTimestamp(resolvedMillis)
				End If
			Else
				Return FormatTimeAgo(resolvedMillis)
			End If
		End If
		Return explicitText
	End If
	If resolvedMillis > 0 Then Return FormatTimestamp(resolvedMillis)
	If explicitText.Length > 0 Then Return explicitText
	Return ""
End Sub

Private Sub IsSameDeviceDate(lTicks1 As Long, lTicks2 As Long) As Boolean
	Return DateTime.GetYear(lTicks1) = DateTime.GetYear(lTicks2) And _
		DateTime.GetMonth(lTicks1) = DateTime.GetMonth(lTicks2) And _
		DateTime.GetDayOfMonth(lTicks1) = DateTime.GetDayOfMonth(lTicks2)
End Sub

Private Sub ExtractMessageTimeMillis(mMessage As Map) As Long
	Dim keys As List
	keys.Initialize
	keys.AddAll(Array("time_millis", "timestamp", "created_at", "time", "header_time"))
	For Each k As String In keys
		If mMessage.ContainsKey(k) = False Then Continue
		Dim raw As Object = mMessage.Get(k)
		Dim parsed As Long = ParseTimeMillis(raw)
		If parsed > 0 Then Return parsed
	Next
	Return 0
End Sub

Private Sub ParseTimeMillis(oValue As Object) As Long
	If oValue = Null Then Return 0
	Dim t As String = oValue
	t = t.Trim
	If t.Length = 0 Then Return 0
	If Regex.IsMatch("^[0-9]+$", t) Then
		Dim n As Long = t
		If n < 1000000000000 Then n = n * 1000
		Return n
	End If
	Return ParseDateTimeText(t)
End Sub

Private Sub ParseDateTimeText(sText As String) As Long
	Dim prevFormat As String = DateTime.DateFormat
	Dim patterns As List
	patterns.Initialize
	patterns.AddAll(Array("yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", mDateTimeFormat))
	For Each fmt As String In patterns
		Try
			DateTime.DateFormat = fmt
			Dim ticks As Long = DateTime.DateParse(sText)
			DateTime.DateFormat = prevFormat
			Return ticks
		Catch
			DateTime.DateFormat = prevFormat
		End Try
	Next
	DateTime.DateFormat = prevFormat
	Return 0
End Sub

Private Sub FormatTimestamp(lValueMillis As Long) As String
	Return B4XDaisyVariants.FormatDateTime(mDateTimeFormat, lValueMillis)
End Sub

Private Sub FormatTimeAgo(lValueMillis As Long) As String
	Dim delta As Long = Max(0, DateTime.Now - lValueMillis)
	Dim sec As Long = delta / DateTime.TicksPerSecond
	If sec < 60 Then Return "just now"
	Dim minutes As Long = sec / 60
	If minutes < 60 Then Return minutes & "m ago"
	Dim hours As Long = minutes / 60
	If hours < 24 Then Return hours & "h ago"
	Dim days As Long = hours / 24
	If days < 7 Then Return days & "d ago"
	Return FormatTimestamp(lValueMillis)
End Sub

Public Sub LoadAvatarFilesFromAssets(lstFiles As List)
	AvatarFiles.Clear
	AvatarCache.Clear
	If lstFiles.IsInitialized = False Then Return
	For Each fn As String In lstFiles
		If File.Exists(File.DirAssets, fn) Then
			AvatarFiles.Add(fn)
			AvatarCache.Put(fn, xui.LoadBitmap(File.DirAssets, fn))
		End If
	Next
End Sub

Public Sub setAvatarFiles(lstFiles As List)
	LoadAvatarFilesFromAssets(lstFiles)
End Sub

Public Sub getAvatarFiles As List
	Dim r As List
	r.Initialize
	For Each fn As String In AvatarFiles
		r.Add(fn)
	Next
	Return r
End Sub

Public Sub RandomAvatarFileOrBlank(iBlankPct As Int) As String
	If AvatarFiles.IsInitialized = False Or AvatarFiles.Size = 0 Then Return ""
	If Rnd(0, 100) < iBlankPct Then Return ""
	Return AvatarFiles.Get(Rnd(0, AvatarFiles.Size))
End Sub

Public Sub RandomAvatarStatus As String
	Dim r As Int = Rnd(0, 100)
	If r < 35 Then Return "online"
	If r < 65 Then Return "offline"
	Return "none"
End Sub

Private Sub AvatarByFile(sFileName As String) As B4XBitmap
	Dim empty As B4XBitmap
	Dim key As String = sFileName.Trim
	If key.Length = 0 Then Return empty
	If AvatarCache.IsInitialized = False Then AvatarCache.Initialize
	If AvatarCache.ContainsKey(key) Then Return AvatarCache.Get(key)
	
	Dim bmp As B4XBitmap = LoadBitmapFromPathIfExists(key)
	If bmp.IsInitialized = False Then
		If File.Exists(File.DirAssets, key) Then bmp = xui.LoadBitmap(File.DirAssets, key)
	End If
	If bmp.IsInitialized Then AvatarCache.Put(key, bmp)
	Return bmp
End Sub

Private Sub LoadBitmapFromPathIfExists(sFullPath As String) As B4XBitmap
	Dim empty As B4XBitmap
	Dim p As String = sFullPath.Trim
	If p.Length = 0 Then Return empty
	Dim slash1 As Int = p.LastIndexOf("/")
	Dim slash2 As Int = p.LastIndexOf("\")
	Dim slash As Int = Max(slash1, slash2)
	If slash <= 0 Then Return empty
	Dim dir As String = p.SubString2(0, slash)
	Dim fn As String = p.SubString(slash + 1)
	If dir.Length = 0 Or fn.Length = 0 Then Return empty
	If File.Exists(dir, fn) = False Then Return empty
	Return xui.LoadBitmap(dir, fn)
End Sub

Public Sub setBubbleAvatarStatusById(sBubbleId As String, sMode As String)
	If BubbleById.IsInitialized = False Then Return
	If BubbleById.ContainsKey(sBubbleId) = False Then Return
	Dim bubble As B4XDaisyChatBubble = BubbleById.Get(sBubbleId)
	bubble.SetAvatarStatus(sMode)
	If MessageById.IsInitialized And MessageById.ContainsKey(sBubbleId) Then
		Dim m As Map = CloneMap(MessageById.Get(sBubbleId))
		m.Put("avatar_status", sMode)
		MessageById.Put(sBubbleId, m)
	End If
End Sub

Public Sub getBubbleIds As List
	Dim result As List
	result.Initialize
	If BubbleIds.IsInitialized = False Then Return result
	For Each id As String In BubbleIds
		result.Add(id)
	Next
	Return result
End Sub

Public Sub setAvatarMask(sMask As String)
	mAvatarMask = B4XDaisyVariants.NormalizeMask(sMask)
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getAvatarMask As String
	Return mAvatarMask
End Sub

Public Sub setMask(sMask As String)
	setAvatarMask(sMask)
End Sub

Public Sub setAvatarSize(iSize As Int)
	mAvatarSize = Max(16dip, iSize)
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getAvatarSize As Int
	Return Round(mAvatarSize)
End Sub

Public Sub setFromBackgroundColor(iColor As Int)
	mFromBackgroundColor = iColor
	mUseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getFromBackgroundColor As Int
	Return mFromBackgroundColor
End Sub

Public Sub setFromTextColor(iColor As Int)
	mFromTextColor = iColor
	mUseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getFromTextColor As Int
	Return mFromTextColor
End Sub

Public Sub setToBackgroundColor(iColor As Int)
	mToBackgroundColor = iColor
	mUseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getToBackgroundColor As Int
	Return mToBackgroundColor
End Sub

Public Sub setToTextColor(iColor As Int)
	mToTextColor = iColor
	mUseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getToTextColor As Int
	Return mToTextColor
End Sub

Public Sub setFromToColors(iFromBack As Int, iFromText As Int, iToBack As Int, iToText As Int)
	mFromBackgroundColor = iFromBack
	mFromTextColor = iFromText
	mToBackgroundColor = iToBack
	mToTextColor = iToText
	mUseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub setUseFromToColors(bEnabled As Boolean)
	mUseFromToColors = bEnabled
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getUseFromToColors As Boolean
	Return mUseFromToColors
End Sub

Public Sub setTheme(sName As String)
	InitializeThemes
	Dim key As String = NormalizeThemeName(sName)
	If Themes.ContainsKey(key) Then
		CurrentTheme = key
		ReconfigureAllBubblesFromMessages(False)
	End If
End Sub

Public Sub getTheme As String
	InitializeThemes
	Return CurrentTheme
End Sub

Public Sub setDateTimeFormat(sValue As String)
	mDateTimeFormat = B4XDaisyVariants.NormalizeDateTimeFormat(sValue, "D, j M Y H:i")
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getDateTimeFormat As String
	Return mDateTimeFormat
End Sub

Public Sub setUseTimeAgo(bEnabled As Boolean)
	mUseTimeAgo = bEnabled
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getUseTimeAgo As Boolean
	Return mUseTimeAgo
End Sub

Public Sub setShowTimeAgoForToday(bEnabled As Boolean)
	mShowTimeAgoForToday = bEnabled
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getShowTimeAgoForToday As Boolean
	Return mShowTimeAgoForToday
End Sub

Public Sub RegisterTheme(sName As String, mPaletteMap As Map)
	InitializeThemes
	If mPaletteMap.IsInitialized = False Then Return
	Dim key As String = NormalizeThemeName(sName)
	If key.Length = 0 Then Return
	Themes.Put(key, mPaletteMap)
	If key = CurrentTheme Then ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getPalette As Map
	Return ResolvePalette("")
End Sub

Public Sub CreateVariant(iBackColor As Int, iTextColor As Int) As Map
	Return VariantMap(iBackColor, iTextColor)
End Sub

Public Sub ShowOnline(bEnabled As Boolean)
	OnlineIndicatorsVisible = bEnabled
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub setOnlineStatusColors(iOnlineColor As Int, iOfflineColor As Int)
	If iOnlineColor <> 0 Then AvatarOnlineColor = iOnlineColor
	If iOfflineColor <> 0 Then AvatarOfflineColor = iOfflineColor
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getOnlineStatusColor As Int
	Return AvatarOnlineColor
End Sub

Public Sub getOfflineStatusColor As Int
	Return AvatarOfflineColor
End Sub

Public Sub setVerticalGap(iGap As Int)
	mVerticalGap = Max(0, iGap)
	RelayoutAll
End Sub

Public Sub getVerticalGap As Int
	Return mVerticalGap
End Sub

Public Sub setWidth(iValue As Int)
	ChatWidth = Max(1dip, iValue)
	ApplyComponentSize
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return ChatWidth
End Sub

Public Sub setHeight(iValue As Int)
	ChatHeight = Max(1dip, iValue)
	ApplyComponentSize
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return ChatHeight
End Sub

Public Sub setSize(iWidth As Int, iHeight As Int)
	ChatWidth = Max(1dip, iWidth)
	ChatHeight = Max(1dip, iHeight)
	ApplyComponentSize
End Sub

Private Sub ReconfigureAllBubblesFromMessages(bDoRelayout As Boolean)
	If BubbleIds.IsInitialized = False Then Return
	If BubbleById.IsInitialized = False Then Return
	If MessageById.IsInitialized = False Then Return
	For Each id As String In BubbleIds
		If BubbleById.ContainsKey(id) = False Then Continue
		Dim bubble As B4XDaisyChatBubble = BubbleById.Get(id)
		Dim source As Map
		If MessageById.ContainsKey(id) Then
			source = CloneMap(MessageById.Get(id))
		Else
			source.Initialize
		End If
		source.Put("id", id)
		ConfigureBubbleFromMessage(bubble, source)
		MessageById.Put(id, source)
	Next
	If bDoRelayout Then RelayoutAll
End Sub
Private Sub bubble_AvatarClick(oTag As Object)
	If xui.SubExists(mCallBack, mEventName & "_AvatarClick", 1) Then
		CallSub2(mCallBack, mEventName & "_AvatarClick", oTag)
	End If
End Sub

Private Sub ResolvePalette(sThemeName As String) As Map
	InitializeThemes
	Dim key As String = NormalizeThemeName(sThemeName)
	If key.Length > 0 And Themes.ContainsKey(key) Then Return Themes.Get(key)
	If Themes.ContainsKey(CurrentTheme) Then Return Themes.Get(CurrentTheme)
	Return Themes.Get("light")
End Sub

Private Sub NormalizeThemeName(sName As String) As String
	If sName = Null Then Return ""
	Return sName.ToLowerCase.Trim
End Sub

Private Sub InitializeThemes
	If Themes.IsInitialized Then Return
	Themes.Initialize
	RegisterDefaultThemes
	CurrentTheme = "light"
End Sub

Private Sub RegisterDefaultThemes
	'FlyonUI theme tokens mapped to component variants.
	Dim pDefault As Map = CreatePalette( _
		xui.Color_RGB(61,42,81), xui.Color_RGB(254,253,255), _
		xui.Color_RGB(192,132,252), xui.Color_RGB(243,232,255), _
		xui.Color_RGB(151,146,158), xui.Color_RGB(61,42,81), _
		xui.Color_RGB(96,165,250), xui.Color_RGB(251,207,232), _
		xui.Color_RGB(34,211,238), xui.Color_RGB(207,250,254), _
		xui.Color_RGB(52,211,153), xui.Color_RGB(209,250,229), _
		xui.Color_RGB(251,146,60), xui.Color_RGB(255,237,213), _
		xui.Color_RGB(252,141,121), xui.Color_RGB(255,245,237))
	Themes.Put("default", pDefault)

	Dim pLight As Map = CreatePalette( _
		xui.Color_RGB(61,42,81), xui.Color_RGB(254,253,255), _
		xui.Color_RGB(192,132,252), xui.Color_RGB(243,232,255), _
		xui.Color_RGB(151,146,158), xui.Color_RGB(61,42,81), _
		xui.Color_RGB(96,165,250), xui.Color_RGB(251,207,232), _
		xui.Color_RGB(34,211,238), xui.Color_RGB(207,250,254), _
		xui.Color_RGB(52,211,153), xui.Color_RGB(209,250,229), _
		xui.Color_RGB(251,146,60), xui.Color_RGB(255,237,213), _
		xui.Color_RGB(252,141,121), xui.Color_RGB(255,245,237))
	Themes.Put("light", pLight)
End Sub

Private Sub CreatePalette(neutralBack As Int, neutralText As Int, _
	primaryBack As Int, primaryText As Int, _
	secondaryBack As Int, secondaryText As Int, _
	accentBack As Int, accentText As Int, _
	infoBack As Int, infoText As Int, _
	successBack As Int, successText As Int, _
	warningBack As Int, warningText As Int, _
	errorBack As Int, errorText As Int) As Map

	Dim m As Map
	m.Initialize
	m.Put("neutral", VariantMap(neutralBack, neutralText))
	m.Put("primary", VariantMap(primaryBack, primaryText))
	m.Put("secondary", VariantMap(secondaryBack, secondaryText))
	m.Put("accent", VariantMap(accentBack, accentText))
	m.Put("info", VariantMap(infoBack, infoText))
	m.Put("success", VariantMap(successBack, successText))
	m.Put("warning", VariantMap(warningBack, warningText))
	m.Put("error", VariantMap(errorBack, errorText))
	Return m
End Sub

Private Sub VariantMap(iBack As Int, iText As Int) As Map
	Dim vm As Map
	vm.Initialize
	vm.Put("back", iBack)
	vm.Put("text", iText)
	vm.Put("muted", Blend(iText, xui.Color_Gray, 0.35))
	Return vm
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
