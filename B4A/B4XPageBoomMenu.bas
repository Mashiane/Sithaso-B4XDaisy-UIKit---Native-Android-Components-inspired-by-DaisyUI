B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private pageScroll As B4XDaisyPageScroll
    Private pnlHost As B4XView
    Private boom As B4XDaisyBoomMenu
    Private mbBoomAdded As Boolean = False
    ' Benchmark: click->DidShow latency, surfaced in the in-app Events Log so it can
    ' be read without the B4A IDE remote logger (which is what routes Log() to logcat).
    Private miWillShowMs As Long = 0
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Log("BoomPage: B4XPage_Created start, Root=" & Root1.Width & "x" & Root1.Height)
    Root = Root1
    Root.Color = xui.Color_RGB(246, 248, 251)

    Try
        pageScroll.Initialize(Me, "pageScroll")
        pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
        pnlHost = pageScroll.Panel
        Log("BoomPage: pageScroll added, pnlHost valid=" & pnlHost.IsInitialized)
    Catch
        Log("B4XPageBoomMenu.B4XPage_Created: " & LastException.Message)
    End Try

    Try
        BuildBoomMenu
        Log("BoomPage: BuildBoomMenu done, buttonCount=" & boom.GetButtonCount)
    Catch
        Log("B4XPageBoomMenu.B4XPage_Created: " & LastException.Message)
    End Try

    RenderExamples(Root.Width, Root.Height)

    ' Add the trigger FAB here, NOT in B4XPage_Resize. B4XPage_Resize is not guaranteed
    ' to fire on first show on this page (it never logged), so adding the boom only in
    ' Resize left the trigger unattached. Mirrors B4XPageFab, which adds the FAB in
    ' B4XPage_Created (BuildPage).
    EnsureBoomAdded(Root.Width, Root.Height)

    Log("BoomPage: B4XPage_Created done")
End Sub

' Add the boom trigger on first call, reposition on later calls. Safe to call from
' both B4XPage_Created and B4XPage_Resize.
Private Sub EnsureBoomAdded(Width As Int, Height As Int)
    If Width <= 0 Or Height <= 0 Then Return
    ' Note: do NOT guard on boom.getIsInitialized here - that checks mBase, which is
    ' only created inside AddToParent. BuildBoomMenu (boom.Initialize) runs first, so
    ' the instance is valid; the Try/Catch covers any failure.
    Dim margin As Int = 24dip
    Dim sz As Int = 56dip
    Dim bLeft As Int = Width - sz - margin
    Dim bTop As Int = Height - sz - margin
    Try
        If mbBoomAdded = False Then
            Log("BoomPage: Adding boom to Root at " & bLeft & "," & bTop & " " & sz & "x" & sz)
            boom.AddToParent(Root, bLeft, bTop, sz, sz)
            mbBoomAdded = True
            Log("BoomPage: boom added, isInit=" & boom.getIsInitialized)
        Else
            boom.Reposition(bLeft, bTop, sz, sz)
        End If
    Catch
        Log("B4XPageBoomMenu.EnsureBoomAdded: " & LastException.Message)
    End Try
End Sub
#End Region

#Region BoomMenu Configuration
Private Sub BuildBoomMenu
    boom.Initialize(Me, "boomdemo")
    boom.setButtonType("SimpleCircle")
    boom.setPiecePlace("DOT_9_1")
    boom.setButtonPlace("SC_9_1")
    boom.setBoomType("PARABOLA_1")
    boom.setEaseType("EaseOutBack")
    boom.setOrderType("DEFAULT")
    boom.setDuration(300)
    boom.setPieceColor(xui.Color_RGB(121, 77, 255))
    boom.setButtonColor(xui.Color_RGB(121, 77, 255))
    boom.setShadowLevel("md")
    boom.setBackdropEnabled(True)
    boom.setBackdropColor(0x55000000)
    boom.setTriggerIconName("plus-solid.svg")
    boom.setTriggerText("")
    ' NOTE: *Dip setters store the value as-is (no scaling). Pass dip-scaled values
    ' via the B4X "dip" keyword, otherwise sizes are treated as raw pixels and the
    ' trigger renders as a tiny (~20dip) dot. Matches the B4XDaisyFab convention.
    boom.setTriggerSizeDip(56dip)
    boom.setRotateTrigger(True)
    boom.setAutoCloseOnActionClick(True)
    boom.setButtonSizeDip(48dip)
    boom.setButtonGapDip(12dip)
    boom.setButtonCornerRadiusDip(24dip)
    boom.AddButton("Alert", "bell-solid.svg", "alert")
    boom.AddButton("Camera", "camera-solid.svg", "camera")
    boom.AddButton("Favourite", "heart-solid.svg", "favourite")
    boom.AddButton("Message", "envelope-solid.svg", "message")
    boom.AddButton("Music", "music-solid.svg", "music")
End Sub
#End Region

#Region Demo UI
Private Sub RenderExamples(Width As Int, Height As Int)
    Try
        pageScroll.Clear

        Dim maxW As Int = pageScroll.UsableWidth
        Dim padding As Int = pageScroll.PagePadding
        Dim gap As Int = pageScroll.YGap
        Dim y As Int = padding

        Dim pnlInfo As B4XView
        pnlInfo = xui.CreatePanel("")
        pnlInfo.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(224, 230, 237), 18dip)
        pnlHost.AddView(pnlInfo, padding, y, maxW, 180dip)

        Dim lblTitle As Label
        lblTitle.Initialize("")
        lblTitle.Text = "B4XDaisyBoomMenu (BoomMenu-Inspired)"
        lblTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblTitle.TextSize = 20
        lblTitle.Typeface = Typeface.DEFAULT_BOLD
        pnlInfo.AddView(lblTitle, 16dip, 16dip, pnlInfo.Width - 32dip, 28dip)

        Dim lblBody As Label
        lblBody.Initialize("")
        lblBody.Text = "Tap the FAB trigger (bottom-right) to boom! Buttons animate out from the trigger position."
        lblBody.TextColor = xui.Color_RGB(71, 85, 105)
        lblBody.TextSize = 14
        pnlInfo.AddView(lblBody, 16dip, 52dip, pnlInfo.Width - 32dip, pnlInfo.Height - 68dip)

        y = y + 180dip + gap

        Dim pnlConfig As B4XView
        pnlConfig = xui.CreatePanel("")
        pnlConfig.SetColorAndBorder(xui.Color_White, 1dip, xui.Color_RGB(224, 230, 237), 18dip)
        pnlHost.AddView(pnlConfig, padding, y, maxW, 380dip)

        Dim lblConfigTitle As Label
        lblConfigTitle.Initialize("")
        lblConfigTitle.Text = "Configuration"
        lblConfigTitle.TextColor = xui.Color_RGB(30, 41, 59)
        lblConfigTitle.TextSize = 16
        lblConfigTitle.Typeface = Typeface.DEFAULT_BOLD
        pnlConfig.AddView(lblConfigTitle, 16dip, 16dip, pnlConfig.Width - 32dip, 24dip)

        AddSpinnerRow(pnlConfig, "Boom Type:", "spBoomType", Array As String("LINE", "PARABOLA_1", "PARABOLA_2", "PARABOLA_3", "PARABOLA_4", "H_THROW_1", "H_THROW_2", "RANDOM"), 60dip, 1)
        AddSpinnerRow(pnlConfig, "Ease Type:", "spEaseType", Array As String("Linear", "EaseOutBack", "EaseOutElastic", "EaseOutBounce", "EaseOutCubic", "EaseOutQuad", "EaseInOutCubic"), 110dip, 1)
        AddSpinnerRow(pnlConfig, "Piece Place:", "spPiecePlace", Array As String("DOT_1", "DOT_3", "DOT_5", "DOT_7", "DOT_9_1", "DOT_9_2", "DOT_9_3", "DOT_3_3", "DOT_5_4", "DOT_8_5", "DOT_9_3", "HORIZONTAL", "VERTICAL"), 160dip, 4)
        AddSpinnerRow(pnlConfig, "Button Place:", "spButtonPlace", Array As String("SC_1", "SC_3", "SC_5", "SC_7", "SC_9_1", "SC_9_2", "SC_9_3", "SC_2_1", "SC_3_3", "SC_4_2", "SC_5_4", "SC_6_3", "SC_7_5", "SC_8_2", "SC_8_5", "SC_9_3", "HORIZONTAL", "VERTICAL", "HAM_1", "HAM_2", "HAM_3"), 210dip, 4)
        AddSpinnerRow(pnlConfig, "Button Type:", "spButtonType", Array As String("SimpleCircle", "TextInsideCircle", "TextOutsideCircle", "Ham"), 260dip, 0)
        AddSeekBarRow(pnlConfig, "Duration:", "sbDuration", 100, 1000, 300, 310dip)

        y = y + 380dip + gap

        Dim pnlEvents As B4XView
        pnlEvents = xui.CreatePanel("")
        pnlEvents.SetColorAndBorder(xui.Color_RGB(30, 41, 59), 1dip, xui.Color_RGB(51, 65, 85), 18dip)
        pnlHost.AddView(pnlEvents, padding, y, maxW, 200dip)

        Dim lblEventsTitle As Label
        lblEventsTitle.Initialize("")
        lblEventsTitle.Text = "Events Log"
        lblEventsTitle.TextColor = xui.Color_RGB(148, 163, 184)
        lblEventsTitle.TextSize = 14
        lblEventsTitle.Typeface = Typeface.DEFAULT_BOLD
        pnlEvents.AddView(lblEventsTitle, 16dip, 12dip, pnlEvents.Width - 32dip, 20dip)

        Dim lblEvents As Label
        lblEvents.Initialize("")
        lblEvents.Text = "Waiting for events..."
        lblEvents.TextColor = xui.Color_RGB(148, 163, 184)
        lblEvents.TextSize = 12
        pnlEvents.AddView(lblEvents, 16dip, 38dip, pnlEvents.Width - 32dip, pnlEvents.Height - 50dip)
        lblEvents.Tag = "events_log"

        pageScroll.AutoFit
    Catch
        Log("B4XPageBoomMenu.RenderExamples: " & LastException.Message)
    End Try
End Sub

Private Sub AddSpinnerRow(Parent As B4XView, LabelText As String, SpinnerName As String, Items() As String, Top As Int, DefaultIndex As Int)
    Dim lbl As Label
    lbl.Initialize("")
    lbl.Text = LabelText
    lbl.TextColor = xui.Color_RGB(71, 85, 105)
    lbl.TextSize = 13
    Parent.AddView(lbl, 16dip, Top, 120dip, 24dip)

    Dim sp As Spinner
    ' Event name = SpinnerName so <SpinnerName>_ItemClick fires and applies the change.
    ' Initialize("") made the spinners inert (no events, no handlers).
    sp.Initialize(SpinnerName)
    For Each item As String In Items
        sp.Add(item)
    Next
    If DefaultIndex >= 0 And DefaultIndex < Items.Length Then sp.SelectedIndex = DefaultIndex
    Parent.AddView(sp, 140dip, Top - 2dip, Parent.Width - 160dip, 30dip)
    sp.Tag = SpinnerName
End Sub

Private Sub AddSeekBarRow(Parent As B4XView, LabelText As String, SeekBarName As String, MinVal As Int, MaxVal As Int, DefaultVal As Int, Top As Int)
    Dim lbl As Label
    lbl.Initialize("")
    lbl.Text = LabelText
    lbl.TextColor = xui.Color_RGB(71, 85, 105)
    lbl.TextSize = 13
    Parent.AddView(lbl, 16dip, Top, 120dip, 24dip)

    Dim sb As SeekBar
    ' Event name = SeekBarName so <SeekBarName>_ValueChanged fires and applies the change.
    sb.Initialize(SeekBarName)
    sb.Max = MaxVal - MinVal
    sb.Value = DefaultVal - MinVal
    Parent.AddView(sb, 140dip, Top + 2dip, Parent.Width - 160dip, 30dip)
    sb.Tag = SeekBarName
End Sub
#End Region

#Region Base Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    Log("BoomPage: B4XPage_Resize " & Width & "x" & Height & " boomAdded=" & mbBoomAdded)
    If Width <= 0 Or Height <= 0 Then Return
    Try
        If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
        RenderExamples(Width, Height)
    Catch
        Log("B4XPageBoomMenu.B4XPage_Resize: " & LastException.Message)
    End Try

    EnsureBoomAdded(Width, Height)
End Sub

Private Sub B4XPage_Appear
    Log("BoomPage: B4XPage_Appear")
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Demo Events
Private Sub boomdemo_BoomButtonClick(Index As Int, Tag As Object)
    LogEvent("BoomButtonClick: Index=" & Index & ", Tag=" & Tag)
End Sub

Private Sub boomdemo_BackgroundClick
    LogEvent("BackgroundClick")
End Sub

Private Sub boomdemo_WillShow
    miWillShowMs = DateTime.Now
    LogEvent("WillShow")
End Sub

Private Sub boomdemo_DidShow
    LogEvent("DidShow delay=" & (DateTime.Now - miWillShowMs) & "ms")
End Sub

Private Sub boomdemo_WillHide
    LogEvent("WillHide")
End Sub

Private Sub boomdemo_DidHide
    LogEvent("DidHide")
End Sub

#Region Config Controls
' Spinners and the seekbar drive the boom settings live. Previously the controls were
' initialized with "" (no event name) and had no handlers, so changing them did nothing.
' The component setters handle refresh where needed: setButtonType/setPiecePlace/
' setButtonPlace call Refresh; setBoomType/setEaseType/setDuration apply on the next Boom.
Private Sub spBoomType_ItemClick (Position As Int, Value As Object)
    If boom.getIsInitialized = False Then Return
    Dim s As String = Value
    boom.setBoomType(s)
End Sub

Private Sub spEaseType_ItemClick (Position As Int, Value As Object)
    If boom.getIsInitialized = False Then Return
    Dim s As String = Value
    boom.setEaseType(s)
End Sub

Private Sub spPiecePlace_ItemClick (Position As Int, Value As Object)
    If boom.getIsInitialized = False Then Return
    Dim s As String = Value
    boom.setPiecePlace(s)
End Sub

Private Sub spButtonPlace_ItemClick (Position As Int, Value As Object)
    If boom.getIsInitialized = False Then Return
    Dim s As String = Value
    boom.setButtonPlace(s)
End Sub

Private Sub spButtonType_ItemClick (Position As Int, Value As Object)
    If boom.getIsInitialized = False Then Return
    Dim s As String = Value
    boom.setButtonType(s)
End Sub

' sbDuration: Max = 1000-100 = 900, Value = duration-100, so actual duration = Value + 100.
' Ignore programmatic changes (UserChanged = False) to avoid feedback loops.
Private Sub sbDuration_ValueChanged (Value As Int, UserChanged As Boolean)
    If UserChanged = False Then Return
    If boom.getIsInitialized = False Then Return
    boom.setDuration(Value + 100)
End Sub
#End Region

Private Sub LogEvent(Message As String)
    Log("BoomPage event: " & Message)
    Try
        For Each v As B4XView In pnlHost.GetAllViewsRecursive
            ' Null-safe tag compare: GetAllViewsRecursive returns views with Null/Map/Object
            ' tags, and "v.Tag = ""events_log""" NPEs when Tag is Null (Object.equals on null).
            If v.Tag Is String Then
                If v.Tag = "events_log" Then
                    Dim lbl As Label = v
                    Dim timestamp As String = DateTime.Time(DateTime.Now)
                    lbl.Text = "[" & timestamp & "] " & Message & CRLF & lbl.Text
                    Exit
                End If
            End If
        Next
    Catch
        Log("B4XPageBoomMenu.LogEvent: " & LastException.Message)
    End Try
End Sub
#End Region
