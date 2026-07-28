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
    Private mContentHeight As Int = 0
    Private mRendered As Boolean = False
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
''' B4XPage Created event. Sets up the ScrollView host only.
''' Rendering is deferred to B4XPage_Appear so Root dimensions are valid.
''' Matches the proven B4XPageInput pattern (svHost.Initialize 1dip, render on Appear).
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1

    Try
        svHost.Initialize(1dip)
        Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
        pnlHost = svHost.Panel
        pnlHost.Color = xui.Color_Transparent
        B4XDaisyVariants.DisableClippingRecursive(pnlHost)
    Catch
        Log("B4XPageSelect.B4XPage_Created: " & LastException.Message)
        B4XPages.MainPage.ShowToast("Select page error: " & LastException.Message, True)
    End Try
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI Select examples with full variant, size, and state coverage.
''' Follows DaisyUI docs parity: base, ghost, 8 color variants, 3 sizes, disabled,
''' programmatic selection, label-above, hint-text.
''' Each example follows: Initialize ? AddToParent ? idiomatic property assignments.
''' All examples include LabelAbove for consistency.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ' -------------------------------------------------------
    ' Example 1: Base / Default select (DaisyUI Example 1)
    ' Demonstrates: default select with no variant
    ' -------------------------------------------------------
    y = AddSectionTitle("Base (Default)", y, maxW)
    Dim c1 As B4XDaisySelect
    c1.Initialize(Me, "sel1")
    c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c1.Items = CreateMap("crimson": "Crimson", "amber": "Amber", "velvet": "Velvet")
    c1.Placeholder = "Pick a color"
    c1.LabelAbove = "Color"
    c1.Tag = "base"
    y = y + c1.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 2: Ghost style select (DaisyUI Example 2)
    ' Demonstrates: transparent background, border hidden until focus
    ' -------------------------------------------------------
    y = AddSectionTitle("Ghost", y, maxW)
    Dim c2 As B4XDaisySelect
    c2.Initialize(Me, "sel2")
    c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c2.Items = CreateMap("inter": "Inter", "poppins": "Poppins", "raleway": "Raleway")
    c2.Placeholder = "Pick a font"
    c2.LabelAbove = "Font"
    c2.Variant = "ghost"
    c2.Tag = "ghost"
    y = y + c2.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 3: Primary color (DaisyUI Example 4)
    ' Demonstrates: primary color variant border
    ' -------------------------------------------------------
    y = AddSectionTitle("Primary", y, maxW)
    Dim c3 As B4XDaisySelect
    c3.Initialize(Me, "sel3")
    c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c3.Items = CreateMap("vscode": "VS Code", "vscode-fork": "VS Code fork", "another": "Another VS Code fork")
    c3.Placeholder = "Pick a text editor"
    c3.LabelAbove = "Text Editor"
    c3.Variant = "primary"
    c3.Tag = "primary"
    y = y + c3.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 4: Secondary color (DaisyUI Example 5)
    ' -------------------------------------------------------
    y = AddSectionTitle("Secondary", y, maxW)
    Dim c4 As B4XDaisySelect
    c4.Initialize(Me, "sel4")
    c4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c4.Items = CreateMap("zig": "Zig", "go": "Go", "rust": "Rust")
    c4.Placeholder = "Pick a language"
    c4.LabelAbove = "Language"
    c4.Variant = "secondary"
    c4.Tag = "secondary"
    y = y + c4.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 5: Accent color (DaisyUI Example 6)
    ' -------------------------------------------------------
    y = AddSectionTitle("Accent", y, maxW)
    Dim c5 As B4XDaisySelect
    c5.Initialize(Me, "sel5")
    c5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c5.Items = CreateMap("light": "Light mode", "dark": "Dark mode", "system": "System")
    c5.Placeholder = "Color scheme"
    c5.LabelAbove = "Theme"
    c5.Variant = "accent"
    c5.Tag = "accent"
    y = y + c5.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 6: Neutral color (DaisyUI Example 7)
    ' -------------------------------------------------------
    y = AddSectionTitle("Neutral", y, maxW)
    Dim c6 As B4XDaisySelect
    c6.Initialize(Me, "sel6")
    c6.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c6.Items = CreateMap("na": "North America", "euw": "EU West", "sea": "South East Asia")
    c6.Placeholder = "Server location"
    c6.LabelAbove = "Region"
    c6.Variant = "neutral"
    c6.Tag = "neutral"
    y = y + c6.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 7: Info color (DaisyUI Example 8)
    ' -------------------------------------------------------
    y = AddSectionTitle("Info", y, maxW)
    Dim c7 As B4XDaisySelect
    c7.Initialize(Me, "sel7")
    c7.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c7.Items = CreateMap("react": "React", "vue": "Vue", "angular": "Angular")
    c7.Placeholder = "Pick a Framework"
    c7.LabelAbove = "Framework"
    c7.Variant = "info"
    c7.Tag = "info"
    y = y + c7.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 8: Success color (DaisyUI Example 9)
    ' -------------------------------------------------------
    y = AddSectionTitle("Success", y, maxW)
    Dim c8 As B4XDaisySelect
    c8.Initialize(Me, "sel8")
    c8.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c8.Items = CreateMap("npm": "npm", "bun": "Bun", "yarn": "yarn")
    c8.Placeholder = "Pick a Runtime"
    c8.LabelAbove = "Runtime"
    c8.Variant = "success"
    c8.Tag = "success"
    y = y + c8.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 9: Warning color (DaisyUI Example 10)
    ' -------------------------------------------------------
    y = AddSectionTitle("Warning", y, maxW)
    Dim c9 As B4XDaisySelect
    c9.Initialize(Me, "sel9")
    c9.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c9.Items = CreateMap("win": "Windows", "mac": "MacOS", "linux": "Linux")
    c9.Placeholder = "Pick an OS"
    c9.LabelAbove = "OS"
    c9.Variant = "warning"
    c9.Tag = "warning"
    y = y + c9.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 10: Error color (DaisyUI Example 11)
    ' -------------------------------------------------------
    y = AddSectionTitle("Error", y, maxW)
    Dim c10 As B4XDaisySelect
    c10.Initialize(Me, "sel10")
    c10.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c10.Items = CreateMap("gpt4": "GPT-4", "claude": "Claude", "llama": "Llama")
    c10.Placeholder = "Pick an AI Model"
    c10.LabelAbove = "AI Model"
    c10.Variant = "error"
    c10.Tag = "error"
    y = y + c10.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 11: Sizes ? md(40), lg(48), xl(56)
    ' Demonstrates: DaisyUI size token heights (--size-field * N)
    ' DaisyUI Example 12
    ' -------------------------------------------------------
    y = AddSectionTitle("Sizes", y, maxW)

    ' md: --size-field * 10 = 40dip (default)
    Dim cMD As B4XDaisySelect
    cMD.Initialize(Me, "selMD")
    cMD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    cMD.Items = CreateMap("md-apple": "Medium Apple", "md-orange": "Medium Orange", "md-tomato": "Medium Tomato")
    cMD.Placeholder = "Medium"
    cMD.LabelAbove = "Medium"
    cMD.Size = "md"
    cMD.Tag = "size-md"
    y = y + cMD.GetComputedHeight + 8dip

    ' lg: --size-field * 12 = 48dip
    Dim cLG As B4XDaisySelect
    cLG.Initialize(Me, "selLG")
    cLG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    cLG.Items = CreateMap("lg-apple": "Large Apple", "lg-orange": "Large Orange", "lg-tomato": "Large Tomato")
    cLG.Placeholder = "Large"
    cLG.LabelAbove = "Large"
    cLG.Size = "lg"
    cLG.Tag = "size-lg"
    y = y + cLG.GetComputedHeight + 8dip

    ' xl: --size-field * 14 = 56dip
    Dim cXL As B4XDaisySelect
    cXL.Initialize(Me, "selXL")
    cXL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    cXL.Items = CreateMap("xl-apple": "XLarge Apple", "xl-orange": "XLarge Orange", "xl-tomato": "XLarge Tomato")
    cXL.Placeholder = "Xlarge"
    cXL.LabelAbove = "Extra Large"
    cXL.Size = "xl"
    cXL.Tag = "size-xl"
    y = y + cXL.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 12: Disabled (DaisyUI Example 13)
    ' Demonstrates: muted bg, muted text, no interaction
    ' -------------------------------------------------------
    y = AddSectionTitle("Disabled", y, maxW)
    Dim c12 As B4XDaisySelect
    c12.Initialize(Me, "sel12")
    c12.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c12.Items = CreateMap("no": "You can't touch this")
    c12.Placeholder = "Disabled select"
    c12.LabelAbove = "Disabled"
    c12.Enabled = False
    c12.Tag = "disabled"
    y = y + c12.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 13: Programmatic selection
    ' Demonstrates: SelectedIndex = 2 pre-selects "Gamma" before any user interaction
    ' -------------------------------------------------------
    y = AddSectionTitle("Programmatic Selection", y, maxW)
    Dim c13 As B4XDaisySelect
    c13.Initialize(Me, "sel13")
    c13.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c13.Items = CreateMap("alpha": "Alpha", "beta": "Beta", "gamma": "Gamma", "delta": "Delta")
    c13.Placeholder = "Pick a letter"
    c13.LabelAbove = "Greek Letter"
    c13.SelectedIndex = 2
    c13.Tag = "programmatic"
    y = y + c13.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 14: Label Above + Variant
    ' Demonstrates: optional label above the trigger with primary variant
    ' -------------------------------------------------------
    y = AddSectionTitle("Label Above + Primary", y, maxW)
    Dim c14 As B4XDaisySelect
    c14.Initialize(Me, "sel14")
    c14.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c14.Items = CreateMap("chrome": "Chrome", "firefox": "Firefox", "safari": "Safari", "edge": "Edge")
    c14.Placeholder = "Pick a browser"
    c14.LabelAbove = "Browser"
    c14.Variant = "primary"
    c14.Tag = "label-above"
    y = y + c14.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 15: Hint Text below
    ' Demonstrates: helper text rendered below the trigger
    ' -------------------------------------------------------
    y = AddSectionTitle("Label Above + Hint Text", y, maxW)
    Dim c15 As B4XDaisySelect
    c15.Initialize(Me, "sel15")
    c15.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c15.Items = CreateMap("usd": "USD", "eur": "EUR", "gbp": "GBP", "jpy": "JPY")
    c15.Placeholder = "Currency"
    c15.LabelAbove = "Currency"
    c15.HintText = "Select your preferred billing currency."
    c15.Tag = "hint-text"
    y = y + c15.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 16: Value/Text pairs (HTML select pattern)
    ' Demonstrates: AddItem(value, text) with distinct keys vs display labels
    ' -------------------------------------------------------
    y = AddSectionTitle("Value / Text Pairs", y, maxW)
    Dim c16 As B4XDaisySelect
    c16.Initialize(Me, "sel16")
    c16.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c16.AddItem("us", "United States")
    c16.AddItem("uk", "United Kingdom")
    c16.AddItem("de", "Germany")
    c16.AddItem("fr", "France")
    c16.AddItem("jp", "Japan")
    c16.AddItem("za", "South Africa")
    c16.Placeholder = "Pick a country"
    c16.LabelAbove = "Country"
    c16.Tag = "value-text"
    y = y + c16.GetComputedHeight + 16dip

    ' -------------------------------------------------------
    ' Example 17: Long list (scrolling test) + ActiveColor
    ' Demonstrates: 50 items to verify ScrollView and MaxDropdownRows,
    ' with the selected dropdown row highlighted in the primary variant.
    ' -------------------------------------------------------
    y = AddSectionTitle("Scrolling (50 items)", y, maxW)
    Dim c17 As B4XDaisySelect
    c17.Initialize(Me, "sel17")
    c17.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    Dim longItems As Map
    longItems.Initialize
    For i = 1 To 50
        longItems.Put("item" & i, "Item " & i)
    Next
    c17.Items = longItems
    c17.Placeholder = "Scroll through items"
    c17.LabelAbove = "Long List"
    c17.MaxDropdownRows = 6
    c17.ActiveColor = "primary"
    c17.SelectedIndex = 2
    c17.Tag = "scroll-test"
    y = y + c17.GetComputedHeight + 16dip

    ' ---------------------------------------------------------
    ' Example 18: ActiveColor - selected item highlight variant
    ' Demonstrates: a neutral-bordered select whose selected dropdown item
    ' uses the primary variant for its background + content color.
    ' Open the dropdown to see the pre-selected item highlighted in primary.
    ' ---------------------------------------------------------
    y = AddSectionTitle("ActiveColor (selected highlight)", y, maxW)
    Dim c18 As B4XDaisySelect
    c18.Initialize(Me, "sel18")
    c18.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c18.Items = CreateMap("alpha": "Alpha", "beta": "Beta", "gamma": "Gamma", "delta": "Delta")
    c18.Placeholder = "Pick a letter"
    c18.LabelAbove = "Greek Letter"
    c18.Variant = "neutral"
    c18.ActiveColor = "primary"
    c18.SelectedIndex = 2
    c18.Tag = "active-color"
    y = y + c18.GetComputedHeight + 16dip

    ' --------------------------------------------------------
    ' Example 19: Required select (red star on label)
    ' Demonstrates: Required = True shows a red star next to LabelAbove.
    ' --------------------------------------------------------
    y = AddSectionTitle("Required", y, maxW)
    Dim c19 As B4XDaisySelect
    c19.Initialize(Me, "sel19")
    c19.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    c19.Items = CreateMap("mobile": "Mobile", "home": "Home", "work": "Work")
    c19.Placeholder = "Select a phone type"
    c19.LabelAbove = "Phone type"
    c19.Required = True
    c19.Tag = "required"
    y = y + c19.GetComputedHeight + 16dip

    mContentHeight = Max(Height, y + PAGE_PAD)
    pnlHost.Height = mContentHeight
End Sub


''' <summary>
''' Spawns a stylized section header label above each demo block.
''' Returns the Y position after the header so the caller can chain examples.
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
Private Sub B4XPage_Appear
    If mRendered = False Then
        RenderExamples(Root.Width, Root.Height)
        mRendered = True
    End If
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

''' <summary>Handles selection change events from select components.</summary>
Private Sub sel1_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Selected - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel2_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Ghost - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel3_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Primary - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel4_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Secondary - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel5_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Accent - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel6_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Neutral - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel7_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Info - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel8_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Success - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel9_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Warning - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel10_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Error - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel12_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Disabled - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel13_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Pre-selected - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel14_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Browser - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel15_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Currency - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel16_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Country key - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub

Private Sub sel17_Changed(Index As Int, Key As String, Value As String)
    #If B4A
        B4XPages.MainPage.ShowToast("Item - Index: " & Index & ", Key: " & Key & ", Value: " & Value, False)
    #End If
End Sub
#End Region