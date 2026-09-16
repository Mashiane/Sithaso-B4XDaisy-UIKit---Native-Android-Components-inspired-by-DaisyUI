B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: WillPresent
#Event: DidPresent
#Event: WillDismiss
#Event: DidDismiss (Role As String, Data As Object)
#Event: DragStart
#Event: DragMove (Data As Map)
#Event: DragEnd (Data As Map)
#Event: BreakpointDidChange (Breakpoint As Float)
#End Region

#Region Designer Properties
#DesignerProperty: Key: IsOpen, DisplayName: Is Open, FieldType: Boolean, DefaultValue: False, Description: Controls the presentation state of the modal.
#DesignerProperty: Key: CanDismiss, DisplayName: Can Dismiss, FieldType: Boolean, DefaultValue: True, Description: Whether the modal can be dismissed by the user (replaces swipeToClose).
#DesignerProperty: Key: BackdropDismiss, DisplayName: Backdrop Dismiss, FieldType: Boolean, DefaultValue: True, Description: If true, clicking the backdrop will dismiss the modal.
#DesignerProperty: Key: Animated, DisplayName: Animated, FieldType: Boolean, DefaultValue: True, Description: If true, the modal will animate in and out.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, MinRange: 0, MaxRange: 3000, Description: Duration (ms) of the open/close slide animation. 0 = instant.
#DesignerProperty: Key: ScaleBackground, DisplayName: Scale Background, FieldType: Boolean, DefaultValue: False, Description: If true and PresentingView is set, the presenting view scales back (iOS card-modal effect) behind the sheet.
#DesignerProperty: Key: BackgroundScale, DisplayName: Background Scale, FieldType: Float, DefaultValue: 0.94, Description: Target scale of the presenting view when fully receded (1.0 = none, 0.94 = 94%).
#DesignerProperty: Key: BackgroundCornerRadius, DisplayName: Background Corner Radius, FieldType: Int, DefaultValue: 18, MinRange: 0, MaxRange: 64, Description: Top corner radius (dip) applied to the presenting view.
#DesignerProperty: Key: BackgroundTranslateY, DisplayName: Background Translate Y, FieldType: Int, DefaultValue: 12, MinRange: 0, MaxRange: 200, Description: Downward shift (dip) of the presenting view when fully receded.
#DesignerProperty: Key: BackgroundDim, DisplayName: Background Dim, FieldType: Float, DefaultValue: 0.08, Description: Dim amount (0 = none, 1 = full) applied to the presenting view.
#DesignerProperty: Key: BackgroundShadow, DisplayName: Background Shadow, FieldType: Boolean, DefaultValue: False, Description: If true, casts an elevation shadow around the receded presenting view.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Modal background color.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: box, List: none|sm|md|lg|xl|2xl|3xl|full|box, Description: Border radius of the modal.
#DesignerProperty: Key: Breakpoints, DisplayName: Breakpoints, FieldType: String, DefaultValue: 0,0.5,1.0, Description: Comma-separated list of snapping ratios from 0.0 to 1.0.
#DesignerProperty: Key: InitialBreakpoint, DisplayName: Initial Breakpoint, FieldType: Float, DefaultValue: 0.5, Description: Ratio of page height shown when presented. Must exist in Breakpoints.
#DesignerProperty: Key: BackdropBreakpoint, DisplayName: Backdrop Breakpoint, FieldType: Float, DefaultValue: 0.0, Description: Ratio of height above which backdrop is active.
#DesignerProperty: Key: Handle, DisplayName: Show Handle, FieldType: Boolean, DefaultValue: True, Description: Shows a drag handle at the top of the sheet.
#DesignerProperty: Key: HandleBehavior, DisplayName: Handle Behavior, FieldType: String, DefaultValue: none, List: none|cycle, Description: Behavior on clicking the handle.
#DesignerProperty: Key: BackdropOpacity, DisplayName: Backdrop Opacity, FieldType: Int, DefaultValue: 40, MinRange: 0, MaxRange: 100, Description: Backdrop opacity percentage.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Content box border color.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Content box border width.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind width token or size.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-[400px], Description: Tailwind height token or size.
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: True, Description: Automatically grow height to fit content children.
#DesignerProperty: Key: ExpandToScroll, DisplayName: Expand To Scroll, FieldType: Boolean, DefaultValue: True, Description: If true, content may scroll inside the sheet and gestures switch between scrolling and dragging.
#DesignerProperty: Key: ScrollBehavior, DisplayName: Scroll Behavior, FieldType: String, DefaultValue: auto, List: auto|drag|scroll, Description: auto = scroll when scrollable else drag sheet; drag = always drag sheet; scroll = always scroll content. Only used when ExpandToScroll is true.
#DesignerProperty: Key: NestedScrollEnabled, DisplayName: Nested Scroll Enabled, FieldType: Boolean, DefaultValue: True, Description: When scrolling reaches the top, continued pull-down hands off to sheet dragging (Ionic-style nested scroll).
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	' UI Layers
	Private mBackdrop As B4XView
	Private mContentBox As B4XView
	Private mDragBar As B4XView
	Private mHandlePill As B4XView
	Private mScrollPanel As B4XView
	Private mContentWrapper As B4XView
	Private mBaseW As Int = 0
	Private mBaseH As Int = 0

	' Component Properties
	Private mbIsOpen As Boolean = False
	Private mbCanDismiss As Boolean = True
	Private mbBackdropDismiss As Boolean = True
	Private mbAnimated As Boolean = True
	Private miAnimationTime As Int = 300
	Private mcBackgroundColor As Int = xui.Color_White
	Private msRounded As String = "box"
	Private mBreakpoints As List
	Private mInitialBreakpoint As Float = 0.5
	Private mBackdropBreakpoint As Float = 0.0
	Private mbHandle As Boolean = True
	Private msHandleBehavior As String = "none"
	Private mCurrentBreakpoint As Float = 0.0
	Private msBreakpointsString As String = "0,0.5,1.0"
	Private miBackdropOpacity As Int = 40
	Private mcBorderColor As Int = xui.Color_Transparent
	Private miBorderWidth As Int = 0
	Private msWidth As String = "w-full"
	Private msHeight As String = "h-[400px]"
	Private mAutoHeight As Boolean = True
	Private mExpandToScroll As Boolean = True
	Private msScrollBehavior As String = "auto"
	Private mbNestedScrollEnabled As Boolean = True
	' iOS card-modal scale-background (PresentingView) transform
	Private mPresentingView As B4XView
	Private mbScaleBackground As Boolean = False
	Private mBackgroundScale As Float = 0.94
	Private mBackgroundCornerRadius As Int = 18dip
	Private mBackgroundTranslateY As Int = 12dip
	Private mBackgroundDim As Float = 0.08
	Private mbBackgroundShadow As Boolean = False
	Private CARD_SHADOW_ELEV As Int = 24dip
	Private mPresentingCornerRadiusJO As JavaObject
	Private mSavedPresentingBg As Object = Null
	Private mSavedParentColor As Int

	' Measured layout (computed in Measure, used everywhere)
	Private mBoxW As Int = 0
	Private mBoxH As Int = 0
	Private mContentHeight As Int = 0
	Private mViewportHeight As Int = 0
	Private mMaxScrollTop As Int = 0
	Private mCanScroll As Boolean = False

	' Animation engine (Timer-driven, requestAnimationFrame style)
	Private Anim As B4XDaisyAnimation
	Private mAnimTimer As Timer
	Private mAnimActive As Boolean = False
	Private mAnimStartMs As Long
	Private mAnimDuration As Int = 1
	Private mAnimEase As String = "easeOutCubic"
	Private mAnimCompleteSub As String = ""
	Private mAnimSheet As Boolean = False
	Private mAnimSheetStart As Float
	Private mAnimSheetChange As Float
	Private mAnimScroll As Boolean = False
	Private mAnimScrollStart As Float
	Private mAnimScrollChange As Float
	Private mAnimBackdrop As Boolean = False
	Private mAnimBackdropStart As Float
	Private mAnimBackdropChange As Float
	Private mAnimPresenting As Boolean = False
	Private mAnimPresentingStart As Float = 0
	Private mAnimPresentingChange As Float = 0
	Private mAnimPrevBp As Float = 0.0
	Private mAnimDismissRole As String = ""
	Private mAnimDismissData As Object = Null

	' Interaction state
	Private mIsAnimating As Boolean = False
	Private mIsDragging As Boolean = False
	Private mDragMode As Int = 0       ' 0 = undecided, 1 = scroll content, 2 = drag sheet
	Private mHandedOff As Boolean = False
	Private mStartScreenY As Float
	Private mStartSheetTop As Float
	Private mStartScrollTop As Float

	' Velocity / physics
	Private mLastMoveTime As Long
	Private mLastMoveY As Float
	Private mVelocityY As Float = 0
	Private mResistance As Float = 0.35
	Private mTapThreshold As Int = 8dip
	Private mVelThreshold As Float = 0.1
	Private mPredictMs As Int = 220
	Private mFlingMs As Int = 300
	Private miContentPadding As Int = 16dip
	Private mMinSheetHeight As Int = 80dip

	' Fixed (non-scrolling) box views added via AddBoxView.
	' The scroll panel starts beneath the tallest of these so that
	' headers (e.g. a navbar) stay pinned while body content scrolls.
	Private mBoxViews As List
	Private mFixedTopOffset As Int = 0
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
	Anim.Initialize
	mAnimTimer.Initialize("mAnimTimer", 16)
	mAnimTimer.Enabled = False
	mBoxViews.Initialize
End Sub

''' <summary>
''' Programmatic creation entry point.
''' </summary>
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	DesignerCreateView(b, Null, props)
	Return mBase
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Private Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBaseW = mBase.Width
	mBaseH = mBase.Height
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' 1. Backdrop
	Dim pBackdrop As Panel
	pBackdrop.Initialize("mBackdrop")
	mBackdrop = pBackdrop
	mBackdrop.Color = xui.Color_ARGB(120, 0, 0, 0)
	mBase.AddView(mBackdrop, 0, 0, mBaseW, mBaseH)

	' 2. Modal Box Content Host
	Dim pBox As Panel
	pBox.Initialize("mContentBox")
	mContentBox = pBox
	mContentBox.Color = mcBackgroundColor
	mBase.AddView(mContentBox, 0, 0, mBaseW, mBaseH)

	' 3. Scroll Panel (holds user content, translated to scroll). Sits behind the drag bar.
	Dim pScroll As Panel
	pScroll.Initialize("")
	mScrollPanel = pScroll
	mScrollPanel.Color = xui.Color_Transparent
	mContentBox.AddView(mScrollPanel, 0, 0, mContentBox.Width, mContentBox.Height)

	' 3b. Inner content wrapper: holds user content and is translated to scroll.
	' mScrollPanel is the fixed viewport (positioned beneath fixed box views);
	' mContentWrapper moves inside it so scrolling never disturbs pinned headers.
	Dim pWrap As Panel
	pWrap.Initialize("")
	mContentWrapper = pWrap
	mContentWrapper.Color = xui.Color_Transparent
	mScrollPanel.AddView(mContentWrapper, 0, 0, mScrollPanel.Width, mScrollPanel.Height)

	' 4. Drag Bar (floats on top of the scroll panel)
	Dim pDrag As Panel
	pDrag.Initialize("mDragBar")
	mDragBar = pDrag
	mDragBar.Color = xui.Color_Transparent
	mContentBox.AddView(mDragBar, 0, 0, mContentBox.Width, 30dip)

	' 5. Handle Pill
	Dim pPill As Panel
	pPill.Initialize("")
	mHandlePill = pPill
	mHandlePill.Color = xui.Color_RGB(200, 200, 200)
	mDragBar.AddView(mHandlePill, (mDragBar.Width - 36dip) / 2, 13dip, 36dip, 4dip)

	ApplyDesignerProps(mProps)
	mBase.Visible = mbIsOpen
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then
		ParseBreakpoints(msBreakpointsString)
		Return
	End If
	mbIsOpen = B4XDaisyVariants.GetPropBool(mProps, "IsOpen", mbIsOpen)
	mbCanDismiss = B4XDaisyVariants.GetPropBool(mProps, "CanDismiss", True)
	mbBackdropDismiss = B4XDaisyVariants.GetPropBool(mProps, "BackdropDismiss", True)
	mbAnimated = B4XDaisyVariants.GetPropBool(mProps, "Animated", True)
	miAnimationTime = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationTime", 300))
	mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
	msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded)

	msBreakpointsString = B4XDaisyVariants.GetPropString(mProps, "Breakpoints", "0,0.5,1.0")
	mInitialBreakpoint = B4XDaisyVariants.GetPropFloat(mProps, "InitialBreakpoint", 0.5)
	mBackdropBreakpoint = B4XDaisyVariants.GetPropFloat(mProps, "BackdropBreakpoint", 0.0)
	mbHandle = B4XDaisyVariants.GetPropBool(mProps, "Handle", True)
	msHandleBehavior = B4XDaisyVariants.GetPropString(mProps, "HandleBehavior", "none")

	miBackdropOpacity = B4XDaisyVariants.GetPropInt(mProps, "BackdropOpacity", 40)
	mcBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", xui.Color_Transparent)
	miBorderWidth = B4XDaisyVariants.GetPropInt(mProps, "BorderWidth", 0)
	msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", "w-full")
	msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", "h-[400px]")
	mAutoHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoHeight", True)
	mExpandToScroll = B4XDaisyVariants.GetPropBool(mProps, "ExpandToScroll", True)
	msScrollBehavior = B4XDaisyVariants.GetPropString(mProps, "ScrollBehavior", "auto")
	mbNestedScrollEnabled = B4XDaisyVariants.GetPropBool(mProps, "NestedScrollEnabled", True)
	mbScaleBackground = B4XDaisyVariants.GetPropBool(mProps, "ScaleBackground", False)
	mBackgroundScale = B4XDaisyVariants.GetPropFloat(mProps, "BackgroundScale", 0.94)
	mBackgroundCornerRadius = B4XDaisyVariants.GetPropInt(mProps, "BackgroundCornerRadius", 18) * 1dip
	mBackgroundTranslateY = B4XDaisyVariants.GetPropInt(mProps, "BackgroundTranslateY", 12) * 1dip
	mBackgroundDim = B4XDaisyVariants.GetPropFloat(mProps, "BackgroundDim", 0.08)
	mbBackgroundShadow = B4XDaisyVariants.GetPropBool(mProps, "BackgroundShadow", False)

	ParseBreakpoints(msBreakpointsString)
	ValidateInitialBreakpoint
	mCurrentBreakpoint = mInitialBreakpoint
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("IsOpen", mbIsOpen)
	props.Put("CanDismiss", mbCanDismiss)
	props.Put("BackdropDismiss", mbBackdropDismiss)
	props.Put("Animated", mbAnimated)
	props.Put("Duration", miAnimationTime)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("Rounded", msRounded)
	props.Put("Breakpoints", msBreakpointsString)
	props.Put("InitialBreakpoint", mInitialBreakpoint)
	props.Put("BackdropBreakpoint", mBackdropBreakpoint)
	props.Put("Handle", mbHandle)
	props.Put("HandleBehavior", msHandleBehavior)
	props.Put("BackdropOpacity", miBackdropOpacity)
	props.Put("BorderColor", mcBorderColor)
	props.Put("BorderWidth", miBorderWidth)
	props.Put("AutoHeight", mAutoHeight)
	props.Put("ExpandToScroll", mExpandToScroll)
	props.Put("ScrollBehavior", msScrollBehavior)
	props.Put("NestedScrollEnabled", mbNestedScrollEnabled)
	props.Put("ScaleBackground", mbScaleBackground)
	props.Put("BackgroundScale", mBackgroundScale)
	props.Put("BackgroundCornerRadius", mBackgroundCornerRadius / 1dip)
	props.Put("BackgroundTranslateY", mBackgroundTranslateY / 1dip)
	props.Put("BackgroundDim", mBackgroundDim)
	props.Put("BackgroundShadow", mbBackgroundShadow)
	Return props
End Sub

Private Sub ParseBreakpoints(sValue As String)
	mBreakpoints.Initialize
	If sValue = Null Or sValue.Trim.Length = 0 Then
		mBreakpoints.Add(0.0)
		mBreakpoints.Add(1.0)
		Return
	End If
	Dim parts() As String = Regex.Split(",", sValue)
	For Each part As String In parts
		Try
			Dim val As Float = part.Trim
			If val >= 0 And val <= 1 Then
				mBreakpoints.Add(val)
			End If
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ParseBreakpoints: " & LastException.Message)
			' Ignore invalid inputs
		End Try
	Next
	mBreakpoints.Sort(True)
	If mBreakpoints.IndexOf(0.0) = -1 Then
		mBreakpoints.InsertAt(0, 0.0)
	End If
End Sub

''' <summary>
''' Ensures InitialBreakpoint exists in the parsed Breakpoints.
''' If not, logs a warning and snaps to the nearest non-zero breakpoint
''' instead of silently accepting an invalid value that snaps later.
''' </summary>
Private Sub ValidateInitialBreakpoint
	If mBreakpoints.IsInitialized = False Or mBreakpoints.Size = 0 Then Return
	If BreakpointExists(mInitialBreakpoint) Then Return
	Dim nearest As Float = FindClosestBreakpoint(mInitialBreakpoint)
	If nearest = 0.0 Then nearest = LowestNonZeroBreakpoint
	If B4XDaisyApp.DebugLogs Then Log($"B4XDaisySheetModal: InitialBreakpoint ${mInitialBreakpoint} is not in Breakpoints [${msBreakpointsString}]; snapping to ${nearest}"$)
	mInitialBreakpoint = nearest
End Sub

Private Sub BreakpointExists(fBp As Float) As Boolean
	For Each fBp As Float In mBreakpoints
		If Abs(fBp - fBp) < 0.001 Then Return True
	Next
	Return False
End Sub

Private Sub LowestNonZeroBreakpoint As Float
	Dim low As Float = 1.0
	For Each bp As Float In mBreakpoints
		If bp > 0 Then low = Min(low, bp)
	Next
	Return low
End Sub
#End Region

#Region Public API
''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	If mBase.IsInitialized = False Then
		CreateView(iWidth, iHeight)
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Base_Resize(iWidth, iHeight)
	Return mBase
End Sub

''' <summary>
''' Attaches a user's B4XView into the modal's scrollable content slot.
''' </summary>
Public Sub AddContentView(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	mContentWrapper.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
End Sub

''' <summary>
''' Attaches a user's B4XView directly to the modal's content box (non-scrolling).
''' Use this for fixed headers/footers (e.g. a navbar) that must stay pinned while
''' the scrollable content added via AddContentView flows beneath them. The scroll
''' panel automatically starts below the bottom edge of all box views added here.
''' </summary>
Public Sub AddBoxView(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If vChildView.IsInitialized = False Then Return
	' Re-parent safely: detach from any previous host before attaching to the content box
	If vChildView.Parent.IsInitialized Then vChildView.RemoveViewFromParent
	mContentBox.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
	If mBoxViews.IndexOf(vChildView) = -1 Then mBoxViews.Add(vChildView)
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
	' Keep fixed box views above the internal drag bar so their child buttons receive touches
	vChildView.BringToFront
End Sub

''' <summary>
''' Retrieves the scrollable content host (children added here scroll inside the sheet).
''' </summary>
Public Sub getContentView As B4XView
	Return mContentWrapper
End Sub

''' <summary>
''' Retrieves the scrollable content panel directly.
''' </summary>
Public Sub getScrollPanel As B4XView
	Return mContentWrapper
End Sub

''' <summary>
''' Retrieves the internal scroll view (content host). Alias of getScrollPanel.
''' </summary>
Public Sub getScrollView As B4XView
	Return mContentWrapper
End Sub

''' <summary>
''' Retrieves the content box (sheet body) for advanced use.
''' </summary>
Public Sub getContentBox As B4XView
	Return mContentBox
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Returns the current scroll offset in dip (0 = top).
''' </summary>
Public Sub getScrollOffset As Int
	If mScrollPanel.IsInitialized = False Then Return 0
	Return Max(0, -mContentWrapper.Top)
End Sub

''' <summary>
''' Scrolls the content to the given offset in dip (animated if Animated is true).
''' </summary>
Public Sub setScrollOffset(iValue As Int)
	If mScrollPanel.IsInitialized = False Or mCanScroll = False Then Return
	Dim target As Int = Max(mMaxScrollTop, -iValue)
	target = Min(0, target)
	AnimateScrollTo(target, "easeOutCubic", 250)
End Sub

''' <summary>
''' Scrolls the content back to the top.
''' </summary>
Public Sub ScrollToTop
	If mScrollPanel.IsInitialized = False Then Return
	AnimateScrollTo(0, "easeOutCubic", 250)
End Sub
#End Region

#Region Rendering & Layout
''' <summary>
''' Resize entry point. Split into Measure / Layout / Refresh.
''' </summary>
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	mBaseW = dWidth
	mBaseH = dHeight
	mBackdrop.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
	Measure
	Layout
	Refresh
	inResize = False
End Sub

''' <summary>
''' Computes all sizes: sheet width/height, content height, scroll viewport and range.
''' Centralized so Present / Drag / Snap share one source of truth.
''' </summary>
Private Sub Measure
	If mBase.IsInitialized = False Then Return
	mFixedTopOffset = ComputeFixedTopOffset
	mContentHeight = MeasureContentHeight
	mBoxH = ComputeSheetHeight(mContentHeight)
	mBoxW = ComputeSheetWidth
	mViewportHeight = Max(0, mBoxH - mFixedTopOffset)
	mMaxScrollTop = Min(0, mViewportHeight - mContentHeight)
	mCanScroll = mContentHeight > mViewportHeight
End Sub

''' <summary>
''' Computes the vertical space reserved by fixed box views (added via AddBoxView).
''' The scroll panel starts immediately beneath the tallest pinned header.
''' </summary>
Private Sub ComputeFixedTopOffset As Int
	If mBoxViews.IsInitialized = False Then Return 0
	Dim h As Int = 0
	For Each v As B4XView In mBoxViews
		If v.IsInitialized And v.Visible Then
			h = Max(h, v.Top + v.Height)
		End If
	Next
	Return h
End Sub

''' <summary>
''' Positions views based on the current breakpoint. Does NOT animate.
''' </summary>
Private Sub Layout
	If mBase.IsInitialized = False Then Return
	Dim screenH As Int = mBaseH
	Dim boxLeft As Int = (mBaseW - mBoxW) / 2
	Dim targetTop As Int = screenH - (mBoxH * mCurrentBreakpoint)
	mContentBox.SetLayoutAnimated(0, boxLeft, targetTop, mBoxW, mBoxH)

	Dim scrollH As Int = mContentHeight
	Dim viewH As Int = Max(0, mBoxH - mFixedTopOffset)
	If scrollH < viewH Then scrollH = viewH
	' mScrollPanel is the FIXED viewport, pinned beneath any fixed box views.
	mScrollPanel.SetLayoutAnimated(0, 0, mFixedTopOffset, mBoxW, viewH)
	' mContentWrapper holds the user content and is translated to scroll.
	mContentWrapper.SetLayoutAnimated(0, 0, 0, mBoxW, scrollH)
	' Clamp existing scroll position into range (0 = rest, mMaxScrollTop = fully scrolled)
	If mContentWrapper.Top < mMaxScrollTop Then mContentWrapper.Top = mMaxScrollTop
	If mContentWrapper.Top > 0 Then mContentWrapper.Top = 0

	If mDragBar.IsInitialized Then
		mDragBar.SetLayoutAnimated(0, 0, 0, mBoxW, 30dip)
		If mHandlePill.IsInitialized Then
			mHandlePill.SetLayoutAnimated(0, (mBoxW - 36dip) / 2, 13dip, 36dip, 4dip)
		End If
	End If
End Sub

''' <summary>
''' Applies visual properties (colors, borders, elevation, handle, z-order).
''' </summary>
Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 16dip)
	mContentBox.SetColorAndBorder(mcBackgroundColor, miBorderWidth, mcBorderColor, radius)
	B4XDaisyVariants.ApplyElevation(mContentBox, "2xl")

	If mScrollPanel.IsInitialized Then
		mScrollPanel.Color = xui.Color_Transparent
		mScrollPanel.SendToBack
	End If
	If mContentWrapper.IsInitialized Then
		mContentWrapper.Color = xui.Color_Transparent
	End If
	If mHandlePill.IsInitialized Then
		mHandlePill.Visible = mbHandle
		If mbHandle Then
			mHandlePill.SetColorAndBorder(xui.Color_RGB(200, 200, 200), 0, 0, 2dip)
			mHandlePill.BringToFront
		End If
	End If
	If mDragBar.IsInitialized Then
		mDragBar.BringToFront
	End If
	' Fixed box views (headers/footers) render above the drag bar so their
	' child controls (buttons, inputs) stay tappable.
	If mBoxViews.IsInitialized Then
		For Each v As B4XView In mBoxViews
			If v.IsInitialized Then v.BringToFront
		Next
	End If
End Sub

Private Sub ComputeSheetWidth As Int
	Dim w As Int = mBaseW
	If msWidth.Trim.Length > 0 And msWidth <> "w-full" Then
		w = B4XDaisyVariants.ResolveSizeSpec(msWidth, mBaseW, w)
	Else
		If mBaseW > 600dip Then w = 600dip
	End If
	Return w
End Sub

''' <summary>
''' Single source of truth for the fully-open sheet height.
''' </summary>
Private Sub ComputeSheetHeight(iContentHeight As Int) As Int
	Dim screenH As Int = mBaseH
	Dim maxRatio As Float = GetMaxRatio
	If mAutoHeight And iContentHeight > 0 Then
		Dim h As Int = iContentHeight + mFixedTopOffset + miContentPadding
		Return Min(screenH, Max(mMinSheetHeight, h))
	End If
	Dim boxH As Int = screenH * maxRatio
	If msHeight.Trim.Length > 0 And msHeight <> "h-full" Then
		boxH = B4XDaisyVariants.ResolveSizeSpec(msHeight, screenH, boxH)
	End If
	Return Min(screenH, Max(mMinSheetHeight, boxH))
End Sub

''' <summary>
''' Measures the total content height from direct children of the scroll panel.
''' </summary>
Private Sub MeasureContentHeight As Int
	If mContentWrapper.IsInitialized = False Then Return 0
	Dim h As Int = 0
	For Each v As B4XView In mContentWrapper.GetAllViewsRecursive
		If v.Parent = mContentWrapper And v.Visible Then
			h = Max(h, v.Top + v.Height)
		End If
	Next
	Return h
End Sub

Private Sub GetMaxRatio As Float
	If mBreakpoints.IsInitialized And mBreakpoints.Size > 0 Then
		Return mBreakpoints.Get(mBreakpoints.Size - 1)
	End If
	Return 1.0
End Sub

Private Sub ComputeBackdropAlpha(fBp As Float) As Float
	' Card style relies on the black parent tint instead of the dim backdrop
	If mbScaleBackground Then Return 0
	If fBp > mBackdropBreakpoint Then Return miBackdropOpacity / 100.0
	Return 0
End Sub

Private Sub UpdateBackdropAlpha
	Dim screenH As Int = mBaseH
	Dim boxH As Int = mBoxH
	If boxH <= 0 Then Return
	Dim ratio As Float = (screenH - mContentBox.Top) / boxH
	Dim maxRatio As Float = GetMaxRatio
	If ratio > mBackdropBreakpoint Then
		Dim range As Float = maxRatio - mBackdropBreakpoint
		Dim targetMax As Float = miBackdropOpacity / 100.0
		If range > 0 Then
			Dim pct As Float = (ratio - mBackdropBreakpoint) / range
			mBackdrop.Alpha = Max(0, Min(targetMax, pct * targetMax))
		Else
			mBackdrop.Alpha = targetMax
		End If
		mBackdrop.Enabled = True
	Else
		mBackdrop.Alpha = 0
		mBackdrop.Enabled = False
	End If
End Sub
#End Region

#Region Modal Lifecycle Methods
''' <summary>
''' Programmatically presents the overlay.
''' Split into PreparePresentation / AnimatePresentation / FireEvents.
''' Animation is Timer-driven (non-blocking); DidPresent fires on completion.
''' </summary>
Public Sub Present As ResumableSub
	If mbIsOpen Or mIsAnimating Then Return False
	mbIsOpen = True

	If xui.SubExists(mCallBack, mEventName & "_WillPresent", 0) Then
		CallSub(mCallBack, mEventName & "_WillPresent")
	End If

	PreparePresentation

	Dim screenH As Int = mBaseH
	Dim boxH As Int = mBoxH
	Dim targetTop As Int = screenH - (boxH * mCurrentBreakpoint)
	Dim backdropTarget As Float = ComputeBackdropAlpha(mCurrentBreakpoint)

	' Scale-background: recede the presenting view behind the sheet
	StartCardPresent

	If mbAnimated Then
		mContentBox.Top = screenH
		mBackdrop.Alpha = 0
		mBackdrop.Visible = True
		mBackdrop.Enabled = mCurrentBreakpoint > mBackdropBreakpoint
		BeginAnim(Max(1, miAnimationTime), "easeOutExpo", "present")
		AnimSetSheet(screenH, targetTop - screenH)
		AnimSetBackdrop(0, backdropTarget)
		If mbScaleBackground And mPresentingView.IsInitialized Then AnimSetPresenting(0, 1)
	Else
		mContentBox.Top = targetTop
		mBackdrop.Alpha = backdropTarget
		mBackdrop.Visible = True
		mBackdrop.Enabled = mCurrentBreakpoint > mBackdropBreakpoint
		ApplyPresentingTransform(1)
		CompletePresent
	End If
	Return True
End Sub

Private Sub PreparePresentation
	mCurrentBreakpoint = mInitialBreakpoint
	Measure
	Layout
	If mScrollPanel.IsInitialized Then mContentWrapper.Top = 0
	mBase.Visible = True
	mBase.BringToFront
End Sub

''' <summary>
''' Dismisses the overlay, passing optional data and role payloads.
''' Split into Prepare / Animate / Finalize / FireEvents.
''' </summary>
Public Sub Dismiss(oData As Object, sRole As String) As ResumableSub
	If Not(mbIsOpen) Or Not(mbCanDismiss) Or mIsAnimating Then Return False

	If xui.SubExists(mCallBack, mEventName & "_WillDismiss", 0) Then
		CallSub(mCallBack, mEventName & "_WillDismiss")
	End If

	mAnimDismissRole = sRole
	mAnimDismissData = oData

	Dim screenH As Int = mBaseH
	Dim curTop As Float = mContentBox.Top

	If mbAnimated Then
		Dim startAlpha As Float = mBackdrop.Alpha
		BeginAnim(Max(1, miAnimationTime), "easeOutCubic", "dismiss")
		AnimSetSheet(curTop, screenH - curTop)
		If startAlpha > 0 Then AnimSetBackdrop(startAlpha, -startAlpha)
		If mbScaleBackground And mPresentingView.IsInitialized Then AnimSetPresenting(1, -1)
	Else
		mContentBox.Top = screenH
		mBackdrop.Alpha = 0
		FinalizeDismiss(sRole, oData)
	End If
	Return True
End Sub

Private Sub FinalizeDismiss(sRole As String, oData As Object)
	mbIsOpen = False
	mBase.Visible = False
	mCurrentBreakpoint = 0.0
	mBackdrop.Alpha = 0
	If mScrollPanel.IsInitialized Then mContentWrapper.Top = 0
	' Restore the presenting element and its parent tint
	RestoreCardPresent
	If xui.SubExists(mCallBack, mEventName & "_DidDismiss", 2) Then
		CallSub3(mCallBack, mEventName & "_DidDismiss", sRole, oData)
	End If
End Sub
#End Region

#Region Animation Engine
''' <summary>
''' Starts (or restarts) the Timer-driven animator. Cancels any running animation.
''' </summary>
Private Sub BeginAnim(iDuration As Int, sEase As String, sCompleteSub As String)
	mAnimTimer.Enabled = False
	mAnimActive = False
	mAnimSheet = False
	mAnimScroll = False
	mAnimBackdrop = False
	mAnimPresenting = False
	mAnimEase = sEase
	mAnimDuration = Max(1, iDuration)
	mAnimStartMs = DateTime.Now
	mAnimCompleteSub = sCompleteSub
	mAnimActive = True
	mIsAnimating = True
	mAnimTimer.Enabled = True
End Sub

Private Sub StopAnim
	mAnimActive = False
	mAnimTimer.Enabled = False
	mIsAnimating = False
	mAnimSheet = False
	mAnimScroll = False
	mAnimBackdrop = False
	mAnimPresenting = False
End Sub

Private Sub AnimSetSheet(fStart As Float, fChange As Float)
	mAnimSheet = True
	mAnimSheetStart = fStart
	mAnimSheetChange = fChange
End Sub

Private Sub AnimSetScroll(fStart As Float, fChange As Float)
	mAnimScroll = True
	mAnimScrollStart = fStart
	mAnimScrollChange = fChange
End Sub

Private Sub AnimSetBackdrop(fStart As Float, fChange As Float)
	mAnimBackdrop = True
	mAnimBackdropStart = fStart
	mAnimBackdropChange = fChange
End Sub

''' <summary>
''' Drives the presenting-element card transform as a 0..1 progress channel.
''' 0 = identity (full size), 1 = fully receded (scaled down + translated).
''' </summary>
Private Sub AnimSetPresenting(fStart As Float, fChange As Float)
	mAnimPresenting = True
	mAnimPresentingStart = fStart
	mAnimPresentingChange = fChange
End Sub

Private Sub mAnimTimer_Tick
	If mAnimActive = False Then Return
	Dim elapsed As Long = DateTime.Now - mAnimStartMs
	If elapsed >= mAnimDuration Then
		If mAnimSheet Then mContentBox.Top = mAnimSheetStart + mAnimSheetChange
		If mAnimScroll Then mContentWrapper.Top = mAnimScrollStart + mAnimScrollChange
		If mAnimBackdrop Then mBackdrop.Alpha = mAnimBackdropStart + mAnimBackdropChange
		If mAnimPresenting Then ApplyPresentingTransform(mAnimPresentingStart + mAnimPresentingChange)
		Dim cb As String = mAnimCompleteSub
		StopAnim
		If cb.Length > 0 Then DispatchComplete(cb)
		Return
	End If
	Dim t As Float = elapsed
	If mAnimSheet Then mContentBox.Top = EvalEase(mAnimEase, t, mAnimSheetStart, mAnimSheetChange, mAnimDuration)
	If mAnimScroll Then mContentWrapper.Top = EvalEase(mAnimEase, t, mAnimScrollStart, mAnimScrollChange, mAnimDuration)
	If mAnimBackdrop Then mBackdrop.Alpha = EvalEase(mAnimEase, t, mAnimBackdropStart, mAnimBackdropChange, mAnimDuration)
	If mAnimPresenting Then ApplyPresentingTransform(EvalEase(mAnimEase, t, mAnimPresentingStart, mAnimPresentingChange, mAnimDuration))
End Sub

Private Sub DispatchComplete(sName As String)
	Select sName
		Case "present"
			CompletePresent
		Case "dismiss"
			CompleteDismiss
		Case "snap"
			CompleteSnap
		Case "fling"
			' no event
	End Select
End Sub

Private Sub CompletePresent
	If xui.SubExists(mCallBack, mEventName & "_DidPresent", 0) Then
		CallSub(mCallBack, mEventName & "_DidPresent")
	End If
End Sub

Private Sub CompleteDismiss
	FinalizeDismiss(mAnimDismissRole, mAnimDismissData)
End Sub

Private Sub CompleteSnap
	If mAnimPrevBp <> mCurrentBreakpoint Then FireBreakpointDidChange
End Sub

Private Sub FireBreakpointDidChange
	If xui.SubExists(mCallBack, mEventName & "_BreakpointDidChange", 1) Then
		CallSub2(mCallBack, mEventName & "_BreakpointDidChange", mCurrentBreakpoint)
	End If
End Sub

Private Sub EvalEase(sEase As String, fT As Float, fStart As Float, fChange As Float, iDuration As Int) As Float
	Select sEase
		Case "linear"
			Return Anim.linearTween(fT, fStart, fChange, iDuration)
		Case "easeOutQuad"
			Return Anim.easeOutQuad(fT, fStart, fChange, iDuration)
		Case "easeOutQuart"
			Return Anim.easeOutQuart(fT, fStart, fChange, iDuration)
		Case "easeOutExpo"
			Return Anim.easeOutExpo(fT, fStart, fChange, iDuration)
		Case Else
			Return Anim.easeOutCubic(fT, fStart, fChange, iDuration)
	End Select
End Sub

''' <summary>
''' Animates only the scroll panel top to a target position.
''' </summary>
Private Sub AnimateScrollTo(iTarget As Int, sEase As String, iDuration As Int)
	If mScrollPanel.IsInitialized = False Then Return
	BeginAnim(iDuration, sEase, "fling")
	AnimSetScroll(mContentWrapper.Top, iTarget - mContentWrapper.Top)
End Sub
#End Region

#Region Scale Background (Card Presentation)
''' <summary>
''' Applies the iOS card-modal transform to the presenting view for a given
''' progress (0 = identity, 1 = fully receded): scale, translateY, rounded top
''' corners, optional dim and shadow - mirroring ion-modal's presentingElement.
''' </summary>
Private Sub ApplyPresentingTransform(fProgress As Float)
	If mPresentingView.IsInitialized = False Then Return
	If mbScaleBackground = False Then Return
	Dim p As Float = Max(0, Min(1, fProgress))
	#If B4A
	Dim scale As Float = 1 + (mBackgroundScale - 1) * p
	Dim ty As Float = mBackgroundTranslateY * p
	Dim jo As JavaObject = mPresentingView
	' Each transform is guarded separately so one unsupported call does not
	' silently abort the rest (this previously masked translation).
	Try
		Dim w As Int = jo.RunMethod("getWidth", Null)
		Dim px As Float = w / 2
		jo.RunMethod("setPivotX", Array As Object(px))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingTransform: " & LastException.Message)
	End Try
	Try
		Dim py As Float = 0
		jo.RunMethod("setPivotY", Array As Object(py))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingTransform: " & LastException.Message)
	End Try
	Try
		jo.RunMethod("setScaleX", Array As Object(scale))
		jo.RunMethod("setScaleY", Array As Object(scale))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingTransform: " & LastException.Message)
	End Try
	Try
		jo.RunMethod("setTranslationY", Array As Object(ty))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingTransform: " & LastException.Message)
	End Try
	ApplyPresentingDim(jo, p)
	ApplyPresentingCornerRadius(p)
	#End If
End Sub

''' <summary>
''' Prepares the presenting view for a scale-background present: installs the
''' rounded-top outline (and optional shadow), then resets the transform.
''' </summary>
Private Sub StartCardPresent
	If mbScaleBackground = False Or mPresentingView.IsInitialized = False Then Return
	SetupPresentingCorners
	ApplyPresentingTransform(0)
End Sub

''' <summary>
''' Restores the presenting view to identity and tears down the outline/shadow.
''' </summary>
Private Sub RestoreCardPresent
	If mbScaleBackground = False Or mPresentingView.IsInitialized = False Then Return
	ApplyPresentingTransform(0)
	TeardownPresentingCorners
End Sub

''' <summary>
''' Installs a transparent rounded-top GradientDrawable as the presenting view's
''' background and enables clip-to-outline so its content clips to rounded top
''' corners. When BackgroundShadow is enabled, applies an elevation shadow that
''' follows the rounded outline. The original background is saved for restore.
''' </summary>
Private Sub SetupPresentingCorners
	If mbScaleBackground = False Or mPresentingView.IsInitialized = False Then Return
	#If B4A
	Dim jo As JavaObject = mPresentingView
	Try
		If mPresentingView.Parent.IsInitialized Then
			mSavedParentColor = mPresentingView.Parent.Color
			mPresentingView.Parent.Color = xui.Color_Black
		End If
		
		Dim presentingColor As Int = xui.Color_RGB(245, 247, 250)
		If mPresentingView.Color <> xui.Color_Transparent And mPresentingView.Color <> 0 Then
			presentingColor = mPresentingView.Color
		Else If mPresentingView.Parent.IsInitialized And mSavedParentColor <> xui.Color_Transparent And mSavedParentColor <> 0 Then
			presentingColor = mSavedParentColor
		End If

		mSavedPresentingBg = jo.RunMethod("getBackground", Null)
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setColor", Array As Object(presentingColor))
		Dim zero() As Float = Array As Float(0, 0, 0, 0, 0, 0, 0, 0)
		gd.RunMethod("setCornerRadii", Array As Object(zero))
		jo.RunMethod("setBackground", Array As Object(gd))
		mPresentingCornerRadiusJO = gd
		Dim ovp As JavaObject
		ovp.InitializeStatic("android.view.ViewOutlineProvider")
		jo.RunMethod("setOutlineProvider", Array As Object(ovp.GetField("BACKGROUND")))
		jo.RunMethod("setClipToOutline", Array As Object(True))
		If mbBackgroundShadow Then
			Dim elev As Float = CARD_SHADOW_ELEV
			jo.RunMethod("setElevation", Array As Object(elev))
			' Elevation drives z-order on API 21+: keep the sheet (mBase) above the
			' now-elevated presenting view so the modal is not drawn behind it.
			Try
				Dim baseElev As Float = elev + 8
				Dim joBase As JavaObject = mBase
				joBase.RunMethod("setElevation", Array As Object(baseElev))
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.SetupPresentingCorners: " & LastException.Message)
			End Try
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.SetupPresentingCorners: " & LastException.Message)
	End Try
	#End If
End Sub

''' <summary>
''' Restores the presenting view's original background, disables outline clipping
''' and clears the elevation shadow.
''' </summary>
Private Sub TeardownPresentingCorners
	If mbScaleBackground = False Or mPresentingView.IsInitialized = False Then Return
	#If B4A
	Dim jo As JavaObject = mPresentingView
	Try
		jo.RunMethod("setBackground", Array As Object(mSavedPresentingBg))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.TeardownPresentingCorners: " & LastException.Message)
	End Try
	Try
		jo.RunMethod("setClipToOutline", Array As Object(False))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.TeardownPresentingCorners: " & LastException.Message)
	End Try
	If mbBackgroundShadow Then
		Try
			Dim elev0 As Float = 0
			jo.RunMethod("setElevation", Array As Object(elev0))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.TeardownPresentingCorners: " & LastException.Message)
		End Try
		Try
			Dim baseElev0 As Float = 0
			Dim joBase As JavaObject = mBase
			joBase.RunMethod("setElevation", Array As Object(baseElev0))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.TeardownPresentingCorners: " & LastException.Message)
		End Try
	End If
	mPresentingCornerRadiusJO = Null
	mSavedPresentingBg = Null
	If mPresentingView.Parent.IsInitialized Then
		mPresentingView.Parent.Color = mSavedParentColor
	End If
	#End If
End Sub

''' <summary>
''' Animates the presenting view's top corner radius with the card progress.
''' </summary>
Private Sub ApplyPresentingCornerRadius(fP As Float)
	#If B4A
	If mPresentingCornerRadiusJO.IsInitialized = False Then Return
	Try
		Dim r As Float = mBackgroundCornerRadius * fP
		Dim radii() As Float = Array As Float(r, r, r, r, 0, 0, 0, 0)
		mPresentingCornerRadiusJO.RunMethod("setCornerRadii", Array As Object(radii))
		mPresentingCornerRadiusJO.RunMethod("invalidateSelf", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingCornerRadius: " & LastException.Message)
	End Try
	#End If
End Sub

''' <summary>
''' Applies a brightness dim to the presenting view (BackgroundDim).
''' Uses RenderEffect + ColorMatrix (RGB scale) on API 31+, falling back to alpha.
''' 0 = no dim, 1 = fully dark.
''' </summary>
Private Sub ApplyPresentingDim(joJo As JavaObject, fP As Float)
	#If B4A
	Dim s As Float = 1 - mBackgroundDim * fP
	If s >= 1 Then
		Try
			joJo.RunMethod("setRenderEffect", Array As Object(Null))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingDim: " & LastException.Message)
		End Try
		Try
			Dim alphaFull As Float = 1
		joJo.RunMethod("setAlpha", Array As Object(alphaFull))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingDim: " & LastException.Message)
		End Try
		Return
	End If
	Try
		Dim vals() As Float = Array As Float(s, 0, 0, 0, 0, 0, s, 0, 0, 0, 0, 0, s, 0, 0, 0, 0, 0, 1, 0)
		Dim cm As JavaObject
		cm.InitializeNewInstance("android.graphics.ColorMatrix", Array As Object(vals))
		Dim cf As JavaObject
		cf.InitializeNewInstance("android.graphics.ColorMatrixColorFilter", Array As Object(cm))
		Dim reStatic As JavaObject
		reStatic.InitializeStatic("android.graphics.RenderEffect")
		Dim effect As JavaObject = reStatic.RunMethod("createColorFilterEffect", Array As Object(cf))
		joJo.RunMethod("setRenderEffect", Array As Object(effect))
	Catch
		Try
			joJo.RunMethod("setAlpha", Array As Object(s))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySheetModal.ApplyPresentingDim: " & LastException.Message)
		End Try
	End Try
	#End If
End Sub

#Region User Interaction
Private Sub mBackdrop_Click
	If mbBackdropDismiss And mbCanDismiss Then
		Dismiss(Null, "backdrop")
	End If
End Sub

Private Sub mContentBox_Click
	' Traps clicks to prevent them from bubbling down to the backdrop
End Sub

Private Sub mContentBox_Touch (iAction As Int, fX As Float, fY As Float)
	HandleGesture(iAction, fX, fY, False)
End Sub

Private Sub mDragBar_Touch (iAction As Int, fX As Float, fY As Float)
	HandleGesture(iAction, fX, fY, True)
End Sub

''' <summary>
''' Unified gesture handler. Decides between scrolling content and dragging the
''' sheet (Ionic-style: "is content already scrolled? YES -> scroll, NO -> drag").
''' </summary>
Private Sub HandleGesture(iAction As Int, fX As Float, fY As Float, bIsHandle As Boolean)
	#If B4A
	B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
	#End If

	If mBase.IsInitialized = False Then Return
	If mbIsOpen = False Or mIsAnimating Then Return

	If iAction = mBase.TOUCH_ACTION_DOWN Then
		mIsDragging = True
		mDragMode = 0
		mHandedOff = False
		mStartScreenY = mContentBox.Top + fY
		mStartSheetTop = mContentBox.Top
		mStartScrollTop = mContentWrapper.Top
		mLastMoveTime = DateTime.Now
		mLastMoveY = mStartScreenY
		mVelocityY = 0
		If xui.SubExists(mCallBack, mEventName & "_DragStart", 0) Then
			CallSub(mCallBack, mEventName & "_DragStart")
		End If
	Else If iAction = mBase.TOUCH_ACTION_MOVE Then
		If mIsDragging = False Then Return
		Dim screenY As Float = mContentBox.Top + fY
		Dim deltaY As Float = screenY - mStartScreenY

		' Velocity tracking (px per ms) with light low-pass smoothing
		Dim nowTime As Long = DateTime.Now
		Dim dt As Long = nowTime - mLastMoveTime
		If dt > 0 Then
			Dim inst As Float = (screenY - mLastMoveY) / dt
			mVelocityY = mVelocityY * 0.6 + inst * 0.4
		End If
		mLastMoveTime = nowTime
		mLastMoveY = screenY

		' Decide mode on first significant move
		If mDragMode = 0 And Abs(deltaY) > 1dip Then
			mDragMode = DecideDragMode(bIsHandle, deltaY)
		End If

		If mDragMode = 1 Then
			ApplyScrollMove(deltaY)
		Else If mDragMode = 2 Then
			ApplySheetMove(deltaY)
		End If

		FireDragMove(screenY, deltaY)
	Else If iAction = mBase.TOUCH_ACTION_UP Then
		If mIsDragging Then
			mIsDragging = False
			FinishGesture(bIsHandle)
		End If
	End If
End Sub

''' <summary>
''' Determines whether this gesture scrolls content or drags the sheet.
''' </summary>
Private Sub DecideDragMode(bIsHandle As Boolean, fDeltaY As Float) As Int
	If bIsHandle Then Return 2
	If mExpandToScroll = False Then Return 2
	If msScrollBehavior = "drag" Then Return 2
	If mCanScroll = False Then Return 2
	If msScrollBehavior = "scroll" Then Return 1
	' auto:
	If mStartScrollTop < 0 Then Return 1     ' content is scrolled -> keep scrolling
	If fDeltaY < 0 Then Return 1              ' moving up -> reveal lower content
	Return 2                                 ' at top + pulling down -> drag sheet
End Sub

''' <summary>
''' Applies a scroll gesture. Pulling past the top either hands off to sheet
''' dragging (nested scroll) or rubber-bands, depending on NestedScrollEnabled.
''' </summary>
Private Sub ApplyScrollMove(fDeltaY As Float)
	Dim rawTop As Float = mStartScrollTop + fDeltaY
	If rawTop > 0 Then
		' Past the top
		If mbNestedScrollEnabled Then
			mContentWrapper.Top = 0
			Dim sheetTarget As Float = mStartSheetTop + rawTop
			mContentBox.Top = ClampSheetRubber(sheetTarget)
			mHandedOff = True
			UpdateBackdropAlpha
		Else
			mContentWrapper.Top = rawTop * mResistance
		End If
	Else If rawTop < mMaxScrollTop Then
		' Past the bottom: rubber band
		mContentWrapper.Top = mMaxScrollTop + (rawTop - mMaxScrollTop) * mResistance
	Else
		mContentWrapper.Top = rawTop
	End If
End Sub

''' <summary>
''' Applies a sheet-drag gesture with rubber-band over-drag at both ends.
''' </summary>
Private Sub ApplySheetMove(fDeltaY As Float)
	Dim sheetTarget As Float = mStartSheetTop + fDeltaY
	mContentBox.Top = ClampSheetRubber(sheetTarget)
	UpdateBackdropAlpha
End Sub

''' <summary>
''' Clamps the sheet top to its bounds, allowing a resisted rubber-band over-drag
''' beyond the fully-open and fully-closed positions before springing back.
''' </summary>
Private Sub ClampSheetRubber(fTarget As Float) As Float
	Dim screenH As Int = mBaseH
	Dim boxH As Int = mBoxH
	Dim maxRatio As Float = GetMaxRatio
	Dim minTop As Int = screenH - (boxH * maxRatio)
	Dim maxTop As Int = screenH
	If fTarget < minTop Then
		Return minTop + (fTarget - minTop) * mResistance
	Else If fTarget > maxTop Then
		Return maxTop + (fTarget - maxTop) * mResistance
	Else
		Return fTarget
	End If
End Sub

''' <summary>
''' Finalizes a gesture: tap detection, scroll fling, or sheet snap (with momentum).
''' </summary>
Private Sub FinishGesture(bIsHandle As Boolean)
	Dim totalMove As Float = Abs(mContentBox.Top - mStartSheetTop) + Abs(mContentWrapper.Top - mStartScrollTop)
	If totalMove < mTapThreshold Then
		If bIsHandle Then HandleDragBarClick
		FireDragEnd
		Return
	End If

	If mDragMode = 1 And mHandedOff Then
		FinishSheetSnap
	Else If mDragMode = 1 Then
		FinishScrollFling
	Else If mDragMode = 2 Then
		FinishSheetSnap
	End If
	FireDragEnd
End Sub

''' <summary>
''' Snaps the sheet to a breakpoint using momentum prediction.
''' Fast swipes overshoot the nearest breakpoint and snap further.
''' </summary>
Private Sub FinishSheetSnap
	Dim screenH As Int = mBaseH
	Dim boxH As Int = mBoxH
	If boxH <= 0 Then Return
	Dim ratio As Float = (screenH - mContentBox.Top) / boxH
	Dim predicted As Float = ratio
	If Abs(mVelocityY) > mVelThreshold Then
		predicted = ratio - (mVelocityY * mPredictMs) / boxH
	End If
	Dim target As Float = FindClosestBreakpoint(predicted)
	If target <= 0.0 Then
		If mbCanDismiss Then
			Dismiss(Null, "gesture")
		Else
			setCurrentBreakpoint(LowestNonZeroBreakpoint)
		End If
	Else
		setCurrentBreakpoint(target)
	End If
End Sub

''' <summary>
''' Flings the scroll content using the gesture velocity, then springs back
''' if it was rubber-banded.
''' </summary>
Private Sub FinishScrollFling
	If mCanScroll = False Then Return
	Dim curTop As Float = mContentWrapper.Top
	Dim target As Float
	If Abs(mVelocityY) < mVelThreshold Then
		target = Max(mMaxScrollTop, Min(0, curTop))
		If target = curTop Then Return
		AnimateScrollTo(target, "easeOutCubic", 200)
	Else
		target = curTop + mVelocityY * mFlingMs
		target = Max(mMaxScrollTop, Min(0, target))
		AnimateScrollTo(target, "easeOutCubic", 250)
	End If
End Sub

Private Sub HandleDragBarClick
	If msHandleBehavior = "cycle" Then
		Dim curIdx As Int = mBreakpoints.IndexOf(mCurrentBreakpoint)
		If curIdx = -1 Then
			Dim closest As Float = FindClosestBreakpoint(mCurrentBreakpoint)
			curIdx = mBreakpoints.IndexOf(closest)
		End If

		Dim nextIdx As Int = -1
		Dim attempts As Int = 0
		Dim tempIdx As Int = curIdx
		Do While attempts < mBreakpoints.Size
			tempIdx = (tempIdx + 1) Mod mBreakpoints.Size
			Dim bp As Float = mBreakpoints.Get(tempIdx)
			If bp > 0 Then
				nextIdx = tempIdx
				Exit
			End If
			attempts = attempts + 1
		Loop

		If nextIdx <> -1 Then
			Dim nextBp As Float = mBreakpoints.Get(nextIdx)
			setCurrentBreakpoint(nextBp)
		End If
	End If
End Sub

Private Sub FireDragMove(fScreenY As Float, fDeltaY As Float)
	If xui.SubExists(mCallBack, mEventName & "_DragMove", 1) = False Then Return
	Dim screenH As Int = mBaseH
	Dim boxH As Int = mBoxH
	Dim progress As Float = 0
	If boxH > 0 Then progress = (screenH - mContentBox.Top) / boxH
	Dim snapBp As Float = FindClosestBreakpoint(progress)
	Dim dragData As Map = CreateMap( _
		"currentY": fScreenY, _
		"deltaY": fDeltaY, _
		"velocityY": mVelocityY, _
		"progress": progress, _
		"snapBreakpoint": snapBp, _
		"mode": mDragMode)
	CallSub2(mCallBack, mEventName & "_DragMove", dragData)
End Sub

Private Sub FireDragEnd
	If xui.SubExists(mCallBack, mEventName & "_DragEnd", 1) = False Then Return
	Dim screenH As Int = mBaseH
	Dim boxH As Int = mBoxH
	Dim progress As Float = 0
	If boxH > 0 Then progress = (screenH - mContentBox.Top) / boxH
	Dim dragData As Map = CreateMap( _
		"currentY": mContentBox.Top, _
		"deltaY": mContentBox.Top - mStartSheetTop, _
		"velocityY": mVelocityY, _
		"progress": progress, _
		"snapBreakpoint": mCurrentBreakpoint, _
		"mode": mDragMode)
	CallSub2(mCallBack, mEventName & "_DragEnd", dragData)
End Sub

Private Sub FindClosestBreakpoint(fRatio As Float) As Float
	Dim closest As Float = 0
	Dim minDiff As Float = 999999
	For Each bp As Float In mBreakpoints
		Dim diff As Float = Abs(bp - fRatio)
		If diff < minDiff Then
			minDiff = diff
			closest = bp
		End If
	Next
	Return closest
End Sub


#End Region

#Region Getters and Setters
Public Sub setIsOpen(bValue As Boolean)
	If mbIsOpen = bValue Then Return
	If bValue Then
		Present
	Else
		Dismiss(Null, "programmatic")
	End If
End Sub

Public Sub getIsOpen As Boolean
	Return mbIsOpen
End Sub

Public Sub setCanDismiss(bValue As Boolean)
	mbCanDismiss = bValue
End Sub

Public Sub getCanDismiss As Boolean
	Return mbCanDismiss
End Sub

Public Sub setBackdropDismiss(bValue As Boolean)
	mbBackdropDismiss = bValue
End Sub

Public Sub getBackdropDismiss As Boolean
	Return mbBackdropDismiss
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setAnimated(bValue As Boolean)
	mbAnimated = bValue
End Sub

Public Sub getAnimated As Boolean
	Return mbAnimated
End Sub

''' <summary>
''' Sets the open/close slide animation duration in milliseconds (0 = instant).
''' </summary>
Public Sub setDuration(iValue As Int)
	miAnimationTime = Max(0, iValue)
End Sub

''' <summary>
''' Returns the open/close slide animation duration in milliseconds.
''' </summary>
Public Sub getDuration As Int
	Return miAnimationTime
End Sub

' Deprecated aliases (backward compatibility).
Public Sub setAnimationTime(iValue As Int)
	setDuration(iValue)
End Sub

Public Sub getAnimationTime As Int
	Return getDuration
End Sub

Public Sub setBreakpoints(sValue As String)
	msBreakpointsString = sValue
	If mBase.IsInitialized Then
		ParseBreakpoints(msBreakpointsString)
		ValidateInitialBreakpoint
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getBreakpoints As String
	Return msBreakpointsString
End Sub

Public Sub setInitialBreakpoint(fValue As Float)
	mInitialBreakpoint = fValue
	If mBreakpoints.IsInitialized Then ValidateInitialBreakpoint
End Sub

Public Sub getInitialBreakpoint As Float
	Return mInitialBreakpoint
End Sub

Public Sub setBackdropBreakpoint(fValue As Float)
	mBackdropBreakpoint = fValue
	If mBase.IsInitialized Then
		setCurrentBreakpoint(mCurrentBreakpoint)
	End If
End Sub

Public Sub getBackdropBreakpoint As Float
	Return mBackdropBreakpoint
End Sub

Public Sub setHandle(bValue As Boolean)
	mbHandle = bValue
	If mBase.IsInitialized Then
		Refresh
	End If
End Sub

Public Sub getHandle As Boolean
	Return mbHandle
End Sub

Public Sub setHandleBehavior(sValue As String)
	msHandleBehavior = sValue
End Sub

Public Sub getHandleBehavior As String
	Return msHandleBehavior
End Sub

Public Sub setCurrentBreakpoint(fBreakpoint As Float)
	If mBase.IsInitialized = False Then Return
	Dim bp As Float = FindClosestBreakpoint(fBreakpoint)
	If bp = 0.0 Then
		Dismiss(Null, "programmatic")
		Return
	End If

	Dim oldBp As Float = mCurrentBreakpoint
	mCurrentBreakpoint = bp
	mAnimPrevBp = oldBp

	Dim screenH As Int = mBase.Height
	Dim boxH As Int = mBoxH
	If boxH <= 0 Then
		Measure
		boxH = mBoxH
	End If
	Dim targetTop As Int = screenH - (boxH * mCurrentBreakpoint)
	Dim backdropTarget As Float = ComputeBackdropAlpha(mCurrentBreakpoint)

	If mScrollPanel.IsInitialized Then mContentWrapper.Top = 0

	If mbAnimated Then
		Dim startTop As Float = mContentBox.Top
		Dim startAlpha As Float = mBackdrop.Alpha
		BeginAnim(150, "easeOutCubic", "snap")
		AnimSetSheet(startTop, targetTop - startTop)
		If Abs(backdropTarget - startAlpha) > 0.001 Then
			AnimSetBackdrop(startAlpha, backdropTarget - startAlpha)
		End If
	Else
		mContentBox.Top = targetTop
		mBackdrop.Alpha = backdropTarget
		mBackdrop.Enabled = mCurrentBreakpoint > mBackdropBreakpoint
		If oldBp <> mCurrentBreakpoint Then FireBreakpointDidChange
	End If
End Sub

Public Sub getCurrentBreakpoint As Float
	Return mCurrentBreakpoint
End Sub

''' <summary>
''' The view that recedes behind the sheet (iOS presentingElement equivalent).
''' Typically the page root container. Required for the scale-background effect.
''' </summary>
Public Sub setPresentingView(vTargetView As B4XView)
	mPresentingView = vTargetView
End Sub

Public Sub getPresentingView As B4XView
	Return mPresentingView
End Sub

''' <summary>
''' Enables the iOS card-modal effect on PresentingView (scale + translate +
''' rounded top corners + dim + optional shadow) during Present/Dismiss.
''' </summary>
Public Sub setScaleBackground(bValue As Boolean)
	mbScaleBackground = bValue
End Sub

Public Sub getScaleBackground As Boolean
	Return mbScaleBackground
End Sub

''' <summary>
''' Target scale of the presenting view when fully receded (1.0 = none).
''' </summary>
Public Sub setBackgroundScale(fValue As Float)
	mBackgroundScale = Max(0.1, Min(1.0, fValue))
End Sub

Public Sub getBackgroundScale As Float
	Return mBackgroundScale
End Sub

''' <summary>
''' Top corner radius (dip) applied to the presenting view.
''' </summary>
Public Sub setBackgroundCornerRadius(iValue As Int)
	mBackgroundCornerRadius = Max(0, iValue)
End Sub

Public Sub getBackgroundCornerRadius As Int
	Return mBackgroundCornerRadius
End Sub

''' <summary>
''' Downward shift (dip) of the presenting view when fully receded.
''' </summary>
Public Sub setBackgroundTranslateY(iValue As Int)
	mBackgroundTranslateY = Max(0, iValue)
End Sub

Public Sub getBackgroundTranslateY As Int
	Return mBackgroundTranslateY
End Sub

''' <summary>
''' Dim amount (0 = none, 1 = full) applied to the presenting view.
''' </summary>
Public Sub setBackgroundDim(fValue As Float)
	mBackgroundDim = Max(0, Min(1, fValue))
End Sub

Public Sub getBackgroundDim As Float
	Return mBackgroundDim
End Sub

''' <summary>
''' If true, casts an elevation shadow around the receded presenting view.
''' </summary>
Public Sub setBackgroundShadow(bValue As Boolean)
	mbBackgroundShadow = bValue
End Sub

Public Sub getBackgroundShadow As Boolean
	Return mbBackgroundShadow
End Sub

Public Sub setBackdropOpacity(iValue As Int)
	miBackdropOpacity = iValue
	If mBase.IsInitialized Then
		setCurrentBreakpoint(mCurrentBreakpoint)
	End If
End Sub

Public Sub getBackdropOpacity As Int
	Return miBackdropOpacity
End Sub

Public Sub setBorderColor(iValue As Int)
	mcBorderColor = iValue
	If mBase.IsInitialized Then
		Refresh
	End If
End Sub

Public Sub getBorderColor As Int
	Return mcBorderColor
End Sub

Public Sub setBorderWidth(iValue As Int)
	miBorderWidth = iValue
	If mBase.IsInitialized Then
		Refresh
	End If
End Sub

Public Sub getBorderWidth As Int
	Return miBorderWidth
End Sub

Public Sub setWidth(sValue As String)
	msWidth = sValue
	If mBase.IsInitialized Then
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getWidth As String
	Return msWidth
End Sub

Public Sub setHeight(sValue As String)
	msHeight = sValue
	If mBase.IsInitialized Then
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getHeight As String
	Return msHeight
End Sub

Public Sub setAutoHeight(bValue As Boolean)
	mAutoHeight = bValue
	If mBase.IsInitialized Then
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getAutoHeight As Boolean
	Return mAutoHeight
End Sub

''' <summary>
''' Public accessor for the fully-open sheet height (centralized computation).
''' </summary>
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return ComputeSheetHeight(MeasureContentHeight)
End Sub

Public Sub setRounded(sValue As String)
	msRounded = sValue
	If mBase.IsInitialized Then
		Refresh
	End If
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

''' <summary>
''' Returns the resolved top corner radius of the sheet modal in dip.
''' </summary>
Public Sub getCornerRadius As Int
	Return B4XDaisyVariants.ResolveRoundedDip(msRounded, 16dip)
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mcBackgroundColor = iValue
	If mBase.IsInitialized Then
		Refresh
	End If
End Sub

Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub setExpandToScroll(bValue As Boolean)
	mExpandToScroll = bValue
End Sub

Public Sub getExpandToScroll As Boolean
	Return mExpandToScroll
End Sub

Public Sub setScrollBehavior(sValue As String)
	msScrollBehavior = sValue
End Sub

Public Sub getScrollBehavior As String
	Return msScrollBehavior
End Sub

Public Sub setNestedScrollEnabled(bValue As Boolean)
	mbNestedScrollEnabled = bValue
End Sub

Public Sub getNestedScrollEnabled As Boolean
	Return mbNestedScrollEnabled
End Sub
#End Region
