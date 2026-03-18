B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private Const PAGE_PAD As Int = 12dip
    Private Const SECTION_GAP As Int = 14dip
    Private Const BTN_H As Int = 36dip
    Private Const BTN_GAP As Int = 8dip
    Private Const GROUP_GAP As Int = 20dip

    Private mMenu As B4XDaisyMenu
    Private mStatusLbl As B4XView

    ' Runtime state trackers
    Private mTextVersion As Int = 0
    Private mIconOn As Boolean = False
    Private mBadgeCount As Int = 0
    Private mBadgeColorIndex As Int = 0
    Private mSubmenuOpen As Boolean = False
    Private mSubmenuIndex As Int = 8
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    B4XPages.SetTitle(Me, "Menu: Item APIs")
    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent
    BuildPage(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    BuildPage(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

' ============================================================
Private Sub BuildPage(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews
    ResetState

    Dim maxW As Int = Max(280dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    y = AddSectionTitle("Menu: Item APIs", y, maxW)
    y = AddSectionNote("Item-level runtime operations: active, disabled, text, icon, badge, visibility, scroll and submenu.", y, maxW)

    ' ---- Build the shared menu ----
    mMenu.Initialize(Me, "menu")
    mMenu.Orientation = "vertical"
    mMenu.Size = "md"
    mMenu.RoundedBox = True
    mMenu.Shadow = "sm"
    mMenu.BackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(248, 247, 251))
    mMenu.Dividers = True
    mMenu.DividerGap = "1"
    mMenu.setHeight("h-52")
    RebuildMenuItems
    Dim menuH As Int = mMenu.GetPreferredHeight
    mMenu.AddToParent(pnlHost, PAGE_PAD, y, maxW, menuH)
    y = y + menuH + SECTION_GAP

    ' ---- Status label ----
    Dim statusBg As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(240, 242, 245))
    Dim lbl As Label
    lbl.Initialize("")
    mStatusLbl = lbl
    mStatusLbl.Text = "Tap a button — the operation appears here"
    mStatusLbl.TextColor = xui.Color_RGB(100, 116, 139)
    mStatusLbl.Font = xui.CreateDefaultFont(11)
    mStatusLbl.Color = statusBg
    mStatusLbl.SetTextAlignment("CENTER", "LEFT")
    pnlHost.AddView(mStatusLbl, PAGE_PAD, y, maxW, 22dip)
    y = y + 28dip

    ' ======================== Button groups ========================

    ' --- Active State ---
    y = AddGroupLabel("Active State", y, maxW)
    y = AddButtonRow("Activate Settings", "activate-3", "ClearActive", "clear-active", "primary", "ghost", y, maxW)

    ' --- Disable / Enable ---
    y = AddGroupLabel("Disable / Enable", y, maxW)
    y = AddButtonRow("Disable Locked", "disable-4", "Enable Locked", "enable-4", "error", "success", y, maxW)

    ' --- Item Text ---
    y = AddGroupLabel("Item Text", y, maxW)
    y = AddButtonRow("Rename Reports", "rename-2", "Reset name", "reset-name-2", "secondary", "ghost", y, maxW)

    ' --- Item Icon ---
    y = AddGroupLabel("Item Icon", y, maxW)
    y = AddButtonRow("Set icon on Overview", "set-icon-1", "Clear icon", "clear-icon-1", "secondary", "ghost", y, maxW)

    ' --- Badge ---
    y = AddGroupLabel("Badge", y, maxW)
    y = AddButtonRow("Inc badge count", "badge-inc", "Clear badge", "badge-clear", "accent", "ghost", y, maxW)
    y = AddButtonRow("Cycle bg color", "badge-color", "Cycle text color", "badge-text-color", "accent", "accent", y, maxW)

    ' --- Item Visibility ---
    y = AddGroupLabel("Item Visibility", y, maxW)
    y = AddButtonRow("Hide Settings", "hide-3", "Show Settings", "show-3", "error", "success", y, maxW)

    ' --- Scroll ---
    y = AddGroupLabel("Scroll", y, maxW)
    y = AddButtonRow("Scroll to Sign Out", "scroll-bottom", "Scroll to Overview", "scroll-top", "neutral", "neutral", y, maxW)

    ' --- Submenu ---
    y = AddGroupLabel("Submenu (Team)", y, maxW)
    y = AddButtonRow("Expand Team", "submenu-open", "Collapse Team", "submenu-close", "primary", "ghost", y, maxW)

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

' ============================================================
Private Sub ResetState
    mTextVersion = 0
    mIconOn = False
    mBadgeCount = 0
    mBadgeColorIndex = 0
    mSubmenuOpen = False
    mSubmenuIndex = 8
End Sub

' Populates mMenu items. Can be called during initial build (before AddToParent)
' or at runtime for a full rebuild. State trackers should be reset before calling.
Private Sub RebuildMenuItems
    mMenu.Clear
    mMenu.AddIconItem("item-1", "Overview", "house-solid.svg")
    mMenu.AddItem("item-2", "Reports")
    mMenu.AddItem("item-3", "Settings")
    mMenu.AddDivider
    mMenu.AddItem("item-badge", "Notifications")
    mMenu.SetItemBadgeText("item-badge", "3")
    mMenu.AddItem("item-4", "Locked")
    mMenu.AddTitle("More")
    mMenu.AddItem("item-5", "Profile")
    Dim sub1 As B4XDaisyMenu = mMenu.AddSubmenu("item-sub", "Team", False)
    sub1.AddItem("item-sub-1", "Engineering")
    sub1.AddItem("item-sub-2", "Design")
    sub1.AddItem("item-sub-3", "Marketing")
    mMenu.AddItem("item-7", "Billing")
    mMenu.AddItem("item-8", "Security")
    mMenu.AddItem("item-9", "API Keys")
    mMenu.AddItem("item-10", "Sign Out")
    mSubmenuIndex = 8
End Sub

' ============================================================
Private Sub btn_Click(Tag As Object)
    Dim action As String = Tag

    Select Case action

        ' ---- Active State ----
        Case "activate-3"
            mMenu.SetItemActive("item-3", True)
            ShowStatus("SetItemActive(""item-3"", True)")

        Case "clear-active"
            mMenu.ClearActive
            ShowStatus("ClearActive()")

        ' ---- Disable / Enable ----
        Case "disable-4"
            mMenu.SetItemDisabled("item-4", True)
            ShowStatus("SetItemDisabled(""item-4"", True)")

        Case "enable-4"
            mMenu.SetItemDisabled("item-4", False)
            ShowStatus("SetItemDisabled(""item-4"", False)")

        ' ---- Item Text ----
        Case "rename-2"
            mTextVersion = mTextVersion + 1
            Dim newNames(4) As String
            newNames(0) = "Monthly Report"
            newNames(1) = "Q4 Analytics"
            newNames(2) = "Sales Data"
            newNames(3) = "Reports"
            Dim nameIdx As Int = (mTextVersion - 1) Mod 4
            mMenu.SetItemText("item-2", newNames(nameIdx))
            ShowStatus("SetItemText(""item-2"", """ & newNames(nameIdx) & """)")

        Case "reset-name-2"
            mTextVersion = 0
            mMenu.SetItemText("item-2", "Reports")
            ShowStatus("SetItemText(""item-2"", ""Reports"")")

        ' ---- Item Icon ----
        Case "set-icon-1"
            mIconOn = True
            mMenu.SetItemIcon("item-1", "gear.svg")
            ShowStatus("SetItemIcon(""item-1"", ""gear.svg"")")

        Case "clear-icon-1"
            mIconOn = False
            mMenu.SetItemIcon("item-1", "house-solid.svg")
            ShowStatus("SetItemIcon(""item-1"", ""house-solid.svg"")  — restored")

        ' ---- Badge ----
        Case "badge-inc"
            mBadgeCount = mBadgeCount + 1
            mMenu.SetItemBadgeText("item-badge", mBadgeCount & "")
            ShowStatus("SetItemBadgeText(""item-badge"", """ & mBadgeCount & """)")

        Case "badge-clear"
            mBadgeCount = 0
            mMenu.SetItemBadgeText("item-badge", "")
            ShowStatus("SetItemBadgeText(""item-badge"", """")  — badge hidden")

        Case "badge-color"
            mBadgeColorIndex = (mBadgeColorIndex + 1) Mod 4
            Dim bgColors(4) As Int
            bgColors(0) = B4XDaisyVariants.GetTokenColor("--color-error",   xui.Color_RGB(220, 38,  38))
            bgColors(1) = B4XDaisyVariants.GetTokenColor("--color-success", xui.Color_RGB(21,  128, 61))
            bgColors(2) = B4XDaisyVariants.GetTokenColor("--color-warning", xui.Color_RGB(202, 138, 4))
            bgColors(3) = B4XDaisyVariants.GetTokenColor("--color-info",    xui.Color_RGB(37,  99,  235))
            Dim colorNames(4) As String
            colorNames(0) = "error" : colorNames(1) = "success" : colorNames(2) = "warning" : colorNames(3) = "info"
            mMenu.SetItemBadgeBackgroundColor("item-badge", bgColors(mBadgeColorIndex))
            ShowStatus("SetItemBadgeBackgroundColor -> " & colorNames(mBadgeColorIndex))

        Case "badge-text-color"
            Dim tcIdx As Int = mBadgeColorIndex Mod 2
            Dim tcColor As Int
            If tcIdx = 0 Then tcColor = xui.Color_White Else tcColor = xui.Color_RGB(30, 41, 59)
            Dim tcName As String
            If tcIdx = 0 Then tcName = "white" Else tcName = "dark"
            mMenu.SetItemBadgeTextColor("item-badge", tcColor)
            ShowStatus("SetItemBadgeTextColor -> " & tcName)

        ' ---- Item Visibility ----
        Case "hide-3"
            mMenu.SetItemVisible("item-3", False)
            ShowStatus("SetItemVisible(""item-3"", False)  — Settings hidden")

        Case "show-3"
            mMenu.SetItemVisible("item-3", True)
            ShowStatus("SetItemVisible(""item-3"", True)  — Settings visible")

        ' ---- Scroll ----
        Case "scroll-bottom"
            mMenu.ScrollToItem("item-10")
            ShowStatus("ScrollToItem(""item-10"")  →  Sign Out")

        Case "scroll-top"
            mMenu.ScrollToItem("item-1")
            ShowStatus("ScrollToItem(""item-1"")  →  Overview")

        ' ---- Submenu ----
        Case "submenu-open"
            mSubmenuOpen = True
            mMenu.SetSubmenuOpen(mSubmenuIndex, True)
            ShowStatus("SetSubmenuOpen(" & mSubmenuIndex & ", True)  — Team expanded")

        Case "submenu-close"
            mSubmenuOpen = False
            mMenu.SetSubmenuOpen(mSubmenuIndex, False)
            ShowStatus("SetSubmenuOpen(" & mSubmenuIndex & ", False)  — Team collapsed")

    End Select
End Sub

Private Sub ShowStatus(Text As String)
    If mStatusLbl.IsInitialized = False Then Return
    mStatusLbl.Text = Text
End Sub

Private Sub menu_Click(Tag As Object)
    Log("menu_Click tag=" & Tag)
End Sub

Private Sub menu_ItemClick(Tag As Object, Text As String)
    Dim s As String = Text
    If s.Trim.Length = 0 Then s = Tag
    ShowStatus("ItemClick: """ & s & """")
    #If B4A
    ToastMessageShow(s, False)
    #End If
End Sub

' ============================================================
' Layout helpers
' ============================================================

Private Sub AddButtonRow(LabelL As String, TagL As String, LabelR As String, TagR As String, _
        VariantL As String, VariantR As String, Y As Int, MaxW As Int) As Int
    Dim twoCol As Boolean = LabelR.Trim.Length > 0
    Dim btnW As Int
    If twoCol Then
        btnW = (MaxW - BTN_GAP) / 2
    Else
        btnW = MaxW
    End If

    Dim btnLeft As B4XDaisyButton
    btnLeft.Initialize(Me, "btn")
    btnLeft.AddToParent(pnlHost, PAGE_PAD, Y, btnW, BTN_H)
    btnLeft.Text = LabelL
    btnLeft.Tag = TagL
    btnLeft.Size = "sm"
    If VariantL.Trim.Length > 0 Then btnLeft.Variant = VariantL

    If twoCol Then
        Dim btnRight As B4XDaisyButton
        btnRight.Initialize(Me, "btn")
        btnRight.AddToParent(pnlHost, PAGE_PAD + btnW + BTN_GAP, Y, btnW, BTN_H)
        btnRight.Text = LabelR
        btnRight.Tag = TagR
        btnRight.Size = "sm"
        If VariantR.Trim.Length > 0 Then btnRight.Variant = VariantR
    End If

    Return Y + BTN_H + BTN_GAP
End Sub

Private Sub AddGroupLabel(Text As String, Y As Int, MaxW As Int) As Int
    Dim lbl As B4XDaisyText
    lbl.Initialize(Me, "")
    lbl.AddToParent(pnlHost, PAGE_PAD, Y + GROUP_GAP - 18dip, MaxW, 18dip)
    lbl.Text = Text
    lbl.TextColor = xui.Color_RGB(71, 85, 105)
    lbl.TextSize = 11
    lbl.FontBold = True
    Return Y + lbl.GetComputedHeight + GROUP_GAP
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = "text-lg"
    title.FontBold = True
    Return Y + title.GetComputedHeight + 2dip
End Sub

Private Sub AddSectionNote(Text As String, Y As Int, Width As Int) As Int
    Dim note As B4XDaisyText
    note.Initialize(Me, "")
    note.AddToParent(pnlHost, PAGE_PAD, Y, Width, 36dip)
    note.Text = Text
    note.TextColor = xui.Color_RGB(100, 116, 139)
    note.TextSize = "text-sm"
    note.SingleLine = False
    Return Y + note.GetComputedHeight + 2dip
End Sub
