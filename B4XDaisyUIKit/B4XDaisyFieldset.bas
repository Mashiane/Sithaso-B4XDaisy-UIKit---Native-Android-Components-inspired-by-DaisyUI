B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Legend, DisplayName: Legend, FieldType: String, DefaultValue: Legend Caption, Description: Caption text shown in the fieldset header
#DesignerProperty: Key: LegendSize, DisplayName: Legend Size, FieldType: String, DefaultValue: text-sm, List: text-xs|text-sm|text-base|text-lg|text-xl, Description: Tailwind-like text size token for legend
#DesignerProperty: Key: LegendBold, DisplayName: Legend Bold, FieldType: Boolean, DefaultValue: False, Description: Render the legend caption in bold
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Optional accent variant for border tint
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: outlined, List: outlined|ghost|inset, Description: Border visual style
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 16, Description: Inner content padding in dip (p-4)
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: False, Description: Automatically grow to fit added content
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color (0 = default bg-base-200)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Legend text color (0 = use theme token)
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color override (0 = default border-base-300)
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip
#DesignerProperty: Key: InputBorder, DisplayName: Input Border, FieldType: Boolean, DefaultValue: False, Description: When True, apply B4XDaisyInput border color and width to the fieldset
#DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: Boolean, DefaultValue: False, Description: If True, the legend text is displayed as a label above the border box
#DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Adds a red star * to the Legend/Label when LabelAbove = True

#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Private mBase As B4XView
    Private mCallBack As Object
    Private mEventName As String
    Private mTag As Object
    Private mbBatchUpdate As Boolean = False
    Private mbBatchDirty As Boolean = False

    Private msLegend As String = "Legend Caption"
    Private msVariant As String = "none"
    Private msLegendSize As String = "text-sm"
    Private mbLegendBold As Boolean = False
    Private msBorderStyle As String = "outlined"
    Private miPaddingDip As Int = 16dip
    Private mbAutoHeight As Boolean = False
    Private msRounded As String = "theme"
    Private msShadow As String = "none"
    Private mcBackgroundColor As Int = 0
    Private mcTextColor As Int = 0
    Private mcBorderColor As Int = 0
    Private miBorderSize As Int = 1dip
    Private mbInputBorder As Boolean = False
    Private mbLabelAbove As Boolean = False
    Private mbRequired As Boolean = False

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
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
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

    Dim lblLbl As Label
    lblLbl.Initialize("")
    lblLbl.SingleLine = True
    lblLegend = lblLbl
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

    ApplyDesignerProps(mProps)
    MoveChildrenToContent(existingChildren)
    Refresh
End Sub

Public Sub ApplyDesignerProps(mProps As Map)
    msLegend = B4XDaisyVariants.GetPropString(mProps, "Legend", "Legend Caption")
    msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", "none")
    msLegendSize = B4XDaisyVariants.GetPropString(mProps, "LegendSize", "text-sm")
    mbLegendBold = B4XDaisyVariants.GetPropBool(mProps, "LegendBold", False)
    msBorderStyle = B4XDaisyVariants.GetPropString(mProps, "BorderStyle", "outlined")
    miPaddingDip = B4XDaisyVariants.GetPropInt(mProps, "Padding", 16)
    mbAutoHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoHeight", False)
    msRounded = NormalizeRoundedMode(B4XDaisyVariants.GetPropString(mProps, "Rounded", "theme"))

    ' Backward compatibility: migrate legacy RoundedBox=True designer prop
    If mProps.ContainsKey("RoundedBox") Then
        Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
        If bLegacyBox And (msRounded = "theme" Or msRounded = "") Then
            msRounded = "rounded-box"
        End If
    End If
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", "none"))
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
    mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
    mcBorderColor = B4XDaisyVariants.GetPropColor(mProps, "BorderColor", mcBorderColor)
    miBorderSize = B4XDaisyVariants.GetPropInt(mProps, "BorderSize", 1) * 1dip
    mbInputBorder = B4XDaisyVariants.GetPropBool(mProps, "InputBorder", False)
    mbLabelAbove = B4XDaisyVariants.GetPropBool(mProps, "LabelAbove", False)
    mbRequired = B4XDaisyVariants.GetPropBool(mProps, "Required", False)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Legend", msLegend)
	props.Put("LegendSize", msLegendSize)
	props.Put("LegendBold", mbLegendBold)
	props.Put("Variant", msVariant)
	props.Put("BorderStyle", msBorderStyle)
	props.Put("Padding", miPaddingDip / 1dip)
	props.Put("AutoHeight", mbAutoHeight)
	props.Put("Rounded", msRounded)
	props.Put("Shadow", msShadow)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("TextColor", mcTextColor)
	props.Put("BorderColor", mcBorderColor)
	props.Put("BorderSize", miBorderSize / 1dip)
	props.Put("InputBorder", mbInputBorder)
	props.Put("LabelAbove", mbLabelAbove)
	props.Put("Required", mbRequired)
	Return props
End Sub

Private Sub ResolveColorValue(oValue As Object, iDefaultColor As Int) As Int
    If oValue = Null Then Return iDefaultColor
    If IsNumber(oValue) Then Return oValue
    Dim s As String = oValue
    s = s.Trim
    If s.Length = 0 Then Return iDefaultColor
    Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
    If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, iDefaultColor)
    Return iDefaultColor
End Sub

Private Sub MoveChildrenToContent(lstChildren As List)
    If lstChildren.IsInitialized = False Then Return
    For Each v As B4XView In lstChildren
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

Private Sub MeasureLegendTextMetrics(sText As String, fntFont As B4XFont) As Map
    Dim m As Map
    m.Initialize
    m.Put("w", 0)
    m.Put("h", 0)
    If sText = Null Then Return m
    Dim t As String = sText.Trim
    If t.Length = 0 Then Return m
    Dim r As B4XRect = cvsMeasure.MeasureText(t, fntFont)
    m.Put("w", Ceil(r.Width))
    m.Put("h", Ceil(r.Height))
    Return m
End Sub

Private Sub MeasureLegendTextWidthExact(sText As String, iFallbackWidth As Int) As Int
    Dim t As String = IIf(sText = Null, "", sText.Trim)
    If t.Length = 0 Then Return 0
    #If B4A
    Try
        Dim jo As JavaObject = lblLegend
        Dim paint As JavaObject = jo.RunMethod("getPaint", Null)
        Dim w As Float = paint.RunMethod("measureText", Array(t))
        Return Max(iFallbackWidth, Ceil(w))
    Catch
        Return iFallbackWidth
    End Try
    #Else
    Return iFallbackWidth
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
    If mbInputBorder Then Return ResolveInputBorderColor
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

Private Sub ResolveInputBorderColor As Int
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Dim defaultColor As Int = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.2)
    Select msVariant
        Case "neutral": Return B4XDaisyVariants.GetTokenColor("--color-neutral", defaultColor)
        Case "primary": Return B4XDaisyVariants.GetTokenColor("--color-primary", defaultColor)
        Case "secondary": Return B4XDaisyVariants.GetTokenColor("--color-secondary", defaultColor)
        Case "accent": Return B4XDaisyVariants.GetTokenColor("--color-accent", defaultColor)
        Case "info": Return B4XDaisyVariants.GetTokenColor("--color-info", defaultColor)
        Case "success": Return B4XDaisyVariants.GetTokenColor("--color-success", defaultColor)
        Case "warning": Return B4XDaisyVariants.GetTokenColor("--color-warning", defaultColor)
        Case "error": Return B4XDaisyVariants.GetTokenColor("--color-error", defaultColor)
        Case Else: Return defaultColor
    End Select
End Sub

Private Sub ResolveInputBorderSize As Int
    Return Max(1dip, B4XDaisyVariants.GetBorderDip(1dip)) * 2
End Sub

Private Sub ResolveFieldsetBorderSize As Int
    If mbInputBorder Then Return ResolveInputBorderSize
    ' Respect explicit 0 as "no border".
    ' Use the same --border theme token that Input uses (GetBorderDip) so the
    ' fieldset border width stays in sync with input borders across themes.
    Dim themeBorder As Float = B4XDaisyVariants.GetBorderDip(miBorderSize)
    Return Max(0, Round(themeBorder))
End Sub

Private Sub NormalizeRoundedMode(sValue As String) As String
    If sValue = Null Then Return "theme"
    Dim s As String = sValue.ToLowerCase.Trim
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
        If msRounded = "rounded-box" Or msRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
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
    B4XDaisyVariants.DisableClippingChain(mBase, 4)
    B4XDaisyVariants.DisableClippingChain(pnlSurface, 1)
    B4XDaisyVariants.DisableClippingChain(pnlLegendMask, 1)
End Sub


Private Sub ApplyLegendMaskShape(iBgColor As Int, fRadiusDip As Float, iStrokeColor As Int, iStrokeDip As Int)
    #If B4A
    Try
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setShape", Array(0)) ' RECTANGLE
        gd.RunMethod("setColor", Array(iBgColor))
        Dim r As Float = Max(0, fRadiusDip)
        ' Top-left, top-right, bottom-right, bottom-left
        Dim radii() As Float = Array As Float(r, r, r, r, 0, 0, 0, 0)
        gd.RunMethod("setCornerRadii", Array(radii))
        If iStrokeDip > 0 Then gd.RunMethod("setStroke", Array(iStrokeDip, iStrokeColor))
        Dim jo As JavaObject = pnlLegendMask
        jo.RunMethod("setBackground", Array(gd))
    Catch
        pnlLegendMask.SetColorAndBorder(iBgColor, iStrokeDip, iStrokeColor, fRadiusDip)
    End Try
    #Else
    pnlLegendMask.SetColorAndBorder(iBgColor, iStrokeDip, iStrokeColor, fRadiusDip)
    #End If
End Sub

Private Sub ApplySurfaceShape(iBgColor As Int, fRadiusDip As Float, iStrokeColor As Int, iStrokeDip As Int)
    #If B4A
    Try
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setShape", Array(0)) ' RECTANGLE
        gd.RunMethod("setColor", Array(iBgColor))
        Dim r As Float = Max(0, fRadiusDip)
        ' Use the same corner-radii path as legend mask to keep border rendering parity.
        Dim radii() As Float = Array As Float(r, r, r, r, r, r, r, r)
        gd.RunMethod("setCornerRadii", Array(radii))
        If iStrokeDip > 0 Then gd.RunMethod("setStroke", Array(iStrokeDip, iStrokeColor))
        Dim jo As JavaObject = pnlSurface
        jo.RunMethod("setBackground", Array(gd))
    Catch
        pnlSurface.SetColorAndBorder(iBgColor, iStrokeDip, iStrokeColor, fRadiusDip)
    End Try
    #Else
    pnlSurface.SetColorAndBorder(iBgColor, iStrokeDip, iStrokeColor, fRadiusDip)
    #End If
End Sub

Private Sub RebuildLayout
    If mBase.IsInitialized = False Then Return

    Dim w As Int = Max(0, mBase.Width)
    Dim h As Int = Max(0, mBase.Height)
    
    Dim hasLegend As Boolean = msLegend.Trim.Length > 0
    Dim displayText As String = ResolveLegendDisplayText(msLegend)

    Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(msLegendSize, 14, 20)
    Dim fontSize As Float = tm.GetDefault("font_size", 14)
    Dim lineHeight As Int = Round(tm.GetDefault("line_height_px", fontSize * 1.45))
    Dim legendFont As B4XFont
    If mbLegendBold Then
        legendFont = xui.CreateDefaultBoldFont(fontSize)
    Else
        legendFont = xui.CreateDefaultFont(fontSize)
    End If
    lblLegend.Font = legendFont
    Dim labelColor As Int = ResolveLegendTextColor
    ApplyRequiredLegendText(lblLegend, displayText, labelColor, ResolveRequiredStarColor(labelColor))
    lblLegend.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)

    #If B4A
    Dim nativeLabel As Label = lblLegend
    nativeLabel.SingleLine = Not(mbLabelAbove)
    #End If

    Dim legendH As Int = 0
    Dim legendTextW As Int = 0
    Dim legendTextH As Int = 0
    Dim legendMaskW As Int = 0
    
    Dim borderSize As Int = ResolveFieldsetBorderSize

    If hasLegend Then
        If mbLabelAbove Then
            Dim tf As Object = Null
            #If B4A
            tf = Typeface.DEFAULT
            #End If
            legendTextH = B4XDaisyVariants.MeasureTextHeightSafe(displayText, fontSize, tf, Max(0, w - 4dip), 4dip)
            legendH = legendTextH + 4dip
            legendMaskW = Max(0, w - 4dip)
        Else
            Dim metric As Map = MeasureLegendTextMetrics(displayText, legendFont)
            legendTextW = metric.GetDefault("w", 0)
            legendTextW = MeasureLegendTextWidthExact(displayText, legendTextW)
            legendTextH = metric.GetDefault("h", lineHeight)
            Dim legendInnerH As Int = Max(lineHeight, legendTextH + 4dip)
            legendH = Max(1dip, legendInnerH + (mLegendPadYDip * 2) + 2dip)
            Dim legendHostW As Int = Max(0, w - (miPaddingDip * 2))
            legendMaskW = Min(legendHostW, legendTextW + (mLegendPadXDip * 2) + (borderSize * 2))
        End If
    End If

    Dim surfaceTop As Int = 0
    If mbLabelAbove Then
        If hasLegend Then
            surfaceTop = legendH - 2dip
        Else
            surfaceTop = 0
        End If
    Else
        If hasLegend Then
            Dim neededTopInset As Int = 0
            If mLegendNudgeYDip < 0 Then neededTopInset = Abs(mLegendNudgeYDip) + 2dip
            surfaceTop = Max(mTopInsetDip, neededTopInset)
        Else
            surfaceTop = 0
        End If
    End If

    Dim surfaceH As Int = Max(0, h - surfaceTop)
    pnlSurface.SetLayoutAnimated(0, 0, surfaceTop, w, surfaceH)

    Dim radiusDip As Float = ResolveCornerRadiusDip

    Dim bg As Int = ResolveFieldsetBackground
    Dim borderColor As Int = ResolveFieldsetBorderColor
    ApplySurfaceShape(bg, radiusDip, borderColor, borderSize)
    ApplyShadow

    Dim contentTop As Int = miPaddingDip
    If hasLegend Then
        Dim legendLeft As Int
        Dim legendTop As Int
        
        If mbLabelAbove Then
            legendLeft = 2dip
            legendTop = 0
            ' Legend sits outside/above the border box, so the box's top content
            ' inset matches the bottom inset (miPaddingDip) for symmetry.
            contentTop = miPaddingDip
        Else
            legendLeft = miPaddingDip - mLegendPadXDip
            If legendLeft < 0 Then legendLeft = 0
            legendTop = surfaceTop + mLegendNudgeYDip
        End If

        pnlLegendMask.Visible = True
        lblLegend.Visible = True
        
        If mbLabelAbove Then
            ApplyLegendMaskShape(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
        Else
            ApplyLegendMaskShape(bg, radiusDip, borderColor, borderSize)
        End If
        
        pnlLegendMask.SetLayoutAnimated(0, legendLeft, legendTop, legendMaskW, legendH)
        
        Dim joinY As Int = Max(0, surfaceTop - legendTop + borderSize)
        joinY = Min(legendH, joinY)
        Dim cutH As Int = Max(0, legendH - joinY)
        pnlLegendCut.Visible = (cutH > 0) And (mbLabelAbove = False)
        If pnlLegendCut.Visible Then
            pnlLegendCut.Color = bg
            pnlLegendCut.SetLayoutAnimated(0, 0, joinY, legendMaskW, cutH)
        Else
            pnlLegendCut.SetLayoutAnimated(0, 0, 0, 0, 0)
        End If
        
        Dim lblLeft, lblTop, lblW, lblH As Int
        If mbLabelAbove Then
            lblLeft = 0
            lblTop = 2dip
            lblW = legendMaskW
            lblH = legendTextH
        Else
            lblLeft = mLegendPadXDip + borderSize
            lblTop = Max(0, mLegendPadYDip - 1dip)
            lblW = Max(0, legendMaskW - (mLegendPadXDip * 2) - (borderSize * 2))
            lblH = Max(1dip, legendH - lblTop - mLegendPadYDip + 1dip)
        End If
        lblLegend.SetLayoutAnimated(0, lblLeft, lblTop, lblW, lblH)
        lblLegend.BringToFront
        
        If mbLabelAbove = False Then
            contentTop = Max(miPaddingDip, legendH + 2dip)
        End If
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

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If mBase.IsInitialized = False Then
        Dim p As B4XView = xui.CreatePanel("pnlAuto")
        Dim w As Int = iWidth
        If w <= 0 Then w = mDefaultWidthDip
        vParent.AddView(p, iLeft, iTop, w, iHeight)
        DesignerCreateView(p, Null, BuildRuntimeProps(w, iHeight))
    End If
    B4XDaisyVariants.DisableClippingChain(vParent, 3)
    Return mBase
End Sub

Private Sub ResolveLegendDisplayText(sBaseText As String) As String
    If sBaseText.Length > 0 And mbRequired And mbLabelAbove And sBaseText.Contains("*") = False Then
        Return sBaseText & " *"
    End If
    Return sBaseText
End Sub

Private Sub ResolveRequiredStarColor(iNormalColor As Int) As Int
    Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
End Sub

Private Sub ApplyRequiredLegendText(vLbl As B4XView, sDisplayText As String, iNormalColor As Int, iStarColor As Int)
    If sDisplayText.Length = 0 Then
        vLbl.Text = ""
        Return
    End If
    If mbRequired And mbLabelAbove And sDisplayText.Contains("*") Then
        Dim starPos As Int = sDisplayText.LastIndexOf("*")
        If starPos >= 0 Then
            Dim basePart As String = sDisplayText.SubString2(0, starPos)
            Dim cs As CSBuilder
            cs.Initialize
            If basePart.Length > 0 Then
                cs.Append(basePart)
            End If
            cs.Color(iStarColor).Append("*").Pop
            vLbl.TextColor = iNormalColor
            B4XDaisyVariants.SetTextOrCSBuilderToLabel(vLbl, cs)
            Return
        End If
    End If
    vLbl.Text = sDisplayText
    vLbl.TextColor = iNormalColor
End Sub

Public Sub setRequired(bValue As Boolean)
    mbRequired = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRequired As Boolean
    Return mbRequired
End Sub

Public Sub setLegend(sL As String)
    msLegend = sL
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLegend As String
    Return msLegend
End Sub

Public Sub setLegendSize(sValue As String)
    msLegendSize = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLegendSize As String
    Return msLegendSize
End Sub

Public Sub setLegendBold(bValue As Boolean)
    mbLegendBold = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLegendBold As Boolean
    Return mbLegendBold
End Sub

Public Sub setVariant(sV As String)
    msVariant = sV
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setBorderStyle(sValue As String)
    msBorderStyle = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderStyle As String
    Return msBorderStyle
End Sub

Public Sub setPadding(iValue As Int)
    miPaddingDip = Max(0, iValue) * 1dip
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPadding As Int
    Return Round(miPaddingDip / 1dip)
End Sub

Public Sub setAutoHeight(bValue As Boolean)
    mbAutoHeight = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getAutoHeight As Boolean
    Return mbAutoHeight
End Sub

Public Sub setBackgroundColor(oValue As Object)
    mcBackgroundColor = ResolveColorValue(oValue, mcBackgroundColor)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setTextColor(oValue As Object)
    mcTextColor = ResolveColorValue(oValue, mcTextColor)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mcTextColor
End Sub

Public Sub setBorderColor(oValue As Object)
    If oValue Is String Then
        Dim s As String = oValue
        If s.Trim.Length = 0 Then
            mcBorderColor = 0
        Else
            mcBorderColor = ResolveColorValue(oValue, mcBorderColor)
        End If
    Else
        mcBorderColor = ResolveColorValue(oValue, mcBorderColor)
    End If
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderColor As Int
    Return mcBorderColor
End Sub

Public Sub setBorderSize(iValue As Int)
    miBorderSize = Max(0, iValue) * 1dip
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderSize As Int
    Return Round(miBorderSize / 1dip)
End Sub

Public Sub setInputBorder(bValue As Boolean)
    mbInputBorder = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getInputBorder As Boolean
    Return mbInputBorder
End Sub

Public Sub setLabelAbove(bValue As Boolean)
    mbLabelAbove = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLabelAbove As Boolean
    Return mbLabelAbove
End Sub

Public Sub setRounded(sValue As String)
    msRounded = NormalizeRoundedMode(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub isRounded As Boolean
    Dim mode As String = NormalizeRoundedMode(msRounded)
    If mode = "rounded-box" Or mode = "theme" Then Return True
    Return mode <> "rounded-none"
End Sub

Public Sub setRoundedBox(bValue As Boolean)
    If bValue Then
        setRounded("rounded-box")
    Else
        setRounded("rounded-none")
    End If
End Sub

Public Sub isRoundedBox As Boolean
    Return (msRounded = "rounded-box" Or msRounded = "theme")
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub GetContentPanel As B4XView
    Return pnlContent
End Sub

Public Sub AddContentView(vView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If pnlContent.IsInitialized = False Then Return
    If vView.IsInitialized = False Then Return
    vView.RemoveViewFromParent
    pnlContent.AddView(vView, iLeft, iTop, iWidth, iHeight)
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

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub Refresh
    If mbBatchUpdate Then
        mbBatchDirty = True
        Return
    End If
    EnsureShadowVisibility
    RebuildLayout
End Sub

' Wrap multiple property changes so the fieldset only rebuilds once.
' Setters that call Refresh become no-ops until EndUpdate.
Public Sub BeginUpdate
    mbBatchUpdate = True
End Sub

Public Sub EndUpdate
    mbBatchUpdate = False
    If mbBatchDirty Then
        mbBatchDirty = False
        Refresh
    End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If inResize Then Return
    inResize = True
    EnsureShadowVisibility
    RebuildLayout
    inResize = False
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized Then Return mBase.Top
	Return 0
End Sub

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region

Public Sub Release
    Try
        cvsMeasure.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFieldset.Release: " & LastException.Message)
    End Try
    If pnlSurface.IsInitialized Then pnlSurface.RemoveViewFromParent
    If pnlLegendMask.IsInitialized Then pnlLegendMask.RemoveViewFromParent
    If pnlLegendCut.IsInitialized Then pnlLegendCut.RemoveViewFromParent
    If pnlContent.IsInitialized Then pnlContent.RemoveViewFromParent
    If pnlMeasure.IsInitialized Then pnlMeasure.RemoveViewFromParent
    mCallBack = Null
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub