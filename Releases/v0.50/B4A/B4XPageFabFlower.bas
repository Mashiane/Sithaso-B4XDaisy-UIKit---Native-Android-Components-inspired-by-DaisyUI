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
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(244, 248, 244)
    B4XPages.SetTitle(Me, "Fab Flower")

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
        pnlInfo.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(214, 223, 214), 18dip)

        lblTitle.Initialize("")
        lblTitle.Text = "Fab Flower"
        lblTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblTitle.TextSize = 20
        lblTitle.Typeface = Typeface.DEFAULT_BOLD
        pnlInfo.AddView(lblTitle, 0, 0, 0, 0)

        lblBody.Initialize("")
        lblBody.Text = "The flower layout keeps the radial spread while the trigger sits at the bottom-right. Use this page to isolate the flower pattern."
        lblBody.TextColor = xui.Color_RGB(71, 85, 105)
        lblBody.TextSize = 14
        pnlInfo.AddView(lblBody, 0, 0, 0, 0)
    End If

    If fab.IsInitialized = False Then
        fab.Initialize(Me, "fabflower")
        fab.Tag = "flower-fab"
        fab.LayoutMode = "flower"
        fab.Placement = "bottom-end"
        fab.TriggerText = ""
        fab.TriggerIconName = "plus-solid.svg"
        fab.TriggerVariant = "success"
        fab.UseCloseAction = True
        fab.CloseActionText = ""
        fab.CloseActionVariant = "error"
        fab.CloseActionIconName = "xmark-solid.svg"
        fab.AddAction("camera", "neutral", "camera-solid.svg")
        fab.AddAction("notify", "warning", "bell-solid.svg")
        fab.AddAction("share", "info", "upload-solid.svg")
        fab.AddAction("duplicate", "secondary", "copy-solid.svg")
        fab.AddToParent(Root, 0, 0, 56dip, 56dip)
    End If
End Sub

Private Sub LayoutPage(Width As Int, Height As Int)
    If pnlInfo.IsInitialized Then
        pnlInfo.SetLayoutAnimated(0, 16dip, 16dip, Max(220dip, Width - 32dip), 148dip)
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
Private Sub fabflower_Click(Tag As Object)
End Sub

Private Sub fabflower_ActionClick(Index As Int, Tag As Object)
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
