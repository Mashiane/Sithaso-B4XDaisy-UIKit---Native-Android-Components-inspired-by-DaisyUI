B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Variables
#IgnoreWarnings:12
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
    B4XPages.SetTitle(Me, "Collapse")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all collapse examples mapped to DaisyUI documentation variants.
''' Each example uses B4XDaisyCollapse directly with explicit Initialize/AddToParent/property assignment.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews


    Dim maxW As Int = Max(220dip, Width - PAGE_PAD * 2)
    Dim y As Int = PAGE_PAD
    Dim titleH As Int = 56dip
    Dim gap As Int = 12dip

    ' #region Example 1: Basic collapse (tap to expand)
    y = AddSectionTitle("Basic Collapse", y, maxW)
    Dim c1 As B4XDaisyCollapse
    c1.Initialize(Me, "collapse1")
    c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c1.TitleText = "Click to open!"
    AddBodyLabel(c1, "Hello! I am the collapse body.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 2: With arrow icon
    y = AddSectionTitle("With Arrow Icon", y, maxW)
    Dim c2 As B4XDaisyCollapse
    c2.Initialize(Me, "collapse2")
    c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c2.Icon = "arrow"
    c2.TitleText = "Click to open!"
    AddBodyLabel(c2, "Hello! I am the collapse body.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 3: With plus/minus icon
    y = AddSectionTitle("With Plus/Minus Icon", y, maxW)
    Dim c3 As B4XDaisyCollapse
    c3.Initialize(Me, "collapse3")
    c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c3.Icon = "plus"
    c3.TitleText = "Click to open!"
    AddBodyLabel(c3, "Hello! I am the collapse body.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 4: Force open (Open = True, content always visible)
    y = AddSectionTitle("Force Open", y, maxW)
    Dim c4 As B4XDaisyCollapse
    c4.Initialize(Me, "collapse4")
    c4.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c4.Icon = "arrow"
    c4.TitleText = "I am always open!"
    AddBodyLabel(c4, "Hello! I am the collapse body.", maxW)
    c4.Open = True
    y = y + titleH + 60dip + gap
    ' #endregion

    ' #region Example 5: Force close (content never shown)
    y = AddSectionTitle("Force Close", y, maxW)
    Dim c5 As B4XDaisyCollapse
    c5.Initialize(Me, "collapse5")
    c5.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c5.TitleText = "I am always closed!"
    AddBodyLabel(c5, "You cannot see me.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 6: Primary variant with arrow icon
    y = AddSectionTitle("Primary Variant", y, maxW)
    Dim c6 As B4XDaisyCollapse
    c6.Initialize(Me, "collapse6")
    c6.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c6.Icon = "arrow"
    c6.Variant = "primary"
    c6.TitleText = "Click to open!"
    c6.TitleVariant = "primary"
    AddBodyLabel(c6, "Primary variant content.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 7: Accent variant with plus icon
    y = AddSectionTitle("Accent Variant (Plus)", y, maxW)
    Dim c7 As B4XDaisyCollapse
    c7.Initialize(Me, "collapse7")
    c7.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c7.Icon = "plus"
    c7.Variant = "accent"
    c7.TitleText = "Click to open!"
    c7.TitleVariant = "accent"
    AddBodyLabel(c7, "Accent variant content.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 8: Custom colors � no border, colored title text
    y = AddSectionTitle("Custom Colors (No Border)", y, maxW)
    Dim c8 As B4XDaisyCollapse
    c8.Initialize(Me, "collapse8")
    c8.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c8.Icon = "arrow"
    c8.TitleText = "Custom colors"
    c8.TitleTextColor = xui.Color_RGB(99, 102, 241)
    AddBodyLabel(c8, "Content with custom text color � RGB(71,85,105).", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 9: Title with left SVG icon
    y = AddSectionTitle("Title With SVG Icon (Left)", y, maxW)
    Dim c9 As B4XDaisyCollapse
    c9.Initialize(Me, "collapse9")
    c9.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c9.Icon = "arrow"
    c9.TitleText = "Settings"
    c9.TitleIconName = "gear.svg"
    AddBodyLabel(c9, "Content revealed when expanded.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 10: Title icon + primary variant
    y = AddSectionTitle("Icon + Primary Variant", y, maxW)
    Dim c10 As B4XDaisyCollapse
    c10.Initialize(Me, "collapse10")
    c10.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c10.Icon = "plus"
    c10.Variant = "primary"
    c10.TitleText = "Notifications"
    c10.TitleVariant = "primary"
    c10.TitleIconName = "bell-solid.svg"
    AddBodyLabel(c10, "Primary-styled collapse with SVG icon.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 11: Plus Icon on Left
    y = AddSectionTitle("Plus Icon On Left", y, maxW)
    Dim c11 As B4XDaisyCollapse
    c11.Initialize(Me, "collapse11")
    c11.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c11.Icon = "plus"
    c11.IconPosition = "left"
    c11.TitleText = "Expand Me (Plus Left)"
    AddBodyLabel(c11, "Expansion indicator is now on the left side.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 12: Arrow Icon on Left
    y = AddSectionTitle("Arrow Icon On Left", y, maxW)
    Dim c12 As B4XDaisyCollapse
    c12.Initialize(Me, "collapse12")
    c12.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c12.Icon = "arrow"
    c12.IconPosition = "left"
    c12.TitleText = "Expand Me (Arrow Left)"
    AddBodyLabel(c12, "Arrow indicator is now on the left side.", maxW)
    y = y + titleH + gap
    ' #endregion

    ' #region Example 13: Dashed Border
    y = AddSectionTitle("Dashed Border", y, maxW)
    Dim c13 As B4XDaisyCollapse
    c13.Initialize(Me, "collapse13")
    c13.AddToParent(pnlHost, PAGE_PAD, y, maxW, titleH)
    c13.BorderStyle = "dashed"
    c13.BorderWidth = "border-2"
    c13.BorderColor = "border-primary"
    c13.Icon = "arrow"          ' add chevron-style arrow on right
    c13.TitleText = "Dashed border collapse"
    AddBodyLabel(c13, "This collapse has a primary-colored dashed border.", maxW)
    y = y + titleH + gap
    ' #endregion
	
    pnlHost.Height = Max(Root.Height, y + PAGE_PAD)
End Sub


''' <summary>
''' Adds a plain body label into a collapse content container.
''' </summary>
Private Sub AddBodyLabel(Collapse As B4XDaisyCollapse, Text As String, MaxW As Int)
    Dim lbl As Label
    lbl.Initialize("")
    lbl.Text = Text
    lbl.TextSize = 14
    ' Retrieve text color from the collapse content component (which now handles variant resolution)
    lbl.TextColor = Collapse.CollapseContent.TextColor
    ' Use 0dip left because the CollapseContent container already provides the standard 16dip padding.
    ' This ensures perfect vertical alignment with the title text.
    Collapse.ContentView.AddView(lbl, 0, 8dip, Collapse.ContentView.Width, 36dip)
End Sub

''' <summary>
''' Adds a bold section title label above each example block.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As Label
    title.Initialize("")
    title.Text = Text
    title.TextSize = 13
    title.TextColor = xui.Color_RGB(30, 41, 59)
    pnlHost.AddView(title, PAGE_PAD, Y, Width, 24dip)
    Return Y + 28dip
End Sub

Private Sub collapse1_Click (Tag As Object)
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
#End Region
Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
