B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12,9

#Region Events
    #Event: Changed(Index As Int, Key As String, Value As String)
    #Event: Click(Tag As Object)
#End Region

#Region Designer Properties
    #DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|ghost|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI color variant applied to border and focus outline.
    #DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: md|lg|xl, Description: DaisyUI size variant controlling height and font-size.
    #DesignerProperty: Key: Placeholder, DisplayName: Placeholder, FieldType: String, DefaultValue: Pick an option, Description: Placeholder text shown when no item is selected.
    #DesignerProperty: Key: LabelAbove, DisplayName: Label Above, FieldType: String, DefaultValue:, Description: Optional label text displayed above the select trigger.
    #DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Helper text displayed below the select trigger.
    #DesignerProperty: Key: Required, DisplayName: Required, FieldType: Boolean, DefaultValue: False, Description: Whether an option must be selected.
    #DesignerProperty: Key: ErrorText, DisplayName: Error Text, FieldType: String, DefaultValue:, Description: Error text displayed below the select when validation fails.
    #DesignerProperty: Key: Radius, DisplayName: Corner Radius, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius token for the select trigger.
    #DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Whether the select is enabled.
    #DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Controls view visibility.
    #DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override background color for the trigger.
    #DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override text color for the selected value.
    #DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level for the trigger.
    #DesignerProperty: Key: Alpha, DisplayName: Alpha, FieldType: Float, DefaultValue: 1.0, Description: View opacity from 0 (invisible) to 1 (fully opaque).
    #DesignerProperty: Key: MaxDropdownRows, DisplayName: Max Dropdown Rows, FieldType: Int, DefaultValue: 5, Description: Maximum number of visible rows in the dropdown before scrolling.
    #DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Variant applied to the background and content color of the selected item in the dropdown. none = follow Variant.
#End Region

#Region Component Code

' -----------------------------------------------------------------------
' ARCHITECTURE: Standalone native view layer (Input methodology)
' ---------------------------------------------------------------------------
' B4XDaisySelect builds its own visual layer - no dependency on B4XDaisyInput.
' The trigger is a pnlSurface panel (border/bg/radius) containing lblValue
' (selected text / placeholder) and cvsChevron (B4XCanvas chevron icon, same
' pattern as B4XDaisyCollapse). Layout and visual styling are driven by
' Base_Resize + ApplyVisual exactly as in B4XDaisyInput. Clicking pnlSurface
' toggles the dropdown overlay.
' -----------------------------------------------------------------------

Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    ' -- Trigger visual layer --
    Private pnlSurface As B4XView
    Private lblValue As B4XView
    Private pnlChevron As B4XView
    Private cvsChevron As B4XCanvas

    ' -- Optional label above / hint below (mirrors Input) --
    Private pnlLabelAbove As B4XView
    Private lblLabelAbove As B4XView
    Private pnlHintText As B4XView
    Private lblHintText As B4XView

    ' -- Dropdown overlay views --
    Private pnlOverlay As B4XView
    Private pnlDropdown As B4XView
    Private svOptions As ScrollView
    Private pnlOptionsInner As B4XView

    ' -- State variables --
    Private msVariant As String = "none"
    Private msSize As String = "md"
    Private msPlaceholder As String = "Pick an option"
    Private msLabelAbove As String = ""
    Private msHintText As String = ""
    Private mbRequired As Boolean = False
    Private msErrorText As String = ""
    Private msRadius As String = "theme"
    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private mcBackgroundColor As Int = 0
    Private mcTextColor As Int = 0
    Private msShadow As String = "none"
    Private mfAlpha As Float = 1.0
    Private miMaxDropdownRows As Int = 5
    Private msActiveColor As String = "none"
    Private mbDropdownOpen As Boolean = False
    Private mbFocused As Boolean = False
        Private mbValidationTouched As Boolean = False
        Private mbProgrammaticError As Boolean = False
    Private mApplyingVisual As Boolean = False
    Private mChevronColor As Int = -1

    ' -- Data --
    Private mItems As List          ' Display text for each option
    Private mItemValues As List     ' Underlying values (parallel to mItems); same as mItems when no explicit values set
    Private miSelectedIndex As Int = -1
    Private miDropdownInset As Int = 0  ' inner inset so option highlights don't bleed over border
    Private mOptionPanels As List
    Private mOptionLabels As List
    Private mParentScrollViews As List
    ' Checkmark removed - dropdown no longer shows a checkmark icon or divider lines
	Private inResize As Boolean = False
End Sub
#End Region
#Region Initialization
''' <summary>
''' Initializes the component. Stores callback context only.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
    mItemValues.Initialize
    mOptionPanels.Initialize
    mOptionLabels.Initialize
    mParentScrollViews.Initialize
End Sub

''' <summary>
''' Designer entry point. Builds the full view hierarchy using Input methodology.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    ' -- pnlSurface: the visible trigger shell (border / bg / radius) --
    Dim pSurf As Panel
    pSurf.Initialize("pnlsel")
    pnlSurface = pSurf
    pnlSurface.Color = xui.Color_Transparent
    mBase.AddView(pnlSurface, 0, 0, 1dip, 1dip)

    ' -- lblValue: selected value / placeholder label --
    Dim lv As Label
    lv.Initialize("")
    lblValue = lv
    lblValue.Color = xui.Color_Transparent
    lblValue.SetTextAlignment("CENTER", "LEFT")
    #If B4A
        Dim joLV As JavaObject = lblValue
        joLV.RunMethod("setSingleLine", Array(True))
        joLV.RunMethod("setIncludeFontPadding", Array(False))
        joLV.RunMethod("setClickable", Array(False)) ' Pass clicks through to pnlSurface
    #End If
    pnlSurface.AddView(lblValue, 0, 0, 1dip, 1dip)

    ' -- pnlChevron + cvsChevron: right-side chevron icon (B4XCanvas) --
    Dim pChev As Panel
    pChev.Initialize("")
    pnlChevron = pChev
    pnlChevron.Color = xui.Color_Transparent
    pnlSurface.AddView(pnlChevron, 0, 0, 1dip, 1dip)

    cvsChevron.Initialize(pnlChevron)
    #If B4A
        ' Make pnlChevron non-clickable so touch events pass through to pnlSurface
        Dim joChev As JavaObject = pnlChevron
        joChev.RunMethod("setClickable", Array(False))
    #End If

    ' -- pnlLabelAbove: optional label above the trigger --
    Dim pLA As Panel
    pLA.Initialize("")
    pnlLabelAbove = pLA
    pnlLabelAbove.Color = xui.Color_Transparent
    mBase.AddView(pnlLabelAbove, 0, 0, 0, 0)

    Dim lLA As Label
    lLA.Initialize("")
    lblLabelAbove = lLA
    lblLabelAbove.Color = xui.Color_Transparent
    lblLabelAbove.SetTextAlignment("LEFT", "LEFT")
    lblLabelAbove.As(Label).SingleLine = False
    pnlLabelAbove.AddView(lblLabelAbove, 0, 0, 0, 0)

    ' -- pnlHintText: optional hint / helper text below the trigger --
    Dim pHT As Panel
    pHT.Initialize("")
    pnlHintText = pHT
    pnlHintText.Color = xui.Color_Transparent
    mBase.AddView(pnlHintText, 0, 0, 0, 0)

    Dim lHT As Label
    lHT.Initialize("")
    lblHintText = lHT
    lblHintText.Color = xui.Color_Transparent
    lblHintText.SetTextAlignment("LEFT", "LEFT")
    lblHintText.As(Label).SingleLine = False
    pnlHintText.AddView(lblHintText, 0, 0, 0, 0)

    ApplyDesignerProps(mProps)
    RegisterDetachListener
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    msVariant     = B4XDaisyVariants.GetPropString(mProps, "Variant", "none")
    msSize        = B4XDaisyVariants.GetPropString(mProps, "Size", "md")
    msPlaceholder = B4XDaisyVariants.GetPropString(mProps, "Placeholder", "Pick an option")
    msLabelAbove  = B4XDaisyVariants.GetPropString(mProps, "LabelAbove", "")
    msHintText    = B4XDaisyVariants.GetPropString(mProps, "HintText", "")
    mbRequired    = B4XDaisyVariants.GetPropBool(mProps, "Required", False)
    msErrorText   = B4XDaisyVariants.GetPropString(mProps, "ErrorText", "")
    msRadius      = B4XDaisyVariants.GetPropString(mProps, "Radius", "theme")
    Dim radiusAlt As String = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRadius)
    If radiusAlt <> "theme" Then msRadius = radiusAlt
    mbEnabled         = B4XDaisyVariants.GetPropBool(mProps, "Enabled", True)
    mbVisible         = B4XDaisyVariants.GetPropBool(mProps, "Visible", True)
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", 0)
    mcTextColor       = B4XDaisyVariants.GetPropColor(mProps, "TextColor", 0)
    msShadow          = B4XDaisyVariants.GetPropString(mProps, "Shadow", "none")
    mfAlpha           = B4XDaisyVariants.GetPropFloat(mProps, "Alpha", 1.0)
    miMaxDropdownRows = B4XDaisyVariants.GetPropInt(mProps, "MaxDropdownRows", 5)
    msActiveColor    = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "ActiveColor", "none"))
End Sub
#End Region

#Region Layout - Base_Resize + ApplyVisual

''' <summary>
''' Responsive layout - mirrors B4XDaisyInput.Base_Resize pattern.
''' </summary>
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If pnlSurface.IsInitialized = False Then Return

    If inResize Then Return
    inResize = True
    Dim w As Int = dWidth
    If w <= 0 Then w = 200dip

    Dim triggerH As Int = ResolveHeightDip
    Dim gap As Int = 4dip

    ' -- Measure optional label above --
    Dim labelAboveH As Int = 0
    Dim measuredLabelH As Int = 0
    If msLabelAbove.Length > 0 Then
        Dim aboveTextSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-sm")
        measuredLabelH = B4XDaisyVariants.MeasureTextHeightSafe(msLabelAbove, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
        labelAboveH = measuredLabelH + 4dip
    End If

    ' -- Measure optional hint / error text below --
    Dim displayedHint As String = msHintText
    If msErrorText.Length > 0 Then displayedHint = msErrorText
    Dim rawHintH As Int = 0
    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
    End If

    ' -- Total height and mBase resize --
    Dim totalH As Int = labelAboveH + triggerH
    If rawHintH > 0 Then totalH = totalH + gap + rawHintH

    Dim curLeft As Int = mBase.Left
    Dim curTop As Int = mBase.Top
    mBase.SetLayoutAnimated(0, curLeft, curTop, w, totalH)

    ' -- Label above --
    If msLabelAbove.Length > 0 Then
        pnlLabelAbove.Visible = True
        pnlLabelAbove.SetLayoutAnimated(0, 0, 0, w, labelAboveH)
        lblLabelAbove.SetLayoutAnimated(0, 2dip, 2dip, w - 4dip, measuredLabelH)
        Dim labelAboveColor As Int = ResolveLabelAboveColor
        ApplyRequiredLabelText(lblLabelAbove, ResolveLabelAboveText, labelAboveColor, ResolveRequiredStarColor(labelAboveColor))
        lblLabelAbove.TextSize = B4XDaisyVariants.ResolveTextSizeDip("text-sm")
    Else
        pnlLabelAbove.Visible = False
        pnlLabelAbove.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If

    ' -- pnlSurface: the trigger shell --
    Dim surfaceY As Int = labelAboveH
    pnlSurface.SetLayoutAnimated(0, 0, surfaceY, w, triggerH)

    ' -- Chevron icon sizing and position (right-aligned, ps-3 pe-7 pattern) --
    ' DaisyUI uses pe-7 (28dip) for the right padding area that holds the chevron arrow.
    ' We replicate this with a dedicated icon panel on the right.
    Dim chevSize As Int = triggerH - 16dip
    If chevSize < 10dip Then chevSize = 10dip
    Dim chevW As Int = chevSize + 8dip   ' icon + small margin
    Dim chevX As Int = w - chevW - 4dip
    Dim chevY As Int = (triggerH - chevSize) / 2
    pnlChevron.SetLayoutAnimated(0, chevX, chevY, chevW, chevSize)
    cvsChevron.Resize(chevSize, chevSize)
    ' Note: DrawChevron is NOT called here because mChevronColor is still
    ' the default 0 (transparent) at this point. ApplyVisual sets the real
    ' color and calls DrawChevron after.

    ' -- lblValue: selected text / placeholder inside trigger --
    ' DaisyUI: ps-3 (12dip) left pad, right boundary before chevron
    Dim lbLeft As Int = ResolveStartPaddingDip
    Dim lbRight As Int = chevX - 4dip
    Dim lbW As Int = Max(10dip, lbRight - lbLeft)
    Dim lbH As Int = triggerH - 4dip
    Dim lbTop As Int = (triggerH - lbH) / 2
    lblValue.SetLayoutAnimated(0, lbLeft, lbTop, lbW, lbH)

    ' -- Hint / error text below --
    If rawHintH > 0 Then
        pnlHintText.Visible = True
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        lblHintText.Text = displayedHint
        lblHintText.TextSize = hintTxtSize
        Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
        Dim hintColor As Int = Bit.Or(0x99000000, Bit.And(0x00FFFFFF, baseContent))
        If msErrorText.Length > 0 Then hintColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
        lblHintText.TextColor = hintColor
        Dim hintY As Int = surfaceY + triggerH + gap
        pnlHintText.SetLayoutAnimated(0, 0, hintY, w, rawHintH)
        lblHintText.SetLayoutAnimated(0, 0, 0, w, rawHintH)
    Else
        pnlHintText.Visible = False
        pnlHintText.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If

    ApplyVisual
    inResize = False
End Sub

''' <summary>
''' Applies all visual styling to the trigger - bg, border, text, chevron color.
''' Mirrors B4XDaisyInput.ApplyVisual pattern exactly.
''' </summary>
Private Sub ApplyVisual
    If pnlSurface.IsInitialized = False Then Return
    If mApplyingVisual Then Return
    mApplyingVisual = True

    Dim base100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", 0xFFFFFFFF)
    Dim base200 As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", 0xFFE5E7EB)
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)

    Dim borderDip As Int = Max(1dip, B4XDaisyVariants.GetBorderDip(1dip))
    Dim radiusDip As Int = ResolveRadiusDip

    Dim bgColor As Int = base100
    Dim borderColor As Int = ResolveInputColor
    Dim textColor As Int = baseContent
    Dim placeholderColor As Int = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.5)
    Dim chevronColor As Int = baseContent

    If mcBackgroundColor <> 0 Then bgColor = mcBackgroundColor
    If mcTextColor <> 0 Then textColor = mcTextColor

    ' -- Ghost variant --
    If msVariant = "ghost" Then
        If mbFocused Then
            If mcBackgroundColor = 0 Then bgColor = base100
            borderColor = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.1)
        Else
            If mcBackgroundColor = 0 Then bgColor = base100
            borderColor = xui.Color_Transparent
        End If
    End If

    ' -- Disabled state --
    If mbEnabled = False Then
        If mcBackgroundColor = 0 Then bgColor = base200
        textColor = B4XDaisyVariants.Blend(baseContent, base200, 0.4)
        placeholderColor = B4XDaisyVariants.Blend(baseContent, base200, 0.2)
        chevronColor = placeholderColor
        ' Border color matches label-above when disabled (Blend 0.4)
        borderColor = B4XDaisyVariants.Blend(baseContent, base200, 0.4)
        ' Muted label-above when disabled
        If lblLabelAbove.IsInitialized Then
            lblLabelAbove.TextColor = B4XDaisyVariants.Blend(baseContent, base200, 0.4)
        End If
    Else
        ' -- Focus (dropdown open): intensify border --
        If mbFocused And msVariant <> "ghost" Then
            If msVariant <> "none" And msVariant <> "" Then
                borderColor = ResolveInputColor
            Else
                borderColor = baseContent
            End If
        End If
        chevronColor = ResolveInputColor
    End If

    ' -- Error state overrides --
    If mbEnabled And msErrorText.Length > 0 Then
        borderColor = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
    End If

    ' -- Apply border and background to pnlSurface --
    B4XDaisyVariants.ApplyEditTextBorder(pnlSurface, bgColor, borderDip, borderColor, radiusDip)
    B4XDaisyVariants.ApplyElevation(pnlSurface, msShadow)

    ' -- Enable/disable pnlSurface for touch feedback --
    #If B4A
        Dim joSurf As JavaObject = pnlSurface
        joSurf.RunMethod("setClickable", Array(mbEnabled))
    #End If

    ' -- lblValue: show selected text or styled placeholder --
    Dim textSize As Float = ResolveTextSize
    lblValue.TextSize = textSize
    Dim hasSelection As Boolean = (miSelectedIndex >= 0 And mItems.IsInitialized And miSelectedIndex < mItems.Size)
    If hasSelection Then
        Dim selVal As Object = mItems.Get(miSelectedIndex)
        Dim selStr As String = ""
        If selVal <> Null Then selStr = "" & selVal
        lblValue.Text = selStr
        lblValue.TextColor = textColor
    Else
        lblValue.Text = msPlaceholder
        lblValue.TextColor = placeholderColor
    End If

    ' -- Chevron canvas icon --
    mChevronColor = chevronColor
    DrawChevron

    ' -- Alpha --
    If mfAlpha < 1.0 Then mBase.Alpha = mfAlpha Else mBase.Alpha = 1.0

    ' -- Visibility --
    mBase.Visible = mbVisible

    ' -- Disable clipping so shadow is visible --
    B4XDaisyVariants.DisableClipping(mBase)
    B4XDaisyVariants.DisableClipping(pnlSurface)

    mApplyingVisual = False
End Sub

''' <summary>
''' Draws the chevron icon on cvsChevron using B4XCanvas - matches B4XDaisyCollapse.DrawIcon pattern.
''' Chevron points down when dropdown is closed, up when open.
''' </summary>
Private Sub DrawChevron
    If mChevronColor = -1 Then Return ' Not yet resolved - skip until ApplyVisual sets the real color
    cvsChevron.ClearRect(cvsChevron.TargetRect)
    Dim color As Int = mChevronColor
    Dim w As Float = cvsChevron.TargetRect.Width
    Dim h As Float = cvsChevron.TargetRect.Height
    Dim stroke As Float = 2dip

    Dim path As B4XPath
    If mbDropdownOpen Then
        ' Chevron pointing up (dropdown open)
        path.Initialize(w * 0.2, h * 0.6)
        path.LineTo(w * 0.5, h * 0.3)
        path.LineTo(w * 0.8, h * 0.6)
    Else
        ' Chevron pointing down (dropdown closed)
        path.Initialize(w * 0.2, h * 0.4)
        path.LineTo(w * 0.5, h * 0.7)
        path.LineTo(w * 0.8, h * 0.4)
    End If
    cvsChevron.DrawPath(path, color, False, stroke)
    cvsChevron.Invalidate
End Sub

Private Sub Refresh
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

#End Region

#Region Theme Resolution

Private Sub ResolveInputColor As Int
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Dim defaultColor As Int = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.2)
    Select msVariant
        Case "neutral":   Return B4XDaisyVariants.GetTokenColor("--color-neutral", defaultColor)
        Case "primary":   Return B4XDaisyVariants.GetTokenColor("--color-primary", defaultColor)
        Case "secondary": Return B4XDaisyVariants.GetTokenColor("--color-secondary", defaultColor)
        Case "accent":    Return B4XDaisyVariants.GetTokenColor("--color-accent", defaultColor)
        Case "info":      Return B4XDaisyVariants.GetTokenColor("--color-info", defaultColor)
        Case "success":   Return B4XDaisyVariants.GetTokenColor("--color-success", defaultColor)
        Case "warning":   Return B4XDaisyVariants.GetTokenColor("--color-warning", defaultColor)
        Case "error":     Return B4XDaisyVariants.GetTokenColor("--color-error", defaultColor)
        Case Else:        Return defaultColor
    End Select
End Sub

''' <summary>
''' Height per size variant - matches DaisyUI CSS: --size = --size-field * N.
''' Assumes --size-field = 4px (default). md=40, lg=48, xl=56.
''' </summary>
Private Sub ResolveHeightDip As Int
    Select msSize
        Case "lg": Return 48dip
        Case "xl": Return 56dip
        Case Else: Return 40dip ' md
    End Select
End Sub

''' <summary>
''' Font size per size variant - matches DaisyUI CSS font-size values.
''' </summary>
Private Sub ResolveTextSize As Float
    Select msSize
        Case "lg": Return 18   ' 1.125rem
        Case "xl": Return 22   ' 1.375rem
        Case Else: Return 14   ' 0.875rem (md)
    End Select
End Sub

''' <summary>
''' Left padding inside the trigger (DaisyUI: ps-3 = 12px).
''' </summary>
Private Sub ResolveStartPaddingDip As Int
    Select msSize
        Case "lg": Return 16dip
        Case "xl": Return 20dip
        Case Else: Return 12dip ' md = ps-3
    End Select
End Sub

''' <summary>
''' Option row padding X (from CSS: px-3 md, px-4 lg, px-5 xl).
''' </summary>
Private Sub ResolveOptionPaddingXDip As Int
    Select msSize
        Case "lg": Return 16dip
        Case "xl": Return 20dip
        Case Else: Return 12dip
    End Select
End Sub

''' <summary>
''' Option row padding Y (from CSS: py-1.5 md/lg/xl).
''' </summary>
Private Sub ResolveOptionPaddingYDip As Int
    Return 6dip
End Sub

Private Sub ResolveRadiusDip As Int
    Dim mode As String = B4XDaisyVariants.NormalizeRounded(msRadius)
    Select mode
        Case "rounded-none": Return 0
        Case "rounded-sm":   Return 2dip
        Case "rounded":      Return 4dip
        Case "rounded-md":   Return 6dip
        Case "rounded-lg":   Return 8dip
        Case "rounded-xl":   Return 12dip
        Case "rounded-2xl":  Return 16dip
        Case "rounded-3xl":  Return 24dip
        Case "rounded-full": Return 9999dip
        Case Else:           Return B4XDaisyVariants.GetRadiusFieldDip(8dip)
    End Select
End Sub

#End Region

#Region Public API

''' <summary>
''' Adds the component to a parent B4XView at the given position and size.
''' If not yet initialized, creates a new mBase panel and calls DesignerCreateView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then
        Dim empty As B4XView
        Return empty
    End If
    Dim finalW As Int = iWidth
    If finalW <= 0 Then finalW = Max(200dip, vParent.Width - iLeft * 2)
    If finalW <= 0 Then finalW = 200dip
    Dim finalH As Int = iHeight
    If finalH <= 0 Then finalH = ResolveHeightDip
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, finalW, finalH)
        Dim props As Map = BuildRuntimeProps
        Dim dummy As Label
        DesignerCreateView(b, dummy, props)
    End If
    ' After DesignerCreateView, mBase.Height includes label-above + trigger + hint-text.
    ' Use that computed height instead of the raw parameter to ensure proper sizing.
    Dim actualH As Int = finalH
    If mBase.IsInitialized And mBase.Height > 0 Then actualH = mBase.Height
    vParent.AddView(mBase, iLeft, iTop, finalW, actualH)
    Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
    Dim props As Map
    props.Initialize
    props.Put("Variant", msVariant)
    props.Put("Size", msSize)
    props.Put("Placeholder", msPlaceholder)
    props.Put("LabelAbove", msLabelAbove)
    props.Put("HintText", msHintText)
    props.Put("Radius", msRadius)
    props.Put("Rounded", msRadius)
    props.Put("Enabled", mbEnabled)
    props.Put("Visible", mbVisible)
    props.Put("BackgroundColor", mcBackgroundColor)
    props.Put("TextColor", mcTextColor)
    props.Put("Shadow", msShadow)
    props.Put("Alpha", mfAlpha)
    props.Put("MaxDropdownRows", miMaxDropdownRows)
    props.Put("ActiveColor", msActiveColor)
    Return props
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

''' <summary>
''' Returns True when the component's mBase is initialized and ready to use.
''' </summary>
Public Sub IsReady As Boolean
    Return mBase.IsInitialized
End Sub

''' <summary>
''' Forces the component to re-resolve theme-aware styling.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

' -----------------------------------------------------------------------
' PROPERTY SETTERS / GETTERS
' -----------------------------------------------------------------------


Private Sub ResolveLabelAboveText As String
    If mbRequired And msLabelAbove.Length > 0 Then
        If msLabelAbove.Contains("*") = False Then
            Return msLabelAbove & " *"
        End If
    End If
    Return msLabelAbove
End Sub

Private Sub ResolveLabelAboveColor As Int
    Dim c As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    If mbEnabled = False Then
        Return B4XDaisyVariants.AlphaColor(c, 0.2)
    End If
    Return c
End Sub

Private Sub ResolveRequiredStarColor(iNormalColor As Int) As Int
    If mbEnabled = False Then Return iNormalColor
    Return B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
End Sub

Private Sub ApplyRequiredLabelText(vLbl As B4XView, sDisplayText As String, iNormalColor As Int, iStarColor As Int)
    If sDisplayText.Length = 0 Then
        vLbl.Text = ""
        Return
    End If
    If mbRequired And sDisplayText.Contains("*") Then
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

Public Sub setVariant(sValue As String)
    If sValue = Null Then sValue = "none"
    msVariant = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

' Sets the variant used for the selected dropdown item's background + content color.
' Pass "none" to follow the select Variant.
Public Sub setActiveColor(sValue As String)
    msActiveColor = B4XDaisyVariants.NormalizeVariant(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActiveColor As String
    Return msActiveColor
End Sub

Public Sub setSize(sValue As String)
    If sValue = Null Then sValue = "md"
    msSize = sValue.ToLowerCase
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return msSize
End Sub

Public Sub setPlaceholder(sValue As String)
    If sValue = Null Then sValue = ""
    msPlaceholder = sValue
    If mBase.IsInitialized = False Then Return
    If miSelectedIndex < 0 Then Refresh
End Sub

Public Sub getPlaceholder As String
    Return msPlaceholder
End Sub

Public Sub setLabelAbove(sValue As String)
    If sValue = Null Then sValue = ""
    msLabelAbove = sValue.Trim
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLabelAbove As String
    Return msLabelAbove
End Sub

Public Sub setHintText(sValue As String)
    If sValue = Null Then sValue = ""
    msHintText = sValue.Trim
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHintText As String
    Return msHintText
End Sub

' Required / error validation helpers
Public Sub setRequired(bValue As Boolean)
    mbRequired = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRequired As Boolean
    Return mbRequired
End Sub

Public Sub setErrorText(sValue As String)
    If sValue = Null Then sValue = ""
    msErrorText = sValue.Trim
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getErrorText As String
    Return msErrorText
End Sub

Public Sub ShowError(sErrorMessage As String)
    msErrorText = sErrorMessage
    mbProgrammaticError = True
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub ClearError
    msErrorText = ""
    mbProgrammaticError = False
    mbValidationTouched = False
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIsValid As Boolean
    Return (msErrorText.Length = 0)
End Sub

''' <summary>
''' Validates the select. When Required=True and no option is selected,
''' shows the configured ErrorText (or a default message) and returns False.
''' </summary>
Public Sub Validate As Boolean
    If mbRequired = False Then
        mbProgrammaticError = False
        ClearError
        Return True
    End If
    If miSelectedIndex >= 0 Then
        mbProgrammaticError = False
        ClearError
        Return True
    End If
    mbValidationTouched = True
    Dim msg As String = msErrorText
    If msg.Length = 0 Then msg = "This field is required."
    ShowError(msg)
    Return False
End Sub
Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized = False Then Return
    If mbEnabled = False Then Close
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized Then
        mBase.Visible = bValue
        If bValue = False Then Close
    End If
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mcBackgroundColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
    Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(sVariantName, 0)
    If c <> 0 Then setBackgroundColor(c)
End Sub

Public Sub setTextColor(iValue As Int)
    mcTextColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mcTextColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
    Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(sVariantName, 0)
    If c <> 0 Then setTextColor(c)
End Sub

Public Sub setRadius(sValue As String)
    msRadius = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRadius As String
    Return msRadius
End Sub

Public Sub setRounded(sValue As String)
    setRadius(sValue)
End Sub

Public Sub getRounded As String
    Return msRadius
End Sub

Public Sub setShadow(sValue As String)
    msShadow = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setAlpha(fValue As Float)
    If fValue < 0 Then fValue = 0
    If fValue > 1 Then fValue = 1
    mfAlpha = fValue
    If mBase.IsInitialized Then mBase.Alpha = mfAlpha
End Sub

Public Sub getAlpha As Float
    Return mfAlpha
End Sub

Public Sub setMaxDropdownRows(iValue As Int)
    miMaxDropdownRows = Max(1, iValue)
End Sub

Public Sub getMaxDropdownRows As Int
    Return miMaxDropdownRows
End Sub

''' <summary>
''' Sets the list of option items from a Map where Key = underlying value, Value = display text.
''' Example: setItems(Map: "us" ? "United States", "uk" ? "United Kingdom")
''' Passing Null or an uninitialized Map clears all items.
''' </summary>
Public Sub setItems(mKeyValues As Map)
    mItems.Initialize
    mItemValues.Initialize
    If mKeyValues <> Null And mKeyValues.IsInitialized Then
        For Each k As String In mKeyValues.Keys
            Dim v As Object = mKeyValues.Get(k)
            mItemValues.Add(k)
            If v = Null Then
                mItems.Add("")
            Else
                mItems.Add("" & v)
            End If
        Next
    End If
    miSelectedIndex = -1
    If mbDropdownOpen Then Close
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getItems As List
    Return mItems
End Sub

''' <summary>
''' Sets the selected item by zero-based index. Pass -1 to clear selection.
''' Fires Changed event if the index changes.
''' </summary>
Public Sub setSelectedIndex(iValue As Int)
    If mItems.IsInitialized = False Then Return
    If iValue < -1 Then iValue = -1
    If iValue >= mItems.Size Then iValue = -1
    Dim oldIndex As Int = miSelectedIndex
    miSelectedIndex = iValue
    If mBase.IsInitialized Then Refresh
    If oldIndex <> iValue Then
        FireChanged(iValue)
    End If
End Sub

Public Sub getSelectedIndex As Int
    Return miSelectedIndex
End Sub

''' <summary>
''' Returns the underlying value of the currently selected item, or empty string if none.
''' Keys from setItems(Map) become the values returned here.
''' </summary>
Public Sub getSelectedValue As String
    If mItemValues.IsInitialized = False Then Return ""
    If miSelectedIndex < 0 Or miSelectedIndex >= mItemValues.Size Then Return ""
    Dim val As Object = mItemValues.Get(miSelectedIndex)
    If val = Null Then Return ""
    Return "" & val
End Sub



''' <summary>
''' Adds a single item with a distinct value and display text (HTML option pattern).
''' Value is the underlying key returned by SelectedValue/SelectedKey.
''' Text is what the user sees in the dropdown and trigger.
''' </summary>
Public Sub AddItem(sValue As String, sText As String)
    If mItems.IsInitialized = False Then mItems.Initialize
    If mItemValues.IsInitialized = False Then mItemValues.Initialize
    mItems.Add(sText)
    mItemValues.Add(sValue)
    If mbDropdownOpen Then Close
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Populates the select with the 12 calendar months (key = 01-12).
''' </summary>
Public Sub LoadMonths
    Clear
    AddItem("01", "January")
    AddItem("02", "February")
    AddItem("03", "March")
    AddItem("04", "April")
    AddItem("05", "May")
    AddItem("06", "June")
    AddItem("07", "July")
    AddItem("08", "August")
    AddItem("09", "September")
    AddItem("10", "October")
    AddItem("11", "November")
    AddItem("12", "December")
End Sub

''' <summary>
''' Populates the select with a curated list of countries.
''' </summary>
Public Sub LoadCountries
    Clear
    Dim countries As List
    countries.Initialize
    countries.Add("AF|Afghanistan")
    countries.Add("AL|Albania")
    countries.Add("DZ|Algeria")
    countries.Add("AD|Andorra")
    countries.Add("AO|Angola")
    countries.Add("AR|Argentina")
    countries.Add("AU|Australia")
    countries.Add("AT|Austria")
    countries.Add("BS|Bahamas")
    countries.Add("BD|Bangladesh")
    countries.Add("BB|Barbados")
    countries.Add("BY|Belarus")
    countries.Add("BE|Belgium")
    countries.Add("BZ|Belize")
    countries.Add("BJ|Benin")
    countries.Add("BT|Bhutan")
    countries.Add("BO|Bolivia")
    countries.Add("BA|Bosnia and Herzegovina")
    countries.Add("BW|Botswana")
    countries.Add("BR|Brazil")
    countries.Add("BN|Brunei")
    countries.Add("BG|Bulgaria")
    countries.Add("BF|Burkina Faso")
    countries.Add("BI|Burundi")
    countries.Add("KH|Cambodia")
    countries.Add("CM|Cameroon")
    countries.Add("CA|Canada")
    countries.Add("CV|Cape Verde")
    countries.Add("CF|Central African Republic")
    countries.Add("TD|Chad")
    countries.Add("CL|Chile")
    countries.Add("CN|China")
    countries.Add("CO|Colombia")
    countries.Add("KM|Comoros")
    countries.Add("CG|Congo")
    countries.Add("CR|Costa Rica")
    countries.Add("HR|Croatia")
    countries.Add("CU|Cuba")
    countries.Add("CY|Cyprus")
    countries.Add("CZ|Czech Republic")
    countries.Add("DK|Denmark")
    countries.Add("DJ|Djibouti")
    countries.Add("DO|Dominican Republic")
    countries.Add("EC|Ecuador")
    countries.Add("EG|Egypt")
    countries.Add("SV|El Salvador")
    countries.Add("GQ|Equatorial Guinea")
    countries.Add("ER|Eritrea")
    countries.Add("EE|Estonia")
    countries.Add("SZ|Eswatini")
    countries.Add("ET|Ethiopia")
    countries.Add("FJ|Fiji")
    countries.Add("FI|Finland")
    countries.Add("FR|France")
    countries.Add("GA|Gabon")
    countries.Add("GM|Gambia")
    countries.Add("GE|Georgia")
    countries.Add("DE|Germany")
    countries.Add("GH|Ghana")
    countries.Add("GR|Greece")
    countries.Add("GD|Grenada")
    countries.Add("GT|Guatemala")
    countries.Add("GN|Guinea")
    countries.Add("GY|Guyana")
    countries.Add("HT|Haiti")
    countries.Add("HN|Honduras")
    countries.Add("HK|Hong Kong")
    countries.Add("HU|Hungary")
    countries.Add("IS|Iceland")
    countries.Add("IN|India")
    countries.Add("ID|Indonesia")
    countries.Add("IR|Iran")
    countries.Add("IQ|Iraq")
    countries.Add("IE|Ireland")
    countries.Add("IL|Israel")
    countries.Add("IT|Italy")
    countries.Add("JM|Jamaica")
    countries.Add("JP|Japan")
    countries.Add("JO|Jordan")
    countries.Add("KZ|Kazakhstan")
    countries.Add("KE|Kenya")
    countries.Add("KI|Kiribati")
    countries.Add("KW|Kuwait")
    countries.Add("KG|Kyrgyzstan")
    countries.Add("LA|Laos")
    countries.Add("LV|Latvia")
    countries.Add("LB|Lebanon")
    countries.Add("LS|Lesotho")
    countries.Add("LR|Liberia")
    countries.Add("LY|Libya")
    countries.Add("LI|Liechtenstein")
    countries.Add("LT|Lithuania")
    countries.Add("LU|Luxembourg")
    countries.Add("MG|Madagascar")
    countries.Add("MW|Malawi")
    countries.Add("MY|Malaysia")
    countries.Add("MV|Maldives")
    countries.Add("ML|Mali")
    countries.Add("MT|Malta")
    countries.Add("MR|Mauritania")
    countries.Add("MU|Mauritius")
    countries.Add("MX|Mexico")
    countries.Add("FM|Micronesia")
    countries.Add("MD|Moldova")
    countries.Add("MC|Monaco")
    countries.Add("MN|Mongolia")
    countries.Add("ME|Montenegro")
    countries.Add("MA|Morocco")
    countries.Add("MZ|Mozambique")
    countries.Add("MM|Myanmar")
    countries.Add("NA|Namibia")
    countries.Add("NR|Nauru")
    countries.Add("NP|Nepal")
    countries.Add("NL|Netherlands")
    countries.Add("NZ|New Zealand")
    countries.Add("NI|Nicaragua")
    countries.Add("NE|Niger")
    countries.Add("NG|Nigeria")
    countries.Add("KP|North Korea")
    countries.Add("MK|North Macedonia")
    countries.Add("NO|Norway")
    countries.Add("OM|Oman")
    countries.Add("PK|Pakistan")
    countries.Add("PW|Palau")
    countries.Add("PS|Palestine")
    countries.Add("PA|Panama")
    countries.Add("PG|Papua New Guinea")
    countries.Add("PY|Paraguay")
    countries.Add("PE|Peru")
    countries.Add("PH|Philippines")
    countries.Add("PL|Poland")
    countries.Add("PT|Portugal")
    countries.Add("QA|Qatar")
    countries.Add("RO|Romania")
    countries.Add("RU|Russia")
    countries.Add("RW|Rwanda")
    countries.Add("WS|Samoa")
    countries.Add("SM|San Marino")
    countries.Add("SA|Saudi Arabia")
    countries.Add("SN|Senegal")
    countries.Add("RS|Serbia")
    countries.Add("SC|Seychelles")
    countries.Add("SL|Sierra Leone")
    countries.Add("SG|Singapore")
    countries.Add("SK|Slovakia")
    countries.Add("SI|Slovenia")
    countries.Add("SB|Solomon Islands")
    countries.Add("SO|Somalia")
    countries.Add("ZA|South Africa")
    countries.Add("KR|South Korea")
    countries.Add("SS|South Sudan")
    countries.Add("ES|Spain")
    countries.Add("LK|Sri Lanka")
    countries.Add("SD|Sudan")
    countries.Add("SR|Suriname")
    countries.Add("SE|Sweden")
    countries.Add("CH|Switzerland")
    countries.Add("SY|Syria")
    countries.Add("TW|Taiwan")
    countries.Add("TJ|Tajikistan")
    countries.Add("TZ|Tanzania")
    countries.Add("TH|Thailand")
    countries.Add("TL|Timor-Leste")
    countries.Add("TG|Togo")
    countries.Add("TO|Tonga")
    countries.Add("TT|Trinidad and Tobago")
    countries.Add("TN|Tunisia")
    countries.Add("TR|Turkey")
    countries.Add("TM|Turkmenistan")
    countries.Add("TV|Tuvalu")
    countries.Add("UG|Uganda")
    countries.Add("UA|Ukraine")
    countries.Add("AE|United Arab Emirates")
    countries.Add("GB|United Kingdom")
    countries.Add("US|United States")
    countries.Add("UY|Uruguay")
    countries.Add("UZ|Uzbekistan")
    countries.Add("VU|Vanuatu")
    countries.Add("VA|Vatican City")
    countries.Add("VE|Venezuela")
    countries.Add("VN|Vietnam")
    countries.Add("YE|Yemen")
    countries.Add("ZM|Zambia")
    countries.Add("ZW|Zimbabwe")
    For Each entry As String In countries
        Dim parts() As String = Regex.Split("\|", entry)
        AddItem(parts(0), parts(1))
    Next
End Sub


''' <summary>
''' Returns the underlying value list (parallel to Items display text).
''' When setItems is used, values = display text. Use AddItem/AddItemsMap for distinct values.
''' </summary>
Public Sub getItemValues As List
    Return mItemValues
End Sub

''' <summary>
''' Returns the underlying value key of the currently selected item, or empty string if none.
''' Same as getSelectedValue - included for semantic clarity when using value/text pairs.
''' </summary>
Public Sub getSelectedKey As String
    Return getSelectedValue
End Sub



''' <summary>
''' Convenience alias for getSelectedValue - returns the key of the currently selected item.
''' </summary>
Public Sub getValue As String
    Return getSelectedValue
End Sub

''' <summary>
''' Selects the item matching the given value key/string.
''' </summary>
Public Sub setValue(sValue As String)
    If mItemValues.IsInitialized = False Then Return
    For i = 0 To mItemValues.Size - 1
        Dim item As Object = mItemValues.Get(i)
        Dim itemStr As String = ""
        If item <> Null Then itemStr = "" & item
        If itemStr = sValue Then
            setSelectedIndex(i)
            Return
        End If
    Next
End Sub

''' <summary>
''' Clears all items and resets selection.
''' </summary>
Public Sub Clear
    mItems.Initialize
    mItemValues.Initialize
    miSelectedIndex = -1
    If mbDropdownOpen Then Close
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Opens the dropdown popup.
''' </summary>
Public Sub Open
    If mbEnabled = False Then Return
    If mbVisible = False Then Return
    If mItems.IsInitialized = False Then Return
    If mItems.Size = 0 Then Return
    If mbDropdownOpen Then Return
    mbDropdownOpen = True
    mbFocused = True
    ReceiveFocus
    Refresh
    ShowDropdown
End Sub

''' <summary>
''' Closes the dropdown popup.
''' </summary>
Public Sub Close
    If mbDropdownOpen = False Then Return
    mbDropdownOpen = False
    mbFocused = False
    HideDropdown
    Blur
    Refresh
End Sub

' Closes the dropdown popup automatically when the trigger view is detached
' from the window (e.g. the user navigates to another page while the dropdown
' is open). The popup overlay is hosted on an outer ancestor that outlives the
' page, so without this hook the dropdown would remain on screen after navigation.
Private Sub RegisterDetachListener
    #If B4A
    Try
        Dim joBase As JavaObject = mBase
        Dim listener As Object = joBase.CreateEvent("android.view.View$OnAttachStateChangeListener", "AttachState", False)
        joBase.RunMethod("addOnAttachStateChangeListener", Array(listener))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.RegisterDetachListener: " & LastException.Message)
    End Try
    #End If
End Sub

#If B4A
Private Sub AttachState_Event(sMethodName As String, oArgs() As Object) As Object
    If sMethodName = "onViewDetachedFromWindow" Then
        If mbDropdownOpen Then Close
    End If
    Return Null
End Sub
#End If

''' <summary>
''' Toggles the dropdown popup open/closed.
''' </summary>
Public Sub Toggle
    If mbDropdownOpen Then Close Else Open
End Sub

''' <summary>
''' Returns True if the dropdown is currently open.
''' </summary>
Public Sub getIsOpen As Boolean
    Return mbDropdownOpen
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

''' <summary>
''' Disconnects event callbacks and nulls internal view references to allow
''' garbage collection. Call this when the component is no longer needed.
''' After calling Release, the component is no longer usable.
''' </summary>
Public Sub Release
    Close
    EnableParentScrolls
    ' Disconnect event listeners on Android to prevent zombie callbacks
    #If B4A
        If pnlSurface.IsInitialized Then
            Try
                Dim joSurf As JavaObject = pnlSurface
                joSurf.RunMethod("setClickable", Array(False))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.Release: " & LastException.Message)
                ' View may already be detached
            End Try
        End If
        If pnlOverlay.IsInitialized Then
            Try
                Dim joOv As JavaObject = pnlOverlay
                joOv.RunMethod("setClickable", Array(False))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.Release: " & LastException.Message)
                ' View may already be detached
            End Try
        End If
    #End If
    ' Remove overlay views if they exist
    If pnlOverlay.IsInitialized Then
        If pnlOverlay.Parent.IsInitialized Then
            pnlOverlay.RemoveViewFromParent
        End If
    End If
    If pnlDropdown.IsInitialized Then
        If pnlDropdown.Parent.IsInitialized Then
            If svOptions.IsInitialized Then
                Try
                    Dim svPanel As B4XView = svOptions.Panel
                    For i = svPanel.NumberOfViews - 1 To 0 Step -1
                        svPanel.GetView(i).RemoveViewFromParent
                    Next
                Catch
                    If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.Release: " & LastException.Message)
                    ' ScrollView panel may already be detached
                End Try
            End If
            pnlDropdown.RemoveViewFromParent
        End If
    End If
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
    ' Null references to break reference chains
    pnlSurface = Null
    lblValue = Null
    pnlChevron = Null
    cvsChevron = Null
    pnlLabelAbove = Null
    lblLabelAbove = Null
    pnlHintText = Null
    lblHintText = Null
    pnlOverlay = Null
    pnlDropdown = Null
    svOptions = Null
    pnlOptionsInner = Null
    mOptionPanels = Null
    mOptionLabels = Null
    mCallBack = Null
End Sub

Public Sub setFocus(bValue As Boolean)
    If pnlSurface.IsInitialized = False Then Return
    #If B4A
        Dim jo As JavaObject = pnlSurface
        If bValue Then jo.RunMethod("requestFocus", Null) Else jo.RunMethod("clearFocus", Null)
    #End If
End Sub

''' <summary>
''' Called when the select receives focus. Clears any transient
''' validation error visual so the user can interact without a distracting red border.
''' </summary>
Public Sub ReceiveFocus
    mbFocused = True
    If msErrorText.Length > 0 And mbProgrammaticError = False Then
        msErrorText = ""
    End If
    If mBase.IsInitialized Then Refresh
End Sub

''' <summary>
''' Called when the component loses focus.
''' </summary>
Public Sub Blur
    mbFocused = False
    If mBase.IsInitialized Then Refresh
End Sub

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

Public Sub GetComputedHeight As Int
    Dim triggerH As Int = ResolveHeightDip
    Dim gap As Int = 4dip
    Dim w As Int = 200dip
    If mBase.IsInitialized And mBase.Width > 0 Then w = mBase.Width
    Dim labelAboveH As Int = 0
    If msLabelAbove.Length > 0 Then
        Dim aboveTextSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-sm")
        Dim measuredLabelH As Int = B4XDaisyVariants.MeasureTextHeightSafe(msLabelAbove, aboveTextSize, Typeface.DEFAULT, w - 4dip, 4dip)
        labelAboveH = measuredLabelH + 4dip
    End If
    Dim displayedHint As String = msHintText
    If msErrorText.Length > 0 Then displayedHint = msErrorText
    Dim rawHintH As Int = 0
    If displayedHint.Length > 0 Then
        Dim hintTxtSize As Float = B4XDaisyVariants.ResolveTextSizeDip("text-xs")
        rawHintH = B4XDaisyVariants.MeasureTextHeightSafe(displayedHint, hintTxtSize, Typeface.DEFAULT, w - 4dip, 4dip)
    End If
    Dim totalH As Int = labelAboveH + triggerH
    If rawHintH > 0 Then totalH = totalH + gap + rawHintH
    If mBase.IsInitialized And mBase.Height > 0 Then Return mBase.Height
    Return totalH
End Sub
#End Region

#Region Dropdown Popup

Private Sub ShowDropdown
    If mBase.IsInitialized = False Then Return
    If mItems.IsInitialized = False Then Return
    If mItems.Size = 0 Then Return

    ' DisableParentScrolls    ' ? REMOVED: no longer needed; popup is now hosted on page Root
    EnsureOverlayHost
    BuildDropdown
    PositionDropdown
    ShowDropdownLayers
End Sub

Private Sub HideDropdown
    ' EnableParentScrolls     ' ? REMOVED: paired with the line above
    If pnlOverlay.IsInitialized Then
        #If B4A
            Try
                Dim joOv As JavaObject = pnlOverlay
                joOv.RunMethod("setClickable", Array(False))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.HideDropdown: " & LastException.Message)
            End Try
        #End If
        If pnlOverlay.Parent.IsInitialized Then pnlOverlay.RemoveViewFromParent
        pnlOverlay.Visible = False
    End If
    If pnlDropdown.IsInitialized Then
        If svOptions.IsInitialized Then
            Try
                Dim svPanel As B4XView = svOptions.Panel
                For i = svPanel.NumberOfViews - 1 To 0 Step -1
                    svPanel.GetView(i).RemoveViewFromParent
                Next
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.HideDropdown: " & LastException.Message)
            End Try
        End If
        If pnlDropdown.Parent.IsInitialized Then pnlDropdown.RemoveViewFromParent
        pnlDropdown.Visible = False
    End If
End Sub


Private Sub EnsureOverlayHost
    Dim host As B4XView = ResolveOverlayHost
    If host.IsInitialized = False Then Return

    If pnlOverlay.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("ddoverlay")
        pnlOverlay = p
        pnlOverlay.Color = xui.Color_Transparent
    End If

    If pnlDropdown.IsInitialized = False Then
        Dim pp As Panel
        pp.Initialize("ddpanel")
        pnlDropdown = pp
        pnlDropdown.Color = xui.Color_Transparent
    End If

    ' Re-parent overlay if host changed
    If pnlOverlay.Parent.IsInitialized Then
        If IsSameView(pnlOverlay.Parent, host) = False Then
            Try
                pnlOverlay.RemoveViewFromParent
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.EnsureOverlayHost: " & LastException.Message)
            End Try
        End If
    End If
    ' Re-parent dropdown if host changed
    If pnlDropdown.Parent.IsInitialized Then
        If IsSameView(pnlDropdown.Parent, host) = False Then
            Try
                pnlDropdown.RemoveViewFromParent
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.EnsureOverlayHost: " & LastException.Message)
            End Try
        End If
    End If

    ' Add overlay to host (full-screen dismiss area)
    If pnlOverlay.Parent.IsInitialized = False Then
        Try
            host.AddView(pnlOverlay, 0, 0, host.Width, host.Height)
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.EnsureOverlayHost: " & LastException.Message)
            ' Host may not be ready
        End Try
    Else
        pnlOverlay.SetLayoutAnimated(0, 0, 0, host.Width, host.Height)
    End If

    ' Add dropdown panel to host if not already added
    If pnlDropdown.Parent.IsInitialized = False Then
        Try
            host.AddView(pnlDropdown, 0, 0, 0, 0) ' will be positioned by PositionDropdown
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.EnsureOverlayHost: " & LastException.Message)
            ' Host may not be ready
        End Try
    End If



    B4XDaisyVariants.DisableClippingRecursive(host)
    B4XDaisyVariants.DisableClippingRecursive(mBase)
End Sub

Private Sub BuildDropdown
    If mItems.IsInitialized = False Then Return
    If mItems.Size = 0 Then Return

    Dim host As B4XView = ResolveOverlayHost
    If host.IsInitialized = False Then Return

    Dim optionHeight As Int = ResolveHeightDip
    Dim extraRows As Int = 0
    If msPlaceholder.Length > 0 Then extraRows = 1
    Dim maxDropdownH As Int = optionHeight * Min(mItems.Size + extraRows, miMaxDropdownRows)
    Dim dropdownW As Int = mBase.Width
    If dropdownW <= 0 Then dropdownW = 200dip
    Dim totalContentH As Int = optionHeight * (mItems.Size + extraRows)

    ' Remove previous dropdown content
    If pnlDropdown.IsInitialized Then
        Dim oldCount As Int = pnlDropdown.NumberOfViews
        For c = oldCount - 1 To 0 Step -1
            Dim oldView As B4XView = pnlDropdown.GetView(c)
            #If B4A
                Try
                    Dim oldSv As ScrollView = oldView
                    Dim svPanel As B4XView = oldSv.Panel
                    For si = svPanel.NumberOfViews - 1 To 0 Step -1
                        svPanel.GetView(si).RemoveViewFromParent
                    Next
                Catch
                    If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.BuildDropdown: " & LastException.Message)
                    ' Not a ScrollView, skip panel cleanup
                End Try
            #End If
            oldView.RemoveViewFromParent
        Next
    End If

    ' Create ScrollView for options
    Dim sv As ScrollView
    sv.Initialize(maxDropdownH)
    svOptions = sv
    #If B4A
    If svOptions.IsInitialized Then
        Try
            Dim joSV As JavaObject = svOptions
            joSV.RunMethod("setOnTouchListener", Array(joSV.CreateEvent("android.view.View$OnTouchListener", "svOptionsTouch", False)))
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.BuildDropdown: " & LastException.Message)
        End Try
    End If
    #End If
    svOptions.Panel.Color = xui.Color_Transparent

    pnlOptionsInner = svOptions.Panel
    pnlOptionsInner.Color = xui.Color_Transparent
    pnlOptionsInner.Height = totalContentH

    ' Clear previous option tracking lists
    mOptionPanels.Initialize
    mOptionLabels.Initialize

    Dim base100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", 0xFFFFFFFF)
    Dim base200 As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", 0xFFE5E7EB)
    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF333333)
    Dim variantColor As Int = ResolveInputColor
    Dim padX As Int = ResolveOptionPaddingXDip
    Dim padY As Int = ResolveOptionPaddingYDip
    Dim textSize As Float = ResolveTextSize

    ' Calculate inner inset so option highlights don't bleed over rounded border
    Dim radiusDip As Int = ResolveRadiusDip
    Dim borderDip As Int = Max(1dip, B4XDaisyVariants.GetBorderDip(1dip))
    miDropdownInset = borderDip + 2dip
    Dim scrollW As Int = dropdownW - miDropdownInset * 2

    ' -- Placeholder row (disabled, non-selectable guide) --
    ' When msPlaceholder is non-empty it doubles as a disabled guide row at the top
    ' of the dropdown - mirrors HTML: <option value="" selected disabled>Pick an option</option>
    ' The row is styled with placeholderColor and NOT added to mOptionPanels,
    ' so ddopt_Click will never match it and no selection is triggered.
    If msPlaceholder.Length > 0 Then
        Dim pnlPh As Panel
        pnlPh.Initialize("ddopt")
        Dim phPanel As B4XView = pnlPh
        phPanel.Color = xui.Color_Transparent
        Dim lblPh As Label
        lblPh.Initialize("")
        Dim phLabel As B4XView = lblPh
        phLabel.Color = xui.Color_Transparent
        phLabel.SetTextAlignment("CENTER", "LEFT")
        phLabel.Text = msPlaceholder
        phLabel.TextSize = textSize
        Dim phColor As Int = B4XDaisyVariants.Blend(baseContent, 0xFFFFFFFF, 0.5)
        phLabel.TextColor = phColor
        #If B4A
            Dim joPhL As JavaObject = phLabel
            joPhL.RunMethod("setSingleLine", Array(True))
            joPhL.RunMethod("setIncludeFontPadding", Array(False))
            joPhL.RunMethod("setClickable", Array(False))
            ' Italic typeface: visually signals "hint" without any structural divider
            joPhL.RunMethod("setTypeface", Array(Typeface.DEFAULT, 2))  ' 2 = Typeface.ITALIC
        #End If
        phPanel.AddView(phLabel, padX, padY, scrollW - padX * 2, optionHeight - padY * 2)
        pnlOptionsInner.AddView(phPanel, 0, 0, scrollW, optionHeight)
        ' NOTE: phPanel intentionally NOT added to mOptionPanels - ddopt_Click ignores it
    End If

    For i = 0 To mItems.Size - 1
        Dim optText As String = mItems.Get(i)
        If optText = Null Then optText = ""

        Dim pnlOpt As Panel
        pnlOpt.Initialize("ddopt")
        Dim optPanel As B4XView = pnlOpt
        optPanel.Color = xui.Color_Transparent

        ' -- Option label --
        Dim lblOpt As Label
        lblOpt.Initialize("")
        Dim optLabel As B4XView = lblOpt
        optLabel.Color = xui.Color_Transparent
        optLabel.SetTextAlignment("CENTER", "LEFT")
        optLabel.Text = optText
        optLabel.TextSize = textSize

        #If B4A
            Dim joOpt As JavaObject = optLabel
            joOpt.RunMethod("setSingleLine", Array(True))
            joOpt.RunMethod("setIncludeFontPadding", Array(False))
            joOpt.RunMethod("setClickable", Array(False)) ' Pass clicks through to parent option panel
            
            Dim joOptPanel As JavaObject = optPanel
            joOptPanel.RunMethod("setOnTouchListener", Array(joOptPanel.CreateEvent("android.view.View$OnTouchListener", "ddoptTouch", False)))
        #End If

        ' -- Highlight selected option --
        Dim isSelected As Boolean = (i = miSelectedIndex)
        ' ActiveColor overrides the selected item's background + content color.
        ' When "none", fall back to the select Variant; when that is also none, base200.
        Dim activeVariant As String = msActiveColor
        If activeVariant = "none" Or activeVariant = "" Then activeVariant = msVariant
        Dim hasActive As Boolean = (activeVariant <> "none" And activeVariant <> "")

        If isSelected Then
            If hasActive Then
                Dim activeHue As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(activeVariant, variantColor)
                optPanel.Color = B4XDaisyVariants.Blend(activeHue, base100, 0.15)
                optLabel.TextColor = B4XDaisyVariants.ResolveTextColorVariant(activeVariant, baseContent)
            Else
                optPanel.Color = base200
                optLabel.TextColor = baseContent
            End If
            ' Apply rounded corners to selected highlight
            Dim highlightRadius As Int = 6dip
            B4XDaisyVariants.ApplyEditTextBorder(optPanel, optPanel.Color, 0, optPanel.Color, highlightRadius)
        Else
            optPanel.Color = xui.Color_Transparent
            optLabel.TextColor = baseContent
        End If

        ' Layout: label spans full width (no checkmark), uses scrollW for inset
        optPanel.AddView(optLabel, padX, padY, scrollW - padX * 2, optionHeight - padY * 2)

        pnlOptionsInner.AddView(optPanel, 0, (i + extraRows) * optionHeight, scrollW, optionHeight)

        mOptionPanels.Add(optPanel)
        mOptionLabels.Add(optLabel)
    Next

    ' Add ScrollView to dropdown panel - inset by miDropdownInset so option highlights
    ' don't bleed over the dropdown's rounded border edges.
    pnlDropdown.AddView(svOptions, miDropdownInset, miDropdownInset, scrollW, maxDropdownH)
    Dim inputColor As Int = ResolveInputColor
    Dim bgColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", 0xFFFFFFFF)
    If mcBackgroundColor <> 0 Then bgColor = mcBackgroundColor

    B4XDaisyVariants.ApplyEditTextBorder(pnlDropdown, bgColor, borderDip, inputColor, radiusDip)
    B4XDaisyVariants.ApplyElevation(pnlDropdown, "md")

    ' ScrollPosition is NOT set here - it is deferred to ShowDropdownLayers via
    ' View.post() so it runs after the ScrollView has been laid out. Setting it
    ' here gets reset to 0 by Android's layout pass.
End Sub

Private Sub ApplyDeferredScroll
    If svOptions.IsInitialized = False Then Return
    If miSelectedIndex < 0 Then Return
    Dim extraRows As Int = 0
    If msPlaceholder.Length > 0 Then extraRows = 1
    Dim optionHeight As Int = ResolveHeightDip
    Dim targetY As Int = (miSelectedIndex + extraRows) * optionHeight
    svOptions.ScrollPosition = targetY
End Sub

Private Sub PositionDropdown
    If mBase.IsInitialized = False Then Return
    If pnlDropdown.IsInitialized = False Then Return
    If pnlOverlay.IsInitialized = False Then Return

    Dim host As B4XView = ResolveOverlayHost
    If host.IsInitialized = False Then Return

    ' -- Use screen coordinates for positioning with fallback --
    Dim triggerLeft As Int = 0
    Dim triggerTop As Int = 0
    Dim triggerW As Int = GetSafeWidth(pnlSurface)
    Dim triggerH As Int = GetSafeHeight(pnlSurface)

    ' Try screen coordinates first (handles scroll), fallback to layout coordinates
    Dim usedScreenCoords As Boolean = False
    #If B4A
        If pnlSurface.IsInitialized And host.IsInitialized Then
            Try
                Dim joSurf As JavaObject = pnlSurface
                Dim surfLoc() As Int = joSurf.RunMethod("getLocationOnScreen", Null)
                Dim joHost As JavaObject = host
                Dim hostLoc() As Int = joHost.RunMethod("getLocationOnScreen", Null)
                triggerLeft = surfLoc(0) - hostLoc(0)
                triggerTop = surfLoc(1) - hostLoc(1)
                usedScreenCoords = True
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.PositionDropdown: " & LastException.Message)
                ' Fall back to layout coordinates
            End Try
        End If
    #End If

    If usedScreenCoords = False Then
        Dim surfaceRect As Map = GetViewRectRelativeToAncestor(pnlSurface, host)
        triggerLeft = surfaceRect.Get("left")
        triggerTop = surfaceRect.Get("top")
    End If

    Dim dropdownH As Int = pnlDropdown.Height
    If dropdownH <= 0 Then dropdownH = ResolveHeightDip * Min(mItems.Size, miMaxDropdownRows) + miDropdownInset * 2
    Dim dropdownW As Int = pnlDropdown.Width
    If dropdownW <= 0 Then dropdownW = triggerW

    Dim hostW As Int = GetSafeWidth(host)
    Dim hostH As Int = GetSafeHeight(host)
    If dropdownW > hostW - 8dip Then
        dropdownW = hostW - 8dip
    End If

    Dim dropLeft As Int = triggerLeft
    ' Default: dropdown below trigger (2dip gap)
    Dim dropTop As Int = triggerTop + triggerH + 2dip

    If dropLeft + dropdownW > hostW Then
        dropLeft = hostW - dropdownW - 4dip
    End If
    If dropLeft < 4dip Then dropLeft = 4dip
    ' If dropdown overflows below host, flip above trigger (2dip gap)
    If dropTop + dropdownH > hostH Then
        dropTop = triggerTop - dropdownH - 2dip
        If dropTop < 4dip Then
            dropTop = 4dip
        End If
    End If

    pnlDropdown.SetLayoutAnimated(0, dropLeft, dropTop, dropdownW, dropdownH)
End Sub

Private Sub ShowDropdownLayers
    ' Z-order: overlay (bottom) ? dropdown (middle) ? trigger (top for visual only)
    ' The overlay captures dismiss clicks, the dropdown shows options above it,
    ' and the trigger stays visible at the top so the user sees what they selected.
    If pnlOverlay.IsInitialized Then
        pnlOverlay.Visible = True
        pnlOverlay.BringToFront
        #If B4A
            ' Ensure the overlay panel receives touch events on all Android versions
            Try
                Dim joOverlay As JavaObject = pnlOverlay
                joOverlay.RunMethod("setClickable", Array(True))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.ShowDropdownLayers: " & LastException.Message)
                ' View may not be attached yet
            End Try
        #End If
    End If
    If pnlDropdown.IsInitialized Then
        pnlDropdown.Visible = True
        pnlDropdown.BringToFront
        B4XDaisyVariants.DisableClippingRecursive(pnlDropdown)
        #If B4A
            ' Ensure the dropdown panel doesn't intercept scroll events meant for
            ' the inner ScrollView - pass touches through to the ScrollView.
            Try
                Dim joDD As JavaObject = pnlDropdown
                joDD.RunMethod("setClickable", Array(False))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.ShowDropdownLayers: " & LastException.Message)
            End Try
        #End If
    End If
    ' Bring trigger to front so it stays visually above overlay but below dropdown
    ' is NOT possible on a single z-plane - instead, keep trigger visible
    ' by ensuring the dropdown is positioned below the trigger area.
    ' Do NOT call mBase.BringToFront here - it would push trigger above dropdown.

    ' Defer scroll-to-selected until after layout pass so the ScrollPosition sticks
    #If B4A
    If pnlDropdown.IsInitialized Then
        Try
            Dim joPost As JavaObject = pnlDropdown
            Dim runnable As Object = joPost.CreateEvent("java.lang.Runnable", "DeferredScroll", False)
            joPost.RunMethod("post", Array(runnable))
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.ShowDropdownLayers post: " & LastException.Message)
        End Try
    End If
    #End If
End Sub

' -----------------------------------------------------------------------
' FIX: Walk to the TOPMOST sized ancestor instead of stopping at the first
' one. Stopping at the first sized parent puts the popup inside the page's
' outer ScrollView (svHost.Panel), which then steals/cancels vertical drags
' on the dropdown's own ScrollView and makes long lists non-scrollable.
' Returning the outermost ancestor (typically the page Root) hosts the
' popup ABOVE the page ScrollView, so its inner list scrolls cleanly.
' -----------------------------------------------------------------------
Private Sub ResolveOverlayHost As B4XView
    Dim empty As B4XView
    If mBase.IsInitialized = False Then Return empty
    Dim current As B4XView = mBase
    Dim bestHost As B4XView = empty
    Do While current.IsInitialized
        Dim w As Int = GetSafeWidth(current)
        Dim h As Int = GetSafeHeight(current)
        If w > 0 And h > 0 Then
            #If B4A
            Try
                Dim className As String = GetType(current)
                If className.Contains("BALayout") Or className.Contains("Panel") Then
                    bestHost = current
                End If
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.B4XView: " & LastException.Message)
                ' Ignore reflection failures
            End Try
            #Else
            bestHost = current
            #End If
        End If
        Try
            If current.Parent.IsInitialized = False Then Exit
            current = current.Parent
        Catch
            Exit
        End Try
    Loop
    Return bestHost
End Sub



Private Sub DisableParentScrolls
    #If B4A
    If mParentScrollViews.IsInitialized = False Then mParentScrollViews.Initialize
    mParentScrollViews.Clear
    Dim current As B4XView = mBase
    Do While current.IsInitialized
        Dim parentView As B4XView
        Try
            If current.Parent.IsInitialized = False Then Exit
            parentView = current.Parent
        Catch
            Exit
        End Try
        
        Dim joParent As JavaObject = parentView
        Dim className As String = ""
        Try
            className = GetType(parentView)
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.DisableParentScrolls: " & LastException.Message)
        End Try
        
        If className.Contains("ScrollView") Then
            mParentScrollViews.Add(joParent)
            Try
                Dim listener As Object = joParent.CreateEvent("android.view.View$OnTouchListener", "BlockScroll", True)
                joParent.RunMethod("setOnTouchListener", Array(listener))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.DisableParentScrolls: " & LastException.Message)
            End Try
        End If
        
        If className.Contains("ViewRootImpl") Then Exit
        current = parentView
    Loop
    #End If
End Sub

Private Sub EnableParentScrolls
    #If B4A
    If mParentScrollViews.IsInitialized Then
        For Each joParent As JavaObject In mParentScrollViews
            Try
                joParent.RunMethod("setOnTouchListener", Array(Null))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.EnableParentScrolls: " & LastException.Message)
            End Try
        Next
        mParentScrollViews.Clear
    End If
    #End If
End Sub

Private Sub BlockScroll_Event(sMethodName As String, oArgs() As Object) As Object
    Return True
End Sub

Private Sub GetViewRectRelativeToAncestor(vTarget As B4XView, vAncestor As B4XView) As Map
    If vTarget.IsInitialized = False Then Return CreateMap("left": 0, "top": 0, "width": 0, "height": 0)
    Dim left As Int = 0
    Dim top As Int = 0
    Dim current As B4XView = vTarget
    Do While current.IsInitialized
        If IsSameView(current, vAncestor) Then Exit
        left = left + GetSafeLeft(current)
        top = top + GetSafeTop(current)
        If current.Parent.IsInitialized = False Then Exit
        current = current.Parent
    Loop
    Return CreateMap("left": left, "top": top, "width": GetSafeWidth(vTarget), "height": GetSafeHeight(vTarget))
End Sub

Private Sub IsSameView(vView1 As B4XView, vView2 As B4XView) As Boolean
    If vView1.IsInitialized = False Or vView2.IsInitialized = False Then Return vView1.IsInitialized = vView2.IsInitialized
    #If B4A
        Try
            Dim jo1 As JavaObject = vView1
            Dim jo2 As JavaObject = vView2
            Return jo1.RunMethod("equals", Array(jo2))
        Catch
            ' Fallback to reference comparison
            Return vView1 = vView2
        End Try
    #Else
        Return vView1 = vView2
    #End If
End Sub

Private Sub GetSafeLeft(vView As B4XView) As Int
    #If B4A
        Try
            Return vView.Left
        Catch
            Dim jo As JavaObject = vView
            Return jo.RunMethod("getLeft", Null)
        End Try
    #Else
        Return vView.Left
    #End If
End Sub

Private Sub GetSafeTop(vView As B4XView) As Int
    #If B4A
        Try
            Return vView.Top
        Catch
            Dim jo As JavaObject = vView
            Return jo.RunMethod("getTop", Null)
        End Try
    #Else
        Return vView.Top
    #End If
End Sub

Private Sub GetSafeWidth(vView As B4XView) As Int
    #If B4A
        Try
            Dim w As Int = vView.Width
            If w > 0 Then Return w
            Dim jo As JavaObject = vView
            Return jo.RunMethod("getWidth", Null)
        Catch
            Try
                Dim jo As JavaObject = vView
                Return jo.RunMethod("getWidth", Null)
            Catch
                Return 0
            End Try
        End Try
    #Else
        Return vView.Width
    #End If
End Sub

Private Sub GetSafeHeight(vView As B4XView) As Int
    #If B4A
        Try
            Dim h As Int = vView.Height
            If h > 0 Then Return h
            Dim jo As JavaObject = vView
            Return jo.RunMethod("getHeight", Null)
        Catch
            Try
                Dim jo As JavaObject = vView
                Return jo.RunMethod("getHeight", Null)
            Catch
                Return 0
            End Try
        End Try
    #Else
        Return vView.Height
    #End If
End Sub
#End Region

#Region Events

''' <summary>
''' Handles clicks on the pnlSurface trigger - fires Click event then toggles dropdown.
''' </summary>
Private Sub pnlsel_Click
    If mbEnabled = False Then Return
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
    Toggle
End Sub

Private Sub ddoverlay_Click
    Close
End Sub

#If B4A
' Touch event for dropdown panel - prevents parent ScrollView from intercepting scroll
Private Sub ddpanel_Touch(iAction As Int, fX As Float, fY As Float) As Boolean
    If mbDropdownOpen = False Then Return False
    Dim joDD As JavaObject = pnlDropdown
    Dim par As JavaObject = joDD.RunMethod("getParent", Null)
    If par.IsInitialized Then
        If iAction = 0 Or iAction = 2 Then
            Try
                par.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.ddpanel_Touch: " & LastException.Message)
            End Try
        End If
    End If
    Return False ' let the inner ScrollView handle the scroll
End Sub

' Touch event proxy for option panels - prevents parent ScrollView from intercepting scroll
Private Sub ddoptTouch_Event(sMethodName As String, oArgs() As Object) As Object
    If sMethodName = "onTouch" Then
        If mbDropdownOpen = False Then Return False
        #If B4A
        Dim motionEvent As JavaObject = oArgs(1)
        Dim Action As Int = motionEvent.RunMethod("getAction", Null)
        Dim clickedPanel As JavaObject = oArgs(0)
        If clickedPanel.IsInitialized Then
            Dim current As JavaObject = clickedPanel
            Do While current.IsInitialized
                Dim parentView As JavaObject
                Try
                    parentView = current.RunMethod("getParent", Null)
                Catch
                    Exit
                End Try
                If parentView.IsInitialized = False Then Exit
                
                ' Only disallow intercept on ancestors OUTSIDE our dropdown popover
                Dim isInternal As Boolean = False
                If svOptions.IsInitialized And IsSameView(parentView, svOptions) Then isInternal = True
                If pnlOptionsInner.IsInitialized And IsSameView(parentView, pnlOptionsInner) Then isInternal = True
                If pnlDropdown.IsInitialized And IsSameView(parentView, pnlDropdown) Then isInternal = True
                
                If isInternal = False Then
                    If Action = 0 Or Action = 2 Then
                        Try
                            parentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
                        Catch
                            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.ddoptTouch_Event: " & LastException.Message)
                        End Try
                    End If
                End If
                
                Try
                    Dim parentClass As String = GetType(parentView)
                    If parentClass.Contains("ViewRootImpl") Then Exit
                Catch
                    Exit
                End Try
                current = parentView
            Loop
        End If
        #End If
    End If
    Return False ' MUST return False so ddopt_Click still triggers on ACTION_UP
End Sub

' Touch event proxy for options scrollview - prevents parent ScrollView from intercepting scroll
Private Sub svOptionsTouch_Event(sMethodName As String, oArgs() As Object) As Object
    If sMethodName = "onTouch" Then
        If mbDropdownOpen = False Then Return False
        #If B4A
        Dim motionEvent As JavaObject = oArgs(1)
        Dim Action As Int = motionEvent.RunMethod("getAction", Null)
        Dim clickedView As JavaObject = oArgs(0)
        If clickedView.IsInitialized Then
            Dim current As JavaObject = clickedView
            Do While current.IsInitialized
                Dim parentView As JavaObject
                Try
                    parentView = current.RunMethod("getParent", Null)
                Catch
                    Exit
                End Try
                If parentView.IsInitialized = False Then Exit
                
                ' Only disallow intercept on ancestors OUTSIDE our dropdown popover
                Dim isInternal As Boolean = False
                If svOptions.IsInitialized And IsSameView(parentView, svOptions) Then isInternal = True
                If pnlOptionsInner.IsInitialized And IsSameView(parentView, pnlOptionsInner) Then isInternal = True
                If pnlDropdown.IsInitialized And IsSameView(parentView, pnlDropdown) Then isInternal = True
                
                If isInternal = False Then
                    If Action = 0 Or Action = 2 Then
                        Try
                            parentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
                        Catch
                            If B4XDaisyApp.DebugLogs Then Log("B4XDaisySelect.svOptionsTouch_Event: " & LastException.Message)
                        End Try
                    End If
                End If
                
                Try
                    Dim parentClass As String = GetType(parentView)
                    If parentClass.Contains("ViewRootImpl") Then Exit
                Catch
                    Exit
                End Try
                current = parentView
            Loop
        End If
        #End If
    End If
    Return False ' let the ScrollView handle the scroll
End Sub
#End If

Private Sub ddopt_Click
    Dim src As Object = Sender
    If src = Null Then Return
    Dim clickedPanel As B4XView = src
    If mOptionPanels.IsInitialized = False Then Return

    For i = 0 To mOptionPanels.Size - 1
        Dim optPanel As B4XView = mOptionPanels.Get(i)
        If IsSameView(optPanel, clickedPanel) Then
            Dim oldIndex As Int = miSelectedIndex
            miSelectedIndex = i
            Close
            Refresh
            If oldIndex <> i Then
                FireChanged(i)
            End If
            Return
        End If
    Next
End Sub

Private Sub DeferredScroll_Event(sMethodName As String, oArgs() As Object) As Object
    ApplyDeferredScroll
    Return Null
End Sub

Private Sub FireChanged(iIndex As Int)
    If mCallBack = Null Then Return
    Dim keyStr As String = ""
    Dim valStr As String = ""
    If iIndex >= 0 Then
        If mItemValues.IsInitialized And iIndex < mItemValues.Size Then
            Dim rawKey As Object = mItemValues.Get(iIndex)
            If rawKey <> Null Then keyStr = "" & rawKey
        End If
        If mItems.IsInitialized And iIndex < mItems.Size Then
            Dim rawVal As Object = mItems.Get(iIndex)
            If rawVal <> Null Then valStr = "" & rawVal
        End If
    End If
    Dim subName As String = mEventName & "_Changed"
    #If B4A
    If xui.SubExists(mCallBack, subName, 3) Then
        Dim jo As JavaObject = mCallBack
        jo.RunMethod("_" & subName.ToLowerCase, Array(iIndex, keyStr, valStr))
    Else If xui.SubExists(mCallBack, subName, 0) Then
        CallSub(mCallBack, subName)
    End If
    #Else If B4J
    If xui.SubExists(mCallBack, subName, 3) Then
        Dim jo As JavaObject = mCallBack
        jo.RunMethod("_" & subName.ToLowerCase, Array(iIndex, keyStr, valStr))
    Else If xui.SubExists(mCallBack, subName, 0) Then
        CallSub(mCallBack, subName)
    End If
    #Else If B4i
    If xui.SubExists(mCallBack, subName, 3) Then
        Dim no As NativeObject = mCallBack
        no.RunMethod("_" & subName.ToLowerCase & ":::", Array(iIndex, keyStr, valStr))
    Else If xui.SubExists(mCallBack, subName, 0) Then
        CallSub(mCallBack, subName)
    End If
    #End If
End Sub
#End Region

#Region DaisyUI Parity Class Tokens
' - select
' - select-accent
' - select-error
' - select-ghost
' - select-info
' - select-lg
' - select-md
' - select-neutral
' - select-primary
' - select-secondary
' - select-sm
' - select-success
' - select-warning
' - select-xl
' - select-xs
#End Region

#Region B4XView Layout Wrapper Methods
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

#End Region
