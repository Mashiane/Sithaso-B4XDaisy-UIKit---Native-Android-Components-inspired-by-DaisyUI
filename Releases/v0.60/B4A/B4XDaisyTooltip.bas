B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Shown
#Event: Hidden
#Event: Click (Tag As Object)

#DesignerProperty: Key: Message, DisplayName: Message, FieldType: String, DefaultValue: Tooltip message, Description: Tooltip text content.
#DesignerProperty: Key: Position, DisplayName: Position, FieldType: String, DefaultValue: top, List: top|bottom|left|right, Description: Anchor position relative to target.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: neutral, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant for tooltip background.
#DesignerProperty: Key: ShowArrow, DisplayName: Show Arrow, FieldType: Boolean, DefaultValue: True, Description: Show the small tail/arrow pointing to target.
#DesignerProperty: Key: ClickToClose, DisplayName: Click To Close, FieldType: Boolean, DefaultValue: True, Description: Hide tooltip when clicked.
#DesignerProperty: Key: TextWrapped, DisplayName: Text Wrapped, FieldType: Boolean, DefaultValue: True, Description: Enable multi-line text wrapping.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Initial visibility.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize tooltip to fit message content.

#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private mMessage As String = "Tooltip message"
	Private mPosition As String = "top"
	Private mVariant As String = "neutral"
	Private mShowArrow As Boolean = True
	Private mClickToClose As Boolean = True
	Private mTextWrapped As Boolean = True
	Private mVisible As Boolean = True
	
	Private mTarget As B4XView
	Private pnlTooltip As B4XView
	Private lblMessage As B4XView
	Private ivTail As B4XView
	Private cvsTail As B4XCanvas
	Private CanvasReady As Boolean = False
	Private CustomContent As B4XView
	
	Private TailSize As Float = 8dip
	Private CornerRadius As Float = 6dip
	Private PaddingH As Float = 12dip
	Private PaddingV As Float = 8dip
	Private MaxWidth As Int = 240dip
	
	Private tu As StringUtils
	Private mDuration As Int = 0
	Private mbAutoResize As Boolean = True
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	
	' Container for the tooltip body
	Dim p As Panel
	p.Initialize("tooltip")
	pnlTooltip = p
	pnlTooltip.Color = xui.Color_Transparent
	mBase.AddView(pnlTooltip, 0, 0, 50dip, 30dip)
	
	' Text label
	Dim l As Label
	l.Initialize("")
	lblMessage = l
	lblMessage.TextColor = xui.Color_White
	lblMessage.SetTextAlignment("CENTER", "CENTER")
	pnlTooltip.AddView(lblMessage, PaddingH, PaddingV, 10dip, 10dip)
	
	' Tail image
	Dim iv As ImageView
	iv.Initialize("")
	ivTail = iv
	mBase.AddView(ivTail, 0, 0, TailSize * 2, TailSize * 2)
	
	ApplyDesignerProps(Props)
	mBase.Visible = mVisible
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mMessage = B4XDaisyVariants.GetPropString(Props, "Message", "Tooltip message")
	mPosition = B4XDaisyVariants.GetPropString(Props, "Position", "top").ToLowerCase
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "neutral"))
	mShowArrow = B4XDaisyVariants.GetPropBool(Props, "ShowArrow", True)
	mClickToClose = B4XDaisyVariants.GetPropBool(Props, "ClickToClose", True)
	mTextWrapped = B4XDaisyVariants.GetPropBool(Props, "TextWrapped", True)
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
	mbAutoResize = B4XDaisyVariants.GetPropBool(Props, "AutoResize", True)
End Sub


' --- Public Methods ---

Public Sub Refresh
	RefreshToolTip
End Sub

Public Sub AttachToTarget(Target As B4XView)
	mTarget = Target
	If mTarget.IsInitialized = False Then Return
	Dim parent As B4XView = mTarget.Parent
	If parent.IsInitialized = False Then Return
	
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	parent.AddView(mBase, 0, 0, 100dip, 100dip)
	
	Refresh
End Sub

Public Sub DetachTarget
	Dim empty As B4XView
	mTarget = empty
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Show
	ShowAnimated(0)
End Sub

Public Sub ShowAnimated(Duration As Int)
	mDuration = Duration
	Refresh ' Make sure we are aligned with target
	mDuration = 0
	mBase.Visible = True
	BringToFront
	If xui.SubExists(mCallBack, mEventName & "_Shown", 0) Then
		CallSub(mCallBack, mEventName & "_Shown")
	End If
End Sub

Public Sub Hide
	mBase.Visible = False
	If xui.SubExists(mCallBack, mEventName & "_Hidden", 0) Then
		CallSub(mCallBack, mEventName & "_Hidden")
	End If
End Sub

Public Sub getVisible As Boolean
	Return mBase.Visible
End Sub

Public Sub setAutoResize(Value As Boolean)
	mbAutoResize = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub

Public Sub setVisible(b As Boolean)
	If b Then Show Else Hide
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	If mBase.IsInitialized Then Refresh
End Sub


Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setMessage(Value As String)
	mMessage = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getMessage As String
	Return mMessage
End Sub

Public Sub setPosition(Value As String)
	mPosition = Value.ToLowerCase
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPosition As String
	Return mPosition
End Sub


Public Sub SetCustomContent(View As B4XView)
	If CustomContent.IsInitialized Then CustomContent.RemoveViewFromParent
	CustomContent = View
	lblMessage.Visible = (CustomContent.IsInitialized = False)
	If CustomContent.IsInitialized Then
		pnlTooltip.AddView(CustomContent, PaddingH, PaddingV, CustomContent.Width, CustomContent.Height)
	End If
	RefreshToolTip
End Sub

' --- UI Update ---

Private Sub RefreshToolTip
	If mBase.IsInitialized = False Then Return
	If mbAutoResize = False Then Return
	
	' Colors
	Dim backColor As Int = GetBackColor
	Dim textColor As Int = GetTextColor
	
	' Size content
	Dim contentW As Int
	Dim contentH As Int
	
	If CustomContent.IsInitialized Then
		contentW = CustomContent.Width
		contentH = CustomContent.Height
		' Ensure it's correctly placed and visible
		CustomContent.SetLayoutAnimated(0, PaddingH, PaddingV, contentW, contentH)
	Else
		lblMessage.Text = mMessage
		lblMessage.TextColor = textColor
		If mTextWrapped Then
			lblMessage.Width = MaxWidth - (PaddingH * 2)
			contentH = tu.MeasureMultilineTextHeight(lblMessage, mMessage)
			contentW = MeasureSingleLineWidth(lblMessage, mMessage)
			If contentW > MaxWidth - (PaddingH * 2) Then contentW = MaxWidth - (PaddingH * 2)
		Else
			contentW = MeasureSingleLineWidth(lblMessage, mMessage)
			contentH = MeasureSingleLineHeight(lblMessage)
		End If
	End If
	
	Dim bodyW As Int = contentW + (PaddingH * 2)
	Dim bodyH As Int = contentH + (PaddingV * 2)
	
	' Layout body
	pnlTooltip.SetLayoutAnimated(0, 0, 0, bodyW, bodyH)
	pnlTooltip.SetColorAndBorder(backColor, 0, 0, CornerRadius)
	If lblMessage.Visible Then
		lblMessage.SetLayoutAnimated(0, PaddingH, PaddingV, contentW, contentH)
	End If
	
	' Base sizing (body + tail space)
	Dim baseW As Int = bodyW
	Dim baseH As Int = bodyH
	
	If mShowArrow Then
		Select Case mPosition
			Case "top", "bottom" : baseH = baseH + TailSize
			Case "left", "right" : baseW = baseW + TailSize
		End Select
	End If
	
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, baseW, baseH)
	
	' Tail positioning and drawing
	ivTail.Visible = mShowArrow
	If mShowArrow Then
		DrawTail(backColor)
		PositionTail(bodyW, bodyH)
	End If
	
	' Global positioning if target exists
	If mTarget.IsInitialized Then
		' ensure ancestors also disable clipping for elevated shadows
		B4XDaisyVariants.DisableClippingRecursive(mBase)
		SyncToTarget(baseW, baseH)
	End If
End Sub

Private Sub PositionTail(bodyW As Int, bodyH As Int)
	Select Case mPosition
		Case "top"
			pnlTooltip.SetLayoutAnimated(0, 0, 0, bodyW, bodyH)
			ivTail.SetLayoutAnimated(0, (bodyW - TailSize * 2) / 2, bodyH - 1dip, TailSize * 2, TailSize * 2) ' overlap 1dip to prevent gaps
		Case "bottom"
			pnlTooltip.SetLayoutAnimated(0, 0, TailSize, bodyW, bodyH)
			ivTail.SetLayoutAnimated(0, (bodyW - TailSize * 2) / 2, 0, TailSize * 2, TailSize * 2)
		Case "left"
			pnlTooltip.SetLayoutAnimated(0, 0, 0, bodyW, bodyH)
			ivTail.SetLayoutAnimated(0, bodyW - 1dip, (bodyH - TailSize * 2) / 2, TailSize * 2, TailSize * 2)
		Case "right"
			pnlTooltip.SetLayoutAnimated(0, TailSize, 0, bodyW, bodyH)
			ivTail.SetLayoutAnimated(0, 0, (bodyH - TailSize * 2) / 2, TailSize * 2, TailSize * 2)
	End Select
End Sub

Private Sub DrawTail(Color As Int)
	If CanvasReady Then cvsTail.Release
	cvsTail.Initialize(ivTail)
	CanvasReady = True
	cvsTail.ClearRect(cvsTail.TargetRect)
	
	Dim p As B4XPath
	Select Case mPosition
		Case "top"
			p.Initialize(TailSize / 2, 0)
			p.LineTo(TailSize * 1.5, 0)
			p.LineTo(TailSize, TailSize)
		Case "bottom"
			p.Initialize(TailSize, 0)
			p.LineTo(TailSize / 2, TailSize)
			p.LineTo(TailSize * 1.5, TailSize)
		Case "left"
			p.Initialize(0, TailSize / 2)
			p.LineTo(TailSize, TailSize)
			p.LineTo(0, TailSize * 1.5)
		Case "right"
			p.Initialize(TailSize, TailSize / 2)
			p.LineTo(0, TailSize)
			p.LineTo(TailSize, TailSize * 1.5)
	End Select
	cvsTail.DrawPath(p, Color, True, 0)
	cvsTail.Invalidate
End Sub

Private Sub SyncToTarget(baseW As Int, baseH As Int)
	Dim tw As Int = mTarget.Width
	Dim th As Int = mTarget.Height
	Dim tx As Int = mTarget.Left
	Dim ty As Int = mTarget.Top
	
	Dim bx As Int
	Dim by As Int
	
	Select Case mPosition
		Case "top"
			bx = tx + (tw - baseW) / 2
			by = ty - baseH
		Case "bottom"
			bx = tx + (tw - baseW) / 2
			by = ty + th
		Case "left"
			bx = tx - baseW
			by = ty + (th - baseH) / 2
		Case "right"
			bx = tx + tw
			by = ty + (th - baseH) / 2
	End Select
	
	mBase.SetLayoutAnimated(mDuration, bx, by, baseW, baseH)
	BringToFront
End Sub

' --- Helpers ---

Private Sub GetBackColor As Int
	Dim pal As Map = B4XDaisyVariants.GetVariantPalette
	Dim vm As Map = pal.GetDefault(mVariant, pal.Get("neutral"))
	Return vm.GetDefault("back", B4XDaisyVariants.GetTokenColor("--color-neutral", xui.Color_RGB(42, 50, 60))) ' neutral default from theme
End Sub

Private Sub GetTextColor As Int
	Dim pal As Map = B4XDaisyVariants.GetVariantPalette
	Dim vm As Map = pal.GetDefault(mVariant, pal.Get("neutral"))
	Return vm.GetDefault("text", xui.Color_White)
End Sub

Private Sub tooltip_Click
	If mClickToClose Then Hide
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	End If
End Sub

Private Sub MeasureSingleLineWidth(v As B4XView, Text As String) As Int
	If Text.Length = 0 Then Return 0
	Dim l As Label = v
	Dim c As Canvas
	c.Initialize(l)
	Return c.MeasureStringWidth(Text, l.Typeface, l.TextSize) + 2dip
End Sub

Private Sub MeasureSingleLineHeight(v As B4XView) As Int
	Dim l As Label = v
	Return tu.MeasureMultilineTextHeight(l, "Ag")
End Sub


Private Sub BringToFront
	#If B4A
	Try
		Dim jo As JavaObject = mBase
		jo.RunMethod("bringToFront", Null)
	Catch
	End Try 'ignore
	#End If
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
