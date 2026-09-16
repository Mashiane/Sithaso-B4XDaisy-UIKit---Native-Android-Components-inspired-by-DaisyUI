B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
'-
' B4XDaisyInputOTP
' 
' WHAT IS THIS?
' Think of this as a set of pin entry boxes (like when a bank sends you a 4-digit code).
' It is built to look and act exactly like the modern "ion-input-otp" component from Ionic v8.
' Since mobile devices don't have standard web APIs, this translates that web design into
' native Android/iOS views, giving users a smooth, high-quality mobile experience.
'-
#IgnoreWarnings:12,9

#Region Events
#Event: Input (Value As String)
#Event: Changed (Value As String)
#Event: Complete (Value As String)
#Event: Focus
#Event: Blur
#Event: DescriptionClick
#End Region

#Region Designer Properties
' Core API
#DesignerProperty: Key: Length, DisplayName: Length, FieldType: Int, DefaultValue: 4, MinRange: 2, MaxRange: 10, Description: Number of input boxes.
#DesignerProperty: Key: InputType, DisplayName: Input Type, FieldType: String, DefaultValue: number, List: number|text, Description: Input type format (enforces numeric or text keyboard).
#DesignerProperty: Key: Value, DisplayName: Value, FieldType: String, DefaultValue:, Description: Pre-fills the OTP boxes.
#DesignerProperty: Key: Separators, DisplayName: Separators, FieldType: String, DefaultValue:, Description: Comma-separated indices (e.g., "1,3") or "all".
#DesignerProperty: Key: Pattern, DisplayName: Pattern, FieldType: String, DefaultValue:, Description: Regex char-class for allowed characters. Defaults by Type.

' Visual Presentation
#DesignerProperty: Key: Shape, DisplayName: Shape, FieldType: String, DefaultValue: round, List: round|soft|rectangular, Description: Border radius styling.
#DesignerProperty: Key: Fill, DisplayName: Fill, FieldType: String, DefaultValue: outline, List: outline|solid, Description: Input box background style.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Dimension token for the input boxes.
#DesignerProperty: Key: Gap, DisplayName: Gap (dip), FieldType: Int, DefaultValue: -1, MinRange: -1, MaxRange: 48, Description: Gap between input boxes in dip. -1 = auto from Size.
#DesignerProperty: Key: Variant, DisplayName: Variant/Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error
#DesignerProperty: Key: FocusVariant, DisplayName: Focus Variant, FieldType: String, DefaultValue: primary, List: none|neutral|primary|secondary|accent|info|success|warning|error

' States
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: ReadOnly, DisplayName: Read Only, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: ValidationState, DisplayName: Validation State, FieldType: String, DefaultValue: none, List: none|valid|invalid, Description: Manual validation styling (maps to ion-valid/ion-invalid).

' Assistive Text
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: String, DefaultValue:
#DesignerProperty: Key: Description, DisplayName: Description (slot), FieldType: String, DefaultValue:, Description: Slotted description text shown below the boxes (ionic slot equiv).
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private pnlSurface As B4XView
	Private pnlLabelAbove, pnlDescription, pnlHintText As B4XView
	Private lblLabelAbove, lblDescription, lblHintText As B4XView

	Private mBoxes As List
	Private mSeparatorsList As List
	Private mSeparatorViews As List

	' API Properties
	Private miLength As Int = 4
	Private msType As String = "number"
	Private msValue As String = ""
	Private msSeparators As String = ""
	Private msPattern As String = ""
	Private msShape As String = "round"
	Private msRounded As String = "theme"
	Private msFill As String = "outline"
	Private msSize As String = "md"
	Private miGap As Int = -1

	Private mbEnabled As Boolean = True
	Private mbReadOnly As Boolean = False
	Private mbVisible As Boolean = True
	Private mbRequired As Boolean = False
	Private msVariant As String = "none"
	Private msFocusVariant As String = "primary"
	Private msValidationState As String = "none"

	Private msLabelAbove, msDescription, msHintText, msErrorText As String

	' Internal State
	Private mbFocused As Boolean = False
	Private miActiveBoxIndex As Int = -1
	Private mIsPopulating As Boolean = False
	Private msLastCommittedValue As String = ""
	Private mbTouched As Boolean = False
	Private msFocusedValue As String = ""
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	mBoxes.Initialize
	mSeparatorsList.Initialize
	mSeparatorViews.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	pnlLabelAbove = xui.CreatePanel("")
	lblLabelAbove = CreateLabel("BOTTOM", "LEFT")
	mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)
	pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

	pnlSurface = xui.CreatePanel("")
	mBase.AddView(pnlSurface, 0, 0, 0, 0)

	pnlDescription = xui.CreatePanel("pnlDescription")
	lblDescription = CreateLabel("TOP", "CENTER")
	mBase.AddView(pnlDescription, 0, 0, 0, 0)
	pnlDescription.AddView(lblDescription, 0, 0, 0, 0)

	pnlHintText = xui.CreatePanel("")
	lblHintText = CreateLabel("TOP", "LEFT")
	mBase.AddView(pnlHintText, 0, 0, 0, 0)
	pnlHintText.AddView(lblHintText, 0, 0, 0, 0)

	ApplyDesignerProps(mProps)
	RebuildBoxes
	Refresh
End Sub

Private Sub CreateLabel(sVAlign As String, sHAlign As String) As B4XView
	Dim l As Label
	l.Initialize("")
	Dim xl As B4XView = l
	xl.Color = xui.Color_Transparent
	xl.SetTextAlignment(sVAlign, sHAlign)
	l.SingleLine = False
	Return xl
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	miLength = Max(2, Min(10, B4XDaisyVariants.GetPropInt(mProps, "Length", miLength)))
	msType = B4XDaisyVariants.GetPropString(mProps, "InputType", msType)
	msValue = B4XDaisyVariants.GetPropString(mProps, "Value", msValue)
	msSeparators = B4XDaisyVariants.GetPropString(mProps, "Separators", msSeparators)
	msPattern = B4XDaisyVariants.GetPropString(mProps, "Pattern", msPattern)
	msShape = B4XDaisyVariants.GetPropString(mProps, "Shape", msShape)
	msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded)
	msFill = B4XDaisyVariants.GetPropString(mProps, "Fill", msFill)
	msSize = B4XDaisyVariants.GetPropString(mProps, "Size", msSize)
	miGap = B4XDaisyVariants.GetPropInt(mProps, "Gap", -1)

	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbReadOnly = B4XDaisyVariants.GetPropBool(mProps, "ReadOnly", mbReadOnly)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)

	msLabelAbove = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", "")
	msDescription = B4XDaisyVariants.GetPropString(mProps, "Description", "")
	msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", "")
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", "")
	msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
	msFocusVariant = B4XDaisyVariants.GetPropString(mProps, "FocusVariant", msFocusVariant)
	msValidationState = B4XDaisyVariants.GetPropString(mProps, "ValidationState", "none")

	ParseSeparators
End Sub

Private Sub ParseSeparators
	mSeparatorsList.Clear
	If msSeparators.Length > 0 Then
		If msSeparators.ToLowerCase.Trim = "all" Then
			For i = 1 To miLength - 1
				mSeparatorsList.Add(i)
			Next
		Else
			Dim parts() As String = Regex.Split(",", msSeparators)
			For Each p As String In parts
				Dim t As String = p.Trim
				If IsNumber(t) Then
					Dim n As Int = t
					If n <= miLength And mSeparatorsList.IndexOf(n) = -1 Then mSeparatorsList.Add(n)
				End If
			Next
		End If
	End If
End Sub
#End Region

#Region Runtime API (AddToParent + property getters/setters)
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	Dim targetH As Int = iHeight
	If targetH <= 0 Then targetH = ResolveComponentHeightDip
	Dim targetW As Int = iWidth
	If targetW <= 0 Then targetW = Max(240dip, vParent.Width - iLeft * 2)
	If targetW <= 0 Then targetW = 240dip
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, targetW, targetH)
	Dim props As Map = BuildRuntimeProps(targetW, targetH)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Dim finalH As Int = mBase.Height
	vParent.AddView(mBase, iLeft, iTop, targetW, finalH)
	Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Length", miLength)
	props.Put("InputType", msType)
	props.Put("Value", msValue)
	props.Put("Separators", msSeparators)
	props.Put("Pattern", msPattern)
	props.Put("Shape", msShape)
	props.Put("Rounded", msRounded)
	props.Put("Fill", msFill)
	props.Put("Size", msSize)
	props.Put("Gap", miGap)
	props.Put("Variant", msVariant)
	props.Put("FocusVariant", msFocusVariant)
	props.Put("Enabled", mbEnabled)
	props.Put("ReadOnly", mbReadOnly)
	props.Put("Visible", mbVisible)
	props.Put("Required", mbRequired)
	props.Put("ValidationState", msValidationState)
	props.Put("LabelAbove", msLabelAbove)
	props.Put("Description", msDescription)
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	Return props
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub setTag(oValue As Object)
	mTag = oValue
	If mBase.IsInitialized Then mBase.Tag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub getLength As Int
	Return miLength
End Sub

Public Sub setLength(iValue As Int)
	miLength = Max(2, Min(10, iValue))
	ParseSeparators
	RebuildBoxes
	Refresh
End Sub

Public Sub getInputType As String
	Return msType
End Sub

Public Sub setInputType(sValue As String)
	msType = sValue
	RebuildBoxes
	Refresh
End Sub

Public Sub getValue As String
	Return getValueInternal
End Sub

Public Sub setValue(sValue As String)
	DistributeValueToBoxes(sValue)
End Sub

Public Sub getSeparators As String
	Return msSeparators
End Sub

Public Sub setSeparators(sValue As String)
	msSeparators = sValue
	ParseSeparators
	RebuildBoxes
	Refresh
End Sub

Public Sub getPattern As String
	Return msPattern
End Sub

Public Sub setPattern(sValue As String)
	msPattern = sValue
End Sub

Public Sub getShape As String
	Return msShape
End Sub

Public Sub setShape(sValue As String)
	msShape = sValue
	Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub setRounded(sValue As String)
	msRounded = sValue
	Refresh
End Sub

Public Sub getFill As String
	Return msFill
End Sub

Public Sub setFill(sValue As String)
	msFill = sValue
	Refresh
End Sub

Public Sub getSize As String
	Return msSize
End Sub

Public Sub setSize(sValue As String)
	msSize = sValue
	RebuildBoxes
	Refresh
End Sub

Public Sub getGap As Int
	Return miGap
End Sub

Public Sub setGap(iValue As Int)
	miGap = iValue
	Refresh
End Sub

Public Sub getVariant As String
	Return msVariant
End Sub

Public Sub setVariant(sValue As String)
	msVariant = sValue
	Refresh
End Sub

Public Sub getFocusVariant As String
	Return msFocusVariant
End Sub

Public Sub setFocusVariant(sValue As String)
	msFocusVariant = sValue
	Refresh
End Sub

Public Sub getEnabled As Boolean
	Return mbEnabled
End Sub

Public Sub setEnabled(bValue As Boolean)
	mbEnabled = bValue
	ApplyVisualToBoxes
End Sub

Public Sub getReadOnly As Boolean
	Return mbReadOnly
End Sub

Public Sub setReadOnly(bValue As Boolean)
	mbReadOnly = bValue
	ApplyVisualToBoxes
End Sub

Public Sub getVisible As Boolean
	Return mbVisible
End Sub

Public Sub setVisible(bValue As Boolean)
	mbVisible = bValue
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getRequired As Boolean
	Return mbRequired
End Sub

Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	Refresh
End Sub

Public Sub getValidationState As String
	Return msValidationState
End Sub

Public Sub setValidationState(sValue As String)
	msValidationState = sValue
	ApplyVisualToBoxes
End Sub

Public Sub getLabelAbove As String
	Return msLabelAbove
End Sub

Public Sub setLabelAbove(sValue As String)
	msLabelAbove = sValue
	Refresh
End Sub

Public Sub getDescription As String
	Return msDescription
End Sub

Public Sub setDescription(sValue As String)
	msDescription = sValue
	Refresh
End Sub

Public Sub getHintText As String
	Return msHintText
End Sub

Public Sub setHintText(sValue As String)
	msHintText = sValue
	Refresh
End Sub

Public Sub getErrorText As String
	Return msErrorText
End Sub

Public Sub setErrorText(sValue As String)
	msErrorText = sValue
	If sValue.Length > 0 Then msValidationState = "invalid"
	Refresh
End Sub

Public Sub getIsComplete As Boolean
	Return getValueInternal.Length = miLength
End Sub

Public Sub getIsValid As Boolean
	Return getValueInternal.Length = miLength
End Sub

Public Sub getFocused As Boolean
	Return mbFocused
End Sub

Public Sub HandleDeleteKey
	If mbReadOnly Or Not(mbEnabled) Then Return
	If miActiveBoxIndex > 0 And miActiveBoxIndex < mBoxes.Size Then
		Dim activeBox As B4XView = mBoxes.Get(miActiveBoxIndex)
		If activeBox.Text.Length = 0 Then
			Dim prevBox As B4XView = mBoxes.Get(miActiveBoxIndex - 1)
			mIsPopulating = True
			prevBox.Text = ""
			mIsPopulating = False
			prevBox.RequestFocus
			RaiseInputEvent
		End If
	End If
End Sub

Public Sub Refresh
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub GetComputedHeight As Int
	Return ResolveComponentHeightDip
End Sub

Public Sub GetActualHeight As Int
	If mBase.IsInitialized Then Return mBase.Height Else Return ResolveComponentHeightDip
End Sub
#End Region

#Region Rendering and Layout
Private Sub RebuildBoxes
	pnlSurface.RemoveAllViews
	mBoxes.Clear
	mSeparatorViews.Clear
	mIsPopulating = True
	Dim joMe As JavaObject = Me

	For i = 0 To miLength - 1
		Dim et As EditText = joMe.RunMethod("createOTPBox", Array As Object("box"))
		Dim xEt As B4XView = et
		xEt.Tag = i
		et.Color = xui.Color_Transparent
		et.TextSize = ResolveTextSizeDip
		et.Gravity = Gravity.CENTER
		et.SingleLine = True

		If msType = "number" Then
			et.InputType = 2
		Else
			et.InputType = 1
		End If

		mBoxes.Add(xEt)
		pnlSurface.AddView(xEt, 0, 0, 0, 0)

		If mSeparatorsList.IndexOf(i + 1) > -1 And i < miLength - 1 Then
			Dim sepPnl As B4XView = xui.CreatePanel("")
			sepPnl.Color = xui.Color_Transparent
			sepPnl.Tag = "sep"
			pnlSurface.AddView(sepPnl, 0, 0, 0, 0)
			mSeparatorViews.Add(sepPnl)
		End If
	Next

	If msValue.Length > 0 Then DistributeValueToBoxes(msValue)
	mIsPopulating = False
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = dWidth
	Dim yCursor As Int = 0

	If msLabelAbove.Length > 0 Then
		Dim labelAboveH As Int = 24dip
		pnlLabelAbove.SetLayoutAnimated(0, 0, yCursor, w, labelAboveH)
		lblLabelAbove.SetLayoutAnimated(0, 4dip, 0, w - 8dip, labelAboveH)
		lblLabelAbove.Text = IIf(mbRequired, msLabelAbove & " *", msLabelAbove)
		lblLabelAbove.TextColor = B4XDaisyVariants.GetActiveTokens.GetDefault("--color-base-content", 0xFF1F2937)
		lblLabelAbove.TextSize = 14
		yCursor = yCursor + labelAboveH + 4dip
		pnlLabelAbove.Visible = True
	Else
		pnlLabelAbove.Visible = False
	End If

	Dim boxDim As Int = ResolveBoxSizeDip
	Dim boxGap As Int = ResolveBoxGapDip
	Dim sepDim As Int = 8dip
	Dim totalW As Int = (boxDim * miLength) + (boxGap * (miLength - 1)) + (mSeparatorsList.Size * (sepDim + boxGap))
	Dim startX As Int = Max(0, (w - totalW) / 2)

	pnlSurface.SetLayoutAnimated(0, 0, yCursor, w, boxDim)
	Dim currentX As Int = startX
	Dim viewIndex As Int = 0

	For i = 0 To miLength - 1
		Dim box As B4XView = pnlSurface.GetView(viewIndex)
		box.SetLayoutAnimated(0, currentX, 0, boxDim, boxDim)
		currentX = currentX + boxDim + boxGap
		viewIndex = viewIndex + 1

		If mSeparatorsList.IndexOf(i + 1) > -1 And i < miLength - 1 Then
			Dim sep As B4XView = pnlSurface.GetView(viewIndex)
			Dim sepW As Int = sepDim
			Dim sepH As Int = sepDim
			Dim sepY As Int = (boxDim - sepH) / 2
			sep.SetLayoutAnimated(0, currentX, sepY, sepW, sepH)
			PaintSeparator(sep)
			currentX = currentX + sepDim + boxGap
			viewIndex = viewIndex + 1
		End If
	Next
	yCursor = yCursor + boxDim + 8dip

	If msDescription.Length > 0 Then
		Dim descH As Int = 22dip
		pnlDescription.SetLayoutAnimated(0, 0, yCursor, w, descH)
		lblDescription.SetLayoutAnimated(0, 8dip, 0, w - 16dip, descH)
		lblDescription.Text = msDescription
		lblDescription.TextColor = B4XDaisyVariants.GetActiveTokens.GetDefault("--color-base-content", 0xFF6B7280)
		lblDescription.TextSize = 12
		pnlDescription.Visible = True
		yCursor = yCursor + descH + 2dip
	Else
		pnlDescription.Visible = False
	End If

	Dim displayedHint As String = IIf(msErrorText.Length > 0, msErrorText, msHintText)
	If displayedHint.Length > 0 Then
		pnlHintText.SetLayoutAnimated(0, 0, yCursor, w, 20dip)
		lblHintText.SetLayoutAnimated(0, 4dip, 0, w - 8dip, 20dip)
		lblHintText.Text = displayedHint
		Dim hintColor As Int = IIf(msErrorText.Length > 0, B4XDaisyVariants.GetActiveTokens.GetDefault("--color-error", 0xFFEF4444), B4XDaisyVariants.GetActiveTokens.GetDefault("--color-base-content", 0xFF6B7280))
		lblHintText.TextColor = hintColor
		lblHintText.TextSize = 12
		pnlHintText.Visible = True
	Else
		pnlHintText.Visible = False
	End If

	Dim finalH As Int = yCursor
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, finalH)

	ApplyVisualToBoxes
	inResize = False
End Sub

Private Sub PaintSeparator(vSep As B4XView)
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim sepColor As Int = tokens.GetDefault("--color-base-300", 0xFFD1D5DB)
	If msVariant <> "none" Then
		Dim vcol As Int = B4XDaisyVariants.GetTokenColor("--color-" & msVariant, sepColor)
		sepColor = B4XDaisyVariants.AlphaColor(vcol, 0.35)
	End If
	vSep.Color = sepColor
	B4XDaisyVariants.ApplyEditTextBorder(vSep, sepColor, 0, sepColor, 999dip)
End Sub

Private Sub ApplyVisualToBoxes
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim baseContent As Int = tokens.GetDefault("--color-base-content", 0xFF1F2937)
	Dim base100 As Int = tokens.GetDefault("--color-base-100", 0xFFFFFFFF)
	Dim base200 As Int = tokens.GetDefault("--color-base-200", 0xFFE5E7EB)
	Dim base300 As Int = tokens.GetDefault("--color-base-300", 0xFFD1D5DB)

	Dim boxBg As Int
	Dim boxBorder As Int
	Dim boxText As Int = baseContent
	Dim borderWidth As Int = 2dip

	If msFill = "solid" Then
		boxBg = B4XDaisyVariants.AlphaColor(baseContent, 0.06)
		boxBorder = base300
		borderWidth = 1dip
	Else
		boxBg = base100
		boxBorder = B4XDaisyVariants.Blend(baseContent, base100, 0.25)
		borderWidth = 1dip
	End If

	If msVariant <> "none" Then
		boxBorder = B4XDaisyVariants.GetTokenColor("--color-" & msVariant, boxBorder)
	End If

	If Not(mbEnabled) Then
		boxBg = B4XDaisyVariants.AlphaColor(baseContent, 0.05)
		boxText = B4XDaisyVariants.AlphaColor(baseContent, 0.4)
		boxBorder = B4XDaisyVariants.AlphaColor(baseContent, 0.15)
	Else If mbReadOnly Then
		boxBg = B4XDaisyVariants.AlphaColor(baseContent, 0.05)
		boxBorder = base300
	Else If IsInvalidState Then
		boxBorder = tokens.GetDefault("--color-error", 0xFFEF4444)
		borderWidth = 2dip
	Else If IsValidState Then
		boxBorder = tokens.GetDefault("--color-success", 0xFF22C55E)
		borderWidth = 2dip
	End If

	Dim radius As Int = ResolveShapeRadiusDip
	Dim focusColor As Int
	If msFocusVariant <> "none" Then
		focusColor = B4XDaisyVariants.GetTokenColor("--color-" & msFocusVariant, baseContent)
	Else
		focusColor = baseContent
	End If

	For i = 0 To mBoxes.Size - 1
		Dim box As B4XView = mBoxes.Get(i)
		box.TextColor = boxText
		box.Enabled = mbEnabled

		If mbReadOnly Then
			#If B4A
			box.As(JavaObject).RunMethod("setFocusable", Array(False))
			#End If
		End If

		Dim currentBorder As Int = boxBorder
		Dim currentBorderWidth As Int = borderWidth

		If mbFocused And i = miActiveBoxIndex And Not(mbReadOnly) And Not(IsInvalidState) And Not(IsValidState) Then
			currentBorder = focusColor
			currentBorderWidth = 2dip
		End If

		B4XDaisyVariants.ApplyEditTextBorder(box, boxBg, currentBorderWidth, currentBorder, radius)
	Next
End Sub

Private Sub IsInvalidState As Boolean
	Return msValidationState = "invalid" Or msErrorText.Length > 0
End Sub

Private Sub IsValidState As Boolean
	Return msValidationState = "valid"
End Sub

Private Sub ResolveShapeRadiusDip As Int
	Select Case msShape
		Case "rectangular": Return 0dip
		Case "soft": Return 8dip
		Case "round": Return 16dip
		Case Else: Return 16dip
	End Select
End Sub

Private Sub ResolveBoxSizeDip As Int
	Select Case msSize
		Case "xs": Return 32dip
		Case "sm": Return 40dip
		Case "lg": Return 56dip
		Case "xl": Return 64dip
		Case Else: Return 48dip
	End Select
End Sub

Private Sub ResolveBoxGapDip As Int
	' Custom Gap overrides the size-based default (-1 = auto)
	If miGap >= 0 Then Return miGap
	Select Case msSize
		Case "xs": Return 6dip
		Case "sm": Return 8dip
		Case "xl": Return 16dip
		Case Else: Return 12dip
	End Select
End Sub

Private Sub ResolveTextSizeDip As Float
	Select Case msSize
		Case "xs": Return 14
		Case "sm": Return 16
		Case "lg": Return 20
		Case "xl": Return 22
		Case Else: Return 18
	End Select
End Sub

Private Sub ResolveComponentHeightDip As Int
	Dim h As Int = ResolveBoxSizeDip + 8dip
	If msLabelAbove.Length > 0 Then h = h + 28dip
	If msDescription.Length > 0 Then h = h + 24dip
	If msHintText.Length > 0 Or msErrorText.Length > 0 Then h = h + 22dip
	Return h
End Sub
#End Region

#Region Core Mechanics (Focus and Input)
Private Sub box_TextChanged(sOld As String, sNew As String)
	' --- ELI15 EXPLANATION ---
	' This sub runs whenever a user types, deletes, or pastes text in any of the OTP boxes.
	' "Old" is what the box had before the change; "New" is what it has now.
	' We ignore changes if we are currently updating the boxes programmatically (mIsPopulating) or if they are ReadOnly.
	If mIsPopulating Or mbReadOnly Then Return
	Dim senderEt As B4XView = Sender
	If senderEt = Null Then Return
	Dim tagObj As Object = senderEt.Tag
	If tagObj = Null Then Return
	Dim idx As Int = tagObj

	' --- ELI15: Paste or Autofill detection ---
	' If a user pastes a code (e.g. "1234"), the text length jumps from empty (0) to multiple characters (length > 1),
	' or increases by more than 1 character. When this happens, we clear all boxes and spread the pasted characters
	' starting from Box 0, then shift the cursor/focus to the first empty box.
	If sNew.Length > 1 And (sNew.Length - sOld.Length > 1 Or sOld.Length = 0) Then
		DistributeValueToBoxes(sNew)
		RaiseInputEvent
		RaiseCompleteEventIfDone
		setFocus(-1)
		Return
	End If

	' --- ELI15: Typing a new letter into a box that already has one ---
	' If a box already has a letter (like "A") and the user types another letter (like "B"), the box's text becomes "AB" (length 2).
	' Since each OTP box only holds 1 character, we keep "A" (Old) in this box, and "push" the new letter "B" (addedChar) into the next box!
	' If there is no next box (meaning the OTP is already complete/full), the new letter is simply ignored (blocked).
	If sNew.Length > 1 And sNew.Length - sOld.Length = 1 Then
		' 1. Revert this box back to its single original character (Old)
		mIsPopulating = True
		senderEt.Text = sOld
		#If B4A
		Dim et As EditText = senderEt
		et.SelectionStart = sOld.Length
		#End If
		mIsPopulating = False

		' 2. Grab the newly typed character (at the end of the text string)
		Dim addedChar As String = sNew.SubString(sNew.Length - 1)
		If IsValidChar(addedChar) Then
			' 3. If there's a box to the right, send the new letter to it!
			If idx < mBoxes.Size - 1 Then
				Dim nextBox As B4XView = mBoxes.Get(idx + 1)
				If nextBox.Text <> addedChar Then
					nextBox.Text = addedChar
				Else
					' If it already has that character, just move focus there
					nextBox.RequestFocus
				End If
			End If
		End If
		RaiseInputEvent
		RaiseCompleteEventIfDone
		Return
	End If

	' --- ELI15: Normal typing in an empty box ---
	' If the box was empty and the user typed 1 character, we make sure it's allowed (e.g. a number).
	' If it is allowed, we automatically jump focus to the next box to make typing smooth and fast.
	If sNew.Length = 1 Then
		If IsValidChar(sNew) = False Then
			' Revert to empty or old text if the character wasn't allowed (e.g. typed a letter when expecting a number)
			mIsPopulating = True
			senderEt.Text = sOld
			#If B4A
			Dim et As EditText = senderEt
			et.SelectionStart = sOld.Length
			#End If
			mIsPopulating = False
			Return
		End If
		If idx < mBoxes.Size - 1 Then
			Dim nb1 As B4XView = mBoxes.Get(idx + 1)
			nb1.RequestFocus
		End If
		RaiseInputEvent
		RaiseCompleteEventIfDone
		Return
	End If

	' --- ELI15: Deleting a character (Backspace) ---
	' If a user deletes the character in a box and there are characters in boxes to its right,
	' we shift all subsequent characters one position to the left (like collapsing a gap in a line) to keep the layout neat.
	If sNew.Length = 0 And sOld.Length = 1 Then
		Dim hasRight As Boolean = False
		For i = idx + 1 To mBoxes.Size - 1
			Dim cb As B4XView = mBoxes.Get(i)
			If cb.Text.Length > 0 Then hasRight = True: Exit
		Next
		If hasRight Then
			mIsPopulating = True
			For i = idx To mBoxes.Size - 2
				Dim curB As B4XView = mBoxes.Get(i)
				Dim nxtB As B4XView = mBoxes.Get(i + 1)
				curB.Text = nxtB.Text
			Next
			Dim lastB As B4XView = mBoxes.Get(mBoxes.Size - 1)
			lastB.Text = ""
			mIsPopulating = False
		End If
		RaiseInputEvent
		Return
	End If
End Sub

Private Sub box_FocusChanged(bHasFocus As Boolean)
	Dim senderEt As B4XView = Sender
	If bHasFocus Then
		miActiveBoxIndex = senderEt.Tag
		If Not(mbFocused) Then
			mbFocused = True
			msFocusedValue = getValueInternal
			If xui.SubExists(mCallBack, mEventName & "_Focus", 0) Then CallSub(mCallBack, mEventName & "_Focus")
		End If
	Else
		Sleep(50)
		Dim anyFocused As Boolean = False
		For Each box As B4XView In mBoxes
			#If B4A
			If box.As(JavaObject).RunMethod("hasFocus", Null) Then anyFocused = True
			#End If
		Next
		mbFocused = anyFocused
		If Not(mbFocused) Then
			mbTouched = True
			Dim currentVal As String = getValueInternal
			If currentVal <> msFocusedValue Then
				msFocusedValue = currentVal
				If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then CallSub2(mCallBack, mEventName & "_Changed", currentVal)
			End If
			If xui.SubExists(mCallBack, mEventName & "_Blur", 0) Then CallSub(mCallBack, mEventName & "_Blur")
		End If
	End If
	ApplyVisualToBoxes
End Sub

Private Sub box_KeyDel
	' --- ELI15 EXPLANATION ---
	' This runs when the user presses Backspace/Delete on an ALREADY empty box.
	' Normally, deleting in an empty box does nothing because there is no text to change.
	' But in an OTP component, we want the Ionic behavior: pressing backspace on an empty box
	' should delete the character in the PREVIOUS box and move the cursor back to it!
	If mIsPopulating Or mbReadOnly Or Not(mbEnabled) Then Return
	Dim senderEt As B4XView = Sender
	If senderEt = Null Then Return
	Dim tagObj As Object = senderEt.Tag
	If tagObj = Null Then Return
	Dim idx As Int = tagObj
	
	' If there is a box to the left, clear its text and move focus to it
	If idx > 0 Then
		Dim pvb As B4XView = mBoxes.Get(idx - 1)
		mIsPopulating = True
		pvb.Text = ""
		mIsPopulating = False
		pvb.RequestFocus
		RaiseInputEvent
	End If
End Sub

Private Sub pnlDescription_Click
	If xui.SubExists(mCallBack, mEventName & "_DescriptionClick", 0) Then CallSub(mCallBack, mEventName & "_DescriptionClick")
End Sub

Public Sub setFocus(iIndex As Int)
	If mbReadOnly Or Not(mbEnabled) Then Return
	Dim targetIdx As Int = iIndex
	If targetIdx < 0 Then
		targetIdx = mBoxes.Size - 1
		For i = 0 To mBoxes.Size - 1
			Dim fb As B4XView = mBoxes.Get(i)
			If fb.Text = "" Then
				targetIdx = i
				Exit
			End If
		Next
	End If
	If targetIdx >= 0 And targetIdx < mBoxes.Size Then
		Dim tfb As B4XView = mBoxes.Get(targetIdx)
		tfb.RequestFocus
	End If
End Sub

Private Sub DistributeValueToBoxes(sValue As String)
	mIsPopulating = True
	Dim raw As String = sValue.Trim
	For i = 0 To mBoxes.Size - 1
		Dim clb As B4XView = mBoxes.Get(i)
		clb.Text = ""
	Next
	Dim placed As Int = 0
	For ci = 0 To raw.Length - 1
		If placed >= mBoxes.Size Then Exit
		Dim ch As String = raw.CharAt(ci)
		If IsValidChar(ch) Then
			Dim plb As B4XView = mBoxes.Get(placed)
			plb.Text = ch
			placed = placed + 1
		End If
	Next
	mIsPopulating = False
End Sub

Private Sub RaiseInputEvent
	If xui.SubExists(mCallBack, mEventName & "_Input", 1) Then CallSub2(mCallBack, mEventName & "_Input", getValueInternal)
End Sub

Private Sub RaiseCompleteEventIfDone
	Dim val As String = getValueInternal
	If val.Length = miLength Then
		If xui.SubExists(mCallBack, mEventName & "_Complete", 1) Then CallSub2(mCallBack, mEventName & "_Complete", val)
	End If
End Sub

Private Sub getValueInternal As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each box As B4XView In mBoxes
		sb.Append(box.Text)
	Next
	Return sb.ToString
End Sub

Private Sub ResolveEffectivePattern As String
	If msPattern.Length > 0 Then Return NormalizePattern(msPattern)
	If msType = "number" Then Return "[\p{N}]"
	Return "[\p{L}\p{N}]"
End Sub

Private Sub NormalizePattern(sP As String) As String
	Dim r As String = sP
	r = r.Replace("\p{Script=", "\p{Is")
	r = r.Replace("\p{sc=", "\p{Is")
	Return r
End Sub

Private Sub IsValidChar(sCharValue As String) As Boolean
	If sCharValue.Length <> 1 Then Return False
	Dim p As String = ResolveEffectivePattern
	Try
		Return Regex.IsMatch("^" & p & "$", sCharValue)
	Catch
		Return True
	End Try
End Sub
#End Region

#If Java
import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputConnectionWrapper;
import android.view.inputmethod.EditorInfo;

// === ELI15 JAVA BRIDGE EXPLANATION ===
// Android's standard EditText doesn't tell us when a user presses backspace on an empty input.
// Also, soft keyboards (like Gboard) do not send standard KeyEvents to the app; they talk directly
// to the input connection.
// So we build a custom "OTPBox" class. It wraps around the input connection using "InputConnectionWrapper"
// to listen to "deleteSurroundingText" (what Gboard calls when deleting) and "sendKeyEvent" (for hardware/fallback delete keys).
// When it catches a delete on an empty text field, it raises the B4A event ("_keydel") so our B4A code can move focus back!
public static class OTPBox extends android.widget.EditText {
    private anywheresoftware.b4a.BA ba;
    private String ev;
    private CharSequence oldText;
    public OTPBox(Context ctx, anywheresoftware.b4a.BA ba, String ev) {
        super(ctx);
        this.ba = ba;
        this.ev = ev;
        
        // Listen for when text actually changes
        addTextChangedListener(new TextWatcher() {
            public void beforeTextChanged(CharSequence s, int start, int count, int after) { oldText = s == null ? "" : s.toString(); }
            public void onTextChanged(CharSequence s, int start, int before, int count) {}
            public void afterTextChanged(Editable s) {
                String nt = s == null ? "" : s.toString();
                // Send text changed event back to B4A
                ba.raiseEvent2(OTPBox.this, false, ev + "_textchanged", true, new Object[]{oldText, nt});
            }
        });
        
        // Listen for focus changes (to paint focus borders)
        setOnFocusChangeListener(new View.OnFocusChangeListener() {
            public void onFocusChange(View v, boolean hasFocus) {
                ba.raiseEventFromUI(OTPBox.this, ev + "_focuschanged", new Object[]{Boolean.valueOf(hasFocus)});
            }
        });
    }
    
    // Hardware keyboard / fallback delete key interception
    @Override
    public boolean onKeyPreIme(int keyCode, KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_DEL) {
            if (getText() == null || getText().length() == 0) {
                ba.raiseEvent2(OTPBox.this, false, ev + "_keydel", true, new Object[]{});
            }
        }
        return super.onKeyPreIme(keyCode, event);
    }
    
    // Software keyboard (Gboard, SwiftKey, etc.) backspace interception on empty fields
    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        InputConnection conn = super.onCreateInputConnection(outAttrs);
        if (conn == null) return null;
        return new InputConnectionWrapper(conn, true) {
            @Override
            public boolean deleteSurroundingText(int beforeLength, int afterLength) {
                // If the box is empty, it means they pressed backspace on an empty field
                if (getText() == null || getText().length() == 0) {
                    ba.raiseEvent2(OTPBox.this, false, ev + "_keydel", true, new Object[]{});
                }
                return super.deleteSurroundingText(beforeLength, afterLength);
            }
            @Override
            public boolean sendKeyEvent(KeyEvent event) {
                // Intercept key downs for backspace
                if (event.getAction() == KeyEvent.ACTION_DOWN && event.getKeyCode() == KeyEvent.KEYCODE_DEL) {
                    if (getText() == null || getText().length() == 0) {
                        ba.raiseEvent2(OTPBox.this, false, ev + "_keydel", true, new Object[]{});
                    }
                }
                return super.sendKeyEvent(event);
            }
        };
    }
}

public OTPBox createOTPBox(String ev) {
    return new OTPBox(ba.context, ba, ev);
}
#End If

Public Sub Release
    If pnlSurface.IsInitialized Then pnlSurface.RemoveViewFromParent
    If pnlLabelAbove.IsInitialized Then pnlLabelAbove.RemoveViewFromParent
    If pnlDescription.IsInitialized Then pnlDescription.RemoveViewFromParent
    If pnlHintText.IsInitialized Then pnlHintText.RemoveViewFromParent
    mCallBack = Null
End Sub
