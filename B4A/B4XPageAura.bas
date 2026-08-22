B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' Demo page for B4XDaisyAura (daisyUI "aura" wrapper).
' Mirrors DaisyUI website examples (https://daisyui.com/components/aura/)

#IgnoreWarnings:12,9

Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private pageScroll As B4XDaisyPageScroll
    Private pnlHost As B4XView
    Private auras As List
End Sub

Public Sub Initialize As Object
    auras.Initialize
    Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
    pnlHost = pageScroll.Panel

    RenderExamples
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
    RenderExamples
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    If auras.IsInitialized Then
        For Each a As B4XDaisyAura In auras
            If a.IsInitialized Then a.StartRotation
        Next
    End If
End Sub

Private Sub B4XPage_Disappear
    If auras.IsInitialized Then
        For Each a As B4XDaisyAura In auras
            If a.IsInitialized Then a.StopRotation
        Next
    End If
End Sub

Private Sub RenderExamples
    If pnlHost.IsInitialized = False Then Return
    pageScroll.Clear
    auras.Clear

    Dim padding As Int = pageScroll.PagePadding
    Dim maxW As Int = pageScroll.UsableWidth
    Dim gap As Int = pageScroll.YGap
    Dim y As Int = padding

    ' 1. Aura around a card
    y = pageScroll.AddSectionTitle("1. Aura around a card", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "default", "md", 0, 0, 3000, "This card has aura")
    y = y + 100dip + gap

    ' 2. Aura around a button
    y = pageScroll.AddSectionTitle("2. Aura around a button", y, False)
    AddButtonAura(padding + maxW / 2, y + 25dip, 160dip, 44dip, "default", "md", 0, 3000, "button with aura")
    y = y + 60dip + gap

    ' 3. Aura dual
    y = pageScroll.AddSectionTitle("3. Aura dual", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "dual", "md", 0, 0, 3000, "This card has dual aura")
    y = y + 100dip + gap

    ' 4. Aura rainbow
    y = pageScroll.AddSectionTitle("4. Aura rainbow", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "rainbow", "md", 0, 0, 3000, "This card has rainbow aura")
    y = y + 100dip + gap

    ' 5. Aura holo
    y = pageScroll.AddSectionTitle("5. Aura holo", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "holo", "md", 0, 0, 4000, "This card has holo aura")
    y = y + 100dip + gap

    ' 6. Aura glow
    y = pageScroll.AddSectionTitle("6. Aura glow", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "glow", "md", 0, 0, 3000, "This card has glow aura")
    y = y + 100dip + gap

    ' 7. Aura gold
    y = pageScroll.AddSectionTitle("7. Aura gold", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "gold", "md", 0, 0, 3000, "This card has gold aura")
    y = y + 100dip + gap

    ' 8. Aura silver
    y = pageScroll.AddSectionTitle("8. Aura silver", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "silver", "md", 0, 0, 3000, "This card has silver aura")
    y = y + 100dip + gap

    ' 9. Aura with custom color (text-orange-600)
    y = pageScroll.AddSectionTitle("9. Aura with custom color", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "default", "md", 0xFFEA580C, 0, 3000, "This card has custom color aura")
    y = y + 100dip + gap

    ' 10. Aura with custom color and custom background color (text-orange-600 bg-yellow-200)
    y = pageScroll.AddSectionTitle("10. Aura with custom color and background color", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "default", "md", 0xFFEA580C, 0xFFFEF08A, 3000, "This card has custom color and background aura")
    y = y + 100dip + gap

    ' 11. Aura rainbow around a pricing card
    y = pageScroll.AddSectionTitle("11. Aura rainbow around a pricing card", y, False)
    AddPricingCardAura(padding, y, maxW - 8dip, 220dip)
    y = y + 240dip + gap

    ' 12. Aura sizes (xs, sm, md, lg, xl)
    y = pageScroll.AddSectionTitle("12. Aura sizes", y, False)
    Dim sizes As List
    sizes.Initialize2(Array As String("xs", "sm", "md", "lg", "xl"))
    Dim perRow As Int = 3
    Dim cellW As Int = maxW / perRow
    Dim rowH2 As Int = 64dip
    For i = 0 To sizes.Size - 1
        Dim sz As String = sizes.Get(i)
        Dim col As Int = i Mod perRow
        Dim row As Int = i / perRow
        Dim ccx As Int = padding + col * cellW + cellW / 2
        Dim ccy As Int = y + row * rowH2 + rowH2 / 2
        AddButtonAura(ccx, ccy, 60dip, 40dip, "default", sz, 0, 3000, sz.ToUpperCase)
    Next
    y = y + ((sizes.Size + perRow - 1) / perRow) * rowH2 + gap

    ' 13. Aura with custom animation duration (2000ms)
    y = pageScroll.AddSectionTitle("13. Aura with custom duration (2000ms)", y, False)
    AddSimpleCardAura(padding, y, maxW - 8dip, 80dip, "rainbow", "md", 0, 0, 2000, "2000ms duration aura")
    y = y + 100dip + gap

    pageScroll.AutoFit
End Sub

Private Sub AuraThicknessDip(Size As String) As Int
    Select Case Size.ToLowerCase
        Case "xs": Return 2dip
        Case "sm": Return 3dip
        Case "lg": Return 6dip
        Case "xl": Return 8dip
        Case Else: Return 4dip ' md
    End Select
End Sub

Private Sub AddButtonAura(CenterX As Int, CenterY As Int, W As Int, H As Int, Style As String, Size As String, Color As Int, Duration As Int, Label As String)
    Dim btn As B4XDaisyButton
    btn.Initialize(Me, "")
    btn.AddToParent(pnlHost, -10000, -10000, W, H)
    btn.Text = Label
    btn.Variant = "primary"
    btn.Size = "md"
    Dim bw As Int = btn.View.Width
    Dim bh As Int = btn.View.Height

    Dim a As B4XDaisyAura
    a.Initialize(Me, "")
    a.setStyle(Style)
    a.setSize(Size)
    If Color <> 0 Then a.setColor(Color)
    a.setDuration(Duration)
    Dim thick As Int = AuraThicknessDip(Size)
    Dim wrapperW As Int = bw + 2 * thick
    Dim wrapperH As Int = bh + 2 * thick
    a.AddToParent(pnlHost, CenterX - wrapperW / 2, CenterY - wrapperH / 2, bw, bh)
    a.Wrap(btn.View)
    a.StartRotation
    auras.Add(a)
End Sub

Private Sub AddSimpleCardAura(Left As Int, Top As Int, W As Int, H As Int, Style As String, Size As String, Color As Int, BgColor As Int, Duration As Int, TextMsg As String)
    Dim card As B4XDaisyCard
    card.Initialize(Me, "card")
    card.AddToParent(pnlHost, Left, Top, W, H)
    Try
        Dim body As B4XView = card.CardBody
        If body.IsInitialized Then
            Dim lbl As Label
            lbl.Initialize("")
            Dim xb As B4XView = lbl
            xb.Text = TextMsg
            xb.TextColor = xui.Color_RGB(30, 41, 59)
            xb.TextSize = 14
            body.AddView(xb, 0, 0, Max(1dip, body.Width), 30dip)
        End If
    Catch
    End Try

    Dim cw As Int = card.getContainer.Width
    Dim ch As Int = card.getContainer.Height
    Dim a As B4XDaisyAura
    a.Initialize(Me, "")
    a.setStyle(Style)
    a.setSize(Size)
    If Color <> 0 Then a.setColor(Color)
    If BgColor <> 0 Then a.setBackgroundColor(BgColor)
    a.setDuration(Duration)
    a.AddToParent(pnlHost, Left, Top, cw, ch)
    a.Wrap(card.getContainer)
    a.StartRotation
    auras.Add(a)
End Sub

Private Sub AddPricingCardAura(Left As Int, Top As Int, W As Int, H As Int)
    Dim card As B4XDaisyCard
    card.Initialize(Me, "pricingCard")
    card.AddToParent(pnlHost, Left, Top, W, H)
    card.Title = "Premium - $29/mo"

    Try
        Dim body As B4XView = card.CardBody
        If body.IsInitialized Then
            Dim lbl As Label
            lbl.Initialize("")
            Dim xb As B4XView = lbl
            xb.Text = "[Most Popular]" & CRLF & "- High-resolution image generation" & CRLF & "- Customizable style templates" & CRLF & "- Batch processing capabilities"
            xb.TextColor = xui.Color_RGB(30, 41, 59)
            xb.TextSize = 13
            body.AddView(xb, 0, 0, Max(1dip, body.Width), 80dip)
        End If
    Catch
    End Try

    Dim cw As Int = card.getContainer.Width
    Dim ch As Int = card.getContainer.Height
    Dim a As B4XDaisyAura
    a.Initialize(Me, "")
    a.setStyle("rainbow")
    a.setSize("md")
    a.setDuration(3000)
    a.AddToParent(pnlHost, Left, Top, cw, ch)
    a.Wrap(card.getContainer)
    a.StartRotation
    auras.Add(a)
End Sub
