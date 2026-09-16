B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Body size token.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Body height token (auto, h-32, h-[120px], etc).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide body container.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView

	Private mSize As String = "md"
	Private mHeight As String = "auto"
	Private mVisible As Boolean = True
	Private mPaddingDip As Int = 24dip
	Private mGapDip As Int = 8dip
	Private mBodyTextSize As Float = 14
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
	mBase.Color = xui.Color_Transparent
	ApplyDesignerProps(mProps)
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mHeight = NormalizeHeightSpec(B4XDaisyVariants.GetPropString(mProps, "Height", mHeight))
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	ApplyMetrics
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Size", mSize)
	props.Put("Visible", mVisible)
	Return props
End Sub

Private Sub ApplyMetrics
	Select Case mSize
		Case "xs"
			mPaddingDip = 8dip    '0.5rem in CSS
			mBodyTextSize = 11
		Case "sm"
			mPaddingDip = 16dip   '1rem
			mBodyTextSize = 12
		Case "lg"
			mPaddingDip = 32dip   '2rem
			mBodyTextSize = 16
		Case "xl"
			mPaddingDip = 40dip   '2.5rem
			mBodyTextSize = 18
		Case Else
			mPaddingDip = 24dip   '1.5rem
			mBodyTextSize = 14
	End Select
	' The Daisy CSS uses a fixed gap of `gap-2` (0.5rem ? 8px) between
	' children inside .card-body regardless of size.  Our previous formula
	' scaled the gap with padding, causing small cards to have a much smaller
	' spacing than the CSS.  Use a constant 8dip to match the stylesheet.
	mGapDip = 8dip
End Sub

Private Sub Refresh
	If BaseIsInitialized = False Then Return
	mBase.Visible = mVisible
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If BaseIsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim baseH As Int = Max(1dip, dHeight)
	Dim h As Int = ResolveHeightDip(baseH)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	inResize = False
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

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If BaseIsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If BaseIsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
	Base_Resize(iWidth, iHeight)
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	ApplyMetrics
	If BaseIsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setHeight(sValue As String)
	mHeight = NormalizeHeightSpec(sValue)
	If BaseIsInitialized Then Refresh
End Sub

Public Sub getHeight As String
	Return mHeight
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If BaseIsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub getPaddingDip As Int
	Return mPaddingDip
End Sub

Public Sub getGapDip As Int
	Return mGapDip
End Sub

Public Sub getBodyTextSize As Float
	Return mBodyTextSize
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub getContainer As B4XView
	Return mBase
End Sub



Private Sub ResolveHeightDip(iDefaultHeight As Int) As Int
	If IsAutoHeightSpec Then Return ResolveAutoHeightDip(iDefaultHeight)
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mHeight, iDefaultHeight))
End Sub

Private Sub ResolveAutoHeightDip(iDefaultHeight As Int) As Int
	If BaseIsInitialized = False Then Return Max(1dip, iDefaultHeight)
	Dim maxBottom As Int = 0
	For i = 0 To mBase.NumberOfViews - 1
		Dim v As B4XView = mBase.GetView(i)
		If v.Visible = False Then Continue
		maxBottom = Max(maxBottom, v.Top + v.Height)
	Next
	If maxBottom > 0 Then Return Max(1dip, maxBottom + mPaddingDip)
	Return Max(1dip, iDefaultHeight)
End Sub

Private Sub BaseIsInitialized As Boolean
	If mBase = Null Then Return False
	Return mBase.IsInitialized
End Sub

Private Sub IsAutoHeightSpec As Boolean
	Dim s As String = NormalizeHeightSpec(mHeight)
	Return s = "auto"
End Sub

Private Sub NormalizeHeightSpec(sValue As String) As String
	Dim s As String = IIf(sValue = Null, "", sValue.ToLowerCase.Trim)
	If s.Length = 0 Then Return "auto"
	Return s
End Sub

#Region B4XView Layout Wrapper Methods
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
