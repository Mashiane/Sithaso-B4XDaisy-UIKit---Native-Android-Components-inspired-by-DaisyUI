B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12,9
Sub Class_Globals
End Sub

Public Sub Initialize
End Sub

Public Sub SetNativeAlpha(vView As B4XView, fAlphaValue As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setAlpha", Array As Object(fAlphaValue))
	#Else
	Dim ignore As Object = vView
	Dim ignore2 As Float = fAlphaValue
	#End If
End Sub

Public Sub SetNativeRotation(vView As B4XView, fDegrees As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setRotation", Array As Object(fDegrees))
	#Else
	Dim ignore As Object = vView
	Dim ignore2 As Float = fDegrees
	#End If
End Sub

Public Sub SetNativeRotationY(vView As B4XView, fDegrees As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setRotationY", Array As Object(fDegrees))
	#Else
	Dim ignore As Object = vView
	Dim ignore2 As Float = fDegrees
	#End If
End Sub

Public Sub AnimateLayerNative(vView As B4XView, fAlphaValue As Float, fDegrees As Float, fDegreesY As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	Dim safeDuration As Long = Max(0, iDurationMs)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(safeDuration))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateLayerNative: " & LastException.Message)
	End Try 'ignore
	anim.RunMethod("alpha", Array As Object(fAlphaValue))
	anim.RunMethod("rotation", Array As Object(fDegrees))
	anim.RunMethod("rotationY", Array As Object(fDegreesY))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	Dim ignore1 As Float = fAlphaValue
	Dim ignore2 As Float = fDegrees
	Dim ignore3 As Float = fDegreesY
	Dim ignore4 As Int = iDurationMs
	#End If
End Sub

Public Sub SetNativeCameraDistance(vView As B4XView, fDistancePx As Float)
	#If B4A
	Dim jo As JavaObject = vView
	Dim safeDistance As Float = Max(0, fDistancePx)
	Try
		jo.RunMethod("setCameraDistance", Array As Object(safeDistance))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.SetNativeCameraDistance: " & LastException.Message)
	End Try 'ignore
	#Else
	Dim ignore As Object = vView
	Dim ignore2 As Float = fDistancePx
	#End If
End Sub

'Sets the translationX property of a view without animation.
Public Sub SetTranslationX(vView As B4XView, fTranslationXPx As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setTranslationX", Array As Object(fTranslationXPx))
	#Else
	Dim ignore As Object = vView
	Dim ignore2 As Float = fTranslationXPx
	#End If
End Sub

'Sets the translationY property of a view without animation.
Public Sub SetTranslationY(vView As B4XView, fTranslationYPx As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setTranslationY", Array As Object(fTranslationYPx))
	#Else
	Dim ignore As Object = vView
	Dim ignore2 As Float = fTranslationYPx
	#End If
End Sub


'Animates the translationX property using ViewPropertyAnimator (hardware-accelerated).
Public Sub AnimateTranslationX(vView As B4XView, fTranslationXPx As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateTranslationX: " & LastException.Message)
	End Try 'ignore
	anim.RunMethod("translationX", Array As Object(fTranslationXPx))
	anim.RunMethod("setInterpolator", Array(CreateLinearInterpolator))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	Dim ignore1 As Float = fTranslationXPx
	Dim ignore2 As Int = iDurationMs
	#End If
End Sub

Private Sub CreateLinearInterpolator As JavaObject
	Dim li As JavaObject
	li.InitializeNewInstance("android.view.animation.LinearInterpolator", Null)
	Return li
End Sub

' SafeDurationMs: boxes a duration into Long so ViewPropertyAnimator.setDuration(long)
' matches via JavaObject reflection. Passing an Int (boxed Integer) fails method matching
' ("Method: setDuration not matched") and silently falls back to the platform default
' 440ms duration. See AnimateAlpha (Dim dur As Long) for the original rationale; this
' helper centralizes the same Long-boxing for every other Animate* sub.
Private Sub SafeDurationMs(iMs As Int) As Long
	Return Max(0, iMs)
End Sub


Public Sub linearTween (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Return fChangeInValue  * fTime/ iDuration + fStart
End Sub
		
'// quadratic easing in - accelerating from zero velocity


Public Sub easeInQuad (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	Return fChangeInValue  * fTime*fTime + fStart
End Sub
		

'// quadratic easing out - decelerating To zero velocity


Public Sub easeOutQuad (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	Return - fChangeInValue * fTime*(fTime-2) + fStart
End Sub

		

'// quadratic easing in/out - acceleration Until halfway, Then deceleration


Public Sub easeInOutQuad (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / (iDuration / 2)
	If (fTime < 1) Then Return fChangeInValue  /2*fTime*fTime + fStart
	fTime = fTime - 1
	Return - fChangeInValue/2 * (fTime*(fTime-2) - 1) + fStart
End Sub


'// cubic easing in - accelerating from zero velocity


Public Sub easeInCubic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	Return fChangeInValue  * fTime*fTime*fTime + fStart
End Sub

		

'// cubic easing out - decelerating To zero velocity


Public Sub easeOutCubic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	fTime = fTime -1
	Return fChangeInValue  * (fTime*fTime*fTime + 1) + fStart
End Sub

		

'// cubic easing in/out - acceleration Until halfway, Then deceleration


Public Sub easeInOutCubic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / (iDuration / 2)
	If (fTime < 1) Then Return fChangeInValue  /2*fTime*fTime*fTime + fStart
	fTime = fTime - 2
	Return fChangeInValue  /2*(fTime*fTime*fTime + 2) + fStart
End Sub
	

'// quartic easing in - accelerating from zero velocity


Public Sub easeInQuart (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	Return fChangeInValue  * fTime*fTime*fTime*fTime + fStart
End Sub

		

'// quartic easing out - decelerating To zero velocity


Public Sub easeOutQuart (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	fTime = fTime -1
	Return - fChangeInValue * (fTime*fTime*fTime*fTime - 1) + fStart
End Sub

		

'// quartic easing in/out - acceleration Until halfway, Then deceleration


Public Sub easeInOutQuart (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime /(iDuration / 2)
	If (fTime < 1) Then Return fChangeInValue  /2 * fTime * fTime * fTime * fTime + fStart
	fTime = fTime -2
	Return - fChangeInValue/2 * (fTime*fTime*fTime*fTime - 2) + fStart
End Sub


'// quintic easing in - accelerating from zero velocity


Public Sub easeInQuint (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	Return fChangeInValue  * fTime*fTime*fTime*fTime*fTime + fStart
End Sub

		

'// quintic easing out - decelerating To zero velocity


Public Sub easeOutQuint (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	fTime = fTime -1
	Return fChangeInValue  * (fTime * fTime*fTime * fTime * fTime + 1) + fStart
End Sub

		

'// quintic easing in/out - acceleration Until halfway, Then deceleration


Public Sub easeInOutQuint (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / (iDuration / 2)
	If (fTime < 1) Then Return fChangeInValue /2 * fTime * fTime * fTime * fTime * fTime + fStart
	fTime = fTime -2
	Return fChangeInValue  /2 * (fTime * fTime * fTime * fTime * fTime + 2) + fStart
End Sub
		

'// sinusoidal easing in - accelerating from zero velocity


Public Sub easeInSine (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Return - fChangeInValue * Cos(fTime/ iDuration * (cPI/2)) + fChangeInValue + fStart
End Sub

		

'// sinusoidal easing out - decelerating To zero velocity


Public Sub easeOutSine (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Return fChangeInValue  * Sin(fTime/ iDuration * (cPI/2)) + fStart
End Sub

		

'// sinusoidal easing in/out - accelerating Until halfway, Then decelerating


Public Sub easeInOutSine (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Return - fChangeInValue/2 * (Cos(cPI*fTime/ iDuration) - 1) + fStart
End Sub

		

'// exponential easing in - accelerating from zero velocity


Public Sub easeInExpo (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime = 0 Then Return fStart
	Return fChangeInValue  * Power( 2, 10 * (fTime/ iDuration - 1) ) + fStart
End Sub

		

'// exponential easing out - decelerating To zero velocity


Public Sub easeOutExpo (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime = iDuration Then Return fStart + fChangeInValue
	Return fChangeInValue  * ( -Power( 2, -10 * fTime/ iDuration ) + 1 ) + fStart
End Sub

		

'// exponential easing in/out - accelerating Until halfway, Then decelerating


Public Sub easeInOutExpo (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime = 0 Then Return fStart
	If fTime = iDuration Then Return fStart + fChangeInValue
	fTime =  fTime /(iDuration / 2)
	If (fTime < 1) Then Return fChangeInValue  /2 * Power( 2, 10 * (fTime - 1) ) + fStart
	fTime = fTime -1
	Return fChangeInValue  /2 * ( -Power( 2, -10 * fTime) + 2 ) + fStart
End Sub
		

'// circular easing in - accelerating from zero velocity


Public Sub easeInCirc (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	Return - fChangeInValue * (Sqrt(1 - fTime * fTime) - 1) + fStart
End Sub

		

'// circular easing out - decelerating To zero velocity


Public Sub easeOutCirc (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / iDuration
	fTime = fTime -1
	Return fChangeInValue  * Sqrt(1 - fTime * fTime) + fStart
End Sub

'// circular easing in/out - acceleration Until halfway, Then deceleration

Public Sub easeInOutCirc (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime =  fTime / (iDuration / 2)
	If (fTime < 1) Then Return - fChangeInValue/2 * (Sqrt(1 - fTime * fTime) - 1) + fStart
	fTime = fTime -2
	Return fChangeInValue  /2 * (Sqrt(1 - fTime * fTime) + 1) + fStart
End Sub

'// back easing in - overshoots starting coordinate
Public Sub easeInBack (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Dim s As Float = 1.70158
	fTime = fTime / iDuration
	Return fChangeInValue * fTime * fTime * ((s + 1) * fTime - s) + fStart
End Sub

'// back easing out - overshoots target coordinate
Public Sub easeOutBack (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Dim s As Float = 1.70158
	fTime = (fTime / iDuration) - 1
	Return fChangeInValue * (fTime * fTime * ((s + 1) * fTime + s) + 1) + fStart
End Sub

'// back easing in/out - overshoots on both ends
Public Sub easeInOutBack (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Dim s As Float = 1.70158 * 1.525
	fTime = fTime / (iDuration / 2)
	If fTime < 1 Then Return fChangeInValue / 2 * (fTime * fTime * ((s + 1) * fTime - s)) + fStart
	fTime = fTime - 2
	Return fChangeInValue / 2 * (fTime * fTime * ((s + 1) * fTime + s) + 2) + fStart
End Sub

'// bounce easing out - bounces settling at the target
Public Sub easeOutBounce (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	fTime = fTime / iDuration
	If fTime < (1 / 2.75) Then
		Return fChangeInValue * (7.5625 * fTime * fTime) + fStart
	Else If fTime < (2 / 2.75) Then
		fTime = fTime - (1.5 / 2.75)
		Return fChangeInValue * (7.5625 * fTime * fTime + 0.75) + fStart
	Else If fTime < (2.5 / 2.75) Then
		fTime = fTime - (2.25 / 2.75)
		Return fChangeInValue * (7.5625 * fTime * fTime + 0.9375) + fStart
	Else
		fTime = fTime - (2.625 / 2.75)
		Return fChangeInValue * (7.5625 * fTime * fTime + 0.984375) + fStart
	End If
End Sub

'// bounce easing in - bounces before starting
Public Sub easeInBounce (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	Return fChangeInValue - easeOutBounce(iDuration - fTime, 0, fChangeInValue, iDuration) + fStart
End Sub

'// bounce easing in/out - bounces on both ends
Public Sub easeInOutBounce (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime < iDuration / 2 Then
		Return easeInBounce(fTime * 2, 0, fChangeInValue, iDuration) * 0.5 + fStart
	Else
		Return easeOutBounce(fTime * 2 - iDuration, 0, fChangeInValue, iDuration) * 0.5 + fChangeInValue * 0.5 + fStart
	End If
End Sub

'// elastic easing in - snaps at start
Public Sub easeInElastic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime = 0 Then Return fStart
	fTime = fTime / iDuration
	If fTime = 1 Then Return fStart + fChangeInValue
    
	Dim p As Float = iDuration * 0.3
	Dim a As Float = fChangeInValue
	Dim s As Float = p / 4
    
	fTime = fTime - 1
	Return -(a * Power(2, 10 * fTime) * Sin((fTime * iDuration - s) * (2 * cPI) / p)) + fStart
End Sub

'// elastic easing out - snaps at target (Crucial for the Floating Drawer and BoomMenu effects)
Public Sub easeOutElastic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime = 0 Then Return fStart
	fTime = fTime / iDuration
	If fTime = 1 Then Return fStart + fChangeInValue
    
	Dim p As Float = iDuration * 0.3
	Dim a As Float = fChangeInValue
	Dim s As Float = p / 4
    
	Return a * Power(2, -10 * fTime) * Sin((fTime * iDuration - s) * (2 * cPI) / p) + fChangeInValue + fStart
End Sub

'// elastic easing in/out - snaps on both ends
Public Sub easeInOutElastic (fTime As Float, fStart As Float, fChangeInValue As Float, iDuration As Int) As Float
	If fTime = 0 Then Return fStart
	fTime = fTime / (iDuration / 2)
	If fTime = 2 Then Return fStart + fChangeInValue
    
	Dim p As Float = iDuration * (0.3 * 1.5)
	Dim a As Float = fChangeInValue
	Dim s As Float = p / 4
    
	fTime = fTime - 1
	If fTime < 0 Then
		Return -0.5 * (a * Power(2, 10 * fTime) * Sin((fTime * iDuration - s) * (2 * cPI) / p)) + fStart
	End If
	Return a * Power(2, -10 * fTime) * Sin((fTime * iDuration - s) * (2 * cPI) / p) * 0.5 + fChangeInValue + fStart
End Sub

'Animates the translationY property using ViewPropertyAnimator (hardware-accelerated).
Public Sub AnimateTranslationY(vView As B4XView, fTranslationYPx As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateTranslationY: " & LastException.Message)
	End Try 'ignore
	anim.RunMethod("translationY", Array As Object(fTranslationYPx))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	Dim ignore1 As Float = fTranslationYPx
	Dim ignore2 As Int = iDurationMs
	#End If
End Sub

'Animates both X and Y translation simultaneously.
Public Sub AnimateTranslationXY(vView As B4XView, fTransX As Float, fTransY As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateTranslationXY: " & LastException.Message)
	End Try
	anim.RunMethod("translationX", Array As Object(fTransX))
	anim.RunMethod("translationY", Array As Object(fTransY))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Sets the pivot point for Rotation and Scale effects. (0,0) is top-left corner.
Public Sub SetNativePivot(vView As B4XView, fPivotX As Float, fPivotY As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setPivotX", Array As Object(fPivotX))
	jo.RunMethod("setPivotY", Array As Object(fPivotY))
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates the hardware ScaleX and ScaleY properties. Normal scale is 1.0.
' Animates hardware ScaleX/ScaleY from a start value to an end value.
Public Sub AnimateScaleFrom(vView As B4XView, fFromScaleX As Float, fFromScaleY As Float, fToScaleX As Float, fToScaleY As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setScaleX", Array As Object(fFromScaleX))
	jo.RunMethod("setScaleY", Array As Object(fFromScaleY))
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateScaleFrom: " & LastException.Message)
	End Try
	anim.RunMethod("scaleX", Array As Object(fToScaleX))
	anim.RunMethod("scaleY", Array As Object(fToScaleY))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Sets hardware ScaleX and ScaleY immediately (no animation).
Public Sub SetNativeScale(vView As B4XView, fScaleX As Float, fScaleY As Float)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setScaleX", Array As Object(fScaleX))
	jo.RunMethod("setScaleY", Array As Object(fScaleY))
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates alpha from a start value to an end value.
Public Sub AnimateAlpha(vView As B4XView, fFromAlpha As Float, fToAlpha As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setAlpha", Array As Object(fFromAlpha))
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		' setDuration(long): pass a Long so JavaObject reflection matches the primitive
		' long signature. Passing an Int (boxed Integer) fails method matching with
		' "Method: setDuration not matched" and leaves the rotation/alpha on the
		' ViewPropertyAnimator default duration.
		Dim dur As Long = Max(0, iDurationMs)
		anim.RunMethod("setDuration", Array As Object(dur))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateAlpha: " & LastException.Message)
	End Try
	anim.RunMethod("alpha", Array As Object(fToAlpha))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates rotation from a start angle to an end angle.
Public Sub AnimateRotation(vView As B4XView, fFromDegrees As Float, fToDegrees As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setRotation", Array As Object(fFromDegrees))
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		' setDuration(long): pass a Long so reflection matches the primitive long
		' signature (see AnimateAlpha for the full rationale).
		Dim dur As Long = Max(0, iDurationMs)
		anim.RunMethod("setDuration", Array As Object(dur))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateRotation: " & LastException.Message)
	End Try
	anim.RunMethod("rotation", Array As Object(fToDegrees))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates hardware ScaleX and ScaleY properties. Normal scale is 1.0.
Public Sub AnimateScale(vView As B4XView, fScaleX As Float, fScaleY As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateScale: " & LastException.Message)
	End Try
	anim.RunMethod("scaleX", Array As Object(fScaleX))
	anim.RunMethod("scaleY", Array As Object(fScaleY))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates hardware RotationX (Vertical Flip).
Public Sub AnimateRotationX(vView As B4XView, fDegreesX As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateRotationX: " & LastException.Message)
	End Try
	anim.RunMethod("rotationX", Array As Object(fDegreesX))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates hardware RotationY (Horizontal Flip).
Public Sub AnimateRotationY(vView As B4XView, fDegreesY As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateRotationY: " & LastException.Message)
	End Try
	anim.RunMethod("rotationY", Array As Object(fDegreesY))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Animates multiple hardware properties simultaneously to mimic complex ViewTransforms.
Public Sub AnimateExtended(vView As B4XView, fAlpha As Float, fTransX As Float, fTransY As Float, fScaleX As Float, fScaleY As Float, fRotX As Float, fRotY As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateExtended: " & LastException.Message)
	End Try
	anim.RunMethod("alpha", Array As Object(fAlpha))
	anim.RunMethod("translationX", Array As Object(fTransX))
	anim.RunMethod("translationY", Array As Object(fTransY))
	anim.RunMethod("scaleX", Array As Object(fScaleX))
	anim.RunMethod("scaleY", Array As Object(fScaleY))
	anim.RunMethod("rotationX", Array As Object(fRotX))
	anim.RunMethod("rotationY", Array As Object(fRotY))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Mimics AndroidViewAnimations "Tada"
Public Sub AnimateTada(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 10
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	' Step 1: Shrink and rotate slightly left
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(0.9))
	anim.RunMethod("scaleY", Array As Object(0.9))
	anim.RunMethod("rotation", Array As Object(-3.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime * 2)))
	anim.RunMethod("start", Null)
	Sleep(stepTime * 2)
	
	' Step 2: Pop out and wobble
	For i = 1 To 6
		Dim rot As Float = 3.0
		If i Mod 2 = 0 Then rot = -3.0
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("scaleX", Array As Object(1.1))
		anim.RunMethod("scaleY", Array As Object(1.1))
		anim.RunMethod("rotation", Array As Object(rot))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	
	' Step 3: Return to normal
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(1.0))
	anim.RunMethod("scaleY", Array As Object(1.0))
	anim.RunMethod("rotation", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime * 2)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Mimics AndroidViewAnimations "RubberBand"
Public Sub AnimateRubberBand(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 6
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(1.25))
	anim.RunMethod("scaleY", Array As Object(0.75))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	Sleep(stepTime)
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(0.75))
	anim.RunMethod("scaleY", Array As Object(1.25))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	Sleep(stepTime)
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(1.15))
	anim.RunMethod("scaleY", Array As Object(0.85))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	Sleep(stepTime)
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(0.95))
	anim.RunMethod("scaleY", Array As Object(1.05))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	Sleep(stepTime)
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(1.05))
	anim.RunMethod("scaleY", Array As Object(0.95))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	Sleep(stepTime)
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(1.0))
	anim.RunMethod("scaleY", Array As Object(1.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Mimics AndroidViewAnimations "Shake"
Public Sub AnimateShake(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 10
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	For i = 1 To 10
		Dim offset As Float = 10dip
		If i Mod 2 = 0 Then offset = -10dip
		If i = 10 Then offset = 0 ' Settle back to center on last frame
		
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("translationX", Array As Object(offset))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Mimics AndroidViewAnimations "Wobble"
Public Sub AnimateWobble(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 6
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	Dim w As Float = vView.Width
	
	' Define keyframes for TranslationX and Rotation
	Dim tx() As Float = Array As Float(-0.25 * w, 0.2 * w, -0.15 * w, 0.1 * w, -0.05 * w, 0)
	Dim rot() As Float = Array As Float(-5, 3, -3, 2, -1, 0)
	
	For i = 0 To 5
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("translationX", Array As Object(tx(i)))
		anim.RunMethod("rotation", Array As Object(rot(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Mimics AndroidViewAnimations "Pulse"
Public Sub AnimatePulse(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Long = Max(1, iDurationMs / 2)
	Dim jo As JavaObject = vView
	Dim anim As JavaObject

	Try
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("scaleX", Array As Object(1.05))
		anim.RunMethod("scaleY", Array As Object(1.05))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimatePulse: " & LastException.Message)
	End Try
	Sleep(stepTime)
	Try
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("scaleX", Array As Object(1.0))
		anim.RunMethod("scaleY", Array As Object(1.0))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimatePulse: " & LastException.Message)
	End Try
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Pushes the current view off the screen to the left
Public Sub AnimateSlidePushLeftOut(vView As B4XView, iScreenWidth As Int, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationX", Array As Object(1.0 * -iScreenWidth))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Slides the new view in from the right edge
Public Sub AnimateSlidePushLeftIn(vView As B4XView, iScreenWidth As Int, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	' Snap to starting position off-screen right
	jo.RunMethod("setTranslationX", Array As Object(1.0 * iScreenWidth))
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationX", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Shrinks and slides the current view out
Public Sub AnimateZoomSlideOut(vView As B4XView, iScreenWidth As Int, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationX", Array As Object(-0.5 * iScreenWidth))
	anim.RunMethod("scaleX", Array As Object(0.8))
	anim.RunMethod("scaleY", Array As Object(0.8))
	anim.RunMethod("alpha", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Expands and slides the new view in
Public Sub AnimateZoomSlideIn(vView As B4XView, iScreenWidth As Int, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	' Snap to starting state
	jo.RunMethod("setTranslationX", Array As Object(0.5 * iScreenWidth))
	jo.RunMethod("setScaleX", Array As Object(0.8))
	jo.RunMethod("setScaleY", Array As Object(0.8))
	jo.RunMethod("setAlpha", Array As Object(0.0))
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationX", Array As Object(0.0))
	anim.RunMethod("scaleX", Array As Object(1.0))
	anim.RunMethod("scaleY", Array As Object(1.0))
	anim.RunMethod("alpha", Array As Object(1.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Drops the current view into the background
Public Sub AnimateStackOut(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(0.85))
	anim.RunMethod("scaleY", Array As Object(0.85))
	anim.RunMethod("alpha", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub


' Swings the current view out like a door turning left
Public Sub AnimateCubeLeftOut(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	' Pivot on the right edge
	jo.RunMethod("setPivotX", Array As Object(1.0 * vView.Width))
	jo.RunMethod("setPivotY", Array As Object(vView.Height / 2.0))
	Try
		jo.RunMethod("setCameraDistance", Array As Object(12000.0))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateCubeLeftOut: " & LastException.Message)
	End Try
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("rotationY", Array As Object(-90.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Swings the new view in like a door closing from the right
Public Sub AnimateCubeLeftIn(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	' Pivot on the left edge and start rotated 90 degrees away
	jo.RunMethod("setPivotX", Array As Object(0.0))
	jo.RunMethod("setPivotY", Array As Object(vView.Height / 2.0))
	jo.RunMethod("setRotationY", Array As Object(90.0))
	Try
		jo.RunMethod("setCameraDistance", Array As Object(12000.0))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateCubeLeftIn: " & LastException.Message)
	End Try
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("rotationY", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Squeezes the current view flat to the left
Public Sub AnimateAccordionOut(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	jo.RunMethod("setPivotX", Array As Object(0.0))
	jo.RunMethod("setPivotY", Array As Object(vView.Height / 2.0))
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Stretches the new view open from the right
Public Sub AnimateAccordionIn(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	' Snap to 0 width anchored to the right side
	jo.RunMethod("setPivotX", Array As Object(1.0 * vView.Width))
	jo.RunMethod("setPivotY", Array As Object(vView.Height / 2.0))
	jo.RunMethod("setScaleX", Array As Object(0.0))
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(1.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Mimics AndroidViewAnimations "Flash"
Public Sub AnimateFlash(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 4
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	Dim alphas() As Float = Array As Float(0.0, 1.0, 0.0, 1.0)
	
	For i = 0 To 3
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("alpha", Array As Object(alphas(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#End If
End Sub

' Mimics AndroidViewAnimations "Swing"
Public Sub AnimateSwing(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 5
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	jo.RunMethod("setPivotX", Array As Object(vView.Width / 2.0))
	jo.RunMethod("setPivotY", Array As Object(0.0)) ' Pivot top center
	
	Dim angles() As Float = Array As Float(15, -10, 5, -5, 0)
	For i = 0 To 4
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("rotation", Array As Object(angles(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#End If
End Sub

' Mimics AndroidViewAnimations "Bounce" (Attention style)
Public Sub AnimateAttentionBounce(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 4
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	Dim offsets() As Float = Array As Float(-30dip, 0, -15dip, 0)
	For i = 0 To 3
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("translationY", Array As Object(offsets(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#End If
End Sub

' Mimics AndroidViewAnimations "StandUp"
Public Sub AnimateStandUp(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 5
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	jo.RunMethod("setPivotX", Array As Object(vView.Width / 2.0))
	jo.RunMethod("setPivotY", Array As Object(vView.Height * 1.0)) ' Pivot bottom center
	
	Dim angles() As Float = Array As Float(55, -30, 15, -15, 0)
	For i = 0 To 4
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("rotationX", Array As Object(angles(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#End If
End Sub

' Mimics AndroidViewAnimations "Wave"
Public Sub AnimateWave(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 5
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	jo.RunMethod("setPivotX", Array As Object(vView.Width / 2.0))
	jo.RunMethod("setPivotY", Array As Object(vView.Height * 1.0))
	
	Dim angles() As Float = Array As Float(12, -12, 3, -3, 0)
	For i = 0 To 4
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("rotation", Array As Object(angles(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	#End If
End Sub

' Mimics AndroidViewAnimations "Hinge" (Swings from top left, then drops out)
Public Sub AnimateHinge(vView As B4XView, iDurationMs As Int)
	#If B4A
	Dim stepTime As Int = iDurationMs / 5
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	jo.RunMethod("setPivotX", Array As Object(0.0))
	jo.RunMethod("setPivotY", Array As Object(0.0)) ' Pivot top left
	
	Dim angles() As Float = Array As Float(80, 60, 80, 60)
	For i = 0 To 3
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("rotation", Array As Object(angles(i)))
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
		anim.RunMethod("start", Null)
		Sleep(stepTime)
	Next
	
	' Drop down and fade out
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationY", Array As Object(vView.Height * 2.0))
	anim.RunMethod("alpha", Array As Object(0.0))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(stepTime)))
	anim.RunMethod("start", Null)
	#End If
End Sub

' Mimics AndroidViewAnimations "Landing" & "TakingOff"
Public Sub AnimateFlight(vView As B4XView, sMode As String, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	Dim startAlpha As Float = IIf(sMode = "in", 0.0, 1.0)
	Dim targetAlpha As Float = IIf(sMode = "in", 1.0, 0.0)
	Dim startScale As Float = IIf(sMode = "in", 1.5, 1.0)
	Dim targetScale As Float = IIf(sMode = "in", 1.0, 1.5)
	
	If sMode = "in" Then
		jo.RunMethod("setScaleX", Array As Object(startScale))
		jo.RunMethod("setScaleY", Array As Object(startScale))
		jo.RunMethod("setAlpha", Array As Object(startAlpha))
	End If
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("scaleX", Array As Object(targetScale))
	anim.RunMethod("scaleY", Array As Object(targetScale))
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#End If
End Sub

' Mimics AndroidViewAnimations "RollIn" & "RollOut"
Public Sub AnimateRoll(vView As B4XView, sMode As String, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	Dim startAlpha As Float = IIf(sMode = "in", 0.0, 1.0)
	Dim targetAlpha As Float = IIf(sMode = "in", 1.0, 0.0)
	Dim startRot As Float = IIf(sMode = "in", -120.0, 0.0)
	Dim targetRot As Float = IIf(sMode = "in", 0.0, 120.0)
	Dim startX As Float = IIf(sMode = "in", -vView.Width * 1.0, 0.0)
	Dim targetX As Float = IIf(sMode = "in", 0.0, vView.Width * 1.0)
	
	If sMode = "in" Then
		jo.RunMethod("setTranslationX", Array As Object(startX))
		jo.RunMethod("setRotation", Array As Object(startRot))
		jo.RunMethod("setAlpha", Array As Object(startAlpha))
	End If
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationX", Array As Object(targetX))
	anim.RunMethod("rotation", Array As Object(targetRot))
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#End If
End Sub

' Handles ALL Fade animations (FadeIn, FadeOut, FadeInUp, FadeOutLeft, etc.)
' Mode: "in" or "out"
' Direction: "up", "down", "left", "right", or "none"
Public Sub AnimateFadeDirectional(vView As B4XView, sMode As String, sDirection As String, fOffsetPx As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	Dim startAlpha As Float = IIf(sMode = "in", 0.0, 1.0)
	Dim targetAlpha As Float = IIf(sMode = "in", 1.0, 0.0)
	Dim startX As Float = 0, startY As Float = 0
	Dim targetX As Float = 0, targetY As Float = 0
	
	If sMode = "in" Then
		If sDirection = "up" Then startY = fOffsetPx
		If sDirection = "down" Then startY = -fOffsetPx
		If sDirection = "left" Then startX = fOffsetPx
		If sDirection = "right" Then startX = -fOffsetPx
	Else
		If sDirection = "up" Then targetY = -fOffsetPx
		If sDirection = "down" Then targetY = fOffsetPx
		If sDirection = "left" Then targetX = -fOffsetPx
		If sDirection = "right" Then targetX = fOffsetPx
	End If
	
	If sMode = "in" Then
		jo.RunMethod("setAlpha", Array As Object(startAlpha))
		jo.RunMethod("setTranslationX", Array As Object(startX))
		jo.RunMethod("setTranslationY", Array As Object(startY))
	End If
	
	Dim fadeDuration As Long = Max(1, iDurationMs)
	Try
		anim = jo.RunMethodJO("animate", Null)
		anim.RunMethod("alpha", Array As Object(targetAlpha))
		anim.RunMethod("translationX", Array As Object(targetX))
		anim.RunMethod("translationY", Array As Object(targetY))
		anim.RunMethod("setDuration", Array As Object(fadeDuration))
		anim.RunMethod("start", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateFadeDirectional: " & LastException.Message)
	End Try
	#End If
End Sub

' Handles ALL Zoom animations (ZoomIn, ZoomOut, ZoomInDown, ZoomOutLeft, etc.)
Public Sub AnimateZoomDirectional(vView As B4XView, sMode As String, sDirection As String, fOffsetPx As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	Dim startAlpha As Float = IIf(sMode = "in", 0.0, 1.0)
	Dim targetAlpha As Float = IIf(sMode = "in", 1.0, 0.0)
	Dim startScale As Float = IIf(sMode = "in", 0.3, 1.0)
	Dim targetScale As Float = IIf(sMode = "in", 1.0, 0.3)
	
	Dim startX As Float = 0, startY As Float = 0
	Dim targetX As Float = 0, targetY As Float = 0
	
	If sMode = "in" Then
		If sDirection = "up" Then startY = fOffsetPx
		If sDirection = "down" Then startY = -fOffsetPx
		If sDirection = "left" Then startX = fOffsetPx
		If sDirection = "right" Then startX = -fOffsetPx
	Else
		If sDirection = "up" Then targetY = -fOffsetPx
		If sDirection = "down" Then targetY = fOffsetPx
		If sDirection = "left" Then targetX = -fOffsetPx
		If sDirection = "right" Then targetX = fOffsetPx
	End If
	
	If sMode = "in" Then
		jo.RunMethod("setAlpha", Array As Object(startAlpha))
		jo.RunMethod("setScaleX", Array As Object(startScale))
		jo.RunMethod("setScaleY", Array As Object(startScale))
		jo.RunMethod("setTranslationX", Array As Object(startX))
		jo.RunMethod("setTranslationY", Array As Object(startY))
	End If
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	anim.RunMethod("scaleX", Array As Object(targetScale))
	anim.RunMethod("scaleY", Array As Object(targetScale))
	anim.RunMethod("translationX", Array As Object(targetX))
	anim.RunMethod("translationY", Array As Object(targetY))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#End If
End Sub

' Handles ALL Slide animations (SlideInLeft, SlideOutUp, etc.)
' Exact same behavior as FadeDirectional but without altering the Alpha.
Public Sub AnimateSlideDirectional(vView As B4XView, sMode As String, sDirection As String, fOffsetPx As Float, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	
	Dim startX As Float = 0, startY As Float = 0
	Dim targetX As Float = 0, targetY As Float = 0
	
	If sMode = "in" Then
		If sDirection = "up" Then startY = fOffsetPx
		If sDirection = "down" Then startY = -fOffsetPx
		If sDirection = "left" Then startX = fOffsetPx
		If sDirection = "right" Then startX = -fOffsetPx
	Else
		If sDirection = "up" Then targetY = -fOffsetPx
		If sDirection = "down" Then targetY = fOffsetPx
		If sDirection = "left" Then targetX = -fOffsetPx
		If sDirection = "right" Then targetX = fOffsetPx
	End If
	
	If sMode = "in" Then
		jo.RunMethod("setTranslationX", Array As Object(startX))
		jo.RunMethod("setTranslationY", Array As Object(startY))
	End If
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("translationX", Array As Object(targetX))
	anim.RunMethod("translationY", Array As Object(targetY))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#End If
End Sub

' Handles ALL Flip Animations (FlipInX, FlipOutY)
Public Sub AnimateFlipDirectional(vView As B4XView, sMode As String, sAxis As String, iDurationMs As Int)
	#If B4A
	Dim jo As JavaObject = vView
	Dim anim As JavaObject
	Try
		jo.RunMethod("setCameraDistance", Array As Object(12000.0)) ' Prevents 3D clipping
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateFlipDirectional: " & LastException.Message)
	End Try
	
	Dim startAlpha As Float = IIf(sMode = "in", 0.0, 1.0)
	Dim targetAlpha As Float = IIf(sMode = "in", 1.0, 0.0)
	Dim startRot As Float = IIf(sMode = "in", 90.0, 0.0)
	Dim targetRot As Float = IIf(sMode = "in", 0.0, 90.0)
	
	If sMode = "in" Then
		jo.RunMethod("setAlpha", Array As Object(startAlpha))
		If sAxis.ToUpperCase = "X" Then jo.RunMethod("setRotationX", Array As Object(startRot))
		If sAxis.ToUpperCase = "Y" Then jo.RunMethod("setRotationY", Array As Object(startRot))
	End If
	
	anim = jo.RunMethodJO("animate", Null)
	anim.RunMethod("alpha", Array As Object(targetAlpha))
	If sAxis.ToUpperCase = "X" Then anim.RunMethod("rotationX", Array As Object(targetRot))
	If sAxis.ToUpperCase = "Y" Then anim.RunMethod("rotationY", Array As Object(targetRot))
	anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
	anim.RunMethod("start", Null)
	#End If
End Sub


' Evaluates any of the 30 Robert Penner easing equations dynamically by name.
' Time: current time (0 to Duration)
' StartValue: starting value
' ChangeInValue: total delta change
' Duration: total animation duration in ms
Public Sub EvaluateEasing(sEaseName As String, fTime As Float, fStartValue As Float, fChangeInValue As Float, iDuration As Int) As Float
    Select Case sEaseName.ToLowerCase.Replace(" ", "").Replace("_", "").Replace("-", "")
        Case "linear", "lineartween"
            Return linearTween(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinquad", "quadin"
            Return easeInQuad(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutquad", "quadout"
            Return easeOutQuad(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutquad", "quadinout"
            Return easeInOutQuad(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeincubic", "cubicin"
            Return easeInCubic(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutcubic", "cubicout"
            Return easeOutCubic(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutcubic", "cubicinout"
            Return easeInOutCubic(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinquart", "quartin"
            Return easeInQuart(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutquart", "quartout"
            Return easeOutQuart(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutquart", "quartinout"
            Return easeInOutQuart(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinquint", "quintin"
            Return easeInQuint(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutquint", "quintout"
            Return easeOutQuint(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutquint", "quintinout"
            Return easeInOutQuint(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinsine", "sinein"
            Return easeInSine(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutsine", "sineout"
            Return easeOutSine(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutsine", "sineinout"
            Return easeInOutSine(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinexpo", "expoin", "expin"
            Return easeInExpo(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutexpo", "expoout", "expout"
            Return easeOutExpo(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutexpo", "expoinout", "expinout"
            Return easeInOutExpo(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeincirc", "circin"
            Return easeInCirc(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutcirc", "circout"
            Return easeOutCirc(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutcirc", "circinout"
            Return easeInOutCirc(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinback", "backin"
            Return easeInBack(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutback", "backout"
            Return easeOutBack(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutback", "backinout"
            Return easeInOutBack(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinbounce", "bouncein"
            Return easeInBounce(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutbounce", "bounceout"
            Return easeOutBounce(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutbounce", "bounceinout"
            Return easeInOutBounce(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinelastic", "elasticin"
            Return easeInElastic(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeoutelastic", "elasticout"
            Return easeOutElastic(fTime, fStartValue, fChangeInValue, iDuration)
        Case "easeinoutelastic", "elasticinout"
            Return easeInOutElastic(fTime, fStartValue, fChangeInValue, iDuration)
        Case Else
			Return linearTween(fTime, fStartValue, fChangeInValue, iDuration)
	End Select
End Sub

'Enhanced version of AnimateExtended.
'Adds Z rotation, easing and start delay.
'The existing AnimateExtended method remains untouched.
Public Sub AnimateExtended2( _
    vView As B4XView, _
    fAlpha As Float, _
    fTransX As Float, _
    fTransY As Float, _
    fScaleX As Float, _
    fScaleY As Float, _
    fRotation As Float, _
    fRotX As Float, _
    fRotY As Float, _
    iDurationMs As Int, _
    sEasing As String, _
    iDelayMs As Int)

    #If B4A

	Dim jo As JavaObject = vView
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)

	anim.RunMethod("cancel", Null)

	Try
		anim.RunMethod("setDuration", Array As Object(SafeDurationMs(iDurationMs)))
		anim.RunMethod("setStartDelay", Array As Object(SafeDurationMs(iDelayMs)))

		Dim interpolator As JavaObject = CreateInterpolator2(sEasing)

		If interpolator.IsInitialized Then
			anim.RunMethod("setInterpolator", Array As Object(interpolator))
		End If

	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAnimation.AnimateExtended2: " & LastException.Message)
	End Try

	anim.RunMethod("alpha", Array As Object(fAlpha))
	anim.RunMethod("translationX", Array As Object(fTransX))
	anim.RunMethod("translationY", Array As Object(fTransY))
	anim.RunMethod("scaleX", Array As Object(fScaleX))
	anim.RunMethod("scaleY", Array As Object(fScaleY))
	anim.RunMethod("rotation", Array As Object(fRotation))
	anim.RunMethod("rotationX", Array As Object(fRotX))
	anim.RunMethod("rotationY", Array As Object(fRotY))

	anim.RunMethod("start", Null)

    #Else

    Dim ignore As Object = vView
    Dim ignore1 As Float = fAlpha
    Dim ignore2 As Float = fTransX
    Dim ignore3 As Float = fTransY
    Dim ignore4 As Float = fScaleX
    Dim ignore5 As Float = fScaleY
    Dim ignore6 As Float = fRotation
    Dim ignore7 As Float = fRotX
    Dim ignore8 As Float = fRotY
    Dim ignore9 As Int = iDurationMs
    Dim ignore10 As String = sEasing
    Dim ignore11 As Int = iDelayMs

    #End If

End Sub

Private Sub CreateInterpolator2(sEasing As String) As JavaObject

    #If B4A

	Dim easing As String = sEasing.ToLowerCase.Replace(" ", "").Replace("_", "").Replace("-", "")

	Dim jo As JavaObject

	Select Case easing

		Case "", "linear", "lineartween"
			jo.InitializeNewInstance("android.view.animation.LinearInterpolator", Null)

		Case "easein", "easeinquad", "quadin"
			jo.InitializeNewInstance("android.view.animation.AccelerateInterpolator", Null)

		Case "easeout", "easeoutquad", "quadout"
			jo.InitializeNewInstance("android.view.animation.DecelerateInterpolator", Null)

		Case "easeinout", "easeinoutquad", "quadinout"
			jo.InitializeNewInstance("android.view.animation.AccelerateDecelerateInterpolator", Null)

		Case Else
			jo.InitializeNewInstance("android.view.animation.LinearInterpolator", Null)

	End Select

	Return jo

    #Else

    Return Null

    #End If

End Sub