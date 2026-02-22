B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
'B4XDaisyDiv.bas
'Versatile container component inspired by HTML div + Tailwind utility classes.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind/spacing padding utilities (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Background color of the container.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Color of the text content.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-sm, Description: Number in dip or Tailwind token (eg 12, text-sm, text-lg).
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Text to display in the container.
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Apply 16px rounded corners.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: none|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius utility.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Shadow depth (elevation).
#DesignerProperty: Key: PlaceContentCenter, DisplayName: Place Content Center, FieldType: Boolean, DefaultValue: False, Description: Center content horizontally and vertically.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Border width in dips.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Border color.
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: solid, List: none|hidden|solid|double|dashed|dotted|groove|ridge|inset|outset, Description: HTML-like border style token.
#DesignerProperty: Key: BorderReliefStrength, DisplayName: Relief Strength, FieldType: Int, DefaultValue: 55, Description: 0-100 strength for groove/ridge/inset/outset shading.
#DesignerProperty: Key: AutoReliefByStyle, DisplayName: Auto Relief By Style, FieldType: Boolean, DefaultValue: True, Description: Use built-in per-style relief presets for groove/ridge/inset/outset.
#DesignerProperty: Key: IsSkeleton, DisplayName: Is Skeleton, FieldType: Boolean, DefaultValue: False, Description: Show skeleton loading state.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI
	
	Private mWidth As Float = 40dip
	Private mHeight As Float = 40dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mTextColor As Int = 0xFF000000
	Private mTextSize As Float = 14dip 'resolved from text-sm
	Private mText As String = ""
	Private mRounded As String = "none"
	Private mRoundedBox As Boolean = False
	Private mShadow As String = "none"
	Private mPlaceContentCenter As Boolean = False
	Private mBorderWidth As Int = 0
	Private mBorderColor As Int = xui.Color_Black
	Private mBorderStyle As String = "solid"
	Private mBorderReliefStrength As Int = 55
	Private mAutoReliefByStyle As Boolean = True
	Private Const RELIEF_PRESET_INSET_OUTSET As Int = 46
	Private Const RELIEF_PRESET_GROOVE_RIDGE As Int = 68
	Private mTag As Object
	Private lblContent As B4XView
	
	'Skeleton Support
	Private mIsSkeleton As Boolean = False
	Private mVariant As String = "none"
	Private pnlSkeleton As B4XView
	Private cvs As B4XCanvas
	
	Private mAnimProgress As Float = 1.5
	Private mAnimTimer As Timer
	Private mAnimDuration As Long = 1800
	Private mAnimStartTime As Long
	Private mSkeletonBaseColor As Int = xui.Color_RGB(209, 213, 219)
	Private mSkeletonShimmerColor As Int = xui.Color_RGB(243, 244, 246)
End Sub


Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	mAnimTimer.Initialize("AnimTimer", 16)
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
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

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
    
    ' Create internal label for text content
    Dim lblInternal As Label
    lblInternal.Initialize("lblContent")
    lblContent = lblInternal
    lblContent.SetTextAlignment("CENTER", "CENTER") 
    mBase.AddView(lblContent, 0, 0, 0, 0) 
    
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mWidthExplicit = Props.ContainsKey("Width")
    mHeightExplicit = Props.ContainsKey("Height")
    mWidth = Max(1dip, GetPropSizeDip(Props, "Width", mWidth))
    mHeight = Max(1dip, GetPropSizeDip(Props, "Height", mHeight))
	mPadding = GetPropString(Props, "Padding", mPadding)
	mMargin = GetPropString(Props, "Margin", mMargin)
    mBackgroundColor = GetPropColor(Props, "BackgroundColor", mBackgroundColor)
    mTextColor = GetPropColor(Props, "TextColor", mTextColor)
    mTextSize = ResolveTextSize(GetPropString(Props, "TextSize", "text-sm"))
    mText = GetPropString(Props, "Text", mText)
    mRounded = GetPropString(Props, "Rounded", mRounded)
    mRoundedBox = GetPropBool(Props, "RoundedBox", mRoundedBox)
    mShadow = B4XDaisyVariants.NormalizeShadow(GetPropString(Props, "Shadow", mShadow))
     mPlaceContentCenter = GetPropBool(Props, "PlaceContentCenter", mPlaceContentCenter)
     mBorderWidth = GetPropInt(Props, "BorderWidth", mBorderWidth)
     mBorderColor = GetPropColor(Props, "BorderColor", mBorderColor)
     mBorderStyle = NormalizeBorderStyle(GetPropString(Props, "BorderStyle", mBorderStyle))
     mBorderReliefStrength = ClampReliefStrength(GetPropInt(Props, "BorderReliefStrength", mBorderReliefStrength))
     mAutoReliefByStyle = GetPropBool(Props, "AutoReliefByStyle", mAutoReliefByStyle)
     mIsSkeleton = GetPropBool(Props, "IsSkeleton", mIsSkeleton)
     mVariant = B4XDaisyVariants.NormalizeVariant(GetPropString(Props, "Variant", mVariant))
     If mVariant <> "none" Then ApplyVariantColors
     ApplyStyle
End Sub







Public Sub Base_Resize (Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    
    ApplyStyle
	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, Width), Max(1dip, Height))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    
    ' Layout children
    For i = 0 To mBase.NumberOfViews - 1
        Dim v As B4XView = mBase.GetView(i)
        
        If v = lblContent Then
            v.Visible = True
            v.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
            If mPlaceContentCenter Then
                v.SetTextAlignment("CENTER", "CENTER")
            Else
                v.SetTextAlignment("TOP", "LEFT")
            End If

        Else If v = pnlSkeleton Then
             'Managed by Base_Resize / DrawSkeleton
             v.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
             If v.IsInitialized Then
                 cvs.Resize(v.Width, v.Height)
                 DrawSkeleton
             End If

        Else
            'Other children
            If mPlaceContentCenter Then
                 v.SetLayoutAnimated(0, contentRect.Left + (contentRect.Width - v.Width) / 2, contentRect.Top + (contentRect.Height - v.Height) / 2, v.Width, v.Height)
            End If
        End If
    Next
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, mPadding, mMargin)
	Return box
End Sub

Private Sub ApplySpacingSpecToBox(Box As Map, PaddingSpec As String, MarginSpec As String)
	Dim rtl As Boolean = False
	Dim p As String = IIf(PaddingSpec = Null, "", PaddingSpec.Trim)
	Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
	If p.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(p, Array As String("p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-")) Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(Box, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			Box.Put("padding_left", pv)
			Box.Put("padding_right", pv)
			Box.Put("padding_top", pv)
			Box.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
			B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			Box.Put("margin_left", mv)
			Box.Put("margin_right", mv)
			Box.Put("margin_top", mv)
			Box.Put("margin_bottom", mv)
		End If
	End If
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(w))
	props.Put("Height", ResolvePxSizeSpec(h))
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

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(ChildView, Left, Top, Width, Height)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Private Sub ApplyStyle
    lblContent.TextColor = mTextColor
    lblContent.TextSize = mTextSize
    lblContent.Text = mText
    ApplyBorderVisual
    ApplyBorderVisual
    ApplyShadow
    ApplySkeletonVisual
End Sub

Private Sub ApplySkeletonVisual
	If mIsSkeleton Then
		EnsureSkeletonPanel
		pnlSkeleton.Visible = True
        pnlSkeleton.BringToFront
		StartAnimation
	Else
		StopAnimation
		If pnlSkeleton.IsInitialized Then
			pnlSkeleton.Visible = False
		End If
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
    DrawBlockSkeleton(w, h)
    cvs.Invalidate
End Sub

Private Sub DrawBlockSkeleton(w As Float, h As Float)
    Dim radius As Float = B4XDaisyVariants.ResolveRoundedRadiusDip(mRounded, Min(w, h))
    If mRoundedBox Then radius = 14dip
    
    ' Draw base rounded rectangle
    Dim basePath As B4XPath
    basePath.InitializeRoundedRect(CreateRect(0, 0, w, h), radius)
    cvs.DrawPath(basePath, mSkeletonBaseColor, True, 0)
    
    Dim shimmerCenter As Float = mAnimProgress * w
    Dim shimmerWidth As Float = w * 0.2
    Dim numStrips As Int = 30
    Dim stripW As Float = shimmerWidth * 2 / numStrips
    Dim skew As Float = h

    ' ---- SAVE & CLIP the native canvas to the rounded rect ----
    #If B4A
    Dim jo As JavaObject = cvs
    Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")       ' B4XCanvas → B4A Canvas
    Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas") ' B4A Canvas → android.graphics.Canvas
    
    Dim clipPath As JavaObject
    clipPath.InitializeNewInstance("android.graphics.Path", Null)
    Dim f0 As Float = 0
    Dim rectF As JavaObject
    rectF.InitializeNewInstance("android.graphics.RectF", Array(f0, f0, w, h))
    Dim pathDir As JavaObject
    pathDir.InitializeStatic("android.graphics.Path.Direction")
    clipPath.RunMethod("addRoundRect", Array(rectF, radius, radius, pathDir.GetField("CW")))
    
    nativeCanvas.RunMethod("save", Null)
    nativeCanvas.RunMethod("clipPath", Array(clipPath))
    #End If
    
    ' Draw shimmer strips (now clipped automatically)
    For i = 0 To numStrips - 1
        Dim stripX As Float = shimmerCenter - shimmerWidth + (i * stripW)
        If stripX + stripW + skew < 0 Or stripX > w Then Continue
        
        Dim distFromCenter As Float = Abs((i - numStrips / 2.0) / (numStrips / 2.0))
        Dim alpha As Int = Max(0, 255 * (1 - distFromCenter * distFromCenter))
        Dim stripColor As Int = SetAlpha(mSkeletonShimmerColor, alpha)
        
        Dim p As B4XPath
        p.Initialize(stripX + skew, 0)
        p.LineTo(stripX + skew + stripW, 0)
        p.LineTo(stripX + stripW, h)
        p.LineTo(stripX, h)
        cvs.DrawPath(p, stripColor, True, 0)
    Next
    
    ' ---- RESTORE canvas (removes the clip) ----
    #If B4A
    nativeCanvas.RunMethod("restore", Null)
    #End If
End Sub


Private Sub SetAlpha (Color As Int, Alpha As Int) As Int
    Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
    Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
    Dim b As Int = Bit.And(Color, 0xFF)
    Return Bit.Or(Bit.ShiftLeft(Alpha, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Private Sub CreateRect(Left As Float, Top As Float, Right As Float, Bottom As Float) As B4XRect
	Dim r As B4XRect
	r.Initialize(Left, Top, Right, Bottom)
	Return r
End Sub





Private Sub ApplyBorderVisual
	Dim bw As Int = Max(0, mBorderWidth)
	Dim radius As Float
	If mRoundedBox Then
		radius = 8dip
	Else If mRounded <> "none" Then
		radius = B4XDaisyVariants.ResolveRoundedRadiusDip(mRounded, Min(mBase.Width, mBase.Height))
	Else
		radius = 0
	End If
	Dim style As String = NormalizeBorderStyle(mBorderStyle)
	
	If style = "none" Or style = "hidden" Or bw = 0 Then
		mBase.SetColorAndBorder(mBackgroundColor, 0, xui.Color_Transparent, radius)
		Return
	End If
	
	#If B4A
	Try
		Select Case style
			Case "solid"
				ApplySingleStrokeNative(bw, mBorderColor, radius, 0, 0)
				Return
			Case "dashed"
				ApplySingleStrokeNative(bw, mBorderColor, radius, Max(4dip, bw * 3), Max(3dip, bw * 2))
				Return
			Case "dotted"
				Dim dotW As Int = Max(1dip, bw)
				ApplySingleStrokeNative(dotW, mBorderColor, radius, dotW, Max(2dip, dotW * 1.5))
				Return
			Case "double"
				If ApplyDoubleBorderNative(bw, mBorderColor, radius) Then Return
			Case "groove"
				If ApplyGrooveRidgeNative(True, bw, mBorderColor, radius) Then Return
			Case "ridge"
				If ApplyGrooveRidgeNative(False, bw, mBorderColor, radius) Then Return
			Case "inset"
				If ApplyInsetOutsetNative(True, bw, mBorderColor, radius) Then Return
			Case "outset"
				If ApplyInsetOutsetNative(False, bw, mBorderColor, radius) Then Return
		End Select
		'Fallback branch for unknown style token on B4A
		ApplySingleStrokeNative(bw, mBorderColor, radius, 0, 0)
		Return
	Catch
	End Try
#End If
	
	mBase.SetColorAndBorder(mBackgroundColor, bw, mBorderColor, radius)
End Sub

#If B4A
Private Sub ApplySingleStrokeNative(StrokeWidth As Int, StrokeColor As Int, Radius As Float, DashWidth As Float, DashGap As Float)
	Dim gd As JavaObject = CreateSolidDrawable(mBackgroundColor, Radius, 0, 0)
	If DashWidth > 0 And DashGap > 0 Then
		gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor, DashWidth, DashGap))
	Else
		gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor))
	End If
	SetNativeBackground(gd)
End Sub

Private Sub ApplyDoubleBorderNative(BorderWidth As Int, BorderColor As Int, Radius As Float) As Boolean
	If BorderWidth <= 1dip Then
		ApplySingleStrokeNative(BorderWidth, BorderColor, Radius, 0, 0)
		Return True
	End If
	Dim lineW As Int = Max(1dip, BorderWidth / 3)
	Dim gapW As Int = Max(1dip, BorderWidth - (lineW * 2))
	Dim innerInset As Int = lineW + gapW

	Dim baseFill As JavaObject = CreateSolidDrawable(mBackgroundColor, Radius, 0, 0)
	Dim outerStroke As JavaObject = CreateSolidDrawable(xui.Color_Transparent, Radius, lineW, BorderColor)
	Dim innerRadius As Float = Max(0, Radius - innerInset)
	Dim innerStroke As JavaObject = CreateSolidDrawable(xui.Color_Transparent, innerRadius, lineW, BorderColor)

	Dim layers(3) As Object
	layers(0) = baseFill
	layers(1) = outerStroke
	layers(2) = innerStroke
	Dim ld As JavaObject
	ld.InitializeNewInstance("android.graphics.drawable.LayerDrawable", Array(layers))
	ld.RunMethod("setLayerInset", Array(2, innerInset, innerInset, innerInset, innerInset))
	SetNativeBackground(ld)
	Return True
End Sub

Private Sub ApplyInsetOutsetNative(IsInset As Boolean, BorderWidth As Int, BorderColor As Int, Radius As Float) As Boolean
	Dim styleName As String
	If IsInset Then
		styleName = "inset"
	Else
		styleName = "outset"
	End If
	Dim factors As Map = ResolveReliefFactors(styleName, False)
	Dim dark As Int = ShiftColor(BorderColor, factors.Get("dark"))
	Dim light As Int = ShiftColor(BorderColor, factors.Get("light"))
	Dim c1 As Int
	Dim c2 As Int
	If IsInset Then
		c1 = dark : c2 = light
	Else
		c1 = light : c2 = dark
	End If

	Dim outerGrad As JavaObject = CreateGradientFillDrawable(c1, c2, Radius)
	Dim innerRadius As Float = Max(0, Radius - BorderWidth)
	Dim innerFill As JavaObject = CreateSolidDrawable(mBackgroundColor, innerRadius, 0, 0)

	Dim layers(2) As Object
	layers(0) = outerGrad
	layers(1) = innerFill
	Dim ld As JavaObject
	ld.InitializeNewInstance("android.graphics.drawable.LayerDrawable", Array(layers))
	ld.RunMethod("setLayerInset", Array(1, BorderWidth, BorderWidth, BorderWidth, BorderWidth))
	SetNativeBackground(ld)
	Return True
End Sub

Private Sub ApplyGrooveRidgeNative(IsGroove As Boolean, BorderWidth As Int, BorderColor As Int, Radius As Float) As Boolean
	If BorderWidth <= 1dip Then
		ApplySingleStrokeNative(BorderWidth, BorderColor, Radius, 0, 0)
		Return True
	End If

	Dim styleName As String
	If IsGroove Then
		styleName = "groove"
	Else
		styleName = "ridge"
	End If
	Dim factors As Map = ResolveReliefFactors(styleName, True)
	Dim dark As Int = ShiftColor(BorderColor, factors.Get("dark"))
	Dim light As Int = ShiftColor(BorderColor, factors.Get("light"))
	Dim outerA As Int
	Dim outerB As Int
	Dim innerA As Int
	Dim innerB As Int
	If IsGroove Then
		outerA = dark : outerB = light
		innerA = light : innerB = dark
	Else
		outerA = light : outerB = dark
		innerA = dark : innerB = light
	End If

	Dim outerW As Int = Max(1dip, BorderWidth / 2)
	Dim innerW As Int = Max(1dip, BorderWidth - outerW)
	Dim totalInset As Int = outerW + innerW

	Dim outerGrad As JavaObject = CreateGradientFillDrawable(outerA, outerB, Radius)
	Dim innerRadius As Float = Max(0, Radius - outerW)
	Dim innerGrad As JavaObject = CreateGradientFillDrawable(innerA, innerB, innerRadius)
	Dim fillRadius As Float = Max(0, Radius - totalInset)
	Dim centerFill As JavaObject = CreateSolidDrawable(mBackgroundColor, fillRadius, 0, 0)

	Dim layers(3) As Object
	layers(0) = outerGrad
	layers(1) = innerGrad
	layers(2) = centerFill
	Dim ld As JavaObject
	ld.InitializeNewInstance("android.graphics.drawable.LayerDrawable", Array(layers))
	ld.RunMethod("setLayerInset", Array(1, outerW, outerW, outerW, outerW))
	ld.RunMethod("setLayerInset", Array(2, totalInset, totalInset, totalInset, totalInset))
	SetNativeBackground(ld)
	Return True
End Sub

Private Sub CreateSolidDrawable(FillColor As Int, Radius As Float, StrokeWidth As Int, StrokeColor As Int) As JavaObject
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setShape", Array(0)) 'RECTANGLE
	gd.RunMethod("setColor", Array(FillColor))
	gd.RunMethod("setCornerRadius", Array(Radius))
	If StrokeWidth > 0 Then gd.RunMethod("setStroke", Array(StrokeWidth, StrokeColor))
	Return gd
End Sub

Private Sub CreateGradientFillDrawable(ColorStart As Int, ColorEnd As Int, Radius As Float) As JavaObject
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setShape", Array(0)) 'RECTANGLE
	Dim orient As JavaObject
	orient.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
	gd.RunMethod("setOrientation", Array(orient.GetField("TL_BR")))
	Dim cols(2) As Int
	cols(0) = ColorStart
	cols(1) = ColorEnd
	gd.RunMethod("setColors", Array(cols))
	gd.RunMethod("setCornerRadius", Array(Radius))
	Return gd
End Sub

Private Sub SetNativeBackground(Drawable As JavaObject)
	Dim jo As JavaObject = mBase
	jo.RunMethod("setBackground", Array(Drawable))
End Sub
#End If

Private Sub ApplyShadow
    Dim e As Float = B4XDaisyVariants.ResolveShadowElevation(mShadow)
    #If B4A
    Dim p As Panel = mBase
    p.Elevation = e
    #End If
End Sub

'Getters and Setters

Public Sub setWidth(Value As Object)
    mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
    mWidthExplicit = True
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As Object
    Return mWidth
End Sub

Public Sub setHeight(Value As Object)
    mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
    mHeightExplicit = True
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As Object
	Return mHeight
End Sub

Public Sub setPadding(Value As String)
	mPadding = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	ApplyStyle
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	ApplyStyle
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setBackgroundColor(Color As Int)
	mBackgroundColor = Color
	If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
    Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(VariantName, mBackgroundColor)
    setBackgroundColor(c)
End Sub

Public Sub setTextColor(Color As Int)
    mTextColor = Color
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getTextColor As Int
    Return mTextColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
    Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(VariantName, mTextColor)
    setTextColor(c)
End Sub

Public Sub setVariant(Value As String)
    mVariant = B4XDaisyVariants.NormalizeVariant(Value)
    ' Reset colors to defaults to ensure variant colors take full effect.
    mTextColor = 0xFF000000
    mBackgroundColor = xui.Color_Transparent
    If mBase.IsInitialized = False Then Return
    ApplyVariantColors
    ApplyStyle
End Sub

Public Sub getVariant As String
    Return mVariant
End Sub

Private Sub ApplyVariantColors
    If mVariant = "none" Then Return
    Dim p As Map = B4XDaisyVariants.GetVariantPalette
    mBackgroundColor = B4XDaisyVariants.ResolveVariantColor(p, mVariant, "back", mBackgroundColor)
    mTextColor = B4XDaisyVariants.ResolveVariantColor(p, mVariant, "text", mTextColor)
End Sub

Public Sub setTextSize(Value As Object)
    mTextSize = ResolveTextSize(Value)
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getTextSize As Float
    Return mTextSize
End Sub

Private Sub ResolveTextSize(Value As Object) As Float
    If Value = Null Then Return 16dip
    If IsNumber(Value) Then Return Max(1, Value)
    Dim s As String = Value
    s = s.Trim
    If s.Length = 0 Then Return 16dip
    If IsNumber(s) Then Return Max(1, s)
    Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(s, 16dip, 16dip * 1.4)
    Return Max(1, tm.GetDefault("font_size", 16dip))
End Sub

Public Sub setText(Text As String)
    mText = Text
    If mBase.IsInitialized = False Then Return
    ApplyStyle
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getText As String
    Return mText
End Sub

Public Sub setRoundedBox(Value As Boolean)
    mRoundedBox = Value
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getRoundedBox As Boolean
    Return mRoundedBox
End Sub



Public Sub setRounded(Value As String)
    mRounded = IIf(Value = Null, "none", Value)
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub



Public Sub setShadow(Value As String)
    mShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setPlaceContentCenter(Value As Boolean)
    mPlaceContentCenter = Value
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPlaceContentCenter As Boolean
    Return mPlaceContentCenter
End Sub

Public Sub setBorderWidth(Value As Int)
    mBorderWidth = Value
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getBorderWidth As Int
    Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
    mBorderColor = Value
    If mBase.IsInitialized = False Then Return
    ApplyStyle
End Sub

Public Sub getBorderColor As Int
    Return mBorderColor
End Sub

Public Sub setBorderColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveBorderColorVariant(VariantName, mBorderColor)
	setBorderColor(c)
End Sub

Public Sub setBorderStyle(Value As String)
	mBorderStyle = NormalizeBorderStyle(Value)
	If mBase.IsInitialized = False Then Return
	ApplyStyle
End Sub

Public Sub getBorderStyle As String
	Return mBorderStyle
End Sub

Public Sub setBorderReliefStrength(Value As Int)
	mBorderReliefStrength = ClampReliefStrength(Value)
	If mBase.IsInitialized = False Then Return
	ApplyStyle
End Sub

Public Sub getBorderReliefStrength As Int
	Return mBorderReliefStrength
End Sub

Public Sub setAutoReliefByStyle(Value As Boolean)
	mAutoReliefByStyle = Value
	If mBase.IsInitialized = False Then Return
	ApplyStyle
End Sub

Public Sub getAutoReliefByStyle As Boolean
	Return mAutoReliefByStyle
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setIsSkeleton(Value As Boolean)
	If mIsSkeleton = Value Then Return
	mIsSkeleton = Value
	If mBase.IsInitialized = False Then Return
	ApplyStyle
End Sub

Public Sub getIsSkeleton As Boolean
	Return mIsSkeleton
End Sub

' Helpers

Private Sub ResolveWidthBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Width > 0 Then Return parent.Width
		If mBase.Width > 0 Then Return mBase.Width
	End If
	Return DefaultValue
End Sub

Private Sub ResolveHeightBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Height > 0 Then Return parent.Height
		If mBase.Height > 0 Then Return mBase.Height
	End If
	Return DefaultValue
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
    If Props.ContainsKey(Key) = False Then Return DefaultDipValue
    Dim o As Object = Props.Get(Key)
    Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
End Sub

Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
    If Props.ContainsKey(Key) = False Then Return DefaultValue
    Return xui.PaintOrColorToColor(Props.Get(Key))
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
    Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
    Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
    Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub NormalizeBorderStyle(Value As String) As String
	If Value = Null Then Return "solid"
	Dim s As String = Value.ToLowerCase.Trim
	Select Case s
		Case "none", "hidden", "solid", "double", "dashed", "dotted", "groove", "ridge", "inset", "outset"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

Private Sub ClampReliefStrength(Value As Int) As Int
	Return Max(0, Min(100, Value))
End Sub

Private Sub ResolveReliefFactors(StyleName As String, Strong As Boolean) As Map
	Dim effectiveStrength As Int = EffectiveReliefStrength(StyleName, Strong)
	Dim t As Float = ClampReliefStrength(effectiveStrength) / 100
	If Strong = False Then t = t * 0.82
	Dim darkFactor As Float = 1 - (0.42 * t)
	Dim lightFactor As Float = 1 + (0.34 * t)
	Return CreateMap("dark": darkFactor, "light": lightFactor)
End Sub

Private Sub EffectiveReliefStrength(StyleName As String, Strong As Boolean) As Int
	Dim manual As Int = ClampReliefStrength(mBorderReliefStrength)
	If mAutoReliefByStyle = False Then Return manual
	
	Dim s As String = NormalizeBorderStyle(StyleName)
	Select Case s
		Case "inset", "outset"
			Return RELIEF_PRESET_INSET_OUTSET
		Case "groove", "ridge"
			Return RELIEF_PRESET_GROOVE_RIDGE
		Case Else
			If Strong Then
				Return Max(manual, RELIEF_PRESET_GROOVE_RIDGE)
			Else
				Return Max(manual, RELIEF_PRESET_INSET_OUTSET)
			End If
	End Select
End Sub

Private Sub ShiftColor(Color As Int, Factor As Float) As Int
	Dim a As Int = Bit.And(Bit.ShiftRight(Color, 24), 0xFF)
	Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
	Dim b As Int = Bit.And(Color, 0xFF)
	r = Max(0, Min(255, r * Factor))
	g = Max(0, Min(255, g * Factor))
	b = Max(0, Min(255, b * Factor))
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Private Sub lblContent_Click
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

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
