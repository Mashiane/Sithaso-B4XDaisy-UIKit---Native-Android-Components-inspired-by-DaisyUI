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
	'Each item is a Map with: panel, avatar, avatar_view, title, id.
	Private AvatarCards As List
	'Lookup table for runtime demos / targeted updates by id.
	Private AvatarById As Map
	Private DemoLoopToken As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Avatar")

	'Scrollable host panel for manual, responsive card layout.
	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	AvatarCards.Initialize
	AvatarById.Initialize
	'Build demo cards once, then place them based on current page size.
	CreateSamples
	LayoutCards(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
	StartRuntimeDemos
End Sub

Private Sub B4XPage_Disappear
	'Invalidate currently running demo loops.
	DemoLoopToken = DemoLoopToken + 1
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	LayoutCards(Width, Height)
End Sub

Private Sub CreateSamples
	'Clear and recreate all sample cards from scratch.
	AvatarCards.Clear
	AvatarById.Clear
	pnlHost.RemoveAllViews
	'Sample: sz-24 rounded
	Dim card1 As B4XView = xui.CreatePanel("")
	card1.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card1, 0, 0, 10dip, 10dip)

	Dim avatar1 As B4XDaisyAvatar
	avatar1.Initialize(Me, "avatar")
	Dim avatarView1 As B4XView = avatar1.AddToParent(card1, 0, 0, 120dip, 120dip)


	avatar1.SetImage(ResolveAssetImage("daisyman1.png"))
	avatar1.SetWidth("24")
	avatar1.SetHeight("24")
	avatar1.SetCenterOnParent(True)
	avatar1.SetVariant("none")
	avatar1.SetStatus("none")
	avatar1.SetAvatarMask("rounded")
	avatar1.SetShadow("none")
	avatar1.SetRingOffset(4dip)
	avatar1.SetShowOnline(False)

'	Dim avatarView1 As B4XView = avatar1.AddToParent(card1, 0, 0, 120dip, 120dip)
	avatarView1.Tag = "sz-24 rounded"

	Dim lblTitle1 As Label
	lblTitle1.Initialize("")
	Dim xlblTitle1 As B4XView = lblTitle1
	xlblTitle1.Text = "sz-24 rounded"
	xlblTitle1.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle1.TextSize = 13
	xlblTitle1.SetTextAlignment("CENTER", "CENTER")
	card1.AddView(xlblTitle1, 0, 0, 10dip, 10dip)

	Dim item1 As Map = CreateMap( _
		"panel": card1, _
		"avatar": avatar1, _
		"avatar_view": avatarView1, _
		"id": "", _
		"title": xlblTitle1 _
	)
	AvatarCards.Add(item1)

	'Sample: sz-24 rounded-xl (mask demo)
	Dim card2 As B4XView = xui.CreatePanel("")
	card2.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card2, 0, 0, 10dip, 10dip)

	Dim avatar2 As B4XDaisyAvatar
	avatar2.Initialize(Me, "avatar")
	Dim avatarView2 As B4XView = avatar2.AddToParent(card2, 0, 0, 120dip, 120dip)


	avatar2.SetImage(ResolveAssetImage("daisywoman1.jpg"))
	avatar2.SetWidth("24")
	avatar2.SetHeight("24")
	avatar2.SetCenterOnParent(True)
	avatar2.SetVariant("none")
	avatar2.SetStatus("none")
	avatar2.SetAvatarMask("rounded-xl")
	avatar2.SetShadow("none")
	avatar2.SetRingOffset(4dip)
	avatar2.SetShowOnline(False)

'	Dim avatarView2 As B4XView = avatar2.AddToParent(card2, 0, 0, 120dip, 120dip)
	avatarView2.Tag = "sz-24 rounded-xl"

	Dim lblTitle2 As Label
	lblTitle2.Initialize("")
	Dim xlblTitle2 As B4XView = lblTitle2
	xlblTitle2.Text = "sz-24 rounded-xl"
	xlblTitle2.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle2.TextSize = 13
	xlblTitle2.SetTextAlignment("CENTER", "CENTER")
	card2.AddView(xlblTitle2, 0, 0, 10dip, 10dip)

	Dim item2 As Map = CreateMap( _
		"panel": card2, _
		"avatar": avatar2, _
		"avatar_view": avatarView2, _
		"id": "mask-demo", _
		"title": xlblTitle2 _
	)
	AvatarCards.Add(item2)
	AvatarById.Put("mask-demo", item2)

	'Sample: sz-24 rounded-full
	Dim card3 As B4XView = xui.CreatePanel("")
	card3.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card3, 0, 0, 10dip, 10dip)

	Dim avatar3 As B4XDaisyAvatar
	avatar3.Initialize(Me, "avatar")
	Dim avatarView3 As B4XView = avatar3.AddToParent(card3, 0, 0, 120dip, 120dip)


	avatar3.SetImage(ResolveAssetImage("face27.jpg"))
	avatar3.SetWidth("24")
	avatar3.SetHeight("24")
	avatar3.SetCenterOnParent(True)
	avatar3.SetVariant("none")
	avatar3.SetStatus("none")
	avatar3.SetAvatarMask("rounded-full")
	avatar3.SetShadow("none")
	avatar3.SetRingOffset(4dip)
	avatar3.SetShowOnline(False)

'	Dim avatarView3 As B4XView = avatar3.AddToParent(card3, 0, 0, 120dip, 120dip)
	avatarView3.Tag = "sz-24 rounded-full"

	Dim lblTitle3 As Label
	lblTitle3.Initialize("")
	Dim xlblTitle3 As B4XView = lblTitle3
	xlblTitle3.Text = "sz-24 rounded-full"
	xlblTitle3.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle3.TextSize = 13
	xlblTitle3.SetTextAlignment("CENTER", "CENTER")
	card3.AddView(xlblTitle3, 0, 0, 10dip, 10dip)

	Dim item3 As Map = CreateMap( _
		"panel": card3, _
		"avatar": avatar3, _
		"avatar_view": avatarView3, _
		"id": "", _
		"title": xlblTitle3 _
	)
	AvatarCards.Add(item3)

	'Sample: avatar-online sz-24 rounded-full (online demo)
	Dim card4 As B4XView = xui.CreatePanel("")
	card4.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card4, 0, 0, 10dip, 10dip)

	Dim avatar4 As B4XDaisyAvatar
	avatar4.Initialize(Me, "avatar")
	Dim avatarView4 As B4XView = avatar4.AddToParent(card4, 0, 0, 120dip, 120dip)


	avatar4.SetImage(ResolveAssetImage("face22.jpg"))
	avatar4.SetWidth("24")
	avatar4.SetHeight("24")
	avatar4.SetCenterOnParent(True)
	avatar4.SetVariant("none")
	avatar4.SetStatus("online")
	avatar4.SetAvatarMask("rounded-full")
	avatar4.SetShadow("none")
	avatar4.SetRingOffset(4dip)
	avatar4.SetShowOnline(True)

'	Dim avatarView4 As B4XView = avatar4.AddToParent(card4, 0, 0, 120dip, 120dip)
	avatarView4.Tag = "avatar-online sz-24 rounded-full"

	Dim lblTitle4 As Label
	lblTitle4.Initialize("")
	Dim xlblTitle4 As B4XView = lblTitle4
	xlblTitle4.Text = "avatar-online sz-24 rounded-full"
	xlblTitle4.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle4.TextSize = 13
	xlblTitle4.SetTextAlignment("CENTER", "CENTER")
	card4.AddView(xlblTitle4, 0, 0, 10dip, 10dip)

	Dim item4 As Map = CreateMap( _
		"panel": card4, _
		"avatar": avatar4, _
		"avatar_view": avatarView4, _
		"id": "online-demo", _
		"title": xlblTitle4 _
	)
	AvatarCards.Add(item4)
	AvatarById.Put("online-demo", item4)

	'Sample: avatar-offline sz-24 rounded-full
	Dim card5 As B4XView = xui.CreatePanel("")
	card5.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card5, 0, 0, 10dip, 10dip)

	Dim avatar5 As B4XDaisyAvatar
	avatar5.Initialize(Me, "avatar")
	Dim avatarView5 As B4XView = avatar5.AddToParent(card5, 0, 0, 120dip, 120dip)


	avatar5.SetImage(ResolveAssetImage("face23.jpg"))
	avatar5.SetWidth("24")
	avatar5.SetHeight("24")
	avatar5.SetCenterOnParent(True)
	avatar5.SetVariant("none")
	avatar5.SetStatus("offline")
	avatar5.SetAvatarMask("rounded-full")
	avatar5.SetShadow("none")
	avatar5.SetRingOffset(4dip)
	avatar5.SetShowOnline(True)

'	Dim avatarView5 As B4XView = avatar5.AddToParent(card5, 0, 0, 120dip, 120dip)
	avatarView5.Tag = "avatar-offline sz-24 rounded-full"

	Dim lblTitle5 As Label
	lblTitle5.Initialize("")
	Dim xlblTitle5 As B4XView = lblTitle5
	xlblTitle5.Text = "avatar-offline sz-24 rounded-full"
	xlblTitle5.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle5.TextSize = 13
	xlblTitle5.SetTextAlignment("CENTER", "CENTER")
	card5.AddView(xlblTitle5, 0, 0, 10dip, 10dip)

	Dim item5 As Map = CreateMap( _
		"panel": card5, _
		"avatar": avatar5, _
		"avatar_view": avatarView5, _
		"id": "", _
		"title": xlblTitle5 _
	)
	AvatarCards.Add(item5)

	'Sample: ring-primary ring-2 ring-offset-2 sz-24 rounded-full (ring demo)
	Dim card6 As B4XView = xui.CreatePanel("")
	card6.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card6, 0, 0, 10dip, 10dip)

	Dim avatar6 As B4XDaisyAvatar
	avatar6.Initialize(Me, "avatar")
	Dim avatarView6 As B4XView = avatar6.AddToParent(card6, 0, 0, 120dip, 120dip)


	avatar6.SetImage(ResolveAssetImage("face21.jpg"))
	avatar6.SetWidth("24")
	avatar6.SetHeight("24")
	avatar6.SetCenterOnParent(True)
	avatar6.SetVariant("primary")
	avatar6.SetStatus("none")
	avatar6.SetAvatarMask("rounded-full")
	avatar6.SetShadow("none")
	avatar6.SetRingColorVariant("primary")
	avatar6.SetRingWidth(2dip)
	avatar6.SetRingOffset(2dip)
	avatar6.SetShowOnline(False)

'	Dim avatarView6 As B4XView = avatar6.AddToParent(card6, 0, 0, 120dip, 120dip)
	avatarView6.Tag = "ring-primary ring-2 ring-offset-2 sz-24 rounded-full"

	Dim lblTitle6 As Label
	lblTitle6.Initialize("")
	Dim xlblTitle6 As B4XView = lblTitle6
	xlblTitle6.Text = "ring-primary ring-2 ring-offset-2 sz-24 rounded-full"
	xlblTitle6.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle6.TextSize = 13
	xlblTitle6.SetTextAlignment("CENTER", "CENTER")
	card6.AddView(xlblTitle6, 0, 0, 10dip, 10dip)

	Dim item6 As Map = CreateMap( _
		"panel": card6, _
		"avatar": avatar6, _
		"avatar_view": avatarView6, _
		"id": "ring-demo", _
		"title": xlblTitle6 _
	)
	AvatarCards.Add(item6)
	AvatarById.Put("ring-demo", item6)

	'Sample: mask-heart sz-24
	Dim card7 As B4XView = xui.CreatePanel("")
	card7.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card7, 0, 0, 10dip, 10dip)

	Dim avatar7 As B4XDaisyAvatar
	avatar7.Initialize(Me, "avatar")
	Dim avatarView7 As B4XView = avatar7.AddToParent(card7, 0, 0, 120dip, 120dip)


	avatar7.SetImage(ResolveAssetImage("face24.jpg"))
	avatar7.SetWidth("24")
	avatar7.SetHeight("24")
	avatar7.SetCenterOnParent(True)
	avatar7.SetVariant("none")
	avatar7.SetStatus("none")
	avatar7.SetAvatarMask("heart")
	avatar7.SetShadow("none")
	avatar7.SetRingOffset(4dip)
	avatar7.SetShowOnline(False)

'	Dim avatarView7 As B4XView = avatar7.AddToParent(card7, 0, 0, 120dip, 120dip)
	avatarView7.Tag = "mask-heart sz-24"

	Dim lblTitle7 As Label
	lblTitle7.Initialize("")
	Dim xlblTitle7 As B4XView = lblTitle7
	xlblTitle7.Text = "mask-heart sz-24"
	xlblTitle7.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle7.TextSize = 13
	xlblTitle7.SetTextAlignment("CENTER", "CENTER")
	card7.AddView(xlblTitle7, 0, 0, 10dip, 10dip)

	Dim item7 As Map = CreateMap( _
		"panel": card7, _
		"avatar": avatar7, _
		"avatar_view": avatarView7, _
		"id": "", _
		"title": xlblTitle7 _
	)
	AvatarCards.Add(item7)

	'Sample: mask-squircle sz-24
	Dim card8 As B4XView = xui.CreatePanel("")
	card8.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card8, 0, 0, 10dip, 10dip)

	Dim avatar8 As B4XDaisyAvatar
	avatar8.Initialize(Me, "avatar")
	Dim avatarView8 As B4XView = avatar8.AddToParent(card8, 0, 0, 120dip, 120dip)


	avatar8.SetImage(ResolveAssetImage("face25.jpg"))
	avatar8.SetWidth("24")
	avatar8.SetHeight("24")
	avatar8.SetCenterOnParent(True)
	avatar8.SetVariant("none")
	avatar8.SetStatus("none")
	avatar8.SetAvatarMask("squircle")
	avatar8.SetShadow("none")
	avatar8.SetRingOffset(4dip)
	avatar8.SetShowOnline(False)

'	Dim avatarView8 As B4XView = avatar8.AddToParent(card8, 0, 0, 120dip, 120dip)
	avatarView8.Tag = "mask-squircle sz-24"

	Dim lblTitle8 As Label
	lblTitle8.Initialize("")
	Dim xlblTitle8 As B4XView = lblTitle8
	xlblTitle8.Text = "mask-squircle sz-24"
	xlblTitle8.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle8.TextSize = 13
	xlblTitle8.SetTextAlignment("CENTER", "CENTER")
	card8.AddView(xlblTitle8, 0, 0, 10dip, 10dip)

	Dim item8 As Map = CreateMap( _
		"panel": card8, _
		"avatar": avatar8, _
		"avatar_view": avatarView8, _
		"id": "", _
		"title": xlblTitle8 _
	)
	AvatarCards.Add(item8)

	'Sample: mask-hexagon-2 sz-24
	Dim card9 As B4XView = xui.CreatePanel("")
	card9.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card9, 0, 0, 10dip, 10dip)

	Dim avatar9 As B4XDaisyAvatar
	avatar9.Initialize(Me, "avatar")
	Dim avatarView9 As B4XView = avatar9.AddToParent(card9, 0, 0, 120dip, 120dip)


	avatar9.SetImage(ResolveAssetImage("face26.jpg"))
	avatar9.SetWidth("24")
	avatar9.SetHeight("24")
	avatar9.SetCenterOnParent(True)
	avatar9.SetVariant("none")
	avatar9.SetStatus("none")
	avatar9.SetAvatarMask("hexagon-2")
	avatar9.SetShadow("none")
	avatar9.SetRingOffset(4dip)
	avatar9.SetShowOnline(False)

'	Dim avatarView9 As B4XView = avatar9.AddToParent(card9, 0, 0, 120dip, 120dip)
	avatarView9.Tag = "mask-hexagon-2 sz-24"

	Dim lblTitle9 As Label
	lblTitle9.Initialize("")
	Dim xlblTitle9 As B4XView = lblTitle9
	xlblTitle9.Text = "mask-hexagon-2 sz-24"
	xlblTitle9.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle9.TextSize = 13
	xlblTitle9.SetTextAlignment("CENTER", "CENTER")
	card9.AddView(xlblTitle9, 0, 0, 10dip, 10dip)

	Dim item9 As Map = CreateMap( _
		"panel": card9, _
		"avatar": avatar9, _
		"avatar_view": avatarView9, _
		"id": "", _
		"title": xlblTitle9 _
	)
	AvatarCards.Add(item9)

	'Sample: sz-32 rounded
	Dim card10 As B4XView = xui.CreatePanel("")
	card10.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card10, 0, 0, 10dip, 10dip)

	Dim avatar10 As B4XDaisyAvatar
	avatar10.Initialize(Me, "avatar")
	Dim avatarView10 As B4XView = avatar10.AddToParent(card10, 0, 0, 120dip, 120dip)


	avatar10.SetImage(ResolveAssetImage("daisyman1.png"))
	avatar10.SetWidth("32")
	avatar10.SetHeight("32")
	avatar10.SetCenterOnParent(True)
	avatar10.SetVariant("none")
	avatar10.SetStatus("none")
	avatar10.SetAvatarMask("rounded")
	avatar10.SetShadow("none")
	avatar10.SetRingOffset(4dip)
	avatar10.SetShowOnline(False)

'	Dim avatarView10 As B4XView = avatar10.AddToParent(card10, 0, 0, 120dip, 120dip)
	avatarView10.Tag = "sz-32 rounded"

	Dim lblTitle10 As Label
	lblTitle10.Initialize("")
	Dim xlblTitle10 As B4XView = lblTitle10
	xlblTitle10.Text = "sz-32 rounded"
	xlblTitle10.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle10.TextSize = 13
	xlblTitle10.SetTextAlignment("CENTER", "CENTER")
	card10.AddView(xlblTitle10, 0, 0, 10dip, 10dip)

	Dim item10 As Map = CreateMap( _
		"panel": card10, _
		"avatar": avatar10, _
		"avatar_view": avatarView10, _
		"id": "", _
		"title": xlblTitle10 _
	)
	AvatarCards.Add(item10)

	'Sample: sz-20 rounded
	Dim card11 As B4XView = xui.CreatePanel("")
	card11.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card11, 0, 0, 10dip, 10dip)

	Dim avatar11 As B4XDaisyAvatar
	avatar11.Initialize(Me, "avatar")
	Dim avatarView11 As B4XView = avatar11.AddToParent(card11, 0, 0, 120dip, 120dip)


	avatar11.SetImage(ResolveAssetImage("daisyman1.png"))
	avatar11.SetWidth("20")
	avatar11.SetHeight("20")
	avatar11.SetCenterOnParent(True)
	avatar11.SetVariant("none")
	avatar11.SetStatus("none")
	avatar11.SetAvatarMask("rounded")
	avatar11.SetShadow("none")
	avatar11.SetRingOffset(4dip)
	avatar11.SetShowOnline(False)

'	Dim avatarView11 As B4XView = avatar11.AddToParent(card11, 0, 0, 120dip, 120dip)
	avatarView11.Tag = "sz-20 rounded"

	Dim lblTitle11 As Label
	lblTitle11.Initialize("")
	Dim xlblTitle11 As B4XView = lblTitle11
	xlblTitle11.Text = "sz-20 rounded"
	xlblTitle11.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle11.TextSize = 13
	xlblTitle11.SetTextAlignment("CENTER", "CENTER")
	card11.AddView(xlblTitle11, 0, 0, 10dip, 10dip)

	Dim item11 As Map = CreateMap( _
		"panel": card11, _
		"avatar": avatar11, _
		"avatar_view": avatarView11, _
		"id": "", _
		"title": xlblTitle11 _
	)
	AvatarCards.Add(item11)

	'Sample: sz-16 rounded
	Dim card12 As B4XView = xui.CreatePanel("")
	card12.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card12, 0, 0, 10dip, 10dip)

	Dim avatar12 As B4XDaisyAvatar
	avatar12.Initialize(Me, "avatar")
	Dim avatarView12 As B4XView = avatar12.AddToParent(card12, 0, 0, 120dip, 120dip)


	avatar12.SetImage(ResolveAssetImage("daisyman1.png"))
	avatar12.SetWidth("16")
	avatar12.SetHeight("16")
	avatar12.SetCenterOnParent(True)
	avatar12.SetVariant("none")
	avatar12.SetStatus("none")
	avatar12.SetAvatarMask("rounded")
	avatar12.SetShadow("none")
	avatar12.SetRingOffset(4dip)
	avatar12.SetShowOnline(False)

'	Dim avatarView12 As B4XView = avatar12.AddToParent(card12, 0, 0, 120dip, 120dip)
	avatarView12.Tag = "sz-16 rounded"

	Dim lblTitle12 As Label
	lblTitle12.Initialize("")
	Dim xlblTitle12 As B4XView = lblTitle12
	xlblTitle12.Text = "sz-16 rounded"
	xlblTitle12.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle12.TextSize = 13
	xlblTitle12.SetTextAlignment("CENTER", "CENTER")
	card12.AddView(xlblTitle12, 0, 0, 10dip, 10dip)

	Dim item12 As Map = CreateMap( _
		"panel": card12, _
		"avatar": avatar12, _
		"avatar_view": avatarView12, _
		"id": "", _
		"title": xlblTitle12 _
	)
	AvatarCards.Add(item12)

	'Sample: sz-8 rounded
	Dim card13 As B4XView = xui.CreatePanel("")
	card13.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card13, 0, 0, 10dip, 10dip)

	Dim avatar13 As B4XDaisyAvatar
	avatar13.Initialize(Me, "avatar")
	Dim avatarView13 As B4XView = avatar13.AddToParent(card13, 0, 0, 120dip, 120dip)


	avatar13.SetImage(ResolveAssetImage("daisyman1.png"))
	avatar13.SetWidth("8")
	avatar13.SetHeight("8")
	avatar13.SetCenterOnParent(True)
	avatar13.SetVariant("none")
	avatar13.SetStatus("none")
	avatar13.SetAvatarMask("rounded")
	avatar13.SetShadow("none")
	avatar13.SetRingOffset(4dip)
	avatar13.SetShowOnline(False)

'	Dim avatarView13 As B4XView = avatar13.AddToParent(card13, 0, 0, 120dip, 120dip)
	avatarView13.Tag = "sz-8 rounded"

	Dim lblTitle13 As Label
	lblTitle13.Initialize("")
	Dim xlblTitle13 As B4XView = lblTitle13
	xlblTitle13.Text = "sz-8 rounded"
	xlblTitle13.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle13.TextSize = 13
	xlblTitle13.SetTextAlignment("CENTER", "CENTER")
	card13.AddView(xlblTitle13, 0, 0, 10dip, 10dip)

	Dim item13 As Map = CreateMap( _
		"panel": card13, _
		"avatar": avatar13, _
		"avatar_view": avatarView13, _
		"id": "", _
		"title": xlblTitle13 _
	)
	AvatarCards.Add(item13)
End Sub

Private Sub StartRuntimeDemos
	DemoLoopToken = DemoLoopToken + 1
	Dim token As Int = DemoLoopToken
	RunRingVariantDemo(token)
	RunMaskDemo(token)
	RunOnlineStatusVariantDemo(token)
End Sub

Private Sub RunRingVariantDemo(Token As Int)
	Dim variants As List = BuildRingVariantCycle
	If variants.Size = 0 Then Return
	Dim idx As Int = 0
	Do While Token = DemoLoopToken
		Dim item As Map = GetAvatarCardById("ring-demo")
		If item.IsInitialized Then
			Dim avatar As B4XDaisyAvatar = item.Get("avatar")
			Dim title As B4XView = item.Get("title")
			Dim variant As String = variants.Get(idx Mod variants.Size)
			avatar.SetVariant(variant)
			avatar.SetRingColorVariant(variant)
			avatar.SetRingWidth(2dip)
			avatar.SetRingOffset(2dip)
			title.Text = "ring-" & variant & " ring-2 ring-offset-2 sz-24 rounded-full"
		End If
		idx = idx + 1
		Sleep(5000)
	Loop
End Sub

Private Sub RunMaskDemo(Token As Int)
	Dim masks As List = BuildMaskCycle
	If masks.Size = 0 Then Return
	Dim idx As Int = 0
	Do While Token = DemoLoopToken
		Dim item As Map = GetAvatarCardById("mask-demo")
		If item.IsInitialized Then
			Dim avatar As B4XDaisyAvatar = item.Get("avatar")
			Dim title As B4XView = item.Get("title")
			Dim maskName As String = masks.Get(idx Mod masks.Size)
			avatar.SetAvatarMask(maskName)
			title.Text = "mask-" & maskName & " sz-24"
		End If
		idx = idx + 1
		Sleep(5000)
	Loop
End Sub

Private Sub RunOnlineStatusVariantDemo(Token As Int)
	Dim variants As List = BuildRingVariantCycle
	If variants.Size = 0 Then Return
	Dim idx As Int = 0
	Do While Token = DemoLoopToken
		Dim item As Map = GetAvatarCardById("online-demo")
		If item.IsInitialized Then
			Dim avatar As B4XDaisyAvatar = item.Get("avatar")
			Dim title As B4XView = item.Get("title")
			Dim variant As String = variants.Get(idx Mod variants.Size)
			avatar.SetShowOnline(True)
			avatar.SetStatus("online")
			avatar.SetVariant(variant)
			avatar.SetAvatarOnlineColorVariant(variant)
			title.Text = "avatar-online variant-" & variant & " sz-24 rounded-full"
		End If
		idx = idx + 1
		Sleep(5000)
	Loop
End Sub

Private Sub BuildRingVariantCycle As List
	Dim lst As List
	lst.Initialize
	Dim raw() As String = Regex.Split("\|", B4XDaisyVariants.VariantList)
	For Each v As String In raw
		Dim n As String = B4XDaisyVariants.NormalizeVariant(v)
		If n <> "none" And lst.IndexOf(n) = -1 Then lst.Add(n)
	Next
	Return lst
End Sub

Private Sub BuildMaskCycle As List
	Dim lst As List
	lst.Initialize
	Dim raw() As String = Regex.Split("\|", B4XDaisyVariants.MaskList)
	For Each m As String In raw
		Dim n As String = B4XDaisyVariants.NormalizeMask(m)
		If n <> "" And lst.IndexOf(n) = -1 Then lst.Add(n)
	Next
	Return lst
End Sub

Private Sub GetAvatarCardById(AvatarId As String) As Map
	Dim empty As Map
	If AvatarById.IsInitialized = False Then Return empty
	Dim key As String = AvatarId.ToLowerCase.Trim
	If key = "" Then Return empty
	If AvatarById.ContainsKey(key) = False Then Return empty
	Return AvatarById.Get(key)
End Sub

Public Sub GetAvatarById(AvatarId As String) As B4XDaisyAvatar
	Dim empty As B4XDaisyAvatar
	Dim item As Map = GetAvatarCardById(AvatarId)
	If item.IsInitialized = False Then Return empty
	Return item.Get("avatar")
End Sub

Private Sub ResolveAssetImage(FileName As String) As String
	'Fallback keeps the demo stable even if one sample image is missing.
	If File.Exists(File.DirAssets, FileName) Then Return FileName
	Return "default.png"
End Sub

Private Sub LayoutCards(Width As Int, Height As Int)
	'Responsive columns:
	'<620dip = 2, >=620dip = 3, >=880dip = 4
	If pnlHost.IsInitialized = False Then Return
	If AvatarCards.IsInitialized = False Then Return

	Dim pad As Int = 12dip
	Dim cols As Int = 2
	If Width >= 880dip Then
		cols = 4
	Else If Width >= 620dip Then
		cols = 3
	End If

	Dim cardW As Int = Max(120dip, (Width - pad * (cols + 1)) / cols)
	Dim cardH As Int = 158dip
	Dim rows As Int = 0
	If AvatarCards.Size > 0 Then rows = (AvatarCards.Size + cols - 1) / cols
	Dim contentH As Int = pad + rows * (cardH + pad)
	svHost.Panel.Height = Max(Height, contentH)

	For i = 0 To AvatarCards.Size - 1
		Dim row As Int = i / cols
		Dim col As Int = i Mod cols
		Dim x As Int = pad + col * (cardW + pad)
		Dim y As Int = pad + row * (cardH + pad)

		Dim item As Map = AvatarCards.Get(i)
		Dim card As B4XView = item.Get("panel")
		Dim avatar As B4XDaisyAvatar = item.Get("avatar")
		Dim avatarView As B4XView = item.Get("avatar_view")
		Dim xlblTitle As B4XView = item.Get("title")
		Dim titleTop As Int = 120dip

		'ScrollView.Panel uses FrameLayout params; re-add with bounds instead of SetLayoutAnimated.
		card.RemoveViewFromParent
		pnlHost.AddView(card, x, y, cardW, cardH)
		avatarView.SetLayoutAnimated(0, 10dip, 8dip, cardW - 20dip, 108dip)
		'Important: force avatar internal layout refresh after parent size changes.
		avatar.ResizeToParent(avatarView)
		xlblTitle.SetLayoutAnimated(0, 8dip, titleTop, cardW - 16dip, 30dip)
	Next
End Sub

Private Sub avatar_AvatarClick(Payload As Object)
	Log("Avatar page click: " & Payload)
End Sub
