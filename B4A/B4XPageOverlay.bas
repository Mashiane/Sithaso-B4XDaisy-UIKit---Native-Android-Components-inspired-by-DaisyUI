B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' B4XPageOverlay demo page
' Shows B4XDaisyOverlay applied to various B4XView targets.

#IgnoreWarnings:12
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
    ' Persistent full-screen overlay instance (shown/hidden on demand)
    Private mFsOverlay As B4XDaisyOverlay
    Private mFsDismissLbl As Label
    ' Example 8: white full-screen overlay
    Private mWhiteOverlay As B4XDaisyOverlay
    Private mWhiteDismissLbl As Label
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

' /**
'  * Initializes the page, sets up the host ScrollView, and renders all examples.
'  */
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "Overlay")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)

    ' Build the full-screen overlay once, hidden, ready for Example 7.
    mFsOverlay.Initialize(Me, "mFsOverlay")
    mFsOverlay.OverlayColor = xui.Color_Black
    mFsOverlay.Opacity = 0.9
    mFsOverlay.CloseOnClick = True
    mFsOverlay.AttachTo(Root)
    mFsDismissLbl.Initialize("")
    mFsDismissLbl.Text = "Tap anywhere to dismiss"
    mFsDismissLbl.TextColor = xui.Color_White
    mFsDismissLbl.TextSize = 16
    mFsDismissLbl.Gravity = Gravity.CENTER
    mFsOverlay.mBase.AddView(mFsDismissLbl, 0, 0, mFsOverlay.mBase.Width, mFsOverlay.mBase.Height)

    ' Build the white full-screen overlay once, hidden, ready for Example 8.
    mWhiteOverlay.Initialize(Me, "mWhiteOverlay")
    mWhiteOverlay.OverlayColor = xui.Color_White
    mWhiteOverlay.Opacity = 0.9
    mWhiteOverlay.CloseOnClick = True
    mWhiteOverlay.AttachTo(Root)
    mWhiteDismissLbl.Initialize("")
    mWhiteDismissLbl.Text = "Tap anywhere to dismiss"
    mWhiteDismissLbl.TextColor = xui.Color_RGB(30, 41, 59)
    mWhiteDismissLbl.TextSize = 16
    mWhiteDismissLbl.Gravity = Gravity.CENTER
    mWhiteOverlay.mBase.AddView(mWhiteDismissLbl, 0, 0, mWhiteOverlay.mBase.Width, mWhiteOverlay.mBase.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
    ' Keep the full-screen overlay covering the whole page after resize.
    If mFsOverlay.IsAttached Then
        mFsOverlay.Resize(Width, Height)
        mFsDismissLbl.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
    If mWhiteOverlay.IsAttached Then
        mWhiteOverlay.Resize(Width, Height)
        mWhiteDismissLbl.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
End Sub

' /**
'  * Renders all overlay examples in a linear top-to-bottom sequence.
'  */
Private Sub RenderExamples(Width As Int, Height As Int)
    If svHost.IsInitialized = False Then Return
    pnlHost = svHost.Panel
    pnlHost.RemoveAllViews
    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim currentY As Int = PAGE_PAD

    ' =========================================================================
    ' Example 1: Basic dark overlay
    ' Demonstrates the default use-case: a semi-transparent black veil over a
    ' colourful background panel, 40% opacity.
    ' =========================================================================
    currentY = AddSectionTitle("Dark overlay (40%)", currentY, maxW)
    Dim pnl1 As Panel
    pnl1.Initialize("")
    Dim base1 As B4XView = pnl1
    base1.Color = xui.Color_RGB(59, 130, 246)      ' blue background
    pnlHost.AddView(base1, PAGE_PAD, currentY, maxW, 120dip)

    ' Background label � sits beneath the overlay (top of the panel)
    Dim lbl1bg As Label
    lbl1bg.Initialize("")
    lbl1bg.Text = "Background content (below overlay)"
    lbl1bg.TextColor = xui.Color_White
    lbl1bg.Gravity = Gravity.CENTER
    base1.AddView(lbl1bg, 0, 0, maxW, 56dip)

    Dim ov1 As B4XDaisyOverlay
    ov1.Initialize(Me, "ov1")
    ov1.OverlayColor = xui.Color_Black
    ov1.Opacity = 0.4
    ov1.AttachTo(base1)
    ov1.Visible = True

    ' Foreground label � added after AttachTo so it renders above the overlay
    Dim lbl1fg As Label
    lbl1fg.Initialize("")
    lbl1fg.Text = "This text is above the overlay"
    lbl1fg.TextColor = xui.Color_White
    lbl1fg.Gravity = Gravity.CENTER
    base1.AddView(lbl1fg, 0, 64dip, maxW, 56dip)

    currentY = currentY + 120dip + 20dip

    ' =========================================================================
    ' Example 2: Colored overlay (error/red tint, 50%)
    ' Demonstrates using a custom overlay colour to create a danger-state tint.
    ' =========================================================================
    currentY = AddSectionTitle("Coloured overlay (error 50%)", currentY, maxW)
    Dim pnl2 As Panel
    pnl2.Initialize("")
    Dim base2 As B4XView = pnl2
    base2.Color = xui.Color_RGB(209, 213, 219)    ' light grey card background
    pnlHost.AddView(base2, PAGE_PAD, currentY, maxW, 100dip)

    Dim lbl2bg As Label
    lbl2bg.Initialize("")
    lbl2bg.Text = "Card content beneath tint"
    lbl2bg.TextColor = xui.Color_RGB(31, 41, 55)
    lbl2bg.Gravity = Gravity.CENTER
    base2.AddView(lbl2bg, 0, 0, maxW, 100dip)

    Dim ov2 As B4XDaisyOverlay
    ov2.Initialize(Me, "ov2")
    ov2.OverlayColor = xui.Color_RGB(239, 68, 68)    ' error red
    ov2.Opacity = 0.5
    ov2.AttachTo(base2)
    ov2.Visible = True

    currentY = currentY + 100dip + 20dip

    ' =========================================================================
    ' Example 3: Rounded overlay matching a rounded card
    ' Demonstrates the Rounded property so the overlay clips to the same
    ' corner radius as its host container (rounded-xl = 12dip).
    ' =========================================================================
    currentY = AddSectionTitle("Rounded overlay (rounded-xl)", currentY, maxW)
    Dim pnl3 As Panel
    pnl3.Initialize("")
    Dim base3 As B4XView = pnl3
    base3.SetColorAndBorder(xui.Color_RGB(16, 185, 129), 0, xui.Color_Transparent, 20dip)
    pnlHost.AddView(base3, PAGE_PAD, currentY, maxW, 120dip)

    Dim lbl3bg As Label
    lbl3bg.Initialize("")
    lbl3bg.Text = "Rounded card (below overlay)"
    lbl3bg.TextColor = xui.Color_White
    lbl3bg.Gravity = Gravity.CENTER
    base3.AddView(lbl3bg, 0, 0, maxW, 56dip)

    Dim ov3 As B4XDaisyOverlay
    ov3.Initialize(Me, "ov3")
    ov3.OverlayColor = xui.Color_Black
    ov3.Opacity = 0.45
    ov3.Rounded = "rounded-xl"
    ov3.AttachTo(base3)
    ov3.Visible = True

    Dim lbl3fg As Label
    lbl3fg.Initialize("")
    lbl3fg.Text = "Overlay clips to rounded-xl"
    lbl3fg.TextColor = xui.Color_White
    lbl3fg.TextSize = 12
    lbl3fg.Gravity = Gravity.CENTER
    base3.AddView(lbl3fg, 0, 64dip, maxW, 56dip)

    currentY = currentY + 120dip + 20dip

    ' =========================================================================
    ' Example 4: PassThrough � overlay tint, touches reach content below
    ' With PassThrough = True the overlay panel's Enabled is False, so touch
    ' events are not consumed and widgets beneath remain fully interactive.
    ' =========================================================================
    currentY = AddSectionTitle("Pass-through touches", currentY, maxW)
    Dim pnl4 As Panel
    pnl4.Initialize("")
    Dim base4 As B4XView = pnl4
    base4.Color = xui.Color_RGB(245, 243, 255)     ' lightest violet background
    pnlHost.AddView(base4, PAGE_PAD, currentY, maxW, 120dip)

    ' Interactive button underneath the overlay
    Dim btn4 As Button
    btn4.Initialize("btn4")
    btn4.Text = "Tap me (touch passes through overlay)"
    btn4.TextColor = xui.Color_White
    btn4.Color = xui.Color_RGB(124, 58, 237)
    base4.AddView(btn4, 8dip, (120dip - 44dip) / 2, maxW - 16dip, 44dip)

    Dim ov4 As B4XDaisyOverlay
    ov4.Initialize(Me, "ov4")
    ov4.OverlayColor = xui.Color_RGB(124, 58, 237)    ' purple tint
    ov4.Opacity = 0.2
    ov4.PassThrough = True
    ov4.AttachTo(base4)
    ov4.Visible = True

    currentY = currentY + 120dip + 20dip

    ' =========================================================================
    ' Example 5: Low opacity white overlay ("frosted" appearance)
    ' A near-white overlay at 15% creates a subtle frosted-glass look.
    ' =========================================================================
    currentY = AddSectionTitle("Frosted overlay (white 15%)", currentY, maxW)
    Dim pnl5 As Panel
    pnl5.Initialize("")
    Dim base5 As B4XView = pnl5
    base5.Color = xui.Color_RGB(15, 23, 42)    ' dark navy background
    pnlHost.AddView(base5, PAGE_PAD, currentY, maxW, 100dip)

    Dim lbl5bg As Label
    lbl5bg.Initialize("")
    lbl5bg.Text = "Dark navy (below overlay)"
    lbl5bg.TextColor = xui.Color_RGB(148, 163, 184)
    lbl5bg.Gravity = Gravity.CENTER
    base5.AddView(lbl5bg, 0, 0, maxW, 48dip)

    Dim ov5 As B4XDaisyOverlay
    ov5.Initialize(Me, "ov5")
    ov5.OverlayColor = xui.Color_White
    ov5.Opacity = 0.15
    ov5.AttachTo(base5)
    ov5.Visible = True

    Dim lbl5fg As Label
    lbl5fg.Initialize("")
    lbl5fg.Text = "Frosted-glass tint (above)"
    lbl5fg.TextColor = xui.Color_White
    lbl5fg.Gravity = Gravity.CENTER
    base5.AddView(lbl5fg, 0, 52dip, maxW, 48dip)

    currentY = currentY + 100dip + 20dip

    ' =========================================================================
    ' Example 6: AddToParent � explicit placement, not full cover
    ' Demonstrates using AddToParent to place the overlay at a fixed sub-region
    ' of the container (bottom third of the panel), like a caption bar.
    ' =========================================================================
    currentY = AddSectionTitle("Caption bar via AddToParent", currentY, maxW)
    Dim pnl6 As Panel
    pnl6.Initialize("")
    Dim base6 As B4XView = pnl6
    base6.Color = xui.Color_RGB(249, 115, 22)    ' orange panel
    pnlHost.AddView(base6, PAGE_PAD, currentY, maxW, 130dip)

    Dim lbl6bg As Label
    lbl6bg.Initialize("")
    lbl6bg.Text = "Image / content area"
    lbl6bg.TextColor = xui.Color_White
    lbl6bg.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL, Gravity.TOP)
    base6.AddView(lbl6bg, 0, 12dip, maxW, 60dip)

    ' Overlay covers only the bottom 44dip � caption bar
    Dim ov6 As B4XDaisyOverlay
    ov6.Initialize(Me, "ov6")
    ov6.OverlayColor = xui.Color_Black
    ov6.Opacity = 0.6
    ov6.AddToParent(base6, 0, 86dip, maxW, 44dip)
    ov6.Visible = True

    Dim lbl6caption As Label
    lbl6caption.Initialize("")
    lbl6caption.Text = "Caption overlay bar"
    lbl6caption.TextColor = xui.Color_White
    lbl6caption.TextSize = 12
    lbl6caption.Gravity = Gravity.CENTER
    base6.AddView(lbl6caption, 0, 86dip, maxW, 44dip)

    currentY = currentY + 130dip + 20dip

    ' =========================================================================
    ' Example 7: Full-screen overlay triggered by a button
    ' Tapping the button adds a full-size overlay on top of Root (the page).
    ' The overlay matches the carousel indicator strip color (black ~31%).
    ' Tap anywhere on the overlay to dismiss it.
    ' =========================================================================
    currentY = AddSectionTitle("Full-screen overlay (tap button)", currentY, maxW)
    Dim btnShowOverlay As B4XDaisyButton
    btnShowOverlay.Initialize(Me, "btnShowOverlay")
    btnShowOverlay.Text = "Show full-screen overlay"
    btnShowOverlay.Variant = "neutral"
    btnShowOverlay.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 44dip)
    currentY = currentY + 44dip + 20dip

    ' =========================================================================
    ' Example 8: White full-screen overlay (80% opacity) via button
    ' A bright white veil covers the whole page at 80% opacity � useful for
    ' light-theme loading states or confirmation overlays.
    ' Tap anywhere on the overlay to dismiss it.
    ' =========================================================================
    currentY = AddSectionTitle("White overlay 80% (tap button)", currentY, maxW)
    Dim btnShowWhite As B4XDaisyButton
    btnShowWhite.Initialize(Me, "btnShowWhite")
    btnShowWhite.Text = "Show white overlay"
    btnShowWhite.Variant = "ghost"
    btnShowWhite.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 44dip)
    currentY = currentY + 44dip + 20dip

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.setTextColor(xui.Color_RGB(30, 41, 59))
    title.TextSize = "text-lg"
    title.FontBold = True
    Return Y + 48dip
End Sub

Private Sub btn4_Click
    xui.MsgboxAsync("The button below the overlay was tapped! Touches passed through.", "PassThrough works")
End Sub

' /**
'  * Shows the full-screen overlay over the entire page.
'  */
Private Sub btnShowOverlay_Click(Tag As Object)
    mFsOverlay.Open
End Sub

' /**
'  * Fired by the overlay's Opened event.
'  */
Private Sub mFsOverlay_Opened(Tag As Object)
    ' Overlay is now visible � no-op in demo, wired to show event fires correctly.
End Sub

' /**
'  * Fired by the overlay's Closed event (triggered automatically via CloseOnClick).
'  */
Private Sub mFsOverlay_Closed(Tag As Object)
    ' Overlay has been dismissed by the user's tap.
End Sub

' /**
'  * Click event fires in addition to Close when CloseOnClick = True.
'  */
Private Sub mFsOverlay_Click(Tag As Object)
    ' No extra action needed � Close is handled automatically by the component.
End Sub

Private Sub btnShowWhite_Click(Tag As Object)
    mWhiteOverlay.Open
End Sub

Private Sub mWhiteOverlay_Opened(Tag As Object)
End Sub

Private Sub mWhiteOverlay_Closed(Tag As Object)
End Sub

Private Sub mWhiteOverlay_Click(Tag As Object)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
