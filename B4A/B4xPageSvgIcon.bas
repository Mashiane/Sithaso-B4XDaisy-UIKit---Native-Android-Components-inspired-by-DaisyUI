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
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "SVG Icon")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	y = RenderVariantCard(maxW, y)
	y = RenderSizeCard(maxW, y)
	y = RenderIndicatorCard(maxW, y)
	y = RenderCounterCard(maxW, y)

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub RenderVariantCard(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Variant-based SVG icons", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Same icon rendered with Daisy variants", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim cardH As Int = 190dip
	Dim card As B4XView = CreateCard(MaxW, y, cardH)

	Dim variants() As String = Array As String("primary", "secondary", "accent", "neutral", "info", "success", "warning", "error")
	Dim cols As Int = 4
	Dim cellW As Int = (MaxW - 24dip) / cols
	Dim iconSize As Int = 44dip

	For i = 0 To variants.Length - 1
		Dim v As String = variants(i)
		Dim col As Int = i Mod cols
		Dim row As Int = i / cols
		Dim cellLeft As Int = 12dip + (col * cellW)
		Dim cellTop As Int = 12dip + (row * 82dip)

		Dim iconLeft As Int = cellLeft + (cellW - iconSize) / 2
		Dim iconTop As Int = cellTop

		Dim iconComp As B4XDaisySvgIcon
		iconComp.Initialize(Me, "")
		Dim iconView As B4XView = iconComp.AddToParent(card, iconLeft, iconTop, iconSize, iconSize)
		iconComp.setSvgAsset("book-open-solid.svg")
		iconComp.setPreserveOriginalColors(False)
		iconComp.setColorVariant(v)
		iconComp.setSize("28px")
		iconComp.ResizeToParent(iconView)

		Dim lbl As Label
		lbl.Initialize("")
		Dim xLbl As B4XView = lbl
		xLbl.Text = v
		xLbl.Font = xui.CreateDefaultFont(11)
		xLbl.TextColor = xui.Color_RGB(71, 85, 105)
		xLbl.SetTextAlignment("CENTER", "CENTER")
		card.AddView(xLbl, cellLeft, iconTop + iconSize + 4dip, cellW, 16dip)
	Next

	y = y + cardH + 14dip
	Return y
End Sub

Private Sub RenderSizeCard(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("SVG icons with different sizes", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Size is set using px tokens on setSize()", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim sizeSpecs() As String = Array As String("12px", "16px", "20px", "24px", "32px", "40px")
	Dim cols As Int = 3
	Dim rows As Int = Ceil(sizeSpecs.Length / cols)
	Dim cardH As Int = 18dip + (rows * 96dip)
	Dim card As B4XView = CreateCard(MaxW, y, cardH)

	Dim cellW As Int = (MaxW - 24dip) / cols
	For i = 0 To sizeSpecs.Length - 1
		Dim s As String = sizeSpecs(i)
		Dim col As Int = i Mod cols
		Dim row As Int = i / cols
		Dim cellLeft As Int = 12dip + (col * cellW)
		Dim cellTop As Int = 12dip + (row * 96dip)
		Dim iconBox As Int = 56dip
		Dim iconLeft As Int = cellLeft + (cellW - iconBox) / 2
		Dim iconTop As Int = cellTop + 4dip

		Dim iconComp As B4XDaisySvgIcon
		iconComp.Initialize(Me, "")
		Dim iconView As B4XView = iconComp.AddToParent(card, iconLeft, iconTop, iconBox, iconBox)
		iconComp.setSvgAsset("book-open-solid.svg")
		iconComp.setPreserveOriginalColors(False)
		iconComp.setColorVariant("primary")
		iconComp.setSize(s)
		iconComp.ResizeToParent(iconView)

		Dim lbl As Label
		lbl.Initialize("")
		Dim xLbl As B4XView = lbl
		xLbl.Text = s
		xLbl.Font = xui.CreateDefaultFont(11)
		xLbl.TextColor = xui.Color_RGB(71, 85, 105)
		xLbl.SetTextAlignment("CENTER", "CENTER")
		card.AddView(xLbl, cellLeft, iconTop + iconBox + 4dip, cellW, 16dip)
	Next

	y = y + cardH + 14dip
	Return y
End Sub

Private Sub RenderIndicatorCard(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("SVG icon with indicator", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Top-right success indicator on bell icon", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim cardH As Int = 150dip
	Dim card As B4XView = CreateCard(MaxW, y, cardH)

	Dim iconSize As Int = 72dip
	Dim iconLeft As Int = (MaxW - iconSize) / 2
	Dim iconTop As Int = 28dip

	Dim iconComp As B4XDaisySvgIcon
	iconComp.Initialize(Me, "")
	Dim iconView As B4XView = iconComp.AddToParent(card, iconLeft, iconTop, iconSize, iconSize)
	iconComp.setSvgAsset("bell-solid.svg")
	iconComp.setPreserveOriginalColors(False)
	iconComp.setColorVariant("neutral")
	iconComp.setSize("42px")
	iconComp.ResizeToParent(iconView)

	Dim ind As B4XDaisyIndicator
	ind.Initialize(Me, "indicator")
	ind.setTag("svg-indicator")
	ind.setText("")
	ind.setVariant("success")
	ind.setSize("sm")
	ind.setHorizontalPlacement("end")
	ind.setVerticalPlacement("top")
	ind.AddToParent(card, iconLeft, iconTop, iconSize, iconSize)
	Dim indTarget As B4XView = iconComp.GetContentView
	If indTarget.IsInitialized Then
		ind.AttachToTarget(indTarget)
	Else
		ind.AttachToTarget(iconView)
	End If

	y = y + cardH + 14dip
	Return y
End Sub

Private Sub RenderCounterCard(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("SVG icon with counter value", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Top-right counter badge showing value = 12", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim cardH As Int = 150dip
	Dim card As B4XView = CreateCard(MaxW, y, cardH)

	Dim iconSize As Int = 72dip
	Dim iconLeft As Int = (MaxW - iconSize) / 2
	Dim iconTop As Int = 28dip

	Dim iconComp As B4XDaisySvgIcon
	iconComp.Initialize(Me, "")
	Dim iconView As B4XView = iconComp.AddToParent(card, iconLeft, iconTop, iconSize, iconSize)
	iconComp.setSvgAsset("bell-solid.svg")
	iconComp.setPreserveOriginalColors(False)
	iconComp.setColorVariant("neutral")
	iconComp.setSize("42px")
	iconComp.ResizeToParent(iconView)

	Dim countInd As B4XDaisyIndicator
	countInd.Initialize(Me, "indicator")
	countInd.setTag("svg-counter")
	countInd.setCounter(True)
	countInd.setText("12")
	countInd.setVariant("error")
	countInd.setRounded("rounded-full")
	countInd.setSize("sm")
	countInd.setHorizontalPlacement("end")
	countInd.setVerticalPlacement("top")
	countInd.AddToParent(card, iconLeft, iconTop, iconSize, iconSize)
	Dim countTarget As B4XView = iconComp.GetContentView
	If countTarget.IsInitialized Then
		countInd.AttachToTarget(countTarget)
	Else
		countInd.AttachToTarget(iconView)
	End If

	y = y + cardH + 14dip
	Return y
End Sub

Private Sub CreateCard(MaxW As Int, Top As Int, Height As Int) As B4XView
	Dim card As B4XView = xui.CreatePanel("")
	card.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	DisableClipping(card)
	pnlHost.AddView(card, PAGE_PAD, Top, MaxW, Height)
	Return card
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

Private Sub indicator_Click(Tag As Object)
	#If B4A
	ToastMessageShow("Indicator click: " & Tag, False)
	#End If
End Sub

Private Sub DisableClipping(v As B4XView)
	If v.IsInitialized = False Then Return
	#If B4A
	Try
		Dim jo As JavaObject = v
		jo.RunMethod("setClipChildren", Array(False))
		jo.RunMethod("setClipToPadding", Array(False))
	Catch
	End Try
	#Else
	Dim ignore As Object = v
	#End If
End Sub
