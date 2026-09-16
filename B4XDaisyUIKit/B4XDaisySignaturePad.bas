B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
' B4XDaisySignaturePad
' Inspired by szimek/signature_pad and standard B4X Canvas Signature
' Follows B4XDaisyUIKit Component Development Standards

#IgnoreWarnings:12,9

#Region Events
#Event: BeginStroke
#Event: EndStroke
#Event: Changed
#End Region

#Region Designer Properties
#DesignerProperty: Key: PenColor, DisplayName: Pen Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Color used to draw the lines.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Canvas background color (0 uses theme/transparent).
#DesignerProperty: Key: MinWidth, DisplayName: Min Width, FieldType: Float, DefaultValue: 1.5, Description: Minimum width of a line.
#DesignerProperty: Key: MaxWidth, DisplayName: Max Width, FieldType: Float, DefaultValue: 4.0, Description: Maximum width of a line.
#DesignerProperty: Key: VelocityFilterWeight, DisplayName: Velocity Filter Weight, FieldType: Float, DefaultValue: 0.7, Description: Weight used to modify velocity.
#DesignerProperty: Key: Variant, DisplayName: Variant (Border), FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic variant for the border.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Border radius token.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow level.
#DesignerProperty: Key: BitMapFormat, DisplayName: BitMap Format, FieldType: String, DefaultValue: png, List: png|jpg|webp|bmp, Description: Format of the exported signature bitmap (png, jpg, webp, bmp).
#DesignerProperty: Key: BitMapQuality, DisplayName: BitMap Quality, FieldType: Int, DefaultValue: 100, Description: Quality of the exported signature bitmap (0-100).
#DesignerProperty: Key: DisallowParentIntercept, DisplayName: Disallow Parent Intercept, FieldType: Boolean, DefaultValue: True, Description: Prevent parent scroll containers from stealing touch gestures on Android.
#DesignerProperty: Key: StrokeCap, DisplayName: Stroke Cap, FieldType: String, DefaultValue: ROUND, List: BUTT|ROUND|SQUARE, Description: Shape of line endpoints - ROUND gives a natural pen feel, BUTT is flat, SQUARE extends slightly past the end.
#DesignerProperty: Key: StrokeJoin, DisplayName: Stroke Join, FieldType: String, DefaultValue: ROUND, List: BEVEL|MITER|ROUND, Description: Shape at line segment corners - ROUND gives smooth curves, MITER is sharp, BEVEL is flat.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables or disables drawing.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the component.
#DesignerProperty: Key: FieldsetMode, DisplayName: Fieldset Mode, FieldType: Boolean, DefaultValue: False, Description: When True, disable own border/background/shadow so a fieldset wrapper can provide them.
#DesignerProperty: Key: MinHeight, DisplayName: Min Height, FieldType: Int, DefaultValue: 150, Description: Minimum height in dip when used standalone.
#DesignerProperty: Key: HintText, DisplayName: Hint Text, FieldType: String, DefaultValue:, Description: Watermark text shown when empty.
#DesignerProperty: Key: HintColor, DisplayName: Hint Color, FieldType: Color, DefaultValue: 0x00000000, Description: Watermark text color (0 = theme text color at 40%).
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' UI Layers
	Private pnlSurface As B4XView
	Private cvs As B4XCanvas
	Private CanvasReady As Boolean = False

	' Properties mapping szimek/signature_pad API
	Private mcBackgroundColor As Int = xui.Color_White

	' Public default properties
	Public StrokeWidth As Float = 2dip
	Public StrokeColor As Int = xui.Color_Black
	Private mfMinWidth As Float = 1.5dip
	Private mfMaxWidth As Float = 4.0dip
	Private mfVelocityFilterWeight As Float = 0.7
    
	' DaisyUI standard properties
	Private msVariant As String = "none"
	Private msRounded As String = "theme"
	Private msShadow As String = "none"
	Private mbEnabled As Boolean = True
	Private mbVisible As Boolean = True

	' Image export configuration properties
	Private msBitMapFormat As String = "png"
	Private miBitMapQuality As Int = 100
	Private mbDisallowParentIntercept As Boolean = True

	' Stroke style properties (B4A Paint equivalents of HTML Canvas lineCap / lineJoin)
	Private msStrokeCap As String = "ROUND"
	Private msStrokeJoin As String = "ROUND"

	' Fieldset Mode & Hint
	Private mbFieldsetMode As Boolean = False
	Private miMinHeight As Int = 150
	Private msHintText As String = ""
	Private mcHintColor As Int = 0

	' Interaction State Tracking
	Private LastX As Float
	Private LastY As Float
	' Anchor point for the current quadratic Bezier segment. This is the
	' midpoint we last drew up to, so the next curve starts where the
	' previous one ended and the stroke stays continuous and smooth.
	Private AnchorX As Float
	Private AnchorY As Float
	Private LastVelocity As Float
	Private LastWidth As Float
	Private mLastTime As Long = 0				' Timestamp (ms) of the previous touch sample - used to compute true px/ms velocity
	Private mPointsCount As Int = 0
	Private mIsDrawing As Boolean = False
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pSurface As Panel
	pSurface.Initialize("Surface")
	pnlSurface = pSurface
	pnlSurface.Color = xui.Color_Transparent
	mBase.AddView(pnlSurface, 0, 0, mBase.Width, mBase.Height)

	ApplyDesignerProps(mProps)
	Refresh
End Sub

''' <summary>
''' Programmatic creation.
''' </summary>
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("mBase")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, BuildRuntimeProps)
	Return mBase
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	StrokeColor = B4XDaisyVariants.GetPropColor(mProps, "PenColor", StrokeColor)
	mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
	mfMinWidth = B4XDaisyVariants.GetPropFloat(mProps, "MinWidth", 1.5) * 1dip
	mfMaxWidth = B4XDaisyVariants.GetPropFloat(mProps, "MaxWidth", 4.0) * 1dip
	mfVelocityFilterWeight = B4XDaisyVariants.GetPropFloat(mProps, "VelocityFilterWeight", 0.7)
    
	msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
	msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded)

	' Backward compatibility: migrate legacy RoundedBox=True designer prop
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (msRounded = "theme" Or msRounded = "") Then
	        msRounded = "rounded-box"
	    End If
	End If
	msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
	msBitMapFormat = B4XDaisyVariants.GetPropString(mProps, "BitMapFormat", msBitMapFormat)
	miBitMapQuality = B4XDaisyVariants.GetPropInt(mProps, "BitMapQuality", miBitMapQuality)
	mbDisallowParentIntercept = B4XDaisyVariants.GetPropBool(mProps, "DisallowParentIntercept", mbDisallowParentIntercept)
	msStrokeCap = B4XDaisyVariants.GetPropString(mProps, "StrokeCap", msStrokeCap).ToUpperCase
	msStrokeJoin = B4XDaisyVariants.GetPropString(mProps, "StrokeJoin", msStrokeJoin).ToUpperCase
	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)

	mbFieldsetMode = B4XDaisyVariants.GetPropBool(mProps, "FieldsetMode", mbFieldsetMode)
	miMinHeight = B4XDaisyVariants.GetPropInt(mProps, "MinHeight", miMinHeight)
	msHintText = B4XDaisyVariants.GetPropString(mProps, "HintText", "")
	mcHintColor = B4XDaisyVariants.GetPropColor(mProps, "HintColor", mcHintColor)
End Sub

Private Sub BuildRuntimeProps As Map
	Return CreateMap( _
        "PenColor": StrokeColor, _
        "BackgroundColor": mcBackgroundColor, _
        "MinWidth": mfMinWidth / 1dip, _
        "MaxWidth": mfMaxWidth / 1dip, _
        "VelocityFilterWeight": mfVelocityFilterWeight, _
        "Variant": msVariant, _
        "Rounded": msRounded, _
        "Shadow": msShadow, _
        "BitMapFormat": msBitMapFormat, _
        "BitMapQuality": miBitMapQuality, _
        "DisallowParentIntercept": mbDisallowParentIntercept, _
        "StrokeCap": msStrokeCap, _
        "StrokeJoin": msStrokeJoin, _
        "Enabled": mbEnabled, _
        "Visible": mbVisible, _
        "FieldsetMode": mbFieldsetMode, _
        "MinHeight": miMinHeight, _
        "HintText": msHintText, _
        "HintColor": mcHintColor)
End Sub
#End Region

#Region Drawing and Layout
''' <summary>
''' Resizes the layout and reinitializes the canvas. Note: automatic canvas resizing clears current drawings.
''' </summary>
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or pnlSurface.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)

	' Inset canvas surface by 1dip so mBase's border is revealed around it
	Dim inset As Int = 1dip
	Dim sx As Int = inset
	Dim sy As Int = inset
	Dim sw As Int = Max(1dip, w - 2 * inset)
	Dim sh As Int = Max(1dip, h - 2 * inset)

	pnlSurface.SetLayoutAnimated(0, sx, sy, sw, sh)

	If CanvasReady = False Then
		cvs.Initialize(pnlSurface)
		CanvasReady = True
		ApplyPaintStyle
		Clear
	Else
		' ponytail: only resize+clear when dimensions actually changed.
		' Same-size refreshes (Save, Validate, theme) must not wipe the ink.
		' Ceiling: if B4XCanvas ever changes how TargetRect reports size this guard needs revisiting.
		If sw <> cvs.TargetRect.Width Or sh <> cvs.TargetRect.Height Then
			cvs.Resize(sw, sh)
			ApplyPaintStyle
			Clear
		End If
	End If
	inResize = False
End Sub

Private Sub ResolveCornerRadiusDip As Float
	Dim mode As String = B4XDaisyVariants.NormalizeRounded(msRounded)
	If mode = "theme" Then
		If msRounded = "rounded-box" Or msRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
		Return 0
	End If
	Return B4XDaisyVariants.ResolveRoundedDip(mode, B4XDaisyVariants.GetRadiusBoxDip(8dip))
End Sub

''' <summary>
''' Applies the current component state, borders, themes, and shadow to the UI.
''' </summary>
Public Sub Refresh
	If mBase.IsInitialized = False Then Return

	Dim radius As Int = ResolveCornerRadiusDip

	' FieldsetMode: the fieldset wrapper owns the outer border/shadow, but the
	' pad still rounds its own canvas area when RoundedBox is set, clipping the
	' background + ink to a rounded rect with a slight gray border.
	If mbFieldsetMode Then
		Dim fsBg As Int = IIf(mcBackgroundColor <> 0, mcBackgroundColor, xui.Color_Transparent)
		Dim fsBorder As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(209, 213, 219))
		mBase.SetColorAndBorder(fsBg, 1dip, fsBorder, radius)
		B4XDaisyVariants.SetOverflowHidden(mBase)
		mBase.Enabled = mbEnabled
		mBase.Visible = mbVisible
		mBase.Alpha = IIf(mbEnabled, 1.0, 0.4)
		If CanvasReady = False And mBase.Width > 0 Then
			Base_Resize(mBase.Width, Max(miMinHeight * 1dip, mBase.Height))
		End If
		DrawHint
		Return
	End If

	Dim base200 As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(229, 231, 235))
	Dim borderColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(209, 213, 219))
	Dim bgColor As Int = IIf(mcBackgroundColor <> 0, mcBackgroundColor, base200)

	If msVariant <> "none" Then
		borderColor = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, borderColor)
	End If

	mBase.SetColorAndBorder(bgColor, 1dip, borderColor, radius)
	B4XDaisyVariants.ApplyElevation(mBase, msShadow)
	B4XDaisyVariants.SetOverflowHidden(mBase)

	mBase.Enabled = mbEnabled
	mBase.Visible = mbVisible
	mBase.Alpha = IIf(mbEnabled, 1.0, 0.4)

	If CanvasReady = False And mBase.Width > 0 Then
		Base_Resize(mBase.Width, mBase.Height)
	End If
	DrawHint
End Sub

' Draws the watermark hint text on the canvas when the pad is empty.
' Action buttons (Save/Cancel) live on the B4XDaisySignature wrapper, not here.
Private Sub DrawHint
	If CanvasReady = False Then Return
	' Hint text - only when no strokes exist
	If mPointsCount = 0 And msHintText.Length > 0 Then
		Dim hintCol As Int = mcHintColor
		If hintCol = 0 Then hintCol = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(64, 64, 64))
		hintCol = xui.Color_ARGB(100, Bit.And(Bit.ShiftRight(hintCol, 16), 0xFF), _
									Bit.And(Bit.ShiftRight(hintCol, 8), 0xFF), _
									Bit.And(hintCol, 0xFF))
		Dim fnt As B4XFont = xui.CreateDefaultFont(14)
		cvs.DrawText(msHintText, cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, fnt, hintCol, "CENTER")
		cvs.Invalidate
	End If
End Sub

Public Sub UpdateTheme
	If mBase.IsInitialized Then Refresh
End Sub
#End Region

#Region Interaction Logic
Private Sub Surface_Touch(iAction As Int, fX As Float, fY As Float)
	#If B4A
	If mbDisallowParentIntercept Then B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
	#End If
	If mbEnabled = False Then Return
    
	Select Case iAction
		Case pnlSurface.TOUCH_ACTION_DOWN
			mIsDrawing = True
			LastX = fX
			LastY = fY
			AnchorX = fX
			AnchorY = fY
			LastVelocity = 0
			mLastTime = DateTime.Now
			If StrokeWidth > 0 Then LastWidth = StrokeWidth Else LastWidth = (mfMinWidth + mfMaxWidth) / 2
            
			RaiseEvent("BeginStroke")
            
			' Draw initial dot
			cvs.DrawLine(fX, fY, fX, fY, StrokeColor, LastWidth)
			cvs.Invalidate
            
		Case pnlSurface.TOUCH_ACTION_MOVE
			If mIsDrawing = False Then Return
            
			' Compute pixel distance since the last touch sample.
			Dim distance As Float = Sqrt(Power(fX - LastX, 2) + Power(fY - LastY, 2))
			' Jitter guard: skip nearly-stationary samples.
			' Multiple DrawQuadBezier calls at the same pixel produce overlapping
			' strokes that render as dark splotches - most visible in variable-width
			' mode. 1 physical pixel is the minimum distance that produces new pixels.
			If distance < 1 Then Return
			' Divide by elapsed milliseconds for true velocity (px/ms).
			' This normalises across devices with different touch sample rates
			' (60 Hz vs 120 Hz) - the same physical swipe speed now always
			' produces the same velocity value, fixing the device-dependent
			' width behaviour identified by Square's research.
			' Max(1,...) guards against duplicate timestamps on very fast events.
			Dim now As Long = DateTime.Now
			Dim deltaMs As Long = Max(1, now - mLastTime)
			Dim velocity As Float = distance / deltaMs
			mLastTime = now
            
			' Low-pass filter to smooth velocity spikes.
			Dim newVelocity As Float = (mfVelocityFilterWeight * velocity) + ((1 - mfVelocityFilterWeight) * LastVelocity)
			' Resolve stroke widths for this segment.
			' In fixed-width mode start and end are identical.
			' In variable-width mode the Bezier tapers from the previous segment's
			' final width (segStartW) to the newly computed width (segEndW), so the
			' stroke swells and thins *within* each curve - the fountain-pen effect
			' described in Square's "Smoother Signatures" article.
			' The factor 2.5 is calibrated for px/ms velocities: at ~3 px/ms a
			' fast swipe reaches mfMinWidth; at rest the stroke stays at mfMaxWidth.
			' NOTE: local vars avoid shadowing the public StrokeWidth field
			' (B4X identifiers are case-insensitive).
			Dim segStartW As Float
			Dim segEndW As Float
			If StrokeWidth > 0 Then
				segStartW = StrokeWidth
				segEndW   = StrokeWidth
			Else
				Dim newWidth As Float = Max(mfMinWidth, Min(mfMaxWidth, mfMaxWidth - (newVelocity * 2.5)))
				segStartW = LastWidth	' start from where last segment ended
				segEndW   = newWidth	' taper to the velocity-derived width
				LastWidth = newWidth
			End If
			' Smooth the stroke with a quadratic Bezier (szimek/signature_pad technique):
			' draw from the previous midpoint anchor to the new midpoint, using the
			' last raw touch point as the control. Width tapers from segStartW to
			' segEndW within the segment for a continuous, natural-looking line.
			Dim midX As Float = (LastX + fX) / 2
			Dim midY As Float = (LastY + fY) / 2
			DrawQuadBezier(AnchorX, AnchorY, LastX, LastY, midX, midY, segStartW, segEndW)
			AnchorX = midX
			AnchorY = midY
             
			LastX = fX
			LastY = fY
			LastVelocity = newVelocity
			mPointsCount = mPointsCount + 1
             
            
			cvs.Invalidate
            
		Case pnlSurface.TOUCH_ACTION_UP
			If mIsDrawing Then
				mIsDrawing = False
				RaiseEvent("EndStroke")
				RaiseEvent("Changed")
			End If
	End Select
End Sub

''' <summary>
''' Draws a variable-width quadratic Bezier from (x0,y0) to (x1,y1) with control
''' point (cx,cy) by subdividing it into short line segments. B4XCanvas has no
''' native curve primitive so we sample the parametric equation:
'''   B(t) = (1-t)^2*P0 + 2*(1-t)*t*C + t^2*P1
''' Stroke width is linearly interpolated from startWidth to endWidth across the
''' sub-segments, matching Square's technique of drawing per-step points with
''' incrementally changing stroke widths (fountain-pen / calligraphy effect).
''' ROUND cap/join + anti-aliasing (set in ApplyPaintStyle) blends the
''' sub-segments seamlessly. Cross-platform (B4A, B4i, B4J via B4XCanvas).
''' </summary>
Private Sub DrawQuadBezier(fX0 As Float, fY0 As Float, fCx As Float, fCy As Float, fX1 As Float, fY1 As Float, fStartWidth As Float, fEndWidth As Float)
	' Adaptive step count based on estimated Bezier arc length.
	' Arc length ~ average of chord (start->end) and control polygon (start->cp + cp->end).
	' This closed-form estimate avoids numerical integration; accuracy ~5% for
	' typical signature curvatures.
	' Goal: 1 step per 2 px. This keeps each sub-segment shorter than the ROUND
	' stroke-cap radius, so consecutive caps always overlap and no gaps appear
	' regardless of stroke speed or mfMinWidth setting.
	' Clamped to [4, 64]: 4 avoids degenerate output on tiny curves;
	' 64 caps CPU cost on very long, fast strokes without visible quality loss.
	Dim chord As Float = Sqrt(Power(fX1 - fX0, 2) + Power(fY1 - fY0, 2))
	Dim legs As Float = Sqrt(Power(fCx - fX0, 2) + Power(fCy - fY0, 2)) + _
	                    Sqrt(Power(fX1 - fCx, 2) + Power(fY1 - fCy, 2))
	Dim approxLen As Float = (chord + legs) / 2
	Dim steps As Int = Max(4, Min(64, Floor(approxLen / 2 + 0.9999)))
	Dim widthDelta As Float = fEndWidth - fStartWidth
	Dim px As Float = fX0
	Dim py As Float = fY0
	For i = 1 To steps
		Dim t As Float = i / steps
		Dim u As Float = 1 - t
		Dim nx As Float = u * u * fX0 + 2 * u * t * fCx + t * t * fX1
		Dim ny As Float = u * u * fY0 + 2 * u * t * fCy + t * t * fY1
		' Use the midpoint of this sub-segment for a smooth, centred
		' width transition with no visible step-change artefacts at joins.
		Dim tMid As Float = (i - 0.5) / steps
		Dim w As Float = fStartWidth + tMid * widthDelta
		cvs.DrawLine(px, py, nx, ny, StrokeColor, w)
		px = nx
		py = ny
	Next
End Sub


#End Region

#Region Public API
''' <summary>
''' B4XCanvas internally holds an anywheresoftware.b4a.objects.drawable.CanvasWrapper,
''' whose public 'paint' field (android.graphics.Paint) is the Paint used by every
''' DrawLine/DrawCircle call. We navigate to it and enable anti-aliasing plus ROUND
''' cap/join so strokes render with smooth outer edges and seamless segment joints.
''' Called after canvas initialization and whenever StrokeCap/StrokeJoin change.
''' </summary>
Private Sub ApplyPaintStyle
	#If B4A
	If CanvasReady = False Then Return
	Try
		' B4XCanvas.cvs -> CanvasWrapper.paint -> android.graphics.Paint
		Dim jo As JavaObject = cvs
		Dim inner As JavaObject = jo.GetField("cvs")
		Dim paint As JavaObject = inner.GetField("paint")
		ApplyPaintTo(paint)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySignaturePad.ApplyPaintStyle: " & LastException.Message)
	End Try
	#End If
End Sub

''' <summary>
''' Configures the supplied android.graphics.Paint for smooth signature strokes:
''' anti-aliasing (kills jagged 'paper-cut' outer edges), dithering, ROUND cap
''' (fills the gap/split between line segments) and ROUND join (smooth corners).
''' </summary>
Private Sub ApplyPaintTo(joPaint As JavaObject)
	Try
		joPaint.RunMethod("setAntiAlias", Array(True))
		joPaint.RunMethod("setDither", Array(True))

		' Force STROKE style as the baseline so ROUND cap/join take effect on lines.
		' DrawCircle/DrawRect with Filled=True set FILL themselves, so this is safe.
		Dim styleClass As JavaObject
		styleClass.InitializeStatic("android.graphics.Paint$Style")
		Dim strokeStyle As JavaObject = styleClass.GetField("STROKE")
		joPaint.RunMethod("setStyle", Array(strokeStyle))

		Dim capClass As JavaObject
		capClass.InitializeStatic("android.graphics.Paint$Cap")
		Dim cap As JavaObject = capClass.GetField(msStrokeCap)
		joPaint.RunMethod("setStrokeCap", Array(cap))

		Dim joinClass As JavaObject
		joinClass.InitializeStatic("android.graphics.Paint$Join")
		Dim join As JavaObject = joinClass.GetField(msStrokeJoin)
		joPaint.RunMethod("setStrokeJoin", Array(join))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisySignaturePad.ApplyPaintTo: " & LastException.Message)
	End Try
End Sub

''' <summary>
''' Clears the signature pad and resets the background.
''' </summary>
Public Sub Clear
	If CanvasReady = False Then Return
	cvs.ClearRect(cvs.TargetRect)
	Dim clearColor As Int = IIf(mcBackgroundColor <> 0, mcBackgroundColor, xui.Color_Transparent)
	If clearColor <> xui.Color_Transparent Then
		Dim radius As Int = ResolveCornerRadiusDip
		If radius > 0 Then
			Dim r As Float = Max(0, radius - 1dip)
			Dim path As B4XPath
			path.InitializeRoundedRect(cvs.TargetRect, r)
			cvs.DrawPath(path, clearColor, True, 0)
		Else
			cvs.DrawRect(cvs.TargetRect, clearColor, True, 0)
		End If
	End If
	mPointsCount = 0
	' Redraw the empty-pad hint watermark now the strokes are gone.
	DrawHint
	cvs.Invalidate
End Sub

''' <summary>
''' Returns true if the signature pad is empty.
''' </summary>
Public Sub IsEmpty As Boolean
	Return mPointsCount = 0
End Sub

''' <summary>
''' Returns the signature as a B4XBitmap object.
''' </summary>
Public Sub GetBitmap As B4XBitmap
	If CanvasReady = False Then Return Null
	Return cvs.CreateBitmap
End Sub

''' <summary>
''' Adds the component to a parent view.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	If mBase.IsInitialized = False Then
		CreateView(iWidth, iHeight)
	End If
	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Return mBase
End Sub

Private Sub RaiseEvent(sSuffix As String)
	If xui.SubExists(mCallBack, mEventName & "_" & sSuffix, 0) Then
		CallSub(mCallBack, mEventName & "_" & sSuffix)
	End If
End Sub
#End Region

#Region Getters and Setters
Public Sub setEnabled(bValue As Boolean)
	mbEnabled = bValue
	Refresh
End Sub

Public Sub getEnabled As Boolean
	Return mbEnabled
End Sub

Public Sub setMinWidth(fValue As Float)
	mfMinWidth = fValue * 1dip
End Sub

Public Sub getMinWidth As Float
	Return mfMinWidth / 1dip
End Sub

Public Sub setMaxWidth(fValue As Float)
	mfMaxWidth = fValue * 1dip
End Sub

Public Sub getMaxWidth As Float
	Return mfMaxWidth / 1dip
End Sub

Public Sub setVelocityFilterWeight(fValue As Float)
	mfVelocityFilterWeight = fValue
End Sub

Public Sub getVelocityFilterWeight As Float
	Return mfVelocityFilterWeight
End Sub

Public Sub setPenColor(iValue As Int)
	StrokeColor = iValue
End Sub

Public Sub getPenColor As Int
	Return StrokeColor
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mcBackgroundColor = iValue
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Returns the computed height of the component (mBase.Height).
''' </summary>
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' <summary>
''' Returns the computed width of the component (mBase.Width).
''' </summary>
Public Sub GetComputedWidth As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Width
End Sub

Public Sub setBitMapFormat(sValue As String)
	msBitMapFormat = sValue
End Sub

Public Sub getBitMapFormat As String
	Return msBitMapFormat
End Sub

Public Sub setBitMapQuality(iValue As Int)
	miBitMapQuality = iValue
End Sub

Public Sub getBitMapQuality As Int
	Return miBitMapQuality
End Sub

Public Sub setDisallowParentIntercept(bValue As Boolean)
	mbDisallowParentIntercept = bValue
End Sub

Public Sub getDisallowParentIntercept As Boolean
	Return mbDisallowParentIntercept
End Sub

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Width = iValue
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Height = iValue
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub setStrokeCap(sValue As String)
	Dim v As String = sValue.ToUpperCase
	If v = "BUTT" Or v = "ROUND" Or v = "SQUARE" Then
		msStrokeCap = v
		ApplyPaintStyle
	End If
End Sub

Public Sub getStrokeCap As String
	Return msStrokeCap
End Sub

Public Sub setStrokeJoin(sValue As String)
	Dim v As String = sValue.ToUpperCase
	If v = "BEVEL" Or v = "MITER" Or v = "ROUND" Then
		msStrokeJoin = v
		ApplyPaintStyle
	End If
End Sub

Public Sub getStrokeJoin As String
	Return msStrokeJoin
End Sub

Public Sub setFieldsetMode(bValue As Boolean)
	mbFieldsetMode = bValue
	Refresh
End Sub
Public Sub getFieldsetMode As Boolean
	Return mbFieldsetMode
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	Return (msRounded = "rounded-box" Or msRounded = "theme")
End Sub

Public Sub setMinHeight(iValue As Int)
	miMinHeight = Max(50, iValue)
	If mBase.IsInitialized Then Refresh
End Sub
Public Sub getMinHeight As Int
	Return miMinHeight
End Sub

Public Sub setHintText(sValue As String)
	If sValue = Null Then sValue = ""
	msHintText = sValue.Trim
	If CanvasReady Then DrawHint
End Sub
Public Sub getHintText As String
	Return msHintText
End Sub

Public Sub setHintColor(iValue As Int)
	mcHintColor = iValue
	If CanvasReady Then DrawHint
End Sub
Public Sub getHintColor As Int
	Return mcHintColor
End Sub

#Region Import / Export

''' <summary>
''' Draws an existing B4XBitmap onto the signature pad.
''' </summary>
Public Sub SetBitmap(bmpBmp As B4XBitmap)
	If CanvasReady = False Or bmpBmp.IsInitialized = False Then Return
	Dim r As B4XRect
	r.Initialize(0, 0, mBase.Width, mBase.Height)
	cvs.DrawBitmap(bmpBmp, r)
	cvs.Invalidate
	' Increment point count so IsEmpty correctly returns False
	mPointsCount = mPointsCount + 1
End Sub

''' <summary>
''' Returns the signature as a Base64 string using the configured BitMapFormat and BitMapQuality.
''' </summary>
Public Sub GetBase64 As String
	If CanvasReady = False Or IsEmpty Then Return ""
    
	Dim bmp As B4XBitmap = cvs.CreateBitmap
	Dim bytes() As Byte
    
	If msBitMapFormat.ToUpperCase = "BMP" Then
		bytes = BitmapToBMP(bmp)
	Else
		Dim out As OutputStream
		out.InitializeToBytesArray(0)
		' Serialize the B4XBitmap to the stream using the configured image format and quality
		bmp.WriteToStream(out, miBitMapQuality, msBitMapFormat.ToUpperCase)
		out.Close
		bytes = out.ToBytesArray
	End If
    
	' Encode the bytes into a Base64 string
	Dim su As StringUtils
	Dim res As String = su.EncodeBase64(bytes)
	If IsBase64(res) Then
		Return res
	Else
		Return ""
	End If
End Sub

''' <summary>
''' Decodes a Base64 string and draws it onto the signature pad.
''' </summary>
Public Sub SetBase64(sBase64String As String)
	If IsBase64(sBase64String) = False Then Return
    
	Dim cleanBase64 As String = sBase64String.Trim
	If cleanBase64.StartsWith("data:") And cleanBase64.Contains(";base64,") Then
		Dim idx As Int = cleanBase64.IndexOf(";base64,")
		If idx > -1 Then
			cleanBase64 = cleanBase64.SubString(idx + 8)
		End If
	End If
    
	Dim su As StringUtils
	Dim bytes() As Byte = su.DecodeBase64(cleanBase64)
    
	If bytes.Length > 0 Then
		Try
			Dim in As InputStream
			in.InitializeFromBytesArray(bytes, 0, bytes.Length)
            
			Dim bmp As B4XBitmap
            
			' Cross-platform bitmap initialization from InputStream
            #If B4A
			Dim tempBmp As Bitmap
			tempBmp.Initialize2(in)
			bmp = tempBmp
            #Else If B4J
            Dim tempBmp As Image
            tempBmp.Initialize2(in)
            bmp = tempBmp
            #Else If B4i
            Dim tempBmp As Bitmap
            tempBmp.Initialize2(in)
            bmp = tempBmp
            #End If
            
			in.Close
            
			' Apply it to the canvas
			SetBitmap(bmp)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisySignaturePad.SetBase64: " & LastException.Message)
		End Try
	End If
End Sub

''' <summary>
''' Validates if a string is a valid Base64 string.
''' </summary>
Public Sub IsBase64(sValue As String) As Boolean
	Dim s As String = sValue.Trim
	If s = "" Then Return False
	If s.StartsWith("data:") And s.Contains(";base64,") Then
		Dim idx As Int = s.IndexOf(";base64,")
		If idx > -1 Then
			s = s.SubString(idx + 8)
		End If
	End If
	s = s.Replace(CRLF, "").Replace(Chr(13), "").Replace(Chr(10), "").Replace(" ", "")
	If s.Length Mod 4 <> 0 Then Return False
	Dim matcher As Matcher = Regex.Matcher("^[A-Za-z0-9+/]+={0,2}$", s)
	Return matcher.Find
End Sub

''' <summary>
''' Converts a B4XBitmap into a raw BMP format byte array.
''' Uses only BitmapCreator + direct byte array writes - no RandomAccessFile dependency.
''' </summary>
Private Sub BitmapToBMP(bmpImg As B4XBitmap) As Byte()
	Dim Padding As Int = 4 - ((bmpImg.Width * 3) Mod 4)
	If Padding = 4 Then Padding = 0
	Dim HeaderSize As Int = 40
	Dim fileOffset As Int = HeaderSize + 14
	Dim dataSize As Int = bmpImg.Width * bmpImg.Height * 3 + bmpImg.Height * Padding
	Dim size As Int = fileOffset + dataSize
	Dim buf(size) As Byte
	Dim pos As Int = 0

	' -- BMP file header (14 bytes) --------------------------------------
	buf(pos) = Asc("B") : pos = pos + 1
	buf(pos) = Asc("M") : pos = pos + 1
	pos = WriteLEInt(buf, pos, size)        ' File size
	pos = WriteLEInt(buf, pos, 0)           ' Reserved
	pos = WriteLEInt(buf, pos, fileOffset)  ' Pixel data offset

	' -- DIB / BITMAPINFOHEADER (40 bytes) -------------------------------
	pos = WriteLEInt(buf, pos, HeaderSize)  ' Header size
	pos = WriteLEInt(buf, pos, bmpImg.Width)   ' Width
	pos = WriteLEInt(buf, pos, bmpImg.Height)  ' Height (positive = bottom-up)
	' Color planes (1) + bits-per-pixel (24) as two LE shorts
	buf(pos) = 1 : pos = pos + 1
	buf(pos) = 0 : pos = pos + 1
	buf(pos) = 24 : pos = pos + 1
	buf(pos) = 0 : pos = pos + 1
	pos = WriteLEInt(buf, pos, 0)           ' Compression (none)
	pos = WriteLEInt(buf, pos, 0)           ' Raw image size (0 for BI_RGB)
	pos = WriteLEInt(buf, pos, 0)           ' X pixels/meter
	pos = WriteLEInt(buf, pos, 0)           ' Y pixels/meter
	pos = WriteLEInt(buf, pos, 0)           ' Colors in table
	pos = WriteLEInt(buf, pos, 0)           ' Important colors

	' -- Pixel data (bottom-up row order, BGR) ---------------------------
	Dim bc As BitmapCreator
	bc.Initialize(bmpImg.Width, bmpImg.Height)
	bc.CopyPixelsFromBitmap(bmpImg)
	Dim a As ARGBColor
	Dim x, y, i As Int
	For y = bc.mHeight - 1 To 0 Step -1
		For x = 0 To bc.mWidth - 1
			bc.GetARGB(x, y, a)
			buf(pos) = a.b : pos = pos + 1
			buf(pos) = a.g : pos = pos + 1
			buf(pos) = a.r : pos = pos + 1
		Next
		For i = 0 To Padding - 1
			buf(pos) = 0 : pos = pos + 1
		Next
	Next
	Return buf
End Sub

''' <summary>
''' Writes a 32-bit integer into buf at pos in little-endian order.
''' Returns the new position after the 4 written bytes.
''' </summary>
Private Sub WriteLEInt(oBuf() As Byte, pos As Int, value As Long) As Int
	oBuf(pos)     = Bit.And(value, 0xFF)
	oBuf(pos + 1) = Bit.And(Bit.ShiftRight(value, 8),  0xFF)
	oBuf(pos + 2) = Bit.And(Bit.ShiftRight(value, 16), 0xFF)
	oBuf(pos + 3) = Bit.And(Bit.ShiftRight(value, 24), 0xFF)
	Return pos + 4
End Sub

Public Sub setVisible(bValue As Boolean)
	mbVisible = bValue
	If mBase.IsInitialized = False Then Return
	mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	Return mbVisible
End Sub

#End Region
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

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setVariant(sValue As String)
    msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub Release
    Try
        cvs.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisySignaturePad.Release: " & LastException.Message)
    End Try
    If pnlSurface.IsInitialized Then pnlSurface.RemoveViewFromParent
    mCallBack = Null
End Sub