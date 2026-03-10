B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XPageCarousel.bas
#Region Events
#End Region

#Region Variables
#IgnoreWarnings:12
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Carousel")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

End Sub

Private Sub B4XPage_Appear
	If pnlHost.NumberOfViews = 0 Then
		Wait For (RenderExamples(Root.Width, Root.Height)) Complete  (Done As Boolean)
	End If
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int) As ResumableSub
    If svHost.IsInitialized = False Then Return False
    pnlHost = svHost.Panel
    pnlHost.RemoveAllViews
    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim currentY As Int = PAGE_PAD
    
    ' #region Example 1: Snap to start (default)
    ' DaisyUI: <div class="carousel rounded-box"> � natural image sizes, no gap/padding.
    currentY = AddSectionTitle("Snap to start (default)", currentY, maxW)
    Dim carousel1 As B4XDaisyCarousel
    carousel1.Initialize(Me, "carousel1")
    carousel1.RoundedBox = True
    carousel1.Height = "h-auto"
    carousel1.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 0)
    
    Dim images1() As String = Array As String("photo-1559703248-dcaaec9fab78.webp", _
                                             "photo-1565098772267-60af42b81ef2.webp", _
                                             "photo-1572635148818-ef6fd45eb394.webp", _
                                             "photo-1494253109108-2e30c049369b.webp", _
                                             "photo-1550258987-190a2d41a8ba.webp", _
                                             "photo-1559181567-c3190ca9959b.webp", _
                                             "photo-1601004890684-d8cbf643f5f2.webp")
                                             
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Snap = "start"
        itm.Width = "w-[300px]"
        itm.Height = "h-[400px]"
        carousel1.AddItem(itm)
    Next
    carousel1.Refresh
    currentY = currentY + carousel1.mBase.Height + 24dip
    Sleep(0)
    ' #endregion
    
    ' #region Example 2: Snap to center
    ' DaisyUI: <div class="carousel carousel-center rounded-box"> � natural image sizes.
    currentY = AddSectionTitle("Snap to center", currentY, maxW)
    Dim carousel2 As B4XDaisyCarousel
    carousel2.Initialize(Me, "carousel2")
    carousel2.Snap = "center"
    carousel2.RoundedBox = True
    carousel2.Height = "h-auto"
    carousel2.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 200dip)
    
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Snap = "center"
        itm.Width = "w-[300px]"
        itm.Height = "h-[400px]"
        carousel2.AddItem(itm)
    Next
    carousel2.Refresh
    currentY = currentY + carousel2.mBase.Height + 24dip
    ' #endregion

    ' #region Example 3: Snap to end
    ' DaisyUI: <div class="carousel carousel-end rounded-box"> � natural image sizes.
    currentY = AddSectionTitle("Snap to end", currentY, maxW)
    Dim carousel3 As B4XDaisyCarousel
    carousel3.Initialize(Me, "carousel3")
    carousel3.Snap = "end"
    carousel3.RoundedBox = True
    carousel3.Height = "h-auto"
    carousel3.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 200dip)
    
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Snap = "end"
        itm.Width = "w-[300px]"
        itm.Height = "h-[400px]"
        carousel3.AddItem(itm)
    Next
    carousel3.Refresh
    currentY = currentY + carousel3.mBase.Height + 24dip
    Sleep(0)
    ' #endregion

    ' #region Example 4: Carousel with full width items
    ' DaisyUI: <div class="carousel rounded-box w-64"> with items that are w-full.
    ' The carousel is fixed at w-64 (256dip); each item fills that width entirely.
    currentY = AddSectionTitle("Carousel with full width items", currentY, maxW)
    Dim carousel4 As B4XDaisyCarousel
    carousel4.Initialize(Me, "carousel4")
    carousel4.RoundedBox = True
    carousel4.Width = "w-64"
    carousel4.Height = "h-[341px]"
    carousel4.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 0)
    
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        ' w-full / h-full � each item fills the 256dip carousel exactly.
        itm.Width = "w-full"
        itm.Height = "h-full"
        carousel4.AddItem(itm)
    Next
    carousel4.Refresh
    currentY = currentY + carousel4.mBase.Height + 24dip
    ' #endregion
    
    ' #region Example 5: Vertical carousel
    ' This demonstrates a vertical scrolling carousel.
    ' Height is set to h-96 (384dip) and items fill the container via w-full / h-full.
    currentY = AddSectionTitle("Vertical carousel", currentY, maxW)
    Dim carousel5 As B4XDaisyCarousel
    carousel5.Initialize(Me, "carousel5")
    carousel5.Orientation = "vertical"
    carousel5.RoundedBox = True
    carousel5.Height = "h-96"
    carousel5.Width = "w-64"
    carousel5.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 200dip)
    
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Width = "w-full"
        itm.Height = "h-full"
        carousel5.AddItem(itm)
    Next
    carousel5.Refresh
    currentY = currentY + carousel5.mBase.Height + 24dip
    Sleep(0)
    ' #endregion
    
    ' #region Example 6: Carousel with half width items
    ' DaisyUI: <div class="carousel rounded-box w-96"> with items that are w-1/2.
    ' Carousel is fixed at w-96 (384dip); each item is exactly half that (192dip).
    currentY = AddSectionTitle("Carousel with half width items", currentY, maxW)
    Dim carousel6 As B4XDaisyCarousel
    carousel6.Initialize(Me, "carousel6")
    carousel6.RoundedBox = True
    carousel6.Width = "w-96"
    carousel6.Height = "h-96"
    carousel6.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 200dip)
    
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        ' w-1/2 resolves to 50% of the passed reference width (carousel width).
        itm.Width = "w-1/2"
        itm.Height = "h-full"
        itm.ImageHeight = "h-full"
        itm.ImageWidth = "w-full"
        carousel6.AddItem(itm)
    Next
    carousel6.Refresh
    currentY = currentY + carousel6.mBase.Height + 24dip
    ' #endregion

    ' #region Example 7: Full-bleed carousel
    ' DaisyUI: <div class="carousel carousel-center bg-neutral rounded-box max-w-md space-x-4 p-4">
    ' Dark neutral background, 1rem gap (space-x-4), 1rem padding (p-4), center snap.
    ' Items have no explicit size; the image itself gets rounded-box corners.
    currentY = AddSectionTitle("Full-bleed carousel", currentY, maxW)
    Dim carousel7 As B4XDaisyCarousel
    carousel7.Initialize(Me, "carousel7")
    carousel7.Snap = "center"
    carousel7.RoundedBox = True
    carousel7.Gap = "space-x-4"
    carousel7.Padding = "p-4"
    carousel7.Height = "h-64"
    carousel7.Width = "w-64"
    carousel7.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 220dip)
    carousel7.BackgroundColor = "neutral"
    
    For Each img As String In images1
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Rounded = "rounded-box"  ' each item individually rounded
        carousel7.AddItem(itm)
    Next
    carousel7.Refresh
    currentY = currentY + carousel7.mBase.Height + 24dip
    ' #endregion

    ' #region Example 8: Carousel with indicator buttons
    ' DaisyUI: <div class="carousel w-full"> � NO rounded-box. Full-width items.
    ' Indicator buttons are rendered as a separate row below the carousel.
    currentY = AddSectionTitle("Carousel with indicator buttons", currentY, maxW)
    Dim images8() As String = Array As String("photo-1625726411847-8cbb60cc71e6.webp", _
                                              "photo-1609621838510-5ad474b7d25d.webp", _
                                              "photo-1414694762283-acccc27bca85.webp", _
                                              "photo-1665553365602-b2fb8e5d1707.webp")
    Dim carousel8 As B4XDaisyCarousel
    carousel8.Initialize(Me, "carousel8")
    carousel8.IndicatorButtons = True
    carousel8.Height = "h-[200px]"
    carousel8.Width = "w-full"
    carousel8.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 220dip)
    
    For Each img As String In images8
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Width = "w-full"
        itm.Height = "h-full"
        carousel8.AddItem(itm)
    Next
    carousel8.Refresh
    currentY = currentY + carousel8.mBase.Height + 24dip
    ' #endregion

    ' #region Example 9: Carousel with next/prev navigation buttons
    ' DaisyUI: <div class="carousel w-full"> � NO rounded-box. Full-width items with
    ' prev/next buttons overlaid absolutely on each item.
    currentY = AddSectionTitle("Carousel with next/prev buttons", currentY, maxW)
    Dim carousel9 As B4XDaisyCarousel
    carousel9.Initialize(Me, "carousel9")
    carousel9.NavigationButtons = True
    carousel9.Width = "w-full"
    carousel9.Height = "h-[200px]"
    carousel9.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 220dip)
    
    For Each img As String In images8
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Width = "w-full"
        itm.Height = "h-full"
        carousel9.AddItem(itm)
    Next
    carousel9.Refresh
    currentY = currentY + carousel9.mBase.Height + 24dip
    ' #endregion

    ' #region Example 10: Carousel with both indicator + navigation buttons
    ' Our addition combining both overlays. Consistent with examples 8 & 9 � no rounded-box.
    currentY = AddSectionTitle("Indicators + navigation buttons", currentY, maxW)
    Dim carousel10 As B4XDaisyCarousel
    carousel10.Initialize(Me, "carousel10")
    carousel10.NavigationButtons = True
    carousel10.IndicatorButtons = True
    carousel10.Width = "w-full"
    carousel10.Height = "h-[200px]"
    carousel10.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 220dip)
    
    For Each img As String In images8
        Dim itm As B4XDaisyCarouselItem
        itm.Initialize(Me, "item")
        itm.ItemType = "image"
        itm.Source = img
        itm.Width = "w-full"
        itm.Height = "h-full"
        carousel10.AddItem(itm)
    Next
    carousel10.Refresh
    currentY = currentY + carousel10.mBase.Height + 24dip
    ' #endregion

    ' #region Example 11: Horizontal auto-play carousel
    ' Full-width carousel that automatically advances slides every 2.5 seconds.
    ' Navigation buttons and indicator dots are both enabled.
    currentY = AddSectionTitle("Horizontal auto-play", currentY, maxW)
    Dim carousel11 As B4XDaisyCarousel
    carousel11.Initialize(Me, "carousel11")
    carousel11.Width = "w-full"
    carousel11.Height = "h-[200px]"
    carousel11.NavigationButtons = True
    carousel11.IndicatorButtons = True
    carousel11.AutoPlay = True
    carousel11.AutoPlayInterval = 2500
    carousel11.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 220dip)
    For Each img As String In images8
        Dim itm11 As B4XDaisyCarouselItem
        itm11.Initialize(Me, "item11")
        itm11.ItemType = "image"
        itm11.Source = img
        itm11.Width = "w-full"
        itm11.Height = "h-full"
        carousel11.AddItem(itm11)
    Next
    carousel11.Refresh
    currentY = currentY + carousel11.mBase.Height + 24dip
    ' #endregion

    ' #region Example 12: Vertical auto-play carousel
    ' Narrow portrait-orientation carousel that auto-advances every 2 seconds.
    ' Indicator dots are shown; navigation arrows are omitted for a clean look.
    currentY = AddSectionTitle("Vertical auto-play", currentY, maxW)
    Dim carousel12 As B4XDaisyCarousel
    carousel12.Initialize(Me, "carousel12")
    carousel12.Orientation = "vertical"
    carousel12.Width = "w-full"
    carousel12.Height = "h-[200px]"
    carousel12.IndicatorButtons = True
    carousel12.AutoPlay = True
    carousel12.AutoPlayInterval = 2000
    carousel12.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 320dip)
    For Each img As String In images8
        Dim itm12 As B4XDaisyCarouselItem
        itm12.Initialize(Me, "item12")
        itm12.ItemType = "image"
        itm12.Source = img
        itm12.Width = "w-full"
        itm12.Height = "h-full"
        carousel12.AddItem(itm12)
    Next
    carousel12.Refresh
    currentY = currentY + carousel12.mBase.Height + 24dip
    ' #endregion

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
    Return true
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.setTextColor(xui.Color_RGB(30, 41, 59))
    title.TextSize = "text-lg"
    title.FontBold = True
    Return Y + 48dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub carousel_Click(Tag As Object)
End Sub


#End Region
