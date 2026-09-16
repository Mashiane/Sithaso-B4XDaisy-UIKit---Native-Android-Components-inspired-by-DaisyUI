B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: ItemChanged (Item As Map)
#Event: FocusChanged (HasFocus As Boolean)
#Event: Changed (SelectedIds As List)

#DesignerProperty: Key: Legend, DisplayName: Legend, FieldType: String, DefaultValue: Select options, Description: Fieldset legend text
#DesignerProperty: Key: LegendSize, DisplayName: Legend Size, FieldType: String, DefaultValue: text-sm, List: text-xs|text-sm|text-base|text-lg|text-xl, Description: Tailwind-like text size token for legend
#DesignerProperty: Key: LegendBold, DisplayName: Legend Bold, FieldType: Boolean, DefaultValue: False, Description: Render the fieldset legend caption in bold
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: Boolean, DefaultValue: False, Description: If True, the legend text is displayed as a label above the border box
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Optional accent variant for border tint
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: outlined, List: outlined|ghost|inset, Description: Border visual style
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 16, Description: Inner content padding in dip (p-4)
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: True, Description: Automatically grow to fit added content
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color (0 = default bg-base-200)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Legend text color (0 = use theme token)
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color override (0 = default border-base-300)
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip
#DesignerProperty: Key: InputBorder, DisplayName: Input Border, FieldType: Boolean, DefaultValue: False, Description: When True, apply B4XDaisyInput border color and width to the fieldset
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether at least one badge must be selected.
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the group.
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Error text displayed below the group when validation fails.
#DesignerProperty: Key: BadgeSelectionMode, DisplayName: Badge Selection Mode, FieldType: String, DefaultValue: multi, List: single|multi, Description: Single allows one checked badge, multi allows many
#DesignerProperty: Key: BadgeSize, DisplayName: Badge Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Badge size token
#DesignerProperty: Key: BadgeHeight, DisplayName: Badge Height, FieldType: String, DefaultValue: 8, Description: Badge height token (tailwind/css size)
#DesignerProperty: Key: BadgeColor, DisplayName: Badge Color, FieldType: String, DefaultValue: neutral, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Default (unchecked) badge color variant
#DesignerProperty: Key: BadgeCheckedColor, DisplayName: Badge Checked Color, FieldType: Color, DefaultValue: 0x00000000, Description: Checked badge background color (0 uses success)
#DesignerProperty: Key: BadgeCheckedTextColor, DisplayName: Badge Checked Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Checked badge text color (0 uses success text/white fallback)
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: Int, DefaultValue: 8, Description: Horizontal gap between badges in dip
#DesignerProperty: Key: RowGap, DisplayName: Row Gap, FieldType: Int, DefaultValue: 8, Description: Vertical gap between badge rows in dip

' ELI5: This is our toy box where we keep all important variables.
#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	Private msLegend As String = "Select options"
	Private msLegendSize As String = "text-sm"
	Private mbLegendBold As Boolean = False
	Private mbLabelAbove As Boolean = False
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

	Private msBadgeSelectionMode As String = "multi"
	Private msItemsSpec As String = ""

	Private msBadgeSize As String = "md"
	Private msBadgeHeight As String = "8"
	Private msBadgeColor As String = "neutral"
	Private msBadgeStyle As String = "solid"
	Private mcBadgeCheckedColor As Int = 0
	Private mcBadgeCheckedTextColor As Int = 0
	Private miGap As Int = 8
	Private miRowGap As Int = 8

	Private FieldsetComp As B4XDaisyFieldset
	Private FieldsetView As B4XView
	Private BadgeHost As B4XView

	Private BadgeDefs As List          ' List(Map("id":String, "text":String))
	Private BadgeOrder As List         ' List(String)
	Private BadgeById As Map           ' id -> B4XDaisyBadge
	Private BadgeViewById As Map       ' id -> B4XView
	Private BadgeTextById As Map       ' id -> text
	Private SelectedLookup As Map      ' id -> True

	Private mbRequired As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
	Private msHintText As String = ""
	Private msErrorText As String = ""
	Private pnlHintText As B4XView
	Private lblHintText As B4XView

	Private mInternalSelectionChange As Boolean = False
	Private inResize As Boolean = False
End Sub

' ELI5: This wakes up the component and remembers who to call back.
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	BadgeDefs.Initialize
	BadgeOrder.Initialize
	BadgeById.Initialize
	BadgeViewById.Initialize
	BadgeTextById.Initialize
	SelectedLookup.Initialize
End Sub

' ELI5: This builds the visual parts when the screen designer places this control.
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	mBase.RemoveAllViews

	EnsureFieldset
	ApplyDesignerProps(mProps)
	ApplyFieldsetStyle
	BuildDefinitionsFromSpec(msItemsSpec)
	RecreateBadgeViews
	Refresh
End Sub

' ELI5: This makes a new badge group view in code with a size you choose.
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

' ELI5: This places the badge group inside another view and sizes it.
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

' ELI5: This is a helper that forwards to AddToParent with the same values.
Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Return AddToParent(vParent, iLeft, iTop, iWidth, iHeight)
End Sub

' ELI5: This gives you the main view so you can use it elsewhere.
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
' ELI5: This tells us if all visual pieces are created and ready.
Public Sub IsReady As Boolean
	Return mBase.IsInitialized And FieldsetView.IsInitialized And BadgeHost.IsInitialized
End Sub

' ELI5: When size changes, this asks the control to redraw neatly.
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Refresh
	inResize = False
End Sub

' ELI5: This redraws styles and layout so everything stays in sync.
Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	ApplyFieldsetStyle
	RebuildLayout
End Sub

' ELI5: This makes sure the inner fieldset and badge host exist.
Private Sub EnsureFieldset
	If FieldsetView.IsInitialized Then Return

	Dim fs As B4XDaisyFieldset
	fs.Initialize(Me, "badgegroupfieldset")
	FieldsetComp = fs
	FieldsetView = FieldsetComp.AddToParent(mBase, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))

	Dim pHost As Panel
	pHost.Initialize("")
	BadgeHost = pHost
	BadgeHost.Color = xui.Color_Transparent
	FieldsetComp.AddContentView(BadgeHost, 0, 0, 1dip, 1dip)

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

' ELI5: This reads designer settings and stores them in our variables.
Private Sub ApplyDesignerProps(mProps As Map)
	msLegend = B4XDaisyVariants.GetPropString(mProps, "Legend", msLegend)
	' Fieldset props should stay raw here; Fieldset does its own normalization/calculation.
	msLegendSize = B4XDaisyVariants.GetPropString(mProps, "LegendSize", msLegendSize)
	mbLegendBold = B4XDaisyVariants.GetPropBool(mProps, "LegendBold", mbLegendBold)
	mbLabelAbove = B4XDaisyVariants.GetPropBool(mProps, "LabelAbove", mbLabelAbove)
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

	msBadgeSelectionMode = B4XDaisyVariants.NormalizeSelectionMode(B4XDaisyVariants.GetPropString(mProps, "BadgeSelectionMode", msBadgeSelectionMode))
	msItemsSpec = B4XDaisyVariants.GetPropString(mProps, "Items", msItemsSpec)

	' Badge props must stay raw here; each Badge handles its own normalization/parsing.
	msBadgeSize = B4XDaisyVariants.GetPropString(mProps, "BadgeSize", msBadgeSize)
	msBadgeHeight = B4XDaisyVariants.GetPropString(mProps, "BadgeHeight", msBadgeHeight)
	msBadgeColor = B4XDaisyVariants.GetPropString(mProps, "BadgeColor", msBadgeColor)
	mcBadgeCheckedColor = B4XDaisyVariants.GetPropColor(mProps, "BadgeCheckedColor", mcBadgeCheckedColor)
	mcBadgeCheckedTextColor = B4XDaisyVariants.GetPropColor(mProps, "BadgeCheckedTextColor", mcBadgeCheckedTextColor)
	miGap = Max(0, B4XDaisyVariants.GetPropInt(mProps, "Gap", miGap))
	miRowGap = Max(0, B4XDaisyVariants.GetPropInt(mProps, "RowGap", miRowGap))
	mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
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
	props.Put("LabelAbove", mbLabelAbove)
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
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	props.Put("BadgeSelectionMode", msBadgeSelectionMode)
	props.Put("Items", msItemsSpec)
	props.Put("BadgeSize", msBadgeSize)
	props.Put("BadgeHeight", msBadgeHeight)
	props.Put("BadgeColor", msBadgeColor)
	props.Put("BadgeCheckedColor", mcBadgeCheckedColor)
	props.Put("BadgeCheckedTextColor", mcBadgeCheckedTextColor)
	props.Put("Gap", miGap)
	props.Put("RowGap", miRowGap)
	Return props
End Sub

' ELI5: This sends our stored fieldset style settings to the fieldset control.

Private Sub MeasureHintHeight(iWidth As Int) As Int
	Dim displayedHint As String = msHintText
	If msErrorText.Length > 0 Then displayedHint = msErrorText
	If displayedHint.Length = 0 Then Return 0
	Dim txtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
	Return B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, txtSize, Typeface.DEFAULT, Max(1dip, iWidth - 4dip), 4dip)
End Sub

Private Sub LayoutHintPanel(iWidth As Int, iTop As Int, iGap As Int)
	If pnlHintText.IsInitialized = False Then Return
	Dim errH As Int = MeasureHintHeight(iWidth)
	If errH > 0 Then
		Dim displayedHint As String = msHintText
		Dim isError As Boolean = False
		If msErrorText.Length > 0 Then
			displayedHint = msErrorText
			isError = True
		End If
		pnlHintText.Visible = True
		pnlHintText.SetLayoutAnimated(0, 0, iTop + iGap, iWidth, errH)
		lblHintText.SetLayoutAnimated(0, 0, 0, iWidth, errH)
		lblHintText.Text = displayedHint
		Dim txtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
		lblHintText.TextSize = txtSize
		If isError Then
			lblHintText.TextColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
		Else
			Dim muted As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
			lblHintText.TextColor = B4XDaisyVariants.SetAlpha(muted, 170)
		End If
		lblHintText.SetTextAlignment("TOP", "LEFT")
	Else
		pnlHintText.Visible = False
		pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
End Sub

Private Sub ApplyFieldsetStyle
	If FieldsetComp.IsInitialized = False Then Return
	FieldsetComp.BeginUpdate
	FieldsetComp.setLegend(msLegend)
	FieldsetComp.setTextColor(mcTextColor)
	FieldsetComp.setLegendSize(msLegendSize)
	FieldsetComp.setLegendBold(mbLegendBold)
	FieldsetComp.setLabelAbove(mbLabelAbove)
	FieldsetComp.setRequired(mbRequired)
	FieldsetComp.setVariant(msVariant)
	FieldsetComp.setAutoHeight(mbAutoHeight)
	FieldsetComp.setPadding(miPadding)
	FieldsetComp.setRounded(msRounded)
	FieldsetComp.setBorderStyle(msBorderStyle)
	FieldsetComp.setBorderSize(miBorderSize)
	FieldsetComp.setInputBorder(mbInputBorder)
	FieldsetComp.setShadow(msShadow)
	FieldsetComp.setBackgroundColor(mcBackgroundColor)
	If msErrorText.Length > 0 Then
		FieldsetComp.setBorderColor(B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444))
	Else
		FieldsetComp.setBorderColor(mcBorderColor)
	End If
	FieldsetComp.EndUpdate
End Sub

' ELI5: This recalculates sizes and positions for fieldset and badge area.
Private Sub RebuildLayout
	If IsReady = False Then Return

	Dim w As Int = Max(1dip, mBase.Width)
	Dim initialH As Int = Max(1dip, mBase.Height)
	FieldsetView.SetLayoutAnimated(0, 0, 0, w, initialH)
	FieldsetComp.Refresh

	Dim contentPanel As B4XView = FieldsetComp.GetContentPanel
	Dim contentW As Int = Max(1dip, contentPanel.Width)

	Dim hostH As Int = LayoutBadges(contentW)
	BadgeHost.SetLayoutAnimated(0, 0, 0, contentW, hostH)
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

' ELI5: This wraps badges into rows, like placing stickers left to right.
Private Sub LayoutBadges(iContentW As Int) As Int
	If BadgeHost.IsInitialized = False Then Return 1dip
	Dim x As Int = 0
	Dim y As Int = 0
	Dim rowH As Int = 0
	Dim gapDip As Int = miGap * 1dip
	Dim rowGapDip As Int = miRowGap * 1dip

	For Each id As String In BadgeOrder
		If BadgeViewById.ContainsKey(id) = False Then Continue
		Dim v As B4XView = BadgeViewById.Get(id)
		Dim b As B4XDaisyBadge = BadgeById.Get(id)
		Dim bw As Int = Max(1dip, v.Width)
		Dim bh As Int = Max(1dip, v.Height)

		If x > 0 And x + bw > iContentW Then
			x = 0
			y = y + rowH + rowGapDip
			rowH = 0
		End If

		v.SetLayoutAnimated(0, x, y, bw, bh)
		b.Base_Resize(bw, bh)
		x = x + bw + gapDip
		rowH = Max(rowH, bh)
	Next

	If BadgeOrder.Size = 0 Then Return 1dip
	Return Max(1dip, y + rowH)
End Sub

' ELI5: This clears old badges and builds fresh badge views from item data.
Private Sub RecreateBadgeViews
	If BadgeHost.IsInitialized = False Then Return
	BadgeHost.RemoveAllViews
	BadgeOrder.Clear
	BadgeById.Clear
	BadgeViewById.Clear
	BadgeTextById.Clear

	NormalizeSelectionAgainstDefinitions

	For i = 0 To BadgeDefs.Size - 1
		Dim def As Map = BadgeDefs.Get(i)
		Dim id As String = def.GetDefault("id", "")
		Dim txt As String = def.GetDefault("text", "")
		If id.Length = 0 Then Continue
		' Badge visuals are global source-of-truth for this component.
		Dim startChecked As Boolean = SelectedLookup.ContainsKey(id)
		If def.ContainsKey("checked") Then startChecked = ResolveBoolValue(def.Get("checked"), startChecked)
		If startChecked Then
			SelectedLookup.Put(id, True)
		Else
			SelectedLookup.Remove(id)
		End If

		Dim chip As B4XDaisyBadge
		chip.Initialize(Me, "chip")
		chip.setId(id)
		chip.setTag(id)
		chip.setToggle(True)
		chip.setText(txt)
		chip.setSize(msBadgeSize)
		chip.setHeight(msBadgeHeight)
		chip.setRounded("rounded-full")
		chip.setStyle(msBadgeStyle)
		chip.setVariant(msBadgeColor)
		chip.setShadow("none")
		chip.setCheckedColor(mcBadgeCheckedColor)
		chip.setCheckedTextColor(mcBadgeCheckedTextColor)
		chip.setChecked(startChecked)
		'
		Dim chipView As B4XView = chip.AddToParent(BadgeHost, 0, 0, 0, 0)
		BadgeOrder.Add(id)
		BadgeById.Put(id, chip)
		BadgeViewById.Put(id, chipView)
		BadgeTextById.Put(id, txt)
	Next

	ApplySelectionModeConstraints(False)
	RebuildLayout
End Sub

' ELI5: This removes selected ids that no longer exist in items.
Private Sub NormalizeSelectionAgainstDefinitions
	Dim keep As Map
	keep.Initialize
	For i = 0 To BadgeDefs.Size - 1
		Dim d As Map = BadgeDefs.Get(i)
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

' ELI5: This runs when a badge is tapped and updates selection rules.
Private Sub chip_FocusChanged(bHasFocus As Boolean)
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

Private Sub chip_Checked(sId As String, bChecked As Boolean)
	If mInternalSelectionChange Then Return
	If sId = Null Then Return
	Dim key As String = sId.Trim
	If key.Length = 0 Then Return
	If BadgeById.ContainsKey(key) = False Then Return

	If msBadgeSelectionMode = "single" And bChecked Then
		mInternalSelectionChange = True
		For Each otherId As String In BadgeOrder
			If otherId = key Then Continue
			If BadgeById.ContainsKey(otherId) = False Then Continue
			Dim otherChip As B4XDaisyBadge = BadgeById.Get(otherId)
			If otherChip.getChecked Then otherChip.setChecked(False)
			SelectedLookup.Remove(otherId)
		Next
		mInternalSelectionChange = False
	End If

	If bChecked Then
		SelectedLookup.Put(key, True)
	Else
		SelectedLookup.Remove(key)
	End If

	If msBadgeSelectionMode = "single" Then ApplySelectionModeConstraints(False)
	RebuildLayout
	RaiseItemChanged(key, bChecked)
	RaiseChanged
End Sub

' ELI5: This tells your page which single badge changed.
Private Sub RaiseItemChanged(sId As String, bChecked As Boolean)
	If xui.SubExists(mCallBack, mEventName & "_ItemChanged", 1) = False Then Return
	Dim item As Map
	item.Initialize
	item.Put("id", sId)
	item.Put("text", BadgeTextById.GetDefault(sId, ""))
	item.Put("checked", bChecked)
	CallSub2(mCallBack, mEventName & "_ItemChanged", item)
End Sub

' ELI5: This tells your page the full selected-id list changed.
Private Sub RaiseChanged
	If xui.SubExists(mCallBack, mEventName & "_Changed", 1) = False Then Return
	CallSub2(mCallBack, mEventName & "_Changed", getSelectedIds)
End Sub

' ELI5: This gets the first found key value from an item map.
Private Sub GetDefValue(mDef As Map, oKeys() As String, DefaultValue As Object) As Object
	If mDef.IsInitialized = False Then Return DefaultValue
	For i = 0 To oKeys.Length - 1
		Dim k As String = oKeys(i)
		If mDef.ContainsKey(k) Then Return mDef.Get(k)
	Next
	Return DefaultValue
End Sub

' ELI5: This gets one item value as text with a safe fallback.
Private Sub GetDefString(mDef As Map, oKeys() As String, DefaultValue As String) As String
	Dim raw As Object = GetDefValue(mDef, oKeys, DefaultValue)
	If raw = Null Then Return DefaultValue
	Dim s As String = raw
	s = s.Trim
	If s.Length = 0 Then Return DefaultValue
	Return s
End Sub

' ELI5: This reads yes/no values from numbers, text, or booleans.
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

' ELI5: This updates each visible badge checked state from our selected map.
Private Sub ApplySelectionToVisibleBadges
	For Each id As String In BadgeOrder
		If BadgeById.ContainsKey(id) = False Then Continue
		Dim chip As B4XDaisyBadge = BadgeById.Get(id)
		chip.setChecked(SelectedLookup.ContainsKey(id))
	Next
	RebuildLayout
End Sub

' ELI5: This enforces single-select mode so only one badge stays selected.
Private Sub ApplySelectionModeConstraints(bRaiseEvents As Boolean)
	If msBadgeSelectionMode <> "single" Then Return

	Dim firstSelected As String = ""
	For Each id As String In BadgeOrder
		If SelectedLookup.ContainsKey(id) Then
			firstSelected = id
			Exit
		End If
	Next

	mInternalSelectionChange = True
	For Each id As String In BadgeOrder
		Dim shouldBeChecked As Boolean = (firstSelected.Length > 0 And id = firstSelected)
		If shouldBeChecked Then
			SelectedLookup.Put(id, True)
		Else
			SelectedLookup.Remove(id)
		End If
		If BadgeById.ContainsKey(id) Then
			Dim chip As B4XDaisyBadge = BadgeById.Get(id)
			chip.setChecked(shouldBeChecked)
		End If
	Next
	mInternalSelectionChange = False
	RebuildLayout

	If bRaiseEvents Then RaiseChanged
End Sub

' ELI5: This turns a pipe-and-colon text spec into badge item definitions.
Private Sub BuildDefinitionsFromSpec(sSpec As String)
	BadgeDefs.Clear
	If sSpec = Null Then Return
	Dim src As String = sSpec.Trim
	If src.Length = 0 Then Return

	Dim parts() As String = Regex.Split("\|", src)
	For i = 0 To parts.Length - 1
		Dim token As String = parts(i).Trim
		If token.Length = 0 Then Continue

		Dim id As String = ""
		Dim txt As String = ""
		Dim p As Int = token.IndexOf(":")
		If p >= 0 Then
			id = token.SubString2(0, p).Trim
			txt = token.SubString(p + 1).Trim
		Else
			txt = token
		End If
		If txt.Length = 0 Then txt = "Item " & (i + 1)
		If id.Length = 0 Then id = BuildFallbackId(txt, i + 1)
		id = EnsureUniqueId(id)

		BadgeDefs.Add(CreateMap("id": id, "text": txt))
	Next
End Sub

' ELI5: This makes a safe id from text when an id is missing.
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

' ELI5: This makes sure an id is unique by adding -2, -3, and so on.
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

' ELI5: This checks if an id already exists in current item definitions.
Private Sub DefinitionContainsId(sId As String) As Boolean
	For i = 0 To BadgeDefs.Size - 1
		Dim d As Map = BadgeDefs.Get(i)
		If d.GetDefault("id", "") = sId Then Return True
	Next
	Return False
End Sub

' ELI5: This finds where an item id sits in the definition list.
Private Sub FindDefinitionIndex(sId As String) As Int
	For i = 0 To BadgeDefs.Size - 1
		Dim d As Map = BadgeDefs.Get(i)
		If d.GetDefault("id", "") = sId Then Return i
	Next
	Return -1
End Sub


' ELI5: This turns a dip size into a px string for props.

'-
' Items API
'-

' ELI5: This adds or updates one badge item in our data list.
Public Sub AddBadgeItem(sId As String, sText As String)
	Dim idNorm As String = IIf(sId = Null, "", sId.Trim)
	Dim txt As String = IIf(sText = Null, "", sText.Trim)
	If txt.Length = 0 Then txt = idNorm
	If txt.Length = 0 Then txt = "Item " & (BadgeDefs.Size + 1)
	If idNorm.Length = 0 Then idNorm = BuildFallbackId(txt, BadgeDefs.Size + 1)

	Dim idx As Int = FindDefinitionIndex(idNorm)
	If idx >= 0 Then
		Dim existing As Map = BadgeDefs.Get(idx)
		existing.Put("text", txt)
		BadgeDefs.Set(idx, existing)
	Else
		Dim uniqueId As String = EnsureUniqueId(idNorm)
		BadgeDefs.Add(CreateMap("id": uniqueId, "text": txt))
	End If
	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This removes one badge item and its selection.
Public Sub RemoveBadgeItem(sId As String)
	If sId = Null Then Return
	Dim key As String = sId.Trim
	If key.Length = 0 Then Return
	Dim idx As Int = FindDefinitionIndex(key)
	If idx < 0 Then Return
	BadgeDefs.RemoveAt(idx)
	SelectedLookup.Remove(key)
	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This removes all badge items and clears selection.
Public Sub ClearBadgeItems
	BadgeDefs.Clear
	SelectedLookup.Clear
	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This accepts runtime items (Map/List/spec text) and rebuilds badges.
Public Sub setItems(oItems As Object)
	BadgeDefs.Clear
	SelectedLookup.Clear
	If oItems = Null Then
		If mBase.IsInitialized Then RecreateBadgeViews
		Return
	End If

	If oItems Is Map Then
		BuildDefinitionsFromMap(oItems)
	Else If oItems Is List Then
		BuildDefinitionsFromList(oItems)
	Else
		Dim s As String = oItems
		BuildDefinitionsFromSpec(s)
	End If

	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This reads key-value pairs and makes badge definitions from them.
Private Sub BuildDefinitionsFromMap(mItems As Map)
	If mItems.IsInitialized = False Then Return
	Dim keys As List = mItems.Keys
	For i = 0 To keys.Size - 1
		Dim rawKey As Object = keys.Get(i)
		Dim rawValue As Object = mItems.Get(rawKey)
		Dim id As String = IIf(rawKey = Null, "", rawKey)
		id = id.Trim
		If rawValue Is Map Then
			Dim it As Map = rawValue
			Dim def As Map = CloneMap(it)
			If id.Length > 0 And def.ContainsKey("id") = False Then def.Put("id", id)
			If def.ContainsKey("text") = False And def.ContainsKey("label") Then def.Put("text", def.Get("label"))
			AddDefinitionFromMap(def, i + 1)
		Else
			Dim txt As String = IIf(rawValue = Null, "", rawValue)
			AddDefinitionItem(id, txt, i + 1)
		End If
	Next
End Sub

' ELI5: This reads list items and makes badge definitions from them.
Private Sub BuildDefinitionsFromList(lstItems As List)
	If lstItems.IsInitialized = False Then Return
	For i = 0 To lstItems.Size - 1
		Dim raw As Object = lstItems.Get(i)
		Dim id As String = ""
		Dim txt As String = ""
		If raw Is Map Then
			Dim it As Map = raw
			Dim def As Map = CloneMap(it)
			If def.ContainsKey("text") = False And def.ContainsKey("label") Then def.Put("text", def.Get("label"))
			AddDefinitionFromMap(def, i + 1)
		Else
			Dim s As String = raw
			s = s.Trim
			Dim p As Int = s.IndexOf(":")
			If p >= 0 Then
				id = s.SubString2(0, p).Trim
				txt = s.SubString(p + 1).Trim
			Else
				txt = s
			End If
		End If

		If raw Is Map Then
			' Map entries were already handled above.
		Else
			AddDefinitionItem(id, txt, i + 1)
		End If
	Next
End Sub

' ELI5: This normalizes one item and adds it with a unique id.
Private Sub AddDefinitionItem(sId As String, sText As String, iIndex As Int)
	Dim def As Map
	def.Initialize
	def.Put("id", sId)
	def.Put("text", sText)
	AddDefinitionFromMap(def, iIndex)
End Sub

' ELI5: This normalizes one item map and keeps extra item settings too.
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
	BadgeDefs.Add(def)
	If def.ContainsKey("checked") Then
		If ResolveBoolValue(def.Get("checked"), False) Then
			SelectedLookup.Put(idNorm, True)
		Else
			SelectedLookup.Remove(idNorm)
		End If
	End If
End Sub

' ELI5: This copies a map so we can safely edit our own version.
Private Sub CloneMap(mSource As Map) As Map
	Dim out As Map
	out.Initialize
	If mSource.IsInitialized = False Then Return out
	For Each k As Object In mSource.Keys
		out.Put(k, mSource.Get(k))
	Next
	Return out
End Sub

' ELI5: This returns all badge item definitions as a list of maps.
Public Sub getItems As List
	Dim out As List
	out.Initialize
	For i = 0 To BadgeDefs.Size - 1
		Dim src As Map = BadgeDefs.Get(i)
		out.Add(CloneMap(src))
	Next
	Return out
End Sub

' ELI5: This stores text spec items and rebuilds badges from it.
Public Sub setItemsSpec(sValue As String)
	msItemsSpec = IIf(sValue = Null, "", sValue.Trim)
	BuildDefinitionsFromSpec(msItemsSpec)
	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This returns the text spec used for item creation.
Public Sub getItemsSpec As String
	Return msItemsSpec
End Sub

'-
' Selection API
'-

' ELI5: This sets single or multi selection behavior.
Public Sub setBadgeSelectionMode(sValue As String)
	msBadgeSelectionMode = B4XDaisyVariants.NormalizeSelectionMode(sValue)
	ApplySelectionModeConstraints(True)
End Sub

' ELI5: This returns current selection behavior mode.
Public Sub getBadgeSelectionMode As String
	Return msBadgeSelectionMode
End Sub

' ELI5: This sets which badges are selected, then updates visuals/events.
Private Sub setSelectedIds(lstIds As List)
	SelectedLookup.Clear
	If lstIds.IsInitialized = False Then
		ApplySelectionModeConstraints(False)
		ApplySelectionToVisibleBadges
		RaiseChanged
		Return
	End If

	If msBadgeSelectionMode = "single" Then
		For Each rawId As Object In lstIds
			Dim id As String = rawId
			If BadgeById.ContainsKey(id) Or FindDefinitionIndex(id) >= 0 Then
				SelectedLookup.Put(id, True)
				Exit
			End If
		Next
	Else
		For Each rawId As Object In lstIds
			Dim id As String = rawId
			If BadgeById.ContainsKey(id) Or FindDefinitionIndex(id) >= 0 Then
				SelectedLookup.Put(id, True)
			End If
		Next
	End If

	ApplySelectionModeConstraints(False)
	ApplySelectionToVisibleBadges
	RaiseChanged
End Sub

' ELI5: This returns selected badge ids in display order.
Private Sub getSelectedIds As List
	Dim ids As List
	ids.Initialize
	For Each id As String In BadgeOrder
		If SelectedLookup.ContainsKey(id) Then ids.Add(id)
	Next
	Return ids
End Sub

' ELI5: This sets selected badge ids from a ; separated string.
Public Sub setSelected(sValue As String)
	Dim ids As List
	ids.Initialize
	If sValue <> Null Then
		Dim src As String = sValue.Trim
		If src.Length > 0 Then
			Dim parts() As String = Regex.Split(";", src)
			For i = 0 To parts.Length - 1
				Dim id As String = parts(i).Trim
				If id.Length = 0 Then Continue
				If ids.IndexOf(id) = -1 Then ids.Add(id)
			Next
		End If
	End If
	setSelectedIds(ids)
End Sub

' ELI5: This returns selected badge ids as a ; separated string.
Public Sub getSelected As String
	Dim ids As List = getSelectedIds
	If ids.IsInitialized = False Or ids.Size = 0 Then Return ""
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To ids.Size - 1
		If i > 0 Then sb.Append(";")
		sb.Append(ids.Get(i))
	Next
	Return sb.ToString
End Sub

''' <summary>
''' Sets checked badge ids from a semicolon-delimited string (e.g. "ui;api;ops").
''' Mirrors the Checked API on B4XDaisyCheckboxGroup / B4XDaisyToggleGroup.
''' </summary>
Public Sub setChecked(sCheckedIds As String)
	setSelected(sCheckedIds)
End Sub

''' <summary>
''' Gets checked badge ids as a semicolon-delimited string. Returns "" if none.
''' Mirrors the Checked API on B4XDaisyCheckboxGroup / B4XDaisyToggleGroup.
''' </summary>
Public Sub getChecked As String
	Return getSelected
End Sub
' ELI5: This checks whether one badge id is currently selected.
Public Sub IsItemSelected(sId As String) As Boolean
	If sId = Null Then Return False
	Return SelectedLookup.ContainsKey(sId.Trim)
End Sub

' ELI5: This checks or unchecks an individual badge by its id.
Public Sub SetItemChecked(sId As String, bChecked As Boolean)
	If sId = Null Then Return
	Dim key As String = sId.Trim
	If key.Length = 0 Then Return
	If bChecked Then
		SelectedLookup.Put(key, True)
	Else
		SelectedLookup.Remove(key)
	End If
	ApplySelectionModeConstraints(False)
	ApplySelectionToVisibleBadges
	RaiseChanged
End Sub

' ELI5: This checks an individual badge by its id.
Public Sub CheckItem(sId As String)
	SetItemChecked(sId, True)
End Sub

' ELI5: This unchecks an individual badge by its id.
Public Sub UncheckItem(sId As String)
	SetItemChecked(sId, False)
End Sub

' ELI5: This unchecks every badge and raises selection changed.
Public Sub ClearSelection
	SelectedLookup.Clear
	ApplySelectionToVisibleBadges
	RaiseChanged
End Sub

'-
' Fieldset API
'-

' ELI5: This sets whether the legend is displayed above the border box.
Public Sub setLabelAbove(bValue As Boolean)
	mbLabelAbove = bValue
	If mBase.IsInitialized Then Refresh
End Sub

' ELI5: This returns whether label above mode is enabled.
Public Sub getLabelAbove As Boolean
	Return mbLabelAbove
End Sub

' ELI5: This enables Input-style border when True.
Public Sub setInputBorder(bValue As Boolean)
	mbInputBorder = bValue
	If mBase.IsInitialized Then Refresh
End Sub

' ELI5: This returns whether input border mode is active.
Public Sub getInputBorder As Boolean
	Return mbInputBorder
End Sub

' ELI5: This sets the legend setting.
Public Sub setLegend(sValue As String)
	msLegend = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current legend setting.
Public Sub getLegend As String
	Return msLegend
End Sub

' ELI5: This sets the legend size setting.
Public Sub setLegendSize(sValue As String)
	msLegendSize = B4XDaisyVariants.NormalizeLegendSize(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current legend size setting.
Public Sub getLegendSize As String
	Return msLegendSize
End Sub

' ELI5: This sets whether the legend caption is rendered in bold.
Public Sub setLegendBold(bValue As Boolean)
	mbLegendBold = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns whether the legend caption is rendered in bold.
Public Sub getLegendBold As Boolean
	Return mbLegendBold
End Sub

' ELI5: This sets the auto height setting.
Public Sub setAutoHeight(bValue As Boolean)
	mbAutoHeight = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current auto height setting.
Public Sub getAutoHeight As Boolean
	Return mbAutoHeight
End Sub

' ELI5: This sets the variant setting.
Public Sub setVariant(sValue As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current variant setting.
Public Sub getVariant As String
	Return msVariant
End Sub

' ELI5: This sets the border style setting.
Public Sub setBorderStyle(sValue As String)
	msBorderStyle = B4XDaisyVariants.NormalizeFieldsetBorderStyle(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current border style setting.
Public Sub getBorderStyle As String
	Return msBorderStyle
End Sub

' ELI5: This sets the padding setting.
Public Sub setPadding(iValue As Int)
	miPadding = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current padding setting.
Public Sub getPadding As Int
	Return miPadding
End Sub

' ELI5: This sets the rounded setting.
Public Sub setRounded(sValue As String)
	msRounded = IIf(sValue = Null, "theme", sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the rounded mode token.
Public Sub getRounded As String
	Return msRounded
End Sub

' ELI5: This tells you if rounded is active (not rounded-none).
Public Sub isRounded As Boolean
	Return B4XDaisyVariants.NormalizeRounded(msRounded) <> "rounded-none"
End Sub

' ELI5: This sets the rounded box setting.
Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

' ELI5: This tells you if rounded box is true right now.
Public Sub isRoundedBox As Boolean
	Return (msRounded = "rounded-box" Or msRounded = "theme")
End Sub

' ELI5: This sets the shadow setting.
Public Sub setShadow(sValue As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current shadow setting.
Public Sub getShadow As String
	Return msShadow
End Sub

' ELI5: This sets the background color setting.
Public Sub setBackgroundColor(oValue As Object)
	mcBackgroundColor = B4XDaisyVariants.ResolveColorValue(oValue, mcBackgroundColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current background color setting.
Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

' ELI5: This sets the text color setting.
Public Sub setTextColor(oValue As Object)
	mcTextColor = B4XDaisyVariants.ResolveColorValue(oValue, mcTextColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current text color setting.
Public Sub getTextColor As Int
	Return mcTextColor
End Sub

' ELI5: This sets the border color setting.
Public Sub setBorderColor(oValue As Object)
	mcBorderColor = B4XDaisyVariants.ResolveColorValue(oValue, mcBorderColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current border color setting.
Public Sub getBorderColor As Int
	Return mcBorderColor
End Sub

' ELI5: This sets the border size setting.
Public Sub setBorderSize(iValue As Int)
	miBorderSize = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current border size setting.
Public Sub getBorderSize As Int
	Return miBorderSize
End Sub

'-
' Badge style API
'-

' ELI5: This sets the badge size setting.
Public Sub setBadgeSize(sValue As String)
	msBadgeSize = sValue
End Sub

' ELI5: This returns the current badge size setting.
Public Sub getBadgeSize As String
	Return msBadgeSize
End Sub

' ELI5: This sets the badge height setting.
Public Sub setBadgeHeight(sValue As String)
	msBadgeHeight = sValue
End Sub

' ELI5: This returns the current badge height setting.
Public Sub getBadgeHeight As String
	Return msBadgeHeight
End Sub

' ELI5: This sets the badge color setting.
Public Sub setBadgeColor(sValue As String)
	msBadgeColor = sValue
End Sub

' ELI5: This returns the current badge color setting.
Public Sub getBadgeColor As String
	Return msBadgeColor
End Sub

' ELI5: This sets the badge style setting.
Public Sub setBadgeStyle(sValue As String)
	msBadgeStyle = B4XDaisyVariants.NormalizeBadgeStyle(sValue)
End Sub

' ELI5: This returns the current badge style setting.
Public Sub getBadgeStyle As String
	Return msBadgeStyle
End Sub

' ELI5: This sets the badge checked color setting.
Public Sub setBadgeCheckedColor(oValue As Object)
	mcBadgeCheckedColor = B4XDaisyVariants.ResolveColorValue(oValue, mcBadgeCheckedColor)
End Sub

' ELI5: This returns the current badge checked color setting.
Public Sub getBadgeCheckedColor As Int
	Return mcBadgeCheckedColor
End Sub

' ELI5: This sets the badge checked text color setting.
Public Sub setBadgeCheckedTextColor(oValue As Object)
	mcBadgeCheckedTextColor = B4XDaisyVariants.ResolveColorValue(oValue, mcBadgeCheckedTextColor)
End Sub

' ELI5: This returns the current badge checked text color setting.
Public Sub getBadgeCheckedTextColor As Int
	Return mcBadgeCheckedTextColor
End Sub

' ELI5: This sets the gap setting.
Public Sub setGap(iValue As Int)
	miGap = Max(0, iValue)
End Sub

' ELI5: This returns the current gap setting.
Public Sub getGap As Int
	Return miGap
End Sub

' ELI5: This sets the row gap setting.
Public Sub setRowGap(iValue As Int)
	miRowGap = Max(0, iValue)
End Sub

' ELI5: This returns the current row gap setting.
Public Sub getRowGap As Int
	Return miRowGap
End Sub

'-
' Common API
'-

' ELI5: This returns your custom tag object stored on this component.
Public Sub getTag As Object
	Return mTag
End Sub

' ELI5: This stores your custom tag object on this component.

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

Public Sub setHintText(sValue As String)
	If sValue = Null Then sValue = ""
	msHintText = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHintText As String
	Return msHintText
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
''' Called when the badge group receives focus. Clears any transient
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

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

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