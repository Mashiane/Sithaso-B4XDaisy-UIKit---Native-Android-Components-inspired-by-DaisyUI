B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
    Private SECTION_GAP As Int = 14dip
    Private ITEM_GAP As Int = 6dip
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

' /**
'  * Initializes the page root, creates the host scrollview, and renders all docs-parity examples.
'  */
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "kbd")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub

' /**
'  * Reflows the scroll host and re-renders examples when page size changes.
'  */
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

' /**
'  * Renders all DaisyUI kbd documentation examples in linear order.
'  */
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
    Dim centerX As Int = PAGE_PAD + (maxW / 2)
    Dim y As Int = PAGE_PAD

    ' /**
    '  * Example 1: Kbd
    '  * Daisy docs: <kbd class="kbd">K</kbd>
    '  */
    y = AddSectionTitle("Kbd", y, maxW)
    AddKbd("K", "md", centerX - 18dip, y, 36dip, 28dip, "kbd-basic")
    y = y + 28dip + SECTION_GAP

    ' /**
    '  * Example 2: Kbd sizes
    '  * Daisy docs: kbd-xs, kbd-sm, kbd-md, kbd-lg, kbd-xl
    '  */
    y = AddSectionTitle("Kbd sizes", y, maxW)
    y = AddSizeRow(y, centerX, maxW)
    y = AddSizeRow1(y, centerX, maxW)
    y = y + SECTION_GAP



    ' /**
    '  * Example 3: In text
    '  * Daisy docs: Press <kbd class="kbd kbd-sm">F</kbd> to pay respects.
    '  */
    y = AddSectionTitle("In text", y, maxW)
    y = AddInlineTextExample(y, PAGE_PAD, maxW)
    y = y + SECTION_GAP

    ' /**
    '  * Example 4: Key combination
    '  * Daisy docs: ctrl + shift + del
    '  */
    y = AddSectionTitle("Key combination", y, maxW)
    y = AddKeyComboRow(y, centerX)
    y = y + SECTION_GAP

    ' /**
    '  * Example 5: Function keys
    '  * Daisy docs shows symbolic modifier keys.
    '  */
    y = AddSectionTitle("Function keys", y, maxW)
    y = AddFunctionKeysRow(y, centerX)
    y = y + SECTION_GAP

    ' /**
    '  * Example 6: A full keyboard
    '  * Daisy docs: qwerty rows.
    '  */
    y = AddSectionTitle("A full keyboard", y, maxW)
    y = AddKeyboardRow(y, centerX, Array As String("q", "w", "e", "r", "t", "y", "u", "i", "o", "p"))
    y = AddKeyboardRow(y, centerX, Array As String("a", "s", "d", "f", "g", "h", "j", "k", "l"))
    y = AddKeyboardRow(y, centerX, Array As String("z", "x", "c", "v", "b", "n", "m", "/"))
    y = y + SECTION_GAP

    ' /**
    '  * Example 7: Arrow keys
    '  * Daisy docs: up, left/right, down.
    '  */
    y = AddSectionTitle("Arrow keys", y, maxW)
    AddKbd("^", "md", centerX - 16dip, y, 32dip, 28dip, "arrow-up")
    y = y + 28dip + ITEM_GAP
    AddKbd("<", "md", centerX - 44dip, y, 32dip, 28dip, "arrow-left")
    AddKbd(">", "md", centerX + 12dip, y, 32dip, 28dip, "arrow-right")
    y = y + 28dip + ITEM_GAP
    AddKbd("v", "md", centerX - 16dip, y, 32dip, 28dip, "arrow-down")
    y = y + 28dip + SECTION_GAP

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim titleLbl As Label
    titleLbl.Initialize("")
    titleLbl.Text = Text
    titleLbl.TextColor = xui.Color_RGB(30, 41, 59)
    titleLbl.TextSize = 18
    titleLbl.Typeface = Typeface.DEFAULT_BOLD
    pnlHost.AddView(titleLbl, PAGE_PAD, Y, Width, 24dip)
    Return Y + 26dip
End Sub

Private Sub AddSizeRow(Y As Int, CenterX As Int, MaxWidth As Int) As Int
    Dim labels() As String = Array As String("Xsmall", "Small", "Medium")
    Dim sizes() As String = Array As String("xs", "sm", "md")
    Dim widths() As Int = Array As Int(42dip, 52dip, 64dip)
    Dim heights() As Int = Array As Int(20dip, 24dip, 28dip)

    ' adjust gap so the entire row fits within MaxWidth (allow shrinking to zero)
    Dim sumWidths As Int = 0
    For i = 0 To widths.Length - 1
        sumWidths = sumWidths + widths(i)
    Next
    Dim gapLocal As Int = ITEM_GAP
    If sumWidths + gapLocal * (labels.Length - 1) > MaxWidth Then
        ' compute maximum allowed gap to fit
        gapLocal = Max(0dip, Floor((MaxWidth - sumWidths) / (labels.Length - 1)))
    End If
    Dim total As Int = sumWidths + gapLocal * (labels.Length - 1)
    Dim x As Int = PAGE_PAD + Max(0dip, (MaxWidth - total) / 2)
    For i = 0 To labels.Length - 1
        AddKbd(labels(i), sizes(i), x, Y, widths(i), heights(i), "size-" & sizes(i))
        x = x + widths(i) + gapLocal
    Next

    Return Y + 36dip
End Sub

Private Sub AddSizeRow1(Y As Int, CenterX As Int, MaxWidth As Int) As Int
    Dim labels() As String = Array As String("Large", "Xlarge")
    Dim sizes() As String = Array As String("lg", "xl")
    Dim widths() As Int = Array As Int(54dip, 65dip)
    Dim heights() As Int = Array As Int(32dip, 36dip)

    ' adjust gap so the entire row fits within MaxWidth (allow shrinking to zero)
    Dim sumWidths As Int = 0
    For i = 0 To widths.Length - 1
        sumWidths = sumWidths + widths(i)
    Next
    Dim gapLocal As Int = ITEM_GAP
    If sumWidths + gapLocal * (labels.Length - 1) > MaxWidth Then
        ' compute maximum allowed gap to fit
        gapLocal = Max(0dip, Floor((MaxWidth - sumWidths) / (labels.Length - 1)))
    End If
    Dim total As Int = sumWidths + gapLocal * (labels.Length - 1)
    Dim x As Int = PAGE_PAD + Max(0dip, (MaxWidth - total) / 2)
    For i = 0 To labels.Length - 1
        AddKbd(labels(i), sizes(i), x, Y, widths(i), heights(i), "size-" & sizes(i))
        x = x + widths(i) + gapLocal
    Next

    Return Y + 36dip
End Sub


Private Sub AddInlineTextExample(Y As Int, X As Int, Width As Int) As Int
    Dim leftLbl As Label
    leftLbl.Initialize("")
    leftLbl.Text = "Press"
    leftLbl.TextColor = xui.Color_RGB(63, 64, 77)
    leftLbl.TextSize = 16
    pnlHost.AddView(leftLbl, X, Y + 4dip, 40dip, 24dip)

    AddKbd("F", "sm", X + 42dip, Y, 26dip, 24dip, "in-text-f")

    Dim rightLbl As Label
    rightLbl.Initialize("")
    rightLbl.Text = "to pay respects."
    rightLbl.TextColor = xui.Color_RGB(63, 64, 77)
    rightLbl.TextSize = 16
    pnlHost.AddView(rightLbl, X + 72dip, Y + 4dip, Width - 72dip, 24dip)

    Return Y + 28dip
End Sub

Private Sub AddKeyComboRow(Y As Int, CenterX As Int) As Int
    Dim keyW As Int = 48dip
    Dim keyH As Int = 28dip
    Dim plusW As Int = 16dip
    Dim total As Int = (keyW * 3) + (plusW * 2) + (ITEM_GAP * 4)
    Dim x As Int = centerX - (total / 2)

    AddKbd("ctrl", "md", x, Y, keyW, keyH, "combo-ctrl")
    x = x + keyW + ITEM_GAP
    AddPlusLabel(x, Y, plusW, keyH)
    x = x + plusW + ITEM_GAP
    AddKbd("shift", "md", x, Y, keyW, keyH, "combo-shift")
    x = x + keyW + ITEM_GAP
    AddPlusLabel(x, Y, plusW, keyH)
    x = x + plusW + ITEM_GAP
    AddKbd("del", "md", x, Y, keyW, keyH, "combo-del")

    Return Y + keyH
End Sub

Private Sub AddFunctionKeysRow(Y As Int, CenterX As Int) As Int
    Dim keys() As String = Array As String("Cmd", "Opt", "Shift", "Ctrl")
    Dim keyW As Int = 52dip
    Dim keyH As Int = 28dip
    Dim total As Int = (keyW * keys.Length) + (ITEM_GAP * (keys.Length - 1))
    Dim x As Int = centerX - (total / 2)

    For i = 0 To keys.Length - 1
        AddKbd(keys(i), "md", x, Y, keyW, keyH, "fn-" & keys(i).ToLowerCase)
        x = x + keyW + ITEM_GAP
    Next
    Return Y + keyH
End Sub

Private Sub AddKeyboardRow(Y As Int, CenterX As Int, Keys() As String) As Int
    Dim keyW As Int = 28dip
    Dim keyH As Int = 28dip
    Dim total As Int = (keyW * Keys.Length) + (ITEM_GAP * (Keys.Length - 1))
    Dim x As Int = centerX - (total / 2)

    For i = 0 To Keys.Length - 1
        AddKbd(Keys(i), "md", x, Y, keyW, keyH, "kb-" & Keys(i))
        x = x + keyW + ITEM_GAP
    Next
    Return Y + keyH + ITEM_GAP
End Sub

Private Sub AddPlusLabel(X As Int, Y As Int, Width As Int, Height As Int)
    Dim plusLbl As B4XDaisyText
    plusLbl.Initialize(Me, "")
    plusLbl.AddToParent(pnlHost, X, Y, Width, Height)
    plusLbl.Text = "+"
    plusLbl.setTextColor(xui.Color_RGB(63, 64, 77))
    plusLbl.TextSize = 16
    plusLbl.setHAlign("CENTER")
    plusLbl.setVAlign("CENTER")
    plusLbl.setAutoResize(False)
End Sub

Private Sub AddKbd(Text As String, Size As String, Left As Int, Top As Int, Width As Int, Height As Int, Tag As String) As B4XDaisyKbd
    Dim k As B4XDaisyKbd
    k.Initialize(Me, "component")
    k.AddToParent(pnlHost, Left, Top, Width, Height)
    k.Text = Text
    k.Size = Size
    k.Tag = Tag
    Return k
End Sub

' /**
'  * Handles click feedback from any rendered kbd instance.
'  */
Private Sub component_Click(Tag As Object)
    #If B4A
    Dim s As String = Tag
    If s.Length = 0 Then s = "kbd"
    ToastMessageShow("Clicked: " & s, False)
    #End If
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
