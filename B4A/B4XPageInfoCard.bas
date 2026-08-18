B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private PAGE_PAD As Int = 12dip
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the demo page class.
''' </summary>
Public Sub Initialize As Object
	Return Me
End Sub

''' <summary>
''' Called when the page is created.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent
	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders InfoCard examples (all 6 types, effects, count-up, variants, click).
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	' --- Type 1: icon-left, colored column (default) ---
	y = AddSectionTitle("Type 1 - Icon Left (colored column)", y, maxW)
	Dim ic1 As B4XDaisyInfoCard
	ic1.Initialize(Me, "ic")
	ic1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic1.InforType = "1"
	ic1.Icon = "user-solid.svg"
	ic1.IconColor = xui.Color_RGB(34, 197, 94)
	ic1.Title = "Employees"
	ic1.Value = "1000"
	ic1.Separator = ","
	ic1.Duration = 2
	ic1.Tag = ic1
	y = y + ic1.GetComputedHeight + 14dip

	' --- Type 2: icon-left, subtle tinted column ---
	y = AddSectionTitle("Type 2 - Icon Left (subtle column)", y, maxW)
	Dim ic2 As B4XDaisyInfoCard
	ic2.Initialize(Me, "ic")
	ic2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic2.InforType = "2"
	ic2.Icon = "bell-solid.svg"
	ic2.IconColor = xui.Color_RGB(59, 130, 246)
	ic2.Title = "Notifications"
	ic2.Value = "2500"
	ic2.Separator = ","
	ic2.Tag = ic2
	y = y + ic2.GetComputedHeight + 14dip

	' --- Type 3: icon-left, no column ---
	y = AddSectionTitle("Type 3 - Icon Left (no column)", y, maxW)
	Dim ic3 As B4XDaisyInfoCard
	ic3.Initialize(Me, "ic")
	ic3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic3.InforType = "3"
	ic3.Icon = "envelope-solid.svg"
	ic3.IconColor = xui.Color_RGB(168, 85, 247)
	ic3.Title = "Messages"
	ic3.Value = "8420"
	ic3.Separator = ","
	ic3.Tag = ic3
	y = y + ic3.GetComputedHeight + 14dip

	' --- Type 4: watermark icon (faint) bottom-right ---
	y = AddSectionTitle("Type 4 - Watermark (faint)", y, maxW)
	Dim ic4 As B4XDaisyInfoCard
	ic4.Initialize(Me, "ic")
	ic4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic4.InforType = "4"
	ic4.Icon = "eye-solid.svg"
	ic4.Title = "Page Views"
	ic4.Value = "38200"
	ic4.Separator = ","
	ic4.Tag = ic4
	y = y + ic4.GetComputedHeight + 14dip

	' --- Type 5: watermark icon (colored) bottom-right ---
	y = AddSectionTitle("Type 5 - Watermark (colored)", y, maxW)
	Dim ic5 As B4XDaisyInfoCard
	ic5.Initialize(Me, "ic")
	ic5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic5.InforType = "5"
	ic5.Icon = "heart-solid.svg"
	ic5.IconColor = xui.Color_RGB(244, 63, 94)
	ic5.Title = "Total Likes"
	ic5.Value = "12345"
	ic5.Separator = ","
	ic5.Tag = ic5
	y = y + ic5.GetComputedHeight + 14dip

	' --- Count-up with prefix / suffix / decimals ---
	y = AddSectionTitle("Count-Up (prefix, suffix, decimals)", y, maxW)
	Dim ic7 As B4XDaisyInfoCard
	ic7.Initialize(Me, "ic")
	ic7.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic7.InforType = "1"
	ic7.Icon = "arrow-up-solid.svg"
	ic7.Variant = "success"
	ic7.Title = "Conversion Rate"
	ic7.Value = "48.75"
	ic7.Prefix = ""
	ic7.Suffix = "%"
	ic7.DecimalPlaces = 2
	ic7.UseGrouping = False
	ic7.Duration = 3
	ic7.Tag = ic7
	y = y + ic7.GetComputedHeight + 14dip

	' --- Value with prefix ($) ---
	y = AddSectionTitle("Value with Prefix ($)", y, maxW)
	Dim ic12 As B4XDaisyInfoCard
	ic12.Initialize(Me, "ic")
	ic12.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic12.InforType = "1"
	ic12.Icon = "arrow-up-solid.svg"
	ic12.Variant = "success"
	ic12.Title = "Total Revenue"
	ic12.Value = "45678"
	ic12.Prefix = "$"
	ic12.Separator = ","
	ic12.Tag = ic12
	y = y + ic12.GetComputedHeight + 14dip

	' --- Variant colors ---
	y = AddSectionTitle("Variant Colors", y, maxW)
	Dim ic8 As B4XDaisyInfoCard
	ic8.Initialize(Me, "ic")
	ic8.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic8.InforType = "1"
	ic8.Icon = "arrow-up-solid.svg"
	ic8.Variant = "primary"
	ic8.Title = "New Sign-ups"
	ic8.Value = "560"
	ic8.Tag = ic8
	y = y + ic8.GetComputedHeight + 12dip

	Dim ic9 As B4XDaisyInfoCard
	ic9.Initialize(Me, "ic")
	ic9.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic9.InforType = "1"
	ic9.Icon = "arrow-down-solid.svg"
	ic9.Variant = "error"
	ic9.Title = "Refunds"
	ic9.Value = "12"
	ic9.Tag = ic9
	y = y + ic9.GetComputedHeight + 14dip

	' --- Effects ---
	y = AddSectionTitle("Effect - Hover Zoom (press)", y, maxW)
	Dim ic10 As B4XDaisyInfoCard
	ic10.Initialize(Me, "ic")
	ic10.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic10.InforType = "1"
	ic10.Icon = "gear.svg"
	ic10.IconColor = xui.Color_RGB(234, 179, 8)
	ic10.Title = "Settings"
	ic10.Value = "9"
	ic10.Effect = "hover-zoom"
	ic10.Tag = ic10
	y = y + ic10.GetComputedHeight + 12dip

	y = AddSectionTitle("Effect - Hover Expand (press)", y, maxW)
	Dim ic11 As B4XDaisyInfoCard
	ic11.Initialize(Me, "ic")
	ic11.AddToParent(pnlHost, PAGE_PAD, y, maxW, 80dip)
	ic11.InforType = "1"
	ic11.Icon = "plus-solid.svg"
	ic11.IconColor = xui.Color_RGB(34, 197, 94)
	ic11.Title = "New Tasks"
	ic11.Value = "37"
	ic11.Effect = "hover-expand"
	ic11.Tag = ic11
	y = y + ic11.GetComputedHeight + 16dip

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Spawns a stylized section header for the demo page.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
	Dim title As B4XDaisyText
	title.Initialize(Me, "lblTitle")
	title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
	title.Text = Text
	title.TextColor = xui.Color_RGB(30, 41, 59)
	title.TextSize = 14
	title.FontBold = True
	Return Y + 32dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

' Shared click handler for all InfoCard examples (they all use EventName "ic").
' Tapping a card shows a global alert toast and re-runs the count-up animation.
Private Sub ic_Click(Tag As Object)
	If Tag Is B4XDaisyInfoCard Then
		Dim r As B4XDaisyInfoCard = Tag
		B4XPages.MainPage.ShowToastAlert("Info Card", r.Title & " - " & r.Value, "info", 2000, "top-center")
		r.StartAnimation
	End If
End Sub
#End Region
