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
	Private ExampleDefs As List
	Private PAGE_PAD As Int = 12dip
	Private ROW_GAP As Int = 8dip
	Private ServerPulseStatus As B4XDaisyStatus
	Private ServerSteadyStatus As B4XDaisyStatus
	Private ServerStateLabel As B4XView
	Private mServerOnline As Boolean = False
	Private mServerLoopEnabled As Boolean = False
	Private mServerLoopRunning As Boolean = False
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Status")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	BuildExampleDefinitions
	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
	mServerLoopEnabled = True
	If mServerLoopRunning = False Then
		CallSubDelayed(Me, "ServerStatusLoop")
	End If
	ApplyServerStatusState
End Sub

Private Sub B4XPage_Disappear
	mServerLoopEnabled = False
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub BuildExampleDefinitions
	ExampleDefs.Initialize

	Dim baseItems As List
	baseItems.Initialize
	baseItems.Add(StatusItem("md", "none"))
	ExampleDefs.Add(CreateMap("kind":"status", "title":"Status", "items":baseItems))

	Dim sizeItems As List
	sizeItems.Initialize
	sizeItems.Add(StatusItem("xs", "none"))
	sizeItems.Add(StatusItem("sm", "none"))
	sizeItems.Add(StatusItem("md", "none"))
	sizeItems.Add(StatusItem("lg", "none"))
	sizeItems.Add(StatusItem("xl", "none"))
	ExampleDefs.Add(CreateMap("kind":"status", "title":"Status sizes", "items":sizeItems))

	Dim colorItems As List
	colorItems.Initialize
	colorItems.Add(StatusItem("md", "primary"))
	colorItems.Add(StatusItem("md", "secondary"))
	colorItems.Add(StatusItem("md", "accent"))
	colorItems.Add(StatusItem("md", "neutral"))
	colorItems.Add(StatusItem("md", "info"))
	colorItems.Add(StatusItem("md", "success"))
	colorItems.Add(StatusItem("md", "warning"))
	colorItems.Add(StatusItem("md", "error"))
	ExampleDefs.Add(CreateMap("kind":"status", "title":"Status with colors", "items":colorItems))

	ExampleDefs.Add(CreateMap("kind":"ping", "title":"Status with ping animation", "note":"Server is down"))
	ExampleDefs.Add(CreateMap("kind":"bounce", "title":"Status with bounce animation", "note":"Unread messages"))
End Sub

Private Sub StatusItem(SizeToken As String, VariantToken As String) As Map
	Dim m As Map
	m.Initialize
	m.Put("size", SizeToken)
	m.Put("variant", VariantToken)
	Return m
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	If ExampleDefs.IsInitialized = False Then Return
	pnlHost.RemoveAllViews
	Dim e As B4XView
	ServerStateLabel = e

	Dim maxW As Int = Max(160dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	For Each section As Map In ExampleDefs
		Dim kind As String = section.GetDefault("kind", "status")
		Select Case kind
			Case "status"
				y = RenderStatusSection(section, maxW, y)
			Case "ping"
				y = RenderPingSection(section, maxW, y)
			Case "bounce"
				y = RenderBounceSection(section, maxW, y)
		End Select
	Next

	pnlHost.Height = Max(Height, y + PAGE_PAD)
	ApplyServerStatusState
End Sub

Private Sub RenderStatusSection(Section As Map, MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim title As String = Section.GetDefault("title", "")
	Dim note As String = Section.GetDefault("note", "")
	Dim items As List = Section.Get("items")

	Dim titleLbl As B4XView = CreateSectionLabel(title, 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	If note.Length > 0 Then
		Dim noteLbl As B4XView = CreateSectionLabel(note, 11, xui.Color_RGB(100, 116, 139), False)
		pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
		y = y + 18dip
	End If

	Dim rowPanel As B4XView = xui.CreatePanel("")
	rowPanel.Color = xui.Color_Transparent
	pnlHost.AddView(rowPanel, PAGE_PAD, y, MaxW, 1dip)
	Dim rowH As Int = LayoutStatusItems(rowPanel, MaxW, items, title)
	rowPanel.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub LayoutStatusItems(RowPanel As B4XView, MaxW As Int, Items As List, SectionName As String) As Int
	Dim x As Int = 0
	Dim y As Int = 0
	Dim rowH As Int = 0
	For i = 0 To Items.Size - 1
		Dim item As Map = Items.Get(i)
		Dim status As B4XDaisyStatus
		status.Initialize(Me, "status")
		ApplyStatusItem(status, item, SectionName & "-" & i)
		Dim statusView As B4XView = status.AddToParent(RowPanel, 0, 0, 0, 0)
		Dim sw As Int = Max(1dip, statusView.Width)
		Dim sh As Int = Max(1dip, statusView.Height)

		If x > 0 And x + sw > MaxW Then
			x = 0
			y = y + rowH + ROW_GAP
			rowH = 0
		End If

		statusView.SetLayoutAnimated(0, x, y, sw, sh)
		x = x + sw + ROW_GAP
		rowH = Max(rowH, sh)
	Next
	Return Max(1dip, y + rowH)
End Sub

Private Sub ApplyStatusItem(StatusComp As B4XDaisyStatus, Item As Map, TagId As String)
	Dim sizeToken As String = Item.GetDefault("size", "md")
	If sizeToken = Null Or sizeToken.Trim.Length = 0 Then sizeToken = "md"
	Dim variantToken As String = Item.GetDefault("variant", "none")
	If variantToken = Null Or variantToken.Trim.Length = 0 Then variantToken = "none"
	StatusComp.setTag(TagId)
	StatusComp.setSize(sizeToken)
	StatusComp.setVariant(variantToken)
End Sub

Private Sub RenderPingSection(Section As Map, MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim title As String = Section.GetDefault("title", "Status with ping animation")
	Dim note As String = Section.GetDefault("note", "Server is down")

	Dim titleLbl As B4XView = CreateSectionLabel(title, 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim rowPanel As B4XView = xui.CreatePanel("")
	rowPanel.Color = xui.Color_Transparent
	pnlHost.AddView(rowPanel, PAGE_PAD, y, MaxW, 1dip)

	Dim pingWrap As B4XView = xui.CreatePanel("")
	pingWrap.Color = xui.Color_Transparent
	rowPanel.AddView(pingWrap, 0, 0, 1dip, 1dip)

	Dim pulse As B4XDaisyStatus
	pulse.Initialize(Me, "status")
	pulse.setVariant("error")
	pulse.setSize("md")
	pulse.setDepth(1)
	pulse.setAnimation("pulse")
	Dim pulseView As B4XView = pulse.AddToParent(pingWrap, 0, 0, 0, 0)
	ServerPulseStatus = pulse

	Dim steady As B4XDaisyStatus
	steady.Initialize(Me, "status")
	steady.setVariant("error")
	steady.setSize("md")
	steady.setDepth(1)
	steady.setAnimation("none")
	Dim steadyView As B4XView = steady.AddToParent(pingWrap, 0, 0, 0, 0)
	ServerSteadyStatus = steady

	Dim dotSize As Int = Max(8dip, Max(Max(pulseView.Width, pulseView.Height), Max(steadyView.Width, steadyView.Height)))
	pingWrap.SetLayoutAnimated(0, 0, 0, dotSize, dotSize)
	pulse.CenterInParent(pingWrap)
	steady.CenterInParent(pingWrap)

	Dim lbl As B4XView = CreateSectionLabel(note, 12, xui.Color_RGB(71, 85, 105), False)
	rowPanel.AddView(lbl, dotSize + 10dip, 0, Max(1dip, MaxW - dotSize - 10dip), 22dip)
	ServerStateLabel = lbl
	Dim rowH As Int = Max(dotSize, 22dip)
	pingWrap.SetLayoutAnimated(0, 0, (rowH - dotSize) / 2, dotSize, dotSize)
	lbl.SetLayoutAnimated(0, dotSize + 10dip, (rowH - 22dip) / 2, Max(1dip, MaxW - dotSize - 10dip), 22dip)
	rowPanel.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)

	y = y + rowH + 14dip
	Return y
End Sub

Private Sub RenderBounceSection(Section As Map, MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim title As String = Section.GetDefault("title", "Status with bounce animation")
	Dim note As String = Section.GetDefault("note", "Unread messages")

	Dim titleLbl As B4XView = CreateSectionLabel(title, 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim rowPanel As B4XView = xui.CreatePanel("")
	rowPanel.Color = xui.Color_Transparent
	pnlHost.AddView(rowPanel, PAGE_PAD, y, MaxW, 1dip)

	Dim bounceWrap As B4XView = xui.CreatePanel("")
	bounceWrap.Color = xui.Color_Transparent
	rowPanel.AddView(bounceWrap, 0, 0, 1dip, 1dip)

	Dim bounce As B4XDaisyStatus
	bounce.Initialize(Me, "status")
	bounce.setVariant("info")
	bounce.setSize("md")
	bounce.setDepth(1)
	bounce.setAnimation("bounce")
	Dim bounceDot As B4XView = bounce.AddToParent(bounceWrap, 0, 0, 0, 0)

	Dim dotSize As Int = Max(8dip, Max(bounceDot.Width, bounceDot.Height))
	bounceWrap.SetLayoutAnimated(0, 0, 0, dotSize, dotSize)
	bounce.CenterInParent(bounceWrap)

	Dim lbl As B4XView = CreateSectionLabel(note, 12, xui.Color_RGB(71, 85, 105), False)
	rowPanel.AddView(lbl, dotSize + 10dip, 0, Max(1dip, MaxW - dotSize - 10dip), 22dip)
	Dim rowH As Int = Max(dotSize, 22dip)
	bounceWrap.SetLayoutAnimated(0, 0, (rowH - dotSize) / 2, dotSize, dotSize)
	lbl.SetLayoutAnimated(0, dotSize + 10dip, (rowH - 22dip) / 2, Max(1dip, MaxW - dotSize - 10dip), 22dip)
	rowPanel.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)

	y = y + rowH + 14dip
	Return y
End Sub

Private Sub CreateSectionLabel(Text As String, Size As Int, Color As Int, Bold As Boolean) As B4XView
	Dim l As Label
	l.Initialize("")
	Dim x As B4XView = l
	x.Text = Text
	x.TextColor = Color
	If Bold Then
		x.Font = xui.CreateDefaultBoldFont(Size)
	Else
		x.Font = xui.CreateDefaultFont(Size)
	End If
	x.SetTextAlignment("CENTER", "LEFT")
	x.Color = xui.Color_Transparent
	Return x
End Sub

Private Sub ServerStatusLoop As ResumableSub
	If mServerLoopRunning Then Return True
	mServerLoopRunning = True
	Do While mServerLoopEnabled
		Sleep(5000)
		If mServerLoopEnabled = False Then Exit
		mServerOnline = Not(mServerOnline)
		ApplyServerStatusState
	Loop
	mServerLoopRunning = False
	Return True
End Sub

Private Sub ApplyServerStatusState
	If ServerStateLabel.IsInitialized Then
		If mServerOnline Then
			ServerStateLabel.Text = "Server is online"
		Else
			ServerStateLabel.Text = "Server is down"
		End If
	End If
	If ServerPulseStatus.IsInitialized Then
		ServerPulseStatus.setVariant(IIf(mServerOnline, "success", "error"))
	End If
	If ServerSteadyStatus.IsInitialized Then
		ServerSteadyStatus.setVariant(IIf(mServerOnline, "success", "error"))
	End If
End Sub
