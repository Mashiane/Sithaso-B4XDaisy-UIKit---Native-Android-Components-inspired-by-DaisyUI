B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: K, Description: Kbd label text.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy kbd size token.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius token.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind padding utility tokens (for example: px-2 py-1).
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind margin utility tokens.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override text color.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide component.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize width to fit text content.

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private lblContent As B4XView
    Private borderBottomLine As B4XView

    Private mText As String = "K"
    Private mSize As String = "md"
    Private mRounded As String = "theme"
    Private mPadding As String = ""
    Private mMargin As String = ""
    Private mBackgroundColor As Int = xui.Color_Transparent
    Private mTextColor As Int = xui.Color_Transparent
    Private mVisible As Boolean = True
    Private mbAutoResize As Boolean = True
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

    Dim l As Label
    l.Initialize("part")
    lblContent = l
    lblContent.SetTextAlignment("CENTER", "CENTER")
    lblContent.Color = xui.Color_Transparent
    mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)

    Dim p As Panel
    p.Initialize("")
    borderBottomLine = p
    borderBottomLine.Color = xui.Color_Transparent
    borderBottomLine.Enabled = False
    mBase.AddView(borderBottomLine, 0, 0, 0, 0)

    mText = B4XDaisyVariants.GetPropString(Props, "Text", "K")
    mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", "md"))
    mRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", "theme")
    mPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "")
    mMargin = B4XDaisyVariants.GetPropString(Props, "Margin", "")
    mBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", xui.Color_Transparent)
    mTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", xui.Color_Transparent)
    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    mbAutoResize = B4XDaisyVariants.GetPropBool(Props, "AutoResize", True)

    Refresh
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        Dim props As Map = BuildRuntimeProps
        DesignerCreateView(p, Null, props)
    End If

    If Width <= 0 Then Width = ResolveMinSizeDip(mSize)
    If Height <= 0 Then Height = ResolveMinSizeDip(mSize)
    Parent.AddView(mBase, Left, Top, Width, Height)
    Base_Resize(mBase.Width, mBase.Height)
    Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Text": mText, _
        "Size": mSize, _
        "Rounded": mRounded, _
        "Padding": mPadding, _
        "Margin": mMargin, _
        "BackgroundColor": mBackgroundColor, _
        "TextColor": mTextColor, _
        "Visible": mVisible, _
        "AutoResize": mbAutoResize)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return

    Dim minSize As Int = ResolveMinSizeDip(mSize)
    If Width < minSize Or Height < minSize Then
        Dim w As Int = Max(minSize, Width)
        Dim h As Int = Max(minSize, Height)
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
        Width = w
        Height = h
    End If

    Dim p As Map = ResolvePadding
    Dim l As Int = p.Get("l")
    Dim t As Int = p.Get("t")
    Dim r As Int = p.Get("r")
    Dim b As Int = p.Get("b")

    lblContent.SetLayoutAnimated(0, l, t, Max(1dip, Width - l - r), Max(1dip, Height - t - b))

    If borderBottomLine.IsInitialized Then
        Dim bw As Int = ResolveBorderDip
        Dim bbw As Int = ResolveBottomBorderDip
        borderBottomLine.SetLayoutAnimated(0, bw, Max(0dip, Height - bbw), Max(1dip, Width - (bw * 2)), bbw)
    End If
    DoAutoResize
End Sub

Private Sub Refresh
    If mBase.IsInitialized = False Then Return

    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(63, 64, 77))
    Dim defaultBg As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(229, 231, 235))
    Dim bg As Int = IIf(mBackgroundColor = xui.Color_Transparent, defaultBg, mBackgroundColor)
    Dim fg As Int = IIf(mTextColor = xui.Color_Transparent, baseContent, mTextColor)
    Dim borderColor As Int = ResolveBorderColor(baseContent)
    Dim borderDip As Int = ResolveBorderDip

    lblContent.Text = mText
    lblContent.TextColor = fg
    lblContent.TextSize = ResolveFontSizeDip(mSize)
    mBase.SetColorAndBorder(bg, borderDip, borderColor, ResolveRadiusDip(mRounded))
    If borderBottomLine.IsInitialized Then borderBottomLine.Color = borderColor
    mBase.Visible = mVisible

    Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ResolvePadding As Map
    Dim fontDip As Float = ResolveFontSizeDip(mSize)
    Dim inlinePad As Int = Max(0dip, Round(fontDip * 0.5))
    Dim left As Int = inlinePad
    Dim top As Int = 0dip
    Dim right As Int = inlinePad
    Dim bottom As Int = 0dip

    If mPadding.Trim.Length > 0 Then
        Dim tokens() As String = Regex.Split("\s+", mPadding.Trim)
        For Each tok As String In tokens
            Dim t As String = tok.ToLowerCase.Trim
            If t.Length = 0 Then Continue
            If t.StartsWith("p-") Then
                Dim v As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(2), 0)
                left = v : right = v : top = v : bottom = v
            Else If t.StartsWith("px-") Then
                Dim v2 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
                left = v2 : right = v2
            Else If t.StartsWith("py-") Then
                Dim v3 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
                top = v3 : bottom = v3
            Else If t.StartsWith("pt-") Then
                top = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
            Else If t.StartsWith("pr-") Then
                right = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), right)
            Else If t.StartsWith("pb-") Then
                bottom = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), bottom)
            Else If t.StartsWith("pl-") Then
                left = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
            End If
        Next
    End If

    Return CreateMap("l": Max(0dip, left), "t": Max(0dip, top), "r": Max(0dip, right), "b": Max(0dip, bottom))
End Sub


Private Sub ResolveFontSizeDip(SizeToken As String) As Float
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 10
        Case "sm"
            Return 12
        Case "md"
            Return 14
        Case "lg"
            Return 16
        Case "xl"
            Return 18
        Case Else
            Return 14
    End Select
End Sub

Private Sub ResolveMinSizeDip(SizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 16dip
        Case "sm"
            Return 20dip
        Case "md"
            Return 24dip
        Case "lg"
            Return 28dip
        Case "xl"
            Return 32dip
        Case Else
            Return 24dip
    End Select
End Sub

Private Sub ResolveBorderDip As Int
    Return Max(0dip, B4XDaisyVariants.GetBorderDip(1dip))
End Sub

Private Sub ResolveBottomBorderDip As Int
    Return ResolveBorderDip + 1dip
End Sub

Private Sub ResolveBorderColor(BaseContent As Int) As Int
    Return xui.Color_ARGB(51, Bit.And(Bit.ShiftRight(BaseContent, 16), 0xFF), Bit.And(Bit.ShiftRight(BaseContent, 8), 0xFF), Bit.And(BaseContent, 0xFF))
End Sub

Private Sub ResolveRadiusDip(RoundedToken As String) As Int
    Dim s As String = IIf(RoundedToken = Null, "theme", RoundedToken.ToLowerCase.Trim)
    Select Case s
        Case "theme", ""
            Return Max(0dip, B4XDaisyVariants.GetRadiusFieldDip(6dip))
        Case Else
            Return Max(0dip, B4XDaisyVariants.TailwindBorderRadiusToDip(s, B4XDaisyVariants.GetRadiusFieldDip(6dip)))
    End Select
End Sub

Public Sub setText(Value As String)
    mText = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText As String
    Return mText
End Sub

Public Sub setSize(Value As String)
    mSize = B4XDaisyVariants.NormalizeSize(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return mSize
End Sub

Public Sub setRounded(Value As String)
    mRounded = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

Public Sub setPadding(Value As String)
    mPadding = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPadding As String
    Return mPadding
End Sub

Public Sub setMargin(Value As String)
    mMargin = IIf(Value = Null, "", Value)
End Sub

Public Sub getMargin As String
    Return mMargin
End Sub

Public Sub setBackgroundColor(Value As Int)
    mBackgroundColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setTextColor(Value As Int)
    mTextColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mTextColor
End Sub

Public Sub setVisible(Value As Boolean)
    mVisible = Value
    If mBase.IsInitialized = False Then Return
    mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setAutoResize(Value As Boolean)
    mbAutoResize = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAutoResize As Boolean
    Return mbAutoResize
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Private Sub mBase_Click
    RaiseClick
End Sub

Private Sub part_Click
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

Private Sub MeasureKbdTextWidth(v As B4XView, Text As String) As Int
    If Text.Length = 0 Then Return 0
    Try
        Dim l As Label = v
        Dim c As Canvas
        c.Initialize(l)
        Return Ceil(c.MeasureStringWidth(Text, l.Typeface, l.TextSize)) + 2dip
    Catch
    End Try 'ignore
    Return Ceil(Text.Length * ResolveFontSizeDip(mSize) * 0.62) + 2dip
End Sub

Private Sub DoAutoResize
    If mbAutoResize = False Then Return
    If mBase.IsInitialized = False Then Return
    If lblContent.IsInitialized = False Then Return
    Dim p As Map = ResolvePadding
    Dim padL As Int = p.Get("l")
    Dim padR As Int = p.Get("r")
    Dim padT As Int = p.Get("t")
    Dim padB As Int = p.Get("b")
    Dim minSize As Int = ResolveMinSizeDip(mSize)
    Dim textW As Int = MeasureKbdTextWidth(lblContent, mText)
    Dim newW As Int = Max(minSize, padL + textW + padR)
    Dim fontH As Float = ResolveFontSizeDip(mSize) * 1.2
    Dim newH As Int = Max(minSize, Round(padT + fontH + padB))
    If newW <> mBase.Width Or newH <> mBase.Height Then
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, newW, newH)
        lblContent.SetLayoutAnimated(0, padL, padT, Max(1dip, newW - padL - padR), Max(1dip, newH - padT - padB))
        If borderBottomLine.IsInitialized Then
            Dim bw As Int = ResolveBorderDip
            Dim bbw As Int = ResolveBottomBorderDip
            borderBottomLine.SetLayoutAnimated(0, bw, Max(0dip, newH - bbw), Max(1dip, newW - (bw * 2)), bbw)
        End If
    End If
End Sub
