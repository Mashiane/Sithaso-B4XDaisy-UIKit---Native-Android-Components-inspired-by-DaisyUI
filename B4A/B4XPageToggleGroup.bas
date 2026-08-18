B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private PAGE_PAD As Int = 12dip

	' Text view to display logs of selection changes
	Private lblLog As B4XDaisyText
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the ToggleGroup demo page.
''' </summary>
Public Sub Initialize As Object
	Return Me
End Sub

''' <summary>
''' B4XPage Created event.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders linear, sequential examples demonstrating the B4XDaisyToggleGroup component properties, size dependencies, and event logic.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	' Event log display section at the top of the demo
	y = AddSectionTitle("Event Log", y, maxW)
	lblLog.Initialize(Me, "")
	lblLog.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
	lblLog.Text = "Interact with toggles below to see events here..."
	lblLog.TextColor = xui.Color_RGB(100, 110, 120)
	lblLog.TextSize = 12
	y = y + 36dip

	''' <summary>
	''' Example 1: Basic Vertical ToggleGroup
	''' Demonstrates vertical stacked items, default MD size, and neutral color theme.
	''' </summary>
	y = AddSectionTitle("1. Basic Vertical Stack", y, maxW)
	Dim g1 As B4XDaisyToggleGroup
	g1.Initialize(Me, "group1")
	g1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g1.Legend = "Select notification channels"
	g1.Items = CreateMap("email": "Email Updates", "sms": "SMS Alerts", "push": "Push Notifications")
	g1.Checked = "email;push"
	y = y + g1.GetComputedHeight + 16dip

	''' <summary>
	''' Example 2: Vertical Stack with Left-Aligned Labels
	''' Demonstrates vertical stacked items with toggle on the right (label on left).
	''' </summary>
	y = AddSectionTitle("2. Vertical Stack (Labels Left, Toggle Right)", y, maxW)
	Dim g2 As B4XDaisyToggleGroup
	g2.Initialize(Me, "group2")
	g2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g2.Legend = "Select privacy options"
	g2.Direction = "vertical"
	g2.Alignment = "end"
	g2.ToggleColor = "success"
	g2.Items = CreateMap("tracking": "Allow tracking", "cookies": "Accept cookies", "analytics": "Send analytics")
	g2.Checked = "cookies"
	y = y + g2.GetComputedHeight + 16dip

	''' <summary>
	''' Example 3: Size Variants & LegendSize Dependency
	''' Demonstrates size scaling (XS and LG) and checks how LegendSize automatically couples to control size when set to "theme".
	''' </summary>
	y = AddSectionTitle("3. Size Scaling & Legend Size Coupling", y, maxW)
	
	' Extra Small (xs) with default "theme" LegendSize -> resolves to text-xs
	Dim g3xs As B4XDaisyToggleGroup
	g3xs.Initialize(Me, "group3xs")
	g3xs.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g3xs.Legend = "XS Size (Coupled Legend Size)"
	g3xs.ToggleSize = "xs"
	g3xs.Items = CreateMap("debug": "Debug logging", "verbose": "Verbose logging")
	y = y + g3xs.GetComputedHeight + 12dip

	' Large (lg) with default "theme" LegendSize -> resolves to text-base
	Dim g3lg As B4XDaisyToggleGroup
	g3lg.Initialize(Me, "group3lg")
	g3lg.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g3lg.Legend = "LG Size (Coupled Legend Size)"
	g3lg.ToggleSize = "lg"
	g3lg.ToggleColor = "primary"
	g3lg.Items = CreateMap("sync": "Auto sync", "backup": "Auto backup", "optimize": "Auto optimize")
	y = y + g3lg.GetComputedHeight + 16dip

	''' <summary>
	''' Example 4: Styling Overrides & Inset Borders
	''' Demonstrates custom background, border colors, and inset styling on the fieldset container.
	''' </summary>
	y = AddSectionTitle("4. Inset Style & Colors Override", y, maxW)
	Dim g4 As B4XDaisyToggleGroup
	g4.Initialize(Me, "group4")
	g4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g4.Legend = "Colors override legend"
	g4.BorderStyle = "inset"
	g4.BackgroundColor = xui.Color_RGB(240, 253, 244) ' Warm green tint
	g4.BorderColor = xui.Color_RGB(34, 197, 94)     ' Green border
	g4.ToggleColor = "success"
	g4.Items = CreateMap("terms": "Accept terms", "policy": "Accept privacy policy")
	y = y + g4.GetComputedHeight + 16dip

	''' <summary>
	''' Example 5: Label Above & Required Variations
	''' Demonstrates toggle groups with LabelAbove set to True, showing variations of required (with red star) and not required.
	''' </summary>
	y = AddSectionTitle("5. Label Above (Required & Not Required)", y, maxW)
	
	Dim g5a As B4XDaisyToggleGroup
	g5a.Initialize(Me, "group5a")
	g5a.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g5a.Legend = "Required: Enable Notification Channels"
	g5a.LabelAbove = True
	g5a.Required = True
	g5a.Items = CreateMap("email": "Email alerts", "sms": "SMS alerts", "push": "Push alerts")
	y = y + g5a.GetComputedHeight + 12dip

	Dim g5b As B4XDaisyToggleGroup
	g5b.Initialize(Me, "group5b")
	g5b.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g5b.Legend = "Not Required: Optional integrations"
	g5b.LabelAbove = True
	g5b.Required = False
	g5b.Items = CreateMap("slack": "Slack", "discord": "Discord")
	y = y + g5b.GetComputedHeight + 16dip

	''' <summary>
	''' Example 6: Input Border by Variant
	''' Demonstrates InputBorder=True combined with each Variant so the fieldset border
	''' picks up the variant color (mirrors B4XDaisyFieldset variant border behavior).
	''' </summary>
	y = AddSectionTitle("6. Input Border by Variant", y, maxW)
	Dim ibVariants() As String = Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
	For Each vname As String In ibVariants
		Dim gIB As B4XDaisyToggleGroup
		gIB.Initialize(Me, "groupib")
		gIB.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
		gIB.Legend = "InputBorder: " & vname
		gIB.Variant = vname
		gIB.InputBorder = True
		gIB.ToggleColor = vname
		gIB.Items = CreateMap("a": "Option A", "b": "Option B")
		y = y + gIB.GetComputedHeight + 10dip
	Next
	''' <summary>
	''' Example 7: Empty Legend
	''' Demonstrates a group with Legend = "" (no caption). Classic style now sits
	''' flush to the top (no wasted legend strip); LabelAbove style is a label-less box.
	''' </summary>
	y = AddSectionTitle("7. Empty Legend", y, maxW)

	Dim g7a As B4XDaisyToggleGroup
	g7a.Initialize(Me, "group7a")
	g7a.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g7a.Legend = ""
	g7a.Items = CreateMap("a": "Option A", "b": "Option B")
	y = y + g7a.GetComputedHeight + 12dip

	Dim g7b As B4XDaisyToggleGroup
	g7b.Initialize(Me, "group7b")
	g7b.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g7b.Legend = ""
	g7b.LabelAbove = True
	g7b.Items = CreateMap("x": "Option X", "y": "Option Y")
	y = y + g7b.GetComputedHeight + 16dip

	''' <summary>
	''' Example 8: Bold Legend
	''' Demonstrates LegendBold = True so the legend caption renders in bold.
	''' </summary>
	y = AddSectionTitle("8. Bold Legend", y, maxW)

	Dim g8 As B4XDaisyToggleGroup
	g8.Initialize(Me, "group8")
	g8.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
	g8.Legend = "Bold legend caption"
	g8.LegendBold = True
	g8.Items = CreateMap("a": "Option A", "b": "Option B")
	y = y + g8.GetComputedHeight + 16dip

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Spawns a stylized section header for the demo logic.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
	Dim title As B4XDaisyText
	title.Initialize(Me, "")
	title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
	title.Text = Text
	title.TextColor = xui.Color_RGB(30, 41, 59)
	title.TextSize = 16
	title.FontBold = True
	Return Y + 30dip
End Sub
#End Region

#Region Page Lifecycle Events
Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub
#End Region

#Region ToggleGroup Events Delegation
Private Sub group1_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 1 Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group1_Changed(SelectedIds As List)
End Sub

Private Sub group2_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 2 Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group2_Changed(SelectedIds As List)
End Sub

Private Sub group3xs_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 3 (XS) Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group3lg_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 3 (LG) Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group4_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 4 Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group5a_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 5a (Required) Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group5b_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 5b (Not Required) Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub
#End Region
