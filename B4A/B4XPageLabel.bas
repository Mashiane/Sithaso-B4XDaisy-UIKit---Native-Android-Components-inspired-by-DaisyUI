B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

#Region Variables

    Sub Class_Globals
        Private Root As B4XView
        Private xui As XUI
        Private svHost As ScrollView
        Private pnlHost As B4XView
        Private PAGE_PAD As Int = 12dip
        Private SECTION_GAP As Int = 24dip
        Private ITEM_HEIGHT As Int = 56dip
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
        B4XPages.SetTitle(Me, "Label")

        svHost.Initialize(Max(1dip, Root.Height))
        Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
        pnlHost = svHost.Panel
        pnlHost.Color = xui.Color_Transparent

        RenderExamples(Root.Width, Root.Height)
    End Sub

    Private Sub B4XPage_Appear
        CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    End Sub
#End Region

#Region Rendering
    ''' <summary>
    ''' Renders all DaisyUI Label examples from docs.
    ''' Docs: https://daisyui.com/components/label/
    ''' </summary>

    Private Sub RenderExamples(Width As Int, Height As Int)
        If pnlHost.IsInitialized = False Then Return
        pnlHost.RemoveAllViews

        Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
        Dim y As Int = PAGE_PAD

        '============================================================
        'Example 1: Label for input (prefix position)
        'HTML: <label class="input"><span class="label">https://</span><input type="text" placeholder="URL" /></label>
        'DaisyUI shows label text before input field
        '============================================================
        y = AddSectionTitle("Label For input (prefix)", y, maxW)
        Dim c1 As B4XDaisyLabel
        c1.Initialize(Me, "label")
        c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c1.Text = "https: //"
        c1.IsInsideInput = True
        c1.Position = "FIRST"
        c1.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 2: Label for input at the end (suffix position)
        'HTML: <label class="input"><input type="text" placeholder="domain name" /><span class="label">.com</span></label>
        'DaisyUI shows label text after input field
        '============================================================
        y = AddSectionTitle("Label For input (suffix)", y, maxW)
        Dim c2 As B4XDaisyLabel
        c2.Initialize(Me, "label")
        c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c2.Text = ".com"
        c2.IsInsideInput = True
        c2.Position = "LAST"
        c2.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 3: Label for select
        'HTML: <label class="select"><span class="label">Type</span><select><option>Personal</option><option>Business</option></select></label>
        'DaisyUI shows label text before select dropdown
        '============================================================
        y = AddSectionTitle("Label For Select", y, maxW)
        Dim c3 As B4XDaisyLabel
        c3.Initialize(Me, "label")
        c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c3.Text = "Type"
        c3.IsInsideInput = True
        c3.Position = "FIRST"
        c3.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 4: Label for date input
        'HTML: <label class="input"><span class="label">Publish date</span><input type="date" /></label>
        'DaisyUI shows label text before date picker
        '============================================================
        y = AddSectionTitle("Label For date input", y, maxW)
        Dim c4 As B4XDaisyLabel
        c4.Initialize(Me, "label")
        c4.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c4.Text = "Publish date"
        c4.IsInsideInput = True
        c4.Position = "FIRST"
        c4.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 5: Floating Label
        'HTML: <label class="floating-label w-full max-w-xs"><span>Your Email</span><input type="email" placeholder="mail@site.com" class="input input-md" /></label>
        'Note: floating-label is a wrapper component for input+span composition
        'We demonstrate the standalone label behavior here
        '============================================================
        y = AddSectionTitle("Floating Label (label text)", y, maxW)
        Dim c5 As B4XDaisyLabel
        c5.Initialize(Me, "label")
        c5.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c5.Text = "Your Email"
        c5.TextSize = "text-md"
        c5.SingleLine = True
        c5.Tag = "floating-email"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 6: Floating Label with Different Sizes
        'HTML: Shows xs, sm, md, lg, xl size variants
        'We demonstrate each size token on separate rows
        '============================================================
        y = AddSectionTitle("Floating Label sizes", y, maxW)

        Dim sizes() As String = Array As String("text-xs", "text-sm", "text-md", "text-lg", "text-xl")
        Dim sizeLabels() As String = Array As String("Extra Small", "Small", "Medium", "Large", "Extra Large")

        For i = 0 To sizes.Length - 1
            Dim cs As B4XDaisyLabel
            cs.Initialize(Me, "label")
            cs.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
            cs.Text = sizeLabels(i)
            cs.TextSize = sizes(i)
            cs.SingleLine = True
            cs.Tag = "size-" & sizes(i)
            y = y + ITEM_HEIGHT + 8dip
        Next
        y = y + SECTION_GAP

        '============================================================
        'Example 7: Standalone label styling (base .label class)
        'CSS: inline-flex items-center gap-1.5 whitespace-nowrap text-current/60
        'Shows label as standalone text element outside input context
        '============================================================
        y = AddSectionTitle("Standalone label styling", y, maxW)
        Dim c7 As B4XDaisyLabel
        c7.Initialize(Me, "label")
        c7.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c7.Text = "Standalone label with text-current/60"
        c7.SingleLine = True
        c7.TextSize = "text-sm"
        c7.Tag = "standalone"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 8: Bold label variant
        'Demonstrates font-bold designer property
        '============================================================
        y = AddSectionTitle("Bold label", y, maxW)
        Dim c8 As B4XDaisyLabel
        c8.Initialize(Me, "label")
        c8.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c8.Text = "Bold label text"
        c8.FontBold = True
        c8.TextSize = "text-sm"
        c8.Tag = "bold-label"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 9: Empty state
        'Demonstrates behavior when label text is empty
        '============================================================
        y = AddSectionTitle("Empty label state", y, maxW)
        Dim c9 As B4XDaisyLabel
        c9.Initialize(Me, "label")
        c9.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c9.Text = ""
        c9.SingleLine = True
        c9.Tag = "empty-label"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 10: Alignment variants
        'Demonstrates HAlign and VAlign designer properties
        '============================================================
        y = AddSectionTitle("Alignment variants", y, maxW)

        Dim c10a As B4XDaisyLabel
        c10a.Initialize(Me, "label")
        c10a.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c10a.Text = "Left aligned text"
        c10a.HAlign = "LEFT"
        c10a.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + 8dip

        Dim c10b As B4XDaisyLabel
        c10b.Initialize(Me, "label")
        c10b.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c10b.Text = "Center aligned text"
        c10b.HAlign = "CENTER"
        c10b.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + 8dip

        Dim c10c As B4XDaisyLabel
        c10c.Initialize(Me, "label")
        c10c.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c10c.Text = "Right aligned text"
        c10c.HAlign = "RIGHT"
        c10c.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + SECTION_GAP

        '============================================================
        'Example 11: Disabled state
        'Demonstrates Enabled = False
        '============================================================
        y = AddSectionTitle("Disabled label", y, maxW)
        Dim c11 As B4XDaisyLabel
        c11.Initialize(Me, "label")
        c11.AddToParent(pnlHost, PAGE_PAD, y, maxW, ITEM_HEIGHT)
        c11.Text = "Disabled label"
        c11.Enabled = False
        c11.TextSize = "text-sm"
        y = y + ITEM_HEIGHT + SECTION_GAP

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

    Private Sub B4XPage_Resize(Width As Int, Height As Int)
        If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
        RenderExamples(Width, Height)
    End Sub

    Private Sub label_Click(Tag As Object)
        #If B4A
            Dim s As String = Tag
            If s.Length = 0 Then s = "label"
            ToastMessageShow("Clicked: " & s, False)
        #End If
    End Sub
#End Region
