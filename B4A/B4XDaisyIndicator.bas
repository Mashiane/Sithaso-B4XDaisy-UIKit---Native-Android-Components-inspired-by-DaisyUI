B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)

#DesignerProperty: Key: HorizontalPlacement, DisplayName: Horizontal Placement, FieldType: String, DefaultValue: end, List: start|center|end, Description: Horizontal indicator placement.
#DesignerProperty: Key: VerticalPlacement, DisplayName: Vertical Placement, FieldType: String, DefaultValue: top, List: top|middle|bottom, Description: Vertical indicator placement.
#DesignerProperty: Key: OffsetX, DisplayName: Offset X, FieldType: String, DefaultValue: 0, Description: Horizontal offset (Tailwind/CSS size token).
#DesignerProperty: Key: OffsetY, DisplayName: Offset Y, FieldType: String, DefaultValue: 0, Description: Vertical offset (Tailwind/CSS size token).
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue:, Description: Indicator text content.
#DesignerProperty: Key: Counter, DisplayName: Counter, FieldType: Boolean, DefaultValue: False, Description: Counter mode: 0 hides, 1..99 shows number, >99 shows 99+.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Badge variant for indicator content.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: sm, List: xs|sm|md|lg|xl, Description: Badge size token for indicator content.
#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: Optional SVG icon asset.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Rounded mode for indicator content.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional text color override (0 = auto).
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional background color override (0 = auto).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide indicator.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private mHorizontalPlacement As String = "end"
	Private mVerticalPlacement As String = "top"
	Private mOffsetX As Float = 0dip
	Private mOffsetY As Float = 0dip
	Private mText As String = ""
	Private mCounter As Boolean = False
	Private mVariant As String = "none"
	Private mSize As String = "sm"
	Private mIconAsset As String = ""
	Private mRounded As String = "rounded"
	Private mTextColor As Int = 0
	Private mBackgroundColor As Int = 0
	Private mVisible As Boolean = True

	Private Surface As B4XView
	Private BadgeComp As B4XDaisyBadge
	Private BadgeView As B4XView
	Private mTarget As B4XView
	Private mResolvedVisible As Boolean = True
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim p As Panel
	p.Initialize("")
	Surface = p
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	DisableClipping(mBase)
	DisableClipping(Surface)

	ApplyDesignerProps(Props)
	RebuildBadge
	mBase.Visible = mResolvedVisible
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map = BuildRuntimeProps
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
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

	Dim props As Map = BuildRuntimeProps

	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Parent.AddView(mBase, Left, Top, w, h)
	BringSelfToFront
	Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
	' Preserve runtime state when recreating indicator through DesignerCreateView.
	Dim props As Map
	props.Initialize
	props.Put("HorizontalPlacement", mHorizontalPlacement)
	props.Put("VerticalPlacement", mVerticalPlacement)
	props.Put("OffsetX", ResolvePxSizeSpec(mOffsetX))
	props.Put("OffsetY", ResolvePxSizeSpec(mOffsetY))
	props.Put("Text", mText)
	props.Put("Counter", mCounter)
	props.Put("Variant", mVariant)
	props.Put("Size", mSize)
	props.Put("IconAsset", mIconAsset)
	props.Put("Rounded", mRounded)
	props.Put("TextColor", mTextColor)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("Visible", mVisible)
	Return props
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(0, Round(SizeDip / 1dip))
	Return px & "px"
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
	Return mBase.IsInitialized And Surface.IsInitialized And BadgeView.IsInitialized
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	Surface.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
	RefreshPlacement
End Sub

Public Sub AttachToTarget(Target As B4XView)
	mTarget = Target
	RefreshPlacement
End Sub

Public Sub DetachTarget
	Dim empty As B4XView
	mTarget = empty
	RefreshPlacement
End Sub

Public Sub RefreshPlacement
	If mBase.IsInitialized = False Then Return
	If mTarget.IsInitialized Then SyncToTarget
	If BadgeView.IsInitialized = False Then Return
	ApplyBadgeAppearance
	LayoutIndicatorItem
	mBase.Visible = mResolvedVisible
	BringSelfToFront
End Sub

Private Sub SyncToTarget
	If mTarget.IsInitialized = False Then Return
	Dim parent As B4XView = mTarget.Parent
	If parent.IsInitialized = False Then Return

	DisableClipping(parent)
	DisableClipping(mTarget)
	DisableClipping(mBase)
	DisableClipping(Surface)

	Dim tw As Int = Max(1dip, mTarget.Width)
	Dim th As Int = Max(1dip, mTarget.Height)

	If mBase.Parent.IsInitialized = False Then
		parent.AddView(mBase, mTarget.Left, mTarget.Top, tw, th)
	Else If mBase.Parent <> parent Then
		mBase.RemoveViewFromParent
		parent.AddView(mBase, mTarget.Left, mTarget.Top, tw, th)
	Else
		mBase.SetLayoutAnimated(0, mTarget.Left, mTarget.Top, tw, th)
	End If
End Sub

Private Sub RebuildBadge
	If Surface.IsInitialized = False Then Return
	Surface.RemoveAllViews

	Dim b As B4XDaisyBadge
	b.Initialize(Me, "badge")
	BadgeComp = b
	BadgeView = BadgeComp.AddToParent(Surface, 0, 0, 0, 0)
	ApplyBadgeAppearance
	LayoutIndicatorItem
End Sub

Private Sub ApplyBadgeAppearance
	If BadgeComp.IsInitialized = False Then Return
	Dim state As Map = ResolveDisplayState
	If mCounter Then
		BadgeComp.setSize("sm")
		BadgeComp.setPadding("p-0")
		BadgeComp.setWidth("6")
		BadgeComp.setHeight("6")
	Else
		BadgeComp.setSize(mSize)
		BadgeComp.setPadding("")
	End If
	BadgeComp.setStyle("solid")
	BadgeComp.setShadow("none")
	BadgeComp.setClosable(False)
	BadgeComp.setToggle(False)
	BadgeComp.setTextCentered(True)
	BadgeComp.setVariant(B4XDaisyVariants.NormalizeVariant(mVariant))
	BadgeComp.setText(state.GetDefault("text", ""))
	BadgeComp.setIconAsset(mIconAsset)
	BadgeComp.setRounded(ResolveRoundedMode)
	BadgeComp.setTag(mTag)
	mResolvedVisible = state.GetDefault("visible", mVisible)

	If mBackgroundColor <> 0 Then BadgeComp.setBackgroundColor(mBackgroundColor)
	If mTextColor <> 0 Then BadgeComp.setTextColor(mTextColor)
End Sub

Private Sub ResolveDisplayState As Map
	Dim displayText As String = IIf(mText = Null, "", mText)
	Dim visible As Boolean = mVisible
	If mCounter Then
		Dim n As Long = ParseCounterNumber(displayText, 0)
		If n <= 0 Then
			displayText = "0"
			visible = False
		Else If n > 99 Then
			displayText = "99+"
		Else
			displayText = NumberFormat2(n, 1, 0, 0, False)
		End If
	End If
	Return CreateMap("text": displayText, "visible": visible)
End Sub

Private Sub ParseCounterNumber(Value As String, DefaultValue As Long) As Long
	Dim s As String = IIf(Value = Null, "", Value.Trim)
	If s.Length = 0 Then Return DefaultValue
	If IsNumber(s) Then Return s
	Return DefaultValue
End Sub

Private Sub ResolveRoundedMode As String
	If mCounter Then Return "rounded-full"
	If HasEmptyContent Then Return "rounded-full"
	Return NormalizeRounded(mRounded)
End Sub

Private Sub HasEmptyContent As Boolean
	Dim t As String = IIf(mText = Null, "", mText.Trim)
	Dim i As String = IIf(mIconAsset = Null, "", mIconAsset.Trim)
	Return t.Length = 0 And i.Length = 0
End Sub

Private Sub LayoutIndicatorItem
	If mBase.IsInitialized = False Or BadgeView.IsInitialized = False Then Return
	Dim hostW As Float = Max(1dip, mBase.Width)
	Dim hostH As Float = Max(1dip, mBase.Height)
	Dim cw As Float = Max(1dip, BadgeView.Width)
	Dim ch As Float = Max(1dip, BadgeView.Height)

	Dim left As Float
	Select Case mHorizontalPlacement
		Case "start"
			left = -cw / 2
		Case "center"
			left = (hostW - cw) / 2
		Case Else
			left = hostW - (cw / 2)
	End Select

	Dim top As Float
	Select Case mVerticalPlacement
		Case "bottom"
			top = hostH - (ch / 2)
		Case "middle"
			top = (hostH - ch) / 2
		Case Else
			top = -ch / 2
	End Select

	left = left + mOffsetX
	top = top + mOffsetY

	BadgeView.SetLayoutAnimated(0, left, top, cw, ch)
	BadgeComp.Base_Resize(cw, ch)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mHorizontalPlacement = NormalizeHorizontalPlacement(GetPropString(Props, "HorizontalPlacement", "end"))
	mVerticalPlacement = NormalizeVerticalPlacement(GetPropString(Props, "VerticalPlacement", "top"))
	mOffsetX = GetPropSizeDip(Props, "OffsetX", "0")
	mOffsetY = GetPropSizeDip(Props, "OffsetY", "0")
	mText = GetPropString(Props, "Text", "")
	mCounter = GetPropBool(Props, "Counter", False)
	mVariant = B4XDaisyVariants.NormalizeVariant(GetPropString(Props, "Variant", "none"))
	mSize = NormalizeSize(GetPropString(Props, "Size", "sm"))
	mIconAsset = GetPropString(Props, "IconAsset", "").Trim
	mRounded = NormalizeRounded(GetPropString(Props, "Rounded", "rounded"))
	mTextColor = B4XDaisyVariants.GetPropInt(Props, "TextColor", 0x00000000)
	mBackgroundColor = B4XDaisyVariants.GetPropInt(Props, "BackgroundColor", 0x00000000)
	mVisible = GetPropBool(Props, "Visible", True)
End Sub







Public Sub setHorizontalPlacement(Value As String)
	mHorizontalPlacement = NormalizeHorizontalPlacement(Value)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getHorizontalPlacement As String
	Return mHorizontalPlacement
End Sub

Public Sub setVerticalPlacement(Value As String)
	mVerticalPlacement = NormalizeVerticalPlacement(Value)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getVerticalPlacement As String
	Return mVerticalPlacement
End Sub

Public Sub setOffsetX(Value As Object)
	mOffsetX = B4XDaisyVariants.TailwindSizeToDip(Value, mOffsetX)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getOffsetX As Float
	Return mOffsetX
End Sub

Public Sub setOffsetY(Value As Object)
	mOffsetY = B4XDaisyVariants.TailwindSizeToDip(Value, mOffsetY)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getOffsetY As Float
	Return mOffsetY
End Sub

Public Sub setText(Value As String)
	mText = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setCounter(Value As Boolean)
	mCounter = Value
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getCounter As Boolean
	Return mCounter
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	' Reset manual overrides to ensure variant colors take full effect.
	mTextColor = 0
	mBackgroundColor = 0
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setSize(Value As String)
	mSize = NormalizeSize(Value)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setIconAsset(Value As String)
	mIconAsset = IIf(Value = Null, "", Value.Trim)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getIconAsset As String
	Return mIconAsset
End Sub

Public Sub setRounded(Value As String)
	mRounded = NormalizeRounded(Value)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackgroundColor = Value
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim fallback As Int = mTextColor
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, fallback)
	setTextColor(c)
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
	Dim fallback As Int = mBackgroundColor
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, fallback)
	setBackgroundColor(c)
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized = False Then Return
	mBase.Tag = Me
	If BadgeComp.IsInitialized Then BadgeComp.setTag(mTag)
End Sub

Public Sub getTag As Object
	Return mTag
End Sub



Private Sub badge_Click(Payload As Object)
	RaiseClick
End Sub

Private Sub RaiseClick
	If mCallBack = Null Then Return
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub

Private Sub NormalizeHorizontalPlacement(Value As String) As String
	If Value = Null Then Return "end"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "start", "center", "end"
			Return s
		Case Else
			Return "end"
	End Select
End Sub

Private Sub NormalizeVerticalPlacement(Value As String) As String
	If Value = Null Then Return "top"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "top", "middle", "bottom"
			Return s
		Case Else
			Return "top"
	End Select
End Sub

Private Sub NormalizeSize(Value As String) As String
	If Value = Null Then Return "sm"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "xs", "sm", "md", "lg", "xl"
			Return s
		Case Else
			Return "sm"
	End Select
End Sub

Private Sub NormalizeRounded(Value As String) As String
	If Value = Null Then Return "rounded"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "theme", "rounded-none", "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full"
			Return s
		Case Else
			Return "rounded"
	End Select
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Object) As Float
	Dim baseDip As Float = B4XDaisyVariants.TailwindSizeToDip(DefaultDipValue, 0)
	If Props.IsInitialized = False Then Return baseDip
	If Props.ContainsKey(Key) = False Then Return baseDip
	Dim raw As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(raw, baseDip)
End Sub

Private Sub BringSelfToFront
	If mBase.IsInitialized = False Then Return
	#If B4A
	Try
		Dim jo As JavaObject = mBase
		jo.RunMethod("bringToFront", Null)
	Catch
	End Try
	#End If
End Sub

Private Sub DisableClipping(v As B4XView)
	If v.IsInitialized = False Then Return
	#If B4A
	Try
		Dim jo As JavaObject = v
		jo.RunMethod("setClipChildren", Array(False))
		jo.RunMethod("setClipToPadding", Array(False))
	Catch
	End Try
	#Else
	Dim ignore As Object = v
	#End If
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
