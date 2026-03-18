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
    Private PAGE_PAD As Int = 20dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_White
    B4XPages.SetTitle(Me, "Accordion")

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

    ' #region Example 1: Standard Accordion (Single Open)
    y = AddSectionTitle("Standard Accordion (Single Open)", y, maxW)
    Dim acc1 As B4XDaisyAccordion
    acc1.Initialize(Me, "acc1")
    acc1.GroupName = "standard-accordion"
    acc1.OpenOnlyOne = True
    acc1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 10dip)
    
    Dim c1a As B4XDaisyCollapse = acc1.AddItemBasic("item1", "arrow", "Click to open item 1")
    AddContent(c1a, "This is the content for the first item. Opening it will close others.")
    
    Dim c1b As B4XDaisyCollapse = acc1.AddItemBasic("item2", "arrow", "Click to open item 2")
    AddContent(c1b, "This is the second item's content. It also belongs to the same accordion group.")
    
    y = y + acc1.GetComputedHeight + PAGE_PAD
    ' #endregion

    ' #region Example 2: Multiple Open Allowed
    y = AddSectionTitle("Accordion (Multiple Open Allowed)", y, maxW)
    Dim acc2 As B4XDaisyAccordion
    acc2.Initialize(Me, "acc2")
    acc2.GroupName = "multi-open-accordion"
    acc2.OpenOnlyOne = False
    acc2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 10dip)
    
    Dim c2a As B4XDaisyCollapse = acc2.AddItemBasic("itemA", "plus", "Item A (Independent)")
    acc2.SetItemVariant("itemA", "primary")
    AddContent(c2a, "You can open multiple items here because OpenOnlyOne is False.")
    
    Dim c2b As B4XDaisyCollapse = acc2.AddItemBasic("itemB", "plus", "Item B (Independent)")
    acc2.SetItemVariant("itemB", "secondary")
    AddContent(c2b, "Secondary item content. Feel free to open both!")
    
    y = y + acc2.GetComputedHeight + PAGE_PAD
    ' #endregion

    ' #region Example 3: Different Icon Positions (User Request)
    y = AddSectionTitle("Custom Icon Positions", y, maxW)
    
    ' Left side
    Dim col5 As B4XDaisyCollapse
    col5.Initialize(Me, "col5")
    col5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 60dip)
    col5.TitleText = "Icon on the Left"
    col5.Icon = "arrow"
    col5.setIconPosition("left")
    col5.setVariant("info")
    
    ' Content
    AddContent(col5, "Collapse with the arrow icon positioned on the left side.")
    y = y + col5.GetComputedHeight + PAGE_PAD
    
    ' Right side (default)
    Dim col6 As B4XDaisyCollapse
    col6.Initialize(Me, "col6")
    col6.AddToParent(pnlHost, PAGE_PAD, y, maxW, 60dip)
    col6.TitleText = "Icon on the Right"
    col6.Icon = "plus"
    col6.setIconPosition("right")
    col6.setVariant("success")
    
    ' Content
    AddContent(col6, "Collapse with the plus/minus icon on the right (default position).")
    y = y + col6.GetComputedHeight + PAGE_PAD
    ' #endregion

    ' #region Example 4: Join + Accordion
    y = AddSectionTitle("Join + Accordion Style", y, maxW)
    Dim acc3 As B4XDaisyAccordion
    acc3.Initialize(Me, "acc3")
    acc3.GroupName = "join-group"
    acc3.setRounded("rounded-none")
    acc3.SpaceY = 0
    acc3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 10dip)

    For i = 1 To 3
        Dim c As B4XDaisyCollapse = acc3.AddItemBasic("joined" & i, "arrow", "Joined Item " & i)
        AddContent(c, "Content for joined item " & i & ". This panel expands to fit its content automatically.")
    Next
    y = y + acc3.GetComputedHeight + PAGE_PAD
    ' #endregion

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 32dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 18
    title.FontBold = True
    Return Y + title.GetComputedHeight + 8dip
End Sub

''' <summary>
''' Standardized content creator for accordion items.
''' Uses text-sm and removes double padding for better alignment.
''' </summary>
Private Sub AddContent(Col As B4XDaisyCollapse, Text As String)
    Dim txt As B4XDaisyText
    txt.Initialize(Me, "")
    txt.Text = Text
    txt.TextSize = "text-sm"
    ' Use 0dip left because the CollapseContent container already provides 16dip padding.
    ' This ensures perfect vertical alignment with the title text.
    txt.AddToParent(Col.getContentView, 0dip, 8dip, Col.getContentView.Width, 60dip)
    Col.RefreshContent
End Sub
#End Region

Private Sub B4XPage_Appear
    If pnlHost.NumberOfViews = 0 Then
        RenderExamples(Root.Width, Root.Height)
    End If
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub
#End Region
