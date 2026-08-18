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
#IgnoreWarnings:12,9
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
    Private mCountdowns As List
    Private mCountdownTitles As List
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent
	mCountdowns.Initialize
	mCountdownTitles.Initialize
End Sub

Private Sub B4XPage_Appear
	If pnlHost.NumberOfViews = 0 Then
		Wait For (RenderExamples(Root.Width, Root.Height)) Complete  (Done As Boolean)
	Else
		If mCountdowns.IsInitialized Then
			For Each cd As B4XDaisyCountdown In mCountdowns
				cd.Start
			Next
		End If
	End If
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Disappear
	If mCountdowns.IsInitialized Then
		For Each cd As B4XDaisyCountdown In mCountdowns
			cd.Stop
		Next
	End If
End Sub

#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int) As ResumableSub
    If svHost.IsInitialized = False Then Return False
    pnlHost = svHost.Panel
    pnlHost.RemoveAllViews
    mCountdowns.Clear
    mCountdownTitles.Clear
    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim currentY As Int = PAGE_PAD

    ' Helper to add an auto countdown with shared settings
    currentY = AddAutoCountdown("dd:hh:mm:ss", currentY, maxW, 40dip, "dd:hh:mm:ss", "", "gap-2", "p-0", "md", "", "primary", True)
    currentY = AddAutoCountdown("hh:mm:ss", currentY, maxW, 40dip, "hh:mm:ss", "", "gap-2", "p-0", "md", "", "accent", True)
    currentY = AddAutoCountdown("dd:hh:mm", currentY, maxW, 40dip, "dd:hh:mm", "days|hours|minutes", "gap-2", "p-0", "md", "right", "info", True)
    currentY = AddAutoCountdown("dd:hh:mm:ss", currentY, maxW, 100dip, "dd:hh:mm:ss", "days|hours|minutes|seconds", "gap-2", "p-0", "md", "bottom",  "success", True)
    currentY = AddAutoCountdown("Countdown Shadows", currentY, maxW, 60dip, "dd:hh:mm:ss", "days|hours|minutes|seconds", "gap-2", "p-1", "md", "bottom", "neutral", False)
    currentY = AddAutoCountdown("Countdown to 2026-12-31", currentY, maxW, 60dip, "dd:hh:mm:ss", "days|hours|minutes|seconds", "gap-2", "p-0", "md", "bottom", "primary", False)
    ' Extra format examples
    currentY = AddAutoCountdown("Sprint timer mm:ss", currentY, maxW, 50dip, "mm:ss", "", "gap-2", "p-0", "md", "none", "accent", False)
    currentY = AddAutoCountdown("Hours:Minutes hh:mm", currentY, maxW, 50dip, "hh:mm", "", "gap-2", "p-0", "md", "none", "secondary", False)

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
    Return True
End Sub

Private Sub AddAutoCountdown(Title As String, Y As Int, Width As Int, Height As Int, Format As String, Labels As String, Gap As String, Padding As String, TextSize As String, LabelPos As String, Variant As String, Outline As Boolean) As Int
    Y = AddSectionTitle(Title, Y, Width)
    Dim cnt As B4XDaisyCountdown
    cnt.Initialize(Me, "")
    cnt.CountDownType = "auto"
    cnt.Format = Format
    cnt.Gap = Gap
    cnt.AutoWidth = True
    cnt.Padding = Padding
    cnt.TextSize = TextSize
    cnt.Variant = Variant
    cnt.Outline = Outline
    cnt.setTargetDate("2026-12-31")
    cnt.AutoStart = True
    If Labels <> "" Then cnt.Labels = Labels
    If LabelPos = "right" Or LabelPos = "bottom" Or LabelPos = "none" Then cnt.LabelPosition = LabelPos
    cnt.AddToParent(pnlHost, PAGE_PAD, Y, Width, Height)
    mCountdowns.Add(cnt)
    mCountdownTitles.Add(Title)
    Return Y + Height + 25dip
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

#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub
#End Region
