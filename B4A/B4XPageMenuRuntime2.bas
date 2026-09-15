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
    Private mSizeIndex As Int = 2           ' 0=xs 1=sm 2=md 3=lg 4=xl
    Private mDynamicCount As Int = 0
    Private mDividersOn As Boolean = True
    Private mMenuEnabled As Boolean = True
    Private mMenuVisible As Boolean = True
    Private mSubmenuIndex As Int = 8
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
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

' -
Private Sub BuildPage(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews
    ResetState

    Dim maxW As Int = Max(280dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    y = AddSectionTitle("Menu: Level APIs", y, maxW)
    y = AddSectionNote("Menu-level and dynamic runtime operations: size, dividers, enabled, visible, add items and rebuild.", y, maxW)

    ' ---- Build the shared menu ----
    mMenu.Initialize(Me, "menu")
    mMenu.Orientation = "vertical"
    mMenu.Size = "md"
    mMenu.Rounded = "rounded-box"
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
    mStatusLbl.Text = "Tap a button ? the operation appears here"
    mStatusLbl.TextColor = xui.Color_RGB(100, 116, 139)
    mStatusLbl.Font = xui.CreateDefaultFont(11)
    mStatusLbl.Color = statusBg
    mStatusLbl.SetTextAlignment("CENTER", "LEFT")
    pnlHost.AddView(mStatusLbl, PAGE_PAD, y, maxW, 22dip)
    y = y + 28dip

    ' - Button groups -

    ' --- Menu Size ---
    y = AddGroupLabel("Menu Size", y, maxW)
    y = AddButtonRow("Cycle size", "cycle-size", "", "", "neutral", "", y, maxW)

    ' --- Dividers ---
    y = AddGroupLabel("Dividers", y, maxW)
    y = AddButtonRow("Toggle dividers", "toggle-dividers", "", "", "neutral", "", y, maxW)

    ' --- Enabled ---
    y = AddGroupLabel("Enabled", y, maxW)
    y = AddButtonRow("Toggle Enabled", "toggle-enabled", "", "", "warning", "", y, maxW)

    ' --- Visible ---
    y = AddGroupLabel("Visible", y, maxW)
    y = AddButtonRow("Toggle Visible", "toggle-visible", "", "", "warning", "", y, maxW)

    ' --- Dynamic Content ---
    y = AddGroupLabel("Dynamic Content & Helpers", y, maxW)
    y = AddButtonRow("Add Avatar Item", "add-avatar", "Add ID Parent/Child", "add-id-tree", "primary", "secondary", y, maxW)
    y = AddButtonRow("Load Map List", "load-list", "Close Submenus", "close-submenus", "accent", "neutral", y, maxW)
    y = AddButtonRow("Add Normal Item", "add-item", "Rebuild menu", "rebuild", "success", "neutral", y, maxW)
    y = AddButtonRow("Measure preferred size", "measure", "", "", "info", "", y, maxW)

    ' --- Reset ---
    y = AddGroupLabel("Reset", y, maxW)
    y = AddButtonRow("Reset all to defaults", "reset-all", "", "", "error", "", y, maxW)

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

' -
Private Sub ResetState
    mSizeIndex = 2
    mDynamicCount = 0
    mDividersOn = True
    mMenuEnabled = True
    mMenuVisible = True
    mSubmenuIndex = 8
End Sub

Private Sub RebuildMenuItems
    mMenu.Clear
    mMenu.AddAvatarBadgeItem("user-mashy", "Anele Mbanga", "mashymain.jpg", "circle", "Admin", "primary")
    mMenu.AddAvatarItem("user-anna", "Anna Smith", "face_anna.jpg", "squircle")
    mMenu.AddDivider
    mMenu.AddIconItem("item-1", "Overview", "house-solid.svg")
    mMenu.AddItem("item-2", "Reports")
    mMenu.AddItem("item-3", "Settings")
    mMenu.AddDivider
    mMenu.AddBadgeItem("item-badge", "Notifications", "3", "secondary")
    mMenu.AddTitle("Management")
    
    ' Using Flat ID-based Tree Addition
    mMenu.AddItemParent("", "tree-team", "Organization", "user-group-solid.svg")
    mMenu.AddItemChild("tree-team", "team-eng", "Engineering", "code-solid.svg")
    mMenu.AddAvatarChildItem("tree-team", "team-lead", "Team Lead (Marcus)", "face_marcus.jpg", "circle")
    mMenu.AddBadgeChildItem("tree-team", "team-qa", "QA Testing", "New", "accent")
    
    mMenu.AddItem("item-billing", "Billing")
    mMenu.AddItem("item-signout", "Sign Out")
    mSubmenuIndex = 8
End Sub

' -
Private Sub btn_Click(Tag As Object)
    Dim action As String = Tag

    Dim sizes(5) As String
    sizes(0) = "xs" : sizes(1) = "sm" : sizes(2) = "md" : sizes(3) = "lg" : sizes(4) = "xl"

    Select Case action

        ' ---- Menu Size ----
        Case "cycle-size"
            mSizeIndex = (mSizeIndex + 1) Mod 5
            mMenu.Size = sizes(mSizeIndex)
            ShowStatus("Size = """ & sizes(mSizeIndex) & """")

        ' ---- Dividers ----
        Case "toggle-dividers"
            mDividersOn = Not(mDividersOn)
            mMenu.Dividers = mDividersOn
            Dim divStr As String
            If mDividersOn Then divStr = "True" Else divStr = "False"
            ShowStatus("Dividers = " & divStr)

        ' ---- Enabled ----
        Case "toggle-enabled"
            mMenuEnabled = Not(mMenuEnabled)
            mMenu.Enabled = mMenuEnabled
            Dim enStr As String
            If mMenuEnabled Then enStr = "True" Else enStr = "False"
            ShowStatus("Enabled = " & enStr)

        ' ---- Visible ----
        Case "toggle-visible"
            mMenuVisible = Not(mMenuVisible)
            mMenu.Visible = mMenuVisible
            Dim visStr As String
            If mMenuVisible Then visStr = "True" Else visStr = "False"
            ShowStatus("Visible = " & visStr)

        ' ---- Dynamic Content ----
        Case "add-avatar"
            mDynamicCount = mDynamicCount + 1
            mMenu.AddAvatarBadgeItem("dyn-av-" & mDynamicCount, "User " & mDynamicCount, "face" & ((mDynamicCount Mod 7) + 4) & ".jpg", "circle", "Active", "success")
            ShowStatus("AddAvatarBadgeItem: User " & mDynamicCount)

        Case "add-id-tree"
            mDynamicCount = mDynamicCount + 1
            Dim parentKey As String = "dyn-parent-" & mDynamicCount
            mMenu.AddItemParent("", parentKey, "Folder " & mDynamicCount, "folder-solid.svg")
            mMenu.AddItemChild(parentKey, parentKey & "-sub1", "Document A", "file-lines-solid.svg")
            mMenu.AddAvatarChildItem(parentKey, parentKey & "-sub2", "Assigned: Marcus", "face_marcus.jpg", "rounded-md")
            mMenu.SetItemOpen(parentKey, True)
            ShowStatus("AddItemParent & AddItemChild with auto-expand")

        Case "load-list"
            Dim itemsList As List
            itemsList.Initialize
            itemsList.Add(CreateMap("kind": "title", "text": "DATA DRIVEN MENU"))
            itemsList.Add(CreateMap("tag": "dash", "text": "Dashboard", "icon": "chart-pie-solid.svg"))
            itemsList.Add(CreateMap("tag": "usr", "text": "Current User", "avatar": "mashymain.jpg", "avatar_shape": "circle", "badge": "VIP", "badge_variant": "warning"))
            itemsList.Add(CreateMap("tag": "sub-proj", "text": "Projects", "is_parent": True, "icon": "folder-solid.svg", "open": True))
            itemsList.Add(CreateMap("tag": "proj-1", "parent": "sub-proj", "text": "B4XDaisyUIKit", "badge": "v0.91", "badge_variant": "primary"))
            itemsList.Add(CreateMap("tag": "proj-2", "parent": "sub-proj", "text": "Client App", "icon": "mobile-screen-solid.svg"))
            itemsList.Add(CreateMap("kind": "divider"))
            itemsList.Add(CreateMap("tag": "logout", "text": "Log Out", "icon": "arrow-right-from-bracket-solid.svg"))
            mMenu.LoadFromList(itemsList)
            ShowStatus("LoadFromList: Loaded 8 items via Map descriptors")

        Case "close-submenus"
            mMenu.CloseParents
            ShowStatus("CloseParents: collapsed all open submenus")

        Case "add-item"
            mDynamicCount = mDynamicCount + 1
            mMenu.AddItem("dyn-" & mDynamicCount, "Dynamic item " & mDynamicCount)
            ShowStatus("AddItem(""dyn-" & mDynamicCount & """)  - item added at end")

        Case "rebuild"
            RebuildMenuItems
            ResetState
            ShowStatus("Clear() + rebuild - all items restored, state reset")

        Case "measure"
            ShowStatus("GetPreferredWidth=" & mMenu.GetPreferredWidth & "  GetPreferredHeight=" & mMenu.GetPreferredHeight)

        ' ---- Reset ----
        Case "reset-all"
            RebuildMenuItems
            ResetState
            mMenu.Size = "md"
            mMenu.Dividers = True
            mMenu.Enabled = True
            mMenu.Visible = True
            ShowStatus("Reset - menu restored to defaults")

    End Select
End Sub

Private Sub ShowStatus(Text As String)
    If mStatusLbl.IsInitialized = False Then Return
    mStatusLbl.Text = Text
End Sub

Private Sub menu_Click(Tag As Object)
    ' Log("menu_Click tag=" & Tag)
End Sub

Private Sub menu_ItemClick(Tag As Object, Text As String)
    Dim s As String = Text
    If s.Trim.Length = 0 Then s = Tag
    ShowStatus("ItemClick: """ & s & """")
    #If B4A
    B4XPages.MainPage.ShowToast(s, False)
    #End If
End Sub

' -
' Layout helpers
' -

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
