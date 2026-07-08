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
    Private PAGE_PAD As Int = 12dip
    Private SECTION_GAP As Int = 14dip
    Private EXAMPLE_GAP As Int = 10dip

    ' Interactive demo input used to demonstrate the Click + FileSelected flow.
    Private interactiveInput As B4XDaisyFileInput
    Private pickCycle As List
    Private pickIndex As Int = 0
End Sub
#End Region

#Region Initialization
' Initializes the demo page.
Public Sub Initialize As Object
    Return Me
End Sub

' B4XPage Created event.
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    pickCycle.Initialize
    pickCycle.Add("invoice-2026-06.pdf")
    pickCycle.Add("photo-profile.png")
    pickCycle.Add("report-quarterly.xlsx")

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
' Renders all DaisyUI file-input examples linearly down the scroll host.
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ' #region Example 1: Base (default)
    y = AddSectionTitle("File input", y, maxW)
    Dim c1 As B4XDaisyFileInput
    c1.Initialize(Me, "component")
    c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    c1.LabelAbove = "Default file input"
    c1.Tag = c1
    y = y + c1.GetComputedHeight + EXAMPLE_GAP
    ' #endregion

    ' #region Example 2: Ghost style
    y = AddSectionTitle("File input ghost", y, maxW)
    Dim c2 As B4XDaisyFileInput
    c2.Initialize(Me, "component")
    c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    c2.LabelAbove = "Ghost file input"
    c2.Style = "ghost"
    c2.Tag = c2
    y = y + c2.GetComputedHeight + EXAMPLE_GAP
    ' #endregion

    ' #region Example 3: With label above and hint (fieldset + label composition)
    y = AddSectionTitle("With label and hint", y, maxW)
    Dim c3 As B4XDaisyFileInput
    c3.Initialize(Me, "component")
    c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    c3.LabelAbove = "Pick a file"
    c3.HintText = "Max size 2MB"
    c3.Tag = c3
    y = y + c3.GetComputedHeight + SECTION_GAP
    ' #endregion

    ' #region Example 4: Sizes
    y = AddSectionTitle("Sizes", y, maxW)
    Dim sizes() As String = Array As String("md", "lg", "xl")
    For Each sz As String In sizes
        Dim cs As B4XDaisyFileInput
        cs.Initialize(Me, "component")
        cs.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip(sz))
        cs.LabelAbove = SizeLabel(sz)
        cs.Size = sz
        cs.Tag = cs
        y = y + cs.GetComputedHeight + EXAMPLE_GAP
    Next
    y = y - EXAMPLE_GAP + SECTION_GAP
    ' #endregion

    ' #region Example 5: Primary color (full variant palette)
    y = AddSectionTitle("Primary color", y, maxW)
    Dim variants() As String = Array As String("primary", "secondary", "accent", "neutral", "info", "success", "warning", "error")
    For Each v As String In variants
        Dim cv As B4XDaisyFileInput
        cv.Initialize(Me, "component")
        cv.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
        cv.LabelAbove = CapitalCase(v)
        cv.Variant = v
        cv.Tag = cv
        y = y + cv.GetComputedHeight + EXAMPLE_GAP
    Next
    y = y - EXAMPLE_GAP + SECTION_GAP
    ' #endregion

    ' #region Example 6: Disabled
    y = AddSectionTitle("Disabled", y, maxW)
    Dim c6 As B4XDaisyFileInput
    c6.Initialize(Me, "component")
    c6.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    c6.LabelAbove = "Disabled"
    c6.Placeholder = "You can't touch this"
    c6.Enabled = False
    c6.Tag = c6
    y = y + c6.GetComputedHeight + SECTION_GAP
    ' #endregion

    ' #region Example 7: Error state (derived ErrorText property)
    y = AddSectionTitle("Error state", y, maxW)
    Dim c7 As B4XDaisyFileInput
    c7.Initialize(Me, "component")
    c7.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    c7.LabelAbove = "Upload your ID document"
    c7.FileName = "id-blurred.png"
    c7.ErrorText = "Image is too blurry. Please re-capture."
    c7.Tag = c7
    y = y + c7.GetComputedHeight + SECTION_GAP
    ' #endregion

    ' #region Example 8: Interactive (tap to simulate picking a file)
    y = AddSectionTitle("Interactive (tap to pick a file)", y, maxW)
    interactiveInput.Initialize(Me, "picker")
    interactiveInput.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    interactiveInput.LabelAbove = "Profile photo"
    interactiveInput.HintText = "Tap to choose a file (Max 2MB)"
    interactiveInput.MaxSize = 2
    interactiveInput.Variant = "primary"
    interactiveInput.Tag = interactiveInput
    y = y + interactiveInput.GetComputedHeight + EXAMPLE_GAP
    ' #endregion

    ' #region Example 9: Required (red star on label above)
    y = AddSectionTitle("Required", y, maxW)
    Dim c9 As B4XDaisyFileInput
    c9.Initialize(Me, "component")
    c9.AddToParent(pnlHost, PAGE_PAD, y, maxW, SizeHeightDip("md"))
    c9.LabelAbove = "Upload your ID document"
    c9.HintText = "A file must be selected"
    c9.Required = True
    c9.Variant = "primary"
    c9.Tag = c9
    y = y + c9.GetComputedHeight + EXAMPLE_GAP
    ' #endregion

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

' Spawns a stylized section header using B4XDaisyText.
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 30dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + 32dip
End Sub

' Maps a file-input size token to a human-readable label for the demo.
Private Sub SizeLabel(Size As String) As String
    Select Case Size.ToLowerCase
        Case "md"
            Return "Medium"
        Case "lg"
            Return "Large"
        Case "xl"
            Return "Extra large"
        Case Else
            Return Size
    End Select
End Sub

' Capitalizes the first letter of a value (used for variant labels).
Private Sub CapitalCase(Value As String) As String
    If Value = Null Or Value.Length = 0 Then Return ""
    Dim first As String = Value.SubString2(0, 1).ToUpperCase
    Return first & Value.SubString(1)
End Sub

' Maps a file-input size token to the component height (dip) for layout.
Private Sub SizeHeightDip(Size As String) As Int
    Select Case Size.ToLowerCase
        Case "md"
            Return 40dip
        Case "lg"
            Return 48dip
        Case "xl"
            Return 56dip
        Case Else
            Return 40dip
    End Select
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub component_Click(Tag As Object)
    #If Not(B4A)
    If Tag Is B4XDaisyFileInput Then
        Dim comp As B4XDaisyFileInput = Tag
        SimulateSelection(comp)
    End If
    #End If
End Sub

Private Sub picker_Click(Tag As Object)
    #If Not(B4A)
    SimulateSelection(interactiveInput)
    #End If
End Sub

Private Sub SimulateSelection(comp As B4XDaisyFileInput)
    If pickCycle.IsInitialized = False Or pickCycle.Size = 0 Then Return
    Dim name As String = pickCycle.Get(pickIndex Mod pickCycle.Size)
    pickIndex = pickIndex + 1
    comp.setFileName(name)
    comp.setFileSize(1500000) ' 1.5MB
    comp.setFileDate(DateTime.Now)
    If name.EndsWith(".pdf") Then
        comp.setMimeType("application/pdf")
    Else If name.EndsWith(".png") Then
        comp.setMimeType("image/png")
    Else
        comp.setMimeType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    End If
    comp.setFileBase64("U2l0aGFzb0RhaXN5VUlLaXQ=")
    
    If comp.ExceedsSize Then
        comp.ShowError("File size limit exceeded (" & comp.MaxSize & "MB max)")
    Else
        If comp.getErrorText.Length > 0 Then comp.ClearError
    End If
    
    #If B4A
    ' This block is empty because simulation is B4J-only
    #Else
    If comp = interactiveInput Then
        picker_FileSelected(name)
    Else
        component_FileSelected(name)
    End If
    #End If
End Sub

Private Sub component_FileSelected(FileName As String)
    #If B4A
    Dim comp As B4XDaisyFileInput = Sender
    If comp.ExceedsSize Then
        ToastMessageShow("Error: File size limit exceeded!", True)
    Else
        Dim details As String = "Selected: " & comp.FileName & CRLF & _
                                "Size: " & comp.FileSize & " bytes" & CRLF & _
                                "Type: " & comp.MimeType & CRLF & _
                                "Extension: " & comp.Extension
        ToastMessageShow(details, True)
    End If
    #Else
    #End If
End Sub

Private Sub component_Cancelled
    #If B4A
    ToastMessageShow("File selection cancelled", False)
    #End If
End Sub

Private Sub picker_FileSelected(FileName As String)
    #If B4A
    If interactiveInput.ExceedsSize Then
        ToastMessageShow("Error: File size limit exceeded!", True)
    Else
        Dim details As String = "Selected: " & interactiveInput.FileName & CRLF & _
                                "Size: " & interactiveInput.FileSize & " bytes" & CRLF & _
                                "Type: " & interactiveInput.MimeType & CRLF & _
                                "Extension: " & interactiveInput.Extension
        ToastMessageShow(details, True)
    End If
    #Else
    #End If
End Sub

Private Sub picker_Cancelled
    #If B4A
    ToastMessageShow("Interactive file selection cancelled", False)
    #End If
End Sub
#End Region