B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=2.00
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private List1K As B4XDaisyList
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    BuildList(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
Private Sub BuildList(Width As Int, Height As Int)
    List1K.Clear
    List1K.Initialize(Me, "List1K")
    List1K.Rounded = "rounded-box"
    List1K.Shadow = "shadow-md"
    List1K.BackgroundColor = "base-100"
    List1K.Padding = 0
    List1K.RowPadding = 16dip
    List1K.Divider = True
    List1K.DividerColor = "base-content/5"
    List1K.RowHeight = 72dip
    List1K.AddToParent(Root, 0, 0, Width, Height)

    List1K.RegisterTemplate("simple", Me, "Template_SimpleRow")

    Dim batch As List
    batch.Initialize
    For i = 0 To 999
        batch.Add(CreateMap("Tag": i, "index": i, "_height": 72, "title": "Row " & (i + 1), "subtitle": "This is row number " & (i + 1) & " of 1000", "_template": "simple"))
    Next
    List1K.AddRowDataBatch(batch)
End Sub
#End Region

#Region Templates
Private Sub Template_SimpleRow(Index As Int)
    Dim Panel As B4XView = List1K.GetCurrentRowPanel
    Dim Data As Map = List1K.GetCurrentRowData
    If Panel = Null Or Panel.IsInitialized = False Or Data = Null Or Data.IsInitialized = False Then Return

    Dim w As Int = Panel.Width
    Dim h As Int = Panel.Height

    Dim idx As Int = Data.GetDefault("index", 0)
    Dim title As String = Data.GetDefault("title", "Row " & idx)
    Dim subtitle As String = Data.GetDefault("subtitle", "")

    ' Row number
    Dim lblNum As Label
    lblNum.Initialize("")
    lblNum.Text = NumberFormat(idx + 1, 1, 0)
    lblNum.TextSize = 12
    lblNum.TextColor = xui.Color_ARGB(80, 0, 0, 0)
    lblNum.Gravity = Gravity.CENTER
    lblNum.Typeface = Typeface.MONOSPACE
    Panel.AddView(lblNum, 8dip, 8dip, 36dip, h - 16dip)

    ' Title
    Dim lblTitle As Label
    lblTitle.Initialize("")
    lblTitle.Text = title
    lblTitle.TextSize = 14
    lblTitle.TextColor = xui.Color_RGB(17, 24, 39)
    lblTitle.Gravity = Bit.Or(Gravity.LEFT, Gravity.BOTTOM)
    lblTitle.SingleLine = True
    Panel.AddView(lblTitle, 48dip, 4dip, Max(1dip, w - 60dip), (h / 2) - 2dip)

    ' Subtitle
    Dim lblSub As Label
    lblSub.Initialize("")
    lblSub.Text = subtitle
    lblSub.TextSize = 11
    lblSub.TextColor = xui.Color_ARGB(140, 0, 0, 0)
    lblSub.Gravity = Bit.Or(Gravity.LEFT, Gravity.TOP)
    lblSub.SingleLine = True
    Panel.AddView(lblSub, 48dip, h / 2, Max(1dip, w - 60dip), (h / 2) - 4dip)
End Sub
#End Region

#Region BaseEvents
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    BuildList(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Events
Private Sub List1K_ItemClick(Index As Int, Tag As Object)
    B4XPages.MainPage.ShowToast("List1K: Row " & (Index + 1), False)
End Sub
#End Region
