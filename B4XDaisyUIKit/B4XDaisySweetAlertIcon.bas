B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#DesignerProperty: Key: IconType, DisplayName: Icon Type, FieldType: String, DefaultValue: success, List: none|warning|error|success|info|question|loading, Description: The icon to animate.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 500, Description: Duration of the drawing animation in milliseconds.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mTag As Object
	
	Private cvs As B4XCanvas
	Private mIconType As String = "success"
	Private mAnimDuration As Int = 500
	
	Private AnimTimer As Timer
	Private mStartTime As Long
	
	' SweetAlert2 Default Colors (Fallback if variant not used)
	Private ColorSuccess As Int = xui.Color_RGB(165, 220, 134)
	Private ColorError As Int = xui.Color_RGB(242, 116, 116)
	Private ColorWarning As Int = xui.Color_RGB(248, 187, 134)
	Private ColorInfo As Int = xui.Color_RGB(63, 195, 238)
	Private ColorQuestion As Int = xui.Color_RGB(135, 173, 189)
	Private ColorLoading As Int = xui.Color_RGB(63, 195, 238)
	Private mInitialized As Boolean = False
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	AnimTimer.Initialize("AnimTimer", 16) ' ~60 FPS
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
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	
	cvs.Initialize(mBase)
	
'	mIconType = Props.GetDefault("IconType", mIconType)
'	mAnimDuration = Props.GetDefault("Duration", Props.GetDefault("AnimationDuration", mAnimDuration))
	ApplyDesignerProps(mProps)
	
	Base_Resize(mBase.Width, mBase.Height)
	mInitialized = True
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mIconType = B4XDaisyVariants.GetPropString(mProps, "IconType", mIconType)
	mAnimDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", mAnimDuration))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("IconType", mIconType)
	props.Put("Duration", mAnimDuration)
	Return props
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	cvs.Resize(dWidth, dHeight)
	' We redraw at 100% progress if resized after animation
	If AnimTimer.Enabled = False Then DrawIcon(1.0)
	inResize = False
End Sub

Public Sub Play
	mStartTime = DateTime.Now
	AnimTimer.Enabled = True
End Sub

Public Sub Stop
	AnimTimer.Enabled = False
End Sub

Public Sub setDuration(iValue As Int)
	mAnimDuration = iValue
End Sub

Public Sub getDuration As Int
	Return mAnimDuration
End Sub

' Deprecated aliases (backward compatibility).
Public Sub setAnimationDuration(iValue As Int)
	setDuration(iValue)
End Sub

Public Sub getAnimationDuration As Int
	Return getDuration
End Sub

Public Sub setIconType(sIcon As String)
	mIconType = sIcon.ToLowerCase
	If mInitialized Then
		If AnimTimer.Enabled = False Then
			DrawIcon(1.0)
		Else
			cvs.ClearRect(cvs.TargetRect)
			cvs.Invalidate
		End If
	End If
End Sub

Public Sub getIconType As String
	Return mIconType
End Sub

Private Sub AnimTimer_Tick
	Dim elapsed As Long = DateTime.Now - mStartTime
	Dim t As Float = elapsed / mAnimDuration
	
	If t >= 1.0 Then
		If mIconType = "loading" Then
			mStartTime = DateTime.Now
			t = 0.0
		Else
			t = 1.0
			AnimTimer.Enabled = False
		End If
	End If
	
	Dim val As Float
	If mIconType = "loading" Then
		val = t
	Else
		' EaseOutCubic for smooth deceleration (Borrowed from B4XDaisyAnimation)
		val = 1.0 - Power(1.0 - t, 3)
	End If
	DrawIcon(val)
End Sub

' -
' 100% PARITY CANVAS DRAWING LOGIC
' -
Private Sub DrawIcon(fProgress As Float)
	cvs.ClearRect(cvs.TargetRect)
	If mIconType = "none" Then Return
	
	Dim w As Float = cvs.TargetRect.Width
	Dim h As Float = cvs.TargetRect.Height
	Dim cx As Float = w / 2
	Dim cy As Float = h / 2
	Dim radius As Float = (Min(w, h) / 2) * 0.9
	Dim strokeW As Float = Max(3dip, w * 0.06)
	Dim ringColor As Int = GetIconColor
	
	If mIconType = "loading" Then
		' Draw a subtle background track for loading spinner
		Dim trackColor As Int = xui.Color_ARGB(30, GetRGB(ringColor, 1), GetRGB(ringColor, 2), GetRGB(ringColor, 3))
		Dim trackP As B4XPath = CreateCleanArcPath(cx, cy, radius, 0, 360)
		cvs.DrawPath(trackP, trackColor, False, strokeW * 0.8)
		
		' Draw rotating spinner arc
		Dim startAngle As Float = -90 + (360 * fProgress)
		Dim sweepAngle As Float = 280
		Dim spinnerP As B4XPath = CreateCleanArcPath(cx, cy, radius, startAngle, sweepAngle)
		cvs.DrawPath(spinnerP, ringColor, False, strokeW * 0.8)
	Else
		' 1. Draw the animated outer ring (all other icons have this)
		Dim ringAlpha As Int = 255 * fProgress
		Dim ringP As B4XPath = CreateCleanArcPath(cx, cy, radius, -90, 360 * fProgress)
		cvs.DrawPath(ringP, xui.Color_ARGB(ringAlpha, GetRGB(ringColor, 1), GetRGB(ringColor, 2), GetRGB(ringColor, 3)), False, strokeW * 0.8)

		' 2. Draw the specific icon internals based on progress
		Select Case mIconType
			Case "success"
				DrawSuccess(cx, cy, radius, strokeW, fProgress, ringColor)
			Case "error"
				DrawError(cx, cy, radius, strokeW, fProgress, ringColor)
			Case "warning"
				DrawWarning(cx, cy, radius, strokeW, fProgress, ringColor)
			Case "info"
				DrawInfo(cx, cy, radius, strokeW, fProgress, ringColor)
			Case "question"
				DrawQuestion(cx, cy, radius, strokeW, fProgress, ringColor)
		End Select
	End If
	
	cvs.Invalidate
End Sub

Private Sub RotatePoint(fX As Float, fY As Float, fCx As Float, fCy As Float, fAngleDegrees As Float) As Float()
	Dim rad As Float = fAngleDegrees * 3.14159265 / 180.0
	Dim cosA As Float = Cos(rad)
	Dim sinA As Float = Sin(rad)
	Dim rx As Float = fCx + (fX - fCx) * cosA - (fY - fCy) * sinA
	Dim ry As Float = fCy + (fX - fCx) * sinA + (fY - fCy) * cosA
	Return Array As Float(rx, ry)
End Sub

Private Sub DrawSuccess(fCx As Float, fCy As Float, fRadius As Float, fStrokeW As Float, fProgress As Float, iColor As Int)
	' SweetAlert2 success checkmark consists of a short line and a long line
	Dim shortStartX As Float = fCx - fRadius * 0.45
	Dim shortStartY As Float = fCy + fRadius * 0.05
	Dim midX As Float = fCx - fRadius * 0.15
	Dim midY As Float = fCy + fRadius * 0.35
	Dim longEndX As Float = fCx + fRadius * 0.45
	Dim longEndY As Float = fCy - fRadius * 0.25
	
	Dim p As B4XPath
	p.Initialize(shortStartX, shortStartY)
	
	' Animate the short line first (0.0 to 0.4 progress)
	Dim p1 As Float = Min(1.0, fProgress / 0.4)
	Dim currentMidX As Float = shortStartX + (midX - shortStartX) * p1
	Dim currentMidY As Float = shortStartY + (midY - shortStartY) * p1
	p.LineTo(currentMidX, currentMidY)
	
	' Animate the long line second (0.4 to 1.0 progress)
	Dim currentEndX As Float = midX
	Dim currentEndY As Float = midY
	If fProgress > 0.4 Then
		Dim p2 As Float = (fProgress - 0.4) / 0.6
		currentEndX = midX + (longEndX - midX) * p2
		currentEndY = midY + (longEndY - midY) * p2
		p.LineTo(currentEndX, currentEndY)
	End If
	
	cvs.DrawPath(p, iColor, False, fStrokeW)
	
	' Enforce rounded caps and joints by drawing filled circles
	cvs.DrawCircle(shortStartX, shortStartY, fStrokeW / 2, iColor, True, 0)
	If fProgress > 0.4 Then
		cvs.DrawCircle(midX, midY, fStrokeW / 2, iColor, True, 0)
	End If
	cvs.DrawCircle(currentEndX, currentEndY, fStrokeW / 2, iColor, True, 0)
End Sub

Private Sub DrawError(fCx As Float, fCy As Float, fRadius As Float, fStrokeW As Float, fProgress As Float, iColor As Int)
	If fProgress < 0.5 Then Return
	
	' Scale factor from 0.0 to 1.0 mapped from progress 0.5 to 1.0
	Dim p As Float = (fProgress - 0.5) / 0.5
	Dim S As Float
	If p < 0.6 Then
		S = 0.4 + 1.25 * p  ' scales from 0.4 to 1.15
	Else
		S = 1.15 - 0.375 * (p - 0.6)  ' scales down from 1.15 to 1.0
	End If
	
	Dim offset As Float = fRadius * 0.3 * S
	Dim currentStroke As Float = fStrokeW * S
	
	' Line 1 (Top-Left to Bottom-Right)
	Dim l1x1 As Float = fCx - offset
	Dim l1y1 As Float = fCy - offset
	Dim l1x2 As Float = fCx + offset
	Dim l1y2 As Float = fCy + offset
	cvs.DrawLine(l1x1, l1y1, l1x2, l1y2, iColor, currentStroke)
	cvs.DrawCircle(l1x1, l1y1, currentStroke / 2, iColor, True, 0)
	cvs.DrawCircle(l1x2, l1y2, currentStroke / 2, iColor, True, 0)
	
	' Line 2 (Top-Right to Bottom-Left)
	Dim l2x1 As Float = fCx + offset
	Dim l2y1 As Float = fCy - offset
	Dim l2x2 As Float = fCx - offset
	Dim l2y2 As Float = fCy + offset
	cvs.DrawLine(l2x1, l2y1, l2x2, l2y2, iColor, currentStroke)
	cvs.DrawCircle(l2x1, l2y1, currentStroke / 2, iColor, True, 0)
	cvs.DrawCircle(l2x2, l2y2, currentStroke / 2, iColor, True, 0)
End Sub

Private Sub DrawWarning(fCx As Float, fCy As Float, fRadius As Float, fStrokeW As Float, fProgress As Float, iColor As Int)
	' Wobble angle logic
	Dim W As Float
	If fProgress < 0.25 Then
		W = 45 - 280 * fProgress
	Else If fProgress < 0.5 Then
		W = -25 + 160 * (fProgress - 0.25)
	Else If fProgress < 0.75 Then
		W = 15 - 80 * (fProgress - 0.5)
	Else
		W = -5 + 20 * (fProgress - 0.75)
	End If
	
	' Tapered vertical bar coordinates (unrotated)
	Dim topY As Float = fCy - fRadius * 0.4
	Dim bottomY As Float = topY + ((fCy + fRadius * 0.1) - topY) * fProgress
	
	Dim rTop As Float = fStrokeW * 0.6
	Dim rBottom As Float = fStrokeW * 0.3
	
	' Draw top circle, bottom circle, and connector polygon
	If bottomY > topY Then
		Dim ptTop() As Float = RotatePoint(fCx, topY, fCx, fCy, W)
		Dim ptBottom() As Float = RotatePoint(fCx, bottomY, fCx, fCy, W)
		
		cvs.DrawCircle(ptTop(0), ptTop(1), rTop, iColor, True, 0)
		cvs.DrawCircle(ptBottom(0), ptBottom(1), rBottom, iColor, True, 0)
		
		' Polygon corners relative to the line direction
		' Since the line is vertical, left and right offsets are perpendicular
		Dim p As B4XPath
		' Left top edge
		Dim pt1() As Float = RotatePoint(fCx - rTop, topY, fCx, fCy, W)
		p.Initialize(pt1(0), pt1(1))
		' Right top edge
		Dim pt2() As Float = RotatePoint(fCx + rTop, topY, fCx, fCy, W)
		p.LineTo(pt2(0), pt2(1))
		' Right bottom edge
		Dim pt3() As Float = RotatePoint(fCx + rBottom, bottomY, fCx, fCy, W)
		p.LineTo(pt3(0), pt3(1))
		' Left bottom edge
		Dim pt4() As Float = RotatePoint(fCx - rBottom, bottomY, fCx, fCy, W)
		p.LineTo(pt4(0), pt4(1))
		' Close path
		p.LineTo(pt1(0), pt1(1))
		
		cvs.DrawPath(p, iColor, True, 0)
	Else
		Dim ptTop() As Float = RotatePoint(fCx, topY, fCx, fCy, W)
		cvs.DrawCircle(ptTop(0), ptTop(1), rTop, iColor, True, 0)
	End If
	
	' Exclamation dot faded in
	If fProgress > 0.6 Then
		Dim dotAlpha As Float = (fProgress - 0.6) / 0.4
		Dim dotY As Float = fCy + fRadius * 0.38
		Dim ptDot() As Float = RotatePoint(fCx, dotY, fCx, fCy, W)
		cvs.DrawCircle(ptDot(0), ptDot(1), fStrokeW * 0.5, xui.Color_ARGB(255 * dotAlpha, GetRGB(iColor, 1), GetRGB(iColor, 2), GetRGB(iColor, 3)), True, 0)
	End If
End Sub

Private Sub DrawInfo(fCx As Float, fCy As Float, fRadius As Float, fStrokeW As Float, fProgress As Float, iColor As Int)
	' Wobble angle logic (same rocking as warning)
	Dim W As Float
	If fProgress < 0.25 Then
		W = 45 - 280 * fProgress
	Else If fProgress < 0.5 Then
		W = -25 + 160 * (fProgress - 0.25)
	Else If fProgress < 0.75 Then
		W = 15 - 80 * (fProgress - 0.5)
	Else
		W = -5 + 20 * (fProgress - 0.75)
	End If
	
	Dim topY As Float = fCy - fRadius * 0.1
	Dim bottomY As Float = topY + ((fCy + fRadius * 0.4) - topY) * fProgress
	
	' Straight vertical line with rounded caps
	Dim ptTop() As Float = RotatePoint(fCx, topY, fCx, fCy, W)
	Dim ptBottom() As Float = RotatePoint(fCx, bottomY, fCx, fCy, W)
	
	cvs.DrawLine(ptTop(0), ptTop(1), ptBottom(0), ptBottom(1), iColor, fStrokeW)
	cvs.DrawCircle(ptTop(0), ptTop(1), fStrokeW / 2, iColor, True, 0)
	cvs.DrawCircle(ptBottom(0), ptBottom(1), fStrokeW / 2, iColor, True, 0)
	
	' Top info dot faded in
	If fProgress > 0.6 Then
		Dim dotAlpha As Float = (fProgress - 0.6) / 0.4
		Dim dotY As Float = fCy - fRadius * 0.38
		Dim ptDot() As Float = RotatePoint(fCx, dotY, fCx, fCy, W)
		cvs.DrawCircle(ptDot(0), ptDot(1), fStrokeW * 0.5, xui.Color_ARGB(255 * dotAlpha, GetRGB(iColor, 1), GetRGB(iColor, 2), GetRGB(iColor, 3)), True, 0)
	End If
End Sub

Private Sub DrawQuestion(fCx As Float, fCy As Float, fRadius As Float, fStrokeW As Float, fProgress As Float, iColor As Int)
	' Y-axis rotation scale factor
	Dim scaleX As Float = Cos((-360 * (1.0 - fProgress)) * 3.14159265 / 180.0)
	
	' Hook arc segment drawing (0.0 to 0.7 progress)
	Dim sweep As Float = 270 * Min(1.0, fProgress / 0.7)
	Dim hookR As Float = fRadius * 0.25
	Dim hookCY As Float = fCy - fRadius * 0.15
	
	Dim p As B4XPath
	Dim startX As Float = fCx - hookR
	Dim startY As Float = hookCY
	Dim rotStartX As Float = fCx + (startX - fCx) * scaleX
	p.Initialize(rotStartX, startY)
	
	' Divide the arc sweep into segments of 10 degrees to apply scaleX
	Dim stepDeg As Float = 10
	Dim numSteps As Int = sweep / stepDeg
	For stepIdx = 1 To numSteps
		Dim angle As Float = 180 + stepIdx * stepDeg
		Dim ptX As Float = fCx + hookR * Cos(angle * 3.14159265 / 180)
		Dim ptY As Float = hookCY + hookR * Sin(angle * 3.14159265 / 180)
		Dim rotPtX As Float = fCx + (ptX - fCx) * scaleX
		p.LineTo(rotPtX, ptY)
	Next
	
	' Last fractional step if sweep is not a multiple of stepDeg
	Dim remainingSweep As Float = sweep - (numSteps * stepDeg)
	If remainingSweep > 0.01 Then
		Dim angle As Float = 180 + sweep
		Dim ptX As Float = fCx + hookR * Cos(angle * 3.14159265 / 180)
		Dim ptY As Float = hookCY + hookR * Sin(angle * 3.14159265 / 180)
		Dim rotPtX As Float = fCx + (ptX - fCx) * scaleX
		p.LineTo(rotPtX, ptY)
	End If
	
	cvs.DrawPath(p, iColor, False, fStrokeW)
	cvs.DrawCircle(rotStartX, startY, fStrokeW / 2, iColor, True, 0)
	
	' Calculate current end of the arc
	Dim endAngle As Float = 180 + sweep
	Dim endX As Float = fCx + hookR * Cos(endAngle * 3.14159265 / 180)
	Dim endY As Float = hookCY + hookR * Sin(endAngle * 3.14159265 / 180)
	Dim rotEndX As Float = fCx + (endX - fCx) * scaleX
	cvs.DrawCircle(rotEndX, endY, fStrokeW / 2, iColor, True, 0)
	
	' 2. Small dropdown line (0.7 to 0.9 progress)
	Dim lineStartY As Float = fCy + fRadius * 0.1
	Dim lineEndY As Float = lineStartY
	If fProgress > 0.7 Then
		Dim p2 As Float = Min(1.0, (fProgress - 0.7) / 0.2)
		lineEndY = lineStartY + (fRadius * 0.15 * p2)
		
		Dim rotLineStartX As Float = fCx + (fCx - fCx) * scaleX
		cvs.DrawLine(rotLineStartX, lineStartY, rotLineStartX, lineEndY, iColor, fStrokeW)
		cvs.DrawCircle(rotLineStartX, lineStartY, fStrokeW / 2, iColor, True, 0)
		cvs.DrawCircle(rotLineStartX, lineEndY, fStrokeW / 2, iColor, True, 0)
	End If
	
	' 3. Bottom question dot faded in (0.9 to 1.0 progress)
	If fProgress > 0.9 Then
		Dim dotAlpha As Float = (fProgress - 0.9) / 0.1
		Dim dotY As Float = fCy + fRadius * 0.42
		Dim rotDotX As Float = fCx + (fCx - fCx) * scaleX
		cvs.DrawCircle(rotDotX, dotY, fStrokeW * 0.5, xui.Color_ARGB(255 * dotAlpha, GetRGB(iColor, 1), GetRGB(iColor, 2), GetRGB(iColor, 3)), True, 0)
	End If
End Sub

' Helper to extract RGB channels
Private Sub GetRGB(iColor As Int, iChannel As Int) As Int
	If iChannel = 1 Then Return Bit.And(Bit.ShiftRight(iColor, 16), 0xFF) ' Red
	If iChannel = 2 Then Return Bit.And(Bit.ShiftRight(iColor, 8), 0xFF)  ' Green
	Return Bit.And(iColor, 0xFF) ' Blue
End Sub

Private Sub GetIconColor As Int
	' Maps the SweetAlert type to its iconic colors
	Select Case mIconType
		Case "success": Return ColorSuccess
		Case "error": Return ColorError
		Case "warning": Return ColorWarning
		Case "info": Return ColorInfo
		Case "question": Return ColorQuestion
		Case "loading": Return ColorLoading
		Case Else: Return xui.Color_Gray
	End Select
End Sub

Private Sub CreateCleanArcPath(fCx As Float, fCy As Float, fRadius As Float, fStartAngle As Float, fSweepAngle As Float) As B4XPath
	#If B4A
	Dim nativePath As JavaObject
	nativePath.InitializeNewInstance("android.graphics.Path", Null)
	Dim rectF As JavaObject
	rectF.InitializeNewInstance("android.graphics.RectF", Array(fCx - fRadius, fCy - fRadius, fCx + fRadius, fCy + fRadius))
	nativePath.RunMethod("addArc", Array(rectF, fStartAngle, fSweepAngle))
	Dim path As B4XPath = nativePath
	Return path
	#Else
	Dim path As B4XPath
	path.InitializeArc(fCx, fCy, fRadius, fStartAngle, fSweepAngle)
	Return path
	#End If
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
