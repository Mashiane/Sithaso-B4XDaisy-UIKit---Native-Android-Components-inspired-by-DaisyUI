B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12
' YogaContainer - Class Module
' Top-level layout manager for a B4XPages screen
'
' Responsibilities:
'   1. Factory methods — create YogaViews (paired YogaNode + B4XView)
'   2. Tree management — the root YogaView
'   3. Layout calculation — runs Yoga, walks tree, applies positions
'   4. Resize handling — re-runs layout when screen size changes
'
' Usage:
'   Dim fc As YogaContainer
'   fc.Initialize(Root, Me)
'
'   Dim header As YogaView = fc.CreatePanel("header", headerStyle)
'   Dim title As YogaView = fc.CreateLabel("title", "Hello", titleStyle)
'   fc.Root.AddChild(header)
'   header.AddChild(title)
'
'   fc.CalculateAndApply

Sub Class_Globals
	' The root YogaView (wraps the B4XPage's Root panel)
	Public Root As YogaView
	
	' Reference to the B4XPage (for event callbacks)
	Private mCallback As Object				'ignore
	
	' All created YogaViews (flat list for easy access)
	Private mAllViews As List
	
	' Track root dimensions
	Private mRootWidth As Float
	Private mRootHeight As Float
	Private mYogaConfig As Object
	
	' XUI reference
	Private xui As XUI
	
	' Auto-measure text views before layout
	Public AutoMeasureText As Boolean = True
End Sub

' ============================================================
' INITIALIZATION
' ============================================================

' Initialize the YogaContainer with the B4XPage's Root view
' callback: the B4XPage (Me) — for event callbacks
'Public Sub Initialize(rootPanel As B4XView, callback As Object) As YogaContainer
'	Return Initialize2(rootPanel, callback, False)
'End Sub

' Initialize with a YogaConfig that can opt into web defaults.
Public Sub Initialize(rootPanel As B4XView, callback As Object, useWebDefaults As Boolean) As YogaContainer
	mCallback = callback
	mAllViews.Initialize
	mYogaConfig = CreateYogaConfig(useWebDefaults)
	
	' Store root dimensions
	mRootWidth = rootPanel.Width
	mRootHeight = rootPanel.Height
	
	' Create root YogaView
	Root.Initialize(rootPanel, "root", "panel", mYogaConfig)
	Root.Node.SetWidth(mRootWidth)
	Root.Node.SetHeight(mRootHeight)
	
	mAllViews.Add(Root)
	Return Me
End Sub

'' Initialize with a style for the root
'Public Sub Initialize2(rootPanel As B4XView, callback As Object, rootStyle As Map)
'	Initialize(rootPanel, callback)
'	
'	If rootStyle.IsInitialized And rootStyle.Size > 0 Then
'		Root.SetStyle(rootStyle)
'	End If
'End Sub

Sub SetStyle(rootStyle As Map)
	Root.SetStyle(rootStyle)
End Sub

' ============================================================
' FACTORY METHODS — Create YogaViews
' Each creates a B4XView + YogaNode pair
' ============================================================

' Create a Panel (container) YogaView
Public Sub CreatePanel(tag As String, style As Map) As YogaView
	Dim pnl As Panel
	pnl.Initialize(tag & "_pnl")
	
	Dim fv As YogaView
	fv.Initialize(pnl, tag, "panel", mYogaConfig)
	
	If style.IsInitialized And style.Size > 0 Then
		fv.SetStyle(style)
	End If
	
	mAllViews.Add(fv)
	Return fv
End Sub

' Create a Label YogaView
Public Sub CreateLabel(tag As String, text As String, style As Map) As YogaView
	Dim lbl As Label
	lbl.Initialize(tag & "_lbl")
	lbl.Text = text
	
	Dim fv As YogaView
	fv.Initialize(lbl, tag, "label", mYogaConfig)
	
	If style.IsInitialized And style.Size > 0 Then
		fv.SetStyle(style)
	End If
	
	mAllViews.Add(fv)
	Return fv
End Sub

' Create a Button YogaView
Public Sub CreateButton(tag As String, text As String, style As Map) As YogaView
	Dim btn As Button
	btn.Initialize(tag & "_btn")
	btn.Text = text
	
	Dim fv As YogaView
	fv.Initialize(btn, tag, "button", mYogaConfig)
	
	' Buttons have a default height if not specified
	If style.IsInitialized = False Or style.ContainsKey("height") = False Then
		fv.Node.SetHeight(48)
	End If
	
	If style.IsInitialized And style.Size > 0 Then
		fv.SetStyle(style)
	End If
	
	mAllViews.Add(fv)
	Return fv
End Sub

' Create a TextField (EditText) YogaView
Public Sub CreateTextField(tag As String, hint As String, style As Map) As YogaView
	Dim edt As EditText
	edt.Initialize(tag & "_edt")
	edt.Hint = hint
	edt.SingleLine = True
	
	Dim fv As YogaView
	fv.Initialize(edt, tag, "textfield", mYogaConfig)
	
	' TextFields have a default height if not specified
	If style.IsInitialized = False Or style.ContainsKey("height") = False Then
		fv.Node.SetHeight(48)
	End If
	
	If style.IsInitialized And style.Size > 0 Then
		fv.SetStyle(style)
	End If
	
	mAllViews.Add(fv)
	Return fv
End Sub

' Create an ImageView YogaView
Public Sub CreateImageView(tag As String, style As Map) As YogaView
	Dim iv As ImageView
	iv.Initialize(tag & "_iv")
	
	Dim fv As YogaView
	fv.Initialize(iv, tag, "imageview", mYogaConfig)
	
	If style.IsInitialized And style.Size > 0 Then
		fv.SetStyle(style)
	End If
	
	mAllViews.Add(fv)
	Return fv
End Sub

' Create a YogaView from an existing B4XView
' Use this for custom views, B4XViews loaded from layout, etc.
Public Sub CreateFromView(tag As String, existingView As B4XView, viewType As String, style As Map) As YogaView
	Dim fv As YogaView
	fv.Initialize(existingView, tag, viewType, mYogaConfig)
	
	If style.IsInitialized And style.Size > 0 Then
		fv.SetStyle(style)
	End If
	
	mAllViews.Add(fv)
	Return fv
End Sub

' Create a Spacer (invisible flex item)
' Like React Native's <View style={{flex: 1}} />
Public Sub CreateSpacer(tag As String, flexGrow As Float) As YogaView
	Dim pnl As Panel
	pnl.Initialize(tag & "_spacer")	
	
	Dim fv As YogaView
	fv.Initialize(pnl, tag, "panel", mYogaConfig)
	fv.Node.SetFlexGrow(flexGrow)
	
	mAllViews.Add(fv)
	Return fv
End Sub

Private Sub CreateYogaConfig(useWebDefaults As Boolean) As Object
	If useWebDefaults = False Then Return Null
	
	Dim factory As JavaObject
	factory.InitializeStatic("com.facebook.yoga.YogaConfigFactory")
	Dim config As JavaObject = factory.RunMethod("create", Null)
	config.RunMethod("setUseWebDefaults", Array(True))
	Return config
End Sub

' ============================================================
' SCROLLABLE CONTAINER
' Creates a ScrollView with an inner flex panel
' Returns the inner YogaView (add children to this)
' ============================================================
'Public Sub CreateScrollView(tag As String, style As Map) As YogaView
'	Dim sv As ScrollView
'	sv.Initialize(0, tag & "_sv")
'	
'	' The ScrollView itself gets a YogaView for sizing
'	Dim svFv As YogaView
'	svFv.Initialize(sv, tag, "scrollview")
'	
'	If style.IsInitialized And style.Size > 0 Then
'		svFv.SetStyle(style)
'	End If
'	
'	mAllViews.Add(svFv)
'	
'	' The inner panel is what children get added to
'	' It will be sized by Yoga (height = content height)
'	Dim innerFv As YogaView
'	innerFv.Initialize(sv.Panel, tag & "_inner", "panel")
'	innerFv.Node.SetWidthPercent(100)
'	' Height will be determined by content (auto)
'	
'	mAllViews.Add(innerFv)
'	
'	Return svFv
'End Sub

' ============================================================
' LAYOUT CALCULATION & APPLICATION
' ============================================================

' Calculate Yoga layout and apply positions to all B4XViews
Public Sub CalculateAndApply
	' Step 1: Pre-measure text views (if enabled)
	If AutoMeasureText Then
		PreMeasureAll(Root)
	End If
	
	' Step 2: Run Yoga layout calculation
	Root.Node.CalculateLayout(mRootWidth, mRootHeight)
	
	' Step 3: Walk tree and apply computed positions
	ApplyLayoutRecursive(Root)
End Sub

' Calculate and apply with animation
Public Sub CalculateAndApplyAnimated(duration As Int)
	If AutoMeasureText Then
		PreMeasureAll(Root)
	End If
	
	Root.Node.CalculateLayout(mRootWidth, mRootHeight)
	ApplyLayoutAnimatedRecursive(Root, duration)
End Sub

' Recursive layout application
Private Sub ApplyLayoutRecursive(fv As YogaView)
	' Skip root — it's the page's Root panel, already sized
	If fv.Tag <> "root" Then
		fv.ApplyOwnLayout(0)
	End If
	
	' Recurse into children
	Dim i As Int
	For i = 0 To fv.Children.Size - 1
		Dim child As YogaView = fv.Children.Get(i)
		ApplyLayoutRecursive(child)
	Next
End Sub

' Recursive animated layout application
Private Sub ApplyLayoutAnimatedRecursive(fv As YogaView, duration As Int)
	If fv.Tag <> "root" Then
		fv.ApplyOwnLayout(duration)
	End If
	
	Dim i As Int
	For i = 0 To fv.Children.Size - 1
		Dim child As YogaView = fv.Children.Get(i)
		ApplyLayoutAnimatedRecursive(child, duration)
	Next
End Sub

' Pre-measure all text-based views
Private Sub PreMeasureAll(fv As YogaView)
	If fv.ViewType = "label" Or fv.ViewType = "button" Then
		fv.PreMeasure(mRootWidth, -1)
	End If
	
	Dim i As Int
	For i = 0 To fv.Children.Size - 1
		Dim child As YogaView = fv.Children.Get(i)
		PreMeasureAll(child)
	Next
End Sub

' ============================================================
' RESIZE HANDLING
' Call this from B4XPage_Resize
' ============================================================
Public Sub Resize(width As Float, height As Float)
	mRootWidth = width
	mRootHeight = height
	
	' Update root Yoga node dimensions
	Root.Node.SetWidth(width)
	Root.Node.SetHeight(height)
	
	' Recalculate and apply
	CalculateAndApply
End Sub

' Resize with animation
Public Sub ResizeAnimated(width As Float, height As Float, duration As Int)
	mRootWidth = width
	mRootHeight = height
	
	Root.Node.SetWidth(width)
	Root.Node.SetHeight(height)
	
	CalculateAndApplyAnimated(duration)
End Sub

' ============================================================
' UTILITY
' ============================================================

' Find a YogaView by tag anywhere in the tree
Public Sub FindByTag(tag As String) As YogaView
	Return Root.FindByTag(tag)
End Sub

' Get all created YogaViews
Public Sub GetAllViews As List
	Return mAllViews
End Sub

' Debug: Print entire layout tree
Public Sub DebugTree
	Log("=== YogaContainer Layout Tree ===")
	Log("Root: " & mRootWidth & " x " & mRootHeight)
	Root.DebugLayout
	Log("=================================")
End Sub

' ============================================================
' CONVENIENCE: Quick row/column builders
' ============================================================

' Create a horizontal row container
Public Sub CreateRow(tag As String, extraStyle As Map) As YogaView
	Dim baseStyle As Map = CreateMap( _
		"flexDirection": "row", _
		"alignItems": "center")
	
	Dim style As Map
	If extraStyle.IsInitialized And extraStyle.Size > 0 Then
		style = YogaStyle.Compose(baseStyle, extraStyle)
	Else
		style = baseStyle
	End If
	
	Return CreatePanel(tag, style)
End Sub

' Create a vertical column container
Public Sub CreateColumn(tag As String, extraStyle As Map) As YogaView
	Dim baseStyle As Map = CreateMap( _
		"flexDirection": "column")
	
	Dim style As Map
	If extraStyle.IsInitialized And extraStyle.Size > 0 Then
		style = YogaStyle.Compose(baseStyle, extraStyle)
	Else
		style = baseStyle
	End If
	
	Return CreatePanel(tag, style)
End Sub

' Create a centered container (both axes)
Public Sub CreateCenter(tag As String, extraStyle As Map) As YogaView
	Dim baseStyle As Map = CreateMap( _
		"flexDirection": "column", _
		"justifyContent": "center", _
		"alignItems": "center")
	
	Dim style As Map
	If extraStyle.IsInitialized And extraStyle.Size > 0 Then
		style = YogaStyle.Compose(baseStyle, extraStyle)
	Else
		style = baseStyle
	End If
	
	Return CreatePanel(tag, style)
End Sub

