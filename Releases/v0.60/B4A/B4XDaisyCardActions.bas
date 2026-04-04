B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: GapDip, DisplayName: Gap Dip, FieldType: Int, DefaultValue: 8, Description: Gap between action items.
#DesignerProperty: Key: Wrap, DisplayName: Wrap, FieldType: Boolean, DefaultValue: True, Description: Wrap action items when row is full.
#DesignerProperty: Key: Justify, DisplayName: Justify, FieldType: String, DefaultValue: start, List: start|center|end, Description: Horizontal row alignment.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide actions.

#IgnoreWarnings:12
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
	mGapDip = Max(0, B4XDaisyVariants.GetPropInt(Props, "GapDip", 8)) * 1dip
	mWrap = B4XDaisyVariants.GetPropBool(Props, "Wrap", mWrap)
	mJustify = NormalizeJustify(B4XDaisyVariants.GetPropString(Props, "Justify", mJustify))
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	Relayout
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, Width), Max(1dip, Height))
	Relayout
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, w, h)
		DesignerCreateView(b, Null, CreateMap("GapDip": mGapDip / 1dip, "Wrap": mWrap, "Justify": mJustify, "Visible": mVisible))
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
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(Duration, Left, Top, Max(1dip, Width), Max(1dip, Height))
	Base_Resize(Width, Height)
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
			Dim vy As Int = y + Max(0, (lineH - vh) / 2)
			v.SetLayoutAnimated(0, x, vy, vw, vh)
			x = x + vw + mGapDip
		Next
		y = y + lineH + mGapDip
	Next
End Sub

Private Sub ResolveRowStartX(ContainerWidth As Int, UsedWidth As Int) As Int
	Select Case mJustify
		Case "center"
			Return Max(0, (ContainerWidth - UsedWidth) / 2)
		Case "end"
			Return Max(0, ContainerWidth - UsedWidth)
		Case Else
			Return 0
	End Select
End Sub

Public Sub setGapDip(Value As Int)
	mGapDip = Max(0, Value)
	If mBase.IsInitialized Then Relayout
End Sub

Public Sub getGapDip As Int
	Return mGapDip
End Sub

Public Sub setWrap(Value As Boolean)
	mWrap = Value
	If mBase.IsInitialized Then Relayout
End Sub

Public Sub getWrap As Boolean
	Return mWrap
End Sub

Public Sub setJustify(Value As String)
	mJustify = NormalizeJustify(Value)
	If mBase.IsInitialized Then Relayout
End Sub

Public Sub getJustify As String
	Return mJustify
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
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

Private Sub NormalizeJustify(Value As String) As String
	Dim s As String = IIf(Value = Null, "", Value.ToLowerCase.Trim)
	If s = "center" Or s = "end" Then Return s
	Return "start"
End Sub

