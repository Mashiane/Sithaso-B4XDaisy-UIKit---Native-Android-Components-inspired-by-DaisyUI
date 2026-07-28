B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=1.1
@EndOfDesignText@
#IgnoreWarnings:12,9

' ButtonPlaceManager - Calculates end positions for boom buttons.
' Faithful port of com.nightonke.boommenu.BoomButtons.ButtonPlaceManager (radius overload).
'
' Original model (critical): button end-positions are computed in the OVERLAY/parent
' coordinate system, NOT relative to the trigger. The flow is:
'   1. Compute center offsets relative to the cluster origin (0,0) = the center slot.
'   2. Shift by parentCenter (parentW/2, parentH/2).
'   3. Shift by the alignment offset (Center/Top/Bottom/Left/Right/TL/TR/BL/BR) so the
'      cluster anchors to a corner/edge with margins.
'   4. Convert center -> top-left by subtracting the radius.
' The trigger position is only the animation START; it does not determine end positions.
' Default alignment is Center (original default_bmb_buttonPlaceAlignmentEnum = 0).
'
' Deviation from original: the original's adjust() uses parentSize.y for the xOffset of
' Right/TR/BR alignments (an apparent copy-paste bug). We use parentSize.x for x offsets.

Sub Class_Globals
	Private xui As XUI
End Sub

Public Sub Initialize
End Sub

' Buttons: offsets + overlay-center + alignment. Returns List of Map(x,y,width,height) as top-left rects.
Public Sub CalculatePositions(ButtonPlace As String, ParentWidth As Float, ParentHeight As Float, _
		ButtonSize As Int, HMargin As Int, VMargin As Int, IMargin As Int, EdgeMargin As Int, _
		Alignment As String, MaxCount As Int) As List
	Dim radius As Float = ButtonSize / 2.0
	Dim offsets As List = CalculateOffsets(NormalizePlace(ButtonPlace), radius, HMargin, VMargin, IMargin, MaxCount)

	' Shift to overlay center.
	ShiftBy(offsets, ParentWidth / 2.0, ParentHeight / 2.0)

	' Apply alignment anchoring (half-width = half-height = radius for circle buttons).
	ApplyAlignment(offsets, ParentWidth, ParentHeight, radius, EdgeMargin, Alignment)

	' Convert center -> top-left and build rects.
	Return ToTopLeftRects(offsets, radius, ButtonSize)
End Sub

' Pieces: offsets + overlay-center, NO alignment (matches original PiecePlaceManager which
' only does po + parentSize/2). Returns List of Map(x,y,width,height) as top-left rects.
Public Sub CalculatePiecePositions(PiecePlace As String, ParentWidth As Float, ParentHeight As Float, _
		PieceSize As Int, HMargin As Int, VMargin As Int, IMargin As Int, MaxCount As Int) As List
	Dim radius As Float = PieceSize / 2.0
	Dim offsets As List = CalculateOffsets(NormalizePlace(PiecePlace), radius, HMargin, VMargin, IMargin, MaxCount)
	ShiftBy(offsets, ParentWidth / 2.0, ParentHeight / 2.0)
	Return ToTopLeftRects(offsets, radius, PieceSize)
End Sub

' Rectangle buttons (Ham): offsets + overlay-center + alignment, using w/h instead of a
' radius. HAM_1..6 / VERTICAL = vertical stack; HORIZONTAL = horizontal stack. This mirrors
' the original rectangle overload for the Ham/Horizontal/Vertical cases (the only place
' enums used with Ham buttons). Returns List of Map(x,y,width,height) as top-left rects.
Public Sub CalculateRectPositions(ButtonPlace As String, ParentWidth As Float, ParentHeight As Float, _
		ButtonWidth As Int, ButtonHeight As Int, HMargin As Int, VMargin As Int, _
		EdgeMargin As Int, Alignment As String, MaxCount As Int) As List
	Dim offsets As List
	offsets.Initialize
	Dim key As String = NormalizePlace(ButtonPlace)
	If key = "HORIZONTAL" Then
		AddHorizontalOffsets(offsets, ButtonWidth / 2.0, ButtonWidth, HMargin, MaxCount)
	Else
		' VERTICAL and HAM_1..6 (NormalizePlace maps HAM_x -> VERTICAL) both stack vertically.
		AddVerticalOffsets(offsets, ButtonHeight / 2.0, ButtonHeight, VMargin, MaxCount)
	End If

	ShiftBy(offsets, ParentWidth / 2.0, ParentHeight / 2.0)
	ApplyAlignmentRect(offsets, ParentWidth, ParentHeight, ButtonWidth / 2.0, ButtonHeight / 2.0, EdgeMargin, Alignment)
	Return ToTopLeftRectsRect(offsets, ButtonWidth / 2.0, ButtonHeight / 2.0, ButtonWidth, ButtonHeight)
End Sub

' Ham pieces: vertical stack of thin bars (hamWidth x hamHeight) with the piece vertical
' margin, centered on the overlay (no alignment). Mirrors PiecePlaceManager.getHamPositions.
Public Sub CalculateHamPiecePositions(ParentWidth As Float, ParentHeight As Float, _
		PieceWidth As Int, PieceHeight As Int, VMargin As Int, MaxCount As Int) As List
	Dim offsets As List
	offsets.Initialize
	AddVerticalOffsets(offsets, PieceHeight / 2.0, PieceHeight, VMargin, MaxCount)
	ShiftBy(offsets, ParentWidth / 2.0, ParentHeight / 2.0)
	Return ToTopLeftRectsRect(offsets, PieceWidth / 2.0, PieceHeight / 2.0, PieceWidth, PieceHeight)
End Sub

' CUSTOM positions: convert user-provided center points (Map with x,y) to top-left rects.
' CustomPositions: List of Map("x": centerX, "y": centerY) in overlay coordinates (0,0 = top-left).
' HalfW/HalfH: half width/height of the piece/button.
' Returns List of Map(x,y,width,height) as top-left rects.
Public Sub CalculateCustomPositions(CustomPositions As List, ParentWidth As Float, ParentHeight As Float, _
		HalfW As Float, HalfH As Float, Width As Int, Height As Int) As List
	Dim rects As List
	rects.Initialize
	For Each pos As Map In CustomPositions
		Dim cx As Float = pos.GetDefault("x", ParentWidth / 2)
		Dim cy As Float = pos.GetDefault("y", ParentHeight / 2)
		Dim m As Map = CreateMap("x": Round(cx - HalfW), "y": Round(cy - HalfH), "width": Width, "height": Height)
		rects.Add(m)
	Next
	Return rects
End Sub

' Strip the SC_/DOT_ prefix so button-place and piece-place share one offset table.
' Returns the sub-variant key, e.g. SC_9_1 -> "9_1", DOT_3_3 -> "3_3". Bare family names
' (SC_3, SC_5, SC_7) collapse to their _1 sub-variant for backward compatibility.
' HAM_1..6 map to VERTICAL (the original reuses the vertical stack for all HAM places).
' HORIZONTAL/VERTICAL/CUSTOM/SHARE pass through.
Private Sub NormalizePlace(Place As String) As String
	Dim p As String = Place.ToUpperCase
	If p.StartsWith("HAM_") Then Return "VERTICAL"
	If p.StartsWith("SC_") Then
		p = p.SubString(3)
	Else If p.StartsWith("DOT_") Then
		p = p.SubString(4)
	End If
	If p = "2" Then Return "2_1"
	If p = "3" Then Return "3_1"
	If p = "4" Then Return "4_1"
	If p = "5" Then Return "5_1"
	If p = "6" Then Return "6_1"
	If p = "7" Then Return "7_1"
	If p = "8" Then Return "8_1"
	If p = "9" Then Return "9_1"
	Return p
End Sub

' Returns List of Map(x,y) center-offsets relative to the cluster origin (0,0).
' Point lists are copied 1:1 from the original radius overload (r_2_0 = 2r, r_3_0 = 3r)
' covering all 35 SC_/DOT_ sub-variants. HAM_1..6 reuse the vertical stack.
Private Sub CalculateOffsets(PlaceKey As String, Radius As Float, HMargin As Int, VMargin As Int, IMargin As Int, MaxCount As Int) As List
	Dim result As List
	result.Initialize

	Dim r As Float = Radius
	Dim r_2_0 As Float = 2 * r
	Dim r_3_0 As Float = 3 * r
	Dim hm As Float = HMargin
	Dim hm_0_5 As Float = hm / 2
	Dim hm_1_5 As Float = hm * 1.5
	Dim vm As Float = VMargin
	Dim vm_0_5 As Float = vm / 2
	Dim vm_1_5 As Float = vm * 1.5
	Dim im As Float = IMargin

	' Default triangle constants (used by SC_3_3/SC_5_1/SC_6_3.../SC_9_2 etc.).
	Dim b As Float = hm_0_5 + r
	Dim c As Float = b / (Sqrt(3) / 2)
	Dim a As Float = c / 2
	Dim e As Float = c - a

	' Inclined override for SC_4_2/SC_5_4/SC_8_5/SC_9_3 (45deg grid, a = (2r+im)/sqrt2).
	If PlaceKey = "4_2" Or PlaceKey = "5_4" Or PlaceKey = "8_5" Or PlaceKey = "9_3" Then
		a = (r_2_0 + im) / Sqrt(2)
	End If

	' SC_8_2 special: vertical triangle base b = vm_0_5 + r (control recomputed).
	If PlaceKey = "8_2" Then
		b = vm_0_5 + r
		c = b / (Sqrt(3) / 2)
		a = c / 2
		e = c - a
	End If

	Dim a_2_0 As Float = 2 * a
	Dim b_2_0 As Float = 2 * b
	Dim b_3_0 As Float = 3 * b
	Dim c_2_0 As Float = 2 * c

	Select Case PlaceKey
		Case "1"
			result.Add(OffsetPoint(0, 0))

		Case "2_1"
			result.Add(OffsetPoint(-hm_0_5 - r, 0))
			result.Add(OffsetPoint(hm_0_5 + r, 0))

		Case "2_2"
			result.Add(OffsetPoint(0, -vm_0_5 - r))
			result.Add(OffsetPoint(0, vm_0_5 + r))

		Case "3_1"
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))

		Case "3_2"
			result.Add(OffsetPoint(0, -vm - r_2_0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(0, vm + r_2_0))

		Case "3_3"
			result.Add(OffsetPoint(-b, -a))
			result.Add(OffsetPoint(b, -a))
			result.Add(OffsetPoint(0, c))

		Case "3_4"
			result.Add(OffsetPoint(0, -c))
			result.Add(OffsetPoint(-b, a))
			result.Add(OffsetPoint(b, a))

		Case "4_1"
			result.Add(OffsetPoint(-hm_0_5 - r, -vm_0_5 - r))
			result.Add(OffsetPoint(hm_0_5 + r, -vm_0_5 - r))
			result.Add(OffsetPoint(-hm_0_5 - r, vm_0_5 + r))
			result.Add(OffsetPoint(hm_0_5 + r, vm_0_5 + r))

		Case "4_2"
			result.Add(OffsetPoint(0, -a))
			result.Add(OffsetPoint(-a, 0))
			result.Add(OffsetPoint(a, 0))
			result.Add(OffsetPoint(0, a))

		Case "5_1"
			result.Add(OffsetPoint(-b_2_0, -c))
			result.Add(OffsetPoint(0, -c))
			result.Add(OffsetPoint(b_2_0, -c))
			result.Add(OffsetPoint(-hm_0_5 - r, a))
			result.Add(OffsetPoint(hm_0_5 + r, a))

		Case "5_2"
			result.Add(OffsetPoint(-hm_0_5 - r, -a))
			result.Add(OffsetPoint(hm_0_5 + r, -a))
			result.Add(OffsetPoint(-b_2_0, c))
			result.Add(OffsetPoint(0, c))
			result.Add(OffsetPoint(b_2_0, c))

		Case "5_3"
			result.Add(OffsetPoint(0, -vm - r_2_0))
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))
			result.Add(OffsetPoint(0, vm + r_2_0))

		Case "5_4"
			result.Add(OffsetPoint(-a, -a))
			result.Add(OffsetPoint(a, -a))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(-a, a))
			result.Add(OffsetPoint(a, a))

		Case "6_1"
			result.Add(OffsetPoint(-hm - r_2_0, -vm_0_5 - r))
			result.Add(OffsetPoint(0, -vm_0_5 - r))
			result.Add(OffsetPoint(hm + r_2_0, -vm_0_5 - r))
			result.Add(OffsetPoint(-hm - r_2_0, vm_0_5 + r))
			result.Add(OffsetPoint(0, vm_0_5 + r))
			result.Add(OffsetPoint(hm + r_2_0, vm_0_5 + r))

		Case "6_2"
			result.Add(OffsetPoint(-hm_0_5 - r, -vm - r_2_0))
			result.Add(OffsetPoint(hm_0_5 + r, -vm - r_2_0))
			result.Add(OffsetPoint(-hm_0_5 - r, 0))
			result.Add(OffsetPoint(hm_0_5 + r, 0))
			result.Add(OffsetPoint(-hm_0_5 - r, vm + r_2_0))
			result.Add(OffsetPoint(hm_0_5 + r, vm + r_2_0))

		Case "6_3"
			result.Add(OffsetPoint(-b, -a - c))
			result.Add(OffsetPoint(b, -a - c))
			result.Add(OffsetPoint(-b_2_0, 0))
			result.Add(OffsetPoint(b_2_0, 0))
			result.Add(OffsetPoint(-b, a + c))
			result.Add(OffsetPoint(b, a + c))

		Case "6_4"
			result.Add(OffsetPoint(0, -b_2_0))
			result.Add(OffsetPoint(-a - c, -b))
			result.Add(OffsetPoint(a + c, -b))
			result.Add(OffsetPoint(-a - c, b))
			result.Add(OffsetPoint(a + c, b))
			result.Add(OffsetPoint(0, b_2_0))

		Case "6_5"
			result.Add(OffsetPoint(-b_2_0, -a - c + e))
			result.Add(OffsetPoint(0, -a - c + e))
			result.Add(OffsetPoint(b_2_0, -a - c + e))
			result.Add(OffsetPoint(-hm_0_5 - r, e))
			result.Add(OffsetPoint(hm_0_5 + r, e))
			result.Add(OffsetPoint(0, a + c + e))

		Case "6_6"
			result.Add(OffsetPoint(0, -a - c - e))
			result.Add(OffsetPoint(-hm_0_5 - r, -e))
			result.Add(OffsetPoint(hm_0_5 + r, -e))
			result.Add(OffsetPoint(-b_2_0, a + c - e))
			result.Add(OffsetPoint(0, a + c - e))
			result.Add(OffsetPoint(b_2_0, a + c - e))

		Case "7_1"
			result.Add(OffsetPoint(-hm - r_2_0, -vm - r_2_0))
			result.Add(OffsetPoint(0, -vm - r_2_0))
			result.Add(OffsetPoint(hm + r_2_0, -vm - r_2_0))
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))
			result.Add(OffsetPoint(0, vm + r_2_0))

		Case "7_2"
			result.Add(OffsetPoint(0, -vm - r_2_0))
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))
			result.Add(OffsetPoint(-hm - r_2_0, vm + r_2_0))
			result.Add(OffsetPoint(0, vm + r_2_0))
			result.Add(OffsetPoint(hm + r_2_0, vm + r_2_0))

		Case "7_3"
			result.Add(OffsetPoint(-b, -a - c))
			result.Add(OffsetPoint(b, -a - c))
			result.Add(OffsetPoint(-b_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(b_2_0, 0))
			result.Add(OffsetPoint(-b, a + c))
			result.Add(OffsetPoint(b, a + c))

		Case "7_4"
			result.Add(OffsetPoint(0, -b_2_0))
			result.Add(OffsetPoint(-a - c, -b))
			result.Add(OffsetPoint(a + c, -b))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(-a - c, b))
			result.Add(OffsetPoint(a + c, b))
			result.Add(OffsetPoint(0, b_2_0))

		Case "7_5"
			result.Add(OffsetPoint(-b_3_0, -a))
			result.Add(OffsetPoint(-b, -a))
			result.Add(OffsetPoint(b, -a))
			result.Add(OffsetPoint(b_3_0, -a))
			result.Add(OffsetPoint(-b_2_0, c))
			result.Add(OffsetPoint(0, c))
			result.Add(OffsetPoint(b_2_0, c))

		Case "7_6"
			result.Add(OffsetPoint(-b_2_0, -c))
			result.Add(OffsetPoint(0, -c))
			result.Add(OffsetPoint(b_2_0, -c))
			result.Add(OffsetPoint(-b_3_0, a))
			result.Add(OffsetPoint(-b, a))
			result.Add(OffsetPoint(b, a))
			result.Add(OffsetPoint(b_3_0, a))

		Case "8_1"
			result.Add(OffsetPoint(-b_2_0, -a - c))
			result.Add(OffsetPoint(0, -a - c))
			result.Add(OffsetPoint(b_2_0, -a - c))
			result.Add(OffsetPoint(-hm_0_5 - r, 0))
			result.Add(OffsetPoint(hm_0_5 + r, 0))
			result.Add(OffsetPoint(-b_2_0, a + c))
			result.Add(OffsetPoint(0, a + c))
			result.Add(OffsetPoint(b_2_0, a + c))

		Case "8_2"
			result.Add(OffsetPoint(-a - c, -b_2_0))
			result.Add(OffsetPoint(a + c, -b_2_0))
			result.Add(OffsetPoint(0, -vm_0_5 - r))
			result.Add(OffsetPoint(-a - c, 0))
			result.Add(OffsetPoint(a + c, 0))
			result.Add(OffsetPoint(0, vm_0_5 + r))
			result.Add(OffsetPoint(-a - c, b_2_0))
			result.Add(OffsetPoint(a + c, b_2_0))

		Case "8_3"
			result.Add(OffsetPoint(-hm - r_2_0, -vm - r_2_0))
			result.Add(OffsetPoint(0, -vm - r_2_0))
			result.Add(OffsetPoint(hm + r_2_0, -vm - r_2_0))
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))
			result.Add(OffsetPoint(-hm - r_2_0, vm + r_2_0))
			result.Add(OffsetPoint(0, vm + r_2_0))
			result.Add(OffsetPoint(hm + r_2_0, vm + r_2_0))

		Case "8_4"
			result.Add(OffsetPoint(0, -a_2_0 - c_2_0))
			result.Add(OffsetPoint(-hm_0_5 - r, -a - c))
			result.Add(OffsetPoint(hm_0_5 + r, -a - c))
			result.Add(OffsetPoint(-b_2_0, 0))
			result.Add(OffsetPoint(b_2_0, 0))
			result.Add(OffsetPoint(-hm_0_5 - r, a + c))
			result.Add(OffsetPoint(hm_0_5 + r, a + c))
			result.Add(OffsetPoint(0, a_2_0 + c_2_0))

		Case "8_5"
			result.Add(OffsetPoint(0, -a_2_0))
			result.Add(OffsetPoint(-a, -a))
			result.Add(OffsetPoint(a, -a))
			result.Add(OffsetPoint(-a_2_0, 0))
			result.Add(OffsetPoint(a_2_0, 0))
			result.Add(OffsetPoint(-a, a))
			result.Add(OffsetPoint(a, a))
			result.Add(OffsetPoint(0, a_2_0))

		Case "8_6"
			result.Add(OffsetPoint(-hm_1_5 - r_3_0, -vm_0_5 - r))
			result.Add(OffsetPoint(-hm_0_5 - r, -vm_0_5 - r))
			result.Add(OffsetPoint(hm_0_5 + r, -vm_0_5 - r))
			result.Add(OffsetPoint(hm_1_5 + r_3_0, -vm_0_5 - r))
			result.Add(OffsetPoint(-hm_1_5 - r_3_0, vm_0_5 + r))
			result.Add(OffsetPoint(-hm_0_5 - r, vm_0_5 + r))
			result.Add(OffsetPoint(hm_0_5 + r, vm_0_5 + r))
			result.Add(OffsetPoint(hm_1_5 + r_3_0, vm_0_5 + r))

		Case "8_7"
			result.Add(OffsetPoint(-hm_0_5 - r, -vm_1_5 - r_3_0))
			result.Add(OffsetPoint(hm_0_5 + r, -vm_1_5 - r_3_0))
			result.Add(OffsetPoint(-hm_0_5 - r, -vm_0_5 - r))
			result.Add(OffsetPoint(hm_0_5 + r, -vm_0_5 - r))
			result.Add(OffsetPoint(-hm_0_5 - r, vm_0_5 + r))
			result.Add(OffsetPoint(hm_0_5 + r, vm_0_5 + r))
			result.Add(OffsetPoint(-hm_0_5 - r, vm_1_5 + r_3_0))
			result.Add(OffsetPoint(hm_0_5 + r, vm_1_5 + r_3_0))

		Case "9_1"
			result.Add(OffsetPoint(-hm - r_2_0, -vm - r_2_0))
			result.Add(OffsetPoint(0, -vm - r_2_0))
			result.Add(OffsetPoint(hm + r_2_0, -vm - r_2_0))
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))
			result.Add(OffsetPoint(-hm - r_2_0, vm + r_2_0))
			result.Add(OffsetPoint(0, vm + r_2_0))
			result.Add(OffsetPoint(hm + r_2_0, vm + r_2_0))

		Case "9_2"
			result.Add(OffsetPoint(0, -a_2_0 - c_2_0))
			result.Add(OffsetPoint(-hm_0_5 - r, -a - c))
			result.Add(OffsetPoint(hm_0_5 + r, -a - c))
			result.Add(OffsetPoint(-b_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(b_2_0, 0))
			result.Add(OffsetPoint(-hm_0_5 - r, a + c))
			result.Add(OffsetPoint(hm_0_5 + r, a + c))
			result.Add(OffsetPoint(0, a_2_0 + c_2_0))

Case "9_3"
            result.Add(OffsetPoint(0, -a_2_0))
            result.Add(OffsetPoint(-a, -a))
            result.Add(OffsetPoint(a, -a))
            result.Add(OffsetPoint(-a_2_0, 0))
            result.Add(OffsetPoint(0, 0))
            result.Add(OffsetPoint(a_2_0, 0))
            result.Add(OffsetPoint(-a, a))
            result.Add(OffsetPoint(a, a))
            result.Add(OffsetPoint(0, a_2_0))

Case "HORIZONTAL"
             AddHorizontalSpacedOffsets(result, r, r_2_0, hm, MaxCount)

Case "VERTICAL"
             AddVerticalSpacedOffsets(result, r, r_2_0, vm, MaxCount)

        Case "SHARE"
            ' SHARE button place: triangular 3-button layout (similar to piece share)
            ' Uses shareLineLength for spread, creates equilateral triangle pointing up
            If MaxCount >= 1 Then result.Add(OffsetPoint(0, -im))  ' top
            If MaxCount >= 2 Then result.Add(OffsetPoint(-im * Sqrt(3) / 2, im / 2))  ' bottom-left
            If MaxCount >= 3 Then result.Add(OffsetPoint(im * Sqrt(3) / 2, im / 2))  ' bottom-right

        Case "CUSTOM"
            ' CUSTOM: positions provided externally via CustomButtonPositions
            ' Handled by caller; return empty to signal custom layout
            ' (The caller will populate from custom positions list)
            ' Nothing to do here - returns empty list

        Case "SHARE"
            ' SHARE piece place: triangular 3-dot layout (original getShareDotPositions)
            ' Uses shareLineLength for spread, creates equilateral triangle pointing up
            ' This is only used for pieces (dots), not buttons
            If MaxCount >= 1 Then result.Add(OffsetPoint(0, -im))  ' top
            If MaxCount >= 2 Then result.Add(OffsetPoint(-im * Sqrt(3) / 2, im / 2))  ' bottom-left
            If MaxCount >= 3 Then result.Add(OffsetPoint(im * Sqrt(3) / 2, im / 2))  ' bottom-right

        Case "CUSTOM"
            ' CUSTOM: positions provided externally via CustomPiecePositions/CustomButtonPositions
            ' Handled by caller; return empty to signal custom layout
            ' (The caller will populate from custom positions list)
            ' Fall through to default (returns empty)
            ' Nothing to do here - custom positions handled in B4XDaisyBoomMenu

		Case Else
			' Fallback: SC_3_1 row.
			result.Add(OffsetPoint(-hm - r_2_0, 0))
			result.Add(OffsetPoint(0, 0))
			result.Add(OffsetPoint(hm + r_2_0, 0))
	End Select

	' Slice to the requested count (our port allows flexible button counts; the original
	' requires the count to match the place enum exactly).
	Dim sliced As List
	sliced.Initialize
	For i = 0 To Min(MaxCount, result.Size) - 1
		sliced.Add(result.Get(i))
	Next
	Return sliced
End Sub

' Horizontal layout (radius overload). Symmetric around origin for odd counts.
Private Sub AddHorizontalOffsets(Result As List, R As Float, R_2_0 As Float, Hm As Float, Count As Int)
	Dim half As Int = Count / 2
	If Count Mod 2 = 0 Then
		For i = half - 1 To 0 Step -1
			Result.Add(OffsetPoint(-R - Hm / 2 - i * (R_2_0 + Hm), 0))
		Next
		For i = 0 To half - 1
			Result.Add(OffsetPoint(R + Hm / 2 + i * (R_2_0 + Hm), 0))
		Next
	Else
		For i = half - 1 To 0 Step -1
			Result.Add(OffsetPoint(-R_2_0 - Hm - i * (R_2_0 + Hm), 0))
		Next
		Result.Add(OffsetPoint(0, 0))
		For i = 0 To half - 1
			Result.Add(OffsetPoint(R_2_0 + Hm + i * (R_2_0 + Hm), 0))
		Next
	End If
End Sub

' Vertical layout (radius overload). Symmetric around origin for odd counts.
Private Sub AddVerticalOffsets(Result As List, R As Float, R_2_0 As Float, Vm As Float, Count As Int)
	Dim half As Int = Count / 2
	If Count Mod 2 = 0 Then
		For i = half - 1 To 0 Step -1
			Result.Add(OffsetPoint(0, -R - Vm / 2 - i * (R_2_0 + Vm)))
		Next
		For i = 0 To half - 1
			Result.Add(OffsetPoint(0, R + Vm / 2 + i * (R_2_0 + Vm)))
		Next
	Else
		For i = half - 1 To 0 Step -1
			Result.Add(OffsetPoint(0, -R_2_0 - Vm - i * (R_2_0 + Vm)))
		Next
		Result.Add(OffsetPoint(0, 0))
		For i = 0 To half - 1
			Result.Add(OffsetPoint(0, R_2_0 + Vm + i * (R_2_0 + Vm)))
		Next
	End If
End Sub

' Mirror of the original adjust(ps, parentSize, halfWidth, halfHeight, bmb).
' halfWidth = halfHeight = radius for circle buttons. EdgeMargin stands in for the
' original's top/bottom/left/right margins (all default to 30dp).
Private Sub ApplyAlignment(Offsets As List, ParentWidth As Float, ParentHeight As Float, _
		HalfSize As Float, EdgeMargin As Int, Alignment As String)
	If Offsets.Size = 0 Then Return
	Dim align As String = Alignment.ToUpperCase
	If align = "CENTER" Then Return

	Dim minX As Float = Offsets.Get(0).As(Map).Get("x")
	Dim maxX As Float = minX
	Dim minY As Float = Offsets.Get(0).As(Map).Get("y")
	Dim maxY As Float = minY
	For Each p As Map In Offsets
		Dim px As Float = p.Get("x")
		Dim py As Float = p.Get("y")
		If px < minX Then minX = px
		If px > maxX Then maxX = px
		If py < minY Then minY = py
		If py > maxY Then maxY = py
	Next

	Dim xOffset As Float = 0
	Dim yOffset As Float = 0
	Select Case align
		Case "TOP"
			yOffset = HalfSize + EdgeMargin - minY
		Case "BOTTOM"
			yOffset = ParentHeight - HalfSize - maxY - EdgeMargin
		Case "LEFT"
			xOffset = HalfSize + EdgeMargin - minX
		Case "RIGHT"
			xOffset = ParentWidth - HalfSize - maxX - EdgeMargin
		Case "TL"
			yOffset = HalfSize + EdgeMargin - minY
			xOffset = HalfSize + EdgeMargin - minX
		Case "TR"
			yOffset = HalfSize + EdgeMargin - minY
			xOffset = ParentWidth - HalfSize - maxX - EdgeMargin
		Case "BL"
			yOffset = ParentHeight - HalfSize - maxY - EdgeMargin
			xOffset = HalfSize + EdgeMargin - minX
		Case "BR"
			yOffset = ParentHeight - HalfSize - maxY - EdgeMargin
			xOffset = ParentWidth - HalfSize - maxX - EdgeMargin
	End Select

	ShiftBy(Offsets, xOffset, yOffset)
End Sub

Private Sub ShiftBy(Offsets As List, DX As Float, DY As Float)
	For Each p As Map In Offsets
		p.Put("x", p.Get("x") + DX)
		p.Put("y", p.Get("y") + DY)
	Next
End Sub

Private Sub ToTopLeftRects(Offsets As List, Radius As Float, Size As Int) As List
	Dim rects As List
	rects.Initialize
	For Each p As Map In Offsets
		Dim m As Map = CreateMap("x": Round(p.Get("x") - Radius), "y": Round(p.Get("y") - Radius), _
			"width": Size, "height": Size)
		rects.Add(m)
	Next
	Return rects
End Sub

' Rectangle variant: x/y top-left from separate half-width / half-height, w×h size.
Private Sub ToTopLeftRectsRect(Offsets As List, HalfW As Float, HalfH As Float, W As Int, H As Int) As List
	Dim rects As List
	rects.Initialize
	For Each p As Map In Offsets
		Dim m As Map = CreateMap("x": Round(p.Get("x") - HalfW), "y": Round(p.Get("y") - HalfH), _
			"width": W, "height": H)
		rects.Add(m)
	Next
	Return rects
End Sub

' Rectangle alignment (separate half-width / half-height). Same anchoring as ApplyAlignment
' but x offsets use HalfW and y offsets use HalfH (rectangle buttons are not square).
Private Sub ApplyAlignmentRect(Offsets As List, ParentWidth As Float, ParentHeight As Float, _
		HalfW As Float, HalfH As Float, EdgeMargin As Int, Alignment As String)
	If Offsets.Size = 0 Then Return
	Dim align As String = Alignment.ToUpperCase
	If align = "CENTER" Then Return

	Dim minX As Float = Offsets.Get(0).As(Map).Get("x")
	Dim maxX As Float = minX
	Dim minY As Float = Offsets.Get(0).As(Map).Get("y")
	Dim maxY As Float = minY
	For Each p As Map In Offsets
		Dim px As Float = p.Get("x")
		Dim py As Float = p.Get("y")
		If px < minX Then minX = px
		If px > maxX Then maxX = px
		If py < minY Then minY = py
		If py > maxY Then maxY = py
	Next

	Dim xOffset As Float = 0
	Dim yOffset As Float = 0
	Select Case align
		Case "TOP"
			yOffset = HalfH + EdgeMargin - minY
		Case "BOTTOM"
			yOffset = ParentHeight - HalfH - maxY - EdgeMargin
		Case "LEFT"
			xOffset = HalfW + EdgeMargin - minX
		Case "RIGHT"
			xOffset = ParentWidth - HalfW - maxX - EdgeMargin
		Case "TL"
			yOffset = HalfH + EdgeMargin - minY
			xOffset = HalfW + EdgeMargin - minX
		Case "TR"
			yOffset = HalfH + EdgeMargin - minY
			xOffset = ParentWidth - HalfW - maxX - EdgeMargin
		Case "BL"
			yOffset = ParentHeight - HalfH - maxY - EdgeMargin
			xOffset = HalfW + EdgeMargin - minX
		Case "BR"
			yOffset = ParentHeight - HalfH - maxY - EdgeMargin
			xOffset = ParentWidth - HalfW - maxX - EdgeMargin
	End Select

	ShiftBy(Offsets, xOffset, yOffset)
End Sub

Private Sub OffsetPoint(X As Float, Y As Float) As Map
    Return CreateMap("x": X, "y": Y)
End Sub

' Adds horizontal offsets: (-n*spacing, 0), ..., (0,0), ..., (n*spacing, 0)
Private Sub AddHorizontalSpacedOffsets(Offsets As List, Radius As Float, Spacing As Float, HMargin As Int, MaxCount As Int)
	Offsets.Clear
	If MaxCount <= 0 Then Return
	
	Dim half As Int = Floor(MaxCount / 2)
	Dim offset As Float
	
For i = 0 To MaxCount - 1
		offset = (i - half) * Spacing
		Offsets.Add(OffsetPoint(offset, 0))
	Next
End Sub

' Adds vertical offsets: (0, -n*spacing), ..., (0,0), ..., (0, n*spacing)
Private Sub AddVerticalSpacedOffsets(Offsets As List, Radius As Float, Spacing As Float, VMargin As Int, MaxCount As Int)
    Offsets.Clear
    If MaxCount <= 0 Then Return
    
    Dim half As Int = Floor(MaxCount / 2)
    Dim offset As Float
    
    For i = 0 To MaxCount - 1
        offset = (i - half) * Spacing
        Offsets.Add(OffsetPoint(0, offset))
Next
End Sub