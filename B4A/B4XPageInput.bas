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
        Private Sections As List   ' List of section Maps for reflow-in-place layout
        Private PAGE_PAD As Int = 12dip
        Private SECTION_GAP As Int = 24dip
        Private ITEM_HEIGHT As Int = 40dip
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
    ''' B4XPage Created event. Sets up the scrollable demo container.
    ''' </summary>
    Private Sub B4XPage_Created(Root1 As B4XView)
        Root = Root1

        svHost.Initialize(1dip)
        Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
        pnlHost = svHost.Panel
        pnlHost.Color = xui.Color_Transparent

        Sections.Initialize
    End Sub

    Private Sub B4XPage_Appear
        If Sections.Size = 0 Then
            CreateSamples
            LayoutInputs(Root.Width, Root.Height)
        End If
        CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    End Sub
#End Region

#Region Sample Creation
    ''' <summary>
    ''' Creates all DaisyUI Input examples from docs once.
    ''' Each section stores view references for reflow-in-place layout.
    ''' </summary>
    Private Sub CreateSamples
        Sections.Clear
        pnlHost.RemoveAllViews

        Dim maxW As Int = Max(220dip, Root.Width - (PAGE_PAD * 2))

        '============================================================
        'Example 1: Text input (base)
        '============================================================
        Dim sec1 As Map = BeginSection("Text input")
        Dim c1 As B4XDaisyInput
        c1.Initialize(Me, "inp")
        c1.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c1.LabelAbove = "Full name"
        c1.Placeholder = "Type here"
        c1.Tag = "base-text"
        AddRow(sec1, c1, 0)
        EndSection(sec1)

        '============================================================
        'Example 2: Text input with icons
        '============================================================
        Dim sec2 As Map = BeginSection("Input with icons")

        Dim c2a As B4XDaisyInput
        c2a.Initialize(Me, "inp")
        c2a.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2a.LabelAbove = "Search"
        c2a.IconLeft = "search-solid.svg"
        c2a.Placeholder = "Search"
        c2a.Tag = "input-search-icon"
        AddRow(sec2, c2a, 0)

        Dim c2b As B4XDaisyInput
        c2b.Initialize(Me, "inp")
        c2b.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2b.LabelAbove = "File"
        c2b.IconLeft = "file.svg"
        c2b.Placeholder = "index.php"
        c2b.Tag = "input-file-icon"
        AddRow(sec2, c2b, 0)

        Dim c2c As B4XDaisyInput
        c2c.Initialize(Me, "inp")
        c2c.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2c.LabelAbove = "Path"
        c2c.IconLeft = "folder-solid.svg"
        c2c.Placeholder = "src/app/"
        c2c.IconRight = "xmark-solid.svg"
        c2c.Tag = "input-path-icon"
        AddRow(sec2, c2c, 0)
        EndSection(sec2)

        '============================================================
        'Example 3: Ghost style
        '============================================================
        Dim sec3 As Map = BeginSection("Ghost style")
        Dim c3 As B4XDaisyInput
        c3.Initialize(Me, "inp")
        c3.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c3.LabelAbove = "Ghost input"
        c3.Variant = "ghost"
        c3.Placeholder = "Type here"
        c3.Tag = "input-ghost"
        AddRow(sec3, c3, 0)
        EndSection(sec3)

        '============================================================
        'Example 4: Input colors
        '============================================================
        Dim sec4 As Map = BeginSection("Input colors")
        Dim colorList As List
        colorList.Initialize
        colorList.AddAll(Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"))
        For i = 0 To colorList.Size - 1
            Dim v As String = colorList.Get(i)
            Dim cc As B4XDaisyInput
            cc.Initialize(Me, "cc" & i)
            cc.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
            cc.LabelAbove = v.SubString2(0, 1).ToUpperCase & v.SubString2(1, v.Length)
            cc.Variant = v
            cc.Placeholder = v
            cc.Tag = "color-" & v
            AddRow(sec4, cc, 0)
        Next
        EndSection(sec4)

        '============================================================
        'Example 5: Sizes
        '============================================================
        Dim sec5 As Map = BeginSection("Sizes")
        Dim sizeVals As List
        sizeVals.Initialize
        sizeVals.AddAll(Array As String("md", "lg", "xl"))
        Dim sizeLabels As List
        sizeLabels.Initialize
        sizeLabels.AddAll(Array As String("Medium", "Large", "Xlarge"))
        Dim sizeHeights As List
        sizeHeights.Initialize
        sizeHeights.AddAll(Array As Int(40dip, 48dip, 56dip))
        For i = 0 To sizeVals.Size - 1
            Dim sz As String = sizeVals.Get(i)
            Dim sl As String = sizeLabels.Get(i)
            Dim shgt As Int = sizeHeights.Get(i)
            Dim cs As B4XDaisyInput
            cs.Initialize(Me, "cs" & i)
            cs.AddToParent(pnlHost, PAGE_PAD, 0, maxW, shgt)
            cs.LabelAbove = sl
            cs.Size = sz
            cs.Placeholder = sl
            cs.Tag = "size-" & sz
            AddRow(sec5, cs, shgt)
        Next
        EndSection(sec5)

        '============================================================
        'Example 6: Disabled
        '============================================================
        Dim sec6 As Map = BeginSection("Disabled")
        Dim c6 As B4XDaisyInput
        c6.Initialize(Me, "inp")
        c6.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c6.LabelAbove = "Disabled"
        c6.Placeholder = "You can't touch this"
        c6.Enabled = False
        c6.Tag = "input-disabled"
        AddRow(sec6, c6, 0)
        EndSection(sec6)

        '============================================================
        'Example 7: Inline labels (left / right)
        '============================================================
        Dim sec7 As Map = BeginSection("Inline labels (left / right)")
        Dim c8a As B4XDaisyInput
        c8a.Initialize(Me, "inp")
        c8a.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c8a.LabelAbove = "URL"
        c8a.LabelLeft = "http://"
        c8a.Placeholder = "example.com"
        c8a.Tag = "input-label-left"
        AddRow(sec7, c8a, 0)

        Dim c8b As B4XDaisyInput
        c8b.Initialize(Me, "inp")
        c8b.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c8b.LabelAbove = "Website"
        c8b.LabelRight = ".com"
        c8b.Placeholder = "example"
        c8b.Tag = "input-label-right"
        AddRow(sec7, c8b, 0)
        EndSection(sec7)

        '============================================================
        'Example 8: Floating label (Label + FloatingLabel=True)
        '============================================================
        Dim sec8 As Map = BeginSection("Floating label")

        Dim c8 As B4XDaisyInput
        c8.Initialize(Me, "inp")
        c8.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c8.LabelAbove = "Full name"
        c8.FloatingLabel = True
        c8.Placeholder = "John Doe"
        c8.Tag = "input-floating-label"
        AddRow(sec8, c8, 0)
        EndSection(sec8)

        '============================================================
        'Example 10: Username input with icon and label above
        '============================================================
        Dim sec10 As Map = BeginSection("Username input with icon")
        Dim c10 As B4XDaisyInput
        c10.Initialize(Me, "inp")
        c10.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c10.LabelAbove = "Username"
        c10.IconLeft = "user-solid.svg"
        c10.Placeholder = "Type your username"
        c10.HintText = "Must be 3 to 30 characters containing only letters, numbers or dash"
        c10.Tag = "input-username"
        AddRow(sec10, c10, 0)
        EndSection(sec10)

        '============================================================
        'Example 11: Email input with icon and label above
        '============================================================
        Dim sec11 As Map = BeginSection("Email input with icon")
        Dim c11 As B4XDaisyInput
        c11.Initialize(Me, "inp")
        c11.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c11.LabelAbove = "Email"
        c11.IconLeft = "envelope-regular.svg"
        c11.InputType = "email"
        c11.Placeholder = "mail@site.com"
        c11.HintText = "Enter valid email address"
        c11.Tag = "input-email"
        AddRow(sec11, c11, 0)
        EndSection(sec11)

        '============================================================
        'Example 12: Password input with icon and label above
        '============================================================
        Dim sec12 As Map = BeginSection("Password input with icon")
        Dim c13 As B4XDaisyInput
        c13.Initialize(Me, "inp")
        c13.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c13.LabelAbove = "Password"
        c13.IconLeft = "key-solid.svg"
        c13.IconRight = "eye-solid.svg"
        c13.InputType = "password"
        c13.Placeholder = "Enter password"
        c13.HintText = "Must be more than 8 characters, including at least one number and one uppercase letter"
        c13.Tag = "input-password"
        AddRow(sec12, c13, 0)
        EndSection(sec12)

        '============================================================
        'Example 14: Number input with label above
        '============================================================
        Dim sec13 As Map = BeginSection("Number input")
        Dim c14 As B4XDaisyInput
        c14.Initialize(Me, "inp")
        c14.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c14.LabelAbove = "Age"
        c14.InputType = "number"
        c14.Placeholder = "Type a number between 1 to 10"
        c14.HintText = "Must be between 1 to 10"
        c14.Tag = "input-number"
        AddRow(sec13, c14, 0)
        EndSection(sec13)

        '============================================================
        'Example 15: Phone input with icon and label above
        '============================================================
        Dim sec14 As Map = BeginSection("Phone input with icon")
        Dim c15 As B4XDaisyInput
        c15.Initialize(Me, "inp")
        c15.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c15.LabelAbove = "Phone"
        c15.IconLeft = "phone-solid.svg"
        c15.InputType = "phone"
        c15.Placeholder = "Enter phone number"
        c15.HintText = "Must be 10 digits"
        c15.Tag = "input-phone"
        AddRow(sec14, c15, 0)
        EndSection(sec14)

        '============================================================
        'Example 15: Clickable icons
        '============================================================
        Dim sec15 As Map = BeginSection("Clickable icons")

        Dim c16a As B4XDaisyInput
        c16a.Initialize(Me, "inpClick")
        c16a.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16a.LabelAbove = "Email"
        c16a.IconLeft = "envelope-regular.svg"
        c16a.InputType = "email"
        c16a.Placeholder = "Tap envelope icon"
        c16a.HintText = "Click the envelope icon on the left"
        c16a.Tag = "input-email-clickable"
        AddRow(sec15, c16a, 0)

        Dim c16b As B4XDaisyInput
        c16b.Initialize(Me, "inpClick")
        c16b.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16b.LabelAbove = "Password"
        c16b.IconLeft = "fingerprint-solid.svg"
        c16b.IconRight = "eye-solid.svg"
        c16b.InputType = "password"
        c16b.Placeholder = "Password hidden by default"
        c16b.HintText = "Tap right eye icon to toggle show/hide"
        c16b.Tag = "input-password-clickable"
        AddRow(sec15, c16b, 0)

        Dim c16c As B4XDaisyInput
        c16c.Initialize(Me, "inpClick")
        c16c.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16c.LabelAbove = "Password"
        c16c.IconRight = "eye-solid.svg"
        c16c.InputType = "password"
        c16c.Placeholder = "Tap eye to reveal"
        c16c.HintText = "Internal toggle: dots <-> plain text"
        c16c.Tag = "input-password-toggle-only"
        AddRow(sec15, c16c, 0)

        Dim c16d As B4XDaisyInput
        c16d.Initialize(Me, "inpClick")
        c16d.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16d.LabelAbove = "Phone"
        c16d.IconLeft = "phone-solid.svg"
        c16d.InputType = "phone"
        c16d.Placeholder = "Tap phone icon"
        c16d.HintText = "Click the phone icon on the left"
        c16d.Tag = "input-phone-clickable"
        AddRow(sec15, c16d, 0)

        Dim c16e As B4XDaisyInput
        c16e.Initialize(Me, "inpClick")
        c16e.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c16e.LabelAbove = "Date"
        c16e.IconLeft = "calendar-solid.svg"
        c16e.IconRight = "chevron-down-solid.svg"
        c16e.Placeholder = "Both icons clickable"
        c16e.HintText = "Left = PrependClick, Right = AppendClick"
        c16e.Tag = "input-both-icons-clickable"
        AddRow(sec15, c16e, 0)
        EndSection(sec15)

        '============================================================
        'Example 17: URL input with icon and label above
        '============================================================
        Dim sec16 As Map = BeginSection("URL input with icon")
        Dim c17 As B4XDaisyInput
        c17.Initialize(Me, "inp")
        c17.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c17.LabelAbove = "Website"
        c17.IconLeft = "link-solid.svg"
        c17.InputType = "url"
        c17.Placeholder = "https://"
        c17.HintText = "Must be valid URL"
        c17.Tag = "input-url"
        AddRow(sec16, c17, 0)
        EndSection(sec16)

        '============================================================
        'Example 18: Multiline input
        '============================================================
        Dim sec18 As Map = BeginSection("Multiline input")
        Dim c18 As B4XDaisyInput
        c18.Initialize(Me, "inpMulti")
        c18.SingleLine = False
        c18.AddToParent(pnlHost, PAGE_PAD, 0, maxW, 80dip)
        c18.LabelAbove = "Message"
        c18.Placeholder = "Type your message here..."
        c18.MaxLines = 4
        c18.Tag = "input-multiline"
        AddRow(sec18, c18, 0)
        EndSection(sec18)

        '============================================================
        'Example 19: Search input (InputType = search)
        '============================================================
        Dim sec19 As Map = BeginSection("Search input")
        Dim c19 As B4XDaisyInput
        c19.Initialize(Me, "inpSearch")
        c19.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c19.LabelAbove = "Search"
        c19.Placeholder = "Search..."
        c19.InputType = "search"
        c19.Variant = "neutral"
        c19.Tag = "input-search"
        AddRow(sec19, c19, 0)
        EndSection(sec19)

        '============================================================
        'Example 20: Required field (red star)
        '============================================================
        Dim sec20 As Map = BeginSection("Required field")
        Dim c20a As B4XDaisyInput
        c20a.Initialize(Me, "inp")
        c20a.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c20a.LabelAbove = "Full name"
        c20a.Placeholder = "Required field"
        c20a.Required = True
        c20a.Tag = "input-required"
        AddRow(sec20, c20a, 0)

        ' Floating label also shows the red star
        Dim c20b As B4XDaisyInput
        c20b.Initialize(Me, "inp")
        c20b.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c20b.LabelAbove = "Email"
        c20b.FloatingLabel = True
        c20b.Placeholder = "you@example.com"
        c20b.Required = True
        c20b.InputType = "email"
        c20b.Tag = "input-required-floating"
        AddRow(sec20, c20b, 0)
        EndSection(sec20)
    End Sub

    ''' <summary>
    ''' Starts a new section. Returns a Map that accumulates rows.
    ''' </summary>
    Private Sub BeginSection(Title As String) As Map
        Dim sec As Map
        sec.Initialize
        Dim lblTitle As B4XDaisyText
        lblTitle.Initialize(Me, "")
        lblTitle.AddToParent(pnlHost, PAGE_PAD, 0, 10dip, 28dip)
        lblTitle.Text = Title
        lblTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblTitle.TextSize = 16
        lblTitle.FontBold = True
        sec.Put("title", lblTitle)
        Dim rows As List
        rows.Initialize
        sec.Put("rows", rows)
        Return sec
    End Sub

    ''' <summary>
    ''' Adds a component row (input or label) to the current section.
    ''' Height defaults to the component's computed height if not specified.
    ''' </summary>
    Private Sub AddRow(Sec As Map, Comp As Object, RowH As Int)
        Dim rows As List = Sec.Get("rows")
        Dim rowMap As Map
        rowMap.Initialize
        Dim v As B4XView
        If Comp Is B4XDaisyInput Then
            Dim inp As B4XDaisyInput = Comp
            v = inp.getView
            If RowH <= 0 Then RowH = inp.GetComputedHeight
        Else If Comp Is B4XDaisyLabel Then
            Dim lbl As B4XDaisyLabel = Comp
            v = lbl.getView
            If RowH <= 0 Then RowH = v.Height
        End If
        rowMap.Put("view", v)
        rowMap.Put("comp", Comp)
        rowMap.Put("h", RowH)
        rows.Add(rowMap)
    End Sub

    ''' <summary>
    ''' Adds a flex panel row (join pattern) to the current section.
    ''' Stores the flex panel and its children for proper resizing.
    ''' </summary>
    Private Sub AddRowFlex(Sec As Map, Flex As B4XDaisyFlexPanel, Inp As B4XDaisyInput, Btn As B4XDaisyButton)
        Dim rows As List = Sec.Get("rows")
        Dim rowMap As Map
        rowMap.Initialize
        rowMap.Put("view", Flex.getView)
        rowMap.Put("comp", Flex)
        rowMap.Put("h", ITEM_HEIGHT)
        rowMap.Put("type", "flex")
        rowMap.Put("flex", Flex)
        rowMap.Put("input", Inp)
        rowMap.Put("input_view", Inp.getView)
        rowMap.Put("button", Btn)
        rowMap.Put("button_view", Btn.getView)
        rows.Add(rowMap)
    End Sub

    ''' <summary>
    ''' Finalizes a section and adds it to the Sections list.
    ''' </summary>
    Private Sub EndSection(Sec As Map)
        Sections.Add(Sec)
    End Sub
#End Region

#Region Layout
    ''' <summary>
    ''' Reflow-in-place layout: repositions all stored views without destroying them.
    ''' Preserves user state (text, focus, validation) across layout changes.
    ''' </summary>
    Private Sub LayoutInputs(Width As Int, Height As Int)
        If pnlHost.IsInitialized = False Then Return
        If Sections.IsInitialized = False Then Return
        If Sections.Size = 0 Then Return

        Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
        Dim y As Int = PAGE_PAD

        For si = 0 To Sections.Size - 1
            Dim sec As Map = Sections.Get(si)
            Dim lblTitle As B4XDaisyText = sec.Get("title")
            Dim rows As List = sec.Get("rows")

            ' Position section title
            If lblTitle <> Null Then
                Dim titleH As Int = 28dip
                lblTitle.SetLayoutAnimated(0, PAGE_PAD, y, maxW, titleH)
                y = y + titleH + 2dip
            End If

            ' Position each row in the section
            For ri = 0 To rows.Size - 1
                Dim row As Map = rows.Get(ri)
                Dim rv As B4XView = row.Get("view")
                Dim rh As Int = row.Get("h")
                Dim rowType As String = row.GetDefault("type", "standard")
                Dim isLastRow As Boolean = (ri = rows.Size - 1)

                If rowType = "flex" Then
                    ' Flex panel (join pattern): resize flex and children
                    Dim flex As B4XDaisyFlexPanel = row.Get("flex")
                    Dim inpView As B4XView = row.Get("input_view")
                    Dim btnView As B4XView = row.Get("button_view")
                    Dim inpComp As B4XDaisyInput = row.Get("input")
                    Dim btnComp As B4XDaisyButton = row.Get("button")
                    Dim flexW As Int = maxW
                    Dim inputW As Int = flexW - 80dip

                    ' Let Base_Resize compute correct heights
                    inpComp.Base_Resize(inputW, 0)
                    Dim inputH As Int = inpComp.GetActualHeight
                    Dim btnH As Int = btnComp.GetComputedHeight
                    Dim flexH As Int = Max(inputH, btnH)

                    ' Resize children inside flex
                    inpView.SetLayoutAnimated(0, 0, 0, inputW, inputH)
                    btnView.SetLayoutAnimated(0, 0, 0, 80dip, btnH)

                    ' Resize flex panel itself and notify
                    rv.SetLayoutAnimated(0, PAGE_PAD, y, flexW, flexH)
                    flex.Base_Resize(flexW, flexH)

                    y = y + flexH
                Else
                    ' Standard row (input or label)
                    Dim comp As Object = row.Get("comp")
                    Dim actualH As Int = rh

                    If comp Is B4XDaisyInput Then
                        ' B4XDaisyInput.Base_Resize computes the correct total
                        ' height (including label-above, hint text, etc.)
                        Dim inp As B4XDaisyInput = comp
                        inp.Base_Resize(maxW, 0)
                        actualH = inp.GetActualHeight
                        ' Reposition view at computed height
                        rv.SetLayoutAnimated(0, PAGE_PAD, y, maxW, actualH)
                    Else If comp Is B4XDaisyLabel Then
                        ' B4XDaisyLabel: auto-height when rh <= 0, otherwise fixed height
                        Dim lbl As B4XDaisyLabel = comp
                        If rh <= 0 Then
                            lbl.Base_Resize(maxW, 0)
                            actualH = lbl.GetActualHeight
                        Else
                            lbl.Base_Resize(maxW, rh)
                            actualH = rh
                        End If
                        rv.SetLayoutAnimated(0, PAGE_PAD, y, maxW, actualH)
                    End If

                    y = y + actualH
                End If

                ' Gap after row
                If isLastRow Then
                    y = y + SECTION_GAP
                Else
                    y = y + 8dip
                End If
            Next
        Next

        pnlHost.Height = Max(Height, y + PAGE_PAD)
    End Sub

    Private Sub B4XPage_Resize(Width As Int, Height As Int)
        If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
        LayoutInputs(Width, Height)
    End Sub
#End Region

#Region Base Events
    Private Sub inp_TextChanged(Old As String, New As String)
        ' Text changed event feedback - logged for debugging
    End Sub

    Private Sub inp_EnterPressed(Text As String)
        #If B4A
            B4XPages.MainPage.ShowToast("Enter pressed: " & Text, False)
        #End If
    End Sub

    Private Sub inp_FocusChanged(HasFocus As Boolean)
        ' Focus change feedback - can be used for validation
    End Sub

    Private Sub inp_Click(Tag As Object)
        #If B4A
            Dim s As String = Tag
            If s.Length = 0 Then s = "input"
            B4XPages.MainPage.ShowToast("Clicked: " & s, False)
        #End If
    End Sub

    ' Clickable icon click handlers
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