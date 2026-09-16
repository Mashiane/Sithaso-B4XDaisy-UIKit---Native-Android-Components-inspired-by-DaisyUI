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

#IgnoreWarnings:12,9
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

	Dim p As Panel
	p.Initialize("")
	pnlContent = p
	pnlContent.Color = xui.Color_Transparent
	mBase.AddView(pnlContent, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(mProps)
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mBackColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackColor)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("BackgroundColor", mBackColor)
	props.Put("TextColor", mTextColor)
	props.Put("Visible", mVisible)
	props.Put("AutoResize", mbAutoResize)
	Return props
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

Private Sub ApplyTextColorRecursive(vView As B4XView, iClr As Int)
	If iClr = 0 Or iClr = -1 Then Return
	' Direct Label check (safe - Try/Catch avoids crash on non-Label types)
	Try
		If vView Is Label Then
			vView.TextColor = iClr
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCollapseContent.ApplyTextColorRecursive: " & LastException.Message)
		' Not a Label - skip
	End Try
	' Recursive check for nested labels in panels
	Dim childCount As Int = 0
	Try
		childCount = vView.NumberOfViews
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCollapseContent.ApplyTextColorRecursive: " & LastException.Message)
		' Not a panel/container - skip recursion
	End Try
	If childCount > 0 Then
		For i = 0 To childCount - 1
			ApplyTextColorRecursive(vView.GetView(i), iClr)
		Next
	End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	' Add padding similar to DaisyUI collapse-content (typically px-4 pb-4)
	Dim pad As Int = 16dip
	pnlContent.SetLayoutAnimated(0, pad, 0, Max(1dip, w - (pad * 2)), Max(1dip, h - (pad * 1.5)))
	DoAutoResize
	inResize = False
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

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, w, h)
		DesignerCreateView(b, Null, BuildRuntimeProps(w, h))
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, w, h)
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

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
	Base_Resize(iWidth, iHeight)
End Sub

Public Sub Relayout
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getContainer As B4XView
	Return pnlContent
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setAutoResize(bValue As Boolean)
	mbAutoResize = bValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
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
