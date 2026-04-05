B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Variables
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 16dip
    Private CARD_PAD As Int = 16dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
    B4XPages.SetTitle(Me, "Tab")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent
    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(280dip, Width - (PAGE_PAD * 2))
    Dim contentLeft As Int = PAGE_PAD
    Dim y As Int = PAGE_PAD

    y = AddSectionTitle(contentLeft, y, maxW, "1. Basic Tabs")
    y = AddDescription(contentLeft, y, maxW, "Default tab style with no special styling. Second tab is active.")

    Dim ex1 As B4XDaisyTab
    ex1.Initialize(Me, "ex1")
    ex1.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex1.Style = "default"
    ex1.AddTab("Tab 1")
    ex1.AddTab("Tab 2")
    ex1.AddTab("Tab 3")
    ex1.ActiveIndex = 1
    ex1.SetTabContentText(0, "Content for Tab 1")
    ex1.SetTabContentText(1, "Content for Tab 2")
    ex1.SetTabContentText(2, "Content for Tab 3")
    ex1.ResizeTab
    Dim ex1H As Int = ex1.GetComputedHeight
    y = y + ex1H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "2. Tabs Border")
    y = AddDescription(contentLeft, y, maxW, "Border style shows a bottom border indicator on the active tab.")

    Dim ex2 As B4XDaisyTab
    ex2.Initialize(Me, "ex2")
    ex2.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex2.Style = "border"
    ex2.ActiveColor = "primary"
    ex2.AddTab("Tab 1")
    ex2.AddTab("Tab 2")
    ex2.AddTab("Tab 3")
    ex2.ActiveIndex = 1
    ex2.SetTabContentText(0, "Border tab content 1")
    ex2.SetTabContentText(1, "Border tab content 2")
    ex2.SetTabContentText(2, "Border tab content 3")
    ex2.ResizeTab
    Dim ex2H As Int = ex2.GetComputedHeight
    y = y + ex2H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "3. Tabs Lift")
    y = AddDescription(contentLeft, y, maxW, "Lift style makes the active tab appear raised with rounded top corners.")

    Dim ex3 As B4XDaisyTab
    ex3.Initialize(Me, "ex3")
    ex3.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex3.Style = "lift"
    ex3.AddTab("Tab 1")
    ex3.AddTab("Tab 2")
    ex3.AddTab("Tab 3")
    ex3.ActiveIndex = 1
    ex3.SetTabContentText(0, "Lift tab content 1")
    ex3.SetTabContentText(1, "Lift tab content 2")
    ex3.SetTabContentText(2, "Lift tab content 3")
    ex3.ResizeTab
    Dim ex3H As Int = ex3.GetComputedHeight
    y = y + ex3H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "4. Tabs Box")
    y = AddDescription(contentLeft, y, maxW, "Box style encloses tabs in a rounded container. Active tab has a solid background.")

    Dim ex4 As B4XDaisyTab
    ex4.Initialize(Me, "ex4")
    ex4.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex4.Style = "box"
    ex4.AddTab("Tab 1")
    ex4.AddTab("Tab 2")
    ex4.AddTab("Tab 3")
    ex4.ActiveIndex = 1
    ex4.SetTabContentText(0, "Box tab content 1")
    ex4.SetTabContentText(1, "Box tab content 2")
    ex4.SetTabContentText(2, "Box tab content 3")
    ex4.ResizeTab
    Dim ex4H As Int = ex4.GetComputedHeight
    y = y + ex4H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "5. Sizes (xs, sm, md, lg, xl)")
    y = AddDescription(contentLeft, y, maxW, "All five size variants demonstrated with lift style.")

    Dim ex5xs As B4XDaisyTab
    ex5xs.Initialize(Me, "ex5xs")
    ex5xs.AddToParent(pnlHost, contentLeft, y, maxW, 60dip)
    ex5xs.Style = "lift"
    ex5xs.Size = "xs"
    ex5xs.AddTab("Xsmall")
    ex5xs.AddTab("Xsmall")
    ex5xs.AddTab("Xsmall")
    ex5xs.ActiveIndex = 1
    ex5xs.SetTabContentText(0, "XS content")
    ex5xs.SetTabContentText(1, "XS content")
    ex5xs.SetTabContentText(2, "XS content")
    ex5xs.ResizeTab
    Dim ex5xsH As Int = ex5xs.GetComputedHeight
    y = y + ex5xsH + 8dip

    Dim ex5sm As B4XDaisyTab
    ex5sm.Initialize(Me, "ex5sm")
    ex5sm.AddToParent(pnlHost, contentLeft, y, maxW, 80dip)
    ex5sm.Style = "lift"
    ex5sm.Size = "sm"
    ex5sm.AddTab("Small")
    ex5sm.AddTab("Small")
    ex5sm.AddTab("Small")
    ex5sm.ActiveIndex = 1
    ex5sm.SetTabContentText(0, "SM content")
    ex5sm.SetTabContentText(1, "SM content")
    ex5sm.SetTabContentText(2, "SM content")
    ex5sm.ResizeTab
    Dim ex5smH As Int = ex5sm.GetComputedHeight
    y = y + ex5smH + 8dip

    Dim ex5md As B4XDaisyTab
    ex5md.Initialize(Me, "ex5md")
    ex5md.AddToParent(pnlHost, contentLeft, y, maxW, 100dip)
    ex5md.Style = "lift"
    ex5md.Size = "md"
    ex5md.AddTab("Medium")
    ex5md.AddTab("Medium")
    ex5md.AddTab("Medium")
    ex5md.ActiveIndex = 1
    ex5md.SetTabContentText(0, "MD content")
    ex5md.SetTabContentText(1, "MD content")
    ex5md.SetTabContentText(2, "MD content")
    ex5md.ResizeTab
    Dim ex5mdH As Int = ex5md.GetComputedHeight
    y = y + ex5mdH + 8dip

    Dim ex5lg As B4XDaisyTab
    ex5lg.Initialize(Me, "ex5lg")
    ex5lg.AddToParent(pnlHost, contentLeft, y, maxW, 120dip)
    ex5lg.Style = "lift"
    ex5lg.Size = "lg"
    ex5lg.AddTab("Large")
    ex5lg.AddTab("Large")
    ex5lg.AddTab("Large")
    ex5lg.ActiveIndex = 1
    ex5lg.SetTabContentText(0, "LG content")
    ex5lg.SetTabContentText(1, "LG content")
    ex5lg.SetTabContentText(2, "LG content")
    ex5lg.ResizeTab
    Dim ex5lgH As Int = ex5lg.GetComputedHeight
    y = y + ex5lgH + 8dip

    Dim ex5xl As B4XDaisyTab
    ex5xl.Initialize(Me, "ex5xl")
    ex5xl.AddToParent(pnlHost, contentLeft, y, maxW, 140dip)
    ex5xl.Style = "lift"
    ex5xl.Size = "xl"
    ex5xl.AddTab("Xlarge")
    ex5xl.AddTab("Xlarge")
    ex5xl.AddTab("Xlarge")
    ex5xl.ActiveIndex = 1
    ex5xl.SetTabContentText(0, "XL content")
    ex5xl.SetTabContentText(1, "XL content")
    ex5xl.SetTabContentText(2, "XL content")
    ex5xl.ResizeTab
    Dim ex5xlH As Int = ex5xl.GetComputedHeight
    y = y + ex5xlH + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "6. Tabs Bottom Placement")
    y = AddDescription(contentLeft, y, maxW, "Tab bar appears at the bottom with tabs-bottom placement.")

    Dim ex6 As B4XDaisyTab
    ex6.Initialize(Me, "ex6")
    ex6.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex6.Style = "lift"
    ex6.Placement = "bottom"
    ex6.AddTab("Tab 1")
    ex6.AddTab("Tab 2")
    ex6.AddTab("Tab 3")
    ex6.ActiveIndex = 1
    ex6.SetTabContentText(0, "Bottom tab content 1")
    ex6.SetTabContentText(1, "Bottom tab content 2")
    ex6.SetTabContentText(2, "Bottom tab content 3")
    ex6.ResizeTab
    Dim ex6H As Int = ex6.GetComputedHeight
    y = y + ex6H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "7. Tabs with Icons")
    y = AddDescription(contentLeft, y, maxW, "Tabs with icon prefixes mirroring the SVG icon examples from DaisyUI docs.")

    Dim ex7 As B4XDaisyTab
    ex7.Initialize(Me, "ex7")
    ex7.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex7.Style = "lift"
    ex7.AddTabWithIcon("Live", "▶")
    ex7.AddTabWithIcon("Laugh", "😄")
    ex7.AddTabWithIcon("Love", "❤")
    ex7.ActiveIndex = 0
    ex7.SetTabContentText(0, "Live content")
    ex7.SetTabContentText(1, "Laugh content")
    ex7.SetTabContentText(2, "Love content")
    ex7.ResizeTab
    Dim ex7H As Int = ex7.GetComputedHeight
    y = y + ex7H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "8. Disabled Tab")
    y = AddDescription(contentLeft, y, maxW, "Third tab is disabled using tab-disabled state. It is non-interactive and appears faded.")

    Dim ex8 As B4XDaisyTab
    ex8.Initialize(Me, "ex8")
    ex8.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex8.Style = "default"
    ex8.AddTab("Tab 1")
    ex8.AddTab("Tab 2")
    ex8.AddTab("Disabled")
    ex8.SetTabDisabled(2, True)
    ex8.ActiveIndex = 1
    ex8.SetTabContentText(0, "Tab 1 content")
    ex8.SetTabContentText(1, "Tab 2 content")
    ex8.SetTabContentText(2, "Disabled content")
    ex8.ResizeTab
    Dim ex8H As Int = ex8.GetComputedHeight
    y = y + ex8H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "9. Tabs with Content")
    y = AddDescription(contentLeft, y, maxW, "Each tab has content that displays when selected.")

    Dim ex9 As B4XDaisyTab
    ex9.Initialize(Me, "ex9")
    ex9.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex9.Style = "default"
    ex9.AddTab("Tab 1")
    ex9.AddTab("Tab 2")
    ex9.AddTab("Tab 3")
    ex9.ActiveIndex = 1
    ex9.SetTabContentText(0, "Tab content 1")
    ex9.SetTabContentText(1, "Tab content 2")
    ex9.SetTabContentText(2, "Tab content 3")
    ex9.ResizeTab
    Dim ex9H As Int = ex9.GetComputedHeight
    y = y + ex9H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "10. Lift Tabs with Content")
    y = AddDescription(contentLeft, y, maxW, "Lift style with content panels. Active tab appears seamlessly connected to content.")

    Dim ex10 As B4XDaisyTab
    ex10.Initialize(Me, "ex10")
    ex10.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex10.Style = "lift"
    ex10.AddTab("Tab 1")
    ex10.AddTab("Tab 2")
    ex10.AddTab("Tab 3")
    ex10.ActiveIndex = 1
    ex10.SetTabContentText(0, "Tab content 1")
    ex10.SetTabContentText(1, "Tab content 2")
    ex10.SetTabContentText(2, "Tab content 3")
    ex10.ResizeTab
    Dim ex10H As Int = ex10.GetComputedHeight
    y = y + ex10H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "11. Box Tabs with Content")
    y = AddDescription(contentLeft, y, maxW, "Box style with content panels. Tabs are enclosed in a rounded container.")

    Dim ex11 As B4XDaisyTab
    ex11.Initialize(Me, "ex11")
    ex11.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex11.Style = "box"
    ex11.AddTab("Tab 1")
    ex11.AddTab("Tab 2")
    ex11.AddTab("Tab 3")
    ex11.ActiveIndex = 1
    ex11.SetTabContentText(0, "Tab content 1")
    ex11.SetTabContentText(1, "Tab content 2")
    ex11.SetTabContentText(2, "Tab content 3")
    ex11.ResizeTab
    Dim ex11H As Int = ex11.GetComputedHeight
    y = y + ex11H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "12. Custom Variant Colors")
    y = AddDescription(contentLeft, y, maxW, "Active tab uses variant color to customize its appearance, mirroring CSS custom properties.")

    Dim ex12 As B4XDaisyTab
    ex12.Initialize(Me, "ex12")
    ex12.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex12.Style = "lift"
    ex12.AddTab("Tab 1")
    ex12.AddTab("Tab 2")
    ex12.AddTab("Tab 3")
    ex12.SetTabVariant(1, "primary")
    ex12.ActiveIndex = 1
    ex12.SetTabContentText(0, "Tab content 1")
    ex12.SetTabContentText(1, "Primary variant content")
    ex12.SetTabContentText(2, "Tab content 3")
    ex12.ResizeTab
    Dim ex12H As Int = ex12.GetComputedHeight
    y = y + ex12H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "13. Scrollable Tabs")
    y = AddDescription(contentLeft, y, maxW, "Many tabs that overflow the container. Scroll horizontally to see all tabs.")

    Dim ex13 As B4XDaisyTab
    ex13.Initialize(Me, "ex13")
    ex13.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex13.Style = "lift"
    ex13.Scrollable = True
    ex13.AddTab("Tab title 1")
    ex13.AddTab("Tab title 2")
    ex13.AddTab("Tab title 3")
    ex13.AddTab("Tab title 4")
    ex13.AddTab("Tab title 5")
    ex13.AddTab("Tab title 6")
    ex13.AddTab("Tab title 7")
    ex13.AddTab("Tab title 8")
    ex13.ActiveIndex = 1
    ex13.SetTabContentText(0, "Scrollable tab 1 content")
    ex13.SetTabContentText(1, "Scrollable tab 2 content")
    ex13.SetTabContentText(2, "Scrollable tab 3 content")
    ex13.SetTabContentText(3, "Scrollable tab 4 content")
    ex13.SetTabContentText(4, "Scrollable tab 5 content")
    ex13.SetTabContentText(5, "Scrollable tab 6 content")
    ex13.SetTabContentText(6, "Scrollable tab 7 content")
    ex13.SetTabContentText(7, "Scrollable tab 8 content")
    ex13.ResizeTab
    Dim ex13H As Int = ex13.GetComputedHeight
    y = y + ex13H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "14. Tabs Right Aligned")
    y = AddDescription(contentLeft, y, maxW, "Tabs aligned to the right side of the tab bar.")

    Dim ex14 As B4XDaisyTab
    ex14.Initialize(Me, "ex14")
    ex14.AddToParent(pnlHost, contentLeft, y, maxW, 200dip)
    ex14.Style = "default"
    ex14.Alignment = "right"
    ex14.AddTab("Tab 1")
    ex14.AddTab("Tab 2")
    ex14.AddTab("Tab 3")
    ex14.ActiveIndex = 1
    ex14.SetTabContentText(0, "Right aligned tab 1")
    ex14.SetTabContentText(1, "Right aligned tab 2")
    ex14.SetTabContentText(2, "Right aligned tab 3")
    ex14.ResizeTab
    Dim ex14H As Int = ex14.GetComputedHeight
    y = y + ex14H + 20dip

    y = AddSectionTitle(contentLeft, y, maxW, "15. Tabs with SVG Icons Only")
    y = AddDescription(contentLeft, y, maxW, "Tabs using only SVG icon files, no text. Active color applies to the icon.")

    Dim ex15 As B4XDaisyTab
    ex15.Initialize(Me, "ex15")
    ex15.AddToParent(pnlHost, contentLeft, y, maxW, 120dip)
    ex15.Style = "lift"
    ex15.Alignment = "center"
    ex15.AddTabWithIcon("", "stat_bolt.svg")
    ex15.AddTabWithIcon("", "heart-solid.svg")
    ex15.AddTabWithIcon("", "house-solid.svg")
    ex15.ActiveIndex = 0
    ex15.SetTabContentText(0, "Bolt tab content")
    ex15.SetTabContentText(1, "Heart tab content")
    ex15.SetTabContentText(2, "House tab content")
    ex15.ResizeTab
    Dim ex15H As Int = ex15.GetComputedHeight
    y = y + ex15H + 20dip

    y = y + 40dip

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, Left, Y, Width, 0)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 15
    title.FontBold = True
    Dim titleH As Int = title.GetComputedHeight
    Return Y + titleH + 4dip
End Sub

Private Sub AddDescription(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim desc As B4XDaisyText
    desc.Initialize(Me, "")
    desc.AddToParent(pnlHost, Left, Y, Width, 0)
    desc.Text = Text
    desc.TextColor = xui.Color_RGB(100, 116, 139)
    desc.TextSize = 11
    Dim descH As Int = desc.GetComputedHeight
    Return Y + descH + 4dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then
        svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
    RenderExamples(Width, Height)
End Sub

Private Sub ex1_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex1 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex2_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex2 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex3_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex3 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex4_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex4 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex5xs_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex5 XS Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex5sm_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex5 SM Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex5md_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex5 MD Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex5lg_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex5 LG Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex5xl_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex5 XL Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex6_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex6 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex7_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex7 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex8_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex8 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex9_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex9 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex10_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex10 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex11_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex11 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex12_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex12 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex13_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex13 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex14_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex14 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub ex15_TabClick(Index As Int)
    #If B4A
    ToastMessageShow("Ex15 Tab " & (Index + 1) & " clicked", False)
    #End If
End Sub
#End Region
