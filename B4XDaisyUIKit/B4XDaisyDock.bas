B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: ItemClick (ItemId As String)

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy dock size token.
#DesignerProperty: Key: BadgeSize, DisplayName: Badge Size, FieldType: String, DefaultValue: auto, List: auto|xs|sm|md|lg|xl, Description: Badge circle size. 'auto' follows the dock Size token; otherwise use an explicit badge size.
#DesignerProperty: Key: ActiveIndex, DisplayName: Active Index, FieldType: Int, DefaultValue: 1, Description: Zero-based active item index. Use -1 for no active item.
#DesignerProperty: Key: ActivePosition, DisplayName: Active Position, FieldType: String, DefaultValue: bottom, List: bottom|top, Description: Active indicator position (bottom or top).
#DesignerProperty: Key: Glass, DisplayName: Glass, FieldType: Boolean, DefaultValue: False, Description: Enable translucent glass background.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Dock background color (0 = theme base-100).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Dock text/icon color (0 = theme base-content).
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: theme|none|sm|rounded|md|lg|xl|2xl|3xl|full, Description: Corner radius style.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind size token or CSS size string.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Tailwind size token or CSS size string. auto follows the dock size token.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enable or disable dock interactions.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide the dock.

#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private msSize As String = "md"
    Private msBadgeSize As String = "auto"
    Private miActiveIndex As Int = 1
    Private msActivePosition As String = "bottom"
    Private mbGlass As Boolean = False
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
    Private mBadgeViews As Map
    Private mItemViews As Map

    Type TDockItem (Id As String, Text As String, SvgAsset As String, Variant As String, Enabled As Boolean, Tag As Object, BadgeValue As String, BadgeVariant As String)
	Private inResize As Boolean = False
End Sub

''' <summary>
''' Initializes the dock component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
    mBadgeViews.Initialize
    mItemViews.Initialize
End Sub

''' <summary>
''' Creates a programmatic dock view.
''' </summary>
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    miRuntimeWidthDip = Max(1dip, iWidth)
    miRuntimeHeightDip = Max(0, iHeight)
    b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, IIf(iHeight > 0, iHeight, ResolveDockHeightDip(msSize))))
    DesignerCreateView(b, Null, BuildRuntimeProps)
    Return mBase
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    If mItems.IsInitialized = False Then mItems.Initialize

    BuildHost
    ApplyDesignerProps(mProps)
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

Private Sub ApplyDesignerProps(mProps As Map)
    msSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", msSize))
    msBadgeSize = NormalizeBadgeSizeProp(B4XDaisyVariants.GetPropString(mProps, "BadgeSize", msBadgeSize))
    miActiveIndex = B4XDaisyVariants.GetPropInt(mProps, "ActiveIndex", miActiveIndex)
    msActivePosition = NormalizeActivePositionProp(B4XDaisyVariants.GetPropString(mProps, "ActivePosition", msActivePosition))
    mbGlass = B4XDaisyVariants.GetPropBool(mProps, "Glass", mbGlass)
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
    mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
    msWidth = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(mProps, "Width", msWidth), "w-full")
    msHeight = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(mProps, "Height", msHeight), "auto")
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Size": msSize, _
        "BadgeSize": msBadgeSize, _
        "ActiveIndex": miActiveIndex, _
        "ActivePosition": msActivePosition, _
        "Glass": mbGlass, _
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
Public Sub AddItem(sId As String, sText As String, sSvgAssetFile As String) As Int
    Return AddItemWithVariant(sId, sText, sSvgAssetFile, "none")
End Sub

''' <summary>
''' Adds an item with a specific DaisyUI variant color.
''' </summary>
Public Sub AddItemWithVariant(sId As String, sText As String, sSvgAssetFile As String, sVariantName As String) As Int
    Dim itm As TDockItem = CreateDockItem(sId, sText, sSvgAssetFile, sVariantName, True, Null)
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
Public Sub SetItemTagByIndex(iIndex As Int, oTagValue As Object)
    If iIndex < 0 Then Return
    If iIndex >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(iIndex)
    itm.Tag = oTagValue
    mItems.Set(iIndex, itm)
End Sub

''' <summary>
''' Sets a custom tag for an item by its unique ID.
''' </summary>
Public Sub SetItemTag(sItemId As String, oTagValue As Object)
    Dim idx As Int = FindItemIndexById(sItemId)
    If idx < 0 Then Return
    SetItemTagByIndex(idx, oTagValue)
End Sub

''' <summary>
''' Enables or disables a specific item by index.
''' </summary>
Public Sub SetItemEnabledByIndex(iIndex As Int, bValue As Boolean)
    If iIndex < 0 Then Return
    If iIndex >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(iIndex)
    itm.Enabled = bValue
    mItems.Set(iIndex, itm)
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Enables or disables a specific item by its unique ID.
''' </summary>
Public Sub SetItemEnabled(sItemId As String, bValue As Boolean)
    Dim idx As Int = FindItemIndexById(sItemId)
    If idx < 0 Then Return
    SetItemEnabledByIndex(idx, bValue)
End Sub

''' <summary>
''' Sets the badge value for an item by index. Pass empty string to hide the badge.
''' </summary>
Public Sub SetItemBadgeValueByIndex(iIndex As Int, sValue As String)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(iIndex)
    Dim oldValue As String = itm.BadgeValue
    Dim capped As String = CapBadgeValue(sValue)
    itm.BadgeValue = capped
    mItems.Set(iIndex, itm)
    
    If mBase.IsInitialized = False Then Return
    If oldValue = capped Then Return
    
    Dim itemPanel As B4XView = FindItemPanelByIndex(iIndex)
    If itemPanel.IsInitialized = False Then Return
    
    Dim existingBadge As B4XView = mBadgeViews.Get(iIndex)
    Dim hasNewBadge As Boolean = (sValue <> Null And sValue.Trim.Length > 0)
    Dim hasOldBadge As Boolean = (existingBadge <> Null And existingBadge.IsInitialized)
    
    If hasOldBadge And hasNewBadge = False Then
        AnimateRemoveBadge(existingBadge, iIndex)
    Else If hasOldBadge = False And hasNewBadge Then
        CreateBadgeView(itemPanel, itm, iIndex, True)
    Else If hasOldBadge And hasNewBadge Then
        AnimateUpdateBadge(existingBadge, itm, iIndex)
    End If
End Sub

''' <summary>
''' Sets the badge value for an item by its unique ID. Pass empty string to hide the badge.
''' </summary>
Public Sub SetItemBadgeValue(sItemId As String, sValue As String)
    Dim idx As Int = FindItemIndexById(sItemId)
    If idx < 0 Then Return
    SetItemBadgeValueByIndex(idx, sValue)
End Sub

''' <summary>
''' Sets the badge color variant for an item by index.
''' </summary>
Public Sub SetItemBadgeColorByIndex(iIndex As Int, sVariantName As String)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(iIndex)
    Dim oldVariant As String = itm.BadgeVariant
    Dim newVariant As String = B4XDaisyVariants.NormalizeVariant(sVariantName)
    itm.BadgeVariant = newVariant
    mItems.Set(iIndex, itm)
    
    If mBase.IsInitialized = False Then Return
    If oldVariant = newVariant Then Return
    
    Dim existingBadge As B4XView = mBadgeViews.Get(iIndex)
    If existingBadge <> Null And existingBadge.IsInitialized Then
        AnimateUpdateBadge(existingBadge, itm, iIndex)
    End If
End Sub

''' <summary>
''' Sets the badge color variant for an item by its unique ID.
''' </summary>
Public Sub SetItemBadgeColor(sItemId As String, sVariantName As String)
    Dim idx As Int = FindItemIndexById(sItemId)
    If idx < 0 Then Return
    SetItemBadgeColorByIndex(idx, sVariantName)
End Sub

''' <summary>
''' Increments the badge numeric value for an item by index by the given amount.
''' </summary>
Public Sub SetItemBadgeIncrementByIndex(iIndex As Int, iAmount As Int)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(iIndex)
    Dim currentVal As Int = ParseBadgeValueAsInt(itm.BadgeValue)
    Dim newVal As String = "" & (currentVal + iAmount)
    SetItemBadgeValueByIndex(iIndex, newVal)
End Sub

''' <summary>
''' Increments the badge numeric value for an item by its unique ID by the given amount.
''' </summary>
Public Sub SetItemBadgeIncrement(sItemId As String, iAmount As Int)
    Dim idx As Int = FindItemIndexById(sItemId)
    If idx < 0 Then Return
    SetItemBadgeIncrementByIndex(idx, iAmount)
End Sub

''' <summary>
''' Decrements the badge numeric value for an item by index by the given amount (minimum 0).
''' </summary>
Public Sub SetItemBadgeDecrementByIndex(iIndex As Int, iAmount As Int)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    Dim itm As TDockItem = mItems.Get(iIndex)
    Dim currentVal As Int = ParseBadgeValueAsInt(itm.BadgeValue)
    Dim newVal As String = "" & Max(0, currentVal - iAmount)
    If newVal = "0" Then newVal = ""
    SetItemBadgeValueByIndex(iIndex, newVal)
End Sub

''' <summary>
''' Decrements the badge numeric value for an item by its unique ID by the given amount (minimum 0).
''' </summary>
Public Sub SetItemBadgeDecrement(sItemId As String, iAmount As Int)
    Dim idx As Int = FindItemIndexById(sItemId)
    If idx < 0 Then Return
    SetItemBadgeDecrementByIndex(idx, iAmount)
End Sub

Private Sub CapBadgeValue(sValue As String) As String
    If sValue = Null Then Return ""
    Dim s As String = sValue.Trim
    If s.Length = 0 Then Return ""
    If IsNumber(s) Then
        Dim n As Int = s
        If n >= 100 Then Return "99+"
    End If
    Return s
End Sub

Private Sub ParseBadgeValueAsInt(sValue As String) As Int
    If sValue = Null Then Return 0
    Dim s As String = sValue.Trim
    If s.Length = 0 Then Return 0
    Dim sb As StringBuilder
    sb.Initialize
    For i = 0 To s.Length - 1
        Dim c As String = s.CharAt(i)
        If IsNumber(c) Then sb.Append(c)
    Next
    If sb.Length = 0 Then Return 0
    Return sb.ToString
End Sub

''' <summary>
''' Finds the index of an item by its unique ID. Returns -1 if not found.
''' </summary>
Private Sub FindItemIndexById(sItemId As String) As Int
    If sItemId = Null Then Return -1
    For i = 0 To mItems.Size - 1
        Dim itm As TDockItem = mItems.Get(i)
        If itm.Id = sItemId Then Return i
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
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        CreateView(Max(1dip, IIf(iWidth > 0, iWidth, vParent.Width)), Max(0, iHeight))
    End If

    miRuntimeWidthDip = Max(0, iWidth)
    miRuntimeHeightDip = Max(0, iHeight)

    Dim targetW As Int = ResolveCurrentWidthDip(IIf(iWidth > 0, iWidth, vParent.Width))
    Dim targetH As Int = ResolveCurrentHeightDip(iHeight)
    vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
    Base_Resize(targetW, targetH)
    Return mBase
End Sub

''' <summary>
''' Returns the underlying B4XView.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
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
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    miRuntimeWidthDip = Max(0, iWidth)
    miRuntimeHeightDip = Max(0, iHeight)
    Dim targetW As Int = ResolveCurrentWidthDip(iWidth)
    Dim targetH As Int = ResolveCurrentHeightDip(iHeight)
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, targetW, targetH)
    Base_Resize(targetW, targetH)
End Sub

Public Sub setLeft(iValue As Int)
    If mBase.IsInitialized = False Then Return
    SetLayoutAnimated(0, iValue, mBase.Top, mBase.Width, mBase.Height)
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Left
End Sub

Public Sub setTop(iValue As Int)
    If mBase.IsInitialized = False Then Return
    SetLayoutAnimated(0, mBase.Left, iValue, mBase.Width, mBase.Height)
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Top
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If pnlSurface.IsInitialized = False Then Return

    If inResize Then Return
    inResize = True
    Dim targetW As Int = Max(1dip, ResolveCurrentWidthDip(dWidth))
    Dim targetH As Int = Max(1dip, ResolveCurrentHeightDip(dHeight))

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
    inResize = False
End Sub

Private Sub ApplySurfaceStyle
    ResolveThemeColors
    Dim radiusDip As Float = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    If mbGlass Then
        B4XDaisyVariants.ApplyGlassStyle(pnlSurface, radiusDip, "glass-md")
        pnlTopBorder.Visible = False
    Else
        pnlSurface.SetColorAndBorder(ResolveEffectiveBackgroundColor, 0, 0, radiusDip)
        B4XDaisyVariants.ApplyElevation(pnlSurface, msShadow)
        ' Hide top border when dock has significant rounding to avoid visual mismatch
        If radiusDip > 4dip Then
            pnlTopBorder.Visible = False
        Else
            pnlTopBorder.Visible = True
            pnlTopBorder.Color = mcBorderColor
        End If
    End If
End Sub

Private Sub RebuildItems(iWidth As Int, iHeight As Int)
    mBadgeViews.Clear
    mItemViews.Clear
    pnlSurface.RemoveAllViews

    Dim box As Map = BuildDockBoxModel
    Dim hostRect As B4XRect
    hostRect.Initialize(0, 0, iWidth, iHeight)
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

Private Sub CreateItemView(iIndex As Int, Item As TDockItem, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    Dim pItem As Panel
    pItem.Initialize("item")
    Dim itemPanel As B4XView = pItem
    itemPanel.Color = xui.Color_Transparent
    itemPanel.Tag = iIndex
    pnlSurface.AddView(itemPanel, iLeft, iTop, iWidth, iHeight)
    B4XDaisyVariants.DisableClipping(itemPanel)
    mItemViews.Put(iIndex, itemPanel)

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
    Dim cursorY As Int = Max(0, Round((iHeight - totalContentHeight) / 2))
    If iIndex = miActiveIndex Then
        Select Case msActivePosition.ToLowerCase
            Case "top"
                cursorY = cursorY + B4XDaisyBoxModel.TailwindSpacingToDip("mt-1.5", 6dip)
            Case "bottom"
                cursorY = Max(0, cursorY - B4XDaisyBoxModel.TailwindSpacingToDip("mb-1", 3dip))
        End Select
    End If

    Dim contentTopY As Int = cursorY
    Dim itemColor As Int = ResolveItemColor(Item.Variant, Item.Enabled, iIndex = miActiveIndex)
    Dim contentBottomY As Int = cursorY + totalContentHeight

    If showIcon Then
        Dim iconComp As B4XDaisySvgIcon
        iconComp.Initialize(Me, "dockicon")
        Dim iconLeft As Int = Round((iWidth - iconSize) / 2)
        Dim iconView As B4XView = iconComp.AddToParent(itemPanel, iconLeft, cursorY, iconSize, iconSize)
        iconView.Tag = iconComp
        iconComp.SetClickable(False)
        iconComp.Color = itemColor
        iconComp.SvgAsset = Item.SvgAsset
        cursorY = iconView.Top + iconView.Height
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
        xlbl.Tag = "label"
        itemPanel.AddView(xlbl, 0, cursorY, iWidth, labelHeight)
    End If

    AddIndicatorView(itemPanel, iWidth, iHeight, contentTopY, contentBottomY, iIndex = miActiveIndex, itemColor)
    
    If Item.BadgeValue <> Null Then
        If Item.BadgeValue.Trim.Length > 0 Then
            CreateBadgeView(itemPanel, Item, iIndex, False)
        End If
    End If
End Sub

Private Sub CreateBadgeView(vItemPanel As B4XView, Item As TDockItem, iIndex As Int, bAnimated As Boolean) As B4XView
    Dim badgeToken As String = ResolveBadgeSizeToken
    Dim badgeTextSize As Float = ResolveBadgeTextSize(badgeToken)
    ' Perfect circle: the diameter grows to fit the text, but width always equals
    ' height and the corner radius is half the diameter, so the badge is always
    ' a circle (even for 99+ or multi-digit values that previously became ovals).
    Dim badgeW As Int = MeasureBadgeWidth(Item.BadgeValue, badgeTextSize, ResolveBadgeHeight(badgeToken))
    Dim badgeH As Int = badgeW
    Dim badgeColors() As Int = ResolveBadgeColors(Item.BadgeVariant)
    
    Dim badgeLbl As Label
    badgeLbl.Initialize("")
    badgeLbl.SingleLine = True
    badgeLbl.Text = Item.BadgeValue
    badgeLbl.TextSize = badgeTextSize
    
    Dim xbadge As B4XView = badgeLbl
    xbadge.Color = xui.Color_Transparent
    xbadge.TextColor = badgeColors(1)
    xbadge.SetTextAlignment("CENTER", "CENTER")
    xbadge.SetColorAndBorder(badgeColors(0), 0, 0, badgeH / 2)
    
    Dim showIcon As Boolean = False
    Dim showLabel As Boolean = False
    If Item.SvgAsset <> Null Then showIcon = Item.SvgAsset.Trim.Length > 0
    If Item.Text <> Null Then showLabel = Item.Text.Trim.Length > 0
    
    Dim labelFontSize As Float = ResolveLabelTextSize(msSize)
    Dim labelHeight As Int = ResolveLabelHeightDip(labelFontSize)
    Dim iconSize As Int = ResolveIconSizeDip(msSize)
    Dim gap As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("gap-px", 1dip))
    
    Dim totalContentHeight As Int = 0
    If showIcon Then totalContentHeight = totalContentHeight + iconSize
    If showLabel Then
        If totalContentHeight > 0 Then totalContentHeight = totalContentHeight + gap
        totalContentHeight = totalContentHeight + labelHeight
    End If
    If totalContentHeight = 0 Then totalContentHeight = iconSize
    Dim cursorY As Int = Max(0, Round((vItemPanel.Height - totalContentHeight) / 2))
    
    Dim targetLeft As Int
    Dim targetTop As Int
    
    If showIcon Then
        Dim iconLeft As Int = Round((vItemPanel.Width - iconSize) / 2)
        targetLeft = iconLeft + iconSize - (badgeW / 2)
        targetTop = cursorY - (badgeH / 2)
    Else If showLabel Then
        Dim labelW As Int = MeasureLabelWidth(Item.Text, labelFontSize)
        Dim labelLeft As Int = (vItemPanel.Width - labelW) / 2
        targetLeft = labelLeft + labelW - (badgeW / 2)
        targetTop = cursorY - (badgeH / 2)
    Else
        targetLeft = vItemPanel.Width - badgeW - 4dip
        targetTop = 4dip
    End If
    
    If bAnimated Then
        Dim cx As Float = targetLeft + (badgeW / 2)
        Dim cy As Float = targetTop + (badgeH / 2)
        vItemPanel.AddView(xbadge, cx - 1dip, cy - 1dip, 2dip, 2dip)
        xbadge.SetLayoutAnimated(300, targetLeft, targetTop, badgeW, badgeH)
    Else
        vItemPanel.AddView(xbadge, targetLeft, targetTop, badgeW, badgeH)
    End If
    
    mBadgeViews.Put(iIndex, xbadge)
    Return xbadge
End Sub

Private Sub AnimateRemoveBadge(vBadge As B4XView, iIndex As Int)
    If vBadge.IsInitialized = False Then Return
    mBadgeViews.Remove(iIndex)
    
    Dim cx As Float = vBadge.Left + (vBadge.Width / 2)
    Dim cy As Float = vBadge.Top + (vBadge.Height / 2)
    
    vBadge.SetLayoutAnimated(300, cx - 1dip, cy - 1dip, 2dip, 2dip)
    Sleep(300)
    If vBadge.IsInitialized And vBadge.Parent <> Null Then
        vBadge.RemoveViewFromParent
    End If
End Sub

Private Sub AnimateUpdateBadge(vBadge As B4XView, Item As TDockItem, iIndex As Int)
    Dim badgeToken As String = ResolveBadgeSizeToken
    Dim badgeTextSize As Float = ResolveBadgeTextSize(badgeToken)
    Dim badgeW As Int = MeasureBadgeWidth(Item.BadgeValue, badgeTextSize, ResolveBadgeHeight(badgeToken))
    Dim badgeH As Int = badgeW
    
    Dim showIcon As Boolean = False
    Dim showLabel As Boolean = False
    If Item.SvgAsset <> Null Then showIcon = Item.SvgAsset.Trim.Length > 0
    If Item.Text <> Null Then showLabel = Item.Text.Trim.Length > 0
    
    Dim labelFontSize As Float = ResolveLabelTextSize(msSize)
    Dim labelHeight As Int = ResolveLabelHeightDip(labelFontSize)
    Dim iconSize As Int = ResolveIconSizeDip(msSize)
    Dim gap As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("gap-px", 1dip))
    
    Dim itemPanel As B4XView = FindItemPanelByIndex(iIndex)
    If itemPanel.IsInitialized = False Then Return
    Dim totalContentHeight As Int = 0
    If showIcon Then totalContentHeight = totalContentHeight + iconSize
    If showLabel Then
        If totalContentHeight > 0 Then totalContentHeight = totalContentHeight + gap
        totalContentHeight = totalContentHeight + labelHeight
    End If
    If totalContentHeight = 0 Then totalContentHeight = iconSize
    Dim cursorY As Int = Max(0, Round((itemPanel.Height - totalContentHeight) / 2))
    
    Dim targetLeft As Int
    Dim targetTop As Int
    
    If showIcon Then
        Dim iconLeft As Int = Round((itemPanel.Width - iconSize) / 2)
        targetLeft = iconLeft + iconSize - (badgeW / 2)
        targetTop = cursorY - (badgeH / 2)
    Else If showLabel Then
        Dim labelW As Int = MeasureLabelWidth(Item.Text, labelFontSize)
        Dim labelLeft As Int = (itemPanel.Width - labelW) / 2
        targetLeft = labelLeft + labelW - (badgeW / 2)
        targetTop = cursorY - (badgeH / 2)
    Else
        targetLeft = itemPanel.Width - badgeW - 4dip
        targetTop = 4dip
    End If
    
    Dim badgeColors() As Int = ResolveBadgeColors(Item.BadgeVariant)
    
    ' Pop Bounce Animation
    Dim targetW_pop As Int = badgeW + 4dip
    Dim targetH_pop As Int = badgeH + 4dip
    Dim targetLeft_pop As Int = targetLeft - 2dip
    Dim targetTop_pop As Int = targetTop - 2dip
    
    vBadge.TextColor = badgeColors(1)
    vBadge.SetColorAndBorder(badgeColors(0), 0, 0, targetH_pop / 2)
    vBadge.Text = Item.BadgeValue
    
    vBadge.SetLayoutAnimated(150, targetLeft_pop, targetTop_pop, targetW_pop, targetH_pop)
    Sleep(150)
    If vBadge.IsInitialized And vBadge.Parent <> Null Then
        vBadge.SetColorAndBorder(badgeColors(0), 0, 0, badgeH / 2)
        vBadge.SetLayoutAnimated(150, targetLeft, targetTop, badgeW, badgeH)
    End If
End Sub

Private Sub FindItemPanelByIndex(iIndex As Int) As B4XView
    ' Item panels are tracked in mItemViews so we never accidentally match a
    ' child view (e.g. the text label, which also carries an Int tag).
    If mItemViews.IsInitialized Then
        Dim v As Object = mItemViews.Get(iIndex)
        If v <> Null Then
            Dim panel As B4XView = v
            If panel.IsInitialized Then Return panel
        End If
    End If
    Dim empty As B4XView
    Return empty
End Sub

Private Sub AddIndicatorView(vParent As B4XView, iWidth As Int, iHeight As Int, iContentTopY As Int, iContentBottomY As Int, bIsActive As Boolean, iItemColor As Int)
    Dim pIndicator As Panel
    pIndicator.Initialize("")
    Dim indicator As B4XView = pIndicator
    indicator.Tag = "indicator"

    Dim indicatorWidth As Int
    If bIsActive Then
        indicatorWidth = B4XDaisyBoxModel.TailwindSpacingToDip("w-10", 40dip)
    Else
        indicatorWidth = B4XDaisyBoxModel.TailwindSpacingToDip("w-6", 24dip)
    End If
    Dim indicatorHeight As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("h-1", 4dip))
    Dim indicatorGap As Int = ResolveIndicatorBottomOffsetDip(msSize)
    Dim indicatorLeft As Int = Round((iWidth - indicatorWidth) / 2)
    Dim indicatorTop As Int
    If msActivePosition.ToLowerCase = "top" Then
        indicatorTop = Max(1dip, iContentTopY - indicatorHeight - 8dip)
    Else
        indicatorTop = iContentBottomY + indicatorGap
    End If

    If bIsActive Then
        indicator.SetColorAndBorder(iItemColor, 0, 0, B4XDaisyVariants.ResolveRoundedDip("rounded-full", 999dip))
    Else
        indicator.SetColorAndBorder(xui.Color_Transparent, 0, 0, B4XDaisyVariants.ResolveRoundedDip("rounded-full", 999dip))
    End If
    vParent.AddView(indicator, indicatorLeft, indicatorTop, indicatorWidth, indicatorHeight)
End Sub

Private Sub ResolveEffectiveTextColor As Int
    If mcTextColor <> 0 Then Return mcTextColor
    Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
End Sub

Private Sub ResolveEffectiveBackgroundColor As Int
    If mcBackgroundColor <> 0 Then Return mcBackgroundColor
    Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
End Sub

Private Sub ResolveThemeColors
    Dim effectiveText As Int = ResolveEffectiveTextColor
    mcBorderColor = B4XDaisyVariants.AlphaColor(effectiveText, 0.05)
End Sub

Private Sub ResolveItemColor(sItemVariant As String, bItemEnabled As Boolean, bIsActive As Boolean) As Int
    Dim effectiveText As Int = ResolveEffectiveTextColor
    
    ' If item has a specific variant, use the actual variant color (e.g., --color-primary)
    Dim v As String = B4XDaisyVariants.NormalizeVariant(sItemVariant)
    If v <> "none" Then
        ' Use the direct variant color token (e.g., --color-primary, --color-warning)
        Dim tokenName As String = "--color-" & v
        Dim variantColor As Int = B4XDaisyVariants.GetTokenColor(tokenName, effectiveText)
        If bItemEnabled = False Or mbEnabled = False Then
            Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", effectiveText)
            Return B4XDaisyVariants.AlphaColor(baseContent, 0.2)
        End If
        Return variantColor
    End If
    
    If mbEnabled = False Or bItemEnabled = False Then
        Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", effectiveText)
        Return B4XDaisyVariants.AlphaColor(baseContent, 0.2)
    End If
    If bIsActive Then
        Return B4XDaisyVariants.GetTokenColor("--color-primary", effectiveText)
    End If
    Return effectiveText
End Sub

Private Sub ResolvePreferredItemWidth(Item As TDockItem, fLabelFontSize As Float) As Int
    Dim preferred As Int = Max(56dip, ResolveIconSizeDip(msSize) + 20dip)
    If Item.Text <> Null Then
        If Item.Text.Trim.Length > 0 Then
            preferred = Max(preferred, MeasureLabelWidth(Item.Text, fLabelFontSize) + 12dip)
        End If
    End If
    Return Min(B4XDaisyBoxModel.TailwindSpacingToDip("max-w-32", 128dip), preferred)
End Sub

Private Sub MeasureLabelWidth(sText As String, fFontSize As Float) As Int
    If sText = Null Then Return 0
    If sText.Trim.Length = 0 Then Return 0
    If pnlMeasure.IsInitialized = False Then
        Return Max(24dip, (sText.Length * fFontSize * 0.7) + 8dip)
    End If
    Try
        Dim r As B4XRect = cvsMeasure.MeasureText(sText, xui.CreateDefaultFont(fFontSize))
        Return Max(24dip, Ceil(r.Width) + 8dip)
    Catch
        Return Max(24dip, (sText.Length * fFontSize * 0.7) + 8dip)
    End Try
End Sub

Private Sub BuildDockBoxModel As Map
    Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtility(box, "p-2", False)
    Return box
End Sub

Private Sub ResolveCurrentWidthDip(iCurrentWidth As Int) As Int
    If miRuntimeWidthDip > 0 Then Return Max(1dip, miRuntimeWidthDip)

    Dim fallback As Int = Max(1dip, iCurrentWidth)
    If mBase.IsInitialized Then
        Try
            Dim parent As B4XView = mBase.Parent
            If parent.IsInitialized Then fallback = Max(1dip, parent.Width)
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyDock.ResolveCurrentWidthDip: " & LastException.Message)
        End Try
    End If
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msWidth, fallback))
End Sub

Private Sub ResolveCurrentHeightDip(iCurrentHeight As Int) As Int
    If miRuntimeHeightDip > 0 Then Return Max(1dip, miRuntimeHeightDip)
    If IsAutoLayoutSpec(msHeight) Then Return ResolveDockHeightDip(msSize)
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msHeight, ResolveDockHeightDip(msSize)))
End Sub

Private Sub ResolveDockHeightDip(sSizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
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

Private Sub ResolveIndicatorBottomOffsetDip(sSizeToken As String) As Int
    ' Returns the gap between content boundary and indicator line
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
        Case "xs", "sm"
            Return 2dip
        Case "lg", "xl"
            Return 4dip
        Case Else
            Return 3dip
    End Select
End Sub

Private Sub ResolveLabelTextSize(sSizeToken As String) As Float
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
        Case "xs", "sm"
            Return 10
        Case "xl"
            Return 12
        Case Else
            Return 11
    End Select
End Sub

Private Sub ResolveLabelHeightDip(fFontSize As Float) As Int
    ' Label height should accommodate the font size with proper line height
    ' CSS line-height for dock-label is approximately 1.2
    Return Max(14dip, Ceil(fFontSize * 1.3) * 1dip)
End Sub

Private Sub ResolveIconSizeDip(sSizeToken As String) As Int
    ' CSS uses size-[1.2em] which scales with the label font size
    ' Icon size should scale proportionally with the dock size
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
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

''' Normalizes the BadgeSize designer property, allowing the special 'auto' token
''' (which means "follow the dock Size") alongside explicit size tokens.
Private Sub NormalizeBadgeSizeProp(sValue As String) As String
    If sValue = Null Then Return "auto"
    Dim s As String = sValue.ToLowerCase.Trim
    If s = "auto" Or s.Length = 0 Then Return "auto"
    Return B4XDaisyVariants.NormalizeSize(s)
End Sub

''' Returns the effective size token used to size badges. When BadgeSize is 'auto'
''' the badge scales proportionally with the dock Size; otherwise the explicit
''' BadgeSize token is used so badges can be sized independently of the dock.
Private Sub ResolveBadgeSizeToken As String
    If msBadgeSize <> Null And msBadgeSize.Trim.Length > 0 And msBadgeSize.ToLowerCase <> "auto" Then
        Return B4XDaisyVariants.NormalizeSize(msBadgeSize)
    End If
    Return msSize
End Sub

Private Sub ResolveBadgeHeight(sSizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
        Case "xs"
            Return 12dip
        Case "sm"
            Return 14dip
        Case "lg"
            Return 18dip
        Case "xl"
            Return 20dip
        Case Else
            Return 16dip
    End Select
End Sub

Private Sub ResolveBadgeTextSize(sSizeToken As String) As Float
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
        Case "xs", "sm"
            Return 8
        Case "lg", "xl"
            Return 10
        Case Else
            Return 9
    End Select
End Sub

Private Sub MeasureBadgeWidth(sText As String, fFontSize As Float, iBadgeH As Int) As Int
    If sText = Null Or sText.Trim.Length = 0 Then Return iBadgeH
    Dim textW As Int = 0
    If pnlMeasure.IsInitialized Then
        Try
            Dim r As B4XRect = cvsMeasure.MeasureText(sText, xui.CreateDefaultFont(fFontSize))
            textW = Ceil(r.Width)
        Catch
            textW = sText.Length * fFontSize * 0.65
        End Try
    Else
        textW = sText.Length * fFontSize * 0.65
    End If
    Return Max(iBadgeH, textW + 8dip)
End Sub

Private Sub ResolveBadgeColors(sBadgeVariant As String) As Int()
    Dim v As String = B4XDaisyVariants.NormalizeVariant(sBadgeVariant)
    If v = "none" Then v = "error" ' Default to error variant (red)
    
    Dim fallbackBG As Int = xui.Color_Red
    Dim fallbackText As Int = xui.Color_White
    
    Dim bgColor As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, v, fallbackBG)
    Dim textColor As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, v, fallbackText)
    
    Return Array As Int(bgColor, textColor)
End Sub

Private Sub CreateDockItem(sId As String, sText As String, sSvgAssetFile As String, sVariantName As String, bEnabledValue As Boolean, oTagValue As Object) As TDockItem
    Dim itm As TDockItem
    If sId = Null Then
        itm.Id = ""
    Else
        itm.Id = sId
    End If
    If sText = Null Then
        itm.Text = ""
    Else
        itm.Text = sText
    End If
    If sSvgAssetFile = Null Then
        itm.SvgAsset = ""
    Else
        itm.SvgAsset = sSvgAssetFile
    End If
    If sVariantName = Null Then
        itm.Variant = "none"
    Else
        itm.Variant = B4XDaisyVariants.NormalizeVariant(sVariantName)
    End If
    itm.Enabled = bEnabledValue
    itm.Tag = oTagValue
    itm.BadgeValue = ""
    itm.BadgeVariant = "none"
    Return itm
End Sub

Private Sub NormalizeLayoutSpec(sValue As String, sDefaultValue As String) As String
    If sValue = Null Then Return sDefaultValue
    Dim s As String = sValue.Trim.ToLowerCase
    If s.Length = 0 Then Return sDefaultValue
    Return s
End Sub

Private Sub IsAutoLayoutSpec(sValue As String) As Boolean
    If sValue = Null Then Return True
    Dim s As String = sValue.Trim.ToLowerCase
    Return s = "auto" Or s = "h-auto" Or s = "w-auto"
End Sub

Private Sub UpdateActiveSelection
    If mItemViews.IsInitialized = False Or mItems.IsInitialized = False Then Return
    If mItemViews.Size <> mItems.Size Then
        Refresh
        Return
    End If

    Dim labelFontSize As Float = ResolveLabelTextSize(msSize)
    Dim labelHeight As Int = ResolveLabelHeightDip(labelFontSize)
    Dim iconSize As Int = ResolveIconSizeDip(msSize)
    Dim gap As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("gap-px", 1dip))
    Dim indicatorHeight As Int = Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip("h-1", 4dip))
    Dim indicatorGap As Int = ResolveIndicatorBottomOffsetDip(msSize)

    For i = 0 To mItems.Size - 1
        Dim itemPanel As B4XView = FindItemPanelByIndex(i)
        If itemPanel.IsInitialized Then
            Dim itm As TDockItem = mItems.Get(i)
            Dim isActive As Boolean = (i = miActiveIndex)
            Dim itemColor As Int = ResolveItemColor(itm.Variant, itm.Enabled, isActive)

            Dim showIcon As Boolean = False
            Dim showLabel As Boolean = False
            If itm.SvgAsset <> Null Then showIcon = itm.SvgAsset.Trim.Length > 0
            If itm.Text <> Null Then showLabel = itm.Text.Trim.Length > 0

            Dim totalContentHeight As Int = 0
            If showIcon Then totalContentHeight = totalContentHeight + iconSize
            If showLabel Then
                If totalContentHeight > 0 Then totalContentHeight = totalContentHeight + gap
                totalContentHeight = totalContentHeight + labelHeight
            End If

            Dim cursorY As Int = Max(0, Round((itemPanel.Height - totalContentHeight) / 2))
            If isActive Then
                Select Case msActivePosition.ToLowerCase
                    Case "top"
                        cursorY = cursorY + B4XDaisyBoxModel.TailwindSpacingToDip("mt-1.5", 6dip)
                    Case "bottom"
                        cursorY = Max(0, cursorY - B4XDaisyBoxModel.TailwindSpacingToDip("mb-1", 3dip))
                End Select
            End If

            Dim contentTopY As Int = cursorY
            Dim contentBottomY As Int = cursorY + totalContentHeight

            For j = 0 To itemPanel.NumberOfViews - 1
                Dim v As B4XView = itemPanel.GetView(j)
                If v.Tag <> Null Then
                    If v.Tag = "indicator" Then
                        Dim indicatorWidth As Int
                        If isActive Then
                            indicatorWidth = B4XDaisyBoxModel.TailwindSpacingToDip("w-10", 40dip)
                            v.SetColorAndBorder(itemColor, 0, 0, B4XDaisyVariants.ResolveRoundedDip("rounded-full", 999dip))
                        Else
                            indicatorWidth = B4XDaisyBoxModel.TailwindSpacingToDip("w-6", 24dip)
                            v.SetColorAndBorder(xui.Color_Transparent, 0, 0, B4XDaisyVariants.ResolveRoundedDip("rounded-full", 999dip))
                        End If
                        Dim indicatorLeft As Int = Round((itemPanel.Width - indicatorWidth) / 2)
                        Dim indicatorTop As Int
                        If msActivePosition.ToLowerCase = "top" Then
                            indicatorTop = Max(1dip, contentTopY - indicatorHeight - 8dip)
                        Else
                            indicatorTop = contentBottomY + indicatorGap
                        End If
                        v.SetLayoutAnimated(100, indicatorLeft, indicatorTop, indicatorWidth, indicatorHeight)
                    Else If v.Tag = "label" Then
                        v.TextColor = itemColor
                        Dim lblY As Int = contentTopY
                        If showIcon Then lblY = contentTopY + iconSize + gap
                        v.SetLayoutAnimated(100, 0, lblY, itemPanel.Width, labelHeight)
                    Else If v.Tag Is B4XDaisySvgIcon Then
                        Dim svgIcon As B4XDaisySvgIcon = v.Tag
                        svgIcon.Color = itemColor
                        Dim iconLeft As Int = Round((itemPanel.Width - iconSize) / 2)
                        v.SetLayoutAnimated(100, iconLeft, contentTopY, iconSize, iconSize)
                    Else If v.Tag = "icon" Then
                        Dim iconLeft As Int = Round((itemPanel.Width - iconSize) / 2)
                        v.SetLayoutAnimated(100, iconLeft, contentTopY, iconSize, iconSize)
                    End If
                End If
            Next
        End If
    Next
End Sub

Private Sub item_Click
    Dim p As Panel = Sender
    Dim idx As Int = p.Tag
    If idx < 0 Then Return
    If idx >= mItems.Size Then Return
    If mbEnabled = False Then Return

    Dim itm As TDockItem = mItems.Get(idx)
    If itm.Enabled = False Then Return

    If miActiveIndex <> idx Then
        miActiveIndex = idx
        UpdateActiveSelection
    End If

    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 1) Then
        CallSubDelayed2(mCallBack, mEventName & "_ItemClick", itm.Id)
    End If
End Sub

Public Sub setSize(sValue As String)
    msSize = B4XDaisyVariants.NormalizeSize(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setBadgeSize(sValue As String)
    msBadgeSize = NormalizeBadgeSizeProp(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBadgeSize As String
    Return msBadgeSize
End Sub

Public Sub setActiveIndex(iValue As Int)
    If iValue < -1 Then iValue = -1
    If miActiveIndex = iValue Then Return
    miActiveIndex = iValue
    If mBase.IsInitialized = False Then Return
    UpdateActiveSelection
End Sub

Public Sub getActiveIndex As Int
    Return miActiveIndex
End Sub

Public Sub setActivePosition(sValue As String)
    msActivePosition = NormalizeActivePositionProp(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActivePosition As String
    Return msActivePosition
End Sub

Public Sub setGlass(bValue As Boolean)
    mbGlass = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getGlass As Boolean
    Return mbGlass
End Sub

Private Sub NormalizeActivePositionProp(sValue As String) As String
    If sValue = Null Then Return "bottom"
    Dim s As String = sValue.ToLowerCase.Trim
    If s = "top" Then Return "top"
    Return "bottom"
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mcBackgroundColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
    mcTextColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mcTextColor
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setRounded(sValue As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setWidth(sValue As String)
    msWidth = NormalizeLayoutSpec(sValue, "w-full")
    miRuntimeWidthDip = 0
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(sValue As String)
    msHeight = NormalizeLayoutSpec(sValue, "auto")
    miRuntimeHeightDip = 0
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
