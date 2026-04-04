B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: PageChanged (PageIndex As Int, ItemId As String)

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Button size token
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|outline|ghost|link|soft|dash, Description: Button style variant
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: String, DefaultValue: primary, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Variant color applied to the active button
#DesignerProperty: Key: ActiveIndex, DisplayName: Active Index, FieldType: Int, DefaultValue: 0, Description: Zero-based index of the active page
#DesignerProperty: Key: Disabled, DisplayName: Disabled, FieldType: Boolean, DefaultValue: False, Description: Disable all pagination buttons
#DesignerProperty: Key: ShowPrevNext, DisplayName: Show Prev/Next, FieldType: Boolean, DefaultValue: True, Description: Show previous/next navigation buttons
#DesignerProperty: Key: PrevText, DisplayName: Prev Text, FieldType: String, DefaultValue: chevron-left-solid.svg, Description: Text or SVG icon for the previous button
#DesignerProperty: Key: NextText, DisplayName: Next Text, FieldType: String, DefaultValue: chevron-right-solid.svg, Description: Text or SVG icon for the next button
#DesignerProperty: Key: ShowFirstLast, DisplayName: Show First/Last, FieldType: Boolean, DefaultValue: False, Description: Show first/last navigation buttons
#DesignerProperty: Key: FirstText, DisplayName: First Text, FieldType: String, DefaultValue: angles-left-solid.svg, Description: Text or SVG icon for the first button
#DesignerProperty: Key: LastText, DisplayName: Last Text, FieldType: String, DefaultValue: angles-right-solid.svg, Description: Text or SVG icon for the last button
#DesignerProperty: Key: ShowPageNumbers, DisplayName: Show Page Numbers, FieldType: Boolean, DefaultValue: True, Description: Show numbered page buttons
#DesignerProperty: Key: PageCount, DisplayName: Page Count, FieldType: Int, DefaultValue: 5, Description: Number of page buttons to display
#DesignerProperty: Key: EqualWidth, DisplayName: Equal Width, FieldType: Boolean, DefaultValue: False, Description: Make prev/next buttons equal width (grid-cols-2 mode)
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|sm|md|lg|xl, Description: Shadow applied to each button
#DesignerProperty: Key: Circle, DisplayName: Circle, FieldType: Boolean, DefaultValue: True, Description: Each button is square — combine with Rounded=full for circle shape
#DesignerProperty: Key: GapX, DisplayName: Gap X, FieldType: Int, DefaultValue: 1, Description: Horizontal gap between pagination buttons in dip
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide component

'================================================================
' B4XDaisyPagination
' A composite pagination component built from B4XDaisyButton
' items arranged with join utility logic (merged borders,
' smart corner radius). Follows DaisyUI pagination docs.
'================================================================

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mCallBack As Object
    Private mEventName As String
    Private mTag As Object

    ' Container
    Private pnlContainer As B4XView

    ' Button management
    Private BtnDefs As List           ' List(Map("id":String, "text":String, "type":String))
    Private BtnOrder As List          ' List(String) - item ids in order
    Private BtnById As Map            ' id -> B4XDaisyButton
    Private BtnViewById As Map        ' id -> B4XView
    Private BtnTextById As Map        ' id -> text

    ' Designer properties
    Private msSize As String = "md"
    Private msStyle As String = "solid"
    Private msActiveColor As String = "primary"
    Private miActiveIndex As Int = 0
    Private mbDisabled As Boolean = False
    Private mbShowPrevNext As Boolean = True
    Private msPrevText As String = "chevron-left-solid.svg"
    Private msNextText As String = "chevron-right-solid.svg"
    Private mbShowFirstLast As Boolean = False
    Private msFirstText As String = "angles-left-solid.svg"
    Private msLastText As String = "angles-right-solid.svg"
    Private msShadow As String = "none"
    Private mbShowPageNumbers As Boolean = True
    Private miPageCount As Int = 5
    Private mbEqualWidth As Boolean = False
    Private mbCircle As Boolean = True
    Private miGapX As Int = 1
    Private mbVisible As Boolean = True

    ' Stores last known dimensions from Base_Resize to avoid reading
    ' pnlContainer.Width/Height before Android's layout pass (returns 0).
    Private mLastW As Int = 1dip
    Private mLastH As Int = 1dip
End Sub

'================================================================
' Initialization
'================================================================

Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    BtnDefs.Initialize
    BtnOrder.Initialize
    BtnById.Initialize
    BtnViewById.Initialize
    BtnTextById.Initialize
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    mBase.RemoveAllViews

    ' Create pnlContainer at minimal size; Refresh will size it correctly.
    Dim p As Panel
    p.Initialize("")
    pnlContainer = p
    pnlContainer.Color = xui.Color_Transparent
    mBase.AddView(pnlContainer, 0, 0, 1dip, 1dip)

    ApplyDesignerProps(Props)
    BuildButtons
    Refresh
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, Width, Height)
    Dim props As Map
    props.Initialize
    props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(Width))
    props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(Height))
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Return mBase
End Sub

Private Sub ResolveButtonControlSizeDip(SizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 24dip
        Case "sm"
            Return 32dip
        Case "md"
            Return 40dip
        Case "lg"
            Return 48dip
        Case "xl"
            Return 56dip
        Case Else
            Return 40dip
    End Select
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        Dim dummy As Label
        DesignerCreateView(b, dummy, CreateMap())
    End If

    ' Calculate proper height from size token with 4px padding
    Dim controlSize As Int = ResolveButtonControlSizeDip(msSize)
    Dim calculatedH As Int = controlSize + 4dip
    Dim actualH As Int = IIf(Height > 0, Height, calculatedH)

    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    Parent.AddView(mBase, Left, Top, Max(1dip, Width), Max(1dip, actualH))
    mLastW = Max(1dip, Width)
    mLastH = Max(1dip, actualH)
    pnlContainer.SetLayoutAnimated(0, 0, 0, mLastW, mLastH)
    Refresh
    Return mBase
End Sub

'================================================================
' Designer property application
'================================================================

Private Sub ApplyDesignerProps(Props As Map)
    If Props.IsInitialized = False Then Return
    If Props.ContainsKey("Size") Then
        Dim v As String = Props.Get("Size")
        If v <> Null And v.Length > 0 Then msSize = v
    End If
    If Props.ContainsKey("Style") Then
        Dim v As String = Props.Get("Style")
        If v <> Null And v.Length > 0 Then msStyle = v
    End If
    If Props.ContainsKey("ActiveColor") Then
        Dim v As String = Props.Get("ActiveColor")
        If v <> Null And v.Length > 0 Then msActiveColor = v
    End If
    If Props.ContainsKey("ActiveIndex") Then
        miActiveIndex = Props.Get("ActiveIndex")
    End If
    If Props.ContainsKey("Disabled") Then
        mbDisabled = Props.Get("Disabled")
    End If
    If Props.ContainsKey("ShowPrevNext") Then
        mbShowPrevNext = Props.Get("ShowPrevNext")
    End If
    If Props.ContainsKey("PrevText") Then
        Dim v As String = Props.Get("PrevText")
        If v <> Null And v.Length > 0 Then msPrevText = v
    End If
    If Props.ContainsKey("NextText") Then
        Dim v As String = Props.Get("NextText")
        If v <> Null And v.Length > 0 Then msNextText = v
    End If
    If Props.ContainsKey("ShowFirstLast") Then
        mbShowFirstLast = Props.Get("ShowFirstLast")
    End If
    If Props.ContainsKey("FirstText") Then
        Dim v As String = Props.Get("FirstText")
        If v <> Null And v.Length > 0 Then msFirstText = v
    End If
    If Props.ContainsKey("LastText") Then
        Dim v As String = Props.Get("LastText")
        If v <> Null And v.Length > 0 Then msLastText = v
    End If
    If Props.ContainsKey("Shadow") Then
        Dim v As String = Props.Get("Shadow")
        If v <> Null And v.Length > 0 Then msShadow = v
    End If
    If Props.ContainsKey("ShowPageNumbers") Then
        mbShowPageNumbers = Props.Get("ShowPageNumbers")
    End If
    If Props.ContainsKey("PageCount") Then
        miPageCount = Props.Get("PageCount")
    End If
    If Props.ContainsKey("EqualWidth") Then
        mbEqualWidth = Props.Get("EqualWidth")
    End If
    If Props.ContainsKey("Circle") Then
        mbCircle = Props.Get("Circle")
    End If
    If Props.ContainsKey("GapX") Then
        miGapX = Max(0, Props.Get("GapX"))
    End If
    If Props.ContainsKey("Visible") Then
        mbVisible = Props.Get("Visible")
    End If
End Sub

'================================================================
' Property getters/setters
'================================================================

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setVisible(Value As Boolean)
    If mbVisible = Value Then Return
    mbVisible = Value
    If mBase.IsInitialized Then mBase.Visible = Value
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setSize(Value As String)
    If msSize = Value Then Return
    msSize = Value
    Refresh
End Sub

Public Sub getStyle As String
    Return msStyle
End Sub

Public Sub setStyle(Value As String)
    If msStyle = Value Then Return
    msStyle = Value
    Refresh
End Sub

Public Sub getActiveColor As String
    Return msActiveColor
End Sub

Public Sub setActiveColor(Value As String)
    If msActiveColor = Value Then Return
    msActiveColor = Value
    Refresh
End Sub

Public Sub getActiveIndex As Int
    Return miActiveIndex
End Sub

Public Sub setActiveIndex(Value As Int)
    If miActiveIndex = Value Then Return
    If BtnOrder.Size = 0 Then
        miActiveIndex = 0
    Else
        miActiveIndex = Max(0, Min(Value, BtnOrder.Size - 1))
    End If
    Refresh
End Sub

Public Sub getDisabled As Boolean
    Return mbDisabled
End Sub

Public Sub setDisabled(Value As Boolean)
    If mbDisabled = Value Then Return
    mbDisabled = Value
    Refresh
End Sub

Public Sub getShowPrevNext As Boolean
    Return mbShowPrevNext
End Sub

Public Sub setShowPrevNext(Value As Boolean)
    If mbShowPrevNext = Value Then Return
    mbShowPrevNext = Value
    BuildButtons
    Refresh
End Sub

Public Sub getShowFirstLast As Boolean
    Return mbShowFirstLast
End Sub

Public Sub setShowFirstLast(Value As Boolean)
    If mbShowFirstLast = Value Then Return
    mbShowFirstLast = Value
    BuildButtons
    Refresh
End Sub

Public Sub getFirstText As String
    Return msFirstText
End Sub

Public Sub setFirstText(Value As String)
    If msFirstText = Value Then Return
    msFirstText = Value
    Refresh
End Sub

Public Sub getLastText As String
    Return msLastText
End Sub

Public Sub setLastText(Value As String)
    If msLastText = Value Then Return
    msLastText = Value
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setShadow(Value As String)
    If msShadow = Value Then Return
    msShadow = Value
    Refresh
End Sub

Public Sub getPrevText As String
    Return msPrevText
End Sub

Public Sub setPrevText(Value As String)
    If msPrevText = Value Then Return
    msPrevText = Value
    Refresh
End Sub

Public Sub getNextText As String
    Return msNextText
End Sub

Public Sub setNextText(Value As String)
    If msNextText = Value Then Return
    msNextText = Value
    Refresh
End Sub

Public Sub getShowPageNumbers As Boolean
    Return mbShowPageNumbers
End Sub

Public Sub setShowPageNumbers(Value As Boolean)
    If mbShowPageNumbers = Value Then Return
    mbShowPageNumbers = Value
    BuildButtons
    Refresh
End Sub

Public Sub getPageCount As Int
    Return miPageCount
End Sub

Public Sub setPageCount(Value As Int)
    If miPageCount = Value Then Return
    miPageCount = Max(1, Value)
    BuildButtons
    Refresh
End Sub

Public Sub getEqualWidth As Boolean
    Return mbEqualWidth
End Sub

Public Sub setEqualWidth(Value As Boolean)
    If mbEqualWidth = Value Then Return
    mbEqualWidth = Value
    Refresh
End Sub

Public Sub getCircle As Boolean
    Return mbCircle
End Sub

Public Sub setCircle(Value As Boolean)
    If mbCircle = Value Then Return
    mbCircle = Value
    Refresh
End Sub

Public Sub getGapX As Int
    Return miGapX
End Sub

Public Sub setGapX(Value As Int)
    If miGapX = Value Then Return
    miGapX = Max(0, Value)
    Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getView As B4XView
    Return mBase
End Sub

'================================================================
' Button building
'================================================================

Private Sub BuildButtons
    BtnDefs.Clear
    BtnOrder.Clear
    BtnById.Clear
    BtnViewById.Clear
    BtnTextById.Clear

    If pnlContainer.IsInitialized Then
        pnlContainer.RemoveAllViews
    End If

    If mbShowFirstLast Then AddBtnDef("first", msFirstText, "nav")
    If mbShowPrevNext Then AddBtnDef("prev", msPrevText, "nav")
    If mbShowPageNumbers Then
        For i = 1 To miPageCount
            AddBtnDef("page-" & i, "" & i, "page")
        Next
    End If
    If mbShowPrevNext Then AddBtnDef("next", msNextText, "nav")
    If mbShowFirstLast Then AddBtnDef("last", msLastText, "nav")

    ' Skip view creation until pnlContainer exists (property setters called before AddToParent).
    If pnlContainer.IsInitialized = False Then Return

    For Each def As Map In BtnDefs
        CreateButtonForDef(def.Get("id"), def.Get("text"))
    Next
End Sub

Private Sub AddBtnDef(Id As String, Text As String, BtnType As String)
    Dim m As Map
    m.Initialize
    m.Put("id", Id)
    m.Put("text", Text)
    m.Put("type", BtnType)
    BtnDefs.Add(m)
    BtnOrder.Add(Id)
    BtnTextById.Put(Id, Text)
End Sub

Private Sub CreateButtonForDef(Id As String, Text As String)
    Dim btn As B4XDaisyButton
    Dim eventName As String
    If Id = "prev" Or Id = "next" Or Id = "first" Or Id = "last" Then
        eventName = "pgbtn_" & Id
    Else
        ' Use a single shared event name for all page buttons
        eventName = "pgbtn_page"
    End If
    btn.Initialize(Me, eventName)
    btn.Padding = "px-0"  ' Remove horizontal padding so icon/text fills full cell width for precise centering
    btn.Size = msSize
    btn.Style = msStyle
    btn.Disabled = mbDisabled
    btn.Active = (Id = GetActiveItemId)
    btn.Circle = mbCircle
    btn.Tag = Id  ' Set tag so click handlers receive the button ID
    
    ' Apply active color variant to the active button
    If Id = GetActiveItemId And msActiveColor <> "none" And msActiveColor.Length > 0 Then
        btn.Variant = msActiveColor
    End If
    
    ' Apply shadow and rounded to all buttons
    ApplyButtonStyle(btn, Id, Text)

    Dim v As B4XView = btn.AddToParent(pnlContainer, 0, 0, 0, 0)
    BtnById.Put(Id, btn)
    BtnViewById.Put(Id, v)
End Sub

Private Sub ApplyButtonStyle(btn As B4XDaisyButton, Id As String, Text As String)
    ' Check if text is an SVG icon (case-insensitive)
    Dim isSvg As Boolean = False
    If Text.Length >= 4 Then
        Dim suffix As String = Text.SubString(Text.Length - 4).ToLowerCase
        If suffix = ".svg" Then isSvg = True
    End If
    
    If isSvg Then
        btn.IconName = Text
        btn.Text = ""
    Else
        btn.IconName = ""
        btn.Text = Text
    End If
    
    ' Build extra classes for shadow
    Dim extraClasses As String = ""
    If msShadow <> "none" And msShadow.Length > 0 Then
        extraClasses = "shadow-" & msShadow
    End If
    
    If extraClasses.Length > 0 Then
        btn.Class = extraClasses
    End If
End Sub

Private Sub GetActiveItemId As String
    If BtnOrder.Size = 0 Then Return ""
    If miActiveIndex >= 0 And miActiveIndex < BtnOrder.Size Then
        Return BtnOrder.Get(miActiveIndex)
    End If
    Return BtnOrder.Get(0)
End Sub

'================================================================
' Layout and refresh
'================================================================

Public Sub Refresh
    If pnlContainer.IsInitialized = False Then Return
    If BtnOrder.Size = 0 Then Return

    Dim total As Int = BtnOrder.Size
    Dim borderWidth As Float = 1dip
    Dim containerW As Int = Max(1dip, mLastW)
    Dim btnH As Int = mLastH
    Dim btnW As Int
    If mbCircle Then
        ' When Circle=True, buttons should be perfect squares based on the size token's control size.
        ' This ensures SVG icons and text are centered both vertically and horizontally.
        Dim controlSize As Int = ResolveButtonControlSizeDip(msSize)
        btnH = controlSize
        btnW = controlSize
    Else
        btnW = containerW / total
    End If
    ' Guard against zero button width
    If btnW <= 0 Then btnW = 1dip

    For i = 0 To total - 1
        Dim id As String = BtnOrder.Get(i)
        Dim v As B4XView = BtnViewById.Get(id)
        If v.IsInitialized = False Then Continue

        Dim btn As B4XDaisyButton = BtnById.Get(id)
        If btn.IsInitialized Then
            btn.Size = msSize
            btn.Style = msStyle
            btn.Disabled = mbDisabled
            btn.Active = (id = GetActiveItemId)
            btn.Circle = mbCircle
            ' Apply active color variant to the active button
            If id = GetActiveItemId And msActiveColor <> "none" And msActiveColor.Length > 0 Then
                btn.Variant = msActiveColor
            Else
                btn.Variant = "none"
            End If
        End If

        Dim gapDip As Int = miGapX * 1dip
        Dim leftPos As Int = i * (btnW + gapDip)
        Dim cellW As Int = btnW
        If btn.IsInitialized Then btn.Base_Resize(cellW, btnH)
        v.SetLayoutAnimated(0, leftPos, 0, cellW, btnH)
        v.Visible = True
    Next

    pnlContainer.Color = xui.Color_Transparent

    mBase.Visible = mbVisible
End Sub

Private Sub Base_Resize(Width As Int, Height As Int)
    If mBase.IsInitialized = False Or pnlContainer.IsInitialized = False Then Return
    ' Guard against zero dimensions to prevent division by zero in Refresh
    If Width <= 0 Or Height <= 0 Then Return
    mLastW = Width
    mLastH = Height
    pnlContainer.SetLayoutAnimated(0, 0, 0, mLastW, mLastH)
    Refresh
End Sub

'================================================================
' Events
'================================================================

Private Sub pgbtn_first_Click(Tag As Object)
    If mbDisabled Then Return
    ' Find the first page button index
    For i = 0 To BtnOrder.Size - 1
        Dim id As String = BtnOrder.Get(i)
        If id.IndexOf("page-") = 0 Then
            miActiveIndex = i
            Exit
        End If
    Next
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, "first")
End Sub

Private Sub pgbtn_prev_Click(Tag As Object)
    If mbDisabled Then Return
    Dim idx As Int = miActiveIndex - 1
    If idx < 0 Then idx = BtnOrder.Size - 1
    miActiveIndex = idx
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, "prev")
End Sub

Private Sub pgbtn_next_Click(Tag As Object)
    If mbDisabled Then Return
    Dim idx As Int = miActiveIndex + 1
    If idx >= BtnOrder.Size Then idx = 0
    miActiveIndex = idx
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, "next")
End Sub

Private Sub pgbtn_last_Click(Tag As Object)
    If mbDisabled Then Return
    ' Find the last page button index
    For i = BtnOrder.Size - 1 To 0 Step -1
        Dim id As String = BtnOrder.Get(i)
        If id.IndexOf("page-") = 0 Then
            miActiveIndex = i
            Exit
        End If
    Next
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, "last")
End Sub

Private Sub pgbtn_page_Click(Tag As Object)
    If mbDisabled Then Return
    If Tag = Null Then Return
    Dim Id As String = Tag
    Dim idx As Int = BtnOrder.IndexOf(Id)
    If idx >= 0 Then
        miActiveIndex = idx
        Refresh
        CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, Id)
    End If
End Sub

Private Sub GetActivePageNumber As Int
    If miActiveIndex < 0 Or miActiveIndex >= BtnOrder.Size Then Return 0
    Dim id As String = BtnOrder.Get(miActiveIndex)
    If id.IndexOf("page-") = 0 Then
        Dim numStr As String = id.SubString(5)
        Dim num As Int = 0
        Try
            num = numStr
        Catch
            num = 0
        End Try
        Return num
    End If
    Return 0
End Sub

''' <summary>
''' Returns the number of page buttons (excludes nav buttons like prev/next/first/last).
''' Note: This is different from the PageCount designer property which is the configured page count.
''' </summary>
Public Sub GetActualPageCount As Int
    Dim count As Int = 0
    For Each id As String In BtnOrder
        If id.IndexOf("page-") = 0 Then count = count + 1
    Next
    Return count
End Sub

'================================================================
' Public API: programmatic usage
'================================================================

''' <summary>
''' Goes to the previous page.
''' </summary>
Public Sub PrevPage
    If mbDisabled Or BtnOrder.Size = 0 Then Return
    Dim idx As Int = miActiveIndex - 1
    If idx < 0 Then idx = BtnOrder.Size - 1
    miActiveIndex = idx
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, "prev")
End Sub

''' <summary>
''' Goes to the next page.
''' </summary>
Public Sub NextPage
    If mbDisabled Or BtnOrder.Size = 0 Then Return
    Dim idx As Int = miActiveIndex + 1
    If idx >= BtnOrder.Size Then idx = 0
    miActiveIndex = idx
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, "next")
End Sub

''' <summary>
''' Goes to a specific page by index (0-based).
''' </summary>
Public Sub GoToPage(Index As Int)
    If Index < 0 Or Index >= BtnOrder.Size Then Return
    miActiveIndex = Index
    Refresh
    CallSubDelayed3(mCallBack, mEventName & "_PageChanged", GetActivePageNumber, BtnOrder.Get(Index))
End Sub

''' <summary>
''' Returns the total number of buttons (including nav buttons like prev/next/first/last).
''' For page count only, use GetPageCount instead.
''' </summary>
Public Sub GetItemCount As Int
    Return BtnOrder.Size
End Sub

''' <summary>
''' Returns the item ID at the given index.
''' </summary>
Public Sub GetItemIdAt(Index As Int) As String
    If Index < 0 Or Index >= BtnOrder.Size Then Return ""
    Return BtnOrder.Get(Index)
End Sub

''' <summary>
''' Sets the disabled state of a specific button by item ID.
''' </summary>
Public Sub SetItemDisabled(Id As String, Disabled As Boolean)
    Dim btn As B4XDaisyButton = BtnById.Get(Id)
    If btn.IsInitialized Then
        btn.Disabled = Disabled
    End If
End Sub
