B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 20rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-12, Description: Tailwind size token or CSS size (eg h-12, 80px, 5rem)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Padding utility/value for group content (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Margin utility/value for group host insets (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: Spacing, DisplayName: Spacing, FieldType: String, DefaultValue: -space-x-6, Description: Overlap or gap utility (eg -space-x-6, space-x-4)
#DesignerProperty: Key: AvatarSize, DisplayName: Avatar Size, FieldType: String, DefaultValue: 12, Description: Tailwind size for avatars (e.g. 12, 16, 24)
#DesignerProperty: Key: LimitTo, DisplayName: Limit To, FieldType: Int, DefaultValue: 5, Description: Max avatars shown before overflow placeholder (+N)

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	Private mWidth As Float = 160dip
	Private mHeight As Float = 48dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mSpacing As String = "-space-x-6"
	Private mAvatarSize As Object = "12"
	Private mLimitTo As Int = 5
	Private Items As List
	Private OverflowAvatar As B4XDaisyAvatar
	Private mOverflowCount As Int = 0
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	Items.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	ApplyDesignerProps(mProps)
	Base_Resize(mBase.Width, mBase.Height)
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
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Relayout
	inResize = False
End Sub







Private Sub ApplyDesignerProps(mProps As Map)
mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(B4XDaisyVariants.GetPropString(mProps, "Width", "full"), B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(B4XDaisyVariants.GetPropString(mProps, "Height", "h-12"), B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
	mWidthExplicit = mProps.ContainsKey("Width")
	mHeightExplicit = mProps.ContainsKey("Height")
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mSpacing = B4XDaisyVariants.GetPropString(mProps, "Spacing", mSpacing)
	mAvatarSize = B4XDaisyVariants.GetPropObject(mProps, "AvatarSize", mAvatarSize)
	mLimitTo = Max(0, B4XDaisyVariants.GetPropInt(mProps, "LimitTo", mLimitTo))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("Spacing", mSpacing)
	props.Put("AvatarSize", mAvatarSize)
	props.Put("LimitTo", mLimitTo)
	Return props
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



Public Sub AddAvatar(Avatar As B4XDaisyAvatar) As Int
	Dim v As B4XView = Avatar.View
	If v.IsInitialized = False Then Return -1
	
	' --- Limit-aware overflow logic ---
	' If adding this avatar would exceed the limit (and limit > 0), create or update the overflow placeholder.
	If mLimitTo > 0 And Items.Size >= mLimitTo Then
		mOverflowCount = mOverflowCount + 1
		If OverflowAvatar.IsInitialized = False Then
			CreateOverflowPlaceholder
		Else
			OverflowAvatar.SetPlaceHolder("+" & mOverflowCount)
		End If
		Return -1
	End If
	
	' --- Normal add (slot available or no limit) ---
	ApplyGroupStyle(Avatar)
	Dim tag As Object = Avatar.getAvatarTag
	Dim idx As Int = AddAvatarViewInternal(v, tag, Avatar)
	Return idx
End Sub

Private Sub ApplyGroupStyle(Avatar As B4XDaisyAvatar)
	' DaisyUI avatar-group spec: circle mask + 2px base-100 ring + 0 offset
	Dim ringW As Float = 2dip
	Dim ringColor As Int = ResolveBorderColor
	' Order matters: Size and Mask first, then manual ring overrides
	Avatar.setAvatarSize(mAvatarSize)
	Avatar.SetAvatarMask("rounded-full")
	Avatar.setRingWidth(ringW)
	Avatar.setRingColor(ringColor)
	Avatar.setRingOffset(0)
End Sub

Private Sub CreateOverflowPlaceholder
	' Build the "+N" pill avatar and add it as a regular item in the Items list.
	OverflowAvatar.Initialize(mCallBack, "overflow_placeholder")
	OverflowAvatar.CreateView(32dip, 32dip) ' Initial size, will be reset by Relayout/ApplyGroupStyle
	OverflowAvatar.SetAvatarType("text")
	OverflowAvatar.SetPlaceHolder("+" & mOverflowCount)
	OverflowAvatar.SetVariant("neutral")
	OverflowAvatar.SetBackgroundColorVariant("neutral")
	OverflowAvatar.SetTextColorVariant("neutral-content")
	OverflowAvatar.TextSize = "text-sm"
	
	' Ensure ring is enabled explicitly before applying group style
	OverflowAvatar.SetRingWidth(2dip)
	ApplyGroupStyle(OverflowAvatar)
	
	Dim v As B4XView = OverflowAvatar.View
	Dim tag As Object = OverflowAvatar.getAvatarTag
	AddAvatarViewInternal(v, tag, OverflowAvatar)
End Sub

Public Sub AddAvatarView(vChildView As B4XView, oTag As Object) As Int
	Return AddAvatarViewInternal(vChildView, oTag, Null)
End Sub

Private Sub AddAvatarViewInternal(vChildView As B4XView, oTag As Object, oAvatarObj As Object) As Int
	If vChildView.IsInitialized = False Then Return -1
	Dim item As Map = CreateMap("view": vChildView, "tag": oTag, "avatar": oAvatarObj)
	Items.Add(item)
	If mBase.IsInitialized Then
		If vChildView.Parent.IsInitialized Then
			Dim parentView As B4XView = vChildView.Parent
			If parentView.IsInitialized And parentView <> mBase Then vChildView.RemoveViewFromParent
		End If
		If vChildView.Parent.IsInitialized = False Then mBase.AddView(vChildView, 0, 0, Max(1dip, vChildView.Width), Max(1dip, vChildView.Height))
		Relayout
	End If
	Return Items.Size - 1
End Sub

Public Sub Clear
	For i = 0 To Items.Size - 1
		Dim it As Map = Items.Get(i)
		Dim v As B4XView = it.Get("view")
		If v.IsInitialized Then v.RemoveViewFromParent
	Next
	Items.Clear
	mOverflowCount = 0
	Dim emptyAvatar As B4XDaisyAvatar
	OverflowAvatar = emptyAvatar
End Sub

Public Sub getCount As Int
	Return Items.Size
End Sub

Public Sub setWidth(oValue As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, Max(1dip, mBase.Height))
	Relayout
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(oValue As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, mBase.Width), mHeight)
	Relayout
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setPadding(sValue As String)
	mPadding = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	mMargin = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setSpacing(sValue As String)
	mSpacing = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getSpacing As String
	Return mSpacing
End Sub



Public Sub applyActiveTheme
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub setAvatarSize(oValue As Object)
	mAvatarSize = oValue
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getAvatarSize As Object
	Return mAvatarSize
End Sub

Public Sub setLimitTo(iValue As Int)
	mLimitTo = Max(1, iValue)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getLimitTo As Int
	Return mLimitTo
End Sub



Private Sub Relayout
	If mBase.IsInitialized = False Then Return
	Dim box As Map = BuildBoxModel
	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	Dim borderColor As Int = ResolveBorderColor
	Dim x As Int = contentRect.Left
	Dim h As Int = Max(1dip, contentRect.Height)
	Dim yTop As Int = contentRect.Top
	
	' Resolve avatar size for positioning only
	Dim resolvedSize As Float = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(mAvatarSize, h))
	
	' Parse spacing string (e.g. "-space-x-6" -> -24dip, "space-x-4" -> 16dip)
	Dim spacingVal As Float = 0
	Dim spc As String = mSpacing.ToLowerCase.Trim
	If spc.Length > 0 Then
		Dim isNeg As Boolean = spc.StartsWith("-")
		If isNeg Then spc = spc.SubString(1).Trim
		If spc.StartsWith("space-x-") Then
			Dim token As String = spc.SubString("space-x-".Length)
			spacingVal = B4XDaisyBoxModel.TailwindSpacingToDip(token, 0dip)
			If isNeg Then spacingVal = -spacingVal
		End If
	End If
	
	' Position every item ? all items in the list are visible (overflow is already a regular item)
	For i = 0 To Items.Size - 1
		Dim item As Map = Items.Get(i)
		Dim v As B4XView = item.Get("view")
		If v.IsInitialized = False Then Continue
		
		If v.Parent.IsInitialized = False Then mBase.AddView(v, 0, 0, Max(1dip, v.Width), Max(1dip, v.Height))
		
		' Container size matches resolvedSize
		Dim w As Int = resolvedSize
		Dim vh As Int = resolvedSize
		Dim y As Int = yTop + Max(0, (h - vh) / 2)
		
		v.SetLayoutAnimated(0, x, y, w, vh)
		ApplyAvatarItemStyle(item, borderColor)
		
		x = x + w + spacingVal
	Next
	
	' Enforce left-to-right overlaps (Z-Index): later items draw on top.
	For i = 0 To Items.Size - 1
		Dim item As Map = Items.Get(i)
		Dim v As B4XView = item.Get("view")
		If v.IsInitialized And v.Parent.IsInitialized Then
			v.BringToFront
		End If
	Next
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

Private Sub ApplyAvatarItemStyle(mItem As Map, iBorderColor As Int)
	Dim v As B4XView = mItem.Get("view")
	If v.IsInitialized = False Then Return
	
	Dim avatarObj As Object = mItem.GetDefault("avatar", Null)
	If avatarObj <> Null Then
		' Styles (mask, ring, offset) already applied in AddAvatar.
		' Here we only trigger the internal redraw to match the container size set by Relayout.
		If xui.SubExists(avatarObj, "Base_Resize", 2) Then
			CallSub3(avatarObj, "Base_Resize", v.Width, v.Height)
		Else If xui.SubExists(avatarObj, "ResizeToParent", 1) Then
			CallSub2(avatarObj, "ResizeToParent", v)
		End If
	Else
		' Fallback to OS native border for raw non-Avatar views inside the group
		Dim r As Float = Min(v.Width, v.Height) / 2
		v.SetColorAndBorder(xui.Color_Transparent, 2dip, iBorderColor, r)
	End If
End Sub

Private Sub ResolveBorderColor As Int
	Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
End Sub





Public Sub setTag(oValue As Object)
	mTag = oValue
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
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
