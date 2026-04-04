B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' YogaView - Class Module
' The bridge between a YogaNode (layout) and a B4XView (rendering)
' Equivalent to React Native's shadow tree node
'
' Each YogaView holds:
'   - A YogaNode for Yoga layout calculations
'   - A B4XView for actual on-screen rendering
'   - Style state for dynamic updates
'   - Child YogaViews (mirrors Yoga + view hierarchy)

Sub Class_Globals
	' The Yoga layout node (shadow)
	Public Node As YogaNode
	
	' The actual B4XView on screen
	Public View As B4XView
	
	' Child YogaViews
	Public Children As List
	
	' Identity
	Public Tag As String
	Public ViewType As String  ' "panel", "label", "button", "textfield", "imageview", "custom"
	
	' Current style state (for re-applying or diffing)
	Private mCurrentStyle As Map
	
	' Visual style state (cached for SetColorAndBorder)
	Private mBgColor As Int = Colors.Transparent
	Private mBorderWidth As Float = 0
	Private mBorderColor As Int = Colors.Transparent
	Private mBorderRadius As Float = 0
	
	' Reference to parent container panel (needed for adding child views)
	Public ParentView As B4XView
	Public ParentFlex As YogaView
	
	' XUI reference
	Private xui As XUI
End Sub

' ============================================================
' INITIALIZATION
' ============================================================
'Public Sub Initialize(mView As B4XView, mTag As String, mViewType As String)
'	Initialize2(mView, mTag, mViewType, Null)
'End Sub

Public Sub Initialize(mView As B4XView, mTag As String, mViewType As String, yogaConfig As Object)
	View = mView
	Tag = mTag
	ViewType = mViewType.ToLowerCase
	Children.Initialize
	
	' Create paired YogaNode
	Node.Initialize(Tag, yogaConfig)
	
	' Initialize style state
	mCurrentStyle.Initialize
End Sub

' ============================================================
' SET STYLE — The core routing method
' Splits a Map into layout props → YogaNode, visual props → B4XView
'
' Usage:
'   fv.SetStyle(YogaStyle.Create( _
'       "flexDirection", "row", _
'       "padding", 16, _
'       "backgroundColor", "#1e293b", _
'       "fontSize", 18))
' ============================================================
Public Sub SetStyle(style As Map)
	If style.IsInitialized = False Then Return
	
	' Store the style for later reference
	Dim i As Int
	For i = 0 To style.Size - 1
		mCurrentStyle.Put(style.GetKeyAt(i), style.GetValueAt(i))
	Next
	
	' Route each property
	For i = 0 To style.Size - 1
		Dim key As String = style.GetKeyAt(i)
		Dim value As Object = style.GetValueAt(i)
		
		If YogaStyle.IsLayoutProperty(key) Then
			' Route to YogaNode
			Node.SetProperty(key, value)
			If key.ToLowerCase = "borderwidth" Or key.ToLowerCase = "overflow" Then
				' Some style keys affect both Yoga layout and the rendered host view.
				ApplyVisualProperty(key, value)
			End If
		Else
			' Route to B4XView (visual)
			ApplyVisualProperty(key, value)
		End If
	Next
	
	' Apply cached border/background (SetColorAndBorder needs all values at once)
	ApplyColorAndBorder
End Sub

' ============================================================
' UPDATE STYLE — Merge new style on top of existing
' Only changed properties are re-applied
' ============================================================
Public Sub UpdateStyle(updates As Map)
	If updates.IsInitialized = False Then Return
	
	Dim merged As Map = YogaStyle.Compose(mCurrentStyle, updates)
	SetStyle(merged)
End Sub

' ============================================================
' APPLY VISUAL PROPERTY — Routes a single visual prop to B4XView
' ============================================================
Private Sub ApplyVisualProperty(key As String, value As Object)
	Select key.ToLowerCase
		
		' --- Background ---
		Case "backgroundcolor"
			mBgColor = YogaStyle.ParseColor(value)
			' Don't apply yet — batched in ApplyColorAndBorder
		
		' --- Text Color ---
		Case "color"
			Try
				View.TextColor = YogaStyle.ParseColor(value)
			Catch
				' View might not support TextColor (e.g., Panel)
			End Try			''ignore
		
		' --- Font Size ---
		Case "fontsize"
			Try
				View.TextSize = value
			Catch
			End Try			''ignore
		
		' --- Font Weight ---
		Case "fontweight"
			Try
				Dim s As String = value
				If s.ToLowerCase = "bold" Or s = "700" Or s = "800" Or s = "900" Then
					SetBoldFont(True)
				Else
					SetBoldFont(False)
				End If
			Catch
			End Try				''ignore
		
		' --- Font Family ---
		Case "fontfamily"
'			Try
'				Dim fontName As String = value
'				Dim tf As Typeface = Typeface.CreateNew2(fontName, Typeface.STYLE_NORMAL)
'				View.Font = xui.CreateFont(tf, View.TextSize)
'				
'				'View.Font = xui.CreateFont2(xui.CreateDefaultFont(View.TextSize), fontName, View.TextSize)
'			Catch
'			End Try
		
		' --- Text Alignment ---
		Case "textalign"
			ApplyTextAlign(value)
		
		' --- Text Transform ---
		Case "texttransform"
			ApplyTextTransform(value)
		
		' --- Opacity ---
		Case "opacity"
			ApplyOpacity(value)
		
		' --- Overflow / clipping ---
		Case "overflow"
			ApplyOverflow(value)
		
		' --- Border Radius ---
		Case "borderradius"
			mBorderRadius = value
		
		' --- Border Color ---
		Case "bordercolor"
			mBorderColor = YogaStyle.ParseColor(value)
		
		' --- Border Width (uniform visual border) ---
		Case "borderwidth"
			mBorderWidth = value
		
		' --- Border Width (visual, not layout) ---
		' Note: "borderWidth" as visual goes here when also set for Yoga layout
		' The Yoga node gets the layout contribution; the view gets the visual
		
		' --- Elevation (Android shadow) ---
		Case "elevation"
			ApplyElevation(value)
		
		' --- Shadow properties (iOS-style) ---
		Case "shadowcolor"
			' Store for batched shadow application
			' Handled via platform-specific code
		Case "shadowoffset"
			' Map with "width" and "height" keys
		Case "shadowopacity"
			' Float 0-1
		Case "shadowradius"
			' Float
		
	End Select
End Sub

Private Sub ApplyOverflow(value As Object)
	#If B4A
	If ViewType <> "panel" And ViewType <> "scrollview" Then Return
	
	Dim overflowValue As String = value
	Dim clip As Boolean = overflowValue.ToLowerCase <> "visible"
	Dim jo As JavaObject = View
	jo.RunMethod("setClipChildren", Array(clip))
	jo.RunMethod("setClipToPadding", Array(clip))
	#End If
End Sub

' ============================================================
' APPLY COLOR AND BORDER — Batched application
' B4XView.SetColorAndBorder needs all values at once
' ============================================================
Private Sub ApplyColorAndBorder
	Try
		View.SetColorAndBorder(mBgColor, mBorderWidth, mBorderColor, mBorderRadius)
	Catch
		' Some views may not support this
		Try
			View.Color = mBgColor
		Catch
		End Try			'ignore
	End Try
End Sub

' ============================================================
' CHILD MANAGEMENT
' ============================================================

' Add a child YogaView to this node
' - Adds to Yoga tree (for layout calculation)
' - Adds B4XView to this view's panel (for rendering)
Public Sub AddChild(child As YogaView)
	' Add to Yoga tree
	Node.AddChild(child.Node)
	
	' Add to our children list
	Children.Add(child)
	child.ParentFlex = Me
	
	' Add the child's B4XView to our panel
	' Position at 0,0 with 0,0 size — Yoga will compute actual position
	If ViewType = "panel" Or ViewType = "scrollview" Then
		child.ParentView = ResolveVisualParent(child)
		Dim pnl As Panel = child.ParentView
		pnl.AddView(child.View, 0, 0, 0, 0)
	End If
End Sub

' Add child at specific index
Public Sub AddChildAt(child As YogaView, index As Int)
	Node.AddChildAt(child.Node, index)
	Children.InsertAt(index, child)
	child.ParentFlex = Me
	
	If ViewType = "panel" Or ViewType = "scrollview" Then
		child.ParentView = ResolveVisualParent(child)
		Dim pnl As Panel = child.ParentView
		pnl.AddView(child.View, 0, 0, 0, 0)
	End If
End Sub

' Remove a child
Public Sub RemoveChild(child As YogaView)
	Dim idx As Int = Children.IndexOf(child)
	If idx >= 0 Then
		Node.RemoveChild(child.Node)
		Children.RemoveAt(idx)
		child.ParentFlex = Null
		
		' Remove B4XView from parent panel
		child.View.RemoveViewFromParent
	End If
End Sub

' Remove all children
Public Sub RemoveAllChildren
	Dim i As Int
	For i = Children.Size - 1 To 0 Step -1
		Dim child As YogaView = Children.Get(i)
		Node.RemoveChildAt(i)
		child.ParentFlex = Null
		child.View.RemoveViewFromParent
	Next
	Children.Clear
End Sub

Private Sub ResolveVisualParent(child As YogaView) As B4XView
	Dim host As YogaView = Me
	Do While host.IsDisplayContents And host.ParentFlex.IsInitialized
		host = host.ParentFlex
	Loop
	If child.IsAbsolutePositioned Then
		Do While host.IsStaticPositioned And host.ParentFlex.IsInitialized
			host = host.ParentFlex
		Loop
	End If
	Return host.View
End Sub

Private Sub IsAbsolutePositioned As Boolean
	Return GetPositionType = "absolute"
End Sub

Private Sub IsStaticPositioned As Boolean
	Return GetPositionType = "static"
End Sub

Private Sub GetPositionType As String
	If mCurrentStyle.IsInitialized = False Then Return ""
	If mCurrentStyle.ContainsKey("position") = False Then Return ""
	Dim value As Object = mCurrentStyle.Get("position")
	If value = Null Then Return ""
	Return value.As(String).ToLowerCase
End Sub

Public Sub GetAppliedLayoutX As Float
	Dim x As Float = Node.GetLayoutX
	x = x + GetContentsOffsetX
	If NeedsStaticOffsetX Then x = x + GetReparentOffsetX
	Return x
End Sub

Public Sub GetAppliedLayoutY As Float
	Dim y As Float = Node.GetLayoutY
	y = y + GetContentsOffsetY
	If NeedsStaticOffsetY Then y = y + GetReparentOffsetY
	Return y
End Sub

Private Sub IsDisplayContents As Boolean
	Return GetDisplayType = "contents"
End Sub

Private Sub IsDisplayNone As Boolean
	Return GetDisplayType = "none"
End Sub

Private Sub GetDisplayType As String
	If mCurrentStyle.IsInitialized = False Then Return ""
	If mCurrentStyle.ContainsKey("display") = False Then Return ""
	Dim value As Object = mCurrentStyle.Get("display")
	If value = Null Then Return ""
	Return value.As(String).ToLowerCase
End Sub

Private Sub GetContentsOffsetX As Float
	If ParentFlex.IsInitialized = False Then Return 0
	If ParentView.IsInitialized = False Then Return 0
	If ParentFlex.View = ParentView Then Return 0
	Dim total As Float = 0
	Dim current As YogaView = ParentFlex
	Do While current.IsInitialized And current.View <> ParentView
		If current.IsDisplayContents Then total = total + current.Node.GetLayoutX
		current = current.ParentFlex
	Loop
	Return total
End Sub

Private Sub GetContentsOffsetY As Float
	If ParentFlex.IsInitialized = False Then Return 0
	If ParentView.IsInitialized = False Then Return 0
	If ParentFlex.View = ParentView Then Return 0
	Dim total As Float = 0
	Dim current As YogaView = ParentFlex
	Do While current.IsInitialized And current.View <> ParentView
		If current.IsDisplayContents Then total = total + current.Node.GetLayoutY
		current = current.ParentFlex
	Loop
	Return total
End Sub

Private Sub NeedsStaticOffsetX As Boolean
	If IsAbsolutePositioned = False Then Return False
	If ParentFlex.IsInitialized = False Then Return False
	If ParentView.IsInitialized = False Then Return False
	If ParentFlex.View = ParentView Then Return False
	If HasStyleKey("left") Or HasStyleKey("right") Or HasStyleKey("start") Or HasStyleKey("end") Then Return False
	Return True
End Sub

Private Sub NeedsStaticOffsetY As Boolean
	If IsAbsolutePositioned = False Then Return False
	If ParentFlex.IsInitialized = False Then Return False
	If ParentView.IsInitialized = False Then Return False
	If ParentFlex.View = ParentView Then Return False
	If HasStyleKey("top") Or HasStyleKey("bottom") Then Return False
	Return True
End Sub

Private Sub GetReparentOffsetX As Float
	Dim total As Float = 0
	Dim current As YogaView = ParentFlex
	Do While current.IsInitialized And current.View <> ParentView
		If current.IsStaticPositioned Then total = total + current.Node.GetLayoutX
		current = current.ParentFlex
	Loop
	Return total
End Sub

Private Sub GetReparentOffsetY As Float
	Dim total As Float = 0
	Dim current As YogaView = ParentFlex
	Do While current.IsInitialized And current.View <> ParentView
		If current.IsStaticPositioned Then total = total + current.Node.GetLayoutY
		current = current.ParentFlex
	Loop
	Return total
End Sub

Private Sub HasStyleKey(searchKey As String) As Boolean
	If mCurrentStyle.IsInitialized = False Then Return False
	Dim i As Int
	For i = 0 To mCurrentStyle.Size - 1
		Dim key As String = mCurrentStyle.GetKeyAt(i)
		If key.ToLowerCase = searchKey.ToLowerCase Then Return True
	Next
	Return False
End Sub

' ============================================================
' APPLY LAYOUT — Apply computed Yoga positions to B4XView
' Called recursively by YogaContainer after CalculateLayout
' ============================================================
Public Sub ApplyLayout
	ApplyOwnLayout(0)
	
	' Recursively apply to children
	Dim i As Int
	For i = 0 To Children.Size - 1
		Dim child As YogaView = Children.Get(i)
		child.ApplyLayout
	Next
End Sub

' Apply layout with animation
Public Sub ApplyLayoutAnimated(duration As Int)
	ApplyOwnLayout(duration)
	
	Dim i As Int
	For i = 0 To Children.Size - 1
		Dim child As YogaView = Children.Get(i)
		child.ApplyLayoutAnimated(duration)
	Next
End Sub

Public Sub ApplyOwnLayout(duration As Int)
	Dim x As Float = GetAppliedLayoutX
	Dim y As Float = GetAppliedLayoutY
	Dim w As Float = Node.GetLayoutWidth
	Dim h As Float = Node.GetLayoutHeight
	
	If IsDisplayContents Or IsDisplayNone Then
		View.Visible = False
		View.SetLayoutAnimated(duration, 0, 0, 0, 0)
	Else
		View.Visible = True
		View.SetLayoutAnimated(duration, x, y, w, h)
	End If
End Sub

' ============================================================
' PRE-MEASURE — For text-based views (Labels)
' Measures the view's intrinsic content size and sets
' it on the YogaNode so Yoga can account for it.
' Call this before CalculateLayout if view has text content.
' ============================================================
Public Sub PreMeasure(maxWidth As Float, maxHeight As Float)
	If ViewType = "label" Or ViewType = "button" Then
		#If B4A
		Dim jo As JavaObject = View
		' Create MeasureSpec
		Dim msClass As JavaObject
		msClass.InitializeStatic("android.view.View$MeasureSpec")
		
		Dim wSpec As Int
		Dim hSpec As Int
		Dim widthSize As Int = Max(0, Ceil(maxWidth))
		Dim heightSize As Int = Max(0, Ceil(maxHeight))
		Dim atMostMode As Int = msClass.GetField("AT_MOST")
		Dim unspecifiedMode As Int = msClass.GetField("UNSPECIFIED")
		
		If maxWidth > 0 Then
			wSpec = msClass.RunMethod("makeMeasureSpec", Array(widthSize, atMostMode))
		Else
			wSpec = msClass.RunMethod("makeMeasureSpec", Array(0, unspecifiedMode))
		End If
		
		If maxHeight > 0 Then
			hSpec = msClass.RunMethod("makeMeasureSpec", Array(heightSize, atMostMode))
		Else
			hSpec = msClass.RunMethod("makeMeasureSpec", Array(0, unspecifiedMode))
		End If
		
		jo.RunMethod("measure", Array(wSpec, hSpec))
		
		Dim measuredW As Int = jo.RunMethod("getMeasuredWidth", Null)
		Dim measuredH As Int = jo.RunMethod("getMeasuredHeight", Null)
		
		' Only set if the Yoga node doesn't already have explicit dimensions
		' (we don't want to override user-set width/height)
		' For now, set min dimensions so Yoga knows the minimum content size
		Node.SetMinWidth(measuredW)
		Node.SetMinHeight(measuredH)
		#End If
		
		#If B4J
		' B4J uses JavaFX — measure via prefWidth/prefHeight
		Dim jo As JavaObject = View
		Dim measuredW As Double = jo.RunMethod("prefWidth", Array(-1))
		Dim measuredH As Double = jo.RunMethod("prefHeight", Array(-1))
		Node.SetMinWidth(measuredW)
		Node.SetMinHeight(measuredH)
		#End If
	End If
End Sub

' ============================================================
' PLATFORM-SPECIFIC VISUAL HELPERS
' ============================================================

' Set bold font
Private Sub SetBoldFont(bold As Boolean)
	#If B4A
	Dim jo As JavaObject = View
	If bold Then
		Dim tf As JavaObject
		tf.InitializeStatic("android.graphics.Typeface")
		jo.RunMethod("setTypeface", Array(tf.GetField("DEFAULT_BOLD")))
	Else
		Dim tf As JavaObject
		tf.InitializeStatic("android.graphics.Typeface")
		jo.RunMethod("setTypeface", Array(tf.GetField("DEFAULT")))
	End If
	#End If
	#If B4J
	If bold Then
		View.Font = xui.CreateFontAwesome(View.TextSize)
		' Actually use CreateFont with bold style
		Dim jo As JavaObject = View
		Dim font As JavaObject
		font.InitializeNewInstance("javafx.scene.text.Font", Array("System Bold", View.TextSize))
		jo.RunMethod("setFont", Array(font))
	End If
	#End If
End Sub

' Apply text alignment
Private Sub ApplyTextAlign(value As Object)
	Dim align As String = value
	#If B4A
	Dim jo As JavaObject = View
	Select align.ToLowerCase
		Case "center"
			jo.RunMethod("setGravity", Array(17)) ' Gravity.CENTER
		Case "right"
			jo.RunMethod("setGravity", Array(5)) ' Gravity.RIGHT
		Case "left"
			jo.RunMethod("setGravity", Array(3)) ' Gravity.LEFT
	End Select
	#End If
	#If B4J
	Dim jo As JavaObject = View
	Select align.ToLowerCase
		Case "center"
			Dim pos As JavaObject
			pos.InitializeStatic("javafx.geometry.Pos")
			jo.RunMethod("setAlignment", Array(pos.GetField("CENTER")))
		Case "right"
			Dim pos As JavaObject
			pos.InitializeStatic("javafx.geometry.Pos")
			jo.RunMethod("setAlignment", Array(pos.GetField("CENTER_RIGHT")))
		Case "left"
			Dim pos As JavaObject
			pos.InitializeStatic("javafx.geometry.Pos")
			jo.RunMethod("setAlignment", Array(pos.GetField("CENTER_LEFT")))
	End Select
	#End If
End Sub

' Apply text transform (uppercase, lowercase, capitalize)
Private Sub ApplyTextTransform(value As Object)
	Dim transform As String = value
	Try
		Dim text As String = View.Text
		Select transform.ToLowerCase
			Case "uppercase"
				View.Text = text.ToUpperCase
			Case "lowercase"
				View.Text = text.ToLowerCase
			Case "capitalize"
				' Capitalize first letter of each word
				Dim words() As String = Regex.Split(" ", text)
				Dim result As StringBuilder
				result.Initialize
				Dim i As Int
				For i = 0 To words.Length - 1
					If words(i).Length > 0 Then
						If i > 0 Then result.Append(" ")
						'result.Append(words(i).CharAt(0).ToUpperCase)
						result.Append(words(i).SubString2(0,1).ToUpperCase)
						If words(i).Length > 1 Then
							result.Append(words(i).SubString(1))
						End If
					End If
				Next
				View.Text = result.ToString
		End Select
	Catch
		' View doesn't support Text
	End Try				'ignore
End Sub

' Apply opacity
Private Sub ApplyOpacity(value As Object)
	Dim alpha As Float = value
	#If B4A
	Dim jo As JavaObject = View
	jo.RunMethod("setAlpha", Array(alpha))
	#End If
	#If B4J
	Dim jo As JavaObject = View
	jo.RunMethod("setOpacity", Array(alpha))
	#End If
End Sub

' Apply elevation (Android shadow)
Private Sub ApplyElevation(value As Object)
	#If B4A
	Dim elevation As Float = value
	Dim jo As JavaObject = View
	jo.RunMethod("setElevation", Array(elevation))
	#End If
	' B4J doesn't have native elevation — could use DropShadow effect
	#If B4J
	Dim elevation As Float = value
	Dim shadow As JavaObject
	shadow.InitializeNewInstance("javafx.scene.effect.DropShadow", Null)
	shadow.RunMethod("setRadius", Array(elevation * 2))
	shadow.RunMethod("setOffsetY", Array(elevation))
	Dim jo As JavaObject = View
	jo.RunMethod("setEffect", Array(shadow))
	#End If
End Sub

' ============================================================
' UTILITY
' ============================================================

' Get the current applied style
Public Sub GetStyle As Map
	Return mCurrentStyle
End Sub

' Check if this YogaView has children
Public Sub HasChildren As Boolean
	Return Children.Size > 0
End Sub

' Find a child YogaView by tag (recursive)
Public Sub FindByTag(searchTag As String) As YogaView
	If Tag = searchTag Then Return Me
	
	Dim i As Int
	For i = 0 To Children.Size - 1
		Dim child As YogaView = Children.Get(i)
		Dim found As YogaView = child.FindByTag(searchTag)
		If found.IsInitialized Then Return found
	Next
	
	' Not found — return uninitialized
	Dim empty As YogaView
	Return empty
End Sub

' Set visibility (maps to both Yoga display and View visibility)
Public Sub SetVisible(visible As Boolean)
	View.Visible = visible
	If visible Then
		Node.SetDisplay("flex")
	Else
		Node.SetDisplay("none")
	End If
End Sub

' Debug: Print layout info
Public Sub DebugLayout
	Log("YogaView [" & Tag & "] " & ViewType & _
		" → x=" & GetAppliedLayoutX & _
		" y=" & GetAppliedLayoutY & _
		" w=" & Node.GetLayoutWidth & _
		" h=" & Node.GetLayoutHeight)
	
	Dim i As Int
	For i = 0 To Children.Size - 1
		Dim child As YogaView = Children.Get(i)
		child.DebugLayout
	Next
End Sub

