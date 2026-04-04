B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind size token or CSS size (eg w-12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto, Description: Tailwind size token or CSS size (eg h-6, 24px, 1.5rem).
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Label text.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Text color.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, Description: Number in dip or Tailwind token (eg 12, text-sm, text-lg).
#DesignerProperty: Key: FontBold, DisplayName: Font Bold, FieldType: Boolean, DefaultValue: False, Description: Use bold font.
#DesignerProperty: Key: SingleLine, DisplayName: Single Line, FieldType: Boolean, DefaultValue: False, Description: Single line text.
#DesignerProperty: Key: Ellipsize, DisplayName: Ellipsize, FieldType: String, DefaultValue: none, List: none|start|middle|end|marquee, Description: Truncate with ellipsis when text overflows. Requires Single Line for start/middle/end.
#DesignerProperty: Key: HAlign, DisplayName: Horizontal Align, FieldType: String, DefaultValue: LEFT, List: LEFT|CENTER|RIGHT, Description: Text horizontal alignment.
#DesignerProperty: Key: VAlign, DisplayName: Vertical Align, FieldType: String, DefaultValue: CENTER, List: TOP|CENTER|BOTTOM, Description: Text vertical alignment.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in dip.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Use rounded-box radius.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Border width in dip.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: IsSkeleton, DisplayName: Is Skeleton, FieldType: Boolean, DefaultValue: False, Description: Show skeleton loading state.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize height to fit text content using CSS line-height calculation (line_height_px * num_lines).
#DesignerProperty: Key: Link, DisplayName: Link, FieldType: Boolean, DefaultValue: False, Description: Render as a clickable link (applies underline styling).
#DesignerProperty: Key: Underline, DisplayName: Underline, FieldType: Boolean, DefaultValue: False, Description: Show underline when Link is enabled.
#DesignerProperty: Key: Url, DisplayName: URL, FieldType: String, DefaultValue: , Description: URL to open when the link is clicked (requires Link = true).

#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Private tu As StringUtils
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Private mWidth As Float = 40dip
	Private mHeight As Float = 24dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	
	Private mText As String = ""
	Private mTextColor As Int = 0xFF000000
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mBorderColor As Int = xui.Color_Transparent
	Private mTextColorOverride As Int = 0
	Private mBackgroundColorOverride As Int = 0
	Private mBorderColorOverride As Int = 0

	Private mTextSize As Float = 14dip 'resolved from text-sm
	Private mTextSizeSpec As Object = "text-sm"
	Private mFontBold As Boolean = False
	Private mSingleLine As Boolean = False
	Private msEllipsize As String = "none"
	Private mHAlign As String = "LEFT"
	Private mVAlign As String = "CENTER"
	Private mPadding As Float = 0dip
	Private mMargin As String = ""
	Private mRoundedBox As Boolean = False
	Private mBorderWidth As Float = 0dip
	
	Private mVisible As Boolean = True
	Private mEnabled As Boolean = True
	Private lblContent As B4XView

	'Skeleton Support
	Private mIsSkeleton As Boolean = False
	Private mVariant As String = "none"
	Private mbAutoResize As Boolean = True
	Private mbIsLink As Boolean = False
	Private mbUnderline As Boolean = False
	Private msUrl As String = ""
	Private pnlSkeleton As B4XView
	Private cvs As B4XCanvas
	
	Private mAnimProgress As Float = 1.5
	Private mAnimTimer As Timer
	Private mAnimDuration As Long = 1800
	Private mAnimStartTime As Long
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	mAnimTimer.Initialize("AnimTimer", 16)
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("base")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(Width))
	props.Put("Height", ResolvePxSizeSpec(Height))
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mTag = mBase.Tag
	mBase.Tag = Me

	Dim l As Label
	l.Initialize("lblContent")
	l.SingleLine = False
	lblContent = l
	mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub UpdateTheme
	If mBase.IsInitialized = False Then Return
	RefreshText
End Sub

Public Sub RefreshText
	If mBase.IsInitialized = False Then Return
	ApplyVariantColors
	ApplyVisual
End Sub

Public Sub MeasureTextWidth As Float
    If mText = "" Then Return 0
    If mWidthExplicit Then Return mWidth
    Dim cvs1 As Canvas
    Dim bmp As Bitmap
    bmp.InitializeMutable(2dip, 2dip)
    cvs1.Initialize2(bmp)
    Dim fnt As B4XFont
    ' mTextSize is stored in sp units (e.g. 12 for text-xs, 32 for value).
    ' Do NOT divide by 1dip � that would convert sp?raw-px and give a ~3x underestimate.
    If mFontBold Then
        fnt = xui.CreateDefaultBoldFont(mTextSize)
    Else
        fnt = xui.CreateDefaultFont(mTextSize)
    End If
    ' Add a safety buffer of 8dip to account for intrinsic Label padding and kerning overhangs
    Return cvs1.MeasureStringWidth(mText, fnt.ToNativeFont, fnt.Size) + (mPadding * 2) + 8dip
End Sub

' Returns the measured pixel height of a single line of text at the current font size.
' Uses StringUtils.MeasureMultilineTextHeight on lblContent � consistent with codebase pattern.
Public Sub MeasureTextHeight As Float
    If lblContent.IsInitialized = False Then Return 16dip
    Dim lbl As Label = lblContent
    Dim savedW As Int = lbl.Width
    lbl.Width = 2000dip   ' prevent wrapping so we measure a single line height
    Dim h As Int = tu.MeasureMultilineTextHeight(lbl, "Xgp")
    lbl.Width = savedW
    Return Max(1dip, h) + (mPadding * 2)
End Sub

' Returns preferred wrapped text height for a given content width.
Public Sub GetPreferredHeight(MaxContentWidth As Int) As Int
	If lblContent.IsInitialized = False Then
		Return Max(1dip, (mTextSize * 1.5dip) + (mPadding * 2))
	End If
	Dim targetW As Int = Max(1dip, MaxContentWidth)
	Dim lbl As Label = lblContent
	Dim savedW As Int = lbl.Width
	lbl.Width = targetW
	lbl.SingleLine = False
	ApplyLineHeight
	Dim sample As String = IIf(mText.Length = 0, " ", mText)
	Dim h As Int = tu.MeasureMultilineTextHeight(lbl, sample)
	' Add a safety factor for multiline text because StringUtils ignores line spacing multiplier
	Dim multiple As Float = GetLineHeightMultiple
    If multiple > 1.05 Then h = h * multiple
	
	lbl.Width = savedW
	lbl.SingleLine = mSingleLine
	Return Max(1dip, h + (mPadding * 2) + 4dip)
End Sub

''' <summary>
''' Returns the current rendered height of this text view (after AutoResize has applied).
''' </summary>
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(Props, "Width", "w-10"))
	Dim heightSpec As String = B4XDaisyVariants.GetPropString(Props, "Height", "h-6").ToLowerCase.Trim
	If heightSpec = "auto" Or heightSpec = "h-auto" Then
		mbAutoResize = True
	Else
		mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(Props, "Height", "h-6"))
	End If
	mWidthExplicit = Props.IsInitialized And Props.ContainsKey("Width")
	mHeightExplicit = Props.IsInitialized And Props.ContainsKey("Height") And (mbAutoResize = False)
	mText = B4XDaisyVariants.GetPropString(Props, "Text", "")
	mTextColor = B4XDaisyVariants.GetPropInt(Props, "TextColor", 0xFF000000)
	mBackgroundColor = B4XDaisyVariants.GetPropInt(Props, "BackgroundColor", 0x00000000)
	mTextSizeSpec = B4XDaisyVariants.GetPropObject(Props, "TextSize", "text-sm")
	mTextSize = ResolveTextSize(mTextSizeSpec, mTextSize)
	mFontBold = B4XDaisyVariants.GetPropBool(Props, "FontBold", False)
	mSingleLine = B4XDaisyVariants.GetPropBool(Props, "SingleLine", False)
	msEllipsize = B4XDaisyVariants.GetPropString(Props, "Ellipsize", "none").ToLowerCase.Trim
	mHAlign = NormalizeHAlign(B4XDaisyVariants.GetPropString(Props, "HAlign", "LEFT"))
	mVAlign = NormalizeVAlign(B4XDaisyVariants.GetPropString(Props, "VAlign", "CENTER"))
	mPadding = Max(0, B4XDaisyVariants.GetPropFloat(Props, "Padding", 0) * 1dip)
	mMargin = B4XDaisyVariants.GetPropString(Props, "Margin", "")
	mRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", False)
	mBorderWidth = Max(0, B4XDaisyVariants.GetPropFloat(Props, "BorderWidth", 0) * 1dip)
	mBorderColor = B4XDaisyVariants.GetPropInt(Props, "BorderColor", 0x00000000)
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
	mEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
	mIsSkeleton = B4XDaisyVariants.GetPropBool(Props, "IsSkeleton", False)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "none"))
	If mVariant <> "none" Then ApplyVariantColors
	mbAutoResize = B4XDaisyVariants.GetPropBool(Props, "AutoResize", False)
	mbIsLink = B4XDaisyVariants.GetPropBool(Props, "Link", False)
	mbUnderline = B4XDaisyVariants.GetPropBool(Props, "Underline", False)
	msUrl = B4XDaisyVariants.GetPropString(Props, "Url", "")
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	
	If pnlSkeleton.IsInitialized Then
		pnlSkeleton.SetLayoutAnimated(0, 0, 0, w, h)
		cvs.Resize(w, h)
	End If
	
	ApplyVisual
End Sub

Private Sub ApplyVisual
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim radius As Float = IIf(mRoundedBox, B4XDaisyVariants.GetRadiusBoxDip(8dip), 0)
	mBase.SetColorAndBorder(mBackgroundColor, mBorderWidth, mBorderColor, radius)

	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	lblContent.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	lblContent.Text = mText
	lblContent.TextColor = mTextColor
	lblContent.TextSize = mTextSize
	lblContent.SetTextAlignment(mVAlign, mHAlign)
	Dim l As Label = lblContent
	' AutoResize = paragraph mode: force wrapping so text never clips to one line
	l.SingleLine = IIf(mbAutoResize, False, mSingleLine)
	Try
		Dim joLbl As JavaObject = lblContent
		Dim joTruncate As JavaObject
		joTruncate.InitializeStatic("android.text.TextUtils$TruncateAt")
		Select Case msEllipsize
			Case "start":   joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("START")))
			Case "middle":  joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("MIDDLE")))
			Case "end":     joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("END")))
			Case "marquee": joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("MARQUEE")))
			Case Else:      joLbl.RunMethod("setEllipsize", Array As Object(Null))
		End Select
	Catch
	End Try
	If mFontBold Then
		lblContent.Font = xui.CreateDefaultBoldFont(mTextSize)
	Else
		lblContent.Font = xui.CreateDefaultFont(mTextSize)
	End If
	ApplyLineHeight
	' Link / underline styling.
	#If B4A
	If mbUnderline Then
		Dim joLnk As JavaObject = lblContent
		Dim lnkFlags As Int = joLnk.RunMethod("getPaintFlags", Null)
		Dim lnkNew As Int = Bit.Or(lnkFlags, 8) ' set Paint.UNDERLINE_TEXT_FLAG
		joLnk.RunMethod("setPaintFlags", Array(lnkNew))
	End If
	#End If
	mBase.Visible = mVisible
	lblContent.Enabled = mEnabled
	ApplySkeletonVisual
	If mbAutoResize Then DoAutoResize
End Sub

Private Sub GetLineHeightMultiple As Float
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(mTextSizeSpec, mTextSize, mTextSize * 1.5)
	Dim fontPx As Float = Max(1, tm.GetDefault("font_size", mTextSize))
	Dim linePx As Float = Max(fontPx, tm.GetDefault("line_height_px", fontPx * 1.5))
	Return Max(1, linePx / fontPx)
End Sub

Private Sub ApplyLineHeight
	If lblContent.IsInitialized = False Then Return
	B4XDaisyVariants.SetLineSpacing(lblContent, GetLineHeightMultiple, 0)
End Sub

' Resizes mBase height to exactly fit text content using CSS line-height math:
'   total_height = line_height_px * num_lines + vertical_padding
' Called at the end of ApplyVisual when mbAutoResize = True.
' Does NOT call Base_Resize to avoid recursion; updates mBase and lblContent directly.
Private Sub DoAutoResize
	If mBase.IsInitialized = False Then Return
	If lblContent.IsInitialized = False Then Return
	' lblContent.Width is already correctly laid out by ApplyVisual — it reflects
	' the exact content-area width accounting for padding and margin.
	Dim contentW As Int = Max(1dip, lblContent.Width)
	Dim newH As Int = GetPreferredHeight(contentW)
	' GetPreferredHeight restores lblContent.SingleLine = mSingleLine after measuring;
	' re-enforce wrapping on the live label here.
	Dim lbl As Label = lblContent
	lbl.SingleLine = False
	If Abs(mBase.Height - newH) <= 1 Then Return
	' Resize the base panel directly
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, newH)
	' Re-layout lblContent for the new height
	Dim host As B4XRect
	host.Initialize(0, 0, mBase.Width, newH)
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	lblContent.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	If pnlSkeleton.IsInitialized Then
		pnlSkeleton.SetLayoutAnimated(0, 0, 0, mBase.Width, newH)
		cvs.Resize(mBase.Width, newH)
	End If
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	box.Put("padding_left", mPadding)
	box.Put("padding_right", mPadding)
	box.Put("padding_top", mPadding)
	box.Put("padding_bottom", mPadding)
	ApplyMarginSpecToBox(box, mMargin)
	Return box
End Sub

Private Sub ApplyMarginSpecToBox(Box As Map, MarginSpec As String)
	Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
	If m.Length = 0 Then Return
	Dim rtl As Boolean = False
	If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
		B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
	Else
		Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
		Box.Put("margin_left", mv)
		Box.Put("margin_right", mv)
		Box.Put("margin_top", mv)
		Box.Put("margin_bottom", mv)
	End If
End Sub







Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Width
	If w <= 0 Then
		If Parent.Width > 0 Then
			w = Parent.Width - Left
		Else
			w = 200dip
		End If
	End If
	Dim h As Int = Height
	If h <= 0 And mbAutoResize Then
		h = 24dip
	Else If h <= 0 Then
		h = 24dip
	End If
	w = Max(1dip, w)
	h = Max(1dip, h)
	Dim p As Panel
	p.Initialize("base")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(w))
	props.Put("Height", ResolvePxSizeSpec(h))
	' Preserve all runtime property state set before AddToParent
	props.Put("Text", mText)
	props.Put("TextColor", mTextColor)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextSize", mTextSizeSpec)
	props.Put("FontBold", mFontBold)
	props.Put("SingleLine", mSingleLine)
	props.Put("Ellipsize", msEllipsize)
	props.Put("HAlign", mHAlign)
	props.Put("VAlign", mVAlign)
	props.Put("Padding", Max(0, Round(mPadding / 1dip)))
	props.Put("Margin", mMargin)
	props.Put("RoundedBox", mRoundedBox)
	props.Put("BorderWidth", Max(0, Round(mBorderWidth / 1dip)))
	props.Put("BorderColor", mBorderColor)
	props.Put("Visible", mVisible)
	props.Put("Enabled", mEnabled)
	props.Put("IsSkeleton", mIsSkeleton)
	props.Put("Variant", mVariant)
	props.Put("AutoResize", mbAutoResize)
	props.Put("Link", mbIsLink)
	props.Put("Underline", mbUnderline)
	props.Put("Url", msUrl)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Parent.AddView(mBase, Left, Top, w, h)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And lblContent.IsInitialized
End Sub

Private Sub lblContent_Click
	RaiseClick
End Sub

Private Sub base_Click
	RaiseClick
End Sub

Private Sub RaiseClick
	#If B4A
	If mbIsLink Then
		If msUrl.Length > 0 Then
			Dim i As Intent
			i.Initialize(i.ACTION_VIEW, msUrl)
			StartActivity(i)
			Return
		End If
	End If
	#End If
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub

Private Sub NormalizeHAlign(Value As String) As String
	Dim s As String = Value.ToUpperCase.Trim
	Select Case s
		Case "LEFT", "CENTER", "RIGHT"
			Return s
		Case Else
			Return "LEFT"
	End Select
End Sub

Private Sub NormalizeVAlign(Value As String) As String
	Dim s As String = Value.ToUpperCase.Trim
	Select Case s
		Case "TOP", "CENTER", "BOTTOM"
			Return s
		Case Else
			Return "CENTER"
	End Select
End Sub

Private Sub ResolveTextSize(Value As Object, DefaultSize As Float) As Float
	If Value = Null Then Return DefaultSize
	If IsNumber(Value) Then Return Max(1, Value)
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultSize
	If IsNumber(s) Then Return Max(1, s)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(s, DefaultSize, DefaultSize * 1.4)
	Return Max(1, tm.GetDefault("font_size", DefaultSize))
End Sub




Public Sub setText(Value As String)
	mText = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mWidth, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	Dim s As String = IIf(Value = Null, "", (Value & "").ToLowerCase.Trim)
	If s = "auto" Or s = "h-auto" Then
		mbAutoResize = True
		If mBase.IsInitialized Then ApplyVisual
		Return
	End If
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setTextColor(Value As Int)
	mTextColorOverride = Value
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub



Public Sub setBackgroundColor(Value As Int)
	mBackgroundColorOverride = Value
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(VariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	' Reset manual colors to ensure variant colors take full effect. (Last one wins)
	mTextColorOverride = 0
	mBackgroundColorOverride = 0
	mBorderColorOverride = 0
	If mBase.IsInitialized = False Then Return
	ApplyVariantColors
	ApplyVisual
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Private Sub ApplyVariantColors
	' Start with theme defaults if no overrides
	Dim p As Map = B4XDaisyVariants.GetVariantPalette
	If mVariant = "none" Then
		mBackgroundColor = xui.Color_Transparent
		mTextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
		mBorderColor = xui.Color_Transparent
	Else
		mBackgroundColor = B4XDaisyVariants.ResolveVariantColor(p, mVariant, "back", xui.Color_Transparent)
		mTextColor = B4XDaisyVariants.ResolveVariantColor(p, mVariant, "text", B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black))
		mBorderColor = B4XDaisyVariants.ResolveBorderColorVariantFromPalette(p, mVariant, xui.Color_Transparent)
	End If
	
	' Apply overrides if set
	If mBackgroundColorOverride <> 0 Then mBackgroundColor = mBackgroundColorOverride
	If mTextColorOverride <> 0 Then mTextColor = mTextColorOverride
	If mBorderColorOverride <> 0 Then mBorderColor = mBorderColorOverride
End Sub

Public Sub setTextSize(Value As Object)
	mTextSizeSpec = Value
	mTextSize = ResolveTextSize(Value, mTextSize)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextSize As Object
	Return mTextSize
End Sub

Public Sub setFontBold(Value As Boolean)
	mFontBold = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getFontBold As Boolean
	Return mFontBold
End Sub

Public Sub setSingleLine(Value As Boolean)
	mSingleLine = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getSingleLine As Boolean
	Return mSingleLine
End Sub

Public Sub setEllipsize(Value As String)
	msEllipsize = Value.ToLowerCase.Trim
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getEllipsize As String
	Return msEllipsize
End Sub

Public Sub setHAlign(Value As String)
	mHAlign = NormalizeHAlign(Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getHAlign As String
	Return mHAlign
End Sub

Public Sub setVAlign(Value As String)
	mVAlign = NormalizeVAlign(Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVAlign As String
	Return mVAlign
End Sub

Public Sub setPadding(Value As Float)
	mPadding = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getPadding As Float
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setBorderWidth(Value As Float)
	mBorderWidth = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderWidth As Float
	Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
	mBorderColorOverride = Value
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub



Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setEnabled(Value As Boolean)
	mEnabled = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setLink(Value As Boolean)
	mbIsLink = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getLink As Boolean
	Return mbIsLink
End Sub

Public Sub setUnderline(Value As Boolean)
	mbUnderline = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getUnderline As Boolean
	Return mbUnderline
End Sub

Public Sub setUrl(Value As String)
	msUrl = IIf(Value = Null, "", Value)
End Sub

Public Sub getUrl As String
	Return msUrl
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Private Sub ApplySkeletonVisual
	If mIsSkeleton Then
		EnsureSkeletonPanel
		pnlSkeleton.Visible = True
		pnlSkeleton.BringToFront
		lblContent.Visible = False
		StartAnimation
	Else
		StopAnimation
		If pnlSkeleton.IsInitialized Then
			pnlSkeleton.Visible = False
		End If
		lblContent.Visible = mVisible
	End If
End Sub

Private Sub EnsureSkeletonPanel
	If pnlSkeleton.IsInitialized And pnlSkeleton.Parent.IsInitialized Then
		Return
	End If
	If pnlSkeleton.IsInitialized Then pnlSkeleton.RemoveViewFromParent
	
	Dim p As Panel
	p.Initialize("")
	pnlSkeleton = p
	pnlSkeleton.Visible = False
	mBase.AddView(pnlSkeleton, 0, 0, mBase.Width, mBase.Height)
	cvs.Initialize(pnlSkeleton)
End Sub

Public Sub StartAnimation
    mAnimStartTime = DateTime.Now
    mAnimTimer.Enabled = True
End Sub

Public Sub StopAnimation
    mAnimTimer.Enabled = False
End Sub

Private Sub AnimTimer_Tick
    ' Calculate progress using ease-in-out timing
    Dim elapsed As Long = DateTime.Now - mAnimStartTime
    Dim t As Float = (elapsed Mod mAnimDuration) / mAnimDuration
    
    ' Ease-in-out cubic
    If t < 0.5 Then
        t = 4 * t * t * t
    Else
        t = 1 - Power(-2 * t + 2, 3) / 2
    End If
    
    ' Map progress: -0.5 (-50%) -> 1.5 (150%) (Left to Right)
    mAnimProgress = -0.5 + (t * 2.0)
    
    DrawSkeleton
End Sub

Private Sub DrawSkeleton
    If pnlSkeleton.IsInitialized = False Then Return
    Dim w As Float = pnlSkeleton.Width
    Dim h As Float = pnlSkeleton.Height
    If w <= 0 Or h <= 0 Then Return
    
    cvs.ClearRect(cvs.TargetRect)
    DrawTextSkeleton(w, h)
    cvs.Invalidate
End Sub

Public Sub setIsSkeleton(Value As Boolean)
	If mIsSkeleton = Value Then Return
	mIsSkeleton = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getIsSkeleton As Boolean
	Return mIsSkeleton
End Sub

Public Sub setAutoResize(Value As Boolean)
	mbAutoResize = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub

Private Sub SetAlpha (Color As Int, Alpha As Int) As Int
    Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
    Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
    Dim b As Int = Bit.And(Color, 0xFF)
    Return Bit.Or(Bit.ShiftLeft(Alpha, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub


Private Sub DrawTextSkeleton (w As Float, h As Float)
    If mText.Length = 0 Then Return
    
    ' Resolve layout (same as ApplyVisual)
	Dim host As B4XRect : host.Initialize(0, 0, w, h)
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    
	Dim fnt As B4XFont
    If mFontBold Then
        fnt = xui.CreateDefaultBoldFont(mTextSize)
    Else
        fnt = xui.CreateDefaultFont(mTextSize)
    End If
    
	Dim cx As Float, cy As Float
	Dim halign As String = mHAlign
	Dim valign As String = mVAlign

	Select Case halign
		Case "LEFT": cx = contentRect.Left
		Case "CENTER": cx = contentRect.CenterX
		Case "RIGHT": cx = contentRect.Right
	End Select
	
	Dim Bounds As B4XRect = cvs.MeasureText(mText, fnt)
	Select Case valign
		Case "TOP": cy = contentRect.Top + Bounds.Height
		Case "CENTER": cy = contentRect.CenterY - (Bounds.Top + Bounds.Bottom) / 2
		Case "BOTTOM": cy = contentRect.Bottom - Bounds.Bottom
	End Select

    ' Base text color with low opacity (20%)
    Dim baseAlpha As Int = 51  '255 * 0.2
    Dim baseTextColor As Int = SetAlpha(mTextColor, baseAlpha)
    
    ' Draw base faded text
    cvs.DrawText(mText, cx, cy, fnt, baseTextColor, halign)
    
    ' Define shimmer region
    Dim shimmerCenter As Float = mAnimProgress * w
    Dim shimmerWidth As Float = w * 0.3
    Dim skew As Float = h
    
    ' ---- NATIVE CLIPPING for the bright text strip ----
    #If B4A
    Dim jo As JavaObject = cvs
    Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")
    Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas")
    
    Dim clipPath As JavaObject
    clipPath.InitializeNewInstance("android.graphics.Path", Null)
    
    Dim stripX As Float = shimmerCenter - shimmerWidth
    ' Define slanted strip points (/)
    clipPath.RunMethod("moveTo", Array(stripX + skew, 0.0f))
    clipPath.RunMethod("lineTo", Array(stripX + skew + shimmerWidth, 0.0f))
    clipPath.RunMethod("lineTo", Array(stripX + shimmerWidth, h))
    clipPath.RunMethod("lineTo", Array(stripX, h))
    clipPath.RunMethod("close", Null)
    
    nativeCanvas.RunMethod("save", Null)
    nativeCanvas.RunMethod("clipPath", Array(clipPath))
    #End If
    
    ' Draw bright text (only the part inside the clipPath will show)
    cvs.DrawText(mText, cx, cy, fnt, mTextColor, halign)
    
    #If B4A
    nativeCanvas.RunMethod("restore", Null)
    #End If
End Sub

' -------------------------------------------------------------
' B4A Raw Label Drop-In Equivalency Methods
' -------------------------------------------------------------

Public Sub setLeft(Value As Int)
    If mBase.IsInitialized Then mBase.Left = Value
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized Then Return mBase.Left
    Return 0
End Sub

Public Sub setTop(Value As Int)
    If mBase.IsInitialized Then mBase.Top = Value
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized Then Return mBase.Top
    Return 0
End Sub

Public Sub setColor(BackgroundColor As Int)
    setBackgroundColor(BackgroundColor)
End Sub

Public Sub getColor As Int
	Return mBackgroundColor
End Sub

Public Sub SetTextAlignment(Vertical As String, Horizontal As String)
    setVAlign(Vertical)
    setHAlign(Horizontal)
End Sub

Public Sub SetLayoutAnimated(Duration As Int, LeftPos As Int, TopPos As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(Duration, LeftPos, TopPos, Max(1dip, Width), Max(1dip, Height))
    If Width > 0 And Height > 0 Then Base_Resize(Width, Height)
End Sub

Public Sub SetColorAndBorder(CBackgroundColor As Int, CBorderW As Float, CBorderC As Int, CornerRadius As Float)
    mBackgroundColor = CBackgroundColor
    mBorderWidth = CBorderW
    mBorderColor = CBorderC
    mRoundedBox = (CornerRadius > 0)
    If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
