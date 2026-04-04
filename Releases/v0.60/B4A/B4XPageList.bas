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
    Private PAGE_PAD As Int = 12dip
    Private SECTION_GAP As Int = 16dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "List")

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

    Dim maxW As Int = Width - (PAGE_PAD * 2)
    maxW = Max(240dip, maxW)
    maxW = Min(560dip, maxW)

    Dim y As Int = PAGE_PAD

    y = AddSectionTitle("List (second column grows - default)", y, maxW)
    y = CreateExample1(maxW, y)

    y = AddSectionTitle("List (third column grows)", y, maxW)
    y = CreateExample2(maxW, y)

    y = AddSectionTitle("List (third column wraps to next row)", y, maxW)
    y = CreateExample3(maxW, y)

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub ConfigureList(Target As B4XDaisyList)
    Target.BackgroundColor = "base-100"
    Target.Shadow = "shadow-md"
    Target.RoundedBox = True
    Target.Padding = 0
    Target.RowPadding = 16dip
    Target.RowGap = 16dip
    Target.Divider = True
    Target.DividerColor = "base-content/5"
    Target.setHeight("auto")
End Sub

Private Sub CreateExample1(maxW As Int, y As Int) As Int
    Dim list1 As B4XDaisyList
    list1.Initialize(Me, "list1")

    list1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    ConfigureList(list1)

    AddListHeaderRow(list1, "Most played songs this week", maxW)

    AddSongRow(list1, "Dio Lupa", "Remaining Reason", "1@94.webp", "", "", True, "row1")
    AddSongRow(list1, "Ellie Beilish", "Bears of a fever", "4@94.webp", "", "", True, "row2")
    AddSongRow(list1, "Sabrino Gardener", "Cappuccino", "3@94.webp", "", "", True, "row3")

    Dim listH As Int = list1.getHeight
    Return y + listH + SECTION_GAP
End Sub

Private Sub CreateExample2(maxW As Int, y As Int) As Int
    Dim list2 As B4XDaisyList
    list2.Initialize(Me, "list2")

    list2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    ConfigureList(list2)

    AddListHeaderRow(list2, "Most played songs this week", maxW)

    AddSongRow(list2, "Dio Lupa", "Remaining Reason", "1@94.webp", "01", "", False, "row1")
    AddSongRow(list2, "Ellie Beilish", "Bears of a fever", "4@94.webp", "02", "", False, "row2")
    AddSongRow(list2, "Sabrino Gardener", "Cappuccino", "3@94.webp", "03", "", False, "row3")

    Dim listH As Int = list2.getHeight
    Return y + listH + SECTION_GAP
End Sub

Private Sub CreateExample3(maxW As Int, y As Int) As Int
    Dim list3 As B4XDaisyList
    list3.Initialize(Me, "list3")

    list3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 0)
    ConfigureList(list3)

    AddListHeaderRow(list3, "Most played songs this week", maxW)

    AddSongRow(list3, "Dio Lupa", "Remaining Reason", "1@94.webp", "", """Remaining Reason"" became an instant hit, praised for its haunting sound and emotional depth. A viral performance brought it widespread recognition, making it one of Dio Lupa''s most iconic tracks.", True, "row1")
    AddSongRow(list3, "Ellie Beilish", "Bears of a fever", "4@94.webp", "", """Bears of a Fever"" captivated audiences with its intense energy and mysterious lyrics. Its popularity skyrocketed after fans shared it widely online, earning Ellie critical acclaim.", True, "row2")
    AddSongRow(list3, "Sabrino Gardener", "Cappuccino", "3@94.webp", "", """Cappuccino"" quickly gained attention for its smooth melody and relatable themes. The song''s success propelled Sabrino into the spotlight, solidifying their status as a rising star.", True, "row3")

    Dim listH As Int = list3.getHeight
    Return y + listH + SECTION_GAP
End Sub

Private Sub AddListHeaderRow(Target As B4XDaisyList, HeaderText As String, Width As Int)
    Dim headerItems As List
    headerItems.Initialize

    Dim headerView As B4XView = CreateHeaderView(HeaderText, Width - 32dip)
    headerItems.Add(CreateMap("view": headerView, "grow": True))

    Dim data As Map = CreateMap("items": headerItems, "height": 28dip, "Tag": "header")
    Target.AddRow(data)
End Sub

Private Sub AddSongRow(Target As B4XDaisyList, Artist As String, Subtitle As String, AvatarImage As String, NumberText As String, WrapText As String, IncludeHeart As Boolean, RowTag As String)
    Dim items As List
    items.Initialize

    If NumberText <> "" Then
        Dim numberView As B4XView = CreateNumberView(NumberText)
        items.Add(CreateMap("view": numberView, "grow": False, "width": 44dip, "height": 40dip))
    End If

    Dim avatarView As B4XView = CreateAvatarView(AvatarImage)
    items.Add(CreateMap("view": avatarView, "grow": False, "width": 40dip, "height": 40dip))

    Dim titleView As B4XView = CreateSongTitleView(Artist, Subtitle, 220dip)
    items.Add(CreateMap("view": titleView, "grow": True, "height": 36dip))

    If WrapText <> "" Then
        Dim wrapView As B4XView = CreateWrapDescriptionView(WrapText, 320dip)
        Dim wrapHeight As Int = Max(70dip, wrapView.Height)
        items.Add(CreateMap("view": wrapView, "grow": False, "wrap": True, "height": wrapHeight))
    End If

    Dim playView As B4XView = CreateActionIconButton(False)
    items.Add(CreateMap("view": playView, "grow": False, "width": 40dip, "height": 40dip))

    If IncludeHeart Then
        Dim heartView As B4XView = CreateActionIconButton(True)
        items.Add(CreateMap("view": heartView, "grow": False, "width": 40dip, "height": 40dip))
    End If

    Dim rowHeight As Int = 72dip
    If WrapText <> "" Then rowHeight = 0

    Dim rowData As Map = CreateMap("items": items, "height": rowHeight, "Tag": RowTag)
    Target.AddRow(rowData)
End Sub

Private Sub CreateHeaderView(Text As String, Width As Int) As B4XView
    Return CreateDaisyTextView(Text, Width, 16dip, 11, xui.Color_ARGB(160, 0, 0, 0), False, True, False)
End Sub

Private Sub CreateSongTitleView(Artist As String, Subtitle As String, Width As Int) As B4XView
    Dim p As B4XView = xui.CreatePanel("")
    p.SetLayoutAnimated(0, 0, 0, Width, 36dip)
    p.Color = xui.Color_Transparent

    Dim nameView As B4XView = CreateDaisyTextView(Artist, Width, 20dip, 16, xui.Color_RGB(17, 24, 39), False, True, False)
    p.AddView(nameView, 0, 0, Width, 20dip)

    Dim subView As B4XView = CreateDaisyTextView(Subtitle, Width, 16dip, 11, xui.Color_ARGB(160, 0, 0, 0), False, True, True)
    p.AddView(subView, 0, 20dip, Width, 16dip)

    Return p
End Sub

Private Sub CreateWrapDescriptionView(Text As String, Width As Int) As B4XView
    Dim txt As B4XDaisyText
    txt.Initialize(Me, "")
    Dim v As B4XView = txt.CreateView(Width, 1dip)
    txt.Text = Text
    txt.TextSize = 11
    txt.TextColor = xui.Color_RGB(31, 41, 55)
    txt.SingleLine = False

    Dim prefH As Int = Max(86dip, txt.GetPreferredHeight(Width) + 20dip)
    v.SetLayoutAnimated(0, 0, 0, Width, prefH)
    txt.Base_Resize(Width, prefH)
    Return v
End Sub

Private Sub CreateDaisyTextView(Text As String, Width As Int, Height As Int, TextSize As Object, TextColor As Int, Bold As Boolean, SingleLine As Boolean, Uppercase As Boolean) As B4XView
    Dim t As B4XDaisyText
    t.Initialize(Me, "")
    Dim v As B4XView = t.CreateView(Max(1dip, Width), Max(1dip, Height))

    Dim content As String = Text
    If Uppercase Then content = content.ToUpperCase

    t.Text = content
    t.TextSize = TextSize
    t.TextColor = TextColor
    t.FontBold = Bold
    t.SingleLine = SingleLine

    Return v
End Sub
Private Sub CreateAvatarView(ImageName As String) As B4XView
    Dim avatar As B4XDaisyAvatar
    avatar.Initialize(Me, "")
    Dim v As B4XView = avatar.CreateView(40dip, 40dip)
    avatar.AvatarSize = "40px"
    avatar.RoundedBox = True
    avatar.Image = ImageName
    Return v
End Sub

Private Sub CreateActionIconButton(IsHeart As Boolean) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim host As B4XView = p
    host.SetLayoutAnimated(0, 0, 0, 40dip, 40dip)
    host.Color = xui.Color_Transparent

    Dim iconView As B4XView
    If IsHeart Then
        iconView = CreateHeartOutlineIconView
    Else
        iconView = CreatePlayOutlineIconView
    End If
    host.AddView(iconView, 10dip, 10dip, 20dip, 20dip)
    Return host
End Sub

Private Sub CreatePlayOutlineIconView As B4XView
    Dim icon As B4XDaisySvgIcon
    icon.Initialize(Me, "")
    Dim v As B4XView = icon.CreateView(20dip, 20dip)
    icon.Size = "20px"
    icon.Color = xui.Color_ARGB(170, 0, 0, 0)
    icon.SvgContent = "<svg xmlns=""http://www.w3.org/2000/svg"" viewBox=""0 0 24 24""><g stroke-linejoin=""round"" stroke-linecap=""round"" stroke-width=""2"" fill=""none"" stroke=""currentColor""><path d=""M6 3L20 12 6 21 6 3z""></path></g></svg>"
    Return v
End Sub

Private Sub CreateHeartOutlineIconView As B4XView
    Dim icon As B4XDaisySvgIcon
    icon.Initialize(Me, "")
    Dim v As B4XView = icon.CreateView(20dip, 20dip)
    icon.Size = "20px"
    icon.Color = xui.Color_ARGB(170, 0, 0, 0)
    icon.SvgContent = "<svg xmlns=""http://www.w3.org/2000/svg"" viewBox=""0 0 24 24""><g stroke-linejoin=""round"" stroke-linecap=""round"" stroke-width=""2"" fill=""none"" stroke=""currentColor""><path d=""M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z""></path></g></svg>"
    Return v
End Sub

Private Sub CreateIconView(AssetName As String) As B4XView
    Dim icon As B4XDaisySvgIcon
    icon.Initialize(Me, "")
    Dim v As B4XView = icon.CreateView(20dip, 20dip)
    icon.Size = "20px"
    icon.Color = xui.Color_ARGB(170, 0, 0, 0)
    icon.SvgAsset = AssetName
    Return v
End Sub

Private Sub CreateNumberView(NumberText As String) As B4XView
    Dim txt As B4XDaisyText
    txt.Initialize(Me, "")
    Dim v As B4XView = txt.CreateView(44dip, 40dip)
    txt.Text = NumberText
    txt.TextSize = 30
    txt.TextColor = xui.Color_ARGB(80, 0, 0, 0)
    Return v
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 30dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + title.GetComputedHeight + 2dip
End Sub

Private Sub list1_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List1 Item Clicked: " & Index & " " & Tag, False)
End Sub

Private Sub list1_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List1 Item Long Clicked: " & Index & " " & Tag, False)
End Sub

Private Sub list2_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List2 Item Clicked: " & Index & " " & Tag, False)
End Sub

Private Sub list2_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List2 Item Long Clicked: " & Index & " " & Tag, False)
End Sub

Private Sub list3_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List3 Item Clicked: " & Index & " " & Tag, False)
End Sub

Private Sub list3_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List3 Item Long Clicked: " & Index & " " & Tag, False)
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region







