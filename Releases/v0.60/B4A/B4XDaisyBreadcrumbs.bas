B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

#Region Events
#Event: ItemClick (ItemId As String)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables breadcrumb interaction.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the component.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, List: text-sm|text-base|text-lg|text-xl, Description: Tailwind text size token used by all crumbs.
#DesignerProperty: Key: CurrentIndex, DisplayName: Current Index, FieldType: Int, DefaultValue: -1, Description: Active breadcrumb index. -1 uses the last item.
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
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mItems.Initialize
End Sub

''' <summary>
''' Creates the component programmatically.
''' </summary>
Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("mBase")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, Width, Height)
    DesignerCreateView(b, Null, BuildRuntimeProps)
    Return mBase
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    BuildHostStructure
    ApplyDesignerProps(Props)
    Refresh
End Sub
#End Region

#Region Public API
''' <summary>
''' Returns the public base view.
''' </summary>
Public Sub getView As B4XView
    Return mBase
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    Parent.AddView(mBase, Left, Top, Max(1dip, Width), Max(1dip, Height))
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
Public Sub SetItems(Items As List)
    mItems = NormalizeItemsList(Items)
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
Public Sub ClearItems
    mItems.Initialize
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds a breadcrumb item.
''' </summary>
Public Sub AddItem(Id As String, Text As String, IconPath As String, Clickable As Boolean)
    If mItems.IsInitialized = False Then mItems.Initialize
    mItems.Add(CreateNormalizedItem(Id, Text, IconPath, Clickable, True))
    mItems = NormalizeItemsList(mItems)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Sets the enabled state.
''' </summary>
Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
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
Public Sub setVisible(Value As Boolean)
    mbVisible = Value
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
Public Sub setTextSize(Value As String)
    msTextSize = NormalizeTextSizeToken(Value)
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
Public Sub setCurrentIndex(Value As Int)
    miCurrentIndex = Value
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
Public Sub setTag(Value As Object)
    mTag = Value
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
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    If xvScroll.IsInitialized = False Then Return
    xvScroll.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
    RenderItems(Max(1dip, Width), Max(1dip, Height))
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

Private Sub ApplyDesignerProps(Props As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    msTextSize = NormalizeTextSizeToken(B4XDaisyVariants.GetPropString(Props, "TextSize", "text-sm"))
    miCurrentIndex = B4XDaisyVariants.GetPropInt(Props, "CurrentIndex", -1)
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Enabled": mbEnabled, _
        "Visible": mbVisible, _
        "TextSize": msTextSize, _
        "CurrentIndex": miCurrentIndex)
End Sub

Private Sub RenderItems(AvailableWidth As Int, AvailableHeight As Int)
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

    miContentWidth = Max(currentLeft, AvailableWidth)
    miContentHeight = Max(1dip, contentHeight)

    xvScroll.SetLayoutAnimated(0, 0, 0, AvailableWidth, Max(miContentHeight, AvailableHeight))
    mHScroll.Panel.Width = miContentWidth
    mHScroll.Panel.Height = Max(miContentHeight, AvailableHeight)
    mItemsPanel.SetLayoutAnimated(0, 0, 0, miContentWidth, contentHeight)
End Sub

Private Sub CreateCrumbView(Item As Map, Index As Int, CurrentIndexResolved As Int, FontSize As Float, ItemHeight As Int, LabelHeight As Int, TextColor As Int, IconSizeDip As Int, ItemGapDip As Int) As B4XView
    Dim p As Panel
    p.Initialize("crumb")
    Dim crumb As B4XView = p
    crumb.Color = xui.Color_Transparent

    Dim textValue As String = Item.GetDefault("Text", "")
    Dim iconPath As String = Item.GetDefault("IconPath", "")
    Dim clickable As Boolean = ResolveItemClickable(Item, Index, CurrentIndexResolved)
    crumb.Tag = CreateMap( _
        "id": Item.GetDefault("Id", ""), _
        "clickable": clickable)
    crumb.Enabled = clickable

    Dim currentLeft As Int = 0

    If iconPath.Length > 0 Then
        Dim iconComp As B4XDaisySvgIcon
        iconComp.Initialize(Me, "")
        Dim iconView As B4XView = iconComp.AddToParent(crumb, 0, 0, IconSizeDip, IconSizeDip)
        iconComp.SvgAsset = iconPath
        iconComp.Color = TextColor
        iconView.SetLayoutAnimated(0, 0, Round((ItemHeight - IconSizeDip) / 2), IconSizeDip, IconSizeDip)
        currentLeft = currentLeft + IconSizeDip + ItemGapDip
    End If

    Dim l As Label
    l.Initialize("")
    Dim xlbl As B4XView = l
    xlbl.Color = xui.Color_Transparent
    xlbl.Text = textValue
    xlbl.TextColor = TextColor
    xlbl.TextSize = FontSize
    xlbl.SetTextAlignment("CENTER", "LEFT")
    Dim nativeLabel As Label = xlbl
    nativeLabel.SingleLine = True
    Dim joLbl As JavaObject = nativeLabel
    joLbl.RunMethod("setIncludeFontPadding", Array(False))
    Dim textTop As Int = Round((itemHeight - LabelHeight) / 2)
    crumb.AddView(xlbl, currentLeft, textTop, Max(1dip, MeasureTextWidth(textValue, FontSize)), Max(1dip, LabelHeight))

    Dim crumbWidth As Int = currentLeft + xlbl.Width
    crumb.SetLayoutAnimated(0, 0, 0, Max(1dip, crumbWidth), Max(1dip, ItemHeight))
    Return crumb
End Sub

Private Sub CreateSeparatorView(ColorValue As Int, SeparatorSizeDip As Int, SeparatorMarginStartDip As Int, SeparatorMarginEndDip As Int) As B4XView
    Dim totalWidth As Int = SeparatorMarginStartDip + SeparatorSizeDip + SeparatorMarginEndDip
    Dim totalHeight As Int = Max(SeparatorSizeDip, 8dip)

    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    host.Color = xui.Color_Transparent
    host.SetLayoutAnimated(0, 0, 0, totalWidth, totalHeight)

    Dim pnlChevron As Panel
    pnlChevron.Initialize("")
    Dim chevron As B4XView = pnlChevron
    chevron.Color = xui.Color_Transparent
    host.AddView(chevron, SeparatorMarginStartDip, Round((totalHeight - SeparatorSizeDip) / 2), SeparatorSizeDip, SeparatorSizeDip)

    Dim cvs As B4XCanvas
    cvs.Initialize(chevron)
    cvs.ClearRect(cvs.TargetRect)
    cvs.DrawLine(1dip, 0, SeparatorSizeDip - 1dip, SeparatorSizeDip / 2, ColorValue, 1dip)
    cvs.DrawLine(SeparatorSizeDip - 1dip, SeparatorSizeDip / 2, 1dip, SeparatorSizeDip, ColorValue, 1dip)
    cvs.Invalidate
    cvs.Release

    Return host
End Sub
#End Region

#Region Item Helpers
Private Sub NormalizeItemsList(Source As List) As List
    Dim nextItems As List
    nextItems.Initialize
    If Source.IsInitialized = False Then Return nextItems

    For Each rawItem As Object In Source
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

Private Sub CreateNormalizedItem(IdValue As String, TextValue As String, IconPath As String, Clickable As Boolean, HasClickable As Boolean) As Map
    Dim normalized As Map
    normalized.Initialize
    normalized.Put("Id", NormalizeItemId(IdValue, TextValue))
    normalized.Put("Text", TextValue.Trim)
    normalized.Put("IconPath", ResolveIconPath(IconPath))
    normalized.Put("Clickable", Clickable)
    normalized.Put("HasClickable", HasClickable)
    Return normalized
End Sub

Private Sub EnsureUniqueItemIds(Source As List) As List
    Dim nextItems As List
    nextItems.Initialize
    Dim seenIds As Map
    seenIds.Initialize

    For i = 0 To Source.Size - 1
        Dim item As Map = Source.Get(i)
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

Private Sub NormalizeItemId(IdValue As String, TextValue As String) As String
    Dim resolvedId As String = ""
    If IdValue <> Null Then resolvedId = IdValue.Trim
    If resolvedId.Length = 0 Then
        If TextValue <> Null Then resolvedId = TextValue.Trim
    End If
    If resolvedId.Length = 0 Then resolvedId = "breadcrumb-item"
    resolvedId = resolvedId.Replace(" ", "-")
    Return resolvedId.ToLowerCase
End Sub

Private Sub ResolveItemClickable(Item As Map, Index As Int, CurrentIndexResolved As Int) As Boolean
    If Item.GetDefault("HasClickable", False) Then Return Item.GetDefault("Clickable", False) And mbEnabled
    Return (Index < CurrentIndexResolved) And mbEnabled
End Sub

Private Sub ResolveCurrentIndex As Int
    If mItems.IsInitialized = False Or mItems.Size = 0 Then Return -1
    If miCurrentIndex < 0 Or miCurrentIndex >= mItems.Size Then Return mItems.Size - 1
    Return miCurrentIndex
End Sub

Private Sub ScaleDimensionByTextSize(BaseSizeDip As Int, FontSize As Float, IsSeparator As Boolean) As Int
    Dim scaleFactor As Float = Max(mfMinScaleFactor, FontSize / mfTextScaleBase)
    Dim scaledSize As Int = Max(1dip, Round(BaseSizeDip * scaleFactor))
    If IsSeparator Then Return Max(miMinSeparatorSizeDip, scaledSize)
    Return scaledSize
End Sub

Private Sub ScaleSpacingByTextSize(BaseSizeDip As Int, FontSize As Float) As Int
    Dim scaleFactor As Float = Max(mfMinScaleFactor, FontSize / mfTextScaleBase)
    Return Max(1dip, Round(BaseSizeDip * scaleFactor))
End Sub

Private Sub NormalizeTextSizeToken(Value As String) As String
    If Value = Null Then Return "text-sm"
    Dim token As String = Value.ToLowerCase.Trim
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

Private Sub ResolveIconPath(Value As String) As String
    If Value = Null Then Return ""
    Dim trimmed As String = Value.Trim
    If trimmed.Length = 0 Then Return ""
    Return B4XDaisyVariants.ResolveAssetImage(trimmed, "")
End Sub

Private Sub MeasureTextWidth(TextValue As String, FontSize As Float) As Int
    Return B4XDaisyVariants.MeasureTextWidthSafe(TextValue, FontSize, Typeface.DEFAULT, 4dip)
End Sub

Private Sub MeasureSingleLineTextHeight(FontSize As Float) As Int
    ' Use a probe with an ascender and a descender to size single-line labels safely.
    ' extraPad uses 0.5x font size to ensure descenders (g, y, p, j) are never clipped
    ' when setIncludeFontPadding(false) removes the default Android bottom cushion.
    Dim probe As String = "Ag"
    Dim extraPad As Int = Max(miTextVerticalBufferDip, Ceil(FontSize * 0.5))
    Dim cvs As Canvas
    Try
        Dim lbl As Label
        lbl.Initialize("")
        cvs.Initialize(lbl)
        Dim h As Float = cvs.MeasureStringHeight(probe, lbl.Typeface, FontSize)
        Return Max(1dip, Ceil(h) + extraPad)
    Catch
        ' Fall back to the same padding model when canvas measurement is unavailable.
    End Try
    Return Max(1dip, Ceil(FontSize * 1.3) + extraPad)
End Sub

Private Sub ApplyAlpha(ColorValue As Int, Alpha01 As Float) As Int
    Dim alphaValue As Int = Max(0, Min(255, Round(255 * Alpha01)))
    Dim redValue As Int = Bit.And(Bit.UnsignedShiftRight(ColorValue, 16), 0xFF)
    Dim greenValue As Int = Bit.And(Bit.UnsignedShiftRight(ColorValue, 8), 0xFF)
    Dim blueValue As Int = Bit.And(ColorValue, 0xFF)
    Return Bit.Or(Bit.ShiftLeft(alphaValue, 24), Bit.Or(Bit.ShiftLeft(redValue, 16), Bit.Or(Bit.ShiftLeft(greenValue, 8), blueValue)))
End Sub
#End Region