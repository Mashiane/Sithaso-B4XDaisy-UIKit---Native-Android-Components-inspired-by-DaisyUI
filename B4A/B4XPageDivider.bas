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
	Private PAGE_PAD As Int = 12dip
	Private ROW_GAP As Int = 20dip
	Private DIVIDER_CONTENT_H As Int = 16dip
	Private DIVIDER_MARGIN_X As Int = 4dip
	Private DIVIDER_MARGIN_Y As Int = 4dip
	Private DIVIDER_HOST_H As Int = 24dip
	Private DIVIDER_TEXT_SIZE As String = "text-sm"
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Divider")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD
	
	' Basic vertical example
	y = RenderSectionHeader(maxW, y, "Divider", "")
	Dim basicCardH As Int = 72dip
	Dim basicRowH As Int = basicCardH + DIVIDER_HOST_H + basicCardH
	Dim basicRow As B4XView = CreateRowPanel(maxW, basicRowH)
	pnlHost.AddView(basicRow, PAGE_PAD, y, maxW, basicRowH)
	AddDemoCard(basicRow, 0, 0, maxW, basicCardH, "content")
	AddDemoDivider(basicRow, 0, basicCardH, maxW, DIVIDER_CONTENT_H, "OR", "vertical", "default", "none", "basic-vertical")
	AddDemoCard(basicRow, 0, basicCardH + DIVIDER_HOST_H, maxW, basicCardH, "content")
	y = y + basicRow.Height + ROW_GAP

	' Basic horizontal example
	y = RenderSectionHeader(maxW, y, "Divider horizontal", "")
	Dim hCardH As Int = 72dip
	Dim hRow As B4XView = CreateRowPanel(maxW, hCardH)
	pnlHost.AddView(hRow, PAGE_PAD, y, maxW, hCardH)
	Dim hDividerContentW As Int = Max(24dip, MeasureTextWidthDip("OR", ResolveDividerTextSizeDip) + 8dip)
	Dim hDividerHostW As Int = hDividerContentW + (DIVIDER_MARGIN_X * 2)
	Dim hCardW As Int = Max(60dip, (maxW - hDividerHostW) / 2)
	AddDemoCard(hRow, 0, 0, hCardW, hCardH, "content")
	AddDemoDivider(hRow, hCardW, 0, hDividerContentW, hCardH, "OR", "horizontal", "default", "none", "basic-horizontal")
	AddDemoCard(hRow, hCardW + hDividerHostW, 0, maxW - hCardW - hDividerHostW, hCardH, "content")
	y = y + hRow.Height + ROW_GAP

	' No-text example
	y = RenderSectionHeader(maxW, y, "Divider with no text", "")
	Dim ntCardH As Int = 72dip
	Dim ntRowH As Int = ntCardH + DIVIDER_HOST_H + ntCardH
	Dim ntRow As B4XView = CreateRowPanel(maxW, ntRowH)
	pnlHost.AddView(ntRow, PAGE_PAD, y, maxW, ntRowH)
	AddDemoCard(ntRow, 0, 0, maxW, ntCardH, "content")
	AddDemoDivider(ntRow, 0, ntCardH, maxW, DIVIDER_CONTENT_H, "", "vertical", "default", "none", "no-text")
	AddDemoCard(ntRow, 0, ntCardH + DIVIDER_HOST_H, maxW, ntCardH, "content")
	y = y + ntRow.Height + ROW_GAP

	' Responsive orientation example
	y = RenderSectionHeader(maxW, y, "responsive (lg:divider-horizontal)", "Switches orientation based on available width.")
	If maxW >= 520dip Then
		Dim rCardH As Int = 128dip
		Dim rRowH As Int = rCardH
		Dim rRow As B4XView = CreateRowPanel(maxW, rRowH)
		pnlHost.AddView(rRow, PAGE_PAD, y, maxW, rRowH)
		Dim rDividerContentW As Int = Max(24dip, MeasureTextWidthDip("OR", ResolveDividerTextSizeDip) + 8dip)
		Dim rDividerHostW As Int = rDividerContentW + (DIVIDER_MARGIN_X * 2)
		Dim rCardW As Int = Max(70dip, (maxW - rDividerHostW) / 2)
		AddDemoCard(rRow, 0, 0, rCardW, rCardH, "content")
		AddDemoDivider(rRow, rCardW, 0, rDividerContentW, rCardH, "OR", "horizontal", "default", "none", "responsive-horizontal")
		AddDemoCard(rRow, rCardW + rDividerHostW, 0, maxW - rCardW - rDividerHostW, rCardH, "content")
		y = y + rRow.Height + ROW_GAP
	Else
		Dim rCardH2 As Int = 128dip
		Dim rRowH2 As Int = rCardH2 + DIVIDER_HOST_H + rCardH2
		Dim rRow2 As B4XView = CreateRowPanel(maxW, rRowH2)
		pnlHost.AddView(rRow2, PAGE_PAD, y, maxW, rRowH2)
		AddDemoCard(rRow2, 0, 0, maxW, rCardH2, "content")
		AddDemoDivider(rRow2, 0, rCardH2, maxW, DIVIDER_CONTENT_H, "OR", "vertical", "default", "none", "responsive-vertical")
		AddDemoCard(rRow2, 0, rCardH2 + DIVIDER_HOST_H, maxW, rCardH2, "content")
		y = y + rRow2.Height + ROW_GAP
	End If

	' Color variants
	y = RenderSectionHeader(maxW, y, "Divider with colors", "")
	Dim colorRowH As Int = DIVIDER_HOST_H * 9
	Dim colorRow As B4XView = CreateRowPanel(maxW, colorRowH)
	pnlHost.AddView(colorRow, PAGE_PAD, y, maxW, colorRowH)
	Dim cy As Int = 0
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Default", "vertical", "default", "none", "color-default")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Neutral", "vertical", "default", "neutral", "color-neutral")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Primary", "vertical", "default", "primary", "color-primary")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Secondary", "vertical", "default", "secondary", "color-secondary")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Accent", "vertical", "default", "accent", "color-accent")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Success", "vertical", "default", "success", "color-success")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Warning", "vertical", "default", "warning", "color-warning")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Info", "vertical", "default", "info", "color-info")
	cy = cy + DIVIDER_HOST_H
	AddDemoDivider(colorRow, 0, cy, maxW, DIVIDER_CONTENT_H, "Error", "vertical", "default", "error", "color-error")
	y = y + colorRow.Height + ROW_GAP

	' Vertical placements
	y = RenderSectionHeader(maxW, y, "Divider in different positions", "")
	Dim vpRowH As Int = DIVIDER_HOST_H * 3
	Dim vpRow As B4XView = CreateRowPanel(maxW, vpRowH)
	pnlHost.AddView(vpRow, PAGE_PAD, y, maxW, vpRowH)
	AddDemoDivider(vpRow, 0, 0, maxW, DIVIDER_CONTENT_H, "Start", "vertical", "start", "none", "pos-v-start")
	AddDemoDivider(vpRow, 0, DIVIDER_HOST_H, maxW, DIVIDER_CONTENT_H, "Default", "vertical", "default", "none", "pos-v-default")
	AddDemoDivider(vpRow, 0, DIVIDER_HOST_H * 2, maxW, DIVIDER_CONTENT_H, "End", "vertical", "end", "none", "pos-v-end")
	y = y + vpRow.Height + ROW_GAP

	' Horizontal placements
	y = RenderSectionHeader(maxW, y, "Divider in different positions (horizontal)", "")
	Dim hpDividerH As Int = 152dip
	Dim hpRow As B4XView = CreateRowPanel(maxW, hpDividerH)
	pnlHost.AddView(hpRow, PAGE_PAD, y, maxW, hpDividerH)
	Dim hpStartW As Int = Max(24dip, MeasureTextWidthDip("Start", ResolveDividerTextSizeDip) + 8dip)
	Dim hpDefaultW As Int = Max(24dip, MeasureTextWidthDip("Default", ResolveDividerTextSizeDip) + 8dip)
	Dim hpEndW As Int = Max(24dip, MeasureTextWidthDip("End", ResolveDividerTextSizeDip) + 8dip)
	Dim hpStartHostW As Int = hpStartW + (DIVIDER_MARGIN_X * 2)
	Dim hpDefaultHostW As Int = hpDefaultW + (DIVIDER_MARGIN_X * 2)
	Dim hpEndHostW As Int = hpEndW + (DIVIDER_MARGIN_X * 2)
	Dim hpGapX As Int = 12dip
	Dim hpTotalW As Int = hpStartHostW + hpDefaultHostW + hpEndHostW + (hpGapX * 2)
	Dim hpLeft As Int = Max(0, (maxW - hpTotalW) / 2)
	AddDemoDivider(hpRow, hpLeft, 0, hpStartW, hpDividerH, "Start", "horizontal", "start", "none", "pos-h-start")
	AddDemoDivider(hpRow, hpLeft + hpStartHostW + hpGapX, 0, hpDefaultW, hpDividerH, "Default", "horizontal", "default", "none", "pos-h-default")
	AddDemoDivider(hpRow, hpLeft + hpStartHostW + hpGapX + hpDefaultHostW + hpGapX, 0, hpEndW, hpDividerH, "End", "horizontal", "end", "none", "pos-h-end")
	y = y + hpRow.Height + ROW_GAP

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub CreateRowPanel(Width As Int, Height As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.Color = xui.Color_Transparent
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	Return p
End Sub

Private Sub AddDemoCard(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int, Text As String)
	Dim baseDiv As B4XDaisyDivision
	baseDiv.Initialize(Me, "")
	baseDiv.AddToParent(Parent, Left, Top, Width, Height)
	baseDiv.PlaceContentCenter = True
	baseDiv.RoundedBox = True
	baseDiv.Text = Text
	baseDiv.setTextSize(DIVIDER_TEXT_SIZE)
	baseDiv.BackgroundColorVariant = "bg-base-300"
	baseDiv.TextColorVariant = "text-neutral-content"
End Sub

Private Sub AddDemoDivider(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int, Text As String, Direction As String, Placement As String, Variant As String, TagId As String) As B4XDaisyDivider
	Return AddDemoDividerWithTextSize(Parent, Left, Top, Width, Height, Text, Direction, Placement, Variant, TagId, DIVIDER_TEXT_SIZE)
End Sub

Private Sub AddDemoDividerWithTextSize(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int, Text As String, Direction As String, Placement As String, Variant As String, TagId As String, TextSizeToken As String) As B4XDaisyDivider
	Dim div As B4XDaisyDivider
	div.Initialize(Me, "divider")
	div.AddToParent(Parent, Left, Top, Width, Height)
	div.Direction = Direction
	div.Placement = Placement
	div.Variant = Variant
	div.Text = Text
	div.TextSize = TextSizeToken
	div.Margin = DefaultDividerMargin(Direction)
	div.Tag = TagId
	Return div
End Sub

Private Sub DefaultDividerMargin(Direction As String) As String
	Dim d As String = IIf(Direction = Null, "", Direction.ToLowerCase.Trim)
	If d = "horizontal" Then Return "mx-1"
	Return "my-1"
End Sub

Private Sub RenderSectionHeader(MaxW As Int, StartY As Int, Title As String, Note As String) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel(Title, 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip
	If Note.Trim.Length > 0 Then
		Dim noteLbl As B4XView = CreateSectionLabel(Note, 11, xui.Color_RGB(100, 116, 139), False)
		pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
		y = y + 18dip
	End If
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

Private Sub MeasureTextWidthDip(Text As String, FontSize As Float) As Int
	Dim t As String = Text
	If t = Null Then t = ""
	t = t.Trim
	If t.Length = 0 Then Return 0
	Dim extraPad As Int = Max(6dip, Min(24dip, t.Length * 3dip))
	Dim lbl As Label
	lbl.Initialize("")
	Dim measureView As B4XView = lbl
	Try
		If Root.IsInitialized Then
			Root.AddView(measureView, 0, 0, 1dip, 1dip)
			Dim c As Canvas
			c.Initialize(lbl)
			Dim w As Float = c.MeasureStringWidth(t, lbl.Typeface, FontSize)
			measureView.RemoveViewFromParent
			Return Max(1dip, Ceil(w) + extraPad)
		End If
	Catch
		If measureView.IsInitialized Then measureView.RemoveViewFromParent
	End Try
	Return Max(1dip, Ceil(t.Length * FontSize * 0.7) + extraPad)
End Sub

Private Sub ResolveDividerTextSizeDip As Float
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(DIVIDER_TEXT_SIZE, 14, 20)
	Return tm.GetDefault("font_size", 14)
End Sub

Private Sub divider_Click(Tag As Object)
	#If B4A
	Dim s As String = Tag
	If s.Length = 0 Then s = "divider"
	ToastMessageShow("Clicked: " & s, False)
	#End If
End Sub
