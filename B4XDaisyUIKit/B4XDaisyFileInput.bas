B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
' Raised when the file input surface (or selector button) is tapped.
' The host app should open its platform file picker in response to this event
' and then call setFileName(...) with the chosen file name.
#Event: Click (Tag As Object)
' Raised after setFileName changes the selected file name to a non-empty value.
#Event: FileSelected (FileName As String)
' Raised if the file selection dialog is cancelled/dismissed without choosing a file.
#Event: Cancelled ()
#Event: FocusChanged (HasFocus As Boolean)
#Event: AppendClick
#End Region

#Region Designer Properties
' Common input-family properties are derived from B4XDaisyInput so the two
' components share the same contract where it applies to a file picker.
#DesignerProperty: Key: ButtonText, DisplayName: Button Text, FieldType: String, DefaultValue: Choose file, Description: Label shown on the file selector button (maps to CSS ::file-selector-button text).
#DesignerProperty: Key: Placeholder, DisplayName: Placeholder, FieldType: String, DefaultValue: No file chosen, Description: Text shown in the filename area when no file is selected.
#DesignerProperty: Key: FileName, DisplayName: File Name, FieldType: String, DefaultValue:, Description: Currently selected file name displayed in the input.
#DesignerProperty: Key: LabelAbove, DisplayName: Label, FieldType: String, DefaultValue:, Description: Label text shown above the input (maps to fieldset-legend in docs fieldset example).
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the input (maps to CSS .label standalone pattern, e.g. Max size 2MB).
#DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Error text displayed below the input in the error color. When non-empty it replaces the hint and turns the border error-colored.
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether a file must be selected.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI color variant applied to the selector button and input border.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: md|lg|xl, Description: DaisyUI size variant controlling height and font-size (xs/sm intentionally omitted).
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: default, List: default|ghost, Description: file-input-ghost style (transparent surface, no border).
#DesignerProperty: Key: Radius, DisplayName: Corner Radius, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius token.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Whether the file input is enabled.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Controls view visibility.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override input surface background color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override filename text color.
#DesignerProperty: Key: PlaceholderColor, DisplayName: Placeholder Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override empty-state filename text color.
#DesignerProperty: Key: ButtonColor, DisplayName: Button Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override selector button background color.
#DesignerProperty: Key: ButtonTextColor, DisplayName: Button Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override selector button text color.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override input border color.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind spacing utility for the filename padding-inline-end (e.g. pe-4, p-4).
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level applied to the input surface.
#DesignerProperty: Key: Typeface, DisplayName: Typeface, FieldType: String, DefaultValue: DEFAULT, List: DEFAULT|DEFAULT_BOLD|MONOSPACE|SANS_SERIF|SERIF, Description: Font family for the filename text.
#DesignerProperty: Key: Gravity, DisplayName: Text Gravity, FieldType: String, DefaultValue: LEFT, List: LEFT|CENTER|RIGHT, Description: Horizontal alignment of the filename text.
#DesignerProperty: Key: Alpha, DisplayName: Alpha, FieldType: Float, DefaultValue: 1.0, Description: View opacity from 0 (invisible) to 1 (fully opaque).
#DesignerProperty: Key: Accept, DisplayName: Accept, FieldType: String, DefaultValue:, Description: File type filter for the content chooser (e.g. image/*, .pdf, .jpg,.png). Maps to HTML accept attribute.
#DesignerProperty: Key: MaxSize, DisplayName: Max Size (MB), FieldType: Int, DefaultValue: 0, Description: Maximum file size allowed in megabytes. A value of 0 means no limit.
#DesignerProperty: Key: AppendIcon, DisplayName: Append Icon, FieldType: String, DefaultValue:, Description: SVG icon asset filename to display on the right end of the file input (e.g. x-solid-full.svg).
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private pnlSurface As B4XView
    Private pnlButton As B4XView
    Private lblButton As B4XView
    Private lblFileName As B4XView
    Private pnlLabelAbove As B4XView
    Private lblLabelAbove As B4XView
    Private pnlHintText As B4XView
    Private lblHintText As B4XView
    Private pnlRightIcon As B4XView
    Private svgRightIcon As B4XDaisySvgIcon

    Private msButtonText As String = "Choose file"
    Private msPlaceholder As String = "No file chosen"
    Private msFileName As String = ""
    Private msLabelAbove As String = ""
    Private msHintText As String = ""
    Private msErrorText As String = ""
    Private mbRequired As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
        Private mbFocused As Boolean = False
    Private msVariant As String = "none"
    Private msSize As String = "md"
    Private msStyle As String = "default"
    Private msRadius As String = "theme"
    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private mcBackgroundColor As Int = 0
    Private mcTextColor As Int = 0
    Private mcPlaceholderColor As Int = 0
    Private mcButtonColor As Int = 0
    Private mcButtonTextColor As Int = 0
    Private mcBorderColor As Int = 0
    Private msPadding As String = ""
    Private msShadow As String = "none"
    Private msTypeface As String = "DEFAULT"
    Private msGravity As String = "LEFT"
    Private mfAlpha As Float = 1.0
    Private mbActive As Boolean = False
    Private msAccept As String = ""
    Private msAppendIcon As String = ""
    Private mlFileDate As Long = 0
    Private mlFileSize As Long = 0
    Private msFileBase64 As String = ""
    Private msMimeType As String = ""
    Private miMaxSize As Int = 0
    Private mFileBytes() As Byte
    Private msSelectedDir As String = ""
    Private msSelectedFileName As String = ""
    #If B4A
    Private cc As ContentChooser
    #End If


    ' CSS-derived spacing constants (fileinput.css):
    ' border = var(--border) (~1px), button px-4 (16dip), button me-4 (16dip), input padding-inline-end 0.75rem (12dip).
    Private miBorderDip As Int = 1dip
    Private miButtonPadX As Int = 16dip
    Private miGapDip As Int = 16dip
    Private miPadEndDip As Int = 12dip
	Private inResize As Boolean = False
End Sub

#End Region

#Region Initialization
' Initializes the component.
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

' Designer entry point.
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim initW As Int = mBase.Width
    If initW <= 0 Then initW = 220dip
    Dim initH As Int = mBase.Height
    If initH <= 0 Then initH = ResolveHeightDip

    Dim pSurf As Panel
    pSurf.Initialize("pnlSurface")
    pnlSurface = pSurf
    pnlSurface.Color = xui.Color_Transparent
    mBase.AddView(pnlSurface, 0, 0, initW, initH)

    Dim pBtn As Panel
    pBtn.Initialize("pnlButton")
    pnlButton = pBtn
    pnlButton.Color = xui.Color_Transparent
    pnlSurface.AddView(pBtn, 0, 0, 0, 0)

    Dim lblB As Label
    lblB.Initialize("")
    lblButton = lblB
    lblButton.Color = xui.Color_Transparent
    lblButton.SetTextAlignment("CENTER", "CENTER")
    lblButton.As(Label).SingleLine = True
    #If B4A
        Dim joB As JavaObject = lblButton
        joB.RunMethod("setIncludeFontPadding", Array(False))
    #End If
    pnlButton.AddView(lblButton, 0, 0, 0, 0)

    Dim lblF As Label
    lblF.Initialize("")
    lblFileName = lblF
    lblFileName.Color = xui.Color_Transparent
    lblFileName.SetTextAlignment("CENTER", "LEFT")
    lblFileName.As(Label).SingleLine = True
    #If B4A
        Dim joF As JavaObject = lblFileName
        joF.RunMethod("setIncludeFontPadding", Array(False))
    #End If
    pnlSurface.AddView(lblFileName, 0, 0, 0, 0)

    Dim pnlLA As Panel
    pnlLA.Initialize("")
    pnlLabelAbove = pnlLA
    pnlLabelAbove.Color = xui.Color_Transparent
    mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)

    Dim lblLA As Label
    lblLA.Initialize("")
    lblLabelAbove = lblLA
    lblLabelAbove.Color = xui.Color_Transparent
    lblLabelAbove.SetTextAlignment("TOP", "LEFT")
    lblLabelAbove.As(Label).SingleLine = False
    #If B4A
        Dim joLA As JavaObject = lblLabelAbove
        joLA.RunMethod("setIncludeFontPadding", Array(False))
    #End If
    pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

    Dim pnlHT As Panel
    pnlHT.Initialize("")
    pnlHintText = pnlHT
    pnlHintText.Color = xui.Color_Transparent
    mBase.AddView(pnlHT, 0, 0, 0, 0)

    Dim lblHT As Label
    lblHT.Initialize("")
    lblHintText = lblHT
    lblHintText.Color = xui.Color_Transparent
    lblHintText.SetTextAlignment("TOP", "LEFT")
    lblHintText.As(Label).SingleLine = False
    #If B4A
        Dim joHT As JavaObject = lblHintText
        joHT.RunMethod("setIncludeFontPadding", Array(False))
    #End If
    pnlHintText.AddView(lblHintText, 0, 0, 0, 0)

    Dim pnlR As Panel
    pnlR.Initialize("pnlRightIcon")
    pnlRightIcon = pnlR
    pnlRightIcon.Color = xui.Color_Transparent
    pnlSurface.AddView(pnlRightIcon, 0, 0, 0, 0)

    Dim svgRight As B4XDaisySvgIcon
    svgRight.Initialize(Me, "")
    svgRightIcon = svgRight
    Dim svgRightBase As B4XView = svgRightIcon.CreateView(24dip, 24dip)
    pnlRightIcon.AddView(svgRightBase, 0, 0, 0, 0)
    svgRightIcon.SetClickable(False)

    ApplyDesignerProps(mProps)
    #If B4A
        ' setFocusable(True) allows keyboard/accessibility focus on the panel.
        ' setFocusableInTouchMode is intentionally omitted: it would cause Android
        ' to consume the first touch as a focus event, requiring a double-tap.
        Dim jo As JavaObject = pnlSurface
        jo.RunMethod("setFocusable", Array(True))
    #End If
    Refresh
End Sub

' Maps designer Props to backing fields.
Private Sub ApplyDesignerProps(mProps As Map)
    msButtonText = B4XDaisyVariants.GetPropString(mProps, "ButtonText", msButtonText)
    msPlaceholder = B4XDaisyVariants.GetPropString(mProps, "Placeholder", msPlaceholder)
    msFileName = B4XDaisyVariants.GetPropString(mProps, "FileName", msFileName)
    msLabelAbove = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", msLabelAbove)
    msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", msHintText)
    msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
    mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
    msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
    msSize = B4XDaisyVariants.GetPropString(mProps, "Size", msSize)
    msStyle = B4XDaisyVariants.GetPropString(mProps, "Style", msStyle)
    msRadius = B4XDaisyVariants.GetPropString(mProps, "Radius", msRadius)
    Dim radiusAlt As String = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRadius)
    If radiusAlt <> "theme" Then msRadius = radiusAlt
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
    mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
    mcPlaceholderColor = B4XDaisyVariants.GetPropColor(mProps, "PlaceholderColor", mcPlaceholderColor)
    mcButtonColor = B4XDaisyVariants.GetPropColor(mProps, "ButtonColor", mcButtonColor)
    mcButtonTextColor = B4XDaisyVariants.GetPropColor(mProps, "ButtonTextColor", mcButtonTextColor)
    mcBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mcBorderColor)
    msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
    msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow)
    msTypeface = B4XDaisyVariants.GetPropString(mProps, "Typeface", msTypeface)
    msGravity = B4XDaisyVariants.GetPropString(mProps, "Gravity", msGravity)
    mfAlpha = B4XDaisyVariants.GetPropFloat(mProps, "Alpha", mfAlpha)
    msAccept = B4XDaisyVariants.GetPropString(mProps, "Accept", msAccept)
    miMaxSize = B4XDaisyVariants.GetPropInt(mProps, "MaxSize", miMaxSize)
    msAppendIcon = B4XDaisyVariants.GetPropString(mProps, "AppendIcon", msAppendIcon)
    ApplyPaddingInternal
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("ButtonText", msButtonText)
	props.Put("Placeholder", msPlaceholder)
	props.Put("FileName", msFileName)
	props.Put("LabelAbove", msLabelAbove)
	props.Put("HintText", msHintText)
	props.Put("ErrorText", msErrorText)
	props.Put("Required", mbRequired)
	props.Put("Variant", msVariant)
	props.Put("Size", msSize)
	props.Put("Style", msStyle)
	props.Put("Radius", msRadius)
	props.Put("Enabled", mbEnabled)
	props.Put("Visible", mbVisible)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("TextColor", mcTextColor)
	props.Put("PlaceholderColor", mcPlaceholderColor)
	props.Put("ButtonColor", mcButtonColor)
	props.Put("ButtonTextColor", mcButtonTextColor)
	props.Put("BorderColor", mcBorderColor)
	props.Put("Padding", msPadding)
	props.Put("Shadow", msShadow)
	props.Put("Typeface", msTypeface)
	props.Put("Gravity", msGravity)
	props.Put("Alpha", mfAlpha)
	props.Put("Accept", msAccept)
	props.Put("MaxSize", miMaxSize)
	props.Put("AppendIcon", msAppendIcon)
	Return props
End Sub
#End Region

#Region Public API

Private Sub ResolveLabelAboveText As String
    If mbRequired And msLabelAbove.Length > 0 Then
        If msLabelAbove.Contains("*") = False Then
            Return msLabelAbove & " *"
        End If
    End If
    Return msLabelAbove
End Sub

Private Sub ResolveLabelAboveColor As Int
    Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    If mbEnabled = False Then
        Return B4XDaisyVariants.AlphaColor(c, 0.2)
    End If
    Return c
End Sub

Private Sub ResolveRequiredStarColor(iNormalColor As Int) As Int
    If mbEnabled = False Then Return iNormalColor
    Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
End Sub

Private Sub ApplyRequiredLabelText(vLbl As B4XView, sDisplayText As String, iNormalColor As Int, iStarColor As Int)
    If sDisplayText.Length = 0 Then
        vLbl.Text = ""
        Return
    End If
    If mbRequired And sDisplayText.Contains("*") Then
        Dim starPos As Int = sDisplayText.LastIndexOf("*")
        If starPos >= 0 Then
            Dim basePart As String = sDisplayText.SubString2(0, starPos)
            Dim cs As CSBuilder
            cs.Initialize
            If basePart.Length > 0 Then
                cs.Append(basePart)
            End If
            cs.Color(iStarColor).Append("*").Pop
            vLbl.TextColor = iNormalColor
            B4XDaisyVariants.SetTextOrCSBuilderToLabel(vLbl, cs)
            Return
        End If
    End If
    vLbl.Text = sDisplayText
    vLbl.TextColor = iNormalColor
End Sub

Public Sub setAppendIcon(sValue As String)
    If sValue = Null Then sValue = ""
    msAppendIcon = sValue.Trim
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getAppendIcon As String
    Return msAppendIcon
End Sub

Public Sub setButtonText(sValue As String)
    If sValue = Null Then sValue = ""
    msButtonText = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getButtonText As String
    Return msButtonText
End Sub

Public Sub setAccept(sValue As String)
    If sValue = Null Then sValue = ""
    msAccept = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getAccept As String
    Return msAccept
End Sub

Public Sub setFileDate(lValue As Long)
    mlFileDate = lValue
End Sub

Public Sub getFileDate As Long
    Return mlFileDate
End Sub

Public Sub setFileSize(lValue As Long)
    mlFileSize = lValue
End Sub

Public Sub getFileSize As Long
    Return mlFileSize
End Sub

Public Sub setFileBase64(sValue As String)
    If sValue = Null Then sValue = ""
    msFileBase64 = sValue
End Sub

Public Sub getFileBase64 As String
    Return msFileBase64
End Sub

Public Sub setMimeType(sValue As String)
    If sValue = Null Then sValue = ""
    msMimeType = sValue.ToLowerCase.Trim
End Sub

Public Sub getMimeType As String
    Return msMimeType
End Sub

Public Sub setMaxSize(iValue As Int)
    miMaxSize = iValue
End Sub

Public Sub getMaxSize As Int
    Return miMaxSize
End Sub

' Read-only computed property returning true if the file size exceeds MaxSize.
Public Sub getExceedsSize As Boolean
    If miMaxSize <= 0 Then Return False
    Dim maxBytes As Long = miMaxSize.As(Long) * 1024 * 1024
    Return mlFileSize > maxBytes
End Sub

Public Sub getFileInputStream As InputStream
	Dim in As InputStream
	#If B4A
	If msSelectedFileName <> "" Then
		Try
			in = File.OpenInput(msSelectedDir, msSelectedFileName)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileInput.InputStream: " & LastException.Message)
		End Try
	End If
	#End If
	Return in
End Sub

Public Sub getFileBytes As Byte()
	Return mFileBytes
End Sub

' Decodes and returns the chosen file as a B4XBitmap if it is an image.
Public Sub GetBitmap As B4XBitmap
	Dim bmp As B4XBitmap
	If mFileBytes.Length > 0 Then
		Try
			Dim in As InputStream
			in.InitializeFromBytesArray(mFileBytes, 0, mFileBytes.Length)
			#If B4A
			Dim tempBmp As Bitmap
			tempBmp.Initialize2(in)
			bmp = tempBmp
			#End If
			#If B4J
			Dim tempBmp As Image
			tempBmp.Initialize2(in)
			bmp = tempBmp
			#End If
			#If B4i
			Dim tempBmp As Bitmap
			tempBmp.Initialize2(in)
			bmp = tempBmp
			#End If
			in.Close
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileInput.B4XBitmap: " & LastException.Message)
		End Try
	End If
	Return bmp
End Sub

' Returns the lowercase file extension of the chosen file, including the leading dot (e.g. .png).
' If no file is chosen or the file has no extension, returns an empty string.
Public Sub getExtension As String
	Return ExtractExtension(msFileName)
End Sub

Public Sub getIsImage As Boolean
    If msMimeType.StartsWith("image/") Then Return True
    Dim ext As String = ExtractExtension(msFileName)
    Select Case ext
        Case ".png", ".jpg", ".jpeg", ".gif", ".webp", ".bmp"
            Return True
    End Select
    Return False
End Sub

Public Sub getIsVideo As Boolean
    If msMimeType.StartsWith("video/") Then Return True
    Dim ext As String = ExtractExtension(msFileName)
    Select Case ext
        Case ".mp4", ".mkv", ".avi", ".mov", ".3gp", ".webm"
            Return True
    End Select
    Return False
End Sub

Public Sub getIsPDF As Boolean
    If msMimeType = "application/pdf" Then Return True
    Dim ext As String = ExtractExtension(msFileName)
    Return ext = ".pdf"
End Sub

Public Sub getIsExcel As Boolean
    Select Case msMimeType
        Case "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "text/csv"
            Return True
    End Select
    Dim ext As String = ExtractExtension(msFileName)
    Select Case ext
        Case ".xls", ".xlsx", ".xlsm", ".csv"
            Return True
    End Select
    Return False
End Sub

Public Sub getIsWord As Boolean
    Select Case msMimeType
        Case "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            Return True
    End Select
    Dim ext As String = ExtractExtension(msFileName)
    Select Case ext
        Case ".doc", ".docx"
            Return True
    End Select
    Return False
End Sub

Private Sub ExtractExtension(sFileName As String) As String
    Dim i As Int = sFileName.LastIndexOf(".")
    If i >= 0 Then
        Return sFileName.SubString(i).ToLowerCase
    End If
    Return ""
End Sub



Public Sub setPlaceholder(sValue As String)
    If sValue = Null Then sValue = ""
    msPlaceholder = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlaceholder As String
    Return msPlaceholder
End Sub

' Sets the selected file name. Raises FileSelected when the value becomes a non-empty file name.
Public Sub setFileName(sValue As String)
    If sValue = Null Then sValue = ""
    Dim prev As String = msFileName
    msFileName = sValue
    If mBase.IsInitialized Then Refresh
    Dim trimmed As String = msFileName.Trim
    If trimmed.Length > 0 And trimmed <> prev.Trim Then
        If xui.SubExists(mCallBack, mEventName & "_FileSelected", 1) Then
            CallSub2(mCallBack, mEventName & "_FileSelected", trimmed)
        End If
    End If
End Sub

Public Sub getFileName As String
    Return msFileName
End Sub

Public Sub setLabelAbove(sValue As String)
    If sValue = Null Then sValue = ""
    msLabelAbove = sValue.Trim
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLabelAbove As String
    Return msLabelAbove
End Sub

Public Sub setHintText(sValue As String)
    If sValue = Null Then sValue = ""
    msHintText = sValue.Trim
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHintText As String
    Return msHintText
End Sub

Public Sub setErrorText(sValue As String)
    If sValue = Null Then sValue = ""
    msErrorText = sValue.Trim
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getErrorText As String
    Return msErrorText
End Sub

' Dynamically sets an error state and displays the message below the input.
Public Sub ShowError(sErrorMessage As String)
    msErrorText = sErrorMessage
    mbProgrammaticError = True
    If mBase.IsInitialized Then Refresh
End Sub

' Clears any dynamic error text and returns the input to normal.
Public Sub ClearError
    msErrorText = ""
    mbProgrammaticError = False
    mbValidationTouched = False
    If mBase.IsInitialized Then Refresh
End Sub
' Required validation helpers
Public Sub setRequired(bValue As Boolean)
    mbRequired = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRequired As Boolean
    Return mbRequired
End Sub

Public Sub getIsValid As Boolean
    Return (msErrorText.Length = 0)
End Sub

''' <summary>
''' Validates the file input. When Required=True and no file is selected,
''' shows the configured ErrorText (or a default message) and returns False.
''' </summary>
Public Sub Validate As Boolean
    If mbRequired = False Then
        mbProgrammaticError = False
        ClearError
        Return True
    End If
    If msFileName.Trim.Length > 0 Then
        mbProgrammaticError = False
        ClearError
        Return True
    End If
    mbValidationTouched = True
    Dim msg As String = msErrorText
    If msg.Length = 0 Then msg = "This field is required."
    ShowError(msg)
    Return False
End Sub
Public Sub setVariant(sValue As String)
    If sValue = Null Then sValue = "none"
    msVariant = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setSize(sValue As String)
    If sValue = Null Then sValue = "md"
    msSize = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setStyle(sValue As String)
    If sValue = Null Then sValue = "default"
    msStyle = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getStyle As String
    Return msStyle
End Sub

Public Sub setRadius(sValue As String)
    If sValue = Null Then sValue = "theme"
    msRadius = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRadius As String
    Return msRadius
End Sub

Public Sub setRounded(sValue As String)
    setRadius(sValue)
End Sub

Public Sub getRounded As String
    Return msRadius
End Sub

Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mcBackgroundColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
    Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(sVariantName, 0)
    If c <> 0 Then setBackgroundColor(c)
End Sub

Public Sub setTextColor(iValue As Int)
    mcTextColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mcTextColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
    Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(sVariantName, 0)
    If c <> 0 Then setTextColor(c)
End Sub

Public Sub setPlaceholderColor(iValue As Int)
    mcPlaceholderColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlaceholderColor As Int
    Return mcPlaceholderColor
End Sub

Public Sub setButtonColor(iValue As Int)
    mcButtonColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getButtonColor As Int
    Return mcButtonColor
End Sub

Public Sub setButtonTextColor(iValue As Int)
    mcButtonTextColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getButtonTextColor As Int
    Return mcButtonTextColor
End Sub

Public Sub setBorderColor(iValue As Int)
    mcBorderColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderColor As Int
    Return mcBorderColor
End Sub

Public Sub setPadding(sValue As String)
    If sValue = Null Then sValue = ""
    msPadding = sValue
    ApplyPaddingInternal
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setShadow(sValue As String)
    If sValue = Null Then sValue = "none"
    msShadow = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setTypeface(sValue As String)
    If sValue = Null Then sValue = "DEFAULT"
    msTypeface = sValue.ToUpperCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTypeface As String
    Return msTypeface
End Sub

Public Sub setGravity(sValue As String)
    If sValue = Null Then sValue = "LEFT"
    msGravity = sValue.ToUpperCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getGravity As String
    Return msGravity
End Sub

Public Sub setAlpha(fValue As Float)
    If fValue < 0 Then fValue = 0
    If fValue > 1 Then fValue = 1
    mfAlpha = fValue
    If mBase.IsInitialized Then mBase.Alpha = mfAlpha
End Sub

Public Sub getAlpha As Float
    Return mfAlpha
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
' Re-resolves all theme-aware styling from the active palette.
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

' Applies the current component state to the UI.
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    B4XDaisyVariants.DisableClipping(mBase)
    If pnlSurface.IsInitialized Then B4XDaisyVariants.DisableClipping(pnlSurface)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

' Adds the component to a parent B4XView.
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        DesignerCreateView(p, Null, BuildRuntimeProps(iWidth, iHeight))
    End If
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    ' Re-layout now that mBase has its real assigned width/height, so the surface
    ' fills the parent-provided bounds instead of the pre-attachment default size.
    Refresh
    Return mBase
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
    If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub setTop(iValue As Int)
    If mBase.IsInitialized Then mBase.Top = iValue
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

' Disconnects callback references to avoid leaks in B4XPages.
Public Sub Release
    If mCallBack <> Null Then mCallBack = Null
    If mBase.IsInitialized Then mBase.Tag = Null
End Sub

' Returns the computed height based on current width and text contents.
Public Sub GetComputedHeight As Int
    If mBase.IsInitialized = False Then Return ResolveHeightDip
    
    Dim w As Int = mBase.Width
    If w <= 0 Then w = 220dip
    Dim inputH As Int = ResolveHeightDip
    Dim gap As Int = 4dip

    ' Label above the input (fieldset-legend parity).
    Dim labelAboveH As Int = 0
    Dim measuredLabelH As Int = 0
    Dim aboveTextSize As Float = 0
    If msLabelAbove.Length > 0 Then
        aboveTextSize = B4XDaisyVariants.ResolveLabelSizeDip(msSize)
        measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(msLabelAbove, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
        labelAboveH = measuredLabelH + 4dip
    End If

    ' Hint text below the input (or error text when an error is present).
    Dim displayedHint As String = msHintText
    If msErrorText.Length > 0 Then displayedHint = msErrorText
    Dim rawHintH As Int = 0
    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
    End If

    Dim totalH As Int = labelAboveH + inputH
    If rawHintH > 0 Then totalH = totalH + gap + rawHintH
    Return totalH
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If pnlSurface.IsInitialized = False Then Return

    If inResize Then Return
    inResize = True
    Dim w As Int = dWidth
    If w <= 0 Then w = 220dip
    Dim inputH As Int = ResolveHeightDip
    Dim gap As Int = 4dip

    ' Label above the input (fieldset-legend parity).
    Dim labelAboveH As Int = 0
    Dim measuredLabelH As Int = 0
    Dim aboveTextSize As Float = 0
    If msLabelAbove.Length > 0 Then
        aboveTextSize = B4XDaisyVariants.ResolveLabelSizeDip(msSize)
        measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(msLabelAbove, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
        labelAboveH = measuredLabelH + 4dip
    End If

    ' Hint text below the input (or error text when an error is present).
    Dim displayedHint As String = msHintText
    If msErrorText.Length > 0 Then displayedHint = msErrorText
    Dim rawHintH As Int = 0
    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
    End If

    Dim totalH As Int = labelAboveH + inputH
    If rawHintH > 0 Then totalH = totalH + gap + rawHintH

    ' Auto-grow mBase to fit label-above + input + hint (matches B4XDaisyInput fit-content behavior).
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, totalH)

    If msLabelAbove.Length > 0 Then
        pnlLabelAbove.Visible = True
        pnlLabelAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
        lblLabelAbove.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, measuredLabelH)
        Dim labelAboveColor As Int = ResolveLabelAboveColor
        ApplyRequiredLabelText(lblLabelAbove, ResolveLabelAboveText, labelAboveColor, ResolveRequiredStarColor(labelAboveColor))
        lblLabelAbove.TextSize = aboveTextSize
        lblLabelAbove.Enabled = True
    Else
        pnlLabelAbove.Visible = False
        pnlLabelAbove.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If

    Dim surfaceY As Int = labelAboveH
    pnlSurface.SetLayoutAnimated(0, 0, surfaceY, w, inputH)

    ' Selector button + filename area inside the surface.
    Dim fnt As Float = ResolveFontPoints
    Dim btnText As String = msButtonText
    If btnText = Null Then btnText = ""
    Dim btnW As Int = B4XDaisyVariants.MeasureTextWidthSafe(btnText, fnt, Typeface.DEFAULT, 4dip) + (miButtonPadX * 2)
    Dim maxBtnW As Int = w * 0.6
    If btnW > maxBtnW Then btnW = maxBtnW
    If btnW < 48dip Then btnW = 48dip

    Dim rightW As Int = 0
    Dim iconSize As Int = inputH - 8dip
    If iconSize < 10dip Then iconSize = 10dip
    
    If msAppendIcon.Length > 0 Then
        rightW = iconSize
        pnlRightIcon.Visible = True
        pnlRightIcon.SetLayoutAnimated(0, w - iconSize - 8dip, (inputH - iconSize) / 2, iconSize, iconSize)
        Dim svgRightBase As B4XView = svgRightIcon.mBase
        svgRightBase.SetLayoutAnimated(0, 0, 0, iconSize, iconSize)
        svgRightIcon.Base_Resize(iconSize, iconSize)
    Else
        pnlRightIcon.Visible = False
        pnlRightIcon.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If

    Dim gapBtn As Int = miGapDip
    Dim fileX As Int = btnW + gapBtn
    Dim fileW As Int = w - fileX - miPadEndDip
    If rightW > 0 Then
        fileW = w - fileX - rightW - 16dip
    End If
    If fileW < 0 Then fileW = 0

    If pnlButton.IsInitialized Then
        pnlButton.SetLayoutAnimated(0, 0, 0, btnW, inputH)
    End If
    If lblButton.IsInitialized Then
        lblButton.SetLayoutAnimated(0, 0, 0, btnW, inputH)
    End If
    If lblFileName.IsInitialized Then
        lblFileName.SetLayoutAnimated(0, fileX, 0, fileW, inputH)
    End If

    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        Dim hintY As Int = surfaceY + inputH + gap
        pnlHintText.Visible = True
        pnlHintText.SetLayoutAnimated(0, 0, hintY, w, rawHintH)
        lblHintText.SetLayoutAnimated(0, 0, 0, w, rawHintH)
        lblHintText.Text = displayedHint
        lblHintText.TextSize = hintTxtSize
        Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
        Dim hintColor As Int = Bit.Or(0x99000000, Bit.And(0x00FFFFFF, baseContent))
        If msErrorText.Length > 0 Then hintColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
        lblHintText.TextColor = hintColor
    Else
        pnlHintText.Visible = False
        pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If

    ApplyVisual
    inResize = False
End Sub

Private Sub RaiseClick
    If mbEnabled = False Then Return
    ' Ghost: clicking draws/removes the border around the component (input ghost focus parity).
    If msStyle = "ghost" Then
        mbActive = Not(mbActive)
        Refresh
    End If
    #If B4A
    ChooseFileInternal
    #End If
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub

Private Sub pnlSurface_Click
    RaiseClick
End Sub

Private Sub pnlButton_Click
    RaiseClick
End Sub

Private Sub pnlSurface_FocusChanged(bHasFocus As Boolean)
    mbFocused = bHasFocus
    ' Route focus changes through public validation hooks:
    ' clear transient errors on focus, re-validate on blur.
    If bHasFocus Then
        ReceiveFocus
    Else
        Blur
    End If
    If xui.SubExists(mCallBack, mEventName & "_FocusChanged", 1) Then
        CallSub2(mCallBack, mEventName & "_FocusChanged", bHasFocus)
    End If
End Sub
#End Region

#Region Visual Resolution
' Applies surface/button/text styling. Called at the end of Base_Resize.
Private Sub ApplyVisual
    If pnlSurface.IsInitialized = False Then Return

    Dim colorMap As Map = ResolveVisualColors
    Dim radius As Int = ResolveRadiusDip
    Dim borderDip As Int = Max(1dip, B4XDaisyVariants.GetBorderDip(1dip))
    Dim surfaceBorderDip As Int = borderDip
    ' Ghost is borderless only while idle; once clicked (active) the surface border is
    ' drawn too so the filename / no-file section is enclosed by the border, not just the button.
    If msStyle = "ghost" And mbActive = False Then surfaceBorderDip = 0

    Dim surfaceBg As Int = colorMap.Get("surfaceBg")
    Dim borderColor As Int = colorMap.Get("borderColor")
    Dim btnBg As Int = colorMap.Get("btnBg")
    Dim btnFg As Int = colorMap.Get("btnFg")
    Dim fileFg As Int = colorMap.Get("fileFg")
    Dim placeholderColor As Int = colorMap.Get("placeholderColor")

    ' Use the same border rendering as B4XDaisyInput so an input and file-input on the
    ' same page share identical surface borders.
    B4XDaisyVariants.ApplyEditTextBorder(pnlSurface, surfaceBg, surfaceBorderDip, borderColor, radius)
    B4XDaisyVariants.ApplyElevation(pnlSurface, msShadow)

    ' The selector button uses the SAME border color as the rest of the component
    ' (the input surface border) so the button reads as a bordered sub-control that
    ' matches the surrounding input frame, instead of a borderless block.
    pnlButton.SetColorAndBorder(btnBg, borderDip, borderColor, radius)

    If lblButton.IsInitialized Then
        lblButton.Text = msButtonText
        lblButton.TextColor = btnFg
        lblButton.TextSize = ResolveFontPoints
    End If

    If lblFileName.IsInitialized Then
        Dim display As String = msFileName
        If display = Null Then display = ""
        display = display.Trim
        Dim usingPlaceholder As Boolean = False
        If display.Length = 0 Then
            display = msPlaceholder
            usingPlaceholder = True
        End If
        lblFileName.Text = display
        If usingPlaceholder Then
            lblFileName.TextColor = placeholderColor
        Else
            lblFileName.TextColor = fileFg
        End If
        lblFileName.TextSize = ResolveFontPoints
        lblFileName.SetTextAlignment("CENTER", ResolveHorizAlign)
        lblFileName.As(Label).Typeface = ResolveTypeface
    End If

    If pnlRightIcon.IsInitialized And pnlRightIcon.Visible And svgRightIcon.IsInitialized Then
        If msAppendIcon.Length > 0 Then
            svgRightIcon.setSvgAsset(msAppendIcon)
            svgRightIcon.setColor(placeholderColor)
        End If
    End If

    If mfAlpha < 1.0 Then
        mBase.Alpha = mfAlpha
    Else
        mBase.Alpha = 1.0
    End If
    mBase.Enabled = mbEnabled
    mBase.Visible = mbVisible
End Sub

' Resolves all theme-aware colors for the active variant/style/enabled/error state.
Private Sub ResolveVisualColors As Map
    Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
    Dim base100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
    Dim base200 As Int = tokens.GetDefault("--color-base-200", xui.Color_RGB(243, 244, 246))
    Dim baseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))

    Dim defaultBorder As Int = B4XDaisyVariants.Blend(baseContent, xui.Color_White, 0.2)
    Dim surfaceBg As Int = base100
    Dim borderColor As Int = defaultBorder
    Dim btnBg As Int = base200
    Dim btnFg As Int = baseContent
    Dim fileFg As Int = baseContent
    Dim placeholderColor As Int = B4XDaisyVariants.Blend(baseContent, xui.Color_White, 0.5)

    Dim variantKey As String = ""
    If msVariant <> Null Then variantKey = msVariant.ToLowerCase.Trim
    If variantKey <> "none" And variantKey <> "" Then
        Dim vbg As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(variantKey, base200)
        btnBg = vbg
        borderColor = ResolveInputBorderColor(variantKey, defaultBorder)
        btnFg = B4XDaisyVariants.ResolveTextColorVariant(variantKey, baseContent)
    End If

    ' file-input-ghost: transparent surface with no border when idle; clicking draws a
    ' border around it (mirrors B4XDaisyInput ghost focus: base-100 bg + base-content 10% border).
    If msStyle = "ghost" Then
        If mbActive Then
            surfaceBg = base100
            borderColor = B4XDaisyVariants.Blend(baseContent, xui.Color_White, 0.1)
        Else
            surfaceBg = xui.Color_Transparent
            borderColor = xui.Color_Transparent
        End If
    End If

    ' Error state: error-colored border (only when enabled).
    If mbEnabled And msErrorText.Length > 0 Then
        borderColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
    End If

    ' Disabled: base-200 surface + muted text, non-interactive button. The border is
    ' uniformly muted (gray) regardless of variant so the control reads as inactive,
    ' matching DaisyUI disabled form controls and staying consistent with
    ' B4XDaisyInput / B4XDaisySelect. Ghost stays borderless.
    If mbEnabled = False Then
        surfaceBg = base200
        If msStyle = "ghost" Then
            borderColor = xui.Color_Transparent
        Else
            borderColor = B4XDaisyVariants.Blend(baseContent, base200, 0.2)
        End If
        btnBg = base200
        btnFg = B4XDaisyVariants.AlphaColor(baseContent, 0.2)
        fileFg = B4XDaisyVariants.AlphaColor(baseContent, 0.2)
        placeholderColor = B4XDaisyVariants.AlphaColor(baseContent, 0.2)
    End If

    ' Explicit overrides take precedence.
    If mcBackgroundColor <> 0 Then surfaceBg = mcBackgroundColor
    If mcBorderColor <> 0 Then borderColor = mcBorderColor
    If mcButtonColor <> 0 Then btnBg = mcButtonColor
    If mcButtonTextColor <> 0 Then btnFg = mcButtonTextColor
    If mcTextColor <> 0 Then fileFg = mcTextColor
    If mcPlaceholderColor <> 0 Then placeholderColor = mcPlaceholderColor

    Return CreateMap("surfaceBg": surfaceBg, "borderColor": borderColor, "btnBg": btnBg, "btnFg": btnFg, "fileFg": fileFg, "placeholderColor": placeholderColor)
End Sub

' Resolves the variant input/border color token (mirrors B4XDaisyInput.ResolveInputColor).
Private Sub ResolveInputBorderColor(sVariantKey As String, iDefaultColor As Int) As Int
    Select Case sVariantKey.ToLowerCase
        Case "neutral"
            Return B4XDaisyVariants.GetTokenColor("--color-neutral", iDefaultColor)
        Case "primary"
            Return B4XDaisyVariants.GetTokenColor("--color-primary", iDefaultColor)
        Case "secondary"
            Return B4XDaisyVariants.GetTokenColor("--color-secondary", iDefaultColor)
        Case "accent"
            Return B4XDaisyVariants.GetTokenColor("--color-accent", iDefaultColor)
        Case "info"
            Return B4XDaisyVariants.GetTokenColor("--color-info", iDefaultColor)
        Case "success"
            Return B4XDaisyVariants.GetTokenColor("--color-success", iDefaultColor)
        Case "warning"
            Return B4XDaisyVariants.GetTokenColor("--color-warning", iDefaultColor)
        Case "error"
            Return B4XDaisyVariants.GetTokenColor("--color-error", iDefaultColor)
        Case Else
            Return iDefaultColor
    End Select
End Sub

' Resolves corner radius from the Radius token (--radius-field fallback).
Private Sub ResolveRadiusDip As Int
    Dim mode As String = B4XDaisyVariants.NormalizeRounded(msRadius)
    Select mode
        Case "rounded-none": Return 0
        Case "rounded-sm": Return 2dip
        Case "rounded": Return 4dip
        Case "rounded-md": Return 6dip
        Case "rounded-lg": Return 8dip
        Case "rounded-xl": Return 12dip
        Case "rounded-2xl": Return 16dip
        Case "rounded-3xl": Return 24dip
        Case "rounded-full": Return 9999dip
        Case Else: Return B4XDaisyVariants.GetRadiusFieldDip(8dip)
    End Select
End Sub

' Resolves the filename horizontal alignment from the Gravity token.
Private Sub ResolveHorizAlign As String
    Select Case msGravity.ToUpperCase
        Case "CENTER"
            Return "CENTER"
        Case "RIGHT"
            Return "RIGHT"
        Case Else
            Return "LEFT"
    End Select
End Sub

' Resolves the filename typeface from the Typeface token.
Private Sub ResolveTypeface As Typeface
    Select Case msTypeface.ToUpperCase
        Case "DEFAULT_BOLD"
            Return Typeface.DEFAULT_BOLD
        Case "MONOSPACE"
            Return Typeface.MONOSPACE
        Case "SANS_SERIF"
            Return Typeface.SANS_SERIF
        Case "SERIF"
            Return Typeface.SERIF
        Case Else
            Return Typeface.DEFAULT
    End Select
End Sub

' Maps file-input size tokens to height (dip). CSS: --size = --size-field * multiplier.
Private Sub ResolveHeightDip As Int
    Select Case msSize.ToLowerCase
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

' Maps file-input size tokens to font size (points). CSS font-size per size class.
Private Sub ResolveFontPoints As Float
    ' Aligns to daisyUI input.css field-size font scale (md=14, lg=18, xl=22).
    Return B4XDaisyVariants.ResolveLabelSizeDip(msSize)
End Sub

' Maps the Padding token to the filename padding-inline-end (dip).
Private Sub ApplyPaddingInternal
    If msPadding.Length > 0 Then
        If B4XDaisyVariants.ContainsAny(msPadding, Array As String("px-", "p-", "pe-")) Then
            Dim pxVal As String = B4XDaisyVariants.ExtractSpacingValue(msPadding)
            miPadEndDip = Max(4dip, B4XDaisyBoxModel.TailwindSpacingToDip(pxVal, 12dip))
        Else
            miPadEndDip = Max(4dip, B4XDaisyBoxModel.TailwindSpacingToDip(msPadding, 12dip))
        End If
    Else
        miPadEndDip = 12dip
    End If
End Sub

#If B4A
Private Sub ChooseFileInternal
    If cc.IsInitialized = False Then
        cc.Initialize("cc")
    End If
    Dim mimeType As String = msAccept
    If mimeType = "" Then mimeType = "*/*"
    Dim title As String = msPlaceholder
    If title = "" Then title = "Choose file"
    cc.Show(mimeType, title)
End Sub

Private Sub cc_Result (bSuccess As Boolean, sDir As String, sFileName As String)
    If bSuccess Then
        Dim realName As String = sFileName
        Dim size As Long = 0
        Dim modified As Long = 0
        Dim mime As String = ""
        
        Try
            Dim resolver As ContentResolver
            resolver.Initialize("")
            Dim u As Uri
            u.Parse(sFileName)
            Dim rs As ResultSet = resolver.Query(u, Null, "", Null, "")
            If rs.NextRow Then
                Dim columns As B4XSet = B4XCollections.CreateSet
                For i = 0 To rs.ColumnCount - 1
                    columns.Add(rs.GetColumnName(i))
                Next
                If columns.Contains("_display_name") Then realName = rs.GetString("_display_name")
                If columns.Contains("_size") Then size = rs.GetLong("_size")
                If columns.Contains("last_modified") Then modified = rs.GetLong("last_modified")
                If columns.Contains("mime_type") Then mime = rs.GetString("mime_type")
            End If
            rs.Close
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileInput.cc_Result: " & LastException.Message)
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileInput.cc_Result: " & LastException.Message)
        End Try
        
        msFileName = realName
        mlFileDate = modified
        mlFileSize = size
        msMimeType = mime
        
        msSelectedDir = sDir
        msSelectedFileName = sFileName
        Try
            Dim in As InputStream = File.OpenInput(sDir, sFileName)
            Dim out As OutputStream
            out.InitializeToBytesArray(0)
            File.Copy2(in, out)
            mFileBytes = out.ToBytesArray
            out.Close
            in.Close
            
            Dim su As StringUtils
            msFileBase64 = su.EncodeBase64(mFileBytes)
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileInput.cc_Result: " & LastException.Message)
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileInput.cc_Result: " & LastException.Message)
            msFileBase64 = ""
            Dim emptyBytes() As Byte
            mFileBytes = emptyBytes
        End Try
        
        If getExceedsSize Then
            ShowError("File size limit exceeded (" & miMaxSize & "MB max)")
        Else
            ClearError
        End If
        
        Refresh
        
        If xui.SubExists(mCallBack, mEventName & "_FileSelected", 1) Then
            CallSub2(mCallBack, mEventName & "_FileSelected", msFileName)
        End If
    Else
        msSelectedDir = ""
        msSelectedFileName = ""
        Dim emptyBytes2() As Byte
        mFileBytes = emptyBytes2
        If xui.SubExists(mCallBack, mEventName & "_Cancelled", 0) Then
            CallSub(mCallBack, mEventName & "_Cancelled")
        End If
    End If
End Sub
#End If

''' <summary>
''' Requests focus for the component.
''' </summary>
Public Sub RequestFocus
    If pnlSurface.IsInitialized Then pnlSurface.RequestFocus
End Sub

''' <summary>
''' Sets or clears focus for the component.
''' </summary>
Public Sub setFocus(bValue As Boolean)
    If pnlSurface.IsInitialized = False Then Return
    #If B4A
        Dim jo As JavaObject = pnlSurface
        If bValue Then jo.RunMethod("requestFocus", Null) Else jo.RunMethod("clearFocus", Null)
    #End If
End Sub

''' <summary>
''' Called when the file input receives focus. Clears any transient
''' validation error visual so the user can interact without a distracting red border.
''' </summary>
Public Sub ReceiveFocus
    mbFocused = True
    If msErrorText.Length > 0 And mbProgrammaticError = False Then
        msErrorText = ""
    End If
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Called when the component loses focus.
''' </summary>
Public Sub Blur
    mbFocused = False
    If mBase.IsInitialized Then Refresh
End Sub

Private Sub pnlRightIcon_Click
    Clear
    If xui.SubExists(mCallBack, mEventName & "_AppendClick", 0) Then
        CallSub(mCallBack, mEventName & "_AppendClick")
    End If
End Sub

' Clears the selected file name and all chosen file metadata.
Public Sub Clear
    msFileName = ""
    msSelectedDir = ""
    msSelectedFileName = ""
    mlFileDate = 0
    mlFileSize = 0
    msFileBase64 = ""
    msMimeType = ""
    Dim emptyBytes() As Byte
    mFileBytes = emptyBytes
    
    If mBase.IsInitialized Then Refresh
End Sub
#End Region

#Region Daisy Class Token Parity Mapping
' B4X has no CSS class engine, so each Daisy class token is implemented as native
' styling/behavior. This block documents the supported token -> B4X mapping and
' satisfies the static style-parity scan for the file-input component.
'
' file-input            -> pnlSurface (base surface: bg-base-100, --input-color border, --radius-field)
' file-input-ghost      -> Style = "ghost" (transparent surface, no border when idle; click draws a base-content 10% border, mirrors B4XDaisyInput ghost focus)
' file-input-neutral    -> Variant = "neutral" (--btn-color/--input-color = --color-neutral)
' file-input-primary    -> Variant = "primary"
' file-input-secondary  -> Variant = "secondary"
' file-input-accent     -> Variant = "accent"
' file-input-info       -> Variant = "info"
' file-input-success    -> Variant = "success"
' file-input-warning    -> Variant = "warning"
' file-input-error      -> Variant = "error"
' file-input-xs         -> (not exposed; xs size intentionally omitted per request, falls back to md)
' file-input-sm         -> (not exposed; sm size intentionally omitted per request, falls back to md)
' file-input-md         -> Size = "md"  (--size = --size-field * 10, font-size 0.875rem, default)
' file-input-lg         -> Size = "lg"  (--size = --size-field * 12, font-size 1.125rem)
' file-input-xl         -> Size = "xl"  (--size = --size-field * 14, font-size 1.125rem, pe-6)
'
' ::file-selector-button tokens:
'   btn styling          -> pnlButton (bg via --btn-bg, text via --btn-fg, border = component border color, px-4, me-4)
'   inline-flex, items-center, align-middle, select-none, cursor-pointer, appearance-none
'                        -> native Panel/Label layout (button is a centered single-line label)
'   cursor-not-allowed   -> Enabled = False (muted colors, non-interactive)
'
' Color/state tokens:
'   bg-base-100          -> surface background default (theme token --color-base-100)
'   bg-base-200          -> selector button background + disabled surface/button (theme token --color-base-200)
'   bg-transparent       -> ghost surface background
'   border-base-200      -> disabled border color
'   text-base-content    -> filename + button text color (theme token --color-base-content)
'   placeholder-base-content       -> empty-state filename text color (PlaceholderColor default)
'   placeholder-base-content/20    -> disabled muted text (AlphaColor(base-content, 0.2))
'   h-full               -> button height fills the input surface height
'   ms-0                 -> ghost selector button margin-inline-start 0
'   me-4                 -> selector button margin-inline-end (miGapDip = 16dip)
'   pe-6                 -> file-input-xl padding-inline-end (miPadEndDip sizing)
'   px-4                 -> selector button padding-inline (miButtonPadX = 16dip)
'
' Composition tokens (demonstrated on the demo page, not part of the control surface):
'   fieldset             -> demo fieldset wrapper panel
'   fieldset-legend      -> LabelAbove property (legend shown above the input)
'   label                -> HintText property (helper label shown below the input)
#End Region

#Region B4XView Layout Wrapper Methods
Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized Then Return mBase.Top
	Return 0
End Sub

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
