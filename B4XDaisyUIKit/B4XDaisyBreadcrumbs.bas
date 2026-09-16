B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: ItemClick (ItemId As String)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables breadcrumb interaction.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the component.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, List: text-sm|text-base|text-lg|text-xl, Description: Tailwind text size token used by all crumbs.
#DesignerProperty: Key: CurrentIndex, DisplayName: Current Index, FieldType: Int, DefaultValue: -1, Description: Active breadcrumb index. -1 uses the last item.
#DesignerProperty: Key: RTL, DisplayName: Right-To-Left, FieldType: Boolean, DefaultValue: False, Description: Flips chevron direction for RTL languages.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private mHScroll As HorizontalScrollView
    Private xvScroll As B4XView
    Private mItemsPanel As B4XView

    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private msTextSize As String = "text-sm"
    Private miCurrentIndex As Int = -1
    Private mbRTL As Boolean = False

    Private mItems As List
    Private miContentWidth As Int = 0
    Private miContentHeight As Int = 0

    Private miPaddingYDip As Int = 8dip
    Private miItemGapDip As Int = 8dip
    Private miIconSizeDip As Int = 16dip
    Private miSeparatorSizeDip As Int = 6dip
    Private miSeparatorMarginStartDip As Int = 8dip
    Private miSeparatorMarginEndDip As Int = 12dip
    Private miTextVerticalBufferDip As Int = 6dip
    Private mfTextScaleBase As Float = 14
    Private mfMinScaleFactor As Float = 0.75
    Private miMinSeparatorSizeDip As Int = 4dip
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
End Sub

''' <summary>
''' Creates the component programmatically.
''' </summary>
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("mBase")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    DesignerCreateView(b, Null, BuildRuntimeProps)
    Return mBase
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    BuildHostStructure
    ApplyDesignerProps(mProps)
    Refresh
End Sub
#End Region

#Region Public API
''' <summary>
''' Returns the public base view.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    vParent.AddView(mBase, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    Base_Resize(mBase.Width, mBase.Height)
    Return mBase
End Sub

''' <summary>
''' Refreshes theme-aware colors and redraws the component.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Rebuilds the breadcrumb layout.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    If mItemsPanel.IsInitialized = False Then Return

    mBase.Visible = mbVisible
    mBase.Enabled = mbEnabled
    ' Disabled: dim the breadcrumb trail so it reads as inactive.
    mBase.Alpha = IIf(mbEnabled, 1.0, 0.3)
    xvScroll.Visible = mbVisible
    xvScroll.Enabled = mbEnabled
    mBase.Color = xui.Color_Transparent
    B4XDaisyVariants.DisableClippingRecursive(mBase)

    RenderItems(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
End Sub

''' <summary>
''' Returns the currently rendered component height.
''' </summary>
Public Sub GetComputedHeight As Int
    If miContentHeight > 0 Then Return miContentHeight
    If mBase.IsInitialized = False Then Return 1dip
    Return mBase.Height
End Sub

''' <summary>
''' Replaces the current breadcrumb items.
''' </summary>
Public Sub SetItems(lstItems As List)
    mItems = NormalizeItemsList(lstItems)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Returns a copy of the breadcrumb items list.
''' </summary>
Public Sub getItems As List
    Return NormalizeItemsList(mItems)
End Sub

''' <summary>
''' Removes all breadcrumb items.
''' </summary>
Public Sub Clear
    mItems.Initialize
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds a breadcrumb item.
''' </summary>
Public Sub AddItem(sId As String, sText As String, sIconPath As String, bClickable As Boolean)
    If mItems.IsInitialized = False Then mItems.Initialize
    mItems.Add(CreateNormalizedItem(sId, sText, sIconPath, bClickable, True))
    mItems = NormalizeItemsList(mItems)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Sets the enabled state.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the enabled state.
''' </summary>
Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

''' <summary>
''' Sets the visible state.
''' </summary>
Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the visible state.
''' </summary>
Public Sub getVisible As Boolean
    Return mbVisible
End Sub

''' <summary>
''' Sets the breadcrumb text size token.
''' </summary>
Public Sub setTextSize(sValue As String)
    msTextSize = NormalizeTextSizeToken(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the breadcrumb text size token.
''' </summary>
Public Sub getTextSize As String
    Return msTextSize
End Sub

''' <summary>
''' Sets the active breadcrumb index. -1 uses the last item.
''' </summary>
Public Sub setCurrentIndex(iValue As Int)
    miCurrentIndex = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the active breadcrumb index.
''' </summary>
Public Sub getCurrentIndex As Int
    Return miCurrentIndex
End Sub

''' <summary>
''' Sets the component tag.
''' </summary>
Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

''' <summary>
''' Gets the component tag.
''' </summary>
Public Sub getTag As Object
    Return mTag
End Sub

''' <summary>
''' Removes the component from its parent.
''' </summary>
Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If xvScroll.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    xvScroll.SetLayoutAnimated(0, 0, 0, Max(1dip, dWidth), Max(1dip, dHeight))
    RenderItems(Max(1dip, dWidth), Max(1dip, dHeight))
    inResize = False
End Sub

Private Sub crumb_Click
    If mbEnabled = False Then Return
    Dim senderView As B4XView = Sender
    If senderView.Tag = Null Then Return
    Dim meta As Map = senderView.Tag
    If meta.GetDefault("clickable", False) = False Then Return

    Dim itemId As String = "" & meta.GetDefault("id", "")

    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 1) Then
        CallSub2(mCallBack, mEventName & "_ItemClick", itemId)
    End If
End Sub
#End Region

#Region Rendering
' DaisyUI token support map for parity validation:
' block breadcrumbs cursor-pointer flex gap-2 h-1.5 h-4 hover:underline inline-flex items-center
' max-w-full max-w-xs me-3 min-h-min ms-2 opacity-40 outline-hidden overflow-x-auto py-2
' stroke-current text-sm w-1.5 w-4 whitespace-nowrap
Private Sub BuildHostStructure
    Dim hsv As HorizontalScrollView
    hsv.Initialize(0, "")
    mHScroll = hsv
    xvScroll = mHScroll
    Dim jo As JavaObject = mHScroll
    jo.RunMethod("setHorizontalScrollBarEnabled", Array(False))
    jo.RunMethod("setVerticalScrollBarEnabled", Array(False))
    mBase.AddView(xvScroll, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
    mHScroll.Panel.Color = xui.Color_Transparent

    Dim p As Panel
    p.Initialize("")
    mItemsPanel = p
    mItemsPanel.Color = xui.Color_Transparent
    mHScroll.Panel.AddView(mItemsPanel, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    msTextSize = NormalizeTextSizeToken(B4XDaisyVariants.GetPropString(mProps, "TextSize", msTextSize))
    miCurrentIndex = B4XDaisyVariants.GetPropInt(mProps, "CurrentIndex", miCurrentIndex)
    mbRTL = B4XDaisyVariants.GetPropBool(mProps, "RTL", mbRTL)
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Enabled": mbEnabled, _
        "Visible": mbVisible, _
        "TextSize": msTextSize, _
        "CurrentIndex": miCurrentIndex)
End Sub

Private Sub RenderItems(iAvailableWidth As Int, iAvailableHeight As Int)
    If mItemsPanel.IsInitialized = False Then Return
    If mItems.IsInitialized = False Then Return
    mItemsPanel.RemoveAllViews

    Dim fontSize As Float = B4XDaisyVariants.ResolveTextSizeDip(msTextSize)
    Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(msTextSize, fontSize, fontSize * 1.4)
    fontSize = tm.GetDefault("font_size", fontSize)
    Dim iconSizeDip As Int = ScaleDimensionByTextSize(miIconSizeDip, fontSize, False)
    Dim separatorSizeDip As Int = ScaleDimensionByTextSize(miSeparatorSizeDip, fontSize, True)
    Dim itemGapDip As Int = ScaleSpacingByTextSize(miItemGapDip, fontSize)
    Dim separatorMarginStartDip As Int = ScaleSpacingByTextSize(miSeparatorMarginStartDip, fontSize)
    Dim separatorMarginEndDip As Int = ScaleSpacingByTextSize(miSeparatorMarginEndDip, fontSize)
    Dim lineHeightPx As Int = Ceil(tm.GetDefault("line_height_px", fontSize * 1.4))
    Dim labelHeight As Int = Max(lineHeightPx, MeasureSingleLineTextHeight(fontSize)) + 4dip
    Dim itemHeight As Int = Max(iconSizeDip, labelHeight)
    Dim baseContentColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
    Dim separatorColor As Int = ApplyAlpha(baseContentColor, 0.4)
    Dim currentIndexResolved As Int = ResolveCurrentIndex

    Dim currentLeft As Int = 0
    Dim contentHeight As Int = itemHeight + (miPaddingYDip * 2)

    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)

        If i > 0 Then
            Dim separatorView As B4XView = CreateSeparatorView(separatorColor, separatorSizeDip, separatorMarginStartDip, separatorMarginEndDip)
            mItemsPanel.AddView(separatorView, currentLeft, Round((contentHeight - separatorView.Height) / 2), separatorView.Width, separatorView.Height)
            currentLeft = currentLeft + separatorView.Width
        End If

        Dim crumbView As B4XView = CreateCrumbView(item, i, currentIndexResolved, fontSize, itemHeight, labelHeight, baseContentColor, iconSizeDip, itemGapDip)
        Dim crumbTop As Int = Round((contentHeight - crumbView.Height) / 2)
        mItemsPanel.AddView(crumbView, currentLeft, crumbTop, crumbView.Width, crumbView.Height)
        currentLeft = currentLeft + crumbView.Width
    Next

    miContentWidth = Max(currentLeft, iAvailableWidth)
    miContentHeight = Max(1dip, contentHeight)

    xvScroll.SetLayoutAnimated(0, 0, 0, iAvailableWidth, Max(miContentHeight, iAvailableHeight))
    mHScroll.Panel.Width = miContentWidth
    mHScroll.Panel.Height = Max(miContentHeight, iAvailableHeight)
    mItemsPanel.SetLayoutAnimated(0, 0, 0, miContentWidth, contentHeight)
End Sub

Private Sub CreateCrumbView(mItem As Map, iIndex As Int, iCurrentIndexResolved As Int, fFontSize As Float, iItemHeight As Int, iLabelHeight As Int, iTextColor As Int, iIconSizeDip As Int, iItemGapDip As Int) As B4XView
    Dim p As Panel
    p.Initialize("crumb")
    Dim crumb As B4XView = p
    crumb.Color = xui.Color_Transparent

    Dim textValue As String = mItem.GetDefault("Text", "")
    Dim iconPath As String = mItem.GetDefault("IconPath", "")
    Dim clickable As Boolean = ResolveItemClickable(mItem, iIndex, iCurrentIndexResolved)
    crumb.Tag = CreateMap( _
        "id": mItem.GetDefault("Id", ""), _
        "clickable": clickable)
    crumb.Enabled = clickable

    Dim currentLeft As Int = 0

    If iconPath.Length > 0 Then
        Dim iconComp As B4XDaisySvgIcon
        iconComp.Initialize(Me, "")
        Dim iconView As B4XView = iconComp.AddToParent(crumb, 0, 0, iIconSizeDip, iIconSizeDip)
        iconComp.SetClickable(False)
        iconComp.SvgAsset = iconPath
        iconComp.Color = iTextColor
        iconView.SetLayoutAnimated(0, 0, Round((iItemHeight - iIconSizeDip) / 2), iIconSizeDip, iIconSizeDip)
        currentLeft = currentLeft + iIconSizeDip + iItemGapDip
    End If

    Dim l As Label
    l.Initialize("")
    Dim xlbl As B4XView = l
    xlbl.Color = xui.Color_Transparent
    xlbl.Text = textValue
    xlbl.TextColor = iTextColor
    xlbl.TextSize = fFontSize
    xlbl.SetTextAlignment("CENTER", "LEFT")
    Dim nativeLabel As Label = xlbl
    nativeLabel.SingleLine = True
    #If B4A
    Dim joLbl As JavaObject = nativeLabel
    joLbl.RunMethod("setIncludeFontPadding", Array(True))
    #End If
    Dim textTop As Int = Round((iItemHeight - iLabelHeight) / 2)
    crumb.AddView(xlbl, currentLeft, textTop, Max(1dip, MeasureTextWidth(textValue, fFontSize)), Max(1dip, iLabelHeight))

    Dim crumbWidth As Int = currentLeft + xlbl.Width
    crumb.SetLayoutAnimated(0, 0, 0, Max(1dip, crumbWidth), Max(1dip, iItemHeight))
    Return crumb
End Sub

Private Sub CreateSeparatorView(iColorValue As Int, iSeparatorSizeDip As Int, iSeparatorMarginStartDip As Int, iSeparatorMarginEndDip As Int) As B4XView
    Dim totalWidth As Int = iSeparatorMarginStartDip + iSeparatorSizeDip + iSeparatorMarginEndDip
    Dim totalHeight As Int = Max(iSeparatorSizeDip, 8dip)

    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    host.Color = xui.Color_Transparent
    host.SetLayoutAnimated(0, 0, 0, totalWidth, totalHeight)

    Dim pnlChevron As Panel
    pnlChevron.Initialize("")
    Dim chevron As B4XView = pnlChevron
    chevron.Color = xui.Color_Transparent
    host.AddView(chevron, iSeparatorMarginStartDip, Round((totalHeight - iSeparatorSizeDip) / 2), iSeparatorSizeDip, iSeparatorSizeDip)

    Dim cvs As B4XCanvas
    cvs.Initialize(chevron)
    cvs.ClearRect(cvs.TargetRect)
    Dim s As Int = iSeparatorSizeDip
    If mbRTL Then
        ' RTL: chevron points left (<)
        cvs.DrawLine(s - 1dip, 0, 1dip, s / 2, iColorValue, 1dip)
        cvs.DrawLine(1dip, s / 2, s - 1dip, s, iColorValue, 1dip)
    Else
        ' LTR: chevron points right (>)
        cvs.DrawLine(1dip, 0, s - 1dip, s / 2, iColorValue, 1dip)
        cvs.DrawLine(s - 1dip, s / 2, 1dip, s, iColorValue, 1dip)
    End If
    cvs.Invalidate
    cvs.Release

    Return host
End Sub
#End Region

#Region Item Helpers
Private Sub NormalizeItemsList(lstSource As List) As List
    Dim nextItems As List
    nextItems.Initialize
    If lstSource.IsInitialized = False Then Return nextItems

    For Each rawItem As Object In lstSource
        If rawItem Is Map Then
            Dim item As Map = rawItem
            Dim idValue As String = ""
            If item.ContainsKey("Id") Then idValue = "" & item.Get("Id")

            Dim textValue As String = ""
            If item.ContainsKey("Text") Then textValue = "" & item.Get("Text")
            If textValue.Trim.Length = 0 Then Continue

            Dim iconPath As String = ""
            If item.ContainsKey("IconPath") Then iconPath = "" & item.Get("IconPath")

            Dim clickableValue As Boolean = False
            Dim hasClickable As Boolean = False
            If item.ContainsKey("Clickable") Then
                clickableValue = item.Get("Clickable")
                hasClickable = True
            End If

            nextItems.Add(CreateNormalizedItem(idValue, textValue, iconPath, clickableValue, hasClickable))
        End If
    Next

    Return EnsureUniqueItemIds(nextItems)
End Sub

Private Sub CreateNormalizedItem(sIdValue As String, sTextValue As String, sIconPath As String, bClickable As Boolean, bHasClickable As Boolean) As Map
    Dim normalized As Map
    normalized.Initialize
    normalized.Put("Id", NormalizeItemId(sIdValue, sTextValue))
    normalized.Put("Text", sTextValue.Trim)
    normalized.Put("IconPath", ResolveIconPath(sIconPath))
    normalized.Put("Clickable", bClickable)
    normalized.Put("HasClickable", bHasClickable)
    Return normalized
End Sub

Private Sub EnsureUniqueItemIds(lstSource As List) As List
    Dim nextItems As List
    nextItems.Initialize
    Dim seenIds As Map
    seenIds.Initialize

    For i = 0 To lstSource.Size - 1
        Dim item As Map = lstSource.Get(i)
        Dim baseId As String = NormalizeItemId("" & item.GetDefault("Id", ""), "" & item.GetDefault("Text", ""))
        Dim resolvedId As String = baseId
        Dim suffix As Int = 2

        Do While seenIds.ContainsKey(resolvedId)
            resolvedId = baseId & "-" & suffix
            suffix = suffix + 1
        Loop

        seenIds.Put(resolvedId, True)
        nextItems.Add(CreateNormalizedItem( _
            resolvedId, _
            "" & item.GetDefault("Text", ""), _
            "" & item.GetDefault("IconPath", ""), _
            item.GetDefault("Clickable", False), _
            item.GetDefault("HasClickable", False)))
    Next

    Return nextItems
End Sub

Private Sub NormalizeItemId(sIdValue As String, sTextValue As String) As String
    Dim resolvedId As String = ""
    If sIdValue <> Null Then resolvedId = sIdValue.Trim
    If resolvedId.Length = 0 Then
        If sTextValue <> Null Then resolvedId = sTextValue.Trim
    End If
    If resolvedId.Length = 0 Then resolvedId = "breadcrumb-item"
    resolvedId = resolvedId.Replace(" ", "-")
    Return resolvedId.ToLowerCase
End Sub

Private Sub ResolveItemClickable(mItem As Map, iIndex As Int, iCurrentIndexResolved As Int) As Boolean
    If mItem.GetDefault("HasClickable", False) Then Return mItem.GetDefault("Clickable", False) And mbEnabled
    Return (iIndex < iCurrentIndexResolved) And mbEnabled
End Sub

Private Sub ResolveCurrentIndex As Int
    If mItems.IsInitialized = False Or mItems.Size = 0 Then Return -1
    If miCurrentIndex < 0 Or miCurrentIndex >= mItems.Size Then Return mItems.Size - 1
    Return miCurrentIndex
End Sub

Private Sub ScaleDimensionByTextSize(iBaseSizeDip As Int, fFontSize As Float, bIsSeparator As Boolean) As Int
    Dim scaleFactor As Float = Max(mfMinScaleFactor, fFontSize / mfTextScaleBase)
    Dim scaledSize As Int = Max(1dip, Round(iBaseSizeDip * scaleFactor))
    If bIsSeparator Then Return Max(miMinSeparatorSizeDip, scaledSize)
    Return scaledSize
End Sub

Private Sub ScaleSpacingByTextSize(iBaseSizeDip As Int, fFontSize As Float) As Int
    Dim scaleFactor As Float = Max(mfMinScaleFactor, fFontSize / mfTextScaleBase)
    Return Max(1dip, Round(iBaseSizeDip * scaleFactor))
End Sub

Private Sub NormalizeTextSizeToken(sValue As String) As String
    If sValue = Null Then Return "text-sm"
    Dim token As String = sValue.ToLowerCase.Trim
    If token.Length = 0 Then Return "text-sm"
    Select Case token
        Case "sm"
            Return "text-sm"
        Case "md", "base"
            Return "text-base"
        Case "lg"
            Return "text-lg"
        Case "xl"
            Return "text-xl"
    End Select
    If token.StartsWith("text-") Then Return token
    Return "text-sm"
End Sub

Private Sub ResolveIconPath(sValue As String) As String
    If sValue = Null Then Return ""
    Dim trimmed As String = sValue.Trim
    If trimmed.Length = 0 Then Return ""
    Return B4XDaisyVariants.ResolveAssetImage(trimmed, "")
End Sub

Private Sub MeasureTextWidth(sTextValue As String, fFontSize As Float) As Int
    Return B4XDaisyVariants.MeasureTextWidthSafe(sTextValue, fFontSize, Typeface.DEFAULT, 8dip)
End Sub

Private Sub MeasureSingleLineTextHeight(fFontSize As Float) As Int
    ' Single-line text height with ample vertical space so font ascenders & descenders are never clipped.
    Return Max(24dip, Ceil(fFontSize * 1.6 * 1dip) + 8dip)
End Sub

Private Sub ApplyAlpha(iColorValue As Int, fAlpha01 As Float) As Int
    Dim alphaValue As Int = Max(0, Min(255, Round(255 * fAlpha01)))
    Dim redValue As Int = Bit.And(Bit.UnsignedShiftRight(iColorValue, 16), 0xFF)
    Dim greenValue As Int = Bit.And(Bit.UnsignedShiftRight(iColorValue, 8), 0xFF)
    Dim blueValue As Int = Bit.And(iColorValue, 0xFF)
    Return Bit.Or(Bit.ShiftLeft(alphaValue, 24), Bit.Or(Bit.ShiftLeft(redValue, 16), Bit.Or(Bit.ShiftLeft(greenValue, 8), blueValue)))
End Sub
#End Region

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
Public Sub getRTL As Boolean
    Return mbRTL
End Sub

Public Sub setRTL(bValue As Boolean)
    mbRTL = bValue
End Sub
