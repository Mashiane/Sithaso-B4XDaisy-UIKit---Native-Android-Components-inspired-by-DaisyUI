B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XDaisyFlexLayout.bas
'Flex-like layout helper for B4X/XUI (native)
'v3: row/column reverse, wrap modes, align-content, space-around/evenly, % basis,
'    grow/shrink, margins, align-self, order, wrapBefore

#IgnoreWarnings:12,9
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
    
    Private mContentWidth As Int = 0
    Private mContentHeight As Int = 0
End Sub

Public Sub Initialize(vContainer As B4XView)
    mContainer = vContainer
    mItemMeta.Initialize
End Sub

Public Sub SetContainer(vContainer As B4XView)
    mContainer = vContainer
End Sub

Public Sub SetPadding(iAll As Int)
    PaddingLeft = iAll : PaddingTop = iAll : PaddingRight = iAll : PaddingBottom = iAll
End Sub

Public Sub SetPaddingLTRB(iLeft As Int, iTop As Int, iRight As Int, iBottom As Int)
    PaddingLeft = iLeft : PaddingTop = iTop : PaddingRight = iRight : PaddingBottom = iBottom
End Sub

Public Sub SetGap(iX As Int, iY As Int)
    GapX = iX : GapY = iY
End Sub

'-
' ITEM META API
'-

'Grow/Shrink + min/max constraints
Public Sub SetItemFlexEx(vView As B4XView, fGrow As Float, fShrink As Float, iMinW As Int, iMaxW As Int, iMinH As Int, iMaxH As Int)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("grow", fGrow)
    meta.Put("shrink", fShrink)
    meta.Put("minw", iMinW)
    meta.Put("maxw", iMaxW)
    meta.Put("minh", iMinH)
    meta.Put("maxh", iMaxH)
End Sub

'Optional absolute basis override. Use -1 for "not set"
Public Sub SetItemBasis(vView As B4XView, iBasisW As Int, iBasisH As Int)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("basisw", iBasisW)
    meta.Put("basish", iBasisH)
End Sub

'Percent basis relative to container inner size.
'PercentMain applies to main axis size, PercentCross applies to cross axis size.
'Use -1 for "not set"
Public Sub SetItemBasisPercent(vView As B4XView, fPercentMain As Float, fPercentCross As Float)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("basis_main_pct", fPercentMain)
    meta.Put("basis_cross_pct", fPercentCross)
End Sub

Public Sub ClearItemBasisPercent(vView As B4XView)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("basis_main_pct", -1)
    meta.Put("basis_cross_pct", -1)
End Sub

'Per-item margins
Public Sub SetItemMargins(vView As B4XView, iLeft As Int, iTop As Int, iRight As Int, iBottom As Int)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("ml", iLeft)
    meta.Put("mt", iTop)
    meta.Put("mr", iRight)
    meta.Put("mb", iBottom)
End Sub

'align-self: "auto","start","center","end","stretch" (+ flex-start/flex-end aliases)
Public Sub SetItemAlignSelf(vView As B4XView, sAlignSelf As String)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("alignself", NormalizeKeyword(sAlignSelf))
End Sub

'Lower order renders first (default 0)
Public Sub SetItemOrder(vView As B4XView, iOrderValue As Int)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("order", iOrderValue)
End Sub

'If True, starts a new line/column before this item (when wrapping enabled)
Public Sub SetItemWrapBefore(vView As B4XView, bValue As Boolean)
    Dim meta As Map = GetOrCreateMeta(vView)
    meta.Put("wrapbefore", bValue)
End Sub

Public Sub ClearItemMeta(vView As B4XView)
    If mItemMeta.IsInitialized = False Then Return
    If mItemMeta.ContainsKey(vView) Then mItemMeta.Remove(vView)
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

''' <summary>
''' Gets the calculated content width after Relayout.
''' </summary>
Public Sub GetContentWidth As Int
    Return mContentWidth
End Sub

''' <summary>
''' Gets the calculated content height after Relayout.
''' </summary>
Public Sub GetContentHeight As Int
    Return mContentHeight
End Sub

'-
' ROW LAYOUT
'-
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
                Case "baseline"
                    itemY = y + mt  ' baseline approximated as start
                Case Else 'start
                    itemY = y + mt
            End Select

            v.SetLayoutAnimated(AnimateDuration, itemX, itemY, w, itemH)
            x = x + ml + w + mr + effectiveGapX
        Next
    Next
    
    ' Store content size
    mContentWidth = ComputeContentWidthFromLines(lines, innerW)
    mContentHeight = ComputeContentHeightFromLines(lines, innerH, lineHeights)
End Sub

Private Sub ComputeContentWidthFromLines(lstLines As List, iInnerW As Int) As Int
    Dim maxW As Int = 0
    For Each line As Map In lstLines
        Dim w As Int = line.Get("width")
        If w > maxW Then maxW = w
    Next
    Return PaddingLeft + maxW + PaddingRight
End Sub

Private Sub ComputeContentHeightFromLines(lstLines As List, iInnerH As Int, lstLineHeights As List) As Int
    Dim totalH As Int = 0
    For Each h As Int In lstLineHeights
        totalH = totalH + h
    Next
    If lstLineHeights.Size > 1 Then
        totalH = totalH + (lstLineHeights.Size - 1) * GapY
    End If
    Return PaddingTop + totalH + PaddingBottom
End Sub

Private Sub ApplyMainAxisFlexRow(lstLineItems As List, iInnerW As Int)
    If lstLineItems.Size = 0 Then Return

    Dim gapTotal As Int = GapX * MaxI(0, lstLineItems.Size - 1)
    Dim totalBaseOuterW As Int = 0

    For Each item As Map In lstLineItems
        Dim meta As Map = item.Get("meta")
        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)

        item.Put("fw", item.Get("w"))
        item.Put("fh", item.Get("h"))

        totalBaseOuterW = totalBaseOuterW + ml + item.Get("w") + mr
    Next

    Dim availableForItems As Int = MaxI(0, iInnerW - gapTotal)
    Dim delta As Int = availableForItems - totalBaseOuterW

    If delta > 0 Then
        ApplyGrowRow(lstLineItems, delta)
    Else If delta < 0 Then
        If IsWrapEnabled = False Or AllowShrinkWhenWrap Then
            ApplyShrinkRow(lstLineItems, -delta)
        End If
    End If
End Sub

Private Sub ApplyGrowRow(lstLineItems As List, iExtraPx As Int)
    Dim totalGrow As Float = 0
    For Each item As Map In lstLineItems
        Dim meta As Map = item.Get("meta")
        totalGrow = totalGrow + MaxF(0, GetMetaFloat(meta, "grow", 0))
    Next
    If totalGrow <= 0 Then Return

    Dim allocated As Int = 0
    For i = 0 To lstLineItems.Size - 1
        Dim item As Map = lstLineItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim g As Float = MaxF(0, GetMetaFloat(meta, "grow", 0))
        If g <= 0 Then Continue

        Dim add As Int
        If i = lstLineItems.Size - 1 Then
            add = iExtraPx - allocated
        Else
            add = Floor((iExtraPx * g) / totalGrow)
            allocated = allocated + add
        End If

        Dim newW As Int = ClampWidth(item.Get("fw") + add, meta)
        item.Put("fw", newW)
    Next

    NormalizeRowToTarget(lstLineItems, iExtraPx, True)
End Sub

Private Sub ApplyShrinkRow(lstLineItems As List, iOverflowPx As Int)
    Dim totalShrinkFactor As Float = 0
    For Each item As Map In lstLineItems
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        totalShrinkFactor = totalShrinkFactor + (s * item.Get("w"))
    Next
    If totalShrinkFactor <= 0 Then Return

    Dim reduced As Int = 0
    For i = 0 To lstLineItems.Size - 1
        Dim item As Map = lstLineItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        If s = 0 Then Continue

        Dim basisW As Int = item.Get("w")
        Dim factor As Float = s * basisW

        Dim cut As Int
        If i = lstLineItems.Size - 1 Then
            cut = iOverflowPx - reduced
        Else
            cut = Floor((iOverflowPx * factor) / totalShrinkFactor)
            reduced = reduced + cut
        End If

        Dim newW As Int = ClampWidth(item.Get("fw") - cut, meta)
        item.Put("fw", newW)
    Next

    NormalizeRowToTarget(lstLineItems, iOverflowPx, False)
End Sub

Private Sub NormalizeRowToTarget(lstLineItems As List, iTargetDelta As Int, bisGrow As Boolean)
    Dim currentBaseOuter As Int = 0
    Dim currentFinalOuter As Int = 0

    For Each item As Map In lstLineItems
        Dim meta As Map = item.Get("meta")
        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)
        currentBaseOuter = currentBaseOuter + ml + item.Get("w") + mr
        currentFinalOuter = currentFinalOuter + ml + item.Get("fw") + mr
    Next

    Dim actualDelta As Int = currentFinalOuter - currentBaseOuter
    Dim remain As Int

    If bisGrow Then
        remain = iTargetDelta - actualDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed As Boolean = False
            For Each item As Map In lstLineItems
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
        remain = actualDelta + iTargetDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed2 As Boolean = False
            For Each item As Map In lstLineItems
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

'-
' COLUMN LAYOUT
'-
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
                Case "baseline"
                    itemX = x + ml  ' baseline approximated as start
                Case Else
                    itemX = x + ml
            End Select

            v.SetLayoutAnimated(AnimateDuration, itemX, itemY, itemW, h)
            y = y + mt + h + mb + effectiveGapY
        Next
    Next
    
    ' Store content size
    mContentHeight = ComputeContentHeightFromCols(cols, innerH)
    mContentWidth = ComputeContentWidthFromCols(cols, innerW, colWidths)
End Sub

Private Sub ComputeContentHeightFromCols(lstCols As List, iInnerH As Int) As Int
    Dim maxH As Int = 0
    For Each col As Map In lstCols
        Dim h As Int = col.Get("height")
        If h > maxH Then maxH = h
    Next
    Return PaddingTop + maxH + PaddingBottom
End Sub

Private Sub ComputeContentWidthFromCols(lstCols As List, iInnerW As Int, lstColWidths As List) As Int
    Dim totalW As Int = 0
    For Each w As Int In lstColWidths
        totalW = totalW + w
    Next
    If lstColWidths.Size > 1 Then
        totalW = totalW + (lstColWidths.Size - 1) * GapX
    End If
    Return PaddingLeft + totalW + PaddingRight
End Sub

Private Sub ApplyMainAxisFlexColumn(lstColItems As List, iInnerH As Int)
    If lstColItems.Size = 0 Then Return

    Dim gapTotal As Int = GapY * MaxI(0, lstColItems.Size - 1)
    Dim totalBaseOuterH As Int = 0

    For Each item As Map In lstColItems
        Dim meta As Map = item.Get("meta")
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)

        item.Put("fw", item.Get("w"))
        item.Put("fh", item.Get("h"))

        totalBaseOuterH = totalBaseOuterH + mt + item.Get("h") + mb
    Next

    Dim availableForItems As Int = MaxI(0, iInnerH - gapTotal)
    Dim delta As Int = availableForItems - totalBaseOuterH

    If delta > 0 Then
        ApplyGrowColumn(lstColItems, delta)
    Else If delta < 0 Then
        If IsWrapEnabled = False Or AllowShrinkWhenWrap Then
            ApplyShrinkColumn(lstColItems, -delta)
        End If
    End If
End Sub

Private Sub ApplyGrowColumn(lstColItems As List, iExtraPx As Int)
    Dim totalGrow As Float = 0
    For Each item As Map In lstColItems
        Dim meta As Map = item.Get("meta")
        totalGrow = totalGrow + MaxF(0, GetMetaFloat(meta, "grow", 0))
    Next
    If totalGrow <= 0 Then Return

    Dim allocated As Int = 0
    For i = 0 To lstColItems.Size - 1
        Dim item As Map = lstColItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim g As Float = MaxF(0, GetMetaFloat(meta, "grow", 0))
        If g <= 0 Then Continue

        Dim add As Int
        If i = lstColItems.Size - 1 Then
            add = iExtraPx - allocated
        Else
            add = Floor((iExtraPx * g) / totalGrow)
            allocated = allocated + add
        End If

        Dim newH As Int = ClampHeight(item.Get("fh") + add, meta)
        item.Put("fh", newH)
    Next

    NormalizeColumnToTarget(lstColItems, iExtraPx, True)
End Sub

Private Sub ApplyShrinkColumn(lstColItems As List, iOverflowPx As Int)
    Dim totalShrinkFactor As Float = 0
    For Each item As Map In lstColItems
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        totalShrinkFactor = totalShrinkFactor + (s * item.Get("h"))
    Next
    If totalShrinkFactor <= 0 Then Return

    Dim reduced As Int = 0
    For i = 0 To lstColItems.Size - 1
        Dim item As Map = lstColItems.Get(i)
        Dim meta As Map = item.Get("meta")
        Dim s As Float = MaxF(0, GetMetaFloat(meta, "shrink", 1))
        If s = 0 Then Continue

        Dim basisH As Int = item.Get("h")
        Dim factor As Float = s * basisH

        Dim cut As Int
        If i = lstColItems.Size - 1 Then
            cut = iOverflowPx - reduced
        Else
            cut = Floor((iOverflowPx * factor) / totalShrinkFactor)
            reduced = reduced + cut
        End If

        Dim newH As Int = ClampHeight(item.Get("fh") - cut, meta)
        item.Put("fh", newH)
    Next

    NormalizeColumnToTarget(lstColItems, iOverflowPx, False)
End Sub

Private Sub NormalizeColumnToTarget(lstColItems As List, iTargetDelta As Int, bisGrow As Boolean)
    Dim currentBaseOuter As Int = 0
    Dim currentFinalOuter As Int = 0

    For Each item As Map In lstColItems
        Dim meta As Map = item.Get("meta")
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)
        currentBaseOuter = currentBaseOuter + mt + item.Get("h") + mb
        currentFinalOuter = currentFinalOuter + mt + item.Get("fh") + mb
    Next

    Dim actualDelta As Int = currentFinalOuter - currentBaseOuter
    Dim remain As Int

    If bisGrow Then
        remain = iTargetDelta - actualDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed As Boolean = False
            For Each item As Map In lstColItems
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
        remain = actualDelta + iTargetDelta
        If remain <= 0 Then Return
        Do While remain > 0
            Dim changed2 As Boolean = False
            For Each item As Map In lstColItems
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

'-
' HELPERS
'-

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

Private Sub NormalizeKeyword(sValue As String) As String
    sValue = sValue.ToLowerCase.Trim
    If sValue = "flex-start" Then Return "start"
    If sValue = "flex-end" Then Return "end"
    Return sValue
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

Private Sub GetOrderedVisibleChildren(vP As B4XView) As List
    Dim buckets As List
    buckets.Initialize

    For i = 0 To vP.NumberOfViews - 1
        Dim v As B4XView = vP.GetView(i)
        If v.Visible = False Then Continue

        Dim meta As Map = GetMeta(v)
        Dim m As Map
        m.Initialize
        m.Put("view", v)
        m.Put("idx", i)
        m.Put("order", GetMetaInt(meta, "order", 0))
        buckets.Add(m)
    Next

    ' Stable insertion sort by (order, original index)
    For i = 1 To buckets.Size - 1
        Dim cur As Map = buckets.Get(i)
        Dim co As Int = cur.Get("order")
        Dim ci As Int = cur.Get("idx")
        Dim j As Int = i - 1
        Do While j >= 0
            Dim a As Map = buckets.Get(j)
            Dim ao As Int = a.Get("order")
            Dim ai As Int = a.Get("idx")
            If ao < co Or (ao = co And ai <= ci) Then Exit
            buckets.Set(j + 1, a)
            j = j - 1
        Loop
        buckets.Set(j + 1, cur)
    Next

    Dim res As List
    res.Initialize
    For Each e As Map In buckets
        res.Add(e.Get("view"))
    Next
    Return res
End Sub

Private Sub ReversedList(lstSrc As List) As List
    Dim r As List
    r.Initialize
    For i = lstSrc.Size - 1 To 0 Step -1
        r.Add(lstSrc.Get(i))
    Next
    Return r
End Sub

Private Sub GetMeta(vView As B4XView) As Map
    If mItemMeta.ContainsKey(vView) Then Return mItemMeta.Get(vView)
    Dim m As Map
    m.Initialize
    Return m
End Sub

Private Sub GetOrCreateMeta(vView As B4XView) As Map
    If mItemMeta.ContainsKey(vView) Then Return mItemMeta.Get(vView)

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

    mItemMeta.Put(vView, m)
    Return m
End Sub

Private Sub ResolveAlignMode(mMeta As Map) As String
    Dim s As String = NormalizeKeyword(GetMetaString(mMeta, "alignself", "auto"))
    If s = "" Or s = "auto" Then Return NormalizeKeyword(AlignItems)
    Return s
End Sub

Private Sub ResolveBasisW(vView As B4XView, mMeta As Map) As Int
    Dim innerW As Int = MaxI(0, mContainer.Width - PaddingLeft - PaddingRight)
    Dim mainPct As Float = GetMetaFloat(mMeta, "basis_main_pct", -1)
    Dim crossPct As Float = GetMetaFloat(mMeta, "basis_cross_pct", -1)

    If IsRowDirection Then
        'main axis = width
        If mainPct >= 0 Then Return Floor(innerW * mainPct / 100)
        'crossPct is height in row mode -> ignore for width
    Else
        'cross axis = width
        If crossPct >= 0 Then Return Floor(innerW * crossPct / 100)
    End If

    Dim bw As Int = GetMetaInt(mMeta, "basisw", -1)
    If bw <> -1 Then Return bw
    Return MaxI(0, vView.Width)
End Sub

Private Sub ResolveBasisH(vView As B4XView, mMeta As Map) As Int
    Dim innerH As Int = MaxI(0, mContainer.Height - PaddingTop - PaddingBottom)
    Dim mainPct As Float = GetMetaFloat(mMeta, "basis_main_pct", -1)
    Dim crossPct As Float = GetMetaFloat(mMeta, "basis_cross_pct", -1)

    If IsRowDirection Then
        'cross axis = height
        If crossPct >= 0 Then Return Floor(innerH * crossPct / 100)
    Else
        'main axis = height
        If mainPct >= 0 Then Return Floor(innerH * mainPct / 100)
    End If

    Dim bh As Int = GetMetaInt(mMeta, "basish", -1)
    If bh <> -1 Then Return bh
    Return MaxI(0, vView.Height)
End Sub

Private Sub ClampWidth(iW As Int, mMeta As Map) As Int
    Dim minw As Int = GetMetaInt(mMeta, "minw", -1)
    Dim maxw As Int = GetMetaInt(mMeta, "maxw", -1)
    Dim r As Int = iW
    If minw <> -1 And r < minw Then r = minw
    If maxw <> -1 And r > maxw Then r = maxw
    If r < 0 Then r = 0
    Return r
End Sub

Private Sub ClampHeight(iH As Int, mMeta As Map) As Int
    Dim minh As Int = GetMetaInt(mMeta, "minh", -1)
    Dim maxh As Int = GetMetaInt(mMeta, "maxh", -1)
    Dim r As Int = iH
    If minh <> -1 And r < minh Then r = minh
    If maxh <> -1 And r > maxh Then r = maxh
    If r < 0 Then r = 0
    Return r
End Sub

Private Sub CreateItemInfo(vView As B4XView, iW As Int, iH As Int, mMeta As Map) As Map
    Dim m As Map
    m.Initialize
    m.Put("view", vView)
    m.Put("w", iW)   'base width
    m.Put("h", iH)   'base height
    m.Put("fw", iW)  'final width
    m.Put("fh", iH)  'final height
    m.Put("meta", mMeta)
    Return m
End Sub

Private Sub CreateLineInfo(lstItems As List, iWidth As Int, iHeight As Int) As Map
    Dim m As Map
    m.Initialize
    m.Put("items", lstItems)
    m.Put("width", iWidth)
    m.Put("height", iHeight)
    Return m
End Sub

'Pack line offsets on cross axis with base gap + align-content mode.
'Returns: map("offsets"=List of Int, "gap"=Int)
Private Sub ComputePackedOffsets(lstLineSizes As List, iAvailable As Int, iBaseGap As Int, sMode As String) As Map
    Dim m As Map
    m.Initialize

    Dim n As Int = lstLineSizes.Size
    Dim offsets As List
    offsets.Initialize

    If n = 0 Then
        m.Put("offsets", offsets)
        m.Put("gap", iBaseGap)
        Return m
    End If

    Dim total As Int = 0
    For Each s As Int In lstLineSizes
        total = total + s
    Next

    Dim totalWithBaseGaps As Int = total + iBaseGap * MaxI(0, n - 1)
    Dim free As Int = MaxI(0, iAvailable - totalWithBaseGaps)

    Dim startPos As Int = 0
    Dim gap As Int = iBaseGap

    Select NormalizeKeyword(sMode)
        Case "center"
            startPos = free / 2
        Case "end"
            startPos = free
        Case "space-between"
            If n > 1 Then gap = iBaseGap + (free / (n - 1))
        Case "space-around"
            If n > 0 Then
                Dim slot As Int = free / n
                startPos = slot / 2
                gap = iBaseGap + slot
            End If
        Case "space-evenly"
            Dim slot2 As Int = free / (n + 1)
            startPos = slot2
            gap = iBaseGap + slot2
        Case Else
            'start / stretch -> startPos=0, gap=BaseGap
    End Select

    Dim p As Int = startPos
    For i = 0 To n - 1
        offsets.Add(p)
        p = p + lstLineSizes.Get(i) + gap
    Next

    m.Put("offsets", offsets)
    m.Put("gap", gap)
    Return m
End Sub

Private Sub StretchLineSizes(lstLineSizes As List, iAvailable As Int, iBaseGap As Int)
    Dim n As Int = lstLineSizes.Size
    If n = 0 Then Return

    Dim total As Int = 0
    For Each s As Int In lstLineSizes
        total = total + s
    Next

    Dim used As Int = total + iBaseGap * MaxI(0, n - 1)
    Dim free As Int = iAvailable - used
    If free <= 0 Then Return

    Dim addEach As Int = free / n
    Dim remPx As Int = free Mod n

    For i = 0 To n - 1
        Dim s As Int = lstLineSizes.Get(i)
        s = s + addEach + IIfI(i < remPx, 1, 0)
        lstLineSizes.Set(i, s)
    Next
End Sub

Private Sub ComputeRowContentWidth(lstItems As List) As Int
    If lstItems.Size = 0 Then Return 0
    Return SumRowOuterFinalWidths(lstItems) + (lstItems.Size - 1) * GapX
End Sub

Private Sub ComputeRowContentHeight(lstItems As List) As Int
    Dim mx As Int = 0
    For Each item As Map In lstItems
        Dim meta As Map = item.Get("meta")
        Dim mt As Int = GetMetaInt(meta, "mt", 0)
        Dim mb As Int = GetMetaInt(meta, "mb", 0)
        Dim totalH As Int = mt + item.Get("fh") + mb
        If totalH > mx Then mx = totalH
    Next
    Return mx
End Sub

Private Sub ComputeColumnContentWidth(lstItems As List) As Int
    Dim mx As Int = 0
    For Each item As Map In lstItems
        Dim meta As Map = item.Get("meta")
        Dim ml As Int = GetMetaInt(meta, "ml", 0)
        Dim mr As Int = GetMetaInt(meta, "mr", 0)
        Dim totalW As Int = ml + item.Get("fw") + mr
        If totalW > mx Then mx = totalW
    Next
    Return mx
End Sub

Private Sub ComputeColumnContentHeight(lstItems As List) As Int
    If lstItems.Size = 0 Then Return 0
    Return SumColumnOuterFinalHeights(lstItems) + (lstItems.Size - 1) * GapY
End Sub

Private Sub SumRowOuterFinalWidths(lstItems As List) As Int
    Dim total As Int = 0
    For Each item As Map In lstItems
        Dim meta As Map = item.Get("meta")
        total = total + GetMetaInt(meta, "ml", 0) + item.Get("fw") + GetMetaInt(meta, "mr", 0)
    Next
    Return total
End Sub

Private Sub SumColumnOuterFinalHeights(lstItems As List) As Int
    Dim total As Int = 0
    For Each item As Map In lstItems
        Dim meta As Map = item.Get("meta")
        total = total + GetMetaInt(meta, "mt", 0) + item.Get("fh") + GetMetaInt(meta, "mb", 0)
    Next
    Return total
End Sub

Private Sub GetMetaInt(mMeta As Map, sKey As String, iDefaultValue As Int) As Int
    If mMeta.IsInitialized = False Then Return iDefaultValue
    If mMeta.ContainsKey(sKey) = False Then Return iDefaultValue
    Return mMeta.Get(sKey)
End Sub

Private Sub GetMetaFloat(mMeta As Map, sKey As String, fDefaultValue As Float) As Float
    If mMeta.IsInitialized = False Then Return fDefaultValue
    If mMeta.ContainsKey(sKey) = False Then Return fDefaultValue
    Return mMeta.Get(sKey)
End Sub

Private Sub GetMetaString(mMeta As Map, sKey As String, sDefaultValue As String) As String
    If mMeta.IsInitialized = False Then Return sDefaultValue
    If mMeta.ContainsKey(sKey) = False Then Return sDefaultValue
    Return mMeta.Get(sKey)
End Sub

Private Sub GetMetaBool(mMeta As Map, sKey As String, bDefaultValue As Boolean) As Boolean
    If mMeta.IsInitialized = False Then Return bDefaultValue
    If mMeta.ContainsKey(sKey) = False Then Return bDefaultValue
    Return mMeta.Get(sKey)
End Sub

Private Sub MaxI(iA As Int, iB As Int) As Int
    If iA > iB Then Return iA Else Return iB
End Sub

Private Sub MaxF(fA As Float, fB As Float) As Float
    If fA > fB Then Return fA Else Return fB
End Sub

Private Sub IIfI(bCondition As Boolean, iTrueValue As Int, iFalseValue As Int) As Int
    If bCondition Then Return iTrueValue Else Return iFalseValue
End Sub
