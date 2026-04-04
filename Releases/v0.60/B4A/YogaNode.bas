B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	' The wrapped Java YogaNode
	Public mNode As JavaObject
	
	' Tree references
	Public Tag As String
	Public Children As List
	Private mParent As YogaNode				'ignore
End Sub

' Initialize a new Yoga node with default Yoga config.
'Public Sub Initialize(nTag As String)
'	Initialize2(nTag, Null)
'End Sub

' Initialize a new Yoga node with an explicit YogaConfig when needed.
Public Sub Initialize(nTag As String, yogaConfig As Object)
	Tag = nTag
	Children.Initialize
	EnsureSoLoaderInitialized
	
	' Create Java YogaNode via factory
	Dim factory As JavaObject
	factory.InitializeStatic("com.facebook.yoga.YogaNodeFactory")
	If yogaConfig = Null Then
		mNode = factory.RunMethod("create", Null)
	Else
		mNode = factory.RunMethod("create", Array(yogaConfig))
	End If
End Sub

Private Sub EnsureSoLoaderInitialized
	Dim loader As JavaObject
	loader.InitializeStatic("com.facebook.soloader.SoLoader")
	If loader.RunMethod("isInitialized", Null) Then Return
	
	' Yoga's native library load path requires an application context on Android.
	Dim context As JavaObject
	context.InitializeContext
	Dim appContext As Object = context.RunMethod("getApplicationContext", Null)
	loader.RunMethod("init", Array(appContext, False))
End Sub

' ============================================================
' GENERAL PROPERTY DISPATCHER
' Called by YogaView.SetStyle() — maps string keys to setters
' ============================================================
Public Sub SetProperty(key As String, value As Object)
	Select key.ToLowerCase
		' --- Flex Direction & Wrap ---
		Case "flexdirection"
			SetFlexDirection(value)
		Case "flexwrap"
			SetFlexWrap(value)
		
		' --- Alignment ---
		Case "justifycontent"
			SetJustifyContent(value)
		Case "alignitems"
			SetAlignItems(value)
		Case "alignself"
			SetAlignSelf(value)
		Case "aligncontent"
			SetAlignContent(value)
		
		' --- Flex Sizing ---
		Case "flex"
			SetFlex(value)
		Case "flexgrow"
			SetFlexGrow(value)
		Case "flexshrink"
			SetFlexShrink(value)
		Case "flexbasis"
			SetFlexBasisSmart(value)
		
		' --- Dimensions ---
		Case "width"
			SetDimensionSmart("Width", value)
		Case "height"
			SetDimensionSmart("Height", value)
		Case "minwidth"
			SetDimensionSmart("MinWidth", value)
		Case "minheight"
			SetDimensionSmart("MinHeight", value)
		Case "maxwidth"
			SetDimensionSmart("MaxWidth", value)
		Case "maxheight"
			SetDimensionSmart("MaxHeight", value)
		
		' --- Padding (all edge variations) ---
		Case "padding"
			SetPaddingSmart("ALL", value)
		Case "paddingtop"
			SetPaddingSmart("TOP", value)
		Case "paddingbottom"
			SetPaddingSmart("BOTTOM", value)
		Case "paddingleft"
			SetPaddingSmart("LEFT", value)
		Case "paddingright"
			SetPaddingSmart("RIGHT", value)
		Case "paddingstart"
			SetPaddingSmart("START", value)
		Case "paddingend"
			SetPaddingSmart("END", value)
		Case "paddinghorizontal"
			SetPaddingSmart("HORIZONTAL", value)
		Case "paddingvertical"
			SetPaddingSmart("VERTICAL", value)
		
		' --- Margin (all edge variations) ---
		Case "margin"
			SetMarginSmart("ALL", value)
		Case "margintop"
			SetMarginSmart("TOP", value)
		Case "marginbottom"
			SetMarginSmart("BOTTOM", value)
		Case "marginleft"
			SetMarginSmart("LEFT", value)
		Case "marginright"
			SetMarginSmart("RIGHT", value)
		Case "marginstart"
			SetMarginSmart("START", value)
		Case "marginend"
			SetMarginSmart("END", value)
		Case "marginhorizontal"
			SetMarginSmart("HORIZONTAL", value)
		Case "marginvertical"
			SetMarginSmart("VERTICAL", value)
		
		' --- Border Width (layout only, visual handled by YogaView) ---
		Case "borderwidth"
			SetBorderWidth("ALL", value)
		Case "bordertopwidth"
			SetBorderWidth("TOP", value)
		Case "borderbottomwidth"
			SetBorderWidth("BOTTOM", value)
		Case "borderleftwidth"
			SetBorderWidth("LEFT", value)
		Case "borderrightwidth"
			SetBorderWidth("RIGHT", value)
		
		' --- Position ---
		Case "position"
			SetPositionType(value)
		Case "top"
			SetPositionEdge("TOP", value)
		Case "bottom"
			SetPositionEdge("BOTTOM", value)
		Case "left"
			SetPositionEdge("LEFT", value)
		Case "right"
			SetPositionEdge("RIGHT", value)
		Case "start"
			SetPositionEdge("START", value)
		Case "end"
			SetPositionEdge("END", value)
		
		' --- Gap ---
		Case "gap"
			SetGap("ALL", value)
		Case "rowgap"
			SetGap("ROW", value)
		Case "columngap"
			SetGap("COLUMN", value)
		
		' --- Other ---
		Case "aspectratio"
			SetAspectRatio(value)
		Case "display"
			SetDisplay(value)
		Case "overflow"
			SetOverflow(value)
		Case "direction"
			SetDirection(value)
		Case "boxsizing"
			SetBoxSizing(value)
	End Select
End Sub

' ============================================================
' FLEX DIRECTION & WRAP
' ============================================================
Public Sub SetFlexDirection(value As Object)
	Dim enumName As String = MapFlexDirection(value)
	mNode.RunMethod("setFlexDirection", Array(GetEnum("com.facebook.yoga.YogaFlexDirection", enumName)))
End Sub

Public Sub SetFlexWrap(value As Object)
	Dim enumName As String
	Select value.As(String).ToLowerCase
		Case "wrap": enumName = "WRAP"
		Case "wrap-reverse": enumName = "WRAP_REVERSE"
		Case "nowrap", "no-wrap": enumName = "NO_WRAP"
		Case Else: enumName = "NO_WRAP"
	End Select
	mNode.RunMethod("setWrap", Array(GetEnum("com.facebook.yoga.YogaWrap", enumName)))
End Sub

' ============================================================
' ALIGNMENT
' ============================================================
Public Sub SetJustifyContent(value As Object)
	Dim enumName As String = MapJustify(value)
	mNode.RunMethod("setJustifyContent", Array(GetEnum("com.facebook.yoga.YogaJustify", enumName)))
End Sub

Public Sub SetAlignItems(value As Object)
	Dim enumName As String = MapAlign(value)
	mNode.RunMethod("setAlignItems", Array(GetEnum("com.facebook.yoga.YogaAlign", enumName)))
End Sub

Public Sub SetAlignSelf(value As Object)
	Dim enumName As String = MapAlign(value)
	mNode.RunMethod("setAlignSelf", Array(GetEnum("com.facebook.yoga.YogaAlign", enumName)))
End Sub

Public Sub SetAlignContent(value As Object)
	Dim enumName As String = MapAlign(value)
	mNode.RunMethod("setAlignContent", Array(GetEnum("com.facebook.yoga.YogaAlign", enumName)))
End Sub

' ============================================================
' FLEX SIZING
' ============================================================
Public Sub SetFlex(value As Object)
	mNode.RunMethod("setFlex", Array(ParseFloat(value)))
End Sub

Public Sub SetFlexGrow(value As Object)
	mNode.RunMethod("setFlexGrow", Array(ParseFloat(value)))
End Sub

Public Sub SetFlexShrink(value As Object)
	mNode.RunMethod("setFlexShrink", Array(ParseFloat(value)))
End Sub

Public Sub SetFlexBasis(value As Float)
	mNode.RunMethod("setFlexBasis", Array(value))
End Sub

Public Sub SetFlexBasisPercent(value As Float)
	mNode.RunMethod("setFlexBasisPercent", Array(value))
End Sub

Public Sub SetFlexBasisAuto
	mNode.RunMethod("setFlexBasisAuto", Null)
End Sub

' Smart: handles number, "50%", "auto"
Private Sub SetFlexBasisSmart(value As Object)
	Dim s As String = value
	If s.ToLowerCase = "auto" Then
		SetFlexBasisAuto
	Else If s.EndsWith("%") Then
		SetFlexBasisPercent(s.Replace("%", ""))
	Else
		SetFlexBasis(ParseLayoutLength(value))
	End If
End Sub

' ============================================================
' DIMENSIONS (Width, Height, Min*, Max*)
' ============================================================
Public Sub SetWidth(value As Float)
	mNode.RunMethod("setWidth", Array(value))
End Sub

Public Sub SetWidthPercent(value As Float)
	mNode.RunMethod("setWidthPercent", Array(value))
End Sub

Public Sub SetWidthAuto
	mNode.RunMethod("setWidthAuto", Null)
End Sub

Public Sub SetHeight(value As Float)
	mNode.RunMethod("setHeight", Array(value))
End Sub

Public Sub SetHeightPercent(value As Float)
	mNode.RunMethod("setHeightPercent", Array(value))
End Sub

Public Sub SetHeightAuto
	mNode.RunMethod("setHeightAuto", Null)
End Sub

Public Sub SetMinWidth(value As Float)
	mNode.RunMethod("setMinWidth", Array(value))
End Sub

Public Sub SetMinWidthPercent(value As Float)
	mNode.RunMethod("setMinWidthPercent", Array(value))
End Sub

Public Sub SetMinHeight(value As Float)
	mNode.RunMethod("setMinHeight", Array(value))
End Sub

Public Sub SetMinHeightPercent(value As Float)
	mNode.RunMethod("setMinHeightPercent", Array(value))
End Sub

Public Sub SetMaxWidth(value As Float)
	mNode.RunMethod("setMaxWidth", Array(value))
End Sub

Public Sub SetMaxWidthPercent(value As Float)
	mNode.RunMethod("setMaxWidthPercent", Array(value))
End Sub

Public Sub SetMaxHeight(value As Float)
	mNode.RunMethod("setMaxHeight", Array(value))
End Sub

Public Sub SetMaxHeightPercent(value As Float)
	mNode.RunMethod("setMaxHeightPercent", Array(value))
End Sub

' Smart dimension setter: handles number, "50%", "auto"
Private Sub SetDimensionSmart(prop As String, value As Object)
	Dim s As String = value
	If s.ToLowerCase = "auto" Then
		mNode.RunMethod("set" & prop & "Auto", Null)
	Else If s.EndsWith("%") Then
		mNode.RunMethod("set" & prop & "Percent", Array(ParseFloat(s.Replace("%", ""))))
	Else
		mNode.RunMethod("set" & prop, Array(ParseLayoutLength(value)))
	End If
End Sub

' ============================================================
' PADDING
' ============================================================
Public Sub SetPadding(edge As String, value As Float)
	mNode.RunMethod("setPadding", Array(GetEdge(edge), value))
End Sub

Public Sub SetPaddingPercent(edge As String, value As Float)
	mNode.RunMethod("setPaddingPercent", Array(GetEdge(edge), value))
End Sub

Private Sub SetPaddingSmart(edge As String, value As Object)
	Dim s As String = value
	If s.EndsWith("%") Then
		SetPaddingPercent(edge, ParseFloat(s.Replace("%", "")))
	Else
		SetPadding(edge, ParseLayoutLength(value))
	End If
End Sub

' ============================================================
' MARGIN
' ============================================================
Public Sub SetMargin(edge As String, value As Float)
	mNode.RunMethod("setMargin", Array(GetEdge(edge), value))
End Sub

Public Sub SetMarginPercent(edge As String, value As Float)
	mNode.RunMethod("setMarginPercent", Array(GetEdge(edge), value))
End Sub

Public Sub SetMarginAuto(edge As String)
	mNode.RunMethod("setMarginAuto", Array(GetEdge(edge)))
End Sub

Private Sub SetMarginSmart(edge As String, value As Object)
	Dim s As String = value
	If s.ToLowerCase = "auto" Then
		SetMarginAuto(edge)
	Else If s.EndsWith("%") Then
		SetMarginPercent(edge, ParseFloat(s.Replace("%", "")))
	Else
		SetMargin(edge, ParseLayoutLength(value))
	End If
End Sub

' ============================================================
' BORDER WIDTH (layout contribution only)
' ============================================================
Public Sub SetBorderWidth(edge As String, value As Object)
	mNode.RunMethod("setBorder", Array(GetEdge(edge), ParseLayoutLength(value)))
End Sub

' ============================================================
' POSITION
' ============================================================
Public Sub SetPositionType(value As Object)
	Dim enumName As String
	Select value.As(String).ToLowerCase
		Case "absolute": enumName = "ABSOLUTE"
		Case "relative": enumName = "RELATIVE"
		Case "static": enumName = "STATIC"
		Case Else: enumName = "RELATIVE"
	End Select
	mNode.RunMethod("setPositionType", Array(GetEnum("com.facebook.yoga.YogaPositionType", enumName)))
End Sub

Public Sub SetPositionEdge(edge As String, value As Object)
	Dim s As String = value
	If s.EndsWith("%") Then
		mNode.RunMethod("setPositionPercent", Array(GetEdge(edge), ParseFloat(s.Replace("%", ""))))
	Else
		mNode.RunMethod("setPosition", Array(GetEdge(edge), ParseLayoutLength(value)))
	End If
End Sub

' ============================================================
' GAP
' ============================================================
Public Sub SetGap(gutter As String, value As Object)
	Dim enumName As String
	Select gutter.ToUpperCase
		Case "ALL": enumName = "ALL"
		Case "ROW": enumName = "ROW"
		Case "COLUMN": enumName = "COLUMN"
		Case Else: enumName = "ALL"
	End Select
	Dim s As String = value
	If s.EndsWith("%") Then
		mNode.RunMethod("setGapPercent", Array(GetEnum("com.facebook.yoga.YogaGutter", enumName), ParseFloat(s.Replace("%", ""))))
	Else
		mNode.RunMethod("setGap", Array(GetEnum("com.facebook.yoga.YogaGutter", enumName), ParseLayoutLength(value)))
	End If
End Sub

' ============================================================
' OTHER PROPERTIES
' ============================================================
Public Sub SetAspectRatio(value As Object)
	mNode.RunMethod("setAspectRatio", Array(ParseFloat(value)))
End Sub

Public Sub SetDisplay(value As Object)
	Dim enumName As String
	Select value.As(String).ToLowerCase
		Case "none": enumName = "NONE"
		Case "flex": enumName = "FLEX"
		Case "contents": enumName = "CONTENTS"
		Case Else: enumName = "FLEX"
	End Select
	mNode.RunMethod("setDisplay", Array(GetEnum("com.facebook.yoga.YogaDisplay", enumName)))
End Sub

Public Sub SetOverflow(value As Object)
	Dim enumName As String
	Select value.As(String).ToLowerCase
		Case "hidden": enumName = "HIDDEN"
		Case "scroll": enumName = "SCROLL"
		Case "visible": enumName = "VISIBLE"
		Case Else: enumName = "VISIBLE"
	End Select
	mNode.RunMethod("setOverflow", Array(GetEnum("com.facebook.yoga.YogaOverflow", enumName)))
End Sub

Public Sub SetDirection(value As Object)
	Dim enumName As String
	Select value.As(String).ToLowerCase
		Case "ltr": enumName = "LTR"
		Case "rtl": enumName = "RTL"
		Case "inherit": enumName = "INHERIT"
		Case Else: enumName = "INHERIT"
	End Select
	mNode.RunMethod("setDirection", Array(GetEnum("com.facebook.yoga.YogaDirection", enumName)))
End Sub

Public Sub SetBoxSizing(value As Object)
	Dim enumName As String
	Select value.As(String).ToLowerCase
		Case "border-box": enumName = "BORDER_BOX"
		Case "content-box": enumName = "CONTENT_BOX"
		Case Else: enumName = "BORDER_BOX"
	End Select
	mNode.RunMethod("setBoxSizing", Array(GetEnum("com.facebook.yoga.YogaBoxSizing", enumName)))
End Sub

' ============================================================
' CHILD MANAGEMENT
' ============================================================
Public Sub AddChild(child As YogaNode)
	mNode.RunMethod("addChildAt", Array(child.mNode, Children.Size))
	Children.Add(child)
	child.mParent = Me
End Sub

Public Sub AddChildAt(child As YogaNode, index As Int)
	mNode.RunMethod("addChildAt", Array(child.mNode, index))
	Children.InsertAt(index, child)
	child.mParent = Me
End Sub

Public Sub RemoveChild(child As YogaNode)
	Dim idx As Int = Children.IndexOf(child)
	If idx >= 0 Then
		mNode.RunMethod("removeChildAt", Array(idx))
		Children.RemoveAt(idx)
		child.mParent = Null
	End If
End Sub

Public Sub RemoveChildAt(index As Int)
	If index >= 0 And index < Children.Size Then
		Dim child As YogaNode = Children.Get(index)
		mNode.RunMethod("removeChildAt", Array(index))
		Children.RemoveAt(index)
		child.mParent = Null
	End If
End Sub

Public Sub GetChildCount As Int
	Return Children.Size
End Sub

Public Sub GetChildAt(index As Int) As YogaNode
	Return Children.Get(index)
End Sub

' ============================================================
' LAYOUT CALCULATION
' ============================================================
Public Sub CalculateLayout(availableWidth As Float, availableHeight As Float)
	mNode.RunMethod("calculateLayout", Array(availableWidth, availableHeight))
End Sub

' Calculate with UNDEFINED dimensions (auto-size)
Public Sub CalculateLayoutAuto
	Dim undefined As Object = GetUndefined
	mNode.RunMethod("calculateLayout", Array(undefined, undefined))
End Sub

' ============================================================
' LAYOUT RESULT GETTERS
' ============================================================
Public Sub GetLayoutX As Float
	Return mNode.RunMethod("getLayoutX", Null)
End Sub

Public Sub GetLayoutY As Float
	Return mNode.RunMethod("getLayoutY", Null)
End Sub

Public Sub GetLayoutWidth As Float
	Return mNode.RunMethod("getLayoutWidth", Null)
End Sub

Public Sub GetLayoutHeight As Float
	Return mNode.RunMethod("getLayoutHeight", Null)
End Sub

Public Sub GetLayoutPadding(edge As String) As Float
	' Use getLayoutPadding with edge enum
	Return mNode.RunMethod("getLayoutPadding", Array(GetEdge(edge)))
End Sub

Public Sub GetLayoutMargin(edge As String) As Float
	Return mNode.RunMethod("getLayoutMargin", Array(GetEdge(edge)))
End Sub

Public Sub GetLayoutBorder(edge As String) As Float
	Return mNode.RunMethod("getLayoutBorder", Array(GetEdge(edge)))
End Sub

' ============================================================
' DIRTY STATE
' ============================================================
Public Sub IsDirty As Boolean
	Return mNode.RunMethod("isDirty", Null)
End Sub

Public Sub MarkDirty
	mNode.RunMethod("markDirty", Null)
End Sub

' ============================================================
' HELPER: Enum Resolver
' ============================================================
Private Sub GetEnum(className As String, valueName As String) As Object
	Dim jo As JavaObject
	jo.InitializeStatic(className)
	Return jo.GetField(valueName)
End Sub

' ============================================================
' HELPER: Edge Enum
' ============================================================
Private Sub GetEdge(edgeName As String) As Object
	Return GetEnum("com.facebook.yoga.YogaEdge", edgeName.ToUpperCase)
End Sub

' ============================================================
' HELPER: UNDEFINED constant (Float.NaN)
' ============================================================
Private Sub GetUndefined As Object
	Dim jo As JavaObject
	jo.InitializeStatic("java.lang.Float")
	Return jo.GetField("NaN")
End Sub

' ============================================================
' HELPER: Parse value to float safely
' ============================================================
Private Sub ParseFloat(value As Object) As Float
	Try
		Return value
	Catch
		Try
			Dim s As String = value
			Return s
		Catch
			Log("YogaNode.ParseFloat: Could not parse value: " & value)
			Return 0
		End Try
	End Try
End Sub

Private Sub ParseLayoutLength(value As Object) As Float
	Return YogaStyle.DipToCurrent1(ParseFloat(value))
End Sub

' ============================================================
' HELPER: Map RN-style names to Java enum names
' ============================================================
Private Sub MapFlexDirection(value As Object) As String
	Select value.As(String).ToLowerCase
		Case "row": Return "ROW"
		Case "column": Return "COLUMN"
		Case "row-reverse": Return "ROW_REVERSE"
		Case "column-reverse": Return "COLUMN_REVERSE"
		Case Else: Return "COLUMN"
	End Select
End Sub

Private Sub MapJustify(value As Object) As String
	Select value.As(String).ToLowerCase
		Case "flex-start": Return "FLEX_START"
		Case "center": Return "CENTER"
		Case "flex-end": Return "FLEX_END"
		Case "space-between": Return "SPACE_BETWEEN"
		Case "space-around": Return "SPACE_AROUND"
		Case "space-evenly": Return "SPACE_EVENLY"
		Case Else: Return "FLEX_START"
	End Select
End Sub

Private Sub MapAlign(value As Object) As String
	Select value.As(String).ToLowerCase
		Case "auto": Return "AUTO"
		Case "flex-start": Return "FLEX_START"
		Case "center": Return "CENTER"
		Case "flex-end": Return "FLEX_END"
		Case "stretch": Return "STRETCH"
		Case "baseline": Return "BASELINE"
		Case "space-between": Return "SPACE_BETWEEN"
		Case "space-around": Return "SPACE_AROUND"
		Case "space-evenly": Return "SPACE_EVENLY"
		Case Else: Return "STRETCH"
	End Select
End Sub

' ============================================================
' CLEANUP
' ============================================================
Public Sub Reset
	mNode.RunMethod("reset", Null)
	Children.Clear
	mParent = Null
End Sub

