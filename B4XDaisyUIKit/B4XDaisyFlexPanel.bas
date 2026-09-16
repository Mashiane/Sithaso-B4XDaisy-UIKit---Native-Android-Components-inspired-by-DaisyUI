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

#IgnoreWarnings:12,9
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
	Private inResize As Boolean = False
End Sub

Public Sub Initialize
End Sub

'Custom View initialization (Designer)
Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    mBase.Tag = Me
    
    xpnlContent = xui.CreatePanel("")
    mBase.AddView(xpnlContent, 0, 0, mBase.Width, mBase.Height)
    
    ApplyDesignerProps(mProps)
    
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
Public Sub InitForCode(oCallback As Object, sEventName As String, vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    mCallBack = oCallback
    mEventName = sEventName
    
    ' Ensure props maps matching types expected by DesignerCreateView (strings for enums, ints for numbers)
    Dim props As Map = CreateMap("Direction": mDirection, "WrapMode": mWrapMode, _
        "GapX": mGapX & "", "GapY": mGapY & "", "PaddingLeft": mPaddingLeft & "", "PaddingTop": mPaddingTop & "", _
        "PaddingRight": mPaddingRight & "", "PaddingBottom": mPaddingBottom & "", "JustifyContent": mJustifyContent, _
        "AlignItems": mAlignItems, "AlignContent": mAlignContent, "AnimateDuration": mAnimateDuration & "", _
        "AllowShrinkWhenWrap": mAllowShrinkWhenWrap & "", "AutoRelayout": mAutoRelayout & "")
    
    Dim p As Panel
    p.Initialize("")
    mBase = p
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    DesignerCreateView(mBase, Null, props)
End Sub

'** helper for programmatic insertion **
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
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

Public Sub Base_Resize (dWidth As Double, dHeight As Double)
    If inResize Then Return
    inResize = True
    If xpnlContent.IsInitialized Then
        xpnlContent.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
        If mAutoRelayout Then Relayout
    End If
    inResize = False
End Sub

'B4X custom view plumbing
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub getIsInitialized As Boolean
    Return mFlex.IsInitialized
End Sub

'Content panel access (add real child views here)
Public Sub GetContentPanel As B4XView
    Return xpnlContent
End Sub

'-
' PUBLIC LAYOUT API
'-

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

Public Sub SetPadding(iAll As Int)
    mPaddingLeft = iAll
    mPaddingTop = iAll
    mPaddingRight = iAll
    mPaddingBottom = iAll
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetPaddingLTRB(iLeft As Int, iTop As Int, iRight As Int, iBottom As Int)
    mPaddingLeft = iLeft
    mPaddingTop = iTop
    mPaddingRight = iRight
    mPaddingBottom = iBottom
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetGap(iX As Int, iY As Int)
    mGapX = iX
    mGapY = iY
    If mAutoRelayout Then Relayout
End Sub

Public Sub setDirection(sValue As String)
    mDirection = sValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getDirection As String
    Return mDirection
End Sub

Public Sub setWrapMode(sValue As String)
    mWrapMode = sValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getWrapMode As String
    Return mWrapMode
End Sub

Public Sub setJustifyContent(sValue As String)
    mJustifyContent = sValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getJustifyContent As String
    Return mJustifyContent
End Sub

Public Sub setAlignItems(sValue As String)
    mAlignItems = sValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAlignItems As String
    Return mAlignItems
End Sub

Public Sub setAlignContent(sValue As String)
    mAlignContent = sValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAlignContent As String
    Return mAlignContent
End Sub

Public Sub setGapX(iValue As Int)
    mGapX = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getGapX As Int
    Return mGapX
End Sub

Public Sub setGapY(iValue As Int)
    mGapY = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getGapY As Int
    Return mGapY
End Sub

Public Sub setPaddingLeft(iValue As Int)
    mPaddingLeft = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingLeft As Int
    Return mPaddingLeft
End Sub

Public Sub setPaddingTop(iValue As Int)
    mPaddingTop = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingTop As Int
    Return mPaddingTop
End Sub

Public Sub setPaddingRight(iValue As Int)
    mPaddingRight = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingRight As Int
    Return mPaddingRight
End Sub

Public Sub setPaddingBottom(iValue As Int)
    mPaddingBottom = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getPaddingBottom As Int
    Return mPaddingBottom
End Sub

Public Sub setAnimateDuration(iValue As Int)
    mAnimateDuration = iValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAnimateDuration As Int
    Return mAnimateDuration
End Sub

Public Sub setAllowShrinkWhenWrap(bValue As Boolean)
    mAllowShrinkWhenWrap = bValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAllowShrinkWhenWrap As Boolean
    Return mAllowShrinkWhenWrap
End Sub

Public Sub setAutoRelayout(bValue As Boolean)
    mAutoRelayout = bValue
    If mAutoRelayout Then Relayout
End Sub

Public Sub getAutoRelayout As Boolean
    Return mAutoRelayout
End Sub

'-
' CHILD MANAGEMENT HELPERS
'-

'Adds an existing B4XView to content panel
Public Sub AddItem(vView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    Try
        vView.RemoveViewFromParent
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFlexPanel.AddItem: " & LastException.Message)
        ' Ignore if it has no parent yet
    End Try
    xpnlContent.AddView(vView, iLeft, iTop, iWidth, iHeight)
    If mAutoRelayout Then Relayout
End Sub

'Adds and returns fluent helper for immediate chaining
Public Sub AddItemEx(vView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XDaisyFlexItem
    xpnlContent.AddView(vView, iLeft, iTop, iWidth, iHeight)
    Dim it As B4XDaisyFlexItem
    it.Initialize(Me, vView)
    Return it
End Sub

'Returns fluent helper for one child item
Public Sub Item(vView As B4XView) As B4XDaisyFlexItem
    Dim it As B4XDaisyFlexItem
    it.Initialize(Me, vView)
    Return it
End Sub

Public Sub RemoveItem(vView As B4XView)
    vView.RemoveViewFromParent
    If mAutoRelayout Then Relayout
End Sub

Public Sub Clear
    For i = xpnlContent.NumberOfViews - 1 To 0 Step -1
        xpnlContent.GetView(i).RemoveViewFromParent
    Next
    mFlex.ClearAllItemMeta
    If mAutoRelayout Then Relayout
End Sub

Public Sub getNumberOfItems As Int
    Return xpnlContent.NumberOfViews
End Sub

Public Sub GetItem(iIndex As Int) As B4XView
    Return xpnlContent.GetView(iIndex)
End Sub

'-
' PER-ITEM FLEX API (passthrough)
'-

Public Sub SetItemFlexEx(vView As B4XView, fGrow As Float, fShrink As Float, iMinW As Int, iMaxW As Int, iMinH As Int, iMaxH As Int)
    mFlex.SetItemFlexEx(vView, fGrow, fShrink, iMinW, iMaxW, iMinH, iMaxH)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemBasis(vView As B4XView, iBasisW As Int, iBasisH As Int)
    mFlex.SetItemBasis(vView, iBasisW, iBasisH)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemBasisPercent(vView As B4XView, fPercentMain As Float, fPercentCross As Float)
    mFlex.SetItemBasisPercent(vView, fPercentMain, fPercentCross)
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearItemBasisPercent(vView As B4XView)
    mFlex.ClearItemBasisPercent(vView)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemMargins(vView As B4XView, iLeft As Int, iTop As Int, iRight As Int, iBottom As Int)
    mFlex.SetItemMargins(vView, iLeft, iTop, iRight, iBottom)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemAlignSelf(vView As B4XView, sAlignSelf As String)
    mFlex.SetItemAlignSelf(vView, sAlignSelf)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemOrder(vView As B4XView, iOrderValue As Int)
    mFlex.SetItemOrder(vView, iOrderValue)
    If mAutoRelayout Then Relayout
End Sub

Public Sub SetItemWrapBefore(vView As B4XView, bValue As Boolean)
    mFlex.SetItemWrapBefore(vView, bValue)
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearItemMeta(vView As B4XView)
    mFlex.ClearItemMeta(vView)
    If mAutoRelayout Then Relayout
End Sub

Public Sub ClearAllItemMeta
    mFlex.ClearAllItemMeta
    If mAutoRelayout Then Relayout
End Sub

'-
' INTERNAL / ADVANCED NO-RELAYOUT ITEM SETTERS
'Used by B4XDaisyFlexItem.ApplyNoRelayout for batching
'-

Public Sub SetItemFlexEx_NoRelayout(vView As B4XView, fGrow As Float, fShrink As Float, iMinW As Int, iMaxW As Int, iMinH As Int, iMaxH As Int)
    mFlex.SetItemFlexEx(vView, fGrow, fShrink, iMinW, iMaxW, iMinH, iMaxH)
End Sub

Public Sub SetItemBasis_NoRelayout(vView As B4XView, iBasisW As Int, iBasisH As Int)
    mFlex.SetItemBasis(vView, iBasisW, iBasisH)
End Sub

Public Sub SetItemBasisPercent_NoRelayout(vView As B4XView, fPercentMain As Float, fPercentCross As Float)
    mFlex.SetItemBasisPercent(vView, fPercentMain, fPercentCross)
End Sub

Public Sub ClearItemBasisPercent_NoRelayout(vView As B4XView)
    mFlex.ClearItemBasisPercent(vView)
End Sub

Public Sub SetItemMargins_NoRelayout(vView As B4XView, iLeft As Int, iTop As Int, iRight As Int, iBottom As Int)
    mFlex.SetItemMargins(vView, iLeft, iTop, iRight, iBottom)
End Sub

Public Sub SetItemAlignSelf_NoRelayout(vView As B4XView, sAlignSelf As String)
    mFlex.SetItemAlignSelf(vView, sAlignSelf)
End Sub

Public Sub SetItemOrder_NoRelayout(vView As B4XView, iOrderValue As Int)
    mFlex.SetItemOrder(vView, iOrderValue)
End Sub

Public Sub SetItemWrapBefore_NoRelayout(vView As B4XView, bValue As Boolean)
    mFlex.SetItemWrapBefore(vView, bValue)
End Sub

'-
' BATCH UPDATE HELPERS
'-

Public Sub BeginUpdate
    mAutoRelayout = False
End Sub

Public Sub EndUpdate(bDoRelayout As Boolean)
    mAutoRelayout = True
    If bDoRelayout Then Relayout
End Sub

'-
' INTERNAL
'-

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

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
    mDirection = B4XDaisyVariants.GetPropString(mProps, "Direction", mDirection)
    mWrapMode = B4XDaisyVariants.GetPropString(mProps, "WrapMode", mWrapMode)
    mGapX = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "GapX", 8))
    mGapY = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "GapY", 8))
    mPaddingLeft = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "PaddingLeft", 8))
    mPaddingTop = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "PaddingTop", 8))
    mPaddingRight = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "PaddingRight", 8))
    mPaddingBottom = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "PaddingBottom", 8))
    mJustifyContent = B4XDaisyVariants.GetPropString(mProps, "JustifyContent", mJustifyContent)
    mAlignItems = B4XDaisyVariants.GetPropString(mProps, "AlignItems", mAlignItems)
    mAlignContent = B4XDaisyVariants.GetPropString(mProps, "AlignContent", mAlignContent)
    mAnimateDuration = B4XDaisyVariants.GetPropInt(mProps, "AnimateDuration", mAnimateDuration)
    mAllowShrinkWhenWrap = B4XDaisyVariants.GetPropBool(mProps, "AllowShrinkWhenWrap", mAllowShrinkWhenWrap)
    mAutoRelayout = B4XDaisyVariants.GetPropBool(mProps, "AutoRelayout", mAutoRelayout)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Direction", mDirection)
	props.Put("WrapMode", mWrapMode)
	props.Put("GapX", mGapX)
	props.Put("GapY", mGapY)
	props.Put("PaddingLeft", mPaddingLeft)
	props.Put("PaddingTop", mPaddingTop)
	props.Put("PaddingRight", mPaddingRight)
	props.Put("PaddingBottom", mPaddingBottom)
	props.Put("JustifyContent", mJustifyContent)
	props.Put("AlignItems", mAlignItems)
	props.Put("AlignContent", mAlignContent)
	props.Put("AnimateDuration", mAnimateDuration)
	props.Put("AllowShrinkWhenWrap", mAllowShrinkWhenWrap)
	props.Put("AutoRelayout", mAutoRelayout)
	Return props
End Sub

'Interpret designer integer values as dip units (spacing-focused props)
Private Sub DipOrInt(iV As Int) As Int
    Return DipToCurrent(iV)
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

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region
