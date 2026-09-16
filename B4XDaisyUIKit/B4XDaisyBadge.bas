B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)
#Event: CloseClick (Tag As Object)
#Event: Checked (Id As String, Checked As Boolean)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: fit-content, Description: Tailwind size token, CSS size, or fit-content
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-6, Description: Tailwind size token or CSS size (eg h-6, 24px, 1.5rem)
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Badge size token
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant used for colors
#DesignerProperty: Key: BadgeStyle, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost, Description: Badge visual style
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: Badge, Description: Text displayed inside badge
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind spacing utilities (eg px-2, py-1, p-1.5)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind spacing utilities (eg m-1, mx-2)
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide badge view
#DesignerProperty: Key: AvatarVisible, DisplayName: Avatar Visible, FieldType: Boolean, DefaultValue: False, Description: Show avatar inside badge
#DesignerProperty: Key: AvatarImage, DisplayName: Avatar Image, FieldType: String, DefaultValue: mashymain.jpg, Description: Avatar image path from assets or full path
#DesignerProperty: Key: AvatarText, DisplayName: Avatar Text, FieldType: String, DefaultValue:, Description: Avatar placeholder text when image is empty
#DesignerProperty: Key: AvatarPosition, DisplayName: Avatar Position, FieldType: String, DefaultValue: left, List: left|right, Description: Avatar placement relative to text
#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: SVG asset used for left icon
#DesignerProperty: Key: Toggle, DisplayName: Toggle, FieldType: Boolean, DefaultValue: False, Description: Enables checked/unchecked toggle behavior
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False, Description: Current checked state (effective when Toggle is true)
#DesignerProperty: Key: CheckedColor, DisplayName: Checked Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color used when checked (0 uses variant fallback)
#DesignerProperty: Key: CheckedTextColor, DisplayName: Checked Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Text/icon color used when checked (0 uses variant fallback)
#DesignerProperty: Key: Id, DisplayName: Id, FieldType: String, DefaultValue:, Description: Optional chip identifier returned in checked event
#DesignerProperty: Key: Closable, DisplayName: Closable, FieldType: Boolean, DefaultValue: False, Description: Show close icon on the right side
#DesignerProperty: Key: CloseIconAsset, DisplayName: Close Icon Asset, FieldType: String, DefaultValue: xmark-solid.svg, Description: SVG asset used for close icon
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode
#DesignerProperty: Key: CapValue, DisplayName: Cap Value, FieldType: Int, DefaultValue: 99, Description: Numeric cap - values above this display as cap+ (0 disables capping)
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: When False, touch events pass through to parent (useful inside clickable list rows)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override border color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override text color.
#DesignerProperty: Key: TextCentered, DisplayName: Text Centered, FieldType: Boolean, DefaultValue: True, Description: Center text inside badge.

#IgnoreWarnings:12
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
	Private mTextCentered As Boolean = True
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mVisible As Boolean = True
	Private mRounded As String = "theme"
	Private mShadow As String = "none"

	Private mAvatarVisible As Boolean = False
	Private mAvatarImage As String = "mashymain.jpg"
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
	Private mCapValue As Int = 99
	Private mClickable As Boolean = True

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
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
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
	lblText.SetTextAlignment("CENTER", "CENTER")
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

	ApplyDesignerProps(mProps)
	' Apply clickable state to native views
	If mClickable = False Then
		#If B4A
		Dim joClickable As JavaObject = mBase
		joClickable.RunMethod("setClickable", Array(False))
		If Surface.IsInitialized Then
			Dim joS As JavaObject = Surface
			joS.RunMethod("setClickable", Array(False))
		End If
		If CloseHost.IsInitialized Then
			Dim joC As JavaObject = CloseHost
			joC.RunMethod("setClickable", Array(False))
		End If
		#Else If B4J
		mBase.Enabled = False
		If Surface.IsInitialized Then Surface.Enabled = False
		If CloseHost.IsInitialized Then CloseHost.Enabled = False
		#Else If B4i
		mBase.Enabled = False
		If Surface.IsInitialized Then Surface.Enabled = False
		If CloseHost.IsInitialized Then CloseHost.Enabled = False
		#End If
		' Propagate to child components
		If AvatarComp.IsInitialized Then AvatarComp.setClickable(False)
		If LeftIconComp.IsInitialized Then LeftIconComp.setClickable(False)
		If CloseIconComp.IsInitialized Then CloseIconComp.setClickable(False)
	End If
	mBase.Visible = mVisible
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mHeightExplicit = mProps.ContainsKey("Height")
	Dim widthSpec As String = B4XDaisyVariants.GetPropString(mProps, "Width", "fit-content").ToLowerCase.Trim
	If widthSpec = "" Or widthSpec = "fit-content" Or widthSpec = "auto" Then
		mFitContentWidth = True
		mWidthExplicit = False
	Else
		mFitContentWidth = False
		mWidthExplicit = True
		mWidth = Max(24dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", "fit-content"))
	End If
		mHeight = Max(16dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", "h-6"))
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded))

	' Backward compatibility: migrate legacy RoundedBox=True designer prop
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
	        mRounded = "rounded-box"
	    End If
	End If
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mClosable = B4XDaisyVariants.GetPropBool(mProps, "Closable", mClosable)
	mToggle = B4XDaisyVariants.GetPropBool(mProps, "Toggle", mToggle)
	mChecked = B4XDaisyVariants.GetPropBool(mProps, "Checked", mChecked)
	' mOutline = B4XDaisyVariants.GetPropBool(Props, "Outline", False) ' This line was not in the original code, so it's commented out or removed.
	' mSoft = B4XDaisyVariants.GetPropBool(Props, "Soft", False) ' This line was not in the original code, so it's commented out or removed.
	mIconAsset = B4XDaisyVariants.GetPropString(mProps, "IconAsset", mIconAsset)
	mAvatarPosition = B4XDaisyVariants.GetPropString(mProps, "AvatarPosition", mAvatarPosition)
	mAvatarVisible = B4XDaisyVariants.GetPropBool(mProps, "AvatarVisible", mAvatarVisible)
	mAvatarImage = B4XDaisyVariants.GetPropString(mProps, "AvatarImage", mAvatarImage).Trim ' Kept original mAvatarImage as it was not replaced by mAvatarAsset
	mAvatarText = B4XDaisyVariants.GetPropString(mProps, "AvatarText", mAvatarText) ' Kept original mAvatarText as it was not replaced by mAvatarAsset
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mBorderColor)
	' ApplyDesignerSpacing(mPadding, mMargin) ' This line was not in the original code, so it's commented out or removed.

	mBadgeStyle = B4XDaisyVariants.NormalizeBadgeStyle(B4XDaisyVariants.GetPropString(mProps, "BadgeStyle", mBadgeStyle)) ' Moved from earlier in the block
	mTextCentered = B4XDaisyVariants.GetPropBool(mProps, "TextCentered", mTextCentered) ' Moved from earlier in the block
	mCheckedColor = B4XDaisyVariants.GetPropColor(mProps, "CheckedColor", mCheckedColor)
	mCheckedTextColor = B4XDaisyVariants.GetPropColor(mProps, "CheckedTextColor", mCheckedTextColor)
	mId = B4XDaisyVariants.GetPropString(mProps, "ID", mId) ' Kept original
	mCloseIconAsset = B4XDaisyVariants.GetPropString(mProps, "CloseIconAsset", mCloseIconAsset).Trim
	If mCloseIconAsset.Length = 0 Then mCloseIconAsset = "xmark-solid.svg"
	mCapValue = B4XDaisyVariants.GetPropInt(mProps, "CapValue", mCapValue)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)

	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mBorderColor)

	If mHeightExplicit = False Then
		Dim sz As Map = ResolveSizeSpec
		mHeight = Max(16dip, sz.GetDefault("height", 24dip))
	End If
	If mFitContentWidth Then
		mWidth = Max(1dip, EstimatePreferredWidth)
	End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If Surface.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	If mFitContentWidth Then w = Max(w, Max(1dip, EstimatePreferredWidth))
	Dim h As Int = Max(1dip, dHeight)
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
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim targetW As Int = iWidth
	Dim targetH As Int = iHeight
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
	vParent.AddView(mBase, iLeft, iTop, finalW, h)
	Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	' Keep runtime state when view is recreated through DesignerCreateView.
	Dim props As Map
	props.Initialize
	If mFitContentWidth Then
		props.Put("Width", "fit-content")
	Else
		props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	End If
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Size", mSize)
	props.Put("Variant", mVariant)
	props.Put("BadgeStyle", mBadgeStyle)
	props.Put("Text", mText)
	props.Put("TextCentered", mTextCentered)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("Visible", mVisible)
	props.Put("Rounded", mRounded)
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
	props.Put("CapValue", mCapValue)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("BorderColor", mBorderColor)
	Return props
End Sub

Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Return AddToParent(vParent, iLeft, iTop, iWidth, iHeight)
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

Private Sub ResolveContentLocalRect(rcOuterRect As B4XRect, mBox As Map) As B4XRect
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(rcOuterRect, mBox)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, mBox)
	Return B4XDaisyBoxModel.ToLocalRect(contentAbs, rcOuterRect)
End Sub

Private Sub ResolveSizeSpec As Map
	Dim key As String = B4XDaisyVariants.NormalizeSize(mSize)
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

Private Sub LayoutContent(rcContentRect As B4XRect)
	Dim sizeMap As Map = ResolveSizeSpec
	Dim xColors As Map = ResolveVisualColors
	Dim textColor As Int = xColors.Get("text")
	Dim textValue As String = ResolveDisplayText

	Dim gap As Int = 8dip
	Dim avatarSize As Int = Max(10dip, sizeMap.GetDefault("avatar", 14dip))
	Dim iconSize As Int = Max(8dip, sizeMap.GetDefault("icon", 11dip))
	Dim closeSize As Int = Max(8dip, sizeMap.GetDefault("close", 11dip))
	Dim fontSize As Float = Max(9, sizeMap.GetDefault("font", 14))

	lblText.Font = xui.CreateDefaultFont(fontSize)
	lblText.Text = textValue
	lblText.TextColor = textColor
	lblText.SetTextAlignment("CENTER", "LEFT")

	Dim leftX As Int = rcContentRect.Left
	Dim rightX As Int = rcContentRect.Right
	Dim centerY As Int = rcContentRect.Top + (rcContentRect.Height / 2)

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
	Dim textH As Int = Max(1dip, rcContentRect.Height)
	lblText.SetLayoutAnimated(0, leftX, centerY - (textH / 2), textW, textH)
End Sub

Private Sub ConfigureAvatar(iAvatarSize As Int)
	If AvatarComp.IsInitialized = False Then Return
	AvatarComp.setVariant(mVariant)
	AvatarComp.setShadow("none")
	AvatarComp.setAvatarMask("circle")
	AvatarComp.setAvatarSize(B4XDaisyVariants.ResolvePxSizeSpec(iAvatarSize))
	If mAvatarImage.Length > 0 Then
		AvatarComp.setAvatarType("image")
		AvatarComp.setAvatar(mAvatarImage)
	Else
		AvatarComp.setAvatarType("text")
		AvatarComp.setAvatar("")
		AvatarComp.setPlaceHolder(mAvatarText)
	End If
	If AvatarView.IsInitialized Then AvatarComp.ResizeToParent(AvatarView)
End Sub

Private Sub ConfigureLeftIcon(iIconSize As Int, iIconColor As Int, sAsset As String)
	If LeftIconComp.IsInitialized = False Then Return
	Dim iconAsset As String = IIf(sAsset = Null, "", sAsset.Trim)
	If iconAsset.Length = 0 Then Return
	LeftIconComp.setSvgAsset(iconAsset)
	LeftIconComp.setPreserveOriginalColors(False)
	LeftIconComp.setColor(iIconColor)
	LeftIconComp.setSize(B4XDaisyVariants.ResolvePxSizeSpec(iIconSize))
	LeftIconComp.ResizeToParent(LeftIconView)
End Sub

Private Sub ConfigureCloseIcon(iIconSize As Int, iIconColor As Int)
	If CloseIconComp.IsInitialized = False Then Return
	Dim iconAsset As String = IIf(mCloseIconAsset = Null, "", mCloseIconAsset.Trim)
	If iconAsset.Length = 0 Then iconAsset = "xmark-solid.svg"
	CloseIconComp.setSvgAsset(iconAsset)
	CloseIconComp.setPreserveOriginalColors(False)
	CloseIconComp.setColor(iIconColor)
	CloseIconComp.setSize(B4XDaisyVariants.ResolvePxSizeSpec(iIconSize))
	CloseIconView.Visible = True
	CloseIconView.SetLayoutAnimated(0, 2dip, 2dip, Max(1dip, CloseHost.Width - 4dip), Max(1dip, CloseHost.Height - 4dip))
	CloseIconComp.ResizeToParent(CloseIconView)
End Sub

Private Sub ApplyVisualStyle(mBox As Map)
	If Surface.IsInitialized = False Then Return
	Dim xColors As Map = ResolveVisualColors
	Dim bg As Int = xColors.Get("back")
	Dim border As Int = xColors.Get("border")
	Dim bw As Int = Max(0, mBox.GetDefault("border_width", 0))
	Dim radius As Float = Max(0, mBox.GetDefault("radius", 0))
	B4XDaisyVariants.ApplyDashedBorder(Surface, bg, bw, border, radius, mBadgeStyle)
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
	B4XDaisyVariants.ApplyElevation(Surface, mShadow)
End Sub

Private Sub EstimatePreferredWidth As Int
	' Empty badge = perfect circle: width must equal height so radius=height/2 gives a circle.
	If IsEmptyBadge Then Return Max(16dip, mHeight)
	Dim sizeMap As Map = ResolveSizeSpec
	Dim f As Float = Max(9, sizeMap.GetDefault("font", 14))
	Dim gap As Int = 8dip
	Dim textW As Int = MeasureSingleLineWidth(ResolveDisplayText, f)
	Dim avatarW As Int = IIf(mAvatarVisible, Max(10dip, sizeMap.GetDefault("avatar", 14dip)) + gap, 0)
	Dim hasLeftIcon As Boolean = (mIconAsset.Length > 0) Or (mToggle And mChecked)
	Dim iconW As Int = IIf(hasLeftIcon, Max(8dip, sizeMap.GetDefault("icon", 11dip)) + gap, 0)
	Dim hasRightIcon As Boolean = (mToggle = False) And mClosable
	Dim rightIconW As Int = IIf(hasRightIcon, Max(8dip, sizeMap.GetDefault("close", 11dip)) + 4dip + gap, 0)
	Dim contentW As Int = Max(0, textW + avatarW + iconW + rightIconW)
	Dim box As Map = BuildBoxModel
	Return Max(1dip, Ceil(B4XDaisyBoxModel.ExpandContentWidth(contentW, box)))
End Sub

Private Sub MeasureSingleLineWidth(sText As String, fFontSize As Float) As Int
	If sText.Length = 0 Then Return 0
	If lblText.IsInitialized Then
		Try
			Dim l As Label = lblText
			Dim c As Canvas
			c.Initialize(l)
			Dim w As Float = c.MeasureStringWidth(sText, l.Typeface, fFontSize)
			Return Max(1dip, Ceil(w) + 2dip)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyBadge.MeasureSingleLineWidth: " & LastException.Message)
		End Try 'ignore
	End If
	' Fallback used before views are attached (e.g. AddToParent pre-creation path).
	Return Max(1dip, Ceil(sText.Length * fFontSize * 0.62) + 2dip)
End Sub


Private Sub ResolveBadgeRadiusDip(fSizeDip As Float) As Float
	Dim mode As String = B4XDaisyVariants.NormalizeRounded(mRounded)
	If mode = "theme" Then
		If mRounded = "rounded-none" Or (mRounded <> "rounded-box" And mRounded <> "theme") Then Return 0
		If IsEmptyBadge Then Return fSizeDip / 2
		Return B4XDaisyVariants.GetRadiusSelectorDip(4dip)
	End If
	Select Case mode
		Case "rounded-none"
			Return 0
		Case "rounded-sm"
			Return Min(fSizeDip / 2, 2dip)
		Case "rounded"
			Return Min(fSizeDip / 2, 4dip)
		Case "rounded-md"
			Return Min(fSizeDip / 2, 6dip)
		Case "rounded-lg"
			Return Min(fSizeDip / 2, 8dip)
		Case "rounded-xl"
			Return Min(fSizeDip / 2, 12dip)
		Case "rounded-2xl"
			Return Min(fSizeDip / 2, 16dip)
		Case "rounded-3xl"
			Return Min(fSizeDip / 2, 24dip)
		Case "rounded-full"
			Return fSizeDip / 2
		Case Else
			Return B4XDaisyVariants.GetRadiusSelectorDip(4dip)
	End Select
End Sub

Private Sub IsEmptyBadge As Boolean
	If mAvatarVisible Then Return False
	If mIconAsset.Trim.Length > 0 Then Return False
	If mClosable Then Return False
	If mToggle And mChecked Then Return False
	If B4XDaisyVariants.NormalizeSingleLineText(mText).Length > 0 Then Return False
	Return True
End Sub








Private Sub ResolveDisplayText As String
	Dim raw As String = B4XDaisyVariants.NormalizeSingleLineText(mText)
	If mCapValue <= 0 Then Return raw
	If raw.Length = 0 Then Return raw
	If IsNumber(raw) Then
		Dim n As Double = raw
		If n >= mCapValue + 1 Then
			Return mCapValue & "+"
		End If
	End If
	Return raw
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
	If mClickable = False Then Return
	If mToggle Then
		ToggleCheckedFromInteraction
	Else If mClosable Then
		HandleCloseTap
	Else
		RaiseClick
	End If
End Sub

Private Sub closebtn_Click
	If mClickable = False Then Return
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

'-
' Public API
'-

Public Sub setWidth(oValue As Object)
	mFitContentWidth = False
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Int = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, targetH)
	Base_Resize(mWidth, targetH)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(oValue As Object)
	mHeight = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mHeight)
	Base_Resize(targetW, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
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

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
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

Public Sub setBadgeStyle(sValue As String)
	mBadgeStyle = B4XDaisyVariants.NormalizeStyle(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBadgeStyle As String
	Return mBadgeStyle
End Sub

Public Sub setStyle(sValue As String)
	setBadgeStyle(sValue)
End Sub

Public Sub getStyle As String
	Return mBadgeStyle
End Sub

Public Sub setText(sValue As String)
	If sValue = Null Then sValue = ""
	mText = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setTextCentered(bValue As Boolean)
	mTextCentered = bValue
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getTextCentered As Boolean
	Return mTextCentered
End Sub

Public Sub setPadding(sValue As String)
	mPadding = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	mMargin = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setRounded(sValue As String)
	mRounded = B4XDaisyVariants.NormalizeRounded(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setShadow(sValue As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	Return mShadow
End Sub

Public Sub setAvatarVisible(bValue As Boolean)
	mAvatarVisible = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarVisible As Boolean
	Return mAvatarVisible
End Sub

Public Sub setAvatarImage(sValue As String)
	If sValue = Null Then sValue = ""
	mAvatarImage = sValue.Trim
	If mAvatarImage.Length > 0 Then mAvatarVisible = True
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarImage As String
	Return mAvatarImage
End Sub

Public Sub setAvatarText(sValue As String)
	If sValue = Null Then sValue = ""
	mAvatarText = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarText As String
	Return mAvatarText
End Sub

Public Sub setAvatarPosition(sValue As String)
	mAvatarPosition = B4XDaisyVariants.NormalizeAvatarPosition(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAvatarPosition As String
	Return mAvatarPosition
End Sub

Public Sub setIconAsset(sValue As String)
	If sValue = Null Then sValue = ""
	mIconAsset = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getIconAsset As String
	Return mIconAsset
End Sub

Public Sub setToggle(bValue As Boolean)
	mToggle = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getToggle As Boolean
	Return mToggle
End Sub

Public Sub setChecked(bValue As Boolean)
	mChecked = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getChecked As Boolean
	Return mChecked
End Sub

Public Sub setCheckedColor(iValue As Int)
	mCheckedColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCheckedColor As Int
	Return mCheckedColor
End Sub

Public Sub setCheckedTextColor(iValue As Int)
	mCheckedTextColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCheckedTextColor As Int
	Return mCheckedTextColor
End Sub

Public Sub setId(sValue As String)
	If sValue = Null Then sValue = ""
	mId = sValue
End Sub

Public Sub getId As String
	Return mId
End Sub

Public Sub setClosable(bValue As Boolean)
	mClosable = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getClosable As Boolean
	Return mClosable
End Sub

Public Sub setCloseIconAsset(sValue As String)
	If sValue = Null Then sValue = ""
	mCloseIconAsset = sValue.Trim
	If mCloseIconAsset.Length = 0 Then mCloseIconAsset = "xmark-solid.svg"
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCloseIconAsset As String
	Return mCloseIconAsset
End Sub


Public Sub setCapValue(iValue As Int)
	mCapValue = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCapValue As Int
	Return mCapValue
End Sub

Public Sub setValue(oValue As Object)
	If oValue = Null Then oValue = ""
	mText = "" & oValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getValue As String
	Return mText
End Sub

' Increment the badge value by 1. Only works when mText is a valid integer.
Public Sub increment As Int
	Return incrementBy(1)
End Sub

' Increment the badge value by the given amount. Only works when mText is a valid integer.
Public Sub incrementBy(iAmount As Int) As Int
	Dim s As String = mText.Trim
	If IsNumber(s) Then
		Dim n As Int = s
		n = n + iAmount
		mText = "" & n
		If mBase.IsInitialized Then Refresh
		Return n
	End If
	Return 0
End Sub

' Decrement the badge value by 1 (minimum 0). Only works when mText is a valid integer.
Public Sub decrement As Int
	Return decrementBy(1)
End Sub

' Decrement the badge value by the given amount (minimum 0). Only works when mText is a valid integer.
Public Sub decrementBy(iAmount As Int) As Int
	Dim s As String = mText.Trim
	If IsNumber(s) Then
		Dim n As Int = s
		n = n - iAmount
		If n < 0 Then n = 0
		mText = "" & n
		If mBase.IsInitialized Then Refresh
		Return n
	End If
	Return 0
End Sub
Public Sub setBackgroundColor(iValue As Int)
	mBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub


Public Sub setBackgroundColorVariant(sVariantName As String)
	Dim xColors As Map = ResolveVisualColors
	Dim fallback As Int = xColors.GetDefault("back", mBackgroundColor)
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, fallback)
	setBackgroundColor(c)
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	Dim xColors As Map = ResolveVisualColors
	Dim fallback As Int = xColors.GetDefault("text", mTextColor)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, fallback)
	setTextColor(c)
End Sub

Public Sub setBorderColor(iValue As Int)
	mBorderColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setBorderColorVariant(sVariantName As String)
	Dim xColors As Map = ResolveVisualColors
	Dim fallback As Int = xColors.GetDefault("border", mBorderColor)
	Dim c As Int = B4XDaisyVariants.ResolveBorderColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, fallback)
	setBorderColor(c)
End Sub



Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' Sets whether the badge intercepts touch events.
''' When False, touches pass through to the parent view (e.g. a list row).
''' When True, the badge handles clicks normally via the Click event.
Public Sub setClickable(bValue As Boolean)
	mClickable = bValue
	#If B4A
	If mBase.IsInitialized Then
		Dim joBase As JavaObject = mBase
		joBase.RunMethod("setClickable", Array(bValue))
		If Surface.IsInitialized Then
			Dim joS As JavaObject = Surface
			joS.RunMethod("setClickable", Array(bValue))
		End If
		If CloseHost.IsInitialized Then
			Dim joC As JavaObject = CloseHost
			joC.RunMethod("setClickable", Array(bValue))
		End If
	End If
	#Else If B4J
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If Surface.IsInitialized Then Surface.Enabled = bValue
		If CloseHost.IsInitialized Then CloseHost.Enabled = bValue
	End If
	#Else If B4i
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If Surface.IsInitialized Then Surface.Enabled = bValue
		If CloseHost.IsInitialized Then CloseHost.Enabled = bValue
	End If
	#End If
	' Propagate to child components
	If AvatarComp.IsInitialized Then AvatarComp.setClickable(bValue)
	If LeftIconComp.IsInitialized Then LeftIconComp.setClickable(bValue)
	If CloseIconComp.IsInitialized Then CloseIconComp.setClickable(bValue)
End Sub

''' Gets whether the badge is clickable.
Public Sub getClickable As Boolean
	Return mClickable
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Release
    If lblText.IsInitialized Then lblText.RemoveViewFromParent
    mCallBack = Null
End Sub