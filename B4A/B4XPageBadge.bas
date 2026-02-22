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
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Badge")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	BuildExampleDefinitions
	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub BuildExampleDefinitions
	ExampleDefs.Initialize

	Dim baseItems As List
	baseItems.Initialize
	baseItems.Add(BadgeItem("Badge", "md", "none", "solid", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge", "items": baseItems))

	Dim sizeItems As List
	sizeItems.Initialize
	sizeItems.Add(BadgeItem("Xsmall", "xs", "none", "solid", "", False))
	sizeItems.Add(BadgeItem("Small", "sm", "none", "solid", "", False))
	sizeItems.Add(BadgeItem("Medium", "md", "none", "solid", "", False))
	sizeItems.Add(BadgeItem("Large", "lg", "none", "solid", "", False))
	sizeItems.Add(BadgeItem("Xlarge", "xl", "none", "solid", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge sizes", "items": sizeItems))

	Dim roundedItems As List
	roundedItems.Initialize
	Dim rNone As Map = BadgeItem("rounded-none", "md", "primary", "solid", "", False)
	rNone.Put("height", "8")
	rNone.Put("rounded", "rounded-none")
	roundedItems.Add(rNone)
	Dim rSm As Map = BadgeItem("rounded-sm", "md", "primary", "solid", "", False)
	rSm.Put("height", "8")
	rSm.Put("rounded", "rounded-sm")
	roundedItems.Add(rSm)
	Dim rBase As Map = BadgeItem("rounded", "md", "primary", "solid", "", False)
	rBase.Put("height", "8")
	rBase.Put("rounded", "rounded")
	roundedItems.Add(rBase)
	Dim rMd As Map = BadgeItem("rounded-md", "md", "primary", "solid", "", False)
	rMd.Put("height", "8")
	rMd.Put("rounded", "rounded-md")
	roundedItems.Add(rMd)
	Dim rLg As Map = BadgeItem("rounded-lg", "md", "primary", "solid", "", False)
	rLg.Put("height", "8")
	rLg.Put("rounded", "rounded-lg")
	roundedItems.Add(rLg)
	Dim rXl As Map = BadgeItem("rounded-xl", "md", "primary", "solid", "", False)
	rXl.Put("height", "8")
	rXl.Put("rounded", "rounded-xl")
	roundedItems.Add(rXl)
	Dim r2Xl As Map = BadgeItem("rounded-2xl", "md", "primary", "solid", "", False)
	r2Xl.Put("height", "8")
	r2Xl.Put("rounded", "rounded-2xl")
	roundedItems.Add(r2Xl)
	Dim r3Xl As Map = BadgeItem("rounded-3xl", "md", "primary", "solid", "", False)
	r3Xl.Put("height", "8")
	r3Xl.Put("rounded", "rounded-3xl")
	roundedItems.Add(r3Xl)
	Dim rFull As Map = BadgeItem("rounded-full", "md", "primary", "solid", "", False)
	rFull.Put("height", "8")
	rFull.Put("rounded", "rounded-full")
	roundedItems.Add(rFull)
	ExampleDefs.Add(CreateMap("title":"Primary badges with rounded options (h-8)", "items": roundedItems))

	Dim colorItems As List
	colorItems.Initialize
	colorItems.Add(BadgeItem("Primary", "md", "primary", "solid", "", False))
	colorItems.Add(BadgeItem("Secondary", "md", "secondary", "solid", "", False))
	colorItems.Add(BadgeItem("Accent", "md", "accent", "solid", "", False))
	colorItems.Add(BadgeItem("Neutral", "md", "neutral", "solid", "", False))
	colorItems.Add(BadgeItem("Info", "md", "info", "solid", "", False))
	colorItems.Add(BadgeItem("Success", "md", "success", "solid", "", False))
	colorItems.Add(BadgeItem("Warning", "md", "warning", "solid", "", False))
	colorItems.Add(BadgeItem("Error", "md", "error", "solid", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge with colors", "items": colorItems))

	Dim toggleItems As List
	toggleItems.Initialize
	Dim togglePalette As Map = B4XDaisyVariants.GetVariantPalette
	Dim toggleVariants() As String = Array As String("primary", "secondary", "accent", "neutral", "info", "success", "warning", "error")
	For Each v As String In toggleVariants
		Dim lbl As String = v.SubString2(0, 1).ToUpperCase & v.SubString(1)
		Dim chip As Map = BadgeItem(lbl, "md", "neutral", "solid", "", False)
		chip.Put("id", "chip-" & v)
		chip.Put("toggle", True)
		chip.Put("checked", False)
		chip.Put("height", "8")
		chip.Put("rounded", "rounded-full")
		chip.Put("checked_color", B4XDaisyVariants.ResolveVariantColor(togglePalette, v, "back", xui.Color_RGB(59, 130, 246)))
		chip.Put("checked_text_color", B4XDaisyVariants.ResolveVariantColor(togglePalette, v, "text", xui.Color_White))
		toggleItems.Add(chip)
	Next
	ExampleDefs.Add(CreateMap("title":"Toggle chips", "note":"Tap chips to toggle. Checked event returns chip ID and checked state.", "items": toggleItems))

	Dim softItems As List
	softItems.Initialize
	softItems.Add(BadgeItem("Primary", "md", "primary", "soft", "", False))
	softItems.Add(BadgeItem("Secondary", "md", "secondary", "soft", "", False))
	softItems.Add(BadgeItem("Accent", "md", "accent", "soft", "", False))
	softItems.Add(BadgeItem("Info", "md", "info", "soft", "", False))
	softItems.Add(BadgeItem("Success", "md", "success", "soft", "", False))
	softItems.Add(BadgeItem("Warning", "md", "warning", "soft", "", False))
	softItems.Add(BadgeItem("Error", "md", "error", "soft", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge with soft style", "items": softItems))

	Dim outlineItems As List
	outlineItems.Initialize
	outlineItems.Add(BadgeItem("Primary", "md", "primary", "outline", "", False))
	outlineItems.Add(BadgeItem("Secondary", "md", "secondary", "outline", "", False))
	outlineItems.Add(BadgeItem("Accent", "md", "accent", "outline", "", False))
	outlineItems.Add(BadgeItem("Info", "md", "info", "outline", "", False))
	outlineItems.Add(BadgeItem("Success", "md", "success", "outline", "", False))
	outlineItems.Add(BadgeItem("Warning", "md", "warning", "outline", "", False))
	outlineItems.Add(BadgeItem("Error", "md", "error", "outline", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge with outline style", "items": outlineItems))

	Dim dashItems As List
	dashItems.Initialize
	dashItems.Add(BadgeItem("Primary", "md", "primary", "dash", "", False))
	dashItems.Add(BadgeItem("Secondary", "md", "secondary", "dash", "", False))
	dashItems.Add(BadgeItem("Accent", "md", "accent", "dash", "", False))
	dashItems.Add(BadgeItem("Info", "md", "info", "dash", "", False))
	dashItems.Add(BadgeItem("Success", "md", "success", "dash", "", False))
	dashItems.Add(BadgeItem("Warning", "md", "warning", "dash", "", False))
	dashItems.Add(BadgeItem("Error", "md", "error", "dash", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge with dash style", "items": dashItems))

	Dim neutralOutlineDash As List
	neutralOutlineDash.Initialize
	neutralOutlineDash.Add(BadgeItem("Outline", "md", "neutral", "outline", "", False))
	neutralOutlineDash.Add(BadgeItem("Dash", "md", "neutral", "dash", "", False))
	ExampleDefs.Add(CreateMap("title":"Neutral badge with outline/dash", "note":"Use on light backgrounds for best contrast.", "items": neutralOutlineDash))

	Dim ghostItems As List
	ghostItems.Initialize
	ghostItems.Add(BadgeItem("ghost", "md", "none", "ghost", "", False))
	ExampleDefs.Add(CreateMap("title":"Badge ghost", "items": ghostItems))

	Dim emptyItems As List
	emptyItems.Initialize
	emptyItems.Add(BadgeItem("", "lg", "primary", "solid", "", False))
	emptyItems.Add(BadgeItem("", "md", "primary", "solid", "", False))
	emptyItems.Add(BadgeItem("", "sm", "primary", "solid", "", False))
	emptyItems.Add(BadgeItem("", "xs", "primary", "solid", "", False))
	ExampleDefs.Add(CreateMap("title":"Empty badge", "items": emptyItems))

	Dim iconItems As List
	iconItems.Initialize
	Dim infoIcon As Map = BadgeItem("Info", "md", "info", "solid", "", False)
	infoIcon.Put("icon_asset", "circle-question-regular.svg")
	iconItems.Add(infoIcon)
	Dim successIcon As Map = BadgeItem("Success", "md", "success", "solid", "", False)
	successIcon.Put("icon_asset", "check-solid.svg")
	iconItems.Add(successIcon)
	Dim warningIcon As Map = BadgeItem("Warning", "md", "warning", "solid", "", False)
	warningIcon.Put("icon_asset", "circle-question-regular.svg")
	iconItems.Add(warningIcon)
	Dim errorIcon As Map = BadgeItem("Error", "md", "error", "solid", "", False)
	errorIcon.Put("icon_asset", "xmark-solid.svg")
	iconItems.Add(errorIcon)
	ExampleDefs.Add(CreateMap("title":"Badge with icon", "note":"Uses the same SVG assets as alert variants.", "items": iconItems))

	Dim closableItems As List
	closableItems.Initialize
	closableItems.Add(BadgeItem("Plain closable", "xl", "neutral", "solid", "", True))
	Dim closableIcon As Map = BadgeItem("Icon closable", "xl", "success", "solid", "", True)
	closableIcon.Put("icon_asset", "check-solid.svg")
	closableItems.Add(closableIcon)
	Dim closableAvatarLeft As Map = BadgeItem("Avatar left", "xl", "primary", "solid", "", True)
	closableAvatarLeft.Put("avatar_image", "face21.jpg")
	closableAvatarLeft.Put("avatar_position", "left")
	closableItems.Add(closableAvatarLeft)
	ExampleDefs.Add(CreateMap("title":"Closable badges", "items": closableItems))

	Dim avatarRightItems As List
	avatarRightItems.Initialize
	Dim avatarRight As Map = BadgeItem("Avatar right", "md", "secondary", "solid", "", False)
	avatarRight.Put("avatar_image", "face22.jpg")
	avatarRight.Put("avatar_position", "right")
	avatarRightItems.Add(avatarRight)
	ExampleDefs.Add(CreateMap("title":"Badge with avatar on right", "items": avatarRightItems))
End Sub

Private Sub BadgeItem(Text As String, Size As String, Variant As String, Style As String, AvatarText As String, Closable As Boolean) As Map
	Dim m As Map
	m.Initialize
	m.Put("text", Text)
	m.Put("size", Size)
	m.Put("variant", Variant)
	m.Put("style", Style)
	m.Put("avatar_text", AvatarText)
	m.Put("closable", Closable)
	Return m
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	If ExampleDefs.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(180dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	For Each section As Map In ExampleDefs
		y = RenderBadgeSection(section, maxW, y)
	Next

	'y = RenderHeadingExamples(maxW, y)
	'y = RenderButtonExamples(maxW, y)

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub RenderBadgeSection(Section As Map, MaxW As Int, StartY As Int) As Int
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
	Dim rowH As Int = LayoutBadgeItems(rowPanel, MaxW, items, title)
	rowPanel.SetLayoutAnimated(0, PAGE_PAD, y, MaxW, rowH)
	y = y + rowH + 14dip
	Return y
End Sub

Private Sub LayoutBadgeItems(RowPanel As B4XView, MaxW As Int, Items As List, SectionName As String) As Int
	Dim x As Int = 0
	Dim y As Int = 0
	Dim rowH As Int = 0
	For i = 0 To Items.Size - 1
		Dim item As Map = Items.Get(i)
		Dim badge As B4XDaisyBadge
		badge.Initialize(Me, "badge")
		ApplyBadgeItem(badge, item, SectionName & "-" & i)
		Dim badgeView As B4XView = badge.AddToParent(RowPanel, 0, 0, 0, 0)
		Dim bw As Int = Max(1dip, badgeView.Width)
		Dim bh As Int = Max(1dip, badgeView.Height)

		If x > 0 And x + bw > MaxW Then
			x = 0
			y = y + rowH + ROW_GAP
			rowH = 0
		End If

		badgeView.SetLayoutAnimated(0, x, y, bw, bh)
		badge.Base_Resize(bw, bh)
		x = x + bw + ROW_GAP
		rowH = Max(rowH, bh)
	Next
	Return Max(1dip, y + rowH)
End Sub

Private Sub ApplyBadgeItem(Badge As B4XDaisyBadge, Item As Map, TagId As String)
	Dim txt As String = Item.GetDefault("text", "Badge")
	If txt = Null Then txt = ""
	Dim sizeToken As String = Item.GetDefault("size", "md")
	If sizeToken = Null Or sizeToken.Trim.Length = 0 Then sizeToken = "md"
	Dim variantToken As String = Item.GetDefault("variant", "none")
	If variantToken = Null Or variantToken.Trim.Length = 0 Then variantToken = "none"
	Dim styleToken As String = Item.GetDefault("style", "solid")
	If styleToken = Null Or styleToken.Trim.Length = 0 Then styleToken = "solid"

	Badge.setTag(TagId)
	Badge.setText(txt)
	Badge.setSize(sizeToken)
	Badge.setVariant(variantToken)
	Badge.setStyle(styleToken)
	Badge.setShadow("none")
	Dim toggleEnabled As Boolean = Item.GetDefault("toggle", False)
	Badge.setToggle(toggleEnabled)
	If Item.ContainsKey("checked") Then Badge.setChecked(Item.GetDefault("checked", False))
	If Item.ContainsKey("checked_color") Then Badge.setCheckedColor(Item.Get("checked_color"))
	If Item.ContainsKey("checked_text_color") Then Badge.setCheckedTextColor(Item.Get("checked_text_color"))
	Dim chipId As String = Item.GetDefault("id", "")
	If chipId <> Null And chipId.Trim.Length > 0 Then Badge.setId(chipId.Trim)
	If Item.ContainsKey("height") Then Badge.setHeight(Item.Get("height"))
	Dim roundedToken As String = Item.GetDefault("rounded", "")
	If roundedToken <> Null And roundedToken.Trim.Length > 0 Then Badge.setRounded(roundedToken)

	Dim avatarPosition As String = Item.GetDefault("avatar_position", "left")
	If avatarPosition <> Null And avatarPosition.Trim.Length > 0 Then Badge.setAvatarPosition(avatarPosition)

	Dim avatarText As String = Item.GetDefault("avatar_text", "")
	Dim avatarImage As String = Item.GetDefault("avatar_image", "")
	Dim hasAvatar As Boolean = False
	If avatarImage <> Null And avatarImage.Trim.Length > 0 Then
		Badge.setAvatarImage(avatarImage.Trim)
		hasAvatar = True
	End If
	If avatarText <> Null And avatarText.Length > 0 Then
		Badge.setAvatarText(avatarText)
		hasAvatar = True
	End If
	If Item.GetDefault("avatar_visible", False) Then hasAvatar = True
	Badge.setAvatarVisible(hasAvatar)

	Dim iconAsset As String = Item.GetDefault("icon_asset", "")
	If iconAsset <> Null And iconAsset.Trim.Length > 0 Then Badge.setIconAsset(iconAsset.Trim)

	Dim isClosable As Boolean = Item.GetDefault("closable", False)
	Badge.setClosable(isClosable)
End Sub

Private Sub RenderHeadingExamples(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Badge in text", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	y = AddHeadingBadgeRow(MaxW, y, "Heading 1", 22, "xl")
	y = AddHeadingBadgeRow(MaxW, y, "Heading 2", 20, "lg")
	y = AddHeadingBadgeRow(MaxW, y, "Heading 3", 17, "md")
	y = AddHeadingBadgeRow(MaxW, y, "Heading 4", 14, "sm")
	y = AddHeadingBadgeRow(MaxW, y, "Heading 5", 12, "xs")
	y = AddHeadingBadgeRow(MaxW, y, "Paragraph", 12, "xs")
	Return y + 10dip
End Sub

Private Sub AddHeadingBadgeRow(MaxW As Int, StartY As Int, HeadingText As String, HeadingSize As Int, BadgeSize As String) As Int
	Dim row As B4XView = xui.CreatePanel("")
	row.Color = xui.Color_Transparent
	pnlHost.AddView(row, PAGE_PAD, StartY, MaxW, 1dip)

	Dim lbl As Label
	lbl.Initialize("")
	Dim xlbl As B4XView = lbl
	xlbl.Text = HeadingText
	xlbl.TextColor = xui.Color_RGB(15, 23, 42)
	xlbl.TextSize = HeadingSize
	row.AddView(xlbl, 0, 0, MaxW, 10dip)

	Dim badge As B4XDaisyBadge
	badge.Initialize(Me, "badge")
	badge.setTag("heading-" & HeadingText)
	badge.setText("Badge")
	badge.setSize(BadgeSize)
	badge.setStyle("solid")
	badge.setShadow("none")
	Dim badgeView As B4XView = badge.AddToParent(row, 0, 0, 0, 0)
	Dim bw As Int = Max(1dip, badgeView.Width)
	Dim bh As Int = Max(1dip, badgeView.Height)

	Dim estimatedLabelW As Int = Max(60dip, Round(HeadingText.Length * HeadingSize * 0.55))
	Dim rowH As Int = Max(bh + 6dip, HeadingSize + 12dip)
	xlbl.SetLayoutAnimated(0, 0, (rowH - (HeadingSize + 8dip)) / 2, MaxW, HeadingSize + 8dip)
	Dim badgeX As Int = Min(MaxW - bw, estimatedLabelW + 8dip)
	badgeView.SetLayoutAnimated(0, badgeX, (rowH - bh) / 2, bw, bh)
	badge.Base_Resize(bw, bh)
	row.SetLayoutAnimated(0, PAGE_PAD, StartY, MaxW, rowH)
	Return StartY + rowH + 8dip
End Sub

Private Sub RenderButtonExamples(MaxW As Int, StartY As Int) As Int
	Dim y As Int = StartY
	Dim titleLbl As B4XView = CreateSectionLabel("Badge in a button", 14, xui.Color_RGB(30, 41, 59), True)
	pnlHost.AddView(titleLbl, PAGE_PAD, y, MaxW, 20dip)
	y = y + 22dip

	y = AddButtonBadgeRow(MaxW, y, "none")
	y = AddButtonBadgeRow(MaxW, y, "secondary")
	Return y + 8dip
End Sub

Private Sub AddButtonBadgeRow(MaxW As Int, StartY As Int, BadgeVariant As String) As Int
	Dim btnPanel As B4XView = xui.CreatePanel("")
	btnPanel.SetColorAndBorder(xui.Color_RGB(37, 99, 235), 0, xui.Color_Transparent, 10dip)
	pnlHost.AddView(btnPanel, PAGE_PAD, StartY, MaxW, 40dip)

	Dim lbl As Label
	lbl.Initialize("")
	Dim xlbl As B4XView = lbl
	xlbl.Text = "Inbox"
	xlbl.TextColor = xui.Color_White
	xlbl.TextSize = 13
	xlbl.SetTextAlignment("CENTER", "LEFT")
	btnPanel.AddView(xlbl, 12dip, 0, 70dip, 40dip)

	Dim badge As B4XDaisyBadge
	badge.Initialize(Me, "badge")
	badge.setTag("button-" & BadgeVariant)
	badge.setText("+99")
	badge.setSize("sm")
	badge.setStyle("solid")
	badge.setShadow("none")
	If BadgeVariant <> "none" Then badge.setVariant(BadgeVariant)
	Dim badgeView As B4XView = badge.AddToParent(btnPanel, 0, 0, 0, 0)
	Dim bw As Int = Max(1dip, badgeView.Width)
	Dim bh As Int = Max(1dip, badgeView.Height)
	badgeView.SetLayoutAnimated(0, MaxW - bw - 12dip, (40dip - bh) / 2, bw, bh)
	badge.Base_Resize(bw, bh)

	Return StartY + 40dip + 8dip
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

Private Sub badge_Click(Tag As Object)
End Sub

Private Sub badge_CloseClick(Tag As Object)
	ToastMessageShow("Badge closed: " & Tag, False)
End Sub

Private Sub badge_Checked(Id As String, Checked As Boolean)
	Dim chipId As String = Id
	If chipId = Null Or chipId.Trim.Length = 0 Then chipId = "(no-id)"
	Dim stateText As String = IIf(Checked, "true", "false")
	ToastMessageShow("Toggle badge id=" & chipId & ", checked=" & stateText, False)
End Sub
