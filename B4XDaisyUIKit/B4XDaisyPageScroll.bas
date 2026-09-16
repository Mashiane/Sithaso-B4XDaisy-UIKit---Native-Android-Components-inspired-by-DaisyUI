B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
    #Event: ScrollStart
    #Event: Scrolling (Position As Int)
    #Event: ScrollEnd
#End Region

#DesignerProperty: Key: PagePadding, DisplayName: Page Padding, FieldType: Int, DefaultValue: 12, Description: Content padding in dip from page edges.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color for the page (0 uses default light gray).
#DesignerProperty: Key: BackgroundVariant, DisplayName: Background Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI variant color for the page background. none = use BackgroundColor.
#DesignerProperty: Key: RootColor, DisplayName: Root Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color for the page parent panel (0 uses default light gray).
#DesignerProperty: Key: Transparent, DisplayName: Transparent, FieldType: Boolean, DefaultValue: False, Description: Set to True to make the page background transparent.
#DesignerProperty: Key: AutoFitHeight, DisplayName: Auto Fit Height, FieldType: Boolean, DefaultValue: True, Description: Automatically resize scroll view panel to fit content.
#DesignerProperty: Key: YGap, DisplayName: Y Gap, FieldType: Int, DefaultValue: 12, Description: Vertical spacing between added elements in dip.
#DesignerProperty: Key: ScrollEnabled, DisplayName: Scroll Enabled, FieldType: Boolean, DefaultValue: True, Description: Enable or disable scrolling. When False the content stays fixed while children remain interactive.

'/**
' * @module B4XDaisyPageScroll
' * @description
' *  A reusable page container Custom View that encapsulates a ScrollView and a transparent host panel.
' *  Designed to centralize boilerplate code for scrollable pages, manage resizing, and automatically
' *  calculate and update scroll heights based on added components.
' */
#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mCallBack As Object
    Private mEventName As String
    Private mTag As Object

    ' Designer/Runtime properties
    Private mPagePadding As Int = 12dip
    Private mBackgroundColor As Int = 0
    Private mRootColor As Int = 0
    Private mTransparent As Boolean = False
    Private mAutoFitHeight As Boolean = True
    Private mYGap As Int = 12dip
    Private mbScrollEnabled As Boolean = True
    Private msBackgroundVariant As String = "none"
    Private mScrollTimer As Timer
    Private miLastScrollPos As Int = 0
    Private mbScrolling As Boolean = False

    ' Internal Views
    Private svHost As ScrollView
    Private pnlHost As B4XView
	Private inResize As Boolean = False
End Sub

''' <summary>
''' Initializes the PageScroll custom view.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

''' <summary>
''' Programmatic creation helper.
''' </summary>
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
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

    ' Read Properties
'    mPagePadding = Props.GetDefault("PagePadding", 12) * 1dip
'    mBackgroundColor = Props.GetDefault("BackgroundColor", 0)
'    msBackgroundVariant = B4XDaisyVariants.NormalizeVariant(Props.GetDefault("BackgroundVariant", "none"))
'    mRootColor = Props.GetDefault("RootColor", 0)
'    mTransparent = Props.GetDefault("Transparent", False)
'    mAutoFitHeight = Props.GetDefault("AutoFitHeight", True)
'    mYGap = Props.GetDefault("YGap", 12) * 1dip
'    mbScrollEnabled = Props.GetDefault("ScrollEnabled", True)
    ApplyDesignerProps(mProps)

    ' Create ScrollView
    svHost.Initialize(Max(1dip, mBase.Height))
    mBase.AddView(svHost, 0, 0, mBase.Width, mBase.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent
    #If B4A
    svHost.Enabled = mbScrollEnabled
    #End If
    mScrollTimer.Initialize("pgscroll", 100)
    mScrollTimer.Enabled = True

    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mPagePadding = B4XDaisyVariants.GetPropInt(mProps, "PagePadding", 12) * 1dip
    mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", 0)
    msBackgroundVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "BackgroundVariant", "none"))
    mRootColor = B4XDaisyVariants.GetPropColor(mProps, "RootColor", 0)
    mTransparent = B4XDaisyVariants.GetPropBool(mProps, "Transparent", False)
    mAutoFitHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoFitHeight", True)
    mYGap = B4XDaisyVariants.GetPropInt(mProps, "YGap", 12) * 1dip
    mbScrollEnabled = B4XDaisyVariants.GetPropBool(mProps, "ScrollEnabled", True)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("PagePadding", mPagePadding / 1dip)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("BackgroundVariant", msBackgroundVariant)
	props.Put("RootColor", mRootColor)
	props.Put("Transparent", mTransparent)
	props.Put("AutoFitHeight", mAutoFitHeight)
	props.Put("YGap", mYGap / 1dip)
	props.Put("ScrollEnabled", mbScrollEnabled)
	Return props
End Sub

''' <summary>
''' Refreshes properties and updates the visual state.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return

    ' Set Page/Parent Background Color
    If mTransparent Then
        mBase.Color = xui.Color_Transparent
        If mBase.Parent.IsInitialized Then mBase.Parent.Color = xui.Color_Transparent
    Else
        ' Set Parent/Root Color
        Dim rootCol As Int = IIf(mRootColor <> 0, mRootColor, xui.Color_RGB(245, 247, 250))
        If mBase.Parent.IsInitialized Then mBase.Parent.Color = rootCol
        
        ' Resolve effective background: BackgroundVariant wins, then BackgroundColor, then transparent
        Dim bg As Int = xui.Color_Transparent
        If msBackgroundVariant <> "none" And msBackgroundVariant <> "" Then
            bg = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundVariant, xui.Color_RGB(245, 247, 250))
        Else If mBackgroundColor <> 0 Then
            bg = mBackgroundColor
        End If
        mBase.Color = bg
        #If B4A
        If svHost.IsInitialized Then svHost.Color = bg
        #End If
    End If

    If mAutoFitHeight Then AutoFit
End Sub

''' <summary>
''' Handles resizing events.
''' </summary>
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If inResize Then Return
    inResize = True
    If mBase.IsInitialized Then
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, dWidth, dHeight)
    End If
    If svHost.IsInitialized Then
        svHost.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    End If
    If mAutoFitHeight Then AutoFit
    inResize = False
End Sub

''' <summary>
''' Alias for Base_Resize.
''' </summary>
Public Sub Resize(dWidth As Double, dHeight As Double)
	Base_Resize(dWidth, dHeight)
End Sub

''' <summary>
''' Standard parent insertion helper for programmatic creation.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

''' <summary>
''' Moves this scroll component to the bottom of its parent's stacking order
''' so sibling views render on top of it.
''' </summary>
Public Sub SendToBack
    If mBase.IsInitialized And mBase.Parent.IsInitialized Then mBase.SendToBack
End Sub

''' <summary>
''' Moves this scroll component to the top of its parent's stacking order
''' so it renders above its siblings.
''' </summary>
Public Sub BringToFront
    If mBase.IsInitialized And mBase.Parent.IsInitialized Then mBase.BringToFront
End Sub

''' <summary>
''' Returns the scrollable host panel where user components should be added.
''' </summary>
Public Sub getPanel As B4XView
    Return pnlHost
End Sub

''' <summary>
''' Returns the underlying ScrollView container.
''' </summary>
Public Sub getScrollView As ScrollView
    Return svHost
End Sub

''' <summary>
''' Scrolls to the top of the content. Pass True for a native smooth animation.
''' </summary>
Public Sub ScrollToTop(bAnimated As Boolean)
    ScrollToPosition(0, bAnimated)
End Sub

''' <summary>
''' Scrolls to the bottom of the content. Pass True for a native smooth animation.
''' </summary>
Public Sub ScrollToBottom(bAnimated As Boolean)
    ScrollToPosition(MaxScrollPosition, bAnimated)
End Sub

''' <summary>
''' Scrolls to an absolute content position (0 = top). Values are clamped to the
''' valid scroll range. Pass True for a native smooth animation.
''' </summary>
Public Sub ScrollToPosition(iPosition As Int, bAnimated As Boolean)
    If svHost.IsInitialized = False Then Return
    Dim target As Int = Max(0, Min(iPosition, MaxScrollPosition))
    #If B4A
        If bAnimated Then
            Try
                Dim jo As JavaObject = svHost
                jo.RunMethod("smoothScrollTo", Array As Object(0, target))
            Catch
                Log("B4XDaisyPageScroll.ScrollToPosition: " & LastException.Message)
                svHost.ScrollPosition = target
            End Try
        Else
            svHost.ScrollPosition = target
        End If
    #End If
End Sub

''' <summary>
''' Returns the current scroll position (0 at the top).
''' </summary>
Public Sub getScrollPosition As Int
    If svHost.IsInitialized = False Then Return 0
    #If B4A
        Return svHost.ScrollPosition
    #End If
End Sub

''' <summary>
''' Returns the maximum scrollable position (content height - viewport height).
''' </summary>
Public Sub getMaxScrollPosition As Int
    Return MaxScrollPosition
End Sub

Private Sub MaxScrollPosition As Int
    If svHost.IsInitialized = False Or pnlHost.IsInitialized = False Then Return 0
    Return Max(0, pnlHost.Height - svHost.Height)
End Sub

''' <summary>
''' Scrolls so the given view aligns near the top of the viewport.
''' The view should live inside the scroll content panel (directly or nested).
''' </summary>
Public Sub ScrollToView(vTargetView As B4XView, bAnimated As Boolean)
    ScrollToViewWithMargin(vTargetView, 0, bAnimated)
End Sub

Public Sub ScrollToViewWithMargin(vTargetView As B4XView, iMarginTop As Int, bAnimated As Boolean)
    Try
        If vTargetView.IsInitialized = False Or pnlHost.IsInitialized = False Then Return
        Dim target As Int = vTargetView.Top
        Dim p As B4XView = vTargetView.Parent
        Dim guard As Int = 0
        Do While p.IsInitialized And p <> pnlHost And guard < 16
            target = target + p.Top
            p = p.Parent
            guard = guard + 1
        Loop
        ScrollToPosition(Max(0, target - iMarginTop), bAnimated)
    Catch
        Log("B4XDaisyPageScroll.ScrollToViewWithMargin: " & LastException.Message)
    End Try
End Sub

#If B4A
''' <summary>
''' Handles soft keyboard height changes on Android. Shrinks the ScrollView to fit
''' the remaining viewport, yields for layout, and scrolls the focused child into view.
''' </summary>
Public Sub IME_HeightChanged(iNewHeight As Int, iOldHeight As Int, oFocusedView As Object)
    Try
        If mBase.IsInitialized = False Or svHost.IsInitialized = False Then Return
        If iNewHeight < iOldHeight Then
            ' Keyboard opened: shrink scroll view to available height
            SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, iNewHeight)
            Sleep(50)
            If oFocusedView <> Null Then
                If oFocusedView Is B4XDaisyInput Then
                    Dim inp As B4XDaisyInput = oFocusedView
                    ScrollToViewWithMargin(inp.View, 28dip, True)
                Else If oFocusedView Is B4XView Then
                    Dim vx As B4XView = oFocusedView
                    ScrollToViewWithMargin(vx, 28dip, True)
                End If
            End If
        Else
            ' Keyboard closed: restore to full height
            Dim iFullHeight As Int = iNewHeight
            If mBase.Parent.IsInitialized Then iFullHeight = mBase.Parent.Height
            SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, iFullHeight)
        End If
    Catch
        Log("B4XDaisyPageScroll.IME_HeightChanged: " & LastException.Message)
    End Try
End Sub
#End If


Public Sub setBackgroundVariant(sValue As String)
    msBackgroundVariant = B4XDaisyVariants.NormalizeVariant(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundVariant As String
    Return msBackgroundVariant
End Sub

Private Sub pgscroll_Tick
    If svHost.IsInitialized = False Then Return
    If MaxScrollPosition <= 0 Then Return
    Dim pos As Int = svHost.ScrollPosition
    If pos <> miLastScrollPos Then
        If mbScrolling = False Then
            mbScrolling = True
            RaiseScrollStart
        End If
        RaiseScrolling(pos)
        miLastScrollPos = pos
    Else If mbScrolling Then
        mbScrolling = False
        RaiseScrollEnd
    End If
End Sub

Private Sub RaiseScrollStart
    If xui.SubExists(mCallBack, mEventName & "_ScrollStart", 0) Then CallSub(mCallBack, mEventName & "_ScrollStart")
End Sub

Private Sub RaiseScrolling(iPosition As Int)
    If xui.SubExists(mCallBack, mEventName & "_Scrolling", 1) Then CallSub2(mCallBack, mEventName & "_Scrolling", iPosition)
End Sub

Private Sub RaiseScrollEnd
    If xui.SubExists(mCallBack, mEventName & "_ScrollEnd", 0) Then CallSub(mCallBack, mEventName & "_ScrollEnd")
End Sub

''' <summary>
''' Returns the total usable content width after applying padding on both sides.
''' </summary>
Public Sub getUsableWidth As Int
    If mBase.IsInitialized = False Then Return 0
    Return Max(100dip, mBase.Width - (mPagePadding * 2))
End Sub

''' <summary>
''' Automatically calculates content boundaries and updates the scroll height.
''' </summary>
Public Sub AutoFit
    If pnlHost.IsInitialized = False Then Return
    Dim maxBottom As Int = 0
    For i = 0 To pnlHost.NumberOfViews - 1
        Dim v As B4XView = pnlHost.GetView(i)
        maxBottom = Max(maxBottom, v.Top + v.Height)
    Next
    pnlHost.Height = Max(mBase.Height, maxBottom + mPagePadding + 200dip)
    #If B4A
    svHost.Panel.Height = pnlHost.Height
    #End If
End Sub

''' <summary>
''' Clears all views from the scroll panel, resets scroll position, and autofits the height.
''' </summary>
Public Sub Clear
	If pnlHost.IsInitialized Then
		pnlHost.RemoveAllViews
		#If B4A
		svHost.ScrollPosition = 0
		#End If
		AutoFit
	End If
End Sub

''' <summary>
''' Adds a standardized B4XDaisyText section title to the scroll content panel and returns the next Y coordinate.
''' Center: set to True to center the title horizontally.
''' </summary>
Public Sub AddSectionTitle(sText As String, iY As Int, bCenter As Boolean) As Int
    Dim title As B4XDaisyText
    title.Initialize(mCallBack, "")
    Dim w As Int = getUsableWidth
    title.AddToParent(pnlHost, mPagePadding, iY, w, 32dip)
    title.Clickable = False
    title.Text = sText
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 18
    title.FontBold = True
    If bCenter Then
        title.HAlign = "CENTER"
    Else
        title.HAlign = "LEFT"
    End If
    Return iY + title.GetComputedHeight + 8dip
End Sub

''' <summary>
''' Adds a standardized B4XDaisyDivider to the scroll panel and returns the next Y coordinate.
''' </summary>
Public Sub AddDivider(iY As Int) As Int
    Dim div As B4XDaisyDivider
    div.Initialize(mCallBack, "")
    Dim w As Int = getUsableWidth
    div.AddToParent(pnlHost, mPagePadding, iY, w, 20dip)
    Return iY + 20dip + 8dip
End Sub

'-
' Getters and Setters
'-

Public Sub getPagePadding As Int
    Return mPagePadding
End Sub

Public Sub setPagePadding(iValue As Int)
    mPagePadding = iValue
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mBackgroundColor = iValue
    Refresh
End Sub

Public Sub getRootColor As Int
    Return mRootColor
End Sub

Public Sub setRootColor(iValue As Int)
    mRootColor = iValue
    Refresh
End Sub

Public Sub getTransparent As Boolean
    Return mTransparent
End Sub

Public Sub setTransparent(bValue As Boolean)
    mTransparent = bValue
    Refresh
End Sub

Public Sub getYGap As Int
    Return mYGap
End Sub

Public Sub setYGap(iValue As Int)
    mYGap = iValue
    Refresh
End Sub

''' <summary>
''' Returns whether scrolling is enabled.
''' </summary>
Public Sub getScrollEnabled As Boolean
    Return mbScrollEnabled
End Sub

''' <summary>
''' Enables or disables scrolling. When False the scroll gesture is locked but
''' child views (inputs, buttons) remain interactive.
''' </summary>
Public Sub setScrollEnabled(bValue As Boolean)
    mbScrollEnabled = bValue
    #If B4A
        If svHost.IsInitialized Then svHost.Enabled = bValue
    #End If
End Sub



Public Sub getAutoFitHeight As Boolean
    Return mAutoFitHeight
End Sub

Public Sub setAutoFitHeight(bValue As Boolean)
    mAutoFitHeight = bValue
    Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
	#If B4A
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(iDuration, 0, 0, iWidth, iHeight)
	#End If
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
	#If B4A
	If svHost.IsInitialized Then svHost.Width = iValue
	#End If
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
	#If B4A
	If svHost.IsInitialized Then svHost.Height = iValue
	#End If
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
