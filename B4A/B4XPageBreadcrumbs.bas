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
    B4XPages.SetTitle(Me, "Breadcrumbs")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI breadcrumbs examples in a linear top-to-bottom flow.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Min(Max(240dip, Width - (PAGE_PAD * 2)), 420dip)
    Dim contentLeft As Int = Max(PAGE_PAD, (Width - maxW) / 2)
    Dim currentY As Int = PAGE_PAD

    ''' <summary>
    ''' Example 1: Basic breadcrumbs.
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "1. Basic breadcrumbs")
    currentY = AddDescription(contentLeft, currentY, maxW, "Earlier crumbs are clickable and the final crumb stays passive as the current location.")
    Dim basic As B4XDaisyBreadcrumbs
    basic.Initialize(Me, "crumbs")
    basic.AddToParent(pnlHost, contentLeft, currentY, maxW, 40dip)
    basic.TextSize = "text-sm"
    basic.CurrentIndex = 2
    basic.ClearItems
    basic.AddItem("home", "Home", "", True)
    basic.AddItem("documents", "Documents", "", True)
    basic.AddItem("add-document", "Add Document", "", False)
    basic.getView.SetLayoutAnimated(0, basic.getView.Left, basic.getView.Top, basic.getView.Width, basic.GetComputedHeight)
    currentY = currentY + basic.GetComputedHeight + 18dip

    ''' <summary>
    ''' Example 2: Breadcrumbs with icons.
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "2. Breadcrumbs with icons")
    currentY = AddDescription(contentLeft, currentY, maxW, "Each breadcrumb can include a Daisy-style SVG icon while keeping the same horizontal flow and separator treatment.")
    Dim withIcons As B4XDaisyBreadcrumbs
    withIcons.Initialize(Me, "crumbs")
    withIcons.AddToParent(pnlHost, contentLeft, currentY, maxW, 40dip)
    withIcons.TextSize = "text-sm"
    withIcons.CurrentIndex = 2
    withIcons.ClearItems
    withIcons.AddItem("home-icon", "Home", "breadcrumb-folder.svg", True)
    withIcons.AddItem("documents-icon", "Documents", "breadcrumb-folder.svg", True)
    withIcons.AddItem("add-document-icon", "Add Document", "breadcrumb-document.svg", False)
    withIcons.getView.SetLayoutAnimated(0, withIcons.getView.Left, withIcons.getView.Top, withIcons.getView.Width, withIcons.GetComputedHeight)
    currentY = currentY + withIcons.GetComputedHeight + 18dip

    ''' <summary>
    ''' Example 3: Max-width horizontal scrolling.
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "3. Breadcrumbs with max-width")
    currentY = AddDescription(contentLeft, currentY, maxW, "A narrow container forces the breadcrumb row to scroll horizontally instead of wrapping.")
    Dim narrowW As Int = Min(220dip, maxW)
    Dim scrolling As B4XDaisyBreadcrumbs
    scrolling.Initialize(Me, "crumbs")
    scrolling.AddToParent(pnlHost, contentLeft, currentY, narrowW, 40dip)
    scrolling.TextSize = "text-sm"
    scrolling.CurrentIndex = 4
    scrolling.ClearItems
    scrolling.AddItem("long-1", "Long text 1", "", True)
    scrolling.AddItem("long-2", "Long text 2", "", True)
    scrolling.AddItem("long-3", "Long text 3", "", True)
    scrolling.AddItem("long-4", "Long text 4", "", True)
    scrolling.AddItem("long-5", "Long text 5", "", False)
    scrolling.getView.SetLayoutAnimated(0, scrolling.getView.Left, scrolling.getView.Top, scrolling.getView.Width, scrolling.GetComputedHeight)
    currentY = currentY + scrolling.GetComputedHeight + 18dip

    ''' <summary>
    ''' Example 4: Text size variants.
    ''' </summary>
    currentY = AddSectionTitle(contentLeft, currentY, maxW, "4. Text size variants")
    currentY = AddDescription(contentLeft, currentY, maxW, "The crumb labels, SVG icons, separators, and spacing now scale together with TextSize so each size preset keeps the same overall proportion.")

    currentY = AddDescription(contentLeft, currentY, maxW, "text-sm")
    Dim sizeSm As B4XDaisyBreadcrumbs
    sizeSm.Initialize(Me, "crumbs")
    sizeSm.AddToParent(pnlHost, contentLeft, currentY, maxW, 40dip)
    sizeSm.TextSize = "text-sm"
    sizeSm.CurrentIndex = 2
    sizeSm.ClearItems
    sizeSm.AddItem("size-sm-home", "Home", "breadcrumb-folder.svg", True)
    sizeSm.AddItem("size-sm-library", "Library", "", True)
    sizeSm.AddItem("size-sm-current", "Typography", "breadcrumb-document.svg", False)
    sizeSm.getView.SetLayoutAnimated(0, sizeSm.getView.Left, sizeSm.getView.Top, sizeSm.getView.Width, sizeSm.GetComputedHeight)
    currentY = currentY + sizeSm.GetComputedHeight + 12dip

    currentY = AddDescription(contentLeft, currentY, maxW, "text-base")
    Dim sizeBase As B4XDaisyBreadcrumbs
    sizeBase.Initialize(Me, "crumbs")
    sizeBase.AddToParent(pnlHost, contentLeft, currentY, maxW, 44dip)
    sizeBase.TextSize = "text-base"
    sizeBase.CurrentIndex = 2
    sizeBase.ClearItems
    sizeBase.AddItem("size-base-home", "Home", "breadcrumb-folder.svg", True)
    sizeBase.AddItem("size-base-library", "Library", "", True)
    sizeBase.AddItem("size-base-current", "Typography", "breadcrumb-document.svg", False)
    sizeBase.getView.SetLayoutAnimated(0, sizeBase.getView.Left, sizeBase.getView.Top, sizeBase.getView.Width, sizeBase.GetComputedHeight)
    currentY = currentY + sizeBase.GetComputedHeight + 12dip

    currentY = AddDescription(contentLeft, currentY, maxW, "text-lg")
    Dim sizeLg As B4XDaisyBreadcrumbs
    sizeLg.Initialize(Me, "crumbs")
    sizeLg.AddToParent(pnlHost, contentLeft, currentY, maxW, 48dip)
    sizeLg.TextSize = "text-lg"
    sizeLg.CurrentIndex = 2
    sizeLg.ClearItems
    sizeLg.AddItem("size-lg-home", "Home", "breadcrumb-folder.svg", True)
    sizeLg.AddItem("size-lg-library", "Library", "", True)
    sizeLg.AddItem("size-lg-current", "Typography", "breadcrumb-document.svg", False)
    sizeLg.getView.SetLayoutAnimated(0, sizeLg.getView.Left, sizeLg.getView.Top, sizeLg.getView.Width, sizeLg.GetComputedHeight)
    currentY = currentY + sizeLg.GetComputedHeight + 12dip

    currentY = AddDescription(contentLeft, currentY, maxW, "text-xl")
    Dim sizeXl As B4XDaisyBreadcrumbs
    sizeXl.Initialize(Me, "crumbs")
    sizeXl.AddToParent(pnlHost, contentLeft, currentY, maxW, 52dip)
    sizeXl.TextSize = "text-xl"
    sizeXl.CurrentIndex = 2
    sizeXl.ClearItems
    sizeXl.AddItem("size-xl-home", "Home", "breadcrumb-folder.svg", True)
    sizeXl.AddItem("size-xl-library", "Library", "", True)
    sizeXl.AddItem("size-xl-current", "Typography", "breadcrumb-document.svg", False)
    sizeXl.getView.SetLayoutAnimated(0, sizeXl.getView.Left, sizeXl.getView.Top, sizeXl.getView.Width, sizeXl.GetComputedHeight)
    currentY = currentY + sizeXl.GetComputedHeight + PAGE_PAD

    pnlHost.Height = Max(Height, currentY)
End Sub

''' <summary>
''' Adds a section title and returns the next Y position.
''' </summary>
Private Sub AddSectionTitle(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "crumbTitle")
    title.AddToParent(pnlHost, Left, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59))
    title.TextSize = 16
    title.FontBold = True
    title.AutoResize = True
    Return Y + title.GetComputedHeight + 6dip
End Sub

''' <summary>
''' Adds a short note under each section title and returns the next Y position.
''' </summary>
Private Sub AddDescription(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim note As B4XDaisyText
    note.Initialize(Me, "crumbNote")
    note.AddToParent(pnlHost, Left, Y, Width, 24dip)
    note.Text = Text
    note.TextColor = xui.Color_RGB(100, 116, 139)
    note.TextSize = "text-sm"
    note.AutoResize = True
    Return Y + note.GetComputedHeight + 10dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Appear
    If pnlHost.IsInitialized Then
        If pnlHost.NumberOfViews = 0 Then
            RenderExamples(Root.Width, Root.Height)
        End If
    End If
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub crumbs_ItemClick(ItemId As String)
    #If B4A
    ToastMessageShow("Breadcrumb " & ItemId, False)
    #End If
End Sub
#End Region