B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
'B4XChatBubble.bas
'Chat bubble inspired by daisyUI chat component, native XUI + cached drawing

#Event: AvatarClick (Payload As Object)
#Event: BubbleClick (Tag As Object)

#DesignerProperty: Key: AvatarMask, DisplayName: Avatar Mask, FieldType: String, DefaultValue: circle, List: circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2, Description: Mask shape used for the bubble avatar
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

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object

	'Layout tokens
	Private Gap As Float = 4dip
	Private OuterMargin As Float = 10dip
	Private PaddingH As Float = 14dip
	Private PaddingV As Float = 10dip
	Private AvatarSize As Float = 40dip
	Private TailSize As Float = 11dip
	Private Corner As Float = 18dip
	Private MaxWidthPct As Float = 0.90
	Private MinBubbleWidth As Int = 40dip   '2.5rem-ish
	Private MinBubbleHeight As Int = 32dip  '2rem-ish
	Private BubbleStyle As String = "rounded" 'rounded|block

	'Options
	Private Side As String = "start" 'start|end
	Private Variant As String = "neutral"
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
	Private AvatarMask As String = "circle" 'circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2
	Private OnlineIndicatorVisible As Boolean = True
	Private AvatarOnlineColor As Int = 0xFF2ECC71
	Private AvatarOfflineColor As Int = 0xFFB4B4B4
	
	Private UseFromToColors As Boolean = False
	Private FromBackgroundColor As Int = 0xFFE5E7EB
	Private FromTextColor As Int = 0xFF111827
	Private ToBackgroundColor As Int = 0xFFDBEAFE
	Private ToTextColor As Int = 0xFF1E3A8A
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
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	InitializeDefaultPalette
End Sub

'Programmatic creation path (without loading from Designer)
Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim pp As Panel
	pp.Initialize("")
	Dim p As B4XView = pp
	p.Color = xui.Color_Transparent
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim dummy As Label
	DesignerCreateView(p, dummy, CreateMap())
	Return mBase
End Sub

Public Sub AddToParent(Parent As B4XView)
	AddToParentAt(Parent, 0, 0, Parent.Width, Parent.Height)
End Sub

Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If Parent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim v As B4XView = CreateView(w, h)
	Parent.AddView(v, Left, Top, w, h)
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
	Return mBase.IsInitialized And pnlRow.IsInitialized And mBase.Width > 0
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
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
	ivAvatar = ChatAvatar.CreateView(AvatarSize, AvatarSize)
	ivAvatar.Color = xui.Color_Transparent
	pnlRow.AddView(ivAvatar, 0, 0, AvatarSize, AvatarSize)

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
	lblHeaderName = CreateLabel(10, False, True)
	lblHeaderTime = CreateLabel(9, False, True)
	lblFooter = CreateLabel(9, False, True)

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
	
	ApplyDesignerProps(Props)

	SetVariant(Variant)
	SetSide("start")

	'Soft elevation where supported (keep subtle)
	ApplyElevation(2dip)
End Sub

Private Sub CreateLabel(Size As Float, Bold As Boolean, SingleLine As Boolean) As B4XView
	Dim l As Label
	l.Initialize("")
	l.SingleLine = SingleLine
	Dim v As B4XView = l
	v.Color = xui.Color_Transparent
	Dim f As B4XFont
	If Bold Then f = xui.CreateDefaultBoldFont(Size) Else f = xui.CreateDefaultFont(Size)
	v.Font = f
	Return v
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	If Props.IsInitialized = False Then Return
	
	AvatarMask = B4XDaisyVariants.NormalizeMask(GetPropString(Props, "AvatarMask", AvatarMask))
	AvatarSize = Max(16dip, GetPropDip(Props, "AvatarSize", AvatarSize))
	SetSide(GetPropString(Props, "Side", Side))
	SetBubbleStyle(GetPropString(Props, "BubbleStyle", BubbleStyle))
	Dim mwp As Float = GetPropFloat(Props, "MaxWidthPercent", MaxWidthPct * 100)
	If mwp > 1 Then mwp = mwp / 100
	SetMaxWidthPercent(mwp)
	'Backward compatibility with older designer keys.
	If Props.ContainsKey("AvatarWidth") Then AvatarSize = Max(16dip, GetPropDip(Props, "AvatarWidth", AvatarSize))
	If Props.ContainsKey("AvatarHeight") Then AvatarSize = Max(16dip, GetPropDip(Props, "AvatarHeight", AvatarSize))
	OnlineIndicatorVisible = GetPropBool(Props, "ShowOnline", OnlineIndicatorVisible)
	
	UseFromToColors = GetPropBool(Props, "UseFromToColors", UseFromToColors)
	FromBackgroundColor = GetPropInt(Props, "FromBackgroundColor", FromBackgroundColor)
	FromTextColor = GetPropInt(Props, "FromTextColor", FromTextColor)
	ToBackgroundColor = GetPropInt(Props, "ToBackgroundColor", ToBackgroundColor)
	ToTextColor = GetPropInt(Props, "ToTextColor", ToTextColor)
	BubbleId = GetPropString(Props, "Id", BubbleId)
	BubbleFromId = GetPropString(Props, "FromId", BubbleFromId)
	SetVariant(GetPropString(Props, "Variant", Variant))
End Sub

Private Sub GetPropDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, 0) * 1dip
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropFloat(Props As Map, Key As String, DefaultValue As Float) As Float
	Return B4XDaisyVariants.GetPropFloat(Props, Key, DefaultValue)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If pnlRow.IsInitialized = False Then Return
	pnlRow.SetLayoutAnimated(0, 0, 0, Width, Height)
	LayoutNow(Width, Height)
End Sub

Public Sub SetId(Value As String)
	If Value = Null Then
		BubbleId = ""
	Else
		BubbleId = Value
	End If
End Sub

Public Sub GetId As String
	Return BubbleId
End Sub

Public Sub SetFromId(Value As String)
	If Value = Null Then
		BubbleFromId = ""
	Else
		BubbleFromId = Value
	End If
End Sub

Public Sub GetFromId As String
	Return BubbleFromId
End Sub

Public Sub GetUsedHeight As Int
	Dim w As Int = 320dip
	If mBase.IsInitialized And mBase.Width > 0 Then w = mBase.Width
	Return MeasureHeight(w)
End Sub

'========================
' Public API (daisy-like)
'========================

Public Sub SetSide(s As String)
	If s <> "start" And s <> "end" Then s = "start"
	Side = s
End Sub

Public Sub SetVariant(v As String)
	If v = Null Then
		Variant = "neutral"
		Return
	End If
	Variant = v.ToLowerCase.Trim
	If Variant.Length = 0 Then Variant = "neutral"
End Sub

Public Sub SetBubbleStyle(StyleName As String)
	Dim s As String = StyleName.ToLowerCase.Trim
	If s <> "block" Then s = "rounded"
	BubbleStyle = s
End Sub

Public Sub SetOutline(Enabled As Boolean, Color As Int, Width As Float)
	ShowOutline = Enabled
	OutlineColor = Color
	OutlineWidth = Width
End Sub

Public Sub SetMaxWidthPercent(p As Float)
	If p < 0.3 Then p = 0.3
	If p > 0.95 Then p = 0.95
	MaxWidthPct = p
End Sub

Public Sub SetAvatarVisible(b As Boolean)
	AvatarVisible = b
End Sub

Public Sub SetAvatarBitmap(bmp As B4XBitmap, Tag As Object)
	AvatarBmp = bmp
	AvatarTag = Tag
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarStatus(Mode As String)
	Dim m As String = Mode.ToLowerCase
	If m <> "online" And m <> "offline" Then m = "none"
	AvatarStatus = m
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarStatusColors(OnlineColor As Int, OfflineColor As Int)
	If OnlineColor <> 0 Then AvatarOnlineColor = OnlineColor
	If OfflineColor <> 0 Then AvatarOfflineColor = OfflineColor
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub GetAvatarOnlineColor As Int
	Return AvatarOnlineColor
End Sub

Public Sub GetAvatarOfflineColor As Int
	Return AvatarOfflineColor
End Sub

Public Sub SetAvatarBorder(Color As Int, Width As Float)
	AvatarBorderColor = Color
	AvatarBorderWidth = Max(0, Width)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarBorderInset(Inset As Float)
	AvatarBorderInset = Max(0, Inset)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub SetAvatarMask(MaskName As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(MaskName)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub GetAvatarMask As String
	Return AvatarMask
End Sub

Public Sub SetGlobalMask(MaskName As String)
	SetAvatarMask(MaskName)
End Sub

Public Sub SetAvatarSize(Size As Float)
	AvatarSize = Max(16dip, Size)
End Sub

Public Sub SetAvatarWidth(Width As Float)
	AvatarSize = Max(16dip, Width)
End Sub

Public Sub SetAvatarHeight(Height As Float)
	AvatarSize = Max(16dip, Height)
End Sub

Public Sub GetAvatarWidth As Float
	Return AvatarSize
End Sub

Public Sub GetAvatarHeight As Float
	Return AvatarSize
End Sub

Public Sub GetAvatarSize As Float
	Return AvatarSize
End Sub

Public Sub SetShowOnline(Show As Boolean)
	OnlineIndicatorVisible = Show
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub GetShowOnline As Boolean
	Return OnlineIndicatorVisible
End Sub

Public Sub SetFromBackgroundColor(Color As Int)
	FromBackgroundColor = Color
	UseFromToColors = True
End Sub

Public Sub GetFromBackgroundColor As Int
	Return FromBackgroundColor
End Sub

Public Sub SetFromTextColor(Color As Int)
	FromTextColor = Color
	UseFromToColors = True
End Sub

Public Sub GetFromTextColor As Int
	Return FromTextColor
End Sub

Public Sub SetToBackgroundColor(Color As Int)
	ToBackgroundColor = Color
	UseFromToColors = True
End Sub

Public Sub GetToBackgroundColor As Int
	Return ToBackgroundColor
End Sub

Public Sub SetToTextColor(Color As Int)
	ToTextColor = Color
	UseFromToColors = True
End Sub

Public Sub GetToTextColor As Int
	Return ToTextColor
End Sub

Public Sub SetFromToColors(FromBack As Int, FromText As Int, ToBack As Int, ToText As Int)
	FromBackgroundColor = FromBack
	FromTextColor = FromText
	ToBackgroundColor = ToBack
	ToTextColor = ToText
	UseFromToColors = True
End Sub

Public Sub SetUseFromToColors(Enabled As Boolean)
	UseFromToColors = Enabled
End Sub

Public Sub GetUseFromToColors As Boolean
	Return UseFromToColors
End Sub

Public Sub SetVariantPalette(Palette As Map)
	InitializeDefaultPalette
	If Palette.IsInitialized Then
		VariantPalette = Palette
	Else
		VariantPalette = DefaultVariantPalette
	End If
End Sub

Public Sub GetVariantPalette As Map
	InitializeDefaultPalette
	Return VariantPalette
End Sub

Public Sub SetColors(BackOverride As Int, TextOverride As Int, MutedOverride As Int)
	OverrideBackColor = BackOverride
	OverrideTextColor = TextOverride
	OverrideMutedColor = MutedOverride
End Sub

Public Sub SetHeader(Text As String)
	HeaderText = Text
End Sub

Public Sub SetHeaderTime(Text As String)
	HeaderTimeText = Text
End Sub

Public Sub SetHeaderParts(NameText As String, TimeText As String)
	HeaderText = NameText
	HeaderTimeText = TimeText
End Sub

Public Sub SetHeaderVisible(b As Boolean)
	HeaderVisible = b
End Sub

Public Sub SetHeaderNameVisible(b As Boolean)
	HeaderNameVisible = b
End Sub

Public Sub SetHeaderTimeVisible(b As Boolean)
	HeaderTimeVisible = b
End Sub

Public Sub SetFooter(Text As String)
	FooterText = Text
End Sub

Public Sub SetFooterVisible(b As Boolean)
	FooterVisible = b
End Sub

Public Sub SetMessage(Text As String)
	MessageText = Text
	ContentMode = "text"
End Sub

Public Sub SetBubbleVisible(b As Boolean)
	BubbleVisible = b
End Sub

Public Sub SetStatus(Mode As String, ExtraText As String)
	'Mode: none|sent|delivered|read
	StatusMode = NormalizeStatusMode(Mode)
	StatusText = ExtraText
End Sub

Private Sub NormalizeStatusMode(Mode As String) As String
	If Mode = Null Then Return "none"
	Dim m As String = Mode.ToLowerCase.Trim
	Select Case m
		Case "sent", "delivered", "read"
			Return m
		Case Else
			Return "none"
	End Select
End Sub

'Content slot: image
Public Sub SetImage(bmp As B4XBitmap, MaxHeight As Int)
	ContentImage = bmp
	If MaxHeight > 0 Then ContentImageMaxH = MaxHeight
	ContentMode = "image"
End Sub

'Content slot: custom view
Public Sub SetCustomContent(v As B4XView)
	CustomContent = v
	ContentMode = "custom"
End Sub

'Convenience: set all in one go
Public Sub SetContentAll(Header As String, Body As String, Footer As String, SideNow As String, VariantNow As String)
	SetHeader(Header)
	SetMessage(Body)
	SetFooter(Footer)
	SetSide(SideNow)
	SetVariant(VariantNow)
End Sub

'CLV: measure row height given available row width
Public Sub MeasureHeight(AvailableWidth As Int) As Int
	Dim bubbleW As Int = ComputeBubbleWidth(AvailableWidth)
	Dim tailLeft As Int = IIf(Side="start", TailSize, 0)
	Dim tailRight As Int = IIf(Side="end", TailSize, 0)
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
		Dim hName As Int = IIf(showHeaderName, MeasureLabelHeight(lblHeaderName, HeaderText, nameW), 0)
		Dim hTime As Int = IIf(showHeaderTime, MeasureLabelHeight(lblHeaderTime, HeaderTimeText, Max(20dip, timeW)), 0)
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
		fh = MeasureLabelHeight(lblFooter, footerCombined, bubbleBodyW)
	End If

	Dim bubbleH As Int = IIf(BubbleVisible, Max(MinBubbleHeight, PaddingV + bodyH + PaddingV), 0)
	Dim rowH As Int = 6dip + IIf(hh > 0, hh + 3dip, 0) + bubbleH + IIf(fh > 0, 3dip + fh, 0)
	rowH = Max(rowH, 6dip + IIf(hh > 0, hh + 3dip, 0) + IIf(AvatarVisible, AvatarSize, 0))
	Return rowH
End Sub

'========================
' Layout & drawing
'========================

Private Sub LayoutNow(RowW As Int, RowH As Int)
	'Colors (theme + overrides)
	Dim cmap As Map
	cmap = ResolveColors
	Dim back As Int = cmap.Get("back")
	Dim txt As Int = cmap.Get("text")
	Dim muted As Int = cmap.Get("muted")
	Dim metaMuted As Int = xui.Color_RGB(120, 120, 120)

	Dim bubbleW As Int = ComputeBubbleWidth(RowW)
	Dim tailLeft As Int = IIf(Side="start", TailSize, 0)
	Dim tailRight As Int = IIf(Side="end", TailSize, 0)
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
	Dim hName As Int = IIf(showHeaderName And nameW > 0, MeasureLabelHeight(lblHeaderName, HeaderText, nameW), 0)
	Dim hTime As Int = IIf(showHeaderTime And timeW > 0, MeasureLabelHeight(lblHeaderTime, HeaderTimeText, Max(20dip, timeW)), 0)
	If showHeaderName Or showHeaderTime Then hh = Max(hName, hTime)
	
	Dim footerCombined As String = FooterComposite
	Dim fh As Int = 0
	lblFooter.Visible = FooterVisible And (footerCombined.Length > 0)
	lblFooter.TextColor = metaMuted
	If lblFooter.Visible Then
		lblFooter.Text = footerCombined
		fh = MeasureLabelHeight(lblFooter, footerCombined, bubbleBodyW)
	End If
	
	Dim topY As Int = 3dip
	Dim bubbleY As Int = topY + IIf(hh > 0, hh + 3dip, 0)

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
	Dim bubbleH As Int = IIf(BubbleVisible, Max(MinBubbleHeight, PaddingV + bodyH + PaddingV), 0)

	Dim aW As Int = 0
	Dim bubbleX As Int
	If Side = "start" Then
		If AvatarVisible Then aW = AvatarSize
		bubbleX = OuterMargin + IIf(AvatarVisible, aW + Gap, 0)
	Else
		If AvatarVisible Then aW = AvatarSize
		bubbleX = RowW - OuterMargin - bubbleW - IIf(AvatarVisible, aW + Gap, 0)
	End If
	
	'Avatar aligned with bubble block (not header/footer)
	If AvatarVisible Then
		ivAvatar.Visible = True
		Dim avatarX As Int = IIf(Side = "start", OuterMargin, RowW - OuterMargin - AvatarSize)
		Dim avatarAnchorH As Int = IIf(BubbleVisible, bubbleH, Max(hh, 0))
		Dim avatarY As Int = bubbleY + Max(0, avatarAnchorH - AvatarSize)
		ivAvatar.SetLayoutAnimated(0, avatarX, avatarY, AvatarSize, AvatarSize)
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
	lblFooter.SetTextAlignment("CENTER", IIf(Side = "start", "LEFT", "RIGHT"))
	Dim nameX As Int = headerX
	Dim timeX As Int = headerX
	If renderHeaderName And renderHeaderTime Then
		If Side = "end" Then
			Dim groupW As Int = nameW + gapW + timeW
			nameX = headerX + bubbleBodyW - groupW
		End If
		timeX = nameX + nameW + gapW
	Else If renderHeaderName Then
		If Side = "end" Then nameX = headerX + bubbleBodyW - nameW
	Else If renderHeaderTime Then
		If Side = "end" Then timeX = headerX + bubbleBodyW - timeW
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
		lblFooter.SetLayoutAnimated(0, footerX, bubbleY + bubbleH + 3dip, bubbleBodyW, fh)
	End If

	'Content slot inside bubble
	If BubbleVisible Then
		pnlContent.SetLayoutAnimated(0, contentX, PaddingV, contentW, bodyH)
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
		DrawBubbleIfNeeded(bubbleW, bubbleH, back, Side, True, ShowOutline, OutlineColor, OutlineWidth, BubbleStyle)
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
	ChatAvatar.SetAvatarMask(AvatarMask)
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
		Case "sent"      : ticks = " ✓"
		Case "delivered" : ticks = " ✓✓"
		Case "read"      : ticks = " ✓✓"
		Case Else        : ticks = ""
	End Select
	Dim extra As String = ""
	If StatusText.Length > 0 Then extra = " • " & StatusText
	
	If FooterText.Length = 0 And ticks.Length = 0 And extra.Length = 0 Then Return ""
	Return FooterText & ticks & extra
End Sub

Private Sub MeasureImageHeight(contentW As Int) As Int
	If ContentImage.IsInitialized = False Then Return 120dip
	Dim iw As Int = ContentImage.Width
	Dim ih As Int = ContentImage.Height
	If iw <= 0 Or ih <= 0 Then Return 120dip
	Dim scaledH As Int = ih * (contentW / iw)
	If scaledH > ContentImageMaxH Then scaledH = ContentImageMaxH
	If scaledH < 80dip Then scaledH = 80dip
	Return scaledH
End Sub

Private Sub MeasureLabelHeight(v As B4XView, Text As String, Width As Int) As Int
	Dim l As Label = v
	l.Width = Max(1dip, Width)
	Dim h As Int = tu.MeasureMultilineTextHeight(l, Text)
	Return Max(1dip, h)
End Sub

Private Sub MeasureSingleLineWidth(v As B4XView, Text As String) As Int
	If Text.Length = 0 Then Return 0
	Dim cleaned As String = Text.Replace(CRLF, Chr(10))
	Dim lines() As String = Regex.Split(Chr(10), cleaned)
	Dim l As Label = v
	Dim c As Canvas
	c.Initialize(l)
	Dim maxW As Float = 0
	For Each ln As String In lines
		Dim w As Float = c.MeasureStringWidth(ln, l.Typeface, l.TextSize)
		If w > maxW Then maxW = w
	Next
	Return Max(1dip, Ceil(maxW) + 2dip)
End Sub

Private Sub FitSingleLineText(v As B4XView, Text As String, MaxWidth As Int) As String
	If MaxWidth <= 0 Then Return ""
	Dim normalized As String = Text.Replace(CRLF, " ").Replace(Chr(10), " ").Trim
	If normalized.Length = 0 Then Return ""
	If MeasureSingleLineWidth(v, normalized) <= MaxWidth Then Return normalized
	Dim dots As String = "..."
	If MeasureSingleLineWidth(v, dots) > MaxWidth Then Return ""
	Dim lo As Int = 0
	Dim hi As Int = normalized.Length
	Do While lo < hi
		Dim mid As Int = (lo + hi + 1) / 2
		Dim candidate As String = normalized.SubString2(0, mid) & dots
		If MeasureSingleLineWidth(v, candidate) <= MaxWidth Then
			lo = mid
		Else
			hi = mid - 1
		End If
	Loop
	If lo <= 0 Then Return dots
	Return normalized.SubString2(0, lo) & dots
End Sub

Private Sub ResolveHeaderLayoutWidths(BubbleBodyW As Int, ShowHeaderName As Boolean, ShowHeaderTime As Boolean) As Map
	Dim result As Map
	result.Initialize
	Dim minTimeW As Int = 20dip
	Dim preferredGapW As Int = 4dip
	Dim gapW As Int = preferredGapW
	Dim nameW As Int = 0
	Dim timeW As Int = 0
	Dim desiredNameW As Int = 0
	Dim desiredTimeW As Int = 0
	
	If ShowHeaderName Then
		desiredNameW = Min(BubbleBodyW, MeasureSingleLineWidth(lblHeaderName, HeaderText))
	End If
	If ShowHeaderTime Then
		desiredTimeW = Min(BubbleBodyW, Max(minTimeW, MeasureSingleLineWidth(lblHeaderTime, HeaderTimeText)))
	End If
	
	If ShowHeaderName And ShowHeaderTime Then
		Dim fullHeaderW As Int = desiredNameW + preferredGapW + desiredTimeW
		If fullHeaderW <= BubbleBodyW Then
			'Everything fits in one row: render full name + time (no name truncation).
			nameW = desiredNameW
			timeW = desiredTimeW
			gapW = preferredGapW
		Else
			'Overflow: preserve time width and let name be ellipsized to remaining space.
			timeW = Min(desiredTimeW, BubbleBodyW)
			Dim remaining As Int = BubbleBodyW - timeW
			If remaining <= 0 Then
				nameW = 0
				gapW = 0
			Else
				gapW = IIf(remaining > preferredGapW, preferredGapW, 0)
				nameW = Max(0, remaining - gapW)
			End If
		End If
	Else If ShowHeaderName Then
		nameW = BubbleBodyW
	Else If ShowHeaderTime Then
		timeW = Min(BubbleBodyW, Max(minTimeW, desiredTimeW))
	End If
	
	result.Put("name_w", nameW)
	result.Put("time_w", timeW)
	result.Put("gap_w", gapW)
	Return result
End Sub

Private Sub MaxBubbleWidth(RowW As Int) As Int
	Dim avatarSlot As Int = IIf(AvatarVisible, AvatarSize + Gap, 0)
	Dim hardMax As Int = RowW - (OuterMargin * 2) - avatarSlot
	Dim pctMax As Int = RowW * MaxWidthPct
	Dim m As Int = Min(hardMax, pctMax)
	Return Max(MinBubbleWidth, m)
End Sub

Private Sub EstimateDesiredContentWidth(maxContentW As Int) As Int
	Dim desired As Int = 80dip
	Dim metaMaxW As Int = maxContentW
	Dim showHeaderName As Boolean = HeaderVisible And HeaderNameVisible And HeaderText.Length > 0
	Dim showHeaderTime As Boolean = HeaderVisible And HeaderTimeVisible And HeaderTimeText.Length > 0
	
	If showHeaderName And showHeaderTime Then
		Dim nameW As Int = MeasureSingleLineWidth(lblHeaderName, HeaderText)
		Dim timeW As Int = MeasureSingleLineWidth(lblHeaderTime, HeaderTimeText)
		desired = Max(desired, Min(metaMaxW, nameW + 4dip + timeW))
	Else If showHeaderName Then
		desired = Max(desired, Min(metaMaxW, MeasureSingleLineWidth(lblHeaderName, HeaderText)))
	Else If showHeaderTime Then
		desired = Max(desired, Min(metaMaxW, MeasureSingleLineWidth(lblHeaderTime, HeaderTimeText)))
	End If
	
	If BubbleVisible Then
		Select Case ContentMode
			Case "text"
				desired = Max(desired, MeasureSingleLineWidth(lblMessage, MessageText))
			Case "image"
				If ContentImage.IsInitialized Then
					desired = Max(desired, Min(maxContentW, Max(80dip, ContentImage.Width)))
				End If
			Case "custom"
				If CustomContent.IsInitialized Then
					desired = Max(desired, CustomContent.Width)
				End If
		End Select
	End If
	
	Dim footerCombined As String = FooterComposite
	If FooterVisible And footerCombined.Length > 0 Then
		desired = Max(desired, Min(metaMaxW, MeasureSingleLineWidth(lblFooter, footerCombined)))
	End If
	
	If desired > maxContentW Then desired = maxContentW
	Return Max(80dip, desired)
End Sub

Private Sub ComputeBubbleWidth(RowW As Int) As Int
	Dim maxBubble As Int = MaxBubbleWidth(RowW)
	Dim tailLeft As Int = IIf(Side="start", TailSize, 0)
	Dim tailRight As Int = IIf(Side="end", TailSize, 0)
	Dim chrome As Int = (PaddingH * 2) + tailLeft + tailRight
	Dim maxContentW As Int = Max(80dip, maxBubble - chrome)
	Dim desiredContentW As Int = EstimateDesiredContentWidth(maxContentW)
	Dim w As Int = chrome + desiredContentW
	If w > maxBubble Then w = maxBubble
	If w < MinBubbleWidth Then w = MinBubbleWidth
	Return w
End Sub

Private Sub ResolveColors As Map
	InitializeDefaultPalette
	Dim pal As Map
	If VariantPalette.IsInitialized Then
		pal = VariantPalette
	Else
		pal = DefaultVariantPalette
	End If
	Dim vm As Map
	If pal.IsInitialized And pal.ContainsKey(Variant) Then
		vm = pal.Get(Variant)
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
	
	If UseFromToColors Then
		If Side = "start" Then
			back = FromBackgroundColor
			txt = FromTextColor
		Else
			back = ToBackgroundColor
			txt = ToTextColor
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

Private Sub GetMapIntSafe(m As Map, Key As String, DefaultValue As Int) As Int
	If m.IsInitialized = False Then Return DefaultValue
	If m.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = m.Get(Key)
	If o = Null Then Return DefaultValue
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
	m.Put("neutral", BuildVariantMap(xui.Color_RGB(241,245,249), xui.Color_Black))
	m.Put("primary", BuildVariantMap(xui.Color_RGB(219,234,254), xui.Color_RGB(30,64,175)))
	m.Put("secondary", BuildVariantMap(xui.Color_RGB(243,232,255), xui.Color_RGB(88,28,135)))
	m.Put("accent", BuildVariantMap(xui.Color_RGB(204,251,241), xui.Color_RGB(19,78,74)))
	m.Put("info", BuildVariantMap(xui.Color_RGB(224,242,254), xui.Color_RGB(12,74,110)))
	m.Put("success", BuildVariantMap(xui.Color_RGB(220,252,231), xui.Color_RGB(20,83,45)))
	m.Put("warning", BuildVariantMap(xui.Color_RGB(254,249,195), xui.Color_RGB(113,63,18)))
	m.Put("error", BuildVariantMap(xui.Color_RGB(254,226,226), xui.Color_RGB(127,29,29)))
	Return m
End Sub

Private Sub BuildVariantMap(back As Int, text As Int) As Map
	Dim vm As Map
	vm.Initialize
	vm.Put("back", back)
	vm.Put("text", text)
	vm.Put("muted", Blend(text, xui.Color_Gray, 0.35))
	Return vm
End Sub

Private Sub DrawBubbleIfNeeded(w As Int, h As Int, back As Int, sideNow As String, tail As Boolean, outline As Boolean, oColor As Int, oWidth As Float, styleNow As String)
	If w <= 0 Or h <= 0 Then Return
	Dim ow As Int = Max(0, oWidth)
	If w = LastW And h = LastH And back = LastBack And sideNow = LastSide And tail = LastTail And outline = LastOutline And oColor = LastOutlineColor And ow = LastOutlineWidth And styleNow = LastStyle Then Return

	LastW = w : LastH = h : LastBack = back : LastSide = sideNow
	LastTail = tail : LastOutline = outline : LastOutlineColor = oColor : LastOutlineWidth = ow
	LastStyle = styleNow
	
	If CanvasReady Then cvs.Release
	cvs.Initialize(ivBubbleBg)
	CanvasReady = True
	cvs.ClearRect(cvs.TargetRect)
	
	Dim tailPadLeft As Float = IIf(sideNow="start" And tail, TailSize, 0)
	Dim tailPadRight As Float = IIf(sideNow="end" And tail, TailSize, 0)
	
	Dim rr As B4XRect
	rr.Initialize(tailPadLeft, 0, w - tailPadRight, h)
	Dim useCorner As Float = IIf(styleNow = "block", 9dip, Corner)
	Dim bubblePath As B4XPath
	bubblePath.InitializeRoundedRect(rr, useCorner)
	
	'Fill
	cvs.DrawPath(bubblePath, back, True, 0)
	'chat-start/end behavior: remove one bottom corner radius like daisyUI rounded-es/ee-none.
	Dim cornerFix As B4XRect
	Dim cornerFixW As Float = Max(useCorner, TailSize + 1dip)
	If sideNow = "start" Then
		cornerFix.Initialize(rr.Left, rr.Bottom - useCorner, rr.Left + cornerFixW, rr.Bottom)
	Else
		cornerFix.Initialize(rr.Right - cornerFixW, rr.Bottom - useCorner, rr.Right, rr.Bottom)
	End If
	cvs.DrawRect(cornerFix, back, True, 0)
	
	'Tail
	If tail Then
		'Anchor tail to bottom edge for a smoother silhouette.
		'Keep tail baseline flush with bubble bottom edge.
		Dim bottomY As Float = h
		Dim attachTopY As Float
		If styleNow = "block" Then
			attachTopY = Max(useCorner, bottomY - TailSize * 0.85)
		Else
			attachTopY = Max(useCorner, bottomY - TailSize * 0.75)
		End If
		Dim p As B4XPath
		If sideNow="start" Then
			p.Initialize(0, bottomY)
			p.LineTo(TailSize, attachTopY)
			p.LineTo(TailSize, bottomY)
			p.LineTo(0, bottomY)
		Else
			p.Initialize(w, bottomY)
			p.LineTo(w - TailSize, attachTopY)
			p.LineTo(w - TailSize, bottomY)
			p.LineTo(w, bottomY)
		End If
		cvs.DrawPath(p, back, True, 0)
	End If

	'Outline (optional)
	If outline Then
		cvs.DrawPath(bubblePath, oColor, False, OutlineWidth)
		If tail Then
			Dim bottomY2 As Float = h
			Dim attachTopY2 As Float
			If styleNow = "block" Then
				attachTopY2 = Max(useCorner, bottomY2 - TailSize * 0.85)
			Else
				attachTopY2 = Max(useCorner, bottomY2 - TailSize * 0.75)
			End If
			Dim p2 As B4XPath
			If sideNow="start" Then
				p2.Initialize(0, bottomY2)
				p2.LineTo(TailSize, attachTopY2)
				p2.LineTo(TailSize, bottomY2)
				p2.LineTo(0, bottomY2)
			Else
				p2.Initialize(w, bottomY2)
				p2.LineTo(w - TailSize, attachTopY2)
				p2.LineTo(w - TailSize, bottomY2)
				p2.LineTo(w, bottomY2)
			End If
			cvs.DrawPath(p2, oColor, False, OutlineWidth)
		End If
	End If

	cvs.Invalidate
End Sub

Private Sub ApplyElevation(e As Float)
	'No-op by default. Native elevation is platform / API dependent.
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

'========================
' Events
'========================

Private Sub chatavatar_AvatarClick(Payload As Object)
	If xui.SubExists(mCallBack, mEventName & "_AvatarClick", 1) Then
		CallSub2(mCallBack, mEventName & "_AvatarClick", Payload)
	End If
End Sub

Public Sub RaiseBubbleClick(Tag As Object)
	If xui.SubExists(mCallBack, mEventName & "_BubbleClick", 1) Then
		CallSub2(mCallBack, mEventName & "_BubbleClick", Tag)
	End If
End Sub
