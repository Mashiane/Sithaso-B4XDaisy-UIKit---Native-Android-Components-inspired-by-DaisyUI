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

    ' Example 1: Basic rotation using SetItems convenience method
    y = AddSectionTitle("Basic Rotation (3 items, text-sm, 3s)", y, maxW)
    y = AddSectionNote("Rotates through 3 words every 3 seconds using SetItems.", y, maxW)
    Dim tr1 As B4XDaisyTextRotate
    tr1.Initialize(Me, "tr1")
    tr1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 42dip)
    tr1.setDuration("3s")
    tr1.SetItems(Array As String("ONE", "TWO", "THREE"))
    y = y + tr1.GetComputedHeight + 18dip

    ' Example 2: Six words, large, centered
    y = AddSectionTitle("Six Words, text-3xl, Centered (3s)", y, maxW)
    y = AddSectionNote("Large bold text, centered. Each item added via AddItem then Refresh to start.", y, maxW)
    Dim tr2 As B4XDaisyTextRotate
    tr2.Initialize(Me, "tr2")
    tr2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
    tr2.setDuration("3s")
    Dim words(6) As String
    words(0) = "DESIGN"
    words(1) = "DEVELOP"
    words(2) = "DEPLOY"
    words(3) = "SCALE"
    words(4) = "MAINTAIN"
    words(5) = "REPEAT"
    For i = 0 To 5
        Dim dt2 As B4XDaisyText
        dt2.Initialize(Me, "")
        dt2.Text = words(i)
        dt2.TextSize = "text-3xl"
        dt2.FontBold = True
        dt2.setHAlign("CENTER")
        tr2.AddItem(dt2)
    Next
    tr2.Refresh
    y = y + tr2.GetComputedHeight + 18dip

    ' Example 3: Per-item color variant
    y = AddSectionTitle("Per-Item Color Variant, text-sm (3s)", y, maxW)
    y = AddSectionNote("Building B4X apps for... each item carries its own semantic variant color.", y, maxW)
    Dim tr3 As B4XDaisyTextRotate
    tr3.Initialize(Me, "tr3")
    tr3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 44dip)
    tr3.setDuration("3s")
    Dim roles(3) As String
    roles(0) = "Designers"
    roles(1) = "Developers"
    roles(2) = "Managers"
    Dim roleVariants(3) As String
    roleVariants(0) = "info"
    roleVariants(1) = "success"
    roleVariants(2) = "warning"
    For i = 0 To 2
        Dim dtr As B4XDaisyText
        dtr.Initialize(Me, "")
        dtr.Text = roles(i)
        dtr.setVariant(roleVariants(i))
        dtr.setHAlign("CENTER")
        dtr.setAutoResize(False)
        tr3.AddItem(dtr)
    Next
    tr3.Refresh
    y = y + tr3.GetComputedHeight + 18dip

    ' Example 4: Custom duration, bold + primary variant
    y = AddSectionTitle("Bold+Primary, text-3xl (3s)", y, maxW)
    y = AddSectionNote("Two items with distinct text styles rotating every 3 seconds.", y, maxW)
    Dim tr4 As B4XDaisyTextRotate
    tr4.Initialize(Me, "tr4")
    tr4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
    tr4.setDuration("3s")
    Dim dtBlaze As B4XDaisyText
    dtBlaze.Initialize(Me, "")
    dtBlaze.Text = "BLAZING"
    dtBlaze.TextSize = "text-3xl"
    dtBlaze.setHAlign("CENTER")
    tr4.AddItem(dtBlaze)
    Dim dtFast As B4XDaisyText
    dtFast.Initialize(Me, "")
    dtFast.Text = "FAST >>>"
    dtFast.TextSize = "text-3xl"
    dtFast.FontBold = True
    dtFast.setVariant("primary")
    dtFast.setHAlign("CENTER")
    tr4.AddItem(dtFast)
    tr4.Refresh
    y = y + tr4.GetComputedHeight + 18dip

    ' Example 5: Emoji-prefixed items
    y = AddSectionTitle("Emoji Prefix, text-3xl (3s)", y, maxW)
    y = AddSectionNote("Emoji-prefixed words rotated with centered large text.", y, maxW)
    Dim tr5 As B4XDaisyTextRotate
    tr5.Initialize(Me, "tr5")
    tr5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
    tr5.setDuration("3s")
    Dim emojis(4) As String
    emojis(0) = Chr(0xD83C) & Chr(0xDFA8) & " Design"    ' Palette emoji U+1F3A8
    emojis(1) = Chr(0xD83D) & Chr(0xDCBB) & " Develop"   ' Laptop emoji U+1F4BB
    emojis(2) = Chr(0xD83D) & Chr(0xDE80) & " Deploy"    ' Rocket emoji U+1F680
    emojis(3) = Chr(0xD83D) & Chr(0xDCC8) & " Scale"     ' Chart emoji U+1F4C8
    For i = 0 To 3
        Dim dte As B4XDaisyText
        dte.Initialize(Me, "")
        dte.Text = emojis(i)
        dte.TextSize = "text-3xl"
        dte.setHAlign("CENTER")
        tr5.AddItem(dte)
    Next
    tr5.Refresh
    y = y + tr5.GetComputedHeight + 18dip

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub ResizeComponents(Width As Int, Height As Int)
    RenderExamples(Width, Height)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + title.GetComputedHeight + 2dip
End Sub

Private Sub AddSectionNote(Text As String, Y As Int, Width As Int) As Int
    Dim note As B4XDaisyText
    note.Initialize(Me, "")
    note.AddToParent(pnlHost, PAGE_PAD, Y, Width, 36dip)
    note.Text = Text
    note.TextColor = xui.Color_RGB(100, 116, 139)
    note.TextSize = 12
    note.SingleLine = False
    Return Y + note.GetComputedHeight + 4dip
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

#End Region
