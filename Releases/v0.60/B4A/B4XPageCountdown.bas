B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XPageCountdown.bas
#Region Events
#End Region

#Region Variables
#IgnoreWarnings:12
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
    
    ' Timer for auto-counting
    Private timer1 As Timer
    Private seconds As Int = 59
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Countdown")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent
    
    timer1.Initialize("timer1", 1000)
    timer1.Enabled = True
End Sub

Private Sub B4XPage_Appear
	If pnlHost.NumberOfViews = 0 Then
		Wait For (RenderExamples(Root.Width, Root.Height)) Complete  (Done As Boolean)
	End If
    timer1.Enabled = True
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Disappear
    timer1.Enabled = False
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int) As ResumableSub
    If svHost.IsInitialized = False Then Return False
    pnlHost = svHost.Panel
    pnlHost.RemoveAllViews
    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim currentY As Int = PAGE_PAD
    
    ' #region Example 1: Basic
    currentY = AddSectionTitle("Basic", currentY, maxW)
    Dim cnt1 As B4XDaisyCountdown
    cnt1.Initialize(Me, "cnt1")
    cnt1.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 40dip)
    
    Dim itm1 As B4XDaisyCountdownItem
    itm1.Initialize(Me, "itm1")
    itm1.Value = seconds
    itm1.Tag = "sec1" 
    cnt1.AddItem(itm1)
    
    currentY = currentY + 60dip
    ' #endregion
    
    ' #region Example 2: Large text with 2 digits
    currentY = AddSectionTitle("Large text with 2 digits", currentY, maxW)
    Dim cnt2 As B4XDaisyCountdown
    cnt2.Initialize(Me, "cnt2")
    cnt2.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim itm2 As B4XDaisyCountdownItem
    itm2.Initialize(Me, "itm2")
    itm2.Value = seconds
    itm2.Digits = 2
    itm2.TextSize = "text-6xl"
    itm2.Tag = "sec2"
    cnt2.AddItem(itm2)
    
    currentY = currentY + 100dip
    ' #endregion
    
    ' #region Example 3: Clock countdown
    currentY = AddSectionTitle("Clock countdown", currentY, maxW)
    Dim cnt3 As B4XDaisyCountdown
    cnt3.Initialize(Me, "cnt3")
    cnt3.Gap = "gap-2"
    cnt3.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 50dip)
    
    Dim itmH3 As B4XDaisyCountdownItem
    itmH3.Initialize(Me, "")
    itmH3.Value = 10
    itmH3.Label = "h"
    cnt3.AddItem(itmH3)
    
    Dim itmM3 As B4XDaisyCountdownItem
    itmM3.Initialize(Me, "")
    itmM3.Value = 24
    itmM3.Label = "m"
    cnt3.AddItem(itmM3)
    
    Dim itmS3 As B4XDaisyCountdownItem
    itmS3.Initialize(Me, "itmS3")
    itmS3.Value = seconds
    itmS3.Label = "s"
    itmS3.Tag = "sec3"
    cnt3.AddItem(itmS3)
    
    currentY = currentY + 70dip
    ' #endregion
    
    ' #region Example 4: Clock countdown with colons
    currentY = AddSectionTitle("Clock countdown with colons", currentY, maxW)
    Dim cnt4 As B4XDaisyCountdown
    cnt4.Initialize(Me, "cnt4")
    cnt4.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 50dip)
    
    Dim itmH4 As B4XDaisyCountdownItem
    itmH4.Initialize(Me, "")
    itmH4.Value = 10
    itmH4.Separator = ":"
    cnt4.AddItem(itmH4)
    
    Dim itmM4 As B4XDaisyCountdownItem
    itmM4.Initialize(Me, "")
    itmM4.Value = 24
    itmM4.Digits = 2
    itmM4.Separator = ":"
    cnt4.AddItem(itmM4)
    
    Dim itmS4 As B4XDaisyCountdownItem
    itmS4.Initialize(Me, "itmS4")
    itmS4.Value = seconds
    itmS4.Digits = 2
    itmS4.Tag = "sec4"
    cnt4.AddItem(itmS4)
    
    currentY = currentY + 70dip
    ' #endregion
    
    ' #region Example 5: Large text with labels (corrected)
    currentY = AddSectionTitle("Large text with labels", currentY, maxW)
    Dim cnt5 As B4XDaisyCountdown
    cnt5.Initialize(Me, "cnt5")
    cnt5.AddToParent(pnlHost, 0, currentY, maxW, 80dip)
    cnt5.Padding = "p-1"        ' no padding around the segments
    cnt5.Gap = "gap-0"          ' segments touch

    Dim texts5() As String = Array As String("days", "hours", "min", "sec")
    Dim vals5() As Int = Array As Int(15, 10, 24, seconds)
    ' add only first three items
    For i = 0 To 3
        Dim itm As B4XDaisyCountdownItem
        itm.Initialize(Me, "")
        itm.Value = vals5(i)
        itm.Label = texts5(i)
        itm.TextSize = "text-md"
        If i = 3 Then itm.Tag = "sec5"
        cnt5.AddItem(itm)
    Next

    currentY = currentY + 100dip
    ' #endregion

    ' #region Example 6: Large text with labels under (single countdown)
    currentY = AddSectionTitle("Large text with labels under", currentY, maxW)
    Dim cnt6 As B4XDaisyCountdown
    cnt6.Initialize(Me, "cnt6")
    cnt6.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 100dip)
    cnt6.Padding = "p-1"
    cnt6.Gap = "gap-0"
    
    Dim texts6() As String = Array As String("days", "hours", "min", "sec")
    Dim vals6() As Int = Array As Int(15, 10, 24, seconds)
    For i = 0 To 3
        Dim itm As B4XDaisyCountdownItem
        itm.Initialize(Me, "")
        itm.Value = vals6(i)
        itm.Label = texts6(i)
        itm.LabelPosition = "BOTTOM"
        itm.TextSize = "text-md"
        If i = 3 Then itm.Tag = "sec6"
        cnt6.AddItem(itm)
    Next
    
    currentY = currentY + 120dip
    ' #endregion

    ' #region Example 7: In boxes with Shadows
    currentY = AddSectionTitle("In boxes with Shadows", currentY, maxW)
    Dim cnt7 As B4XDaisyCountdown
    cnt7.Initialize(Me, "cnt7")
    cnt7.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 120dip)
    cnt7.Padding = "p-1"     
    cnt7.Gap = "gap-2"
    cnt7.Rounded = "rounded-lg"
    
    Dim texts7() As String = Array As String("days", "hours", "min", "sec")
    Dim vals7() As Int = Array As Int(15, 10, 24, seconds)
    For i = 0 To 3
        Dim itm As B4XDaisyCountdownItem
        itm.Initialize(Me, "")
        itm.Value = vals7(i)
        itm.Digits = 2
        itm.Label = texts7(i)
        itm.LabelPosition = "BOTTOM"
        itm.TextSize = "text-md"
        itm.Variant = "neutral"
        ' rounded and shadow are now propagated from cnt7
        If i = 3 Then itm.Tag = "sec7"
        cnt7.AddItem(itm)
    Next

    currentY = currentY + 150dip
    ' #endregion

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
    Return True
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim l As B4XDaisyText
    l.Initialize(Me, "")
    l.AddToParent(pnlHost, PAGE_PAD, Y, Width, 30dip)
    l.Text = Text
    l.TextColor = xui.Color_RGB(30, 41, 59)
    l.TextSize = 18
    Return Y + l.GetComputedHeight + 10dip
End Sub

Private Sub timer1_Tick
    seconds = seconds - 1
    If seconds < 0 Then seconds = 59
    UpdateSeconds(pnlHost)
End Sub

Private Sub UpdateSeconds(Parent As B4XView)
    For Each v As B4XView In Parent.GetAllViewsRecursive
        ' Check if Tag is B4XDaisyCountdownItem class
        If B4XDaisyVariants.IsClass(v.Tag, "B4XDaisyCountdownItem") Then
            Dim itm As B4XDaisyCountdownItem = v.Tag
            Dim tg As String = ""
            If itm.Tag <> Null Then tg = itm.Tag
            If tg.StartsWith("sec") Then
                itm.Value = seconds
            End If
        End If
    Next
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub
#End Region