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
    Private pageScroll As B4XDaisyPageScroll
    Private pnlHost As B4XView
    Private pad As Int
    Private gap As Int
    Private maxW As Int
    Private y As Int
    Private mainStats As B4XDaisyStat
    Private btnFeedback As B4XDaisyButton
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_White
    Root.RemoveAllViews

    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
    pnlHost = pageScroll.Panel

    RenderPage(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
    RenderPage(Width, Height)
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub RenderPage(W As Int, H As Int)
    If pnlHost.IsInitialized = False Then Return

    pageScroll.Clear

    pad = pageScroll.PagePadding
    gap = pageScroll.YGap
    maxW = pageScroll.UsableWidth
    y = pad

    y = pageScroll.AddSectionTitle("Dashboard", y, False) + gap

    mainStats.Initialize(Me, "mainStats")
    mainStats.Orientation = "horizontal"
    mainStats.EqualWidths = True
    mainStats.MaxWidth = maxW
    mainStats.Rounded = "rounded-box"
    mainStats.Shadow = "md"
    mainStats.AddToParent(pnlHost, pad, y, maxW, 100dip)

    Dim s1 As B4XDaisyStatItem = mainStats.AddItem1("statTodaySales", "Today Sales", "1250.5")
    s1.Prefix = "$"
    s1.DecimalPlaces = 2
    s1.UseGrouping = True
    s1.Variant = "primary"
    mainStats.AddItem(s1)

    Dim s2 As B4XDaisyStatItem = mainStats.AddItem1("statActiveUsers", "Active Users", "87")
    s2.Variant = "success"
    mainStats.AddItem(s2)

    Dim s3 As B4XDaisyStatItem = mainStats.AddItem1("statConversionRate", "Conversion Rate", "4.2%")
    s3.Variant = "info"
    mainStats.AddItem(s3)

    mainStats.Refresh
    y = y + mainStats.GetComputedHeight + gap

    btnFeedback.Initialize(Me, "btnFeedback")
    btnFeedback.AddToParent(pnlHost, pad, y, maxW, 48dip)
    btnFeedback.Text = "Try confirmation dialog"
    btnFeedback.Variant = "primary"
    y = y + btnFeedback.GetComputedHeight + gap

    pageScroll.AutoFit
End Sub

Private Sub btnFeedback_Click
    Dim sf As Object = B4XPages.MainPage.ShowSwalConfirm("Delete item?", "This action cannot be undone. Are you sure you want to proceed?", "Delete", "Cancel")
    Wait For (sf) Complete (Result As B4XDaisySweetAlertResult)
    If Result.IsConfirmed Then
        Log("Item deleted")
    End If
End Sub
