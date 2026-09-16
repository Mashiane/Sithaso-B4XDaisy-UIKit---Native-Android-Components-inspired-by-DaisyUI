B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Layout orientation.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: box, List: none|selector|field|box|full, Description: Border radius token (none=0, selector=--radius-selector, field=--radius-field, box=--radius-box, full=9999dip).
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: String, DefaultValue: token, Description: Border width in dip, or "token" to use --border theme value, or "0" for none.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: String, DefaultValue: base-300, List: base-300|base-200|base-content|primary|secondary|accent|info|success|warning|error|none, Description: Border color token.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-content, Description: Card width: empty = use AddToParent width, "w-content" = shrink-wrap to content, or a number (dip).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: , Description: Card height: empty or "h-content" = driven by tallest item, or a number (dip) to force a fixed height.
#DesignerProperty: Key: EqualWidths, DisplayName: Equal Widths, FieldType: Boolean, DefaultValue: False, Description: Give every horizontal stat item the same width within the available width.
#DesignerProperty: Key: MaxWidth, DisplayName: Maximum Width, FieldType: Int, DefaultValue: 0, Description: Maximum available width in dip. 0 uses the width supplied to AddToParent.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#End Region

#Region Variables
#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private mVisible As Boolean = True

    
    ' Local properties
    Private mOrientation As String = "horizontal"
    Private mShadow As String = "none"
    Private mRounded As String = "box"
    Private msBorderWidth As String = "token"
    Private msBorderColor As String = "base-300"
    Private mHScroll As HorizontalScrollView
    Private mItemsPanel As B4XView
    Private mGivenWidth As Int = 0
    Private msWidth As String = "__UNSET__"
    Private msHeight As String = ""
    Private mbEqualWidths As Boolean = False
    Private miMaxWidth As Int = 0
    Private mIsResizing As Boolean = False
    Private mItems As List
    Private mContentWidth As Int = 0
    Private mContentHeight As Int = 0
    
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ApplyDesignerProps(mProps)
    
    BuildScrollContainer
    mBase.Visible = mVisible
    Refresh
End Sub
#End Region

#Region Public API
''' Returns the content-driven width after Refresh (inline-grid fit-content).
Public Sub getContentWidth As Int
    Return mContentWidth
End Sub

''' Returns the content-driven height after Refresh (inline-grid fit-content).
Public Sub getContentHeight As Int
    Return mContentHeight
End Sub

Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    ' For B4X native, we simulate the look.
    Dim bgColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    
    ' Resolve border color
    Dim resolvedBorderColor As Int
    If msBorderColor = "none" Or msBorderColor = "" Then
        resolvedBorderColor = xui.Color_Transparent
    Else
        resolvedBorderColor = B4XDaisyVariants.GetTokenColor("--color-" & msBorderColor, xui.Color_LightGray)
    End If
    
    ' Resolve border width
    Dim resolvedBorderWidth As Float
    If msBorderWidth = "token" Or msBorderWidth = "" Then
        resolvedBorderWidth = B4XDaisyVariants.GetBorderDip(1dip)
    Else
        If IsNumber(msBorderWidth) Then
            resolvedBorderWidth = msBorderWidth * 1dip
        Else
            resolvedBorderWidth = 0
        End If
    End If
    
    ' Resolve border radius
    Dim resolvedRadius As Float
    Select Case mRounded
        Case "none" : resolvedRadius = 0
        Case "selector" : resolvedRadius = B4XDaisyVariants.GetRadiusSelectorDip(4dip)
        Case "field" : resolvedRadius = B4XDaisyVariants.GetRadiusFieldDip(6dip)
        Case "box" : resolvedRadius = B4XDaisyVariants.GetRadiusBoxDip(16dip)
        Case "full" : resolvedRadius = 9999dip
        Case Else : resolvedRadius = B4XDaisyVariants.GetRadiusBoxDip(16dip)
    End Select
    
    mBase.SetColorAndBorder(bgColor, resolvedBorderWidth, resolvedBorderColor, resolvedRadius)
    
    ' Clip children to the rounded outline (CSS overflow + border-radius)
    Dim jo As JavaObject = mBase
    jo.RunMethod("setClipToOutline", Array(True))
    
    ' Apply shadow elevation
    B4XDaisyVariants.ApplyElevation(mBase, mShadow)
    
    ' CSS: .stats = inline-grid grid-flow-col overflow-x-auto
    ' Each .stat column is max-content wide (no equal division). All items share the tallest row height.
    Dim itemCount As Int = mItems.Size
    If itemCount = 0 Then Return
    
    ' -- Phase 1: auto-size every item to its own content (inline-grid: shrink-wrap) --
    For i = 0 To itemCount - 1
        Dim itm As B4XDaisyStatItem = mItems.Get(i)
        itm.Orientation = mOrientation
        itm.ShowSeparator = (i < itemCount - 1)
        itm.Refresh
    Next
    
    ' -- Phase 2: find the uniform dimension that all items must share ---------
    ' Horizontal: all items share the TALLEST item's height (CSS grid row stretch).
    ' Vertical  : all items share the WIDEST  item's width  (CSS w-full in same column).
    Dim maxH As Int = 0
    Dim maxW As Int = 0
    Dim availableW As Int = ResolveAvailableWidth
    Dim equalItemW As Int = 0
    Dim equalRemainder As Int = 0
    If mOrientation = "horizontal" And mbEqualWidths Then
        equalItemW = Max(1dip, Floor(availableW / itemCount))
        equalRemainder = Max(0, availableW - (equalItemW * itemCount))
        For i = 0 To itemCount - 1
            Dim equalItem As B4XDaisyStatItem = mItems.Get(i)
            Dim itemW As Int = equalItemW
            If i < equalRemainder Then itemW = itemW + 1
            ' Re-measure at the assigned width so wrapped labels affect row height.
            equalItem.Base_Resize(itemW, 0)
            maxH = Max(maxH, equalItem.ContentHeight)
        Next
    Else
        For i = 0 To itemCount - 1
            Dim itm As B4XDaisyStatItem = mItems.Get(i)
            maxH = Max(maxH, itm.ContentHeight)
            maxW = Max(maxW, itm.ContentWidth)
        Next
    End If
    maxH = Max(maxH, 60dip)
    maxW = Max(maxW, 80dip)
    
    ' -- Phase 3: apply uniform dimension and position items ------------------
    Dim currentPos As Int = 0
    For i = 0 To itemCount - 1
        Dim itm As B4XDaisyStatItem = mItems.Get(i)
        If mOrientation = "horizontal" Then
            Dim itemW As Int = itm.ContentWidth
            If mbEqualWidths Then
                itemW = equalItemW
                If i < equalRemainder Then itemW = itemW + 1
                If itm.ContentWidth <> itemW Or itm.ContentHeight <> maxH Then itm.Base_Resize(itemW, maxH)
            Else
                ' Stretch each item to the tallest height; keep its content-measured width.
                If itm.ContentHeight <> maxH Then itm.Base_Resize(itemW, maxH)
            End If
            itm.mBase.Left = currentPos
            itm.mBase.Top  = 0
            currentPos = currentPos + itemW
        Else
            ' Stretch each item to the widest width; keep its content-measured height.
            If itm.ContentWidth <> maxW Then itm.Base_Resize(maxW, itm.ContentHeight)
            itm.mBase.Left = 0
            itm.mBase.Top  = currentPos
            currentPos = currentPos + itm.ContentHeight
        End If
    Next
    
    ' -- Phase 4: size card, scroll container, and content panel --------------
    ' Width/Height properties: "" = use mGivenWidth (default), "w-content"/"h-content" = shrink-wrap,
    ' or a numeric string = treat as dip value.
    If mOrientation = "horizontal" Then
        mContentWidth = currentPos
        mContentHeight = maxH
        
        ' Resolve card width
        Dim cardW As Int
        If mbEqualWidths Then
            cardW = availableW
        Else If msWidth = "w-content" Then
            cardW = Max(currentPos, 1dip)
            If cardW > mGivenWidth And mGivenWidth > 0 Then cardW = mGivenWidth
        Else If msWidth <> "" And IsNumber(msWidth) Then
            cardW = msWidth * 1dip
        Else
            cardW = Max(mGivenWidth, 1dip)
        End If
        cardW = Min(cardW, availableW)
        
        ' Resolve card height
        Dim cardH As Int
        If msHeight <> "" And msHeight <> "h-content" And IsNumber(msHeight) Then
            cardH = Max(msHeight * 1dip, maxH)
        Else
            cardH = maxH
        End If
        
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, cardW, cardH)
        If mHScroll.IsInitialized Then
            mHScroll.Width = cardW
            mHScroll.Height = cardH
            If mbEqualWidths Then
                mItemsPanel.Width = cardW
            Else
                mItemsPanel.Width = Max(currentPos, cardW)
            End If
        End If
    Else
        ' Resolve card width (vertical)
        Dim cardW2 As Int
        If msWidth = "w-content" Then
            cardW2 = Max(maxW, 1dip)
        Else If msWidth <> "" And IsNumber(msWidth) Then
            cardW2 = msWidth * 1dip
        Else
            cardW2 = Max(mGivenWidth, maxW)
        End If
        cardW2 = Min(cardW2, availableW)
        
        ' Resolve card height (vertical)
        Dim cardH2 As Int
        If msHeight <> "" And msHeight <> "h-content" And IsNumber(msHeight) Then
            cardH2 = msHeight * 1dip
        Else
            cardH2 = currentPos
        End If
        
        mContentWidth = cardW2
        mContentHeight = cardH2
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, cardW2, cardH2)
        If mHScroll.IsInitialized Then
            mHScroll.Width = cardW2
            mHScroll.Height = cardH2
            mItemsPanel.Width = cardW2
        End If
    End If
    Sleep(0)
End Sub

Public Sub AddItem(Item As B4XDaisyStatItem)
    If mItems.IndexOf(Item) = -1 Then mItems.Add(Item)
    If Item.mBase.IsInitialized = False Then
        Item.CreateView(mBase.Width, 100dip)
    End If
    ' Add to the internal scroll panel (or mBase if scroll not yet created)
    If mItemsPanel.IsInitialized Then
        If Item.mBase.Parent <> mItemsPanel Then
            mItemsPanel.AddView(Item.mBase, 0, 0, Item.mBase.Width, Item.mBase.Height)
        End If
    Else
        If Item.mBase.Parent <> mBase Then
            mBase.AddView(Item.mBase, 0, 0, Item.mBase.Width, Item.mBase.Height)
        End If
    End If
    ' Don't call Refresh here - caller should set item properties first, then call Refresh.
End Sub

''' <summary>
''' Creates and configures a B4XDaisyStatItem with Title and Value.
''' Caller must call AddItem(item) to add it to the container, then Refresh.
''' </summary>
Public Sub AddItem1(sEventName As String, sTitle As String, sValue As String) As B4XDaisyStatItem
    Dim item As B4XDaisyStatItem
    item.Initialize(mCallBack, sEventName)
    item.setTitle(sTitle)
    item.setValue(sValue)
    Return item
End Sub

''' <summary>
''' Creates and configures a B4XDaisyStatItem with Title, Value and Description.
''' Caller must call AddItem(item) to add it to the container, then Refresh.
''' </summary>
Public Sub AddItem2(sEventName As String, sTitle As String, sValue As String, sDescription As String) As B4XDaisyStatItem
    Dim item As B4XDaisyStatItem
    item.Initialize(mCallBack, sEventName)
    item.setTitle(sTitle)
    item.setValue(sValue)
    item.setDescription(sDescription)
    Return item
End Sub

' Re-runs the count-up animation on every item in this stats container (value + radial figure).
Public Sub StartAnimation
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyStatItem = mItems.Get(i)
        itm.StartAnimation
    Next
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    Dim w As Int = Max(1dip, iWidth)
    Dim h As Int = Max(1dip, iHeight)
    ' Set mGivenWidth BEFORE DesignerCreateView so the first Refresh uses the real width.
    mGivenWidth = w
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, w, h)
        Dim props As Map = BuildRuntimeProps(w, h)
        Dim dummy As Label
        DesignerCreateView(b, dummy, props)
    End If
    ' Only force AddToParent width when NOT shrink-wrapping to content.
    ' With w-content as default, Refresh already sized mBase correctly  don't override it.
    If msWidth <> "w-content" And mbEqualWidths = False And miMaxWidth = 0 Then
        If mBase.Width <> w Then mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, mBase.Height)
    End If
    vParent.AddView(mBase, iLeft, iTop, mBase.Width, mBase.Height)
    Return mBase
End Sub

Public Sub getEqualWidths As Boolean
    Return mbEqualWidths
End Sub

Public Sub setEqualWidths(bValue As Boolean)
    If mbEqualWidths = bValue Then Return
    mbEqualWidths = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getMaxWidth As Int
    Return miMaxWidth
End Sub

Public Sub setMaxWidth(iValue As Int)
    miMaxWidth = Max(0, iValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub setOrientation(sValue As String)
    mOrientation = B4XDaisyVariants.NormalizeOrientation(sValue)
    Refresh
End Sub

Public Sub getOrientation As String
    Return mOrientation
End Sub

Public Sub setShadow(sValue As String)
    mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setRounded(sValue As String)
    mRounded = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

Public Sub setBorderWidth(sValue As String)
    msBorderWidth = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderWidth As String
    Return msBorderWidth
End Sub

Public Sub setBorderColor(sValue As String)
    msBorderColor = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderColor As String
    Return msBorderColor
End Sub

''' Sets the card width: "" = use AddToParent width (default), "w-content" = shrink-wrap to content,
''' or a numeric string treated as dip (e.g. "320" = 320dip).
Public Sub setWidth(sValue As String)
    msWidth = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

''' Sets the card height: "" or "h-content" = content-driven (default), or a numeric string in dip.
Public Sub setHeight(sValue As String)
    msHeight = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

''' Sets the layout of the base view with animation.
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

''' Sets the left position of the base view.
Public Sub setLeft(iValue As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Left = iValue
End Sub

''' Sets the top position of the base view.
Public Sub setTop(iValue As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Top = iValue
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mIsResizing Then Return
    mIsResizing = True
    If dWidth > 2dip Then mGivenWidth = dWidth
    ' Manual layout 
    Refresh
    mIsResizing = False
End Sub

Private Sub mBase_Click
    RaiseClick
End Sub

' removed simple forwarding helper; call variant method directly

Private Sub GetPropBool(mProps As Map, sKey As String, bDefaultValue As Boolean) As Boolean
    Return B4XDaisyVariants.GetPropBool(mProps, sKey, bDefaultValue)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
    If mOrientation = "horizontal" Then mOrientation = B4XDaisyVariants.GetPropString(mProps, "Orientation", "horizontal")
    If mShadow = "none" Then mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", "none"))
    If mRounded = "box" Then mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", "box")
    If msBorderWidth = "token" Then msBorderWidth = B4XDaisyVariants.GetPropString(mProps, "BorderWidth", "token")
    If msBorderColor = "base-300" Then msBorderColor = B4XDaisyVariants.GetPropString(mProps, "BorderColor", "base-300")
    If msWidth = "__UNSET__" Then msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", "w-content")
    If msHeight = "" Then msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", "")
    mbEqualWidths = B4XDaisyVariants.GetPropBool(mProps, "EqualWidths", mbEqualWidths)
    miMaxWidth = Max(0, B4XDaisyVariants.GetPropInt(mProps, "MaxWidth", miMaxWidth))
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub ResolveAvailableWidth As Int
    Dim availableW As Int = mGivenWidth
    If availableW <= 0 And mBase.IsInitialized Then availableW = mBase.Width
    If miMaxWidth > 0 Then availableW = Min(availableW, miMaxWidth * 1dip)
    Return Max(1dip, availableW)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", "w-content")
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Orientation", mOrientation)
	props.Put("Shadow", mShadow)
	props.Put("Rounded", mRounded)
	props.Put("BorderWidth", msBorderWidth)
	props.Put("BorderColor", msBorderColor)
	props.Put("EqualWidths", mbEqualWidths)
	props.Put("MaxWidth", miMaxWidth)
	props.Put("Visible", mVisible)
	Return props
End Sub

''' Creates the internal HorizontalScrollView that holds all stat items.
''' Stat callers no longer need to wrap the component in a HorizontalScrollView.
Private Sub BuildScrollContainer
    If mBase.IsInitialized = False Then Return
    If mHScroll.IsInitialized Then Return
    mHScroll.Initialize(0, "")
    Try
        Dim jHSV As JavaObject = mHScroll
        jHSV.RunMethod("setBackgroundColor", Array As Object(0))
        jHSV.RunMethod("setOverScrollMode", Array As Object(2))
        jHSV.RunMethod("setHorizontalScrollBarEnabled", Array As Object(False))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyStat.BuildScrollContainer: " & LastException.Message)
    End Try
    mBase.AddView(mHScroll, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
    Dim ipanel As B4XView = mHScroll.Panel
    mItemsPanel = ipanel
    mItemsPanel.Color = xui.Color_Transparent
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
#End Region

#Region Cleanup
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

#Region B4XView Layout Wrapper Methods
Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
