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
	B4XPages.SetTitle(Me, "Checkbox")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders linear examples for all checkbox states, sizes, variants, and configurations.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	' ═══════════════════════════════════════════════════════════════════════
	' 1. Basic Checkboxes
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("1. Basic Checkboxes", y, maxW)

	' Unchecked Checkbox (No Label)
	Dim cbUnchecked As B4XDaisyCheckbox
	cbUnchecked.Initialize(Me, "cbUnchecked")
	cbUnchecked.AddToParent(pnlHost, PAGE_PAD, y, 40dip, 40dip)
	cbUnchecked.Checked = False
	cbUnchecked.Tag = "Unchecked box"
	y = y + 50dip


	' Checkbox with Label (Right)
	Dim cbLabelRight As B4XDaisyCheckbox
	cbLabelRight.Initialize(Me, "cbLabelRight")
	cbLabelRight.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbLabelRight.Text = "Remember me"
	cbLabelRight.Checked = True
	cbLabelRight.Tag = "Label Right"
	y = y + 50dip

	' Checkbox with Label (Left)
	Dim cbLabelLeft As B4XDaisyCheckbox
	cbLabelLeft.Initialize(Me, "cbLabelLeft")
	cbLabelLeft.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbLabelLeft.Text = "Accept Terms and Conditions"
	cbLabelLeft.Checked = False
	cbLabelLeft.Position = "start"
	cbLabelLeft.Tag = "Label Left"
	y = y + 60dip

	' ═══════════════════════════════════════════════════════════════════════
	' 2. Size Variants
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("2. Checkbox Sizes", y, maxW)

	' Extra Small (xs)
	Dim cbXS As B4XDaisyCheckbox
	cbXS.Initialize(Me, "cbXS")
	cbXS.AddToParent(pnlHost, PAGE_PAD, y, maxW, 30dip)
	cbXS.Text = "Size XS (Extra Small)"
	cbXS.Size = "xs"
	cbXS.Checked = True
	cbXS.Tag = "Size XS"
	y = y + 40dip

	' Small (sm)
	Dim cbSM As B4XDaisyCheckbox
	cbSM.Initialize(Me, "cbSM")
	cbSM.AddToParent(pnlHost, PAGE_PAD, y, maxW, 35dip)
	cbSM.Text = "Size SM (Small)"
	cbSM.Size = "sm"
	cbSM.Checked = True
	cbSM.Tag = "Size SM"
	y = y + 45dip

	' Medium (md - Default)
	Dim cbMD As B4XDaisyCheckbox
	cbMD.Initialize(Me, "cbMD")
	cbMD.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbMD.Text = "Size MD (Medium - Default)"
	cbMD.Size = "md"
	cbMD.Checked = True
	cbMD.Tag = "Size MD"
	y = y + 50dip

	' Large (lg)
	Dim cbLG As B4XDaisyCheckbox
	cbLG.Initialize(Me, "cbLG")
	cbLG.AddToParent(pnlHost, PAGE_PAD, y, maxW, 45dip)
	cbLG.Text = "Size LG (Large)"
	cbLG.Size = "lg"
	cbLG.Checked = True
	cbLG.Tag = "Size LG"
	y = y + 55dip

	' Extra Large (xl)
	Dim cbXL As B4XDaisyCheckbox
	cbXL.Initialize(Me, "cbXL")
	cbXL.AddToParent(pnlHost, PAGE_PAD, y, maxW, 50dip)
	cbXL.Text = "Size XL (Extra Large)"
	cbXL.Size = "xl"
	cbXL.Checked = True
	cbXL.Tag = "Size XL"
	y = y + 65dip

	' ═══════════════════════════════════════════════════════════════════════
	' 3. Semantic Color Variants
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("3. Color Variants", y, maxW)

	' Neutral
	Dim cbNeutral As B4XDaisyCheckbox
	cbNeutral.Initialize(Me, "cbNeutral")
	cbNeutral.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbNeutral.Text = "Neutral Checkbox"
	cbNeutral.Variant = "neutral"
	cbNeutral.Checked = True
	cbNeutral.Tag = "Neutral"
	y = y + 50dip

	' Primary
	Dim cbPrimary As B4XDaisyCheckbox
	cbPrimary.Initialize(Me, "cbPrimary")
	cbPrimary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbPrimary.Text = "Primary Checkbox"
	cbPrimary.Variant = "primary"
	cbPrimary.Checked = True
	cbPrimary.Tag = "Primary"
	y = y + 50dip

	' Secondary
	Dim cbSecondary As B4XDaisyCheckbox
	cbSecondary.Initialize(Me, "cbSecondary")
	cbSecondary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbSecondary.Text = "Secondary Checkbox"
	cbSecondary.Variant = "secondary"
	cbSecondary.Checked = True
	cbSecondary.Tag = "Secondary"
	y = y + 50dip

	' Accent
	Dim cbAccent As B4XDaisyCheckbox
	cbAccent.Initialize(Me, "cbAccent")
	cbAccent.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbAccent.Text = "Accent Checkbox"
	cbAccent.Variant = "accent"
	cbAccent.Checked = True
	cbAccent.Tag = "Accent"
	y = y + 50dip

	' Success
	Dim cbSuccess As B4XDaisyCheckbox
	cbSuccess.Initialize(Me, "cbSuccess")
	cbSuccess.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbSuccess.Text = "Success Checkbox"
	cbSuccess.Variant = "success"
	cbSuccess.Checked = True
	cbSuccess.Tag = "Success"
	y = y + 50dip

	' Info
	Dim cbInfo As B4XDaisyCheckbox
	cbInfo.Initialize(Me, "cbInfo")
	cbInfo.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbInfo.Text = "Info Checkbox"
	cbInfo.Variant = "info"
	cbInfo.Checked = True
	cbInfo.Tag = "Info"
	y = y + 50dip

	' Warning
	Dim cbWarning As B4XDaisyCheckbox
	cbWarning.Initialize(Me, "cbWarning")
	cbWarning.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbWarning.Text = "Warning Checkbox"
	cbWarning.Variant = "warning"
	cbWarning.Checked = True
	cbWarning.Tag = "Warning"
	y = y + 50dip

	' Error
	Dim cbError As B4XDaisyCheckbox
	cbError.Initialize(Me, "cbError")
	cbError.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbError.Text = "Error Checkbox"
	cbError.Variant = "error"
	cbError.Checked = True
	cbError.Tag = "Error"
	y = y + 60dip

	' ═══════════════════════════════════════════════════════════════════════
	' 4. Component States
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("4. Checkbox States", y, maxW)

	' Indeterminate state
	Dim cbIndet As B4XDaisyCheckbox
	cbIndet.Initialize(Me, "cbIndet")
	cbIndet.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbIndet.Text = "Indeterminate Checkbox"
	cbIndet.Indeterminate = True
	cbIndet.Variant = "primary"
	cbIndet.Tag = "Indeterminate"
	y = y + 50dip

	' Disabled unchecked state
	Dim cbDisabled As B4XDaisyCheckbox
	cbDisabled.Initialize(Me, "cbDisabled")
	cbDisabled.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbDisabled.Text = "Disabled Unchecked"
	cbDisabled.Enabled = False
	cbDisabled.Checked = False
	cbDisabled.Tag = "Disabled Unchecked"
	y = y + 50dip

	' Disabled checked state
	Dim cbDisabledChecked As B4XDaisyCheckbox
	cbDisabledChecked.Initialize(Me, "cbDisabledChecked")
	cbDisabledChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbDisabledChecked.Text = "Disabled Checked"
	cbDisabledChecked.Enabled = False
	cbDisabledChecked.Checked = True
	cbDisabledChecked.Tag = "Disabled Checked"
	y = y + 60dip

	' ═══════════════════════════════════════════════════════════════════════
	' 5. Label Alignment (Position)
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("5. Label Alignment (Position)", y, maxW)

	' Position = start (Label on the right)
	Dim cbPosStart As B4XDaisyCheckbox
	cbPosStart.Initialize(Me, "cbPosStart")
	cbPosStart.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbPosStart.Text = "Position Start (Label on Right)"
	cbPosStart.Position = "start"
	cbPosStart.Checked = True
	cbPosStart.Variant = "secondary"
	cbPosStart.Tag = "Position Start"
	y = y + 50dip

	' Position = end (Label on the left)
	Dim cbPosEnd As B4XDaisyCheckbox
	cbPosEnd.Initialize(Me, "cbPosEnd")
	cbPosEnd.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbPosEnd.Text = "Position End (Label on Left)"
	cbPosEnd.Position = "end"
	cbPosEnd.Checked = True
	cbPosEnd.Variant = "secondary"
	cbPosEnd.Tag = "Position End"
	y = y + 50dip

	' ═══════════════════════════════════════════════════════════════════════
	' 6. With Fieldset and Label  (DaisyUI Example 2)
	' Mirrors: fieldset.bg-base-100 + legend + label wrapper
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("6. With Fieldset and Label", y, maxW)

	''' Fieldset container with legend "Login options" and a checkbox inside a label row.
	Dim fsLogin As B4XDaisyFieldset
	fsLogin.Initialize(Me, "fsLogin")
	fsLogin.Legend = "Login options"
	fsLogin.AutoHeight = True
	Dim fsH As Int = 100dip
	fsLogin.AddToParent(pnlHost, PAGE_PAD, y, 240dip, fsH)

	Dim cbRemember As B4XDaisyCheckbox
	cbRemember.Initialize(Me, "cbRemember")
	cbRemember.AddToParent(fsLogin.GetContentPanel, 0, 0, 220dip, 40dip)
	cbRemember.Checked = True
	cbRemember.Text = "Remember me"
	cbRemember.Position = "start"
	fsLogin.Refresh
	y = y + fsLogin.GetComputedHeight + 20dip

	' ═══════════════════════════════════════════════════════════════════════
	' 7. Custom Colors  (DaisyUI Example 7)
	' Mirrors: border-indigo-600 bg-indigo-500 checked:bg-orange-400
	'          checked:text-orange-800 checked:border-orange-500
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("7. Custom Colors", y, maxW)

	''' Unchecked state: indigo background + indigo border
	Dim cbCustomUnchecked As B4XDaisyCheckbox
	cbCustomUnchecked.Initialize(Me, "cbCustomUnchecked")
	cbCustomUnchecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbCustomUnchecked.Text = "Custom (indigo unchecked)"
	cbCustomUnchecked.Checked = False
	cbCustomUnchecked.BackgroundColor = xui.Color_RGB(99, 102, 241)   ' indigo-500
	cbCustomUnchecked.BorderColor = xui.Color_RGB(79, 70, 229)        ' indigo-600
	cbCustomUnchecked.TextColor = xui.Color_RGB(99, 102, 241)         ' tick transparent until checked
	cbCustomUnchecked.Tag = "Custom Unchecked"
	y = y + 50dip

	''' Checked state: orange checked background + orange border + dark orange tick
	Dim cbCustomChecked As B4XDaisyCheckbox
	cbCustomChecked.Initialize(Me, "cbCustomChecked")
	cbCustomChecked.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbCustomChecked.Text = "Custom (orange checked)"
	cbCustomChecked.Checked = True
	cbCustomChecked.BackgroundColor = xui.Color_RGB(251, 146, 60)     ' orange-400
	cbCustomChecked.BorderColor = xui.Color_RGB(249, 115, 22)         ' orange-500
	cbCustomChecked.TextColor = xui.Color_RGB(154, 52, 18)            ' orange-800
	cbCustomChecked.Tag = "Custom Checked"
	y = y + 60dip

	' ═══════════════════════════════════════════════════════════════════════
	' 8. Shadow / Elevation
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("8. Shadow / Elevation", y, maxW)

	Dim shadowLevels() As String = Array As String("none", "xs", "sm", "md", "lg", "xl", "2xl")
	For Each level As String In shadowLevels
		Dim cbShadow As B4XDaisyCheckbox
		cbShadow.Initialize(Me, "cbShadow_" & level)
		cbShadow.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
		cbShadow.Text = "Shadow: " & level
		cbShadow.Checked = True
		cbShadow.Variant = "primary"
		cbShadow.Shadow = level
		cbShadow.Tag = "Shadow " & level
		y = y + 45dip
	Next

	' ═══════════════════════════════════════════════════════════════════════
	' 9. Custom Checked Styling
	' ═══════════════════════════════════════════════════════════════════════
	y = AddSectionTitle("9. Custom Checked Styling", y, maxW)

	Dim cbCustomStyle As B4XDaisyCheckbox
	cbCustomStyle.Initialize(Me, "cbCustomStyle")
	cbCustomStyle.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	cbCustomStyle.Text = "Custom colors (Indigo unchecked -> Orange checked)"
	cbCustomStyle.Checked = True
	cbCustomStyle.BackgroundColor = xui.Color_RGB(99, 102, 241)        ' Indigo bg
	cbCustomStyle.BorderColor = xui.Color_RGB(79, 70, 229)            ' Indigo border
	cbCustomStyle.CheckedBackgroundColor = xui.Color_RGB(251, 146, 60) ' Orange checked bg
	cbCustomStyle.CheckedBorderColor = xui.Color_RGB(249, 115, 22)     ' Orange checked border
	cbCustomStyle.CheckedTextColor = xui.Color_RGB(154, 52, 18)        ' Orange checkmark color
	cbCustomStyle.Tag = "Custom Checkbox"
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
Private Sub cbUnchecked_Checked(Checked As Boolean)
	LogStateChange("cbUnchecked", Checked)
End Sub


Private Sub cbLabelRight_Checked(Checked As Boolean)
	LogStateChange("cbLabelRight", Checked)
End Sub

Private Sub cbLabelLeft_Checked(Checked As Boolean)
	LogStateChange("cbLabelLeft", Checked)
End Sub

Private Sub cbXS_Checked(Checked As Boolean)
	LogStateChange("cbXS", Checked)
End Sub

Private Sub cbSM_Checked(Checked As Boolean)
	LogStateChange("cbSM", Checked)
End Sub

Private Sub cbMD_Checked(Checked As Boolean)
	LogStateChange("cbMD", Checked)
End Sub

Private Sub cbLG_Checked(Checked As Boolean)
	LogStateChange("cbLG", Checked)
End Sub

Private Sub cbXL_Checked(Checked As Boolean)
	LogStateChange("cbXL", Checked)
End Sub

Private Sub cbNeutral_Checked(Checked As Boolean)
	LogStateChange("cbNeutral", Checked)
End Sub

Private Sub cbPrimary_Checked(Checked As Boolean)
	LogStateChange("cbPrimary", Checked)
End Sub

Private Sub cbSecondary_Checked(Checked As Boolean)
	LogStateChange("cbSecondary", Checked)
End Sub

Private Sub cbAccent_Checked(Checked As Boolean)
	LogStateChange("cbAccent", Checked)
End Sub

Private Sub cbSuccess_Checked(Checked As Boolean)
	LogStateChange("cbSuccess", Checked)
End Sub

Private Sub cbInfo_Checked(Checked As Boolean)
	LogStateChange("cbInfo", Checked)
End Sub

Private Sub cbWarning_Checked(Checked As Boolean)
	LogStateChange("cbWarning", Checked)
End Sub

Private Sub cbError_Checked(Checked As Boolean)
	LogStateChange("cbError", Checked)
End Sub

Private Sub cbIndet_Checked(Checked As Boolean)
	LogStateChange("cbIndet", Checked)
End Sub

Private Sub cbPosStart_Checked(Checked As Boolean)
	LogStateChange("cbPosStart", Checked)
End Sub

Private Sub cbPosEnd_Checked(Checked As Boolean)
	LogStateChange("cbPosEnd", Checked)
End Sub

Private Sub cbRemember_Checked(Checked As Boolean)
	LogStateChange("cbRemember", Checked)
End Sub

Private Sub cbCustomUnchecked_Checked(Checked As Boolean)
	LogStateChange("cbCustomUnchecked", Checked)
End Sub

Private Sub cbCustomChecked_Checked(Checked As Boolean)
	LogStateChange("cbCustomChecked", Checked)
End Sub

Private Sub cbCustomStyle_Checked(Checked As Boolean)
	LogStateChange("cbCustomStyle", Checked)
End Sub

Private Sub LogStateChange(ControlId As String, Checked As Boolean)
	#If B4A
	ToastMessageShow(ControlId & " Checked = " & Checked, False)
	#End If
	Log(ControlId & " state changed: Checked = " & Checked)
End Sub
#End Region

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub