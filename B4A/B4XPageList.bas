B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=2.00
@EndOfDesignText@

#Region Variables
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
    Private SECTION_GAP As Int = 16dip
    Private List1 As B4XDaisyList
    Private List2 As B4XDaisyList
    Private List3 As B4XDaisyList
    Private List4 As B4XDaisyList
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
    If pnlHost = Null Then Return
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews
    Dim currentY As Int = PAGE_PAD
    Dim maxW As Int = Width - (PAGE_PAD * 2)
    maxW = Max(240dip, maxW)
    maxW = Min(560dip, maxW)

    ' === DaisyUI: List (2 columns, second column grows - default) ===
    currentY = AddSectionTitle("List (2nd column grows - default)", currentY, maxW)
    List1.Clear
    List1.Initialize(Me, "List1")
    List1.Rounded = "rounded-box"
    List1.Shadow = "shadow-md"
    List1.BackgroundColor = "base-100"
    List1.Padding = 0
    List1.RowPadding = 16dip
    List1.Divider = True
    List1.DividerColor = "base-content/5"
    List1.RowHeight = 72dip
    List1.AutoHeight = True
    List1.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 320dip)
    List1.AddHeader("Most played songs this week")
    List1.AddRowData(CreateMap("Tag": "row1", "_height": 72, "title": "Dio Lupa", "subtitle": "Remaining Reason", "avatar": "face_3.jpg", "rowType": "song"))
    List1.AddRowData(CreateMap("Tag": "row2", "_height": 72, "title": "Ellie Beilish", "subtitle": "Bears of a fever", "avatar": "face_13.jpg", "rowType": "song"))
    List1.AddRowData(CreateMap("Tag": "row3", "_height": 72, "title": "Sabrino Gardener", "subtitle": "Cappuccino", "avatar": "face_profile13.jpeg", "rowType": "song"))
    currentY = currentY + List1.getHeight + SECTION_GAP

    ' === DaisyUI: List (3 columns, 3rd column grows) ===
    currentY = AddSectionTitle("List (3rd column grows)", currentY, maxW)
    List2.Clear
    List2.Initialize(Me, "List2")
    List2.Rounded = "rounded-box"
    List2.Shadow = "shadow-md"
    List2.BackgroundColor = "base-100"
    List2.Padding = 0
    List2.RowPadding = 16dip
    List2.Divider = True
    List2.DividerColor = "base-content/5"
    List2.RowHeight = 72dip
    List2.AutoHeight = True
    List2.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 320dip)
    List2.AddHeader("Most played songs this week")
    List2.AddRowData(CreateMap("Tag": "rank1", "_height": 72, "number": "01", "title": "Dio Lupa", "subtitle": "Remaining Reason", "avatar": "face_3.jpg", "rowType": "ranked_song"))
    List2.AddRowData(CreateMap("Tag": "rank2", "_height": 72, "number": "02", "title": "Ellie Beilish", "subtitle": "Bears of a fever", "avatar": "face_13.jpg", "rowType": "ranked_song"))
    List2.AddRowData(CreateMap("Tag": "rank3", "_height": 72, "number": "03", "title": "Sabrino Gardener", "subtitle": "Cappuccino", "avatar": "face_profile13.jpeg", "rowType": "ranked_song"))
    currentY = currentY + List2.getHeight + SECTION_GAP

    ' === DaisyUI: List (3 columns, 3rd column wraps to next row) ===
    currentY = AddSectionTitle("List (3rd column wraps)", currentY, maxW)
    List3.Clear
    List3.Initialize(Me, "List3")
    List3.Rounded = "rounded-box"
    List3.Shadow = "shadow-md"
    List3.BackgroundColor = "base-100"
    List3.Padding = 0
    List3.RowPadding = 16dip
    List3.Divider = True
    List3.DividerColor = "base-content/5"
    List3.RowHeight = 90dip
    List3.AutoHeight = True
    List3.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 400dip)
    List3.AddHeader("Most played songs this week")
    List3.AddRowData(CreateMap("Tag": "wrap1", "_height": 100, "title": "Dio Lupa", "subtitle": "Remaining Reason", "avatar": "face_3.jpg", "wrapText": "Remaining Reason became an instant hit, praised for its haunting sound and emotional depth.", "rowType": "wrapped_song"))
    List3.AddRowData(CreateMap("Tag": "wrap2", "_height": 100, "title": "Ellie Beilish", "subtitle": "Bears of a fever", "avatar": "face_13.jpg", "wrapText": "Bears of a Fever captivated audiences with its intense energy and mysterious lyrics.", "rowType": "wrapped_song"))
    List3.AddRowData(CreateMap("Tag": "wrap3", "_height": 100, "title": "Sabrino Gardener", "subtitle": "Cappuccino", "avatar": "face_profile13.jpeg", "wrapText": "Cappuccino quickly gained attention for its smooth melody and relatable themes.", "rowType": "wrapped_song"))
    currentY = currentY + List3.getHeight + SECTION_GAP

    ' === DaisyUI: List (no header, clickable icon buttons) ===
    currentY = AddSectionTitle("Custom: List (no header, soft icon buttons)", currentY, maxW)
    List4.Clear
    List4.Initialize(Me, "List4")
    List4.Rounded = "rounded-box"
    List4.Shadow = "shadow-md"
    List4.BackgroundColor = "base-100"
    List4.Padding = 0
    List4.RowPadding = 16dip
    List4.Divider = True
    List4.DividerColor = "base-content/5"
    List4.RowHeight = 72dip
    List4.AutoHeight = True
    List4.AddToParent(pnlHost, PAGE_PAD, currentY, maxW, 320dip)
    List4.AddRowData(CreateMap("Tag": "nh1", "_height": 72, "title": "Dio Lupa", "subtitle": "Remaining Reason", "avatar": "face_3.jpg", "rowType": "noheader_song"))
    List4.AddRowData(CreateMap("Tag": "nh2", "_height": 72, "title": "Ellie Beilish", "subtitle": "Bears of a fever", "avatar": "face_13.jpg", "rowType": "noheader_song"))
    List4.AddRowData(CreateMap("Tag": "nh3", "_height": 72, "title": "Sabrino Gardener", "subtitle": "Cappuccino", "avatar": "face_profile13.jpeg", "rowType": "noheader_song"))
    currentY = currentY + List4.getHeight + SECTION_GAP

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
End Sub
#End Region

#Region RowContent
Private Sub List1_CreateRowContent(Index As Int)
    Dim Panel As B4XView = List1.GetCurrentRowPanel
    Dim Data As Map = List1.GetCurrentRowData
    If Panel = Null Or Panel.IsInitialized = False Or Data = Null Or Data.IsInitialized = False Then Return
    Dim isHeader As Boolean = Data.GetDefault("_header", False)
    If isHeader Then
        CreateHeaderRow(Panel, Data)
        Return
    End If
    Dim rowType As String = Data.GetDefault("rowType", "song")
    If rowType = "song" Then CreateSongRow(Panel, Data, True)
End Sub

Private Sub List2_CreateRowContent(Index As Int)
    Dim Panel As B4XView = List2.GetCurrentRowPanel
    Dim Data As Map = List2.GetCurrentRowData
    If Panel = Null Or Panel.IsInitialized = False Or Data = Null Or Data.IsInitialized = False Then Return
    Dim isHeader As Boolean = Data.GetDefault("_header", False)
    If isHeader Then
        CreateHeaderRow(Panel, Data)
        Return
    End If
    Dim rowType As String = Data.GetDefault("rowType", "ranked_song")
    If rowType = "ranked_song" Then CreateRankedSongRow(Panel, Data)
End Sub

Private Sub List3_CreateRowContent(Index As Int)
    Dim Panel As B4XView = List3.GetCurrentRowPanel
    Dim Data As Map = List3.GetCurrentRowData
    If Panel = Null Or Panel.IsInitialized = False Or Data = Null Or Data.IsInitialized = False Then Return
    Dim isHeader As Boolean = Data.GetDefault("_header", False)
    If isHeader Then
        CreateHeaderRow(Panel, Data)
        Return
    End If
    Dim rowType As String = Data.GetDefault("rowType", "wrapped_song")
    If rowType = "wrapped_song" Then CreateWrappedSongRow(Panel, Data)
End Sub

Private Sub List4_CreateRowContent(Index As Int)
    Dim Panel As B4XView = List4.GetCurrentRowPanel
    Dim Data As Map = List4.GetCurrentRowData
    If Panel = Null Or Panel.IsInitialized = False Or Data = Null Or Data.IsInitialized = False Then Return
    Dim rowType As String = Data.GetDefault("rowType", "noheader_song")
    If rowType = "noheader_song" Then CreateNoHeaderSongRow(Panel, Data)
End Sub
#End Region

#Region RowBuilders
Private Sub CreateHeaderRow(Panel As B4XView, Data As Map)
    Dim w As Int = Panel.Width
    Dim h As Int = Panel.Height
    Dim title As String = Data.GetDefault("title", "")
    Dim txtHeader As B4XDaisyText
    txtHeader.Initialize(Me, "")
    txtHeader.AddToParent(Panel, 16dip, 0, Max(1dip, w - 32dip), h)
    txtHeader.Text = title
    txtHeader.TextSize = 11
    txtHeader.TextColor = xui.Color_ARGB(160, 0, 0, 0)
    txtHeader.UpperCase = True
    txtHeader.VAlign = "CENTER"
    txtHeader.HAlign = "LEFT"
    txtHeader.SingleLine = True
End Sub

Private Sub CreateSongRow(Panel As B4XView, Data As Map, ShowHeart As Boolean)
    Dim w As Int = Panel.Width
    Dim h As Int = Panel.Height
    Dim av As B4XDaisyAvatar
    av.Initialize(Me, "")
    av.AddToParent(Panel, 8dip, (h - 48dip) / 2, 48dip, 48dip)
    av.RoundedBox = True
    av.AvatarSize = "size-10"
    av.Image = Data.GetDefault("avatar", "face_3.jpg")
    Dim btnSize As Int = 40dip
    Dim rightMargin As Int = btnSize + 8dip
    If ShowHeart Then rightMargin = rightMargin + btnSize + 4dip
    Dim textLeft As Int = 64dip
    Dim textW As Int = Max(1dip, w - textLeft - rightMargin)
    Dim txtTitle As B4XDaisyText
    txtTitle.Initialize(Me, "")
    txtTitle.AddToParent(Panel, textLeft, 10dip, textW, 24dip)
    txtTitle.Text = Data.GetDefault("title", "")
    txtTitle.TextSize = 15
    txtTitle.TextColor = xui.Color_RGB(17, 24, 39)
    txtTitle.FontBold = True
    txtTitle.SingleLine = True
    Dim txtSub As B4XDaisyText
    txtSub.Initialize(Me, "")
    txtSub.AddToParent(Panel, textLeft, 34dip, textW, 20dip)
    txtSub.Text = Data.GetDefault("subtitle", "")
    txtSub.TextSize = 11
    txtSub.TextColor = xui.Color_ARGB(160, 0, 0, 0)
    txtSub.UpperCase = True
    txtSub.FontBold = True
    txtSub.SingleLine = True
    Dim btnPlay As B4XDaisyIconButton
    btnPlay.Initialize(Me, "iconplay")
    btnPlay.setVariant("default")
    btnPlay.setStyle("ghost")
    btnPlay.setSize("md")
    btnPlay.setShape("square")
    btnPlay.setIconAsset("play-solid.svg")
    btnPlay.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
    btnPlay.setTag(Data.GetDefault("Tag", ""))
    btnPlay.AddToParent(Panel, w - rightMargin + 4dip, (h - btnSize) / 2, btnSize, btnSize)
    If ShowHeart Then
        Dim btnHeart As B4XDaisyIconButton
        btnHeart.Initialize(Me, "iconheart")
        btnHeart.setVariant("default")
        btnHeart.setStyle("ghost")
        btnHeart.setSize("md")
        btnHeart.setShape("square")
        btnHeart.setIconAsset("heart-solid.svg")
        btnHeart.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
        btnHeart.setTag(CreateMap("IsRed": False, "DataTag": Data.GetDefault("Tag", "")))
        btnHeart.AddToParent(Panel, w - rightMargin + btnSize + 8dip, (h - btnSize) / 2, btnSize, btnSize)
    End If
    av.setClickable(False)
    txtTitle.setClickable(False)
    txtSub.setClickable(False)
End Sub

Private Sub iconHeart_Click(Tag As Object)
    Dim btn As B4XDaisyIconButton = Sender
    If Tag Is Map Then
        Dim props As Map = Tag
        Dim isRed As Boolean = props.GetDefault("IsRed", False)
        If isRed Then
            btn.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
            btn.setVariant("default")
            props.Put("IsRed", False)
        Else
            btn.setIconColor(xui.Color_Red)
            btn.setVariant("error")
            props.Put("IsRed", True)
        End If
    End If
End Sub

Private Sub iconplay_Click(Tag As Object)
    ToastMessageShow("Play: " & Tag, False)
End Sub

Private Sub CreateRankedSongRow(Panel As B4XView, Data As Map)
    Dim w As Int = Panel.Width
    Dim h As Int = Panel.Height
    Dim txtNum As B4XDaisyText
    txtNum.Initialize(Me, "")
    txtNum.AddToParent(Panel, 4dip, 4dip, 48dip, h - 8dip)
    txtNum.Text = Data.GetDefault("number", "01")
    txtNum.TextSize = 36
    txtNum.TextColor = xui.Color_ARGB(77, 0, 0, 0)
    txtNum.FontBold = False
    txtNum.SingleLine = True
    Dim av As B4XDaisyAvatar
    av.Initialize(Me, "")
    av.AddToParent(Panel, 52dip, (h - 48dip) / 2, 48dip, 48dip)
    av.RoundedBox = True
    av.AvatarSize = "size-10"
    av.Image = Data.GetDefault("avatar", "face_3.jpg")
    Dim btnSize As Int = 40dip
    Dim textLeft As Int = 104dip
    Dim textW As Int = Max(1dip, w - textLeft - btnSize - 12dip)
    Dim txtTitle As B4XDaisyText
    txtTitle.Initialize(Me, "")
    txtTitle.AddToParent(Panel, textLeft, 10dip, textW, 24dip)
    txtTitle.Text = Data.GetDefault("title", "")
    txtTitle.TextSize = 15
    txtTitle.TextColor = xui.Color_RGB(17, 24, 39)
    txtTitle.FontBold = True
    txtTitle.SingleLine = True
    Dim txtSub As B4XDaisyText
    txtSub.Initialize(Me, "")
    txtSub.AddToParent(Panel, textLeft, 34dip, textW, 20dip)
    txtSub.Text = Data.GetDefault("subtitle", "")
    txtSub.TextSize = 11
    txtSub.TextColor = xui.Color_ARGB(160, 0, 0, 0)
    txtSub.UpperCase = True
    txtSub.FontBold = True
    txtSub.SingleLine = True
    Dim btnPlay As B4XDaisyIconButton
    btnPlay.Initialize(Me, "iconplay")
    btnPlay.setVariant("default")
    btnPlay.setStyle("ghost")
    btnPlay.setSize("md")
    btnPlay.setShape("square")
    btnPlay.setIconAsset("play-solid.svg")
    btnPlay.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
    btnPlay.setTag(Data.GetDefault("Tag", ""))
    btnPlay.AddToParent(Panel, w - btnSize - 8dip, (h - btnSize) / 2, btnSize, btnSize)
    txtNum.setClickable(False)
    av.setClickable(False)
    txtTitle.setClickable(False)
    txtSub.setClickable(False)
End Sub

Private Sub CreateWrappedSongRow(Panel As B4XView, Data As Map)
    Dim w As Int = Panel.Width
    Dim h As Int = Panel.Height
    Dim av As B4XDaisyAvatar
    av.Initialize(Me, "")
    av.AddToParent(Panel, 8dip, 8dip, 48dip, 48dip)
    av.RoundedBox = True
    av.AvatarSize = "size-10"
    av.Image = Data.GetDefault("avatar", "face_3.jpg")
    Dim btnSize As Int = 40dip
    Dim textLeft As Int = 64dip
    Dim textW As Int = Max(1dip, w - textLeft - btnSize * 2 - 16dip)
    Dim txtTitle As B4XDaisyText
    txtTitle.Initialize(Me, "")
    txtTitle.AddToParent(Panel, textLeft, 4dip, textW, 22dip)
    txtTitle.Text = Data.GetDefault("title", "")
    txtTitle.TextSize = 15
    txtTitle.TextColor = xui.Color_RGB(17, 24, 39)
    txtTitle.FontBold = True
    txtTitle.SingleLine = True
    Dim txtSub As B4XDaisyText
    txtSub.Initialize(Me, "")
    txtSub.AddToParent(Panel, textLeft, 26dip, textW, 16dip)
    txtSub.Text = Data.GetDefault("subtitle", "")
    txtSub.TextSize = 11
    txtSub.TextColor = xui.Color_ARGB(160, 0, 0, 0)
    txtSub.UpperCase = True
    txtSub.FontBold = True
    txtSub.SingleLine = True
    Dim wrapTop As Int = 50dip
    Dim wrapW As Int = Max(1dip, w - 32dip)
    Dim txtWrap As B4XDaisyText
    txtWrap.Initialize(Me, "")
    txtWrap.AddToParent(Panel, 16dip, wrapTop, wrapW, Max(1dip, h - wrapTop - 4dip))
    txtWrap.Text = Data.GetDefault("wrapText", "")
    txtWrap.TextSize = 11
    txtWrap.TextColor = xui.Color_ARGB(140, 0, 0, 0)
    txtWrap.SingleLine = False
    Dim btnPlay As B4XDaisyIconButton
    btnPlay.Initialize(Me, "iconplay")
    btnPlay.setVariant("default")
    btnPlay.setStyle("ghost")
    btnPlay.setSize("md")
    btnPlay.setShape("square")
    btnPlay.setIconAsset("play-solid.svg")
    btnPlay.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
    btnPlay.setTag(Data.GetDefault("Tag", ""))
    btnPlay.AddToParent(Panel, w - btnSize * 2 - 12dip, 12dip, btnSize, btnSize)
    Dim btnHeart As B4XDaisyIconButton
    btnHeart.Initialize(Me, "iconheart")
    btnHeart.setVariant("default")
    btnHeart.setStyle("ghost")
    btnHeart.setSize("md")
    btnHeart.setShape("square")
    btnHeart.setIconAsset("heart-solid.svg")
    btnHeart.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
    btnHeart.setTag(CreateMap("IsRed": False, "DataTag": Data.GetDefault("Tag", "")))
    btnHeart.AddToParent(Panel, w - btnSize - 8dip, 12dip, btnSize, btnSize)
    av.setClickable(False)
    txtTitle.setClickable(False)
    txtSub.setClickable(False)
    txtWrap.setClickable(False)
End Sub

Private Sub CreateNoHeaderSongRow(Panel As B4XView, Data As Map)
    Dim w As Int = Panel.Width
    Dim h As Int = Panel.Height
    Dim av As B4XDaisyAvatar
    av.Initialize(Me, "")
    av.AddToParent(Panel, 8dip, (h - 48dip) / 2, 48dip, 48dip)
    av.RoundedBox = True
    av.AvatarSize = "size-10"
    av.Image = Data.GetDefault("avatar", "face_3.jpg")
    Dim btnSize As Int = 40dip
    Dim rightMargin As Int = btnSize * 2 + 12dip
    Dim textLeft As Int = 64dip
    Dim textW As Int = Max(1dip, w - textLeft - rightMargin)
    Dim txtTitle As B4XDaisyText
    txtTitle.Initialize(Me, "")
    txtTitle.AddToParent(Panel, textLeft, 10dip, textW, 24dip)
    txtTitle.Text = Data.GetDefault("title", "")
    txtTitle.TextSize = 15
    txtTitle.TextColor = xui.Color_RGB(17, 24, 39)
    txtTitle.FontBold = True
    txtTitle.SingleLine = True
    Dim txtSub As B4XDaisyText
    txtSub.Initialize(Me, "")
    txtSub.AddToParent(Panel, textLeft, 34dip, textW, 20dip)
    txtSub.Text = Data.GetDefault("subtitle", "")
    txtSub.TextSize = 11
    txtSub.TextColor = xui.Color_ARGB(160, 0, 0, 0)
    txtSub.UpperCase = True
    txtSub.FontBold = True
    txtSub.SingleLine = True
    Dim btnPlay As B4XDaisyIconButton
    btnPlay.Initialize(Me, "nhplay")
    btnPlay.setVariant("primary")
    btnPlay.setStyle("soft")
    btnPlay.setSize("md")
    btnPlay.setShape("circle")
    btnPlay.setIconAsset("play-solid.svg")
    btnPlay.setTag(Data.GetDefault("Tag", ""))
    btnPlay.AddToParent(Panel, w - rightMargin, (h - btnSize) / 2, btnSize, btnSize)
    Dim btnHeart As B4XDaisyIconButton
    btnHeart.Initialize(Me, "nhheart")
    btnHeart.setVariant("error")
    btnHeart.setStyle("soft")
    btnHeart.setSize("md")
    btnHeart.setShape("circle")
    btnHeart.setIconAsset("heart-solid.svg")
    btnHeart.setTag(CreateMap("IsRed": False, "DataTag": Data.GetDefault("Tag", "")))
    btnHeart.AddToParent(Panel, w - rightMargin + btnSize + 4dip, (h - btnSize) / 2, btnSize, btnSize)
    av.setClickable(False)
    txtTitle.setClickable(False)
    txtSub.setClickable(False)
End Sub
#End Region

#Region BaseEvents
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost <> Null And svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Helpers
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + title.GetComputedHeight + 2dip
End Sub

Private Sub List1_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List1 Clicked: " & Index & " Tag=" & Tag, False)
End Sub

Private Sub List1_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List1 Long: " & Index, False)
End Sub

Private Sub List2_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List2 Clicked: " & Index & " Tag=" & Tag, False)
End Sub

Private Sub List2_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List2 Long: " & Index, False)
End Sub

Private Sub List3_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List3 Clicked: " & Index & " Tag=" & Tag, False)
End Sub

Private Sub List3_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List3 Long: " & Index, False)
End Sub

Private Sub List4_ItemClick(Index As Int, Tag As Object)
    ToastMessageShow("List4 Clicked: " & Index & " Tag=" & Tag, False)
End Sub

Private Sub List4_ItemLongClick(Index As Int, Tag As Object)
    ToastMessageShow("List4 Long: " & Index, False)
End Sub

Private Sub nhplay_Click(Tag As Object)
    ToastMessageShow("Play: " & Tag, False)
End Sub

Private Sub nhheart_Click(Tag As Object)
    Dim btn As B4XDaisyIconButton = Sender
    If Tag Is Map Then
        Dim props As Map = Tag
        Dim isRed As Boolean = props.GetDefault("IsRed", False)
        If isRed Then
            btn.setIconColor(xui.Color_ARGB(170, 0, 0, 0))
            btn.setVariant("default")
            btn.setStyle("ghost")
            props.Put("IsRed", False)
        Else
            btn.setIconColor(xui.Color_Red)
            btn.setVariant("error")
            btn.setStyle("soft")
            props.Put("IsRed", True)
        End If
    End If
End Sub
#End Region