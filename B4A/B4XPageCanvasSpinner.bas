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
    Private spinner As B4XDaisyCanvasSpinner
    Private btn As B4XView
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_White

    spinner.Initialize(Me, "spinner")
    If Root.Parent.IsInitialized Then
        spinner.Show(Root.Parent)
        spinner.Hide
    End If
    
    Dim db As B4XDaisyButton
    db.Initialize(Me, "btn")
    btn = db.AddToParent(Root, 10dip, 10dip, 100dip, 40dip)
    db.Text = "Toggle"
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    spinner.Resize(Width, Height)
End Sub

Private Sub btn_Click(Tag As Object)
    If spinner.Visible Then
        spinner.Hide
    Else
        If Root.Parent.IsInitialized Then
            spinner.Show(Root.Parent)
        End If
    End If
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
