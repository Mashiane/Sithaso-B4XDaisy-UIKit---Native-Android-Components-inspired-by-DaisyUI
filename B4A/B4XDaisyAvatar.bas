B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: AvatarClick (Payload As Object)

#DesignerProperty: Key: Image, DisplayName: Image Path, FieldType: String, DefaultValue:, Description: Full image path on device
#DesignerProperty: Key: Mask, DisplayName: Mask, FieldType: String, DefaultValue: circle, List: circle|square|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2, Description: Avatar mask shape
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Use rounded box mask (radius: 4dip). Overrides mask setting.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level (Tailwind/Daisy scale)
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Variant used for placeholder and status colors
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: CenterOnParent, DisplayName: Center On Parent, FieldType: Boolean, DefaultValue: True, Description: Center avatar inside parent bounds
#DesignerProperty: Key: ChatImage, DisplayName: Chat Image Mode, FieldType: Boolean, DefaultValue: False, Description: Apply chat-image rendering defaults (shared with chat bubble usage)
#DesignerProperty: Key: Status, DisplayName: Status, FieldType: String, DefaultValue: none, List: none|online|offline, Description: Online indicator status
#DesignerProperty: Key: ShowOnline, DisplayName: Show Online Indicator, FieldType: Boolean, DefaultValue: False, Description: Show online/offline indicator dot
#DesignerProperty: Key: UseVariantStatusColors, DisplayName: Use Variant Colors, FieldType: Boolean, DefaultValue: False, Description: Derive online/offline colors from current variant (default keeps success green / gray)
#DesignerProperty: Key: OnlineColor, DisplayName: Online Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override online color (0 means auto)
#DesignerProperty: Key: OfflineColor, DisplayName: Offline Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override offline color (0 means auto)
#DesignerProperty: Key: RingColor, DisplayName: Ring Color, FieldType: Color, DefaultValue: 0x00000000, Description: Ring color override (0 means auto by variant)
#DesignerProperty: Key: RingWidth, DisplayName: Ring Width, FieldType: Int, DefaultValue: 0, Description: Ring stroke width in dip
#DesignerProperty: Key: RingOffset, DisplayName: Ring Offset, FieldType: Int, DefaultValue: 0, Description: Space between image and ring in dip

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object

	Private Const PROP_DEFAULT_VARIANT As String = "none"
	Private Const PROP_DEFAULT_SIZE_TOKEN As String = "10"
	Private Const PROP_DEFAULT_STATUS As String = "none"
	Private Const PROP_DEFAULT_MASK As String = "circle"
	Private Const PROP_DEFAULT_SHADOW As String = "none"
	Private Const PROP_DEFAULT_CENTER_ON_PARENT As Boolean = True
	Private Const PROP_DEFAULT_CHAT_IMAGE As Boolean = False
	Private Const PROP_DEFAULT_RING_WIDTH_DIP As Float = 0dip
	Private Const PROP_DEFAULT_RING_OFFSET_DIP As Float = 0dip
	Private Const PROP_DEFAULT_SHOW_ONLINE As Boolean = False
	Private Const PROP_DEFAULT_USE_VARIANT_STATUS As Boolean = False
	Private Const PROP_DEFAULT_ONLINE_COLOR As Int = 0xFF2ECC71
	Private Const PROP_DEFAULT_OFFLINE_COLOR As Int = 0xFFB4B4B4

	Private Variant As String = PROP_DEFAULT_VARIANT

	Private mWidth As Float = 40dip
	Private mHeight As Float = 40dip
	Private CenterOnParent As Boolean = PROP_DEFAULT_CENTER_ON_PARENT
	Private ChatImage As Boolean = PROP_DEFAULT_CHAT_IMAGE
	Private AvatarMask As String = PROP_DEFAULT_MASK
	Private AvatarPath As String = ""
	Private AvatarBmp As B4XBitmap
	Private AvatarTag As Object

	Private AvatarStatus As String = PROP_DEFAULT_STATUS 'none|online|offline
	Private OnlineIndicatorVisible As Boolean = PROP_DEFAULT_SHOW_ONLINE
	Private UseVariantStatusColors As Boolean = PROP_DEFAULT_USE_VARIANT_STATUS
	Private AvatarOnlineColor As Int = PROP_DEFAULT_ONLINE_COLOR
	Private AvatarOfflineColor As Int = PROP_DEFAULT_OFFLINE_COLOR
	Private CustomOnlineColor As Int = 0
	Private CustomOfflineColor As Int = 0

	Private AvatarBorderColor As Int = 0xFFF5F5F5
	Private AvatarBorderWidth As Float = PROP_DEFAULT_RING_WIDTH_DIP
	Private RingColor As Int = 0
	Private RingOffset As Float = PROP_DEFAULT_RING_OFFSET_DIP
	Private Shadow As String = PROP_DEFAULT_SHADOW

	Private VariantPalette As Map
	Private DefaultVariantPalette As Map

	Private ivAvatar As B4XView
	Private AvatarCvs As B4XCanvas
	Private AvatarCanvasReady As Boolean = False
	Private LastUpscaleWarningKey As String = ""
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	InitializePalette
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim dummy As Label
	DesignerCreateView(b, dummy, CreateMap())
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
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(ChildView, Left, Top, Width, Height)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And ivAvatar.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mBase.Color = xui.Color_Transparent

	Dim pAvatar As Panel
	pAvatar.Initialize("ivAvatar")
	ivAvatar = pAvatar
	ivAvatar.Color = xui.Color_Transparent
	mBase.AddView(ivAvatar, 0, 0, mWidth, mHeight)

	InitializePalette
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or ivAvatar.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim drawW As Int = Max(1dip, mWidth)
	Dim drawH As Int = Max(1dip, mHeight)
	If drawW > w Then drawW = w
	If drawH > h Then drawH = h
	Dim x As Int = 0
	Dim y As Int = 0
	If CenterOnParent Then
		x = (w - drawW) / 2
		y = (h - drawH) / 2
	End If
	ivAvatar.SetLayoutAnimated(0, x, y, drawW, drawH)
	DrawAvatar
End Sub

'Convenience helper: resize avatar internals to match a parent view size.
Public Sub ResizeToParent(b4xV As B4XView)
	If b4xV.IsInitialized = False Then Return
	Base_Resize(b4xV.Width, b4xV.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	'Reset mapped runtime values to designer defaults first (prevents drift).
	Variant = PROP_DEFAULT_VARIANT
	Shadow = PROP_DEFAULT_SHADOW
	mWidth = B4XDaisyVariants.TailwindSizeToDip(PROP_DEFAULT_SIZE_TOKEN, 40dip)
	mHeight = B4XDaisyVariants.TailwindSizeToDip(PROP_DEFAULT_SIZE_TOKEN, 40dip)
	CenterOnParent = PROP_DEFAULT_CENTER_ON_PARENT
	ChatImage = PROP_DEFAULT_CHAT_IMAGE
	AvatarMask = PROP_DEFAULT_MASK
	AvatarStatus = PROP_DEFAULT_STATUS
	OnlineIndicatorVisible = PROP_DEFAULT_SHOW_ONLINE
	UseVariantStatusColors = PROP_DEFAULT_USE_VARIANT_STATUS
	AvatarOnlineColor = PROP_DEFAULT_ONLINE_COLOR
	AvatarOfflineColor = PROP_DEFAULT_OFFLINE_COLOR
	CustomOnlineColor = 0
	CustomOfflineColor = 0
	AvatarBorderWidth = PROP_DEFAULT_RING_WIDTH_DIP
	RingColor = 0
	RingOffset = PROP_DEFAULT_RING_OFFSET_DIP
	AvatarPath = ""

	If Props.IsInitialized = False Then
		setVariant(Variant)
		setShadow(Shadow)
		setChatImage(ChatImage)
		setAvatarMask(AvatarMask)
		setAvatarStatus(AvatarStatus)
		setShowOnline(OnlineIndicatorVisible)
		setAvatar("")
		Return
	End If

	setVariant(getPropString(Props, "Variant", PROP_DEFAULT_VARIANT))
	SetShadow(GetPropString(Props, "Shadow", PROP_DEFAULT_SHADOW))

	mWidth = Max(16dip, GetPropSizeDip(Props, "Width", mWidth))
	mHeight = Max(16dip, GetPropSizeDip(Props, "Height", mHeight))
	CenterOnParent = GetPropBool(Props, "CenterOnParent", PROP_DEFAULT_CENTER_ON_PARENT)
	ChatImage = GetPropBool(Props, "ChatImage", PROP_DEFAULT_CHAT_IMAGE)
	'Compatibility aliases (older key names).
	If Props.ContainsKey("AvatarWidth") Then mWidth = Max(16dip, GetPropSizeDip(Props, "AvatarWidth", mWidth))
	If Props.ContainsKey("AvatarHeight") Then mHeight = Max(16dip, GetPropSizeDip(Props, "AvatarHeight", mHeight))
	If Props.ContainsKey("AvatarSize") Then
		Dim s As Float = Max(16dip, GetPropSizeDip(Props, "AvatarSize", Min(mWidth, mHeight)))
		mWidth = s
		mHeight = s
	End If

	SetAvatarMask(GetPropString(Props, "Mask", GetPropString(Props, "AvatarMask", PROP_DEFAULT_MASK)))
	If GetPropBool(Props, "RoundedBox", False) Then SetAvatarMask("rounded")
	SetAvatarStatus(GetPropString(Props, "Status", PROP_DEFAULT_STATUS))
	SetShowOnline(GetPropBool(Props, "ShowOnline", PROP_DEFAULT_SHOW_ONLINE))
	UseVariantStatusColors = GetPropBool(Props, "UseVariantStatusColors", PROP_DEFAULT_USE_VARIANT_STATUS)

	CustomOnlineColor = GetPropInt(Props, "OnlineColor", 0)
	CustomOfflineColor = GetPropInt(Props, "OfflineColor", 0)
	AvatarOnlineColor = PROP_DEFAULT_ONLINE_COLOR
	AvatarOfflineColor = PROP_DEFAULT_OFFLINE_COLOR
	If CustomOnlineColor <> 0 Then AvatarOnlineColor = CustomOnlineColor
	If CustomOfflineColor <> 0 Then AvatarOfflineColor = CustomOfflineColor
	RingColor = GetPropInt(Props, "RingColor", 0)
	AvatarBorderWidth = Max(0, GetPropDip(Props, "RingWidth", PROP_DEFAULT_RING_WIDTH_DIP))
	RingOffset = Max(0, GetPropDip(Props, "RingOffset", PROP_DEFAULT_RING_OFFSET_DIP))
	'Compatibility with earlier internal naming.
	If Props.ContainsKey("AvatarBorderWidth") Then AvatarBorderWidth = Max(0, GetPropDip(Props, "AvatarBorderWidth", AvatarBorderWidth))
	If Props.ContainsKey("AvatarBorderInset") Then RingOffset = Max(0, GetPropDip(Props, "AvatarBorderInset", RingOffset))

	SetAvatar(GetPropString(Props, "Image", GetPropString(Props, "Avatar", "")))
End Sub

Private Sub getPropDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, 0) * 1dip
End Sub

Private Sub getPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
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

Public Sub setVariant(Value As String)
	Variant = B4XDaisyVariants.NormalizeVariant(Value)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getVariant As String
	Return Variant
End Sub

Public Sub setShadow(Value As String)
	Shadow = B4XDaisyVariants.NormalizeShadow(Value)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShadow As String
	Return Shadow
End Sub

Public Sub setChatImage(Value As Boolean)
	ChatImage = Value
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getChatImage As Boolean
	Return ChatImage
End Sub

Public Sub setVariantPalette(Palette As Map)
	If Palette.IsInitialized Then
		VariantPalette = Palette
	Else
		InitializePalette
		VariantPalette = DefaultVariantPalette
	End If
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getVariantPalette As Map
	InitializePalette
	Return VariantPalette
End Sub

Public Sub setUseVariantStatusColors(Enabled As Boolean)
	UseVariantStatusColors = Enabled
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getUseVariantStatusColors As Boolean
	Return UseVariantStatusColors
End Sub

Public Sub setAvatar(Path As String)
	Dim empty As B4XBitmap
	If Path = Null Then
		AvatarPath = ""
		AvatarBmp = empty
		LastUpscaleWarningKey = ""
		If ivAvatar.IsInitialized Then DrawAvatar
		Return
	End If
	AvatarPath = Path.Trim
	If AvatarPath.Length = 0 Then
		AvatarBmp = empty
		LastUpscaleWarningKey = ""
		If ivAvatar.IsInitialized Then DrawAvatar
		Return
	End If
	Try
		Dim slash1 As Int = AvatarPath.LastIndexOf("/")
		Dim slash2 As Int = AvatarPath.LastIndexOf("\")
		Dim slash As Int = Max(slash1, slash2)
		Dim dir As String = ""
		Dim fn As String = AvatarPath
		If slash >= 0 Then
			dir = AvatarPath.SubString2(0, slash)
			fn = AvatarPath.SubString(slash + 1)
		End If
		If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then
			AvatarBmp = xui.LoadBitmap(dir, fn)
		Else If File.Exists(File.DirAssets, AvatarPath) Then
			AvatarBmp = xui.LoadBitmap(File.DirAssets, AvatarPath)
		Else
			AvatarBmp = empty
		End If
	Catch
		AvatarBmp = empty
	End Try
	LastUpscaleWarningKey = ""
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatar As String
	Return AvatarPath
End Sub

Public Sub setImage(Path As String)
	SetAvatar(Path)
End Sub

Public Sub getImage As String
	Return AvatarPath
End Sub

Public Sub setAvatarBitmap(bmp As B4XBitmap, Tag As Object)
	AvatarBmp = bmp
	AvatarTag = Tag
	AvatarPath = ""
	LastUpscaleWarningKey = ""
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarTag As Object
	Return AvatarTag
End Sub

Public Sub setAvatarStatus(Mode As String)
	Dim m As String = Mode.ToLowerCase
	If m <> "online" And m <> "offline" Then m = "none"
	AvatarStatus = m
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setStatus(Mode As String)
	SetAvatarStatus(Mode)
End Sub

Public Sub getAvatarStatus As String
	Return AvatarStatus
End Sub

Public Sub setAvatarStatusColors(OnlineColor As Int, OfflineColor As Int)
	If OnlineColor <> 0 Then
		CustomOnlineColor = OnlineColor
		AvatarOnlineColor = OnlineColor
	End If
	If OfflineColor <> 0 Then
		CustomOfflineColor = OfflineColor
		AvatarOfflineColor = OfflineColor
	End If
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

'Helper for online-only status color updates without touching offline color.
Public Sub setAvatarOnlineColor(OnlineColor As Int)
	If OnlineColor = 0 Then Return
	CustomOnlineColor = OnlineColor
	AvatarOnlineColor = OnlineColor
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

'Short alias for setAvatarOnlineColor.
Public Sub setOnlineColor(OnlineColor As Int)
	setAvatarOnlineColor(OnlineColor)
End Sub

Public Sub getAvatarOnlineColor As Int
	Return ResolveOnlineColor
End Sub

Public Sub getAvatarOfflineColor As Int
	Return ResolveOfflineColor
End Sub

Public Sub setShowOnline(Show As Boolean)
	OnlineIndicatorVisible = Show
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShowOnline As Boolean
	Return OnlineIndicatorVisible
End Sub

Public Sub setAvatarMask(MaskName As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(MaskName)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarMask As String
	Return AvatarMask
End Sub

Public Sub setRoundedBox(Value As Boolean)
	If Value Then
		SetAvatarMask("rounded")
	Else
		SetAvatarMask("circle")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	Return AvatarMask = "rounded"
End Sub

Public Sub setGlobalMask(MaskName As String)
	SetAvatarMask(MaskName)
End Sub

Public Sub setAvatarSize(Size As Object)
	Dim v As Float = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Size, Min(mWidth, mHeight)))
	mWidth = v
	mHeight = v
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setCenterOnParent(Value As Boolean)
	CenterOnParent = Value
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getCenterOnParent As Boolean
	Return CenterOnParent
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

'Compatibility wrappers for previous API names.
Public Sub setAvatarWidth(Value As Object)
	setWidth(Value)
End Sub

Public Sub setAvatarHeight(Value As Object)
	setHeight(Value)
End Sub

Public Sub getAvatarWidth As Float
	Return getWidth
End Sub

Public Sub getAvatarHeight As Float
	Return getHeight
End Sub

Public Sub setAvatarBorder(Color As Int, Width As Float)
	AvatarBorderColor = Color
	AvatarBorderWidth = Max(0, Width)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setAvatarBorderInset(Inset As Float)
	SetRingOffset(Inset)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setRingColor(Color As Int)
	RingColor = Color
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingColor As Int
	Return RingColor
End Sub

'Convenience API: pass a Daisy variant token (eg "primary") for ring color.
Public Sub setRingColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, VariantName, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, VariantName, "muted", AvatarBorderColor)
	SetRingColor(c)
End Sub

Public Sub setRingWidth(Width As Float)
	AvatarBorderWidth = Max(0, Width)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingWidth As Float
	Return AvatarBorderWidth
End Sub

Public Sub setRingOffset(Offset As Float)
	RingOffset = Max(0, Offset)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingOffset As Float
	Return RingOffset
End Sub

Private Sub InitializePalette
	If DefaultVariantPalette.IsInitialized = False Then DefaultVariantPalette = B4XDaisyVariants.DefaultPalette
	If VariantPalette.IsInitialized = False Then VariantPalette = DefaultVariantPalette
End Sub

Private Sub ActivePalette As Map
	If VariantPalette.IsInitialized Then Return VariantPalette
	InitializePalette
	Return DefaultVariantPalette
End Sub

Private Sub ResolveOnlineColor As Int
	Dim c As Int = AvatarOnlineColor
	If UseVariantStatusColors Then c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "back", c)
	If CustomOnlineColor <> 0 Then c = CustomOnlineColor
	Return c
End Sub

Private Sub ResolveOfflineColor As Int
	Dim c As Int = AvatarOfflineColor
	If UseVariantStatusColors Then
		c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "muted", c)
		If c = 0 Then c = B4XDaisyVariants.ResolveOfflineColor(Variant, AvatarOfflineColor)
	End If
	If CustomOfflineColor <> 0 Then c = CustomOfflineColor
	Return c
End Sub

Private Sub ResolveRingColor As Int
	If RingColor <> 0 Then Return RingColor
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, Variant, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "muted", AvatarBorderColor)
	Return c
End Sub

Private Sub ResolveAvatarContentRect(Width As Float, Height As Float) As B4XRect
	Dim r As B4XRect
	r.Initialize(0, 0, Width, Height)
	Dim spec As Map = B4XDaisyVariants.ResolveShadowSpec(Shadow)
	Dim leftPadPx As Float = 0
	Dim topPadPx As Float = 0
	Dim rightPadPx As Float = 0
	Dim bottomPadPx As Float = 0

	Dim layers() As String = Array As String("1", "2")
	For Each layer As String In layers
		Dim alpha As Double = GetPropFloat(spec, "alpha" & layer, 0)
		If alpha <= 0 Then Continue
		Dim y As Float = GetPropFloat(spec, "y" & layer, 0)
		Dim blur As Float = Max(0, GetPropFloat(spec, "blur" & layer, 0))
		Dim spread As Float = GetPropFloat(spec, "spread" & layer, 0)
		Dim expansion As Float = Max(0, spread) + (blur * 0.6)
		leftPadPx = Max(leftPadPx, expansion)
		rightPadPx = Max(rightPadPx, expansion)
		topPadPx = Max(topPadPx, expansion + Max(0, -y))
		bottomPadPx = Max(bottomPadPx, expansion + Max(0, y))
	Next

	Dim leftPad As Float = leftPadPx * 1dip
	Dim topPad As Float = topPadPx * 1dip
	Dim rightPad As Float = rightPadPx * 1dip
	Dim bottomPad As Float = bottomPadPx * 1dip

	If leftPad + rightPad > Width - 2dip Then
		Dim capX As Float = Max(0, (Width - 2dip) / 2)
		leftPad = Min(leftPad, capX)
		rightPad = Min(rightPad, capX)
	End If
	If topPad + bottomPad > Height - 2dip Then
		Dim capY As Float = Max(0, (Height - 2dip) / 2)
		topPad = Min(topPad, capY)
		bottomPad = Min(bottomPad, capY)
	End If

	r.Initialize(leftPad, topPad, Width - rightPad, Height - bottomPad)
	Return r
End Sub

Private Sub DrawAvatarShadow(BaseRect As B4XRect, MaskName As String)
	Dim spec As Map = B4XDaisyVariants.ResolveShadowSpec(Shadow)
	DrawShadowLayer(BaseRect, MaskName, GetPropFloat(spec, "y1", 0), GetPropFloat(spec, "blur1", 0), GetPropFloat(spec, "spread1", 0), GetPropFloat(spec, "alpha1", 0))
	DrawShadowLayer(BaseRect, MaskName, GetPropFloat(spec, "y2", 0), GetPropFloat(spec, "blur2", 0), GetPropFloat(spec, "spread2", 0), GetPropFloat(spec, "alpha2", 0))
End Sub

Private Sub DrawShadowLayer(BaseRect As B4XRect, MaskName As String, OffsetYPx As Float, BlurPx As Float, SpreadPx As Float, Alpha As Double)
	If Alpha <= 0 Then Return

	Dim y As Float = OffsetYPx * 1dip
	Dim blur As Float = Max(0, BlurPx) * 1dip
	Dim spread As Float = SpreadPx * 1dip
	Dim expansion As Float = Max(0, spread) + (blur * 0.45)
	Dim alphaInt As Int = Max(0, Min(255, Alpha * 255))
	If alphaInt <= 0 Then Return

	Dim shadowRect As B4XRect
	shadowRect.Initialize(BaseRect.Left - expansion, BaseRect.Top + y - expansion, BaseRect.Right + expansion, BaseRect.Bottom + y + expansion)
	Dim shadowPath As B4XPath = B4XDaisyVariants.CreateMaskPathInRect(shadowRect, MaskName)
	AvatarCvs.DrawPath(shadowPath, xui.Color_ARGB(alphaInt, 0, 0, 0), True, 0)

	'Second pass to mimic blur falloff in utility shadows.
	If blur > 0.5dip Then
		Dim extra As Float = blur * 0.35
		Dim shadowRect2 As B4XRect
		shadowRect2.Initialize(shadowRect.Left - extra, shadowRect.Top - extra, shadowRect.Right + extra, shadowRect.Bottom + extra)
		Dim alpha2 As Int = Max(0, Min(255, alphaInt * 0.4))
		If alpha2 > 0 Then
			Dim shadowPath2 As B4XPath = B4XDaisyVariants.CreateMaskPathInRect(shadowRect2, MaskName)
			AvatarCvs.DrawPath(shadowPath2, xui.Color_ARGB(alpha2, 0, 0, 0), True, 0)
		End If
	End If
End Sub

Private Sub DrawAvatar
	If ivAvatar.IsInitialized = False Or ivAvatar.Visible = False Then Return
	Dim aw As Int = Max(1dip, ivAvatar.Width)
	Dim ah As Int = Max(1dip, ivAvatar.Height)
	If aw <= 0 Or ah <= 0 Then Return

	If AvatarCanvasReady Then AvatarCvs.Release
	AvatarCvs.Initialize(ivAvatar)
	AvatarCanvasReady = True
	AvatarCvs.ClearRect(AvatarCvs.TargetRect)

	Dim full As B4XRect
	If ChatImage Then
		full.Initialize(0, 0, aw, ah)
	Else
		full = ResolveAvatarContentRect(aw, ah)
		If full.Width <= 2dip Or full.Height <= 2dip Then full.Initialize(0, 0, aw, ah)
	End If
	Dim imageRect As B4XRect
	Dim imagePath As B4XPath
	Dim ringPath As B4XPath
	Dim shadowRect As B4XRect
	Dim shadowMask As String = AvatarMask
	Dim effectiveStatus As String = AvatarStatus
	If OnlineIndicatorVisible = False Then effectiveStatus = "none"

	Dim statusColor As Int = 0
	If effectiveStatus = "online" Then
		statusColor = ResolveOnlineColor
	Else If effectiveStatus = "offline" Then
		statusColor = ResolveOfflineColor
	End If

	Dim ringColor As Int
	If ChatImage Then
		ringColor = IIf(statusColor <> 0, statusColor, AvatarBorderColor)
	Else
		ringColor = ResolveRingColor
	End If
	Dim ringW As Float = Max(0, AvatarBorderWidth)
	'Chat-image behavior: online status should always surface a visible ring.
	If ChatImage And effectiveStatus = "online" And ringW <= 0 Then
		ringW = Max(1dip, PROP_DEFAULT_RING_WIDTH_DIP)
	End If
	Dim gapW As Float = Max(0, RingOffset)
	Dim ringRadius As Float = -1

	If AvatarMask = "circle" Or AvatarMask = "rounded-full" Then
		Dim s As Float = Min(full.Width, full.Height)
		Dim ox As Float = full.Left + (full.Width - s) / 2
		Dim oy As Float = full.Top + (full.Height - s) / 2
		Dim cx0 As Float = ox + s / 2
		Dim cy0 As Float = oy + s / 2
		Dim outerR As Float = s / 2 - 0.5dip
		Dim reserved As Float = IIf(ringW > 0, gapW + ringW, 0)
		Dim avatarR As Float = outerR - reserved
		If avatarR < 3dip Then avatarR = Max(3dip, outerR * 0.75)
		imageRect.Initialize(cx0 - avatarR, cy0 - avatarR, cx0 + avatarR, cy0 + avatarR)
		imagePath.InitializeOval(imageRect)
		If ringW > 0 Then ringRadius = avatarR + gapW + ringW / 2
		shadowRect.Initialize(cx0 - outerR, cy0 - outerR, cx0 + outerR, cy0 + outerR)
		shadowMask = "circle"
	Else
		Dim reserved2 As Float = IIf(ringW > 0, gapW + ringW, 0)
		If ChatImage Then
			imageRect = full
			imagePath = B4XDaisyVariants.CreateMaskPathRect(aw, ah, AvatarMask)
		Else
			imageRect = InsetRectSafe(full, reserved2, 6dip)
			imagePath = B4XDaisyVariants.CreateMaskPathInRect(imageRect, AvatarMask)
		End If
		shadowRect = full
		If ringW > 0 Then
			If ChatImage Then
				ringPath = imagePath
			Else
				ringPath = B4XDaisyVariants.CreateMaskPathInRect(full, AvatarMask)
			End If
		End If
	End If

	If ChatImage = False And B4XDaisyVariants.NormalizeShadow(Shadow) <> "none" Then
		DrawAvatarShadow(shadowRect, shadowMask)
	End If

	AvatarCvs.ClipPath(imagePath)
	If AvatarBmp.IsInitialized Then
		If ChatImage Then
			WarnIfUpscaled(AvatarSourceLabel, AvatarBmp, imageRect)
			AvatarCvs.DrawBitmap(AvatarBmp, imageRect)
		Else
			'Use object-fit: cover behavior by default (center crop, keep aspect ratio).
			Dim bmpRect As B4XRect = ResolveBitmapCoverRect(AvatarBmp, imageRect)
			WarnIfUpscaled(AvatarSourceLabel, AvatarBmp, bmpRect)
			AvatarCvs.DrawBitmap(AvatarBmp, bmpRect)
		End If
	Else
		Dim placeholder As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "back", xui.Color_RGB(220, 220, 220))
		AvatarCvs.DrawRect(imageRect, placeholder, True, 0)
	End If
	AvatarCvs.RemoveClip

	If ringW > 0 Then
		If AvatarMask = "circle" Or AvatarMask = "rounded-full" Then
			If ringRadius > 0 Then AvatarCvs.DrawCircle(imageRect.CenterX, imageRect.CenterY, ringRadius, ringColor, False, ringW)
		Else
			AvatarCvs.DrawPath(ringPath, ringColor, False, ringW)
		End If
	End If

	If effectiveStatus <> "none" Then
		Dim dd As Float = IIf(ChatImage, Min(aw, ah), Min(imageRect.Width, imageRect.Height))
		Dim d As Float = Max(6dip, dd * 0.15)
		Dim r As Float = d / 2
		Dim cx As Float
		Dim cy As Float
		If ChatImage Then
			cx = aw - (dd * 0.07) - r
			cy = (dd * 0.07) + r
		Else
			cx = imageRect.Right - (dd * 0.07) - r
			cy = imageRect.Top + (dd * 0.07) + r
		End If
		AvatarCvs.DrawCircle(cx, cy, r + 2dip, AvatarBorderColor, True, 0)
		AvatarCvs.DrawCircle(cx, cy, r, statusColor, True, 0)
	End If

	AvatarCvs.Invalidate
End Sub

Private Sub AvatarSourceLabel As String
	If AvatarPath <> "" Then Return AvatarPath
	Return "<bitmap>"
End Sub

Private Sub WarnIfUpscaled(SourceLabel As String, Bmp As B4XBitmap, DestRect As B4XRect)
	If Bmp.IsInitialized = False Then Return
	If Bmp.Width <= 0 Or Bmp.Height <= 0 Then Return
	If DestRect.Width <= 0 Or DestRect.Height <= 0 Then Return
	Dim sx As Double = DestRect.Width / Bmp.Width
	Dim sy As Double = DestRect.Height / Bmp.Height
	Dim scaleUp As Double = Max(sx, sy)
	If scaleUp <= 1.05 Then Return
	Dim key As String = SourceLabel & "|" & Bmp.Width & "x" & Bmp.Height & "|" & Round(DestRect.Width) & "x" & Round(DestRect.Height)
	If key = LastUpscaleWarningKey Then Return
	LastUpscaleWarningKey = key
	Log("B4XDaisyAvatar warning: '" & SourceLabel & "' may pixelate (source " & Bmp.Width & "x" & Bmp.Height & _
		", draw " & Round(DestRect.Width) & "x" & Round(DestRect.Height) & ", upscale x" & NumberFormat2(scaleUp, 1, 2, 2, False) & ").")
End Sub

Private Sub InsetRectSafe(Source As B4XRect, Inset As Float, MinSize As Float) As B4XRect
	Dim r As B4XRect
	Dim ix As Float = Max(0, Min(Inset, Max(0, (Source.Width - MinSize) / 2)))
	Dim iy As Float = Max(0, Min(Inset, Max(0, (Source.Height - MinSize) / 2)))
	r.Initialize(Source.Left + ix, Source.Top + iy, Source.Right - ix, Source.Bottom - iy)
	Return r
End Sub

Private Sub ResolveBitmapCoverRect(Bmp As B4XBitmap, TargetRect As B4XRect) As B4XRect
	Dim outRect As B4XRect
	outRect.Initialize(TargetRect.Left, TargetRect.Top, TargetRect.Right, TargetRect.Bottom)
	If Bmp.IsInitialized = False Then Return outRect
	If Bmp.Width <= 0 Or Bmp.Height <= 0 Then Return outRect
	If TargetRect.Width <= 0 Or TargetRect.Height <= 0 Then Return outRect

	'CSS-like object-fit: cover => scale to fully cover target and crop overflow.
	Dim scaleX As Float = TargetRect.Width / Bmp.Width
	Dim scaleY As Float = TargetRect.Height / Bmp.Height
	Dim scale As Float = Max(scaleX, scaleY)
	Dim w As Float = Bmp.Width * scale
	Dim h As Float = Bmp.Height * scale
	Dim cx As Float = TargetRect.CenterX
	Dim cy As Float = TargetRect.CenterY
	outRect.Initialize(cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
	Return outRect
End Sub

Private Sub ivAvatar_Click
	Dim payload As Object = AvatarTag
	If payload = Null Then payload = mBase.Tag
	If payload = Null Then payload = ""
	If xui.SubExists(mCallBack, mEventName & "_AvatarClick", 1) Then
		CallSub2(mCallBack, mEventName & "_AvatarClick", payload)
	End If
End Sub
