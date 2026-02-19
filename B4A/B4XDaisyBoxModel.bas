B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@
'Shared CSS-like box model helpers for Daisy components.

Sub Process_Globals
	Private DefaultSpacingScalePx As Map
	Private Const AUTO_MARGIN_SENTINEL As Float = -9999999
End Sub

Private Sub EnsureDefaultSpacingScale
	If DefaultSpacingScalePx.IsInitialized Then Return
	DefaultSpacingScalePx.Initialize
	DefaultSpacingScalePx.Put("0", 0)
	DefaultSpacingScalePx.Put("px", 1)
	DefaultSpacingScalePx.Put("0.5", 2)
	DefaultSpacingScalePx.Put("1", 4)
	DefaultSpacingScalePx.Put("1.5", 6)
	DefaultSpacingScalePx.Put("2", 8)
	DefaultSpacingScalePx.Put("2.5", 10)
	DefaultSpacingScalePx.Put("3", 12)
	DefaultSpacingScalePx.Put("3.5", 14)
	DefaultSpacingScalePx.Put("4", 16)
	DefaultSpacingScalePx.Put("5", 20)
	DefaultSpacingScalePx.Put("6", 24)
	DefaultSpacingScalePx.Put("7", 28)
	DefaultSpacingScalePx.Put("8", 32)
	DefaultSpacingScalePx.Put("9", 36)
	DefaultSpacingScalePx.Put("10", 40)
	DefaultSpacingScalePx.Put("11", 44)
	DefaultSpacingScalePx.Put("12", 48)
	DefaultSpacingScalePx.Put("14", 56)
	DefaultSpacingScalePx.Put("16", 64)
	DefaultSpacingScalePx.Put("20", 80)
	DefaultSpacingScalePx.Put("24", 96)
	DefaultSpacingScalePx.Put("28", 112)
	DefaultSpacingScalePx.Put("32", 128)
	DefaultSpacingScalePx.Put("36", 144)
	DefaultSpacingScalePx.Put("40", 160)
	DefaultSpacingScalePx.Put("44", 176)
	DefaultSpacingScalePx.Put("48", 192)
	DefaultSpacingScalePx.Put("52", 208)
	DefaultSpacingScalePx.Put("56", 224)
	DefaultSpacingScalePx.Put("60", 240)
	DefaultSpacingScalePx.Put("64", 256)
	DefaultSpacingScalePx.Put("72", 288)
	DefaultSpacingScalePx.Put("80", 320)
	DefaultSpacingScalePx.Put("96", 384)
End Sub

Public Sub GetDefaultSpacingScale As Map
	EnsureDefaultSpacingScale
	Dim out As Map
	out.Initialize
	For Each k As String In DefaultSpacingScalePx.Keys
		out.Put(k, DefaultSpacingScalePx.Get(k))
	Next
	Return out
End Sub

Public Sub TailwindSpacingToDip(Value As Object, DefaultDip As Float) As Float
	If Value = Null Then Return Max(0, DefaultDip)
	EnsureDefaultSpacingScale

	Dim raw As String = Value
	Dim s As String = raw.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, DefaultDip)

	' Accept utility-style tokens and keep only the final spacing spec part.
	Dim p As Int = s.LastIndexOf("-")
	If p >= 0 And p < s.Length - 1 Then s = s.SubString(p + 1)
	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then s = s.SubString2(1, s.Length - 1).Trim

	If DefaultSpacingScalePx.ContainsKey(s) Then
		Dim px As Float = DefaultSpacingScalePx.Get(s)
		Return px * 1dip
	End If
	Return Max(0, B4XDaisyVariants.TailwindSizeToDip(Value, DefaultDip))
End Sub

Public Sub CreateDefaultModel As Map
	Dim m As Map
	m.Initialize
	m.Put("margin_left", 0)
	m.Put("margin_top", 0)
	m.Put("margin_right", 0)
	m.Put("margin_bottom", 0)
	m.Put("padding_left", 0)
	m.Put("padding_top", 0)
	m.Put("padding_right", 0)
	m.Put("padding_bottom", 0)
	m.Put("border_width", 0)
	m.Put("radius", 0)
	m.Put("radius_tl", -1)
	m.Put("radius_tr", -1)
	m.Put("radius_br", -1)
	m.Put("radius_bl", -1)
	m.Put("min_width", 0)
	m.Put("min_height", 0)
	m.Put("max_width", -1)
	m.Put("max_height", -1)
	m.Put("box_sizing", "border-box")
	Return m
End Sub

Public Sub ResolveLength(Value As Object, ParentSize As Float, DefaultDip As Float) As Float
	Dim base As Float = IIf(ParentSize > 0, ParentSize, DefaultDip)
	Return Max(0, TailwindSpacingToDip(Value, base))
End Sub

Public Sub ApplyPaddingUtility(Model As Map, Utility As String, IsRtl As Boolean) As Boolean
	If Model.IsInitialized = False Then Return False
	If Utility = Null Then Return False
	Dim u As String = Utility.ToLowerCase.Trim
	If u.Length = 0 Then Return False

	Dim key As String = ""
	Dim valueToken As String = ""
	Dim p As Int = u.IndexOf("-")
	If p <= 0 Or p >= u.Length - 1 Then Return False
	key = u.SubString2(0, p)
	valueToken = u.SubString(p + 1)
	Dim v As Float = TailwindSpacingToDip(valueToken, 0dip)

	Select Case key
		Case "p"
			Model.Put("padding_left", v)
			Model.Put("padding_top", v)
			Model.Put("padding_right", v)
			Model.Put("padding_bottom", v)
		Case "px"
			Model.Put("padding_left", v)
			Model.Put("padding_right", v)
		Case "py"
			Model.Put("padding_top", v)
			Model.Put("padding_bottom", v)
		Case "pt"
			Model.Put("padding_top", v)
		Case "pr"
			Model.Put("padding_right", v)
		Case "pb"
			Model.Put("padding_bottom", v)
		Case "pl"
			Model.Put("padding_left", v)
		Case "ps"
			If IsRtl Then
				Model.Put("padding_right", v)
			Else
				Model.Put("padding_left", v)
			End If
		Case "pe"
			If IsRtl Then
				Model.Put("padding_left", v)
			Else
				Model.Put("padding_right", v)
			End If
		Case Else
			Return False
	End Select
	Return True
End Sub

Public Sub ApplyPaddingUtilities(Model As Map, Utilities As String, IsRtl As Boolean)
	If Model.IsInitialized = False Then Return
	If Utilities = Null Then Return
	Dim raw As String = Utilities.Trim
	If raw.Length = 0 Then Return
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each token As String In parts
		ApplyPaddingUtility(Model, token, IsRtl)
	Next
End Sub

Public Sub ApplyMarginUtility(Model As Map, Utility As String, IsRtl As Boolean) As Boolean
	If Model.IsInitialized = False Then Return False
	If Utility = Null Then Return False
	Dim u As String = Utility.ToLowerCase.Trim
	If u.Length = 0 Then Return False
	Dim isNegative As Boolean = False
	If u.StartsWith("-") Then
		isNegative = True
		u = u.SubString(1).Trim
		If u.Length = 0 Then Return False
	End If

	Dim key As String = ""
	Dim valueToken As String = ""
	Dim p As Int = u.IndexOf("-")
	If p <= 0 Or p >= u.Length - 1 Then Return False
	key = u.SubString2(0, p)
	valueToken = u.SubString(p + 1)
	Dim isAuto As Boolean = (valueToken = "auto")
	If isAuto And isNegative Then Return False
	Dim v As Float = IIf(isAuto, AUTO_MARGIN_SENTINEL, TailwindSpacingToDip(valueToken, 0dip))
	If isNegative Then v = -v

	Select Case key
		Case "m"
			Model.Put("margin_left", v)
			Model.Put("margin_top", v)
			Model.Put("margin_right", v)
			Model.Put("margin_bottom", v)
		Case "mx"
			Model.Put("margin_left", v)
			Model.Put("margin_right", v)
		Case "my"
			Model.Put("margin_top", v)
			Model.Put("margin_bottom", v)
		Case "mt"
			Model.Put("margin_top", v)
		Case "mr"
			Model.Put("margin_right", v)
		Case "mb"
			Model.Put("margin_bottom", v)
		Case "ml"
			Model.Put("margin_left", v)
		Case "ms"
			If IsRtl Then
				Model.Put("margin_right", v)
			Else
				Model.Put("margin_left", v)
			End If
		Case "me"
			If IsRtl Then
				Model.Put("margin_left", v)
			Else
				Model.Put("margin_right", v)
			End If
		Case Else
			Return False
	End Select
	Return True
End Sub

Public Sub ApplyMarginUtilities(Model As Map, Utilities As String, IsRtl As Boolean)
	If Model.IsInitialized = False Then Return
	If Utilities = Null Then Return
	Dim raw As String = Utilities.Trim
	If raw.Length = 0 Then Return
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each token As String In parts
		ApplyMarginUtility(Model, token, IsRtl)
	Next
End Sub

Public Sub ApplyRadiusUtility(Model As Map, Utility As String, IsRtl As Boolean) As Boolean
	If Model.IsInitialized = False Then Return False
	If Utility = Null Then Return False
	Dim u As String = Utility.ToLowerCase.Trim
	If u.Length = 0 Then Return False

	Dim value As Float = ResolveRadiusUtilityValueDip(u)
	If value < 0 Then Return False

	Select Case u
		Case "rounded-box", "rounded-field", "rounded-selector"
			SetRadiusAll(Model, value)
		Case "rounded-t-box", "rounded-t-field", "rounded-t-selector"
			SetRadiusTop(Model, value)
		Case "rounded-b-box", "rounded-b-field", "rounded-b-selector"
			SetRadiusBottom(Model, value)
		Case "rounded-l-box", "rounded-l-field", "rounded-l-selector"
			SetRadiusLeft(Model, value)
		Case "rounded-r-box", "rounded-r-field", "rounded-r-selector"
			SetRadiusRight(Model, value)
		Case "rounded-tl-box", "rounded-tl-field", "rounded-tl-selector"
			Model.Put("radius_tl", value)
		Case "rounded-tr-box", "rounded-tr-field", "rounded-tr-selector"
			Model.Put("radius_tr", value)
		Case "rounded-br-box", "rounded-br-field", "rounded-br-selector"
			Model.Put("radius_br", value)
		Case "rounded-bl-box", "rounded-bl-field", "rounded-bl-selector"
			Model.Put("radius_bl", value)
		Case Else
			Return False
	End Select
	Model.Put("radius", ResolveEffectiveRadius(Model, value))
	Return True
End Sub

Public Sub ApplyRadiusUtilities(Model As Map, Utilities As String, IsRtl As Boolean)
	If Model.IsInitialized = False Then Return
	If Utilities = Null Then Return
	Dim raw As String = Utilities.Trim
	If raw.Length = 0 Then Return
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each token As String In parts
		ApplyRadiusUtility(Model, token, IsRtl)
	Next
End Sub

Public Sub GetCornerRadius(Model As Map, Corner As String, Fallback As Float) As Float
	If Model.IsInitialized = False Then Return Max(0, Fallback)
	Dim key As String = "radius_" & Corner.ToLowerCase.Trim
	Dim v As Float = GetFloat(Model, key, -1)
	If v >= 0 Then Return v
	Return Max(0, GetFloat(Model, "radius", Fallback))
End Sub

Public Sub ResolveOuterRect(HostRect As B4XRect, Model As Map) As B4XRect
	Dim l As Float = HostRect.Left + GetMarginValue(Model, "margin_left")
	Dim t As Float = HostRect.Top + GetMarginValue(Model, "margin_top")
	Dim rr As Float = HostRect.Right - GetMarginValue(Model, "margin_right")
	Dim bb As Float = HostRect.Bottom - GetMarginValue(Model, "margin_bottom")
	Dim r As B4XRect
	r.Initialize(l, t, rr, bb)
	Return NormalizeRect(r)
End Sub

Public Sub ResolveBorderRect(OuterRect As B4XRect, Model As Map) As B4XRect
	Return NormalizeRect(OuterRect)
End Sub

Public Sub ResolvePaddingRect(BorderRect As B4XRect, Model As Map) As B4XRect
	Dim bw As Float = Max(0, GetFloat(Model, "border_width", 0))
	Return InsetRect(BorderRect, bw, bw, bw, bw)
End Sub

Public Sub ResolveContentRect(BorderRect As B4XRect, Model As Map) As B4XRect
	Dim r As B4XRect = ResolvePaddingRect(BorderRect, Model)
	Return InsetRect(r, Max(0, GetFloat(Model, "padding_left", 0)), Max(0, GetFloat(Model, "padding_top", 0)), Max(0, GetFloat(Model, "padding_right", 0)), Max(0, GetFloat(Model, "padding_bottom", 0)))
End Sub

Public Sub ExpandContentWidth(ContentWidth As Float, Model As Map) As Float
	Dim w As Float = Max(0, ContentWidth)
	w = w + Max(0, GetFloat(Model, "padding_left", 0)) + Max(0, GetFloat(Model, "padding_right", 0))
	w = w + Max(0, GetFloat(Model, "border_width", 0)) * 2
	w = w + GetMarginValue(Model, "margin_left") + GetMarginValue(Model, "margin_right")
	Dim minW As Float = GetFloat(Model, "min_width", 0)
	Dim maxW As Float = GetFloat(Model, "max_width", -1)
	If minW > 0 Then w = Max(w, minW)
	If maxW > 0 Then w = Min(w, maxW)
	Return w
End Sub

Public Sub ExpandContentHeight(ContentHeight As Float, Model As Map) As Float
	Dim h As Float = Max(0, ContentHeight)
	h = h + Max(0, GetFloat(Model, "padding_top", 0)) + Max(0, GetFloat(Model, "padding_bottom", 0))
	h = h + Max(0, GetFloat(Model, "border_width", 0)) * 2
	h = h + GetMarginValue(Model, "margin_top") + GetMarginValue(Model, "margin_bottom")
	Dim minH As Float = GetFloat(Model, "min_height", 0)
	Dim maxH As Float = GetFloat(Model, "max_height", -1)
	If minH > 0 Then h = Max(h, minH)
	If maxH > 0 Then h = Min(h, maxH)
	Return h
End Sub

Public Sub ToLocalRect(AbsoluteRect As B4XRect, OriginRect As B4XRect) As B4XRect
	Dim r As B4XRect
	r.Initialize(AbsoluteRect.Left - OriginRect.Left, AbsoluteRect.Top - OriginRect.Top, AbsoluteRect.Right - OriginRect.Left, AbsoluteRect.Bottom - OriginRect.Top)
	Return NormalizeRect(r)
End Sub

Private Sub InsetRect(SourceRect As B4XRect, LeftInset As Float, TopInset As Float, RightInset As Float, BottomInset As Float) As B4XRect
	Dim r As B4XRect
	Dim l As Float = SourceRect.Left + Max(0, LeftInset)
	Dim t As Float = SourceRect.Top + Max(0, TopInset)
	Dim rr As Float = SourceRect.Right - Max(0, RightInset)
	Dim bb As Float = SourceRect.Bottom - Max(0, BottomInset)
	If rr < l Then rr = l
	If bb < t Then bb = t
	r.Initialize(l, t, rr, bb)
	Return r
End Sub

Private Sub NormalizeRect(SourceRect As B4XRect) As B4XRect
	Dim r As B4XRect
	Dim l As Float = SourceRect.Left
	Dim t As Float = SourceRect.Top
	Dim rr As Float = Max(SourceRect.Right, l)
	Dim bb As Float = Max(SourceRect.Bottom, t)
	r.Initialize(l, t, rr, bb)
	Return r
End Sub

Private Sub GetFloat(Model As Map, Key As String, DefaultValue As Float) As Float
	If Model.IsInitialized = False Then Return DefaultValue
	If Model.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Model.Get(Key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Private Sub GetMarginValue(Model As Map, Key As String) As Float
	Dim v As Float = GetFloat(Model, Key, 0)
	If v = AUTO_MARGIN_SENTINEL Then Return 0
	Return v
End Sub

Private Sub ResolveRadiusUtilityValueDip(Utility As String) As Float
	Select Case Utility
		Case "rounded-box", "rounded-t-box", "rounded-b-box", "rounded-l-box", "rounded-r-box", "rounded-tl-box", "rounded-tr-box", "rounded-br-box", "rounded-bl-box"
			Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
		Case "rounded-field", "rounded-t-field", "rounded-b-field", "rounded-l-field", "rounded-r-field", "rounded-tl-field", "rounded-tr-field", "rounded-br-field", "rounded-bl-field"
			Return B4XDaisyVariants.GetRadiusFieldDip(6dip)
		Case "rounded-selector", "rounded-t-selector", "rounded-b-selector", "rounded-l-selector", "rounded-r-selector", "rounded-tl-selector", "rounded-tr-selector", "rounded-br-selector", "rounded-bl-selector"
			Return B4XDaisyVariants.GetRadiusSelectorDip(4dip)
		Case Else
			Return -1
	End Select
End Sub

Private Sub SetRadiusAll(Model As Map, Value As Float)
	Model.Put("radius", Value)
	Model.Put("radius_tl", Value)
	Model.Put("radius_tr", Value)
	Model.Put("radius_br", Value)
	Model.Put("radius_bl", Value)
End Sub

Private Sub SetRadiusTop(Model As Map, Value As Float)
	Model.Put("radius_tl", Value)
	Model.Put("radius_tr", Value)
End Sub

Private Sub SetRadiusBottom(Model As Map, Value As Float)
	Model.Put("radius_bl", Value)
	Model.Put("radius_br", Value)
End Sub

Private Sub SetRadiusLeft(Model As Map, Value As Float)
	Model.Put("radius_tl", Value)
	Model.Put("radius_bl", Value)
End Sub

Private Sub SetRadiusRight(Model As Map, Value As Float)
	Model.Put("radius_tr", Value)
	Model.Put("radius_br", Value)
End Sub

Private Sub ResolveEffectiveRadius(Model As Map, DefaultValue As Float) As Float
	Dim tl As Float = GetFloat(Model, "radius_tl", -1)
	Dim tr As Float = GetFloat(Model, "radius_tr", -1)
	Dim br As Float = GetFloat(Model, "radius_br", -1)
	Dim bl As Float = GetFloat(Model, "radius_bl", -1)
	If tl >= 0 And tr >= 0 And br >= 0 And bl >= 0 And tl = tr And tr = br And br = bl Then Return tl
	Return Max(0, GetFloat(Model, "radius", DefaultValue))
End Sub
