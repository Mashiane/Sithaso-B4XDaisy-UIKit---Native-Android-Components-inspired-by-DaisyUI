B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
' B4XDaisyPicker
' 100% Parity with Ionic v8 ion-picker (Inline Compositional Architecture)
#IgnoreWarnings:12,9

#Event: Changed (ColumnName As String, Value As Object)

#DesignerProperty: Key: Mode, DisplayName: Mode, FieldType: String, DefaultValue: md, List: ios|md, Description: Platform rendering mode.
#DesignerProperty: Key: FadeBackground, DisplayName: Fade Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Maps to --fade-background-rgb gradient masks.
#DesignerProperty: Key: HighlightBackground, DisplayName: Highlight Color, FieldType: Color, DefaultValue: 0x1A000000, Description: Maps to --highlight-background.
#DesignerProperty: Key: HighlightVariant, DisplayName: Highlight Variant, FieldType: String, DefaultValue: , List: none|primary|secondary|accent|info|success|warning|error, Description: DaisyUI variant for the selected-item highlight band. Overrides Highlight Color when set.
#DesignerProperty: Key: ActiveTextColor, DisplayName: Active Text Color, FieldType: Color, DefaultValue: 0, Description: Text color of the selected (centered) item. 0 = auto (uses the highlight variant -content color when a HighlightVariant is set, else the normal column text color).
#DesignerProperty: Key: HighlightRadius, DisplayName: Highlight Radius, FieldType: Int, DefaultValue: 8, Description: Maps to --highlight-border-radius.
#DesignerProperty: Key: VisibleItems, DisplayName: Visible Items, FieldType: Int, DefaultValue: 5, Description: Number of option rows visible at once (odd values center cleanly).
#DesignerProperty: Key: PickerType, DisplayName: Picker Type, FieldType: String, DefaultValue: default, List: default|auto, Description: 'default' = user-defined columns; 'auto' = columns auto-generated from InputFormat (date/time/date-time/12h). Legacy date/time/date-time values map to 'auto'.
#DesignerProperty: Key: InputFormat, DisplayName: Input Format, FieldType: String, DefaultValue: Y-m-d, Description: flatpickr-style tokens that define auto columns AND the returned value. Y/y year, m/n/M/F month, d/j day, H/G 24h, h/g 12h, i minute, s second, K/a AM-PM. Use [..] for literal text.
#DesignerProperty: Key: DisplayFormat, DisplayName: Display Format, FieldType: String, DefaultValue:, Description: flatpickr-style tokens controlling how auto-generated wheels DISPLAY each value (independent of InputFormat, which controls the returned value). e.g. "F" shows full month names on the month wheel, "j" shows day without leading zero, "y" shows 2-digit year. Empty = default labels (short month, 2-digit day, 4-digit year). Only affects PickerType=auto.
#DesignerProperty: Key: MinYear, DisplayName: Min Year, FieldType: Int, DefaultValue: 0, Description: Lowest year for date/date-time pickers (0 = current year - 10).
#DesignerProperty: Key: MaxYear, DisplayName: Max Year, FieldType: Int, DefaultValue: 0, Description: Highest year for date/date-time pickers (0 = current year + 10).
#DesignerProperty: Key: ColumnDelimiter, DisplayName: Column Delimiter, FieldType: String, DefaultValue: , Description: When set, GetValue returns the column values joined by this delimiter (in column order). Overrides InputFormat formatting.
#DesignerProperty: Key: TextAlign, DisplayName: Text Align, FieldType: String, DefaultValue: CENTER, List: CENTER|LEFT|RIGHT, Description: Horizontal alignment of column option text (vertical is always centered).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-lg, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius mode applied to the picker root panel.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level applied to the picker root panel.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
    
	' Ionic v8 API Parity Properties
	Private msMode As String = "md"
	Private mcFadeBackground As Int
	Private mcHighlightBackground As Int
	Private msHighlightVariant As String = ""
	Private mcActiveTextColor As Int = 0
	Private miHighlightRadius As Int
    
	' Compositional Architecture Data Structures
	Type PickerOption(Text As String, Value As Object, Disabled As Boolean)
	Type PickerColumn(Name As String, Options As List, sv As ScrollView, pnlInner As B4XView, Prefix As String, Suffix As String, Disabled As Boolean, CurrentIndex As Int, Color As Int, ActiveColor As Int, Role As String)
    
	Private mColumns As List
	Private mMapColumns As Map
    
	' Visual Overlays
	Private pnlHighlight As B4XView
	Private pnlTopFade As B4XView
	Private pnlBottomFade As B4XView
	Private pnlColumnsContainer As B4XView
    
	Private miItemHeight As Int
	Private miVisibleItems As Int = 5 ' Number of option rows visible at once (configurable via VisibleItems)
	Private msPickerType As String = "default"
	Private msInputFormat As String = "Y-m-d"
	Private msDisplayFormat As String = ""
	Private miMinYear As Int = 0
	Private miMaxYear As Int = 0
	Private msColumnDelimiter As String = ""
	Private msTextAlign As String = "CENTER"
	Private mScrollDebounce As Map

	' Appearance (Rounded + Shadow)
	Private msRounded As String = "rounded-lg"
	Private msShadow As String = "none"
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	mColumns.Initialize
	mMapColumns.Initialize
	mScrollDebounce.Initialize
    
	' Defaults (match #DesignerProperty DefaultValue) so runtime AddToParent without
	' explicit props renders correctly.
	msMode = "md"
	mcFadeBackground = 0xFFFFFFFF
	mcHighlightBackground = 0x1A000000
	miHighlightRadius = 8 ' dips (DipToCurrent applied at render)
	msPickerType = "default"
	msInputFormat = "Y-m-d"
	msDisplayFormat = ""
	miMinYear = 0
	miMaxYear = 0
	msColumnDelimiter = ""
	msTextAlign = "CENTER"
	msHighlightVariant = ""
	mcActiveTextColor = 0
	msRounded = "rounded-lg"
	msShadow = "none"
    
	miItemHeight = IIf(msMode = "ios", 34dip, 44dip)
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBase.Color = xui.Color_Transparent
    
'	msMode = Props.GetDefault("Mode", "md")
'	mcFadeBackground = xui.PaintOrColorToColor(Props.GetDefault("FadeBackground", 0xFFFFFFFF))
'	mcHighlightBackground = xui.PaintOrColorToColor(Props.GetDefault("HighlightBackground", 0x1A000000))
'	msHighlightVariant = Props.GetDefault("HighlightVariant", "")
'	mcActiveTextColor = Props.GetDefault("ActiveTextColor", 0)
'	miHighlightRadius = Props.GetDefault("HighlightRadius", 8) ' dips
'	miVisibleItems = Max(1, Props.GetDefault("VisibleItems", 5))
'	msPickerType = NormalizePickerType(Props.GetDefault("PickerType", "default"))
'	msInputFormat = Props.GetDefault("InputFormat", "Y-m-d")
'	msDisplayFormat = Props.GetDefault("DisplayFormat", "")
'	miMinYear = Props.GetDefault("MinYear", 0)
'	miMaxYear = Props.GetDefault("MaxYear", 0)
'	msColumnDelimiter = Props.GetDefault("ColumnDelimiter", "")
'	msTextAlign = Props.GetDefault("TextAlign", "CENTER")
'	msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", msRounded))
'	msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", msShadow))
	ApplyDesignerProps(mProps)
	If msHighlightVariant.Length > 0 And msHighlightVariant <> "none" Then
		mcHighlightBackground = B4XDaisyVariants.GetTokenColor("--color-" & msHighlightVariant, mcHighlightBackground)
	End If
    
	miItemHeight = IIf(msMode = "ios", 34dip, 44dip)
    
	BuildContainer
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	msMode = mProps.GetDefault("Mode", "md")
	mcFadeBackground = xui.PaintOrColorToColor(mProps.GetDefault("FadeBackground", 0xFFFFFFFF))
	mcHighlightBackground = xui.PaintOrColorToColor(mProps.GetDefault("HighlightBackground", 0x1A000000))
	msHighlightVariant = mProps.GetDefault("HighlightVariant", "")
	mcActiveTextColor = mProps.GetDefault("ActiveTextColor", 0)
	miHighlightRadius = mProps.GetDefault("HighlightRadius", 8) ' dips
	miVisibleItems = Max(1, mProps.GetDefault("VisibleItems", 5))
	msPickerType = NormalizePickerType(mProps.GetDefault("PickerType", "default"))
	msInputFormat = mProps.GetDefault("InputFormat", "Y-m-d")
	msDisplayFormat = mProps.GetDefault("DisplayFormat", "")
	miMinYear = mProps.GetDefault("MinYear", 0)
	miMaxYear = mProps.GetDefault("MaxYear", 0)
	msColumnDelimiter = mProps.GetDefault("ColumnDelimiter", "")
	msTextAlign = mProps.GetDefault("TextAlign", "CENTER")
	msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
	msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
End Sub

#Region Runtime API (AddToParent + property setters)
' Runtime creation - mirrors B4XDaisyModal/B4XDaisyButton AddToParent so demo pages
' can use: picker.Initialize(...) : picker.AddToParent(parent, l, t, w, h) instead of DesignerCreateView.
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
		DesignerCreateView(b, Null, BuildRuntimeProps)
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Refresh
	Return mBase
End Sub

' Packages the current theme/behaviour fields into a Props map so DesignerCreateView
' (called by AddToParent) re-applies them consistently.
Private Sub BuildRuntimeProps As Map
	Dim p As Map = CreateMap()
	p.Put("Mode", msMode)
	p.Put("FadeBackground", mcFadeBackground)
	p.Put("HighlightBackground", mcHighlightBackground)
	p.Put("HighlightVariant", msHighlightVariant)
	p.Put("ActiveTextColor", mcActiveTextColor)
	p.Put("HighlightRadius", miHighlightRadius)
	p.Put("VisibleItems", miVisibleItems)
	p.Put("PickerType", msPickerType)
	p.Put("InputFormat", msInputFormat)
	p.Put("DisplayFormat", msDisplayFormat)
	p.Put("MinYear", miMinYear)
	p.Put("MaxYear", miMaxYear)
	p.Put("ColumnDelimiter", msColumnDelimiter)
	p.Put("TextAlign", msTextAlign)
	p.Put("Rounded", msRounded)
	p.Put("Shadow", msShadow)
	Return p
End Sub

' Idiomatic property setters. Set BEFORE AddToParent for theming; safe to call after too
' (they rebuild the container when the picker is already on screen).
Public Sub setMode(sValue As String)
	msMode = sValue
	If mBase.IsInitialized Then
		miItemHeight = IIf(msMode = "ios", 34dip, 44dip)
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getMode As String
	Return msMode
End Sub

Public Sub setFadeBackground(iValue As Int)
	mcFadeBackground = xui.PaintOrColorToColor(iValue)
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getFadeBackground As Int
	Return mcFadeBackground
End Sub

Public Sub setHighlightBackground(iValue As Int)
	mcHighlightBackground = xui.PaintOrColorToColor(iValue)
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getHighlightBackground As Int
	Return mcHighlightBackground
End Sub

' DaisyUI variant (primary/secondary/accent/info/success/warning/error) for the selected-item
' highlight band. Resolves the variant to a color and overrides HighlightBackground. Pass "" or
' "none" to clear and revert to the configured HighlightBackground color.
Public Sub setHighlightVariant(sValue As String)
	msHighlightVariant = sValue.Trim.ToLowerCase
	If msHighlightVariant.Length > 0 And msHighlightVariant <> "none" Then
		mcHighlightBackground = B4XDaisyVariants.GetTokenColor("--color-" & msHighlightVariant, mcHighlightBackground)
	End If
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getHighlightVariant As String
	Return msHighlightVariant
End Sub

' Text color of the selected (centered) item across all columns. 0 = auto:
' when a HighlightVariant is set, the variant -content color is used (for contrast
' over the band); otherwise the normal column text color is used.
Public Sub setActiveTextColor(iValue As Int)
	mcActiveTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getActiveTextColor As Int
	Return mcActiveTextColor
End Sub

Public Sub setHighlightRadius(iValue As Int)
	miHighlightRadius = iValue ' dips
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getHighlightRadius As Int
	Return miHighlightRadius
End Sub

' Number of option rows visible at once. Odd values center cleanly on the middle item.
' Set BEFORE AddToParent for it to take effect on first render; safe to call after too
' (it rebuilds the container when the picker is already on screen).
Public Sub setVisibleItems(iValue As Int)
	miVisibleItems = Max(1, iValue)
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getVisibleItems As Int
	Return miVisibleItems
End Sub

' Natural render height needed to show VisibleItems rows without clipping.
' Use this (instead of a hardcoded dip value) when sizing the picker via AddToParent
' and when advancing the page layout cursor so the bottom row is never cut off.
Public Sub GetComputedHeight As Int
	Return miVisibleItems * miItemHeight
End Sub

' PickerType: 'default' = user-defined columns; 'auto' = columns auto-generated from
' InputFormat. Legacy 'date'/'time'/'date-time' values are accepted and treated as 'auto'
' (InputFormat decides the actual wheels). Set BEFORE AddToParent for auto columns to
' render on first draw.
Public Sub setPickerType(sValue As String)
	msPickerType = NormalizePickerType(sValue)
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getPickerType As String
	Return msPickerType
End Sub

' Normalizes the PickerType token: 'default' stays 'default'; everything else (including
' legacy 'date'/'time'/'date-time') maps to 'auto' so old projects/runtime code keep working.
Private Sub NormalizePickerType(sValue As String) As String
	If sValue = Null Then Return "default"
	Dim v As String = sValue.ToLowerCase.Trim
	If v = "default" Then Return "default"
	Return "auto"
End Sub

' Token format that defines the auto columns and the value returned by GetValue.
' Examples: "Y-m-d" (date), "H:i" (time 24h), "h:i K" (time 12h w/ AM-PM), "Y-m-d H:i" (date-time).
Public Sub setInputFormat(sValue As String)
	msInputFormat = sValue
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getInputFormat As String
	Return msInputFormat
End Sub

' Token format controlling how auto-generated wheels DISPLAY each value (independent of
' InputFormat, which controls the returned value). Empty = default per-role labels.
' Only affects PickerType='auto'.
Public Sub setDisplayFormat(sValue As String)
	msDisplayFormat = sValue
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getDisplayFormat As String
	Return msDisplayFormat
End Sub

' Year range for date/date-time pickers (0 = auto: current year -/+ 10).
Public Sub setMinYear(iValue As Int)
	miMinYear = iValue
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getMinYear As Int
	Return miMinYear
End Sub
Public Sub setMaxYear(iValue As Int)
	miMaxYear = iValue
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getMaxYear As Int
	Return miMaxYear
End Sub

' Column delimiter used by GetValue to join column values (in column order). When non-empty
' it overrides InputFormat formatting and works for 'default' type pickers too.
Public Sub setColumnDelimiter(sValue As String)
	msColumnDelimiter = sValue
End Sub
Public Sub getColumnDelimiter As String
	Return msColumnDelimiter
End Sub

' Horizontal alignment of column option text: CENTER (default), LEFT or RIGHT.
Public Sub setTextAlign(sValue As String)
	Dim v As String = sValue.ToUpperCase
	If v = "CENTER" Or v = "LEFT" Or v = "RIGHT" Then msTextAlign = v
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getTextAlign As String
	Return msTextAlign
End Sub

'DaisyUI rounded token (theme|rounded-none|...|rounded-full) applied to the picker root panel.
'Set BEFORE AddToParent for it to take effect on first render; safe to call after too
'(it rebuilds the container so the corner radius + clip are re-applied).
Public Sub setRounded(sValue As String)
	msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getRounded As String
	Return msRounded
End Sub

'Elevation shadow level (none|xs|sm|md|lg|xl|2xl) applied to the picker root panel.
'Set BEFORE AddToParent for it to take effect on first render; safe to call after too.
Public Sub setShadow(sValue As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized Then
		BuildContainer
		Refresh
	End If
End Sub
Public Sub getShadow As String
	Return msShadow
End Sub

'Resolved corner radius (dips) for the current Rounded token. Useful when a caller wants
'to paint a matching background via SetColorAndBorder after AddToParent without hardcoding
'the dip value for the chosen rounded token.
Public Sub GetRoundedRadius As Float
	Return B4XDaisyVariants.ResolveRoundedDip(msRounded, 8dip)
End Sub

' Applies a background color and rounded border directly to the picker's root panel (mBase)
' so callers don't need to touch mBase. Call after AddToParent. Persists across theme rebuilds
' (BuildContainer does not reset the root background).
Public Sub SetColorAndBorder(iColor As Int, fBorderWidth As Float, iBorderColor As Int, fCornerRadius As Float)
	If mBase.IsInitialized Then mBase.SetColorAndBorder(iColor, fBorderWidth, iBorderColor, fCornerRadius)
End Sub
#End Region

#Region API Methods (v8 Component Structure)
' Maps to ion-picker-column and its slots (prefix/suffix)
Public Sub AddColumn(sColumnName As String, sPrefix As String, sSuffix As String, bDisabled As Boolean)
	Dim col As PickerColumn
	col.Initialize
	col.Name = sColumnName
	col.Options.Initialize
	col.Prefix = sPrefix
	col.Suffix = sSuffix
	col.Disabled = bDisabled
	col.CurrentIndex = 0
    
	mColumns.Add(col)
	mMapColumns.Put(sColumnName, col)
End Sub

' Convenience date column builders. Each adds a column tagged with a flatpickr role
' and populates it with options whose VALUE is numeric and whose DISPLAY text follows
' DisplayFormat (falling back to the default per-role label). Combined with InputFormat
' (value) and DisplayFormat (display), GetValue/GetDisplayValue/SetValue work the
' flatpickr way without any external loops.

' Adds a Day column (1-31). Value = day number; label via the DisplayFormat day token.
Public Sub AddColumnDay(sColumnName As String)
	AddColumn(sColumnName, "", "", False)
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	col.Role = "day"
	Dim now As Long = DateTime.Now
	For d = 1 To 31
		AddOption(sColumnName, DisplayLabel("day", d), d)
	Next
	SetColumnCurrentIndex(sColumnName, DateTime.GetDayOfMonth(now) - 1)
End Sub

' Adds a Month column (1-12). Value = month number; label via the DisplayFormat month
' token (M -> Jan, m -> 01, F -> January).
Public Sub AddColumnMonth(sColumnName As String)
	AddColumn(sColumnName, "", "", False)
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	col.Role = "month"
	Dim now As Long = DateTime.Now
	For m = 1 To 12
		AddOption(sColumnName, DisplayLabel("month", m), m)
	Next
	SetColumnCurrentIndex(sColumnName, DateTime.GetMonth(now) - 1)
End Sub

' Adds a Year column (StartYear..EndYear). Value = year number; label via the DisplayFormat
' year token (Y -> 2027, y -> 27).
Public Sub AddColumnYear(sColumnName As String, iStartYear As Int, iEndYear As Int)
	AddColumn(sColumnName, "", "", False)
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	col.Role = "year"
	Dim now As Long = DateTime.Now
	For yr = iStartYear To iEndYear
		AddOption(sColumnName, DisplayLabel("year", yr), yr)
	Next
	SetColumnCurrentIndex(sColumnName, DateTime.GetYear(now) - iStartYear)
End Sub

' Maps to ion-picker-column-option. Options are added enabled; use SetOptionDisabled
' to disable an individual option after it has been added.
Public Sub AddOption(sColumnName As String, sText As String, oValue As Object)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
    
	Dim opt As PickerOption
	opt.Initialize
	opt.Text = sText
	opt.Value = oValue
    
	col.Options.Add(opt)
End Sub

' True when at least one column has a flatpickr role tag (AddColumnDay/Month/Year).
' Used to decide whether GetValue/GetDisplayValue/SetValue may use InputFormat/DisplayFormat
' for a 'default'-type picker (auto pickers always can).
Private Sub HasRoleColumns As Boolean
	For Each col As PickerColumn In mColumns
		If col.Role.Length > 0 Then Return True
	Next
	Return False
End Sub

' Current value (Object) of the column matching a role. Searches by Role tag first
' (AddColumnDay/Month/Year on a default picker), then falls back to a column named
' exactly the role (auto-generated columns are named by role). Null if not found.
Private Sub GetColumnValueByRole(sRole As String) As Object
	For Each col As PickerColumn In mColumns
		If col.Role = sRole Then
			If col.Options.Size > 0 Then
				Dim opt As PickerOption = col.Options.Get(col.CurrentIndex)
				Return opt.Value
			End If
			Return Null
		End If
	Next
	If mMapColumns.ContainsKey(sRole) Then
		Dim col As PickerColumn = mMapColumns.Get(sRole)
		If col.Options.Size > 0 Then
			Dim opt2 As PickerOption = col.Options.Get(col.CurrentIndex)
			Return opt2.Value
		End If
	End If
	Return Null
End Sub

' Matches Value against a role's column options and scrolls to it. Numeric-aware
' (so "07" matches option value 7). No-op if the role/value is not found.
Private Sub SetColumnValueByRole(sRole As String, oValue As Object)
	Dim col As PickerColumn
	Dim found As Boolean
	For Each c As PickerColumn In mColumns
		If c.Role = sRole Then
			col = c
			found = True
			Exit
		End If
	Next
	If found = False And mMapColumns.ContainsKey(sRole) Then
		col = mMapColumns.Get(sRole)
		found = True
	End If
	If found = False Then Return
	Dim target As String = "" & oValue
	For i = 0 To col.Options.Size - 1
		Dim opt As PickerOption = col.Options.Get(i)
		If ValuesEqual(opt.Value, target) Then
			ScrollToActiveItem(col, i, True)
			Return
		End If
	Next
End Sub

' Parses a value string using a flatpickr-style format: splits on the format's literal
' separators and maps each non-empty part to a token's role, then sets that role's
' column. Returns True if at least one role was set.
Private Sub SetValuesByFormat(sValue As String, sFmt As String) As Boolean
	' Sequential parser (no regex): walk format segments, consume literals, and capture
	' each token's substring up to the next literal. Maps each token to its role and sets it.
	Dim segs As List = ParseFormat(sFmt)
	Dim pos As Int = 0
	Dim setCount As Int = 0
	For si = 0 To segs.Size - 1
		Dim seg As Map = segs.Get(si)
		If seg.Get("type") = "literal" Then
			Dim lit As String = seg.Get("value")
			If lit.Length > 0 And pos + lit.Length <= sValue.Length Then
				If sValue.SubString2(pos, pos + lit.Length) = lit Then pos = pos + lit.Length
			End If
		Else
			Dim tok As String = seg.Get("value")
			Dim role As String = RoleForToken(tok)
			Dim endPos As Int = sValue.Length
			For sj = si + 1 To segs.Size - 1
				Dim seg2 As Map = segs.Get(sj)
				If seg2.Get("type") = "literal" Then
					Dim lit2 As String = seg2.Get("value")
					If lit2.Length > 0 Then
						Dim foundAt As Int = sValue.IndexOf2(lit2, pos)
						If foundAt >= 0 Then endPos = foundAt
					End If
					Exit
				End If
			Next
			If endPos < pos Then endPos = pos
			Dim part As String = sValue.SubString2(pos, endPos)
			If part.Length > 0 Then
				SetColumnValueByRole(role, part)
				setCount = setCount + 1
			End If
			pos = endPos
		End If
	Next
	Return setCount > 0
End Sub

' Numeric-aware equality: "07" matches 7, "2026" matches 2026; "dog" only matches "dog".
Private Sub ValuesEqual(oA As Object, oB As Object) As Boolean
	Dim sa As String = "" & oA
	Dim sb As String = "" & oB
	If sa = sb Then Return True
	If IsNumber(sa) And IsNumber(sb) Then Return (sa * 1) = (sb * 1)
	Return False
End Sub

' Programmatic selection matching the v8 column setValue() internal method
Public Sub SetColumnValue(sColumnName As String, oValue As Object)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
    
	For i = 0 To col.Options.Size - 1
		Dim opt As PickerOption = col.Options.Get(i)
		If ValuesEqual(opt.Value, oValue) Then
			ScrollToActiveItem(col, i, True)
			Return
		End If
	Next
End Sub

' Enable/disable an individual option identified by its Value (matches the option whose
' opt.Value equals the supplied value). The option's label is greyed/ungreyed immediately.
' Pass Disabled=True to disable, False to re-enable.
Public Sub SetOptionDisabled(sColumnName As String, oValue As Object, bDisabled As Boolean)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	For i = 0 To col.Options.Size - 1
		Dim opt As PickerOption = col.Options.Get(i)
		If ValuesEqual(opt.Value, oValue) Then
			opt.Disabled = bDisabled
			If mBase.IsInitialized Then ApplyColumnColors(col)
			Return
		End If
	Next
End Sub

' Same as SetOptionDisabled but identifies the option by its zero-based index in the column.
Public Sub SetOptionDisabledByIndex(sColumnName As String, iIndex As Int, bDisabled As Boolean)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	If iIndex < 0 Or iIndex >= col.Options.Size Then Return
	Dim opt As PickerOption = col.Options.Get(iIndex)
	opt.Disabled = bDisabled
	If mBase.IsInitialized Then ApplyColumnColors(col)
End Sub

Public Sub GetColumnValue(sColumnName As String) As Object
	If mMapColumns.ContainsKey(sColumnName) = False Then Return Null
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	If col.Options.Size = 0 Then Return Null
	Dim opt As PickerOption = col.Options.Get(col.CurrentIndex)
	Return opt.Value
End Sub

' Returns the option values of a column (in option order). Handy for building random
' selections or validating against the picker's own values.
Public Sub GetColumnOptionValues(sColumnName As String) As List
	Dim empty As List
	empty.Initialize
	If mMapColumns.ContainsKey(sColumnName) = False Then Return empty
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	Dim out As List
	out.Initialize
	For i = 0 To col.Options.Size - 1
		Dim opt As PickerOption = col.Options.Get(i)
		out.Add(opt.Value)
	Next
	Return out
End Sub

Public Sub SetColumnColor(sColumnName As String, iColor As Int)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	col.Color = iColor
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub GetColumnColor(sColumnName As String) As Int
	If mMapColumns.ContainsKey(sColumnName) = False Then Return 0
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	Return col.Color
End Sub

' Apply a DaisyUI variant (primary/secondary/accent/info/success/warning/error) as the column's option text color.
' Pass "" or "none" to clear and revert to the default content color.
Public Sub SetColumnColorVariant(sColumnName As String, sVariant As String)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	Dim v As String = sVariant.Trim.ToLowerCase
	If v.Length = 0 Or v = "none" Then
		col.Color = 0
	Else
		col.Color = B4XDaisyVariants.GetTokenColor("--color-" & v, 0)
	End If
	If mBase.IsInitialized Then Refresh
End Sub

' Enable/disable a column. A disabled column greys out its options and ignores scroll-snap/tap selection.
Public Sub SetColumnEnabled(sColumnName As String, bEnabled As Boolean)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	col.Disabled = Not(bEnabled)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub GetColumnEnabled(sColumnName As String) As Boolean
	If mMapColumns.ContainsKey(sColumnName) = False Then Return False
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	Return Not(col.Disabled)
End Sub

' Per-column override for the selected item text color. 0 = fall back to the global
' ActiveTextColor / HighlightVariant -content / normal column text color.
Public Sub SetColumnActiveTextColor(sColumnName As String, iColor As Int)
	If mMapColumns.ContainsKey(sColumnName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	col.ActiveColor = iColor
	If mBase.IsInitialized Then ApplyColumnColors(col)
End Sub
Public Sub GetColumnActiveTextColor(sColumnName As String) As Int
	If mMapColumns.ContainsKey(sColumnName) = False Then Return 0
	Dim col As PickerColumn = mMapColumns.Get(sColumnName)
	Return col.ActiveColor
End Sub

' Emulates the column's internal native scroll settling behavior
Private Sub ScrollToActiveItem(Col As PickerColumn, iIndex As Int, bSmooth As Boolean)
	Col.CurrentIndex = iIndex
	ApplyColumnColors(Col)
	Dim targetY As Int = iIndex * miItemHeight
	If bSmooth Then
		' Assuming easeOutCubic is available from your B4XDaisyMath module
		AnimateScroll(Col.sv, targetY, 250)
	Else
		Col.sv.ScrollPosition = targetY
	End If
    
	' Emit ionChange equivalent
	If xui.SubExists(mCallBack, mEventName & "_Changed", 2) Then
		CallSub3(mCallBack, mEventName & "_Changed", Col.Name, GetColumnValue(Col.Name))
	End If
End Sub
#End Region

#Region Rendering & Physics
' Reorders role-tagged columns (AddColumnDay/Month/Year) to follow DisplayFormat's
' token order, so the wheels display in the DisplayFormat order (e.g. d M Y -> Day, Month,
' Year). Columns whose role is not in DisplayFormat, and non-role columns, keep their
' relative order at the end. No-op for auto pickers or pickers without role columns.
Private Sub ReorderColumnsByDisplayFormat
	If msPickerType <> "default" Then Return
	If msDisplayFormat.Length = 0 Then Return
	If HasRoleColumns = False Then Return
	Dim order As List
	order.Initialize
	Dim segs As List = ParseFormat(msDisplayFormat)
	For Each seg As Map In segs
	If seg.Get("type") = "token" Then
	Dim role As String = RoleForToken(seg.Get("value"))
	If role.Length > 0 And order.IndexOf(role) = -1 Then order.Add(role)
	End If
	Next
	If order.Size = 0 Then Return
	Dim reordered As List
	reordered.Initialize
	For Each role As String In order
	For Each col As PickerColumn In mColumns
	If col.Role = role Then reordered.Add(col)
	Next
	Next
	For Each col As PickerColumn In mColumns
	If order.IndexOf(col.Role) = -1 Then reordered.Add(col)
	Next
	If reordered.Size = mColumns.Size Then mColumns = reordered
End Sub

Public Sub Refresh
	' PickerType='auto' regenerates its columns from InputFormat on every refresh so
	' the wheel always matches the configured format (date/time/date-time/12h...).
	If msPickerType <> "default" Then RebuildAutoColumns
	' For default pickers built with AddColumnDay/Month/Year, order the wheels to match
	' DisplayFormat (e.g. d M Y -> Day, Month, Year). No-op for auto or non-role pickers.
	ReorderColumnsByDisplayFormat
	pnlColumnsContainer.RemoveAllViews
    
	Dim colWidth As Int = mBase.Width / Max(1, mColumns.Size)
	Dim currentX As Int = 0
    
	For Each col As PickerColumn In mColumns
		Dim pnlColWrapper As B4XView = xui.CreatePanel("")
		pnlColumnsContainer.AddView(pnlColWrapper, currentX, 0, colWidth, mBase.Height)
        
		' Prefix/Suffix slot layout: reserve a slot on each side that has a prefix/suffix
		' so the scrollable wheel sits cleanly between them with edge padding (no overlap).
		Dim hasPref As Boolean = col.Prefix <> ""
		Dim hasSuff As Boolean = col.Suffix <> ""
		Dim slotW As Int = colWidth / 3
		Dim edgePad As Int = 16dip ' outer padding nudge: prefix in from left, suffix in from right
		Dim wheelLeft As Int = IIf(hasPref, slotW, 0)
		Dim wheelW As Int = colWidth - IIf(hasPref, slotW, 0) - IIf(hasSuff, slotW, 0)
		Dim rowY As Int = (mBase.Height / 2) - (miItemHeight / 2)
		
		' Render Prefix (Slot) - left aligned, padded from the left edge
		If hasPref Then
			Dim lblPref As Label : lblPref.Initialize("")
			Dim xlblPref As B4XView = lblPref
			xlblPref.Text = col.Prefix
			xlblPref.SetTextAlignment("CENTER", "LEFT")
			pnlColWrapper.AddView(xlblPref, edgePad, rowY, slotW - edgePad, miItemHeight)
		End If
		
		' Initialize ScrollView to map to CSS Scroll Snapping mechanics
		Dim sv As ScrollView
		sv.Initialize2(col.Options.Size * miItemHeight + (mBase.Height - miItemHeight), "SV")
		Dim xsv As B4XView = sv
		col.sv = sv
		col.pnlInner = sv.Panel
		xsv.Tag = col
		#If B4A
		' Attach a touch listener so an enclosing page ScrollView cannot intercept
		' vertical drags on this column (same fix used by B4XDaisySelect). Without it
		' scrolling the picker column scrolls the underlying page instead.
		Try
			Dim joSV As JavaObject = xsv
			joSV.RunMethod("setOnTouchListener", Array(joSV.CreateEvent("android.view.View$OnTouchListener", "ColSVTouch", False)))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPicker.Refresh: " & LastException.Message)
		End Try
		#End If
		pnlColWrapper.AddView(xsv, wheelLeft, 0, wheelW, mBase.Height)
        
		' Render Options
		Dim yOffset As Int = (mBase.Height / 2) - (miItemHeight / 2) ' Start padding to align first item to center
		' Per-column color: a column color (variant) tints its option text; a disabled column greys out.
		Dim colTextColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
		If col.Color <> 0 Then colTextColor = col.Color
		If col.Disabled Then colTextColor = xui.Color_Gray
		For i = 0 To col.Options.Size - 1
			Dim opt As PickerOption = col.Options.Get(i)
			Dim lblOpt As Label : lblOpt.Initialize("PickerOpt")
			Dim xlblOpt As B4XView = lblOpt
			xlblOpt.Text = opt.Text
			xlblOpt.TextColor = IIf(opt.Disabled, xui.Color_Gray, colTextColor)
			xlblOpt.TextSize = IIf(msMode = "ios", 20, 16)
			xlblOpt.SetTextAlignment("CENTER", msTextAlign)
			xlblOpt.Tag = CreateMap("col": col.Name, "index": i)
			#If B4A
			' Attach the same scroll-interception listener to the (clickable) option label so
			' ACTION_DOWN/MOVE on it still tells ancestors OUTSIDE the picker not to intercept.
			' Without this, making labels clickable lets the page ScrollView steal the drag because
			' the column ScrollView's own listener never receives the consumed ACTION_DOWN.
			Try
						Dim joLbl As JavaObject = xlblOpt
						joLbl.RunMethod("setOnTouchListener", Array(joLbl.CreateEvent("android.view.View$OnTouchListener", "ColSVTouch", False)))
			Catch
						If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPicker.Refresh: " & LastException.Message)
			End Try
			#End If
			col.pnlInner.AddView(xlblOpt, 0, yOffset + (i * miItemHeight), wheelW, miItemHeight)
		Next
		
		' Snap to the column's CurrentIndex (e.g. today/now for auto columns)
		' without animating or firing change events on initial render.
		If col.CurrentIndex > 0 Then
			Try
				col.sv.ScrollPosition = col.CurrentIndex * miItemHeight
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPicker.Refresh: " & LastException.Message)
			End Try
		End If
		ApplyColumnColors(col)
		
		' Render Suffix (Slot) - right aligned, padded from the right edge
		If hasSuff Then
			Dim lblSuff As Label : lblSuff.Initialize("")
			Dim xlblSuff As B4XView = lblSuff
			xlblSuff.Text = col.Suffix
			xlblSuff.SetTextAlignment("CENTER", "RIGHT")
			pnlColWrapper.AddView(xlblSuff, colWidth - slotW, rowY, slotW - edgePad, miItemHeight)
		End If
		
		currentX = currentX + colWidth
	Next
End Sub

' Resolves the text color for the active (centered) item of a column.
' Priority: per-column ActiveColor > global ActiveTextColor > HighlightVariant -content > 0 (normal).
Private Sub ResolveActiveColor(Col As PickerColumn) As Int
	If Col.ActiveColor <> 0 Then Return Col.ActiveColor
	If mcActiveTextColor <> 0 Then Return mcActiveTextColor
	If msHighlightVariant.Length > 0 And msHighlightVariant <> "none" Then
		Return B4XDaisyVariants.GetTokenColor("--color-" & msHighlightVariant & "-content", xui.Color_White)
	End If
	Return 0
End Sub

' Recolors a column option labels: the active (CurrentIndex) item uses the active
' color when one is resolved; others use the normal column text color. Disabled
' options/columns stay grey.
Private Sub ApplyColumnColors(Col As PickerColumn)
	If Col.pnlInner.IsInitialized = False Then Return
	If Col.Options.Size = 0 Then Return
	Dim colTextColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
	If Col.Color <> 0 Then colTextColor = Col.Color
	If Col.Disabled Then colTextColor = xui.Color_Gray
	Dim activeColor As Int = ResolveActiveColor(Col)
	For i = 0 To Col.Options.Size - 1
		Dim lbl As B4XView = Col.pnlInner.GetView(i)
		Dim opt As PickerOption = Col.Options.Get(i)
		Dim c As Int = colTextColor
		If opt.Disabled Then
			c = xui.Color_Gray
		Else If i = Col.CurrentIndex And activeColor <> 0 Then
			c = activeColor
		End If
		lbl.TextColor = c
	Next
End Sub

Private Sub BuildContainer
	' Idempotent: clear any previous overlays so BuildContainer is safe to re-run
	' (e.g. when a theme property setter is called after AddToParent).
	mBase.RemoveAllViews
    
	' Center Highlight Bar (--highlight-background)
	pnlHighlight = xui.CreatePanel("")
	pnlHighlight.SetColorAndBorder(mcHighlightBackground, 0, 0, DipToCurrent(miHighlightRadius))
	mBase.AddView(pnlHighlight, 8dip, (mBase.Height / 2) - (miItemHeight / 2), mBase.Width - 16dip, miItemHeight)
    
	pnlColumnsContainer = xui.CreatePanel("")
	mBase.AddView(pnlColumnsContainer, 0, 0, mBase.Width, mBase.Height)
    
	' Top & Bottom Gradient Fades (--fade-background-rgb)
	pnlTopFade = xui.CreatePanel("")
	pnlBottomFade = xui.CreatePanel("")
	mBase.AddView(pnlTopFade, 0, 0, mBase.Width, (mBase.Height / 2) - (miItemHeight / 2))
	mBase.AddView(pnlBottomFade, 0, (mBase.Height / 2) + (miItemHeight / 2), mBase.Width, (mBase.Height / 2) - (miItemHeight / 2))
    
	' Apply gradients mapping to RGB variables
	' NOTE: B4XView has no .Background member; build the GradientDrawable via JavaObject
	' (proven pattern from B4XDaisyStatus/B4XDaisyDivision) and apply with setBackground.
	Dim topGradient(2) As Int = Array As Int(mcFadeBackground, xui.Color_Transparent)
	Dim gdOrient As JavaObject
	gdOrient.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
	Dim topGd As JavaObject
	topGd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	topGd.RunMethod("setOrientation", Array(gdOrient.GetField("TOP_BOTTOM")))
	topGd.RunMethod("setColors", Array(topGradient))
	Dim joTop As JavaObject = pnlTopFade
	joTop.RunMethod("setBackground", Array(topGd))
    
	Dim bottomGradient(2) As Int = Array As Int(xui.Color_Transparent, mcFadeBackground)
	Dim botGd As JavaObject
	botGd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	botGd.RunMethod("setOrientation", Array(gdOrient.GetField("TOP_BOTTOM")))
	botGd.RunMethod("setColors", Array(bottomGradient))
	Dim joBot As JavaObject = pnlBottomFade
	joBot.RunMethod("setBackground", Array(botGd))
    
	' Pass touches through to the ScrollView beneath WITHOUT clobbering the gradient
	' (setting .Color would overwrite the GradientDrawable Background set above)
	pnlTopFade.Enabled = False
	pnlBottomFade.Enabled = False
    
	ApplyAppearance
End Sub

'Applies the Rounded (corner radius) and Shadow (elevation) appearance tokens to the picker
'root panel (mBase). Called from BuildContainer so the look persists across theme rebuilds.
'A caller's later SetColorAndBorder can still override the radius/background; elevation is a
'separate View property and is preserved.
Private Sub ApplyAppearance
	Dim radius As Float = B4XDaisyVariants.ResolveRoundedDip(msRounded, 8dip)
	'Preserve the current root background color while applying the resolved corner radius.
	mBase.SetColorAndBorder(mBase.Color, 0, 0, radius)
	'Clip overlay children (highlight + fades) to the rounded outline.
	B4XDaisyVariants.SetOverflowHidden(mBase)
	'Elevation shadow (Tailwind/Daisy scale) - needs a background drawable to cast.
	B4XDaisyVariants.ApplyElevation(mBase, msShadow)
End Sub

Private Sub SV_ScrollChanged(iPosition As Int)
	Dim xsv As B4XView = Sender
	Dim col As PickerColumn = xsv.Tag
	If col.Disabled Then Return
    
	' Emulate CSS Scroll Snapping settlement logic
	mScrollDebounce.Put(col.Name, DateTime.Now)
	Sleep(150)
	If mScrollDebounce.Get(col.Name) > DateTime.Now - 150 Then Return ' Still scrolling
    
	' Momentum settled, snap to nearest element
	Dim targetIndex As Int = Round(iPosition / miItemHeight)
	targetIndex = Max(0, Min(targetIndex, col.Options.Size - 1))
    
	If targetIndex <> col.CurrentIndex Then
		ScrollToActiveItem(col, targetIndex, True)
	End If
End Sub

Private Sub AnimateScroll(sv As ScrollView, iTargetY As Int, iDuration As Int)
	Dim startY As Float = sv.ScrollPosition
	Dim change As Float = iTargetY - startY
	Dim startTime As Long = DateTime.Now
    
	Do While DateTime.Now - startTime < iDuration
		Dim elapsed As Float = DateTime.Now - startTime
		sv.ScrollPosition = easeOutCubic(elapsed, startY, change, iDuration)
		Sleep(0)
	Loop
	sv.ScrollPosition = iTargetY
End Sub

Private Sub easeOutCubic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime = fTime / iDuration
	fTime = fTime - 1
	Return fChangeInValue * (fTime * fTime * fTime + 1) + fStart
End Sub
#End Region

#Region Auto Columns (InputFormat-driven)
' When PickerType <> "default" the columns are auto-generated from InputFormat instead
' of being added manually. The same token walk drives both column generation and the
' formatted value returned by GetValue.
'
' InputFormat uses flatpickr-style single-character tokens (see https://flatpickr.js.org/formatting):
'   YEAR:    Y = 4-digit (2026)       y = 2-digit (26)
'   MONTH:   m = 2-digit (07)         n = no leading zero (7)
'            M = short name (Jul)     F = full name (July)
'   DAY:     d = 2-digit (01)         j = no leading zero (1)
'   HOUR:    H = 24h, 2-digit (14)    G = 24h, no leading zero (14)
'            h = 12h, 2-digit (02)    g = 12h, no leading zero (2)
'   MINUTE:  i = 2-digit (30)
'   SECOND:  s = 2-digit (00)
'   AM/PM:   K = uppercase (PM)      a = lowercase (pm)   -> adds an AM/PM wheel
'   LITERAL: wrap text in [..] to pass it through verbatim, e.g. [T] -> T
' Any other character is a literal separator and is preserved in the GetValue output.
'
' Examples:
'   date       "Y-m-d"      -> 2026-07-03   (wheels: year, month, day)
'   time 24h   "H:i"        -> 14:30        (wheels: hour, minute)
'   time 12h   "h:i K"      -> 02:30 PM     (wheels: hour12, minute, ampm)
'   date-time  "Y-m-d H:i"  -> 2026-07-03 14:30
' Each unique role produces one wheel. The month wheel always shows short names while
' the output token decides numeric vs name; day options always show 2 digits.
Private Sub RebuildAutoColumns
	mColumns.Initialize
	mMapColumns.Initialize
	Dim fmt As String = msInputFormat
	If fmt.Length = 0 Then fmt = DefaultFormatForType(msPickerType)
	' One wheel per unique role encountered in the format (flatpickr tokens).
	Dim segs As List = ParseFormat(fmt)
	For Each seg As Map In segs
		If seg.Get("type") = "token" Then
			Dim role As String = RoleForToken(seg.Get("value"))
			If role.Length > 0 And mMapColumns.ContainsKey(role) = False Then
				BuildColumnForRole(role)
			End If
		End If
	Next
End Sub

' Parses a flatpickr-style format string into ordered segments. Each segment is a Map:
'   type="token"   value=<single char token>   e.g. d, m, Y, H, i, K
'   type="literal" value=<text>                separator or [..] escaped literal text
Private Sub ParseFormat(sFmt As String) As List
	Dim segs As List
	segs.Initialize
	Dim pos As Int = 0
	Do While pos < sFmt.Length
		Dim ch As String = sFmt.SubString2(pos, pos + 1)
		If ch = "[" Then
			' Literal escape: copy text up to the closing ] verbatim.
			Dim closePos As Int = sFmt.IndexOf2("]", pos + 1)
			If closePos < 0 Then closePos = sFmt.Length
			segs.Add(CreateMap("type": "literal", "value": sFmt.SubString2(pos + 1, closePos)))
			pos = closePos + 1
		Else If IsFormatToken(ch) Then
			segs.Add(CreateMap("type": "token", "value": ch))
			pos = pos + 1
		Else
			segs.Add(CreateMap("type": "literal", "value": ch))
			pos = pos + 1
		End If
	Loop
	Return segs
End Sub

Private Sub IsFormatToken(sCh As String) As Boolean
	Select Case sCh
		Case "Y","y","m","n","M","F","d","j","H","G","h","g","i","s","K","a"
			Return True
	End Select
	Return False
End Sub

' Maps a flatpickr token to the internal column role it drives.
Private Sub RoleForToken(sToken As String) As String
	Select Case sToken
		Case "Y", "y"
			Return "year"
		Case "m", "n", "M", "F"
			Return "month"
		Case "d", "j"
			Return "day"
		Case "H", "G"
			Return "hour"
		Case "h", "g"
			Return "hour12"
		Case "i"
			Return "minute"
		Case "s"
			Return "second"
		Case "K", "a"
			Return "ampm"
	End Select
	Return ""
End Sub

' Resolves the display label for an auto-generated wheel option. When DisplayFormat
' is configured, the first token in it that maps to the role is used (so e.g. DisplayFormat="F"
' shows full month names). Otherwise the per-role default token is used, reproducing the
' original labels (short month, 2-digit day, 4-digit year, ...). Only the token style is
' applied; this does not add/remove wheels (those are still driven by InputFormat).
Private Sub DisplayLabel(sRole As String, oValue As Object) As String
	Return FormatToken(DisplayTokenForRole(sRole), oValue)
End Sub

' Returns the flatpickr token used to label a role on its wheel.
Private Sub DisplayTokenForRole(sRole As String) As String
	If msDisplayFormat.Length > 0 Then
		Dim segs As List = ParseFormat(msDisplayFormat)
		For Each seg As Map In segs
			If seg.Get("type") = "token" Then
				If RoleForToken(seg.Get("value")) = sRole Then Return seg.Get("value")
			End If
		Next
	End If
	' Defaults reproduce the original per-role labels.
	Select Case sRole
		Case "year": Return "Y"
		Case "month": Return "M"
		Case "day": Return "d"
		Case "hour": Return "H"
		Case "hour12": Return "h"
		Case "minute": Return "i"
		Case "second": Return "s"
		Case "ampm": Return "K"
	End Select
	Return ""
End Sub

Private Sub BuildColumnForRole(sRole As String)
	Dim now As Long = DateTime.Now
	Select Case sRole
		Case "year"
			Dim minY As Int = ResolveMinYear
			Dim maxY As Int = ResolveMaxYear
			AddColumn("year", "", "", False)
			For y = minY To maxY
				AddOption("year", DisplayLabel("year", y), y)
			Next
			SetColumnCurrentIndex("year", DateTime.GetYear(now) - minY)
		Case "month"
			AddColumn("month", "", "", False)
			For m = 1 To 12
				AddOption("month", DisplayLabel("month", m), m)
			Next
			SetColumnCurrentIndex("month", DateTime.GetMonth(now) - 1)
		Case "day"
			AddColumn("day", "", "", False)
			For d = 1 To 31
				AddOption("day", DisplayLabel("day", d), d)
			Next
			SetColumnCurrentIndex("day", DateTime.GetDayOfMonth(now) - 1)
		Case "hour"
			AddColumn("hour", "", "", False)
			For h = 0 To 23
				AddOption("hour", DisplayLabel("hour", h), h)
			Next
			SetColumnCurrentIndex("hour", DateTime.GetHour(now))
		Case "hour12"
			AddColumn("hour12", "", "", False)
			For h = 1 To 12
				AddOption("hour12", DisplayLabel("hour12", h), h)
			Next
			Dim curH As Int = DateTime.GetHour(now)
			Dim h12 As Int = curH Mod 12
			If h12 = 0 Then h12 = 12
			SetColumnCurrentIndex("hour12", h12 - 1)
		Case "minute"
			AddColumn("minute", "", "", False)
			For mm = 0 To 59
				AddOption("minute", DisplayLabel("minute", mm), mm)
			Next
			SetColumnCurrentIndex("minute", DateTime.GetMinute(now))
		Case "second"
			AddColumn("second", "", "", False)
			For s = 0 To 59
				AddOption("second", DisplayLabel("second", s), s)
			Next
			SetColumnCurrentIndex("second", DateTime.GetSecond(now))
		Case "ampm"
			AddColumn("ampm", "", "", False)
			AddOption("ampm", DisplayLabel("ampm", "AM"), "AM")
			AddOption("ampm", DisplayLabel("ampm", "PM"), "PM")
			SetColumnCurrentIndex("ampm", IIf(DateTime.GetHour(now) >= 12, 1, 0))
	End Select
End Sub

Private Sub SetColumnCurrentIndex(sName As String, iIndex As Int)
	If mMapColumns.ContainsKey(sName) = False Then Return
	Dim col As PickerColumn = mMapColumns.Get(sName)
	If col.Options.Size = 0 Then Return
	col.CurrentIndex = Max(0, Min(iIndex, col.Options.Size - 1))
End Sub

Private Sub ResolveMinYear As Int
	If miMinYear > 0 Then Return miMinYear
	Return DateTime.GetYear(DateTime.Now) - 10
End Sub

Private Sub ResolveMaxYear As Int
	If miMaxYear > 0 Then Return miMaxYear
	Return DateTime.GetYear(DateTime.Now) + 10
End Sub

Private Sub MonthAbbr(iM As Int) As String
	Dim names() As String = Array As String("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	If iM >= 1 And iM <= 12 Then Return names(iM - 1)
	Return "" & iM
End Sub

Private Sub MonthFull(iM As Int) As String
	Dim names() As String = Array As String("January","February","March","April","May","June","July","August","September","October","November","December")
	If iM >= 1 And iM <= 12 Then Return names(iM - 1)
	Return "" & iM
End Sub

Private Sub Pad2(iN As Int) As String
	Return NumberFormat2(iN, 2, 0, 0, False)
End Sub

Private Sub Pad4(iN As Int) As String
	Return NumberFormat2(iN, 4, 0, 0, False)
End Sub

Private Sub ToInt(oValue As Object) As Int
	Dim n As Int = oValue
	Return n
End Sub

' Fallback format used when PickerType='auto' and InputFormat is empty. Only 'auto'
' reaches here ('default' short-circuits in Refresh/GetValue), so a date format is the
' sensible default.
Private Sub DefaultFormatForType(sTyp As String) As String
	Return "Y-m-d"
End Sub

' Programmatic multi-column setter, symmetric with GetValue for 'default' type pickers.
' When a ColumnDelimiter is configured, pass the values joined by it (in column order),
' Sets the selection from a formatted value string.
' - ColumnDelimiter set: splits the value by the delimiter and applies parts to
'   columns in column order (e.g. "red-md" with delimiter -).
' - Otherwise parses the value with InputFormat (flatpickr dateFormat) and sets each
'   role's column (works for auto pickers and for default pickers built with
'   AddColumnDay/Month/Year), e.g. SetValue("2027-01-01") with InputFormat="Y-m-d".
' - Falls back to applying the whole string to the first column.
Public Sub SetValue(sValue As String)
	If sValue = Null Then Return
	If mColumns.Size = 0 Then Return
	If msColumnDelimiter.Length > 0 Then
		Dim parts() As String = Regex.Split(msColumnDelimiter, sValue)
		Dim n As Int = Min(parts.Length, mColumns.Size)
		For i = 0 To n - 1
			SetColumnValueByIndex(i, parts(i))
		Next
	Return
	End If
	Dim fmt As String = msInputFormat
	If msPickerType <> "default" And fmt.Length = 0 Then fmt = DefaultFormatForType(msPickerType)
	If fmt.Length > 0 And (msPickerType <> "default" Or HasRoleColumns) Then
		If SetValuesByFormat(sValue, fmt) Then Return
	End If
	SetColumnValueByIndex(0, sValue)
End Sub

' Matches a value (compared as a string) against a column's option values and scrolls
' that option to the active/center position, firing ColumnChanged. No-op when not found.
Private Sub SetColumnValueByIndex(iIndex As Int, oValue As Object)
	If iIndex < 0 Or iIndex >= mColumns.Size Then Return
	Dim col As PickerColumn = mColumns.Get(iIndex)
	Dim target As String = "" & oValue
	For i = 0 To col.Options.Size - 1
		Dim opt As PickerOption = col.Options.Get(i)
		If ValuesEqual(opt.Value, target) Then
			ScrollToActiveItem(col, i, True)
			Return
		End If
	Next
End Sub

' Convenience setter that accepts a B4X List of values, one per column in column order
' (index 0 -> first column, index 1 -> second column, ...). Each item is matched against
' a column's option values (compared as strings) and scrolled to center; an unmatched
' item leaves that column unchanged. Extra items beyond the column count are ignored.
' Works for 'default' type pickers (use SetColumnValue per role for auto types).
Public Sub SetValueList(lstValues As List)
	If lstValues.IsInitialized = False Then Return
	If mColumns.Size = 0 Then Return
	Dim n As Int = Min(lstValues.Size, mColumns.Size)
	For i = 0 To n - 1
		SetColumnValueByIndex(i, lstValues.Get(i))
	Next
End Sub

' Returns the current selection as a B4X List, one entry per column in column order
' (index 0 -> first column, ...). Works for every picker type and is often handier than
' the formatted GetValue string when you want the raw per-column values.
Public Sub GetValueList As List
	Dim out As List
	out.Initialize
	For Each col As PickerColumn In mColumns
		Dim v As Object = Null
		If col.Options.Size > 0 Then
			Dim opt As PickerOption = col.Options.Get(col.CurrentIndex)
			v = opt.Value
		End If
		out.Add(v)
	Next
	Return out
End Sub

' Returns the current selection formatted according to InputFormat (flatpickr tokens).
' Only meaningful for PickerType='auto'; returns "" for 'default'
' (use GetColumnValue/GetValueList per column, or set ColumnDelimiter to join all column values).
Public Sub GetValue As String
	' Returns the VALUE formatted by InputFormat (flatpickr dateFormat).
	' ColumnDelimiter (if set) joins raw column values in column order and overrides this.
	' For 'default'-type pickers, InputFormat formatting only applies when date/time role
	' columns exist (AddColumnDay/Month/Year); otherwise returns "" (backward compatible).
	If msColumnDelimiter.Length > 0 Then Return JoinColumnValues(msColumnDelimiter)
	Dim fmt As String = msInputFormat
	If msPickerType <> "default" And fmt.Length = 0 Then fmt = DefaultFormatForType(msPickerType)
	If fmt.Length = 0 Then Return ""
	If msPickerType = "default" And HasRoleColumns = False Then Return ""
	Dim segs As List = ParseFormat(fmt)
	Dim sb As StringBuilder
	sb.Initialize
	For Each seg As Map In segs
		If seg.Get("type") = "literal" Then
			sb.Append(seg.Get("value"))
		Else
			Dim tok As String = seg.Get("value")
			sb.Append(FormatToken(tok, GetColumnValueByRole(RoleForToken(tok))))
		End If
	Next
	Return sb.ToString
End Sub

' Returns the current selection formatted with DisplayFormat (flatpickr altFormat-style):
' a composite DISPLAY string such as 01 Jan 2027 (DisplayFormat=d M Y), independent of
' InputFormat which controls the VALUE returned by GetValue (e.g. 2027-01-01). Falls back to
' GetValue when no DisplayFormat is set or for default-type pickers.
Public Sub GetDisplayValue As String
	' Returns the DISPLAY string formatted by DisplayFormat (flatpickr altFormat).
	' Falls back to GetValue when no DisplayFormat is set, or for 'default'-type pickers
	' without date/time role columns (AddColumnDay/Month/Year).
	If msDisplayFormat.Length = 0 Then Return GetValue
	If msPickerType = "default" And HasRoleColumns = False Then Return GetValue
	Dim segs As List = ParseFormat(msDisplayFormat)
	Dim sb As StringBuilder
	sb.Initialize
	For Each seg As Map In segs
		If seg.Get("type") = "literal" Then
			sb.Append(seg.Get("value"))
		Else
			Dim tok As String = seg.Get("value")
			sb.Append(FormatToken(tok, GetColumnValueByRole(RoleForToken(tok))))
		End If
	Next
	Return sb.ToString
End Sub

' Joins the current value of every column (in the order columns were added) using Delim.
Private Sub JoinColumnValues(sDelim As String) As String
	If mColumns.Size = 0 Then Return ""
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To mColumns.Size - 1
		Dim col As PickerColumn = mColumns.Get(i)
		Dim v As Object = Null
		If col.Options.Size > 0 Then
			Dim opt As PickerOption = col.Options.Get(col.CurrentIndex)
			v = opt.Value
		End If
		If i > 0 Then sb.Append(sDelim)
		If v <> Null Then sb.Append("" & v)
	Next
	Return sb.ToString
End Sub

' Formats a column value for a single flatpickr token (used by GetValue).
Private Sub FormatToken(sToken As String, oValue As Object) As String
	If oValue = Null Then Return ""
	Select Case sToken
		Case "Y"
			Return Pad4(ToInt(oValue))
		Case "y"
			Return Pad2(ToInt(oValue) Mod 100)
		Case "m"
			Return Pad2(ToInt(oValue))
		Case "n"
			Return "" & ToInt(oValue)
		Case "M"
			Return MonthAbbr(ToInt(oValue))
		Case "F"
			Return MonthFull(ToInt(oValue))
		Case "d"
			Return Pad2(ToInt(oValue))
		Case "j"
			Return "" & ToInt(oValue)
		Case "H"
			Return Pad2(ToInt(oValue))
		Case "G"
			Return "" & ToInt(oValue)
		Case "h"
			Return Pad2(ToInt(oValue))
		Case "g"
			Return "" & ToInt(oValue)
		Case "i"
			Return Pad2(ToInt(oValue))
		Case "s"
			Return Pad2(ToInt(oValue))
		Case "K"
			Return "" & oValue
		Case "a"
			Return ("" & oValue).ToLowerCase
	End Select
	Return ""
End Sub

' Tap-to-select: tapping a visible option scrolls that item to the center highlight
' and makes it the active value (mirrors the Label.Initialize+Tag+Click pattern used
' by B4XDaisyTab). A drag still scrolls the column normally via the parent ScrollView.
Private Sub PickerOpt_Click
	Dim src As B4XView = Sender
	Dim tagVal As Object = src.Tag
	If tagVal Is Map Then
		Dim info As Map = tagVal
		Dim colName As String = info.Get("col")
		Dim idx As Int = info.Get("index")
		If mMapColumns.ContainsKey(colName) Then
			Dim col As PickerColumn = mMapColumns.Get(colName)
			If col.Disabled Then Return
			If idx < 0 Or idx >= col.Options.Size Then Return
			Dim opt As PickerOption = col.Options.Get(idx)
			If opt.Disabled Then Return
			ScrollToActiveItem(col, idx, True)
		End If
	End If
End Sub
#End Region

#Region Scroll Intercept Fix (B4A)
' Mirrors the proven B4XDaisySelect touch-interception pattern. Each column's
' ScrollView is given an OnTouchListener that walks up the view hierarchy and
' calls requestDisallowInterceptTouchEvent(True) on every ancestor OUTSIDE the
' picker's own root (mBase). This stops an enclosing page ScrollView from stealing
' vertical drags so the picker column scrolls cleanly instead of scrolling the page.
#If B4A
Private Sub ColSVTouch_Event(sMethodName As String, oArgs() As Object) As Object
	If sMethodName = "onTouch" Then
		#If B4A
		Dim motionEvent As JavaObject = oArgs(1)
		Dim Action As Int = motionEvent.RunMethod("getAction", Null)
		Dim touchedView As JavaObject = oArgs(0)
		If touchedView.IsInitialized Then
			Dim current As JavaObject = touchedView
			Dim reachedPickerRoot As Boolean = False
			Do While current.IsInitialized
				Dim parentView As JavaObject
				Try
					parentView = current.RunMethod("getParent", Null)
				Catch
					Exit
				End Try
				If parentView.IsInitialized = False Then Exit

				' Once we have climbed past the picker's own root (mBase), every
				' remaining ancestor is external (page ScrollView etc.) and must be
				' told not to intercept the column's vertical drag.
				If reachedPickerRoot Then
					If Action = 0 Or Action = 2 Then ' ACTION_DOWN / ACTION_MOVE
						Try
							parentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
						Catch
							If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPicker.ColSVTouch_Event: " & LastException.Message)
						End Try
					End If
				End If

				' Detect crossing the picker root boundary (mBase) so the next loop
				' iteration begins disallowing intercept on external ancestors.
				If mBase.IsInitialized Then
					Dim joMB As JavaObject = mBase
					Try
						If parentView.RunMethod("equals", Array(joMB)) Then reachedPickerRoot = True
					Catch
						If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPicker.ColSVTouch_Event: " & LastException.Message)
					End Try
				End If

				Try
					Dim parentClass As String = GetType(parentView)
					If parentClass.Contains("ViewRootImpl") Then Exit
				Catch
					Exit
				End Try
				current = parentView
			Loop
		End If
		#End If
	End If
	Return False ' let the ScrollView handle the scroll
End Sub
#End If
#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

#Region Base Properties
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
#End Region
