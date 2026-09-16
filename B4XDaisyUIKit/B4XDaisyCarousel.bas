B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#Event: Changed (Index As Int)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Carousel scroll orientation.
#DesignerProperty: Key: Snap, DisplayName: Snap Position, FieldType: String, DefaultValue: start, List: start|center|end, Description: Carousel snapping behavior.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius variant.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Box shadow elevation level.
#DesignerProperty: Key: NavigationButtons, DisplayName: Navigation Buttons, FieldType: Boolean, DefaultValue: False, Description: Show prev/next navigation buttons overlaid on the carousel.
#DesignerProperty: Key: IndicatorButtons, DisplayName: Indicator Buttons, FieldType: Boolean, DefaultValue: False, Description: Show indicator dot buttons overlaid at the bottom of the carousel.
#DesignerProperty: Key: AutoPlay, DisplayName: Auto Play, FieldType: Boolean, DefaultValue: False, Description: Automatically advance slides on a timed interval.
#DesignerProperty: Key: AutoPlayInterval, DisplayName: AutoPlay Interval (ms), FieldType: Int, DefaultValue: 3000, Description: Milliseconds between auto-advance steps when AutoPlay is enabled.
#DesignerProperty: Key: ItemGap, DisplayName: Item Gap, FieldType: Int, DefaultValue: 0, Description: Gap in pixels between carousel items (space-x-N / space-y-N equivalent).
#DesignerProperty: Key: Gap, DisplayName: Gap (Token), FieldType: String, DefaultValue: , Description: Space between items as a Tailwind/DaisyUI spacing token: space-x-4, gap-2, 16px etc. Overrides Item Gap when non-empty.
#DesignerProperty: Key: ContentPadding, DisplayName: Content Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in pixels of the scroll area inside the carousel container (p-N equivalent).
#DesignerProperty: Key: Padding, DisplayName: Padding (Token), FieldType: String, DefaultValue: , Description: Inner content padding as a Tailwind/DaisyUI spacing token: p-4, p-2, 8px etc. Overrides Content Padding when non-empty.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Width as a Tailwind class: w-full, w-64, w-1/2, w-[300px] etc.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-[300px], Description: Height as a Tailwind class: h-[300px], h-48, h-full, h-[200px], h-auto (auto-fits tallest item) etc.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: , Description: Background color as a DaisyUI/Tailwind token: neutral, base-200, primary, transparent etc.
#DesignerProperty: Key: IndicatorBackgroundColor, DisplayName: Indicator Bg Color, FieldType: Color, DefaultValue: 0x50000000, Description: Color of the indicator strip background.
#DesignerProperty: Key: IndicatorActiveColor, DisplayName: Indicator Active Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Color of the active indicator dot.
#DesignerProperty: Key: IndicatorInactiveColor, DisplayName: Indicator Inactive Color, FieldType: Color, DefaultValue: 0x78FFFFFF, Description: Color of the inactive indicator dots.
#DesignerProperty: Key: IndicatorDotSize, DisplayName: Indicator Dot Size, FieldType: Int, DefaultValue: 10, Description: Size of the indicator dots.
#DesignerProperty: Key: IndicatorDotGap, DisplayName: Indicator Dot Gap, FieldType: Int, DefaultValue: 6, Description: Spacing between indicator dots.
#DesignerProperty: Key: IndicatorOffset, DisplayName: Indicator Offset, FieldType: Int, DefaultValue: 0, Description: Distance to offset the indicator dots strip from its default edge.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region Variables
#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private mVisible As Boolean = True

    
    ' Internal views
    Private mScrollView As B4XView ' HorizontalScrollView or ScrollView
    Private mHScrollView As HorizontalScrollView ' Typed ref for horizontal - needed to wire ScrollChanged event
    Private mVScrollView As ScrollView ' Typed ref for vertical - needed to wire ScrollChanged event
    Private mContentPanel As B4XView
    
    ' Local properties
    Private msOrientation As String = "horizontal"
    Private msSnap As String = "start"
    Private msRounded As String = "theme"
    Private msShadow As String = "none"
    
    Private mItems As List
    Private mIsResizing As Boolean = False
    Private mSnapTimer As Timer
    ' Prevents snap timer from re-triggering during programmatic smooth scroll.
    Private mIsProgrammaticScroll As Boolean = False
    Private mProgrammaticTimer As Timer
    ' Polls HorizontalScrollView.ScrollPosition since Initialize("") suppresses ScrollChanged event.
    Private mScrollPollTimer As Timer
    Private mLastScrollPos As Int = 0
    
    ' Auto-play (timed slide advance)
    Private mbAutoPlay As Boolean = False
    Private mnAutoPlayInterval As Int = 3000
    Private mAutoPlayTimer As Timer
    Private mAutoPlayUserPausedTimer As Timer  ' resumes autoplay after user interaction
    
    ' Overlay controls
    Private mScrollHost As B4XView
    Private mBtnPrev As B4XView
    Private mBtnNext As B4XView
    Private mPnlIndicators As B4XView
    Private mDotViews As List
    Private mbNavigationButtons As Boolean = False
    Private mbIndicatorButtons As Boolean = False
    Private mbEnabled As Boolean = True
    Private mCurrentIndex As Int = 0
    Private mnItemGap As Int = 0
    Private msGap As String = ""          ' Tailwind token override for item gap (e.g. space-x-4)
    Private mnContentPadding As Int = 0
    Private msPaddingToken As String = "" ' Tailwind token override for content padding (e.g. p-4)
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-[300px]"
    Private msBackgroundColor As String = ""
    Private mnIndicatorBackgroundColor As Int = 0x50000000
    Private mnIndicatorActiveColor As Int = 0xFFFFFFFF
    Private mnIndicatorInactiveColor As Int = 0x78FFFFFF
    Private mnIndicatorDotSize As Int = 10dip
    Private mnIndicatorDotGap As Int = 6dip
    Private mnIndicatorOffset As Int = 0dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
    mDotViews.Initialize
    mProgrammaticTimer.Initialize("mProgrammaticTimer", 500)
    mProgrammaticTimer.Enabled = False
    mScrollPollTimer.Initialize("mScrollPollTimer", 80)
    mScrollPollTimer.Enabled = False
    mAutoPlayTimer.Initialize("mAutoPlayTimer", 3000)
    mAutoPlayTimer.Enabled = False
    mAutoPlayUserPausedTimer.Initialize("mAutoPlayUserPausedTimer", 3000)
    mAutoPlayUserPausedTimer.Enabled = False
    mSnapTimer.Initialize("mSnapTimer", 200)
    mSnapTimer.Enabled = False
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ApplyDesignerProps(mProps)
    
    If mSnapTimer.IsInitialized = False Then
        mSnapTimer.Initialize("mSnapTimer", 200)
        mSnapTimer.Enabled = False
    End If
    
    UpdateScrollContainer
    mBase.Visible = mVisible
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    msOrientation = B4XDaisyVariants.GetPropString(mProps, "Orientation", msOrientation)
    msSnap = B4XDaisyVariants.GetPropString(mProps, "Snap", msSnap)
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))

    ' Backward compatibility: migrate legacy RoundedBox=True designer prop
    If mProps.ContainsKey("RoundedBox") Then
        Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
        If bLegacyBox And (msRounded = "theme" Or msRounded = "") Then
            msRounded = "rounded-box"
        End If
    End If
    mbNavigationButtons = B4XDaisyVariants.GetPropBool(mProps, "NavigationButtons", mbNavigationButtons)
    mbIndicatorButtons = B4XDaisyVariants.GetPropBool(mProps, "IndicatorButtons", mbIndicatorButtons)
    mnItemGap = B4XDaisyVariants.GetPropInt(mProps, "ItemGap", mnItemGap)
    msGap = B4XDaisyVariants.GetPropString(mProps, "Gap", msGap)
    If msGap <> "" Then mnItemGap = B4XDaisyVariants.TailwindSpacingToDip(msGap, 0)
    mnContentPadding = B4XDaisyVariants.GetPropInt(mProps, "ContentPadding", mnContentPadding)
    msPaddingToken = B4XDaisyVariants.GetPropString(mProps, "Padding", msPaddingToken)
    If msPaddingToken <> "" Then mnContentPadding = B4XDaisyVariants.TailwindSpacingToDip(msPaddingToken, 0)
    msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", msWidth)
    msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", msHeight)
    msBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "BackgroundColor", msBackgroundColor)
    mnIndicatorBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "IndicatorBackgroundColor", mnIndicatorBackgroundColor)
    mnIndicatorActiveColor = B4XDaisyVariants.GetPropInt(mProps, "IndicatorActiveColor", mnIndicatorActiveColor)
    mnIndicatorInactiveColor = B4XDaisyVariants.GetPropInt(mProps, "IndicatorInactiveColor", mnIndicatorInactiveColor)
    mnIndicatorDotSize = B4XDaisyVariants.GetPropInt(mProps, "IndicatorDotSize", 10) * 1dip
    mnIndicatorDotGap = B4XDaisyVariants.GetPropInt(mProps, "IndicatorDotGap", 6) * 1dip
    mnIndicatorOffset = B4XDaisyVariants.GetPropInt(mProps, "IndicatorOffset", 0) * 1dip
    msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow)
    mbAutoPlay = B4XDaisyVariants.GetPropBool(mProps, "AutoPlay", mbAutoPlay)
    mnAutoPlayInterval = B4XDaisyVariants.GetPropInt(mProps, "AutoPlayInterval", mnAutoPlayInterval)
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    If mnAutoPlayInterval < 500 Then mnAutoPlayInterval = 500
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", msWidth)
	props.Put("Height", msHeight)
	props.Put("Orientation", msOrientation)
	props.Put("Snap", msSnap)
	props.Put("Rounded", msRounded)
	props.Put("NavigationButtons", mbNavigationButtons)
	props.Put("IndicatorButtons", mbIndicatorButtons)
	props.Put("ItemGap", mnItemGap)
	props.Put("Gap", msGap)
	props.Put("ContentPadding", mnContentPadding)
	props.Put("Padding", msPaddingToken)
	props.Put("BackgroundColor", msBackgroundColor)
	props.Put("IndicatorBackgroundColor", mnIndicatorBackgroundColor)
	props.Put("IndicatorActiveColor", mnIndicatorActiveColor)
	props.Put("IndicatorInactiveColor", mnIndicatorInactiveColor)
	props.Put("IndicatorDotSize", mnIndicatorDotSize / 1dip)
	props.Put("IndicatorDotGap", mnIndicatorDotGap / 1dip)
	props.Put("IndicatorOffset", mnIndicatorOffset / 1dip)
	props.Put("Shadow", msShadow)
	props.Put("AutoPlay", mbAutoPlay)
	props.Put("AutoPlayInterval", mnAutoPlayInterval)
	props.Put("Enabled", mbEnabled)
	props.Put("Visible", mVisible)
	Return props
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("mBase")
	p.Width = iWidth
	p.Height = iHeight
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Base_Resize(iWidth, iHeight)
	Return mBase
End Sub
#End Region

#Region Public API
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    If mScrollHost.IsInitialized = False Then Return
    
    ' RoundedBox (DaisyUI semantic token) takes priority over the manual Rounded string.
    Dim radius As Int
    If msRounded = "rounded-box" Or msRounded = "theme" Then
        radius = B4XDaisyVariants.ResolveRoundedDip("rounded-box", 0)
    Else
        radius = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    End If
    
    ' Resolve background color from Tailwind/DaisyUI token string.
    Dim bgColor As Int
    If msBackgroundColor = "" Or msBackgroundColor = "transparent" Or msBackgroundColor = "none" Then
        bgColor = xui.Color_Transparent
    Else
        ' Strip bg- prefix if present so "bg-neutral" and "neutral" both work.
        Dim colorToken As String = msBackgroundColor
        If colorToken.ToLowerCase.StartsWith("bg-") Then colorToken = colorToken.SubString(3)
        bgColor = B4XDaisyVariants.ResolveBackgroundColorVariant(colorToken, xui.Color_Transparent)
    End If
    
    ' Apply rounded corners + background color to mBase (no clip - keeps overlays visible).
    mBase.SetColorAndBorder(bgColor, 0, 0, radius)
    ' Apply shadow elevation (DaisyUI shadow utility).
    B4XDaisyVariants.ApplyElevation(mBase, msShadow)
    ' Disabled: dim the whole carousel so it reads as inactive.
    mBase.Alpha = IIf(mbEnabled, 1.0, 0.3)
    
    ' Apply rounded corners + clip to mScrollHost so scroll content is masked.
    mScrollHost.SetColorAndBorder(xui.Color_Transparent, 0, 0, radius)
    B4XDaisyVariants.SetOverflowHidden(mScrollHost)
    
    ' Update items layout
    LayoutItems
    
    ' Build/refresh overlaid nav buttons and indicator dots
    LayoutOverlays
    
    ' Sync auto-play timer: ensure running when enabled+has items, paused otherwise.
    If mbAutoPlay And mItems.Size > 0 Then
        mAutoPlayTimer.Interval = mnAutoPlayInterval
        If mAutoPlayTimer.Enabled = False And mAutoPlayUserPausedTimer.Enabled = False Then
            mAutoPlayTimer.Enabled = True
        End If
    Else If mbAutoPlay = False Then
        mAutoPlayTimer.Enabled = False
    End If
    
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	Dim refW As Int = iWidth
	If refW <= 0 Then refW = vParent.Width
	Dim refH As Int = iHeight
	If refH <= 0 Then refH = vParent.Height
	Dim actualW As Int = B4XDaisyVariants.TailwindSizeToDip(msWidth, refW)
	Dim actualH As Int
	If msHeight = "h-auto" Or msHeight = "auto" Then
		actualH = 1dip
	Else
		actualH = B4XDaisyVariants.TailwindSizeToDip(msHeight, refH)
	End If
	If actualW < 1 Then actualW = Max(1, refW)
	If actualH < 1 Then actualH = Max(1, refH)
	
	If mBase.IsInitialized = False Then
		CreateView(actualW, actualH)
	End If
	vParent.AddView(mBase, iLeft, iTop, actualW, actualH)
	Return mBase
End Sub

Private Sub UpdateScrollContainer
    If mBase.IsInitialized = False Then Return
    
    ' Remove old scroll host (its children - mScrollView - are removed with it)
    If mScrollHost.IsInitialized Then mScrollHost.RemoveViewFromParent
    
    ' mScrollHost is the clipped inner area; overlay views live on mBase above it
    Dim pHost As Panel
    pHost.Initialize("mBase")
    mScrollHost = pHost
    mScrollHost.Color = xui.Color_Transparent
    Dim cp As Int = mnContentPadding
    mBase.AddView(mScrollHost, cp, cp, Max(1, mBase.Width - cp * 2), Max(1, mBase.Height - cp * 2))
    
    If msOrientation = "horizontal" Then
        mHScrollView.Initialize(0, "")
        mScrollView = mHScrollView
        ' Hide scrollbar (DaisyUI: scrollbar-width: none / ::-webkit-scrollbar { display: none })
        Dim joH As JavaObject = mHScrollView
        joH.RunMethod("setHorizontalScrollBarEnabled", Array(False))
    Else
        mVScrollView.Initialize(0)
        mScrollView = mVScrollView
        ' Hide scrollbar (DaisyUI: scrollbar-width: none / ::-webkit-scrollbar { display: none })
        Dim jo As JavaObject = mVScrollView
        jo.RunMethod("setVerticalScrollBarEnabled", Array(False))
    End If
    mScrollPollTimer.Enabled = True
    
    mScrollHost.AddView(mScrollView, 0, 0, mScrollHost.Width, mScrollHost.Height)
    
    ' Get Inner Panel (Content Panel)
    If msOrientation = "horizontal" Then
        mContentPanel = mHScrollView.Panel
    Else
        mContentPanel = mVScrollView.Panel
    End If
    
    mContentPanel.Color = xui.Color_Transparent
    #If B4A
    AttachTouchDisallow(mScrollView)
    AttachTouchDisallow(mContentPanel)
    #End If
    
    ' Re-parent any existing items into the new content panel, preserving their sizes
    For Each itm As B4XDaisyCarouselItem In mItems
        If itm.mBase.IsInitialized Then
            Dim savedW As Int = itm.mBase.Width
            Dim savedH As Int = itm.mBase.Height
            If savedW < 1 Then savedW = 100dip
            If savedH < 1 Then savedH = 100dip
            itm.RemoveViewFromParent
            mContentPanel.AddView(itm.mBase, 0, 0, savedW, savedH)
            #If B4A
            AttachTouchDisallow(itm.mBase)
            #End If
        End If
    Next
End Sub

Public Sub AddItem(Item As B4XDaisyCarouselItem)
    If mItems.IndexOf(Item) = -1 Then mItems.Add(Item)
    If Item.mBase.IsInitialized = False Or Item.mBase.Parent <> mContentPanel Then
        ' Auto-parent the item into the content panel, resolving its Width/Height tokens
        ' against the scroll host dimensions (more reliable than mContentPanel which may be 0).
        ' LayoutItems will re-resolve them accurately at Refresh time.
        If Item.mBase.IsInitialized And Item.mBase.Parent <> Null Then Item.mBase.RemoveViewFromParent
        Dim refW As Int = mScrollHost.Width
        If refW < 1 Then refW = Max(1, mBase.Width - mnContentPadding * 2)
        Dim refH As Int = mScrollHost.Height
        If refH < 1 Then refH = Max(1, mBase.Height - mnContentPadding * 2)
        Item.AddToParent(mContentPanel, 0, 0, refW, refH)
        #If B4A
        AttachTouchDisallow(Item.mBase)
        #End If
    End If
    Refresh
End Sub

Public Sub RemoveItem(Item As B4XDaisyCarouselItem)
    Dim idx As Int = mItems.IndexOf(Item)
    If idx > -1 Then
        mItems.RemoveAt(idx)
        Item.mBase.RemoveViewFromParent
        Refresh
    End If
End Sub

Public Sub Clear
    For Each itm As B4XDaisyCarouselItem In mItems
        itm.mBase.RemoveViewFromParent
    Next
    mItems.Clear
    mCurrentIndex = 0
    Refresh
End Sub

Private Sub LayoutItems
    If mItems.Size = 0 Then Return
    
    Dim currentPos As Int = 0
    Dim itemCount As Int = mItems.Size
    For i = 0 To itemCount - 1
        Dim itm As B4XDaisyCarouselItem = mItems.Get(i)
        If itm.mBase.IsInitialized = False Then Continue
        Dim gap As Int = 0
        If i < itemCount - 1 Then gap = mnItemGap
        
        If msOrientation = "horizontal" Then
            Dim scrollH As Int = mScrollHost.Height
            If scrollH < 1 Then scrollH = mBase.Height - mnContentPadding * 2
            Dim scrollW As Int = mScrollHost.Width
            If scrollW < 1 Then scrollW = mBase.Width - mnContentPadding * 2
            ' Re-resolve width and height tokens against current scroll host dimensions.
            Dim itemW As Int = B4XDaisyVariants.TailwindSizeToDip(itm.Width, scrollW)
            ' w-auto: item frame inherits its ImageWidth token size
            If itm.Width = "w-auto" Or itm.Width = "auto" Then
                Dim autoW As Int = B4XDaisyVariants.TailwindSizeToDip(itm.ImageWidth, scrollW)
                If autoW > 0 Then itemW = autoW
            End If
            If itemW < 1 Then itemW = itm.mBase.Width
            If itemW < 1 Then itemW = scrollW
            Dim itemH As Int = B4XDaisyVariants.TailwindSizeToDip(itm.Height, scrollH)
            ' h-auto: item frame inherits its ImageHeight token size
            If itm.Height = "h-auto" Or itm.Height = "auto" Then
                Dim autoH As Int = B4XDaisyVariants.TailwindSizeToDip(itm.ImageHeight, scrollH)
                If autoH > 0 Then itemH = autoH
            End If
            If itemH < 1 Then itemH = itm.mBase.Height
            If itemH < 1 Then itemH = scrollH
            itm.mBase.SetLayoutAnimated(0, currentPos, 0, itemW, itemH)
            itm.Base_Resize(itemW, itemH)
            currentPos = currentPos + itemW + gap
        Else
            Dim scrollW2 As Int = mScrollHost.Width
            If scrollW2 < 1 Then scrollW2 = mBase.Width - mnContentPadding * 2
            Dim scrollH2 As Int = mScrollHost.Height
            If scrollH2 < 1 Then scrollH2 = mBase.Height - mnContentPadding * 2
            ' Re-resolve width and height tokens against current scroll host dimensions.
            Dim itemH2 As Int = B4XDaisyVariants.TailwindSizeToDip(itm.Height, scrollH2)
            ' h-auto: item frame inherits its ImageHeight token size
            If itm.Height = "h-auto" Or itm.Height = "auto" Then
                Dim autoH2 As Int = B4XDaisyVariants.TailwindSizeToDip(itm.ImageHeight, scrollH2)
                If autoH2 > 0 Then itemH2 = autoH2
            End If
            If itemH2 < 1 Then itemH2 = itm.mBase.Height
            If itemH2 < 1 Then itemH2 = scrollH2
            Dim itemW2 As Int = B4XDaisyVariants.TailwindSizeToDip(itm.Width, scrollW2)
            ' w-auto: item frame inherits its ImageWidth token size
            If itm.Width = "w-auto" Or itm.Width = "auto" Then
                Dim autoW2 As Int = B4XDaisyVariants.TailwindSizeToDip(itm.ImageWidth, scrollW2)
                If autoW2 > 0 Then itemW2 = autoW2
            End If
            If itemW2 < 1 Then itemW2 = itm.mBase.Width
            If itemW2 < 1 Then itemW2 = scrollW2
            itm.mBase.SetLayoutAnimated(0, 0, currentPos, itemW2, itemH2)
            itm.Base_Resize(itemW2, itemH2)
            currentPos = currentPos + itemH2 + gap
        End If
    Next
    
    ' h-auto: resize mBase and mScrollHost to the tallest (H) or widest (V) item.
    Dim isAutoH As Boolean = (msHeight = "h-auto" Or msHeight = "auto")
    If isAutoH And msOrientation = "horizontal" Then
        Dim maxItemH As Int = 0
        For i = 0 To mItems.Size - 1
            Dim itmH As B4XDaisyCarouselItem = mItems.Get(i)
            maxItemH = Max(maxItemH, itmH.mBase.Height)
        Next
        If maxItemH > 0 Then
            Dim newH As Int = maxItemH + mnContentPadding * 2
            mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, newH)
            Dim cp As Int = mnContentPadding
            mScrollHost.SetLayoutAnimated(0, cp, cp, Max(1, mBase.Width - cp * 2), Max(1, newH - cp * 2))
        End If
    End If

    ' Update content panel size
    Dim scrollHostH As Int = mScrollHost.Height
    Dim scrollHostW As Int = mScrollHost.Width
    If scrollHostH < 1 Then scrollHostH = mBase.Height - mnContentPadding * 2
    If scrollHostW < 1 Then scrollHostW = mBase.Width - mnContentPadding * 2
    If msOrientation = "horizontal" Then
        mContentPanel.Width = Max(currentPos, scrollHostW)
        Dim contentH As Int = scrollHostH
        For i = 0 To mItems.Size - 1
            Dim itmH As B4XDaisyCarouselItem = mItems.Get(i)
            If itmH.mBase.IsInitialized Then contentH = Max(contentH, itmH.mBase.Height)
        Next
        mContentPanel.Height = contentH
    Else
        Dim contentW As Int = scrollHostW
        For i = 0 To mItems.Size - 1
            Dim itmW As B4XDaisyCarouselItem = mItems.Get(i)
            If itmW.mBase.IsInitialized Then contentW = Max(contentW, itmW.mBase.Width)
        Next
        mContentPanel.Width = contentW
        mContentPanel.Height = Max(currentPos, scrollHostH)
    End If
End Sub

Public Sub ScrollToItem(iIndex As Int)
    If iIndex < 0 Or iIndex >= mItems.Size Then Return
    Dim itm As B4XDaisyCarouselItem = mItems.Get(iIndex)
    Dim viewportSize As Int
    If msOrientation = "horizontal" Then
        viewportSize = mScrollHost.Width
        If viewportSize < 1 Then viewportSize = mBase.Width - mnContentPadding * 2
    Else
        viewportSize = mScrollHost.Height
        If viewportSize < 1 Then viewportSize = mBase.Height - mnContentPadding * 2
    End If
    
    Dim targetPos As Int
    Select msSnap
        Case "start"
            If msOrientation = "horizontal" Then
                targetPos = itm.mBase.Left
            Else
                targetPos = itm.mBase.Top
            End If
        Case "center"
            If msOrientation = "horizontal" Then
                targetPos = itm.mBase.Left + (itm.mBase.Width / 2) - (viewportSize / 2)
            Else
                targetPos = itm.mBase.Top + (itm.mBase.Height / 2) - (viewportSize / 2)
            End If
        Case "end"
            If msOrientation = "horizontal" Then
                targetPos = (itm.mBase.Left + itm.mBase.Width) - viewportSize
            Else
                targetPos = (itm.mBase.Top + itm.mBase.Height) - viewportSize
            End If
    End Select
    
    targetPos = Max(0, targetPos)
    
    ' Use smooth scroll (DaisyUI: scroll-behavior: smooth).
    ' Set flag so snap timer is suppressed during the animation.
    mIsProgrammaticScroll = True
    mProgrammaticTimer.Enabled = False
    mProgrammaticTimer.Enabled = True
    
    Dim joScroll As JavaObject = mScrollView
    If msOrientation = "horizontal" Then
        joScroll.RunMethod("smoothScrollTo", Array(targetPos, 0))
    Else
        joScroll.RunMethod("smoothScrollTo", Array(0, targetPos))
    End If
    
    Dim oldIndex As Int = mCurrentIndex
    mCurrentIndex = iIndex
    UpdateDots
    If oldIndex <> mCurrentIndex Then
        If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
            CallSub2(mCallBack, mEventName & "_Changed", mCurrentIndex)
        End If
    End If
End Sub

Public Sub getOrientation As String
    Return msOrientation
End Sub

Public Sub setOrientation(sValue As String)
    msOrientation = sValue
    UpdateScrollContainer
    Refresh
End Sub

Public Sub getSnap As String
    Return msSnap
End Sub

Public Sub setSnap(sValue As String)
    msSnap = sValue
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setRounded(sValue As String)
    msRounded = sValue
    Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getItemGap As Int
    Return mnItemGap
End Sub

Public Sub setItemGap(iValue As Int)
    mnItemGap = iValue
    msGap = ""  ' raw dip wins; clear token override
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getGap As String
    Return msGap
End Sub

Public Sub setGap(sValue As String)
    msGap = sValue
    If sValue <> "" Then mnItemGap = B4XDaisyVariants.TailwindSpacingToDip(sValue, 0)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getContentPadding As Int
    Return mnContentPadding
End Sub

Public Sub setContentPadding(iValue As Int)
    mnContentPadding = iValue
    msPaddingToken = ""  ' raw dip wins; clear token override
    If mBase.IsInitialized Then
        UpdateScrollContainer
        Refresh
    End If
End Sub

Public Sub getPadding As String
    Return msPaddingToken
End Sub

Public Sub setPadding(sValue As String)
    msPaddingToken = sValue
    If sValue <> "" Then mnContentPadding = B4XDaisyVariants.TailwindSpacingToDip(sValue, 0)
    If mBase.IsInitialized Then
        UpdateScrollContainer
        Refresh
    End If
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setWidth(sValue As String)
    msWidth = sValue
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setHeight(sValue As String)
    msHeight = sValue
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setBackgroundColor(sValue As String)
    msBackgroundColor = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getNavigationButtons As Boolean
    Return mbNavigationButtons
End Sub

Public Sub setNavigationButtons(bValue As Boolean)
    mbNavigationButtons = bValue
    If mBase.IsInitialized Then LayoutOverlays
End Sub

Public Sub getIndicatorButtons As Boolean
    Return mbIndicatorButtons
End Sub

Public Sub setIndicatorButtons(bValue As Boolean)
    mbIndicatorButtons = bValue
    If mBase.IsInitialized Then LayoutOverlays
End Sub

Public Sub getAutoPlay As Boolean
    Return mbAutoPlay
End Sub

Public Sub setAutoPlay(bValue As Boolean)
    mbAutoPlay = bValue
    If bValue Then
        StartAutoPlay
    Else
        StopAutoPlay
    End If
End Sub

Public Sub getAutoPlayInterval As Int
    Return mnAutoPlayInterval
End Sub

Public Sub setAutoPlayInterval(iValue As Int)
    mnAutoPlayInterval = Max(500, iValue)
    mAutoPlayTimer.Interval = mnAutoPlayInterval
End Sub

' Start auto-sliding at the current AutoPlayInterval.
Public Sub StartAutoPlay
    If mItems.Size = 0 Then Return
    mbAutoPlay = True
    mAutoPlayUserPausedTimer.Enabled = False
    mAutoPlayTimer.Interval = mnAutoPlayInterval
    mAutoPlayTimer.Enabled = True
End Sub

' Stop auto-sliding and disable all auto-play timers.
Public Sub StopAutoPlay
    mbAutoPlay = False
    mAutoPlayTimer.Enabled = False
    mAutoPlayUserPausedTimer.Enabled = False
End Sub

' Pause all timers when the view or parent page becomes inactive.
Public Sub Pause
    mScrollPollTimer.Enabled = False
    mAutoPlayTimer.Enabled = False
    mAutoPlayUserPausedTimer.Enabled = False
    mSnapTimer.Enabled = False
    mProgrammaticTimer.Enabled = False
End Sub

' Resume timers when the view or parent page becomes active.
Public Sub Resume
    mScrollPollTimer.Enabled = True
    If mbAutoPlay Then mAutoPlayTimer.Enabled = True
End Sub


Public Sub getCurrentIndex As Int
    Return mCurrentIndex
End Sub

Public Sub getVisible As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Visible
End Sub

Public Sub setVisible(bValue As Boolean)
	    mVisible = bValue
	    If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized Then
        mBase.Enabled = bValue
        Refresh
    End If
End Sub

Public Sub getRoundedBox As Boolean
    Return (msRounded = "rounded-box" Or msRounded = "theme")
End Sub

Public Sub setRoundedBox(bValue As Boolean)
    If bValue Then
        setRounded("rounded-box")
    Else
        setRounded("rounded-none")
    End If
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIndicatorBackgroundColor As Int
    Return mnIndicatorBackgroundColor
End Sub

Public Sub setIndicatorBackgroundColor(iValue As Int)
    mnIndicatorBackgroundColor = iValue
    If mPnlIndicators.IsInitialized Then mPnlIndicators.Color = iValue
End Sub

Public Sub getIndicatorActiveColor As Int
    Return mnIndicatorActiveColor
End Sub

Public Sub setIndicatorActiveColor(iValue As Int)
    mnIndicatorActiveColor = iValue
    If mBase.IsInitialized Then UpdateDots
End Sub

Public Sub getIndicatorInactiveColor As Int
    Return mnIndicatorInactiveColor
End Sub

Public Sub setIndicatorInactiveColor(iValue As Int)
    mnIndicatorInactiveColor = iValue
    If mBase.IsInitialized Then UpdateDots
End Sub

Public Sub getIndicatorDotSize As Int
    Return mnIndicatorDotSize
End Sub

Public Sub setIndicatorDotSize(iValue As Int)
    mnIndicatorDotSize = iValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIndicatorDotGap As Int
    Return mnIndicatorDotGap
End Sub

Public Sub setIndicatorDotGap(iValue As Int)
    mnIndicatorDotGap = iValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIndicatorOffset As Int
    Return mnIndicatorOffset
End Sub

Public Sub setIndicatorOffset(iValue As Int)
    mnIndicatorOffset = iValue
    If mBase.IsInitialized Then Refresh
End Sub

' Build (or rebuild) the nav buttons and indicator dots overlaid on mBase.
' Called from Refresh and whenever NavigationButtons/IndicatorButtons props change.
Private Sub LayoutOverlays
    If mBase.IsInitialized = False Then Return
    
    Dim NAV_SIZE As Int = 38dip
    Dim NAV_MARGIN As Int = 8dip
    Dim DOT_SIZE As Int = mnIndicatorDotSize
    Dim DOT_GAP As Int = mnIndicatorDotGap
    Dim INDICATOR_STRIP As Int = Max(32dip, DOT_SIZE + 12dip)   ' height (horizontal) or width (vertical) of dot strip
    Dim isVertical As Boolean = (msOrientation = "vertical")
    
    ' --- Navigation prev/next buttons ---
    If mBtnPrev.IsInitialized Then mBtnPrev.RemoveViewFromParent
    If mBtnNext.IsInitialized Then mBtnNext.RemoveViewFromParent
    
    If mbNavigationButtons Then
        If isVertical Then
            ' Vertical: prev on top-center, next on bottom-center; use ?/?
            Dim btnCenterX As Int = (mBase.Width - NAV_SIZE) / 2
            
            Dim pPrev As Panel
            pPrev.Initialize("mBtnPrev")
            mBtnPrev = pPrev
            mBtnPrev.SetColorAndBorder(xui.Color_ARGB(180, 0, 0, 0), 0, 0, NAV_SIZE / 2)
            mBase.AddView(mBtnPrev, btnCenterX, NAV_MARGIN, NAV_SIZE, NAV_SIZE)
            Dim lblPrev As Label
            lblPrev.Initialize("")
            lblPrev.Text = Chr(9650)   ' ?
            lblPrev.Gravity = Gravity.CENTER
            lblPrev.TextColor = xui.Color_White
            lblPrev.TextSize = 16
            mBtnPrev.AddView(lblPrev, 0, 0, NAV_SIZE, NAV_SIZE)
            
            Dim pNext As Panel
            pNext.Initialize("mBtnNext")
            mBtnNext = pNext
            mBtnNext.SetColorAndBorder(xui.Color_ARGB(180, 0, 0, 0), 0, 0, NAV_SIZE / 2)
            mBase.AddView(mBtnNext, btnCenterX, mBase.Height - NAV_MARGIN - NAV_SIZE, NAV_SIZE, NAV_SIZE)
            Dim lblNext As Label
            lblNext.Initialize("")
            lblNext.Text = Chr(9660)   ' ?
            lblNext.Gravity = Gravity.CENTER
            lblNext.TextColor = xui.Color_White
            lblNext.TextSize = 16
            mBtnNext.AddView(lblNext, 0, 0, NAV_SIZE, NAV_SIZE)
        Else
            ' Horizontal: prev on left-center, next on right-center; use ?/?
            Dim btnCenterY As Int = (mBase.Height - NAV_SIZE) / 2
            
            Dim pPrev As Panel
            pPrev.Initialize("mBtnPrev")
            mBtnPrev = pPrev
            mBtnPrev.SetColorAndBorder(xui.Color_ARGB(180, 0, 0, 0), 0, 0, NAV_SIZE / 2)
            mBase.AddView(mBtnPrev, NAV_MARGIN, btnCenterY, NAV_SIZE, NAV_SIZE)
            Dim lblPrev As Label
            lblPrev.Initialize("")
            lblPrev.Text = Chr(10094)  ' ?
            lblPrev.Gravity = Gravity.CENTER
            lblPrev.TextColor = xui.Color_White
            lblPrev.TextSize = 16
            mBtnPrev.AddView(lblPrev, 0, 0, NAV_SIZE, NAV_SIZE)
            
            Dim pNext As Panel
            pNext.Initialize("mBtnNext")
            mBtnNext = pNext
            mBtnNext.SetColorAndBorder(xui.Color_ARGB(180, 0, 0, 0), 0, 0, NAV_SIZE / 2)
            mBase.AddView(mBtnNext, mBase.Width - NAV_MARGIN - NAV_SIZE, btnCenterY, NAV_SIZE, NAV_SIZE)
            Dim lblNext As Label
            lblNext.Initialize("")
            lblNext.Text = Chr(10095)  ' ?
            lblNext.Gravity = Gravity.CENTER
            lblNext.TextColor = xui.Color_White
            lblNext.TextSize = 16
            mBtnNext.AddView(lblNext, 0, 0, NAV_SIZE, NAV_SIZE)
        End If
    End If
    
    ' --- Indicator dots ---
    If mPnlIndicators.IsInitialized Then mPnlIndicators.RemoveViewFromParent
    mDotViews.Clear
    
    If mbIndicatorButtons And mItems.Size > 0 Then
        Dim p As Panel
        p.Initialize("")
        mPnlIndicators = p
        mPnlIndicators.Color = mnIndicatorBackgroundColor
        
        If isVertical Then
            ' Vertical: dot column on the right edge, vertically centered, offset inwards
            mBase.AddView(mPnlIndicators, mBase.Width - INDICATOR_STRIP - mnIndicatorOffset, 0, INDICATOR_STRIP, mBase.Height)
            
            Dim totalH As Int = mItems.Size * (DOT_SIZE + DOT_GAP) - DOT_GAP
            Dim startY As Int = (mBase.Height - totalH) / 2
            Dim dotX As Int = (INDICATOR_STRIP - DOT_SIZE) / 2
            
            For i = 0 To mItems.Size - 1
                Dim dot As Panel
                dot.Initialize("mDotBtn")
                dot.Tag = i
                Dim dv As B4XView = dot
                mPnlIndicators.AddView(dv, dotX, startY + i * (DOT_SIZE + DOT_GAP), DOT_SIZE, DOT_SIZE)
                mDotViews.Add(dv)
            Next
        Else
            ' Horizontal: dot row along the bottom edge, horizontally centered, offset upwards
            mBase.AddView(mPnlIndicators, 0, mBase.Height - INDICATOR_STRIP - mnIndicatorOffset, mBase.Width, INDICATOR_STRIP)
            
            Dim totalW As Int = mItems.Size * (DOT_SIZE + DOT_GAP) - DOT_GAP
            Dim startX As Int = (mBase.Width - totalW) / 2
            Dim dotY As Int = (INDICATOR_STRIP - DOT_SIZE) / 2
            
            For i = 0 To mItems.Size - 1
                Dim dot As Panel
                dot.Initialize("mDotBtn")
                dot.Tag = i
                Dim dv As B4XView = dot
                mPnlIndicators.AddView(dv, startX + i * (DOT_SIZE + DOT_GAP), dotY, DOT_SIZE, DOT_SIZE)
                mDotViews.Add(dv)
            Next
        End If
        UpdateDots
    End If

    ' Reflect the component enabled state on the interactive overlays so a disabled
    ' carousel cannot be driven by its nav buttons or indicator dots.
    If mBtnPrev.IsInitialized Then mBtnPrev.Enabled = mbEnabled
    If mBtnNext.IsInitialized Then mBtnNext.Enabled = mbEnabled
    For i = 0 To mDotViews.Size - 1
        Dim dView As B4XView = mDotViews.Get(i)
        dView.Enabled = mbEnabled
    Next
End Sub

' Refresh which dot is highlighted to match mCurrentIndex.
Private Sub UpdateDots
    If mDotViews.Size = 0 Then Return
    Dim DOT_SIZE As Int = mnIndicatorDotSize
    For i = 0 To mDotViews.Size - 1
        Dim dv As B4XView = mDotViews.Get(i)
        If i = mCurrentIndex Then
            dv.SetColorAndBorder(mnIndicatorActiveColor, 0, 0, DOT_SIZE / 2)
        Else
            dv.SetColorAndBorder(mnIndicatorInactiveColor, 0, 0, DOT_SIZE / 2)
        End If
    Next
End Sub

Private Sub mBtnPrev_Click
    If mbEnabled = False Then Return
    ScrollToItem(Max(0, mCurrentIndex - 1))
End Sub

Private Sub mBtnNext_Click
    If mbEnabled = False Then Return
    ScrollToItem(Min(mItems.Size - 1, mCurrentIndex + 1))
End Sub

Private Sub mDotBtn_Click
    If mbEnabled = False Then Return
    Dim clickedDot As B4XView = Sender
    If clickedDot.Tag <> Null Then
        ScrollToItem(clickedDot.Tag)
    End If
End Sub

Private Sub mScrollView_ScrollChanged(iPosition As Int)
    ' Suppress snap timer during programmatic smooth scroll.
    If mIsProgrammaticScroll Then Return
    ' User-initiated scroll: pause auto-play briefly so user can view the current slide.
    If mbAutoPlay Then
        mAutoPlayTimer.Enabled = False
        mAutoPlayUserPausedTimer.Interval = Max(2000, mnAutoPlayInterval)
        mAutoPlayUserPausedTimer.Enabled = False
        mAutoPlayUserPausedTimer.Enabled = True
    End If
    ' Reset snap debounce timer.
    mSnapTimer.Enabled = False
    mSnapTimer.Enabled = True
End Sub

' Vertical ScrollView typed-variable event - delegates to shared snap logic.
Private Sub mVScrollView_ScrollChanged(iPosition As Int)
    mScrollView_ScrollChanged(iPosition)
End Sub

' Horizontal ScrollView typed-variable event - delegates to shared snap logic.
Private Sub mHScrollView_ScrollChanged(iPosition As Int)
    mScrollView_ScrollChanged(iPosition)
End Sub



#If B4A
Private Sub AttachTouchDisallow(vView As B4XView)
    If vView.IsInitialized = False Then Return
    Try
        Dim jo As JavaObject = vView
        Dim listener As Object = jo.CreateEventFromUI("android.view.View$OnTouchListener", "OnTouch", False)
        jo.RunMethod("setOnTouchListener", Array(listener))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCarousel.AttachTouchDisallow: " & LastException.Message)
    End Try
End Sub

Private Sub OnTouch_Event (sMethodName As String, oArgs() As Object) As Object
    If oArgs.Length > 1 Then
        Try
            Dim motionEvent As JavaObject = oArgs(1)
            Dim action As Int = motionEvent.RunMethod("getActionMasked", Null)
            B4XDaisyVariants.RequestDisallowParentIntercept(mBase, action)
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCarousel.OnTouch_Event: " & LastException.Message)
        End Try
    End If
    Return False ' Return False so native view touch processing continues normally
End Sub
#End If

Private Sub mBase_Touch(iAction As Int, fX As Float, fY As Float) As Boolean
    #If B4A
    B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
    #End If
    Return False ' never consume - let inner ScrollView handle the scroll
End Sub

Private Sub mSnapTimer_Tick
    mSnapTimer.Enabled = False
    SnapToNearestItem
End Sub

' Resets the programmatic-scroll guard 500ms after smooth scroll starts,
' allowing the snap timer to respond to user drags again.
Private Sub mProgrammaticTimer_Tick
    mProgrammaticTimer.Enabled = False
    mIsProgrammaticScroll = False
End Sub

' Advances the carousel to the next slide, wrapping around to the first after the last.
Private Sub mAutoPlayTimer_Tick
    If mItems.Size = 0 Then Return
    Dim nextIdx As Int = (mCurrentIndex + 1) Mod mItems.Size
    ScrollToItem(nextIdx)
End Sub

' Resumes auto-play after the user-scroll pause period expires.
Private Sub mAutoPlayUserPausedTimer_Tick
    mAutoPlayUserPausedTimer.Enabled = False
    If mbAutoPlay And mItems.Size > 0 Then
        mAutoPlayTimer.Interval = mnAutoPlayInterval
        mAutoPlayTimer.Enabled = True
    End If
End Sub

' Polls ScrollPosition every 80ms to detect user scroll
' (compensates for scrollviews using empty event name to avoid setEventName crash).
Private Sub mScrollPollTimer_Tick
    If mIsProgrammaticScroll Then Return
    Dim pos As Int = 0
    If msOrientation = "horizontal" Then
        If mHScrollView.IsInitialized = False Then Return
        pos = mHScrollView.ScrollPosition
    Else
        If mVScrollView.IsInitialized = False Then Return
        pos = mVScrollView.ScrollPosition
    End If
    If pos <> mLastScrollPos Then
        mLastScrollPos = pos
        ' User-initiated scroll: pause auto-play briefly.
        If mbAutoPlay Then
            mAutoPlayTimer.Enabled = False
            mAutoPlayUserPausedTimer.Interval = Max(2000, mnAutoPlayInterval)
            mAutoPlayUserPausedTimer.Enabled = False
            mAutoPlayUserPausedTimer.Enabled = True
        End If
        ' Mirror what mScrollView_ScrollChanged would do: reset snap debounce timer.
        mSnapTimer.Enabled = False
        mSnapTimer.Enabled = True
    End If
End Sub

Private Sub SnapToNearestItem
    If mItems.Size = 0 Then Return
    
    Dim scrollPos As Int
    Dim viewportSize As Int
    If msOrientation = "horizontal" Then
        If mHScrollView.IsInitialized = False Then Return
        scrollPos = mHScrollView.ScrollPosition
        viewportSize = mScrollHost.Width
        If viewportSize < 1 Then viewportSize = mBase.Width - mnContentPadding * 2
    Else
        If mVScrollView.IsInitialized = False Then Return
        scrollPos = mVScrollView.ScrollPosition
        viewportSize = mScrollHost.Height
        If viewportSize < 1 Then viewportSize = mBase.Height - mnContentPadding * 2
    End If
    
    Dim bestIndex As Int = 0
    Dim bestDist As Int = 999999
    
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyCarouselItem = mItems.Get(i)
        If itm.mBase.IsInitialized = False Then Continue
        Dim snapPos As Int
        Select msSnap
            Case "start"
                If msOrientation = "horizontal" Then
                    snapPos = itm.mBase.Left
                Else
                    snapPos = itm.mBase.Top
                End If
            Case "center"
                If msOrientation = "horizontal" Then
                    snapPos = itm.mBase.Left + (itm.mBase.Width / 2) - (viewportSize / 2)
                Else
                    snapPos = itm.mBase.Top + (itm.mBase.Height / 2) - (viewportSize / 2)
                End If
            Case "end"
                If msOrientation = "horizontal" Then
                    snapPos = (itm.mBase.Left + itm.mBase.Width) - viewportSize
                Else
                    snapPos = (itm.mBase.Top + itm.mBase.Height) - viewportSize
                End If
        End Select
        Dim dist As Int = Abs(scrollPos - snapPos)
        If dist < bestDist Then
            bestDist = dist
            bestIndex = i
        End If
    Next
    
    ScrollToItem(bestIndex)
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mIsResizing Then Return
    mIsResizing = True
    
    If mScrollHost.IsInitialized Then
        Dim cp As Int = mnContentPadding
        Dim hW As Int = Max(1, dWidth - cp * 2)
        Dim hH As Int = Max(1, dHeight - cp * 2)
        mScrollHost.SetLayoutAnimated(0, cp, cp, hW, hH)
        If mScrollView.IsInitialized Then
            mScrollView.SetLayoutAnimated(0, 0, 0, hW, hH)
        End If
        LayoutItems
    End If
    
    ' Rebuild overlays at new dimensions (handles dot reposition and orientation changes).
    LayoutOverlays
    
    mIsResizing = False
End Sub

Private Sub mBase_Click
    RaiseClick
End Sub

Private Sub RaiseClick
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub
#End Region

#Region Cleanup
''' <summary>
''' Returns the current rendered height of this carousel.
''' </summary>
Public Sub GetComputedHeight As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub