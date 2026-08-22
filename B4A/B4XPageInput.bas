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
        Private pageScroll As B4XDaisyPageScroll
        Private pnlContent As B4XView
        Private PAGE_PAD As Int = 12dip
        Private ROW_GAP As Int = 10dip
        Private ITEM_HEIGHT As Int = 40dip
        Private Samples As List
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
    ''' B4XPage Created event. Sets up the B4XDaisyPageScroll container.
    ''' </summary>
    Private Sub B4XPage_Created(Root1 As B4XView)
        Root = Root1

        pageScroll.Initialize(Me, "pageScroll")
        pageScroll.PagePadding = PAGE_PAD
        pageScroll.YGap = ROW_GAP
        pageScroll.AutoFitHeight = True
        pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
        pnlContent = pageScroll.Panel

        Samples.Initialize
    End Sub

    Private Sub B4XPage_Appear
        If Samples.Size = 0 Then
            CreateSamples
            LayoutInputs(Root.Width, Root.Height)
        End If
        CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    End Sub

    Private Sub B4XPage_Resize(Width As Int, Height As Int)
        If pageScroll.IsInitialized Then pageScroll.SetLayoutAnimated(0, 0, 0, Width, Height)
        LayoutInputs(Width, Height)
    End Sub
#End Region

#Region Sample Creation
    ''' <summary>
    ''' Creates all DaisyUI Input examples from docs.
    ''' </summary>
    Private Sub CreateSamples
        Samples.Clear
        pnlContent.RemoveAllViews

        Dim maxW As Int = Max(220dip, Root.Width - (PAGE_PAD * 2))

        '-
        'Example 1: Text input (base)
        '-
        AddSectionTitle("Text input")
        Dim c1 As B4XDaisyInput
        c1.Initialize(Me, "inp")
        c1.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c1.LabelAbove = "Full name"
        c1.Placeholder = "Type here"
        c1.Tag = "base-text"
        Samples.Add(c1)

        '-
        'Example 2: Text input with icons
        '-
        AddSectionTitle("Input with icons")

        Dim c2a As B4XDaisyInput
        c2a.Initialize(Me, "inp")
        c2a.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2a.LabelAbove = "Search"
        c2a.IconLeft = "magnifying-glass-solid.svg"
        c2a.Placeholder = "Search"
        c2a.Tag = "input-search-icon"
        Samples.Add(c2a)

        Dim c2b As B4XDaisyInput
        c2b.Initialize(Me, "inp")
        c2b.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2b.LabelAbove = "File"
        c2b.IconLeft = "file.svg"
        c2b.Placeholder = "index.php"
        c2b.Tag = "input-file-icon"
        Samples.Add(c2b)

        Dim c2c As B4XDaisyInput
        c2c.Initialize(Me, "inp")
        c2c.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2c.LabelAbove = "Path"
        c2c.IconLeft = "folder-solid.svg"
        c2c.Placeholder = "src/app/"
        c2c.IconRight = "xmark-solid.svg"
        c2c.Tag = "input-path-icon"
        Samples.Add(c2c)

        '-
        'Example 3: Ghost style
        '-
        AddSectionTitle("Ghost style")
        Dim c3 As B4XDaisyInput
        c3.Initialize(Me, "inp")
        c3.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c3.LabelAbove = "Ghost input"
        c3.Variant = "ghost"
        c3.Placeholder = "Type here"
        c3.Tag = "input-ghost"
        Samples.Add(c3)

        '-
        'Example 4: Input colors
        '-
        AddSectionTitle("Input colors")
        Dim colorList As List
        colorList.Initialize
        colorList.AddAll(Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"))
        For i = 0 To colorList.Size - 1
            Dim v As String = colorList.Get(i)
            Dim cc As B4XDaisyInput
            cc.Initialize(Me, "cc" & i)
            cc.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
            cc.LabelAbove = v.SubString2(0, 1).ToUpperCase & v.SubString2(1, v.Length)
            cc.Variant = v
            cc.Placeholder = v
            cc.Tag = "color-" & v
            Samples.Add(cc)
        Next

        '-
        'Example 5: Sizes
        '-
        AddSectionTitle("Sizes")
        Dim sizeVals As List = Array As String("md", "lg", "xl")
        Dim sizeLabels As List = Array As String("Medium", "Large", "Xlarge")
        Dim sizeHeights As List = Array As Int(40dip, 48dip, 56dip)
        For i = 0 To sizeVals.Size - 1
            Dim sz As String = sizeVals.Get(i)
            Dim sl As String = sizeLabels.Get(i)
            Dim shgt As Int = sizeHeights.Get(i)
            Dim cs As B4XDaisyInput
            cs.Initialize(Me, "cs" & i)
            cs.AddToParent(pnlContent, PAGE_PAD, 0, maxW, shgt)
            cs.LabelAbove = sl
            cs.Size = sz
            cs.Placeholder = sl
            cs.Tag = "size-" & sz
            Samples.Add(cs)
        Next

        '-
        'Example 6: Disabled
        '-
        AddSectionTitle("Disabled")
        Dim c6 As B4XDaisyInput
        c6.Initialize(Me, "inp")
        c6.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c6.LabelAbove = "Disabled"
        c6.Placeholder = "You can't touch this"
        c6.Enabled = False
        c6.Tag = "input-disabled"
        Samples.Add(c6)

        '-
        'Example 7: Inline labels (left / right)
        '-
        AddSectionTitle("Inline labels (left / right)")
        Dim c8a As B4XDaisyInput
        c8a.Initialize(Me, "inp")
        c8a.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c8a.LabelAbove = "URL"
        c8a.LabelLeft = "http://"
        c8a.Placeholder = "example.com"
        c8a.Tag = "input-label-left"
        Samples.Add(c8a)

        Dim c8b As B4XDaisyInput
        c8b.Initialize(Me, "inp")
        c8b.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c8b.LabelAbove = "Website"
        c8b.LabelRight = ".com"
        c8b.Placeholder = "example"
        c8b.Tag = "input-label-right"
        Samples.Add(c8b)

        '-
        'Example 8: Floating label (Label + FloatingLabel=True)
        '-
        AddSectionTitle("Floating label")
        Dim c8 As B4XDaisyInput
        c8.Initialize(Me, "inp")
        c8.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c8.LabelAbove = "Full name"
        c8.FloatingLabel = True
        c8.Placeholder = "John Doe"
        c8.Tag = "input-floating-label"
        Samples.Add(c8)

        '-
        'Example 10: Username input with icon and label above
        '-
        AddSectionTitle("Username input with icon")
        Dim c10 As B4XDaisyInput
        c10.Initialize(Me, "inp")
        c10.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c10.LabelAbove = "Username"
        c10.IconLeft = "user-solid.svg"
        c10.Placeholder = "Type your username"
        c10.HintText = "Must be 3 to 30 characters containing only letters, numbers or dash"
        c10.Tag = "input-username"
        Samples.Add(c10)

        '-
        'Example 11: Email input with icon and label above
        '-
        AddSectionTitle("Email input with icon")
        Dim c11 As B4XDaisyInput
        c11.Initialize(Me, "inp")
        c11.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c11.LabelAbove = "Email"
        c11.IconLeft = "envelope-regular.svg"
        c11.InputType = "email"
        c11.Placeholder = "mail@site.com"
        c11.HintText = "Enter valid email address"
        c11.Tag = "input-email"
        Samples.Add(c11)

        '-
        'Example 12: Password input with icon and label above
        '-
        AddSectionTitle("Password input with icon")
        Dim c13 As B4XDaisyInput
        c13.Initialize(Me, "inp")
        c13.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c13.LabelAbove = "Password"
        c13.IconLeft = "key-solid.svg"
        c13.IconRight = "eye-solid.svg"
        c13.InputType = "password"
        c13.Placeholder = "Enter password"
        c13.HintText = "Must be more than 8 characters, including at least one number and one uppercase letter"
        c13.Tag = "input-password"
        Samples.Add(c13)

        '-
        'Example 14: Number input with label above
        '-
        AddSectionTitle("Number input")
        Dim c14 As B4XDaisyInput
        c14.Initialize(Me, "inp")
        c14.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c14.LabelAbove = "Age"
        c14.InputType = "number"
        c14.Placeholder = "Type a number between 1 to 10"
        c14.HintText = "Must be between 1 to 10"
        c14.Tag = "input-number"
        Samples.Add(c14)

        '-
        'Example 15: Phone input with icon and label above
        '-
        AddSectionTitle("Phone input with icon")
        Dim c15 As B4XDaisyInput
        c15.Initialize(Me, "inp")
        c15.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c15.LabelAbove = "Phone"
        c15.IconLeft = "phone-solid.svg"
        c15.InputType = "phone"
        c15.Placeholder = "Enter phone number"
        c15.HintText = "Must be 10 digits"
        c15.Tag = "input-phone"
        Samples.Add(c15)

        '-
        'Example 15 (Part 2): Clickable icons
        '-
        AddSectionTitle("Clickable icons")

        Dim c16a As B4XDaisyInput
        c16a.Initialize(Me, "inpClick")
        c16a.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16a.LabelAbove = "Email"
        c16a.IconLeft = "envelope-regular.svg"
        c16a.InputType = "email"
        c16a.Placeholder = "Tap envelope icon"
        c16a.HintText = "Click the envelope icon on the left"
        c16a.Tag = "input-email-clickable"
        Samples.Add(c16a)

        Dim c16b As B4XDaisyInput
        c16b.Initialize(Me, "inpClick")
        c16b.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16b.LabelAbove = "Password"
        c16b.IconLeft = "fingerprint-solid.svg"
        c16b.IconRight = "eye-solid.svg"
        c16b.InputType = "password"
        c16b.Placeholder = "Password hidden by default"
        c16b.HintText = "Tap right eye icon to toggle show/hide"
        c16b.Tag = "input-password-clickable"
        Samples.Add(c16b)

        Dim c16c As B4XDaisyInput
        c16c.Initialize(Me, "inpClick")
        c16c.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16c.LabelAbove = "Password"
        c16c.IconRight = "eye-solid.svg"
        c16c.InputType = "password"
        c16c.Placeholder = "Tap eye to reveal"
        c16c.HintText = "Internal toggle: dots <-> plain text"
        c16c.Tag = "input-password-toggle-only"
        Samples.Add(c16c)

        Dim c16d As B4XDaisyInput
        c16d.Initialize(Me, "inpClick")
        c16d.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16d.LabelAbove = "Phone"
        c16d.IconLeft = "phone-solid.svg"
        c16d.InputType = "phone"
        c16d.Placeholder = "Tap phone icon"
        c16d.HintText = "Click the phone icon on the left"
        c16d.Tag = "input-phone-clickable"
        Samples.Add(c16d)

        Dim c16e As B4XDaisyInput
        c16e.Initialize(Me, "inpClick")
        c16e.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16e.LabelAbove = "Date"
        c16e.IconLeft = "calendar-solid.svg"
        c16e.IconRight = "chevron-down-solid.svg"
        c16e.Placeholder = "Both icons clickable"
        c16e.HintText = "Left = PrependClick, Right = AppendClick"
        c16e.Tag = "input-both-icons-clickable"
        Samples.Add(c16e)

        '-
        'Example 17: URL input with icon and label above
        '-
        AddSectionTitle("URL input with icon")
        Dim c17 As B4XDaisyInput
        c17.Initialize(Me, "inp")
        c17.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c17.LabelAbove = "Website"
        c17.IconLeft = "link-solid.svg"
        c17.InputType = "url"
        c17.Placeholder = "https://"
        c17.HintText = "Must be valid URL"
        c17.Tag = "input-url"
        Samples.Add(c17)

        '-
        'Example 18: Multiline input
        '-
        AddSectionTitle("Multiline input")
        Dim c18 As B4XDaisyInput
        c18.Initialize(Me, "inpMulti")
        c18.SingleLine = False
        c18.AddToParent(pnlContent, PAGE_PAD, 0, maxW, 80dip)
        c18.LabelAbove = "Message"
        c18.Placeholder = "Type your message here..."
        c18.MaxLines = 4
        c18.Tag = "input-multiline"
        Samples.Add(c18)

        '-
        'Example 19: Search input (InputType = search)
        '-
        AddSectionTitle("Search input")
        Dim c19 As B4XDaisyInput
        c19.Initialize(Me, "inpSearch")
        c19.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c19.LabelAbove = "Search"
        c19.Placeholder = "Search..."
        c19.InputType = "search"
        c19.Variant = "neutral"
        c19.Tag = "input-search"
        Samples.Add(c19)

        '-
        'Example 20: Required field (red star)
        '-
        AddSectionTitle("Required field")
        Dim c20a As B4XDaisyInput
        c20a.Initialize(Me, "inp")
        c20a.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c20a.LabelAbove = "Full name"
        c20a.Placeholder = "Required field"
        c20a.Required = True
        c20a.Tag = "input-required"
        Samples.Add(c20a)

        Dim c20b As B4XDaisyInput
        c20b.Initialize(Me, "inp")
        c20b.AddToParent(pnlContent, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c20b.LabelAbove = "Email"
        c20b.FloatingLabel = True
        c20b.Placeholder = "you@example.com"
        c20b.Required = True
        c20b.InputType = "email"
        c20b.Tag = "input-required-floating"
        Samples.Add(c20b)
    End Sub

    Private Sub AddSectionTitle(Title As String)
        Dim lblTitle As B4XDaisyText
        lblTitle.Initialize(Me, "")
        lblTitle.AddToParent(pnlContent, PAGE_PAD, 0, 10dip, 28dip)
        lblTitle.Text = Title
        lblTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblTitle.TextSize = 16
        lblTitle.FontBold = True
        Samples.Add(lblTitle)
    End Sub
#End Region

#Region Layout
    ''' <summary>
    ''' Layouts all input samples sequentially down the PageScroll container.
    ''' </summary>
    Private Sub LayoutInputs(Width As Int, Height As Int)
        If pnlContent.IsInitialized = False Then Return
        If Samples.IsInitialized = False Then Return
        If Samples.Size = 0 Then Return

        Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
        Dim y As Int = PAGE_PAD

        For Each item As Object In Samples
            If item Is B4XDaisyText Then
                Dim txt As B4XDaisyText = item
                Dim titleH As Int = 28dip
                txt.SetLayoutAnimated(0, PAGE_PAD, y, maxW, titleH)
                y = y + titleH + 2dip
            Else If item Is B4XDaisyInput Then
                Dim inp As B4XDaisyInput = item
                inp.Base_Resize(maxW, 0)
                Dim actualH As Int = inp.GetActualHeight
                inp.View.SetLayoutAnimated(0, PAGE_PAD, y, maxW, actualH)
                y = y + actualH + ROW_GAP
            End If
        Next

        pnlContent.Height = Max(Height, y + PAGE_PAD)
    End Sub
#End Region

#Region Base Events
    Private Sub inp_TextChanged(Old As String, New As String)
    End Sub

    Private Sub inp_EnterPressed(Text As String)
        #If B4A
            B4XPages.MainPage.ShowToast("Enter pressed: " & Text, False)
        #End If
    End Sub

    Private Sub inp_FocusChanged(HasFocus As Boolean)
    End Sub

    Private Sub inp_Click(Tag As Object)
        #If B4A
            Dim s As String = Tag
            If s.Length = 0 Then s = "input"
            B4XPages.MainPage.ShowToast("Clicked: " & s, False)
        #End If
    End Sub

    Private Sub inpClick_PrependClick
        #If B4A
            B4XPages.MainPage.ShowToast("Prepend icon clicked (left icon)", False)
        #End If
    End Sub

    Private Sub inpClick_AppendClick
        #If B4A
            B4XPages.MainPage.ShowToast("Append icon clicked (right icon)", False)
        #End If
    End Sub

    Private Sub inpSearch_Clear
        #If B4A
            B4XPages.MainPage.ShowToast("Search cleared", False)
        #End If
    End Sub
#End Region
