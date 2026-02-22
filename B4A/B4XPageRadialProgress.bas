B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private mParent As B4XMainPage
	
	Private Timer1 As Timer
	Private animatedRadial As B4XDaisyRadialProgress
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Radial Progress")

	Dim sv As ScrollView
	sv.Initialize(Max(1dip, Root.Height))
	Root.AddView(sv, 0, 0, Root.Width, Root.Height)
	Dim content As B4XView = sv.Panel
	content.Color = xui.Color_Transparent
	
	Dim currentY As Int = 20dip
	
	'Header
	Dim lblHeader As B4XDaisyLabel
	lblHeader.Initialize(Me, "")
	lblHeader.AddToParent(content, 10dip, currentY, 300dip, 40dip)
	lblHeader.Text = "Radial Progress"
	lblHeader.TextSize = "text-2xl"
	lblHeader.FontBold = True
	currentY = currentY + 50dip
	
	'--- Radial progress ---
	Dim lblEx1 As B4XDaisyLabel
	lblEx1.Initialize(Me, "")
	lblEx1.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx1.Text = "Radial progress"
	currentY = currentY + 40dip
	
	Dim rp1 As B4XDaisyRadialProgress
	rp1.Initialize(Me, "")
	rp1.AddToParent(content, 10dip, currentY, 80dip, 80dip)
	rp1.Value = 70
	currentY = currentY + 100dip
	
	'--- Different values ---
	Dim lblEx2 As B4XDaisyLabel
	lblEx2.Initialize(Me, "")
	lblEx2.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx2.Text = "Different values"
	currentY = currentY + 40dip
	
	Dim vals() As Int = Array As Int(0, 20, 60, 80, 100)
	For i = 0 To vals.Length - 1
		Dim rp As B4XDaisyRadialProgress
		rp.Initialize(Me, "")
		rp.AddToParent(content, 10dip + (i * 70dip), currentY, 60dip, 60dip)
		rp.Variant = "primary"
		rp.Value = vals(i)
	Next
	currentY = currentY + 80dip
	
	'--- Custom colors ---
	Dim lblEx3 As B4XDaisyLabel
	lblEx3.Initialize(Me, "")
	lblEx3.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx3.Text = "Custom colors"
	currentY = currentY + 40dip
	
	Dim rpCol1 As B4XDaisyRadialProgress
	rpCol1.Initialize(Me, "")
	rpCol1.AddToParent(content, 10dip, currentY, 80dip, 80dip)
	rpCol1.Value = 70
	rpCol1.Variant = "primary"
	
	Dim rpCol2 As B4XDaisyRadialProgress
	rpCol2.Initialize(Me, "")
	rpCol2.AddToParent(content, 100dip, currentY, 80dip, 80dip)
	rpCol2.Value = 70
	rpCol2.Variant = "secondary"
	
	Dim rpCol3 As B4XDaisyRadialProgress
	rpCol3.Initialize(Me, "")
	rpCol3.AddToParent(content, 190dip, currentY, 80dip, 80dip)
	rpCol3.Value = 70
	rpCol3.Variant = "accent"
	
	Dim rpCol4 As B4XDaisyRadialProgress
	rpCol4.Initialize(Me, "")
	rpCol4.AddToParent(content, 280dip, currentY, 80dip, 80dip)
	rpCol4.Value = 70
	rpCol4.Variant = "neutral"
	rpCol4.TrackColor = xui.Color_RGB(254, 215, 170)
	rpCol4.TextColor = xui.Color_RGB(194, 65, 12)
	
	currentY = currentY + 100dip
	
	'--- Different thickness ---
	Dim lblEx4 As B4XDaisyLabel
	lblEx4.Initialize(Me, "")
	lblEx4.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx4.Text = "Different thickness"
	currentY = currentY + 40dip
	
	Dim rpThick1 As B4XDaisyRadialProgress
	rpThick1.Initialize(Me, "")
	rpThick1.AddToParent(content, 10dip, currentY, 80dip, 80dip)
	rpThick1.Value = 70
	rpThick1.Thickness = "2dip"
	
	Dim rpThick2 As B4XDaisyRadialProgress
	rpThick2.Initialize(Me, "")
	rpThick2.AddToParent(content, 100dip, currentY, 80dip, 80dip)
	rpThick2.Value = 70
	rpThick2.Thickness = "10dip"
	currentY = currentY + 100dip
	
	'--- Different sizes ---
	Dim lblEx5 As B4XDaisyLabel
	lblEx5.Initialize(Me, "")
	lblEx5.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx5.Text = "Different sizes"
	currentY = currentY + 40dip
	
	Dim rpSize1 As B4XDaisyRadialProgress
	rpSize1.Initialize(Me, "")
	rpSize1.AddToParent(content, 10dip, currentY, 120dip, 120dip)
	rpSize1.Value = 70
	
	Dim rpSize2 As B4XDaisyRadialProgress
	rpSize2.Initialize(Me, "")
	rpSize2.AddToParent(content, 150dip, currentY + 30dip, 60dip, 60dip)
	rpSize2.Value = 70
	currentY = currentY + 140dip
	
	'--- Custom Background and Border ---
	Dim lblEx6 As B4XDaisyLabel
	lblEx6.Initialize(Me, "")
	lblEx6.AddToParent(content, 10dip, currentY, 340dip, 30dip)
	lblEx6.Text = "Custom Background & Border"
	currentY = currentY + 40dip
	
	Dim rpBg As B4XDaisyRadialProgress
	rpBg.Initialize(Me, "")
	rpBg.AddToParent(content, 10dip, currentY, 80dip, 80dip)
	rpBg.Value = 70	
	rpBg.Variant = "primary"
	rpBg.BackgroundColor = xui.Color_RGB(59, 130, 246)
	rpBg.TextColor = xui.Color_White
	rpBg.BorderColor = xui.Color_RGB(59, 130, 246)
	rpBg.BorderWidth = "4dip"
	currentY = currentY + 100dip
	
	'--- Text CountUp & Prefixes ---
	Dim lblEx7 As B4XDaisyLabel
	lblEx7.Initialize(Me, "")
	lblEx7.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx7.Text = "Text CountUp & Prefixes"
	currentY = currentY + 40dip
	
	Dim rpAnim As B4XDaisyRadialProgress
	rpAnim.Initialize(Me, "rpAnim")
	rpAnim.AddToParent(content, 10dip, currentY, 80dip, 80dip)
	rpAnim.Value = 70
	rpAnim.Prefix = "$"
	rpAnim.Suffix = "K"
	rpAnim.TextCountUp = True
	rpAnim.CountUpSpeed = 1000
	animatedRadial = rpAnim
	currentY = currentY + 100dip
	
	'--- SVG DisplayType ---
	Dim lblEx8 As B4XDaisyLabel
	lblEx8.Initialize(Me, "")
	lblEx8.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx8.Text = "SVG DisplayType"
	currentY = currentY + 40dip
	
	Dim rpSvg1 As B4XDaisyRadialProgress
	rpSvg1.Initialize(Me, "")
	rpSvg1.AddToParent(content, 10dip, currentY, 80dip, 80dip)
	rpSvg1.Value = 70
	rpSvg1.DisplayType = "svg"
	rpSvg1.Variant = "success"
	rpSvg1.SvgAsset = "check-solid.svg"
	
	Dim rpSvg2 As B4XDaisyRadialProgress
	rpSvg2.Initialize(Me, "")
	rpSvg2.AddToParent(content, 100dip, currentY, 80dip, 80dip)
	rpSvg2.Value = 70
	rpSvg2.DisplayType = "svg"
	rpSvg2.Variant = "error"
	rpSvg2.SvgAsset = "xmark-solid.svg"
	rpSvg2.Thickness = "4dip"
	currentY = currentY + 100dip
	
	' Add animation control buttons
	Dim btnStart As Button
	btnStart.Initialize("btnStart")
	btnStart.Text = "Animate to 85%"
	content.AddView(btnStart, 10dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	Dim btnAnimate10 As Button
	btnAnimate10.Initialize("btnAnimate10")
	btnAnimate10.Text = "Animate to 10%"
	content.AddView(btnAnimate10, 10dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	Dim btnTimer As Button
	btnTimer.Initialize("btnTimer")
	btnTimer.Text = "Start 5s Countdown"
	content.AddView(btnTimer, 10dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	Dim btnReset As Button
	btnReset.Initialize("btnReset")
	btnReset.Text = "Reset (Max 100)"
	content.AddView(btnReset, 10dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	content.Height = currentY + 50dip
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
End Sub

Private Sub btnStart_Click
	animatedRadial.SetValueAnimated(85, 3000)
End Sub

Private Sub btnAnimate10_Click
	animatedRadial.SetValueAnimated(10, 2000)
End Sub

Private Sub btnTimer_Click
	animatedRadial.StartTimer(5000)
End Sub

Private Sub btnReset_Click
	animatedRadial.setMaxValue(100)
	animatedRadial.setPrefix("$")
	animatedRadial.setSuffix("K")
	animatedRadial.setTextCountUp(True)
	animatedRadial.SetValueAnimated(0, 500)
End Sub

Public Sub SetParent(Parent As B4XMainPage)
	mParent = Parent
End Sub
