B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private m1, m2, m3, m5, m7, m8, m9 As B4XDaisyModal
    Private m10, m11, m12, m13, m14, m15 As B4XDaisyModal
    Private m16, m17 As B4XDaisyModal
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
    B4XPages.SetTitle(Me, "Modal")

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
    AddActionButton(m1, "Close", "m1_close")
    
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
    AddLabel(m3, "Tap ✕ in the top-right corner to close.")
    
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
    Dim btnM5Close As B4XDaisyButton
    btnM5Close.Initialize(Me, "modalBtn")
    btnM5Close.Tag = "m5_close"
    btnM5Close.Text = "Close"
    btnM5Close.Size = "md"
    btnM5Close.Variant = "primary"
    m5.AddAction(btnM5Close)
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
    Dim btnM7Dismiss As B4XDaisyButton
    btnM7Dismiss.Initialize(Me, "modalBtn")
    btnM7Dismiss.Tag = "m7_close"
    btnM7Dismiss.Text = "Dismiss"
    btnM7Dismiss.Size = "md"
    btnM7Dismiss.Variant = "primary"
    m7.AddAction(btnM7Dismiss)
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
    m8.SidebarDuration = 300
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
    m9.SidebarDuration = 300
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
    AddLabel(m10, "glass-xs: opacity 8% — barely there shimmer")

    m11.Initialize(Me, "m11")
    m11.AddToParent(Root, 0, 0, Width, Height)
    m11.Title = "Glass SM"
    m11.GlassSize = "glass-sm"
    m11.Visible = False
    AddLabel(m11, "glass-sm: opacity 15% — light frost")

    m12.Initialize(Me, "m12")
    m12.AddToParent(Root, 0, 0, Width, Height)
    m12.Title = "Glass MD"
    m12.GlassSize = "glass-md"
    m12.Visible = False
    AddLabel(m12, "glass-md: opacity 30% — DaisyUI default")

    m13.Initialize(Me, "m13")
    m13.AddToParent(Root, 0, 0, Width, Height)
    m13.Title = "Glass LG"
    m13.GlassSize = "glass-lg"
    m13.Visible = False
    AddLabel(m13, "glass-lg: opacity 50% — heavy frost")

    m14.Initialize(Me, "m14")
    m14.AddToParent(Root, 0, 0, Width, Height)
    m14.Title = "Glass XL"
    m14.GlassSize = "glass-xl"
    m14.Visible = False
    AddLabel(m14, "glass-xl: opacity 70% — near-opaque wash")

    m15.Initialize(Me, "m15")
    m15.AddToParent(Root, 0, 0, Width, Height)
    m15.Title = "Glass 2XL"
    m15.GlassSize = "glass-2xl"
    m15.Visible = False
    AddLabel(m15, "glass-2xl: opacity 85% — near-solid")

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
    AddLabel(m16, "The backdrop is invisible — only the dialog card appears.")
    AddActionButton(m16, "Close", "m16_close")

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
    AddActionButton(m17, "I Accept", "m17_close")

    Dim btn17 As B4XDaisyButton
    btn17.Initialize(Me, "btn17")
    btn17.AddToParent(pnlHost, 20dip, y, 180dip, 40dip)
    btn17.Text = "Non-Dismissable Modal"
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
    Dim lbl As B4XDaisyText
    lbl.Initialize(Me, "")
    lbl.Text = Text
    lbl.TextSize = "text-base"
    lbl.AddToParent(m.getBodyContainer, 0, 0, m.getBodyContainer.Width, 40dip)
    m.Refresh
End Sub

Private Sub AddActionButton(m As B4XDaisyModal, Text As String, ItemTag As String)
    Dim btn As B4XDaisyButton
    btn.Initialize(Me, "modalBtn")
    btn.Tag = ItemTag
    btn.Text = Text
    btn.Size = "sm"
    btn.Variant = "primary"
    m.AddAction(btn)
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

Sub modalBtn_Click(Tag As Object)
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
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    If m1.getView.IsInitialized Then m1.AddToParent(Root, 0, 0, Width, Height)
    If m2.getView.IsInitialized Then m2.AddToParent(Root, 0, 0, Width, Height)
    If m3.getView.IsInitialized Then m3.AddToParent(Root, 0, 0, Width, Height)
    If m5.getView.IsInitialized Then m5.AddToParent(Root, 0, 0, Width, Height)
    If m7.getView.IsInitialized Then m7.AddToParent(Root, 0, 0, Width, Height)
    If m8.getView.IsInitialized Then m8.AddToParent(Root, 0, 0, Width, Height)
    If m9.getView.IsInitialized Then m9.AddToParent(Root, 0, 0, Width, Height)
    If m10.getView.IsInitialized Then m10.AddToParent(Root, 0, 0, Width, Height)
    If m11.getView.IsInitialized Then m11.AddToParent(Root, 0, 0, Width, Height)
    If m12.getView.IsInitialized Then m12.AddToParent(Root, 0, 0, Width, Height)
    If m13.getView.IsInitialized Then m13.AddToParent(Root, 0, 0, Width, Height)
    If m14.getView.IsInitialized Then m14.AddToParent(Root, 0, 0, Width, Height)
    If m15.getView.IsInitialized Then m15.AddToParent(Root, 0, 0, Width, Height)
    If m16.getView.IsInitialized Then m16.AddToParent(Root, 0, 0, Width, Height)
    If m17.getView.IsInitialized Then m17.AddToParent(Root, 0, 0, Width, Height)
End Sub