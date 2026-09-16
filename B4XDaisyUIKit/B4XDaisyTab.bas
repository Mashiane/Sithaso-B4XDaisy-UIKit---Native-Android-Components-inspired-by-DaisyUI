B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: TabClick (Index As Int)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables or disables the component.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the component.
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: default, List: default|border|lift|box, Description: Tab style variant: default, border (bottom line), lift (raised with corners), box (enclosed container).
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Tab size: xs, sm, md (default), lg, xl.
#DesignerProperty: Key: Placement, DisplayName: Placement, FieldType: String, DefaultValue: top, List: top|bottom, Description: Tab bar placement relative to content: top (default) or bottom.
#DesignerProperty: Key: ActiveIndex, DisplayName: Active Index, FieldType: Int, DefaultValue: 0, Description: Index of the active tab (0-based).
#DesignerProperty: Key: Scrollable, DisplayName: Scrollable, FieldType: Boolean, DefaultValue: False, Description: Enables horizontal scrolling when tabs overflow the container width.
#DesignerProperty: Key: Alignment, DisplayName: Alignment, FieldType: String, DefaultValue: center, List: left|center|right, Description: Horizontal alignment of tabs within the tab bar.
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: String, DefaultValue: primary, List: none|primary|secondary|accent|neutral|info|success|warning|error, Description: Accent color applied to the active tab (background + text/border).
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind width token or CSS size.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto, Description: Tailwind height token or CSS size.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private mTabs As List
    Private mContentPanels As List

    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private msStyle As String = "default"
    Private msSize As String = "md"
    Private msPlacement As String = "top"
    Private miActiveIndex As Int = 0
    Private mbScrollable As Boolean = False
    Private msAlignment As String = "center"
    Private msActiveColor As String = "primary"
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-auto"

    Private pnlTabBar As B4XView
    Private pnlContentHost As B4XView
    Private pnlScrollHost As B4XView
    Private hsvScroll As HorizontalScrollView

    Private MI_BORDER_THICKNESS As Int = 2dip
    Private MI_BORDER_INDICATOR_H As Int = 3dip
    Private MI_LIFT_CORNER_RADIUS As Int = 8dip
    Private MI_BOX_PAD As Int = 4dip
    Private MI_CONTENT_PAD As Int = 24dip
    Private MI_TAB_GAP As Int = 2dip
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mTabs.Initialize
    mContentPanels.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then
        mTag = mBase.Tag
    End If
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    pnlTabBar = xui.CreatePanel("")
    pnlTabBar.Color = xui.Color_Transparent
    mBase.AddView(pnlTabBar, 0, 0, mBase.Width, mBase.Height)

    Dim hsv As HorizontalScrollView
    hsv.Initialize(0, "")
    hsvScroll = hsv
    hsvScroll.Color = xui.Color_Transparent
    hsvScroll.SetVisibleAnimated(0, False)
    mBase.AddView(hsvScroll, 0, 0, mBase.Width, mBase.Height)

    pnlScrollHost = xui.CreatePanel("")
    pnlScrollHost.Color = xui.Color_Transparent
    hsvScroll.Panel.AddView(pnlScrollHost, 0, 0, mBase.Width, mBase.Height)

    pnlContentHost = xui.CreatePanel("")
    pnlContentHost.Color = xui.Color_Transparent
    mBase.AddView(pnlContentHost, 0, 0, mBase.Width, mBase.Height)

    ApplyDesignerProps(mProps)
    Refresh
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
    Dim props As Map
    props = BuildRuntimeProps
    DesignerCreateView(b, Null, props)
    Return mBase
End Sub
#End Region

#Region Public API
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    vParent.AddView(mBase, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    Base_Resize(mBase.Width, mBase.Height)
    Return mBase
End Sub

Public Sub AddTab(sText As String)
    If mTabs.IsInitialized = False Then mTabs.Initialize
    If mContentPanels.IsInitialized = False Then mContentPanels.Initialize
    Dim tabItem As Map
    tabItem.Initialize
    tabItem.Put("Text", sText)
    tabItem.Put("Variant", "")
    tabItem.Put("Disabled", False)
    tabItem.Put("IconText", "")
    mTabs.Add(tabItem)
    Dim pnl As Panel
    pnl.Initialize("")
    Dim xvPnl As B4XView = pnl
    xvPnl.Color = xui.Color_Transparent
    mContentPanels.Add(xvPnl)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub AddTabWithIcon(sText As String, sIconText As String)
    If mTabs.IsInitialized = False Then mTabs.Initialize
    If mContentPanels.IsInitialized = False Then mContentPanels.Initialize
    Dim iconType As String = IIf(sIconText.ToLowerCase.EndsWith(".svg"), "svg", "text")
    Dim tabItem As Map
    tabItem.Initialize
    tabItem.Put("Text", sText)
    tabItem.Put("Variant", "")
    tabItem.Put("Disabled", False)
    tabItem.Put("IconText", sIconText)
    tabItem.Put("IconType", iconType)
    mTabs.Add(tabItem)
    Dim pnl As Panel
    pnl.Initialize("")
    Dim xvPnl As B4XView = pnl
    xvPnl.Color = xui.Color_Transparent
    mContentPanels.Add(xvPnl)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub SetTabDisabled(iIndex As Int, bDisabled As Boolean)
    If iIndex < 0 Or iIndex >= mTabs.Size Then Return
    Dim tabItem As Map = mTabs.Get(iIndex)
    tabItem.Put("Disabled", bDisabled)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub SetTabVariant(iIndex As Int, sVariant As String)
    If iIndex < 0 Or iIndex >= mTabs.Size Then Return
    Dim tabItem As Map = mTabs.Get(iIndex)
    tabItem.Put("Variant", sVariant)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub SetTabTitle(iIndex As Int, sText As String)
    If iIndex < 0 Or iIndex >= mTabs.Size Then Return
    Dim tabItem As Map = mTabs.Get(iIndex)
    tabItem.Put("Text", sText)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub SetTabTitleTextColor(iIndex As Int, iColor As Int)
    If iIndex < 0 Or iIndex >= mTabs.Size Then Return
    Dim tabItem As Map = mTabs.Get(iIndex)
    tabItem.Put("TitleTextColor", iColor)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub SetTabTitleColor(iIndex As Int, iColor As Int)
    If iIndex < 0 Or iIndex >= mTabs.Size Then Return
    Dim tabItem As Map = mTabs.Get(iIndex)
    tabItem.Put("TitleColor", iColor)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub SetTabContent(iIndex As Int, vContent As B4XView)
    If iIndex < 0 Or iIndex >= mContentPanels.Size Then Return
    Dim pnl As B4XView = mContentPanels.Get(iIndex)
    pnl.RemoveAllViews
    If vContent.IsInitialized Then
        pnl.AddView(vContent, 0, 0, pnl.Width, pnl.Height)
    End If
End Sub

Public Sub GetTabContent(iIndex As Int) As B4XView
    If iIndex < 0 Or iIndex >= mContentPanels.Size Then Return Null
    Return mContentPanels.Get(iIndex)
End Sub

Public Sub SetTabContentText(iIndex As Int, sText As String)
    If iIndex < 0 Or iIndex >= mContentPanels.Size Then Return
    Dim pnl As B4XView = mContentPanels.Get(iIndex)
    pnl.RemoveAllViews
    Dim lbl As Label
    lbl.Initialize("")
    Dim xlbl As B4XView = lbl
    xlbl.Color = xui.Color_Transparent
    xlbl.Text = sText
    xlbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
    xlbl.TextSize = 14
    xlbl.SetTextAlignment("TOP", "LEFT")
    Dim lblW As Int = pnl.Width - 2 * MI_CONTENT_PAD
    If lblW < 50dip Then lblW = 200dip
    Dim lblH As Int = B4XDaisyVariants.MeasureTextHeightSafe(sText, 14, Typeface.DEFAULT, lblW, 4dip) + 8dip
    pnl.AddView(xlbl, MI_CONTENT_PAD, MI_CONTENT_PAD, lblW, Max(lblH, 30dip))
End Sub

Public Sub SetTabs(lstTabsList As List)
    If mTabs.IsInitialized = False Then mTabs.Initialize
    If mContentPanels.IsInitialized = False Then mContentPanels.Initialize
    mTabs.Initialize
    mContentPanels.Initialize
    For Each rawTab As Object In lstTabsList
        If rawTab Is Map Then
            Dim m As Map = rawTab
            Dim t As String = ""
            If m.ContainsKey("Text") Then t = m.Get("Text")
            Dim v As String = ""
            If m.ContainsKey("Variant") Then v = m.Get("Variant")
            Dim d As Boolean = False
            If m.ContainsKey("Disabled") Then d = m.Get("Disabled")
            Dim ico As String = ""
            If m.ContainsKey("IconText") Then ico = m.Get("IconText")
            Dim tabItem As Map
            tabItem.Initialize
            tabItem.Put("Text", t)
            tabItem.Put("Variant", v)
            tabItem.Put("Disabled", d)
            tabItem.Put("IconText", ico)
            mTabs.Add(tabItem)
            Dim pnl As Panel
            pnl.Initialize("")
            Dim xvPnl As B4XView = pnl
            xvPnl.Color = xui.Color_Transparent
            mContentPanels.Add(xvPnl)
        End If
    Next
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub ClearTabs
    If mTabs.IsInitialized = False Then mTabs.Initialize
    If mContentPanels.IsInitialized = False Then mContentPanels.Initialize
    mTabs.Initialize
    mContentPanels.Initialize
    If pnlTabBar.IsInitialized Then pnlTabBar.RemoveAllViews
    If pnlScrollHost.IsInitialized Then pnlScrollHost.RemoveAllViews
    If pnlContentHost.IsInitialized Then pnlContentHost.RemoveAllViews
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTabCount As Int
    If mTabs.IsInitialized = False Then Return 0
    Return mTabs.Size
End Sub

Public Sub GetComputedHeight As Int
    If mTabs.Size = 0 Then Return 0
    Dim tabH As Int = GetTabHeightDip
    Dim isBox As Boolean = msStyle = "box"
    Dim boxPad As Int = 0
    If isBox Then boxPad = MI_BOX_PAD
    Dim tabBarH As Int = tabH
    If isBox Then tabBarH = tabH + boxPad * 2

    Dim maxContentH As Int = 0
    For i = 0 To mContentPanels.Size - 1
        Dim pnl As B4XView = mContentPanels.Get(i)
        If pnl.IsInitialized And pnl.NumberOfViews > 0 Then
            Dim maxChildBottom As Int = 0
            For c = 0 To pnl.NumberOfViews - 1
                Dim child As B4XView = pnl.GetView(c)
                Dim childBottom As Int = child.Top + child.Height
                If childBottom > maxChildBottom Then maxChildBottom = childBottom
            Next
            Dim panelH As Int = maxChildBottom + MI_CONTENT_PAD
            If panelH > maxContentH Then maxContentH = panelH
        End If
    Next
    If maxContentH = 0 Then maxContentH = 60dip

    Dim contentOverlap As Int = 0
    If msStyle = "lift" Or msStyle = "border" Then contentOverlap = MI_BORDER_THICKNESS
    Dim contentTopOffset As Int = 0
    If isBox Then contentTopOffset = 4dip

    Return tabBarH + maxContentH
End Sub

Public Sub setActiveIndex(iValue As Int)
    miActiveIndex = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActiveIndex As Int
    Return miActiveIndex
End Sub

Public Sub setStyle(sValue As String)
    msStyle = NormalizeStyle(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getStyle As String
    Return msStyle
End Sub

Public Sub setSize(sValue As String)
    msSize = NormalizeSize(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setPlacement(sValue As String)
    msPlacement = NormalizePlacement(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlacement As String
    Return msPlacement
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
    mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setScrollable(bValue As Boolean)
    mbScrollable = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getScrollable As Boolean
    Return mbScrollable
End Sub

Public Sub setAlignment(sValue As String)
    msAlignment = NormalizeAlignment(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getAlignment As String
    Return msAlignment
End Sub

Public Sub setActiveColor(sValue As String)
    msActiveColor = NormalizeActiveColor(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActiveColor As String
    Return msActiveColor
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setWidth(sValue As String)
    msWidth = sValue
    If msWidth.Length = 0 Then msWidth = "w-full"
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(sValue As String)
    msHeight = sValue
    If msHeight.Length = 0 Then msHeight = "h-auto"
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then
        mBase.RemoveViewFromParent
    End If
End Sub

Public Sub ResizeTab
    If mBase.IsInitialized = False Then Return
    If pnlContentHost.IsInitialized = False Then Return
    If mContentPanels.Size = 0 Then Return

    Refresh

    Dim tabH As Int = GetTabHeightDip
    Dim isBox As Boolean = msStyle = "box"
    Dim boxPad As Int = 0
    If isBox Then boxPad = MI_BOX_PAD
    Dim tabBarHeight As Int = tabH
    If isBox Then tabBarHeight = tabH + boxPad * 2

    Dim maxContentH As Int = 0
    For i = 0 To mContentPanels.Size - 1
        Dim pnl As B4XView = mContentPanels.Get(i)
        If pnl.IsInitialized And pnl.NumberOfViews > 0 Then
            Dim maxChildBottom As Int = 0
            For c = 0 To pnl.NumberOfViews - 1
                Dim child As B4XView = pnl.GetView(c)
                Dim childBottom As Int = child.Top + child.Height
                If childBottom > maxChildBottom Then maxChildBottom = childBottom
            Next
            Dim panelH As Int = maxChildBottom + MI_CONTENT_PAD
            If panelH > maxContentH Then maxContentH = panelH
        End If
    Next
    If maxContentH = 0 Then maxContentH = 60dip

    Dim totalH As Int = tabBarHeight + maxContentH
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, totalH)

    Dim tabBarY As Int = 0
    If msPlacement = "bottom" Then
        tabBarY = totalH - tabBarHeight
    End If

    If pnlTabBar.IsInitialized Then
        pnlTabBar.SetLayoutAnimated(0, 0, tabBarY, mBase.Width, tabBarHeight)
    End If
    If mbScrollable And hsvScroll.IsInitialized Then
        hsvScroll.SetLayoutAnimated(0, 0, tabBarY, mBase.Width, tabBarHeight)
        hsvScroll.Panel.Height = tabBarHeight
    End If

    Dim containerW As Int = pnlContentHost.Width
    Dim contentY As Int = 0
    If msPlacement = "bottom" Then
        contentY = 0
    Else
        contentY = tabBarHeight
    End If
    pnlContentHost.SetLayoutAnimated(0, 0, contentY, containerW, maxContentH)
End Sub
#End Region

#Region Private Helpers
Private Sub NormalizeStyle(sValue As String) As String
    If sValue = "" Then Return "default"
    Dim v As String = sValue.ToLowerCase
    Select Case v
        Case "border", "tabs-border"
            Return "border"
        Case "lift", "tabs-lift"
            Return "lift"
        Case "box", "tabs-box"
            Return "box"
        Case Else
            Return "default"
    End Select
End Sub

Private Sub NormalizeSize(sValue As String) As String
    If sValue = "" Then Return "md"
    Dim v As String = sValue.ToLowerCase
    Select Case v
        Case "xs", "tabs-xs"
            Return "xs"
        Case "sm", "tabs-sm"
            Return "sm"
        Case "md", "tabs-md"
            Return "md"
        Case "lg", "tabs-lg"
            Return "lg"
        Case "xl", "tabs-xl"
            Return "xl"
        Case Else
            Return "md"
    End Select
End Sub

Private Sub NormalizePlacement(sValue As String) As String
    If sValue = "" Then Return "top"
    Dim v As String = sValue.ToLowerCase
    Select Case v
        Case "top", "tabs-top"
            Return "top"
        Case "bottom", "tabs-bottom"
            Return "bottom"
        Case Else
            Return "top"
    End Select
End Sub

Private Sub NormalizeAlignment(sValue As String) As String
    If sValue = "" Then Return "center"
    Dim v As String = sValue.ToLowerCase
    Select Case v
        Case "left", "start"
            Return "left"
        Case "center", "middle"
            Return "center"
        Case "right", "end"
            Return "right"
        Case Else
            Return "center"
    End Select
End Sub

Private Sub NormalizeActiveColor(sValue As String) As String
    If sValue = "" Then Return "none"
    Dim v As String = sValue.ToLowerCase
    Select Case v
        Case "primary", "secondary", "accent", "neutral", "info", "success", "warning", "error"
            Return v
        Case Else
            Return "none"
    End Select
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    If mProps.IsInitialized = False Then Return
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    msStyle = NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "Style", msStyle))
    msSize = NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", msSize))
    msPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(mProps, "Placement", msPlacement))
    miActiveIndex = B4XDaisyVariants.GetPropInt(mProps, "ActiveIndex", miActiveIndex)
    mbScrollable = B4XDaisyVariants.GetPropBool(mProps, "Scrollable", mbScrollable)
    msAlignment = NormalizeAlignment(B4XDaisyVariants.GetPropString(mProps, "Alignment", msAlignment))
    msActiveColor = NormalizeActiveColor(B4XDaisyVariants.GetPropString(mProps, "ActiveColor", msActiveColor))
    msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", msWidth)
    msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", msHeight)
End Sub

Private Sub BuildRuntimeProps As Map
    Dim props As Map
    props.Initialize
    props.Put("Enabled", mbEnabled)
    props.Put("Visible", mbVisible)
    props.Put("Style", msStyle)
    props.Put("Size", msSize)
    props.Put("Placement", msPlacement)
    props.Put("ActiveIndex", miActiveIndex)
    props.Put("Scrollable", mbScrollable)
    props.Put("Alignment", msAlignment)
    props.Put("ActiveColor", msActiveColor)
    props.Put("Width", msWidth)
    props.Put("Height", msHeight)
    Return props
End Sub

Private Sub GetTabHeightDip As Int
    Select Case msSize
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

Private Sub GetTabFontSize As Float
    Select Case msSize
        Case "xs"
            Return 12
        Case "sm"
            Return 14
        Case "md"
            Return 14
        Case "lg"
            Return 18
        Case "xl"
            Return 18
        Case Else
            Return 14
    End Select
End Sub

Private Sub GetTabPaddingX As Int
    Select Case msSize
        Case "xs"
            Return 6dip
        Case "sm"
            Return 8dip
        Case "md"
            Return 12dip
        Case "lg"
            Return 16dip
        Case "xl"
            Return 20dip
        Case Else
            Return 12dip
    End Select
End Sub

Private Sub ResolveThemeColor(sTokenName As String, iFallback As Int) As Int
    Return B4XDaisyVariants.GetTokenColor("--color-" & sTokenName, iFallback)
End Sub
#End Region

#Region Refresh
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    If pnlTabBar.IsInitialized = False Then Return

    pnlTabBar.RemoveAllViews
    If pnlScrollHost.IsInitialized Then
        pnlScrollHost.RemoveAllViews
    End If
    If pnlContentHost.IsInitialized Then
        pnlContentHost.RemoveAllViews
    End If

    Dim tabH As Int = GetTabHeightDip
    Dim fontSize As Float = GetTabFontSize
    Dim padX As Int = GetTabPaddingX

    Dim baseContentColor As Int = ResolveThemeColor("base-content", 0xFF333333)
    Dim base100Color As Int = ResolveThemeColor("base-100", 0xFFFFFFFF)
    Dim base200Color As Int = ResolveThemeColor("base-200", 0xFFF0F0F0)
    Dim base300Color As Int = ResolveThemeColor("base-300", 0xFFDDDDDD)

    Dim isBox As Boolean = msStyle = "box"
    Dim isLift As Boolean = msStyle = "lift"
    Dim isBorder As Boolean = msStyle = "border"

    If isBox Then
        Dim fieldRadius As Int = B4XDaisyVariants.GetRadiusFieldDip(8dip)
        Dim boxRadius As Int = Min(tabH / 2, fieldRadius) + Min(4dip, 3 * fieldRadius)
        pnlTabBar.SetColorAndBorder(base200Color, 0, 0, boxRadius)
        Dim topHighlight As B4XView = xui.CreatePanel("")
        topHighlight.Color = xui.Color_ARGB(26, 255, 255, 255)
        pnlTabBar.AddView(topHighlight, 0, 0, 0, 1dip)
        Dim bottomShadow As B4XView = xui.CreatePanel("")
        bottomShadow.Color = xui.Color_ARGB(13, 0, 0, 0)
        pnlTabBar.AddView(bottomShadow, 0, boxRadius, 0, 1dip)
    Else
        pnlTabBar.Color = xui.Color_Transparent
    End If

    Dim boxPad As Int = 0
    If isBox Then boxPad = MI_BOX_PAD

    Dim tabGap As Int = MI_TAB_GAP

    Dim totalTabsW As Int = 0
    Dim tabWidths As List
    tabWidths.Initialize

    For i = 0 To mTabs.Size - 1
        Dim tabItem As Map = mTabs.Get(i)
        Dim tabText As String = tabItem.Get("Text")
        Dim iconText As String = ""
        If tabItem.ContainsKey("IconText") Then iconText = tabItem.Get("IconText")
        Dim iconType As String = ""
        If tabItem.ContainsKey("IconType") Then iconType = tabItem.Get("IconType")
        Dim displayText As String = tabText
        If iconText.Length > 0 And iconType <> "svg" Then displayText = iconText & " " & tabText
        Dim tw As Int
        If iconType = "svg" And tabText.Length = 0 Then
            Dim svgIconSize As Int = Round(tabH * 0.6)
            tw = svgIconSize + 16dip
        Else
            tw = B4XDaisyVariants.MeasureTextWidthSafe(displayText, fontSize, Typeface.DEFAULT, 4dip)
            tw = tw + padX * 2
        End If
        tw = Max(tw, 48dip)
        tabWidths.Add(tw)
        totalTabsW = totalTabsW + tw
        If i < mTabs.Size - 1 Then totalTabsW = totalTabsW + tabGap
    Next

    Dim containerW As Int = pnlTabBar.Width
    If containerW <= 0 Then containerW = mBase.Width
    If containerW <= 0 Then containerW = 300dip

    Dim startX As Int = 0
    If isBox = False And isLift = False And isBorder = False Then
        Dim remainingSpace As Int = containerW - totalTabsW
        If remainingSpace > 0 And mTabs.Size > 0 Then
            Select Case msAlignment
                Case "left"
                    startX = 0
                Case "right"
                    startX = remainingSpace
                Case Else
                    startX = remainingSpace / 2
            End Select
        End If
    End If

    Dim actualTabH As Int = tabH
    If isBox Then actualTabH = tabH - 2dip

    Dim tabBarContentW As Int = totalTabsW
    If isBox Then tabBarContentW = tabBarContentW + boxPad * 2

    If mbScrollable Then
        If hsvScroll.IsInitialized Then
            hsvScroll.SetVisibleAnimated(0, True)
            pnlScrollHost.SetLayoutAnimated(0, 0, 0, Max(containerW, tabBarContentW), actualTabH)
            hsvScroll.SetLayoutAnimated(0, 0, 0, containerW, actualTabH)
            hsvScroll.Panel.Width = Max(containerW, tabBarContentW)
            hsvScroll.Panel.Height = actualTabH
        End If
    Else
        If hsvScroll.IsInitialized Then
            hsvScroll.SetVisibleAnimated(0, False)
        End If
    End If

    Dim renderTarget As B4XView
    If mbScrollable Then
        renderTarget = pnlScrollHost
    Else
        renderTarget = pnlTabBar
    End If

    For i = 0 To mTabs.Size - 1
        Dim tabItem As Map = mTabs.Get(i)
        Dim tabText As String = tabItem.Get("Text")
        Dim tabVariant As String = ""
        If tabItem.ContainsKey("Variant") Then tabVariant = tabItem.Get("Variant")
        Dim tabDisabled As Boolean = False
        If tabItem.ContainsKey("Disabled") Then tabDisabled = tabItem.Get("Disabled")
        Dim iconText As String = ""
        If tabItem.ContainsKey("IconText") Then iconText = tabItem.Get("IconText")
        Dim tw As Int = tabWidths.Get(i)

        Dim tx As Int = startX
        For j = 0 To i - 1
            tx = tx + tabWidths.Get(j) + tabGap
        Next
        If isBox Then tx = tx + boxPad

        Dim isActive As Boolean = (i = miActiveIndex)

        Dim pnlTab As Panel
        pnlTab.Initialize("tab")
        Dim xvTab As B4XView = pnlTab
        xvTab.Tag = i
        xvTab.Color = xui.Color_Transparent

        Dim textColor As Int
        Dim tabBgColor As Int = xui.Color_Transparent
        Dim tabBorderColor As Int = xui.Color_Transparent
        Dim borderWidth As Int = 0
        Dim cornerRadius As Int = 0
        ' A per-tab Disabled flag OR a disabled whole component (mbEnabled = False) both
        ' mute the tab text to the inactive color and make it non-interactive.
        If tabDisabled Or mbEnabled = False Then
            Dim alpha As Int = Bit.And(0xFFFFFF, baseContentColor)
            textColor = Bit.Or(0x66000000, alpha)
            xvTab.Enabled = False
        Else If isActive Then
            Dim activeColor As Int = xui.Color_Transparent
            If msActiveColor <> "none" Then
                activeColor = ResolveVariantColor(msActiveColor, base100Color)
            End If
            If isBox Then
                textColor = ResolveVariantContentColor(msActiveColor, baseContentColor)
                If activeColor <> xui.Color_Transparent Then
                    tabBgColor = activeColor
                Else
                    tabBgColor = base100Color
                End If
                borderWidth = 1dip
                tabBorderColor = base300Color
                cornerRadius = B4XDaisyVariants.GetRadiusFieldDip(8dip)
            Else If isLift Then
                textColor = ResolveVariantContentColor(msActiveColor, baseContentColor)
                If activeColor <> xui.Color_Transparent Then
                    tabBgColor = activeColor
                Else
                    tabBgColor = base100Color
                End If
                borderWidth = 0
                tabBorderColor = base300Color
                cornerRadius = B4XDaisyVariants.GetRadiusFieldDip(MI_LIFT_CORNER_RADIUS)
            Else If isBorder Then
                tabBgColor = xui.Color_Transparent
                borderWidth = 0
                textColor = baseContentColor
                If activeColor <> xui.Color_Transparent Then
                    tabBorderColor = activeColor
                Else
                    tabBorderColor = base300Color
                End If
                cornerRadius = B4XDaisyVariants.GetRadiusFieldDip(8dip)
            Else
                If activeColor <> xui.Color_Transparent Then
                    tabBgColor = activeColor
                    textColor = ResolveVariantContentColor(msActiveColor, baseContentColor)
                Else
                    tabBgColor = base100Color
                End If
                borderWidth = 1dip
                tabBorderColor = base300Color
                cornerRadius = B4XDaisyVariants.GetRadiusFieldDip(8dip)
            End If
        Else
            ' Inactive tab: dim text to 50% (CSS: text-base-content/50)
            Dim inactiveAlpha As Int = Bit.And(0xFFFFFF, baseContentColor)
            textColor = Bit.Or(0x80000000, inactiveAlpha)
        End If

        If tabItem.ContainsKey("TitleTextColor") Then
            textColor = tabItem.Get("TitleTextColor")
        End If
        If isActive And tabItem.ContainsKey("TitleColor") Then
            textColor = tabItem.Get("TitleColor")
        End If

        If tabBgColor <> xui.Color_Transparent Then
            If isLift And isActive Then
                ApplyLiftTabShape(xvTab, tabBgColor, tabBorderColor, cornerRadius, tw, actualTabH, msPlacement = "bottom")
            Else If cornerRadius > 0 Then
                xvTab.SetColorAndBorder(tabBgColor, borderWidth, tabBorderColor, cornerRadius)
            Else
                xvTab.SetColorAndBorder(tabBgColor, borderWidth, tabBorderColor, 0)
            End If
        Else
            xvTab.Color = xui.Color_Transparent
            If borderWidth > 0 Then
                xvTab.SetColorAndBorder(xui.Color_Transparent, borderWidth, tabBorderColor, cornerRadius)
            End If
        End If

        If isBorder And isActive Then
            Dim borderPnl As B4XView = xui.CreatePanel("")
            Dim borderH As Int = MI_BORDER_INDICATOR_H
            Dim borderW As Int = Round(tw * 0.8)
            Dim borderX As Int = Round(tw * 0.1)
            If msPlacement = "bottom" Then
                borderPnl.Color = tabBorderColor
                xvTab.AddView(borderPnl, borderX, 0, borderW, borderH)
            Else
                borderPnl.Color = tabBorderColor
                xvTab.AddView(borderPnl, borderX, actualTabH - borderH, borderW, borderH)
            End If
        End If

        If isBox And isActive Then
            B4XDaisyVariants.ApplyElevation(xvTab, "sm")
        End If

        Dim iconType As String = ""
        If tabItem.ContainsKey("IconType") Then iconType = tabItem.Get("IconType")

        Dim lblX As Int = 0
        If iconType = "svg" And iconText.Length > 0 Then
            Dim svgIconSize As Int = Round(actualTabH * 0.6)
            Dim svgIcon As B4XDaisySvgIcon
            svgIcon.Initialize(Me, "")
            Dim svgLeft As Int
            If tabText.Length = 0 Then
                svgLeft = Round((tw - svgIconSize) / 2)
            Else
                svgLeft = 4dip
            End If
            Dim svgView As B4XView = svgIcon.AddToParent(xvTab, svgLeft, Round((actualTabH - svgIconSize) / 2), svgIconSize, svgIconSize)
            svgIcon.SetClickable(False)
            svgIcon.SetSvgAsset(iconText)
            svgIcon.SetPreserveOriginalColors(False)
            svgIcon.SetColor(textColor)
            lblX = svgLeft + svgIconSize + 8dip
        End If

        Dim lblTab As Label
        lblTab.Initialize("tab")
        Dim xlbl As B4XView = lblTab
        xlbl.Color = xui.Color_Transparent
        xlbl.TextColor = textColor
        xlbl.TextSize = fontSize
        xlbl.SetTextAlignment("CENTER", "CENTER")
        xlbl.Tag = i

        Dim displayText As String = tabText
        If iconText.Length > 0 And iconType <> "svg" Then displayText = iconText & "  " & tabText
        xlbl.Text = displayText

        xvTab.AddView(xlbl, lblX, 0, tw - lblX, actualTabH)

        Dim tabY As Int = 0
        If isBox Then tabY = boxPad
        renderTarget.AddView(xvTab, tx, tabY, tw, actualTabH)
    Next

    Dim tabBarHeight As Int = tabH
    If isBox Then tabBarHeight = tabH + boxPad * 2

    Dim tabBarY As Int = 0
    If msPlacement = "bottom" Then
        Dim totalH As Int = mBase.Height
        If totalH <= 0 Then totalH = 200dip
        tabBarY = totalH - tabBarHeight
        If tabBarY < 0 Then tabBarY = 0
    End If

    If mbScrollable = False Then
        pnlTabBar.Visible = True
        pnlTabBar.SetLayoutAnimated(0, 0, tabBarY, containerW, tabBarHeight)
    Else
        pnlTabBar.Visible = False
        If hsvScroll.IsInitialized Then
            hsvScroll.SetVisibleAnimated(0, True)
            hsvScroll.SetLayoutAnimated(0, 0, tabBarY, containerW, tabBarHeight)
        End If
    End If

    If pnlContentHost.IsInitialized Then
        Dim contentOverlap As Int = 0
        If isLift Or isBorder Then contentOverlap = MI_BORDER_THICKNESS

        Dim contentTopOffset As Int = 0
        If isBox Then contentTopOffset = 4dip

        Dim contentRadius As Int = B4XDaisyVariants.GetRadiusBoxDip(8dip)
        Dim contentBorderWidth As Int = 1dip
        If isBox Then
            Dim fieldRadius As Int = B4XDaisyVariants.GetRadiusFieldDip(8dip)
            contentRadius = Min(tabH / 2, fieldRadius) + Min(4dip, 3 * fieldRadius) - MI_BORDER_THICKNESS
        End If

        Dim contentH As Int = 0
        For cp = 0 To mContentPanels.Size - 1
            Dim cpPnl As B4XView = mContentPanels.Get(cp)
            If cpPnl.IsInitialized And cpPnl.NumberOfViews > 0 Then
                Dim cpMaxBottom As Int = 0
                For c = 0 To cpPnl.NumberOfViews - 1
                    Dim child As B4XView = cpPnl.GetView(c)
                    Dim childBottom As Int = child.Top + child.Height
                    If childBottom > cpMaxBottom Then cpMaxBottom = childBottom
                Next
                Dim cpH As Int = cpMaxBottom + MI_CONTENT_PAD
                If cpH > contentH Then contentH = cpH
            End If
        Next
        If contentH = 0 Then contentH = 60dip

        Dim totalH As Int = tabBarHeight + contentH
        If msHeight <> "h-auto" And msHeight.Length > 0 Then
            totalH = mBase.Height
            contentH = totalH - tabBarHeight
            If contentH < 0 Then contentH = 0
        End If

        If msPlacement = "bottom" Then
            pnlContentHost.SetLayoutAnimated(0, 0, 0, containerW, contentH)
        Else
            pnlContentHost.SetLayoutAnimated(0, 0, tabBarY + tabBarHeight, containerW, contentH)
        End If

        Dim activeTabX As Int = -1
        Dim activeTabW As Int = 0
        If isLift And miActiveIndex >= 0 And miActiveIndex < mTabs.Size Then
            Dim atx As Int = startX
            For j = 0 To miActiveIndex - 1
                atx = atx + tabWidths.Get(j) + tabGap
            Next
            activeTabX = atx
            activeTabW = tabWidths.Get(miActiveIndex)
            If mbScrollable Then
                If miActiveIndex = 0 Then
                    activeTabX = 0
                Else If miActiveIndex = mTabs.Size - 1 Then
                    activeTabX = pnlContentHost.Width - activeTabW
                Else
                    activeTabX = -1
                End If
            End If
        End If

        For i = 0 To mContentPanels.Size - 1
            Dim pnl As B4XView = mContentPanels.Get(i)
            If i = miActiveIndex Then
                pnl.Visible = True
                Dim pnlW As Int = pnlContentHost.Width
                Dim pnlH As Int = pnlContentHost.Height
                If isLift Then
                    pnlH = pnlH + contentOverlap
                    ApplyLiftContentShape(pnl, base100Color, base300Color, contentBorderWidth, contentRadius, pnlW, pnlH, activeTabX, activeTabW, msPlacement = "bottom")
                    pnl.SetLayoutAnimated(0, 0, -contentOverlap, pnlW, pnlH)
                Else If isBox Then
                    pnl.SetColorAndBorder(base100Color, contentBorderWidth, base300Color, contentRadius)
                    pnl.SetLayoutAnimated(0, 0, contentTopOffset, pnlW, pnlH - contentTopOffset)
                Else
                    pnl.SetColorAndBorder(base100Color, contentBorderWidth, base300Color, contentRadius)
                    pnl.SetLayoutAnimated(0, 0, 0, pnlW, pnlH)
                End If
                If pnl.Parent.IsInitialized = False Then
                    pnlContentHost.AddView(pnl, 0, 0, pnlContentHost.Width, pnlContentHost.Height)
                End If
            Else
                pnl.Visible = False
            End If
        Next
    End If
End Sub
#End Region

#Region Lift Shapes
Private Sub ApplyLiftTabShape(vView As B4XView, iBgColor As Int, iStrokeColor As Int, iRadiusDip As Int, iW As Int, iH As Int, bIsBottom As Boolean)
    #If B4A
    Try
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setShape", Array(0))
        gd.RunMethod("setColor", Array(iBgColor))
        Dim r As Float = Max(0, iRadiusDip)
        Dim radii() As Float
        If bIsBottom Then
            radii = Array As Float(0, 0, 0, 0, r, r, r, r)
        Else
            radii = Array As Float(r, r, r, r, 0, 0, 0, 0)
        End If
        gd.RunMethod("setCornerRadii", Array(radii))
        If iStrokeColor <> xui.Color_Transparent Then
            gd.RunMethod("setStroke", Array(1dip, iStrokeColor))
        End If
        Dim jo As JavaObject = vView
        jo.RunMethod("setBackground", Array(gd))
    Catch
        vView.SetColorAndBorder(iBgColor, 1dip, iStrokeColor, iRadiusDip)
    End Try
    #Else
    vView.SetColorAndBorder(iBgColor, 1dip, iStrokeColor, iRadiusDip)
    #End If
End Sub

Private Sub ApplyLiftContentShape(vView As B4XView, iBgColor As Int, iStrokeColor As Int, iStrokeDip As Int, iRadiusDip As Int, iW As Int, iH As Int, iActiveTabX As Int, iActiveTabW As Int, bIsBottom As Boolean)
    #If B4A
    Try
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setShape", Array(0))
        gd.RunMethod("setColor", Array(iBgColor))
        Dim r As Float = Max(0, iRadiusDip)
        If iActiveTabX < 0 Then
            Dim radii() As Float = Array As Float(r, r, r, r, r, r, r, r)
            gd.RunMethod("setCornerRadii", Array(radii))
        Else If bIsBottom Then
            Dim topLeftR As Float = r
            Dim topRightR As Float = r
            Dim bottomLeftR As Float = r
            Dim bottomRightR As Float = r
            If iActiveTabX <= 1dip Then bottomLeftR = 0
            If iActiveTabX + iActiveTabW >= iW - 1dip Then bottomRightR = 0
            Dim radii() As Float = Array As Float(topLeftR, topLeftR, topRightR, topRightR, bottomRightR, bottomRightR, bottomLeftR, bottomLeftR)
            gd.RunMethod("setCornerRadii", Array(radii))
        Else
            Dim topLeftR As Float = r
            Dim topRightR As Float = r
            If iActiveTabX <= 1dip Then topLeftR = 0
            If iActiveTabX + iActiveTabW >= iW - 1dip Then topRightR = 0
            Dim radii() As Float = Array As Float(topLeftR, topLeftR, topRightR, topRightR, r, r, r, r)
            gd.RunMethod("setCornerRadii", Array(radii))
        End If
        If iStrokeColor <> xui.Color_Transparent Then
            gd.RunMethod("setStroke", Array(iStrokeDip, iStrokeColor))
        End If
        Dim jo As JavaObject = vView
        jo.RunMethod("setBackground", Array(gd))
    Catch
        vView.SetColorAndBorder(iBgColor, iStrokeDip, iStrokeColor, iRadiusDip)
    End Try
    #Else
    vView.SetColorAndBorder(iBgColor, iStrokeDip, iStrokeColor, iRadiusDip)
    #End If
End Sub
#End Region

#Region Color Helpers
Private Sub ResolveVariantColor(sVariant As String, iFallback As Int) As Int
    If sVariant = "" Then Return iFallback
    Dim v As String = sVariant.ToLowerCase
    Select Case v
        Case "primary"
            Return ResolveThemeColor("primary", 0xFF6366F1)
        Case "secondary"
            Return ResolveThemeColor("secondary", 0xFFEC4899)
        Case "accent"
            Return ResolveThemeColor("accent", 0xFF14B8A6)
        Case "neutral"
            Return ResolveThemeColor("neutral", 0xFF6B7280)
        Case "info"
            Return ResolveThemeColor("info", 0xFF3B82F6)
        Case "success"
            Return ResolveThemeColor("success", 0xFF22C55E)
        Case "warning"
            Return ResolveThemeColor("warning", 0xFFF59E0B)
        Case "error"
            Return ResolveThemeColor("error", 0xFFEF4444)
        Case Else
            Return iFallback
    End Select
End Sub

Private Sub ResolveVariantContentColor(sVariant As String, iFallback As Int) As Int
    If sVariant = "" Then Return iFallback
    Dim v As String = sVariant.ToLowerCase
    Select Case v
        Case "primary"
            Return ResolveThemeColor("primary-content", iFallback)
        Case "secondary"
            Return ResolveThemeColor("secondary-content", iFallback)
        Case "accent"
            Return ResolveThemeColor("accent-content", iFallback)
        Case "neutral"
            Return ResolveThemeColor("neutral-content", iFallback)
        Case "info"
            Return ResolveThemeColor("info-content", iFallback)
        Case "success"
            Return ResolveThemeColor("success-content", iFallback)
        Case "warning"
            Return ResolveThemeColor("warning-content", iFallback)
        Case "error"
            Return ResolveThemeColor("error-content", iFallback)
        Case Else
            Return iFallback
    End Select
End Sub
#End Region

#Region Events
Private Sub tab_Click
    If mbEnabled = False Then Return
    Dim srcView As B4XView = Sender
    Dim idx As Int = -1
    Dim tagVal As Object = srcView.Tag
    If tagVal Is Int Then idx = tagVal
    If idx < 0 Or idx >= mTabs.Size Then Return
    Dim tabItem As Map = mTabs.Get(idx)
    Dim tabDisabled As Boolean = False
    If tabItem.ContainsKey("Disabled") Then tabDisabled = tabItem.Get("Disabled")
    If tabDisabled Then Return
    miActiveIndex = idx
    Refresh
    If xui.SubExists(mCallBack, mEventName & "_TabClick", 1) Then
        CallSub2(mCallBack, mEventName & "_TabClick", idx)
    End If
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If pnlTabBar.IsInitialized = False Then Return
    If pnlContentHost.IsInitialized = False Then Return

    If inResize Then Return
    inResize = True
    pnlTabBar.Width = dWidth
    pnlContentHost.Width = dWidth

    If dHeight > 0 Then
        Dim tabBarH As Int = pnlTabBar.Height
        If tabBarH <= 0 Then tabBarH = GetTabHeightDip
        If msPlacement = "bottom" Then
            pnlContentHost.SetLayoutAnimated(0, 0, 0, dWidth, dHeight - tabBarH)
            pnlTabBar.SetLayoutAnimated(0, 0, dHeight - tabBarH, dWidth, tabBarH)
        Else
            pnlContentHost.SetLayoutAnimated(0, 0, tabBarH, dWidth, dHeight - tabBarH)
        End If
    End If

    If mbScrollable And hsvScroll.IsInitialized Then
        hsvScroll.SetLayoutAnimated(0, 0, pnlTabBar.Top, dWidth, pnlTabBar.Height)
        hsvScroll.Panel.Width = pnlScrollHost.Width
        hsvScroll.Panel.Height = pnlScrollHost.Height
        If pnlScrollHost.IsInitialized Then
            pnlScrollHost.SetLayoutAnimated(0, 0, 0, Max(dWidth, hsvScroll.Panel.Width), pnlTabBar.Height)
        End If
    End If

    For i = 0 To mContentPanels.Size - 1
        Dim pnl As B4XView = mContentPanels.Get(i)
        If pnl.IsInitialized And pnl.Visible Then
            pnl.SetLayoutAnimated(0, 0, 0, pnlContentHost.Width, pnlContentHost.Height)
        End If
    Next
    inResize = False
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
