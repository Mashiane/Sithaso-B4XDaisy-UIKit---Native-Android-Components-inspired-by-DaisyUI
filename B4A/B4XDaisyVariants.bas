B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@
'Shared Daisy variant helpers for B4X components.

Sub Process_Globals
	Private xui As XUI
	Private Const TW_SPACE_STEP_PX As Float = 4
	Private Const CSS_BASE_FONT_PX As Float = 16
	Public Const FLATPICKR_UNIX_PLACEHOLDER As String = "__fp_unix__"
	Private Themes As Map
	Private ActiveThemeName As String = "light"
End Sub

Public Sub SetActiveTheme(ThemeName As String)
	EnsureThemeInitialized
	Dim key As String = NormalizeThemeName(ThemeName)
	If Themes.ContainsKey(key) = False Then key = "light"
	ActiveThemeName = key
End Sub

Public Sub GetActiveTheme As String
	EnsureThemeInitialized
	Return ActiveThemeName
End Sub

Public Sub HasTheme(ThemeName As String) As Boolean
	EnsureThemeInitialized
	Return Themes.ContainsKey(NormalizeThemeName(ThemeName))
End Sub

Public Sub RegisterTheme(ThemeName As String, Tokens As Map)
	EnsureThemeInitialized
	If Tokens.IsInitialized = False Then Return
	Dim key As String = NormalizeThemeName(ThemeName)
	Dim t As Map
	t.Initialize
	For Each mk As Object In Tokens.Keys
		Dim sk As String = mk
		If sk.StartsWith("--") Then
			t.Put(sk.ToLowerCase, Tokens.Get(mk))
		Else
			t.Put(sk, Tokens.Get(mk))
		End If
	Next
	themes.Put("--theme-name", key)
	Themes.Put(key, t)
End Sub

Public Sub ResolveAssetImage(FileName As String, DefaultImage As String) As String
	If FileName = Null Or FileName.Trim.Length = 0 Then Return DefaultImage
	Dim f As String = FileName.Trim
	If File.Exists(File.DirAssets, f) Then Return f
	Return DefaultImage
End Sub

Public Sub ResolveAssetSVG(FileName As String, DefaultText As String) As String
	If FileName = Null Or FileName.Trim.Length = 0 Then Return DefaultText
	Dim f As String = FileName.Trim
	If File.Exists(File.DirAssets, f) Then 
		Return File.ReadString(File.DirAssets, f)
	End If
	Return DefaultText
End Sub

Public Sub GetThemeTokens(ThemeName As String) As Map
	EnsureThemeInitialized
	Dim key As String = NormalizeThemeName(ThemeName)
	If Themes.ContainsKey(key) Then Return Themes.Get(key)
	Return Themes.Get("light")
End Sub

Public Sub GetActiveTokens As Map
	Return GetThemeTokens(ActiveThemeName)
End Sub

Public Sub GetTokenColor(Token As String, DefaultColor As Int) As Int
	Dim m As Map = GetActiveTokens
	Dim k As String = NormalizeTokenKey(Token)
	If m.ContainsKey(k) = False Then Return DefaultColor
	Dim o As Object = m.Get(k)
	If o Is Int Then Return o
	If o Is Float Or o Is Double Then Return o
	Return DefaultColor
End Sub

Public Sub ResolveThemeColorTokenName(Name As String) As String
	If Name = Null Then Return ""
	Dim key As String = NormalizeUtilityToken(Name.ToLowerCase.Trim)
	If key.Length = 0 Then Return ""
	Dim slashPos As Int = key.IndexOf("/")
	If slashPos > 0 Then key = key.SubString2(0, slashPos).Trim
	If key.StartsWith("[") And key.EndsWith("]") And key.Length > 2 Then
		key = key.SubString2(1, key.Length - 1).Trim
	End If
	If key.StartsWith("(") And key.EndsWith(")") And key.Length > 2 Then
		key = key.SubString2(1, key.Length - 1).Trim
	End If
	If key.StartsWith("var(") And key.EndsWith(")") Then
		Dim pVar As Int = key.IndexOf("--")
		If pVar >= 0 Then key = key.SubString2(pVar, key.Length - 1).Trim
	End If
	Dim direct As String = MapKnownThemeColorNameToToken(key)
	If direct.Length > 0 Then Return direct
	key = StripColorUtilityPrefix(key)
	If key.StartsWith("--") Then Return NormalizeTokenKey(key)
	Return MapKnownThemeColorNameToToken(key)
End Sub

Private Sub StripColorUtilityPrefix(Value As String) As String
	Dim s As String = Value
	Dim prefixes() As String = Array As String( _
		"ring-offset-", "placeholder-", "decoration-", "divide-", "outline-", "shadow-", _
		"stroke-", "fill-", "caret-", "ring-", "from-", "via-", "to-", "border-", "text-", "bg-", "accent-", "color-" _
	)
	For Each pref As String In prefixes
		If s.StartsWith(pref) And s.Length > pref.Length Then
			Return s.SubString(pref.Length).Trim
		End If
	Next
	Return s
End Sub

Private Sub MapKnownThemeColorNameToToken(Key As String) As String
	Select Case Key
		Case "primary", "secondary", "accent", "neutral", "info", "success", "warning", "error", _
			"base-100", "base-200", "base-300", "base-content", _
			"primary-content", "secondary-content", "accent-content", "neutral-content", _
			"info-content", "success-content", "warning-content", "error-content"
			Return "--color-" & Key
		Case Else
			Return ""
	End Select
End Sub

Public Sub GetTokenString(Token As String, DefaultValue As String) As String
	Dim m As Map = GetActiveTokens
	Dim k As String = NormalizeTokenKey(Token)
	If m.ContainsKey(k) = False Then Return DefaultValue
	Dim o As Object = m.Get(k)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Public Sub GetTokenNumber(Token As String, DefaultValue As Float) As Float
	Dim m As Map = GetActiveTokens
	Dim k As String = NormalizeTokenKey(Token)
	If m.ContainsKey(k) = False Then Return DefaultValue
	Dim o As Object = m.Get(k)
	If o = Null Then Return DefaultValue
	If IsNumber(o) Then Return o
	Dim s As String = o
	If IsNumber(s) Then Return s
	Return DefaultValue
End Sub

Public Sub GetTokenDip(Token As String, DefaultDipValue As Float) As Float
	Dim raw As String = GetTokenString(Token, "")
	If raw.Length = 0 Then Return DefaultDipValue
	Return ParseThemeLengthToDip(raw, DefaultDipValue)
End Sub

Public Sub GetBorderDip(DefaultDip As Float) As Float
	Return GetTokenDip("--border", DefaultDip)
End Sub

Public Sub GetRadiusBoxDip(DefaultDip As Float) As Float
	Return GetTokenDip("--radius-box", DefaultDip)
End Sub

Public Sub GetRadiusFieldDip(DefaultDip As Float) As Float
	Return GetTokenDip("--radius-field", DefaultDip)
End Sub

Public Sub GetRadiusSelectorDip(DefaultDip As Float) As Float
	Return GetTokenDip("--radius-selector", DefaultDip)
End Sub

Public Sub GetVariantPalette As Map
	Return BuildVariantPalette(ActiveThemeName)
End Sub

Public Sub BuildVariantPalette(ThemeName As String) As Map
	Dim t As Map = GetThemeTokens(ThemeName)
	Dim palette As Map
	palette.Initialize
	palette.Put("neutral", BuildVariantMap(t.GetDefault("--color-neutral", xui.Color_RGB(63, 64, 77)), t.GetDefault("--color-neutral-content", xui.Color_RGB(248, 248, 249))))
	palette.Put("primary", BuildVariantMap(t.GetDefault("--color-primary", xui.Color_RGB(121, 77, 255)), t.GetDefault("--color-primary-content", xui.Color_RGB(243, 242, 255))))
	palette.Put("secondary", BuildVariantMap(t.GetDefault("--color-secondary", xui.Color_RGB(118, 113, 127)), t.GetDefault("--color-secondary-content", xui.Color_RGB(247, 247, 248))))
	palette.Put("accent", BuildVariantMap(t.GetDefault("--color-accent", xui.Color_RGB(59, 130, 246)), t.GetDefault("--color-accent-content", xui.Color_RGB(239, 246, 255))))
	palette.Put("info", BuildVariantMap(t.GetDefault("--color-info", xui.Color_RGB(4, 182, 212)), t.GetDefault("--color-info-content", xui.Color_RGB(236, 254, 255))))
	palette.Put("success", BuildVariantMap(t.GetDefault("--color-success", xui.Color_RGB(0, 202, 75)), t.GetDefault("--color-success-content", xui.Color_RGB(240, 252, 248))))
	palette.Put("warning", BuildVariantMap(t.GetDefault("--color-warning", xui.Color_RGB(252, 170, 30)), t.GetDefault("--color-warning-content", xui.Color_RGB(255, 253, 245))))
	palette.Put("error", BuildVariantMap(t.GetDefault("--color-error", xui.Color_RGB(251, 65, 65)), t.GetDefault("--color-error-content", xui.Color_RGB(255, 250, 245))))
	Return palette
End Sub

Private Sub EnsureThemeInitialized
	If Themes.IsInitialized Then Return
	Themes.Initialize
	RegisterLightTheme
	If Themes.ContainsKey(ActiveThemeName) = False Then ActiveThemeName = "light"
End Sub

Private Sub RegisterLightTheme
	Dim light As Map
	light.Initialize
	light.Put("--theme-name", "light")
	light.Put("--color-base-100", 0xFFFFFFFF)
	light.Put("--color-base-200", 0xFFF8F7FB)
	light.Put("--color-base-300", 0xFF403F43)
	light.Put("--color-base-content", 0xFF3F404D)
	light.Put("--color-primary", 0xFF794DFF)
	light.Put("--color-primary-content", 0xFFF3F2FF)
	light.Put("--color-secondary", 0xFF76717F)
	light.Put("--color-secondary-content", 0xFFF7F7F8)
	light.Put("--color-accent", 0xFF3B82F6)
	light.Put("--color-accent-content", 0xFFEFF6FF)
	light.Put("--color-neutral", 0xFF3F404D)
	light.Put("--color-neutral-content", 0xFFF8F8F9)
	light.Put("--color-info", 0xFF04B6D4)
	light.Put("--color-info-content", 0xFFECFEFF)
	light.Put("--color-success", 0xFF00CA4B)
	light.Put("--color-success-content", 0xFFF0FCF8)
	light.Put("--color-warning", 0xFFFCAA1E)
	light.Put("--color-warning-content", 0xFFFFFDF5)
	light.Put("--color-error", 0xFFFB4141)
	light.Put("--color-error-content", 0xFFFFFAF5)
	light.Put("--radius-selector", "0.25rem")
	light.Put("--radius-field", "0.375rem")
	light.Put("--radius-box", "0.5rem")
	light.Put("--size-selector", "0.25rem")
	light.Put("--size-field", "0.25rem")
	light.Put("--spacing", "0.25rem")
	light.Put("--border", "1px")
	light.Put("--depth", 0)
	light.Put("--noise", 0)
	' Glass utility defaults (daisyui-inspired).
	light.Put("--glass-blur", "40px")
	light.Put("--glass-opacity", "30%")
	light.Put("--glass-reflect-degree", "100")
	light.Put("--glass-reflect-opacity", "5%")
	light.Put("--glass-border-opacity", "20%")
	light.Put("--glass-text-shadow-opacity", "5%")
	Themes.Put("light", light)
End Sub

Private Sub NormalizeThemeName(Value As String) As String
	If Value = Null Then Return "light"
	Dim s As String = Value.ToLowerCase.Trim
	If s.Length = 0 Then Return "light"
	Return s
End Sub

Private Sub NormalizeTokenKey(Token As String) As String
	If Token = Null Then Return ""
	Dim s As String = Token.Trim
	If s.StartsWith("--") = False Then s = "--" & s
	Return s.ToLowerCase
End Sub

Private Sub ParseThemeLengthToDip(Value As String, DefaultDipValue As Float) As Float
	Dim s As String = Value.ToLowerCase.Trim
	If s.Length = 0 Then Return DefaultDipValue
	If s.EndsWith("px") Then
		Dim npx As String = s.SubString2(0, s.Length - 2).Trim
		If IsNumber(npx) Then Return npx * 1dip
		Return DefaultDipValue
	End If
	If s.EndsWith("rem") Then
		Dim nrem As String = s.SubString2(0, s.Length - 3).Trim
		If IsNumber(nrem) Then Return nrem * 16 * 1dip
		Return DefaultDipValue
	End If
	If s.EndsWith("em") Then
		Dim nem As String = s.SubString2(0, s.Length - 2).Trim
		If IsNumber(nem) Then Return nem * 16 * 1dip
		Return DefaultDipValue
	End If
	If IsNumber(s) Then Return s * 1dip
	Return DefaultDipValue
End Sub

Public Sub VariantList As String
	Return "none|neutral|primary|secondary|accent|info|success|warning|error"
End Sub

Public Sub NormalizeVariant(Name As String) As String
	If Name = Null Then Return "none"
	Dim v As String = Name.ToLowerCase.Trim
	If v.StartsWith("variant-") Then v = v.SubString(8)
	If v.StartsWith("badge-") Then v = v.SubString(6)
	If v = "" Then v = "none"
	Select Case v
		Case "none", "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
			Return v
		Case Else
			Return "none"
	End Select
End Sub

Public Sub BuildVariantMap(BackColor As Int, TextColor As Int) As Map
	Dim vm As Map
	vm.Initialize
	vm.Put("back", BackColor)
	vm.Put("text", TextColor)
	vm.Put("muted", Blend(TextColor, xui.Color_Gray, 0.35))
	Return vm
End Sub

Public Sub DefaultPalette As Map
	Return GetVariantPalette
End Sub

Public Sub ResolveVariantMap(Palette As Map, VariantName As String) As Map
	Dim pal As Map = IIf(Palette.IsInitialized, Palette, DefaultPalette)
	Dim key As String = NormalizeVariant(VariantName)
	If pal.ContainsKey(key) Then Return pal.Get(key)
	If pal.ContainsKey("neutral") Then Return pal.Get("neutral")
	Return BuildVariantMap(0xFFE5E7EB, 0xFF111827)
End Sub

Public Sub ResolveVariantColor(Palette As Map, VariantName As String, Key As String, DefaultColor As Int) As Int
	Dim keyVariant As String = NormalizeVariant(VariantName)
	'The explicit "none" variant means "don't apply a semantic palette color".
	If keyVariant = "none" Then Return DefaultColor
	Dim vm As Map = ResolveVariantMap(Palette, keyVariant)
	If vm.ContainsKey(Key) Then
		Dim o As Object = vm.Get(Key)
		If o <> Null Then Return o
	End If
	Return DefaultColor
End Sub

' Resolves background color from either:
' 1) Daisy/Tailwind-like token strings (for example: bg-base-100, bg-base-content), or
' 2) semantic variant names (primary, success, etc).
' Token lookups are read from the active theme.
Public Sub ResolveBackgroundColorVariantFromPalette(Palette As Map, VariantOrToken As String, DefaultColor As Int) As Int
	Return ResolveColorVariantFromPalette(Palette, VariantOrToken, "back", DefaultColor)
End Sub

Public Sub ResolveTextColorVariantFromPalette(Palette As Map, VariantOrToken As String, DefaultColor As Int) As Int
	Return ResolveColorVariantFromPalette(Palette, VariantOrToken, "text", DefaultColor)
End Sub

Public Sub ResolveBorderColorVariantFromPalette(Palette As Map, VariantOrToken As String, DefaultColor As Int) As Int
	Return ResolveColorVariantFromPalette(Palette, VariantOrToken, "border", DefaultColor)
End Sub

Public Sub ResolveBackgroundColorVariant(VariantOrToken As String, DefaultColor As Int) As Int
	Return ResolveBackgroundColorVariantFromPalette(DefaultPalette, VariantOrToken, DefaultColor)
End Sub

Public Sub ResolveTextColorVariant(VariantOrToken As String, DefaultColor As Int) As Int
	Return ResolveTextColorVariantFromPalette(DefaultPalette, VariantOrToken, DefaultColor)
End Sub

Public Sub ResolveBorderColorVariant(VariantOrToken As String, DefaultColor As Int) As Int
	Return ResolveBorderColorVariantFromPalette(DefaultPalette, VariantOrToken, DefaultColor)
End Sub

Public Sub ResolveColorVariantFromPalette(Palette As Map, VariantOrToken As String, PaletteKey As String, DefaultColor As Int) As Int
	If VariantOrToken = Null Then Return DefaultColor
	Dim name As String = VariantOrToken.Trim
	If name.Length = 0 Then Return DefaultColor

	Dim token As String = ResolveThemeColorTokenName(name)
	If token.Length > 0 Then
		Return GetTokenColor(token, DefaultColor)
	End If

	Return ResolveVariantColor(Palette, name, PaletteKey, DefaultColor)
End Sub

Public Sub ResolveOnlineColor(VariantName As String, DefaultColor As Int) As Int
	Return ResolveVariantColor(DefaultPalette, VariantName, "back", DefaultColor)
End Sub

Public Sub ResolveOfflineColor(VariantName As String, DefaultColor As Int) As Int
	Dim c As Int = ResolveOnlineColor(VariantName, DefaultColor)
	Return Blend(c, xui.Color_Gray, 0.55)
End Sub

Public Sub Blend(c1 As Int, c2 As Int, t As Double) As Int
	Dim r1 As Int = Bit.And(Bit.ShiftRight(c1, 16), 0xFF)
	Dim g1 As Int = Bit.And(Bit.ShiftRight(c1, 8), 0xFF)
	Dim b1 As Int = Bit.And(c1, 0xFF)
	Dim r2 As Int = Bit.And(Bit.ShiftRight(c2, 16), 0xFF)
	Dim g2 As Int = Bit.And(Bit.ShiftRight(c2, 8), 0xFF)
	Dim b2 As Int = Bit.And(c2, 0xFF)
	Return xui.Color_RGB(r1 + (r2-r1)*t, g1 + (g2-g1)*t, b1 + (b2-b1)*t)
End Sub

Public Sub ShadowList As String
	'Matches Daisy usage of Tailwind shadow utility levels.
	Return "none|xs|sm|md|lg|xl|2xl"
End Sub

Public Sub NormalizeShadow(Name As String) As String
	If Name = Null Then Return "none"
	Dim v As String = Name.ToLowerCase.Trim
	If v.StartsWith("shadow-") Then v = v.SubString(7)
	If v = "shadow" Then v = "sm"
	If v = "" Then v = "none"
	Select Case v
		Case "none", "xs", "sm", "md", "lg", "xl", "2xl"
			Return v
		Case Else
			Return "none"
	End Select
End Sub

Public Sub ResolveShadowElevation(Level As String) As Float
	'Android-style elevation approximation for Tailwind shadow levels.
	Select Case NormalizeShadow(Level)
		Case "none"
			Return 0
		Case "xs"
			Return 1dip
		Case "sm"
			Return 2dip
		Case "md"
			Return 4dip
		Case "lg"
			Return 8dip
		Case "xl"
			Return 12dip
		Case "2xl"
			Return 16dip
		Case Else
			Return 0
	End Select
End Sub

Public Sub ResolveShadowSpec(Level As String) As Map
	'Tailwind 4 shadow tokens used by Daisy utility classes (px units).
	Select Case NormalizeShadow(Level)
		Case "xs"
			Return BuildShadowSpec(1, 2, 0, 0.05, 0, 0, 0, 0)
		Case "sm"
			Return BuildShadowSpec(1, 3, 0, 0.10, 1, 2, -1, 0.10)
		Case "md"
			Return BuildShadowSpec(4, 6, -1, 0.10, 2, 4, -2, 0.10)
		Case "lg"
			Return BuildShadowSpec(10, 15, -3, 0.10, 4, 6, -4, 0.10)
		Case "xl"
			Return BuildShadowSpec(20, 25, -5, 0.10, 8, 10, -6, 0.10)
		Case "2xl"
			Return BuildShadowSpec(25, 50, -12, 0.25, 0, 0, 0, 0)
		Case Else
			Return BuildShadowSpec(0, 0, 0, 0, 0, 0, 0, 0)
	End Select
End Sub

Public Sub MaskList As String
	Return "circle|square|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2"
End Sub

Public Sub MaskListSimple As String
	Return "circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2"
End Sub

Public Sub NormalizeMask(MaskName As String) As String
	If MaskName = Null Then Return "circle"
	Dim m As String = MaskName.ToLowerCase.Trim
	If m.StartsWith("mask-") Then m = m.SubString(5)
	Select Case m
		Case "circle", "square", "rounded-none", "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full", "squircle", "decagon", "diamond", "heart", "hexagon", "hexagon-2", "pentagon", "star", "star-2", "triangle", "triangle-2", "triangle-3", "triangle-4", "half-1", "half-2"
			Return m
		Case Else
			Return "circle"
	End Select
End Sub

Public Sub CreateMaskPath(Size As Float, MaskName As String) As B4XPath
	Return CreateMaskPathRect(Size, Size, MaskName)
End Sub

Public Sub CreateMaskPathRect(Width As Float, Height As Float, MaskName As String) As B4XPath
	Dim r As B4XRect
	r.Initialize(0, 0, Width, Height)
	Return CreateMaskPathInRect(r, MaskName)
End Sub

Public Sub CreateMaskPathInRect(TargetRect As B4XRect, MaskName As String) As B4XPath
	Dim m As String = NormalizeMask(MaskName)
	Dim s As Float = Min(TargetRect.Width, TargetRect.Height)
	Dim ox As Float = TargetRect.Left + (TargetRect.Width - s) / 2
	Dim oy As Float = TargetRect.Top + (TargetRect.Height - s) / 2
	Select Case m
		Case "circle"
			Dim r As B4XRect
			r.Initialize(ox, oy, ox + s, oy + s)
			Dim p As B4XPath
			p.InitializeOval(r)
			Return p
		Case "squircle"
			Return CreateDaisySquirclePathAt(s, ox, oy)
		Case "square"
			Return CreateRectPathAt(s, ox, oy)
		Case "rounded-none", "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full"
			Dim rrRound As B4XRect
			rrRound.Initialize(TargetRect.Left, TargetRect.Top, TargetRect.Right, TargetRect.Bottom)
			Dim baseSize As Float = Min(rrRound.Width, rrRound.Height)
			If m = "rounded-full" Then
				Dim pFull As B4XPath
				pFull.InitializeRoundedRect(rrRound, baseSize / 2)
				Return pFull
			End If
			Dim radius As Float = ResolveRoundedRadiusDip(m, baseSize)
			If radius <= 0 Then
				Dim pRect As B4XPath
				pRect.Initialize(rrRound.Left, rrRound.Top)
				pRect.LineTo(rrRound.Right, rrRound.Top)
				pRect.LineTo(rrRound.Right, rrRound.Bottom)
				pRect.LineTo(rrRound.Left, rrRound.Bottom)
				pRect.LineTo(rrRound.Left, rrRound.Top)
				Return pRect
			End If
			Dim pRound As B4XPath
			pRound.InitializeRoundedRect(rrRound, radius)
			Return pRound
		Case "decagon", "diamond", "hexagon", "hexagon-2", "pentagon", "star", "star-2", "triangle", "triangle-2", "triangle-3", "triangle-4"
			Return CreateDaisyPolygonMaskAt(m, s, ox, oy)
		Case "heart"
			Return CreateDaisyHeartPathAt(s, ox, oy)
		Case "half-1"
			Return CreateHalfRectPathAt(s, True, ox, oy)
		Case "half-2"
			Return CreateHalfRectPathAt(s, False, ox, oy)
		Case Else
			Dim re As B4XRect
			re.Initialize(ox, oy, ox + s, oy + s)
			Dim pe As B4XPath
			pe.InitializeOval(re)
			Return pe
	End Select
End Sub

Public Sub ResolveRoundedRadiusDip(MaskName As String, Size As Float) As Float
	Select Case MaskName
		Case "rounded-none"
			Return 0
		Case "rounded-sm"
			Return Min(Size / 2, 2dip)
		Case "rounded"
			Return Min(Size / 2, 4dip)
		Case "rounded-md"
			Return Min(Size / 2, 6dip)
		Case "rounded-lg"
			Return Min(Size / 2, 8dip)
		Case "rounded-xl"
			Return Min(Size / 2, 12dip)
		Case "rounded-2xl"
			Return Min(Size / 2, 16dip)
		Case "rounded-3xl"
			Return Min(Size / 2, 24dip)
		Case "rounded-full"
			Return Size / 2
		Case Else
			Return Min(Size / 2, 4dip)
	End Select
End Sub

'Matches DaisyUI mask-squircle SVG path:
'M100 0C20 0 0 20 0 100s20 100 100 100 100-20 100-100S180 0 100 0Z
Private Sub CreateDaisySquirclePathAt(Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim scale As Float = Size / 200
	Dim p As B4XPath
	p.Initialize(OffsetX + 100 * scale, OffsetY)
	AppendCubicApprox(p, OffsetX, OffsetY, scale, 100, 0, 20, 0, 0, 20, 0, 100, 16)
	AppendCubicApprox(p, OffsetX, OffsetY, scale, 0, 100, 0, 180, 20, 200, 100, 200, 16)
	AppendCubicApprox(p, OffsetX, OffsetY, scale, 100, 200, 180, 200, 200, 180, 200, 100, 16)
	AppendCubicApprox(p, OffsetX, OffsetY, scale, 200, 100, 200, 20, 180, 0, 100, 0, 16)
	Return p
End Sub

'Matches DaisyUI mask-heart SVG path (viewBox 200x185).
Private Sub CreateDaisyHeartPathAt(Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim sourceW As Float = 200
	Dim sourceH As Float = 185
	Dim scale As Float = Min(Size / sourceW, Size / sourceH)
	Dim renderW As Float = sourceW * scale
	Dim renderH As Float = sourceH * scale
	Dim x0 As Float = OffsetX + (Size - renderW) / 2
	Dim y0 As Float = OffsetY + (Size - renderH) / 2
	Dim p As B4XPath
	p.Initialize(x0 + 100 * scale, y0 + 184.606 * scale)

	AppendSvgArcApprox(p, x0, y0, scale, 100, 184.606, 15.384, 15.384, 0, 0, 1, 91.347, 181.928, 20)
	AppendCubicApprox(p, x0, y0, scale, 91.347, 181.928, 53.565, 156.28, 37.205, 138.695, 28.182, 127.7, 18)
	AppendCubicApprox(p, x0, y0, scale, 28.182, 127.7, 8.952, 104.264, -0.254, 80.202, 0.005, 54.146, 18)
	AppendCubicApprox(p, x0, y0, scale, 0.005, 54.146, 0.308, 24.287, 24.264, 0, 53.406, 0, 18)
	AppendCubicApprox(p, x0, y0, scale, 53.406, 0, 74.598, 0, 89.275, 11.937, 97.822, 21.879, 14)
	AppendSvgArcApprox(p, x0, y0, scale, 97.822, 21.879, 2.884, 2.884, 0, 0, 0, 102.178, 21.879, 10)
	AppendCubicApprox(p, x0, y0, scale, 102.178, 21.879, 110.725, 11.927, 125.402, 0, 146.594, 0, 14)
	AppendCubicApprox(p, x0, y0, scale, 146.594, 0, 175.736, 0, 199.692, 24.287, 199.994, 54.151, 18)
	AppendCubicApprox(p, x0, y0, scale, 199.994, 54.151, 200.254, 80.212, 191.038, 104.273, 171.818, 127.705, 18)
	AppendCubicApprox(p, x0, y0, scale, 171.818, 127.705, 162.795, 138.699, 146.435, 156.285, 108.653, 181.933, 18)
	AppendSvgArcApprox(p, x0, y0, scale, 108.653, 181.933, 15.384, 15.384, 0, 0, 1, 100, 184.606, 20)
	p.LineTo(x0 + 100 * scale, y0 + 184.606 * scale)
	Return p
End Sub

'Uses DaisyUI SVG geometry for polygon-style masks.
Private Sub CreateDaisyPolygonMaskAt(MaskName As String, Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Select Case MaskName
		Case "decagon"
			Return CreateSvgPolygonPathAt(192, 200, Array As Float( _
				96,0, 154.779,19.098, 191.106,69.098, 191.106,130.902, 154.779,180.902, _
				96,200, 37.221,180.902, 0.894,130.902, 0.894,69.098, 37.221,19.098), Size, OffsetX, OffsetY)
		Case "diamond"
			Return CreateSvgPolygonPathAt(200, 200, Array As Float(100,0, 200,100, 100,200, 0,100), Size, OffsetX, OffsetY)
		Case "hexagon"
			Return CreateDaisyHexagonPathAt(Size, OffsetX, OffsetY)
		Case "hexagon-2"
			Return CreateDaisyHexagon2PathAt(Size, OffsetX, OffsetY)
		Case "pentagon"
			Return CreateSvgPolygonPathAt(192, 181, Array As Float(96,0, 191.106,69.098, 154.779,180.902, 37.22,180.902, 0.894,69.098), Size, OffsetX, OffsetY)
		Case "star"
			Return CreateSvgPolygonPathAt(192, 180, Array As Float( _
				96,137.263, 37.221,179.287, 59.384,110.898, 0.894,68.481, 73.37,68.238, _
				96,0, 118.63,68.238, 191.106,68.481, 132.616,110.898, 154.779,179.287), Size, OffsetX, OffsetY)
		Case "star-2"
			Return CreateSvgPolygonPathAt(192, 180, Array As Float( _
				96,153.044, 37.221,179.287, 44.241,115.774, 0.894,68.481, 64.011,55.471, _
				96,0, 127.989,55.472, 191.106,68.482, 147.759,115.774, 154.779,179.287), Size, OffsetX, OffsetY)
		Case "triangle"
			Return CreateSvgPolygonPathAt(174, 149, Array As Float(87,148.476, 0.397,148.661, 43.86,74.423, 87,0, 130.14,74.423, 173.603,148.661), Size, OffsetX, OffsetY)
		Case "triangle-2"
			Return CreateSvgPolygonPathAt(174, 150, Array As Float(87,0.738, 173.603,0.554, 130.14,74.792, 87,149.214, 43.86,74.792, 0.397,0.554), Size, OffsetX, OffsetY)
		Case "triangle-3"
			Return CreateSvgPolygonPathAt(150, 174, Array As Float(149.369,87.107, 149.554,173.71, 75.315,130.247, 0.893,87.107, 75.315,43.967, 149.554,0.505), Size, OffsetX, OffsetY)
		Case "triangle-4"
			Return CreateSvgPolygonPathAt(150, 174, Array As Float(0.631,87.107, 0.446,0.505, 74.685,43.967, 149.107,87.107, 74.685,130.247, 0.446,173.71), Size, OffsetX, OffsetY)
		Case Else
			Return CreateRectPathAt(Size, OffsetX, OffsetY)
	End Select
End Sub

'Matches DaisyUI mask-hexagon SVG path (viewBox 182x201).
Private Sub CreateDaisyHexagonPathAt(Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim sourceW As Float = 182
	Dim sourceH As Float = 201
	Dim scale As Float = Min(Size / sourceW, Size / sourceH)
	Dim renderW As Float = sourceW * scale
	Dim renderH As Float = sourceH * scale
	Dim x0 As Float = OffsetX + (Size - renderW) / 2
	Dim y0 As Float = OffsetY + (Size - renderH) / 2

	Dim p As B4XPath
	p.Initialize(x0 + 0.3 * scale, y0 + 65.486 * scale)
	AppendCubicApprox(p, x0, y0, scale, 0.3,65.486, 0.3,56.29, 6.987,45.423, 14.511,40.408, 12)
	p.LineTo(x0 + 76.371 * scale, y0 + 4.462 * scale)
	AppendCubicApprox(p, x0, y0, scale, 76.371,4.462, 84.731,-0.554, 97.27,-0.554, 105.629,4.462, 12)
	p.LineTo(x0 + 167.489 * scale, y0 + 40.408 * scale)
	AppendCubicApprox(p, x0, y0, scale, 167.489,40.408, 175.849,45.423, 181.7,56.29, 181.7,65.486, 12)
	p.LineTo(x0 + 181.7 * scale, y0 + 136.541 * scale)
	AppendCubicApprox(p, x0, y0, scale, 181.7,136.541, 181.7,145.737, 175.013,156.604, 167.489,161.62, 12)
	p.LineTo(x0 + 105.629 * scale, y0 + 197.565 * scale)
	AppendCubicApprox(p, x0, y0, scale, 105.629,197.565, 97.269,201.745, 84.73,201.745, 76.371,197.565, 12)
	p.LineTo(x0 + 14.51 * scale, y0 + 161.62 * scale)
	AppendCubicApprox(p, x0, y0, scale, 14.51,161.62, 6.151,157.44, 0.3,145.737, 0.3,136.54, 12)
	p.LineTo(x0 + 0.3 * scale, y0 + 65.486 * scale)
	Return p
End Sub

'Matches DaisyUI mask-hexagon-2 SVG path (viewBox 200x182).
Private Sub CreateDaisyHexagon2PathAt(Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim sourceW As Float = 200
	Dim sourceH As Float = 182
	Dim scale As Float = Min(Size / sourceW, Size / sourceH)
	Dim renderW As Float = sourceW * scale
	Dim renderH As Float = sourceH * scale
	Dim x0 As Float = OffsetX + (Size - renderW) / 2
	Dim y0 As Float = OffsetY + (Size - renderH) / 2

	Dim p As B4XPath
	p.Initialize(x0 + 64.786 * scale, y0 + 181.4 * scale)
	AppendCubicApprox(p, x0, y0, scale, 64.786,181.4, 55.59,181.4, 44.723,174.713, 39.707,167.19, 12)
	p.LineTo(x0 + 3.762 * scale, y0 + 105.33 * scale)
	AppendCubicApprox(p, x0, y0, scale, 3.762,105.33, -1.254,96.97, -1.254,84.43, 3.762,76.071, 12)
	p.LineTo(x0 + 39.707 * scale, y0 + 14.211 * scale)
	AppendCubicApprox(p, x0, y0, scale, 39.707,14.211, 44.723,5.851, 55.59,0, 64.786,0, 12)
	p.LineTo(x0 + 135.841 * scale, y0 + 0 * scale)
	AppendCubicApprox(p, x0, y0, scale, 135.841,0, 145.037,0, 155.904,6.688, 160.92,14.211, 12)
	p.LineTo(x0 + 196.865 * scale, y0 + 76.071 * scale)
	AppendCubicApprox(p, x0, y0, scale, 196.865,76.071, 201.045,84.431, 201.045,96.97, 196.865,105.329, 12)
	p.LineTo(x0 + 160.92 * scale, y0 + 167.189 * scale)
	AppendCubicApprox(p, x0, y0, scale, 160.92,167.189, 156.74,175.549, 145.037,181.4, 135.841,181.4, 12)
	p.LineTo(x0 + 64.786 * scale, y0 + 181.4 * scale)
	Return p
End Sub

Private Sub CreateSvgPolygonPathAt(SourceWidth As Float, SourceHeight As Float, Points() As Float, Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim scale As Float = Min(Size / SourceWidth, Size / SourceHeight)
	Dim renderW As Float = SourceWidth * scale
	Dim renderH As Float = SourceHeight * scale
	Dim x0 As Float = OffsetX + (Size - renderW) / 2
	Dim y0 As Float = OffsetY + (Size - renderH) / 2
	Dim p As B4XPath
	p.Initialize(x0 + Points(0) * scale, y0 + Points(1) * scale)
	For i = 2 To Points.Length - 1 Step 2
		p.LineTo(x0 + Points(i) * scale, y0 + Points(i + 1) * scale)
	Next
	p.LineTo(x0 + Points(0) * scale, y0 + Points(1) * scale)
	Return p
End Sub

'Approximates a cubic bezier segment with line segments for B4XPath.
Private Sub AppendCubicApprox(Path As B4XPath, OffsetX As Float, OffsetY As Float, Scale As Float, _
	X0 As Float, Y0 As Float, X1 As Float, Y1 As Float, X2 As Float, Y2 As Float, X3 As Float, Y3 As Float, Steps As Int)
	Dim n As Int = Max(4, Steps)
	For i = 1 To n
		Dim t As Double = i / n
		Dim u As Double = 1 - t
		Dim x As Double = u * u * u * X0 + 3 * u * u * t * X1 + 3 * u * t * t * X2 + t * t * t * X3
		Dim y As Double = u * u * u * Y0 + 3 * u * u * t * Y1 + 3 * u * t * t * Y2 + t * t * t * Y3
		Path.LineTo(OffsetX + x * Scale, OffsetY + y * Scale)
	Next
End Sub

'Approximates an SVG elliptical arc segment with line segments.
Private Sub AppendSvgArcApprox(Path As B4XPath, OffsetX As Float, OffsetY As Float, Scale As Float, _
	X0 As Float, Y0 As Float, Rx As Float, Ry As Float, XAxisRotDeg As Float, LargeArcFlag As Int, SweepFlag As Int, X1 As Float, Y1 As Float, Steps As Int)
	Dim rx0 As Double = Abs(Rx)
	Dim ry0 As Double = Abs(Ry)
	If rx0 = 0 Or ry0 = 0 Then
		Path.LineTo(OffsetX + X1 * Scale, OffsetY + Y1 * Scale)
		Return
	End If
	Dim phi As Double = XAxisRotDeg * cPI / 180
	Dim cosPhi As Double = Cos(phi)
	Dim sinPhi As Double = Sin(phi)
	Dim dx2 As Double = (X0 - X1) / 2
	Dim dy2 As Double = (Y0 - Y1) / 2
	Dim x1p As Double = cosPhi * dx2 + sinPhi * dy2
	Dim y1p As Double = -sinPhi * dx2 + cosPhi * dy2

	Dim lambda As Double = (x1p * x1p) / (rx0 * rx0) + (y1p * y1p) / (ry0 * ry0)
	If lambda > 1 Then
		Dim scaleUp As Double = Sqrt(lambda)
		rx0 = rx0 * scaleUp
		ry0 = ry0 * scaleUp
	End If

	Dim rx2 As Double = rx0 * rx0
	Dim ry2 As Double = ry0 * ry0
	Dim num As Double = rx2 * ry2 - rx2 * y1p * y1p - ry2 * x1p * x1p
	Dim den As Double = rx2 * y1p * y1p + ry2 * x1p * x1p
	Dim factor As Double = 0
	If den <> 0 Then factor = Sqrt(Max(0, num / den))
	If LargeArcFlag = SweepFlag Then factor = -factor
	Dim cxp As Double = factor * (rx0 * y1p / ry0)
	Dim cyp As Double = factor * (-ry0 * x1p / rx0)

	Dim cx As Double = cosPhi * cxp - sinPhi * cyp + (X0 + X1) / 2
	Dim cy As Double = sinPhi * cxp + cosPhi * cyp + (Y0 + Y1) / 2

	Dim ux As Double = (x1p - cxp) / rx0
	Dim uy As Double = (y1p - cyp) / ry0
	Dim vx As Double = (-x1p - cxp) / rx0
	Dim vy As Double = (-y1p - cyp) / ry0

	Dim theta1 As Double = ATan2(uy, ux)
	Dim delta As Double = ATan2(ux * vy - uy * vx, ux * vx + uy * vy)
	If SweepFlag = 0 And delta > 0 Then delta = delta - 2 * cPI
	If SweepFlag = 1 And delta < 0 Then delta = delta + 2 * cPI

	Dim n As Int = Max(6, Steps)
	For i = 1 To n
		Dim t As Double = theta1 + delta * i / n
		Dim ct As Double = Cos(t)
		Dim st As Double = Sin(t)
		Dim x As Double = cx + cosPhi * rx0 * ct - sinPhi * ry0 * st
		Dim y As Double = cy + sinPhi * rx0 * ct + cosPhi * ry0 * st
		Path.LineTo(OffsetX + x * Scale, OffsetY + y * Scale)
	Next
End Sub

Private Sub CreateRectPathAt(Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim p As B4XPath
	p.Initialize(OffsetX, OffsetY)
	p.LineTo(OffsetX + Size, OffsetY)
	p.LineTo(OffsetX + Size, OffsetY + Size)
	p.LineTo(OffsetX, OffsetY + Size)
	p.LineTo(OffsetX, OffsetY)
	Return p
End Sub

Private Sub CreateHalfRectPathAt(Size As Float, LeftHalf As Boolean, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim x0 As Float = OffsetX + IIf(LeftHalf, 0, Size / 2)
	Dim x1 As Float = OffsetX + IIf(LeftHalf, Size / 2, Size)
	Dim y0 As Float = OffsetY
	Dim y1 As Float = OffsetY + Size
	Dim p As B4XPath
	p.Initialize(x0, y0)
	p.LineTo(x1, y0)
	p.LineTo(x1, y1)
	p.LineTo(x0, y1)
	p.LineTo(x0, y0)
	Return p
End Sub

' ============================================================
' Universal canvas clipping / view overflow utilities.
' Components should call these instead of duplicating native
' save/clipPath/restore and setClipChildren logic.
' ============================================================

' Clips a B4XCanvas to the shape defined by MaskName inside TargetRect.
' Call RestoreCanvasClip when done drawing to remove the clip.
' Returns True if the clip was applied, False if not (unsupported platform).
Public Sub ClipCanvasToShape(cvs As B4XCanvas, TargetRect As B4XRect, MaskName As String) As Boolean
	#If B4A
	' 1. Create the mask path
	Dim maskPath As B4XPath = CreateMaskPathInRect(TargetRect, MaskName)
	
	' 2. Extract the native android.graphics.Path from the B4XPath wrapper
	Dim joPath As JavaObject = maskPath
	Dim nativePath As JavaObject = joPath.RunMethod("getObject", Null)
	
	' 3. Drill down: B4XCanvas → B4A Canvas → android.graphics.Canvas
	Dim jo As JavaObject = cvs
	Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")
	Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas")
	
	' 4. Save and clip
	nativeCanvas.RunMethod("save", Null)
	nativeCanvas.RunMethod("clipPath", Array(nativePath))
	Return True
	#Else
	Dim ignoreCvs As Object = cvs
	Dim ignoreRect As Object = TargetRect
	Dim ignoreMask As String = MaskName
	Return False
	#End If
End Sub

' Restores the canvas state after a ClipCanvasToShape call.
' Must be called to undo the clip applied by ClipCanvasToShape.
Public Sub RestoreCanvasClip(cvs As B4XCanvas)
	#If B4A
	Dim jo As JavaObject = cvs
	Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")
	Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas")
	nativeCanvas.RunMethod("restore", Null)
	#Else
	Dim ignoreCvs As Object = cvs
	#End If
End Sub

' Disables clip-children and clip-to-padding on a B4XView,
' allowing child views or canvas drawings to overflow its bounds
' (e.g. pulse animations, status indicators, drop shadows).
Public Sub DisableViewClipping(v As B4XView)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setClipChildren", Array(False))
	jo.RunMethod("setClipToPadding", Array(False))
	#Else
	Dim ignore As Object = v
	#End If
End Sub

' Enables view-level shaped clipping (CSS overflow:hidden with a shape).
' Uses Android's ViewOutlineProvider + setClipToOutline to clip ALL children
' to the specified shape. This is the true overflow:hidden for non-rectangular bounds.
' NOTE: Android OutlineProvider only supports oval and rounded-rect shapes.
'       Complex masks (heart, hexagon, star etc.) are NOT supported at view level.
'       For those, use ClipCanvasToShape at the canvas drawing level instead.
Public Sub EnableShapedClipping(v As B4XView, MaskName As String)
	#If B4A
	Dim m As String = NormalizeMask(MaskName)
	Dim jo As JavaObject = v
	
	Select Case m
		Case "circle", "rounded-full"
			' Oval outline provider — clips to a perfect circle/ellipse
			Dim provider As JavaObject
			provider.InitializeNewInstance("anywheresoftware.b4a.objects.CustomViewWrapper.OvalOutlineProvider", Null)
			jo.RunMethod("setOutlineProvider", Array(provider))
			jo.RunMethod("setClipToOutline", Array(True))
		Case "rounded-none", "square"
			' Rectangular — just use default clip
			jo.RunMethod("setClipToOutline", Array(False))
		Case "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl"
			' Rounded-rect outline via corner radius
			Dim size As Float = Min(v.Width, v.Height)
			Dim radius As Float = ResolveRoundedRadiusDip(m, size)
			' Use background-based outline: set a rounded GradientDrawable,
			' Android will derive the outline from it automatically
			Dim gd As JavaObject
			gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
			gd.RunMethod("setCornerRadius", Array(radius))
			gd.RunMethod("setColor", Array(0))  ' Transparent — we only want the outline shape
			jo.RunMethod("setBackground", Array(gd))
			jo.RunMethod("setClipToOutline", Array(True))
		Case Else
			' Complex masks (squircle, heart, hexagon etc.)
			' Android OutlineProvider cannot clip to arbitrary paths.
			' Caller should use ClipCanvasToShape for these instead.
			jo.RunMethod("setClipToOutline", Array(False))
	End Select
	#Else
	Dim ignore As Object = v
	Dim ignoreMask As String = MaskName
	#End If
End Sub

' Disables any previously applied shaped clipping on a view.
' Resets to Android's default rectangular clip behavior.
Public Sub DisableShapedClipping(v As B4XView)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setClipToOutline", Array(False))
	#Else
	Dim ignore As Object = v
	#End If
End Sub

Private Sub BuildShadowSpec(Y1 As Float, Blur1 As Float, Spread1 As Float, Alpha1 As Double, Y2 As Float, Blur2 As Float, Spread2 As Float, Alpha2 As Double) As Map
	Dim m As Map
	m.Initialize
	m.Put("y1", Y1)
	m.Put("blur1", Blur1)
	m.Put("spread1", Spread1)
	m.Put("alpha1", Alpha1)
	m.Put("y2", Y2)
	m.Put("blur2", Blur2)
	m.Put("spread2", Spread2)
	m.Put("alpha2", Alpha2)
	Return m
End Sub

Public Sub NormalizeDateTimeFormat(Value As String, DefaultFlatpickrFormat As String) As String
	Dim fallback As String = "D, j M Y H:i"
	If DefaultFlatpickrFormat <> Null Then
		Dim candidate As String = DefaultFlatpickrFormat.Trim
		If candidate.Length > 0 Then fallback = candidate
	End If
	If Value = Null Then Return ConvertFlatpickrToDateFormat(fallback)
	Dim v As String = Value.Trim
	If v.Length = 0 Then Return ConvertFlatpickrToDateFormat(fallback)
	If LooksLikeJavaDateFormat(v) Then Return v
	Dim converted As String = ConvertFlatpickrToDateFormat(v)
	If converted.Length = 0 Then Return ConvertFlatpickrToDateFormat(fallback)
	Return converted
End Sub

Public Sub FormatDateTime(FormatText As String, ValueMillis As Long) As String
	Dim normalized As String = NormalizeDateTimeFormat(FormatText, "D, j M Y H:i")
	Dim prevFormat As String = DateTime.DateFormat
	DateTime.DateFormat = normalized
	Dim result As String = DateTime.Date(ValueMillis)
	DateTime.DateFormat = prevFormat
	If result.Contains(FLATPICKR_UNIX_PLACEHOLDER) Then
		Dim unixSeconds As Long = ValueMillis / DateTime.TicksPerSecond
		result = result.Replace(FLATPICKR_UNIX_PLACEHOLDER, unixSeconds)
	End If
	Return result
End Sub

Public Sub LooksLikeJavaDateFormat(FormatText As String) As Boolean
	Dim f As String = FormatText
	If f.Contains("yyyy") Or f.Contains("yyy") Then Return True
	If f.Contains("yy") Then Return True
	If f.Contains("MMMM") Or f.Contains("MMM") Or f.Contains("MM") Then Return True
	If f.Contains("dd") Then Return True
	If f.Contains("HH") Or f.Contains("hh") Then Return True
	If f.Contains("mm") Or f.Contains("ss") Then Return True
	If f.Contains("EEE") Then Return True
	Return False
End Sub

Public Sub ConvertFlatpickrToDateFormat(FormatText As String) As String
	If FormatText = Null Then Return ""
	Dim sb As StringBuilder
	sb.Initialize
	Dim inLiteral As Boolean = False
	Dim escaped As Boolean = False
	For i = 0 To FormatText.Length - 1
		Dim ch As String = FormatText.CharAt(i)
		If escaped Then
			If inLiteral = False Then
				sb.Append("'")
				inLiteral = True
			End If
			If ch = "'" Then sb.Append("''") Else sb.Append(ch)
			escaped = False
			Continue
		End If
		If ch = "\" Then
			escaped = True
			Continue
		End If
		Dim mapped As String = FlatpickrTokenToDateToken(ch)
		If mapped.Length > 0 Then
			If inLiteral Then
				sb.Append("'")
				inLiteral = False
			End If
			sb.Append(mapped)
		Else
			If IsAsciiLetter(ch) Then
				If inLiteral = False Then
					sb.Append("'")
					inLiteral = True
				End If
				If ch = "'" Then sb.Append("''") Else sb.Append(ch)
			Else
				If inLiteral Then
					sb.Append("'")
					inLiteral = False
				End If
				If ch = "'" Then sb.Append("''") Else sb.Append(ch)
			End If
		End If
	Next
	If inLiteral Then sb.Append("'")
	Return sb.ToString
End Sub

Private Sub FlatpickrTokenToDateToken(Token As String) As String
	Select Case Token
		Case "d"
			Return "dd"
		Case "D"
			Return "EEE"
		Case "j"
			Return "d"
		Case "l"
			Return "EEEE"
		Case "F"
			Return "MMMM"
		Case "m"
			Return "MM"
		Case "n"
			Return "M"
		Case "M"
			Return "MMM"
		Case "y"
			Return "yy"
		Case "Y"
			Return "yyyy"
		Case "H"
			Return "HH"
		Case "h"
			Return "hh"
		Case "G"
			Return "H"
		Case "i"
			Return "mm"
		Case "S"
			Return "ss"
		Case "K"
			Return "a"
		Case "w"
			Return "u"
		Case "J"
			Return "d"
		Case "U"
			Return "'" & FLATPICKR_UNIX_PLACEHOLDER & "'"
		Case Else
			Return ""
	End Select
End Sub

Private Sub IsAsciiLetter(ch As String) As Boolean
	If ch.Length = 0 Then Return False
	Dim c As Int = Asc(ch)
	Return (c >= 65 And c <= 90) Or (c >= 97 And c <= 122)
End Sub

Public Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Public Sub GetPropFloat(Props As Map, Key As String, DefaultValue As Float) As Float
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If o = Null Then Return DefaultValue
	Try
		If IsNumber(o) Then Return o
	Catch
	End Try
	Try
		Dim s As String = "" & o
		Return ParseCssLengthToPx(s, DefaultValue)
	Catch
		Return DefaultValue
	End Try
End Sub

Public Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If o = Null Then Return DefaultValue
	Try
		If IsNumber(o) Then Return o
	Catch
	End Try
	Try
		Dim s As String = "" & o
		Return ParseCssLengthToPx(s, DefaultValue)
	Catch
		Return DefaultValue
	End Try
End Sub

Public Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If o = Null Then Return DefaultValue
	Return o
End Sub

Public Sub TailwindSizeToPx(Value As Object, DefaultPx As Float) As Float
	If Value = Null Then Return Max(0, DefaultPx)
	If Value Is String Then
		Dim raw As String = Value
		Dim s As String = raw.ToLowerCase.Trim
		If s.Length = 0 Then Return Max(0, DefaultPx)
		
		'Accept class-like tokens: w-12, h-12, size-12.
		If s.StartsWith("w-") Or s.StartsWith("h-") Or s.StartsWith("size-") Then
			Dim p As Int = s.LastIndexOf("-")
			If p >= 0 And p < s.Length - 1 Then s = s.SubString(p + 1)
		End If
	
		'Accept bracket notation: [80px], [5rem], [12]
		If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
			s = s.SubString2(1, s.Length - 1).Trim
		End If
	
		If s = "full" Or s = "screen" Then s = "100%"
		If s = "auto" Then Return Max(0, DefaultPx)
	
		If s.EndsWith("%") Then
			Dim pctText As String = s.SubString2(0, s.Length - 1).Trim
			Dim npct As Double = ParseCssNumber(pctText, -1)
			If npct >= 0 Then Return Max(0, DefaultPx * npct / 100)
			Return Max(0, DefaultPx)
		End If
	
		If s.EndsWith("px") Then
			Dim npx As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
			If npx >= 0 Then Return npx
			Return Max(0, DefaultPx)
		End If
	
		If s.EndsWith("rem") Then
			Dim nrem As Double = ParseCssNumber(s.SubString2(0, s.Length - 3), -1)
			If nrem >= 0 Then Return nrem * CSS_BASE_FONT_PX
			Return Max(0, DefaultPx)
		End If
	
		If s.EndsWith("em") Then
			Dim nem As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
			If nem >= 0 Then Return nem * CSS_BASE_FONT_PX
			Return Max(0, DefaultPx)
		End If
	
		'Bare numbers in strings are Tailwind spacing tokens: "12" -> 12 * 0.25rem -> 48px.
		Dim ntw As Double = ParseCssNumber(s, -1)
		If ntw >= 0 Then Return ntw * TW_SPACE_STEP_PX
		Return Max(0, DefaultPx)
	Else If IsNumber(Value) Then
		'If the value is already a numeric type (Int/Float from a variable), treat it as a literal pixel/dip value.
		Dim pf As Float = Value
		Return Max(0, pf)
	End If
	Return Max(0, DefaultPx)
End Sub

Public Sub TailwindSizeToDip(Value As Object, DefaultDip As Float) As Float
	Dim defaultPx As Float = Max(0, DefaultDip / 1dip)
	Dim px As Float = TailwindSizeToPx(Value, defaultPx)
	Return px * 1dip
End Sub

' Resolves Tailwind spacing values (including gap tokens) to pixels.
' Supports: px, rem, em, %, bracket notation, bare scale numbers, and utility prefixes.
Public Sub TailwindSpacingToPx(Value As Object, DefaultPx As Float) As Float
	If Value = Null Then Return Max(0, DefaultPx)

	Dim raw As String = Value
	Dim s As String = raw.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, DefaultPx)

	Dim token As String = NormalizeSpacingValueToken(s)
	If token.Length = 0 Then Return Max(0, DefaultPx)

	' Tailwind spacing special token.
	If token = "px" Then Return 1

	' Accept bracket notation: [80px], [5rem], [12]
	If token.StartsWith("[") And token.EndsWith("]") And token.Length > 2 Then
		token = token.SubString2(1, token.Length - 1).Trim
	End If

	If token.EndsWith("%") Then
		Dim npct As Double = ParseCssNumber(token.SubString2(0, token.Length - 1), -1)
		If npct >= 0 Then Return Max(0, DefaultPx * npct / 100)
		Return Max(0, DefaultPx)
	End If
	If token.EndsWith("px") Then
		Dim npx As Double = ParseCssNumber(token.SubString2(0, token.Length - 2), -1)
		If npx >= 0 Then Return npx
		Return Max(0, DefaultPx)
	End If
	If token.EndsWith("rem") Then
		Dim nrem As Double = ParseCssNumber(token.SubString2(0, token.Length - 3), -1)
		If nrem >= 0 Then Return nrem * CSS_BASE_FONT_PX
		Return Max(0, DefaultPx)
	End If
	If token.EndsWith("em") Then
		Dim nem As Double = ParseCssNumber(token.SubString2(0, token.Length - 2), -1)
		If nem >= 0 Then Return nem * CSS_BASE_FONT_PX
		Return Max(0, DefaultPx)
	End If

	' Bare numbers follow Tailwind v4 spacing: calc(var(--spacing) * n).
	Dim n As Double = ParseCssNumber(token, -1)
	If n >= 0 Then Return n * ResolveSpacingStepPx
	Return Max(0, DefaultPx)
End Sub

Public Sub TailwindSpacingToDip(Value As Object, DefaultDip As Float) As Float
	Dim defaultPx As Float = Max(0, DefaultDip / 1dip)
	Dim px As Float = TailwindSpacingToPx(Value, defaultPx)
	Return px * 1dip
End Sub

Public Sub TailwindGapToDip(Value As Object, DefaultDip As Float) As Float
	Return TailwindSpacingToDip(Value, DefaultDip)
End Sub

' Parses utility strings like "gap-2", "gap-x-4", "gap-y-1.5".
' Returns map keys: gap_x, gap_y, gap.
Public Sub ParseGapUtilities(Utilities As String, DefaultGapDip As Float) As Map
	Dim gx As Float = Max(0, DefaultGapDip)
	Dim gy As Float = Max(0, DefaultGapDip)
	Dim m As Map
	m.Initialize

	Dim raw As String = IIf(Utilities = Null, "", Utilities.Trim)
	If raw.Length = 0 Then
		m.Put("gap_x", gx)
		m.Put("gap_y", gy)
		m.Put("gap", (gx + gy) / 2)
		Return m
	End If

	Dim tokens() As String = Regex.Split("\s+", raw)
	For Each t As String In tokens
		Dim u As String = t.ToLowerCase.Trim
		If u.StartsWith("gap-x-") Then
			gx = TailwindSpacingToDip(u.SubString(6), gx)
		Else If u.StartsWith("gap-y-") Then
			gy = TailwindSpacingToDip(u.SubString(6), gy)
		Else If u.StartsWith("gap-") Then
			Dim gv As Float = TailwindSpacingToDip(u.SubString(4), (gx + gy) / 2)
			gx = gv
			gy = gv
		End If
	Next

	m.Put("gap_x", gx)
	m.Put("gap_y", gy)
	m.Put("gap", (gx + gy) / 2)
	Return m
End Sub

Public Sub BorderStyleList As String
	Return "solid|dashed|dotted|double|hidden|none"
End Sub

' Resolves Tailwind border width tokens (v4-friendly) to dip.
' Supports: border, border-2, border-[3px], border-[0.125rem], border-px, bare numeric values.
Public Sub TailwindBorderWidthToDip(Value As Object, DefaultDip As Float) As Float
	If Value = Null Then Return Max(0, DefaultDip)
	Dim raw As String = Value
	Dim s As String = NormalizeUtilityToken(raw.ToLowerCase.Trim)
	If s.Length = 0 Then Return Max(0, DefaultDip)

	If s = "border" Then Return Max(0, GetBorderDip(IIf(DefaultDip > 0, DefaultDip, 1dip)))
	If s.StartsWith("border-") Then
		Dim rest As String = s.SubString(7)
		Dim sideParsed As Map = ParseBorderSideScope(rest)
		If sideParsed.GetDefault("has_scope", False) Then rest = sideParsed.GetDefault("value", "")
		If rest.Length = 0 Then Return Max(0, GetBorderDip(IIf(DefaultDip > 0, DefaultDip, 1dip)))
		s = rest
	End If

	If s = "px" Then Return 1dip
	If s = "thin" Then Return 1dip
	If s = "medium" Then Return 3dip
	If s = "thick" Then Return 5dip

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.StartsWith("(") And s.EndsWith(")") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.Contains("--border") Then Return Max(0, GetBorderDip(IIf(DefaultDip > 0, DefaultDip, 1dip)))
	If s.StartsWith("--") Then Return Max(0, GetTokenDip(s, DefaultDip))

	Dim px As Float = ParseCssLengthToPx(s, -1)
	If px >= 0 Then Return Max(0, px * 1dip)
	Return Max(0, DefaultDip)
End Sub

' Resolves Tailwind rounded tokens to dip.
' Supports: rounded, rounded-sm/md/lg/xl/2xl/3xl/4xl/full/none, rounded-[10px], and Daisy rounded-box|field|selector.
Public Sub TailwindBorderRadiusToDip(Value As Object, DefaultDip As Float) As Float
	If Value = Null Then Return Max(0, DefaultDip)
	Dim raw As String = Value
	Dim s As String = NormalizeUtilityToken(raw.ToLowerCase.Trim)
	If s.Length = 0 Then Return Max(0, DefaultDip)
	If s.StartsWith("rounded-") Then s = s.SubString(8)

	Select Case s
		Case "", "default"
			Return 4dip
		Case "none"
			Return 0
		Case "sm"
			Return 2dip
		Case "md"
			Return 6dip
		Case "lg"
			Return 8dip
		Case "xl"
			Return 12dip
		Case "2xl"
			Return 16dip
		Case "3xl"
			Return 24dip
		Case "4xl"
			Return 32dip
		Case "full"
			Return 9999dip
		Case "box"
			Return Max(0, GetRadiusBoxDip(IIf(DefaultDip > 0, DefaultDip, 8dip)))
		Case "field"
			Return Max(0, GetRadiusFieldDip(IIf(DefaultDip > 0, DefaultDip, 6dip)))
		Case "selector"
			Return Max(0, GetRadiusSelectorDip(IIf(DefaultDip > 0, DefaultDip, 4dip)))
	End Select

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	Dim px As Float = ParseCssLengthToPx(s, -1)
	If px >= 0 Then Return Max(0, px * 1dip)
	Return Max(0, DefaultDip)
End Sub

' Resolves Tailwind border color tokens (including optional /opacity suffix) to a B4X color.
' Supports Daisy theme tokens, variant names, hex/rgb/rgba, common color names, and Tailwind hue-shade names.
Public Sub TailwindBorderColorToColor(Value As String, DefaultColor As Int) As Int
	If Value = Null Then Return DefaultColor
	Dim token As String = NormalizeUtilityToken(Value.ToLowerCase.Trim)
	If token.Length = 0 Then Return DefaultColor

	If token.StartsWith("border-") Then token = token.SubString(7)
	Dim scopeInfo As Map = ParseBorderSideScope(token)
	If scopeInfo.GetDefault("has_scope", False) Then token = scopeInfo.GetDefault("value", "")
	If token.Length = 0 Then Return DefaultColor

	Return ResolveUtilityColorWithOpacity(token, DefaultColor)
End Sub

' Parses utility strings such as:
' border, border-2, border-x-4, border-t, border-s, border-[3px],
' border-solid|dashed|dotted|double|hidden|none,
' border-primary/30, border-[#1f2937]/50, border-red-500,
' rounded, rounded-lg, rounded-t-md, rounded-ss-xl, rounded-[12px], rounded-t-box.
' Returns a map with width/color/style for all sides and corner radii.
Public Sub ParseBorderUtilities(Utilities As String, DefaultBorderDip As Float, DefaultBorderColor As Int, DefaultRadiusDip As Float, RtlEnabled As Boolean) As Map
	Dim spec As Map = CreateDefaultBorderSpec(DefaultBorderDip, DefaultBorderColor, DefaultRadiusDip)
	Dim raw As String = IIf(Utilities = Null, "", Utilities.Trim)
	If raw.Length = 0 Then Return spec

	Dim hasUtility As Boolean = False
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each part As String In parts
		Dim u As String = NormalizeUtilityToken(part.ToLowerCase.Trim)
		If u.Length = 0 Then Continue
		If u.StartsWith("border") Then
			If ApplyBorderUtilityToken(spec, u, RtlEnabled) Then hasUtility = True
		Else If u.StartsWith("rounded") Then
			If ApplyRoundedUtilityToken(spec, u, RtlEnabled) Then hasUtility = True
		End If
	Next

	spec.Put("has_border_utility", hasUtility)
	SyncBorderAggregate(spec)
	SyncRadiusAggregate(spec)
	Return spec
End Sub

' Applies parsed border/radius values to a box model map.
' For non-uniform side widths, border_width uses the max side to avoid clipping.
Public Sub ApplyBorderSpecToBoxModel(Model As Map, BorderSpec As Map)
	If Model.IsInitialized = False Or BorderSpec.IsInitialized = False Then Return
	SyncBorderAggregate(BorderSpec)
	SyncRadiusAggregate(BorderSpec)

	Dim tw As Float = Max(0, BorderSpec.GetDefault("border_top_width", 0))
	Dim rw As Float = Max(0, BorderSpec.GetDefault("border_right_width", 0))
	Dim bw As Float = Max(0, BorderSpec.GetDefault("border_bottom_width", 0))
	Dim lw As Float = Max(0, BorderSpec.GetDefault("border_left_width", 0))
	Dim uniformW As Boolean = BorderSpec.GetDefault("border_uniform_width", False)
	Dim resolvedW As Float = IIf(uniformW, tw, Max(Max(tw, rw), Max(bw, lw)))

	Dim style As String = BorderSpec.GetDefault("border_style", "solid")
	If style = "none" Or style = "hidden" Then resolvedW = 0

	Model.Put("border_width", resolvedW)
	Model.Put("radius", Max(0, BorderSpec.GetDefault("radius", 0)))
	Model.Put("radius_tl", Max(0, BorderSpec.GetDefault("radius_tl", 0)))
	Model.Put("radius_tr", Max(0, BorderSpec.GetDefault("radius_tr", 0)))
	Model.Put("radius_br", Max(0, BorderSpec.GetDefault("radius_br", 0)))
	Model.Put("radius_bl", Max(0, BorderSpec.GetDefault("radius_bl", 0)))
End Sub

Public Sub TailwindTextMetrics(Value As Object, DefaultFontSize As Float, DefaultLineHeightPx As Float) As Map
	Dim defaultFont As Float = Max(1, DefaultFontSize)
	Dim defaultLine As Float = Max(defaultFont, DefaultLineHeightPx)
	Dim textToken As String = ""
	Dim leadingToken As String = ""

	If Value <> Null Then
		Dim raw As String = Value
		Dim s As String = raw.Trim
		If s.Length > 0 Then
			Dim parts() As String = Regex.Split("\s+", s)
			For Each p As String In parts
				Dim t As String = NormalizeUtilityToken(p)
				If t.Length = 0 Then Continue
				If textToken.Length = 0 And t.StartsWith("text-") Then
					textToken = t
				Else If leadingToken.Length = 0 And t.StartsWith("leading-") Then
					leadingToken = t
				End If
			Next
			If textToken.Length = 0 Then textToken = NormalizeUtilityToken(s)
		End If
	End If

	Dim sizeInfo As Map = ResolveTailwindTextToken(textToken, defaultFont, defaultLine)
	Dim fontSize As Float = sizeInfo.GetDefault("font_size", defaultFont)
	Dim linePx As Float = sizeInfo.GetDefault("line_height_px", defaultLine)
	Dim slashLeading As String = sizeInfo.GetDefault("leading_spec", "")
	If slashLeading.Length > 0 Then
		linePx = ResolveLeadingSpecToPx(slashLeading, fontSize, linePx)
	Else If leadingToken.Length > 0 Then
		linePx = ResolveLeadingSpecToPx(leadingToken, fontSize, linePx)
	End If

	Dim result As Map
	result.Initialize
	result.Put("font_size", fontSize)
	result.Put("font_size_dip", fontSize * 1dip)
	result.Put("line_height_px", linePx)
	result.Put("line_height_dip", linePx * 1dip)
	Return result
End Sub

Public Sub GetGlassSpec As Map
	' Returns active glass style values resolved from theme tokens.
	Dim m As Map
	m.Initialize
	Dim blurDip As Float = GetTokenDip("--glass-blur", 40dip)
	Dim glassOpacity As Float = ParsePercent01(GetTokenString("--glass-opacity", "30%"), 0.3)
	Dim reflectDegree As Float = GetTokenNumber("--glass-reflect-degree", 100)
	Dim reflectOpacity As Float = ParsePercent01(GetTokenString("--glass-reflect-opacity", "5%"), 0.05)
	Dim borderOpacity As Float = ParsePercent01(GetTokenString("--glass-border-opacity", "20%"), 0.2)
	Dim textShadowOpacity As Float = ParsePercent01(GetTokenString("--glass-text-shadow-opacity", "5%"), 0.05)
	m.Put("blur_dip", blurDip)
	m.Put("opacity", glassOpacity)
	m.Put("reflect_degree", reflectDegree)
	m.Put("reflect_opacity", reflectOpacity)
	m.Put("border_opacity", borderOpacity)
	m.Put("text_shadow_opacity", textShadowOpacity)
	Return m
End Sub

Public Sub ApplyGlassStyle(Target As B4XView, RadiusDip As Float)
	' Approximate daisy .glass style for B4X views.
	If Target.IsInitialized = False Then Return
	Dim spec As Map = GetGlassSpec
	Dim bgAlpha As Float = Max(0, Min(1, spec.GetDefault("opacity", 0.3)))
	Dim borderAlpha As Float = Max(0, Min(1, spec.GetDefault("border_opacity", 0.2)))
	Dim back As Int = AlphaColor(xui.Color_White, bgAlpha)
	Dim stroke As Int = AlphaColor(xui.Color_White, borderAlpha)
	Dim rd As Float = Max(0, RadiusDip)

	#If B4A
	If TryApplyGlassNative(Target, rd, bgAlpha, borderAlpha) Then Return
	#End If

	' Fallback for non-B4A / native failure.
	Target.SetColorAndBorder(back, Max(1dip, GetBorderDip(1dip)), stroke, rd)
End Sub

Public Sub ApplyGlassTextStyle(TextTarget As B4XView)
	' Applies subtle text shadow style where available.
	If TextTarget.IsInitialized = False Then Return
	Dim spec As Map = GetGlassSpec
	Dim a As Float = Max(0, Min(1, spec.GetDefault("text_shadow_opacity", 0.05)))
	#If B4A
	Try
		Dim j As JavaObject = TextTarget
		Dim shadowColor As Int = AlphaColor(xui.Color_Black, a)
		j.RunMethod("setShadowLayer", Array As Object(1dip, 0, 1dip, shadowColor))
	Catch
	End Try
	#End If
End Sub

Private Sub ParsePercent01(Value As String, DefaultValue As Float) As Float
	If Value = Null Then Return Max(0, Min(1, DefaultValue))
	Dim s As String = Value.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, Min(1, DefaultValue))
	If s.EndsWith("%") Then
		Dim n As String = s.SubString2(0, s.Length - 1).Trim
		If IsNumber(n) Then Return Max(0, Min(1, n / 100))
	End If
	If IsNumber(s) Then
		Dim v As Float = s
		If v > 1 Then v = v / 100
		Return Max(0, Min(1, v))
	End If
	Return Max(0, Min(1, DefaultValue))
End Sub

Private Sub AlphaColor(ColorValue As Int, Alpha01 As Float) As Int
	Dim a As Int = Max(0, Min(255, Round(255 * Max(0, Min(1, Alpha01)))))
	Dim r As Int = Bit.And(Bit.ShiftRight(ColorValue, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(ColorValue, 8), 0xFF)
	Dim b As Int = Bit.And(ColorValue, 0xFF)
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

#If B4A
Private Sub TryApplyGlassNative(Target As B4XView, RadiusDip As Float, BgOpacity As Float, BorderOpacity As Float) As Boolean
	Try
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(0)) 'RECTANGLE
		gd.RunMethod("setCornerRadius", Array(Max(0, RadiusDip)))
		gd.RunMethod("setColor", Array(0))
		gd.RunMethod("setStroke", Array(Max(1dip, GetBorderDip(1dip)), AlphaColor(xui.Color_White, BorderOpacity)))
		' 135deg highlight gradient: semi-white -> transparent.
		Dim ori As JavaObject
		ori.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
		gd.RunMethod("setOrientation", Array(ori.GetField("TL_BR")))
		Dim clr As Object = Array As Int(AlphaColor(xui.Color_White, BgOpacity), AlphaColor(xui.Color_White, 0))
		gd.RunMethod("setColors", Array(clr))

		Dim j As JavaObject = Target
		j.RunMethod("setBackground", Array(gd))
		' Small elevation approximation for glass depth.
		j.RunMethod("setElevation", Array(2dip))
		Return True
	Catch
		Return False
	End Try
End Sub
#End If

Public Sub TailwindTextFontSize(Value As Object, DefaultFontSize As Float) As Float
	Dim m As Map = TailwindTextMetrics(Value, DefaultFontSize, DefaultFontSize * 1.5)
	Return m.GetDefault("font_size", DefaultFontSize)
End Sub

Public Sub TailwindTextLineHeightDip(Value As Object, DefaultLineHeightDip As Float) As Float
	Dim defaultLinePx As Float = Max(1, DefaultLineHeightDip / 1dip)
	Dim m As Map = TailwindTextMetrics(Value, 14, defaultLinePx)
	Return m.GetDefault("line_height_dip", DefaultLineHeightDip)
End Sub

Private Sub ResolveTailwindTextToken(Token As String, DefaultFontSize As Float, DefaultLineHeightPx As Float) As Map
	Dim t As String = Token.ToLowerCase.Trim
	Dim leadingSpec As String = ""
	Dim pSlash As Int = t.IndexOf("/")
	If pSlash >= 0 Then
		leadingSpec = t.SubString(pSlash + 1).Trim
		t = t.SubString2(0, pSlash).Trim
	End If
	If t.StartsWith("text-") Then t = t.SubString(5)

	Dim m As Map
	m.Initialize
	Select Case t
		Case "xs"
			m.Put("font_size", 12)
			m.Put("line_height_px", 16)
		Case "sm"
			m.Put("font_size", 14)
			m.Put("line_height_px", 20)
		Case "base"
			m.Put("font_size", 16)
			m.Put("line_height_px", 24)
		Case "lg"
			m.Put("font_size", 18)
			m.Put("line_height_px", 28)
		Case "xl"
			m.Put("font_size", 20)
			m.Put("line_height_px", 28)
		Case "2xl"
			m.Put("font_size", 24)
			m.Put("line_height_px", 32)
		Case "3xl"
			m.Put("font_size", 30)
			m.Put("line_height_px", 36)
		Case "4xl"
			m.Put("font_size", 36)
			m.Put("line_height_px", 40)
		Case "5xl"
			m.Put("font_size", 48)
			m.Put("line_height_px", 48)
		Case "6xl"
			m.Put("font_size", 60)
			m.Put("line_height_px", 60)
		Case "7xl"
			m.Put("font_size", 72)
			m.Put("line_height_px", 72)
		Case "8xl"
			m.Put("font_size", 96)
			m.Put("line_height_px", 96)
		Case "9xl"
			m.Put("font_size", 128)
			m.Put("line_height_px", 128)
		Case Else
			Dim customPx As Float = ParseCssLengthToPx(t, DefaultFontSize)
			m.Put("font_size", customPx)
			m.Put("line_height_px", Max(customPx, DefaultLineHeightPx))
	End Select
	m.Put("leading_spec", leadingSpec)
	Return m
End Sub

Private Sub ResolveLeadingSpecToPx(Spec As String, FontSize As Float, DefaultLineHeightPx As Float) As Float
	Dim s As String = Spec.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(FontSize, DefaultLineHeightPx)
	If s.StartsWith("leading-") Then s = s.SubString(8).Trim

	Select Case s
		Case "none"
			Return Max(1, FontSize * 1.0)
		Case "tight"
			Return Max(1, FontSize * 1.25)
		Case "snug"
			Return Max(1, FontSize * 1.375)
		Case "normal"
			Return Max(1, FontSize * 1.5)
		Case "relaxed"
			Return Max(1, FontSize * 1.625)
		Case "loose"
			Return Max(1, FontSize * 2.0)
	End Select

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.EndsWith("%") Then
		Dim pct As Double = ParseCssNumber(s.SubString2(0, s.Length - 1), -1)
		If pct >= 0 Then Return Max(1, FontSize * pct / 100)
	End If

	Dim n As Double = ParseCssNumber(s, -1)
	If n >= 0 Then Return Max(1, n * TW_SPACE_STEP_PX)
	Return Max(1, ParseCssLengthToPx(s, DefaultLineHeightPx))
End Sub

Private Sub CreateDefaultBorderSpec(DefaultBorderDip As Float, DefaultBorderColor As Int, DefaultRadiusDip As Float) As Map
	Dim spec As Map
	spec.Initialize
	Dim w As Float = Max(0, DefaultBorderDip)
	Dim r As Float = Max(0, DefaultRadiusDip)

	spec.Put("border_width", w)
	spec.Put("border_top_width", w)
	spec.Put("border_right_width", w)
	spec.Put("border_bottom_width", w)
	spec.Put("border_left_width", w)

	spec.Put("border_style", "solid")
	spec.Put("border_top_style", "solid")
	spec.Put("border_right_style", "solid")
	spec.Put("border_bottom_style", "solid")
	spec.Put("border_left_style", "solid")

	spec.Put("border_color", DefaultBorderColor)
	spec.Put("border_top_color", DefaultBorderColor)
	spec.Put("border_right_color", DefaultBorderColor)
	spec.Put("border_bottom_color", DefaultBorderColor)
	spec.Put("border_left_color", DefaultBorderColor)
	spec.Put("border_color_token", "")
	spec.Put("border_opacity", ColorAlpha01(DefaultBorderColor))

	spec.Put("radius", r)
	spec.Put("radius_tl", r)
	spec.Put("radius_tr", r)
	spec.Put("radius_br", r)
	spec.Put("radius_bl", r)

	spec.Put("border_uniform_width", True)
	spec.Put("border_uniform_color", True)
	spec.Put("border_uniform_style", True)
	spec.Put("radius_uniform", True)
	spec.Put("has_border_utility", False)
	Return spec
End Sub

Private Sub ApplyBorderUtilityToken(Spec As Map, Utility As String, RtlEnabled As Boolean) As Boolean
	If Spec.IsInitialized = False Then Return False
	If Utility = Null Then Return False
	Dim u As String = Utility.ToLowerCase.Trim
	If u.Length = 0 Then Return False

	Dim defaultBorderDip As Float = GetBorderDip(1dip)
	If u = "border" Then
		SetBorderWidthScope(Spec, "all", defaultBorderDip, RtlEnabled)
		SyncBorderAggregate(Spec)
		Return True
	End If
	If u.StartsWith("border-") = False Then Return False

	Dim rest As String = u.SubString(7).Trim
	If rest.Length = 0 Then
		SetBorderWidthScope(Spec, "all", defaultBorderDip, RtlEnabled)
		SyncBorderAggregate(Spec)
		Return True
	End If

	If IsBorderStyleToken(rest) Then
		SetBorderStyleScope(Spec, "all", NormalizeBorderStyle(rest), RtlEnabled)
		SyncBorderAggregate(Spec)
		Return True
	End If

	Dim scopeInfo As Map = ParseBorderSideScope(rest)
	Dim scope As String = "all"
	Dim valueToken As String = rest
	If scopeInfo.GetDefault("has_scope", False) Then
		scope = scopeInfo.GetDefault("scope", "all")
		valueToken = scopeInfo.GetDefault("value", "")
		If valueToken.Length = 0 Then
			SetBorderWidthScope(Spec, scope, defaultBorderDip, RtlEnabled)
			SyncBorderAggregate(Spec)
			Return True
		End If
	End If

	If IsBorderStyleToken(valueToken) Then
		SetBorderStyleScope(Spec, scope, NormalizeBorderStyle(valueToken), RtlEnabled)
		SyncBorderAggregate(Spec)
		Return True
	End If

	Dim maybeWidth As Float = ResolveBorderWidthTokenDip(valueToken, -1)
	If maybeWidth >= 0 Then
		SetBorderWidthScope(Spec, scope, maybeWidth, RtlEnabled)
		SyncBorderAggregate(Spec)
		Return True
	End If

	Dim baseColor As Int = Spec.GetDefault("border_color", xui.Color_Black)
	Dim c As Int = ResolveUtilityColorWithOpacity(valueToken, baseColor)
	SetBorderColorScope(Spec, scope, c, RtlEnabled)
	Spec.Put("border_color_token", valueToken)
	SyncBorderAggregate(Spec)
	Return True
End Sub

Private Sub ApplyRoundedUtilityToken(Spec As Map, Utility As String, RtlEnabled As Boolean) As Boolean
	If Spec.IsInitialized = False Then Return False
	If Utility = Null Then Return False
	Dim u As String = Utility.ToLowerCase.Trim
	If u.Length = 0 Then Return False
	If u.StartsWith("rounded") = False Then Return False

	Dim scope As String = "all"
	Dim valueToken As String = "default"
	If u = "rounded" Then
		scope = "all"
		valueToken = "default"
	Else If u.StartsWith("rounded-") Then
		Dim rest As String = u.SubString(8).Trim
		Dim scopeInfo As Map = ParseRoundedScope(rest)
		If scopeInfo.GetDefault("has_scope", False) Then
			scope = scopeInfo.GetDefault("scope", "all")
			valueToken = scopeInfo.GetDefault("value", "")
			If valueToken.Length = 0 Then valueToken = "default"
		Else
			scope = "all"
			valueToken = rest
			If valueToken.Length = 0 Then valueToken = "default"
		End If
	Else
		Return False
	End If

	Dim fallbackRadius As Float = Max(0, Spec.GetDefault("radius", 4dip))
	Dim r As Float = TailwindBorderRadiusToDip(valueToken, fallbackRadius)
	SetRoundedScope(Spec, scope, r, RtlEnabled)
	SyncRadiusAggregate(Spec)
	Return True
End Sub

Private Sub ParseBorderSideScope(Token As String) As Map
	Dim m As Map
	m.Initialize
	m.Put("has_scope", False)
	m.Put("scope", "all")
	m.Put("value", Token)
	If Token = Null Then Return m

	Dim t As String = Token.ToLowerCase.Trim
	If t.Length = 0 Then Return m
	Dim scopes() As String = Array As String("x", "y", "t", "r", "b", "l", "s", "e")
	For Each sc As String In scopes
		If t = sc Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", "")
			Return m
		End If
		Dim pref As String = sc & "-"
		If t.StartsWith(pref) And t.Length > pref.Length Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", t.SubString(pref.Length))
			Return m
		End If
	Next
	Return m
End Sub

Private Sub ParseRoundedScope(Token As String) As Map
	Dim m As Map
	m.Initialize
	m.Put("has_scope", False)
	m.Put("scope", "all")
	m.Put("value", Token)
	If Token = Null Then Return m

	Dim t As String = Token.ToLowerCase.Trim
	If t.Length = 0 Then Return m
	Dim scopes() As String = Array As String("ss", "se", "ee", "es", "tl", "tr", "br", "bl", "s", "e", "t", "b", "l", "r")
	For Each sc As String In scopes
		If t = sc Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", "")
			Return m
		End If
		Dim pref As String = sc & "-"
		If t.StartsWith(pref) And t.Length > pref.Length Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", t.SubString(pref.Length))
			Return m
		End If
	Next
	Return m
End Sub

Private Sub ResolveBorderWidthTokenDip(Token As String, FallbackDip As Float) As Float
	If Token = Null Then Return FallbackDip
	Dim s As String = Token.ToLowerCase.Trim
	If s.Length = 0 Then Return FallbackDip
	If s = "default" Then Return GetBorderDip(IIf(FallbackDip >= 0, FallbackDip, 1dip))
	If s = "px" Then Return 1dip
	If s = "thin" Then Return 1dip
	If s = "medium" Then Return 3dip
	If s = "thick" Then Return 5dip

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.StartsWith("(") And s.EndsWith(")") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.Contains("--border") Then Return GetBorderDip(IIf(FallbackDip >= 0, FallbackDip, 1dip))
	If s.StartsWith("--") Then Return GetTokenDip(s, IIf(FallbackDip >= 0, FallbackDip, 1dip))

	Dim px As Float = ParseCssLengthToPx(s, -1)
	If px >= 0 Then Return Max(0, px * 1dip)
	Return FallbackDip
End Sub

Private Sub ResolveUtilityColorWithOpacity(ColorToken As String, DefaultColor As Int) As Int
	If ColorToken = Null Then Return DefaultColor
	Dim s As String = ColorToken.ToLowerCase.Trim
	If s.Length = 0 Then Return DefaultColor

	Dim alpha01 As Float = 1
	Dim pSlash As Int = s.LastIndexOf("/")
	If pSlash > 0 And pSlash < s.Length - 1 Then
		alpha01 = ParseUtilityOpacity01(s.SubString(pSlash + 1), 1)
		s = s.SubString2(0, pSlash).Trim
	End If

	Dim baseColor As Int = ResolveUtilityColor(s, DefaultColor)
	Dim a As Float = Max(0, Min(1, ColorAlpha01(baseColor) * alpha01))
	Return AlphaColor(baseColor, a)
End Sub

Private Sub ResolveUtilityColor(ColorToken As String, DefaultColor As Int) As Int
	If ColorToken = Null Then Return DefaultColor
	Dim s As String = ColorToken.ToLowerCase.Trim
	If s.Length = 0 Then Return DefaultColor

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.StartsWith("color:") Then s = s.SubString(6).Trim
	If s = "current" Or s = "inherit" Then Return DefaultColor
	If s = "transparent" Then Return xui.Color_Transparent
	If s.StartsWith("--") Then Return GetTokenColor(s, DefaultColor)

	Dim themeKey As String = ResolveThemeColorTokenName(s)
	If themeKey.Length > 0 Then Return GetTokenColor(themeKey, DefaultColor)
	Dim normalizedVariant As String = NormalizeVariant(s)
	If normalizedVariant <> "none" Then Return ResolveVariantColor(DefaultPalette, normalizedVariant, "back", DefaultColor)

	If s.StartsWith("#") Then Return ParseHexColorToken(s, DefaultColor)
	If s.StartsWith("rgb(") Or s.StartsWith("rgba(") Then Return ParseRgbColorToken(s, DefaultColor)
	If s.StartsWith("hsl(") Or s.StartsWith("hsla(") Then Return ParseHslColorToken(s, DefaultColor)
	If s.StartsWith("var(") Then
		Dim pVar As Int = s.IndexOf("--")
		If pVar >= 0 Then
			Dim tail As String = s.SubString(pVar)
			Dim pEnd As Int = tail.IndexOf(")")
			If pEnd >= 0 Then tail = tail.SubString2(0, pEnd)
			Return GetTokenColor(tail, DefaultColor)
		End If
	End If

	Dim basic As Int = ResolveCssNamedColor(s, -1)
	If basic <> -1 Then Return basic
	Dim tw As Int = ResolveTailwindPaletteColor(s, -1)
	If tw <> -1 Then Return tw
	If IsNumber(s) Then Return s
	Return DefaultColor
End Sub

Private Sub ResolveCssNamedColor(Name As String, DefaultColor As Int) As Int
	Select Case Name
		Case "black"
			Return xui.Color_Black
		Case "white"
			Return xui.Color_White
		Case "red"
			Return xui.Color_Red
		Case "green"
			Return xui.Color_Green
		Case "blue"
			Return xui.Color_Blue
		Case "yellow"
			Return xui.Color_Yellow
		Case "cyan", "aqua"
			Return xui.Color_Cyan
		Case "magenta", "fuchsia"
			Return xui.Color_Magenta
		Case "gray", "grey"
			Return xui.Color_Gray
		Case "orange"
			Return xui.Color_RGB(249, 115, 22)
		Case "pink"
			Return xui.Color_RGB(236, 72, 153)
		Case "purple"
			Return xui.Color_RGB(168, 85, 247)
		Case "teal"
			Return xui.Color_RGB(20, 184, 166)
		Case "lime"
			Return xui.Color_RGB(132, 204, 22)
		Case "amber"
			Return xui.Color_RGB(245, 158, 11)
		Case "indigo"
			Return xui.Color_RGB(99, 102, 241)
		Case "rose"
			Return xui.Color_RGB(244, 63, 94)
		Case "slate"
			Return xui.Color_RGB(100, 116, 139)
		Case "zinc"
			Return xui.Color_RGB(113, 113, 122)
		Case "neutral"
			Return xui.Color_RGB(115, 115, 115)
		Case "stone"
			Return xui.Color_RGB(120, 113, 108)
		Case Else
			Return DefaultColor
	End Select
End Sub

Private Sub ResolveTailwindPaletteColor(Token As String, DefaultColor As Int) As Int
	If Token = Null Then Return DefaultColor
	Dim s As String = Token.ToLowerCase.Trim
	If s.Length = 0 Then Return DefaultColor

	Dim hue As String = s
	Dim shade As Int = 500
	Dim p As Int = s.LastIndexOf("-")
	If p > 0 And p < s.Length - 1 Then
		Dim shadeText As String = s.SubString(p + 1).Trim
		If IsNumber(shadeText) Then
			hue = s.SubString2(0, p).Trim
			shade = shadeText
		End If
	End If

	Dim base500 As Int = ResolveTailwindHue500(hue, -1)
	If base500 = -1 Then Return DefaultColor
	Return ShadeTailwindColor(base500, shade)
End Sub

Private Sub ResolveTailwindHue500(Hue As String, DefaultColor As Int) As Int
	Select Case Hue
		Case "slate"
			Return xui.Color_RGB(100, 116, 139)
		Case "gray", "grey"
			Return xui.Color_RGB(107, 114, 128)
		Case "zinc"
			Return xui.Color_RGB(113, 113, 122)
		Case "neutral"
			Return xui.Color_RGB(115, 115, 115)
		Case "stone"
			Return xui.Color_RGB(120, 113, 108)
		Case "red"
			Return xui.Color_RGB(239, 68, 68)
		Case "orange"
			Return xui.Color_RGB(249, 115, 22)
		Case "amber"
			Return xui.Color_RGB(245, 158, 11)
		Case "yellow"
			Return xui.Color_RGB(234, 179, 8)
		Case "lime"
			Return xui.Color_RGB(132, 204, 22)
		Case "green"
			Return xui.Color_RGB(34, 197, 94)
		Case "emerald"
			Return xui.Color_RGB(16, 185, 129)
		Case "teal"
			Return xui.Color_RGB(20, 184, 166)
		Case "cyan"
			Return xui.Color_RGB(6, 182, 212)
		Case "sky"
			Return xui.Color_RGB(14, 165, 233)
		Case "blue"
			Return xui.Color_RGB(59, 130, 246)
		Case "indigo"
			Return xui.Color_RGB(99, 102, 241)
		Case "violet"
			Return xui.Color_RGB(139, 92, 246)
		Case "purple"
			Return xui.Color_RGB(168, 85, 247)
		Case "fuchsia"
			Return xui.Color_RGB(217, 70, 239)
		Case "pink"
			Return xui.Color_RGB(236, 72, 153)
		Case "rose"
			Return xui.Color_RGB(244, 63, 94)
		Case Else
			Return DefaultColor
	End Select
End Sub

Private Sub ShadeTailwindColor(BaseColor As Int, Shade As Int) As Int
	Dim s As Int = Shade
	If s <= 50 Then Return Blend(BaseColor, xui.Color_White, 0.92)
	If s < 500 Then
		Dim tLight As Float = (500 - s) / 450
		Return Blend(BaseColor, xui.Color_White, Max(0, Min(1, tLight * 0.92)))
	End If
	If s = 500 Then Return BaseColor
	If s >= 950 Then Return Blend(BaseColor, xui.Color_Black, 0.72)
	Dim tDark As Float = (s - 500) / 450
	Return Blend(BaseColor, xui.Color_Black, Max(0, Min(1, tDark * 0.72)))
End Sub

Private Sub ParseHexColorToken(Value As String, DefaultColor As Int) As Int
	Try
		Dim hex As String = Value.Trim
		If hex.StartsWith("#") Then hex = hex.SubString(1)
		Select Case hex.Length
			Case 3
				Dim r3 As Int = Bit.ParseInt(hex.SubString2(0, 1) & hex.SubString2(0, 1), 16)
				Dim g3 As Int = Bit.ParseInt(hex.SubString2(1, 2) & hex.SubString2(1, 2), 16)
				Dim b3 As Int = Bit.ParseInt(hex.SubString2(2, 3) & hex.SubString2(2, 3), 16)
				Return xui.Color_ARGB(255, r3, g3, b3)
			Case 4
				Dim r4 As Int = Bit.ParseInt(hex.SubString2(0, 1) & hex.SubString2(0, 1), 16)
				Dim g4 As Int = Bit.ParseInt(hex.SubString2(1, 2) & hex.SubString2(1, 2), 16)
				Dim b4 As Int = Bit.ParseInt(hex.SubString2(2, 3) & hex.SubString2(2, 3), 16)
				Dim a4 As Int = Bit.ParseInt(hex.SubString2(3, 4) & hex.SubString2(3, 4), 16)
				Return xui.Color_ARGB(a4, r4, g4, b4)
			Case 6
				Dim r6 As Int = Bit.ParseInt(hex.SubString2(0, 2), 16)
				Dim g6 As Int = Bit.ParseInt(hex.SubString2(2, 4), 16)
				Dim b6 As Int = Bit.ParseInt(hex.SubString2(4, 6), 16)
				Return xui.Color_ARGB(255, r6, g6, b6)
			Case 8
				' CSS 8-digit hex uses RRGGBBAA.
				Dim r8 As Int = Bit.ParseInt(hex.SubString2(0, 2), 16)
				Dim g8 As Int = Bit.ParseInt(hex.SubString2(2, 4), 16)
				Dim b8 As Int = Bit.ParseInt(hex.SubString2(4, 6), 16)
				Dim a8 As Int = Bit.ParseInt(hex.SubString2(6, 8), 16)
				Return xui.Color_ARGB(a8, r8, g8, b8)
			Case Else
				Return DefaultColor
		End Select
	Catch
		Return DefaultColor
	End Try
End Sub

Private Sub ParseRgbColorToken(Value As String, DefaultColor As Int) As Int
	Try
		Dim s As String = Value.Trim
		Dim p1 As Int = s.IndexOf("(")
		Dim p2 As Int = s.LastIndexOf(")")
		If p1 < 0 Or p2 <= p1 Then Return DefaultColor
		Dim inside As String = s.SubString2(p1 + 1, p2).Trim
		If inside.Length = 0 Then Return DefaultColor

		inside = inside.Replace("/", ",")
		inside = Regex.Replace("\s+", inside, ",")
		inside = Regex.Replace(",+", inside, ",")
		If inside.StartsWith(",") Then inside = inside.SubString(1)
		If inside.EndsWith(",") Then inside = inside.SubString2(0, inside.Length - 1)

		Dim parts() As String = Regex.Split(",", inside)
		If parts.Length < 3 Then Return DefaultColor
		Dim r As Int = ParseColorChannel(parts(0), -1)
		Dim g As Int = ParseColorChannel(parts(1), -1)
		Dim b As Int = ParseColorChannel(parts(2), -1)
		If r < 0 Or g < 0 Or b < 0 Then Return DefaultColor
		Dim a01 As Float = 1
		If parts.Length >= 4 Then a01 = ParseUtilityOpacity01(parts(3), 1)
		Return xui.Color_ARGB(Round(255 * Max(0, Min(1, a01))), r, g, b)
	Catch
		Return DefaultColor
	End Try
End Sub

Private Sub ParseHslColorToken(Value As String, DefaultColor As Int) As Int
	Try
		Dim s As String = Value.Trim
		Dim p1 As Int = s.IndexOf("(")
		Dim p2 As Int = s.LastIndexOf(")")
		If p1 < 0 Or p2 <= p1 Then Return DefaultColor
		Dim inside As String = s.SubString2(p1 + 1, p2).Trim
		If inside.Length = 0 Then Return DefaultColor

		inside = inside.Replace("/", ",")
		inside = Regex.Replace("\s+", inside, ",")
		inside = Regex.Replace(",+", inside, ",")
		If inside.StartsWith(",") Then inside = inside.SubString(1)
		If inside.EndsWith(",") Then inside = inside.SubString2(0, inside.Length - 1)

		Dim parts() As String = Regex.Split(",", inside)
		If parts.Length < 3 Then Return DefaultColor

		Dim hText As String = parts(0).ToLowerCase.Trim
		If hText.EndsWith("deg") Then hText = hText.SubString2(0, hText.Length - 3).Trim
		Dim h As Float = ParseCssNumber(hText, 0)
		Dim s01 As Float = ParseUtilityOpacity01(parts(1), -1)
		Dim l01 As Float = ParseUtilityOpacity01(parts(2), -1)
		If s01 < 0 Or l01 < 0 Then Return DefaultColor

		Dim rgb As Map = HslToRgb(h, s01, l01)
		Dim a01 As Float = 1
		If parts.Length >= 4 Then a01 = ParseUtilityOpacity01(parts(3), 1)
		Return xui.Color_ARGB(Round(255 * Max(0, Min(1, a01))), rgb.GetDefault("r", 0), rgb.GetDefault("g", 0), rgb.GetDefault("b", 0))
	Catch
		Return DefaultColor
	End Try
End Sub

Private Sub HslToRgb(H As Float, S As Float, L As Float) As Map
	Dim h01 As Float = H / 360
	Do While h01 < 0
		h01 = h01 + 1
	Loop
	Do While h01 >= 1
		h01 = h01 - 1
	Loop
	Dim s01 As Float = Max(0, Min(1, S))
	Dim l01 As Float = Max(0, Min(1, L))
	Dim r As Float
	Dim g As Float
	Dim b As Float
	If s01 = 0 Then
		r = l01
		g = l01
		b = l01
	Else
		Dim q As Float = IIf(l01 < 0.5, l01 * (1 + s01), l01 + s01 - l01 * s01)
		Dim p As Float = 2 * l01 - q
		r = HueToRgb(p, q, h01 + (1 / 3))
		g = HueToRgb(p, q, h01)
		b = HueToRgb(p, q, h01 - (1 / 3))
	End If
	Dim m As Map
	m.Initialize
	m.Put("r", Round(255 * Max(0, Min(1, r))))
	m.Put("g", Round(255 * Max(0, Min(1, g))))
	m.Put("b", Round(255 * Max(0, Min(1, b))))
	Return m
End Sub

Private Sub HueToRgb(p As Float, q As Float, tIn As Float) As Float
	Dim t As Float = tIn
	If t < 0 Then t = t + 1
	If t > 1 Then t = t - 1
	If t < 1 / 6 Then Return p + (q - p) * 6 * t
	If t < 1 / 2 Then Return q
	If t < 2 / 3 Then Return p + (q - p) * (2 / 3 - t) * 6
	Return p
End Sub

Private Sub ParseColorChannel(Text As String, DefaultValue As Int) As Int
	If Text = Null Then Return DefaultValue
	Dim s As String = Text.ToLowerCase.Trim
	If s.Length = 0 Then Return DefaultValue
	If s.EndsWith("%") Then
		Dim pct As Double = ParseCssNumber(s.SubString2(0, s.Length - 1), -1)
		If pct < 0 Then Return DefaultValue
		Return Round(Max(0, Min(255, 255 * pct / 100)))
	End If
	Dim n As Double = ParseCssNumber(s, -1)
	If n < 0 Then Return DefaultValue
	Return Round(Max(0, Min(255, n)))
End Sub

Private Sub ParseUtilityOpacity01(Value As String, DefaultValue As Float) As Float
	If Value = Null Then Return Max(0, Min(1, DefaultValue))
	Dim s As String = Value.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, Min(1, DefaultValue))
	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.EndsWith("%") Then
		Dim pct As Double = ParseCssNumber(s.SubString2(0, s.Length - 1), -1)
		If pct >= 0 Then Return Max(0, Min(1, pct / 100))
		Return Max(0, Min(1, DefaultValue))
	End If
	Dim n As Double = ParseCssNumber(s, -1)
	If n < 0 Then Return Max(0, Min(1, DefaultValue))
	If n > 1 Then n = n / 100
	Return Max(0, Min(1, n))
End Sub

Private Sub ColorAlpha01(ColorValue As Int) As Float
	Dim a As Int = Bit.And(Bit.ShiftRight(ColorValue, 24), 0xFF)
	Return a / 255
End Sub

Private Sub IsBorderStyleToken(Token As String) As Boolean
	Dim s As String = NormalizeBorderStyle(Token)
	Return s.Length > 0
End Sub

Private Sub NormalizeBorderStyle(Token As String) As String
	If Token = Null Then Return ""
	Dim s As String = Token.ToLowerCase.Trim
	If s.StartsWith("border-") Then s = s.SubString(7).Trim
	Select Case s
		Case "solid", "dashed", "dotted", "double", "hidden", "none"
			Return s
		Case Else
			Return ""
	End Select
End Sub

Private Sub SetBorderWidthScope(Spec As Map, Scope As String, WidthDip As Float, RtlEnabled As Boolean)
	Dim v As Float = Max(0, WidthDip)
	Select Case Scope
		Case "all"
			Spec.Put("border_top_width", v)
			Spec.Put("border_right_width", v)
			Spec.Put("border_bottom_width", v)
			Spec.Put("border_left_width", v)
		Case "x"
			Spec.Put("border_left_width", v)
			Spec.Put("border_right_width", v)
		Case "y"
			Spec.Put("border_top_width", v)
			Spec.Put("border_bottom_width", v)
		Case "t"
			Spec.Put("border_top_width", v)
		Case "r"
			Spec.Put("border_right_width", v)
		Case "b"
			Spec.Put("border_bottom_width", v)
		Case "l"
			Spec.Put("border_left_width", v)
		Case "s"
			If RtlEnabled Then
				Spec.Put("border_right_width", v)
			Else
				Spec.Put("border_left_width", v)
			End If
		Case "e"
			If RtlEnabled Then
				Spec.Put("border_left_width", v)
			Else
				Spec.Put("border_right_width", v)
			End If
	End Select
End Sub

Private Sub SetBorderStyleScope(Spec As Map, Scope As String, StyleValue As String, RtlEnabled As Boolean)
	Dim styleResolved As String = NormalizeBorderStyle(StyleValue)
	If styleResolved.Length = 0 Then styleResolved = "solid"
	Select Case Scope
		Case "all"
			Spec.Put("border_top_style", styleResolved)
			Spec.Put("border_right_style", styleResolved)
			Spec.Put("border_bottom_style", styleResolved)
			Spec.Put("border_left_style", styleResolved)
		Case "x"
			Spec.Put("border_left_style", styleResolved)
			Spec.Put("border_right_style", styleResolved)
		Case "y"
			Spec.Put("border_top_style", styleResolved)
			Spec.Put("border_bottom_style", styleResolved)
		Case "t"
			Spec.Put("border_top_style", styleResolved)
		Case "r"
			Spec.Put("border_right_style", styleResolved)
		Case "b"
			Spec.Put("border_bottom_style", styleResolved)
		Case "l"
			Spec.Put("border_left_style", styleResolved)
		Case "s"
			If RtlEnabled Then
				Spec.Put("border_right_style", styleResolved)
			Else
				Spec.Put("border_left_style", styleResolved)
			End If
		Case "e"
			If RtlEnabled Then
				Spec.Put("border_left_style", styleResolved)
			Else
				Spec.Put("border_right_style", styleResolved)
			End If
	End Select
End Sub

Private Sub SetBorderColorScope(Spec As Map, Scope As String, ColorValue As Int, RtlEnabled As Boolean)
	Select Case Scope
		Case "all"
			Spec.Put("border_top_color", ColorValue)
			Spec.Put("border_right_color", ColorValue)
			Spec.Put("border_bottom_color", ColorValue)
			Spec.Put("border_left_color", ColorValue)
		Case "x"
			Spec.Put("border_left_color", ColorValue)
			Spec.Put("border_right_color", ColorValue)
		Case "y"
			Spec.Put("border_top_color", ColorValue)
			Spec.Put("border_bottom_color", ColorValue)
		Case "t"
			Spec.Put("border_top_color", ColorValue)
		Case "r"
			Spec.Put("border_right_color", ColorValue)
		Case "b"
			Spec.Put("border_bottom_color", ColorValue)
		Case "l"
			Spec.Put("border_left_color", ColorValue)
		Case "s"
			If RtlEnabled Then
				Spec.Put("border_right_color", ColorValue)
			Else
				Spec.Put("border_left_color", ColorValue)
			End If
		Case "e"
			If RtlEnabled Then
				Spec.Put("border_left_color", ColorValue)
			Else
				Spec.Put("border_right_color", ColorValue)
			End If
	End Select
End Sub

Private Sub SetRoundedScope(Spec As Map, Scope As String, RadiusDip As Float, RtlEnabled As Boolean)
	Dim r As Float = Max(0, RadiusDip)
	Select Case Scope
		Case "all"
			Spec.Put("radius_tl", r)
			Spec.Put("radius_tr", r)
			Spec.Put("radius_br", r)
			Spec.Put("radius_bl", r)
		Case "t"
			Spec.Put("radius_tl", r)
			Spec.Put("radius_tr", r)
		Case "b"
			Spec.Put("radius_bl", r)
			Spec.Put("radius_br", r)
		Case "l"
			Spec.Put("radius_tl", r)
			Spec.Put("radius_bl", r)
		Case "r"
			Spec.Put("radius_tr", r)
			Spec.Put("radius_br", r)
		Case "tl"
			Spec.Put("radius_tl", r)
		Case "tr"
			Spec.Put("radius_tr", r)
		Case "br"
			Spec.Put("radius_br", r)
		Case "bl"
			Spec.Put("radius_bl", r)
		Case "s"
			If RtlEnabled Then
				Spec.Put("radius_tr", r)
				Spec.Put("radius_br", r)
			Else
				Spec.Put("radius_tl", r)
				Spec.Put("radius_bl", r)
			End If
		Case "e"
			If RtlEnabled Then
				Spec.Put("radius_tl", r)
				Spec.Put("radius_bl", r)
			Else
				Spec.Put("radius_tr", r)
				Spec.Put("radius_br", r)
			End If
		Case "ss"
			If RtlEnabled Then
				Spec.Put("radius_tr", r)
			Else
				Spec.Put("radius_tl", r)
			End If
		Case "se"
			If RtlEnabled Then
				Spec.Put("radius_tl", r)
			Else
				Spec.Put("radius_tr", r)
			End If
		Case "ee"
			If RtlEnabled Then
				Spec.Put("radius_bl", r)
			Else
				Spec.Put("radius_br", r)
			End If
		Case "es"
			If RtlEnabled Then
				Spec.Put("radius_br", r)
			Else
				Spec.Put("radius_bl", r)
			End If
	End Select
End Sub

Private Sub SyncBorderAggregate(Spec As Map)
	If Spec.IsInitialized = False Then Return
	Dim tw As Float = Max(0, Spec.GetDefault("border_top_width", 0))
	Dim rw As Float = Max(0, Spec.GetDefault("border_right_width", 0))
	Dim bw As Float = Max(0, Spec.GetDefault("border_bottom_width", 0))
	Dim lw As Float = Max(0, Spec.GetDefault("border_left_width", 0))
	Dim uniformW As Boolean = (tw = rw And rw = bw And bw = lw)
	Spec.Put("border_uniform_width", uniformW)
	Spec.Put("border_width", IIf(uniformW, tw, Max(Max(tw, rw), Max(bw, lw))))

	Dim tc As Int = Spec.GetDefault("border_top_color", xui.Color_Black)
	Dim rc As Int = Spec.GetDefault("border_right_color", tc)
	Dim bc As Int = Spec.GetDefault("border_bottom_color", tc)
	Dim lc As Int = Spec.GetDefault("border_left_color", tc)
	Dim uniformC As Boolean = (tc = rc And rc = bc And bc = lc)
	Spec.Put("border_uniform_color", uniformC)
	Spec.Put("border_color", tc)
	Spec.Put("border_opacity", ColorAlpha01(tc))

	Dim ts As String = Spec.GetDefault("border_top_style", "solid")
	Dim rs As String = Spec.GetDefault("border_right_style", ts)
	Dim bs As String = Spec.GetDefault("border_bottom_style", ts)
	Dim ls As String = Spec.GetDefault("border_left_style", ts)
	Dim uniformS As Boolean = (ts = rs And rs = bs And bs = ls)
	Spec.Put("border_uniform_style", uniformS)
	Spec.Put("border_style", ts)
End Sub

Private Sub SyncRadiusAggregate(Spec As Map)
	If Spec.IsInitialized = False Then Return
	Dim tl As Float = Max(0, Spec.GetDefault("radius_tl", 0))
	Dim tr As Float = Max(0, Spec.GetDefault("radius_tr", 0))
	Dim br As Float = Max(0, Spec.GetDefault("radius_br", 0))
	Dim bl As Float = Max(0, Spec.GetDefault("radius_bl", 0))
	Dim uniformR As Boolean = (tl = tr And tr = br And br = bl)
	Spec.Put("radius_uniform", uniformR)
	Spec.Put("radius", IIf(uniformR, tl, Max(Max(tl, tr), Max(br, bl))))
End Sub

Private Sub NormalizeUtilityToken(Token As String) As String
	If Token = Null Then Return ""
	Dim t As String = Token.Trim
	If t.Length = 0 Then Return ""
	Dim p As Int = t.LastIndexOf(":")
	If p >= 0 And p < t.Length - 1 Then t = t.SubString(p + 1)
	Return t
End Sub

Private Sub NormalizeSpacingValueToken(Value As String) As String
	Dim s As String = NormalizeUtilityToken(Value.ToLowerCase)
	If s.Length = 0 Then Return ""

	' Strip common utility prefixes while preserving the trailing spacing token.
	Dim prefixes() As String = Array As String( _
		"gap-x-", "gap-y-", "gap-", _
		"space-x-", "space-y-", _
		"px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-", "p-", _
		"mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "m-", _
		"w-", "h-", "size-" _
	)
	For Each pref As String In prefixes
		If s.StartsWith(pref) And s.Length > pref.Length Then
			Return s.SubString(pref.Length).Trim
		End If
	Next
	Return s
End Sub

Public Sub ContainsAny(Text As String, Needles() As String) As Boolean
	If Text = Null Then Return False
	Dim s As String = Text.ToLowerCase
	For Each n As String In Needles
		If n = Null Then Continue
		Dim k As String = n.ToLowerCase
		If k.Length = 0 Then Continue
		If s.Contains(k) Then Return True
	Next
	Return False
End Sub

Public Sub IsRtl As Boolean
	#If B4A
	Try
		Dim joLocale As JavaObject
		joLocale.InitializeStatic("java.util.Locale")
		Dim localeObj As Object = joLocale.RunMethod("getDefault", Null)
		Dim joTextUtils As JavaObject
		joTextUtils.InitializeStatic("android.text.TextUtils")
		Dim dir As Int = joTextUtils.RunMethod("getLayoutDirectionFromLocale", Array(localeObj))
		Return dir = 1
	Catch
		Return False
	End Try
	#Else
	Return False
	#End If
End Sub

Private Sub ParseCssLengthToPx(Value As String, DefaultPx As Float) As Float
	Dim s As String = Value.ToLowerCase.Trim
	If s.Length = 0 Then Return DefaultPx
	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.EndsWith("px") Then
		Dim npx As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
		If npx >= 0 Then Return npx
		Return DefaultPx
	End If
	If s.EndsWith("rem") Then
		Dim nrem As Double = ParseCssNumber(s.SubString2(0, s.Length - 3), -1)
		If nrem >= 0 Then Return nrem * CSS_BASE_FONT_PX
		Return DefaultPx
	End If
	If s.EndsWith("em") Then
		Dim nem As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
		If nem >= 0 Then Return nem * CSS_BASE_FONT_PX
		Return DefaultPx
	End If
	Dim n As Double = ParseCssNumber(s, -1)
	If n >= 0 Then Return n
	Return DefaultPx
End Sub

Private Sub ResolveSpacingStepPx As Float
	Dim raw As String = GetTokenString("--spacing", "0.25rem")
	Dim px As Float = ParseCssLengthToPx(raw, 4)
	Return Max(0.0001, px)
End Sub

Private Sub ParseCssNumber(Text As String, DefaultValue As Double) As Double
	Dim s As String = Text.Trim
	If s.Length = 0 Then Return DefaultValue
	If IsNumber(s) = False Then Return DefaultValue
	Return s
End Sub
Public Sub NormalizeRounded(Value As String) As String
	If Value = Null Then Return "rounded-none"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "", "theme", "selector"
			Return "rounded-md" ' Default for daisy
		Case "none", "rounded-none"
			Return "rounded-none"
		Case "sm", "rounded-sm"
			Return "rounded-sm"
		Case "default", "rounded"
			Return "rounded"
		Case "md", "rounded-md"
			Return "rounded-md"
		Case "lg", "rounded-lg"
			Return "rounded-lg"
		Case "xl", "rounded-xl"
			Return "rounded-xl"
		Case "2xl", "rounded-2xl"
			Return "rounded-2xl"
		Case "3xl", "rounded-3xl"
			Return "rounded-3xl"
		Case "full", "rounded-full"
			Return "rounded-full"
		Case Else
			Return "rounded-md"
	End Select
End Sub

Public Sub ResolveRoundedDip(Rounded As String, DefaultDip As Float) As Float
	Select Case NormalizeRounded(Rounded)
		Case "rounded-none"
			Return 0
		Case "rounded-sm"
			Return 2dip
		Case "rounded"
			Return 4dip
		Case "rounded-md"
			Return 6dip
		Case "rounded-lg"
			Return 8dip
		Case "rounded-xl"
			Return 12dip
		Case "rounded-2xl"
			Return 16dip
		Case "rounded-3xl"
			Return 24dip
		Case "rounded-full"
			Return 9999dip
		Case Else
			Return DefaultDip
	End Select
End Sub
Public Sub SetAlpha(Color As Int, Alpha As Int) As Int
	Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
	Dim b As Int = Bit.And(Color, 0xFF)
	Return Bit.Or(Bit.ShiftLeft(Alpha, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Public Sub ShiftColor(Color As Int, Factor As Float) As Int
	Dim a As Int = Bit.And(Bit.ShiftRight(Color, 24), 0xFF)
	Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
	Dim b As Int = Bit.And(Color, 0xFF)
	r = Max(0, Min(255, r * Factor))
	g = Max(0, Min(255, g * Factor))
	b = Max(0, Min(255, b * Factor))
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Public Sub CloneProps(Props As Map) As Map
	Dim m As Map
	m.Initialize
	If Props.IsInitialized Then
		For Each k As Object In Props.Keys
			m.Put(k, Props.Get(k))
		Next
	End If
	Return m
End Sub

Public Sub DisableClipping(v As B4XView)
	If v.IsInitialized = False Then Return
	#If B4A
	Try
		Dim jo As JavaObject = v
		jo.RunMethod("setClipChildren", Array(False))
		jo.RunMethod("setClipToPadding", Array(False))
	Catch
	End Try
	#End If
End Sub

Public Sub ApplyElevation(v As B4XView, ShadowLevel As String)
	If v.IsInitialized = False Then Return
	Dim e As Float = ResolveShadowElevation(ShadowLevel)
	#If B4A
	Try
		Dim p As Panel = v
		p.Elevation = e
		' Ensure elevation follows the outline for rounded corners
		Dim jo As JavaObject = v
		jo.RunMethod("setClipToOutline", Array(True))
	Catch
	End Try
	#End If
End Sub
