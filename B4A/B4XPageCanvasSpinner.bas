B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private overlay As B4XDaisyOverlay
    Private spinner As B4XDaisyCanvasSpinner
    Private btn As B4XView
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_White
    B4XPages.SetTitle(Me, "Canvas Spinner")

    overlay.Initialize(Me, "overlay")
    overlay.OverlayColor = xui.Color_White
    overlay.Opacity = 0.7
    overlay.AttachTo(Root) ' adds to root and expands automatically
    overlay.Visible = False ' start hidden

    spinner.Initialize(Me, "spinner")
    spinner.AttachTo(overlay.mBase) ' attach into overlay surface
    ' make sure the spinner has the proper size/drawing immediately
    spinner.Resize(Root.Width, Root.Height)
    spinner.Hide ' not animating until the overlay is shown
    
    Dim db As B4XDaisyButton
    db.Initialize(Me, "btn")
    btn = db.AddToParent(Root, 10dip, 10dip, 100dip, 40dip)
    db.Text = "Toggle"
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    overlay.Resize(Width, Height)
    spinner.Resize(Width, Height)
End Sub

Private Sub btn_Click(Tag As Object)
    overlay.Visible = Not(overlay.Visible)
    If overlay.Visible Then
        spinner.Show
    Else
        spinner.Hide
    End If
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
