B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#End Region

#DesignerProperty: Key: Value, DisplayName: Value, FieldType: Int, DefaultValue: 0, Description: Current numeric value (0-999).
#DesignerProperty: Key: Digits, DisplayName: Digits, FieldType: Int, DefaultValue: 1, Description: Minimum number of digits to display.
#DesignerProperty: Key: Label, DisplayName: Label, FieldType: String, DefaultValue: , Description: Text label for this segment (e.g. days, hours).
#DesignerProperty: Key: LabelPosition, DisplayName: Label Position, FieldType: String, DefaultValue: none, List: none|bottom|right, Description: Where to place the label relative to the number. 'none' hides labels.
#DesignerProperty: Key: TextSize, DisplayName: Font Size, FieldType: String, DefaultValue: md, List: text-xs|text-sm|md|text-base|text-lg|text-xl|text-2xl|text-3xl|text-4xl|text-5xl|text-6xl|text-7xl|text-8xl|text-9xl, Description: Typography size token.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.
#DesignerProperty: Key: Outline, DisplayName: Outline, FieldType: Boolean, DefaultValue: False, Description: If true, the item will have an outline.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 350, Description: Animation duration in milliseconds (0 = instant).

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Internal views
    Private mDigitPanelContainer As Panel
    Private mDigitPanels As List
    Private mDigitLabels As List
    Private lblLabel As Label
    
    ' Local properties
    Private mnValue As Int = 0
    Private mnDigits As Int = 1
    Private msLabel As String = ""
    Private msLabelPosition As String = "none"
    Private msTextSize As String = "md"
    Private msVariant As String = "none"
    Private msRounded As String = "none"
    Private msShadow As String = "none"
    Private msStyle As String = "solid"
    Private mnLineHeight As Float = B4XDaisyVariants.LINE_HEIGHT_DEFAULT
    Private mbOutline As Boolean = False
    
    Private DEBUG_BORDER As Boolean = False
    Private mIsResizing As Boolean = False
    
    ' Per-digit 3D flip animation
    Private mbAnimated As Boolean = True
    Private miDuration As Int = 350
    Private timerAnimate As Timer
    Private mbAnimating As Boolean = False
    Private mnAnimateFrom As Int = 0
    Private mnAnimateTo As Int = 0
    Private mnAnimateStep As Int = 0
    Private mnAnimateTotalSteps As Int = 0
    Private mFlipMidpoint As Int = 0
    Private mFlipOldDigits As String = ""
    Private mFlipNewDigits As String = ""
    Private mDigitWidth As Int = 0
    Private mnRequiredWidth As Int = 0
    Private mnTargetWidth As Int = -1
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Initialize labels
    lblLabel.Initialize("")
    
    mBase.AddView(lblLabel, 0, 0, 0, 0)
    
    ' Digit panel container
    mDigitPanelContainer.Initialize("")
    mBase.AddView(mDigitPanelContainer, 0, 0, 0, 0)
    mDigitPanelContainer.Color = xui.Color_Transparent
    
    ' Initialize per-digit lists
    mDigitPanels.Initialize
    mDigitLabels.Initialize
    
    ApplyDesignerProps(mProps)
    timerAnimate.Initialize("timerAnimate", 30)

    Refresh
End Sub
#End Region

#Region Public API
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    Dim oldWidth As Int = mBase.Width
    
    ' Format value string based on Digits
    Dim sVal As String = mnValue
    If mnDigits = 2 Then
        sVal = NumberFormat(mnValue, 2, 0)
    Else If mnDigits = 3 Then
        sVal = NumberFormat(mnValue, 3, 0)
    End If
    ' Apply styles
    Dim bgColor As Int
    Dim borderColor As Int
    Dim borderWidth As Int
    If mbOutline Then
        bgColor = xui.Color_Transparent
        borderWidth = 1dip
        If msVariant = "none" Or msVariant = "" Then
            borderColor = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_LightGray)
        Else
            borderColor = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_LightGray))
        End If
    Else
        bgColor = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, xui.Color_Transparent)
        borderWidth = 0
        borderColor = xui.Color_Transparent
    End If
    
    mBase.Color = bgColor
    Dim textColor As Int = GetTextColor
    ' radius & elevation
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    B4XDaisyVariants.ApplyElevation(mBase, msShadow)
    mBase.SetColorAndBorder(bgColor, borderWidth, borderColor, radius)
    ' Set text size (tailwind tokens) using shared variant utility
    Dim fontSize As Float = B4XDaisyVariants.ResolveTextSizeDip(msTextSize)
    If fontSize <= 0 Then fontSize = 16dip
    ' Resolve line-height from global variants (matching web behavior)
    Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(msTextSize, fontSize, fontSize * 1.5)
    mnLineHeight = tm.GetDefault("line_height_dip", B4XDaisyVariants.LINE_HEIGHT_DEFAULT)
        
    BuildDigitPanels(sVal, textColor, fontSize)
    
    If msLabel.trim <> "" And msLabelPosition <> "none" Then
        lblLabel.Text = msLabel
        lblLabel.visible = True
        lblLabel.TextColor = textColor
        lblLabel.TextSize = fontSize * 0.7 
        B4XDaisyVariants.SetLineSpacing(lblLabel, mnLineHeight, 0)
    Else
        lblLabel.visible = False    
    End If

    Dim measureVal As Int = mDigitPanels.Size * mDigitWidth
    Dim measureLab As Int = 0
    If lblLabel.Visible Then measureLab = MeasureTextWidth(msLabel, lblLabel.TextSize, lblLabel.Typeface)
    
    Dim paddingLR As Int = 2dip
    If msVariant <> "none" And msVariant <> "" Then
        paddingLR = 6dip
    End If
    
    Dim requiredWidth As Int = 0
    If msLabelPosition = "right" Then
        requiredWidth = measureVal + paddingLR * 2 + measureLab + 4dip
    Else If msLabelPosition = "bottom" Then
        Dim contentW As Int = measureVal + paddingLR * 2
        requiredWidth = Max(contentW, measureLab + 4dip)
    Else ' none
        requiredWidth = measureVal + paddingLR * 2
    End If
    
    mnRequiredWidth = Max(requiredWidth, 40dip)
    If mnTargetWidth > 0 Then
        mBase.Width = mnTargetWidth
    Else
        mBase.Width = mnRequiredWidth
    End If
    
    Base_Resize(mBase.Width, mBase.Height)
    
'    If mBase.IsInitialized And mBase.Width <> oldWidth Then
'        If mCallBack <> Null And SubExists(mCallBack, "ItemSizeChanged") Then
'            CallSub(mCallBack, "ItemSizeChanged")
'        End If
'    End If
End Sub

Public Sub getRequiredWidth As Int
    Return mnRequiredWidth
End Sub

Public Sub getTargetWidth As Int
    Return mnTargetWidth
End Sub

Public Sub setTargetWidth(iValue As Int)
    mnTargetWidth = iValue
    If mBase.IsInitialized And mnTargetWidth > 0 Then
        mBase.Width = mnTargetWidth
    End If
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub getIsInitialized As Boolean
    If mBase.IsInitialized = False Then Return False
    Return mDigitPanelContainer.IsInitialized
End Sub

#Region Getters/Setters
Public Sub getValue As Int
    Return mnValue
End Sub

Public Sub setValue(iValue As Int)
    Dim newVal As Int = Max(0, Min(999, iValue))
    If mBase.IsInitialized = False Then
        mnValue = newVal
        Return
    End If
    If mbAnimated And mnValue <> newVal And miDuration > 0 Then
        StartAnimation(mnValue, newVal)
    Else
        mnValue = newVal
        Refresh
    End If
End Sub

Public Sub setAnimated(bValue As Boolean)
    mbAnimated = bValue
End Sub

Public Sub getAnimated As Boolean
    Return mbAnimated
End Sub

Public Sub setDuration(iMilliseconds As Int)
    miDuration = Max(0, iMilliseconds)
End Sub

Public Sub getDuration As Int
    Return miDuration
End Sub



Public Sub getDigits As Int
    Return mnDigits
End Sub

Public Sub setDigits(iValue As Int)
    mnDigits = Max(1, Min(3, iValue))
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabel As String
    Return msLabel
End Sub

Public Sub setLabel(sValue As String)
    msLabel = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelPosition As String
    Return msLabelPosition
End Sub

Public Sub setLabelPosition(sValue As String)
    If sValue = "right" Or sValue = "bottom" Or sValue = "none" Then
        msLabelPosition = sValue
    Else
        msLabelPosition = "none"
    End If
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextSize As String
    Return msTextSize
End Sub

Public Sub setTextSize(sValue As String)
    msTextSize = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub getStyle As String
    Return msStyle
End Sub

Public Sub setStyle(sValue As String)
    msStyle = sValue.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub setVariant(sValue As String)
    msVariant = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setRounded(sValue As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getOutline As Boolean
    Return mbOutline
End Sub

Public Sub setOutline(bValue As Boolean)
    mbOutline = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Private Sub GetTextColor As Int
    If mbOutline Then
        If msVariant = "none" Or msVariant = "" Then
            Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
        Else
            Return B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black))
        End If
    Else
        Return B4XDaisyVariants.ResolveTextColorVariant(msVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black))
    End If
End Sub



Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub
#End Region
#End Region

#Region Digit 3D Flip Animation
Private Sub StartAnimation(iFromVal As Int, iToVal As Int)
    If mbAnimating Then
        timerAnimate.Enabled = False
    End If
    mnAnimateFrom = iFromVal
    mnAnimateTo = iToVal
    mnValue = iToVal
    
    mFlipOldDigits = mnValueToString(mnAnimateFrom)
    mFlipNewDigits = mnValueToString(mnAnimateTo)
    
    BuildDigitPanels(mFlipOldDigits, GetTextColor, B4XDaisyVariants.ResolveTextSizeDip(msTextSize))
    
    mbAnimating = True
    mnAnimateStep = 0
    mnAnimateTotalSteps = Max(1, miDuration / timerAnimate.Interval)
    mFlipMidpoint = Max(1, mnAnimateTotalSteps / 2)
    timerAnimate.Enabled = True
End Sub

Private Sub timerAnimate_Tick
    mnAnimateStep = mnAnimateStep + 1
    If mnAnimateStep >= mnAnimateTotalSteps Then
        timerAnimate.Enabled = False
        mbAnimating = False
        For i = 0 To mDigitPanels.Size - 1
            Dim pnl As B4XView = mDigitPanels.Get(i)
            SetRotationX(pnl, 0)
        Next
        BuildDigitPanels(mFlipNewDigits, GetTextColor, B4XDaisyVariants.ResolveTextSizeDip(msTextSize))
        Dim oldWidth As Int = mBase.Width
        Dim measureVal As Int = mDigitPanels.Size * mDigitWidth
        Dim measureLab As Int = 0
        If lblLabel.Visible Then measureLab = MeasureTextWidth(msLabel, lblLabel.TextSize, lblLabel.Typeface)
        
        Dim paddingLR As Int = 2dip
        If msVariant <> "none" And msVariant <> "" Then
            paddingLR = 6dip
        End If
        
        Dim requiredWidth As Int = 0
        If msLabelPosition = "right" Then
            requiredWidth = measureVal + paddingLR * 2 + measureLab + 4dip
        Else If msLabelPosition = "bottom" Then
            Dim contentW As Int = measureVal + paddingLR * 2
            requiredWidth = Max(contentW, measureLab + 4dip)
        Else
            requiredWidth = measureVal + paddingLR * 2
        End If
        
        mnRequiredWidth = Max(requiredWidth, 40dip)
        If mnTargetWidth > 0 Then
            mBase.Width = mnTargetWidth
        Else
            mBase.Width = mnRequiredWidth
        End If
        
        If mnTargetWidth > 0 Then
            Base_Resize(mnTargetWidth, mBase.Height)
        Else
            Base_Resize(mBase.Width, mBase.Height)
        End If
        
'        If mBase.Width <> oldWidth Then
'            If mCallBack <> Null And SubExists(mCallBack, "ItemSizeChanged") Then
'                CallSub(mCallBack, "ItemSizeChanged")
'            End If
'        End If
        Return
    End If
    
    If mnAnimateStep < mFlipMidpoint Then
        ' Phase 1: flip away 0 -> -90 (ease-in)
        Dim t As Float = mnAnimateStep / mFlipMidpoint
        t = t * t
        Dim angle As Float = -90 * t
        For i = 0 To mDigitPanels.Size - 1
            Dim pnl As B4XView = mDigitPanels.Get(i)
            SetRotationX(pnl, angle)
        Next
    Else If mnAnimateStep = mFlipMidpoint Then
        ' Midpoint: swap text, set rotation to 90
        BuildDigitPanels(mFlipNewDigits, GetTextColor, B4XDaisyVariants.ResolveTextSizeDip(msTextSize))
        For i = 0 To mDigitPanels.Size - 1
            Dim pnl As B4XView = mDigitPanels.Get(i)
            SetRotationX(pnl, 90)
        Next
    Else
        ' Phase 2: flip in 90 -> 0 (ease-out)
        Dim t As Float = (mnAnimateStep - mFlipMidpoint) / mFlipMidpoint
        t = 1 - (1 - t) * (1 - t)
        Dim angle As Float = 90 * (1 - t)
        For i = 0 To mDigitPanels.Size - 1
            Dim pnl As B4XView = mDigitPanels.Get(i)
            SetRotationX(pnl, angle)
        Next
    End If
End Sub

Private Sub SetRotationX(vView As B4XView, fAngle As Float)
    #If B4A
    If vView.IsInitialized Then
        Dim jo As JavaObject = vView
        jo.RunMethod("setRotationX", Array As Object(fAngle))
    End If
    #End If
End Sub

Private Sub mnValueToString(iV As Int) As String
    Dim s As String = iV
    If mnDigits = 2 Then
        s = NumberFormat(iV, 2, 0)
    Else If mnDigits = 3 Then
        s = NumberFormat(iV, 3, 0)
    End If
    Return s
End Sub
#End Region

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
    mnValue = B4XDaisyVariants.GetPropInt(mProps, "Value", mnValue)
    mnDigits = B4XDaisyVariants.GetPropInt(mProps, "Digits", mnDigits)
    msLabel = B4XDaisyVariants.GetPropString(mProps, "Label", msLabel)
    msLabelPosition = B4XDaisyVariants.GetPropString(mProps, "LabelPosition", msLabelPosition)
    msTextSize = B4XDaisyVariants.GetPropString(mProps, "TextSize", msTextSize)
    msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
    mbOutline = B4XDaisyVariants.GetPropBool(mProps, "Outline", False)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Rounded", msRounded)
	props.Put("Shadow", msShadow)
	props.Put("Value", mnValue)
	props.Put("Digits", mnDigits)
	props.Put("Label", msLabel)
	props.Put("LabelPosition", msLabelPosition)
	props.Put("TextSize", msTextSize)
	props.Put("Variant", msVariant)
	props.Put("Outline", mbOutline)
	props.Put("Duration", miDuration)
	Return props
End Sub
#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Or mIsResizing Then Return
    mIsResizing = True
    
    Dim numDigits As Int = mDigitPanels.Size
    Dim measureVal As Int = numDigits * mDigitWidth
    Dim measureLab As Int
    If msLabel = "" Then
        measureLab = 0
    Else
        measureLab = MeasureTextWidth(msLabel, lblLabel.TextSize, lblLabel.Typeface)
    End If
    
    Dim paddingLR As Int = 2dip
    If msVariant <> "none" And msVariant <> "" Then
        paddingLR = 6dip
    End If
    
    If msLabelPosition = "right" Then
        Dim contentW As Int = measureVal + measureLab
        Dim startX As Int = (dWidth - contentW) / 2
        If startX < paddingLR Then startX = paddingLR
        mDigitPanelContainer.SetLayoutAnimated(0, startX, 0, measureVal, dHeight)
        If lblLabel.Visible Then
            lblLabel.SetLayoutAnimated(0, startX + measureVal, 0, measureLab + 2dip, dHeight)
        Else
            lblLabel.SetLayoutAnimated(0, 0, 0, 0, dHeight)
        End If
        lblLabel.Gravity = Gravity.CENTER_VERTICAL
    Else
        Dim contentW As Int = measureVal
        Dim startX As Int = (dWidth - contentW) / 2
        If startX < 0 Then startX = 0
        
        If msLabelPosition = "none" Or lblLabel.Visible = False Then
            mDigitPanelContainer.SetLayoutAnimated(0, startX, 0, measureVal, dHeight)
            lblLabel.SetLayoutAnimated(0, 0, 0, 0, 0)
        Else
            Dim digitTextHeight As Int = mnLineHeight
            Dim labelTextHeight As Int = (lblLabel.TextSize * 1.5) * 1dip
            Dim gapY As Int = 4dip
            Dim totalBlockHeight As Int = digitTextHeight + gapY + labelTextHeight
            Dim startY As Int = (dHeight - totalBlockHeight) / 2
            If startY < 0 Then startY = 0
            
            mDigitPanelContainer.SetLayoutAnimated(0, startX, startY, measureVal, digitTextHeight)
            lblLabel.SetLayoutAnimated(0, 0, startY + digitTextHeight + gapY, dWidth, labelTextHeight)
            lblLabel.Gravity = Gravity.CENTER
        End If
    End If
    
    LayoutDigitPanels
    
    mIsResizing = False
End Sub

Private Sub BuildDigitPanels(sValue As String, iTextColor As Int, fFontSize As Float)
    Dim charCount As Int = sValue.Length
    Do While mDigitPanels.Size > charCount
        Dim idx As Int = mDigitPanels.Size - 1
        Dim pnlToRemove As B4XView = mDigitPanels.Get(idx)
        pnlToRemove.RemoveViewFromParent
        mDigitPanels.RemoveAt(idx)
        mDigitLabels.RemoveAt(idx)
    Loop
    Do While mDigitPanels.Size < charCount
        Dim pnl As Panel
        pnl.Initialize("")
        Dim bpnl As B4XView = pnl
        bpnl.Color = xui.Color_Transparent
        mDigitPanelContainer.AddView(bpnl, 0, 0, 0, 0)
        mDigitPanels.Add(bpnl)
        
        Dim newLbl As Label
        newLbl.Initialize("")
        Dim blbl As B4XView = newLbl
        bpnl.AddView(blbl, 0, 0, 0, 0)
        blbl.TextColor = iTextColor
        blbl.TextSize = fFontSize
        newLbl.Typeface = Typeface.MONOSPACE
        mDigitLabels.Add(blbl)
    Loop
    
    mDigitWidth = MeasureTextWidth("8", fFontSize, Typeface.MONOSPACE)
    mDigitWidth = Max(mDigitWidth, 10dip)
    For i = 0 To charCount - 1
        Dim ch As String = sValue.CharAt(i)
        Dim eachLbl As B4XView = mDigitLabels.Get(i)
        eachLbl.Text = ch
    Next
    For i = 0 To mDigitLabels.Size - 1
        Dim targetLbl As B4XView = mDigitLabels.Get(i)
        targetLbl.TextColor = iTextColor
        targetLbl.TextSize = fFontSize
    Next
End Sub

Private Sub LayoutDigitPanels
    Dim num As Int = mDigitPanels.Size
    Dim chHeight As Float = mDigitPanelContainer.Height
    For i = 0 To num - 1
        Dim pnl As B4XView = mDigitPanels.Get(i)
        pnl.SetLayoutAnimated(0, i * mDigitWidth, 0, mDigitWidth, chHeight)
        Dim lbl As B4XView = mDigitLabels.Get(i)
        lbl.SetLayoutAnimated(0, 0, 0, mDigitWidth, chHeight)
        #If B4A
        Dim nativeLbl As Label = lbl
        nativeLbl.Gravity = Gravity.CENTER
        #End If
    Next
End Sub

Private Sub MeasureTextWidth(sText As String, fTextSize As Float, tf As Typeface) As Int
    ' delegate to shared safe helper (adds buffer to avoid clipping)
    Return B4XDaisyVariants.MeasureTextWidthSafe(sText, fTextSize, tf, 4dip)
End Sub

' helper: convert tailwind text-size string to dip value (delegates to global variant helper)
Private Sub TextSizeTokenToDip(sToken As String, fDefaultDip As Float) As Float
    Dim res As Float = B4XDaisyVariants.ResolveTextSizeDip(sToken)
    If res <= 0 Then res = fDefaultDip
    Return res
End Sub

#End Region

#Region Cleanup
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

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
