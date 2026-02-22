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
	'Each item is a Map with: panel, avatar, avatar_view, title.
	Private MaskCards As List
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Mask")

	'Scrollable host panel for manual, responsive card layout.
	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	MaskCards.Initialize
	'Build demo cards once, then place them based on current page size.
	CreateSamples
	LayoutCards(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	LayoutCards(Width, Height)
End Sub

Private Sub CreateSamples
	'Clear and recreate all sample cards from scratch.
	MaskCards.Clear
	pnlHost.RemoveAllViews

	'Examples from DaisyUI mask docs.
	Dim card1 As B4XView = xui.CreatePanel("")
	card1.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card1, 0, 0, 10dip, 10dip)

	Dim avatar1 As B4XDaisyAvatar
	avatar1.Initialize(Me, "maskavatar")
	Dim avatarView1 As B4XView = avatar1.AddToParent(card1, 0, 0, 180dip, 180dip)


	avatar1.SetImage("mask1.webp")
	avatar1.SetWidth("40")
	avatar1.SetHeight("40")
	avatar1.SetCenterOnParent(True)
	avatar1.SetVariant("none")
	avatar1.SetStatus("none")
	avatar1.SetShowOnline(False)
	avatar1.SetAvatarMask("squircle")
	avatar1.SetShadow("none")
	avatar1.SetRingWidth(0)
	avatar1.SetRingOffset(0)

'	Dim avatarView1 As B4XView = avatar1.AddToParent(card1, 0, 0, 180dip, 180dip)
	avatarView1.Tag = "mask mask-squircle w-40 h-40"

	Dim lblTitle1 As Label
	lblTitle1.Initialize("")
	Dim xlblTitle1 As B4XView = lblTitle1
	xlblTitle1.Text = "mask mask-squircle w-40 h-40"
	xlblTitle1.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle1.TextSize = 12
	xlblTitle1.SetTextAlignment("CENTER", "CENTER")
	card1.AddView(xlblTitle1, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card1, "avatar": avatar1, "avatar_view": avatarView1, "title": xlblTitle1))

	Dim card2 As B4XView = xui.CreatePanel("")
	card2.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card2, 0, 0, 10dip, 10dip)

	Dim avatar2 As B4XDaisyAvatar
	avatar2.Initialize(Me, "maskavatar")
	Dim avatarView2 As B4XView = avatar2.AddToParent(card2, 0, 0, 180dip, 180dip)


	avatar2.SetImage("mask1.webp")
	avatar2.SetWidth("40")
	avatar2.SetHeight("40")
	avatar2.SetCenterOnParent(True)
	avatar2.SetVariant("none")
	avatar2.SetStatus("none")
	avatar2.SetShowOnline(False)
	avatar2.SetAvatarMask("heart")
	avatar2.SetShadow("none")
	avatar2.SetRingWidth(0)
	avatar2.SetRingOffset(0)

'	Dim avatarView2 As B4XView = avatar2.AddToParent(card2, 0, 0, 180dip, 180dip)
	avatarView2.Tag = "mask mask-heart w-40 h-40"

	Dim lblTitle2 As Label
	lblTitle2.Initialize("")
	Dim xlblTitle2 As B4XView = lblTitle2
	xlblTitle2.Text = "mask mask-heart w-40 h-40"
	xlblTitle2.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle2.TextSize = 12
	xlblTitle2.SetTextAlignment("CENTER", "CENTER")
	card2.AddView(xlblTitle2, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card2, "avatar": avatar2, "avatar_view": avatarView2, "title": xlblTitle2))

	Dim card3 As B4XView = xui.CreatePanel("")
	card3.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card3, 0, 0, 10dip, 10dip)

	Dim avatar3 As B4XDaisyAvatar
	avatar3.Initialize(Me, "maskavatar")
	Dim avatarView3 As B4XView = avatar3.AddToParent(card3, 0, 0, 180dip, 180dip)


	avatar3.SetImage("mask1.webp")
	avatar3.SetWidth("40")
	avatar3.SetHeight("40")
	avatar3.SetCenterOnParent(True)
	avatar3.SetVariant("none")
	avatar3.SetStatus("none")
	avatar3.SetShowOnline(False)
	avatar3.SetAvatarMask("hexagon")
	avatar3.SetShadow("none")
	avatar3.SetRingWidth(0)
	avatar3.SetRingOffset(0)

'	Dim avatarView3 As B4XView = avatar3.AddToParent(card3, 0, 0, 180dip, 180dip)
	avatarView3.Tag = "mask mask-hexagon w-40 h-40"

	Dim lblTitle3 As Label
	lblTitle3.Initialize("")
	Dim xlblTitle3 As B4XView = lblTitle3
	xlblTitle3.Text = "mask mask-hexagon w-40 h-40"
	xlblTitle3.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle3.TextSize = 12
	xlblTitle3.SetTextAlignment("CENTER", "CENTER")
	card3.AddView(xlblTitle3, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card3, "avatar": avatar3, "avatar_view": avatarView3, "title": xlblTitle3))

	Dim card4 As B4XView = xui.CreatePanel("")
	card4.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card4, 0, 0, 10dip, 10dip)

	Dim avatar4 As B4XDaisyAvatar
	avatar4.Initialize(Me, "maskavatar")
	Dim avatarView4 As B4XView = avatar4.AddToParent(card4, 0, 0, 180dip, 180dip)


	avatar4.SetImage("mask1.webp")
	avatar4.SetWidth("40")
	avatar4.SetHeight("40")
	avatar4.SetCenterOnParent(True)
	avatar4.SetVariant("none")
	avatar4.SetStatus("none")
	avatar4.SetShowOnline(False)
	avatar4.SetAvatarMask("hexagon-2")
	avatar4.SetShadow("none")
	avatar4.SetRingWidth(0)
	avatar4.SetRingOffset(0)

'	Dim avatarView4 As B4XView = avatar4.AddToParent(card4, 0, 0, 180dip, 180dip)
	avatarView4.Tag = "mask mask-hexagon-2 w-40 h-40"

	Dim lblTitle4 As Label
	lblTitle4.Initialize("")
	Dim xlblTitle4 As B4XView = lblTitle4
	xlblTitle4.Text = "mask mask-hexagon-2 w-40 h-40"
	xlblTitle4.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle4.TextSize = 12
	xlblTitle4.SetTextAlignment("CENTER", "CENTER")
	card4.AddView(xlblTitle4, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card4, "avatar": avatar4, "avatar_view": avatarView4, "title": xlblTitle4))

	Dim card5 As B4XView = xui.CreatePanel("")
	card5.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card5, 0, 0, 10dip, 10dip)

	Dim avatar5 As B4XDaisyAvatar
	avatar5.Initialize(Me, "maskavatar")
	Dim avatarView5 As B4XView = avatar5.AddToParent(card5, 0, 0, 180dip, 180dip)


	avatar5.SetImage("mask1.webp")
	avatar5.SetWidth("40")
	avatar5.SetHeight("40")
	avatar5.SetCenterOnParent(True)
	avatar5.SetVariant("none")
	avatar5.SetStatus("none")
	avatar5.SetShowOnline(False)
	avatar5.SetAvatarMask("decagon")
	avatar5.SetShadow("none")
	avatar5.SetRingWidth(0)
	avatar5.SetRingOffset(0)

'	Dim avatarView5 As B4XView = avatar5.AddToParent(card5, 0, 0, 180dip, 180dip)
	avatarView5.Tag = "mask mask-decagon w-40 h-40"

	Dim lblTitle5 As Label
	lblTitle5.Initialize("")
	Dim xlblTitle5 As B4XView = lblTitle5
	xlblTitle5.Text = "mask mask-decagon w-40 h-40"
	xlblTitle5.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle5.TextSize = 12
	xlblTitle5.SetTextAlignment("CENTER", "CENTER")
	card5.AddView(xlblTitle5, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card5, "avatar": avatar5, "avatar_view": avatarView5, "title": xlblTitle5))

	Dim card6 As B4XView = xui.CreatePanel("")
	card6.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card6, 0, 0, 10dip, 10dip)

	Dim avatar6 As B4XDaisyAvatar
	avatar6.Initialize(Me, "maskavatar")
	Dim avatarView6 As B4XView = avatar6.AddToParent(card6, 0, 0, 180dip, 180dip)


	avatar6.SetImage("mask1.webp")
	avatar6.SetWidth("40")
	avatar6.SetHeight("40")
	avatar6.SetCenterOnParent(True)
	avatar6.SetVariant("none")
	avatar6.SetStatus("none")
	avatar6.SetShowOnline(False)
	avatar6.SetAvatarMask("pentagon")
	avatar6.SetShadow("none")
	avatar6.SetRingWidth(0)
	avatar6.SetRingOffset(0)

'	Dim avatarView6 As B4XView = avatar6.AddToParent(card6, 0, 0, 180dip, 180dip)
	avatarView6.Tag = "mask mask-pentagon w-40 h-40"

	Dim lblTitle6 As Label
	lblTitle6.Initialize("")
	Dim xlblTitle6 As B4XView = lblTitle6
	xlblTitle6.Text = "mask mask-pentagon w-40 h-40"
	xlblTitle6.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle6.TextSize = 12
	xlblTitle6.SetTextAlignment("CENTER", "CENTER")
	card6.AddView(xlblTitle6, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card6, "avatar": avatar6, "avatar_view": avatarView6, "title": xlblTitle6))

	Dim card7 As B4XView = xui.CreatePanel("")
	card7.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card7, 0, 0, 10dip, 10dip)

	Dim avatar7 As B4XDaisyAvatar
	avatar7.Initialize(Me, "maskavatar")
	Dim avatarView7 As B4XView = avatar7.AddToParent(card7, 0, 0, 180dip, 180dip)


	avatar7.SetImage("mask1.webp")
	avatar7.SetWidth("40")
	avatar7.SetHeight("40")
	avatar7.SetCenterOnParent(True)
	avatar7.SetVariant("none")
	avatar7.SetStatus("none")
	avatar7.SetShowOnline(False)
	avatar7.SetAvatarMask("diamond")
	avatar7.SetShadow("none")
	avatar7.SetRingWidth(0)
	avatar7.SetRingOffset(0)

'	Dim avatarView7 As B4XView = avatar7.AddToParent(card7, 0, 0, 180dip, 180dip)
	avatarView7.Tag = "mask mask-diamond w-40 h-40"

	Dim lblTitle7 As Label
	lblTitle7.Initialize("")
	Dim xlblTitle7 As B4XView = lblTitle7
	xlblTitle7.Text = "mask mask-diamond w-40 h-40"
	xlblTitle7.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle7.TextSize = 12
	xlblTitle7.SetTextAlignment("CENTER", "CENTER")
	card7.AddView(xlblTitle7, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card7, "avatar": avatar7, "avatar_view": avatarView7, "title": xlblTitle7))

	Dim card8 As B4XView = xui.CreatePanel("")
	card8.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card8, 0, 0, 10dip, 10dip)

	Dim avatar8 As B4XDaisyAvatar
	avatar8.Initialize(Me, "maskavatar")
	Dim avatarView8 As B4XView = avatar8.AddToParent(card8, 0, 0, 180dip, 180dip)


	avatar8.SetImage("mask1.webp")
	avatar8.SetWidth("40")
	avatar8.SetHeight("40")
	avatar8.SetCenterOnParent(True)
	avatar8.SetVariant("none")
	avatar8.SetStatus("none")
	avatar8.SetShowOnline(False)
	avatar8.SetAvatarMask("square")
	avatar8.SetShadow("none")
	avatar8.SetRingWidth(0)
	avatar8.SetRingOffset(0)

'	Dim avatarView8 As B4XView = avatar8.AddToParent(card8, 0, 0, 180dip, 180dip)
	avatarView8.Tag = "mask mask-square w-40 h-40"

	Dim lblTitle8 As Label
	lblTitle8.Initialize("")
	Dim xlblTitle8 As B4XView = lblTitle8
	xlblTitle8.Text = "mask mask-square w-40 h-40"
	xlblTitle8.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle8.TextSize = 12
	xlblTitle8.SetTextAlignment("CENTER", "CENTER")
	card8.AddView(xlblTitle8, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card8, "avatar": avatar8, "avatar_view": avatarView8, "title": xlblTitle8))

	Dim card9 As B4XView = xui.CreatePanel("")
	card9.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card9, 0, 0, 10dip, 10dip)

	Dim avatar9 As B4XDaisyAvatar
	avatar9.Initialize(Me, "maskavatar")
	Dim avatarView9 As B4XView = avatar9.AddToParent(card9, 0, 0, 180dip, 180dip)


	avatar9.SetImage("mask1.webp")
	avatar9.SetWidth("40")
	avatar9.SetHeight("40")
	avatar9.SetCenterOnParent(True)
	avatar9.SetVariant("none")
	avatar9.SetStatus("none")
	avatar9.SetShowOnline(False)
	avatar9.SetAvatarMask("circle")
	avatar9.SetShadow("none")
	avatar9.SetRingWidth(0)
	avatar9.SetRingOffset(0)

'	Dim avatarView9 As B4XView = avatar9.AddToParent(card9, 0, 0, 180dip, 180dip)
	avatarView9.Tag = "mask mask-circle w-40 h-40"

	Dim lblTitle9 As Label
	lblTitle9.Initialize("")
	Dim xlblTitle9 As B4XView = lblTitle9
	xlblTitle9.Text = "mask mask-circle w-40 h-40"
	xlblTitle9.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle9.TextSize = 12
	xlblTitle9.SetTextAlignment("CENTER", "CENTER")
	card9.AddView(xlblTitle9, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card9, "avatar": avatar9, "avatar_view": avatarView9, "title": xlblTitle9))

	Dim card10 As B4XView = xui.CreatePanel("")
	card10.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card10, 0, 0, 10dip, 10dip)

	Dim avatar10 As B4XDaisyAvatar
	avatar10.Initialize(Me, "maskavatar")
	Dim avatarView10 As B4XView = avatar10.AddToParent(card10, 0, 0, 180dip, 180dip)


	avatar10.SetImage("mask1.webp")
	avatar10.SetWidth("40")
	avatar10.SetHeight("40")
	avatar10.SetCenterOnParent(True)
	avatar10.SetVariant("none")
	avatar10.SetStatus("none")
	avatar10.SetShowOnline(False)
	avatar10.SetAvatarMask("star")
	avatar10.SetShadow("none")
	avatar10.SetRingWidth(0)
	avatar10.SetRingOffset(0)

'	Dim avatarView10 As B4XView = avatar10.AddToParent(card10, 0, 0, 180dip, 180dip)
	avatarView10.Tag = "mask mask-star w-40 h-40"

	Dim lblTitle10 As Label
	lblTitle10.Initialize("")
	Dim xlblTitle10 As B4XView = lblTitle10
	xlblTitle10.Text = "mask mask-star w-40 h-40"
	xlblTitle10.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle10.TextSize = 12
	xlblTitle10.SetTextAlignment("CENTER", "CENTER")
	card10.AddView(xlblTitle10, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card10, "avatar": avatar10, "avatar_view": avatarView10, "title": xlblTitle10))

	Dim card11 As B4XView = xui.CreatePanel("")
	card11.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card11, 0, 0, 10dip, 10dip)

	Dim avatar11 As B4XDaisyAvatar
	avatar11.Initialize(Me, "maskavatar")
	Dim avatarView11 As B4XView = avatar11.AddToParent(card11, 0, 0, 180dip, 180dip)


	avatar11.SetImage("mask1.webp")
	avatar11.SetWidth("40")
	avatar11.SetHeight("40")
	avatar11.SetCenterOnParent(True)
	avatar11.SetVariant("none")
	avatar11.SetStatus("none")
	avatar11.SetShowOnline(False)
	avatar11.SetAvatarMask("star-2")
	avatar11.SetShadow("none")
	avatar11.SetRingWidth(0)
	avatar11.SetRingOffset(0)

'	Dim avatarView11 As B4XView = avatar11.AddToParent(card11, 0, 0, 180dip, 180dip)
	avatarView11.Tag = "mask mask-star-2 w-40 h-40"

	Dim lblTitle11 As Label
	lblTitle11.Initialize("")
	Dim xlblTitle11 As B4XView = lblTitle11
	xlblTitle11.Text = "mask mask-star-2 w-40 h-40"
	xlblTitle11.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle11.TextSize = 12
	xlblTitle11.SetTextAlignment("CENTER", "CENTER")
	card11.AddView(xlblTitle11, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card11, "avatar": avatar11, "avatar_view": avatarView11, "title": xlblTitle11))

	Dim card12 As B4XView = xui.CreatePanel("")
	card12.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card12, 0, 0, 10dip, 10dip)

	Dim avatar12 As B4XDaisyAvatar
	avatar12.Initialize(Me, "maskavatar")
	Dim avatarView12 As B4XView = avatar12.AddToParent(card12, 0, 0, 180dip, 180dip)


	avatar12.SetImage("mask1.webp")
	avatar12.SetWidth("40")
	avatar12.SetHeight("40")
	avatar12.SetCenterOnParent(True)
	avatar12.SetVariant("none")
	avatar12.SetStatus("none")
	avatar12.SetShowOnline(False)
	avatar12.SetAvatarMask("triangle")
	avatar12.SetShadow("none")
	avatar12.SetRingWidth(0)
	avatar12.SetRingOffset(0)

'	Dim avatarView12 As B4XView = avatar12.AddToParent(card12, 0, 0, 180dip, 180dip)
	avatarView12.Tag = "mask mask-triangle w-40 h-40"

	Dim lblTitle12 As Label
	lblTitle12.Initialize("")
	Dim xlblTitle12 As B4XView = lblTitle12
	xlblTitle12.Text = "mask mask-triangle w-40 h-40"
	xlblTitle12.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle12.TextSize = 12
	xlblTitle12.SetTextAlignment("CENTER", "CENTER")
	card12.AddView(xlblTitle12, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card12, "avatar": avatar12, "avatar_view": avatarView12, "title": xlblTitle12))

	Dim card13 As B4XView = xui.CreatePanel("")
	card13.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card13, 0, 0, 10dip, 10dip)

	Dim avatar13 As B4XDaisyAvatar
	avatar13.Initialize(Me, "maskavatar")
	Dim avatarView13 As B4XView = avatar13.AddToParent(card13, 0, 0, 180dip, 180dip)


	avatar13.SetImage("mask1.webp")
	avatar13.SetWidth("40")
	avatar13.SetHeight("40")
	avatar13.SetCenterOnParent(True)
	avatar13.SetVariant("none")
	avatar13.SetStatus("none")
	avatar13.SetShowOnline(False)
	avatar13.SetAvatarMask("triangle-2")
	avatar13.SetShadow("none")
	avatar13.SetRingWidth(0)
	avatar13.SetRingOffset(0)

'	Dim avatarView13 As B4XView = avatar13.AddToParent(card13, 0, 0, 180dip, 180dip)
	avatarView13.Tag = "mask mask-triangle-2 w-40 h-40"

	Dim lblTitle13 As Label
	lblTitle13.Initialize("")
	Dim xlblTitle13 As B4XView = lblTitle13
	xlblTitle13.Text = "mask mask-triangle-2 w-40 h-40"
	xlblTitle13.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle13.TextSize = 12
	xlblTitle13.SetTextAlignment("CENTER", "CENTER")
	card13.AddView(xlblTitle13, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card13, "avatar": avatar13, "avatar_view": avatarView13, "title": xlblTitle13))

	Dim card14 As B4XView = xui.CreatePanel("")
	card14.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card14, 0, 0, 10dip, 10dip)

	Dim avatar14 As B4XDaisyAvatar
	avatar14.Initialize(Me, "maskavatar")
	Dim avatarView14 As B4XView = avatar14.AddToParent(card14, 0, 0, 180dip, 180dip)


	avatar14.SetImage("mask1.webp")
	avatar14.SetWidth("40")
	avatar14.SetHeight("40")
	avatar14.SetCenterOnParent(True)
	avatar14.SetVariant("none")
	avatar14.SetStatus("none")
	avatar14.SetShowOnline(False)
	avatar14.SetAvatarMask("triangle-3")
	avatar14.SetShadow("none")
	avatar14.SetRingWidth(0)
	avatar14.SetRingOffset(0)

'	Dim avatarView14 As B4XView = avatar14.AddToParent(card14, 0, 0, 180dip, 180dip)
	avatarView14.Tag = "mask mask-triangle-3 w-40 h-40"

	Dim lblTitle14 As Label
	lblTitle14.Initialize("")
	Dim xlblTitle14 As B4XView = lblTitle14
	xlblTitle14.Text = "mask mask-triangle-3 w-40 h-40"
	xlblTitle14.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle14.TextSize = 12
	xlblTitle14.SetTextAlignment("CENTER", "CENTER")
	card14.AddView(xlblTitle14, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card14, "avatar": avatar14, "avatar_view": avatarView14, "title": xlblTitle14))

	Dim card15 As B4XView = xui.CreatePanel("")
	card15.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card15, 0, 0, 10dip, 10dip)

	Dim avatar15 As B4XDaisyAvatar
	avatar15.Initialize(Me, "maskavatar")
	Dim avatarView15 As B4XView = avatar15.AddToParent(card15, 0, 0, 180dip, 180dip)


	avatar15.SetImage("mask1.webp")
	avatar15.SetWidth("40")
	avatar15.SetHeight("40")
	avatar15.SetCenterOnParent(True)
	avatar15.SetVariant("none")
	avatar15.SetStatus("none")
	avatar15.SetShowOnline(False)
	avatar15.SetAvatarMask("triangle-4")
	avatar15.SetShadow("none")
	avatar15.SetRingWidth(0)
	avatar15.SetRingOffset(0)

'	Dim avatarView15 As B4XView = avatar15.AddToParent(card15, 0, 0, 180dip, 180dip)
	avatarView15.Tag = "mask mask-triangle-4 w-40 h-40"

	Dim lblTitle15 As Label
	lblTitle15.Initialize("")
	Dim xlblTitle15 As B4XView = lblTitle15
	xlblTitle15.Text = "mask mask-triangle-4 w-40 h-40"
	xlblTitle15.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle15.TextSize = 12
	xlblTitle15.SetTextAlignment("CENTER", "CENTER")
	card15.AddView(xlblTitle15, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card15, "avatar": avatar15, "avatar_view": avatarView15, "title": xlblTitle15))

	'Modifier utilities listed in the docs.
	Dim card16 As B4XView = xui.CreatePanel("")
	card16.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card16, 0, 0, 10dip, 10dip)

	Dim avatar16 As B4XDaisyAvatar
	avatar16.Initialize(Me, "maskavatar")
	Dim avatarView16 As B4XView = avatar16.AddToParent(card16, 0, 0, 180dip, 180dip)


	avatar16.SetImage("mask1.webp")
	avatar16.SetWidth("40")
	avatar16.SetHeight("40")
	avatar16.SetCenterOnParent(True)
	avatar16.SetVariant("none")
	avatar16.SetStatus("none")
	avatar16.SetShowOnline(False)
	avatar16.SetAvatarMask("half-1")
	avatar16.SetShadow("none")
	avatar16.SetRingWidth(0)
	avatar16.SetRingOffset(0)

'	Dim avatarView16 As B4XView = avatar16.AddToParent(card16, 0, 0, 180dip, 180dip)
	avatarView16.Tag = "mask mask-squircle mask-half-1 w-40 h-40"

	Dim lblTitle16 As Label
	lblTitle16.Initialize("")
	Dim xlblTitle16 As B4XView = lblTitle16
	xlblTitle16.Text = "mask mask-squircle mask-half-1 w-40 h-40"
	xlblTitle16.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle16.TextSize = 12
	xlblTitle16.SetTextAlignment("CENTER", "CENTER")
	card16.AddView(xlblTitle16, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card16, "avatar": avatar16, "avatar_view": avatarView16, "title": xlblTitle16))

	Dim card17 As B4XView = xui.CreatePanel("")
	card17.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card17, 0, 0, 10dip, 10dip)

	Dim avatar17 As B4XDaisyAvatar
	avatar17.Initialize(Me, "maskavatar")
	Dim avatarView17 As B4XView = avatar17.AddToParent(card17, 0, 0, 180dip, 180dip)


	avatar17.SetImage("mask1.webp")
	avatar17.SetWidth("40")
	avatar17.SetHeight("40")
	avatar17.SetCenterOnParent(True)
	avatar17.SetVariant("none")
	avatar17.SetStatus("none")
	avatar17.SetShowOnline(False)
	avatar17.SetAvatarMask("half-2")
	avatar17.SetShadow("none")
	avatar17.SetRingWidth(0)
	avatar17.SetRingOffset(0)

'	Dim avatarView17 As B4XView = avatar17.AddToParent(card17, 0, 0, 180dip, 180dip)
	avatarView17.Tag = "mask mask-squircle mask-half-2 w-40 h-40"

	Dim lblTitle17 As Label
	lblTitle17.Initialize("")
	Dim xlblTitle17 As B4XView = lblTitle17
	xlblTitle17.Text = "mask mask-squircle mask-half-2 w-40 h-40"
	xlblTitle17.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle17.TextSize = 12
	xlblTitle17.SetTextAlignment("CENTER", "CENTER")
	card17.AddView(xlblTitle17, 0, 0, 10dip, 10dip)

	MaskCards.Add(CreateMap("panel": card17, "avatar": avatar17, "avatar_view": avatarView17, "title": xlblTitle17))
End Sub


Private Sub LayoutCards(Width As Int, Height As Int)
	'Responsive columns:
	'<540dip = 1, >=540dip = 2, >=940dip = 3
	If pnlHost.IsInitialized = False Then Return
	If MaskCards.IsInitialized = False Then Return

	Dim pad As Int = 12dip
	Dim cols As Int = 1
	If Width >= 940dip Then
		cols = 3
	Else If Width >= 540dip Then
		cols = 2
	End If

	Dim cardW As Int = Max(200dip, (Width - pad * (cols + 1)) / cols)
	Dim cardH As Int = 240dip
	Dim rows As Int = 0
	If MaskCards.Size > 0 Then rows = (MaskCards.Size + cols - 1) / cols
	Dim contentH As Int = pad + rows * (cardH + pad)
	svHost.Panel.Height = Max(Height, contentH)

	For i = 0 To MaskCards.Size - 1
		Dim row As Int = i / cols
		Dim col As Int = i Mod cols
		Dim x As Int = pad + col * (cardW + pad)
		Dim y As Int = pad + row * (cardH + pad)

		Dim item As Map = MaskCards.Get(i)
		Dim card As B4XView = item.Get("panel")
		Dim avatar As B4XDaisyAvatar = item.Get("avatar")
		Dim avatarView As B4XView = item.Get("avatar_view")
		Dim xlblTitle As B4XView = item.Get("title")
		Dim titleTop As Int = 182dip

		'ScrollView.Panel uses FrameLayout params; re-add with bounds instead of SetLayoutAnimated.
		card.RemoveViewFromParent
		pnlHost.AddView(card, x, y, cardW, cardH)
		avatarView.SetLayoutAnimated(0, 10dip, 8dip, cardW - 20dip, 170dip)
		'Force avatar internal layout refresh after parent size changes.
		avatar.ResizeToParent(avatarView)
		xlblTitle.SetLayoutAnimated(0, 8dip, titleTop, cardW - 16dip, 48dip)
	Next
End Sub

Private Sub maskavatar_AvatarClick(Payload As Object)
End Sub
