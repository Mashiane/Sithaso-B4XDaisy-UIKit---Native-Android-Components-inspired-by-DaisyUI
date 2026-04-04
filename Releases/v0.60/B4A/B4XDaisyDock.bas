B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: ItemClick (ItemId As String)

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy dock size token.
#DesignerProperty: Key: ActiveIndex, DisplayName: Active Index, FieldType: Int, DefaultValue: 1, Description: Zero-based active item index. Use -1 for no active item.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Dock background color (0 = theme base-100).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Dock text/icon color (0 = theme base-content).
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: theme|none|sm|rounded|md|lg|xl|2xl|3xl|full, Description: Corner radius style.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind size token or CSS size string.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Tailwind size token or CSS size string. auto follows the dock size token.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enable or disable dock interactions.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide the dock.

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private msSize As String = "md"
    Private miActiveIndex As Int = 1
    Private mcBackgroundColor As Int = 0
    Private mcTextColor As Int = 0
    Private msShadow As String = "none"
    Private msRounded As String = "none"
    Private msWidth As String = "w-full"
    Private msHeight As String = "auto"
    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True

    Private miRuntimeWidthDip As Int = 0
    Private miRuntimeHeightDip As Int = 0

    Private mcBorderColor As Int = 0

    Private pnlSurface As B4XView
    Private pnlTopBorder As B4XView
    Private pnlMeasure As B4XView
    Private cvsMeasure As B4XCanvas
    Private mItems As List

    Type TDockItem (Id As String, Text As String, SvgAsset As String, Variant As String, Enabled As Boolean, Tag As Object)
End Sub

''' <summary>
''' Initializes the dock component.
''' </summary>
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mItems.Initialize
End Sub

''' <summary>
''' Creates a programmatic dock view.
''' </summary>
Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    miRuntimeWidthDip = Max(1dip, Width)
    miRuntimeHeightDip = Max(0, Height)
    b.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, IIf(Height > 0, Height, ResolveDockHeightDip(msSize))))
    DesignerCreateView(b, Null, BuildRuntimeProps)
    Return mBase
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    If mItems.IsInitialized = False Then mItems.Initialize

    BuildHost
    ApplyDesignerProps(Props)
    Refresh
End Sub

Private Sub BuildHost
    Dim pSurface As Panel
    pSurface.Initialize("")
    pnlSurface = pSurface
    pnlSurface.Color = xui.Color_Transparent
    mBase.AddView(pnlSurface, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))

    Dim pBorder As Panel
    pBorder.Initialize("")
    pnlTopBorder = pBorder
    pnlTopBorder.Color = xui.Color_Transparent
    mBase.AddView(pnlTopBorder, 0, 0, Max(1dip, mBase.Width), 1dip)

    Dim pMeasure As Panel
    pMeasure.Initialize("")
    pnlMeasure = pMeasure
    pnlMeasure.Color = xui.Color_Transparent
    mBase.AddView(pnlMeasure, 0, 0, 120dip, 32dip)
    pnlMeasure.Visible = False
    cvsMeasure.Initialize(pnlMeasure)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    msSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", "md"))
    miActiveIndex = B4XDaisyVariants.GetPropInt(Props, "ActiveIndex", 1)
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", 0)
    mcTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", 0)
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "none"))
    msWidth = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(Props, "Width", "w-full"), "w-full")
    msHeight = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(Props, "Height", "auto"), "auto")
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Size": msSize, _
        "ActiveIndex": miActiveIndex, _
        "BackgroundColor": mcBackgroundColor, _
        "TextColor": mcTextColor, _
        "Shadow": msShadow, _
        "Rounded": msRounded, _
        "Width": msWidth, _
        "Height": msHeight, _
        "Enabled": mbEnabled, _
        "Visible": mbVisible)
End Sub

''' <summary>
''' Adds an item that uses an SVG asset file for the icon.
''' </summary>
Public Sub AddItem(Id As String, Text As String, SvgAssetFile As String) As Int
    Return AddItemWithVariant(Id, Text, SvgAssetFile, "none")
End Sub

''' <summary>
''' Adds an item with a specific DaisyUI variant color.
''' </summary>
Public Sub AddItemWithVariant(Id As String, Text As String, SvgAssetFile As String, VariantName As String) As Int
    Dim itm As TDockItem = CreateDockItem(Id, Text, SvgAssetFile, VariantName, True, Null)
    Dim idx As Int = mItems.Size
    mItems.Add(itm)
    If mBase.IsInitialized Then Refresh
    Return idx
End Sub

''' <summary>
''' Clears all dock items.
''' </summary>
Public Sub ClearItems
    mItems.Clear
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Sets a custom tag for an item by index.
''' </summary>
Public Sub SetItemTagByIndex(Index As Int, TagValue As Object)
    If Index < 0 Then Return
    If Index >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(Index)
    itm.Tag = TagValue
    mItems.Set(Index, itm)
End Sub

''' <summary>
''' Sets a custom tag for an item by its unique ID.
''' </summary>
Public Sub SetItemTag(ItemId As String, TagValue As Object)
    Dim idx As Int = FindItemIndexById(ItemId)
    If idx < 0 Then Return
    SetItemTagByIndex(idx, TagValue)
End Sub

''' <summary>
''' Enables or disables a specific item by index.
''' </summary>
Public Sub SetItemEnabledByIndex(Index As Int, Value As Boolean)
    If Index < 0 Then Return
    If Index >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(Index)
    itm.Enabled = Value
    mItems.Set(Index, itm)
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Enables or disables a specific item by its unique ID.
''' </summary>
Public Sub SetItemEnabled(ItemId As String, Value As Boolean)
    Dim idx As Int = FindItemIndexById(ItemId)
    If idx < 0 Then Return
    SetItemEnabledByIndex(idx, Value)
End Sub

''' <summary>
''' Finds the index of an item by its unique ID. Returns -1 if not found.
''' </summary>
Private Sub FindItemIndexById(ItemId As String) As Int
    If ItemId = Null Then Return -1
    For i = 0 To mItems.Size - 1
        Dim itm As TDockItem = mItems.Get(i)
        If itm.Id = ItemId Then Return i
    Next
    Return -1
End Sub

''' <summary>
''' Re-resolves theme-driven colors and rebuilds the dock.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Applies the current state to the dock UI.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    ResolveThemeColors
    mBase.Visible = mbVisible
    pnlSurface.Visible = mbVisible
    pnlTopBorder.Visible = mbVisible

    Dim resolvedW As Int = ResolveCurrentWidthDip(mBase.Width)
    Dim resolvedH As Int = ResolveCurrentHeightDip(mBase.Height)
    If mBase.Parent <> Null Then
        If mBase.Width <> resolvedW Or mBase.Height <> resolvedH Then
            mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, resolvedW, resolvedH)
        End If
    End If
    Base_Resize(resolvedW, resolvedH)
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        CreateView(Max(1dip, IIf(Width > 0, Width, Parent.Width)), Max(0, Height))
    End If

    miRuntimeWidthDip = Max(0, Width)
    miRuntimeHeightDip = Max(0, Height)

    Dim targetW As Int = ResolveCurrentWidthDip(IIf(Width > 0, Width, Parent.Width))
    Dim targetH As Int = ResolveCurrentHeightDip(Height)
    Parent.AddView(mBase, Left, Top, targetW, targetH)
    Base_Resize(targetW, targetH)
    Return mBase
End Sub

''' <summary>
''' Returns the underlying B4XView.
''' </summary>
Public Sub View As B4XView
    Return mBase
End Sub

''' <summary>
''' Removes the dock from its parent.
''' </summary>
Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

''' <summary>
''' Supports B4XView-style animated layout updates.
''' </summary>
Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    miRuntimeWidthDip = Max(0, Width)
    miRuntimeHeightDip = Max(0, Height)
    Dim targetW As Int = ResolveCurrentWidthDip(Width)
    Dim targetH As Int = ResolveCurrentHeightDip(Height)
    mBase.SetLayoutAnimated(Duration, Left, Top, targetW, targetH)
    Base_Resize(targetW, targetH)
End Sub

Public Sub setLeft(Value As Int)
    If mBase.IsInitialized = False Then Return
    SetLayoutAnimated(0, Value, mBase.Top, mBase.Width, mBase.Height)
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Left
End Sub

Public Sub setTop(Value As Int)
    If mBase.IsInitialized = False Then Return
    SetLayoutAnimated(0, mBase.Left, Value, mBase.Width, mBase.Height)
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Top
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    If pnlSurface.IsInitialized = False Then Return

    Dim targetW As Int = Max(1dip, ResolveCurrentWidthDip(Width))
    Dim targetH As Int = Max(1dip, ResolveCurrentHeightDip(Height))

    If mBase.Parent <> Null Then
        If mBase.Width <> targetW Or mBase.Height <> targetH Then
            mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
        End If
    End If

    pnlSurface.SetLayoutAnimated(0, 0, 0, targetW, targetH)
    pnlTopBorder.SetLayoutAnimated(0, 0, 0, targetW, Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("h-0.5", 1dip)))
    ApplySurfaceStyle
    RebuildItems(targetW, targetH)

    B4XDaisyVariants.DisableClipping(pnlSurface)
    B4XDaisyVariants.DisableClippingChain(mBase, 4)
End Sub

Private Sub ApplySurfaceStyle
    Dim radiusDip As Float = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    pnlSurface.SetColorAndBorder(mcBackgroundColor, 0, 0, radiusDip)
    B4XDaisyVariants.ApplyElevation(pnlSurface, msShadow)
    ' Hide top border when dock has significant rounding to avoid visual mismatch
    If radiusDip > 4dip Then
        pnlTopBorder.Visible = False
    Else
        pnlTopBorder.Visible = True
        pnlTopBorder.Color = mcBorderColor
    End If
End Sub

Private Sub RebuildItems(Width As Int, Height As Int)
    pnlSurface.RemoveAllViews

    Dim box As Map = BuildDockBoxModel
    Dim hostRect As B4XRect
    hostRect.Initialize(0, 0, Width, Height)
    Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(hostRect, box)
    Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    Dim contentRect As B4XRect = B4XDaisyBoxModel.ToLocalRect(contentAbs, hostRect)

    If mItems.Size = 0 Then Return

    Dim dockGap As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("gap-px", 1dip))
    Dim itemBottomMargin As Int = Max(0, B4XDaisyBoxModel.TailwindSpacingToDip("mb-2", 8dip))
    Dim itemH As Int = Max(1dip, Round(contentRect.Height - itemBottomMargin))
    Dim segmentW As Float = contentRect.Width / Max(1, mItems.Size)

    For i = 0 To mItems.Size - 1
        Dim itm As TDockItem = mItems.Get(i)
        Dim preferredW As Int = ResolvePreferredItemWidth(itm, ResolveLabelTextSize(msSize))
        Dim segmentInnerW As Int = Max(1dip, Round(segmentW - dockGap))
        Dim itemW As Int = Min(B4XDaisyBoxModel.TailwindSpacingToDip("max-w-32", 128dip), Max(1dip, Min(segmentInnerW, preferredW)))
        Dim itemX As Int = Round(contentRect.Left + (segmentW * i) + ((segmentW - itemW) / 2))
        CreateItemView(i, itm, itemX, Round(contentRect.Top), itemW, itemH)
    Next
End Sub

Private Sub CreateItemView(Index As Int, Item As TDockItem, Left As Int, Top As Int, Width As Int, Height As Int)
    Dim pItem As Panel
    pItem.Initialize("item")
    Dim itemPanel As B4XView = pItem
    itemPanel.Color = xui.Color_Transparent
    itemPanel.Tag = Index
    pnlSurface.AddView(itemPanel, Left, Top, Width, Height)
    B4XDaisyVariants.DisableClipping(itemPanel)

    Dim labelFontSize As Float = ResolveLabelTextSize(msSize)
    Dim labelHeight As Int = ResolveLabelHeightDip(labelFontSize)
    Dim iconSize As Int = ResolveIconSizeDip(msSize)
    Dim gap As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("gap-px", 1dip))
    Dim showIcon As Boolean = False
    Dim showLabel As Boolean = False

    If Item.SvgAsset <> Null Then
        showIcon = Item.SvgAsset.Trim.Length > 0
    End If
    If Item.Text <> Null Then
        showLabel = Item.Text.Trim.Length > 0
    End If

    Dim totalContentHeight As Int = 0
    If showIcon Then totalContentHeight = totalContentHeight + iconSize
    If showLabel Then
        If totalContentHeight > 0 Then totalContentHeight = totalContentHeight + gap
        totalContentHeight = totalContentHeight + labelHeight
    End If
    If totalContentHeight = 0 Then totalContentHeight = iconSize

    Dim cursorY As Int = Max(0, Round((Height - totalContentHeight) / 2))
    Dim itemColor As Int = ResolveItemColor(Item.Variant, Item.Enabled)
    Dim contentBottomY As Int = 0

    If showIcon Then
        Dim iconComp As B4XDaisySvgIcon
        iconComp.Initialize(Me, "dockicon")
        Dim iconLeft As Int = Round((Width - iconSize) / 2)
        Dim iconView As B4XView = iconComp.AddToParent(itemPanel, iconLeft, cursorY, iconSize, iconSize)
        iconComp.Color = itemColor
        iconComp.SvgAsset = Item.SvgAsset
        cursorY = iconView.Top + iconView.Height
        contentBottomY = cursorY
    End If

    If showLabel Then
        If showIcon Then cursorY = cursorY + gap
        Dim lbl As Label
        lbl.Initialize("")
        lbl.SingleLine = True
        lbl.Text = Item.Text
        lbl.TextSize = labelFontSize
        Dim xlbl As B4XView = lbl
        xlbl.Color = xui.Color_Transparent
        xlbl.TextColor = itemColor
        xlbl.SetTextAlignment("CENTER", "CENTER")
        xlbl.Tag = Index
        itemPanel.AddView(xlbl, 0, cursorY, Width, labelHeight)
        contentBottomY = cursorY + labelHeight
    Else If showIcon Then
        ' When icon-only (no label), add extra space below icon for indicator clearance
        contentBottomY = contentBottomY + B4XDaisyBoxModel.TailwindSpacingToDip("mb-2", 8dip)
    End If

    AddIndicatorView(itemPanel, Width, Height, contentBottomY, Index = miActiveIndex, itemColor)
End Sub

Private Sub AddIndicatorView(Parent As B4XView, Width As Int, Height As Int, ContentBottomY As Int, IsActive As Boolean, ItemColor As Int)
    Dim pIndicator As Panel
    pIndicator.Initialize("")
    Dim indicator As B4XView = pIndicator

    Dim indicatorWidth As Int
    If IsActive Then
        indicatorWidth = B4XDaisyBoxModel.TailwindSpacingToDip("w-10", 40dip)
    Else
        indicatorWidth = B4XDaisyBoxModel.TailwindSpacingToDip("w-6", 24dip)
    End If
    Dim indicatorHeight As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("h-1", 4dip))
    Dim indicatorBottomOffset As Int = ResolveIndicatorBottomOffsetDip(msSize)
    Dim indicatorLeft As Int = Round((Width - indicatorWidth) / 2)
    Dim indicatorTop As Int = ContentBottomY + indicatorBottomOffset

    If IsActive Then
        indicator.SetColorAndBorder(ItemColor, 0, 0, B4XDaisyVariants.ResolveRoundedDip("rounded-full", 999dip))
    Else
        indicator.SetColorAndBorder(xui.Color_Transparent, 0, 0, B4XDaisyVariants.ResolveRoundedDip("rounded-full", 999dip))
    End If
    Parent.AddView(indicator, indicatorLeft, indicatorTop, indicatorWidth, indicatorHeight)
End Sub

Private Sub ResolveThemeColors
    Dim fallbackBase100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    Dim fallbackBaseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))

    If mcBackgroundColor = 0 Then mcBackgroundColor = fallbackBase100
    If mcTextColor = 0 Then mcTextColor = fallbackBaseContent
    mcBorderColor = B4XDaisyVariants.AlphaColor(fallbackBaseContent, 0.05)
End Sub

Private Sub ResolveItemColor(ItemVariant As String, ItemEnabled As Boolean) As Int
    ' If item has a specific variant, use the actual variant color (e.g., --color-primary)
    Dim v As String = B4XDaisyVariants.NormalizeVariant(ItemVariant)
    If v <> "none" Then
        ' Use the direct variant color token (e.g., --color-primary, --color-warning)
        Dim tokenName As String = "--color-" & v
        Dim variantColor As Int = B4XDaisyVariants.GetTokenColor(tokenName, mcTextColor)
        If ItemEnabled = False Or mbEnabled = False Then
            Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", mcTextColor)
            Return B4XDaisyVariants.AlphaColor(baseContent, 0.1)
        End If
        Return variantColor
    End If
    
    ' Default: use dock's text color
    If mbEnabled = False Then
        Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", mcTextColor)
        Return B4XDaisyVariants.AlphaColor(baseContent, 0.1)
    End If
    If ItemEnabled = False Then
        Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", mcTextColor)
        Return B4XDaisyVariants.AlphaColor(baseContent, 0.1)
    End If
    Return mcTextColor
End Sub

Private Sub ResolvePreferredItemWidth(Item As TDockItem, LabelFontSize As Float) As Int
    Dim preferred As Int = Max(56dip, ResolveIconSizeDip(msSize) + 20dip)
    If Item.Text <> Null Then
        If Item.Text.Trim.Length > 0 Then
            preferred = Max(preferred, MeasureLabelWidth(Item.Text, LabelFontSize) + 12dip)
        End If
    End If
    Return Min(B4XDaisyBoxModel.TailwindSpacingToDip("max-w-32", 128dip), preferred)
End Sub

Private Sub MeasureLabelWidth(Text As String, FontSize As Float) As Int
    If Text = Null Then Return 0
    If Text.Trim.Length = 0 Then Return 0
    If pnlMeasure.IsInitialized = False Then
        Return Max(24dip, (Text.Length * FontSize * 0.7) + 8dip)
    End If
    Try
        Return Max(24dip, cvsMeasure.MeasureText(Text, xui.CreateDefaultFont(FontSize)) + 8dip)
    Catch
        Return Max(24dip, (Text.Length * FontSize * 0.7) + 8dip)
    End Try
End Sub

Private Sub BuildDockBoxModel As Map
    Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtility(box, "p-2", False)
    Return box
End Sub

Private Sub ResolveCurrentWidthDip(CurrentWidth As Int) As Int
    If miRuntimeWidthDip > 0 Then Return Max(1dip, miRuntimeWidthDip)

    Dim fallback As Int = Max(1dip, CurrentWidth)
    If mBase.IsInitialized Then
        Try
            Dim parent As B4XView = mBase.Parent
            If parent.IsInitialized Then fallback = Max(1dip, parent.Width)
        Catch
        End Try
    End If
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msWidth, fallback))
End Sub

Private Sub ResolveCurrentHeightDip(CurrentHeight As Int) As Int
    If miRuntimeHeightDip > 0 Then Return Max(1dip, miRuntimeHeightDip)
    If IsAutoLayoutSpec(msHeight) Then Return ResolveDockHeightDip(msSize)
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msHeight, ResolveDockHeightDip(msSize)))
End Sub

Private Sub ResolveDockHeightDip(SizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 48dip
        Case "sm"
            Return B4XDaisyBoxModel.TailwindSpacingToDip("h-14", 56dip)
        Case "lg"
            Return 72dip
        Case "xl"
            Return 80dip
        Case Else
            Return 64dip
    End Select
End Sub

Private Sub ResolveIndicatorBottomOffsetDip(SizeToken As String) As Int
    ' Returns the gap between content bottom and indicator top
    ' CSS: .dock-active:after bottom values relative to item bottom
    ' xs/sm: bottom: -0.1rem (indicator overlaps content slightly)
    ' md: bottom: 0.2rem (small gap below content)
    ' lg/xl: bottom: 0.4rem (larger gap below content)
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs", "sm"
            Return -2dip
        Case "lg", "xl"
            Return 6dip
        Case Else
            Return 3dip
    End Select
End Sub

Private Sub ResolveLabelTextSize(SizeToken As String) As Float
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs", "sm"
            Return 10
        Case "xl"
            Return 12
        Case Else
            Return 11
    End Select
End Sub

Private Sub ResolveLabelHeightDip(FontSize As Float) As Int
    ' Label height should accommodate the font size with proper line height
    ' CSS line-height for dock-label is approximately 1.2
    Return Max(14dip, Ceil(FontSize * 1.3) * 1dip)
End Sub

Private Sub ResolveIconSizeDip(SizeToken As String) As Int
    ' CSS uses size-[1.2em] which scales with the label font size
    ' Icon size should scale proportionally with the dock size
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 16dip
        Case "sm"
            Return 18dip
        Case "md"
            Return 20dip
        Case "lg"
            Return 22dip
        Case "xl"
            Return 24dip
        Case Else
            Return 20dip
    End Select
End Sub

Private Sub CreateDockItem(Id As String, Text As String, SvgAssetFile As String, VariantName As String, EnabledValue As Boolean, TagValue As Object) As TDockItem
    Dim itm As TDockItem
    If Id = Null Then
        itm.Id = ""
    Else
        itm.Id = Id
    End If
    If Text = Null Then
        itm.Text = ""
    Else
        itm.Text = Text
    End If
    If SvgAssetFile = Null Then
        itm.SvgAsset = ""
    Else
        itm.SvgAsset = SvgAssetFile
    End If
    If VariantName = Null Then
        itm.Variant = "none"
    Else
        itm.Variant = B4XDaisyVariants.NormalizeVariant(VariantName)
    End If
    itm.Enabled = EnabledValue
    itm.Tag = TagValue
    Return itm
End Sub

Private Sub NormalizeLayoutSpec(Value As String, DefaultValue As String) As String
    If Value = Null Then Return DefaultValue
    Dim s As String = Value.Trim.ToLowerCase
    If s.Length = 0 Then Return DefaultValue
    Return s
End Sub

Private Sub IsAutoLayoutSpec(Value As String) As Boolean
    If Value = Null Then Return True
    Dim s As String = Value.Trim.ToLowerCase
    Return s = "auto" Or s = "h-auto" Or s = "w-auto"
End Sub

Private Sub item_Click
    Dim p As Panel = Sender
    Dim idx As Int = p.Tag
    If idx < 0 Then Return
    If idx >= mItems.Size Then Return
    If mbEnabled = False Then Return

    Dim itm As TDockItem = mItems.Get(idx)
    If itm.Enabled = False Then Return

    miActiveIndex = idx
    Base_Resize(mBase.Width, mBase.Height)

    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 1) Then
        CallSubDelayed2(mCallBack, mEventName & "_ItemClick", itm.Id)
    End If
End Sub

Public Sub setSize(Value As String)
    msSize = B4XDaisyVariants.NormalizeSize(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setActiveIndex(Value As Int)
    If Value < -1 Then Value = -1
    miActiveIndex = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActiveIndex As Int
    Return miActiveIndex
End Sub

Public Sub setBackgroundColor(Value As Int)
    mcBackgroundColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setTextColor(Value As Int)
    mcTextColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mcTextColor
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setRounded(Value As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setWidth(Value As String)
    msWidth = NormalizeLayoutSpec(Value, "w-full")
    miRuntimeWidthDip = 0
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(Value As String)
    msHeight = NormalizeLayoutSpec(Value, "auto")
    miRuntimeHeightDip = 0
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mbVisible = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub
