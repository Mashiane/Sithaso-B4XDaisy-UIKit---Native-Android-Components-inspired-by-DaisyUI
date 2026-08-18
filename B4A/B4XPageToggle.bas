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

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

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

    ' -
    ' 1. BASE SECTION
    ' -
    y = AddSectionTitle("Base Toggle", y, maxW)
    
    ''' Example: Standard checked toggle
    Dim tgBaseChecked As B4XDaisyToggle
    tgBaseChecked.Initialize(Me, "tg")
    tgBaseChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgBaseChecked.Text = "Checked Toggle"
    tgBaseChecked.Checked = True
    tgBaseChecked.Tag = "base-checked"
    y = y + 44dip

    ''' Example: Standard unchecked toggle
    Dim tgBaseUnchecked As B4XDaisyToggle
    tgBaseUnchecked.Initialize(Me, "tg")
    tgBaseUnchecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgBaseUnchecked.Text = "Unchecked Toggle"
    tgBaseUnchecked.Checked = False
    tgBaseUnchecked.Tag = "base-unchecked"
    y = y + 44dip

    ''' Example: Indeterminate toggle
    Dim tgBaseIndet As B4XDaisyToggle
    tgBaseIndet.Initialize(Me, "tg")
    tgBaseIndet.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgBaseIndet.Text = "Indeterminate Toggle"
    tgBaseIndet.Indeterminate = True
    tgBaseIndet.Tag = "base-indeterminate"
    y = y + 56dip

    ' -
    ' 2. TEXTLESS (VISUAL ONLY) SECTION
    ' -
    y = AddSectionTitle("Textless (Visual-Only) Toggle", y, maxW)

    ''' Example: Checkbox-style toggle without text (Checked)
    Dim tgTextlessChecked As B4XDaisyToggle
    tgTextlessChecked.Initialize(Me, "tg")
    tgTextlessChecked.AddToParent(pnlHost, PAGE_PAD, y, 48dip, 24dip)
    tgTextlessChecked.Checked = True
    tgTextlessChecked.Tag = "textless-checked"
    
    ''' Example: Checkbox-style toggle without text (Unchecked)
    Dim tgTextlessUnchecked As B4XDaisyToggle
    tgTextlessUnchecked.Initialize(Me, "tg")
    tgTextlessUnchecked.AddToParent(pnlHost, PAGE_PAD + 60dip, y, 48dip, 24dip)
    tgTextlessUnchecked.Checked = False
    tgTextlessUnchecked.Tag = "textless-unchecked"
    y = y + 40dip

    ' -
    ' 3. VARIANTS SECTION
    ' -
    y = AddSectionTitle("Color Variants (Checked)", y, maxW)

    ''' Example: Primary variant
    Dim tgVarPrimary As B4XDaisyToggle
    tgVarPrimary.Initialize(Me, "tg")
    tgVarPrimary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarPrimary.Text = "Primary Toggle"
    tgVarPrimary.Variant = "primary"
    tgVarPrimary.Checked = True
    tgVarPrimary.Tag = "variant-primary"
    y = y + 44dip

    ''' Example: Secondary variant
    Dim tgVarSecondary As B4XDaisyToggle
    tgVarSecondary.Initialize(Me, "tg")
    tgVarSecondary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarSecondary.Text = "Secondary Toggle"
    tgVarSecondary.Variant = "secondary"
    tgVarSecondary.Checked = True
    tgVarSecondary.Tag = "variant-secondary"
    y = y + 44dip

    ''' Example: Accent variant
    Dim tgVarAccent As B4XDaisyToggle
    tgVarAccent.Initialize(Me, "tg")
    tgVarAccent.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarAccent.Text = "Accent Toggle"
    tgVarAccent.Variant = "accent"
    tgVarAccent.Checked = True
    tgVarAccent.Tag = "variant-accent"
    y = y + 44dip

    ''' Example: Neutral variant
    Dim tgVarNeutral As B4XDaisyToggle
    tgVarNeutral.Initialize(Me, "tg")
    tgVarNeutral.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarNeutral.Text = "Neutral Toggle"
    tgVarNeutral.Variant = "neutral"
    tgVarNeutral.Checked = True
    tgVarNeutral.Tag = "variant-neutral"
    y = y + 44dip

    ''' Example: Info variant
    Dim tgVarInfo As B4XDaisyToggle
    tgVarInfo.Initialize(Me, "tg")
    tgVarInfo.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarInfo.Text = "Info Toggle"
    tgVarInfo.Variant = "info"
    tgVarInfo.Checked = True
    tgVarInfo.Tag = "variant-info"
    y = y + 44dip

    ''' Example: Success variant
    Dim tgVarSuccess As B4XDaisyToggle
    tgVarSuccess.Initialize(Me, "tg")
    tgVarSuccess.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarSuccess.Text = "Success Toggle"
    tgVarSuccess.Variant = "success"
    tgVarSuccess.Checked = True
    tgVarSuccess.Tag = "variant-success"
    y = y + 44dip

    ''' Example: Warning variant
    Dim tgVarWarning As B4XDaisyToggle
    tgVarWarning.Initialize(Me, "tg")
    tgVarWarning.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarWarning.Text = "Warning Toggle"
    tgVarWarning.Variant = "warning"
    tgVarWarning.Checked = True
    tgVarWarning.Tag = "variant-warning"
    y = y + 44dip

    ''' Example: Error variant
    Dim tgVarError As B4XDaisyToggle
    tgVarError.Initialize(Me, "tg")
    tgVarError.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgVarError.Text = "Error Toggle"
    tgVarError.Variant = "error"
    tgVarError.Checked = True
    tgVarError.Tag = "variant-error"
    y = y + 56dip

    ' -
    ' 4. SIZES SECTION
    ' -
    y = AddSectionTitle("Sizes (Checked)", y, maxW)

    ''' Example: Extra Small Size
    Dim tgSizeXS As B4XDaisyToggle
    tgSizeXS.Initialize(Me, "tg")
    tgSizeXS.AddToParent(pnlHost, PAGE_PAD, y, maxW, 30dip)
    tgSizeXS.Text = "Extra Small (xs)"
    tgSizeXS.Size = "xs"
    tgSizeXS.Checked = True
    tgSizeXS.Tag = "size-xs"
    y = y + 36dip

    ''' Example: Small Size
    Dim tgSizeSM As B4XDaisyToggle
    tgSizeSM.Initialize(Me, "tg")
    tgSizeSM.AddToParent(pnlHost, PAGE_PAD, y, maxW, 32dip)
    tgSizeSM.Text = "Small (sm)"
    tgSizeSM.Size = "sm"
    tgSizeSM.Checked = True
    tgSizeSM.Tag = "size-sm"
    y = y + 38dip

    ''' Example: Medium Size (Default)
    Dim tgSizeMD As B4XDaisyToggle
    tgSizeMD.Initialize(Me, "tg")
    tgSizeMD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgSizeMD.Text = "Medium (md)"
    tgSizeMD.Size = "md"
    tgSizeMD.Checked = True
    tgSizeMD.Tag = "size-md"
    y = y + 44dip

    ''' Example: Large Size
    Dim tgSizeLG As B4XDaisyToggle
    tgSizeLG.Initialize(Me, "tg")
    tgSizeLG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    tgSizeLG.Text = "Large (lg)"
    tgSizeLG.Size = "lg"
    tgSizeLG.Checked = True
    tgSizeLG.Tag = "size-lg"
    y = y + 48dip

    ''' Example: Extra Large Size
    Dim tgSizeXL As B4XDaisyToggle
    tgSizeXL.Initialize(Me, "tg")
    tgSizeXL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 44dip)
    tgSizeXL.Text = "Extra Large (xl)"
    tgSizeXL.Size = "xl"
    tgSizeXL.Checked = True
    tgSizeXL.Tag = "size-xl"
    y = y + 56dip

    ' -
    ' 5. POSITIONS SECTION
    ' -
    y = AddSectionTitle("Positions (Label Alignment)", y, maxW)

    ''' Example: Position start (Toggle on left)
    Dim tgPosStartH As B4XDaisyToggle
    tgPosStartH.Initialize(Me, "tg")
    tgPosStartH.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgPosStartH.Text = "Position Start (Label on Right)"
    tgPosStartH.Position = "start"
    tgPosStartH.Checked = True
    tgPosStartH.Tag = "position-start-h"
    y = y + 44dip

    ''' Example: Position end (Toggle on right)
    Dim tgPosEndH As B4XDaisyToggle
    tgPosEndH.Initialize(Me, "tg")
    tgPosEndH.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgPosEndH.Text = "Position End (Label on Left)"
    tgPosEndH.Position = "end"
    tgPosEndH.Checked = True
    tgPosEndH.Tag = "position-end-h"
    y = y + 56dip

    ' -
    ' 6. DISABLED SECTION
    ' -
    y = AddSectionTitle("Disabled Toggles", y, maxW)

    ''' Example: Disabled unchecked toggle
    Dim tgDisabledUnchecked As B4XDaisyToggle
    tgDisabledUnchecked.Initialize(Me, "tg")
    tgDisabledUnchecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgDisabledUnchecked.Text = "Disabled Unchecked"
    tgDisabledUnchecked.Enabled = False
    tgDisabledUnchecked.Checked = False
    tgDisabledUnchecked.Tag = "disabled-unchecked"
    y = y + 44dip

    ''' Example: Disabled checked toggle
    Dim tgDisabledChecked As B4XDaisyToggle
    tgDisabledChecked.Initialize(Me, "tg")
    tgDisabledChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
    tgDisabledChecked.Text = "Disabled Checked"
    tgDisabledChecked.Enabled = False
    tgDisabledChecked.Checked = True
    tgDisabledChecked.Tag = "disabled-checked"
    y = y + 56dip

    ' -
    ' 7. WITH FIELDSET AND LABEL
    ' -
    y = AddSectionTitle("With Fieldset and Label", y, maxW)

    ''' Fieldset container with legend "Login options" and a toggle inside a label row.
    Dim fsLogin As B4XDaisyFieldset
    fsLogin.Initialize(Me, "fsLogin")
    fsLogin.Legend = "Login options"
    fsLogin.AutoHeight = True
    Dim fsH As Int = 100dip
    fsLogin.AddToParent(pnlHost, PAGE_PAD, y, 240dip, fsH)

    Dim tgRemember As B4XDaisyToggle
    tgRemember.Initialize(Me, "tg")
    tgRemember.AddToParent(fsLogin.GetContentPanel, 0, 0, 220dip, 40dip)
    tgRemember.Checked = True
    tgRemember.Text = "Remember me"
    tgRemember.Position = "start"
    fsLogin.Refresh
    y = y + fsLogin.GetComputedHeight + 20dip

    ' -
    ' 8. CUSTOM COLORS
    ' -
    y = AddSectionTitle("Custom Colors", y, maxW)

    ''' Unchecked state: indigo background + indigo border
    Dim tgCustomUnchecked As B4XDaisyToggle
    tgCustomUnchecked.Initialize(Me, "tg")
    tgCustomUnchecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    tgCustomUnchecked.Text = "Custom (indigo unchecked)"
    tgCustomUnchecked.Checked = False
    tgCustomUnchecked.BackgroundColor = xui.Color_RGB(99, 102, 241)   ' indigo-500
    tgCustomUnchecked.BorderColor = xui.Color_RGB(79, 70, 229)        ' indigo-600
    tgCustomUnchecked.TextColor = xui.Color_RGB(99, 102, 241)
    tgCustomUnchecked.Tag = "Custom Unchecked"
    y = y + 50dip

    ''' Checked state: orange checked background + orange border + dark orange text/checkmark
    Dim tgCustomChecked As B4XDaisyToggle
    tgCustomChecked.Initialize(Me, "tg")
    tgCustomChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    tgCustomChecked.Text = "Custom (orange checked)"
    tgCustomChecked.Checked = True
    tgCustomChecked.BackgroundColor = xui.Color_RGB(251, 146, 60)     ' orange-400
    tgCustomChecked.BorderColor = xui.Color_RGB(249, 115, 22)         ' orange-500
    tgCustomChecked.TextColor = xui.Color_RGB(154, 52, 18)            ' orange-800
    tgCustomChecked.Tag = "Custom Checked"
    y = y + 60dip

    ' -
    ' 9. CUSTOM CHECKED STYLING
    ' -
    y = AddSectionTitle("Custom Checked Styling", y, maxW)

    Dim tgCustomStyle As B4XDaisyToggle
    tgCustomStyle.Initialize(Me, "tg")
    tgCustomStyle.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    tgCustomStyle.Text = "Custom colors (Indigo unchecked -> Orange checked)"
    tgCustomStyle.Checked = True
    tgCustomStyle.BackgroundColor = xui.Color_RGB(99, 102, 241)        ' Indigo bg
    tgCustomStyle.BorderColor = xui.Color_RGB(79, 70, 229)            ' Indigo border
    tgCustomStyle.CheckedBackgroundColor = xui.Color_RGB(251, 146, 60) ' Orange checked bg
    tgCustomStyle.CheckedBorderColor = xui.Color_RGB(249, 115, 22)     ' Orange checked border
    tgCustomStyle.CheckedTextColor = xui.Color_RGB(154, 52, 18)        ' Orange checkmark color
    tgCustomStyle.Tag = "Custom Toggle"
    y = y + 50dip

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
Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub tg_Checked(Checked As Boolean)
	Dim source As B4XDaisyToggle = Sender
	Dim textVal As String = source.Text
	If textVal.Length = 0 Then textVal = "Textless Toggle"
	#If B4A
	B4XPages.MainPage.ShowToast(textVal & " checked: " & Checked, False)
	#End If
End Sub
#End Region
