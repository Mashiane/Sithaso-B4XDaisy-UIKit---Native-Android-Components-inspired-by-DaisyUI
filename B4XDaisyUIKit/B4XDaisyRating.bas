B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: Changed(Value As Float)
#Event: FocusChanged (HasFocus As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Value, DisplayName: Value, FieldType: Float, DefaultValue: 0, Description: Current rating value (0 = no selection, use 0.5 for half stars).
#DesignerProperty: Key: MaxValue, DisplayName: Max Value, FieldType: Int, DefaultValue: 5, Description: Maximum number of rating items.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size variant (rating-xs through rating-xl).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant.
#DesignerProperty: Key: IconStyle, DisplayName: Icon Style, FieldType: String, DefaultValue: star-2, List: circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4, Description: Icon mask shape.
#DesignerProperty: Key: Half, DisplayName: Half Star, FieldType: Boolean, DefaultValue: False, Description: Enable half-star increments (rating-half parity).
#DesignerProperty: Key: AllowClear, DisplayName: Allow Clear, FieldType: Boolean, DefaultValue: False, Description: Allow clearing the rating by selecting same value (rating-hidden parity).
#DesignerProperty: Key: ReadOnly, DisplayName: Read Only, FieldType: Boolean, DefaultValue: False, Description: Read-only mode - no interaction, display only.
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether a rating value greater than 0 is required.
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: Color, DefaultValue: 0, Description: Custom color for active/filled items (0 = theme default bg-base-content).
#DesignerProperty: Key: InactiveColor, DisplayName: Inactive Color, FieldType: Color, DefaultValue: 0, Description: Custom color for inactive/empty items (0 = theme default opacity-20).
#DesignerProperty: Key: Gap, DisplayName: Gap (dip), FieldType: Int, DefaultValue: 4, Description: Gap between items in dip (maps to gap-1 ~ 4dip).
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: String, DefaultValue:, Description: Label text displayed above the rating.
#DesignerProperty: Key: LabelVisible, DisplayName: Label Visible, FieldType: Boolean, DefaultValue: False, Description: Whether the label above is visible.
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the rating.
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Text displayed below the rating when in the error validation state.
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private pnlSurface As B4XView
	Private cvsRating As B4XCanvas

	Private mfValue As Float = 0
	Private miMaxValue As Int = 5
	Private mSize As String = "md"
	Private msVariant As String = "none"
	Private msIconStyle As String = "star-2"
	Private mbHalf As Boolean = False
	Private mbAllowClear As Boolean = False
	Private mbReadOnly As Boolean = False
	Private mbRequired As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
	Private msErrorText As String = ""
	Private msLabelAbove As String = ""
	Private mbLabelVisible As Boolean = False
	Private msHintText As String = ""
	Private pnlLabelAbove As B4XView
	Private lblLabelAbove As B4XView
	Private pnlHintText As B4XView
	Private lblHintText As B4XView
	Private mcActiveColor As Int = 0
	Private mcInactiveColor As Int = 0
	Private miGap As Int = 4
	Private mbEnabled As Boolean = True
	Private mbVisible As Boolean = True

	Private mfItemSize As Float = 0
	Private mfItemGap As Float = 0

	Private mbDragging As Boolean = False
	Private mbCanvasReady As Boolean = False

	Private mActiveColors As List

	' DaisyUI token support map for parity validation:
	' align-middle appearance-none bg-base-content bg-green-400 bg-green-500
	' bg-orange-400 bg-red-400 bg-yellow-400 bg-lime-400 cursor-pointer gap-1
	' h-6 inline-flex mask mask-half-1 mask-half-2 mask-heart mask-star
	' mask-star-2 opacity-100 opacity-20 rating-lg rating-md rating-sm rating-xs
	' rating-xl rating-hidden rounded-none size-4 size-5 size-6 size-7 size-8
	' w-2 w-2.5 w-3 w-4 w-6 w-[.875rem] bg-transparent relative
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
	mActiveColors.Initialize
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("pnlSurface")
	pnlSurface = pSurface
	pnlSurface.Color = xui.Color_Transparent
	mBase.AddView(pnlSurface, 0, 0, mBase.Width, mBase.Height)

	' Create label-above chrome (lives in mBase, outside pnlSurface, so it never steals touch)
	Dim pLA As Panel
	pLA.Initialize("")
	pnlLabelAbove = pLA
	pnlLabelAbove.Color = xui.Color_Transparent
	mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)

	Dim lLA As Label
	lLA.Initialize("")
	lblLabelAbove = lLA
	lblLabelAbove.Color = xui.Color_Transparent
	lblLabelAbove.SetTextAlignment("LEFT", "LEFT")
	#If B4A
	lLA.SingleLine = False
	#End If
	pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

	' Create hint/error text chrome below the rating
	Dim pHT As Panel
	pHT.Initialize("")
	pnlHintText = pHT
	pnlHintText.Color = xui.Color_Transparent
	mBase.AddView(pnlHintText, 0, 0, 0, 0)

	Dim lHT As Label
	lHT.Initialize("")
	lblHintText = lHT
	lblHintText.Color = xui.Color_Transparent
	lblHintText.SetTextAlignment("LEFT", "LEFT")
	#If B4A
	lHT.SingleLine = False
	#End If
	pnlHintText.AddView(lblHintText, 0, 0, 0, 0)

	ApplyDesignerProps(mProps)
	#If B4A
		' setFocusable(True) allows keyboard/accessibility focus on the panel.
		' setFocusableInTouchMode is intentionally omitted: it would cause Android
		' to consume the first touch as a focus event, requiring a double-tap.
		Dim jo As JavaObject = pnlSurface
		jo.RunMethod("setFocusable", Array(True))
	#End If
	mBase.Visible = mbVisible
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mfValue = B4XDaisyVariants.GetPropFloat(mProps, "Value", mfValue)
	miMaxValue = B4XDaisyVariants.GetPropInt(mProps, "MaxValue", miMaxValue)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
	msIconStyle = B4XDaisyVariants.GetPropString(mProps, "IconStyle", msIconStyle)
	mbHalf = B4XDaisyVariants.GetPropBool(mProps, "Half", mbHalf)
	mbAllowClear = B4XDaisyVariants.GetPropBool(mProps, "AllowClear", mbAllowClear)
	mbReadOnly = B4XDaisyVariants.GetPropBool(mProps, "ReadOnly", mbReadOnly)
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
	mcActiveColor = B4XDaisyVariants.GetPropColor(mProps, "ActiveColor", mcActiveColor)
	mcInactiveColor = B4XDaisyVariants.GetPropColor(mProps, "InactiveColor", mcInactiveColor)
	miGap = B4XDaisyVariants.GetPropInt(mProps, "Gap", miGap)
	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
	msLabelAbove = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", msLabelAbove)
	mbLabelVisible = B4XDaisyVariants.GetPropBool(mProps, "LabelVisible", mbLabelVisible)
	msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", msHintText)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Value", mfValue)
	props.Put("MaxValue", miMaxValue)
	props.Put("Size", mSize)
	props.Put("Variant", msVariant)
	props.Put("IconStyle", msIconStyle)
	props.Put("Half", mbHalf)
	props.Put("AllowClear", mbAllowClear)
	props.Put("ReadOnly", mbReadOnly)
	props.Put("Required", mbRequired)
	props.Put("ActiveColor", mcActiveColor)
	props.Put("InactiveColor", mcInactiveColor)
	props.Put("Gap", miGap)
	props.Put("Enabled", mbEnabled)
	props.Put("Visible", mbVisible)
	props.Put("LabelAbove", msLabelAbove)
	props.Put("LabelVisible", mbLabelVisible)
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	Return props
End Sub
#End Region

#Region Public API
''' <summary>
''' Sets the current rating value.
''' </summary>
Public Sub setValue(fValue As Float)
	mfValue = Max(0, Min(fValue, miMaxValue))
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the current rating value.
''' </summary>
Public Sub getValue As Float
	Return mfValue
End Sub

''' <summary>
''' Sets the maximum number of rating items.
''' </summary>
Public Sub setMaxValue(iValue As Int)
	miMaxValue = Max(1, iValue)
	If mfValue > miMaxValue Then mfValue = miMaxValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the maximum number of rating items.
''' </summary>
Public Sub getMaxValue As Int
	Return miMaxValue
End Sub

''' <summary>
''' Sets the Size variant (rating-xs through rating-xl).
''' </summary>
Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the Size variant.
''' </summary>
Public Sub getSize As String
	Return mSize
End Sub

''' <summary>
''' Sets the color variant.
''' </summary>
Public Sub setVariant(sValue As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the color variant.
''' </summary>
Public Sub getVariant As String
	Return msVariant
End Sub

''' <summary>
''' Sets the icon mask style (mask-star, mask-star-2, mask-heart).
''' </summary>
Public Sub setIconStyle(sValue As String)
	msIconStyle = sValue.ToLowerCase
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the icon style.
''' </summary>
Public Sub getIconStyle As String
	Return msIconStyle
End Sub

''' <summary>
''' Sets half-star mode (rating-half parity).
''' </summary>
Public Sub setHalf(bValue As Boolean)
	mbHalf = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets half-star mode.
''' </summary>
Public Sub getHalf As Boolean
	Return mbHalf
End Sub

''' <summary>
''' Sets whether tapping the same value clears the rating (rating-hidden parity).
''' </summary>
Public Sub setAllowClear(bValue As Boolean)
	mbAllowClear = bValue
End Sub

''' <summary>
''' Gets whether clearing is allowed.
''' </summary>
Public Sub getAllowClear As Boolean
	Return mbAllowClear
End Sub

''' <summary>
''' Sets read-only mode. When True, the rating displays but does not respond to touch.
''' </summary>
Public Sub setReadOnly(bValue As Boolean)
	mbReadOnly = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets read-only mode.
''' </summary>
Public Sub getReadOnly As Boolean
	Return mbReadOnly
End Sub

''' <summary>
''' Sets the active/filled color (maps to bg-* color tokens). Pass 0 to use theme default.
''' </summary>
Public Sub setActiveColor(iValue As Int)
	mcActiveColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the active/filled color.
''' </summary>
Public Sub getActiveColor As Int
	Return mcActiveColor
End Sub

''' <summary>
''' Sets the inactive/empty color (maps to opacity-20). Pass 0 to use theme default.
''' </summary>
Public Sub setInactiveColor(iValue As Int)
	mcInactiveColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the inactive/empty color.
''' </summary>
Public Sub getInactiveColor As Int
	Return mcInactiveColor
End Sub

''' <summary>
''' Sets per-item colors for multi-color rating (e.g. mask-heart with multiple colors).
''' Resets when a new list is set. Pass Null or empty list to reset to uniform color.
''' </summary>
Public Sub SetItemColors(lstItemColorList As List)
	mActiveColors = lstItemColorList
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Sets the gap between items in dip (maps to gap-1 = 4dip).
''' </summary>
Public Sub setGap(iValue As Int)
	miGap = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the gap between items in dip.
''' </summary>
Public Sub getGap As Int
	Return miGap
End Sub

''' <summary>
''' Sets the Enabled state.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
	mbEnabled = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the Enabled state.
''' </summary>
Public Sub getEnabled As Boolean
	Return mbEnabled
End Sub

''' <summary>
''' Sets the Visible state.
''' </summary>
Public Sub setVisible(bValue As Boolean)
	mbVisible = bValue
	If mBase.IsInitialized Then
		mBase.Visible = bValue
		Refresh
	End If
End Sub

''' <summary>
''' Gets the Visible state.
''' </summary>
Public Sub getVisible As Boolean
	Return mbVisible
End Sub

''' <summary>
''' Sets the label text displayed above the rating.
''' </summary>
Public Sub setLabelAbove(sValue As String)
	If sValue = Null Then sValue = ""
	msLabelAbove = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the label text displayed above the rating.
''' </summary>
Public Sub getLabelAbove As String
	Return msLabelAbove
End Sub

''' <summary>
''' Sets whether the label above is visible.
''' </summary>
Public Sub setLabelVisible(bValue As Boolean)
	mbLabelVisible = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets whether the label above is visible.
''' </summary>
Public Sub getLabelVisible As Boolean
	Return mbLabelVisible
End Sub

''' <summary>
''' Sets the helper text displayed below the rating.
''' </summary>
Public Sub setHintText(sValue As String)
	If sValue = Null Then sValue = ""
	msHintText = sValue.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Gets the helper text displayed below the rating.
''' </summary>
Public Sub getHintText As String
	Return msHintText
End Sub

''' <summary>
''' Sets width using a Tailwind size token or dip value.
''' </summary>
Public Sub setWidth(sValue As String)
	If mBase.IsInitialized Then
		mBase.Width = B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Width)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

''' <summary>
''' Gets width string.
''' </summary>
Public Sub getWidth As String
	If mBase.IsInitialized Then Return mBase.Width & "dip"
	Return "0dip"
End Sub

''' <summary>
''' Sets height using a Tailwind size token or dip value.
''' </summary>
Public Sub setHeight(sValue As String)
	If mBase.IsInitialized Then
		mBase.Height = B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Height)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

''' <summary>
''' Gets height string.
''' </summary>
Public Sub getHeight As String
	If mBase.IsInitialized Then Return mBase.Height & "dip"
	Return "0dip"
End Sub

''' <summary>
''' Sets the component tag.
''' </summary>
Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

''' <summary>
''' Gets the component tag.
''' </summary>
Public Sub getTag As Object
	Return mTag
End Sub

''' <summary>
''' Sets the left position.
''' </summary>
Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

''' <summary>
''' Sets the top position.
''' </summary>
Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
End Sub

''' <summary>
''' Returns the component role identifier.
''' </summary>
Public Sub getRole As String
	Return "rating"
End Sub

''' <summary>
''' Re-resolves theme-aware colors from the active palette.
''' </summary>
Public Sub UpdateTheme
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

''' <summary>
''' Applies the current component state to the UI.
''' </summary>
Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	If pnlSurface.IsInitialized = False Then Return

	If mbEnabled Then
		mBase.Alpha = 1.0
	Else
		mBase.Alpha = 0.3
	End If

	#If B4A
	B4XDaisyVariants.DisableClippingRecursive(mBase)
	B4XDaisyVariants.DisableClipping(pnlSurface)
	#End If

	Base_Resize(mBase.Width, mBase.Height)
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase

	Dim targetH As Int = iHeight
	If targetH <= 0 Then targetH = ResolveItemSizeDip
	Dim targetW As Int = iWidth
	If targetW <= 0 Then targetW = ComputePreferredWidth

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		DesignerCreateView(p, Null, BuildRuntimeProps(targetW, targetH))
	End If

	vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
	Refresh
	Return mBase
End Sub

''' <summary>
''' Returns the core view instance.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Gets the computed height based on size.
''' </summary>
Public Sub getComputedHeight As Int
	If mBase.IsInitialized = False Then Return ResolveItemSizeDip
	Return mBase.Height
End Sub

''' <summary>
''' Programmatic layout helper.
''' </summary>
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
End Sub

''' <summary>
''' Sets the background color variant for theme-aware styling.
''' </summary>
Public Sub setBackgroundColorVariant(sVariant As String)
	Dim resolved As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(sVariant, mcActiveColor)
	If resolved <> 0 Then mcActiveColor = resolved
	Refresh
End Sub

''' <summary>
''' Sets the text/content color variant for theme-aware styling.
''' </summary>
Public Sub setTextColorVariant(sVariant As String)
	Dim resolved As Int = B4XDaisyVariants.ResolveTextColorVariant(sVariant, mcInactiveColor)
	If resolved <> 0 Then mcInactiveColor = resolved
	Refresh
End Sub

''' <summary>
''' Requests focus for the component.
''' </summary>
Public Sub RequestFocus
	If pnlSurface.IsInitialized Then pnlSurface.RequestFocus
End Sub

''' <summary>
''' Sets or clears focus for the component.
''' </summary>
Public Sub setFocus(bValue As Boolean)
	If pnlSurface.IsInitialized = False Then Return
	#If B4A
		Dim jo As JavaObject = pnlSurface
		If bValue Then jo.RunMethod("requestFocus", Null) Else jo.RunMethod("clearFocus", Null)
	#End If
End Sub

''' <summary>
''' Called when the rating receives focus. Clears any transient
''' validation error visual so the user can interact without a distracting red border.
''' </summary>
Public Sub ReceiveFocus
        If msErrorText.Length > 0 And mbProgrammaticError = False Then
                msErrorText = ""
        End If
        If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Called when the component loses focus.
''' </summary>
Public Sub Blur
    If mBase.IsInitialized Then Refresh
End Sub
#End Region

#Region Layout and Drawing
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If pnlSurface.IsInitialized = False Then Return

	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)

	' --- Label Above (caption + required red star) ---
	Dim labelAboveH As Int = 0
	Dim measuredLabelH As Int = 0
	If mbLabelVisible And msLabelAbove.Length > 0 Then
		Dim aboveTextSize As Float = B4XDaisyVariants.ResolveLabelSizeDip(mSize)
		Dim labelText As String = ResolveLabelAboveText
		measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(labelText, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
		labelAboveH = measuredLabelH + 4dip
	End If

	' --- Hint / Error text below ---
	Dim displayedHint As String = msHintText
	If msErrorText.Length > 0 Then displayedHint = msErrorText
	Dim rawHintH As Int = 0
	Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
	If displayedHint.Length > 0 Then
		rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
	End If
	Dim gap As Int = 4dip

	' --- Determine rating band + total height ---
	' Auto-grow only when chrome (label/hint) is present so existing chrome-less
	' usage runs the original code path verbatim (zero regression).
	Dim hasChrome As Boolean = (labelAboveH > 0) Or (rawHintH > 0)
	Dim surfaceY As Int = 0
	Dim surfaceH As Int = h
	If hasChrome Then
		Dim bandH As Int = ResolveItemSizeDip
		surfaceY = labelAboveH
		surfaceH = bandH
		Dim totalH As Int = labelAboveH + bandH
		If rawHintH > 0 Then totalH = totalH + gap + rawHintH
		If h <> totalH Then
			h = totalH
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
		End If
	End If

	' --- Position label above ---
	If labelAboveH > 0 Then
		pnlLabelAbove.Visible = True
		pnlLabelAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
		lblLabelAbove.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, measuredLabelH)
		Dim labelAboveColor As Int = ResolveLabelAboveColor
		ApplyRequiredLabelText(lblLabelAbove, ResolveLabelAboveText, labelAboveColor, ResolveRequiredStarColor(labelAboveColor))
		lblLabelAbove.TextSize = B4XDaisyVariants.ResolveLabelSizeDip(mSize)
	Else
		If pnlLabelAbove.IsInitialized Then
			pnlLabelAbove.Visible = False
			pnlLabelAbove.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	End If

	' --- Rating surface occupies the band ---
	pnlSurface.SetLayoutAnimated(0, 0, surfaceY, w, surfaceH)

	mfItemSize = ResolveItemSizeDip
	mfItemGap = miGap * 1dip

	If mbCanvasReady = False Then
		cvsRating.Initialize(pnlSurface)
		mbCanvasReady = True
	Else
		cvsRating.Resize(w, surfaceH)
	End If
	cvsRating.ClearRect(cvsRating.TargetRect)
	DrawRating
	cvsRating.Invalidate

	' --- Hint / error text below the rating ---
	If rawHintH > 0 Then
		pnlHintText.Visible = True
		lblHintText.Text = displayedHint
		lblHintText.TextSize = hintTxtSize
		Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
		Dim hintColor As Int = Bit.Or(0x99000000, Bit.And(0x00FFFFFF, baseContent))
		If msErrorText.Length > 0 Then hintColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
		lblHintText.TextColor = hintColor
		Dim hintY As Int = surfaceY + surfaceH + gap
		pnlHintText.SetLayoutAnimated(0, 0, hintY, w, rawHintH)
		lblHintText.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, rawHintH)
	Else
		If pnlHintText.IsInitialized Then
			pnlHintText.Visible = False
			pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
		End If
	End If
	inResize = False
End Sub

Private Sub DrawRating
	Dim w As Float = pnlSurface.Width
	Dim h As Float = pnlSurface.Height
	Dim itemSize As Float = mfItemSize
	Dim gapSize As Float = mfItemGap

	Dim xColors As Map = ResolveVisualColors
	Dim activeColor As Int = xColors.Get("activeColor")
	Dim inactiveColor As Int = xColors.Get("inactiveColor")

	If mbHalf Then
		DrawHalfRating(w, h, itemSize, gapSize, activeColor, inactiveColor)
	Else
		DrawFullRating(w, h, itemSize, gapSize, activeColor, inactiveColor)
	End If
End Sub

''' <summary>
''' Draws full-star rating items (non-half mode).
''' Parity: CSS .rating :where(*) opacity-20 for inactive, opacity-100 for checked/preceding.
''' </summary>
Private Sub DrawFullRating(fW As Float, fH As Float, fItemSize As Float, fGapSize As Float, iActiveColor As Int, iInactiveColor As Int)
	Dim valInt As Int = Floor(mfValue)
	Dim i As Int

	For i = 1 To miMaxValue
		Dim itemX As Float = (i - 1) * (fItemSize + fGapSize)
		Dim itemColor As Int

		If i <= valInt Then
			itemColor = ResolveItemColor(i, iActiveColor)
		Else
			itemColor = ResolveItemInactiveColor(i, iInactiveColor)
		End If

		DrawIcon(msIconStyle, itemX, (fH - fItemSize) / 2, fItemSize, itemColor)
	Next
End Sub

''' <summary>
''' Draws half-star rating items (rating-half mode).
''' Parity: CSS .rating-half with mask-half-1 and mask-half-2.
''' </summary>
Private Sub DrawHalfRating(fW As Float, fH As Float, fItemSize As Float, fGapSize As Float, iActiveColor As Int, iInactiveColor As Int)
	Dim halfW As Float = ResolveHalfWidthDip
	Dim fullW As Float = halfW * 2
	Dim centerY As Float = fH / 2

	Dim i As Int
	For i = 1 To miMaxValue
		Dim itemStartX As Float = (i - 1) * (fullW + fGapSize)

		Dim leftHalfActive As Boolean = False
		Dim rightHalfActive As Boolean = False

		Dim itemStart As Float = i - 1
		Dim itemEnd As Float = i

		If mfValue >= itemEnd Then
			leftHalfActive = True
			rightHalfActive = True
		Else If mfValue >= itemStart + 0.5 Then
			leftHalfActive = True
			rightHalfActive = False
		End If

		Dim leftColor As Int
		Dim rightColor As Int

		If leftHalfActive Then
			leftColor = ResolveItemColor(i, iActiveColor)
		Else
			leftColor = ResolveItemInactiveColor(i, iInactiveColor)
		End If

		If rightHalfActive Then
			rightColor = ResolveItemColor(i, iActiveColor)
		Else
			rightColor = ResolveItemInactiveColor(i, iInactiveColor)
		End If

		Dim itemY As Float = centerY - fItemSize / 2
		Dim iconPath As B4XPath = CreateIconPath(msIconStyle, itemStartX, itemY, fItemSize)

		' Left half: clip to icon shape, fill left half with leftColor
		cvsRating.ClipPath(iconPath)
		cvsRating.DrawRect(CreateRect(itemStartX, itemY, itemStartX + halfW, itemY + fItemSize), leftColor, True, 0)
		cvsRating.RemoveClip

		' Right half: clip to icon shape, fill right half with rightColor
		Dim iconPathR As B4XPath = CreateIconPath(msIconStyle, itemStartX, itemY, fItemSize)
		cvsRating.ClipPath(iconPathR)
		cvsRating.DrawRect(CreateRect(itemStartX + halfW, itemY, itemStartX + fullW, itemY + fItemSize), rightColor, True, 0)
		cvsRating.RemoveClip
	Next
End Sub

''' <summary>
''' Draws a filled icon (star, star-2, or heart) at the specified position.
''' </summary>
Private Sub DrawIcon(sIconStyle As String, fX As Float, fY As Float, fSize As Float, iColor As Int)
	Dim path As B4XPath = CreateIconPath(sIconStyle, fX, fY, fSize)
	cvsRating.DrawPath(path, iColor, True, 0)
End Sub

''' <summary>
''' Creates a path for the specified icon style by delegating to B4XDaisyVariants.
''' </summary>
Private Sub CreateIconPath(sIconStyle As String, fX As Float, fY As Float, fSize As Float) As B4XPath
	Dim r As B4XRect
	r.Initialize(fX, fY, fX + fSize, fY + fSize)
	Return B4XDaisyVariants.CreateMaskPathInRect(r, sIconStyle)
End Sub

Private Sub CreateRect(fLeft As Float, fTop As Float, fRight As Float, fBottom As Float) As B4XRect
	Dim r As B4XRect
	r.Initialize(fLeft, fTop, fRight, fBottom)
	Return r
End Sub

''' <summary>
''' Resolves active and inactive colors from theme tokens.
''' Parity: CSS bg-base-content for active, opacity-20 of bg-base-content for inactive.
''' </summary>
Private Sub ResolveVisualColors As Map
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))

	Dim activeCol As Int = baseContent
	If msVariant.ToLowerCase <> "none" Then
		activeCol = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, baseContent)
	End If

	Dim inactiveCol As Int = B4XDaisyVariants.AlphaColor(activeCol, 0.2)

	If mcActiveColor <> 0 Then
		activeCol = mcActiveColor
	End If

	If mcInactiveColor <> 0 Then
		inactiveCol = mcInactiveColor
	End If

	Return CreateMap("activeColor": activeCol, "inactiveColor": inactiveCol)
End Sub

''' <summary>
''' Returns the per-item active color if set via SetItemColors, otherwise the default.
''' </summary>
Private Sub ResolveItemColor(iIndex As Int, iDefaultColor As Int) As Int
	If mActiveColors.IsInitialized And mActiveColors.Size > 0 Then
		If iIndex >= 1 And iIndex <= mActiveColors.Size Then
			Dim c As Int = mActiveColors.Get(iIndex - 1)
			If c <> 0 Then Return c
		End If
	End If
	Return iDefaultColor
End Sub

''' <summary>
''' Returns the per-item inactive color. Currently always the default inactive color.
''' </summary>
Private Sub ResolveItemInactiveColor(iIndex As Int, iDefaultColor As Int) As Int
	If mActiveColors.IsInitialized And mActiveColors.Size > 0 Then
		If iIndex >= 1 And iIndex <= mActiveColors.Size Then
			Dim c As Int = mActiveColors.Get(iIndex - 1)
			If c <> 0 Then Return B4XDaisyVariants.AlphaColor(c, 0.2)
		End If
	End If
	Return iDefaultColor
End Sub

''' <summary>
''' Maps size variant tokens to dip values.
''' Parity: CSS rating-xs=size-4(16px), rating-sm=size-5(20px), rating-md=size-6(24px=h-6), rating-lg=size-7(28px), rating-xl=size-8(32px).
''' </summary>
Private Sub ResolveItemSizeDip As Float
	Select Case mSize.ToLowerCase
		Case "xs": Return 16dip
		Case "sm": Return 20dip
		Case "md": Return 24dip
		Case "lg": Return 28dip
		Case "xl": Return 32dip
		Case Else: Return B4XDaisyVariants.TailwindSizeToDip(mSize, 24dip)
	End Select
End Sub

''' <summary>
''' Maps half-width sizes to dip values per CSS rating-half dimensions.
''' Parity: rating-half rating-xs=w-2, rating-sm=w-2.5, rating-md=w-3, rating-lg=w-[.875rem], rating-xl=w-4.
''' </summary>
Private Sub ResolveHalfWidthDip As Float
	Return ResolveItemSizeDip / 2
End Sub

''' <summary>
''' Computes the preferred width based on current settings.
''' </summary>
Private Sub ComputePreferredWidth As Int
	Dim itemSize As Float = ResolveItemSizeDip
	Dim gapSize As Float = miGap * 1dip
	If mbHalf Then
		Dim halfW As Float = ResolveHalfWidthDip
		Return miMaxValue * halfW * 2 + (miMaxValue - 1) * gapSize
	Else
		Return miMaxValue * itemSize + (miMaxValue - 1) * gapSize
	End If
End Sub

' --- Label Above / Required red-star / Hint helpers (mirrors B4XDaisyRange) ---

Private Sub ResolveLabelAboveText As String
	If mbRequired And msLabelAbove.Length > 0 Then
		If msLabelAbove.Contains("*") = False Then
			Return msLabelAbove & " *"
		End If
	End If
	Return msLabelAbove
End Sub

Private Sub ResolveLabelAboveColor As Int
	Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	If mbEnabled = False Then
		Return B4XDaisyVariants.AlphaColor(c, 0.2)
	End If
	Return c
End Sub

Private Sub ResolveRequiredStarColor(iNormalColor As Int) As Int
	If mbEnabled = False Then Return iNormalColor
	Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
End Sub

Private Sub ApplyRequiredLabelText(vLbl As B4XView, sDisplayText As String, iNormalColor As Int, iStarColor As Int)
	If sDisplayText.Length = 0 Then
		vLbl.Text = ""
		Return
	End If
	If mbRequired And sDisplayText.Contains("*") Then
		Dim starPos As Int = sDisplayText.LastIndexOf("*")
		If starPos >= 0 Then
			Dim basePart As String = sDisplayText.SubString2(0, starPos)
			Dim cs As CSBuilder
			cs.Initialize
			If basePart.Length > 0 Then
				cs.Append(basePart)
			End If
			cs.Color(iStarColor).Append("*").Pop
			vLbl.TextColor = iNormalColor
			B4XDaisyVariants.SetTextOrCSBuilderToLabel(vLbl, cs)
			Return
		End If
	End If
	vLbl.Text = sDisplayText
	vLbl.TextColor = iNormalColor
End Sub
#End Region

#Region Touch and Interaction
Private Sub pnlSurface_Touch(iAction As Int, fX As Float, fY As Float)
	If mbEnabled = False Then Return
	If mbReadOnly Then Return
	If mBase.Width <= 0 Then Return

	Select iAction
		Case mBase.TOUCH_ACTION_DOWN
			mbDragging = True
			UpdateValueFromTouch(fX)
		Case mBase.TOUCH_ACTION_MOVE
			If mbDragging Then
				UpdateValueFromTouch(fX)
			End If
		Case Else
			' Handles TOUCH_ACTION_UP and system cancel
			If mbDragging Then
				mbDragging = False
			End If
	End Select
End Sub

Private Sub UpdateValueFromTouch(fX As Float)
	Dim newVal As Float

	If mbHalf Then
		newVal = ValueFromHalfTouch(fX)
	Else
		newVal = ValueFromFullTouch(fX)
	End If

	If newVal = mfValue And mbAllowClear Then
		newVal = 0
	End If

	If newVal <> mfValue Then
		mfValue = newVal
		Refresh
		RaiseChanged(mfValue)
	End If
End Sub

''' <summary>
''' Calculates value from touch position in full-star mode.
''' </summary>
Private Sub ValueFromFullTouch(fX As Float) As Float
	Dim itemSize As Float = mfItemSize
	Dim gapSize As Float = mfItemGap
	Dim trackWidth As Float = itemSize * miMaxValue + gapSize * (miMaxValue - 1)

	If trackWidth <= 0 Then Return 0

	Dim pct As Float = fX / trackWidth
	pct = Max(0, Min(pct, 1.0))

	Dim rawVal As Float = pct * miMaxValue
	If rawVal <= 0.5 Then
		If mbAllowClear Then
			Return 0
		Else
			Return 1
		End If
	Else
		Return Ceil(rawVal)
	End If
End Sub

''' <summary>
''' Calculates value from touch position in half-star mode.
''' </summary>
Private Sub ValueFromHalfTouch(fX As Float) As Float
	Dim halfW As Float = ResolveHalfWidthDip
	Dim fullW As Float = halfW * 2
	Dim gapSize As Float = mfItemGap
	Dim trackWidth As Float = fullW * miMaxValue + gapSize * (miMaxValue - 1)

	If trackWidth <= 0 Then Return 0

	Dim pct As Float = fX / trackWidth
	pct = Max(0, Min(pct, 1.0))

	Dim rawVal As Float = pct * miMaxValue * 2
	Dim finalVal As Float = Round(rawVal) * 0.5
	If finalVal < 0.5 And mbAllowClear = False Then
		Return 0.5
	Else
		Return finalVal
	End If
End Sub

Private Sub RaiseChanged(fVal As Float)
	If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", fVal)
	End If
End Sub
#End Region


Private Sub pnlSurface_FocusChanged(bHasFocus As Boolean)
        ' Route focus changes through public validation hooks:
        ' clear transient errors on focus, re-validate on blur.
        If bHasFocus Then
                ReceiveFocus
        Else
                Blur
        End If
        If xui.SubExists(mCallBack, mEventName & "_FocusChanged", 1) Then
                CallSub2(mCallBack, mEventName & "_FocusChanged", bHasFocus)
        End If
End Sub

#Region Cleanup

' Required / error validation helpers
Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRequired As Boolean
	Return mbRequired
End Sub

Public Sub setErrorText(sValue As String)
	If sValue = Null Then sValue = ""
	msErrorText = sValue.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getErrorText As String
	Return msErrorText
End Sub

Public Sub getIsValid As Boolean
	Return (msErrorText.Length = 0)
End Sub

''' <summary>
''' Dynamically sets the rating into an error validation state and displays the specified error text.
''' </summary>
Public Sub ShowError(sErrorMessage As String)
        msErrorText = sErrorMessage
        mbProgrammaticError = True
        If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Clears any dynamic error state and returns the rating to normal.
''' </summary>
Public Sub ClearError
        msErrorText = ""
        mbProgrammaticError = False
        mbValidationTouched = False
        If mBase.IsInitialized Then Refresh
End Sub

Public Sub Validate As Boolean
	If mbRequired = False Then
        mbProgrammaticError = False
		msErrorText = ""
		Return True
	End If
	If mfValue > 0 Then
        mbProgrammaticError = False
		msErrorText = ""
		Return True
	End If
        mbValidationTouched = True
	If msErrorText.Length = 0 Then msErrorText = "This field is required."
	Return False
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Release
	mCallBack = Null
	If mActiveColors.IsInitialized Then mActiveColors.Clear
	cvsRating.Release
	pnlSurface = Null
	cvsRating = Null
	pnlLabelAbove = Null
	lblLabelAbove = Null
	pnlHintText = Null
	lblHintText = Null
End Sub
#End Region

#Region B4XView Layout Wrapper Methods
Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
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
