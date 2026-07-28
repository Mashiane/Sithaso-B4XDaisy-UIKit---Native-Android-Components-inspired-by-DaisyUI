B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=2.00
@EndOfDesignText@
#IgnoreWarnings:12,9

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

    ' === Solid square icon buttons ===
    currentY = AddSectionTitle("Solid (Square)", currentY, maxW)
    Dim row1 As List
    row1.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "info", "success", "warning", "error")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant(v)
        btn.setStyle("solid")
        btn.setShape("square")
        btn.setTag("solid-square-" & v)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row1.Add(btn.getView)
    Next
    currentY = LayoutRow(row1, currentY, maxW, 8dip)

    ' === Solid circle icon buttons ===
    currentY = AddSectionTitle("Solid (Circle)", currentY, maxW)
    Dim row2 As List
    row2.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "info", "success", "warning", "error")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant(v)
        btn.setStyle("solid")
        btn.setShape("circle")
        btn.setTag("solid-circle-" & v)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row2.Add(btn.getView)
    Next
    currentY = LayoutRow(row2, currentY, maxW, 8dip)

    ' === Soft ===
    currentY = AddSectionTitle("Soft", currentY, maxW)
    Dim row3 As List
    row3.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "info", "success", "warning", "error")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant(v)
        btn.setStyle("soft")
        btn.setShape("circle")
        btn.setTag("soft-" & v)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row3.Add(btn.getView)
    Next
    currentY = LayoutRow(row3, currentY, maxW, 8dip)

    ' === Outline ===
    currentY = AddSectionTitle("Outline", currentY, maxW)
    Dim row4 As List
    row4.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "info", "success", "warning", "error")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant(v)
        btn.setStyle("outline")
        btn.setShape("circle")
        btn.setTag("outline-" & v)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row4.Add(btn.getView)
    Next
    currentY = LayoutRow(row4, currentY, maxW, 8dip)

    ' === Dash ===
    currentY = AddSectionTitle("Dash", currentY, maxW)
    Dim rowDash As List
    rowDash.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "info", "success", "warning", "error")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant(v)
        btn.setStyle("dash")
        btn.setShape("circle")
        btn.setTag("dash-" & v)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        rowDash.Add(btn.getView)
    Next
    currentY = LayoutRow(rowDash, currentY, maxW, 8dip)

    ' === Ghost ===
    currentY = AddSectionTitle("Ghost", currentY, maxW)
    Dim row5 As List
    row5.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "secondary", "accent")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant(v)
        btn.setStyle("ghost")
        btn.setShape("circle")
        btn.setsize("md")
        btn.setTag("ghost-" & v)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row5.Add(btn.getView)
    Next
    currentY = LayoutRow(row5, currentY, maxW, 8dip)

    ' === Sizes ===
    currentY = AddSectionTitle("Sizes (Primary, Circle)", currentY, maxW)
    Dim row6 As List
    row6.Initialize
    For Each s As String In Array As String("xs", "sm", "md", "lg", "xl")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant("primary")
        btn.setStyle("solid")
        btn.setSize(s)
        btn.setShape("circle")
        btn.setTag("size-circle-" & s)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row6.Add(btn.getView)
    Next
    currentY = LayoutRow(row6, currentY, maxW, 8dip)

    ' === Sizes Square ===
    currentY = AddSectionTitle("Sizes (Primary, Square)", currentY, maxW)
    Dim row7 As List
    row7.Initialize
    For Each s As String In Array As String("xs", "sm", "md", "lg", "xl")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant("primary")
        btn.setStyle("solid")
        btn.setSize(s)
        btn.setShape("square")
        btn.setTag("size-square-" & s)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row7.Add(btn.getView)
    Next
    currentY = LayoutRow(row7, currentY, maxW, 8dip)

    ' === Custom Sizes (new CustomSize property) ===
    ' CustomSize (dip) overrides the Size token. The button renders at
    ' CustomSize x CustomSize, and the icon auto-scales to ~40% of that
    ' size (clamped to a 12dip minimum), so both button and icon grow.
    currentY = AddSectionTitle("Custom Sizes - Square (icon scales with button)", currentY, maxW)
    Dim row7b As List
    row7b.Initialize
    For Each cs As Int In Array As Int(24, 36, 48, 64, 80)
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant("primary")
        btn.setStyle("solid")
        btn.setCustomSize(cs)
        btn.setShape("square")
        btn.setTag("custom-square-" & cs)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row7b.Add(btn.getView)
    Next
    currentY = LayoutRow(row7b, currentY, maxW, 8dip)

    ' === Custom Sizes - Circle (shape preserved) ===
    currentY = AddSectionTitle("Custom Sizes - Circle (shape preserved)", currentY, maxW)
    Dim row7c As List
    row7c.Initialize
    For Each cs As Int In Array As Int(24, 36, 48, 64, 80)
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ib")
        btn.setVariant("secondary")
        btn.setStyle("solid")
        btn.setCustomSize(cs)
        btn.setShape("circle")
        btn.setTag("custom-circle-" & cs)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row7c.Add(btn.getView)
    Next
    currentY = LayoutRow(row7c, currentY, maxW, 8dip)

    ' === Active State ===
    currentY = AddSectionTitle("Active State", currentY, maxW)
    Dim row8 As List
    row8.Initialize
    For Each v As String In Array As String("primary", "secondary", "accent")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ibactive")
        btn.setVariant(v)
        btn.setStyle("solid")
        btn.setShape("circle")
        btn.setTag("active-" & v)
        btn.setActive(True)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row8.Add(btn.getView)
    Next
    currentY = LayoutRow(row8, currentY, maxW, 8dip)
    ' === Loading State ===
    currentY = AddSectionTitle("Loading State", currentY, maxW)
    Dim row9 As List
    row9.Initialize
    For Each v As String In Array As String("default", "neutral", "primary", "info", "success", "warning", "error")
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ibloading")
        btn.setVariant(v)
        btn.setStyle("solid")
        btn.setShape("circle")
        btn.setTag("loading-" & v)
        btn.setLoading(True)
        btn.setIconAsset("heart-solid.svg")
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row9.Add(btn.getView)
    Next
    currentY = LayoutRow(row9, currentY, maxW, 8dip)

    ' === Different icons ===
    currentY = AddSectionTitle("Different Icons", currentY, maxW)
    Dim row10 As List
    row10.Initialize
    Dim icons() As String = Array As String("play-solid.svg", "heart-solid.svg", "check-solid.svg", "xmark-solid.svg", "bell-solid.svg", "gear.svg")
    For Each icon As String In icons
        Dim btn As B4XDaisyIconButton
        btn.Initialize(Me, "ibicon")
        btn.setVariant("primary")
        btn.setStyle("solid")
        btn.setShape("circle")
        btn.setTag(icon)
        btn.setIconAsset(icon)
        btn.AddToParent(pnlHost, 0, 0, 0, 0)
        row10.Add(btn.getView)
    Next
    currentY = LayoutRow(row10, currentY, maxW, 8dip)

    pnlHost.Height = Max(Height, currentY + PAGE_PAD)
End Sub
#End Region

#Region Events
Private Sub ib_Click(Tag As Object)
    B4XPages.MainPage.ShowToast("Clicked: " & Tag, False)
End Sub


Private Sub ibloading_Click(Tag As Object)
    B4XPages.MainPage.ShowToast("Loading: " & Tag, False)
End Sub
Private Sub ibactive_Click(Tag As Object)
    B4XPages.MainPage.ShowToast("Active: " & Tag, False)
End Sub

Private Sub ibicon_Click(Tag As Object)
    B4XPages.MainPage.ShowToast("Icon: " & Tag, False)
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
    title.SingleLine = True
    Return Y + title.GetComputedHeight + 4dip
End Sub

Private Sub LayoutRow(Buttons As List, Y As Int, MaxWidth As Int, Gap As Int) As Int
    If Buttons.IsInitialized = False Or Buttons.Size = 0 Then Return Y
    Dim totalButtonWidth As Int = 0
    For Each v As B4XView In Buttons
        totalButtonWidth = totalButtonWidth + v.Width
    Next
    Dim totalGap As Int = Gap * (Buttons.Size - 1)
    Dim totalRowWidth As Int = totalButtonWidth + totalGap
    Dim startX As Int = PAGE_PAD + Max(0, (MaxWidth - totalRowWidth) / 2)
    Dim currentX As Int = startX
    Dim maxH As Int = 0
    For Each v As B4XView In Buttons
        v.SetLayoutAnimated(0, currentX, Y, v.Width, v.Height)
        currentX = currentX + v.Width + Gap
        maxH = Max(maxH, v.Height)
    Next
    Return Y + maxH + SECTION_GAP
End Sub
#End Region
