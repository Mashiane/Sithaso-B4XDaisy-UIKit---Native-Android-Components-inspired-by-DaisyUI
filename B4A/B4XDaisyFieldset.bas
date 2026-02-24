B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Legend, DisplayName: Legend, FieldType: String, DefaultValue: Legend Caption, Description: Caption text shown in the fieldset header
#DesignerProperty: Key: LegendSize, DisplayName: Legend Size, FieldType: String, DefaultValue: text-sm, List: text-xs|text-sm|text-base|text-lg|text-xl, Description: Tailwind-like text size token for legend
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Optional accent variant for border tint
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: outlined, List: outlined|ghost|inset, Description: Border visual style
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 16, Description: Inner content padding in dip (p-4)
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: False, Description: Automatically grow to fit added content
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius mode
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Use box radius for container
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color (0 = default bg-base-200)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Legend text color (0 = use theme token)
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color override (0 = default border-base-300)
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip

Sub Class_Globals
    Private xui As XUI
    Private mBase As B4XView
    Private mCallBack As Object
    Private mEventName As String
    Private mTag As Object

    Private msLegend As String = "Legend Caption"
    Private msVariant As String = "none"
    Private msLegendSize As String = "text-sm"
    Private msBorderStyle As String = "outlined"
    Private miPaddingDip As Int = 16dip
    Private mbAutoHeight As Boolean = False
    Private msRounded As String = "theme"
    Private mbRoundedBox As Boolean = True
    Private msShadow As String = "none"
    Private mcBackgroundColor As Int = 0
    Private mcTextColor As Int = 0
    Private mcBorderColor As Int = 0
    Private miBorderSize As Int = 1dip

    Private pnlSurface As B4XView
    Private pnlLegendMask As B4XView
    Private pnlLegendCut As B4XView
    Private lblLegend As B4XView
    Private pnlContent As B4XView
    Private pnlMeasure As B4XView
    Private cvsMeasure As B4XCanvas
    Private mLegendPadXDip As Int = 6dip
    Private mLegendPadYDip As Int = 2dip
    Private mLegendNudgeYDip As Int = -12dip
    Private mTopInsetDip As Int = 10dip
    Private mDefaultWidthDip As Int = 320dip ' Daisy w-xs
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim existingChildren As List
    existingChildren.Initialize
    For i = 0 To mBase.NumberOfViews - 1
        existingChildren.Add(mBase.GetView(i))
    Next

    Dim pSurface As Panel
    pSurface.Initialize("")
    pnlSurface = pSurface
    pnlSurface.Color = xui.Color_Transparent
    mBase.AddView(pnlSurface, 0, 0, 0, 0)

    Dim pMask As Panel
    pMask.Initialize("")
    pnlLegendMask = pMask
    pnlLegendMask.Color = xui.Color_Transparent
    mBase.AddView(pnlLegendMask, 0, 0, 0, 0)

    Dim pCut As Panel
    pCut.Initialize("")
    pnlLegendCut = pCut
    pnlLegendCut.Color = xui.Color_Transparent
    pnlLegendMask.AddView(pnlLegendCut, 0, 0, 0, 0)

    Dim lbl As Label
    lbl.Initialize("")
    lbl.SingleLine = True
    lblLegend = lbl
    lblLegend.Color = xui.Color_Transparent
    lblLegend.SetTextAlignment("CENTER", "LEFT")
    pnlLegendMask.AddView(lblLegend, 0, 0, 0, 0)

    Dim pContent As Panel
    pContent.Initialize("")
    pnlContent = pContent
    pnlContent.Color = xui.Color_Transparent
    pnlSurface.AddView(pnlContent, 0, 0, 0, 0)

    Dim pMeasure As Panel
    pMeasure.Initialize("")
    pnlMeasure = pMeasure
    mBase.AddView(pnlMeasure, 0, 0, 120dip, 40dip)
    pnlMeasure.Visible = False
    cvsMeasure.Initialize(pnlMeasure)

    ApplyDesignerProps(Props)
    MoveChildrenToContent(existingChildren)
    Refresh
End Sub

Public Sub ApplyDesignerProps(Props As Map)
    msLegend = B4XDaisyVariants.GetPropString(Props, "Legend", "Legend Caption")
    msVariant = B4XDaisyVariants.GetPropString(Props, "Variant", "none")
    msLegendSize = B4XDaisyVariants.GetPropString(Props, "LegendSize", "text-sm")
    msBorderStyle = B4XDaisyVariants.GetPropString(Props, "BorderStyle", "outlined")
    miPaddingDip = B4XDaisyVariants.GetPropInt(Props, "Padding", 16)
    mbAutoHeight = B4XDaisyVariants.GetPropBool(Props, "AutoHeight", False)
    msRounded = NormalizeRoundedMode(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
    mbRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", True)
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    mcBackgroundColor = ResolveColorValue(Props.Get("BackgroundColor"), mcBackgroundColor)
    mcTextColor = ResolveColorValue(Props.Get("TextColor"), mcTextColor)
    mcBorderColor = ResolveColorValue(Props.Get("BorderColor"), mcBorderColor)
    miBorderSize = B4XDaisyVariants.GetPropInt(Props, "BorderSize", 1) * 1dip
End Sub

Private Sub ResolveColorValue(Value As Object, DefaultColor As Int) As Int
    If Value = Null Then Return DefaultColor
    If IsNumber(Value) Then Return Value
    Dim s As String = Value
    s = s.Trim
    If s.Length = 0 Then Return DefaultColor
    Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
    If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, DefaultColor)
    Return DefaultColor
End Sub

Private Sub MoveChildrenToContent(Children As List)
    If Children.IsInitialized = False Then Return
    For Each v As B4XView In Children
        If v = Null Then Continue
        If v = pnlSurface Then Continue
        If v = pnlLegendMask Then Continue
        If v = pnlMeasure Then Continue
        Dim l As Int = v.Left
        Dim t As Int = v.Top
        Dim w As Int = v.Width
        Dim h As Int = v.Height
        v.RemoveViewFromParent
        pnlContent.AddView(v, l, t, w, h)
    Next
End Sub

Private Sub MeasureLegendTextMetrics(Text As String, Font As B4XFont) As Map
    Dim m As Map
    m.Initialize
    m.Put("w", 0)
    m.Put("h", 0)
    If Text = Null Then Return m
    Dim t As String = Text.Trim
    If t.Length = 0 Then Return m
    Dim r As B4XRect = cvsMeasure.MeasureText(t, Font)
    m.Put("w", Ceil(r.Width))
    m.Put("h", Ceil(r.Height))
    Return m
End Sub

Private Sub MeasureLegendTextWidthExact(Text As String, FallbackWidth As Int) As Int
    Dim t As String = IIf(Text = Null, "", Text.Trim)
    If t.Length = 0 Then Return 0
    #If B4A
    Try
        Dim jo As JavaObject = lblLegend
        Dim paint As JavaObject = jo.RunMethod("getPaint", Null)
        Dim w As Float = paint.RunMethod("measureText", Array(t))
        Return Max(FallbackWidth, Ceil(w))
    Catch
        Return FallbackWidth
    End Try
    #Else
    Return FallbackWidth
    #End If
End Sub

Private Sub ResolveFieldsetBackground As Int
    If mcBackgroundColor <> 0 Then Return mcBackgroundColor
    Select Case msBorderStyle
        Case "ghost"
            Return xui.Color_Transparent
        Case Else
            Return B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(248, 247, 251))
    End Select
End Sub

Private Sub ResolveFieldsetBorderColor As Int
    If mcBorderColor <> 0 Then Return mcBorderColor
    Dim baseBorder As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(224, 224, 228))
    If msVariant <> "none" Then
        Dim accentBorder As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, baseBorder)
        baseBorder = B4XDaisyVariants.Blend(accentBorder, baseBorder, 0.55)
    End If
    If msBorderStyle = "inset" Then
        Dim contentColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
        baseBorder = B4XDaisyVariants.Blend(baseBorder, contentColor, 0.08)
    End If
    Return baseBorder
End Sub

Private Sub ResolveFieldsetBorderSize As Int
    ' Respect explicit 0 as "no border".
    Return Max(0, miBorderSize)
End Sub

Private Sub NormalizeRoundedMode(Value As String) As String
    If Value = Null Then Return "theme"
    Dim s As String = Value.ToLowerCase.Trim
    Select Case s
        Case "", "theme", "selector"
            Return "theme"
        Case "none", "rounded-none"
            Return "rounded-none"
        Case "sm", "rounded-sm"
            Return "rounded-sm"
        Case "default", "rounded"
            Return "rounded"
        Case "md", "rounded-md"
            Return "rounded-md"
        Case "lg", "rounded-lg"
            Return "rounded-lg"
        Case "xl", "rounded-xl"
            Return "rounded-xl"
        Case "2xl", "rounded-2xl"
            Return "rounded-2xl"
        Case "3xl", "rounded-3xl"
            Return "rounded-3xl"
        Case "full", "rounded-full"
            Return "rounded-full"
        Case Else
            Return "theme"
    End Select
End Sub

Private Sub ResolveCornerRadiusDip As Float
    Dim mode As String = NormalizeRoundedMode(msRounded)
    If mode = "theme" Then
        If mbRoundedBox Then Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
        Return 0
    End If
    Return B4XDaisyVariants.ResolveRoundedDip(mode, B4XDaisyVariants.GetRadiusFieldDip(6dip))
End Sub

Private Sub ResolveLegendTextColor As Int
    If mcTextColor <> 0 Then Return mcTextColor
    Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
End Sub

Private Sub ApplyShadow
    B4XDaisyVariants.ApplyElevation(pnlSurface, msShadow)
    If pnlLegendMask.IsInitialized Then
        If msLegend.Trim.Length > 0 And pnlLegendMask.Visible Then
            B4XDaisyVariants.ApplyElevation(pnlLegendMask, msShadow)
        Else
            B4XDaisyVariants.ApplyElevation(pnlLegendMask, "none")
        End If
    End If
End Sub

Private Sub EnsureShadowVisibility
    DisableClippingChain(mBase, 4)
    DisableClippingChain(pnlSurface, 1)
    DisableClippingChain(pnlLegendMask, 1)
End Sub

Private Sub DisableClippingChain(StartView As B4XView, MaxLevels As Int)
    If StartView.IsInitialized = False Then Return
    Dim v As B4XView = StartView
    For i = 0 To Max(0, MaxLevels)
        If v.IsInitialized = False Then Exit
        B4XDaisyVariants.DisableClipping(v)
        If v.Parent.IsInitialized = False Then Exit
        v = v.Parent
    Next
End Sub

Private Sub ApplyLegendMaskShape(BgColor As Int, RadiusDip As Float, StrokeColor As Int, StrokeDip As Int)
    #If B4A
    Try
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setShape", Array(0)) ' RECTANGLE
        gd.RunMethod("setColor", Array(BgColor))
        Dim r As Float = Max(0, RadiusDip)
        ' Top-left, top-right, bottom-right, bottom-left
        Dim radii() As Float = Array As Float(r, r, r, r, 0, 0, 0, 0)
        gd.RunMethod("setCornerRadii", Array(radii))
        If StrokeDip > 0 Then gd.RunMethod("setStroke", Array(StrokeDip, StrokeColor))
        Dim jo As JavaObject = pnlLegendMask
        jo.RunMethod("setBackground", Array(gd))
    Catch
        pnlLegendMask.SetColorAndBorder(BgColor, StrokeDip, StrokeColor, RadiusDip)
    End Try
    #Else
    pnlLegendMask.SetColorAndBorder(BgColor, StrokeDip, StrokeColor, RadiusDip)
    #End If
End Sub

Private Sub ApplySurfaceShape(BgColor As Int, RadiusDip As Float, StrokeColor As Int, StrokeDip As Int)
    #If B4A
    Try
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setShape", Array(0)) ' RECTANGLE
        gd.RunMethod("setColor", Array(BgColor))
        Dim r As Float = Max(0, RadiusDip)
        ' Use the same corner-radii path as legend mask to keep border rendering parity.
        Dim radii() As Float = Array As Float(r, r, r, r, r, r, r, r)
        gd.RunMethod("setCornerRadii", Array(radii))
        If StrokeDip > 0 Then gd.RunMethod("setStroke", Array(StrokeDip, StrokeColor))
        Dim jo As JavaObject = pnlSurface
        jo.RunMethod("setBackground", Array(gd))
    Catch
        pnlSurface.SetColorAndBorder(BgColor, StrokeDip, StrokeColor, RadiusDip)
    End Try
    #Else
    pnlSurface.SetColorAndBorder(BgColor, StrokeDip, StrokeColor, RadiusDip)
    #End If
End Sub

Private Sub RebuildLayout
    If mBase.IsInitialized = False Then Return

    Dim w As Int = Max(0, mBase.Width)
    Dim h As Int = Max(0, mBase.Height)
    Dim neededTopInset As Int = 0
    If mLegendNudgeYDip < 0 Then neededTopInset = Abs(mLegendNudgeYDip) + 2dip
    Dim surfaceTop As Int = Max(mTopInsetDip, neededTopInset)
    Dim surfaceH As Int = Max(0, h - surfaceTop)
    pnlSurface.SetLayoutAnimated(0, 0, surfaceTop, w, surfaceH)

    Dim radiusDip As Float = ResolveCornerRadiusDip

    Dim bg As Int = ResolveFieldsetBackground
    Dim borderColor As Int = ResolveFieldsetBorderColor
    Dim borderSize As Int = ResolveFieldsetBorderSize
    ApplySurfaceShape(bg, radiusDip, borderColor, borderSize)
    ApplyShadow

    Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(msLegendSize, 14, 20)
    Dim fontSize As Float = tm.GetDefault("font_size", 14)
    Dim lineHeight As Int = Round(tm.GetDefault("line_height_px", fontSize * 1.45))
    Dim legendFont As B4XFont = xui.CreateDefaultFont(fontSize)
    lblLegend.Font = legendFont
    lblLegend.TextColor = ResolveLegendTextColor
    lblLegend.Text = msLegend
    lblLegend.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)

    Dim hasLegend As Boolean = msLegend.Trim.Length > 0
    Dim contentTop As Int = miPaddingDip
    If hasLegend Then
        Dim metric As Map = MeasureLegendTextMetrics(msLegend, legendFont)
        Dim legendTextW As Int = metric.GetDefault("w", 0)
        legendTextW = MeasureLegendTextWidthExact(msLegend, legendTextW)
        Dim legendTextH As Int = metric.GetDefault("h", lineHeight)
        Dim legendInnerH As Int = Max(lineHeight, legendTextH + 4dip)
        Dim legendH As Int = Max(1dip, legendInnerH + (mLegendPadYDip * 2) + 2dip)
        Dim legendHostW As Int = Max(0, w - (miPaddingDip * 2))
        Dim legendMaskW As Int = Min(legendHostW, legendTextW + (mLegendPadXDip * 2) + (borderSize * 2))
        Dim legendLeft As Int = miPaddingDip - mLegendPadXDip
        If legendLeft < 0 Then legendLeft = 0
        Dim legendTop As Int = surfaceTop + mLegendNudgeYDip

        pnlLegendMask.Visible = True
        lblLegend.Visible = True
        ApplyLegendMaskShape(bg, radiusDip, borderColor, borderSize)
        pnlLegendMask.SetLayoutAnimated(0, legendLeft, legendTop, legendMaskW, legendH)
        Dim joinY As Int = Max(0, surfaceTop - legendTop + borderSize)
        joinY = Min(legendH, joinY)
        Dim cutH As Int = Max(0, legendH - joinY)
        pnlLegendCut.Visible = (cutH > 0)
        If cutH > 0 Then
            pnlLegendCut.Color = bg
            pnlLegendCut.SetLayoutAnimated(0, 0, joinY, legendMaskW, cutH)
        Else
            pnlLegendCut.SetLayoutAnimated(0, 0, 0, 0, 0)
        End If
        Dim lblW As Int = Max(0, legendMaskW - (mLegendPadXDip * 2) - (borderSize * 2))
        Dim lblY As Int = Max(0, mLegendPadYDip - 1dip)
        Dim lblH As Int = Max(1dip, legendH - lblY - mLegendPadYDip + 1dip)
        lblLegend.SetLayoutAnimated(0, mLegendPadXDip + borderSize, lblY, lblW, lblH)
        lblLegend.BringToFront
        contentTop = Max(miPaddingDip, legendH + 2dip)
    Else
        pnlLegendMask.Visible = False
        pnlLegendCut.Visible = False
        lblLegend.Visible = False
        pnlLegendMask.SetLayoutAnimated(0, 0, 0, 0, 0)
        pnlLegendCut.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If

    If mbAutoHeight Then
        Dim requiredContentBottom As Int = MeasureContentBottom
        Dim targetH As Int = surfaceTop + contentTop + requiredContentBottom + miPaddingDip
        targetH = Max(targetH, surfaceTop + contentTop + miPaddingDip)
        If Abs(targetH - h) > 1dip Then
            mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, targetH)
            h = targetH
            surfaceH = Max(0, h - surfaceTop)
            pnlSurface.SetLayoutAnimated(0, 0, surfaceTop, w, surfaceH)
        End If
    End If

    Dim contentW As Int = Max(0, w - (miPaddingDip * 2))
    Dim contentH As Int = Max(0, surfaceH - contentTop - miPaddingDip)
    pnlContent.SetLayoutAnimated(0, miPaddingDip, contentTop, contentW, contentH)
End Sub

Private Sub MeasureContentBottom As Int
    If pnlContent.IsInitialized = False Then Return 0
    Dim m As Int = 0
    For i = 0 To pnlContent.NumberOfViews - 1
        Dim v As B4XView = pnlContent.GetView(i)
        m = Max(m, v.Top + v.Height)
    Next
    Return m
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If mBase.IsInitialized = False Then
        Dim p As B4XView = xui.CreatePanel("pnlAuto")
        Dim w As Int = Width
        If w <= 0 Then w = mDefaultWidthDip
        Parent.AddView(p, Left, Top, w, Height)
        DesignerCreateView(p, Null, CreateMap( _
            "Legend":"", _
            "Padding":miPaddingDip, _
            "AutoHeight":mbAutoHeight, _
            "BorderStyle":"outlined", _
            "Rounded":"theme", _
            "RoundedBox":True, _
            "BorderSize":1, _
            "BackgroundColor":"bg-base-200", _
            "BorderColor":"border-base-300" _
        ))
    End If
    DisableClippingChain(Parent, 3)
    Return mBase
End Sub

Public Sub setLegend(l As String)
    msLegend = l
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLegend As String
    Return msLegend
End Sub

Public Sub setLegendSize(s As String)
    msLegendSize = s
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLegendSize As String
    Return msLegendSize
End Sub

Public Sub setVariant(v As String)
    msVariant = v
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setBorderStyle(s As String)
    msBorderStyle = s
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderStyle As String
    Return msBorderStyle
End Sub

Public Sub setPadding(Value As Int)
    miPaddingDip = Max(0, Value) * 1dip
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPadding As Int
    Return Round(miPaddingDip / 1dip)
End Sub

Public Sub setAutoHeight(Value As Boolean)
    mbAutoHeight = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getAutoHeight As Boolean
    Return mbAutoHeight
End Sub

Public Sub setBackgroundColor(Value As Object)
    mcBackgroundColor = ResolveColorValue(Value, mcBackgroundColor)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setTextColor(Value As Object)
    mcTextColor = ResolveColorValue(Value, mcTextColor)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mcTextColor
End Sub

Public Sub setBorderColor(Value As Object)
    If Value Is String Then
        Dim s As String = Value
        If s.Trim.Length = 0 Then
            mcBorderColor = 0
        Else
            mcBorderColor = ResolveColorValue(Value, mcBorderColor)
        End If
    Else
        mcBorderColor = ResolveColorValue(Value, mcBorderColor)
    End If
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderColor As Int
    Return mcBorderColor
End Sub

Public Sub setBorderSize(Value As Int)
    miBorderSize = Max(0, Value) * 1dip
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderSize As Int
    Return Round(miBorderSize / 1dip)
End Sub

Public Sub setRounded(Value As String)
    msRounded = NormalizeRoundedMode(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub isRounded As Boolean
    Dim mode As String = NormalizeRoundedMode(msRounded)
    If mode = "theme" Then Return mbRoundedBox
    Return mode <> "rounded-none"
End Sub

Public Sub setRoundedBox(b As Boolean)
    mbRoundedBox = b
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub isRoundedBox As Boolean
    Return mbRoundedBox
End Sub

Public Sub setShadow(s As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(s)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub GetContentPanel As B4XView
    Return pnlContent
End Sub

Public Sub AddContentView(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    If pnlContent.IsInitialized = False Then Return
    If v.IsInitialized = False Then Return
    v.RemoveViewFromParent
    pnlContent.AddView(v, Left, Top, Width, Height)
    If mbAutoHeight Then Refresh
End Sub

Public Sub ClearContent
    If pnlContent.IsInitialized = False Then Return
    pnlContent.RemoveAllViews
    If mbAutoHeight Then Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub Refresh
    EnsureShadowVisibility
    RebuildLayout
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    EnsureShadowVisibility
    RebuildLayout
End Sub
