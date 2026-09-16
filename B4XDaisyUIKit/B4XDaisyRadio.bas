B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: Checked (Checked As Boolean)
#Event: Click (Tag As Object)
#Event: FocusChanged (HasFocus As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: GroupName, DisplayName: Group Name, FieldType: String, DefaultValue: , Description: Radio group name.
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False, Description: Checked state.
#DesignerProperty: Key: Value, DisplayName: Value, FieldType: String, DefaultValue: , Description: Value assigned to the radio.
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Label text.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size variant.
#DesignerProperty: Key: Position, DisplayName: Position, FieldType: String, DefaultValue: start, List: start|end, Description: Position alignment.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override border color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override label text color.
#DesignerProperty: Key: CheckedBackgroundColor, DisplayName: Checked Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override checked background color.
#DesignerProperty: Key: CheckedBorderColor, DisplayName: Checked Border Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override checked border color.
#DesignerProperty: Key: CheckedTextColor, DisplayName: Checked Dot Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override checked center dot color.
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Set field as required.
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue: , Description: Message displayed when field validation fails.
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	Private pnlSurface As B4XView
	Private pnlCheckSquare As B4XView
	Private pnlCheckCanvas As B4XView
	Private lblText As B4XView
	Private cvs As B4XCanvas

	Private mChecked As Boolean = False
	Private mText As String = ""
	Private mbRequired As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
	Private msErrorText As String = ""
	Private mVariant As String = "none"
	Private mSize As String = "md"
	Private msPosition As String = "start"
	Private mEnabled As Boolean = True
	Private mVisible As Boolean = True

	Private mcBackgroundColor As Int = 0
	Private mcTextColor As Int = 0
	Private mcBorderColor As Int = 0
	Private mcCheckedBackgroundColor As Int = 0
	Private mcCheckedBorderColor As Int = 0
	Private mcCheckedTextColor As Int = 0

	Private mShadow As String = "none"
	Private mValue As String = ""
	Private mGroupName As String = ""
	' DaisyUI token support map for parity validation:
	' align-middle appearance-none bg-base-100 bg-blue-100 bg-current bg-red-100
	' block border-blue-300 border-current border-red-300 checked:bg-blue-200
	' checked:bg-red-200 checked:border-blue-600 checked:border-red-600
	' checked:text-blue-600 checked:text-red-600 cursor-not-allowed cursor-pointer
	' inline-block opacity-20 outline -outline-offset-1 p-1 radio
	' radio-accent radio-error radio-info radio-lg radio-md radio-neutral
	' radio-primary radio-secondary radio-sm radio-success radio-warning
	' radio-xl radio-xs relative rounded-full shrink-0 size-full
	Private inResize As Boolean = False
End Sub
#End Region

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	mChecked = B4XDaisyVariants.GetPropBool(mProps, "Checked", mChecked)
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	msPosition = B4XDaisyVariants.GetPropString(mProps, "Position", msPosition)
	mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mEnabled)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
	mValue = B4XDaisyVariants.GetPropString(mProps, "Value", mValue)
	mGroupName = B4XDaisyVariants.GetPropString(mProps, "GroupName", mGroupName)
	mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
	mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
	mcBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mcBorderColor)
	mcCheckedBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "CheckedBackgroundColor", mcCheckedBackgroundColor)
	mcCheckedBorderColor = B4XDaisyVariants.GetPropColor(mProps, "CheckedBorderColor", mcCheckedBorderColor)
	mcCheckedTextColor = B4XDaisyVariants.GetPropColor(mProps, "CheckedTextColor", mcCheckedTextColor)
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("GroupName", mGroupName)
	props.Put("Checked", mChecked)
	props.Put("Value", mValue)
	props.Put("Text", mText)
	props.Put("Variant", mVariant)
	props.Put("Size", mSize)
	props.Put("Position", msPosition)
	props.Put("Enabled", mEnabled)
	props.Put("Visible", mVisible)
	props.Put("Shadow", mShadow)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("BorderColor", mcBorderColor)
	props.Put("TextColor", mcTextColor)
	props.Put("CheckedBackgroundColor", mcCheckedBackgroundColor)
	props.Put("CheckedBorderColor", mcCheckedBorderColor)
	props.Put("CheckedTextColor", mcCheckedTextColor)
	props.Put("Required", mbRequired)
	props.Put("ErrorText", msErrorText)
	Return props
End Sub

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' 1. Create outer surface panel for click containment and label + radio circle grouping
	Dim pSurface As Panel
	pSurface.Initialize("pnlSurface")
	pnlSurface = pSurface
	pnlSurface.Color = xui.Color_Transparent
	mBase.AddView(pnlSurface, 0, 0, mBase.Width, mBase.Height)

	' 2. Create inner panel representing the checkable circle
	Dim pCheck As Panel
	pCheck.Initialize("")
	pnlCheckSquare = pCheck
	pnlCheckSquare.Color = xui.Color_Transparent
	pnlSurface.AddView(pnlCheckSquare, 0, 0, 24dip, 24dip)

	' Isolated transparent canvas panel inside checkable circle for drawing dot glyphs
	Dim pCanvas As Panel
	pCanvas.Initialize("")
	pnlCheckCanvas = pCanvas
	pnlCheckCanvas.Color = xui.Color_Transparent
	pnlCheckSquare.AddView(pnlCheckCanvas, 0, 0, 24dip, 24dip)

	' Initialize B4XCanvas on the isolated canvas panel
	cvs.Initialize(pnlCheckCanvas)

	' 3. Create the text label
	Dim l As Label
	l.Initialize("")
	l.SingleLine = True
	lblText = l
	lblText.Color = xui.Color_Transparent
	lblText.SetTextAlignment("CENTER", "LEFT")
	pnlSurface.AddView(lblText, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(mProps)

	mBase.Visible = mVisible
	#If B4A
		' setFocusable(True) allows keyboard/accessibility focus on the panel.
		' setFocusableInTouchMode is intentionally omitted: it would cause Android
		' to consume the first touch as a focus event, requiring a double-tap.
		Dim jo As JavaObject = pnlSurface
		jo.RunMethod("setFocusable", Array(True))
	#End If
	Refresh
End Sub
#End Region

#Region Public API
''' <summary>
''' Sets the Checked state.
''' </summary>

Private Sub ResolveLabelText(sBaseText As String) As String
	Return sBaseText
End Sub

Public Sub setChecked(bValue As Boolean)
	mChecked = bValue
	If mChecked And mGroupName <> "" And mBase.IsInitialized Then
		UncheckGroupSiblings
	End If
	Refresh
End Sub

''' <summary>
''' Walks the parent chain and unchecks any sibling B4XDaisyRadio
''' instances sharing the same GroupName.  This follows the same pattern
''' as B4XRadioButton - iterating parent children instead of a global
''' registry - so there are no stale references and no crash-prone
''' parent-chain traversal.
''' </summary>
Private Sub UncheckGroupSiblings
	Try
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized = False Then Return
		' Only search direct siblings in the immediate parent panel.
		' All radios inside a B4XDaisyRadioGroup share the same RadioHost
		' panel as their direct parent, so ancestor traversal is not needed
		' and causes spurious Checked=False events that break single-tap behaviour.
		UncheckInParent(parent)
	Catch
		' mBase.Parent threw - view is detached or hierarchy is invalid.
		Return
	End Try
End Sub

Private Sub UncheckInParent(vParent As B4XView)
	If vParent.IsInitialized = False Then Return
	Try
		Dim count As Int = vParent.NumberOfViews
		For i = 0 To count - 1
			Dim v As B4XView = vParent.GetView(i)
			If v <> mBase And v.Tag Is B4XDaisyRadio Then
				Dim rb As B4XDaisyRadio = v.Tag
				If rb.GroupName = mGroupName And rb.Checked Then
					rb.Checked = False
				End If
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyRadio.UncheckInParent: " & LastException.Message)
		' Parent view hierarchy may be changing - skip gracefully.
	End Try
End Sub

''' <summary>
''' Returns the component role.
''' </summary>
Public Sub getRole As String
	Return "radio"
End Sub

''' <summary>
''' Sets the GroupName.
''' </summary>
Public Sub setGroupName(sValue As String)
	mGroupName = sValue
End Sub

''' <summary>
''' Gets the GroupName.
''' </summary>
Public Sub getGroupName As String
	Return mGroupName
End Sub

''' <summary>
''' Gets the Checked state.
''' </summary>
Public Sub getChecked As Boolean
	Return mChecked
End Sub

''' <summary>
''' Sets the Value.
''' </summary>
Public Sub setValue(sValue As String)
	mValue = sValue
End Sub

''' <summary>
''' Gets the Value.
''' </summary>
Public Sub getValue As String
	Return mValue
End Sub

''' <summary>
''' Sets the Label Text.
''' </summary>
Public Sub setText(sValue As String)
	mText = sValue
	Refresh
End Sub

''' <summary>
''' Gets the Label Text.
''' </summary>
Public Sub getText As String
	Return mText
End Sub

''' <summary>
''' Sets the Variant.
''' </summary>
Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	Refresh
End Sub

''' <summary>
''' Gets the Variant.
''' </summary>
Public Sub getVariant As String
	Return mVariant
End Sub

''' <summary>
''' Sets the Size.
''' </summary>
Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	Refresh
End Sub

''' <summary>
''' Gets the Size.
''' </summary>
Public Sub getSize As String
	Return mSize
End Sub

''' <summary>
''' Sets the Position alignment.
''' </summary>
Public Sub setPosition(sValue As String)
	msPosition = sValue
	Refresh
End Sub

''' <summary>
''' Gets the Position alignment.
''' </summary>
Public Sub getPosition As String
	Return msPosition
End Sub

''' <summary>
''' Sets the Enabled state.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
	mEnabled = bValue
	Refresh
End Sub

''' <summary>
''' Gets the Enabled state.
''' </summary>
Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

''' <summary>
''' Sets the Visible state.
''' </summary>
Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then mBase.Visible = bValue
	Refresh
End Sub

''' <summary>
''' Gets the Visible state.
''' </summary>
Public Sub getVisible As Boolean
	Return mVisible
End Sub

''' <summary>
''' Sets the Shadow elevation level.
''' </summary>
Public Sub setShadow(sValue As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	Refresh
End Sub

''' <summary>
''' Gets the Shadow elevation level.
''' </summary>
Public Sub getShadow As String
	Return mShadow
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
''' Sets the background color override.
''' </summary>

' Required / error validation helpers
Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	If mBase.IsInitialized Then Refresh
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
''' Dynamically sets the radio into an error validation state and displays the specified error text.
''' </summary>
Public Sub ShowError(sErrorMessage As String)
        msErrorText = sErrorMessage
        mbProgrammaticError = True
        If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Clears any dynamic error state and returns the radio to normal.
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
	If mChecked Then
        mbProgrammaticError = False
		msErrorText = ""
		Return True
	End If
        mbValidationTouched = True
	If msErrorText.Length = 0 Then msErrorText = "This field is required."
	If mBase.IsInitialized Then Refresh
	Return False
End Sub

Public Sub setBackgroundColor(iColor As Int)
	mcBackgroundColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the background color override.
''' </summary>
Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

''' <summary>
''' Sets the border color override.
''' </summary>
Public Sub setBorderColor(iColor As Int)
	mcBorderColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the border color override.
''' </summary>
Public Sub getBorderColor As Int
	Return mcBorderColor
End Sub

''' <summary>
''' Sets the text/checkmark color override.
''' </summary>
Public Sub setTextColor(iColor As Int)
	mcTextColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the text/checkmark color override.
''' </summary>
Public Sub getTextColor As Int
	Return mcTextColor
End Sub

''' <summary>
''' Sets the checked background color override.
''' </summary>
Public Sub setCheckedBackgroundColor(iColor As Int)
	mcCheckedBackgroundColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the checked background color override.
''' </summary>
Public Sub getCheckedBackgroundColor As Int
	Return mcCheckedBackgroundColor
End Sub

''' <summary>
''' Sets the checked border color override.
''' </summary>
Public Sub setCheckedBorderColor(iColor As Int)
	mcCheckedBorderColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the checked border color override.
''' </summary>
Public Sub getCheckedBorderColor As Int
	Return mcCheckedBorderColor
End Sub

''' <summary>
''' Sets the checked dot color override.
''' </summary>
Public Sub setCheckedTextColor(iColor As Int)
	mcCheckedTextColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the checked dot color override.
''' </summary>
Public Sub getCheckedTextColor As Int
	Return mcCheckedTextColor
End Sub

''' <summary>
''' Forces the component to re-resolve theme-aware styling.
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
	mBase.Alpha = IIf(mEnabled, 1.0, 0.3)
	B4XDaisyVariants.DisableClippingRecursive(mBase)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	
	' Handle fit-content sizing if dimensions are <= 0
	Dim targetW As Int = iWidth
	Dim targetH As Int = iHeight
	If targetW <= 0 Then targetW = EstimatePreferredWidth
	If targetH <= 0 Then targetH = EstimatePreferredHeight

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
''' Gets the complete height of the component.
''' </summary>
Public Sub getComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
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
''' Called when the radio receives focus. Clears any transient
''' validation error visual so the user can interact without a distracting red border.
''' </summary>
Public Sub ReceiveFocus
        If msErrorText.Length > 0 And mbProgrammaticError = False Then
                msErrorText = ""
                If mBase.IsInitialized Then Refresh
        End If
End Sub

''' <summary>
''' Called when the component loses focus.
''' </summary>
Public Sub Blur
    ' No state changes on blur; skip Refresh to avoid re-layout on every focus loss.
End Sub
#End Region

#Region Drawing and Layout
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If pnlSurface.IsInitialized = False Then Return

	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)

	pnlSurface.SetLayoutAnimated(0, 0, 0, w, h)

	Dim squareSize As Float = ResolveRadioSizeDip
	' Corner radius is sz / 2 to make it a perfect circle
	pnlCheckSquare.SetLayoutAnimated(0, 0, 0, squareSize, squareSize)
	If pnlCheckCanvas.IsInitialized Then
		pnlCheckCanvas.SetLayoutAnimated(0, 0, 0, squareSize, squareSize)
	End If
	cvs.Resize(squareSize, squareSize)

	Dim textVal As String = B4XDaisyVariants.NormalizeSingleLineText(mText)
	Dim hasText As Boolean = textVal.Length > 0

	If hasText = False Then
		' Position radio circle in host panel based on position alignment
		Dim leftX As Float = 0
		If msPosition = "end" Then
			leftX = w - squareSize
		End If
		Dim topY As Float = (h - squareSize) / 2
		pnlCheckSquare.SetLayoutAnimated(0, leftX, topY, squareSize, squareSize)
		lblText.Visible = False
	Else
		lblText.Visible = True
		lblText.Text = ResolveLabelText(textVal)
		Dim fontSize As Float = ResolveTextSizePoints
		lblText.Font = xui.CreateDefaultFont(fontSize)

		' Apply Text Color from Active Theme
		Dim visualColors As Map = ResolveVisualColors
		Dim labelColor As Int = visualColors.Get("label")
		If msErrorText.Length > 0 Then
			labelColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
		End If
		lblText.TextColor = labelColor

		Dim gap As Float = 8dip
		Dim topY As Float = (h - squareSize) / 2

		If msPosition = "end" Then
			' Label on the left, Radio on the right
			Dim textLeft As Float = 0
			Dim textWidth As Float = w - squareSize - gap
			lblText.SetLayoutAnimated(0, textLeft, 0, textWidth, h)
			lblText.SetTextAlignment("CENTER", "LEFT")

			Dim leftX As Float = w - squareSize
			pnlCheckSquare.SetLayoutAnimated(0, leftX, topY, squareSize, squareSize)
		Else
			' Label on the right, Radio on the left
			Dim leftX As Float = 0
			pnlCheckSquare.SetLayoutAnimated(0, leftX, topY, squareSize, squareSize)

			Dim textLeft As Float = squareSize + gap
			Dim textWidth As Float = w - textLeft
			lblText.SetLayoutAnimated(0, textLeft, 0, textWidth, h)
			lblText.SetTextAlignment("CENTER", "LEFT")
		End If
	End If

	DrawRadio
	inResize = False
End Sub

Private Sub DrawRadio
	If pnlCheckSquare.IsInitialized = False Then Return

	Dim xColors As Map = ResolveVisualColors
	Dim bgColor As Int = xColors.Get("back")
	Dim borderColor As Int = xColors.Get("border")
	Dim tickColor As Int = xColors.Get("text")

	Dim bw As Float = Max(0, B4XDaisyVariants.GetBorderDip(1dip))
	Dim sz As Float = pnlCheckSquare.Width
	Dim radius As Float = sz / 2 ' Perfect circle

	' 1. Draw rounded box via GradientDrawable (B4A native)
	#If B4A
	Try
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(0))        ' RECTANGLE
		gd.RunMethod("setColor", Array(bgColor))
		Dim r As Float = Max(0, radius)
		Dim radii() As Float = Array As Float(r, r, r, r, r, r, r, r)
		gd.RunMethod("setCornerRadii", Array(radii))
		If bw > 0 Then gd.RunMethod("setStroke", Array(Round(bw), borderColor))
		Dim joPanel As JavaObject = pnlCheckSquare
		joPanel.RunMethod("setBackground", Array(gd))
	Catch
		pnlCheckSquare.SetColorAndBorder(bgColor, bw, borderColor, radius)
	End Try
	#Else
	pnlCheckSquare.SetColorAndBorder(bgColor, bw, borderColor, radius)
	#End If

	' Apply elevation shadow to the circular radio container
	B4XDaisyVariants.ApplyElevation(pnlCheckSquare, mShadow)

	' 2. Draw dot glyph via B4XCanvas
	cvs.ClearRect(cvs.TargetRect)
	
	If mChecked Then
		Dim padding As Float = ResolveRadioPaddingDip(sz)
		Dim dotRadius As Float = (sz / 2) - padding
		If dotRadius > 0 Then
			cvs.DrawCircle(sz / 2, sz / 2, dotRadius, tickColor, True, 0)
		End If
	End If
	cvs.Invalidate
End Sub

Private Sub ResolveVisualColors As Map
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim base100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))

	' Radio border: color-mix(in oklab, var(--color-base-content) 20%, #0000)
	Dim borderColor As Int = B4XDaisyVariants.AlphaColor(baseContent, 0.20)

	Dim back As Int = base100
	Dim border As Int = borderColor
	Dim text As Int = xui.Color_Transparent

	Dim variantKey As String = mVariant.ToLowerCase
	If variantKey = "none" Then
		If mChecked Then
			back = base100
			border = baseContent
			text = baseContent
		Else
			back = base100
			border = borderColor
			text = xui.Color_Transparent
		End If
	Else
		Dim variantBg As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(variantKey, baseContent)
		Dim variantBorder As Int = B4XDaisyVariants.AlphaColor(variantBg, 0.20)

		If mChecked Then
			back = base100
			border = variantBg
			text = variantBg
		Else
			back = base100
			border = variantBorder
			text = xui.Color_Transparent
		End If
	End If

	' Apply custom properties override
	Dim lblColor As Int = baseContent
	If mChecked Then
		If mcCheckedBackgroundColor <> 0 Then
			back = mcCheckedBackgroundColor
		Else If mcBackgroundColor <> 0 Then
			back = mcBackgroundColor
		End If
		
		If mcCheckedBorderColor <> 0 Then
			border = mcCheckedBorderColor
		Else If mcBorderColor <> 0 Then
			border = mcBorderColor
		End If
		
		If mcCheckedTextColor <> 0 Then
			text = mcCheckedTextColor
		Else If mcTextColor <> 0 Then
			text = mcTextColor
		End If
	Else
		If mcBackgroundColor <> 0 Then back = mcBackgroundColor
		If mcBorderColor <> 0 Then border = mcBorderColor
	End If

	Return CreateMap("back": back, "border": border, "text": text, "label": lblColor)
End Sub

Private Sub ResolveRadioSizeDip As Float
	Select Case mSize.ToLowerCase
		Case "xs": Return 16dip
		Case "sm": Return 20dip
		Case "md": Return 24dip
		Case "lg": Return 28dip
		Case "xl": Return 32dip
		Case Else
			Return B4XDaisyVariants.TailwindSizeToDip(mSize, 24dip)
	End Select
End Sub

Private Sub ResolveTextSizePoints As Float
	Select Case mSize.ToLowerCase
		Case "xs": Return 11
		Case "sm": Return 12
		Case "md": Return 14
		Case "lg": Return 18
		Case "xl": Return 22
		Case Else: Return 14
	End Select
End Sub

Private Sub ResolveRadioPaddingDip(fSz As Float) As Float
	Select Case mSize.ToLowerCase
		Case "xs": Return 2dip
		Case "sm": Return 3dip
		Case "md": Return 4dip
		Case "lg": Return 5dip
		Case "xl": Return 6dip
		Case Else: Return Max(2dip, 4dip * (fSz / 24dip))
	End Select
End Sub

Private Sub EstimatePreferredWidth As Int
	Dim squareSize As Float = ResolveRadioSizeDip
	If mText.Length = 0 Then Return squareSize
	Dim fontSize As Float = ResolveTextSizePoints
	Return squareSize + 8dip + EstimateTextWidth(mText, fontSize)
End Sub

Private Sub EstimatePreferredHeight As Int
	Dim squareSize As Float = ResolveRadioSizeDip
	If mText.Length = 0 Then Return squareSize
	Dim fontSize As Float = ResolveTextSizePoints
	Return Max(squareSize, EstimateTextHeight(mText, fontSize))
End Sub

Private Sub EstimateTextWidth(sText As String, fFontSize As Float) As Int
	If sText.Length = 0 Then Return 0
	Try
		If lblText.IsInitialized Then
			Dim l As Label = lblText
			Return B4XDaisyVariants.MeasureTextWidthSafe(sText, fFontSize, l.Typeface, 2dip)
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyRadio.EstimateTextWidth: " & LastException.Message)
	End Try
	Return Max(1dip, Ceil(sText.Length * fFontSize * 0.62) + 2dip)
End Sub

Private Sub EstimateTextHeight(sText As String, fFontSize As Float) As Int
	If sText.Length = 0 Then Return 0
	Try
		If lblText.IsInitialized Then
			Dim l As Label = lblText
			Return B4XDaisyVariants.MeasureTextHeightSafe(sText, fFontSize, l.Typeface, 2000dip, 2dip)
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyRadio.EstimateTextHeight: " & LastException.Message)
	End Try
	Return Max(1dip, Ceil(fFontSize * 1.3) + 2dip)
End Sub
#End Region

#Region Click Event Handling
Private Sub pnlSurface_Click
	If mEnabled = False Then Return
	' Once checked, a radio button cannot be unchecked by clicking it again
	If mChecked = True Then
		RaiseClick
		Return
	End If
	setChecked(True)
	RaiseCheckedEvent
	RaiseClick
End Sub

Private Sub RaiseCheckedEvent
	If xui.SubExists(mCallBack, mEventName & "_Checked", 1) Then
		CallSub2(mCallBack, mEventName & "_Checked", mChecked)
	End If
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
#End Region

#Region Cleanup
Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Release
	pnlSurface = Null
	pnlCheckSquare = Null
	pnlCheckCanvas = Null
	lblText = Null
	Try
		cvs.Release
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyRadio.Release: " & LastException.Message)
	End Try
	cvs = Null
End Sub
#End Region

#Region B4XView Layout Wrapper Methods
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
