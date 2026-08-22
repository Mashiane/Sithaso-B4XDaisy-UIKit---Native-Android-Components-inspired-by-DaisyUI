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
	
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView
	
	' Demo progress bars
	Private pAnim As B4XDaisyProgress
	Private pInline As B4XDaisyProgress
	Private pVolume As B4XDaisyProgress
	Private pVolumeInline As B4XDaisyProgress
	Private pTransient As B4XDaisyProgress
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel
	
	RenderExamples
End Sub

Private Sub RenderExamples
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear
	
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim currentY As Int = padding
	
	'Header
	Dim lblHeader As B4XDaisyText
	lblHeader.Initialize(Me, "")
	lblHeader.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	lblHeader.Text = "Progress Bar Components"
	lblHeader.TextSize = "text-lg"
	lblHeader.FontBold = True
	currentY = currentY + lblHeader.GetComputedHeight + gap

	'--- Example 1 ---
	currentY = pageScroll.AddSectionTitle("Progress (Default Neutral)", currentY, False)
	Dim vals() As Int = Array As Int(0, 10, 40, 70, 100)
	For i = 0 To vals.Length - 1
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(pnlHost, padding, currentY, maxW, 8dip)
		p.Value = vals(i)
		currentY = currentY + 8dip + gap
	Next
	currentY = currentY + gap
	
	'--- Example 2 ---
	currentY = pageScroll.AddSectionTitle("Progress (Primary)", currentY, False)
	For i = 0 To vals.Length - 1
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(pnlHost, padding, currentY, maxW, 8dip)
		p.Variant = "primary"
		p.Value = vals(i)
		currentY = currentY + 8dip + gap
	Next
	currentY = currentY + gap
	
	'--- Example Colors ---
	currentY = pageScroll.AddSectionTitle("Progress Colors", currentY, False)
	Dim colorKeys() As String = Array As String("secondary", "accent", "info", "success", "warning", "error")
	For Each c As String In colorKeys
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(pnlHost, padding, currentY, maxW, 8dip)
		p.Variant = c
		p.Value = 65
		currentY = currentY + 8dip + gap
	Next
	currentY = currentY + gap

	'--- Sizes ---
	currentY = pageScroll.AddSectionTitle("Progress Sizes (with Tooltips)", currentY, False)
	Dim sizes() As String = Array As String("xs", "sm", "md", "lg", "xl")
	For i = 0 To sizes.Length - 1
		Dim s As String = sizes(i)
		Dim p As B4XDaisyProgress
		p.Initialize(Me, "")
		p.AddToParent(pnlHost, padding, currentY, maxW, 20dip)
		p.Size = s
		p.Value = 20 + (i * 15) ' staggered values: 20%, 35%, 50%, 65%, 80%
		p.ShowTooltip = True
		currentY = currentY + p.GetComputedHeight + 24dip ' Large vertical gap for tooltips
	Next
	currentY = currentY + gap

	'--- Animation & Tooltip ---
	currentY = pageScroll.AddSectionTitle("Animated with Tooltip", currentY, False)
	pAnim.Initialize(Me, "pAnim")
	pAnim.AddToParent(pnlHost, padding, currentY, maxW, 12dip)
	pAnim.Variant = "primary"
	pAnim.ShowTooltip = True
	pAnim.Animated = True
	pAnim.Duration = 3000
	pAnim.Value = 20
	currentY = currentY + pAnim.GetComputedHeight + 24dip
	
	Dim btnStart As B4XDaisyButton
	btnStart.Initialize(Me, "btnStart")
	btnStart.Text = "Animate to 85%"
	btnStart.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 40dip + gap
	
	Dim btnAnimate10 As B4XDaisyButton
	btnAnimate10.Initialize(Me, "btnAnimate10")
	btnAnimate10.Text = "Animate to 10%"
	btnAnimate10.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 40dip + gap
	
	Dim btnTimer As B4XDaisyButton
	btnTimer.Initialize(Me, "btnTimer")
	btnTimer.Text = "Start 5s Countdown"
	btnTimer.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 40dip + gap
	
	Dim btnReset As B4XDaisyButton
	btnReset.Initialize(Me, "btnReset")
	btnReset.Text = "Reset (Max 100)"
	btnReset.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 40dip + gap

	'--- Transient Tooltip (TooltipOpen = False) ---
	currentY = pageScroll.AddSectionTitle("Animated with Transient Tooltip", currentY, False)
	pTransient.Initialize(Me, "pTransient")
	pTransient.AddToParent(pnlHost, padding, currentY, maxW, 12dip)
	pTransient.Variant = "secondary"
	pTransient.ShowTooltip = True
	pTransient.TooltipOpen = False	' tooltip fades in on change, then fades out
	pTransient.Animated = True
	pTransient.Duration = 2000
	pTransient.Value = 40
	currentY = currentY + pTransient.GetComputedHeight + 8dip
	
	Dim btnTransientUp As B4XDaisyButton
	btnTransientUp.Initialize(Me, "btnTransientUp")
	btnTransientUp.Text = "Set to 75%"
	btnTransientUp.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 40dip + gap
	
	Dim btnTransientDown As B4XDaisyButton
	btnTransientDown.Initialize(Me, "btnTransientDown")
	btnTransientDown.Text = "Set to 20%"
	btnTransientDown.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 40dip + gap
	
	'--- Example 6: Inline Numbers ---
	currentY = pageScroll.AddSectionTitle("Progress Inline Numbers (NumberProgressBar Style)", currentY, False)
	pInline.Initialize(Me, "pInline")
	pInline.AddToParent(pnlHost, padding, currentY, maxW, 20dip)
	pInline.Variant = "primary"
	pInline.ShowNumberInline = True
	pInline.Animated = True
	pInline.Duration = 3000
	pInline.Value = 35
	currentY = currentY + pInline.GetComputedHeight + gap

	' Add buttons to animate it
	Dim btnAnimateInline As B4XDaisyButton
	btnAnimateInline.Initialize(Me, "btnAnimateInline")
	btnAnimateInline.Text = "Animate Inline to 90%"
	btnAnimateInline.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 50dip

	Dim btnAnimateInlineZero As B4XDaisyButton
	btnAnimateInlineZero.Initialize(Me, "btnAnimateInlineZero")
	btnAnimateInlineZero.Text = "Animate Inline to 0%"
	btnAnimateInlineZero.AddToParent(pnlHost, padding, currentY, maxW, 40dip)
	currentY = currentY + 70dip

	'--- Example 7: Inline Progress Sizes ---
	currentY = pageScroll.AddSectionTitle("Inline Progress Sizes (xs to xl)", currentY, False)
	Dim inlineSizes() As String = Array As String("xs", "sm", "md", "lg", "xl")
	For i = 0 To inlineSizes.Length - 1
		Dim s As String = inlineSizes(i)
		
		Dim pSize As B4XDaisyProgress
		pSize.Initialize(Me, "")
		pSize.AddToParent(pnlHost, padding, currentY, maxW, 20dip)
		pSize.Size = s
		pSize.ShowNumberInline = True
		pSize.LabelAbove = "Size: " & s.ToUpperCase
		pSize.LabelVisible = True
		pSize.Value = 20 + (i * 15)
		currentY = currentY + pSize.GetComputedHeight + gap
	Next
	currentY = currentY + 20dip

	'--- Example 8: Interactive Volume/Indicator Bars ---
	currentY = pageScroll.AddSectionTitle("Volume Controllers (Tapping Icons Decrements/Increments)", currentY, False)
	
	' Standard Volume Bar
	pVolume.Initialize(Me, "pVolume")
	pVolume.AddToParent(pnlHost, padding, currentY + 12dip, maxW, 24dip)
	pVolume.IconLeft = "volume-low-solid-full.svg"
	pVolume.IconRight = "volume-high-solid-full.svg"
	pVolume.MinValue = 0
	pVolume.setMaxValue(100)
	pVolume.StepValue = 10
	pVolume.Animated = True
	pVolume.Duration = 250
	pVolume.ShowTooltip = True
	pVolume.TooltipOpen = False
	pVolume.Value = 50
	pVolume.Variant = "primary"
	currentY = currentY + pVolume.GetComputedHeight + gap + 16dip
	
	' Inline Volume Bar
	pVolumeInline.Initialize(Me, "pVolumeInline")
	pVolumeInline.AddToParent(pnlHost, padding, currentY + 12dip, maxW, 28dip)
	pVolumeInline.IconLeft = "volume-low-solid-full.svg"
	pVolumeInline.IconRight = "volume-high-solid-full.svg"
	pVolumeInline.MinValue = 0
	pVolumeInline.setMaxValue(100)
	pVolumeInline.StepValue = 5
	pVolumeInline.Animated = True
	pVolumeInline.Duration = 200
	pVolumeInline.ShowNumberInline = True
	pVolumeInline.ShowTooltip = True
	pVolumeInline.TooltipOpen = False
	pVolumeInline.Value = 30
	pVolumeInline.Variant = "secondary"
	currentY = currentY + pVolumeInline.GetComputedHeight + gap + 16dip
	
	pageScroll.AutoFit
End Sub

Private Sub btnStart_Click(Tag As Object)
	pAnim.Duration = 3000
	pAnim.Value = 85
End Sub

Private Sub btnAnimate10_Click(Tag As Object)
	pAnim.Duration = 2000
	pAnim.Value = 10
End Sub

Private Sub btnTimer_Click(Tag As Object)
	pAnim.StartTimer(5000)
End Sub

Private Sub btnReset_Click(Tag As Object)
	pAnim.setMaxValue(100)
	pAnim.Duration = 500
	pAnim.Value = 0
End Sub

Private Sub btnAnimateInline_Click(Tag As Object)
	pInline.Duration = 3000
	pInline.Value = 90
End Sub

Private Sub btnAnimateInlineZero_Click(Tag As Object)
	pInline.Duration = 2000
	pInline.Value = 0
End Sub

Private Sub btnTransientUp_Click(Tag As Object)
	pTransient.Duration = 2000
	pTransient.Value = 75
End Sub

Private Sub btnTransientDown_Click(Tag As Object)
	pTransient.Duration = 1500
	pTransient.Value = 20
End Sub

Private Sub B4XPage_Disappear
	If pAnim.IsInitialized Then pAnim.StopAnimation
	If pInline.IsInitialized Then pInline.StopAnimation
	If pVolume.IsInitialized Then pVolume.StopAnimation
	If pVolumeInline.IsInitialized Then pVolumeInline.StopAnimation
	If pTransient.IsInitialized Then pTransient.StopAnimation
End Sub

Private Sub pVolume_Changed (Value As Float)
	Log("pVolume Changed: " & Value)
End Sub

Private Sub pVolumeInline_Changed (Value As Float)
	Log("pVolumeInline Changed: " & Value)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height)
		RenderExamples
	End If
End Sub


Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
