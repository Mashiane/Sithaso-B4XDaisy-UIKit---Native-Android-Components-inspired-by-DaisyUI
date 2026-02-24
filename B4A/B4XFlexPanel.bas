B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XFlexPanel.bas
'Custom View wrapper around B4XFlexLayout v3
'Requires: B4XFlexLayout.bas (v3) + B4XFlexItem.bas

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
#DesignerProperty: Key: AlignItems, DisplayName: Align Items, FieldType: String, DefaultValue: start, List: start|center|end|stretch|flex-start|flex-end
#DesignerProperty: Key: AlignContent, DisplayName: Align Content, FieldType: String, DefaultValue: start, List: start|center|end|stretch|space-between|space-around|space-evenly|flex-start|flex-end
#DesignerProperty: Key: AnimateDuration, DisplayName: Animate Duration (ms), FieldType: Int, DefaultValue: 0
#DesignerProperty: Key: AllowShrinkWhenWrap, DisplayName: Allow Shrink When Wrap, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: AutoRelayout, DisplayName: Auto Relayout, FieldType: Boolean, DefaultValue: True

Sub Class_Globals
    Private xui As XUI
    Private mEventName As String
    Private mCallBack As Object
    
    Public mBase As B4XView
    Private xpnlContent As B4XView
    
    Private mFlex As B4XFlexLayout
    
    'Public config mirrors (runtime editable)
    Public Direction As String = "row"
    Public WrapMode As String = "wrap"
    Public GapX As Int = 8dip
    Public GapY As Int = 8dip
    
    Public PaddingLeft As Int = 8dip
    Public PaddingTop As Int = 8dip
    Public PaddingRight As Int = 8dip
    Public PaddingBottom As Int = 8dip
    
    Public JustifyContent As String = "start"
    Public AlignItems As String = "start"
    Public AlignContent As String = "start"
    
    Public AnimateDuration As Int = 0
    Public AllowShrinkWhenWrap As Boolean = False
    Public AutoRelayout As Boolean = True
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
    Direction = GetPropStr(Props, "Direction", "row")
    WrapMode = GetPropStr(Props, "WrapMode", "wrap")
    GapX = DipOrInt(GetPropInt(Props, "GapX", 8))
    GapY = DipOrInt(GetPropInt(Props, "GapY", 8))
    
    PaddingLeft = DipOrInt(GetPropInt(Props, "PaddingLeft", 8))
    PaddingTop = DipOrInt(GetPropInt(Props, "PaddingTop", 8))
    PaddingRight = DipOrInt(GetPropInt(Props, "PaddingRight", 8))
    PaddingBottom = DipOrInt(GetPropInt(Props, "PaddingBottom", 8))
    
    JustifyContent = GetPropStr(Props, "JustifyContent", "start")
    AlignItems = GetPropStr(Props, "AlignItems", "start")
    AlignContent = GetPropStr(Props, "AlignContent", "start")
    
    AnimateDuration = GetPropInt(Props, "AnimateDuration", 0)
    AllowShrinkWhenWrap = GetPropBool(Props, "AllowShrinkWhenWrap", False)
    AutoRelayout = GetPropBool(Props, "AutoRelayout", True)
    
    'Initialize flex engine
    mFlex.Initialize(xpnlContent)
    ApplySettingsToFlex
    
    If xui.SubExists(mCallBack, mEventName & "_Ready", 0) Then
        CallSub(mCallBack, mEventName & "_Ready")
    End If
End Sub

'Code-only initialization helper (no Designer)
Public Sub InitForCode(Callback As Object, EventName As String, Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    mCallBack = Callback
    mEventName = EventName
    
    mBase = xui.CreatePanel("")
    Parent.AddView(mBase, Left, Top, Width, Height)
    
    xpnlContent = xui.CreatePanel("")
    mBase.AddView(xpnlContent, 0, 0, Width, Height)
    
    mFlex.Initialize(xpnlContent)
    ApplySettingsToFlex
    
    If xui.SubExists(mCallBack, mEventName & "_Ready", 0) Then
        CallSub(mCallBack, mEventName & "_Ready")
    End If
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
    If xpnlContent.IsInitialized Then
        xpnlContent.SetLayoutAnimated(0, 0, 0, Width, Height)
        If AutoRelayout Then Relayout
    End If
End Sub

'B4X custom view plumbing
Public Sub getBase As B4XView
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

Public Sub SetPadding(All As Int)
    PaddingLeft = All
    PaddingTop = All
    PaddingRight = All
    PaddingBottom = All
    If AutoRelayout Then Relayout
End Sub

Public Sub SetPaddingLTRB(Left As Int, Top As Int, Right As Int, Bottom As Int)
    PaddingLeft = Left
    PaddingTop = Top
    PaddingRight = Right
    PaddingBottom = Bottom
    If AutoRelayout Then Relayout
End Sub

Public Sub SetGap(X As Int, Y As Int)
    GapX = X
    GapY = Y
    If AutoRelayout Then Relayout
End Sub

Public Sub SetDirection(Value As String)
    Direction = Value
    If AutoRelayout Then Relayout
End Sub

Public Sub SetWrapMode(Value As String)
    WrapMode = Value
    If AutoRelayout Then Relayout
End Sub

Public Sub SetJustifyContent(Value As String)
    JustifyContent = Value
    If AutoRelayout Then Relayout
End Sub

Public Sub SetAlignItems(Value As String)
    AlignItems = Value
    If AutoRelayout Then Relayout
End Sub

Public Sub SetAlignContent(Value As String)
    AlignContent = Value
    If AutoRelayout Then Relayout
End Sub

'========================
' CHILD MANAGEMENT HELPERS
'========================

'Adds an existing B4XView to content panel
Public Sub AddItem(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    xpnlContent.AddView(v, Left, Top, Width, Height)
    If AutoRelayout Then Relayout
End Sub

'Adds and returns fluent helper for immediate chaining
Public Sub AddItemEx(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XFlexItem
    xpnlContent.AddView(v, Left, Top, Width, Height)
    Dim it As B4XFlexItem
    it.Initialize(Me, v)
    Return it
End Sub

'Returns fluent helper for one child item
Public Sub Item(v As B4XView) As B4XFlexItem
    Dim it As B4XFlexItem
    it.Initialize(Me, v)
    Return it
End Sub

Public Sub RemoveItem(v As B4XView)
    v.RemoveViewFromParent
    If AutoRelayout Then Relayout
End Sub

Public Sub ClearItems
    For i = xpnlContent.NumberOfViews - 1 To 0 Step -1
        xpnlContent.GetView(i).RemoveViewFromParent
    Next
    mFlex.ClearAllItemMeta
    If AutoRelayout Then Relayout
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
    If AutoRelayout Then Relayout
End Sub

Public Sub SetItemBasis(v As B4XView, BasisW As Int, BasisH As Int)
    mFlex.SetItemBasis(v, BasisW, BasisH)
    If AutoRelayout Then Relayout
End Sub

Public Sub SetItemBasisPercent(v As B4XView, PercentMain As Float, PercentCross As Float)
    mFlex.SetItemBasisPercent(v, PercentMain, PercentCross)
    If AutoRelayout Then Relayout
End Sub

Public Sub ClearItemBasisPercent(v As B4XView)
    mFlex.ClearItemBasisPercent(v)
    If AutoRelayout Then Relayout
End Sub

Public Sub SetItemMargins(v As B4XView, Left As Int, Top As Int, Right As Int, Bottom As Int)
    mFlex.SetItemMargins(v, Left, Top, Right, Bottom)
    If AutoRelayout Then Relayout
End Sub

Public Sub SetItemAlignSelf(v As B4XView, AlignSelf As String)
    mFlex.SetItemAlignSelf(v, AlignSelf)
    If AutoRelayout Then Relayout
End Sub

Public Sub SetItemOrder(v As B4XView, OrderValue As Int)
    mFlex.SetItemOrder(v, OrderValue)
    If AutoRelayout Then Relayout
End Sub

Public Sub SetItemWrapBefore(v As B4XView, Value As Boolean)
    mFlex.SetItemWrapBefore(v, Value)
    If AutoRelayout Then Relayout
End Sub

Public Sub ClearItemMeta(v As B4XView)
    mFlex.ClearItemMeta(v)
    If AutoRelayout Then Relayout
End Sub

Public Sub ClearAllItemMeta
    mFlex.ClearAllItemMeta
    If AutoRelayout Then Relayout
End Sub

'========================
' INTERNAL / ADVANCED NO-RELAYOUT ITEM SETTERS
'Used by B4XFlexItem.ApplyNoRelayout for batching
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
    AutoRelayout = False
End Sub

Public Sub EndUpdate(DoRelayout As Boolean)
    AutoRelayout = True
    If DoRelayout Then Relayout
End Sub

'========================
' INTERNAL
'========================

Private Sub ApplySettingsToFlex
    mFlex.Direction = Direction
    mFlex.WrapMode = WrapMode
    
    'legacy bool mirror for compatibility inside flex class
    mFlex.Wrap = (WrapMode.ToLowerCase <> "nowrap")
    
    mFlex.GapX = GapX
    mFlex.GapY = GapY
    
    mFlex.PaddingLeft = PaddingLeft
    mFlex.PaddingTop = PaddingTop
    mFlex.PaddingRight = PaddingRight
    mFlex.PaddingBottom = PaddingBottom
    
    mFlex.JustifyContent = JustifyContent
    mFlex.AlignItems = AlignItems
    mFlex.AlignContent = AlignContent
    
    mFlex.AnimateDuration = AnimateDuration
    mFlex.AllowShrinkWhenWrap = AllowShrinkWhenWrap
End Sub

Private Sub GetPropStr(Props As Map, Key As String, DefaultValue As String) As String
    If Props.IsInitialized = False Then Return DefaultValue
    If Props.ContainsKey(Key) = False Then Return DefaultValue
    Return Props.Get(Key)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
    If Props.IsInitialized = False Then Return DefaultValue
    If Props.ContainsKey(Key) = False Then Return DefaultValue
    Return Props.Get(Key)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
    If Props.IsInitialized = False Then Return DefaultValue
    If Props.ContainsKey(Key) = False Then Return DefaultValue
    Return Props.Get(Key)
End Sub

'Interpret designer integer values as dip units (spacing-focused props)
Private Sub DipOrInt(v As Int) As Int
    Return DipToCurrent(v)
End Sub