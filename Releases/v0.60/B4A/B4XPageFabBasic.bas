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
    Private pnlInfo As B4XView
    Private lblTitle As Label
    Private lblBody As Label
    Private fab As B4XDaisyFab
    Private toaster As B4XDaisyToast
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(246, 248, 251)
    B4XPages.SetTitle(Me, "Fab Basic")

    BuildPage
    LayoutPage(Root.Width, Root.Height)
End Sub
#End Region

#Region Layout
Private Sub BuildPage
    If pnlInfo.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        pnlInfo = p
        Root.AddView(pnlInfo, 0, 0, 0, 0)
        pnlInfo.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(224, 230, 237), 18dip)

        lblTitle.Initialize("")
        lblTitle.Text = "Basic FAB"
        lblTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblTitle.TextSize = 20
        lblTitle.Typeface = Typeface.DEFAULT_BOLD
        pnlInfo.AddView(lblTitle, 0, 0, 0, 0)

        lblBody.Initialize("")
        lblBody.Text = "This example uses a plain floating action button only. There are no child actions, no close state, and no overlay."
        lblBody.TextColor = xui.Color_RGB(71, 85, 105)
        lblBody.TextSize = 14
        pnlInfo.AddView(lblBody, 0, 0, 0, 0)
    End If

    If toaster.IsInitialized = False Then
        toaster.Initialize(Me, "toaster")
        toaster.CreateView
        toaster.SetRoot(Root)
        toaster.SetPosition("end", "top")
    End If

    If fab.IsInitialized = False Then
        fab.Initialize(Me, "fabbasic")
        fab.Tag = "basic-fab"
        fab.TriggerText = ""
        fab.TriggerIconName = "plus-solid.svg"
        fab.TriggerVariant = "primary"
        fab.UseCloseAction = False
        fab.Placement = "bottom-end"
        fab.AddToParent(Root, 0, 0, 56dip, 56dip)
    End If
End Sub

Private Sub LayoutPage(Width As Int, Height As Int)
    If pnlInfo.IsInitialized Then
        Dim cardW As Int = Max(220dip, Width - 32dip)
        pnlInfo.SetLayoutAnimated(0, 16dip, 16dip, cardW, 148dip)
        lblTitle.SetLayoutAnimated(0, 16dip, 16dip, pnlInfo.Width - 32dip, 28dip)
        lblBody.SetLayoutAnimated(0, 16dip, 52dip, pnlInfo.Width - 32dip, pnlInfo.Height - 68dip)
    End If

    If fab.IsInitialized Then
        fab.Refresh
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
Private Sub fabbasic_Click(Tag As Object)
    toaster.SuccessWithDuration("FAB tapped!", 2000)
End Sub
#End Region
