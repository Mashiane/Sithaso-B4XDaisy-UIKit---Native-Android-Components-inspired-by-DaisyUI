B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@

' YogaStyle - Code Module
' B4X Style Object System — like React Native's StyleSheet
'
' Usage:
'   Dim style As Map = YogaStyle.Create( _
'       "flexDirection", "row", _
'       "padding", 16, _
'       "backgroundColor", "#1e293b")
'
'   Dim composed As Map = YogaStyle.Compose(baseStyle, overrideStyle)

Sub Process_Globals
	' Layout property names (routed to YogaNode)
	Private LayoutProps As Map
	
	' Visual property names (routed to B4XView)
	Private VisualProps As Map
	
	Private mInitialized As Boolean = False
End Sub

' ============================================================
' INITIALIZATION — builds the property classification maps
' ============================================================
Private Sub EnsureInitialized
	If mInitialized Then Return
	mInitialized = True
	
	' Layout properties — these go to YogaNode.SetProperty()
	LayoutProps.Initialize
	Dim layoutKeys() As String = Array As String( _
		"flexdirection", "flexwrap", _
		"justifycontent", "alignitems", "alignself", "aligncontent", _
		"flex", "flexgrow", "flexshrink", "flexbasis", _
		"width", "height", "minwidth", "minheight", "maxwidth", "maxheight", _
		"padding", "paddingtop", "paddingbottom", "paddingleft", "paddingright", _
		"paddingstart", "paddingend", "paddinghorizontal", "paddingvertical", _
		"margin", "margintop", "marginbottom", "marginleft", "marginright", _
		"marginstart", "marginend", "marginhorizontal", "marginvertical", _
		"borderwidth", "bordertopwidth", "borderbottomwidth", "borderleftwidth", "borderrightwidth", _
		"position", "top", "bottom", "left", "right", "start", "end", _
		"gap", "rowgap", "columngap", _
		"aspectratio", "display", "overflow", "direction", "boxsizing")
	
	Dim i As Int
	For i = 0 To layoutKeys.Length - 1
		LayoutProps.Put(layoutKeys(i), True)
	Next
	
	' Visual properties — these go to B4XView
	VisualProps.Initialize
	Dim visualKeys() As String = Array As String( _
		"backgroundcolor", "color", "opacity", _
		"borderradius", "bordercolor", _
		"bordertopleftradius", "bordertoprightradius", _
		"borderbottomleftradius", "borderbottomrightradius", _
		"fontsize", "fontfamily", "fontweight", _
		"textalign", "texttransform", "textdecorationline", _
		"letterspacing", "lineheight", _
		"elevation", "shadowcolor", "shadowoffset", "shadowopacity", "shadowradius", _
		"tintcolor", "resizemode")
	
	For i = 0 To visualKeys.Length - 1
		VisualProps.Put(visualKeys(i), True)
	Next
End Sub

' ============================================================
' CREATE — Create a style Map from key-value pairs
' Like React Native's StyleSheet.create() for a single style
'
' Usage:
'   Dim s As Map = YogaStyle.Create( _
'       "flexDirection", "row", _
'       "padding", 16, _
'       "backgroundColor", "#ff0000")
' ============================================================
Public Sub Create(Args() As Object) As Map
	EnsureInitialized
	Dim m As Map
	m.Initialize
	
	' Args come in pairs: key1, value1, key2, value2, ...
	Dim i As Int
	For i = 0 To Args.Length - 1 Step 2
		If i + 1 < Args.Length Then
			Dim key As String = Args(i)
			Dim value As Object = Args(i + 1)
			m.Put(key, value)
		End If
	Next
	
	Return m
End Sub

' ============================================================
' COMPOSE — Merge two style maps (second overrides first)
' Like React Native's [styles.base, styles.override]
'
' Usage:
'   Dim merged As Map = YogaStyle.Compose(baseStyle, overrideStyle)
' ============================================================
Public Sub Compose(base As Map, overrides As Map) As Map
	Dim result As Map
	result.Initialize
	
	' Copy base
	If base.IsInitialized Then
		Dim i As Int
		For i = 0 To base.Size - 1
			result.Put(base.GetKeyAt(i), base.GetValueAt(i))
		Next
	End If
	
	' Apply overrides (replaces existing keys)
	If overrides.IsInitialized Then
		Dim i As Int
		For i = 0 To overrides.Size - 1
			result.Put(overrides.GetKeyAt(i), overrides.GetValueAt(i))
		Next
	End If
	
	Return result
End Sub

' ============================================================
' COMPOSE MANY — Merge multiple style maps
' Like React Native's [styles.a, styles.b, styles.c]
'
' Usage:
'   Dim merged As Map = YogaStyle.ComposeMany(Array(s1, s2, s3))
' ============================================================
Public Sub ComposeMany(styles As List) As Map
	Dim result As Map
	result.Initialize
	
	Dim i As Int
	For i = 0 To styles.Size - 1
		Dim style As Map = styles.Get(i)
		If style.IsInitialized Then
			Dim j As Int
			For j = 0 To style.Size - 1
				result.Put(style.GetKeyAt(j), style.GetValueAt(j))
			Next
		End If
	Next
	
	Return result
End Sub

' ============================================================
' STYLESHEET — Create named styles (like StyleSheet.create())
'
' Usage:
'   Dim styles As Map = YogaStyle.StyleSheet(Array( _
'       "container", CreateMap("flexDirection": "column", "padding": 16), _
'       "title", CreateMap("fontSize": 24, "color": "#ffffff")))
'
'   Dim containerStyle As Map = styles.Get("container")
' ============================================================
Public Sub StyleSheet(pairs() As Object) As Map
	Dim result As Map
	result.Initialize
	
	Dim i As Int
	For i = 0 To pairs.Length - 1 Step 2
		If i + 1 < pairs.Length Then
			result.Put(pairs(i), pairs(i + 1))
		End If
	Next
	
	Return result
End Sub

' ============================================================
' CLASSIFICATION — Is this a layout or visual property?
' ============================================================
Public Sub IsLayoutProperty(key As String) As Boolean
	EnsureInitialized
	Return LayoutProps.ContainsKey(key.ToLowerCase)
End Sub

Public Sub IsVisualProperty(key As String) As Boolean
	EnsureInitialized
	Return VisualProps.ContainsKey(key.ToLowerCase)
End Sub

' ============================================================
' EXTRACT — Split a style map into layout and visual parts
'
' Returns a Map with two keys: "layout" and "visual",
' each containing a Map of the respective properties.
' ============================================================
Public Sub Extract(style As Map) As Map
	EnsureInitialized
	
	Dim layoutMap As Map
	layoutMap.Initialize
	Dim visualMap As Map
	visualMap.Initialize
	
	If style.IsInitialized Then
		Dim i As Int
		For i = 0 To style.Size - 1
			Dim key As String = style.GetKeyAt(i)
			Dim value As Object = style.GetValueAt(i)
			
			If IsLayoutProperty(key) Then
				layoutMap.Put(key, value)
			Else If IsVisualProperty(key) Then
				visualMap.Put(key, value)
			Else
				' Unknown property — log warning, put in visual as fallback
				Log("YogaStyle.Extract: Unknown property '" & key & "' — treating as visual")
				visualMap.Put(key, value)
			End If
		Next
	End If
	
	Dim result As Map = CreateMap("layout": layoutMap, "visual": visualMap)
	Return result
End Sub

' ============================================================
' COLOR PARSING — Converts CSS hex/named colors to B4X color int
'
' Supports: "#RRGGBB", "#AARRGGBB", "#RGB", named colors
' ============================================================
Public Sub ParseColor(value As Object) As Int
	Dim s As String = value
	s = s.Trim
	
	' Named colors
	Select s.ToLowerCase
		Case "transparent": Return Colors.Transparent
		Case "white": Return Colors.White
		Case "black": Return Colors.Black
		Case "red": Return Colors.Red
		Case "green": Return Colors.Green
		Case "blue": Return Colors.Blue
		Case "gray", "grey": Return Colors.Gray
		Case "yellow": Return Colors.Yellow
		Case "cyan": Return Colors.Cyan
		Case "magenta": Return Colors.Magenta
	End Select
	
	' Hex color
	If s.StartsWith("#") Then
		s = s.SubString(1) ' remove #
		
		' #RGB → #RRGGBB
		If s.Length = 3 Then
			Dim r As String = s.CharAt(0) & s.CharAt(0)
			Dim g As String = s.CharAt(1) & s.CharAt(1)
			Dim b As String = s.CharAt(2) & s.CharAt(2)
			s = r & g & b
		End If
		
		' #RRGGBB
		If s.Length = 6 Then
			Dim rv As Int = Bit.ParseInt(s.SubString2(0, 2), 16)
			Dim gv As Int = Bit.ParseInt(s.SubString2(2, 4), 16)
			Dim bv As Int = Bit.ParseInt(s.SubString2(4, 6), 16)
			Return Colors.RGB(rv, gv, bv)
		End If
		
		' #AARRGGBB
		If s.Length = 8 Then
			Dim av As Int = Bit.ParseInt(s.SubString2(0, 2), 16)
			Dim rv As Int = Bit.ParseInt(s.SubString2(2, 4), 16)
			Dim gv As Int = Bit.ParseInt(s.SubString2(4, 6), 16)
			Dim bv As Int = Bit.ParseInt(s.SubString2(6, 8), 16)
			Return Colors.ARGB(av, rv, gv, bv)
		End If
	End If
	
	' rgba(r, g, b, a) format
	If s.ToLowerCase.StartsWith("rgba(") Then
		s = s.SubString(5) ' remove "rgba("
		s = s.Replace(")", "")
		Dim parts() As String = Regex.Split(",", s)
		If parts.Length >= 4 Then
			Dim rv As Int = parts(0).Trim
			Dim gv As Int = parts(1).Trim
			Dim bv As Int = parts(2).Trim
			Dim avf As Float = parts(3).Trim
			Return Colors.ARGB(Round(avf * 255), rv, gv, bv)
		End If
	End If
	
	' rgb(r, g, b) format
	If s.ToLowerCase.StartsWith("rgb(") Then
		s = s.SubString(4)
		s = s.Replace(")", "")
		Dim parts() As String = Regex.Split(",", s)
		If parts.Length >= 3 Then
			Dim rv As Int = parts(0).Trim
			Dim gv As Int = parts(1).Trim
			Dim bv As Int = parts(2).Trim
			Return Colors.RGB(rv, gv, bv)
		End If
	End If
	
	Log("YogaStyle.ParseColor: Could not parse color '" & value & "' — using black")
	Return Colors.Black
End Sub

' ============================================================
' CONDITIONAL STYLE — Apply style only if condition is true
'
' Usage:
'   Dim style As Map = YogaStyle.Conditional(isActive, activeStyle, inactiveStyle)
' ============================================================
Public Sub Conditional(condition As Boolean, trueStyle As Map, falseStyle As Map) As Map
	If condition Then Return trueStyle Else Return falseStyle
End Sub

' ============================================================
' DYNAMIC STYLE — Create style with computed values
'
' Usage:
'   Dim style As Map = YogaStyle.Create( _
'       "width", screenWidth * 0.5, _
'       "padding", IIf(isTablet, 24, 12))
' ============================================================
' (Dynamic values work naturally since Create() accepts any Object values)

' ============================================================
' DIP CONVERSION HELPER
' ============================================================
Public Sub DipToCurrent1(value As Float) As Float
	' In B4X, use dip-to-pixel conversion
	' This wraps the standard DipToCurrent function
	Return value * GetDeviceLayoutValues.Scale
End Sub

