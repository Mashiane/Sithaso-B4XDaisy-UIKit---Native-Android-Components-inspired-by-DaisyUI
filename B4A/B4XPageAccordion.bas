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
    acc1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 200dip)
    acc1.OpenOnlyOne = True
    
    ' Item 1
    Dim col1 As B4XDaisyCollapse
    col1.Initialize(Me, "col1")
    col1.TitleText = "Click to open item 1"
    col1.Icon = "arrow"
    col1.setTag("item1")
    acc1.AddItem(col1) ' automatically adds to accordion and positions
    
    ' Item 1 Content
    AddContent(col1, "This is the content for the first item. Opening it will close others.")
    
    ' Item 2
    Dim col2 As B4XDaisyCollapse
    col2.Initialize(Me, "col2")
    col2.TitleText = "Click to open item 2"
    col2.Icon = "arrow"
    col2.setTag("item2")
    acc1.AddItem(col2)
    
    ' Item 2 Content
    AddContent(col2, "This is the second item's content. It also belongs to the same accordion group.")
    
    y = y + acc1.mBase.Height + PAGE_PAD
    ' #endregion

    ' #region Example 2: Multiple Open Allowed
    y = AddSectionTitle("Accordion (Multiple Open Allowed)", y, maxW)
    Dim acc2 As B4XDaisyAccordion
    acc2.Initialize(Me, "acc2")
    acc2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 200dip)
    acc2.OpenOnlyOne = False
    
    ' Item 1
    Dim col3 As B4XDaisyCollapse
    col3.Initialize(Me, "col3")
    col3.TitleText = "Item A (Independent)"
    col3.Icon = "plus"
    col3.setVariant("primary")
    acc2.AddItem(col3)
    
    ' Content A
    AddContent(col3, "You can open multiple items here because OpenOnlyOne is False.")
    
    ' Item 2
    Dim col4 As B4XDaisyCollapse
    col4.Initialize(Me, "col4")
    col4.TitleText = "Item B (Independent)"
    col4.Icon = "plus"
    col4.setVariant("secondary")
    acc2.AddItem(col4)
    
    ' Content B
    AddContent(col4, "Secondary item content. Feel free to open both!")
    
    y = y + acc2.mBase.Height + PAGE_PAD
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
    y = y + col5.mBase.Height + PAGE_PAD
    
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
    y = y + col6.mBase.Height + PAGE_PAD
    ' #endregion

    ' #region Example 4: Join + Accordion
    y = AddSectionTitle("Join + Accordion Style", y, maxW)
    ' This would typically be a set of collapses with no bottom/top margins
    Dim acc3 As B4XDaisyAccordion
    acc3.Initialize(Me, "acc3")
    acc3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 180dip)
    
    For i = 1 To 3
        Dim c As B4XDaisyCollapse
        c.Initialize(Me, "joined")
        c.AddToParent(acc3.mBase, 0, (i-1)*50dip, maxW, 50dip)
        c.TitleText = "Joined Item " & i
        c.Icon = "arrow"
        ' Rounded-none to simulate join effect
        c.setRounded("rounded-none")
        acc3.AddItem(c)
        
        AddContent(c, "Content for joined item " & i)
    Next
    y = y + 200dip
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
    Return Y + 40dip
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




Private Sub GetAccordionForGroup(Name As String) As B4XDaisyAccordion
    ' Helper to find accordion instance on the page by matching group name
    For i = 0 To pnlHost.NumberOfViews - 1
        Dim v As B4XView = pnlHost.GetView(i)
        If v.Tag Is B4XDaisyAccordion Then
            Dim acc As B4XDaisyAccordion = v.Tag
            ' The accordion assigns group names like "group_" & tag
            ' Check if the requested group name matches this accordion's tag
            If Name = ("group_" & acc.getTag) Then
                Return acc
            End If
        End If
    Next
    Return Null
End Sub


#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub
#End Region
