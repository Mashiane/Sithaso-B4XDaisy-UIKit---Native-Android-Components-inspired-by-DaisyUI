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
    B4XPages.SetTitle(Me, "Timeline")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

''' <summary>
''' Renders all DaisyUI Timeline examples.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ' ====== 1. Default Timeline (Vertical) ======
    y = AddSectionTitle("1. Default Timeline", y, maxW)
    Dim tl1 As B4XDaisyTimeline
    tl1.Initialize(Me, "tl1")
    tl1.Orientation = "vertical"
    tl1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 300dip)
    tl1.AddItemBox("tl1_1", "1984", "First Macintosh computer", False, True)
    tl1.AddItemBox("tl1_2", "1998", "iMac", False, True)
    tl1.AddItemBox("tl1_3", "2001", "iPod", False, True)
    tl1.AddItemBox("tl1_4", "2007", "iPhone", False, True)
    tl1.AddItemBox("tl1_5", "2015", "Apple Watch", False, True)
    tl1.SetItemDone("tl1_4", False)   
    tl1.SetItemDone("tl1_5", False)  
    y = y + 320dip

    ' ====== 2. Timeline with icons ======
    y = AddSectionTitle("2. Timeline with icons", y, maxW)
    Dim tl2 As B4XDaisyTimeline
    tl2.Initialize(Me, "tl2")
    tl2.Orientation = "vertical"
    tl2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 300dip)
    tl2.AddItemBox("tl2_1", "1984", "First Macintosh computer", False, True)
    tl2.AddItemBox("tl2_2", "1998", "iMac", False, True)
    tl2.AddItemBox("tl2_3", "2001", "iPod", False, True)
    tl2.AddItemBox("tl2_4", "2007", "iPhone", False, True)
    tl2.AddItemBox("tl2_5", "2015", "Apple Watch", False, True)
    y = y + 320dip

    ' ====== 3. Timeline with different sides ======
    y = AddSectionTitle("3. Timeline with different sides", y, maxW)
    Dim tl3 As B4XDaisyTimeline
    tl3.Initialize(Me, "tl3")
    tl3.Orientation = "vertical"
    tl3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 300dip)
    tl3.AddItemBox("tl3_1", "First Macintosh computer", "", False, False)
    tl3.AddItemBox("tl3_2", "", "iMac", False, False)
    tl3.AddItemBox("tl3_3", "iPod", "", False, False)
    tl3.AddItemBox("tl3_4", "", "iPhone", False, False)
    tl3.AddItemBox("tl3_5", "Apple Watch", "", False, False)
    y = y + 320dip

    ' ====== 4. Timeline with different sides / colorful (Multi-line test) ======
    y = AddSectionTitle("4. Colorful & Multi-line", y, maxW)
    Dim tl4 As B4XDaisyTimeline
    tl4.Initialize(Me, "tl4")
    tl4.Orientation = "vertical"
    tl4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 450dip)
    tl4.AddItemBox("tl4_1", "1984", "First Macintosh computer (Revolutionary PC)", False, True)
    tl4.AddItemBox("tl4_2", "", "iMac", False, True)
    tl4.AddItemBox("tl4_3", "2001", "iPod (1,000 songs in your pocket)", True, False)
    tl4.AddItemBox("tl4_4", "", "iPhone", False, True)
    tl4.AddItemBox("tl4_5", "2015", "Apple Watch", True, False)
' apply colorful variants using setters
tl4.SetItemVariant("tl4_1", "primary")
tl4.SetItemVariant("tl4_2", "secondary")
tl4.SetItemVariant("tl4_3", "accent")
tl4.SetItemVariant("tl4_4", "info")
tl4.SetItemVariant("tl4_5", "warning")
    y = y + 470dip

    ' ====== 5. Timeline horizontal with dashed border ======
    y = AddSectionTitle("5. Horizontal with dashed border & boxes", y, maxW)
    Dim tl5 As B4XDaisyTimeline
    tl5.Initialize(Me, "tl5")
    tl5.Orientation = "horizontal"
    tl5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 200dip)
    tl5.AddItemBox("tl5_1", "1984", "First Macintosh", False, True)
    tl5.AddItemBox("tl5_2", "1998", "iMac", False, True)
    tl5.AddItemBox("tl5_3", "2001", "iPod", False, True) ' Default variant
    tl5.AddItemBox("tl5_4", "2007", "iPhone", False, True)
    tl5.AddItemBox("tl5_5", "2015", "Apple Watch", False, True)
    ' dash every item to illustrate dashed border support
For i = 1 To 5
    tl5.SetItemDashedBorder("tl5_" & i, True)
Next
    y = y + 320dip  ' extra spacing before next section
    ' ====== 6. Timeline horizontal with different sides ======
    y = AddSectionTitle("6. Timeline horizontal with different sides", y, maxW)
    Dim tl6 As B4XDaisyTimeline
    tl6.Initialize(Me, "tl6")
    tl6.Orientation = "horizontal"
    tl6.AddToParent(pnlHost, PAGE_PAD, y, maxW, 200dip)
    tl6.AddItemBox("tl6_1", "First Macintosh computer", "", False, False)
    tl6.AddItemBox("tl6_2", "", "iMac", False, False)
    tl6.AddItemBox("tl6_3", "iPod", "", False, False)
    tl6.AddItemBox("tl6_4", "", "iPhone", False, False)
    tl6.AddItemBox("tl6_5", "Apple Watch", "", False, False)
    y = y + 220dip

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Adds a stylized section title for the demo.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 14
    title.FontBold = True
    Return Y + 32dip
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


