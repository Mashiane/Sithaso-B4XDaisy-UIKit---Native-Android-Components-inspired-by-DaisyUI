B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Event: Click (Tag As Object)
#Event: ItemClick (Tag As Object, Text As String)
#Event: SubmenuToggle (Tag As Object, IsOpen As Boolean)
#Event: Opened
#Event: Closed

#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables dropdown interactions.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the dropdown.
#DesignerProperty: Key: Opened, DisplayName: Opened, FieldType: Boolean, DefaultValue: False, Description: Initial open state.
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
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    EnsureCaptureLayer
    EnsureMenu
    ApplyDesignerProps(mProps)
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

Private Sub ApplyDesignerProps(mProps As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    mbOpen = B4XDaisyVariants.GetPropBool(mProps, "Open", mbOpen)
    msPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(mProps, "Placement", msPlacement))
    msDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(mProps, "Direction", msDirection))
    mbHoverOpen = B4XDaisyVariants.GetPropBool(mProps, "HoverOpen", mbHoverOpen)
    mbForceOpen = B4XDaisyVariants.GetPropBool(mProps, "ForceOpen", mbForceOpen)
    mbForceClose = B4XDaisyVariants.GetPropBool(mProps, "ForceClose", mbForceClose)
    msMenuWidth = NormalizeSizeSpec(B4XDaisyVariants.GetPropString(mProps, "MenuWidth", msMenuWidth), "w-52")
    msMenuPadding = B4XDaisyVariants.GetPropString(mProps, "MenuPadding", msMenuPadding)
    msMenuRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "MenuRounded", msMenuRounded))
    msMenuShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "MenuShadow", msMenuShadow))
    mbBringToFront = B4XDaisyVariants.GetPropBool(mProps, "BringToFront", mbBringToFront)
    mcMenuBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "MenuBackgroundColor", mcMenuBackgroundColor)
    mcMenuTextColor = B4XDaisyVariants.GetPropColor(mProps, "MenuTextColor", mcMenuTextColor)
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    Dim empty As B4XView
    If vParent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim baseView As B4XView = p
        baseView.Color = xui.Color_Transparent
        baseView.SetLayoutAnimated(0, 0, 0, Max(1dip, ResolveBaseWidth(iWidth)), Max(1dip, ResolveBaseHeight(iHeight)))
        Dim dummy As Label
        DesignerCreateView(baseView, dummy, BuildRuntimeProps)
    End If

    ClearAnchorTarget
    Dim targetW As Int = ResolveBaseWidth(iWidth)
    Dim targetH As Int = ResolveBaseHeight(iHeight)
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
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

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    EnsureCaptureLayer
    EnsureMenu

    Dim targetW As Int = Max(1dip, dWidth)
    Dim targetH As Int = Max(1dip, dHeight)
    pnlTriggerCapture.SetLayoutAnimated(0, 0, 0, targetW, targetH)
    pnlTriggerCapture.Visible = mbVisible
    pnlTriggerCapture.Enabled = mbEnabled
    ' Disabled: dim the trigger so it reads as inactive (open is already blocked).
    pnlTriggerCapture.Alpha = IIf(mbEnabled, 1.0, 0.3)
    pnlTriggerCapture.BringToFront
    B4XDaisyVariants.ApplyElevation(mBase, "2xl")
    B4XDaisyVariants.ApplyElevation(pnlTriggerCapture, "2xl")
    LayoutPopup
    inResize = False
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
    ' Disabled: dim the trigger so it reads as inactive (open is already blocked).
    pnlTriggerCapture.Alpha = IIf(mbEnabled, 1.0, 0.3)

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

Private Sub ResolvePopupChromeInsets(sDirection As String, sPlacement As String, iChromePad As Int) As Map
    Dim leftPad As Int = iChromePad
    Dim topPad As Int = iChromePad
    Dim rightPad As Int = iChromePad
    Dim bottomPad As Int = iChromePad

    Select Case sDirection
        Case "top", "bottom"
            Select Case sPlacement
                Case "start"
                    leftPad = 0
                    rightPad = iChromePad * 2
                Case "end"
                    leftPad = iChromePad * 2
                    rightPad = 0
            End Select
        Case Else
            Select Case sPlacement
                Case "start"
                    topPad = 0
                    bottomPad = iChromePad * 2
                Case "end"
                    topPad = iChromePad * 2
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
        ' Log($"[DD:${mTag}] dir=${msDirection} place=${msPlacement} trigLeft=${triggerLeft} trigW=${triggerW} popupW=${popupW} chromePad=${chromePad} hostW=${GetSafeWidth(host)} ? popupLeft=${popupLeft} (trigRight=${triggerLeft+triggerW} menuRight=${popupLeft+popupW})"$)
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

    pnlOutsideCapture.Visible = ShouldUseOutsideCapture
    pnlPopupLayer.Visible = True
    If mbBringToFront Then
        mBase.BringToFront
        If pnlOutsideCapture.IsInitialized Then pnlOutsideCapture.BringToFront
        pnlPopupLayer.BringToFront
        ApplyPopupLayerElevation(pnlPopupLayer)
        If mMenu.IsInitialized And mMenu.View.IsInitialized Then mMenu.View.BringToFront
    End If
End Sub

Private Sub SafeViewLeft(vView As B4XView) As Int
    If vView.IsInitialized = False Then Return -1
    Return GetSafeLeft(vView)
End Sub

Private Sub SafeViewTop(vView As B4XView) As Int
    If vView.IsInitialized = False Then Return -1
    Return GetSafeTop(vView)
End Sub

Private Sub SafeViewWidth(vView As B4XView) As Int
    If vView.IsInitialized = False Then Return -1
    Return GetSafeWidth(vView)
End Sub

Private Sub SafeViewHeight(vView As B4XView) As Int
    If vView.IsInitialized = False Then Return -1
    Return GetSafeHeight(vView)
End Sub

Private Sub SelectBestPopupCandidate(iTriggerLeft As Int, iTriggerTop As Int, iTriggerW As Int, iTriggerH As Int, iPopupW As Int, iPopupH As Int, iChromePad As Int, iHostW As Int, iHostH As Int, sPreferredDirection As String, sPreferredPlacement As String) As Map
    ' Always honour the requested direction and placement exactly - no auto-flip.
    ' DaisyUI CSS never auto-flips; the demo page positions triggers so the menu
    ' always has room to open in the intended direction.
    Return BuildPopupCandidate(iTriggerLeft, iTriggerTop, iTriggerW, iTriggerH, iPopupW, iPopupH, iChromePad, iHostW, iHostH, sPreferredDirection, sPreferredPlacement)
End Sub

Private Sub BuildPopupCandidate(iTriggerLeft As Int, iTriggerTop As Int, iTriggerW As Int, iTriggerH As Int, iPopupW As Int, iPopupH As Int, iChromePad As Int, iHostW As Int, iHostH As Int, sDirection As String, sPlacement As String) As Map
    Dim menuLeft As Int = ResolvePopupLeft(iTriggerLeft, iTriggerTop, iTriggerW, iTriggerH, iPopupW, iPopupH, sDirection, sPlacement)
    Dim menuTop As Int = ResolvePopupTop(iTriggerLeft, iTriggerTop, iTriggerW, iTriggerH, iPopupW, iPopupH, sDirection, sPlacement)
    Dim chromeInsets As Map = ResolvePopupChromeInsets(sDirection, sPlacement, iChromePad)
    Dim chromeLeft As Int = chromeInsets.Get("left")
    Dim chromeTop As Int = chromeInsets.Get("top")
    Dim chromeRight As Int = chromeInsets.Get("right")
    Dim chromeBottom As Int = chromeInsets.Get("bottom")
    Dim frameLeft As Int = menuLeft - chromeLeft
    Dim frameTop As Int = menuTop - chromeTop
    Dim frameW As Int = iPopupW + chromeLeft + chromeRight
    Dim frameH As Int = iPopupH + chromeTop + chromeBottom

    Dim overflowLeft As Int = Max(0, -frameLeft)
    Dim overflowTop As Int = Max(0, -frameTop)
    Dim overflowRight As Int = Max(0, (frameLeft + frameW) - iHostW)
    Dim overflowBottom As Int = Max(0, (frameTop + frameH) - iHostH)
    Dim totalOverflow As Long = overflowLeft + overflowTop + overflowRight + overflowBottom

    Dim clampedMenuLeft As Int = ClampPopupLeft(menuLeft, iPopupW, chromeLeft, chromeRight, iHostW, sDirection, sPlacement)
    Dim clampedMenuTop As Int = ClampMenuCoordinate(menuTop, iPopupH, chromeTop, chromeBottom, iHostH)

    Return CreateMap( _
        "left": clampedMenuLeft, _
        "top": clampedMenuTop, _
        "direction": sDirection, _
        "placement": sPlacement, _
        "overflow": totalOverflow)
End Sub

Private Sub ClampPopupLeft(iMenuCoord As Int, iMenuSize As Int, iMinPad As Int, iMaxPad As Int, iHostSize As Int, sDirection As String, sPlacement As String) As Int
    If (sDirection = "top" Or sDirection = "bottom") And sPlacement = "start" Then
        Return Max(0dip, iMenuCoord)
    End If
    Return ClampMenuCoordinate(iMenuCoord, iMenuSize, iMinPad, iMaxPad, iHostSize)
End Sub

' Sets elevation on the popup layer without setClipToOutline, so the transparent
' container does not draw a shadow of its own or clip its children.
Private Sub ApplyPopupLayerElevation(vView As B4XView)
    #If B4A
    Try
        Dim e As Float = 20dip
        Dim jo As JavaObject = vView
        jo.RunMethod("setElevation", Array(e))
        jo.RunMethod("setTranslationZ", Array(e))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyDropdown.ApplyPopupLayerElevation: " & LastException.Message)
    End Try
    #End If
End Sub

Private Sub ClampMenuCoordinate(iMenuCoord As Int, iMenuSize As Int, iMinPad As Int, iMaxPad As Int, iHostSize As Int) As Int
    Dim minCoord As Int = iMinPad
    Dim maxCoord As Int = iHostSize - iMenuSize - iMaxPad
    If maxCoord < minCoord Then
        Return Max(0dip, Min(iMenuCoord, Max(0dip, iHostSize - iMenuSize)))
    End If
    Return Max(minCoord, Min(iMenuCoord, maxCoord))
End Sub

Private Sub ResolvePopupGap As Int
    Return 4dip
End Sub

Private Sub ResolvePopupEdgeOffset As Int
    Return 0
End Sub

Private Sub ResolvePopupLeft(iTriggerLeft As Int, iTriggerTop As Int, iTriggerW As Int, iTriggerH As Int, iPopupW As Int, iPopupH As Int, sDirection As String, sPlacement As String) As Int
    Dim gap As Int = ResolvePopupGap
    Dim edgeOffset As Int = ResolvePopupEdgeOffset
    Select Case sDirection
        Case "left"
            Return iTriggerLeft - iPopupW - gap
        Case "right"
            Return iTriggerLeft + iTriggerW + gap
        Case Else
            Select Case sPlacement
                Case "center"
                    Return iTriggerLeft + ((iTriggerW - iPopupW) / 2)
                Case "end"
                    Return iTriggerLeft + iTriggerW - iPopupW + edgeOffset
                Case Else
                    Return iTriggerLeft
            End Select
    End Select
End Sub

Private Sub ResolvePopupTop(iTriggerLeft As Int, iTriggerTop As Int, iTriggerW As Int, iTriggerH As Int, iPopupW As Int, iPopupH As Int, sDirection As String, sPlacement As String) As Int
    Dim gap As Int = ResolvePopupGap
    Dim edgeOffset As Int = ResolvePopupEdgeOffset
    Select Case sDirection
        Case "top"
            Return iTriggerTop - iPopupH - gap
        Case "bottom"
            Return iTriggerTop + iTriggerH + gap
        Case Else
            Select Case sPlacement
                Case "center"
                    Return iTriggerTop + ((iTriggerH - iPopupH) / 2)
                Case "end"
                    Return iTriggerTop + iTriggerH - iPopupH + edgeOffset
                Case Else
                    Return iTriggerTop - edgeOffset
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

Private Sub GetSafeLeft(vView As B4XView) As Int
    #If B4A
    Try
        Return vView.Left
    Catch
        Dim jo As JavaObject = vView
        Return jo.RunMethod("getLeft", Null)
    End Try
    #Else
    Return vView.Left
    #End If
End Sub

Private Sub GetSafeTop(vView As B4XView) As Int
    #If B4A
    Try
        Return vView.Top
    Catch
        Dim jo As JavaObject = vView
        Return jo.RunMethod("getTop", Null)
    End Try
    #Else
    Return vView.Top
    #End If
End Sub

Private Sub GetSafeWidth(vView As B4XView) As Int
    #If B4A
    Try
        Dim w As Int = vView.Width
        If w > 0 Then Return w
        Dim jo As JavaObject = vView
        Return jo.RunMethod("getWidth", Null)
    Catch
        Try
            Dim jo As JavaObject = vView
            Return jo.RunMethod("getWidth", Null)
        Catch
            Return 0
        End Try
    End Try
    #Else
    Return vView.Width
    #End If
End Sub

Private Sub GetSafeHeight(vView As B4XView) As Int
    #If B4A
    Try
        Dim h As Int = vView.Height
        If h > 0 Then Return h
        Dim jo As JavaObject = vView
        Return jo.RunMethod("getHeight", Null)
    Catch
        Try
            Dim jo As JavaObject = vView
            Return jo.RunMethod("getHeight", Null)
        Catch
            Return 0
        End Try
    End Try
    #Else
    Return vView.Height
    #End If
End Sub

Private Sub GetViewRectRelativeToAncestor(vTarget As B4XView, vAncestor As B4XView) As Map
    If vTarget.IsInitialized = False Then Return CreateMap("left": 0, "top": 0, "width": 0, "height": 0)
    Dim left As Int = 0
    Dim top As Int = 0
    Dim current As B4XView = vTarget
    Do While current.IsInitialized
        If current = vAncestor Then Exit
        left = left + GetSafeLeft(current)
        top = top + GetSafeTop(current)
        If current.Parent.IsInitialized = False Then Exit
        current = current.Parent
    Loop
    Return CreateMap("left": left, "top": top, "width": GetSafeWidth(vTarget), "height": GetSafeHeight(vTarget))
End Sub

Private Sub ShouldPopupBeVisible As Boolean
    If mbVisible = False Then Return False
    If mbForceClose Then Return False
    If mbForceOpen Then Return True
	Return mbOpen
End Sub

Private Sub IsSameView(vView1 As B4XView, vView2 As B4XView) As Boolean
	If vView1.IsInitialized = False Or vView2.IsInitialized = False Then Return vView1.IsInitialized = vView2.IsInitialized
    #If B4A
	Try
		Dim jo1 As JavaObject = vView1
		Dim jo2 As JavaObject = vView2
		Dim id1 As Int = jo1.RunMethod("hashCode", Null)
		Dim id2 As Int = jo2.RunMethod("hashCode", Null)
		Return id1 = id2
	Catch
		Return False
	End Try
    #Else
        Return vView1 = vView2
    #End If
End Sub

Private Sub ShouldUseOutsideCapture As Boolean
    If ShouldPopupBeVisible = False Then Return False
    If mbForceOpen Then Return False
    Return True
End Sub

Private Sub ResolveBaseWidth(iRequestedWidth As Int) As Int
    If iRequestedWidth > 0 Then Return Max(1dip, iRequestedWidth)
    Return 1dip
End Sub

Private Sub ResolveBaseHeight(iRequestedHeight As Int) As Int
    If iRequestedHeight > 0 Then Return Max(1dip, iRequestedHeight)
    Return 1dip
End Sub

Private Sub NormalizePlacement(sValue As String) As String
    Dim rawValue As String = sValue
    If rawValue = Null Then rawValue = "start"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "start", "center", "end"
            Return s
        Case Else
            Return "start"
    End Select
End Sub

Private Sub NormalizeDirection(sValue As String) As String
    Dim rawValue As String = sValue
    If rawValue = Null Then rawValue = "bottom"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "top", "bottom", "left", "right"
            Return s
        Case Else
            Return "bottom"
    End Select
End Sub

Private Sub NormalizeSizeSpec(sValue As String, sDefaultValue As String) As String
    Dim s As String = sValue
    If s = Null Then s = ""
    s = s.Trim
    If s.Length = 0 Then Return sDefaultValue
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

Private Sub SetRequestedOpenState(bValue As Boolean, bRaiseEvents As Boolean)
    If mbForceOpen Or mbForceClose Then
        Refresh
        Return
    End If
    If mbOpen = bValue Then
        Refresh
        Return
    End If
    mbOpen = bValue
    If bValue = False And mMenu.IsInitialized Then mMenu.ClearActive
    Refresh
    If bRaiseEvents = False Then Return
    If bValue Then
        If xui.SubExists(mCallBack, mEventName & "_Opened", 0) Then
            CallSub(mCallBack, mEventName & "_Opened")
        End If
    Else
        If xui.SubExists(mCallBack, mEventName & "_Closed", 0) Then
            CallSub(mCallBack, mEventName & "_Closed")
        End If
    End If
End Sub

Public Sub AddTitle(sText As String) As Int
    EnsureMenu
    Return mMenu.AddTitle(sText)
End Sub

Public Sub AddDivider As Int
    EnsureMenu
    Return mMenu.AddDivider
End Sub

Public Sub AddItem(oTagValue As Object, sText As String) As Int
    EnsureMenu
    Return mMenu.AddItem(oTagValue, sText)
End Sub

Public Sub AddIconItem(oTagValue As Object, sText As String, sIconName As String) As Int
    EnsureMenu
    Return mMenu.AddIconItem(oTagValue, sText, sIconName)
End Sub

Public Sub AddBadgeItem(oTagValue As Object, sText As String, sBadgeText As String, sBadgeVariant As String) As Int
    EnsureMenu
    Return mMenu.AddBadgeItem(oTagValue, sText, sBadgeText, sBadgeVariant)
End Sub

Public Sub AddIconBadgeItem(oTagValue As Object, sText As String, sIconName As String, sBadgeText As String, sBadgeVariant As String) As Int
    EnsureMenu
    Return mMenu.AddIconBadgeItem(oTagValue, sText, sIconName, sBadgeText, sBadgeVariant)
End Sub

Public Sub AddSubmenu(oTagValue As Object, sText As String, bInitiallyOpen As Boolean) As B4XDaisyMenu
    EnsureMenu
    Return mMenu.AddSubmenu(oTagValue, sText, bInitiallyOpen)
End Sub

Public Sub SetItemDisabled(oTagValue As Object, bValue As Boolean)
    EnsureMenu
    mMenu.SetItemDisabled(oTagValue, bValue)
End Sub

Public Sub getMenu As B4XDaisyMenu
    EnsureMenu
    Return mMenu
End Sub

Public Sub SetItemActive(oTagValue As Object, bValue As Boolean)
    EnsureMenu
    mMenu.SetItemActive(oTagValue, bValue)
End Sub

Public Sub SetItemText(oTagValue As Object, sValue As String)
    EnsureMenu
    mMenu.SetItemText(oTagValue, sValue)
End Sub

Public Sub SetItemIcon(oTagValue As Object, sIconName As String)
    EnsureMenu
    mMenu.SetItemIcon(oTagValue, sIconName)
End Sub

Public Sub SetItemVisible(oTagValue As Object, bValue As Boolean)
    EnsureMenu
    mMenu.SetItemVisible(oTagValue, bValue)
End Sub

Public Sub ScrollToItem(oTagValue As Object)
    EnsureMenu
    mMenu.ScrollToItem(oTagValue)
End Sub

Public Sub SetSubmenuOpen(iIndex As Int, bValue As Boolean)
    EnsureMenu
    mMenu.SetSubmenuOpen(iIndex, bValue)
End Sub

Public Sub SetItemBadgeText(oTagValue As Object, sValue As String)
    EnsureMenu
    mMenu.SetItemBadgeText(oTagValue, sValue)
End Sub

Public Sub SetItemBadgeBackgroundColor(oTagValue As Object, iColor As Int)
    EnsureMenu
    mMenu.SetItemBadgeBackgroundColor(oTagValue, iColor)
End Sub

Public Sub SetItemBadgeTextColor(oTagValue As Object, iColor As Int)
    EnsureMenu
    mMenu.SetItemBadgeTextColor(oTagValue, iColor)
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

Public Sub AttachTo(vTarget As B4XView) As B4XView
    Dim empty As B4XView
    If vTarget.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim baseView As B4XView = p
        baseView.Color = xui.Color_Transparent
        baseView.SetLayoutAnimated(0, 0, 0, Max(1dip, vTarget.Width), Max(1dip, vTarget.Height))
        Dim dummy As Label
        DesignerCreateView(baseView, dummy, BuildRuntimeProps)
    End If

    EnsureMenu
    mMenu.BringToFront = True
    mvAnchorTarget = vTarget
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
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    Base_Resize(Max(1dip, iWidth), Max(1dip, iHeight))
    Refresh
End Sub

Public Sub setLeft(iValue As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Left = iValue
    LayoutPopup
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized Then Return mBase.Left
    Return 0
End Sub

Public Sub setTop(iValue As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Top = iValue
    LayoutPopup
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized Then Return mBase.Top
    Return 0
End Sub

Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setOpened(bValue As Boolean)
    SetRequestedOpenState(bValue, False)
End Sub

Public Sub getOpened As Boolean
    Return mbOpen
End Sub

Public Sub setPlacement(sValue As String)
    msPlacement = NormalizePlacement(sValue)
    Refresh
End Sub

Public Sub getPlacement As String
    Return msPlacement
End Sub

Public Sub setDirection(sValue As String)
    msDirection = NormalizeDirection(sValue)
    Refresh
End Sub

Public Sub getDirection As String
    Return msDirection
End Sub

Public Sub setHoverOpen(bValue As Boolean)
    mbHoverOpen = bValue
    Refresh
End Sub

Public Sub getHoverOpen As Boolean
    Return mbHoverOpen
End Sub

Public Sub setForceOpen(bValue As Boolean)
    mbForceOpen = bValue
    If bValue Then 
        mbForceClose = False
    End If
    Refresh
End Sub

Public Sub getForceOpen As Boolean
    Return mbForceOpen
End Sub

Public Sub setForceClose(bValue As Boolean)
    mbForceClose = bValue
    If bValue Then 
        mbForceOpen = False
    End If
    Refresh
End Sub

Public Sub getForceClose As Boolean
    Return mbForceClose
End Sub

Public Sub setAnchorTarget(vValue As B4XView)
    If vValue.IsInitialized = False Then
        Detach
        Return
    End If
    AttachTo(vValue)
End Sub

Public Sub getAnchorTarget As B4XView
    Return mvAnchorTarget
End Sub

Public Sub getAttachedMode As Boolean
    Return HasAttachedTarget
End Sub

Public Sub setMenuWidth(sValue As String)
    msMenuWidth = NormalizeSizeSpec(sValue, "w-52")
    Refresh
End Sub

Public Sub getMenuWidth As String
    Return msMenuWidth
End Sub

Public Sub setMenuPadding(sValue As String)
    If sValue = Null Then
        msMenuPadding = ""
    Else
        msMenuPadding = sValue
    End If
    Refresh
End Sub

Public Sub getMenuPadding As String
    Return msMenuPadding
End Sub

Public Sub setMenuRounded(sValue As String)
    msMenuRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    Refresh
End Sub

Public Sub getMenuRounded As String
    Return msMenuRounded
End Sub

Public Sub setMenuShadow(sValue As String)
    msMenuShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    Refresh
End Sub

Public Sub getMenuShadow As String
    Return msMenuShadow
End Sub

Public Sub setBringToFront(bValue As Boolean)
    mbBringToFront = bValue
    Refresh
End Sub

Public Sub getBringToFront As Boolean
    Return mbBringToFront
End Sub

Public Sub setMenuBackgroundColor(iValue As Int)
    mcMenuBackgroundColor = iValue
    Refresh
End Sub

Public Sub getMenuBackgroundColor As Int
    Return mcMenuBackgroundColor
End Sub

Public Sub setMenuTextColor(iValue As Int)
    mcMenuTextColor = iValue
    Refresh
End Sub

Public Sub getMenuTextColor As Int
    Return mcMenuTextColor
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
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

Private Sub ddmenu_ItemClick(oTag As Object, sText As String)
    If xui.SubExists(mCallBack, mEventName & "_ItemClick", 2) Then
        CallSub3(mCallBack, mEventName & "_ItemClick", oTag, sText)
    End If
    If mbForceOpen = False Then Close
End Sub

Private Sub ddmenu_SubmenuToggle(oTag As Object, bIsOpen As Boolean)
    If xui.SubExists(mCallBack, mEventName & "_SubmenuToggle", 2) Then
        CallSub3(mCallBack, mEventName & "_SubmenuToggle", oTag, bIsOpen)
    End If
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
