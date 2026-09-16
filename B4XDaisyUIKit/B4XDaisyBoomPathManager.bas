B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=1.1
@EndOfDesignText@
#IgnoreWarnings:12,9

' B4XDaisyBoomPathManager - Calculates animation paths for boom buttons.
' Faithful port of com.nightonke.boommenu.Animation.AnimationManager.calculateShowXY.
'
' Original model (critical): the path is a Lagrange parabola through three points.
' For PARABOLA_1/2 and HORIZONTAL_THROW_1/2 the FREE parameter is x (eased in the
' original) and y = a*x^2 + b*x + c. For PARABOLA_3/4 the free parameter is y and
' x = a*y^2 + b*y + c (the parabola bows horizontally). PARABOLA_2/4 need the
' overlay (parent) size for their parent-relative control point. |dx| < 1 forces
' LINE to avoid a degenerate parabola.
'
' Deviation: the original bakes easing into the free-parameter sampling (x is
' eased, y solved from the parabola). The port samples the free parameter LINEARLY
' here and applies easing later in AnimateAlongPath by indexing into the path with
' easedProgress. For LINE this is identical; for the parabolas the curve SHAPE
' matches the original exactly while the eased motion-along-curve differs slightly.

Sub Class_Globals
	Private xui As XUI
End Sub

Public Sub Initialize
End Sub

' Main entry: returns List of Map(x,y) for each frame along the path.
' ParentWidth/ParentHeight are the overlay size (needed by PARABOLA_2/4).
Public Sub CalculatePath(BoomType As String, StartX As Float, StartY As Float, EndX As Float, EndY As Float, _
		ParentWidth As Float, ParentHeight As Float, DurationMs As Int) As List
	Dim result As List
	result.Initialize

	Dim frames As Int = Max(2, DurationMs / 16)

	Dim bt As String = BoomType.ToUpperCase
	' |dx| < 1 -> LINE (original guard against a degenerate / vertical parabola).
	If Abs(EndX - StartX) < 1 And bt <> "LINE" Then
		bt = "LINE"
	End If

	Select Case bt
		Case "LINE"
			result.AddAll(CalculateLinePath(StartX, StartY, EndX, EndY, frames))
		Case "PARABOLA_1"
			' Bows up: control y = 3/4 of the higher endpoint.
			result.AddAll(CalculateParabolaYOfX(StartX, StartY, EndX, EndY, _
				(StartX + EndX) / 2, Min(StartY, EndY) * 3.0 / 4, frames))
		Case "PARABOLA_2"
			' Bows down: control y between parentHeight and the lower endpoint.
			result.AddAll(CalculateParabolaYOfX(StartX, StartY, EndX, EndY, _
				(StartX + EndX) / 2, (ParentHeight + Max(StartY, EndY)) / 2, frames))
		Case "PARABOLA_3"
			' Bows left (x is dependent): control x = half the smaller endpoint x.
			result.AddAll(CalculateParabolaXOfY(StartX, StartY, EndX, EndY, _
				Min(StartX, EndX) / 2, (StartY + EndY) / 2, frames))
		Case "PARABOLA_4"
			' Bows right (x is dependent): control x between parentWidth and larger x.
			result.AddAll(CalculateParabolaXOfY(StartX, StartY, EndX, EndY, _
				(ParentWidth + Max(StartX, EndX)) / 2, (StartY + EndY) / 2, frames))
		Case "H_THROW_1"
			' Throw past the end, then settle. Control at (2*EndX-StartX, StartY).
			result.AddAll(CalculateParabolaYOfX(StartX, StartY, EndX, EndY, _
				2 * EndX - StartX, StartY, frames))
		Case "H_THROW_2"
			' Throw past the start, then settle to the end. Free parameter must run
			' Start -> End (trigger -> slot) so the boom flies OUT of the trigger, not
			' into it. Control point (2*StartX-EndX, EndY) matches the original
			' calculateShowXY HORIZONTAL_THROW_2 (x3 = 2*start - end). The earlier swap of
			' the first two arg pairs reversed traversal to slot -> trigger, which piled
			' buttons on the trigger during boom. Hide reuses this path via
			' AnimateAlongPathReverse (slot -> trigger), matching calculateHideXY.
			result.AddAll(CalculateParabolaYOfX(StartX, StartY, EndX, EndY, _
				2 * StartX - EndX, EndY, frames))
		Case "RANDOM"
			Dim types() As String = Array As String("LINE", "PARABOLA_1", "PARABOLA_2", "PARABOLA_3", "PARABOLA_4", "H_THROW_1", "H_THROW_2")
			Dim randomType As String = types(Rnd(0, types.Length))
			result.AddAll(CalculatePath(randomType, StartX, StartY, EndX, EndY, ParentWidth, ParentHeight, DurationMs))
		Case Else
			result.AddAll(CalculateLinePath(StartX, StartY, EndX, EndY, frames))
	End Select

	Return result
End Sub

' Straight line interpolation (frames+1 samples, t = 0..1).
Private Sub CalculateLinePath(fStartX As Float, fStartY As Float, fEndX As Float, fEndY As Float, iFrames As Int) As List
	Dim result As List
	result.Initialize
	For i = 0 To iFrames
		Dim t As Float = i / iFrames
		result.Add(CreateMap("x": fStartX + (fEndX - fStartX) * t, "y": fStartY + (fEndY - fStartY) * t))
	Next
	Return result
End Sub

' Parabola y = a*x^2 + b*x + c through (x1,y1),(x2,y2),(x3,y3). x is the free
' parameter sampled linearly from x1 to x2; y is solved from the parabola.
' Matches the original calculateShowXY PARABOLA_1/2 and HORIZONTAL_THROW cases.
Private Sub CalculateParabolaYOfX(fX1 As Float, fY1 As Float, fX2 As Float, fY2 As Float, fX3 As Float, fY3 As Float, iFrames As Int) As List
	Dim result As List
	result.Initialize

	Dim den As Float = fX1 * fX1 * (fX2 - fX3) + fX2 * fX2 * (fX3 - fX1) + fX3 * fX3 * (fX1 - fX2)
	If Abs(den) < 0.0001 Then
		' Collinear / degenerate control point -> straight line.
		Return CalculateLinePath(fX1, fY1, fX2, fY2, iFrames)
	End If

	Dim a As Float = (fY1 * (fX2 - fX3) + fY2 * (fX3 - fX1) + fY3 * (fX1 - fX2)) / den
	Dim b As Float = (fY1 - fY2) / (fX1 - fX2) - a * (fX1 + fX2)
	Dim c As Float = fY1 - fX1 * fX1 * a - fX1 * b

	For i = 0 To iFrames
		Dim t As Float = i / iFrames
		Dim x As Float = fX1 + (fX2 - fX1) * t
		Dim y As Float = a * x * x + b * x + c
		result.Add(CreateMap("x": x, "y": y))
	Next
	Return result
End Sub

' Parabola x = a*y^2 + b*y + c through (x1,y1),(x2,y2),(x3,y3). y is the free
' parameter sampled linearly from y1 to y2; x is solved from the parabola (the
' parabola bows horizontally). Matches the original PARABOLA_3/4 cases.
Private Sub CalculateParabolaXOfY(fX1 As Float, fY1 As Float, fX2 As Float, fY2 As Float, fX3 As Float, fY3 As Float, iFrames As Int) As List
	Dim result As List
	result.Initialize

	Dim den As Float = fY1 * fY1 * (fY2 - fY3) + fY2 * fY2 * (fY3 - fY1) + fY3 * fY3 * (fY1 - fY2)
	If Abs(den) < 0.0001 Then
		Return CalculateLinePath(fX1, fY1, fX2, fY2, iFrames)
	End If

	Dim a As Float = (fX1 * (fY2 - fY3) + fX2 * (fY3 - fY1) + fX3 * (fY1 - fY2)) / den
	Dim b As Float = (fX1 - fX2) / (fY1 - fY2) - a * (fY1 + fY2)
	Dim c As Float = fX1 - fY1 * fY1 * a - fY1 * b

	For i = 0 To iFrames
		Dim t As Float = i / iFrames
		Dim y As Float = fY1 + (fY2 - fY1) * t
		Dim x As Float = a * y * y + b * y + c
		result.Add(CreateMap("x": x, "y": y))
	Next
	Return result
End Sub
