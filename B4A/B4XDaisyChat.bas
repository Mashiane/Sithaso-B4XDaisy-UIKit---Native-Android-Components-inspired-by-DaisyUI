B4A=true
Group=Default Group\DaisuyUIKit
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

	Private AvatarMask As String = "squircle"
	Private AvatarSize As Float = 40dip
	Private FromBackgroundColor As Int = 0xFF4338CA
	Private FromTextColor As Int = 0xFFFFFFFF
	Private ToBackgroundColor As Int = 0xFF0EA5E9
	Private ToTextColor As Int = 0xFF082F49
	Private UseFromToColors As Boolean = True
	Private Themes As Map
	Private CurrentTheme As String = "light"
	Private DateTimeFormat As String = "D, j M Y H:i"
	Private UseTimeAgo As Boolean = False
	Private ShowTimeAgoForToday As Boolean = True
	Private OnlineIndicatorsVisible As Boolean = True
	Private VerticalGap As Int = 8dip
	Private ChatWidth As Int = 0
	Private ChatHeight As Int = 0
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private AvatarOnlineColor As Int = 0xFF2ECC71
	Private AvatarOfflineColor As Int = 0xFFB4B4B4
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	InitializeThemes
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

	ApplyDesignerProps(Props)
	ApplyComponentSize
End Sub

Public Sub Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	If sv.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, 0, 0, Width, Height)
	ChatWidth = Width
	ChatHeight = Height
	Dim contentRect As B4XRect = ResolveContentRectForBounds(Width, Height)
	sv.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	RelayoutAll
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	If sv.IsInitialized = False Then Return
	ChatWidth = Width
	ChatHeight = Height
	Dim contentRect As B4XRect = ResolveContentRectForBounds(Width, Height)
	sv.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	RelayoutAll
End Sub

Public Sub AddToParent(Parent As B4XView)
	AddToParentAt(Parent, 0, 0, Parent.Width, Parent.Height)
End Sub

Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If Parent.IsInitialized = False Then Return
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
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If pnlContent.IsInitialized Then Return pnlContent
	If mBase.IsInitialized Then Return mBase
	Return empty
End Sub

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If pnlContent.IsInitialized Then
		pnlContent.AddView(ChildView, Left, Top, Width, Height)
		Return
	End If
	If mBase.IsInitialized Then mBase.AddView(ChildView, Left, Top, Width, Height)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And sv.IsInitialized And mBase.Width > 0
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	AvatarMask = B4XDaisyVariants.NormalizeMask(getPropString(Props, "AvatarMask", AvatarMask))
	AvatarSize = Max(16dip, getPropDip(Props, "AvatarSize", AvatarSize))
	FromBackgroundColor = getPropInt(Props, "FromBackgroundColor", FromBackgroundColor)
	FromTextColor = getPropInt(Props, "FromTextColor", FromTextColor)
	ToBackgroundColor = getPropInt(Props, "ToBackgroundColor", ToBackgroundColor)
	ToTextColor = getPropInt(Props, "ToTextColor", ToTextColor)
	UseFromToColors = getPropBool(Props, "UseFromToColors", UseFromToColors)
	setTheme(getPropString(Props, "Theme", CurrentTheme))
	DateTimeFormat = B4XDaisyVariants.NormalizeDateTimeFormat(getPropString(Props, "DateTimeFormat", DateTimeFormat), "D, j M Y H:i")
	UseTimeAgo = getPropBool(Props, "UseTimeAgo", UseTimeAgo)
	ShowTimeAgoForToday = getPropBool(Props, "ShowTimeAgoForToday", ShowTimeAgoForToday)
	VerticalGap = Max(0, getPropDip(Props, "VerticalGap", VerticalGap))
	ChatWidth = Max(0, getPropDip(Props, "Width", 0))
	ChatHeight = Max(0, getPropDip(Props, "Height", 0))
	mPadding = getPropString(Props, "Padding", mPadding)
	mMargin = getPropString(Props, "Margin", mMargin)
	
	AvatarOnlineColor = getPropInt(Props, "OnlineColor", AvatarOnlineColor)
	AvatarOfflineColor = getPropInt(Props, "OfflineColor", AvatarOfflineColor)
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub







Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setPadding(Value As String)
	mPadding = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Private Sub getPropDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, 0) * 1dip
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

Private Sub ResolveContentRectForBounds(Width As Float, Height As Float) As B4XRect
	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, Width), Max(1dip, Height))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Return B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
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

Private Sub getPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub getPropFloat(Props As Map, Key As String, DefaultValue As Float) As Float
	Return B4XDaisyVariants.GetPropFloat(Props, Key, DefaultValue)
End Sub

Private Sub getPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub getPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

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

Public Sub setConversations(Messages As List)
	Clear
	If Messages.IsInitialized = False Then Return
	For Each m As Map In Messages
		AddMessage(m, False)
	Next
End Sub

Public Sub ClearConversations
	Clear
End Sub

Public Sub AppendMessage(Message As Map) As String
	Return AddMessage(Message, False)
End Sub

Public Sub AppendMessageAndScroll(Message As Map, Smooth As Boolean) As String
	Dim id As String = AddMessage(Message, False)
	If Smooth Then
		SmoothScrollToMessage(id, 450)
	Else
		ScrollToMessage(id)
	End If
	Return id
End Sub

Public Sub ScrollToMessage(BubbleId As String)
	If RowById.IsInitialized = False Or sv.IsInitialized = False Then Return
	If RowById.ContainsKey(BubbleId) = False Then Return
	Dim row As B4XView = RowById.Get(BubbleId)
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

Public Sub SmoothScrollToTop(DurationMs As Int) As ResumableSub
	Wait For (SmoothScrollToPosition(0, DurationMs)) Complete (ok As Boolean)
	Return ok
End Sub

Public Sub SmoothScrollToBottom(DurationMs As Int) As ResumableSub
	Wait For (SmoothScrollToPosition(MaxScrollPosition, DurationMs)) Complete (ok As Boolean)
	Return ok
End Sub

Public Sub SmoothScrollToMessage(BubbleId As String, DurationMs As Int) As ResumableSub
	If RowById.IsInitialized = False Or RowById.ContainsKey(BubbleId) = False Then Return False
	Dim row As B4XView = RowById.Get(BubbleId)
	Wait For (SmoothScrollToPosition(row.Top, DurationMs)) Complete (ok As Boolean)
	Return ok
End Sub

Public Sub SmoothScrollToPosition(Target As Int, DurationMs As Int) As ResumableSub
	If sv.IsInitialized = False Then Return False
	Dim targetClamped As Int = ClampScrollPosition(Target)
	Dim startPos As Int = sv.ScrollPosition
	If DurationMs <= 0 Or startPos = targetClamped Then
		sv.ScrollPosition = targetClamped
		Return True
	End If
	Dim frameMs As Int = 16
	Dim steps As Int = Max(1, DurationMs / frameMs)
	Dim stepDelay As Int = Max(10, DurationMs / steps)
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

Public Sub getMessageById(BubbleId As String) As Map
	Dim result As Map
	result.Initialize
	If MessageById.IsInitialized = False Then Return result
	If MessageById.ContainsKey(BubbleId) = False Then Return result
	Return CloneMap(MessageById.Get(BubbleId))
End Sub

Public Sub getMessage(BubbleId As String) As Map
	Return GetMessageById(BubbleId)
End Sub

Public Sub UpdateMessageById(BubbleId As String, Fields As Map) As Boolean
	If MessageById.IsInitialized = False Or MessageById.ContainsKey(BubbleId) = False Then Return False
	If Fields.IsInitialized = False Then Return False
	Dim merged As Map = CloneMap(MessageById.Get(BubbleId))
	For Each k As String In Fields.Keys
		merged.Put(k, Fields.Get(k))
	Next
	Return ReplaceMessageById(BubbleId, merged)
End Sub

Public Sub UpdateMessage(Message As Map) As Boolean
	If Message.IsInitialized = False Then Return False
	Dim bubbleId As String = ResolveMessageId(Message)
	If bubbleId.Length = 0 Then Return False
	Dim fields As Map = CloneMap(Message)
	If fields.ContainsKey("id") Then fields.Remove("id")
	If fields.ContainsKey("Id") Then fields.Remove("Id")
	If fields.Size = 0 Then Return MessageById.IsInitialized And MessageById.ContainsKey(bubbleId)
	Return UpdateMessageById(bubbleId, fields)
End Sub

Public Sub UpdateHeaderById(BubbleId As String, HeaderName As String, HeaderTime As String) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("header", HeaderName)
	m.Put("header_time", HeaderTime)
	Return UpdateMessageById(BubbleId, m)
End Sub

Public Sub UpdateFooterById(BubbleId As String, FooterText As String) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("footer", FooterText)
	Return UpdateMessageById(BubbleId, m)
End Sub

Public Sub UpdateAvatarById(BubbleId As String, AvatarBitmap As B4XBitmap) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("avatar_bitmap", AvatarBitmap)
	m.Put("avatar", "")
	Return UpdateMessageById(BubbleId, m)
End Sub

Public Sub UpdateOnlineStatusById(BubbleId As String, Status As String, OnlineColor As Int) As Boolean
	Dim m As Map
	m.Initialize
	m.Put("avatar_status", Status)
	If OnlineColor <> 0 Then m.Put("avatar_online_color", OnlineColor)
	Return UpdateMessageById(BubbleId, m)
End Sub

Public Sub ReplaceMessageById(BubbleId As String, Message As Map) As Boolean
	If BubbleById.IsInitialized = False Or BubbleById.ContainsKey(BubbleId) = False Then Return False
	If Message.IsInitialized = False Then Return False
	Dim bubble As B4XDaisyChatBubble = BubbleById.Get(BubbleId)
	Dim source As Map = CloneMap(Message)
	source.Put("id", BubbleId)
	ConfigureBubbleFromMessage(bubble, source)
	MessageById.Put(BubbleId, source)
	RelayoutAll
	Return True
End Sub

Public Sub DeleteMessageById(BubbleId As String) As Boolean
	If BubbleIds.IsInitialized = False Then Return False
	Dim idx As Int = IndexOfBubbleId(BubbleId)
	If idx = -1 Then Return False
	Dim row As B4XView = ItemPanels.Get(idx)
	row.RemoveViewFromParent
	ItemPanels.RemoveAt(idx)
	BubbleIds.RemoveAt(idx)
	If BubbleById.IsInitialized Then BubbleById.Remove(BubbleId)
	If RowById.IsInitialized Then RowById.Remove(BubbleId)
	If MessageById.IsInitialized Then MessageById.Remove(BubbleId)
	RelayoutAll
	Return True
End Sub

Public Sub AddMessage(Message As Map, ScrollTo As Boolean) As String
	If Message.IsInitialized = False Then Message = CreateMap()
	Dim source As Map = CloneMap(Message)
	
	Dim bubble As B4XDaisyChatBubble
	bubble.Initialize(Me, "bubble")
	bubble.CreateView(ListWidth, 10dip)
	ConfigureBubbleFromMessage(bubble, source)
	Dim bubbleId As String = AddBubbleRow(bubble, ResolveMessageId(source))
	source.Put("id", bubbleId)
	MessageById.Put(bubbleId, source)
	If ScrollTo Then ScrollToMessage(bubbleId)
	Return bubbleId
End Sub

Private Sub ConfigureBubbleFromMessage(bubble As B4XDaisyChatBubble, Message As Map)
	Dim side As String = GetMapString(Message, "side", "start")
	If side <> "end" Then side = "start"
	Dim variantRaw As String = GetMapString(Message, "variant", "")
	Dim hasVariant As Boolean = variantRaw.Trim.Length > 0
	Dim variant As String = "neutral"
	If hasVariant Then variant = variantRaw
	Dim text As String = GetMapString(Message, "text", "")
	Dim header As String = GetMapString(Message, "header", "")
	Dim headerTimeRaw As String = GetMapString(Message, "header_time", "")
	Dim headerTime As String = ResolveHeaderTime(Message, headerTimeRaw)
	Dim footer As String = GetMapString(Message, "footer", "")
	Dim statusMode As String = NormalizeBubbleStatusMode(GetMapString(Message, "status_mode", "none"))
	Dim statusText As String = GetMapString(Message, "status_text", "")
	Dim localUseFromTo As Boolean = UseFromToColors
	If hasVariant Then localUseFromTo = False
	If Message.ContainsKey("use_from_to_colors") Then localUseFromTo = GetMapBool(Message, "use_from_to_colors", localUseFromTo)
	Dim messageTheme As String = GetMapString(Message, "theme", "")
	Dim messagePalette As Map = GetMapMap(Message, "theme_palette")
	Dim resolvedPalette As Map
	If messagePalette.IsInitialized Then
		resolvedPalette = messagePalette
	Else
		resolvedPalette = ResolvePalette(messageTheme)
	End If
	Dim showHeader As Boolean
	If Message.ContainsKey("show_header") Then
		showHeader = getMapBool(Message, "show_header", False)
	Else
		showHeader = (header.Length > 0 Or headerTime.Length > 0)
	End If
	Dim showFooter As Boolean
	If Message.ContainsKey("show_footer") Then
		showFooter = getMapBool(Message, "show_footer", False)
	Else
		showFooter = (footer.Length > 0 Or statusMode <> "none" Or statusText.Length > 0)
	End If
	Dim avatarStatus As String = getMapString(Message, "avatar_status", "none")
	If avatarStatus = "" Then avatarStatus = "none"
	Dim onlineColor As Int = getMapInt(Message, "avatar_online_color", AvatarOnlineColor)
	Dim offlineColor As Int = getMapInt(Message, "avatar_offline_color", AvatarOfflineColor)
	Dim avatarMaskNow As String = getMapString(Message, "avatar_mask", AvatarMask)
	Dim backOverride As Int = getMapInt(Message, "back_color", 0)
	Dim textOverride As Int = getMapInt(Message, "text_color", 0)
	Dim mutedOverride As Int = getMapInt(Message, "muted_color", 0)
	
	bubble.SetSide(side)
	bubble.SetVariant(variant)
	bubble.SetBubbleStyle("block")
	bubble.SetAvatarSize(AvatarSize)
	bubble.SetGlobalMask(avatarMaskNow)
	bubble.SetShowOnline(OnlineIndicatorsVisible)
	bubble.SetAvatarStatusColors(onlineColor, offlineColor)
	bubble.SetVariantPalette(resolvedPalette)
	bubble.SetFromToColors(FromBackgroundColor, FromTextColor, ToBackgroundColor, ToTextColor)
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
	
	Dim abmp As B4XBitmap = getAvatarBitmapFromMessage(Message)
	Dim hasAvatar As Boolean = abmp.IsInitialized
	bubble.SetAvatarVisible(hasAvatar)
	If hasAvatar Then
		bubble.SetAvatarBitmap(abmp, getMapObject(Message, "avatar_tag", Null))
		If OnlineIndicatorsVisible Then bubble.SetAvatarStatus(avatarStatus) Else bubble.SetAvatarStatus("none")
	Else
		bubble.SetAvatarStatus("none")
	End If
End Sub

Private Sub getAvatarBitmapFromMessage(Message As Map) As B4XBitmap
	Dim empty As B4XBitmap
	If Message.ContainsKey("avatar_bitmap") Then
		Dim bmp As B4XBitmap = Message.Get("avatar_bitmap")
		If bmp.IsInitialized Then Return bmp
	End If
	Dim fileName As String = GetMapString(Message, "avatar", "")
	If fileName.Trim.Length = 0 Then Return empty
	Return AvatarByFile(fileName)
End Sub

Private Sub AddBubbleRow(bubble As B4XDaisyChatBubble, PreferredId As String) As String
	Dim pp As Panel
	pp.Initialize("")
	Dim row As B4XView = pp
	row.Color = xui.Color_Transparent
	Dim bubbleId As String = PreferredId
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
		y = prev.Top + prev.Height + VerticalGap
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

Private Sub ResolveMessageId(Message As Map) As String
	Dim id As String = GetMapString(Message, "id", "")
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
		y = y + rowH + VerticalGap
	Next
	UpdateContentHeight
End Sub

Private Sub UpdateContentHeight
	Dim h As Int = 0
	If ItemPanels.Size > 0 Then
		Dim last As B4XView = ItemPanels.Get(ItemPanels.Size - 1)
		h = last.Top + last.Height + VerticalGap
	End If
	If sv.IsInitialized Then h = Max(h, sv.Height)
	pnlContent.Height = h
End Sub

Private Sub MaxScrollPosition As Int
	If sv.IsInitialized = False Or pnlContent.IsInitialized = False Then Return 0
	Return Max(0, pnlContent.Height - sv.Height)
End Sub

Private Sub ClampScrollPosition(Value As Int) As Int
	Return Max(0, Min(Value, MaxScrollPosition))
End Sub

Private Sub getMapString(m As Map, key As String, DefaultValue As String) As String
	If m.ContainsKey(key) = False Then Return DefaultValue
	Dim o As Object = m.Get(key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Private Sub NormalizeBubbleStatusMode(Mode As String) As String
	If Mode = Null Then Return "none"
	Dim m As String = Mode.ToLowerCase.Trim
	Select Case m
		Case "sent", "delivered", "read"
			Return m
		Case Else
			Return "none"
	End Select
End Sub

Private Sub getMapBool(m As Map, key As String, DefaultValue As Boolean) As Boolean
	If m.ContainsKey(key) = False Then Return DefaultValue
	Dim o As Object = m.Get(key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Private Sub getMapInt(m As Map, key As String, DefaultValue As Int) As Int
	If m.ContainsKey(key) = False Then Return DefaultValue
	Dim o As Object = m.Get(key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Private Sub getMapObject(m As Map, key As String, DefaultValue As Object) As Object
	If m.ContainsKey(key) = False Then Return DefaultValue
	Dim o As Object = m.Get(key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Private Sub getMapMap(m As Map, key As String) As Map
	Dim result As Map
	If m.ContainsKey(key) = False Then Return result
	Dim o As Object = m.Get(key)
	If o = Null Then Return result
	result = o
	Return result
End Sub

Private Sub CloneMap(Source As Map) As Map
	Dim result As Map
	result.Initialize
	If Source.IsInitialized = False Then Return result
	For Each k As Object In Source.Keys
		result.Put(k, Source.Get(k))
	Next
	Return result
End Sub

Private Sub IndexOfBubbleId(BubbleId As String) As Int
	If BubbleIds.IsInitialized = False Then Return -1
	For i = 0 To BubbleIds.Size - 1
		If BubbleIds.Get(i) = BubbleId Then Return i
	Next
	Return -1
End Sub

Private Sub ResolveHeaderTime(Message As Map, HeaderTimeText As String) As String
	Dim explicitText As String = HeaderTimeText.Trim
	Dim explicitMillis As Long = ParseTimeMillis(explicitText)
	Dim messageMillis As Long = ExtractMessageTimeMillis(Message)
	Dim resolvedMillis As Long = IIf(explicitMillis > 0, explicitMillis, messageMillis)
	If UseTimeAgo Then
		If resolvedMillis > 0 Then
			If ShowTimeAgoForToday Then
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

Private Sub IsSameDeviceDate(Ticks1 As Long, Ticks2 As Long) As Boolean
	Return DateTime.GetYear(Ticks1) = DateTime.GetYear(Ticks2) And _
		DateTime.GetMonth(Ticks1) = DateTime.GetMonth(Ticks2) And _
		DateTime.GetDayOfMonth(Ticks1) = DateTime.GetDayOfMonth(Ticks2)
End Sub

Private Sub ExtractMessageTimeMillis(Message As Map) As Long
	Dim keys As List
	keys.Initialize
	keys.AddAll(Array("time_millis", "timestamp", "created_at", "time", "header_time"))
	For Each k As String In keys
		If Message.ContainsKey(k) = False Then Continue
		Dim raw As Object = Message.Get(k)
		Dim parsed As Long = ParseTimeMillis(raw)
		If parsed > 0 Then Return parsed
	Next
	Return 0
End Sub

Private Sub ParseTimeMillis(Value As Object) As Long
	If Value = Null Then Return 0
	Dim t As String = Value
	t = t.Trim
	If t.Length = 0 Then Return 0
	If Regex.IsMatch("^[0-9]+$", t) Then
		Dim n As Long = t
		If n < 1000000000000 Then n = n * 1000
		Return n
	End If
	Return ParseDateTimeText(t)
End Sub

Private Sub ParseDateTimeText(Text As String) As Long
	Dim prevFormat As String = DateTime.DateFormat
	Dim patterns As List
	patterns.Initialize
	patterns.AddAll(Array("yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", DateTimeFormat))
	For Each fmt As String In patterns
		Try
			DateTime.DateFormat = fmt
			Dim ticks As Long = DateTime.DateParse(Text)
			DateTime.DateFormat = prevFormat
			Return ticks
		Catch
			DateTime.DateFormat = prevFormat
		End Try
	Next
	DateTime.DateFormat = prevFormat
	Return 0
End Sub

Private Sub FormatTimestamp(ValueMillis As Long) As String
	Return B4XDaisyVariants.FormatDateTime(DateTimeFormat, ValueMillis)
End Sub

Private Sub FormatTimeAgo(ValueMillis As Long) As String
	Dim delta As Long = Max(0, DateTime.Now - ValueMillis)
	Dim sec As Long = delta / DateTime.TicksPerSecond
	If sec < 60 Then Return "just now"
	Dim minutes As Long = sec / 60
	If minutes < 60 Then Return minutes & "m ago"
	Dim hours As Long = minutes / 60
	If hours < 24 Then Return hours & "h ago"
	Dim days As Long = hours / 24
	If days < 7 Then Return days & "d ago"
	Return FormatTimestamp(ValueMillis)
End Sub

Public Sub LoadAvatarFilesFromAssets(Files As List)
	AvatarFiles.Clear
	AvatarCache.Clear
	If Files.IsInitialized = False Then Return
	For Each fn As String In Files
		If File.Exists(File.DirAssets, fn) Then
			AvatarFiles.Add(fn)
			AvatarCache.Put(fn, xui.LoadBitmap(File.DirAssets, fn))
		End If
	Next
End Sub

Public Sub setAvatarFiles(Files As List)
	LoadAvatarFilesFromAssets(Files)
End Sub

Public Sub getAvatarFiles As List
	Dim r As List
	r.Initialize
	For Each fn As String In AvatarFiles
		r.Add(fn)
	Next
	Return r
End Sub

Public Sub RandomAvatarFileOrBlank(BlankPct As Int) As String
	If AvatarFiles.IsInitialized = False Or AvatarFiles.Size = 0 Then Return ""
	If Rnd(0, 100) < BlankPct Then Return ""
	Return AvatarFiles.Get(Rnd(0, AvatarFiles.Size))
End Sub

Public Sub RandomAvatarStatus As String
	Dim r As Int = Rnd(0, 100)
	If r < 35 Then Return "online"
	If r < 65 Then Return "offline"
	Return "none"
End Sub

Private Sub AvatarByFile(FileName As String) As B4XBitmap
	Dim empty As B4XBitmap
	Dim key As String = FileName.Trim
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

Private Sub LoadBitmapFromPathIfExists(FullPath As String) As B4XBitmap
	Dim empty As B4XBitmap
	Dim p As String = FullPath.Trim
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

Public Sub setBubbleAvatarStatusById(BubbleId As String, Mode As String)
	If BubbleById.IsInitialized = False Then Return
	If BubbleById.ContainsKey(BubbleId) = False Then Return
	Dim bubble As B4XDaisyChatBubble = BubbleById.Get(BubbleId)
	bubble.SetAvatarStatus(Mode)
	If MessageById.IsInitialized And MessageById.ContainsKey(BubbleId) Then
		Dim m As Map = CloneMap(MessageById.Get(BubbleId))
		m.Put("avatar_status", Mode)
		MessageById.Put(BubbleId, m)
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

Public Sub setAvatarMask(Mask As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(Mask)
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getAvatarMask As String
	Return AvatarMask
End Sub

Public Sub setMask(Mask As String)
	setAvatarMask(Mask)
End Sub

Public Sub setAvatarSize(Size As Int)
	AvatarSize = Max(16dip, Size)
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getAvatarSize As Int
	Return Round(AvatarSize)
End Sub

Public Sub setFromBackgroundColor(Color As Int)
	FromBackgroundColor = Color
	UseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getFromBackgroundColor As Int
	Return FromBackgroundColor
End Sub

Public Sub setFromTextColor(Color As Int)
	FromTextColor = Color
	UseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getFromTextColor As Int
	Return FromTextColor
End Sub

Public Sub setToBackgroundColor(Color As Int)
	ToBackgroundColor = Color
	UseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getToBackgroundColor As Int
	Return ToBackgroundColor
End Sub

Public Sub setToTextColor(Color As Int)
	ToTextColor = Color
	UseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getToTextColor As Int
	Return ToTextColor
End Sub

Public Sub setFromToColors(FromBack As Int, FromText As Int, ToBack As Int, ToText As Int)
	FromBackgroundColor = FromBack
	FromTextColor = FromText
	ToBackgroundColor = ToBack
	ToTextColor = ToText
	UseFromToColors = True
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub setUseFromToColors(Enabled As Boolean)
	UseFromToColors = Enabled
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getUseFromToColors As Boolean
	Return UseFromToColors
End Sub

Public Sub setTheme(Name As String)
	InitializeThemes
	Dim key As String = NormalizeThemeName(Name)
	If Themes.ContainsKey(key) Then
		CurrentTheme = key
		ReconfigureAllBubblesFromMessages(False)
	End If
End Sub

Public Sub getTheme As String
	InitializeThemes
	Return CurrentTheme
End Sub

Public Sub setDateTimeFormat(Value As String)
	DateTimeFormat = B4XDaisyVariants.NormalizeDateTimeFormat(Value, "D, j M Y H:i")
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getDateTimeFormat As String
	Return DateTimeFormat
End Sub

Public Sub setUseTimeAgo(Enabled As Boolean)
	UseTimeAgo = Enabled
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getUseTimeAgo As Boolean
	Return UseTimeAgo
End Sub

Public Sub setShowTimeAgoForToday(Enabled As Boolean)
	ShowTimeAgoForToday = Enabled
	ReconfigureAllBubblesFromMessages(True)
End Sub

Public Sub getShowTimeAgoForToday As Boolean
	Return ShowTimeAgoForToday
End Sub

Public Sub RegisterTheme(Name As String, PaletteMap As Map)
	InitializeThemes
	If PaletteMap.IsInitialized = False Then Return
	Dim key As String = NormalizeThemeName(Name)
	If key.Length = 0 Then Return
	Themes.Put(key, PaletteMap)
	If key = CurrentTheme Then ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getPalette As Map
	Return ResolvePalette("")
End Sub

Public Sub CreateVariant(BackColor As Int, TextColor As Int) As Map
	Return VariantMap(BackColor, TextColor)
End Sub

Public Sub ShowOnline(Enabled As Boolean)
	OnlineIndicatorsVisible = Enabled
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub setOnlineStatusColors(OnlineColor As Int, OfflineColor As Int)
	If OnlineColor <> 0 Then AvatarOnlineColor = OnlineColor
	If OfflineColor <> 0 Then AvatarOfflineColor = OfflineColor
	ReconfigureAllBubblesFromMessages(False)
End Sub

Public Sub getOnlineStatusColor As Int
	Return AvatarOnlineColor
End Sub

Public Sub getOfflineStatusColor As Int
	Return AvatarOfflineColor
End Sub

Public Sub setVerticalGap(Gap As Int)
	VerticalGap = Max(0, Gap)
	RelayoutAll
End Sub

Public Sub getVerticalGap As Int
	Return VerticalGap
End Sub

Public Sub setWidth(Value As Int)
	ChatWidth = Max(1dip, Value)
	ApplyComponentSize
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return ChatWidth
End Sub

Public Sub setHeight(Value As Int)
	ChatHeight = Max(1dip, Value)
	ApplyComponentSize
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return ChatHeight
End Sub

Public Sub setSize(Width As Int, Height As Int)
	ChatWidth = Max(1dip, Width)
	ChatHeight = Max(1dip, Height)
	ApplyComponentSize
End Sub

Private Sub ReconfigureAllBubblesFromMessages(DoRelayout As Boolean)
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
	If DoRelayout Then RelayoutAll
End Sub
Private Sub bubble_AvatarClick(tag As Object)
	If xui.SubExists(mCallBack, mEventName & "_AvatarClick", 1) Then
		CallSub2(mCallBack, mEventName & "_AvatarClick", tag)
	End If
End Sub

Private Sub ResolvePalette(ThemeName As String) As Map
	InitializeThemes
	Dim key As String = NormalizeThemeName(ThemeName)
	If key.Length > 0 And Themes.ContainsKey(key) Then Return Themes.Get(key)
	If Themes.ContainsKey(CurrentTheme) Then Return Themes.Get(CurrentTheme)
	Return Themes.Get("light")
End Sub

Private Sub NormalizeThemeName(Name As String) As String
	If Name = Null Then Return ""
	Return Name.ToLowerCase.Trim
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

Private Sub VariantMap(back As Int, text As Int) As Map
	Dim vm As Map
	vm.Initialize
	vm.Put("back", back)
	vm.Put("text", text)
	vm.Put("muted", Blend(text, xui.Color_Gray, 0.35))
	Return vm
End Sub

Private Sub Blend(c1 As Int, c2 As Int, t As Double) As Int
	Dim r1 As Int = Bit.And(Bit.ShiftRight(c1, 16), 0xFF)
	Dim g1 As Int = Bit.And(Bit.ShiftRight(c1, 8), 0xFF)
	Dim b1 As Int = Bit.And(c1, 0xFF)
	Dim r2 As Int = Bit.And(Bit.ShiftRight(c2, 16), 0xFF)
	Dim g2 As Int = Bit.And(Bit.ShiftRight(c2, 8), 0xFF)
	Dim b2 As Int = Bit.And(c2, 0xFF)
	Return xui.Color_RGB(r1 + (r2-r1)*t, g1 + (g2-g1)*t, b1 + (b2-b1)*t)
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
