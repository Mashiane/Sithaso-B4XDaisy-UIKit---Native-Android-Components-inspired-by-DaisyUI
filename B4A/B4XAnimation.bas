B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
End Sub

Public Sub Initialize
End Sub

Public Sub SetNativeAlpha(v As B4XView, AlphaValue As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setAlpha", Array As Object(AlphaValue))
	#Else
	Dim ignore As Object = v
	Dim ignore2 As Float = AlphaValue
	#End If
End Sub

Public Sub SetNativeRotation(v As B4XView, Degrees As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setRotation", Array As Object(Degrees))
	#Else
	Dim ignore As Object = v
	Dim ignore2 As Float = Degrees
	#End If
End Sub

Public Sub SetNativeRotationY(v As B4XView, Degrees As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setRotationY", Array As Object(Degrees))
	#Else
	Dim ignore As Object = v
	Dim ignore2 As Float = Degrees
	#End If
End Sub

Public Sub AnimateLayerNative(v As B4XView, AlphaValue As Float, Degrees As Float, DegreesY As Float, DurationMs As Int)
	#If B4A
	Dim jo As JavaObject = v
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	Dim safeDuration As Long = Max(0, DurationMs)
	anim.RunMethod("cancel", Null)
	anim.RunMethod("alpha", Array As Object(AlphaValue))
	anim.RunMethod("rotation", Array As Object(Degrees))
	anim.RunMethod("rotationY", Array As Object(DegreesY))
	Try
		anim.RunMethod("setDuration", Array As Object(safeDuration))
	Catch
	End Try
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = v
	Dim ignore1 As Float = AlphaValue
	Dim ignore2 As Float = Degrees
	Dim ignore3 As Float = DegreesY
	Dim ignore4 As Int = DurationMs
	#End If
End Sub

Public Sub SetNativeCameraDistance(v As B4XView, DistancePx As Float)
	#If B4A
	Dim jo As JavaObject = v
	Dim safeDistance As Float = Max(0, DistancePx)
	Try
		jo.RunMethod("setCameraDistance", Array As Object(safeDistance))
	Catch
	End Try
	#Else
	Dim ignore As Object = v
	Dim ignore2 As Float = DistancePx
	#End If
End Sub

'Sets the translationX property of a view without animation.
Public Sub SetTranslationX(v As B4XView, TranslationXPx As Float)
	#If B4A
	Dim jo As JavaObject = v
	jo.RunMethod("setTranslationX", Array As Object(TranslationXPx))
	#Else
	Dim ignore As Object = v
	Dim ignore2 As Float = TranslationXPx
	#End If
End Sub

'Animates the translationX property using ViewPropertyAnimator (hardware-accelerated).
Public Sub AnimateTranslationX(v As B4XView, TranslationXPx As Float, DurationMs As Int)
	#If B4A
	Dim jo As JavaObject = v
	Dim anim As JavaObject = jo.RunMethodJO("animate", Null)
	anim.RunMethod("cancel", Null)
	anim.RunMethod("translationX", Array As Object(TranslationXPx))
	Try
		anim.RunMethod("setDuration", Array As Object(Max(0, DurationMs)))
	Catch
	End Try
	anim.RunMethod("setInterpolator", Array(CreateLinearInterpolator))
	anim.RunMethod("start", Null)
	#Else
	Dim ignore As Object = v
	Dim ignore1 As Float = TranslationXPx
	Dim ignore2 As Int = DurationMs
	#End If
End Sub

Private Sub CreateLinearInterpolator As JavaObject
	Dim li As JavaObject
	li.InitializeNewInstance("android.view.animation.LinearInterpolator", Null)
	Return li
End Sub
