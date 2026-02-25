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
	Private toast As B4XDaisyToast
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Toast")

	toast.Initialize(Me, "toast")
	' Attach the toast container to the Root of this page.
	toast.SetRoot(Root)
	' We use a dummy view to trigger DesignerCreateView if needed, 
	' or just use code-only path.
	Dim dummy As Panel
	dummy.Initialize("")
	Dim b As B4XView = dummy
	b.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	toast.DesignerCreateView(b, Null, CreateMap())

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
	lblHeader.Text = "Toast Notifications"
	lblHeader.TextSize = "text-sm"
	lblHeader.FontBold = True
	currentY = currentY + 60dip
	
	'--- Example 1: Position Controls ---
	Dim lblEx1 As B4XDaisyText
	lblEx1.Initialize(Me, "")
	lblEx1.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx1.Text = "Screen Positioning"
	lblEx1.TextSize = "text-sm"
	currentY = currentY + 40dip

	Dim btnBottomEnd As Button = CreateButton("Bottom End", "bottom_end")
	content.AddView(btnBottomEnd, 10dip, currentY, 140dip, 40dip)
	
	Dim btnTopStart As Button = CreateButton("Top Start", "top_start")
	content.AddView(btnTopStart, 160dip, currentY, 140dip, 40dip)
	currentY = currentY + 50dip

	Dim btnBottomStart As Button = CreateButton("Bottom Start", "bottom_start")
	content.AddView(btnBottomStart, 10dip, currentY, 140dip, 40dip)
	
	Dim btnTopEnd As Button = CreateButton("Top End", "top_end")
	content.AddView(btnTopEnd, 160dip, currentY, 140dip, 40dip)
	currentY = currentY + 60dip

	'--- Example 2: Timed Notifications ---
	Dim lblEx2 As B4XDaisyText
	lblEx2.Initialize(Me, "")
	lblEx2.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx2.Text = "Timed Notifications (3s)"
	lblEx2.TextSize = "text-sm"
	currentY = currentY + 40dip

	Dim btnTimedSuccess As Button = CreateButton("Timed Success", "timed_success")
	content.AddView(btnTimedSuccess, 10dip, currentY, 140dip, 40dip)
	
	Dim btnTimedError As Button = CreateButton("Timed Error", "timed_error")
	content.AddView(btnTimedError, 160dip, currentY, 140dip, 40dip)
	currentY = currentY + 60dip

	'--- Example 3: Stacked ---
	Dim lblEx3 As B4XDaisyText
	lblEx3.Initialize(Me, "")
	lblEx3.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx3.Text = "Stacked Messages"
	lblEx3.TextSize = "text-sm"
	currentY = currentY + 40dip

	Dim btnStackInfo As Button = CreateButton("Add Info Stack", "stack_info")
	content.AddView(btnStackInfo, 10dip, currentY, 140dip, 40dip)
	
	Dim btnClearAll As Button = CreateButton("Clear All", "clear_all")
	content.AddView(btnClearAll, 160dip, currentY, 140dip, 40dip)
	currentY = currentY + 60dip

	' Initial visible toast
	toast.Info("Welcome to Toast Demos!")
End Sub

Private Sub B4XPage_Appear
	' Clear any lingering toasts from previous visits
	toast.Clear
End Sub

Private Sub CreateButton(Text As String, Tag As Object) As Button
	Dim b As Button
	b.Initialize("ExampleClick")
	b.Text = Text
	b.Tag = Tag
	Return b
End Sub

Private Sub ExampleClick_Click
	Dim b As Button = Sender
	Dim tag As String = b.Tag
	
	Select Case tag
		Case "bottom_end"
			toast.SetPosition("end", "bottom")
			toast.Info("Bottom End Notification")
		Case "top_start"
			toast.SetPosition("start", "top")
			toast.Success("Top Start Notification")
		Case "bottom_start"
			toast.SetPosition("start", "bottom")
			toast.Warning("Bottom Start Notification")
		Case "top_end"
			toast.SetPosition("end", "top")
			toast.Error("Top End Notification")
		Case "timed_success"
			toast.SuccessWithDuration("Successful Operation!", 3000)
		Case "timed_error"
			toast.ErrorWithDuration("Failed to save data.", 5000)
		Case "stack_info"
			toast.Info("New message arrived.")
		Case "clear_all"
			toast.Clear
	End Select
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	toast.Base_Resize(Width, Height)
	If Root.GetView(0) Is ScrollView Then
		Dim sv As ScrollView = Root.GetView(0)
		sv.Width = Width
		sv.Height = Height
	End If
End Sub

