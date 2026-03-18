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
    Private Const SECTION_GAP As Int = 100dip
    Private Dropdowns As List
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    Dropdowns.Initialize
    B4XPages.SetTitle(Me, "Dropdown")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent
    B4XDaisyVariants.DisableClippingRecursive(pnlHost)

    BuildExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    BuildExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub BuildExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews
    Dropdowns.Clear

    Dim maxW As Int = Max(280dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    y = ExampleIntro(y, maxW)
    y = ExampleNotificationBell(y, maxW)
    y = ExampleAvatarTrigger(y, maxW)
    y = ExampleStart(y, maxW)
    y = ExampleEnd(y, maxW)
    y = ExampleCenter(y, maxW)
    y = ExampleTop(y, maxW)
    y = ExampleTopCenter(y, maxW)
    y = ExampleTopEnd(y, maxW)
    y = ExampleBottom(y, maxW)
    y = ExampleBottomCenter(y, maxW)
    y = ExampleBottomEnd(y, maxW)
    y = ExampleLeft(y, maxW)
    y = ExampleLeftCenter(y, maxW)
    y = ExampleLeftEnd(y, maxW)
    y = ExampleRight(y, maxW)
    y = ExampleRightEnd(y, maxW)
    y = ExampleRightCenter(y, maxW)
    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub ExampleIntro(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Dropdown menu", Y, Width)
    Y = AddSectionNote("AttachTo lets any existing host view become the trigger while the dropdown still renders an internal B4XDaisyMenu popup.", Y, Width)
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-basic", "start", "bottom")
    Return AddDropdownBlock("", dd, "Open menu", Y, Width, False)
End Sub

Private Sub ExampleNotificationBell(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Notification bell", Y, Width)
    Y = AddSectionNote("An SVG bell icon acts as the trigger. A red indicator badge shows unread count. The menu lists mixed single-line and multi-line notifications.", Y, Width)

    Dim iconSize As Int = 48dip
    Dim iconPad As Int = 12dip

    ' Container row — needed so the indicator badge can overflow the bell without being clipped
    Dim row As B4XView = xui.CreatePanel("")
    row.Color = xui.Color_Transparent
    B4XDaisyVariants.DisableClipping(row)
    pnlHost.AddView(row, PAGE_PAD, Y, iconSize + iconPad * 2, iconSize + iconPad * 2)

    ' Bell SVG icon — the visual trigger, centered in row with padding
    Dim bell As B4XDaisySvgIcon
    bell.Initialize(Me, "bell")
    Dim bellView As B4XView = bell.AddToParent(row, iconPad, iconPad, iconSize, iconSize)
    bell.SvgAsset = "bell-solid.svg"
    bell.ColorVariant = "base-content"
    bell.Padding = 8dip

    ' Red counter indicator overlaid top-right of the bell
    Dim ind As B4XDaisyIndicator
    ind.Initialize(Me, "ind")
    ind.AddToParent(row, iconPad, iconPad, iconSize, iconSize)
    ind.setCounter(True)
    ind.setText("3")
    ind.setVariant("error")
    ind.setSize("xs")
    ind.setHorizontalPlacement("end")
    ind.setVerticalPlacement("top")
    ind.AttachToTarget(bellView)

    ' Menu width: 90% of available page width, expressed as px for TailwindSizeToDip
    Dim menuW As Int = Max(200dip, Width * 0.9)
    Dim menuWSpec As String = (menuW / 1dip) & "px"

    ' Dropdown attached to the bell icon
    Dim dd As B4XDaisyDropdown
    dd.Initialize(Me, "dropdown")
    dd.Tag = "dropdown-bell"
    dd.Placement = "start"
    dd.Direction = "bottom"
    dd.MenuWidth = menuWSpec
    dd.MenuPadding = "p-2"
    dd.MenuRounded = "theme"
    dd.MenuShadow = "sm"
    dd.MenuBackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dd.MenuTextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(44, 52, 64))
    dd.BringToFront = True

    ' Notifications header
    dd.Menu.AddTitle("Notifications")

    ' Single-line: simple alert
    dd.AddItem("notif-system", "System maintenance at midnight")

    ' Multi-line: sender title + message item
    dd.Menu.AddTitle("Anna K.")
    dd.AddItem("notif-anna", "Can you review the latest PR? It has a few breaking changes.")

    ' Single-line
    dd.AddItem("notif-deploy", "Deployment to production succeeded")

    ' Multi-line: sender title + message item
    dd.Menu.AddTitle("Marcus T.")
    dd.AddItem("notif-marcus", "Meeting rescheduled to 3pm — please update your calendar.")

    ' Single-line
    dd.AddItem("notif-login", "New login from Chrome on Windows")

    dd.AttachTo(row)
    Dropdowns.Add(dd)

    Return Y + iconSize + iconPad * 2 + SECTION_GAP
End Sub

Private Sub ExampleAvatarTrigger(Y As Int, Width As Int) As Int
    Y = AddSectionTitle("Avatar dropdown", Y, Width)
    Y = AddSectionNote("The trigger can be an image avatar instead of a button. This matches the common account-menu pattern.", Y, Width)

    Dim dd As B4XDaisyDropdown
    dd.Initialize(Me, "dropdown")
    dd.Tag = "dropdown-avatar"
    dd.Placement = "start"
    dd.Direction = "bottom"
    dd.MenuWidth = "w-auto"
    dd.MenuPadding = "p-2"
    dd.MenuRounded = "theme"
    dd.MenuShadow = "sm"
    dd.MenuBackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dd.MenuTextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(44, 52, 64))
    dd.BringToFront = True
    dd.AddItem("dropdown-avatar-profile", "Profile")
    dd.AddItem("dropdown-avatar-settings", "Settings")
    dd.AddItem("dropdown-avatar-logout", "Logout")
    Dropdowns.Add(dd)

    Return AddAvatarDropdownBlock(dd, Y)
End Sub

Private Sub ExampleStart(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-start", "start", "bottom")
    Return AddDropdownBlock("1. Dropdown start", dd, "Start", Y, Width, False)
End Sub

Private Sub ExampleEnd(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-end", "end", "bottom")
    Return AddDropdownBlock("2. Dropdown end", dd, "End", Y, Width, False)
End Sub

Private Sub ExampleCenter(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-center", "center", "bottom")
    Return AddDropdownBlock("3. Dropdown center", dd, "Center", Y, Width, False)
End Sub

Private Sub ExampleTop(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-top", "start", "top")
    Return AddDropdownBlock("4. Dropdown top", dd, "Top", Y, Width, False)
End Sub

Private Sub ExampleTopCenter(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-top-center", "center", "top")
    Return AddDropdownBlock("5. Dropdown top center", dd, "Top center", Y, Width, False)
End Sub

Private Sub ExampleTopEnd(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-top-end", "end", "top")
    Return AddDropdownBlock("6. Dropdown top end", dd, "Top end", Y, Width, False)
End Sub

Private Sub ExampleBottom(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-bottom", "start", "bottom")
    Return AddDropdownBlock("7. Dropdown bottom", dd, "Bottom", Y, Width, False)
End Sub

Private Sub ExampleBottomCenter(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-bottom-center", "center", "bottom")
    Return AddDropdownBlock("8. Dropdown bottom center", dd, "Bottom center", Y, Width, False)
End Sub

Private Sub ExampleBottomEnd(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-bottom-end", "end", "bottom")
    Return AddDropdownBlock("9. Dropdown bottom end", dd, "Bottom end", Y, Width, False)
End Sub

Private Sub ExampleLeft(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-left", "start", "left")
    Return AddDropdownBlock("10. Dropdown left", dd, "Left", Y, Width, False)
End Sub

Private Sub ExampleLeftCenter(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-left-center", "center", "left")
    Return AddDropdownBlock("11. Dropdown left center", dd, "Left center", Y, Width, False)
End Sub

Private Sub ExampleLeftEnd(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-left-end", "end", "left")
    Return AddDropdownBlock("12. Dropdown left end", dd, "Left end", Y, Width, False)
End Sub

Private Sub ExampleRight(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-right", "start", "right")
    Return AddDropdownBlock("13. Dropdown right", dd, "Right", Y, Width, False)
End Sub

Private Sub ExampleRightEnd(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-right-end", "end", "right")
    Return AddDropdownBlock("14. Dropdown right end", dd, "Right end", Y, Width, False)
End Sub

Private Sub ExampleRightCenter(Y As Int, Width As Int) As Int
    Dim dd As B4XDaisyDropdown = CreateMenuDropdown("dropdown-right-center", "center", "right")
    Return AddDropdownBlock("15. Dropdown right center", dd, "Right center", Y, Width, False)
End Sub

Private Sub CreateMenuDropdown(TagValue As String, Placement As String, Direction As String) As B4XDaisyDropdown
    Dim dd As B4XDaisyDropdown
    dd.Initialize(Me, "dropdown")
    dd.Tag = TagValue
    dd.Placement = Placement
    dd.Direction = Direction
    dd.MenuWidth = "w-auto"
    dd.MenuPadding = "p-2"
    dd.MenuRounded = "theme"
    dd.MenuShadow = "sm"
    dd.MenuBackgroundColor = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    dd.MenuTextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(44, 52, 64))
    dd.BringToFront = True
    dd.AddItem(TagValue & "-1", "Item 1")
    dd.AddItem(TagValue & "-2", "Item 2")
    Return dd
End Sub

Private Sub AddDropdownBlock(SectionTitle As String, DropdownComp As B4XDaisyDropdown, TriggerText As String, Y As Int, Width As Int, ReserveOpenMenu As Boolean) As Int
    Dim triggerW As Int = 180dip
    Dim triggerH As Int = 40dip
    Dim blockW As Int = Max(280dip, Width)
    Dim direction As String = DropdownComp.Direction
    Dim placement As String = DropdownComp.Placement
    Dim hostLeft As Int = PAGE_PAD
    Dim hostTop As Int = Y
    Dim blockH As Int = triggerH

    If direction = "left" Or direction = "right" Then
        blockH = 132dip
        ' Right-direction: trigger on left. Left-direction: trigger on right.
        If direction = "right" Then
            hostLeft = PAGE_PAD
        Else
            hostLeft = PAGE_PAD + Max(0dip, blockW - triggerW)
        End If
    Else
        Select Case placement
            Case "end"
                hostLeft = PAGE_PAD + Max(0dip, blockW - triggerW)
            Case "center"
                hostLeft = PAGE_PAD + (blockW - triggerW) / 2
            Case Else
                hostLeft = PAGE_PAD
        End Select
    End If

    ' Render title above the button — must happen before hostTop is calculated
    ' so that Y is already advanced past the title when positioning the trigger.
    If SectionTitle.Length > 0 Then
        Y = AddSectionTitle(SectionTitle, Y, blockW)
    End If

    ' Calculate hostTop after title so the trigger always sits below it.
    If direction = "left" Or direction = "right" Then
        Select Case placement
            Case "center"
                hostTop = Y + (blockH - triggerH) / 2
            Case "end"
                hostTop = Y + blockH - triggerH
            Case Else
                hostTop = Y
        End Select
    Else
        hostTop = Y
    End If

    Dim host As B4XDaisyButton
    host.Initialize(Me, "host")
    host.Text = TriggerText
    host.Variant = "default"
    host.Style = "solid"
    host.Size = "md"
    Dim hostView As B4XView = host.AddToParent(pnlHost, hostLeft, hostTop, triggerW, triggerH)

    DropdownComp.AttachTo(hostView)

    Dim nextY As Int = Y + blockH + SECTION_GAP
    If ReserveOpenMenu Then
        nextY = nextY + DropdownComp.GetPreferredMenuHeight + 12dip
    End If
    Return nextY
End Sub

Private Sub AddAvatarDropdownBlock(DropdownComp As B4XDaisyDropdown, Y As Int) As Int
    Dim avatarSize As Int = 56dip

    Dim avatar As B4XDaisyAvatar
    avatar.Initialize(Me, "avatar")
    avatar.AddToParent(pnlHost, PAGE_PAD, Y, avatarSize, avatarSize)
    avatar.setAvatar("face_profile11.jpg")
    avatar.setAvatarMask("rounded-full")
    avatar.setShowOnline(True)
    avatar.setAvatarStatus("online")
    avatar.setRingWidth(2dip)
    avatar.setRingColorVariant("primary")

    DropdownComp.AttachTo(avatar.View)

    Return Y + avatarSize + SECTION_GAP
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Return AddSectionTitle2(Text, Y, Width, PAGE_PAD)
End Sub

Private Sub AddSectionTitle2(Text As String, Y As Int, Width As Int, Left As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "text")
    title.AddToParent(pnlHost, Left, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = "text-lg"
    title.FontBold = True
    title.setAutoResize(True)
    Return Y + title.GetComputedHeight + 2dip
End Sub

Private Sub AddSectionNote(Text As String, Y As Int, Width As Int) As Int
    Dim note As B4XDaisyText
    note.Initialize(Me, "text")
    note.AddToParent(pnlHost, PAGE_PAD, Y, Width, 40dip)
    note.Text = Text
    note.TextColor = xui.Color_RGB(100, 116, 139)
    note.TextSize = "text-sm"
    note.SingleLine = False
    Return Y + note.GetComputedHeight + 2dip
End Sub

Private Sub dropdown_Click(Tag As Object)
    Log("B4XDaisyDropdown.Click=" & Tag)
End Sub

Private Sub dropdown_ItemClick(Tag As Object, Text As String)
    #If B4A
    Dim displayText As String = Text
    If displayText.Length = 0 Then displayText = "" & Tag
    ToastMessageShow("Dropdown: " & displayText, False)
    #End If
End Sub

Private Sub host_Click(Tag As Object)
    Log("Host Button Clicked: " & Tag)
End Sub

Private Sub avatar_Click(Tag As Object)
    Log("Avatar Trigger Clicked: " & Tag)
End Sub
