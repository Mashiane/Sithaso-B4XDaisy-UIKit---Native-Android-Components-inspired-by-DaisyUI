B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
'B4XPageStack.bas
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private sv As ScrollView
	Private StackEntries As List
	Private mStackIntroRunning As Boolean = False
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Stack Demo")
	
	sv.Initialize(0)
	Root.AddView(sv, 0, 0, Root.Width, Root.Height)
	StackEntries.Initialize
	
	Dim top As Int = 10dip
	top = CreateStackDemo(sv, top, "bottom") ' Default
	top = CreateStackDemo(sv, top, "top")
	top = CreateStackDemo(sv, top, "start")
	top = CreateStackDemo(sv, top, "end")
	
	sv.Panel.Height = top + 50dip
End Sub

Private Sub CreateStackDemo(TargetSV As ScrollView, TopOffset As Int, Direction As String) As Int
	Dim w As Int = B4XDaisyVariants.TailwindSizeToDip("32", 128dip)
	Dim h As Int = B4XDaisyVariants.TailwindSizeToDip("20", 80dip)
	
	Dim lbl As Label
	lbl.Initialize("")
	lbl.Text = "Direction: " & Direction.ToUpperCase
	lbl.TextColor = xui.Color_Black
	lbl.TextSize = 14
	TargetSV.Panel.AddView(lbl, 20dip, TopOffset, 200dip, 30dip)
	TopOffset = TopOffset + 30dip
	
	Dim stack As B4XDaisyStack
	stack.Initialize(Me, "")
	Dim pStack As B4XView = stack.CreateView(w, h)
	TargetSV.Panel.AddView(pStack, 50dip, TopOffset, w, h)
	
	stack.Direction = Direction
	stack.setLayoutAnimationMs(0)
	stack.setStepPrimary(0)
	stack.setStepSecondary(0)
	
	AddDivs(stack)
	StackEntries.Add(CreateMap("stack": stack, "stepPrimary": 7, "stepSecondary": 3, "animationMs": 220))
	
	Return TopOffset + h + 30dip
End Sub

Private Sub AddDivs(stack As B4XDaisyStack)
	' Colors
	Dim cPrimary As Int = B4XDaisyVariants.ResolveOnlineColor("primary", 0xFF570DF8)
	Dim tPrimary As Int = B4XDaisyVariants.ResolveVariantColor(Null, "primary", "text", xui.Color_White)
	
	Dim cAccent As Int = B4XDaisyVariants.ResolveOnlineColor("accent", 0xFF37CDBE)
	Dim tAccent As Int = B4XDaisyVariants.ResolveVariantColor(Null, "accent", "text", xui.Color_Black)
	
	Dim cSecondary As Int = B4XDaisyVariants.ResolveOnlineColor("secondary", 0xFFF000B8)
	Dim tSecondary As Int = B4XDaisyVariants.ResolveVariantColor(Null, "secondary", "text", xui.Color_White)
	
	' Create 3 Divs using setters
	AddDiv(stack, cPrimary, tPrimary, "1")
	AddDiv(stack, cAccent, tAccent, "2")
	AddDiv(stack, cSecondary, tSecondary, "3")
End Sub

Private Sub AddDiv(stack As B4XDaisyStack, Color As Int, TextColor As Int, Text As String)
	Dim div As B4XDaisyDiv
	div.Initialize(Me, "")
	Dim p As B4XView = div.CreateView(10dip, 10dip)
	
	' Using Setters as requested
	div.BackgroundColor = Color
	div.TextColor = TextColor
	div.Text = Text
	div.setWidth("100%")
	div.setHeight("100%")
	div.RoundedBox = True
	div.PlaceContentCenter = True
	div.Shadow = "none"
	
	' Add to Stack
	stack.AddLayer(p)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(Me, "AnimateStacksIn")
End Sub

Private Sub B4XPage_Disappear
	SetStacksCollapsed
End Sub

Private Sub SetStacksCollapsed
	If StackEntries.IsInitialized = False Then Return
	For Each entry As Map In StackEntries
		Dim stack As B4XDaisyStack = entry.Get("stack")
		stack.setLayoutAnimationMs(0)
		stack.setStepPrimary(0)
		stack.setStepSecondary(0)
	Next
End Sub

Private Sub AnimateStacksIn
	If StackEntries.IsInitialized = False Or StackEntries.Size = 0 Then Return
	If mStackIntroRunning Then Return
	mStackIntroRunning = True
	Sleep(30)
	For Each entry As Map In StackEntries
		Dim stack As B4XDaisyStack = entry.Get("stack")
		Dim animMs As Int = entry.GetDefault("animationMs", 220)
		Dim stepPrimary As Int = entry.GetDefault("stepPrimary", 7)
		Dim stepSecondary As Int = entry.GetDefault("stepSecondary", 3)
		stack.setLayoutAnimationMs(animMs)
		stack.setStepPrimary(stepPrimary)
		stack.setStepSecondary(stepSecondary)
	Next
	Sleep(300)
	mStackIntroRunning = False
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    If sv.IsInitialized Then
        sv.SetLayout(0, 0, Width, Height)
    End If
End Sub
