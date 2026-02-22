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
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Avatar Group")

	'Scrollable host panel for manual, responsive card layout.
	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	AvatarCards.Initialize
	CreateSamples
	LayoutCards(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	LayoutCards(Width, Height)
End Sub

Private Sub CreateSamples
	AvatarCards.Clear
	pnlHost.RemoveAllViews
	
	'Sample: Avatar Group Overlap (-space-x-6)
	Dim card1 As B4XView = xui.CreatePanel("")
	card1.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card1, 0, 0, 10dip, 10dip)

	Dim group1 As B4XDaisyAvatarGroup
	group1.Initialize(Me, "avatar_group1")
	Dim groupView1 As B4XView = group1.AddToParent(card1, 0, 0, 120dip, 120dip)
	
	For Each img As String In Array As String("face11.jpg", "face12.jpg", "face14.jpg", "face16.jpg")
		Dim av As B4XDaisyAvatar
		av.Initialize(Me, "grp_av")
		av.CreateView(48dip, 48dip)
		av.SetImage(img)
		av.SetAvatarMask("rounded-full")
		group1.AddAvatar(av)
	Next

	groupView1.Tag = "avatar-group -space-x-6"

	Dim lblTitle1 As Label
	lblTitle1.Initialize("")
	Dim xlblTitle1 As B4XView = lblTitle1
	xlblTitle1.Text = "Group -space-x-6 (Overlap)"
	xlblTitle1.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle1.TextSize = 13
	xlblTitle1.SetTextAlignment("CENTER", "CENTER")
	card1.AddView(xlblTitle1, 0, 0, 10dip, 10dip)

	Dim item1 As Map = CreateMap( _
		"panel": card1, _
		"avatar": group1, _
		"avatar_view": groupView1, _
		"id": "", _
		"title": xlblTitle1 _
	)
	AvatarCards.Add(item1)

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

	'Sample: Text Placeholder Neutral
	Dim card4 As B4XView = xui.CreatePanel("")
	card4.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card4, 0, 0, 10dip, 10dip)

	Dim avatar4 As B4XDaisyAvatar
	avatar4.Initialize(Me, "avatar")
	Dim avatarView4 As B4XView = avatar4.AddToParent(card4, 0, 0, 120dip, 120dip)

	avatar4.SetAvatarType("text")
	avatar4.SetPlaceHolder("AB")
	avatar4.SetWidth("24")
	avatar4.SetHeight("24")
	avatar4.SetCenterOnParent(True)
	avatar4.SetVariant("neutral")
	avatar4.SetBackgroundColorVariant("neutral")
	avatar4.SetTextColorVariant("neutral-content")
	avatar4.SetAvatarMask("rounded-full")
	
	avatarView4.Tag = "placeholder neutral sz-24"

	Dim lblTitle4 As Label
	lblTitle4.Initialize("")
	Dim xlblTitle4 As B4XView = lblTitle4
	xlblTitle4.Text = "Placeholder (Neutral)"
	xlblTitle4.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle4.TextSize = 13
	xlblTitle4.SetTextAlignment("CENTER", "CENTER")
	card4.AddView(xlblTitle4, 0, 0, 10dip, 10dip)

	Dim item4 As Map = CreateMap( _
		"panel": card4, _
		"avatar": avatar4, _
		"avatar_view": avatarView4, _
		"id": "", _
		"title": xlblTitle4 _
	)
	AvatarCards.Add(item4)

	'Sample: Avatar Group Mixed Images + Placeholder
	Dim card3 As B4XView = xui.CreatePanel("")
	card3.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card3, 0, 0, 10dip, 10dip)

	Dim group3 As B4XDaisyAvatarGroup
	group3.Initialize(Me, "avatar_group_mixed")
	Dim groupView3 As B4XView = group3.AddToParent(card3, 0, 0, 120dip, 120dip)
	
	group3.setLimitTo(2)
	
	For Each img As String In Array As String("face22.jpg", "face23.jpg", "face24.jpg")
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
	card3.AddView(xlblTitle3, 0, 0, 10dip, 10dip)

	Dim item3 As Map = CreateMap( _
		"panel": card3, _
		"avatar": group3, _
		"avatar_view": groupView3, _
		"id": "", _
		"title": xlblTitle3 _
	)
	AvatarCards.Add(item3)

	'Sample: Avatar Group No Limit (limit 0)
	Dim cardNoLimit As B4XView = xui.CreatePanel("")
	cardNoLimit.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(cardNoLimit, 0, 0, 10dip, 10dip)

	Dim groupNoLimit As B4XDaisyAvatarGroup
	groupNoLimit.Initialize(Me, "avatar_group_nolimit")
	Dim groupViewNoLimit As B4XView = groupNoLimit.AddToParent(cardNoLimit, 0, 0, 120dip, 120dip)
	
	groupNoLimit.setLimitTo(0)
	
	For Each img As String In Array As String("face11.jpg", "face12.jpg", "face14.jpg", "face16.jpg", "face17.jpg", "face18.jpg")
		Dim av As B4XDaisyAvatar
		av.Initialize(Me, "grp_av_nl")
		av.CreateView(48dip, 48dip)
		av.SetImage(img)
		av.SetAvatarMask("rounded-full")
		groupNoLimit.AddAvatar(av)
	Next

	groupViewNoLimit.Tag = "avatar-group no-limit"

	Dim lblTitleNoLimit As Label
	lblTitleNoLimit.Initialize("")
	Dim xlblTitleNoLimit As B4XView = lblTitleNoLimit
	xlblTitleNoLimit.Text = "Group No Limit (limit 0)"
	xlblTitleNoLimit.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitleNoLimit.TextSize = 13
	xlblTitleNoLimit.SetTextAlignment("CENTER", "CENTER")
	cardNoLimit.AddView(xlblTitleNoLimit, 0, 0, 10dip, 10dip)

	Dim itemNoLimit As Map = CreateMap( _
		"panel": cardNoLimit, _
		"avatar": groupNoLimit, _
		"avatar_view": groupViewNoLimit, _
		"id": "", _
		"title": xlblTitleNoLimit _
	)
	AvatarCards.Add(itemNoLimit)

	'Sample: Text Placeholder Accent
	Dim card5 As B4XView = xui.CreatePanel("")
	card5.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card5, 0, 0, 10dip, 10dip)

	Dim avatar5 As B4XDaisyAvatar
	avatar5.Initialize(Me, "avatar")
	Dim avatarView5 As B4XView = avatar5.AddToParent(card5, 0, 0, 120dip, 120dip)

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
	card5.AddView(xlblTitle5, 0, 0, 10dip, 10dip)

	Dim item5 As Map = CreateMap( _
		"panel": card5, _
		"avatar": avatar5, _
		"avatar_view": avatarView5, _
		"id": "", _
		"title": xlblTitle5 _
	)
	AvatarCards.Add(item5)
	
	'Sample: Avatar Group Gap (space-x-4)
	Dim card2 As B4XView = xui.CreatePanel("")
	card2.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card2, 0, 0, 10dip, 10dip)

	Dim group2 As B4XDaisyAvatarGroup
	group2.Initialize(Me, "avatar_group2")
	Dim groupView2 As B4XView = group2.AddToParent(card2, 0, 0, 120dip, 120dip)
	

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

	Dim lblTitle2 As Label
	lblTitle2.Initialize("")
	Dim xlblTitle2 As B4XView = lblTitle2
	xlblTitle2.Text = "Group space-x-4 (Gap)"
	xlblTitle2.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle2.TextSize = 13
	xlblTitle2.SetTextAlignment("CENTER", "CENTER")
	card2.AddView(xlblTitle2, 0, 0, 10dip, 10dip)

	Dim item2 As Map = CreateMap( _
		"panel": card2, _
		"avatar": group2, _
		"avatar_view": groupView2, _
		"id": "", _
		"title": xlblTitle2 _
	)
	AvatarCards.Add(item2)

End Sub


Private Sub LayoutCards(Width As Int, Height As Int)
	'Responsive columns:
	'<620dip = 2, >=620dip = 3, >=880dip = 4
	If pnlHost.IsInitialized = False Then Return
	If AvatarCards.IsInitialized = False Then Return

	Dim pad As Int = 12dip
	Dim cols As Int = 1
	Dim cardW As Int = Max(120dip, Width - pad * 2)
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
		Dim avatar As Object = item.Get("avatar")
		Dim avatarView As B4XView = item.Get("avatar_view")
		Dim xlblTitle As B4XView = item.Get("title")
		Dim titleTop As Int = 120dip

		'ScrollView.Panel uses FrameLayout params; re-add with bounds instead of SetLayoutAnimated.
		card.RemoveViewFromParent
		pnlHost.AddView(card, x, y, cardW, cardH)
		avatarView.SetLayoutAnimated(0, 10dip, 8dip, cardW - 20dip, 108dip)
		
		'Important: force avatar internal layout refresh after parent size changes.
		If avatar <> Null Then
			If xui.SubExists(avatar, "ResizeToParent", 1) Then
				CallSub2(avatar, "ResizeToParent", avatarView)
			Else If xui.SubExists(avatar, "Base_Resize", 2) Then
				CallSub3(avatar, "Base_Resize", avatarView.Width, avatarView.Height)
			End If
		End If
			
		xlblTitle.SetLayoutAnimated(0, 8dip, titleTop, cardW - 16dip, 30dip)
	Next
End Sub
