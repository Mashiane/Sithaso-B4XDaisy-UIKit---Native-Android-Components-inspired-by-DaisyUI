B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#End Region

#DesignerProperty: Key: Value, DisplayName: Value, FieldType: Int, DefaultValue: 0, Description: Current numeric value (0-999).
#DesignerProperty: Key: Digits, DisplayName: Digits, FieldType: Int, DefaultValue: 1, Description: Minimum number of digits to display.
#DesignerProperty: Key: Label, DisplayName: Label, FieldType: String, DefaultValue: , Description: Text label for this segment (e.g. days, hours).
#DesignerProperty: Key: LabelPosition, DisplayName: Label Position, FieldType: String, DefaultValue: RIGHT, List: RIGHT|BOTTOM, Description: Where to place the label relative to the number.
#DesignerProperty: Key: Separator, DisplayName: Separator, FieldType: String, DefaultValue: , Description: Optional separator string (e.g. ":") shown after the number.
#DesignerProperty: Key: TextSize, DisplayName: Font Size, FieldType: String, DefaultValue: text-base, List: text-xs|text-sm|text-base|text-lg|text-xl|text-2xl|text-3xl|text-4xl|text-5xl|text-6xl|text-7xl|text-8xl|text-9xl, Description: Typography size token.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Internal views
    Private lblValue As Label
    Private lblLabel As Label
    Private lblSeparator As Label
    
    ' Local properties
    Private mnValue As Int = 0
    Private mnDigits As Int = 1
    Private msLabel As String = ""
    Private msLabelPosition As String = "RIGHT"
    Private msSeparator As String = ""
    Private msTextSize As String = "text-base"
    Private msVariant As String = "none"
    ' new style props
    Private msRounded As String = "none"
    Private msShadow As String = "none"
    Private mnLineHeight As Float = B4XDaisyVariants.LINE_HEIGHT_DEFAULT
    
    ' debug border flag (matches countdown container) - off by default
    Private DEBUG_BORDER As Boolean = False
    
    Private mIsResizing As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Initialize labels
    lblValue.Initialize("")
    lblLabel.Initialize("")
    lblSeparator.Initialize("")
    
    mBase.AddView(lblValue, 0, 0, 0, 0)
    mBase.AddView(lblLabel, 0, 0, 0, 0)
    mBase.AddView(lblSeparator, 0, 0, 0, 0)
    
    ' Load properties
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "none"))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    mnValue = B4XDaisyVariants.GetPropInt(Props, "Value", 0)
    mnDigits = B4XDaisyVariants.GetPropInt(Props, "Digits", 1)
    msLabel = B4XDaisyVariants.GetPropString(Props, "Label", "")
    msLabelPosition = B4XDaisyVariants.GetPropString(Props, "LabelPosition", "RIGHT")
    msSeparator = B4XDaisyVariants.GetPropString(Props, "Separator", "")
    msTextSize = B4XDaisyVariants.GetPropString(Props, "TextSize", "text-base")
    msVariant = B4XDaisyVariants.GetPropString(Props, "Variant", "none")
    ' LineHeight is now managed globally but can be overridden in code
    ' line-height is resolved dynamically via global variants (see Refresh)
    mnLineHeight = B4XDaisyVariants.LINE_HEIGHT_DEFAULT
    
    ' Apply safety standard #10: Disable clipping
    ' (handled by global style or parent container now)
    Refresh
End Sub
#End Region

#Region Public API
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    ' re-apply background and decorations if theme changed
    mBase.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, xui.Color_Transparent)
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    B4XDaisyVariants.ApplyElevation(mBase, msShadow)
    mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, radius)
    Refresh
End Sub

Public Sub Refresh
    ' Format value string based on Digits
    Dim sVal As String = mnValue
    If mnDigits = 2 Then
        sVal = NumberFormat(mnValue, 2, 0)
    Else If mnDigits = 3 Then
        sVal = NumberFormat(mnValue, 3, 0)
    End If
    ' Apply styles
    ' resolve background first (allows variant to color the panel)
    mBase.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, xui.Color_Transparent)
    Dim textColor As Int = B4XDaisyVariants.ResolveTextColorVariant(msVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black))
    ' radius & elevation
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    B4XDaisyVariants.ApplyElevation(mBase, msShadow)
    mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, radius)
    ' Set text size (tailwind tokens) using shared variant utility
    Dim fontSize As Float = B4XDaisyVariants.ResolveTextSizeDip(msTextSize)
    If fontSize <= 0 Then fontSize = 16dip
    ' Resolve line-height from global variants (matching web behavior)
    Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(msTextSize, fontSize, fontSize * 1.5)
    mnLineHeight = tm.GetDefault("line_height_dip", B4XDaisyVariants.LINE_HEIGHT_DEFAULT)
        
    lblValue.Text = sVal
    lblValue.TextColor = textColor
    lblValue.TextSize = fontSize
    lblValue.Typeface = Typeface.MONOSPACE
    B4XDaisyVariants.SetLineSpacing(lblValue, mnLineHeight, 0)
    
    if mslabel.trim <> "" then
        lblLabel.Text = msLabel
        lbllabel.visible = true
        lblLabel.TextColor = textColor
        lblLabel.TextSize = fontSize * 0.7 
        B4XDaisyVariants.SetLineSpacing(lblLabel, mnLineHeight, 0)
    else
        lbllabel.visible = false    
    End If

    if msSeparator.trim <> "" then
        lblSeparator.Text = msSeparator
        lblSeparator.Visible = True
        lblSeparator.TextColor = textColor
        lblSeparator.TextSize = fontSize
        B4XDaisyVariants.SetLineSpacing(lblSeparator, mnLineHeight, 0)
    else
        lblSeparator.Visible = False
    end if        
    
    If msLabelPosition = "RIGHT" Then
        Dim measureVal As Int = MeasureTextWidth(lblValue.Text, lblValue.TextSize, lblValue.Typeface)
        Dim measureSep As Int = 0
        Dim measureLab As Int = 0
        If lblSeparator.Visible Then measureSep = MeasureTextWidth(msSeparator, lblSeparator.TextSize, lblSeparator.Typeface)
        If lblLabel.Visible Then measureLab = MeasureTextWidth(msLabel, lblLabel.TextSize, lblLabel.Typeface)
        ' Add generous buffers to prevent cropping
        Dim extraGap As Int = 0
        If measureSep > 0 Then extraGap = 4dip
        mBase.Width = measureVal + 8dip + measureSep + extraGap + measureLab + 8dip
    End If
    
    
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("mBase")
    Dim b As B4XView = p
    b.SetLayoutAnimated(0, 0, 0, Width, Height)
    Dim props As Map = CreateMap("Value": mnValue, "Digits": mnDigits, "Label": msLabel, "LabelPosition": msLabelPosition, "Separator": msSeparator, "TextSize": msTextSize, "Variant": msVariant, "Rounded": msRounded, "Shadow": msShadow)
    DesignerCreateView(b, Null, props)
    Return mBase
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        CreateView(Width, Height)
    End If
    Parent.AddView(mBase, Left, Top, Width, Height)
    Return mBase
End Sub

Public Sub getView As B4XView
    Return mBase
End Sub

Public Sub getIsInitialized As Boolean
    If mBase.IsInitialized = False Then Return False
    Return lblValue.IsInitialized
End Sub

#Region Getters/Setters
Public Sub getValue As Int
    Return mnValue
End Sub

Public Sub setValue(Value As Int)
    mnValue = Max(0, Min(999, Value))
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getDigits As Int
    Return mnDigits
End Sub

Public Sub setDigits(Value As Int)
    mnDigits = Max(1, Min(3, Value))
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabel As String
    Return msLabel
End Sub

Public Sub setLabel(Value As String)
    msLabel = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabelPosition As String
    Return msLabelPosition
End Sub

Public Sub setLabelPosition(Value As String)
    msLabelPosition = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSeparator As String
    Return msSeparator
End Sub

Public Sub setSeparator(Value As String)
    msSeparator = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextSize As String
    Return msTextSize
End Sub

Public Sub setTextSize(Value As String)
    msTextSize = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setVariant(Value As String)
    msVariant = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setRounded(Value As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(Value)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized Then Refresh
End Sub



Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub
#End Region
#End Region

#Region Base Events
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Or mIsResizing Then Return
    mIsResizing = True
    
    ' Layout depends on LabelPosition
    Dim measureVal As Int = MeasureTextWidth(lblValue.Text, lblValue.TextSize, lblValue.Typeface)
    Dim measureSep As Int = IIf(msSeparator = "", 0, MeasureTextWidth(msSeparator, lblSeparator.TextSize, lblSeparator.Typeface))
    Dim measureLab As Int = IIf(msLabel = "", 0, MeasureTextWidth(msLabel, lblLabel.TextSize, lblLabel.Typeface))
    
    If msLabelPosition = "RIGHT" Then
        ' Horizontal layout: [Value][Separator][Label]
        ' Add small gaps and horizontal padding (4dip)
        lblValue.SetLayoutAnimated(0, 4dip, 0, measureVal + 2dip, Height)
        If lblSeparator.Visible Then
            lblSeparator.SetLayoutAnimated(0, 4dip + measureVal + 2dip, 0, measureSep + 2dip, Height)
        Else
            lblSeparator.SetLayoutAnimated(0, 0, 0, 0, Height)
        End If
        If lblLabel.Visible Then
            lblLabel.SetLayoutAnimated(0, 4dip + measureVal + 2dip + measureSep + 2dip, 0, measureLab + 2dip, Height)
        Else
            lblLabel.SetLayoutAnimated(0, 0, 0, 0, Height)
        End If
        
        lblValue.Gravity = Gravity.CENTER_VERTICAL
        lblSeparator.Gravity = Gravity.CENTER_VERTICAL
        lblLabel.Gravity = Gravity.CENTER_VERTICAL
    Else
        ' Vertical layout: [Value + Separator] over [Label]
        lblValue.SetLayoutAnimated(0, 0, 0, Width, Height * 0.75)
        lblSeparator.SetLayoutAnimated(0, Width - measureSep, 0, measureSep, Height * 0.75)
        lblLabel.SetLayoutAnimated(0, 0, Height * 0.75, Width, Height * 0.25)
        
        ' use Gravity to avoid unsupported SetTextAlignment bug
        lblValue.Gravity = Gravity.CENTER
        lblLabel.Gravity = Gravity.CENTER_HORIZONTAL
    End If
    
    mIsResizing = False
End Sub

Private Sub MeasureTextWidth(Text As String, TextSize As Float, tf As Typeface) As Int
    ' delegate to shared safe helper (adds buffer to avoid clipping)
    Return B4XDaisyVariants.MeasureTextWidthSafe(Text, TextSize, tf, 4dip)
End Sub

' helper: convert tailwind text-size string to dip value (delegates to global variant helper)
Private Sub TextSizeTokenToDip(Token As String, DefaultDip As Float) As Float
    Dim res As Float = B4XDaisyVariants.ResolveTextSizeDip(Token)
    If res <= 0 Then res = DefaultDip
    Return res
End Sub

Private Sub mBase_Click
    RaiseClick
End Sub

Private Sub RaiseClick
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
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
