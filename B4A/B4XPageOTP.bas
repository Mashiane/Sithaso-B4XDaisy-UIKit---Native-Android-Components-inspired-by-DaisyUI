B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9

'================================================================
' B4XPageOTP
' Demo page regenerating every Ionic v8 ion-input-otp example for
' the B4XDaisyOTP component (parity reference).
'================================================================

#Region Variables
    Sub Class_Globals
        Private Root As B4XView
        Private xui As XUI
        Private pageScroll As B4XDaisyPageScroll
        Private pnlHost As B4XView

        ' Components
        Private otpBasic1, otpBasic2 As B4XDaisyOTP
        Private otpType1, otpType2 As B4XDaisyOTP
        Private otpShape1, otpShape2, otpShape3 As B4XDaisyOTP
        Private otpFill1, otpFill2 As B4XDaisyOTP
        Private otpSize1, otpSize2, otpSize3, otpSize4, otpSize5 As B4XDaisyOTP
        Private otpSep1, otpSep2, otpSep3 As B4XDaisyOTP
        Private otpState1, otpState2, otpState3, otpState4 As B4XDaisyOTP
        Private otpPattern1, otpPattern2, otpPattern3, otpPattern4, otpPattern5, otpPattern6 As B4XDaisyOTP
        Private otpColor1, otpColor2, otpColor3, otpColor4, otpColor5, otpColor6, otpColor7, otpColor8, otpColor9 As B4XDaisyOTP
        Private otpCustom1, otpCustom2 As B4XDaisyOTP
        Private otpFocus1, otpFocus2, otpFocus3 As B4XDaisyOTP
        Private otpRounded1, otpRounded2, otpRounded3 As B4XDaisyOTP
    End Sub
#End Region

#Region Initialization
    ''' <summary>Initializes the demo page.</summary>
    Public Sub Initialize As Object
        Return Me
    End Sub

    ''' <summary>Sets up the scrollable demo container.</summary>
    Private Sub B4XPage_Created(Root1 As B4XView)
        Root = Root1

        pageScroll.Initialize(Me, "pageScroll")
        pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
        pnlHost = pageScroll.Panel

        RenderExamples(Root.Width, Root.Height)
    End Sub

    Private Sub B4XPage_Appear
        CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    End Sub
#End Region

#Region Rendering
    ''' <summary>
    ''' Renders and sizes all demo examples.
    ''' </summary>
    Private Sub RenderExamples(Width As Int, Height As Int)
        pageScroll.Clear

        Dim maxW As Int = pageScroll.UsableWidth
        Dim padding As Int = pageScroll.PagePadding
        Dim gap As Int = pageScroll.YGap
        Dim y As Int = padding

        ' 1. Basic
        y = pageScroll.AddSectionTitle("Basic", y, False)
        
        otpBasic1.Initialize(Me, "otp")
        otpBasic1.Tag = "basic-default"
        otpBasic1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpBasic1.Description = "Didn't get a code? Resend the code"
        y = y + otpBasic1.GetActualHeight + gap

        otpBasic2.Initialize(Me, "otp")
        otpBasic2.Tag = "basic-length6"
        otpBasic2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpBasic2.Length = 6
        otpBasic2.Gap = 1dip
        otpBasic2.Description = "Didn't get a code? Resend the code"
        y = y + otpBasic2.GetActualHeight + gap

        ' 2. Type
        y = pageScroll.AddSectionTitle("Type", y, False)
        
        otpType1.Initialize(Me, "otp")
        otpType1.Tag = "type-number"
        otpType1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpType1.InputType = "number"
        otpType1.Description = "Numbers only"
        y = y + otpType1.GetActualHeight + gap

        otpType2.Initialize(Me, "otp")
        otpType2.Tag = "type-text"
        otpType2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpType2.InputType = "text"
        otpType2.Description = "Letters and numbers"
        y = y + otpType2.GetActualHeight + gap

        ' 3. Shape
        y = pageScroll.AddSectionTitle("Shape", y, False)
        
        otpShape1.Initialize(Me, "otp")
        otpShape1.Tag = "shape-round"
        otpShape1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpShape1.Shape = "round"
        otpShape1.Description = "Round"
        y = y + otpShape1.GetActualHeight + gap

        otpShape2.Initialize(Me, "otp")
        otpShape2.Tag = "shape-soft"
        otpShape2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpShape2.Shape = "soft"
        otpShape2.Description = "Soft"
        y = y + otpShape2.GetActualHeight + gap

        otpShape3.Initialize(Me, "otp")
        otpShape3.Tag = "shape-rectangular"
        otpShape3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpShape3.Shape = "rectangular"
        otpShape3.Description = "Rectangular"
        y = y + otpShape3.GetActualHeight + gap

        ' 3b. Rounded
        y = pageScroll.AddSectionTitle("Rounded (Tailwind tokens)", y, False)
        
        otpRounded1.Initialize(Me, "otp")
        otpRounded1.Tag = "rounded-none"
        otpRounded1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpRounded1.Rounded = "rounded-none"
        otpRounded1.Description = "Rounded None (0px)"
        y = y + otpRounded1.GetActualHeight + gap

        otpRounded2.Initialize(Me, "otp")
        otpRounded2.Tag = "rounded-md"
        otpRounded2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpRounded2.Rounded = "rounded-md"
        otpRounded2.Description = "Rounded Medium (6px)"
        y = y + otpRounded2.GetActualHeight + gap

        otpRounded3.Initialize(Me, "otp")
        otpRounded3.Tag = "rounded-full"
        otpRounded3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpRounded3.Rounded = "rounded-full"
        otpRounded3.Description = "Rounded Full"
        y = y + otpRounded3.GetActualHeight + gap

        ' 4. Fill
        y = pageScroll.AddSectionTitle("Fill", y, False)
        
        otpFill1.Initialize(Me, "otp")
        otpFill1.Tag = "fill-outline"
        otpFill1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpFill1.Fill = "outline"
        otpFill1.Description = "Outline"
        y = y + otpFill1.GetActualHeight + gap

        otpFill2.Initialize(Me, "otp")
        otpFill2.Tag = "fill-solid"
        otpFill2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpFill2.Fill = "solid"
        otpFill2.Description = "Solid"
        y = y + otpFill2.GetActualHeight + gap

        ' 5. Size
        y = pageScroll.AddSectionTitle("Size", y, False)
        
        otpSize1.Initialize(Me, "otp")
        otpSize1.Tag = "size-xs"
        otpSize1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSize1.Size = "xs"
        otpSize1.Description = "Extra Small (xs)"
        y = y + otpSize1.GetActualHeight + gap

        otpSize2.Initialize(Me, "otp")
        otpSize2.Tag = "size-sm"
        otpSize2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSize2.Size = "sm"
        otpSize2.Description = "Small (sm)"
        y = y + otpSize2.GetActualHeight + gap

        otpSize3.Initialize(Me, "otp")
        otpSize3.Tag = "size-md"
        otpSize3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSize3.Size = "md"
        otpSize3.Description = "Medium (md)"
        y = y + otpSize3.GetActualHeight + gap

        otpSize4.Initialize(Me, "otp")
        otpSize4.Tag = "size-lg"
        otpSize4.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSize4.Size = "lg"
        otpSize4.Description = "Large (lg)"
        y = y + otpSize4.GetActualHeight + gap

        otpSize5.Initialize(Me, "otp")
        otpSize5.Tag = "size-xl"
        otpSize5.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSize5.Size = "xl"
        otpSize5.Description = "Extra Large (xl)"
        y = y + otpSize5.GetActualHeight + gap

        ' 6. Separators
        y = pageScroll.AddSectionTitle("Separators", y, False)
        
        otpSep1.Initialize(Me, "otp")
        otpSep1.Tag = "separators-1-3"
        otpSep1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSep1.Separators = "1,3"
        otpSep1.Description = "Didn't get a code? Resend the code"
        y = y + otpSep1.GetActualHeight + gap

        otpSep2.Initialize(Me, "otp")
        otpSep2.Tag = "separators-2"
        otpSep2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSep2.Separators = "2"
        otpSep2.Description = "Didn't get a code? Resend the code"
        y = y + otpSep2.GetActualHeight + gap

        otpSep3.Initialize(Me, "otp")
        otpSep3.Tag = "separators-all"
        otpSep3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpSep3.Separators = "all"
        otpSep3.Description = "Didn't get a code? Resend the code"
        y = y + otpSep3.GetActualHeight + gap

        ' 7. States
        y = pageScroll.AddSectionTitle("States", y, False)
        
        otpState1.Initialize(Me, "otp")
        otpState1.Tag = "state-disabled"
        otpState1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpState1.Enabled = False
        otpState1.Value = "1234"
        otpState1.Description = "Disabled"
        y = y + otpState1.GetActualHeight + gap

        otpState2.Initialize(Me, "otp")
        otpState2.Tag = "state-readonly"
        otpState2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpState2.ReadOnly = True
        otpState2.Value = "1234"
        otpState2.Description = "Readonly"
        y = y + otpState2.GetActualHeight + gap

        otpState3.Initialize(Me, "otp")
        otpState3.Tag = "state-invalid"
        otpState3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpState3.Value = "12"
        otpState3.ValidationState = "invalid"
        otpState3.ErrorText = "Invalid"
        y = y + otpState3.GetActualHeight + gap

        otpState4.Initialize(Me, "otp")
        otpState4.Tag = "state-valid"
        otpState4.AddToParent(pnlHost, padding, y, maxW, 0)
        otpState4.Value = "1234"
        otpState4.ValidationState = "valid"
        otpState4.Description = "Valid"
        y = y + otpState4.GetActualHeight + gap

        ' 8. Pattern
        y = pageScroll.AddSectionTitle("Pattern", y, False)
        
        otpPattern1.Initialize(Me, "otp")
        otpPattern1.Tag = "pattern-1-4"
        otpPattern1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpPattern1.Pattern = "[1-4]"
        otpPattern1.Value = "123"
        otpPattern1.Description = "Numbers 1-4 only"
        y = y + otpPattern1.GetActualHeight + gap

        otpPattern2.Initialize(Me, "otp")
        otpPattern2.Tag = "pattern-any"
        otpPattern2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpPattern2.InputType = "text"
        otpPattern2.Pattern = "."
        otpPattern2.Value = "!@#"
        otpPattern2.Description = "All characters allowed"
        y = y + otpPattern2.GetActualHeight + gap

        otpPattern3.Initialize(Me, "otp")
        otpPattern3.Tag = "pattern-latin"
        otpPattern3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpPattern3.InputType = "text"
        otpPattern3.Pattern = "[A-Z]"
        otpPattern3.Value = "ABC"
        otpPattern3.Description = "Capital Latin letters only"
        y = y + otpPattern3.GetActualHeight + gap

        otpPattern4.Initialize(Me, "otp")
        otpPattern4.Tag = "pattern-greek"
        otpPattern4.AddToParent(pnlHost, padding, y, maxW, 0)
        otpPattern4.InputType = "text"
        otpPattern4.Pattern = "[\p{Script=Greek}]"
        otpPattern4.Value = Chr(945) & Chr(946) & Chr(947)
        otpPattern4.Description = "Greek characters only"
        y = y + otpPattern4.GetActualHeight + gap

        otpPattern5.Initialize(Me, "otp")
        otpPattern5.Tag = "pattern-arabic"
        otpPattern5.AddToParent(pnlHost, padding, y, maxW, 0)
        otpPattern5.InputType = "text"
        otpPattern5.Pattern = "[\p{Script=Arabic}]"
        otpPattern5.Value = Chr(1575) & Chr(1576) & Chr(1578)
        otpPattern5.Description = "Arabic characters only"
        y = y + otpPattern5.GetActualHeight + gap

        otpPattern6.Initialize(Me, "otp")
        otpPattern6.Tag = "pattern-han"
        otpPattern6.AddToParent(pnlHost, padding, y, maxW, 0)
        otpPattern6.InputType = "text"
        otpPattern6.Pattern = "[\p{Script=Han}]"
        otpPattern6.Value = Chr(29994) & Chr(20057) & Chr(19993)
        otpPattern6.Description = "Chinese (Han) characters only"
        y = y + otpPattern6.GetActualHeight + gap

        ' 9. Theming: Colors
        y = pageScroll.AddSectionTitle("Theming: Colors", y, False)
        
        otpColor1.Initialize(Me, "otp")
        otpColor1.Tag = "color-primary"
        otpColor1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor1.Length = 2
        otpColor1.Variant = "primary"
        otpColor1.Description = "Primary"
        y = y + otpColor1.GetActualHeight + gap

        otpColor2.Initialize(Me, "otp")
        otpColor2.Tag = "color-secondary"
        otpColor2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor2.Length = 2
        otpColor2.Variant = "secondary"
        otpColor2.Description = "Secondary"
        y = y + otpColor2.GetActualHeight + gap

        otpColor3.Initialize(Me, "otp")
        otpColor3.Tag = "color-accent"
        otpColor3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor3.Length = 2
        otpColor3.Variant = "accent"
        otpColor3.Description = "Accent"
        y = y + otpColor3.GetActualHeight + gap

        otpColor4.Initialize(Me, "otp")
        otpColor4.Tag = "color-info"
        otpColor4.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor4.Length = 2
        otpColor4.Variant = "info"
        otpColor4.Description = "Info"
        y = y + otpColor4.GetActualHeight + gap

        otpColor5.Initialize(Me, "otp")
        otpColor5.Tag = "color-success"
        otpColor5.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor5.Length = 2
        otpColor5.Variant = "success"
        otpColor5.Description = "Success"
        y = y + otpColor5.GetActualHeight + gap

        otpColor6.Initialize(Me, "otp")
        otpColor6.Tag = "color-warning"
        otpColor6.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor6.Length = 2
        otpColor6.Variant = "warning"
        otpColor6.Description = "Warning"
        y = y + otpColor6.GetActualHeight + gap

        otpColor7.Initialize(Me, "otp")
        otpColor7.Tag = "color-error"
        otpColor7.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor7.Length = 2
        otpColor7.Variant = "error"
        otpColor7.Description = "Error"
        y = y + otpColor7.GetActualHeight + gap

        otpColor8.Initialize(Me, "otp")
        otpColor8.Tag = "color-neutral"
        otpColor8.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor8.Length = 2
        otpColor8.Variant = "neutral"
        otpColor8.Description = "Neutral"
        y = y + otpColor8.GetActualHeight + gap

        otpColor9.Initialize(Me, "otp")
        otpColor9.Tag = "color-none"
        otpColor9.AddToParent(pnlHost, padding, y, maxW, 0)
        otpColor9.Length = 2
        otpColor9.Variant = "none"
        otpColor9.Description = "None"
        y = y + otpColor9.GetActualHeight + gap

        ' 9b. Theming: Focus Colors
        y = pageScroll.AddSectionTitle("Theming: Focus Colors (Default border + Variant focus)", y, False)
        
        otpFocus1.Initialize(Me, "otp")
        otpFocus1.Tag = "focus-primary"
        otpFocus1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpFocus1.Length = 3
        otpFocus1.Variant = "none"
        otpFocus1.FocusVariant = "primary"
        otpFocus1.Description = "Primary Focus (Default border)"
        y = y + otpFocus1.GetActualHeight + gap

        otpFocus2.Initialize(Me, "otp")
        otpFocus2.Tag = "focus-secondary"
        otpFocus2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpFocus2.Length = 3
        otpFocus2.Variant = "none"
        otpFocus2.FocusVariant = "secondary"
        otpFocus2.Description = "Secondary Focus (Default border)"
        y = y + otpFocus2.GetActualHeight + gap

        otpFocus3.Initialize(Me, "otp")
        otpFocus3.Tag = "focus-accent"
        otpFocus3.AddToParent(pnlHost, padding, y, maxW, 0)
        otpFocus3.Length = 3
        otpFocus3.Variant = "none"
        otpFocus3.FocusVariant = "accent"
        otpFocus3.Description = "Accent Focus (Default border)"
        y = y + otpFocus3.GetActualHeight + gap
 
        ' 10. Theming: Custom
        y = pageScroll.AddSectionTitle("Theming: Custom (CSS vars -> Daisy tokens)", y, False)
        
        otpCustom1.Initialize(Me, "otp")
        otpCustom1.Tag = "css-outline"
        otpCustom1.AddToParent(pnlHost, padding, y, maxW, 0)
        otpCustom1.Variant = "secondary"
        otpCustom1.Separators = "all"
        otpCustom1.Description = "Custom outline (variant + separators)"
        y = y + otpCustom1.GetActualHeight + gap

        otpCustom2.Initialize(Me, "otp")
        otpCustom2.Tag = "css-solid"
        otpCustom2.AddToParent(pnlHost, padding, y, maxW, 0)
        otpCustom2.Variant = "secondary"
        otpCustom2.Fill = "solid"
        otpCustom2.Separators = "all"
        otpCustom2.Description = "Custom solid (variant + fill + separators)"
        y = y + otpCustom2.GetActualHeight

        pageScroll.AutoFit
    End Sub

    Private Sub B4XPage_Resize(Width As Int, Height As Int)
        If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
        RenderExamples(Width, Height)
    End Sub
#End Region

#Region OTP Events
    ''' <summary>Fires on every keystroke (ionic ionInput).</summary>
    Private Sub otp_Input(Value As String)
        ' Per-keystroke value feedback (ionic ionInput). Toast omitted to avoid spam.
    End Sub

    ''' <summary>Fires on blur when value changed (ionic ionChange).</summary>
    Private Sub otp_Changed(Value As String)
        #If B4A
        B4XPages.MainPage.ShowToast("OTP changed: " & Value, False)
        #End If
    End Sub

    ''' <summary>Fires when all boxes are filled (ionic ionComplete).</summary>
    Private Sub otp_Complete(Value As String)
        #If B4A
        B4XPages.MainPage.ShowToast("OTP complete: " & Value, True)
        #End If
    End Sub

    Private Sub otp_Focus
    End Sub

    Private Sub otp_Blur
    End Sub

    Private Sub otp_DescriptionClick
        #If B4A
        B4XPages.MainPage.ShowToast("Resend the code tapped", False)
        #End If
    End Sub
#End Region

#If B4A
' Note: Backspace/Delete (KEYCODE_DEL) is handled internally by the B4XDaisyOTP
' component itself, so it does not need to be intercepted at the page level.
#End If

Public Sub B4XPage_KeyPress (KeyCode As Int) As Boolean
	#If B4A
	If KeyCode = 4 Then ' KEYCODE_BACK
	End If
	#End If
	Return False
End Sub
