B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

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

    ' ========================================================
    ' Section 1: H1 to H6 Heading Hierarchy (ion-text style)
    ' ========================================================
    y = AddSectionTitle("Heading Hierarchy (H1 - H6)", y, maxW)
    
    ' H1
    Dim h1 As B4XDaisyText
    h1.Initialize(Me, "")
    h1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    h1.Text = "H1 Heading - text-5xl"
    h1.TextSize = "text-5xl"
    h1.FontBold = True
    y = y + h1.GetComputedHeight + 8dip

    ' H2
    Dim h2 As B4XDaisyText
    h2.Initialize(Me, "")
    h2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    h2.Text = "H2 Heading - text-4xl"
    h2.TextSize = "text-4xl"
    h2.FontBold = True
    y = y + h2.GetComputedHeight + 8dip

    ' H3
    Dim h3 As B4XDaisyText
    h3.Initialize(Me, "")
    h3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    h3.Text = "H3 Heading - text-3xl"
    h3.TextSize = "text-3xl"
    h3.FontBold = True
    y = y + h3.GetComputedHeight + 8dip

    ' H4
    Dim h4 As B4XDaisyText
    h4.Initialize(Me, "")
    h4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    h4.Text = "H4 Heading - text-2xl"
    h4.TextSize = "text-2xl"
    h4.FontBold = True
    y = y + h4.GetComputedHeight + 8dip

    ' H5
    Dim h5 As B4XDaisyText
    h5.Initialize(Me, "")
    h5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    h5.Text = "H5 Heading - text-xl"
    h5.TextSize = "text-xl"
    h5.FontBold = True
    y = y + h5.GetComputedHeight + 8dip

    ' H6
    Dim h6 As B4XDaisyText
    h6.Initialize(Me, "")
    h6.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    h6.Text = "H6 Heading - text-lg"
    h6.TextSize = "text-lg"
    h6.FontBold = True
    y = y + h6.GetComputedHeight + PAGE_PAD

    ' ========================================================
    ' Section 2: Semantic Color Variants (DaisyUI Style)
    ' ========================================================
    y = AddSectionTitle("Semantic Color Variants", y, maxW)
    
    Dim variants() As String = Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
    For Each v As String In variants
        Dim vt As B4XDaisyText
        vt.Initialize(Me, "")
        vt.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
        vt.Text = "Text variant: " & v.ToUpperCase
        vt.Variant = v
        vt.TextSize = "text-sm"
        vt.FontBold = True
        y = y + vt.GetComputedHeight + 8dip
    Next
    y = y + PAGE_PAD

    ' ========================================================
    ' Section 3: Font Styles & Decorations
    ' ========================================================
    y = AddSectionTitle("Font Styles & Decorations", y, maxW)

    ' Bold
    Dim st1 As B4XDaisyText
    st1.Initialize(Me, "")
    st1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    st1.Text = "Bold Text Style"
    st1.FontBold = True
    st1.TextSize = "text-sm"
    y = y + st1.GetComputedHeight + 8dip

    ' Italic
    Dim st2 As B4XDaisyText
    st2.Initialize(Me, "")
    st2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    st2.Text = "Italic Text Style"
    st2.Italic = True
    st2.TextSize = "text-sm"
    y = y + st2.GetComputedHeight + 8dip

    ' Underline
    Dim st3 As B4XDaisyText
    st3.Initialize(Me, "")
    st3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    st3.Text = "Underlined Text Style"
    st3.Underline = True
    st3.TextSize = "text-sm"
    y = y + st3.GetComputedHeight + 8dip

    ' Strikethrough
    Dim st4 As B4XDaisyText
    st4.Initialize(Me, "")
    st4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    st4.Text = "Strikethrough Text Style"
    st4.Strikethrough = True
    st4.TextSize = "text-sm"
    y = y + st4.GetComputedHeight + 8dip

    ' Combined
    Dim st5 As B4XDaisyText
    st5.Initialize(Me, "")
    st5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    st5.Text = "Bold, Italic, and Underlined Text"
    st5.FontBold = True
    st5.Italic = True
    st5.Underline = True
    st5.TextSize = "text-sm"
    y = y + st5.GetComputedHeight + PAGE_PAD

    ' ========================================================
    ' Section 4: Case Transformations (New Features)
    ' ========================================================
    y = AddSectionTitle("Casing Transformations", y, maxW)

    ' Upper Case
    Dim c1 As B4XDaisyText
    c1.Initialize(Me, "")
    c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c1.Text = "transform this to uppercase text"
    c1.UpperCase = True
    c1.TextSize = "text-sm"
    y = y + c1.GetComputedHeight + 8dip

    ' Lower Case
    Dim c2 As B4XDaisyText
    c2.Initialize(Me, "")
    c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c2.Text = "TRANSFORM THIS TO LOWERCASE TEXT"
    c2.LowerCase = True
    c2.TextSize = "text-sm"
    y = y + c2.GetComputedHeight + 8dip

    ' Capitalize
    Dim c3 As B4XDaisyText
    c3.Initialize(Me, "")
    c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c3.Text = "capitalize the first letter of each word"
    c3.Capitalize = True
    c3.TextSize = "text-sm"
    y = y + c3.GetComputedHeight + PAGE_PAD

    ' ========================================================
    ' Section 5: Letter Spacing / Kerning (New Feature)
    ' ========================================================
    y = AddSectionTitle("Letter Spacing (Kerning)", y, maxW)

    ' Wide spacing
    Dim ls1 As B4XDaisyText
    ls1.Initialize(Me, "")
    ls1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    ls1.Text = "WIDE LETTER SPACING (0.1em)"
    ls1.LetterSpacing = 0.1
    ls1.TextSize = "text-sm"
    ls1.FontBold = True
    y = y + ls1.GetComputedHeight + 8dip

    ' Extra wide spacing
    Dim ls2 As B4XDaisyText
    ls2.Initialize(Me, "")
    ls2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    ls2.Text = "EXTRA WIDE SPACING (0.2em)"
    ls2.LetterSpacing = 0.2
    ls2.TextSize = "text-sm"
    ls2.FontBold = True
    y = y + ls2.GetComputedHeight + PAGE_PAD

    ' ========================================================
    ' Section 6: Text Shadows & Glows (New Feature)
    ' ========================================================
    y = AddSectionTitle("Text Shadows & Glow Effects", y, maxW)

    ' Standard drop shadow
    Dim sh1 As B4XDaisyText
    sh1.Initialize(Me, "")
    sh1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    sh1.Text = "Elegant Drop Shadow"
    sh1.TextSize = "text-xl"
    sh1.FontBold = True
    sh1.ShadowRadius = 3.0
    sh1.ShadowDx = 2.0
    sh1.ShadowDy = 2.0
    sh1.ShadowColor = xui.Color_ARGB(150, 100, 100, 100)
    y = y + sh1.GetComputedHeight + 12dip

    ' Glowing neon text
    Dim sh2 As B4XDaisyText
    sh2.Initialize(Me, "")
    sh2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    sh2.Text = "Neon Glow Text"
    sh2.TextSize = "text-2xl"
    sh2.FontBold = True
    sh2.TextColor = xui.Color_RGB(255, 20, 147) ' Deep Pink
    sh2.ShadowRadius = 8.0
    sh2.ShadowDx = 0.0
    sh2.ShadowDy = 0.0
    sh2.ShadowColor = xui.Color_RGB(255, 20, 147)
    y = y + sh2.GetComputedHeight + PAGE_PAD

    ' ========================================================
    ' Section 7: Text Alignments
    ' ========================================================
    y = AddSectionTitle("Text Alignments", y, maxW)

    ' Left aligned (Default)
    Dim al1 As B4XDaisyText
    al1.Initialize(Me, "")
    al1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    al1.Text = "Left Aligned Text (Default)"
    al1.HAlign = "LEFT"
    al1.TextSize = "text-sm"
    y = y + al1.GetComputedHeight + 8dip

    ' Centered
    Dim al2 As B4XDaisyText
    al2.Initialize(Me, "")
    al2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    al2.Text = "Centered Text"
    al2.HAlign = "CENTER"
    al2.TextSize = "text-sm"
    y = y + al2.GetComputedHeight + 8dip

    ' Right aligned
    Dim al3 As B4XDaisyText
    al3.Initialize(Me, "")
    al3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    al3.Text = "Right Aligned Text"
    al3.HAlign = "RIGHT"
    al3.TextSize = "text-sm"
    y = y + al3.GetComputedHeight + PAGE_PAD

    ' ========================================================
    ' Section 8: Multiline Paragraph Flow
    ' ========================================================
    y = AddSectionTitle("Multiline Paragraph Auto-Sizing", y, maxW)

    Dim p1 As B4XDaisyText
    p1.Initialize(Me, "")
    p1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    p1.Text = "This is a demonstration of a long, multiline paragraph inside the B4XDaisyText component. By configuring AutoResize to True and using 'h-auto' heights, the component is designed to dynamically query its native font metrics. It determines the number of lines required based on the current width and scales the base panel height to fit the text perfectly without any clipping or overlap."
    p1.TextSize = "text-base"
    p1.TextColor = xui.Color_RGB(71, 85, 105)
    p1.Padding = 8dip
    p1.BorderWidth = 1dip
    p1.BorderColor = xui.Color_RGB(226, 232, 240)
    p1.RoundedBox = True
    y = y + p1.GetComputedHeight + PAGE_PAD

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
#End Region

#Region Page Events
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
