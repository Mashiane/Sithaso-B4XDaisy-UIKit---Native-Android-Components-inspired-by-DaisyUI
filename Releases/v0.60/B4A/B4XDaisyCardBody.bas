B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Body size token.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Body height token (auto, h-32, h-[120px], etc).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide body container.

#IgnoreWarnings:12
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
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	ApplyDesignerProps(Props)
	Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", mSize))
	mHeight = NormalizeHeightSpec(B4XDaisyVariants.GetPropString(Props, "Height", mHeight))
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
	ApplyMetrics
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

Public Sub Base_Resize(Width As Double, Height As Double)
	If BaseIsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim baseH As Int = Max(1dip, Height)
	Dim h As Int = ResolveHeightDip(baseH)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int
	If Height > 0 Then
		h = Max(1dip, Height)
	Else
		h = ResolveHeightDip(Max(1dip, mPaddingDip * 2))
	End If
	If BaseIsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, w, h)
		DesignerCreateView(b, Null, CreateMap("Size": mSize, "Height": mHeight, "Visible": mVisible))
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	Parent.AddView(mBase, Left, Top, w, h)
	Refresh
	Return mBase
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If BaseIsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
	If BaseIsInitialized = False Then Return
	mBase.SetLayoutAnimated(Duration, Left, Top, Max(1dip, Width), Max(1dip, Height))
	Base_Resize(Width, Height)
End Sub

Public Sub setSize(Value As String)
	mSize = B4XDaisyVariants.NormalizeSize(Value)
	ApplyMetrics
	If BaseIsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setHeight(Value As String)
	mHeight = NormalizeHeightSpec(Value)
	If BaseIsInitialized Then Refresh
End Sub

Public Sub getHeight As String
	Return mHeight
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
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

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub getContainer As B4XView
	Return mBase
End Sub



Private Sub ResolveHeightDip(DefaultHeight As Int) As Int
	If IsAutoHeightSpec Then Return ResolveAutoHeightDip(DefaultHeight)
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mHeight, DefaultHeight))
End Sub

Private Sub ResolveAutoHeightDip(DefaultHeight As Int) As Int
	If BaseIsInitialized = False Then Return Max(1dip, DefaultHeight)
	Dim maxBottom As Int = 0
	For i = 0 To mBase.NumberOfViews - 1
		Dim v As B4XView = mBase.GetView(i)
		If v.Visible = False Then Continue
		maxBottom = Max(maxBottom, v.Top + v.Height)
	Next
	If maxBottom > 0 Then Return Max(1dip, maxBottom + mPaddingDip)
	Return Max(1dip, DefaultHeight)
End Sub

Private Sub BaseIsInitialized As Boolean
	If mBase = Null Then Return False
	Return mBase.IsInitialized
End Sub

Private Sub IsAutoHeightSpec As Boolean
	Dim s As String = NormalizeHeightSpec(mHeight)
	Return s = "auto"
End Sub

Private Sub NormalizeHeightSpec(Value As String) As String
	Dim s As String = IIf(Value = Null, "", Value.ToLowerCase.Trim)
	If s.Length = 0 Then Return "auto"
	Return s
End Sub
