B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XDaisyFlexPanel.bas
'Custom View wrapper around B4XDaisyFlexLayout v3
'Requires: B4XDaisyFlexLayout.bas (v3) + B4XDaisyFlexItem.bas

#Event: Ready
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: row, List: row|row-reverse|column|column-reverse
#DesignerProperty: Key: WrapMode, DisplayName: Wrap Mode, FieldType: String, DefaultValue: wrap, List: nowrap|wrap|wrap-reverse
#DesignerProperty: Key: GapX, DisplayName: Gap X, FieldType: Int, DefaultValue: 8
#DesignerProperty: Key: GapY, DisplayName: Gap Y, FieldType: Int, DefaultValue: 8
#DesignerProperty: Key: PaddingLeft, DisplayName: Padding Left, FieldType: Int, DefaultValue: 8
#DesignerProperty: Key: PaddingTop, DisplayName: Padding Top, FieldType: Int, DefaultValue: 8
#DesignerProperty: Key: PaddingRight, DisplayName: Padding Right, FieldType: Int, DefaultValue: 8
#DesignerProperty: Key: PaddingBottom, DisplayName: Padding Bottom, FieldType: Int, DefaultValue: 8
#DesignerProperty: Key: JustifyContent, DisplayName: Justify Content, FieldType: String, DefaultValue: start, List: start|center|end|space-between|space-around|space-evenly|flex-start|flex-end
#DesignerProperty: Key: AlignItems, DisplayName: Align Items, FieldType: String, DefaultValue: start, List: start|center|end|stretch|baseline|flex-start|flex-end
#DesignerProperty: Key: AlignContent, DisplayName: Align Content, FieldType: String, DefaultValue: start, List: start|center|end|stretch|space-between|space-around|space-evenly|flex-start|flex-end
#DesignerProperty: Key: AnimateDuration, DisplayName: Animate Duration (ms), FieldType: Int, DefaultValue: 0
#DesignerProperty: Key: AllowShrinkWhenWrap, DisplayName: Allow Shrink When Wrap, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: AutoRelayout, DisplayName: Auto Relayout, FieldType: Boolean, DefaultValue: True

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Private mEventName As String
    Private mCallBack As Object
    
    Public mBase As B4XView
    Private xpnlContent As B4XView
    
    Private mFlex As B4XDaisyFlexLayout
    
    'Internal config mirrors (runtime editable through property accessors)
    Private mDirection As String = "row"
    Private mWrapMode As String = "wrap"
    Private mGapX As Int = 8dip
    Private mGapY As Int = 8dip
    
    Private mPaddingLeft As Int = 8dip
    Private mPaddingTop As Int = 8dip
    Private mPaddingRight As Int = 8dip
    Private mPaddingBottom As Int = 8dip
    
    Private mJustifyContent As String = "start"
    Private mAlignItems As String = "start"
    Private mAlignContent As String = "start"
    
    Private mAnimateDuration As Int = 0
    Private mAllowShrinkWhenWrap As Boolean = False
    Private mAutoRelayout As Boolean = True
End Sub

Public Sub Initialize
End Sub

'Custom View initialization (Designer)
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    mBase.Tag = Me
    
    xpnlContent = xui.CreatePanel("")
    mBase.AddView(xpnlContent, 0, 0, mBase.Width, mBase.Height)
    
    'Read designer props
    mDirection = B4XDaisyVariants.GetPropString(Props, "Direction", "row")
    mWrapMode = B4XDaisyVariants.GetPropString(Props, "WrapMode", "wrap")
    mGapX = DipOrInt(B4XDaisyVariants.GetPropInt(Props, "GapX", 8))
    mGapY = DipOrInt(B4XDaisyVariants.GetPropInt(Props, "GapY", 8))
    
    mPaddingLeft = DipOrInt(B4XDaisyVariants.GetPropInt(Props, "PaddingLeft", 8))
    mPaddingTop = DipOrInt(B4XDaisyVariants.GetPropInt(Props, "PaddingTop", 8))
    mPaddingRight = DipOrInt(B4XDaisyVariants.GetPropInt(Props, "PaddingRight", 8))
    mPaddingBottom = DipOrInt(B4XDaisyVariants.GetPropInt(Props, "PaddingBottom", 8))
    
    mJustifyContent = B4XDaisyVariants.GetPropString(Props, "JustifyContent", "start")
    mAlignItems = B4XDaisyVariants.GetPropString(Props, "AlignItems", "start")
    mAlignContent = B4XDaisyVariants.GetPropString(Props, "AlignContent", "start")
    
    mAnimateDuration = B4XDaisyVariants.GetPropInt(Props, "AnimateDuration", 0)
    mAllowShrinkWhenWrap = B4XDaisyVariants.GetPropBool(Props, "AllowShrinkWhenWrap", False)
    mAutoRelayout = B4XDaisyVariants.GetPropBool(Props, "AutoRelayout", True)
    
    'Initialize flex engine
    mFlex.Initialize(xpnlContent)
    ApplySettingsToFlex
    
    ' only attempt to raise Ready event if callback was provided
    If mCallBack <> Null And mEventName <> "" Then
        If xui.SubExists(mCallBack, mEventName & "_Ready", 0) Then
            CallSub(mCallBack, mEventName & "_Ready")
        End If
    End If
End Sub

'Code-only initialization helper (no Designer)
Public Sub InitForCode(Callback As Object, EventName As String, Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    mCallBack = Callback
    mEventName = EventName
    
    ' Ensure props maps matching types expected by DesignerCreateView (strings for enums, ints for numbers)
    Dim props As Map = CreateMap("Direction": mDirection, "WrapMode": mWrapMode, _
        "GapX": mGapX & "", "GapY": mGapY & "", "PaddingLeft": mPaddingLeft & "", "PaddingTop": mPaddingTop & "", _
        "PaddingRight": mPaddingRight & "", "PaddingBottom": mPaddingBottom & "", "JustifyContent": mJustifyContent, _
        "AlignItems": mAlignItems, "AlignContent": mAlignContent, "AnimateDuration": mAnimateDuration & "", _
        "AllowShrinkWhenWrap": mAllowShrinkWhenWrap & "", "AutoRelayout": mAutoRelayout & "")
    
    Dim p As Panel
    p.Initialize("")
    mBase = p
    Parent.AddView(mBase, Left, Top, Width, Height)
    DesignerCreateView(mBase, Null, props)
End Sub

'** helper for programmatic insertion **
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        ' use existing init logic
        InitForCode(mCallBack, mEventName, Parent, Left, Top, Width, Height)
    Else
        mBase.RemoveViewFromParent
        Parent.AddView(mBase, Left, Top, Width, Height)
    End If
    Return mBase
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
    If xpnlContent.IsInitialized Then
        xpnlContent.SetLayoutAnimated(0, 0, 0, Width, Height)
        If mAutoRelayout Then Relayout
    End If
End Sub

'B4X custom view plumbing
Public Sub getView As B4XView
    Return mBase
End Sub

Public Sub getIsInitialized As Boolean
    Return mFlex.IsInitialized
End Sub

'Content panel access (add real child views here)
Public Sub GetContentPanel As B4XView
    Return xpnlContent
End Sub

'========================
' PUBLIC LAYOUT API
'========================

Public Sub Relayout
    If mFlex.IsInitialized = False Then Return
    ApplySettingsToFlex
    mFlex.Relayout
End Sub

''' <summary>
''' Gets the calculated content width after Relayout.
''' </summary>
Public Sub GetMeasuredWidth As Int
    Return mFlex.GetContentWidth
End Sub

''' <summary>
''' Gets the calculated content height after Relayout.
''' </summary>
Public Sub GetMeasuredHeight As Int
    Return mFlex.GetContentHeight
End Sub

Public Sub SetPadding(All As Int)
    mPaddingLeft = All
    mPaddingTop = All
    mPaddingRight = All
    mPaddingBottom = All
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetPaddingLTRB(Left As Int, Top As Int, Right As Int, Bottom As Int)
    mPaddingLeft = Left
    mPaddingTop = Top
    mPaddingRight = Right
    mPaddingBottom = Bottom
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetGap(X As Int, Y As Int)
    mGapX = X
    mGapY = Y
    If mAutoRelayout Then Relayout
End Sub

Public Sub setDirection(Value As String)
    mDirection = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getDirection As String
    Return mDirection
End Sub

Public Sub setWrapMode(Value As String)
    mWrapMode = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getWrapMode As String
    Return mWrapMode
End Sub

Public Sub setJustifyContent(Value As String)
    mJustifyContent = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getJustifyContent As String
    Return mJustifyContent
End Sub

Public Sub setAlignItems(Value As String)
    mAlignItems = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAlignItems As String
    Return mAlignItems
End Sub

Public Sub setAlignContent(Value As String)
    mAlignContent = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAlignContent As String
    Return mAlignContent
End Sub

Public Sub setGapX(Value As Int)
    mGapX = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getGapX As Int
    Return mGapX
End Sub

Public Sub setGapY(Value As Int)
    mGapY = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getGapY As Int
    Return mGapY
End Sub

Public Sub setPaddingLeft(Value As Int)
    mPaddingLeft = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingLeft As Int
    Return mPaddingLeft
End Sub

Public Sub setPaddingTop(Value As Int)
    mPaddingTop = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingTop As Int
    Return mPaddingTop
End Sub

Public Sub setPaddingRight(Value As Int)
    mPaddingRight = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingRight As Int
    Return mPaddingRight
End Sub

Public Sub setPaddingBottom(Value As Int)
    mPaddingBottom = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingBottom As Int
    Return mPaddingBottom
End Sub

Public Sub setAnimateDuration(Value As Int)
    mAnimateDuration = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAnimateDuration As Int
    Return mAnimateDuration
End Sub

Public Sub setAllowShrinkWhenWrap(Value As Boolean)
    mAllowShrinkWhenWrap = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAllowShrinkWhenWrap As Boolean
    Return mAllowShrinkWhenWrap
End Sub

Public Sub setAutoRelayout(Value As Boolean)
    mAutoRelayout = Value
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAutoRelayout As Boolean
    Return mAutoRelayout
End Sub

'========================
' CHILD MANAGEMENT HELPERS
'========================

'Adds an existing B4XView to content panel
Public Sub AddItem(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    Try
        v.RemoveViewFromParent
    Catch
        ' Ignore if it has no parent yet
    End Try
    xpnlContent.AddView(v, Left, Top, Width, Height)
    If mAutoRelayout Then Relayout
End Sub

'Adds and returns fluent helper for immediate chaining
Public Sub AddItemEx(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XDaisyFlexItem
    xpnlContent.AddView(v, Left, Top, Width, Height)
    Dim it As B4XDaisyFlexItem
    it.Initialize(Me, v)
    Return it
End Sub

'Returns fluent helper for one child item
Public Sub Item(v As B4XView) As B4XDaisyFlexItem
    Dim it As B4XDaisyFlexItem
    it.Initialize(Me, v)
    Return it
End Sub

Public Sub RemoveItem(v As B4XView)
    v.RemoveViewFromParent
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearItems
    For i = xpnlContent.NumberOfViews - 1 To 0 Step -1
        xpnlContent.GetView(i).RemoveViewFromParent
    Next
    mFlex.ClearAllItemMeta
    If mAutoRelayout Then Relayout
End Sub

Public Sub getNumberOfItems As Int
    Return xpnlContent.NumberOfViews
End Sub

Public Sub GetItem(Index As Int) As B4XView
    Return xpnlContent.GetView(Index)
End Sub

'========================
' PER-ITEM FLEX API (passthrough)
'========================

Public Sub SetItemFlexEx(v As B4XView, Grow As Float, Shrink As Float, MinW As Int, MaxW As Int, MinH As Int, MaxH As Int)
    mFlex.SetItemFlexEx(v, Grow, Shrink, MinW, MaxW, MinH, MaxH)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemBasis(v As B4XView, BasisW As Int, BasisH As Int)
    mFlex.SetItemBasis(v, BasisW, BasisH)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemBasisPercent(v As B4XView, PercentMain As Float, PercentCross As Float)
    mFlex.SetItemBasisPercent(v, PercentMain, PercentCross)
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearItemBasisPercent(v As B4XView)
    mFlex.ClearItemBasisPercent(v)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemMargins(v As B4XView, Left As Int, Top As Int, Right As Int, Bottom As Int)
    mFlex.SetItemMargins(v, Left, Top, Right, Bottom)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemAlignSelf(v As B4XView, AlignSelf As String)
    mFlex.SetItemAlignSelf(v, AlignSelf)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemOrder(v As B4XView, OrderValue As Int)
    mFlex.SetItemOrder(v, OrderValue)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemWrapBefore(v As B4XView, Value As Boolean)
    mFlex.SetItemWrapBefore(v, Value)
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearItemMeta(v As B4XView)
    mFlex.ClearItemMeta(v)
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearAllItemMeta
    mFlex.ClearAllItemMeta
    If mAutoRelayout Then Relayout
End Sub

'========================
' INTERNAL / ADVANCED NO-RELAYOUT ITEM SETTERS
'Used by B4XDaisyFlexItem.ApplyNoRelayout for batching
'========================

Public Sub SetItemFlexEx_NoRelayout(v As B4XView, Grow As Float, Shrink As Float, MinW As Int, MaxW As Int, MinH As Int, MaxH As Int)
    mFlex.SetItemFlexEx(v, Grow, Shrink, MinW, MaxW, MinH, MaxH)
End Sub

Public Sub SetItemBasis_NoRelayout(v As B4XView, BasisW As Int, BasisH As Int)
    mFlex.SetItemBasis(v, BasisW, BasisH)
End Sub

Public Sub SetItemBasisPercent_NoRelayout(v As B4XView, PercentMain As Float, PercentCross As Float)
    mFlex.SetItemBasisPercent(v, PercentMain, PercentCross)
End Sub

Public Sub ClearItemBasisPercent_NoRelayout(v As B4XView)
    mFlex.ClearItemBasisPercent(v)
End Sub

Public Sub SetItemMargins_NoRelayout(v As B4XView, Left As Int, Top As Int, Right As Int, Bottom As Int)
    mFlex.SetItemMargins(v, Left, Top, Right, Bottom)
End Sub

Public Sub SetItemAlignSelf_NoRelayout(v As B4XView, AlignSelf As String)
    mFlex.SetItemAlignSelf(v, AlignSelf)
End Sub

Public Sub SetItemOrder_NoRelayout(v As B4XView, OrderValue As Int)
    mFlex.SetItemOrder(v, OrderValue)
End Sub

Public Sub SetItemWrapBefore_NoRelayout(v As B4XView, Value As Boolean)
    mFlex.SetItemWrapBefore(v, Value)
End Sub

'========================
' BATCH UPDATE HELPERS
'========================

Public Sub BeginUpdate
    mAutoRelayout = False
End Sub

Public Sub EndUpdate(DoRelayout As Boolean)
    mAutoRelayout = True
    If DoRelayout Then Relayout
End Sub

'========================
' INTERNAL
'========================

Private Sub ApplySettingsToFlex
    mFlex.Direction = mDirection
    mFlex.WrapMode = mWrapMode
    
    'legacy bool mirror for compatibility inside flex class
    mFlex.Wrap = (mWrapMode.ToLowerCase <> "nowrap")
    
    mFlex.GapX = mGapX
    mFlex.GapY = mGapY
    
    mFlex.PaddingLeft = mPaddingLeft
    mFlex.PaddingTop = mPaddingTop
    mFlex.PaddingRight = mPaddingRight
    mFlex.PaddingBottom = mPaddingBottom
    
    mFlex.JustifyContent = mJustifyContent
    mFlex.AlignItems = mAlignItems
    mFlex.AlignContent = mAlignContent
    
    mFlex.AnimateDuration = mAnimateDuration
    mFlex.AllowShrinkWhenWrap = mAllowShrinkWhenWrap
End Sub

'Interpret designer integer values as dip units (spacing-focused props)
Private Sub DipOrInt(v As Int) As Int
    Return DipToCurrent(v)
End Sub
