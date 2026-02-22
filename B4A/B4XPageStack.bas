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
	Dim pStack As B4XView = stack.AddToParent(TargetSV.Panel, 50dip, TopOffset, w, h)
	stack.Direction = Direction
	stack.setLayoutAnimationMs(0)
	stack.setStepPrimary(0)
	stack.setStepSecondary(0)
'	Dim pStack As B4XView = stack.AddToParent(TargetSV.Panel, 50dip, TopOffset, w, h)

	'Create 3 stack layers (divs) in-place so each demo is self-contained.

	Dim div1 As B4XDaisyDiv
	div1.Initialize(Me, "")
	Dim divView1 As B4XView = div1.AddToParent(pStack, 0, 0, 10dip, 10dip)
	div1.SetBackgroundColorVariant("primary")
	div1.SetTextColorVariant("primary-content")
	div1.Text = "1"
	div1.setWidth("100%")
	div1.setHeight("100%")
	div1.RoundedBox = True
	div1.PlaceContentCenter = True
	div1.Shadow = "none"
'	Dim divView1 As B4XView = div1.AddToParent(pStack, 0, 0, 10dip, 10dip)
	stack.AddLayer(divView1)

	Dim div2 As B4XDaisyDiv
	div2.Initialize(Me, "")
	Dim divView2 As B4XView = div2.AddToParent(pStack, 0, 0, 10dip, 10dip)
	div2.SetBackgroundColorVariant("accent")
	div2.SetTextColorVariant("accent-content")
	div2.Text = "2"
	div2.setWidth("100%")
	div2.setHeight("100%")
	div2.RoundedBox = True
	div2.PlaceContentCenter = True
	div2.Shadow = "none"
'	Dim divView2 As B4XView = div2.AddToParent(pStack, 0, 0, 10dip, 10dip)
	stack.AddLayer(divView2)

	Dim div3 As B4XDaisyDiv
	div3.Initialize(Me, "")
	Dim divView3 As B4XView = div3.AddToParent(pStack, 0, 0, 10dip, 10dip)
	div3.SetBackgroundColorVariant("secondary")
	div3.SetTextColorVariant("secondary-content")
	div3.Text = "3"
	div3.setWidth("100%")
	div3.setHeight("100%")
	div3.RoundedBox = True
	div3.PlaceContentCenter = True
	div3.Shadow = "none"
'	Dim divView3 As B4XView = div3.AddToParent(pStack, 0, 0, 10dip, 10dip)
	stack.AddLayer(divView3)

	StackEntries.Add(CreateMap("stack": stack, "stepPrimary": 7, "stepSecondary": 3, "animationMs": 220))
	
	Return TopOffset + h + 30dip
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
