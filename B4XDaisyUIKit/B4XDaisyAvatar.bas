B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click

#DesignerProperty: Key: Image, DisplayName: Image Path, FieldType: String, DefaultValue:mashymain.jpg, Description: Full image path on device
#DesignerProperty: Key: Mask, DisplayName: Mask, FieldType: String, DefaultValue: circle, List: circle|square|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2, Description: Avatar mask shape
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-full, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius token.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level (Tailwind/Daisy scale)
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Variant used for placeholder and status colors
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-10, Description: Tailwind size token or CSS size (eg w-12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-10, Description: Tailwind size token or CSS size (eg h-12, 80px, 4em, 5rem)
#DesignerProperty: Key: AvatarType, DisplayName: Avatar Type, FieldType: String, DefaultValue: image, List: image|svg|text, Description: Content type rendered inside avatar
#DesignerProperty: Key: PlaceHolder, DisplayName: Placeholder, FieldType: String, DefaultValue:, Description: Placeholder text for text type (and image/svg fallback)
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, Description: Placeholder text size token (eg text-sm, text-lg). Empty = auto-fit
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
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: When False, touch events pass through to parent (useful inside clickable list rows)
#DesignerProperty: Key: ResizeMode, DisplayName: Resize Mode, FieldType: String, DefaultValue: FILL_NO_DISTORTIONS, List: FIT|FILL|FILL_NO_DISTORTIONS|NONE, Description: Aspect scaling mode (similar to B4XImageView ResizeMode)
#DesignerProperty: Key: BlurRadius, DisplayName: Blur Radius, FieldType: Int, DefaultValue: 0, Description: Image blur level (0 = disabled, 1 to 25 = scale-down blur factor)
#DesignerProperty: Key: Glass, DisplayName: Glass Effect, FieldType: Boolean, DefaultValue: False, Description: Enable translucent glass shine and highlight borders

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private msVariant As String = "none"

	Private mWidth As Float = 40dip
	Private mHeight As Float = 40dip
	Private mWidthToken As String = "w-10"
	Private mHeightToken As String = "h-10"
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private msAvatarType As String = "image"
	Private PlaceholderText As String = ""
	Private PlaceholderTextSize As String = "text-sm"
	Private PlaceholderTextColor As Int = 0
	Private PlaceholderBackgroundColor As Int = 0
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mbCenterOnParent As Boolean = True
	Private mbChatImage As Boolean = False
	Private AvatarMask As String = "circle"
	Private mRounded As String = "rounded-full"
	Private AvatarPath As String = "mashymain.jpg"
	Private AvatarBmp As B4XBitmap
	Private AvatarTag As Object

	Private AvatarStatus As String = "none" 'none|online|offline
	Private OnlineIndicatorVisible As Boolean = False
	Private mbUseVariantStatusColors As Boolean = False
	Private AvatarOnlineColor As Int = 0xFF2ECC71
	Private AvatarOfflineColor As Int = 0xFFB4B4B4
	Private CustomOnlineColor As Int = 0
	Private CustomOfflineColor As Int = 0

	Private AvatarBorderColor As Int = 0
	Private AvatarBorderWidth As Float = 0dip
	Private mcRingColor As Int = 0
	Private mfRingOffset As Float = 0dip
	Private mClickable As Boolean = True
	Private msShadow As String = "none"

	Private msResizeMode As String = "FILL_NO_DISTORTIONS"
	Private miBlurRadius As Int = 0
	Private mbGlass As Boolean = False

	Private VariantPalette As Map
	Private DefaultVariantPalette As Map

	Private ivAvatar As B4XView
	Private AvatarCvs As B4XCanvas
	Private AvatarCanvasReady As Boolean = False
	Private LastUpscaleWarningKey As String = ""
	Private mImage As B4XDaisyImage
	Private ivIndicator As Panel
	Private IndicatorCvs As B4XCanvas
	Private IndicatorCvsReady As Boolean = False
	Private inResize As Boolean = False
	Private MaskBitmapCache As Map
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	InitializePalette
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
Public Sub GetActualHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub GetActualWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub AddViewToContent(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And ivAvatar.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	InitializePalette
	ApplyDesignerProps(mProps)

	Dim pAvatar As Panel
	pAvatar.Initialize("ivAvatar")
	ivAvatar = pAvatar
	ivAvatar.Color = xui.Color_Transparent
	mBase.AddView(ivAvatar, 0, 0, mWidth, mHeight)

	mImage.Initialize(Me, "mImage")
	mImage.AddToParent(ivAvatar, 0, 0, ivAvatar.Width, ivAvatar.Height)
	mImage.mBase.Visible = False

	' Overlay panel for the online/offline indicator - always above mImage
	ivIndicator.Initialize("")
	Dim ivInd As B4XView = ivIndicator
	ivInd.Color = xui.Color_Transparent
	ivAvatar.AddView(ivInd, 0, 0, ivAvatar.Width, ivAvatar.Height)
	ivInd.BringToFront
	' Apply clickable state to native views
	If mClickable = False Then
		#If B4A
		Dim joBase2 As JavaObject = mBase
		joBase2.RunMethod("setClickable", Array(False))
		If ivAvatar.IsInitialized Then
			Dim joIv2 As JavaObject = ivAvatar
			joIv2.RunMethod("setClickable", Array(False))
		End If
		#Else If B4J
		mBase.Enabled = False
		If ivAvatar.IsInitialized Then ivAvatar.Enabled = False
		#Else If B4i
		mBase.Enabled = False
		If ivAvatar.IsInitialized Then ivAvatar.Enabled = False
		#End If
	End If
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or ivAvatar.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)

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
	If mbCenterOnParent Then
		x = contentRect.Left + (availW - drawW) / 2
		y = contentRect.Top + (availH - drawH) / 2
	End If
	ivAvatar.SetLayoutAnimated(0, x, y, drawW, drawH)
	DrawAvatar
	inResize = False
End Sub

'Convenience helper: resize avatar internals to match a parent view size.
Public Sub ResizeToParent(vB4xV As B4XView)
	If vB4xV.IsInitialized = False Then Return
	Base_Resize(vB4xV.Width, vB4xV.Height)
End Sub







Private Sub ApplyDesignerProps(mProps As Map)
	setVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
	setShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))

	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", "w-10"))
	mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", "h-10"))
	mWidthExplicit = mProps.IsInitialized And mProps.ContainsKey("Width")
	mHeightExplicit = mProps.IsInitialized And mProps.ContainsKey("Height")
	'mPlaceholderAutoColor = B4XDaisyVariants.GetPropBool(Props, "PlaceholderAutoColor", True) ' Not used in this class
	'mRadius = Max(0dip, B4XDaisyVariants.GetPropFloat(Props, "Radius", 0) * 1dip) ' Not used in this class

	msAvatarType = NormalizeAvatarType(B4XDaisyVariants.GetPropString(mProps, "AvatarType", msAvatarType))
	PlaceholderText = B4XDaisyVariants.GetPropString(mProps, "PlaceHolder", PlaceholderText)
	Dim tsVal As String = B4XDaisyVariants.GetPropString(mProps, "TextSize", PlaceholderTextSize)
	If tsVal.Length > 0 Then PlaceholderTextSize = tsVal
	PlaceholderTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", PlaceholderTextColor)
	PlaceholderBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", PlaceholderBackgroundColor)
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mbCenterOnParent = B4XDaisyVariants.GetPropBool(mProps, "CenterOnParent", mbCenterOnParent)
	mbChatImage = B4XDaisyVariants.GetPropBool(mProps, "ChatImage", mbChatImage)
	'Compatibility aliases (older key names).
	If mProps.ContainsKey("AvatarWidth") Then mWidthExplicit = True
	If mProps.ContainsKey("AvatarHeight") Then mHeightExplicit = True
	If mProps.ContainsKey("AvatarSize") Then
		mWidthExplicit = True
		mHeightExplicit = True
	End If

	setAvatarMask(B4XDaisyVariants.GetPropString(mProps, "Mask", B4XDaisyVariants.GetPropString(mProps, "AvatarMask", AvatarMask)))
	mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)

	' Backward compatibility: migrate legacy RoundedBox=True
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
	        mRounded = "rounded-box"
	    End If
	End If
	setAvatarStatus(B4XDaisyVariants.GetPropString(mProps, "Status", AvatarStatus))
	setShowOnline(B4XDaisyVariants.GetPropBool(mProps, "ShowOnline", OnlineIndicatorVisible))
	mbUseVariantStatusColors = B4XDaisyVariants.GetPropBool(mProps, "UseVariantStatusColors", mbUseVariantStatusColors)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)

	CustomOnlineColor = B4XDaisyVariants.GetPropColor(mProps, "OnlineColor", CustomOnlineColor)
	CustomOfflineColor = B4XDaisyVariants.GetPropColor(mProps, "OfflineColor", CustomOfflineColor)
	If CustomOnlineColor <> 0 Then AvatarOnlineColor = CustomOnlineColor
	If CustomOfflineColor <> 0 Then AvatarOfflineColor = CustomOfflineColor
	mcRingColor = B4XDaisyVariants.GetPropColor(mProps, "RingColor", mcRingColor)
	AvatarBorderWidth = Max(0, B4XDaisyVariants.GetPropDip(mProps, "RingWidth", AvatarBorderWidth))
	mfRingOffset = Max(0, B4XDaisyVariants.GetPropDip(mProps, "RingOffset", mfRingOffset))
	'Compatibility with earlier internal naming.
	If mProps.ContainsKey("AvatarBorderWidth") Then AvatarBorderWidth = Max(0, B4XDaisyVariants.GetPropDip(mProps, "AvatarBorderWidth", AvatarBorderWidth))
	If mProps.ContainsKey("AvatarBorderInset") Then mfRingOffset = Max(0, B4XDaisyVariants.GetPropDip(mProps, "AvatarBorderInset", mfRingOffset))

	setAvatar(B4XDaisyVariants.GetPropString(mProps, "Image", B4XDaisyVariants.GetPropString(mProps, "Avatar", AvatarPath)))
	msResizeMode = B4XDaisyVariants.GetPropString(mProps, "ResizeMode", msResizeMode)
	If msResizeMode.Trim = "" Then msResizeMode = "FILL_NO_DISTORTIONS"
	miBlurRadius = B4XDaisyVariants.GetPropInt(mProps, "BlurRadius", miBlurRadius)
	mbGlass = B4XDaisyVariants.GetPropBool(mProps, "Glass", mbGlass)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Image", AvatarPath)
	props.Put("Variant", msVariant)
	props.Put("Shadow", msShadow)
	props.Put("AvatarType", msAvatarType)
	props.Put("PlaceHolder", PlaceholderText)
	props.Put("TextSize", PlaceholderTextSize)
	props.Put("TextColor", PlaceholderTextColor)
	props.Put("BackgroundColor", PlaceholderBackgroundColor)
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("CenterOnParent", mbCenterOnParent)
	props.Put("ChatImage", mbChatImage)
	props.Put("Mask", AvatarMask)
	props.Put("Rounded", mRounded)
	props.Put("Status", AvatarStatus)
	props.Put("ShowOnline", OnlineIndicatorVisible)
	Return props
End Sub







Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, mPadding, mMargin)
	Return box
End Sub

Private Sub ApplySpacingSpecToBox(mBox As Map, sPaddingSpec As String, sMarginSpec As String)
	Dim rtl As Boolean = False
	Dim p As String = ""
	If sPaddingSpec <> Null Then p = sPaddingSpec.Trim
	Dim m As String = ""
	If sMarginSpec <> Null Then m = sMarginSpec.Trim
	If p.Length > 0 Then
		If p.Contains("-") Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(mBox, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			mBox.Put("padding_left", pv)
			mBox.Put("padding_top", pv)
			mBox.Put("padding_right", pv)
			mBox.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If m.Contains("-") Then
			B4XDaisyBoxModel.ApplyMarginUtilities(mBox, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			mBox.Put("margin_left", mv)
			mBox.Put("margin_top", mv)
			mBox.Put("margin_right", mv)
			mBox.Put("margin_bottom", mv)
		End If
	End If
End Sub





Public Sub setVariant(sValue As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	' Reset manual overrides to ensure variant colors take full effect.
	PlaceholderBackgroundColor = 0
	PlaceholderTextColor = 0
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getVariant As String
	Return msVariant
End Sub

Public Sub setShadow(sValue As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setResizeMode(sValue As String)
	If sValue = Null Or sValue.Trim = "" Then sValue = "FILL_NO_DISTORTIONS"
	msResizeMode = sValue.ToUpperCase.Trim
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getResizeMode As String
	Return msResizeMode
End Sub

Public Sub setBlurRadius(iValue As Int)
	miBlurRadius = iValue
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getBlurRadius As Int
	Return miBlurRadius
End Sub

Public Sub setGlass(bValue As Boolean)
	mbGlass = bValue
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getGlass As Boolean
	Return mbGlass
End Sub

Public Sub setChatImage(bValue As Boolean)
	mbChatImage = bValue
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getChatImage As Boolean
	Return mbChatImage
End Sub

Public Sub setVariantPalette(mPalette As Map)
	If mPalette.IsInitialized Then
		VariantPalette = mPalette
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

Public Sub setUseVariantStatusColors(bEnabled As Boolean)
	mbUseVariantStatusColors = bEnabled
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getUseVariantStatusColors As Boolean
	Return mbUseVariantStatusColors
End Sub

Public Sub setAvatar(sPath As String)
	Dim empty As B4XBitmap
	If sPath = Null Then
		AvatarPath = ""
		AvatarBmp = empty
		LastUpscaleWarningKey = ""
		If ivAvatar.IsInitialized Then DrawAvatar
		Return
	End If
	AvatarPath = sPath.Trim
	If AvatarPath.Length = 0 Then
		AvatarBmp = empty
		LastUpscaleWarningKey = ""
		If ivAvatar.IsInitialized Then DrawAvatar
		Return
	End If
	Try
		Dim resolved As String = B4XDaisyVariants.ResolveAssetImage(AvatarPath, "")
		If resolved.Length > 0 Then
			AvatarBmp = xui.LoadBitmap(File.DirAssets, resolved)
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

Public Sub setImage(sPath As String)
	If sPath = Null Then
		AvatarPath = ""
	Else
		AvatarPath = sPath.Trim
	End If
	If mBase.IsInitialized = False Then Return
	setAvatar(AvatarPath)
End Sub

Public Sub getImage As String
	Return AvatarPath
End Sub

Public Sub setMask(sValue As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(sValue)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getMask As String
	Return getAvatarMask
End Sub

Public Sub setAvatarBitmap(bmpBmp As B4XBitmap, oTag As Object)
	AvatarBmp = bmpBmp
	AvatarTag = oTag
	AvatarPath = ""
	LastUpscaleWarningKey = ""
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarTag As Object
	Return AvatarTag
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setAvatarStatus(sMode As String)
	If sMode = Null Then sMode = "none"
	Dim m As String = sMode.ToLowerCase
	If m <> "online" And m <> "offline" Then m = "none"
	AvatarStatus = m
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setStatus(sMode As String)
	If sMode = Null Then sMode = "none"
	Dim m As String = sMode.ToLowerCase
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

Public Sub setAvatarStatusColors(iOnlineColor As Int, iOfflineColor As Int)
	If iOnlineColor <> 0 Then
		CustomOnlineColor = iOnlineColor
		AvatarOnlineColor = iOnlineColor
	End If
	If iOfflineColor <> 0 Then
		CustomOfflineColor = iOfflineColor
		AvatarOfflineColor = iOfflineColor
	End If
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

'Helper for online-only status color updates without touching offline color.
Public Sub setAvatarOnlineColor(iOnlineColor As Int)
	If iOnlineColor = 0 Then Return
	CustomOnlineColor = iOnlineColor
	AvatarOnlineColor = iOnlineColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getOnlineColor As Int
	Return ResolveOnlineColor
End Sub

Public Sub setOfflineColor(iOfflineColor As Int)
	If iOfflineColor = 0 Then Return
	CustomOfflineColor = iOfflineColor
	AvatarOfflineColor = iOfflineColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getOfflineColor As Int
	Return ResolveOfflineColor
End Sub

Public Sub setAvatarOnlineColorVariant(sVariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveOnlineColor(sVariantName, ResolveOnlineColor)
	setAvatarOnlineColor(c)
End Sub

'Short alias for setAvatarOnlineColor.
Public Sub setOnlineColor(iOnlineColor As Int)
	If iOnlineColor = 0 Then Return
	CustomOnlineColor = iOnlineColor
	AvatarOnlineColor = iOnlineColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setOnlineColorVariant(sVariantName As String)
	setAvatarOnlineColorVariant(sVariantName)
End Sub

Public Sub getAvatarOnlineColor As Int
	Return ResolveOnlineColor
End Sub

Public Sub getAvatarOfflineColor As Int
	Return ResolveOfflineColor
End Sub

Public Sub setShowOnline(bShow As Boolean)
	OnlineIndicatorVisible = bShow
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getShowOnline As Boolean
	Return OnlineIndicatorVisible
End Sub

Public Sub setAvatarType(sValue As String)
	msAvatarType = NormalizeAvatarType(sValue)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarType As String
	Return msAvatarType
End Sub

Public Sub setPlaceHolder(sValue As String)
	If sValue = Null Then sValue = ""
	PlaceholderText = sValue
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getPlaceHolder As String
	Return PlaceholderText
End Sub

Public Sub setTextColor(iValue As Int)
	PlaceholderTextColor = iValue
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getTextColor As Int
	Return PlaceholderTextColor
End Sub

Public Sub setTextSize(sValue As String)
	If sValue = Null Then sValue = ""
	PlaceholderTextSize = sValue.Trim
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getTextSize As String
	Return PlaceholderTextSize
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(ActivePalette, sVariantName, PlaceholderTextColor)
	setTextColor(c)
End Sub

Public Sub setBackgroundColor(iValue As Int)
	PlaceholderBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getBackgroundColor As Int
	Return PlaceholderBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
	InitializePalette
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(ActivePalette, sVariantName, PlaceholderBackgroundColor)
	setBackgroundColor(c)
End Sub

Public Sub setAvatarMask(sMaskName As String)
	AvatarMask = B4XDaisyVariants.NormalizeMask(sMaskName)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getAvatarMask As String
	Return AvatarMask
End Sub

Public Sub setRounded(sValue As String)
	mRounded = IIf(sValue = Null, "rounded-full", sValue.ToLowerCase.Trim)
	If ivAvatar.IsInitialized Then DrawAvatar
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

Public Sub setGlobalMask(sMaskName As String)
	setAvatarMask(sMaskName)
End Sub

Public Sub setAvatarSize(oSize As Object)
	If oSize <> Null Then
		mWidthToken = oSize
		mHeightToken = oSize
	End If
	Dim v As Float
	If IsNumber(oSize) And (Not(oSize Is String)) Then
		v = oSize
	Else
		v = B4XDaisyVariants.TailwindSizeToDip(oSize, Min(mWidth, mHeight))
	End If
	mWidth = Max(16dip, v)
	mHeight = Max(16dip, v)

	mWidthExplicit = True
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setWidth(oValue As Object)
	If oValue <> Null Then mWidthToken = oValue
	Dim v As Float
	If IsNumber(oValue) And (Not(oValue Is String)) Then
		v = oValue
	Else
		v = B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth))
	End If
	mWidth = Max(16dip, v)

	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	ApplyRuntimeHostSize
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setHeight(oValue As Object)
	If oValue <> Null Then mHeightToken = oValue
	Dim v As Float
	If IsNumber(oValue) And (Not(oValue Is String)) Then
		v = oValue
	Else
		v = B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight))
	End If
	mHeight = Max(16dip, v)

	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	ApplyRuntimeHostSize
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setPadding(sValue As String)
	If sValue = Null Then mPadding = "" Else mPadding = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	If sValue = Null Then mMargin = "" Else mMargin = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setCenterOnParent(bValue As Boolean)
	mbCenterOnParent = bValue
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getCenterOnParent As Boolean
	Return mbCenterOnParent
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

'Compatibility wrappers for previous API names.
Public Sub setAvatarWidth(oValue As Object)
	setWidth(oValue)
End Sub

Public Sub setAvatarHeight(oValue As Object)
	setHeight(oValue)
End Sub

Public Sub getAvatarWidth As Float
	Return getWidth
End Sub

Public Sub getAvatarHeight As Float
	Return getHeight
End Sub

Private Sub ApplyRuntimeHostSize
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(1dip, mBase.Width)
	Dim targetH As Int = Max(1dip, mBase.Height)
	If mWidthExplicit Then targetW = Max(1dip, Round(mWidth))
	If mHeightExplicit Then targetH = Max(1dip, Round(mHeight))
	If targetW <> mBase.Width Or targetH <> mBase.Height Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
	End If
End Sub

Public Sub setAvatarBorder(iColor As Int, fWidth As Float)
	AvatarBorderColor = iColor
	AvatarBorderWidth = Max(0, fWidth)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setAvatarBorderInset(fInset As Float)
	setRingOffset(fInset)
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub setRingColor(iColor As Int)
	mcRingColor = iColor
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingColor As Int
	Return mcRingColor
End Sub

'Convenience API: pass a Daisy variant token (eg "primary") for ring color.
Public Sub setRingColorVariant(sVariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, sVariantName, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, sVariantName, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, sVariantName, "muted", AvatarBorderColor)
	setRingColor(c)
End Sub

Public Sub setRingWidth(fWidth As Float)
	AvatarBorderWidth = Max(0, fWidth)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingWidth As Float
	Return AvatarBorderWidth
End Sub

Public Sub setRingOffset(fOffset As Float)
	mfRingOffset = Max(0, fOffset)
	If mBase.IsInitialized = False Then Return
	If ivAvatar.IsInitialized Then DrawAvatar
End Sub

Public Sub getRingOffset As Float
	Return mfRingOffset
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
	Dim c As Int = 0
	If mbUseVariantStatusColors Then
		c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, msVariant, "back", 0)
	End If
	If c = 0 Then c = B4XDaisyVariants.GetTokenColor("--color-success", 0xFF2ECC71)
	If CustomOnlineColor <> 0 Then c = CustomOnlineColor
	Return c
End Sub

Private Sub ResolveOfflineColor As Int
	Dim c As Int = 0
	If mbUseVariantStatusColors Then
		c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, msVariant, "muted", 0)
	End If
	If c = 0 Then c = B4XDaisyVariants.GetTokenColor("--color-base-300", 0xFFB4B4B4)
	If CustomOfflineColor <> 0 Then c = CustomOfflineColor
	Return c
End Sub

Private Sub ResolveEffectiveMask As String
	If mRounded = "rounded-none" Or mRounded = "rounded-full" Then Return AvatarMask
	' RoundedBox=True: use the theme's --radius-box value, mapped to the nearest mask token.
	Dim r As Float = B4XDaisyVariants.GetRadiusBoxDip(8dip)
	If r <= 0 Then Return "rounded-none"
	If r < 3dip Then Return "rounded-sm"
	If r < 6dip Then Return "rounded"
	If r < 10dip Then Return "rounded-md"
	If r < 14dip Then Return "rounded-lg"
	If r < 18dip Then Return "rounded-xl"
	If r < 22dip Then Return "rounded-2xl"
	Return "rounded-3xl"
End Sub

Private Sub ResolveRingColor As Int
	If mcRingColor <> 0 Then Return mcRingColor
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, msVariant, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, msVariant, "back", 0)
	If c = 0 Then c = B4XDaisyVariants.ResolveVariantColor(ActivePalette, msVariant, "muted", ResolveAvatarOutlineColor)
	Return c
End Sub

Private Sub ResolveAvatarOutlineColor As Int
	If AvatarBorderColor <> 0 Then Return AvatarBorderColor
	Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_RGB(245, 245, 245))
End Sub

Private Sub ResolveAvatarContentRect(fWidth As Float, fHeight As Float) As B4XRect
	Dim r As B4XRect
	r.Initialize(0, 0, fWidth, fHeight)
	Dim spec As Map = B4XDaisyVariants.ResolveShadowSpec(msShadow)
	Dim leftPadPx As Float = 0
	Dim topPadPx As Float = 0
	Dim rightPadPx As Float = 0
	Dim bottomPadPx As Float = 0

	Dim layers() As String = Array As String("1", "2")
	For Each layer As String In layers
		Dim alpha As Double = B4XDaisyVariants.GetPropFloat(spec, "alpha" & layer, 0)
		If alpha <= 0 Then Continue
		Dim y As Float = B4XDaisyVariants.GetPropFloat(spec, "y" & layer, 0)
		Dim blur As Float = Max(0, B4XDaisyVariants.GetPropFloat(spec, "blur" & layer, 0))
		Dim spread As Float = B4XDaisyVariants.GetPropFloat(spec, "spread" & layer, 0)
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

	If leftPad + rightPad > fWidth - 2dip Then
		Dim capX As Float = Max(0, (fWidth - 2dip) / 2)
		leftPad = Min(leftPad, capX)
		rightPad = Min(rightPad, capX)
	End If
	If topPad + bottomPad > fHeight - 2dip Then
		Dim capY As Float = Max(0, (fHeight - 2dip) / 2)
		topPad = Min(topPad, capY)
		bottomPad = Min(bottomPad, capY)
	End If

	r.Initialize(leftPad, topPad, fWidth - rightPad, fHeight - bottomPad)
	Return r
End Sub

Private Sub DrawAvatarShadow(rcBaseRect As B4XRect, sMaskName As String)
	Dim spec As Map = B4XDaisyVariants.ResolveShadowSpec(msShadow)
	DrawShadowLayer(rcBaseRect, sMaskName, B4XDaisyVariants.GetPropFloat(spec, "y1", 0), B4XDaisyVariants.GetPropFloat(spec, "blur1", 0), B4XDaisyVariants.GetPropFloat(spec, "spread1", 0), B4XDaisyVariants.GetPropFloat(spec, "alpha1", 0))
	DrawShadowLayer(rcBaseRect, sMaskName, B4XDaisyVariants.GetPropFloat(spec, "y2", 0), B4XDaisyVariants.GetPropFloat(spec, "blur2", 0), B4XDaisyVariants.GetPropFloat(spec, "spread2", 0), B4XDaisyVariants.GetPropFloat(spec, "alpha2", 0))
End Sub

Private Sub DrawShadowLayer(rcBaseRect As B4XRect, sMaskName As String, fOffsetYPx As Float, fBlurPx As Float, fSpreadPx As Float, dAlpha As Double)
	If dAlpha <= 0 Then Return

	Dim y As Float = fOffsetYPx * 1dip
	Dim blur As Float = Max(0, fBlurPx) * 1dip
	Dim spread As Float = fSpreadPx * 1dip
	Dim expansion As Float = Max(0, spread) + (blur * 0.45)
	Dim alphaInt As Int = Max(0, Min(255, dAlpha * 255))
	If alphaInt <= 0 Then Return

	Dim shadowRect As B4XRect
	shadowRect.Initialize(rcBaseRect.Left - expansion, rcBaseRect.Top + y - expansion, rcBaseRect.Right + expansion, rcBaseRect.Bottom + y + expansion)
	Dim shadowPath As B4XPath = B4XDaisyVariants.CreateMaskPathInRect(shadowRect, sMaskName)
	AvatarCvs.DrawPath(shadowPath, xui.Color_ARGB(alphaInt, 0, 0, 0), True, 0)

	'Second pass to mimic blur falloff in utility shadows.
	If blur > 0.5dip Then
		Dim extra As Float = blur * 0.35
		Dim shadowRect2 As B4XRect
		shadowRect2.Initialize(shadowRect.Left - extra, shadowRect.Top - extra, shadowRect.Right + extra, shadowRect.Bottom + extra)
		Dim alpha2 As Int = Max(0, Min(255, alphaInt * 0.4))
		If alpha2 > 0 Then
			Dim shadowPath2 As B4XPath = B4XDaisyVariants.CreateMaskPathInRect(shadowRect2, sMaskName)
			AvatarCvs.DrawPath(shadowPath2, xui.Color_ARGB(alpha2, 0, 0, 0), True, 0)
		End If
	End If
End Sub

Private Sub EnsureMaskCache
	If MaskBitmapCache.IsInitialized = False Then MaskBitmapCache.Initialize
End Sub

Private Sub MaskCacheKey(sMaskName As String, iWidth As Int, iHeight As Int) As String
	Return sMaskName & "|" & iWidth & "|" & iHeight
End Sub

Private Sub GetCachedMaskBitmap(sKey As String) As B4XBitmap
	EnsureMaskCache
	If MaskBitmapCache.ContainsKey(sKey) Then
		Dim cached As B4XBitmap = MaskBitmapCache.Get(sKey)
		If cached.IsInitialized Then Return cached
	End If
	Dim empty As B4XBitmap
	Return empty
End Sub

Private Sub PutCachedMaskBitmap(sKey As String, bmpBmp As B4XBitmap)
	EnsureMaskCache
	If bmpBmp.IsInitialized Then MaskBitmapCache.Put(sKey, bmpBmp)
End Sub

Private Sub DrawAvatar
	If ivAvatar.IsInitialized = False Or ivAvatar.Visible = False Then Return
	Dim aw As Int = Max(1dip, ivAvatar.Width)
	Dim ah As Int = Max(1dip, ivAvatar.Height)
	If aw <= 0 Or ah <= 0 Then Return
	
	Dim effectiveMask As String = ResolveEffectiveMask

	If AvatarCanvasReady Then AvatarCvs.Release
	AvatarCvs.Initialize(ivAvatar)
	AvatarCanvasReady = True
	#If B4A
	Dim jo As JavaObject = AvatarCvs
	Dim cvsJO As JavaObject = jo.GetField("cvs")
	Dim paint As JavaObject = cvsJO.GetField("paint")
	paint.RunMethod("setFilterBitmap", Array(True))
	paint.RunMethod("setAntiAlias", Array(True))
	#End If
	AvatarCvs.ClearRect(AvatarCvs.TargetRect)

	Dim full As B4XRect
	If mbChatImage Then
		full.Initialize(0, 0, aw, ah)
	Else
		full = ResolveAvatarContentRect(aw, ah)
		If full.Width <= 2dip Or full.Height <= 2dip Then full.Initialize(0, 0, aw, ah)
	End If
	Dim imageRect As B4XRect
	Dim imagePath As B4XPath
	Dim ringPath As B4XPath
	Dim shadowRect As B4XRect
	Dim shadowMask As String = effectiveMask
	Dim effectiveStatus As String = AvatarStatus
	If OnlineIndicatorVisible = False Then effectiveStatus = "none"

	Dim statusColor As Int = 0
	If effectiveStatus = "online" Then
		statusColor = ResolveOnlineColor
	Else If effectiveStatus = "offline" Then
		statusColor = ResolveOfflineColor
	End If

	Dim resolvedRingColor As Int
	Dim outlineColor As Int = ResolveAvatarOutlineColor
	If mbChatImage Then
		resolvedRingColor = IIf(statusColor <> 0, statusColor, outlineColor)
	Else
		resolvedRingColor = ResolveRingColor
	End If
	Dim ringW As Float = Max(0, AvatarBorderWidth)
	'Chat-image behavior: online status should always surface a visible ring.
	If mbChatImage And effectiveStatus = "online" And ringW <= 0 Then
		ringW = Max(1dip, 1dip)
	End If
	Dim gapW As Float = Max(0, mfRingOffset)
	Dim ringRadius As Float = -1

	If effectiveMask = "circle" Or effectiveMask = "rounded-full" Then
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
		If mbChatImage Then
			imageRect = full
			imagePath = B4XDaisyVariants.CreateMaskPathRect(aw, ah, effectiveMask)
		Else
			imageRect = InsetRectSafe(full, reserved2, 6dip)
			imagePath = B4XDaisyVariants.CreateMaskPathInRect(imageRect, effectiveMask)
		End If
		shadowRect = full
		If ringW > 0 Then
			If mbChatImage Then
				ringPath = imagePath
			Else
				ringPath = B4XDaisyVariants.CreateMaskPathInRect(full, effectiveMask)
			End If
		End If
	End If

	If mbChatImage = False And B4XDaisyVariants.NormalizeShadow(msShadow) <> "none" Then
		DrawAvatarShadow(shadowRect, shadowMask)
	End If

	Dim canDrawBitmap As Boolean = AvatarBmp.IsInitialized And msAvatarType = "image"

	'Fast path (inner mImage view) only handles the trivial shapes that mImage can render natively:
	'circle/rounded-full (rounded) and square/rounded-none (square). All rounded-* corner masks and
	'every polygon/heart/squircle mask route through the cached DrawThroughMask path so the mask
	'actually applies to the bitmap. Previously rounded-* hit the fast path with setRoundedImage(False)
	'and rendered square, ignoring the requested corner radius.
	Dim isSimpleShape As Boolean = False
	If effectiveMask = "circle" Or effectiveMask = "rounded-full" Or _
	   effectiveMask = "square" Or effectiveMask = "rounded-none" Then
		isSimpleShape = True
	End If

	If mImage.IsInitialized Then
		If canDrawBitmap And isSimpleShape Then
			mImage.mBase.Visible = True
			Dim imgX As Int = imageRect.Left
			Dim imgY As Int = imageRect.Top
			Dim imgW As Int = Max(1dip, imageRect.Width)
			Dim imgH As Int = Max(1dip, imageRect.Height)
			mImage.mBase.SetLayoutAnimated(0, imgX, imgY, imgW, imgH)
			mImage.Base_Resize(imgW, imgH)
			mImage.setResizeMode(msResizeMode)
			
			If effectiveMask = "circle" Or effectiveMask = "rounded-full" Then
				mImage.setRoundedImage(True)
			Else
				mImage.setRoundedImage(False)
			End If

			Dim drawBmp As B4XBitmap = AvatarBmp
			If miBlurRadius > 0 Then
				drawBmp = BlurImage(AvatarBmp, miBlurRadius)
			End If
			mImage.setBitmap(drawBmp)
		Else
			mImage.mBase.Visible = False
		End If
	End If

	If canDrawBitmap And isSimpleShape = False Then
		Dim drawBmp As B4XBitmap = AvatarBmp
		If miBlurRadius > 0 Then
			drawBmp = BlurImage(AvatarBmp, miBlurRadius)
		End If
		Dim bmpRect As B4XRect = ResolveBitmapDestRect(drawBmp, imageRect, msResizeMode)
		
		' 1. Reuse or create a transparent mask bitmap of the target size (aw x ah)
		Dim maskKey As String = MaskCacheKey(effectiveMask, aw, ah)
		Dim maskBmp As B4XBitmap = GetCachedMaskBitmap(maskKey)
		If maskBmp.IsInitialized = False Then
			Dim maskCvs As B4XCanvas
			Dim pnlMask As Panel
			pnlMask.Initialize("")
			Dim maskView As B4XView = pnlMask
			maskView.SetLayoutAnimated(0, 0, 0, aw, ah)
			maskCvs.Initialize(maskView)

			' Draw the path on the mask canvas in solid black with anti-aliasing
			#If B4A
			Dim joMask As JavaObject = maskCvs
			Dim cvsJOMask As JavaObject = joMask.GetField("cvs")
			Dim paintMask As JavaObject = cvsJOMask.GetField("paint")
			paintMask.RunMethod("setAntiAlias", Array(True))
			#End If
			maskCvs.DrawPath(imagePath, xui.Color_Black, True, 0)
			maskCvs.Invalidate
			maskBmp = maskCvs.CreateBitmap
			maskCvs.Release
			PutCachedMaskBitmap(maskKey, maskBmp)
		End If

		' 2. Create a transparent image bitmap of the target size (aw x ah)
		Dim imgBmp As B4XBitmap
		Dim imgCvs As B4XCanvas
		Dim pnlImg As Panel
		pnlImg.Initialize("")
		Dim imgView As B4XView = pnlImg
		imgView.SetLayoutAnimated(0, 0, 0, aw, ah)
		imgCvs.Initialize(imgView)
		
		' Resize the drawBmp to the exact destination size first using bilinear filtering.
		' This prevents the pixelation/aliasing that occurs when downscaling large images on Android's Canvas.
		Dim scaledBmp As B4XBitmap = drawBmp.Resize(Max(1, bmpRect.Width), Max(1, bmpRect.Height), False)
		
		#If B4A
		Dim joImg As JavaObject = imgCvs
		Dim cvsJOImg As JavaObject = joImg.GetField("cvs")
		Dim paintImg As JavaObject = cvsJOImg.GetField("paint")
		paintImg.RunMethod("setFilterBitmap", Array(True))
		paintImg.RunMethod("setAntiAlias", Array(True))
		#End If
		imgCvs.DrawBitmap(scaledBmp, bmpRect)
		
		' Draw glass overlay on the temporary image canvas so that it also gets masked perfectly
		If mbGlass Then
			Dim glassBgColor As Int = xui.Color_ARGB(35, 255, 255, 255)
			imgCvs.DrawRect(imageRect, glassBgColor, True, 0)
			imgCvs.DrawPath(imagePath, xui.Color_ARGB(100, 255, 255, 255), False, 1.5dip)
		End If
		
		imgCvs.Invalidate
		imgBmp = imgCvs.CreateBitmap
		imgCvs.Release
		
		' 3. Blend them using BitmapCreatorEffects
		Dim bce As BitmapCreatorEffects
		bce.Initialize
		Dim maskedBmp As B4XBitmap = bce.DrawThroughMask(imgBmp, maskBmp)
 		
		' 4. Draw the final anti-aliased bitmap onto the main canvas (without clipping)
		AvatarCvs.DrawBitmap(maskedBmp, AvatarCvs.TargetRect)
	Else
		' Standard clipped drawing for placeholders
		AvatarCvs.ClipPath(imagePath)
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
			Dim ty As Float = imageRect.CenterY - (textRect.Height / 2) - textRect.Top
			AvatarCvs.DrawText(phText, tx, ty, f, ResolvePlaceholderTextColor, "CENTER")
		End If
		If mbGlass Then
			Dim glassBgColor As Int = xui.Color_ARGB(35, 255, 255, 255)
			AvatarCvs.DrawRect(imageRect, glassBgColor, True, 0)
			AvatarCvs.DrawPath(imagePath, xui.Color_ARGB(100, 255, 255, 255), False, 1.5dip)
		End If
		AvatarCvs.RemoveClip
	End If

	If ringW > 0 Then
		If AvatarMask = "circle" Or AvatarMask = "rounded-full" Then
			If ringRadius > 0 Then AvatarCvs.DrawCircle(imageRect.CenterX, imageRect.CenterY, ringRadius, resolvedRingColor, False, ringW)
		Else
			AvatarCvs.DrawPath(ringPath, resolvedRingColor, False, ringW)
		End If
	End If

	' Draw online/offline indicator on its own overlay canvas so it renders above mImage
	Dim ivInd As B4XView = ivIndicator
	ivInd.SetLayoutAnimated(0, 0, 0, aw, ah)
	ivInd.BringToFront
	If IndicatorCvsReady Then IndicatorCvs.Release
	IndicatorCvs.Initialize(ivInd)
	IndicatorCvsReady = True
	IndicatorCvs.ClearRect(IndicatorCvs.TargetRect)
	If effectiveStatus <> "none" Then
		' Anchor the status dot to the avatar's outer box (not the ring-inset imageRect)
		' so it sits at the corner consistently, matching DaisyUI .avatar-online:before
		' (top:7%; right:7%; width/height:15% of the box). A ring no longer pulls it inward.
		Dim dd As Float = Min(aw, ah)
		Dim d As Float = Max(6dip, dd * 0.15)
		Dim r As Float = d / 2
		Dim cx As Float = aw - (dd * 0.07) - r
		Dim cy As Float = (dd * 0.07) + r
		IndicatorCvs.DrawCircle(cx, cy, r + 2dip, outlineColor, True, 0)
		IndicatorCvs.DrawCircle(cx, cy, r, statusColor, True, 0)
	End If
	IndicatorCvs.Invalidate

	AvatarCvs.Invalidate
End Sub

Private Sub NormalizeAvatarType(sValue As String) As String
	If sValue = Null Then Return "image"
	Dim v As String = sValue.ToLowerCase.Trim
	Select Case v
		Case "image", "svg", "text"
			Return v
		Case Else
			Return "image"
	End Select
End Sub

Private Sub ResolvePlaceholderBackColor As Int
	If PlaceholderBackgroundColor <> 0 Then Return PlaceholderBackgroundColor
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, msVariant, "back", 0)
	If c <> 0 Then Return c
	Return B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(220, 220, 220))
End Sub

Private Sub ResolvePlaceholderTextColor As Int
	If PlaceholderTextColor <> 0 Then Return PlaceholderTextColor
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(ActivePalette, msVariant, "text", 0)
	If c <> 0 Then Return c
	Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(55, 65, 81))
End Sub

Private Sub ResolvePlaceholderText As String
	Dim t As String = PlaceholderText
	If t <> Null Then t = t.Trim Else t = ""
	If t.Length > 0 Then Return t
	If msAvatarType = "svg" Then Return "SVG"
	Return ""
End Sub

Private Sub AvatarSourceLabel As String
	If AvatarPath <> "" Then Return AvatarPath
	Return "<bitmap>"
End Sub

Private Sub WarnIfUpscaled(sSourceLabel As String, bmpBmp As B4XBitmap, rcDestRect As B4XRect)
	If bmpBmp.IsInitialized = False Then Return
	If bmpBmp.Width <= 0 Or bmpBmp.Height <= 0 Then Return
	If rcDestRect.Width <= 0 Or rcDestRect.Height <= 0 Then Return
	Dim sx As Double = rcDestRect.Width / bmpBmp.Width
	Dim sy As Double = rcDestRect.Height / bmpBmp.Height
	Dim scaleUp As Double = Max(sx, sy)
	If scaleUp <= 1.05 Then Return
	Dim key As String = sSourceLabel & "|" & bmpBmp.Width & "x" & bmpBmp.Height & "|" & Round(rcDestRect.Width) & "x" & Round(rcDestRect.Height)
	If key = LastUpscaleWarningKey Then Return
	LastUpscaleWarningKey = key
End Sub

Private Sub InsetRectSafe(rcSource As B4XRect, fInset As Float, fMinSize As Float) As B4XRect
	Dim r As B4XRect
	Dim ix As Float = Max(0, Min(fInset, Max(0, (rcSource.Width - fMinSize) / 2)))
	Dim iy As Float = Max(0, Min(fInset, Max(0, (rcSource.Height - fMinSize) / 2)))
	r.Initialize(rcSource.Left + ix, rcSource.Top + iy, rcSource.Right - ix, rcSource.Bottom - iy)
	Return r
End Sub

Private Sub ResolveBitmapDestRect(bmpBmp As B4XBitmap, rcTargetRect As B4XRect, sMode As String) As B4XRect
	Dim outRect As B4XRect
	outRect.Initialize(rcTargetRect.Left, rcTargetRect.Top, rcTargetRect.Right, rcTargetRect.Bottom)
	If bmpBmp.IsInitialized = False Then Return outRect
	If bmpBmp.Width <= 0 Or bmpBmp.Height <= 0 Then Return outRect
	If rcTargetRect.Width <= 0 Or rcTargetRect.Height <= 0 Then Return outRect

	Dim modeUpper As String = sMode.ToUpperCase.Trim
	If modeUpper = "" Then modeUpper = "FILL_NO_DISTORTIONS"
	
	' Check for ChatImageMode override (chat bubbles always use FILL / stretch)
	If mbChatImage Then modeUpper = "FILL"

	Select modeUpper
		Case "FILL"
			Return outRect
		Case "FIT"
			Dim r As Float = Min(rcTargetRect.Width / bmpBmp.Width, rcTargetRect.Height / bmpBmp.Height)
			Dim w As Float = bmpBmp.Width * r
			Dim h As Float = bmpBmp.Height * r
			Dim cx As Float = rcTargetRect.CenterX
			Dim cy As Float = rcTargetRect.CenterY
			outRect.Initialize(cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
		Case "FILL_NO_DISTORTIONS"
			Dim r As Float = Max(rcTargetRect.Width / bmpBmp.Width, rcTargetRect.Height / bmpBmp.Height)
			Dim w As Float = bmpBmp.Width * r
			Dim h As Float = bmpBmp.Height * r
			Dim cx As Float = rcTargetRect.CenterX
			Dim cy As Float = rcTargetRect.CenterY
			outRect.Initialize(cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
		Case "NONE"
			Dim w As Float = bmpBmp.Width
			Dim h As Float = bmpBmp.Height
			Dim cx As Float = rcTargetRect.CenterX
			Dim cy As Float = rcTargetRect.CenterY
			outRect.Initialize(cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
		Case Else
			' Default to FILL_NO_DISTORTIONS
			Dim r As Float = Max(rcTargetRect.Width / bmpBmp.Width, rcTargetRect.Height / bmpBmp.Height)
			Dim w As Float = bmpBmp.Width * r
			Dim h As Float = bmpBmp.Height * r
			Dim cx As Float = rcTargetRect.CenterX
			Dim cy As Float = rcTargetRect.CenterY
			outRect.Initialize(cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
	End Select
	Return outRect
End Sub

Private Sub ivAvatar_Click
	If mClickable = False Then Return
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' Sets whether the avatar intercepts touch events.
''' When False, touches pass through to the parent view (e.g. a list row).
''' When True, the avatar handles clicks normally via the Click event.
Public Sub setClickable(bValue As Boolean)
	mClickable = bValue
	#If B4A
	If mBase.IsInitialized Then
		Dim joBase As JavaObject = mBase
		joBase.RunMethod("setClickable", Array(bValue))
		If ivAvatar.IsInitialized Then
			Dim joIv As JavaObject = ivAvatar
			joIv.RunMethod("setClickable", Array(bValue))
		End If
	End If
	#Else If B4J
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If ivAvatar.IsInitialized Then ivAvatar.Enabled = bValue
	End If
	#Else If B4i
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If ivAvatar.IsInitialized Then ivAvatar.Enabled = bValue
	End If
	#End If
End Sub

''' Gets whether the avatar is clickable.
Public Sub getClickable As Boolean
	Return mClickable
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

'Sets a bitmap and sets the gravity to Fill.
Public Sub SetBitmapAndFill (vImageView As B4XView, bmpBmp As B4XBitmap)
	vImageView.SetBitmap(bmpBmp)
	Dim iiv As ImageView = vImageView
	#if B4A
	iiv.Gravity = Gravity.FILL
	#Else If B4J
	iiv.PreserveRatio = False
	#else if B4i
	iiv.ContentMode = iiv.MODE_FILL
	#End If
End Sub

Private Sub BlurImage(bmpBmp As B4XBitmap, iRadius As Int) As B4XBitmap
	If bmpBmp.IsInitialized = False Then Return bmpBmp
	Dim n As Long = DateTime.Now
	
	' Downscale the image to speed up blur and add natural smoothness
	Dim ReduceScale As Float = Max(1.5, iRadius / 2.5)
	Dim count As Int = Max(2, Min(5, iRadius / 2))
	
	Dim targetW As Int = Max(16, bmpBmp.Width / ReduceScale)
	Dim targetH As Int = Max(16, bmpBmp.Height / ReduceScale)
	Dim smallBmp As B4XBitmap = bmpBmp.Resize(targetW, targetH, True)
	
	Dim bc As BitmapCreator
	bc.Initialize(smallBmp.Width, smallBmp.Height)
	bc.CopyPixelsFromBitmap(smallBmp)
	
	' Perform box blur passes
	Dim clrs(3) As ARGBColor
	Dim temp As ARGBColor
	Dim m As Int
	For steps = 1 To count
		For y = 0 To bc.mHeight - 1
			For x = 0 To 2
				bc.GetARGB(x, y, clrs(x))
			Next
			SetAvg(bc, 1, y, clrs, temp)
			m = 0
			For x = 2 To bc.mWidth - 2
				bc.GetARGB(x + 1, y, clrs(m))
				m = (m + 1) Mod clrs.Length
				SetAvg(bc, x, y, clrs, temp)
			Next
		Next
		For x = 0 To bc.mWidth - 1
			For y = 0 To 2
				bc.GetARGB(x, y, clrs(y))
			Next
			SetAvg(bc, x, 1, clrs, temp)
			m = 0
			For y = 2 To bc.mHeight - 2
				bc.GetARGB(x, y + 1, clrs(m))
				m = (m + 1) Mod clrs.Length
				SetAvg(bc, x, y, clrs, temp)
			Next
		Next
	Next
	
	Dim blurredBmp As B4XBitmap = bc.Bitmap
	Dim finalBmp As B4XBitmap = blurredBmp.Resize(bmpBmp.Width, bmpBmp.Height, True)
	Return finalBmp
End Sub

Private Sub SetAvg(bc As BitmapCreator, iX As Int, iY As Int, oClrs() As ARGBColor, temp As ARGBColor)
	temp.Initialize
	Dim totalR As Int = 0
	Dim totalG As Int = 0
	Dim totalB As Int = 0
	Dim totalA As Int = 0
	For Each c As ARGBColor In oClrs
		totalR = totalR + c.r
		totalG = totalG + c.g
		totalB = totalB + c.b
		totalA = totalA + c.a
	Next
	temp.a = totalA / oClrs.Length
	temp.r = totalR / oClrs.Length
	temp.g = totalG / oClrs.Length
	temp.b = totalB / oClrs.Length
	bc.SetARGB(iX, iY, temp)
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

Public Sub Release
    If ivAvatar.IsInitialized Then ivAvatar.RemoveViewFromParent
    If ivIndicator.IsInitialized Then ivIndicator.RemoveView
    If MaskBitmapCache.IsInitialized Then MaskBitmapCache.Clear
    mCallBack = Null
End Sub