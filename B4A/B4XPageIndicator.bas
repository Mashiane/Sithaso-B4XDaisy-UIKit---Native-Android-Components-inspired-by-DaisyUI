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
	Private mCounterDemoToken As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Indicator")

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

	y = RenderSidesSection(maxW, y)
	y = RenderNoTextSidesSection(maxW, y)
	y = RenderVariantSection(maxW, y)
	y = RenderAvatarSection(maxW, y)
	y = RenderCountIndicatorSection(maxW, y)
	y = RenderSvgCounterSection(maxW, y)

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub RenderSidesSection(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Indicator placements on div", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Base uses Daisy div style: bg-base-300 grid h-32 w-32 place-items-center", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	DisableClipping(row)
	pnlHost.AddView(row, PAGE_PAD, y, MaxW, 1dip)

	Dim boxSize As Int = B4XDaisyVariants.TailwindSizeToDip("32", 128dip)
	Dim boxLeft As Int = Max(0, (MaxW - boxSize) / 2)
	Dim boxTop As Int = 42dip

	Dim baseDiv As B4XDaisyDiv
	baseDiv.Initialize(Me, "")
	Dim baseView As B4XView = baseDiv.AddToParent(row, boxLeft, boxTop, boxSize, boxSize)
	baseDiv.setWidth("32")
	baseDiv.setHeight("32")
	baseDiv.setPlaceContentCenter(True)
	baseDiv.setRoundedBox(True)
	baseDiv.setText("content")
	baseDiv.setTextSize("text-sm")
	baseDiv.setBackgroundColorVariant("bg-base-300")
	baseDiv.setTextColorVariant("text-neutral-content")
	
	Dim placements As List
	placements.Initialize
	placements.Add(CreateMap("hx":"start", "vy":"top", "label":"TL"))
	placements.Add(CreateMap("hx":"center", "vy":"top", "label":"T"))
	placements.Add(CreateMap("hx":"end", "vy":"top", "label":"TR"))
	placements.Add(CreateMap("hx":"start", "vy":"middle", "label":"L"))
	placements.Add(CreateMap("hx":"center", "vy":"middle", "label":"C"))
	placements.Add(CreateMap("hx":"end", "vy":"middle", "label":"R"))
	placements.Add(CreateMap("hx":"start", "vy":"bottom", "label":"BL"))
	placements.Add(CreateMap("hx":"center", "vy":"bottom", "label":"B"))
	placements.Add(CreateMap("hx":"end", "vy":"bottom", "label":"BR"))

	For Each p As Map In placements
		Dim ind As B4XDaisyIndicator
		ind.Initialize(Me, "indicator")
		ind.setTag(p.GetDefault("label", ""))
		ind.setSize("sm")
		ind.setVariant("secondary")
		ind.setText(p.GetDefault("label", ""))
		ind.setHorizontalPlacement(p.GetDefault("hx", "end"))
		ind.setVerticalPlacement(p.GetDefault("vy", "top"))
		ind.AddToParent(row, boxLeft, boxTop, boxSize, boxSize)
		ind.AttachToTarget(baseView)
	Next

	Dim rowH As Int = boxTop + boxSize + 44dip
	row.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub RenderNoTextSidesSection(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Indicator dots on all sides (random variants)", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("No text indicators with random variant colors", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	DisableClipping(row)
	pnlHost.AddView(row, PAGE_PAD, y, MaxW, 1dip)

	Dim boxSize As Int = B4XDaisyVariants.TailwindSizeToDip("32", 128dip)
	Dim boxLeft As Int = Max(0, (MaxW - boxSize) / 2)
	Dim boxTop As Int = 34dip

	Dim baseDiv As B4XDaisyDiv
	baseDiv.Initialize(Me, "")
	Dim baseView As B4XView = baseDiv.AddToParent(row, boxLeft, boxTop, boxSize, boxSize)
	baseDiv.setWidth("32")
	baseDiv.setHeight("32")
	baseDiv.setPlaceContentCenter(True)
	baseDiv.setRoundedBox(True)
	baseDiv.setText("content")
	baseDiv.setTextSize("text-sm")
	baseDiv.setBackgroundColorVariant("bg-base-300")
	baseDiv.setTextColorVariant("text-neutral-content")

	Dim variants As List
	variants.Initialize
	For Each v As String In Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
		variants.Add(v)
	Next

	Dim placements As List
	placements.Initialize
	placements.Add(CreateMap("hx":"start", "vy":"top", "label":"TL"))
	placements.Add(CreateMap("hx":"center", "vy":"top", "label":"T"))
	placements.Add(CreateMap("hx":"end", "vy":"top", "label":"TR"))
	placements.Add(CreateMap("hx":"start", "vy":"middle", "label":"L"))
	placements.Add(CreateMap("hx":"center", "vy":"middle", "label":"C"))
	placements.Add(CreateMap("hx":"end", "vy":"middle", "label":"R"))
	placements.Add(CreateMap("hx":"start", "vy":"bottom", "label":"BL"))
	placements.Add(CreateMap("hx":"center", "vy":"bottom", "label":"B"))
	placements.Add(CreateMap("hx":"end", "vy":"bottom", "label":"BR"))

	For Each p As Map In placements
		Dim variant As String = variants.Get(Rnd(0, variants.Size))

		Dim ind As B4XDaisyIndicator
		ind.Initialize(Me, "indicator")
		ind.setTag("dot-" & p.GetDefault("label", "") & "-" & variant)
		ind.setSize("sm")
		ind.setVariant(variant)
		ind.setText("")
		ind.setHorizontalPlacement(p.GetDefault("hx", "end"))
		ind.setVerticalPlacement(p.GetDefault("vy", "top"))
		ind.AddToParent(row, boxLeft, boxTop, boxSize, boxSize)
		ind.AttachToTarget(baseView)
	Next

	Dim rowH As Int = boxTop + boxSize + 44dip
	row.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub RenderVariantSection(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Top-right indicators by variant", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Each indicator uses setVariant(variant) and shows variant name", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	DisableClipping(row)
	pnlHost.AddView(row, PAGE_PAD, y, MaxW, 1dip)

	Dim variants As List
	variants.Initialize
	For Each v As String In Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
		variants.Add(v)
	Next

	Dim boxSize As Int = B4XDaisyVariants.TailwindSizeToDip("32", 128dip)
	Dim gapY As Int = 18dip
	Dim left As Int = Max(0, (MaxW - boxSize) / 2)
	Dim topPad As Int = 24dip

	For i = 0 To variants.Size - 1
		Dim variant As String = variants.Get(i)
		Dim top As Int = topPad + (i * (boxSize + gapY))

		Dim baseDiv As B4XDaisyDiv
		baseDiv.Initialize(Me, "")
		Dim baseView As B4XView = baseDiv.AddToParent(row, left, top, boxSize, boxSize)
		baseDiv.setWidth("32")
		baseDiv.setHeight("32")
		baseDiv.setPlaceContentCenter(True)
		baseDiv.setRoundedBox(True)
		baseDiv.setText("content")
	baseDiv.setTextSize("text-sm")
		baseDiv.setBackgroundColorVariant("bg-base-300")
		baseDiv.setTextColorVariant("text-neutral-content")

		Dim ind As B4XDaisyIndicator
		ind.Initialize(Me, "indicator")
		ind.setTag("variant-" & variant)
		ind.setText(variant)
		ind.setVariant(variant)
		ind.setSize("sm")
		ind.setHorizontalPlacement("end")
		ind.setVerticalPlacement("top")
		ind.AddToParent(row, left, top, boxSize, boxSize)
		ind.AttachToTarget(baseView)
	Next

	Dim rows As Int = Max(1, variants.Size)
	Dim rowH As Int = topPad + (rows * boxSize) + ((rows - 1) * gapY) + 18dip
	row.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub RenderAvatarSection(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Avatar with indicator", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	DisableClipping(row)
	pnlHost.AddView(row, PAGE_PAD, y, MaxW, 1dip)

	Dim avatarSize As Int = 80dip
	Dim avatarLeft As Int = Max(0, (MaxW - avatarSize) / 2)
	Dim avatarTop As Int = 20dip

	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "avatar")
	Dim avatarView As B4XView = av.AddToParent(row, avatarLeft, avatarTop, avatarSize, avatarSize)
	av.setAvatarType("image")
	av.setAvatar("batperson@192.webp")
	av.setAvatarMask("rounded-lg")
	av.setVariant("neutral")

	Dim online As B4XDaisyIndicator
	online.Initialize(Me, "indicator")
	online.setTag("avatar-justice")
	online.setText("Justice")
	online.setVariant("secondary")
	online.setSize("md")
	online.setHorizontalPlacement("end")
	online.setVerticalPlacement("top")
	online.AddToParent(row, avatarLeft, avatarTop, avatarSize, avatarSize)
	online.AttachToTarget(avatarView)

	Dim rowH As Int = avatarTop + avatarSize + 26dip
	row.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub RenderCountIndicatorSection(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Count indicator", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	DisableClipping(row)
	pnlHost.AddView(row, PAGE_PAD, y, MaxW, 1dip)

	Dim boxSize As Int = B4XDaisyVariants.TailwindSizeToDip("32", 128dip)
	Dim boxLeft As Int = Max(0, (MaxW - boxSize) / 2)
	Dim boxTop As Int = 22dip

	Dim baseDiv As B4XDaisyDiv
	baseDiv.Initialize(Me, "")
	Dim baseView As B4XView = baseDiv.AddToParent(row, boxLeft, boxTop, boxSize, boxSize)
	baseDiv.setWidth("32")
	baseDiv.setHeight("32")
	baseDiv.setPlaceContentCenter(True)
	baseDiv.setRoundedBox(True)
	baseDiv.setText("content")
	baseDiv.setTextSize("text-sm")
	baseDiv.setBackgroundColorVariant("bg-base-300")
	baseDiv.setTextColorVariant("text-neutral-content")

	Dim countInd As B4XDaisyIndicator
	countInd.Initialize(Me, "indicator")
	countInd.setTag("count-3")
	countInd.setCounter(True)
	countInd.setText("0")
	countInd.setVariant("primary")
	countInd.setRounded("rounded-full")
	countInd.setSize("sm")
	countInd.setHorizontalPlacement("end")
	countInd.setVerticalPlacement("top")
	countInd.AddToParent(row, boxLeft, boxTop, boxSize, boxSize)
	countInd.AttachToTarget(baseView)
	StartCounterDemoLoop(countInd)

	Dim rowH As Int = boxTop + boxSize + 30dip
	row.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub RenderSvgCounterSection(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("SVG icon with counter indicator", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	Dim noteLbl As B4XView = CreateSectionLabel("Bell icon (42px) with top-right success counter = 5", 11, xui.Color_RGB(100, 116, 139), False)
	pnlHost.AddView(noteLbl, PAGE_PAD, y, MaxW, 16dip)
	y = y + 18dip

	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	DisableClipping(row)
	pnlHost.AddView(row, PAGE_PAD, y, MaxW, 1dip)

	Dim iconSize As Int = Max(1dip, Round(B4XDaisyVariants.TailwindSizeToDip("42px", 42dip)))
	Dim iconLeft As Int = Max(0, (MaxW - iconSize) / 2)
	Dim iconTop As Int = 18dip

	Dim bell As B4XDaisySvgIcon
	bell.Initialize(Me, "")
	Dim bellView As B4XView = bell.AddToParent(row, iconLeft, iconTop, iconSize, iconSize)
	bell.setSvgAsset("bell-solid.svg")
	bell.setSize("42px")
	bell.setColorVariant("neutral")

	Dim ind As B4XDaisyIndicator
	ind.Initialize(Me, "indicator")
	ind.setTag("svg-counter-bell")
	ind.setCounter(True)
	ind.setText("5")
	ind.setVariant("success")
	ind.setRounded("rounded-full")
	ind.setHorizontalPlacement("end")
	ind.setVerticalPlacement("top")
	ind.AddToParent(row, iconLeft, iconTop, iconSize, iconSize)
	ind.AttachToTarget(bellView)

	Dim rowH As Int = iconTop + iconSize + 24dip
	row.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub StartCounterDemoLoop(Indicator As B4XDaisyIndicator)
	mCounterDemoToken = mCounterDemoToken + 1
	Dim token As Int = mCounterDemoToken
	RunCounterDemoLoop(Indicator, token)
End Sub

Private Sub RunCounterDemoLoop(Indicator As B4XDaisyIndicator, Token As Int)
	Do While Token = mCounterDemoToken
		For value = 0 To 100 Step 1
			If Token <> mCounterDemoToken Then Return
			If Indicator.IsReady = False Then Return
			Indicator.setText(value)
			Sleep(1 * DateTime.TicksPerSecond)
		Next
	Loop
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
