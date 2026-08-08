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
	
	Private chooser As MediaChooser
	Private FileHandler As B4XDaisyFileHandler
	Private imgPreview As B4XDaisyImage
	Private lblMediaInfo As B4XDaisyText
	Private cardPreview As B4XDaisyCard
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

	xui.SetDataFolder("mediachooser-example")
	chooser.Initialize(Me, "chooser")

	Try
		FileHandler.Initialize
	Catch
		Log("B4XPageMediaPicker FileHandler.Initialize Error: " & LastException.Message)
	End Try
	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Disappear
	Log("B4XPageMediaPicker: Page paused / backgrounded.")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	Try
		pageScroll.Clear

	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim currentY As Int = padding

	' Section Title
	currentY = pageScroll.AddSectionTitle("Media & File Pickers", currentY, False)
	currentY = AddDescription("Trigger native camera, video, audio, and content picker actions via DaisyUI icon buttons.", currentY, maxW)

	' --- Action Buttons Grid / Row ---
	Dim pnlButtons As B4XView = xui.CreatePanel("")
	pnlHost.AddView(pnlButtons, padding, currentY, maxW, 56dip)
	
	Dim btnWidth As Int = 48dip
	Dim btnGap As Int = 12dip
	Dim startX As Int = 0

	' Camera Button
	Dim btnCamera As B4XDaisyIconButton
	btnCamera.Initialize(Me, "btnCamera")
	btnCamera.Variant = "primary"
	btnCamera.IconAsset = "camera-solid.svg"
	btnCamera.AddToParent(pnlButtons, startX, 0, btnWidth, btnWidth)
	startX = startX + btnWidth + btnGap

	' Video Button
	Dim btnVideo As B4XDaisyIconButton
	btnVideo.Initialize(Me, "btnVideo")
	btnVideo.Variant = "secondary"
	btnVideo.IconAsset = "video-solid.svg"
	btnVideo.AddToParent(pnlButtons, startX, 0, btnWidth, btnWidth)
	startX = startX + btnWidth + btnGap

	' Audio / Mic Button
	Dim btnAudio As B4XDaisyIconButton
	btnAudio.Initialize(Me, "btnAudio")
	btnAudio.Variant = "accent"
	btnAudio.IconAsset = "microphone-solid.svg"
	btnAudio.AddToParent(pnlButtons, startX, 0, btnWidth, btnWidth)
	startX = startX + btnWidth + btnGap

	' File Browse Button
	Dim btnBrowse As B4XDaisyIconButton
	btnBrowse.Initialize(Me, "btnBrowse")
	btnBrowse.Variant = "info"
	btnBrowse.IconAsset = "folder-solid.svg"
	btnBrowse.AddToParent(pnlButtons, startX, 0, btnWidth, btnWidth)

	currentY = currentY + 68dip

	' --- Photo Preview Section (B4XDaisyImage) ---
	currentY = pageScroll.AddSectionTitle("Captured Photo Preview", currentY, False)
	
	imgPreview.Initialize(Me, "imgPreview")
	imgPreview.AddToParent(pnlHost, padding, currentY, maxW, 200dip)
	imgPreview.Rounded = True
	imgPreview.ResizeMode = "FIT"
	currentY = currentY + 210dip

	' --- Selected Media Information Card ---
	currentY = pageScroll.AddSectionTitle("Selected Media Metadata", currentY, False)
	
	lblMediaInfo.Initialize(Me, "lblMediaInfo")
	lblMediaInfo.Text = "No media selected yet. Tap an icon button above to capture or select media."
	lblMediaInfo.TextColor = xui.Color_RGB(100, 116, 139)
	lblMediaInfo.AddToParent(pnlHost, padding, currentY, maxW, 80dip)
	currentY = currentY + 90dip

	' --- Placeholder Sections for Video/Audio & PDF Viewers ---
	currentY = pageScroll.AddSectionTitle("Video & Audio Player Placeholder", currentY, False)
	currentY = AddDescription("Placeholder section for video and audio playback components.", currentY, maxW)
	currentY = currentY + 10dip

	currentY = pageScroll.AddSectionTitle("Document & PDF Viewer Placeholder", currentY, False)
	currentY = AddDescription("Placeholder section for PDF and document rendering components.", currentY, maxW)
	currentY = currentY + 20dip

	pageScroll.AutoFit
	Catch
		Log("B4XPageMediaPicker RenderExamples error: " & LastException.Message)
	End Try
End Sub

Private Sub AddDescription(Text As String, Y As Int, Width As Int) As Int
	Dim l As B4XDaisyText
	l.Initialize(Me, "")
	l.AddToParent(pnlHost, pageScroll.PagePadding, Y, Width, 40dip)
	l.Text = Text
	l.TextColor = xui.Color_RGB(100, 116, 139)
	l.TextSize = "text-sm"
	Return Y + l.GetComputedHeight + 8dip
End Sub
#End Region

#Region Button Action Handlers
Private Sub btnCamera_Click(Tag As Object)
	Dim rp As RuntimePermissions
	rp.CheckAndRequest(rp.PERMISSION_CAMERA)
	Wait For B4XPage_PermissionResult (Permission As String, Done As Boolean)
	If Done Then
		Wait For (chooser.CaptureImage) Complete (Result As MediaChooserResult)
		If Result.Success Then
			If File.Exists(Result.MediaDir, Result.MediaFile) Then
				Dim bmp As B4XBitmap = LoadBitmapSample(Result.MediaDir, Result.MediaFile, 1920, 1920)
				imgPreview.setBitmap(bmp)
			End If
			B4XPages.MainPage.ShowToastSuccess("Photo captured successfully!", False)
		Else
			B4XPages.MainPage.ShowToastError("Photo capture cancelled or failed", False)
		End If
	Else
		B4XPages.MainPage.ShowToastError("Camera permission denied", False)
	End If
End Sub

Private Sub btnVideo_Click(Tag As Object)
	Dim rp As RuntimePermissions
	rp.CheckAndRequest(rp.PERMISSION_CAMERA)
	Wait For B4XPage_PermissionResult (Permission As String, Done As Boolean)
	If Done Then
		Wait For (chooser.CaptureVideo) Complete (Result As MediaChooserResult)
		If Result.Success Then
			lblMediaInfo.Text = "🎥 Video Recorded:" & CRLF & _
				"Dir: " & Result.MediaDir & CRLF & _
				"File: " & Result.MediaFile & CRLF & _
				"Type: " & Result.Mime
			B4XPages.MainPage.ShowToastSuccess("Video recorded!", False)
		Else
			B4XPages.MainPage.ShowToastError("Video recording cancelled or failed", False)
		End If
	Else
		B4XPages.MainPage.ShowToastError("Camera permission denied", False)
	End If
End Sub

Private Sub btnAudio_Click(Tag As Object)
	Wait For (FileHandler.RecordAudio) Complete (Result As LoadResult)
	Log(Result.Dir)
	Log(Result.FileName)
	Log(Result.Success)

	
'	
'	If Result <> Null And Result.Success Then
'		lblMediaInfo.Text = "🎙️ Voice Recorded:" & CRLF & _
'			"URI: " & Result.FileName & CRLF & _
'			"Name: " & Result.RealName & CRLF & _
'			"Size: " & Result.Size & " bytes"
'		B4XPages.MainPage.ShowToastSuccess("Audio recorded!", False)
'	Else
'		B4XPages.MainPage.ShowToastError("Audio recording cancelled", False)
'	End If
End Sub

Private Sub btnBrowse_Click(Tag As Object)
	Wait For (FileHandler.LoadWithFilter("*/*", "Choose File")) Complete (Result As LoadResult)
	Log(Result.Dir)
	Log(Result.FileName)
	Log(Result.Success)

'	If Result <> Null And Result.Success Then
'		If Result.Image <> Null And Result.Image.IsInitialized Then
'			imgPreview.setBitmap(Result.Image)
'		End If
'		lblMediaInfo.Text = "📁 File Selected:" & CRLF & _
'			"Name: " & Result.RealName & CRLF & _
'			"Type: " & Result.MimeType & CRLF & _
'			"Size: " & Result.Size & " bytes"
'		B4XPages.MainPage.ShowToastSuccess("File loaded!", False)
'	Else
'		B4XPages.MainPage.ShowToastError("File selection cancelled", False)
'	End If
End Sub

Private Sub Chooser_Progress (Value As Int)
	' Progress handled via PageAppear / PageDisappear lifecycle
End Sub

Private Sub Chooser_Error (Key As String, Message As String)
	B4XPages.MainPage.ShowToastError(Message, False)
End Sub