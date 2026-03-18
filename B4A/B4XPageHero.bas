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
    
    ' 1. Centered hero (rounded-box, bg-neutral)
    y = AddSectionTitle("1. Centered Hero (DaisyUI)", y, maxW)
    Dim h1 As B4XDaisyHero
    h1.Initialize(Me, "hero")
    h1.AddToParent(pnlHost, targetX, y, useW, H_HEIGHT)
    h1.Direction = "vertical"
    h1.ContentAlignment = "center"
    h1.Gap = "4"
    h1.BackgroundColorVariant = "bg-neutral"
    h1.RoundedBox = True
    AddHeroContent(h1, useW, H_HEIGHT, "Hello there", "Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem quasi.", "Get Started", xui.Color_White)
    y = y + H_HEIGHT + SECTION_GAP

    ' 2. Hero with overlay image
    y = AddSectionTitle("2. Hero with Overlay Image (DaisyUI)", y, maxW)
    Dim h2 As B4XDaisyHero
    h2.Initialize(Me, "hero")
    h2.AddToParent(pnlHost, targetX, y, useW, H_HEIGHT)
    h2.Direction = "vertical"
    h2.ContentAlignment = "center"
    h2.Rounded = "rounded"
    h2.Shadow = "lg"
    h2.OverlayVisible = True
    h2.BackgroundImage = "photo-1507358522600-9f71e620c44e.webp"
    AddHeroContent(h2, useW, H_HEIGHT, "Hello there", "Provident cupiditate voluptatem et in.", "Get Started", xui.Color_White)
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
    Return Y + title.GetComputedHeight + 2dip
End Sub

' Add title, body text and optional button to the hero content panel.
' Passes HeroW/HeroH so FlexLayout is reflowed after children are added.
Private Sub AddHeroContent(Hero As B4XDaisyHero, HeroW As Int, HeroH As Int, Title As String, Desc As String, ButtonText As String, TextColor As Int)
    Dim p As B4XView = Hero.GetContentPanel
    Dim contentW As Int = Max(1dip, p.Width)

    Dim t As B4XDaisyText
    t.Initialize(Me, "")
    t.AddToParent(p, 0, 0, contentW, 40dip)
    t.Text = Title
    t.TextSize = 24
    t.FontBold = True
    t.TextColor = TextColor
    t.SetTextAlignment("CENTER", "CENTER")

    Dim d As B4XDaisyText
    d.Initialize(Me, "")
    d.setAutoResize(True)
    d.AddToParent(p, 0, 0, contentW, 20dip)
    d.Text = Desc
    d.TextSize = 14
    d.TextColor = TextColor
    d.SetTextAlignment("CENTER", "CENTER")

    If ButtonText.Length > 0 Then
        Dim b As B4XDaisyButton
        b.Initialize(Me, "herobtn")
        b.AddToParent(p, 0, 0, 120dip, 40dip)
        b.Text = ButtonText
        b.Variant = "primary"
    End If

    ' Reflow FlexLayout now that children are present
    Hero.Base_Resize(HeroW, HeroH)
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
