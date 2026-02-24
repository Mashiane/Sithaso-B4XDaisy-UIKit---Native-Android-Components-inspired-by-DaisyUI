B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XFlexLayout.bas
'Flex-like layout helper for B4X/XUI (native)
'v3: row/column reverse, wrap modes, align-content, space-around/evenly, % basis,
'    grow/shrink, margins, align-self, order, wrapBefore

Sub Class_Globals
    Private xui As XUI

    'Main axis direction:
    ' "row", "row-reverse", "column", "column-reverse"
    Public Direction As String = "row"

    'Wrap mode:
    ' "nowrap", "wrap", "wrap-reverse"
    Public WrapMode As String = "wrap"

    'Backward compat (optional)
    Public Wrap As Boolean = True

    Public GapX As Int = 0dip
    Public GapY As Int = 0dip

    Public PaddingLeft As Int = 0dip
    Public PaddingTop As Int = 0dip
    Public PaddingRight As Int = 0dip
    Public PaddingBottom As Int = 0dip

    ' "start","center","end","space-between","space-around","space-evenly"
    Public JustifyContent As String = "start"

    ' "start","center","end","stretch"
    Public AlignItems As String = "start"

    ' multi-line packing:
    ' "start","center","end","space-between","space-around","space-evenly","stretch"
    Public AlignContent As String = "start"

    Public AnimateDuration As Int = 0

    'If True, shrink can happen even when WrapMode is wrap/wrap-reverse and a line overflows
    Public AllowShrinkWhenWrap As Boolean = False

    Private mContainer As B4XView
    Private mItemMeta As Map 'key=view, value=meta map
End Sub

Public Sub Initialize(Container As B4XView)
    mContainer = Container
    mItemMeta.Initialize
End Sub

Public Sub SetContainer(Container As B4XView)
    mContainer = Container
End Sub

Public Sub SetPadding(All As Int)
    PaddingLeft = All : PaddingTop = All : PaddingRight = All : PaddingBottom = All
End Sub

Public Sub SetPaddingLTRB(Left As Int, Top As Int, Right As Int, Bottom As Int)
    PaddingLeft = Left : PaddingTop = Top : PaddingRight = Right : PaddingBottom = Bottom
End Sub

Public Sub SetGap(X As Int, Y As Int)
    GapX = X : GapY = Y
End Sub

'========================
' ITEM META API
'========================

'Grow/Shrink + min/max constraints
Public Sub SetItemFlexEx(v As B4XView, Grow As Float, Shrink As Float, MinW As Int, MaxW As Int, MinH As Int, MaxH As Int)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("grow", Grow)
    meta.Put("shrink", Shrink)
    meta.Put("minw", MinW)
    meta.Put("maxw", MaxW)
    meta.Put("minh", MinH)
    meta.Put("maxh", MaxH)
End Sub

'Optional absolute basis override. Use -1 for "not set"
Public Sub SetItemBasis(v As B4XView, BasisW As Int, BasisH As Int)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("basisw", BasisW)
    meta.Put("basish", BasisH)
End Sub

'Percent basis relative to container inner size.
'PercentMain applies to main axis size, PercentCross applies to cross axis size.
'Use -1 for "not set"
Public Sub SetItemBasisPercent(v As B4XView, PercentMain As Float, PercentCross As Float)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("basis_main_pct", PercentMain)
    meta.Put("basis_cross_pct", PercentCross)
End Sub

Public Sub ClearItemBasisPercent(v As B4XView)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("basis_main_pct", -1)
    meta.Put("basis_cross_pct", -1)
End Sub

'Per-item margins
Public Sub SetItemMargins(v As B4XView, Left As Int, Top As Int, Right As Int, Bottom As Int)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("ml", Left)
    meta.Put("mt", Top)
    meta.Put("mr", Right)
    meta.Put("mb", Bottom)
End Sub

'align-self: "auto","start","center","end","stretch" (+ flex-start/flex-end aliases)
Public Sub SetItemAlignSelf(v As B4XView, AlignSelf As String)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("alignself", NormalizeKeyword(AlignSelf))
End Sub

'Lower order renders first (default 0)
Public Sub SetItemOrder(v As B4XView, OrderValue As Int)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("order", OrderValue)
End Sub

'If True, starts a new line/column before this item (when wrapping enabled)
Public Sub SetItemWrapBefore(v As B4XView, Value As Boolean)
    Dim meta As Map = GetOrCreateMeta(v)
    meta.Put("wrapbefore", Value)
End Sub

Public Sub ClearItemMeta(v As B4XView)
    If mItemMeta.IsInitialized = False Then Return
    If mItemMeta.ContainsKey(v) Then mItemMeta.Remove(v)
End Sub

Public Sub ClearAllItemMeta
    mItemMeta.Clear
End Sub

Public Sub Relayout
    If mContainer.IsInitialized = False Then Return

    NormalizeLegacySettings

    If IsRowDirection Then
        LayoutRow
    Else
        LayoutColumn
    End If
End Sub

'========================
' ROW LAYOUT
'========================
Private Sub LayoutRow
    Dim items As List = GetOrderedVisibleChildren(mContainer)
    If items.Size = 0 Then Return

    Dim innerX As Int = PaddingLeft
    Dim innerY As Int = PaddingTop
    Dim innerW As Int = MaxI(0, mContainer.Width - PaddingLeft - PaddingRight)
    Dim innerH As Int = MaxI(0, mContainer.Height - PaddingTop - PaddingBottom)

    Dim lines As List
    lines.Initialize

    Dim currentLine As List
    currentLine.Initialize

    Dim lineBaseW As Int = 0  'outer widths + gaps
    Dim lineCrossH As Int = 0 'max outer heights

    For Each v As B4XView In items
        Dim meta As Map = GetMeta(v)

        Dim baseW As Int = ClampWidth(ResolveBasisW(v, meta), meta)
        Dim baseH As Int = ClampHeight(ResolveBasisH(v, meta), meta)

        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)
        Dim wrapBefore As Boolean = GetMetaBool(meta, "wrapbefore", False)

        Dim itemOuterW As Int = ml + baseW + mr
        Dim itemOuterH As Int = mt + baseH + mb

        If IsWrapEnabled = False Then
            currentLine.Add(CreateItemInfo(v, baseW, baseH, meta))
            lineBaseW = lineBaseW + IIfI(currentLine.Size = 1, 0, GapX) + itemOuterW
            If itemOuterH > lineCrossH Then lineCrossH = itemOuterH
            Continue
        End If

        If wrapBefore And currentLine.Size > 0 Then
            lines.Add(CreateLineInfo(currentLine, lineBaseW, lineCrossH))
            currentLine.Initialize
            lineBaseW = 0
            lineCrossH = 0
        End If

        Dim proposed As Int
        If currentLine.Size = 0 Then
            proposed = itemOuterW
        Else
            proposed = lineBaseW + GapX + itemOuterW
        End If

        If proposed > innerW And currentLine.Size > 0 Then
            lines.Add(CreateLineInfo(currentLine, lineBaseW, lineCrossH))
            currentLine.Initialize
            currentLine.Add(CreateItemInfo(v, baseW, baseH, meta))
            lineBaseW = itemOuterW
            lineCrossH = itemOuterH
        Else
            currentLine.Add(CreateItemInfo(v, baseW, baseH, meta))
            lineBaseW = proposed
            If itemOuterH > lineCrossH Then lineCrossH = itemOuterH
        End If
    Next

    If currentLine.Size > 0 Then lines.Add(CreateLineInfo(currentLine, lineBaseW, lineCrossH))

    'First pass: flex on each line + recompute line metrics
    Dim lineHeights As List
    lineHeights.Initialize
    For Each line As Map In lines
        Dim lineItems As List = line.Get("items")
        ApplyMainAxisFlexRow(lineItems, innerW)
        line.Put("width", ComputeRowContentWidth(lineItems))
        line.Put("height", ComputeRowContentHeight(lineItems))
        lineHeights.Add(line.Get("height"))
    Next

    'Align-content packs lines on cross axis (vertical for row)
    If NormalizeKeyword(AlignContent) = "stretch" Then
        StretchLineSizes(lineHeights, innerH, GapY)
    End If

    Dim pack As Map = ComputePackedOffsets(lineHeights, innerH, GapY, NormalizeKeyword(AlignContent))
    Dim yOffsets As List = pack.Get("offsets")

    'wrap-reverse mirrors line stack
    If IsWrapReverse Then
        Dim mirrored As List
        mirrored.Initialize
        For i = 0 To yOffsets.Size - 1
            Dim lineH As Int = lineHeights.Get(i)
            Dim y0 As Int = yOffsets.Get(i)
            mirrored.Add(innerH - (y0 + lineH))
        Next
        yOffsets = mirrored
    End If

    For li = 0 To lines.Size - 1
        Dim line As Map = lines.Get(li)
        Dim lineItems As List = line.Get("items")
        Dim contentW As Int = line.Get("width")
        Dim contentH As Int = line.Get("height")
        Dim packedH As Int = lineHeights.Get(li) 'may exceed contentH when align-content:stretch

        Dim y As Int = innerY + yOffsets.Get(li)

        Dim startX As Int = innerX
        Dim effectiveGapX As Int = GapX

        Select NormalizeKeyword(JustifyContent)
            Case "center"
                startX = innerX + MaxI(0, (innerW - contentW) / 2)
            Case "end"
                startX = innerX + MaxI(0, innerW - contentW)
            Case "space-between"
                If lineItems.Size > 1 Then
                    Dim totalOuterW As Int = SumRowOuterFinalWidths(lineItems)
                    Dim available As Int = MaxI(0, innerW - totalOuterW)
                    effectiveGapX = available / (lineItems.Size - 1)
                    startX = innerX
                Else
                    startX = innerX
                End If
            Case "space-around"
                If lineItems.Size > 0 Then
                    Dim totalOuterW2 As Int = SumRowOuterFinalWidths(lineItems)
                    Dim free2 As Int = MaxI(0, innerW - totalOuterW2)
                    effectiveGapX = free2 / lineItems.Size
                    startX = innerX + effectiveGapX / 2
                Else
                    startX = innerX
                End If
            Case "space-evenly"
                If lineItems.Size > 0 Then
                    Dim totalOuterW3 As Int = SumRowOuterFinalWidths(lineItems)
                    Dim free3 As Int = MaxI(0, innerW - totalOuterW3)
                    effectiveGapX = free3 / (lineItems.Size + 1)
                    startX = innerX + effectiveGapX
                Else
                    startX = innerX
                End If
            Case Else 'start
                startX = innerX
        End Select

        Dim placeItems As List = lineItems
        If IsReverseMain Then placeItems = ReversedList(lineItems)

        Dim x As Int = startX

        For i = 0 To placeItems.Size - 1
            Dim item As Map = placeItems.Get(i)
            Dim v As B4XView = item.Get("view")
            Dim w As Int = item.Get("fw")
            Dim h As Int = item.Get("fh")
            Dim meta As Map = item.Get("meta")

            Dim ml As Int = GetMetaInt(meta, "ml", 0)
            Dim mt As Int = GetMetaInt(meta, "mt", 0)
            Dim mr As Int = GetMetaInt(meta, "mr", 0)
            Dim mb As Int = GetMetaInt(meta, "mb", 0)

            Dim outerH As Int = mt + h + mb
            Dim itemX As Int = x + ml
            Dim itemY As Int = y + mt
            Dim itemH As Int = h

            Dim alignMode As String = ResolveAlignMode(meta)

            Select alignMode
                Case "center"
                    itemY = y + MaxI(0, (packedH - outerH) / 2) + mt
                Case "end"
                    itemY = y + MaxI(0, packedH - outerH) + mt
                Case "stretch"
                    itemY = y + mt
                    itemH = MaxI(0, packedH - mt - mb)
                    itemH = ClampHeight(itemH, meta)
                Case Else 'start
                    itemY = y + mt
            End Select

            v.SetLayoutAnimated(AnimateDuration, itemX, itemY, w, itemH)
            x = x + ml + w + mr + effectiveGapX
        Next
    Next
End Sub

Private Sub ApplyMainAxisFlexRow(lineItems As List, innerW As Int)
    If lineItems.Size = 0 Then Return

    Dim gapTotal As Int = GapX * MaxI(0, lineItems.Size - 1)
    Dim totalBaseOuterW As Int = 0

    For Each item As Map In lineItems
        Dim meta As Map = item.Get("meta")
        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)

        item.Put("fw", item.Get("w"))
        item.Put("fh", item.Get("h"))

        totalBaseOuterW = totalBaseOuterW + ml + item.Get("w") + mr
    Next

    Dim availableForItems As Int = MaxI(0, innerW - gapTotal)
    Dim delta As Int = availableForItems - totalBaseOuterW

    If delta > 0 Then
        ApplyGrowRow(lineItems, delta)
    Else If delta < 0 Then
        If IsWrapEnabled = False Or AllowShrinkWhenWrap Then
            ApplyShrinkRow(lineItems, -delta)
        End If
    End If
End Sub

Private Sub ApplyGrowRow(lineItems As List, extraPx As Int)
    Dim totalGrow As Float = 0
    For Each item As Map In lineItems
        Dim meta As Map = item.Get("meta")
        totalGrow = totalGrow + MaxF(0, GetMetaFloat(meta, "grow", 0))
    Next
    If totalGrow <= 0 Then Return

    Dim allocated As Int = 0
    For i = 0 To lineItems.Size - 1
        Dim item As Map = lineItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim g As Float = MaxF(0, GetMetaFloat(meta, "grow", 0))
        If g <= 0 Then Continue

        Dim add As Int
        If i = lineItems.Size - 1 Then
            add = extraPx - allocated
        Else
            add = Floor((extraPx * g) / totalGrow)
            allocated = allocated + add
        End If

        Dim newW As Int = ClampWidth(item.Get("fw") + add, meta)
        item.Put("fw", newW)
    Next

    NormalizeRowToTarget(lineItems, extraPx, True)
End Sub

Private Sub ApplyShrinkRow(lineItems As List, overflowPx As Int)
    Dim totalShrinkFactor As Float = 0
    For Each item As Map In lineItems
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        totalShrinkFactor = totalShrinkFactor + (s * item.Get("w"))
    Next
    If totalShrinkFactor <= 0 Then Return

    Dim reduced As Int = 0
    For i = 0 To lineItems.Size - 1
        Dim item As Map = lineItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        If s = 0 Then Continue

        Dim basisW As Int = item.Get("w")
        Dim factor As Float = s * basisW

        Dim cut As Int
        If i = lineItems.Size - 1 Then
            cut = overflowPx - reduced
        Else
            cut = Floor((overflowPx * factor) / totalShrinkFactor)
            reduced = reduced + cut
        End If

        Dim newW As Int = ClampWidth(item.Get("fw") - cut, meta)
        item.Put("fw", newW)
    Next

    NormalizeRowToTarget(lineItems, overflowPx, False)
End Sub

Private Sub NormalizeRowToTarget(lineItems As List, targetDelta As Int, isGrow As Boolean)
    Dim currentBaseOuter As Int = 0
    Dim currentFinalOuter As Int = 0

    For Each item As Map In lineItems
        Dim meta As Map = item.Get("meta")
        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)
        currentBaseOuter = currentBaseOuter + ml + item.Get("w") + mr
        currentFinalOuter = currentFinalOuter + ml + item.Get("fw") + mr
    Next

    Dim actualDelta As Int = currentFinalOuter - currentBaseOuter
    Dim remain As Int

    If isGrow Then
        remain = targetDelta - actualDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed As Boolean = False
            For Each item As Map In lineItems
                If remain <= 0 Then Exit
                Dim meta As Map = item.Get("meta")
                Dim maxw As Int = GetMetaInt(meta, "maxw", -1)
                Dim fw As Int = item.Get("fw")
                If maxw <> -1 And fw >= maxw Then Continue
                item.Put("fw", fw + 1)
                remain = remain - 1
                changed = True
            Next
            If changed = False Then Exit
        Loop
    Else
        remain = actualDelta + targetDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed2 As Boolean = False
            For Each item As Map In lineItems
                If remain <= 0 Then Exit
                Dim meta2 As Map = item.Get("meta")
                Dim minw As Int = GetMetaInt(meta2, "minw", -1)
                Dim fw2 As Int = item.Get("fw")
                If minw <> -1 And fw2 <= minw Then Continue
                If fw2 <= 0 Then Continue
                item.Put("fw", fw2 - 1)
                remain = remain - 1
                changed2 = True
            Next
            If changed2 = False Then Exit
        Loop
    End If
End Sub

'========================
' COLUMN LAYOUT
'========================
Private Sub LayoutColumn
    Dim items As List = GetOrderedVisibleChildren(mContainer)
    If items.Size = 0 Then Return

    Dim innerX As Int = PaddingLeft
    Dim innerY As Int = PaddingTop
    Dim innerW As Int = MaxI(0, mContainer.Width - PaddingLeft - PaddingRight)
    Dim innerH As Int = MaxI(0, mContainer.Height - PaddingTop - PaddingBottom)

    Dim cols As List
    cols.Initialize

    Dim currentCol As List
    currentCol.Initialize

    Dim colBaseH As Int = 0
    Dim colCrossW As Int = 0

    For Each v As B4XView In items
        Dim meta As Map = GetMeta(v)

        Dim baseW As Int = ClampWidth(ResolveBasisW(v, meta), meta)
        Dim baseH As Int = ClampHeight(ResolveBasisH(v, meta), meta)

        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)
        Dim wrapBefore As Boolean = GetMetaBool(meta, "wrapbefore", False)

        Dim itemOuterW As Int = ml + baseW + mr
        Dim itemOuterH As Int = mt + baseH + mb

        If IsWrapEnabled = False Then
            currentCol.Add(CreateItemInfo(v, baseW, baseH, meta))
            colBaseH = colBaseH + IIfI(currentCol.Size = 1, 0, GapY) + itemOuterH
            If itemOuterW > colCrossW Then colCrossW = itemOuterW
            Continue
        End If

        If wrapBefore And currentCol.Size > 0 Then
            cols.Add(CreateLineInfo(currentCol, colCrossW, colBaseH))
            currentCol.Initialize
            colBaseH = 0
            colCrossW = 0
        End If

        Dim proposed As Int
        If currentCol.Size = 0 Then
            proposed = itemOuterH
        Else
            proposed = colBaseH + GapY + itemOuterH
        End If

        If proposed > innerH And currentCol.Size > 0 Then
            cols.Add(CreateLineInfo(currentCol, colCrossW, colBaseH))
            currentCol.Initialize
            currentCol.Add(CreateItemInfo(v, baseW, baseH, meta))
            colBaseH = itemOuterH
            colCrossW = itemOuterW
        Else
            currentCol.Add(CreateItemInfo(v, baseW, baseH, meta))
            colBaseH = proposed
            If itemOuterW > colCrossW Then colCrossW = itemOuterW
        End If
    Next

    If currentCol.Size > 0 Then cols.Add(CreateLineInfo(currentCol, colCrossW, colBaseH))

    'First pass: flex on each col + recompute metrics
    Dim colWidths As List
    colWidths.Initialize
    For Each col As Map In cols
        Dim colItems As List = col.Get("items")
        ApplyMainAxisFlexColumn(colItems, innerH)
        col.Put("width", ComputeColumnContentWidth(colItems))
        col.Put("height", ComputeColumnContentHeight(colItems))
        colWidths.Add(col.Get("width"))
    Next

    'Align-content packs columns on cross axis (horizontal for column)
    If NormalizeKeyword(AlignContent) = "stretch" Then
        StretchLineSizes(colWidths, innerW, GapX)
    End If

    Dim pack As Map = ComputePackedOffsets(colWidths, innerW, GapX, NormalizeKeyword(AlignContent))
    Dim xOffsets As List = pack.Get("offsets")

    If IsWrapReverse Then
        Dim mirrored As List
        mirrored.Initialize
        For i = 0 To xOffsets.Size - 1
            Dim colW As Int = colWidths.Get(i)
            Dim x0 As Int = xOffsets.Get(i)
            mirrored.Add(innerW - (x0 + colW))
        Next
        xOffsets = mirrored
    End If

    For ci = 0 To cols.Size - 1
        Dim col As Map = cols.Get(ci)
        Dim colItems As List = col.Get("items")
        Dim contentW As Int = col.Get("width")
        Dim contentH As Int = col.Get("height")
        Dim packedW As Int = colWidths.Get(ci) 'may exceed contentW when align-content:stretch

        Dim x As Int = innerX + xOffsets.Get(ci)

        Dim startY As Int = innerY
        Dim effectiveGapY As Int = GapY

        Select NormalizeKeyword(JustifyContent)
            Case "center"
                startY = innerY + MaxI(0, (innerH - contentH) / 2)
            Case "end"
                startY = innerY + MaxI(0, innerH - contentH)
            Case "space-between"
                If colItems.Size > 1 Then
                    Dim totalOuterH As Int = SumColumnOuterFinalHeights(colItems)
                    Dim available As Int = MaxI(0, innerH - totalOuterH)
                    effectiveGapY = available / (colItems.Size - 1)
                    startY = innerY
                Else
                    startY = innerY
                End If
            Case "space-around"
                If colItems.Size > 0 Then
                    Dim totalOuterH2 As Int = SumColumnOuterFinalHeights(colItems)
                    Dim free2 As Int = MaxI(0, innerH - totalOuterH2)
                    effectiveGapY = free2 / colItems.Size
                    startY = innerY + effectiveGapY / 2
                Else
                    startY = innerY
                End If
            Case "space-evenly"
                If colItems.Size > 0 Then
                    Dim totalOuterH3 As Int = SumColumnOuterFinalHeights(colItems)
                    Dim free3 As Int = MaxI(0, innerH - totalOuterH3)
                    effectiveGapY = free3 / (colItems.Size + 1)
                    startY = innerY + effectiveGapY
                Else
                    startY = innerY
                End If
            Case Else
                startY = innerY
        End Select

        Dim placeItems As List = colItems
        If IsReverseMain Then placeItems = ReversedList(colItems)

        Dim y As Int = startY

        For i = 0 To placeItems.Size - 1
            Dim item As Map = placeItems.Get(i)
            Dim v As B4XView = item.Get("view")
            Dim w As Int = item.Get("fw")
            Dim h As Int = item.Get("fh")
            Dim meta As Map = item.Get("meta")

            Dim ml As Int = GetMetaInt(meta, "ml", 0)
            Dim mt As Int = GetMetaInt(meta, "mt", 0)
            Dim mr As Int = GetMetaInt(meta, "mr", 0)
            Dim mb As Int = GetMetaInt(meta, "mb", 0)

            Dim outerW As Int = ml + w + mr
            Dim itemX As Int = x + ml
            Dim itemY As Int = y + mt
            Dim itemW As Int = w

            Dim alignMode As String = ResolveAlignMode(meta)

            Select alignMode
                Case "center"
                    itemX = x + MaxI(0, (packedW - outerW) / 2) + ml
                Case "end"
                    itemX = x + MaxI(0, packedW - outerW) + ml
                Case "stretch"
                    itemX = x + ml
                    itemW = MaxI(0, packedW - ml - mr)
                    itemW = ClampWidth(itemW, meta)
                Case Else
                    itemX = x + ml
            End Select

            v.SetLayoutAnimated(AnimateDuration, itemX, itemY, itemW, h)
            y = y + mt + h + mb + effectiveGapY
        Next
    Next
End Sub

Private Sub ApplyMainAxisFlexColumn(colItems As List, innerH As Int)
    If colItems.Size = 0 Then Return

    Dim gapTotal As Int = GapY * MaxI(0, colItems.Size - 1)
    Dim totalBaseOuterH As Int = 0

    For Each item As Map In colItems
        Dim meta As Map = item.Get("meta")
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)

        item.Put("fw", item.Get("w"))
        item.Put("fh", item.Get("h"))

        totalBaseOuterH = totalBaseOuterH + mt + item.Get("h") + mb
    Next

    Dim availableForItems As Int = MaxI(0, innerH - gapTotal)
    Dim delta As Int = availableForItems - totalBaseOuterH

    If delta > 0 Then
        ApplyGrowColumn(colItems, delta)
    Else If delta < 0 Then
        If IsWrapEnabled = False Or AllowShrinkWhenWrap Then
            ApplyShrinkColumn(colItems, -delta)
        End If
    End If
End Sub

Private Sub ApplyGrowColumn(colItems As List, extraPx As Int)
    Dim totalGrow As Float = 0
    For Each item As Map In colItems
        Dim meta As Map = item.Get("meta")
        totalGrow = totalGrow + MaxF(0, GetMetaFloat(meta, "grow", 0))
    Next
    If totalGrow <= 0 Then Return

    Dim allocated As Int = 0
    For i = 0 To colItems.Size - 1
        Dim item As Map = colItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim g As Float = MaxF(0, GetMetaFloat(meta, "grow", 0))
        If g <= 0 Then Continue

        Dim add As Int
        If i = colItems.Size - 1 Then
            add = extraPx - allocated
        Else
            add = Floor((extraPx * g) / totalGrow)
            allocated = allocated + add
        End If

        Dim newH As Int = ClampHeight(item.Get("fh") + add, meta)
        item.Put("fh", newH)
    Next

    NormalizeColumnToTarget(colItems, extraPx, True)
End Sub

Private Sub ApplyShrinkColumn(colItems As List, overflowPx As Int)
    Dim totalShrinkFactor As Float = 0
    For Each item As Map In colItems
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        totalShrinkFactor = totalShrinkFactor + (s * item.Get("h"))
    Next
    If totalShrinkFactor <= 0 Then Return

    Dim reduced As Int = 0
    For i = 0 To colItems.Size - 1
        Dim item As Map = colItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        If s = 0 Then Continue

        Dim basisH As Int = item.Get("h")
        Dim factor As Float = s * basisH

        Dim cut As Int
        If i = colItems.Size - 1 Then
            cut = overflowPx - reduced
        Else
            cut = Floor((overflowPx * factor) / totalShrinkFactor)
            reduced = reduced + cut
        End If

        Dim newH As Int = ClampHeight(item.Get("fh") - cut, meta)
        item.Put("fh", newH)
    Next

    NormalizeColumnToTarget(colItems, overflowPx, False)
End Sub

Private Sub NormalizeColumnToTarget(colItems As List, targetDelta As Int, isGrow As Boolean)
    Dim currentBaseOuter As Int = 0
    Dim currentFinalOuter As Int = 0

    For Each item As Map In colItems
        Dim meta As Map = item.Get("meta")
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)
        currentBaseOuter = currentBaseOuter + mt + item.Get("h") + mb
        currentFinalOuter = currentFinalOuter + mt + item.Get("fh") + mb
    Next

    Dim actualDelta As Int = currentFinalOuter - currentBaseOuter
    Dim remain As Int

    If isGrow Then
        remain = targetDelta - actualDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed As Boolean = False
            For Each item As Map In colItems
                If remain <= 0 Then Exit
                Dim meta As Map = item.Get("meta")
                Dim maxh As Int = GetMetaInt(meta, "maxh", -1)
                Dim fh As Int = item.Get("fh")
                If maxh <> -1 And fh >= maxh Then Continue
                item.Put("fh", fh + 1)
                remain = remain - 1
                changed = True
            Next
            If changed = False Then Exit
        Loop
    Else
        remain = actualDelta + targetDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed2 As Boolean = False
            For Each item As Map In colItems
                If remain <= 0 Then Exit
                Dim meta2 As Map = item.Get("meta")
                Dim minh As Int = GetMetaInt(meta2, "minh", -1)
                Dim fh2 As Int = item.Get("fh")
                If minh <> -1 And fh2 <= minh Then Continue
                If fh2 <= 0 Then Continue
                item.Put("fh", fh2 - 1)
                remain = remain - 1
                changed2 = True
            Next
            If changed2 = False Then Exit
        Loop
    End If
End Sub

'========================
' HELPERS
'========================

Private Sub NormalizeLegacySettings
    'If user still uses Wrap Boolean, convert to WrapMode unless WrapMode explicitly set to wrap-reverse.
    Dim wm As String = NormalizeKeyword(WrapMode)
    If Wrap = False Then
        If wm <> "wrap-reverse" Then WrapMode = "nowrap"
    Else
        If wm = "" Or wm = "nowrap" Then WrapMode = "wrap"
    End If

    Direction = NormalizeKeyword(Direction)
    WrapMode = NormalizeKeyword(WrapMode)
    JustifyContent = NormalizeKeyword(JustifyContent)
    AlignItems = NormalizeKeyword(AlignItems)
    AlignContent = NormalizeKeyword(AlignContent)
End Sub

Private Sub NormalizeKeyword(s As String) As String
    s = s.ToLowerCase.Trim
    If s = "flex-start" Then Return "start"
    If s = "flex-end" Then Return "end"
    Return s
End Sub

Private Sub IsRowDirection As Boolean
    Dim d As String = NormalizeKeyword(Direction)
    Return d.StartsWith("row")
End Sub

Private Sub IsReverseMain As Boolean
    Dim d As String = NormalizeKeyword(Direction)
    Return d.EndsWith("-reverse")
End Sub

Private Sub IsWrapEnabled As Boolean
    Dim w As String = NormalizeKeyword(WrapMode)
    Return w = "wrap" Or w = "wrap-reverse"
End Sub

Private Sub IsWrapReverse As Boolean
    Return NormalizeKeyword(WrapMode) = "wrap-reverse"
End Sub

Private Sub GetOrderedVisibleChildren(p As B4XView) As List
    Dim buckets As List
    buckets.Initialize

    For i = 0 To p.NumberOfViews - 1
        Dim v As B4XView = p.GetView(i)
        If v.Visible = False Then Continue

        Dim meta As Map = GetMeta(v)
        Dim m As Map
        m.Initialize
        m.Put("view", v)
        m.Put("idx", i)
        m.Put("order", GetMetaInt(meta, "order", 0))
        buckets.Add(m)
    Next

    'stable sort by (order, original index)
    For i = 0 To buckets.Size - 2
        For j = i + 1 To buckets.Size - 1
            Dim a As Map = buckets.Get(i)
            Dim b As Map = buckets.Get(j)
            Dim ao As Int = a.Get("order")
            Dim bo As Int = b.Get("order")
            Dim ai As Int = a.Get("idx")
            Dim bi As Int = b.Get("idx")

            If bo < ao Or (bo = ao And bi < ai) Then
                buckets.Set(i, b)
                buckets.Set(j, a)
            End If
        Next
    Next

    Dim res As List
    res.Initialize
    For Each e As Map In buckets
        res.Add(e.Get("view"))
    Next
    Return res
End Sub

Private Sub ReversedList(src As List) As List
    Dim r As List
    r.Initialize
    For i = src.Size - 1 To 0 Step -1
        r.Add(src.Get(i))
    Next
    Return r
End Sub

Private Sub GetMeta(v As B4XView) As Map
    If mItemMeta.ContainsKey(v) Then Return mItemMeta.Get(v)
    Dim m As Map
    m.Initialize
    Return m
End Sub

Private Sub GetOrCreateMeta(v As B4XView) As Map
    If mItemMeta.ContainsKey(v) Then Return mItemMeta.Get(v)

    Dim m As Map
    m.Initialize

    m.Put("grow", 0)
    m.Put("shrink", 1)

    m.Put("basisw", -1)
    m.Put("basish", -1)
    m.Put("basis_main_pct", -1)
    m.Put("basis_cross_pct", -1)

    m.Put("minw", -1)
    m.Put("maxw", -1)
    m.Put("minh", -1)
    m.Put("maxh", -1)

    m.Put("ml", 0)
    m.Put("mt", 0)
    m.Put("mr", 0)
    m.Put("mb", 0)

    m.Put("alignself", "auto")
    m.Put("order", 0)
    m.Put("wrapbefore", False)

    mItemMeta.Put(v, m)
    Return m
End Sub

Private Sub ResolveAlignMode(meta As Map) As String
    Dim s As String = NormalizeKeyword(GetMetaString(meta, "alignself", "auto"))
    If s = "" Or s = "auto" Then Return NormalizeKeyword(AlignItems)
    Return s
End Sub

Private Sub ResolveBasisW(v As B4XView, meta As Map) As Int
    Dim innerW As Int = MaxI(0, mContainer.Width - PaddingLeft - PaddingRight)
    Dim mainPct As Float = GetMetaFloat(meta, "basis_main_pct", -1)
    Dim crossPct As Float = GetMetaFloat(meta, "basis_cross_pct", -1)

    If IsRowDirection Then
        'main axis = width
        If mainPct >= 0 Then Return Floor(innerW * mainPct / 100)
        'crossPct is height in row mode -> ignore for width
    Else
        'cross axis = width
        If crossPct >= 0 Then Return Floor(innerW * crossPct / 100)
    End If

    Dim bw As Int = GetMetaInt(meta, "basisw", -1)
    If bw <> -1 Then Return bw
    Return MaxI(0, v.Width)
End Sub

Private Sub ResolveBasisH(v As B4XView, meta As Map) As Int
    Dim innerH As Int = MaxI(0, mContainer.Height - PaddingTop - PaddingBottom)
    Dim mainPct As Float = GetMetaFloat(meta, "basis_main_pct", -1)
    Dim crossPct As Float = GetMetaFloat(meta, "basis_cross_pct", -1)

    If IsRowDirection Then
        'cross axis = height
        If crossPct >= 0 Then Return Floor(innerH * crossPct / 100)
    Else
        'main axis = height
        If mainPct >= 0 Then Return Floor(innerH * mainPct / 100)
    End If

    Dim bh As Int = GetMetaInt(meta, "basish", -1)
    If bh <> -1 Then Return bh
    Return MaxI(0, v.Height)
End Sub

Private Sub ClampWidth(w As Int, meta As Map) As Int
    Dim minw As Int = GetMetaInt(meta, "minw", -1)
    Dim maxw As Int = GetMetaInt(meta, "maxw", -1)
    Dim r As Int = w
    If minw <> -1 And r < minw Then r = minw
    If maxw <> -1 And r > maxw Then r = maxw
    If r < 0 Then r = 0
    Return r
End Sub

Private Sub ClampHeight(h As Int, meta As Map) As Int
    Dim minh As Int = GetMetaInt(meta, "minh", -1)
    Dim maxh As Int = GetMetaInt(meta, "maxh", -1)
    Dim r As Int = h
    If minh <> -1 And r < minh Then r = minh
    If maxh <> -1 And r > maxh Then r = maxh
    If r < 0 Then r = 0
    Return r
End Sub

Private Sub CreateItemInfo(v As B4XView, w As Int, h As Int, meta As Map) As Map
    Dim m As Map
    m.Initialize
    m.Put("view", v)
    m.Put("w", w)   'base width
    m.Put("h", h)   'base height
    m.Put("fw", w)  'final width
    m.Put("fh", h)  'final height
    m.Put("meta", meta)
    Return m
End Sub

Private Sub CreateLineInfo(items As List, width As Int, height As Int) As Map
    Dim m As Map
    m.Initialize
    m.Put("items", items)
    m.Put("width", width)
    m.Put("height", height)
    Return m
End Sub

'Pack line offsets on cross axis with base gap + align-content mode.
'Returns: map("offsets"=List of Int, "gap"=Int)
Private Sub ComputePackedOffsets(LineSizes As List, Available As Int, BaseGap As Int, Mode As String) As Map
    Dim m As Map
    m.Initialize

    Dim n As Int = LineSizes.Size
    Dim offsets As List
    offsets.Initialize

    If n = 0 Then
        m.Put("offsets", offsets)
        m.Put("gap", BaseGap)
        Return m
    End If

    Dim total As Int = 0
    For Each s As Int In LineSizes
        total = total + s
    Next

    Dim totalWithBaseGaps As Int = total + BaseGap * MaxI(0, n - 1)
    Dim free As Int = MaxI(0, Available - totalWithBaseGaps)

    Dim startPos As Int = 0
    Dim gap As Int = BaseGap

    Select NormalizeKeyword(Mode)
        Case "center"
            startPos = free / 2
        Case "end"
            startPos = free
        Case "space-between"
            If n > 1 Then gap = BaseGap + (free / (n - 1))
        Case "space-around"
            If n > 0 Then
                Dim slot As Int = free / n
                startPos = slot / 2
                gap = BaseGap + slot
            End If
        Case "space-evenly"
            Dim slot2 As Int = free / (n + 1)
            startPos = slot2
            gap = BaseGap + slot2
        Case Else
            'start / stretch -> startPos=0, gap=BaseGap
    End Select

    Dim p As Int = startPos
    For i = 0 To n - 1
        offsets.Add(p)
        p = p + LineSizes.Get(i) + gap
    Next

    m.Put("offsets", offsets)
    m.Put("gap", gap)
    Return m
End Sub

Private Sub StretchLineSizes(LineSizes As List, Available As Int, BaseGap As Int)
    Dim n As Int = LineSizes.Size
    If n = 0 Then Return

    Dim total As Int = 0
    For Each s As Int In LineSizes
        total = total + s
    Next

    Dim used As Int = total + BaseGap * MaxI(0, n - 1)
    Dim free As Int = Available - used
    If free <= 0 Then Return

    Dim addEach As Int = free / n
    Dim remPx As Int = free Mod n

    For i = 0 To n - 1
        Dim s As Int = LineSizes.Get(i)
        s = s + addEach + IIfI(i < remPx, 1, 0)
        LineSizes.Set(i, s)
    Next
End Sub

Private Sub ComputeRowContentWidth(items As List) As Int
    If items.Size = 0 Then Return 0
    Return SumRowOuterFinalWidths(items) + (items.Size - 1) * GapX
End Sub

Private Sub ComputeRowContentHeight(items As List) As Int
    Dim mx As Int = 0
    For Each item As Map In items
        Dim meta As Map = item.Get("meta")
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)
        Dim totalH As Int = mt + item.Get("fh") + mb
        If totalH > mx Then mx = totalH
    Next
    Return mx
End Sub

Private Sub ComputeColumnContentWidth(items As List) As Int
    Dim mx As Int = 0
    For Each item As Map In items
        Dim meta As Map = item.Get("meta")
        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)
        Dim totalW As Int = ml + item.Get("fw") + mr
        If totalW > mx Then mx = totalW
    Next
    Return mx
End Sub

Private Sub ComputeColumnContentHeight(items As List) As Int
    If items.Size = 0 Then Return 0
    Return SumColumnOuterFinalHeights(items) + (items.Size - 1) * GapY
End Sub

Private Sub SumRowOuterFinalWidths(items As List) As Int
    Dim total As Int = 0
    For Each item As Map In items
        Dim meta As Map = item.Get("meta")
        total = total + GetMetaInt(meta, "ml", 0) + item.Get("fw") + GetMetaInt(meta, "mr", 0)
    Next
    Return total
End Sub

Private Sub SumColumnOuterFinalHeights(items As List) As Int
    Dim total As Int = 0
    For Each item As Map In items
        Dim meta As Map = item.Get("meta")
        total = total + GetMetaInt(meta, "mt", 0) + item.Get("fh") + GetMetaInt(meta, "mb", 0)
    Next
    Return total
End Sub

Private Sub GetMetaInt(meta As Map, Key As String, DefaultValue As Int) As Int
    If meta.IsInitialized = False Then Return DefaultValue
    If meta.ContainsKey(Key) = False Then Return DefaultValue
    Return meta.Get(Key)
End Sub

Private Sub GetMetaFloat(meta As Map, Key As String, DefaultValue As Float) As Float
    If meta.IsInitialized = False Then Return DefaultValue
    If meta.ContainsKey(Key) = False Then Return DefaultValue
    Return meta.Get(Key)
End Sub

Private Sub GetMetaString(meta As Map, Key As String, DefaultValue As String) As String
    If meta.IsInitialized = False Then Return DefaultValue
    If meta.ContainsKey(Key) = False Then Return DefaultValue
    Return meta.Get(Key)
End Sub

Private Sub GetMetaBool(meta As Map, Key As String, DefaultValue As Boolean) As Boolean
    If meta.IsInitialized = False Then Return DefaultValue
    If meta.ContainsKey(Key) = False Then Return DefaultValue
    Return meta.Get(Key)
End Sub

Private Sub MaxI(a As Int, b As Int) As Int
    If a > b Then Return a Else Return b
End Sub

Private Sub MaxF(a As Float, b As Float) As Float
    If a > b Then Return a Else Return b
End Sub

Private Sub IIfI(Condition As Boolean, TrueValue As Int, FalseValue As Int) As Int
    If Condition Then Return TrueValue Else Return FalseValue
End Sub