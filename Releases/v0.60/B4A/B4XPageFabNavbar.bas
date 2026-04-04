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
    Private Navbar As B4XDaisyNavbar
    Private NavbarView As B4XView
    Private pnlInfo As B4XView
    Private lblTitle As Label
    Private lblBody As Label
    Private fab As B4XDaisyFab
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(244, 247, 251)
    B4XPages.SetTitle(Me, "Fab Navbar")

    BuildPage
    LayoutPage(Root.Width, Root.Height)
End Sub
#End Region

#Region Layout
Private Sub BuildPage
    If NavbarView.IsInitialized = False Then
        Navbar.Initialize(Me, "fabnavnav")
        Navbar.setVariant("primary")
        NavbarView = Navbar.AddToParent(Root, 0, 0, Root.Width, 72dip)
        Navbar.AddTitleToStart("Fab Navbar")
    End If

    If pnlInfo.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        pnlInfo = p
        Root.AddView(pnlInfo, 0, 0, 0, 0)
        pnlInfo.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(219, 226, 235), 18dip)

        lblTitle.Initialize("")
        lblTitle.Text = "Top Right FAB Above Navbar"
        lblTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblTitle.TextSize = 20
        lblTitle.Typeface = Typeface.DEFAULT_BOLD
        pnlInfo.AddView(lblTitle, 0, 0, 0, 0)

        lblBody.Initialize("")
        lblBody.Text = "This FAB sits above the navbar surface and expands downward so the children stay attached to the top action point."
        lblBody.TextColor = xui.Color_RGB(71, 85, 105)
        lblBody.TextSize = 14
        pnlInfo.AddView(lblBody, 0, 0, 0, 0)
    End If

    If fab.IsInitialized = False Then
        fab.Initialize(Me, "fabnav")
        fab.Tag = "navbar-fab"
        fab.PlacementMode = "anchored"
        fab.Direction = "bottom"
        fab.AnchorAlignment = "end"
        fab.OnEdge = True
        fab.TriggerText = ""
        fab.TriggerIconName = "plus-solid.svg"
        fab.TriggerVariant = "secondary"
        fab.UseCloseAction = True
        fab.CloseActionText = ""
        fab.CloseActionVariant = "error"
        fab.CloseActionIconName = "xmark-solid.svg"
        fab.AddAction("camera", "neutral", "camera-solid.svg")
        fab.AddAction("duplicate", "accent", "copy-solid.svg")
        fab.AddAction("share", "info", "upload-solid.svg")
        fab.AnchorView = Navbar.GetEndPanel
        fab.OverlayHost = Root
        fab.AddToParent(Root, 0, 0, 56dip, 56dip)
    End If
End Sub

Private Sub LayoutPage(Width As Int, Height As Int)
    If NavbarView.IsInitialized Then
        NavbarView.SetLayoutAnimated(0, 0, 0, Width, 72dip)
        Navbar.Base_Resize(Width, 72dip)
    End If

    If pnlInfo.IsInitialized Then
        pnlInfo.SetLayoutAnimated(0, 16dip, 96dip, Max(220dip, Width - 32dip), 148dip)
        lblTitle.SetLayoutAnimated(0, 16dip, 16dip, pnlInfo.Width - 32dip, 28dip)
        lblBody.SetLayoutAnimated(0, 16dip, 52dip, pnlInfo.Width - 32dip, pnlInfo.Height - 68dip)
    End If

    If fab.IsInitialized Then
        fab.Refresh
        fab.BringToFront
    End If
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    LayoutPage(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Demo Events
Private Sub fabnav_Click(Tag As Object)
End Sub

Private Sub fabnav_ActionClick(Index As Int, Tag As Object)
    ShowDemoToast("Action " & Index, Tag)
End Sub

Private Sub ShowDemoToast(Kind As String, Tag As Object)
    #If B4A
    Dim s As String = ""
    If Tag <> Null Then s = Tag
    If s.Length = 0 Then s = Kind
    ToastMessageShow(Kind & ": " & s, False)
    #End If
End Sub
#End Region
