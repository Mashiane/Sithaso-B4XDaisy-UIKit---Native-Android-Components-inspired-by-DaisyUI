B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

#Event: Click (Tag As Object)
#Event: ItemClick (Tag As Object, Text As String)
#Event: SubmenuToggle (Tag As Object, Open As Boolean)

#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables menu interactions.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the menu.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind size token or CSS size used as preferred width.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto, Description: Tailwind size token, CSS size, or h-auto.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-2, Description: Tailwind padding utilities for the menu surface.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind margin utilities for the menu container.
#DesignerProperty: Key: Dividers, DisplayName: Dividers, FieldType: Boolean, DefaultValue: True, Description: Adds automatic dividers between clickable menu items.
#DesignerProperty: Key: DividerGap, DisplayName: Divider Gap, FieldType: String, DefaultValue: 1, Description: Gap around automatic dividers using Tailwind spacing token or CSS size.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy menu size token.
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: vertical, List: vertical|horizontal, Description: Top-level menu layout direction.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius mode.
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Uses theme rounded-box radius when Rounded=theme.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
#DesignerProperty: Key: BringToFront, DisplayName: Bring To Front, FieldType: Boolean, DefaultValue: True, Description: Brings the full menu view above siblings after layout.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional surface background override.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional menu text color override.
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: Color, DefaultValue: 0x00000000, Description: Active menu color. Used as border or background based on ActiveBorder.
#DesignerProperty: Key: ActiveTextColor, DisplayName: Active Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Active item text color when ActiveBorder is False.
#DesignerProperty: Key: ActiveBorder, DisplayName: Active Border, FieldType: Boolean, DefaultValue: False, Description: Shows a left border for the active item instead of filling the item background.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize height to fit menu items.

Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mScrollHost As B4XView
    Private Surface As B4XView
    Private mScrollView As B4XView
    Private mVScrollView As ScrollView
    Private mHScrollView As HorizontalScrollView
    Private msScrollMode As String = "none"
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private mEnabled As Boolean = True
    Private mVisible As Boolean = True
    Private mWidth As Float = 0
    Private mWidthExplicit As Boolean = False
    Private mWidthFull As Boolean = True
    Private mHeight As Float = 0
    Private mHeightExplicit As Boolean = False
    Private mPadding As String = "p-2"
    Private mMargin As String = ""
    Private mDividers As Boolean = True
    Private mDividerGap As String = "1"
    Private mSize As String = "md"
    Private mOrientation As String = "vertical"
    Private mRounded As String = "theme"
    Private mRoundedBox As Boolean = True
    Private mShadow As String = "none"
    Private mBringToFront As Boolean = True
    Private mBackgroundColor As Int = 0
    Private mTextColor As Int = 0
    Private mActiveColor As Int = 0
    Private mActiveTextColor As Int = 0
    Private mActiveBorder As Boolean = False
    Private mDebugDividerBorders As Boolean = False
    Private mbAutoResize As Boolean = True

    Private mItems As List
    Private mLevel As Int = 0
    Private mbPopup As Boolean = False
    Private mParentMenu As B4XDaisyMenu
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mItems.Initialize
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim p As Panel
    p.Initialize("")
    mScrollHost = p
    mScrollHost.Color = xui.Color_Transparent
    mBase.AddView(mScrollHost, 0, 0, mBase.Width, mBase.Height)

    Dim pSurface As Panel
    pSurface.Initialize("")
    Surface = pSurface
    Surface.Color = xui.Color_Transparent

    ApplyDesignerProps(Props)
    Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    Dim widthSpec As String = B4XDaisyVariants.GetPropString(Props, "Width", "w-full").ToLowerCase.Trim
    If widthSpec = "" Or widthSpec = "w-full" Or widthSpec = "full" Then
        mWidth = 0
        mWidthExplicit = False
        mWidthFull = True
    Else
        mWidth = Max(72dip, B4XDaisyVariants.GetPropSizeDip(Props, "Width", "w-56"))
        mWidthExplicit = True
        mWidthFull = False
    End If
    Dim heightSpec As String = B4XDaisyVariants.GetPropString(Props, "Height", "h-auto").ToLowerCase.Trim
    If heightSpec = "" Or heightSpec = "h-auto" Or heightSpec = "auto" Then
        mHeightExplicit = False
        mHeight = 0
    Else
        mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(Props, "Height", "h-10"))
        mHeightExplicit = True
    End If
    mPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "p-2")
    mMargin = B4XDaisyVariants.GetPropString(Props, "Margin", "")
    mDividers = B4XDaisyVariants.GetPropBool(Props, "Dividers", True)
    mDividerGap = B4XDaisyVariants.GetPropString(Props, "DividerGap", "1")
    mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", "md"))
    mOrientation = B4XDaisyVariants.NormalizeOrientation(B4XDaisyVariants.GetPropString(Props, "Orientation", "vertical"))
    mRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
    mRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", True)
    mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    mBringToFront = B4XDaisyVariants.GetPropBool(Props, "BringToFront", True)
    mBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", 0)
    mTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", 0)
    mActiveColor = B4XDaisyVariants.GetPropColor(Props, "ActiveColor", 0)
    mActiveTextColor = B4XDaisyVariants.GetPropColor(Props, "ActiveTextColor", 0)
    mActiveBorder = B4XDaisyVariants.GetPropBool(Props, "ActiveBorder", False)
    mbAutoResize = B4XDaisyVariants.GetPropBool(Props, "AutoResize", True)
    If mbAutoResize Then mHeightExplicit = False
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        Dim createW As Int = Width
        If createW <= 0 Then
            If UsesFullWidth And Parent.IsInitialized Then
                createW = Max(1dip, Parent.Width)
            Else
                createW = Max(1dip, GetPreferredWidth)
            End If
        End If
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, createW), Max(1dip, Height))
        Dim dummy As Label
        DesignerCreateView(b, dummy, BuildRuntimeProps(createW, Height))
    End If
    Dim targetH As Int = Height
    If targetH <= 0 Then
        If mHeightExplicit Then
            targetH = Max(1dip, mHeight)
        Else
            targetH = GetPreferredHeight
        End If
    End If
    Dim targetW As Int = Width
    If targetW <= 0 Then
        If UsesFullWidth And Parent.IsInitialized Then
            targetW = Max(1dip, Parent.Width)
        Else If mWidthExplicit Then
            targetW = Max(1dip, mWidth)
        Else
            targetW = Max(1dip, GetPreferredWidth)
        End If
    End If
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    Parent.AddView(mBase, Left, Top, Max(1dip, targetW), Max(1dip, targetH))
    Base_Resize(Max(1dip, targetW), Max(1dip, targetH))
    Refresh
    If mBringToFront Then mBase.BringToFront
    Return mBase
End Sub

Private Sub BuildRuntimeProps(Width As Int, Height As Int) As Map
    Dim props As Map
    props.Initialize
    props.Put("Enabled", mEnabled)
    props.Put("Visible", mVisible)
    If UsesFullWidth Then
        props.Put("Width", "w-full")
    Else
        props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(Max(1dip, Width)))
    End If
    If mHeightExplicit Then
        props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(Max(1dip, Height)))
    Else
    props.Put("Height", "h-auto")
    End If
    props.Put("Padding", mPadding)
    props.Put("Margin", mMargin)
    props.Put("Dividers", mDividers)
    props.Put("DividerGap", mDividerGap)
    props.Put("Size", mSize)
    props.Put("Orientation", mOrientation)
    props.Put("Rounded", mRounded)
    props.Put("RoundedBox", mRoundedBox)
    props.Put("Shadow", mShadow)
    props.Put("BringToFront", mBringToFront)
    props.Put("BackgroundColor", mBackgroundColor)
    props.Put("TextColor", mTextColor)
    props.Put("ActiveColor", mActiveColor)
    props.Put("ActiveTextColor", mActiveTextColor)
    props.Put("ActiveBorder", mActiveBorder)
    props.Put("DebugDividerBorders", mDebugDividerBorders)
    props.Put("AutoResize", mbAutoResize)
    Return props
End Sub

Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    EnsureHostStructure
    DetachRenderedSubmenus
    Surface.RemoveAllViews
    LayoutHosts(mBase.Width, mBase.Height)
    mBase.Visible = mVisible
    ApplySurfaceStyle
    RenderMenu
    UpdateScrollContentSize
    If mBringToFront Then mBase.BringToFront
End Sub

Private Sub ApplySurfaceStyle
    If mBase.IsInitialized = False Then Return
    Dim bg As Int = ResolveMenuBackgroundColor
    Dim radius As Float = ResolveCornerRadius
    If mLevel = 0 Or mbPopup Then
        mBase.SetColorAndBorder(bg, 0, xui.Color_Transparent, radius)
        Surface.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
        B4XDaisyVariants.ApplyElevation(mBase, mShadow)
        B4XDaisyVariants.SetOverflowHidden(mBase)
    Else
        mBase.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
        Surface.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
        B4XDaisyVariants.ApplyElevation(mBase, "none")
    End If
    B4XDaisyVariants.ApplyElevation(Surface, "none")
End Sub

Private Sub RenderMenu
    Dim outerRect As B4XRect = ResolveOuterRect(Surface.Width, Surface.Height)
    Dim contentRect As B4XRect = ResolveContentRect
    Dim y As Int = contentRect.Top
    Dim x As Int = contentRect.Left
    Dim contentW As Int = Max(1dip, contentRect.Width)
    Dim spec As Map = ResolveSizeSpec
    Dim rowH As Int = spec.Get("row_h")
    Dim horizontalMaxH As Int = rowH + (ResolveOuterPadding * 2)
    Dim previousClickable As Boolean = False

    If mLevel > 0 And mOrientation = "vertical" And mbPopup = False Then
        AddBranchLine(outerRect, contentRect)
    End If

    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("visible", True) Then
            Dim kind As String = item.Get("kind")
            Select Case kind
            Case "divider"
                previousClickable = False
                If mOrientation = "vertical" Then
                    y = y + AddDividerBlock(item, x, y, contentW, "vertical")
                Else
                    x = x + AddDividerBlock(item, x, contentRect.Top, ResolveDividerExtent, "horizontal")
                End If
            Case "title"
                previousClickable = False
                If mOrientation = "vertical" Then
                    Dim titleH As Int = AddTitleView(item, x, y, contentW)
                    y = y + titleH
                End If
            Case Else
                If mDividers And IsClickableItem(item) And previousClickable Then
                    If mOrientation = "horizontal" And mLevel = 0 Then
                        x = x + AddAutoDivider(x, contentRect.Top, ResolveDividerExtent, "horizontal")
                    Else
                        y = y + AddAutoDivider(x, y, contentW, "vertical")
                    End If
                End If
                If mOrientation = "horizontal" And mLevel = 0 Then
                    Dim rowW As Int = EstimateRowWidth(item)
                    AddRowView(item, x, contentRect.Top, rowW, rowH, False)
                    x = x + rowW
                    If kind = "submenu" And item.GetDefault("open", False) Then
                        Dim popup As B4XDaisyMenu = item.Get("submenu")
                        popup.SetPopupMode(True)
                        popup.Orientation = "vertical"
                        popup.Size = mSize
                        popup.Shadow = "md"
                        popup.BringToFront = True
                        Dim popupW As Int = Max(72dip, popup.GetPreferredWidth)
                        Dim popupH As Int = popup.GetPreferredHeight
                        Dim popupHost As B4XView = ResolvePopupHost
                        Dim popupLeft As Int = mBase.Left + item.Get("row_left")
                        Dim popupTop As Int = mBase.Top + contentRect.Top + rowH + 8dip
                        EnsurePopupBase(popup, popupW, popupH)
                        If popup.mBase.Parent.IsInitialized Then popup.mBase.RemoveViewFromParent
                        popupHost.AddView(popup.mBase, popupLeft, popupTop, popupW, popupH)
                        popup.Base_Resize(popupW, popupH)
                        popup.Refresh
                        If mBase.Parent.IsInitialized Then mBase.BringToFront
                        popup.mBase.BringToFront
                    End If
                Else
                    Dim thisRowH As Int = MeasureItemRowHeight(item, contentW)
                    AddRowView(item, x, y, contentW, thisRowH, True)
                    y = y + thisRowH
                    If kind = "submenu" And item.GetDefault("open", False) Then
                        Dim child As B4XDaisyMenu = item.Get("submenu")
                        child.SetPopupMode(False)
                        child.Orientation = "vertical"
                        child.Size = mSize
                        Dim childH As Int = child.GetPreferredHeight
                        child.AddToParent(Surface, x, y, contentW, childH)
                        y = y + childH
                    End If
                End If
                previousClickable = IsClickableItem(item)
            End Select
        End If
    Next

    If mOrientation = "horizontal" And mLevel = 0 Then
        Base_Resize(mBase.Width, horizontalMaxH)
    End If
End Sub

Private Sub EnsurePopupBase(Popup As B4XDaisyMenu, Width As Int, Height As Int)
    If Popup.IsInitialized = False Then Return
    If Popup.mBase.IsInitialized Then Return
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
    Dim dummy As Label
    Popup.DesignerCreateView(b, dummy, Popup.BuildRuntimeProps(Width, Height))
End Sub

Private Sub ResolvePopupHost As B4XView
    If mBase.IsInitialized And mBase.Parent.IsInitialized Then Return mBase.Parent
    Return Surface
End Sub

Private Sub DetachRenderedSubmenus
    If mItems.IsInitialized = False Then Return
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("kind", "") = "submenu" And item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            child.RemoveViewFromParent
        End If
    Next
End Sub

Private Sub AddBranchLine(OuterRect As B4XRect, ContentRect As B4XRect)
    If Surface.IsInitialized = False Then Return
    Dim p As Panel
    p.Initialize("")
    Dim line As B4XView = p
    line.Color = ResolveDividerColor
    Dim lineX As Int = Max(0, ContentRect.Left)
    Dim lineTop As Int = ContentRect.Top + 12dip
    Dim lineBottom As Int = ContentRect.Bottom - 12dip
    Dim lineHeight As Int = Max(1dip, lineBottom - lineTop)
    Surface.AddView(line, lineX, lineTop, 1dip, lineHeight)
End Sub

Private Sub AddAutoDivider(Left As Int, Top As Int, Width As Int, Direction As String) As Int
    Dim item As Map
    item.Initialize
    item.Put("kind", "auto-divider")
    Return AddDividerBlock(item, Left, Top, Width, Direction)
End Sub

Private Sub AddDividerBlock(Item As Map, Left As Int, Top As Int, Width As Int, Direction As String) As Int
    Dim gap As Int = ResolveDividerGapDip
    Dim thickness As Int = ResolveDividerThicknessDip
    If Direction = "horizontal" Then
        Dim rowH As Int = ResolveSizeSpec.Get("row_h")
        AddDividerSpacerView(Left, Top, gap, rowH)
        AddDividerView(Item, Left + gap, Top, thickness, rowH, Direction)
        AddDividerSpacerView(Left + gap + thickness, Top, gap, rowH)
    Else
        AddDividerSpacerView(Left, Top, Width, gap)
        AddDividerView(Item, Left, Top + gap, Width, thickness, Direction)
        AddDividerSpacerView(Left, Top + gap + thickness, Width, gap)
    End If
    Return ResolveDividerExtent
End Sub

Private Sub AddDividerView(Item As Map, Left As Int, Top As Int, Width As Int, Height As Int, Direction As String) As Int
    Dim divider As B4XDaisyDivider
    divider.Initialize(Me, "")
    divider.setDirection(Direction)
    divider.setGap(0)
    divider.setLineThickness(ResolveDividerThicknessDip)
    divider.setMargin("m-0")
    divider.setPadding("p-0")
    divider.setBackgroundColor(ResolveDividerColor)
    divider.setText("")
    divider.setVisible(True)
    Dim v As B4XView = divider.AddToParent(Surface, Left, Top, Max(1dip, Width), Max(1dip, Height))
    Item.Put("view", v)
    Return ResolveDividerExtent
End Sub

Private Sub AddDividerSpacerView(Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim spacer As B4XView = p
    spacer.Color = xui.Color_Transparent
    Surface.AddView(spacer, Left, Top, Max(0, Width), Max(0, Height))
    Return spacer
End Sub

Private Sub AddTitleView(Item As Map, Left As Int, Top As Int, Width As Int) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim titleH As Int = spec.Get("title_h")
    Dim l As Label
    l.Initialize("")
    Dim v As B4XView = l
    v.Color = xui.Color_Transparent
    v.Text = item.GetDefault("text", "")
    v.TextColor = ResolveTitleColor
    v.Font = xui.CreateDefaultBoldFont(spec.Get("title_font"))
    v.SetTextAlignment("CENTER", "LEFT")
    Surface.AddView(v, Left, Top, Width, titleH)
    Item.Put("view", v)
    Return titleH
End Sub

Private Sub AddRowView(Item As Map, Left As Int, Top As Int, Width As Int, Height As Int, FillWidth As Boolean)
    Dim p As Panel
    p.Initialize("")
    Dim row As B4XView = p
    row.Color = xui.Color_Transparent
    Surface.AddView(row, Left, Top, Width, Height)
    Item.Put("view", row)
    Item.Put("row_left", Left)
    LayoutRowContent(row, Item, Width, Height, FillWidth)
End Sub

Private Sub LayoutRowContent(Row As B4XView, Item As Map, Width As Int, Height As Int, FillWidth As Boolean)
    Dim spec As Map = ResolveSizeSpec
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim rowRadius As Float = B4XDaisyVariants.GetRadiusFieldDip(8dip)
    Dim textColor As Int = ResolveRowTextColor(Item)
    Dim backColor As Int = ResolveRowBackgroundColor(Item)
    Row.SetColorAndBorder(backColor, 0, xui.Color_Transparent, rowRadius)
    If item.GetDefault("active", False) And mActiveBorder Then
        Dim pBorder As Panel
        pBorder.Initialize("")
        Dim activeBorderView As B4XView = pBorder
        activeBorderView.Color = ResolveActiveColor
        Row.AddView(activeBorderView, 0, 4dip, 3dip, Max(1dip, Height - 8dip))
    End If

    Dim leftX As Int = px
    Dim rightX As Int = Width - px
    Dim singleRowH As Int = spec.Get("row_h")
    Dim centerY As Int = Min(Height, singleRowH) / 2
    Dim text As String = item.GetDefault("text", "")
    Dim iconName As String = GetMapString(item, "icon")
    Dim badgeTextValue As String = GetMapString(item, "badge_text")
    Dim badgeVariantValue As String = GetMapString(item, "badge_variant")
    Dim hasIcon As Boolean = iconName.Trim.Length > 0
    Dim rowHasBadge As Boolean = HasBadge(Item)
    Dim hasChevron As Boolean = item.Get("kind") = "submenu"
    Dim iconOnly As Boolean = IsIconOnlyItem(Item)

    If hasIcon Then
        Dim icon As B4XDaisySvgIcon
        icon.Initialize(Me, "")
        Dim iconLeft As Int = leftX
        If iconOnly Then iconLeft = Max(0, (Width - iconSize) / 2)
        Dim iconView As B4XView = icon.AddToParent(Row, iconLeft, centerY - (iconSize / 2), iconSize, iconSize)
        icon.SvgAsset = item.Get("icon")
        icon.PreserveOriginalColors = False
        icon.Color = textColor
        icon.ResizeToParent(iconView)
        Item.Put("icon_view", iconView)
        If iconOnly Then
            leftX = iconLeft
            rightX = iconLeft + iconSize
        Else
            leftX = leftX + iconSize + gap
        End If
    End If

    If hasChevron Then
        Dim chevronSize As Int = Max(12dip, iconSize - 2dip)
        Dim chevronView As B4XView = AddSubmenuChevronView(Row, item, rightX - chevronSize, centerY - (chevronSize / 2), chevronSize, textColor)
        rightX = rightX - chevronSize - gap
        Item.Put("chevron_view", chevronView)
    End If

    If rowHasBadge Then
        Dim badge As B4XDaisyBadge
        badge.Initialize(Me, "")
        Dim badgeText As String = item.GetDefault("badge_text", "")
        Dim badgeVariant As String = item.GetDefault("badge_variant", "neutral")
        Dim badgeSpec As Map = ResolveBadgeSpec
        Dim badgeW As Int = EstimateBadgeWidth(badgeText)
        Dim badgeH As Int = badgeSpec.Get("height")
        Dim badgeView As B4XView = badge.AddToParent(Row, rightX - badgeW, centerY - (badgeH / 2), badgeW, badgeH)
        badge.Text = badgeText
        badge.Size = badgeSpec.Get("size")
        badge.Variant = badgeVariant
        badge.setRounded("rounded-full")
        If badgeText.Length = 0 Then
            badge.setWidth(B4XDaisyVariants.ResolvePxSizeSpec(badgeW))
            badge.setHeight(B4XDaisyVariants.ResolvePxSizeSpec(badgeH))
        End If
        If GetMapString(item, "badge_style").Length > 0 Then badge.BadgeStyle = item.Get("badge_style")
        If item.GetDefault("badge_background_color", 0) <> 0 Then badge.BackgroundColor = item.Get("badge_background_color")
        If item.GetDefault("badge_text_color", 0) <> 0 Then badge.TextColor = item.Get("badge_text_color")
        rightX = rightX - badgeW - gap
        Item.Put("badge_view", badgeView)
    End If

    If iconOnly = False Then
        Dim l As Label
        l.Initialize("")
        Dim textView As B4XView = l
        textView.Color = xui.Color_Transparent
        textView.Text = text
        textView.TextColor = textColor
        textView.Font = xui.CreateDefaultFont(spec.Get("font"))
        Dim singleLineH As Int = spec.Get("row_h")
        If Height > singleLineH Then
            ' Multiline: top-align text with vertical padding so it sits inside the expanded row
            Dim vertPad As Int = Max(0, (singleLineH - Ceil(spec.Get("font") * 1dip)) / 2)
            textView.SetTextAlignment("TOP", "LEFT")
            Row.AddView(textView, leftX, vertPad, Max(1dip, rightX - leftX), Max(1dip, Height - 2 * vertPad))
        Else
            ' Single-line: span the full row height and let CENTER alignment handle vertical positioning
            textView.SetTextAlignment("CENTER", "LEFT")
            Row.AddView(textView, leftX, 0, Max(1dip, rightX - leftX), Height)
        End If
        Item.Put("text_view", textView)
    End If

    Dim hit As Panel
    hit.Initialize("row")
    Dim hitView As B4XView = hit
    hitView.Color = xui.Color_Transparent
    hitView.Tag = Item
    hitView.Enabled = mEnabled And (Item.GetDefault("disabled", False) = False)
    Row.AddView(hitView, 0, 0, Width, Height)
    Item.Put("hit_view", hitView)
End Sub

Private Sub row_Click
    Dim senderView As B4XView = Sender
    Dim item As Map = senderView.Tag
    If item.IsInitialized = False Then Return
    If item.GetDefault("disabled", False) Then Return
    If item.Get("kind") = "submenu" Then
        ToggleSubmenuItem(item, Not(item.GetDefault("open", False)), 200)
        RaiseSubmenuToggle(item.GetDefault("tag", item.GetDefault("text", "")), item.GetDefault("open", False))
        Return
    End If
    Dim idx As Int = mItems.IndexOf(item)
    If idx >= 0 Then SetItemActiveByIndex(idx, True)
    RaiseItem(item.GetDefault("tag", item.GetDefault("text", "")), item.GetDefault("text", ""))
End Sub

Private Sub submenuchild_Click(Tag As Object)
    RaiseClick(Tag)
End Sub

Private Sub submenuchild_ItemClick(Tag As Object, Text As String)
    RaiseItem(Tag, Text)
End Sub

Private Sub submenuchild_SubmenuToggle(Tag As Object, Open As Boolean)
    RaiseSubmenuToggle(Tag, Open)
End Sub

Private Sub RaiseItem(Tag As Object, Text As String)
    RaiseClick(Tag)
    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 2) Then
        CallSub3(mCallBack, mEventName & "_ItemClick", Tag, Text)
    End If
End Sub

Private Sub RaiseClick(Tag As Object)
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", Tag)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub

Private Sub RaiseSubmenuToggle(Tag As Object, Open As Boolean)
    If xui.SubExists(mCallBack, mEventName & "_SubmenuToggle", 2) Then
        CallSub3(mCallBack, mEventName & "_SubmenuToggle", Tag, Open)
    End If
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    EnsureHostStructure
    LayoutHosts(Width, Height)
    If mBringToFront Then mBase.BringToFront
End Sub

Public Sub Clear
    If mItems.IsInitialized = False Then mItems.Initialize
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            child.RemoveViewFromParent
        End If
    Next
    mItems.Clear
    If Surface.IsInitialized Then Surface.RemoveAllViews
End Sub

Public Sub AddTitle(Text As String) As Int
    Dim item As Map = CreateItem("title", Text, Text, "", "", "", "none")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddDivider As Int
    Dim item As Map = CreateItem("divider", "", "", "", "", "", "none")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddItem(TagValue As Object, Text As String) As Int
    If TagValue = Null Then Return -1
    If TagValue Is String Then
        Dim tagText As String = TagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", Text, TagValue, "", "", "", "none")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddIconItem(TagValue As Object, Text As String, IconName As String) As Int
    If TagValue = Null Then Return -1
    If TagValue Is String Then
        Dim tagText As String = TagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", Text, TagValue, IconName, "", "", "none")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddBadgeItem(TagValue As Object, Text As String, BadgeText As String, BadgeVariant As String) As Int
    If TagValue = Null Then Return -1
    If TagValue Is String Then
        Dim tagText As String = TagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", Text, TagValue, "", BadgeText, BadgeVariant, "solid")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddIconBadgeItem(TagValue As Object, Text As String, IconName As String, BadgeText As String, BadgeVariant As String) As Int
    If TagValue = Null Then Return -1
    If TagValue Is String Then
        Dim tagText As String = TagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", Text, TagValue, IconName, BadgeText, BadgeVariant, "solid")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddSubmenu(TagValue As Object, Text As String, InitiallyOpen As Boolean) As B4XDaisyMenu
    Dim child As B4XDaisyMenu
    If TagValue = Null Then Return child
    If TagValue Is String Then
        Dim tagText As String = TagValue
        If tagText.Trim.Length = 0 Then Return child
    End If
    child.Initialize(Me, "submenuchild")
    child.SetLevelInternal(mLevel + 1)
    child.SetParentMenuInternal(Me)
    child.Size = mSize
    child.Enabled = mEnabled
    child.Visible = True
    child.Orientation = "vertical"
    If mBackgroundColor <> 0 Then child.BackgroundColor = mBackgroundColor
    Dim item As Map = CreateItem("submenu", Text, TagValue, "", "", "", "none")
    item.Put("submenu", child)
    item.Put("open", InitiallyOpen)
    mItems.Add(item)
    RefreshIfReady
    Return child
End Sub

Private Sub CreateItem(Kind As String, Text As String, TagValue As Object, IconName As String, BadgeText As String, BadgeVariant As String, BadgeStyle As String) As Map
    Dim item As Map
    item.Initialize
    item.Put("kind", Kind)
    item.Put("text", Text)
    item.Put("tag", TagValue)
    item.Put("icon", IconName)
    item.Put("badge_text", BadgeText)
    item.Put("badge_variant", B4XDaisyVariants.NormalizeVariant(BadgeVariant))
    item.Put("badge_style", BadgeStyle)
    item.Put("badge_background_color", 0)
    item.Put("badge_text_color", 0)
    item.Put("disabled", False)
    item.Put("active", False)
    item.Put("open", False)
    Return item
End Sub

Public Sub SetItemDisabled(TagValue As Object, Value As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("disabled", Value)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub ClearActive
    ResolveRootMenu.ClearActiveRecursive
    RefreshIfReady
End Sub

' Scrolls the vertical scroll view so the item with the given tag is visible.
' Has no effect when the menu has no explicit height / scroll mode is not vertical.
Public Sub ScrollToItem(TagValue As Object)
    If msScrollMode <> "vertical" Then Return
    If mVScrollView.IsInitialized = False Then Return
    Dim item As Map = FindItemByTagRecursive(Me, TagValue)
    If item.IsInitialized = False Then Return
    Dim rowView As B4XView = item.GetDefault("view", Null)
    If rowView = Null Or rowView.IsInitialized = False Then Return
    ' rowView.Top is the y offset inside Surface, the scrollable content panel.
    Dim rowTop As Int = rowView.Top
    Dim rowH As Int = rowView.Height
    ' Use mScrollHost.Height as the reliable visible-area height
    Dim viewH As Int = mScrollHost.Height
    If viewH <= 0 Then viewH = mVScrollView.Height
    Dim jo As JavaObject = mVScrollView
    Dim scrollResult As Object = jo.RunMethod("getScrollY", Null)
    Dim curScroll As Int = 0
    If scrollResult <> Null Then curScroll = scrollResult
    ' Only scroll if the row is not already fully visible
    If rowTop >= curScroll And rowTop + rowH <= curScroll + viewH Then Return
    Dim targetY As Int
    If rowTop < curScroll Then
        targetY = rowTop
    Else
        targetY = rowTop + rowH - viewH
    End If
    Dim scrollToX As Int = 0
    Dim scrollToY As Int = Max(0, targetY)
    jo.RunMethod("smoothScrollTo", Array(scrollToX, scrollToY))
End Sub

Private Sub SetItemActiveByIndex(Index As Int, Value As Boolean)
    If Index < 0 Or Index >= mItems.Size Then Return
    If Value Then
        ResolveRootMenu.ClearActiveRecursive
    End If
    Dim item As Map = mItems.Get(Index)
    item.Put("active", Value)
    RefreshIfReady
End Sub

Public Sub SetItemActive(TagValue As Object, Value As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    If Value Then root.ClearActiveRecursive
    item.Put("active", Value)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetSubmenuOpen(Index As Int, Value As Boolean)
    If Index < 0 Or Index >= mItems.Size Then Return
    Dim item As Map = mItems.Get(Index)
    If item.GetDefault("kind", "") <> "submenu" Then Return
    ToggleSubmenuItem(item, Value, 0)
End Sub

Public Sub SetItemBadgeText(TagValue As Object, Value As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_text", Value)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeBackgroundColor(TagValue As Object, Color As Int)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_background_color", Color)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeTextColor(TagValue As Object, Color As Int)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_text_color", Color)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemText(TagValue As Object, Value As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("text", Value)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemIcon(TagValue As Object, IconName As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("icon", IconName)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemVisible(TagValue As Object, Value As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, TagValue)
    If item.IsInitialized = False Then Return
    item.Put("visible", Value)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, TagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub GetItemView(Index As Int) As B4XView
    Dim empty As B4XView
    If Index < 0 Or Index >= mItems.Size Then Return empty
    Dim item As Map = mItems.Get(Index)
    If item.ContainsKey("view") Then Return item.Get("view")
    Return empty
End Sub

Public Sub GetPreferredHeight As Int
    If mHeightExplicit Then Return Max(1dip, mHeight)
    Return Max(Ceil(B4XDaisyBoxModel.ExpandContentHeight(MeasureMenuContentHeight(False), BuildRootBoxModel)), ResolveMinimumHeight)
End Sub

Private Sub MeasureMenuContentHeight(IncludePopupSurface As Boolean) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim rowH As Int = spec.Get("row_h")
    Dim total As Int = 0
    If mOrientation = "horizontal" And mLevel = 0 Then
        Return rowH
    End If
    ' Estimate content width so multiline items measure their true height
    Dim estimatedContentW As Int
    If Surface.IsInitialized And Surface.Width > 0 Then
        estimatedContentW = Surface.Width
    Else If mWidthExplicit Then
        estimatedContentW = Max(40dip, mWidth - ResolveOuterPadding * 2)
    Else If mBase.IsInitialized And mBase.Parent.IsInitialized And mBase.Parent.Width > 0 Then
        estimatedContentW = Max(40dip, mBase.Parent.Width - ResolveOuterPadding * 2)
    Else
        estimatedContentW = Max(40dip, GetPreferredWidth - ResolveOuterPadding * 2)
    End If
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("visible", True) Then
            Select Case item.GetDefault("kind", "")
                Case "divider"
                    total = total + ResolveDividerExtent
                Case "title"
                    total = total + spec.Get("title_h")
                Case Else
                    total = total + MeasureItemRowHeight(item, estimatedContentW)
                    If item.GetDefault("kind", "") = "submenu" And item.GetDefault("open", False) Then
                        Dim child As B4XDaisyMenu = item.Get("submenu")
                        If IncludePopupSurface Then
                            total = total + child.GetPreferredSurfaceHeight
                        Else
                            total = total + child.GetPreferredHeight
                        End If
                    End If
            End Select
        End If
    Next
    total = total + (GetAutoDividerCount * ResolveDividerExtent)
    Return Max(total, rowH + (ResolveOuterPadding * 2))
End Sub

Public Sub GetPreferredWidth As Int
    If UsesFullWidth And mBase.IsInitialized And mBase.Parent.IsInitialized Then Return Max(72dip, mBase.Parent.Width)
    If mWidthExplicit Then Return Max(72dip, mWidth)
    Dim total As Int = 0
    If mOrientation = "horizontal" And mLevel = 0 Then
        For i = 0 To mItems.Size - 1
            Dim hItem As Map = mItems.Get(i)
            If hItem.GetDefault("visible", True) Then
                total = total + EstimateRowWidth(hItem)
            End If
        Next
        total = total + (GetAutoDividerCount * ResolveDividerExtent)
        Return Max(Ceil(B4XDaisyBoxModel.ExpandContentWidth(total, BuildRootBoxModel)), 120dip)
    End If
    Dim maxW As Int = ResolveMinimumWidth
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("visible", True) Then
            maxW = Max(maxW, EstimateRowWidth(item))
            If item.GetDefault("kind", "") = "submenu" Then
                Dim child As B4XDaisyMenu = item.Get("submenu")
                maxW = Max(maxW, 18dip + child.GetPreferredWidth)
            End If
        End If
    Next
    Return Ceil(B4XDaisyBoxModel.ExpandContentWidth(maxW, BuildRootBoxModel))
End Sub

Private Sub EstimateRowWidth(Item As Map) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim fontSize As Float = spec.Get("font")
    Dim text As String = item.GetDefault("text", "")
    Dim w As Int = px * 2
    Dim kind As String = item.GetDefault("kind", "")
    If kind = "divider" Then Return 60dip
    If kind = "title" Then
        Return px * 2 + B4XDaisyVariants.MeasureTextWidthSafe(text, spec.Get("title_font"), Typeface.DEFAULT_BOLD, 8dip)
    End If
    If IsIconOnlyItem(Item) Then
        Return Max(iconSize + (px * 2), spec.Get("row_h"))
    End If
    If GetMapString(Item, "icon").Trim.Length > 0 Then w = w + iconSize + gap
    w = w + B4XDaisyVariants.MeasureTextWidthSafe(text, fontSize, Typeface.DEFAULT, 8dip)
    If HasBadge(Item) Then
        w = w + EstimateBadgeWidth(Item.GetDefault("badge_text", "")) + gap
    End If
    If kind = "submenu" Then w = w + 14dip + gap
    Return Max(w, 72dip)
End Sub

Private Sub EstimateBadgeWidth(Text As String) As Int
    Dim badgeSpec As Map = ResolveBadgeSpec
    If Text.Length = 0 Then Return badgeSpec.Get("height")
    Dim content As String = Text
    Return Max(badgeSpec.Get("min_w"), B4XDaisyVariants.MeasureTextWidthSafe(content, badgeSpec.Get("font"), Typeface.DEFAULT_BOLD, badgeSpec.Get("buffer")))
End Sub

Private Sub HasBadge(Item As Map) As Boolean
    If GetMapString(Item, "badge_text").Length > 0 Then Return True
    If GetMapString(Item, "badge_variant").Length > 0 And GetMapString(Item, "badge_variant") <> "none" Then Return True
    If Item.GetDefault("badge_background_color", 0) <> 0 Then Return True
    If Item.GetDefault("badge_text_color", 0) <> 0 Then Return True
    Return False
End Sub

Private Sub ResolveBadgeSpec As Map
    Select Case B4XDaisyVariants.NormalizeSize(mSize)
        Case "xs"
            Return CreateMap("size": "xs", "height": 16dip, "font": 10, "buffer": 16dip, "min_w": 22dip)
        Case "sm"
            Return CreateMap("size": "sm", "height": 20dip, "font": 11, "buffer": 18dip, "min_w": 24dip)
        Case "lg"
            Return CreateMap("size": "lg", "height": 28dip, "font": 15, "buffer": 22dip, "min_w": 32dip)
        Case "xl"
            Return CreateMap("size": "xl", "height": 32dip, "font": 17, "buffer": 24dip, "min_w": 36dip)
        Case Else
            Return CreateMap("size": "md", "height": 24dip, "font": 13, "buffer": 20dip, "min_w": 28dip)
    End Select
End Sub

Private Sub ResolveSizeSpec As Map
    Select Case B4XDaisyVariants.NormalizeSize(mSize)
        Case "xs"
            Return CreateMap("row_h": 24dip, "font": 11, "title_font": 10, "title_h": 24dip, "pad_x": 8dip, "gap": 6dip, "icon": 14dip)
        Case "sm"
            Return CreateMap("row_h": 28dip, "font": 12, "title_font": 11, "title_h": 26dip, "pad_x": 10dip, "gap": 6dip, "icon": 16dip)
        Case "lg"
            Return CreateMap("row_h": 42dip, "font": 18, "title_font": 15, "title_h": 34dip, "pad_x": 16dip, "gap": 8dip, "icon": 20dip)
        Case "xl"
            Return CreateMap("row_h": 50dip, "font": 22, "title_font": 17, "title_h": 38dip, "pad_x": 20dip, "gap": 10dip, "icon": 22dip)
        Case Else
            Return CreateMap("row_h": 34dip, "font": 14, "title_font": 13, "title_h": 28dip, "pad_x": 12dip, "gap": 8dip, "icon": 20dip)
    End Select
End Sub

Private Sub MeasureItemRowHeight(Item As Map, ContentWidth As Int) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim rowH As Int = spec.Get("row_h")
    If ContentWidth <= 0 Then Return rowH
    Dim kind As String = item.GetDefault("kind", "item")
    If kind <> "item" And kind <> "submenu" Then Return rowH
    If IsIconOnlyItem(Item) Then Return rowH
    Dim text As String = item.GetDefault("text", "")
    If text.Trim.Length = 0 Then Return rowH
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim fontSize As Float = spec.Get("font")
    Dim textAreaW As Int = ContentWidth - (px * 2)
    If GetMapString(item, "icon").Trim.Length > 0 Then textAreaW = textAreaW - iconSize - gap
    If kind = "submenu" Then textAreaW = textAreaW - Max(12dip, iconSize - 2dip) - gap
    If HasBadge(item) Then textAreaW = textAreaW - EstimateBadgeWidth(item.GetDefault("badge_text", "")) - gap
    If textAreaW < 40dip Then Return rowH
    Dim textW As Int = B4XDaisyVariants.MeasureTextWidthSafe(text, fontSize, Typeface.DEFAULT, 0)
    If textW <= textAreaW Then Return rowH
    Dim lineH As Int = Ceil(fontSize * 1dip * 1.4)
    Dim vertPad As Int = Max(4dip, (rowH - Ceil(fontSize * 1dip)) / 2)
    Dim lines As Int = Ceil(textW / textAreaW)
    Return Max(rowH, lines * lineH + vertPad * 2)
End Sub

Private Sub IsIconOnlyItem(Item As Map) As Boolean
    If Item.IsInitialized = False Then Return False
    If Item.GetDefault("kind", "") <> "item" Then Return False
    If GetMapString(Item, "icon").Trim.Length = 0 Then Return False
    If GetMapString(Item, "text").Trim.Length > 0 Then Return False
    If HasBadge(Item) Then Return False
    Return True
End Sub

Private Sub IsIconOnlyMenu As Boolean
    If mItems.IsInitialized = False Or mItems.Size = 0 Then Return False
    For i = 0 To mItems.Size - 1
        If IsIconOnlyItem(mItems.Get(i)) = False Then Return False
    Next
    Return True
End Sub

Private Sub UsesFullWidth As Boolean
    If mOrientation = "horizontal" And mLevel = 0 Then Return False
    Return mWidthFull
End Sub

Private Sub ResolveMinimumWidth As Int
    If mOrientation = "vertical" And IsIconOnlyMenu Then Return 0
    Return 120dip
End Sub

Private Sub ResolveDividerGapDip As Int
    If mDividerGap.Trim.Length = 0 Then Return 0
    Return Max(0dip, B4XDaisyVariants.TailwindSizeToDip(mDividerGap, 16dip))
End Sub

Private Sub ResolveDividerThicknessDip As Int
    Return 1dip
End Sub

Private Sub ResolveDividerExtent As Int
    Return Max(ResolveDividerThicknessDip, (ResolveDividerGapDip * 2) + ResolveDividerThicknessDip)
End Sub

Private Sub ResolveOuterPadding As Int
    Dim box As Map = BuildInnerBoxModel
    Return box.GetDefault("padding_left", 8dip)
End Sub

Private Sub BuildRootBoxModel As Map
    Dim box As Map = BuildInnerBoxModel
    Dim marginSpec As String = mMargin
    If marginSpec.Trim.Length = 0 And mLevel > 0 And mbPopup = False Then marginSpec = "ms-4"
    B4XDaisyBoxModel.ApplyMarginUtilities(box, marginSpec, False)
    Return box
End Sub

Private Sub BuildInnerBoxModel As Map
    Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
    Dim defaultPadding As String = "p-2"
    If mLevel > 0 And mbPopup = False Then
        defaultPadding = "ps-2 pe-0 py-0"
    End If
    Dim paddingSpec As String = mPadding
    If paddingSpec.Trim.Length = 0 Then paddingSpec = defaultPadding
    B4XDaisyBoxModel.ApplyPaddingUtilities(box, paddingSpec, False)
    Return box
End Sub

Private Sub ResolveOuterRect(Width As Double, Height As Double) As B4XRect
    Dim host As B4XRect
    host.Initialize(0, 0, Max(1dip, Width), Max(1dip, Height))
    Return B4XDaisyBoxModel.ResolveOuterRect(host, BuildRootBoxModel)
End Sub

Private Sub ResolveContentRect As B4XRect
    Dim host As B4XRect
    host.Initialize(0, 0, Max(1dip, Surface.Width), Max(1dip, Surface.Height))
    Dim innerBox As Map = BuildInnerBoxModel
    Return B4XDaisyBoxModel.ResolveContentRect(host, innerBox)
End Sub

Private Sub ResolveScrollMode As String
    If mOrientation = "horizontal" And mWidthExplicit Then Return "horizontal"
    If mHeightExplicit Then Return "vertical"
    Return "none"
End Sub

Private Sub EnsureHostStructure
    If mBase.IsInitialized = False Then Return
    If mScrollHost.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        mScrollHost = p
        mScrollHost.Color = xui.Color_Transparent
        mBase.AddView(mScrollHost, 0, 0, mBase.Width, mBase.Height)
    End If
    If Surface.IsInitialized = False Then
        Dim pSurface As Panel
        pSurface.Initialize("")
        Surface = pSurface
        Surface.Color = xui.Color_Transparent
    End If

    Dim nextMode As String = ResolveScrollMode
    If nextMode = msScrollMode And Surface.Parent.IsInitialized Then Return

    mScrollHost.RemoveAllViews
    If Surface.IsInitialized And Surface.Parent.IsInitialized Then Surface.RemoveViewFromParent
    mScrollView = Null

    Select Case nextMode
        Case "vertical"
            mVScrollView.Initialize(0)
            mScrollView = mVScrollView
            Dim joV As JavaObject = mVScrollView
            joV.RunMethod("setVerticalScrollBarEnabled", Array(False))
            mScrollHost.AddView(mScrollView, 0, 0, Max(1dip, mScrollHost.Width), Max(1dip, mScrollHost.Height))
            mVScrollView.Panel.Color = xui.Color_Transparent
            mVScrollView.Panel.AddView(Surface, 0, 0, Max(1dip, mScrollHost.Width), Max(1dip, mScrollHost.Height))
        Case "horizontal"
            mHScrollView.Initialize(0, "")
            mScrollView = mHScrollView
            Dim joH As JavaObject = mHScrollView
            joH.RunMethod("setHorizontalScrollBarEnabled", Array(False))
            mScrollHost.AddView(mScrollView, 0, 0, Max(1dip, mScrollHost.Width), Max(1dip, mScrollHost.Height))
            mHScrollView.Panel.Color = xui.Color_Transparent
            mHScrollView.Panel.AddView(Surface, 0, 0, Max(1dip, mScrollHost.Width), Max(1dip, mScrollHost.Height))
        Case Else
            mScrollHost.AddView(Surface, 0, 0, Max(1dip, mScrollHost.Width), Max(1dip, mScrollHost.Height))
    End Select
    msScrollMode = nextMode
End Sub

Private Sub LayoutHosts(Width As Double, Height As Double)
    If mScrollHost.IsInitialized = False Then Return
    Dim outerRect As B4XRect = ResolveOuterRect(Width, Height)
    mScrollHost.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
    If msScrollMode = "vertical" Or msScrollMode = "horizontal" Then
        If mScrollView.IsInitialized Then mScrollView.SetLayoutAnimated(0, 0, 0, outerRect.Width, outerRect.Height)
    End If

    Dim surfaceW As Int = Max(1dip, outerRect.Width)
    Dim surfaceH As Int = Max(1dip, outerRect.Height)
    If msScrollMode = "vertical" Then
        surfaceH = Max(surfaceH, GetPreferredSurfaceHeight)
    Else If msScrollMode = "horizontal" Then
        surfaceW = Max(surfaceW, GetPreferredSurfaceWidth)
        surfaceH = Max(surfaceH, GetPreferredSurfaceHeight)
    End If
    Surface.SetLayoutAnimated(0, 0, 0, surfaceW, surfaceH)
End Sub

Private Sub UpdateScrollContentSize
    If msScrollMode = "vertical" Then
        Dim h As Int = Max(GetPreferredSurfaceHeight, mScrollHost.Height)
        mVScrollView.Panel.Height = h
        mVScrollView.Panel.Width = mScrollHost.Width
        Surface.SetLayoutAnimated(0, 0, 0, mScrollHost.Width, h)
    Else If msScrollMode = "horizontal" Then
        Dim w As Int = Max(GetPreferredSurfaceWidth, mScrollHost.Width)
        Dim h2 As Int = Max(GetPreferredSurfaceHeight, mScrollHost.Height)
        mHScrollView.Panel.Width = w
        mHScrollView.Panel.Height = h2
        Surface.SetLayoutAnimated(0, 0, 0, w, h2)
    End If
End Sub

Private Sub GetPreferredSurfaceWidth As Int
    Return Ceil(B4XDaisyBoxModel.ExpandContentWidth(GetContentWidthCore, BuildInnerBoxModel))
End Sub

Private Sub GetPreferredSurfaceHeight As Int
    Return Ceil(B4XDaisyBoxModel.ExpandContentHeight(MeasureMenuContentHeight(True), BuildInnerBoxModel))
End Sub

Private Sub ResolveMinimumHeight As Int
    Dim spec As Map = ResolveSizeSpec
    Dim rowH As Int = spec.Get("row_h")
    If mOrientation = "horizontal" And mLevel = 0 Then Return rowH + 8dip
    Return rowH + (ResolveOuterPadding * 2)
End Sub

Private Sub GetContentWidthCore As Int
    Dim total As Int = 0
    If mOrientation = "horizontal" And mLevel = 0 Then
        For i = 0 To mItems.Size - 1
            total = total + EstimateRowWidth(mItems.Get(i))
        Next
        total = total + (GetAutoDividerCount * ResolveDividerExtent)
        Return Max(total, 120dip)
    End If
    Dim maxW As Int = ResolveMinimumWidth
    For i = 0 To mItems.Size - 1
        maxW = Max(maxW, EstimateRowWidth(mItems.Get(i)))
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("kind", "") = "submenu" Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            maxW = Max(maxW, 18dip + child.GetPreferredSurfaceWidth)
        End If
    Next
    Return maxW
End Sub

Private Sub GetContentHeightCore As Int
    Return MeasureMenuContentHeight(True)
End Sub

Private Sub ResolveMenuBackgroundColor As Int
    If mBackgroundColor <> 0 Then Return mBackgroundColor
    If mbPopup Then Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    If mLevel = 0 Then Return B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(232, 234, 237))
    Return xui.Color_Transparent
End Sub

Private Sub AddSubmenuChevronView(Parent As B4XView, Item As Map, Left As Int, Top As Int, Size As Int, Color As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim v As B4XView = p
    v.Color = xui.Color_Transparent
    Parent.AddView(v, Left, Top, Size, Size)
    Dim cvs As B4XCanvas
    cvs.Initialize(v)
    DrawSubmenuChevron(cvs, item.GetDefault("open", False), Color)
    Item.Put("chevron_canvas", cvs)
    Return v
End Sub

Private Sub DrawSubmenuChevron(TargetCanvas As B4XCanvas, IsOpen As Boolean, Color As Int)
    TargetCanvas.ClearRect(TargetCanvas.TargetRect)
    Dim w As Float = TargetCanvas.TargetRect.Width
    Dim h As Float = TargetCanvas.TargetRect.Height
    Dim stroke As Float = Max(1.5dip, Min(w, h) * 0.12)
    Dim path As B4XPath
    If IsOpen Then
        path.Initialize(w * 0.2, h * 0.6)
        path.LineTo(w * 0.5, h * 0.3)
        path.LineTo(w * 0.8, h * 0.6)
    Else
        path.Initialize(w * 0.2, h * 0.4)
        path.LineTo(w * 0.5, h * 0.7)
        path.LineTo(w * 0.8, h * 0.4)
    End If
    TargetCanvas.DrawPath(path, Color, False, stroke)
    TargetCanvas.Invalidate
End Sub

Private Sub ResolveRowBackgroundColor(Item As Map) As Int
    If item.GetDefault("active", False) Then
        If mActiveBorder Then Return xui.Color_Transparent
        Return ResolveActiveColor
    End If
    Return xui.Color_Transparent
End Sub

Private Sub ResolveRowTextColor(Item As Map) As Int
    If item.GetDefault("active", False) Then
        If mActiveBorder Then Return ResolveActiveColor
        Return ResolveActiveTextColor
    End If
    If item.GetDefault("disabled", False) Then
        Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 72)
    End If
    Return ResolveBaseTextColor
End Sub

Private Sub ResolveBaseTextColor As Int
    If mTextColor <> 0 Then Return mTextColor
    Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(44, 52, 64))
End Sub

Private Sub ResolveTitleColor As Int
    Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 120)
End Sub

Private Sub ResolveDividerColor As Int
    Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 30)
End Sub

Private Sub IsClickableItem(Item As Map) As Boolean
    If Item.IsInitialized = False Then Return False
    Dim kind As String = Item.GetDefault("kind", "")
    Select Case kind
        Case "item", "submenu"
            Return True
        Case Else
            Return False
    End Select
End Sub

Private Sub GetAutoDividerCount As Int
    If mDividers = False Then Return 0
    Dim count As Int = 0
    Dim previousClickable As Boolean = False
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("visible", True) = False Then
        Else If IsClickableItem(item) Then
            If previousClickable Then count = count + 1
            previousClickable = True
        Else
            previousClickable = False
        End If
    Next
    Return count
End Sub

Private Sub ResolveCornerRadius As Float
    Select Case B4XDaisyVariants.NormalizeRounded(mRounded)
        Case "rounded-none"
            Return 0
        Case "rounded-sm"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded-sm", 2dip)
        Case "rounded"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded", 4dip)
        Case "rounded-md"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded-md", 6dip)
        Case "rounded-lg"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded-lg", 8dip)
        Case "rounded-xl"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded-xl", 12dip)
        Case "rounded-2xl"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded-2xl", 16dip)
        Case "rounded-3xl"
            Return B4XDaisyVariants.TailwindBorderRadiusToDip("rounded-3xl", 24dip)
        Case "rounded-full"
            Return 999dip
        Case Else
            If mRoundedBox = False Then Return 0
            Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
    End Select
End Sub

Private Sub ResolveActiveColor As Int
    If mActiveColor <> 0 Then Return mActiveColor
    Return B4XDaisyVariants.GetTokenColor("--color-neutral", xui.Color_RGB(63, 64, 77))
End Sub

Private Sub ResolveActiveTextColor As Int
    If mActiveTextColor <> 0 Then Return mActiveTextColor
    Return B4XDaisyVariants.GetTokenColor("--color-neutral-content", xui.Color_White)
End Sub

Private Sub RefreshIfReady
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub SetLevelInternal(Level As Int)
    mLevel = Max(0, Level)
End Sub

Public Sub SetParentMenuInternal(ParentMenu As B4XDaisyMenu)
    mParentMenu = ParentMenu
End Sub

Private Sub ResolveRootMenu As B4XDaisyMenu
    Dim current As B4XDaisyMenu = Me
    Do While current.mParentMenu.IsInitialized
        current = current.mParentMenu
    Loop
    Return current
End Sub

Private Sub FindItemByTagRecursive(MenuComp As B4XDaisyMenu, TagValue As Object) As Map
    Dim empty As Map
    If MenuComp.IsInitialized = False Or MenuComp.mItems.IsInitialized = False Then Return empty
    For i = 0 To MenuComp.mItems.Size - 1
        Dim item As Map = MenuComp.mItems.Get(i)
        If item.GetDefault("kind", "") <> "divider" And item.GetDefault("kind", "") <> "title" Then
            If TagsMatch(item.GetDefault("tag", Null), TagValue) Then Return item
        End If
        If item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            Dim childItem As Map = FindItemByTagRecursive(child, TagValue)
            If childItem.IsInitialized Then Return childItem
        End If
    Next
    Return empty
End Sub

Private Sub FindOwningMenuByTagRecursive(MenuComp As B4XDaisyMenu, TagValue As Object) As B4XDaisyMenu
    Dim empty As B4XDaisyMenu
    If MenuComp.IsInitialized = False Or MenuComp.mItems.IsInitialized = False Then Return empty
    For i = 0 To MenuComp.mItems.Size - 1
        Dim item As Map = MenuComp.mItems.Get(i)
        If item.GetDefault("kind", "") <> "divider" And item.GetDefault("kind", "") <> "title" Then
            If TagsMatch(item.GetDefault("tag", Null), TagValue) Then Return MenuComp
        End If
        If item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            Dim owner As B4XDaisyMenu = FindOwningMenuByTagRecursive(child, TagValue)
            If owner.IsInitialized Then Return owner
        End If
    Next
    Return empty
End Sub

Private Sub TagsMatch(LeftTag As Object, RightTag As Object) As Boolean
    If LeftTag = Null Or RightTag = Null Then Return False
    Try
        Return LeftTag = RightTag
    Catch
        Dim leftText As String = LeftTag
        Dim rightText As String = RightTag
        Return leftText = rightText
    End Try
End Sub

Private Sub ClearActiveRecursive
    If mItems.IsInitialized = False Then Return
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("kind", "") <> "divider" And item.GetDefault("kind", "") <> "title" Then
            item.Put("active", False)
        End If
        If item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            child.ClearActiveRecursive
        End If
    Next
End Sub

Private Sub UpdateMeasuredHeightRecursive(OldHeight As Int, AnimDuration As Int)
    If mBase.IsInitialized = False Then Return
    If mOrientation = "horizontal" And mLevel = 0 Then Return
    If mHeightExplicit Then
        If mParentMenu.IsInitialized And mParentMenu.mBase.IsInitialized Then
            mParentMenu.UpdateMeasuredHeightRecursive(mParentMenu.mBase.Height, AnimDuration)
        End If
        Return
    End If

    Dim targetH As Int = Max(1dip, GetPreferredHeight)
    Dim previousH As Int = Max(0, OldHeight)
    If previousH = 0 Then previousH = mBase.Height
    If targetH <> mBase.Height Then
        mBase.SetLayoutAnimated(AnimDuration, mBase.Left, mBase.Top, mBase.Width, targetH)
        Base_Resize(mBase.Width, targetH)
    End If
    Dim delta As Int = targetH - previousH

    If mParentMenu.IsInitialized And mParentMenu.mBase.IsInitialized Then
        mParentMenu.UpdateMeasuredHeightRecursive(mParentMenu.mBase.Height, AnimDuration)
        Return
    End If

    If delta <> 0 Then
        Dim parentView As B4XView = mBase.Parent
        If parentView.IsInitialized Then
            B4XDaisyVariants.ShiftSiblingsBelow(mBase, delta, AnimDuration)
        End If
    End If
End Sub

Private Sub ToggleSubmenuItem(Item As Map, Value As Boolean, AnimDuration As Int)
    If Item.IsInitialized = False Then Return
    If Item.GetDefault("kind", "") <> "submenu" Then Return
    If Item.GetDefault("open", False) = Value Then Return

    Item.Put("open", Value)

    Dim root As B4XDaisyMenu = ResolveRootMenu
    If root.IsInitialized And root.mBase.IsInitialized Then
        Dim oldRootH As Int = root.mBase.Height
        root.Refresh
        root.UpdateMeasuredHeightRecursive(oldRootH, AnimDuration)
    Else
        Dim oldH As Int = 0
        If mBase.IsInitialized Then oldH = mBase.Height
        RefreshIfReady
        UpdateMeasuredHeightRecursive(oldH, AnimDuration)
    End If
End Sub

Public Sub SetPopupMode(Value As Boolean)
    mbPopup = Value
End Sub

Private Sub GetMapString(Item As Map, Key As String) As String
    If Item.IsInitialized = False Then Return ""
    Dim o As Object = Item.GetDefault(Key, "")
    If o = Null Then Return ""
    Dim s As String = o
    Return s
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub View As B4XView
    Dim empty As B4XView
    If mBase.IsInitialized Then Return mBase
    Return empty
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(Duration, Left, Top, Max(1dip, Width), Max(1dip, Height))
    Base_Resize(Max(1dip, Width), Max(1dip, Height))
    Refresh
End Sub

Public Sub setLeft(Value As Int)
    If mBase.IsInitialized Then mBase.Left = Value
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized Then Return mBase.Left
    Return 0
End Sub

Public Sub setTop(Value As Int)
    If mBase.IsInitialized Then mBase.Top = Value
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized Then Return mBase.Top
    Return 0
End Sub

Public Sub setEnabled(Value As Boolean)
    mEnabled = Value
    RefreshIfReady
End Sub

Public Sub getEnabled As Boolean
    Return mEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mVisible = Value
    If mBase.IsInitialized Then mBase.Visible = Value
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setWidth(Value As Object)
    If Value = Null Then Return
    Dim raw As String = Value
    If raw.ToLowerCase.Trim = "w-full" Or raw.ToLowerCase.Trim = "full" Then
        mWidth = 0
        mWidthExplicit = False
        mWidthFull = True
    Else If raw.ToLowerCase.Trim = "w-auto" Or raw.ToLowerCase.Trim = "auto" Then
        mWidth = 0
        mWidthExplicit = False
        mWidthFull = False
    Else
        mWidth = Max(72dip, B4XDaisyVariants.TailwindSizeToDip(Value, Max(mWidth, 224dip)))
        mWidthExplicit = True
        mWidthFull = False
    End If
    If mBase.IsInitialized = False Then Return
    Dim targetW As Int = IIf(UsesFullWidth And mBase.Parent.IsInitialized, mBase.Parent.Width, mWidth)
    If targetW <= 0 Then targetW = Max(72dip, GetPreferredWidth)
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, mBase.Height)
    Base_Resize(targetW, mBase.Height)
    Refresh
End Sub

Public Sub getWidth As Float
    If UsesFullWidth And mBase.IsInitialized Then Return mBase.Width
    Return mWidth
End Sub

Public Sub setHeight(Value As Object)
    If Value = Null Then Return
    Dim raw As String = Value
    If raw.ToLowerCase.Trim = "h-auto" Or raw.ToLowerCase.Trim = "auto" Then
        mbAutoResize = True
        mHeightExplicit = False
        mHeight = 0
    Else
        mbAutoResize = False
        mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, Max(mHeight, 40dip)))
        mHeightExplicit = True
    End If
    If mBase.IsInitialized = False Then Return
    Dim targetH As Int = IIf(mHeightExplicit, mHeight, GetPreferredHeight)
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, targetH)
    Base_Resize(mBase.Width, targetH)
    Refresh
End Sub

Public Sub getHeight As Float
    If mHeightExplicit Then Return mHeight
    If mBase.IsInitialized Then Return mBase.Height
    Return 0
End Sub

Public Sub setAutoResize(Value As Boolean)
    mbAutoResize = Value
    If mbAutoResize Then mHeightExplicit = False
    RefreshIfReady
End Sub

Public Sub getAutoResize As Boolean
    Return mbAutoResize
End Sub

Public Sub setPadding(Value As String)
    mPadding = IIf(Value = Null, "", Value)
    RefreshIfReady
End Sub

Public Sub getPadding As String
    Return mPadding
End Sub

Public Sub setMargin(Value As String)
    mMargin = IIf(Value = Null, "", Value)
    RefreshIfReady
End Sub

Public Sub getMargin As String
    Return mMargin
End Sub

Public Sub setDividers(Value As Boolean)
    mDividers = Value
    RefreshIfReady
End Sub

Public Sub getDividers As Boolean
    Return mDividers
End Sub

Public Sub setDividerGap(Value As String)
    mDividerGap = IIf(Value = Null, "", Value)
    RefreshIfReady
End Sub

Public Sub getDividerGap As String
    Return mDividerGap
End Sub

Public Sub setSize(Value As String)
    mSize = B4XDaisyVariants.NormalizeSize(Value)
    RefreshIfReady
End Sub

Public Sub getSize As String
    Return mSize
End Sub

Public Sub setOrientation(Value As String)
    mOrientation = B4XDaisyVariants.NormalizeOrientation(Value)
    RefreshIfReady
End Sub

Public Sub getOrientation As String
    Return mOrientation
End Sub

Public Sub setRounded(Value As String)
    mRounded = B4XDaisyVariants.NormalizeRounded(Value)
    RefreshIfReady
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

Public Sub setRoundedBox(Value As Boolean)
    mRoundedBox = Value
    RefreshIfReady
End Sub

Public Sub getRoundedBox As Boolean
    Return mRoundedBox
End Sub

Public Sub setShadow(Value As String)
    mShadow = B4XDaisyVariants.NormalizeShadow(Value)
    RefreshIfReady
End Sub

Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setBringToFront(Value As Boolean)
    mBringToFront = Value
    If mBase.IsInitialized And mBringToFront Then mBase.BringToFront
End Sub

Public Sub getBringToFront As Boolean
    Return mBringToFront
End Sub

Public Sub setBackgroundColor(Value As Int)
    mBackgroundColor = Value
    RefreshIfReady
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
    mBackgroundColor = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, ResolveMenuBackgroundColor)
    RefreshIfReady
End Sub

Public Sub setTextColor(Value As Int)
    mTextColor = Value
    RefreshIfReady
End Sub

Public Sub getTextColor As Int
    Return mTextColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
    mTextColor = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, VariantName, ResolveBaseTextColor)
    RefreshIfReady
End Sub

Public Sub setActiveColor(Value As Int)
    mActiveColor = Value
    RefreshIfReady
End Sub

Public Sub getActiveColor As Int
    Return mActiveColor
End Sub

Public Sub setActiveTextColor(Value As Int)
    mActiveTextColor = Value
    RefreshIfReady
End Sub

Public Sub getActiveTextColor As Int
    Return mActiveTextColor
End Sub

Public Sub setActiveBorder(Value As Boolean)
    mActiveBorder = Value
    RefreshIfReady
End Sub

Public Sub getActiveBorder As Boolean
    Return mActiveBorder
End Sub

Public Sub setDebugDividerBorders(Value As Boolean)
    mDebugDividerBorders = Value
    RefreshIfReady
End Sub

Public Sub getDebugDividerBorders As Boolean
    Return mDebugDividerBorders
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub
