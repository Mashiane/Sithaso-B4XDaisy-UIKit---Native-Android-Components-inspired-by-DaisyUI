B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
#IgnoreWarnings:12,9
#DesignerProperty: Key: ResizeMode, DisplayName: Resize Mode, FieldType: String, List: FIT|FILL|FILL_NO_DISTORTIONS|FILL_WIDTH|FILL_HEIGHT|NONE, DefaultValue: FIT
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: CornersRadius, DisplayName: Corners Radius, FieldType: Int, DefaultValue: 0
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFAAAAAA
Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object
	Private iv As B4XView
	Private mResizeMode As String
	Private mRounded As Boolean = False
	Private mBitmap As B4XBitmap
	Public mBackgroundColor As Int
	Private mCornersRadius As Int
	Private inResize As Boolean = False
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mEventName = sEventName
	mCallBack = oCallback
	mResizeMode = "FIT"
	mRounded = False
	mBackgroundColor = 0 ' Transparent by default when dynamically instantiated
	mCornersRadius = 0
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

Public Sub AddToParentAt(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Return AddToParent(vParent, iLeft, iTop, iWidth, iHeight)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("ResizeMode", mResizeMode)
	props.Put("Rounded", mRounded)
	props.Put("CornersRadius", mCornersRadius)
	props.Put("BackgroundColor", mBackgroundColor)
	Return props
End Sub

'Base type must be Object
Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
    Tag = mBase.Tag
    mBase.Tag = Me 
	Dim iiv As ImageView
	iiv.Initialize("")
	iv = iiv
'	If Props.ContainsKey("Rounded") Then mRounded = Props.Get("Rounded")
'	If Props.ContainsKey("ResizeMode") Then mResizeMode = Props.Get("ResizeMode")
'	If Props.ContainsKey("BackgroundColor") Then mBackgroundColor = xui.PaintOrColorToColor(Props.Get("BackgroundColor"))
'	mCornersRadius = DipToCurrent(Props.GetDefault("CornersRadius", 0))
	ApplyDesignerProps(mProps)
	mBase.AddView(iv, 0, 0, mBase.Width, mBase.Height)
	Update
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mRounded = B4XDaisyVariants.GetPropBool(mProps, "Rounded", mRounded)
	mResizeMode = B4XDaisyVariants.GetPropString(mProps, "ResizeMode", mResizeMode)
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mCornersRadius = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "CornersRadius", 0))
End Sub

Public Sub Base_Resize (dWidth As Double, dHeight As Double)
	If inResize Then Return
	inResize = True
	Update
	inResize = False
End Sub

'Gets or sets whether to make the rounded image.
Public Sub getRounded As Boolean
	Return mRounded
End Sub

Public Sub setRounded (bValue As Boolean)
	If bValue = mRounded Then Return
	mRounded = bValue
	UpdateClip
End Sub

'Gets or sets whether to make the rounded image.
Public Sub getCornersRadius As Int
	Return mCornersRadius
End Sub

Public Sub setCornersRadius (iValue As Int)
	mCornersRadius = iValue
	UpdateClip
End Sub

' Alias methods for backward compatibility with B4XDaisyAvatar
Public Sub getRoundedImage As Boolean
	Return mRounded
End Sub

Public Sub setRoundedImage (bValue As Boolean)
	If bValue = mRounded Then Return
	mRounded = bValue
	UpdateClip
End Sub

'Gets or sets the background color of the image container.
Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mBackgroundColor = iValue
    Update
End Sub

'Gets or sets the resize mode. One of the following values: FIT, FILL, FILL_NO_DISTORTIONS, FILL_WIDTH, FILL_HEIGHT, NONE
'All modes except of FILL respect the image ratio. In most cases it is better not to use FILL.
Public Sub getResizeMode As String
	Return mResizeMode
End Sub

Public Sub setResizeMode(sValue As String)
	If sValue = mResizeMode Then Return
	mResizeMode = sValue
	Update
End Sub

Public Sub Update
	If mBitmap.IsInitialized = False Then Return
	UpdateClip
	Dim ImageViewWidth, ImageViewHeight As Float
	Dim bmpRatio As Float = mBitmap.Width / mBitmap.Height
	Select mResizeMode
		Case "FILL"
			ImageViewWidth = mBase.Width
			ImageViewHeight = mBase.Height
		Case "FIT"
			Dim r As Float = Min(mBase.Width / mBitmap.Width, mBase.Height / mBitmap.Height)
			ImageViewWidth = mBitmap.Width * r
			ImageViewHeight = mBitmap.Height * r		
		Case "FILL_WIDTH"
			ImageViewWidth = mBase.Width
			ImageViewHeight = ImageViewWidth / bmpRatio
		Case "FILL_HEIGHT"
			ImageViewHeight = mBase.Height
			ImageViewWidth = ImageViewHeight * bmpRatio
		Case "FILL_NO_DISTORTIONS"
			Dim r As Float = Max(mBase.Width / mBitmap.Width, mBase.Height / mBitmap.Height)
			ImageViewWidth = mBitmap.Width * r
			ImageViewHeight = mBitmap.Height * r
		Case "NONE"
			ImageViewWidth = mBitmap.Width
			ImageViewHeight = mBitmap.Height
		Case Else
			If B4XDaisyApp.DebugLogs Then Log("Invalid resize mode: "  & mResizeMode)
	End Select
	iv.SetLayoutAnimated(0, Round(mBase.Width / 2 - ImageViewWidth / 2), Round(mBase.Height / 2 - ImageViewHeight / 2), Round(ImageViewWidth), Round(ImageViewHeight))
End Sub

'Loads a bitmap. It uses LoadBitmapSample in B4A to avoid loading larger than necessary images.
Public Sub Load (sDir As String, sFileName As String)
	#if B4A
	setBitmap(LoadBitmapSample(sDir, sFileName, mBase.Width, mBase.Height))
	#Else
	setBitmap(xui.LoadBitmap(sDir, sFileName))
	#End If
End Sub

'Removes the bitmap.
Public Sub Clear
	mBitmap = Null
	iv.SetBitmap(Null)
End Sub

Public Sub setBitmap(bmpBmp As B4XBitmap)
	mBitmap = bmpBmp
	XUIViewsUtils.SetBitmapAndFill(iv, bmpBmp)
	Update
End Sub

Public Sub getBitmap As B4XBitmap
	Return mBitmap
End Sub


Private Sub UpdateClip
	If mRounded Then
		mBase.SetColorAndBorder(mBackgroundColor, 0, 0, Min(mBase.Width / 2, mBase.Height / 2))
	Else
		mBase.SetColorAndBorder(mBackgroundColor, 0, 0, mCornersRadius)
	End If
#if B4J
	Dim jo As JavaObject = mBase
	Dim shape As JavaObject
	If mRounded Then
		Dim radius As Double = Min(mBase.Width / 2, mBase.Height / 2)
		Dim cx As Double = mBase.Width / 2
		Dim cy As Double = mBase.Height / 2
		shape.InitializeNewInstance("javafx.scene.shape.Circle", Array(cx, cy, radius))
	Else
		Dim cx As Double = mBase.Width
		Dim cy As Double = mBase.Height
		shape.InitializeNewInstance("javafx.scene.shape.Rectangle", Array(cx, cy))
		If mCornersRadius > 0 Then
			Dim d As Double = mCornersRadius
			shape.RunMethod("setArcHeight", Array(d))
			shape.RunMethod("setArcWidth", Array(d))
		End If
	End If
	jo.RunMethod("setClip", Array(shape))
#else if B4A
	Dim jo As JavaObject = mBase
	jo.RunMethod("setClipToOutline", Array(mRounded Or mCornersRadius > 0))
#end if
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

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
