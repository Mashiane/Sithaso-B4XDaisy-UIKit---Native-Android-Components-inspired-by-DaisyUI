B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XPageStat.bas
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
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the page.
''' </summary>
Public Sub Initialize As Object
    Return Me
End Sub

''' <summary>
''' Called when the page is created.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Stat")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

End Sub

Private Sub B4XPage_Appear
	If pnlHost.NumberOfViews = 0 Then
		Wait For (RenderExamples(Root.Width, Root.Height)) Complete  (Done As Boolean)
	End If
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Rendering
''' <summary>
''' Builds all stat demo examples. Each horizontal .stats component is hosted inside a
''' HorizontalScrollView matching the CSS overflow-x-auto behaviour � the stat expands to
''' its natural fit-content width and scrolls if it exceeds the available page width.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int) As ResumableSub
    If svHost.IsInitialized = False Then Return False
    pnlHost = svHost.Panel
    pnlHost.RemoveAllViews
    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim currentY As Int = PAGE_PAD
    
    ' #region Example 1: Stat (Basic) � single item, horizontal
    ''' Demonstrates the minimal stat: one item with title, value and description.
    currentY = AddSectionTitle("Stat (Basic)", currentY, maxW)
    Dim sv1 As HorizontalScrollView
    sv1.Initialize(0, "")
    pnlHost.AddView(sv1, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats1 As B4XDaisyStat
    stats1.Initialize(Me, "")
    stats1.AddToParent(sv1.Panel, 0, 0, 1dip, 1dip)
    
    Dim item1 As B4XDaisyStatItem
    item1.Initialize(Me, "component")
    item1.Title = "Total Page Views"
    item1.Value = "89,400"
    item1.Description = "21% more than last month"
    stats1.AddItem(item1)
    stats1.Refresh
    
    sv1.Panel.Width = Max(stats1.ContentWidth, maxW)
    Dim h1 As Int = stats1.ContentHeight
    sv1.Width = maxW : sv1.Height = h1
    currentY = currentY + h1 + 12dip
    Sleep(0)
    ' #endregion
    
    ' #region Example 2: Stat with icons or image � three items, each with a figure icon
    ''' Demonstrates stat-figure slot with three horizontally laid-out items. The combined
    ''' content is typically wider than the screen, so the HorizontalScrollView allows
    ''' the user to scroll right � matching the CSS overflow-x-auto on .stats.
    currentY = AddSectionTitle("Stat with icons or image", currentY, maxW)
    Dim sv2 As HorizontalScrollView
    sv2.Initialize(0, "")
    pnlHost.AddView(sv2, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats2 As B4XDaisyStat
    stats2.Initialize(Me, "")
    stats2.AddToParent(sv2.Panel, 0, 0, 1dip, 1dip)
    
    ''' Item 1: heart icon + Total Likes metric.
    Dim item2_1 As B4XDaisyStatItem
    item2_1.Initialize(Me, "component")
    item2_1.Title = "Total Likes"
    item2_1.Value = "25.6K"
    item2_1.Description = "21% more than last month"
    item2_1.FigureType = "svg"
    item2_1.FigureSource = "heart.svg"
    item2_1.FigureColor = "error"
    stats2.AddItem(item2_1)
    
    ''' Item 2: bolt icon + Page Views metric.
    Dim item2_2 As B4XDaisyStatItem
    item2_2.Initialize(Me, "component")
    item2_2.Title = "Page Views"
    item2_2.Value = "2.6M"
    item2_2.Description = "21% more than last month"
    item2_2.FigureType = "svg"
    item2_2.FigureSource = "stat_bolt.svg"
    item2_2.FigureColor = "info"
    stats2.AddItem(item2_2)
    
    ''' Item 3: check icon + Tasks Done metric.
    Dim item2_3 As B4XDaisyStatItem
    item2_3.Initialize(Me, "component")
    item2_3.Title = "Tasks Done"
    item2_3.Value = "86%"
    item2_3.Description = "31 tasks remaining"
    item2_3.FigureType = "svg"
    item2_3.FigureSource = "check.svg"
    item2_3.FigureColor = "success"
    stats2.AddItem(item2_3)
    
    stats2.Refresh
    
    sv2.Panel.Width = Max(stats2.ContentWidth, maxW)
    Dim h2 As Int = stats2.ContentHeight
    sv2.Width = maxW : sv2.Height = h2
    currentY = currentY + h2 + 12dip
    Sleep(0)
    ' #endregion
    
    ' #region Example 3: Centered items � two items with center-aligned content
    ''' Demonstrates CenterItems=True: title, value and description are all centred
    ''' inside each stat cell.
    currentY = AddSectionTitle("Centered items", currentY, maxW)
    Dim sv3 As HorizontalScrollView
    sv3.Initialize(0, "")
    pnlHost.AddView(sv3, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats3 As B4XDaisyStat
    stats3.Initialize(Me, "")
    stats3.AddToParent(sv3.Panel, 0, 0, 1dip, 1dip)
    
    Dim item3_1 As B4XDaisyStatItem
    item3_1.Initialize(Me, "component")
    item3_1.CenterItems = True
    item3_1.Title = "Downloads"
    item3_1.Value = "31K"
    item3_1.Description = "From Jan 1st to Feb 1st"
    stats3.AddItem(item3_1)
    
    Dim item3_2 As B4XDaisyStatItem
    item3_2.Initialize(Me, "component")
    item3_2.CenterItems = True
    item3_2.Title = "Users"
    item3_2.Value = "4,200"
    item3_2.Description = "?? 40 (2%)"
    stats3.AddItem(item3_2)
    
    stats3.Refresh
    
    sv3.Panel.Width = Max(stats3.ContentWidth, maxW)
    Dim h3 As Int = stats3.ContentHeight
    sv3.Width = maxW : sv3.Height = h3
    currentY = currentY + h3 + 12dip
    ' #endregion
    
    ' #region Example 4: Vertical � stats stacked top-to-bottom with bottom-edge separators
    ''' Demonstrates stats-vertical: items flow in a column. Each item (except the last)
    ''' shows a dashed bottom border (border-block-end) per CSS.
    currentY = AddSectionTitle("Vertical", currentY, maxW)
    Dim stats4 As B4XDaisyStat
    stats4.Initialize(Me, "")
    stats4.Orientation = "vertical"
    stats4.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 1dip)
    
    Dim item4_1 As B4XDaisyStatItem
    item4_1.Initialize(Me, "component")
    item4_1.Title = "Downloads"
    item4_1.Value = "31K"
    item4_1.Description = "Jan 1st - Feb 1st"
    stats4.AddItem(item4_1)
    
    Dim item4_2 As B4XDaisyStatItem
    item4_2.Initialize(Me, "component")
    item4_2.Title = "New Users"
    item4_2.Value = "4,200"
    item4_2.Description = "?? 400 (22%)"
    stats4.AddItem(item4_2)
    
    stats4.Refresh
    
    currentY = currentY + stats4.ContentHeight + 12dip
    Sleep(0)
    ' #endregion
    
    ' #region Example 4b: Colored variants � Variant sets bg + text, ValueColor overrides value text
    ''' Demonstrates Variant property: background color + all text become the variant's
    ''' content color. ValueColor can still override just the value label independently.
    currentY = AddSectionTitle("Colored variants", currentY, maxW)
    Dim sv4b As HorizontalScrollView
    sv4b.Initialize(0, "")
    pnlHost.AddView(sv4b, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats4b As B4XDaisyStat
    stats4b.Initialize(Me, "")
    stats4b.AddToParent(sv4b.Panel, 0, 0, 1dip, 1dip)
    
    ''' Item 1: Primary variant � bg + all text colored.
    Dim item4b_1 As B4XDaisyStatItem
    item4b_1.Initialize(Me, "component")
    item4b_1.Title = "Revenue"
    item4b_1.Value = "$12.4K"
    item4b_1.Description = "This quarter"
    item4b_1.Variant = "primary"
    stats4b.AddItem(item4b_1)
    
    ''' Item 2: Secondary variant.
    Dim item4b_2 As B4XDaisyStatItem
    item4b_2.Initialize(Me, "component")
    item4b_2.Title = "Signups"
    item4b_2.Value = "890"
    item4b_2.Description = "Last 7 days"
    item4b_2.Variant = "secondary"
    stats4b.AddItem(item4b_2)
    
    ''' Item 3: Accent variant.
    Dim item4b_3 As B4XDaisyStatItem
    item4b_3.Initialize(Me, "component")
    item4b_3.Title = "Bounce Rate"
    item4b_3.Value = "14%"
    item4b_3.Description = "Improved by 3%"
    item4b_3.Variant = "accent"
    stats4b.AddItem(item4b_3)
    
    stats4b.Refresh
    
    sv4b.Panel.Width = Max(stats4b.ContentWidth, maxW)
    Dim h4b As Int = stats4b.ContentHeight
    sv4b.Width = maxW : sv4b.Height = h4b
    currentY = currentY + h4b + 12dip
    Sleep(0)
    ' #endregion
    
    ' #region Example 5: With action button
    ''' Demonstrates stat-actions slot: an Add funds button appears below the value.
    currentY = AddSectionTitle("With action button", currentY, maxW)
    Dim sv5 As HorizontalScrollView
    sv5.Initialize(0, "")
    pnlHost.AddView(sv5, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats5 As B4XDaisyStat
    stats5.Initialize(Me, "")
    stats5.AddToParent(sv5.Panel, 0, 0, 1dip, 1dip)
    
    Dim item5_1 As B4XDaisyStatItem
    item5_1.Initialize(Me, "component")
    item5_1.Title = "Account balance"
    item5_1.Value = "$89,400"
    Dim btn1 As B4XDaisyButton
    btn1.Initialize(Me, "component")
    btn1.Text = "Add funds"
    btn1.Variant = "success"
    btn1.Size = "xs"
    item5_1.AddAction(btn1)
    stats5.AddItem(item5_1)
    
    stats5.Refresh
    
    sv5.Panel.Width = Max(stats5.ContentWidth, maxW)
    Dim h5 As Int = stats5.ContentHeight
    sv5.Width = maxW : sv5.Height = h5
    currentY = currentY + h5 + 12dip
    ' #endregion
    
    ' #region Example 6: With radial progress figure
    ''' Demonstrates stat-figure slot with a B4XDaisyRadialProgress as the figure icon.
    currentY = AddSectionTitle("With radial progress", currentY, maxW)
    Dim sv6 As HorizontalScrollView
    sv6.Initialize(0, "")
    pnlHost.AddView(sv6, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats6 As B4XDaisyStat
    stats6.Initialize(Me, "")
    stats6.AddToParent(sv6.Panel, 0, 0, 1dip, 1dip)
    
    Dim item6_1 As B4XDaisyStatItem
    item6_1.Initialize(Me, "component")
    item6_1.Title = "Tasks Done"
    item6_1.Value = "86%"
    item6_1.Description = "31 remaining"
    item6_1.ValueColor = "primary"
    item6_1.FigureType = "radial"
    item6_1.FigureSource = "86"
    item6_1.FigureColor = "primary"
    stats6.AddItem(item6_1)
    
    Dim item6_2 As B4XDaisyStatItem
    item6_2.Initialize(Me, "component")
    item6_2.Title = "Downloads"
    item6_2.Value = "31K"
    item6_2.Description = "From Jan 1st"
    item6_2.ValueColor = "secondary"
    item6_2.FigureType = "radial"
    item6_2.FigureSource = "62"
    item6_2.FigureColor = "secondary"
    stats6.AddItem(item6_2)
    
    stats6.Refresh
    
    sv6.Panel.Width = Max(stats6.ContentWidth, maxW)
    Dim h6 As Int = stats6.ContentHeight
    sv6.Width = maxW : sv6.Height = h6
    currentY = currentY + h6 + 12dip
    ' #endregion
    
    ' #region Example 7: With avatar figure
    ''' Demonstrates stat-figure slot with a B4XDaisyAvatar as the figure image.
    currentY = AddSectionTitle("With avatar figure", currentY, maxW)
    Dim sv7 As HorizontalScrollView
    sv7.Initialize(0, "")
    pnlHost.AddView(sv7, PAGE_PAD, currentY, maxW, 80dip)
    
    Dim stats7 As B4XDaisyStat
    stats7.Initialize(Me, "")
    stats7.AddToParent(sv7.Panel, 0, 0, 1dip, 1dip)
    
    ''' Item 1: Avatar image + user stats.
    Dim item7_1 As B4XDaisyStatItem
    item7_1.Initialize(Me, "component")
    item7_1.Title = "Active Users"
    item7_1.Value = "1,240"
    item7_1.Description = "Online now"
    item7_1.FigureType = "image"
    item7_1.FigureSource = "face_anna.jpg"
    stats7.AddItem(item7_1)
    
    ''' Item 2: Avatar image + engagement stats.
    Dim item7_2 As B4XDaisyStatItem
    item7_2.Initialize(Me, "component")
    item7_2.Title = "Engagement"
    item7_2.Value = "92%"
    item7_2.Description = "Last 30 days"
    item7_2.ValueColor = "accent"
    item7_2.FigureType = "image"
    item7_2.FigureSource = "face_marcus.jpg"
    stats7.AddItem(item7_2)
    
    stats7.Refresh
    
    sv7.Panel.Width = Max(stats7.ContentWidth, maxW)
    Dim h7 As Int = stats7.ContentHeight
    sv7.Width = maxW : sv7.Height = h7
    currentY = currentY + h7 + 12dip
    ' #endregion

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
    Return True
End Sub


Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.setTextColor(xui.Color_RGB(30, 41, 59))
    title.TextSize = "text-lg"
    title.FontBold = True
    Return Y + 48dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub component_Click(Tag As Object)
    Log("Clicked: " & Tag)
End Sub


#End Region
