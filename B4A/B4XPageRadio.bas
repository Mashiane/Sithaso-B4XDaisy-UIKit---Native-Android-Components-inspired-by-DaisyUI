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

	' Radio instances declared globally to support grouping selection toggles
	Private rGroup1Opt1 As B4XDaisyRadio
	Private rGroup1Opt2 As B4XDaisyRadio
	Private rThemeLight As B4XDaisyRadio
	Private rThemeDark As B4XDaisyRadio
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
''' Renders linear examples for all radio states, sizes, variants, and configurations.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	' -----------------------------------------------------------------------
	' 1. Basic Radios (Grouped)
	' -----------------------------------------------------------------------
	y = AddSectionTitle("1. Basic Radios (Grouped)", y, maxW)

	' Radio Option 1
	rGroup1Opt1.Initialize(Me, "rGroup1Opt1")
	rGroup1Opt1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rGroup1Opt1.GroupName = "basic"
	rGroup1Opt1.Text = "Option 1 (Default Selected)"
	rGroup1Opt1.Checked = True
	rGroup1Opt1.Tag = "Group1-Opt1"
	y = y + 50dip

	' Radio Option 2
	rGroup1Opt2.Initialize(Me, "rGroup1Opt2")
	rGroup1Opt2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rGroup1Opt2.GroupName = "basic"
	rGroup1Opt2.Text = "Option 2"
	rGroup1Opt2.Checked = False
	rGroup1Opt2.Tag = "Group1-Opt2"
	y = y + 60dip

	' -----------------------------------------------------------------------
	' 2. Size Variants
	' -----------------------------------------------------------------------
	y = AddSectionTitle("2. Radio Sizes", y, maxW)

	' Extra Small (xs)
	Dim rXS As B4XDaisyRadio
	rXS.Initialize(Me, "rXS")
	rXS.AddToParent(pnlHost, PAGE_PAD, y, maxW, 30dip)
	rXS.GroupName = "sizes"
	rXS.Text = "Size XS (Extra Small)"
	rXS.Size = "xs"
	rXS.Checked = False
	rXS.Tag = "Size XS"
	y = y + 40dip

	' Small (sm)
	Dim rSM As B4XDaisyRadio
	rSM.Initialize(Me, "rSM")
	rSM.AddToParent(pnlHost, PAGE_PAD, y, maxW, 35dip)
	rSM.GroupName = "sizes"
	rSM.Text = "Size SM (Small)"
	rSM.Size = "sm"
	rSM.Checked = False
	rSM.Tag = "Size SM"
	y = y + 45dip

	' Medium (md - Default)
	Dim rMD As B4XDaisyRadio
	rMD.Initialize(Me, "rMD")
	rMD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rMD.GroupName = "sizes"
	rMD.Text = "Size MD (Medium - Default)"
	rMD.Size = "md"
	rMD.Checked = True
	rMD.Tag = "Size MD"
	y = y + 50dip

	' Large (lg)
	Dim rLG As B4XDaisyRadio
	rLG.Initialize(Me, "rLG")
	rLG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 45dip)
	rLG.GroupName = "sizes"
	rLG.Text = "Size LG (Large)"
	rLG.Size = "lg"
	rLG.Checked = False
	rLG.Tag = "Size LG"
	y = y + 55dip

	' Extra Large (xl)
	Dim rXL As B4XDaisyRadio
	rXL.Initialize(Me, "rXL")
	rXL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 50dip)
	rXL.GroupName = "sizes"
	rXL.Text = "Size XL (Extra Large)"
	rXL.Size = "xl"
	rXL.Checked = False
	rXL.Tag = "Size XL"
	y = y + 65dip

	' -----------------------------------------------------------------------
	' 3. Semantic Color Variants
	' -----------------------------------------------------------------------
	y = AddSectionTitle("3. Color Variants", y, maxW)

	' Neutral
	Dim rNeutral As B4XDaisyRadio
	rNeutral.Initialize(Me, "rNeutral")
	rNeutral.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rNeutral.GroupName = "colors"
	rNeutral.Text = "Neutral Radio"
	rNeutral.Variant = "neutral"
	rNeutral.Checked = False
	rNeutral.Tag = "Neutral"
	y = y + 50dip

	' Primary
	Dim rPrimary As B4XDaisyRadio
	rPrimary.Initialize(Me, "rPrimary")
	rPrimary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rPrimary.GroupName = "colors"
	rPrimary.Text = "Primary Radio"
	rPrimary.Variant = "primary"
	rPrimary.Checked = True
	rPrimary.Tag = "Primary"
	y = y + 50dip

	' Secondary
	Dim rSecondary As B4XDaisyRadio
	rSecondary.Initialize(Me, "rSecondary")
	rSecondary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rSecondary.GroupName = "colors"
	rSecondary.Text = "Secondary Radio"
	rSecondary.Variant = "secondary"
	rSecondary.Checked = False
	rSecondary.Tag = "Secondary"
	y = y + 50dip

	' Accent
	Dim rAccent As B4XDaisyRadio
	rAccent.Initialize(Me, "rAccent")
	rAccent.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rAccent.GroupName = "colors"
	rAccent.Text = "Accent Radio"
	rAccent.Variant = "accent"
	rAccent.Checked = False
	rAccent.Tag = "Accent"
	y = y + 50dip

	' Success
	Dim rSuccess As B4XDaisyRadio
	rSuccess.Initialize(Me, "rSuccess")
	rSuccess.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rSuccess.GroupName = "colors"
	rSuccess.Text = "Success Radio"
	rSuccess.Variant = "success"
	rSuccess.Checked = False
	rSuccess.Tag = "Success"
	y = y + 50dip

	' Info
	Dim rInfo As B4XDaisyRadio
	rInfo.Initialize(Me, "rInfo")
	rInfo.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rInfo.GroupName = "colors"
	rInfo.Text = "Info Radio"
	rInfo.Variant = "info"
	rInfo.Checked = False
	rInfo.Tag = "Info"
	y = y + 50dip

	' Warning
	Dim rWarning As B4XDaisyRadio
	rWarning.Initialize(Me, "rWarning")
	rWarning.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rWarning.GroupName = "colors"
	rWarning.Text = "Warning Radio"
	rWarning.Variant = "warning"
	rWarning.Checked = False
	rWarning.Tag = "Warning"
	y = y + 50dip

	' Error
	Dim rError As B4XDaisyRadio
	rError.Initialize(Me, "rError")
	rError.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rError.GroupName = "colors"
	rError.Text = "Error Radio"
	rError.Variant = "error"
	rError.Checked = False
	rError.Tag = "Error"
	y = y + 60dip

	' -----------------------------------------------------------------------
	' 4. Component States
	' -----------------------------------------------------------------------
	y = AddSectionTitle("4. Radio States", y, maxW)

	' Disabled unchecked state
	Dim rDisabled As B4XDaisyRadio
	rDisabled.Initialize(Me, "rDisabled")
	rDisabled.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rDisabled.GroupName = "states"
	rDisabled.Text = "Disabled Unchecked"
	rDisabled.Enabled = False
	rDisabled.Checked = False
	rDisabled.Tag = "Disabled Unchecked"
	y = y + 50dip

	' Disabled checked state
	Dim rDisabledChecked As B4XDaisyRadio
	rDisabledChecked.Initialize(Me, "rDisabledChecked")
	rDisabledChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rDisabledChecked.GroupName = "states"
	rDisabledChecked.Text = "Disabled Checked"
	rDisabledChecked.Enabled = False
	rDisabledChecked.Checked = True
	rDisabledChecked.Tag = "Disabled Checked"
	y = y + 60dip

	' -----------------------------------------------------------------------
	' 5. Label Alignment (Position)
	' -----------------------------------------------------------------------
	y = AddSectionTitle("5. Label Alignment (Position)", y, maxW)

	' Position = start (Label on the right)
	Dim rPosStart As B4XDaisyRadio
	rPosStart.Initialize(Me, "rPosStart")
	rPosStart.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rPosStart.GroupName = "positions"
	rPosStart.Text = "Position Start (Label on Right)"
	rPosStart.Position = "start"
	rPosStart.Checked = True
	rPosStart.Variant = "secondary"
	rPosStart.Tag = "Position Start"
	y = y + 50dip

	' Position = end (Label on the left)
	Dim rPosEnd As B4XDaisyRadio
	rPosEnd.Initialize(Me, "rPosEnd")
	rPosEnd.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rPosEnd.GroupName = "positions"
	rPosEnd.Text = "Position End (Label on Left)"
	rPosEnd.Position = "end"
	rPosEnd.Checked = False
	rPosEnd.Variant = "secondary"
	rPosEnd.Tag = "Position End"
	y = y + 50dip

	' -----------------------------------------------------------------------
	' 6. With Fieldset and Label
	' -----------------------------------------------------------------------
	y = AddSectionTitle("6. With Fieldset and Label", y, maxW)

	Dim fsLogin As B4XDaisyFieldset
	fsLogin.Initialize(Me, "fsLogin")
	fsLogin.Legend = "Choose Theme Mode"
	fsLogin.AutoHeight = True
	Dim fsH As Int = 140dip
	fsLogin.AddToParent(pnlHost, PAGE_PAD, y, 240dip, fsH)

	rThemeLight.Initialize(Me, "rThemeLight")
	rThemeLight.AddToParent(fsLogin.GetContentPanel, 0, 0, 220dip, 40dip)
	rThemeLight.GroupName = "theme"
	rThemeLight.Checked = True
	rThemeLight.Text = "Light Mode"
	rThemeLight.Position = "start"

	rThemeDark.Initialize(Me, "rThemeDark")
	rThemeDark.AddToParent(fsLogin.GetContentPanel, 0, 45dip, 220dip, 40dip)
	rThemeDark.GroupName = "theme"
	rThemeDark.Checked = False
	rThemeDark.Text = "Dark Mode"
	rThemeDark.Position = "start"

	fsLogin.Refresh
	y = y + fsLogin.GetComputedHeight + 20dip

	' -----------------------------------------------------------------------
	' 7. Custom Colors
	' -----------------------------------------------------------------------
	y = AddSectionTitle("7. Custom Colors", y, maxW)

	' Unchecked state override
	Dim rCustomUnchecked As B4XDaisyRadio
	rCustomUnchecked.Initialize(Me, "rCustomUnchecked")
	rCustomUnchecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rCustomUnchecked.GroupName = "customColors"
	rCustomUnchecked.Text = "Custom (indigo unchecked)"
	rCustomUnchecked.Checked = False
	rCustomUnchecked.BackgroundColor = xui.Color_RGB(99, 102, 241)   ' indigo-500
	rCustomUnchecked.BorderColor = xui.Color_RGB(79, 70, 229)        ' indigo-600
	rCustomUnchecked.Tag = "Custom Unchecked"
	y = y + 50dip

	' Checked state override
	Dim rCustomChecked As B4XDaisyRadio
	rCustomChecked.Initialize(Me, "rCustomChecked")
	rCustomChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rCustomChecked.GroupName = "customColors"
	rCustomChecked.Text = "Custom (orange checked)"
	rCustomChecked.Checked = True
	rCustomChecked.BackgroundColor = xui.Color_RGB(251, 146, 60)     ' orange-400
	rCustomChecked.BorderColor = xui.Color_RGB(249, 115, 22)         ' orange-500
	rCustomChecked.TextColor = xui.Color_RGB(154, 52, 18)            ' orange-800 (inner dot)
	rCustomChecked.Tag = "Custom Checked"
	y = y + 60dip

	' -----------------------------------------------------------------------
	' 8. Shadow / Elevation
	' -----------------------------------------------------------------------
	y = AddSectionTitle("8. Shadow / Elevation", y, maxW)

	Dim shadowLevels() As String = Array As String("none", "xs", "sm", "md", "lg", "xl", "2xl")
	For Each level As String In shadowLevels
		Dim rShadow As B4XDaisyRadio
		rShadow.Initialize(Me, "rShadow_" & level)
		rShadow.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
		rShadow.GroupName = "shadows"
		rShadow.Text = "Shadow: " & level
		rShadow.Checked = (level = "md")
		rShadow.Variant = "primary"
		rShadow.Shadow = level
		rShadow.Tag = "Shadow " & level
		y = y + 45dip
	Next

	' -----------------------------------------------------------------------
	' 9. Custom Checked Styling
	' -----------------------------------------------------------------------
	y = AddSectionTitle("9. Custom Checked Styling", y, maxW)

	Dim rCustomStyle As B4XDaisyRadio
	rCustomStyle.Initialize(Me, "rCustomStyle")
	rCustomStyle.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	rCustomStyle.GroupName = "customStyle"
	rCustomStyle.Text = "Custom colors (Indigo unchecked -> Orange checked)"
	rCustomStyle.Checked = True
	rCustomStyle.BackgroundColor = xui.Color_RGB(99, 102, 241)        ' Indigo bg
	rCustomStyle.BorderColor = xui.Color_RGB(79, 70, 229)            ' Indigo border
	rCustomStyle.CheckedBackgroundColor = xui.Color_RGB(251, 146, 60) ' Orange checked bg
	rCustomStyle.CheckedBorderColor = xui.Color_RGB(249, 115, 22)     ' Orange checked border
	rCustomStyle.CheckedTextColor = xui.Color_RGB(154, 52, 18)        ' Orange center dot
	rCustomStyle.Tag = "Custom Radio Style"
	y = y + 50dip

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Spawns a stylized section header for the demo page.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
	Dim title As B4XDaisyText
	title.Initialize(Me, "")
	title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
	title.Text = Text
	title.TextColor = xui.Color_RGB(30, 41, 59)
	title.TextSize = 16
	title.FontBold = True
	Return Y + 34dip
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub
#End Region

#Region Component Events
Private Sub rGroup1Opt1_Checked(Checked As Boolean)
	LogStateChange("rGroup1Opt1", Checked)
End Sub

Private Sub rGroup1Opt2_Checked(Checked As Boolean)
	LogStateChange("rGroup1Opt2", Checked)
End Sub

Private Sub rThemeLight_Checked(Checked As Boolean)
	LogStateChange("rThemeLight", Checked)
End Sub

Private Sub rThemeDark_Checked(Checked As Boolean)
	LogStateChange("rThemeDark", Checked)
End Sub

Private Sub rXS_Checked(Checked As Boolean)
	LogStateChange("rXS", Checked)
End Sub

Private Sub rSM_Checked(Checked As Boolean)
	LogStateChange("rSM", Checked)
End Sub

Private Sub rMD_Checked(Checked As Boolean)
	LogStateChange("rMD", Checked)
End Sub

Private Sub rLG_Checked(Checked As Boolean)
	LogStateChange("rLG", Checked)
End Sub

Private Sub rXL_Checked(Checked As Boolean)
	LogStateChange("rXL", Checked)
End Sub

Private Sub rNeutral_Checked(Checked As Boolean)
	LogStateChange("rNeutral", Checked)
End Sub

Private Sub rPrimary_Checked(Checked As Boolean)
	LogStateChange("rPrimary", Checked)
End Sub

Private Sub rSecondary_Checked(Checked As Boolean)
	LogStateChange("rSecondary", Checked)
End Sub

Private Sub rAccent_Checked(Checked As Boolean)
	LogStateChange("rAccent", Checked)
End Sub

Private Sub rSuccess_Checked(Checked As Boolean)
	LogStateChange("rSuccess", Checked)
End Sub

Private Sub rInfo_Checked(Checked As Boolean)
	LogStateChange("rInfo", Checked)
End Sub

Private Sub rWarning_Checked(Checked As Boolean)
	LogStateChange("rWarning", Checked)
End Sub

Private Sub rError_Checked(Checked As Boolean)
	LogStateChange("rError", Checked)
End Sub

Private Sub rPosStart_Checked(Checked As Boolean)
	LogStateChange("rPosStart", Checked)
End Sub

Private Sub rPosEnd_Checked(Checked As Boolean)
	LogStateChange("rPosEnd", Checked)
End Sub

Private Sub rCustomUnchecked_Checked(Checked As Boolean)
	LogStateChange("rCustomUnchecked", Checked)
End Sub

Private Sub rCustomChecked_Checked(Checked As Boolean)
	LogStateChange("rCustomChecked", Checked)
End Sub

Private Sub rCustomStyle_Checked(Checked As Boolean)
	LogStateChange("rCustomStyle", Checked)
End Sub

Private Sub LogStateChange(ControlId As String, Checked As Boolean)
	#If B4A
	B4XPages.MainPage.ShowToast(ControlId & " Checked = " & Checked, False)
	#End If
End Sub

#End Region

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
