B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 20rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 12, Description: Tailwind size token or CSS size (eg 12, 80px, 5rem)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Padding utility/value for group content (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Margin utility/value for group host insets (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: Spacing, DisplayName: Spacing, FieldType: String, DefaultValue: -space-x-6, Description: Overlap or gap utility (eg -space-x-6, space-x-4)
#DesignerProperty: Key: AvatarSize, DisplayName: Avatar Size, FieldType: String, DefaultValue: 12, Description: Tailwind size for avatars (e.g. 12, 16, 24)
#DesignerProperty: Key: LimitTo, DisplayName: Limit To, FieldType: Int, DefaultValue: 5, Description: Max avatars shown before overflow placeholder (+N)

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
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	Items.Initialize
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
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
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(w))
	props.Put("Height", ResolvePxSizeSpec(h))
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

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub







Private Sub ApplyDesignerProps(Props As Map)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(B4XDaisyVariants.GetPropString(Props, "Width", mWidth), ResolveWidthBase(mWidth)))
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(B4XDaisyVariants.GetPropString(Props, "Height", mHeight), ResolveHeightBase(mHeight)))
	mWidthExplicit = Props.ContainsKey("Width")
	mHeightExplicit = Props.ContainsKey("Height")
	mPadding = B4XDaisyVariants.GetPropString(Props, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(Props, "Margin", mMargin)
	mSpacing = B4XDaisyVariants.GetPropString(Props, "Spacing", mSpacing)
	mAvatarSize = Props.GetDefault("AvatarSize", mAvatarSize)
	mLimitTo = Max(0, B4XDaisyVariants.GetPropInt(Props, "LimitTo", mLimitTo))
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

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
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

Public Sub AddAvatarView(ChildView As B4XView, Tag As Object) As Int
	Return AddAvatarViewInternal(ChildView, Tag, Null)
End Sub

Private Sub AddAvatarViewInternal(ChildView As B4XView, Tag As Object, AvatarObj As Object) As Int
	If ChildView.IsInitialized = False Then Return -1
	Dim item As Map = CreateMap("view": ChildView, "tag": Tag, "avatar": AvatarObj)
	Items.Add(item)
	If mBase.IsInitialized Then
		If ChildView.Parent.IsInitialized Then
			Dim parentView As B4XView = ChildView.Parent
			If parentView.IsInitialized And parentView <> mBase Then ChildView.RemoveViewFromParent
		End If
		If ChildView.Parent.IsInitialized = False Then mBase.AddView(ChildView, 0, 0, Max(1dip, ChildView.Width), Max(1dip, ChildView.Height))
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

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mWidth, Max(1dip, mBase.Height))
	Relayout
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, mBase.Width), mHeight)
	Relayout
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setPadding(Value As String)
	mPadding = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setSpacing(Value As String)
	mSpacing = IIf(Value = Null, "", Value)
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

Public Sub setAvatarSize(Value As Object)
	mAvatarSize = Value
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getAvatarSize As Object
	Return mAvatarSize
End Sub

Public Sub setLimitTo(Value As Int)
	mLimitTo = Max(1, Value)
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
	
	' Position every item — all items in the list are visible (overflow is already a regular item)
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

Private Sub ApplyAvatarItemStyle(Item As Map, BorderColor As Int)
	Dim v As B4XView = Item.Get("view")
	If v.IsInitialized = False Then Return
	
	Dim avatarObj As Object = Item.GetDefault("avatar", Null)
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
		v.SetColorAndBorder(xui.Color_Transparent, 2dip, BorderColor, r)
	End If
End Sub

Private Sub ResolveBorderColor As Int
	Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
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

Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
