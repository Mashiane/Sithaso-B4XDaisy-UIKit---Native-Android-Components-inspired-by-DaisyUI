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
		Log($"B4XAnimation warning: setDuration unavailable (${LastException.Message})."$)
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
		Log($"B4XAnimation warning: setCameraDistance unavailable (${LastException.Message})."$)
	End Try
	#Else
	Dim ignore As Object = v
	Dim ignore2 As Float = DistancePx
	#End If
End Sub
