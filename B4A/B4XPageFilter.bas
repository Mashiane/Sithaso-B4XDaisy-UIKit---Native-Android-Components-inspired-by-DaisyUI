B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
    ' Root is the main container panel of the page, automatically managed by B4XPages.
    Private Root As B4XView
    Private xui As XUI
    ' svHost is the main ScrollView container that handles screen overflow by allowing content to scroll vertically.
    Private svHost As ScrollView
    ' pnlHost references svHost.Panel, the actual scrollable canvas panel where dynamic layouts and filters are added.
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
    ' Store a local reference to the page's root container panel
    Root = Root1

    ' Initialize the ScrollView container to support vertical scrolling
    svHost.Initialize(Max(1dip, Root.Height))
    ' Add the ScrollView to the root container so it fills the screen
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    ' Get the reference to the ScrollView's inner scrollable canvas panel
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    ' Render the filters on the pnlHost canvas
    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders linear examples generated from recipe variant groups.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ' #region Example 1: Filter with single selection and reset button
    y = AddSectionTitle("Filter with single selection and reset button", y, maxW)
    Dim c1 As B4XDaisyFilter
    c1.Initialize(Me, "filter1")
    c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    c1.Options = "svelte:Svelte, vue:Vue, react:React"
    c1.CloseType = "icon"
    c1.CloseIcon = "close.svg"
    c1.ResetPosition = "left"
    c1.Rounded = "theme"
    c1.Variant = "success"
    y = y + c1.GetComputedHeight + 20dip
    ' #endregion

    ' #region Example 2: Filter with custom reset text and outline style
    y = AddSectionTitle("Filter with custom reset text and outline style", y, maxW)
    Dim c2 As B4XDaisyFilter
    c2.Initialize(Me, "filter2")
    c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    c2.Options = "sveltekit:Sveltekit, nuxt:Nuxt, nextjs:Next.js"
    c2.CloseType = "text"
    c2.ResetText = "All"
    c2.ResetPosition = "left"
    c2.Rounded = "rounded-full" ' chip-like shape
    c2.Variant = "primary"
    c2.FilterStyle = "outline"
    y = y + c2.GetComputedHeight + 20dip
    ' #endregion

    ' #region Example 3: Filter with multi-select (checkboxes) and reset button
    y = AddSectionTitle("Filter with multi-select and reset button", y, maxW)
    Dim c3 As B4XDaisyFilter
    c3.Initialize(Me, "filter3")
    c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    c3.Options = "svelte:Svelte, vue:Vue, react:React"
    c3.CloseType = "icon"
    c3.CloseIcon = "close.svg"
    c3.ResetPosition = "right"
    c3.MultiSelect = True
    c3.Rounded = "rounded-md"
    c3.Variant = "accent"
    y = y + c3.GetComputedHeight + 20dip
    ' #endregion

    ' #region Example 4: Filter Sizes
    y = AddSectionTitle("Filter Sizes (md, lg)", y, maxW)
    
    Dim fSizeMD As B4XDaisyFilter
    fSizeMD.Initialize(Me, "fSizeMD")
    fSizeMD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    fSizeMD.Options = "apple:Apple, banana:Banana, orange:Orange"
    fSizeMD.Size = "md"
    fSizeMD.Variant = "primary"
    fSizeMD.CloseType = "icon"
    fSizeMD.CloseIcon = "close.svg"
    y = y + fSizeMD.GetComputedHeight + 10dip

    Dim fSizeLG As B4XDaisyFilter
    fSizeLG.Initialize(Me, "fSizeLG")
    fSizeLG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    fSizeLG.Options = "apple:Apple, banana:Banana, orange:Orange"
    fSizeLG.Size = "lg"
    fSizeLG.Variant = "secondary"
    fSizeLG.CloseType = "icon"
    fSizeLG.CloseIcon = "close.svg"
    y = y + fSizeLG.GetComputedHeight + 20dip
    ' #endregion

    ' #region Example 5: Filter Variants with Checked Option
    y = AddSectionTitle("Filter Variants with Checked Option", y, maxW)
    
    Dim filterVariants() As String = Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
    For Each v As String In filterVariants
        Dim fVar As B4XDaisyFilter
        fVar.Initialize(Me, "fVar_" & v)
        fVar.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
        fVar.Options = "opt1:Option 1, opt2:Option 2, opt3:Option 3"
        fVar.Variant = v
        fVar.setChecked("opt2")
        y = y + fVar.GetComputedHeight + 10dip
    Next
    ' #endregion

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
    Return Y + title.GetComputedHeight + 8dip
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

' Event handlers for Example 1
Private Sub filter1_Changed(Keys As List)
    #If B4A
    If Keys.Size > 0 Then
        B4XPages.MainPage.ShowToast("Filter 1 Active Option: " & Keys.Get(0), False)
    Else
        B4XPages.MainPage.ShowToast("Filter 1 Reset / No Active Option", False)
    End If
    #End If
End Sub

Private Sub filter1_ResetClick
    #If B4A
    B4XPages.MainPage.ShowToast("Filter 1 Reset", False)
    #End If
End Sub

' Event handlers for Example 2
Private Sub filter2_Changed(Keys As List)
    #If B4A
    If Keys.Size > 0 Then
        B4XPages.MainPage.ShowToast("Filter 2 Active Option: " & Keys.Get(0), False)
    Else
        B4XPages.MainPage.ShowToast("Filter 2 Reset / No Active Option", False)
    End If
    #End If
End Sub

Private Sub filter2_ResetClick
    #If B4A
    B4XPages.MainPage.ShowToast("Filter 2 Reset", False)
    #End If
End Sub

' Event handlers for Example 3
Private Sub filter3_ItemChanged(Id As String, Text As String, Checked As Boolean)
    #If B4A
    B4XPages.MainPage.ShowToast("Filter 3 Checkbox " & Id & " state changed: " & Checked, False)
    #End If
End Sub

Private Sub filter3_ResetClick
    #If B4A
    B4XPages.MainPage.ShowToast("Filter 3 Reset", False)
    #End If
End Sub

' Event handlers for Example 4 (Filter Sizes)
Private Sub fSizeMD_Changed(Keys As List)
    #If B4A
    If Keys.Size > 0 Then
        B4XPages.MainPage.ShowToast("Filter MD Active: " & Keys.Get(0), False)
    Else
        B4XPages.MainPage.ShowToast("Filter MD Reset", False)
    End If
    #End If
End Sub

Private Sub fSizeMD_ResetClick
    #If B4A
    B4XPages.MainPage.ShowToast("Filter MD Reset", False)
    #End If
End Sub

Private Sub fSizeLG_Changed(Keys As List)
    #If B4A
    If Keys.Size > 0 Then
        B4XPages.MainPage.ShowToast("Filter LG Active: " & Keys.Get(0), False)
    Else
        B4XPages.MainPage.ShowToast("Filter LG Reset", False)
    End If
    #End If
End Sub

Private Sub fSizeLG_ResetClick
    #If B4A
    B4XPages.MainPage.ShowToast("Filter LG Reset", False)
    #End If
End Sub



' Event handlers for Example 5 (Filter Variants)
Private Sub fVar_neutral_Changed(Keys As List)
    HandleVariantChanged("neutral", Keys)
End Sub

Private Sub fVar_neutral_ResetClick
    HandleVariantReset("neutral")
End Sub

Private Sub fVar_primary_Changed(Keys As List)
    HandleVariantChanged("primary", Keys)
End Sub

Private Sub fVar_primary_ResetClick
    HandleVariantReset("primary")
End Sub

Private Sub fVar_secondary_Changed(Keys As List)
    HandleVariantChanged("secondary", Keys)
End Sub

Private Sub fVar_secondary_ResetClick
    HandleVariantReset("secondary")
End Sub

Private Sub fVar_accent_Changed(Keys As List)
    HandleVariantChanged("accent", Keys)
End Sub

Private Sub fVar_accent_ResetClick
    HandleVariantReset("accent")
End Sub

Private Sub fVar_info_Changed(Keys As List)
    HandleVariantChanged("info", Keys)
End Sub

Private Sub fVar_info_ResetClick
    HandleVariantReset("info")
End Sub

Private Sub fVar_success_Changed(Keys As List)
    HandleVariantChanged("success", Keys)
End Sub

Private Sub fVar_success_ResetClick
    HandleVariantReset("success")
End Sub

Private Sub fVar_warning_Changed(Keys As List)
    HandleVariantChanged("warning", Keys)
End Sub

Private Sub fVar_warning_ResetClick
    HandleVariantReset("warning")
End Sub

Private Sub fVar_error_Changed(Keys As List)
    HandleVariantChanged("error", Keys)
End Sub

Private Sub fVar_error_ResetClick
    HandleVariantReset("error")
End Sub

Private Sub HandleVariantChanged(VariantName As String, Keys As List)
    #If B4A
    If Keys.Size > 0 Then
        B4XPages.MainPage.ShowToast("Filter " & VariantName & " Active: " & Keys.Get(0), False)
    Else
        B4XPages.MainPage.ShowToast("Filter " & VariantName & " Reset", False)
    End If
    #End If
End Sub

Private Sub HandleVariantReset(VariantName As String)
    #If B4A
    B4XPages.MainPage.ShowToast("Filter " & VariantName & " Reset", False)
    #End If
End Sub
#End Region
