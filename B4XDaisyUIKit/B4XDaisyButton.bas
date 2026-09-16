B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: Button, Description: Button label.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: default, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Semantic color variant.
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost|link, Description: Daisy button style.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Daisy button size token.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius token.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind padding utility tokens (For example: px-3 py-1).
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind margin utility tokens.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: auto, Description: Tailwind/CSS width token (For example: auto, 40px, w-40, [12rem]).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Tailwind/CSS height token (For example: auto, 40px, h-10, [3rem]).
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
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show Or hide component.
#DesignerProperty: Key: TextAlignment, DisplayName: Text Alignment, FieldType: String, DefaultValue: CENTER, List: CENTER|LEFT|RIGHT, Description: Horizontal alignment of button text.
#DesignerProperty: Key: Glass, DisplayName: Glass, FieldType: Boolean, DefaultValue: False, Description: Enable translucent glass background effect.
#DesignerProperty: Key: ButtonSizeDip, DisplayName: Button Size (dip), FieldType: Int, DefaultValue: 0, MinRange: 0, Description: Explicit button extent in dip (circle/square/content height). 0 = auto from Size token.
#DesignerProperty: Key: IconSize, DisplayName: Icon Size (dip), FieldType: Int, DefaultValue: 0, MinRange: 0, Description: Explicit icon size in dip. 0 = auto from Size token.

#IgnoreWarnings:12,9

Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private mGlass As Boolean = False

    Private lblContent As B4XView
    Private iconComp As B4XDaisySvgIcon
    Private iconView As B4XView
    Private loadingComp As B4XDaisyLoading
    Private loadingView As B4XView
    Private pnlMeasure As B4XView
    Private cvsMeasure As B4XCanvas
'    Private mTouchDown As Boolean

    Private mText As String ="Button"
    Private mClassTokens As String ="btn"
    Private mShadow As String ="xs"
    Private mVariant As String ="default"
    Private mStyle As String ="solid"
    Private mSize As String ="md"
    Private mRounded As String ="theme"
    Private mPadding As String =""
    Private mMargin As String =""
    Private mWidth As String ="auto"
    Private mHeight As String ="auto"
    Private mIconName As String =""
    Private mIconColor As Int = xui.Color_Transparent
    ' Explicit overrides (0 = auto/derive from Size token). Used by the FAB and
    ' other containers that need exact dip sizing independent of the Size token.
    Private miButtonExtentDip As Int = 0
    Private miIconSizeDip As Int = 0

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
    Private mTextAlignment As String = "CENTER"
	Private iTextColor As Int
	Private mPressed As Boolean = False
    ' True when DesignerCreateView was called by the B4A layout system (LoadLayout).
    ' False when called via AddToParent (mBase has no parent yet at that point).
    ' ponytail: guards Base_Resize from displacing layout-managed mBase.
    Private mOwnedByLayout As Boolean = False
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
    ' Normalize the base background so designer/drawer colors do not leak through
    ' the custom background (critical for ghost/link styles in LoadLayout).
    mBase.Color = xui.Color_Transparent
    ' Detect whether this call came from LoadLayout (parent already set) or AddToParent.
    mOwnedByLayout = mBase.Parent.IsInitialized

    If lblLbl <> Null Then
        If lblLbl.IsInitialized Then
            If lblLbl.Text.Trim.Length > 0 Then
                mText = lblLbl.Text
            End If
        End If
    End If

    ' Remove the placeholder label so it cannot cover or intercept custom content.
    mBase.RemoveAllViews

    Dim t As Label
    t.Initialize("part")
    lblContent = t
    lblContent.Color = xui.Color_Transparent
    #If B4A
    Try
        Dim joLbl As JavaObject = lblContent
        joLbl.RunMethod("setClickable", Array(False))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.DesignerCreateView: " & LastException.Message)
    End Try
    #End If
    Dim lContent As Label = lblContent
    lContent.SingleLine = True

    EnsureContentSingleLine
    mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)

    Dim icon As B4XDaisySvgIcon
    icon.Initialize(Me,"btnicon")
    iconComp = icon
    iconView = iconComp.AddToParent(mBase, 0, 0, 1dip, 1dip)
    Try
        iconComp.SetClickable(False)
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.DesignerCreateView: " & LastException.Message)
    End Try
    iconView.Visible = False

    Dim ld As B4XDaisyLoading
    ld.Initialize(Me,"btnloading")
    loadingComp = ld
    loadingView = loadingComp.AddToParent(mBase, 0, 0, 1dip, 1dip)
    Try
        loadingComp.SetClickable(False)
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.DesignerCreateView: " & LastException.Message)
    End Try
    loadingView.Visible = False

    Dim p As Panel
    p.Initialize("")
    pnlMeasure = p
    mBase.AddView(pnlMeasure, 0, 0, 120dip, 40dip)
    pnlMeasure.Visible = False
    Try
        cvsMeasure.Initialize(pnlMeasure)
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.DesignerCreateView: " & LastException.Message)
    End Try

    ApplyDesignerProps(mProps)
    ApplyContentGravity

    ParseClassTokens(mClassTokens)
    #If B4A
    If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyButton.DesignerCreateView: owned=${mOwnedByLayout}, size=${mBase.Width}x${mBase.Height}, text=${mText}, variant=${mVariant}, style=${mStyle}"$)
    #End If
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    Dim pText As String = B4XDaisyVariants.GetPropString(mProps,"Text", "")
    If pText.Trim.Length > 0 Then mText = pText
    mClassTokens = B4XDaisyVariants.GetPropString(mProps,"Class", mClassTokens)
    mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps,"Variant", mVariant))
    mStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(mProps,"Style", mStyle))
    mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps,"Size", mSize))
    mRounded = B4XDaisyVariants.GetPropString(mProps,"Rounded", mRounded)
    mPadding = B4XDaisyVariants.GetPropString(mProps,"Padding", mPadding)
    mMargin = B4XDaisyVariants.GetPropString(mProps,"Margin", mMargin)
    mWidth = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(mProps,"Width", mWidth),"40px")
    mHeight = NormalizeLayoutSpec(B4XDaisyVariants.GetPropString(mProps,"Height", mHeight),"auto")
    mIconName = B4XDaisyVariants.GetPropString(mProps,"IconName", mIconName)
    mIconColor = B4XDaisyVariants.GetPropColor(mProps,"IconColor", mIconColor)
    mWide = B4XDaisyVariants.GetPropBool(mProps,"Wide", mWide)
    mBlock = B4XDaisyVariants.GetPropBool(mProps,"Block", mBlock)
    mSquare = B4XDaisyVariants.GetPropBool(mProps,"Square", mSquare)
    mCircle = B4XDaisyVariants.GetPropBool(mProps,"Circle", mCircle)
    mActive = B4XDaisyVariants.GetPropBool(mProps,"Active", mActive)
    mDisabled = B4XDaisyVariants.GetPropBool(mProps,"Disabled", mDisabled)
    mLoading = B4XDaisyVariants.GetPropBool(mProps,"Loading", mLoading)
    mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps,"BackgroundColor", mBackgroundColor)
    mTextColor = B4XDaisyVariants.GetPropColor(mProps,"TextColor", mTextColor)
    mBorderColor = B4XDaisyVariants.GetPropColor(mProps,"BorderColor", mBorderColor)
    mVisible = B4XDaisyVariants.GetPropBool(mProps,"Visible", mVisible)
    mGlass = B4XDaisyVariants.GetPropBool(mProps,"Glass", mGlass)
    mTextAlignment = B4XDaisyVariants.GetPropString(mProps,"TextAlignment", mTextAlignment)
    miButtonExtentDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "ButtonSizeDip", miButtonExtentDip))
    miIconSizeDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "IconSize", miIconSizeDip))
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    Dim props As Map = BuildRuntimeProps
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    Dim empty As B4XView
    If vParent.IsInitialized = False Then Return empty

    Dim mg As Map = ResolveMargin
    iLeft = iLeft + mg.Get("l")
    iTop = iTop + mg.Get("t")
    iWidth = iWidth - mg.Get("l") - mg.Get("r")
    iHeight = iHeight - mg.Get("t") - mg.Get("b")

    Dim controlSize As Int = ResolveButtonHeightDip(mSize)
    If iWidth <= 0 Then iWidth = ResolveConfiguredWidthDip(controlSize)
    If mBlock = False Then iWidth = Max(iWidth, EstimateContentWidthDip)
    If iHeight <= 0 Then iHeight = ResolveConfiguredHeightDip(controlSize)
    If mBlock Then
        Dim available As Int = vParent.Width - iLeft - mg.Get("r")
        If available > controlSize Then
            iWidth = Max(iWidth, available)
        Else
            iWidth = Max(iWidth, EstimateContentWidthDip)
        End If
    Else If mWide Then
        iWidth = ResolveWideWidthDip(Max(iWidth, EstimateContentWidthDip), iLeft, vParent, mg, controlSize)
    End If

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If

    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
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
    "Visible": mVisible, _
    "Glass": mGlass, _
    "TextAlignment": mTextAlignment, _
    "ButtonSizeDip": miButtonExtentDip, _
    "IconSize": miIconSizeDip)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return

    #If B4A
    If inResize Then Return
    inResize = True
    If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyButton.Base_Resize: in=${dWidth}x${dHeight}, owned=${mOwnedByLayout}, mBase=${mBase.Width}x${mBase.Height}"$)
    #End If

    Dim hasText As Boolean = (mText.Trim.Length > 0)
    Dim hasIcon As Boolean = (mIconName.Trim.Length > 0)
    Dim reqW As Int = EstimateContentWidthDip
    Dim controlSize As Int = ResolveButtonHeightDip(mSize)
    Dim targetW As Int = Max(1dip, dWidth)
    Dim targetH As Int = Max(1dip, dHeight)

    Dim isIconOnly As Boolean = (mSquare Or mCircle Or (hasText = False And (hasIcon Or mLoading)))

    If isIconOnly Then
        ' Square / Circle / Icon-only buttons MUST be 1:1 square/circle.
        Dim side As Int = controlSize
        targetW = side
        targetH = side
        ' Set mBase width/height to 1:1 without altering Left/Top
        If mBase.Width <> targetW Or mBase.Height <> targetH Then
            mBase.Width = targetW
            mBase.Height = targetH
            dWidth = targetW
            dHeight = targetH
        End If
    Else If mOwnedByLayout = False Then
        ' Programmatic text button: auto-expand mBase when content needs more space.
        If IsAutoLayoutSpec(mWidth) Then
            targetW = Max(targetW, reqW)
        Else If mBlock And mBase.Parent.IsInitialized Then
            Dim mg As Map = ResolveMargin
            Dim available As Int = mBase.Parent.Width - mBase.Left - mg.Get("r")
            If available > controlSize Then
                targetW = Max(targetW, available)
            Else
                targetW = Max(targetW, reqW)
            End If
        Else If mWide Then
            targetW = ResolveWideWidthDip(reqW, mBase.Left, mBase.Parent, ResolveMargin, controlSize)
        End If
        If targetW <> dWidth Or targetH <> dHeight Then
            Try
                mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
                mBase.Width = targetW
                mBase.Height = targetH
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.Base_Resize: " & LastException.Message)
            End Try
            dWidth = targetW
            dHeight = targetH
        End If
    Else
        ' ponytail: Layout-owned text button - enforce minimum viable size from
        ' the Size token so LoadLayout buttons are never invisible. Only adjusts
        ' Width/Height (not Left/Top) to respect designer-managed position.
        Dim minH As Int = controlSize
        If targetH < minH Then
            targetH = minH
            If mBase.Height <> targetH Then mBase.Height = targetH
            dHeight = targetH
        End If
        If targetW < reqW Then
            targetW = reqW
            If mBase.Width <> targetW Then mBase.Width = targetW
            dWidth = targetW
        End If
    End If

    Dim p As Map = ResolvePadding
    Dim l As Int = p.Get("l")
    Dim t As Int = p.Get("t")
    Dim r As Int = p.Get("r")
    Dim b As Int = p.Get("b")

    Dim contentW As Int = Max(1dip, targetW - l - r)
    Dim contentH As Int = Max(1dip, targetH - t - b)

    Dim indicatorW As Int = Max(12dip, ResolveIndicatorSizeDip)
    Dim gap As Int = 6dip

    lblContent.Visible = hasText

    If mLoading Then
        loadingView.Visible = True
        iconView.Visible = False
        If hasText = False Then
            ' Icon-only: fill the full content area so no empty space shows.
            Dim spinW As Int = Min(contentW, contentH)
            loadingView.SetLayoutAnimated(0, l + (contentW - spinW) / 2, t + (contentH - spinW) / 2, spinW, spinW)
            lblContent.SetLayoutAnimated(0, l, t, contentW, contentH)
        Else
            Dim tw As Int = MeasureTextWidthDip(mText, xui.CreateDefaultBoldFont(lblContent.TextSize))
            Dim totalW As Int = indicatorW + gap + tw
            Dim startX As Int
            Dim alignLoad As String = mTextAlignment.ToUpperCase
            If alignLoad = "LEFT" Then
                startX = l
            Else If alignLoad = "RIGHT" Then
                startX = l + Max(0dip, contentW - totalW)
            Else
                startX = l + Max(0dip, (contentW - totalW) / 2)
            End If
            loadingView.SetLayoutAnimated(0, startX, t + (contentH - indicatorW) / 2, indicatorW, indicatorW)
            lblContent.SetLayoutAnimated(0, startX + indicatorW + gap, t, Max(1dip, tw), contentH)
        End If
        If loadingComp.IsInitialized Then loadingComp.Base_Resize(loadingView.Width, loadingView.Height)
        iconView.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
    Else If hasIcon Then
        loadingView.Visible = False
        iconView.Visible = True
        If hasText = False Then
            ' Icon-only: respect configured icon size (indicatorW), capped at available content bounds.
            Dim iconSz As Int = Min(indicatorW, Min(contentW, contentH))
            iconView.SetLayoutAnimated(0, l + (contentW - iconSz) / 2, t + (contentH - iconSz) / 2, iconSz, iconSz)
            lblContent.SetLayoutAnimated(0, l, t, contentW, contentH)
        Else
            Dim tw2 As Int = MeasureTextWidthDip(mText, xui.CreateDefaultBoldFont(lblContent.TextSize))
            Dim totalW2 As Int = indicatorW + gap + tw2
            Dim startX2 As Int
            Dim alignIcon As String = mTextAlignment.ToUpperCase
            If alignIcon = "LEFT" Then
                startX2 = l
            Else If alignIcon = "RIGHT" Then
                startX2 = l + Max(0dip, contentW - totalW2)
            Else
                startX2 = l + Max(0dip, (contentW - totalW2) / 2)
            End If
            iconView.SetLayoutAnimated(0, startX2, t + (contentH - indicatorW) / 2, indicatorW, indicatorW)
            lblContent.SetLayoutAnimated(0, startX2 + indicatorW + gap, t, Max(1dip, tw2), contentH)
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
    ' Fix shadow outline for buttons inside initially-hidden containers.
    ' GradientDrawable.getBounds() stays at 0,0,0,0 until drawBackground runs.
    ' Setting bounds here ensures a correct rounded-rect shadow on first draw.
    #If B4A
        If mBase.Width > 0 And mBase.Height > 0 Then
            Try
                Dim joMB As JavaObject = mBase
                Dim bgDraw As JavaObject = joMB.RunMethod("getBackground", Null)
                If bgDraw.IsInitialized Then
                    bgDraw.RunMethod("setBounds", Array(0, 0, mBase.Width, mBase.Height))
                    joMB.RunMethod("invalidateOutline", Null)
                End If
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.Base_Resize: " & LastException.Message)
            End Try
        End If
    #End If
    inResize = False
End Sub


Public Sub Refresh
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
            If NormalizeVariant(mVariant) ="default" Or NormalizeVariant(mVariant) ="none" Then
                fg = baseContent
            Else
                fg = variantBack
            End If
        Case "outline","dash"
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
            If NormalizeVariant(mVariant) ="default" Or NormalizeVariant(mVariant) ="none" Then
                fg = primaryBack
            Else
                fg = variantBack
            End If
        Case Else
            'solid default
    End Select

    If NormalizeVariant(mVariant) ="warning" And B4XDaisyVariants.NormalizeStyle(mStyle) ="solid" Then
        fg = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
    End If

    If mActive And bg <> xui.Color_Transparent Then
        bg = B4XDaisyVariants.Blend(bg, xui.Color_Black, 0.07)
        br = B4XDaisyVariants.Blend(br, xui.Color_Black, 0.07)
    End If

    If mDisabled Then
        Dim faded As Int = ToAlphaColor(baseContent, 51)
        fg = faded
        If B4XDaisyVariants.NormalizeStyle(mStyle) <>"ghost" And B4XDaisyVariants.NormalizeStyle(mStyle) <>"link" Then
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
	iTextColor = fg

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
        loadingComp.setColor(fg)
        loadingComp.setVisible(mLoading)
    End If

    Dim radius As Int = ResolveRadiusDip(IIf(mCircle,"rounded-full", mRounded))

    Dim borderW As Int = ResolveBorderDip
    Select Case B4XDaisyVariants.NormalizeStyle(mStyle)
        Case "ghost","link"
            If mBorderColor <> xui.Color_Transparent Then
                borderW = Max(1dip, borderW)  ' Honor explicit border color even on ghost/link
            Else
                borderW = 0
            End If
        Case Else
            borderW = Max(1dip, borderW)
    End Select
    If mDisabled And (B4XDaisyVariants.NormalizeStyle(mStyle) <>"ghost" And B4XDaisyVariants.NormalizeStyle(mStyle) <>"link") Then
        borderW = 0
    End If

    If mGlass Then
        B4XDaisyVariants.ApplyGlassStyle(mBase, radius, "glass-md")
    Else
        B4XDaisyVariants.ApplyDashedBorder(mBase, bg, borderW, br, radius, mStyle)
    End If
    EnsureShadowVisibility
    If mActive Then
        B4XDaisyVariants.ApplyElevation(mBase,"none")
    Else
        B4XDaisyVariants.ApplyElevation(mBase, mShadow)
    End If
    mBase.Visible = mVisible
    #If B4A
    If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyButton.Refresh: bg=${bg}, fg=${fg}, br=${br}, borderW=${borderW}, radius=${radius}, style=${mStyle}, variant=${mVariant}, baseW=${mBase.Width}, baseH=${mBase.Height}, visible=${mBase.Visible}"$)
    #End If
    If inResize = False Then
        Base_Resize(mBase.Width, mBase.Height)
    End If
End Sub

Public Sub setGlass(bValue As Boolean)
    mGlass = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getGlass As Boolean
    Return mGlass
End Sub

Private Sub ResolveVariantBackColor(iDefaultColor As Int) As Int
    Dim v As String = NormalizeVariant(mVariant)
    If v ="default" Or v ="none" Then Return iDefaultColor
        Return B4XDaisyVariants.ResolveBackgroundColorVariant(v, iDefaultColor)
    End Sub

    Private Sub ResolveVariantTextColor(iDefaultColor As Int) As Int
        Dim v As String = NormalizeVariant(mVariant)
        If v ="default" Or v ="none" Then Return iDefaultColor
            Return B4XDaisyVariants.ResolveTextColorVariant(v, iDefaultColor)
        End Sub

        Private Sub ResolveOutlineColor(iBaseContent As Int, iVariantBack As Int) As Int
            Dim v As String = NormalizeVariant(mVariant)
            If v ="default" Or v ="none" Then Return iBaseContent
                Return iVariantBack
            End Sub

            Private Sub ToAlphaColor(iBaseColor As Int, iAlpha As Int) As Int
                Dim a As Int = Max(0, Min(255, iAlpha))
                Dim r As Int = Bit.And(Bit.ShiftRight(iBaseColor, 16), 0xFF)
                Dim g As Int = Bit.And(Bit.ShiftRight(iBaseColor, 8), 0xFF)
                Dim b As Int = Bit.And(iBaseColor, 0xFF)
                Return xui.Color_ARGB(a, r, g, b)
            End Sub

            Private Sub ParseClassTokens(sTokensText As String)
                If sTokensText = Null Then Return
                Dim raw As String = sTokensText.Trim
                If raw.Length = 0 Then Return

                Dim tokens() As String = Regex.Split("\s+", raw)
                For Each tokenRaw As String In tokens
                    Dim token As String = tokenRaw.ToLowerCase.Trim
                    If token.Length = 0 Then Continue

                    Select Case token
                        Case "btn","button"
                        Case "btn-neutral","neutral"
                            mVariant ="neutral"
                        Case "btn-primary","primary"
                            mVariant ="primary"
                        Case "btn-secondary","secondary"
                            mVariant ="secondary"
                        Case "btn-accent","accent"
                            mVariant ="accent"
                        Case "btn-info","info"
                            mVariant ="info"
                        Case "btn-success","success"
                            mVariant ="success"
                        Case "btn-warning","warning"
                            mVariant ="warning"
                        Case "btn-error","error"
                            mVariant ="error"
                        Case "btn-soft","soft"
                            mStyle ="soft"
                        Case "btn-outline","outline"
                            mStyle ="outline"
                        Case "btn-dash","dash"
                            mStyle ="dash"
                        Case "btn-ghost","ghost"
                            mStyle ="ghost"
                        Case "btn-link","link"
                            mStyle ="link"
                        Case "btn-xs","xs"
                            mSize ="xs"
                        Case "btn-sm","sm"
                            mSize ="sm"
                        Case "btn-md","md"
                            mSize ="md"
                        Case "btn-lg","lg"
                            mSize ="lg"
                        Case "btn-xl","xl"
                            mSize ="xl"
                        Case "btn-wide","wide"
                            mWide = True
                        Case "btn-block","block"
                            mBlock = True
                        Case "btn-square","square"
                            mSquare = True
                            mCircle = False
                        Case "btn-circle","circle"
                            mCircle = True
                            mSquare = False
                            mRounded ="rounded-full"
                        Case "btn-active","active"
                            mActive = True
                        Case "btn-disabled","disabled"
                            mDisabled = True
                        Case "loading","loading-spinner"
                            mLoading = True
                        Case "shadow-none","shadow-xs","shadow-sm","shadow-md","shadow-lg","shadow-xl","shadow-2xl","shadow"
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
                                    mPadding = mPadding &" " & token
                                End If
                            Else If token.StartsWith("m-") Or token.StartsWith("mx-") Or token.StartsWith("my-") Or token.StartsWith("mt-") Or token.StartsWith("mr-") Or token.StartsWith("mb-") Or token.StartsWith("ml-") Then
                                If mMargin.Length = 0 Then
                                    mMargin = token
                                Else
                                    mMargin = mMargin &" " & token
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

            Private Sub NormalizeVariant(sValue As String) As String
                If sValue = Null Then Return "default"
                Dim v As String = sValue.ToLowerCase.Trim
                v = v.Replace("btn-","")
                Select Case v
                    Case "default","none","neutral","primary","secondary","accent","info","success","warning","error"
                        Return v
                    Case Else
                        Return "default"
                End Select
            End Sub

            Private Sub ResolveFontSizeDip(sSizeToken As String) As Float
                Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
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

            Private Sub ResolveHorizontalPaddingDip(sSizeToken As String) As Int
                Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
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

            Private Sub ResolveButtonHeightDip(sSizeToken As String) As Int
                If miButtonExtentDip > 0 Then Return miButtonExtentDip
                Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
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

            Private Sub ResolveRadiusDip(sRoundedToken As String) As Int
                Dim s As String = IIf(sRoundedToken = Null,"theme", sRoundedToken.ToLowerCase.Trim)
                Select Case s
                    Case "theme",""
                        Return Max(0dip, B4XDaisyVariants.GetRadiusFieldDip(8dip))
                    Case Else
                        Return Max(0dip, B4XDaisyVariants.TailwindBorderRadiusToDip(s, B4XDaisyVariants.GetRadiusFieldDip(8dip)))
                End Select
            End Sub

            Private Sub ResolvePadding As Map
                Dim px As Int = ResolveHorizontalPaddingDip(mSize)
                Dim py As Int = 0dip
                
                ' Reduce horizontal padding for square/circle buttons to ensure text fits
                If mSquare Or mCircle Then
                    Select Case B4XDaisyVariants.NormalizeSize(mSize)
                        Case "xs"
                            px = 4dip
                        Case "sm"
                            px = 6dip
                        Case "md"
                            px = 8dip
                        Case "lg"
                            px = 10dip
                        Case "xl"
                            px = 12dip
                        Case Else
                            px = 8dip
                    End Select
                End If
                
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
                            left = v: right = v: top = v: bottom = v
                        Else If t.StartsWith("px-") Then
                            Dim v2 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
                            left = v2: right = v2
                        Else If t.StartsWith("py-") Then
                            Dim v3 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
                            top = v3: bottom = v3
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

                Return CreateMap("l": Max(0dip, left),"t": Max(0dip, top),"r": Max(0dip, right),"b": Max(0dip, bottom))
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
                            left = v: right = v: top = v: bottom = v
                        Else If t.StartsWith("mx-") Then
                            Dim v2 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), left)
                            left = v2: right = v2
                        Else If t.StartsWith("my-") Then
                            Dim v3 As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), top)
                            top = v3: bottom = v3
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

                Return CreateMap("l": Max(0dip, left),"t": Max(0dip, top),"r": Max(0dip, right),"b": Max(0dip, bottom))
            End Sub

            Public Sub GetEstimateContentWidth As Int
                Return EstimateContentWidthDip
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
                If miIconSizeDip > 0 Then Return miIconSizeDip
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

            Private Sub ResolveWideWidthDip(iPreferredWidth As Int, iLeft As Int, vParent As B4XView, mapMargin As Map, iMinWidth As Int) As Int
                'Daisy btn-wide maps to fixed 16rem (256dip) width.
                Dim wideW As Int = 256dip
                If vParent.IsInitialized Then
                    Dim mg As Map = mapMargin
                    Dim avail As Int = vParent.Width - iLeft - mg.Get("r")
                    If avail > 0 And wideW > avail Then wideW = avail
                End If
                Return Max(wideW, iPreferredWidth)
            End Sub

            Private Sub ResolveConfiguredWidthDip(iDefaultWidth As Int) As Int
                If IsAutoLayoutSpec(mWidth) Then Return Max(1dip, iDefaultWidth)
                Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mWidth, iDefaultWidth))
            End Sub

            Private Sub ResolveConfiguredHeightDip(iDefaultHeight As Int) As Int
                If IsAutoLayoutSpec(mHeight) Then Return Max(1dip, iDefaultHeight)
                Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mHeight, iDefaultHeight))
            End Sub

            Private Sub IsAutoLayoutSpec(sValue As String) As Boolean
                Dim s As String = IIf(sValue = Null,"", sValue.ToLowerCase.Trim)
                Return s ="auto"
            End Sub

            Private Sub NormalizeLayoutSpec(sValue As String, sDefaultValue As String) As String
                Dim s As String = IIf(sValue = Null,"", sValue.Trim)
                If s.Length = 0 Then Return sDefaultValue
                Return s
            End Sub

            Private Sub IsTransparentColor(iValue As Int) As Boolean
                Return Bit.And(Bit.ShiftRight(iValue, 24), 0xFF) = 0
            End Sub

            Private Sub MeasureTextWidthDip(sText As String, fntFont As B4XFont) As Int
                Dim t As String = sText
                If t = Null Or t.Trim.Length = 0 Then Return 16dip
                If pnlMeasure.IsInitialized = False Then
                    Return Max(16dip, Ceil(t.Trim.Length * fntFont.Size * 0.62) + 2dip)
                End If
                Dim r As B4XRect = cvsMeasure.MeasureText(t.Trim, fntFont)
                Return Ceil(r.Width) + 8dip
            End Sub

            Private Sub FlattenTextSingleLine(sValue As String) As String
                Dim s As String = IIf(sValue = Null,"", sValue)
                s = s.Replace(CRLF," ")
                s = s.Replace(Chr(10)," ")
                s = s.Replace(Chr(13)," ")
                Return s
            End Sub

            Private Sub EnsureContentSingleLine
                #If B4A
                    Try
                        Dim jo As JavaObject = lblContent
                        jo.RunMethod("setSingleLine", Array(True))
                        jo.RunMethod("setMaxLines", Array(1))
                        jo.RunMethod("setHorizontallyScrolling", Array(True))
                        jo.RunMethod("setFocusable", Array(False))
                        jo.RunMethod("setFocusableInTouchMode", Array(False))
                        jo.RunMethod("setEllipsize", Array(Null))
                    Catch
                    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.EnsureContentSingleLine: " & LastException.Message)
                    End Try  'ignore
                #End If
            End Sub

            Private Sub EnsureShadowVisibility
                'use shared helper in Variants
                B4XDaisyVariants.DisableClippingChain(mBase, 4)
            End Sub

            Public Sub setText(sValue As String)
                mText = IIf(sValue = Null,"", sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getText As String
                Return mText
            End Sub

            Public Sub setClass(sValue As String)
                mClassTokens = IIf(sValue = Null,"", sValue)
                ParseClassTokens(mClassTokens)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getClass As String
                Return mClassTokens
            End Sub

            Public Sub setVariant(sValue As String)
                mVariant = NormalizeVariant(sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getVariant As String
                Return mVariant
            End Sub

            Public Sub setStyle(sValue As String)
                mStyle = B4XDaisyVariants.NormalizeStyle(sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getStyle As String
                Return mStyle
            End Sub

            Public Sub setSize(sValue As String)
                mSize = B4XDaisyVariants.NormalizeSize(sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getSize As String
                Return mSize
            End Sub

            ' Explicit button extent (circle/square/content height) in dip.
            ' 0 = auto from the Size token. Lets containers like the FAB force an
            ' exact button size that the token scale cannot reach.
            Public Sub setButtonSizeDip(iValue As Int)
                miButtonExtentDip = Max(0, iValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getButtonSizeDip As Int
                Return miButtonExtentDip
            End Sub

            ' Explicit icon size in dip. 0 = auto from the Size token.
            Public Sub setIconSize(iValue As Int)
                miIconSizeDip = Max(0, iValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getIconSize As Int
                Return miIconSizeDip
            End Sub

            Public Sub setRounded(sValue As String)
                mRounded = IIf(sValue = Null,"theme", sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getRounded As String
                Return mRounded
            End Sub

            Public Sub setPadding(sValue As String)
                mPadding = IIf(sValue = Null,"", sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getPadding As String
                Return mPadding
            End Sub

            Public Sub setMargin(sValue As String)
                mMargin = IIf(sValue = Null,"", sValue)
                If mBase.IsInitialized = False Then Return
                Base_Resize(mBase.Width, mBase.Height)
            End Sub

            Public Sub getMargin As String
                Return mMargin
            End Sub

            ' Shadow / elevation level applied to the button (idle state).
            ' Accepted: "none","xs","sm","md","lg","xl","2xl" (also "shadow-*").
            ' Default is "xs". Set to "none" to remove the elevation.
            Public Sub setShadow(sValue As String)
                mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getShadow As String
                Return mShadow
            End Sub

            Public Sub setWidth(sValue As String)
                mWidth = NormalizeLayoutSpec(sValue,"40px")
                If mBase.IsInitialized = False Then Return
                Base_Resize(mBase.Width, mBase.Height)
            End Sub

            Public Sub getWidth As String
                Return mWidth
            End Sub

            Public Sub setHeight(sValue As String)
                mHeight = NormalizeLayoutSpec(sValue,"auto")
                If mBase.IsInitialized = False Then Return
                Base_Resize(mBase.Width, mBase.Height)
            End Sub

            Public Sub getHeight As String
                Return mHeight
            End Sub

            Public Sub setIconName(sValue As String)
                mIconName = IIf(sValue = Null,"", sValue)
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getIconName As String
                Return mIconName
            End Sub

            Public Sub setIconColor(iValue As Int)
                mIconColor = iValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getIconColor As Int
                Return mIconColor
            End Sub

            Public Sub setWide(bValue As Boolean)
                mWide = bValue
                If mBase.IsInitialized = False Then Return
                Base_Resize(mBase.Width, mBase.Height)
            End Sub

            Public Sub getWide As Boolean
                Return mWide
            End Sub

            Public Sub setBlock(bValue As Boolean)
                mBlock = bValue
                If mBase.IsInitialized = False Then Return
                Base_Resize(mBase.Width, mBase.Height)
            End Sub

            Public Sub getBlock As Boolean
                Return mBlock
            End Sub

            Public Sub setSquare(bValue As Boolean)
                mSquare = bValue
                If bValue Then mCircle = False
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getSquare As Boolean
                Return mSquare
            End Sub

            Public Sub setCircle(bValue As Boolean)
                mCircle = bValue
                If bValue Then
                    mSquare = False
                    mRounded ="rounded-full"
                End If
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getCircle As Boolean
                Return mCircle
            End Sub

            Public Sub setActive(bValue As Boolean)
                mActive = bValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getActive As Boolean
                Return mActive
            End Sub

            Public Sub setDisabled(bValue As Boolean)
                mDisabled = bValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getDisabled As Boolean
                Return mDisabled
            End Sub

            Public Sub setEnabled(bValue As Boolean)
                setDisabled(Not(bValue))
            End Sub

            Public Sub getEnabled As Boolean
                Return Not(getDisabled)
            End Sub

            Public Sub setLoading(bValue As Boolean)
                mLoading = bValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getLoading As Boolean
                Return mLoading
            End Sub

            Public Sub setBackgroundColor(iValue As Int)
                mBackgroundColor = iValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getBackgroundColor As Int
                Return mBackgroundColor
            End Sub

            Public Sub setTextColor(iValue As Int)
                mTextColor = iValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getTextColor As Int
                Return mTextColor
            End Sub

            Public Sub setBorderColor(iValue As Int)
                mBorderColor = iValue
                If mBase.IsInitialized = False Then Return
                Refresh
            End Sub

            Public Sub getBorderColor As Int
                Return mBorderColor
            End Sub

            Public Sub setVisible(bValue As Boolean)
                mVisible = bValue
                If mBase.IsInitialized = False Then Return
                mBase.Visible = mVisible
            End Sub

            Public Sub getVisible As Boolean
                Return mVisible
            End Sub

            Public Sub setTextAlignment(sValue As String)
                mTextAlignment = IIf(sValue = Null, "CENTER", sValue.ToUpperCase)
                If mBase.IsInitialized = False Then Return
                ApplyContentGravity
                Refresh
            End Sub

            Public Sub getTextAlignment As String
                Return mTextAlignment
            End Sub

            ' Applies the content label gravity so text is vertically centered on Android
            ' for any horizontal alignment (LEFT/CENTER/RIGHT). Always ORs in
            ' Gravity.CENTER_VERTICAL (0x00000010) on B4A because B4XView.SetTextAlignment
            ' does not reliably produce CENTER_VERTICAL on a native Android TextView.
            Private Sub ApplyContentGravity
                If lblContent.IsInitialized = False Then Return
                Dim align As String = mTextAlignment.ToUpperCase
                #If B4A
                    Dim jo As JavaObject = lblContent
                    Dim horiz As Int
                    Select Case align
                        Case "LEFT"
                            horiz = 0x00000003   ' Gravity.LEFT
                        Case "RIGHT"
                            horiz = 0x00000005   ' Gravity.RIGHT
                        Case Else
                            horiz = 0x00000001   ' Gravity.CENTER_HORIZONTAL
                    End Select
                    jo.RunMethod("setGravity", Array(Bit.Or(horiz, 0x00000010))) ' | Gravity.CENTER_VERTICAL
                #Else
                    lblContent.SetTextAlignment(align, "CENTER")
                #End If
            End Sub

            Public Sub setTag(oValue As Object)
                mTag = oValue
            End Sub

            Public Sub getTag As Object
                Return mTag
            End Sub

            Public Sub View As B4XView
            	Dim empty As B4XView
            	If mBase.IsInitialized = False Then Return empty
            	Return mBase
            End Sub
Public Sub GetComputedHeight As Int
                If mBase.IsInitialized = False Then Return 0
                Return mBase.Height
            End Sub

            Public Sub RemoveViewFromParent
                If mBase.IsInitialized Then mBase.RemoveViewFromParent
            End Sub
            ''' <summary>
            ''' Requests or clears keyboard/touch focus on the button.
            ''' B4XDaisyButton is a Panel-based custom view which is not focusable by default,
            ''' so the base view is made focusable (and focusable-in-touch-mode) before focus
            ''' is requested. Pass False to clear focus.
            ''' </summary>
            Public Sub setFocus(bValue As Boolean)
                If mBase.IsInitialized = False Then Return
                #If B4A
                    Dim jo As JavaObject = mBase
                    If bValue Then
                        jo.RunMethod("setFocusable", Array(True))
                        jo.RunMethod("setFocusableInTouchMode", Array(True))
                        jo.RunMethod("requestFocus", Null)
                    Else
                        jo.RunMethod("clearFocus", Null)
                    End If
                #End If
            End Sub

            ''' <summary>
            ''' Returns True if the button currently has focus.
            ''' </summary>
            Public Sub getIsFocused As Boolean
                If mBase.IsInitialized = False Then Return False
                #If B4A
                    Dim jo As JavaObject = mBase
                    Return jo.RunMethod("hasFocus", Null)
                #Else
                    Return False
                #End If
            End Sub

            ''' <summary>
            ''' Convenience method that requests focus on the button (equivalent to setFocus(True)).
            ''' </summary>
            Public Sub RequestFocus
                setFocus(True)
            End Sub


            Private Sub RaiseClick
                If mDisabled Then
                    Return
                End If
                Dim payload As Object = mTag
        		Dim args As List
                args.Initialize
                If payload = Null Then
				Else
				 args.Add(payload)
				End If
                B4XDaisyVariants.RaiseEventIfSubExists(mCallBack, mEventName & "_Click", args)
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region

Private Sub TriggerButtonRipple(fX As Float, fY As Float)
	If mDisabled Then Return
	Dim RippleDuration As Int = 300
	Dim RippleColor As Int = ToAlphaColor(iTextColor, 64)
	Dim radius As Int = ResolveRadiusDip(IIf(mCircle,"rounded-full", mRounded))
	B4XDaisyVariants.CreateRipple(mBase, fX, fY, RippleColor, RippleDuration, radius)
'	Sleep(RippleDuration)
End Sub

'this traps click events
Private Sub mBase_Touch (iAction As Int, fX As Float, fY As Float)
	Select iAction
	Case mBase.TOUCH_ACTION_DOWN
		mPressed = True
		TriggerButtonRipple(fX, fY)
	Case mBase.TOUCH_ACTION_MOVE
		If fX < 0 Or fX > mBase.Width Or fY < 0 Or fY > mBase.Height Then
			mPressed = False ' finger dragged off the button, cancel
		End If
	Case mBase.TOUCH_ACTION_UP
		If mPressed Then RaiseClick
		mPressed = False
	End Select
End Sub


Public Sub Release
    If loadingComp.IsInitialized Then loadingComp.StopAnimation
    If iconComp.IsInitialized Then iconComp.RemoveViewFromParent
    If loadingComp.IsInitialized Then loadingComp.RemoveViewFromParent
    Try
        cvsMeasure.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyButton.Release: " & LastException.Message)
    End Try
    If lblContent.IsInitialized Then lblContent.RemoveViewFromParent
    mCallBack = Null
End Sub
