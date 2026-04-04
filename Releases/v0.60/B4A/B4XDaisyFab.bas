B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12

#Region Events
#Event: Click (Tag As Object)
#Event: ActionClick (Index As Int, Tag As Object)
#Event: MainActionClick (Tag As Object)
#Event: CloseClick (Tag As Object)
#Event: Opened
#Event: Closed
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enable or disable the FAB.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide the FAB.
#DesignerProperty: Key: Open, DisplayName: Open, FieldType: Boolean, DefaultValue: False, Description: Initial open state.
#DesignerProperty: Key: PlacementMode, DisplayName: Placement Mode, FieldType: String, DefaultValue: fixed, List: fixed|anchored|manual, Description: How the FAB is positioned.
#DesignerProperty: Key: Placement, DisplayName: Placement, FieldType: String, DefaultValue: bottom-end, List: bottom-end|bottom-start|bottom-center|top-end|top-start|top-center|center-end|center-start|center, Description: Fixed placement preset.
#DesignerProperty: Key: AnchorAlignment, DisplayName: Anchor Alignment, FieldType: String, DefaultValue: start, List: start|center|end, Description: Horizontal alignment used with anchored placement.
#DesignerProperty: Key: OnEdge, DisplayName: On Edge, FieldType: Boolean, DefaultValue: False, Description: Overlap the active edge by half the trigger size.
#DesignerProperty: Key: OpenMode, DisplayName: Open Mode, FieldType: String, DefaultValue: click, List: click|hover|focus, Description: Interaction mode used to open the FAB.
#DesignerProperty: Key: LayoutMode, DisplayName: Layout Mode, FieldType: String, DefaultValue: vertical, List: vertical|flower|toolbar, Description: Layout used when the FAB opens.
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: top, List: top|right|bottom|left, Description: Expansion direction.
#DesignerProperty: Key: BackdropEnabled, DisplayName: Backdrop Enabled, FieldType: Boolean, DefaultValue: True, Description: Show a backdrop and close on outside click.
#DesignerProperty: Key: AutoCloseOnActionClick, DisplayName: Auto Close On Action Click, FieldType: Boolean, DefaultValue: True, Description: Close after a regular action click.
#DesignerProperty: Key: TriggerText, DisplayName: Trigger Text, FieldType: String, DefaultValue: F, Description: Trigger button text.
#DesignerProperty: Key: TriggerVariant, DisplayName: Trigger Variant, FieldType: String, DefaultValue: primary, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Trigger variant.
#DesignerProperty: Key: TriggerStyle, DisplayName: Trigger Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost|link, Description: Trigger style.
#DesignerProperty: Key: TriggerSize, DisplayName: Trigger Size, FieldType: String, DefaultValue: lg, List: xs|sm|md|lg|xl, Description: Trigger size.
#DesignerProperty: Key: ChildActionSize, DisplayName: Child Action Size, FieldType: String, DefaultValue: sm, List: xs|sm|md|lg|xl, Description: Child action button size.
#DesignerProperty: Key: TriggerIconName, DisplayName: Trigger Icon Name, FieldType: String, DefaultValue:, Description: Optional trigger icon asset file name.
#DesignerProperty: Key: TriggerCircle, DisplayName: Trigger Circle, FieldType: Boolean, DefaultValue: True, Description: Use circular trigger button.
#DesignerProperty: Key: UseMainAction, DisplayName: Use Main Action, FieldType: Boolean, DefaultValue: False, Description: Replace the trigger with a main action when open.
#DesignerProperty: Key: MainActionText, DisplayName: Main Action Text, FieldType: String, DefaultValue: M, Description: Main action button text.
#DesignerProperty: Key: MainActionVariant, DisplayName: Main Action Variant, FieldType: String, DefaultValue: secondary, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Main action variant.
#DesignerProperty: Key: MainActionIconName, DisplayName: Main Action Icon Name, FieldType: String, DefaultValue:, Description: Optional main action icon.
#DesignerProperty: Key: UseCloseAction, DisplayName: Use Close Action, FieldType: Boolean, DefaultValue: False, Description: Replace the trigger with a close action when open.
#DesignerProperty: Key: CloseActionText, DisplayName: Close Action Text, FieldType: String, DefaultValue: X, Description: Close action button text.
#DesignerProperty: Key: CloseActionVariant, DisplayName: Close Action Variant, FieldType: String, DefaultValue: error, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Close action variant.
#DesignerProperty: Key: CloseActionIconName, DisplayName: Close Action Icon Name, FieldType: String, DefaultValue:, Description: Optional close action icon.
#End Region

' Daisy FAB token manifest for parity/style auditing:
' absolute, bottom-0, bottom-4, btn-circle, btn-error, btn-info, btn-lg, btn-primary,
' btn-secondary, btn-success, end-0, end-4, fab-close, fab-flower, fab-main-action,
' fixed, flex, flex-col-reverse, gap-2, grid, hidden, inset-0, invisible, items-center,
' items-end, opacity-0, opacity-100, pointer-events-auto, pointer-events-none, relative,
' rotate-90, scale-100, scale-80, size-6, text-sm, tooltip, tooltip-left,
' whitespace-nowrap, z-1, z-999

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Private mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private mbOpen As Boolean = False
    Private msPlacementMode As String = "fixed"
    Private msPlacement As String = "bottom-end"
    Private msAnchorAlignment As String = "start"
    Private mbOnEdge As Boolean = False
    Private msOpenMode As String = "click"
    Private msLayoutMode As String = "vertical"
    Private msDirection As String = "top"
    Private mbBackdropEnabled As Boolean = True
    Private mbAutoCloseOnActionClick As Boolean = True

    Private msTriggerText As String = "F"
    Private msTriggerVariant As String = "primary"
    Private msTriggerStyle As String = "solid"
    Private msTriggerSize As String = "lg"
    Private msChildActionSize As String = "sm"
    Private msTriggerIconName As String = ""
    Private mbTriggerCircle As Boolean = True

    Private mbUseMainAction As Boolean = False
    Private msMainActionText As String = "M"
    Private msMainActionVariant As String = "secondary"
    Private msMainActionIconName As String = ""

    Private mbUseCloseAction As Boolean = False
    Private msCloseActionText As String = "X"
    Private msCloseActionVariant As String = "error"
    Private msCloseActionIconName As String = ""

    Private mvAnchorTarget As B4XView
    Private mvOverlayHost As B4XView

    Private Const TRIGGER_TRANSITION_DURATION_MS As Int = 180
    Private btnTrigger As B4XDaisyButton
    Private vTrigger As B4XView
    Private btnCloseTrigger As B4XDaisyButton
    Private vCloseTrigger As B4XView
    Private mTriggerTransition As B4XAnimation
    Private mbActionWarmupQueued As Boolean = False
    Private mbActionViewsWarmed As Boolean = False

    Private pnlOverlay As B4XView
    Private pnlBackdrop As B4XView
    Private pnlActionLayer As B4XView

    Private pnlMeasure As B4XView
    Private cvsMeasure As B4XCanvas

    Private lstActions As List
    Private mapMainAction As Map
    Private mapCloseAction As Map

    Private miGapDip As Int = 8dip
    Private miEdgeOffsetDip As Int = 16dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    lstActions.Initialize
    mTriggerTransition.Initialize
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    mTriggerTransition.Initialize
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    If lstActions.IsInitialized = False Then lstActions.Initialize

    Dim pMeasure As Panel
    pMeasure.Initialize("")
    pnlMeasure = pMeasure
    pnlMeasure.Visible = False
    mBase.AddView(pnlMeasure, 0, 0, 120dip, 40dip)
    cvsMeasure.Initialize(pnlMeasure)

    BuildTriggerIfNeeded
    ApplyDesignerProps(Props)
    EnsureOverlayAttached
    Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mbVisible)
    mbOpen = B4XDaisyVariants.GetPropBool(Props, "Open", mbOpen)
    msPlacementMode = NormalizePlacementMode(B4XDaisyVariants.GetPropString(Props, "PlacementMode", msPlacementMode))
    msPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(Props, "Placement", msPlacement))
    msAnchorAlignment = NormalizeAnchorAlignment(B4XDaisyVariants.GetPropString(Props, "AnchorAlignment", msAnchorAlignment))
    mbOnEdge = B4XDaisyVariants.GetPropBool(Props, "OnEdge", mbOnEdge)
    msOpenMode = NormalizeOpenMode(B4XDaisyVariants.GetPropString(Props, "OpenMode", msOpenMode))
    msLayoutMode = NormalizeLayoutMode(B4XDaisyVariants.GetPropString(Props, "LayoutMode", msLayoutMode))
    msDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(Props, "Direction", msDirection))
    mbBackdropEnabled = B4XDaisyVariants.GetPropBool(Props, "BackdropEnabled", mbBackdropEnabled)
    mbAutoCloseOnActionClick = B4XDaisyVariants.GetPropBool(Props, "AutoCloseOnActionClick", mbAutoCloseOnActionClick)

    msTriggerText = B4XDaisyVariants.GetPropString(Props, "TriggerText", msTriggerText)
    msTriggerVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "TriggerVariant", msTriggerVariant))
    msTriggerStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(Props, "TriggerStyle", msTriggerStyle))
    msTriggerSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "TriggerSize", msTriggerSize))
    msChildActionSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "ChildActionSize", msChildActionSize))
    msTriggerIconName = B4XDaisyVariants.GetPropString(Props, "TriggerIconName", msTriggerIconName)
    mbTriggerCircle = B4XDaisyVariants.GetPropBool(Props, "TriggerCircle", mbTriggerCircle)

    mbUseMainAction = B4XDaisyVariants.GetPropBool(Props, "UseMainAction", mbUseMainAction)
    msMainActionText = B4XDaisyVariants.GetPropString(Props, "MainActionText", msMainActionText)
    msMainActionVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "MainActionVariant", msMainActionVariant))
    msMainActionIconName = B4XDaisyVariants.GetPropString(Props, "MainActionIconName", msMainActionIconName)

    mbUseCloseAction = B4XDaisyVariants.GetPropBool(Props, "UseCloseAction", mbUseCloseAction)
    msCloseActionText = B4XDaisyVariants.GetPropString(Props, "CloseActionText", msCloseActionText)
    msCloseActionVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "CloseActionVariant", msCloseActionVariant))
    msCloseActionIconName = B4XDaisyVariants.GetPropString(Props, "CloseActionIconName", msCloseActionIconName)

    SyncSpecialActionRecords
End Sub
#End Region

#Region Composition
Private Sub BuildTriggerIfNeeded
    If btnTrigger.IsInitialized = False Then
        Dim b As B4XDaisyButton
        b.Initialize(Me, "fabtrigger")
        btnTrigger = b
    End If
    If vTrigger.IsInitialized = False Then
        vTrigger = btnTrigger.AddToParent(mBase, 0, 0, 0, 0)
    End If
End Sub

Private Sub BuildCloseTriggerIfNeeded
    If mbUseCloseAction = False Then Return
    If btnCloseTrigger.IsInitialized = False Then
        Dim b As B4XDaisyButton
        b.Initialize(Me, "fabclose")
        btnCloseTrigger = b
    End If
    If vCloseTrigger.IsInitialized = False Then
        vCloseTrigger = btnCloseTrigger.AddToParent(mBase, 0, 0, 0, 0)
        mTriggerTransition.SetNativeAlpha(vCloseTrigger, 0)
        SetNativeScale(vCloseTrigger, 0.92, 0.92)
        vCloseTrigger.Visible = False
    End If
End Sub

Private Sub SyncTriggerButtons
    If btnTrigger.Text <> msTriggerText Then btnTrigger.Text = msTriggerText
    If btnTrigger.Variant <> msTriggerVariant Then btnTrigger.Variant = msTriggerVariant
    If btnTrigger.Style <> msTriggerStyle Then btnTrigger.Style = msTriggerStyle
    If btnTrigger.Size <> msTriggerSize Then btnTrigger.Size = msTriggerSize
    If btnTrigger.IconName <> msTriggerIconName Then btnTrigger.IconName = msTriggerIconName
    If btnTrigger.Circle <> mbTriggerCircle Then btnTrigger.Circle = mbTriggerCircle
    If btnTrigger.Disabled <> Not(mbEnabled) Then btnTrigger.Disabled = Not(mbEnabled)
    If btnTrigger.Visible <> mbVisible Then btnTrigger.Visible = mbVisible
    btnTrigger.Tag = mTag

    If mbUseCloseAction = False Then
        If vCloseTrigger.IsInitialized Then
            vCloseTrigger.Visible = False
            mTriggerTransition.SetNativeAlpha(vCloseTrigger, 0)
            SetNativeScale(vCloseTrigger, 0.92, 0.92)
        End If
        Return
    End If

    BuildCloseTriggerIfNeeded
    If btnCloseTrigger.Text <> msCloseActionText Then btnCloseTrigger.Text = msCloseActionText
    If btnCloseTrigger.Variant <> msCloseActionVariant Then btnCloseTrigger.Variant = msCloseActionVariant
    If btnCloseTrigger.Style <> "solid" Then btnCloseTrigger.Style = "solid"
    If btnCloseTrigger.Size <> msTriggerSize Then btnCloseTrigger.Size = msTriggerSize
    If btnCloseTrigger.IconName <> msCloseActionIconName Then btnCloseTrigger.IconName = msCloseActionIconName
    If btnCloseTrigger.Circle <> mbTriggerCircle Then btnCloseTrigger.Circle = mbTriggerCircle
    If btnCloseTrigger.Disabled <> Not(mbEnabled) Then btnCloseTrigger.Disabled = Not(mbEnabled)
    If btnCloseTrigger.Visible <> mbVisible Then btnCloseTrigger.Visible = mbVisible
    btnCloseTrigger.Tag = ResolveCloseTriggerTag
End Sub

Private Sub ScheduleActionWarmup
    If mBase.IsInitialized = False Then Return
    If mBase.Parent.IsInitialized = False Then Return
    If HasExpandableContent = False Then
        mbActionWarmupQueued = False
        mbActionViewsWarmed = False
        Return
    End If
    If mbActionViewsWarmed Or mbActionWarmupQueued Then Return
    mbActionWarmupQueued = True
    CallSubDelayed(Me, "WarmActionViews")
End Sub

Private Sub WarmActionViews
    mbActionWarmupQueued = False
    If mBase.IsInitialized = False Then Return
    If mBase.Parent.IsInitialized = False Then Return
    If HasExpandableContent = False Then
        mbActionViewsWarmed = False
        Return
    End If

    EnsureOverlayAttached
    EnsureAllActionViews
    mbActionViewsWarmed = True

    If mbOpen Then
        LayoutOpenState
    Else
        HideAllActionHosts
    End If
End Sub

Private Sub ResolveCloseTriggerTag As Object
    If mapCloseAction.IsInitialized Then Return mapCloseAction.GetDefault("Tag", mTag)
    Return mTag
End Sub

Private Sub EnsureOverlayAttached
    If mBase.IsInitialized = False Then Return
    If HasExpandableContent = False Then
        If pnlOverlay.IsInitialized Then
            pnlOverlay.Visible = False
            If pnlOverlay.Parent.IsInitialized Then pnlOverlay.RemoveViewFromParent
        End If
        Return
    End If
    Dim overlayHost As B4XView = ResolveOverlayHost
    If overlayHost.IsInitialized = False Then Return

    If pnlOverlay.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        pnlOverlay = p
        pnlOverlay.Color = xui.Color_Transparent

        Dim pb As Panel
        pb.Initialize("fabbackdrop")
        pnlBackdrop = pb
        pnlBackdrop.Color = B4XDaisyVariants.SetAlpha(xui.Color_Black, 32)
        pnlOverlay.AddView(pnlBackdrop, 0, 0, overlayHost.Width, overlayHost.Height)

        Dim pa As Panel
        pa.Initialize("")
        pnlActionLayer = pa
        pnlActionLayer.Color = xui.Color_Transparent
        pnlOverlay.AddView(pnlActionLayer, 0, 0, overlayHost.Width, overlayHost.Height)
    End If

    If pnlOverlay.Parent.IsInitialized And pnlOverlay.Parent <> overlayHost Then
        pnlOverlay.RemoveViewFromParent
    End If

    If pnlOverlay.Parent.IsInitialized = False Then
        overlayHost.AddView(pnlOverlay, 0, 0, overlayHost.Width, overlayHost.Height)
    End If

    pnlOverlay.SetLayoutAnimated(0, 0, 0, overlayHost.Width, overlayHost.Height)
    pnlBackdrop.SetLayoutAnimated(0, 0, 0, pnlOverlay.Width, pnlOverlay.Height)
    pnlActionLayer.SetLayoutAnimated(0, 0, 0, pnlOverlay.Width, pnlOverlay.Height)
    pnlOverlay.Visible = mbOpen And mbVisible
    pnlBackdrop.Visible = mbBackdropEnabled

    B4XDaisyVariants.DisableClippingRecursive(overlayHost)
    B4XDaisyVariants.DisableClippingRecursive(mBase)
End Sub

Private Sub SyncSpecialActionRecords
    If mbUseCloseAction Then
        Dim emptyMain As Map
        mapMainAction = emptyMain
    Else If mbUseMainAction Then
        mapMainAction = BuildActionRecord("main", msMainActionText, "", msMainActionVariant, "solid", msTriggerSize, msMainActionIconName, True, "main")
    Else
        Dim emptyMain As Map
        mapMainAction = emptyMain
    End If

    If mbUseCloseAction Then
        mapCloseAction = BuildActionRecord("close", msCloseActionText, "", msCloseActionVariant, "solid", msTriggerSize, msCloseActionIconName, True, "close")
    Else
        Dim emptyClose As Map
        mapCloseAction = emptyClose
    End If
End Sub

Private Sub BuildActionRecord(Role As String, Text As String, LabelText As String, Variant As String, Style As String, Size As String, IconName As String, Circle As Boolean, TagValue As Object) As Map
    Dim rec As Map
    rec.Initialize
    rec.Put("Role", Role)
    rec.Put("Text", IIf(Text = Null, "", Text))
    rec.Put("Label", IIf(LabelText = Null, "", LabelText))
    rec.Put("Variant", B4XDaisyVariants.NormalizeVariant(Variant))
    rec.Put("Style", B4XDaisyVariants.NormalizeStyle(Style))
    rec.Put("Size", B4XDaisyVariants.NormalizeSize(Size))
    rec.Put("IconName", IIf(IconName = Null, "", IconName))
    rec.Put("Circle", Circle)
    rec.Put("Tag", TagValue)
    rec.Put("Visible", True)
    Return rec
End Sub

Private Sub EnsureActionView(Rec As Map)
    EnsureOverlayAttached
    If Rec.IsInitialized = False Or pnlActionLayer.IsInitialized = False Then Return

    Dim host As B4XView = GetRecView(Rec, "Host")
    If host.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        host = p
        host.Color = xui.Color_Transparent
        pnlActionLayer.AddView(host, 0, 0, 10dip, 10dip)
        Rec.Put("Host", host)
    End If

    Dim lbl As B4XView = Rec.Get("LabelView")
    If lbl.IsInitialized = False Then
        Dim l As Label
        l.Initialize("")
        lbl = l
        lbl.Color = xui.Color_Transparent
        lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
        lbl.SetTextAlignment("LEFT", "CENTER")
        host.AddView(lbl, 0, 0, 1dip, 1dip)
        Rec.Put("LabelView", lbl)
    End If

    Dim btn As B4XDaisyButton = GetRecButton(Rec)
    Dim btnView As B4XView = GetRecView(Rec, "ButtonView")
    If btn.IsInitialized = False Or btnView.IsInitialized = False Then
        Dim actBtn As B4XDaisyButton
        actBtn.Initialize(Me, "fabaction")
        btn = actBtn
        btnView = btn.AddToParent(host, 0, 0, 0, 0)
        Rec.Put("Button", btn)
        Rec.Put("ButtonView", btnView)
    End If

    ApplyActionAppearance(Rec)
End Sub

Private Sub ApplyActionAppearance(Rec As Map)
    If Rec.IsInitialized = False Then Return
    Dim btn As B4XDaisyButton = GetRecButton(Rec)
    Dim btnView As B4XView = GetRecView(Rec, "ButtonView")
    Dim lbl As B4XView = GetRecView(Rec, "LabelView")
    If btn.IsInitialized = False Or btnView.IsInitialized = False Then Return

    If btn.Text <> Rec.Get("Text") Then btn.Text = Rec.Get("Text")
    If btn.Variant <> Rec.Get("Variant") Then btn.Variant = Rec.Get("Variant")
    If btn.Style <> Rec.Get("Style") Then btn.Style = Rec.Get("Style")
    If btn.Size <> Rec.Get("Size") Then btn.Size = Rec.Get("Size")
    If btn.Circle <> Rec.Get("Circle") Then btn.Circle = Rec.Get("Circle")
    If btn.IconName <> Rec.Get("IconName") Then btn.IconName = Rec.Get("IconName")
    If btn.Disabled <> Not(mbEnabled) Then btn.Disabled = Not(mbEnabled)

    Dim payload As Map = CreateMap("role": Rec.Get("Role"), "tag": Rec.Get("Tag"))
    If Rec.Get("Role") = "action" Then
        payload.Put("index", lstActions.IndexOf(Rec))
    Else
        payload.Put("index", -1)
    End If
    btn.Tag = payload

    Dim labelText As String = Rec.Get("Label")
    If lbl.IsInitialized Then
        lbl.Text = labelText
        lbl.Visible = labelText.Length > 0 And msLayoutMode <> "toolbar"
    End If

    btnView.Visible = Rec.GetDefault("Visible", True)
End Sub
#End Region

#Region Public API
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        DesignerCreateView(p, Null, BuildRuntimeProps)
    End If

    Dim targetW As Int = Max(ResolveButtonExtentDip(msTriggerSize), Width)
    Dim targetH As Int = Max(ResolveButtonExtentDip(msTriggerSize), Height)
    Parent.AddView(mBase, Left, Top, targetW, targetH)
    EnsureOverlayAttached
    ApplyPlacementIfNeeded
    Base_Resize(mBase.Width, mBase.Height)
    ScheduleActionWarmup
    Return mBase
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return

    BuildTriggerIfNeeded
    BuildCloseTriggerIfNeeded
    SyncSpecialActionRecords
    SyncTriggerButtons

    mBase.Visible = mbVisible
    EnsureOverlayAttached
    ApplyPlacementIfNeeded
    Base_Resize(mBase.Width, mBase.Height)
    UpdateTriggerTransition(mbOpen And mbUseCloseAction, False)

    If mbOpen And HasExpandableContent Then
        Open
    Else
        Close
    End If
    ScheduleActionWarmup
End Sub

Public Sub UpdateTheme
    Refresh
End Sub

Public Sub Open
    If mbVisible = False Then Return
    If HasExpandableContent = False Then Return

    mbOpen = True
    EnsureOverlayAttached
    LayoutOpenState
    UpdateTriggerTransition(True, True)
    If xui.SubExists(mCallBack, mEventName & "_Opened", 0) Then
        CallSub(mCallBack, mEventName & "_Opened")
    End If
End Sub

Public Sub Close
    If mbOpen = False Then
        ApplyClosedState
        Return
    End If

    mbOpen = False
    UpdateTriggerTransition(False, True)
    ApplyClosedState
    If xui.SubExists(mCallBack, mEventName & "_Closed", 0) Then
        CallSub(mCallBack, mEventName & "_Closed")
    End If
End Sub

Public Sub Toggle
    If mbOpen Then Close Else Open
End Sub

Public Sub ClearActions
    For Each rec As Map In lstActions
        RemoveActionViews(rec)
    Next
    lstActions.Clear
    mbActionViewsWarmed = False
    mbActionWarmupQueued = False
    If mbOpen Then LayoutOpenState
End Sub

Public Sub AddActionEx(Text As String, LabelText As String, Variant As String, Style As String, Size As String, IconName As String, Circle As Boolean, TagValue As Object) As Int
    Dim rec As Map = BuildActionRecord("action", Text, LabelText, Variant, Style, Size, IconName, Circle, TagValue)
    lstActions.Add(rec)
    mbActionViewsWarmed = False
    ScheduleActionWarmup
    If mbOpen Then LayoutOpenState
    Return lstActions.Size - 1
End Sub

Public Sub AddAction(TagValue As Object, Variant As String, IconName As String) As Int
    Return AddActionEx("", "", Variant, "solid", msChildActionSize, IconName, True, TagValue)
End Sub

Public Sub AddActionDetailed(Text As String, LabelText As String, Variant As String, IconName As String, TagValue As Object) As Int
    Return AddActionEx(Text, LabelText, Variant, "solid", msChildActionSize, IconName, True, TagValue)
End Sub

Public Sub SetMainAction(Text As String, LabelText As String, Variant As String, IconName As String, TagValue As Object)
    mbUseMainAction = True
    mbUseCloseAction = False
    mapMainAction = BuildActionRecord("main", Text, LabelText, Variant, "solid", msTriggerSize, IconName, True, TagValue)
    Dim emptyClose As Map
    mapCloseAction = emptyClose
    mbActionViewsWarmed = False
    ScheduleActionWarmup
    If mbOpen Then LayoutOpenState
End Sub

Public Sub SetCloseAction(Text As String, LabelText As String, Variant As String, IconName As String, TagValue As Object)
    mbUseCloseAction = True
    mbUseMainAction = False
    mapCloseAction = BuildActionRecord("close", Text, LabelText, Variant, "solid", msTriggerSize, IconName, True, TagValue)
    Dim emptyMain As Map
    mapMainAction = emptyMain
    mbActionViewsWarmed = False
    ScheduleActionWarmup
    If mbOpen Then LayoutOpenState
End Sub

Public Sub GetActionButtonView(Index As Int) As B4XView
    Dim empty As B4XView
    If Index < 0 Or Index >= lstActions.Size Then Return empty
    Dim rec As Map = lstActions.Get(Index)
    EnsureActionView(rec)
    Dim v As B4XView = GetRecView(rec, "ButtonView")
    Return v
End Sub

Public Sub SetActionVisible(Index As Int, Value As Boolean)
    If Index < 0 Or Index >= lstActions.Size Then Return
    Dim rec As Map = lstActions.Get(Index)
    rec.Put("Visible", Value)
    If mbOpen Then LayoutOpenState
End Sub

Public Sub setAnchorTarget(Value As B4XView)
    mvAnchorTarget = Value
    If mBase.IsInitialized = False Then Return
    ApplyPlacementIfNeeded
    If mbOpen Then LayoutOpenState
End Sub

Public Sub getAnchorTarget As B4XView
    Return mvAnchorTarget
End Sub

Public Sub setAnchorAlignment(Value As String)
    msAnchorAlignment = NormalizeAnchorAlignment(Value)
    If mBase.IsInitialized = False Then Return
    ApplyPlacementIfNeeded
    If mbOpen Then LayoutOpenState
End Sub

Public Sub getAnchorAlignment As String
    Return msAnchorAlignment
End Sub

Public Sub setAnchorView(Value As B4XView)
    setAnchorTarget(Value)
End Sub

Public Sub getAnchorView As B4XView
    Return mvAnchorTarget
End Sub

Public Sub setOverlayHost(Value As B4XView)
    mvOverlayHost = Value
    If mBase.IsInitialized = False Then Return
    EnsureOverlayAttached
    ApplyPlacementIfNeeded
    If mbOpen Then LayoutOpenState
End Sub

Public Sub getOverlayHost As B4XView
    Return mvOverlayHost
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(Duration, Left, Top, Width, Height)
    EnsureOverlayAttached
    If mbOpen Then LayoutOpenState
End Sub

Public Sub Resize(Width As Double, Height As Double)
    Base_Resize(Width, Height)
End Sub

Public Sub BringToFront
    If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub setLeft(Value As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Left = Value
    If mbOpen Then LayoutOpenState
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Left
End Sub

Public Sub setTop(Value As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Top = Value
    If mbOpen Then LayoutOpenState
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Top
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
    If btnTrigger.IsInitialized Then btnTrigger.Tag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mbVisible = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setOpen(Value As Boolean)
    mbOpen = Value
    If mBase.IsInitialized = False Then Return
    If Value Then Open Else Close
End Sub

Public Sub getOpen As Boolean
    Return mbOpen
End Sub

Public Sub setPlacementMode(Value As String)
    msPlacementMode = NormalizePlacementMode(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlacementMode As String
    Return msPlacementMode
End Sub

Public Sub setPlacement(Value As String)
    msPlacement = NormalizePlacement(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlacement As String
    Return msPlacement
End Sub

Public Sub setOnEdge(Value As Boolean)
    mbOnEdge = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getOnEdge As Boolean
    Return mbOnEdge
End Sub

Public Sub setOpenMode(Value As String)
    msOpenMode = NormalizeOpenMode(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getOpenMode As String
    Return msOpenMode
End Sub

Public Sub setLayoutMode(Value As String)
    msLayoutMode = NormalizeLayoutMode(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLayoutMode As String
    Return msLayoutMode
End Sub

Public Sub setDirection(Value As String)
    msDirection = NormalizeDirection(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getDirection As String
    Return msDirection
End Sub

Public Sub setBackdropEnabled(Value As Boolean)
    mbBackdropEnabled = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackdropEnabled As Boolean
    Return mbBackdropEnabled
End Sub

Public Sub setAutoCloseOnActionClick(Value As Boolean)
    mbAutoCloseOnActionClick = Value
End Sub

Public Sub getAutoCloseOnActionClick As Boolean
    Return mbAutoCloseOnActionClick
End Sub

Public Sub setTriggerText(Value As String)
    msTriggerText = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTriggerText As String
    Return msTriggerText
End Sub

Public Sub setTriggerVariant(Value As String)
    msTriggerVariant = B4XDaisyVariants.NormalizeVariant(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTriggerVariant As String
    Return msTriggerVariant
End Sub

Public Sub setTriggerStyle(Value As String)
    msTriggerStyle = B4XDaisyVariants.NormalizeStyle(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTriggerStyle As String
    Return msTriggerStyle
End Sub

Public Sub setTriggerSize(Value As String)
    msTriggerSize = B4XDaisyVariants.NormalizeSize(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTriggerSize As String
    Return msTriggerSize
End Sub

Public Sub setChildActionSize(Value As String)
    msChildActionSize = B4XDaisyVariants.NormalizeSize(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getChildActionSize As String
    Return msChildActionSize
End Sub

Public Sub setTriggerIconName(Value As String)
    msTriggerIconName = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTriggerIconName As String
    Return msTriggerIconName
End Sub

Public Sub setTriggerCircle(Value As Boolean)
    mbTriggerCircle = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTriggerCircle As Boolean
    Return mbTriggerCircle
End Sub

Public Sub setUseMainAction(Value As Boolean)
    mbUseMainAction = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getUseMainAction As Boolean
    Return mbUseMainAction
End Sub

Public Sub setMainActionText(Value As String)
    msMainActionText = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getMainActionText As String
    Return msMainActionText
End Sub

Public Sub setMainActionVariant(Value As String)
    msMainActionVariant = B4XDaisyVariants.NormalizeVariant(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getMainActionVariant As String
    Return msMainActionVariant
End Sub

Public Sub setMainActionIconName(Value As String)
    msMainActionIconName = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getMainActionIconName As String
    Return msMainActionIconName
End Sub

Public Sub setUseCloseAction(Value As Boolean)
    mbUseCloseAction = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getUseCloseAction As Boolean
    Return mbUseCloseAction
End Sub

Public Sub setCloseActionText(Value As String)
    msCloseActionText = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getCloseActionText As String
    Return msCloseActionText
End Sub

Public Sub setCloseActionVariant(Value As String)
    msCloseActionVariant = B4XDaisyVariants.NormalizeVariant(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getCloseActionVariant As String
    Return msCloseActionVariant
End Sub

Public Sub setCloseActionIconName(Value As String)
    msCloseActionIconName = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getCloseActionIconName As String
    Return msCloseActionIconName
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
    If pnlOverlay.IsInitialized And pnlOverlay.Parent.IsInitialized Then pnlOverlay.RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

#Region Layout
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return

    BuildTriggerIfNeeded
    BuildCloseTriggerIfNeeded
    SyncTriggerButtons

    Dim triggerExtent As Int = ResolveButtonExtentDip(msTriggerSize)
    Dim targetW As Int = Max(triggerExtent, Width)
    Dim targetH As Int = Max(triggerExtent, Height)
    If vTrigger.IsInitialized Then
        vTrigger.SetLayoutAnimated(0, 0, 0, targetW, targetH)
        btnTrigger.Base_Resize(targetW, targetH)
    End If
    If vCloseTrigger.IsInitialized Then
        vCloseTrigger.SetLayoutAnimated(0, 0, 0, targetW, targetH)
        btnCloseTrigger.Base_Resize(targetW, targetH)
    End If

    EnsureOverlayAttached
    UpdateTriggerTransition(mbOpen And mbUseCloseAction, False)
    If mbOpen Then LayoutOpenState
End Sub

Private Sub UpdateTriggerTransition(OpenState As Boolean, Animate As Boolean)
    If vTrigger.IsInitialized = False Then Return

    Dim showClose As Boolean = OpenState And mbUseCloseAction And vCloseTrigger.IsInitialized
    If showClose = False Then
        If vCloseTrigger.IsInitialized = False Then
            vTrigger.Visible = mbVisible
            mTriggerTransition.SetNativeAlpha(vTrigger, 1)
            SetNativeScale(vTrigger, 1, 1)
            Return
        End If
    End If

    Dim triggerAlpha As Float = 1
    Dim closeAlpha As Float = 0
    Dim triggerScale As Float = 1
    Dim closeScale As Float = 0.92
    Dim triggerRotation As Float = 0
    Dim closeRotation As Float = -90
    If showClose Then
        triggerAlpha = 0
        closeAlpha = 1
        triggerScale = 0.92
        closeScale = 1
        triggerRotation = 90
        closeRotation = 0
    End If

    vTrigger.Visible = mbVisible
    If vCloseTrigger.IsInitialized Then vCloseTrigger.Visible = mbVisible And mbUseCloseAction

    If showClose Then
        vCloseTrigger.BringToFront
        btnTrigger.Disabled = True
        If btnCloseTrigger.IsInitialized Then btnCloseTrigger.Disabled = Not(mbEnabled)
    Else
        vTrigger.BringToFront
        btnTrigger.Disabled = Not(mbEnabled)
        If btnCloseTrigger.IsInitialized Then btnCloseTrigger.Disabled = True
    End If

    If Animate Then
        AnimateTriggerView(vTrigger, triggerAlpha, triggerScale, triggerRotation, TRIGGER_TRANSITION_DURATION_MS)
        If vCloseTrigger.IsInitialized Then AnimateTriggerView(vCloseTrigger, closeAlpha, closeScale, closeRotation, TRIGGER_TRANSITION_DURATION_MS)
    Else
        mTriggerTransition.SetNativeAlpha(vTrigger, triggerAlpha)
        mTriggerTransition.SetNativeRotation(vTrigger, triggerRotation)
        SetNativeScale(vTrigger, triggerScale, triggerScale)
        If vCloseTrigger.IsInitialized Then
            mTriggerTransition.SetNativeAlpha(vCloseTrigger, closeAlpha)
            mTriggerTransition.SetNativeRotation(vCloseTrigger, closeRotation)
            SetNativeScale(vCloseTrigger, closeScale, closeScale)
        End If
    End If
End Sub

Private Sub AnimateTriggerView(ViewRef As B4XView, AlphaValue As Float, ScaleValue As Float, RotationValue As Float, DurationMs As Int)
    If ViewRef.IsInitialized = False Then Return
    #If B4A
    Dim jo As JavaObject = ViewRef
    Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
    anim.RunMethod("cancel", Null)
    anim.RunMethod("alpha", Array As Object(AlphaValue))
    anim.RunMethod("rotation", Array As Object(RotationValue))
    anim.RunMethod("scaleX", Array As Object(ScaleValue))
    anim.RunMethod("scaleY", Array As Object(ScaleValue))
    Try
        anim.RunMethod("setDuration", Array As Object(Max(0, DurationMs)))
    Catch
    End Try
    anim.RunMethod("start", Null)
    #Else
    mTriggerTransition.SetNativeAlpha(ViewRef, AlphaValue)
    mTriggerTransition.SetNativeRotation(ViewRef, RotationValue)
    SetNativeScale(ViewRef, ScaleValue, ScaleValue)
    Dim ignore As Int = DurationMs
    #End If
End Sub

Private Sub SetNativeScale(v As B4XView, sx As Float, sy As Float)
    #If B4A
    Dim jo As JavaObject = v
    jo.RunMethod("setScaleX", Array As Object(sx))
    jo.RunMethod("setScaleY", Array As Object(sy))
    #Else
    Dim ignore As Object = v
    Dim ignoreX As Float = sx
    Dim ignoreY As Float = sy
    #End If
End Sub

Private Sub LayoutOpenState
    If pnlOverlay.IsInitialized = False Or mBase.Parent.IsInitialized = False Then Return

    pnlOverlay.Visible = mbVisible And mbOpen
    pnlBackdrop.Visible = mbBackdropEnabled
    pnlBackdrop.Color = IIf(mbBackdropEnabled, B4XDaisyVariants.SetAlpha(xui.Color_Black, 32), xui.Color_Transparent)
    If HasTriggerReplacement Then
        pnlOverlay.BringToFront
    Else
        pnlOverlay.BringToFront
        mBase.BringToFront
    End If

    Select Case msLayoutMode
        Case "toolbar"
            LayoutToolbar
        Case "flower"
            LayoutFlower
        Case Else
            LayoutVertical
    End Select
End Sub

Private Sub LayoutVertical
    HideAllActionHosts

    Dim triggerRect As Map = GetTriggerRectInParent
    Dim baseLeft As Int = triggerRect.Get("left")
    Dim baseTop As Int = triggerRect.Get("top")
    Dim triggerW As Int = triggerRect.Get("width")
    Dim triggerH As Int = triggerRect.Get("height")

    LayoutSpecialAtTrigger(mapMainAction, baseLeft, baseTop, triggerW, triggerH)
    If vTrigger.IsInitialized Then vTrigger.Visible = mbVisible
    If vCloseTrigger.IsInitialized Then vCloseTrigger.Visible = mbVisible And mbUseCloseAction

    Dim slot As Int = 0
    For Each rec As Map In lstActions
        If rec.GetDefault("Visible", True) = False Then Continue
        EnsureActionView(rec)
        Dim sizeInfo As Map = MeasureActionHost(rec, False)
        Dim host As B4XView = rec.Get("Host")
        Dim hostW As Int = sizeInfo.Get("width")
        Dim hostH As Int = sizeInfo.Get("height")
        Dim buttonW As Int = sizeInfo.Get("buttonW")

        Dim x As Int = baseLeft
        Dim y As Int = baseTop
        Select Case msDirection
            Case "bottom"
                x = GetVerticalHostLeft(baseLeft, triggerW, hostW, buttonW)
                y = baseTop + triggerH + miGapDip + (slot * (hostH + miGapDip))
            Case "left"
                x = baseLeft - ((slot + 1) * (hostW + miGapDip))
                y = baseTop + (triggerH - hostH) / 2
            Case "right"
                x = baseLeft + triggerW + (slot * (hostW + miGapDip))
                y = baseTop + (triggerH - hostH) / 2
            Case Else
                x = GetVerticalHostLeft(baseLeft, triggerW, hostW, buttonW)
                y = baseTop - ((slot + 1) * (hostH + miGapDip))
        End Select

        host.SetLayoutAnimated(0, x, y, hostW, hostH)
        LayoutHostContents(rec, False)
        host.Visible = True
        slot = slot + 1
    Next
End Sub

Private Sub LayoutFlower
    HideAllActionHosts

    Dim triggerRect As Map = GetTriggerRectInParent
    Dim centerX As Float = triggerRect.Get("left") + (triggerRect.Get("width") / 2)
    Dim centerY As Float = triggerRect.Get("top") + (triggerRect.Get("height") / 2)

    LayoutSpecialAtTrigger(mapMainAction, triggerRect.Get("left"), triggerRect.Get("top"), triggerRect.Get("width"), triggerRect.Get("height"))
    If vTrigger.IsInitialized Then vTrigger.Visible = mbVisible
    If vCloseTrigger.IsInitialized Then vCloseTrigger.Visible = mbVisible And mbUseCloseAction

    Dim visibleItems As List
    visibleItems.Initialize
    For Each rec As Map In lstActions
        If rec.GetDefault("Visible", True) Then visibleItems.Add(rec)
    Next

    Dim maxCount As Int = Min(4, visibleItems.Size)
    Dim degrees() As Float = GetFlowerDegrees(maxCount)
    Dim radius As Float = GetFlowerRadiusDip(maxCount)

    For i = 0 To maxCount - 1
        Dim rec As Map = visibleItems.Get(i)
        EnsureActionView(rec)
        Dim sizeInfo As Map = MeasureActionHost(rec, True)
        Dim host As B4XView = rec.Get("Host")
        Dim hostW As Int = sizeInfo.Get("width")
        Dim hostH As Int = sizeInfo.Get("height")

        Dim rotated As Float = RotateFlowerDegree(degrees(i), msDirection)
        Dim dx As Float = Cos(rotated * cPI / 180) * radius
        Dim dy As Float = Sin(rotated * cPI / 180) * radius * -1
        Dim x As Int = Round(centerX + dx - (hostW / 2))
        Dim y As Int = Round(centerY + dy - (hostH / 2))

        host.SetLayoutAnimated(0, x, y, hostW, hostH)
        LayoutHostContents(rec, True)
        host.Visible = True
    Next
End Sub

Private Sub ApplyClosedState
    If pnlOverlay.IsInitialized Then pnlOverlay.Visible = False
    HideAllActionHosts
    If vTrigger.IsInitialized Then vTrigger.Visible = mbVisible
    If vCloseTrigger.IsInitialized Then vCloseTrigger.Visible = mbVisible And mbUseCloseAction
    If mBase.IsInitialized Then mBase.BringToFront
End Sub

Private Sub LayoutToolbar
    HideAllActionHosts
    vTrigger.Visible = False
    If vCloseTrigger.IsInitialized Then vCloseTrigger.Visible = False

    Dim barY As Int
    If ShouldToolbarDockTop Then
        barY = miEdgeOffsetDip
    Else
        barY = Max(0, pnlOverlay.Height - 72dip - miEdgeOffsetDip)
    End If

    Dim allItems As List
    allItems.Initialize
    If mapMainAction.IsInitialized Then allItems.Add(mapMainAction)
    For Each rec As Map In lstActions
        If rec.GetDefault("Visible", True) Then allItems.Add(rec)
    Next
    If mapCloseAction.IsInitialized Then allItems.Add(mapCloseAction)

    Dim count As Int = Max(1, allItems.Size)
    Dim gap As Int = 8dip
    Dim usableW As Int = Max(160dip, pnlOverlay.Width - (miEdgeOffsetDip * 2))
    Dim itemW As Int = Max(48dip, (usableW - ((count - 1) * gap)) / count)

    For i = 0 To allItems.Size - 1
        Dim rec As Map = allItems.Get(i)
        EnsureActionView(rec)
        Dim host As B4XView = rec.Get("Host")
        host.SetLayoutAnimated(0, miEdgeOffsetDip + (i * (itemW + gap)), barY, itemW, 64dip)
        LayoutHostContents(rec, False)
        host.Visible = True
    Next
End Sub

Private Sub LayoutSpecialAtTrigger(Rec As Map, Left As Int, Top As Int, Width As Int, Height As Int)
    If Rec.IsInitialized = False Then Return
    EnsureActionView(Rec)
    Dim host As B4XView = GetRecView(Rec, "Host")
    host.SetLayoutAnimated(0, Left, Top, Width, Height)
    LayoutHostContents(Rec, True)
    host.Visible = True
End Sub

Private Sub HideAllActionHosts
    For Each rec As Map In lstActions
        Dim host As B4XView = GetRecView(rec, "Host")
        If host.IsInitialized Then host.Visible = False
    Next
    If mapMainAction.IsInitialized Then
        Dim hostMain As B4XView = GetRecView(mapMainAction, "Host")
        If hostMain.IsInitialized Then hostMain.Visible = False
    End If
    If mapCloseAction.IsInitialized Then
        Dim hostClose As B4XView = GetRecView(mapCloseAction, "Host")
        If hostClose.IsInitialized Then hostClose.Visible = False
    End If
End Sub

Private Sub HasTriggerReplacement As Boolean
    If mapMainAction.IsInitialized Then Return True
    Return False
End Sub

Private Sub MeasureActionHost(Rec As Map, FlowerMode As Boolean) As Map
    EnsureActionView(Rec)
    Dim btnView As B4XView = GetRecView(Rec, "ButtonView")
    Dim lbl As B4XView = GetRecView(Rec, "LabelView")
    Dim buttonW As Int = Max(ResolveButtonExtentDip(Rec.Get("Size")), btnView.Width)
    Dim buttonH As Int = Max(ResolveButtonExtentDip(Rec.Get("Size")), btnView.Height)
    Dim labelW As Int = 0
    If FlowerMode = False And lbl.IsInitialized And lbl.Text.Length > 0 Then
        labelW = MeasureTextWidth(lbl.Text, xui.CreateDefaultFont(14)) + 6dip
    End If
    Dim totalW As Int = buttonW + IIf(labelW > 0, labelW + 8dip, 0)
    Dim totalH As Int = Max(buttonH, 28dip)
    Return CreateMap("width": totalW, "height": totalH, "buttonW": buttonW, "buttonH": buttonH, "labelW": labelW)
End Sub

Private Sub LayoutHostContents(Rec As Map, ButtonOnly As Boolean)
    Dim host As B4XView = GetRecView(Rec, "Host")
    Dim btnView As B4XView = GetRecView(Rec, "ButtonView")
    Dim btn As B4XDaisyButton = GetRecButton(Rec)
    Dim lbl As B4XView = GetRecView(Rec, "LabelView")
    If host.IsInitialized = False Or btnView.IsInitialized = False Or btn.IsInitialized = False Then Return

    Dim info As Map = MeasureActionHost(Rec, ButtonOnly)
    Dim buttonW As Int = info.Get("buttonW")
    Dim buttonH As Int = info.Get("buttonH")
    Dim labelW As Int = info.Get("labelW")

    If ButtonOnly Then
        btnView.SetLayoutAnimated(0, (host.Width - buttonW) / 2, (host.Height - buttonH) / 2, buttonW, buttonH)
        btn.Base_Resize(buttonW, buttonH)
        If lbl.IsInitialized Then lbl.Visible = False
        Return
    End If

    If lbl.IsInitialized And labelW > 0 Then
        lbl.Visible = True
        lbl.SetLayoutAnimated(0, 0, (host.Height - 24dip) / 2, labelW, 24dip)
        btnView.SetLayoutAnimated(0, host.Width - buttonW, (host.Height - buttonH) / 2, buttonW, buttonH)
    Else
        If lbl.IsInitialized Then lbl.Visible = False
        btnView.SetLayoutAnimated(0, host.Width - buttonW, (host.Height - buttonH) / 2, buttonW, buttonH)
    End If
    btn.Base_Resize(buttonW, buttonH)
End Sub

Private Sub ApplyPlacementIfNeeded
    If mBase.IsInitialized = False Or mBase.Parent.IsInitialized = False Then Return
    Dim parent As B4XView = mBase.Parent
    Dim w As Int = Max(ResolveButtonExtentDip(msTriggerSize), mBase.Width)
    Dim h As Int = Max(ResolveButtonExtentDip(msTriggerSize), mBase.Height)

    Select Case msPlacementMode
        Case "manual"
        Case "anchored"
            If mvAnchorTarget.IsInitialized = False Then Return
            Dim anchorRect As Map = GetViewRectRelativeToAncestor(mvAnchorTarget, parent)
            Dim left As Int = anchorRect.Get("left")
            Dim top As Int = anchorRect.Get("top")
            Dim anchorW As Int = anchorRect.Get("width")
            Dim anchorH As Int = anchorRect.Get("height")
            Select Case msAnchorAlignment
                Case "center"
                    left = left + ((anchorW - w) / 2)
                Case "end"
                    left = left + anchorW - w
            End Select
            Select Case msDirection
                Case "bottom"
                    If mbOnEdge Then
                        top = top + anchorH - (h / 2)
                    Else
                        top = top + anchorH + miGapDip
                    End If
                Case "left"
                    If mbOnEdge Then
                        left = left - (w / 2)
                    Else
                        left = left - w - miGapDip
                    End If
                Case "right"
                    If mbOnEdge Then
                        left = left + anchorW - (w / 2)
                    Else
                        left = left + anchorW + miGapDip
                    End If
                Case Else
                    If mbOnEdge Then
                        top = top - (h / 2)
                    Else
                        top = top - h - miGapDip
                    End If
            End Select
            mBase.SetLayoutAnimated(0, left, top, w, h)
        Case Else
            Dim left As Int = mBase.Left
            Dim top As Int = mBase.Top
            Select Case msPlacement
                Case "bottom-start"
                    left = miEdgeOffsetDip
                    If mbOnEdge Then
                        top = parent.Height - (h / 2)
                    Else
                        top = parent.Height - h - miEdgeOffsetDip
                    End If
                Case "bottom-center"
                    left = (parent.Width - w) / 2
                    If mbOnEdge Then
                        top = parent.Height - (h / 2)
                    Else
                        top = parent.Height - h - miEdgeOffsetDip
                    End If
                Case "top-end"
                    left = parent.Width - w - miEdgeOffsetDip
                    If mbOnEdge Then
                        top = -(h / 2)
                    Else
                        top = miEdgeOffsetDip
                    End If
                Case "top-start"
                    left = miEdgeOffsetDip
                    If mbOnEdge Then
                        top = -(h / 2)
                    Else
                        top = miEdgeOffsetDip
                    End If
                Case "top-center"
                    left = (parent.Width - w) / 2
                    If mbOnEdge Then
                        top = -(h / 2)
                    Else
                        top = miEdgeOffsetDip
                    End If
                Case "center-end"
                    If mbOnEdge Then
                        left = parent.Width - (w / 2)
                    Else
                        left = parent.Width - w - miEdgeOffsetDip
                    End If
                    top = (parent.Height - h) / 2
                Case "center-start"
                    If mbOnEdge Then
                        left = -(w / 2)
                    Else
                        left = miEdgeOffsetDip
                    End If
                    top = (parent.Height - h) / 2
                Case "center"
                    left = (parent.Width - w) / 2
                    top = (parent.Height - h) / 2
                Case Else
                    left = parent.Width - w - miEdgeOffsetDip
                    If mbOnEdge Then
                        top = parent.Height - (h / 2)
                    Else
                        top = parent.Height - h - miEdgeOffsetDip
                    End If
            End Select
            mBase.SetLayoutAnimated(0, left, top, w, h)
    End Select
End Sub

Private Sub GetVerticalHostLeft(BaseLeft As Int, TriggerWidth As Int, HostWidth As Int, ButtonWidth As Int) As Int
    Return BaseLeft + (TriggerWidth / 2) - HostWidth + (ButtonWidth / 2)
End Sub

Private Sub GetTriggerRectInParent As Map
    Return CreateMap("left": mBase.Left, "top": mBase.Top, "width": Max(ResolveButtonExtentDip(msTriggerSize), mBase.Width), "height": Max(ResolveButtonExtentDip(msTriggerSize), mBase.Height))
End Sub

Private Sub ResolveOverlayHost As B4XView
    Dim empty As B4XView
    If mvOverlayHost.IsInitialized Then Return mvOverlayHost
    If mBase.IsInitialized = False Then Return empty
    Return mBase.Parent
End Sub

Private Sub GetViewRectRelativeToAncestor(Target As B4XView, Ancestor As B4XView) As Map
    If Target.IsInitialized = False Then Return CreateMap("left": 0, "top": 0, "width": 0, "height": 0)
    Dim left As Int = 0
    Dim top As Int = 0
    Dim current As B4XView = Target
    Do While current.IsInitialized
        If current = Ancestor Then Exit
        left = left + current.Left
        top = top + current.Top
        If current.Parent.IsInitialized = False Then Exit
        current = current.Parent
    Loop
    Return CreateMap("left": left, "top": top, "width": Target.Width, "height": Target.Height)
End Sub
#End Region

#Region Events
Private Sub fabtrigger_Click(Tag As Object)
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", Tag)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If

    If HasExpandableContent = False Then Return
    If mbEnabled = False Then Return

    Select Case NormalizeRuntimeOpenMode
        Case "focus"
            Open
        Case Else
            Toggle
    End Select
End Sub

Private Sub fabclose_Click(Tag As Object)
    Dim closeTag As Object = Tag
    If closeTag = Null Then closeTag = ResolveCloseTriggerTag
    If xui.SubExists(mCallBack, mEventName & "_CloseClick", 1) Then
        CallSub2(mCallBack, mEventName & "_CloseClick", closeTag)
    End If
    Close
End Sub

Private Sub fabaction_Click(Tag As Object)
    If (Tag Is Map) = False Then Return
    Dim payload As Map = Tag
    Dim role As String = payload.GetDefault("role", "")
    Dim tagValue As Object = payload.Get("tag")
    Dim index As Int = payload.GetDefault("index", -1)

    Select Case role
        Case "main"
            If xui.SubExists(mCallBack, mEventName & "_MainActionClick", 1) Then
                CallSub2(mCallBack, mEventName & "_MainActionClick", tagValue)
            End If
            If mbAutoCloseOnActionClick Then Close
        Case "close"
            If xui.SubExists(mCallBack, mEventName & "_CloseClick", 1) Then
                CallSub2(mCallBack, mEventName & "_CloseClick", tagValue)
            End If
            Close
        Case Else
            If xui.SubExists(mCallBack, mEventName & "_ActionClick", 2) Then
                CallSub3(mCallBack, mEventName & "_ActionClick", index, tagValue)
            End If
            If mbAutoCloseOnActionClick Then Close
    End Select
End Sub

Private Sub fabbackdrop_Click
    If mbBackdropEnabled = False Then Return
    Close
End Sub
#End Region

#Region Helpers
Private Sub EnsureAllActionViews
    For Each rec As Map In lstActions
        EnsureActionView(rec)
    Next
    If mapMainAction.IsInitialized Then EnsureActionView(mapMainAction)
    If mapCloseAction.IsInitialized Then EnsureActionView(mapCloseAction)
End Sub

Private Sub RemoveActionViews(Rec As Map)
    If Rec.IsInitialized = False Then Return
    Dim host As B4XView = GetRecView(Rec, "Host")
    If host.IsInitialized Then host.RemoveViewFromParent
End Sub

Private Sub GetRecView(Rec As Map, Key As String) As B4XView
    Dim v As B4XView
    If Rec.IsInitialized = False Then Return v
    If Rec.ContainsKey(Key) = False Then Return v
    Dim value As Object = Rec.Get(Key)
    If value = Null Then Return v
    v = value
    Return v
End Sub

Private Sub GetRecButton(Rec As Map) As B4XDaisyButton
    Dim btn As B4XDaisyButton
    If Rec.IsInitialized = False Then Return btn
    If Rec.ContainsKey("Button") = False Then Return btn
    Dim value As Object = Rec.Get("Button")
    If value = Null Then Return btn
    btn = value
    Return btn
End Sub

Private Sub HasExpandableContent As Boolean
    If lstActions.IsInitialized And lstActions.Size > 0 Then Return True
    If mapMainAction.IsInitialized Then Return True
    If mapCloseAction.IsInitialized Then Return True
    Return False
End Sub

Private Sub NormalizePlacementMode(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "fixed"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "manual", "anchored", "fixed"
            Return s
        Case Else
            Return "fixed"
    End Select
End Sub

Private Sub NormalizePlacement(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "bottom-end"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "bottom-end", "bottom-start", "bottom-center", "top-end", "top-start", "top-center", "center-end", "center-start", "center"
            Return s
        Case Else
            Return "bottom-end"
    End Select
End Sub

Private Sub NormalizeAnchorAlignment(Value As String) As String
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

Private Sub NormalizeOpenMode(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "click"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "click", "hover", "focus"
            Return s
        Case Else
            Return "click"
    End Select
End Sub

Private Sub NormalizeRuntimeOpenMode As String
    If msLayoutMode = "toolbar" And msOpenMode = "hover" Then Return "click"
    #If B4A
    If msOpenMode = "hover" Then Return "click"
    #End If
    Return msOpenMode
End Sub

Private Sub NormalizeLayoutMode(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "vertical"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "vertical", "flower", "toolbar"
            Return s
        Case Else
            Return "vertical"
    End Select
End Sub

Private Sub NormalizeDirection(Value As String) As String
    Dim rawValue As String = Value
    If rawValue = Null Then rawValue = "top"
    Dim s As String = rawValue.ToLowerCase.Trim
    Select Case s
        Case "top", "right", "bottom", "left"
            Return s
        Case Else
            Return "top"
    End Select
End Sub

Private Sub ResolveButtonExtentDip(SizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 32dip
        Case "sm"
            Return 40dip
        Case "lg"
            Return 56dip
        Case "xl"
            Return 64dip
        Case Else
            Return 48dip
    End Select
End Sub

Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
    If Text = Null Or Text.Length = 0 Then Return 0
    Dim r As B4XRect = cvsMeasure.MeasureText(Text, Font1)
    Return Ceil(r.Width)
End Sub

Private Sub GetFlowerDegrees(Count As Int) As Float()
    Select Case Count
        Case 1
            Return Array As Float(135)
        Case 2
            Return Array As Float(165, 105)
        Case 3
            Return Array As Float(180, 135, 90)
        Case Else
            Return Array As Float(180, 150, 120, 90)
    End Select
End Sub

Private Sub GetFlowerRadiusDip(Count As Int) As Float
    Select Case Count
        Case 1, 2
            Return 84dip
        Case 3
            Return 96dip
        Case Else
            Return 112dip
    End Select
End Sub

Private Sub RotateFlowerDegree(BaseDegree As Float, DirectionValue As String) As Float
    Select Case DirectionValue
        Case "right"
            Return BaseDegree - 90
        Case "bottom"
            Return BaseDegree - 180
        Case "left"
            Return BaseDegree + 90
        Case Else
            Return BaseDegree
    End Select
End Sub

Private Sub ShouldToolbarDockTop As Boolean
    If msPlacement.StartsWith("top") Then Return True
    If msPlacement.StartsWith("bottom") Then Return False
    Return mBase.Top < (mBase.Parent.Height / 2)
End Sub

Private Sub BuildRuntimeProps As Map
    Dim props As Map
    props.Initialize
    props.Put("Enabled", mbEnabled)
    props.Put("Visible", mbVisible)
    props.Put("Open", mbOpen)
    props.Put("PlacementMode", msPlacementMode)
    props.Put("Placement", msPlacement)
    props.Put("AnchorAlignment", msAnchorAlignment)
    If mvAnchorTarget.IsInitialized Then props.Put("AnchorView", mvAnchorTarget)
    If mvOverlayHost.IsInitialized Then props.Put("OverlayHost", mvOverlayHost)
    props.Put("OnEdge", mbOnEdge)
    props.Put("OpenMode", msOpenMode)
    props.Put("LayoutMode", msLayoutMode)
    props.Put("Direction", msDirection)
    props.Put("BackdropEnabled", mbBackdropEnabled)
    props.Put("AutoCloseOnActionClick", mbAutoCloseOnActionClick)
    props.Put("TriggerText", msTriggerText)
    props.Put("TriggerVariant", msTriggerVariant)
    props.Put("TriggerStyle", msTriggerStyle)
    props.Put("TriggerSize", msTriggerSize)
    props.Put("ChildActionSize", msChildActionSize)
    props.Put("TriggerIconName", msTriggerIconName)
    props.Put("TriggerCircle", mbTriggerCircle)
    props.Put("UseMainAction", mbUseMainAction)
    props.Put("MainActionText", msMainActionText)
    props.Put("MainActionVariant", msMainActionVariant)
    props.Put("MainActionIconName", msMainActionIconName)
    props.Put("UseCloseAction", mbUseCloseAction)
    props.Put("CloseActionText", msCloseActionText)
    props.Put("CloseActionVariant", msCloseActionVariant)
    props.Put("CloseActionIconName", msCloseActionIconName)
    Return props
End Sub
#End Region
