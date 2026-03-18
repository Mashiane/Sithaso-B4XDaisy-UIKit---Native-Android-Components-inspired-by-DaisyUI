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
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Tooltip")

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
	ttInfo.mBase = CreateDummyBase
	ttInfo.DesignerCreateView(ttInfo.mBase, Null, CreateMap("Message": "Info: System details", "Variant": "info"))
	ttInfo.AttachToTarget(btnInfo.mBase)
	currentY = currentY + 100dip ' Large gap for tooltip visibility
	
	Dim btnSuccess As B4XDaisyButton = CreateButton("Show Success Tooltip", "v_success")
	btnSuccess.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttSuccess.Initialize(Me, "ttSuccess")
	ttSuccess.mBase = CreateDummyBase
	ttSuccess.DesignerCreateView(ttSuccess.mBase, Null, CreateMap("Message": "Success: Task complete!", "Variant": "success"))
	ttSuccess.AttachToTarget(btnSuccess.mBase)
	currentY = currentY + 100dip
	
	Dim btnWarning As B4XDaisyButton = CreateButton("Show Warning Tooltip", "v_warning")
	btnWarning.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttWarning.Initialize(Me, "ttWarning")
	ttWarning.mBase = CreateDummyBase
	ttWarning.DesignerCreateView(ttWarning.mBase, Null, CreateMap("Message": "Warning: Check parameters", "Variant": "warning"))
	ttWarning.AttachToTarget(btnWarning.mBase)
	currentY = currentY + 100dip
	
	Dim btnError As B4XDaisyButton = CreateButton("Show Error Tooltip", "v_error")
	btnError.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttError.Initialize(Me, "ttError")
	ttError.mBase = CreateDummyBase
	ttError.DesignerCreateView(ttError.mBase, Null, CreateMap("Message": "Error: Action failed!", "Variant": "error"))
	ttError.AttachToTarget(btnError.mBase)
	currentY = currentY + 120dip

	'--- Positions Section ---
	AddSectionHeader(content, "Placement", currentY)
	currentY = currentY + 60dip
	
	Dim btnTop As B4XDaisyButton = CreateButton("Tooltip Top", "pos_top")
	btnTop.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttTop.Initialize(Me, "ttTop")
	ttTop.mBase = CreateDummyBase
	ttTop.DesignerCreateView(ttTop.mBase, Null, CreateMap("Message": "I am on top"))
	ttTop.AttachToTarget(btnTop.mBase)
	currentY = currentY + 100dip
	
	Dim btnBottom As B4XDaisyButton = CreateButton("Tooltip Bottom", "pos_bottom")
	btnBottom.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttBottom.Initialize(Me, "ttBottom")
	ttBottom.mBase = CreateDummyBase
	ttBottom.DesignerCreateView(ttBottom.mBase, Null, CreateMap("Message": "I am at the bottom", "Position": "bottom"))
	ttBottom.AttachToTarget(btnBottom.mBase)
	currentY = currentY + 100dip
	
	' For Left tooltip: place button on the right side to give space to the left
	Dim btnLeft As B4XDaisyButton = CreateButton("Left", "pos_left")
	btnLeft.AddToParent(content, 180dip, currentY, 100dip, 40dip)
	ttLeft.Initialize(Me, "ttLeft")
	ttLeft.mBase = CreateDummyBase
	ttLeft.DesignerCreateView(ttLeft.mBase, Null, CreateMap("Message": "Left side tooltip", "Position": "left"))
	ttLeft.AttachToTarget(btnLeft.mBase)
	currentY = currentY + 100dip
	
	' For Right tooltip: place button on the left side to give space to the right
	Dim btnRight As B4XDaisyButton = CreateButton("Right", "pos_right")
	btnRight.AddToParent(content, 20dip, currentY, 100dip, 40dip)
	ttRight.Initialize(Me, "ttRight")
	ttRight.mBase = CreateDummyBase
	ttRight.DesignerCreateView(ttRight.mBase, Null, CreateMap("Message": "Right side tooltip", "Position": "right"))
	ttRight.AttachToTarget(btnRight.mBase)
	currentY = currentY + 120dip

	'--- Rich Section ---
	AddSectionHeader(content, "Rich Content", currentY)
	currentY = currentY + 60dip
	
	Dim btnRich As B4XDaisyButton = CreateButton("Show Rich Tooltip", "rich")
	btnRich.AddToParent(content, 20dip, currentY, 260dip, 40dip)
	ttRich.Initialize(Me, "ttRich")
	ttRich.mBase = CreateDummyBase
	ttRich.DesignerCreateView(ttRich.mBase, Null, CreateMap("Variant": "neutral", "ShowArrow": True))
	ttRich.AttachToTarget(btnRich.mBase)
	
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

Private Sub CreateDummyBase As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	Return b
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
