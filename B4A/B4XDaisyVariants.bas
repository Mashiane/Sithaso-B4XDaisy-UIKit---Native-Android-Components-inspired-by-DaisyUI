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
End Sub

Public Sub VariantList As String
	Return "none|neutral|primary|secondary|accent|info|success|warning|error"
End Sub

Public Sub NormalizeVariant(Name As String) As String
	If Name = Null Then Return "none"
	Dim v As String = Name.ToLowerCase.Trim
	If v.StartsWith("variant-") Then v = v.SubString(8)
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
	Dim m As Map
	m.Initialize
	'FlyonUI light theme defaults from flyonui-main/src/themes/light.css.
	m.Put("neutral", BuildVariantMap(xui.Color_RGB(63,64,77), xui.Color_RGB(248,248,249)))
	m.Put("primary", BuildVariantMap(xui.Color_RGB(121,77,255), xui.Color_RGB(243,242,255)))
	m.Put("secondary", BuildVariantMap(xui.Color_RGB(118,113,127), xui.Color_RGB(247,247,248)))
	m.Put("accent", BuildVariantMap(xui.Color_RGB(59,130,246), xui.Color_RGB(239,246,255)))
	m.Put("info", BuildVariantMap(xui.Color_RGB(4,182,212), xui.Color_RGB(236,254,255)))
	m.Put("success", BuildVariantMap(xui.Color_RGB(0,202,75), xui.Color_RGB(240,252,248)))
	m.Put("warning", BuildVariantMap(xui.Color_RGB(252,170,30), xui.Color_RGB(255,253,245)))
	m.Put("error", BuildVariantMap(xui.Color_RGB(251,65,65), xui.Color_RGB(255,250,245)))
	Return m
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

Private Sub ResolveRoundedRadiusDip(MaskName As String, Size As Float) As Float
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
	Return o
End Sub

Public Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If o = Null Then Return DefaultValue
	Return o
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
	If IsNumber(Value) Then Return Max(0, Value * TW_SPACE_STEP_PX)
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

	If s = "auto" Or s = "full" Or s = "screen" Then Return Max(0, DefaultPx)

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

	'Bare numbers are Tailwind spacing tokens: 12 -> 12 * 0.25rem -> 48px.
	Dim ntw As Double = ParseCssNumber(s, -1)
	If ntw >= 0 Then Return ntw * TW_SPACE_STEP_PX
	Return Max(0, DefaultPx)
End Sub

Public Sub TailwindSizeToDip(Value As Object, DefaultDip As Float) As Float
	Dim defaultPx As Float = Max(0, DefaultDip / 1dip)
	Dim px As Float = TailwindSizeToPx(Value, defaultPx)
	Return px * 1dip
End Sub

Private Sub ParseCssNumber(Text As String, DefaultValue As Double) As Double
	Dim s As String = Text.Trim
	If s.Length = 0 Then Return DefaultValue
	If IsNumber(s) = False Then Return DefaultValue
	Return s
End Sub
