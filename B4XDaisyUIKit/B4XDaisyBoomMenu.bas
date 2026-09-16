B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: BoomButtonClick (Index As Int, Tag As Object)
#Event: BackgroundClick
#Event: WillShow
#Event: DidShow
#Event: WillHide
#Event: DidHide
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enable or disable the BoomMenu.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide the BoomMenu.
#DesignerProperty: Key: ButtonType, DisplayName: Button Type, FieldType: String, DefaultValue: SimpleCircle, List: SimpleCircle|TextInsideCircle|TextOutsideCircle|Ham, Description: Type of boom buttons.
#DesignerProperty: Key: PiecePlace, DisplayName: Piece Place, FieldType: String, DefaultValue: DOT_9_1, List: DOT_1|DOT_2_1|DOT_2_2|DOT_3_1|DOT_3_2|DOT_3_3|DOT_3_4|DOT_4_1|DOT_4_2|DOT_5_1|DOT_5_2|DOT_5_3|DOT_5_4|DOT_6_1|DOT_6_2|DOT_6_3|DOT_6_4|DOT_6_5|DOT_6_6|DOT_7_1|DOT_7_2|DOT_7_3|DOT_7_4|DOT_7_5|DOT_7_6|DOT_8_1|DOT_8_2|DOT_8_3|DOT_8_4|DOT_8_5|DOT_8_6|DOT_8_7|DOT_9_1|DOT_9_2|DOT_9_3|HORIZONTAL|VERTICAL|SHARE|CUSTOM, Description: Layout of piece (placeholder) dots. All 35 DOT sub-variants are supported.
#DesignerProperty: Key: ButtonPlace, DisplayName: Button Place, FieldType: String, DefaultValue: SC_9_1, List: SC_1|SC_2_1|SC_2_2|SC_3_1|SC_3_2|SC_3_3|SC_3_4|SC_4_1|SC_4_2|SC_5_1|SC_5_2|SC_5_3|SC_5_4|SC_6_1|SC_6_2|SC_6_3|SC_6_4|SC_6_5|SC_6_6|SC_7_1|SC_7_2|SC_7_3|SC_7_4|SC_7_5|SC_7_6|SC_8_1|SC_8_2|SC_8_3|SC_8_4|SC_8_5|SC_8_6|SC_8_7|SC_9_1|SC_9_2|SC_9_3|HORIZONTAL|VERTICAL|HAM_1|HAM_2|HAM_3|HAM_4|HAM_5|HAM_6|CUSTOM, Description: Layout of boom buttons. All 35 SC sub-variants plus HORIZONTAL/VERTICAL/HAM_1..6.
#DesignerProperty: Key: BoomType, DisplayName: Boom Type, FieldType: String, DefaultValue: H_THROW_2, List: LINE|PARABOLA_1|PARABOLA_2|PARABOLA_3|PARABOLA_4|H_THROW_1|H_THROW_2|RANDOM, Description: Animation path type. Default H_THROW_2 matches the original BoomMenu.
#DesignerProperty: Key: EaseType, DisplayName: Ease Type, FieldType: String, DefaultValue: EaseOutBack, List: Linear|EaseInSine|EaseOutSine|EaseInOutSine|EaseInQuad|EaseOutQuad|EaseInOutQuad|EaseInCubic|EaseOutCubic|EaseInOutCubic|EaseInQuart|EaseOutQuart|EaseInOutQuart|EaseInQuint|EaseOutQuint|EaseInOutQuint|EaseInExpo|EaseOutExpo|EaseInOutExpo|EaseInCirc|EaseOutCirc|EaseInOutCirc|EaseInBack|EaseOutBack|EaseInOutBack|EaseInElastic|EaseOutElastic|EaseInOutElastic|EaseInBounce|EaseOutBounce|EaseInOutBounce, Description: Easing function for the show (boom) animation.
#DesignerProperty: Key: HideEaseType, DisplayName: Hide Ease Type, FieldType: String, DefaultValue: EaseInBack, List: Linear|EaseInSine|EaseOutSine|EaseInOutSine|EaseInQuad|EaseOutQuad|EaseInOutQuad|EaseInCubic|EaseOutCubic|EaseInOutCubic|EaseInQuart|EaseOutQuart|EaseInOutQuart|EaseInQuint|EaseOutQuint|EaseInOutQuint|EaseInExpo|EaseOutExpo|EaseInOutExpo|EaseInCirc|EaseOutCirc|EaseInOutCirc|EaseInBack|EaseOutBack|EaseInOutBack|EaseInElastic|EaseOutElastic|EaseInOutElastic|EaseInBounce|EaseOutBounce|EaseInOutBounce, Description: Easing function for the hide (reboom) animation. Default EaseInBack matches the original.
#DesignerProperty: Key: OrderType, DisplayName: Order Type, FieldType: String, DefaultValue: RANDOM, List: DEFAULT|REVERSE|RANDOM, Description: Animation order. Default RANDOM matches the original BoomMenu.
#DesignerProperty: Key: Duration, DisplayName: Duration (ms), FieldType: Int, DefaultValue: 300, MinRange: 0, MaxRange: 2000, Description: Animation duration in milliseconds.
#DesignerProperty: Key: PieceColor, DisplayName: Piece Color, FieldType: Color, DefaultValue: 0xFF794DFF, Description: Color of the piece placeholders.
#DesignerProperty: Key: ButtonColor, DisplayName: Button Color, FieldType: Color, DefaultValue: 0xFF794DFF, Description: Color of the boom buttons.
#DesignerProperty: Key: ShadowLevel, DisplayName: Shadow Level, FieldType: String, DefaultValue: md, List: none|xs|sm|md|lg|xl|2xl, Description: Shadow elevation for pieces/buttons.
#DesignerProperty: Key: BackdropEnabled, DisplayName: Backdrop Enabled, FieldType: Boolean, DefaultValue: True, Description: Show backdrop when open.
#DesignerProperty: Key: BackdropColor, DisplayName: Backdrop Color, FieldType: Color, DefaultValue: 0x55000000, Description: Backdrop color (with alpha). Default 0x55 matches the original dimColor.
#DesignerProperty: Key: AutoBoom, DisplayName: Auto Boom, FieldType: Boolean, DefaultValue: False, Description: Automatically boom on show.
#DesignerProperty: Key: BoomDelay, DisplayName: Boom Delay (ms), FieldType: Int, DefaultValue: 0, MinRange: 0, Description: Delay before auto boom.
#DesignerProperty: Key: ReboomDelay, DisplayName: Reboom Delay (ms), FieldType: Int, DefaultValue: 0, MinRange: 0, Description: Delay before auto reboom.
#DesignerProperty: Key: RotateTrigger, DisplayName: Rotate Trigger, FieldType: Boolean, DefaultValue: True, Description: Rotate trigger button when booming.
#DesignerProperty: Key: RotateButtons, DisplayName: Rotate Buttons, FieldType: Boolean, DefaultValue: True, Description: Rotate boom buttons during the boom/reboom animation (original rotateDegree).
#DesignerProperty: Key: RotateDegree, DisplayName: Rotate Degree, FieldType: Int, DefaultValue: 720, MinRange: 0, MaxRange: 3600, Description: Degrees boom buttons rotate during a boom (and unrotate during reboom). Original default 720.
#DesignerProperty: Key: AutoCloseOnActionClick, DisplayName: Auto Close On Action Click, FieldType: Boolean, DefaultValue: True, Description: Close after a regular action click.
#DesignerProperty: Key: AutoCloseOnBackgroundClick, DisplayName: Auto Close On Background Click, FieldType: Boolean, DefaultValue: True, Description: Close when the backdrop is clicked (the original cancelable toggle).
#DesignerProperty: Key: TriggerIconName, DisplayName: Trigger Icon, FieldType: String, DefaultValue: , Description: Trigger button icon asset name.
#DesignerProperty: Key: TriggerText, DisplayName: Trigger Text, FieldType: String, DefaultValue: , Description: Trigger button text.
#DesignerProperty: Key: TriggerSizeDip, DisplayName: Trigger Size (dip), FieldType: Int, DefaultValue: 56, MinRange: 0, Description: Trigger button size in dip.
#DesignerProperty: Key: ButtonSizeDip, DisplayName: Button Size (dip), FieldType: Int, DefaultValue: 48, MinRange: 0, Description: Boom button size in dip.
#DesignerProperty: Key: ButtonGapDip, DisplayName: Button Gap (dip), FieldType: Int, DefaultValue: 12, MinRange: 0, Description: Gap between buttons.
#DesignerProperty: Key: PieceSizeDip, DisplayName: Piece Size (dip), FieldType: Int, DefaultValue: 6, MinRange: 0, Description: Piece placeholder (dot) diameter in dip. Original default 2*dotRadius = 6dp.
#DesignerProperty: Key: PieceCornerRadiusDip, DisplayName: Piece Corner Radius (dip), FieldType: Int, DefaultValue: 3, MinRange: 0, Description: Piece corner radius in dip. Equals half the piece size for a circular dot (original pieceCornerRadius -1 = circle).
#DesignerProperty: Key: PieceHMarginDip, DisplayName: Piece H-Margin (dip), FieldType: Float, DefaultValue: 2.5, MinRange: 0, Description: Horizontal margin between piece dots (original pieceHorizontalMargin 2.5dp).
#DesignerProperty: Key: PieceVMarginDip, DisplayName: Piece V-Margin (dip), FieldType: Float, DefaultValue: 2.5, MinRange: 0, Description: Vertical margin between piece dots (original pieceVerticalMargin 2.5dp).
#DesignerProperty: Key: PieceIMarginDip, DisplayName: Piece I-Margin (dip), FieldType: Float, DefaultValue: 3.5355, MinRange: 0, Description: Inclined margin between piece dots for 45deg layouts (original pieceInclinedMargin 3.5355dp = 5/sqrt2).
#DesignerProperty: Key: ButtonCornerRadiusDip, DisplayName: Button Corner Radius (dip), FieldType: Int, DefaultValue: 24, MinRange: 0, Description: Button corner radius in dip.
#DesignerProperty: Key: HamButtonWidthDip, DisplayName: Ham Button Width (dip), FieldType: Int, DefaultValue: 300, MinRange: 0, Description: Ham (rectangle) button width in dip. Original default 300dp.
#DesignerProperty: Key: HamButtonHeightDip, DisplayName: Ham Button Height (dip), FieldType: Int, DefaultValue: 60, MinRange: 0, Description: Ham (rectangle) button height in dip. Original default 60dp.
#DesignerProperty: Key: HamImageSizeDip, DisplayName: Ham Image Size (dip), FieldType: Int, DefaultValue: 40, MinRange: 0, Description: Ham button image size in dip (image sits left of the title/subtitle).
#DesignerProperty: Key: HamTitleSize, DisplayName: Ham Title Size, FieldType: Int, DefaultValue: 14, MinRange: 0, Description: Ham button title text size (points).
#DesignerProperty: Key: HamSubSize, DisplayName: Ham Sub Size, FieldType: Int, DefaultValue: 10, MinRange: 0, Description: Ham button subtitle text size (points).
#End Region

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
	Private mbAnimating As Boolean = False

	' Button types
	Private msButtonType As String = "SimpleCircle"
	Private Const BUTTON_TYPE_SIMPLE_CIRCLE As String = "SimpleCircle"
	Private Const BUTTON_TYPE_TEXT_INSIDE_CIRCLE As String = "TextInsideCircle"
	Private Const BUTTON_TYPE_TEXT_OUTSIDE_CIRCLE As String = "TextOutsideCircle"
	Private Const BUTTON_TYPE_HAM As String = "Ham"

	' Piece layouts
	Private msPiecePlace As String = "DOT_9_1"
	' Button layouts
	Private msButtonPlace As String = "SC_9_1"
	' Animation
	Private msBoomType As String = "H_THROW_2"
	Private msEaseType As String = "EaseOutBack"
	Private msHideEaseType As String = "EaseInBack"
	Private msOrderType As String = "RANDOM"
	Private miDuration As Int = 300

	' Colors
	Private miPieceColor As Int = 0xFF794DFF
	Private miButtonColor As Int = 0xFF794DFF
	Private msShadowLevel As String = "md"

	' Backdrop
	Private mbBackdropEnabled As Boolean = True
	Private miBackdropColor As Int = 0x55000000

	' Auto boom
	Private mbAutoBoom As Boolean = False
	Private miBoomDelay As Int = 0
	Private miReboomDelay As Int = 0
	Private mbAutoCloseOnActionClick As Boolean = True
	Private mbAutoCloseOnBackgroundClick As Boolean = True

	' Trigger / button rotation
	Private mbRotateTrigger As Boolean = True
	Private mbRotateButtons As Boolean = True
	Private miRotateDegree As Int = 720
	Private msTriggerIconName As String = ""
	Private msTriggerText As String = ""
	Private miTriggerSizeDip As Int = 56dip
	Private miButtonSizeDip As Int = 48dip
	Private miButtonGapDip As Int = 12dip
	Private miPieceSizeDip As Int = 6dip
	Private miPieceCornerRadiusDip As Int = 3dip
	Private miButtonCornerRadiusDip As Int = 24dip

	' Piece margins are decoupled from the button gap (original pieceHorizontal/Vertical/
	' InclinedMargin = 2.5/2.5/3.5355dp, vs button 20/25/20dp). Pieces are small preview
	' dots clustered tightly at the destination slots.
	Private miPieceHMarginDip As Float = 2.5dip
	Private miPieceVMarginDip As Float = 2.5dip
	Private miPieceIMarginDip As Float = 3.5355dip

	' Share line length for SHARE piece place (triangular layout with connecting lines)
	' Original default: 20dp (shareLineLength in default_values.xml)
	Private miShareLineLengthDip As Int = 20dip

	' Ham (rectangle) button geometry. The Ham piece is a thin bar (hamWidth x hamHeight).
	Private miHamButtonWidthDip As Int = 300dip
	Private miHamButtonHeightDip As Int = 60dip
	Private miHamImageSizeDip As Int = 40dip
	Private miHamTitleSize As Int = 14
	Private miHamSubSize As Int = 10
	Private miHamPieceWidthDip As Int = 20dip
	Private miHamPieceHeightDip As Int = 3dip

	' Button placement (ported from original BoomMenu). The cluster is anchored to the
	' overlay by msButtonPlaceAlignment (default Center = original default). hm/vm reuse
	' miButtonGapDip; im is the inclined margin (SC_9_3 etc.); edge margin is used by
	' non-Center alignments. Defaults match original default_values.xml (im=20dp, edges=30dp).
	Private msButtonPlaceAlignment As String = "Center"
	Private miButtonInclinedMarginDip As Int = 20dip
	Private miButtonEdgeMarginDip As Int = 30dip

	' Views
	Private btnTrigger As B4XDaisyButton
	Private vTrigger As B4XView
	Private pnlOverlay As B4XView
	Private pnlBackdrop As B4XView
	Private pnlPieceLayer As B4XView
	Private pnlButtonLayer As B4XView
	Private pnlMeasure As B4XView
	Private cvsMeasure As B4XCanvas

	' Data
	Private lstButtonRecords As List

	' Animation
	Private animBoom As B4XDaisyAnimation
	Private miAnimToken As Int = 0

	' State
	Private msState As String = "CLOSED"
	Private Const STATE_CLOSED As String = "CLOSED"
	Private Const STATE_BOOMING As String = "BOOMING"
	Private Const STATE_OPENED As String = "OPENED"
	Private Const STATE_REBOOMING As String = "REBOOMING"

	' Piece/Button layout engines
	Private pieceManager As B4XDaisyPiecePlaceManager
	Private buttonManager As B4XDaisyButtonPlaceManager
	Private pathManager As B4XDaisyBoomPathManager

	' Custom positions (used when PiecePlace/ButtonPlace = "CUSTOM")
	Private mcCustomPiecePositions As List
	Private mcCustomButtonPositions As List

	' Color morph
	Private miOriginalPieceColor As Int
	Private miOriginalButtonColor As Int
	Private inResize As Boolean = False
	Private miBoomStartTime As Long = 0
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	lstButtonRecords.Initialize
	animBoom.Initialize
	pieceManager.Initialize
	buttonManager.Initialize
	pathManager.Initialize
	mcCustomPiecePositions.Initialize
	mcCustomButtonPositions.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pMeasure As Panel
	pMeasure.Initialize("")
	pnlMeasure = pMeasure
	pnlMeasure.Visible = False
	mBase.AddView(pnlMeasure, 0, 0, 100dip, 40dip)
	cvsMeasure.Initialize(pnlMeasure)

	ApplyDesignerProps(mProps)
	BuildTriggerIfNeeded
	EnsureOverlayAttached
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
	msButtonType = B4XDaisyVariants.GetPropString(mProps, "ButtonType", msButtonType)
	msPiecePlace = B4XDaisyVariants.GetPropString(mProps, "PiecePlace", msPiecePlace)
	msButtonPlace = B4XDaisyVariants.GetPropString(mProps, "ButtonPlace", msButtonPlace)
	msBoomType = B4XDaisyVariants.GetPropString(mProps, "BoomType", msBoomType)
	msEaseType = B4XDaisyVariants.GetPropString(mProps, "EaseType", msEaseType)
	msHideEaseType = B4XDaisyVariants.GetPropString(mProps, "HideEaseType", msHideEaseType)
	msOrderType = B4XDaisyVariants.GetPropString(mProps, "OrderType", msOrderType)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
	miPieceColor = B4XDaisyVariants.GetPropColor(mProps, "PieceColor", miPieceColor)
	miButtonColor = B4XDaisyVariants.GetPropColor(mProps, "ButtonColor", miButtonColor)
	msShadowLevel = B4XDaisyVariants.GetPropString(mProps, "ShadowLevel", msShadowLevel)
	mbBackdropEnabled = B4XDaisyVariants.GetPropBool(mProps, "BackdropEnabled", mbBackdropEnabled)
	miBackdropColor = B4XDaisyVariants.GetPropColor(mProps, "BackdropColor", miBackdropColor)
	mbAutoBoom = B4XDaisyVariants.GetPropBool(mProps, "AutoBoom", mbAutoBoom)
	miBoomDelay = B4XDaisyVariants.GetPropInt(mProps, "BoomDelay", miBoomDelay)
	miReboomDelay = B4XDaisyVariants.GetPropInt(mProps, "ReboomDelay", miReboomDelay)
	mbRotateTrigger = B4XDaisyVariants.GetPropBool(mProps, "RotateTrigger", mbRotateTrigger)
	mbRotateButtons = B4XDaisyVariants.GetPropBool(mProps, "RotateButtons", mbRotateButtons)
	miRotateDegree = B4XDaisyVariants.GetPropInt(mProps, "RotateDegree", miRotateDegree)
	mbAutoCloseOnActionClick = B4XDaisyVariants.GetPropBool(mProps, "AutoCloseOnActionClick", mbAutoCloseOnActionClick)
	mbAutoCloseOnBackgroundClick = B4XDaisyVariants.GetPropBool(mProps, "AutoCloseOnBackgroundClick", mbAutoCloseOnBackgroundClick)
	msTriggerIconName = B4XDaisyVariants.GetPropString(mProps, "TriggerIconName", msTriggerIconName)
	msTriggerText = B4XDaisyVariants.GetPropString(mProps, "TriggerText", msTriggerText)
	' Designer passes raw dip ints (e.g. 56); convert to dip-scaled pixels via * 1dip.
	' BuildRuntimeProps returns them divided by 1dip so the manual AddToParent round-trip
	' re-scales without double-scaling. Mirrors B4XDaisyCarousel indicator props.
	miTriggerSizeDip = B4XDaisyVariants.GetPropInt(mProps, "TriggerSizeDip", 56) * 1dip
	miButtonSizeDip = B4XDaisyVariants.GetPropInt(mProps, "ButtonSizeDip", 48) * 1dip
	miButtonGapDip = B4XDaisyVariants.GetPropInt(mProps, "ButtonGapDip", 12) * 1dip
	miPieceSizeDip = B4XDaisyVariants.GetPropInt(mProps, "PieceSizeDip", 6) * 1dip
	miPieceCornerRadiusDip = B4XDaisyVariants.GetPropInt(mProps, "PieceCornerRadiusDip", 3) * 1dip
	miButtonCornerRadiusDip = B4XDaisyVariants.GetPropInt(mProps, "ButtonCornerRadiusDip", 24) * 1dip
	' Piece margins are floats (original 2.5 / 3.5355dp).
	miPieceHMarginDip = B4XDaisyVariants.GetPropFloat(mProps, "PieceHMarginDip", 2.5) * 1dip
	miPieceVMarginDip = B4XDaisyVariants.GetPropFloat(mProps, "PieceVMarginDip", 2.5) * 1dip
	miPieceIMarginDip = B4XDaisyVariants.GetPropFloat(mProps, "PieceIMarginDip", 3.5355) * 1dip
	' Ham button geometry.
	miHamButtonWidthDip = B4XDaisyVariants.GetPropInt(mProps, "HamButtonWidthDip", 300) * 1dip
	miHamButtonHeightDip = B4XDaisyVariants.GetPropInt(mProps, "HamButtonHeightDip", 60) * 1dip
	miHamImageSizeDip = B4XDaisyVariants.GetPropInt(mProps, "HamImageSizeDip", 40) * 1dip
	miHamTitleSize = B4XDaisyVariants.GetPropInt(mProps, "HamTitleSize", 14)
	miHamSubSize = B4XDaisyVariants.GetPropInt(mProps, "HamSubSize", 10)

	miOriginalPieceColor = miPieceColor
	miOriginalButtonColor = miButtonColor
End Sub
#End Region

#Region Composition
Private Sub BuildTriggerIfNeeded
	If btnTrigger.IsInitialized = False Then
		Dim b As B4XDaisyButton
		b.Initialize(Me, "boomtrigger")
		btnTrigger = b
	End If
	If vTrigger.IsInitialized = False Then
		vTrigger = btnTrigger.AddToParent(mBase, 0, 0, 0, 0)
	End If
End Sub

Private Sub SyncTriggerButton
	If btnTrigger.IsInitialized = False Then Return

	btnTrigger.Text = msTriggerText
	btnTrigger.IconName = msTriggerIconName
	btnTrigger.Circle = True
	btnTrigger.Variant = "primary"
	btnTrigger.Style = "solid"
	btnTrigger.Size = "lg"
	btnTrigger.ButtonSizeDip = miTriggerSizeDip
	btnTrigger.IconSize = 24dip
	btnTrigger.Disabled = Not(mbEnabled)
	btnTrigger.Visible = mbVisible
	btnTrigger.Tag = mTag
End Sub

Private Sub EnsureOverlayAttached
	If mBase.IsInitialized = False Then Return
	If mBase.Parent.IsInitialized = False Then Return

	Dim overlayHost As B4XView = mBase.Parent
	If pnlOverlay.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		pnlOverlay = p
		pnlOverlay.Color = xui.Color_Transparent

		Dim pb As Panel
		pb.Initialize("boombackdrop")
		pnlBackdrop = pb
		pnlBackdrop.Color = miBackdropColor
		pnlOverlay.AddView(pnlBackdrop, 0, 0, overlayHost.Width, overlayHost.Height)

		Dim pp As Panel
		pp.Initialize("")
		pnlPieceLayer = pp
		pnlPieceLayer.Color = xui.Color_Transparent
		pnlOverlay.AddView(pnlPieceLayer, 0, 0, overlayHost.Width, overlayHost.Height)

		Dim pb2 As Panel
		pb2.Initialize("")
		pnlButtonLayer = pb2
		pnlButtonLayer.Color = xui.Color_Transparent
		pnlOverlay.AddView(pnlButtonLayer, 0, 0, overlayHost.Width, overlayHost.Height)
	End If

	Dim currentParent As B4XView = pnlOverlay.Parent
	If currentParent.IsInitialized And IsSameView(currentParent, overlayHost) = False Then
		pnlOverlay.RemoveViewFromParent
	End If

	If pnlOverlay.Parent.IsInitialized = False Then
		overlayHost.AddView(pnlOverlay, 0, 0, overlayHost.Width, overlayHost.Height)
	End If

	pnlOverlay.SetLayoutAnimated(0, 0, 0, overlayHost.Width, overlayHost.Height)
	pnlBackdrop.SetLayoutAnimated(0, 0, 0, pnlOverlay.Width, pnlOverlay.Height)
	pnlPieceLayer.SetLayoutAnimated(0, 0, 0, pnlOverlay.Width, pnlOverlay.Height)
	pnlButtonLayer.SetLayoutAnimated(0, 0, 0, pnlOverlay.Width, pnlOverlay.Height)

	B4XDaisyVariants.DisableClipping(pnlOverlay)
	B4XDaisyVariants.DisableClipping(pnlPieceLayer)
	B4XDaisyVariants.DisableClipping(pnlButtonLayer)
	B4XDaisyVariants.DisableClippingRecursive(overlayHost)
	B4XDaisyVariants.DisableClippingRecursive(mBase)

	pnlOverlay.Visible = mbOpen And mbVisible
	pnlBackdrop.Visible = mbBackdropEnabled
End Sub

Private Sub IsSameView(vV1 As B4XView, vV2 As B4XView) As Boolean
	#If B4A
	Dim jo1 As JavaObject = vV1
	Dim jo2 As JavaObject = vV2
	Return jo1.RunMethod("equals", Array As Object(jo2))
	#Else
	Return vV1 = vV2
	#End If
End Sub

Private Sub CreateButtonRecord(iIndex As Int, sText As String, sIconName As String, oTagValue As Object, bVisible As Boolean) As Map
	Dim rec As Map
	rec.Initialize
	rec.Put("Index", iIndex)
	rec.Put("Text", IIf(sText = Null, "", sText))
	rec.Put("SubText", "")
	rec.Put("IconName", IIf(sIconName = Null, "", sIconName))
	rec.Put("Tag", oTagValue)
	rec.Put("Visible", bVisible)
	rec.Put("ButtonView", Null)
	rec.Put("PieceView", Null)
	rec.Put("IsContainer", False)
	rec.Put("MorphView", Null)
	rec.Put("MorphRadius", 0)
	Return rec
End Sub

Private Sub EnsureButtonView(mRec As Map)
	If mRec.IsInitialized = False Or pnlButtonLayer.IsInitialized = False Then Return

	' If ButtonType changed since this record's views were built, tear them down so the
	' correct view class (B4XDaisyButton vs container Panel) AND its container children
	' (IconComp/TitleLabel/CirclePanel/TextLabel) get rebuilt. Without this, switching
	' ButtonType at runtime (e.g. SimpleCircle -> Ham) reuses the cached ButtonView and
	' skips BuildContainerChildren, leaving the child refs absent; ApplyHamAppearance /
	' ApplyTextOutsideAppearance then read Rec.Get("IconComp") = Null and NPE on
	' iconComp.IsInitialized (a typed class instance, unlike B4XView, does not tolerate Null).
	Dim builtType As String = mRec.GetDefault("BuiltButtonType", "")
	If builtType <> msButtonType Then
		RemoveButtonViews(mRec)
	End If

	' ApplyButtonAppearance is expensive: ApplyCircleButtonAppearance sets ~10
	' B4XDaisyButton properties, and every one of those setters calls Refresh
	' (SVG raster + relayout). Re-running it every boom blocked the main thread
	' for ~800ms before any button moved. The original Java BoomMenu builds views
	' once and reuses them. We do the same: apply appearance only when the views
	' are first built (or rebuilt after a ButtonType teardown). Per-boom color
	' reset is handled cheaply by ResetButtonColor in LayoutButtons.
	Dim needsAppearance As Boolean = False
	Dim btnView As B4XView = mRec.Get("ButtonView")
	If btnView.IsInitialized = False Then
		If msButtonType = BUTTON_TYPE_HAM Or msButtonType = BUTTON_TYPE_TEXT_OUTSIDE_CIRCLE Then
			' Container panel renders its own content and handles click via the "boombtn"
			' event (boombtn_Click reads Sender.Tag). Used for Ham (image + title/sub) and
			' TextOutsideCircle (circle image + text below).
			Dim p As Panel
			p.Initialize("boombtn")
			btnView = p
			btnView.Color = xui.Color_Transparent
			pnlButtonLayer.AddView(btnView, 0, 0, 0, 0)
			mRec.Put("ButtonView", btnView)
			mRec.Put("ButtonObj", Null)
			mRec.Put("IsContainer", True)
			BuildContainerChildren(mRec)
		Else
			Dim b As B4XDaisyButton
			b.Initialize(Me, "boombutton")
			Dim v As B4XView = b.AddToParent(pnlButtonLayer, 0, 0, 0, 0)
			mRec.Put("ButtonView", v)
			mRec.Put("ButtonObj", b)
			mRec.Put("IsContainer", False)
		End If
		mRec.Put("BuiltButtonType", msButtonType)
		needsAppearance = True
	End If

	Dim pieceView As B4XView = mRec.Get("PieceView")
	If pieceView.IsInitialized = False Then
		Dim pp As Panel
		pp.Initialize("")
		pieceView = pp
		pieceView.Color = xui.Color_Transparent
		Dim pw As Int
		Dim ph As Int
		If msButtonType = BUTTON_TYPE_HAM Then
			pw = miHamPieceWidthDip
			ph = miHamPieceHeightDip
		Else
			pw = miPieceSizeDip
			ph = miPieceSizeDip
		End If
		pnlPieceLayer.AddView(pieceView, 0, 0, pw, ph)
		mRec.Put("PieceView", pieceView)
		needsAppearance = True
	End If

	If needsAppearance Then ApplyButtonAppearance(mRec)
End Sub

' Cheaply restore the button's original background color after a boom that used
' MorphButtonColor to tint it. No-op (and no Refresh) when the drawable was never
' morphed, so the common case (pieceColor - buttonColor) pays nothing. Replaces
' the per-boom full ApplyButtonAppearance that previously did this reset.
Private Sub ResetButtonColor(mRec As Map)
	If mRec.IsInitialized = False Then Return
	If mRec.GetDefault("HasMorphColor", False) = False Then Return
	MorphButtonColor(mRec, miOriginalButtonColor)
	mRec.Put("HasMorphColor", False)
	mRec.Remove("LastMorphColor")
End Sub

Private Sub ApplyButtonAppearance(mRec As Map)
	If mRec.IsInitialized = False Then Return
	Select Case msButtonType
		Case BUTTON_TYPE_HAM, BUTTON_TYPE_TEXT_OUTSIDE_CIRCLE
			ApplyContainerAppearance(mRec)
		Case Else
			ApplyCircleButtonAppearance(mRec)
	End Select
End Sub

' SimpleCircle + TextInsideCircle render through B4XDaisyButton.
Private Sub ApplyCircleButtonAppearance(mRec As Map)
	Dim btnObj As B4XDaisyButton = mRec.Get("ButtonObj")
	Dim btnView As B4XView = mRec.Get("ButtonView")
	Dim pieceView As B4XView = mRec.Get("PieceView")
	If btnObj.IsInitialized = False Or btnView.IsInitialized = False Or pieceView.IsInitialized = False Then Return

	Select Case msButtonType
		Case BUTTON_TYPE_SIMPLE_CIRCLE
			btnObj.Text = ""
			btnObj.IconName = mRec.Get("IconName")
		Case BUTTON_TYPE_TEXT_INSIDE_CIRCLE
			btnObj.Text = mRec.Get("Text")
			btnObj.IconName = ""
	End Select

	' Drive circle-vs-rounded-rect from the corner radius (original buttonCornerRadius).
	' Radius >= half the button => full circle (preserves the previous all-circle default
	' of 24dip on a 48dip button); a smaller radius yields a rounded-rect boom button.
	Dim halfSize As Float = miButtonSizeDip / 2.0
	Dim isCircle As Boolean = (miButtonCornerRadiusDip >= halfSize)
	If isCircle Then
		btnObj.Circle = True
	Else
		btnObj.Circle = False
		btnObj.Rounded = RadiusDipToToken(miButtonCornerRadiusDip)
	End If

	btnObj.Variant = "primary"
	btnObj.Style = "solid"
	btnObj.Size = "md"
	' Use the designer ButtonColor as the button background (the original colors the button
	' with buttonColor, not a themed variant). BackgroundColor override is honored by
	' B4XDaisyButton.Refresh (bg = mBackgroundColor when non-transparent).
	btnObj.BackgroundColor = miButtonColor
	btnObj.ButtonSizeDip = miButtonSizeDip
	btnObj.IconSize = 20dip
	btnObj.Disabled = Not(mbEnabled)

	Dim payload As Map = CreateMap("index": mRec.Get("Index"), "tag": mRec.Get("Tag"))
	btnObj.Tag = payload

	' Color-morph target = the button view itself; radius matches its shape.
	mRec.Put("MorphView", btnView)
	mRec.Put("MorphRadius", IIf(isCircle, miButtonSizeDip / 2.0, miButtonCornerRadiusDip))

	btnView.Visible = mRec.GetDefault("Visible", True)
	pieceView.Visible = mRec.GetDefault("Visible", True)

	B4XDaisyVariants.ApplyElevation(btnView, msShadowLevel)
	B4XDaisyVariants.ApplyElevation(pieceView, msShadowLevel)
End Sub

' Ham + TextOutsideCircle render into a container panel built by BuildContainerChildren.
Private Sub ApplyContainerAppearance(mRec As Map)
	Dim btnView As B4XView = mRec.Get("ButtonView")
	Dim pieceView As B4XView = mRec.Get("PieceView")
	If btnView.IsInitialized = False Or pieceView.IsInitialized = False Then Return

	Dim payload As Map = CreateMap("index": mRec.Get("Index"), "tag": mRec.Get("Tag"))
	btnView.Tag = payload

	If msButtonType = BUTTON_TYPE_HAM Then
		ApplyHamAppearance(mRec, btnView)
	Else
		ApplyTextOutsideAppearance(mRec, btnView)
	End If

	btnView.Visible = mRec.GetDefault("Visible", True)
	pieceView.Visible = mRec.GetDefault("Visible", True)
	B4XDaisyVariants.ApplyElevation(btnView, msShadowLevel)
	B4XDaisyVariants.ApplyElevation(pieceView, msShadowLevel)
End Sub

' Create the container's child views once (circle + icon + label for TextOutside;
' image + title + sub for Ham). Re-appearance updates their content/geometry.
Private Sub BuildContainerChildren(mRec As Map)
	Dim btnView As B4XView = mRec.Get("ButtonView")
	If btnView.IsInitialized = False Then Return

	If msButtonType = BUTTON_TYPE_HAM Then
		Dim img As B4XDaisySvgIcon
		img.Initialize(Me, "boomhamicon")
		img.AddToParent(btnView, 0, 0, miHamImageSizeDip, miHamImageSizeDip)
		mRec.Put("IconComp", img)

		Dim lblTitle As Label
		lblTitle.Initialize("")
		lblTitle.Color = xui.Color_Transparent
		lblTitle.TextColor = xui.Color_White
		lblTitle.Typeface = Typeface.DEFAULT_BOLD
		btnView.AddView(lblTitle, 0, 0, 0, 0)
		mRec.Put("TitleLabel", lblTitle)

		Dim lblSub As Label
		lblSub.Initialize("")
		lblSub.Color = xui.Color_Transparent
		lblSub.TextColor = xui.Color_RGB(220, 220, 220)
		btnView.AddView(lblSub, 0, 0, 0, 0)
		mRec.Put("SubLabel", lblSub)
	Else
		' TextOutsideCircle: a colored circle panel with the image centered, plus a text
		' label below the circle (text outside the circle).
		Dim cp As Panel
		cp.Initialize("")
		Dim circlePanel As B4XView = cp
		circlePanel.Color = miButtonColor
		btnView.AddView(circlePanel, 0, 0, miButtonSizeDip, miButtonSizeDip)
		mRec.Put("CirclePanel", circlePanel)

		Dim img As B4XDaisySvgIcon
		img.Initialize(Me, "boomtoicon")
		Dim iconSize As Int = Max(8dip, miButtonSizeDip * 0.6)
		img.AddToParent(circlePanel, (miButtonSizeDip - iconSize) / 2, (miButtonSizeDip - iconSize) / 2, iconSize, iconSize)
		mRec.Put("IconComp", img)

		Dim lbl As Label
		lbl.Initialize("")
		lbl.Color = xui.Color_Transparent
		lbl.TextColor = xui.Color_White
		lbl.Gravity = Gravity.CENTER_HORIZONTAL
		lbl.Typeface = Typeface.DEFAULT_BOLD
		btnView.AddView(lbl, 0, 0, 0, 0)
		mRec.Put("TextLabel", lbl)
	End If
End Sub

Private Sub ApplyHamAppearance(mRec As Map, vBtnView As B4XView)
	Dim iconComp As B4XDaisySvgIcon = mRec.Get("IconComp")
	Dim lblTitle As Label = mRec.Get("TitleLabel")
	Dim lblSub As Label = mRec.Get("SubLabel")
	Dim iconName As String = mRec.Get("IconName")

	Dim imgLeft As Int = 12dip
	Dim imgSize As Int = miHamImageSizeDip
	Dim textLeft As Int = imgLeft + imgSize + 12dip
	Dim textW As Int = miHamButtonWidthDip - textLeft - 12dip
	Dim titleH As Int = Max(1dip, miHamButtonHeightDip / 2 - 4dip)
	Dim subH As Int = Max(1dip, miHamButtonHeightDip / 2 - 4dip)

	If iconComp.IsInitialized Then
		Dim imgTop As Int = (miHamButtonHeightDip - imgSize) / 2
		iconComp.mBase.SetLayoutAnimated(0, imgLeft, imgTop, imgSize, imgSize)
		If iconName.Trim.Length > 0 Then
			iconComp.setSvgAsset(iconName)
			iconComp.setPreserveOriginalColors(True)
			iconComp.setRoundedBox(False)
			iconComp.setColor(xui.Color_White)
		End If
	End If
	If lblTitle.IsInitialized Then
		lblTitle.Text = mRec.Get("Text")
		lblTitle.TextSize = miHamTitleSize
		lblTitle.Gravity = Gravity.CENTER_VERTICAL
		lblTitle.SetLayoutAnimated(0, textLeft, 6dip, textW, titleH)
	End If
	If lblSub.IsInitialized Then
		lblSub.Text = mRec.GetDefault("SubText", "")
		lblSub.TextSize = miHamSubSize
		lblSub.Gravity = Gravity.CENTER_VERTICAL
		lblSub.SetLayoutAnimated(0, textLeft, miHamButtonHeightDip / 2 - 2dip, textW, subH)
	End If

	' Rounded-rect background in the designer ButtonColor.
	Dim radius As Int = Min(miButtonCornerRadiusDip, miHamButtonHeightDip / 2)
	B4XDaisyVariants.ApplyDashedBorder(vBtnView, miButtonColor, 0, 0, radius, "solid")
	mRec.Put("MorphView", vBtnView)
	mRec.Put("MorphRadius", radius)
End Sub

Private Sub ApplyTextOutsideAppearance(mRec As Map, vBtnView As B4XView)
	Dim circlePanel As B4XView = mRec.Get("CirclePanel")
	Dim iconComp As B4XDaisySvgIcon = mRec.Get("IconComp")
	Dim lbl As Label = mRec.Get("TextLabel")
	Dim iconName As String = mRec.Get("IconName")
	Dim txt As String = mRec.Get("Text")

	' Container geometry: circle centered horizontally over the slot, text below.
	Dim textGap As Int = 6dip
	Dim textSize As Int = 12
	Dim textH As Int = Max(14dip, textSize + 4dip)
	Dim textW As Int = miButtonSizeDip + 16dip
	If lbl.IsInitialized And txt.Length > 0 Then
		lbl.TextSize = textSize
		Dim measuredW As Int = B4XDaisyVariants.MeasureTextWidthSafe(txt, textSize, Typeface.DEFAULT_BOLD, 8dip)
		textW = Max(miButtonSizeDip, measuredW)
		lbl.Text = txt
		lbl.Gravity = Gravity.CENTER_HORIZONTAL
	End If

	Dim containerW As Int = Max(miButtonSizeDip, textW)
	Dim containerH As Int = miButtonSizeDip + textGap + textH
	Dim circleLeft As Int = (containerW - miButtonSizeDip) / 2
	mRec.Put("ContainerW", containerW)
	mRec.Put("ContainerH", containerH)
	mRec.Put("CircleLeft", circleLeft)

	If circlePanel.IsInitialized Then
		circlePanel.SetLayoutAnimated(0, circleLeft, 0, miButtonSizeDip, miButtonSizeDip)
		B4XDaisyVariants.ApplyDashedBorder(circlePanel, miButtonColor, 0, 0, miButtonSizeDip / 2, "solid")
	End If
	If iconComp.IsInitialized And iconName.Trim.Length > 0 Then
		Dim iconSize As Int = Max(8dip, miButtonSizeDip * 0.6)
		iconComp.mBase.SetLayoutAnimated(0, (miButtonSizeDip - iconSize) / 2, (miButtonSizeDip - iconSize) / 2, iconSize, iconSize)
		iconComp.setSvgAsset(iconName)
		iconComp.setPreserveOriginalColors(True)
		iconComp.setRoundedBox(False)
		iconComp.setColor(xui.Color_White)
	End If
	If lbl.IsInitialized Then
		lbl.SetLayoutAnimated(0, 0, miButtonSizeDip + textGap, containerW, textH)
	End If

	' Morph the circle (the colored surface), not the transparent container.
	mRec.Put("MorphView", circlePanel)
	mRec.Put("MorphRadius", miButtonSizeDip / 2)
End Sub

' Maps a dip corner radius to the nearest B4XDaisyButton Rounded token (mirrors
' B4XDaisyVariants.ResolveRoundedRadiusDip). Only called for sub-circle radii.
Private Sub RadiusDipToToken(fRadiusDipPx As Float) As String
	Dim r As Float = fRadiusDipPx / 1dip
	If r <= 0 Then Return "rounded-none"
	If r <= 2 Then Return "rounded-sm"
	If r <= 4 Then Return "rounded"
	If r <= 6 Then Return "rounded-md"
	If r <= 8 Then Return "rounded-lg"
	If r <= 12 Then Return "rounded-xl"
	If r <= 16 Then Return "rounded-2xl"
	Return "rounded-3xl"
End Sub

Private Sub DrawPiece(mRec As Map)
	Dim pieceView As B4XView = mRec.Get("PieceView")
	If pieceView.IsInitialized = False Then Return

	Dim cvs As B4XCanvas
	cvs.Initialize(pieceView)
	Dim r As B4XRect
	r.Initialize(0, 0, pieceView.Width, pieceView.Height)
	' Ham pieces are thin bars (pill shape); dot pieces are circles/squares whose corner
	' radius comes from miPieceCornerRadiusDip (3dp on a 6dp dot = a circle).
	Dim radius As Float
	If msButtonType = BUTTON_TYPE_HAM Then
		radius = pieceView.Height / 2.0
	Else
		radius = miPieceCornerRadiusDip
	End If
	Dim path As B4XPath
	path.InitializeRoundedRect(r, radius)
	cvs.DrawPath(path, miPieceColor, True, 0)
	cvs.Invalidate
End Sub

Private Sub UpdateAllPieces
	For Each rec As Map In lstButtonRecords
		DrawPiece(rec)
	Next
End Sub

Private Sub RemoveButtonViews(mRec As Map)
	Dim btnView As B4XView = mRec.Get("ButtonView")
	Dim pieceView As B4XView = mRec.Get("PieceView")
	If btnView.IsInitialized Then btnView.RemoveViewFromParent
	If pieceView.IsInitialized Then pieceView.RemoveViewFromParent
	' Clear every appearance/child ref so a rebuild for a different ButtonType starts clean.
	' Stale refs (e.g. a Ham TitleLabel lingering after switching to TextOutsideCircle)
	' are unused by the new appearance sub, but clearing avoids any chance of touching a
	' view that was removed from its parent. Map.Remove on an absent key is a no-op.
	mRec.Remove("ButtonView")
	mRec.Remove("PieceView")
	mRec.Remove("ButtonObj")
	mRec.Remove("IsContainer")
	mRec.Remove("BuiltButtonType")
	mRec.Remove("IconComp")
	mRec.Remove("TitleLabel")
	mRec.Remove("SubLabel")
	mRec.Remove("CirclePanel")
	mRec.Remove("TextLabel")
	mRec.Remove("ContainerW")
	mRec.Remove("ContainerH")
	mRec.Remove("CircleLeft")
	mRec.Remove("MorphView")
	mRec.Remove("MorphRadius")
	mRec.Remove("HasMorphColor")
	mRec.Remove("LastMorphColor")
End Sub
#End Region

#Region Public API
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AddToParent: Parent not initialized")
		Return empty
	End If

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		DesignerCreateView(p, Null, BuildRuntimeProps)
	End If

	' If already parented to this same parent, just reposition
	If mBase.Parent.IsInitialized Then
		If IsSameView(mBase.Parent, vParent) Then
			Reposition(iLeft, iTop, iWidth, iHeight)
			Return mBase
		End If
		' Different parent - remove first
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AddToParent: reparenting")
		If pnlOverlay.IsInitialized And pnlOverlay.Parent.IsInitialized Then pnlOverlay.RemoveViewFromParent
		mBase.RemoveViewFromParent
	End If

	Dim wasVisible As Boolean = mbVisible
	mBase.Visible = False

	Dim targetW As Int = Max(miTriggerSizeDip, iWidth)
	Dim targetH As Int = Max(miTriggerSizeDip, iHeight)
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AddToParent: adding mBase at " & iLeft & "," & iTop & " " & targetW & "x" & targetH)
	vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
	EnsureOverlayAttached
	Base_Resize(mBase.Width, mBase.Height)

	mBase.Visible = wasVisible
	If vTrigger.IsInitialized Then vTrigger.Visible = wasVisible
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AddToParent: done, overlay parent valid=" & pnlOverlay.Parent.IsInitialized)
	Return mBase
End Sub

' Reposition the trigger without re-adding to parent
Public Sub Reposition(iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	Dim targetW As Int = Max(miTriggerSizeDip, iWidth)
	Dim targetH As Int = Max(miTriggerSizeDip, iHeight)
	mBase.SetLayoutAnimated(0, iLeft, iTop, targetW, targetH)
	EnsureOverlayAttached
	Base_Resize(targetW, targetH)
End Sub

Public Sub Refresh
	If mBase.IsInitialized = False Then Return

	BuildTriggerIfNeeded
	SyncTriggerButton
	EnsureOverlayAttached
	ApplyPlacementIfNeeded
	Base_Resize(mBase.Width, mBase.Height)
	UpdateAllPieces

	If mbAutoBoom And Not(mbOpen) Then
		If miBoomDelay > 0 Then
			Sleep(miBoomDelay)
		End If
		Boom
	End If
End Sub

Public Sub UpdateTheme
	Refresh
End Sub

Public Sub Boom
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.Boom: visible=" & mbVisible & " animating=" & mbAnimating & " open=" & mbOpen & " buttons=" & lstButtonRecords.Size)
	If mbVisible = False Then Return
	If mbAnimating Then Return
	If mbOpen Then Return
	If lstButtonRecords.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.Boom: no buttons, aborting")
		Return
	End If
	If mBase.IsInitialized = False Then
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.Boom: mBase not initialized")
		Return
	End If
	If mBase.Parent.IsInitialized = False Then
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.Boom: mBase has no parent - not added to view tree yet")
		Return
	End If

	msState = STATE_BOOMING
	mbAnimating = True
	mbOpen = True
	miAnimToken = miAnimToken + 1

	FireEvent("WillShow")

	EnsureOverlayAttached
	pnlOverlay.Visible = True
	pnlBackdrop.Visible = mbBackdropEnabled

	miBoomStartTime = DateTime.Now
	LayoutPieces
	If B4XDaisyApp.DebugLogs Then Log($"BoomMenu.T: LayoutPieces=${DateTime.Now - miBoomStartTime}ms"$)
	LayoutButtons
	If B4XDaisyApp.DebugLogs Then Log($"BoomMenu.T: LayoutButtons=${DateTime.Now - miBoomStartTime}ms"$)
	AnimateBoom
	If B4XDaisyApp.DebugLogs Then Log($"BoomMenu.T: AnimateBoom setup=${DateTime.Now - miBoomStartTime}ms"$)

	If xui.SubExists(mCallBack, mEventName & "_DidShow", 0) Then
		CallSubDelayed(Me, "FireDidShow")
	End If
End Sub

Private Sub FireDidShow
	If mbOpen And msState = STATE_BOOMING Then
		If B4XDaisyApp.DebugLogs Then Log($"BoomMenu.T: DidShow(total)=${DateTime.Now - miBoomStartTime}ms"$)
		msState = STATE_OPENED
		mbAnimating = False
		FireEvent("DidShow")
	End If
End Sub

Public Sub Reboom
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.Reboom: visible=" & mbVisible & " animating=" & mbAnimating & " open=" & mbOpen)
	If mbVisible = False Then Return
	If mbAnimating Then Return
	If Not(mbOpen) Then Return

	' Optional pre-reboom delay (mirrors the auto-boom BoomDelay). Default 0 = no wait.
	' Re-check state after sleeping since the caller may have toggled in the meantime.
	If miReboomDelay > 0 Then
		Sleep(miReboomDelay)
		If mbAnimating Then Return
		If Not(mbOpen) Then Return
	End If

	msState = STATE_REBOOMING
	mbAnimating = True
	miAnimToken = miAnimToken + 1

	FireEvent("WillHide")

	AnimateReboom

	If xui.SubExists(mCallBack, mEventName & "_DidHide", 0) Then
		CallSubDelayed(Me, "FireDidHide")
	End If
End Sub

Private Sub FireDidHide
	If Not(mbOpen) And msState = STATE_REBOOMING Then
		msState = STATE_CLOSED
		mbAnimating = False
		mbOpen = False
		ApplyClosedState
		FireEvent("DidHide")
	End If
End Sub

Public Sub Toggle
	If mbOpen Then Reboom Else Boom
End Sub

Public Sub AddButton(sText As String, sIconName As String, oTagValue As Object) As Int
	Dim rec As Map = CreateButtonRecord(lstButtonRecords.Size, sText, sIconName, oTagValue, True)
	lstButtonRecords.Add(rec)
	If mbOpen Then
		EnsureButtonView(rec)
		LayoutButtons
		AnimateNewButton(rec, lstButtonRecords.Size - 1)
	End If
	Return lstButtonRecords.Size - 1
End Sub

Public Sub AddButtonEx(sText As String, sIconName As String, oTagValue As Object, bVisible As Boolean) As Int
	Dim rec As Map = CreateButtonRecord(lstButtonRecords.Size, sText, sIconName, oTagValue, bVisible)
	lstButtonRecords.Add(rec)
	If mbOpen And bVisible Then
		EnsureButtonView(rec)
		LayoutButtons
		AnimateNewButton(rec, lstButtonRecords.Size - 1)
	End If
	Return lstButtonRecords.Size - 1
End Sub

' Ham button with a title, subtitle, image, and tag. Only meaningful when ButtonType = Ham.
Public Sub AddHamButton(sTitle As String, sSubText As String, sIconName As String, oTagValue As Object) As Int
	Dim rec As Map = CreateButtonRecord(lstButtonRecords.Size, sTitle, sIconName, oTagValue, True)
	rec.Put("SubText", IIf(sSubText = Null, "", sSubText))
	lstButtonRecords.Add(rec)
	If mbOpen Then
		EnsureButtonView(rec)
		LayoutButtons
		AnimateNewButton(rec, lstButtonRecords.Size - 1)
	End If
	Return lstButtonRecords.Size - 1
End Sub

Public Sub SetButtonSubText(iIndex As Int, sSubText As String)
	If iIndex < 0 Or iIndex >= lstButtonRecords.Size Then Return
	Dim rec As Map = lstButtonRecords.Get(iIndex)
	rec.Put("SubText", IIf(sSubText = Null, "", sSubText))
	If mbOpen Then ApplyButtonAppearance(rec)
End Sub

Public Sub RemoveButton(iIndex As Int)
	If iIndex < 0 Or iIndex >= lstButtonRecords.Size Then Return
	Dim rec As Map = lstButtonRecords.Get(iIndex)
	RemoveButtonViews(rec)
	lstButtonRecords.RemoveAt(iIndex)
	If mbOpen Then LayoutButtons
End Sub

Public Sub ClearButtons
	For Each rec As Map In lstButtonRecords
		RemoveButtonViews(rec)
	Next
	lstButtonRecords.Clear
	If mbOpen Then LayoutButtons
End Sub

Public Sub SetButtonVisible(iIndex As Int, bValue As Boolean)
	If iIndex < 0 Or iIndex >= lstButtonRecords.Size Then Return
	Dim rec As Map = lstButtonRecords.Get(iIndex)
	If rec.GetDefault("Visible", True) = bValue Then Return
	rec.Put("Visible", bValue)
	If mbOpen Then
		If bValue Then
			EnsureButtonView(rec)
			LayoutButtons
			AnimateNewButton(rec, iIndex)
		Else
			AnimateHideButton(rec, iIndex)
		End If
	End If
End Sub

Public Sub GetButtonView(iIndex As Int) As B4XView
	Dim empty As B4XView
	If iIndex < 0 Or iIndex >= lstButtonRecords.Size Then Return empty
	Dim rec As Map = lstButtonRecords.Get(iIndex)
	EnsureButtonView(rec)
	Return rec.Get("ButtonView")
End Sub

Public Sub GetButtonTag(iIndex As Int) As Object
	If iIndex < 0 Or iIndex >= lstButtonRecords.Size Then Return Null
	Dim rec As Map = lstButtonRecords.Get(iIndex)
	Return rec.Get("Tag")
End Sub

Public Sub SetButtonTag(iIndex As Int, oTagValue As Object)
	If iIndex < 0 Or iIndex >= lstButtonRecords.Size Then Return
	Dim rec As Map = lstButtonRecords.Get(iIndex)
	rec.Put("Tag", oTagValue)
	Dim btnObj As B4XDaisyButton = Rec.Get("ButtonObj")
	' Container types (Ham/TextOutsideCircle) store ButtonObj = Null; guard the typed-class
	' call to avoid an NPE on btnObj.IsInitialized. B4X And does not short-circuit, so nest
	' the IsInitialized check inside the Null check.
	If btnObj <> Null Then
		If btnObj.IsInitialized Then
			Dim payload As Map = CreateMap("index": iIndex, "tag": oTagValue)
			btnObj.Tag = payload
		End If
	End If
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

Public Sub setOpened(bValue As Boolean)
	mbOpen = bValue
	If mbOpen Then Boom Else Reboom
End Sub

Public Sub setOpen(bValue As Boolean)
	If bValue Then Boom Else Reboom
End Sub

Public Sub getOpened As Boolean
	Return mbOpen
End Sub

Public Sub getOpen As Boolean
	Return mbOpen
End Sub

Public Sub getIsInitialized As Boolean
	Return mBase.IsInitialized
End Sub

Public Sub setDuration(iValue As Int)
	miDuration = Max(0, iValue)
End Sub

Public Sub getDuration As Int
	Return miDuration
End Sub

Public Sub setButtonType(sValue As String)
	msButtonType = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getButtonType As String
	Return msButtonType
End Sub

Public Sub setPiecePlace(sValue As String)
	msPiecePlace = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPiecePlace As String
	Return msPiecePlace
End Sub

Public Sub setButtonPlace(sValue As String)
	msButtonPlace = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getButtonPlace As String
	Return msButtonPlace
End Sub

' Button-place alignment anchors the button cluster to the overlay: Center (default,
' matches original), Top, Bottom, Left, Right, TL, TR, BL, BR.
Public Sub setButtonPlaceAlignment(sValue As String)
	msButtonPlaceAlignment = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getButtonPlaceAlignment As String
	Return msButtonPlaceAlignment
End Sub

Public Sub setBoomType(sValue As String)
	msBoomType = sValue
End Sub

Public Sub getBoomType As String
	Return msBoomType
End Sub

Public Sub setEaseType(sValue As String)
	msEaseType = sValue
End Sub

Public Sub getEaseType As String
	Return msEaseType
End Sub

' Hide (reboom) easing. Kept separate from the show ease to match the original,
' which uses EaseInBack for hide and EaseOutBack for show. setEaseType remains the
' show-ease setter for backward compatibility.
Public Sub setHideEaseType(sValue As String)
	msHideEaseType = sValue
End Sub

Public Sub getHideEaseType As String
	Return msHideEaseType
End Sub

Public Sub setOrderType(sValue As String)
	msOrderType = sValue
End Sub

Public Sub getOrderType As String
	Return msOrderType
End Sub

Public Sub setPieceColor(iValue As Int)
	miPieceColor = iValue
	miOriginalPieceColor = iValue
	If mBase.IsInitialized Then UpdateAllPieces
End Sub

Public Sub getPieceColor As Int
	Return miPieceColor
End Sub

Public Sub setButtonColor(iValue As Int)
	miButtonColor = iValue
	miOriginalButtonColor = iValue
End Sub

Public Sub getButtonColor As Int
	Return miButtonColor
End Sub

Public Sub setShadowLevel(sValue As String)
	msShadowLevel = sValue
	If mBase.IsInitialized Then
		For Each rec As Map In lstButtonRecords
			ApplyButtonAppearance(rec)
		Next
	End If
End Sub

Public Sub getShadowLevel As String
	Return msShadowLevel
End Sub

Public Sub setBackdropEnabled(bValue As Boolean)
	mbBackdropEnabled = bValue
	If pnlBackdrop.IsInitialized Then pnlBackdrop.Visible = bValue
End Sub

Public Sub getBackdropEnabled As Boolean
	Return mbBackdropEnabled
End Sub

Public Sub setBackdropColor(iValue As Int)
	miBackdropColor = iValue
	If pnlBackdrop.IsInitialized Then pnlBackdrop.Color = iValue
End Sub

Public Sub getBackdropColor As Int
	Return miBackdropColor
End Sub

Public Sub setAutoBoom(bValue As Boolean)
	mbAutoBoom = bValue
End Sub

Public Sub getAutoBoom As Boolean
	Return mbAutoBoom
End Sub

Public Sub setBoomDelay(iValue As Int)
	miBoomDelay = Max(0, iValue)
End Sub

Public Sub getBoomDelay As Int
	Return miBoomDelay
End Sub

Public Sub setReboomDelay(iValue As Int)
	miReboomDelay = Max(0, iValue)
End Sub

Public Sub getReboomDelay As Int
	Return miReboomDelay
End Sub

Public Sub setRotateTrigger(bValue As Boolean)
	mbRotateTrigger = bValue
End Sub

Public Sub getRotateTrigger As Boolean
	Return mbRotateTrigger
End Sub

Public Sub setAutoCloseOnActionClick(bValue As Boolean)
	mbAutoCloseOnActionClick = bValue
End Sub

Public Sub getAutoCloseOnActionClick As Boolean
	Return mbAutoCloseOnActionClick
End Sub

' Whether tapping the backdrop closes the menu (the original cancelable toggle).
Public Sub setAutoCloseOnBackgroundClick(bValue As Boolean)
	mbAutoCloseOnBackgroundClick = bValue
End Sub

Public Sub getAutoCloseOnBackgroundClick As Boolean
	Return mbAutoCloseOnBackgroundClick
End Sub

' Whether boom buttons spin during the boom/reboom animation (original rotateDegree).
Public Sub setRotateButtons(bValue As Boolean)
	mbRotateButtons = bValue
End Sub

Public Sub getRotateButtons As Boolean
	Return mbRotateButtons
End Sub

Public Sub setRotateDegree(iValue As Int)
	miRotateDegree = Max(0, iValue)
End Sub

Public Sub getRotateDegree As Int
	Return miRotateDegree
End Sub

Public Sub setTriggerText(sValue As String)
	msTriggerText = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTriggerText As String
	Return msTriggerText
End Sub

Public Sub setTriggerIconName(sValue As String)
	msTriggerIconName = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTriggerIconName As String
	Return msTriggerIconName
End Sub

Public Sub setTriggerSizeDip(iValue As Int)
	miTriggerSizeDip = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTriggerSizeDip As Int
	Return miTriggerSizeDip
End Sub

Public Sub setButtonSizeDip(iValue As Int)
	miButtonSizeDip = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getButtonSizeDip As Int
	Return miButtonSizeDip
End Sub

Public Sub setButtonGapDip(iValue As Int)
	miButtonGapDip = Max(0, iValue)
	If mBase.IsInitialized And mbOpen Then LayoutButtons
End Sub

Public Sub getButtonGapDip As Int
	Return miButtonGapDip
End Sub

Public Sub setPieceSizeDip(iValue As Int)
	miPieceSizeDip = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPieceSizeDip As Int
	Return miPieceSizeDip
End Sub

Public Sub setPieceCornerRadiusDip(iValue As Int)
	miPieceCornerRadiusDip = Max(0, iValue)
	If mBase.IsInitialized Then UpdateAllPieces
End Sub

Public Sub getPieceCornerRadiusDip As Int
	Return miPieceCornerRadiusDip
End Sub

Public Sub setButtonCornerRadiusDip(iValue As Int)
	miButtonCornerRadiusDip = Max(0, iValue)
	If mBase.IsInitialized Then
		For Each rec As Map In lstButtonRecords
			ApplyButtonAppearance(rec)
		Next
	End If
End Sub

Public Sub getButtonCornerRadiusDip As Int
	Return miButtonCornerRadiusDip
End Sub

Public Sub setPieceHMarginDip(fValue As Float)
	miPieceHMarginDip = Max(0, fValue)
	If mBase.IsInitialized And mbOpen Then LayoutPieces
End Sub

Public Sub getPieceHMarginDip As Float
	Return miPieceHMarginDip
End Sub

Public Sub setPieceVMarginDip(fValue As Float)
	miPieceVMarginDip = Max(0, fValue)
	If mBase.IsInitialized And mbOpen Then LayoutPieces
End Sub

Public Sub getPieceVMarginDip As Float
	Return miPieceVMarginDip
End Sub

Public Sub setPieceIMarginDip(fValue As Float)
	miPieceIMarginDip = Max(0, fValue)
	If mBase.IsInitialized And mbOpen Then LayoutPieces
End Sub

Public Sub getPieceIMarginDip As Float
	Return miPieceIMarginDip
End Sub

Public Sub setHamButtonWidthDip(iValue As Int)
	miHamButtonWidthDip = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHamButtonWidthDip As Int
	Return miHamButtonWidthDip
End Sub

Public Sub setHamButtonHeightDip(iValue As Int)
	miHamButtonHeightDip = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHamButtonHeightDip As Int
	Return miHamButtonHeightDip
End Sub

Public Sub setHamImageSizeDip(iValue As Int)
	miHamImageSizeDip = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHamImageSizeDip As Int
	Return miHamImageSizeDip
End Sub

Public Sub setHamTitleSize(iValue As Int)
	miHamTitleSize = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHamTitleSize As Int
	Return miHamTitleSize
End Sub

Public Sub setHamSubSize(iValue As Int)
	miHamSubSize = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHamSubSize As Int
	Return miHamSubSize
End Sub

Public Sub GetState As String
	Return msState
End Sub

Public Sub GetButtonCount As Int
	Return lstButtonRecords.Size
End Sub

Public Sub BuildRuntimeProps As Map
	Dim m As Map
	m.Initialize
	m.Put("Enabled", mbEnabled)
	m.Put("Visible", mbVisible)
	m.Put("ButtonType", msButtonType)
	m.Put("PiecePlace", msPiecePlace)
	m.Put("ButtonPlace", msButtonPlace)
	m.Put("BoomType", msBoomType)
	m.Put("EaseType", msEaseType)
	m.Put("HideEaseType", msHideEaseType)
	m.Put("OrderType", msOrderType)
	m.Put("Duration", miDuration)
	m.Put("PieceColor", miPieceColor)
	m.Put("ButtonColor", miButtonColor)
	m.Put("ShadowLevel", msShadowLevel)
	m.Put("BackdropEnabled", mbBackdropEnabled)
	m.Put("BackdropColor", miBackdropColor)
	m.Put("AutoBoom", mbAutoBoom)
	m.Put("BoomDelay", miBoomDelay)
	m.Put("ReboomDelay", miReboomDelay)
	m.Put("RotateTrigger", mbRotateTrigger)
	m.Put("RotateButtons", mbRotateButtons)
	m.Put("RotateDegree", miRotateDegree)
	m.Put("AutoCloseOnActionClick", mbAutoCloseOnActionClick)
	m.Put("AutoCloseOnBackgroundClick", mbAutoCloseOnBackgroundClick)
	m.Put("TriggerIconName", msTriggerIconName)
	m.Put("TriggerText", msTriggerText)
	' Pass raw dip ints back (field holds dip-scaled pixels) so ApplyDesignerProps
	' re-scales via * 1dip on the manual AddToParent round-trip without double-scaling.
	m.Put("TriggerSizeDip", miTriggerSizeDip / 1dip)
	m.Put("ButtonSizeDip", miButtonSizeDip / 1dip)
	m.Put("ButtonGapDip", miButtonGapDip / 1dip)
	m.Put("PieceSizeDip", miPieceSizeDip / 1dip)
	m.Put("PieceCornerRadiusDip", miPieceCornerRadiusDip / 1dip)
	m.Put("PieceHMarginDip", miPieceHMarginDip / 1dip)
	m.Put("PieceVMarginDip", miPieceVMarginDip / 1dip)
	m.Put("PieceIMarginDip", miPieceIMarginDip / 1dip)
	m.Put("ButtonCornerRadiusDip", miButtonCornerRadiusDip / 1dip)
	m.Put("HamButtonWidthDip", miHamButtonWidthDip / 1dip)
	m.Put("HamButtonHeightDip", miHamButtonHeightDip / 1dip)
	m.Put("HamImageSizeDip", miHamImageSizeDip / 1dip)
	m.Put("HamTitleSize", miHamTitleSize)
	m.Put("HamSubSize", miHamSubSize)
	Return m
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
	SyncTriggerButton

	Dim triggerExtent As Int = miTriggerSizeDip
	Dim targetW As Int = Max(triggerExtent, dWidth)
	Dim targetH As Int = Max(triggerExtent, dHeight)
	If vTrigger.IsInitialized Then
		vTrigger.SetLayoutAnimated(0, 0, 0, targetW, targetH)
		btnTrigger.Base_Resize(targetW, targetH)
	End If

	EnsureOverlayAttached
	If mbOpen Then
		LayoutPieces
		LayoutButtons
	End If
	inResize = False
End Sub

Private Sub ApplyPlacementIfNeeded
End Sub

Private Sub LayoutPieces
	If pnlPieceLayer.IsInitialized = False Or mBase.Parent.IsInitialized = False Then Return

	' Pieces are centered on the overlay (no alignment), matching the original
	' B4XDaisyPiecePlaceManager. Pieces use their OWN size + margins (small dots), decoupled from
	' the button size/gap. For Ham buttons the piece is a thin bar laid out vertically.
	Dim parentW As Float = pnlPieceLayer.Width
	Dim parentH As Float = pnlPieceLayer.Height

	Dim piecePositions As List
	If msButtonType = BUTTON_TYPE_HAM Then
		piecePositions = LayoutHamPieces(parentW, parentH)
	Else
		piecePositions = pieceManager.CalculatePositions(msPiecePlace, parentW, parentH, _
			miPieceSizeDip, miPieceHMarginDip, miPieceVMarginDip, miPieceIMarginDip, lstButtonRecords.Size)
	End If

	For i = 0 To lstButtonRecords.Size - 1
		If i >= piecePositions.Size Then Exit
		Dim rec As Map = lstButtonRecords.Get(i)
		If rec.GetDefault("Visible", True) = False Then Continue
		EnsureButtonView(rec)
		Dim pieceView As B4XView = rec.Get("PieceView")
		Dim pos As Map = piecePositions.Get(i)
		Dim x As Int = pos.Get("x")
		Dim y As Int = pos.Get("y")
		Dim w As Int = pos.Get("width")
		Dim h As Int = pos.Get("height")
		pieceView.SetLayoutAnimated(0, x, y, w, h)
		DrawPiece(rec)
	Next
End Sub

Private Sub LayoutButtons
	If pnlButtonLayer.IsInitialized = False Or mBase.Parent.IsInitialized = False Then Return

	' Buttons are anchored to the overlay (pnlButtonLayer) by msButtonPlaceAlignment,
	' NOT centered on the trigger. The trigger is only the animation start. This matches
	' the original BoomMenuButton, which uses background.getLayoutParams() as parentSize.
	Dim parentW As Float = pnlButtonLayer.Width
	Dim parentH As Float = pnlButtonLayer.Height

	Dim isHam As Boolean = (msButtonType = BUTTON_TYPE_HAM)
	Dim isTextOutside As Boolean = (msButtonType = BUTTON_TYPE_TEXT_OUTSIDE_CIRCLE)

	' Slot centers. Ham buttons use the rectangle overload (ham size); all other types use
	' the circle (radius) overload with the button size, so the CIRCLES land on the grid.
	Dim buttonPositions As List
	If isHam Then
		buttonPositions = buttonManager.CalculateRectPositions(msButtonPlace, parentW, parentH, _
			miHamButtonWidthDip, miHamButtonHeightDip, miButtonGapDip, miButtonGapDip, _
			miButtonEdgeMarginDip, msButtonPlaceAlignment, lstButtonRecords.Size)
	Else
		buttonPositions = buttonManager.CalculatePositions(msButtonPlace, parentW, parentH, _
			miButtonSizeDip, miButtonGapDip, miButtonGapDip, miButtonInclinedMarginDip, _
			miButtonEdgeMarginDip, msButtonPlaceAlignment, lstButtonRecords.Size)
	End If

	For i = 0 To lstButtonRecords.Size - 1
		If i >= buttonPositions.Size Then Exit
		Dim rec As Map = lstButtonRecords.Get(i)
		If rec.GetDefault("Visible", True) = False Then Continue
		EnsureButtonView(rec)
		ResetButtonColor(rec)
		Dim btnView As B4XView = rec.Get("ButtonView")
		Dim pos As Map = buttonPositions.Get(i)
		Dim px As Int = pos.Get("x")
		Dim py As Int = pos.Get("y")
		Dim pw As Int = pos.Get("width")
		Dim ph As Int = pos.Get("height")

		If isTextOutside Then
			' Re-center the container so the CIRCLE (top of container) sits on the slot
			' center; the text extends below the circle. Container size was computed in
			' ApplyTextOutsideAppearance and stored on the record.
			Dim cw As Int = rec.GetDefault("ContainerW", pw)
			Dim ch As Int = rec.GetDefault("ContainerH", ph)
			Dim circleLeft As Int = rec.GetDefault("CircleLeft", 0)
			Dim slotCx As Int = px + pw / 2
			Dim slotCy As Int = py + ph / 2
			Dim left As Int = slotCx - circleLeft - miButtonSizeDip / 2
			Dim top As Int = slotCy - miButtonSizeDip / 2
			btnView.SetLayoutAnimated(0, left, top, cw, ch)
		Else
			btnView.SetLayoutAnimated(0, px, py, pw, ph)
			Dim btnObj As B4XDaisyButton = rec.Get("ButtonObj")
			' Container types (Ham) store ButtonObj = Null; guard the typed-class call to
			' avoid an NPE on btnObj.IsInitialized (a B4XDaisyButton instance does not
			' tolerate Null, unlike B4XView). B4X And does not short-circuit, so nest the
			' IsInitialized check inside the Null check.
			If btnObj <> Null Then
				If btnObj.IsInitialized Then btnObj.Base_Resize(pw, ph)
			End If
		End If
	Next
End Sub

' Ham pieces: vertical stack of thin bars centered on the overlay (no alignment).
Private Sub LayoutHamPieces(fParentW As Float, fParentH As Float) As List
	Return buttonManager.CalculateHamPiecePositions(fParentW, fParentH, _
		miHamPieceWidthDip, miHamPieceHeightDip, miPieceVMarginDip, lstButtonRecords.Size)
End Sub

Private Sub GetTriggerRectInParent As Map
	Dim m As Map
	m.Initialize
	If vTrigger.IsInitialized And mBase.IsInitialized And mBase.Parent.IsInitialized Then
		' vTrigger coords are relative to mBase; overlay is on mBase.Parent, so offset by mBase position
		m.Put("left", mBase.Left + vTrigger.Left)
		m.Put("top", mBase.Top + vTrigger.Top)
		m.Put("width", vTrigger.Width)
		m.Put("height", vTrigger.Height)
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.GetTriggerRect: " & m.Get("left") & "," & m.Get("top") & " " & m.Get("width") & "x" & m.Get("height"))
	Else
		m.Put("left", 0)
		m.Put("top", 0)
		m.Put("width", miTriggerSizeDip)
		m.Put("height", miTriggerSizeDip)
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.GetTriggerRect: fallback (views not ready)")
	End If
	Return m
End Sub
#End Region

#Region Animation
Private Sub AnimateBoom
	Dim myToken As Int = miAnimToken
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AnimateBoom: token=" & myToken & " buttons=" & lstButtonRecords.Size)

	Dim indices As List = GetOrderedIndices

	Dim triggerRect As Map = GetTriggerRectInParent
	Dim startX As Float = triggerRect.Get("left") + (triggerRect.Get("width") / 2)
	Dim startY As Float = triggerRect.Get("top") + (triggerRect.Get("height") / 2)
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AnimateBoom: startCenter=" & startX & "," & startY)

	Dim paths As List
	paths.Initialize
	For Each idx As Int In indices
		If idx >= lstButtonRecords.Size Then Continue
		Dim rec As Map = lstButtonRecords.Get(idx)
		If rec.GetDefault("Visible", True) = False Then Continue
		Dim btnView As B4XView = rec.Get("ButtonView")
		Dim pieceView As B4XView = rec.Get("PieceView")
		If btnView.IsInitialized = False Or pieceView.IsInitialized = False Then Continue

		Dim endX As Float = btnView.Left + btnView.Width / 2
		Dim endY As Float = btnView.Top + btnView.Height / 2
		If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AnimateBoom: btn[" & idx & "] endCenter=" & endX & "," & endY)

		Dim pathPoints As List = pathManager.CalculatePath(msBoomType, startX, startY, endX, endY, _
			pnlButtonLayer.Width, pnlButtonLayer.Height, miDuration)
		paths.Add(CreateMap("rec": rec, "path": pathPoints, "btnView": btnView, "pieceView": pieceView))
	Next

	If mbRotateTrigger Then
		animBoom.AnimateRotation(vTrigger, 0, 90, miDuration)
	End If

	animBoom.AnimateAlpha(pnlBackdrop, 0, 1, miDuration)

	Dim initialScale As Float = GetButtonInitialScale
	For i = 0 To paths.Size - 1
		If myToken <> miAnimToken Then
			If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AnimateBoom: token cancelled at i=" & i)
			mbAnimating = False
			Return
		End If
		If Not(mbOpen) Then
			mbAnimating = False
			Return
		End If

		Dim pathData As Map = paths.Get(i)
		Dim rec As Map = pathData.Get("rec")
		Dim btnView As B4XView = pathData.Get("btnView")
		Dim pieceView As B4XView = pathData.Get("pieceView")
		Dim pathPoints As List = pathData.Get("path")

		#If B4A
		Dim endPoint As Map = pathPoints.Get(pathPoints.Size - 1)
		animBoom.SetTranslationX(btnView, startX - endPoint.Get("x"))
		animBoom.SetTranslationY(btnView, startY - endPoint.Get("y"))
		#End If

		btnView.Visible = True
		animBoom.SetNativeAlpha(btnView, 0)
		animBoom.SetNativeScale(btnView, initialScale, initialScale)

		pieceView.Visible = True
		animBoom.SetNativeAlpha(pieceView, 1)
		animBoom.SetNativeScale(pieceView, 1, 1)

		Dim durationMs As Int = miDuration

		If i > 0 Then Sleep(30)
		If myToken <> miAnimToken Then
			mbAnimating = False
			Return
		End If
		If Not(mbOpen) Then
			mbAnimating = False
			Return
		End If

		' Spin the boom button as it travels (original rotateDegree). Native
		' ViewPropertyAnimator runs concurrently with the path frame loop.
		If mbRotateButtons Then
			animBoom.SetNativeRotation(btnView, 0)
			animBoom.AnimateRotation(btnView, 0, miRotateDegree, durationMs)
		End If

		AnimateAlongPath(btnView, pieceView, pathPoints, durationMs, msEaseType, CreateMap("rec": rec, "isLast": i = paths.Size - 1))
	Next
	If B4XDaisyApp.DebugLogs Then Log("BoomMenu.AnimateBoom: complete")
End Sub

Private Sub AnimateAlongPath(vBtnView As B4XView, vPieceView As B4XView, lstPathPoints As List, iDurationMs As Int, sEaseType As String, mExtra As Map)
	Dim initialScale As Float = GetButtonInitialScale

	If lstPathPoints.Size < 2 Then
		animBoom.AnimateAlpha(vBtnView, 0, 1, iDurationMs)
		animBoom.AnimateScaleFrom(vBtnView, initialScale, initialScale, 1, 1, iDurationMs)
		Return
	End If

	Dim myToken As Int = miAnimToken
	Dim isLast As Boolean = mExtra.GetDefault("isLast", False)
	Dim rec As Map = mExtra.Get("rec")

	Dim frames As Int = Max(1, iDurationMs / 16)
	Dim pathLen As Int = lstPathPoints.Size
	Dim frameLoopStart As Long = DateTime.Now

	For frame = 0 To frames
		If myToken <> miAnimToken Then Return
		If Not(mbOpen) Then Return

		Dim progress As Float = frame / frames
		Dim easedProgress As Float = ApplyEase(progress, sEaseType)

		' EaseOutBack (and other overshooting eases) produce easedProgress > 1.0, which
		' made pathIndex exceed the last valid index and PathPoints.Get(idx1) throw
		' IndexOutOfBoundsException. Clamp the PATH position to [0,1]; the scale/alpha
		' below still use the unclamped easedProgress so the bounce/overshoot feel stays.
		Dim pathProgress As Float = Max(0, Min(1, easedProgress))
		Dim pathIndex As Float = pathProgress * (pathLen - 1)
		Dim idx1 As Int = Floor(pathIndex)
		Dim idx2 As Int = Min(idx1 + 1, pathLen - 1)
		Dim localT As Float = pathIndex - idx1

		Dim p1 As Map = lstPathPoints.Get(idx1)
		Dim p2 As Map = lstPathPoints.Get(idx2)

		Dim x As Float = p1.Get("x") + (p2.Get("x") - p1.Get("x")) * localT
		Dim y As Float = p1.Get("y") + (p2.Get("y") - p1.Get("y")) * localT

		#If B4A
		Dim endPoint As Map = lstPathPoints.Get(pathLen - 1)
		animBoom.SetTranslationX(vBtnView, x - endPoint.Get("x"))
		animBoom.SetTranslationY(vBtnView, y - endPoint.Get("y"))
		#Else
		vBtnView.SetLayoutAnimated(0, x - vBtnView.Width / 2, y - vBtnView.Height / 2, vBtnView.Width, vBtnView.Height)
		#End If

		Dim alpha As Float = easedProgress
		Dim scale As Float = initialScale + (1 - initialScale) * easedProgress
		animBoom.SetNativeAlpha(vBtnView, alpha)
		animBoom.SetNativeScale(vBtnView, scale, scale)

		Dim pieceAlpha As Float = 1 - easedProgress
		Dim pieceScale As Float = 1 - 0.3 * easedProgress
		animBoom.SetNativeAlpha(vPieceView, pieceAlpha)
		animBoom.SetNativeScale(vPieceView, pieceScale, pieceScale)

		' Color morph (ShowRgbEvaluator): morph the button surface pieceColor -> buttonColor
		' over the FIRST half of the show (speedMap = min(1, f*2)). No-op when the two colors
		' match (the default), so the common case pays zero per-frame cost.
		If miOriginalPieceColor <> miOriginalButtonColor Then
			Dim spd As Float = Max(0, Min(1, easedProgress * 2))
			MorphButtonColor(rec, LerpColor(miOriginalPieceColor, miOriginalButtonColor, spd))
		End If

		Sleep(16)
	Next

	' Snap to the final button color at the end of show.
	If miOriginalPieceColor <> miOriginalButtonColor Then
		MorphButtonColor(rec, miOriginalButtonColor)
	End If

	If isLast Then
		If B4XDaisyApp.DebugLogs Then Log($"BoomMenu.T: AnimateAlongPath(last) frames=${frames} elapsed=${DateTime.Now - frameLoopStart}ms"$)
	End If
	If isLast And xui.SubExists(mCallBack, mEventName & "_DidShow", 0) Then
		CallSubDelayed(Me, "FireDidShow")
	End If
End Sub

Private Sub ApplyEase(fProgress As Float, sEaseType As String) As Float
	Dim t As Float = fProgress * 1000
	Select Case sEaseType
		Case "Linear"
			Return animBoom.linearTween(t, 0, 1, 1000)
		Case "EaseInSine"
			Return animBoom.easeInSine(t, 0, 1, 1000)
		Case "EaseOutSine"
			Return animBoom.easeOutSine(t, 0, 1, 1000)
		Case "EaseInOutSine"
			Return animBoom.easeInOutSine(t, 0, 1, 1000)
		Case "EaseInQuad"
			Return animBoom.easeInQuad(t, 0, 1, 1000)
		Case "EaseOutQuad"
			Return animBoom.easeOutQuad(t, 0, 1, 1000)
		Case "EaseInOutQuad"
			Return animBoom.easeInOutQuad(t, 0, 1, 1000)
		Case "EaseInCubic"
			Return animBoom.easeInCubic(t, 0, 1, 1000)
		Case "EaseOutCubic"
			Return animBoom.easeOutCubic(t, 0, 1, 1000)
		Case "EaseInOutCubic"
			Return animBoom.easeInOutCubic(t, 0, 1, 1000)
		Case "EaseInQuart"
			Return animBoom.easeInQuart(t, 0, 1, 1000)
		Case "EaseOutQuart"
			Return animBoom.easeOutQuart(t, 0, 1, 1000)
		Case "EaseInOutQuart"
			Return animBoom.easeInOutQuart(t, 0, 1, 1000)
		Case "EaseInQuint"
			Return animBoom.easeInQuint(t, 0, 1, 1000)
		Case "EaseOutQuint"
			Return animBoom.easeOutQuint(t, 0, 1, 1000)
		Case "EaseInOutQuint"
			Return animBoom.easeInOutQuint(t, 0, 1, 1000)
		Case "EaseInExpo"
			Return animBoom.easeInExpo(t, 0, 1, 1000)
		Case "EaseOutExpo"
			Return animBoom.easeOutExpo(t, 0, 1, 1000)
		Case "EaseInOutExpo"
			Return animBoom.easeInOutExpo(t, 0, 1, 1000)
		Case "EaseInCirc"
			Return animBoom.easeInCirc(t, 0, 1, 1000)
		Case "EaseOutCirc"
			Return animBoom.easeOutCirc(t, 0, 1, 1000)
		Case "EaseInOutCirc"
			Return animBoom.easeInOutCirc(t, 0, 1, 1000)
		Case "EaseInBack"
			Return animBoom.easeInBack(t, 0, 1, 1000)
		Case "EaseOutBack"
			Return animBoom.easeOutBack(t, 0, 1, 1000)
		Case "EaseInOutBack"
			Return animBoom.easeInOutBack(t, 0, 1, 1000)
		Case "EaseInElastic"
			Return animBoom.easeInElastic(t, 0, 1, 1000)
		Case "EaseOutElastic"
			Return animBoom.easeOutElastic(t, 0, 1, 1000)
		Case "EaseInOutElastic"
			Return animBoom.easeInOutElastic(t, 0, 1, 1000)
		Case "EaseInBounce"
			Return animBoom.easeInBounce(t, 0, 1, 1000)
		Case "EaseOutBounce"
			Return animBoom.easeOutBounce(t, 0, 1, 1000)
		Case "EaseInOutBounce"
			Return animBoom.easeInOutBounce(t, 0, 1, 1000)
		Case Else
			Return animBoom.easeOutBack(t, 0, 1, 1000)
	End Select
End Sub

' Re-apply just the button's background drawable in a new color (no full Refresh, so the
' icon/text are not reloaded). Coalesces consecutive equal colors. The morph target view
' and its corner radius are stored on the record by ApplyButtonAppearance/Apply*Appearance.
Private Sub MorphButtonColor(mRec As Map, iColor As Int)
	If mRec.IsInitialized = False Then Return
	Dim hasLast As Boolean = mRec.GetDefault("HasMorphColor", False)
	Dim last As Int = mRec.GetDefault("LastMorphColor", 0)
	If hasLast And last = iColor Then Return
	mRec.Put("HasMorphColor", True)
	mRec.Put("LastMorphColor", iColor)
	Dim morphView As B4XView = mRec.Get("MorphView")
	If morphView.IsInitialized = False Then Return

	#If B4A
	Try
		Dim jo As JavaObject = morphView
		Dim bgDrawable As JavaObject = jo.RunMethod("getBackground", Null)
		If bgDrawable.IsInitialized Then
			bgDrawable.RunMethod("setColor", Array(iColor))
			Return
		End If
	Catch
		' Fallback to old behavior if reflection fails
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyBoomMenu.MorphButtonColor: " & LastException.Message)
	End Try
	#End If

	Dim radius As Float = mRec.GetDefault("MorphRadius", 0)
	B4XDaisyVariants.ApplyDashedBorder(morphView, iColor, 0, 0, radius, "solid")
End Sub

' ARGB linear interpolation between two colors (mirrors Show/HideRgbEvaluator.evaluate).
Private Sub LerpColor(iStartColor As Int, iEndColor As Int, fT As Float) As Int
	Dim t0 As Float = Max(0, Min(1, fT))
	Dim sa As Int = Bit.And(Bit.ShiftRight(iStartColor, 24), 0xFF)
	Dim sr As Int = Bit.And(Bit.ShiftRight(iStartColor, 16), 0xFF)
	Dim sg As Int = Bit.And(Bit.ShiftRight(iStartColor, 8), 0xFF)
	Dim sb As Int = Bit.And(iStartColor, 0xFF)
	Dim ea As Int = Bit.And(Bit.ShiftRight(iEndColor, 24), 0xFF)
	Dim er As Int = Bit.And(Bit.ShiftRight(iEndColor, 16), 0xFF)
	Dim eg As Int = Bit.And(Bit.ShiftRight(iEndColor, 8), 0xFF)
	Dim eb As Int = Bit.And(iEndColor, 0xFF)
	Dim a As Int = sa + (ea - sa) * t0
	Dim r As Int = sr + (er - sr) * t0
	Dim g As Int = sg + (eg - sg) * t0
	Dim b As Int = sb + (eb - sb) * t0
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

' Compute the boom-button scale at the start of the show animation. In the original
' BoomMenu the button grows from pieceSize/contentWidth to 1.0. The default 6dip piece
' on a 48dip button yields 0.125; we floor it at 0.1. Ham and container button types
' keep the existing 0.3 start so text/outside-label layout is not crushed.
Private Sub GetButtonInitialScale As Float
	If msButtonType = BUTTON_TYPE_HAM Then Return 0.3
	If msButtonType = BUTTON_TYPE_TEXT_OUTSIDE_CIRCLE Then Return 0.3
	If miButtonSizeDip <= 0 Or miPieceSizeDip >= miButtonSizeDip Then Return 0.3
	Return Max(0.1, miPieceSizeDip / (miButtonSizeDip * 1.0))
End Sub

Private Sub AnimateReboom
	Dim myToken As Int = miAnimToken

	' Hide uses the SAME ordered indices as show (GetOrderedIndices already applies
	' the order enum). The original does not re-reverse REVERSE for hide, so we must
	' not either - re-reversing turned REVERSE back into DEFAULT (double-reverse bug).
	Dim indices As List = GetOrderedIndices

	Dim triggerRect As Map = GetTriggerRectInParent
	Dim startX As Float = triggerRect.Get("left") + (triggerRect.Get("width") / 2)
	Dim startY As Float = triggerRect.Get("top") + (triggerRect.Get("height") / 2)

	For i = 0 To indices.Size - 1
		If myToken <> miAnimToken Then
			mbAnimating = False
			Return
		End If
		If mbOpen = False Then
			mbAnimating = False
			Return
		End If

		Dim idx As Int = indices.Get(i)
		If idx >= lstButtonRecords.Size Then Continue
		Dim rec As Map = lstButtonRecords.Get(idx)
		If rec.GetDefault("Visible", True) = False Then Continue
		Dim btnView As B4XView = rec.Get("ButtonView")
		Dim pieceView As B4XView = rec.Get("PieceView")
		If btnView.IsInitialized = False Or pieceView.IsInitialized = False Then Continue

		Dim endX As Float = btnView.Left + btnView.Width / 2
		Dim endY As Float = btnView.Top + btnView.Height / 2

		Dim pathPoints As List = pathManager.CalculatePath(msBoomType, startX, startY, endX, endY, _
			pnlButtonLayer.Width, pnlButtonLayer.Height, miDuration)

		If i > 0 Then Sleep(20)
		If myToken <> miAnimToken Then
			mbAnimating = False
			Return
		End If
		If mbOpen = False Then
			mbAnimating = False
			Return
		End If

		' Unspin the boom button back to 0 during reboom (original rotateDegree).
		If mbRotateButtons Then
			animBoom.AnimateRotation(btnView, miRotateDegree, 0, miDuration)
		End If

		AnimateAlongPathReverse(btnView, pieceView, pathPoints, miDuration, msHideEaseType, CreateMap("rec": rec, "isLast": i = indices.Size - 1))
	Next

	If mbRotateTrigger Then
		animBoom.AnimateRotation(vTrigger, 90, 0, miDuration)
	End If

	animBoom.AnimateAlpha(pnlBackdrop, 1, 0, miDuration)
End Sub

Private Sub AnimateAlongPathReverse(vBtnView As B4XView, vPieceView As B4XView, lstPathPoints As List, iDurationMs As Int, sEaseType As String, mExtra As Map)
	Dim initialScale As Float = GetButtonInitialScale

	If lstPathPoints.Size < 2 Then
		animBoom.AnimateAlpha(vBtnView, 1, 0, iDurationMs)
		animBoom.AnimateScaleFrom(vBtnView, 1, 1, initialScale, initialScale, iDurationMs)
		Return
	End If

	Dim myToken As Int = miAnimToken
	Dim isLast As Boolean = mExtra.GetDefault("isLast", False)
	Dim rec As Map = mExtra.Get("rec")

	Dim frames As Int = Max(1, iDurationMs / 16)
	Dim pathLen As Int = lstPathPoints.Size

	For frame = 0 To frames
		If myToken <> miAnimToken Then
			mbAnimating = False
			Return
		End If
		If mbOpen = False Then
			mbAnimating = False
			Return
		End If

		Dim progress As Float = frame / frames
		Dim easedProgress As Float = ApplyEase(progress, sEaseType)

		' Clamp path position to [0,1]: EaseOutBack overshoots > 1.0, which made
		' (1 - easedProgress) go negative and PathPoints.Get(idx1) throw. See AnimateAlongPath.
		Dim pathProgress As Float = Max(0, Min(1, 1 - easedProgress))
		Dim pathIndex As Float = pathProgress * (pathLen - 1)
		Dim idx1 As Int = Floor(pathIndex)
		Dim idx2 As Int = Min(idx1 + 1, pathLen - 1)
		Dim localT As Float = pathIndex - idx1

		Dim p1 As Map = lstPathPoints.Get(idx1)
		Dim p2 As Map = lstPathPoints.Get(idx2)

		Dim x As Float = p1.Get("x") + (p2.Get("x") - p1.Get("x")) * localT
		Dim y As Float = p1.Get("y") + (p2.Get("y") - p1.Get("y")) * localT

		#If B4A
		Dim endPoint As Map = lstPathPoints.Get(pathLen - 1)
		animBoom.SetTranslationX(vBtnView, x - endPoint.Get("x"))
		animBoom.SetTranslationY(vBtnView, y - endPoint.Get("y"))
		#Else
		vBtnView.SetLayoutAnimated(0, x - vBtnView.Width / 2, y - vBtnView.Height / 2, vBtnView.Width, vBtnView.Height)
		#End If

		Dim alpha As Float = 1 - easedProgress
		Dim scale As Float = 1 - (1 - initialScale) * easedProgress
		animBoom.SetNativeAlpha(vBtnView, alpha)
		animBoom.SetNativeScale(vBtnView, scale, scale)

		Dim pieceAlpha As Float = easedProgress
		Dim pieceScale As Float = 0.7 + 0.3 * easedProgress
		animBoom.SetNativeAlpha(vPieceView, pieceAlpha)
		animBoom.SetNativeScale(vPieceView, pieceScale, pieceScale)

		' Color morph (HideRgbEvaluator): keep buttonColor for the first half, then morph
		' buttonColor -> pieceColor over the SECOND half (speedMap = (f-0.5)*2 for f>0.5).
		If miOriginalPieceColor <> miOriginalButtonColor Then
			Dim spd As Float
			If easedProgress <= 0.5 Then
				spd = 0
			Else
				spd = Max(0, Min(1, (easedProgress - 0.5) * 2))
			End If
			MorphButtonColor(rec, LerpColor(miOriginalButtonColor, miOriginalPieceColor, spd))
		End If

		Sleep(16)
	Next

	vBtnView.Visible = False
	vPieceView.Visible = False

	If isLast Then
		' No extra sleep - apply closed state immediately after last button finishes
		if myToken <> miAnimToken Then
			mbAnimating = False
			Return
		End If
		ApplyClosedState
		CallSubDelayed(Me, "FireDidHide")
	End If
End Sub

Private Sub ApplyClosedState
	pnlOverlay.Visible = False
	pnlBackdrop.Visible = False
	For Each rec As Map In lstButtonRecords
		Dim btnView As B4XView = rec.Get("ButtonView")
		Dim pieceView As B4XView = rec.Get("PieceView")
		If btnView.IsInitialized Then
			btnView.Visible = False
			If mbRotateButtons Then animBoom.SetNativeRotation(btnView, 0)
			#If B4A
			animBoom.SetTranslationX(btnView, 0)
			animBoom.SetTranslationY(btnView, 0)
			#End If
		End If
		If pieceView.IsInitialized Then pieceView.Visible = False
	Next
	msState = STATE_CLOSED
	mbOpen = False
	mbAnimating = False
End Sub

Private Sub AnimateNewButton(mRec As Map, iIndex As Int)
	Dim btnView As B4XView = mRec.Get("ButtonView")
	Dim pieceView As B4XView = mRec.Get("PieceView")
	If btnView.IsInitialized = False Or pieceView.IsInitialized = False Then Return

	Dim triggerRect As Map = GetTriggerRectInParent
	Dim startX As Float = triggerRect.Get("left") + (triggerRect.Get("width") / 2)
	Dim startY As Float = triggerRect.Get("top") + (triggerRect.Get("height") / 2)
	Dim endX As Float = btnView.Left + btnView.Width / 2
	Dim endY As Float = btnView.Top + btnView.Height / 2

	Dim pathPoints As List = pathManager.CalculatePath(msBoomType, startX, startY, endX, endY, _
		pnlButtonLayer.Width, pnlButtonLayer.Height, miDuration)

	Dim initialScale As Float = GetButtonInitialScale

	#If B4A
	Dim endPoint As Map = pathPoints.Get(pathPoints.Size - 1)
	animBoom.SetTranslationX(btnView, startX - endPoint.Get("x"))
	animBoom.SetTranslationY(btnView, startY - endPoint.Get("y"))
	#End If

	btnView.Visible = True
	animBoom.SetNativeAlpha(btnView, 0)
	animBoom.SetNativeScale(btnView, initialScale, initialScale)
	pieceView.Visible = True
	animBoom.SetNativeAlpha(pieceView, 1)
	animBoom.SetNativeScale(pieceView, 1, 1)

	AnimateAlongPath(btnView, pieceView, pathPoints, miDuration, msEaseType, CreateMap("rec": mRec, "isLast": True))
End Sub

Private Sub AnimateHideButton(mRec As Map, iIndex As Int)
	Dim btnView As B4XView = mRec.Get("ButtonView")
	Dim pieceView As B4XView = mRec.Get("PieceView")
	If btnView.IsInitialized = False Or pieceView.IsInitialized = False Then Return

	Dim triggerRect As Map = GetTriggerRectInParent
	Dim startX As Float = btnView.Left + btnView.Width / 2
	Dim startY As Float = btnView.Top + btnView.Height / 2
	Dim endX As Float = triggerRect.Get("left") + (triggerRect.Get("width") / 2)
	Dim endY As Float = triggerRect.Get("top") + (triggerRect.Get("height") / 2)

	Dim pathPoints As List = pathManager.CalculatePath(msBoomType, startX, startY, endX, endY, _
		pnlButtonLayer.Width, pnlButtonLayer.Height, miDuration)

	AnimateAlongPathReverse(btnView, pieceView, pathPoints, miDuration, msHideEaseType, CreateMap("rec": mRec, "isLast": False))
End Sub

Private Sub GetOrderedIndices As List
	Dim indices As List
	indices.Initialize
	For i = 0 To lstButtonRecords.Size - 1
		Dim recItem As Map = lstButtonRecords.Get(i)
		If recItem.GetDefault("Visible", True) Then
			indices.Add(i)
		End If
	Next

	Select Case msOrderType
		Case "REVERSE"
			Dim reversed As List
			reversed.Initialize
			For i = indices.Size - 1 To 0 Step -1
				reversed.Add(indices.Get(i))
			Next
			Return reversed
		Case "RANDOM"
			For i = indices.Size - 1 To 1 Step -1
				Dim j As Int = Rnd(0, i + 1)
				Dim temp As Int = indices.Get(i)
				indices.Set(i, indices.Get(j))
				indices.Set(j, temp)
			Next
			Return indices
		Case Else
			Return indices
	End Select
End Sub
#End Region

#Region Events
Private Sub FireEvent(sEventName As String)
	If xui.SubExists(mCallBack, mEventName & "_" & sEventName, 0) Then
		CallSub(mCallBack, mEventName & "_" & sEventName)
	End If
End Sub

' B4XDaisyButton.RaiseClick forwards via RaiseEventIfSubExists -> CallSub2, passing the
' button's Tag as the single argument. CallSub2 does NOT set Sender (only native event
' dispatch does), so these handlers must take a Tag param and read the payload from it,
' not from Sender. Mirrors B4XDaisyFab.fabtrigger_Click. A 0-param signature here crashes
' with "Sub boomtrigger_click signature does not match expected signature."
Public Sub boomtrigger_Click(oTag As Object)
	If mbEnabled = False Then Return
	If mbOpen Then
		Reboom
	Else
		Boom
	End If
End Sub

Public Sub boombutton_Click(oTag As Object)
	If mbEnabled = False Then Return
	Dim payload As Map = oTag
	If payload.IsInitialized = False Then Return
	Dim index As Int = payload.GetDefault("index", -1)
	Dim btnTag As Object = payload.Get("tag")
	If xui.SubExists(mCallBack, mEventName & "_BoomButtonClick", 2) Then
		CallSub3(mCallBack, mEventName & "_BoomButtonClick", index, btnTag)
	End If
	If mbAutoCloseOnActionClick Then Reboom
End Sub

' Container-based buttons (Ham, TextOutsideCircle) raise this Click event. Sender is the
' container panel; its Tag carries the index/tag payload (set in ApplyContainerAppearance).
Public Sub boombtn_Click
	If mbEnabled = False Then Return
	Dim p As Panel = Sender
	Dim payload As Map
	If p.IsInitialized Then payload = p.Tag
	If payload.IsInitialized = False Then Return
	Dim index As Int = payload.GetDefault("index", -1)
	Dim btnTag As Object = payload.Get("tag")
	If xui.SubExists(mCallBack, mEventName & "_BoomButtonClick", 2) Then
		CallSub3(mCallBack, mEventName & "_BoomButtonClick", index, btnTag)
	End If
	If mbAutoCloseOnActionClick Then Reboom
End Sub

Public Sub boombackdrop_Click
	If mbEnabled = False Then Return
	If mbAutoCloseOnBackgroundClick And mbOpen Then Reboom
	FireEvent("BackgroundClick")
End Sub
#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
