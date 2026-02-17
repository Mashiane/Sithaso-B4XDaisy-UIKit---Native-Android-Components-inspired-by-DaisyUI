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
	AddMaskSample("mask mask-squircle w-40 h-40", "40", "squircle")
	AddMaskSample("mask mask-heart w-40 h-40", "40", "heart")
	AddMaskSample("mask mask-hexagon w-40 h-40", "40", "hexagon")
	AddMaskSample("mask mask-hexagon-2 w-40 h-40", "40", "hexagon-2")
	AddMaskSample("mask mask-decagon w-40 h-40", "40", "decagon")
	AddMaskSample("mask mask-pentagon w-40 h-40", "40", "pentagon")
	AddMaskSample("mask mask-diamond w-40 h-40", "40", "diamond")
	AddMaskSample("mask mask-square w-40 h-40", "40", "square")
	AddMaskSample("mask mask-circle w-40 h-40", "40", "circle")
	AddMaskSample("mask mask-star w-40 h-40", "40", "star")
	AddMaskSample("mask mask-star-2 w-40 h-40", "40", "star-2")
	AddMaskSample("mask mask-triangle w-40 h-40", "40", "triangle")
	AddMaskSample("mask mask-triangle-2 w-40 h-40", "40", "triangle-2")
	AddMaskSample("mask mask-triangle-3 w-40 h-40", "40", "triangle-3")
	AddMaskSample("mask mask-triangle-4 w-40 h-40", "40", "triangle-4")

	'Modifier utilities listed in the docs.
	AddMaskSample("mask mask-squircle mask-half-1 w-40 h-40", "40", "half-1")
	AddMaskSample("mask mask-squircle mask-half-2 w-40 h-40", "40", "half-2")
End Sub

Private Sub AddMaskSample(Title As String, SizeSpec As String, MaskName As String)
	'Card container.
	Dim card As B4XView = xui.CreatePanel("")
	card.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 14dip)
	pnlHost.AddView(card, 0, 0, 10dip, 10dip)

	'Create avatar using the same component workflow as the avatar page.
	Dim avatar As B4XDaisyAvatar
	avatar.Initialize(Me, "maskavatar")
	Dim avatarView As B4XView = avatar.CreateView(180dip, 180dip)
	avatarView.Tag = Title
	card.AddView(avatarView, 0, 0, 180dip, 180dip)

	avatar.SetImage(ResolveAssetImage("mask.webp"))
	avatar.SetWidth(SizeSpec)
	avatar.SetHeight(SizeSpec)
	avatar.SetCenterOnParent(True)
	avatar.SetVariant("none")
	avatar.SetStatus("none")
	avatar.SetShowOnline(False)
	avatar.SetAvatarMask(MaskName)
	avatar.SetShadow("none")
	avatar.SetRingWidth(0)
	avatar.SetRingOffset(0)

	Dim lblTitle As Label
	lblTitle.Initialize("")
	Dim xlblTitle As B4XView = lblTitle
	xlblTitle.Text = Title
	xlblTitle.TextColor = xui.Color_RGB(15, 23, 42)
	xlblTitle.TextSize = 12
	xlblTitle.SetTextAlignment("CENTER", "CENTER")
	card.AddView(xlblTitle, 0, 0, 10dip, 10dip)

	Dim item As Map = CreateMap( _
		"panel": card, _
		"avatar": avatar, _
		"avatar_view": avatarView, _
		"title": xlblTitle _
	)
	'Store references for later relayout in B4XPage_Resize.
	MaskCards.Add(item)
End Sub

Private Sub ResolveAssetImage(FileName As String) As String
	If File.Exists(File.DirAssets, FileName) Then Return FileName
	Return "default.png"
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
	Log("Mask page click: " & Payload)
End Sub
