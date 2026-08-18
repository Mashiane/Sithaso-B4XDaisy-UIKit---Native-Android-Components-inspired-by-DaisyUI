B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	' Signature Pad instance
	Private spDemo As B4XDaisySignaturePad
	Private spTarget As B4XDaisySignaturePad
    
	' Action Buttons
	Private btnClear As B4XDaisyButton
	Private btnCopyToTarget As B4XDaisyButton
	Private btnClearTarget As B4XDaisyButton
	Private btnCheckEmpty As B4XDaisyButton
	Private btnExportPNG As B4XDaisyButton
	Private btnExportBMP As B4XDaisyButton
	Private btnSaveLocal As B4XDaisyButton
	Private btnLoadLocal As B4XDaisyButton
    
	' Color options
	Private btnPenBlack As B4XDaisyButton
	Private btnPenRed As B4XDaisyButton
	Private btnPenBlue As B4XDaisyButton

	' Pen Width Range (controls signature pad stroke width)
	Private rngPenWidth As B4XDaisyRange
	Private lblPenWidth As B4XDaisyText
    
	' Configuration Toggles
	Private tglIntercept As B4XDaisyToggle
	Private tglEnable As B4XDaisyToggle
    
	' Preview Panel & ImageView
	Private pnlPreviewFrame As B4XView
	Private ivPreview As ImageView
    
	' Local Base64 buffer
	Private localSavedBase64 As String = ""

	' B4XDaisySignature (fieldset wrapper) instances
	Private sigFieldset As B4XDaisySignature
	Private sigFieldsetRequired As B4XDaisySignature
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

	' Initialize PageScroll Host
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	' Toast migrated to B4XMainPage central methods

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding
    
	' -------------------------------------------------------------
	' Section 1: The Interactive Signature Pad
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("Interactive Drawing Area", y, False)
    
	spDemo.Initialize(Me, "spDemo")
	spDemo.AddToParent(pnlHost, padding, y, maxW, 220dip)
	spDemo.PenColor = xui.Color_Black
	spDemo.BackgroundColor = xui.Color_White
	spDemo.MinWidth = 2
	spDemo.MaxWidth = 6
	spDemo.BitMapFormat = "png"
	spDemo.BitMapQuality = 100
	spDemo.DisallowParentIntercept = True
	y = y + spDemo.GetComputedHeight + gap
    
	' -------------------------------------------------------------
	' Section 2: Drawing Actions & Settings
	' Buttons are stacked vertically (one per row) using full width.
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("Canvas Controls & Settings", y, False)
    
	btnClear.Initialize(Me, "btnClear")
	btnClear.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnClear.Text = "Clear"
	btnClear.Variant = "error"
	y = y + btnClear.GetComputedHeight + gap
    
	btnCheckEmpty.Initialize(Me, "btnCheckEmpty")
	btnCheckEmpty.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnCheckEmpty.Text = "Check Empty"
	btnCheckEmpty.Variant = "neutral"
	y = y + btnCheckEmpty.GetComputedHeight + gap
    
	btnPenBlack.Initialize(Me, "btnPenBlack")
	btnPenBlack.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnPenBlack.Text = "Pen Color: Black"
	btnPenBlack.Variant = "neutral"
	y = y + btnPenBlack.GetComputedHeight + gap
    
	btnPenRed.Initialize(Me, "btnPenRed")
	btnPenRed.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnPenRed.Text = "Pen Color: Red"
	btnPenRed.Variant = "error"
	y = y + btnPenRed.GetComputedHeight + gap
    
	btnPenBlue.Initialize(Me, "btnPenBlue")
	btnPenBlue.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnPenBlue.Text = "Pen Color: Blue"
	btnPenBlue.Variant = "info"
	y = y + btnPenBlue.GetComputedHeight + gap
	
	' Pen Width slider - controls the signature pad stroke width
	lblPenWidth.Initialize(Me, "lblPenWidth")
	lblPenWidth.AddToParent(pnlHost, padding, y, maxW, 24dip)
	lblPenWidth.Text = "Pen Width"
	lblPenWidth.TextColor = xui.Color_RGB(30, 41, 59)
	lblPenWidth.TextSize = 14
	lblPenWidth.FontBold = True
	lblPenWidth.HAlign = "LEFT"
	y = y + lblPenWidth.GetComputedHeight + 4dip
	
	rngPenWidth.Initialize(Me, "rngPenWidth")
	rngPenWidth.AddToParent(pnlHost, padding, y, maxW, 44dip)
	rngPenWidth.MinValue = 1
	rngPenWidth.MaxValue = 20
	rngPenWidth.StepValue = 1
	rngPenWidth.Value = 2
	rngPenWidth.Size = "md"
	rngPenWidth.Variant = "primary"
	rngPenWidth.ShowFill = True
	spDemo.StrokeWidth = rngPenWidth.Value * 1dip
	y = y + rngPenWidth.getComputedHeight + gap
    
	' Settings Toggles stacked vertically
	tglIntercept.Initialize(Me, "tglIntercept")
	tglIntercept.AddToParent(pnlHost, padding, y, maxW, 40dip)
	tglIntercept.Checked = True
	tglIntercept.Text = "Disallow Scroll Intercept"
	y = y + tglIntercept.getComputedHeight + gap
    
	tglEnable.Initialize(Me, "tglEnable")
	tglEnable.AddToParent(pnlHost, padding, y, maxW, 40dip)
	tglEnable.Checked = True
	tglEnable.Text = "Enabled"
	y = y + tglEnable.getComputedHeight + gap
    
	' -------------------------------------------------------------
	' Section 3: Import / Export & Preview
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("Import, Export & Validation", y, False)
    
	btnExportPNG.Initialize(Me, "btnExportPNG")
	btnExportPNG.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnExportPNG.Text = "Export PNG"
	btnExportPNG.Variant = "primary"
	y = y + btnExportPNG.GetComputedHeight + gap
    
	btnExportBMP.Initialize(Me, "btnExportBMP")
	btnExportBMP.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnExportBMP.Text = "Export BMP"
	btnExportBMP.Variant = "primary"
	y = y + btnExportBMP.GetComputedHeight + gap
    
	btnSaveLocal.Initialize(Me, "btnSaveLocal")
	btnSaveLocal.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnSaveLocal.Text = "Save Base64"
	btnSaveLocal.Variant = "secondary"
	y = y + btnSaveLocal.GetComputedHeight + gap
    
	btnLoadLocal.Initialize(Me, "btnLoadLocal")
	btnLoadLocal.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnLoadLocal.Text = "Load Base64"
	btnLoadLocal.Variant = "secondary"
	y = y + btnLoadLocal.GetComputedHeight + gap
    
	' Preview Window Title
	y = pageScroll.AddSectionTitle("Last Exported Image Preview", y, False)
    
	' Image Preview Container
	Dim p As Panel
	p.Initialize("")
	pnlPreviewFrame = p
	pnlPreviewFrame.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_LightGray, 8dip)
	pnlHost.AddView(pnlPreviewFrame, padding, y, maxW, 120dip)
    
	' Add image view inside frame
	Dim iv As ImageView
	iv.Initialize("")
	ivPreview = iv
	pnlPreviewFrame.AddView(ivPreview, 4dip, 4dip, pnlPreviewFrame.Width - 8dip, pnlPreviewFrame.Height - 8dip)
	#If B4A
	Dim ivNative As ImageView = ivPreview
	ivNative.Gravity = Gravity.CENTER
	#End If
	y = y + pnlPreviewFrame.Height + gap
    
	' -------------------------------------------------------------
	' Section 4: Drawing Synchronization & Pad Copying
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("Drawing Synchronization & Pad Copying", y, False)
    
	spTarget.Initialize(Me, "spTarget")
	spTarget.AddToParent(pnlHost, padding, y, maxW, 150dip)
	spTarget.PenColor = xui.Color_Blue
	spTarget.BackgroundColor = xui.Color_White
	spTarget.MinWidth = 2
	spTarget.MaxWidth = 4
	spTarget.DisallowParentIntercept = True
	y = y + spTarget.GetComputedHeight + gap
    
	btnCopyToTarget.Initialize(Me, "btnCopyToTarget")
	btnCopyToTarget.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnCopyToTarget.Text = "Copy to Target Pad"
	btnCopyToTarget.Variant = "accent"
	y = y + btnCopyToTarget.GetComputedHeight + gap
    
	btnClearTarget.Initialize(Me, "btnClearTarget")
	btnClearTarget.AddToParent(pnlHost, padding, y, maxW, 36dip)
	btnClearTarget.Text = "Clear Target"
	btnClearTarget.Variant = "neutral"
	y = y + btnClearTarget.GetComputedHeight + gap
    
	' -------------------------------------------------------------
	' Section 5: Fieldset Wrapper (B4XDaisySignature)
	' -------------------------------------------------------------
	y = pageScroll.AddSectionTitle("Fieldset Wrapped Signature", y, False)

	sigFieldset.Initialize(Me, "sigFieldset")
	sigFieldset.AddToParent(pnlHost, padding, y, maxW, 180dip)
	sigFieldset.setLegend("Your Signature")
	sigFieldset.setVariant("primary")
	sigFieldset.setShadow("sm")
	sigFieldset.setHintText("Draw your signature in the area above")
	y = y + sigFieldset.getHeight + gap

	y = pageScroll.AddSectionTitle("Required Signature with Validation", y, False)

	sigFieldsetRequired.Initialize(Me, "sigFieldsetRequired")
	sigFieldsetRequired.AddToParent(pnlHost, padding, y, maxW, 180dip)
	sigFieldsetRequired.setLegend("Authorized Signature")
	sigFieldsetRequired.setLabelAbove(True)
	sigFieldsetRequired.setRequired(True)
	sigFieldsetRequired.setHintText("This field is required - please sign above")
	sigFieldsetRequired.setErrorText("You must provide a signature before continuing")
	sigFieldsetRequired.setShadow("sm")
	y = y + sigFieldsetRequired.getHeight + gap

	' AutoFit scroll height
	pageScroll.AutoFit
End Sub


#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)

	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region UI Actions
Private Sub btnClear_Click(Tag As Object)
	spDemo.Clear
	B4XPages.MainPage.ShowToast("Signature pad cleared", False)
End Sub

Private Sub btnCheckEmpty_Click(Tag As Object)
	If spDemo.IsEmpty Then
		B4XPages.MainPage.ShowToastWarning("Signature pad is empty!", False)
	Else
		B4XPages.MainPage.ShowToastSuccess("Signature pad contains a drawing!", False)
	End If
End Sub

' Pen colors selection
Private Sub btnPenBlack_Click(Tag As Object)
	spDemo.PenColor = xui.Color_Black
	B4XPages.MainPage.ShowToast("Pen color set to Black", False)
End Sub

Private Sub btnPenRed_Click(Tag As Object)
	spDemo.PenColor = xui.Color_Red
	B4XPages.MainPage.ShowToast("Pen color set to Red", False)
End Sub

Private Sub btnPenBlue_Click(Tag As Object)
	spDemo.PenColor = xui.Color_Blue
	B4XPages.MainPage.ShowToast("Pen color set to Blue", False)
End Sub

' Pen Width range - updates the signature pad stroke width in real time
Private Sub rngPenWidth_Changed(Value As Int)
	spDemo.StrokeWidth = Value * 1dip
End Sub


' Toggle configuration updates
Private Sub tglIntercept_Checked(Checked As Boolean)
	spDemo.DisallowParentIntercept = Checked
	If Checked Then
		B4XPages.MainPage.ShowToastSuccess("Parent Scroll Intercept Disabled", False)
	Else
		B4XPages.MainPage.ShowToast("Parent Scroll Intercept Enabled", False)
	End If
End Sub

Private Sub tglEnable_Checked(Checked As Boolean)
	spDemo.Enabled = Checked
	If Checked Then
		B4XPages.MainPage.ShowToastSuccess("Signature pad Enabled", False)
	Else
		B4XPages.MainPage.ShowToast("Signature pad Disabled", False)
	End If
End Sub

' Exports & Imports
Private Sub btnExportPNG_Click(Tag As Object)
	If spDemo.IsEmpty Then
		B4XPages.MainPage.ShowToastWarning("Cannot export: drawing area is empty", False)
		Return
	End If
    
	' Set format to PNG and export
	spDemo.BitMapFormat = "png"
	Dim b64 As String = spDemo.GetBase64
    
	' Populate preview B4XBitmap
	Dim bmp As B4XBitmap = spDemo.GetBitMap
	Dim ivX As B4XView = ivPreview
	ivX.SetBitmap(bmp)
    
	B4XPages.MainPage.ShowToastSuccess("Exported PNG successfully", False)
End Sub

Private Sub btnExportBMP_Click(Tag As Object)
	If spDemo.IsEmpty Then
		B4XPages.MainPage.ShowToastWarning("Cannot export: drawing area is empty", False)
		Return
	End If
    
	' Set format to BMP and export
	spDemo.BitMapFormat = "bmp"
	Dim b64 As String = spDemo.GetBase64
    
	' Populate preview B4XBitmap
	Dim bmp As B4XBitmap = spDemo.GetBitMap
	Dim ivX As B4XView = ivPreview
	ivX.SetBitmap(bmp)
    
	B4XPages.MainPage.ShowToastSuccess("Exported BMP successfully", False)
End Sub

Private Sub btnSaveLocal_Click(Tag As Object)
	If spDemo.IsEmpty Then
		B4XPages.MainPage.ShowToastWarning("Cannot save: drawing area is empty", False)
		Return
	End If
    
	localSavedBase64 = spDemo.GetBase64
	B4XPages.MainPage.ShowToastSuccess("Base64 string saved to local memory", False)
End Sub

Private Sub btnLoadLocal_Click(Tag As Object)
	If localSavedBase64 = "" Then
		B4XPages.MainPage.ShowToastWarning("No saved Base64 string found. Save one first!", False)
		Return
	End If
    
	' Load signature from base64
	spDemo.SetBase64(localSavedBase64)
	B4XPages.MainPage.ShowToastSuccess("Loaded signature from Base64 string", False)
End Sub

Private Sub btnCopyToTarget_Click(Tag As Object)
	If spDemo.IsEmpty Then
		B4XPages.MainPage.ShowToastWarning("Nothing to copy: drawing area is empty", False)
		Return
	End If
    
	' Get signature as B4XBitmap from spDemo and set it onto spTarget
	Dim bmp As B4XBitmap = spDemo.GetBitMap
	spTarget.SetBitmap(bmp)
	B4XPages.MainPage.ShowToastSuccess("Copied signature as Bitmap successfully", False)
End Sub

Private Sub btnClearTarget_Click(Tag As Object)
	spTarget.Clear
	B4XPages.MainPage.ShowToast("Target signature pad cleared", False)
End Sub

' B4XDaisySignature fieldset wrapper actions
Private Sub sigFieldset_Saved (Data As String)
	B4XPages.MainPage.ShowToastSuccess("Signature saved! (Base64 length: " & Data.Length & ")", False)
End Sub

Private Sub sigFieldset_Cleared
	B4XPages.MainPage.ShowToast("Signature cleared", False)
End Sub

Private Sub sigFieldsetRequired_Saved (Data As String)
	B4XPages.MainPage.ShowToastSuccess("Required Signature saved! (Base64 length: " & Data.Length & ")", False)
End Sub

Private Sub sigFieldsetRequired_Cleared
	B4XPages.MainPage.ShowToast("Required Signature cleared", False)
End Sub
#End Region
