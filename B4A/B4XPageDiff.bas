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
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "Diff")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders linear examples generated from Daisy documentation.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim imageHeight As Int = 300dip
    Dim y As Int = PAGE_PAD

    ' #region Example 1: Diff
    y = AddSectionTitle("Diff", y, maxW)
    
    Dim diffimg As B4XDaisyDiff
    diffimg.Initialize(Me, "component")
    diffimg.AddToParent(pnlHost, PAGE_PAD, y, maxW, imageHeight)
    diffimg.Tag = "diff-image"
    diffimg.DiffType = "image"
    diffimg.Height = "h-[300px]"
    diffimg.Image1 = "photo-1560717789-0ac7c58ac90a.webp"
    diffimg.Image2 = "photo-1560717789-0ac7c58ac90a-blur.webp"
    diffimg.Position = 0.5
    
    y = y + imageHeight + 20dip
    ' #endregion

    ' #region Example 2: Diff text
    y = AddSectionTitle("Diff text", y, maxW)
    
    Dim difftext As B4XDaisyDiff
    difftext.Initialize(Me, "component")
    difftext.AddToParent(pnlHost, PAGE_PAD, y, maxW, imageHeight)
    difftext.Tag = "diff-text"
    difftext.DiffType = "text"
    difftext.Height = "h-[300px]"
    difftext.Text1 = "DAISY"
    difftext.Text2 = "DAISY"
    difftext.TextSize = "text-4xl"
    difftext.Text1Color = "primary"
    difftext.Text2Color = "success"
    difftext.Position = 0.4
    
    y = y + imageHeight + 20dip
    ' #endregion

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Spawns a stylized section header for the demo logic.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + 30dip
End Sub
#End Region

#Region Base Events
''' <summary>
''' B4XPage Resize event.
''' </summary>
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

''' <summary>
''' B4XPage Appear event.
''' </summary>
Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub


#End Region
