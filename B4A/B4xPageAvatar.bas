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

	AddAvatarSample("sz-24 rounded", "24", "daisyman1.png", "none", "none", "rounded", "none", "")
	AddAvatarSample("sz-24 rounded-xl", "24", "daisywoman1.jpg", "none", "none", "rounded-xl", "none", "mask-demo")
	AddAvatarSample("sz-24 rounded-full", "24", "face27.jpg", "none", "none", "rounded-full", "none", "")
	AddAvatarSample("avatar-online sz-24 rounded-full", "24", "face22.jpg", "none", "online", "rounded-full", "none", "online-demo")
	AddAvatarSample("avatar-offline sz-24 rounded-full", "24", "face23.jpg", "none", "offline", "rounded-full", "none", "")
	AddAvatarSample("ring-primary ring-2 ring-offset-2 sz-24 rounded-full", "24", "face21.jpg", "primary", "none", "rounded-full", "none", "ring-demo")
	'Map Daisy ring utilities to component settings for the sample above.
	ConfigureLastSampleRing("primary", 2dip, 2dip)
	AddAvatarSample("mask-heart sz-24", "24", "face24.jpg", "none", "none", "heart", "none", "")
	AddAvatarSample("mask-squircle sz-24", "24", "face25.jpg", "none", "none", "squircle", "none", "")
	AddAvatarSample("mask-hexagon-2 sz-24", "24", "face26.jpg", "none", "none", "hexagon-2", "none", "")
	AddAvatarSample("sz-32 rounded", "32", "daisyman1.png", "none", "none", "rounded", "none", "")
	AddAvatarSample("sz-20 rounded", "20", "daisyman1.png", "none", "none", "rounded", "none", "")
	AddAvatarSample("sz-16 rounded", "16", "daisyman1.png", "none", "none", "rounded", "none", "")
	AddAvatarSample("sz-8 rounded", "8", "daisyman1.png", "none", "none", "rounded", "none", "")
	'AddAvatarSample("Tailwind 8", "8", "anna.jpg", "primary", "online", "circle", "xs")
	'AddAvatarSample("Tailwind 10", "10", "angela.jpg", "secondary", "online", "rounded", "sm")
	'AddAvatarSample("Tailwind 12", "12", "face3.jpg", "accent", "offline", "squircle", "md")
	'AddAvatarSample("80px", "80px", "face8.jpg", "info", "online", "hexagon", "lg")
	'AddAvatarSample("4em", "4em", "daisywoman1.jpg", "success", "offline", "heart", "xl")
	'AddAvatarSample("5rem", "5rem", "daisyman1.png", "warning", "online", "star", "2xl")
End Sub

Private Sub ConfigureLastSampleRing(VariantName As String, RingWidth As Float, RingOffset As Float)
	'Apply ring settings to the most recently added sample card.
	If AvatarCards.IsInitialized = False Or AvatarCards.Size = 0 Then Return
	Dim item As Map = AvatarCards.Get(AvatarCards.Size - 1)
	Dim avatar As B4XDaisyAvatar = item.Get("avatar")
	avatar.SetVariant(VariantName)
	avatar.SetRingColorVariant(VariantName)
	avatar.SetRingWidth(Max(0, RingWidth))
	avatar.SetRingOffset(Max(0, RingOffset))
End Sub

Private Sub AddAvatarSample(Title As String, SizeSpec As String, ImageFile As String, VariantName As String, Status As String, MaskName As String, ShadowLevel As String, AvatarId As String)
	'Card container.
	Dim card As B4XView = xui.CreatePanel("")
	card.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card, 0, 0, 10dip, 10dip)

	'Create avatar using the Initialize -> CreateView workflow.
	Dim avatar As B4XDaisyAvatar
	avatar.Initialize(Me, "avatar")
	Dim avatarView As B4XView = avatar.CreateView(120dip, 120dip)
	avatarView.Tag = Title
	card.AddView(avatarView, 0, 0, 120dip, 120dip)

	'Apply sample settings so each card demonstrates different properties.
	avatar.SetImage(ResolveAssetImage(ImageFile))
	avatar.SetWidth(SizeSpec)
	avatar.SetHeight(SizeSpec)
	avatar.SetCenterOnParent(True)
	avatar.SetVariant(VariantName)
	avatar.SetStatus(Status)
	avatar.SetAvatarMask(MaskName)
	avatar.SetShadow(ShadowLevel)
	avatar.SetRingOffset(4dip)
	avatar.SetShowOnline(Status <> "none")

	Dim lblTitle As Label
	lblTitle.Initialize("")
	Dim xlblTitle As B4XView = lblTitle
	xlblTitle.Text = Title
	xlblTitle.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle.TextSize = 13
	xlblTitle.SetTextAlignment("CENTER", "CENTER")
	card.AddView(xlblTitle, 0, 0, 10dip, 10dip)

	Dim item As Map = CreateMap( _
		"panel": card, _
		"avatar": avatar, _
		"avatar_view": avatarView, _
		"id": AvatarId, _
		"title": xlblTitle _
	)
	'Store references for later relayout in B4XPage_Resize.
	AvatarCards.Add(item)
	Dim normalizedId As String = AvatarId.ToLowerCase.Trim
	If normalizedId <> "" Then AvatarById.Put(normalizedId, item)
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
			Dim onlineColor As Int = B4XDaisyVariants.ResolveOnlineColor(variant, 0xFF2ECC71)
			avatar.SetShowOnline(True)
			avatar.SetStatus("online")
			avatar.SetVariant(variant)
			avatar.SetAvatarOnlineColor(onlineColor)
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
