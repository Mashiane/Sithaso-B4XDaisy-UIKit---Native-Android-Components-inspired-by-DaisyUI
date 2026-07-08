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
	Private toast As B4XDaisyToast

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

	' Initialize Toast for feedback
	toast.Initialize(Me, "toast")
	toast.CreateView
	toast.SetRoot(Root)
	toast.SetPosition("end", "bottom")

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding
	Dim btnW As Int = maxW - (padding * 2)
    
	' ─────────────────────────────────────────────────────────────
	' Section 1: The Interactive Signature Pad
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("Interactive Drawing Area", y, False)
    
	spDemo.Initialize(Me, "spDemo")
	spDemo.AddToParent(pnlHost, padding, y, btnW, 220dip)
	spDemo.PenColor = xui.Color_Black
	spDemo.BackgroundColor = xui.Color_White
	spDemo.MinWidth = 2
	spDemo.MaxWidth = 6
	spDemo.BitMapFormat = "png"
	spDemo.BitMapQuality = 100
	spDemo.DisallowParentIntercept = True
	y = y + spDemo.GetComputedHeight + gap
    
	' ─────────────────────────────────────────────────────────────
	' Section 2: Drawing Actions & Settings
	' Buttons are stacked vertically (one per row) using full width.
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("Canvas Controls & Settings", y, False)
    
	btnClear.Initialize(Me, "btnClear")
	btnClear.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnClear.Text = "Clear"
	btnClear.Variant = "error"
	y = y + btnClear.GetComputedHeight + gap
    
	btnCheckEmpty.Initialize(Me, "btnCheckEmpty")
	btnCheckEmpty.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnCheckEmpty.Text = "Check Empty"
	btnCheckEmpty.Variant = "neutral"
	y = y + btnCheckEmpty.GetComputedHeight + gap
    
	btnPenBlack.Initialize(Me, "btnPenBlack")
	btnPenBlack.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnPenBlack.Text = "Pen Color: Black"
	btnPenBlack.Variant = "neutral"
	y = y + btnPenBlack.GetComputedHeight + gap
    
	btnPenRed.Initialize(Me, "btnPenRed")
	btnPenRed.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnPenRed.Text = "Pen Color: Red"
	btnPenRed.Variant = "error"
	y = y + btnPenRed.GetComputedHeight + gap
    
	btnPenBlue.Initialize(Me, "btnPenBlue")
	btnPenBlue.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnPenBlue.Text = "Pen Color: Blue"
	btnPenBlue.Variant = "info"
	y = y + btnPenBlue.GetComputedHeight + gap
	
	' Pen Width slider - controls the signature pad stroke width
	lblPenWidth.Initialize(Me, "lblPenWidth")
	lblPenWidth.AddToParent(pnlHost, padding, y, btnW, 24dip)
	lblPenWidth.Text = "Pen Width"
	lblPenWidth.TextColor = xui.Color_RGB(30, 41, 59)
	lblPenWidth.TextSize = 14
	lblPenWidth.FontBold = True
	lblPenWidth.HAlign = "LEFT"
	y = y + lblPenWidth.GetComputedHeight + 4dip
	
	rngPenWidth.Initialize(Me, "rngPenWidth")
	rngPenWidth.AddToParent(pnlHost, padding, y, btnW, 44dip)
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
	tglIntercept.AddToParent(pnlHost, padding, y, btnW, 40dip)
	tglIntercept.Checked = True
	tglIntercept.Text = "Disallow Scroll Intercept"
	y = y + tglIntercept.getComputedHeight + gap
    
	tglEnable.Initialize(Me, "tglEnable")
	tglEnable.AddToParent(pnlHost, padding, y, btnW, 40dip)
	tglEnable.Checked = True
	tglEnable.Text = "Enabled"
	y = y + tglEnable.getComputedHeight + gap
    
	' ─────────────────────────────────────────────────────────────
	' Section 3: Import / Export & Preview
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("Import, Export & Validation", y, False)
    
	btnExportPNG.Initialize(Me, "btnExportPNG")
	btnExportPNG.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnExportPNG.Text = "Export PNG"
	btnExportPNG.Variant = "primary"
	y = y + btnExportPNG.GetComputedHeight + gap
    
	btnExportBMP.Initialize(Me, "btnExportBMP")
	btnExportBMP.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnExportBMP.Text = "Export BMP"
	btnExportBMP.Variant = "primary"
	y = y + btnExportBMP.GetComputedHeight + gap
    
	btnSaveLocal.Initialize(Me, "btnSaveLocal")
	btnSaveLocal.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnSaveLocal.Text = "Save Base64"
	btnSaveLocal.Variant = "secondary"
	y = y + btnSaveLocal.GetComputedHeight + gap
    
	btnLoadLocal.Initialize(Me, "btnLoadLocal")
	btnLoadLocal.AddToParent(pnlHost, padding, y, btnW, 36dip)
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
	pnlHost.AddView(pnlPreviewFrame, padding, y, btnW, 120dip)
    
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
    
	' ─────────────────────────────────────────────────────────────
	' Section 4: Drawing Synchronization & Pad Copying
	' ─────────────────────────────────────────────────────────────
	y = pageScroll.AddSectionTitle("Drawing Synchronization & Pad Copying", y, False)
    
	spTarget.Initialize(Me, "spTarget")
	spTarget.AddToParent(pnlHost, padding, y, btnW, 150dip)
	spTarget.PenColor = xui.Color_Blue
	spTarget.BackgroundColor = xui.Color_White
	spTarget.MinWidth = 2
	spTarget.MaxWidth = 4
	spTarget.DisallowParentIntercept = True
	y = y + spTarget.GetComputedHeight + gap
    
	btnCopyToTarget.Initialize(Me, "btnCopyToTarget")
	btnCopyToTarget.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnCopyToTarget.Text = "Copy to Target Pad"
	btnCopyToTarget.Variant = "accent"
	y = y + btnCopyToTarget.GetComputedHeight + gap
    
	btnClearTarget.Initialize(Me, "btnClearTarget")
	btnClearTarget.AddToParent(pnlHost, padding, y, btnW, 36dip)
	btnClearTarget.Text = "Clear Target"
	btnClearTarget.Variant = "neutral"
	y = y + btnClearTarget.GetComputedHeight + gap
    
	' AutoFit scroll height
	pageScroll.AutoFit
End Sub


#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	If toast.IsInitialized Then toast.Base_Resize(Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region UI Actions
Private Sub btnClear_Click(Tag As Object)
	spDemo.Clear
	toast.InfoWithDuration("Signature pad cleared", 1500)
End Sub

Private Sub btnCheckEmpty_Click(Tag As Object)
	If spDemo.IsEmpty Then
		toast.WarningWithDuration("Signature pad is empty!", 2000)
	Else
		toast.SuccessWithDuration("Signature pad contains a drawing!", 2000)
	End If
End Sub

' Pen colors selection
Private Sub btnPenBlack_Click(Tag As Object)
	spDemo.PenColor = xui.Color_Black
	toast.InfoWithDuration("Pen color set to Black", 1500)
End Sub

Private Sub btnPenRed_Click(Tag As Object)
	spDemo.PenColor = xui.Color_Red
	toast.InfoWithDuration("Pen color set to Red", 1500)
End Sub

Private Sub btnPenBlue_Click(Tag As Object)
	spDemo.PenColor = xui.Color_Blue
	toast.InfoWithDuration("Pen color set to Blue", 1500)
End Sub

' Pen Width range - updates the signature pad stroke width in real time
Private Sub rngPenWidth_Changed(Value As Int)
	spDemo.StrokeWidth = Value * 1dip
End Sub


' Toggle configuration updates
Private Sub tglIntercept_Checked(Checked As Boolean)
	spDemo.DisallowParentIntercept = Checked
	If Checked Then
		toast.SuccessWithDuration("Parent Scroll Intercept Disabled", 1500)
	Else
		toast.InfoWithDuration("Parent Scroll Intercept Enabled", 1500)
	End If
End Sub

Private Sub tglEnable_Checked(Checked As Boolean)
	spDemo.Enabled = Checked
	If Checked Then
		toast.SuccessWithDuration("Signature pad Enabled", 1500)
	Else
		toast.InfoWithDuration("Signature pad Disabled", 1500)
	End If
End Sub

' Exports & Imports
Private Sub btnExportPNG_Click(Tag As Object)
	If spDemo.IsEmpty Then
		toast.WarningWithDuration("Cannot export: drawing area is empty", 2000)
		Return
	End If
    
	' Set format to PNG and export
	spDemo.BitMapFormat = "png"
	Dim b64 As String = spDemo.GetBase64
    
	' Populate preview B4XBitmap
	Dim bmp As B4XBitmap = spDemo.GetBitMap
	Dim ivX As B4XView = ivPreview
	ivX.SetBitmap(bmp)
    
	toast.SuccessWithDuration("Exported PNG successfully", 2000)
End Sub

Private Sub btnExportBMP_Click(Tag As Object)
	If spDemo.IsEmpty Then
		toast.WarningWithDuration("Cannot export: drawing area is empty", 2000)
		Return
	End If
    
	' Set format to BMP and export
	spDemo.BitMapFormat = "bmp"
	Dim b64 As String = spDemo.GetBase64
    
	' Populate preview B4XBitmap
	Dim bmp As B4XBitmap = spDemo.GetBitMap
	Dim ivX As B4XView = ivPreview
	ivX.SetBitmap(bmp)
    
	toast.SuccessWithDuration("Exported BMP successfully", 2000)
End Sub

Private Sub btnSaveLocal_Click(Tag As Object)
	If spDemo.IsEmpty Then
		toast.WarningWithDuration("Cannot save: drawing area is empty", 2000)
		Return
	End If
    
	localSavedBase64 = spDemo.GetBase64
	toast.SuccessWithDuration("Base64 string saved to local memory", 2000)
End Sub

Private Sub btnLoadLocal_Click(Tag As Object)
	If localSavedBase64 = "" Then
		toast.WarningWithDuration("No saved Base64 string found. Save one first!", 2000)
		Return
	End If
    
	' Load signature from base64
	spDemo.SetBase64(localSavedBase64)
	toast.SuccessWithDuration("Loaded signature from Base64 string", 2000)
End Sub

Private Sub btnCopyToTarget_Click(Tag As Object)
	If spDemo.IsEmpty Then
		toast.WarningWithDuration("Nothing to copy: drawing area is empty", 2000)
		Return
	End If
    
	' Get signature as B4XBitmap from spDemo and set it onto spTarget
	Dim bmp As B4XBitmap = spDemo.GetBitMap
	spTarget.SetBitmap(bmp)
	toast.SuccessWithDuration("Copied signature as Bitmap successfully", 2000)
End Sub

Private Sub btnClearTarget_Click(Tag As Object)
	spTarget.Clear
	toast.InfoWithDuration("Target signature pad cleared", 1500)
End Sub
#End Region
