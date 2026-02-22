B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private SampleItems As List
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Loading")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	SampleItems.Initialize
	CreateSamples
	LayoutSamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	LayoutSamples(Width, Height)
End Sub

Private Sub CreateSamples
	SampleItems.Clear
	pnlHost.RemoveAllViews
	
	Dim styles() As String = Array As String("spinner", "dots", "ring", "ball", "bars", "infinity")
	Dim sizes() As String = Array As String("xs", "sm", "md", "lg", "xl")
	Dim colorNames() As String = Array As String("primary", "secondary", "accent", "neutral", "info", "success", "warning", "error")

	' 1. Size Matrix for all styles
	For Each style As String In styles
		AddHeader("Style: " & style)
		
		For Each size As String In sizes
			' Create a row for this size
			AddVariantRow(style, size, colorNames)
		Next
	Next
End Sub

Private Sub AddHeader(Title As String)
	Dim lbl As Label
	lbl.Initialize("")
	Dim x As B4XView = lbl
	x.Text = Title
	x.TextColor = xui.Color_Black
	' x.Font = xui.CreateDefaultBoldFont(16) ' xui doesn't have CreateDefaultBoldFont in strict XUI, but B4A xui does? 
	' Previous error was Unknown member: createdefaultbold. Then createdefaultboldfont.
	' Let's stick to simple text size/bold or just Typeface = Typeface.DEFAULT_BOLD (B4A specific) or xui.CreateDefaultBold (which usually works in B4XPages if XUI lib is correct).
	' Actually, B4A XUI: xui.CreateDefaultBold -> Returns B4XFont.
	' x.Font = ...
	' Let's try xui.CreateDefaultBold again or just set TextSize.
	x.TextSize = 16
	x.SetTextAlignment("CENTER", "LEFT")
	
	' B4A specific bold
	#If B4A
	Dim jo As JavaObject = x
	jo.RunMethod("setTypeface", Array(Typeface.DEFAULT_BOLD))
	#End If
	
	pnlHost.AddView(x, 0, 0, 1dip, 1dip)
	
	Dim item As Map = CreateMap( _
		"type": "header", _
		"view": x, _
		"h": 40dip _
	)
	SampleItems.Add(item)
End Sub

Private Sub AddVariantRow(Style As String, Size As String, VariantColors() As String)
	' Container for the whole row (Label + HSV)
	Dim p As Panel
	p.Initialize("")
	Dim pRow As B4XView = p
	pRow.Color = xui.Color_Transparent
	pnlHost.AddView(pRow, 0, 0, 1dip, 1dip)
	
	' Label
	Dim lbl As Label
	lbl.Initialize("")
	Dim xLbl As B4XView = lbl
	xLbl.Text = Size
	xLbl.TextColor = xui.Color_DarkGray
	xLbl.TextSize = 14
	xLbl.SetTextAlignment("CENTER", "LEFT")
	pRow.AddView(xLbl, 0, 0, 40dip, 1dip) ' Width fixed for label
	
	' Horizontal Scroll View for variants
	Dim hsv As HorizontalScrollView
	hsv.Initialize(0, "hsv")
	Dim xHsv As B4XView = hsv
	pRow.AddView(xHsv, 45dip, 0, 1dip, 1dip) ' Will resize width later
	
	' Content Panel for HSV
	Dim pContent As B4XView = hsv.Panel
	pContent.Color = xui.Color_Transparent
	
	' Add Default (currentColor)
	Dim currentX As Int = 5dip
	Dim compSize As Int = GetSizeDip(Size)
	
	currentX = AddLoadingComponent(pContent, Style, Size, "currentColor", currentX, compSize)
	
	' Add Variants
	For Each color As String In VariantColors
		currentX = AddLoadingComponent(pContent, Style, Size, color, currentX, compSize)
	Next
	
	hsv.Panel.Width = currentX
	
	' Row Height depends on component size + padding
	Dim rowH As Int = Max(40dip, compSize + 20dip)
	
	Dim item As Map = CreateMap( _
		"type": "row", _
		"view": pRow, _
		"label": xLbl, _
		"hsv": xHsv, _
		"h": rowH _
	)
	SampleItems.Add(item)
End Sub

Private Sub AddLoadingComponent(Parent As B4XView, Style As String, Size As String, Color As String, Left As Int, CompSize As Int) As Int
	Dim loading As B4XDaisyLoading
	loading.Initialize(Me, "loading")
	loading.AddToParent(Parent, Left, 10dip, CompSize, CompSize) ' 10dip top padding
	
	loading.SetStyle(Style)
	loading.SetSize(Size)
	loading.SetColor(Color)
	
	Return Left + CompSize + 15dip ' Gap
End Sub

Private Sub GetSizeDip(Size As String) As Int
	' Match B4XDaisyLoading logic roughly for the container
	Select Case Size
		Case "xs": Return 16dip
		Case "sm": Return 20dip
		Case "md": Return 24dip
		Case "lg": Return 28dip
		Case "xl": Return 32dip
	End Select
	Return 24dip
End Sub

Private Sub LayoutSamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	If SampleItems.IsInitialized = False Then Return

	Dim pad As Int = 10dip
	Dim y As Int = pad
	Dim maxW As Int = Max(1dip, Width - (pad * 2))

	For i = 0 To SampleItems.Size - 1
		Dim item As Map = SampleItems.Get(i)
		Dim v As B4XView = item.Get("view")
		Dim h As Int = item.Get("h")
		
		v.SetLayoutAnimated(0, pad, y, maxW, h)
		
		If item.Get("type") = "row" Then
			Dim xLbl As B4XView = item.Get("label")
			Dim xHsv As B4XView = item.Get("hsv")
			
			' Label: Left 30dip
			xLbl.SetLayoutAnimated(0, 0, 0, 30dip, h)
			' HSV: Rest of width
			xHsv.SetLayoutAnimated(0, 35dip, 0, maxW - 35dip, h)
			
			' Center content vertically in HSV? It's handled by TOP padding in AddLoadingComponent (10dip)
			' We might want to adjust TOP padding based on row height for perfect centering if needed
			' But fixed top padding is okay for now.
		Else
			' Header
			v.SetLayoutAnimated(0, pad, y, maxW, h)
		End If
		
		y = y + h + 5dip
	Next

	svHost.Panel.Height = Max(Height, y + 50dip)
End Sub
