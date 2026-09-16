B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#Event: Changed (Color As Int)

#DesignerProperty: Key: InitialColor, DisplayName: Initial Color, FieldType: Color, DefaultValue: 0xFFEF4444, Description: The starting color of the wheel.
#DesignerProperty: Key: WheelThickness, DisplayName: Wheel Thickness, FieldType: Int, DefaultValue: 24, Description: Thickness of the Hue ring in dip.
#DesignerProperty: Key: HandleSize, DisplayName: Handle Size, FieldType: Int, DefaultValue: 24, Description: The diameter of the draggable knobs in dip.
#DesignerProperty: Key: Shadow, DisplayName: Handle Shadow, FieldType: String, DefaultValue: md, List: none|xs|sm|md|lg|xl|2xl, Description: Shadow elevation for handles.
#DesignerProperty: Key: WheelReflectsSaturation, DisplayName: Reflect Saturation, FieldType: Boolean, DefaultValue: False, Description: If true, the hue ring colors reflect the selected saturation.
#DesignerProperty: Key: ShowColorIndicator, DisplayName: Show Color Indicator, FieldType: Boolean, DefaultValue: True, Description: Shows internal selected color indicator block at the bottom.
#DesignerProperty: Key: CenterOnParent, DisplayName: Center On Parent, FieldType: Boolean, DefaultValue: False, Description: If true, centers the color wheel inside its parent layout.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.

#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' UI Layers
	Private pnlHue As B4XView
	Private cvsHue As B4XCanvas
	Private HueCanvasReady As Boolean
	Private pnlSV As B4XView
	Private cvsSV As B4XCanvas
	Private SVCanvasReady As Boolean
	Private pnlIndicator As B4XView
    
	Private pnlHueHandle As B4XView
	Private pnlSVHandle As B4XView
	
	Private cvsHueHandle As B4XCanvas
	Private HueHandleCanvasReady As Boolean

	' Properties
	Private mColor As Int = 0xFFEF4444
	Private mInitialColor As Int = 0xFFEF4444
	Private mWheelThickness As Int = 24dip
	Private mHandleSize As Int = 24dip
	Private mShadow As String = "md"
	Private mVisible As Boolean = True
	Private mWheelReflectsSaturation As Boolean = False
	Private mShowColorIndicator As Boolean = True
	Private mIndicatorHeight As Int = 24dip
	Private mCenterOnParent As Boolean = False

	' HSV State
	Private mHueVal As Float = 0     ' 0 to 360
	Private mSatVal As Float = 1     ' 0 to 1
	Private mValVal As Float = 1     ' 0 to 1
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

''' <summary>
''' Programmatic creation.
''' </summary>
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

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' 1. Hue Disk Host
	Dim p1 As Panel
	p1.Initialize("pnlHue")
	pnlHue = p1
	pnlHue.Color = xui.Color_Transparent
	mBase.AddView(pnlHue, 0, 0, mBase.Width, mBase.Height)
    
	' 2. SV Inner Box Host
	Dim p2 As Panel
	p2.Initialize("pnlSV")
	pnlSV = p2
	mBase.AddView(pnlSV, 0, 0, 1dip, 1dip)

	' 3. Color Indicator Block
	Dim p3 As Panel
	p3.Initialize("pnlIndicator")
	pnlIndicator = p3
	mBase.AddView(pnlIndicator, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(mProps)
	mBase.Visible = mVisible

	' 3. Draggable Handles
	Dim h1 As Panel, h2 As Panel
	
	h1.Initialize("")
	pnlHueHandle = h1
	pnlHueHandle.Enabled = False
	pnlHueHandle.Color = xui.Color_Transparent
	
	h2.Initialize("")
	pnlSVHandle = h2
	pnlSVHandle.Enabled = False
    
	mBase.AddView(pnlHueHandle, 0, 0, mHandleSize, mHandleSize)
	pnlSV.AddView(pnlSVHandle, 0, 0, mHandleSize, mHandleSize)

	' Convert initial color to HSV
	RGBToHSV(mColor)
	mInitialColor = mColor
    
	Refresh
End Sub
Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	mColor = B4XDaisyVariants.GetPropColor(mProps, "InitialColor", mColor)
	mWheelThickness = B4XDaisyVariants.GetPropInt(mProps, "WheelThickness", 24) * 1dip
	mHandleSize = B4XDaisyVariants.GetPropInt(mProps, "HandleSize", 24) * 1dip
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
	mWheelReflectsSaturation = B4XDaisyVariants.GetPropBool(mProps, "WheelReflectsSaturation", False)
	mShowColorIndicator = B4XDaisyVariants.GetPropBool(mProps, "ShowColorIndicator", True)
	mCenterOnParent = B4XDaisyVariants.GetPropBool(mProps, "CenterOnParent", False)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", True)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("InitialColor", mColor)
	props.Put("WheelThickness", mWheelThickness / 1dip)
	props.Put("HandleSize", mHandleSize / 1dip)
	props.Put("Shadow", mShadow)
	props.Put("WheelReflectsSaturation", mWheelReflectsSaturation)
	props.Put("ShowColorIndicator", mShowColorIndicator)
	props.Put("CenterOnParent", mCenterOnParent)
	props.Put("Visible", mVisible)
	Return props
End Sub
#End Region

#Region Core APIs
''' <summary>
''' Gets the current Color as an Int.
''' </summary>
Public Sub getColor As Int
	Return mColor
End Sub

''' <summary>
''' Sets the color programmatically and updates the UI.
''' </summary>
Public Sub setColor(iNewColor As Int)
	mColor = iNewColor
	RGBToHSV(mColor)
	mInitialColor = iNewColor
	If mWheelReflectsSaturation Then
		DrawHueDisk
	End If
	UpdateVisuals
	DrawSVSquare
End Sub

''' <summary>
''' Gets the current HSV values as a Float Array [Hue, Saturation, Value] (Hue 0-360, Sat 0-100, Val 0-100).
''' </summary>
Public Sub getHSV As Float()
	Return Array As Float(mHueVal, mSatVal * 100, mValVal * 100)
End Sub

''' <summary>
''' Sets the HSV values as a Float Array [Hue, Saturation, Value] (Hue 0-360, Sat 0-100, Val 0-100).
''' </summary>
Public Sub setHSV(oHsv() As Float)
	If oHsv.Length >= 3 Then
		mHueVal = Max(0, Min(360, oHsv(0)))
		mSatVal = Max(0, Min(100, oHsv(1))) / 100
		mValVal = Max(0, Min(100, oHsv(2))) / 100
		mColor = HSVToRGB(mHueVal, mSatVal, mValVal)
		mInitialColor = mColor
		If mWheelReflectsSaturation Then
			DrawHueDisk
		End If
		UpdateVisuals
		DrawSVSquare
	End If
End Sub

''' <summary>
''' Sets the color via independent HSV values programmatically (Hue 0-360, Saturation 0-1, Value 0-1).
''' </summary>
Public Sub setHSV3(fHue As Float, fSaturation As Float, fValue As Float)
	mHueVal = Max(0, Min(360, fHue))
	mSatVal = Max(0, Min(1, fSaturation))
	mValVal = Max(0, Min(1, fValue))
	mColor = HSVToRGB(mHueVal, mSatVal, mValVal)
	mInitialColor = mColor
	If mWheelReflectsSaturation Then
		DrawHueDisk
	End If
	UpdateVisuals
	DrawSVSquare
End Sub

''' <summary>
''' Gets the current HSL values (Hue 0-360, Sat 0-100, Lightness 0-100).
''' </summary>
Public Sub getHSL As Float()
	Return RGBToHSL(mColor)
End Sub

''' <summary>
''' Sets the color via HSL values (Hue 0-360, Sat 0-100, Lightness 0-100).
''' </summary>
Public Sub setHSL(oHsl() As Float)
	If oHsl.Length >= 3 Then
		setColor(HSLToRGB(oHsl(0), oHsl(1), oHsl(2)))
	End If
End Sub

''' <summary>
''' Gets the current RGB values as an Int Array [Red, Green, Blue] (each 0 to 255).
''' </summary>
Public Sub getRGB As Int()
	Dim r As Int = Bit.And(Bit.ShiftRight(mColor, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(mColor, 8), 0xFF)
	Dim b As Int = Bit.And(mColor, 0xFF)
	Return Array As Int(r, g, b)
End Sub

''' <summary>
''' Sets the color via RGB values [Red, Green, Blue] (each 0 to 255).
''' </summary>
Public Sub setRGB(oRgb() As Int)
	If oRgb.Length >= 3 Then
		setColor(xui.Color_RGB(oRgb(0), oRgb(1), oRgb(2)))
	End If
End Sub

''' <summary>
''' Gets the current color as a lowercase Hex string starting with # (e.g. #ff0000).
''' </summary>
Public Sub getHex As String
	Return ColorToHex(mColor)
End Sub

''' <summary>
''' Sets the color programmatically via Hex string.
''' </summary>
Public Sub setHex(sHexStr As String)
	setColor(HexToColor(sHexStr))
End Sub

''' <summary>
''' Gets the outer wheel diameter (width/height of the control).
''' </summary>
Public Sub getWheelDiameter As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

''' <summary>
''' Sets the overall diameter of the color wheel.
''' </summary>
Public Sub setWheelDiameter(iDiameter As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, iDiameter, iDiameter)
		Base_Resize(iDiameter, iDiameter)
	End If
End Sub

''' <summary>
''' Gets whether the outer Hue ring reflects current Saturation selection.
''' </summary>
Public Sub getWheelReflectsSaturation As Boolean
	Return mWheelReflectsSaturation
End Sub

''' <summary>
''' Sets whether the outer Hue ring reflects current Saturation selection.
''' </summary>
Public Sub setWheelReflectsSaturation(bValue As Boolean)
	mWheelReflectsSaturation = bValue
	DrawHueDisk
	UpdateVisuals
End Sub

Public Sub setShowColorIndicator(bValue As Boolean)
	mShowColorIndicator = bValue
	Refresh
End Sub

Public Sub getShowColorIndicator As Boolean
	Return mShowColorIndicator
End Sub

Public Sub setIndicatorHeight(iHeightDip As Int)
	mIndicatorHeight = iHeightDip
	Refresh
End Sub

Public Sub getIndicatorHeight As Int
	Return mIndicatorHeight
End Sub

''' <summary>
''' Sets the starting initial reference color in memory.
''' </summary>
Public Sub setInitialColor(iValue As Int)
	mInitialColor = iValue
End Sub

''' <summary>
''' Gets the starting initial reference color.
''' </summary>
Public Sub getInitialColor As Int
	Return mInitialColor
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub setWheelThickness(iThickness As Int)
	mWheelThickness = iThickness
	Refresh
End Sub

Public Sub setCenterOnParent(bValue As Boolean)
	mCenterOnParent = bValue
	Refresh
End Sub

Public Sub getCenterOnParent As Boolean
	Return mCenterOnParent
End Sub

Public Sub getWheelThickness As Int
	Return mWheelThickness
End Sub

Public Sub setHandleSize(iSize As Int)
	mHandleSize = iSize
	If pnlHueHandle.IsInitialized Then
		pnlHueHandle.SetLayoutAnimated(0, pnlHueHandle.Left, pnlHueHandle.Top, mHandleSize, mHandleSize)
	End If
	If pnlSVHandle.IsInitialized Then
		pnlSVHandle.SetLayoutAnimated(0, pnlSVHandle.Left, pnlSVHandle.Top, mHandleSize, mHandleSize)
	End If
	Refresh
End Sub

Public Sub getHandleSize As Int
	Return mHandleSize
End Sub

Public Sub setHandleDiameter(iSize As Int)
	setHandleSize(iSize)
End Sub

Public Sub getHandleDiameter As Int
	Return getHandleSize
End Sub

#Region Math & Color Conversions
Private Sub GetHueFromColor(iC As Int) As Float
	Dim r As Float = Bit.And(Bit.ShiftRight(iC, 16), 0xFF) / 255
	Dim g As Float = Bit.And(Bit.ShiftRight(iC, 8), 0xFF) / 255
	Dim b As Float = Bit.And(iC, 0xFF) / 255
    
	Dim cmax As Float = Max(r, Max(g, b))
	Dim cmin As Float = Min(r, Min(g, b))
	Dim diff As Float = cmax - cmin
    
	Dim h As Float = 0
	If diff = 0 Then
		h = 0
	Else If cmax = r Then
		h = 60 * (((g - b) / diff) Mod 6)
	Else If cmax = g Then
		h = 60 * (((b - r) / diff) + 2)
	Else
		h = 60 * (((r - g) / diff) + 4)
	End If
	If h < 0 Then h = h + 360
	Return h
End Sub

Private Sub ColorToHex(iC As Int) As String
	Dim r As Int = Bit.And(Bit.ShiftRight(iC, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iC, 8), 0xFF)
	Dim b As Int = Bit.And(iC, 0xFF)
	Return "#" & IntToHex2(r) & IntToHex2(g) & IntToHex2(b)
End Sub

Private Sub IntToHex2(iValue As Int) As String
	Dim hexChars As String = "0123456789abcdef"
	Dim high As Int = Bit.ShiftRight(iValue, 4)
	Dim low As Int = Bit.And(iValue, 0x0F)
	Return hexChars.CharAt(high) & hexChars.CharAt(low)
End Sub

Private Sub HexToColor(sHexStr As String) As Int
	Dim cleanHex As String = sHexStr.Replace("#", "").Trim.ToLowerCase
	If cleanHex.Length = 3 Then
		Dim c1 As String = cleanHex.CharAt(0)
		Dim c2 As String = cleanHex.CharAt(1)
		Dim c3 As String = cleanHex.CharAt(2)
		cleanHex = c1 & c1 & c2 & c2 & c3 & c3
	End If
	If cleanHex.Length <> 6 Then Return 0xFFFF0000
    
	Dim r As Int = HexToInt(cleanHex.SubString2(0, 2))
	Dim g As Int = HexToInt(cleanHex.SubString2(2, 4))
	Dim b As Int = HexToInt(cleanHex.SubString2(4, 6))
	Return xui.Color_RGB(r, g, b)
End Sub

Private Sub HexToInt(sHexVal As String) As Int
	Dim hexChars As String = "0123456789abcdef"
	Dim res As Int = 0
	For i = 0 To sHexVal.Length - 1
		Dim c As String = sHexVal.CharAt(i)
		Dim val As Int = hexChars.IndexOf(c)
		If val < 0 Then val = 0
		res = res * 16 + val
	Next
	Return res
End Sub

Private Sub RGBToHSL(iC As Int) As Float()
	Dim r As Float = Bit.And(Bit.ShiftRight(iC, 16), 0xFF) / 255
	Dim g As Float = Bit.And(Bit.ShiftRight(iC, 8), 0xFF) / 255
	Dim b As Float = Bit.And(iC, 0xFF) / 255
    
	Dim cmax As Float = Max(r, Max(g, b))
	Dim cmin As Float = Min(r, Min(g, b))
	Dim diff As Float = cmax - cmin
    
	Dim h As Float = 0
	Dim s As Float = 0
	Dim l As Float = (cmax + cmin) / 2
    
	If diff = 0 Then
		h = 0
		s = 0
	Else
		If l < 0.5 Then
			s = diff / (cmax + cmin)
		Else
			s = diff / (2 - cmax - cmin)
		End If
        
		If cmax = r Then
			h = 60 * (((g - b) / diff) Mod 6)
		Else If cmax = g Then
			h = 60 * (((b - r) / diff) + 2)
		Else
			h = 60 * (((r - g) / diff) + 4)
		End If
	End If
    
	If h < 0 Then h = h + 360
	Return Array As Float(h, s * 100, l * 100)
End Sub

Private Sub HSLToRGB(fH As Float, fS As Float, fL As Float) As Int
	fS = fS / 100
	fL = fL / 100
    
	Dim c As Float = (1 - Abs(2 * fL - 1)) * fS
	Dim x As Float = c * (1 - Abs(((fH / 60) Mod 2) - 1))
	Dim m As Float = fL - c / 2
    
	Dim r1 As Float = 0
	Dim g1 As Float = 0
	Dim b1 As Float = 0
	Dim i As Int = Floor(fH / 60) Mod 6
	Select i
		Case 0: r1 = c: g1 = x: b1 = 0
		Case 1: r1 = x: g1 = c: b1 = 0
		Case 2: r1 = 0: g1 = c: b1 = x
		Case 3: r1 = 0: g1 = x: b1 = c
		Case 4: r1 = x: g1 = 0: b1 = c
		Case 5: r1 = c: g1 = 0: b1 = x
	End Select
    
	Return xui.Color_RGB((r1 + m) * 255, (g1 + m) * 255, (b1 + m) * 255)
End Sub
#End Region
#End Region

#Region Rendering & Canvas Logic
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
    
	If mCenterOnParent And mBase.Parent.IsInitialized Then
		Dim parentW As Float = mBase.Parent.Width
		Dim parentH As Float = mBase.Parent.Height
		Dim newLeft As Float = (parentW - w) / 2
		Dim newTop As Float = (parentH - h) / 2
		mBase.Left = newLeft
		mBase.Top = newTop
	End If
    
	Dim indGap As Int = 8dip
	Dim indH As Int = mIndicatorHeight
	Dim wheelH As Int = h
	If mShowColorIndicator And pnlIndicator.IsInitialized Then
		wheelH = Max(1dip, h - indH - indGap)
	End If

	' Layout Hue disk to fill the upper area
	pnlHue.SetLayoutAnimated(0, 0, 0, w, wheelH)
	If HueCanvasReady Then cvsHue.Release
	cvsHue.Initialize(pnlHue)
	HueCanvasReady = True
    
	' Layout SV Box in the center - optimized size for visual balance
	Dim ringCenterRadius As Float = (Min(w, wheelH) / 2) - (mWheelThickness / 2) - 2dip
	Dim innerRadius As Float = ringCenterRadius - (mWheelThickness / 2)
	Dim boxSide As Int = Max(1dip, innerRadius * 1.414) ' Square inside the circle
	pnlSV.SetLayoutAnimated(0, (w - boxSide) / 2, (wheelH - boxSide) / 2, boxSide, boxSide)
	If SVCanvasReady Then cvsSV.Release
	cvsSV.Initialize(pnlSV)
	SVCanvasReady = True
	
	' Layout handles and initialize handle canvases
	pnlHueHandle.SetLayoutAnimated(0, pnlHueHandle.Left, pnlHueHandle.Top, mHandleSize, mHandleSize)
	pnlSVHandle.SetLayoutAnimated(0, pnlSVHandle.Left, pnlSVHandle.Top, mHandleSize, mHandleSize)
	
	If HueHandleCanvasReady Then cvsHueHandle.Release
	cvsHueHandle.Initialize(pnlHueHandle)
	HueHandleCanvasReady = True
    
	' Layout internal color indicator panel at the bottom
	If pnlIndicator.IsInitialized Then
		If mShowColorIndicator Then
			pnlIndicator.Visible = True
			Dim padX As Int = 8dip
			Dim indW As Int = Max(1dip, w - (padX * 2))
			Dim indLeft As Int = padX
			Dim indTop As Int = wheelH + indGap
			pnlIndicator.SetLayoutAnimated(0, indLeft, indTop, indW, indH)
		Else
			pnlIndicator.Visible = False
		End If
	End If

	DrawHueDisk
	DrawSVSquare
	UpdateVisuals
	inResize = False
End Sub

Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub UpdateVisuals
	If mBase.IsInitialized = False Then Return
    
	' Draw active Hue handle (white outline circle with a small dot of current color)
	If HueHandleCanvasReady Then
		cvsHueHandle.ClearRect(cvsHueHandle.TargetRect)
		Dim cx As Float = pnlHueHandle.Width / 2
		Dim cy As Float = pnlHueHandle.Height / 2
		cvsHueHandle.DrawCircle(cx, cy, cx - 1dip, xui.Color_White, False, 2dip)
		
		Dim dotColor As Int = HSVToRGB(mHueVal, 1, 1)
		cvsHueHandle.DrawCircle(cx, cy, cx / 3, dotColor, True, 0)
		cvsHueHandle.Invalidate
	End If

	' Style SV handle (solid circle of current color, with a 2dip white border)
	pnlSVHandle.SetColorAndBorder(mColor, 2dip, xui.Color_White, pnlSVHandle.Width / 2)
    
	B4XDaisyVariants.ApplyElevation(pnlHueHandle, mShadow)
	B4XDaisyVariants.ApplyElevation(pnlSVHandle, mShadow)
    
	If pnlIndicator.IsInitialized And mShowColorIndicator Then
		Dim borderColor As Int = B4XDaisyVariants.AlphaColor(xui.Color_Black, 0.2)
		pnlIndicator.SetColorAndBorder(mColor, 1dip, borderColor, 6dip)
	End If

	PositionHandles
End Sub

Private Sub DrawHueDisk
	If HueCanvasReady = False Then Return
	cvsHue.ClearRect(cvsHue.TargetRect)
	Dim cx As Float = pnlHue.Width / 2
	Dim cy As Float = pnlHue.Height / 2
	
	' Sizing parameters for the inner and outer radius of the hollow ring
	Dim centerR As Float = Min(cx, cy) - (mWheelThickness / 2) - 2dip
	Dim R_outer As Float = centerR + mWheelThickness / 2
	Dim R_inner As Float = centerR - mWheelThickness / 2
    
	Dim sat As Float = 100
	Dim lightness As Float = 50
	If mWheelReflectsSaturation Then
		Dim hsl() As Float = RGBToHSL(mColor)
		sat = hsl(1)
		lightness = hsl(2)
	End If
    
	' Draw a hollow circular Hue spectrum ring using filled quadrilateral segments to prevent edge ridges
	For i = 0 To 359 Step 1
		Dim angle1 As Float = i
		Dim angle2 As Float = i + 1.1 ' Slightly overlap to prevent anti-aliasing gaps between segments
        
		Dim ox1 As Float = cx + R_outer * CosD(angle1)
		Dim oy1 As Float = cy + R_outer * SinD(angle1)
		Dim ix1 As Float = cx + R_inner * CosD(angle1)
		Dim iy1 As Float = cy + R_inner * SinD(angle1)
        
		Dim ox2 As Float = cx + R_outer * CosD(angle2)
		Dim oy2 As Float = cy + R_outer * SinD(angle2)
		Dim ix2 As Float = cx + R_inner * CosD(angle2)
		Dim iy2 As Float = cy + R_inner * SinD(angle2)
        
		Dim col As Int = HSLToRGB((i + 90) Mod 360, sat, lightness)
        
		Dim p As B4XPath
		p.Initialize(ox1, oy1)
		p.LineTo(ox2, oy2)
		p.LineTo(ix2, iy2)
		p.LineTo(ix1, iy1)
		p.LineTo(ox1, oy1)
		cvsHue.DrawPath(p, col, True, 0)
	Next
	
	cvsHue.Invalidate
End Sub

Private Sub DrawSVSquare
	If SVCanvasReady = False Then Return
	cvsSV.ClearRect(cvsSV.TargetRect)
    
	Dim w As Float = pnlSV.Width
	Dim h As Float = pnlSV.Height
	Dim stepSize As Int = 2
    
	Dim hueColor As Int = HSVToRGB(mHueVal, 1, 1)
    
	' 1. Draw horizontal saturation gradient (White to Hue)
	For x = 0 To w Step stepSize
		Dim ratio As Float = x / w
		Dim col As Int = BlendColors(hueColor, xui.Color_White, ratio)
		Dim r As B4XRect
		r.Initialize(x, 0, x + stepSize, h)
		cvsSV.DrawRect(r, col, True, 0)
	Next
    
	' 2. Draw vertical value gradient using black alpha blending (Transparent to Black)
	For y = 0 To h Step stepSize
		Dim ratio As Float = y / h
		Dim alpha As Int = ratio * 255
		Dim col As Int = xui.Color_ARGB(alpha, 0, 0, 0)
		Dim r As B4XRect
		r.Initialize(0, y, w, y + stepSize)
		cvsSV.DrawRect(r, col, True, 0)
	Next
    
	cvsSV.Invalidate
End Sub

Private Sub PositionHandles
	If pnlHueHandle.IsInitialized = False Or pnlSVHandle.IsInitialized = False Then Return
    
	' Position Hue Handle (relative to parent mBase)
	Dim cx As Float = pnlHue.Width / 2
	Dim cy As Float = pnlHue.Height / 2
	Dim r As Float = Min(cx, cy) - (mWheelThickness / 2) - 2dip
	
	Dim angle As Float = (mHueVal - 90 + 360) Mod 360
	Dim hRad As Float = angle * cPI / 180
    
	pnlHueHandle.Left = cx + (r * Cos(hRad)) - (pnlHueHandle.Width / 2)
	pnlHueHandle.Top = cy + (r * Sin(hRad)) - (pnlHueHandle.Height / 2)
    
	' Position SV Handle (relative to parent pnlSV coordinates)
	Dim svX As Float = mSatVal * pnlSV.Width
	Dim svY As Float = (1 - mValVal) * pnlSV.Height
	pnlSVHandle.Left = svX - (pnlSVHandle.Width / 2)
	pnlSVHandle.Top = svY - (pnlSVHandle.Height / 2)
End Sub
#End Region

#Region Touch Handlers
Private Sub pnlHue_Touch (iAction As Int, fX As Float, fY As Float)
	Dim cx As Float = pnlHue.Width / 2
	Dim cy As Float = pnlHue.Height / 2
	Dim dx As Float = fX - cx
	Dim dy As Float = fY - cy
	Dim dist As Float = Sqrt(dx*dx + dy*dy)
    
	Dim outerR As Float = Min(cx, cy) - (mWheelThickness / 2) - 2dip
	Dim innerR As Float = outerR - (mWheelThickness / 2)
    
	' Radius filter to only register touches close to the Hue ring
	Dim touchPadding As Float = 15dip
	If dist < (innerR - touchPadding) Or dist > (outerR + mWheelThickness/2 + touchPadding) Then
		Return
	End If

	#If B4A
	B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
	#End If
    
	' Calculate angle for Hue
	Dim angle As Float = ATan2D(dy, dx)
	If angle < 0 Then angle = angle + 360
	mHueVal = (angle + 90) Mod 360
    
	mColor = HSVToRGB(mHueVal, mSatVal, mValVal)
	DrawSVSquare
	UpdateVisuals
	RaiseChanged
End Sub

Private Sub pnlSV_Touch (iAction As Int, fX As Float, fY As Float)
	#If B4A
	B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
	#End If
	Dim cx As Float = Max(0, Min(fX, pnlSV.Width))
	Dim cy As Float = Max(0, Min(fY, pnlSV.Height))
    
	mSatVal = cx / pnlSV.Width
	mValVal = 1 - (cy / pnlSV.Height)
    
	mColor = HSVToRGB(mHueVal, mSatVal, mValVal)
	If mWheelReflectsSaturation Then
		DrawHueDisk
	End If
	UpdateVisuals
	RaiseChanged
End Sub

Private Sub RaiseChanged
	If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
		CallSub2(mCallBack, mEventName & "_Changed", mColor)
	End If
End Sub


#End Region

#Region HSV / RGB Math Helpers
Private Sub HSVToRGB(fH As Float, fS As Float, fV As Float) As Int
	Dim r, g, b As Float
	Dim i As Int = Floor(fH / 60)
	Dim f As Float = (fH / 60) - i
	Dim p As Float = fV * (1 - fS)
	Dim q As Float = fV * (1 - f * fS)
	Dim t As Float = fV * (1 - (1 - f) * fS)
    
	Select i Mod 6
		Case 0: r = fV: g = t: b = p
		Case 1: r = q: g = fV: b = p
		Case 2: r = p: g = fV: b = t
		Case 3: r = p: g = q: b = fV
		Case 4: r = t: g = p: b = fV
		Case 5: r = fV: g = p: b = q
	End Select
	
	Return xui.Color_RGB(r * 255, g * 255, b * 255)
End Sub

Private Sub RGBToHSV(iC As Int)
	Dim r As Float = Bit.And(Bit.ShiftRight(iC, 16), 0xFF) / 255
	Dim g As Float = Bit.And(Bit.ShiftRight(iC, 8), 0xFF) / 255
	Dim b As Float = Bit.And(iC, 0xFF) / 255
    
	Dim cmax As Float = Max(r, Max(g, b))
	Dim cmin As Float = Min(r, Min(g, b))
	Dim diff As Float = cmax - cmin
    
	mValVal = cmax
	If cmax = 0 Then
		mSatVal = 0
	Else
		mSatVal = diff / cmax
	End If
    
	If diff = 0 Then
		mHueVal = 0
	Else If cmax = r Then
		mHueVal = 60 * (((g - b) / diff) Mod 6)
	Else If cmax = g Then
		mHueVal = 60 * (((b - r) / diff) + 2)
	Else
		mHueVal = 60 * (((r - g) / diff) + 4)
	End If
	If mHueVal < 0 Then mHueVal = mHueVal + 360
End Sub

Private Sub BlendColors(iC1 As Int, iC2 As Int, fRatio As Float) As Int
	Dim r1 As Int = Bit.And(Bit.ShiftRight(iC1, 16), 0xFF)
	Dim g1 As Int = Bit.And(Bit.ShiftRight(iC1, 8), 0xFF)
	Dim b1 As Int = Bit.And(iC1, 0xFF)
    
	Dim r2 As Int = Bit.And(Bit.ShiftRight(iC2, 16), 0xFF)
	Dim g2 As Int = Bit.And(Bit.ShiftRight(iC2, 8), 0xFF)
	Dim b2 As Int = Bit.And(iC2, 0xFF)
    
	Return xui.Color_RGB(r2 + (r1 - r2) * fRatio, g2 + (g1 - g2) * fRatio, b2 + (b1 - b2) * fRatio)
End Sub
#End Region

#Region B4XView Layout Wrapper Methods
''' <summary>
''' Attaches the component to an existing target view, completely filling its dimensions.
''' </summary>
Public Sub AttachTo(vTarget As B4XView)
	AddToParent(vTarget, 0, 0, vTarget.Width, vTarget.Height)
End Sub

''' <summary>
''' Adds the component to a parent B4XView with given parameters.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
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

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
End Sub

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Width = iValue
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Height = iValue
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
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

Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub
#End Region
Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setShadow(sValue As String)
    mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setVisible(bValue As Boolean)
    mVisible = bValue
    mBase.Visible = bValue
End Sub

Public Sub Release
    Try
        cvsHue.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyColorWheel.Release: " & LastException.Message)
    End Try
    Try
        cvsSV.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyColorWheel.Release: " & LastException.Message)
    End Try
    Try
        cvsHueHandle.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyColorWheel.Release: " & LastException.Message)
    End Try
    If pnlHue.IsInitialized Then pnlHue.RemoveViewFromParent
    If pnlSV.IsInitialized Then pnlSV.RemoveViewFromParent
    If pnlIndicator.IsInitialized Then pnlIndicator.RemoveViewFromParent
    If pnlHueHandle.IsInitialized Then pnlHueHandle.RemoveViewFromParent
    If pnlSVHandle.IsInitialized Then pnlSVHandle.RemoveViewFromParent
    mCallBack = Null
End Sub
