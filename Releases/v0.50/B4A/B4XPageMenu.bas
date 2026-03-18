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
    Private Const PAGE_PAD As Int = 12dip
    Private Const SECTION_GAP As Int = 18dip
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    B4XPages.SetTitle(Me, "Menu")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    BuildExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    BuildExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub BuildExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(280dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    y = ExampleMenu(y, maxW)
    y = ExampleResponsive(y, maxW, Width)
    y = ExampleIconOnly(y, maxW)
    y = ExampleIconOnlyHorizontal(y, maxW)
    y = ExampleMenuSizes(y, maxW)
    y = ExampleDisabled(y, maxW)
    y = ExampleIcons(y, maxW)
    y = ExampleIconsBadgesResponsive(y, maxW, Width)
    y = ExampleNoPaddingRadius(y, maxW)
    y = ExampleTitle(y, maxW)
    y = ExampleTitleAsParent(y, maxW)
    y = ExampleSubmenu(y, maxW)
    y = ExampleCollapsible(y, maxW)
    y = ExampleFileTree(y, maxW)
    y = ExampleActive(y, maxW)
    y = ExampleHorizontal(y, maxW)
    y = ExampleHorizontalSubmenu(y, maxW)
    y = ExampleMegaMenu(y, maxW, Width)
    y = ExampleResponsiveCollapsible(y, maxW, Width)
    y = ExampleActiveBorder(y, maxW)
    y = ExampleScrollableFixedHeight(y, maxW)

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub ExampleMenu(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-basic", "vertical", "md")
    menu.AddItem("menu-item-1", "Item 1")
    menu.AddItem("menu-item-2", "Item 2")
    menu.AddItem("menu-item-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleResponsive(Y As Int, Width As Int, ViewWidth As Int) As Int
    Y = AddSectionTitle("Responsive: vertical on small screen, horizontal on large screen", Y, Width)
    Y = AddSectionNote("This demo switches orientation based on page width to approximate the Daisy responsive example.", Y, Width)
    Dim orientation As String = IIf(ViewWidth >= 720dip, "horizontal", "vertical")
    Dim menu As B4XDaisyMenu = CreateMenu("menu-responsive", orientation, "md")
    menu.AddItem("responsive-item-1", "Item 1")
    menu.AddItem("responsive-item-2", "Item 2")
    menu.AddItem("responsive-item-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleIconOnly(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with icon only", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-icon-only", "vertical", "md")
    menu.AddIconItem("icon-home", "", "house-solid.svg")
    menu.AddIconItem("icon-details", "", "circle-info-solid.svg")
    menu.AddIconItem("icon-stats", "", "table-cells-solid.svg")
    Return AddMenuBlock(menu, Y, menu.GetPreferredWidth)
End Sub

Private Sub ExampleIconOnlyHorizontal(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with icon only (horizontal)", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-icon-only-horizontal", "horizontal", "md")
    menu.AddIconItem("icon-horizontal-home", "", "house-solid.svg")
    menu.AddIconItem("icon-horizontal-details", "", "circle-info-solid.svg")
    menu.AddIconItem("icon-horizontal-stats", "", "table-cells-solid.svg")
    Return AddMenuBlock(menu, Y, menu.GetPreferredWidth)
End Sub

Private Sub ExampleMenuSizes(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu sizes", Y, Width)
    Dim names() As String = Array As String("xs", "sm", "md", "lg", "xl")
    For Each s As String In names
        Dim menu As B4XDaisyMenu = CreateMenu("menu-size-" & s, "vertical", s)
        menu.AddItem(s & "-1", s.ToUpperCase & " 1")
        menu.AddItem(s & "-2", s.ToUpperCase & " 2")
        Y = AddMenuBlock(menu, Y, Width)
    Next
    Return Y
End Sub

Private Sub ExampleDisabled(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with disabled items", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-disabled", "vertical", "md")
    menu.AddItem("enabled", "Enabled item")
    Dim i1 As Int = menu.AddItem("disabled-button", "disabled item")
    menu.SetItemDisabled(i1, True)
    Dim i2 As Int = menu.AddItem("disabled-link", "disabled item")
    menu.SetItemDisabled(i2, True)
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleIcons(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with icons", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-icons", "vertical", "md")
    menu.AddIconItem("icons-home", "Home", "house-solid.svg")
    menu.AddIconItem("icons-details", "Details", "circle-info-solid.svg")
    menu.AddIconItem("icons-stats", "Stats", "table-cells-solid.svg")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleIconsBadgesResponsive(Y As Int, Width As Int, ViewWidth As Int) As Int
    Y = AddSectionTitle("Menu with icons and badge (responsive)", Y, Width)
    Dim orientation As String = IIf(ViewWidth >= 720dip, "horizontal", "vertical")
    Dim menu As B4XDaisyMenu = CreateMenu("menu-icons-badges", orientation, "md")
    menu.AddIconBadgeItem("Inbox", "Inbox", "inbox.svg", "99+", "neutral")
    menu.AddIconBadgeItem("Updates", "Updates", "circle-info-solid.svg", "NEW", "warning")
    menu.AddBadgeItem("Stats", "Stats", "", "info")
    menu.SetItemBadgeText("Inbox", "120")
    menu.SetItemBadgeBackgroundColor("Updates", xui.Color_RGB(249, 115, 22))
    menu.SetItemBadgeTextColor("Updates", xui.Color_White)
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleNoPaddingRadius(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu without padding and border radius", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-no-padding-radius", "vertical", "md")
    menu.Padding = "p-0"
    menu.Rounded = "rounded-none"
    menu.RoundedBox = False
    menu.AddItem("no-pad-1", "Item 1")
    menu.AddItem("no-pad-2", "Item 2")
    menu.AddItem("no-pad-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleTitle(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with title", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-title", "vertical", "md")
    menu.AddTitle("Title")
    menu.AddItem("title-item-1", "Item 1")
    menu.AddItem("title-item-2", "Item 2")
    menu.AddItem("title-item-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleTitleAsParent(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with title as a parent", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-title-parent", "vertical", "md")
    Dim titleParent As B4XDaisyMenu = menu.AddSubmenu("title-parent", "Title", True)
    titleParent.AddItem("title-parent-1", "Item 1")
    titleParent.AddItem("title-parent-2", "Item 2")
    titleParent.AddItem("title-parent-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleSubmenu(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Submenu", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-submenu", "vertical", "md")
    menu.AddItem("submenu-item-1", "Item 1")
    Dim parent As B4XDaisyMenu = menu.AddSubmenu("submenu-parent", "Parent", True)
    parent.AddItem("submenu-1", "Submenu 1")
    parent.AddItem("submenu-2", "Submenu 2")
    Dim deep As B4XDaisyMenu = parent.AddSubmenu("submenu-deep-parent", "Parent", True)
    deep.AddItem("submenu-deep-1", "Submenu 1")
    deep.AddItem("submenu-deep-2", "Submenu 2")
    menu.AddItem("submenu-item-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleCollapsible(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Collapsible submenu", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-collapsible", "vertical", "md")
    menu.AddItem("collapsible-item-1", "Item 1")
    Dim parent As B4XDaisyMenu = menu.AddSubmenu("collapsible-parent", "Parent", True)
    parent.AddItem("collapsible-sub-1", "Submenu 1")
    parent.AddItem("collapsible-sub-2", "Submenu 2")
    Dim deep As B4XDaisyMenu = parent.AddSubmenu("collapsible-deep-parent", "Parent", True)
    deep.AddItem("collapsible-deep-1", "Submenu 1")
    deep.AddItem("collapsible-deep-2", "Submenu 2")
    menu.AddItem("collapsible-item-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleFileTree(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("File tree", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-file-tree", "vertical", "md")
    menu.AddIconItem("resume.pdf", "resume.pdf", "file-lines-solid.svg")
    Dim rootFiles As B4XDaisyMenu = menu.AddSubmenu("my-files", "My Files", True)
    rootFiles.AddIconItem("Project", "Project", "folder-solid.svg")
    Dim images As B4XDaisyMenu = rootFiles.AddSubmenu("Images", "Images", True)
    images.AddIconItem("hero.png", "hero.png", "image-solid.svg")
    images.AddIconItem("logo.png", "logo.png", "image-solid.svg")
    Dim docs As B4XDaisyMenu = rootFiles.AddSubmenu("Documents", "Documents", True)
    docs.AddIconItem("Notes.txt", "Notes.txt", "file-lines-solid.svg")
    docs.AddIconItem("Invoice.pdf", "Invoice.pdf", "file-lines-solid.svg")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleActive(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Menu with active item", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-active", "vertical", "md")
    menu.AddItem("active-item-1", "Item 1")
    Dim activeIndex As Int = menu.AddItem("active-item-2", "Item 2")
    menu.SetItemActive(activeIndex, True)
    menu.AddItem("active-item-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleHorizontal(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Horizontal menu", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-horizontal", "horizontal", "md")
    menu.Dividers = True
    menu.DividerGap = "1"
    menu.AddItem("horizontal-1", "Item 1")
    menu.AddItem("horizontal-2", "Item 2")
    menu.AddItem("horizontal-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleHorizontalSubmenu(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Horizontal submenu", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-horizontal-submenu", "horizontal", "md")
    menu.AddItem("horizontal-submenu-1", "Item 1")
    Dim parent As B4XDaisyMenu = menu.AddSubmenu("horizontal-submenu-parent", "Parent", False)
    parent.AddItem("horizontal-submenu-sub-1", "Submenu 1")
    parent.AddItem("horizontal-submenu-sub-2", "Submenu 2")
    menu.AddItem("horizontal-submenu-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleMegaMenu(Y As Int, Width As Int, ViewWidth As Int) As Int
    Y = AddSectionTitle("Mega menu with submenu (responsive)", Y, Width)
    Dim orientation As String = IIf(ViewWidth >= 900dip, "horizontal", "vertical")
    Dim menu As B4XDaisyMenu = CreateMenu("menu-mega", orientation, "md")
    menu.AddItem("mega-home", "Home")
    Dim parent As B4XDaisyMenu = menu.AddSubmenu("mega-products", "Products", True)
    parent.AddItem("mega-analytics", "Analytics")
    parent.AddItem("mega-payments", "Payments")
    parent.AddItem("mega-security", "Security")
    parent.AddItem("mega-integrations", "Integrations")
    Dim teams As B4XDaisyMenu = menu.AddSubmenu("mega-teams", "Teams", True)
    teams.AddItem("mega-design", "Design")
    teams.AddItem("mega-engineering", "Engineering")
    teams.AddItem("mega-operations", "Operations")
    menu.AddItem("mega-contact", "Contact")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleResponsiveCollapsible(Y As Int, Width As Int, ViewWidth As Int) As Int
    Y = AddSectionTitle("Collapsible with submenu (responsive)", Y, Width)
    Dim orientation As String = IIf(ViewWidth >= 720dip, "horizontal", "vertical")
    Dim menu As B4XDaisyMenu = CreateMenu("menu-responsive-collapsible", orientation, "md")
    menu.AddItem("responsive-collapsible-1", "Item 1")
    Dim parent As B4XDaisyMenu = menu.AddSubmenu("responsive-collapsible-parent", "Parent", True)
    parent.AddItem("responsive-collapsible-sub-1", "Submenu 1")
    parent.AddItem("responsive-collapsible-sub-2", "Submenu 2")
    Dim deep As B4XDaisyMenu = parent.AddSubmenu("responsive-collapsible-deep", "Parent", True)
    deep.AddItem("responsive-collapsible-deep-1", "Submenu 1")
    deep.AddItem("responsive-collapsible-deep-2", "Submenu 2")
    menu.AddItem("responsive-collapsible-3", "Item 3")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleActiveBorder(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Active Border", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-active-border", "vertical", "md")
    menu.ActiveBorder = True
    menu.ActiveColor = xui.Color_RGB(37, 99, 235)
    menu.AddItem("active-border-overview", "Overview")
    Dim borderIndex As Int = menu.AddItem("active-border-security", "Security")
    menu.SetItemActive(borderIndex, True)
    menu.AddItem("active-border-audit", "Audit")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub ExampleScrollableFixedHeight(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Scrollable fixed-height menu", Y, Width)
    Dim menu As B4XDaisyMenu = CreateMenu("menu-scroll-fixed", "vertical", "md")
    menu.setHeight("h-48")
    menu.AddItem("scroll-fixed-1", "Item 1")
    menu.AddItem("scroll-fixed-2", "Item 2")
    menu.AddItem("scroll-fixed-3", "Item 3")
    menu.AddItem("scroll-fixed-4", "Item 4")
    menu.AddItem("scroll-fixed-5", "Item 5")
    menu.AddItem("scroll-fixed-6", "Item 6")
    menu.AddItem("scroll-fixed-7", "Item 7")
    menu.AddItem("scroll-fixed-8", "Item 8")
    menu.AddItem("scroll-fixed-9", "Item 9")
    menu.AddItem("scroll-fixed-10", "Item 10")
    Return AddMenuBlock(menu, Y, Width)
End Sub

Private Sub CreateMenu(TagValue As String, Orientation As String, SizeToken As String) As B4XDaisyMenu
    Dim menu As B4XDaisyMenu
    menu.Initialize(Me, "menu")
    menu.Tag = TagValue
    menu.Orientation = Orientation
    menu.Size = SizeToken
    menu.RoundedBox = True
    menu.Shadow = "none"
    menu.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(248, 247, 251))
    menu.Dividers = True
    menu.DividerGap = "1"
    Return menu
End Sub

Private Sub AddMenuBlock(MenuComp As B4XDaisyMenu, Y As Int, Width As Int) As Int
    Dim menuHeight As Int = MenuComp.GetPreferredHeight
    Dim blockWidth As Int = Width
    If MenuComp.Orientation = "horizontal" Then blockWidth = MenuComp.GetPreferredWidth
    MenuComp.AddToParent(pnlHost, PAGE_PAD, Y, blockWidth, menuHeight)
    Return Y + menuHeight + SECTION_GAP
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = "text-lg"
    title.FontBold = True
    Return Y + title.GetComputedHeight + 2dip
End Sub

Private Sub AddSectionNote(Text As String, Y As Int, Width As Int) As Int
    Dim note As B4XDaisyText
    note.Initialize(Me, "")
    note.AddToParent(pnlHost, PAGE_PAD, Y, Width, 36dip)
    note.Text = Text
    note.TextColor = xui.Color_RGB(100, 116, 139)
    note.TextSize = "text-sm"
    note.SingleLine = False
    Return Y + note.GetComputedHeight + 2dip
End Sub

Private Sub menu_Click(Tag As Object)
    Log("B4XDaisyMenu.Click=" & Tag)
End Sub

Private Sub menu_ItemClick(Tag As Object, Text As String)
    #If B4A
    Dim s As String = Text
    If s.Length = 0 Then s = Tag
    ToastMessageShow("Menu: " & s, False)
    #End If
End Sub
