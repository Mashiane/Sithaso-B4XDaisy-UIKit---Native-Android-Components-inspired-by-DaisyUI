B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

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
#DesignerProperty: Key: Opened, DisplayName: Opened, FieldType: Boolean, DefaultValue: False, Description: Initial open state.
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
#DesignerProperty: Key: TriggerSizeDip, DisplayName: Trigger Size (dip), FieldType: Int, DefaultValue: 56, MinRange: 0, Description: Explicit trigger button extent in dip. 0 = use TriggerSize token.
#DesignerProperty: Key: TriggerIconSize, DisplayName: Trigger Icon Size (dip), FieldType: Int, DefaultValue: 24, MinRange: 0, Description: Explicit trigger icon size in dip. 0 = auto from size token.
#DesignerProperty: Key: ChildActionSizeDip, DisplayName: Child Action Size (dip), FieldType: Int, DefaultValue: 40, MinRange: 0, Description: Explicit child action button extent in dip. 0 = use ChildActionSize token.
#DesignerProperty: Key: ChildActionIconSize, DisplayName: Child Action Icon Size (dip), FieldType: Int, DefaultValue: 20, MinRange: 0, Description: Explicit child action icon size in dip. 0 = auto from size token.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, MinRange: 0, MaxRange: 2000, Description: Duration in milliseconds for trigger and action button transition animations (0 = instant).
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

	' Explicit dip defaults (0 = fall back to the size token). These let the FAB
	' use exact Material-style dimensions: trigger 56dip / icon 24dip, child 40dip / icon 20dip.
	Private miTriggerSizeDip As Int = 56dip
	Private miTriggerIconDip As Int = 24dip
	Private miChildSizeDip As Int = 40dip
	Private miChildIconDip As Int = 20dip

	Private mvAnchorTarget As B4XView
	Private mvOverlayHost As B4XView

	Private Const TRIGGER_TRANSITION_DURATION_MS As Int = 180
	Private miDuration As Int = 300
	' Monotonic token used to cancel a deferred ApplyClosedState when the FAB is
	' reopened (or closed again) while the close cross-fade is still playing.
	Private miCloseToken As Int = 0
	Private btnTrigger As B4XDaisyButton
	Private vTrigger As B4XView
	Private btnCloseTrigger As B4XDaisyButton
	Private vCloseTrigger As B4XView
	Private mTriggerTransition As B4XDaisyAnimation
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
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	lstActions.Initialize
	mTriggerTransition.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
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
	ApplyDesignerProps(mProps)
	EnsureOverlayAttached
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
	mbOpen = B4XDaisyVariants.GetPropBool(mProps, "Open", mbOpen)
	msPlacementMode = NormalizePlacementMode(B4XDaisyVariants.GetPropString(mProps, "PlacementMode", msPlacementMode))
	msPlacement = NormalizePlacement(B4XDaisyVariants.GetPropString(mProps, "Placement", msPlacement))
	msAnchorAlignment = NormalizeAnchorAlignment(B4XDaisyVariants.GetPropString(mProps, "AnchorAlignment", msAnchorAlignment))
	mbOnEdge = B4XDaisyVariants.GetPropBool(mProps, "OnEdge", mbOnEdge)
	msOpenMode = NormalizeOpenMode(B4XDaisyVariants.GetPropString(mProps, "OpenMode", msOpenMode))
	msLayoutMode = NormalizeLayoutMode(B4XDaisyVariants.GetPropString(mProps, "LayoutMode", msLayoutMode))
	msDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(mProps, "Direction", msDirection))
	mbBackdropEnabled = B4XDaisyVariants.GetPropBool(mProps, "BackdropEnabled", mbBackdropEnabled)
	mbAutoCloseOnActionClick = B4XDaisyVariants.GetPropBool(mProps, "AutoCloseOnActionClick", mbAutoCloseOnActionClick)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))

	msTriggerText = B4XDaisyVariants.GetPropString(mProps, "TriggerText", msTriggerText)
	msTriggerVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "TriggerVariant", msTriggerVariant))
	msTriggerStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "TriggerStyle", msTriggerStyle))
	msTriggerSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "TriggerSize", msTriggerSize))
	msChildActionSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "ChildActionSize", msChildActionSize))
	miTriggerSizeDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "TriggerSizeDip", miTriggerSizeDip))
	miTriggerIconDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "TriggerIconSize", miTriggerIconDip))
	miChildSizeDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "ChildActionSizeDip", miChildSizeDip))
	miChildIconDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "ChildActionIconSize", miChildIconDip))
	msTriggerIconName = B4XDaisyVariants.GetPropString(mProps, "TriggerIconName", msTriggerIconName)
	mbTriggerCircle = B4XDaisyVariants.GetPropBool(mProps, "TriggerCircle", mbTriggerCircle)

	mbUseMainAction = B4XDaisyVariants.GetPropBool(mProps, "UseMainAction", mbUseMainAction)
	msMainActionText = B4XDaisyVariants.GetPropString(mProps, "MainActionText", msMainActionText)
	msMainActionVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "MainActionVariant", msMainActionVariant))
	msMainActionIconName = B4XDaisyVariants.GetPropString(mProps, "MainActionIconName", msMainActionIconName)

	mbUseCloseAction = B4XDaisyVariants.GetPropBool(mProps, "UseCloseAction", mbUseCloseAction)
	msCloseActionText = B4XDaisyVariants.GetPropString(mProps, "CloseActionText", msCloseActionText)
	msCloseActionVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "CloseActionVariant", msCloseActionVariant))
	msCloseActionIconName = B4XDaisyVariants.GetPropString(mProps, "CloseActionIconName", msCloseActionIconName)

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
	btnTrigger.ButtonSizeDip = miTriggerSizeDip
	btnTrigger.IconSize = miTriggerIconDip
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
	btnCloseTrigger.ButtonSizeDip = miTriggerSizeDip
	btnCloseTrigger.IconSize = miTriggerIconDip
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

	' Ensure FAB and its overlay stay above sibling views (e.g. ScrollView)
	BringToFront

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

	' Detach overlay only if its parent is a different view than overlayHost.
	' Use IsSameView for reliable native-view identity comparison.
	Dim currentParent As B4XView = pnlOverlay.Parent
	If currentParent.IsInitialized And IsSameView(currentParent, overlayHost) = False Then
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

	' Disable clipping on the overlay and action layer so that views with
	' translationX/Y or scale transforms (flower animation) are not clipped
	' to their layout bounds by Android's default setClipChildren=true.
	B4XDaisyVariants.DisableClipping(pnlOverlay)
	B4XDaisyVariants.DisableClipping(pnlActionLayer)
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

Private Sub BuildActionRecord(sRole As String, sText As String, sLabelText As String, sVariant As String, sStyle As String, sSize As String, sIconName As String, bCircle As Boolean, oTagValue As Object) As Map
	Dim rec As Map
	rec.Initialize
	rec.Put("Role", sRole)
	rec.Put("Text", IIf(sText = Null, "", sText))
	rec.Put("Label", IIf(sLabelText = Null, "", sLabelText))
	rec.Put("Variant", B4XDaisyVariants.NormalizeVariant(sVariant))
	rec.Put("Style", B4XDaisyVariants.NormalizeStyle(sStyle))
	rec.Put("Size", B4XDaisyVariants.NormalizeSize(sSize))
	rec.Put("IconName", IIf(sIconName = Null, "", sIconName))
	rec.Put("Circle", bCircle)
	rec.Put("Tag", oTagValue)
	rec.Put("Visible", True)
	Return rec
End Sub

Private Sub EnsureActionView(mRec As Map)
	EnsureOverlayAttached
	If mRec.IsInitialized = False Or pnlActionLayer.IsInitialized = False Then Return

	Dim host As B4XView = GetRecView(mRec, "Host")
	If host.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		host = p
		host.Color = xui.Color_Transparent
		pnlActionLayer.AddView(host, 0, 0, 10dip, 10dip)
		mRec.Put("Host", host)
	End If

	Dim lbl As B4XView = mRec.Get("LabelView")
	If lbl.IsInitialized = False Then
		Dim l As Label
		l.Initialize("")
		lbl = l
		lbl.Color = xui.Color_Transparent
		lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
		lbl.SetTextAlignment("LEFT", "CENTER")
		host.AddView(lbl, 0, 0, 1dip, 1dip)
		mRec.Put("LabelView", lbl)
	End If

	Dim btn As B4XDaisyButton = GetRecButton(mRec)
	Dim btnView As B4XView = GetRecView(mRec, "ButtonView")
	If btn.IsInitialized = False Or btnView.IsInitialized = False Then
		Dim actBtn As B4XDaisyButton
		actBtn.Initialize(Me, "fabaction")
		btn = actBtn
		btnView = btn.AddToParent(host, 0, 0, 0, 0)
		mRec.Put("Button", btn)
		mRec.Put("ButtonView", btnView)
	End If

	ApplyActionAppearance(mRec)
End Sub

Private Sub ApplyActionAppearance(mRec As Map)
	If mRec.IsInitialized = False Then Return
	Dim btn As B4XDaisyButton = GetRecButton(mRec)
	Dim btnView As B4XView = GetRecView(mRec, "ButtonView")
	Dim lbl As B4XView = GetRecView(mRec, "LabelView")
	If btn.IsInitialized = False Or btnView.IsInitialized = False Then Return

	If btn.Text <> mRec.Get("Text") Then btn.Text = mRec.Get("Text")
	If btn.Variant <> mRec.Get("Variant") Then btn.Variant = mRec.Get("Variant")
	If btn.Style <> mRec.Get("Style") Then btn.Style = mRec.Get("Style")
	If btn.Size <> mRec.Get("Size") Then btn.Size = mRec.Get("Size")
	If btn.Circle <> mRec.Get("Circle") Then btn.Circle = mRec.Get("Circle")
	If btn.IconName <> mRec.Get("IconName") Then btn.IconName = mRec.Get("IconName")
	If btn.Disabled <> Not(mbEnabled) Then btn.Disabled = Not(mbEnabled)
	' Apply explicit dip sizing per role: child actions vs trigger-replacement specials.
	If mRec.Get("Role") = "action" Then
		btn.ButtonSizeDip = miChildSizeDip
		btn.IconSize = miChildIconDip
	Else
		btn.ButtonSizeDip = miTriggerSizeDip
		btn.IconSize = miTriggerIconDip
	End If

	Dim payload As Map = CreateMap("role": mRec.Get("Role"), "tag": mRec.Get("Tag"))
	If mRec.Get("Role") = "action" Then
		payload.Put("index", lstActions.IndexOf(mRec))
	Else
		payload.Put("index", -1)
	End If
	btn.Tag = payload

	Dim labelText As String = mRec.Get("Label")
	If lbl.IsInitialized Then
		lbl.Text = labelText
		lbl.Visible = labelText.Length > 0 And msLayoutMode <> "toolbar"
	End If

	btnView.Visible = mRec.GetDefault("Visible", True)
End Sub
#End Region

#Region Public API
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		DesignerCreateView(p, Null, BuildRuntimeProps)
	End If

	' Hide during initial positioning to prevent visible slide from (0,0)
	Dim wasVisible As Boolean = mbVisible
	mBase.Visible = False

	Dim targetW As Int = Max(ResolveTriggerExtentDip, iWidth)
	Dim targetH As Int = Max(ResolveTriggerExtentDip, iHeight)
	vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
	EnsureOverlayAttached
	ApplyPlacementIfNeeded
	Base_Resize(mBase.Width, mBase.Height)

	' Restore visibility after positioning is complete
	mBase.Visible = wasVisible
	If vTrigger.IsInitialized Then vTrigger.Visible = wasVisible
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

	' Cancel any pending deferred close so it cannot snap the closed state over our open.
	miCloseToken = miCloseToken + 1
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
	miCloseToken = miCloseToken + 1
	Dim myToken As Int = miCloseToken
	' For flower mode: skip the miDuration pre-sleep - HideFlowerActionsAnimated
	' owns the full collapse timing (200ms). For other modes: wait for the trigger
	' cross-fade before snapping closed.
	If msLayoutMode <> "flower" And miDuration > 0 Then
		Sleep(miDuration)
		If miCloseToken <> myToken Then Return
		If mbOpen Then Return
	End If
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

Public Sub AddActionEx(sText As String, sLabelText As String, sVariant As String, sStyle As String, sSize As String, sIconName As String, bCircle As Boolean, oTagValue As Object) As Int
	Dim rec As Map = BuildActionRecord("action", sText, sLabelText, sVariant, sStyle, sSize, sIconName, bCircle, oTagValue)
	lstActions.Add(rec)
	mbActionViewsWarmed = False
	ScheduleActionWarmup
	If mbOpen Then LayoutOpenState
	Return lstActions.Size - 1
End Sub

Public Sub AddAction(oTagValue As Object, sVariant As String, sIconName As String) As Int
	Return AddActionEx("", "", sVariant, "solid", msChildActionSize, sIconName, True, oTagValue)
End Sub

Public Sub AddActionDetailed(sText As String, sLabelText As String, sVariant As String, sIconName As String, oTagValue As Object) As Int
	Return AddActionEx(sText, sLabelText, sVariant, "solid", msChildActionSize, sIconName, True, oTagValue)
End Sub

Public Sub SetMainAction(sText As String, sLabelText As String, sVariant As String, sIconName As String, oTagValue As Object)
	mbUseMainAction = True
	mbUseCloseAction = False
	mapMainAction = BuildActionRecord("main", sText, sLabelText, sVariant, "solid", msTriggerSize, sIconName, True, oTagValue)
	Dim emptyClose As Map
	mapCloseAction = emptyClose
	mbActionViewsWarmed = False
	ScheduleActionWarmup
	If mbOpen Then LayoutOpenState
End Sub

Public Sub SetCloseAction(sText As String, sLabelText As String, sVariant As String, sIconName As String, oTagValue As Object)
	mbUseCloseAction = True
	mbUseMainAction = False
	mapCloseAction = BuildActionRecord("close", sText, sLabelText, sVariant, "solid", msTriggerSize, sIconName, True, oTagValue)
	Dim emptyMain As Map
	mapMainAction = emptyMain
	mbActionViewsWarmed = False
	ScheduleActionWarmup
	If mbOpen Then LayoutOpenState
End Sub

Public Sub GetActionButtonView(iIndex As Int) As B4XView
	Dim empty As B4XView
	If iIndex < 0 Or iIndex >= lstActions.Size Then Return empty
	Dim rec As Map = lstActions.Get(iIndex)
	EnsureActionView(rec)
	Dim v As B4XView = GetRecView(rec, "ButtonView")
	Return v
End Sub

Public Sub SetActionVisible(iIndex As Int, bValue As Boolean)
	If iIndex < 0 Or iIndex >= lstActions.Size Then Return
	Dim rec As Map = lstActions.Get(iIndex)
	rec.Put("Visible", bValue)
	If mbOpen Then LayoutOpenState
End Sub

Public Sub setAnchorTarget(vValue As B4XView)
	mvAnchorTarget = vValue
	If mBase.IsInitialized = False Then Return
	ApplyPlacementIfNeeded
	If mbOpen Then LayoutOpenState
End Sub

Public Sub getAnchorTarget As B4XView
	Return mvAnchorTarget
End Sub

Public Sub setAnchorAlignment(sValue As String)
	msAnchorAlignment = NormalizeAnchorAlignment(sValue)
	If mBase.IsInitialized = False Then Return
	ApplyPlacementIfNeeded
	If mbOpen Then LayoutOpenState
End Sub

Public Sub getAnchorAlignment As String
	Return msAnchorAlignment
End Sub

Public Sub setAnchorView(vValue As B4XView)
	setAnchorTarget(vValue)
End Sub

Public Sub getAnchorView As B4XView
	Return mvAnchorTarget
End Sub

Public Sub setOverlayHost(vValue As B4XView)
	mvOverlayHost = vValue
	If mBase.IsInitialized = False Then Return
	EnsureOverlayAttached
	ApplyPlacementIfNeeded
	If mbOpen Then LayoutOpenState
End Sub

Public Sub getOverlayHost As B4XView
	Return mvOverlayHost
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
	EnsureOverlayAttached
	If mbOpen Then LayoutOpenState
End Sub

Public Sub Resize(dWidth As Double, dHeight As Double)
	Base_Resize(dWidth, dHeight)
End Sub

Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
	If pnlOverlay.IsInitialized And pnlOverlay.Parent.IsInitialized Then pnlOverlay.BringToFront
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized = False Then Return
	mBase.Left = iValue
	If mbOpen Then LayoutOpenState
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Left
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized = False Then Return
	mBase.Top = iValue
	If mbOpen Then LayoutOpenState
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Top
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
	If btnTrigger.IsInitialized Then btnTrigger.Tag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
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
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getVisible As Boolean
	Return mbVisible
End Sub

''' <summary>
''' Sets the transition animation duration in milliseconds (0 = instant).
''' </summary>
Public Sub setDuration(iValue As Int)
	miDuration = Max(0, iValue)
End Sub

''' <summary>
''' Returns the transition animation duration in milliseconds.
''' </summary>
Public Sub getDuration As Int
	Return miDuration
End Sub

Public Sub setOpened(bValue As Boolean)
	mbOpen = bValue
	If mBase.IsInitialized = False Then Return
	If bValue Then Open Else Close
End Sub

Public Sub getOpened As Boolean
	Return mbOpen
End Sub

' ponytail: explicit boolean accessor. `Public Sub Open` (the open-action
' method) shadows the `Open` property getter when read as `fab.Open`, so B4A
' resolves `fab.Open` to the void method and ObjectToBoolean("") throws
' "Cannot parse:  as boolean" (crash on back-press from a FAB page).
' Use IsOpen to read the open state unambiguously.
Public Sub IsOpen As Boolean
	Return mbOpen
End Sub

Public Sub setPlacementMode(sValue As String)
	msPlacementMode = NormalizePlacementMode(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPlacementMode As String
	Return msPlacementMode
End Sub

Public Sub setPlacement(sValue As String)
	msPlacement = NormalizePlacement(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getPlacement As String
	Return msPlacement
End Sub

Public Sub setOnEdge(bValue As Boolean)
	mbOnEdge = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getOnEdge As Boolean
	Return mbOnEdge
End Sub

Public Sub setOpenMode(sValue As String)
	msOpenMode = NormalizeOpenMode(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getOpenMode As String
	Return msOpenMode
End Sub

Public Sub setLayoutMode(sValue As String)
	msLayoutMode = NormalizeLayoutMode(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getLayoutMode As String
	Return msLayoutMode
End Sub

Public Sub setDirection(sValue As String)
	msDirection = NormalizeDirection(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDirection As String
	Return msDirection
End Sub

Public Sub setBackdropEnabled(bValue As Boolean)
	mbBackdropEnabled = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackdropEnabled As Boolean
	Return mbBackdropEnabled
End Sub

Public Sub setAutoCloseOnActionClick(bValue As Boolean)
	mbAutoCloseOnActionClick = bValue
End Sub

Public Sub getAutoCloseOnActionClick As Boolean
	Return mbAutoCloseOnActionClick
End Sub

Public Sub setTriggerText(sValue As String)
	msTriggerText = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerText As String
	Return msTriggerText
End Sub

Public Sub setTriggerVariant(sValue As String)
	msTriggerVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerVariant As String
	Return msTriggerVariant
End Sub

Public Sub setTriggerStyle(sValue As String)
	msTriggerStyle = B4XDaisyVariants.NormalizeStyle(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerStyle As String
	Return msTriggerStyle
End Sub

Public Sub setTriggerSize(sValue As String)
	msTriggerSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerSize As String
	Return msTriggerSize
End Sub

Public Sub setChildActionSize(sValue As String)
	msChildActionSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getChildActionSize As String
	Return msChildActionSize
End Sub

' Explicit dip sizing. 0 = fall back to the corresponding size token.
Public Sub setTriggerSizeDip(iValue As Int)
	miTriggerSizeDip = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerSizeDip As Int
	Return miTriggerSizeDip
End Sub

Public Sub setTriggerIconSize(iValue As Int)
	miTriggerIconDip = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerIconSize As Int
	Return miTriggerIconDip
End Sub

Public Sub setChildActionSizeDip(iValue As Int)
	miChildSizeDip = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getChildActionSizeDip As Int
	Return miChildSizeDip
End Sub

Public Sub setChildActionIconSize(iValue As Int)
	miChildIconDip = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getChildActionIconSize As Int
	Return miChildIconDip
End Sub

Public Sub setTriggerIconName(sValue As String)
	msTriggerIconName = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerIconName As String
	Return msTriggerIconName
End Sub

Public Sub setTriggerCircle(bValue As Boolean)
	mbTriggerCircle = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTriggerCircle As Boolean
	Return mbTriggerCircle
End Sub

Public Sub setUseMainAction(bValue As Boolean)
	mbUseMainAction = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getUseMainAction As Boolean
	Return mbUseMainAction
End Sub

Public Sub setMainActionText(sValue As String)
	msMainActionText = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMainActionText As String
	Return msMainActionText
End Sub

Public Sub setMainActionVariant(sValue As String)
	msMainActionVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMainActionVariant As String
	Return msMainActionVariant
End Sub

Public Sub setMainActionIconName(sValue As String)
	msMainActionIconName = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getMainActionIconName As String
	Return msMainActionIconName
End Sub

Public Sub setUseCloseAction(bValue As Boolean)
	mbUseCloseAction = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getUseCloseAction As Boolean
	Return mbUseCloseAction
End Sub

Public Sub setCloseActionText(sValue As String)
	msCloseActionText = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCloseActionText As String
	Return msCloseActionText
End Sub

Public Sub setCloseActionVariant(sValue As String)
	msCloseActionVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getCloseActionVariant As String
	Return msCloseActionVariant
End Sub

Public Sub setCloseActionIconName(sValue As String)
	msCloseActionIconName = IIf(sValue = Null, "", sValue)
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
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return

	If inResize Then Return
	inResize = True
	BuildTriggerIfNeeded
	BuildCloseTriggerIfNeeded
	SyncTriggerButtons

	Dim triggerExtent As Int = ResolveTriggerExtentDip
	Dim targetW As Int = Max(triggerExtent, dWidth)
	Dim targetH As Int = Max(triggerExtent, dHeight)
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
	inResize = False
End Sub

Private Sub UpdateTriggerTransition(bOpenState As Boolean, bAnimate As Boolean)
	If vTrigger.IsInitialized = False Then Return

	Dim showClose As Boolean = bOpenState And mbUseCloseAction And vCloseTrigger.IsInitialized
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

	If bAnimate Then
		AnimateTriggerView(vTrigger, triggerAlpha, triggerScale, triggerRotation, miDuration)
		If vCloseTrigger.IsInitialized Then AnimateTriggerView(vCloseTrigger, closeAlpha, closeScale, closeRotation, miDuration)
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

Private Sub AnimateTriggerView(vViewRef As B4XView, fAlphaValue As Float, fScaleValue As Float, fRotationValue As Float, iDurationMs As Int)
	If vViewRef.IsInitialized = False Then Return
    #If B4A
	Dim jo As JavaObject = vViewRef
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	' setDuration must be configured BEFORE alpha/rotation/scaleX/scaleY, because those
	' property methods auto-start the ViewPropertyAnimator; calling setDuration afterwards
	' does not apply to the already-running animation (the swap then appeared instant).
	Dim trigDurationMs As Long = Max(0, iDurationMs)
	Try
		anim.RunMethod("setDuration", Array As Object(trigDurationMs))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFab.AnimateTriggerView: " & LastException.Message)
	End Try
	anim.RunMethod("alpha", Array As Object(fAlphaValue))
	anim.RunMethod("rotation", Array As Object(fRotationValue))
	anim.RunMethod("scaleX", Array As Object(fScaleValue))
	anim.RunMethod("scaleY", Array As Object(fScaleValue))
	anim.RunMethod("start", Null)
    #Else
    mTriggerTransition.SetNativeAlpha(vViewRef, fAlphaValue)
    mTriggerTransition.SetNativeRotation(vViewRef, fRotationValue)
    SetNativeScale(vViewRef, fScaleValue, fScaleValue)
    Dim ignore As Int = iDurationMs
    #End If
End Sub

''' <summary>
''' Animates an action host button fading/scaling in when the FAB opens, mirroring the
''' trigger transition approach (native Android view property animator). Staggered by slot.
''' </summary>
Private Sub AnimateActionHostIn(vHostView As B4XView, iSlotIndex As Int)
	If vHostView.IsInitialized = False Then Return
	If miDuration <= 0 Then Return
    #If B4A
	mTriggerTransition.SetNativeAlpha(vHostView, 0)
	SetNativeScale(vHostView, 0.6, 0.6)
	' ViewPropertyAnimator.alpha/scaleX/scaleY take float params. B4A boxes a value
	' by its declared type, so we must pass Float (and Long for delay/duration)
	' variables, or JavaObject cannot match the method and throws "Method not matched".
	Dim targetAlpha As Float = 1
	Dim targetScale As Float = 1
	Dim delayMs As Long = Min(150, iSlotIndex * 35)
	Dim durationMs As Long = Max(0, miDuration)
	Dim jo As JavaObject = vHostView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(durationMs))
		anim.RunMethod("setStartDelay", Array As Object(delayMs))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFab.AnimateActionHostIn: " & LastException.Message)
	End Try
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	anim.RunMethod("scaleX", Array As Object(targetScale))
	anim.RunMethod("scaleY", Array As Object(targetScale))
	anim.RunMethod("start", Null)
    #End If
End Sub

Private Sub SetNativeScale(vView As B4XView, fSx As Float, fSy As Float)
    #If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setScaleX", Array As Object(fSx))
	jo.RunMethod("setScaleY", Array As Object(fSy))
    #Else
    Dim ignore As Object = vView
    Dim ignoreX As Float = fSx
    Dim ignoreY As Float = fSy
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
		AnimateActionHostIn(host, slot)
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

		' Place host at its FINAL layout position immediately.
		' Use translationX/Y to offset it visually back to the trigger center,
		' then animate translation to 0 so it appears to fly out from the trigger.
		' NOTE: BringToFront/SetLayoutAnimated/Visible are applied FIRST, and the
		' hidden (offset/scaled-down/transparent) state is applied LAST, immediately
		' before the Sleep+animate call. Previously the hidden state was set before
		' these calls, and something in that sequence (a deferred relayout pass or
		' BringToFront) was resetting translation/scale/alpha back to normal before
		' AnimateFlowerHostOut ever captured a "from" value, so the tween had nothing
		' to interpolate and the host just appeared instantly at its final position.
		host.BringToFront
		host.SetLayoutAnimated(0, x, y, hostW, hostH)
		LayoutHostContents(rec, True)
		host.Visible = True
		Dim offsetX As Float = (centerX - (hostW / 2)) - x
		Dim offsetY As Float = (centerY - (hostH / 2)) - y
		SetNativeTranslation(host, offsetX, offsetY)
		mTriggerTransition.SetNativeAlpha(host, 0)
		SetNativeScale(host, 0.1, 0.1)
		Sleep(Max(1, i * 30))
		If mbOpen = False Then Return
		AnimateFlowerHostOut(host, 250)
	Next
End Sub

' Animates a flower action host from its current translation offset to its final
' layout position (translationX/Y -> 0), fading and scaling in simultaneously.
Private Sub AnimateFlowerHostOut(vHostView As B4XView, iDurationMs As Int)
	If vHostView.IsInitialized = False Then Return
    #If B4A
	Dim targetAlpha As Float = 1
	Dim targetScale As Float = 1
	Dim targetTx As Float = 0
	Dim targetTy As Float = 0
	Dim dur As Long = Max(0, iDurationMs)
	Dim jo As JavaObject = vHostView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(dur))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFab.AnimateFlowerHostOut: " & LastException.Message)
	End Try
	anim.RunMethod("translationX", Array As Object(targetTx))
	anim.RunMethod("translationY", Array As Object(targetTy))
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	anim.RunMethod("scaleX", Array As Object(targetScale))
	anim.RunMethod("scaleY", Array As Object(targetScale))
	anim.RunMethod("start", Null)
    #Else
    mTriggerTransition.SetNativeAlpha(vHostView, 1)
    SetNativeScale(vHostView, 1, 1)
    SetNativeTranslation(vHostView, 0, 0)
    Dim ignore As Int = iDurationMs
    #End If
End Sub

Private Sub SetNativeTranslation(vView As B4XView, fTx As Float, fTy As Float)
    #If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setTranslationX", Array As Object(fTx))
	jo.RunMethod("setTranslationY", Array As Object(fTy))
    #Else
    Dim ignore As Object = vView
    Dim ignoreTx As Float = fTx
    Dim ignoreTy As Float = fTy
    #End If
End Sub

Private Sub HideFlowerActionsAnimated
	Dim triggerRect As Map = GetTriggerRectInParent
	Dim centerX As Float = triggerRect.Get("left") + (triggerRect.Get("width") / 2)
	Dim centerY As Float = triggerRect.Get("top") + (triggerRect.Get("height") / 2)
	Dim myToken As Int = miCloseToken

	For Each rec As Map In lstActions
		Dim host As B4XView = GetRecView(rec, "Host")
		If host.IsInitialized = False Then Continue
		If host.Visible = False Then Continue
		' Animate translation toward trigger center, scale and fade out.
		Dim targetTx As Float = (centerX - (host.Width / 2)) - host.Left
		Dim targetTy As Float = (centerY - (host.Height / 2)) - host.Top
		AnimateFlowerHostIn(host, targetTx, targetTy, 200)
	Next
	Sleep(200)
	If miCloseToken <> myToken Then Return
	If mbOpen Then Return
	' Reset translation so hosts are clean for next open.
	For Each rec As Map In lstActions
		Dim host As B4XView = GetRecView(rec, "Host")
		If host.IsInitialized Then SetNativeTranslation(host, 0, 0)
	Next
	HideAllActionHosts
	' Now safe to hide the overlay: the 200ms collapse animation has completed
	' and the token/open checks above confirmed no new open has been issued.
	If pnlOverlay.IsInitialized Then pnlOverlay.Visible = False
End Sub

' Animates a flower host collapsing back toward the trigger (translation + fade/scale out).
Private Sub AnimateFlowerHostIn(vHostView As B4XView, fTargetTx As Float, fTargetTy As Float, iDurationMs As Int)
	If vHostView.IsInitialized = False Then Return
    #If B4A
	Dim targetAlpha As Float = 0
	Dim targetScale As Float = 0.1
	Dim dur As Long = Max(0, iDurationMs)
	Dim jo As JavaObject = vHostView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(dur))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFab.AnimateFlowerHostIn: " & LastException.Message)
	End Try
	anim.RunMethod("translationX", Array As Object(fTargetTx))
	anim.RunMethod("translationY", Array As Object(fTargetTy))
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	anim.RunMethod("scaleX", Array As Object(targetScale))
	anim.RunMethod("scaleY", Array As Object(targetScale))
	anim.RunMethod("start", Null)
    #Else
    mTriggerTransition.SetNativeAlpha(vHostView, 0)
    SetNativeScale(vHostView, 0.1, 0.1)
    SetNativeTranslation(vHostView, fTargetTx, fTargetTy)
    Dim ignore As Int = iDurationMs
    #End If
End Sub

Private Sub ApplyClosedState
	If msLayoutMode = "flower" Then
		' For flower mode: HideFlowerActionsAnimated plays the 200ms collapse
		' animation while keeping the overlay visible, then hides the overlay
		' and action hosts itself after the sleep completes.
		' Do NOT hide the overlay here - doing so would make the collapse
		' animation invisible.
		HideFlowerActionsAnimated
	Else
		If pnlOverlay.IsInitialized Then pnlOverlay.Visible = False
		HideAllActionHosts
	End If
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
		mTriggerTransition.SetNativeAlpha(host, 0)
		SetNativeScale(host, 0.6, 0.6)
		host.Visible = True
		host.BringToFront
		AnimateActionHostIn(host, i)
	Next
End Sub

Private Sub LayoutSpecialAtTrigger(mRec As Map, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mRec.IsInitialized = False Then Return
	EnsureActionView(mRec)
	Dim host As B4XView = GetRecView(mRec, "Host")
	host.SetLayoutAnimated(0, iLeft, iTop, iWidth, iHeight)
	LayoutHostContents(mRec, True)
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

Private Sub MeasureActionHost(mRec As Map, bFlowerMode As Boolean) As Map
	EnsureActionView(mRec)
	Dim btnView As B4XView = GetRecView(mRec, "ButtonView")
	Dim lbl As B4XView = GetRecView(mRec, "LabelView")
	Dim buttonW As Int = Max(ResolveActionExtentDip(mRec), btnView.Width)
	Dim buttonH As Int = Max(ResolveActionExtentDip(mRec), btnView.Height)
	Dim labelW As Int = 0
	If bFlowerMode = False And lbl.IsInitialized And lbl.Text.Length > 0 Then
		labelW = MeasureTextWidth(lbl.Text, xui.CreateDefaultFont(14)) + 6dip
	End If
	Dim totalW As Int = buttonW + IIf(labelW > 0, labelW + 8dip, 0)
	Dim totalH As Int = Max(buttonH, 28dip)
	Return CreateMap("width": totalW, "height": totalH, "buttonW": buttonW, "buttonH": buttonH, "labelW": labelW)
End Sub

Private Sub LayoutHostContents(mRec As Map, bButtonOnly As Boolean)
	Dim host As B4XView = GetRecView(mRec, "Host")
	Dim btnView As B4XView = GetRecView(mRec, "ButtonView")
	Dim btn As B4XDaisyButton = GetRecButton(mRec)
	Dim lbl As B4XView = GetRecView(mRec, "LabelView")
	If host.IsInitialized = False Or btnView.IsInitialized = False Or btn.IsInitialized = False Then Return

	Dim info As Map = MeasureActionHost(mRec, bButtonOnly)
	Dim buttonW As Int = info.Get("buttonW")
	Dim buttonH As Int = info.Get("buttonH")
	Dim labelW As Int = info.Get("labelW")

	If bButtonOnly Then
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
	Dim w As Int = Max(ResolveTriggerExtentDip, mBase.Width)
	Dim h As Int = Max(ResolveTriggerExtentDip, mBase.Height)

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

Private Sub GetVerticalHostLeft(iBaseLeft As Int, iTriggerWidth As Int, iHostWidth As Int, iButtonWidth As Int) As Int
	Return iBaseLeft + (iTriggerWidth / 2) - iHostWidth + (iButtonWidth / 2)
End Sub

Private Sub GetTriggerRectInParent As Map
	Return CreateMap("left": mBase.Left, "top": mBase.Top, "width": Max(ResolveTriggerExtentDip, mBase.Width), "height": Max(ResolveTriggerExtentDip, mBase.Height))
End Sub

Private Sub ResolveOverlayHost As B4XView
	Dim empty As B4XView
	If mvOverlayHost.IsInitialized Then Return mvOverlayHost
	If mBase.IsInitialized = False Then Return empty
	Return mBase.Parent
End Sub

Private Sub GetViewRectRelativeToAncestor(vTarget As B4XView, vAncestor As B4XView) As Map
	If vTarget.IsInitialized = False Then Return CreateMap("left": 0, "top": 0, "width": 0, "height": 0)
    #If B4A
	' Use getLocationOnScreen ONLY if view is attached to a window and has non-zero screen coordinates.
	' During page initialization (before first draw), getLocationOnScreen returns [0,0] for all views,
	' which causes anchored views (like FABs on Navbar) to briefly calculate left=0 and then slide to their real position.
	Try
		Dim joTarget As JavaObject = vTarget
		Dim loc(2) As Int
		joTarget.RunMethod("getLocationOnScreen", Array(loc))
		Dim targetScreenX As Int = loc(0)
		Dim targetScreenY As Int = loc(1)
		Dim joAncestor As JavaObject = vAncestor
		joAncestor.RunMethod("getLocationOnScreen", Array(loc))
		Dim ancestorScreenX As Int = loc(0)
		Dim ancestorScreenY As Int = loc(1)
		If targetScreenX <> 0 Or targetScreenY <> 0 Or ancestorScreenX <> 0 Or ancestorScreenY <> 0 Then
			Return CreateMap("left": targetScreenX - ancestorScreenX, "top": targetScreenY - ancestorScreenY, _
				"width": GetSafeWidth(vTarget), "height": GetSafeHeight(vTarget))
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFab.GetViewRectRelativeToAncestor: " & LastException.Message)
		' Fall through to layout-walk fallback
	End Try
    #End If
	' Fallback: accumulate Left/Top up the view hierarchy.
	' This works accurately for views before initial screen layout/draw.
	Dim left As Int = 0
	Dim top As Int = 0
	Dim current As B4XView = vTarget
	Dim depth As Int = 0
	Do While current.IsInitialized And depth < 20
		' Use native view identity - B4XView = is unreliable across .Parent calls
		If IsSameView(current, vAncestor) Then Exit
		left = left + GetSafeLeft(current)
		top = top + GetSafeTop(current)
		Try
			Dim pv As B4XView = current.Parent
			If pv = Null Or pv.IsInitialized = False Then Exit
			current = pv
		Catch
			Exit
		End Try
		depth = depth + 1
	Loop
	Return CreateMap("left": left, "top": top, "width": GetSafeWidth(vTarget), "height": GetSafeHeight(vTarget))
End Sub

' Compare two B4XView wrappers by their underlying Android View identity.
' B4XView = B4XView is always False when one comes from .Parent; use this instead.

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

Private Sub IsSameView(vView1 As B4XView, vView2 As B4XView) As Boolean
	If vView1.IsInitialized = False Or vView2.IsInitialized = False Then Return vView1.IsInitialized = vView2.IsInitialized
    #If B4A
	Try
		Dim jo1 As JavaObject = vView1
		Dim jo2 As JavaObject = vView2
		' Compare native View identity via System.identityHashCode.
		' Using equals() can fail when JavaObject wrapping doesn't unwrap
		' the native view correctly across different B4XView wrapper instances.
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
#End Region

#Region Events
Private Sub fabtrigger_Click(oTag As Object)
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", oTag)
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

Private Sub fabclose_Click(oTag As Object)
	Dim closeTag As Object = oTag
	If closeTag = Null Then closeTag = ResolveCloseTriggerTag
	If xui.SubExists(mCallBack, mEventName & "_CloseClick", 1) Then
		CallSub2(mCallBack, mEventName & "_CloseClick", closeTag)
	End If
	Close
End Sub

Private Sub fabaction_Click(oTag As Object)
	If (oTag Is Map) = False Then Return
	Dim payload As Map = oTag
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

Private Sub RemoveActionViews(mRec As Map)
	If mRec.IsInitialized = False Then Return
	Dim host As B4XView = GetRecView(mRec, "Host")
	If host.IsInitialized Then host.RemoveViewFromParent
End Sub

Private Sub GetRecView(mRec As Map, sKey As String) As B4XView
	Dim v As B4XView
	If mRec.IsInitialized = False Then Return v
	If mRec.ContainsKey(sKey) = False Then Return v
	Dim value As Object = mRec.Get(sKey)
	If value = Null Then Return v
	v = value
	Return v
End Sub

Private Sub GetRecButton(mRec As Map) As B4XDaisyButton
	Dim btn As B4XDaisyButton
	If mRec.IsInitialized = False Then Return btn
	If mRec.ContainsKey("Button") = False Then Return btn
	Dim value As Object = mRec.Get("Button")
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

Private Sub NormalizePlacementMode(sValue As String) As String
	Dim rawValue As String = sValue
	If rawValue = Null Then rawValue = "fixed"
	Dim s As String = rawValue.ToLowerCase.Trim
	Select Case s
		Case "manual", "anchored", "fixed"
			Return s
		Case Else
			Return "fixed"
	End Select
End Sub

Private Sub NormalizePlacement(sValue As String) As String
	Dim rawValue As String = sValue
	If rawValue = Null Then rawValue = "bottom-end"
	Dim s As String = rawValue.ToLowerCase.Trim
	Select Case s
		Case "bottom-end", "bottom-start", "bottom-center", "top-end", "top-start", "top-center", "center-end", "center-start", "center"
			Return s
		Case Else
			Return "bottom-end"
	End Select
End Sub

Private Sub NormalizeAnchorAlignment(sValue As String) As String
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

Private Sub NormalizeOpenMode(sValue As String) As String
	Dim rawValue As String = sValue
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

Private Sub NormalizeLayoutMode(sValue As String) As String
	Dim rawValue As String = sValue
	If rawValue = Null Then rawValue = "vertical"
	Dim s As String = rawValue.ToLowerCase.Trim
	Select Case s
		Case "vertical", "flower", "toolbar"
			Return s
		Case Else
			Return "vertical"
	End Select
End Sub

Private Sub NormalizeDirection(sValue As String) As String
	Dim rawValue As String = sValue
	If rawValue = Null Then rawValue = "top"
	Dim s As String = rawValue.ToLowerCase.Trim
	Select Case s
		Case "top", "right", "bottom", "left"
			Return s
		Case Else
			Return "top"
	End Select
End Sub

Private Sub ResolveButtonExtentDip(sSizeToken As String) As Int
	Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
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

' Trigger extent: explicit dip wins, otherwise the TriggerSize token.
Private Sub ResolveTriggerExtentDip As Int
	If miTriggerSizeDip > 0 Then Return miTriggerSizeDip
	Return ResolveButtonExtentDip(msTriggerSize)
End Sub

' Per-record extent: child actions use the child dip; main/close specials use the
' trigger extent. Falls back to the record's size token when the dip is 0.
Private Sub ResolveActionExtentDip(mRec As Map) As Int
	If mRec.IsInitialized = False Then Return ResolveTriggerExtentDip
	Dim role As String = mRec.Get("Role")
	If role = "action" Then
		If miChildSizeDip > 0 Then Return miChildSizeDip
		Return ResolveButtonExtentDip(mRec.Get("Size"))
	Else
		Return ResolveTriggerExtentDip
	End If
End Sub

Private Sub MeasureTextWidth(sText As String, fntFont1 As B4XFont) As Int
	If sText = Null Or sText.Length = 0 Then Return 0
	Dim r As B4XRect = cvsMeasure.MeasureText(sText, fntFont1)
	Return Ceil(r.Width)
End Sub

Private Sub GetFlowerDegrees(iCount As Int) As Float()
	Select Case iCount
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

Private Sub GetFlowerRadiusDip(iCount As Int) As Float
	Select Case iCount
		Case 1, 2
			Return 84dip
		Case 3
			Return 96dip
		Case Else
			Return 112dip
	End Select
End Sub

Private Sub RotateFlowerDegree(fBaseDegree As Float, sDirectionValue As String) As Float
	Select Case sDirectionValue
		Case "right"
			Return fBaseDegree - 90
		Case "bottom"
			Return fBaseDegree - 180
		Case "left"
			Return fBaseDegree + 90
		Case Else
			Return fBaseDegree
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
	props.Put("TriggerSizeDip", miTriggerSizeDip)
	props.Put("TriggerIconSize", miTriggerIconDip)
	props.Put("ChildActionSizeDip", miChildSizeDip)
	props.Put("ChildActionIconSize", miChildIconDip)
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
