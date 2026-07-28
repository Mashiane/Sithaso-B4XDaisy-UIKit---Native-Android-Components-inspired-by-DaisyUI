B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=1.1
@EndOfDesignText@
#IgnoreWarnings:12,9

' PiecePlaceManager - Calculates positions for piece placeholders (the dots that preview
' where buttons will land).
'
' Faithful to the original com.nightonke.boommenu.Piece.PiecePlaceManager: pieces use the
' SAME center offsets as buttons (DOT_x offsets equal SC_x offsets) shifted by the overlay
' center, with NO alignment step. So with the default Center button alignment, pieces sit
' exactly where the buttons will land. Offset computation is delegated to ButtonPlaceManager
' to keep a single source of truth.

Sub Class_Globals
	Private buttonManager As ButtonPlaceManager
End Sub

Public Sub Initialize
	buttonManager.Initialize
End Sub

' Returns List of Map(x,y,width,height) as top-left rects, centered on the overlay (no alignment).
Public Sub CalculatePositions(PiecePlace As String, ParentWidth As Float, ParentHeight As Float, _
		PieceSize As Int, HMargin As Int, VMargin As Int, IMargin As Int, MaxCount As Int) As List
	Return buttonManager.CalculatePiecePositions(PiecePlace, ParentWidth, ParentHeight, _
		PieceSize, HMargin, VMargin, IMargin, MaxCount)
End Sub