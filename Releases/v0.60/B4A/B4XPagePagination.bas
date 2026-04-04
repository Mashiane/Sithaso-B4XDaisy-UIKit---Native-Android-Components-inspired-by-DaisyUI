B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12
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
''' Initializes the Pagination demo page.
''' </summary>
Public Sub Initialize As Object
    Return Me
End Sub

''' <summary>
''' B4XPage Created event.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
    Try
        Root = Root1
        If Root.IsInitialized = False Then Return
        Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
        B4XPages.SetTitle(Me, "Pagination")

        svHost.Initialize(Max(1dip, Root.Height))
        Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
        pnlHost = svHost.Panel
        pnlHost.Color = xui.Color_Transparent

        RenderExamples(Root.Width, Root.Height)
    Catch
        ' Ignore errors
    End Try
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI Pagination examples.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Min(Max(240dip, Width - (PAGE_PAD * 2)), 384dip)
    Dim contentLeft As Int = Max(PAGE_PAD, (Width - maxW) / 2)
    Dim currentY As Int = PAGE_PAD

    ''' <summary>
    ''' Example 1: Pagination with an active button
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "1. Pagination with an active button")
    currentY = AddDescription(contentLeft, currentY, maxW, "A join group with 4 buttons, where button 2 is active.")
    
    ' Add pagination directly to pnlHost with explicit dimensions (bypass card/host structure)
    Dim pag1 As B4XDaisyPagination
    pag1.Initialize(Me, "pag1")
    pag1.Size = "md"
    pag1.ShowPrevNext = False
    pag1.PageCount = 4
    pag1.ActiveIndex = 1
    pag1.AddToParent(pnlHost, contentLeft, currentY, maxW, 64dip)
    currentY = currentY + 64dip + 18dip

    ''' <summary>
    ''' Example 2: Sizes
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "2. Sizes")
    currentY = AddDescription(contentLeft, currentY, maxW, "Pagination at xs, sm, md, lg, and xl button sizes.")
    
    ' XS
    currentY = currentY + 8dip
    Dim pagXs As B4XDaisyPagination
    pagXs.Initialize(Me, "pagXs")
    pagXs.Size = "xs"
    pagXs.ShowPrevNext = False
    pagXs.PageCount = 4
    pagXs.ActiveIndex = 1
    pagXs.AddToParent(pnlHost, contentLeft, currentY, maxW, 24dip)
    currentY = currentY + 32dip
    
    ' SM
    currentY = currentY + 8dip
    Dim pagSm As B4XDaisyPagination
    pagSm.Initialize(Me, "pagSm")
    pagSm.Size = "sm"
    pagSm.ShowPrevNext = False
    pagSm.PageCount = 4
    pagSm.ActiveIndex = 1
    pagSm.AddToParent(pnlHost, contentLeft, currentY, maxW, 32dip)
    currentY = currentY + 40dip
    
    ' MD
    currentY = currentY + 8dip
    Dim pagMd As B4XDaisyPagination
    pagMd.Initialize(Me, "pagMd")
    pagMd.Size = "md"
    pagMd.ShowPrevNext = False
    pagMd.PageCount = 4
    pagMd.ActiveIndex = 1
    pagMd.AddToParent(pnlHost, contentLeft, currentY, maxW, 40dip)
    currentY = currentY + 48dip
    
    ' LG
    currentY = currentY + 8dip
    Dim pagLg As B4XDaisyPagination
    pagLg.Initialize(Me, "pagLg")
    pagLg.Size = "lg"
    pagLg.ShowPrevNext = False
    pagLg.PageCount = 4
    pagLg.ActiveIndex = 1
    pagLg.AddToParent(pnlHost, contentLeft, currentY, maxW, 48dip)
    currentY = currentY + 56dip
    
    ' XL
    currentY = currentY + 8dip
    Dim pagXl As B4XDaisyPagination
    pagXl.Initialize(Me, "pagXl")
    pagXl.Size = "xl"
    pagXl.ShowPrevNext = False
    pagXl.PageCount = 4
    pagXl.ActiveIndex = 1
    pagXl.AddToParent(pnlHost, contentLeft, currentY, maxW, 56dip)
    currentY = currentY + 64dip + PAGE_PAD

    ''' <summary>
    ''' Example 3: With a disabled button
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "3. With a disabled button")
    currentY = AddDescription(contentLeft, currentY, maxW, "A pagination group with page 3 button disabled.")
    Dim pag3 As B4XDaisyPagination
    pag3.Initialize(Me, "pag3")
    pag3.Size = "md"
    pag3.ShowPrevNext = False
    pag3.PageCount = 5
    pag3.ActiveIndex = 0
    pag3.AddToParent(pnlHost, contentLeft, currentY, maxW, 64dip)
    pag3.SetItemDisabled("page-3", True)
    currentY = currentY + 64dip + 18dip

    ''' <summary>
    ''' Example 4: Interactive demo with page counter
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "4. Interactive pagination")
    currentY = AddDescription(contentLeft, currentY, maxW, "Click the buttons to navigate. Current page is highlighted.")
    Dim pag4 As B4XDaisyPagination
    pag4.Initialize(Me, "pag4")
    pag4.Size = "md"
    pag4.ShowPrevNext = True
    pag4.ShowPageNumbers = True
    pag4.PageCount = 5
    pag4.ActiveIndex = 0
    pag4.AddToParent(pnlHost, contentLeft, currentY, maxW, 64dip)
    currentY = currentY + 64dip + 4dip
    ' Add a label showing current page
    Dim lblPage As B4XDaisyText
    lblPage.Initialize(Me, "lblPageInfo")
    lblPage.AddToParent(pnlHost, contentLeft, currentY, maxW, 24dip)
    lblPage.Text = "Current page: 1"
    lblPage.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(100, 116, 139))
    lblPage.TextSize = 12
    lblPage.SetTextAlignment("CENTER", "CENTER")
    currentY = currentY + 24dip + PAGE_PAD

    ''' <summary>
    ''' Example 5: With First/Last buttons
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "5. With First/Last buttons")
    currentY = AddDescription(contentLeft, currentY, maxW, "Pagination with first/last navigation using double-chevron icons.")
    Dim pag5 As B4XDaisyPagination
    pag5.Initialize(Me, "pag5")
    pag5.Size = "md"
    pag5.ShowPrevNext = True
    pag5.ShowFirstLast = True
    pag5.ShowPageNumbers = True
    pag5.PageCount = 3
    pag5.ActiveIndex = 0
    pag5.AddToParent(pnlHost, contentLeft, currentY, maxW, 64dip)
    currentY = currentY + 64dip + 18dip

    ''' <summary>
    ''' Example 6: Shadow variants
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "6. Shadow variants")
    currentY = AddDescription(contentLeft, currentY, maxW, "Pagination buttons with different shadow styles.")
    
    ' No shadow (default)
    currentY = currentY + 8dip
    Dim pagNoShadow As B4XDaisyPagination
    pagNoShadow.Initialize(Me, "pagNoShadow")
    pagNoShadow.Size = "sm"
    pagNoShadow.ShowPrevNext = True
    pagNoShadow.ShowPageNumbers = False
    pagNoShadow.Shadow = "none"
    pagNoShadow.AddToParent(pnlHost, contentLeft, currentY, maxW, 48dip)
    currentY = currentY + 56dip
    
    ' Small shadow
    currentY = currentY + 8dip
    Dim pagShadowSm As B4XDaisyPagination
    pagShadowSm.Initialize(Me, "pagShadowSm")
    pagShadowSm.Size = "sm"
    pagShadowSm.ShowPrevNext = True
    pagShadowSm.ShowPageNumbers = False
    pagShadowSm.Shadow = "sm"
    pagShadowSm.AddToParent(pnlHost, contentLeft, currentY, maxW, 48dip)
    currentY = currentY + 56dip
    
    ' Medium shadow
    currentY = currentY + 8dip
    Dim pagShadowMd As B4XDaisyPagination
    pagShadowMd.Initialize(Me, "pagShadowMd")
    pagShadowMd.Size = "sm"
    pagShadowMd.ShowPrevNext = True
    pagShadowMd.ShowPageNumbers = False
    pagShadowMd.Shadow = "md"
    pagShadowMd.AddToParent(pnlHost, contentLeft, currentY, maxW, 48dip)
    currentY = currentY + 56dip
    
    ' Large shadow
    currentY = currentY + 8dip
    Dim pagShadowLg As B4XDaisyPagination
    pagShadowLg.Initialize(Me, "pagShadowLg")
    pagShadowLg.Size = "sm"
    pagShadowLg.ShowPrevNext = True
    pagShadowLg.ShowPageNumbers = False
    pagShadowLg.Shadow = "lg"
    pagShadowLg.AddToParent(pnlHost, contentLeft, currentY, maxW, 48dip)
    currentY = currentY + 56dip + PAGE_PAD

    pnlHost.Height = Max(Height, currentY)
End Sub

''' <summary>
''' Adds a section title using B4XDaisyText and returns the next Y position.
''' </summary>
Private Sub AddSectionTitle(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "pagTitle")
    title.AddToParent(pnlHost, Left, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59))
    title.TextSize = 16
    title.FontBold = True
    title.AutoResize = True
    Return Y + title.GetComputedHeight + 6dip
End Sub

''' <summary>
''' Adds a description using B4XDaisyText and returns the next Y position.
''' </summary>
Private Sub AddDescription(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim desc As B4XDaisyText
    desc.Initialize(Me, "pagCopy")
    desc.AddToParent(pnlHost, Left, Y, Width, 20dip)
    desc.Text = Text
    desc.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(100, 116, 139))
    desc.TextSize = 12
    desc.SingleLine = False
    desc.AutoResize = True
    Return Y + desc.GetComputedHeight + 10dip
End Sub

''' <summary>
''' Adds the preview card container.
''' </summary>
Private Sub AddPreviewCard(Left As Int, Y As Int, Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim card As B4XView = p
    Dim bg As Int = B4XDaisyVariants.ResolveBackgroundColorVariant("bg-base-300", xui.Color_RGB(229, 231, 235))
    card.SetColorAndBorder(bg, 0, 0, B4XDaisyVariants.GetRadiusBoxDip(16dip))
    pnlHost.AddView(card, Left, Y, Width, Height)
    Return card
End Sub

''' <summary>
''' Adds the bordered bottom host.
''' </summary>
Private Sub AddPreviewHost(Card As B4XView, DockHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    host.SetColorAndBorder(xui.Color_Transparent, 1dip, B4XDaisyVariants.ResolveBorderColorVariant("border-base-300", xui.Color_RGB(203, 213, 225)), 0)
    Card.AddView(host, 0, Card.Height - DockHeight, Card.Width, DockHeight)
    Return host
End Sub

''' <summary>
''' Adds the bordered bottom host with explicit dimensions.
''' </summary>
Private Sub AddPreviewHostWithSize(Card As B4XView, DockHeight As Int, HostWidth As Int, HostHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    host.SetColorAndBorder(xui.Color_Transparent, 1dip, B4XDaisyVariants.ResolveBorderColorVariant("border-base-300", xui.Color_RGB(203, 213, 225)), 0)
    Card.AddView(host, 0, Card.Height - DockHeight, HostWidth, HostHeight)
    Return host
End Sub
#End Region

#Region Layout Helpers
Private Sub Base_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub
#End Region

#Region Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    Base_Resize(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub pag1_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination", PageIndex, ItemId)
End Sub

Private Sub pagXs_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination XS", PageIndex, ItemId)
End Sub

Private Sub pagSm_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination SM", PageIndex, ItemId)
End Sub

Private Sub pagMd_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination MD", PageIndex, ItemId)
End Sub

Private Sub pagLg_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination LG", PageIndex, ItemId)
End Sub

Private Sub pagXl_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination XL", PageIndex, ItemId)
End Sub

Private Sub pag3_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Disabled", PageIndex, ItemId)
End Sub

Private Sub pag4_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Interactive", PageIndex, ItemId)
End Sub

Private Sub pag5_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination First/Last", PageIndex, ItemId)
End Sub

Private Sub pagNoShadow_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination No Shadow", PageIndex, ItemId)
End Sub

Private Sub pagShadowSm_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Shadow SM", PageIndex, ItemId)
End Sub

Private Sub pagShadowMd_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Shadow MD", PageIndex, ItemId)
End Sub

Private Sub pagShadowLg_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Shadow LG", PageIndex, ItemId)
End Sub

Private Sub pagRoundedFull_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Rounded Full", PageIndex, ItemId)
End Sub

Private Sub pagRoundedMd_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Rounded MD", PageIndex, ItemId)
End Sub

Private Sub pagRoundedNone_PageChanged(PageIndex As Int, ItemId As String)
    ShowPageClick("Pagination Rounded None", PageIndex, ItemId)
End Sub

Private Sub ShowPageClick(ExampleName As String, PageIndex As Int, ItemId As String)
    #If B4A
    Try
        ToastMessageShow(ExampleName & ": Page " & (PageIndex + 1) & " (" & ItemId & ")", False)
    Catch
        ' Ignore errors
    End Try
    #End If
End Sub
#End Region
