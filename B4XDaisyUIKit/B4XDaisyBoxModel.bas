B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
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

Public Sub TailwindSpacingToDip(oValue As Object, fDefaultDip As Float) As Float
	If oValue = Null Then Return Max(0, fDefaultDip)
	EnsureDefaultSpacingScale

	Dim raw As String = oValue
	If raw = Null Then Return Max(0, fDefaultDip)
	Dim s As String = raw.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, fDefaultDip)

	'Accept utility-style tokens and keep only the final spacing spec part.
	Dim p As Int = s.LastIndexOf("-")
	If p > = 0 And p < s.Length - 1 Then s = s.SubString(p + 1)
	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If

	If DefaultSpacingScalePx.ContainsKey(s) Then
		Dim px As Float = DefaultSpacingScalePx.Get(s)
		Return px * 1dip
	End If
	Return Max(0, B4XDaisyVariants.TailwindSizeToDip(oValue, fDefaultDip))
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

Public Sub ResolveLength(oValue As Object, fParentSize As Float, fDefaultDip As Float) As Float
	Dim base As Float = IIf(fParentSize > 0, fParentSize, fDefaultDip)
	Return Max(0, TailwindSpacingToDip(oValue, base))
End Sub

Public Sub ApplyPaddingUtility(mModel As Map, sUtility As String, bIsRtl As Boolean) As Boolean
	If mModel.IsInitialized = False Then Return False
	If sUtility = Null Then Return False
	Dim u As String = sUtility.ToLowerCase.Trim
	If u.Length = 0 Then Return False

	Dim key As String = ""
	Dim valueToken As String = ""
	Dim p As Int = u.IndexOf("-")
	If p < = 0 Or p > = u.Length - 1 Then Return False
	key = u.SubString2(0, p)
	valueToken = u.SubString(p + 1)
	Dim v As Float = TailwindSpacingToDip(valueToken, 0dip)

	Select Case key
		Case "p"
			mModel.Put("padding_left", v)
			mModel.Put("padding_top", v)
			mModel.Put("padding_right", v)
			mModel.Put("padding_bottom", v)
		Case "px"
			mModel.Put("padding_left", v)
			mModel.Put("padding_right", v)
		Case "py"
			mModel.Put("padding_top", v)
			mModel.Put("padding_bottom", v)
		Case "pt"
			mModel.Put("padding_top", v)
		Case "pr"
			mModel.Put("padding_right", v)
		Case "pb"
			mModel.Put("padding_bottom", v)
		Case "pl"
			mModel.Put("padding_left", v)
		Case "ps"
			If bIsRtl Then
				mModel.Put("padding_right", v)
			Else
				mModel.Put("padding_left", v)
			End If
		Case "pe"
			If bIsRtl Then
				mModel.Put("padding_left", v)
			Else
				mModel.Put("padding_right", v)
			End If
		Case Else
			Return False
	End Select
	Return True
End Sub

Public Sub ApplyPaddingUtilities(mModel As Map, sUtilities As String, bIsRtl As Boolean)
	If mModel.IsInitialized = False Then Return
	If sUtilities = Null Then Return
	Dim raw As String = sUtilities.Trim
	If raw.Length = 0 Then Return
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each token As String In parts
		ApplyPaddingUtility(mModel, token, bIsRtl)
	Next
End Sub

Public Sub ApplyMarginUtility(mModel As Map, sUtility As String, bIsRtl As Boolean) As Boolean
	If mModel.IsInitialized = False Then Return False
	If sUtility = Null Then Return False
	Dim u As String = sUtility.ToLowerCase.Trim
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
	If p < = 0 Or p > = u.Length - 1 Then Return False
	key = u.SubString2(0, p)
	valueToken = u.SubString(p + 1)
	Dim isAuto As Boolean = (valueToken = "auto")
	If isAuto And isNegative Then Return False
	Dim v As Float = IIf(isAuto, AUTO_MARGIN_SENTINEL, TailwindSpacingToDip(valueToken, 0dip))
	If isNegative Then v = -v

	Select Case key
		Case "m"
			mModel.Put("margin_left", v)
			mModel.Put("margin_top", v)
			mModel.Put("margin_right", v)
			mModel.Put("margin_bottom", v)
		Case "mx"
			mModel.Put("margin_left", v)
			mModel.Put("margin_right", v)
		Case "my"
			mModel.Put("margin_top", v)
			mModel.Put("margin_bottom", v)
		Case "mt"
			mModel.Put("margin_top", v)
		Case "mr"
			mModel.Put("margin_right", v)
		Case "mb"
			mModel.Put("margin_bottom", v)
		Case "ml"
			mModel.Put("margin_left", v)
		Case "ms"
			If bIsRtl Then
				mModel.Put("margin_right", v)
			Else
				mModel.Put("margin_left", v)
			End If
		Case "me"
			If bIsRtl Then
				mModel.Put("margin_left", v)
			Else
				mModel.Put("margin_right", v)
			End If
		Case Else
			Return False
	End Select
	Return True
End Sub

Public Sub ApplyMarginUtilities(mModel As Map, sUtilities As String, bIsRtl As Boolean)
	If mModel.IsInitialized = False Then Return
	If sUtilities = Null Then Return
	Dim raw As String = sUtilities.Trim
	If raw.Length = 0 Then Return
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each token As String In parts
		ApplyMarginUtility(mModel, token, bIsRtl)
	Next
End Sub

Public Sub ApplyRadiusUtility(mModel As Map, sUtility As String, bIsRtl As Boolean) As Boolean
	If mModel.IsInitialized = False Then Return False
	If sUtility = Null Then Return False
	Dim u As String = sUtility.ToLowerCase.Trim
	If u.Length = 0 Then Return False

	Dim value As Float = ResolveRadiusUtilityValueDip(u)
	If value < 0 Then Return False

	Select Case u
		Case "rounded-box", "rounded-field", "rounded-selector"
			SetRadiusAll(mModel, value)
		Case "rounded-t-box", "rounded-t-field", "rounded-t-selector"
			SetRadiusTop(mModel, value)
		Case "rounded-b-box", "rounded-b-field", "rounded-b-selector"
			SetRadiusBottom(mModel, value)
		Case "rounded-l-box", "rounded-l-field", "rounded-l-selector"
			SetRadiusLeft(mModel, value)
		Case "rounded-r-box", "rounded-r-field", "rounded-r-selector"
			SetRadiusRight(mModel, value)
		Case "rounded-tl-box", "rounded-tl-field", "rounded-tl-selector"
			mModel.Put("radius_tl", value)
		Case "rounded-tr-box", "rounded-tr-field", "rounded-tr-selector"
			mModel.Put("radius_tr", value)
		Case "rounded-br-box", "rounded-br-field", "rounded-br-selector"
			mModel.Put("radius_br", value)
		Case "rounded-bl-box", "rounded-bl-field", "rounded-bl-selector"
			mModel.Put("radius_bl", value)
		Case Else
			Return False
	End Select
	mModel.Put("radius", ResolveEffectiveRadius(mModel, value))
	Return True
End Sub

Public Sub ApplyRadiusUtilities(mModel As Map, sUtilities As String, bIsRtl As Boolean)
	If mModel.IsInitialized = False Then Return
	If sUtilities = Null Then Return
	Dim raw As String = sUtilities.Trim
	If raw.Length = 0 Then Return
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each token As String In parts
		ApplyRadiusUtility(mModel, token, bIsRtl)
	Next
End Sub

Public Sub GetCornerRadius(mModel As Map, sCorner As String, fFallback As Float) As Float
	If mModel.IsInitialized = False Then Return Max(0, fFallback)
	Dim key As String = "radius_" & sCorner.ToLowerCase.Trim
	Dim v As Float = GetFloat(mModel, key, -1)
	If v > = 0 Then Return v
	Return Max(0, GetFloat(mModel, "radius", fFallback))
End Sub

Public Sub ResolveOuterRect(rcHostRect As B4XRect, mModel As Map) As B4XRect
	Dim l As Float = rcHostRect.Left + GetMarginValue(mModel, "margin_left")
	Dim t As Float = rcHostRect.Top + GetMarginValue(mModel, "margin_top")
	Dim rr As Float = rcHostRect.Right - GetMarginValue(mModel, "margin_right")
	Dim bb As Float = rcHostRect.Bottom - GetMarginValue(mModel, "margin_bottom")
	Dim r As B4XRect
	r.Initialize(l, t, rr, bb)
	Return NormalizeRect(r)
End Sub

Public Sub ResolveBorderRect(rcOuterRect As B4XRect, mModel As Map) As B4XRect
	Return NormalizeRect(rcOuterRect)
End Sub

Public Sub ResolvePaddingRect(rcBorderRect As B4XRect, mModel As Map) As B4XRect
	Dim bw As Float = Max(0, GetFloat(mModel, "border_width", 0))
	Return InsetRect(rcBorderRect, bw, bw, bw, bw)
End Sub

Public Sub ResolveContentRect(rcBorderRect As B4XRect, mModel As Map) As B4XRect
	Dim r As B4XRect = ResolvePaddingRect(rcBorderRect, mModel)
	Return InsetRect(r, Max(0, GetFloat(mModel, "padding_left", 0)), Max(0, GetFloat(mModel, "padding_top", 0)), Max(0, GetFloat(mModel, "padding_right", 0)), Max(0, GetFloat(mModel, "padding_bottom", 0)))
End Sub

Public Sub ExpandContentWidth(fContentWidth As Float, mModel As Map) As Float
	Dim w As Float = Max(0, fContentWidth)
	w = w + Max(0, GetFloat(mModel, "padding_left", 0)) + Max(0, GetFloat(mModel, "padding_right", 0))
	w = w + Max(0, GetFloat(mModel, "border_width", 0)) * 2
	w = w + GetMarginValue(mModel, "margin_left") + GetMarginValue(mModel, "margin_right")
	Dim minW As Float = GetFloat(mModel, "min_width", 0)
	Dim maxW As Float = GetFloat(mModel, "max_width", -1)
	If minW > 0 Then w = Max(w, minW)
	If maxW > 0 Then w = Min(w, maxW)
	Return w
End Sub

Public Sub ExpandContentHeight(fContentHeight As Float, mModel As Map) As Float
	Dim h As Float = Max(0, fContentHeight)
	h = h + Max(0, GetFloat(mModel, "padding_top", 0)) + Max(0, GetFloat(mModel, "padding_bottom", 0))
	h = h + Max(0, GetFloat(mModel, "border_width", 0)) * 2
	h = h + GetMarginValue(mModel, "margin_top") + GetMarginValue(mModel, "margin_bottom")
	Dim minH As Float = GetFloat(mModel, "min_height", 0)
	Dim maxH As Float = GetFloat(mModel, "max_height", -1)
	If minH > 0 Then h = Max(h, minH)
	If maxH > 0 Then h = Min(h, maxH)
	Return h
End Sub

Public Sub ToLocalRect(rcAbsoluteRect As B4XRect, rcOriginRect As B4XRect) As B4XRect
	Dim r As B4XRect
	r.Initialize(rcAbsoluteRect.Left - rcOriginRect.Left, rcAbsoluteRect.Top - rcOriginRect.Top, rcAbsoluteRect.Right - rcOriginRect.Left, rcAbsoluteRect.Bottom - rcOriginRect.Top)
	Return NormalizeRect(r)
End Sub

Private Sub InsetRect(rcSourceRect As B4XRect, fLeftInset As Float, fTopInset As Float, fRightInset As Float, fBottomInset As Float) As B4XRect
	Dim r As B4XRect
	Dim l As Float = rcSourceRect.Left + Max(0, fLeftInset)
	Dim t As Float = rcSourceRect.Top + Max(0, fTopInset)
	Dim rr As Float = rcSourceRect.Right - Max(0, fRightInset)
	Dim bb As Float = rcSourceRect.Bottom - Max(0, fBottomInset)
	If rr < l Then rr = l
	If bb < t Then bb = t
	r.Initialize(l, t, rr, bb)
	Return r
End Sub

Private Sub NormalizeRect(rcSourceRect As B4XRect) As B4XRect
	Dim r As B4XRect
	Dim l As Float = rcSourceRect.Left
	Dim t As Float = rcSourceRect.Top
	Dim rr As Float = Max(rcSourceRect.Right, l)
	Dim bb As Float = Max(rcSourceRect.Bottom, t)
	r.Initialize(l, t, rr, bb)
	Return r
End Sub

Private Sub GetFloat(mModel As Map, sKey As String, fDefaultValue As Float) As Float
	If mModel.IsInitialized = False Then Return fDefaultValue
	If mModel.ContainsKey(sKey) = False Then Return fDefaultValue
	Dim o As Object = mModel.Get(sKey)
	If o = Null Then Return fDefaultValue
	Return o
End Sub

Private Sub GetMarginValue(mModel As Map, sKey As String) As Float
	Dim v As Float = GetFloat(mModel, sKey, 0)
	If v = AUTO_MARGIN_SENTINEL Then Return 0
	Return v
End Sub

Private Sub ResolveRadiusUtilityValueDip(sUtility As String) As Float
	Select Case sUtility
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

Private Sub SetRadiusAll(mModel As Map, fValue As Float)
	mModel.Put("radius", fValue)
	mModel.Put("radius_tl", fValue)
	mModel.Put("radius_tr", fValue)
	mModel.Put("radius_br", fValue)
	mModel.Put("radius_bl", fValue)
End Sub

Private Sub SetRadiusTop(mModel As Map, fValue As Float)
	mModel.Put("radius_tl", fValue)
	mModel.Put("radius_tr", fValue)
End Sub

Private Sub SetRadiusBottom(mModel As Map, fValue As Float)
	mModel.Put("radius_bl", fValue)
	mModel.Put("radius_br", fValue)
End Sub

Private Sub SetRadiusLeft(mModel As Map, fValue As Float)
	mModel.Put("radius_tl", fValue)
	mModel.Put("radius_bl", fValue)
End Sub

Private Sub SetRadiusRight(mModel As Map, fValue As Float)
	mModel.Put("radius_tr", fValue)
	mModel.Put("radius_br", fValue)
End Sub

Private Sub ResolveEffectiveRadius(mModel As Map, fDefaultValue As Float) As Float
	Dim tl As Float = GetFloat(mModel, "radius_tl", -1)
	Dim tr As Float = GetFloat(mModel, "radius_tr", -1)
	Dim br As Float = GetFloat(mModel, "radius_br", -1)
	Dim bl As Float = GetFloat(mModel, "radius_bl", -1)
	If tl > = 0 And tr > = 0 And br > = 0 And bl > = 0 And tl = tr And tr = br And br = bl Then Return tl
	Return Max(0, GetFloat(mModel, "radius", fDefaultValue))
End Sub
