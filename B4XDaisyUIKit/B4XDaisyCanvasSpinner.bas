B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: 100dip, Description: Width/height of the spinner (px, %, dip, etc).
#DesignerProperty: Key: Color1, DisplayName: Primary Color, FieldType: Color, DefaultValue: 0xFF3FC3EE, Description: First ring color.
#DesignerProperty: Key: Color2, DisplayName: Secondary Color, FieldType: Color, DefaultValue: 0xFFF27474, Description: Second ring color.
#DesignerProperty: Key: Color3, DisplayName: Tertiary Color, FieldType: Color, DefaultValue: 0xFFF8BB86, Description: Third ring color.
#DesignerProperty: Key: StrokeWidth, DisplayName: Stroke Width, FieldType: String, DefaultValue: 4dip, Description: Ring border thickness.
#DesignerProperty: Key: OverlayColor, DisplayName: Overlay Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Backdrop color when overlay is shown.
#DesignerProperty: Key: OverlayOpacity, DisplayName: Overlay Opacity, FieldType: Float, DefaultValue: 0.0, Description: Backdrop opacity from 0.0 (transparent) to 1.0 (opaque).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the spinner.

#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private timer As Timer
    Private angle1 As Float, angle2 As Float, angle3 As Float

    ' nested panels/canvases for each ring
    Private p1 As B4XView, p2 As B4XView, p3 As B4XView
    Private c1 As B4XCanvas, c2 As B4XCanvas, c3 As B4XCanvas
    Private canvasesInitialized As Boolean

    ' properties
    Private mSize As String = "100dip"
    Private mColor1 As Int = 0xFF3FC3EE
    Private mColor2 As Int = 0xFFF27474
    Private mColor3 As Int = 0xFFF8BB86
    Private mStroke As Float = 4dip
    Private mOverlayColor As Int = 0xFFFFFFFF
    Private mOverlayOpacity As Float = 0.0
    Private mVisible As Boolean = True
    Private mCallBack As Object
    Private mEventName As String
    Private mFullScreenLoader As Boolean = False
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mBase = xui.CreatePanel("")
    mBase.SetLayoutAnimated(0, 0, 0, 100dip, 100dip)
    timer.Initialize("t", 16)
    ' create three overlay panels
    p1 = xui.CreatePanel("") : p1.SetColorAndBorder(xui.Color_Transparent,0,0,0)
    p2 = xui.CreatePanel("") : p2.SetColorAndBorder(xui.Color_Transparent,0,0,0)
    p3 = xui.CreatePanel("") : p3.SetColorAndBorder(xui.Color_Transparent,0,0,0)
    mBase.AddView(p1,0,0,0,0)
    mBase.AddView(p2,0,0,0,0)
    mBase.AddView(p3,0,0,0,0)
    ' canvases will be initialized once panels have valid size
    canvasesInitialized = False
End Sub

Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    timer.Initialize("t", 16)
    ' nested panels
    p1 = xui.CreatePanel("") : p2 = xui.CreatePanel("") : p3 = xui.CreatePanel("")
    p1.SetColorAndBorder(xui.Color_Transparent,0,0,0)
    p2.SetColorAndBorder(xui.Color_Transparent,0,0,0)
    p3.SetColorAndBorder(xui.Color_Transparent,0,0,0)
    mBase.AddView(p1,0,0,0,0)
    mBase.AddView(p2,0,0,0,0)
    mBase.AddView(p3,0,0,0,0)
    ' canvases will be initialized later when resized
    canvasesInitialized = False
    ' apply designer props
'    mSize = B4XDaisyVariants.GetPropString(Props, "Size", mSize)
'    mColor1 = B4XDaisyVariants.GetPropColor(Props, "Color1", mColor1)
'    mColor2 = B4XDaisyVariants.GetPropColor(Props, "Color2", mColor2)
'    mColor3 = B4XDaisyVariants.GetPropColor(Props, "Color3", mColor3)
'    mStroke = B4XDaisyVariants.GetPropFloat(Props, "StrokeWidth", mStroke)
'    mOverlayColor = B4XDaisyVariants.GetPropColor(Props, "OverlayColor", mOverlayColor)
'    mOverlayOpacity = Max(0.0, Min(1.0, B4XDaisyVariants.GetPropFloat(Props, "OverlayOpacity", mOverlayOpacity)))
'    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
    ApplyDesignerProps(mProps)
    Base_Resize(mBase.Width, mBase.Height)
    ' apply visibility state from designer
    mBase.Visible = mVisible
    #If B4A
    If mVisible Then
        StartNativeRotation(p1, 2000)
        StartNativeRotation(p2, 3000)
        StartNativeRotation(p3, 1500)
    End If
    #Else
    If timer <> Null Then
        If timer.IsInitialized Then timer.Enabled = mVisible
    End If
    #End If
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    ' apply designer props
    mSize = B4XDaisyVariants.GetPropString(mProps, "Size", mSize)
    mColor1 = B4XDaisyVariants.GetPropColor(mProps, "Color1", mColor1)
    mColor2 = B4XDaisyVariants.GetPropColor(mProps, "Color2", mColor2)
    mColor3 = B4XDaisyVariants.GetPropColor(mProps, "Color3", mColor3)
    mStroke = B4XDaisyVariants.GetPropFloat(mProps, "StrokeWidth", mStroke)
    mOverlayColor = B4XDaisyVariants.GetPropColor(mProps, "OverlayColor", mOverlayColor)
    mOverlayOpacity = Max(0.0, Min(1.0, B4XDaisyVariants.GetPropFloat(mProps, "OverlayOpacity", mOverlayOpacity)))
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub BuildRuntimeProps As Map
	Dim props As Map
	props.Initialize
	props.Put("Size", mSize)
	props.Put("Color1", mColor1)
	props.Put("Color2", mColor2)
	props.Put("Color3", mColor3)
	props.Put("StrokeWidth", mStroke)
	props.Put("OverlayColor", mOverlayColor)
	props.Put("OverlayOpacity", mOverlayOpacity)
	props.Put("Visible", mVisible)
	Return props
End Sub

Public Sub GetComputedHeight As Int
	If mBase = Null Then Return 0
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent = Null Or vParent.IsInitialized = False Then Return mBase
    If mBase = Null Or mBase.IsInitialized = False Then Return mBase
    mFullScreenLoader = False
    If iWidth <= 0 Then iWidth = mBase.Width
    If iHeight <= 0 Then iHeight = mBase.Height
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    ApplyOverlayColor
    ResizePanels(iWidth, iHeight)
    Return mBase
End Sub

' Attaches spinner full-screen to the given view and expands to its size
Public Sub AttachTo(vTarget As B4XView) As B4XView
    If vTarget = Null Or vTarget.IsInitialized = False Then Return mBase
    If mBase = Null Or mBase.IsInitialized = False Then Return mBase
    mFullScreenLoader = True
    vTarget.AddView(mBase, 0, 0, vTarget.Width, vTarget.Height)
    ApplyOverlayColor
    ResizePanels(vTarget.Width, vTarget.Height)
    Return mBase
End Sub

Public Sub Base_Resize (dWidth As Double, dHeight As Double)
    If mBase = Null Or mBase.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    ResizePanels(dWidth, dHeight)
    Draw
    inResize = False
End Sub

' convenience method for external callers (page/overlay) to resize & layout
Public Sub Resize(iWidth As Int, iHeight As Int)
    If mBase = Null Or mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    ResizePanels(iWidth, iHeight)
    Draw
End Sub

' Utility for adding a child to the spinner (not common but mirror overlay API)
Public Sub AddChild(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase <> Null And mBase.IsInitialized Then
        mBase.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
    End If
End Sub

Private Sub t_Tick
    ' loader-1.css durations:
    ' Ring 1 (Center/Outer): 2s = 360deg / (2000ms / 16ms) = 2.88 deg/tick
    ' Ring 2 (Middle): 3s = 360deg / (3000ms / 16ms) = 1.92 deg/tick
    ' Ring 3 (Inner): 1.5s = 360deg / (1500ms / 16ms) = 3.84 deg/tick
    
    angle1 = (angle1 + 2.88) Mod 360
    angle2 = (angle2 + 1.92) Mod 360
    angle3 = (angle3 + 3.84) Mod 360
    
    ' Rotate panels clockwise (parity with CSS spin keyframe)
    p1.Rotation = angle1
    p2.Rotation = angle2
    p3.Rotation = angle3
End Sub

Private Sub Draw
    ' loader-1.css: 3 concentric rings, only specific arcs colored, each spins at different speed
    If canvasesInitialized = False Then Return
    c1.ClearRect(c1.TargetRect)
    c2.ClearRect(c2.TargetRect)
    c3.ClearRect(c3.TargetRect)
    
    Dim avail As Float = Min(c1.TargetRect.Width, c1.TargetRect.Height)
    Dim rBase As Float = Max(0, (avail - mStroke) / 2)
    Dim cx As Float = c1.TargetRect.Width / 2
    Dim cy As Float = c1.TargetRect.Height / 2
    
    ' To prevent overlap, we space the concentric rings by the stroke width plus a small gap
    Dim ringGap As Float = mStroke * 1.3
    Dim r1 As Float = rBase
    Dim r2 As Float = Max(0, rBase - ringGap)
    Dim r3 As Float = Max(0, rBase - 2 * ringGap)
    
    ' Ring 1: Outer, first color, two 90deg segments (top and bottom)
    DrawLoaderRing(c1, cx, cy, r1, mStroke, mColor1, 90, 0)
    DrawLoaderRing(c1, cx, cy, r1, mStroke, mColor1, 90, 180)
    
    ' Ring 2: Middle, second color, one 90deg segment (top)
    DrawLoaderRing(c2, cx, cy, r2, mStroke, mColor2, 90, 0)
    
    ' Ring 3: Inner, third color, one 90deg segment (top)
    DrawLoaderRing(c3, cx, cy, r3, mStroke, mColor3, 90, 0)
    
    c1.Invalidate
    c2.Invalidate
    c3.Invalidate
End Sub

' Draws a ring portion (CSS border-color effect)
Private Sub DrawLoaderRing(cvsCvs As B4XCanvas, fCx As Float, fCy As Float, fRadius As Float, fStroke As Float, iColor As Int, fSweepAngle As Float, fOffsetAngle As Float)
    Dim startAngle As Float = -90 - (fSweepAngle / 2) + fOffsetAngle
    
    ' Draw subtle background track (10% opacity) for depth
    Dim trackColor As Int = xui.Color_ARGB(25, GetRGB(iColor, 1), GetRGB(iColor, 2), GetRGB(iColor, 3))
    Dim trackP As B4XPath = CreateCleanArcPath(fCx, fCy, fRadius, 0, 360)
    cvsCvs.DrawPath(trackP, trackColor, False, fStroke)
    
    ' Draw foreground rotating/colored arc
    Dim path As B4XPath = CreateCleanArcPath(fCx, fCy, fRadius, startAngle, fSweepAngle)
    cvsCvs.DrawPath(path, iColor, False, fStroke)
    
    ' Round caps to match the smooth look of the GIF
    Dim startX As Float = fCx + fRadius * CosD(startAngle)
    Dim startY As Float = fCy + fRadius * SinD(startAngle)
    Dim endAngle As Float = startAngle + fSweepAngle
    Dim endX As Float = fCx + fRadius * CosD(endAngle)
    Dim endY As Float = fCy + fRadius * SinD(endAngle)
    cvsCvs.DrawCircle(startX, startY, fStroke/2, iColor, True, 0)
    cvsCvs.DrawCircle(endX, endY, fStroke/2, iColor, True, 0)
End Sub

Public Sub Show(vTarget As B4XView)
    If mBase = Null Or mBase.IsInitialized = False Then Return
    If vTarget <> Null And vTarget.IsInitialized Then
        Dim isAttached As Boolean = False
        Try
            If mBase.Parent = vTarget Then isAttached = True
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCanvasSpinner.Show: " & LastException.Message)
        End Try
        If isAttached = False Then
            mBase.RemoveViewFromParent
            vTarget.AddView(mBase, 0, 0, vTarget.Width, vTarget.Height)
        End If
        mFullScreenLoader = True
        Resize(vTarget.Width, vTarget.Height)
    End If
    ApplyOverlayColor
    mBase.Visible = True
    #If B4A
    Dim elev As Float = 24dip
    Dim jo As JavaObject = mBase
    jo.RunMethod("setElevation", Array As Object(elev))
    #End If
    mBase.BringToFront
    If canvasesInitialized Then Draw
    #If B4A
    StartNativeRotation(p1, 2000)
    StartNativeRotation(p2, 3000)
    StartNativeRotation(p3, 1500)
    #Else
    If timer <> Null Then
        If timer.IsInitialized Then timer.Enabled = True
    End If
    #End If
End Sub

Public Sub Hide
    #If B4A
    StopNativeRotation(p1)
    StopNativeRotation(p2)
    StopNativeRotation(p3)
    #Else
    If timer <> Null Then
        If timer.IsInitialized Then timer.Enabled = False
    End If
    #End If
    If mBase = Null Or mBase.IsInitialized = False Then Return
    mBase.Color = xui.Color_Transparent
    mBase.Visible = False
End Sub

Public Sub getVisible As Boolean
    If mBase <> Null And mBase.IsInitialized Then Return mBase.Visible
    Return False
End Sub

Public Sub setVisible(bValue As Boolean)
    If mBase = Null Then Return
    If bValue Then Show(Null) Else Hide
End Sub

Public Sub getSize As String
    Return mSize
End Sub
Public Sub setSize(sValue As String)
    mSize = sValue
    If mBase <> Null And mBase.IsInitialized Then
        mBase.SetLayoutAnimated(0, 0, 0, B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Width), B4XDaisyVariants.TailwindSizeToDip(sValue, mBase.Height))
        ResizePanels(mBase.Width, mBase.Height)
        Draw
    End If
End Sub

' ---- additional property accessors ----
Public Sub getColor1 As Int
    Return mColor1
End Sub
Public Sub setColor1(iC As Int)
    mColor1 = iC
    If canvasesInitialized Then Draw
End Sub

Public Sub getColor2 As Int
    Return mColor2
End Sub
Public Sub setColor2(iC As Int)
    mColor2 = iC
    If canvasesInitialized Then Draw
End Sub

Public Sub getColor3 As Int
    Return mColor3
End Sub
Public Sub setColor3(iC As Int)
    mColor3 = iC
    If canvasesInitialized Then Draw
End Sub

Public Sub getStrokeWidth As Float
    Return mStroke
End Sub
Public Sub setStrokeWidth(fS As Float)
    mStroke = fS
    If canvasesInitialized Then Draw
End Sub

Public Sub getOverlayColor As Int
    Return mOverlayColor
End Sub
Public Sub setOverlayColor(iC As Int)
    mOverlayColor = iC
    If getVisible Then ApplyOverlayColor
End Sub

Public Sub getOverlayOpacity As Float
    Return mOverlayOpacity
End Sub
Public Sub setOverlayOpacity(fO As Float)
    mOverlayOpacity = Max(0.0, Min(1.0, fO))
    If getVisible Then ApplyOverlayColor
End Sub' helper to reposition the three panels when size changes
Private Sub ResizePanels(iWidth As Int, iHeight As Int)
    Dim side As Int = Min(iWidth, iHeight)
    If mFullScreenLoader Then
        side = Min(iWidth, iHeight) * 0.5
    End If
    Dim left As Int = (iWidth - side) / 2
    Dim top As Int = (iHeight - side) / 2
    ' To ensure 100% perfect concentricity, all panels must have the exact same size and center.
    ' We control the ring offsets purely via the radius in the Draw method.
    p1.SetLayoutAnimated(0, left, top, side, side)
    p2.SetLayoutAnimated(0, left, top, side, side)
    p3.SetLayoutAnimated(0, left, top, side, side)
    
    ' initialize canvases once when panels have dimensions
    If canvasesInitialized = False And side > 0 Then
        c1.Initialize(p1)
        c2.Initialize(p2)
        c3.Initialize(p3)
        canvasesInitialized = True
    End If
    c1.Resize(side, side)
    c2.Resize(side, side)
    c3.Resize(side, side)
    ' always redraw after resizing (or after first initialization)
    If canvasesInitialized Then Draw
End Sub

Private Sub ApplyOverlayColor
    If mBase <> Null And mBase.IsInitialized Then
        Dim alpha As Int = Max(0, Min(255, mOverlayOpacity * 255))
        mBase.Color = xui.Color_ARGB(alpha, GetRGB(mOverlayColor, 1), GetRGB(mOverlayColor, 2), GetRGB(mOverlayColor, 3))
    End If
End Sub

' more setters/getters could be added as needed

' Helper to extract RGB channels
Private Sub GetRGB(iColor As Int, iChannel As Int) As Int
	If iChannel = 1 Then Return Bit.And(Bit.ShiftRight(iColor, 16), 0xFF) ' Red
	If iChannel = 2 Then Return Bit.And(Bit.ShiftRight(iColor, 8), 0xFF)  ' Green
	Return Bit.And(iColor, 0xFF) ' Blue
End Sub

Private Sub CreateCleanArcPath(fCx As Float, fCy As Float, fRadius As Float, fStartAngle As Float, fSweepAngle As Float) As B4XPath
	#If B4A
	Dim nativePath As JavaObject
	nativePath.InitializeNewInstance("android.graphics.Path", Null)
	Dim rectF As JavaObject
	rectF.InitializeNewInstance("android.graphics.RectF", Array(fCx - fRadius, fCy - fRadius, fCx + fRadius, fCy + fRadius))
	nativePath.RunMethod("addArc", Array(rectF, fStartAngle, fSweepAngle))
	Dim path As B4XPath = nativePath
	Return path
	#Else
	Dim path As B4XPath
	path.InitializeArc(fCx, fCy, fRadius, fStartAngle, fSweepAngle)
	Return path
	#End If
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized Then Return mBase.Top
	Return 0
End Sub

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region

#If B4A
Private Sub StartNativeRotation(vView1 As B4XView, iDurationMs As Int)
	Try
		Dim joView As JavaObject = vView1
		Dim joAnim As JavaObject
		Dim joInterpolator As JavaObject
		
		joInterpolator.InitializeNewInstance("android.view.animation.LinearInterpolator", Null)
		
		Dim fromDeg As Float = 0
		Dim toDeg As Float = 360
		Dim pivotXType As Int = 1
		Dim pivotXVal As Float = 0.5
		Dim pivotYType As Int = 1
		Dim pivotYVal As Float = 0.5
		joAnim.InitializeNewInstance("android.view.animation.RotateAnimation", Array As Object(fromDeg, toDeg, pivotXType, pivotXVal, pivotYType, pivotYVal))
		joAnim.RunMethod("setInterpolator", Array(joInterpolator))
		
		Dim duration As Long = iDurationMs
		joAnim.RunMethod("setDuration", Array(duration))
		joAnim.RunMethod("setRepeatCount", Array(-1)) ' -1 = Animation.INFINITE
		
		joView.RunMethod("startAnimation", Array(joAnim))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCanvasSpinner.StartNativeRotation: " & LastException.Message)
	End Try
End Sub

Private Sub StopNativeRotation(vView1 As B4XView)
	Try
		Dim joView As JavaObject = vView1
		joView.RunMethod("clearAnimation", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCanvasSpinner.StopNativeRotation: " & LastException.Message)
	End Try
End Sub
#End If

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
