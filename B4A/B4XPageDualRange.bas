B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI

	' Page Frame & Navigation (Official B4XDaisyUIKit template)
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost    As B4XView
	Private navbar     As B4XDaisyNavbar

	' Coordinate Accumulator & Layout Metrics
	Private pad        As Int
	Private gap        As Int
	Private maxW       As Int
	Private y          As Int
	Private NAVBAR_H   As Int = 56dip

	' Live feedback readout component (Pure B4XDaisyText)
	Private txtFeedback As B4XDaisyText
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the demo page class.
''' </summary>
Public Sub Initialize As Object
	Return Me
End Sub

''' <summary>
''' B4XPage Created event. Assembles layout skeleton (Navbar + PageScroll).
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews

	BuildScroll
	BuildNavbar
	RenderContent
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height - NAVBAR_H)
		RenderContent
	End If
End Sub

Private Sub BuildScroll
	Dim scrollTop As Int = NAVBAR_H
	Dim scrollH   As Int = Root.Height - NAVBAR_H
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, scrollTop, Root.Width, scrollH)
	pageScroll.SendToBack
	pnlHost = pageScroll.Panel
End Sub

Private Sub BuildNavbar
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
	navbar.BringToFront
	navbar.Title = "Dual Range"
	navbar.Variant = "primary"
	navbar.BackVisible = True
	navbar.BackLabel = ""
End Sub
#End Region

#Region Rendering
''' <summary>
''' Composes all dual-range slider examples sequentially using the vertical coordinate accumulator.
''' </summary>
Private Sub RenderContent
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	''' Example 1: Basic Dual Range Slider
	''' Standard dual handle range with default styling and live readout.
	y = pageScroll.AddSectionTitle("Basic Dual Range Slider", y, False) + gap
	Dim dr1 As B4XDaisyDualRange
	dr1.Initialize(Me, "drBasic")
	dr1.AddToParent(pnlHost, pad, y, maxW, 24dip)
	dr1.MinValue = 0
	dr1.MaxValue = 100
	dr1.LowerValue = 20
	dr1.UpperValue = 80
	dr1.LabelAbove = "Selected Range"
	dr1.LabelVisible = True
	dr1.ShowValue = True
	dr1.Tag = "basic-dual-range"
	y = y + dr1.ComputedHeight + gap

	''' Example 2: Price Filter (Prefix $, Step = 25, Min Dist = 50)
	''' Currency formatting, step snapping, and minimum separation constraint.
	y = pageScroll.AddSectionTitle("Price Filter (Step = $25, Min Dist = $50)", y, False) + gap
	Dim drPrice As B4XDaisyDualRange
	drPrice.Initialize(Me, "drPrice")
	drPrice.AddToParent(pnlHost, pad, y, maxW, 24dip)
	drPrice.MinValue = 0
	drPrice.MaxValue = 1000
	drPrice.LowerValue = 150
	drPrice.UpperValue = 650
	drPrice.StepValue = 25
	drPrice.MinDistance = 50
	drPrice.ValuePrefix = "$"
	drPrice.Variant = "primary"
	drPrice.LabelAbove = "Budget Range"
	drPrice.LabelVisible = True
	drPrice.ShowValue = True
	drPrice.HintText = "Drag either thumb to adjust price boundaries."
	drPrice.Tag = "price-dual-range"
	y = y + drPrice.ComputedHeight + gap

	''' Example 3: Dual Tooltips (Transient on Drag)
	''' Shows floating value bubbles above each handle while dragging.
	y = pageScroll.AddSectionTitle("Dual Tooltips (Fade In On Drag)", y, False) + gap
	Dim drTip As B4XDaisyDualRange
	drTip.Initialize(Me, "drTip")
	drTip.AddToParent(pnlHost, pad, y, maxW, 24dip)
	drTip.MinValue = 0
	drTip.MaxValue = 100
	drTip.LowerValue = 30
	drTip.UpperValue = 70
	drTip.Variant = "accent"
	drTip.ShowTooltip = True
	drTip.TooltipPosition = "top"
	drTip.LabelAbove = "Temperature Range (deg C)"
	drTip.LabelVisible = True
	drTip.ValueSuffix = " deg C"
	drTip.ShowValue = True
	drTip.Tag = "tooltip-dual-range"
	y = y + drTip.ComputedHeight + gap

	''' Example 4: Permanent Tooltips (Always Open)
	y = pageScroll.AddSectionTitle("Permanent Tooltips (Always Open)", y, False) + gap
	Dim drTipOpen As B4XDaisyDualRange
	drTipOpen.Initialize(Me, "drTipOpen")
	drTipOpen.AddToParent(pnlHost, pad, y, maxW, 24dip)
	drTipOpen.MinValue = 10
	drTipOpen.MaxValue = 90
	drTipOpen.LowerValue = 25
	drTipOpen.UpperValue = 75
	drTipOpen.Variant = "secondary"
	drTipOpen.ShowTooltip = True
	drTipOpen.TooltipOpen = True
	drTipOpen.TooltipPosition = "top"
	drTipOpen.LabelAbove = "Sound Frequency Range"
	drTipOpen.LabelVisible = True
	drTipOpen.ValueSuffix = "Hz"
	drTipOpen.ShowValue = True
	drTipOpen.Tag = "tip-open-dual-range"
	y = y + drTipOpen.ComputedHeight + 20dip

	''' Example 5: Color Variants
	y = pageScroll.AddSectionTitle("Color Variants", y, False) + gap
	Dim variants() As String = Array As String("primary", "secondary", "accent", "success", "warning", "error", "info", "neutral")
	For Each varName As String In variants
		Dim drV As B4XDaisyDualRange
		drV.Initialize(Me, "drVar_" & varName)
		drV.AddToParent(pnlHost, pad, y, maxW, 24dip)
		drV.MinValue = 0
		drV.MaxValue = 100
		drV.LowerValue = 15
		drV.UpperValue = 85
		drV.Variant = varName
		drV.LabelAbove = varName.ToUpperCase & " Variant"
		drV.LabelVisible = True
		drV.ShowValue = True
		y = y + drV.ComputedHeight + 12dip
	Next

	''' Example 6: Sizing Scale
	y = pageScroll.AddSectionTitle("Sizing Scale (xs, sm, md, lg, xl)", y, False) + gap
	Dim sizes() As String = Array As String("xs", "sm", "md", "lg", "xl")
	For Each sz As String In sizes
		Dim drSz As B4XDaisyDualRange
		drSz.Initialize(Me, "drSize_" & sz)
		drSz.AddToParent(pnlHost, pad, y, maxW, 24dip)
	drSz.MinValue = 0
	drSz.MaxValue = 100
	drSz.LowerValue = 25
	drSz.UpperValue = 75
	drSz.Size = sz
	drSz.Variant = "primary"
	drSz.LabelAbove = "Size: " & sz.ToUpperCase
	drSz.LabelVisible = True
	drSz.ShowValue = True
	drSz.Tag = "size-" & sz
	drSz.Tag = "size-" & sz
	drSz.Tag = "size-" & sz
	y = y + drSz.ComputedHeight + 12dip
	Next

	''' Example 7: Live Event Feedback Readout
	y = pageScroll.AddSectionTitle("Interactive Event Callback Demo", y, False) + gap
	Dim drLive As B4XDaisyDualRange
	drLive.Initialize(Me, "drLive")
	drLive.AddToParent(pnlHost, pad, y, maxW, 24dip)
	drLive.MinValue = 0
	drLive.MaxValue = 500
	drLive.LowerValue = 100
	drLive.UpperValue = 400
	drLive.StepValue = 10
	drLive.Variant = "success"
	drLive.LabelAbove = "Live Dynamic Slider"
	drLive.LabelVisible = True
	drLive.ShowValue = True
	drLive.ValuePrefix = "k"
	drLive.ValueSuffix = " RPM"
	y = y + drLive.ComputedHeight + 8dip

	' Pure B4XDaisyText component for live event callback readout
	txtFeedback.Initialize(Me, "txtFeedback")
	txtFeedback.AddToParent(pnlHost, pad, y, maxW, 28dip)
	txtFeedback.Text = "Event Callback: Lower = 100 RPM, Upper = 400 RPM"
	txtFeedback.TextColor = xui.Color_RGB(16, 185, 129)
	txtFeedback.TextSize = 14
	txtFeedback.HAlign = "CENTER"
	y = y + 28dip + 36dip

	pageScroll.AutoFit
End Sub
#End Region

#Region Events
Private Sub navbar_Back (Tag As Object)
	B4XPages.ShowPage("dashboard")
End Sub

Private Sub drLive_Changed (LowerValue As Int, UpperValue As Int)
	If txtFeedback.IsInitialized Then
		txtFeedback.Text = "Event Callback: Lower = " & LowerValue & " RPM, Upper = " & UpperValue & " RPM"
	End If
End Sub
#End Region
