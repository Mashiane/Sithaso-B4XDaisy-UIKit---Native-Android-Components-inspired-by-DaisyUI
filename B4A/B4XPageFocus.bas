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
	Private pnlHost As B4XView

	Private inpDemo As B4XDaisyInput
	Private btnSetInp As B4XDaisyButton
	Private btnClrInp As B4XDaisyButton

	Private selDemo As B4XDaisySelect
	Private btnSetSel As B4XDaisyButton
	Private btnClrSel As B4XDaisyButton

	Private fileDemo As B4XDaisyFileInput
	Private btnSetFile As B4XDaisyButton
	Private btnClrFile As B4XDaisyButton

	Private chkDemo As B4XDaisyCheckbox
	Private btnSetChk As B4XDaisyButton
	Private btnClrChk As B4XDaisyButton

	Private radDemo As B4XDaisyRadio
	Private btnSetRad As B4XDaisyButton
	Private btnClrRad As B4XDaisyButton

	Private tglDemo As B4XDaisyToggle
	Private btnSetTgl As B4XDaisyButton
	Private btnClrTgl As B4XDaisyButton

	Private rngDemo As B4XDaisyRange
	Private btnSetRng As B4XDaisyButton
	Private btnClrRng As B4XDaisyButton

	Private ratDemo As B4XDaisyRating
	Private btnSetRat As B4XDaisyButton
	Private btnClrRat As B4XDaisyButton
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
	
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim btnGap As Int = 8dip	' space between a component and its button row
	Dim btnW As Int = (maxW - 8dip) / 2
	Dim y As Int = padding

	' 1. Input Component
	y = pageScroll.AddSectionTitle("1. Text Input Focus", y, False)
	inpDemo.Initialize(Me, "inpDemo")
	inpDemo.AddToParent(pnlHost, padding, y, maxW, 40dip)
	inpDemo.Placeholder = "Enter text..."
	inpDemo.LabelAbove = "B4XDaisyInput"
	y = y + inpDemo.GetComputedHeight + btnGap

	btnSetInp.Initialize(Me, "btnSetInp")
	btnSetInp.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetInp.Text = "Set Focus"
	btnSetInp.Variant = "primary"

	btnClrInp.Initialize(Me, "btnClrInp")
	btnClrInp.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrInp.Text = "Clear Focus"
	btnClrInp.Variant = "secondary"
	y = y + btnSetInp.GetComputedHeight + gap

	' 2. Select Component
	y = pageScroll.AddSectionTitle("2. Dropdown Select Focus", y, False)
	selDemo.Initialize(Me, "selDemo")
	selDemo.AddToParent(pnlHost, padding, y, maxW, 40dip)
	selDemo.Placeholder = "Pick an option..."
	selDemo.LabelAbove = "B4XDaisySelect"
	selDemo.Items = CreateMap("opt1": "Option 1", "opt2": "Option 2", "opt3": "Option 3")
	y = y + selDemo.GetComputedHeight + btnGap

	btnSetSel.Initialize(Me, "btnSetSel")
	btnSetSel.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetSel.Text = "Set Focus"
	btnSetSel.Variant = "primary"

	btnClrSel.Initialize(Me, "btnClrSel")
	btnClrSel.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrSel.Text = "Clear Focus"
	btnClrSel.Variant = "secondary"
	y = y + btnSetSel.GetComputedHeight + gap

	' 3. File Input Component
	y = pageScroll.AddSectionTitle("3. File Input Focus", y, False)
	fileDemo.Initialize(Me, "fileDemo")
	fileDemo.AddToParent(pnlHost, padding, y, maxW, 40dip)
	fileDemo.Placeholder = "Choose a file..."
	fileDemo.LabelAbove = "B4XDaisyFileInput"
	y = y + fileDemo.GetComputedHeight + btnGap

	btnSetFile.Initialize(Me, "btnSetFile")
	btnSetFile.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetFile.Text = "Set Focus"
	btnSetFile.Variant = "primary"

	btnClrFile.Initialize(Me, "btnClrFile")
	btnClrFile.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrFile.Text = "Clear Focus"
	btnClrFile.Variant = "secondary"
	y = y + btnSetFile.GetComputedHeight + gap

	' 4. Checkbox Component
	y = pageScroll.AddSectionTitle("4. Checkbox Focus", y, False)
	chkDemo.Initialize(Me, "chkDemo")
	chkDemo.AddToParent(pnlHost, padding, y, maxW, 40dip)
	chkDemo.Text = "Standard Checkbox"
	y = y + chkDemo.GetComputedHeight + btnGap

	btnSetChk.Initialize(Me, "btnSetChk")
	btnSetChk.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetChk.Text = "Set Focus"
	btnSetChk.Variant = "primary"

	btnClrChk.Initialize(Me, "btnClrChk")
	btnClrChk.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrChk.Text = "Clear Focus"
	btnClrChk.Variant = "secondary"
	y = y + btnSetChk.GetComputedHeight + gap

	' 5. Radio Component
	y = pageScroll.AddSectionTitle("5. Radio Focus", y, False)
	radDemo.Initialize(Me, "radDemo")
	radDemo.AddToParent(pnlHost, padding, y, maxW, 40dip)
	radDemo.Text = "Radio Button"
	y = y + radDemo.GetComputedHeight + btnGap

	btnSetRad.Initialize(Me, "btnSetRad")
	btnSetRad.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetRad.Text = "Set Focus"
	btnSetRad.Variant = "primary"

	btnClrRad.Initialize(Me, "btnClrRad")
	btnClrRad.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrRad.Text = "Clear Focus"
	btnClrRad.Variant = "secondary"
	y = y + btnSetRad.GetComputedHeight + gap

	' 6. Toggle Component
	y = pageScroll.AddSectionTitle("6. Toggle Focus", y, False)
	tglDemo.Initialize(Me, "tglDemo")
	tglDemo.AddToParent(pnlHost, padding, y, maxW, 40dip)
	tglDemo.Text = "Toggle Switch"
	y = y + tglDemo.GetComputedHeight + btnGap

	btnSetTgl.Initialize(Me, "btnSetTgl")
	btnSetTgl.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetTgl.Text = "Set Focus"
	btnSetTgl.Variant = "primary"

	btnClrTgl.Initialize(Me, "btnClrTgl")
	btnClrTgl.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrTgl.Text = "Clear Focus"
	btnClrTgl.Variant = "secondary"
	y = y + btnSetTgl.GetComputedHeight + gap

	' 7. Range Component
	y = pageScroll.AddSectionTitle("7. Range Slider Focus", y, False)
	rngDemo.Initialize(Me, "rngDemo")
	rngDemo.AddToParent(pnlHost, padding, y, maxW, 24dip)
	y = y + rngDemo.GetComputedHeight + btnGap

	btnSetRng.Initialize(Me, "btnSetRng")
	btnSetRng.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetRng.Text = "Set Focus"
	btnSetRng.Variant = "primary"

	btnClrRng.Initialize(Me, "btnClrRng")
	btnClrRng.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrRng.Text = "Clear Focus"
	btnClrRng.Variant = "secondary"
	y = y + btnSetRng.GetComputedHeight + gap

	' 8. Rating Component
	y = pageScroll.AddSectionTitle("8. Rating Star Focus", y, False)
	ratDemo.Initialize(Me, "ratDemo")
	ratDemo.AddToParent(pnlHost, padding, y, maxW, 24dip)
	ratDemo.Value = 3
	y = y + ratDemo.GetComputedHeight + btnGap

	btnSetRat.Initialize(Me, "btnSetRat")
	btnSetRat.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSetRat.Text = "Set Focus"
	btnSetRat.Variant = "primary"

	btnClrRat.Initialize(Me, "btnClrRat")
	btnClrRat.AddToParent(pnlHost, padding + btnW + 8dip, y, btnW, 36dip)
	btnClrRat.Text = "Clear Focus"
	btnClrRat.Variant = "secondary"
	y = y + btnSetRat.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Event Handlers

' 1. Input Focus
Private Sub btnSetInp_Click(Tag As Object)
	inpDemo.Focus = True
End Sub
Private Sub btnClrInp_Click(Tag As Object)
	inpDemo.Focus = False
End Sub

' 2. Select Focus
Private Sub btnSetSel_Click(Tag As Object)
	selDemo.Focus = True
End Sub
Private Sub btnClrSel_Click(Tag As Object)
	selDemo.Focus = False
End Sub

' 3. File Input Focus
Private Sub btnSetFile_Click(Tag As Object)
	fileDemo.Focus = True
End Sub
Private Sub btnClrFile_Click(Tag As Object)
	fileDemo.Focus = False
End Sub

' 4. Checkbox Focus
Private Sub btnSetChk_Click(Tag As Object)
	chkDemo.Focus = True
End Sub
Private Sub btnClrChk_Click(Tag As Object)
	chkDemo.Focus = False
End Sub

' 5. Radio Focus
Private Sub btnSetRad_Click(Tag As Object)
	radDemo.Focus = True
End Sub
Private Sub btnClrRad_Click(Tag As Object)
	radDemo.Focus = False
End Sub

' 6. Toggle Focus
Private Sub btnSetTgl_Click(Tag As Object)
	tglDemo.Focus = True
End Sub
Private Sub btnClrTgl_Click(Tag As Object)
	tglDemo.Focus = False
End Sub

' 7. Range Focus
Private Sub btnSetRng_Click(Tag As Object)
	rngDemo.Focus = True
End Sub
Private Sub btnClrRng_Click(Tag As Object)
	rngDemo.Focus = False
End Sub

' 8. Rating Focus
Private Sub btnSetRat_Click(Tag As Object)
	ratDemo.Focus = True
End Sub
Private Sub btnClrRat_Click(Tag As Object)
	ratDemo.Focus = False
End Sub

#End Region
