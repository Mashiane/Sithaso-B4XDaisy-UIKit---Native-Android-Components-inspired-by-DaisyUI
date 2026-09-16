B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: BeginStroke
#Event: EndStroke
#Event: Changed
#Event: Saved (Data As String)
#Event: Cleared
#Event: FocusChanged (HasFocus As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Legend, DisplayName: Legend, FieldType: String, DefaultValue: Signature, Description: Fieldset legend text
#DesignerProperty: Key: LegendSize, DisplayName: Legend Size, FieldType: String, DefaultValue: theme, List: theme|text-xs|text-sm|text-base|text-lg|text-xl, Description: Legend text size token
#DesignerProperty: Key: LegendBold, DisplayName: Legend Bold, FieldType: Boolean, DefaultValue: False, Description: Render the fieldset legend caption in bold
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: Boolean, DefaultValue: False, Description: If True, the legend text is displayed as a label above the border box
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Optional accent variant for border tint
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: outlined, List: outlined|ghost|inset, Description: Border visual style
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 16, Description: Inner content padding in dip
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: True, Description: Automatically grow to fit added content
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color (0 = default bg-base-200)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Legend text color (0 = use theme token)
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color override (0 = default border-base-300)
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip
#DesignerProperty: Key: InputBorder, DisplayName: Input Border, FieldType: Boolean, DefaultValue: False, Description: When True, apply B4XDaisyInput border color and width to the fieldset
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether a signature is required
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the group
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Error text displayed below the group when validation fails

' Signature pad properties
#DesignerProperty: Key: PenColor, DisplayName: Pen Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Color used to draw the lines
#DesignerProperty: Key: PadBackgroundColor, DisplayName: Pad Background Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Signature canvas background (0 = transparent)
#DesignerProperty: Key: MinWidth, DisplayName: Min Width, FieldType: Float, DefaultValue: 1.5, Description: Minimum width of a line
#DesignerProperty: Key: MaxWidth, DisplayName: Max Width, FieldType: Float, DefaultValue: 4.0, Description: Maximum width of a line
#DesignerProperty: Key: VelocityFilterWeight, DisplayName: Velocity Filter Weight, FieldType: Float, DefaultValue: 0.7, Description: Weight used to modify velocity
#DesignerProperty: Key: BitMapFormat, DisplayName: BitMap Format, FieldType: String, DefaultValue: png, List: png|jpg|webp|bmp, Description: Format of the exported signature bitmap
#DesignerProperty: Key: BitMapQuality, DisplayName: BitMap Quality, FieldType: Int, DefaultValue: 100, Description: Quality of the exported signature bitmap (0-100)
#DesignerProperty: Key: DisallowParentIntercept, DisplayName: Disallow Parent Intercept, FieldType: Boolean, DefaultValue: True, Description: Prevent parent scroll containers from stealing touch gestures
#DesignerProperty: Key: StrokeCap, DisplayName: Stroke Cap, FieldType: String, DefaultValue: ROUND, List: BUTT|ROUND|SQUARE, Description: Shape of line endpoints
#DesignerProperty: Key: StrokeJoin, DisplayName: Stroke Join, FieldType: String, DefaultValue: ROUND, List: BEVEL|MITER|ROUND, Description: Shape at line segment corners
#DesignerProperty: Key: PadEnabled, DisplayName: Pad Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables or disables drawing on the pad
#DesignerProperty: Key: PadVisible, DisplayName: Pad Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the pad
#DesignerProperty: Key: MinHeight, DisplayName: Min Height, FieldType: Int, DefaultValue: 150, Description: Minimum signature pad height in dip
#DesignerProperty: Key: HintColor, DisplayName: Hint Color, FieldType: Color, DefaultValue: 0x00000000, Description: Watermark hint text color (0 = theme)
#DesignerProperty: Key: ClearButtonVisible, DisplayName: Clear Button Visible, FieldType: Boolean, DefaultValue: True, Description: Show the clear button below the pad
#DesignerProperty: Key: ClearButtonText, DisplayName: Clear Button Text, FieldType: String, DefaultValue: Clear, Description: Text of the clear button
#DesignerProperty: Key: SaveButtonVisible, DisplayName: Save Button Visible, FieldType: Boolean, DefaultValue: True, Description: Show the save button below the pad
#DesignerProperty: Key: SaveButtonText, DisplayName: Save Button Text, FieldType: String, DefaultValue: Save, Description: Text of the save button
#End Region

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	' Fieldset
	Private FieldsetComp As B4XDaisyFieldset
	Private FieldsetView As B4XView
	Private PadHost As B4XView

	' Signature pad
	Private PadComp As B4XDaisySignaturePad
	Private PadView As B4XView

	' Fieldset state
	Private msLegend As String = "Signature"
	Private msLegendSize As String = "theme"
	Private mbLegendBold As Boolean = False
	Private msVariant As String = "none"
	Private msBorderStyle As String = "outlined"
	Private miPadding As Int = 16
	Private mbAutoHeight As Boolean = True
	Private msRounded As String = "theme"
	Private msShadow As String = "none"
	Private mcBackgroundColor As Int = 0
	Private mcTextColor As Int = 0
	Private mcBorderColor As Int = 0
	Private miBorderSize As Int = 1
	Private mbInputBorder As Boolean = False
	Private mbRequired As Boolean = False
	Private mbLabelAbove As Boolean = False
	Private msHintText As String = ""
	' Configured failure message (set via ErrorText prop). Not shown until
	' validation actually fails.
	Private msErrorText As String = ""
	' Currently-displayed error string. Empty means no active error. Decoupled
	' from msErrorText so setErrorText can configure the message without
	' immediately rendering an error state on load.
	Private msActiveErrorText As String = ""
	Private mbValidationTouched As Boolean = False
	Private mbProgrammaticError As Boolean = False
	Private pnlHintText As B4XView
	Private lblHintText As B4XView

	' Signature pad forwarded state
	Private mcPenColor As Int = 0xFF000000
	Private mcPadBackgroundColor As Int = 0xFFFFFFFF
	Private mfMinWidth As Float = 1.5
	Private mfMaxWidth As Float = 4.0
	Private mfVelocityFilterWeight As Float = 0.7
	Private msBitMapFormat As String = "png"
	Private miBitMapQuality As Int = 100
	Private mbDisallowParentIntercept As Boolean = True
	Private msStrokeCap As String = "ROUND"
	Private msStrokeJoin As String = "ROUND"
	Private mbPadEnabled As Boolean = True
	Private mbPadVisible As Boolean = True
	Private miMinHeight As Int = 150
	Private mcHintColor As Int = 0
	Private mbClearButtonVisible As Boolean = True
	Private msClearButtonText As String = "Clear"
	Private mbSaveButtonVisible As Boolean = True
	Private msSaveButtonText As String = "Save"

	' Action buttons (real B4XDaisyButtons at the bottom: Clear left, Save right)
	Private btnSigClear As B4XDaisyButton
	Private btnSigSave As B4XDaisyButton
	Private btnSigClearView As B4XView
	Private btnSigSaveView As B4XView
	Private inResize As Boolean = False
End Sub

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	mBase.RemoveAllViews

	EnsureFieldset
	ApplyDesignerProps(mProps)
	ApplyFieldsetStyle
	CreatePad
	EnsureButtons
	Refresh
End Sub

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

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.Color = xui.Color_Transparent
		b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
		Dim props As Map = BuildRuntimeProps(Max(1dip, iWidth), Max(1dip, iHeight))
		Dim dummy As Label
		DesignerCreateView(b, dummy, props)
	End If

	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	If mbAutoHeight Then h = Max(h, FieldsetView.Height)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Base_Resize(w, h)
	Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub IsReady As Boolean
	Return mBase.IsInitialized And FieldsetView.IsInitialized And PadView.IsInitialized
End Sub
#End Region

#Region Layout
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Refresh
	inResize = False
End Sub

Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	ApplyFieldsetStyle
	RebuildLayout
End Sub

Private Sub EnsureFieldset
	If FieldsetView.IsInitialized Then Return

	Dim fs As B4XDaisyFieldset
	fs.Initialize(Me, "sigfieldset")
	FieldsetComp = fs
	FieldsetView = FieldsetComp.AddToParent(mBase, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))

	Dim pContent As Panel
	pContent.Initialize("")
	PadHost = pContent
	PadHost.Color = xui.Color_Transparent
	FieldsetComp.AddContentView(PadHost, 0, 0, 1dip, 1dip)

	Dim pHT As Panel
	pHT.Initialize("")
	pnlHintText = pHT
	pnlHintText.Color = xui.Color_Transparent
	PadHost.AddView(pnlHintText, 0, 0, 1dip, 1dip)
	Dim lHT As Label
	lHT.Initialize("")
	lblHintText = lHT
	lblHintText.Color = xui.Color_Transparent
	lblHintText.SetTextAlignment("TOP", "LEFT")
	lblHintText.As(Label).SingleLine = False
	pnlHintText.AddView(lblHintText, 0, 0, 1dip, 1dip)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	msLegend = B4XDaisyVariants.GetPropString(mProps, "Legend", msLegend)
	msLegendSize = B4XDaisyVariants.GetPropString(mProps, "LegendSize", msLegendSize)
	mbLegendBold = B4XDaisyVariants.GetPropBool(mProps, "LegendBold", mbLegendBold)
	msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
	msBorderStyle = B4XDaisyVariants.GetPropString(mProps, "BorderStyle", msBorderStyle)
	miPadding = B4XDaisyVariants.GetPropInt(mProps, "Padding", miPadding)
	mbAutoHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoHeight", mbAutoHeight)
	msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))

	' Backward compatibility: migrate legacy RoundedBox=True designer prop
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (msRounded = "theme" Or msRounded = "") Then
	        msRounded = "rounded-box"
	    End If
	End If
	msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow)
	mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
	mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
	mcBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mcBorderColor)
	miBorderSize = B4XDaisyVariants.GetPropInt(mProps, "BorderSize", miBorderSize)
	mbInputBorder = B4XDaisyVariants.GetPropBool(mProps, "InputBorder", mbInputBorder)
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
	mbLabelAbove = B4XDaisyVariants.GetPropBool(mProps, "LabelAbove", mbLabelAbove)
	msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", msHintText)
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)

	mcPenColor = B4XDaisyVariants.GetPropColor(mProps, "PenColor", mcPenColor)
	mcPadBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "PadBackgroundColor", mcPadBackgroundColor)
	mfMinWidth = B4XDaisyVariants.GetPropFloat(mProps, "MinWidth", mfMinWidth)
	mfMaxWidth = B4XDaisyVariants.GetPropFloat(mProps, "MaxWidth", mfMaxWidth)
	mfVelocityFilterWeight = B4XDaisyVariants.GetPropFloat(mProps, "VelocityFilterWeight", mfVelocityFilterWeight)
	msBitMapFormat = B4XDaisyVariants.GetPropString(mProps, "BitMapFormat", msBitMapFormat)
	miBitMapQuality = B4XDaisyVariants.GetPropInt(mProps, "BitMapQuality", miBitMapQuality)
	mbDisallowParentIntercept = B4XDaisyVariants.GetPropBool(mProps, "DisallowParentIntercept", mbDisallowParentIntercept)
	msStrokeCap = B4XDaisyVariants.GetPropString(mProps, "StrokeCap", msStrokeCap).ToUpperCase
	msStrokeJoin = B4XDaisyVariants.GetPropString(mProps, "StrokeJoin", msStrokeJoin).ToUpperCase
	mbPadEnabled = B4XDaisyVariants.GetPropBool(mProps, "PadEnabled", mbPadEnabled)
	mbPadVisible = B4XDaisyVariants.GetPropBool(mProps, "PadVisible", mbPadVisible)
	miMinHeight = B4XDaisyVariants.GetPropInt(mProps, "MinHeight", miMinHeight)
	mcHintColor = B4XDaisyVariants.GetPropColor(mProps, "HintColor", mcHintColor)
	mbClearButtonVisible = B4XDaisyVariants.GetPropBool(mProps, "ClearButtonVisible", mbClearButtonVisible)
	msClearButtonText = B4XDaisyVariants.GetPropString(mProps, "ClearButtonText", msClearButtonText)
	mbSaveButtonVisible = B4XDaisyVariants.GetPropBool(mProps, "SaveButtonVisible", mbSaveButtonVisible)
	msSaveButtonText = B4XDaisyVariants.GetPropString(mProps, "SaveButtonText", msSaveButtonText)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Legend", msLegend)
	props.Put("LegendSize", msLegendSize)
	props.Put("LegendBold", mbLegendBold)
	props.Put("Variant", msVariant)
	props.Put("BorderStyle", msBorderStyle)
	props.Put("Padding", miPadding)
	props.Put("AutoHeight", mbAutoHeight)
	props.Put("Rounded", msRounded)
	props.Put("Shadow", msShadow)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("TextColor", mcTextColor)
	props.Put("BorderColor", mcBorderColor)
	props.Put("BorderSize", miBorderSize)
	props.Put("InputBorder", mbInputBorder)
	props.Put("Required", mbRequired)
	props.Put("LabelAbove", mbLabelAbove)
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	props.Put("PenColor", mcPenColor)
	props.Put("PadBackgroundColor", mcPadBackgroundColor)
	props.Put("MinWidth", mfMinWidth)
	props.Put("MaxWidth", mfMaxWidth)
	props.Put("VelocityFilterWeight", mfVelocityFilterWeight)
	props.Put("BitMapFormat", msBitMapFormat)
	props.Put("BitMapQuality", miBitMapQuality)
	props.Put("DisallowParentIntercept", mbDisallowParentIntercept)
	props.Put("StrokeCap", msStrokeCap)
	props.Put("StrokeJoin", msStrokeJoin)
	props.Put("PadEnabled", mbPadEnabled)
	Return props
End Sub

Private Sub ApplyFieldsetStyle
	If FieldsetComp.IsInitialized = False Then Return
	FieldsetComp.BeginUpdate
	FieldsetComp.setLegend(ResolveLegendText)
	FieldsetComp.setTextColor(ResolveLegendColor)
	FieldsetComp.setLegendSize(msLegendSize)
	FieldsetComp.setLegendBold(mbLegendBold)
	FieldsetComp.setVariant(msVariant)
	FieldsetComp.setAutoHeight(mbAutoHeight)
	FieldsetComp.setPadding(miPadding)
	FieldsetComp.setRounded(msRounded)
	FieldsetComp.setBorderStyle(msBorderStyle)
	FieldsetComp.setBorderSize(miBorderSize)
	FieldsetComp.setInputBorder(mbInputBorder)
	FieldsetComp.setShadow(msShadow)
	FieldsetComp.setBackgroundColor(mcBackgroundColor)
	FieldsetComp.setLabelAbove(mbLabelAbove)
	FieldsetComp.setRequired(mbRequired)
	If msActiveErrorText.Length > 0 Then
		FieldsetComp.setBorderColor(B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444))
	Else
		FieldsetComp.setBorderColor(mcBorderColor)
	End If
	FieldsetComp.EndUpdate
End Sub

Private Sub ResolveLegendText As String
	If mbLabelAbove Then Return msLegend
	If mbRequired And msLegend.Length > 0 Then
		If msLegend.Contains("*") = False Then Return msLegend & " *"
	End If
	Return msLegend
End Sub

Private Sub ResolveLegendColor As Int
	Dim c As Int = mcTextColor
	If c = 0 Then c = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
	If mbRequired And (mbLabelAbove = False) Then
		Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
	End If
	Return c
End Sub

Private Sub CreatePad
	If PadView.IsInitialized Then Return
	Dim sig As B4XDaisySignaturePad
	sig.Initialize(Me, "sigwrapperpad")
	PadComp = sig
	PadComp.setFieldsetMode(True)
	PadComp.setPenColor(mcPenColor)
	PadComp.setBackgroundColor(mcPadBackgroundColor)
	PadComp.setMinWidth(mfMinWidth)
	PadComp.setMaxWidth(mfMaxWidth)
	PadComp.setVelocityFilterWeight(mfVelocityFilterWeight)
	PadComp.setBitMapFormat(msBitMapFormat)
	PadComp.setBitMapQuality(miBitMapQuality)
	PadComp.setDisallowParentIntercept(mbDisallowParentIntercept)
	PadComp.setStrokeCap(msStrokeCap)
	PadComp.setStrokeJoin(msStrokeJoin)
	PadComp.setEnabled(mbPadEnabled)
	PadComp.setVisible(mbPadVisible)
	PadComp.setMinHeight(miMinHeight)
	PadComp.setHintColor(mcHintColor)
	PadComp.setRounded(msRounded)

	PadView = PadComp.AddToParent(PadHost, 0, 0, Max(1dip, PadHost.Width), Max(1dip, miMinHeight * 1dip))
End Sub

' Creates the real Clear/Save B4XDaisyButtons inside PadHost (i.e. inside the
' fieldset), below the pad. Clear sits left (error/red), Save right
' (success/green). Positioned by RebuildLayout. Hosting them in PadHost keeps
' them inside the fieldset and within its padding.
Private Sub EnsureButtons
	If PadHost.IsInitialized = False Then Return
	If btnSigClearView.IsInitialized = False Then
		Dim bc As B4XDaisyButton
		bc.Initialize(Me, "sigClear")
		btnSigClear = bc
		btnSigClear.setVariant("neutral")
		btnSigClear.setSize("md")
		btnSigClear.setText(msClearButtonText)
		btnSigClear.setTag("clear")
		btnSigClear.setVisible(mbClearButtonVisible)
		btnSigClearView = btnSigClear.AddToParent(PadHost, 0, 0, 1dip, 40dip)
	End If
	If btnSigSaveView.IsInitialized = False Then
		Dim bs As B4XDaisyButton
		bs.Initialize(Me, "sigSave")
		btnSigSave = bs
		btnSigSave.setVariant("success")
		btnSigSave.setSize("md")
		btnSigSave.setText(msSaveButtonText)
		btnSigSave.setTag("save")
		btnSigSave.setVisible(mbSaveButtonVisible)
		btnSigSaveView = btnSigSave.AddToParent(PadHost, 0, 0, 1dip, 40dip)
	End If
End Sub

Private Sub RebuildLayout
	If IsReady = False Then Return

	Dim w As Int = Max(1dip, mBase.Width)
	Dim initialH As Int = Max(1dip, mBase.Height)
	FieldsetView.SetLayoutAnimated(0, 0, 0, w, initialH)
	FieldsetComp.Refresh

	Dim contentPanel As B4XView = FieldsetComp.GetContentPanel
	Dim contentW As Int = Max(1dip, contentPanel.Width)
	Dim contentH As Int = Max(1dip, contentPanel.Height)

	' The pad fills the top of the content area; the hint/error text sits inside
	' PadHost between the pad and the Clear/Save button bar, so all three live
	' within the fieldset's padding.
	Dim barH As Int = 40dip
	Dim barGap As Int = 8dip
	Dim hintGap As Int = 6dip
	Dim showBar As Boolean = (mbClearButtonVisible Or mbSaveButtonVisible)
	Dim reservedBar As Int = IIf(showBar, barGap + barH, 0)

	Dim hintH As Int = MeasureHintHeight(contentW)
	Dim reservedHint As Int = IIf(hintH > 0, hintGap + hintH, 0)

	Dim padW As Int = contentW
	Dim padH As Int = Max(miMinHeight * 1dip, contentH - reservedBar - reservedHint)
	Dim hostH As Int = padH + reservedHint + reservedBar

	PadHost.SetLayoutAnimated(0, 0, 0, padW, hostH)
	PadView.SetLayoutAnimated(0, 0, 0, padW, padH)
	PadComp.Base_Resize(padW, padH)
	' Re-apply the FieldsetMode border/bg at the final size (the pad's own Refresh
	' only ran at creation when mBase was 1dip; the border drawable must be
	' re-applied so the rounded frame + inset canvas render correctly).
	PadComp.Refresh

	' Hint/error panel between the pad and the button bar.
	If hintH > 0 Then
		LayoutHintPanel(padW, padH + hintGap, hintH)
	Else
		LayoutHintPanel(padW, 0, 0)
	End If

	If showBar Then LayoutButtonBar(padW, padH + reservedHint + barGap, barH)
	FieldsetComp.Refresh

	' The hint now lives inside the fieldset (in PadHost), so the wrapper's
	' target height is just the fieldset height.
	Dim fieldsetH As Int = Max(1dip, FieldsetView.Height)
	Dim targetH As Int = fieldsetH
	FieldsetView.SetLayoutAnimated(0, 0, 0, w, fieldsetH)

	If mbAutoHeight Then
		If Abs(mBase.Height - targetH) > 1dip Then
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, targetH)
		End If
	End If
End Sub

' Positions the Clear/Save buttons in a two-up row. Each button takes half
' the width with an 8dip gutter between them. Hidden buttons are collapsed.
' Base_Resize is called after resizing so the button relayouts its content
' label to the new width (otherwise the text stays at the AddToParent content
' width and renders left-aligned in the wider button).
Private Sub LayoutButtonBar(iWidth As Int, iTop As Int, iHeight As Int)
	Dim gap As Int = 8dip
	Dim halfW As Int = Max(1dip, (iWidth - gap) / 2)
	If btnSigClearView.IsInitialized Then
		If mbClearButtonVisible Then
			btnSigClear.setVisible(True)
			btnSigClearView.SetLayoutAnimated(0, 0, iTop, halfW, iHeight)
			btnSigClear.Base_Resize(halfW, iHeight)
		Else
			btnSigClear.setVisible(False)
		End If
	End If
	If btnSigSaveView.IsInitialized Then
		If mbSaveButtonVisible Then
			btnSigSave.setVisible(True)
			btnSigSaveView.SetLayoutAnimated(0, halfW + gap, iTop, halfW, iHeight)
			btnSigSave.Base_Resize(halfW, iHeight)
		Else
			btnSigSave.setVisible(False)
		End If
	End If
End Sub

Private Sub MeasureHintHeight(iWidth As Int) As Int
	Dim displayedHint As String = msHintText
	If msActiveErrorText.Length > 0 Then displayedHint = msActiveErrorText
	If displayedHint.Length = 0 Then Return 0
	Dim txtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
	Return B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, txtSize, Typeface.DEFAULT, Max(1dip, iWidth - 4dip), 4dip)
End Sub

' Places the hint/error panel inside PadHost at the given Top with the given
' Height. Error text (red) takes priority over the hint text (muted). Width is
' the pad width; the panel is left-aligned within it.
Private Sub LayoutHintPanel(iWidth As Int, iTop As Int, iHeight As Int)
	If pnlHintText.IsInitialized = False Then Return
	Dim displayedHint As String = msHintText
	Dim isError As Boolean = (msActiveErrorText.Length > 0)
	If isError Then displayedHint = msActiveErrorText
	If displayedHint.Length = 0 Or iHeight <= 0 Then
		pnlHintText.Visible = False
		pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
		Return
	End If
	pnlHintText.Visible = True
	pnlHintText.SetLayoutAnimated(0, 0, iTop, iWidth, iHeight)
	lblHintText.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	lblHintText.Text = displayedHint
	Dim txtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
	lblHintText.TextSize = txtSize
	If isError Then
		lblHintText.TextColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
	Else
		lblHintText.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF666666)
	End If
	lblHintText.SetTextAlignment("TOP", "LEFT")
End Sub
#End Region

#Region Pad Event Forwarding
Private Sub sigwrapperpad_BeginStroke
	RaiseEvent("BeginStroke")
End Sub

Private Sub sigwrapperpad_EndStroke
	RaiseEvent("EndStroke")
End Sub

Private Sub sigwrapperpad_Changed
	RaiseEvent("Changed")
	' Route focus through validation hooks
	If PadComp.IsEmpty Then
		Blur
	Else
		ReceiveFocus
	End If
End Sub

' Save button: when the signature is required, enforce validation first (showing
' the error hint and aborting if empty). Otherwise export the signature and raise
' Saved with the Base64 payload (only when there is ink to save).
' Tag is the button's mTag ("save"); unused.
Private Sub sigSave_Click(oTag As Object)
	If mbRequired Then
		If Validate = False Then Return
	End If
	Dim b64 As String = GetBase64
	If b64.Length > 0 Then
		RaiseEvent1("Saved", b64)
	End If
End Sub

' Clear button: discard the signature and reset validation state (clears any
' error hint and the touched flag), then raise Cleared + Changed.
' Tag is the button's mTag ("clear"); unused.
Private Sub sigClear_Click(oTag As Object)
	If PadComp.IsInitialized Then PadComp.Clear
	ClearError
	RaiseEvent("Cleared")
	RaiseEvent("Changed")
End Sub


Private Sub RaiseEvent(sSuffix As String)
	If xui.SubExists(mCallBack, mEventName & "_" & sSuffix, 0) Then
		CallSub(mCallBack, mEventName & "_" & sSuffix)
	End If
End Sub

' Raises a 1-arg event (e.g. Saved(Data As String)). SubExists must check for
' arity 1 to match the handler, otherwise CallSub2 would pass an extra arg to a
' 0-arg handler and crash at runtime.
Private Sub RaiseEvent1(sSuffix As String, oArg As Object)
	If xui.SubExists(mCallBack, mEventName & "_" & sSuffix, 1) Then
		CallSub2(mCallBack, mEventName & "_" & sSuffix, oArg)
	End If
End Sub

#End Region

#Region Palette Forwarded Getters/Setters
Public Sub setPenColor(iValue As Int)
	mcPenColor = iValue
	If PadComp.IsInitialized Then PadComp.setPenColor(iValue)
End Sub

Public Sub getPenColor As Int
	Return mcPenColor
End Sub

Public Sub setPadBackgroundColor(iValue As Int)
	mcPadBackgroundColor = iValue
	If PadComp.IsInitialized Then PadComp.setBackgroundColor(iValue)
End Sub

Public Sub getPadBackgroundColor As Int
	Return mcPadBackgroundColor
End Sub

Public Sub setMinWidth(fValue As Float)
	mfMinWidth = fValue
	If PadComp.IsInitialized Then PadComp.setMinWidth(fValue)
End Sub

Public Sub getMinWidth As Float
	Return mfMinWidth
End Sub

Public Sub setMaxWidth(fValue As Float)
	mfMaxWidth = fValue
	If PadComp.IsInitialized Then PadComp.setMaxWidth(fValue)
End Sub

Public Sub getMaxWidth As Float
	Return mfMaxWidth
End Sub

Public Sub setVelocityFilterWeight(fValue As Float)
	mfVelocityFilterWeight = fValue
	If PadComp.IsInitialized Then PadComp.setVelocityFilterWeight(fValue)
End Sub

Public Sub getVelocityFilterWeight As Float
	Return mfVelocityFilterWeight
End Sub

Public Sub setBitMapFormat(sValue As String)
	msBitMapFormat = sValue
	If PadComp.IsInitialized Then PadComp.setBitMapFormat(sValue)
End Sub

Public Sub getBitMapFormat As String
	Return msBitMapFormat
End Sub

Public Sub setBitMapQuality(iValue As Int)
	miBitMapQuality = iValue
	If PadComp.IsInitialized Then PadComp.setBitMapQuality(iValue)
End Sub

Public Sub getBitMapQuality As Int
	Return miBitMapQuality
End Sub

Public Sub setDisallowParentIntercept(bValue As Boolean)
	mbDisallowParentIntercept = bValue
	If PadComp.IsInitialized Then PadComp.setDisallowParentIntercept(bValue)
End Sub

Public Sub getDisallowParentIntercept As Boolean
	Return mbDisallowParentIntercept
End Sub

Public Sub setStrokeCap(sValue As String)
	msStrokeCap = sValue.ToUpperCase
	If PadComp.IsInitialized Then PadComp.setStrokeCap(msStrokeCap)
End Sub

Public Sub getStrokeCap As String
	Return msStrokeCap
End Sub

Public Sub setStrokeJoin(sValue As String)
	msStrokeJoin = sValue.ToUpperCase
	If PadComp.IsInitialized Then PadComp.setStrokeJoin(msStrokeJoin)
End Sub

Public Sub getStrokeJoin As String
	Return msStrokeJoin
End Sub

Public Sub setPadEnabled(bValue As Boolean)
	mbPadEnabled = bValue
	If PadComp.IsInitialized Then PadComp.setEnabled(bValue)
End Sub

Public Sub getPadEnabled As Boolean
	Return mbPadEnabled
End Sub

Public Sub setPadVisible(bValue As Boolean)
	mbPadVisible = bValue
	If PadComp.IsInitialized Then PadComp.setVisible(bValue)
End Sub

Public Sub getPadVisible As Boolean
	Return mbPadVisible
End Sub

Public Sub setMinHeight(iValue As Int)
	miMinHeight = Max(50, iValue)
	If mBase.IsInitialized Then RebuildLayout
End Sub

Public Sub getMinHeight As Int
	Return miMinHeight
End Sub

Public Sub setHintColor(iValue As Int)
	mcHintColor = iValue
	If PadComp.IsInitialized Then PadComp.setHintColor(iValue)
End Sub

Public Sub getHintColor As Int
	Return mcHintColor
End Sub

Public Sub setClearButtonVisible(bValue As Boolean)
	mbClearButtonVisible = bValue
	If btnSigClearView.IsInitialized Then
		btnSigClear.setVisible(bValue)
		If mBase.IsInitialized Then RebuildLayout
	End If
End Sub

Public Sub getClearButtonVisible As Boolean
	Return mbClearButtonVisible
End Sub

Public Sub setClearButtonText(sValue As String)
	If sValue = Null Then sValue = ""
	msClearButtonText = sValue.Trim
	If btnSigClearView.IsInitialized Then btnSigClear.setText(msClearButtonText)
End Sub

Public Sub getClearButtonText As String
	Return msClearButtonText
End Sub

Public Sub setSaveButtonVisible(bValue As Boolean)
	mbSaveButtonVisible = bValue
	If btnSigSaveView.IsInitialized Then
		btnSigSave.setVisible(bValue)
		If mBase.IsInitialized Then RebuildLayout
	End If
End Sub

Public Sub getSaveButtonVisible As Boolean
	Return mbSaveButtonVisible
End Sub

Public Sub setSaveButtonText(sValue As String)
	If sValue = Null Then sValue = ""
	msSaveButtonText = sValue.Trim
	If btnSigSaveView.IsInitialized Then btnSigSave.setText(msSaveButtonText)
End Sub

Public Sub getSaveButtonText As String
	Return msSaveButtonText
End Sub
#End Region

#Region Public Signature API
Public Sub Clear
	If PadComp.IsInitialized Then PadComp.Clear
End Sub

Public Sub IsEmpty As Boolean
	If PadComp.IsInitialized Then Return PadComp.IsEmpty
	Return True
End Sub

Public Sub GetBitmap As B4XBitmap
	If PadComp.IsInitialized Then Return PadComp.GetBitmap
	Return Null
End Sub

Public Sub GetBase64 As String
	If PadComp.IsInitialized Then Return PadComp.GetBase64
	Return ""
End Sub

Public Sub SetBase64(sBase64String As String)
	If PadComp.IsInitialized Then PadComp.SetBase64(sBase64String)
End Sub

Public Sub SetBitmap(bmpBmp As B4XBitmap)
	If PadComp.IsInitialized Then PadComp.SetBitmap(bmpBmp)
End Sub

Public Sub IsBase64(sValue As String) As Boolean
	Return PadComp.IsBase64(sValue)
End Sub
#End Region

#Region Validation
Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRequired As Boolean
	Return mbRequired
End Sub

Public Sub setLabelAbove(bValue As Boolean)
	mbLabelAbove = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelAbove As Boolean
	Return mbLabelAbove
End Sub

Public Sub setHintText(sValue As String)
	If sValue = Null Then sValue = ""
	msHintText = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHintText As String
	Return msHintText
End Sub

' Configures the failure message shown when validation fails. This does NOT
' display an error immediately; the error only renders after Validate fails or
' ShowError is called. Kept separate from the active error state so a required
' field can declare its ErrorText up front without showing red on load.
Public Sub setErrorText(sValue As String)
	If sValue = Null Then sValue = ""
	msErrorText = sValue.Trim
End Sub

Public Sub getErrorText As String
	Return msErrorText
End Sub

Public Sub ShowError(sErrorMessage As String)
	msActiveErrorText = sErrorMessage
	mbProgrammaticError = True
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub ClearError
	msActiveErrorText = ""
	mbProgrammaticError = False
	mbValidationTouched = False
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIsValid As Boolean
	Return (msActiveErrorText.Length = 0)
End Sub

Public Sub Validate As Boolean
	If mbRequired = False Then
		mbProgrammaticError = False
		ClearError
		Return True
	End If
	If PadComp.IsInitialized And PadComp.IsEmpty = False Then
		mbProgrammaticError = False
		ClearError
		Return True
	End If
	Dim msg As String = msErrorText
	If msg.Length = 0 Then msg = "Signature is required."
	mbValidationTouched = True
	ShowError(msg)
	Return False
End Sub

Public Sub ReceiveFocus
	If msActiveErrorText.Length > 0 And mbProgrammaticError = False Then
		msActiveErrorText = ""
		If mBase.IsInitialized Then Refresh
	End If
	If xui.SubExists(mCallBack, mEventName & "_FocusChanged", 1) Then
		CallSub2(mCallBack, mEventName & "_FocusChanged", True)
	End If
End Sub

Public Sub Blur
	If mbRequired And PadComp.IsInitialized And PadComp.IsEmpty Then
		If mbValidationTouched = False Then
			mbValidationTouched = True
		End If
	End If
	If xui.SubExists(mCallBack, mEventName & "_FocusChanged", 1) Then
		CallSub2(mCallBack, mEventName & "_FocusChanged", False)
	End If
End Sub
#End Region

#Region Fieldset Property Forwards
Public Sub setLegend(sValue As String)
	msLegend = sValue
	Refresh
End Sub

Public Sub getLegend As String
	Return msLegend
End Sub

Public Sub setLegendSize(sValue As String)
	msLegendSize = sValue
	Refresh
End Sub

Public Sub getLegendSize As String
	Return msLegendSize
End Sub

Public Sub setLegendBold(bValue As Boolean)
	mbLegendBold = bValue
	Refresh
End Sub

Public Sub getLegendBold As Boolean
	Return mbLegendBold
End Sub

Public Sub setVariant(sValue As String)
	msVariant = sValue
	Refresh
End Sub

Public Sub getVariant As String
	Return msVariant
End Sub

Public Sub setBorderStyle(sValue As String)
	msBorderStyle = B4XDaisyVariants.NormalizeFieldsetBorderStyle(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBorderStyle As String
	Return msBorderStyle
End Sub

Public Sub setRounded(sValue As String)
	msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
	If PadComp.IsInitialized Then PadComp.setRounded(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub isRoundedBox As Boolean
	Return (msRounded = "rounded-box" Or msRounded = "theme")
End Sub

Public Sub setShadow(sValue As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setPadding(iValue As Int)
	miPadding = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPadding As Int
	Return miPadding
End Sub

Public Sub setAutoHeight(bValue As Boolean)
	mbAutoHeight = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAutoHeight As Boolean
	Return mbAutoHeight
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mcBackgroundColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
	mcTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mcTextColor
End Sub

Public Sub setBorderColor(iValue As Int)
	mcBorderColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBorderColor As Int
	Return mcBorderColor
End Sub

Public Sub setBorderSize(iValue As Int)
	miBorderSize = Max(0, iValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBorderSize As Int
	Return miBorderSize
End Sub

Public Sub setInputBorder(bValue As Boolean)
	mbInputBorder = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputBorder As Boolean
	Return mbInputBorder
End Sub
#End Region

#Region Tag
Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub
#End Region

#Region Utility
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

Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

Public Sub Release
    If PadComp.IsInitialized Then PadComp.Release
    If FieldsetComp.IsInitialized Then FieldsetComp.Release
    If btnSigClear.IsInitialized Then btnSigClear.Release
    If btnSigSave.IsInitialized Then btnSigSave.Release
    If btnSigClearView.IsInitialized Then btnSigClearView.RemoveViewFromParent
    If btnSigSaveView.IsInitialized Then btnSigSaveView.RemoveViewFromParent
    If pnlHintText.IsInitialized Then pnlHintText.RemoveViewFromParent
    mCallBack = Null
End Sub