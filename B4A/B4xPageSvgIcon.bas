B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pnlCard As B4XView
	Private lblTitle As B4XView
	Private lblState As B4XView
	Private SvgIcon As B4XDaisySvgIcon
	Private IconView As B4XView
	Private DemoToken As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "SVG Icon")

	Dim t As Label
	t.Initialize("")
	lblTitle = t
	lblTitle.Text = "B4XDaisySvgIcon (B4A)"
	lblTitle.TextColor = xui.Color_RGB(15, 23, 42)
	lblTitle.TextSize = 20
	lblTitle.SetTextAlignment("CENTER", "CENTER")
	Root.AddView(lblTitle, 0, 0, 10dip, 10dip)

	Dim p As B4XView = xui.CreatePanel("")
	p.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(226, 232, 240), 18dip)
	pnlCard = p
	Root.AddView(pnlCard, 0, 0, 10dip, 10dip)

	Dim s As Label
	s.Initialize("")
	lblState = s
	lblState.Text = ""
	lblState.TextColor = xui.Color_RGB(51, 65, 85)
	lblState.TextSize = 13
	lblState.SetTextAlignment("CENTER", "CENTER")
	Root.AddView(lblState, 0, 0, 10dip, 10dip)

	SvgIcon.Initialize(Me, "svg")
	IconView = SvgIcon.AddToParent(pnlCard, 0, 0, 200dip, 200dip)
	SvgIcon.SetSvgAsset("book-open-solid.svg")
	SvgIcon.SetPreserveOriginalColors(False)
	SvgIcon.SetColorVariant("primary")
	SvgIcon.SetSize("24")
'	IconView = SvgIcon.AddToParent(pnlCard, 0, 0, 200dip, 200dip)

	LayoutPage(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
	StartDemoLoop
End Sub

Private Sub B4XPage_Disappear
	DemoToken = DemoToken + 1
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	LayoutPage(Width, Height)
End Sub

Private Sub LayoutPage(Width As Int, Height As Int)
	If Width <= 0 Or Height <= 0 Then Return
	Dim pad As Int = 14dip
	Dim titleH As Int = 34dip
	Dim stateH As Int = 42dip
	Dim cardW As Int = Min(260dip, Max(160dip, Width - pad * 2))
	Dim cardH As Int = cardW
	Dim cardLeft As Int = (Width - cardW) / 2
	Dim cardTop As Int = Max(titleH + pad * 2, (Height - cardH) / 2 - 14dip)

	lblTitle.SetLayoutAnimated(0, pad, pad, Width - pad * 2, titleH)
	pnlCard.SetLayoutAnimated(0, cardLeft, cardTop, cardW, cardH)
	lblState.SetLayoutAnimated(0, pad, cardTop + cardH + 8dip, Width - pad * 2, stateH)
	If IconView.IsInitialized Then
		IconView.SetLayoutAnimated(0, 0, 0, cardW, cardH)
		SvgIcon.ResizeToParent(IconView)
	End If
End Sub

Private Sub StartDemoLoop
	DemoToken = DemoToken + 1
	Dim token As Int = DemoToken
	RunDemoLoop(token)
End Sub

Private Sub RunDemoLoop(Token As Int)
	Dim variants As List = BuildVariantCycle
	If variants.Size = 0 Then Return
	Dim sizes() As String = Array As String("14", "16", "20", "24", "28", "32")
	Dim idx As Int = 0
	Do While Token = DemoToken
		Dim variant As String = variants.Get(idx Mod variants.Size)
		Dim sizeSpec As String = sizes(idx Mod sizes.Length)
		SvgIcon.SetColorVariant(variant)
		SvgIcon.SetSize(sizeSpec)
		lblState.Text = "asset: book-open-solid.svg | color: " & variant & " | size: " & sizeSpec
		idx = idx + 1
		Sleep(3000)
	Loop
End Sub

Private Sub BuildVariantCycle As List
	Dim lst As List
	lst.Initialize
	Dim raw() As String = Regex.Split("\|", B4XDaisyVariants.VariantList)
	For Each v As String In raw
		Dim n As String = B4XDaisyVariants.NormalizeVariant(v)
		If n <> "none" And lst.IndexOf(n) = -1 Then lst.Add(n)
	Next
	Return lst
End Sub
