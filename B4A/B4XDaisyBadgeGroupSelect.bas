B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: ItemChanged (Item As Map)
#Event: SelectionChanged (SelectedIds As List)

#DesignerProperty: Key: Legend, DisplayName: Legend, FieldType: String, DefaultValue: Select options, Description: Fieldset legend text
#DesignerProperty: Key: LegendSize, DisplayName: Legend Size, FieldType: String, DefaultValue: text-sm, List: text-xs|text-sm|text-base|text-lg|text-xl, Description: Tailwind-like text size token for legend
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Optional accent variant for border tint
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: outlined, List: outlined|ghost|inset, Description: Border visual style
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 16, Description: Inner content padding in dip (p-4)
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: True, Description: Automatically grow to fit added content
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius mode
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Use box radius for container
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color (0 = default bg-base-200)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Legend text color (0 = use theme token)
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color override (0 = default border-base-300)
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip
#DesignerProperty: Key: BadgeSelectionMode, DisplayName: Badge Selection Mode, FieldType: String, DefaultValue: multi, List: single|multi, Description: Single allows one checked badge, multi allows many
#DesignerProperty: Key: BadgeSize, DisplayName: Badge Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Badge size token
#DesignerProperty: Key: BadgeHeight, DisplayName: Badge Height, FieldType: String, DefaultValue: 8, Description: Badge height token (tailwind/css size)
#DesignerProperty: Key: BadgeColor, DisplayName: Badge Color, FieldType: String, DefaultValue: neutral, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Default (unchecked) badge color variant
#DesignerProperty: Key: BadgeCheckedColor, DisplayName: Badge Checked Color, FieldType: Color, DefaultValue: 0x00000000, Description: Checked badge background color (0 uses success)
#DesignerProperty: Key: BadgeCheckedTextColor, DisplayName: Badge Checked Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Checked badge text color (0 uses success text/white fallback)
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: Int, DefaultValue: 8, Description: Horizontal gap between badges in dip
#DesignerProperty: Key: RowGap, DisplayName: Row Gap, FieldType: Int, DefaultValue: 8, Description: Vertical gap between badge rows in dip

' ELI5: This is our toy box where we keep all important variables.
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	Private msLegend As String = "Select options"
	Private msLegendSize As String = "text-sm"
	Private msVariant As String = "none"
	Private msBorderStyle As String = "outlined"
	Private miPadding As Int = 16
	Private mbAutoHeight As Boolean = True
	Private msRounded As String = "theme"
	Private mbRoundedBox As Boolean = True
	Private msShadow As String = "none"
	Private mcBackgroundColor As Int = 0
	Private mcTextColor As Int = 0
	Private mcBorderColor As Int = 0
	Private miBorderSize As Int = 1

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

	Private mInternalSelectionChange As Boolean = False
End Sub

' ELI5: This wakes up the component and remembers who to call back.
Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	BadgeDefs.Initialize
	BadgeOrder.Initialize
	BadgeById.Initialize
	BadgeViewById.Initialize
	BadgeTextById.Initialize
	SelectedLookup.Initialize
End Sub

' ELI5: This builds the visual parts when the screen designer places this control.
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	mBase.RemoveAllViews

	EnsureFieldset
	ApplyDesignerProps(Props)
	ApplyFieldsetStyle
	BuildDefinitionsFromSpec(msItemsSpec)
	RecreateBadgeViews
	Refresh
End Sub

' ELI5: This makes a new badge group view in code with a size you choose.
Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(Width))
	props.Put("Height", ResolvePxSizeSpec(Height))
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

' ELI5: This places the badge group inside another view and sizes it.
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.Color = xui.Color_Transparent
		b.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
		Dim props As Map
		props.Initialize
		props.Put("Width", ResolvePxSizeSpec(Max(1dip, Width)))
		props.Put("Height", ResolvePxSizeSpec(Max(1dip, Height)))
		Dim dummy As Label
		DesignerCreateView(b, dummy, props)
	End If

	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	If mbAutoHeight Then h = Max(h, FieldsetView.Height)
	Parent.AddView(mBase, Left, Top, w, h)
	Base_Resize(w, h)
	Return mBase
End Sub

' ELI5: This is a helper that forwards to AddToParent with the same values.
Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Return AddToParent(Parent, Left, Top, Width, Height)
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
Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Refresh
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
End Sub

' ELI5: This reads designer settings and stores them in our variables.
Private Sub ApplyDesignerProps(Props As Map)
	msLegend = B4XDaisyVariants.GetPropString(Props, "Legend", "Select options")
	' Fieldset props should stay raw here; Fieldset does its own normalization/calculation.
	msLegendSize = B4XDaisyVariants.GetPropString(Props, "LegendSize", "text-sm")
	msVariant = B4XDaisyVariants.GetPropString(Props, "Variant", "none")
	msBorderStyle = B4XDaisyVariants.GetPropString(Props, "BorderStyle", "outlined")
	miPadding = B4XDaisyVariants.GetPropInt(Props, "Padding", 16)
	mbAutoHeight = B4XDaisyVariants.GetPropBool(Props, "AutoHeight", True)
	msRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", "theme")
	mbRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", True)
	msShadow = B4XDaisyVariants.GetPropString(Props, "Shadow", "none")
	mcBackgroundColor = B4XDaisyVariants.GetPropInt(Props, "BackgroundColor", 0x00000000)
	mcTextColor = B4XDaisyVariants.GetPropInt(Props, "TextColor", 0x00000000)
	mcBorderColor = B4XDaisyVariants.GetPropInt(Props, "BorderColor", 0x00000000)
	miBorderSize = B4XDaisyVariants.GetPropInt(Props, "BorderSize", 1)

	msBadgeSelectionMode = NormalizeSelectionMode(B4XDaisyVariants.GetPropString(Props, "BadgeSelectionMode", "multi"))
	msItemsSpec = B4XDaisyVariants.GetPropString(Props, "Items", msItemsSpec)

	' Badge props must stay raw here; each Badge handles its own normalization/parsing.
	msBadgeSize = B4XDaisyVariants.GetPropString(Props, "BadgeSize", "md")
	msBadgeHeight = B4XDaisyVariants.GetPropString(Props, "BadgeHeight", "8")
	msBadgeColor = B4XDaisyVariants.GetPropString(Props, "BadgeColor", "neutral")
	mcBadgeCheckedColor = B4XDaisyVariants.GetPropInt(Props, "BadgeCheckedColor", 0)
	mcBadgeCheckedTextColor = B4XDaisyVariants.GetPropInt(Props, "BadgeCheckedTextColor", 0)
	miGap = Max(0, B4XDaisyVariants.GetPropInt(Props, "Gap", 8))
	miRowGap = Max(0, B4XDaisyVariants.GetPropInt(Props, "RowGap", 8))
End Sub

' ELI5: This sends our stored fieldset style settings to the fieldset control.
Private Sub ApplyFieldsetStyle
	If FieldsetComp.IsInitialized = False Then Return
	FieldsetComp.setLegend(msLegend)
	FieldsetComp.setLegendSize(msLegendSize)
	FieldsetComp.setVariant(msVariant)
	FieldsetComp.setAutoHeight(mbAutoHeight)
	FieldsetComp.setPadding(miPadding)
	FieldsetComp.setRounded(msRounded)
	FieldsetComp.setRoundedBox(mbRoundedBox)
	FieldsetComp.setBorderStyle(msBorderStyle)
	FieldsetComp.setBorderSize(miBorderSize)
	FieldsetComp.setShadow(msShadow)
	FieldsetComp.setBackgroundColor(mcBackgroundColor)
	FieldsetComp.setBorderColor(mcBorderColor)
	FieldsetComp.setTextColor(mcTextColor)
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

	If mbAutoHeight Then
		Dim targetH As Int = Max(1dip, FieldsetView.Height)
		If Abs(mBase.Height - targetH) > 1dip Then
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, targetH)
			FieldsetView.SetLayoutAnimated(0, 0, 0, w, targetH)
		End If
	End If
End Sub

' ELI5: This wraps badges into rows, like placing stickers left to right.
Private Sub LayoutBadges(ContentW As Int) As Int
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

		If x > 0 And x + bw > ContentW Then
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
		chip.setToggle(true)
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
Private Sub chip_Checked(Id As String, Checked As Boolean)
	If mInternalSelectionChange Then Return
	If Id = Null Then Return
	Dim key As String = Id.Trim
	If key.Length = 0 Then Return
	If BadgeById.ContainsKey(key) = False Then Return

	If msBadgeSelectionMode = "single" And Checked Then
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

	If Checked Then
		SelectedLookup.Put(key, True)
	Else
		SelectedLookup.Remove(key)
	End If

	If msBadgeSelectionMode = "single" Then ApplySelectionModeConstraints(False)
	RebuildLayout
	RaiseItemChanged(key, Checked)
	RaiseSelectionChanged
End Sub

' ELI5: This tells your page which single badge changed.
Private Sub RaiseItemChanged(Id As String, Checked As Boolean)
	If xui.SubExists(mCallBack, mEventName & "_ItemChanged", 1) = False Then Return
	Dim item As Map
	item.Initialize
	item.Put("id", Id)
	item.Put("text", BadgeTextById.GetDefault(Id, ""))
	item.Put("checked", Checked)
	CallSub2(mCallBack, mEventName & "_ItemChanged", item)
End Sub

' ELI5: This tells your page the full selected-id list changed.
Private Sub RaiseSelectionChanged
	If xui.SubExists(mCallBack, mEventName & "_SelectionChanged", 1) = False Then Return
	CallSub2(mCallBack, mEventName & "_SelectionChanged", GetSelectedIds)
End Sub

' ELI5: This gets the first found key value from an item map.
Private Sub GetDefValue(Def As Map, Keys() As String, DefaultValue As Object) As Object
	If Def.IsInitialized = False Then Return DefaultValue
	For i = 0 To Keys.Length - 1
		Dim k As String = Keys(i)
		If Def.ContainsKey(k) Then Return Def.Get(k)
	Next
	Return DefaultValue
End Sub

' ELI5: This gets one item value as text with a safe fallback.
Private Sub GetDefString(Def As Map, Keys() As String, DefaultValue As String) As String
	Dim raw As Object = GetDefValue(Def, Keys, DefaultValue)
	If raw = Null Then Return DefaultValue
	Dim s As String = raw
	s = s.Trim
	If s.Length = 0 Then Return DefaultValue
	Return s
End Sub

' ELI5: This reads yes/no values from numbers, text, or booleans.
Private Sub ResolveBoolValue(Value As Object, DefaultValue As Boolean) As Boolean
	If Value = Null Then Return DefaultValue
	If Value Is Boolean Then Return Value
	If IsNumber(Value) Then Return (Value <> 0)
	Dim s As String = Value
	s = s.ToLowerCase.Trim
	Select Case s
		Case "true", "1", "yes", "y", "on"
			Return True
		Case "false", "0", "no", "n", "off", ""
			Return False
		Case Else
			Return DefaultValue
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
Private Sub ApplySelectionModeConstraints(RaiseEvents As Boolean)
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

	If RaiseEvents Then RaiseSelectionChanged
End Sub

' ELI5: This turns a pipe-and-colon text spec into badge item definitions.
Private Sub BuildDefinitionsFromSpec(Spec As String)
	BadgeDefs.Clear
	If Spec = Null Then Return
	Dim src As String = Spec.Trim
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
Private Sub BuildFallbackId(Text As String, Index As Int) As String
	Dim src As String = IIf(Text = Null, "", Text.ToLowerCase.Trim)
	If src.Length = 0 Then Return "item-" & Index
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
	If src.Length = 0 Then src = "item-" & Index
	Return src
End Sub

' ELI5: This makes sure an id is unique by adding -2, -3, and so on.
Private Sub EnsureUniqueId(Value As String) As String
	Dim baseId As String = IIf(Value = Null, "", Value.Trim)
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
Private Sub DefinitionContainsId(Id As String) As Boolean
	For i = 0 To BadgeDefs.Size - 1
		Dim d As Map = BadgeDefs.Get(i)
		If d.GetDefault("id", "") = Id Then Return True
	Next
	Return False
End Sub

' ELI5: This finds where an item id sits in the definition list.
Private Sub FindDefinitionIndex(Id As String) As Int
	For i = 0 To BadgeDefs.Size - 1
		Dim d As Map = BadgeDefs.Get(i)
		If d.GetDefault("id", "") = Id Then Return i
	Next
	Return -1
End Sub

' ELI5: This keeps selection mode valid: only single or multi.
Private Sub NormalizeSelectionMode(Value As String) As String
	If Value = Null Then Return "multi"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "single", "multi"
			Return s
		Case Else
			Return "multi"
	End Select
End Sub

' ELI5: This keeps legend size token valid for known text sizes.
Private Sub NormalizeLegendSize(Value As String) As String
	If Value = Null Then Return "text-sm"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "text-xs", "text-sm", "text-base", "text-lg", "text-xl"
			Return s
		Case Else
			Return "text-sm"
	End Select
End Sub

' ELI5: This keeps badge style token valid for known styles.
Private Sub NormalizeBadgeStyle(Value As String) As String
	If Value = Null Then Return "solid"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "solid", "soft", "outline", "dash", "ghost"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

' ELI5: This keeps fieldset border style valid for known options.
Private Sub NormalizeFieldsetBorderStyle(Value As String) As String
	If Value = Null Then Return "outlined"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "outlined", "ghost", "inset"
			Return s
		Case Else
			Return "outlined"
	End Select
End Sub

' ELI5: This converts numbers or color tokens into a real color value.
Private Sub ResolveColorValue(Value As Object, DefaultColor As Int) As Int
	If Value = Null Then Return DefaultColor
	If IsNumber(Value) Then Return Value
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, DefaultColor)
	Return DefaultColor
End Sub

' ELI5: This turns a dip size into a px string for props.
Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

'========================
' Items API
'========================

' ELI5: This adds or updates one badge item in our data list.
Public Sub AddBadgeItem(Id As String, Text As String)
	Dim idNorm As String = IIf(Id = Null, "", Id.Trim)
	Dim txt As String = IIf(Text = Null, "", Text.Trim)
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
Public Sub RemoveBadgeItem(Id As String)
	If Id = Null Then Return
	Dim key As String = Id.Trim
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
Public Sub setItems(Items As Object)
	BadgeDefs.Clear
	SelectedLookup.Clear
	If Items = Null Then
		If mBase.IsInitialized Then RecreateBadgeViews
		Return
	End If

	If Items Is Map Then
		BuildDefinitionsFromMap(Items)
	Else If Items Is List Then
		BuildDefinitionsFromList(Items)
	Else
		Dim s As String = Items
		BuildDefinitionsFromSpec(s)
	End If

	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This reads key-value pairs and makes badge definitions from them.
Private Sub BuildDefinitionsFromMap(Items As Map)
	If Items.IsInitialized = False Then Return
	Dim keys As List = Items.Keys
	For i = 0 To keys.Size - 1
		Dim rawKey As Object = keys.Get(i)
		Dim rawValue As Object = Items.Get(rawKey)
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
Private Sub BuildDefinitionsFromList(Items As List)
	If Items.IsInitialized = False Then Return
	For i = 0 To Items.Size - 1
		Dim raw As Object = Items.Get(i)
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
Private Sub AddDefinitionItem(Id As String, Text As String, Index As Int)
	Dim def As Map
	def.Initialize
	def.Put("id", Id)
	def.Put("text", Text)
	AddDefinitionFromMap(def, Index)
End Sub

' ELI5: This normalizes one item map and keeps extra item settings too.
Private Sub AddDefinitionFromMap(Source As Map, Index As Int)
	Dim def As Map = CloneMap(Source)
	Dim idNorm As String = GetDefString(def, Array As String("id"), "")
	Dim txt As String = GetDefString(def, Array As String("text", "label"), "")
	idNorm = idNorm.Trim
	If txt.Length = 0 Then txt = idNorm
	If txt.Length = 0 Then txt = "Item " & Index
	If idNorm.Length = 0 Then idNorm = BuildFallbackId(txt, Index)
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
Private Sub CloneMap(Source As Map) As Map
	Dim out As Map
	out.Initialize
	If Source.IsInitialized = False Then Return out
	For Each k As Object In Source.Keys
		out.Put(k, Source.Get(k))
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
Public Sub setItemsSpec(Value As String)
	msItemsSpec = IIf(Value = Null, "", Value.Trim)
	BuildDefinitionsFromSpec(msItemsSpec)
	If mBase.IsInitialized Then RecreateBadgeViews
End Sub

' ELI5: This returns the text spec used for item creation.
Public Sub getItemsSpec As String
	Return msItemsSpec
End Sub

'========================
' Selection API
'========================

' ELI5: This sets single or multi selection behavior.
Public Sub setBadgeSelectionMode(Value As String)
	msBadgeSelectionMode = NormalizeSelectionMode(Value)
	ApplySelectionModeConstraints(True)
End Sub

' ELI5: This returns current selection behavior mode.
Public Sub getBadgeSelectionMode As String
	Return msBadgeSelectionMode
End Sub

' ELI5: This sets which badges are selected, then updates visuals/events.
Public Sub setSelectedIds(Ids As List)
	SelectedLookup.Clear
	If Ids.IsInitialized = False Then
		ApplySelectionModeConstraints(False)
		ApplySelectionToVisibleBadges
		RaiseSelectionChanged
		Return
	End If

	If msBadgeSelectionMode = "single" Then
		For Each rawId As Object In Ids
			Dim id As String = rawId
			If BadgeById.ContainsKey(id) Or FindDefinitionIndex(id) >= 0 Then
				SelectedLookup.Put(id, True)
				Exit
			End If
		Next
	Else
		For Each rawId As Object In Ids
			Dim id As String = rawId
			If BadgeById.ContainsKey(id) Or FindDefinitionIndex(id) >= 0 Then
				SelectedLookup.Put(id, True)
			End If
		Next
	End If

	ApplySelectionModeConstraints(False)
	ApplySelectionToVisibleBadges
	RaiseSelectionChanged
End Sub

' ELI5: This returns selected badge ids in display order.
Public Sub getSelectedIds As List
	Dim ids As List
	ids.Initialize
	For Each id As String In BadgeOrder
		If SelectedLookup.ContainsKey(id) Then ids.Add(id)
	Next
	Return ids
End Sub

' ELI5: This sets selected badge ids from a ; separated string.
Public Sub setSelected(Value As String)
	Dim ids As List
	ids.Initialize
	If Value <> Null Then
		Dim src As String = Value.Trim
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

' ELI5: This checks whether one badge id is currently selected.
Public Sub IsItemSelected(Id As String) As Boolean
	If Id = Null Then Return False
	Return SelectedLookup.ContainsKey(Id.Trim)
End Sub

' ELI5: This unchecks every badge and raises selection changed.
Public Sub ClearSelection
	SelectedLookup.Clear
	ApplySelectionToVisibleBadges
	RaiseSelectionChanged
End Sub

'========================
' Fieldset API
'========================

' ELI5: This sets the legend setting.
Public Sub setLegend(Value As String)
	msLegend = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current legend setting.
Public Sub getLegend As String
	Return msLegend
End Sub

' ELI5: This sets the legend size setting.
Public Sub setLegendSize(Value As String)
	msLegendSize = NormalizeLegendSize(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current legend size setting.
Public Sub getLegendSize As String
	Return msLegendSize
End Sub

' ELI5: This sets the auto height setting.
Public Sub setAutoHeight(Value As Boolean)
	mbAutoHeight = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current auto height setting.
Public Sub getAutoHeight As Boolean
	Return mbAutoHeight
End Sub

' ELI5: This sets the variant setting.
Public Sub setVariant(Value As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current variant setting.
Public Sub getVariant As String
	Return msVariant
End Sub

' ELI5: This sets the border style setting.
Public Sub setBorderStyle(Value As String)
	msBorderStyle = NormalizeFieldsetBorderStyle(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current border style setting.
Public Sub getBorderStyle As String
	Return msBorderStyle
End Sub

' ELI5: This sets the padding setting.
Public Sub setPadding(Value As Int)
	miPadding = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current padding setting.
Public Sub getPadding As Int
	Return miPadding
End Sub

' ELI5: This sets the rounded setting.
Public Sub setRounded(Value As String)
	msRounded = IIf(Value = Null, "theme", Value)
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
Public Sub setRoundedBox(Value As Boolean)
	mbRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This tells you if rounded box is true right now.
Public Sub isRoundedBox As Boolean
	Return mbRoundedBox
End Sub

' ELI5: This sets the shadow setting.
Public Sub setShadow(Value As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current shadow setting.
Public Sub getShadow As String
	Return msShadow
End Sub

' ELI5: This sets the background color setting.
Public Sub setBackgroundColor(Value As Object)
	mcBackgroundColor = ResolveColorValue(Value, mcBackgroundColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current background color setting.
Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

' ELI5: This sets the text color setting.
Public Sub setTextColor(Value As Object)
	mcTextColor = ResolveColorValue(Value, mcTextColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current text color setting.
Public Sub getTextColor As Int
	Return mcTextColor
End Sub

' ELI5: This sets the border color setting.
Public Sub setBorderColor(Value As Object)
	mcBorderColor = ResolveColorValue(Value, mcBorderColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current border color setting.
Public Sub getBorderColor As Int
	Return mcBorderColor
End Sub

' ELI5: This sets the border size setting.
Public Sub setBorderSize(Value As Int)
	miBorderSize = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

' ELI5: This returns the current border size setting.
Public Sub getBorderSize As Int
	Return miBorderSize
End Sub

'========================
' Badge style API
'========================

' ELI5: This sets the badge size setting.
Public Sub setBadgeSize(Value As String)
	msBadgeSize = Value
End Sub

' ELI5: This returns the current badge size setting.
Public Sub getBadgeSize As String
	Return msBadgeSize
End Sub

' ELI5: This sets the badge height setting.
Public Sub setBadgeHeight(Value As String)
	msBadgeHeight = Value
End Sub

' ELI5: This returns the current badge height setting.
Public Sub getBadgeHeight As String
	Return msBadgeHeight
End Sub

' ELI5: This sets the badge color setting.
Public Sub setBadgeColor(Value As String)
	msBadgeColor = Value
End Sub

' ELI5: This returns the current badge color setting.
Public Sub getBadgeColor As String
	Return msBadgeColor
End Sub

' ELI5: This sets the badge style setting.
Public Sub setBadgeStyle(Value As String)
	msBadgeStyle = NormalizeBadgeStyle(Value)
End Sub

' ELI5: This returns the current badge style setting.
Public Sub getBadgeStyle As String
	Return msBadgeStyle
End Sub

' ELI5: This sets the badge checked color setting.
Public Sub setBadgeCheckedColor(Value As Int)
	mcBadgeCheckedColor = Value
End Sub

' ELI5: This returns the current badge checked color setting.
Public Sub getBadgeCheckedColor As Int
	Return mcBadgeCheckedColor
End Sub

' ELI5: This sets the badge checked text color setting.
Public Sub setBadgeCheckedTextColor(Value As Int)
	mcBadgeCheckedTextColor = Value
End Sub

' ELI5: This returns the current badge checked text color setting.
Public Sub getBadgeCheckedTextColor As Int
	Return mcBadgeCheckedTextColor
End Sub

' ELI5: This sets the gap setting.
Public Sub setGap(Value As Int)
	miGap = Max(0, Value)
End Sub

' ELI5: This returns the current gap setting.
Public Sub getGap As Int
	Return miGap
End Sub

' ELI5: This sets the row gap setting.
Public Sub setRowGap(Value As Int)
	miRowGap = Max(0, Value)
End Sub

' ELI5: This returns the current row gap setting.
Public Sub getRowGap As Int
	Return miRowGap
End Sub

'========================
' Common API
'========================

' ELI5: This returns your custom tag object stored on this component.
Public Sub getTag As Object
	Return mTag
End Sub

' ELI5: This stores your custom tag object on this component.
Public Sub setTag(Value As Object)
	mTag = Value
End Sub
