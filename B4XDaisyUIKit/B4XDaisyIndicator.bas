B4A=true
Group=Default Group\DaisyUIKit
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
#DesignerProperty: Key: CapValue, DisplayName: Cap Value, FieldType: Int, DefaultValue: 99, Description: Numeric cap - values above this display as cap+ (0 disables capping).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Badge variant for indicator content.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: sm, List: xs|sm|md|lg|xl, Description: Badge size token for indicator content.
#DesignerProperty: Key: IconAsset, DisplayName: Icon Asset, FieldType: String, DefaultValue:, Description: Optional SVG icon asset.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Rounded mode for indicator content.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional text color override (0 = auto).
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional background color override (0 = auto).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide indicator.
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: False, Description: When True, the indicator handles clicks via the Click event. When False (default), touches pass through to the parent.

#IgnoreWarnings:12,9
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
	Private mCapValue As Int = 99

	Private Surface As B4XView
	Private BadgeComp As B4XDaisyBadge
	Private BadgeView As B4XView
	Private mTarget As B4XView
	Private mResolvedVisible As Boolean = True
	Private mClickable As Boolean = False
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim p As Panel
	p.Initialize("")
	Surface = p
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	B4XDaisyVariants.DisableClipping(mBase)
	B4XDaisyVariants.DisableClipping(Surface)

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
		#Else If B4J
		mBase.Enabled = False
		If Surface.IsInitialized Then Surface.Enabled = False
		#Else If B4i
		mBase.Enabled = False
		If Surface.IsInitialized Then Surface.Enabled = False
		#End If
		' Propagate to child badge component
		If BadgeComp.IsInitialized Then BadgeComp.setClickable(False)
	End If
	RebuildBadge
	mBase.Visible = mResolvedVisible
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Private Sub BringSelfToFront
	If mBase.IsInitialized = False Then Return
	#If B4A
	Try
		Dim jo As JavaObject = mBase
		jo.RunMethod("bringToFront", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyIndicator.BringSelfToFront: " & LastException.Message)
	End Try 'ignore
	#End If
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

	Dim props As Map = BuildRuntimeProps

	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
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
	props.Put("CapValue", mCapValue)
	Return props
End Sub

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(0, Round(fSizeDip / 1dip))
	Return px & "px"
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
	Return mBase.IsInitialized And Surface.IsInitialized And BadgeView.IsInitialized
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Surface.SetLayoutAnimated(0, 0, 0, Max(1dip, dWidth), Max(1dip, dHeight))
	RefreshPlacement
	inResize = False
End Sub

Public Sub AttachTo(vTarget As B4XView)
	mTarget = vTarget
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

B4XDaisyVariants.DisableClipping(parent)
    B4XDaisyVariants.DisableClipping(mTarget)
    B4XDaisyVariants.DisableClipping(mBase)
    B4XDaisyVariants.DisableClipping(Surface)

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
	BadgeComp.setCapValue(0) ' Disable badge-level capping; indicator handles it
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
			displayText = ""
			visible = False
		Else If n > mCapValue Then
			displayText = mCapValue & "+"
		Else
			displayText = NumberFormat2(n, 1, 0, 0, False)
		End If
	End If
	Return CreateMap("text": displayText, "visible": visible)
End Sub

Private Sub ParseCounterNumber(sValue As String, lDefaultValue As Long) As Long
	Dim s As String = IIf(sValue = Null, "", sValue.Trim)
	If s.Length = 0 Then Return lDefaultValue
	If IsNumber(s) Then Return s
	Return lDefaultValue
End Sub

Private Sub ResolveRoundedMode As String
	If mCounter Then Return "rounded-full"
	If HasEmptyContent Then Return "rounded-full"
	Return B4XDaisyVariants.NormalizeRounded(mRounded)
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

Private Sub ApplyDesignerProps(mProps As Map)
	mHorizontalPlacement = B4XDaisyVariants.NormalizeHorizontalPlacement(B4XDaisyVariants.GetPropString(mProps, "HorizontalPlacement", mHorizontalPlacement))
	mVerticalPlacement = B4XDaisyVariants.NormalizeVerticalPlacement(B4XDaisyVariants.GetPropString(mProps, "VerticalPlacement", mVerticalPlacement))
	mOffsetX = B4XDaisyVariants.GetPropSizeDip(mProps, "OffsetX", "0")
	mOffsetY = B4XDaisyVariants.GetPropSizeDip(mProps, "OffsetY", "0")
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mCounter = B4XDaisyVariants.GetPropBool(mProps, "Counter", mCounter)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mIconAsset = B4XDaisyVariants.GetPropString(mProps, "IconAsset", mIconAsset).Trim
	mRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded))
	mTextColor = B4XDaisyVariants.GetPropInt(mProps, "TextColor", mTextColor)
	mBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "BackgroundColor", mBackgroundColor)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mCapValue = B4XDaisyVariants.GetPropInt(mProps, "CapValue", mCapValue)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)
End Sub







Public Sub setHorizontalPlacement(sValue As String)
	mHorizontalPlacement = B4XDaisyVariants.NormalizeHorizontalPlacement(sValue)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getHorizontalPlacement As String
	Return mHorizontalPlacement
End Sub

Public Sub setVerticalPlacement(sValue As String)
	mVerticalPlacement = B4XDaisyVariants.NormalizeVerticalPlacement(sValue)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getVerticalPlacement As String
	Return mVerticalPlacement
End Sub

Public Sub setOffsetX(oValue As Object)
	mOffsetX = B4XDaisyVariants.TailwindSizeToDip(oValue, mOffsetX)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getOffsetX As Float
	Return mOffsetX
End Sub

Public Sub setOffsetY(oValue As Object)
	mOffsetY = B4XDaisyVariants.TailwindSizeToDip(oValue, mOffsetY)
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getOffsetY As Float
	Return mOffsetY
End Sub

Public Sub setText(sValue As String)
	mText = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setCounter(bValue As Boolean)
	mCounter = bValue
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getCounter As Boolean
	Return mCounter
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
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

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setIconAsset(sValue As String)
	mIconAsset = IIf(sValue = Null, "", sValue.Trim)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getIconAsset As String
	Return mIconAsset
End Sub

Public Sub setRounded(sValue As String)
	mRounded = B4XDaisyVariants.NormalizeRounded(sValue)
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	Dim fallback As Int = mTextColor
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, fallback)
	setTextColor(c)
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
	Dim fallback As Int = mBackgroundColor
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, fallback)
	setBackgroundColor(c)
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized = False Then Return
	RefreshPlacement
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
	If mBase.IsInitialized = False Then Return
	mBase.Tag = Me
	If BadgeComp.IsInitialized Then BadgeComp.setTag(mTag)
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setCapValue(iValue As Int)
	mCapValue = iValue
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

Public Sub getCapValue As Int
	Return mCapValue
End Sub

' Set the indicator text to a numeric value. Useful for counter mode.
Public Sub setValue(iValue As Int)
	mText = "" & iValue
	If mBase.IsInitialized = False Then Return
	RebuildBadge
	RefreshPlacement
End Sub

' Get the current indicator value as an integer (returns 0 if text is not numeric).
Public Sub getValue As Int
	Return ParseCounterNumber(mText, 0)
End Sub



Private Sub badge_Click(oPayload As Object)
	RaiseClick
End Sub

Private Sub RaiseClick
	If mClickable = False Then Return
	If mCallBack = Null Then Return
	If mEventName <> "" Then
		If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
			CallSub2(mCallBack, mEventName & "_Click", mTag)
			Return
		Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
			CallSub(mCallBack, mEventName & "_Click")
			Return
		End If
	End If
	
	' Fallback: forward click to target if target is inside a clickable wrapper (like Navbar's xClick)
	If mTarget <> Null Then
		If mTarget.IsInitialized Then
			Dim p As B4XView = mTarget.Parent
			If p <> Null Then
				If p.IsInitialized And p.Tag <> Null Then
					If p.Tag Is String Then
						Dim targetEventName As String = p.Tag
						If targetEventName <> "" Then
							If xui.SubExists(mCallBack, targetEventName & "_Click", 0) Then
								CallSub(mCallBack, targetEventName & "_Click")
								Return
							End If
						End If
					End If
				End If
			End If
			
			' If target itself has a tag that matches an event handler
			If mTarget.Tag <> Null Then
				If mTarget.Tag Is String Then
					Dim targetEventName As String = mTarget.Tag
					If targetEventName <> "" Then
						If xui.SubExists(mCallBack, targetEventName & "_Click", 0) Then
							CallSub(mCallBack, targetEventName & "_Click")
							Return
						End If
					End If
				End If
			End If
		End If
	End If
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' Sets whether the indicator intercepts touch events.
''' When False, touches pass through to the parent view (e.g. a list row).
''' When True, the indicator handles clicks normally via the Click event.
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
	End If
	#Else If B4J
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If Surface.IsInitialized Then Surface.Enabled = bValue
	End If
	#Else If B4i
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If Surface.IsInitialized Then Surface.Enabled = bValue
	End If
	#End If
	' Propagate to child badge component
	If BadgeComp.IsInitialized Then BadgeComp.setClickable(bValue)
End Sub

''' Gets whether the indicator is clickable.
Public Sub getClickable As Boolean
	Return mClickable
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

' Increments the current text/counter value by 1. Returns the new value.
Public Sub Increment As Int
	Return IncrementBy(1)
End Sub

' Increments the current text/counter value by the given amount. Returns the new value.
Public Sub IncrementBy(iAmount As Int) As Int
	Dim current As Long = ParseCounterNumber(mText, 0)
	Dim newVal As Long = current + iAmount
	setText(newVal)
	Return newVal
End Sub

' Decrements the current text/counter value by 1 (minimum 0). Returns the new value.
Public Sub Decrement As Int
	Return DecrementBy(1)
End Sub

' Decrements the current text/counter value by the given amount (minimum 0). Returns the new value.
Public Sub DecrementBy(iAmount As Int) As Int
	Dim current As Long = ParseCounterNumber(mText, 0)
	Dim newVal As Long = Max(0, current - iAmount)
	setText(newVal)
	Return newVal
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

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
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

#End Region
