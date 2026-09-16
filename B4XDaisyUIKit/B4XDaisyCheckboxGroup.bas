B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: ItemChanged (id As String, text As String, checked As Boolean)
#Event: Changed (SelectedIds As List)
#Event: FocusChanged (HasFocus As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Legend, DisplayName: Legend, FieldType: String, DefaultValue: Select options, Description: Fieldset legend text
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
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: vertical, List: vertical|horizontal, Description: Items layout direction
#DesignerProperty: Key: Alignment, DisplayName: Checkbox Alignment, FieldType: String, DefaultValue: start, List: start|end, Description: Checkbox element check position
#DesignerProperty: Key: CheckboxColor, DisplayName: Checkbox Color, FieldType: String, DefaultValue: neutral, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Default checkbox color variant
#DesignerProperty: Key: CheckboxSize, DisplayName: Checkbox Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Checkbox size token
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: Int, DefaultValue: 8, Description: Gap between elements in dip
#DesignerProperty: Key: RowGap, DisplayName: Row Gap, FieldType: Int, DefaultValue: 8, Description: Row gap for wrapped flow mode in dip
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether at least one option must be selected.
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the group.
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Error text displayed below the group when validation fails.
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	Private msLegend As String = "Select options"
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

	Private msDirection As String = "vertical"
	Private msAlignment As String = "start"
	Private msCheckboxColor As String = "neutral"
	Private msCheckboxSize As String = "md"
	Private miGap As Int = 8
	Private miRowGap As Int = 8

	Private FieldsetComp As B4XDaisyFieldset
	Private FieldsetView As B4XView
	Private CheckboxHost As B4XView

	Private CheckboxDefs As List          ' List(Map("id":String, "text":String))
	Private CheckboxOrder As List         ' List(String)
	Private CheckboxById As Map           ' id -> B4XDaisyCheckbox
	Private CheckboxViewById As Map       ' id -> B4XView
	Private CheckboxTextById As Map       ' id -> text
	Private SelectedLookup As Map         ' id -> True

	Private mbRequired As Boolean = False
	Private mbLabelAbove As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
	Private msHintText As String = ""
	Private msErrorText As String = ""
	Private pnlHintText As B4XView
	Private lblHintText As B4XView

	Private mInternalSelectionChange As Boolean = False
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
	CheckboxDefs.Initialize
	CheckboxOrder.Initialize
	CheckboxById.Initialize
	CheckboxViewById.Initialize
	CheckboxTextById.Initialize
	SelectedLookup.Initialize
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	mBase.RemoveAllViews

	EnsureFieldset
	ApplyDesignerProps(mProps)
	ApplyFieldsetStyle
	RecreateCheckboxViews
	Refresh
End Sub

''' <summary>
''' Creates a programmatic view reference.
''' </summary>
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

''' <summary>
''' Adds the component to a parent view.
''' </summary>
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

''' <summary>
''' Adds the component to a parent view at the specified coordinates.
''' </summary>
Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Return AddToParent(vParent, iLeft, iTop, iWidth, iHeight)
End Sub

''' <summary>
''' Returns the underlying base view.
''' </summary>
''' <summary>
''' Helper accessor for getView.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Returns true if visual panels are ready.
''' </summary>
Public Sub IsReady As Boolean
	Return mBase.IsInitialized And FieldsetView.IsInitialized And CheckboxHost.IsInitialized
End Sub
#End Region

#Region Rendering and Layout
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
	fs.Initialize(Me, "checkboxgroupfieldset")
	FieldsetComp = fs
	FieldsetView = FieldsetComp.AddToParent(mBase, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))

	Dim pHost As Panel
	pHost.Initialize("")
	CheckboxHost = pHost
	CheckboxHost.Color = xui.Color_Transparent
	FieldsetComp.AddContentView(CheckboxHost, 0, 0, 1dip, 1dip)

	' Hint/error text panel below the fieldset
	Dim pHT As Panel
	pHT.Initialize("")
	pnlHintText = pHT
	pnlHintText.Color = xui.Color_Transparent
	mBase.AddView(pnlHintText, 0, 0, 1dip, 1dip)
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

	msDirection = B4XDaisyVariants.GetPropString(mProps, "Direction", msDirection)
	msAlignment = B4XDaisyVariants.GetPropString(mProps, "Alignment", msAlignment)
	msCheckboxColor = B4XDaisyVariants.GetPropString(mProps, "CheckboxColor", msCheckboxColor)
	msCheckboxSize = B4XDaisyVariants.GetPropString(mProps, "CheckboxSize", msCheckboxSize)
	miGap = Max(0, B4XDaisyVariants.GetPropInt(mProps, "Gap", miGap))
	miRowGap = Max(0, B4XDaisyVariants.GetPropInt(mProps, "RowGap", miRowGap))
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
	mbLabelAbove = B4XDaisyVariants.GetPropBool(mProps, "LabelAbove", mbLabelAbove)
	msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", msHintText)
	msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
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
	props.Put("Direction", msDirection)
	props.Put("Alignment", msAlignment)
	props.Put("CheckboxColor", msCheckboxColor)
	props.Put("CheckboxSize", msCheckboxSize)
	props.Put("Gap", miGap)
	props.Put("RowGap", miRowGap)
	props.Put("Required", mbRequired)
	props.Put("LabelAbove", mbLabelAbove)
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	Return props
End Sub


Private Sub ResolveLegendText As String
	If mbLabelAbove Then Return msLegend
	If mbRequired And msLegend.Length > 0 Then
		If msLegend.Contains("*") = False Then
			Return msLegend & " *"
		End If
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
Private Sub ApplyFieldsetStyle
	If FieldsetComp.IsInitialized = False Then Return
	FieldsetComp.BeginUpdate
	FieldsetComp.setLegend(ResolveLegendText)
	FieldsetComp.setTextColor(ResolveLegendColor)
	FieldsetComp.setLegendSize(ResolveLegendSize(msCheckboxSize, msLegendSize))
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
	If msErrorText.Length > 0 Then
		FieldsetComp.setBorderColor(B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444))
	Else
		FieldsetComp.setBorderColor(mcBorderColor)
	End If
	FieldsetComp.EndUpdate
End Sub

Private Sub ResolveLegendSize(sControlSize As String, sLegendSizeProp As String) As String
	If sLegendSizeProp <> "theme" Then Return sLegendSizeProp
	Select Case sControlSize.ToLowerCase
		Case "xs": Return "text-xs"
		Case "sm": Return "text-sm"
		Case "md": Return "text-sm"
		Case "lg": Return "text-base"
		Case "xl": Return "text-lg"
		Case Else: Return "text-sm"
	End Select
End Sub

Private Sub RebuildLayout
	If IsReady = False Then Return

	Dim w As Int = Max(1dip, mBase.Width)
	Dim initialH As Int = Max(1dip, mBase.Height)
	FieldsetView.SetLayoutAnimated(0, 0, 0, w, initialH)
	FieldsetComp.Refresh

	Dim contentPanel As B4XView = FieldsetComp.GetContentPanel
	Dim contentW As Int = Max(1dip, contentPanel.Width)

	Dim hostH As Int = LayoutCheckboxes(contentW)
	CheckboxHost.SetLayoutAnimated(0, 0, 0, contentW, hostH)
	FieldsetComp.Refresh

	Dim fieldsetH As Int = Max(1dip, FieldsetView.Height)
	Dim gap As Int = 4dip
	Dim errH As Int = MeasureHintHeight(w)
	Dim targetH As Int = fieldsetH
	If errH > 0 Then targetH = targetH + gap + errH
	FieldsetView.SetLayoutAnimated(0, 0, 0, w, fieldsetH)
	LayoutHintPanel(w, fieldsetH, gap)

	If mbAutoHeight Then
		If Abs(mBase.Height - targetH) > 1dip Then
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, targetH)
		End If
	End If
End Sub

Private Sub MeasureHintHeight(iWidth As Int) As Int
	Dim displayedHint As String = msHintText
	If msErrorText.Length > 0 Then displayedHint = msErrorText
	If displayedHint.Length = 0 Then Return 0
	Dim txtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
	Return B4XDaisyVariants.MeasureTextHeightSafe(msErrorText, txtSize, Typeface.DEFAULT, Max(1dip, iWidth - 4dip), 4dip)
End Sub

Private Sub LayoutHintPanel(iWidth As Int, iTop As Int, iGap As Int)
	If pnlHintText.IsInitialized = False Then Return
	Dim errH As Int = MeasureHintHeight(iWidth)
	If errH > 0 Then
		pnlHintText.Visible = True
		pnlHintText.SetLayoutAnimated(0, 0, iTop + iGap, iWidth, errH)
		lblHintText.SetLayoutAnimated(0, 0, 0, iWidth, errH)
		lblHintText.Text = msErrorText
		Dim txtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
		lblHintText.TextSize = txtSize
		lblHintText.TextColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
		lblHintText.SetTextAlignment("TOP", "LEFT")
	Else
		pnlHintText.Visible = False
		pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
End Sub

Private Sub LayoutCheckboxes(iContentW As Int) As Int
	If CheckboxHost.IsInitialized = False Then Return 1dip
	Dim x As Int = 0
	Dim y As Int = 0
	Dim rowH As Int = 0
	Dim gapDip As Int = miGap * 1dip
	Dim rowGapDip As Int = miRowGap * 1dip

	If msDirection.ToLowerCase = "vertical" Then
		For Each id As String In CheckboxOrder
			If CheckboxViewById.ContainsKey(id) = False Then Continue
			Dim v As B4XView = CheckboxViewById.Get(id)
			Dim cb As B4XDaisyCheckbox = CheckboxById.Get(id)
			
			Dim prefW As Int = iContentW
			Dim prefH As Int = cb.mBase.Height
			If prefH <= 0 Then prefH = 24dip
			
			v.SetLayoutAnimated(0, 0, y, prefW, prefH)
			cb.Base_Resize(prefW, prefH)
			y = y + prefH + gapDip
		Next
		If CheckboxOrder.Size = 0 Then Return 1dip
		Return Max(1dip, y - gapDip)
	Else
		' Horizontal Flow Layout (wrap)
		For Each id As String In CheckboxOrder
			If CheckboxViewById.ContainsKey(id) = False Then Continue
			Dim v As B4XView = CheckboxViewById.Get(id)
			Dim cb As B4XDaisyCheckbox = CheckboxById.Get(id)
			
			Dim bw As Int = v.Width
			Dim bh As Int = v.Height
			
			If x > 0 And x + bw > iContentW Then
				x = 0
				y = y + rowH + rowGapDip
				rowH = 0
			End If

			v.SetLayoutAnimated(0, x, y, bw, bh)
			cb.Base_Resize(bw, bh)
			
			x = x + bw + gapDip
			rowH = Max(rowH, bh)
		Next
		If CheckboxOrder.Size = 0 Then Return 1dip
		Return Max(1dip, y + rowH)
	End If
End Sub

Private Sub RecreateCheckboxViews
	If CheckboxHost.IsInitialized = False Then Return
	CheckboxHost.RemoveAllViews
	CheckboxOrder.Clear
	CheckboxById.Clear
	CheckboxViewById.Clear
	CheckboxTextById.Clear

	NormalizeSelectionAgainstDefinitions

	For i = 0 To CheckboxDefs.Size - 1
		Dim def As Map = CheckboxDefs.Get(i)
		Dim id As String = def.GetDefault("id", "")
		Dim txt As String = def.GetDefault("text", "")
		If id.Length = 0 Then Continue
		
		Dim startChecked As Boolean = SelectedLookup.ContainsKey(id)
		If def.ContainsKey("checked") Then startChecked = ResolveBoolValue(def.Get("checked"), startChecked)
		If startChecked Then
			SelectedLookup.Put(id, True)
		Else
			SelectedLookup.Remove(id)
		End If

		Dim cb As B4XDaisyCheckbox
		cb.Initialize(Me, "checkbox")
		cb.setTag(id)
		cb.setText(txt)
		cb.setVariant(msCheckboxColor)
		cb.setSize(msCheckboxSize)
		cb.setPosition(msAlignment)
		cb.setChecked(startChecked)
		
		' Dynamic size estimation
		Dim cbView As B4XView = cb.AddToParent(CheckboxHost, 0, 0, 0, 0)
		CheckboxOrder.Add(id)
		CheckboxById.Put(id, cb)
		CheckboxViewById.Put(id, cbView)
		CheckboxTextById.Put(id, txt)
	Next

	ApplySelectionState(False)
	RebuildLayout
End Sub

Private Sub NormalizeSelectionAgainstDefinitions
	Dim keep As Map
	keep.Initialize
	For i = 0 To CheckboxDefs.Size - 1
		Dim d As Map = CheckboxDefs.Get(i)
		Dim id As String = d.GetDefault("id", "")
		If id.Length > 0 Then keep.Put(id, True)
	Next

	Dim keysToRemove As List
	keysToRemove.Initialize
	For Each k As String In SelectedLookup.Keys
		If keep.ContainsKey(k) = False Then keysToRemove.Add(k)
	Next
	For Each k As String In keysToRemove
		SelectedLookup.Remove(k)
	Next
End Sub

Private Sub ApplySelectionState(bRaiseEvents As Boolean)
	mInternalSelectionChange = True
	For Each id As String In CheckboxOrder
		If CheckboxById.ContainsKey(id) = False Then Continue
		Dim cb As B4XDaisyCheckbox = CheckboxById.Get(id)
		Dim shouldBeChecked As Boolean = SelectedLookup.ContainsKey(id)
		If cb.getChecked <> shouldBeChecked Then cb.setChecked(shouldBeChecked)
	Next
	mInternalSelectionChange = False

	If bRaiseEvents Then
		RaiseChanged
	End If
End Sub
#End Region

#Region Checkbox Event Handling
Private Sub checkbox_FocusChanged(bHasFocus As Boolean)
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

Private Sub checkbox_Checked(bChecked As Boolean)
	If mInternalSelectionChange Then Return
	Dim cb As B4XDaisyCheckbox = Sender
	Dim id As String = cb.getTag
	
	If bChecked Then
		SelectedLookup.Put(id, True)
	Else
		SelectedLookup.Remove(id)
	End If

	RaiseItemChanged(id, bChecked)
	RaiseChanged
End Sub

Private Sub RaiseItemChanged(sId As String, bChecked As Boolean)
	Dim subName As String = mEventName & "_ItemChanged"
	Dim text As String = CheckboxTextById.GetDefault(sId, "")
	#If B4A
	If xui.SubExists(mCallBack, subName, 3) Then
		Dim jo As JavaObject = mCallBack
		jo.RunMethod("_" & subName.ToLowerCase, Array(sId, text, bChecked))
	Else If xui.SubExists(mCallBack, subName, 1) Then
		Dim item As Map
		item.Initialize
		item.Put("id", sId)
		item.Put("text", text)
		item.Put("checked", bChecked)
		CallSub2(mCallBack, subName, item)
	End If
	#Else If B4J
	If xui.SubExists(mCallBack, subName, 3) Then
		Dim jo As JavaObject = mCallBack
		jo.RunMethod("_" & subName.ToLowerCase, Array(sId, text, bChecked))
	Else If xui.SubExists(mCallBack, subName, 1) Then
		Dim item As Map
		item.Initialize
		item.Put("id", sId)
		item.Put("text", text)
		item.Put("checked", bChecked)
		CallSub2(mCallBack, subName, item)
	End If
	#Else If B4i
	If xui.SubExists(mCallBack, subName, 3) Then
		Dim no As NativeObject = mCallBack
		no.RunMethod("_" & subName.ToLowerCase & ":::", Array(sId, text, bChecked))
	Else If xui.SubExists(mCallBack, subName, 1) Then
		Dim item As Map
		item.Initialize
		item.Put("id", sId)
		item.Put("text", text)
		item.Put("checked", bChecked)
		CallSub2(mCallBack, subName, item)
	End If
	#End If
End Sub

Private Sub RaiseChanged
	If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", getSelectedIds)
	End If
End Sub
#End Region

#Region Public Items API
Public Sub AddItem(sId As String, sText As String)
	Dim idNorm As String = IIf(sId = Null, "", sId.Trim)
	Dim txt As String = IIf(sText = Null, "", sText.Trim)
	If txt.Length = 0 Then txt = idNorm
	If txt.Length = 0 Then txt = "Item " & (CheckboxDefs.Size + 1)
	If idNorm.Length = 0 Then idNorm = BuildFallbackId(txt, CheckboxDefs.Size + 1)

	Dim idx As Int = FindDefinitionIndex(idNorm)
	If idx >= 0 Then
		Dim existing As Map = CheckboxDefs.Get(idx)
		existing.Put("text", txt)
		CheckboxDefs.Set(idx, existing)
	Else
		Dim uniqueId As String = EnsureUniqueId(idNorm)
		CheckboxDefs.Add(CreateMap("id": uniqueId, "text": txt))
	End If
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub RemoveItem(sId As String)
	If sId = Null Then Return
	Dim key As String = sId.Trim
	If key.Length = 0 Then Return
	Dim idx As Int = FindDefinitionIndex(key)
	If idx < 0 Then Return
	CheckboxDefs.RemoveAt(idx)
	SelectedLookup.Remove(key)
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub Clear
	CheckboxDefs.Clear
	SelectedLookup.Clear
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub setItems(mItems As Map)
	CheckboxDefs.Clear
	SelectedLookup.Clear
	If mItems = Null Then
		If mBase.IsInitialized Then RecreateCheckboxViews
		Return
	End If
	BuildDefinitionsFromMap(mItems)
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub getItems As Map
	Dim out As Map
	out.Initialize
	For i = 0 To CheckboxDefs.Size - 1
		Dim src As Map = CheckboxDefs.Get(i)
		Dim id As String = src.Get("id")
		Dim txt As String = src.Get("text")
		out.Put(id, txt)
	Next
	Return out
End Sub
#End Region

#Region Selection API
Private Sub setSelectedIds(lstIds As List)
	SelectedLookup.Clear
	If lstIds.IsInitialized = False Then
		If mBase.IsInitialized Then ApplySelectionState(True)
		Return
	End If

	For Each rawId As Object In lstIds
		Dim id As String = rawId
		If CheckboxById.ContainsKey(id) Or FindDefinitionIndex(id) >= 0 Then
			SelectedLookup.Put(id, True)
		End If
	Next

	If mBase.IsInitialized Then ApplySelectionState(True)
End Sub

Private Sub getSelectedIds As List
	Dim out As List
	out.Initialize
	For Each id As String In CheckboxOrder
		If SelectedLookup.ContainsKey(id) Then out.Add(id)
	Next
	Return out
End Sub

''' <summary>
''' Sets checked items from a semicolon-delimited string of IDs.
''' Example: "apples;bananas;oranges"
''' </summary>
Public Sub setChecked(sCheckedIds As String)
	SelectedLookup.Clear
	If sCheckedIds = Null Then
		If mBase.IsInitialized Then ApplySelectionState(True)
		Return
	End If
	Dim parts() As String = Regex.Split(";", sCheckedIds)
	For Each id As String In parts
		id = id.Trim
		If id.Length > 0 And (CheckboxById.ContainsKey(id) Or FindDefinitionIndex(id) >= 0) Then
			SelectedLookup.Put(id, True)
		End If
	Next
	If mBase.IsInitialized Then ApplySelectionState(True)
End Sub

''' <summary>
''' Gets checked item IDs as a semicolon-delimited string.
''' Returns empty string if none checked.
''' </summary>
Public Sub getChecked As String
	Dim out As List
	out.Initialize
	For Each id As String In CheckboxOrder
		If SelectedLookup.ContainsKey(id) Then out.Add(id)
	Next
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To out.Size - 1
		If i > 0 Then sb.Append(";")
		sb.Append(out.Get(i))
	Next
	Return sb.ToString
End Sub

Public Sub SetItemChecked(sId As String, bChecked As Boolean)
	If sId = Null Then Return
	Dim key As String = sId.Trim
	If key.Length = 0 Then Return
	If bChecked Then
		SelectedLookup.Put(key, True)
	Else
		SelectedLookup.Remove(key)
	End If
	If mBase.IsInitialized Then ApplySelectionState(True)
End Sub

Public Sub CheckItem(sId As String)
	SetItemChecked(sId, True)
End Sub

Public Sub UncheckItem(sId As String)
	SetItemChecked(sId, False)
End Sub

Public Sub IsItemChecked(sId As String) As Boolean
	If sId = Null Then Return False
	Return SelectedLookup.ContainsKey(sId.Trim)
End Sub
#End Region

#Region Styling Getters/Setters
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

Public Sub setDirection(sValue As String)
	msDirection = sValue
	Refresh
End Sub

Public Sub getDirection As String
	Return msDirection
End Sub

Public Sub setAlignment(sValue As String)
	msAlignment = sValue
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub getAlignment As String
	Return msAlignment
End Sub

Public Sub setCheckboxColor(sValue As String)
	msCheckboxColor = sValue
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub getCheckboxColor As String
	Return msCheckboxColor
End Sub

Public Sub setCheckboxSize(sValue As String)
	msCheckboxSize = sValue
	If mBase.IsInitialized Then RecreateCheckboxViews
End Sub

Public Sub getCheckboxSize As String
	Return msCheckboxSize
End Sub

Public Sub setAutoHeight(bValue As Boolean)
	mbAutoHeight = bValue
	Refresh
End Sub

Public Sub getAutoHeight As Boolean
	Return mbAutoHeight
End Sub

Public Sub setPadding(iValue As Int)
	miPadding = iValue
	Refresh
End Sub

Public Sub getPadding As Int
	Return miPadding
End Sub

Public Sub setGap(iValue As Int)
	miGap = iValue
	Refresh
End Sub

Public Sub getGap As Int
	Return miGap
End Sub

Public Sub setRowGap(iValue As Int)
	miRowGap = iValue
	Refresh
End Sub

Public Sub getRowGap As Int
	Return miRowGap
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

' Required / error validation helpers
Public Sub setRequired(bValue As Boolean)
	mbRequired = bValue
	If mBase.IsInitialized Then Refresh
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

Public Sub ShowError(sErrorMessage As String)
        msErrorText = sErrorMessage
        mbProgrammaticError = True
        If mBase.IsInitialized Then Refresh
End Sub

Public Sub ClearError
        msErrorText = ""
        mbProgrammaticError = False
        mbValidationTouched = False
        If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIsValid As Boolean
	Return (msErrorText.Length = 0)
End Sub

''' <summary>
''' Validates the group. When Required=True and no option is selected,
''' shows the configured ErrorText (or a default message) and returns False.
''' </summary>
Public Sub Validate As Boolean
	If mbRequired = False Then
                mbProgrammaticError = False
		ClearError
		Return True
	End If
	If SelectedLookup.Size > 0 Then
                mbProgrammaticError = False
		ClearError
		Return True
	End If
	Dim msg As String = msErrorText
	If msg.Length = 0 Then msg = "This field is required."
        mbValidationTouched = True
	ShowError(msg)
	Return False
End Sub

''' <summary>
''' Called when the checkbox group receives focus. Clears any transient
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
    ' No state changes on blur; skip Refresh to avoid a full re-layout on every focus loss.
End Sub
Public Sub setBorderStyle(sValue As String)
	msBorderStyle = B4XDaisyVariants.NormalizeFieldsetBorderStyle(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderStyle As String
	Return msBorderStyle
End Sub

Public Sub setRounded(sValue As String)
	msRounded = IIf(sValue = Null, "theme", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub isRounded As Boolean
	Return B4XDaisyVariants.NormalizeRounded(msRounded) <> "rounded-none"
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
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mcBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
	mcTextColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mcTextColor
End Sub

Public Sub setBorderColor(iValue As Int)
	mcBorderColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	Return mcBorderColor
End Sub

Public Sub setBorderSize(iValue As Int)
	miBorderSize = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderSize As Int
	Return miBorderSize
End Sub

Public Sub setInputBorder(bValue As Boolean)
	mbInputBorder = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getInputBorder As Boolean
	Return mbInputBorder
End Sub
#End Region

#Region Internal Helpers
Private Sub BuildDefinitionsFromMap(mItems As Map)
	If mItems.IsInitialized = False Then Return
	Dim idx As Int = 1
	For Each rawKey As Object In mItems.Keys
		Dim rawValue As Object = mItems.Get(rawKey)
		Dim id As String = IIf(rawKey = Null, "", rawKey)
		id = id.Trim
		If rawValue Is Map Then
			Dim it As Map = rawValue
			Dim def As Map = CloneMap(it)
			If id.Length > 0 And def.ContainsKey("id") = False Then def.Put("id", id)
			If def.ContainsKey("text") = False And def.ContainsKey("label") Then def.Put("text", def.Get("label"))
			AddDefinitionFromMap(def, idx)
		Else
			Dim txt As String = IIf(rawValue = Null, "", rawValue)
			AddDefinitionItem(id, txt, idx)
		End If
		idx = idx + 1
	Next
End Sub



Private Sub AddDefinitionItem(sId As String, sText As String, iIndex As Int)
	Dim def As Map
	def.Initialize
	def.Put("id", sId)
	def.Put("text", sText)
	AddDefinitionFromMap(def, iIndex)
End Sub

Private Sub AddDefinitionFromMap(mSource As Map, iIndex As Int)
	Dim def As Map = CloneMap(mSource)
	Dim idNorm As String = GetDefString(def, Array As String("id"), "")
	Dim txt As String = GetDefString(def, Array As String("text", "label"), "")
	idNorm = idNorm.Trim
	If txt.Length = 0 Then txt = idNorm
	If txt.Length = 0 Then txt = "Item " & iIndex
	If idNorm.Length = 0 Then idNorm = BuildFallbackId(txt, iIndex)
	If DefinitionContainsId(idNorm) Then idNorm = EnsureUniqueId(idNorm)
	def.Put("id", idNorm)
	def.Put("text", txt)
	CheckboxDefs.Add(def)
	If def.ContainsKey("checked") Then
		If ResolveBoolValue(def.Get("checked"), False) Then
			SelectedLookup.Put(idNorm, True)
		Else
			SelectedLookup.Remove(idNorm)
		End If
	End If
End Sub

Private Sub BuildFallbackId(sText As String, iIndex As Int) As String
	Dim src As String = IIf(sText = Null, "", sText.ToLowerCase.Trim)
	If src.Length = 0 Then Return "item-" & iIndex
	src = src.Replace(" ", "-")
	src = src.Replace(":", "-")
	src = src.Replace("|", "-")
	src = src.Replace(",", "-")
	src = src.Replace("/", "-")
	src = src.Replace("\", "-")
	Do While src.Contains("--")
		src = src.Replace("--", "-")
	Loop
	If src.StartsWith("-") Then src = src.SubString(1)
	If src.EndsWith("-") Then src = src.SubString2(0, src.Length - 1)
	If src.Length = 0 Then src = "item-" & iIndex
	Return src
End Sub

Private Sub EnsureUniqueId(sValue As String) As String
	Dim baseId As String = IIf(sValue = Null, "", sValue.Trim)
	If baseId.Length = 0 Then baseId = "item"
	Dim candidate As String = baseId
	Dim n As Int = 2
	Do While DefinitionContainsId(candidate)
		candidate = baseId & "-" & n
		n = n + 1
	Loop
	Return candidate
End Sub

Private Sub DefinitionContainsId(sId As String) As Boolean
	For i = 0 To CheckboxDefs.Size - 1
		Dim d As Map = CheckboxDefs.Get(i)
		If d.GetDefault("id", "") = sId Then Return True
	Next
	Return False
End Sub

Private Sub FindDefinitionIndex(sId As String) As Int
	For i = 0 To CheckboxDefs.Size - 1
		Dim d As Map = CheckboxDefs.Get(i)
		If d.GetDefault("id", "") = sId Then Return i
	Next
	Return -1
End Sub

Private Sub CloneMap(mSource As Map) As Map
	Dim out As Map
	out.Initialize
	If mSource.IsInitialized = False Then Return out
	For Each k As Object In mSource.Keys
		out.Put(k, mSource.Get(k))
	Next
	Return out
End Sub

Private Sub GetDefValue(mDef As Map, oKeys() As String, DefaultValue As Object) As Object
	If mDef.IsInitialized = False Then Return DefaultValue
	For i = 0 To oKeys.Length - 1
		Dim k As String = oKeys(i)
		If mDef.ContainsKey(k) Then Return mDef.Get(k)
	Next
	Return DefaultValue
End Sub

Private Sub GetDefString(mDef As Map, oKeys() As String, DefaultValue As String) As String
	Dim raw As Object = GetDefValue(mDef, oKeys, DefaultValue)
	If raw = Null Then Return DefaultValue
	Dim s As String = raw
	s = s.Trim
	If s.Length = 0 Then Return DefaultValue
	Return s
End Sub

Private Sub ResolveBoolValue(oValue As Object, bDefaultValue As Boolean) As Boolean
	If oValue = Null Then Return bDefaultValue
	If oValue Is Boolean Then Return oValue
	If IsNumber(oValue) Then Return (oValue <> 0)
	Dim s As String = oValue
	s = s.ToLowerCase.Trim
	Select Case s
		Case "true", "1", "yes", "y", "on"
			Return True
		Case "false", "0", "no", "n", "off", ""
			Return False
		Case Else
			Return bDefaultValue
	End Select
End Sub
#End Region

''' <summary>
''' Gets the complete height of the component.
''' </summary>
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

#Region Cleanup
Public Sub Release
	For Each id As String In CheckboxOrder
		If CheckboxById.ContainsKey(id) Then
			Dim cb As B4XDaisyCheckbox = CheckboxById.Get(id)
			cb.Release
			cb.setTag(Null)
		End If
	Next
	CheckboxById.Clear
	CheckboxViewById.Clear
	CheckboxDefs.Clear
	CheckboxOrder.Clear
	CheckboxTextById.Clear
	SelectedLookup.Clear
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
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

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region