B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private m1, m2, m3, m5, m7, m8, m9 As B4XDaisyModal
    Private m10, m11, m12, m13, m14, m15 As B4XDaisyModal
    Private m16, m17 As B4XDaisyModal
    Private m18, m19, m20, m21, m22 As B4XDaisyModal
    Private mNoAnim, mSlowAnim As B4XDaisyModal
    Private mPresetYesNo, mPresetOkCancel As B4XDaisyModal
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    CloseAllModals
End Sub

' Modal Demo Page
' Demonstrates 100% parity with DaisyUI documentation examples.
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_White

    ' ScrollView for vertical flow
    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    ' Render Examples
    RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
    pnlHost.RemoveAllViews
    Dim y As Int = 12dip
    Dim maxW As Int = Width - 40dip

    m1.Initialize(Me, "m1")
    m1.AddToParent(Root, 0, 0, Width, Height)
    m1.Title = "Hello!"
    m1.Visible = False
    AddLabel(m1, "Tap the button below to close.")
    m1.AddActionButton("modalBtn", "Close", "primary")
    m1.Refresh
    
    Dim btn1 As B4XDaisyButton
    btn1.Initialize(Me, "btn1")
    btn1.AddToParent(pnlHost, 20dip, y, 120dip, 40dip)
    btn1.Text = "Open Modal"
    y = y + 46dip

    m2.Initialize(Me, "m2")
    m2.AddToParent(Root, 0, 0, Width, Height)
    m2.Title = "Hello!"
    m2.ClickOutsideToClose = True
    m2.Visible = False
    AddLabel(m2, "Tap outside the dialog to close.")
    
    Dim btn2 As B4XDaisyButton
    btn2.Initialize(Me, "btn2")
    btn2.AddToParent(pnlHost, 20dip, y, 140dip, 40dip)
    btn2.Text = "Open Modal"
    y = y + 46dip

    m3.Initialize(Me, "m3")
    m3.AddToParent(Root, 0, 0, Width, Height)
    m3.Title = "Hello!"
    m3.ShowCloseButton = True
    m3.Visible = False
    AddLabel(m3, "Tap x in the top-right corner to close.")
    
    Dim btn3 As B4XDaisyButton
    btn3.Initialize(Me, "btn3")
    btn3.AddToParent(pnlHost, 20dip, y, 160dip, 40dip)
    btn3.Text = "Open Corner Close"
    y = y + 46dip

    m5.Initialize(Me, "m5")
    m5.AddToParent(Root, 0, 0, Width, Height)
    m5.Title = "Hello!"
    m5.Placement = "bottom"
    m5.Visible = False
    AddLabel(m5, "Slides up from the bottom of the screen.")
    m5.AddActionButton("modalBtn", "Close", "primary")
    m5.Refresh

    Dim btn5 As B4XDaisyButton
    btn5.Initialize(Me, "btn5")
    btn5.AddToParent(pnlHost, 20dip, y, 140dip, 40dip)
    btn5.Text = "Open Bottom"
    y = y + 46dip

    m7.Initialize(Me, "m7")
    m7.AddToParent(Root, 0, 0, Width, Height)
    m7.Title = "Immersive Mode"
    m7.FullScreen = True
    m7.Visible = False
    m7.AddActionButton("modalBtn", "Dismiss", "primary")
    m7.Refresh

    Dim btn7 As B4XDaisyButton
    btn7.Initialize(Me, "btn7")
    btn7.AddToParent(pnlHost, 20dip, y, 150dip, 40dip)
    btn7.Text = "Open Full Screen"
    y = y + 46dip

    m8.Initialize(Me, "m8")
    m8.AddToParent(Root, 0, 0, Width, Height)
    m8.Title = "Sidebar"
    m8.Sidebar = True
    m8.SidebarSide = "left"
    m8.Duration = 300
    m8.Width = "w-[70%]"
    m8.Visible = False
    AddLabel(m8, "This behaves like a drawer/sidebar modal.")
    
    Dim btn8 As B4XDaisyButton
    btn8.Initialize(Me, "btn8")
    btn8.AddToParent(pnlHost, 20dip, y, 150dip, 40dip)
    btn8.Text = "Sidebar - Left"
    y = y + 46dip

    m9.Initialize(Me, "m9")
    m9.AddToParent(Root, 0, 0, Width, Height)
    m9.Title = "Sidebar"
    m9.Sidebar = True
    m9.SidebarSide = "right"
    m9.Duration = 300
    m9.Width = "w-[70%]"
    m9.Visible = False
    AddLabel(m9, "This behaves like a drawer/sidebar modal.")
    
    Dim btn9 As B4XDaisyButton
    btn9.Initialize(Me, "btn9")
    btn9.AddToParent(pnlHost, 20dip, y, 150dip, 40dip)
    btn9.Text = "Sidebar - Right"
    y = y + 46dip

    m10.Initialize(Me, "m10")
    m10.AddToParent(Root, 0, 0, Width, Height)
    m10.Title = "Glass XS"
    m10.GlassSize = "glass-xs"
    m10.Visible = False
    AddLabel(m10, "glass-xs: opacity 8% - barely there shimmer")

    m11.Initialize(Me, "m11")
    m11.AddToParent(Root, 0, 0, Width, Height)
    m11.Title = "Glass SM"
    m11.GlassSize = "glass-sm"
    m11.Visible = False
    AddLabel(m11, "glass-sm: opacity 15% - light frost")

    m12.Initialize(Me, "m12")
    m12.AddToParent(Root, 0, 0, Width, Height)
    m12.Title = "Glass MD"
    m12.GlassSize = "glass-md"
    m12.Visible = False
    AddLabel(m12, "glass-md: opacity 30% - DaisyUI default")

    m13.Initialize(Me, "m13")
    m13.AddToParent(Root, 0, 0, Width, Height)
    m13.Title = "Glass LG"
    m13.GlassSize = "glass-lg"
    m13.Visible = False
    AddLabel(m13, "glass-lg: opacity 50% - heavy frost")

    m14.Initialize(Me, "m14")
    m14.AddToParent(Root, 0, 0, Width, Height)
    m14.Title = "Glass XL"
    m14.GlassSize = "glass-xl"
    m14.Visible = False
    AddLabel(m14, "glass-xl: opacity 70% - near-opaque wash")

    m15.Initialize(Me, "m15")
    m15.AddToParent(Root, 0, 0, Width, Height)
    m15.Title = "Glass 2XL"
    m15.GlassSize = "glass-2xl"
    m15.Visible = False
    AddLabel(m15, "glass-2xl: opacity 85% - near-solid")

    ' Two rows of 3 buttons, sm size
    Dim btnGW As Int = (maxW - 8dip) / 3
    Dim btn10 As B4XDaisyButton
    btn10.Initialize(Me, "btn10")
    btn10.AddToParent(pnlHost, 20dip, y, btnGW, 32dip)
    btn10.Text = "XS"
    btn10.Size = "sm"
    Dim btn11 As B4XDaisyButton
    btn11.Initialize(Me, "btn11")
    btn11.AddToParent(pnlHost, 20dip + btnGW + 4dip, y, btnGW, 32dip)
    btn11.Text = "SM"
    btn11.Size = "sm"
    Dim btn12 As B4XDaisyButton
    btn12.Initialize(Me, "btn12")
    btn12.AddToParent(pnlHost, 20dip + (btnGW + 4dip) * 2, y, btnGW, 32dip)
    btn12.Text = "MD"
    btn12.Size = "sm"
    y = y + 80dip
    Dim btn13 As B4XDaisyButton
    btn13.Initialize(Me, "btn13")
    btn13.AddToParent(pnlHost, 20dip, y, btnGW, 32dip)
    btn13.Text = "LG"
    btn13.Size = "sm"
    Dim btn14 As B4XDaisyButton
    btn14.Initialize(Me, "btn14")
    btn14.AddToParent(pnlHost, 20dip + btnGW + 4dip, y, btnGW, 32dip)
    btn14.Text = "XL"
    btn14.Size = "sm"
    Dim btn15 As B4XDaisyButton
    btn15.Initialize(Me, "btn15")
    btn15.AddToParent(pnlHost, 20dip + (btnGW + 4dip) * 2, y, btnGW, 32dip)
    btn15.Text = "2XL"
    btn15.Size = "sm"
    y = y + 44dip

    ' --- Example: Modal without overlay ---
    m16.Initialize(Me, "m16")
    m16.AddToParent(Root, 0, 0, Width, Height)
    m16.Title = "No Overlay"
    m16.BackdropColor = "transparent"
    m16.BackdropOpacity = 0
    m16.Visible = False
    AddLabel(m16, "The backdrop is invisible - only the dialog card appears.")
    m16.AddActionButton("modalBtn", "Close", "primary")
    m16.Refresh

    Dim btn16 As B4XDaisyButton
    btn16.Initialize(Me, "btn16")
    btn16.AddToParent(pnlHost, 20dip, y, 160dip, 40dip)
    btn16.Text = "No Overlay Modal"
    y = y + 46dip

    ' --- Example: Modal you cannot dismiss ---
    m17.Initialize(Me, "m17")
    m17.AddToParent(Root, 0, 0, Width, Height)
    m17.Title = "Cannot Dismiss"
    m17.ClickOutsideToClose = False
    m17.ShowCloseButton = False
    m17.Visible = False
    AddLabel(m17, "This modal cannot be closed by tapping outside or pressing back. You must tap the button.")
    m17.AddActionButton("modalBtn", "I Accept", "primary")
    m17.Refresh

    Dim btn17 As B4XDaisyButton
    btn17.Initialize(Me, "btn17")
    btn17.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn17.Text = "Non-Dismissable Modal"
    y = y + 46dip

    ' - Color & Border variants -
    y = AddExample(y, "Color & Border Variants", "Variant backgrounds, borders and title colors")

    ' --- Modal with primary variant background ---
    m18.Initialize(Me, "m18")
    m18.AddToParent(Root, 0, 0, Width, Height)
    m18.Title = "Primary Background"
    m18.BackgroundColor = "primary"
    m18.TitleTextColor = "primary-content"
    m18.ClickOutsideToClose = True
    m18.ShowCloseButton = True
    m18.Visible = False
    AddLabelThemed(m18, "The modal box uses the primary variant as its background.", "primary-content")
    m18.Refresh

    Dim btn18 As B4XDaisyButton
    btn18.Initialize(Me, "btn18")
    btn18.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn18.Text = "Primary BG Modal"
    y = y + 46dip

    ' --- Modal with secondary variant background ---
    m19.Initialize(Me, "m19")
    m19.AddToParent(Root, 0, 0, Width, Height)
    m19.Title = "Secondary Background"
    m19.BackgroundColor = "secondary"
    m19.TitleTextColor = "secondary-content"
    m19.ClickOutsideToClose = True
    m19.ShowCloseButton = True
    m19.Visible = False
    AddLabelThemed(m19, "The modal box uses the secondary variant as its background.", "secondary-content")
    m19.Refresh

    Dim btn19 As B4XDaisyButton
    btn19.Initialize(Me, "btn19")
    btn19.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn19.Text = "Secondary BG Modal"
    y = y + 46dip

    ' --- Modal with success variant background ---
    m20.Initialize(Me, "m20")
    m20.AddToParent(Root, 0, 0, Width, Height)
    m20.Title = "Success Background"
    m20.BackgroundColor = "success"
    m20.TitleTextColor = "success-content"
    m20.ClickOutsideToClose = True
    m20.ShowCloseButton = True
    m20.Visible = False
    AddLabelThemed(m20, "The modal box uses the success variant as its background.", "success-content")
    m20.Refresh

    Dim btn20 As B4XDaisyButton
    btn20.Initialize(Me, "btn20")
    btn20.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn20.Text = "Success BG Modal"
    y = y + 46dip

    ' --- Modal with a variant border color ---
    m21.Initialize(Me, "m21")
    m21.AddToParent(Root, 0, 0, Width, Height)
    m21.Title = "Bordered Modal"
    m21.BorderColor = "error"
    m21.BorderWidth = "border-4"
    m21.ClickOutsideToClose = True
    m21.Visible = False
    AddLabel(m21, "This modal box has an error-variant border (border-4).")
    m21.AddActionButton("modalBtn", "Close", "primary")
    m21.Refresh

    Dim btn21 As B4XDaisyButton
    btn21.Initialize(Me, "btn21")
    btn21.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn21.Text = "Bordered Modal"
    y = y + 46dip

    ' --- Modal with a colored title bar (variant) ---
    m22.Initialize(Me, "m22")
    m22.AddToParent(Root, 0, 0, Width, Height)
    m22.Title = "Colored Title"
    m22.TitleColor = "primary"
    m22.ClickOutsideToClose = True
    m22.Visible = False
    AddLabel(m22, "The title bar uses the primary variant; its text auto-switches to primary-content.")
    m22.AddActionButton("modalBtn", "Close", "primary")
    m22.Refresh

    Dim btn22 As B4XDaisyButton
    btn22.Initialize(Me, "btn22")
    btn22.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn22.Text = "Colored Title Modal"
    y = y + 46dip

    mNoAnim.Initialize(Me, "mNoAnim")
    mNoAnim.AddToParent(Root, 0, 0, Width, Height)
    mNoAnim.Title = "Instant Snap Modal"
    mNoAnim.Animated = False
    mNoAnim.Visible = False
    AddLabel(mNoAnim, "This modal snaps instantly without any opening or closing animation transitions.")
    mNoAnim.AddActionButton("modalBtn", "Close", "primary")
    mNoAnim.Refresh
    
    Dim btnNoAnim As B4XDaisyButton
    btnNoAnim.Initialize(Me, "btnNoAnim")
    btnNoAnim.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btnNoAnim.Text = "Open Instant Modal"
    y = y + 46dip
    
    mSlowAnim.Initialize(Me, "mSlowAnim")
    mSlowAnim.AddToParent(Root, 0, 0, Width, Height)
    mSlowAnim.Title = "Slow Animation Modal"
    mSlowAnim.Duration = 1000
    mSlowAnim.Visible = False
    AddLabel(mSlowAnim, "This modal opens and closes slowly with a 1000ms animation duration.")
    mSlowAnim.AddActionButton("modalBtn", "Close", "primary")
    mSlowAnim.Refresh
    
    Dim btnSlowAnim As B4XDaisyButton
    btnSlowAnim.Initialize(Me, "btnSlowAnim")
    btnSlowAnim.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btnSlowAnim.Text = "Open Slow Modal"
    y = y + 46dip

    ' Action Type Presets Example 1: Yes / No
    mPresetYesNo.Initialize(Me, "mPresetYesNo")
    mPresetYesNo.AddToParent(Root, 0, 0, Width, Height)
    mPresetYesNo.Title = "Confirm Action"
    mPresetYesNo.setActionType("yes-no")
    mPresetYesNo.Visible = False
    AddLabel(mPresetYesNo, "Are you sure you want to proceed with this task?")
    mPresetYesNo.Refresh

    Dim btnPreset1 As B4XDaisyButton
    btnPreset1.Initialize(Me, "btnPreset1")
    btnPreset1.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btnPreset1.Text = "Preset: Yes / No"
    y = y + 46dip

    ' Action Type Presets Example 2: OK / Cancel
    mPresetOkCancel.Initialize(Me, "mPresetOkCancel")
    mPresetOkCancel.AddToParent(Root, 0, 0, Width, Height)
    mPresetOkCancel.Title = "Information"
    mPresetOkCancel.setActionType("ok-cancel")
    mPresetOkCancel.Visible = False
    AddLabel(mPresetOkCancel, "Your settings have been saved successfully.")
    mPresetOkCancel.Refresh

    Dim btnPreset2 As B4XDaisyButton
    btnPreset2.Initialize(Me, "btnPreset2")
    btnPreset2.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btnPreset2.Text = "Preset: OK / Cancel"
    y = y + 46dip

    pnlHost.Height = y + 12dip
End Sub
Private Sub AddExample(Y As Int, Title As String, Subtitle As String) As Int
    Dim t1 As B4XDaisyText
    t1.Initialize(Me, "")
    t1.AddToParent(pnlHost, 20dip, Y, pnlHost.Width - 40dip, 20dip)
    t1.Text = Title
    t1.TextSize = "text-sm"
    t1.FontBold = True
    
    Return Y + t1.GetComputedHeight + 4dip
End Sub

Private Sub AddLabel(m As B4XDaisyModal, Text As String)
    Dim body As B4XView = m.getBodyContainer
    Dim bodyW As Int = Max(1dip, body.Width)
    Dim lbl As B4XDaisyText
    lbl.Initialize(Me, "")
    lbl.Text = Text
    lbl.TextSize = "text-base"
    lbl.SingleLine = False        ' wrap long text across multiple lines
    ' Add at the body's inner width; the text view auto-resizes its height to
    ' fit the wrapped content.
    lbl.AddToParent(body, 0, 0, bodyW, 24dip)
    ' Measure the wrapped height for this content width and apply it explicitly
    ' so the modal's h-auto box sizes to fit the (possibly multi-line) label.
    Dim prefH As Int = Max(24dip, lbl.GetPreferredHeight(bodyW))
    If lbl.View.Height <> prefH Then
        lbl.View.SetLayoutAnimated(0, 0, 0, bodyW, prefH)
        lbl.RefreshText
    End If
    ' Re-calculate modal auto-height so the box fits the label.
    m.Refresh
End Sub

' Adds a multi-line label whose text color is set to a variant/token spec
' (e.g. "primary-content"). Used for modals with a variant background so the
' body text stays readable.
Private Sub AddLabelThemed(m As B4XDaisyModal, Text As String, TextColorSpec As String)
    Dim body As B4XView = m.getBodyContainer
    Dim bodyW As Int = Max(1dip, body.Width)
    Dim lbl As B4XDaisyText
    lbl.Initialize(Me, "")
    lbl.Text = Text
    lbl.TextSize = "text-base"
    lbl.SingleLine = False
    If TextColorSpec.Trim.Length > 0 And TextColorSpec.ToLowerCase <> "none" Then
        lbl.setTextColorVariant(TextColorSpec)
    End If
    lbl.AddToParent(body, 0, 0, bodyW, 24dip)
    Dim prefH As Int = Max(24dip, lbl.GetPreferredHeight(bodyW))
    If lbl.View.Height <> prefH Then
        lbl.View.SetLayoutAnimated(0, 0, 0, bodyW, prefH)
        lbl.RefreshText
    End If
    m.Refresh
End Sub

' Event Handlers
Sub btn1_Click(Tag As Object)
    m1.Show
End Sub

Sub btn2_Click(Tag As Object)
    m2.Show
End Sub

Sub btn3_Click(Tag As Object)
    m3.Show
End Sub

Sub btn5_Click(Tag As Object)
    m5.Show
End Sub

Sub btn7_Click(Tag As Object)
    m7.Show
End Sub

Sub btn8_Click(Tag As Object)
    m8.Show
End Sub

Sub btn9_Click(Tag As Object)
    m9.Show
End Sub

Sub btn10_Click(Tag As Object)
    m10.Show
End Sub

Sub btn11_Click(Tag As Object)
    m11.Show
End Sub

Sub btn12_Click(Tag As Object)
    m12.Show
End Sub

Sub btn13_Click(Tag As Object)
    m13.Show
End Sub

Sub btn14_Click(Tag As Object)
    m14.Show
End Sub

Sub btn15_Click(Tag As Object)
    m15.Show
End Sub

Sub btn16_Click(Tag As Object)
    m16.Show
End Sub

Sub btn17_Click(Tag As Object)
    m17.Show
End Sub

Sub btn18_Click(Tag As Object)
    m18.Show
End Sub

Sub btn19_Click(Tag As Object)
    m19.Show
End Sub

Sub btn20_Click(Tag As Object)
    m20.Show
End Sub

Sub btn21_Click(Tag As Object)
    m21.Show
End Sub

Sub btn22_Click(Tag As Object)
    m22.Show
End Sub

Sub btnNoAnim_Click(Tag As Object)
    mNoAnim.Show
End Sub

Sub btnSlowAnim_Click(Tag As Object)
    mSlowAnim.Show
End Sub

Sub btnPreset1_Click(Tag As Object)
    mPresetYesNo.Show
End Sub

Sub btnPreset2_Click(Tag As Object)
    mPresetOkCancel.Show
End Sub

Sub mPresetYesNo_YesClick(Tag As Object)
    B4XPages.MainPage.ShowToastSuccess("Modal: 'YES' tapped!", False)
End Sub

Sub mPresetYesNo_NoClick(Tag As Object)
    B4XPages.MainPage.ShowToastError("Modal: 'NO' tapped!", False)
End Sub

Sub mPresetOkCancel_OkClick(Tag As Object)
    B4XPages.MainPage.ShowToastSuccess("Modal: 'OK' tapped!", False)
End Sub

Sub mPresetOkCancel_CancelClick(Tag As Object)
    B4XPages.MainPage.ShowToast("Modal: 'CANCEL' tapped!", False)
End Sub

Sub modalBtn_Click(Tag As Object)
    B4XPages.MainPage.ShowToast("Modal closed", False)
    CloseAllModals
End Sub

Private Sub CloseAllModals
    m1.Close
    m2.Close
    m3.Close
    m5.Close
    m7.Close
    m8.Close
    m9.Close
    m10.Close
    m11.Close
    m12.Close
    m13.Close
    m14.Close
    m15.Close
    m16.Close
    m17.Close
    m18.Close
    m19.Close
    m20.Close
    m21.Close
    m22.Close
    mNoAnim.Close
    mSlowAnim.Close
    If mPresetYesNo.IsInitialized Then mPresetYesNo.Close
    If mPresetOkCancel.IsInitialized Then mPresetOkCancel.Close
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    If m1.View.IsInitialized Then m1.AddToParent(Root, 0, 0, Width, Height)
    If m2.View.IsInitialized Then m2.AddToParent(Root, 0, 0, Width, Height)
    If m3.View.IsInitialized Then m3.AddToParent(Root, 0, 0, Width, Height)
    If m5.View.IsInitialized Then m5.AddToParent(Root, 0, 0, Width, Height)
    If m7.View.IsInitialized Then m7.AddToParent(Root, 0, 0, Width, Height)
    If m8.View.IsInitialized Then m8.AddToParent(Root, 0, 0, Width, Height)
    If m9.View.IsInitialized Then m9.AddToParent(Root, 0, 0, Width, Height)
    If m10.View.IsInitialized Then m10.AddToParent(Root, 0, 0, Width, Height)
    If m11.View.IsInitialized Then m11.AddToParent(Root, 0, 0, Width, Height)
    If m12.View.IsInitialized Then m12.AddToParent(Root, 0, 0, Width, Height)
    If m13.View.IsInitialized Then m13.AddToParent(Root, 0, 0, Width, Height)
    If m14.View.IsInitialized Then m14.AddToParent(Root, 0, 0, Width, Height)
    If m15.View.IsInitialized Then m15.AddToParent(Root, 0, 0, Width, Height)
    If m16.View.IsInitialized Then m16.AddToParent(Root, 0, 0, Width, Height)
    If m17.View.IsInitialized Then m17.AddToParent(Root, 0, 0, Width, Height)
    If m18.View.IsInitialized Then m18.AddToParent(Root, 0, 0, Width, Height)
    If m19.View.IsInitialized Then m19.AddToParent(Root, 0, 0, Width, Height)
    If m20.View.IsInitialized Then m20.AddToParent(Root, 0, 0, Width, Height)
    If m21.View.IsInitialized Then m21.AddToParent(Root, 0, 0, Width, Height)
    If m22.View.IsInitialized Then m22.AddToParent(Root, 0, 0, Width, Height)
    If mNoAnim.IsInitialized And mNoAnim.View.IsInitialized Then mNoAnim.AddToParent(Root, 0, 0, Width, Height)
    If mSlowAnim.IsInitialized And mSlowAnim.View.IsInitialized Then mSlowAnim.AddToParent(Root, 0, 0, Width, Height)
    If mPresetYesNo.IsInitialized And mPresetYesNo.View.IsInitialized Then mPresetYesNo.AddToParent(Root, 0, 0, Width, Height)
    If mPresetOkCancel.IsInitialized And mPresetOkCancel.View.IsInitialized Then mPresetOkCancel.AddToParent(Root, 0, 0, Width, Height)
End Sub
