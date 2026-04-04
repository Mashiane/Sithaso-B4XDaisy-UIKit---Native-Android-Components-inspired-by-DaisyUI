B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: 100dip, Description: Width/height of the spinner (px, %, dip, etc).
#DesignerProperty: Key: Color1, DisplayName: Primary Color, FieldType: Color, DefaultValue: 0xFF3498DB, Description: First ring color.
#DesignerProperty: Key: Color2, DisplayName: Secondary Color, FieldType: Color, DefaultValue: 0xFFDB213A, Description: Second ring color.
#DesignerProperty: Key: Color3, DisplayName: Tertiary Color, FieldType: Color, DefaultValue: 0xFFDEC52D, Description: Third ring color.
#DesignerProperty: Key: StrokeWidth, DisplayName: Stroke Width, FieldType: String, DefaultValue: 3dip, Description: Ring border thickness.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the spinner.

#IgnoreWarnings:12
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
    Private mColor1 As Int = 0xFF3498DB
    Private mColor2 As Int = 0xFFDB213A
    Private mColor3 As Int = 0xFFDEC52D
    Private mStroke As Float = 3dip
    Private mVisible As Boolean = True
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
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

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
    mBase = Base
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
    mSize = B4XDaisyVariants.GetPropString(Props, "Size", mSize)
    mColor1 = B4XDaisyVariants.GetPropColor(Props, "Color1", mColor1)
    mColor2 = B4XDaisyVariants.GetPropColor(Props, "Color2", mColor2)
    mColor3 = B4XDaisyVariants.GetPropColor(Props, "Color3", mColor3)
    mStroke = B4XDaisyVariants.GetPropFloat(Props, "StrokeWidth", mStroke)
    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    Base_Resize(mBase.Width, mBase.Height)
    ' apply visibility state from designer
    mBase.Visible = mVisible
    timer.Enabled = mVisible
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If Width <= 0 Then Width = mBase.Width
    If Height <= 0 Then Height = mBase.Height
    Parent.AddView(mBase, Left, Top, Width, Height)
    ResizePanels(Width, Height)
    Return mBase
End Sub

' Attaches spinner full-screen to the given view and expands to its size
Public Sub AttachTo(Target As B4XView) As B4XView
    If Target.IsInitialized = False Then Return mBase
    Target.AddView(mBase, 0, 0, Target.Width, Target.Height)
    ResizePanels(Target.Width, Target.Height)
    Return mBase
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
    ResizePanels(Width, Height)
    Draw
End Sub

' convenience method for external callers (page/overlay) to resize & layout
Public Sub Resize(Width As Int, Height As Int)
    ' maintain a square spinner fitting inside the given area
    Dim side As Int = Min(Width, Height) * 0.5
    mBase.SetLayoutAnimated(0, Width / 2 - side / 2, Height / 2 - side / 2, side, side)
    ResizePanels(side, side)
    Draw
End Sub

' Utility for adding a child to the spinner (not common but mirror overlay API)
Public Sub AddChild(View As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized Then
        mBase.AddView(View, Left, Top, Width, Height)
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
    
    ' Ring 1: Outer, blue, two 90deg segments (top and bottom)
    ' border-top-color: #3498db; border-bottom-color: #3498db;
    DrawLoaderRing(c1, cx, cy, rBase, mStroke, mColor1, 90, 0)
    DrawLoaderRing(c1, cx, cy, rBase, mStroke, mColor1, 90, 180)
    
    ' Ring 2: Middle, red, one 90deg segment (top)
    ' border-top-color: #db213a; top/bottom/left/right: 2%;
    DrawLoaderRing(c2, cx, cy, rBase * 0.96, mStroke, mColor2, 90, 0)
    
    ' Ring 3: Inner, yellow, one 90deg segment (top)
    ' border-top-color: #dec52d; top/bottom/left/right: 5%;
    DrawLoaderRing(c3, cx, cy, rBase * 0.90, mStroke, mColor3, 90, 0)
    
    c1.Invalidate
    c2.Invalidate
    c3.Invalidate
End Sub

' Draws a ring portion (CSS border-color effect)
Private Sub DrawLoaderRing(cvs As B4XCanvas, cx As Float, cy As Float, radius As Float, stroke As Float, color As Int, sweepAngle As Float, offsetAngle As Float)
    Dim startAngle As Float = -90 - (sweepAngle / 2) + offsetAngle
    Dim segments As Int = 12
    Dim path As B4XPath
    path.Initialize(0,0)
    CreateArcPath(path, cx, cy, radius, startAngle, sweepAngle, segments)
    cvs.DrawPath(path, color, False, stroke)
    
    ' Round caps to match the smooth look of the GIF
    Dim startX As Float = cx + radius * CosD(startAngle)
    Dim startY As Float = cy + radius * SinD(startAngle)
    Dim endAngle As Float = startAngle + sweepAngle
    Dim endX As Float = cx + radius * CosD(endAngle)
    Dim endY As Float = cy + radius * SinD(endAngle)
    cvs.DrawCircle(startX, startY, stroke/2, color, True, 0)
    cvs.DrawCircle(endX, endY, stroke/2, color, True, 0)
End Sub

Public Sub Show
    ' ensure the rings are drawn before becoming visible
    If canvasesInitialized Then Draw
    mBase.Visible = True
    timer.Enabled = True
End Sub

Public Sub Hide
    timer.Enabled = False
    mBase.Visible = False
End Sub

Public Sub getVisible As Boolean
    Return mBase.Visible
End Sub

Public Sub setVisible(b As Boolean)
    If b Then Show Else Hide
End Sub

Public Sub getSize As String
    Return mSize
End Sub
Public Sub setSize(s As String)
    mSize = s
    If mBase.IsInitialized Then
        mBase.SetLayoutAnimated(0, 0, 0, B4XDaisyVariants.TailwindSizeToDip(s, mBase.Width), B4XDaisyVariants.TailwindSizeToDip(s, mBase.Height))
        ResizePanels(mBase.Width, mBase.Height)
        Draw
    End If
End Sub

' ---- additional property accessors ----
Public Sub getColor1 As Int
    Return mColor1
End Sub
Public Sub setColor1(c As Int)
    mColor1 = c
    If canvasesInitialized Then Draw
End Sub

Public Sub getColor2 As Int
    Return mColor2
End Sub
Public Sub setColor2(c As Int)
    mColor2 = c
    If canvasesInitialized Then Draw
End Sub

Public Sub getColor3 As Int
    Return mColor3
End Sub
Public Sub setColor3(c As Int)
    mColor3 = c
    If canvasesInitialized Then Draw
End Sub

Public Sub getStrokeWidth As Float
    Return mStroke
End Sub
Public Sub setStrokeWidth(s As Float)
    mStroke = s
    If canvasesInitialized Then Draw
End Sub



' helper to reposition the three panels when size changes
Private Sub ResizePanels(Width As Int, Height As Int)
    Dim side As Int = Min(Width, Height)
    ' To ensure 100% perfect concentricity, all panels must have the exact same size and center.
    ' We control the ring offsets purely via the radius in the Draw method.
    p1.SetLayoutAnimated(0, 0, 0, side, side)
    p2.SetLayoutAnimated(0, 0, 0, side, side)
    p3.SetLayoutAnimated(0, 0, 0, side, side)
    
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

' more setters/getters could be added as needed

' draw a fractional ring using a path (start angle = 0)
Private Sub DrawRing(cvs As B4XCanvas, cx As Float, cy As Float, radius As Float, color As Int, stroke As Float, sweepAngle As Float)
    Dim startAngle As Float = 0
    Dim segments As Int = 36 ' 10� per segment gives smooth arc
    Dim path As B4XPath
    path.Initialize(0,0) ' will be moved below
    CreateArcPath(path, cx, cy, radius, startAngle, sweepAngle, segments)
    ' draw the path with stroke width; rounded caps done manually below
    cvs.DrawPath(path, color, False, stroke)
    ' draw circles at start/end to mimic round stroke cap
    Dim startX As Float = cx + radius * CosD(startAngle)
    Dim startY As Float = cy + radius * SinD(startAngle)
    Dim endAngle As Float = startAngle + sweepAngle
    Dim endX As Float = cx + radius * CosD(endAngle)
    Dim endY As Float = cy + radius * SinD(endAngle)
    cvs.DrawCircle(startX, startY, stroke/2, color, True, 0)
    cvs.DrawCircle(endX, endY, stroke/2, color, True, 0)
    cvs.Invalidate
End Sub

' generates a polyline approximating an arc
Private Sub CreateArcPath(path As B4XPath, cx As Float, cy As Float, radius As Float, startAngle As Float, sweepAngle As Float, segments As Int)
    Dim angleStep As Float = sweepAngle / segments
    Dim angle As Float = startAngle
    For i = 0 To segments
        Dim x As Float = cx + radius * CosD(angle)
        Dim y As Float = cy + radius * SinD(angle)
        If i = 0 Then
            path.Initialize(x, y)
        Else
            path.LineTo(x, y)
        End If
        angle = angle + angleStep
    Next
End Sub
