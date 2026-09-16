B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

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
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
#DesignerProperty: Key: BringToFront, DisplayName: Bring To Front, FieldType: Boolean, DefaultValue: True, Description: Brings the full menu view above siblings after layout.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional surface background override.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional menu text color override.
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: Color, DefaultValue: 0x00000000, Description: Active menu color. Used as border or background based on ActiveBorder.
#DesignerProperty: Key: ActiveTextColor, DisplayName: Active Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Active item text color when ActiveBorder is False.
#DesignerProperty: Key: ActiveBorder, DisplayName: Active Border, FieldType: Boolean, DefaultValue: False, Description: Shows a left border for the active item instead of filling the item background.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize height to fit menu items.
#DesignerProperty: Key: BadgeSize, DisplayName: Badge Size, FieldType: String, DefaultValue: auto, List: auto|xs|sm|md|lg|xl, Description: Badge size. 'auto' follows menu size.
#DesignerProperty: Key: BadgeVariant, DisplayName: Badge Variant, FieldType: String, DefaultValue: neutral, List: neutral|primary|secondary|accent|info|success|warning|error|ghost, Description: Default badge color variant.
#DesignerProperty: Key: BadgeStyle, DisplayName: Badge Style, FieldType: String, DefaultValue: solid, List: solid|outline|soft|dash, Description: Default badge style.
#DesignerProperty: Key: RailMode, DisplayName: Rail Mode, FieldType: Boolean, DefaultValue: False, Description: Compact navigation rail mode that hides text and centers icons.
#DesignerProperty: Key: RightBorder, DisplayName: Right Border, FieldType: Boolean, DefaultValue: False, Description: Shows a vertical border line on the right edge of the menu.
#DesignerProperty: Key: RightBorderColor, DisplayName: Right Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Custom color for the right border line.

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
    Private mShadow As String = "none"
    Private mBringToFront As Boolean = True
    Private mBackgroundColor As Int = 0
    Private mTextColor As Int = 0
    Private mActiveColor As Int = 0
    Private mActiveTextColor As Int = 0
    Private mActiveBorder As Boolean = False
    Private mbAutoResize As Boolean = True
    Private msBadgeSize As String = "auto"
    Private msBadgeVariant As String = "neutral"
    Private msBadgeStyle As String = "solid"
    Private msBadgeRounded As String = "rounded-full"
    Private mUpdating As Boolean = False
    Private mAutoRefresh As Boolean = True
    Private mbRailMode As Boolean = False
    Private mbRightBorder As Boolean = False
    Private pnlRightBorderView As B4XView
    Private mRightBorderColor As Int = 0

    Private mItems As List
    Private mDividerViews As List
    Private mLevel As Int = 0
    Private mbPopup As Boolean = False
    Private mParentMenu As B4XDaisyMenu
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
    mDividerViews.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
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

    ApplyDesignerProps(mProps)
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mEnabled)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
    Dim widthSpec As String = B4XDaisyVariants.GetPropString(mProps, "Width", "w-full").ToLowerCase.Trim
    If widthSpec = "" Or widthSpec = "w-full" Or widthSpec = "full" Then
        mWidth = 0
        mWidthExplicit = False
        mWidthFull = True
    Else
        mWidth = Max(72dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", "w-56"))
        mWidthExplicit = True
        mWidthFull = False
    End If
    Dim heightSpec As String = B4XDaisyVariants.GetPropString(mProps, "Height", "h-auto").ToLowerCase.Trim
    If heightSpec = "" Or heightSpec = "h-auto" Or heightSpec = "auto" Then
        mHeightExplicit = False
        mHeight = 0
    Else
        mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", "h-10"))
        mHeightExplicit = True
    End If
    mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
    mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
    mDividers = B4XDaisyVariants.GetPropBool(mProps, "Dividers", mDividers)
    mDividerGap = B4XDaisyVariants.GetPropString(mProps, "DividerGap", mDividerGap)
    mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
    mOrientation = B4XDaisyVariants.NormalizeOrientation(B4XDaisyVariants.GetPropString(mProps, "Orientation", mOrientation))
    mRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded))

    ' Backward compatibility: migrate legacy RoundedBox=True designer prop
    If mProps.ContainsKey("RoundedBox") Then
        Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
        If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
            mRounded = "rounded-box"
        End If
    End If
    mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
    mBringToFront = B4XDaisyVariants.GetPropBool(mProps, "BringToFront", mBringToFront)
    mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
    mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
    mActiveColor = B4XDaisyVariants.GetPropColor(mProps, "ActiveColor", mActiveColor)
    mActiveTextColor = B4XDaisyVariants.GetPropColor(mProps, "ActiveTextColor", mActiveTextColor)
    mActiveBorder = B4XDaisyVariants.GetPropBool(mProps, "ActiveBorder", mActiveBorder)
    mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
    If mbAutoResize Then mHeightExplicit = False
    msBadgeSize = NormalizeBadgeSizeProp(B4XDaisyVariants.GetPropString(mProps, "BadgeSize", msBadgeSize))
    msBadgeVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "BadgeVariant", msBadgeVariant))
    msBadgeStyle = B4XDaisyVariants.GetPropString(mProps, "BadgeStyle", msBadgeStyle)
    msBadgeRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "BadgeRounded", msBadgeRounded))
    mbRightBorder = B4XDaisyVariants.GetPropBool(mProps, "RightBorder", mbRightBorder)
    mRightBorderColor = B4XDaisyVariants.GetPropColor(mProps, "RightBorderColor", mRightBorderColor)
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    Dim empty As B4XView
    If vParent.IsInitialized = False Then Return empty
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        Dim createW As Int = iWidth
        If createW <= 0 Then
            If UsesFullWidth And vParent.IsInitialized Then
                createW = Max(1dip, vParent.Width)
            Else
                createW = Max(1dip, GetPreferredWidth)
            End If
        End If
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, createW), Max(1dip, iHeight))
        Dim dummy As Label
        DesignerCreateView(b, dummy, BuildRuntimeProps(createW, iHeight))
    End If
    Dim targetH As Int = iHeight
    If targetH <= 0 Then
        If mHeightExplicit Then
            targetH = Max(1dip, mHeight)
        Else
            targetH = GetPreferredHeight
        End If
    End If
    Dim targetW As Int = iWidth
    If targetW <= 0 Then
        If UsesFullWidth And vParent.IsInitialized Then
            targetW = Max(1dip, vParent.Width)
        Else If mWidthExplicit Then
            targetW = Max(1dip, mWidth)
        Else
            targetW = Max(1dip, GetPreferredWidth)
        End If
    End If
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    vParent.AddView(mBase, iLeft, iTop, Max(1dip, targetW), Max(1dip, targetH))
    Base_Resize(Max(1dip, targetW), Max(1dip, targetH))
    Refresh
    If mBringToFront Then mBase.BringToFront
    Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
    Dim props As Map
    props.Initialize
    props.Put("Enabled", mEnabled)
    props.Put("Visible", mVisible)
    If UsesFullWidth Then
        props.Put("Width", "w-full")
    Else
        props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(Max(1dip, iWidth)))
    End If
    If mHeightExplicit Then
        props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(Max(1dip, iHeight)))
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
    props.Put("Shadow", mShadow)
    props.Put("BringToFront", mBringToFront)
    props.Put("BackgroundColor", mBackgroundColor)
    props.Put("TextColor", mTextColor)
    props.Put("ActiveColor", mActiveColor)
    props.Put("ActiveTextColor", mActiveTextColor)
    props.Put("ActiveBorder", mActiveBorder)
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
    LayoutRightBorder
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

    If mDividerViews.IsInitialized Then
        mDividerViews.Clear
    Else
        mDividerViews.Initialize
    End If

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

Private Sub EnsurePopupBase(Popup As B4XDaisyMenu, iWidth As Int, iHeight As Int)
    If Popup.IsInitialized = False Then Return
    If Popup.mBase.IsInitialized Then Return
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
    Dim dummy As Label
    Popup.DesignerCreateView(b, dummy, Popup.BuildRuntimeProps(iWidth, iHeight))
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

Private Sub AddBranchLine(rcOuterRect As B4XRect, rcContentRect As B4XRect)
    If Surface.IsInitialized = False Then Return
    Dim p As Panel
    p.Initialize("")
    Dim line As B4XView = p
    line.Color = ResolveDividerColor
    Dim lineX As Int = Max(0, rcContentRect.Left)
    Dim lineTop As Int = rcContentRect.Top + 12dip
    Dim lineBottom As Int = rcContentRect.Bottom - 12dip
    Dim lineHeight As Int = Max(1dip, lineBottom - lineTop)
    Surface.AddView(line, lineX, lineTop, 1dip, lineHeight)
End Sub

Private Sub AddAutoDivider(iLeft As Int, iTop As Int, iWidth As Int, sDirection As String) As Int
    Dim item As Map
    item.Initialize
    item.Put("kind", "auto-divider")
    Return AddDividerBlock(item, iLeft, iTop, iWidth, sDirection)
End Sub

Private Sub AddDividerBlock(mItem As Map, iLeft As Int, iTop As Int, iWidth As Int, sDirection As String) As Int
    Dim gap As Int = ResolveDividerGapDip
    Dim thickness As Int = ResolveDividerThicknessDip
    If sDirection = "horizontal" Then
        Dim rowH As Int = ResolveSizeSpec.Get("row_h")
        AddDividerSpacerView(iLeft, iTop, gap, rowH)
        AddDividerView(mItem, iLeft + gap, iTop, thickness, rowH, sDirection)
        AddDividerSpacerView(iLeft + gap + thickness, iTop, gap, rowH)
    Else
        AddDividerSpacerView(iLeft, iTop, iWidth, gap)
        AddDividerView(mItem, iLeft, iTop + gap, iWidth, thickness, sDirection)
        AddDividerSpacerView(iLeft, iTop + gap + thickness, iWidth, gap)
    End If
    Return ResolveDividerExtent
End Sub

Private Sub AddDividerView(mItem As Map, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int, sDirection As String) As Int
    Dim p As Panel
    p.Initialize("")
    Dim v As B4XView = p
    v.Color = ResolveDividerColor
    Surface.AddView(v, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    mItem.Put("view", v)
    If mDividerViews.IsInitialized Then mDividerViews.Add(v)
    Return ResolveDividerExtent
End Sub

Private Sub AddDividerSpacerView(iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim spacer As B4XView = p
    spacer.Color = xui.Color_Transparent
    Surface.AddView(spacer, iLeft, iTop, Max(0, iWidth), Max(0, iHeight))
    Return spacer
End Sub

Private Sub AddTitleView(mItem As Map, iLeft As Int, iTop As Int, iWidth As Int) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim titleH As Int = spec.Get("title_h")
    Dim l As Label
    l.Initialize("")
    Dim v As B4XView = l
    v.Color = xui.Color_Transparent
    v.Text = mItem.GetDefault("text", "")
    v.TextColor = ResolveTitleColor
    v.Font = xui.CreateDefaultBoldFont(spec.Get("title_font"))
    v.SetTextAlignment("CENTER", "LEFT")
    Surface.AddView(v, iLeft, iTop, iWidth, titleH)
    mItem.Put("view", v)
    Return titleH
End Sub

Private Sub AddRowView(mItem As Map, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int, bFillWidth As Boolean)
    Dim p As Panel
    p.Initialize("")
    Dim row As B4XView = p
    row.Color = xui.Color_Transparent
    Surface.AddView(row, iLeft, iTop, iWidth, iHeight)
    mItem.Put("view", row)
    mItem.Put("row_left", iLeft)
    LayoutRowContent(row, mItem, iWidth, iHeight, bFillWidth)
End Sub

Private Sub LayoutRowContent(vRow As B4XView, mItem As Map, iWidth As Int, iHeight As Int, bFillWidth As Boolean)
    Dim spec As Map = ResolveSizeSpec
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim rowRadius As Float = B4XDaisyVariants.GetRadiusFieldDip(8dip)
    Dim textColor As Int = ResolveRowTextColor(mItem)
    Dim backColor As Int = ResolveRowBackgroundColor(mItem)
    vRow.SetColorAndBorder(backColor, 0, xui.Color_Transparent, rowRadius)
    If mItem.GetDefault("active", False) And mActiveBorder Then
        Dim pBorder As Panel
        pBorder.Initialize("")
        Dim activeBorderView As B4XView = pBorder
        activeBorderView.Color = ResolveActiveColor
        vRow.AddView(activeBorderView, 0, 4dip, 3dip, Max(1dip, iHeight - 8dip))
    End If

    Dim leftX As Int = px
    Dim rightX As Int = iWidth - px
    Dim singleRowH As Int = spec.Get("row_h")
    Dim centerY As Int = Min(iHeight, singleRowH) / 2
    Dim text As String = mItem.GetDefault("text", "")
    Dim iconName As String = GetMapString(mItem, "icon")
    Dim badgeTextValue As String = GetMapString(mItem, "badge_text")
    Dim badgeVariantValue As String = GetMapString(mItem, "badge_variant")
    Dim hasIcon As Boolean = iconName.Trim.Length > 0
    Dim rowHasAvatar As Boolean = HasAvatar(mItem)
    Dim rowHasBadge As Boolean = HasBadge(mItem)
    Dim hasChevron As Boolean = mItem.Get("kind") = "submenu"
    Dim iconOnly As Boolean = IsIconOnlyItem(mItem)
    Dim isRailOrIconOnly As Boolean = mbRailMode Or iconOnly

    If rowHasAvatar Then
        Dim avatarSize As Int = spec.Get("avatar")
        Dim avatarComp As B4XDaisyAvatar
        avatarComp.Initialize(Me, "")
        Dim avatarLeft As Int = leftX
        If isRailOrIconOnly Then avatarLeft = Max(0, (iWidth - avatarSize) / 2)
        Dim avatarView As B4XView = avatarComp.AddToParent(vRow, avatarLeft, centerY - (avatarSize / 2), avatarSize, avatarSize)
        avatarComp.setClickable(False)
        Dim avObj As Object = mItem.Get("avatar")
        If avObj Is B4XBitmap Then
            avatarComp.setAvatarBitmap(avObj, "")
        Else
            Dim avPath As String = avObj
            avatarComp.setImage(avPath)
        End If
        Dim avatarMask As String = mItem.GetDefault("avatar_shape", "circle")
        If avatarMask.Trim.Length > 0 Then avatarComp.setMask(avatarMask)
        avatarComp.ResizeToParent(avatarView)
        mItem.Put("avatar_view", avatarView)
        mItem.Put("avatar_comp", avatarComp)
        If isRailOrIconOnly Then
            leftX = avatarLeft
            rightX = avatarLeft + avatarSize
        Else
            leftX = leftX + avatarSize + gap
        End If
    End If

    If hasIcon Then
        Dim icon As B4XDaisySvgIcon
        icon.Initialize(Me, "")
        Dim iconLeft As Int = leftX
        If isRailOrIconOnly And rowHasAvatar = False Then iconLeft = Max(0, (iWidth - iconSize) / 2)
        Dim iconView As B4XView = icon.AddToParent(vRow, iconLeft, centerY - (iconSize / 2), iconSize, iconSize)
        icon.SetClickable(False)
        icon.SvgAsset = mItem.Get("icon")
        icon.PreserveOriginalColors = False
        icon.Color = textColor
        icon.ResizeToParent(iconView)
        mItem.Put("icon_view", iconView)
        If isRailOrIconOnly And rowHasAvatar = False Then
            leftX = iconLeft
            rightX = iconLeft + iconSize
        Else
            leftX = leftX + iconSize + gap
        End If
    End If

    If hasChevron Then
        Dim chevronSize As Int = Max(12dip, iconSize - 2dip)
        Dim chevronView As B4XView = AddSubmenuChevronView(vRow, mItem, rightX - chevronSize, centerY - (chevronSize / 2), chevronSize, textColor)
        chevronView.Visible = Not(mbRailMode)
        rightX = rightX - chevronSize - gap
        mItem.Put("chevron_view", chevronView)
    End If

    If rowHasBadge Then
        Dim badge As B4XDaisyBadge
        badge.Initialize(Me, "")
        Dim badgeText As String = mItem.GetDefault("badge_text", "")
        Dim badgeVariant As String = mItem.GetDefault("badge_variant", "")
        If badgeVariant = "" Or badgeVariant = "none" Then badgeVariant = msBadgeVariant
        If badgeVariant = "" Or badgeVariant = "none" Then badgeVariant = "neutral"
        Dim badgeSpec As Map = ResolveBadgeSpec(mItem)
        Dim badgeW As Int = EstimateBadgeWidth(mItem, badgeText)
        Dim badgeH As Int = badgeSpec.Get("height")
        Dim badgeView As B4XView = badge.AddToParent(vRow, rightX - badgeW, centerY - (badgeH / 2), badgeW, badgeH)
        badge.SetClickable(False)
        badge.Text = badgeText
        badge.Size = badgeSpec.Get("size")
        badge.Variant = badgeVariant
        Dim rounded As String = mItem.GetDefault("badge_rounded", "")
        If rounded = "" Then rounded = msBadgeRounded
        If rounded = "" Then rounded = "rounded-full"
        badge.setRounded(rounded)
        If badgeText.Length = 0 Then
            badge.setWidth(B4XDaisyVariants.ResolvePxSizeSpec(badgeW))
            badge.setHeight(B4XDaisyVariants.ResolvePxSizeSpec(badgeH))
        End If
        Dim style As String = mItem.GetDefault("badge_style", "")
        If style = "" Or style = "none" Then style = msBadgeStyle
        If style = "" Or style = "none" Then style = "solid"
        If style.Length > 0 Then badge.BadgeStyle = style
        If mItem.GetDefault("badge_background_color", 0) <> 0 Then badge.BackgroundColor = mItem.Get("badge_background_color")
        If mItem.GetDefault("badge_text_color", 0) <> 0 Then badge.TextColor = mItem.Get("badge_text_color")
        badgeView.Visible = Not(mbRailMode)
        rightX = rightX - badgeW - gap
        mItem.Put("badge_view", badgeView)
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
        If iHeight > singleLineH Then
            ' Multiline: top-align text with vertical padding so it sits inside the expanded row
            Dim vertPad As Int = Max(0, (singleLineH - Ceil(spec.Get("font") * 1dip)) / 2)
            textView.SetTextAlignment("TOP", "LEFT")
            vRow.AddView(textView, leftX, vertPad, Max(1dip, rightX - leftX), Max(1dip, iHeight - 2 * vertPad))
        Else
            ' Single-line: span the full row height and let CENTER alignment handle vertical positioning
            textView.SetTextAlignment("CENTER", "LEFT")
            vRow.AddView(textView, leftX, 0, Max(1dip, rightX - leftX), iHeight)
        End If
        textView.Visible = Not(mbRailMode)
        mItem.Put("text_view", textView)
    End If

    Dim hit As Panel
    hit.Initialize("row")
    Dim hitView As B4XView = hit
    hitView.Color = xui.Color_Transparent
    hitView.Tag = mItem
    hitView.Enabled = mEnabled And (mItem.GetDefault("disabled", False) = False)
    vRow.AddView(hitView, 0, 0, iWidth, iHeight)
    mItem.Put("hit_view", hitView)
End Sub

Private Sub row_Click
    If mEnabled = False Then Return
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

Private Sub submenuchild_Click(oTag As Object)
    RaiseClick(oTag)
End Sub

Private Sub submenuchild_ItemClick(oTag As Object, sText As String)
    RaiseItem(oTag, sText)
End Sub

Private Sub submenuchild_SubmenuToggle(oTag As Object, bOpen As Boolean)
    RaiseSubmenuToggle(oTag, bOpen)
End Sub

Private Sub RaiseItem(oTag As Object, sText As String)
    RaiseClick(oTag)
    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 2) Then
        CallSub3(mCallBack, mEventName & "_ItemClick", oTag, sText)
    End If
End Sub

Private Sub RaiseClick(oTag As Object)
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", oTag)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub

Private Sub RaiseSubmenuToggle(oTag As Object, bOpen As Boolean)
    If xui.SubExists(mCallBack, mEventName & "_SubmenuToggle", 2) Then
        CallSub3(mCallBack, mEventName & "_SubmenuToggle", oTag, bOpen)
    End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    EnsureHostStructure
    LayoutHosts(dWidth, dHeight)
    If mBringToFront Then mBase.BringToFront
    LayoutRightBorder
    inResize = False
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

Public Sub AddTitle(sText As String) As Int
    Dim item As Map = CreateItem("title", sText, sText, "", "", "", "none")
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

Public Sub AddItem(oTagValue As Object, sText As String) As Int
    If oTagValue = Null Then Return -1
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", sText, oTagValue, "", "", "", "none")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddIconItem(oTagValue As Object, sText As String, sIconName As String) As Int
    If oTagValue = Null Then Return -1
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", sText, oTagValue, sIconName, "", "", "none")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddBadgeItem(oTagValue As Object, sText As String, sBadgeText As String, sBadgeVariant As String) As Int
    If oTagValue = Null Then Return -1
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", sText, oTagValue, "", sBadgeText, sBadgeVariant, "solid")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddIconBadgeItem(oTagValue As Object, sText As String, sIconName As String, sBadgeText As String, sBadgeVariant As String) As Int
    If oTagValue = Null Then Return -1
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", sText, oTagValue, sIconName, sBadgeText, sBadgeVariant, "solid")
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddAvatarItem(oTagValue As Object, sText As String, oAvatar As Object, sAvatarShape As String) As Int
    If oTagValue = Null Then Return -1
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", sText, oTagValue, "", "", "", "none")
    item.Put("avatar", oAvatar)
    If sAvatarShape <> Null And sAvatarShape.Trim.Length > 0 Then item.Put("avatar_shape", sAvatarShape)
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddAvatarBadgeItem(oTagValue As Object, sText As String, oAvatar As Object, sAvatarShape As String, sBadgeText As String, sBadgeVariant As String) As Int
    If oTagValue = Null Then Return -1
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return -1
    End If
    Dim item As Map = CreateItem("item", sText, oTagValue, "", sBadgeText, sBadgeVariant, "solid")
    item.Put("avatar", oAvatar)
    If sAvatarShape <> Null And sAvatarShape.Trim.Length > 0 Then item.Put("avatar_shape", sAvatarShape)
    mItems.Add(item)
    RefreshIfReady
    Return mItems.Size - 1
End Sub

Public Sub AddAvatarChildItem(oParentTag As Object, oTagValue As Object, sText As String, oAvatar As Object, sAvatarShape As String) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Return targetMenu.AddAvatarItem(oTagValue, sText, oAvatar, sAvatarShape)
End Sub

Public Sub AddAvatarBadgeChildItem(oParentTag As Object, oTagValue As Object, sText As String, oAvatar As Object, sAvatarShape As String, sBadgeText As String, sBadgeVariant As String) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Return targetMenu.AddAvatarBadgeItem(oTagValue, sText, oAvatar, sAvatarShape, sBadgeText, sBadgeVariant)
End Sub

Public Sub AddItemParent(oParentTag As Object, oTagValue As Object, sText As String, sIconName As String) As B4XDaisyMenu
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Dim child As B4XDaisyMenu = targetMenu.AddSubmenu(oTagValue, sText, False)
    If sIconName <> Null And sIconName.Trim.Length > 0 Then
        targetMenu.SetItemIcon(oTagValue, sIconName)
    End If
    Return child
End Sub

Public Sub AddItemChild(oParentTag As Object, oTagValue As Object, sText As String, sIconName As String) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    If sIconName <> Null And sIconName.Trim.Length > 0 Then
        Return targetMenu.AddIconItem(oTagValue, sText, sIconName)
    Else
        Return targetMenu.AddItem(oTagValue, sText)
    End If
End Sub

Public Sub AddBadgeChildItem(oParentTag As Object, oTagValue As Object, sText As String, sBadgeText As String, sBadgeVariant As String) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Return targetMenu.AddBadgeItem(oTagValue, sText, sBadgeText, sBadgeVariant)
End Sub

Public Sub AddIconBadgeChildItem(oParentTag As Object, oTagValue As Object, sText As String, sIconName As String, sBadgeText As String, sBadgeVariant As String) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Return targetMenu.AddIconBadgeItem(oTagValue, sText, sIconName, sBadgeText, sBadgeVariant)
End Sub

Public Sub AddTitleChild(oParentTag As Object, sText As String) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Return targetMenu.AddTitle(sText)
End Sub

Public Sub AddDividerChild(oParentTag As Object) As Int
    Dim targetMenu As B4XDaisyMenu = ResolveTargetMenuForParent(oParentTag)
    Return targetMenu.AddDivider
End Sub

Public Sub FindSubmenuMenuByTag(oTagValue As Object) As B4XDaisyMenu
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized And item.ContainsKey("submenu") Then
        Dim child As B4XDaisyMenu = item.Get("submenu")
        Return child
    End If
    Dim empty As B4XDaisyMenu
    Return empty
End Sub

Private Sub ResolveTargetMenuForParent(oParentTag As Object) As B4XDaisyMenu
    If oParentTag <> Null Then
        If oParentTag Is String Then
            Dim pt As String = oParentTag
            If pt.Trim.Length > 0 Then
                Dim found As B4XDaisyMenu = ResolveRootMenu.FindSubmenuMenuByTag(oParentTag)
                If found.IsInitialized Then Return found
            End If
        Else
            Dim foundObj As B4XDaisyMenu = ResolveRootMenu.FindSubmenuMenuByTag(oParentTag)
            If foundObj.IsInitialized Then Return foundObj
        End If
    End If
    Return Me
End Sub

Public Sub LoadFromList(lstItemsList As List)
    If lstItemsList = Null Or lstItemsList.IsInitialized = False Then Return
    Clear
    AddItems(lstItemsList)
End Sub

Public Sub AddItems(lstItemsList As List)
    If lstItemsList = Null Or lstItemsList.IsInitialized = False Then Return
    For i = 0 To lstItemsList.Size - 1
        Dim raw As Object = lstItemsList.Get(i)
        If raw Is Map Then
            Dim m As Map = raw
            Dim kind As String = m.GetDefault("kind", "")
            Dim tagVal As Object = m.GetDefault("tag", m.GetDefault("key", m.GetDefault("id", "")))
            Dim parentVal As Object = m.GetDefault("parent", m.GetDefault("parent_id", m.GetDefault("parent_tag", "")))
            Dim textVal As String = m.GetDefault("text", m.GetDefault("title", m.GetDefault("label", "")))
            Dim iconVal As String = m.GetDefault("icon", "")
            Dim avatarVal As Object = m.GetDefault("avatar", m.GetDefault("image", ""))
            Dim avatarShapeVal As String = m.GetDefault("avatar_shape", m.GetDefault("avatar_mask", "circle"))
            Dim badgeTextVal As String = m.GetDefault("badge", m.GetDefault("badge_text", ""))
            Dim badgeVariantVal As String = m.GetDefault("badge_variant", m.GetDefault("badge_color", ""))
            Dim isParent As Boolean = m.GetDefault("is_parent", False)
            If kind.ToLowerCase = "submenu" Or kind.ToLowerCase = "collapse-item" Then isParent = True

            If kind.ToLowerCase = "title" Then
                AddTitleChild(parentVal, textVal)
            Else If kind.ToLowerCase = "divider" Then
                AddDividerChild(parentVal)
            Else If isParent Then
                Dim subChild As B4XDaisyMenu = AddItemParent(parentVal, tagVal, textVal, iconVal)
                If badgeTextVal.Trim.Length > 0 Or badgeVariantVal.Trim.Length > 0 Then
                    SetItemBadgeText(tagVal, badgeTextVal)
                    If badgeVariantVal.Trim.Length > 0 Then SetItemBadgeVariant(tagVal, badgeVariantVal)
                End If
                If m.GetDefault("open", False) Then SetItemOpen(tagVal, True)
            Else If avatarVal <> Null And (avatarVal Is B4XBitmap Or (avatarVal Is String And ("" & avatarVal).Trim.Length > 0)) Then
                If badgeTextVal.Trim.Length > 0 Or badgeVariantVal.Trim.Length > 0 Then
                    AddAvatarBadgeChildItem(parentVal, tagVal, textVal, avatarVal, avatarShapeVal, badgeTextVal, badgeVariantVal)
                Else
                    AddAvatarChildItem(parentVal, tagVal, textVal, avatarVal, avatarShapeVal)
                End If
            Else If badgeTextVal.Trim.Length > 0 Or badgeVariantVal.Trim.Length > 0 Then
                If iconVal.Trim.Length > 0 Then
                    AddIconBadgeChildItem(parentVal, tagVal, textVal, iconVal, badgeTextVal, badgeVariantVal)
                Else
                    AddBadgeChildItem(parentVal, tagVal, textVal, badgeTextVal, badgeVariantVal)
                End If
            Else
                AddItemChild(parentVal, tagVal, textVal, iconVal)
            End If

            If m.GetDefault("active", False) Then SetItemActive(tagVal, True)
            If m.GetDefault("disabled", False) Then SetItemDisabled(tagVal, True)
            If m.ContainsKey("badge_size") Then SetItemBadgeSize(tagVal, m.Get("badge_size"))
            If m.ContainsKey("badge_style") Then SetItemBadgeStyle(tagVal, m.Get("badge_style"))
            If m.ContainsKey("badge_rounded") Then SetItemBadgeRounded(tagVal, m.Get("badge_rounded"))
        End If
    Next
    RefreshIfReady
End Sub

Public Sub AddSubmenu(oTagValue As Object, sText As String, bInitiallyOpen As Boolean) As B4XDaisyMenu
    Dim child As B4XDaisyMenu
    If oTagValue = Null Then Return child
    If oTagValue Is String Then
        Dim tagText As String = oTagValue
        If tagText.Trim.Length = 0 Then Return child
    End If
    child.Initialize(Me, "submenuchild")
    child.SetLevelInternal(mLevel + 1)
    child.SetParentMenuInternal(Me)
    child.Size = mSize
    child.BadgeSize = msBadgeSize
    child.BadgeVariant = msBadgeVariant
    child.BadgeStyle = msBadgeStyle
    child.BadgeRounded = msBadgeRounded
    child.Enabled = mEnabled
    child.Visible = True
    child.Orientation = "vertical"
    If mBackgroundColor <> 0 Then child.BackgroundColor = mBackgroundColor
    Dim item As Map = CreateItem("submenu", sText, oTagValue, "", "", "", "none")
    item.Put("submenu", child)
    item.Put("open", bInitiallyOpen)
    mItems.Add(item)
    RefreshIfReady
    Return child
End Sub

Private Sub CreateItem(sKind As String, sText As String, oTagValue As Object, sIconName As String, sBadgeText As String, sBadgeVariant As String, sBadgeStyle As String) As Map
    Dim item As Map
    item.Initialize
    item.Put("kind", sKind)
    item.Put("text", sText)
    item.Put("tag", oTagValue)
    item.Put("icon", sIconName)
    item.Put("avatar", "")
    item.Put("avatar_shape", "circle")
    item.Put("badge_text", sBadgeText)
    If sBadgeVariant.Trim.Length > 0 And sBadgeVariant.ToLowerCase <> "none" Then
        item.Put("badge_variant", B4XDaisyVariants.NormalizeVariant(sBadgeVariant))
    Else
        item.Put("badge_variant", "")
    End If
    If sBadgeStyle.Trim.Length > 0 And sBadgeStyle.ToLowerCase <> "none" Then
        item.Put("badge_style", sBadgeStyle)
    Else
        item.Put("badge_style", "")
    End If
    item.Put("badge_size", "")
    item.Put("badge_rounded", "")
    item.Put("badge_background_color", 0)
    item.Put("badge_text_color", 0)
    item.Put("disabled", False)
    item.Put("active", False)
    item.Put("open", False)
    Return item
End Sub

Public Sub SetItemDisabled(oTagValue As Object, bValue As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("disabled", bValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub ClearActive
    ResolveRootMenu.ClearActiveRecursive
    RefreshIfReady
End Sub

' Scrolls the vertical scroll view so the item with the given tag is visible.
' Has no effect when the menu has no explicit height / scroll mode is not vertical.
Public Sub ScrollToItem(oTagValue As Object)
    If msScrollMode <> "vertical" Then Return
    If mVScrollView.IsInitialized = False Then Return
    Dim item As Map = FindItemByTagRecursive(Me, oTagValue)
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

Private Sub SetItemActiveByIndex(iIndex As Int, bValue As Boolean)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    If bValue Then
        ResolveRootMenu.ClearActiveRecursive
    End If
    Dim item As Map = mItems.Get(iIndex)
    item.Put("active", bValue)
    RefreshIfReady
End Sub

Public Sub SetItemActive(oTagValue As Object, bValue As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    If bValue Then root.ClearActiveRecursive
    item.Put("active", bValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetSubmenuOpen(iIndex As Int, bValue As Boolean)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    Dim item As Map = mItems.Get(iIndex)
    If item.GetDefault("kind", "") <> "submenu" Then Return
    ToggleSubmenuItem(item, bValue, 0)
End Sub

Public Sub SetItemBadgeText(oTagValue As Object, sValue As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_text", sValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeBackgroundColor(oTagValue As Object, iColor As Int)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_background_color", iColor)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeTextColor(oTagValue As Object, iColor As Int)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_text_color", iColor)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeVariant(oTagValue As Object, sValue As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_variant", B4XDaisyVariants.NormalizeVariant(sValue))
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeSize(oTagValue As Object, sValue As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_size", sValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeStyle(oTagValue As Object, sValue As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_style", sValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemBadgeRounded(oTagValue As Object, sValue As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("badge_rounded", B4XDaisyVariants.NormalizeRounded(sValue))
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemText(oTagValue As Object, sValue As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("text", sValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemIcon(oTagValue As Object, sIconName As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("icon", sIconName)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemVisible(oTagValue As Object, bValue As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("visible", bValue)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemAvatar(oTagValue As Object, oAvatar As Object)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("avatar", oAvatar)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemAvatarShape(oTagValue As Object, sShape As String)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized = False Then Return
    item.Put("avatar_shape", sShape)
    Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
    If owner.IsInitialized Then owner.RefreshIfReady Else root.RefreshIfReady
End Sub

Public Sub SetItemOpen(oTagValue As Object, bValue As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    Dim item As Map = root.FindItemByTagRecursive(root, oTagValue)
    If item.IsInitialized And item.GetDefault("kind", "") = "submenu" Then
        Dim owner As B4XDaisyMenu = root.FindOwningMenuByTagRecursive(root, oTagValue)
        If owner.IsInitialized Then
            owner.ToggleSubmenuItem(item, bValue, 0)
        Else
            root.ToggleSubmenuItem(item, bValue, 0)
        End If
    End If
End Sub

Public Sub OpenParents
    SetParentsOpen(True)
End Sub

Public Sub CloseParents
    SetParentsOpen(False)
End Sub

Public Sub OpenAllSubmenus
    SetParentsOpen(True)
End Sub

Public Sub CloseAllSubmenus
    SetParentsOpen(False)
End Sub

Public Sub SetParentsOpen(bOpenState As Boolean)
    Dim root As B4XDaisyMenu = ResolveRootMenu
    root.BeginUpdate
    root.SetParentsOpenInternal(bOpenState)
    root.EndUpdate
End Sub

Private Sub SetParentsOpenInternal(bOpenState As Boolean)
    If mItems.IsInitialized = False Then Return
    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        If item.GetDefault("kind", "") = "submenu" Then
            item.Put("open", bOpenState)
            Dim child As B4XDaisyMenu = item.Get("submenu")
            If child.IsInitialized Then child.SetParentsOpenInternal(bOpenState)
        End If
    Next
End Sub

Public Sub GetItemView(iIndex As Int) As B4XView
    Dim empty As B4XView
    If iIndex < 0 Or iIndex >= mItems.Size Then Return empty
    Dim item As Map = mItems.Get(iIndex)
    If item.ContainsKey("view") Then Return item.Get("view")
    Return empty
End Sub

Public Sub GetPreferredHeight As Int
    If mHeightExplicit Then Return Max(1dip, mHeight)
    Return Max(Ceil(B4XDaisyBoxModel.ExpandContentHeight(MeasureMenuContentHeight(False), BuildRootBoxModel)), ResolveMinimumHeight)
End Sub

Private Sub MeasureMenuContentHeight(bIncludePopupSurface As Boolean) As Int
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
                        If bIncludePopupSurface Then
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

Private Sub EstimateRowWidth(mItem As Map) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim avatarSize As Int = spec.Get("avatar")
    Dim fontSize As Float = spec.Get("font")
    Dim text As String = mItem.GetDefault("text", "")
    Dim w As Int = px * 2
    Dim kind As String = mItem.GetDefault("kind", "")
    If kind = "divider" Then Return 60dip
    If kind = "title" Then
        Return px * 2 + B4XDaisyVariants.MeasureTextWidthSafe(text, spec.Get("title_font"), Typeface.DEFAULT_BOLD, 8dip)
    End If
    If IsIconOnlyItem(mItem) Then
        If HasAvatar(mItem) Then Return Max(avatarSize + (px * 2), spec.Get("row_h"))
        Return Max(iconSize + (px * 2), spec.Get("row_h"))
    End If
    If HasAvatar(mItem) Then w = w + avatarSize + gap
    If GetMapString(mItem, "icon").Trim.Length > 0 Then w = w + iconSize + gap
    w = w + B4XDaisyVariants.MeasureTextWidthSafe(text, fontSize, Typeface.DEFAULT, 8dip)
    If HasBadge(mItem) Then
        w = w + EstimateBadgeWidth(mItem, mItem.GetDefault("badge_text", "")) + gap
    End If
    If kind = "submenu" Then w = w + 14dip + gap
    Return Max(w, 72dip)
End Sub

Private Sub NormalizeBadgeSizeProp(sValue As String) As String
    If sValue = Null Then Return "auto"
    Dim s As String = sValue.ToLowerCase.Trim
    If s = "" Or s = "auto" Then Return "auto"
    Return B4XDaisyVariants.NormalizeSize(s)
End Sub

Private Sub ResolveBadgeSizeToken(mItem As Map) As String
    If mItem.IsInitialized Then
        Dim itemSize As String = GetMapString(mItem, "badge_size").Trim
        If itemSize.Length > 0 And itemSize <> "auto" Then
            Return B4XDaisyVariants.NormalizeSize(itemSize)
        End If
    End If
    If msBadgeSize <> Null And msBadgeSize.Trim.Length > 0 And msBadgeSize.ToLowerCase <> "auto" Then
        Return B4XDaisyVariants.NormalizeSize(msBadgeSize)
    End If
    Return B4XDaisyVariants.NormalizeSize(mSize)
End Sub

Private Sub EstimateBadgeWidth(mItem As Map, sText As String) As Int
    Dim badgeSpec As Map = ResolveBadgeSpec(mItem)
    If sText.Length = 0 Then Return badgeSpec.Get("height")
    Dim content As String = sText
    Return Max(badgeSpec.Get("min_w"), B4XDaisyVariants.MeasureTextWidthSafe(content, badgeSpec.Get("font"), Typeface.DEFAULT_BOLD, badgeSpec.Get("buffer")))
End Sub

Private Sub HasAvatar(mItem As Map) As Boolean
    If mItem.IsInitialized = False Then Return False
    If mItem.ContainsKey("avatar") Then
        Dim avObj As Object = mItem.Get("avatar")
        If avObj <> Null Then
            If avObj Is B4XBitmap Then Return True
            If avObj Is String Then
                Dim avStr As String = avObj
                If avStr.Trim.Length > 0 Then Return True
            End If
        End If
    End If
    Return False
End Sub

Private Sub HasBadge(mItem As Map) As Boolean
    If GetMapString(mItem, "badge_text").Trim.Length > 0 Then Return True
    Dim v As String = GetMapString(mItem, "badge_variant").Trim
    If v.Length > 0 And v.ToLowerCase <> "none" Then Return True
    If mItem.GetDefault("badge_background_color", 0) <> 0 Then Return True
    If mItem.GetDefault("badge_text_color", 0) <> 0 Then Return True
    Return False
End Sub

Private Sub ResolveBadgeSpec(mItem As Map) As Map
    Dim effectiveSize As String = ResolveBadgeSizeToken(mItem)
    Select Case effectiveSize
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
            Return CreateMap("row_h": 24dip, "font": 11, "title_font": 10, "title_h": 24dip, "pad_x": 8dip, "gap": 6dip, "icon": 14dip, "avatar": 16dip)
        Case "sm"
            Return CreateMap("row_h": 28dip, "font": 12, "title_font": 11, "title_h": 26dip, "pad_x": 10dip, "gap": 6dip, "icon": 16dip, "avatar": 20dip)
        Case "lg"
            Return CreateMap("row_h": 42dip, "font": 18, "title_font": 15, "title_h": 34dip, "pad_x": 16dip, "gap": 8dip, "icon": 20dip, "avatar": 28dip)
        Case "xl"
            Return CreateMap("row_h": 50dip, "font": 22, "title_font": 17, "title_h": 38dip, "pad_x": 20dip, "gap": 10dip, "icon": 22dip, "avatar": 32dip)
        Case Else
            Return CreateMap("row_h": 34dip, "font": 14, "title_font": 13, "title_h": 28dip, "pad_x": 12dip, "gap": 8dip, "icon": 20dip, "avatar": 24dip)
    End Select
End Sub

Private Sub MeasureItemRowHeight(mItem As Map, iContentWidth As Int) As Int
    Dim spec As Map = ResolveSizeSpec
    Dim rowH As Int = spec.Get("row_h")
    If iContentWidth <= 0 Then Return rowH
    Dim kind As String = mItem.GetDefault("kind", "item")
    If kind <> "item" And kind <> "submenu" Then Return rowH
    If IsIconOnlyItem(mItem) Then Return rowH
    Dim text As String = mItem.GetDefault("text", "")
    If text.Trim.Length = 0 Then Return rowH
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim avatarSize As Int = spec.Get("avatar")
    Dim fontSize As Float = spec.Get("font")
    Dim textAreaW As Int = iContentWidth - (px * 2)
    If HasAvatar(mItem) Then textAreaW = textAreaW - avatarSize - gap
    If GetMapString(mItem, "icon").Trim.Length > 0 Then textAreaW = textAreaW - iconSize - gap
    If kind = "submenu" Then textAreaW = textAreaW - Max(12dip, iconSize - 2dip) - gap
    If HasBadge(mItem) Then textAreaW = textAreaW - EstimateBadgeWidth(mItem, mItem.GetDefault("badge_text", "")) - gap
    If textAreaW < 40dip Then Return rowH
    Dim textW As Int = B4XDaisyVariants.MeasureTextWidthSafe(text, fontSize, Typeface.DEFAULT, 0)
    If textW <= textAreaW Then Return rowH
    Dim lineH As Int = Ceil(fontSize * 1dip * 1.4)
    Dim vertPad As Int = Max(4dip, (rowH - Ceil(fontSize * 1dip)) / 2)
    Dim lines As Int = Ceil(textW / textAreaW)
    Return Max(rowH, lines * lineH + vertPad * 2)
End Sub

Private Sub IsIconOnlyItem(mItem As Map) As Boolean
    If mItem.IsInitialized = False Then Return False
    If mItem.GetDefault("kind", "") <> "item" Then Return False
    If HasAvatar(mItem) = False And GetMapString(mItem, "icon").Trim.Length = 0 Then Return False
    If GetMapString(mItem, "text").Trim.Length > 0 Then Return False
    If HasBadge(mItem) Then Return False
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
    If mOrientation = "vertical" And (IsIconOnlyMenu Or mbRailMode) Then Return 0
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

Private Sub ResolveOuterRect(dWidth As Double, dHeight As Double) As B4XRect
    Dim host As B4XRect
    host.Initialize(0, 0, Max(1dip, dWidth), Max(1dip, dHeight))
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

Private Sub LayoutHosts(dWidth As Double, dHeight As Double)
    If mScrollHost.IsInitialized = False Then Return
    Dim outerRect As B4XRect = ResolveOuterRect(dWidth, dHeight)
    mScrollHost.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
    If msScrollMode = "vertical" Or msScrollMode = "horizontal" Then
        If mScrollView.IsInitialized Then mScrollView.SetLayoutAnimated(0, 0, 0, outerRect.Width, outerRect.Height)
    End If

    Dim surfaceW As Int = Max(1dip, outerRect.Width)
    Dim surfaceH As Int = Max(1dip, outerRect.Height)
    If msScrollMode = "vertical" Then
        surfaceH = Max(surfaceH, GetPreferredSurfaceHeight)
        If mVScrollView.IsInitialized Then
            mVScrollView.Panel.Width = surfaceW
            mVScrollView.Panel.Height = surfaceH
        End If
    Else If msScrollMode = "horizontal" Then
        surfaceW = Max(surfaceW, GetPreferredSurfaceWidth)
        surfaceH = Max(surfaceH, GetPreferredSurfaceHeight)
        If mHScrollView.IsInitialized Then
            mHScrollView.Panel.Width = surfaceW
            mHScrollView.Panel.Height = surfaceH
        End If
    End If
    Surface.SetLayoutAnimated(0, 0, 0, surfaceW, surfaceH)
End Sub

Private Sub UpdateScrollContentSize
    If msScrollMode = "vertical" Then
        Dim h As Int = Max(GetPreferredSurfaceHeight, mScrollHost.Height)
        If mVScrollView.IsInitialized Then
            mVScrollView.Panel.Height = h
            mVScrollView.Panel.Width = mScrollHost.Width
        End If
        Surface.SetLayoutAnimated(0, 0, 0, mScrollHost.Width, h)
    Else If msScrollMode = "horizontal" Then
        Dim w As Int = Max(GetPreferredSurfaceWidth, mScrollHost.Width)
        Dim h2 As Int = Max(GetPreferredSurfaceHeight, mScrollHost.Height)
        If mHScrollView.IsInitialized Then
            mHScrollView.Panel.Width = w
            mHScrollView.Panel.Height = h2
        End If
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

Private Sub AddSubmenuChevronView(vParent As B4XView, mItem As Map, iLeft As Int, iTop As Int, iSize As Int, iColor As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim v As B4XView = p
    v.Color = xui.Color_Transparent
    vParent.AddView(v, iLeft, iTop, iSize, iSize)
    Dim cvs As B4XCanvas
    cvs.Initialize(v)
    DrawSubmenuChevron(cvs, mItem.GetDefault("open", False), iColor)
    mItem.Put("chevron_canvas", cvs)
    Return v
End Sub

Private Sub DrawSubmenuChevron(cvsTargetCanvas As B4XCanvas, bIsOpen As Boolean, iColor As Int)
    cvsTargetCanvas.ClearRect(cvsTargetCanvas.TargetRect)
    Dim w As Float = cvsTargetCanvas.TargetRect.Width
    Dim h As Float = cvsTargetCanvas.TargetRect.Height
    Dim stroke As Float = Max(1.5dip, Min(w, h) * 0.12)
    Dim path As B4XPath
    If bIsOpen Then
        path.Initialize(w * 0.2, h * 0.6)
        path.LineTo(w * 0.5, h * 0.3)
        path.LineTo(w * 0.8, h * 0.6)
    Else
        path.Initialize(w * 0.2, h * 0.4)
        path.LineTo(w * 0.5, h * 0.7)
        path.LineTo(w * 0.8, h * 0.4)
    End If
    cvsTargetCanvas.DrawPath(path, iColor, False, stroke)
    cvsTargetCanvas.Invalidate
End Sub

Private Sub ResolveRowBackgroundColor(mItem As Map) As Int
    If mItem.GetDefault("active", False) Then
        If mActiveBorder Then Return xui.Color_Transparent
        Return ResolveActiveColor
    End If
    Return xui.Color_Transparent
End Sub

Private Sub ResolveRowTextColor(mItem As Map) As Int
    ' When the whole menu is disabled (mEnabled = False) every row reads as muted,
    ' matching the per-item disabled color so the control looks uniformly inactive.
    If mEnabled = False Then Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 72)
    If mItem.GetDefault("active", False) Then
        If mActiveBorder Then Return ResolveActiveColor
        Return ResolveActiveTextColor
    End If
    If mItem.GetDefault("disabled", False) Then
        Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 72)
    End If
    Return ResolveBaseTextColor
End Sub

Private Sub ResolveBaseTextColor As Int
    If mTextColor <> 0 Then Return mTextColor
    Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(44, 52, 64))
End Sub

Private Sub ResolveTitleColor As Int
    Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 102)
End Sub

Private Sub ResolveDividerColor As Int
    Return B4XDaisyVariants.SetAlpha(ResolveBaseTextColor, 26)
End Sub

Private Sub IsClickableItem(mItem As Map) As Boolean
    If mItem.IsInitialized = False Then Return False
    Dim kind As String = mItem.GetDefault("kind", "")
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
            If mRounded = "rounded-none" Or (mRounded <> "rounded-box" And mRounded <> "theme") Then Return 0
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

Public Sub BeginUpdate
    mUpdating = True
End Sub

Public Sub EndUpdate
    mUpdating = False
    Dim root As B4XDaisyMenu = ResolveRootMenu
    If root.IsInitialized And root.mBase.IsInitialized Then
        Dim oldRootH As Int = root.mBase.Height
        root.Refresh
        root.UpdateMeasuredHeightRecursive(oldRootH, 0)
    Else
        RefreshIfReady
    End If
End Sub

Public Sub setAutoRefresh(bValue As Boolean)
    mAutoRefresh = bValue
    If mAutoRefresh Then RefreshIfReady
End Sub

Public Sub getAutoRefresh As Boolean
    Return mAutoRefresh
End Sub

Private Sub RefreshIfReady
    If mUpdating Or mAutoRefresh = False Then Return
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub SetLevelInternal(iLevel As Int)
    mLevel = Max(0, iLevel)
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

Private Sub FindItemByTagRecursive(MenuComp As B4XDaisyMenu, oTagValue As Object) As Map
    Dim empty As Map
    If MenuComp.IsInitialized = False Or MenuComp.mItems.IsInitialized = False Then Return empty
    For i = 0 To MenuComp.mItems.Size - 1
        Dim item As Map = MenuComp.mItems.Get(i)
        If item.GetDefault("kind", "") <> "divider" And item.GetDefault("kind", "") <> "title" Then
            If TagsMatch(item.GetDefault("tag", Null), oTagValue) Then Return item
        End If
        If item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            Dim childItem As Map = FindItemByTagRecursive(child, oTagValue)
            If childItem.IsInitialized Then Return childItem
        End If
    Next
    Return empty
End Sub

Private Sub FindOwningMenuByTagRecursive(MenuComp As B4XDaisyMenu, oTagValue As Object) As B4XDaisyMenu
    Dim empty As B4XDaisyMenu
    If MenuComp.IsInitialized = False Or MenuComp.mItems.IsInitialized = False Then Return empty
    For i = 0 To MenuComp.mItems.Size - 1
        Dim item As Map = MenuComp.mItems.Get(i)
        If item.GetDefault("kind", "") <> "divider" And item.GetDefault("kind", "") <> "title" Then
            If TagsMatch(item.GetDefault("tag", Null), oTagValue) Then Return MenuComp
        End If
        If item.ContainsKey("submenu") Then
            Dim child As B4XDaisyMenu = item.Get("submenu")
            Dim owner As B4XDaisyMenu = FindOwningMenuByTagRecursive(child, oTagValue)
            If owner.IsInitialized Then Return owner
        End If
    Next
    Return empty
End Sub

Private Sub TagsMatch(oLeftTag As Object, oRightTag As Object) As Boolean
    If oLeftTag = Null Or oRightTag = Null Then Return False
    Try
        Return oLeftTag = oRightTag
    Catch
        Dim leftText As String = oLeftTag
        Dim rightText As String = oRightTag
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

Private Sub UpdateMeasuredHeightRecursive(iOldHeight As Int, iAnimDuration As Int)
    If mBase.IsInitialized = False Then Return
    If mOrientation = "horizontal" And mLevel = 0 Then Return
    If mHeightExplicit Then
        If mParentMenu.IsInitialized And mParentMenu.mBase.IsInitialized Then
            mParentMenu.UpdateMeasuredHeightRecursive(mParentMenu.mBase.Height, iAnimDuration)
        End If
        Return
    End If

    Dim targetH As Int = Max(1dip, GetPreferredHeight)
    Dim previousH As Int = Max(0, iOldHeight)
    If previousH = 0 Then previousH = mBase.Height
    If targetH <> mBase.Height Then
        mBase.SetLayoutAnimated(iAnimDuration, mBase.Left, mBase.Top, mBase.Width, targetH)
        Base_Resize(mBase.Width, targetH)
    End If
    Dim delta As Int = targetH - previousH

    If mParentMenu.IsInitialized And mParentMenu.mBase.IsInitialized Then
        mParentMenu.UpdateMeasuredHeightRecursive(mParentMenu.mBase.Height, iAnimDuration)
        Return
    End If

    If delta <> 0 Then
        Dim parentView As B4XView = mBase.Parent
        If parentView.IsInitialized Then
            B4XDaisyVariants.ShiftSiblingsBelow(mBase, delta, iAnimDuration)
        End If
    End If
End Sub

Private Sub ToggleSubmenuItem(mItem As Map, bValue As Boolean, iAnimDuration As Int)
    If mItem.IsInitialized = False Then Return
    If mItem.GetDefault("kind", "") <> "submenu" Then Return
    If mItem.GetDefault("open", False) = bValue Then Return

    mItem.Put("open", bValue)

    If mUpdating Or mAutoRefresh = False Then Return

    Dim root As B4XDaisyMenu = ResolveRootMenu
    If root.IsInitialized And root.mBase.IsInitialized Then
        Dim oldRootH As Int = root.mBase.Height
        root.Refresh
        root.UpdateMeasuredHeightRecursive(oldRootH, iAnimDuration)
    Else
        Dim oldH As Int = 0
        If mBase.IsInitialized Then oldH = mBase.Height
        RefreshIfReady
        UpdateMeasuredHeightRecursive(oldH, iAnimDuration)
    End If
End Sub

Public Sub SetPopupMode(bValue As Boolean)
    mbPopup = bValue
End Sub

Private Sub GetMapString(mItem As Map, sKey As String) As String
    If mItem.IsInitialized = False Then Return ""
    Dim o As Object = mItem.GetDefault(sKey, "")
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
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    Base_Resize(Max(1dip, iWidth), Max(1dip, iHeight))
    ApplyRailMode(mbRailMode, Max(1dip, iWidth))
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

Public Sub setEnabled(bValue As Boolean)
    mEnabled = bValue
    RefreshIfReady
End Sub

Public Sub getEnabled As Boolean
    Return mEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mVisible = bValue
    If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setWidth(oValue As Object)
    If oValue = Null Then Return
    Dim raw As String = oValue
    If raw.ToLowerCase.Trim = "w-full" Or raw.ToLowerCase.Trim = "full" Then
        mWidth = 0
        mWidthExplicit = False
        mWidthFull = True
    Else If raw.ToLowerCase.Trim = "w-auto" Or raw.ToLowerCase.Trim = "auto" Then
        mWidth = 0
        mWidthExplicit = False
        mWidthFull = False
    Else
        mWidth = Max(72dip, B4XDaisyVariants.TailwindSizeToDip(oValue, Max(mWidth, 224dip)))
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

Public Sub setHeight(oValue As Object)
    If oValue = Null Then Return
    Dim raw As String = oValue
    If raw.ToLowerCase.Trim = "h-auto" Or raw.ToLowerCase.Trim = "auto" Then
        mbAutoResize = True
        mHeightExplicit = False
        mHeight = 0
    Else
        mbAutoResize = False
        mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, Max(mHeight, 40dip)))
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

Public Sub setAutoResize(bValue As Boolean)
    mbAutoResize = bValue
    If mbAutoResize Then
        mHeightExplicit = False
    Else
        mHeightExplicit = True
        If mHeight <= 0 And mBase.IsInitialized Then mHeight = mBase.Height
    End If
    RefreshIfReady
End Sub

Public Sub getAutoResize As Boolean
    Return mbAutoResize
End Sub

Public Sub setPadding(sValue As String)
    mPadding = IIf(sValue = Null, "", sValue)
    RefreshIfReady
End Sub

Public Sub getPadding As String
    Return mPadding
End Sub

Public Sub setMargin(sValue As String)
    mMargin = IIf(sValue = Null, "", sValue)
    RefreshIfReady
End Sub

Public Sub getMargin As String
    Return mMargin
End Sub

Public Sub setDividers(bValue As Boolean)
    mDividers = bValue
    RefreshIfReady
End Sub

Public Sub getDividers As Boolean
    Return mDividers
End Sub

Public Sub setDividerGap(sValue As String)
    mDividerGap = IIf(sValue = Null, "", sValue)
    RefreshIfReady
End Sub

Public Sub getDividerGap As String
    Return mDividerGap
End Sub

Public Sub setSize(sValue As String)
    mSize = B4XDaisyVariants.NormalizeSize(sValue)
    RefreshIfReady
End Sub

Public Sub getSize As String
    Return mSize
End Sub

Public Sub setOrientation(sValue As String)
    mOrientation = B4XDaisyVariants.NormalizeOrientation(sValue)
    RefreshIfReady
End Sub

Public Sub getOrientation As String
    Return mOrientation
End Sub

Public Sub setRounded(sValue As String)
    mRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    RefreshIfReady
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
    If bValue Then
        setRounded("rounded-box")
    Else
        setRounded("rounded-none")
    End If
End Sub

Public Sub getRoundedBox As Boolean
    Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setShadow(sValue As String)
    mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    RefreshIfReady
End Sub

Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setBringToFront(bValue As Boolean)
    mBringToFront = bValue
    If mBase.IsInitialized And mBringToFront Then mBase.BringToFront
End Sub

Public Sub getBringToFront As Boolean
    Return mBringToFront
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mBackgroundColor = iValue
    RefreshIfReady
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
    mBackgroundColor = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, ResolveMenuBackgroundColor)
    RefreshIfReady
End Sub

Public Sub setTextColor(iValue As Int)
    mTextColor = iValue
    RefreshIfReady
End Sub

Public Sub getTextColor As Int
    Return mTextColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
    mTextColor = B4XDaisyVariants.ResolveTextColorVariantFromPalette(B4XDaisyVariants.GetVariantPalette, sVariantName, ResolveBaseTextColor)
    RefreshIfReady
End Sub

Public Sub setActiveColor(iValue As Int)
    mActiveColor = iValue
    RefreshIfReady
End Sub

Public Sub getActiveColor As Int
    Return mActiveColor
End Sub

Public Sub setActiveTextColor(iValue As Int)
    mActiveTextColor = iValue
    RefreshIfReady
End Sub

Public Sub getActiveTextColor As Int
    Return mActiveTextColor
End Sub

Public Sub setActiveBorder(bValue As Boolean)
    mActiveBorder = bValue
    RefreshIfReady
End Sub

Public Sub getActiveBorder As Boolean
    Return mActiveBorder
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setBadgeSize(sValue As String)
    msBadgeSize = NormalizeBadgeSizeProp(sValue)
    RefreshIfReady
End Sub

Public Sub getBadgeSize As String
    Return msBadgeSize
End Sub

Public Sub setBadgeVariant(sValue As String)
    msBadgeVariant = B4XDaisyVariants.NormalizeVariant(sValue)
    RefreshIfReady
End Sub

Public Sub getBadgeVariant As String
    Return msBadgeVariant
End Sub

Public Sub setBadgeStyle(sValue As String)
    msBadgeStyle = sValue
    RefreshIfReady
End Sub

Public Sub getBadgeStyle As String
    Return msBadgeStyle
End Sub

Public Sub setBadgeRounded(sValue As String)
    msBadgeRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    RefreshIfReady
End Sub

Public Sub getBadgeRounded As String
    Return msBadgeRounded
End Sub

Public Sub setRailMode(bValue As Boolean, iIntendedWidth As Int)
    mbRailMode = bValue
    If mBase.IsInitialized Then
        ApplyRailMode(bValue, iIntendedWidth)
    End If
End Sub

Public Sub getRailMode As Boolean
    Return mbRailMode
End Sub

Private Sub ApplyRailMode(bCollapsed As Boolean, iIntendedWidth As Int)
    If mItems.IsInitialized = False Then Return
    mbRailMode = bCollapsed

    ' Use the caller-supplied intended width when available. mBase.Width can lag
    ' behind a duration-0 SetLayoutAnimated (getWidth returns the old value on
    ' the same frame), which would shrink the base back and clip expanded text.
    Dim currentW As Int = IIf(iIntendedWidth > 0, iIntendedWidth, mBase.Width)
    If currentW <= 0 And mBase.Parent.IsInitialized Then
        currentW = mBase.Parent.Width
    End If
    If currentW <= 0 Then currentW = 60dip
    
    If mBase.IsInitialized Then
        mBase.Width = currentW
        LayoutHosts(currentW, mBase.Height)
    End If
    
    Dim outerRect As B4XRect = ResolveOuterRect(currentW, mBase.Height)
    Dim host As B4XRect
    host.Initialize(0, 0, Max(1dip, outerRect.Width), Max(1dip, outerRect.Height))
    Dim innerBox As Map = BuildInnerBoxModel
    Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(host, innerBox)
    Dim contentW As Int = Max(1dip, contentRect.Width)
    Dim spec As Map = ResolveSizeSpec
    Dim px As Int = spec.Get("pad_x")
    Dim gap As Int = spec.Get("gap")
    Dim iconSize As Int = spec.Get("icon")
    Dim avatarSize As Int = spec.Get("avatar")

    For i = 0 To mItems.Size - 1
        Dim item As Map = mItems.Get(i)
        Dim kind As String = item.GetDefault("kind", "")
        
        If item.ContainsKey("view") Then
            Dim rowV As B4XView = item.Get("view")
            rowV.Width = contentW
        End If
        If item.ContainsKey("hit_view") Then
            Dim hitV As B4XView = item.Get("hit_view")
            hitV.Width = contentW
        End If

        If kind = "title" Then
            If item.ContainsKey("view") Then
                Dim titleV As B4XView = item.Get("view")
                titleV.Visible = Not(bCollapsed)
                titleV.Width = contentW
            End If
        Else If kind = "item" Then
            Dim leftX As Int = px
            Dim rightX As Int = contentW - px
            
            If item.ContainsKey("avatar_view") Then
                Dim avV As B4XView = item.Get("avatar_view")
                avV.Left = IIf(bCollapsed, Max(0, (contentW - avatarSize) / 2), px)
                If bCollapsed = False Then leftX = leftX + avatarSize + gap
            End If

            If item.ContainsKey("icon_view") Then
                Dim iconV As B4XView = item.Get("icon_view")
                iconV.Left = IIf(bCollapsed, Max(0, (contentW - iconSize) / 2), px)
                If bCollapsed = False Then leftX = leftX + iconSize + gap
            End If

            If item.ContainsKey("chevron_view") Then
                Dim chevV As B4XView = item.Get("chevron_view")
                chevV.Visible = Not(bCollapsed)
                If bCollapsed = False Then
                    chevV.Left = rightX - chevV.Width
                    rightX = rightX - chevV.Width - gap
                End If
            End If

            If item.ContainsKey("badge_view") Then
                Dim badgeV As B4XView = item.Get("badge_view")
                badgeV.Visible = Not(bCollapsed)
                If bCollapsed = False Then
                    badgeV.Left = rightX - badgeV.Width
                    rightX = rightX - badgeV.Width - gap
                End If
            End If

            If item.ContainsKey("text_view") Then
                Dim textV As B4XView = item.Get("text_view")
                textV.Visible = Not(bCollapsed)
                If bCollapsed = False Then
                    textV.Left = leftX
                    textV.Width = Max(1dip, rightX - leftX)
                End If
            End If
        End If
    Next
    
    If mDividerViews.IsInitialized Then
        For Each divV As B4XView In mDividerViews
            If divV.IsInitialized Then
                divV.Width = contentW
            End If
        Next
    End If
    
    LayoutRightBorder
End Sub

Private Sub LayoutRightBorder
    If mBase.IsInitialized = False Then Return
    If mbRightBorder Then
        If pnlRightBorderView.IsInitialized = False Then
            Dim p As Panel
            p.Initialize("")
            pnlRightBorderView = p
            mBase.AddView(pnlRightBorderView, 0, 0, 1dip, 1dip)
        End If
        Dim bColor As Int = mRightBorderColor
        If bColor = 0 Then bColor = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(200, 205, 215))
        pnlRightBorderView.Color = bColor
        pnlRightBorderView.Visible = True
        pnlRightBorderView.SetLayoutAnimated(0, Max(0, mBase.Width - 1dip), 0, 1dip, mBase.Height)
        pnlRightBorderView.BringToFront
    Else
        If pnlRightBorderView.IsInitialized Then
            pnlRightBorderView.Visible = False
        End If
    End If
End Sub

Public Sub setRightBorder(bValue As Boolean)
    mbRightBorder = bValue
    LayoutRightBorder
End Sub

Public Sub getRightBorder As Boolean
    Return mbRightBorder
End Sub

Public Sub setRightBorderColor(iValue As Int)
    mRightBorderColor = iValue
    LayoutRightBorder
End Sub

#Region B4XView Z-Order and Visibility Methods
Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region