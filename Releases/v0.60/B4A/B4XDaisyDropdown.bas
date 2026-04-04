B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

#Event: Click (Tag As Object)
#Event: ItemClick (Tag As Object, Text As String)
#Event: SubmenuToggle (Tag As Object, IsOpen As Boolean)
#Event: Opened
#Event: Closed

#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables dropdown interactions.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the dropdown.
#DesignerProperty: Key: Open, DisplayName: Open, FieldType: Boolean, DefaultValue: False, Description: Initial open state.
#DesignerProperty: Key: Placement, DisplayName: Placement, FieldType: String, DefaultValue: start, List: start|center|end, Description: Alignment of the popup relative to the trigger. Default start keeps the popup left edge aligned with the target for top/bottom dropdowns.
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: bottom, List: top|bottom|left|right, Description: Direction used when opening the dropdown. Together with Placement=start, the default behavior is bottom-left on the target unless changed.
#DesignerProperty: Key: HoverOpen, DisplayName: Hover Open, FieldType: Boolean, DefaultValue: False, Description: Hover-style mode. On B4A this falls back to click behavior.
#DesignerProperty: Key: ForceOpen, DisplayName: Force Open, FieldType: Boolean, DefaultValue: False, Description: Forces the popup to stay open.
#DesignerProperty: Key: ForceClose, DisplayName: Force Close, FieldType: Boolean, DefaultValue: False, Description: Forces the popup to stay closed.
#DesignerProperty: Key: MenuWidth, DisplayName: Menu Width, FieldType: String, DefaultValue: w-52, Description: Tailwind or CSS width token used for the popup menu.
#DesignerProperty: Key: MenuPadding, DisplayName: Menu Padding, FieldType: String, DefaultValue: p-2, Description: Tailwind padding applied to the popup menu.
#DesignerProperty: Key: MenuRounded, DisplayName: Menu Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Rounded token applied to the popup menu.
#DesignerProperty: Key: MenuShadow, DisplayName: Menu Shadow, FieldType: String, DefaultValue: sm, List: none|xs|sm|md|lg|xl|2xl, Description: Shadow level applied to the popup menu.
#DesignerProperty: Key: BringToFront, DisplayName: Bring To Front, FieldType: Boolean, DefaultValue: True, Description: Brings the trigger and popup to the front when opened.
#DesignerProperty: Key: MenuBackgroundColor, DisplayName: Menu Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional popup menu background override.
#DesignerProperty: Key: MenuTextColor, DisplayName: Menu Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional popup menu text color override.

' Daisy dropdown token manifest for parity/style auditing:
' absolute, bg-base-100, bottom-0, bottom-1/2, bottom-auto, bottom-full, btn,
' dropdown, dropdown-bottom, dropdown-center, dropdown-content, dropdown-end,
' dropdown-hover, dropdown-left, dropdown-open, dropdown-right, dropdown-start,
' dropdown-top, end-0, end-1/2, end-auto, end-full, fixed, hidden,
' inline-block, m-1, m-auto, menu, opacity-0, opacity-100, origin-bottom,
' origin-left, origin-right, origin-top, outline-hidden, p-2, pointer-events-none,
' relative, rounded-box, shadow-sm, start-full, text-inherit, top-0, top-auto,
' top-full, w-52, z-1

Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private mbOpen As Boolean = False
    Private msPlacement As String = "start"
    Private msDirection As String = "bottom"
    Private mbHoverOpen As Boolean = False
    Private mbForceOpen As Boolean = False
    Private mbForceClose As Boolean = False
    Private msMenuWidth As String = "w-52"
    Private msMenuPadding As String = "p-2"
    Private msMenuRounded As String = "theme"
    Private msMenuShadow As String = "sm"
    Private mbBringToFront As Boolean = True
    Private mcMenuBackgroundColor As Int = 0
    Private mcMenuTextColor As Int = 0

    Private mMenu As B4XDaisyMenu
    Private mvAnchorTarget As B4XView
    Private pnlTriggerCapture As B4XView

    Private pnlOutsideCapture As B4XView
    Private pnlPopupLayer As B4XView
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    EnsureCaptureLayer
    EnsureMenu
    ApplyDesignerProps(Props)
    Refresh
End Sub

Private Sub EnsureCaptureLayer
    If pnlTriggerCapture.IsInitialized Then Return
    Dim p As Panel
    p.Initialize("ddcapture")
    pnlTriggerCapture = p
    pnlTriggerCapture.Color = xui.Color_Transparent
    mBase.AddView(pnlTriggerCapture, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
End Sub

Private Sub EnsureMenu
    If mMenu.IsInitialized Then Return
    Dim menuComp As B4XDaisyMenu
    menuComp.Initialize(Me, "ddmenu")
    menuComp.SetPopupMode(True)
    menuComp.Orientation = "vertical"
    menuComp.Size = "md"
    menuComp.BringToFront = True
    mMenu = menuComp

    ' Force create the internal menu view so that mMenu.View is valid immediately.
    ' This prevents "Object should first be initialized" crashes during early measurements or configuration.
    Dim p As Panel
    p.Initialize("")
    Dim creator As B4XView = p
    mMenu.AddToParent(creator, 0, 0, 200dip, 100dip)
    mMenu.RemoveViewFromParent
    mMenu.Visible = False
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    mbOpen = B4XDaisyVariants.GetPropBool(Props, "Open", False)
    msPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(Props, "Placement", "start"))
    msDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(Props, "Direction", "bottom"))
    mbHoverOpen = B4XDaisyVariants.GetPropBool(Props, "HoverOpen", False)
    mbForceOpen = B4XDaisyVariants.GetPropBool(Props, "ForceOpen", False)
    mbForceClose = B4XDaisyVariants.GetPropBool(Props, "ForceClose", False)
    msMenuWidth = NormalizeSizeSpec(B4XDaisyVariants.GetPropString(Props, "MenuWidth", "w-52"), "w-52")
    msMenuPadding = B4XDaisyVariants.GetPropString(Props, "MenuPadding", "p-2")
    msMenuRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "MenuRounded", "theme"))
    msMenuShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "MenuShadow", "sm"))
    mbBringToFront = B4XDaisyVariants.GetPropBool(Props, "BringToFront", True)
    mcMenuBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "MenuBackgroundColor", 0)
    mcMenuTextColor = B4XDaisyVariants.GetPropColor(Props, "MenuTextColor", 0)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim baseView As B4XView = p
        baseView.Color = xui.Color_Transparent
        baseView.SetLayoutAnimated(0, 0, 0, Max(1dip, ResolveBaseWidth(Width)), Max(1dip, ResolveBaseHeight(Height)))
        Dim dummy As Label
        DesignerCreateView(baseView, dummy, BuildRuntimeProps)
    End If

    ClearAnchorTarget
    Dim targetW As Int = ResolveBaseWidth(Width)
    Dim targetH As Int = ResolveBaseHeight(Height)
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    Parent.AddView(mBase, Left, Top, targetW, targetH)
    Base_Resize(targetW, targetH)
    Refresh
    Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
    Dim props As Map
    props.Initialize
    props.Put("Enabled", mbEnabled)
    props.Put("Visible", mbVisible)
    props.Put("Open", mbOpen)
    props.Put("Placement", msPlacement)
    props.Put("Direction", msDirection)
    props.Put("HoverOpen", mbHoverOpen)
    props.Put("ForceOpen", mbForceOpen)
    props.Put("ForceClose", mbForceClose)
    props.Put("MenuWidth", msMenuWidth)
    props.Put("MenuPadding", msMenuPadding)
    props.Put("MenuRounded", msMenuRounded)
    props.Put("MenuShadow", msMenuShadow)
    props.Put("BringToFront", mbBringToFront)
    props.Put("MenuBackgroundColor", mcMenuBackgroundColor)
    props.Put("MenuTextColor", mcMenuTextColor)
    Return props
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    EnsureCaptureLayer
    EnsureMenu

    Dim targetW As Int = Max(1dip, Width)
    Dim targetH As Int = Max(1dip, Height)
    pnlTriggerCapture.SetLayoutAnimated(0, 0, 0, targetW, targetH)
    pnlTriggerCapture.Visible = mbVisible
    pnlTriggerCapture.Enabled = mbEnabled
    pnlTriggerCapture.BringToFront
    B4XDaisyVariants.ApplyElevation(mBase, "2xl")
    B4XDaisyVariants.ApplyElevation(pnlTriggerCapture, "2xl")
    LayoutPopup
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    EnsureCaptureLayer
    EnsureMenu
    SyncAttachedLayout
    SyncMenu
    mBase.Visible = mbVisible
    pnlTriggerCapture.Visible = mbVisible
    pnlTriggerCapture.Enabled = mbEnabled

    If ShouldPopupBeVisible Then
        EnsurePopupLayersAttached
        LayoutPopup
    Else
        HidePopupLayers
    End If

    If mbBringToFront And mBase.Parent.IsInitialized Then
        mBase.BringToFront
        B4XDaisyVariants.ApplyElevation(mBase, "2xl")
        B4XDaisyVariants.ApplyElevation(pnlTriggerCapture, "2xl")
        If pnlOutsideCapture.IsInitialized Then pnlOutsideCapture.BringToFront
        If pnlOutsideCapture.IsInitialized Then B4XDaisyVariants.ApplyElevation(pnlOutsideCapture, "none")
        If pnlPopupLayer.IsInitialized Then pnlPopupLayer.BringToFront
        If pnlPopupLayer.IsInitialized Then ApplyPopupLayerElevation(pnlPopupLayer)
    End If
End Sub

Private Sub SyncMenu
    If mMenu.IsInitialized = False Then Return
    mMenu.Enabled = mbEnabled
    mMenu.Visible = True
    mMenu.Padding = msMenuPadding
    mMenu.Rounded = msMenuRounded
    mMenu.RoundedBox = True
    mMenu.Shadow = msMenuShadow
    mMenu.BringToFront = True
    mMenu.SetPopupMode(True)
    mMenu.setWidth(msMenuWidth)
    mMenu.setHeight("auto")
    mMenu.BackgroundColor = mcMenuBackgroundColor
    mMenu.TextColor = mcMenuTextColor
End Sub

Private Sub EnsurePopupLayersAttached
    Dim host As B4XView = ResolveOverlayHost
    If host.IsInitialized = False Then Return

    If pnlOutsideCapture.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("ddoutside")
        pnlOutsideCapture = p
        pnlOutsideCapture.Color = xui.Color_Transparent
    End If

    If pnlPopupLayer.IsInitialized = False Then
        Dim pp As Panel
        pp.Initialize("")
        pnlPopupLayer = pp
        pnlPopupLayer.Color = xui.Color_Transparent
    End If

    If pnlOutsideCapture.Parent.IsInitialized And IsSameView(pnlOutsideCapture.Parent, host) = False Then
        pnlOutsideCapture.RemoveViewFromParent
    End If
    If pnlPopupLayer.Parent.IsInitialized And IsSameView(pnlPopupLayer.Parent, host) = False Then
        pnlPopupLayer.RemoveViewFromParent
    End If

    If pnlOutsideCapture.Parent.IsInitialized = False Then
        host.AddView(pnlOutsideCapture, 0, 0, host.Width, host.Height)
    Else
        pnlOutsideCapture.SetLayoutAnimated(0, 0, 0, host.Width, host.Height)
    End If
    
    If pnlPopupLayer.Parent.IsInitialized = False Then
        ' Initial add, size doesn't matter yet as LayoutPopup will set it
        host.AddView(pnlPopupLayer, 0, 0, 1dip, 1dip)
    End If

    pnlOutsideCapture.BringToFront
    pnlOutsideCapture.Visible = ShouldUseOutsideCapture
    pnlPopupLayer.BringToFront
    pnlPopupLayer.Visible = True
    B4XDaisyVariants.ApplyElevation(pnlOutsideCapture, "none")
    ApplyPopupLayerElevation(pnlPopupLayer)
    B4XDaisyVariants.DisableClippingRecursive(host)
    B4XDaisyVariants.DisableClippingRecursive(pnlPopupLayer)
    B4XDaisyVariants.DisableClippingRecursive(mBase)
    If mvAnchorTarget.IsInitialized Then B4XDaisyVariants.DisableClippingRecursive(mvAnchorTarget)
    LogDropdownDebugState("EnsurePopupLayersAttached", -1, -1, -1, -1)
End Sub

Private Sub HidePopupLayers
    If pnlOutsideCapture.IsInitialized Then pnlOutsideCapture.Visible = False
    If pnlPopupLayer.IsInitialized = False Then Return
    If mMenu.IsInitialized Then mMenu.RemoveViewFromParent
    pnlPopupLayer.Visible = False
End Sub

Private Sub ResolvePopupChromePadding As Int
    Select Case B4XDaisyVariants.NormalizeShadow(msMenuShadow)
        Case "none"
            Return 0dip
        Case "xs"
            Return 3dip
        Case "sm"
            Return 5dip
        Case "md"
            Return 7dip
        Case "lg"
            Return 10dip
        Case "xl"
            Return 14dip
        Case Else
            Return 18dip
    End Select
End Sub

Private Sub ResolvePopupChromeInsets(Direction As String, Placement As String, ChromePad As Int) As Map
    Dim leftPad As Int = ChromePad
    Dim topPad As Int = ChromePad
    Dim rightPad As Int = ChromePad
    Dim bottomPad As Int = ChromePad

    Select Case Direction
        Case "top", "bottom"
            Select Case Placement
                Case "start"
                    leftPad = 0
                    rightPad = ChromePad * 2
                Case "end"
                    leftPad = ChromePad * 2
                    rightPad = 0
            End Select
        Case Else
            Select Case Placement
                Case "start"
                    topPad = 0
                    bottomPad = ChromePad * 2
                Case "end"
                    topPad = ChromePad * 2
                    bottomPad = 0
            End Select
    End Select

    Return CreateMap("left": leftPad, "top": topPad, "right": rightPad, "bottom": bottomPad)
End Sub

Private Sub LayoutPopup
    If ShouldPopupBeVisible = False Then
        HidePopupLayers
        Return
    End If

    EnsurePopupLayersAttached
    If pnlPopupLayer.IsInitialized = False Then Return

    SyncMenu
    Dim popupW As Int = Max(72dip, mMenu.GetPreferredWidth)
    Dim popupH As Int = Max(1dip, mMenu.GetPreferredHeight)
    Dim chromePad As Int = ResolvePopupChromePadding
    Dim triggerRect As Map = GetTriggerRectInOverlay
    Dim triggerLeft As Int = triggerRect.Get("left")
    Dim triggerTop As Int = triggerRect.Get("top")
    Dim triggerW As Int = triggerRect.Get("width")
    Dim triggerH As Int = triggerRect.Get("height")

    Dim popupLeft As Int
    Dim popupTop As Int
    Dim appliedDirection As String = msDirection
    Dim appliedPlacement As String = msPlacement

    Dim host As B4XView = ResolveOverlayHost
    If host.IsInitialized Then
        Dim candidate As Map = SelectBestPopupCandidate(triggerLeft, triggerTop, triggerW, triggerH, popupW, popupH, chromePad, GetSafeWidth(host), GetSafeHeight(host), msDirection, msPlacement)
        popupLeft = candidate.Get("left")
        popupTop = candidate.Get("top")
        appliedDirection = candidate.Get("direction")
        appliedPlacement = candidate.Get("placement")
        Log($"[DD:${mTag}] dir=${msDirection} place=${msPlacement} trigLeft=${triggerLeft} trigW=${triggerW} popupW=${popupW} chromePad=${chromePad} hostW=${GetSafeWidth(host)} ? popupLeft=${popupLeft} (trigRight=${triggerLeft+triggerW} menuRight=${popupLeft+popupW})"$)
    Else
        popupLeft = ResolvePopupLeft(triggerLeft, triggerTop, triggerW, triggerH, popupW, popupH, msDirection, msPlacement)
        popupTop = ResolvePopupTop(triggerLeft, triggerTop, triggerW, triggerH, popupW, popupH, msDirection, msPlacement)
    End If

    Dim chromeInsets As Map = ResolvePopupChromeInsets(appliedDirection, appliedPlacement, chromePad)
    Dim chromeLeft As Int = chromeInsets.Get("left")
    Dim chromeTop As Int = chromeInsets.Get("top")
    Dim chromeRight As Int = chromeInsets.Get("right")
    Dim chromeBottom As Int = chromeInsets.Get("bottom")

    Dim menuView As B4XView = mMenu.View
    Dim bNeedsCreation As Boolean = False
    If menuView.IsInitialized = False Then
        bNeedsCreation = True
    Else If menuView.Parent.IsInitialized = False Then
        bNeedsCreation = True
    End If

    If bNeedsCreation Then
        pnlPopupLayer.SetLayoutAnimated(0, popupLeft - chromeLeft, popupTop - chromeTop, popupW + chromeLeft + chromeRight, popupH + chromeTop + chromeBottom)
        mMenu.AddToParent(pnlPopupLayer, chromeLeft, chromeTop, popupW, popupH)
    Else
        pnlPopupLayer.SetLayoutAnimated(0, popupLeft - chromeLeft, popupTop - chromeTop, popupW + chromeLeft + chromeRight, popupH + chromeTop + chromeBottom)
        mMenu.SetLayoutAnimated(0, chromeLeft, chromeTop, popupW, popupH)
    End If

    LogDropdownDebugState("LayoutPopup", triggerLeft, triggerTop, popupLeft, popupTop)

    pnlOutsideCapture.Visible = ShouldUseOutsideCapture
    pnlPopupLayer.Visible = True
    If mbBringToFront Then
        mBase.BringToFront
        If pnlOutsideCapture.IsInitialized Then pnlOutsideCapture.BringToFront
        pnlPopupLayer.BringToFront
        ApplyPopupLayerElevation(pnlPopupLayer)
        If mMenu.IsInitialized And mMenu.View.IsInitialized Then mMenu.View.BringToFront
        LogDropdownDebugState("AfterBringToFront", triggerLeft, triggerTop, popupLeft, popupTop)
    End If
End Sub

Private Sub LogDropdownDebugState(Stage As String, TriggerLeft As Int, TriggerTop As Int, PopupLeft As Int, PopupTop As Int)
    #If B4A
    Try
        Dim targetRect As Map = GetTriggerRectInOverlay
        Dim targetLeft As Int = targetRect.Get("left")
        Dim targetTop As Int = targetRect.Get("top")
        Dim targetWidth As Int = targetRect.Get("width")
        Dim targetHeight As Int = targetRect.Get("height")
        Dim menuView As B4XView
        If mMenu.IsInitialized Then menuView = mMenu.View
        Log($"[DropdownDebug:${Stage}] tag=${mTag}, requestedTrigger=(${TriggerLeft},${TriggerTop}), requestedPopup=(${PopupLeft},${PopupTop}), actualTrigger=(${targetLeft},${targetTop},${targetWidth},${targetHeight}), mBase=(${SafeViewLeft(mBase)},${SafeViewTop(mBase)},${SafeViewWidth(mBase)},${SafeViewHeight(mBase)}), popupLayer=(${SafeViewLeft(pnlPopupLayer)},${SafeViewTop(pnlPopupLayer)},${SafeViewWidth(pnlPopupLayer)},${SafeViewHeight(pnlPopupLayer)}), menu=(${SafeViewLeft(menuView)},${SafeViewTop(menuView)},${SafeViewWidth(menuView)},${SafeViewHeight(menuView)})"$)
        Log($"[DropdownDebug:${Stage}:Z] targetParent=${GetViewParentSummary(mvAnchorTarget)}, baseParent=${GetViewParentSummary(mBase)}, popupParent=${GetViewParentSummary(pnlPopupLayer)}, menuParent=${GetViewParentSummary(menuView)}, targetZ=${GetViewZSummary(mvAnchorTarget)}, baseZ=${GetViewZSummary(mBase)}, popupZ=${GetViewZSummary(pnlPopupLayer)}, menuZ=${GetViewZSummary(menuView)}"$)
    Catch
        Log($"[DropdownDebug:${Stage}] logging failed for tag=${mTag}"$)
    End Try
    #End If
End Sub

Private Sub SafeViewLeft(v As B4XView) As Int
    If v.IsInitialized = False Then Return -1
    Return GetSafeLeft(v)
End Sub

Private Sub SafeViewTop(v As B4XView) As Int
    If v.IsInitialized = False Then Return -1
    Return GetSafeTop(v)
End Sub

Private Sub SafeViewWidth(v As B4XView) As Int
    If v.IsInitialized = False Then Return -1
    Return GetSafeWidth(v)
End Sub

Private Sub SafeViewHeight(v As B4XView) As Int
    If v.IsInitialized = False Then Return -1
    Return GetSafeHeight(v)
End Sub

Private Sub GetViewParentSummary(v As B4XView) As String
    If v.IsInitialized = False Then Return "no-view"
    If v.Parent.IsInitialized = False Then Return "no-parent"
    Return $"(${SafeViewLeft(v.Parent)},${SafeViewTop(v.Parent)},${SafeViewWidth(v.Parent)},${SafeViewHeight(v.Parent)})"$
End Sub

Private Sub GetViewZSummary(v As B4XView) As String
    If v.IsInitialized = False Then Return "no-view"
    #If B4A
    Try
        Dim jo As JavaObject = v
        Dim elev As Float = jo.RunMethod("getElevation", Null)
        Dim tz As Float = jo.RunMethod("getTranslationZ", Null)
        Return $"e=${NumberFormat2(elev,1,1,1,False)},tz=${NumberFormat2(tz,1,1,1,False)}"$
    Catch
        Return "z-unavailable"
    End Try
    #Else
    Return "z-n/a"
    #End If
End Sub

Private Sub SelectBestPopupCandidate(TriggerLeft As Int, TriggerTop As Int, TriggerW As Int, TriggerH As Int, PopupW As Int, PopupH As Int, ChromePad As Int, HostW As Int, HostH As Int, PreferredDirection As String, PreferredPlacement As String) As Map
    ' Always honour the requested direction and placement exactly � no auto-flip.
    ' DaisyUI CSS never auto-flips; the demo page positions triggers so the menu
    ' always has room to open in the intended direction.
    Return BuildPopupCandidate(TriggerLeft, TriggerTop, TriggerW, TriggerH, PopupW, PopupH, ChromePad, HostW, HostH, PreferredDirection, PreferredPlacement)
End Sub

Private Sub BuildPopupCandidate(TriggerLeft As Int, TriggerTop As Int, TriggerW As Int, TriggerH As Int, PopupW As Int, PopupH As Int, ChromePad As Int, HostW As Int, HostH As Int, Direction As String, Placement As String) As Map
    Dim menuLeft As Int = ResolvePopupLeft(TriggerLeft, TriggerTop, TriggerW, TriggerH, PopupW, PopupH, Direction, Placement)
    Dim menuTop As Int = ResolvePopupTop(TriggerLeft, TriggerTop, TriggerW, TriggerH, PopupW, PopupH, Direction, Placement)
    Dim chromeInsets As Map = ResolvePopupChromeInsets(Direction, Placement, ChromePad)
    Dim chromeLeft As Int = chromeInsets.Get("left")
    Dim chromeTop As Int = chromeInsets.Get("top")
    Dim chromeRight As Int = chromeInsets.Get("right")
    Dim chromeBottom As Int = chromeInsets.Get("bottom")
    Dim frameLeft As Int = menuLeft - chromeLeft
    Dim frameTop As Int = menuTop - chromeTop
    Dim frameW As Int = PopupW + chromeLeft + chromeRight
    Dim frameH As Int = PopupH + chromeTop + chromeBottom

    Dim overflowLeft As Int = Max(0, -frameLeft)
    Dim overflowTop As Int = Max(0, -frameTop)
    Dim overflowRight As Int = Max(0, (frameLeft + frameW) - HostW)
    Dim overflowBottom As Int = Max(0, (frameTop + frameH) - HostH)
    Dim totalOverflow As Long = overflowLeft + overflowTop + overflowRight + overflowBottom

    Dim clampedMenuLeft As Int = ClampPopupLeft(menuLeft, PopupW, chromeLeft, chromeRight, HostW, Direction, Placement)
    Dim clampedMenuTop As Int = ClampMenuCoordinate(menuTop, PopupH, chromeTop, chromeBottom, HostH)

    Return CreateMap( _
        "left": clampedMenuLeft, _
        "top": clampedMenuTop, _
        "direction": Direction, _
        "placement": Placement, _
        "overflow": totalOverflow)
End Sub

Private Sub ClampPopupLeft(MenuCoord As Int, MenuSize As Int, MinPad As Int, MaxPad As Int, HostSize As Int, Direction As String, Placement As String) As Int
    If (Direction = "top" Or Direction = "bottom") And Placement = "start" Then
        Return Max(0dip, MenuCoord)
    End If
    Return ClampMenuCoordinate(MenuCoord, MenuSize, MinPad, MaxPad, HostSize)
End Sub

' Sets elevation on the popup layer without setClipToOutline, so the transparent
' container does not draw a shadow of its own or clip its children.
Private Sub ApplyPopupLayerElevation(v As B4XView)
    #If B4A
    Try
        Dim e As Float = 20dip
        Dim jo As JavaObject = v
        jo.RunMethod("setElevation", Array(e))
        jo.RunMethod("setTranslationZ", Array(e))
    Catch
    End Try
    #End If
End Sub

Private Sub ClampMenuCoordinate(MenuCoord As Int, MenuSize As Int, MinPad As Int, MaxPad As Int, HostSize As Int) As Int
    Dim minCoord As Int = MinPad
    Dim maxCoord As Int = HostSize - MenuSize - MaxPad
    If maxCoord < minCoord Then
        Return Max(0dip, Min(MenuCoord, Max(0dip, HostSize - MenuSize)))
    End If
    Return Max(minCoord, Min(MenuCoord, maxCoord))
End Sub

Private Sub ResolvePopupGap As Int
    Return 4dip
End Sub

Private Sub ResolvePopupEdgeOffset As Int
    Return 0
End Sub

Private Sub ResolvePopupLeft(TriggerLeft As Int, TriggerTop As Int, TriggerW As Int, TriggerH As Int, PopupW As Int, PopupH As Int, Direction As String, Placement As String) As Int
    Dim gap As Int = ResolvePopupGap
    Dim edgeOffset As Int = ResolvePopupEdgeOffset
    Select Case Direction
        Case "left"
            Return TriggerLeft - PopupW - gap
        Case "right"
            Return TriggerLeft + TriggerW + gap
        Case Else
            Select Case Placement
                Case "center"
                    Return TriggerLeft + ((TriggerW - PopupW) / 2)
                Case "end"
                    Return TriggerLeft + TriggerW - PopupW + edgeOffset
                Case Else
                    Return TriggerLeft
            End Select
    End Select
End Sub

Private Sub ResolvePopupTop(TriggerLeft As Int, TriggerTop As Int, TriggerW As Int, TriggerH As Int, PopupW As Int, PopupH As Int, Direction As String, Placement As String) As Int
    Dim gap As Int = ResolvePopupGap
    Dim edgeOffset As Int = ResolvePopupEdgeOffset
    Select Case Direction
        Case "top"
            Return TriggerTop - PopupH - gap
        Case "bottom"
            Return TriggerTop + TriggerH + gap
        Case Else
            Select Case Placement
                Case "center"
                    Return TriggerTop + ((TriggerH - PopupH) / 2)
                Case "end"
                    Return TriggerTop + TriggerH - PopupH + edgeOffset
                Case Else
                    Return TriggerTop - edgeOffset
            End Select
    End Select
End Sub

Private Sub GetTriggerRectInOverlay As Map
    Dim host As B4XView = ResolveOverlayHost
    Dim source As B4XView = ResolveAnchorSourceView
    If source.IsInitialized = False Then
        Return CreateMap("left": 0, "top": 0, "width": 0, "height": 0)
    End If
    If host.IsInitialized = False Then Return CreateMap("left": source.Left, "top": source.Top, "width": source.Width, "height": source.Height)
    Return GetViewRectRelativeToAncestor(source, host)
End Sub

Private Sub ResolveOverlayHost As B4XView
    Dim empty As B4XView
    ' Walk up from the trigger to find the first ancestor with a real measured width.
    ' This avoids using MATCH_PARENT panels (-1) as the host for clamping calculations.
    Dim current As B4XView
    If mvAnchorTarget.IsInitialized Then
        current = mvAnchorTarget
    Else If mBase.IsInitialized Then
        current = mBase
    Else
        Return empty
    End If

    Dim iter As B4XView = current
    Do While iter.IsInitialized
        If iter.Parent.IsInitialized = False Then Exit
        iter = iter.Parent
        Dim w As Int = GetSafeWidth(iter)
        Dim h As Int = GetSafeHeight(iter)
        If w > 0 And h > 0 Then Return iter
    Loop
    Return empty
End Sub

Private Sub ResolveAnchorSourceView As B4XView
    If mvAnchorTarget.IsInitialized Then Return mvAnchorTarget
    Return mBase
End Sub

Private Sub HasAttachedTarget As Boolean
    Return mvAnchorTarget.IsInitialized
End Sub

Private Sub SyncAttachedLayout
    If HasAttachedTarget = False Then Return
    If mvAnchorTarget.Parent.IsInitialized = False Then Return

    EnsureMenu
    mMenu.BringToFront = True

    Dim host As B4XView = mvAnchorTarget.Parent
    If mBase.Parent.IsInitialized Then
        If IsSameView(mBase.Parent, host) = False Then
            mBase.RemoveViewFromParent
        End If
    End If

    Dim left As Int = GetSafeLeft(mvAnchorTarget)
    Dim top As Int = GetSafeTop(mvAnchorTarget)
    Dim width As Int = Max(1dip, GetSafeWidth(mvAnchorTarget))
    Dim height As Int = Max(1dip, GetSafeHeight(mvAnchorTarget))

    If mBase.Parent.IsInitialized = False Then
        host.AddView(mBase, left, top, width, height)
    Else
        mBase.SetLayoutAnimated(0, left, top, width, height)
    End If

    Base_Resize(width, height)
End Sub

Private Sub ClearAnchorTarget
    Dim empty As B4XView
    mvAnchorTarget = empty
End Sub

Private Sub GetSafeLeft(v As B4XView) As Int
    #If B4A
    Try
        Return v.Left
    Catch
        Dim jo As JavaObject = v
        Return jo.RunMethod("getLeft", Null)
    End Try
    #Else
    Return v.Left
    #End If
End Sub

Private Sub GetSafeTop(v As B4XView) As Int
    #If B4A
    Try
        Return v.Top
    Catch
        Dim jo As JavaObject = v
        Return jo.RunMethod("getTop", Null)
    End Try
    #Else
    Return v.Top
    #End If
End Sub

Private Sub GetSafeWidth(v As B4XView) As Int
    #If B4A
    Try
        Dim w As Int = v.Width
        If w > 0 Then Return w
        Dim jo As JavaObject = v
        Return jo.RunMethod("getWidth", Null)
    Catch
        Try
            Dim jo As JavaObject = v
            Return jo.RunMethod("getWidth", Null)
        Catch
            Return 0
        End Try
    End Try
    #Else
    Return v.Width
    #End If
End Sub

Private Sub GetSafeHeight(v As B4XView) As Int
    #If B4A
    Try
        Dim h As Int = v.Height
        If h > 0 Then Return h
        Dim jo As JavaObject = v
        Return jo.RunMethod("getHeight", Null)
    Catch
        Try
            Dim jo As JavaObject = v
            Return jo.RunMethod("getHeight", Null)
        Catch
            Return 0
        End Try
    End Try
    #Else
    Return v.Height
    #End If
End Sub

Private Sub GetViewRectRelativeToAncestor(Target As B4XView, Ancestor As B4XView) As Map
    If Target.IsInitialized = False Then Return CreateMap("left": 0, "top": 0, "width": 0, "height": 0)
    Dim left As Int = 0
    Dim top As Int = 0
    Dim current As B4XView = Target
    Do While current.IsInitialized
        If current = Ancestor Then Exit
        left = left + GetSafeLeft(current)
        top = top + GetSafeTop(current)
        If current.Parent.IsInitialized = False Then Exit
        current = current.Parent
    Loop
    Return CreateMap("left": left, "top": top, "width": GetSafeWidth(Target), "height": GetSafeHeight(Target))
End Sub

Private Sub ShouldPopupBeVisible As Boolean
    If mbVisible = False Then Return False
    If mbForceClose Then Return False
    If mbForceOpen Then Return True
    Return mbOpen
End Sub

Private Sub IsSameView(View1 As B4XView, View2 As B4XView) As Boolean
    If View1.IsInitialized = False Or View2.IsInitialized = False Then Return View1.IsInitialized = View2.IsInitialized
    #If B4A
    Try
        Dim jo1 As JavaObject = View1
        Dim jo2 As JavaObject = View2
        Return jo1.RunMethod("equals", Array(jo2))
    Catch
        Return View1 = View2
    End Try
    #Else
    Return View1 = View2
    #End If
End Sub

Private Sub ShouldUseOutsideCapture As Boolean
    If ShouldPopupBeVisible = False Then Return False
    If mbForceOpen Then Return False
    Return True
End Sub

Private Sub ResolveBaseWidth(RequestedWidth As Int) As Int
    If RequestedWidth > 0 Then Return Max(1dip, RequestedWidth)
    Return 1dip
End Sub

Private Sub ResolveBaseHeight(RequestedHeight As Int) As Int
    If RequestedHeight > 0 Then Return Max(1dip, RequestedHeight)
    Return 1dip
End Sub

Private Sub NormalizePlacement(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "start"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "start", "center", "end"
            Return s
        Case Else
            Return "start"
    End Select
End Sub

Private Sub NormalizeDirection(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "bottom"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "top", "bottom", "left", "right"
            Return s
        Case Else
            Return "bottom"
    End Select
End Sub

Private Sub NormalizeSizeSpec(Value As String, DefaultValue As String) As String
    Dim s As String = Value
    If s = Null Then s = ""
    s = s.Trim
    If s.Length = 0 Then Return DefaultValue
    Return s
End Sub

Public Sub Open
    SetRequestedOpenState(True, True)
End Sub

Public Sub Close
    SetRequestedOpenState(False, True)
End Sub

Public Sub Toggle
    If mbForceOpen Or mbForceClose Then Return
    SetRequestedOpenState(Not(mbOpen), True)
End Sub

Private Sub SetRequestedOpenState(Value As Boolean, RaiseEvents As Boolean)
    If mbForceOpen Or mbForceClose Then
        Refresh
        Return
    End If
    If mbOpen = Value Then
        Refresh
        Return
    End If
    mbOpen = Value
    If Value = False And mMenu.IsInitialized Then mMenu.ClearActive
    Refresh
    If RaiseEvents = False Then Return
    If Value Then
        If xui.SubExists(mCallBack, mEventName & "_Opened", 0) Then
            CallSub(mCallBack, mEventName & "_Opened")
        End If
    Else
        If xui.SubExists(mCallBack, mEventName & "_Closed", 0) Then
            CallSub(mCallBack, mEventName & "_Closed")
        End If
    End If
End Sub

Public Sub AddTitle(Text As String) As Int
    EnsureMenu
    Return mMenu.AddTitle(Text)
End Sub

Public Sub AddDivider As Int
    EnsureMenu
    Return mMenu.AddDivider
End Sub

Public Sub AddItem(TagValue As Object, Text As String) As Int
    EnsureMenu
    Return mMenu.AddItem(TagValue, Text)
End Sub

Public Sub AddIconItem(TagValue As Object, Text As String, IconName As String) As Int
    EnsureMenu
    Return mMenu.AddIconItem(TagValue, Text, IconName)
End Sub

Public Sub AddBadgeItem(TagValue As Object, Text As String, BadgeText As String, BadgeVariant As String) As Int
    EnsureMenu
    Return mMenu.AddBadgeItem(TagValue, Text, BadgeText, BadgeVariant)
End Sub

Public Sub AddIconBadgeItem(TagValue As Object, Text As String, IconName As String, BadgeText As String, BadgeVariant As String) As Int
    EnsureMenu
    Return mMenu.AddIconBadgeItem(TagValue, Text, IconName, BadgeText, BadgeVariant)
End Sub

Public Sub AddSubmenu(TagValue As Object, Text As String, InitiallyOpen As Boolean) As B4XDaisyMenu
    EnsureMenu
    Return mMenu.AddSubmenu(TagValue, Text, InitiallyOpen)
End Sub

Public Sub SetItemDisabled(TagValue As Object, Value As Boolean)
    EnsureMenu
    mMenu.SetItemDisabled(TagValue, Value)
End Sub

Public Sub getMenu As B4XDaisyMenu
    EnsureMenu
    Return mMenu
End Sub

Public Sub SetItemActive(TagValue As Object, Value As Boolean)
    EnsureMenu
    mMenu.SetItemActive(TagValue, Value)
End Sub

Public Sub SetItemText(TagValue As Object, Value As String)
    EnsureMenu
    mMenu.SetItemText(TagValue, Value)
End Sub

Public Sub SetItemIcon(TagValue As Object, IconName As String)
    EnsureMenu
    mMenu.SetItemIcon(TagValue, IconName)
End Sub

Public Sub SetItemVisible(TagValue As Object, Value As Boolean)
    EnsureMenu
    mMenu.SetItemVisible(TagValue, Value)
End Sub

Public Sub ScrollToItem(TagValue As Object)
    EnsureMenu
    mMenu.ScrollToItem(TagValue)
End Sub

Public Sub SetSubmenuOpen(Index As Int, Value As Boolean)
    EnsureMenu
    mMenu.SetSubmenuOpen(Index, Value)
End Sub

Public Sub SetItemBadgeText(TagValue As Object, Value As String)
    EnsureMenu
    mMenu.SetItemBadgeText(TagValue, Value)
End Sub

Public Sub SetItemBadgeBackgroundColor(TagValue As Object, Color As Int)
    EnsureMenu
    mMenu.SetItemBadgeBackgroundColor(TagValue, Color)
End Sub

Public Sub SetItemBadgeTextColor(TagValue As Object, Color As Int)
    EnsureMenu
    mMenu.SetItemBadgeTextColor(TagValue, Color)
End Sub

Public Sub GetPreferredWidth As Int
If mBase.IsInitialized Then Return Max(1dip, mBase.Width)
    Return 0
End Sub

Public Sub GetPreferredHeight As Int
If mBase.IsInitialized Then Return Max(1dip, mBase.Height)
    Return 0
End Sub

Public Sub GetPreferredMenuWidth As Int
    EnsureMenu
    SyncMenu
    Return mMenu.GetPreferredWidth
End Sub

Public Sub GetPreferredMenuHeight As Int
    EnsureMenu
    SyncMenu
    Return mMenu.GetPreferredHeight
End Sub

Public Sub AttachTo(Target As B4XView) As B4XView
    Dim empty As B4XView
    If Target.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim baseView As B4XView = p
        baseView.Color = xui.Color_Transparent
        baseView.SetLayoutAnimated(0, 0, 0, Max(1dip, Target.Width), Max(1dip, Target.Height))
        Dim dummy As Label
        DesignerCreateView(baseView, dummy, BuildRuntimeProps)
    End If

    EnsureMenu
    mMenu.BringToFront = True
    mvAnchorTarget = Target
    SyncAttachedLayout
    Refresh
    Return mBase
End Sub

Public Sub Detach
    HidePopupLayers
    ClearAnchorTarget
    If mBase.IsInitialized And mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    EnsureMenu
    mMenu.UpdateTheme
    Refresh
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
    HidePopupLayers
    ClearAnchorTarget
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
    If mBase.IsInitialized = False Then Return
    mBase.Left = Value
    LayoutPopup
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized Then Return mBase.Left
    Return 0
End Sub

Public Sub setTop(Value As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Top = Value
    LayoutPopup
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized Then Return mBase.Top
    Return 0
End Sub

Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mbVisible = Value
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setOpen(Value As Boolean)
    SetRequestedOpenState(Value, False)
End Sub

Public Sub getOpen As Boolean
    Return mbOpen
End Sub

Public Sub setPlacement(Value As String)
    msPlacement = NormalizePlacement(Value)
    Refresh
End Sub

Public Sub getPlacement As String
    Return msPlacement
End Sub

Public Sub setDirection(Value As String)
    msDirection = NormalizeDirection(Value)
    Refresh
End Sub

Public Sub getDirection As String
    Return msDirection
End Sub

Public Sub setHoverOpen(Value As Boolean)
    mbHoverOpen = Value
    Refresh
End Sub

Public Sub getHoverOpen As Boolean
    Return mbHoverOpen
End Sub

Public Sub setForceOpen(Value As Boolean)
    mbForceOpen = Value
    If Value Then 
        mbForceClose = False
    End If
    Refresh
End Sub

Public Sub getForceOpen As Boolean
    Return mbForceOpen
End Sub

Public Sub setForceClose(Value As Boolean)
    mbForceClose = Value
    If Value Then 
        mbForceOpen = False
    End If
    Refresh
End Sub

Public Sub getForceClose As Boolean
    Return mbForceClose
End Sub

Public Sub setAnchorTarget(Value As B4XView)
    If Value.IsInitialized = False Then
        Detach
        Return
    End If
    AttachTo(Value)
End Sub

Public Sub getAnchorTarget As B4XView
    Return mvAnchorTarget
End Sub

Public Sub getAttachedMode As Boolean
    Return HasAttachedTarget
End Sub

Public Sub setMenuWidth(Value As String)
    msMenuWidth = NormalizeSizeSpec(Value, "w-52")
    Refresh
End Sub

Public Sub getMenuWidth As String
    Return msMenuWidth
End Sub

Public Sub setMenuPadding(Value As String)
    If Value = Null Then
        msMenuPadding = ""
    Else
        msMenuPadding = Value
    End If
    Refresh
End Sub

Public Sub getMenuPadding As String
    Return msMenuPadding
End Sub

Public Sub setMenuRounded(Value As String)
    msMenuRounded = B4XDaisyVariants.NormalizeRounded(Value)
    Refresh
End Sub

Public Sub getMenuRounded As String
    Return msMenuRounded
End Sub

Public Sub setMenuShadow(Value As String)
    msMenuShadow = B4XDaisyVariants.NormalizeShadow(Value)
    Refresh
End Sub

Public Sub getMenuShadow As String
    Return msMenuShadow
End Sub

Public Sub setBringToFront(Value As Boolean)
    mbBringToFront = Value
    Refresh
End Sub

Public Sub getBringToFront As Boolean
    Return mbBringToFront
End Sub

Public Sub setMenuBackgroundColor(Value As Int)
    mcMenuBackgroundColor = Value
    Refresh
End Sub

Public Sub getMenuBackgroundColor As Int
    Return mcMenuBackgroundColor
End Sub

Public Sub setMenuTextColor(Value As Int)
    mcMenuTextColor = Value
    Refresh
End Sub

Public Sub getMenuTextColor As Int
    Return mcMenuTextColor
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Private Sub ddcapture_Click
    RaiseTriggerClick
End Sub

Private Sub ddcapture_LongClick
    If mbEnabled = False Or mbForceOpen Or mbForceClose Then Return
    If mbHoverOpen Then Open
End Sub

Private Sub RaiseTriggerClick
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", mTag)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If

    If mbEnabled = False Then Return
    If mbForceOpen Or mbForceClose Then Return
    Toggle
End Sub

Private Sub ddoutside_Click
    If mbForceOpen Then Return
    Close
End Sub

Private Sub ddmenu_ItemClick(Tag As Object, Text As String)
    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 2) Then
        CallSub3(mCallBack, mEventName & "_ItemClick", Tag, Text)
    End If
    If mbForceOpen = False Then Close
End Sub

Private Sub ddmenu_SubmenuToggle(Tag As Object, IsOpen As Boolean)
    If xui.SubExists(mCallBack, mEventName & "_SubmenuToggle", 2) Then
        CallSub3(mCallBack, mEventName & "_SubmenuToggle", Tag, IsOpen)
    End If
End Sub
