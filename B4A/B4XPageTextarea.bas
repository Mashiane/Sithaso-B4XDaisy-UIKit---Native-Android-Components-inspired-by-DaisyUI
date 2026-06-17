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
        Private Sections As List   ' List of section Maps for reflow-in-place layout
        Private PAGE_PAD As Int = 12dip
        Private SECTION_GAP As Int = 24dip
        Private ITEM_HEIGHT As Int = 80dip ' Standard height for textareas
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
        Root.Color = xui.Color_RGB(245, 247, 250)
        B4XPages.SetTitle(Me, "Textarea")

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
    ''' Creates all DaisyUI Textarea examples using B4XDaisyInput in multiline mode.
    ''' Each section stores view references for reflow-in-place layout.
    ''' </summary>
    Private Sub CreateSamples
        Sections.Clear
        pnlHost.RemoveAllViews

        Dim maxW As Int = Max(220dip, Root.Width - (PAGE_PAD * 2))

        '============================================================
        'Example 1: Textarea (base example)
        '============================================================
        Dim sec1 As Map = BeginSection("Textarea")
        Dim c1 As B4XDaisyInput
        c1.Initialize(Me, "txt")
        c1.SingleLine = False
        c1.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c1.Placeholder = "Bio"
        c1.MaxLines = 2
        c1.Tag = "base-textarea"
        AddRow(sec1, c1, 0)
        EndSection(sec1)

        '============================================================
        'Example 2: Ghost style (no background)
        '============================================================
        Dim sec2 As Map = BeginSection("Ghost style")
        Dim c2 As B4XDaisyInput
        c2.Initialize(Me, "txt")
        c2.SingleLine = False
        c2.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c2.Variant = "ghost"
        c2.Placeholder = "Bio"
        c2.MaxLines = 2
        c2.Tag = "ghost-textarea"
        AddRow(sec2, c2, 0)
        EndSection(sec2)

        '============================================================
        'Example 3: With form control and labels (fieldset pattern)
        '============================================================
        Dim sec3 As Map = BeginSection("With form control and labels")
        Dim c3 As B4XDaisyInput
        c3.Initialize(Me, "txt")
        c3.SingleLine = False
        c3.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c3.LabelAbove = "Your bio"
        c3.Placeholder = "Bio"
        c3.HintText = "Optional"
        c3.MaxLines = 2
        c3.Tag = "labeled-textarea"
        AddRow(sec3, c3, 0)
        EndSection(sec3)

        '============================================================
        'Example 4: Textarea colors
        '============================================================
        Dim sec4 As Map = BeginSection("Textarea colors")
        Dim colorList As List
        colorList.Initialize
        colorList.AddAll(Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"))
        For i = 0 To colorList.Size - 1
            Dim v As String = colorList.Get(i)
            Dim cc As B4XDaisyInput
            cc.Initialize(Me, "cc" & i)
            cc.SingleLine = False
            cc.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
            cc.Variant = v
            cc.Placeholder = v.SubString2(0, 1).ToUpperCase & v.SubString2(1, v.Length)
            cc.MaxLines = 2
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
        For i = 0 To sizeVals.Size - 1
            Dim sz As String = sizeVals.Get(i)
            Dim sl As String = sizeLabels.Get(i)
            Dim cs As B4XDaisyInput
            cs.Initialize(Me, "cs" & i)
            cs.SingleLine = False
            cs.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
            cs.Size = sz
            cs.Placeholder = sl
            cs.MaxLines = 3
            cs.Tag = "size-" & sz
            AddRow(sec5, cs, 0)
        Next
        EndSection(sec5)

        '============================================================
        'Example 6: Disabled
        '============================================================
        Dim sec6 As Map = BeginSection("Disabled")
        Dim c6 As B4XDaisyInput
        c6.Initialize(Me, "txt")
        c6.SingleLine = False
        c6.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c6.Placeholder = "Bio"
        c6.MaxLines = 2
        c6.Enabled = False
        c6.Tag = "disabled-textarea"
        AddRow(sec6, c6, 0)
        EndSection(sec6)

        '============================================================
        'Example 7: Auto-grow / Auto-height
        '============================================================
        Dim sec7 As Map = BeginSection("Auto-grow textarea")
        Dim c7 As B4XDaisyInput
        c7.Initialize(Me, "txtAuto")
        c7.SingleLine = False
        c7.AddToParent(pnlHost, PAGE_PAD, 0, maxW, ITEM_HEIGHT)
        c7.Placeholder = "Type here and press Enter to add more lines..."
        c7.MaxLines = 6
        c7.AutoHeight = True
        c7.Tag = "auto-height-textarea"
        AddRow(sec7, c7, 0)
        EndSection(sec7)
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
    ''' Adds a component row to the current section.
    ''' </summary>
    Private Sub AddRow(Sec As Map, Comp As B4XDaisyInput, RowH As Int)
        Dim rows As List = Sec.Get("rows")
        Dim rowMap As Map
        rowMap.Initialize
        Dim v As B4XView = Comp.mBase
        If RowH <= 0 Then RowH = Comp.GetComputedHeight
        rowMap.Put("view", v)
        rowMap.Put("comp", Comp)
        rowMap.Put("h", RowH)
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
    ''' Reflow-in-place layout.
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
                Dim isLastRow As Boolean = (ri = rows.Size - 1)

                Dim inp As B4XDaisyInput = row.Get("comp")
                inp.Base_Resize(maxW, rh)
                Dim actualH As Int = inp.mBase.Height
                rv.SetLayoutAnimated(0, PAGE_PAD, y, maxW, actualH)
                y = y + actualH

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
    Private Sub txt_TextChanged(Old As String, New As String)
    End Sub

    Private Sub txt_FocusChanged(HasFocus As Boolean)
    End Sub

    Private Sub txt_Click(Tag As Object)
    End Sub

    Private Sub txtAuto_TextChanged(Old As String, New As String)
        LayoutInputs(Root.Width, Root.Height)
    End Sub
#End Region
