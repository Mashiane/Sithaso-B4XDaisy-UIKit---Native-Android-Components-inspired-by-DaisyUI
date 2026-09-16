B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: spinner, List: spinner|dots|ring|ball|bars|infinity, Description: The loading animation style.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size of the loading indicator (xs, sm, md, lg, xl).
#DesignerProperty: Key: Speed, DisplayName: Speed, FieldType: Int, DefaultValue: 100, Description: Animation speed percentage (100 = normal).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visibility of the component.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant (sets spinner color).
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: When False, touch events pass through to parent (useful inside clickable list rows)
#DesignerProperty: Key: Color, DisplayName: Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override loading spinner color.

#IgnoreWarnings:12
Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI
	Private mTag As Object
	

	' Properties
	Private mLoadingStyle As String = "spinner"
	Private mSize As String = "md"
	Private mColorInt As Int = xui.Color_Black
	Private mSpeed As Int = 100
	Private mVisible As Boolean = True
	Private mVariant As String = "none"
	Private mColorOverride As Int = 0

	' Internal Views
	Private ivIcon As B4XDaisySvgIcon
	Private pnlContainer As B4XView
	Private ChildViews As List

	' Animation State
	Private AnimationActive As Boolean = False
	Private AnimIndex As Int = 0
	Private IsAttached As Boolean = False
	Private anim As B4XDaisyAnimation
	Private mCurrentTimeMs As Long = 0
	Private mClickable As Boolean = True
	Private inResize As Boolean = False
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mEventName = sEventName
	mCallBack = oCallback
	ChildViews.Initialize
	anim.Initialize
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = iWidth
	Dim h As Int = iHeight
	If w <= 0 And mBase.IsInitialized Then w = mBase.Width
	If h <= 0 And mBase.IsInitialized Then h = mBase.Height
	If w <= 0 Then w = 32dip
	If h <= 0 Then h = 32dip
	
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	
	Dim props As Map = BuildRuntimeProps(w, h)
	
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	IsAttached = True

	ApplyDesignerProps(mProps)
	' Apply clickable state to native views
	If mClickable = False Then
		#If B4A
		Dim joClickable As JavaObject = mBase
		joClickable.RunMethod("setClickable", Array(False))
		' Disable click on all child views recursively
		For Each v As B4XView In mBase.GetAllViewsRecursive
			Dim joV As JavaObject = v
			joV.RunMethod("setClickable", Array(False))
		Next
		#Else If B4J
		mBase.Enabled = False
		#Else If B4i
		mBase.Enabled = False
		#End If
	End If
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mLoadingStyle = B4XDaisyVariants.GetPropString(mProps, "Style", mLoadingStyle)
	mSize = B4XDaisyVariants.GetPropString(mProps, "Size", mSize)
	mSpeed = B4XDaisyVariants.GetPropInt(mProps, "Speed", mSpeed)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	' Initial render
	UpdateLayout
	mColorOverride = B4XDaisyVariants.GetPropColor(mProps, "Color", mColorOverride)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Style", mLoadingStyle)
	props.Put("Size", mSize)
	props.Put("Speed", mSpeed)
	props.Put("Visible", mVisible)
	props.Put("Variant", mVariant)
	props.Put("Clickable", mClickable)
	props.Put("Color", mColorOverride)
	Return props
End Sub

Public Sub Base_Resize (dWidth As Double, dHeight As Double)
	If IsAttached = False Then Return
	If inResize Then Return
	inResize = True
	UpdateLayout
	inResize = False
End Sub

Private Sub UpdateLayout
	If mBase.IsInitialized = False Then Return
	mBase.RemoveAllViews
	ChildViews.Clear
	
	' Resolve Size
	Dim sizeSelectorEx As Float = B4XDaisyVariants.GetTokenDip("--size-selector", 4dip)
	Dim sizeDip As Float = sizeSelectorEx * 6 ' Default md
	
	Select Case mSize
		Case "xs"
			sizeDip = sizeSelectorEx * 4
		Case "sm"
			sizeDip = sizeSelectorEx * 5
		Case "md"
			sizeDip = sizeSelectorEx * 6
		Case "lg"
			sizeDip = sizeSelectorEx * 7
		Case "xl"
			sizeDip = sizeSelectorEx * 8
		Case Else
			' Try to parse as custom size or default to md
			sizeDip = B4XDaisyVariants.TailwindSizeToDip(mSize, sizeSelectorEx * 6)
	End Select

	' If mBase is larger than requested size, center content? Or assume mBase IS the size?
	' Daisy behavior: .loading class SETS width.
	' Here, we might want to respect mBase size if explicit, or force it?
	' Let's assume content fills mBase but we advise setting mBase size via Size property.
	
	' Actually, `B4XDaisyBoxModel` usage suggests we should respect mBase size, 
	' BUT usually these components are fixed size based on token.
	' Let's respect mBase frame but center content if needed.
	
	Dim contentSize As Float = sizeDip
	Dim contentX As Float = (mBase.Width - contentSize) / 2
	Dim contentY As Float = (mBase.Height - contentSize) / 2
	
	' Resolve Color from Variant or explicit override.
	Dim baseContent As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	Dim colorInt As Int
	If mColorOverride <> 0 Then
		' Color override set explicitly - use it directly
		colorInt = mColorOverride
	Else If mVariant = "none" Then
		colorInt = baseContent
	Else
		colorInt = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, baseContent)
	End If
	mColorInt = colorInt

	Select Case mLoadingStyle
		Case "spinner"
			CreateSvgIcon("spinner", contentSize, colorInt, contentX, contentY)
		Case "infinity"
			CreateSvgIcon("infinity", contentSize, colorInt, contentX, contentY)
		Case "dots"
			CreateDots(contentSize, colorInt, contentX, contentY)
		Case "bars"
			CreateBars(contentSize, colorInt, contentX, contentY)
		Case "ring"
			CreateRing(contentSize, colorInt, contentX, contentY)
		Case "ball"
			CreateBall(contentSize, colorInt, contentX, contentY)
		Case Else
			CreateSvgIcon("spinner", contentSize, colorInt, contentX, contentY)
	End Select
	
	StartAnimation
End Sub

Private Sub CreateSvgIcon(sIconName As String, fSize As Float, iColor As Int, fX As Float, fY As Float)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	mBase.AddView(b, fX, fY, fSize, fSize)
	
	Dim iv As B4XDaisySvgIcon
	iv.Initialize(Me, "ivIcon")
	' We need to create it manually since we aren't using DesignerCreateView for the child
	Dim props As Map
	props.Initialize
	props.Put("Color", iColor)
	props.Put("Width", fSize)
	props.Put("Height", fSize)
	' We use a dummy label
	Dim lbl As Label
	lbl.Initialize("")
	iv.DesignerCreateView(b, lbl, props)
	iv.Base_Resize(fSize, fSize)
	iv.SetSvgContent(GetSvgPath(sIconName))
	
	ChildViews.Add(iv)
End Sub

Private Sub CreateDots(fSize As Float, iColor As Int, fX As Float, fY As Float)
	' 3 dots. Width = Size. Dot size approx Size/4. Spacing?
	' Daisy dots: 3 circles.
	Dim dotSize As Float = fSize * 0.25
	Dim gap As Float = (fSize - (3 * dotSize)) / 2 ' Distribute
	' Actually daisy dots are usually tightly packed or spaced evenly.
	' Let's put them at 0%, 37.5%, 75% of width approx.
	
	For i = 0 To 2
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetColorAndBorder(iColor, 0, 0, dotSize/2)
		Dim dx As Float = fX + (i * (dotSize + gap))
		' Center vertically
		Dim dy As Float = fY + (fSize - dotSize) / 2
		mBase.AddView(b, dx, dy, dotSize, dotSize)
		ChildViews.Add(b)
	Next
End Sub

Private Sub CreateBars(fSize As Float, iColor As Int, fX As Float, fY As Float)
	' 3 bars. 24x24 coord system.
	' Rect 1: x=1, y=1, w=6, h=22
	' Rect 2: x=9, y=1, w=6, h=22
	' Rect 3: x=17, y=1, w=6, h=22
	
	Dim scale As Float = fSize / 24
	Dim w As Float = 6 * scale
	Dim h As Float = 22 * scale ' Max height
	
	For i = 0 To 2
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.Color = iColor ' Rects don't have border in SVG
		' Initial position
		Dim startX As Float = 0
		Select i
			Case 0: startX = 1 * scale
			Case 1: startX = 9 * scale
			Case 2: startX = 17 * scale
		End Select
		
		Dim startY As Float = 1 * scale
		
		mBase.AddView(b, fX + startX, fY + startY, w, h)
		ChildViews.Add(b)
	Next
End Sub

Private Sub CreateRing(fSize As Float, iColor As Int, fX As Float, fY As Float)
	' 2 rings.
	For i = 0 To 1
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetColorAndBorder(xui.Color_Transparent, 2dip, iColor, fSize/2)
		' Start centered, full size? Or small?
		' Animation: Scale 0->1, Fade 1->0
		mBase.AddView(b, fX, fY, fSize, fSize)
		ChildViews.Add(b)
	Next
End Sub

Private Sub CreateBall(fSize As Float, iColor As Int, fX As Float, fY As Float)
	' 1 ball.
	Dim ballSize As Float = fSize * 0.8
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.SetColorAndBorder(iColor, 0, 0, ballSize/2)
	mBase.AddView(b, fX + (fSize-ballSize)/2, fY + (fSize-ballSize)/2, ballSize, ballSize)
	ChildViews.Add(b)
End Sub

Public Sub StartAnimation
	If AnimationActive Then Return
	If mVisible = False Then Return
	If IsAttached = False Then Return
	
	AnimationActive = True
	AnimateLoop
End Sub

Public Sub StopAnimation
	AnimationActive = False
End Sub

Private Sub AnimateLoop
	Dim lastTime As Long = DateTime.Now
	' Standardize on milliseconds
	
	Do While AnimationActive
		If mVisible = False Or mBase.IsInitialized = False Then
			AnimationActive = False
			Exit
		End If
		
		Dim now As Long = DateTime.Now
		Dim delta As Long = now - lastTime
		lastTime = now
		
		' Speed factor: 100 = 1.0x, 200 = 2.0x
		Dim speedFactor As Float = mSpeed / 100.0
		If speedFactor <= 0 Then speedFactor = 1.0
		
		' We accumulate "AnimTime" based on delta * speed
		' Instead of global tick, let's pass elapsed time
		' Actually, simpler: define a global "running time" for the component
		' or just pass current system time scaled? No, restarting animation should probably reset or continue smoothly.
		' Let's use a member variable mCurrentTimeMs
		
		mCurrentTimeMs = mCurrentTimeMs + (delta * speedFactor)
		
		Select Case mLoadingStyle
			Case "spinner"
				UpdateSpinner(mCurrentTimeMs)
			Case "dots"
				UpdateDots(mCurrentTimeMs)
			Case "bars"
				UpdateBars(mCurrentTimeMs)
			Case "ring"
				UpdateRing(mCurrentTimeMs)
			Case "ball"
				UpdateBall(mCurrentTimeMs)
			Case "infinity"
				UpdateInfinity(mCurrentTimeMs)
		End Select

		Sleep(16) ' ~60fps cap
	Loop
End Sub

Private Sub UpdateSpinner(lTimeMs As Long)
	If ChildViews.Size = 0 Then Return
	Dim iv As B4XDaisySvgIcon = ChildViews.Get(0)
	
	' CSS: 
	' Rotate: dur=2s (2000ms). Linear.
	' Stroke: dur=1.5s (1500ms).
	
	' 1. Rotation
	Dim rotDur As Int = 2000
	Dim rotProgress As Float = (lTimeMs Mod rotDur) / rotDur
	iv.mBase.Rotation = rotProgress * 360
	
	' 2. Stroke Animation (Dash/Offset) requires modifying SVG content dynamically OR 
	'_using a specific Spinner implementation. 
	' The generic SVG "spinner" path in GetSvgPath includes <animate> tags which B4X SVG engine MIGHT ignore.
	' If we want to replicate it manually we need to update the SVG string.
	' For now, let's just stick to Rotation for Spinner as it's the primary effect.
	' (Implementing stroke dash animation would require regenerating SVG string every frame).
End Sub

Private Sub UpdateDots(lTimeMs As Long)
	If ChildViews.Size < 3 Then Return
	' CSS: dur=1.05s (1050ms)
	' KeyTimes: 0; 0.286; 0.571; 1
	' Values cy: 12 -> 6 -> 12 -> 12
	' Stagger: 0s, 0.1s, 0.2s
	
	Dim duration As Int = 1050
	Dim delays() As Int = Array As Int(0, 100, 200)
	
	Dim s As Float = mBase.Width / 24
	Dim baseY As Float = mBase.Height / 2 ' Center (cy=12)
	
	For i = 0 To 2
		Dim b As B4XView = ChildViews.Get(i)
		Dim t As Float = ((lTimeMs + (duration - delays(i))) Mod duration) / duration
		
		Dim valCy As Float
		' KeyTimes: 0 -> 0.286 -> 0.571 -> 1
		If t < 0.286 Then
			valCy = Interpolate(12, 6, t / 0.286)
		Else If t < 0.571 Then
			valCy = Interpolate(6, 12, (t - 0.286) / (0.571 - 0.286))
		Else
			valCy = 12
		End If
		
		' Map 12 -> Center. 6 -> Up.
		' cy=12 is center. cy=6 is top (so -6 units).
		Dim offsetUnits As Float = valCy - 12
		b.Top = baseY + (offsetUnits * s) - (b.Height/2)
	Next
End Sub

Private Sub UpdateBars(lTimeMs As Long)
	If ChildViews.Size < 3 Then Return
	' CSS: dur=.8s (800ms)
	' Stagger: 0s, -0.65s (150ms), -0.5s (300ms)
	
	Dim duration As Int = 800
	Dim delays() As Int = Array As Int(0, 150, 300)
	
	Dim s As Float = mBase.Width / 24
	Dim v0 As B4XView = ChildViews.Get(0)
	Dim contentX As Float = v0.Left - (1 * s)
	Dim contentY As Float = (mBase.Height - (24 * s)) / 2 
	
	For i = 0 To 2
		Dim b As B4XView = ChildViews.Get(i)
		Dim t As Float = ((lTimeMs + (duration - delays(i))) Mod duration) / duration
		
		Dim valY As Float
		Dim valH As Float
		Dim valO As Float
		
		' KeyTimes: 0 -> 0.938 -> 1
		Dim k1 As Float = 0.938
		
		If t < k1 Then
			Dim loc As Float = t / k1
			valY = Interpolate(1, 5, loc)
			valH = Interpolate(22, 14, loc)
			valO = Interpolate(1, 0.2, loc)
		Else
			Dim loc As Float = (t - k1) / (1 - k1)
			valY = Interpolate(5, 1, loc)
			valH = Interpolate(14, 22, loc)
			valO = Interpolate(0.2, 1, loc)
		End If
		
		b.Top = contentY + (valY * s)
		b.Height = valH * s
		anim.SetNativeAlpha(b, valO)
	Next
End Sub

Private Sub Interpolate(fFromVal As Float, fToVal As Float, fFraction As Float) As Float
	' Cubic ease-in-out: matches CSS keySplines (cubic-bezier ~0.4,0,0.2,1)
	Dim f As Float = fFraction
	If f < 0.5 Then
		f = 4 * f * f * f
	Else
		f = 1 - Power(-2 * f + 2, 3) / 2
	End If
	Return fFromVal + (fToVal - fFromVal) * f
End Sub

Private Sub UpdateRing(lTimeMs As Long)
	If ChildViews.Size < 2 Then Return
	' CSS: dur=1.8s (1800ms)
	' Stagger: 0s, -0.9s (which is +900ms effectively)
	
	Dim duration As Int = 1800
	
	UpdateRingChild(ChildViews.Get(0), lTimeMs Mod duration, duration)
	UpdateRingChild(ChildViews.Get(1), (lTimeMs + 900) Mod duration, duration)
End Sub

Private Sub UpdateRingChild(vChildView As B4XView, lTime As Long, iDuration As Int)
	Dim progress As Float = lTime / iDuration ' 0..1
	' Values r: 1 -> 20. (Width/Diameter: 2 -> 40). 
	' Values opacity: 1 -> 0.
	
	Dim sizeUnits As Float = Interpolate(2, 40, progress)
	Dim alpha As Float = Interpolate(1, 0, progress)
	
	Dim s As Float = mBase.Width / 44 ' Ring svg viewBox is 44x44!
	
	Dim size As Float = sizeUnits * s
	
	Dim cx As Float = mBase.Width / 2
	Dim cy As Float = mBase.Height / 2
	View.SetLayoutAnimated(0, cx - size/2, cy - size/2, size, size)
	View.SetColorAndBorder(xui.Color_Transparent, 2dip, mColorInt, size/2)
	anim.SetNativeAlpha(View, alpha)
End Sub

Private Sub UpdateBall(lTimeMs As Long)
	If ChildViews.Size = 0 Then Return
	Dim b As B4XView = ChildViews.Get(0)
	' CSS: dur=.8s (800ms)
	' KeyTimes: 0; 0.469; 0.5; 0.531; 1
	' cy: 5 -> 20 -> 20.5 -> 20 -> 5
	' rx: 4 -> 4 -> 4.8 -> 4 -> 4
	' ry: 4 -> 4 -> 3 -> 4 -> 4
	
	Dim duration As Int = 800
	Dim t As Float = (lTimeMs Mod duration) / duration
	
	Dim s As Float = mBase.Width / 24
	' Center
	Dim contentX As Float = (mBase.Width - (24 * s)) / 2
	Dim contentY As Float = (mBase.Height - (24 * s)) / 2
	
	Dim valCy As Float
	Dim valRx As Float
	Dim valRy As Float
	
	If t < 0.469 Then
		Dim loc As Float = t / 0.469
		valCy = Interpolate(5, 20, loc)
		valRx = 4
		valRy = 4
	Else If t < 0.5 Then
		Dim loc As Float = (t - 0.469) / (0.5 - 0.469)
		valCy = Interpolate(20, 20.5, loc)
		valRx = Interpolate(4, 4.8, loc)
		valRy = Interpolate(4, 3, loc)
	Else If t < 0.531 Then
		Dim loc As Float = (t - 0.5) / (0.531 - 0.5)
		valCy = Interpolate(20.5, 20, loc)
		valRx = Interpolate(4.8, 4, loc)
		valRy = Interpolate(3, 4, loc)
	Else
		Dim loc As Float = (t - 0.531) / (1 - 0.531)
		valCy = Interpolate(20, 5, loc)
		valRx = 4
		valRy = 4
	End If
	
	Dim cx As Float = contentX + (12 * s)
	Dim cy As Float = contentY + (valCy * s)
	Dim w As Float = valRx * 2 * s
	Dim h As Float = valRy * 2 * s
	
	b.SetLayoutAnimated(0, cx - w/2, cy - h/2, w, h)
End Sub

Private Sub UpdateInfinity(lTimeMs As Long)
	If ChildViews.Size = 0 Then Return
	Dim iv As B4XDaisySvgIcon = ChildViews.Get(0)
	
	' CSS: dur=2s (2000ms)
	' stroke-dashoffset: 0 -> 256.589
	
	Dim duration As Int = 2000
	Dim progress As Float = (lTimeMs Mod duration) / duration
	Dim offset As Float = progress * 256.589
	
	iv.SetSvgContent(GetInfinitySvg(offset))
End Sub





Public Sub getStyle As String
	Return mLoadingStyle
End Sub

Public Sub setStyle(sValue As String)
	mLoadingStyle = sValue
	UpdateLayout
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setSize(sValue As String)
	mSize = sValue
	UpdateLayout
End Sub

Public Sub getSpeed As Int
	Return mSpeed
End Sub

Public Sub setSpeed(iValue As Int)
	mSpeed = iValue
	If AnimationActive Then
		StopAnimation
		StartAnimation
	End If
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	mBase.Visible = bValue
	If bValue Then StartAnimation Else StopAnimation
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	UpdateLayout
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setTag(oTag As Object)
	mTag = oTag
	If mBase.IsInitialized Then mBase.Tag = oTag
End Sub

Public Sub getTag As Object
	Return mTag
End Sub



Private Sub GetSvgPath(sName As String) As String
	Select Case sName
		Case "spinner"
			Return "<svg width='24' height='24' stroke='currentColor' viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'><g transform-origin='center'><circle cx='12' cy='12' r='9.5' fill='none' stroke-width='3' stroke-linecap='round' stroke-dasharray='42 150'></circle></g></svg>"
		Case "infinity"
			Return "<svg xmlns='http://www.w3.org/2000/svg' stroke='currentColor' stroke-width='10' stroke-dasharray='205.271 51.318' viewBox='0 0 100 100' fill='none'><path d='M24.3 30C11.4 30 5 43.3 5 50s6.4 20 19.3 20c19.3 0 32.1-40 51.4-40C88.6 30 95 43.3 95 50s-6.4 20-19.3 20C56.4 70 43.6 30 24.3 30z' stroke-linecap='round'/></svg>"
	End Select
	Return ""
End Sub

Private Sub GetInfinitySvg(fOffset As Float) As String
	' Using locale independent formatting for float? B4X floats usually dot separated.
	Dim offStr As String = NumberFormat2(fOffset, 1, 3, 3, False)
	Return "<svg xmlns='http://www.w3.org/2000/svg' stroke='currentColor' stroke-width='10' stroke-dasharray='205.271 51.318' stroke-dashoffset='" & offStr & "' viewBox='0 0 100 100' fill='none'><path d='M24.3 30C11.4 30 5 43.3 5 50s6.4 20 19.3 20c19.3 0 32.1-40 51.4-40C88.6 30 95 43.3 95 50s-6.4 20-19.3 20C56.4 70 43.6 30 24.3 30z' stroke-linecap='round'/></svg>"
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' Sets whether the loading indicator intercepts touch events.
''' When False, touches pass through to the parent view (e.g. a list row).
''' When True, the loading indicator handles clicks normally.
Public Sub setClickable(bValue As Boolean)
	mClickable = bValue
	#If B4A
	If mBase.IsInitialized Then
		Dim joBase As JavaObject = mBase
		joBase.RunMethod("setClickable", Array(bValue))
		' Propagate to all child views recursively
		For Each v As B4XView In mBase.GetAllViewsRecursive
			Dim joV As JavaObject = v
			joV.RunMethod("setClickable", Array(bValue))
		Next
	End If
	#Else If B4J
	If mBase.IsInitialized Then mBase.Enabled = bValue
	#Else If B4i
	If mBase.IsInitialized Then mBase.Enabled = bValue
	#End If
End Sub

''' Gets whether the loading indicator is clickable.
Public Sub getClickable As Boolean
	Return mClickable
End Sub

''' Sets an explicit color override for the loading indicator.
''' Pass a color with a valid alpha channel (e.g. 0xFF000000 for opaque black).
''' Pass 0 or a fully-transparent color to revert to variant-based color resolution.
Public Sub setColor(iValue As Int)
	mColorOverride = iValue
	If mBase.IsInitialized = False Then Return
	UpdateLayout
End Sub

Public Sub getColor As Int
	Return mColorOverride
End Sub
Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
