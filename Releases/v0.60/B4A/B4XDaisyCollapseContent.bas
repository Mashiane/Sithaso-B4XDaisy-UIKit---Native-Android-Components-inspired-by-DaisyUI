B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'/**
' * B4XDaisyCollapseContent
' * -----------------------------------------------------------------------------
' * Content container part for B4XDaisyCollapse.
' */

#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit background color override (0 uses parent/theme).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit text color override for child labels (0 uses theme token).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide content.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize height to fit child views.

#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView
	Private pnlContent As B4XView

	Private mVisible As Boolean = True
	Private mTextColor As Int = 0
	Private mBackColor As Int = 0
	Private mbAutoResize As Boolean = True
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

	Dim p As Panel
	p.Initialize("")
	pnlContent = p
	pnlContent.Color = xui.Color_Transparent
	mBase.AddView(pnlContent, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(Props)
	Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
	mBackColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", mBackColor)
	mTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", mTextColor)
	mbAutoResize = B4XDaisyVariants.GetPropBool(Props, "AutoResize", True)
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	If mBackColor <> 0 Then mBase.Color = mBackColor
	
	' Debug border
	#if DEBUG
	' mBase.SetColorAndBorder(mBase.Color, 1dip, xui.Color_Red, 0)
	#end if
	
	' Propagate text color to children (CSS-like inheritance for plain labels)
	If pnlContent.IsInitialized Then
		For i = 0 To pnlContent.NumberOfViews - 1
			Dim v As B4XView = pnlContent.GetView(i)
			ApplyTextColorRecursive(v, mTextColor)
		Next
	End If
	
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyTextColorRecursive(v As B4XView, clr As Int)
	If clr = 0 Or clr = -1 Then Return
	' Direct Label check
	#If B4A or B4J or B4i
	If v Is Label Then
		v.TextColor = clr
	End If
	#End If
	' Recursive check for nested labels in panels
	Dim childCount As Int = 0
	Try
		childCount = v.NumberOfViews
	Catch
		' Not a panel/container — skip recursion
	End Try
	If childCount > 0 Then
		For i = 0 To childCount - 1
			ApplyTextColorRecursive(v.GetView(i), clr)
		Next
	End If
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	' Add padding similar to DaisyUI collapse-content (typically px-4 pb-4)
	Dim pad As Int = 16dip
	pnlContent.SetLayoutAnimated(0, pad, 0, Max(1dip, w - (pad * 2)), Max(1dip, h - (pad * 1.5)))
	DoAutoResize
End Sub

Private Sub DoAutoResize
	If mbAutoResize = False Then Return
	If mBase.IsInitialized = False Then Return
	If pnlContent.IsInitialized = False Then Return
	Dim maxBottom As Int = 0
	For i = 0 To pnlContent.NumberOfViews - 1
		Dim v As B4XView = pnlContent.GetView(i)
		If v.Visible Then
			maxBottom = Max(maxBottom, v.Top + v.Height)
		End If
	Next
	If maxBottom <= 0 Then Return
	Dim pad As Int = 16dip
	Dim newH As Int = Max(1dip, maxBottom + Round(pad * 1.5))
	If newH <> mBase.Height Then
		mBase.Height = newH
		pnlContent.Height = Max(1dip, maxBottom + pad)
	End If
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
		DesignerCreateView(b, Null, CreateMap("Visible": mVisible))
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
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getContainer As B4XView
	Return pnlContent
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setAutoResize(Value As Boolean)
	mbAutoResize = Value
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub