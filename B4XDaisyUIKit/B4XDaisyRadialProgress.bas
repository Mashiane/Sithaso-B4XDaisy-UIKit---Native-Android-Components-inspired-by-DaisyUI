B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: None

#DesignerProperty: Key: Value, DisplayName: Value, FieldType: Int, DefaultValue: 0, Description: Current progress value
#DesignerProperty: Key: MinValue, DisplayName: Min Value, FieldType: Int, DefaultValue: 0, Description: Minimum possible value
#DesignerProperty: Key: MaxValue, DisplayName: Max Value, FieldType: Int, DefaultValue: 100, Description: Maximum possible value
#DesignerProperty: Key: StepValue, DisplayName: Step Value, FieldType: Int, DefaultValue: 1, Description: Step size for increments
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: 80px, Description: Tailwind size token or CSS size (eg 20, 80dip, 5rem, 80px)
#DesignerProperty: Key: Thickness, DisplayName: Thickness, FieldType: String, DefaultValue: 10%, Description: Stroke thickness (e.g. 10%, 4dip, 8px)
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|primary|secondary|accent|info|success|warning|error, Description: Semantic color variant
#DesignerProperty: Key: DisplayType, DisplayName: Display Type, FieldType: String, DefaultValue: text, List: text|svg|none, Description: Content shown in the center
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: 0, Description: Base text to show when DisplayType is text
#DesignerProperty: Key: Prefix, DisplayName: Prefix, FieldType: String, DefaultValue:, Description: Text shown before the value
#DesignerProperty: Key: Suffix, DisplayName: Suffix, FieldType: String, DefaultValue: %, Description: Text shown after the value
#DesignerProperty: Key: TextCountUp, DisplayName: Text CountUp, FieldType: Boolean, DefaultValue: False, Description: Animate text value incrementally
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, Description: Duration for Text CountUp in ms
#DesignerProperty: Key: SvgAsset, DisplayName: Svg Asset, FieldType: String, DefaultValue:, Description: SVG file used when DisplayType is svg
#DesignerProperty: Key: TrackColor, DisplayName: Track Color, FieldType: Color, DefaultValue: 0x00000000, Description: Color of the background ring (0 uses default base-200)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color Override, FieldType: Color, DefaultValue: 0x00000000, Description: 0/transparent
#DesignerProperty: Key: TextColor, DisplayName: Text Color Override, FieldType: Color, DefaultValue: 0xFF000000, Description: Default text/arc color
#DesignerProperty: Key: BorderColor, DisplayName: Border Color Override, FieldType: Color, DefaultValue: 0x00000000, Description: 0/variant fallback
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: String, DefaultValue: 0, Description: Outer border width (e.g. 4dip)

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private mWidth As Float = 80dip
	Private mHeight As Float = 80dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False

	Private mValue As Int = 0
	Private mMinValue As Int = 0
	Private mMaxValue As Int = 100
	Private mStepValue As Int = 1
	Private mThickness As String = "10%"
	Private mVariant As String = "none"
	Private mDisplayType As String = "text"
	Private mText As String = "0"
	Private mPrefix As String = ""
	Private mSuffix As String = "%"
	Private mTextCountUp As Boolean = False
	Private mCountUpSpeed As Int = 300
	Private mSvgAsset As String = ""
	
	Private mTrackColor As Int = 0
	Private mBackgroundColor As Int = 0
	Private mTextColor As Int = 0xFF000000
	Private mBorderColor As Int = 0
	Private mBorderWidth As String = "0"

	Private cvs As B4XCanvas
	Private Surface As B4XView
	Private lblText As B4XView
	Private SvgComp As B4XDaisySvgIcon
	Private SvgView As B4XView
	
	' Animation state variables
	Private AnimationTimer As Timer
	Private CurrentAnimatedValue As Float
	Private TargetValue As Float
	Private AnimationStartTime As Long
	Private AnimationDuration As Long
	Private StartAnimatedValue As Float
	
	' Text counter state
	Private cvsTextVal As Float
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
	
	Dim pSurface As Panel
	pSurface.Initialize("surface")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)
	
	cvs.Initialize(Surface)
	
	Dim pText As Label
	pText.Initialize("")
	pText.SingleLine = True
	lblText = pText
	lblText.Color = xui.Color_Transparent
	lblText.SetTextAlignment("CENTER", "CENTER")
	Surface.AddView(lblText, 0, 0, 1dip, 1dip)
	
	Dim sc As B4XDaisySvgIcon
	sc.Initialize(Me, "svgicon")
	SvgComp = sc
	SvgView = SvgComp.AddToParent(Surface, 0, 0, 1dip, 1dip)
	SvgView.Visible = False
	
	ApplyDesignerProps(mProps)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mWidthExplicit = mProps.ContainsKey("Size")
	mHeightExplicit = mWidthExplicit
	Dim sz As Float = Max(16dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Size", "80px"))
	mWidth = sz
	mHeight = sz
	
	mValue = B4XDaisyVariants.GetPropInt(mProps, "Value", mValue)
	mMinValue = B4XDaisyVariants.GetPropInt(mProps, "MinValue", mMinValue)
	mMaxValue = B4XDaisyVariants.GetPropInt(mProps, "MaxValue", mMaxValue)
	If mMinValue > mMaxValue Then
		Dim t_min As Int = mMinValue
		mMinValue = mMaxValue
		mMaxValue = t_min
	End If
	TargetValue = Max(mMinValue, Min(mMaxValue, mValue))
	CurrentAnimatedValue = TargetValue
	cvsTextVal = TargetValue
	
	mStepValue = B4XDaisyVariants.GetPropInt(mProps, "StepValue", mStepValue)
	If mStepValue <= 0 Then mStepValue = 1
	
	mThickness = B4XDaisyVariants.GetPropString(mProps, "Thickness", mThickness)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mDisplayType = B4XDaisyVariants.GetPropString(mProps, "DisplayType", mDisplayType).ToLowerCase.Trim
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mPrefix = B4XDaisyVariants.GetPropString(mProps, "Prefix", mPrefix)
	mSuffix = B4XDaisyVariants.GetPropString(mProps, "Suffix", mSuffix)
	mTextCountUp = B4XDaisyVariants.GetPropBool(mProps, "TextCountUp", mTextCountUp)
	mCountUpSpeed = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "CountUpSpeed", mCountUpSpeed))
	mSvgAsset = B4XDaisyVariants.GetPropString(mProps, "SvgAsset", mSvgAsset)
	
	mTrackColor = B4XDaisyVariants.GetPropInt(mProps, "TrackColor", mTrackColor)
	mBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "BackgroundColor", mBackgroundColor)
	mTextColor = B4XDaisyVariants.GetPropInt(mProps, "TextColor", mTextColor)
	mBorderColor = B4XDaisyVariants.GetPropInt(mProps, "BorderColor", mBorderColor)
	mBorderWidth = B4XDaisyVariants.GetPropString(mProps, "BorderWidth", mBorderWidth)
	
	mValue = Max(mMinValue, Min(mMaxValue, mValue))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Size", ResolvePxSizeSpec(Min(iWidth, iHeight)))
	props.Put("Value", mValue)
	props.Put("MinValue", mMinValue)
	props.Put("MaxValue", mMaxValue)
	props.Put("StepValue", mStepValue)
	props.Put("Thickness", mThickness)
	props.Put("Variant", mVariant)
	props.Put("DisplayType", mDisplayType)
	props.Put("Text", mText)
	props.Put("Prefix", mPrefix)
	props.Put("Suffix", mSuffix)
	props.Put("TextCountUp", mTextCountUp)
	props.Put("Duration", mCountUpSpeed)
	props.Put("SvgAsset", mSvgAsset)
	props.Put("TrackColor", mTrackColor)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("BorderColor", mBorderColor)
	props.Put("BorderWidth", mBorderWidth)
	Return props
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
	Dim w As Int = Max(16dip, iWidth)
	Dim h As Int = Max(16dip, iHeight)
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

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return

    If inResize Then Return
    inResize = True
    Dim availableW As Int = Max(1dip, dWidth)
    Dim availableH As Int = Max(1dip, dHeight)

    ' Always fit inside what the parent actually gave us
    Dim size As Int = Max(1dip, Min(availableW, availableH))

    Dim leftOffset As Int = (availableW - size) / 2
    Dim topOffset As Int = (availableH - size) / 2

    Surface.SetLayoutAnimated(0, leftOffset, topOffset, size, size)

    cvs.Release
    cvs.Initialize(Surface)

    DrawComponent
    inResize = False
End Sub

Public Sub DrawComponent
	If Surface.IsInitialized = False Then Return
	Dim size As Int = Max(1dip, Surface.Width)
	cvs.ClearRect(cvs.TargetRect)
	
	Dim strokeWpx As Float = CalculateThicknessDip(size)
	Dim bw As Float = Max(0, B4XDaisyBoxModel.TailwindSpacingToDip(mBorderWidth, 0dip))
	
	Dim xColors As Map = ResolveVisualColors
	Dim textCol As Int = xColors.Get("text")
	Dim backCol As Int = xColors.Get("back")
	Dim borderCol As Int = xColors.Get("border")
	Dim trackCol As Int = xColors.Get("track")
	
	Dim cx As Float = size / 2
	Dim cy As Float = size / 2
	
	' Render Background and Border natively on the B4XCanvas so we don't destroy the bitmap buffer
	If backCol <> xui.Color_Transparent Then
		cvs.DrawCircle(cx, cy, size / 2, backCol, True, 0)
	End If
	If bw > 0 Then
		cvs.DrawCircle(cx, cy, (size / 2) - (bw / 2), borderCol, False, bw)
	End If
	
	' Render The Rings
	Dim r As Float = (size - strokeWpx) / 2 - bw
	If r < 1 Then r = 1
	
	' Draw Track Ring
	If trackCol <> xui.Color_Transparent Then
		cvs.DrawCircle(cx, cy, r, trackCol, False, strokeWpx)
	End If
	
	' Calculate visual completion percentage
	Dim range As Float = mMaxValue - mMinValue
	If range <= 0 Then range = 1
	Dim pct As Float = (CurrentAnimatedValue - mMinValue) / range
	If pct < 0 Then pct = 0
	If pct > 1 Then pct = 1
	
	' Draw Progress Arc
	If pct >= 1 Then
		cvs.DrawCircle(cx, cy, r, textCol, False, strokeWpx)
	Else If pct > 0 Then
		Dim p As B4XPath
		' Create a pie wedge slightly larger than our stroke to use as a clip mask
		p.InitializeArc(cx, cy, r + strokeWpx, -90, pct * 360)
		cvs.ClipPath(p)
		' Draw the full circle, but only the unmasked wedge portion will render!
		cvs.DrawCircle(cx, cy, r, textCol, False, strokeWpx)
		cvs.RemoveClip
		
		' Draw rounded caps at both start (top) and trailing end of arc
		cvs.DrawCircle(cx, cy - r, strokeWpx / 2, textCol, True, 0)
		Dim endAngle As Float = (-90 + (pct * 360)) * cPI / 180
		cvs.DrawCircle(cx + r * Cos(endAngle), cy + r * Sin(endAngle), strokeWpx / 2, textCol, True, 0)
	End If

	cvs.Invalidate
	
	' Render Center Content
	Dim contentAreaRatio As Float = 1 - ((strokeWpx * 2) / size)
	Dim contentAreaSize As Float = size * contentAreaRatio
	Dim cx_c As Float = cx - (contentAreaSize / 2)
	Dim cy_c As Float = cy - (contentAreaSize / 2)
	
	If mDisplayType = "text" Then
		SvgView.Visible = False
		lblText.Visible = True
		lblText.SetLayoutAnimated(0, cx_c, cy_c, contentAreaSize, contentAreaSize)
		lblText.TextColor = textCol
		
		Dim dsText As String = mText
		If mTextCountUp Or mSuffix = "s" Then
			Dim stepVal As Float = cvsTextVal
			If mStepValue > 1 Then
				stepVal = Round(cvsTextVal / mStepValue) * mStepValue
			Else
				stepVal = Round(cvsTextVal)
			End If
			dsText = NumberFormat2(stepVal, 1, 0, 0, False)
			
			If mSuffix = "s" And mMaxValue > 100 Then
				dsText = NumberFormat(cvsTextVal / 1000, 1, 1)
			End If
		End If
		lblText.Text = $"${mPrefix}${dsText}${mSuffix}"$
		
		' Dynamic font sizing (converted from pixels to SP)
		Dim fontSizePx As Float = contentAreaSize * 0.25
		#If B4A Or B4i
		lblText.Font = xui.CreateDefaultFont(fontSizePx / xui.Scale)
		#Else
		lblText.Font = xui.CreateDefaultFont(fontSizePx)
		#End If
	Else If mDisplayType = "svg" Then
		lblText.Visible = False
		If mSvgAsset.Trim.Length > 0 Then
			SvgView.Visible = True
			Dim iconSize As Int = Max(1dip, contentAreaSize * 0.6)
			Dim icx As Float = cx - (iconSize / 2)
			Dim icy As Float = cy - (iconSize / 2)
			SvgView.SetLayoutAnimated(0, icx, icy, iconSize, iconSize)
			SvgComp.setSvgAsset(mSvgAsset)
			SvgComp.setPreserveOriginalColors(False)
			SvgComp.setColor(textCol)
			SvgComp.setSize(ResolvePxSizeSpec(iconSize))
			SvgComp.ResizeToParent(SvgView)
		Else
			SvgView.Visible = False
		End If
	Else
		lblText.Visible = False
		SvgView.Visible = False
	End If
End Sub

Private Sub ResolveVisualColors As Map
    Dim palette As Map = B4XDaisyVariants.GetVariantPalette
    Dim tokens As Map = B4XDaisyVariants.GetActiveTokens

    Dim fallbackBase200 As Int = xui.Color_RGB(232, 234, 237)
    Dim fallbackBaseContent As Int = xui.Color_Black

    Dim base200 As Int = tokens.GetDefault("--color-base-200", fallbackBase200)
    Dim baseContent As Int = tokens.GetDefault("--color-base-content", fallbackBaseContent)

    Dim text As Int = baseContent
    
    Dim back As Int = xui.Color_Transparent
    Dim border As Int = xui.Color_Transparent
    Dim track As Int = base200

    Dim variantKey As String = B4XDaisyVariants.NormalizeVariant(mVariant)
    If variantKey <> "none" Then
        text = B4XDaisyVariants.ResolveVariantColor(palette, variantKey, "back", text)
    End If

    If mTextColor <> 0 Then text = mTextColor
    If mTrackColor <> 0 Then track = mTrackColor
    If mBackgroundColor <> 0 Then back = mBackgroundColor
    If mBorderColor <> 0 Then border = mBorderColor

    ' IMPORTANT: protect against token/palette returning non-Int which becomes 0 (transparent)
    track = EnsureVisibleStrokeColor(track, fallbackBase200)
    text = EnsureVisibleStrokeColor(text, fallbackBaseContent)
	
    Return CreateMap("text": text, "back": back, "track": track, "border": border)
End Sub


Private Sub CalculateThicknessDip(iSizeDip As Int) As Float
	Dim th As String = mThickness.Trim.ToLowerCase
	If th.EndsWith("%") Then
		Dim pNum As Float = 10
		Try
			pNum = th.Replace("%", "")
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyRadialProgress.CalculateThicknessDip: " & LastException.Message)
		End Try 'ignore
		Return Max(1dip, iSizeDip * (pNum / 100))
	Else
		Return Max(1dip, B4XDaisyBoxModel.TailwindSpacingToDip(th, iSizeDip * 0.1))
	End If
End Sub

Public Sub SetValueAnimated(fNewValue As Float, iDuration As Int)
	fNewValue = Max(mMinValue, Min(mMaxValue, fNewValue))
	If fNewValue = TargetValue Then Return
	
	StopAnimation
	
	TargetValue = fNewValue
	mText = Round(TargetValue)
	StartAnimatedValue = CurrentAnimatedValue
	AnimationDuration = iDuration
	AnimationStartTime = DateTime.Now
	
	If iDuration <= 0 Then
		CurrentAnimatedValue = TargetValue
		cvsTextVal = TargetValue
		DrawComponent
	Else
		If AnimationTimer.IsInitialized = False Then
			AnimationTimer.Initialize("AnimationTimer", 16)
		End If
		AnimationTimer.Enabled = True
	End If
End Sub

Private Sub AnimationTimer_Tick
	Dim t As Long = DateTime.Now - AnimationStartTime
	
	If t >= AnimationDuration Then
		AnimationTimer.Enabled = False
		CurrentAnimatedValue = TargetValue
		cvsTextVal = TargetValue
		DrawComponent
		
		If mSuffix = "s" And mTextCountUp Then
			' When finished animating to 0 from a timer, ensure exact 0.0s is shown
			cvsTextVal = TargetValue
			DrawComponent
		End If
		Return
	End If
	
	Dim pct As Float = t / AnimationDuration
	' Easing out
	pct = 1 - Power(1 - pct, 3)
	
	CurrentAnimatedValue = StartAnimatedValue + (TargetValue - StartAnimatedValue) * pct
	If mTextCountUp Then
		cvsTextVal = StartAnimatedValue + (TargetValue - StartAnimatedValue) * pct
	Else
		cvsTextVal = TargetValue
	End If
	DrawComponent
End Sub

Public Sub StopAnimation
	If AnimationTimer.IsInitialized Then
		AnimationTimer.Enabled = False
	End If
End Sub

Public Sub StartTimer(iDurationMs As Int)
	setMaxValue(iDurationMs)
	setValue(iDurationMs)
	Dim oldSuffix As String = mSuffix
	Dim oldPrefix As String = mPrefix
	Dim oldTextCountUp As Boolean = mTextCountUp
	
	mSuffix = "s"
	mPrefix = ""
	mTextCountUp = True
	
	SetValueAnimated(0, iDurationMs)
	
	' We rely on the developer to reset the suffix/prefix afterwards if needed,
	' which they'll do with the Reset button in our demo.
End Sub

Public Sub getMaxValue As Int
	Return mMaxValue
End Sub

Public Sub setMaxValue(iMaxVal As Int)
	mMaxValue = iMaxVal
	DrawComponent
End Sub

Public Sub getMinValue As Int
	Return mMinValue
End Sub

Public Sub setMinValue(iMinVal As Int)
	mMinValue = iMinVal
	DrawComponent
End Sub

Public Sub getValue As Int
	Return mValue
End Sub

Public Sub setValue(iValue As Int)
	mValue = Max(mMinValue, Min(mMaxValue, iValue))
	mText = mValue
	TargetValue = mValue
	CurrentAnimatedValue = mValue
	cvsTextVal = mValue
	DrawComponent
End Sub

Public Sub setStepValue(iStepVal As Int)
	mStepValue = Max(1, iStepVal)
	DrawComponent
End Sub

Public Sub getStepValue As Int
	Return mStepValue
End Sub

Public Sub setDisplayType(sDType As String)
	mDisplayType = sDType.ToLowerCase.Trim
	DrawComponent
End Sub

Public Sub getDisplayType As String
	Return mDisplayType
End Sub

Public Sub setText(sNewText As String)
	mText = sNewText
	DrawComponent
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setVariant(sNewVariant As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sNewVariant)
	' Reset manual colors to ensure variant colors take full effect. (Last one wins)
	mTextColor = 0
	mBackgroundColor = 0
	mTrackColor = 0
	mBorderColor = 0
	DrawComponent
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setSize(oValue As Object)
	Dim v As Float = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(oValue, Min(mWidth, mHeight)))
	mWidth = v
	mHeight = v
	mWidthExplicit = True
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getSize As Float
	Return mWidth
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setThickness(sNewThickness As String)
	mThickness = sNewThickness
	DrawComponent
End Sub

Public Sub getThickness As String
	Return mThickness
End Sub

Public Sub setSvgAsset(sNewSvgAsset As String)
	mSvgAsset = sNewSvgAsset
	DrawComponent
End Sub

Public Sub getSvgAsset As String
	Return mSvgAsset
End Sub

Public Sub setPrefix(sNewPrefix As String)
	mPrefix = sNewPrefix
	DrawComponent
End Sub

Public Sub getPrefix As String
	Return mPrefix
End Sub

Public Sub setSuffix(sNewSuffix As String)
	mSuffix = sNewSuffix
	DrawComponent
End Sub

Public Sub getSuffix As String
	Return mSuffix
End Sub

Public Sub setTextCountUp(bNewTextCountUp As Boolean)
	mTextCountUp = bNewTextCountUp
	DrawComponent
End Sub

Public Sub getTextCountUp As Boolean
	Return mTextCountUp
End Sub

Public Sub setDuration(iNewCountUpSpeed As Int)
	mCountUpSpeed = iNewCountUpSpeed
End Sub

Public Sub getDuration As Int
	Return mCountUpSpeed
End Sub

' Deprecated aliases (backward compatibility).
Public Sub setCountUpSpeed(iNewCountUpSpeed As Int)
	setDuration(iNewCountUpSpeed)
End Sub

Public Sub getCountUpSpeed As Int
	Return getDuration
End Sub

Public Sub setTrackColor(iNewTrackColor As Int)
	mTrackColor = iNewTrackColor
	DrawComponent
End Sub

Public Sub getTrackColor As Int
	Return mTrackColor
End Sub

Public Sub setBackgroundColor(iNewBackgroundColor As Int)
	mBackgroundColor = iNewBackgroundColor
	DrawComponent
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub





Public Sub setTextColor(iNewTextColor As Int)
	mTextColor = iNewTextColor
	DrawComponent
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub



Public Sub setBorderColor(iNewBorderColor As Int)
	mBorderColor = iNewBorderColor
	DrawComponent
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub





Public Sub setBorderWidth(sNewBorderWidth As String)
	mBorderWidth = sNewBorderWidth
	DrawComponent
End Sub

Public Sub getBorderWidth As String
	Return mBorderWidth
End Sub


Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub IsReady As Boolean
	Return mBase.IsInitialized And Surface.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub










Private Sub EnsureVisibleStrokeColor(iC As Int, iFallback As Int) As Int

    ' If alpha is 0, the stroke is invisible.
    If Bit.And(iC, 0xFF000000) = 0 Then Return iFallback
    Return iC
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

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
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
