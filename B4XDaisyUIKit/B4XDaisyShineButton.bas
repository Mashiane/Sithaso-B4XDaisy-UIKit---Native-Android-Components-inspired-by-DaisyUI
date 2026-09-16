B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' B4XDaisyShineButton - DaisyUI Animated Interactive Shine/Burst Toggle Button
'
' Wraps ChadCSong/ShineButton to provide animated like/heart/favorite toggle buttons
' with multi-color particle bursts, pure File.DirAssets asset loading (no res/raw copying required),
' and full DaisyUI size scale (xs=28dip, sm=36dip, md=48dip, lg=64dip, xl=80dip).

#Event: CheckChanged (Checked As Boolean)
#Event: Click

#DesignerProperty: Key: Shape, DisplayName: Shape, FieldType: String, DefaultValue: heart, List: heart|like|smile|star|svg, Description: Built-in shape or custom SVG asset
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: DaisyUI size token (xs=28dip, sm=36dip, md=48dip, lg=64dip, xl=80dip)
#DesignerProperty: Key: CustomSize, DisplayName: Custom Size, FieldType: Int, DefaultValue: 0, Description: Custom width/height in dip (overrides Size token when > 0)
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: primary, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: Semantic color variant for checked state
#DesignerProperty: Key: SvgAsset, DisplayName: SVG Asset, FieldType: String, DefaultValue:, Description: SVG file name from File.DirAssets (used when Shape=svg or to override shape)
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False, Description: Initial checked state
#DesignerProperty: Key: BtnColor, DisplayName: Unchecked Color, FieldType: Color, DefaultValue: 0xFF9CA3AF, Description: Unchecked icon color
#DesignerProperty: Key: BtnFillColor, DisplayName: Fill Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override checked fill color (0 = auto from Variant)
#DesignerProperty: Key: BigShineColor, DisplayName: Big Shine Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Main burst particle color (0 = auto)
#DesignerProperty: Key: SmallShineColor, DisplayName: Small Shine Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Secondary sparkle color (0 = auto)
#DesignerProperty: Key: AllowRandomColor, DisplayName: Random Particle Colors, FieldType: Boolean, DefaultValue: True, Description: Enables multi-colored burst particles
#DesignerProperty: Key: EnableFlashing, DisplayName: Enable Flashing, FieldType: Boolean, DefaultValue: False, Description: Flashes random colors during burst
#DesignerProperty: Key: AnimDuration, DisplayName: Animation Duration, FieldType: Int, DefaultValue: 1500, Description: Particle burst duration in ms
#DesignerProperty: Key: ClickAnimDuration, DisplayName: Click Duration, FieldType: Int, DefaultValue: 200, Description: Button press bounce duration in ms
#DesignerProperty: Key: ShineCount, DisplayName: Particle Count, FieldType: Int, DefaultValue: 7, Description: Number of starburst particles
#DesignerProperty: Key: ShineTurnAngle, DisplayName: Turn Angle, FieldType: Float, DefaultValue: 20, Description: Rotation angle for flying particles
#DesignerProperty: Key: ShineDistanceMultiple, DisplayName: Distance Multiple, FieldType: Float, DefaultValue: 1.5, Description: Particle spread radius multiplier
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide component
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: Enable or disable touch events

#IgnoreWarnings:12,9

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	#If B4A
	Private nativeBtn As ShineButton
	#End If

	' Properties
	Private mShape As String = "heart"
	Private mSize As String = "md"
	Private mCustomSize As Int = 0
	Private mVariant As String = "primary"
	Private mSvgAsset As String = ""
	Private mChecked As Boolean = False
	Private mBtnColor As Int = 0xFF9CA3AF
	Private mBtnFillColor As Int = xui.Color_Transparent
	Private mBigShineColor As Int = xui.Color_Transparent
	Private mSmallShineColor As Int = xui.Color_Transparent
	Private mAllowRandomColor As Boolean = True
	Private mEnableFlashing As Boolean = False
	Private mAnimDuration As Int = 1500
	Private mClickAnimDuration As Int = 200
	Private mShineCount As Int = 7
	Private mShineTurnAngle As Float = 20
	Private mShineDistanceMultiple As Float = 1.5
	Private mVisible As Boolean = True
	Private mClickable As Boolean = True
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me

	ApplyDesignerProps(mProps)
	BuildNativeView
End Sub

Public Sub CreateView(iSizeDip As Int) As B4XView
	If iSizeDip <= 0 Then iSizeDip = ResolveControlSizeDip
	Dim p As Panel
	p.Initialize("mBase")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iSizeDip, iSizeDip)
	Dim dummy As Label
	dummy.Initialize("")
	DesignerCreateView(b, dummy, BuildRuntimeProps)
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		DesignerCreateView(p, Null, BuildRuntimeProps)
	End If

	Dim controlSize As Int = ResolveControlSizeDip
	If iWidth <= 0 Then iWidth = controlSize
	If iHeight <= 0 Then iHeight = controlSize
	iWidth = Max(iWidth, controlSize)
	iHeight = Max(iHeight, controlSize)

	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Base_Resize(mBase.Width, mBase.Height)
	Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
	Return CreateMap( _
	"Shape": mShape, _
	"Size": mSize, _
	"CustomSize": mCustomSize, _
	"Variant": mVariant, _
	"SvgAsset": mSvgAsset, _
	"Checked": mChecked, _
	"BtnColor": mBtnColor, _
	"BtnFillColor": mBtnFillColor, _
	"BigShineColor": mBigShineColor, _
	"SmallShineColor": mSmallShineColor, _
	"AllowRandomColor": mAllowRandomColor, _
	"EnableFlashing": mEnableFlashing, _
	"AnimDuration": mAnimDuration, _
	"ClickAnimDuration": mClickAnimDuration, _
	"ShineCount": mShineCount, _
	"ShineTurnAngle": mShineTurnAngle, _
	"ShineDistanceMultiple": mShineDistanceMultiple, _
	"Visible": mVisible, _
	"Clickable": mClickable)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mShape = B4XDaisyVariants.GetPropString(mProps, "Shape", mShape).ToLowerCase
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mCustomSize = B4XDaisyVariants.GetPropInt(mProps, "CustomSize", mCustomSize)
	mVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant)
	mSvgAsset = B4XDaisyVariants.GetPropString(mProps, "SvgAsset", mSvgAsset)
	mChecked = B4XDaisyVariants.GetPropBool(mProps, "Checked", mChecked)
	mBtnColor = B4XDaisyVariants.GetPropColor(mProps, "BtnColor", mBtnColor)
	mBtnFillColor = B4XDaisyVariants.GetPropColor(mProps, "BtnFillColor", mBtnFillColor)
	mBigShineColor = B4XDaisyVariants.GetPropColor(mProps, "BigShineColor", mBigShineColor)
	mSmallShineColor = B4XDaisyVariants.GetPropColor(mProps, "SmallShineColor", mSmallShineColor)
	mAllowRandomColor = B4XDaisyVariants.GetPropBool(mProps, "AllowRandomColor", mAllowRandomColor)
	mEnableFlashing = B4XDaisyVariants.GetPropBool(mProps, "EnableFlashing", mEnableFlashing)
	mAnimDuration = B4XDaisyVariants.GetPropInt(mProps, "AnimDuration", mAnimDuration)
	mClickAnimDuration = B4XDaisyVariants.GetPropInt(mProps, "ClickAnimDuration", mClickAnimDuration)
	mShineCount = B4XDaisyVariants.GetPropInt(mProps, "ShineCount", mShineCount)
	mShineTurnAngle = B4XDaisyVariants.GetPropFloat(mProps, "ShineTurnAngle", mShineTurnAngle)
	mShineDistanceMultiple = B4XDaisyVariants.GetPropFloat(mProps, "ShineDistanceMultiple", mShineDistanceMultiple)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mClickable = B4XDaisyVariants.GetPropBool(mProps, "Clickable", mClickable)
End Sub

Private Sub BuildNativeView
	#If B4A
	Dim sz As Int = ResolveControlSizeDip
	nativeBtn.Initialize("nativeBtn")
	mBase.AddView(nativeBtn, 0, 0, sz, sz)

	ApplyAllProperties
	#End If
End Sub

Public Sub ApplyAllProperties
	#If B4A
	If nativeBtn.IsInitialized = False Then Return

	' Colors
	Dim fillColor As Int = ResolveFillColor
	Dim bigColor As Int = mBigShineColor
	If bigColor = xui.Color_Transparent Or bigColor = 0 Then bigColor = fillColor
	Dim smallColor As Int = mSmallShineColor
	If smallColor = xui.Color_Transparent Or smallColor = 0 Then smallColor = xui.Color_RGB(251, 191, 36) ' Gold

	nativeBtn.BtnColor = mBtnColor
	nativeBtn.BtnFillColor = fillColor
	nativeBtn.BigShineColor = bigColor
	nativeBtn.SmallShineColor = smallColor
	nativeBtn.AllowRandomColor = mAllowRandomColor
	nativeBtn.EnableFlashing = mEnableFlashing
	nativeBtn.AnimDuration = mAnimDuration
	nativeBtn.ClickAnimDuration = mClickAnimDuration
	nativeBtn.ShineCount = mShineCount
	nativeBtn.ShineTurnAngle = mShineTurnAngle
	nativeBtn.ShineDistanceMultiple = mShineDistanceMultiple

	' Shape
	ApplyShape

	' Checked state
	nativeBtn.Checked = mChecked
	mBase.Visible = mVisible
	#End If
End Sub

Private Sub ApplyShape
	#If B4A
	If nativeBtn.IsInitialized = False Then Return

	If mSvgAsset.Trim.Length > 0 Then
		If File.Exists(File.DirAssets, mSvgAsset.Trim) Then
			Dim svgContent As String = File.ReadString(File.DirAssets, mSvgAsset.Trim)
			SetSvgContent(svgContent)
			Return
		End If
	End If

	' Direct loading from File.DirAssets (PNGs first as bundled by user, then SVGs)
	Dim shapeName As String = mShape.ToLowerCase
	Dim pngCandidate As String = ""
	Dim svgCandidate As String = ""

	Select Case shapeName
		Case "heart"
			pngCandidate = "heart.png"
			svgCandidate = "heart-solid.svg"
		Case "like", "thumbs-up", "thumb-up"
			pngCandidate = "like.png"
		Case "smile", "face-smile"
			pngCandidate = "smile.png"
			svgCandidate = "face-smile-solid.svg"
		Case "star"
			pngCandidate = "star.png"
		Case Else
			pngCandidate = shapeName & ".png"
			svgCandidate = shapeName & ".svg"
	End Select

	If pngCandidate.Length > 0 And File.Exists(File.DirAssets, pngCandidate) Then
		Dim bmp As Bitmap = LoadBitmap(File.DirAssets, pngCandidate)
		nativeBtn.ShapeBitmap = bmp
	Else If svgCandidate.Length > 0 And File.Exists(File.DirAssets, svgCandidate) Then
		Dim svgContent As String = File.ReadString(File.DirAssets, svgCandidate)
		SetSvgContent(svgContent)
	Else
		' Fallback to raw resource identifier
		nativeBtn.ShapeResource = shapeName
	End If
	#End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True

	Dim sz As Int = ResolveControlSizeDip
	If mBase.Width <> sz Or mBase.Height <> sz Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, sz, sz)
	End If

	#If B4A
	If nativeBtn.IsInitialized Then
		nativeBtn.SetLayoutAnimated(0, 0, 0, sz, sz)
	End If
	#End If

	inResize = False
End Sub

' - Size Resolution -

Private Sub ResolveControlSizeDip As Int
	If mCustomSize > 0 Then Return mCustomSize * 1dip
	Select Case B4XDaisyVariants.NormalizeSize(mSize)
		Case "xs"
			Return 28dip
		Case "sm"
			Return 36dip
		Case "md"
			Return 48dip
		Case "lg"
			Return 64dip
		Case "xl"
			Return 80dip
		Case Else
			Return 48dip
	End Select
End Sub

Private Sub ResolveFillColor As Int
	If mBtnFillColor <> xui.Color_Transparent And mBtnFillColor <> 0 Then Return mBtnFillColor

	Select Case B4XDaisyVariants.NormalizeVariant(mVariant)
		Case "primary"
			Return xui.Color_RGB(59, 130, 246) ' Blue
		Case "secondary"
			Return xui.Color_RGB(168, 85, 247) ' Purple
		Case "accent"
			Return xui.Color_RGB(236, 72, 153) ' Pink
		Case "info"
			Return xui.Color_RGB(6, 182, 212) ' Cyan
		Case "success"
			Return xui.Color_RGB(34, 197, 94) ' Green
		Case "warning"
			Return xui.Color_RGB(234, 179, 8) ' Yellow
		Case "error"
			Return xui.Color_RGB(239, 68, 68) ' Red
		Case "neutral"
			Return xui.Color_RGB(75, 85, 99) ' Gray
		Case Else
			' Default based on shape
			Select Case mShape.ToLowerCase
				Case "like"
					Return xui.Color_RGB(59, 130, 246)
				Case "smile"
					Return xui.Color_RGB(234, 179, 8)
				Case "star"
					Return xui.Color_RGB(34, 197, 94)
				Case Else
					Return xui.Color_RGB(239, 68, 68)
			End Select
	End Select
End Sub

' - SVG and Shape Methods -

Public Sub SetSvgAsset(sFileName As String)
	SetSvg(File.DirAssets, sFileName)
End Sub

Public Sub SetSvg(sDir As String, sFileName As String)
	#If B4A
	If File.Exists(sDir, sFileName) = False Then Return
	mSvgAsset = sFileName
	Dim svgContent As String = File.ReadString(sDir, sFileName)
	SetSvgContent(svgContent)
	#End If
End Sub

Public Sub SetSvgContent(sSvgMarkup As String)
	#If B4A
	If nativeBtn.IsInitialized = False Then Return
	Dim sz As Int = ResolveControlSizeDip
	Dim icon As B4XDaisySvgIcon
	icon.Initialize(Me, "")
	Dim jo As JavaObject = icon
	Dim o As Object = jo.RunMethod("nativeRenderSvgToBitmap", Array(sSvgMarkup, sz, sz, xui.Color_White, False))
	If o <> Null Then
		Dim bmp As Bitmap = o
		nativeBtn.ShapeBitmap = bmp
	End If
	#End If
End Sub

Public Sub SetShapeBitmap(Bmp As Bitmap)
	#If B4A
	If nativeBtn.IsInitialized Then
		nativeBtn.ShapeBitmap = Bmp
	End If
	#End If
End Sub

Public Sub SetShapeResource(sResourceName As String)
	#If B4A
	mShape = sResourceName.ToLowerCase
	If nativeBtn.IsInitialized Then
		nativeBtn.ShapeResource = sResourceName
	End If
	#End If
End Sub

' - Animation and State Control -

Public Sub TriggerShine
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.showAnim
	#End If
End Sub

Public Sub ShowAnim
	TriggerShine
End Sub

Public Sub setChecked(bValue As Boolean)
	mChecked = bValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.Checked = bValue
	#End If
End Sub

Public Sub getChecked As Boolean
	Return mChecked
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setVariant(sValue As String)
	mVariant = sValue
	ApplyAllProperties
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setShape(sValue As String)
	mShape = sValue.ToLowerCase
	mSvgAsset = ""
	ApplyShape
End Sub

Public Sub getSvgAsset As String
	Return mSvgAsset
End Sub

Public Sub getShape As String
	Return mShape
End Sub

Public Sub setBtnColor(iColor As Int)
	mBtnColor = iColor
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.BtnColor = iColor
	#End If
End Sub

Public Sub getBtnColor As Int
	Return mBtnColor
End Sub

Public Sub setBtnFillColor(iColor As Int)
	mBtnFillColor = iColor
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.BtnFillColor = iColor
	#End If
End Sub

Public Sub getBtnFillColor As Int
	Return mBtnFillColor
End Sub


Public Sub setAllowRandomColor(bValue As Boolean)
	mAllowRandomColor = bValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.AllowRandomColor = bValue
	#End If
End Sub

Public Sub getAllowRandomColor As Boolean
	Return mAllowRandomColor
End Sub

Public Sub setEnableFlashing(bValue As Boolean)
	mEnableFlashing = bValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.EnableFlashing = bValue
	#End If
End Sub

Public Sub getEnableFlashing As Boolean
	Return mEnableFlashing
End Sub

Public Sub setBigShineColor(iColor As Int)
	mBigShineColor = iColor
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.BigShineColor = iColor
	#End If
End Sub

Public Sub getBigShineColor As Int
	Return mBigShineColor
End Sub

Public Sub setSmallShineColor(iColor As Int)
	mSmallShineColor = iColor
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.SmallShineColor = iColor
	#End If
End Sub

Public Sub getSmallShineColor As Int
	Return mSmallShineColor
End Sub

Public Sub setAnimDuration(iValue As Int)
	mAnimDuration = iValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.AnimDuration = iValue
	#End If
End Sub

Public Sub getAnimDuration As Int
	Return mAnimDuration
End Sub

Public Sub setClickAnimDuration(iValue As Int)
	mClickAnimDuration = iValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.ClickAnimDuration = iValue
	#End If
End Sub

Public Sub getClickAnimDuration As Int
	Return mClickAnimDuration
End Sub

Public Sub setShineCount(iValue As Int)
	mShineCount = iValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.ShineCount = iValue
	#End If
End Sub

Public Sub getShineCount As Int
	Return mShineCount
End Sub

Public Sub setShineTurnAngle(fValue As Float)
	mShineTurnAngle = fValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.ShineTurnAngle = fValue
	#End If
End Sub

Public Sub getShineTurnAngle As Float
	Return mShineTurnAngle
End Sub

Public Sub setShineDistanceMultiple(fValue As Float)
	mShineDistanceMultiple = fValue
	#If B4A
	If nativeBtn.IsInitialized Then nativeBtn.ShineDistanceMultiple = fValue
	#End If
End Sub

Public Sub getShineDistanceMultiple As Float
	Return mShineDistanceMultiple
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

#If B4A
Private Sub nativeBtn_button_clicked
	If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	End If
End Sub

Private Sub nativeBtn_check_changed (bCheck As Boolean)
	mChecked = bCheck
	If xui.SubExists(mCallBack, mEventName & "_CheckChanged", 1) Then
		CallSub2(mCallBack, mEventName & "_CheckChanged", bCheck)
	End If
End Sub
#End If

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

#Region Base Properties
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

Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub
#End Region
