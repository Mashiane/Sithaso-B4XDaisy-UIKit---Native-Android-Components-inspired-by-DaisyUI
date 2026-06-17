B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12
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
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Toggle Group")

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
	Log("Group 1 Selection Changed: " & SelectedIds)
End Sub

Private Sub group2_ItemChanged(Id As String, Text As String, Checked As Boolean)
	lblLog.Text = "Group 2 Item Changed: " & Id & " (" & Text & ") = " & Checked
End Sub

Private Sub group2_Changed(SelectedIds As List)
	Log("Group 2 Selection Changed: " & SelectedIds)
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
#End Region
