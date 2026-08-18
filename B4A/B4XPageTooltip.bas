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
	'Private mParent As B4XMainPage
	
	' Tooltips
	Private ttInfo As B4XDaisyTooltip
	Private ttSuccess As B4XDaisyTooltip
	Private ttWarning As B4XDaisyTooltip
	Private ttError As B4XDaisyTooltip
	Private ttTop As B4XDaisyTooltip
	Private ttBottom As B4XDaisyTooltip
	Private ttLeft As B4XDaisyTooltip
	Private ttRight As B4XDaisyTooltip
	Private ttRich As B4XDaisyTooltip
	' Alignment examples
	Private ttTopStart As B4XDaisyTooltip
	Private ttTopCenter As B4XDaisyTooltip
	Private ttTopEnd As B4XDaisyTooltip
	Private ttLeftStart As B4XDaisyTooltip
	Private ttLeftCenter As B4XDaisyTooltip
	Private ttLeftEnd As B4XDaisyTooltip
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1

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
	lblHeader.Text = "Tooltip Component"
	lblHeader.TextSize = "text-2xl"
	lblHeader.FontBold = True
	currentY = currentY + 60dip
	
	'--- Variants Section ---
	' Spacing logic: button (40dip) + tooltip (~40dip) + gap (20dip) = ~100dip per item
	AddSectionHeader(content, "Variants", currentY)
	currentY = currentY + 60dip ' More space after header

	Dim btnInfo As B4XDaisyButton = CreateButton("Show Info Tooltip", "v_info")
	btnInfo.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttInfo.Initialize(Me, "ttInfo")
	ttInfo.CreateView(100dip, 100dip)
	ttInfo.Message = "Info: System details"
	ttInfo.Variant = "info"
	ttInfo.AttachTo(btnInfo.View)
	currentY = currentY + 100dip ' Large gap for tooltip visibility
	
	Dim btnSuccess As B4XDaisyButton = CreateButton("Show Success Tooltip", "v_success")
	btnSuccess.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttSuccess.Initialize(Me, "ttSuccess")
	ttSuccess.CreateView(100dip, 100dip)
	ttSuccess.Message = "Success: Task complete!"
	ttSuccess.Variant = "success"
	ttSuccess.AttachTo(btnSuccess.View)
	currentY = currentY + 100dip
	
	Dim btnWarning As B4XDaisyButton = CreateButton("Show Warning Tooltip", "v_warning")
	btnWarning.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttWarning.Initialize(Me, "ttWarning")
	ttWarning.CreateView(100dip, 100dip)
	ttWarning.Message = "Warning: Check parameters"
	ttWarning.Variant = "warning"
	ttWarning.AttachTo(btnWarning.View)
	currentY = currentY + 100dip
	
	Dim btnError As B4XDaisyButton = CreateButton("Show Error Tooltip", "v_error")
	btnError.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttError.Initialize(Me, "ttError")
	ttError.CreateView(100dip, 100dip)
	ttError.Message = "Error: Action failed!"
	ttError.Variant = "error"
	ttError.AttachTo(btnError.View)
	currentY = currentY + 120dip

	'--- Positions Section ---
	AddSectionHeader(content, "Placement", currentY)
	currentY = currentY + 60dip
	
	Dim btnTop As B4XDaisyButton = CreateButton("Tooltip Top", "pos_top")
	btnTop.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttTop.Initialize(Me, "ttTop")
	ttTop.CreateView(100dip, 100dip)
	ttTop.Message = "I am on top"
	ttTop.AttachTo(btnTop.View)
	currentY = currentY + 100dip
	
	Dim btnBottom As B4XDaisyButton = CreateButton("Tooltip Bottom", "pos_bottom")
	btnBottom.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttBottom.Initialize(Me, "ttBottom")
	ttBottom.CreateView(100dip, 100dip)
	ttBottom.Message = "I am at the bottom"
	ttBottom.Position = "bottom"
	ttBottom.AttachTo(btnBottom.View)
	currentY = currentY + 100dip
	
	' For Left tooltip: place button on the right side to give space to the left
	Dim btnLeft As B4XDaisyButton = CreateButton("Left", "pos_left")
	btnLeft.AddToParent(content, 180dip, currentY, 100dip, 40dip)
	ttLeft.Initialize(Me, "ttLeft")
	ttLeft.CreateView(100dip, 100dip)
	ttLeft.Message = "Left side tooltip"
	ttLeft.Position = "left"
	ttLeft.AttachTo(btnLeft.View)
	currentY = currentY + 100dip
	
	' For Right tooltip: place button on the left side to give space to the right
	Dim btnRight As B4XDaisyButton = CreateButton("Right", "pos_right")
	btnRight.AddToParent(content, 20dip, currentY, 100dip, 40dip)
	ttRight.Initialize(Me, "ttRight")
	ttRight.CreateView(100dip, 100dip)
	ttRight.Message = "Right side tooltip"
	ttRight.Position = "right"
	ttRight.AttachTo(btnRight.View)
	currentY = currentY + 120dip

	'--- Alignment Section ---
	' Demonstrates tooltip-start / tooltip-center / tooltip-end alignment.
	AddSectionHeader(content, "Alignment (start / center / end)", currentY)
	currentY = currentY + 60dip

	' Top alignment: tooltip above the button, shifted to start / center / end.
	Dim btnTopStart As B4XDaisyButton = CreateButton("Top start", "al_top_start")
	btnTopStart.AddToParent(content, 20dip, currentY, 200dip, 40dip)
	ttTopStart.Initialize(Me, "ttTopStart")
	ttTopStart.CreateView(100dip, 100dip)
	ttTopStart.Message = "start"
	ttTopStart.Position = "top"
	ttTopStart.Alignment = "start"
	ttTopStart.AttachTo(btnTopStart.View)
	currentY = currentY + 90dip
 
	Dim btnTopCenter As B4XDaisyButton = CreateButton("Top center", "al_top_center")
	btnTopCenter.AddToParent(content, 20dip, currentY, 200dip, 40dip)
	ttTopCenter.Initialize(Me, "ttTopCenter")
	ttTopCenter.CreateView(100dip, 100dip)
	ttTopCenter.Message = "center"
	ttTopCenter.Position = "top"
	ttTopCenter.Alignment = "center"
	ttTopCenter.AttachTo(btnTopCenter.View)
	currentY = currentY + 90dip
 
	Dim btnTopEnd As B4XDaisyButton = CreateButton("Top end", "al_top_end")
	btnTopEnd.AddToParent(content, 20dip, currentY, 200dip, 40dip)
	ttTopEnd.Initialize(Me, "ttTopEnd")
	ttTopEnd.CreateView(100dip, 100dip)
	ttTopEnd.Message = "end"
	ttTopEnd.Position = "top"
	ttTopEnd.Alignment = "end"
	ttTopEnd.AttachTo(btnTopEnd.View)
	currentY = currentY + 110dip
 
	' Left alignment: tooltip to the left of the button, shifted to start / center / end (vertical).
	Dim btnLeftStart As B4XDaisyButton = CreateButton("Left start", "al_left_start")
	btnLeftStart.AddToParent(content, 180dip, currentY, 120dip, 40dip)
	ttLeftStart.Initialize(Me, "ttLeftStart")
	ttLeftStart.CreateView(100dip, 100dip)
	ttLeftStart.Message = "start"
	ttLeftStart.Position = "left"
	ttLeftStart.Alignment = "start"
	ttLeftStart.AttachTo(btnLeftStart.View)
	currentY = currentY + 80dip
 
	Dim btnLeftCenter As B4XDaisyButton = CreateButton("Left center", "al_left_center")
	btnLeftCenter.AddToParent(content, 180dip, currentY, 120dip, 40dip)
	ttLeftCenter.Initialize(Me, "ttLeftCenter")
	ttLeftCenter.CreateView(100dip, 100dip)
	ttLeftCenter.Message = "center"
	ttLeftCenter.Position = "left"
	ttLeftCenter.Alignment = "center"
	ttLeftCenter.AttachTo(btnLeftCenter.View)
	currentY = currentY + 80dip
 
	Dim btnLeftEnd As B4XDaisyButton = CreateButton("Left end", "al_left_end")
	btnLeftEnd.AddToParent(content, 180dip, currentY, 120dip, 40dip)
	ttLeftEnd.Initialize(Me, "ttLeftEnd")
	ttLeftEnd.CreateView(100dip, 100dip)
	ttLeftEnd.Message = "end"
	ttLeftEnd.Position = "left"
	ttLeftEnd.Alignment = "end"
	ttLeftEnd.AttachTo(btnLeftEnd.View)
	currentY = currentY + 120dip
 
	'--- Rich Section ---
	AddSectionHeader(content, "Rich Content", currentY)
	currentY = currentY + 60dip
	
	Dim btnRich As B4XDaisyButton = CreateButton("Show Rich Tooltip", "rich")
	btnRich.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttRich.Initialize(Me, "ttRich")
	ttRich.CreateView(100dip, 100dip)
	ttRich.Variant = "neutral"
	ttRich.ShowArrow = True
	ttRich.AttachTo(btnRich.View)
	
	' Create a rich panel
	Dim p As Panel
	p.Initialize("")
	Dim bRich As B4XView = p
	bRich.SetLayoutAnimated(0, 0, 0, 140dip, 30dip)
	bRich.Color = xui.Color_Transparent
	
	Dim badge As B4XDaisyBadge
	badge.Initialize(Me, "")
	badge.AddToParent(bRich, 0, 3dip, 140dip, 24dip)
	badge.setText("RICH CONTENT")
	badge.setVariant("accent")
	
	ttRich.SetCustomContent(bRich)
	
	currentY = currentY + 150dip
	sv.Panel.Height = currentY
End Sub

Private Sub AddSectionHeader(Parent As B4XView, Text As String, Y As Int)
	Dim lbl As B4XDaisyText
	lbl.Initialize(Me, "")
	lbl.AddToParent(Parent, 15dip, Y, 280dip, 30dip)
	lbl.Text = Text
	lbl.TextSize = "text-lg"
	lbl.FontBold = True
End Sub

Private Sub CreateButton(Text As String, Tag As Object) As B4XDaisyButton
	Dim b As B4XDaisyButton
	b.Initialize(Me, "ExampleClick")
	b.Text = Text
	b.Tag = Tag
	Return b
End Sub

Private Sub ExampleClick_Click(Tag As Object)
	Select Case Tag
		Case "v_info" : ttInfo.Visible = Not(ttInfo.Visible)
		Case "v_success" : ttSuccess.Visible = Not(ttSuccess.Visible)
		Case "v_warning" : ttWarning.Visible = Not(ttWarning.Visible)
		Case "v_error" : ttError.Visible = Not(ttError.Visible)
		Case "pos_top" : ttTop.Visible = Not(ttTop.Visible)
		Case "pos_bottom" : ttBottom.Visible = Not(ttBottom.Visible)
		Case "pos_left" : ttLeft.Visible = Not(ttLeft.Visible)
		Case "pos_right" : ttRight.Visible = Not(ttRight.Visible)
		Case "rich" : ttRich.Visible = Not(ttRich.Visible)
		Case "al_top_start" : ttTopStart.Visible = Not(ttTopStart.Visible)
		Case "al_top_center" : ttTopCenter.Visible = Not(ttTopCenter.Visible)
		Case "al_top_end" : ttTopEnd.Visible = Not(ttTopEnd.Visible)
		Case "al_left_start" : ttLeftStart.Visible = Not(ttLeftStart.Visible)
		Case "al_left_center" : ttLeftCenter.Visible = Not(ttLeftCenter.Visible)
		Case "al_left_end" : ttLeftEnd.Visible = Not(ttLeftEnd.Visible)
	End Select
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Root.GetView(0) Is ScrollView Then
		Dim sv As ScrollView = Root.GetView(0)
		sv.SetLayoutAnimated(0, 0, 0, Width, Height)
	End If
End Sub


Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
