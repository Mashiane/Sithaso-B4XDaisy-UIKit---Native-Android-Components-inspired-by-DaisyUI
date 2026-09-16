B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@

#Event: TagTap (Tag As String)
#Event: TagLongPress (Tag As String)
' DrawTag delivers a Map with keys: Canvas (B4XCanvas), X, Y (Float), Alpha (Int), Index (Int).
' Raised per tag per frame so the caller can custom-render each tag. Built via CallSub2
' because B4X dynamic dispatch caps at 3 args.
#Event: DrawTag (Info As Map)

#DesignerProperty: Key: Items, DisplayName: Items (| list), FieldType: String, DefaultValue: Android|iOS|Flutter|React|Vue|Svelte|Kotlin|Swift|Java|Dart|Node|Python|Rust|Go|PHP|Ruby, Description: Pipe-separated tag labels. Max 200.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF1F2937, Description: Color of the tag labels.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: Float, DefaultValue: 14, Description: Font size in dip.
#DesignerProperty: Key: Radius, DisplayName: Sphere Radius, FieldType: Float, DefaultValue: 1.5, Description: World radius of the sphere. Larger value = smaller visual sphere. 1.0 - 10.0.
#DesignerProperty: Key: Sensitivity, DisplayName: Touch Sensitivity, FieldType: Int, DefaultValue: 11, Description: Higher = slower drag rotation. 1 - 100.
#DesignerProperty: Key: CircularAvatars, DisplayName: Circular Avatars, FieldType: Boolean, DefaultValue: True, Description: Crop avatar images into circles with optional borders.
#DesignerProperty: Key: AvatarBorderColor, DisplayName: Avatar Border Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Border ring color for circular avatars.
#DesignerProperty: Key: AvatarBorderWidth, DisplayName: Avatar Border Width, FieldType: Float, DefaultValue: 2, Description: Border stroke width in dip.
#DesignerProperty: Key: AutoRotate, DisplayName: Auto Rotate, FieldType: Boolean, DefaultValue: True, Description: Spin the sphere continuously when idle.
#DesignerProperty: Key: Easing, DisplayName: Depth Easing, FieldType: String, DefaultValue: easeOut, List: none|easeIn|easeOut|easeInExpo|easeOutExpo|inQuint|outQuint|reverseQuint, Description: Alpha curve based on depth (back of sphere fades).
#DesignerProperty: Key: RotateOnTouch, DisplayName: Rotate On Touch, FieldType: Boolean, DefaultValue: True, Description: Allow drag to rotate the sphere.
#DesignerProperty: Key: AutoSpeed, DisplayName: Auto Speed, FieldType: Float, DefaultValue: 0.4, Description: Auto-rotation speed (radians per frame per axis at 60fps). Try 0.1 - 1.0.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide the sphere.

#IgnoreWarnings:12, 9

#Region Variables
Sub Class_Globals
	Type TagPoint (x As Float, y As Float, z As Float)
	Private xui As XUI
	Public mBase As B4XView
	Private cvs As B4XCanvas
	Private tmr As Timer
	Private mCallBack As Object
	Private mEventName As String

	Private mItems As List
	Private mBitmaps As List
	Private mImageWidth As Float = 36dip
	Private mImageHeight As Float = 36dip
	Private mCircularAvatars As Boolean = True
	Private mAvatarBorderColor As Int = 0xFFFFFFFF
	Private mAvatarBorderWidth As Float = 2dip
	Private mTextColor As Int = 0xFF1F2937
	Private mTextSize As Float = 14
	Private mRadius As Float = 1.5
	Private mSensitivity As Int = 11
	Private mAutoRotate As Boolean = True
	Private mEasing As String = "easeOut"
	Private mRotateOnTouch As Boolean = True
	Private mAutoSpeed As Float = 0.4
	Private mVisible As Boolean = True

	Private mTags() As TagPoint
	Private mCount As Int
	Private mW As Float
	Private mH As Float
	Private mCx As Float
	Private mCy As Float
	Private mProjDist As Float
	Private mRadiansPerPx As Float
	Private mFont As B4XFont
	Private mBaselineOffset As Float
	Private mHasCustomDraw As Boolean
	' ponytail: reused per-frame to avoid Map allocation churn at 60fps x N tags.
	Private mDrawInfo As Map

	Private mDownTime As Long
	Private mDownX As Float
	Private mDownY As Float
	Private mLastX As Float
	Private mLastY As Float
	Private mIsDragging As Boolean
	Private mLongPressFired As Boolean
	Private tmrLongPress As Timer
	Private tmrFling As Timer
	Private mFlingVX As Float
	Private mFlingVY As Float
End Sub
#End Region

#Region Init
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	mBase = xui.CreatePanel("mBase")
	mBase.SetLayoutAnimated(0, 0, 0, 300dip, 300dip)
	mItems.Initialize
	mBitmaps.Initialize
	mBase.Tag = Me
	cvs.Initialize(mBase)
	RebuildFont
	InitTimers
	mRadiansPerPx = cPI / 90.0 / mSensitivity
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If mBase.IsInitialized = False Then Return mBase
	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Base_Resize(iWidth, iHeight)
	Return mBase
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, CreateMap( _
		"Items": "", _
		"TextColor": mTextColor, _
		"TextSize": mTextSize, _
		"Radius": mRadius, _
		"Sensitivity": mSensitivity, _
		"AutoRotate": mAutoRotate, _
		"Easing": mEasing, _
		"RotateOnTouch": mRotateOnTouch, _
		"AutoSpeed": mAutoSpeed, _
		"Visible": mVisible))
	Return mBase
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBase.Tag = Me
	cvs.Initialize(mBase)
	ParseItems(mProps.GetDefault("Items", ""))
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mTextSize = B4XDaisyVariants.GetPropFloat(mProps, "TextSize", mTextSize)
	mRadius = Max(1.0, Min(10.0, B4XDaisyVariants.GetPropFloat(mProps, "Radius", mRadius)))
	mSensitivity = Max(1, Min(100, B4XDaisyVariants.GetPropInt(mProps, "Sensitivity", mSensitivity)))
	mAutoRotate = B4XDaisyVariants.GetPropBool(mProps, "AutoRotate", mAutoRotate)
	mEasing = B4XDaisyVariants.GetPropString(mProps, "Easing", mEasing).ToLowerCase
	mRotateOnTouch = B4XDaisyVariants.GetPropBool(mProps, "RotateOnTouch", mRotateOnTouch)
	mAutoSpeed = B4XDaisyVariants.GetPropFloat(mProps, "AutoSpeed", mAutoSpeed)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	InitTimers
	RebuildFont
	mRadiansPerPx = cPI / 90.0 / mSensitivity
	Distribute
	mBase.Visible = mVisible
	If mVisible Then StartAutoLoop
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub InitTimers
	tmr.Initialize("tmrFrame", 16)
	tmrLongPress.Initialize("tmrLong", 500)
	tmrFling.Initialize("tmrFling", 16)
	mDrawInfo.Initialize
End Sub

Private Sub RebuildFont
	mFont = xui.CreateDefaultFont(mTextSize)
	' ponytail: B4XFont exposes no baseline accessor; visual half-ascent is a
	' good-enough vertical centering knob for tag labels.
	mBaselineOffset = mTextSize * 0.35
End Sub
#End Region

#Region Public API
Public Sub setItems(lstTags As List)
	mItems.Initialize
	If lstTags.IsInitialized Then
		For i = 0 To lstTags.Size - 1
			Dim s As String = lstTags.Get(i)
			If s <> "" Then mItems.Add(s)
		Next
	End If
	Distribute
End Sub

Public Sub getItems As List
	Return mItems
End Sub

Public Sub setBitmaps(lstBitmaps As List)
	mBitmaps.Initialize
	If lstBitmaps.IsInitialized Then
		For i = 0 To lstBitmaps.Size - 1
			mBitmaps.Add(lstBitmaps.Get(i))
		Next
	End If
	Distribute
End Sub

Public Sub setBitmaps2(lstBitmaps As List, fWidthDip As Float, fHeightDip As Float)
	mImageWidth = fWidthDip
	mImageHeight = fHeightDip
	setBitmaps(lstBitmaps)
End Sub

Public Sub getBitmaps As List
	Return mBitmaps
End Sub

Public Sub setImageSize(fWidthDip As Float, fHeightDip As Float)
	mImageWidth = fWidthDip
	mImageHeight = fHeightDip
	Redraw
End Sub

Public Sub getImageWidth As Float
	Return mImageWidth
End Sub

Public Sub getImageHeight As Float
	Return mImageHeight
End Sub

Public Sub setCircularAvatars(bValue As Boolean)
	mCircularAvatars = bValue
	Redraw
End Sub

Public Sub getCircularAvatars As Boolean
	Return mCircularAvatars
End Sub

Public Sub setAvatarBorderColor(iValue As Int)
	mAvatarBorderColor = iValue
	Redraw
End Sub

Public Sub getAvatarBorderColor As Int
	Return mAvatarBorderColor
End Sub

Public Sub setAvatarBorderWidth(fValue As Float)
	mAvatarBorderWidth = fValue
	Redraw
End Sub

Public Sub getAvatarBorderWidth As Float
	Return mAvatarBorderWidth
End Sub

Public Sub getCount As Int
	Return mCount
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	Redraw
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setTextSize(fValue As Float)
	mTextSize = fValue
	RebuildFont
	Redraw
End Sub

Public Sub getTextSize As Float
	Return mTextSize
End Sub

Public Sub setRadius(fValue As Float)
	mRadius = Max(1.0, Min(10.0, fValue))
	Distribute
End Sub

Public Sub getRadius As Float
	Return mRadius
End Sub

Public Sub setSensitivity(iValue As Int)
	mSensitivity = Max(1, Min(100, iValue))
	mRadiansPerPx = cPI / 90.0 / mSensitivity
End Sub

Public Sub getSensitivity As Int
	Return mSensitivity
End Sub

Public Sub setAutoRotate(bValue As Boolean)
	mAutoRotate = bValue
	If mAutoRotate Then StartAutoLoop Else StopAutoLoop
End Sub

Public Sub getAutoRotate As Boolean
	Return mAutoRotate
End Sub

Public Sub setEasing(sValue As String)
	mEasing = sValue.ToLowerCase
	Redraw
End Sub

Public Sub getEasing As String
	Return mEasing
End Sub

Public Sub setRotateOnTouch(bValue As Boolean)
	mRotateOnTouch = bValue
End Sub

Public Sub getRotateOnTouch As Boolean
	Return mRotateOnTouch
End Sub

Public Sub setAutoSpeed(fValue As Float)
	mAutoSpeed = fValue
End Sub

Public Sub getAutoSpeed As Float
	Return mAutoSpeed
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	mBase.Visible = bValue
	If bValue Then StartAutoLoop Else StopAutoLoop
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub AddRotation(fDeltaX As Float, fDeltaY As Float)
	ApplyDelta(fDeltaX, fDeltaY)
	Redraw
End Sub

Public Sub addTag(sTag As String)
	mItems.Add(sTag)
	Distribute
End Sub

Public Sub addTagsAt(iStartIndex As Int, lstTags As List)
	If lstTags.IsInitialized = False Or lstTags.Size = 0 Then Return
	For i = 0 To lstTags.Size - 1
		mItems.Add(lstTags.Get(i))
	Next
	Distribute
End Sub

Public Sub removeTagAt(iIndex As Int) As Boolean
	If iIndex < 0 Or iIndex >= mItems.Size Then Return False
	mItems.RemoveAt(iIndex)
	Distribute
	Return True
End Sub

Public Sub removeTag(sTag As String) As Boolean
	Dim idx As Int = mItems.IndexOf(sTag)
	If idx < 0 Then Return False
	Return removeTagAt(idx)
End Sub

Public Sub clearTags
	mItems.Clear
	Distribute
End Sub
#End Region

#Region Layout
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If dWidth <= 0 Or dHeight <= 0 Then Return
	mW = dWidth
	mH = dHeight
	mCx = dWidth / 2
	mCy = dHeight / 2
	mProjDist = Min(dWidth, dHeight) * 0.4
	cvs.Resize(dWidth, dHeight)
	Redraw
End Sub
#End Region

#Region 3D Math
Private Sub Distribute
	If mBitmaps.IsInitialized And mBitmaps.Size > 0 Then
		mCount = mBitmaps.Size
	Else
		mCount = mItems.Size
	End If
	If mCount = 0 Then
		Dim empty() As TagPoint
		mTags = empty
		Redraw
		Return
	End If
	Dim arr(mCount) As TagPoint
	Dim offset As Float = 2.0 / mCount
	Dim increment As Float = cPI * (3 - Sqrt(5))
	For i = 0 To mCount - 1
		Dim t As TagPoint
		t.Initialize
		Dim yy As Float = (i * offset) - 1 + (offset / 2)
		Dim rr As Float = Sqrt(Max(0, 1 - yy * yy))
		Dim phi As Float = i * increment
		t.x = Cos(phi) * rr
		t.y = yy
		t.z = Sin(phi) * rr
		arr(i) = t
	Next
	mTags = arr
	mHasCustomDraw = (mCallBack <> Null) And SubExists(mCallBack, mEventName & "_DrawTag")
	Redraw
End Sub

Private Sub ApplyDelta(fDeltaX As Float, fDeltaY As Float)
	If mCount = 0 Then Return
	Dim rx As Float = fDeltaY * mRadiansPerPx
	Dim ry As Float = fDeltaX * mRadiansPerPx
	For i = 0 To mCount - 1
		Dim t As TagPoint = mTags(i)
		Dim y0 As Float = t.y
		t.y = y0 * Cos(rx) - t.z * Sin(rx)
		t.z = y0 * Sin(rx) + t.z * Cos(rx)
		Dim x0 As Float = t.x
		t.x = x0 * Cos(ry) - t.z * Sin(ry)
		t.z = x0 * Sin(ry) + t.z * Cos(ry)
		mTags(i) = t
	Next
End Sub

Private Sub ZSortIndices As Int()
	Dim idx(mCount) As Int
	If mCount = 0 Then Return idx
	For i = 0 To mCount - 1
		idx(i) = i
	Next
	For i = 1 To mCount - 1
		Dim j As Int = i
		Do While j > 0
			If mTags(idx(j)).z < mTags(idx(j - 1)).z Then
				Dim tmp As Int = idx(j)
				idx(j) = idx(j - 1)
				idx(j - 1) = tmp
				j = j - 1
			Else
				Exit
			End If
		Loop
	Next
	Return idx
End Sub

Private Sub ProjectX(t As TagPoint) As Float
	Dim denom As Float = mRadius - t.z
	If denom <= 0 Then denom = 0.0001
	Return (mProjDist * t.x) / denom + mCx
End Sub

Private Sub ProjectY(t As TagPoint) As Float
	Dim denom As Float = mRadius - t.z
	If denom <= 0 Then denom = 0.0001
	Return (mProjDist * t.y) / denom + mCy
End Sub

Private Sub DepthAlpha(t As TagPoint) As Int
	If mEasing = "none" Then Return 255
	Dim t01 As Float = (t.z + 1) / 2
	Dim e As Float = Ease(mEasing, t01)
	If e <> e Then Return 30
	Return Max(30, Min(255, Round(30 + 225 * e)))
End Sub
#End Region

#Region Easing
Private Sub Ease(sName As String, fT As Float) As Float
	Select sName
		Case "easein"
			Return Power(fT, 3)
		Case "easeout"
			Dim f As Float = fT - 1
			Return 1 + Power(f, 3)
		Case "easeinexpo"
			If fT <= 0 Then Return 0
			Return Power(2, 10 * (fT - 1))
		Case "easeoutexpo"
			If fT >= 1 Then Return 1
			Return 1 - Power(2, -10 * fT)
		Case "inquint"
			Return Power(fT, 5)
		Case "outquint"
			Dim f2 As Float = fT - 1
			Return 1 + Power(f2, 5)
		Case "reversequint"
			Return 1 - Power(fT, 5)
		Case Else
			Return 1
	End Select
End Sub
#End Region

#Region Render
Public Sub Redraw
	If mCount = 0 Or mW <= 0 Or mH <= 0 Then Return
	cvs.ClearRect(cvs.TargetRect)
	Dim idx() As Int = ZSortIndices
	For k = 0 To idx.Length - 1
		Dim i As Int = idx(k)
		Dim t As TagPoint = mTags(i)
		Dim sx As Float = ProjectX(t)
		Dim sy As Float = ProjectY(t)
		If sx < -mTextSize * 2 Or sx > mW + mTextSize * 2 Then Continue
		If sy < -mTextSize * 2 Or sy > mH + mTextSize * 2 Then Continue
		Dim a As Int = DepthAlpha(t)
		If a <= 0 Then Continue
		If mHasCustomDraw Then
			mDrawInfo.Put("Canvas", cvs)
			mDrawInfo.Put("X", sx)
			mDrawInfo.Put("Y", sy)
			mDrawInfo.Put("Alpha", a)
			mDrawInfo.Put("Index", i)
			CallSub2(mCallBack, mEventName & "_DrawTag", mDrawInfo)
		Else If mBitmaps.IsInitialized And mBitmaps.Size > 0 Then
			Dim bmp As B4XBitmap = mBitmaps.Get(i Mod mBitmaps.Size)
			Dim scaleFactor As Float = 0.4 + 0.6 * (a / 255.0)
			Dim sw As Float = mImageWidth * scaleFactor
			Dim sh As Float = mImageHeight * scaleFactor
			Dim r As B4XRect
			r.Initialize(sx - sw / 2, sy - sh / 2, sx + sw / 2, sy + sh / 2)
			If mCircularAvatars Then
				Dim path As B4XPath
				path.InitializeOval(r)
				cvs.ClipPath(path)
				cvs.DrawBitmap(bmp, r)
				cvs.RemoveClip
				If mAvatarBorderWidth > 0 Then
					Dim borderCol As Int = Bit.Or(Bit.ShiftLeft(a, 24), Bit.And(mAvatarBorderColor, 0x00FFFFFF))
					cvs.DrawCircle(sx, sy, sw / 2, borderCol, False, mAvatarBorderWidth * scaleFactor)
				End If
			Else
				cvs.DrawBitmap(bmp, r)
			End If
		Else
			Dim col As Int = Bit.Or(Bit.ShiftLeft(a, 24), Bit.And(mTextColor, 0x00FFFFFF))
			Dim label As String = ""
			If mItems.IsInitialized And i < mItems.Size Then label = mItems.Get(i)
			cvs.DrawText(label, sx, sy + mBaselineOffset, mFont, col, "CENTER")
		End If
	Next
	cvs.Invalidate
End Sub
#End Region

#Region Touch


Private Sub mBase_Touch(iAction As Int, fX As Float, fY As Float)
	#If B4A
	B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
	#End If
	If Not(mRotateOnTouch) Then Return
	Select iAction
		Case mBase.TOUCH_ACTION_DOWN
			StopFling
			mDownTime = DateTime.Now
			mDownX = fX
			mDownY = fY
			mLastX = fX
			mLastY = fY
			mIsDragging = False
			mLongPressFired = False
			tmrLongPress.Enabled = True
		Case mBase.TOUCH_ACTION_MOVE
			Dim dx As Float = fX - mLastX
			Dim dy As Float = fY - mLastY
			If Not(mIsDragging) Then
				If Sqrt(Power(fX - mDownX, 2) + Power(fY - mDownY, 2)) > 8 Then
					mIsDragging = True
					tmrLongPress.Enabled = False
				End If
			End If
			If mIsDragging Then
				ApplyDelta(dx, dy)
				mLastX = fX
				mLastY = fY
				Redraw
			End If
		Case mBase.TOUCH_ACTION_UP
			tmrLongPress.Enabled = False
			If mIsDragging Then
				StartFling(fX - mLastX, fY - mLastY)
			Else
				If Not(mLongPressFired) And (DateTime.Now - mDownTime) < 500 Then
					HandleTap(fX, fY)
				End If
			End If
			mIsDragging = False
		Case Else ' system cancel / other: stop timers, drop drag state
			tmrLongPress.Enabled = False
			mIsDragging = False
	End Select
End Sub

Private Sub tmrLong_Tick
	tmrLongPress.Enabled = False
	mLongPressFired = True
	HandleLongPress(mDownX, mDownY)
End Sub

Private Sub HandleTap(fX As Float, fY As Float)
	Dim idx As Int = HitTest(fX, fY)
	If idx >= 0 And mCallBack <> Null And SubExists(mCallBack, mEventName & "_TagTap") Then
		CallSub2(mCallBack, mEventName & "_TagTap", mItems.Get(idx))
	End If
End Sub

Private Sub HandleLongPress(fX As Float, fY As Float)
	Dim idx As Int = HitTest(fX, fY)
	If idx >= 0 And mCallBack <> Null And SubExists(mCallBack, mEventName & "_TagLongPress") Then
		CallSub2(mCallBack, mEventName & "_TagLongPress", mItems.Get(idx))
	End If
End Sub

Private Sub HitTest(fX As Float, fY As Float) As Int
	If mCount = 0 Then Return -1
	Dim best As Int = -1
	Dim bestD As Float = mTextSize * 2
	For i = 0 To mCount - 1
		Dim t As TagPoint = mTags(i)
		If t.z > 0 Then
			Dim sx As Float = ProjectX(t)
			Dim sy As Float = ProjectY(t)
			Dim dx As Float = fX - sx
			Dim dy As Float = fY - sy
			Dim d As Float = Sqrt(dx * dx + dy * dy)
			If d < bestD Then
				bestD = d
				best = i
			End If
		End If
	Next
	Return best
End Sub
#End Region

#Region Auto + Fling
Private Sub StartAutoLoop
	If mBase.IsInitialized = False Then Return
	If mBase.Visible = False Then Return
	tmr.Enabled = True
End Sub

Private Sub StopAutoLoop
	tmr.Enabled = False
End Sub

Private Sub tmrFrame_Tick
	If Not(mAutoRotate) And Not(tmrFling.Enabled) Then
		tmr.Enabled = False
		Return
	End If
	ApplyDelta(mAutoSpeed, -mAutoSpeed)
	Redraw
End Sub

Private Sub StartFling(fVX As Float, fVY As Float)
	mFlingVX = fVX
	mFlingVY = fVY
	If Abs(fVX) + Abs(fVY) < 1 Then Return
	tmrFling.Enabled = True
End Sub

Private Sub StopFling
	tmrFling.Enabled = False
	mFlingVX = 0
	mFlingVY = 0
End Sub

Private Sub tmrFling_Tick
	mFlingVX = mFlingVX / 1.07
	mFlingVY = mFlingVY / 1.07
	ApplyDelta(mFlingVX, mFlingVY)
	Redraw
	If Abs(mFlingVX) + Abs(mFlingVY) < 0.1 Then
		StopFling
		If mAutoRotate Then StartAutoLoop Else tmr.Enabled = False
	End If
End Sub
#End Region

#Region Helpers
Private Sub ParseItems(sText As String)
	mItems.Initialize
	If sText = "" Then Return
	Dim parts() As String = Regex.Split("\|", sText)
	For i = 0 To parts.Length - 1
		Dim s As String = parts(i).Trim
		If s <> "" Then
			mItems.Add(s)
			If mItems.Size >= 200 Then Exit
		End If
	Next
End Sub
#End Region

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
