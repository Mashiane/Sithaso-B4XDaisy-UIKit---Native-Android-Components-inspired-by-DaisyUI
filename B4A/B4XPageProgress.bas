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
	
	' Demo progress bars
	Private pAnim As B4XDaisyProgress
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Progress")

	Dim sv As ScrollView
	sv.Initialize(Max(1dip, Root.Height))
	Root.AddView(sv, 0, 0, Root.Width, Root.Height)
	Dim content As B4XView = sv.Panel
	content.Color = xui.Color_Transparent
	
	Dim currentY As Int = 20dip
	
	'Header
	Dim lblHeader As B4XDaisyText
	lblHeader.Initialize(Me, "")
	lblHeader.AddToParent(content, 10dip, currentY, 300dip, 40dip)
	lblHeader.Text = "Progress"
	lblHeader.TextSize = "text-sm"
	lblHeader.FontBold = True
	currentY = currentY + 50dip
	
	'--- Example 1 ---
	Dim lblEx1 As B4XDaisyText
	lblEx1.Initialize(Me, "")
	lblEx1.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx1.Text = "Progress (Default Neutral)"
	lblEx1.TextSize = "text-sm"
	currentY = currentY + 40dip

	Dim vals() As Int = Array As Int(0, 10, 40, 70, 100)
	For i = 0 To vals.Length - 1
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(content, 10dip, currentY, 200dip, 8dip)
		p.Value = vals(i)
		currentY = currentY + 30dip
	Next
	currentY = currentY + 20dip
	
	'--- Example 2 ---
	Dim lblEx2 As B4XDaisyText
	lblEx2.Initialize(Me, "")
	lblEx2.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx2.Text = "Progress (Primary)"
	lblEx2.TextSize = "text-sm"
	currentY = currentY + 40dip

	For i = 0 To vals.Length - 1
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(content, 10dip, currentY, 200dip, 8dip)
		p.Variant = "primary"
		p.Value = vals(i)
		currentY = currentY + 30dip
	Next
	currentY = currentY + 20dip
	
	'--- Example Colors ---
	Dim lblEx3 As B4XDaisyText
	lblEx3.Initialize(Me, "")
	lblEx3.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx3.Text = "Progress Colors"
	lblEx3.TextSize = "text-sm"
	currentY = currentY + 40dip

	Dim colorKeys() As String = Array As String("secondary", "accent", "info", "success", "warning", "error")
	For Each c As String In colorKeys
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(content, 10dip, currentY, 200dip, 8dip)
		p.Variant = c
		p.Value = 65
		currentY = currentY + 30dip
	Next
	currentY = currentY + 20dip

	'--- Sizes ---
	Dim lblEx4 As B4XDaisyText
	lblEx4.Initialize(Me, "")
	lblEx4.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx4.Text = "Progress Sizes (with Tooltips)"
	lblEx4.TextSize = "text-sm"
	currentY = currentY + 60dip ' More space

	Dim sizes() As String = Array As String("xs", "sm", "md", "lg", "xl")
	For Each s As String In sizes
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(content, 10dip, currentY, 180dip, 20dip) ' Smaller width (180dip) + spacing
		p.Size = s
		p.Value = 40 + (sizes.Length * 5) ' staggered values
		p.ShowTooltip = True
		currentY = currentY + 60dip ' Large vertical gap for tooltips
	Next
	currentY = currentY + 40dip

	'--- Animation & Tooltip ---
	Dim lblEx5 As B4XDaisyText
	lblEx5.Initialize(Me, "")
	lblEx5.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx5.Text = "Animated with Tooltip"
	lblEx5.TextSize = "text-sm"
	currentY = currentY + 60dip ' More space for tooltip

	pAnim.Initialize(Me, "pAnim")
	pAnim.AddToParent(content, 10dip, currentY, 280dip, 12dip)
	pAnim.Variant = "secondary"
	pAnim.ShowTooltip = True
	pAnim.Value = 20
	currentY = currentY + 60dip
	
	Dim btnStart As Button
	btnStart.Initialize("btnStart")
	btnStart.Text = "Animate to 85%"
	content.AddView(btnStart, 20dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	Dim btnAnimate10 As Button
	btnAnimate10.Initialize("btnAnimate10")
	btnAnimate10.Text = "Animate to 10%"
	content.AddView(btnAnimate10, 20dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	Dim btnTimer As Button
	btnTimer.Initialize("btnTimer")
	btnTimer.Text = "Start 5s Countdown"
	content.AddView(btnTimer, 20dip, currentY, 200dip, 40dip)
	currentY = currentY + 50dip
	
	Dim btnReset As Button
	btnReset.Initialize("btnReset")
	btnReset.Text = "Reset (Max 100)"
	content.AddView(btnReset, 20dip, currentY, 200dip, 40dip)
	currentY = currentY + 80dip

	sv.Panel.Height = currentY + 100dip
End Sub

Private Sub btnStart_Click
	pAnim.SetValueAnimated(85, 3000)
End Sub

Private Sub btnAnimate10_Click
	pAnim.SetValueAnimated(10, 2000)
End Sub

Private Sub btnTimer_Click
	pAnim.StartTimer(5000)
End Sub

Private Sub btnReset_Click
	pAnim.setMaxValue(100)
	pAnim.SetValueAnimated(0, 500)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Root.GetView(0) Is ScrollView Then
		Dim sv As ScrollView = Root.GetView(0)
		sv.Width = Width
		sv.Height = Height
	End If
End Sub

