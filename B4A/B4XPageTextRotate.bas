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
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "TextRotate")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ' #region Example 1: Basic Rotation
    y = AddSectionTitle("Basic Rotation (3 items, 3s)", y, maxW)
    Dim tr1 As B4XDaisyTextRotate
    tr1.Initialize(Me, "tr1")
    tr1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    tr1.setDuration("3s")
    tr1.SetItems(Array As String("Hello", "Beautiful", "World"))
    
    y = y + 50dip
    ' #endregion

    ' #region Example 2: Fast Rotation with Primary Variant
    y = AddSectionTitle("Fast Rotation (2 items, 1s, Primary)", y, maxW)
    Dim tr2 As B4XDaisyTextRotate
    tr2.Initialize(Me, "tr2")
    tr2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    tr2.setDuration("1s")
    tr2.setVariant("primary")
    tr2.SetItems(Array As String("FAST", "ROTATION"))
    
    y = y + 50dip
    ' #endregion

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub ResizeComponents(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    
    ' Reposition existing views
    Dim currentY As Int = PAGE_PAD
    For i = 0 To pnlHost.NumberOfViews - 1
        Dim v As B4XView = pnlHost.GetView(i)
        v.SetLayoutAnimated(0, PAGE_PAD, currentY, maxW, v.Height)
        currentY = currentY + v.Height + 2dip
    Next
    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + title.View.Height + 2dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    ResizeComponents(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub tr1_Click(Tag As Object)
End Sub
#End Region
