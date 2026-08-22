B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' Demo page for Easing Interpolator Playground.
' Showcases all 30 Penner Easing curves on an ImageView with live graph plotting.
' Inspired by https://github.com/MasayukiSuda/EasingInterpolator

#IgnoreWarnings:12,9

Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private pageScroll As B4XDaisyPageScroll
    Private pnlHost As B4XView

    ' Stage & Animation views
    Private pnlStage As B4XView
    Private pnlGraph As B4XView
    Private cvsGraph As B4XCanvas
    Private imgTarget As B4XView
    Private btnPlay As B4XDaisyButton
    Private lblEasingName As B4XView

    ' Animation State
    Private tAnim As Timer
    Private startTime As Long
    Private currentDuration As Int = 1200
    Private selectedEasing As String = "EaseOutBounce"
    Private isAnimating As Boolean = False
    Private animObj As B4XDaisyAnimation
    Private startX As Float
    Private endX As Float
    Private trackY As Float
    Private graphX As List
    Private graphY As List
End Sub

Public Sub Initialize As Object
    animObj.Initialize
    graphX.Initialize
    graphY.Initialize
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
    pnlHost = pageScroll.Panel

    RenderPage
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
    RenderPage
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Disappear
    StopAnimation
End Sub

Private Sub RenderPage
    If pnlHost.IsInitialized = False Then Return
    pageScroll.Clear
    StopAnimation

    Dim padding As Int = pageScroll.PagePadding
    Dim maxW As Int = pageScroll.UsableWidth
    Dim gap As Int = pageScroll.YGap
    Dim y As Int = padding

    ' 1. Interactive Stage Card
    y = pageScroll.AddSectionTitle("1. Interactive Easing Playground", y, False)
    
    Dim stageH As Int = 220dip
    pnlStage = xui.CreatePanel("")
    pnlStage.SetColorAndBorder(xui.Color_White, 0, 0, 12dip)
    pnlHost.AddView(pnlStage, padding, y, maxW, stageH)

    ' Graph canvas inside stage
    pnlGraph = xui.CreatePanel("")
    pnlStage.AddView(pnlGraph, 10dip, 10dip, maxW - 20dip, 140dip)
    cvsGraph.Initialize(pnlGraph)

    ' Easing name label
    Dim lName As Label
    lName.Initialize("")
    lblEasingName = lName
    lblEasingName.Text = "Selected: " & selectedEasing
    lblEasingName.TextColor = B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3B82F6)
    lblEasingName.TextSize = 14
    pnlStage.AddView(lblEasingName, 15dip, 155dip, maxW - 140dip, 25dip)

    ' Play Button
    btnPlay.Initialize(Me, "btnPlay")
    btnPlay.AddToParent(pnlStage, maxW - 120dip, 150dip, 105dip, 36dip)
    btnPlay.Text = "Play"
    btnPlay.Variant = "primary"
    btnPlay.Size = "sm"

    ' Target ImageView (animated icon)
    Dim iv As ImageView
    iv.Initialize("")
    imgTarget = iv
    imgTarget.SetColorAndBorder(B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3B82F6), 0, 0, 8dip)
    
    startX = 20dip
    endX = maxW - 20dip - 40dip
    trackY = 90dip
    pnlStage.AddView(imgTarget, startX, trackY, 40dip, 40dip)

    DrawGraphBackground

    y = y + stageH + gap

    ' 2. Easing Category Selectors
    y = pageScroll.AddSectionTitle("2. Select Easing Curve", y, False)

    Dim categories As List
    categories.Initialize2(Array As String( _
        "Bounce & Elastic", "Back (Overshoot)", "Expo & Circ", _
        "Quad & Cubic", "Quart & Quint", "Sine & Linear"))

    Dim easeGroups As List
    easeGroups.Initialize
    easeGroups.Add(Array As String("EaseOutBounce", "EaseInBounce", "EaseInOutBounce", "EaseOutElastic", "EaseInElastic", "EaseInOutElastic"))
    easeGroups.Add(Array As String("EaseOutBack", "EaseInBack", "EaseInOutBack"))
    easeGroups.Add(Array As String("EaseOutExpo", "EaseInExpo", "EaseInOutExpo", "EaseOutCirc", "EaseInCirc", "EaseInOutCirc"))
    easeGroups.Add(Array As String("EaseOutQuad", "EaseInQuad", "EaseInOutQuad", "EaseOutCubic", "EaseInCubic", "EaseInOutCubic"))
    easeGroups.Add(Array As String("EaseOutQuart", "EaseInQuart", "EaseInOutQuart", "EaseOutQuint", "EaseInQuint", "EaseInOutQuint"))
    easeGroups.Add(Array As String("EaseOutSine", "EaseInSine", "EaseInOutSine", "Linear"))

    Dim colW As Int = (maxW - 10dip) / 2

    For g = 0 To categories.Size - 1
        Dim catName As String = categories.Get(g)
        Dim items() As String = easeGroups.Get(g)
        
        Dim cardHeader As Label
        cardHeader.Initialize("")
        Dim xh As B4XView = cardHeader
        xh.Text = catName
        xh.TextColor = xui.Color_RGB(51, 65, 85)
        xh.TextSize = 13
        pnlHost.AddView(xh, padding, y, maxW, 20dip)
        y = y + 22dip

        For i = 0 To items.Length - 1
            Dim easeName As String = items(i)
            Dim colIdx As Int = i Mod 2
            Dim rowIdx As Int = i / 2
            Dim bx As Int = padding + colIdx * (colW + 10dip)
            Dim by As Int = y + rowIdx * 42dip

            Dim btnEase As B4XDaisyButton
            btnEase.Initialize(Me, "btnEase")
            btnEase.Tag = easeName
            btnEase.AddToParent(pnlHost, bx, by, colW, 36dip)
            btnEase.Text = easeName
            btnEase.Variant = "outline"
            btnEase.Size = "sm"
        Next
        y = y + ((items.Length + 1) / 2) * 42dip + 10dip
    Next

    pageScroll.AutoFit
End Sub

Private Sub DrawGraphBackground
    If pnlGraph.IsInitialized = False Then Return
    cvsGraph.ClearRect(cvsGraph.TargetRect)
    
    Dim gw As Float = pnlGraph.Width
    Dim gh As Float = pnlGraph.Height
    
    ' Draw grid lines
    Dim pGrid As B4XPath
    pGrid.Initialize(0, gh / 2)
    pGrid.LineTo(gw, gh / 2)
    cvsGraph.DrawPath(pGrid, xui.Color_RGB(241, 245, 249), False, 1dip)

    ' Start and end track line
    Dim pTrack As B4XPath
    pTrack.Initialize(10dip, gh - 20dip)
    pTrack.LineTo(gw - 10dip, gh - 20dip)
    cvsGraph.DrawPath(pTrack, xui.Color_RGB(226, 232, 240), False, 2dip)

    cvsGraph.Invalidate
End Sub

Private Sub btnPlay_Click
    StartAnimation(selectedEasing)
End Sub

Private Sub btnEase_Click (Value As Object)
    Dim btn As B4XDaisyButton = Sender
    If btn.IsInitialized Then
        selectedEasing = btn.Tag
        lblEasingName.Text = "Selected: " & selectedEasing
        StartAnimation(selectedEasing)
    Else If Value <> Null Then
        selectedEasing = Value
        lblEasingName.Text = "Selected: " & selectedEasing
        StartAnimation(selectedEasing)
    End If
End Sub

Private Sub StartAnimation(EaseName As String)
    StopAnimation
    graphX.Clear
    graphY.Clear
    DrawGraphBackground

    selectedEasing = EaseName
    lblEasingName.Text = "Selected: " & selectedEasing
    imgTarget.Left = startX
    startTime = DateTime.Now
    isAnimating = True

    If tAnim.IsInitialized = False Then
        tAnim.Initialize("tAnim", 16)
    End If
    tAnim.Enabled = True
End Sub

Private Sub StopAnimation
    If tAnim.IsInitialized Then tAnim.Enabled = False
    isAnimating = False
End Sub

Private Sub tAnim_Tick
    If isAnimating = False Then Return
    Try
        Dim elapsed As Long = DateTime.Now - startTime
        If elapsed >= currentDuration Then
            elapsed = currentDuration
            StopAnimation
        End If

        ' Compute interpolated progress using B4XDaisyAnimation.EvaluateEasing
        Dim val As Float = animObj.EvaluateEasing(selectedEasing, elapsed, 0, 1, currentDuration)
        If val <> val Or val > 1000000 Or val < -1000000 Then val = 0 ' NaN / Infinity guard

        ' Update target ImageView position
        Dim currentPos As Float = startX + val * (endX - startX)
        imgTarget.Left = currentPos

        ' Record point for graph plotting
        Dim gw As Float = pnlGraph.Width
        Dim gh As Float = pnlGraph.Height
        Dim px As Float = (elapsed / currentDuration) * (gw - 20dip) + 10dip
        Dim py As Float = (gh - 20dip) - val * (gh - 40dip)
        
        graphX.Add(px)
        graphY.Add(py)

        ' Draw live easing trail on graph
        If graphX.Size > 1 Then
            Dim pTrail As B4XPath
            Dim x0 As Float = graphX.Get(0)
            Dim y0 As Float = graphY.Get(0)
            pTrail.Initialize(x0, y0)
            For i = 1 To graphX.Size - 1
                Dim xi As Float = graphX.Get(i)
                Dim yi As Float = graphY.Get(i)
                pTrail.LineTo(xi, yi)
            Next
            cvsGraph.ClearRect(cvsGraph.TargetRect)
            DrawGraphBackground
            cvsGraph.DrawPath(pTrail, B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3B82F6), False, 3dip)
            cvsGraph.Invalidate
        End If
    Catch
        Log("tAnim_Tick error: " & LastException.Message)
    End Try
End Sub
