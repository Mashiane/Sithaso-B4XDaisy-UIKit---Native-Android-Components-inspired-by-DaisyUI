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

    Private navbar As B4XDaisyNavbar
    Private pageScroll As B4XDaisyPageScroll
    Private pnlHost As B4XView

    Private helpBtn As B4XDaisyButton
    Private enjoyHint As B4XDaisyEnjoyHint

    Private NAVBAR_H As Int = 56dip

    ' References to views used in the tour steps
    Private refNameInput As B4XDaisyInput
    Private refEmailInput As B4XDaisyInput
    Private refCountrySelect As B4XDaisySelect
    Private refNotificationsToggle As B4XDaisyToggle
    Private refDarkModeToggle As B4XDaisyToggle
    Private refTermsCheckbox As B4XDaisyCheckbox
    Private refRangeSlider As B4XDaisyRange
    Private refRating As B4XDaisyRating
    Private refSaveBtn As B4XDaisyButton
    Private refDeleteBtn As B4XDaisyButton
    Private refAvatar As B4XDaisyAvatar
    Private tourRunning As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1

    BuildScroll
    BuildNavbar
    RenderContent
End Sub
#End Region

#Region Layout Builders
Private Sub BuildNavbar
    navbar.Initialize(Me, "navbar")
    navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
    navbar.BringToFront
    navbar.Title = "EnjoyHint Demo"
    navbar.Variant = "primary"
    navbar.BackVisible = True

    helpBtn = navbar.AddButtonIconToEnd("helpBtn", 40dip, "circle-question-regular.svg", xui.Color_White, True)
    helpBtn.IconSize = 35dip
End Sub

Private Sub BuildScroll
    Dim scrollTop As Int = NAVBAR_H
    Dim scrollH As Int = Root.Height - NAVBAR_H

    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, scrollTop, Root.Width, scrollH)
    pageScroll.SendToBack
    pnlHost = pageScroll.Panel
End Sub
#End Region

#Region Content Rendering
Private Sub RenderContent
    pageScroll.Clear

    Dim maxW As Int = pageScroll.UsableWidth
    Dim pad As Int = pageScroll.PagePadding
    Dim gap As Int = pageScroll.YGap
    Dim y As Int = pad

    ' -- Profile Section --
    y = pageScroll.AddSectionTitle("Profile Picture", y, False)

    refAvatar.Initialize(Me, "refAvatar")
    refAvatar.AddToParent(pnlHost, (maxW - 80dip) / 2, y, 80dip, 80dip)
    refAvatar.CenterOnParent = True
    refAvatar.setAvatarBitmap(xui.LoadBitmap(File.DirAssets, "mashymain.jpg"), Null)
    y = y + refAvatar.GetComputedHeight + gap

    ' -- Text Inputs --
    y = pageScroll.AddSectionTitle("Personal Information", y, False)

    refNameInput.Initialize(Me, "refNameInput")
    refNameInput.AddToParent(pnlHost, pad, y, maxW, 40dip)
    refNameInput.LabelAbove = "Full Name"
    refNameInput.Placeholder = "Enter your name..."
    y = y + refNameInput.GetComputedHeight + gap

    refEmailInput.Initialize(Me, "refEmailInput")
    refEmailInput.AddToParent(pnlHost, pad, y, maxW, 40dip)
    refEmailInput.LabelAbove = "Email Address"
    refEmailInput.Placeholder = "email@example.com"
    refEmailInput.InputType = "email"
    y = y + refEmailInput.GetComputedHeight + gap

    ' -- Select --
    y = pageScroll.AddSectionTitle("Location", y, False)

    refCountrySelect.Initialize(Me, "refCountrySelect")
    refCountrySelect.AddToParent(pnlHost, pad, y, maxW, 40dip)
    refCountrySelect.LabelAbove = "Country"
    refCountrySelect.Placeholder = "Pick a country..."
    refCountrySelect.Items = CreateMap("za": "South Africa", "us": "United States", "gb": "United Kingdom")
    y = y + refCountrySelect.GetComputedHeight + gap

    ' -- Toggles & Checkboxes --
    y = pageScroll.AddSectionTitle("Preferences", y, False)

    refNotificationsToggle.Initialize(Me, "refNotificationsToggle")
    refNotificationsToggle.AddToParent(pnlHost, pad, y, maxW, 40dip)
    refNotificationsToggle.Text = "Enable notifications"
    y = y + refNotificationsToggle.GetComputedHeight + gap

    refDarkModeToggle.Initialize(Me, "refDarkModeToggle")
    refDarkModeToggle.AddToParent(pnlHost, pad, y, maxW, 40dip)
    refDarkModeToggle.Text = "Dark mode"
    refDarkModeToggle.Checked = True
    y = y + refDarkModeToggle.GetComputedHeight + gap

    refTermsCheckbox.Initialize(Me, "refTermsCheckbox")
    refTermsCheckbox.AddToParent(pnlHost, pad, y, maxW, 40dip)
    refTermsCheckbox.Text = "I agree to the terms and conditions"
    y = y + refTermsCheckbox.GetComputedHeight + gap

    ' -- Range Slider --
    y = pageScroll.AddSectionTitle("Volume", y, False)

    refRangeSlider.Initialize(Me, "refRangeSlider")
    refRangeSlider.AddToParent(pnlHost, pad, y, maxW, 24dip)
    refRangeSlider.Value = 60
    y = y + refRangeSlider.GetComputedHeight + gap

    ' -- Rating --
    y = pageScroll.AddSectionTitle("Rate your experience", y, False)

    refRating.Initialize(Me, "refRating")
    refRating.AddToParent(pnlHost, pad, y, maxW, 32dip)
    refRating.Value = 4
    y = y + refRating.GetComputedHeight + gap

    ' -- Actions --
    y = pageScroll.AddSectionTitle("Actions", y, False)

    Dim btnW As Int = (maxW - 8dip) / 2

    refSaveBtn.Initialize(Me, "refSaveBtn")
    refSaveBtn.AddToParent(pnlHost, pad, y, btnW, 44dip)
    refSaveBtn.Text = "Save"
    refSaveBtn.Variant = "primary"

    Dim btnCancel As B4XDaisyButton
    btnCancel.Initialize(Me, "btnCancel")
    btnCancel.AddToParent(pnlHost, pad + btnW + 8dip, y, btnW, 44dip)
    btnCancel.Text = "Cancel"
    btnCancel.Variant = "secondary"
    y = y + refSaveBtn.GetComputedHeight + gap

    refDeleteBtn.Initialize(Me, "refDeleteBtn")
    refDeleteBtn.AddToParent(pnlHost, pad, y, maxW, 44dip)
    refDeleteBtn.Text = "Delete Account"
    refDeleteBtn.Variant = "error"
    y = y + refDeleteBtn.GetComputedHeight + gap

    pageScroll.AutoFit
End Sub
#End Region

#Region Tour Setup
Private Sub StartTour
    
    ' End any previous tour and remove stale overlay before re-initializing
    Try
        If tourRunning And enjoyHint.IsInitialized Then
            enjoyHint.EndTour
        End If
    Catch
        Log("B4XPageEnjoyHint.StartTour: " & LastException.Message)
    End Try
    tourRunning = False
    
    ' Scroll to top so the first spotlight is positioned correctly
    If pageScroll.IsInitialized Then
        pageScroll.ScrollToTop(False)
    End If
    
    Try
        enjoyHint.Initialize(Me, "enjoyHint", Root)
    Catch
        Log("B4XPageEnjoyHint.StartTour: " & LastException.Message)
        Return
    End Try
    tourRunning = True
    enjoyHint.BtnNextText = "Next"
    enjoyHint.BtnSkipText = "Skip"
    enjoyHint.BtnPrevText = "Previous"
    enjoyHint.BtnFinishText = "Done"
    
    enjoyHint.AddStep(refAvatar.mBase, "This is your profile picture. Tap to change it.", "circle", 8dip, 0, "center")
    enjoyHint.AddStep(refNameInput.mBase, "Enter your full name here.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refEmailInput.mBase, "Provide a valid email address.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refCountrySelect.mBase, "Select your country from the dropdown.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refNotificationsToggle.mBase, "Toggle push notifications on or off.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refDarkModeToggle.mBase, "Switch between light and dark themes.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refTermsCheckbox.mBase, "Accept the terms to continue.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refRangeSlider.mBase, "Drag to adjust the volume level.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refRating.mBase, "Rate your experience with the stars.", "rect", 4dip, 0, "left")
    enjoyHint.AddStep(refSaveBtn.mBase, "Save your changes here.", "rect", 4dip, 0, "right")
    enjoyHint.AddStep(refDeleteBtn.mBase, "Danger zone � permanently delete your account.", "rect", 4dip, 0, "center")
    Try
        enjoyHint.RunWithResume
    Catch
        Log("B4XPageEnjoyHint.StartTour: " & LastException.Message)
    End Try
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If navbar.IsInitialized Then
        navbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_H)
    End If
    If pageScroll.IsInitialized Then
        pageScroll.Base_Resize(Width, Height - NAVBAR_H)
    End If
    If tourRunning Then enjoyHint.EndTour
    tourRunning = False
    RenderContent
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Event Handlers
Private Sub navbar_Back(Tag As Object)
    B4XPages.ShowPage("dashboard")
End Sub

Private Sub helpBtn_Click(Tag As Object)
    StartTour
End Sub

Private Sub enjoyHint_OnNextClick
    Log("Tour: next")
End Sub

Private Sub enjoyHint_OnPrevClick
    Log("Tour: previous")
End Sub

Private Sub enjoyHint_OnSkipClick
    Log("Tour: skipped")
    tourRunning = False
End Sub

Private Sub enjoyHint_OnCloseClick
    Log("Tour: closed")
    tourRunning = False
End Sub

Private Sub enjoyHint_OnOverlayClick
    Log("Tour: overlay tapped")
End Sub
#End Region


