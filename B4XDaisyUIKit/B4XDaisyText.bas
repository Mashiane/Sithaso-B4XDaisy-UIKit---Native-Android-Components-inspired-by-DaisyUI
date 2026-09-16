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
#DesignerProperty: Key: Heading, DisplayName: Heading, FieldType: String, DefaultValue: none, List: none|h1|h2|h3|h4|h5|h6, Description: Apply Ionic heading settings (font-size 26->16, weight 500, line-height 1.2). Overrides TextSize when not none.
#DesignerProperty: Key: FontBold, DisplayName: Font Bold, FieldType: Boolean, DefaultValue: False, Description: Use bold font.
#DesignerProperty: Key: SingleLine, DisplayName: Single Line, FieldType: Boolean, DefaultValue: False, Description: Single line text.
#DesignerProperty: Key: Ellipsize, DisplayName: Ellipsize, FieldType: String, DefaultValue: none, List: none|start|middle|end|marquee, Description: Truncate with ellipsis when text overflows. Requires Single Line for start/middle/end.
#DesignerProperty: Key: HAlign, DisplayName: Horizontal Align, FieldType: String, DefaultValue: LEFT, List: LEFT|CENTER|RIGHT, Description: Text horizontal alignment.
#DesignerProperty: Key: VAlign, DisplayName: Vertical Align, FieldType: String, DefaultValue: CENTER, List: TOP|CENTER|BOTTOM, Description: Text vertical alignment.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in dip.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-none, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius token.
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
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: When False, touch events pass through to parent (useful inside clickable list rows)
#DesignerProperty: Key: UpperCase, DisplayName: Upper Case, FieldType: Boolean, DefaultValue: False, Description: Transform text to uppercase.
#DesignerProperty: Key: Italic, DisplayName: Italic, FieldType: Boolean, DefaultValue: False, Description: Render text in italic style.
#DesignerProperty: Key: Strikethrough, DisplayName: Strikethrough, FieldType: Boolean, DefaultValue: False, Description: Draw a horizontal line through the text.
#DesignerProperty: Key: LowerCase, DisplayName: Lower Case, FieldType: Boolean, DefaultValue: False, Description: Transform text to lowercase.
#DesignerProperty: Key: Capitalize, DisplayName: Capitalize, FieldType: Boolean, DefaultValue: False, Description: Capitalize first letter of each word.
#DesignerProperty: Key: LetterSpacing, DisplayName: Letter Spacing, FieldType: Float, DefaultValue: 0.0, Description: Letter spacing in em units (eg 0.05, 0.1).
#DesignerProperty: Key: ShadowRadius, DisplayName: Shadow Radius, FieldType: Float, DefaultValue: 0.0, Description: Blur radius of the text shadow (0 to disable).
#DesignerProperty: Key: ShadowDx, DisplayName: Shadow Dx, FieldType: Float, DefaultValue: 0.0, Description: Horizontal offset of the text shadow.
#DesignerProperty: Key: ShadowDy, DisplayName: Shadow Dy, FieldType: Float, DefaultValue: 0.0, Description: Vertical offset of the text shadow.
#DesignerProperty: Key: ShadowColor, DisplayName: Shadow Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Color of the text shadow.

#IgnoreWarnings:12,9
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
	Private msHeading As String = "none"
	Private mFontBold As Boolean = False
	Private mSingleLine As Boolean = False
	Private msEllipsize As String = "none"
	Private mHAlign As String = "LEFT"
	Private mVAlign As String = "CENTER"
	Private mPadding As Float = 0dip
	Private mMargin As String = ""
	Private mRounded As String = "rounded-none"
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
	Private mClickable As Boolean = True
	Private mUpperCase As Boolean = False
	Private mItalic As Boolean = False
	Private mStrikethrough As Boolean = False
	Private mLowerCase As Boolean = False
	Private mCapitalize As Boolean = False
	Private mLetterSpacing As Float = 0.0
	Private mShadowRadius As Float = 0.0
	Private mShadowDx As Float = 0.0
	Private mShadowDy As Float = 0.0
	Private mShadowColor As Int = 0xFF000000
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	mAnimTimer.Initialize("AnimTimer", 16)
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("base")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mTag = mBase.Tag
	mBase.Tag = Me

	Dim l As Label
	l.Initialize("lblContent")
	l.SingleLine = False
	lblContent = l
	mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)
	ApplyDesignerProps(mProps)
	' Apply clickable state to native views
	If mClickable = False Then
		#If B4A
		Dim joClickable As JavaObject = mBase
		joClickable.RunMethod("setClickable", Array(False))
		If lblContent.IsInitialized Then
			Dim joLbl As JavaObject = lblContent
			joLbl.RunMethod("setClickable", Array(False))
		End If
		#Else If B4J
		mBase.Enabled = False
		If lblContent.IsInitialized Then lblContent.Enabled = False
		#Else If B4i
		mBase.Enabled = False
		If lblContent.IsInitialized Then lblContent.Enabled = False
		#End If
	End If
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
    Dim fnt As B4XFont
    ' mTextSize is stored in sp units (e.g. 12 for text-xs, 32 for value).
    ' Do NOT divide by 1dip - that would convert sp to raw-px and give a ~3x underestimate.
    If mFontBold Then
        fnt = xui.CreateDefaultBoldFont(mTextSize)
    Else
        fnt = xui.CreateDefaultFont(mTextSize)
    End If
    ' Add a safety buffer of 8dip to account for intrinsic Label padding and kerning overhangs
    Return B4XDaisyVariants.MeasureTextWidthSafe(mText, fnt.Size, fnt.ToNativeFont, (mPadding * 2) + 8dip)
End Sub

' Returns the measured pixel height of a single line of text at the current font size.
' Uses StringUtils.MeasureMultilineTextHeight on lblContent - consistent with codebase pattern.
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
Public Sub GetPreferredHeight(iMaxContentWidth As Int) As Int
	If lblContent.IsInitialized = False Then
		Return Max(1dip, (mTextSize * 1.5dip) + (mPadding * 2))
	End If
	Dim targetW As Int = Max(1dip, iMaxContentWidth)
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

' <summary>
' Returns the current rendered height of this text view (after AutoResize has applied).
' </summary>
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mWidth = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", "w-10"))
	Dim heightSpec As String = B4XDaisyVariants.GetPropString(mProps, "Height", "h-6").ToLowerCase.Trim
	If heightSpec = "auto" Or heightSpec = "h-auto" Then
		mbAutoResize = True
	Else
		mHeight = Max(1dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", "h-6"))
	End If
	mWidthExplicit = mProps.IsInitialized And mProps.ContainsKey("Width")
	mHeightExplicit = mProps.IsInitialized And mProps.ContainsKey("Height") And (mbAutoResize = False)
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mTextColor = B4XDaisyVariants.GetPropInt(mProps, "TextColor", mTextColor)
	mBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "BackgroundColor", 0x00000000)
	mTextSizeSpec = B4XDaisyVariants.GetPropObject(mProps, "TextSize", "text-sm")
	msHeading = B4XDaisyVariants.GetPropString(mProps, "Heading", "none").ToLowerCase.Trim
	mTextSize = ResolveTextSize(EffectiveTextSizeSpec, mTextSize)
	mFontBold = B4XDaisyVariants.GetPropBool(mProps, "FontBold", mFontBold)
	mSingleLine = B4XDaisyVariants.GetPropBool(mProps, "SingleLine", mSingleLine)
	msEllipsize = B4XDaisyVariants.GetPropString(mProps, "Ellipsize", msEllipsize).ToLowerCase.Trim
	mHAlign = NormalizeHAlign(B4XDaisyVariants.GetPropString(mProps, "HAlign", mHAlign))
	mVAlign = NormalizeVAlign(B4XDaisyVariants.GetPropString(mProps, "VAlign", mVAlign))
	mPadding = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "Padding", 0) * 1dip)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)

	' Backward compatibility: migrate legacy RoundedBox=True
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (mRounded = "theme" Or mRounded = "" Or mRounded = "rounded-none") Then
	        mRounded = "rounded-box"
	    End If
	End If
	mBorderWidth = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "BorderWidth", 0) * 1dip)
	mBorderColor = B4XDaisyVariants.GetPropInt(mProps, "BorderColor", 0x00000000)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mEnabled)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)
	mIsSkeleton = B4XDaisyVariants.GetPropBool(mProps, "IsSkeleton", mIsSkeleton)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	If mVariant <> "none" Then ApplyVariantColors
	mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
	mbIsLink = B4XDaisyVariants.GetPropBool(mProps, "Link", mbIsLink)
	mbUnderline = B4XDaisyVariants.GetPropBool(mProps, "Underline", mbUnderline)
	msUrl = B4XDaisyVariants.GetPropString(mProps, "Url", msUrl)
	mUpperCase = B4XDaisyVariants.GetPropBool(mProps, "UpperCase", mUpperCase)
	mItalic = B4XDaisyVariants.GetPropBool(mProps, "Italic", mItalic)
	mStrikethrough = B4XDaisyVariants.GetPropBool(mProps, "Strikethrough", mStrikethrough)
	mLowerCase = B4XDaisyVariants.GetPropBool(mProps, "LowerCase", mLowerCase)
	mCapitalize = B4XDaisyVariants.GetPropBool(mProps, "Capitalize", mCapitalize)
	mLetterSpacing = B4XDaisyVariants.GetPropFloat(mProps, "LetterSpacing", mLetterSpacing)
	mShadowRadius = B4XDaisyVariants.GetPropFloat(mProps, "ShadowRadius", mShadowRadius)
	mShadowDx = B4XDaisyVariants.GetPropFloat(mProps, "ShadowDx", mShadowDx)
	mShadowDy = B4XDaisyVariants.GetPropFloat(mProps, "ShadowDy", mShadowDy)
	mShadowColor = B4XDaisyVariants.GetPropInt(mProps, "ShadowColor", 0xFF000000)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(iWidth))
	props.Put("Height", ResolvePxSizeSpec(iHeight))
	props.Put("Text", mText)
	props.Put("TextColor", mTextColor)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextSize", mTextSizeSpec)
	props.Put("Heading", msHeading)
	props.Put("FontBold", mFontBold)
	props.Put("SingleLine", mSingleLine)
	props.Put("Ellipsize", msEllipsize)
	props.Put("HAlign", mHAlign)
	props.Put("VAlign", mVAlign)
	props.Put("Padding", Max(0, Round(mPadding / 1dip)))
	props.Put("Margin", mMargin)
	props.Put("Rounded", mRounded)
	props.Put("BorderWidth", Max(0, Round(mBorderWidth / 1dip)))
	props.Put("BorderColor", mBorderColor)
	props.Put("Visible", mVisible)
	props.Put("Enabled", mEnabled)
	props.Put("Clickable", mClickable)
	props.Put("IsSkeleton", mIsSkeleton)
	props.Put("Variant", mVariant)
	props.Put("AutoResize", mbAutoResize)
	props.Put("Link", mbIsLink)
	props.Put("Underline", mbUnderline)
	props.Put("Url", msUrl)
	props.Put("UpperCase", mUpperCase)
	props.Put("Italic", mItalic)
	props.Put("Strikethrough", mStrikethrough)
	props.Put("LowerCase", mLowerCase)
	props.Put("Capitalize", mCapitalize)
	props.Put("LetterSpacing", mLetterSpacing)
	props.Put("ShadowRadius", mShadowRadius)
	props.Put("ShadowDx", mShadowDx)
	props.Put("ShadowDy", mShadowDy)
	props.Put("ShadowColor", mShadowColor)
	Return props
End Sub


Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	
	If pnlSkeleton.IsInitialized Then
		pnlSkeleton.SetLayoutAnimated(0, 0, 0, w, h)
		cvs.Resize(w, h)
	End If
	
	ApplyVisual
	inResize = False
End Sub

Private Sub ApplyVisual
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim radius As Float = IIf(mRounded = "rounded-box" Or mRounded = "theme", B4XDaisyVariants.GetRadiusBoxDip(8dip), 0)
	mBase.SetColorAndBorder(mBackgroundColor, mBorderWidth, mBorderColor, radius)

	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	lblContent.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	
	Dim displayTxt As String = mText
	If mUpperCase Then
		displayTxt = mText.ToUpperCase
	Else If mLowerCase Then
		displayTxt = mText.ToLowerCase
	Else If mCapitalize Then
		displayTxt = CapitalizeWords(mText)
	End If

	lblContent.Text = displayTxt
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
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
	End Try
	If mFontBold Then
		lblContent.Font = xui.CreateDefaultBoldFont(mTextSize)
	Else
		lblContent.Font = xui.CreateDefaultFont(mTextSize)
	End If
	#If B4A
	If mItalic Then
		Dim l As Label = lblContent
		If mFontBold Then
			l.Typeface = Typeface.CreateNew(Typeface.DEFAULT, 3) ' BOLD_ITALIC
		Else
			l.Typeface = Typeface.CreateNew(Typeface.DEFAULT, 2) ' ITALIC
		End If
	Else If IsHeadingSpec(EffectiveTextSizeSpec) And mFontBold = False Then
		ApplyHeadingTypeface(lblContent)
	End If
	#End If
	ApplyLineHeight
	' Paint flags: underline, strikethrough
	#If B4A
	Dim joLbl As JavaObject = lblContent
	Dim curFlags As Int = joLbl.RunMethod("getPaintFlags", Null)
	If mbUnderline Then
		curFlags = Bit.Or(curFlags, 8) ' Paint.UNDERLINE_TEXT_FLAG
	End If
	If mStrikethrough Then
		curFlags = Bit.Or(curFlags, 16) ' Paint.STRIKE_THRU_TEXT_FLAG
	End If
	joLbl.RunMethod("setPaintFlags", Array(curFlags))
	#End If

	' Apply Letter Spacing
	#If B4A
	If mLetterSpacing <> 0.0 Then
		Try
			Dim joLbl As JavaObject = lblContent
			joLbl.RunMethod("setLetterSpacing", Array(mLetterSpacing))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	Else
		Try
			Dim joLbl As JavaObject = lblContent
			joLbl.RunMethod("setLetterSpacing", Array(0.0f))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	End If
	#Else If B4i
	If mLetterSpacing <> 0.0 Then
		Try
			Dim no As NativeObject = lblContent
			Dim attrText As NativeObject
			attrText = attrText.Initialize("NSMutableAttributedString").RunMethod("alloc", Null).RunMethod("initWithString:", Array(displayTxt))
			Dim range As Map = CreateMap("location": 0, "length": displayTxt.Length)
			attrText.RunMethod("addAttribute:value:range:", Array("NSKern", mLetterSpacing * mTextSize, range))
			no.SetField("attributedText", attrText)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	End If
	#End If

	' Apply Text Shadows & Glows
	#If B4A
	If mShadowRadius > 0 Then
		Try
			Dim joLbl As JavaObject = lblContent
			joLbl.RunMethod("setShadowLayer", Array(mShadowRadius, mShadowDx, mShadowDy, mShadowColor))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	Else
		Try
			Dim joLbl As JavaObject = lblContent
			joLbl.RunMethod("setShadowLayer", Array(0.0f, 0.0f, 0.0f, 0))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	End If
	#Else If B4i
	If mShadowRadius > 0 Then
		Try
			Dim no As NativeObject = lblContent
			no.SetField("shadowColor", no.ColorToUIColor(mShadowColor))
			no.SetField("shadowOffset", no.MakeSize(mShadowDx, mShadowDy))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	Else
		Try
			Dim no As NativeObject = lblContent
			no.SetField("shadowColor", Null)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyVisual: " & LastException.Message)
		End Try
	End If
	#End If

	mBase.Visible = mVisible
	lblContent.Enabled = mEnabled
	' Disabled: dim the text so it reads as inactive (matches the disabled family).
	mBase.Alpha = IIf(mEnabled, 1.0, 0.3)
	ApplySkeletonVisual
	If mbAutoResize Then DoAutoResize
End Sub

Private Sub GetLineHeightMultiple As Float
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(EffectiveTextSizeSpec, mTextSize, mTextSize * 1.5)
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
	' lblContent.Width is already correctly laid out by ApplyVisual =" it reflects
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

Private Sub ApplyMarginSpecToBox(mBox As Map, sMarginSpec As String)
	Dim m As String = IIf(sMarginSpec = Null, "", sMarginSpec.Trim)
	If m.Length = 0 Then Return
	Dim rtl As Boolean = False
	If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
		B4XDaisyBoxModel.ApplyMarginUtilities(mBox, m, rtl)
	Else
		Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
		mBox.Put("margin_left", mv)
		mBox.Put("margin_right", mv)
		mBox.Put("margin_top", mv)
		mBox.Put("margin_bottom", mv)
	End If
End Sub







Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = iWidth
	If w <= 0 Then
		If vParent.Width > 0 Then
			w = vParent.Width - iLeft
		Else
			w = 200dip
		End If
	End If
	Dim h As Int = iHeight
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
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
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
	If mClickable = False Then Return
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

Private Sub NormalizeHAlign(sValue As String) As String
	Dim s As String = sValue.ToUpperCase.Trim
	Select Case s
		Case "LEFT", "CENTER", "RIGHT"
			Return s
		Case Else
			Return "LEFT"
	End Select
End Sub

Private Sub NormalizeVAlign(sValue As String) As String
	Dim s As String = sValue.ToUpperCase.Trim
	Select Case s
		Case "TOP", "CENTER", "BOTTOM"
			Return s
		Case Else
			Return "CENTER"
	End Select
End Sub

Private Sub ResolveTextSize(oValue As Object, fDefaultSize As Float) As Float
	If oValue = Null Then Return fDefaultSize
	If IsNumber(oValue) Then Return Max(1, oValue)
	Dim s As String = oValue
	s = s.Trim
	If s.Length = 0 Then Return fDefaultSize
	If IsNumber(s) Then Return Max(1, s)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(s, fDefaultSize, fDefaultSize * 1.4)
	Return Max(1, tm.GetDefault("font_size", fDefaultSize))
End Sub




Public Sub setText(sValue As String)
	mText = sValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setWidth(oValue As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, mWidth))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mWidth, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(oValue As Object)
	Dim s As String = IIf(oValue = Null, "", (oValue & "").ToLowerCase.Trim)
	If s = "auto" Or s = "h-auto" Then
		mbAutoResize = True
		If mBase.IsInitialized Then ApplyVisual
		Return
	End If
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(oValue, mHeight))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColorOverride = iValue
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub



Public Sub setBackgroundColor(iValue As Int)
	mBackgroundColorOverride = iValue
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(sVariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
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
	If mVariant = "none" Then
		mBackgroundColor = xui.Color_Transparent
		mTextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
		mBorderColor = xui.Color_Transparent
	Else
		mBackgroundColor = xui.Color_Transparent
		mTextColor = B4XDaisyVariants.ResolveTextColor(mVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black))
		mBorderColor = xui.Color_Transparent
	End If
	
	' Apply overrides if set
	If mBackgroundColorOverride <> 0 Then mBackgroundColor = mBackgroundColorOverride
	If mTextColorOverride <> 0 Then mTextColor = mTextColorOverride
	If mBorderColorOverride <> 0 Then mBorderColor = mBorderColorOverride
End Sub

Public Sub setTextSize(oValue As Object)
	mTextSizeSpec = oValue
	mTextSize = ResolveTextSize(EffectiveTextSizeSpec, mTextSize)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub setHeading(sValue As String)
	If sValue = Null Then sValue = "none"
	msHeading = sValue.ToLowerCase.Trim
	mTextSize = ResolveTextSize(EffectiveTextSizeSpec, mTextSize)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getHeading As String
	Return msHeading
End Sub

Private Sub EffectiveTextSizeSpec As Object
	If IsHeadingSpec(msHeading) Then Return msHeading
	Return mTextSizeSpec
End Sub

Private Sub IsHeadingSpec(oSpec As Object) As Boolean
	If oSpec = Null Then Return False
	Dim s As String = oSpec
	s = s.ToLowerCase.Trim
	Return s = "h1" Or s = "h2" Or s = "h3" Or s = "h4" Or s = "h5" Or s = "h6"
End Sub

Private Sub ApplyHeadingTypeface(vLbl As B4XView)
	#If B4A
		Try
			Dim joTf As JavaObject
			joTf.InitializeStatic("android.graphics.Typeface")
			Dim medium As JavaObject = joTf.RunMethod("create", Array As Object("sans-serif-medium", 0))
			Dim joLbl As JavaObject = vLbl
			joLbl.RunMethod("setTypeface", Array As Object(medium))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyText.ApplyHeadingTypeface: " & LastException.Message)
		End Try
	#End If
End Sub

Public Sub getTextSize As Object
	Return mTextSize
End Sub

Public Sub setFontBold(bValue As Boolean)
	mFontBold = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getFontBold As Boolean
	Return mFontBold
End Sub

Public Sub setSingleLine(bValue As Boolean)
	mSingleLine = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getSingleLine As Boolean
	Return mSingleLine
End Sub

Public Sub setEllipsize(sValue As String)
	msEllipsize = sValue.ToLowerCase.Trim
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getEllipsize As String
	Return msEllipsize
End Sub

Public Sub setHAlign(sValue As String)
	mHAlign = NormalizeHAlign(sValue)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getHAlign As String
	Return mHAlign
End Sub

Public Sub setVAlign(sValue As String)
	mVAlign = NormalizeVAlign(sValue)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVAlign As String
	Return mVAlign
End Sub

Public Sub setPadding(fValue As Float)
	mPadding = Max(0, fValue)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getPadding As Float
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	mMargin = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setRounded(sValue As String)
	mRounded = IIf(sValue = Null, "rounded-none", sValue.ToLowerCase.Trim)
	If mBase.IsInitialized Then ApplyVisual
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setBorderWidth(fValue As Float)
	mBorderWidth = Max(0, fValue)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderWidth As Float
	Return mBorderWidth
End Sub

Public Sub setBorderColor(iValue As Int)
	mBorderColorOverride = iValue
	ApplyVariantColors
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub



Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setEnabled(bValue As Boolean)
	mEnabled = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setLink(bValue As Boolean)
	mbIsLink = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getLink As Boolean
	Return mbIsLink
End Sub

Public Sub setUnderline(bValue As Boolean)
	mbUnderline = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getUnderline As Boolean
	Return mbUnderline
End Sub

Public Sub setUrl(sValue As String)
	msUrl = IIf(sValue = Null, "", sValue)
End Sub

Public Sub getUrl As String
	Return msUrl
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
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

Public Sub setIsSkeleton(bValue As Boolean)
	If mIsSkeleton = bValue Then Return
	mIsSkeleton = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getIsSkeleton As Boolean
	Return mIsSkeleton
End Sub

Public Sub setAutoResize(bValue As Boolean)
	mbAutoResize = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub

Private Sub SetAlpha (iColor As Int, iAlpha As Int) As Int
    Dim r As Int = Bit.And(Bit.ShiftRight(iColor, 16), 0xFF)
    Dim g As Int = Bit.And(Bit.ShiftRight(iColor, 8), 0xFF)
    Dim b As Int = Bit.And(iColor, 0xFF)
    Return Bit.Or(Bit.ShiftLeft(iAlpha, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub


Private Sub DrawTextSkeleton (fW As Float, fH As Float)
    If mText.Length = 0 Then Return
    
    ' Resolve layout (same as ApplyVisual)
	Dim host As B4XRect : host.Initialize(0, 0, fW, fH)
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    
	Dim fnt As B4XFont
	If mFontBold Then
		fnt = xui.CreateDefaultBoldFont(mTextSize)
	Else
		fnt = xui.CreateDefaultFont(mTextSize)
	End If
	#If B4A
	If mItalic Then
		Dim tf As Typeface
		If mFontBold Then
			tf = Typeface.CreateNew(Typeface.DEFAULT, 3) ' BOLD_ITALIC
		Else
			tf = Typeface.CreateNew(Typeface.DEFAULT, 2) ' ITALIC
		End If
		fnt = xui.CreateFont(tf, mTextSize)
	End If
	#End If

	' Use formatted text casing for skeleton
	Dim skeletonText As String = mText
	If mUpperCase Then
		skeletonText = mText.ToUpperCase
	Else If mLowerCase Then
		skeletonText = mText.ToLowerCase
	Else If mCapitalize Then
		skeletonText = CapitalizeWords(mText)
	End If
	
	Dim cx As Float, cy As Float
	Dim halign As String = mHAlign
	Dim valign As String = mVAlign

	Select Case halign
		Case "LEFT": cx = contentRect.Left
		Case "CENTER": cx = contentRect.CenterX
		Case "RIGHT": cx = contentRect.Right
	End Select
	
	Dim Bounds As B4XRect = cvs.MeasureText(skeletonText, fnt)
	Select Case valign
		Case "TOP": cy = contentRect.Top - Bounds.Top
		Case "CENTER": cy = contentRect.CenterY - (Bounds.Top + Bounds.Bottom) / 2
		Case "BOTTOM": cy = contentRect.Bottom - Bounds.Bottom
	End Select

    ' Base text color with low opacity (20%)
    Dim baseAlpha As Int = 51  '255 * 0.2
    Dim baseTextColor As Int = SetAlpha(mTextColor, baseAlpha)
    
    ' Draw base faded text
    cvs.DrawText(skeletonText, cx, cy, fnt, baseTextColor, halign)
    
    ' Define shimmer region
    Dim shimmerCenter As Float = mAnimProgress * fW
    Dim shimmerWidth As Float = fW * 0.3
    Dim skew As Float = fH
    
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
    clipPath.RunMethod("lineTo", Array(stripX + shimmerWidth, fH))
    clipPath.RunMethod("lineTo", Array(stripX, fH))
    clipPath.RunMethod("close", Null)
    
    nativeCanvas.RunMethod("save", Null)
    nativeCanvas.RunMethod("clipPath", Array(clipPath))
    #End If
    
    ' Draw bright text (only the part inside the clipPath will show)
    cvs.DrawText(skeletonText, cx, cy, fnt, mTextColor, halign)
    
    #If B4A
    nativeCanvas.RunMethod("restore", Null)
    #End If
End Sub

' -------------------------------------------------------------
' B4A Raw Label Drop-In Equivalency Methods
' -------------------------------------------------------------

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

Public Sub setColor(iBackgroundColor As Int)
    setBackgroundColor(iBackgroundColor)
End Sub

Public Sub getColor As Int
	Return mBackgroundColor
End Sub

Public Sub SetTextAlignment(sVertical As String, sHorizontal As String)
    setVAlign(sVertical)
    setHAlign(sHorizontal)
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeftPos As Int, iTopPos As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeftPos, iTopPos, Max(1dip, iWidth), Max(1dip, iHeight))
    If iWidth > 0 And iHeight > 0 Then Base_Resize(iWidth, iHeight)
End Sub

Public Sub SetColorAndBorder(iCBackgroundColor As Int, fCBorderW As Float, iCBorderC As Int, fCornerRadius As Float)
    mBackgroundColor = iCBackgroundColor
    mBorderWidth = fCBorderW
    mBorderColor = iCBorderC
    If fCornerRadius > 0 Then mRounded = "rounded-box" Else mRounded = "rounded-none"
    If mBase.IsInitialized Then ApplyVisual
End Sub

''' Sets whether the text intercepts touch events.
''' When False, touches pass through to the parent view (e.g. a list row).
''' When True, the text handles clicks normally via the Click event.
Public Sub setClickable(bValue As Boolean)
	mClickable = bValue
	#If B4A
	If mBase.IsInitialized Then
		Dim joBase As JavaObject = mBase
		joBase.RunMethod("setClickable", Array(bValue))
		If lblContent.IsInitialized Then
			Dim joLbl As JavaObject = lblContent
			joLbl.RunMethod("setClickable", Array(bValue))
		End If
	End If
	#Else If B4J
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If lblContent.IsInitialized Then lblContent.Enabled = bValue
	End If
	#Else If B4i
	If mBase.IsInitialized Then
		mBase.Enabled = bValue
		If lblContent.IsInitialized Then lblContent.Enabled = bValue
	End If
	#End If
End Sub

''' Gets whether the text is clickable.
Public Sub getClickable As Boolean
	Return mClickable
End Sub


''' Sets whether the text is displayed in uppercase.
''' When True, the text is transformed to uppercase before rendering.
Public Sub setUpperCase(bValue As Boolean)
	mUpperCase = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

''' Gets whether the text is displayed in uppercase.
Public Sub getUpperCase As Boolean
	Return mUpperCase
End Sub

''' Sets whether the text is rendered in italic style.
Public Sub setItalic(bValue As Boolean)
	mItalic = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

''' Gets whether the text is rendered in italic style.
Public Sub getItalic As Boolean
	Return mItalic
End Sub

''' Sets whether the text has a strikethrough line.
Public Sub setStrikethrough(bValue As Boolean)
	mStrikethrough = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

''' Gets whether the text has a strikethrough line.
Public Sub getStrikethrough As Boolean
	Return mStrikethrough
End Sub

Public Sub setLowerCase(bValue As Boolean)
	mLowerCase = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getLowerCase As Boolean
	Return mLowerCase
End Sub

Public Sub setCapitalize(bValue As Boolean)
	mCapitalize = bValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getCapitalize As Boolean
	Return mCapitalize
End Sub

Public Sub setLetterSpacing(fValue As Float)
	mLetterSpacing = fValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getLetterSpacing As Float
	Return mLetterSpacing
End Sub

Public Sub setShadowRadius(fValue As Float)
	mShadowRadius = fValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getShadowRadius As Float
	Return mShadowRadius
End Sub

Public Sub setShadowDx(fValue As Float)
	mShadowDx = fValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getShadowDx As Float
	Return mShadowDx
End Sub

Public Sub setShadowDy(fValue As Float)
	mShadowDy = fValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getShadowDy As Float
	Return mShadowDy
End Sub

Public Sub setShadowColor(iValue As Int)
	mShadowColor = iValue
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getShadowColor As Int
	Return mShadowColor
End Sub

Private Sub CapitalizeWords(sValue As String) As String
	If sValue = Null Or sValue.Length = 0 Then Return ""
	Dim sb As StringBuilder
	sb.Initialize
	Dim capitalizeNext As Boolean = True
	For i = 0 To sValue.Length - 1
		Dim c As String = sValue.SubString2(i, i + 1)
		If c = " " Or c = Chr(9) Or c = CRLF Or c = Chr(10) Or c = Chr(13) Then
			sb.Append(c)
			capitalizeNext = True
		Else
			If capitalizeNext Then
				sb.Append(c.ToUpperCase)
				capitalizeNext = False
			Else
				sb.Append(c.ToLowerCase)
			End If
		End If
	Next
	Return sb.ToString
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub




#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region