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
#DesignerProperty: Key: Overlap, DisplayName: Overlap, FieldType: Int, DefaultValue: 8, Description: Horizontal overlap between avatars in dip
#DesignerProperty: Key: ItemSize, DisplayName: Item Size, FieldType: String, DefaultValue: 10, Description: Fallback avatar size when child has no size
#DesignerProperty: Key: AvatarSize, DisplayName: Avatar Size, FieldType: String, DefaultValue: 0, Description: Forced avatar size for all items (0 keeps individual sizes)
#DesignerProperty: Key: LimitTo, DisplayName: Limit To, FieldType: Int, DefaultValue: 5, Description: Max avatars shown before overflow placeholder (+N)
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 4, Description: Border width applied around each avatar
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color (0 = theme base-100)

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
	Private mOverlap As Float = 8dip
	Private mItemSize As Float = 40dip
	Private mAvatarSize As Float = 0dip
	Private mLimitTo As Int = 5
	Private mBorderWidth As Float = 4dip
	Private mBorderColor As Int = 0
	Private Items As List
	Private CustProps As Map
	Private OverflowView As B4XView
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	Items.Initialize
	SetDefaults
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

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub SetDefaults
	CustProps.Initialize
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("Margin", mMargin)
	CustProps.Put("Overlap", mOverlap)
	CustProps.Put("ItemSize", mItemSize)
	CustProps.Put("AvatarSize", mAvatarSize)
	CustProps.Put("LimitTo", mLimitTo)
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("BorderColor", mBorderColor)
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
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("Margin", mMargin)
	CustProps.Put("Overlap", mOverlap)
	CustProps.Put("ItemSize", mItemSize)
	CustProps.Put("AvatarSize", mAvatarSize)
	CustProps.Put("LimitTo", mLimitTo)
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("BorderColor", mBorderColor)
	CustProps.Put("Tag", mTag)
	Return CustProps
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	If CustProps.IsInitialized = False Then SetDefaults
	SetProperties(Props)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(CustProps.GetDefault("Width", mWidth), ResolveWidthBase(mWidth)))
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(CustProps.GetDefault("Height", mHeight), ResolveHeightBase(mHeight)))
	mWidthExplicit = CustProps.ContainsKey("Width")
	mHeightExplicit = CustProps.ContainsKey("Height")
	mPadding = CustProps.GetDefault("Padding", mPadding)
	mMargin = CustProps.GetDefault("Margin", mMargin)
	mOverlap = Max(0, B4XDaisyVariants.TailwindSizeToDip(CustProps.GetDefault("Overlap", mOverlap), mOverlap))
	mItemSize = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(CustProps.GetDefault("ItemSize", mItemSize), mItemSize))
	mAvatarSize = Max(0, B4XDaisyVariants.TailwindSizeToDip(CustProps.GetDefault("AvatarSize", mAvatarSize), mAvatarSize))
	mLimitTo = Max(1, CustProps.GetDefault("LimitTo", mLimitTo))
	mBorderWidth = Max(0, B4XDaisyVariants.TailwindSizeToDip(CustProps.GetDefault("BorderWidth", mBorderWidth), mBorderWidth))
	mBorderColor = CustProps.GetDefault("BorderColor", mBorderColor)
End Sub

Public Sub AddAvatarComponent(Avatar As B4XDaisyAvatar) As Int
	Dim tag As Object = Null
	Dim v As B4XView = Avatar.View
	If v.IsInitialized = False Then Return -1
	tag = Avatar.getAvatarTag
	Dim idx As Int = AddAvatarViewInternal(v, tag, Avatar)
	Return idx
End Sub

Public Sub AddAvatarView(ChildView As B4XView, Tag As Object) As Int
	Return AddAvatarViewInternal(ChildView, Tag, Null)
End Sub

Private Sub AddAvatarViewInternal(ChildView As B4XView, Tag As Object, AvatarObj As Object) As Int
	If ChildView.IsInitialized = False Then Return -1
	Dim item As Map = CreateMap("view": ChildView, "tag": Tag, "avatar": AvatarObj)
	Items.Add(item)
	If mBase.IsInitialized Then
		If ChildView.Parent.IsInitialized And ChildView.Parent <> mBase Then ChildView.RemoveViewFromParent
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
	If OverflowView.IsInitialized Then
		OverflowView.RemoveViewFromParent
		Dim empty As B4XView
		OverflowView = empty
	End If
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

Public Sub setOverlap(Value As Object)
	mOverlap = Max(0, B4XDaisyVariants.TailwindSizeToDip(Value, mOverlap))
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getOverlap As Float
	Return mOverlap
End Sub

Public Sub setItemSize(Value As Object)
	mItemSize = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, mItemSize))
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getItemSize As Float
	Return mItemSize
End Sub

Public Sub applyActiveTheme
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub setAvatarSize(Value As Object)
	mAvatarSize = Max(0, B4XDaisyVariants.TailwindSizeToDip(Value, mAvatarSize))
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getAvatarSize As Float
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

Public Sub setBorderWidth(Value As Object)
	mBorderWidth = Max(0, B4XDaisyVariants.TailwindSizeToDip(Value, mBorderWidth))
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getBorderWidth As Float
	Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
	mBorderColor = Value
	If mBase.IsInitialized = False Then Return
	Relayout
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
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
	Dim visibleCount As Int = Min(Items.Size, mLimitTo)
	For i = 0 To Items.Size - 1
		Dim item As Map = Items.Get(i)
		Dim v As B4XView = item.Get("view")
		If v.IsInitialized = False Then Continue
		Dim showItem As Boolean = (i < visibleCount)
		v.Visible = showItem
		If showItem = False Then Continue
		If v.Parent.IsInitialized = False Then mBase.AddView(v, 0, 0, Max(1dip, v.Width), Max(1dip, v.Height))
		Dim forcedSize As Int = IIf(mAvatarSize > 0, Max(16dip, mAvatarSize), 0)
		Dim w As Int = IIf(forcedSize > 0, forcedSize, Max(16dip, IIf(v.Width > 1dip, v.Width, mItemSize)))
		Dim vh As Int = IIf(forcedSize > 0, forcedSize, Max(16dip, IIf(v.Height > 1dip, v.Height, mItemSize)))
		Dim y As Int = yTop + Max(0, (h - vh) / 2)
		v.SetLayoutAnimated(0, x, y, w, vh)
		ApplyAvatarItemStyle(item, borderColor)
		x = x + Max(1dip, w - mOverlap)
	Next
	LayoutOverflowPlaceholder(x, yTop, h, borderColor)
End Sub

Private Sub LayoutOverflowPlaceholder(StartX As Int, TopY As Int, HostH As Int, BorderColor As Int)
	Dim extra As Int = Items.Size - mLimitTo
	If extra <= 0 Then
		If OverflowView.IsInitialized Then OverflowView.Visible = False
		Return
	End If
	If OverflowView.IsInitialized = False Then
		Dim l As Label
		l.Initialize("")
		OverflowView = l
		OverflowView.SetTextAlignment("CENTER", "CENTER")
		OverflowView.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
		mBase.AddView(OverflowView, 0, 0, 1dip, 1dip)
	End If
	OverflowView.Visible = True
	Dim forcedSize As Int = IIf(mAvatarSize > 0, Max(16dip, mAvatarSize), 0)
	Dim sz As Int = IIf(forcedSize > 0, forcedSize, Max(16dip, mItemSize))
	Dim y As Int = TopY + Max(0, (HostH - sz) / 2)
	OverflowView.SetLayoutAnimated(0, StartX, y, sz, sz)
	OverflowView.Text = "+" & extra
	OverflowView.TextSize = Max(10, Min(16, sz / 3))
	OverflowView.SetColorAndBorder(B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(229, 231, 235)), mBorderWidth, BorderColor, sz / 2)
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
	Dim r As Float = Min(v.Width, v.Height) / 2
	v.SetColorAndBorder(xui.Color_Transparent, mBorderWidth, BorderColor, r)
	Dim avatarObj As Object = Item.GetDefault("avatar", Null)
	If avatarObj <> Null Then
		If mAvatarSize > 0 And xui.SubExists(avatarObj, "setAvatarSize", 1) Then CallSub2(avatarObj, "setAvatarSize", mAvatarSize)
		If xui.SubExists(avatarObj, "setRingWidth", 1) Then CallSub2(avatarObj, "setRingWidth", mBorderWidth)
		If xui.SubExists(avatarObj, "setRingColor", 1) Then CallSub2(avatarObj, "setRingColor", BorderColor)
	End If
End Sub

Private Sub ResolveBorderColor As Int
	If mBorderColor <> 0 Then Return mBorderColor
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
