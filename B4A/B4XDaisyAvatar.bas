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
#DesignerProperty: Key: AvatarType, DisplayName: Avatar Type, FieldType: String, DefaultValue: image, List: image|svg|text, Description: Content type rendered inside avatar
#DesignerProperty: Key: PlaceHolder, DisplayName: Placeholder, FieldType: String, DefaultValue:, Description: Placeholder text for text type (and image/svg fallback)
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue:, Description: Placeholder text size token (eg text-sm, text-lg). Empty = auto-fit
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Placeholder text color (0 = theme base-content)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Placeholder background color (0 = variant/theme fallback)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Padding utility/value for avatar drawing area (eg p-2, px-1, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Margin utility/value for avatar host insets (eg m-2, mx-1.5, 1)
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
	Private mTag As Object
	Private CustProps As Map

	Private Variant As String = "none"

	Private mWidth As Float = 40dip
	Private mHeight As Float = 40dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private AvatarType As String = "image"
	Private PlaceholderText As String = ""
	Private PlaceholderTextSize As String = ""
	Private PlaceholderTextColor As Int = 0
	Private PlaceholderBackgroundColor As Int = 0
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private CenterOnParent As Boolean = True
	Private ChatImage As Boolean = False
	Private AvatarMask As String = "circle"
	Private AvatarPath As String = ""
	Private AvatarBmp As B4XBitmap
	Private AvatarTag As Object

	Private AvatarStatus As String = "none" 'none|online|offline
	Private OnlineIndicatorVisible As Boolean = False
	Private UseVariantStatusColors As Boolean = False
	Private AvatarOnlineColor As Int = 0xFF2ECC71
	Private AvatarOfflineColor As Int = 0xFFB4B4B4
	Private CustomOnlineColor As Int = 0
	Private CustomOfflineColor As Int = 0

	Private AvatarBorderColor As Int = 0
	Private AvatarBorderWidth As Float = 0dip
	Private RingColor As Int = 0
	Private RingOffset As Float = 0dip
	Private Shadow As String = "none"

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
	SetDefaults
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
	Dim snap As Map = GetProperties
	Dim props As Map
	props.Initialize
	For Each k As String In snap.Keys
		props.Put(k, snap.Get(k))
	Next
	If mWidthExplicit = False Then props.Put("Width", Max(1, Round(w / 1dip)) & "px")
	If mHeightExplicit = False Then props.Put("Height", Max(1, Round(h / 1dip)) & "px")
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

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(ChildView, Left, Top, Width, Height)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And ivAvatar.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
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
	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, w, h)
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	Dim availW As Int = Max(1dip, contentRect.Width)
	Dim availH As Int = Max(1dip, contentRect.Height)
	Dim drawW As Int = Max(1dip, mWidth)
	Dim drawH As Int = Max(1dip, mHeight)
	If drawW > availW Then drawW = availW
	If drawH > availH Then drawH = availH
	Dim x As Int = contentRect.Left
	Dim y As Int = contentRect.Top
	If CenterOnParent Then
		x = contentRect.Left + (availW - drawW) / 2
		y = contentRect.Top + (availH - drawH) / 2
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
	If CustProps.IsInitialized = False Then SetDefaults
	SetProperties(Props)
	Dim p As Map = CustProps
	'Reset mapped runtime values to designer defaults first (prevents drift).
	Variant = "none"
	Shadow = "none"
	mWidth = B4XDaisyVariants.TailwindSizeToDip("10", 40dip)
	mHeight = B4XDaisyVariants.TailwindSizeToDip("10", 40dip)
	mWidthExplicit = False
	mHeightExplicit = False
	AvatarType = "image"
	PlaceholderText = ""
	PlaceholderTextSize = ""
	PlaceholderTextColor = 0
	PlaceholderBackgroundColor = 0
	mPadding = ""
	mMargin = ""
	CenterOnParent = True
	ChatImage = False
	AvatarMask = "circle"
	AvatarStatus = "none"
	OnlineIndicatorVisible = False
	UseVariantStatusColors = False
	AvatarOnlineColor = 0xFF2ECC71
	AvatarOfflineColor = 0xFFB4B4B4
	CustomOnlineColor = 0
	CustomOfflineColor = 0
	AvatarBorderColor = 0
	AvatarBorderWidth = 0dip
	RingColor = 0
	RingOffset = 0dip
	AvatarPath = ""

	setVariant(getPropString(p, "Variant", Variant))
	SetShadow(GetPropString(p, "Shadow", Shadow))

	mWidth = Max(16dip, GetPropSizeDip(p, "Width", ResolveWidthBase(mWidth)))
	mHeight = Max(16dip, GetPropSizeDip(p, "Height", ResolveHeightBase(mHeight)))
	AvatarType = NormalizeAvatarType(getPropString(p, "AvatarType", AvatarType))
	PlaceholderText = getPropString(p, "PlaceHolder", PlaceholderText)
	PlaceholderTextSize = getPropString(p, "TextSize", PlaceholderTextSize)
	PlaceholderTextColor = GetPropInt(p, "TextColor", PlaceholderTextColor)
	PlaceholderBackgroundColor = GetPropInt(p, "BackgroundColor", PlaceholderBackgroundColor)
	mPadding = getPropString(p, "Padding", mPadding)
	mMargin = getPropString(p, "Margin", mMargin)
	CenterOnParent = GetPropBool(p, "CenterOnParent", CenterOnParent)
	ChatImage = GetPropBool(p, "ChatImage", ChatImage)
	'Compatibility aliases (older key names).
	If p.ContainsKey("AvatarWidth") Then mWidth = Max(16dip, GetPropSizeDip(p, "AvatarWidth", ResolveWidthBase(mWidth)))
	If p.ContainsKey("AvatarHeight") Then mHeight = Max(16dip, GetPropSizeDip(p, "AvatarHeight", ResolveHeightBase(mHeight)))
	If p.ContainsKey("AvatarSize") Then
		Dim s As Float = Max(16dip, GetPropSizeDip(p, "AvatarSize", Min(mWidth, mHeight)))
		mWidth = s
		mHeight = s
	End If
	If p.ContainsKey("Width") Then mWidthExplicit = True
	If p.ContainsKey("Height") Then mHeightExplicit = True
	If p.ContainsKey("AvatarWidth") Then mWidthExplicit = True
	If p.ContainsKey("AvatarHeight") Then mHeightExplicit = True
	If p.ContainsKey("AvatarSize") Then
		mWidthExplicit = True
		mHeightExplicit = True
	End If

	SetAvatarMask(GetPropString(p, "Mask", GetPropString(p, "AvatarMask", AvatarMask)))
	If GetPropBool(p, "RoundedBox", False) Then SetAvatarMask("rounded")
	SetAvatarStatus(GetPropString(p, "Status", AvatarStatus))
	SetShowOnline(GetPropBool(p, "ShowOnline", OnlineIndicatorVisible))
	UseVariantStatusColors = GetPropBool(p, "UseVariantStatusColors", UseVariantStatusColors)

	CustomOnlineColor = GetPropInt(p, "OnlineColor", 0)
	CustomOfflineColor = GetPropInt(p, "OfflineColor", 0)
	AvatarOnlineColor = 0xFF2ECC71
	AvatarOfflineColor = 0xFFB4B4B4
	If CustomOnlineColor <> 0 Then AvatarOnlineColor = CustomOnlineColor
	If CustomOfflineColor <> 0 Then AvatarOfflineColor = CustomOfflineColor
	RingColor = GetPropInt(p, "RingColor", 0)
	AvatarBorderWidth = Max(0, GetPropDip(p, "RingWidth", AvatarBorderWidth))
	RingOffset = Max(0, GetPropDip(p, "RingOffset", RingOffset))
	'Compatibility with earlier internal naming.
	If p.ContainsKey("AvatarBorderWidth") Then AvatarBorderWidth = Max(0, GetPropDip(p, "AvatarBorderWidth", AvatarBorderWidth))
	If p.ContainsKey("AvatarBorderInset") Then RingOffset = Max(0, GetPropDip(p, "AvatarBorderInset", RingOffset))

	SetAvatar(GetPropString(p, "Image", GetPropString(p, "Avatar", "")))
End Sub

Public Sub SetDefaults
	CustProps.Initialize
	CustProps.Put("Variant", Variant)
	CustProps.Put("Shadow", Shadow)
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("AvatarType", AvatarType)
	CustProps.Put("PlaceHolder", PlaceholderText)
	CustProps.Put("TextSize", PlaceholderTextSize)
	CustProps.Put("TextColor", PlaceholderTextColor)
	CustProps.Put("BackgroundColor", PlaceholderBackgroundColor)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("Margin", mMargin)
	CustProps.Put("CenterOnParent", CenterOnParent)
	CustProps.Put("ChatImage", ChatImage)
	CustProps.Put("Image", AvatarPath)
	CustProps.Put("Avatar", AvatarPath)
	CustProps.Put("Mask", AvatarMask)
	CustProps.Put("Status", AvatarStatus)
	CustProps.Put("ShowOnline", OnlineIndicatorVisible)
	CustProps.Put("UseVariantStatusColors", UseVariantStatusColors)
	CustProps.Put("OnlineColor", CustomOnlineColor)
	CustProps.Put("OfflineColor", CustomOfflineColor)
	CustProps.Put("RingColor", RingColor)
	CustProps.Put("RingWidth", AvatarBorderWidth)
	CustProps.Put("RingOffset", RingOffset)
End Sub

Public Sub SetProperties(Props As Map)
	If Props.IsInitialized = False Then Return
	Dim src As Map
	src.Initialize
	For Each k As String In Props.Keys
		src.Put(k, Props.Get(k))
	Next
	CustProps.Initialize
	For Each k As String In src.Keys
		CustProps.Put(k, src.Get(k))
	Next
End Sub

Public Sub GetProperties As Map
	CustProps.Initialize
	CustProps.Put("Variant", Variant)
	CustProps.Put("Shadow", Shadow)
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("AvatarType", AvatarType)
	CustProps.Put("PlaceHolder", PlaceholderText)
	CustProps.Put("TextSize", PlaceholderTextSize)
	CustProps.Put("TextColor", PlaceholderTextColor)
	CustProps.Put("BackgroundColor", PlaceholderBackgroundColor)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("Margin", mMargin)
	CustProps.Put("CenterOnParent", CenterOnParent)
	CustProps.Put("ChatImage", ChatImage)
	CustProps.Put("Image", AvatarPath)
	CustProps.Put("Avatar", AvatarPath)
	CustProps.Put("Mask", AvatarMask)
	CustProps.Put("Status", AvatarStatus)
	CustProps.Put("ShowOnline", OnlineIndicatorVisible)
	CustProps.Put("UseVariantStatusColors", UseVariantStatusColors)
	CustProps.Put("OnlineColor", CustomOnlineColor)
	CustProps.Put("OfflineColor", CustomOfflineColor)
	CustProps.Put("RingColor", RingColor)
	CustProps.Put("RingWidth", AvatarBorderWidth)
	CustProps.Put("RingOffset", RingOffset)
	CustProps.Put("Tag", mTag)
	Return CustProps
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
		If p.Contains("-") Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(Box, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			Box.Put("padding_left", pv)
			Box.Put("padding_top", pv)
			Box.Put("padding_right", pv)
			Box.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If m.Contains("-") Then
			B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			Box.Put("margin_left", mv)
			Box.Put("margin_top", mv)
			Box.Put("margin_right", mv)
			Box.Put("margin_bottom", mv)
		End If
	End If
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
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getVariant As String
	Return Variant
End Sub

Public Sub setShadow(Value As String)
	Shadow = B4XDaisyVariants.NormalizeShadow(Value)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShadow As String
	Return Shadow
End Sub

Public Sub setChatImage(Value As Boolean)
	ChatImage = Value
	If mBase.IsInitialized = False Then Return
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

Public Sub applyActiveTheme
	InitializePalette
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setUseVariantStatusColors(Enabled As Boolean)
	UseVariantStatusColors = Enabled
	If mBase.IsInitialized = False Then Return
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
	If Path = Null Then
		AvatarPath = ""
	Else
		AvatarPath = Path.Trim
	End If
	If mBase.IsInitialized = False Then Return
	SetAvatar(AvatarPath)
End Sub

Public Sub getImage As String
	Return AvatarPath
End Sub

Public Sub setMask(Value As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(Value)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getMask As String
	Return getAvatarMask
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

Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setAvatarStatus(Mode As String)
	Dim m As String = Mode.ToLowerCase
	If m <> "online" And m <> "offline" Then m = "none"
	AvatarStatus = m
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setStatus(Mode As String)
	Dim m As String = Mode.ToLowerCase
	If m <> "online" And m <> "offline" Then m = "none"
	AvatarStatus = m
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarStatus As String
	Return AvatarStatus
End Sub

Public Sub getStatus As String
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
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

'Helper for online-only status color updates without touching offline color.
Public Sub setAvatarOnlineColor(OnlineColor As Int)
	If OnlineColor = 0 Then Return
	CustomOnlineColor = OnlineColor
	AvatarOnlineColor = OnlineColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getOnlineColor As Int
	Return ResolveOnlineColor
End Sub

Public Sub setOfflineColor(OfflineColor As Int)
	If OfflineColor = 0 Then Return
	CustomOfflineColor = OfflineColor
	AvatarOfflineColor = OfflineColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getOfflineColor As Int
	Return ResolveOfflineColor
End Sub

Public Sub setAvatarOnlineColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveOnlineColor(VariantName, ResolveOnlineColor)
	setAvatarOnlineColor(c)
End Sub

'Short alias for setAvatarOnlineColor.
Public Sub setOnlineColor(OnlineColor As Int)
	If OnlineColor = 0 Then Return
	CustomOnlineColor = OnlineColor
	AvatarOnlineColor = OnlineColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setOnlineColorVariant(VariantName As String)
	setAvatarOnlineColorVariant(VariantName)
End Sub

Public Sub getAvatarOnlineColor As Int
	Return ResolveOnlineColor
End Sub

Public Sub getAvatarOfflineColor As Int
	Return ResolveOfflineColor
End Sub

Public Sub setShowOnline(Show As Boolean)
	OnlineIndicatorVisible = Show
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShowOnline As Boolean
	Return OnlineIndicatorVisible
End Sub

Public Sub setAvatarType(Value As String)
	AvatarType = NormalizeAvatarType(Value)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarType As String
	Return AvatarType
End Sub

Public Sub setPlaceHolder(Value As String)
	If Value = Null Then Value = ""
	PlaceholderText = Value
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getPlaceHolder As String
	Return PlaceholderText
End Sub

Public Sub setTextColor(Value As Int)
	PlaceholderTextColor = Value
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getTextColor As Int
	Return PlaceholderTextColor
End Sub

Public Sub setTextSize(Value As String)
	If Value = Null Then Value = ""
	PlaceholderTextSize = Value.Trim
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getTextSize As String
	Return PlaceholderTextSize
End Sub

Public Sub setTextColorVariant(VariantName As String)
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, VariantName, "text", PlaceholderTextColor)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "text", PlaceholderTextColor)
	setTextColor(c)
End Sub

Public Sub setBackgroundColor(Value As Int)
	PlaceholderBackgroundColor = Value
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getBackgroundColor As Int
	Return PlaceholderBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, VariantName, "back", PlaceholderBackgroundColor)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", PlaceholderBackgroundColor)
	setBackgroundColor(c)
End Sub

Public Sub setAvatarMask(MaskName As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(MaskName)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarMask As String
	Return AvatarMask
End Sub

Public Sub setRoundedBox(Value As Boolean)
	AvatarMask = IIf(Value, "rounded", "circle")
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
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
	mWidthExplicit = True
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
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

Public Sub setCenterOnParent(Value As Boolean)
	CenterOnParent = Value
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
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
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setAvatarBorderInset(Inset As Float)
	SetRingOffset(Inset)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setRingColor(Color As Int)
	RingColor = Color
	If mBase.IsInitialized = False Then Return
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
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingWidth As Float
	Return AvatarBorderWidth
End Sub

Public Sub setRingOffset(Offset As Float)
	RingOffset = Max(0, Offset)
	If mBase.IsInitialized = False Then Return
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
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "muted", ResolveAvatarOutlineColor)
	Return c
End Sub

Private Sub ResolveAvatarOutlineColor As Int
	If AvatarBorderColor <> 0 Then Return AvatarBorderColor
	Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_RGB(245, 245, 245))
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
	Dim outlineColor As Int = ResolveAvatarOutlineColor
	If ChatImage Then
		ringColor = IIf(statusColor <> 0, statusColor, outlineColor)
	Else
		ringColor = ResolveRingColor
	End If
	Dim ringW As Float = Max(0, AvatarBorderWidth)
	'Chat-image behavior: online status should always surface a visible ring.
	If ChatImage And effectiveStatus = "online" And ringW <= 0 Then
		ringW = Max(1dip, 1dip)
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
	Dim canDrawBitmap As Boolean = AvatarBmp.IsInitialized And AvatarType = "image"
	If canDrawBitmap Then
		If ChatImage Then
			'WarnIfUpscaled(AvatarSourceLabel, AvatarBmp, imageRect)
			AvatarCvs.DrawBitmap(AvatarBmp, imageRect)
		Else
			'Use object-fit: cover behavior by default (center crop, keep aspect ratio).
			Dim bmpRect As B4XRect = ResolveBitmapCoverRect(AvatarBmp, imageRect)
			'WarnIfUpscaled(AvatarSourceLabel, AvatarBmp, bmpRect)
			AvatarCvs.DrawBitmap(AvatarBmp, bmpRect)
		End If
	Else
		Dim placeholder As Int = ResolvePlaceholderBackColor
		AvatarCvs.DrawRect(imageRect, placeholder, True, 0)
		Dim phText As String = ResolvePlaceholderText
		If phText.Length > 0 Then
			Dim autoSize As Float = Max(10, Min(imageRect.Width, imageRect.Height) * 0.36)
			Dim fontSize As Float = autoSize
			If PlaceholderTextSize.Length > 0 Then
				Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(PlaceholderTextSize, autoSize, autoSize * 1.2)
				fontSize = tm.GetDefault("font_size", autoSize)
			End If
			Dim f As B4XFont = xui.CreateDefaultBoldFont(fontSize)
			Dim textRect As B4XRect = AvatarCvs.MeasureText(phText, f)
			Dim tx As Float = imageRect.CenterX
			Dim ty As Float = imageRect.CenterY - (textRect.Height / 2) + textRect.Height
			AvatarCvs.DrawText(phText, tx, ty, f, ResolvePlaceholderTextColor, "CENTER")
		End If
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
		AvatarCvs.DrawCircle(cx, cy, r + 2dip, outlineColor, True, 0)
		AvatarCvs.DrawCircle(cx, cy, r, statusColor, True, 0)
	End If

	AvatarCvs.Invalidate
End Sub

Private Sub NormalizeAvatarType(Value As String) As String
	If Value = Null Then Return "image"
	Dim v As String = Value.ToLowerCase.Trim
	Select Case v
		Case "image", "svg", "text"
			Return v
		Case Else
			Return "image"
	End Select
End Sub

Private Sub ResolvePlaceholderBackColor As Int
	If PlaceholderBackgroundColor <> 0 Then Return PlaceholderBackgroundColor
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, Variant, "back", 0)
	If c <> 0 Then Return c
	Return B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(220, 220, 220))
End Sub

Private Sub ResolvePlaceholderTextColor As Int
	If PlaceholderTextColor <> 0 Then Return PlaceholderTextColor
	Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(55, 65, 81))
End Sub

Private Sub ResolvePlaceholderText As String
	Dim t As String = PlaceholderText
	If t <> Null Then t = t.Trim Else t = ""
	If t.Length > 0 Then Return t
	If AvatarType = "svg" Then Return "SVG"
	Return ""
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
	If payload = Null Then payload = mTag
	If payload = Null Then payload = ""
	If xui.SubExists(mCallBack, mEventName & "_AvatarClick", 1) Then
		CallSub2(mCallBack, mEventName & "_AvatarClick", payload)
	End If
End Sub
