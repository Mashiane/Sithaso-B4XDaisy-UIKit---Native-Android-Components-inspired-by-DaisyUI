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
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "Link")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD

    ' #region Example 1: link (base — cursor-pointer + underline)
    y = AddSectionTitle("link", y, maxW)
    Dim c1 As B4XDaisyText
    c1.Initialize(Me, "lnk")
    c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c1.Text = "I am a simple link"
    c1.Link = True
    c1.Underline = True
    c1.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c1.Tag = "I am a simple link"
    y = y + c1.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 2: link link-hover (no-underline, underline on hover)
    y = AddSectionTitle("link link-hover", y, maxW)
    Dim c2 As B4XDaisyText
    c2.Initialize(Me, "lnk")
    c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c2.Text = "Only underline on hover"
    c2.Link = True
    c2.Underline = False
    c2.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c2.Tag = "Only underline on hover"
    y = y + c2.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 3: link-primary
    y = AddSectionTitle("link-primary", y, maxW)
    Dim c3 As B4XDaisyText
    c3.Initialize(Me, "lnk")
    c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c3.Text = "Primary color link"
    c3.Link = True
    c3.Underline = True
    c3.setTextColorVariant("link-primary")
    c3.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c3.Tag = "link-primary"
    y = y + c3.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 4: link-secondary
    y = AddSectionTitle("link-secondary", y, maxW)
    Dim c4 As B4XDaisyText
    c4.Initialize(Me, "lnk")
    c4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c4.Text = "Secondary color link"
    c4.Link = True
    c4.Underline = True
    c4.setTextColorVariant("link-secondary")
    c4.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c4.Tag = "link-secondary"
    y = y + c4.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 5: link-accent
    y = AddSectionTitle("link-accent", y, maxW)
    Dim c5 As B4XDaisyText
    c5.Initialize(Me, "lnk")
    c5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c5.Text = "Accent color link"
    c5.Link = True
    c5.Underline = True
    c5.setTextColorVariant("link-accent")
    c5.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c5.Tag = "link-accent"
    y = y + c5.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 6: link-neutral
    y = AddSectionTitle("link-neutral", y, maxW)
    Dim c6 As B4XDaisyText
    c6.Initialize(Me, "lnk")
    c6.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c6.Text = "Neutral color link"
    c6.Link = True
    c6.Underline = True
    c6.setTextColorVariant("link-neutral")
    c6.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c6.Tag = "link-neutral"
    y = y + c6.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 7: link-success
    y = AddSectionTitle("link-success", y, maxW)
    Dim c7 As B4XDaisyText
    c7.Initialize(Me, "lnk")
    c7.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c7.Text = "Success color link"
    c7.Link = True
    c7.Underline = True
    c7.setTextColorVariant("link-success")
    c7.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c7.Tag = "link-success"
    y = y + c7.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 8: link-info
    y = AddSectionTitle("link-info", y, maxW)
    Dim c8 As B4XDaisyText
    c8.Initialize(Me, "lnk")
    c8.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c8.Text = "Info color link"
    c8.Link = True
    c8.Underline = True
    c8.setTextColorVariant("link-info")
    c8.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c8.Tag = "link-info"
    y = y + c8.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 9: link-warning
    y = AddSectionTitle("link-warning", y, maxW)
    Dim c9 As B4XDaisyText
    c9.Initialize(Me, "lnk")
    c9.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c9.Text = "Warning color link"
    c9.Link = True
    c9.Underline = True
    c9.setTextColorVariant("link-warning")
    c9.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c9.Tag = "link-warning"
    y = y + c9.GetComputedHeight + 8dip
    ' #endregion

    ' #region Example 10: link-error
    y = AddSectionTitle("link-error", y, maxW)
    Dim c10 As B4XDaisyText
    c10.Initialize(Me, "lnk")
    c10.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
    c10.Text = "Error color link"
    c10.Link = True
    c10.Underline = True
    c10.setTextColorVariant("link-error")
    c10.Url = "https://www.b4x.com/android/forum/threads/b4x-b4a-b4xdaisy-ui-kit-native-components-inspired-by-daisyui-tailwind.170352/"
    c10.Tag = "link-error"
    y = y + c10.GetComputedHeight + 8dip
    ' #endregion

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 16
    title.FontBold = True
    Return Y + title.GetComputedHeight + 4dip
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

#End Region
