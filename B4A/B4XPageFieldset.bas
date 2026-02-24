B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=1
@EndOfDesignText@

Sub Class_Globals
    Private xui As XUI
    Private Root As B4XView
    Private scvContent As ScrollView
    Private pnlContent As B4XView
    Private currentY As Int = 20dip
    Private gap As Int = 30dip
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_White
    scvContent.Initialize(0)
    Root.AddView(scvContent, 0, 0, Root.Width, Root.Height)
    pnlContent = scvContent.Panel
    pnlContent.Color = xui.Color_White
    pnlContent.Width = Root.Width

    AddTitle("Fieldset parity")
    AddParityFieldset

    AddTitle("Fieldset with multiple controls")
    AddDetailsFieldset
    
    AddTitle("Fieldset shadows (borderless)")
    AddShadowFieldsetCollection
    
    AddTitle("Fieldset variant border colors")
    AddVariantBorderFieldsetCollection
    
    AddTitle("Fieldset variant backgrounds (borderless)")
    AddVariantBackgroundFieldsetCollection

    pnlContent.Height = currentY + 36dip
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    If scvContent.IsInitialized = False Then Return
    scvContent.SetLayoutAnimated(0, 0, 0, Width, Height)
    pnlContent.Width = Width
End Sub

Private Sub AddTitle(Text As String)
    Dim lbl As Label
    lbl.Initialize("")
    Dim xl As B4XView = lbl
    xl.Text = Text
    xl.Font = xui.CreateDefaultBoldFont(18)
    xl.TextColor = xui.Color_DarkGray
    pnlContent.AddView(xl, 12dip, currentY, Root.Width - 24dip, 28dip)
    currentY = currentY + 34dip
End Sub

Private Sub AddParityFieldset
    Dim fs As B4XDaisyFieldset
    fs.Initialize(Me, "fs_parity")

    Dim boxW As Int = Min(Root.Width - 24dip, 320dip)
    Dim left As Int = 12dip
    Dim h As Int = 1dip
    If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

    Dim v As B4XView = fs.AddToParent(pnlContent, left, currentY, boxW, h)
    fs.setAutoHeight(True)
    fs.setLegend("Anele Mbanga (Mashy)")
    ApplyDemoFieldsetStyle(fs)

    Dim inputView As B4XView = CreateNativeInput("My awesome page")
    fs.AddContentView(inputView, 0, 0, boxW - (fs.getPadding * 2dip), 42dip)

    Dim helper As B4XView = CreateHelperLabel("You can edit page title later on from settings", "")
    fs.AddContentView(helper, 0, 50dip, boxW - (fs.getPadding * 2dip), 34dip)

    fs.Refresh
    currentY = currentY + v.Height + gap
End Sub

Private Sub AddDetailsFieldset
    Dim fs As B4XDaisyFieldset
    fs.Initialize(Me, "fs_details")

    Dim boxW As Int = Min(Root.Width - 24dip, 320dip)
    Dim left As Int = 12dip
    Dim h As Int = 1dip
    If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

    Dim v As B4XView = fs.AddToParent(pnlContent, left, currentY, boxW, h)
    fs.setAutoHeight(True)
    fs.setLegend("Page details")
    ApplyDemoFieldsetStyle(fs)

    Dim y As Int = 0
    y = AddFormRow(fs, y, "Title", "My awesome page", boxW)
    y = AddFormRow(fs, y, "Slug", "my-awesome-page", boxW)
    y = AddFormRow(fs, y, "Author", "Name", boxW)

    fs.Refresh
    currentY = currentY + v.Height + 12dip
End Sub

Private Sub AddShadowFieldsetCollection
    Dim levels() As String = Array As String("xs", "sm", "md", "lg", "xl")
    For Each level As String In levels
        Dim fs As B4XDaisyFieldset
        fs.Initialize(Me, $"fs_shadow_${level}"$)

        Dim boxW As Int = Min(Root.Width - 24dip, 320dip)
        Dim left As Int = 12dip
        Dim h As Int = 1dip
        If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

        Dim v As B4XView = fs.AddToParent(pnlContent, left, currentY, boxW, h)
        fs.setAutoHeight(True)
        fs.setLegend($"Shadow: ${level}"$)
        ApplyShadowOnlyFieldsetStyle(fs, level)

        Dim helper As B4XView = CreateHelperLabel($"Borderless fieldset with ${level} shadow"$, "")
        fs.AddContentView(helper, 0, 0, boxW - (fs.getPadding * 2dip), 34dip)

        Dim inputView As B4XView = CreateNativeInput($"shadow-${level}"$)
        fs.AddContentView(inputView, 0, 36dip, boxW - (fs.getPadding * 2dip), 42dip)

        fs.Refresh
        currentY = currentY + v.Height + 14dip
    Next
    currentY = currentY + 4dip
End Sub

Private Sub AddVariantBorderFieldsetCollection
    Dim variants() As String = Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
    For Each variant As String In variants
        Dim fs As B4XDaisyFieldset
        fs.Initialize(Me, $"fs_variant_${variant}"$)

        Dim boxW As Int = Min(Root.Width - 24dip, 320dip)
        Dim left As Int = 12dip
        Dim h As Int = 1dip
        If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

        Dim v As B4XView = fs.AddToParent(pnlContent, left, currentY, boxW, h)
        fs.setAutoHeight(True)
        fs.setLegend($"Variant: ${variant}"$)
        ApplyVariantBorderFieldsetStyle(fs, variant)

        Dim helper As B4XView = CreateHelperLabel($"Border color uses variant ${variant}"$, "")
        fs.AddContentView(helper, 0, 0, boxW - (fs.getPadding * 2dip), 34dip)

        Dim inputView As B4XView = CreateNativeInput($"variant-${variant}"$)
        fs.AddContentView(inputView, 0, 36dip, boxW - (fs.getPadding * 2dip), 42dip)

        fs.Refresh
        currentY = currentY + v.Height + 14dip
    Next
End Sub

Private Sub AddVariantBackgroundFieldsetCollection
    Dim variants() As String = Array As String("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
    For Each variant As String In variants
        Dim fs As B4XDaisyFieldset
        fs.Initialize(Me, $"fs_bg_${variant}"$)

        Dim boxW As Int = Min(Root.Width - 24dip, 320dip)
        Dim left As Int = 12dip
        Dim h As Int = 1dip
        If boxW < Root.Width - 24dip Then left = (Root.Width - boxW) / 2

        Dim v As B4XView = fs.AddToParent(pnlContent, left, currentY, boxW, h)
        fs.setAutoHeight(True)
        fs.setLegend($"Background: ${variant}"$)
        ApplyVariantBackgroundFieldsetStyle(fs, variant)

        Dim helper As B4XView = CreateHelperLabel($"Borderless fieldset using ${variant} background"$, variant)
        fs.AddContentView(helper, 0, 0, boxW - (fs.getPadding * 2dip), 34dip)

        Dim inputView As B4XView = CreateNativeInput($"bg-${variant}"$)
        fs.AddContentView(inputView, 0, 36dip, boxW - (fs.getPadding * 2dip), 42dip)

        fs.Refresh
        currentY = currentY + v.Height + 14dip
    Next
End Sub

Private Sub ApplyDemoFieldsetStyle(fs As B4XDaisyFieldset)
    If fs.IsInitialized = False Then Return
    fs.setBackgroundColor("bg-base-200")
    fs.setBorderColor("border-base-300")
    fs.setRoundedBox(True)
    fs.setBorderStyle("outlined")
    fs.setBorderSize(1)
    fs.setPadding(16) ' p-4
    fs.setTextColor("text-base-content")
End Sub

Private Sub ApplyShadowOnlyFieldsetStyle(fs As B4XDaisyFieldset, ShadowLevel As String)
    If fs.IsInitialized = False Then Return
    fs.setBackgroundColor("bg-base-200")
    fs.setRoundedBox(True)
    fs.setBorderStyle("ghost")
    fs.setBorderSize(0)
    fs.setBorderColor("")
    fs.setPadding(16) ' p-4
    fs.setTextColor("text-base-content")
    fs.setShadow(ShadowLevel)
End Sub

Private Sub ApplyVariantBorderFieldsetStyle(fs As B4XDaisyFieldset, VariantName As String)
    If fs.IsInitialized = False Then Return
    fs.setBackgroundColor("bg-base-200")
    fs.setRoundedBox(True)
    fs.setBorderStyle("outlined")
    fs.setBorderSize(1)
    fs.setBorderColor("")
    fs.setVariant(VariantName)
    fs.setPadding(16) ' p-4
    fs.setTextColor("text-base-content")
    fs.setShadow("none")
End Sub

Private Sub ApplyVariantBackgroundFieldsetStyle(fs As B4XDaisyFieldset, VariantName As String)
    If fs.IsInitialized = False Then Return
    fs.setVariant(VariantName)
    fs.setBackgroundColor(VariantName)
    fs.setRoundedBox(True)
    fs.setBorderStyle("ghost")
    fs.setBorderSize(0)
    fs.setBorderColor("")
    fs.setPadding(16) ' p-4
    fs.setTextColor(VariantName & "-content")
    fs.setShadow("none")
End Sub

Private Sub AddFormRow(fs As B4XDaisyFieldset, Top As Int, Caption As String, Placeholder As String, boxW As Int) As Int
    Dim contentW As Int = boxW - (fs.getPadding * 2dip)
    Dim lbl As Label
    lbl.Initialize("")
    Dim xlbl As B4XView = lbl
    xlbl.Text = Caption
    xlbl.Font = xui.CreateDefaultFont(13)
    xlbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
    fs.AddContentView(xlbl, 0, Top, contentW, 18dip)

    Dim inputView As B4XView = CreateNativeInput(Placeholder)
    fs.AddContentView(inputView, 0, Top + 20dip, contentW, 42dip)
    Return Top + 70dip
End Sub

Private Sub CreateNativeInput(Placeholder As String) As B4XView
    Dim et As EditText
    et.Initialize("")
    et.TextSize = 16
    et.Hint = Placeholder
    et.SingleLine = True
    et.Color = xui.Color_Transparent
    et.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)

    Dim v As B4XView = et
    Dim borderColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(224, 224, 228))
    Dim bg As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    v.SetColorAndBorder(bg, Max(1dip, Round(B4XDaisyVariants.GetBorderDip(1dip))), borderColor, B4XDaisyVariants.GetRadiusFieldDip(6dip))
    Return v
End Sub

Private Sub CreateHelperLabel(Text As String, VariantName As String) As B4XView
    Dim lbl As Label
    lbl.Initialize("")
    lbl.Text = Text
    lbl.SingleLine = False
    lbl.TextSize = 13
    Dim normalizedVariant As String = B4XDaisyVariants.NormalizeVariant(VariantName)
    If normalizedVariant <> "none" And normalizedVariant.Length > 0 Then
        Dim variantToken As String = "--color-" & normalizedVariant & "-content"
        lbl.TextColor = B4XDaisyVariants.GetTokenColor(variantToken, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray))
    Else
        lbl.TextColor = B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray), 150)
    End If
    Return lbl
End Sub
