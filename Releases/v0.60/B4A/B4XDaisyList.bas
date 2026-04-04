B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: ItemClick (Index As Int, Tag As Object)
#Event: ItemLongClick (Index As Int, Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 80%)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Tailwind size token/CSS size or auto to fit rows
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: base-100, Description: DaisyUI background color token
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: String, DefaultValue: , Description: DaisyUI text color token
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Apply rounded-box radius to the list container
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: shadow-md, List: |none|shadow|shadow-md|shadow-lg|shadow-xl, Description: DaisyUI shadow class
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: 0, Description: Container padding in dip
#DesignerProperty: Key: RowPadding, DisplayName: Row Padding, FieldType: String, DefaultValue: 4, Description: Gap around row content in dip
#DesignerProperty: Key: RowGap, DisplayName: Row Gap, FieldType: String, DefaultValue: 4, Description: Gap between row items in dip
#DesignerProperty: Key: DividerColor, DisplayName: Divider Color, FieldType: String, DefaultValue: base-content/5, Description: Divider border color token
#DesignerProperty: Key: Divider, DisplayName: Show Divider, FieldType: Boolean, DefaultValue: True, Description: Show divider line between rows

#IgnoreWarnings: 12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    ' Internal views
    Private pnlContainer As B4XView

    ' Row items storage
    Private mRows As List

    ' Designer properties
    Private msBackgroundColor As String = "base-100"
    Private msTextColor As String = ""
    Private mbRoundedBox As Boolean = True
    Private msShadow As String = "shadow-md"
    Private miPadding As Int = 0
    Private miRowPadding As Int = 4
    Private miRowGap As Int = 4
    Private msDividerColor As String = "base-content/5"
    Private mbShowDivider As Boolean = True
    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private msWidth As String = "full"
    Private msHeight As String = "auto"
    Private mbAutoHeight As Boolean = True
    Private mbAutoSizing As Boolean = False
    ' Layout tracking
    Private mRowViews As List
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mRows.Initialize
    mRowViews.Initialize
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim p As Panel
    p.Initialize("")
    pnlContainer = p
    pnlContainer.Color = xui.Color_Transparent
    mBase.AddView(pnlContainer, 0, 0, mBase.Width, mBase.Height)

    msBackgroundColor = B4XDaisyVariants.GetPropString(Props, "BackgroundColor", "base-100")
    msTextColor = B4XDaisyVariants.GetPropString(Props, "TextColor", "")
    mbRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", True)
    msShadow = B4XDaisyVariants.GetPropString(Props, "Shadow", "shadow-md")
    miPadding = B4XDaisyVariants.GetPropInt(Props, "Padding", 0)
    miRowPadding = B4XDaisyVariants.GetPropInt(Props, "RowPadding", 4)
    miRowGap = B4XDaisyVariants.GetPropInt(Props, "RowGap", 4)
    msWidth = NormalizeSizeSpec(B4XDaisyVariants.GetPropString(Props, "Width", "full"), "full")
    msHeight = NormalizeSizeSpec(B4XDaisyVariants.GetPropString(Props, "Height", "auto"), "auto")
    mbAutoHeight = (msHeight = "auto")
    msDividerColor = B4XDaisyVariants.GetPropString(Props, "DividerColor", "base-content/5")
    mbShowDivider = B4XDaisyVariants.GetPropBool(Props, "Divider", True)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)

    ApplyStyles
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return

    Dim targetW As Int = Max(1dip, Width)
    Dim targetH As Int = Max(1dip, Height)

    targetW = ResolveWidthDip(targetW)
    If mbAutoHeight = False Then targetH = ResolveHeightDip(targetH)

    If targetW <> mBase.Width Or targetH <> mBase.Height Then
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
    End If

    Dim pad As Int = miPadding
    Dim containerW As Int = Max(0, targetW - (pad * 2))
    Dim containerH As Int = Max(0, targetH - (pad * 2))
    pnlContainer.SetLayoutAnimated(0, pad, pad, containerW, containerH)

    LayoutRows
End Sub

Private Sub LayoutRows
    If pnlContainer.IsInitialized = False Then Return
    If pnlContainer.Width <= 0 Then Return

    If mRowViews.Size = 0 Then
        pnlContainer.Height = 0
        MaybeAdjustAutoHeight
        Return
    End If

    Dim containerW As Float = pnlContainer.Width
    Dim y As Float = 0

    For i = 0 To mRowViews.Size - 1
        Dim rowPanel As B4XView = mRowViews.Get(i)
        If rowPanel.IsInitialized = False Then Continue

        Dim rowData As Map = mRows.Get(i)
        Dim rowH As Float = rowData.GetDefault("height", 40dip)
        If rowH <= 0 Then rowH = EstimateRowBaseHeight(rowData)

        rowH = LayoutRowItems(rowPanel, rowData, containerW, rowH)
        rowPanel.SetLayoutAnimated(0, 0, y, containerW, rowH)

        LayoutRowDivider(rowPanel, rowData, containerW, rowH, i < mRowViews.Size - 1)
        y = y + rowH
    Next

    pnlContainer.Height = y
    MaybeAdjustAutoHeight
End Sub

Private Sub MaybeAdjustAutoHeight
    If mbAutoHeight = False Then Return
    If mBase.IsInitialized = False Then Return
    If mbAutoSizing Then Return

    Dim desiredH As Int = getContentHeight
    If Abs(mBase.Height - desiredH) < 1dip Then Return

    mbAutoSizing = True
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, desiredH)
    Base_Resize(mBase.Width, desiredH)
    mbAutoSizing = False
End Sub

Private Sub NormalizeSizeSpec(Value As String, DefaultValue As String) As String
    If Value = Null Then Return DefaultValue
    Dim s As String = Value.Trim.ToLowerCase
    If s.Length = 0 Then Return DefaultValue
    If s = "w-full" Then Return "full"
    If s = "h-auto" Then Return "auto"
    Return s
End Sub

Private Sub ResolveWidthDip(Fallback As Int) As Int
    Dim parentW As Int = Fallback
    If mBase.IsInitialized Then
        Dim parent As B4XView = mBase.Parent
        If parent.IsInitialized Then parentW = Max(1dip, parent.Width - mBase.Left)
    End If
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msWidth, parentW))
End Sub

Private Sub ResolveHeightDip(Fallback As Int) As Int
    Dim parentH As Int = Fallback
    If mBase.IsInitialized Then
        Dim parent As B4XView = mBase.Parent
        If parent.IsInitialized Then parentH = Max(1dip, parent.Height - mBase.Top)
    End If
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msHeight, parentH))
End Sub

Private Sub LayoutRowItems(RowPanel As B4XView, RowData As Map, RowW As Float, DefaultRowH As Float) As Float
    Dim items As List = RowData.Get("items")
    If items.IsInitialized = False Then Return Max(1dip, DefaultRowH)

    Dim padding As Int = miRowPadding

    Dim inlineItems As List
    inlineItems.Initialize
    Dim wrapItems As List
    wrapItems.Initialize

    Dim growCount As Int = 0
    Dim fixedTotalW As Float = 0
    Dim maxInlineH As Float = 0

    For i = 0 To items.Size - 1
        Dim item As Map = items.Get(i)
        Dim itemView As B4XView = item.Get("view")
        If itemView.IsInitialized = False Then Continue

        Dim isWrap As Boolean = item.GetDefault("wrap", False)
        If isWrap Then
            wrapItems.Add(item)
        Else
            inlineItems.Add(item)

            Dim isGrow As Boolean = item.GetDefault("grow", False)
            If isGrow Then
                growCount = growCount + 1
            Else
                fixedTotalW = fixedTotalW + ResolveItemWidth(item, itemView)
            End If

            maxInlineH = Max(maxInlineH, ResolveItemHeight(item, itemView, DefaultRowH - (padding * 2)))
        End If
    Next

    Dim inlineCount As Int = inlineItems.Size
    Dim totalGap As Float = 0
    If inlineCount > 1 Then totalGap = (inlineCount - 1) * miRowGap

    Dim hasExplicitGrow As Boolean = growCount > 0
    Dim defaultGrowIndex As Int = -1
    If hasExplicitGrow = False And inlineCount >= 2 Then
        defaultGrowIndex = 1
        Dim defaultGrowItem As Map = inlineItems.Get(defaultGrowIndex)
        Dim defaultGrowView As B4XView = defaultGrowItem.Get("view")
        fixedTotalW = Max(0, fixedTotalW - ResolveItemWidth(defaultGrowItem, defaultGrowView))
        growCount = 1
    End If

    Dim availableGrowW As Float = Max(0, RowW - (padding * 2) - fixedTotalW - totalGap)
    Dim growW As Float = 0
    If growCount > 0 Then growW = availableGrowW / growCount

    If maxInlineH <= 0 Then maxInlineH = Max(1dip, DefaultRowH - (padding * 2))

    Dim currentX As Float = padding
    For j = 0 To inlineItems.Size - 1
        Dim item As Map = inlineItems.Get(j)
        Dim itemView As B4XView = item.Get("view")

        Dim isGrow As Boolean = item.GetDefault("grow", False)
        Dim useGrow As Boolean = isGrow
        If useGrow = False And defaultGrowIndex = j Then useGrow = True

        Dim w As Float = ResolveItemWidth(item, itemView)
        If useGrow Then w = Max(1dip, growW)

        Dim h As Float = ResolveItemHeight(item, itemView, maxInlineH)
        Dim itemY As Float = padding + Max(0, (maxInlineH - h) / 2)

        itemView.SetLayoutAnimated(0, currentX, itemY, Max(1dip, w), Max(1dip, h))
        currentX = currentX + Max(1dip, w) + miRowGap
    Next

    Dim contentBottom As Float = padding
    If inlineItems.Size > 0 Then contentBottom = padding + maxInlineH

    For j = 0 To wrapItems.Size - 1
        Dim wrapItem As Map = wrapItems.Get(j)
        Dim wrapView As B4XView = wrapItem.Get("view")

        If contentBottom > padding Then contentBottom = contentBottom + miRowGap

        Dim wrapW As Float = Max(1dip, RowW - (padding * 2))
        Dim wrapH As Float = ResolveItemHeight(wrapItem, wrapView, DefaultRowH - (padding * 2))

        wrapView.SetLayoutAnimated(0, padding, contentBottom, wrapW, wrapH)
        contentBottom = contentBottom + wrapH
    Next

    Return Max(DefaultRowH, contentBottom + padding)
End Sub


Private Sub EstimateRowBaseHeight(RowData As Map) As Float
    Dim items As List = RowData.Get("items")
    If items.IsInitialized = False Then Return 40dip

    Dim inlineMaxH As Float = 0
    Dim wrapTotalH As Float = 0
    Dim wrapCount As Int = 0

    For i = 0 To items.Size - 1
        Dim item As Map = items.Get(i)
        Dim itemView As B4XView = item.Get("view")
        If itemView.IsInitialized = False Then Continue

        Dim isWrap As Boolean = item.GetDefault("wrap", False)
        Dim h As Float = ResolveItemHeight(item, itemView, 40dip)

        If isWrap Then
            wrapTotalH = wrapTotalH + h
            wrapCount = wrapCount + 1
        Else
            inlineMaxH = Max(inlineMaxH, h)
        End If
    Next

    If inlineMaxH <= 0 And wrapCount = 0 Then inlineMaxH = 40dip

    Dim total As Float = (miRowPadding * 2)
    total = total + inlineMaxH

    If wrapCount > 0 Then
        If inlineMaxH > 0 Then total = total + miRowGap
        total = total + wrapTotalH
        If wrapCount > 1 Then total = total + ((wrapCount - 1) * miRowGap)
    End If

    Return Max(40dip, total)
End Sub

Private Sub ResolveItemWidth(Item As Map, ItemView As B4XView) As Float
    Dim w As Float = Item.GetDefault("width", 0)
    If w <= 0 Then w = ItemView.Width
    If w <= 0 Then w = 1dip
    Return w
End Sub

Private Sub ResolveItemHeight(Item As Map, ItemView As B4XView, DefaultHeight As Float) As Float
    Dim h As Float = Item.GetDefault("height", 0)
    If h <= 0 Then h = ItemView.Height
    If h <= 0 Then h = DefaultHeight
    If h <= 0 Then h = 1dip
    Return h
End Sub

Private Sub LayoutRowDivider(RowPanel As B4XView, RowData As Map, RowW As Float, RowH As Float, IsBeforeLast As Boolean)
    Dim dividerObj As Object = RowData.GetDefault("dividerView", Null)
    Dim divider As B4XView
    If dividerObj <> Null Then divider = dividerObj

    If mbShowDivider = False Or IsBeforeLast = False Then
        If divider.IsInitialized Then divider.Visible = False
        Return
    End If

    If divider.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        divider = p
        RowPanel.AddView(divider, 0, 0, 0, 0)
        RowData.Put("dividerView", divider)
    End If

    Dim inset As Int = B4XDaisyVariants.GetRadiusBoxDip(8dip)
    Dim lineW As Float = Max(1dip, RowW - (inset * 2))
    Dim lineY As Float = Max(0, RowH - 1dip)
    Dim baseDividerColor As Int = B4XDaisyVariants.ResolveBorderColorVariant(msDividerColor, xui.Color_ARGB(13, 0, 0, 0))
    Dim lineColor As Int = B4XDaisyVariants.SetAlpha(baseDividerColor, 22)

    divider.Color = lineColor
    divider.Visible = True
    divider.SetLayoutAnimated(0, inset, lineY, lineW, 1dip)
End Sub

Private Sub ApplyStyles
    If mBase.IsInitialized = False Then Return

    Dim bgColor As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundColor, xui.Color_White)
    mBase.Color = bgColor

    Dim radius As Int = 0
    If mbRoundedBox Then radius = B4XDaisyVariants.GetRadiusBoxDip(8dip)

    mBase.SetColorAndBorder(bgColor, 0, xui.Color_Transparent, radius)

    Dim shadowToken As String = NormalizeShadowToken(msShadow)
    B4XDaisyVariants.ApplyElevation(mBase, shadowToken)
    ApplyInteractionState
End Sub

Private Sub ApplyInteractionState
    If mBase.IsInitialized = False Then Return
    mBase.Visible = mbVisible
    mBase.Enabled = mbEnabled
End Sub

Private Sub NormalizeShadowToken(Value As String) As String
    If Value = Null Then Return "none"

    Dim v As String = Value.Trim.ToLowerCase
    Select Case v
        Case "shadow"
            Return "sm"
        Case "shadow-sm"
            Return "sm"
        Case "shadow-md"
            Return "md"
        Case "shadow-lg"
            Return "lg"
        Case "shadow-xl"
            Return "xl"
        Case "shadow-2xl"
            Return "2xl"
        Case "none", ""
            Return "none"
        Case Else
            Return "none"
    End Select
End Sub

' =======================
' Public API - Rows
' =======================

''' <summary>
''' Adds a new row to the list.
''' </summary>
Public Sub AddRow(Data As Map) As Int
    Dim items As List = Data.Get("items")
    If items.IsInitialized = False Then items.Initialize

    Dim rowData As Map = CreateMap( _
        "items": items, _
        "height": Data.GetDefault("height", 40dip), _
        "Tag": Data.GetDefault("Tag", Null), _
        "colGrow": Data.GetDefault("colGrow", 0), _
        "colWrap": Data.GetDefault("colWrap", False))

    Dim colGrow As Int = rowData.GetDefault("colGrow", 0)
    If colGrow > 0 And colGrow <= items.Size Then
        Dim growItem As Map = items.Get(colGrow - 1)
        growItem.Put("grow", True)
    End If

    For i = 0 To items.Size - 1
        Dim item As Map = items.Get(i)
        item.Put("grow", item.GetDefault("grow", False))
        item.Put("wrap", item.GetDefault("wrap", False))
    Next

    mRows.Add(rowData)

    Dim rowPanel As Panel
    rowPanel.Initialize("row")
    rowPanel.Color = xui.Color_Transparent
    pnlContainer.AddView(rowPanel, 0, 0, pnlContainer.Width, Max(1dip, rowData.Get("height")))

    Dim itemViews As List
    itemViews.Initialize

    For i = 0 To items.Size - 1
        Dim item As Map = items.Get(i)
        Dim itemView As B4XView = item.Get("view")

        If itemView.IsInitialized Then
            Dim itemW As Float = ResolveItemWidth(item, itemView)
            Dim itemH As Float = ResolveItemHeight(item, itemView, rowData.Get("height"))
            rowPanel.AddView(itemView, 0, 0, Max(1dip, itemW), Max(1dip, itemH))
            itemViews.Add(itemView)
        End If
    Next

    rowData.Put("itemViews", itemViews)
    mRowViews.Add(rowPanel)

    Dim idx As Int = mRows.Size - 1
    rowPanel.Tag = idx

    LayoutRows
    Return idx
End Sub

''' <summary>
''' Clears all rows.
''' </summary>
Public Sub Clear
    For Each row As B4XView In mRowViews
        If row.IsInitialized Then row.RemoveViewFromParent
    Next
    mRows.Clear
    mRowViews.Clear
    LayoutRows
End Sub

''' <summary>
''' Gets the number of rows.
''' </summary>
Public Sub getRowCount As Int
    Return mRows.Size
End Sub

''' <summary>
''' Gets a row by index.
''' </summary>
Public Sub GetRow(Index As Int) As Map
    If Index < 0 Or Index >= mRows.Size Then Return Null
    Return mRows.Get(Index)
End Sub

''' <summary>
''' Removes a row by index.
''' </summary>
Public Sub RemoveRow(Index As Int)
    If Index < 0 Or Index >= mRows.Size Then Return

    Dim row As B4XView = mRowViews.Get(Index)
    If row.IsInitialized Then row.RemoveViewFromParent

    mRows.RemoveAt(Index)
    mRowViews.RemoveAt(Index)

    For i = Index To mRowViews.Size - 1
        Dim rowPanel As B4XView = mRowViews.Get(i)
        rowPanel.Tag = i
    Next

    LayoutRows
End Sub

' =======================
' Public API - Properties
' =======================

Public Sub setBackgroundColor(Value As String)
    msBackgroundColor = Value
    ApplyStyles
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setTextColor(Value As String)
    msTextColor = Value
    ApplyStyles
End Sub

Public Sub getTextColor As String
    Return msTextColor
End Sub

Public Sub setRoundedBox(Value As Boolean)
    mbRoundedBox = Value
    ApplyStyles
End Sub

Public Sub getRoundedBox As Boolean
    Return mbRoundedBox
End Sub

Public Sub setShadow(Value As String)
    msShadow = Value
    ApplyStyles
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setPadding(Value As Int)
    miPadding = Value
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPadding As Int
    Return miPadding
End Sub

Public Sub setRowPadding(Value As Int)
    miRowPadding = Value
    LayoutRows
End Sub

Public Sub getRowPadding As Int
    Return miRowPadding
End Sub

Public Sub setRowGap(Value As Int)
    miRowGap = Value
    LayoutRows
End Sub

Public Sub getRowGap As Int
    Return miRowGap
End Sub

Public Sub setDivider(Value As Boolean)
    mbShowDivider = Value
    LayoutRows
End Sub

Public Sub getDivider As Boolean
    Return mbShowDivider
End Sub

Public Sub setDividerColor(Value As String)
    msDividerColor = Value
    LayoutRows
End Sub

Public Sub getDividerColor As String
    Return msDividerColor
End Sub

Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
    ApplyInteractionState
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mbVisible = Value
    ApplyInteractionState
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setWidth(Value As Object)
    msWidth = NormalizeSizeSpec(B4XDaisyVariants.NormalizeSizeSpec(Value, "full"), "full")
    If mBase.IsInitialized = False Then Return
    Dim w As Int = ResolveWidthDip(mBase.Width)
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, mBase.Height)
    Base_Resize(w, mBase.Height)
End Sub

Public Sub getWidth As Int
    If mBase.IsInitialized Then Return mBase.Width
    Return 0
End Sub

Public Sub setHeight(Value As Object)
    msHeight = NormalizeSizeSpec(B4XDaisyVariants.NormalizeSizeSpec(Value, "auto"), "auto")
    mbAutoHeight = (msHeight = "auto")
    If mBase.IsInitialized = False Then Return

    If mbAutoHeight Then
        LayoutRows
        Return
    End If

    Dim h As Int = ResolveHeightDip(mBase.Height)
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, h)
    Base_Resize(mBase.Width, h)
End Sub

Public Sub getHeight As Int
    If mBase.IsInitialized Then Return mBase.Height
    Return 0
End Sub

Public Sub getContentHeight As Int
    If pnlContainer.IsInitialized = False Then Return Max(1dip, miPadding * 2)
    Return Max(1dip, Ceil(pnlContainer.Height + (miPadding * 2)))
End Sub

' =======================
' Public API - Tag
' =======================

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

' =======================
' Base Events
' =======================

Private Sub Row_Click
    Dim rowPanel As B4XView = Sender
    Dim idx As Int = rowPanel.Tag
    If idx >= 0 And idx < mRows.Size Then
        Dim rowData As Map = mRows.Get(idx)
        Dim payload As Object = rowData.GetDefault("Tag", Null)
        RaiseEvent(mEventName & "_ItemClick", idx, payload)
    End If
End Sub

Private Sub RaiseEvent(EventName As String, Index As Int, Tag As Object)
    If xui.SubExists(mCallBack, EventName, 2) Then
        CallSub3(mCallBack, EventName, Index, Tag)
    End If
End Sub

Private Sub Row_LongClick As Boolean
    Dim rowPanel As B4XView = Sender
    Dim idx As Int = rowPanel.Tag
    If idx >= 0 And idx < mRows.Size Then
        Dim rowData As Map = mRows.Get(idx)
        Dim payload As Object = rowData.GetDefault("Tag", Null)
        RaiseEvent(mEventName & "_ItemLongClick", idx, payload)
    End If
    Return True
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim widthSpec As String = msWidth
    Dim heightSpec As String = msHeight
    If Width > 0 Then widthSpec = B4XDaisyVariants.ResolvePxSizeSpec(Width)
    If Height > 0 Then heightSpec = B4XDaisyVariants.ResolvePxSizeSpec(Height)

    Dim widthBase As Int = Max(1dip, Parent.Width - Left)
    Dim heightBase As Int = Max(1dip, Parent.Height - Top)
    Dim targetW As Int = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(widthSpec, widthBase))
    Dim targetH As Int
    If Height > 0 Then
        targetH = Height
    Else
        If heightSpec = "auto" Then
            targetH = 1dip
        Else
            targetH = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(heightSpec, heightBase))
        End If
    End If

    Dim p As Panel
    p.Initialize("")
    mBase = p
    Parent.AddView(mBase, Left, Top, targetW, targetH)

    Dim props As Map = CreateMap( _
        "Width": widthSpec, _
        "Height": heightSpec, _
        "BackgroundColor": msBackgroundColor, _
        "TextColor": msTextColor, _
        "RoundedBox": mbRoundedBox, _
        "Shadow": msShadow, _
        "Padding": miPadding, _
        "RowPadding": miRowPadding, _
        "RowGap": miRowGap, _
        "DividerColor": msDividerColor, _
        "Divider": mbShowDivider, _
        "Enabled": mbEnabled, _
        "Visible": mbVisible)

    Dim dummy As Label
    DesignerCreateView(mBase, dummy, props)
    Return mBase
End Sub

Public Sub UpdateTheme
    ApplyStyles
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Refresh
    ApplyStyles
    LayoutRows
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

' =======================
' Convenience Methods
' =======================

''' <summary>
''' Adds a simple text row.
''' </summary>
Public Sub AddTextRow(Title As String, OptionalSubtitle As String) As Int
    Dim items As List
    items.Initialize

    Dim titleView As B4XView = CreateTextItemView(Title, 180dip, 20dip, 14, xui.Color_Black, False, True)
    items.Add(CreateMap("view": titleView, "grow": True, "height": 20dip))

    Dim data As Map = CreateMap("items": items, "height": 40dip, "Tag": Title)
    Return AddRow(data)
End Sub

''' <summary>
''' Adds a row with multiple items.
''' </summary>
Public Sub AddRowWithItems(Views As List, OptionalHeight As Int) As Int
    Dim items As List
    items.Initialize

    For Each v As B4XView In Views
        items.Add(CreateMap("view": v, "grow": False))
    Next

    Dim h As Int = 40dip
    If OptionalHeight > 0 Then h = OptionalHeight

    Dim data As Map = CreateMap("items": items, "height": h)
    Return AddRow(data)
End Sub

Public Sub CreateTextItemView(Text As String, Width As Int, Height As Int, TextSize As Object, TextColor As Int, Bold As Boolean, SingleLine As Boolean) As B4XView
    Dim t As B4XDaisyText
    t.Initialize(Me, "")
    Dim v As B4XView = t.CreateView(Max(1dip, Width), Max(1dip, Height))
    t.Text = Text
    t.TextSize = TextSize
    t.TextColor = TextColor
    t.FontBold = Bold
    t.SingleLine = SingleLine
    Return v
End Sub

Public Sub CreateStackedTextView(Title As String, Subtitle As String, Width As Int, TitleSize As Object, SubtitleSize As Object, TitleColor As Int, SubtitleColor As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    Dim totalH As Int = 36dip
    host.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), totalH)
    host.Color = xui.Color_Transparent

    Dim topView As B4XView = CreateTextItemView(Title, Width, 20dip, TitleSize, TitleColor, False, True)
    host.AddView(topView, 0, 0, Width, 20dip)

    Dim bottomView As B4XView = CreateTextItemView(Subtitle, Width, 16dip, SubtitleSize, SubtitleColor, False, True)
    host.AddView(bottomView, 0, 20dip, Width, 16dip)

    Return host
End Sub





