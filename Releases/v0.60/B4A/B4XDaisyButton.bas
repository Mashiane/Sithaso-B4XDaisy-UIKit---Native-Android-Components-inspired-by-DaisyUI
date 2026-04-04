B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: Button, Description: Button label.
'#DesignerProperty: Key: Class, DisplayName: Class, FieldType: String, DefaultValue: btn, Description: Daisy class tokens (for example: btn btn-primary btn-outline).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: default, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Semantic color variant.
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost|link, Description: Daisy button style.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy button size token.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius token.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind padding utility tokens (for example: px-3 py-1).
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind margin utility tokens.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 40px, Description: Tailwind/CSS width token (for example: auto, 40px, w-40, [12rem]).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Tailwind/CSS height token (for example: auto, 40px, h-10, [3rem]).
#DesignerProperty: Key: IconName, DisplayName: Icon Name, FieldType: String, DefaultValue:, Description: SVG icon asset file name.
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Optional icon color override.
#DesignerProperty: Key: Wide, DisplayName: Wide, FieldType: Boolean, DefaultValue: False, Description: Applies btn-wide behavior.
#DesignerProperty: Key: Block, DisplayName: Block, FieldType: Boolean, DefaultValue: False, Description: Applies btn-block behavior.
#DesignerProperty: Key: Square, DisplayName: Square, FieldType: Boolean, DefaultValue: False, Description: Applies btn-square behavior.
#DesignerProperty: Key: Circle, DisplayName: Circle, FieldType: Boolean, DefaultValue: False, Description: Applies btn-circle behavior.
#DesignerProperty: Key: Active, DisplayName: Active, FieldType: Boolean, DefaultValue: False, Description: Applies btn-active behavior.
#DesignerProperty: Key: Disabled, DisplayName: Disabled, FieldType: Boolean, DefaultValue: False, Description: Applies disabled behavior.
#DesignerProperty: Key: Loading, DisplayName: Loading, FieldType: Boolean, DefaultValue: False, Description: Shows loading indicator.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override background color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override text color.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override border color.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide component.

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private lblContent As B4XView
    Private iconComp As B4XDaisySvgIcon
    Private iconView As B4XView
    Private loadingComp As B4XDaisyLoading
    Private loadingView As B4XView
    Private pnlMeasure As B4XView
    Private cvsMeasure As B4XCanvas

    Private mText As String = "Button"
    Private mClassTokens As String = "btn"
    Private mShadow As String = "xs"
    Private mVariant As String = "default"
    Private mStyle As String = "solid"
    Private mSize As String = "md"
    Private mRounded As String = "theme"
    Private mPadding As String = ""
    Private mMargin As String = ""
    Private mWidth As String = "40px"
    Private mHeight As String = "auto"
    Private mIconName As String = ""
    Private mIconColor As Int = xui.Color_Transparent

    Private mWide As Boolean = False
    Private mBlock As Boolean = False
    Private mSquare As Boolean = False
    Private mCircle As Boolean = False
    Private mActive As Boolean = False
    Private mDisabled As Boolean = False
    Private mLoading As Boolean = False

    Private mBackgroundColor As Int = xui.Color_Transparent
    Private mTextColor As Int = xui.Color_Transparent
    Private mBorderColor As Int = xui.Color_Transparent
    Private mVisible As Boolean = True
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me

    Dim t As Label
    t.Initialize("part")
    lblContent = t
    lblContent.SetTextAlignment("CENTER", "CENTER")
    lblContent.Color = xui.Color_Transparent
    Dim lContent As Label = lblContent
    lContent.SingleLine = True
    EnsureContentSingleLine
    mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)

    Dim icon As B4XDaisySvgIcon
    icon.Initialize(Me, "btnicon")
    iconComp = icon
    iconView = iconComp.AddToParent(mBase, 0, 0, 1dip, 1dip)
    iconView.Visible = False

    Dim ld As B4XDaisyLoading
    ld.Initialize(Me, "btnloading")
    loadingComp = ld
    loadingView = loadingComp.AddToParent(mBase, 0, 0, 1dip, 1dip)
    loadingView.Visible = False

    Dim p As Panel
    p.Initialize("")
    pnlMeasure = p
    mBase.AddView(pnlMeasure, 0, 0, 120dip, 40dip)
    pnlMeasure.Visible = False
    cvsMeasure.Initialize(pnlMeasure)

mText = B4XDaisyVariants.GetPropString(Props, "Text", mText)
    mClassTokens = B4XDaisyVariants.GetPropString(Props, "Class", mClassTokens)
    mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", mVariant))
    mStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(Props, "Style", mStyle))
    mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", mSize))
    mRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", mRounded)
    mPadding = B4XDaisyVariants.GetPropString(Props, "Padding", mPadding)
    mMargin = B4XDaisyVariants.GetPropString(Props, "Margin", mMargin)
    mWidth = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(Props, "Width", mWidth), "40px")
    mHeight = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(Props, "Height", mHeight), "auto")
    mIconName = B4XDaisyVariants.GetPropString(Props, "IconName", mIconName)
    mIconColor = B4XDaisyVariants.GetPropColor(Props, "IconColor", mIconColor)
    mWide = B4XDaisyVariants.GetPropBool(Props, "Wide", mWide)
    mBlock = B4XDaisyVariants.GetPropBool(Props, "Block", mBlock)
    mSquare = B4XDaisyVariants.GetPropBool(Props, "Square", mSquare)
    mCircle = B4XDaisyVariants.GetPropBool(Props, "Circle", mCircle)
    mActive = B4XDaisyVariants.GetPropBool(Props, "Active", mActive)
    mDisabled = B4XDaisyVariants.GetPropBool(Props, "Disabled", mDisabled)
    mLoading = B4XDaisyVariants.GetPropBool(Props, "Loading", mLoading)
    mBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", mBackgroundColor)
    mTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", mTextColor)
    mBorderColor = B4XDaisyVariants.GetPropColor(Props, "BorderColor", mBorderColor)
    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)

    ParseClassTokens(mClassTokens)
    Refresh
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        DesignerCreateView(p, Null, BuildRuntimeProps)
    End If

    Dim mg As Map = ResolveMargin
    Left = Left + mg.Get("l")
    Top = Top + mg.Get("t")
    Width = Width - mg.Get("l") - mg.Get("r")
    Height = Height - mg.Get("t") - mg.Get("b")

    Dim controlSize As Int = ResolveButtonHeightDip(mSize)
    If Width <= 0 Then Width = ResolveConfiguredWidthDip(controlSize)
    If mBlock = False Then Width = Max(Width, EstimateContentWidthDip)
    If Height <= 0 Then Height = ResolveConfiguredHeightDip(controlSize)
    If mBlock Then
        Dim available As Int = Parent.Width - Left - mg.Get("r")
        If available > controlSize Then
            Width = Max(Width, available)
        Else
            Width = Max(Width, EstimateContentWidthDip)
        End If
    Else If mWide Then
        Width = ResolveWideWidthDip(Max(Width, EstimateContentWidthDip), Left, Parent, mg, controlSize)
    End If

    Parent.AddView(mBase, Left, Top, Width, Height)
    Base_Resize(mBase.Width, mBase.Height)
    Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Text": mText, _
        "Class": mClassTokens, _
        "Variant": mVariant, _
        "Style": mStyle, _
        "Size": mSize, _
        "Rounded": mRounded, _
        "Padding": mPadding, _
        "Margin": mMargin, _
        "Width": mWidth, _
        "Height": mHeight, _
        "IconName": mIconName, _
        "IconColor": mIconColor, _
        "Wide": mWide, _
        "Block": mBlock, _
        "Square": mSquare, _
        "Circle": mCircle, _
        "Active": mActive, _
        "Disabled": mDisabled, _
        "Loading": mLoading, _
        "BackgroundColor": mBackgroundColor, _
        "TextColor": mTextColor, _
        "BorderColor": mBorderColor, _
        "Visible": mVisible)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return

    Dim targetW As Int = Max(1dip, Width)
    Dim controlSize As Int = ResolveButtonHeightDip(mSize)
    Dim targetH As Int
    If IsAutoLayoutSpec(mHeight) Then
        targetH = Max(controlSize, Height)
    Else
        targetH = Max(1dip, Height)
    End If
    Dim targetLeft As Int = mBase.Left
    Dim mg As Map = ResolveMargin

    If mSquare Or mCircle Then
        targetW = controlSize
        targetH = controlSize
    Else
        targetW = Max(targetW, controlSize)
        targetW = Max(targetW, EstimateContentWidthDip)
        If mBlock And mBase.Parent.IsInitialized Then
            Dim available As Int = mBase.Parent.Width - targetLeft - mg.Get("r")
            If available > controlSize Then
                targetW = Max(targetW, available)
            End If
        Else If mWide Then
            targetW = ResolveWideWidthDip(targetW, targetLeft, mBase.Parent, mg, controlSize)
        End If
    End If

    If targetW <> Width Or targetH <> Height Or targetLeft <> mBase.Left Then
        mBase.SetLayoutAnimated(0, targetLeft, mBase.Top, targetW, targetH)
        Width = targetW
        Height = targetH
    End If

    Dim p As Map = ResolvePadding
    Dim l As Int = p.Get("l")
    Dim t As Int = p.Get("t")
    Dim r As Int = p.Get("r")
    Dim b As Int = p.Get("b")

    Dim contentW As Int = Max(1dip, Width - l - r)
    Dim contentH As Int = Max(1dip, Height - t - b)

    Dim indicatorW As Int = Max(12dip, ResolveIndicatorSizeDip)
    Dim gap As Int = 6dip
    Dim hasText As Boolean = (mText.Trim.Length > 0)
    Dim hasIcon As Boolean = (mIconName.Trim.Length > 0)

    lblContent.Visible = hasText

    If mLoading Then
        loadingView.Visible = True
        iconView.Visible = False
        If hasText = False Then
            loadingView.SetLayoutAnimated(0, l + (contentW - indicatorW) / 2, t + (contentH - indicatorW) / 2, indicatorW, indicatorW)
            lblContent.SetLayoutAnimated(0, l, t, contentW, contentH)
        Else
            Dim tw As Int = MeasureTextWidthDip(mText, xui.CreateDefaultBoldFont(lblContent.TextSize))
            Dim totalW As Int = indicatorW + gap + tw
            Dim startX As Int = l + Max(0dip, (contentW - totalW) / 2)
            loadingView.SetLayoutAnimated(0, startX, t + (contentH - indicatorW) / 2, indicatorW, indicatorW)
            lblContent.SetLayoutAnimated(0, startX + indicatorW + gap, t, Max(1dip, contentW - (startX - l) - indicatorW - gap), contentH)
        End If
        If loadingComp.IsInitialized Then loadingComp.Base_Resize(loadingView.Width, loadingView.Height)
        iconView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
    Else If hasIcon Then
        loadingView.Visible = False
        iconView.Visible = True
        If hasText = False Then
            iconView.SetLayoutAnimated(0, l + (contentW - indicatorW) / 2, t + (contentH - indicatorW) / 2, indicatorW, indicatorW)
            lblContent.SetLayoutAnimated(0, l, t, contentW, contentH)
        Else
            Dim tw2 As Int = MeasureTextWidthDip(mText, xui.CreateDefaultBoldFont(lblContent.TextSize))
            Dim totalW2 As Int = indicatorW + gap + tw2
            Dim startX2 As Int = l + Max(0dip, (contentW - totalW2) / 2)
            iconView.SetLayoutAnimated(0, startX2, t + (contentH - indicatorW) / 2, indicatorW, indicatorW)
            lblContent.SetLayoutAnimated(0, startX2 + indicatorW + gap, t, Max(1dip, contentW - (startX2 - l) - indicatorW - gap), contentH)
        End If
        If iconComp.IsInitialized Then
            iconComp.setWidth(iconView.Width)
            iconComp.setHeight(iconView.Height)
            iconComp.ResizeToParent(iconView)
        End If
        loadingView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
    Else
        loadingView.Visible = False
        iconView.Visible = False
        loadingView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
        iconView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
        lblContent.SetLayoutAnimated(0, l, t, contentW, contentH)
    End If
    ' Explicitly set the background drawable's bounds to the resolved layout dimensions
    ' and invalidate the outline.  This is necessary for buttons inside initially-hidden
    ' containers (e.g. modals with Visible=False): Android's drawBackground never runs
    ' while a view is hidden, so GradientDrawable.getBounds() stays at 0,0,0,0.
    ' GradientDrawable.getOutline() returns empty when getBounds() is empty, which
    ' causes the shadow renderer to fall back to the view's rectangular BOUNDS outline
    ' — producing a square shadow regardless of the button's corner radius.
    ' By setting the drawable bounds here (after we know the final layout size) and
    ' re-invalidating the outline, the rounded-rect shadow is correct on first draw.
    #If B4A
    If targetW > 0 And targetH > 0 Then
        Try
            Dim joMB As JavaObject = mBase
            Dim bgDraw As JavaObject = joMB.RunMethod("getBackground", Null)
            If bgDraw.IsInitialized Then
                bgDraw.RunMethod("setBounds", Array(0, 0, targetW, targetH))
                joMB.RunMethod("invalidateOutline", Null)
            End If
        Catch
        End Try
    End If
    #End If
End Sub

Private Sub Refresh
    If mBase.IsInitialized = False Then Return

    Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
    Dim base100 As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    Dim base200 As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(229, 231, 235))
    Dim primaryBack As Int = B4XDaisyVariants.ResolveBackgroundColorVariant("primary", xui.Color_RGB(59, 130, 246))

    Dim variantBack As Int = ResolveVariantBackColor(base200)
    Dim variantText As Int = ResolveVariantTextColor(baseContent)

    Dim bg As Int = variantBack
    Dim fg As Int = variantText
    Dim br As Int = B4XDaisyVariants.Blend(bg, xui.Color_Black, 0.10)

    Select Case B4XDaisyVariants.NormalizeStyle(mStyle)
        Case "soft"
            bg = B4XDaisyVariants.Blend(base100, variantBack, 0.08)
            br = B4XDaisyVariants.Blend(base100, variantBack, 0.10)
            If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
                fg = baseContent
            Else
                fg = variantBack
            End If
        Case "outline", "dash"
            bg = xui.Color_Transparent
            br = ResolveOutlineColor(baseContent, variantBack)
            fg = br
        Case "ghost"
            bg = xui.Color_Transparent
            br = xui.Color_Transparent
            fg = ResolveOutlineColor(baseContent, variantBack)
        Case "link"
            bg = xui.Color_Transparent
            br = xui.Color_Transparent
            If NormalizeVariant(mVariant) = "default" Or NormalizeVariant(mVariant) = "none" Then
                fg = primaryBack
            Else
                fg = variantBack
            End If
        Case Else
            'solid default
    End Select

    If NormalizeVariant(mVariant) = "warning" And B4XDaisyVariants.NormalizeStyle(mStyle) = "solid" Then
        fg = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
    End If

    If mActive And bg <> xui.Color_Transparent Then
        bg = B4XDaisyVariants.Blend(bg, xui.Color_Black, 0.07)
        br = B4XDaisyVariants.Blend(br, xui.Color_Black, 0.07)
    End If

    If mDisabled Then
        Dim faded As Int = ToAlphaColor(baseContent, 51)
        fg = faded
        If B4XDaisyVariants.NormalizeStyle(mStyle) <> "ghost" And B4XDaisyVariants.NormalizeStyle(mStyle) <> "link" Then
            bg = ToAlphaColor(baseContent, 26)
            br = xui.Color_Transparent
        Else
            bg = xui.Color_Transparent
            br = xui.Color_Transparent
        End If
        mBase.Enabled = False
    Else
        mBase.Enabled = True
    End If

    If mBackgroundColor <> xui.Color_Transparent Then bg = mBackgroundColor
    If mTextColor <> xui.Color_Transparent Then fg = mTextColor
    If mBorderColor <> xui.Color_Transparent Then br = mBorderColor

    lblContent.Text = FlattenTextSingleLine(mText)
    lblContent.TextColor = fg
    lblContent.TextSize = ResolveFontSizeDip(mSize)

    Dim l As Label = lblContent
    l.Typeface = Typeface.DEFAULT_BOLD
    l.SingleLine = True
    EnsureContentSingleLine

    If iconComp.IsInitialized Then
        If mIconName.Trim.Length > 0 Then
            Dim preserveIconColors As Boolean = IsTransparentColor(mIconColor)
            iconComp.setSvgAsset(mIconName)
            iconComp.setPreserveOriginalColors(preserveIconColors)
            iconComp.setColor(IIf(preserveIconColors, fg, mIconColor))
            iconComp.setRoundedBox(False)
        End If
    End If
    If loadingComp.IsInitialized Then
        loadingComp.setStyle("spinner")
        loadingComp.setSize(mSize)
        loadingComp.setVariant(IIf(NormalizeVariant(mVariant) = "default", "none", mVariant))
        loadingComp.setVisible(mLoading)
    End If

    Dim radius As Int = ResolveRadiusDip(IIf(mCircle, "rounded-full", mRounded))

    Dim borderW As Int = ResolveBorderDip
    Select Case B4XDaisyVariants.NormalizeStyle(mStyle)
        Case "ghost", "link"
            borderW = 0
        Case Else
            borderW = Max(1dip, borderW)
    End Select
    If mDisabled And (B4XDaisyVariants.NormalizeStyle(mStyle) <> "ghost" And B4XDaisyVariants.NormalizeStyle(mStyle) <> "link") Then
        borderW = 0
    End If

    B4XDaisyVariants.ApplyDashedBorder(mBase, bg, borderW, br, radius, mStyle)
    EnsureShadowVisibility
    B4XDaisyVariants.ApplyElevation(mBase, mShadow)
    mBase.Visible = mVisible
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ResolveVariantBackColor(DefaultColor As Int) As Int
    Dim v As String = NormalizeVariant(mVariant)
    If v = "default" Or v = "none" Then Return DefaultColor
    Return B4XDaisyVariants.ResolveBackgroundColorVariant(v, DefaultColor)
End Sub

Private Sub ResolveVariantTextColor(DefaultColor As Int) As Int
    Dim v As String = NormalizeVariant(mVariant)
    If v = "default" Or v = "none" Then Return DefaultColor
    Return B4XDaisyVariants.ResolveTextColorVariant(v, DefaultColor)
End Sub

Private Sub ResolveOutlineColor(BaseContent As Int, VariantBack As Int) As Int
    Dim v As String = NormalizeVariant(mVariant)
    If v = "default" Or v = "none" Then Return BaseContent
    Return VariantBack
End Sub

Private Sub ToAlphaColor(BaseColor As Int, Alpha As Int) As Int
    Dim a As Int = Max(0, Min(255, Alpha))
    Dim r As Int = Bit.And(Bit.ShiftRight(BaseColor, 16), 0xFF)
    Dim g As Int = Bit.And(Bit.ShiftRight(BaseColor, 8), 0xFF)
    Dim b As Int = Bit.And(BaseColor, 0xFF)
    Return xui.Color_ARGB(a, r, g, b)
End Sub

Private Sub ParseClassTokens(TokensText As String)
    If TokensText = Null Then Return
    Dim raw As String = TokensText.Trim
    If raw.Length = 0 Then Return

    Dim tokens() As String = Regex.Split("\s+", raw)
    For Each tokenRaw As String In tokens
        Dim token As String = tokenRaw.ToLowerCase.Trim
        If token.Length = 0 Then Continue

        Select Case token
            Case "btn", "button"
            Case "btn-neutral", "neutral"
                mVariant = "neutral"
            Case "btn-primary", "primary"
                mVariant = "primary"
            Case "btn-secondary", "secondary"
                mVariant = "secondary"
            Case "btn-accent", "accent"
                mVariant = "accent"
            Case "btn-info", "info"
                mVariant = "info"
            Case "btn-success", "success"
                mVariant = "success"
            Case "btn-warning", "warning"
                mVariant = "warning"
            Case "btn-error", "error"
                mVariant = "error"
            Case "btn-soft", "soft"
                mStyle = "soft"
            Case "btn-outline", "outline"
                mStyle = "outline"
            Case "btn-dash", "dash"
                mStyle = "dash"
            Case "btn-ghost", "ghost"
                mStyle = "ghost"
            Case "btn-link", "link"
                mStyle = "link"
            Case "btn-xs", "xs"
                mSize = "xs"
            Case "btn-sm", "sm"
                mSize = "sm"
            Case "btn-md", "md"
                mSize = "md"
            Case "btn-lg", "lg"
                mSize = "lg"
            Case "btn-xl", "xl"
                mSize = "xl"
            Case "btn-wide", "wide"
                mWide = True
            Case "btn-block", "block"
                mBlock = True
            Case "btn-square", "square"
                mSquare = True
                mCircle = False
            Case "btn-circle", "circle"
                mCircle = True
                mSquare = False
                mRounded = "rounded-full"
            Case "btn-active", "active"
                mActive = True
            Case "btn-disabled", "disabled"
                mDisabled = True
            Case "loading", "loading-spinner"
                mLoading = True
            Case "shadow-none", "shadow-xs", "shadow-sm", "shadow-md", "shadow-lg", "shadow-xl", "shadow-2xl", "shadow"
                mShadow = B4XDaisyVariants.NormalizeShadow(token)
            Case Else
                If token.StartsWith("rounded") Then
                    mRounded = token
                Else If token.StartsWith("shadow-") Then
                    mShadow = B4XDaisyVariants.NormalizeShadow(token)
                Else If token.StartsWith("p-") Or token.StartsWith("px-") Or token.StartsWith("py-") Or token.StartsWith("pt-") Or token.StartsWith("pr-") Or token.StartsWith("pb-") Or token.StartsWith("pl-") Then
                    If mPadding.Length = 0 Then
                        mPadding = token
                    Else
                        mPadding = mPadding & " " & token
                    End If
                Else If token.StartsWith("m-") Or token.StartsWith("mx-") Or token.StartsWith("my-") Or token.StartsWith("mt-") Or token.StartsWith("mr-") Or token.StartsWith("mb-") Or token.StartsWith("ml-") Then
                    If mMargin.Length = 0 Then
                        mMargin = token
                    Else
                        mMargin = mMargin & " " & token
                    End If
                Else If token.StartsWith("bg-") Then
                    mBackgroundColor = B4XDaisyVariants.ResolveBackgroundColorVariant(token, mBackgroundColor)
                Else If token.StartsWith("text-") Then
                    mTextColor = B4XDaisyVariants.ResolveTextColorVariant(token, mTextColor)
                Else If token.StartsWith("border-") Then
                    mBorderColor = B4XDaisyVariants.ResolveBorderColorVariant(token, mBorderColor)
                End If
        End Select
    Next

    mVariant = NormalizeVariant(mVariant)
    mStyle = B4XDaisyVariants.NormalizeStyle(mStyle)
    mSize = B4XDaisyVariants.NormalizeSize(mSize)
End Sub

Private Sub NormalizeVariant(Value As String) As String
    If Value = Null Then Return "default"
    Dim v As String = Value.ToLowerCase.Trim
    v = v.Replace("btn-", "")
    Select Case v
        Case "default", "none", "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
            Return v
        Case Else
            Return "default"
    End Select
End Sub





Private Sub ResolveFontSizeDip(SizeToken As String) As Float
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 11
        Case "sm"
            Return 12
        Case "md"
            Return 14
        Case "lg"
            Return 18
        Case "xl"
            Return 22
        Case Else
            Return 14
    End Select
End Sub

Private Sub ResolveHorizontalPaddingDip(SizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 8dip
        Case "sm"
            Return 12dip
        Case "md"
            Return 16dip
        Case "lg"
            Return 20dip
        Case "xl"
            Return 24dip
        Case Else
            Return 16dip
    End Select
End Sub

Private Sub ResolveButtonHeightDip(SizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(SizeToken)
        Case "xs"
            Return 24dip
        Case "sm"
            Return 32dip
        Case "md"
            Return 40dip
        Case "lg"
            Return 48dip
        Case "xl"
            Return 56dip
        Case Else
            Return 40dip
    End Select
End Sub

Private Sub ResolveBorderDip As Int
    Return Max(0dip, B4XDaisyVariants.GetBorderDip(1dip))
End Sub

Private Sub ResolveRadiusDip(RoundedToken As String) As Int
    Dim s As String = IIf(RoundedToken = Null, "theme", RoundedToken.ToLowerCase.Trim)
    Select Case s
        Case "theme", ""
            Return Max(0dip, B4XDaisyVariants.GetRadiusFieldDip(8dip))
        Case Else
            Return Max(0dip, B4XDaisyVariants.TailwindBorderRadiusToDip(s, B4XDaisyVariants.GetRadiusFieldDip(8dip)))
    End Select
End Sub

Private Sub ResolvePadding As Map
    Dim px As Int = ResolveHorizontalPaddingDip(mSize)
    Dim py As Int = 0dip
    Dim left As Int = px
    Dim top As Int = py
    Dim right As Int = px
    Dim bottom As Int = py

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

Private Sub ResolveMargin As Map
    Dim left As Int = 0dip
    Dim top As Int = 0dip
    Dim right As Int = 0dip
    Dim bottom As Int = 0dip

    If mMargin.Trim.Length > 0 Then
        Dim tokens() As String = Regex.Split("\s+", mMargin.Trim)
        For Each tok As String In tokens
            Dim t As String = tok.ToLowerCase.Trim
            If t.Length = 0 Then Continue
            If t.StartsWith("m-") Then
                Dim v As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(2), 0)
                left = v : right = v : top = v : bottom = v
            Else If t.StartsWith("mx-") Then
                Dim v2 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
                left = v2 : right = v2
            Else If t.StartsWith("my-") Then
                Dim v3 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
                top = v3 : bottom = v3
            Else If t.StartsWith("mt-") Then
                top = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
            Else If t.StartsWith("mr-") Then
                right = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), right)
            Else If t.StartsWith("mb-") Then
                bottom = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), bottom)
            Else If t.StartsWith("ml-") Then
                left = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
            End If
        Next
    End If

    Return CreateMap("l": Max(0dip, left), "t": Max(0dip, top), "r": Max(0dip, right), "b": Max(0dip, bottom))
End Sub

Private Sub EstimateContentWidthDip As Int
    Dim f As B4XFont = xui.CreateDefaultBoldFont(ResolveFontSizeDip(mSize))
    Dim w As Int = MeasureTextWidthDip(mText, f)
    Dim px As Int = ResolveHorizontalPaddingDip(mSize)
    Dim total As Int = w + (px * 2)
    If mLoading Or mIconName.Trim.Length > 0 Then total = total + ResolveIndicatorSizeDip + 6dip
    If mSquare Or mCircle Then Return ResolveButtonHeightDip(mSize)
    If mWide Then total = Max(total, 256dip)
    Return Max(ResolveButtonHeightDip(mSize), total)
End Sub

Private Sub ResolveIndicatorSizeDip As Int
    Select Case B4XDaisyVariants.NormalizeSize(mSize)
        Case "xs"
            Return 12dip
        Case "sm"
            Return 14dip
        Case "md"
            Return 16dip
        Case "lg"
            Return 18dip
        Case "xl"
            Return 20dip
        Case Else
            Return 16dip
    End Select
End Sub

Private Sub ResolveWideWidthDip(PreferredWidth As Int, Left As Int, Parent As B4XView, Margin As Map, MinWidth As Int) As Int
    ' Daisy btn-wide maps to max-w-64 (16rem). Use fixed 16rem width.
    Return Max(MinWidth, 256dip)
End Sub

Private Sub ResolveConfiguredWidthDip(DefaultWidth As Int) As Int
    If IsAutoLayoutSpec(mWidth) Then Return Max(1dip, DefaultWidth)
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mWidth, DefaultWidth))
End Sub

Private Sub ResolveConfiguredHeightDip(DefaultHeight As Int) As Int
    If IsAutoLayoutSpec(mHeight) Then Return Max(1dip, DefaultHeight)
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mHeight, DefaultHeight))
End Sub

Private Sub IsAutoLayoutSpec(Value As String) As Boolean
    Dim s As String = IIf(Value = Null, "", Value.ToLowerCase.Trim)
    Return s = "auto"
End Sub

Private Sub NormalizeLayoutSpec(Value As String, DefaultValue As String) As String
    Dim s As String = IIf(Value = Null, "", Value.Trim)
    If s.Length = 0 Then Return DefaultValue
    Return s
End Sub

Private Sub IsTransparentColor(Value As Int) As Boolean
    Return Bit.And(Bit.ShiftRight(Value, 24), 0xFF) = 0
End Sub

Private Sub MeasureTextWidthDip(Text As String, Font As B4XFont) As Int
    Dim t As String = Text
    If t = Null Or t.Trim.Length = 0 Then Return 16dip
    Dim r As B4XRect = cvsMeasure.MeasureText(t.Trim, Font)
    Return Ceil(r.Width) + 8dip
End Sub

Private Sub FlattenTextSingleLine(Value As String) As String
    Dim s As String = IIf(Value = Null, "", Value)
    s = s.Replace(CRLF, " ")
    s = s.Replace(Chr(10), " ")
    s = s.Replace(Chr(13), " ")
    Return s
End Sub

Private Sub EnsureContentSingleLine
    #If B4A
    Try
        Dim jo As JavaObject = lblContent
        jo.RunMethod("setSingleLine", Array(True))
        jo.RunMethod("setMaxLines", Array(1))
        jo.RunMethod("setHorizontallyScrolling", Array(True))
        Dim truncateAt As JavaObject
        truncateAt.InitializeStatic("android.text.TextUtils$TruncateAt")
        jo.RunMethod("setEllipsize", Array(truncateAt.GetField("END")))
    Catch
    End Try 'ignore
    #End If
End Sub

Private Sub EnsureShadowVisibility
    ' use shared helper in Variants
    B4XDaisyVariants.DisableClippingChain(mBase, 4)
End Sub


Public Sub setText(Value As String)
    mText = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText As String
    Return mText
End Sub

Public Sub setClass(Value As String)
    mClassTokens = IIf(Value = Null, "", Value)
    ParseClassTokens(mClassTokens)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getClass As String
    Return mClassTokens
End Sub

Public Sub setVariant(Value As String)
    mVariant = NormalizeVariant(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return mVariant
End Sub

Public Sub setStyle(Value As String)
    mStyle = B4XDaisyVariants.NormalizeStyle(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getStyle As String
    Return mStyle
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
    mRounded = IIf(Value = Null, "theme", Value)
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
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getMargin As String
    Return mMargin
End Sub

Public Sub setWidth(Value As String)
    mWidth = NormalizeLayoutSpec(Value, "40px")
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As String
    Return mWidth
End Sub

Public Sub setHeight(Value As String)
    mHeight = NormalizeLayoutSpec(Value, "auto")
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As String
    Return mHeight
End Sub

Public Sub setIconName(Value As String)
    mIconName = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getIconName As String
    Return mIconName
End Sub

Public Sub setIconColor(Value As Int)
    mIconColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getIconColor As Int
    Return mIconColor
End Sub

Public Sub setWide(Value As Boolean)
    mWide = Value
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWide As Boolean
    Return mWide
End Sub

Public Sub setBlock(Value As Boolean)
    mBlock = Value
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getBlock As Boolean
    Return mBlock
End Sub

Public Sub setSquare(Value As Boolean)
    mSquare = Value
    If Value Then mCircle = False
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSquare As Boolean
    Return mSquare
End Sub

Public Sub setCircle(Value As Boolean)
    mCircle = Value
    If Value Then
        mSquare = False
        mRounded = "rounded-full"
    End If
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getCircle As Boolean
    Return mCircle
End Sub

Public Sub setActive(Value As Boolean)
    mActive = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActive As Boolean
    Return mActive
End Sub

Public Sub setDisabled(Value As Boolean)
    mDisabled = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getDisabled As Boolean
    Return mDisabled
End Sub

Public Sub setLoading(Value As Boolean)
    mLoading = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getLoading As Boolean
    Return mLoading
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

Public Sub setBorderColor(Value As Int)
    mBorderColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderColor As Int
    Return mBorderColor
End Sub

Public Sub setVisible(Value As Boolean)
    mVisible = Value
    If mBase.IsInitialized = False Then Return
    mBase.Visible = mVisible
End Sub

Public Sub getVisible As Boolean
    Return mVisible
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
    If mDisabled Then Return
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub

