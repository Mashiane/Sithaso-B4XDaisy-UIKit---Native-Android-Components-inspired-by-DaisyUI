B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
    #Event: TextChanged (Old As String, New As String)
    #Event: EnterPressed (Text As String)
    #Event: FocusChanged (HasFocus As Boolean)
    #Event: Click (Tag As Object)
    #Event: PrependClick
    #Event: AppendClick
    #Event: Clear
    #Event: DateSelected (DateTick As Long, FormattedDate As String)
    #Event: TimeSelected (Hour As Int, Minute As Int)
#End Region

#Region Designer Properties
    #DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|ghost|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI color variant applied To border color.
    #DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: md|lg|xl, Description: DaisyUI size variant controlling height And font-size.
    #DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue:, Description: Current input text value.
    #DesignerProperty: Key: Placeholder, DisplayName: Placeholder, FieldType: String, DefaultValue: Type here, Description: Placeholder text shown inside the input when empty.
    #DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the input (maps To CSS .label standalone pattern).
    #DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Text displayed below the input when in the error validation state.
    #DesignerProperty: Key: RequiredErrorText, DisplayName: Required Error Text, FieldType: String, DefaultValue:, Description: Error text shown when the required field is empty.
    #DesignerProperty: Key: MinLengthErrorText, DisplayName: Min Length Error Text, FieldType: String, DefaultValue:, Description: Error text shown when the input is shorter than Min Length.
    #DesignerProperty: Key: MaxLengthErrorText, DisplayName: Max Length Error Text, FieldType: String, DefaultValue:, Description: Error text shown when the input exceeds Max Length.
    #DesignerProperty: Key: PatternErrorText, DisplayName: Pattern Error Text, FieldType: String, DefaultValue:, Description: Error text shown when the Validation Pattern does not match.
    #DesignerProperty: Key: LabelAbove, DisplayName: Label, FieldType: String, DefaultValue:, Description: Label text. When FloatingLabel=True this becomes the floating label; otherwise shown above the input.
    #DesignerProperty: Key: InputType, DisplayName: Input Type, FieldType: String, DefaultValue: text, List: text|number|decimal|phone|email|url|password|date|time|datetime|stepper|search|color, Description: Keyboard input Type For the native EditText.
    #DesignerProperty: Key: DateFormat, DisplayName: Date Format, FieldType: String, DefaultValue: yyyy-MM-dd, Description: Date format string for date picker (e.g. yyyy-MM-dd, dd/MM/yyyy).
    #DesignerProperty: Key: TimeFormat, DisplayName: Time Format, FieldType: String, DefaultValue: HH:mm, Description: Time format string for time picker (e.g. HH:mm, hh:mm a).
    #DesignerProperty: Key: Is24Hours, DisplayName: Is 24 Hours, FieldType: Boolean, DefaultValue: True, Description: Use 24-hour format for time picker.
    #DesignerProperty: Key: MinValue, DisplayName: Min Value, FieldType: String, DefaultValue: 0, Description: Minimum value for stepper input type.
    #DesignerProperty: Key: MaxValue, DisplayName: Max Value, FieldType: String, DefaultValue: 100, Description: Maximum value for stepper input type.
    #DesignerProperty: Key: StepValue, DisplayName: Step Value, FieldType: String, DefaultValue: 1, Description: Increment/decrement amount for stepper input type.
    #DesignerProperty: Key: PasswordChar, DisplayName: Password Character, FieldType: String, DefaultValue: *, Description: Character to use for password masking. Defaults to * (asterisk).
    #DesignerProperty: Key: IconLeft, DisplayName: Icon Left, FieldType: String, DefaultValue:, Description: Left-side SVG icon asset filename.
    #DesignerProperty: Key: IconRight, DisplayName: Icon Right, FieldType: String, DefaultValue:, Description: Right-side SVG icon asset filename.
    #DesignerProperty: Key: LabelLeft, DisplayName: Label Left, FieldType: String, DefaultValue:, Description: Left-side text label inside input.
    #DesignerProperty: Key: LabelRight, DisplayName: Label Right, FieldType: String, DefaultValue:, Description: Right-side text label inside input.
    #DesignerProperty: Key: FloatingLabel, DisplayName: Floating Label, FieldType: Boolean, DefaultValue: False, Description: If True the label floats between placeholder and above-input positions.
    #DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether this field is required.
    #DesignerProperty: Key: ValidationPattern, DisplayName: Validation Pattern, FieldType: String, DefaultValue:, Description: Regular expression pattern For validation.
    #DesignerProperty: Key: MinLength, DisplayName: Min Length, FieldType: Int, DefaultValue: 0, Description: Minimum character count.
    #DesignerProperty: Key: MaxLength, DisplayName: Max Length, FieldType: Int, DefaultValue: 0, Description: Maximum character count.
    #DesignerProperty: Key: Radius, DisplayName: Corner Radius, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius token.
    #DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Whether the input is enabled.
    #DesignerProperty: Key: SingleLine, DisplayName: Single Line, FieldType: Boolean, DefaultValue: True, Description: Restrict input To a single line.
    #DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Controls view visibility.
    #DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override background color.
    #DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override text color.
    #DesignerProperty: Key: PlaceholderColor, DisplayName: Placeholder Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override placeholder color.
    #DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind spacing utility.
    #DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
    #DesignerProperty: Key: ImeOptions, DisplayName: IME Options, FieldType: String, DefaultValue: normal, List: normal|actionNext|actionGo|actionSearch|actionSend|actionDone|actionNone, Description: Keyboard action button (IME options) For the native EditText.
    #DesignerProperty: Key: SearchIcon, DisplayName: Search Icon, FieldType: String, DefaultValue: magnifying-glass-solid.svg, Description: Leading search icon asset (used when InputType = search and IconLeft is empty).
    #DesignerProperty: Key: ClearIcon, DisplayName: Clear Icon, FieldType: String, DefaultValue: xmark-solid.svg, Description: Trailing clear button icon asset (used when InputType = search).
    #DesignerProperty: Key: ShowClearButton, DisplayName: Show Clear Button, FieldType: String, DefaultValue: always, List: never|focus|always, Description: When to show the search clear button (InputType = search).
    #DesignerProperty: Key: Gravity, DisplayName: Text Gravity, FieldType: String, DefaultValue: LEFT, List: LEFT|CENTER|RIGHT, Description: Horizontal text alignment within the input.
    #DesignerProperty: Key: Typeface, DisplayName: Typeface, FieldType: String, DefaultValue: DEFAULT, List: DEFAULT|DEFAULT_BOLD|MONOSPACE|SANS_SERIF|SERIF, Description: Font family For the input text.
    #DesignerProperty: Key: MaxLines, DisplayName: Max Lines, FieldType: Int, DefaultValue: 1, Description: Maximum visible lines (set > 1 For multiline input).
    #DesignerProperty: Key: MinLines, DisplayName: Min Lines, FieldType: Int, DefaultValue: 1, Description: Minimum visible lines For multiline input.
    #DesignerProperty: Key: AllCaps, DisplayName: All Caps, FieldType: Boolean, DefaultValue: False, Description: Force all input text To uppercase.
    #DesignerProperty: Key: ReadOnly, DisplayName: Read Only, FieldType: Boolean, DefaultValue: False, Description: Makes the input read-only (selectable but Not editable).
    #DesignerProperty: Key: CursorVisible, DisplayName: Cursor Visible, FieldType: Boolean, DefaultValue: True, Description: Whether the text cursor is visible.
    #DesignerProperty: Key: LetterSpacing, DisplayName: Letter Spacing, FieldType: Float, DefaultValue: 0, Description: Extra spacing between characters (em units, 0 = normal).
    #DesignerProperty: Key: Alpha, DisplayName: Alpha, FieldType: Float, DefaultValue: 1.0, Description: View opacity from 0 (invisible) To 1 (fully opaque).
    #DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: False, Description: Auto-grow height based on text lines (multiline only).
    #DesignerProperty: Key: NoAutoFill, DisplayName: No Autofill, FieldType: Boolean, DefaultValue: True, Description: Prevent Android autofill service and yellow background highlight overlay.
#End Region

#Region Component Code
    Sub Class_Globals
        Private xui As XUI
        Public mBase As B4XView
        Private mEventName As String
        Private mCallBack As Object
        Private mTag As Object

        Private pnlSurface As B4XView
        Private edtInput As EditText
        Private pnlLeftIcon As B4XView
        Private pnlRightIcon As B4XView
        Private svgLeftIcon As B4XDaisySvgIcon
        Private svgRightIcon As B4XDaisySvgIcon
        Private pnlLeftLabel As B4XView
        Private lblLeftLabel As B4XView
        Private pnlLeftBorder As B4XView
        Private pnlRightLabel As B4XView
        Private lblRightLabel As B4XView
        Private pnlRightBorder As B4XView
        Private pnlFloating As B4XView
        Private lblFloating As B4XView
        Private pnlLabelAbove As B4XView
        Private lblLabelAbove As B4XView
        Private pnlHintText As B4XView
        Private lblHintText As B4XView

        Private msVariant As String = "none"
        Private msSize As String = "md"
        Private msText As String = ""
        Private msPlaceholder As String = "Type here"
        Private msHintText As String = ""
        Private msErrorText As String = ""
        Private msLabelAbove As String = ""
        Private msInputType As String = "text"
        Private msDateFormat As String = "yyyy-MM-dd"
        Private msTimeFormat As String = "HH:mm"
        Private mbIs24Hours As Boolean = True
        Private msMinDate As String = ""
        Private msMaxDate As String = ""
        Private mDatePicker As AC_DatePicker
        Private mTimePicker As AC_TimePicker
        Private msPasswordChar As String = ""
        Private msIconLeft As String = ""
        Private msIconRight As String = ""
        Private mAppendIconColor As Int = 0
        Private msSearchIcon As String = "magnifying-glass-solid.svg"
        Private msClearIcon As String = "xmark-solid.svg"
        Private msShowClearButton As String = "always"
        Private msLabelLeft As String = ""
        Private msLabelRight As String = ""
        Private mbFloatingLabel As Boolean = False
        Private msRadius As String = "theme"
        Private mbEnabled As Boolean = True
        Private mbSingleLine As Boolean = True
        Private mbVisible As Boolean = True
        Private mcBackgroundColor As Int = 0
        Private mcTextColor As Int = 0
        Private mcPlaceholderColor As Int = 0
        Private msPadding As String = ""
        Private msShadow As String = "none"
        Private mbRequired As Boolean = False
        Private msValidationPattern As String = ""
        Private miMinLength As Int = 0
        Private miMaxLength As Int = 0
        Private msRequiredErrorText As String = ""
        Private msMinLengthErrorText As String = ""
        Private msMaxLengthErrorText As String = ""
        Private msPatternErrorText As String = ""
        Private msValidationErrorKey As String = ""
        Private mfMinValue As Double = 0
        Private mfMaxValue As Double = 100
        Private mfStepValue As Double = 1
        Private msValidationState As String = "none"
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False

        Private msImeOptions As String = "normal"
        Private msGravity As String = "LEFT"
        Private msTypeface As String = "DEFAULT"
        Private miMaxLines As Int = 1
        Private miMinLines As Int = 1
        Private mbAllCaps As Boolean = False
        Private mbReadOnly As Boolean = False
        Private mbCursorVisible As Boolean = True
        Private mfLetterSpacing As Float = 0
        Private mfAlpha As Float = 1.0
        Private mbNoAutoFill As Boolean = True

        Private mbFocused As Boolean = False
        Private mSettingText As Boolean = False
        Private miInputPaddingX As Int = 12dip
        Private mApplyingVisual As Boolean = False
        Private mbPasswordVisible As Boolean = False
        Private mbPasswordInput As Boolean = False
        Private miIconSize As Int = 0
        Private mvCompiledPattern As JavaObject
        ' Cached layout values for floating label updates from event handlers
        Private miLastLabelAboveH As Int = 0
        Private mbAutoHeight As Boolean = False
        Private mbProgrammaticFocus As Boolean = False
        Private miLineCount As Int = 1
    	Private inResize As Boolean = False
    End Sub

    Public Sub Initialize(oCallback As Object, sEventName As String)
        mCallBack = oCallback
        mEventName = sEventName
    End Sub

    Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
        mBase = oBase
        If mTag = Null Then mTag = mBase.Tag
        mBase.Tag = Me
        mBase.Color = xui.Color_Transparent

        Dim pSurface As Panel
        pSurface.Initialize("pnlSurface")
        pnlSurface = pSurface
        pnlSurface.Color = xui.Color_Transparent

        Dim initWidth As Int = mBase.Width
        If initWidth <= 0 Then initWidth = 200dip

        Dim initHeight As Int = mBase.Height
        If initHeight <= 0 Then initHeight = ResolveHeightDip
        mBase.AddView(pnlSurface, 0, 0, initWidth, initHeight)
        ApplyDesignerProps(mProps)
        Dim edt As EditText
        If mbSingleLine Then
            edt.Initialize("edt")
        Else
            edt.Initialize("edtMulti")
        End If
        edtInput = edt
        edtInput.Color = xui.Color_Transparent
        ' Guard the initial clear: edt_TextChanged would otherwise run with no guard
        ' and overwrite msText (set by ApplyDesignerProps / the caller) with "" , which
        ' then makes the re-apply blank the EDT (e.g. color type loses its "#000000").
        mApplyingVisual = True
        edtInput.Text = ""
        mApplyingVisual = False
        #If B4A
            Dim jo As JavaObject = edtInput
            jo.RunMethod("setHintTextColor", Array(xui.Color_RGB(156, 163, 175)))
            ApplyAutofillSettings
        #End If
        pnlSurface.AddView(edtInput, 0, 0, 1dip, 1dip)

        Dim pnlL As Panel
        pnlL.Initialize("pnlLeftIcon")
        pnlLeftIcon = pnlL
        pnlLeftIcon.Color = xui.Color_Transparent
        pnlSurface.AddView(pnlLeftIcon, 0, 0, 0, 0)

        Dim svgLeft As B4XDaisySvgIcon
        svgLeft.Initialize(Me, "")
        svgLeftIcon = svgLeft
        Dim svgLeftBase As B4XView = svgLeftIcon.CreateView(24dip, 24dip)
        pnlLeftIcon.AddView(svgLeftBase, 0, 0, 0, 0)
        svgLeftIcon.SetClickable(False)

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

        Dim pnlLLbl As Panel
        pnlLLbl.Initialize("")
        pnlLeftLabel = pnlLLbl
        pnlLeftLabel.Color = xui.Color_Transparent
        pnlSurface.AddView(pnlLeftLabel, 0, 0, 0, 0)

        Dim lblLLbl As Label
        lblLLbl.Initialize("")
        lblLeftLabel = lblLLbl
        lblLeftLabel.Color = xui.Color_Transparent
        lblLeftLabel.SetTextAlignment("CENTER", "CENTER")
        lblLeftLabel.As(Label).SingleLine = True
        pnlLeftLabel.AddView(lblLeftLabel, 0, 0, 0, 0)

        Dim pnlLBorder As Panel
        pnlLBorder.Initialize("")
        pnlLeftBorder = pnlLBorder
        pnlLeftBorder.Color = xui.Color_Transparent
        pnlLeftLabel.AddView(pnlLeftBorder, 0, 0, 1dip, 0)

        Dim pnlRLbl As Panel
        pnlRLbl.Initialize("")
        pnlRightLabel = pnlRLbl
        pnlRightLabel.Color = xui.Color_Transparent
        pnlSurface.AddView(pnlRightLabel, 0, 0, 0, 0)

        Dim lblRLbl As Label
        lblRLbl.Initialize("")
        lblRightLabel = lblRLbl
        lblRightLabel.Color = xui.Color_Transparent
        lblRightLabel.SetTextAlignment("CENTER", "CENTER")
        lblRightLabel.As(Label).SingleLine = True
        pnlRightLabel.AddView(lblRightLabel, 0, 0, 0, 0)

        Dim pnlRBorder As Panel
        pnlRBorder.Initialize("")
        pnlRightBorder = pnlRBorder
        pnlRightBorder.Color = xui.Color_Transparent
        pnlRightLabel.AddView(pnlRightBorder, 0, 0, 1dip, 0)

        Dim pnlFlt As Panel
        pnlFlt.Initialize("pnlFlt")
        pnlFloating = pnlFlt
        pnlFloating.Color = xui.Color_Transparent
        mBase.AddView(pnlFloating, 0, 0, 0, 0)

        Dim lblFlt As Label
        lblFlt.Initialize("")
        lblFloating = lblFlt
        lblFloating.Color = xui.Color_Transparent
        lblFloating.SetTextAlignment("TOP", "LEFT")
        lblFloating.As(Label).SingleLine = True
        #If B4A
            Dim joFlt As JavaObject = lblFloating
            joFlt.RunMethod("setIncludeFontPadding", Array(False))
        #End If
        pnlFloating.AddView(lblFloating, 0, 0, 0, 0)

        Dim pnlLA As Panel
        pnlLA.Initialize("")
        pnlLabelAbove = pnlLA
        pnlLabelAbove.Color = xui.Color_Transparent
        mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)

        Dim lblLA As Label
        lblLA.Initialize("")
        lblLabelAbove = lblLA
        lblLabelAbove.Color = xui.Color_Transparent
        lblLabelAbove.SetTextAlignment("LEFT", "LEFT")
        lblLabelAbove.As(Label).SingleLine = False
        pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

        Dim pnlHT As Panel
        pnlHT.Initialize("")
        pnlHintText = pnlHT
        pnlHintText.Color = xui.Color_Transparent
        mBase.AddView(pnlHintText, 0, 0, 0, 0)

        Dim lblHT As Label
        lblHT.Initialize("")
        lblHintText = lblHT
        lblHintText.Color = xui.Color_Transparent
        lblHintText.SetTextAlignment("LEFT", "LEFT")
        lblHintText.As(Label).SingleLine = False
        #If B4A
            Dim joHT As JavaObject = lblHintText
            joHT.RunMethod("setIncludeFontPadding", Array(False))
            ' Force native TOP|LEFT gravity so the text sits at the top-left of the panel,
            ' directly below the input border without extra vertical padding.
            joHT.RunMethod("setGravity", Array(Bit.Or(0x30, 0x03)))
        #End If
        pnlHintText.AddView(lblHintText, 0, 0, 0, 0)

        mApplyingVisual = True
        edtInput.Text = msText
        mApplyingVisual = False

        Refresh
    End Sub

    Private Sub ApplyDesignerProps(mProps As Map)
        msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
        msSize = B4XDaisyVariants.GetPropString(mProps, "Size", msSize)
        msText = B4XDaisyVariants.GetPropString(mProps, "Text", msText)
        msPlaceholder = B4XDaisyVariants.GetPropString(mProps, "Placeholder", msPlaceholder)
        msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", msHintText)
        msErrorText = B4XDaisyVariants.GetPropString(mProps, "ErrorText", msErrorText)
        msRequiredErrorText = B4XDaisyVariants.GetPropString(mProps, "RequiredErrorText", msRequiredErrorText)
        msMinLengthErrorText = B4XDaisyVariants.GetPropString(mProps, "MinLengthErrorText", msMinLengthErrorText)
        msMaxLengthErrorText = B4XDaisyVariants.GetPropString(mProps, "MaxLengthErrorText", msMaxLengthErrorText)
        msPatternErrorText = B4XDaisyVariants.GetPropString(mProps, "PatternErrorText", msPatternErrorText)
        msLabelAbove = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", msLabelAbove)
        msInputType = B4XDaisyVariants.GetPropString(mProps, "InputType", msInputType)
        msDateFormat = B4XDaisyVariants.GetPropString(mProps, "DateFormat", msDateFormat)
        msTimeFormat = B4XDaisyVariants.GetPropString(mProps, "TimeFormat", msTimeFormat)
        mbIs24Hours = B4XDaisyVariants.GetPropBool(mProps, "Is24Hours", mbIs24Hours)
        msPasswordChar = B4XDaisyVariants.GetPropString(mProps, "PasswordChar", msPasswordChar)
        msIconLeft = B4XDaisyVariants.GetPropString(mProps, "IconLeft", msIconLeft)
        msIconRight = B4XDaisyVariants.GetPropString(mProps, "IconRight", msIconRight)
        msLabelLeft = B4XDaisyVariants.GetPropString(mProps, "LabelLeft", msLabelLeft)
        msLabelRight = B4XDaisyVariants.GetPropString(mProps, "LabelRight", msLabelRight)
        mbFloatingLabel = B4XDaisyVariants.GetPropBool(mProps, "FloatingLabel", mbFloatingLabel)
        msRadius = B4XDaisyVariants.GetPropString(mProps, "Radius", msRadius)
        Dim radiusAlt As String = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRadius)
        If radiusAlt <> "theme" Then msRadius = radiusAlt

            If msInputType = "password" Then
                mbPasswordInput = True
                mbPasswordVisible = False
                If msIconRight = "" Then msIconRight = "eye-solid.svg"
            Else If msInputType = "stepper" Then
                mbPasswordInput = False
                mbPasswordVisible = False
                If msIconLeft = "" Then msIconLeft = "chevron-left-solid.svg"
                If msIconRight = "" Then msIconRight = "chevron-right-solid.svg"
                msGravity = "CENTER"
            Else If msInputType = "color" Then
                mbPasswordInput = False
                mbPasswordVisible = False
                If msIconRight = "" Then msIconRight = "palette-solid-full.svg"
                mbReadOnly = True
                If mAppendIconColor = 0 Or mAppendIconColor = xui.Color_Transparent Then
                    mAppendIconColor = xui.Color_Black
                End If
                If msText = "" Or msText = "Type here" Then
                    msText = "#000000"
                Else If msText.StartsWith("#") Or msText.StartsWith("0x") Or msText.Length = 6 Then
                    Dim parsedC As Int = HexToColor(msText)
                    If parsedC <> 0 Then mAppendIconColor = parsedC
                End If
            Else If msInputType = "date" Then
                mbPasswordInput = False
                mbPasswordVisible = False
                mbReadOnly = True
                If msIconRight = "" Then msIconRight = "calendar-days-regular-full.svg"
            Else If msInputType = "time" Then
                mbPasswordInput = False
                mbPasswordVisible = False
                mbReadOnly = True
                If msIconRight = "" Then msIconRight = "clock-regular-full.svg"
            Else
                mbPasswordInput = False
                mbPasswordVisible = False
            End If
            mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
            mbSingleLine = B4XDaisyVariants.GetPropBool(mProps, "SingleLine", mbSingleLine)
            mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
            mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
            mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
            mcPlaceholderColor = B4XDaisyVariants.GetPropColor(mProps, "PlaceholderColor", mcPlaceholderColor)
            msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
            msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow)
            mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", mbRequired)
            msValidationPattern = B4XDaisyVariants.GetPropString(mProps, "ValidationPattern", msValidationPattern)
            miMinLength = B4XDaisyVariants.GetPropInt(mProps, "MinLength", miMinLength)
            miMaxLength = B4XDaisyVariants.GetPropInt(mProps, "MaxLength", miMaxLength)
            mfMinValue = ParseStepperValueString(B4XDaisyVariants.GetPropString(mProps, "MinValue", "0"), mfMinValue)
            mfMaxValue = ParseStepperValueString(B4XDaisyVariants.GetPropString(mProps, "MaxValue", "100"), mfMaxValue)
            mfStepValue = ParseStepperValueString(B4XDaisyVariants.GetPropString(mProps, "StepValue", "1"), mfStepValue)
            msImeOptions = B4XDaisyVariants.GetPropString(mProps, "ImeOptions", msImeOptions)
            msSearchIcon = B4XDaisyVariants.GetPropString(mProps, "SearchIcon", msSearchIcon)
            msClearIcon = B4XDaisyVariants.GetPropString(mProps, "ClearIcon", msClearIcon)
            msShowClearButton = B4XDaisyVariants.GetPropString(mProps, "ShowClearButton", msShowClearButton).ToLowerCase
            msGravity = B4XDaisyVariants.GetPropString(mProps, "Gravity", msGravity)
            msTypeface = B4XDaisyVariants.GetPropString(mProps, "Typeface", msTypeface)
            miMaxLines = B4XDaisyVariants.GetPropInt(mProps, "MaxLines", miMaxLines)
            miMinLines = B4XDaisyVariants.GetPropInt(mProps, "MinLines", miMinLines)
            mbAllCaps = B4XDaisyVariants.GetPropBool(mProps, "AllCaps", mbAllCaps)
            mbReadOnly = B4XDaisyVariants.GetPropBool(mProps, "ReadOnly", mbReadOnly)
            mbCursorVisible = B4XDaisyVariants.GetPropBool(mProps, "CursorVisible", mbCursorVisible)
            mfLetterSpacing = B4XDaisyVariants.GetPropFloat(mProps, "LetterSpacing", mfLetterSpacing)
            mfAlpha = B4XDaisyVariants.GetPropFloat(mProps, "Alpha", mfAlpha)
            mbAutoHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoHeight", mbAutoHeight)
            mbNoAutoFill = B4XDaisyVariants.GetPropBool(mProps, "NoAutoFill", mbNoAutoFill)

            If msPadding.Length > 0 Then
            If B4XDaisyVariants.ContainsAny(msPadding, Array As String("px-", "p-")) Then
                Dim pxVal As String = B4XDaisyVariants.ExtractSpacingValue(msPadding)
                miInputPaddingX = Max(4dip, B4XDaisyBoxModel.TailwindSpacingToDip(pxVal, 12dip))
            Else
                miInputPaddingX = Max(4dip, B4XDaisyBoxModel.TailwindSpacingToDip(msPadding, 12dip))
            End If
        Else
            miInputPaddingX = 12dip
        End If
    End Sub

    Public Sub Base_Resize(dWidth As Double, dHeight As Double)
        If mBase.IsInitialized = False Then Return
        If pnlSurface.IsInitialized = False Then Return
        If edtInput.IsInitialized = False Then Return

        If inResize Then Return
        inResize = True
        Dim w As Int = dWidth
        If w <= 0 Then w = 200dip

        Dim inputH As Int = ResolveHeightDip
        Dim gap As Int = 2dip

        Dim labelAboveH As Int = 0
        Dim aboveTextSize As Float = 0
        Dim measuredLabelH As Int = 0
        If msLabelAbove.Length > 0 Then
        aboveTextSize = B4XDaisyVariants.ResolveLabelSizeDip(msSize)
        measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(ResolveLabelAboveText, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
        labelAboveH = measuredLabelH + 4dip
    End If

    Dim displayedHint As String = msHintText
    If msValidationState = "error" Then
        displayedHint = ResolveValidationErrorText
    End If
    Dim rawHintH As Int = 0
    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
    End If

Dim totalH As Int = labelAboveH + inputH
If rawHintH > 0 Then totalH = totalH + gap + rawHintH

' Cache layout values for floating label updates from event handlers
miLastLabelAboveH = labelAboveH

Dim curLeft As Int = mBase.Left
Dim curTop As Int = mBase.Top
mBase.SetLayoutAnimated(0, curLeft, curTop, w, totalH)

If msLabelAbove.Length > 0 And mbFloatingLabel = False Then
    ' Static label above the input (non-floating mode)
    pnlLabelAbove.Visible = True
    pnlLabelAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
    lblLabelAbove.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, measuredLabelH)
    Dim labelAboveColor As Int = ResolveLabelAboveColor
    ApplyRequiredLabelText(lblLabelAbove, ResolveLabelAboveText, labelAboveColor, ResolveRequiredStarColor(labelAboveColor))
    lblLabelAbove.TextSize = aboveTextSize
    lblLabelAbove.Enabled = True
Else
    ' In floating mode (or no label), hide the static label above
    pnlLabelAbove.Visible = False
    pnlLabelAbove.SetLayoutAnimated(0, 0, 0, 0, 0)
End If

Dim surfaceY As Int = labelAboveH
pnlSurface.SetLayoutAnimated(0, 0, surfaceY, w, inputH)

    Dim iconSize As Int
    If msInputType = "stepper" Then
        iconSize = inputH - 24dip
    Else
        iconSize = inputH - 8dip
    End If
    If iconSize < 10dip Then iconSize = 10dip
    miIconSize = iconSize
Dim iconGap As Int = 4dip

Dim leftW As Int = 0
Dim leftIsLabel As Boolean = False
If msLabelLeft.Length > 0 Then
leftW = MeasureLabelWidth(msLabelLeft)
leftIsLabel = True
Else If msIconLeft.Length > 0 Then
    leftW = iconSize
End If

Dim rightW As Int = 0
Dim rightIsLabel As Boolean = False
If msLabelRight.Length > 0 Then
rightW = MeasureLabelWidth(msLabelRight)
rightIsLabel = True
Else If msIconRight.Length > 0 Then
    rightW = iconSize
End If

Dim iconPadding As Int = miInputPaddingX / 2
If msInputType = "stepper" Then iconPadding = 10dip

Dim edtLeft As Int = miInputPaddingX
If leftW > 0 Then
    If leftIsLabel Then
        edtLeft = leftW + iconGap + miInputPaddingX / 2
    Else
        edtLeft = iconPadding + leftW + iconGap
    End If
End If

Dim edtRight As Int = w - miInputPaddingX
If rightW > 0 Then
    If rightIsLabel Then
        edtRight = edtRight - rightW - iconGap - miInputPaddingX / 2
    Else
        edtRight = w - iconPadding - rightW - iconGap
    End If
End If

Dim edtW As Int = Max(10dip, edtRight - edtLeft)
edtInput.SetLayoutAnimated(0, edtLeft, 0, edtW, inputH)

If leftW > 0 And leftIsLabel = False Then
pnlLeftIcon.Visible = True
pnlLeftIcon.SetLayoutAnimated(0, iconPadding, (inputH - iconSize) / 2, iconSize, iconSize)
Dim svgLeftBase As B4XView = svgLeftIcon.mBase
svgLeftBase.SetLayoutAnimated(0, 0, 0, iconSize, iconSize)
svgLeftIcon.Base_Resize(iconSize, iconSize)
ApplySvgIcon(svgLeftIcon, msIconLeft, iconSize, False)
Else
    pnlLeftIcon.Visible = False
    pnlLeftIcon.SetLayoutAnimated(0, 0, 0, 0, 0)
End If

If rightW > 0 And rightIsLabel = False Then
pnlRightIcon.Visible = True
pnlRightIcon.SetLayoutAnimated(0, w - rightW - iconPadding, (inputH - iconSize) / 2, iconSize, iconSize)
Dim svgRightBase As B4XView = svgRightIcon.mBase
svgRightBase.SetLayoutAnimated(0, 0, 0, iconSize, iconSize)
svgRightIcon.Base_Resize(iconSize, iconSize)
ApplySvgIcon(svgRightIcon, msIconRight, iconSize, True)
Else
    pnlRightIcon.Visible = False
    pnlRightIcon.SetLayoutAnimated(0, 0, 0, 0, 0)
End If

        If leftW > 0 And leftIsLabel Then
            pnlLeftLabel.Visible = True
            Dim lblLeftH As Int = inputH - 8dip
            pnlLeftLabel.SetLayoutAnimated(0, 0, (inputH - lblLeftH) / 2, leftW, lblLeftH)
            lblLeftLabel.SetLayoutAnimated(0, 12dip, 0, leftW - 12dip, lblLeftH)
            lblLeftLabel.Text = msLabelLeft
            lblLeftLabel.TextSize = ResolveTextSize
            lblLeftLabel.TextColor = ResolveInputColor
            lblLeftLabel.Enabled = mbEnabled
            pnlLeftBorder.Color = B4XDaisyVariants.Blend(ResolveInputColor, 0xFFFFFFFF, 0.1)
            pnlLeftBorder.SetLayoutAnimated(0, leftW - 1dip, 0, 1dip, lblLeftH)
        Else
            pnlLeftLabel.Visible = False
            pnlLeftLabel.SetLayoutAnimated(0, 0, 0, 0, 0)
        End If

        If rightW > 0 And rightIsLabel Then
            pnlRightLabel.Visible = True
            Dim lblRightH As Int = inputH - 8dip
            pnlRightLabel.SetLayoutAnimated(0, w - rightW, (inputH - lblRightH) / 2, rightW, lblRightH)
            lblRightLabel.SetLayoutAnimated(0, 0, 0, rightW - 12dip, lblRightH)
            lblRightLabel.Text = msLabelRight
            lblRightLabel.TextSize = ResolveTextSize
            lblRightLabel.TextColor = ResolveInputColor
            lblRightLabel.Enabled = mbEnabled
            pnlRightBorder.Color = B4XDaisyVariants.Blend(ResolveInputColor, 0xFFFFFFFF, 0.1)
            pnlRightBorder.SetLayoutAnimated(0, 0, 0, 1dip, lblRightH)
        Else
            pnlRightLabel.Visible = False
            pnlRightLabel.SetLayoutAnimated(0, 0, 0, 0, 0)
        End If

        If mbFloatingLabel And msLabelAbove.Length > 0 Then
            UpdateFloatingLabel(w, inputH, surfaceY)
        Else
            pnlFloating.Visible = False
            pnlFloating.SetLayoutAnimated(0, 0, 0, 0, 0)
        End If

        If displayedHint.Length > 0 Then
            pnlHintText.Visible = True
            Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
            lblHintText.Text = displayedHint
            lblHintText.TextSize = hintTxtSize
            Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
            Dim hintTxtColor As Int = Bit.Or(0x99000000, Bit.And(0x00FFFFFF, baseContent))
            Select msValidationState

                Case "error": hintTxtColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
            End Select
            lblHintText.TextColor = hintTxtColor
            ' Measure the raw text height without extra vertical padding; then add a small
            ' padding symmetric to the LabelAbove layout so the visible text sits close
            ' to the input border the same way the label above does.
            Dim measuredHintH As Int = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 0)
            Dim hintPanelH As Int = measuredHintH + 4dip
            Dim hintY As Int = surfaceY + inputH + gap
            pnlHintText.SetLayoutAnimated(0, 0, hintY, w, hintPanelH)
            lblHintText.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, measuredHintH)
        Else
            pnlHintText.Visible = False
            pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
        End If
ApplyVisual
        inResize = False
End Sub

Private Sub MeasureLabelWidth(sText As String) As Int
    Dim textSize As Float = ResolveTextSize
    Dim rawW As Int = B4XDaisyVariants.MeasureTextWidthSafe(sText, textSize, Typeface.DEFAULT, 0)
    Return rawW + 24dip
End Sub

Private Sub UpdateFloatingLabel(iWidth As Int, iInputHeight As Int, iSurfaceY As Int)
    If mbFloatingLabel = False Then Return
    If msLabelAbove.Length = 0 Then Return
    If pnlFloating.IsInitialized = False Then Return

    ' Floating label (AS_TextFieldAdvanced style):
    ' Animates between two positions with 250ms duration:
    '   Placeholder state (unfocused, empty): inside the input, full size, muted color
    '   Floating state (focused or has text): same position as LabelAbove (2dip, 2dip), small size, accent color
    '
    ' CRITICAL: The floating label's final position MUST match exactly where lblLabelAbove
    ' would be when FloatingLabel = False. lblLabelAbove sits at (2dip, 2dip) inside pnlLabelAbove,
    ' which sits at (0, 0) inside mBase. So in mBase coordinates: (2dip, 2dip).

    Dim shouldFloat As Boolean = mbFocused Or (msText <> Null And msText.Length > 0)

    ' Floating state uses text-sm (small), placeholder state uses input text size (large)
    Dim fltTextSize As Float
    If shouldFloat Then
        fltTextSize = B4XDaisyVariants.ResolveTextSizeDip("text-sm")
    Else
        fltTextSize = ResolveTextSize
    End If

    ' Measure text at target size for layout (include required star when present)
    Dim displayLabelText As String = ResolveLabelAboveText
    Dim fltW As Int = B4XDaisyVariants.MeasureTextWidthSafe(displayLabelText, fltTextSize, Typeface.DEFAULT, 4dip)
    Dim rawFltH As Int = B4XDaisyVariants.MeasureTextHeightSafe(displayLabelText, fltTextSize, Typeface.DEFAULT, fltW, 4dip)
    Dim fltH As Int = rawFltH + 4dip  ' text height + small vertical padding

    ' State-dependent color - floating matches LabelAbove color, placeholder is muted
    Dim fltLabelColor As Int = ResolveFloatingLabelColor(shouldFloat)

    ' AS_TextFieldAdvanced uses 250ms for animation
    Dim animDuration As Int = 250

    pnlFloating.Visible = True
    ApplyRequiredLabelText(lblFloating, displayLabelText, fltLabelColor, ResolveRequiredStarColor(fltLabelColor))

    If shouldFloat Then
        ' -- Floating state: label at the EXACT same position as lblLabelAbove --
        ' lblLabelAbove sits at (2dip, 2dip) inside pnlLabelAbove which is at (0,0) inside mBase.
        ' So the floating label must also be at (2dip, 2dip) in mBase coordinates.
        ' pnlFloating at (0, 0) + lblFloating at (2dip, 2dip) = same absolute position.
        lblFloating.SetTextSizeAnimated(animDuration, fltTextSize)
        lblFloating.SetTextAlignment("TOP", "LEFT")

        Dim fltPanelW As Int = fltW + 4dip

        pnlFloating.SetLayoutAnimated(animDuration, 0, 0, fltPanelW, fltH + 2dip)
        lblFloating.SetLayoutAnimated(animDuration, 2dip, 2dip, fltW, fltH)
        pnlFloating.Color = xui.Color_Transparent
        B4XDaisyVariants.ApplyElevation(pnlFloating, "none")
    Else
        ' -- Placeholder state: label centered inside the input area --
        ' Position inside pnlSurface area, centered vertically, aligned to input text.
        Dim defaultTop As Int = iSurfaceY + (iInputHeight - rawFltH) / 2
        Dim defaultLeft As Int = miInputPaddingX
        Dim fltPanelW2 As Int = fltW + 8dip

        lblFloating.SetTextSizeAnimated(animDuration, fltTextSize)
        lblFloating.SetTextAlignment("CENTER", "LEFT")

        pnlFloating.SetLayoutAnimated(animDuration, defaultLeft, defaultTop, fltPanelW2, rawFltH + 2dip)
        lblFloating.SetLayoutAnimated(animDuration, 4dip, 0, fltW, rawFltH)
        pnlFloating.Color = xui.Color_Transparent
        B4XDaisyVariants.ApplyElevation(pnlFloating, "none")
    End If
End Sub

Private Sub ResolveFloatingLabelColor(bShouldFloat As Boolean) As Int
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Dim base100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", 0xFFFFFFFF)
    Dim errorColor As Int = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFB3261E)

    If mbEnabled = False Then
        ' Disabled: onSurface @ 38% opacity
        Return B4XDaisyVariants.Blend(baseContent, base100, 0.38)
    Else If msValidationState = "error" Then
        ' Error state: error color
        Return errorColor
    Else If bShouldFloat Then
        ' Floating state: same color as static LabelAbove (baseContent)
        ' Matches AS_TextFieldAdvanced: floating label uses the title color
        Return baseContent
    Else
        ' Unfocused, empty: placeholder color (muted, like native hint)
        Return B4XDaisyVariants.Blend(baseContent, base100, 0.5)
    End If
End Sub


#Region Validation

    Private Sub RunValidation
        If mBase.IsInitialized = False Then Return
        If mbRequired = False And msValidationPattern.Length = 0 And miMinLength = 0 And miMaxLength = 0 Then
        If mbProgrammaticError Then
            msValidationState = "error"
        Else
            msValidationState = "none"
        End If
        Return
    End If
Dim txt As String = msText
Dim hasError As Boolean = False
msValidationErrorKey = ""

If mbRequired And txt.Trim.Length = 0 Then
    hasError = True
    msValidationErrorKey = "required"
End If
If hasError = False And miMinLength > 0 And txt.Trim.Length < miMinLength Then
    hasError = True
    msValidationErrorKey = "minlength"
End If
If hasError = False And miMaxLength > 0 And txt.Length > miMaxLength Then
    hasError = True
    msValidationErrorKey = "maxlength"
End If
If hasError = False And msValidationPattern.Length > 0 And txt.Trim.Length > 0 Then
#If B4A
    Try
        Dim ok As Boolean = False
        If mvCompiledPattern <> Null Then
            Dim matcher As JavaObject = mvCompiledPattern.RunMethod("matcher", Array(txt.Trim))
            ok = matcher.RunMethod("matches", Null)
        Else
            Dim jo As JavaObject
            jo.InitializeStatic("java.util.regex.Pattern")
            ok = jo.RunMethod("matches", Array(msValidationPattern, txt.Trim))
        End If
        If ok = False Then
            hasError = True
            msValidationErrorKey = "pattern"
        End If
    Catch
        hasError = True
        msValidationErrorKey = "pattern"
    End Try
#End If
End If
    If hasError Then
        msValidationState = "error"
        mbProgrammaticError = False
    Else If mbProgrammaticError Then
        msValidationState = "error"
        msValidationErrorKey = ""
    Else
        msValidationState = "valid"
    End If
    ' Only show validation colours (red/green) if the user has interacted or an explicit error was shown.
    If mbValidationTouched = False And mbProgrammaticError = False Then
        msValidationState = "none"
    End If
End Sub
#End Region

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    Dim targetH As Int = iHeight
    If targetH <= 0 Then targetH = ResolveHeightDip
    Dim targetW As Int = iWidth
    If targetW <= 0 Then targetW = Max(200dip, vParent.Width - iLeft * 2)
    If targetW <= 0 Then targetW = 200dip
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, targetW, targetH)
    Dim props As Map = BuildRuntimeProps(targetW, targetH)
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Dim finalH As Int = mBase.Height
    vParent.AddView(mBase, iLeft, iTop, targetW, finalH)
    Return mBase
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
    Dim props As Map
    props.Initialize
    props.Put("Variant", msVariant)
    props.Put("Size", msSize)
    props.Put("Text", msText)
    props.Put("Placeholder", msPlaceholder)
    props.Put("HintText", msHintText)
    props.Put("ErrorText", msErrorText)
    props.Put("LabelAbove", msLabelAbove)
    props.Put("InputType", msInputType)
    props.Put("IconLeft", msIconLeft)
    props.Put("IconRight", msIconRight)
    props.Put("LabelLeft", msLabelLeft)
    props.Put("LabelRight", msLabelRight)
    props.Put("FloatingLabel", mbFloatingLabel)
    props.Put("Required", mbRequired)
    props.Put("ValidationPattern", msValidationPattern)
    props.Put("MinLength", miMinLength)
    props.Put("MaxLength", miMaxLength)
    props.Put("Radius", msRadius)
    props.Put("Rounded", msRadius)
    props.Put("Enabled", mbEnabled)
    props.Put("SingleLine", mbSingleLine)
    props.Put("Visible", mbVisible)
    props.Put("BackgroundColor", mcBackgroundColor)
    props.Put("TextColor", mcTextColor)
    props.Put("PlaceholderColor", mcPlaceholderColor)
    props.Put("Padding", msPadding)
    props.Put("Shadow", msShadow)
    props.Put("ImeOptions", msImeOptions)
    props.Put("SearchIcon", msSearchIcon)
    props.Put("ClearIcon", msClearIcon)
    props.Put("ShowClearButton", msShowClearButton)
    props.Put("Gravity", msGravity)
    props.Put("Typeface", msTypeface)
    props.Put("MaxLines", miMaxLines)
    props.Put("MinLines", miMinLines)
    props.Put("AllCaps", mbAllCaps)
    props.Put("ReadOnly", mbReadOnly)
    props.Put("CursorVisible", mbCursorVisible)
    props.Put("LetterSpacing", mfLetterSpacing)
    props.Put("Alpha", mfAlpha)
    props.Put("NoAutoFill", mbNoAutoFill)
    Return props
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub GetComputedHeight As Int
    Dim inputH As Int = ResolveHeightDip
    Dim gap As Int = 2dip
    Dim labelAboveH As Int = 0
    Dim w As Int = mBase.Width
    If w <= 0 Then w = 200dip
    If msLabelAbove.Length > 0 Then
    Dim aboveTextSize As Float = B4XDaisyVariants.ResolveLabelSizeDip(msSize)
    Dim measuredLabelH As Int = B4XDaisyVariants.MeasureTextHeightSafe(ResolveLabelAboveText, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
    labelAboveH = measuredLabelH + 4dip
End If
    Dim displayedHint As String = msHintText
    If msValidationState = "error" Then
        displayedHint = ResolveValidationErrorText
    End If
    Dim rawHintH As Int = 0
    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 0)
    End If
    Dim hintPanelH As Int = 0
    If rawHintH > 0 Then hintPanelH = rawHintH + 4dip
    Dim totalH As Int = labelAboveH + inputH
    If hintPanelH > 0 Then totalH = totalH + gap + hintPanelH
    If mBase.IsInitialized And mBase.Height > 0 Then Return mBase.Height
    Return totalH
End Sub

Public Sub GetActualHeight As Int
    If mBase.IsInitialized Then Return mBase.Height
    Return 0
End Sub

Public Sub GetActualWidth As Int
    If mBase.IsInitialized Then Return mBase.Width
    Return 0
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

''' <summary>
''' Requests focus for the input field.
''' </summary>
Public Sub RequestFocus
    If edtInput.IsInitialized Then
        edtInput.RequestFocus
    End If
End Sub

''' <summary>
''' Disconnects event callbacks and nulls internal view references to allow
''' garbage collection. Call this when the component is no longer needed,
''' especially in B4XPages where views are created and destroyed dynamically.
''' After calling Release, the component is no longer usable.
''' </summary>

Public Sub Release
    #If B4A
        ' Disconnect EditText callbacks - prevents stale events on zombie instances.
        ' Setting the EditText to a new no-callback instance breaks the reference chain.
        If edtInput.IsInitialized Then
            Try
                Dim jo As JavaObject = edtInput
                jo.RunMethod("setOnFocusChangeListener", Array(Null)) ' remove focus listener
                jo.RunMethod("setOnEditorActionListener", Array(Null)) ' remove editor action listener
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInput.Release: " & LastException.Message)
                ' Silently ignore - view may already be detached
            End Try
        End If
    #End If
    ' Remove views from parent hierarchy
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
    ' Null internal view references to break reference chains
    ' (B4A GC can then collect the class instance)
    pnlSurface = Null
    edtInput = Null
    pnlLeftIcon = Null
    pnlRightIcon = Null
    svgLeftIcon = Null
    svgRightIcon = Null
    pnlLeftLabel = Null
    lblLeftLabel = Null
    pnlLeftBorder = Null
    pnlRightLabel = Null
    lblRightLabel = Null
    pnlRightBorder = Null
    pnlFloating = Null
    lblFloating = Null
    pnlLabelAbove = Null
    lblLabelAbove = Null
    pnlHintText = Null
    lblHintText = Null
    mvCompiledPattern = Null
    mCallBack = Null
End Sub

Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Private Sub Refresh
    If mBase.IsInitialized = False Then Return
    ApplySearchClearButton
    B4XDaisyVariants.DisableClipping(mBase)
    B4XDaisyVariants.DisableClipping(pnlSurface)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyVisual
    If edtInput.IsInitialized = False Then Return
    If mApplyingVisual Then Return
    mApplyingVisual = True
    Dim textSize As Float = ResolveTextSize
    Dim inputHeight As Int = ResolveHeightDip
    Dim radiusDip As Int = ResolveRadiusDip
    Dim borderDip As Int = Max(1dip, B4XDaisyVariants.GetBorderDip(1dip))
    Dim base100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", 0xFFFFFFFF)
    Dim base200 As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", 0xFFE5E7EB)
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Dim borderColor As Int = ResolveInputColor
    Dim bgColor As Int = base100
    Dim txtColor As Int = baseContent
    Dim hintColor As Int = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.5)
    If mcBackgroundColor <> 0 Then bgColor = mcBackgroundColor
    If mcTextColor <> 0 Then txtColor = mcTextColor
    If mcPlaceholderColor <> 0 Then hintColor = mcPlaceholderColor
    If msVariant = "ghost" Then
        If mbFocused Then
            If mcBackgroundColor = 0 Then bgColor = base100
            borderColor = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.1)
        Else
            If mcBackgroundColor = 0 Then bgColor = base100
            borderColor = xui.Color_Transparent
        End If
    End If
    If mbEnabled = False Then
        If mcBackgroundColor = 0 Then bgColor = base200
        ' Disabled text/hint muted to base-content @ 20% alpha (matches B4XDaisyFileInput for consistency).
        txtColor = B4XDaisyVariants.AlphaColor(baseContent, 0.2)
        hintColor = B4XDaisyVariants.AlphaColor(baseContent, 0.2)
        ' Disabled border: ghost = transparent, otherwise uniformly muted gray (variant tint dropped).
        If msVariant = "ghost" Then
            borderColor = xui.Color_Transparent
        Else
            borderColor = B4XDaisyVariants.Blend(baseContent, bgColor, 0.2)
        End If
    Else
        Select msValidationState
            Case "valid": borderColor = B4XDaisyVariants.GetTokenColor("--color-success", 0xFF22C55E)
            Case "error": borderColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
            Case Else
                If mbFocused And msVariant <> "ghost" Then borderColor = baseContent
            End Select
    End If
    Dim edtText As String = edtInput.Text
    If edtText = Null Then edtText = ""
    If edtText <> msText Then edtInput.Text = msText
    edtInput.TextSize = textSize
    #If B4A
        Dim jo2 As JavaObject = edtInput
        Dim shouldFloat As Boolean = mbFocused Or (msText <> Null And msText.Length > 0)
        ' When floating label is active, always clear the native hint - our lblFloating handles both states
        If mbFloatingLabel And msLabelAbove.Length > 0 Then
            jo2.RunMethod("setHint", Array(""))
        Else If mbEnabled And shouldFloat Then
            jo2.RunMethod("setHint", Array(""))
        Else
            jo2.RunMethod("setHint", Array(msPlaceholder))
        End If
        jo2.RunMethod("setSingleLine", Array(mbSingleLine))
        Dim padT As Int = 8dip
        Dim padB As Int = 8dip
        If mbSingleLine Then
            padT = 0
            padB = 0
        End If
        jo2.RunMethod("setPadding", Array(0, padT, 0, padB))
        jo2.RunMethod("setHintTextColor", Array(hintColor))
        jo2.RunMethod("setTextColor", Array(txtColor))
        ' Typeface: resolve from token string to native Typeface
        Dim tf As Typeface = ResolveTypeface
        jo2.RunMethod("setTypeface", Array(tf))
        ' Gravity: horizontal text alignment within EditText
        Dim gravityFlags As Int = ResolveGravity
        jo2.RunMethod("setGravity", Array(gravityFlags))
        Dim desc As String = msLabelAbove
        If desc = Null Or desc.Length = 0 Then desc = msPlaceholder
        jo2.RunMethod("setContentDescription", Array(desc))
        If mbNoAutoFill Then
            jo2.RunMethod("setBackground", Array(Null))
            Try
                jo2.RunMethod("setDefaultFocusHighlightEnabled", Array(False))
            Catch
            	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInput.ApplyVisual: " & LastException.Message)
            End Try
        End If
    #End If
    edtInput.Enabled = mbEnabled
    ' Alpha: view opacity
    If mfAlpha < 1.0 Then
        mBase.Alpha = mfAlpha
    Else
        mBase.Alpha = 1.0
    End If
    ' Save cursor position - setInputType() resets it to 0 on Android
    #If B4A
        Dim cursorPos As Int = 0
        If edtInput.IsInitialized Then
            Try
                cursorPos = edtInput.SelectionStart
            Catch
                cursorPos = 0
            End Try
        End If
    #End If
    ApplyInputType
    ' Post-ApplyInputType: these must run AFTER ApplyInputType to avoid being overwritten
    ApplyNativeProperties
    ApplyImeOptions
    ' Re-apply password masking AFTER ApplyNativeProperties: setSingleLine()/setInputType()
    ' inside ApplyNativeProperties can reset the transformation method, so the custom '*'
    ' mask must be applied last to survive.
    ApplyPasswordTransformation
    ' Re-apply text AFTER ApplyNativeProperties: setKeyListener(Null) for read-only inputs
    ' (e.g. color type) recreates the EditText text buffer and blanks displayed text, so
    ' the value synced above at the start of ApplyVisual disappears on first render.
    #If B4A
        If edtInput.IsInitialized Then
            Dim postTxt As String = edtInput.Text
            If postTxt = Null Then postTxt = ""
            If postTxt <> msText Then
                edtInput.Text = msText
            End If
        End If
    #End If
    ' Restore cursor position - setInputType() resets cursor to position 0 on Android
    #If B4A
        If mbFocused And edtInput.IsInitialized Then
            Try
                If cursorPos >= 0 And cursorPos <= edtInput.Text.Length Then
                    edtInput.SetSelection(cursorPos, cursorPos)
                End If
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInput.ApplyVisual: " & LastException.Message)
                ' Silently ignore - selection may be invalid after input type change
            End Try
        End If
    #End If
    B4XDaisyVariants.ApplyEditTextBorder(pnlSurface, bgColor, borderDip, borderColor, radiusDip)
    B4XDaisyVariants.ApplyElevation(pnlSurface, msShadow)
    mApplyingVisual = False
End Sub

Private Sub ResolveInputColor As Int
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Dim defaultColor As Int = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.2)
    Select msVariant
        Case "neutral": Return B4XDaisyVariants.GetTokenColor("--color-neutral", defaultColor)
        Case "primary": Return B4XDaisyVariants.GetTokenColor("--color-primary", defaultColor)
        Case "secondary": Return B4XDaisyVariants.GetTokenColor("--color-secondary", defaultColor)
        Case "accent": Return B4XDaisyVariants.GetTokenColor("--color-accent", defaultColor)
        Case "info": Return B4XDaisyVariants.GetTokenColor("--color-info", defaultColor)
        Case "success": Return B4XDaisyVariants.GetTokenColor("--color-success", defaultColor)
        Case "warning": Return B4XDaisyVariants.GetTokenColor("--color-warning", defaultColor)
        Case "error": Return B4XDaisyVariants.GetTokenColor("--color-error", defaultColor)
        Case Else: Return defaultColor
    End Select
End Sub

Private Sub ResolvePlaceholderColor As Int
    If mcPlaceholderColor <> 0 Then Return mcPlaceholderColor
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Return B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.5)
End Sub

Private Sub ResolveHeightDip As Int
    Dim baseH As Int
    Select msSize
        Case "lg": baseH = 48dip
        Case "xl": baseH = 56dip
        Case Else: baseH = 40dip
    End Select
    ' Multiline: scale height by line count, enforcing min height of 80dip (min-h-20)
    If mbSingleLine = False Then
        If mbAutoHeight Then
            Dim lines As Int = GetTextLineCount
            Dim count As Int = Max(2, Min(miMaxLines, lines))
            Return baseH * count
        Else
            Return Max(80dip, baseH * miMaxLines)
        End If
    End If
    Return baseH
End Sub

Private Sub GetTextLineCount As Int
    If edtInput.IsInitialized Then
        #If B4A
        Dim jo As JavaObject = edtInput
        Dim lines As Int = jo.RunMethod("getLineCount", Null)
        If lines > 0 Then Return lines
        #End If
    End If
    ' Fallback count based on LF characters
    If msText = Null Or msText = "" Then Return 1
    Dim linesCount As Int = 1
    Dim start As Int = 0
    Do While True
        Dim idx As Int = msText.IndexOf2(Chr(10), start)
        If idx >= 0 Then
            linesCount = linesCount + 1
            start = idx + 1
        Else
            Exit
        End If
    Loop
    Return linesCount
End Sub

Private Sub ResolveTextSize As Float
    Select msSize
        Case "lg": Return 18
        Case "xl": Return 22
        Case Else: Return 14
    End Select
End Sub

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

Private Sub ApplySvgIcon(svgIcon As B4XDaisySvgIcon, sIcon As String, iSize As Int, bisRightIcon As Boolean)
    If svgIcon.IsInitialized = False Then Return
    If sIcon.Length = 0 Then Return
    Dim txtColor As Int
    If bisRightIcon And mAppendIconColor <> 0 And mAppendIconColor <> xui.Color_Transparent Then
        txtColor = mAppendIconColor
    Else If mbEnabled Then
        txtColor = ResolveInputColor
    Else
        txtColor = B4XDaisyVariants.GetTokenColor("--color-base-200", 0xFFE5E7EB)
    End If
    Dim actualIcon As String = sIcon
    If mbPasswordInput And bisRightIcon Then
        If mbPasswordVisible Then actualIcon ="eye-slash-solid.svg" Else actualIcon ="eye-solid.svg"
    End If
    svgIcon.setSvgAsset(actualIcon)
    svgIcon.setColor(txtColor)
End Sub

Private Sub TogglePasswordVisibility
    If mbPasswordInput = False Then Return
    mbPasswordVisible = Not(mbPasswordVisible)
    #If B4A
        Dim jo As JavaObject = edtInput
        ' Use plain text input type (NOT the password variation) + a custom transformation
        ' for masking. This avoids Android recognizing an email+password login form,
        ' which triggers the autofill yellow highlight on adjacent email fields.
        jo.RunMethod("setInputType", Array(Bit.Or(0x00000001, 0x00080000)))
        edtInput.PasswordMode = False
        If mbPasswordVisible = False Then
            Dim effChar As String = msPasswordChar
            If effChar.Length = 0 Then effChar = "*"
            Dim nativeMe As JavaObject = Me
            Dim transform As Object = nativeMe.RunMethod("getAsteriskTransformation", Array(effChar))
            jo.RunMethod("setTransformationMethod", Array(transform))
        End If
    #End If
    If pnlRightIcon.Visible And svgRightIcon.IsInitialized Then
        Dim svgRightBase As B4XView = svgRightIcon.mBase
        svgRightBase.SetLayoutAnimated(0, 0, 0, miIconSize, miIconSize)
        svgRightIcon.Base_Resize(miIconSize, miIconSize)
        ApplySvgIcon(svgRightIcon, msIconRight, miIconSize, True)
    End If
    #If B4A
        Dim jo2 As JavaObject = edtInput
        jo2.RunMethod("requestFocus", Null)
    #End If
    If edtInput.IsInitialized Then
        Try
		 edtInput.SetSelection(edtInput.Text.Length, 0)
		  Catch
		 End Try
    End If
End Sub

Private Sub ApplyInputType
    If edtInput.IsInitialized = False Then Return
    #If B4A
        Dim jo As JavaObject = edtInput
        ' TYPE_TEXT_FLAG_NO_SUGGESTIONS (0x00008000) prevents spell-check underlines
        Dim NO_SUGGEST As Int = 0x00008000
        Dim NUMBER_FLAG_DECIMAL As Int = 0x00002000
        Dim NUMBER_FLAG_SIGNED As Int = 0x00001000
        Select msInputType
            Case "number": jo.RunMethod("setInputType", Array(0x00000002))
            Case "decimal": jo.RunMethod("setInputType", Array(Bit.Or(Bit.Or(0x00000002, NUMBER_FLAG_DECIMAL), NUMBER_FLAG_SIGNED)))
            Case "phone": jo.RunMethod("setInputType", Array(0x00000003))
            Case "email": jo.RunMethod("setInputType", Array(Bit.Or(Bit.Or(0x00000001, 0x00000021), NO_SUGGEST)))
            Case "url": jo.RunMethod("setInputType", Array(Bit.Or(Bit.Or(0x00000001, 0x00000006), NO_SUGGEST)))
            Case "password"
                ' Plain text input type + custom transformation (see ApplyPasswordTransformation).
                ' Avoids the password input-type variation so Android does not detect a
                ' login form (which would highlight the email field with autofill yellow).
                jo.RunMethod("setInputType", Array(Bit.Or(0x00000001, 0x00080000)))
                edtInput.PasswordMode = False
            Case "date", "time", "datetime": jo.RunMethod("setInputType", Array(0))
            Case "stepper": jo.RunMethod("setInputType", Array(0x00000002))
            Case Else: jo.RunMethod("setInputType", Array(Bit.Or(0x00000001, NO_SUGGEST))): edtInput.PasswordMode = False
        End Select
        ' ImeOptions: keyboard action button
        ApplyImeOptions
    #End If
End Sub

' Apply the custom password mask character ('*' by default). Must be called AFTER
' ApplyNativeProperties, because setSingleLine()/setInputType() there can reset the
' EditText transformation method. Uses a plain text input type (no password variation)
' so Android does not flag the form as a login form and yellow-highlight the email.
Private Sub ApplyPasswordTransformation
    If edtInput.IsInitialized = False Then Return
    If mbPasswordInput = False Then Return
    If mbPasswordVisible Then Return
    #If B4A
        Dim jo As JavaObject = edtInput
        Dim effChar As String = msPasswordChar
        If effChar.Length = 0 Then effChar = "*"
        Dim nativeMe As JavaObject = Me
        Dim transform As Object = nativeMe.RunMethod("getAsteriskTransformation", Array(effChar))
        jo.RunMethod("setTransformationMethod", Array(transform))
    #End If
End Sub

Private Sub ApplyImeOptions
    #If B4A
        Try
            If edtInput.IsInitialized = False Then Return
            Dim jo As JavaObject = edtInput
        Dim imeAction As Int
        Dim effIme As String = msImeOptions.ToLowerCase
        If msInputType = "search" And effIme = "normal" Then effIme = "actionsearch"
        Select effIme
            Case "actionnext": imeAction = 0x00000005  ' IME_ACTION_NEXT
            Case "actiongo": imeAction = 0x00000002      ' IME_ACTION_GO
            Case "actionsearch": imeAction = 0x00000003  ' IME_ACTION_SEARCH
            Case "actionsend": imeAction = 0x00000004    ' IME_ACTION_SEND
            Case "actiondone": imeAction = 0x00000006    ' IME_ACTION_DONE
            Case "actionnone": imeAction = 0x00000001    ' IME_ACTION_NONE
            Case Else: imeAction = 0x00000006            ' IME_ACTION_DONE (default)
        End Select
        ' Multiline: Enter key must insert a newline, not trigger an action.
        ' Add IME_FLAG_NO_ENTER_ACTION so the keyboard shows a newline key
        ' instead of an action button like "Done" or "Next".
        If mbSingleLine = False Then
            imeAction = Bit.Or(imeAction, 0x04000000)  ' IME_FLAG_NO_ENTER_ACTION
        End If
        jo.RunMethod("setImeOptions", Array(imeAction))
        Catch
            Log("B4XDaisyInput.ApplyImeOptions: " & LastException.Message)
        End Try
    #End If
End Sub

Private Sub ResolveTypeface As Typeface
    Select msTypeface.ToUpperCase
        Case "DEFAULT_BOLD": Return Typeface.DEFAULT_BOLD
        Case "MONOSPACE": Return Typeface.MONOSPACE
        Case "SANS_SERIF": Return Typeface.SANS_SERIF
        Case "SERIF": Return Typeface.SERIF
        Case Else: Return Typeface.DEFAULT
    End Select
End Sub

Private Sub ResolveGravity As Int
    ' Android Gravity constants: CENTER=17, LEFT=3, RIGHT=5
    ' SingleLine: CENTER_VERTICAL (16) for vertical centering
    ' Multiline: TOP (48) for text starting at top, wrapping down
    Dim verticalFlag As Int
    If mbSingleLine = False Then
        verticalFlag = 0x00000030  ' TOP -  text starts at top for multiline
    Else
        verticalFlag = 0x00000010  ' CENTER_VERTICAL -  text centered for single line
    End If
    Select msGravity.ToUpperCase
        Case "CENTER": Return Bit.Or(0x00000001, verticalFlag)  ' CENTER_HORIZONTAL | vertical
        Case "RIGHT": Return Bit.Or(0x00000005, verticalFlag)   ' RIGHT | vertical
        Case Else: Return Bit.Or(0x00000003, verticalFlag)      ' LEFT | vertical
    End Select
End Sub

' Apply native properties that must run AFTER ApplyInputType to avoid being overwritten.
' AllCaps modifies inputType, ReadOnly sets keyListener to null -  both would be
' undone if applied before ApplyInputType resets the inputType.
Private Sub ApplyNativeProperties
    If edtInput.IsInitialized = False Then Return
    #If B4A
        Dim jo As JavaObject = edtInput
        ' Multiline: must run after ApplyInputType to avoid single-line override.
        ' OR TYPE_TEXT_FLAG_MULTI_LINE (0x00020000) into inputType and setSingleLine(False)
        If mbSingleLine = False Then
            Dim currentType As Int = jo.RunMethod("getInputType", Null).As(Int)
            jo.RunMethod("setInputType", Array(Bit.Or(currentType, 0x00020000)))
            jo.RunMethod("setSingleLine", Array(False))
            If miMinLines > 1 Then
                jo.RunMethod("setMinLines", Array(miMinLines))
            End If
        Else
            jo.RunMethod("setSingleLine", Array(True))
        End If
        ' AllCaps: OR TYPE_TEXT_FLAG_CAP_CHARACTERS (0x00004000) into current inputType
        If mbAllCaps Then
            Dim currentType As Int = jo.RunMethod("getInputType", Null).As(Int)
            jo.RunMethod("setInputType", Array(Bit.Or(currentType, 0x00004000)))
        End If
        ' CursorVisible
        jo.RunMethod("setCursorVisible", Array(mbCursorVisible))
        ' LetterSpacing (API 21+)
        If mfLetterSpacing <> 0 Then
            jo.RunMethod("setLetterSpacing", Array(mfLetterSpacing))
        End If
        ' ReadOnly: focusable + selectable but not editable.
        ' ApplyInputType already restored the correct KeyListener for the current
        ' input type, so we only need to null it out when ReadOnly=True.
        If msInputType = "date" Or msInputType = "time" Or msInputType = "color" Then
            jo.RunMethod("setFocusable", Array(False))
            jo.RunMethod("setFocusableInTouchMode", Array(False))
            jo.RunMethod("setCursorVisible", Array(False))
            jo.RunMethod("setClickable", Array(True))
            jo.RunMethod("setKeyListener", Array(Null))
        Else If mbReadOnly Then
            jo.RunMethod("setFocusable", Array(True))
            jo.RunMethod("setFocusableInTouchMode", Array(True))
            jo.RunMethod("setLongClickable", Array(True))
            jo.RunMethod("setKeyListener", Array(Null)) ' disables editing
        End If
        ' Autofill: must run AFTER setInputType, which can reset importantForAutofill on some Android versions.
        ' IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS (8) prevents the yellow highlight that Android
        ' applies when it detects a login form (email + password fields). Using NO (2) blocks data
        ' saving but NOT the highlight - using 8 on the EditText itself suppresses it entirely.
        jo.RunMethod("setImportantForAutofill", Array(8)) ' IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS
        ' Clear any autofill type hints Android infers from inputType (e.g. email -> AUTOFILL_HINT_EMAIL_ADDRESS)
        ' so Android has no basis to show the autofill yellow overlay on this field.
        jo.RunMethod("setAutofillHints", Array(Null))
        ' Also mark the surface panel and outer base so Android excludes the entire input subtree from autofill
        Dim joSurf As JavaObject = pnlSurface
        joSurf.RunMethod("setImportantForAutofill", Array(8)) ' IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS
        Dim joBase As JavaObject = mBase
        joBase.RunMethod("setImportantForAutofill", Array(8))
        ' Prevent Android state save/restore from confusing multiple EditTexts
        jo.RunMethod("setSaveEnabled", Array(False))
    #End If
End Sub


#Region Public Property Setters/Getters
    Public Sub setText(sValue As String)
        If sValue = Null Then sValue = ""
        msText = sValue
        If msInputType = "color" And sValue.Length > 0 Then
            Dim parsedC As Int = HexToColor(sValue)
            If parsedC <> 0 Then mAppendIconColor = parsedC
        End If
        If edtInput.IsInitialized Then
            Dim edtText As String = edtInput.Text
            If edtText = Null Then edtText = ""
            If edtText <> sValue Then
                mSettingText = True
                edtInput.Text = sValue
                mSettingText = False
                If sValue.Length > 0 Then
                    Try
					 edtInput.SetSelection(sValue.Length, sValue.Length)
					  Catch
					 End Try
                End If
            End If
        End If
        If mBase.IsInitialized = False Then Return
        ' Validation is manual-only; do not auto-validate on programmatic text changes.
        Refresh
    End Sub

Public Sub getText As String
    ' Color type keeps the hex in msText. The read-only EDT (setKeyListener Null)
    ' can display blank on some OEMs (e.g. Honor), so return the backing field,
    ' not the EDT, so callers (e.g. color wheel seeding) get the true hex.
    If msInputType = "color" Then Return msText
    If edtInput.IsInitialized Then
    Dim txt As String = edtInput.Text
    If txt = Null Then txt = ""
    Return txt
End If
Return msText
End Sub

Public Sub setPlaceholder(sValue As String)
    If sValue = Null Then sValue = ""
    msPlaceholder = sValue
    #If B4A
        If edtInput.IsInitialized Then
        Dim jo3 As JavaObject = edtInput
        jo3.RunMethod("setHint", Array(sValue))
    End If
#End If
End Sub

Public Sub getPlaceholder As String
    Return msPlaceholder
End Sub

Public Sub setHintText(sValue As String)
    If sValue = Null Then sValue = ""
    msHintText = sValue.Trim
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHintText As String
    Return msHintText
End Sub


Private Sub ResolveLabelDisplayText(sBaseText As String) As String
    If sBaseText.Length > 0 And mbRequired And sBaseText.Contains("*") = False Then
        Return sBaseText & " *"
    End If
    Return sBaseText
End Sub

Private Sub ResolveLabelAboveText As String
    Return ResolveLabelDisplayText(msLabelAbove)
End Sub

Private Sub ResolveLabelAboveColor As Int
    Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    If mbEnabled = False Then
        Return B4XDaisyVariants.AlphaColor(c, 0.2)
    End If
    Return c
End Sub


Private Sub ResolveValidationErrorText As String
    If msValidationState <> "error" Then Return ""
    Select msValidationErrorKey
        Case "required"
            If msRequiredErrorText.Length > 0 Then Return msRequiredErrorText
            Return "This field is required"
        Case "minlength"
            If msMinLengthErrorText.Length > 0 Then Return msMinLengthErrorText
            Return "Minimum " & miMinLength & " characters required"
        Case "maxlength"
            If msMaxLengthErrorText.Length > 0 Then Return msMaxLengthErrorText
            Return "Maximum " & miMaxLength & " characters allowed"
        Case "pattern"
            If msPatternErrorText.Length > 0 Then Return msPatternErrorText
            Return "Invalid format"
        Case Else
            Return msErrorText
    End Select
End Sub

Public Sub GetValidationError As String
    Return ResolveValidationErrorText
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
Public Sub setLabelAbove(sValue As String)
    If sValue = Null Then sValue = ""
    msLabelAbove = sValue.Trim
    If mBase.IsInitialized Then RunValidation: Refresh
End Sub

Public Sub getLabelAbove As String
    Return msLabelAbove
End Sub

Public Sub setVariant(sValue As String)
    If sValue = Null Then sValue = "none"
    msVariant = sValue.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setSize(sValue As String)
    If sValue = Null Then sValue = "md"
    msSize = sValue.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setInputType(sValue As String)
    If sValue = Null Then sValue = "text"
    msInputType = sValue.ToLowerCase
    If msInputType = "password" Then
        mbPasswordInput = True: mbPasswordVisible = False
        If msIconRight = "" Then msIconRight = "eye-solid.svg"
    Else If msInputType = "stepper" Then
        mbPasswordInput = False: mbPasswordVisible = False
        If msIconLeft = "" Then msIconLeft = "chevron-left-solid.svg"
        If msIconRight = "" Then msIconRight = "chevron-right-solid.svg"
        msGravity = "CENTER"
    Else If msInputType = "color" Then
        mbPasswordInput = False: mbPasswordVisible = False
        If msIconRight = "" Then msIconRight = "palette-solid-full.svg"
        mbReadOnly = True
        If mAppendIconColor = 0 Or mAppendIconColor = xui.Color_Transparent Then
            mAppendIconColor = xui.Color_Black
        End If
        If msText = "" Or msText = "Type here" Then
            msText = "#000000"
        Else If msText.StartsWith("#") Or msText.StartsWith("0x") Or msText.Length = 6 Then
            Dim parsedC2 As Int = HexToColor(msText)
            If parsedC2 <> 0 Then mAppendIconColor = parsedC2
        End If
    Else If msInputType = "date" Then
        mbPasswordInput = False: mbPasswordVisible = False
        mbReadOnly = True
        If msIconRight = "" Then msIconRight = "calendar-days-regular-full.svg"
    Else If msInputType = "time" Then
        mbPasswordInput = False: mbPasswordVisible = False
        mbReadOnly = True
        If msIconRight = "" Then msIconRight = "clock-regular-full.svg"
    Else
        mbPasswordInput = False: mbPasswordVisible = False
    End If
    If mBase.IsInitialized Then ApplyInputType: Refresh
End Sub

Public Sub setAppendIcon(sValue As String)
    setIconRight(sValue)
End Sub

Public Sub getAppendIcon As String
    Return getIconRight
End Sub

Public Sub setAppendIconColor(iValue As Int)
    mAppendIconColor = iValue
    If msInputType = "color" And iValue <> xui.Color_Transparent Then
        Dim hexVal As String = ColorToHex(iValue)
        If msText <> hexVal Then
            msText = hexVal
            If edtInput.IsInitialized Then
                mSettingText = True
                edtInput.Text = hexVal
                mSettingText = False
            End If
        End If
    End If
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAppendIconColor As Int
    Return mAppendIconColor
End Sub

Public Sub setAppendColor(iValue As Int)
    setAppendIconColor(iValue)
End Sub

Public Sub getAppendColor As Int
    Return getAppendIconColor
End Sub

Private Sub ApplySearchClearButton
    If msInputType <> "search" Then Return
    If msIconLeft = "" Then msIconLeft = msSearchIcon
    Dim show As Boolean = False
    If msShowClearButton = "always" Then
        show = True
    Else If msShowClearButton = "focus" Then
        show = mbFocused
    End If
    Dim clearAsset As String = msClearIcon
    If clearAsset.Trim.Length = 0 Then clearAsset = "xmark-solid.svg"
    If show Then
        If msIconRight <> clearAsset Then msIconRight = clearAsset
    Else
        If msIconRight <> "" Then msIconRight = ""
    End If
End Sub

Private Sub ClearSearchText
    If edtInput.IsInitialized = False Then Return
    mSettingText = True
    edtInput.Text = ""
    msText = ""
    mSettingText = False
    If xui.SubExists(mCallBack, mEventName & "_Clear", 0) Then
        CallSub(mCallBack, mEventName & "_Clear")
    End If
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub setSearchIcon(sValue As String)
    If sValue = Null Then sValue = ""
    msSearchIcon = sValue.Trim
    If msSearchIcon.Length = 0 Then msSearchIcon = "magnifying-glass-solid.svg"
    If msInputType = "search" And mBase.IsInitialized Then Refresh
End Sub

Public Sub getSearchIcon As String
    Return msSearchIcon
End Sub

Public Sub setClearIcon(sValue As String)
    If sValue = Null Then sValue = ""
    msClearIcon = sValue.Trim
    If mBase.IsInitialized Then ApplySearchClearButton: Refresh
End Sub

Public Sub getClearIcon As String
    Return msClearIcon
End Sub

Public Sub setShowClearButton(sValue As String)
    If sValue = Null Then sValue = "always"
    Dim v As String = sValue.ToLowerCase.Trim
    If v <> "never" And v <> "focus" And v <> "always" Then v = "always"
    msShowClearButton = v
    If mBase.IsInitialized Then ApplySearchClearButton: Refresh
End Sub

Public Sub getShowClearButton As String
    Return msShowClearButton
End Sub

Public Sub setPasswordChar(sValue As String)
        If sValue = Null Then sValue = ""
        msPasswordChar = sValue
        If mBase.IsInitialized Then ApplyInputType: Refresh
    End Sub

    Public Sub getPasswordChar As String
        Return msPasswordChar
    End Sub

    Public Sub getInputType As String
        Return msInputType
    End Sub

    Public Sub setMinValue(sValue As String)
        If sValue = Null Then sValue = ""
        mfMinValue = ParseStepperValueString(sValue, mfMinValue)
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getMinValue As String
        Return FormatStepperValue(mfMinValue)
    End Sub

    Public Sub setMaxValue(sValue As String)
        If sValue = Null Then sValue = ""
        mfMaxValue = ParseStepperValueString(sValue, mfMaxValue)
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getMaxValue As String
        Return FormatStepperValue(mfMaxValue)
    End Sub

    Public Sub setStepValue(sValue As String)
        If sValue = Null Then sValue = ""
        mfStepValue = ParseStepperValueString(sValue, mfStepValue)
        If mfStepValue < 0 Then mfStepValue = 0
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getStepValue As String
        Return FormatStepperValue(mfStepValue)
    End Sub

    Public Sub setIconLeft(sValue As String)
        msIconLeft = sValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getIconLeft As String
        Return msIconLeft
    End Sub

    Public Sub setIconRight(sValue As String)
        msIconRight = sValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getIconRight As String
        Return msIconRight
    End Sub

    Public Sub setRadius(sValue As String)
        msRadius = sValue
        If mBase.IsInitialized Then Refresh
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
        If edtInput.IsInitialized Then edtInput.Enabled = bValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getEnabled As Boolean
        Return mbEnabled
    End Sub

    Public Sub setSingleLine(bValue As Boolean)
        mbSingleLine = bValue
        #If B4A
            If edtInput.IsInitialized Then
            Dim jo4 As JavaObject = edtInput
            jo4.RunMethod("setSingleLine", Array(bValue))
        End If
    #End If
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSingleLine As Boolean
    Return mbSingleLine
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
    If mBase.IsInitialized Then Refresh
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
    If mBase.IsInitialized Then Refresh
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
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPlaceholderColor As Int
    Return mcPlaceholderColor
End Sub

Public Sub setPadding(sValue As String)
    msPadding = sValue
    If msPadding.Length > 0 Then
    If B4XDaisyVariants.ContainsAny(msPadding, Array As String("px-", "p-")) Then
        Dim pxVal As String = B4XDaisyVariants.ExtractSpacingValue(msPadding)
        miInputPaddingX = Max(4dip, B4XDaisyBoxModel.TailwindSpacingToDip(pxVal, 12dip))
    Else
        miInputPaddingX = Max(4dip, B4XDaisyBoxModel.TailwindSpacingToDip(msPadding, 12dip))
    End If
Else
    miInputPaddingX = 12dip
End If
If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setShadow(sValue As String)
    msShadow = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setLabelLeft(sValue As String)
    msLabelLeft = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelLeft As String
    Return msLabelLeft
End Sub

Public Sub setLabelRight(sValue As String)
    msLabelRight = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelRight As String
    Return msLabelRight
End Sub

Public Sub setFloatingLabel(bValue As Boolean)
    mbFloatingLabel = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getFloatingLabel As Boolean
    Return mbFloatingLabel
End Sub


#Region Native Property API

    Public Sub setImeOptions(sValue As String)
        If sValue = Null Then sValue = "normal"
        msImeOptions = sValue.ToLowerCase
        If mBase.IsInitialized Then ApplyImeOptions
    End Sub

    Public Sub getImeOptions As String
        Return msImeOptions
    End Sub

    Public Sub setGravity(sValue As String)
        If sValue = Null Then sValue = "LEFT"
        msGravity = sValue.ToUpperCase
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getGravity As String
        Return msGravity
    End Sub

    Public Sub setTypeface(sValue As String)
        If sValue = Null Then sValue = "DEFAULT"
        msTypeface = sValue.ToUpperCase
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getTypeface As String
        Return msTypeface
    End Sub

    Public Sub setMaxLines(iValue As Int)
        miMaxLines = Max(1, iValue)
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getMaxLines As Int
        Return miMaxLines
    End Sub

    Public Sub setMinLines(iValue As Int)
        miMinLines = Max(1, iValue)
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getMinLines As Int
        Return miMinLines
    End Sub

    Public Sub setAllCaps(bValue As Boolean)
        mbAllCaps = bValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getAllCaps As Boolean
        Return mbAllCaps
    End Sub

    Public Sub setReadOnly(bValue As Boolean)
        mbReadOnly = bValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getReadOnly As Boolean
        Return mbReadOnly
    End Sub

    Public Sub setCursorVisible(bValue As Boolean)
        mbCursorVisible = bValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getCursorVisible As Boolean
        Return mbCursorVisible
    End Sub

    Public Sub setLetterSpacing(fValue As Float)
        mfLetterSpacing = fValue
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getLetterSpacing As Float
        Return mfLetterSpacing
    End Sub

    Public Sub setAlpha(fValue As Float)
        If fValue < 0 Then fValue = 0
        If fValue > 1 Then fValue = 1
        mfAlpha = fValue
        If mBase.IsInitialized Then
            mBase.Alpha = mfAlpha
        End If
    End Sub

    Public Sub getAlpha As Float
        Return mfAlpha
    End Sub

    Public Sub setAutoHeight(bValue As Boolean)
        mbAutoHeight = bValue
        If mBase.IsInitialized = False Then Return
        Refresh
    End Sub

    Public Sub getAutoHeight As Boolean
        Return mbAutoHeight
    End Sub

    Public Sub setNoAutoFill(bValue As Boolean)
        mbNoAutoFill = bValue
        If mBase.IsInitialized Then
            ApplyAutofillSettings
            Refresh
        End If
    End Sub

    Public Sub getNoAutoFill As Boolean
        Return mbNoAutoFill
    End Sub

#End Region

#Region Validation API

    Public Sub setRequired(bValue As Boolean)
        mbRequired = bValue
        If mBase.IsInitialized Then RunValidation: Refresh
    End Sub

    Public Sub getRequired As Boolean
        Return mbRequired
    End Sub

    Public Sub setValidationPattern(sValue As String)
        If sValue = Null Then sValue = ""
        msValidationPattern = sValue
        mvCompiledPattern = Null
        If msValidationPattern.Length > 0 Then
        #If B4A
            Try
                Dim jo As JavaObject
                jo.InitializeStatic("java.util.regex.Pattern")
                mvCompiledPattern = jo.RunMethod("compile", Array(msValidationPattern))
            Catch
                mvCompiledPattern = Null
            End Try
            #End If
        End If
        If mBase.IsInitialized Then RunValidation: Refresh
    End Sub

    Public Sub getValidationPattern As String
        Return msValidationPattern
    End Sub

    Public Sub setMinLength(iValue As Int)
        miMinLength = Max(0, iValue)
        If mBase.IsInitialized Then RunValidation: Refresh
    End Sub

    Public Sub getMinLength As Int
        Return miMinLength
    End Sub

    Public Sub setMaxLength(iValue As Int)
        miMaxLength = Max(0, iValue)
        If mBase.IsInitialized Then RunValidation: Refresh
    End Sub

    Public Sub getMaxLength As Int
        Return miMaxLength
    End Sub

    Public Sub setValidationState(sValue As String)
        msValidationState = sValue.ToLowerCase
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getValidationState As String
        Return msValidationState
    End Sub

    Public Sub getIsValid As Boolean
        Return (msValidationState = "valid")
    End Sub

    Public Sub Revalidate
        If mBase.IsInitialized Then
            RunValidation
            Refresh
        End If
    End Sub

    Public Sub setErrorText(sValue As String)
        If sValue = Null Then
            sValue = ""
        End If
        msErrorText = sValue
        If mBase.IsInitialized Then
            Refresh
        End If
    End Sub


    Public Sub setRequiredErrorText(sValue As String)
        If sValue = Null Then sValue = ""
        msRequiredErrorText = sValue.Trim
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getRequiredErrorText As String
        Return msRequiredErrorText
    End Sub

    Public Sub setMinLengthErrorText(sValue As String)
        If sValue = Null Then sValue = ""
        msMinLengthErrorText = sValue.Trim
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getMinLengthErrorText As String
        Return msMinLengthErrorText
    End Sub

    Public Sub setMaxLengthErrorText(sValue As String)
        If sValue = Null Then sValue = ""
        msMaxLengthErrorText = sValue.Trim
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getMaxLengthErrorText As String
        Return msMaxLengthErrorText
    End Sub

    Public Sub setPatternErrorText(sValue As String)
        If sValue = Null Then sValue = ""
        msPatternErrorText = sValue.Trim
        If mBase.IsInitialized Then Refresh
    End Sub

    Public Sub getPatternErrorText As String
        Return msPatternErrorText
    End Sub

    Public Sub getErrorText As String
        Return msErrorText
    End Sub

    Public Sub getIsBlank As Boolean
        Return (getText.Trim.Length = 0)
    End Sub

    ''' <summary>
    ''' Performs validation checks on the current input value and returns True if valid, False if invalid.
    ''' Updates validation UI indicators.
    ''' </summary>
    Public Sub Validate As Boolean
        mbValidationTouched = True
        mbProgrammaticError = False
        RunValidation
        If mBase.IsInitialized Then
            Refresh
        End If
        Return (msValidationState = "valid" Or msValidationState = "none")
    End Sub

    ''' <summary>
    ''' Alias for Validate().
    ''' </summary>
    Public Sub CheckValidation As Boolean
        Return Validate
    End Sub

    ''' <summary>
    ''' Dynamically sets the input into an error validation state and displays the specified error text.
    ''' </summary>
    Public Sub ShowError(sErrorMessage As String)
        msErrorText = sErrorMessage
        msValidationState = "error"
        mbProgrammaticError = True
        msValidationErrorKey = ""
        If mBase.IsInitialized Then
            Refresh
        End If
    End Sub

    ''' <summary>
    ''' Clears any dynamic error state and returns the input to normal.
    ''' </summary>
    Public Sub ClearError
        msErrorText = ""
        msValidationState = "none"
        mbProgrammaticError = False
        If mBase.IsInitialized Then
            Refresh
        End If
    End Sub

    ''' <summary>
    ''' Called when the input receives focus. Clears any transient error
    ''' visual so the user can edit without a distracting red border.
    ''' </summary>
    Public Sub ReceiveFocus
        mbFocused = True
        ' Only clear validation errors on focus; preserve programmatic errors set via ShowError.
        If msValidationState = "error" And mbProgrammaticError = False Then
            msValidationState = "none"
        End If
        If mBase.IsInitialized Then Refresh
        ' When focus is set programmatically (e.g. via Next/Done key), place cursor at the end.
        If mbProgrammaticFocus Then
            mbProgrammaticFocus = False
            If edtInput.IsInitialized And msText.Length > 0 Then
                Try
					 edtInput.SetSelection(msText.Length, msText.Length)
				Catch
				 End Try
            End If
        End If
    End Sub

    ''' <summary>
    ''' Called when the input loses focus.
    ''' </summary>
    Public Sub Blur
        mbFocused = False
        mbProgrammaticFocus = False
        If mBase.IsInitialized Then
            RunValidation
            Refresh
        End If
    End Sub
#End Region

Public Sub setFocus(bValue As Boolean)
    If edtInput.IsInitialized = False Then Return
    #If B4A
        Dim jo As JavaObject = edtInput
        If bValue Then
            jo.RunMethod("requestFocus", Null)
            mbProgrammaticFocus = True
        Else
            jo.RunMethod("clearFocus", Null)
            mbProgrammaticFocus = False
        End If
    #End If
End Sub

Public Sub getIsFocused As Boolean
    Return mbFocused
End Sub

Public Sub getEditText As B4XView
    Return edtInput
End Sub

Public Sub SelectAll
    If edtInput.IsInitialized Then edtInput.SelectAll
End Sub

Public Sub SetSelection(iStartPos As Int, iLength As Int)
    If edtInput.IsInitialized Then edtInput.SetSelection(iStartPos, iLength)
End Sub


#End Region

#Region Events

    Private Sub edt_TextChanged(sOld As String, sNew As String)
        If mApplyingVisual Then Return
        If mSettingText Then
            msText = sNew
            Return
        End If
        If sNew = Null Then sNew = ""
        ' Autofill rejection: Android autofill writes text to UNFOCUSED EditTexts.
        ' Revert any external text change on an unfocused input back to our backing field.
        If mbFocused = False And sOld <> sNew Then
            If edtInput.IsInitialized Then
                mApplyingVisual = True
                edtInput.Text = msText
                mApplyingVisual = False
            End If
            Return
        End If
        msText = sNew
        ' Keep Android autofill from drawing its yellow overlay while the user is typing.
        If mbFocused Then CancelAutofillHighlight
        ' Validation is manual-only; text changes do not auto-validate.
        #If B4A
        If mbSingleLine = False And mbAutoHeight Then
            Dim currentNew As String = sNew
            Sleep(30)
            If edtInput.IsInitialized = False Or msText <> currentNew Then Return
            Dim lines As Int = GetTextLineCount
            If lines <> miLineCount Then
                miLineCount = lines
                Refresh
                If xui.SubExists(mCallBack, mEventName & "_TextChanged", 2) Then
                    CallSub3(mCallBack, mEventName & "_TextChanged", sOld, currentNew)
                End If
                Return
            End If
        End If
        #End If
        ' Validation is manual-only; text changes do not trigger validation.
        mApplyingVisual = True
        ' Update floating label position when text changes (placeholder -> floating transition)
        If mbFloatingLabel And msLabelAbove.Length > 0 And pnlFloating.IsInitialized Then
            UpdateFloatingLabel(mBase.Width, ResolveHeightDip, miLastLabelAboveH)
        End If
        If xui.SubExists(mCallBack, mEventName & "_TextChanged", 2) Then
            CallSub3(mCallBack, mEventName & "_TextChanged", sOld, sNew)
        End If
        mApplyingVisual = False
    End Sub

    Private Sub edt_EnterPressed
    If mbSingleLine = False Then
        #If B4A
            Dim jo As JavaObject = edtInput
            Dim startPos As Int = jo.RunMethod("getSelectionStart", Null)
            Dim endPos As Int = jo.RunMethod("getSelectionEnd", Null)
            If startPos < 0 Then startPos = 0
            If endPos < 0 Then endPos = 0
            Dim text As String = edtInput.Text
            If text = Null Then text = ""
            If startPos > text.Length Then startPos = text.Length
            If endPos > text.Length Then endPos = text.Length
            
            Dim minPos As Int = Min(startPos, endPos)
            Dim maxPos As Int = Max(startPos, endPos)
            
            Dim newText As String = text.SubString2(0, minPos) & CRLF & text.SubString(maxPos)
            edtInput.Text = newText
            edtInput.SetSelection(minPos + 1, 0)
        #End If
        Return
    End If
    Dim text As String = ""
    If edtInput.IsInitialized Then
        text = edtInput.Text
        If text = Null Then text = ""
    End If
    If xui.SubExists(mCallBack, mEventName & "_EnterPressed", 1) Then
        CallSub2(mCallBack, mEventName & "_EnterPressed", text)
    Else If xui.SubExists(mCallBack, mEventName & "_EnterPressed", 0) Then
        CallSub(mCallBack, mEventName & "_EnterPressed")
    End If
End Sub

Private Sub ApplyAutofillSettings
    #If B4A
        If edtInput.IsInitialized = False Then Return
        Dim jo As JavaObject = edtInput
        If mbNoAutoFill Then
            ' IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS (8) prevents Android autofill from
            ' highlighting/filling this field and any child views (e.g. the native EditText).
            jo.RunMethod("setImportantForAutofill", Array(8))
            jo.RunMethod("setAutofillHints", Array(Null))
            jo.RunMethod("setSaveEnabled", Array(False))
            jo.RunMethod("setBackground", Array(Null))
            Try
                jo.RunMethod("setDefaultFocusHighlightEnabled", Array(False))
            Catch
            	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInput.ApplyAutofillSettings: " & LastException.Message)
            End Try
            ' Also exclude the outer container from autofill so the framework never traverses
            ' into this input's subtree from the parent layout.
            If pnlSurface.IsInitialized Then
                Dim joSurf As JavaObject = pnlSurface
                joSurf.RunMethod("setImportantForAutofill", Array(8))
            End If
            If mBase.IsInitialized Then
                Dim joBase As JavaObject = mBase
                joBase.RunMethod("setImportantForAutofill", Array(8))
            End If
            CancelAutofillHighlight
        Else
            jo.RunMethod("setImportantForAutofill", Array(0)) ' IMPORTANT_FOR_AUTOFILL_AUTO
            jo.RunMethod("setSaveEnabled", Array(True))
            If pnlSurface.IsInitialized Then
                Dim joSurf As JavaObject = pnlSurface
                joSurf.RunMethod("setImportantForAutofill", Array(0))
            End If
            If mBase.IsInitialized Then
                Dim joBase As JavaObject = mBase
                joBase.RunMethod("setImportantForAutofill", Array(0))
            End If
            If msInputType = "email" Then
                jo.RunMethod("setAutofillHints", Array(Array As String("emailAddress")))
            Else If msInputType = "password" Then
                jo.RunMethod("setAutofillHints", Array(Array As String("password")))
            Else If msInputType = "phone" Then
                jo.RunMethod("setAutofillHints", Array(Array As String("phone")))
            Else
                jo.RunMethod("setAutofillHints", Array(Null))
            End If
        End If
    #End If
End Sub

' Cancel any active Android autofill highlight on this input.
' Called on focus changes and while typing, because some OEM autofill services ignore
' IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS and still draw the yellow overlay.
Private Sub CancelAutofillHighlight
    #If B4A
        If mbNoAutoFill = False Then Return
        Try
            Dim joAF As JavaObject = edtInput
            joAF.RunMethod("setImportantForAutofill", Array(8)) ' re-assert EXCLUDE_DESCENDANTS
            joAF.RunMethod("setBackground", Array(Null))
            Try
                joAF.RunMethod("setDefaultFocusHighlightEnabled", Array(False))
            Catch
            	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInput.CancelAutofillHighlight: " & LastException.Message)
            End Try
            Dim context As JavaObject = joAF.RunMethod("getContext", Null)
            Dim afmService As JavaObject = context.RunMethod("getSystemService", Array("autofill"))
            If afmService.IsInitialized Then
                afmService.RunMethod("cancel", Null)
            End If
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInput.CancelAutofillHighlight: " & LastException.Message)
            ' Silently ignore - AutofillManager not available on this device/API level
        End Try
    #End If
End Sub

Private Sub edt_FocusChanged(bHasFocus As Boolean)
    mbFocused = bHasFocus
    CancelAutofillHighlight
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

Private Sub edt_Click
    If msInputType = "date" Then
        ShowDatePicker
    Else If msInputType = "time" Then
        ShowTimePicker
    End If
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub

Private Sub edtMulti_Click
    edt_Click
End Sub

Private Sub pnlSurface_Click
    If msInputType = "date" Then
        ShowDatePicker
    Else If msInputType = "time" Then
        ShowTimePicker
    Else
        If edtInput.IsInitialized Then
        #If B4A
            Dim jo5 As JavaObject = edtInput
            jo5.RunMethod("requestFocus", Null)
        #End If
        End If
    End If
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub

Private Sub pnlLeftIcon_Click
    If msInputType = "stepper" Then UpdateStepperValue(-mfStepValue)
    If msInputType = "date" Then ShowDatePicker
    If msInputType = "time" Then ShowTimePicker
    If xui.SubExists(mCallBack, mEventName & "_PrependClick", 0) Then
        CallSub(mCallBack, mEventName & "_PrependClick")
    End If
End Sub

Private Sub pnlRightIcon_Click
    If mbPasswordInput Then TogglePasswordVisibility
    If msInputType = "stepper" Then UpdateStepperValue(mfStepValue)
    If msInputType = "date" Then ShowDatePicker
    If msInputType = "time" Then ShowTimePicker
    If msInputType = "search" Then
        ClearSearchText
        Return
    End If
    If xui.SubExists(mCallBack, mEventName & "_AppendClick", 0) Then
        CallSub(mCallBack, mEventName & "_AppendClick")
    End If
End Sub

' M3: Focus delegation - clicking the floating label overlay panel focuses the input
Private Sub pnlFlt_Click
    #If B4A
        If msInputType = "date" Then
            ShowDatePicker
            Return
        Else If msInputType = "time" Then
            ShowTimePicker
            Return
        End If
        Dim jo As JavaObject = edtInput
        jo.RunMethod("requestFocus", Null)
    #End If
End Sub
Private Sub edtMulti_TextChanged(sOld As String, sNew As String)
    edt_TextChanged(sOld, sNew)
End Sub

Private Sub edtMulti_FocusChanged(bHasFocus As Boolean)
    edt_FocusChanged(bHasFocus)
End Sub
#End Region


' ========================================
' STEPPER INPUT HELPERS
' ========================================

Private Sub UpdateStepperValue(dDelta As Double)
    If msInputType <> "stepper" Then Return
    Dim oldText As String = msText
    Dim currentVal As Double = ParseStepperNumber(msText)
    Dim newVal As Double = currentVal + dDelta
    Dim decPlaces As Int = StepperDecimalPlaces
    newVal = Round2(newVal, decPlaces)
    If newVal < mfMinValue Then newVal = mfMinValue
    If newVal > mfMaxValue Then newVal = mfMaxValue
    Dim newText As String = FormatStepperValue(newVal)
    If newText = oldText Then Return
    msText = newText
    If edtInput.IsInitialized Then
        mSettingText = True
        edtInput.Text = newText
        mSettingText = False
    End If
    ' Validation is manual-only; stepper changes do not auto-validate.
    Refresh
    If xui.SubExists(mCallBack, mEventName & "_TextChanged", 2) Then
        CallSub3(mCallBack, mEventName & "_TextChanged", oldText, newText)
    End If
End Sub

Private Sub ParseStepperNumber(sText As String) As Double
    If sText = Null Then Return 0
    Dim s As String = sText.Trim
    If s.Length = 0 Then Return 0
    Try
        Return s
    Catch
        Return 0
    End Try
End Sub

Private Sub ParseStepperValueString(sValue As String, dDefaultValue As Double) As Double
    If sValue = Null Then Return dDefaultValue
    Dim s As String = sValue.Trim
    If s.Length = 0 Then Return dDefaultValue
    Try
        Return s
    Catch
        Return dDefaultValue
    End Try
End Sub

Private Sub FormatStepperValue(dValue As Double) As String
    If Floor(dValue) = dValue Then
        Return NumberFormat(dValue, 1, 0)
    Else
        Dim s As String = NumberFormat2(dValue, 1, 6, 6, False)
        Do While s.Contains(".") And s.EndsWith("0")
            s = s.SubString2(0, s.Length - 1)
        Loop
        If s.EndsWith(".") Then s = s.SubString2(0, s.Length - 1)
        Return s
    End If
End Sub

Private Sub StepperDecimalPlaces As Int
    Dim s As String = FormatStepperValue(mfStepValue)
    Dim p As Int = s.IndexOf(".")
    If p >= 0 Then Return s.Length - p - 1
    Return 0
End Sub

#If Java
import android.text.method.PasswordTransformationMethod;
import android.view.View;

public Object getAsteriskTransformation(final String maskChar) {
    if (maskChar == null || maskChar.length() == 0) {
        return PasswordTransformationMethod.getInstance();
    }
    final char c = maskChar.charAt(0);
    return new PasswordTransformationMethod() {
        @Override
        public CharSequence getTransformation(CharSequence source, View view) {
            return new PasswordCharSequence(source, c);
        }

        class PasswordCharSequence implements CharSequence {
            private CharSequence mSource;
            private char mChar;
            public PasswordCharSequence(CharSequence source, char c) {
                mSource = source;
                mChar = c;
            }
            public char charAt(int index) {
                return mChar;
            }
            public int length() {
                return mSource.length();
            }
            public CharSequence subSequence(int start, int end) {
                return new PasswordCharSequence(mSource.subSequence(start, end), mChar);
            }
        }
    };
}
#End If

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
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

#Region Color Hex Conversion Helpers
Private Sub ColorToHex(iC As Int) As String
	Dim r As Int = Bit.And(Bit.ShiftRight(iC, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iC, 8), 0xFF)
	Dim b As Int = Bit.And(iC, 0xFF)
	Return "#" & IntToHex2(r) & IntToHex2(g) & IntToHex2(b)
End Sub

Private Sub IntToHex2(iValue As Int) As String
	Dim hexChars As String = "0123456789abcdef"
	Dim high As Int = Bit.ShiftRight(iValue, 4)
	Dim low As Int = Bit.And(iValue, 0x0F)
	Return hexChars.CharAt(high) & hexChars.CharAt(low)
End Sub

Private Sub HexToColor(sHexStr As String) As Int
	Dim cleanHex As String = sHexStr.Replace("#", "").Replace("0x", "").Trim.ToLowerCase
	If cleanHex.Length = 3 Then
		Dim c1 As String = cleanHex.CharAt(0)
		Dim c2 As String = cleanHex.CharAt(1)
		Dim c3 As String = cleanHex.CharAt(2)
		cleanHex = c1 & c1 & c2 & c2 & c3 & c3
	End If
	If cleanHex.Length <> 6 Then Return 0
    
	Dim r As Int = HexToInt(cleanHex.SubString2(0, 2))
	Dim g As Int = HexToInt(cleanHex.SubString2(2, 4))
	Dim b As Int = HexToInt(cleanHex.SubString2(4, 6))
	Return xui.Color_RGB(r, g, b)
End Sub

Private Sub HexToInt(sHexVal As String) As Int
	Dim hexChars As String = "0123456789abcdef"
	Dim res As Int = 0
	For i = 0 To sHexVal.Length - 1
		Dim ch As String = sHexVal.CharAt(i)
		Dim idx As Int = hexChars.IndexOf(ch)
		If idx >= 0 Then
			res = res * 16 + idx
		End If
	Next
	Return Bit.Or(0xFF000000, res)
End Sub
#End Region

Public Sub setDateFormat(sValue As String)
    If sValue = Null Or sValue = "" Then sValue = "yyyy-MM-dd"
    msDateFormat = sValue
End Sub

Public Sub getDateFormat As String
    Return msDateFormat
End Sub

Public Sub setTimeFormat(sValue As String)
    If sValue = Null Or sValue = "" Then sValue = "HH:mm"
    msTimeFormat = sValue
End Sub

Public Sub getTimeFormat As String
    Return msTimeFormat
End Sub

Public Sub setIs24Hours(bValue As Boolean)
    mbIs24Hours = bValue
End Sub

Public Sub getIs24Hours As Boolean
    Return mbIs24Hours
End Sub

Public Sub setMinDate(sValue As String)
    msMinDate = sValue
End Sub

Public Sub getMinDate As String
    Return msMinDate
End Sub

Public Sub setMaxDate(sValue As String)
    msMaxDate = sValue
End Sub

Public Sub getMaxDate As String
    Return msMaxDate
End Sub

Public Sub ShowDatePicker
    If mDatePicker.IsInitialized = False Then
        mDatePicker.Initialize(Me, "mDatePicker")
    End If
    If msMinDate.Length > 0 Then mDatePicker.SetMinDate(FormatDateForNativePicker(msMinDate))
    If msMaxDate.Length > 0 Then mDatePicker.SetMaxDate(FormatDateForNativePicker(msMaxDate))
    
    Dim initialTick As Long = DateTime.Now
    Dim sVal As String = msText.Trim
    If sVal.Length > 0 Then
        Dim oldFmt As String = DateTime.DateFormat
        Try
            DateTime.DateFormat = msDateFormat
            initialTick = DateTime.DateParse(sVal)
            DateTime.DateFormat = oldFmt
        Catch
            DateTime.DateFormat = oldFmt
            initialTick = DateTime.Now
        End Try
    End If
    mDatePicker.Show(initialTick)
End Sub

Private Sub FormatDateForNativePicker(sDateStr As String) As String
    If sDateStr.Trim.Length = 0 Then Return ""
    Dim oldFmt As String = DateTime.DateFormat
    Dim tick As Long = 0
    Try
        DateTime.DateFormat = msDateFormat
        tick = DateTime.DateParse(sDateStr.Trim)
        DateTime.DateFormat = "dd/MM/yyyy"
        Dim res As String = DateTime.Date(tick)
        DateTime.DateFormat = oldFmt
        Return res
    Catch
        DateTime.DateFormat = oldFmt
        Return sDateStr
    End Try
End Sub

Private Sub mDatePicker_OkClicked (lDateTick As Long)
    Dim oldFmt As String = DateTime.DateFormat
    Dim formattedDate As String
    Try
        DateTime.DateFormat = msDateFormat
        formattedDate = DateTime.Date(lDateTick)
        DateTime.DateFormat = oldFmt
    Catch
        DateTime.DateFormat = oldFmt
        formattedDate = DateTime.Date(lDateTick)
    End Try
    setText(formattedDate)
    If xui.SubExists(mCallBack, mEventName & "_DateSelected", 2) Then
        CallSub3(mCallBack, mEventName & "_DateSelected", lDateTick, formattedDate)
    End If
End Sub

Public Sub ShowTimePicker
    If mTimePicker.IsInitialized = False Then
        mTimePicker.Initialize(Me, "mTimePicker")
    End If
    Dim initialTick As Long = DateTime.Now
    Dim sVal As String = msText.Trim
    If sVal.Length > 0 Then
        Dim oldFmt As String = DateTime.TimeFormat
        Try
            DateTime.TimeFormat = msTimeFormat
            initialTick = DateTime.TimeParse(sVal)
            DateTime.TimeFormat = oldFmt
        Catch
            DateTime.TimeFormat = oldFmt
            initialTick = DateTime.Now
        End Try
    End If
    mTimePicker.Show(initialTick, mbIs24Hours)
End Sub

Private Sub mTimePicker_OkClicked (iHour As Int, iMinute As Int)
    Dim timeStr As String
    If mbIs24Hours Then
        timeStr = NumberFormat(iHour, 2, 0) & ":" & NumberFormat(iMinute, 2, 0)
    Else
        Dim ampm As String = IIf(iHour < 12, "AM", "PM")
        Dim h12 As Int = iHour Mod 12
        If h12 = 0 Then h12 = 12
        timeStr = NumberFormat(h12, 2, 0) & ":" & NumberFormat(iMinute, 2, 0) & " " & ampm
    End If
    setText(timeStr)
    If xui.SubExists(mCallBack, mEventName & "_TimeSelected", 2) Then
        CallSub3(mCallBack, mEventName & "_TimeSelected", iHour, iMinute)
    End If
End Sub
