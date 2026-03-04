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
    Private PAGE_PAD As Int = 12dip
    Private SECTION_GAP As Int = 16dip
    Private HERO_WIDTH As Int = 400dip
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    'Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "Hero")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Width - (PAGE_PAD * 2)
    Dim useW As Int = Min(HERO_WIDTH, maxW)
    Dim targetX As Int = (Width - useW) / 2
    Dim y As Int = PAGE_PAD
    Dim H_HEIGHT As Int = 320dip
    
    ' DaisyUI: Centered hero (rounded box)
    y = AddSectionTitle("1. Centered Hero (DaisyUI)", y, maxW)
    Dim h1 As B4XDaisyHero
    h1.Initialize(Me, "hero")
    h1.AddToParent(pnlHost, targetX, y, useW, H_HEIGHT)
    h1.Direction = "vertical"
    h1.ContentAlignment = "center"
    h1.Gap = "4"
    h1.BackgroundColorVariant = "bg-base-300"
    h1.TextColorVariant = "text-neutral-content"
    h1.RoundedBox = True
    
    ' explicitly use white text on the centered hero
    AddHeroContentWithColor(h1, "Hello there", "Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem quasi.", "Get Started", xui.Color_White)
    y = y + H_HEIGHT + SECTION_GAP

    ' DaisyUI: Hero with overlay image - rounded with shadow
    y = AddSectionTitle("2. Hero with Overlay (DaisyUI)", y, maxW)
    Dim h4 As B4XDaisyHero
    h4.Initialize(Me, "hero")
    h4.AddToParent(pnlHost, targetX, y, useW, H_HEIGHT)
    h4.Direction = "vertical"
    h4.ContentAlignment = "center"
    h4.Rounded = "rounded"
    h4.Shadow = "lg"
    h4.TextColorVariant = "text-neutral-content"
    h4.OverlayVisible = True
    h4.BackgroundImage = "photo-1507358522600-9f71e620c44e.webp"
    
    AddHeroContentWithColor(h4, "Hello there", "Provident cupiditate voluptatem et in.", "Get Started", xui.Color_White)
    y = y + H_HEIGHT + SECTION_GAP

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + 30dip
End Sub

Private Sub AddHeroContent(Hero As B4XDaisyHero, Title As String, Desc As String, ButtonText As String)
    AddHeroContentWithColor(Hero, Title, Desc, ButtonText, xui.Color_Black)
End Sub

Private Sub AddHeroContentWithColor(Hero As B4XDaisyHero, Title As String, Desc As String, ButtonText As String, TextColor As Int)
    Dim p As B4XView = Hero.GetContentPanel
    Dim totalH As Int = 150dip
    Dim startY As Int = (p.Height - totalH) / 2
    AddHeroTextToPanel(p, Title, Desc, 0, startY, p.Width, TextColor)
    
    If ButtonText.Length > 0 Then
        Dim b As B4XDaisyButton
        b.Initialize(Me, "herobtn")
        b.AddToParent(p, (p.Width - 120dip) / 2, startY + 110dip, 120dip, 40dip)
        b.Text = ButtonText
        b.Variant = "primary"
    End If
End Sub

Private Sub AddHeroTextToPanel(P As B4XView, Title As String, Desc As String, X As Int, Y As Int, Width As Int, TextColor As Int)
    Dim t As B4XDaisyText
    t.Initialize(Me, "")
    t.AddToParent(P, X, Y, Width, 40dip)
    t.Text = Title
    t.TextSize = 24
    t.FontBold = True
    t.TextColor = TextColor
    t.SetTextAlignment("CENTER", "CENTER")
    
    Dim d As B4XDaisyText
    d.Initialize(Me, "")
    d.AddToParent(P, X, Y + 45dip, Width, 60dip)
    d.Text = Desc
    d.TextSize = 14
    d.TextColor = TextColor
    d.SetTextAlignment("CENTER", "CENTER")
End Sub



Private Sub hero_Click(Tag As Object)
    ' Handle hero click
End Sub

Private Sub herobtn_Click(Tag As Object)
    ToastMessageShow("Hero Action Clicked!", False)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
