B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: GapDip, DisplayName: Gap Dip, FieldType: Int, DefaultValue: 8, Description: Gap between action items.
#DesignerProperty: Key: Wrap, DisplayName: Wrap, FieldType: Boolean, DefaultValue: True, Description: Wrap action items when row is full.
#DesignerProperty: Key: Justify, DisplayName: Justify, FieldType: String, DefaultValue: start, List: start|center|End, Description: Horizontal row alignment.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show Or hide actions.

#IgnoreWarnings:12,9

Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView

	Private mGapDip As Int = 8dip
	Private mWrap As Boolean = True
	Private mJustify As String = "start"
	Private mVisible As Boolean = True
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
	mGapDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "GapDip", 8)) * 1dip
	mWrap = B4XDaisyVariants.GetPropBool(mProps, "Wrap", mWrap)
	mJustify = NormalizeJustify(B4XDaisyVariants.GetPropString(mProps, "Justify", mJustify))
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("GapDip", mGapDip / 1dip)
	props.Put("Wrap", mWrap)
	props.Put("Justify", mJustify)
	props.Put("Visible", mVisible)
	Return props
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	Relayout
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, dWidth), Max(1dip, dHeight))
	Relayout
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
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
	Base_Resize(iWidth, iHeight)
End Sub

Public Sub Relayout
	If mBase.IsInitialized = False Then Return

	Dim containerW As Int = Max(1dip, mBase.Width)
	Dim rows As List
	rows.Initialize

	Dim currentItems As List
	currentItems.Initialize
	Dim rowW As Int = 0
	Dim rowH As Int = 0

	For i = 0 To mBase.NumberOfViews - 1
		Dim v As B4XView = mBase.GetView(i)
		If v.Visible = False Then Continue

		Dim vw As Int = Max(1dip, v.Width)
		Dim vh As Int = Max(1dip, v.Height)
		vw = Min(containerW, vw)

		Dim addW As Int = vw
		If currentItems.Size > 0 Then addW = addW + mGapDip

		If mWrap And currentItems.Size > 0 And rowW + addW > containerW Then
			rows.Add(CreateMap("items": currentItems, "width": rowW, "height": rowH))
			currentItems.Initialize
			currentItems.Add(v)
			rowW = vw
			rowH = vh
		Else
			currentItems.Add(v)
			rowW = rowW + addW
			rowH = Max(rowH, vh)
		End If
	Next

	If currentItems.Size > 0 Then
		rows.Add(CreateMap("items": currentItems, "width": rowW, "height": rowH))
	End If

	Dim y As Int = 0
	For Each row As Map In rows
		Dim items As List = row.Get("items")
		Dim usedW As Int = row.Get("width")
		Dim lineH As Int = row.Get("height")
		Dim x As Int = ResolveRowStartX(containerW, usedW)
		For Each v As B4XView In items
			Dim vw As Int = Max(1dip, Min(containerW, v.Width))
			Dim vh As Int = Max(1dip, v.Height)
			Dim vy As Int = y
			v.SetLayoutAnimated(0, x, vy, vw, vh)
			x = x + vw + mGapDip
		Next
		y = y + lineH + mGapDip
	Next
End Sub

Private Sub ResolveRowStartX(iContainerWidth As Int, iUsedWidth As Int) As Int
	Select Case mJustify
		Case "center"
			Return Max(0, (iContainerWidth - iUsedWidth) / 2)
		Case "End"
			Return Max(0, iContainerWidth - iUsedWidth)
		Case Else
			Return 0
	End Select
End Sub

Public Sub setGapDip(iValue As Int)
	mGapDip = Max(0, iValue)
	If mBase.IsInitialized Then Relayout
End Sub

Public Sub getGapDip As Int
	Return mGapDip
End Sub

Public Sub setWrap(bValue As Boolean)
	mWrap = bValue
	If mBase.IsInitialized Then Relayout
End Sub

Public Sub getWrap As Boolean
	Return mWrap
End Sub

Public Sub setJustify(sValue As String)
	mJustify = NormalizeJustify(sValue)
	If mBase.IsInitialized Then Relayout
End Sub

Public Sub getJustify As String
	Return mJustify
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
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

Private Sub NormalizeJustify(sValue As String) As String
	Dim s As String = IIf(sValue = Null, "", sValue.ToLowerCase.Trim)
	Select Case s
		Case "center" : Return "center"
		Case "end" : Return "End"
		Case "start" : Return "start"
		Case Else : Return "start"
	End Select
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
