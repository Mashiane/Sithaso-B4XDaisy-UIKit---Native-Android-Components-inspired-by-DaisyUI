B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Variables
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the demo page.
''' </summary>
Public Sub Initialize As Object
    Return Me
End Sub

''' <summary>
''' B4XPage Created event.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
    B4XPages.SetTitle(Me, "Hover 3D")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI hover-3d examples with native B4X composition.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ''' <summary>
    ''' Example 1: 3D image hover effect.
    ''' </summary>
    y = AddSectionTitle("3D image hover effect", y, maxW)
    y = AddSectionNote("Hover to see the 3D effect applied to a single passive image surface.", y, maxW)

    Dim heroW As Int = maxW
    Dim hoverImage As B4XDaisyHover3d
    hoverImage.Initialize(Me, "hoverImage")
    hoverImage.AddToParent(pnlHost, PAGE_PAD, y, heroW, 214dip)
    hoverImage.setWidth("w-full")
    hoverImage.setHeight("h-[250px]")
    hoverImage.Rounded = "rounded-2xl"
    hoverImage.Padding = "p-[15px]"
    hoverImage.setContentType("image")
    hoverImage.setImage("creditcard.webp")
    hoverImage.ScaleOnHover = 1.05
    hoverImage.MaxTilt = 10
    hoverImage.Refresh
    y = y + hoverImage.GetComputedHeight + 24dip

    ''' <summary>
    ''' Example 2: 3D card hover effect.
    ''' </summary>
    y = AddSectionTitle("3D card hover effect", y, maxW)
    y = AddSectionNote("The wrapper stays general-purpose while the hosted content recreates the dark credit-card example from DaisyUI.", y, maxW)

    Dim cardW As Int = maxW
    Dim hoverCard As B4XDaisyHover3d
    hoverCard.Initialize(Me, "hoverCard")
    hoverCard.setWidth("w-full")
    hoverCard.setHeight("h-auto")
    hoverCard.AddToParent(pnlHost, PAGE_PAD, y, cardW, 236dip)
    hoverCard.setContentType("custom")
    hoverCard.setPadding("p-[15px]")
    hoverCard.setContentBackgroundColor(xui.Color_Black)
    hoverCard.setContentRounded("rounded-2xl")
    hoverCard.setContentPadding("p-[15px]")
    hoverCard.ScaleOnHover = 1.05
    hoverCard.MaxTilt = 10
    hoverCard.Refresh

    Dim cardHost As B4XView = hoverCard.ContentPanel
    Dim contentW As Int = Max(1dip, cardHost.Width)
    cardHost.Color = xui.Color_Transparent

    Dim glowA As B4XView = xui.CreatePanel("")
    glowA.SetColorAndBorder(xui.Color_ARGB(10, 255, 255, 255), 0, xui.Color_Transparent, 999dip)
    glowA.Tag = "ignore-auto-height"
    cardHost.AddView(glowA, -40dip, 126dip, 150dip, 150dip)

    Dim glowB As B4XView = xui.CreatePanel("")
    glowB.SetColorAndBorder(xui.Color_ARGB(10, 255, 255, 255), 0, xui.Color_Transparent, 999dip)
    glowB.Tag = "ignore-auto-height"
    cardHost.AddView(glowB, contentW - 110dip, -34dip, 150dip, 150dip)

    Dim lblBank As Label
    lblBank.Initialize("")
    Dim xlblBank As B4XView = lblBank
    xlblBank.Text = "BANK OF LATVERIA"
    xlblBank.TextSize = 13
    xlblBank.TextColor = xui.Color_White
    xlblBank.Font = xui.CreateDefaultBoldFont(xlblBank.TextSize)
    cardHost.AddView(xlblBank, 0, 0, 180dip, 24dip)

    Dim lblGlyph As Label
    lblGlyph.Initialize("")
    Dim xlblGlyph As B4XView = lblGlyph
    xlblGlyph.Text = "*"
    xlblGlyph.TextSize = 38
    xlblGlyph.TextColor = xui.Color_ARGB(30, 255, 255, 255)
    cardHost.AddView(xlblGlyph, contentW - 46dip, -2dip, 36dip, 40dip)

    Dim lblNumber As Label
    lblNumber.Initialize("")
    Dim xlblNumber As B4XView = lblNumber
    xlblNumber.Text = "0210 8820 1150 0222"
    xlblNumber.TextSize = 18
    xlblNumber.TextColor = xui.Color_ARGB(120, 255, 255, 255)
    cardHost.AddView(xlblNumber, 0, 92dip, contentW - 32dip, 30dip)

    Dim lblHolderCaption As Label
    lblHolderCaption.Initialize("")
    Dim xlblHolderCaption As B4XView = lblHolderCaption
    xlblHolderCaption.Text = "CARD HOLDER"
    xlblHolderCaption.TextSize = 11
    xlblHolderCaption.TextColor = xui.Color_ARGB(52, 255, 255, 255)
    cardHost.AddView(xlblHolderCaption, 0, 148dip, 110dip, 18dip)

    Dim lblHolder As Label
    lblHolder.Initialize("")
    Dim xlblHolder As B4XView = lblHolder
    xlblHolder.Text = "VICTOR VON D."
    xlblHolder.TextSize = 13
    xlblHolder.TextColor = xui.Color_White
    cardHost.AddView(xlblHolder, 0, 168dip, 150dip, 22dip)

    Dim lblExpiresCaption As Label
    lblExpiresCaption.Initialize("")
    Dim xlblExpiresCaption As B4XView = lblExpiresCaption
    xlblExpiresCaption.Text = "EXPIRES"
    xlblExpiresCaption.TextSize = 11
    xlblExpiresCaption.TextColor = xui.Color_ARGB(52, 255, 255, 255)
    cardHost.AddView(xlblExpiresCaption, contentW - 94dip, 148dip, 80dip, 18dip)

    Dim lblExpires As Label
    lblExpires.Initialize("")
    Dim xlblExpires As B4XView = lblExpires
    xlblExpires.Text = "29/08"
    xlblExpires.TextSize = 13
    xlblExpires.TextColor = xui.Color_White
    cardHost.AddView(xlblExpires, contentW - 94dip, 168dip, 80dip, 22dip)
    hoverCard.Refresh
    y = y + hoverCard.GetComputedHeight + 26dip

    ''' <summary>
    ''' Example 3: 3D image gallery hover effect.
    ''' </summary>
    y = AddSectionTitle("3D hover effect for image gallery", y, maxW)
    y = AddSectionNote("Three passive image cards show the same hover container reused in a gallery layout.", y, maxW)

    Dim galleryGap As Int = 16dip
    Dim galleryW As Int = Min(220dip, maxW)
    Dim galleryH As Int = 146dip
    Dim galleryRowFits As Boolean = (maxW >= ((galleryW * 3) + (galleryGap * 2)))
    Dim galleryLeft As Int = PAGE_PAD

    If galleryRowFits Then
        galleryLeft = PAGE_PAD + Max(0, (maxW - ((galleryW * 3) + (galleryGap * 2))) / 2)
        y = AddGalleryItem(galleryLeft, y, galleryW, galleryH, "card-1.webp", "galleryOne")
        y = AddGalleryItem(galleryLeft + galleryW + galleryGap, y - galleryH, galleryW, galleryH, "card-2.webp", "galleryTwo")
        y = AddGalleryItem(galleryLeft + ((galleryW + galleryGap) * 2), y - galleryH, galleryW, galleryH, "card-3.webp", "galleryThree")
        y = y + 22dip
    Else
        y = AddGalleryItem(PAGE_PAD, y, maxW, 180dip, "card-1.webp", "galleryOne")
        y = AddGalleryItem(PAGE_PAD, y, maxW, 180dip, "card-2.webp", "galleryTwo")
        y = AddGalleryItem(PAGE_PAD, y, maxW, 180dip, "card-3.webp", "galleryThree")
    End If

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Adds a demo section title.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 30dip)
    title.Text = Text
    title.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59))
    title.TextSize = 18
    title.FontBold = True
    Return Y + title.GetComputedHeight + 4dip
End Sub

''' <summary>
''' Adds a small descriptive note below a section title.
''' </summary>
Private Sub AddSectionNote(Text As String, Y As Int, Width As Int) As Int
    Dim note As B4XDaisyText
    note.Initialize(Me, "")
    note.AddToParent(pnlHost, PAGE_PAD, Y, Width, 38dip)
    note.Text = Text
    note.TextColor = B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59)), 170)
    note.TextSize = 12
    Return Y + note.GetComputedHeight + 5dip
End Sub

''' <summary>
''' Adds one passive gallery item using the hover host.
''' </summary>
Private Sub AddGalleryItem(Left As Int, Top As Int, Width As Int, Height As Int, AssetName As String, EventName As String) As Int
    Dim hoverItem As B4XDaisyHover3d
    hoverItem.Initialize(Me, EventName)
    hoverItem.AddToParent(pnlHost, Left, Top, Width, Height)
    hoverItem.Rounded = "rounded-2xl"
    hoverItem.Padding = "p-[15px]"
    hoverItem.setWidth("w-full")
    hoverItem.setHeight("h-[400px]")
    hoverItem.setContentType("image")
    hoverItem.setImage(AssetName)
    hoverItem.Refresh
    Return Top + hoverItem.GetComputedHeight + 16dip
End Sub
#End Region

#Region Base Events
''' <summary>
''' Resizes the page and rebuilds the examples.
''' </summary>
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then
        svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
    RenderExamples(Width, Height)
End Sub

''' <summary>
''' Signals dashboard readiness when the page appears.
''' </summary>
Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub hoverImage_Click(Tag As Object)
    'Log("hover image clicked")
End Sub

Private Sub hoverCard_Click(Tag As Object)
    'Log("hover card clicked")
End Sub

Private Sub galleryOne_Click(Tag As Object)
    'Log("gallery item 1 clicked")
End Sub

Private Sub galleryTwo_Click(Tag As Object)
    'Log("gallery item 2 clicked")
End Sub

Private Sub galleryThree_Click(Tag As Object)
    'Log("gallery item 3 clicked")
End Sub
#End Region
