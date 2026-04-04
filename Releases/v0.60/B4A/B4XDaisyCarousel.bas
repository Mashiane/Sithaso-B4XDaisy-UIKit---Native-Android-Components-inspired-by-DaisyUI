B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Carousel scroll orientation.
#DesignerProperty: Key: Snap, DisplayName: Snap Position, FieldType: String, DefaultValue: start, List: start|center|end, Description: Carousel snapping behavior.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius variant.
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Apply the DaisyUI rounded-box semantic corner radius. Takes priority over the Rounded property when True.
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
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region Variables
#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Internal views
    Private mScrollView As B4XView ' HorizontalScrollView or ScrollView
    Private mHScrollView As HorizontalScrollView ' Typed ref for horizontal � needed to wire ScrollChanged event
    Private mVScrollView As ScrollView ' Typed ref for vertical � needed to wire ScrollChanged event
    Private mContentPanel As B4XView
    
    ' Local properties
    Private msOrientation As String = "horizontal"
    Private msSnap As String = "start"
    Private msRounded As String = "theme"
    Private mbRoundedBox As Boolean = False
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
    Private mCurrentIndex As Int = 0
    Private mnItemGap As Int = 0
    Private msGap As String = ""          ' Tailwind token override for item gap (e.g. space-x-4)
    Private mnContentPadding As Int = 0
    Private msPaddingToken As String = "" ' Tailwind token override for content padding (e.g. p-4)
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-[300px]"
    Private msBackgroundColor As String = ""
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
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
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Load properties
    msOrientation = B4XDaisyVariants.GetPropString(Props, "Orientation", "horizontal")
    msSnap = B4XDaisyVariants.GetPropString(Props, "Snap", "start")
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
    mbNavigationButtons = B4XDaisyVariants.GetPropBool(Props, "NavigationButtons", False)
    mbIndicatorButtons = B4XDaisyVariants.GetPropBool(Props, "IndicatorButtons", False)
    mnItemGap = B4XDaisyVariants.GetPropInt(Props, "ItemGap", 0)
    msGap = B4XDaisyVariants.GetPropString(Props, "Gap", "")
    If msGap <> "" Then mnItemGap = B4XDaisyVariants.TailwindSpacingToDip(msGap, 0)
    mnContentPadding = B4XDaisyVariants.GetPropInt(Props, "ContentPadding", 0)
    msPaddingToken = B4XDaisyVariants.GetPropString(Props, "Padding", "")
    If msPaddingToken <> "" Then mnContentPadding = B4XDaisyVariants.TailwindSpacingToDip(msPaddingToken, 0)
    msWidth = B4XDaisyVariants.GetPropString(Props, "Width", "w-full")
    msHeight = B4XDaisyVariants.GetPropString(Props, "Height", "h-[300px]")
    msBackgroundColor = B4XDaisyVariants.GetPropString(Props, "BackgroundColor", "")
    mbRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", False)
    msShadow = B4XDaisyVariants.GetPropString(Props, "Shadow", "none")
    mbAutoPlay = B4XDaisyVariants.GetPropBool(Props, "AutoPlay", False)
    mnAutoPlayInterval = B4XDaisyVariants.GetPropInt(Props, "AutoPlayInterval", 3000)
    If mnAutoPlayInterval < 500 Then mnAutoPlayInterval = 500
    
    mSnapTimer.Initialize("mSnapTimer", 200)
    mSnapTimer.Enabled = False
    
    UpdateScrollContainer
    Refresh
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("mBase")
    ' Pre-size the panel so mBase.Width/Height are correct when DesignerCreateView
    ' calls Refresh -> LayoutOverlays, preventing overlays being placed at 0,0.
    p.Width = Width
    p.Height = Height
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    ' Carry over any properties set before AddToParent so they are not overwritten
    ' by empty-prop defaults in DesignerCreateView (same fix applied to CarouselItem).
    Dim props As Map
    props.Initialize
    props.Put("Orientation", msOrientation)
    props.Put("Snap", msSnap)
    props.Put("Rounded", msRounded)
    props.Put("NavigationButtons", mbNavigationButtons)
    props.Put("IndicatorButtons", mbIndicatorButtons)
    props.Put("ItemGap", mnItemGap)
    props.Put("Gap", msGap)
    props.Put("ContentPadding", mnContentPadding)
    props.Put("Padding", msPaddingToken)
    props.Put("Width", msWidth)
    props.Put("Height", msHeight)
    props.Put("BackgroundColor", msBackgroundColor)
    props.Put("RoundedBox", mbRoundedBox)
    props.Put("Shadow", msShadow)
    props.Put("AutoPlay", mbAutoPlay)
    props.Put("AutoPlayInterval", mnAutoPlayInterval)
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Base_Resize(Width, Height)
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
    If mbRoundedBox Then
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
    
    ' Apply rounded corners + background color to mBase (no clip � keeps overlays visible).
    mBase.SetColorAndBorder(bgColor, 0, 0, radius)
    ' Apply shadow elevation (DaisyUI shadow utility).
    B4XDaisyVariants.ApplyElevation(mBase, msShadow)
    
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

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    
    ' Resolve actual dimensions from Tailwind width/height tokens.
    ' The passed Width/Height serve as the "full" reference (e.g. w-full -> passed Width).
    ' Fall back to parent dimensions when the caller passes 0.
    Dim refW As Int = Width
    If refW <= 0 Then refW = Parent.Width
    Dim refH As Int = Height
    If refH <= 0 Then refH = Parent.Height
    Dim actualW As Int = B4XDaisyVariants.TailwindSizeToDip(msWidth, refW)
    Dim actualH As Int
    If msHeight = "h-auto" Or msHeight = "auto" Then
        ' Height will be resolved after items are measured in Refresh/LayoutItems.
        actualH = 1dip
    Else
        actualH = B4XDaisyVariants.TailwindSizeToDip(msHeight, refH)
    End If
    If actualW < 1 Then actualW = Max(1, refW)
    If actualH < 1 Then actualH = Max(1, refH)
    
    If mBase.IsInitialized = False Then
        CreateView(actualW, actualH)
    End If
    Parent.AddView(mBase, Left, Top, actualW, actualH)
    Return mBase
End Sub

Private Sub UpdateScrollContainer
    If mBase.IsInitialized = False Then Return
    
    ' Remove old scroll host (its children � mScrollView � are removed with it)
    If mScrollHost.IsInitialized Then mScrollHost.RemoveViewFromParent
    
    ' mScrollHost is the clipped inner area; overlay views live on mBase above it
    Dim pHost As Panel
    pHost.Initialize("")
    mScrollHost = pHost
    mScrollHost.Color = xui.Color_Transparent
    Dim cp As Int = mnContentPadding
    mBase.AddView(mScrollHost, cp, cp, Max(1, mBase.Width - cp * 2), Max(1, mBase.Height - cp * 2))
    
    If msOrientation = "horizontal" Then
        mHScrollView.Initialize(0, "")
        mScrollView = mHScrollView
        mScrollPollTimer.Enabled = True
        ' Hide scrollbar (DaisyUI: scrollbar-width: none / ::-webkit-scrollbar { display: none })
        Dim joH As JavaObject = mScrollView
        joH.RunMethod("setHorizontalScrollBarEnabled", Array(False))
    Else
        mVScrollView.Initialize(0)
        mScrollView = mVScrollView
        ' Hide scrollbar (DaisyUI: scrollbar-width: none / ::-webkit-scrollbar { display: none })
        Dim jo As JavaObject = mVScrollView
        jo.RunMethod("setVerticalScrollBarEnabled", Array(False))
        mScrollPollTimer.Enabled = False
    End If
    
    mScrollHost.AddView(mScrollView, 0, 0, mScrollHost.Width, mScrollHost.Height)
    
    ' Get Inner Panel (Content Panel)
    If msOrientation = "horizontal" Then
        mContentPanel = mHScrollView.Panel
    Else
        mContentPanel = mVScrollView.Panel
    End If
    
    mContentPanel.Color = xui.Color_Transparent
    
    ' Re-parent any existing items into the new content panel, preserving their sizes
    For Each itm As B4XDaisyCarouselItem In mItems
        Dim savedW As Int = itm.mBase.Width
        Dim savedH As Int = itm.mBase.Height
        If savedW < 1 Then savedW = 100dip
        If savedH < 1 Then savedH = 100dip
        If itm.mBase.Parent <> Null Then itm.mBase.RemoveViewFromParent
        mContentPanel.AddView(itm.mBase, 0, 0, savedW, savedH)
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

Public Sub ClearItems
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
        mContentPanel.Height = scrollHostH
    Else
        mContentPanel.Width = scrollHostW
        mContentPanel.Height = Max(currentPos, scrollHostH)
    End If
End Sub

Public Sub ScrollToItem(Index As Int)
    If Index < 0 Or Index >= mItems.Size Then Return
    Dim itm As B4XDaisyCarouselItem = mItems.Get(Index)
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
    
    mCurrentIndex = Index
    UpdateDots
End Sub

Public Sub getOrientation As String
    Return msOrientation
End Sub

Public Sub setOrientation(Value As String)
    msOrientation = Value
    UpdateScrollContainer
    Refresh
End Sub

Public Sub getSnap As String
    Return msSnap
End Sub

Public Sub setSnap(Value As String)
    msSnap = Value
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setRounded(Value As String)
    msRounded = Value
    Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getItemGap As Int
    Return mnItemGap
End Sub

Public Sub setItemGap(Value As Int)
    mnItemGap = Value
    msGap = ""  ' raw dip wins; clear token override
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getGap As String
    Return msGap
End Sub

Public Sub setGap(Value As String)
    msGap = Value
    If Value <> "" Then mnItemGap = B4XDaisyVariants.TailwindSpacingToDip(Value, 0)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getContentPadding As Int
    Return mnContentPadding
End Sub

Public Sub setContentPadding(Value As Int)
    mnContentPadding = Value
    msPaddingToken = ""  ' raw dip wins; clear token override
    If mBase.IsInitialized Then
        UpdateScrollContainer
        Refresh
    End If
End Sub

Public Sub getPadding As String
    Return msPaddingToken
End Sub

Public Sub setPadding(Value As String)
    msPaddingToken = Value
    If Value <> "" Then mnContentPadding = B4XDaisyVariants.TailwindSpacingToDip(Value, 0)
    If mBase.IsInitialized Then
        UpdateScrollContainer
        Refresh
    End If
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setWidth(Value As String)
    msWidth = Value
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setHeight(Value As String)
    msHeight = Value
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setBackgroundColor(Value As String)
    msBackgroundColor = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getNavigationButtons As Boolean
    Return mbNavigationButtons
End Sub

Public Sub setNavigationButtons(Value As Boolean)
    mbNavigationButtons = Value
    If mBase.IsInitialized Then LayoutOverlays
End Sub

Public Sub getIndicatorButtons As Boolean
    Return mbIndicatorButtons
End Sub

Public Sub setIndicatorButtons(Value As Boolean)
    mbIndicatorButtons = Value
    If mBase.IsInitialized Then LayoutOverlays
End Sub

Public Sub getAutoPlay As Boolean
    Return mbAutoPlay
End Sub

Public Sub setAutoPlay(Value As Boolean)
    mbAutoPlay = Value
    If Value Then
        StartAutoPlay
    Else
        StopAutoPlay
    End If
End Sub

Public Sub getAutoPlayInterval As Int
    Return mnAutoPlayInterval
End Sub

Public Sub setAutoPlayInterval(Value As Int)
    mnAutoPlayInterval = Max(500, Value)
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

Public Sub getCurrentIndex As Int
    Return mCurrentIndex
End Sub

Public Sub getVisible As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Visible
End Sub

Public Sub setVisible(Value As Boolean)
    If mBase.IsInitialized Then mBase.Visible = Value
End Sub

Public Sub getEnabled As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Enabled
End Sub

Public Sub setEnabled(Value As Boolean)
    If mBase.IsInitialized Then mBase.Enabled = Value
End Sub

Public Sub getRoundedBox As Boolean
    Return mbRoundedBox
End Sub

Public Sub setRoundedBox(Value As Boolean)
    mbRoundedBox = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized Then Refresh
End Sub

' Build (or rebuild) the nav buttons and indicator dots overlaid on mBase.
' Called from Refresh and whenever NavigationButtons/IndicatorButtons props change.
Private Sub LayoutOverlays
    If mBase.IsInitialized = False Then Return
    
    Dim NAV_SIZE As Int = 38dip
    Dim NAV_MARGIN As Int = 8dip
    Dim INDICATOR_STRIP As Int = 32dip   ' height (horizontal) or width (vertical) of dot strip
    Dim DOT_SIZE As Int = 10dip
    Dim DOT_GAP As Int = 6dip
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
        mPnlIndicators.Color = xui.Color_ARGB(80, 0, 0, 0)
        
        If isVertical Then
            ' Vertical: dot column on the right edge, vertically centered
            mBase.AddView(mPnlIndicators, mBase.Width - INDICATOR_STRIP, 0, INDICATOR_STRIP, mBase.Height)
            
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
            ' Horizontal: dot row along the bottom edge, horizontally centered
            mBase.AddView(mPnlIndicators, 0, mBase.Height - INDICATOR_STRIP, mBase.Width, INDICATOR_STRIP)
            
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
End Sub

' Refresh which dot is highlighted to match mCurrentIndex.
Private Sub UpdateDots
    If mDotViews.Size = 0 Then Return
    Dim DOT_SIZE As Int = 10dip
    For i = 0 To mDotViews.Size - 1
        Dim dv As B4XView = mDotViews.Get(i)
        If i = mCurrentIndex Then
            dv.SetColorAndBorder(xui.Color_White, 0, 0, DOT_SIZE / 2)
        Else
            dv.SetColorAndBorder(xui.Color_ARGB(120, 255, 255, 255), 0, 0, DOT_SIZE / 2)
        End If
    Next
End Sub

Private Sub mBtnPrev_Click
    ScrollToItem(Max(0, mCurrentIndex - 1))
End Sub

Private Sub mBtnNext_Click
    ScrollToItem(Min(mItems.Size - 1, mCurrentIndex + 1))
End Sub

Private Sub mDotBtn_Click
    Dim clickedDot As Panel = Sender
    If clickedDot.Tag <> Null Then
        ScrollToItem(clickedDot.Tag)
    End If
End Sub

Private Sub mScrollView_ScrollChanged(Position As Int)
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

' Vertical ScrollView typed-variable event � delegates to shared snap logic.
Private Sub mVScrollView_ScrollChanged(Position As Int)
    mScrollView_ScrollChanged(Position)
End Sub

' Horizontal ScrollView typed-variable event � delegates to shared snap logic.
Private Sub mHScrollView_ScrollChanged(Position As Int)
    mScrollView_ScrollChanged(Position)
End Sub

' Disallow parent (page ScrollView) from intercepting touch events when the
' carousel is vertical � prevents the page from stealing vertical scroll gestures.
Private Sub mBase_Touch(Action As Int, X As Float, Y As Float) As Boolean
    If msOrientation = "vertical" Then
        Dim joBase As JavaObject = mBase
        Dim par As JavaObject = joBase.RunMethod("getParent", Null)
        ' ACTION_DOWN=0, ACTION_MOVE=2: lock parent; ACTION_UP=1, ACTION_CANCEL=3: release
        Dim disallow As Boolean = (Action = 0 Or Action = 2)
        par.RunMethod("requestDisallowInterceptTouchEvent", Array(disallow))
    End If
    Return False ' never consume � let mVScrollView handle the scroll
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

' Polls HorizontalScrollView.ScrollPosition every 80ms to detect user scroll
' (compensates for mHScrollView using empty event name to avoid setEventName crash).
Private Sub mScrollPollTimer_Tick
    If mHScrollView.IsInitialized = False Then Return
    If msOrientation <> "horizontal" Then Return
    If mIsProgrammaticScroll Then Return
    Dim pos As Int = mHScrollView.ScrollPosition
    If pos <> mLastScrollPos Then
        mLastScrollPos = pos
        ' User-initiated horizontal scroll: pause auto-play briefly.
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
        Dim hsv As HorizontalScrollView = mScrollView
        scrollPos = hsv.ScrollPosition
        viewportSize = mScrollHost.Width
        If viewportSize < 1 Then viewportSize = mBase.Width - mnContentPadding * 2
    Else
        scrollPos = mVScrollView.ScrollPosition
        viewportSize = mScrollHost.Height
        If viewportSize < 1 Then viewportSize = mBase.Height - mnContentPadding * 2
    End If
    
    Dim bestIndex As Int = 0
    Dim bestDist As Int = 999999
    
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyCarouselItem = mItems.Get(i)
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
Public Sub Base_Resize(Width As Double, Height As Double)
    If mIsResizing Then Return
    mIsResizing = True
    
    If mScrollHost.IsInitialized Then
        Dim cp As Int = mnContentPadding
        Dim hW As Int = Max(1, Width - cp * 2)
        Dim hH As Int = Max(1, Height - cp * 2)
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
