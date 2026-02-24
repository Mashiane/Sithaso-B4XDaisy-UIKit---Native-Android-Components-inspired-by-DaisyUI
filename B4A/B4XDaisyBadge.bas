B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)
#Event: CloseClick (Tag As Object)
#Event: Checked (Id As String, Checked As Boolean)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: fit-content, Description: Tailwind size token, CSS size, or fit-content
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size (eg 6, 24px, 1.5rem)
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Badge size token
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant used for colors
#DesignerProperty: Key: BadgeStyle, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost, Description: Badge visual style
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: Badge, Description: Text displayed inside badge
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind spacing utilities (eg px-2, py-1, p-1.5)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind spacing utilities (eg m-1, mx-2)
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide badge view
#DesignerProperty: Key: AvatarVisible, DisplayName: Avatar Visible, FieldType: Boolean, DefaultValue: False, Description: Show avatar inside badge
#DesignerProperty: Key: AvatarImage, DisplayName: Avatar Image, FieldType: String, DefaultValue:, Description: Avatar image path from assets or full path
#DesignerProperty: Key: AvatarText, DisplayName: Avatar Text, FieldType: String, DefaultValue:, Description: Avatar placeholder text when image is empty
#DesignerProperty: Key: AvatarPosition, DisplayName: Avatar Position, FieldType: String, DefaultValue: left, List: left|right, Description: Avatar placement relative to text
#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: SVG asset used for left icon
#DesignerProperty: Key: Toggle, DisplayName: Toggle, FieldType: Boolean, DefaultValue: False, Description: Enables checked/unchecked toggle behavior
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False, Description: Current checked state (effective when Toggle is true)
#DesignerProperty: Key: CheckedColor, DisplayName: Checked Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color used when checked (0 uses variant fallback)
#DesignerProperty: Key: CheckedTextColor, DisplayName: Checked Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Text/icon color used when checked (0 uses variant fallback)
#DesignerProperty: Key: ID, DisplayName: ID, FieldType: String, DefaultValue:, Description: Optional chip identifier returned in checked event
#DesignerProperty: Key: Closable, DisplayName: Closable, FieldType: Boolean, DefaultValue: False, Description: Show close icon on the right side
#DesignerProperty: Key: CloseIconAsset, DisplayName: Close Icon Asset, FieldType: String, DefaultValue: xmark-solid.svg, Description: SVG asset used for close icon
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius mode
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Use selector radius from active theme
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private mWidth As Float = 88dip
	Private mHeight As Float = 24dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mFitContentWidth As Boolean = True
	Private mSize As String = "md"
	Private mVariant As String = "none"
	Private mBadgeStyle As String = "solid"
	Private mText As String = "Badge"
	Private mTextCentered As Boolean = False
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mVisible As Boolean = True
	Private mRounded As String = "theme"
	Private mRoundedBox As Boolean = True
	Private mShadow As String = "none"

	Private mAvatarVisible As Boolean = False
	Private mAvatarImage As String = ""
	Private mAvatarText As String = ""
	Private mAvatarPosition As String = "left"
	Private mIconAsset As String = ""
	Private mToggle As Boolean = False
	Private mChecked As Boolean = False
	Private mCheckedColor As Int = 0
	Private mCheckedTextColor As Int = 0
	Private mId As String = ""
	Private mClosable As Boolean = False
	Private mCloseIconAsset As String = "xmark-solid.svg"

	Private mBackgroundColor As Int = 0
	Private mTextColor As Int = 0
	Private mBorderColor As Int = 0

	Private Surface As B4XView
	Private lblText As B4XView
	Private AvatarComp As B4XDaisyAvatar
	Private AvatarView As B4XView
	Private LeftIconComp As B4XDaisySvgIcon
	Private LeftIconView As B4XView
	Private CloseHost As B4XView
	Private CloseIconComp As B4XDaisySvgIcon
	Private CloseIconView As B4XView
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
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

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("surface")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	Dim pText As Label
	pText.Initialize("")
	pText.SingleLine = True
	lblText = pText
	lblText.Color = xui.Color_Transparent
	lblText.SetTextAlignment("CENTER", "LEFT")
	Surface.AddView(lblText, 0, 0, 1dip, 1dip)

	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "badgeavatar")
	AvatarComp = av
	AvatarView = AvatarComp.AddToParent(Surface, 0, 0, 1dip, 1dip)
	AvatarView.Visible = False

	Dim li As B4XDaisySvgIcon
	li.Initialize(Me, "badgeicon")
	LeftIconComp = li
	LeftIconView = LeftIconComp.AddToParent(Surface, 0, 0, 1dip, 1dip)
	LeftIconView.Visible = False

	Dim pClose As Panel
	pClose.Initialize("closebtn")
	CloseHost = pClose
	CloseHost.Color = xui.Color_Transparent
	Surface.AddView(CloseHost, 0, 0, 1dip, 1dip)
	CloseHost.Visible = False

	Dim ci As B4XDaisySvgIcon
	ci.Initialize(Me, "closeicon")
	CloseIconComp = ci
	CloseIconView = CloseIconComp.AddToParent(CloseHost, 0, 0, 1dip, 1dip)
	CloseIconView.Visible = False

	ApplyDesignerProps(Props)
	mBase.Visible = mVisible
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mHeightExplicit = Props.ContainsKey("Height")
	Dim widthSpec As String = GetPropString(Props, "Width", "fit-content").ToLowerCase.Trim
	If widthSpec = "" Or widthSpec = "fit-content" Or widthSpec = "auto" Then
		mFitContentWidth = True
		mWidthExplicit = False
	Else
		mFitContentWidth = False
		mWidthExplicit = True
		mWidth = Max(24dip, GetPropSizeDip(Props, "Width", "fit-content"))
	End If
	mHeight = Max(16dip, GetPropSizeDip(Props, "Height", "6"))
	mSize = NormalizeSize(GetPropString(Props, "Size", "md"))
	mVariant = B4XDaisyVariants.NormalizeVariant(GetPropString(Props, "Variant", "none"))
	mBadgeStyle = NormalizeBadgeStyle(GetPropString(Props, "BadgeStyle", "solid"))
	mText = GetPropString(Props, "Text", "Badge")
	mTextCentered = GetPropBool(Props, "TextCentered", mTextCentered)
	mPadding = GetPropString(Props, "Padding", "")
	mMargin = GetPropString(Props, "Margin", "")
	mVisible = GetPropBool(Props, "Visible", True)
	mRounded = NormalizeRounded(GetPropString(Props, "Rounded", "theme"))
	mRoundedBox = GetPropBool(Props, "RoundedBox", True)
	mShadow = B4XDaisyVariants.NormalizeShadow(GetPropString(Props, "Shadow", "none"))
	mAvatarVisible = GetPropBool(Props, "AvatarVisible", False)
	mAvatarImage = GetPropString(Props, "AvatarImage", "").Trim
	mAvatarText = GetPropString(Props, "AvatarText", "")
	mAvatarPosition = NormalizeAvatarPosition(GetPropString(Props, "AvatarPosition", "left"))
	mIconAsset = GetPropString(Props, "IconAsset", "").Trim
	mToggle = GetPropBool(Props, "Toggle", False)
	mId = GetPropString(Props, "ID", "")
	mChecked = GetPropBool(Props, "Checked", False)
	mCheckedColor = Props.GetDefault("CheckedColor", mCheckedColor)
	mCheckedTextColor = Props.GetDefault("CheckedTextColor", mCheckedTextColor)
	mId = GetPropString(Props, "ID", "")
	mClosable = GetPropBool(Props, "Closable", False)
	mCloseIconAsset = GetPropString(Props, "CloseIconAsset", "xmark-solid.svg").Trim
	If mCloseIconAsset.Length = 0 Then mCloseIconAsset = "xmark-solid.svg"

	mBackgroundColor = B4XDaisyVariants.GetPropInt(Props, "BackgroundColor", mBackgroundColor)
	mTextColor = B4XDaisyVariants.GetPropInt(Props, "TextColor", mTextColor)
	mBorderColor = B4XDaisyVariants.GetPropInt(Props, "BorderColor", mBorderColor)

	If mHeightExplicit = False Then
		Dim sz As Map = ResolveSizeSpec
		mHeight = Max(16dip, sz.GetDefault("height", 24dip))
	End If
	If mFitContentWidth Then
		mWidth = Max(1dip, EstimatePreferredWidth)
	End If
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	If Surface.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	If mFitContentWidth Then w = Max(w, Max(1dip, EstimatePreferredWidth))
	Dim h As Int = Max(1dip, Height)
	If mFitContentWidth And Abs(mBase.Width - w) > 1dip Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	End If
	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, w, h)
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Surface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
	ApplyVisualStyle(box)
	Dim contentLocalRect As B4XRect = ResolveContentLocalRect(outerRect, box)
	LayoutContent(contentLocalRect)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim targetW As Int = Width
	Dim targetH As Int = Height
	If targetW <= 0 Then targetW = Max(1dip, EstimatePreferredWidth)
	If targetH <= 0 Then targetH = Max(16dip, mHeight)
	Dim w As Int = Max(1dip, targetW)
	Dim h As Int = Max(1dip, targetH)

	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)

	Dim props As Map = BuildRuntimeProps(w, h)

	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Dim finalW As Int = w
	If mFitContentWidth Then finalW = Max(finalW, EstimatePreferredWidth)
	mBase.SetLayoutAnimated(0, 0, 0, finalW, h)
	Parent.AddView(mBase, Left, Top, finalW, h)
	Return mBase
End Sub

Private Sub BuildRuntimeProps(Width As Int, Height As Int) As Map
	' Keep runtime state when view is recreated through DesignerCreateView.
	Dim props As Map
	props.Initialize
	If mFitContentWidth Then
		props.Put("Width", "fit-content")
	Else
		props.Put("Width", ResolvePxSizeSpec(Width))
	End If
	props.Put("Height", ResolvePxSizeSpec(Height))
	props.Put("Size", mSize)
	props.Put("Variant", mVariant)
	props.Put("BadgeStyle", mBadgeStyle)
	props.Put("Text", mText)
	props.Put("TextCentered", mTextCentered)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("Visible", mVisible)
	props.Put("Rounded", mRounded)
	props.Put("RoundedBox", mRoundedBox)
	props.Put("Shadow", mShadow)
	props.Put("AvatarVisible", mAvatarVisible)
	props.Put("AvatarImage", mAvatarImage)
	props.Put("AvatarText", mAvatarText)
	props.Put("AvatarPosition", mAvatarPosition)
	props.Put("IconAsset", mIconAsset)
	props.Put("Toggle", mToggle)
	props.Put("Checked", mChecked)
	props.Put("CheckedColor", mCheckedColor)
	props.Put("CheckedTextColor", mCheckedTextColor)
	props.Put("ID", mId)
	props.Put("Closable", mClosable)
	props.Put("CloseIconAsset", mCloseIconAsset)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("BorderColor", mBorderColor)
	Return props
End Sub

Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Return AddToParent(Parent, Left, Top, Width, Height)
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
	Dim sizeMap As Map = ResolveSizeSpec
	Dim sizeDip As Float = sizeMap.GetDefault("height", 24dip)
	If mHeightExplicit Then sizeDip = Max(16dip, mHeight)
	Dim bw As Float = Max(0, B4XDaisyVariants.GetBorderDip(1dip))
	Dim px As Float = Max(0, (sizeDip / 2) - bw)
	Dim py As Float = 0dip
	box.Put("padding_left", px)
	box.Put("padding_right", px)
	box.Put("padding_top", py)
	box.Put("padding_bottom", py)
	box.Put("border_width", bw)
	box.Put("radius", ResolveBadgeRadiusDip(sizeDip))
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

Private Sub ResolveSizeSpec As Map
	Dim key As String = NormalizeSize(mSize)
	Select Case key
		Case "xs"
			Return CreateMap("height": 16dip, "font": 10, "pad_h": 6dip, "pad_v": 1dip, "gap": 4dip, "avatar": 12dip, "icon": 10dip, "close": 10dip)
		Case "sm"
			Return CreateMap("height": 20dip, "font": 12, "pad_h": 7dip, "pad_v": 2dip, "gap": 4dip, "avatar": 14dip, "icon": 11dip, "close": 11dip)
		Case "lg"
			Return CreateMap("height": 28dip, "font": 16, "pad_h": 10dip, "pad_v": 3dip, "gap": 6dip, "avatar": 18dip, "icon": 14dip, "close": 14dip)
		Case "xl"
			Return CreateMap("height": 32dip, "font": 18, "pad_h": 12dip, "pad_v": 4dip, "gap": 6dip, "avatar": 20dip, "icon": 16dip, "close": 16dip)
		Case Else
			Return CreateMap("height": 24dip, "font": 14, "pad_h": 8dip, "pad_v": 2dip, "gap": 5dip, "avatar": 16dip, "icon": 12dip, "close": 12dip)
	End Select
End Sub

Private Sub LayoutContent(ContentRect As B4XRect)
	Dim sizeMap As Map = ResolveSizeSpec
	Dim xColors As Map = ResolveVisualColors
	Dim textColor As Int = xColors.Get("text")
	Dim textValue As String = NormalizeSingleLineText(mText)

	Dim gap As Int = 8dip
	Dim avatarSize As Int = Max(10dip, sizeMap.GetDefault("avatar", 14dip))
	Dim iconSize As Int = Max(8dip, sizeMap.GetDefault("icon", 11dip))
	Dim closeSize As Int = Max(8dip, sizeMap.GetDefault("close", 11dip))
	Dim fontSize As Float = Max(9, sizeMap.GetDefault("font", 14))

	lblText.Font = xui.CreateDefaultFont(fontSize)
	lblText.Text = textValue
	lblText.TextColor = textColor
	lblText.SetTextAlignment("CENTER", "LEFT")

	Dim leftX As Int = ContentRect.Left
	Dim rightX As Int = ContentRect.Right
	Dim centerY As Int = ContentRect.Top + (ContentRect.Height / 2)

	Dim hasAvatar As Boolean = mAvatarVisible
	Dim avatarOnRight As Boolean = hasAvatar And (mAvatarPosition = "right")
	Dim avatarOnLeft As Boolean = hasAvatar And (mAvatarPosition <> "right")
	If hasAvatar Then
		ConfigureAvatar(avatarSize)
		AvatarView.Visible = True
	Else
		AvatarView.Visible = False
		AvatarView.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If

	If avatarOnLeft Then
		ConfigureAvatar(avatarSize)
		AvatarView.SetLayoutAnimated(0, leftX, centerY - (avatarSize / 2), avatarSize, avatarSize)
		leftX = leftX + avatarSize + gap
	End If

	Dim hasToggleIcon As Boolean = mToggle And mChecked
	Dim leftIconAsset As String = IIf(hasToggleIcon, "check-solid.svg", mIconAsset)
	Dim hasLeftIcon As Boolean = leftIconAsset.Trim.Length > 0
	If hasLeftIcon Then
		LeftIconView.Visible = True
		LeftIconView.SetLayoutAnimated(0, leftX, centerY - (iconSize / 2), iconSize, iconSize)
		ConfigureLeftIcon(iconSize, textColor, leftIconAsset)
		leftX = leftX + iconSize + gap
	Else
		LeftIconView.Visible = False
		LeftIconView.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If

	Dim hasClose As Boolean = (mToggle = False) And mClosable
	Dim hasRightIcon As Boolean = hasClose
	If hasRightIcon Then
		Dim hostSize As Int = closeSize + 4dip
		CloseHost.Visible = True
		CloseHost.SetLayoutAnimated(0, rightX - hostSize, centerY - (hostSize / 2), hostSize, hostSize)
		ConfigureCloseIcon(closeSize, textColor)
		rightX = rightX - hostSize - gap
	Else
		CloseHost.Visible = False
		CloseHost.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If

	If avatarOnRight Then
		AvatarView.SetLayoutAnimated(0, rightX - avatarSize, centerY - (avatarSize / 2), avatarSize, avatarSize)
		rightX = rightX - avatarSize - gap
	End If

	Dim textOnlyContent As Boolean = (hasAvatar = False) And (hasLeftIcon = False) And (hasRightIcon = False)
	If mTextCentered Or textOnlyContent Then
		lblText.SetTextAlignment("CENTER", "CENTER")
	Else
		lblText.SetTextAlignment("CENTER", "LEFT")
	End If

	Dim textW As Int = Max(1dip, rightX - leftX)
	Dim textH As Int = Max(1dip, ContentRect.Height)
	lblText.SetLayoutAnimated(0, leftX, centerY - (textH / 2), textW, textH)
End Sub

Private Sub ConfigureAvatar(AvatarSize As Int)
	If AvatarComp.IsInitialized = False Then Return
	AvatarComp.setVariant(mVariant)
	AvatarComp.setShadow("none")
	AvatarComp.setAvatarMask("circle")
	AvatarComp.setAvatarSize(ResolvePxSizeSpec(AvatarSize))
	If mAvatarImage.Length > 0 Then
		AvatarComp.setAvatarType("image")
		AvatarComp.setAvatar(mAvatarImage)
	Else
		AvatarComp.setAvatarType("text")
		AvatarComp.setAvatar("")
		AvatarComp.setPlaceHolder(mAvatarText)
	End If
End Sub

Private Sub ConfigureLeftIcon(IconSize As Int, IconColor As Int, Asset As String)
	If LeftIconComp.IsInitialized = False Then Return
	Dim iconAsset As String = IIf(Asset = Null, "", Asset.Trim)
	If iconAsset.Length = 0 Then Return
	LeftIconComp.setSvgAsset(iconAsset)
	LeftIconComp.setPreserveOriginalColors(False)
	LeftIconComp.setColor(IconColor)
	LeftIconComp.setSize(ResolvePxSizeSpec(IconSize))
	LeftIconComp.ResizeToParent(LeftIconView)
End Sub

Private Sub ConfigureCloseIcon(IconSize As Int, IconColor As Int)
	If CloseIconComp.IsInitialized = False Then Return
	Dim iconAsset As String = IIf(mCloseIconAsset = Null, "", mCloseIconAsset.Trim)
	If iconAsset.Length = 0 Then iconAsset = "xmark-solid.svg"
	CloseIconComp.setSvgAsset(iconAsset)
	CloseIconComp.setPreserveOriginalColors(False)
	CloseIconComp.setColor(IconColor)
	CloseIconComp.setSize(ResolvePxSizeSpec(IconSize))
	CloseIconView.Visible = True
	CloseIconView.SetLayoutAnimated(0, 2dip, 2dip, Max(1dip, CloseHost.Width - 4dip), Max(1dip, CloseHost.Height - 4dip))
	CloseIconComp.ResizeToParent(CloseIconView)
End Sub

Private Sub ApplyVisualStyle(Box As Map)
	If Surface.IsInitialized = False Then Return
	Dim xColors As Map = ResolveVisualColors
	Dim bg As Int = xColors.Get("back")
	Dim border As Int = xColors.Get("border")
	Dim bw As Int = Max(0, Box.GetDefault("border_width", 0))
	Dim radius As Float = Max(0, Box.GetDefault("radius", 0))
	#If B4A
	Try
		Dim dashW As Float = 0
		Dim dashGap As Float = 0
		If mBadgeStyle = "dash" Then
			dashW = Max(4dip, bw * 3)
			dashGap = Max(3dip, bw * 2)
		End If
		ApplyStrokeNative(Surface, bg, border, bw, radius, dashW, dashGap)
	Catch
		Surface.SetColorAndBorder(bg, bw, border, radius)
	End Try
	#Else
	Surface.SetColorAndBorder(bg, bw, border, radius)
	#End If
	ApplyShadow
End Sub

Private Sub ResolveVisualColors As Map
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim base100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim base200 As Int = tokens.GetDefault("--color-base-200", xui.Color_RGB(232, 234, 237))
	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(63, 64, 77))
	Dim neutralBack As Int = tokens.GetDefault("--color-neutral", xui.Color_RGB(63, 64, 77))
	Dim neutralContent As Int = tokens.GetDefault("--color-neutral-content", xui.Color_RGB(248, 248, 249))

	Dim variantKey As String = B4XDaisyVariants.NormalizeVariant(mVariant)
	Dim accentBack As Int = B4XDaisyVariants.ResolveVariantColor(palette, variantKey, "back", neutralBack)
	Dim accentText As Int = B4XDaisyVariants.ResolveVariantColor(palette, variantKey, "text", neutralContent)

	Dim back As Int
	Dim text As Int
	Dim border As Int

	Select Case mBadgeStyle
		Case "ghost"
			back = base200
			text = baseContent
			border = base200
		Case "soft"
			If variantKey = "none" Then
				back = B4XDaisyVariants.Blend(baseContent, base100, 0.92)
				text = baseContent
				border = B4XDaisyVariants.Blend(baseContent, base100, 0.9)
			Else
				back = B4XDaisyVariants.Blend(accentBack, base100, 0.92)
				text = accentBack
				border = B4XDaisyVariants.Blend(accentBack, base100, 0.9)
			End If
		Case "outline", "dash"
			back = xui.Color_Transparent
			If variantKey = "none" Then
				text = baseContent
				border = text
			Else If variantKey = "neutral" Then
				text = baseContent
				border = accentBack
			Else
				text = accentBack
				border = accentBack
			End If
		Case Else
			If variantKey = "none" Then
				back = base100
				text = baseContent
				border = base200
			Else
				back = accentBack
				text = accentText
				border = accentBack
			End If
	End Select

	If mToggle And mChecked Then
		Dim checkedBackFallback As Int = B4XDaisyVariants.ResolveVariantColor(palette, "success", "back", accentBack)
		Dim checkedTextFallback As Int = B4XDaisyVariants.ResolveVariantColor(palette, "success", "text", accentText)
		back = IIf(mCheckedColor <> 0, mCheckedColor, checkedBackFallback)
		text = IIf(mCheckedTextColor <> 0, mCheckedTextColor, checkedTextFallback)
		border = back
	End If

	If mBackgroundColor <> 0 Then back = mBackgroundColor
	If mTextColor <> 0 Then text = mTextColor
	If mBorderColor <> 0 Then border = mBorderColor
	Return CreateMap("back": back, "text": text, "border": border)
End Sub

Private Sub ApplyShadow
	Dim e As Float = B4XDaisyVariants.ResolveShadowElevation(mShadow)
	#If B4A
	Dim p As Panel = Surface
	p.Elevation = e
	#End If
End Sub

Private Sub EstimatePreferredWidth As Int
	Dim sizeMap As Map = ResolveSizeSpec
	Dim f As Float = Max(9, sizeMap.GetDefault("font", 14))
	Dim gap As Int = 8dip
	Dim textW As Int = MeasureSingleLineWidth(NormalizeSingleLineText(mText), f)
	Dim avatarW As Int = IIf(mAvatarVisible, Max(10dip, sizeMap.GetDefault("avatar", 14dip)) + gap, 0)
	Dim hasLeftIcon As Boolean = (mIconAsset.Length > 0) Or (mToggle And mChecked)
	Dim iconW As Int = IIf(hasLeftIcon, Max(8dip, sizeMap.GetDefault("icon", 11dip)) + gap, 0)
	Dim hasRightIcon As Boolean = (mToggle = False) And mClosable
	Dim rightIconW As Int = IIf(hasRightIcon, Max(8dip, sizeMap.GetDefault("close", 11dip)) + 4dip + gap, 0)
	Dim contentW As Int = Max(0, textW + avatarW + iconW + rightIconW)
	Dim box As Map = BuildBoxModel
	Return Max(1dip, Ceil(B4XDaisyBoxModel.ExpandContentWidth(contentW, box)))
End Sub

Private Sub MeasureSingleLineWidth(Text As String, FontSize As Float) As Int
	If Text.Length = 0 Then Return 0
	If lblText.IsInitialized Then
		Try
			Dim l As Label = lblText
			Dim c As Canvas
			c.Initialize(l)
			Dim w As Float = c.MeasureStringWidth(Text, l.Typeface, FontSize)
			Return Max(1dip, Ceil(w) + 2dip)
		Catch
		End Try
	End If
	' Fallback used before views are attached (e.g. AddToParent pre-creation path).
	Return Max(1dip, Ceil(Text.Length * FontSize * 0.62) + 2dip)
End Sub

Private Sub NormalizeSingleLineText(Value As String) As String
	If Value = Null Then Return ""
	Return Value.Replace(CRLF, " ").Replace(Chr(10), " ").Trim
End Sub

Private Sub NormalizeSize(Value As String) As String
	If Value = Null Then Return "md"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "xs", "sm", "md", "lg", "xl"
			Return s
		Case Else
			Return "md"
	End Select
End Sub

Private Sub NormalizeBadgeStyle(Value As String) As String
	If Value = Null Then Return "solid"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "solid", "soft", "outline", "dash", "ghost"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

Private Sub NormalizeRounded(Value As String) As String
	If Value = Null Then Return "theme"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "", "theme", "selector"
			Return "theme"
		Case "none", "rounded-none"
			Return "rounded-none"
		Case "sm", "rounded-sm"
			Return "rounded-sm"
		Case "default", "rounded"
			Return "rounded"
		Case "md", "rounded-md"
			Return "rounded-md"
		Case "lg", "rounded-lg"
			Return "rounded-lg"
		Case "xl", "rounded-xl"
			Return "rounded-xl"
		Case "2xl", "rounded-2xl"
			Return "rounded-2xl"
		Case "3xl", "rounded-3xl"
			Return "rounded-3xl"
		Case "full", "rounded-full", "rounded-rull"
			Return "rounded-full"
		Case Else
			Return "theme"
	End Select
End Sub

Private Sub ResolveBadgeRadiusDip(SizeDip As Float) As Float
	Dim mode As String = NormalizeRounded(mRounded)
	If mode = "theme" Then
		If mRoundedBox = False Then Return 0
		If IsEmptyBadge Then Return SizeDip / 2
		Return B4XDaisyVariants.GetRadiusSelectorDip(4dip)
	End If
	Select Case mode
		Case "rounded-none"
			Return 0
		Case "rounded-sm"
			Return Min(SizeDip / 2, 2dip)
		Case "rounded"
			Return Min(SizeDip / 2, 4dip)
		Case "rounded-md"
			Return Min(SizeDip / 2, 6dip)
		Case "rounded-lg"
			Return Min(SizeDip / 2, 8dip)
		Case "rounded-xl"
			Return Min(SizeDip / 2, 12dip)
		Case "rounded-2xl"
			Return Min(SizeDip / 2, 16dip)
		Case "rounded-3xl"
			Return Min(SizeDip / 2, 24dip)
		Case "rounded-full"
			Return SizeDip / 2
		Case Else
			Return B4XDaisyVariants.GetRadiusSelectorDip(4dip)
	End Select
End Sub

Private Sub IsEmptyBadge As Boolean
	If mAvatarVisible Then Return False
	If mIconAsset.Trim.Length > 0 Then Return False
	If mClosable Then Return False
	If mToggle And mChecked Then Return False
	If NormalizeSingleLineText(mText).Length > 0 Then Return False
	Return True
End Sub

Private Sub NormalizeAvatarPosition(Value As String) As String
	If Value = Null Then Return "left"
	Dim s As String = Value.ToLowerCase.Trim
	If s = "right" Then Return "right"
	Return "left"
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Object) As Float
	Dim baseDip As Float = B4XDaisyVariants.TailwindSizeToDip(DefaultDipValue, 0)
	If Props.IsInitialized = False Then Return baseDip
	If Props.ContainsKey(Key) = False Then Return baseDip
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, baseDip)
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
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

	If mBase.IsInitialized = False Then Return
	If mFitContentWidth Then
		Dim targetW As Int = Max(1dip, EstimatePreferredWidth)
		Dim targetH As Int = Max(1dip, mBase.Height)
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
	End If
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub surface_Click
	If mToggle Then
		ToggleCheckedFromInteraction
	Else If mClosable Then
		HandleCloseTap
	Else
		RaiseClick
	End If
End Sub

Private Sub closebtn_Click
	If mToggle Then
		ToggleCheckedFromInteraction
	Else
		HandleCloseTap
	End If
End Sub

Private Sub HandleCloseTap
	If mClosable = False Then Return
	setVisible(False)
	RaiseCloseClick
End Sub

Private Sub ToggleCheckedFromInteraction
	If mToggle = False Then Return
	mChecked = Not(mChecked)
	Refresh
	RaiseCheckedEvent
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

Private Sub RaiseCloseClick
	Dim payload As Object = mTag
	If payload = Null Then payload = mBase
	If xui.SubExists(mCallBack, mEventName & "_CloseClick", 1) Then
		CallSub2(mCallBack, mEventName & "_CloseClick", payload)
	Else If xui.SubExists(mCallBack, mEventName & "_CloseClick", 0) Then
		CallSub(mCallBack, mEventName & "_CloseClick")
	End If
End Sub

Private Sub RaiseCheckedEvent
	Dim idValue As String = mId
	If xui.SubExists(mCallBack, mEventName & "_Checked", 2) Then
		CallSub3(mCallBack, mEventName & "_Checked", idValue, mChecked)
	Else If xui.SubExists(mCallBack, mEventName & "_CheckedChanged", 2) Then
		CallSub3(mCallBack, mEventName & "_CheckedChanged", idValue, mChecked)
	End If
End Sub

' Native dashed stroke helper used for badge-dash style.
#If B4A
Private Sub ApplyStrokeNative(Target As B4XView, FillColor As Int, StrokeColor As Int, StrokeWidth As Int, Radius As Float, DashWidth As Float, DashGap As Float)
	Dim gd As JavaObject = CreateSolidDrawable(FillColor, Radius)
	If StrokeWidth > 0 Then
		If DashWidth > 0 And DashGap > 0 Then
			gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor, DashWidth, DashGap))
		Else
			gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor))
		End If
	End If
	SetNativeBackground(Target, gd)
End Sub

Private Sub CreateSolidDrawable(FillColor As Int, Radius As Float) As JavaObject
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setShape", Array(0)) 'RECTANGLE
	gd.RunMethod("setColor", Array(FillColor))
	gd.RunMethod("setCornerRadius", Array(Radius))
	Return gd
End Sub

Private Sub SetNativeBackground(Target As B4XView, Drawable As JavaObject)
	Dim jo As JavaObject = Target
	jo.RunMethod("setBackground", Array(Drawable))
End Sub
#End If

'========================
' Public API
'========================

Public Sub setWidth(Value As Object)
	mFitContentWidth = False
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Int = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, targetH)
	Base_Resize(mWidth, targetH)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mHeight)
	Base_Resize(targetW, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(Value As String)
	mSize = NormalizeSize(Value)
	If mHeightExplicit = False Then
		Dim sz As Map = ResolveSizeSpec
		mHeight = Max(16dip, sz.GetDefault("height", 24dip))
	End If
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	' Reset manual colors to ensure variant colors take full effect. (Last one wins)
	mBackgroundColor = 0
	mTextColor = 0
	mBorderColor = 0
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setBadgeStyle(Value As String)
	mBadgeStyle = NormalizeBadgeStyle(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBadgeStyle As String
	Return mBadgeStyle
End Sub

Public Sub setStyle(Value As String)
	setBadgeStyle(Value)
End Sub

Public Sub getStyle As String
	Return mBadgeStyle
End Sub

Public Sub setText(Value As String)
	If Value = Null Then Value = ""
	mText = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setTextCentered(Value As Boolean)
	mTextCentered = Value
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getTextCentered As Boolean
	Return mTextCentered
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
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setRounded(Value As String)
	mRounded = NormalizeRounded(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setShadow(Value As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	Return mShadow
End Sub

Public Sub setAvatarVisible(Value As Boolean)
	mAvatarVisible = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarVisible As Boolean
	Return mAvatarVisible
End Sub

Public Sub setAvatarImage(Value As String)
	If Value = Null Then Value = ""
	mAvatarImage = Value.Trim
	If mAvatarImage.Length > 0 Then mAvatarVisible = True
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarImage As String
	Return mAvatarImage
End Sub

Public Sub setAvatarText(Value As String)
	If Value = Null Then Value = ""
	mAvatarText = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarText As String
	Return mAvatarText
End Sub

Public Sub setAvatarPosition(Value As String)
	mAvatarPosition = NormalizeAvatarPosition(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarPosition As String
	Return mAvatarPosition
End Sub

Public Sub setIconAsset(Value As String)
	If Value = Null Then Value = ""
	mIconAsset = Value.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconAsset As String
	Return mIconAsset
End Sub

Public Sub setToggle(Value As Boolean)
	mToggle = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getToggle As Boolean
	Return mToggle
End Sub

Public Sub setChecked(Value As Boolean)
	mChecked = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getChecked As Boolean
	Return mChecked
End Sub

Public Sub setCheckedColor(Value As Int)
	mCheckedColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCheckedColor As Int
	Return mCheckedColor
End Sub

Public Sub setCheckedTextColor(Value As Int)
	mCheckedTextColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCheckedTextColor As Int
	Return mCheckedTextColor
End Sub

Public Sub setId(Value As String)
	If Value = Null Then Value = ""
	mId = Value
End Sub

Public Sub getId As String
	Return mId
End Sub

Public Sub setClosable(Value As Boolean)
	mClosable = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getClosable As Boolean
	Return mClosable
End Sub

Public Sub setCloseIconAsset(Value As String)
	If Value = Null Then Value = ""
	mCloseIconAsset = Value.Trim
	If mCloseIconAsset.Length = 0 Then mCloseIconAsset = "xmark-solid.svg"
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCloseIconAsset As String
	Return mCloseIconAsset
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackgroundColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub



Public Sub setBackgroundColorVariant(VariantName As String)
	Dim xColors As Map = ResolveVisualColors
	Dim fallback As Int = xColors.GetDefault("back", mBackgroundColor)
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, fallback)
	setBackgroundColor(c)
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim xColors As Map = ResolveVisualColors
	Dim fallback As Int = xColors.GetDefault("text", mTextColor)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, fallback)
	setTextColor(c)
End Sub

Public Sub setBorderColor(Value As Int)
	mBorderColor = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setBorderColorVariant(VariantName As String)
	Dim xColors As Map = ResolveVisualColors
	Dim fallback As Int = xColors.GetDefault("border", mBorderColor)
	Dim c As Int = B4XDaisyVariants.ResolveBorderColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, fallback)
	setBorderColor(c)
End Sub



Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
