B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
'B4XPageStack.bas
#IgnoreWarnings:12
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private sv As ScrollView
	Private StackEntries As List
	Private AvatarLayers As List
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
	AvatarLayers.Initialize
	
	Dim top As Int = 10dip
	top = CreateStackDemo(sv, top, "bottom") ' Default
	top = CreateStackDemo(sv, top, "top")
	top = CreateStackDemo(sv, top, "start")
	top = CreateStackDemo(sv, top, "end")
	top = CreateStackPhotosDemo(sv, top)
	
	sv.Panel.Height = top + 50dip
End Sub

Private Sub CreateStackDemo(TargetSV As ScrollView, TopOffset As Int, Direction As String) As Int
	Dim w As Int = B4XDaisyVariants.TailwindSizeToDip("32", 128dip)
	Dim h As Int = B4XDaisyVariants.TailwindSizeToDip("20", 80dip)
	
	Dim lbl As B4XDaisyText
	lbl.Initialize(Me, "")
	lbl.AddToParent(TargetSV.Panel, 20dip, TopOffset, 200dip, 30dip)
	lbl.Text = "Direction: " & Direction.ToUpperCase
	lbl.TextColor = xui.Color_Black
	lbl.TextSize = 14
	lbl.setAutoResize(False)
	TopOffset = TopOffset + lbl.GetComputedHeight
	
	Dim stack As B4XDaisyStack
	stack.Initialize(Me, "")
	Dim pStack As B4XView = stack.AddToParent(TargetSV.Panel, 50dip, TopOffset, w, h)
	stack.Direction = Direction
	stack.setLayoutAnimationMs(0)
	stack.setStepPrimary(0)
	stack.setStepSecondary(0)
'	Dim pStack As B4XView = stack.AddToParent(TargetSV.Panel, 50dip, TopOffset, w, h)

	'Create 3 stack layers (divs) in-place so each demo is self-contained.

	Dim div1 As B4XDaisyDivision
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

	Dim div2 As B4XDaisyDivision
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

	Dim div3 As B4XDaisyDivision
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
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
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

Private Sub CreateStackPhotosDemo(TargetSV As ScrollView, TopOffset As Int) As Int
	Dim w As Int = B4XDaisyVariants.TailwindSizeToDip("w-48", 192dip)
	Dim h As Int = B4XDaisyVariants.TailwindSizeToDip("h-64", 256dip)
	
	Dim lbl As B4XDaisyText
	lbl.Initialize(Me, "")
	lbl.AddToParent(TargetSV.Panel, 20dip, TopOffset, 300dip, 30dip)
	lbl.Text = "Photos (direction: bottom)"
	lbl.TextColor = xui.Color_Black
	lbl.TextSize = 14
	lbl.setAutoResize(False)
	TopOffset = TopOffset + lbl.GetComputedHeight
	
	Dim photoStack As B4XDaisyStack
	photoStack.Initialize(Me, "")
	Dim stackView As B4XView = photoStack.AddToParent(TargetSV.Panel, 50dip, TopOffset, w, h)
	photoStack.Direction = "bottom"
	photoStack.setLayoutAnimationMs(0)
	photoStack.setStepPrimary(18)
	photoStack.setStepSecondary(8)
	
	AddPhotoLayer(TargetSV.Panel, photoStack, stackView, w, h, "photo-1559703248-dcaaec9fab78")
	AddPhotoLayer(TargetSV.Panel, photoStack, stackView, w, h, "photo-1565098772267-60af42b81ef2")
	AddPhotoLayer(TargetSV.Panel, photoStack, stackView, w, h, "photo-1572635148818-ef6fd45eb394")
	
	RefreshAvatarLayerSizes
	StackEntries.Add(CreateMap("stack": photoStack, "stepPrimary": 18, "stepSecondary": 8, "animationMs": 220))
	
	Return TopOffset + h + 30dip
End Sub

Private Sub AddPhotoLayer(TargetSVPanel As B4XView, PStack As B4XDaisyStack, StackView As B4XView, StackWidth As Int, StackHeight As Int, BaseName As String)
	Dim avatar As B4XDaisyAvatar
	avatar.Initialize(Me, "")
	Dim avatarView As B4XView = avatar.AddToParent(StackView, 0, 0, StackWidth, StackHeight)
	avatar.SetImage(ResolvePhotoAsset(BaseName))
	avatar.SetRoundedBox(True)
	avatar.SetShowOnline(False)
	avatar.SetShadow("none")
	avatar.SetRingWidth(0)
	avatar.SetRingOffset(0)
	avatar.setWidth("100%")
	avatar.setHeight("100%")
	avatar.SetCenterOnParent(True)
	PStack.AddLayer(avatarView)
	AvatarLayers.Add(CreateMap("avatar": avatar, "view": avatarView))
End Sub

Private Sub RefreshAvatarLayerSizes
	If AvatarLayers.IsInitialized = False Then Return
	For Each entry As Map In AvatarLayers
		Dim avatar As B4XDaisyAvatar = entry.Get("avatar")
		Dim avatarView As B4XView = entry.Get("view")
		avatar.ResizeToParent(avatarView)
	Next
End Sub

Private Sub ResolvePhotoAsset(BaseName As String) As String
	Dim name As String = BaseName.Trim
	If name.Length = 0 Then Return "face21.jpg"
	If File.Exists(File.DirAssets, name) Then Return name
	If File.Exists(File.DirAssets, name & ".webp") Then Return name & ".webp"
	If File.Exists(File.DirAssets, name & ".jpg") Then Return name & ".jpg"
	If File.Exists(File.DirAssets, name & ".png") Then Return name & ".png"
	Return "face21.jpg"
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    If sv.IsInitialized Then
        sv.SetLayout(0, 0, Width, Height)
    End If
    RefreshAvatarLayerSizes
End Sub

