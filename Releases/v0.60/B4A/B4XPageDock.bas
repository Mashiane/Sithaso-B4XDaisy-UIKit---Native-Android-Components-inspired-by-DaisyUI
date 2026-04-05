B4A=true
Group=Default Group\DaisyUIKit
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
''' Initializes the Dock demo page.
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
    B4XPages.SetTitle(Me, "Dock")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI Dock examples.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Min(Max(240dip, Width - (PAGE_PAD * 2)), 384dip)
    Dim contentLeft As Int = Max(PAGE_PAD, (Width - maxW) / 2)
    Dim currentY As Int = PAGE_PAD

    ''' <summary>
    ''' Example 1: Dock
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock")
    currentY = AddDescription(contentLeft, currentY, maxW, "Base dock with labels and a centered active item.")
    Dim cardDock As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("md"))
    Dim hostDock As B4XView = AddPreviewDockHost(cardDock, ResolveDockHeightDip("md"), True)
    Dim dockBase As B4XDaisyDock
    dockBase.Initialize(Me, "dockBase")
    dockBase.Size = "md"
    dockBase.ActiveIndex = 1
    dockBase.AddToParent(hostDock, 0, 0, hostDock.Width, 0)
    dockBase.AddItem("home", "Home", "dock-home.svg")
    dockBase.AddItem("inbox", "Inbox", "dock-inbox.svg")
    dockBase.AddItem("settings", "Settings", "dock-settings.svg")
    currentY = currentY + cardDock.Height + 18dip

    ''' <summary>
    ''' Example 2: Dock Extra Small size
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Extra Small size")
    currentY = AddDescription(contentLeft, currentY, maxW, "Extra small dock with icon-only items.")
    Dim cardXs As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("xs"))
    Dim hostXs As B4XView = AddPreviewDockHost(cardXs, ResolveDockHeightDip("xs"), True)
    Dim dockXs As B4XDaisyDock
    dockXs.Initialize(Me, "dockXs")
    dockXs.Size = "xs"
    dockXs.ActiveIndex = 1
    dockXs.AddToParent(hostXs, 0, 0, hostXs.Width, 0)
    dockXs.AddItem("xs-home", "", "dock-home.svg")
    dockXs.AddItem("xs-inbox", "", "dock-inbox.svg")
    dockXs.AddItem("xs-settings", "", "dock-settings.svg")
    currentY = currentY + cardXs.Height + 18dip

    ''' <summary>
    ''' Example 3: Dock Small size
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Small size")
    currentY = AddDescription(contentLeft, currentY, maxW, "Small dock with icon-only items.")
    Dim cardSm As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("sm"))
    Dim hostSm As B4XView = AddPreviewDockHost(cardSm, ResolveDockHeightDip("sm"), True)
    Dim dockSm As B4XDaisyDock
    dockSm.Initialize(Me, "dockSm")
    dockSm.Size = "sm"
    dockSm.ActiveIndex = 1
    dockSm.AddToParent(hostSm, 0, 0, hostSm.Width, 0)
    dockSm.AddItem("sm-home", "", "dock-home.svg")
    dockSm.AddItem("sm-inbox", "", "dock-inbox.svg")
    dockSm.AddItem("sm-settings", "", "dock-settings.svg")
    currentY = currentY + cardSm.Height + 18dip

    ''' <summary>
    ''' Example 4: Dock Medium size
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Medium size")
    currentY = AddDescription(contentLeft, currentY, maxW, "Medium dock with the standard label treatment.")
    Dim cardMd As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("md"))
    Dim hostMd As B4XView = AddPreviewDockHost(cardMd, ResolveDockHeightDip("md"), True)
    Dim dockMd As B4XDaisyDock
    dockMd.Initialize(Me, "dockMd")
    dockMd.Size = "md"
    dockMd.ActiveIndex = 1
    dockMd.AddToParent(hostMd, 0, 0, hostMd.Width, 0)
    dockMd.AddItem("md-home", "Home", "dock-home.svg")
    dockMd.AddItem("md-inbox", "Inbox", "dock-inbox.svg")
    dockMd.AddItem("md-settings", "Settings", "dock-settings.svg")
    currentY = currentY + cardMd.Height + 18dip

    ''' <summary>
    ''' Example 5: Dock Large size
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Large size")
    currentY = AddDescription(contentLeft, currentY, maxW, "Large dock with labels and a lower active indicator.")
    Dim cardLg As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("lg"))
    Dim hostLg As B4XView = AddPreviewDockHost(cardLg, ResolveDockHeightDip("lg"), True)
    Dim dockLg As B4XDaisyDock
    dockLg.Initialize(Me, "dockLg")
    dockLg.Size = "lg"
    dockLg.ActiveIndex = 1
    dockLg.AddToParent(hostLg, 0, 0, hostLg.Width, 0)
    dockLg.AddItem("lg-home", "Home", "dock-home.svg")
    dockLg.AddItem("lg-inbox", "Inbox", "dock-inbox.svg")
    dockLg.AddItem("lg-settings", "Settings", "dock-settings.svg")
    currentY = currentY + cardLg.Height + 18dip

    ''' <summary>
    ''' Example 6: Dock Extra Large size
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Extra Large size")
    currentY = AddDescription(contentLeft, currentY, maxW, "Extra large dock with the biggest label size from the docs.")
    Dim cardXl As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("xl"))
    Dim hostXl As B4XView = AddPreviewDockHost(cardXl, ResolveDockHeightDip("xl"), True)
    Dim dockXl As B4XDaisyDock
    dockXl.Initialize(Me, "dockXl")
    dockXl.Size = "xl"
    dockXl.ActiveIndex = 1
    dockXl.AddToParent(hostXl, 0, 0, hostXl.Width, 0)
    dockXl.AddItem("xl-home", "Home", "dock-home.svg")
    dockXl.AddItem("xl-inbox", "Inbox", "dock-inbox.svg")
    dockXl.AddItem("xl-settings", "Settings", "dock-settings.svg")
    currentY = currentY + cardXl.Height + 18dip

    ''' <summary>
    ''' Example 7: Dock with custom colors
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock with custom colors")
    currentY = AddDescription(contentLeft, currentY, maxW, "Neutral surface with neutral-content text colors.")
    Dim cardNeutral As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("md"))
    Dim hostNeutral As B4XView = AddPreviewDockHost(cardNeutral, ResolveDockHeightDip("md"), False)
    Dim dockNeutral As B4XDaisyDock
    dockNeutral.Initialize(Me, "dockNeutral")
    dockNeutral.Size = "md"
    dockNeutral.ActiveIndex = 1
    dockNeutral.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-neutral", xui.Color_RGB(38, 38, 38))
    dockNeutral.TextColor = B4XDaisyVariants.GetTokenColor("--color-neutral-content", xui.Color_RGB(255, 255, 255))
    dockNeutral.AddToParent(hostNeutral, 0, 0, hostNeutral.Width, 0)
    dockNeutral.AddItem("neutral-home", "Home", "dock-home.svg")
    dockNeutral.AddItem("neutral-inbox", "Inbox", "dock-inbox.svg")
    dockNeutral.AddItem("neutral-settings", "Settings", "dock-settings.svg")
    currentY = currentY + cardNeutral.Height + PAGE_PAD

    ''' <summary>
    ''' Example 8: Dock with disabled items
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock with disabled items")
    currentY = AddDescription(contentLeft, currentY, maxW, "Second item is disabled and appears dimmed with no pointer events.")
    Dim cardDisabled As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("md"))
    Dim hostDisabled As B4XView = AddPreviewDockHost(cardDisabled, ResolveDockHeightDip("md"), True)
    Dim dockDisabled As B4XDaisyDock
    dockDisabled.Initialize(Me, "dockDisabled")
    dockDisabled.Size = "md"
    dockDisabled.ActiveIndex = 0
    dockDisabled.AddToParent(hostDisabled, 0, 0, hostDisabled.Width, 0)
    dockDisabled.AddItem("disabled-home", "Home", "dock-home.svg")
    dockDisabled.AddItem("disabled-inbox", "Inbox", "dock-inbox.svg")
    dockDisabled.AddItem("disabled-settings", "Settings", "dock-settings.svg")
    dockDisabled.SetItemEnabled("disabled-inbox", False)
    currentY = currentY + cardDisabled.Height + 18dip

    ''' <summary>
    ''' Example 9: Dock with all items disabled
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock fully disabled")
    currentY = AddDescription(contentLeft, currentY, maxW, "Entire dock is disabled - no items respond to touch.")
    Dim cardAllDisabled As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("md"))
    Dim hostAllDisabled As B4XView = AddPreviewDockHost(cardAllDisabled, ResolveDockHeightDip("md"), True)
    Dim dockAllDisabled As B4XDaisyDock
    dockAllDisabled.Initialize(Me, "dockAllDisabled")
    dockAllDisabled.Size = "md"
    dockAllDisabled.Enabled = False
    dockAllDisabled.AddToParent(hostAllDisabled, 0, 0, hostAllDisabled.Width, 0)
    dockAllDisabled.AddItem("alldisabled-home", "Home", "dock-home.svg")
    dockAllDisabled.AddItem("alldisabled-inbox", "Inbox", "dock-inbox.svg")
    dockAllDisabled.AddItem("alldisabled-settings", "Settings", "dock-settings.svg")
    currentY = currentY + cardAllDisabled.Height + 18dip

    ''' <summary>
    ''' Example 11: Dock with per-item variant colors
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock with per-item variant colors")
    currentY = AddDescription(contentLeft, currentY, maxW, "Each dock item uses a different semantic variant color for icon, text, and active indicator.")
    Dim cardVariants As B4XView = AddPreviewCard(contentLeft, currentY, maxW, ResolvePreviewHeightDip("md"))
    Dim hostVariants As B4XView = AddPreviewDockHost(cardVariants, ResolveDockHeightDip("md"), True)
    Dim dockVariants As B4XDaisyDock
    dockVariants.Initialize(Me, "dockVariants")
    dockVariants.Size = "md"
    dockVariants.ActiveIndex = 0
    dockVariants.AddToParent(hostVariants, 0, 0, hostVariants.Width, 0)
    dockVariants.AddItemWithVariant("variant-primary", "Primary", "dock-home.svg", "primary")
    dockVariants.AddItemWithVariant("variant-secondary", "Secondary", "dock-inbox.svg", "secondary")
    dockVariants.AddItemWithVariant("variant-accent", "Accent", "dock-settings.svg", "accent")
    dockVariants.AddItemWithVariant("variant-warning", "Warning", "triangle-exclamation-solid.svg", "warning")
    dockVariants.AddItemWithVariant("variant-error", "Error", "circle-xmark-solid.svg", "error")
    currentY = currentY + cardVariants.Height + PAGE_PAD

    ''' <summary>
    ''' Example 12: Dock with different shadow levels
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Shadow Levels")
    currentY = AddDescription(contentLeft, currentY, maxW, "Docks with no shadow, small shadow, and large shadow.")
    
    ' No shadow
    currentY = currentY + 8dip
    Dim dockNoShadow As B4XDaisyDock
    dockNoShadow.Initialize(Me, "dockNoShadow")
    dockNoShadow.Size = "sm"
    dockNoShadow.Shadow = "none"
    dockNoShadow.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dockNoShadow.AddToParent(pnlHost, contentLeft, currentY, maxW, 0)
    dockNoShadow.AddItem("ns-home", "", "dock-home.svg")
    dockNoShadow.AddItem("ns-inbox", "", "dock-inbox.svg")
    dockNoShadow.AddItem("ns-settings", "", "dock-settings.svg")
    currentY = currentY + dockNoShadow.View.Height + 12dip
    
    ' Small shadow
    currentY = currentY + 8dip
    Dim dockSmShadow As B4XDaisyDock
    dockSmShadow.Initialize(Me, "dockSmShadow")
    dockSmShadow.Size = "sm"
    dockSmShadow.Shadow = "sm"
    dockSmShadow.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dockSmShadow.AddToParent(pnlHost, contentLeft, currentY, maxW, 0)
    dockSmShadow.AddItem("ss-home", "", "dock-home.svg")
    dockSmShadow.AddItem("ss-inbox", "", "dock-inbox.svg")
    dockSmShadow.AddItem("ss-settings", "", "dock-settings.svg")
    currentY = currentY + dockSmShadow.View.Height + 12dip
    
    ' Large shadow
    currentY = currentY + 8dip
    Dim dockLgShadow As B4XDaisyDock
    dockLgShadow.Initialize(Me, "dockLgShadow")
    dockLgShadow.Size = "sm"
    dockLgShadow.Shadow = "lg"
    dockLgShadow.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dockLgShadow.AddToParent(pnlHost, contentLeft, currentY, maxW, 0)
    dockLgShadow.AddItem("ls-home", "", "dock-home.svg")
    dockLgShadow.AddItem("ls-inbox", "", "dock-inbox.svg")
    dockLgShadow.AddItem("ls-settings", "", "dock-settings.svg")
    currentY = currentY + dockLgShadow.View.Height + PAGE_PAD

    ''' <summary>
    ''' Example 13: Dock with different rounded styles
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "Dock Rounded Styles")
    currentY = AddDescription(contentLeft, currentY, maxW, "Docks with none, rounded, and full corner radius.")
    
    ' No rounded
    currentY = currentY + 8dip
    Dim dockNoRounded As B4XDaisyDock
    dockNoRounded.Initialize(Me, "dockNoRounded")
    dockNoRounded.Size = "sm"
    dockNoRounded.Rounded = "none"
    dockNoRounded.Shadow = "sm"
    dockNoRounded.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dockNoRounded.AddToParent(pnlHost, contentLeft, currentY, maxW, 0)
    dockNoRounded.AddItem("nr-home", "", "dock-home.svg")
    dockNoRounded.AddItem("nr-inbox", "", "dock-inbox.svg")
    dockNoRounded.AddItem("nr-settings", "", "dock-settings.svg")
    currentY = currentY + dockNoRounded.View.Height + 12dip
    
    ' Rounded
    currentY = currentY + 8dip
    Dim dockRounded As B4XDaisyDock
    dockRounded.Initialize(Me, "dockRounded")
    dockRounded.Size = "sm"
    dockRounded.Rounded = "rounded"
    dockRounded.Shadow = "sm"
    dockRounded.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dockRounded.AddToParent(pnlHost, contentLeft, currentY, maxW, 0)
    dockRounded.AddItem("rd-home", "", "dock-home.svg")
    dockRounded.AddItem("rd-inbox", "", "dock-inbox.svg")
    dockRounded.AddItem("rd-settings", "", "dock-settings.svg")
    currentY = currentY + dockRounded.View.Height + 12dip
    
    ' Full rounded
    currentY = currentY + 8dip
    Dim dockFullRounded As B4XDaisyDock
    dockFullRounded.Initialize(Me, "dockFullRounded")
    dockFullRounded.Size = "sm"
    dockFullRounded.Rounded = "full"
    dockFullRounded.Shadow = "sm"
    dockFullRounded.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dockFullRounded.AddToParent(pnlHost, contentLeft, currentY, maxW, 0)
    dockFullRounded.AddItem("fr-home", "", "dock-home.svg")
    dockFullRounded.AddItem("fr-inbox", "", "dock-inbox.svg")
    dockFullRounded.AddItem("fr-settings", "", "dock-settings.svg")
    currentY = currentY + dockFullRounded.View.Height + PAGE_PAD

    pnlHost.Height = Max(Height, currentY)
End Sub

''' <summary>
''' Adds a section title using B4XDaisyText and returns the next Y position.
''' </summary>
Private Sub AddSectionTitle(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "dockTitle")
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
    desc.Initialize(Me, "dockCopy")
    desc.AddToParent(pnlHost, Left, Y, Width, 20dip)
    desc.Text = Text
    desc.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(100, 116, 139))
    desc.TextSize = 12
    desc.SingleLine = False
    desc.AutoResize = True
    Return Y + desc.GetComputedHeight + 10dip
End Sub

''' <summary>
''' Adds the preview card container that matches the docs examples.
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
''' Adds the bordered bottom host that holds the dock itself.
''' </summary>
Private Sub AddPreviewDockHost(Card As B4XView, DockHeight As Int, ShowBorder As Boolean) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    Dim borderWidth As Int = 0
    If ShowBorder Then borderWidth = 1dip
    Dim borderColor As Int = B4XDaisyVariants.ResolveBorderColorVariant("border-base-300", xui.Color_RGB(203, 213, 225))
    host.SetColorAndBorder(xui.Color_Transparent, borderWidth, borderColor, 0)
    Card.AddView(host, 0, Card.Height - DockHeight, Card.Width, DockHeight)
    Return host
End Sub
#End Region

#Region Layout Helpers
Private Sub ResolveDockHeightDip(SizeToken As String) As Int
    Select Case SizeToken
        Case "xs"
            Return 48dip
        Case "sm"
            Return 56dip
        Case "lg"
            Return 72dip
        Case "xl"
            Return 80dip
        Case Else
            Return 64dip
    End Select
End Sub

Private Sub ResolvePreviewHeightDip(SizeToken As String) As Int
    Return 128dip + ResolveDockHeightDip(SizeToken)
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub dockBase_ItemClick(ItemId As String)
    ShowDockClick("Dock", ItemId)
End Sub

Private Sub dockXs_ItemClick(ItemId As String)
    ShowDockClick("Dock XS", ItemId)
End Sub

Private Sub dockSm_ItemClick(ItemId As String)
    ShowDockClick("Dock SM", ItemId)
End Sub

Private Sub dockMd_ItemClick(ItemId As String)
    ShowDockClick("Dock MD", ItemId)
End Sub

Private Sub dockLg_ItemClick(ItemId As String)
    ShowDockClick("Dock LG", ItemId)
End Sub

Private Sub dockXl_ItemClick(ItemId As String)
    ShowDockClick("Dock XL", ItemId)
End Sub

Private Sub dockNeutral_ItemClick(ItemId As String)
    ShowDockClick("Dock Neutral", ItemId)
End Sub

Private Sub dockDisabled_ItemClick(ItemId As String)
    ShowDockClick("Dock Disabled (item)", ItemId)
End Sub

Private Sub dockAllDisabled_ItemClick(ItemId As String)
    ShowDockClick("Dock All Disabled", ItemId)
End Sub

Private Sub dockVariants_ItemClick(ItemId As String)
    ShowDockClick("Dock Variants", ItemId)
End Sub

Private Sub dockNoShadow_ItemClick(ItemId As String)
    ShowDockClick("Dock No Shadow", ItemId)
End Sub

Private Sub dockSmShadow_ItemClick(ItemId As String)
    ShowDockClick("Dock SM Shadow", ItemId)
End Sub

Private Sub dockLgShadow_ItemClick(ItemId As String)
    ShowDockClick("Dock LG Shadow", ItemId)
End Sub

Private Sub dockNoRounded_ItemClick(ItemId As String)
    ShowDockClick("Dock No Rounded", ItemId)
End Sub

Private Sub dockRounded_ItemClick(ItemId As String)
    ShowDockClick("Dock Rounded", ItemId)
End Sub

Private Sub dockFullRounded_ItemClick(ItemId As String)
    ShowDockClick("Dock Full Rounded", ItemId)
End Sub

Private Sub ShowDockClick(ExampleName As String, ItemId As String)
    #If B4A
    ToastMessageShow(ExampleName & ": " & ItemId, False)
    #End If
End Sub
#End Region
