B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12
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
End Sub

Private Sub B4XPage_Appear
	If AvatarCards.Size = 0 Then
		Wait For (CreateSamples) Complete  (Done As Boolean)
	End If
	StartRuntimeDemos
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Disappear
	'Invalidate currently running demo loops.
	DemoLoopToken = DemoLoopToken + 1
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	LayoutCards(Width, Height)
End Sub

Private Sub CreateSamples As ResumableSub
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

	
	avatar1.SetImage("face11.jpg")
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


	avatar2.SetImage("face12.jpg")
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
	Sleep(0)

	'Sample: sz-24 rounded-full
	Dim card3 As B4XView = xui.CreatePanel("")
	card3.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card3, 0, 0, 10dip, 10dip)

	Dim avatar3 As B4XDaisyAvatar
	avatar3.Initialize(Me, "avatar")
	Dim avatarView3 As B4XView = avatar3.AddToParent(card3, 0, 0, 120dip, 120dip)


	avatar3.SetImage("face14.jpg")
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


	avatar4.SetImage("face16.jpg")
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
	Sleep(0)

	'Sample: avatar-offline sz-24 rounded-full
	Dim card5 As B4XView = xui.CreatePanel("")
	card5.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card5, 0, 0, 10dip, 10dip)

	Dim avatar5 As B4XDaisyAvatar
	avatar5.Initialize(Me, "avatar")
	Dim avatarView5 As B4XView = avatar5.AddToParent(card5, 0, 0, 120dip, 120dip)


	avatar5.SetImage("face17.jpg")
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


	avatar6.SetImage("face18.jpg")
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
	Sleep(0)

	'Sample: mask-heart sz-24
	Dim card7 As B4XView = xui.CreatePanel("")
	card7.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card7, 0, 0, 10dip, 10dip)

	Dim avatar7 As B4XDaisyAvatar
	avatar7.Initialize(Me, "avatar")
	Dim avatarView7 As B4XView = avatar7.AddToParent(card7, 0, 0, 120dip, 120dip)


	avatar7.SetImage("face19.jpg")
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


	avatar8.SetImage("face21.jpg")
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
	Sleep(0)

	'Sample: mask-hexagon-2 sz-24
	Dim card9 As B4XView = xui.CreatePanel("")
	card9.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card9, 0, 0, 10dip, 10dip)

	Dim avatar9 As B4XDaisyAvatar
	avatar9.Initialize(Me, "avatar")
	Dim avatarView9 As B4XView = avatar9.AddToParent(card9, 0, 0, 120dip, 120dip)


	avatar9.SetImage("face22.jpg")
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


	avatar10.SetImage("face_1.jpg")
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


	avatar11.SetImage("face_2.jpg")
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


	avatar12.SetImage("face_3.jpg")
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
	Sleep(0)

	'Sample: sz-8 rounded
	Dim card13 As B4XView = xui.CreatePanel("")
	card13.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card13, 0, 0, 10dip, 10dip)

	Dim avatar13 As B4XDaisyAvatar
	avatar13.Initialize(Me, "avatar")
	Dim avatarView13 As B4XView = avatar13.AddToParent(card13, 0, 0, 120dip, 120dip)


	avatar13.SetImage("face4.jpg")
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
	
	'Sample: Placeholder D sz-24
	Dim cardD As B4XView = xui.CreatePanel("")
	cardD.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardD, 0, 0, 10dip, 10dip)

	Dim avatarD As B4XDaisyAvatar
	avatarD.Initialize(Me, "avatar")
	Dim avatarViewD As B4XView = avatarD.AddToParent(cardD, 0, 0, 120dip, 120dip)

	avatarD.SetAvatarType("text")
	avatarD.SetPlaceHolder("D")
	avatarD.SetWidth("24")
	avatarD.SetHeight("24")
	avatarD.SetCenterOnParent(True)
	avatarD.SetVariant("neutral")
	avatarD.SetBackgroundColorVariant("neutral")
	avatarD.SetTextColorVariant("neutral-content")
	avatarD.SetAvatarMask("rounded-full")
	avatarD.TextSize = "text-3xl"
	
	avatarViewD.Tag = "placeholder D sz-24"

	Dim lblTitleD As Label
	lblTitleD.Initialize("")
	Dim xlblTitleD As B4XView = lblTitleD
	xlblTitleD.Text = "placeholder w-24"
	xlblTitleD.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleD.TextSize = 13
	xlblTitleD.SetTextAlignment("CENTER", "CENTER")
	cardD.AddView(xlblTitleD, 0, 0, 10dip, 10dip)

	Dim itemD As Map = CreateMap( _
		"panel": cardD, _
		"avatar": avatarD, _
		"avatar_view": avatarViewD, _
		"id": "", _
		"title": xlblTitleD _
	)
	AvatarCards.Add(itemD)
	Sleep(0)

	'Sample: Placeholder AI sz-16 online
	Dim cardAI As B4XView = xui.CreatePanel("")
	cardAI.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardAI, 0, 0, 10dip, 10dip)

	Dim avatarAI As B4XDaisyAvatar
	avatarAI.Initialize(Me, "avatar")
	Dim avatarViewAI As B4XView = avatarAI.AddToParent(cardAI, 0, 0, 120dip, 120dip)

	avatarAI.SetAvatarType("text")
	avatarAI.SetPlaceHolder("AI")
	avatarAI.SetWidth("16")
	avatarAI.SetHeight("16")
	avatarAI.SetCenterOnParent(True)
	avatarAI.SetVariant("neutral")
	avatarAI.SetBackgroundColorVariant("neutral")
	avatarAI.SetTextColorVariant("neutral-content")
	avatarAI.SetAvatarMask("rounded-full")
	avatarAI.SetStatus("online")
	avatarAI.SetShowOnline(True)
	avatarAI.TextSize = "text-xl"
	
	avatarViewAI.Tag = "placeholder AI sz-16 online"

	Dim lblTitleAI As Label
	lblTitleAI.Initialize("")
	Dim xlblTitleAI As B4XView = lblTitleAI
	xlblTitleAI.Text = "placeholder w-16 online"
	xlblTitleAI.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleAI.TextSize = 13
	xlblTitleAI.SetTextAlignment("CENTER", "CENTER")
	cardAI.AddView(xlblTitleAI, 0, 0, 10dip, 10dip)

	Dim itemAI As Map = CreateMap( _
		"panel": cardAI, _
		"avatar": avatarAI, _
		"avatar_view": avatarViewAI, _
		"id": "", _
		"title": xlblTitleAI _
	)
	AvatarCards.Add(itemAI)

	'Sample: Placeholder SY sz-12
	Dim cardSY As B4XView = xui.CreatePanel("")
	cardSY.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardSY, 0, 0, 10dip, 10dip)

	Dim avatarSY As B4XDaisyAvatar
	avatarSY.Initialize(Me, "avatar")
	Dim avatarViewSY As B4XView = avatarSY.AddToParent(cardSY, 0, 0, 120dip, 120dip)

	avatarSY.SetAvatarType("text")
	avatarSY.SetPlaceHolder("SY")
	avatarSY.SetWidth("12")
	avatarSY.SetHeight("12")
	avatarSY.SetCenterOnParent(True)
	avatarSY.SetVariant("neutral")
	avatarSY.SetBackgroundColorVariant("neutral")
	avatarSY.SetTextColorVariant("neutral-content")
	avatarSY.SetAvatarMask("rounded-full")
	avatarSY.TextSize = "text-base"
	
	avatarViewSY.Tag = "placeholder SY sz-12"

	Dim lblTitleSY As Label
	lblTitleSY.Initialize("")
	Dim xlblTitleSY As B4XView = lblTitleSY
	xlblTitleSY.Text = "placeholder w-12"
	xlblTitleSY.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleSY.TextSize = 13
	xlblTitleSY.SetTextAlignment("CENTER", "CENTER")
	cardSY.AddView(xlblTitleSY, 0, 0, 10dip, 10dip)

	Dim itemSY As Map = CreateMap( _
		"panel": cardSY, _
		"avatar": avatarSY, _
		"avatar_view": avatarViewSY, _
		"id": "", _
		"title": xlblTitleSY _
	)
	AvatarCards.Add(itemSY)
	Sleep(0)

	'Sample: Placeholder UI sz-8
	Dim cardUI As B4XView = xui.CreatePanel("")
	cardUI.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardUI, 0, 0, 10dip, 10dip)

	Dim avatarUI As B4XDaisyAvatar
	avatarUI.Initialize(Me, "avatar")
	Dim avatarViewUI As B4XView = avatarUI.AddToParent(cardUI, 0, 0, 120dip, 120dip)

	avatarUI.SetAvatarType("text")
	avatarUI.SetPlaceHolder("UI")
	avatarUI.SetWidth("8")
	avatarUI.SetHeight("8")
	avatarUI.SetCenterOnParent(True)
	avatarUI.SetVariant("neutral")
	avatarUI.SetBackgroundColorVariant("neutral")
	avatarUI.SetTextColorVariant("neutral-content")
	avatarUI.SetAvatarMask("rounded-full")
	avatarUI.TextSize = "text-xs"
	
	avatarViewUI.Tag = "placeholder UI sz-8"

	Dim lblTitleUI As Label
	lblTitleUI.Initialize("")
	Dim xlblTitleUI As B4XView = lblTitleUI
	xlblTitleUI.Text = "placeholder w-8"
	xlblTitleUI.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleUI.TextSize = 13
	xlblTitleUI.SetTextAlignment("CENTER", "CENTER")
	cardUI.AddView(xlblTitleUI, 0, 0, 10dip, 10dip)

	Dim itemUI As Map = CreateMap( _
		"panel": cardUI, _
		"avatar": avatarUI, _
		"avatar_view": avatarViewUI, _
		"id": "", _
		"title": xlblTitleUI _
	)
	itemUI.Put("title", xlblTitleUI)
	AvatarCards.Add(itemUI)

	'Sample: Avatar Group Overlap (-space-x-6)
	Dim cardG1 As B4XView = xui.CreatePanel("")
	cardG1.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardG1, 0, 0, 10dip, 10dip)

	Dim groupG1 As B4XDaisyAvatarGroup
	groupG1.Initialize(Me, "avatar_group1")
	Dim groupViewG1 As B4XView = groupG1.AddToParent(cardG1, 0, 0, 120dip, 120dip)
	
	For Each img As String In Array As String("face11.jpg", "face12.jpg", "face14.jpg", "face16.jpg")
		Dim av As B4XDaisyAvatar
		av.Initialize(Me, "grp_av")
		av.CreateView(48dip, 48dip)
		av.SetImage(img)
		av.SetAvatarMask("rounded-full")
		groupG1.AddAvatar(av)
	Next

	groupViewG1.Tag = "avatar-group -space-x-6"

	Dim lblTitleG1 As Label
	lblTitleG1.Initialize("")
	Dim xlblTitleG1 As B4XView = lblTitleG1
	xlblTitleG1.Text = "Group -space-x-6 (Overlap)"
	xlblTitleG1.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleG1.TextSize = 13
	xlblTitleG1.SetTextAlignment("CENTER", "CENTER")
	cardG1.AddView(xlblTitleG1, 0, 0, 10dip, 10dip)

	Dim itemG1 As Map = CreateMap( _
		"panel": cardG1, _
		"avatar": groupG1, _
		"avatar_view": groupViewG1, _
		"id": "", _
		"title": xlblTitleG1 _
	)
	AvatarCards.Add(itemG1)

	'Sample: Avatar Group with Overflow Placeholder (+4)
	Dim cardOverflow As B4XView = xui.CreatePanel("")
	cardOverflow.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardOverflow, 0, 0, 10dip, 10dip)

	Dim groupOverflow As B4XDaisyAvatarGroup
	groupOverflow.Initialize(Me, "avatar_group_overflow")
	Dim groupViewOverflow As B4XView = groupOverflow.AddToParent(cardOverflow, 0, 0, 120dip, 120dip)
	
	groupOverflow.setLimitTo(5)
	
	For Each img As String In Array As String("face_1.jpg", "face_2.jpg", "face_3.jpg", "face4.jpg", "face5.jpg", "face6.jpg", "face7.jpg", "face9.jpg", "face_8.jpg")
		Dim av As B4XDaisyAvatar
		av.Initialize(Me, "grp_av_overflow")
		av.CreateView(48dip, 48dip)
		av.SetImage(img)
		av.SetAvatarMask("rounded-full")
		groupOverflow.AddAvatar(av)
	Next

	groupViewOverflow.Tag = "avatar-group overflow"

	Dim lblTitleOverflow As Label
	lblTitleOverflow.Initialize("")
	Dim xlblTitleOverflow As B4XView = lblTitleOverflow
	xlblTitleOverflow.Text = "Group Overflow (9 avatars, limit 5 = +4)"
	xlblTitleOverflow.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleOverflow.TextSize = 13
	xlblTitleOverflow.SetTextAlignment("CENTER", "CENTER")
	cardOverflow.AddView(xlblTitleOverflow, 0, 0, 10dip, 10dip)

	Dim itemOverflow As Map = CreateMap( _
		"panel": cardOverflow, _
		"avatar": groupOverflow, _
		"avatar_view": groupViewOverflow, _
		"id": "", _
		"title": xlblTitleOverflow _
	)
	AvatarCards.Add(itemOverflow)

	'Sample: Avatar Group Mixed Images + Placeholder
	Dim cardG3 As B4XView = xui.CreatePanel("")
	cardG3.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardG3, 0, 0, 10dip, 10dip)

	Dim group3 As B4XDaisyAvatarGroup
	group3.Initialize(Me, "avatar_group_mixed")
	Dim groupView3 As B4XView = group3.AddToParent(cardG3, 0, 0, 120dip, 120dip)
	
	group3.setLimitTo(2)
	
	For Each img As String In Array As String("face22.jpg", "face_2.jpg", "face24.jpg")
		Dim av As B4XDaisyAvatar
		av.Initialize(Me, "grp_av_img")
		av.CreateView(48dip, 48dip)
		av.SetImage(img)
		av.SetAvatarMask("rounded-full")
		group3.AddAvatar(av)
	Next
	
	' Add the placeholder at the end of the group
	Dim avText As B4XDaisyAvatar
	avText.Initialize(Me, "grp_av_txt")
	avText.CreateView(48dip, 48dip)
	avText.SetAvatarType("text")
	avText.SetPlaceHolder("+99")
	avText.SetVariant("secondary")
	avText.SetBackgroundColorVariant("secondary")
	avText.SetTextColorVariant("secondary-content")
	avText.SetAvatarMask("rounded-full")
	group3.AddAvatar(avText)

	groupView3.Tag = "avatar-group mixed"

	Dim lblTitle3 As Label
	lblTitle3.Initialize("")
	Dim xlblTitle3 As B4XView = lblTitle3
	xlblTitle3.Text = "Group Mixed (limit 2, +3)"
	xlblTitle3.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle3.TextSize = 13
	xlblTitle3.SetTextAlignment("CENTER", "CENTER")
	cardG3.AddView(xlblTitle3, 0, 0, 10dip, 10dip)

	Dim itemG3 As Map = CreateMap( _
		"panel": cardG3, _
		"avatar": group3, _
		"avatar_view": groupView3, _
		"id": "", _
		"title": xlblTitle3 _
	)
	AvatarCards.Add(itemG3)

	
	'Sample: Avatar Group Gap (space-x-4)
	Dim card2G As B4XView = xui.CreatePanel("")
	card2G.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card2G, 0, 0, 10dip, 10dip)

	Dim group2 As B4XDaisyAvatarGroup
	group2.Initialize(Me, "avatar_group2")
	Dim groupView2 As B4XView = group2.AddToParent(card2G, 0, 0, 120dip, 120dip)
	
	group2.setSpacing("space-x-4")
	
	For Each img As String In Array As String("face17.jpg", "face18.jpg", "face19.jpg", "face21.jpg")
		Dim av As B4XDaisyAvatar
		av.Initialize(Me, "grp_av")
		av.CreateView(48dip, 48dip)
		av.SetImage(img)
		av.SetAvatarMask("rounded-full")
		group2.AddAvatar(av)
	Next

	groupView2.Tag = "avatar-group space-x-4"

	Dim lblTitle2G As Label
	lblTitle2G.Initialize("")
	Dim xlblTitle2G As B4XView = lblTitle2G
	xlblTitle2G.Text = "Group space-x-4 (Gap)"
	xlblTitle2G.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle2G.TextSize = 13
	xlblTitle2G.SetTextAlignment("CENTER", "CENTER")
	card2G.AddView(xlblTitle2G, 0, 0, 10dip, 10dip)

	Dim item2G As Map = CreateMap( _
		"panel": card2G, _
		"avatar": group2, _
		"avatar_view": groupView2, _
		"id": "", _
		"title": xlblTitle2G _
	)
	AvatarCards.Add(item2G)

	'Sample: Text Placeholder Accent
	Dim cardG5 As B4XView = xui.CreatePanel("")
	cardG5.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardG5, 0, 0, 10dip, 10dip)

	Dim avatar5 As B4XDaisyAvatar
	avatar5.Initialize(Me, "avatar")
	Dim avatarView5 As B4XView = avatar5.AddToParent(cardG5, 0, 0, 120dip, 120dip)

	avatar5.SetAvatarType("text")
	avatar5.SetPlaceHolder("+99")
	avatar5.SetWidth("16")
	avatar5.SetHeight("16")
	avatar5.SetCenterOnParent(True)
	avatar5.SetVariant("accent")
	avatar5.SetBackgroundColorVariant("accent")
	avatar5.SetTextColorVariant("accent-content")
	avatar5.SetAvatarMask("rounded-full")
	
	avatarView5.Tag = "placeholder accent sz-16"

	Dim lblTitle5 As Label
	lblTitle5.Initialize("")
	Dim xlblTitle5 As B4XView = lblTitle5
	xlblTitle5.Text = "Placeholder (+99, Accent)"
	xlblTitle5.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle5.TextSize = 13
	xlblTitle5.SetTextAlignment("CENTER", "CENTER")
	cardG5.AddView(xlblTitle5, 0, 0, 10dip, 10dip)

	Dim item5 As Map = CreateMap( _
		"panel": cardG5, _
		"avatar": avatar5, _
		"avatar_view": avatarView5, _
		"id": "", _
		"title": xlblTitle5 _
	)
	AvatarCards.Add(item5)
	Sleep(0)
	LayoutCards(Root.Width, Root.Height)
	Return true
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

Private Sub LayoutCards(Width As Int, Height As Int)
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
	Dim currentY As Int = pad
	Dim currentX As Int = pad
	Dim colIndex As Int = 0
	Dim maxRowH As Int = cardH

	For i = 0 To AvatarCards.Size - 1
		Dim item As Map = AvatarCards.Get(i)
		Dim avatar As Object = item.Get("avatar")
		Dim card As B4XView = item.Get("panel")
		Dim avatarView As B4XView = item.Get("avatar_view")
		Dim xlblTitle As B4XView = item.Get("title")
		
		Dim isGroup As Boolean = (GetType(avatar).ToLowerCase.Contains("avatargroup"))
		
		If isGroup Then
			' Finish current single row if needed
			If colIndex > 0 Then
				currentY = currentY + maxRowH + pad
				colIndex = 0
				currentX = pad
			End If
			
			Dim rowW As Int = Width - pad * 2
			Dim rowH As Int = cardH ' Maintain consistency with single cards
			
			card.RemoveViewFromParent
			pnlHost.AddView(card, pad, currentY, rowW, rowH)
			
			' Center group inside the full-width card with internal padding
			avatarView.SetLayoutAnimated(0, 10dip, 8dip, rowW - 20dip, 108dip)
			xlblTitle.SetLayoutAnimated(0, 8dip, 120dip, rowW - 16dip, 30dip)
			
			If xui.SubExists(avatar, "ResizeToParent", 1) Then
				CallSub2(avatar, "ResizeToParent", avatarView)
			Else If xui.SubExists(avatar, "Base_Resize", 2) Then
				CallSub3(avatar, "Base_Resize", avatarView.Width, avatarView.Height)
			End If
			
			currentY = currentY + rowH + pad
		Else
			' Standard grid layout for individual avatars
			card.RemoveViewFromParent
			pnlHost.AddView(card, currentX, currentY, cardW, cardH)
			
			avatarView.SetLayoutAnimated(0, 10dip, 8dip, cardW - 20dip, 108dip)
			xlblTitle.SetLayoutAnimated(0, 8dip, 120dip, cardW - 16dip, 30dip)
			
			If xui.SubExists(avatar, "ResizeToParent", 1) Then
				CallSub2(avatar, "ResizeToParent", avatarView)
			Else If xui.SubExists(avatar, "Base_Resize", 2) Then
				CallSub3(avatar, "Base_Resize", avatarView.Width, avatarView.Height)
			End If
			
			colIndex = colIndex + 1
			If colIndex >= cols Then
				currentY = currentY + cardH + pad
				colIndex = 0
				currentX = pad
			Else
				currentX = currentX + cardW + pad
			End If
		End If
	Next
	
	If colIndex > 0 Then
		currentY = currentY + cardH + pad
	End If
	
	svHost.Panel.Height = Max(Height, currentY)
End Sub

Private Sub avatar_AvatarClick(Payload As Object)
	'Log("Avatar page click: " & Payload)
End Sub


