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
#DesignerProperty: Key: GroupName, DisplayName: Group Name, FieldType: String, DefaultValue: , Description: Checkbox group name.
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False, Description: Checked state.
#DesignerProperty: Key: Indeterminate, DisplayName: Indeterminate, FieldType: Boolean, DefaultValue: False, Description: Indeterminate state.
#DesignerProperty: Key: Value, DisplayName: Value, FieldType: String, DefaultValue: , Description: Value assigned to the checkbox.
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
#DesignerProperty: Key: CheckedTextColor, DisplayName: Checked Checkmark Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override checked checkmark/text color.
#DesignerProperty: Key: Multiline, DisplayName: Multiline, FieldType: Boolean, DefaultValue: False, Description: Enable multi-line label text wrapping.
#DesignerProperty: Key: LineSpacing, DisplayName: Line Spacing Extra, FieldType: Int, DefaultValue: 0, Description: Extra space added between lines in pixels.
#DesignerProperty: Key: LineSpacingMult, DisplayName: Line Spacing Multiplier, FieldType: Float, DefaultValue: 1.0, Description: Line spacing multiplier.
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
	Private mIndeterminate As Boolean = False
	Private mText As String = ""
	Private mTextCS As Object = Null ' CharSequence (CSBuilder) label, used when TextCS is set
	Private mHasTextCS As Boolean = False
	Private mbMultiline As Boolean = False
	Private mfLineSpacingExtra As Float = 0    ' extra space (pixels) added between label lines
	Private mfLineSpacingMult As Float = 1.0   ' line-height multiplier applied to the label
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
	' [clip-path:none] [--tw-content:"v"] align-middle appearance-none bg-base-100
	' bg-current bg-indigo-500 bg-transparent block border border-base-300
	' border-indigo-600 checkbox checkbox-accent checkbox-error checkbox-info
	' checkbox-lg checkbox-md checkbox-neutral checkbox-primary checkbox-secondary
	' checkbox-sm checkbox-success checkbox-warning checkbox-xl checkbox-xs
	' checked:bg-orange-400 checked:border-orange-500 checked:text-orange-800
	' cursor-not-allowed cursor-pointer fieldset fieldset-legend inline-block
	' label opacity-0 opacity-100 opacity-20 p-[0.125rem] p-[0.1875rem]
	' p-[0.25rem] p-[0.3125rem] p-[0.375rem] p-1 p-4 relative rotate-0
	' rotate-45 rounded-box rounded-selector shrink-0 size-full text-accent-content
	' text-base-content text-error-content text-info-content text-neutral-content
	' text-primary-content text-secondary-content text-success-content
	' text-warning-content w-64
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
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' 1. Create outer surface panel for click containment and label + square grouping
	Dim pSurface As Panel
	pSurface.Initialize("pnlSurface")
	pnlSurface = pSurface
	pnlSurface.Color = xui.Color_Transparent
	mBase.AddView(pnlSurface, 0, 0, mBase.Width, mBase.Height)

	' 2. Create inner panel representing the checkable square
	Dim pCheck As Panel
	pCheck.Initialize("")
	pnlCheckSquare = pCheck
	pnlCheckSquare.Color = xui.Color_Transparent
	pnlSurface.AddView(pnlCheckSquare, 0, 0, 24dip, 24dip)

	' Isolated transparent canvas panel inside checkable square for drawing tick/minus glyphs
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

	' 4. Read properties
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

Private Sub ApplyDesignerProps(mProps As Map)
	mChecked = B4XDaisyVariants.GetPropBool(mProps, "Checked", mChecked)
	mIndeterminate = B4XDaisyVariants.GetPropBool(mProps, "Indeterminate", mIndeterminate)
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

	mbMultiline = B4XDaisyVariants.GetPropBool(mProps, "Multiline", mbMultiline)
	mfLineSpacingExtra = B4XDaisyVariants.GetPropFloat(mProps, "LineSpacing", mfLineSpacingExtra)
	mfLineSpacingMult = B4XDaisyVariants.GetPropFloat(mProps, "LineSpacingMult", mfLineSpacingMult)
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("GroupName", mGroupName)
	props.Put("Checked", mChecked)
	props.Put("Indeterminate", mIndeterminate)
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
	props.Put("Multiline", mbMultiline)
	props.Put("LineSpacing", mfLineSpacingExtra)
	props.Put("LineSpacingMult", mfLineSpacingMult)
	props.Put("Required", mbRequired)
	props.Put("ErrorText", msErrorText)
	Return props
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
	If bValue Then mIndeterminate = False
	If bValue And mGroupName <> "" And mBase.IsInitialized Then
		UncheckGroupSiblings
	End If
	Refresh
End Sub

''' <summary>
''' Walks the parent and unchecks any sibling B4XDaisyCheckbox instances
''' sharing the same GroupName. Mirrors B4XDaisyRadio/B4XDaisyToggle so a
''' checkbox group can act as single-select when GroupName is set.
''' </summary>
Private Sub UncheckGroupSiblings
	Try
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized = False Then Return
		UncheckInParent(parent)
	Catch
		Return
	End Try
End Sub

Private Sub UncheckInParent(vParent As B4XView)
	If vParent.IsInitialized = False Then Return
	Try
		Dim count As Int = vParent.NumberOfViews
		For i = 0 To count - 1
			Dim v As B4XView = vParent.GetView(i)
			If v <> mBase And v.Tag Is B4XDaisyCheckbox Then
				Dim cb As B4XDaisyCheckbox = v.Tag
				If cb.GroupName = mGroupName And cb.Checked Then
					cb.Checked = False
				End If
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCheckbox.UncheckInParent: " & LastException.Message)
	End Try
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
''' Returns the component role.
''' </summary>
Public Sub getRole As String
	Return "checkbox"
End Sub

''' <summary>
''' Sets the Indeterminate state.
''' </summary>
Public Sub setIndeterminate(bValue As Boolean)
	mIndeterminate = bValue
	If bValue Then mChecked = False
	Refresh
End Sub

''' <summary>
''' Gets the Indeterminate state.
''' </summary>
Public Sub getIndeterminate As Boolean
	Return mIndeterminate
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
''' Sets the label text as a CharSequence (CSBuilder). When set, this takes precedence
''' over Text and supports clickable spans (call EnableClickEvents on the CSBuilder is
''' handled internally so tap events route to the module that built the CSBuilder).
''' </summary>
Public Sub setTextCS(oValue As Object)
	mTextCS = oValue
	mHasTextCS = True
	If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Gets the CharSequence label (CSBuilder) if set.
''' </summary>
Public Sub getTextCS As Object
	Return mTextCS
End Sub

''' <summary>
''' Enables multi-line wrapping for the label (use with TextCS for tappable links).
''' </summary>
Public Sub setMultiline(bValue As Boolean)
	mbMultiline = bValue
	If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Gets whether the label wraps across multiple lines.
''' </summary>
Public Sub getMultiline As Boolean
	Return mbMultiline
End Sub

''' <summary>
''' Extra spacing (pixels, pass e.g. 4dip) added between label lines. Applied to
''' multi-line / TextCS labels via the native TextView.setLineSpacing API.
''' </summary>
Public Sub setLineSpacing(fExtra As Float)
	mfLineSpacingExtra = fExtra
	If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Gets the extra line spacing (pixels) applied between label lines.
''' </summary>
Public Sub getLineSpacing As Float
	Return mfLineSpacingExtra
End Sub

''' <summary>
''' Line-height multiplier applied together with LineSpacing (default 1.0).
''' </summary>
Public Sub setLineSpacingMult(fValue As Float)
	mfLineSpacingMult = fValue
	If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Gets the line-height multiplier.
''' </summary>
Public Sub getLineSpacingMult As Float
	Return mfLineSpacingMult
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
	mBase.Visible = bValue
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
''' Dynamically sets the checkbox into an error validation state and displays the specified error text.
''' </summary>
Public Sub ShowError(sErrorMessage As String)
        msErrorText = sErrorMessage
        mbProgrammaticError = True
        If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Clears any dynamic error state and returns the checkbox to normal.
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
''' Sets the checked checkmark color override.
''' </summary>
Public Sub setCheckedTextColor(iColor As Int)
	mcCheckedTextColor = iColor
	Refresh
End Sub

''' <summary>
''' Gets the checked checkmark color override.
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
''' Called when the checkbox receives focus. Clears any transient
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

	Dim squareSize As Float = ResolveCheckboxSizeDip
	pnlCheckSquare.SetLayoutAnimated(0, 0, 0, squareSize, squareSize)
	If pnlCheckCanvas.IsInitialized Then
		pnlCheckCanvas.SetLayoutAnimated(0, 0, 0, squareSize, squareSize)
	End If
	cvs.Resize(squareSize, squareSize)

	Dim hasText As Boolean
	Dim textVal As String
	If mHasTextCS Then
		hasText = True
	Else
		textVal = mText
		If mbMultiline = False Then textVal = B4XDaisyVariants.NormalizeSingleLineText(mText)
		hasText = textVal.Length > 0
	End If

	If hasText = False Then
		' Position checkbox square in host panel based on position alignment
		Dim leftX As Float = 0
		If msPosition = "end" Then
			leftX = w - squareSize
		End If
		Dim topY As Float = (h - squareSize) / 2
		pnlCheckSquare.SetLayoutAnimated(0, leftX, topY, squareSize, squareSize)
		lblText.Visible = False
	Else
		lblText.Visible = True
		' B4A: toggle single-line vs multi-line wrapping on the native label.
		#If B4A
		Dim lblNative As Label = lblText
		lblNative.SingleLine = Not(mbMultiline)
		If mbMultiline And mfLineSpacingExtra > 0 Then
			Dim jolbl As JavaObject = lblNative
			jolbl.RunMethod("setLineSpacing", Array As Object(mfLineSpacingExtra, mfLineSpacingMult))
		End If
		#End If
		If mHasTextCS Then
			' CharSequence (CSBuilder) label with clickable spans.
			#If B4A
			Dim cs As CSBuilder = mTextCS
			lblNative.Text = cs
			' Custom movement method: only taps landing on a ClickableSpan are consumed (and
			' fire the span's onClick -> Terms_Click / Privacy_Click). Taps on the non-link
			' label text are NOT consumed so they fall through to the surface and toggle
			' the checkbox. The label is made non-clickable so it never steals non-link taps.
			Dim nativeMe As JavaObject = Me
			Dim mm As Object = nativeMe.RunMethod("createLinkOnlyMovementMethod", Null)
			Dim jolbl As JavaObject = lblNative
			jolbl.RunMethod("setMovementMethod", Array As Object(mm))
			jolbl.RunMethod("setClickable", Array As Object(False))
			#End If
		Else
			lblText.Text = ResolveLabelText(textVal)
		End If
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
			' Label on the left, Checkbox on the right
			Dim textLeft As Float = 0
			Dim textWidth As Float = w - squareSize - gap
			lblText.SetLayoutAnimated(0, textLeft, 0, textWidth, h)
			lblText.SetTextAlignment("CENTER", "LEFT")

			Dim leftX As Float = w - squareSize
			pnlCheckSquare.SetLayoutAnimated(0, leftX, topY, squareSize, squareSize)
		Else
			' Label on the right, Checkbox on the left
			Dim leftX As Float = 0
			pnlCheckSquare.SetLayoutAnimated(0, leftX, topY, squareSize, squareSize)

			Dim textLeft As Float = squareSize + gap
			Dim textWidth As Float = w - textLeft
			lblText.SetLayoutAnimated(0, textLeft, 0, textWidth, h)
			lblText.SetTextAlignment("CENTER", "LEFT")
		End If
	End If

	DrawCheckbox
	inResize = False
End Sub

Private Sub DrawCheckbox
	If pnlCheckSquare.IsInitialized = False Then Return

	Dim xColors As Map = ResolveVisualColors
	Dim bgColor As Int = xColors.Get("back")
	Dim borderColor As Int = xColors.Get("border")
	Dim tickColor As Int = xColors.Get("text")

	Dim bw As Float = Max(0, B4XDaisyVariants.GetBorderDip(1dip))
	Dim sz As Float = pnlCheckSquare.Width
	Dim radius As Float = ResolveCheckboxRadiusDip

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

	' Apply elevation shadow to the checkbox square (follows corner radius)
	B4XDaisyVariants.ApplyElevation(pnlCheckSquare, mShadow)

	' 2. Draw tick or minus glyph via B4XCanvas
	cvs.ClearRect(cvs.TargetRect)
	
	' DaisyUI checkbox uses p-[0.25rem] padding for md, so inner checkmark area is smaller
	' Checkmark stroke scales with size (DaisyUI: 2px base, scales with size)
	Dim strokeThickness As Float = Max(2dip, 2.5dip * (sz / 24dip))
	
	If mChecked Then
		' Checkmark: L-shape - DaisyUI uses clip-path polygon for proportions
		' Approximating: start ~20% from left, 50% from top; mid ~45%, 70%; end ~70%, 30%
		Dim startX As Float = 0.22 * sz
		Dim startY As Float = 0.50 * sz
		Dim midX As Float = 0.45 * sz
		Dim midY As Float = 0.70 * sz
		Dim endX As Float = 0.72 * sz
		Dim endY As Float = 0.30 * sz
		Dim p As B4XPath
		p.Initialize(startX, startY)
		p.LineTo(midX, midY)
		p.LineTo(endX, endY)
		cvs.DrawPath(p, tickColor, False, strokeThickness)
	Else If mIndeterminate Then
		' Indeterminate: horizontal line centered (DaisyUI translates -35% vertically)
		Dim sx As Float = 0.20 * sz
		Dim ex As Float = 0.80 * sz
		Dim cy As Float = 0.45 * sz  ' Slightly higher like DaisyUI's translate: 0 -35%
		cvs.DrawLine(sx, cy, ex, cy, tickColor, strokeThickness)
	End If
	cvs.Invalidate
End Sub

Private Sub ResolveVisualColors As Map
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim base100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))

	' DaisyUI checkbox border: color-mix(in oklab, var(--color-base-content) 20%, #0000)
	' Approximate as 20% opacity baseContent over transparent
	Dim borderColor As Int = B4XDaisyVariants.AlphaColor(baseContent, 0.20)

	Dim back As Int = base100
	Dim border As Int = borderColor
	Dim text As Int = baseContent

	Dim variantKey As String = mVariant.ToLowerCase
	If variantKey = "none" Then
		If mChecked Then
			back = baseContent
			border = baseContent
			text = base100
		Else If mIndeterminate Then
			back = B4XDaisyVariants.AlphaColor(baseContent, 0.20)
			border = B4XDaisyVariants.AlphaColor(baseContent, 0.20)
			text = baseContent
		Else
			back = base100
			border = borderColor
			text = xui.Color_Transparent
		End If
	Else
		Dim variantBg As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(variantKey, baseContent)
		Dim variantText As Int = B4XDaisyVariants.ResolveTextColorVariant(variantKey, xui.Color_White)
		Dim variantBorder As Int = B4XDaisyVariants.AlphaColor(variantBg, 0.20)

		If mChecked Then
			back = variantBg
			border = variantBg
			text = variantText
		Else If mIndeterminate Then
			back = B4XDaisyVariants.AlphaColor(variantBg, 0.20)
			border = variantBorder
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

Private Sub ResolveCheckboxSizeDip As Float
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

Private Sub ResolveCheckboxRadiusDip As Float
	Return B4XDaisyVariants.GetRadiusSelectorDip(4dip)
End Sub

Private Sub EstimatePreferredWidth As Int
	Dim squareSize As Float = ResolveCheckboxSizeDip
	If mText.Length = 0 Then Return squareSize
	Dim fontSize As Float = ResolveTextSizePoints
	Return squareSize + 8dip + EstimateTextWidth(mText, fontSize)
End Sub

Private Sub EstimatePreferredHeight As Int
	Dim squareSize As Float = ResolveCheckboxSizeDip
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
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCheckbox.EstimateTextWidth: " & LastException.Message)
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
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCheckbox.EstimateTextHeight: " & LastException.Message)
	End Try
	Return Max(1dip, Ceil(fFontSize * 1.3) + 2dip)
End Sub
#End Region

#Region Click Event Handling
Private Sub pnlSurface_Click
	If mEnabled = False Then Return
	' Group mode (GroupName set): single-select like a radio. A checked
	' checkbox in a group cannot be unchecked by re-tapping it; tapping a
	' different one checks it and unchecks the rest via UncheckGroupSiblings.
	If mGroupName <> "" Then
		If mChecked = True Then
			RaiseClick
			Return
		End If
		setChecked(True)
		RaiseCheckedEvent
		RaiseClick
		Return
	End If
	mChecked = Not(mChecked)
	mIndeterminate = False
	Refresh
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
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCheckbox.Release: " & LastException.Message)
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


#If Java
import android.text.Layout;
import android.text.Spannable;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.view.MotionEvent;
import android.widget.TextView;

/**
 * Returns a MovementMethod that ONLY consumes touches which land on a ClickableSpan
 * (firing the span's onClick on ACTION_UP). Touches on non-link text are not consumed,
 * so they fall through to the parent view (the checkbox surface) and toggle the box.
 * This avoids the OEM-dependent behaviour of the stock LinkMovementMethod, which can
 * either swallow non-link taps or let link taps also trigger the parent's click.
 */
public Object createLinkOnlyMovementMethod() {
	return new LinkMovementMethod() {
		@Override
		public boolean onTouchEvent(TextView widget, Spannable buffer, MotionEvent event) {
			int action = event.getAction();
			if (action == MotionEvent.ACTION_UP || action == MotionEvent.ACTION_DOWN) {
				int x = (int) event.getX();
				int y = (int) event.getY();
				x -= widget.getTotalPaddingLeft();
				y -= widget.getTotalPaddingTop();
				x += widget.getScrollX();
				y += widget.getScrollY();
				Layout layout = widget.getLayout();
				if (layout == null) return false;
				int line = layout.getLineForVertical(y);
				int off = layout.getOffsetForHorizontal(line, x);
				ClickableSpan[] link = buffer.getSpans(off, off, ClickableSpan.class);
				if (link.length != 0) {
					if (action == MotionEvent.ACTION_UP) {
						link[0].onClick(widget);
					}
					return true;   // consume link touches -> no checkbox toggle
				}
				return false;      // non-link -> fall through to surface -> toggle
			}
			return false;
		}
	};
}
#End If
