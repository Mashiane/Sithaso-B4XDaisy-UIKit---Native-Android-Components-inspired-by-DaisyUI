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
#DesignerProperty: Key: Alignment, DisplayName: Alignment, FieldType: String, DefaultValue: center, List: start|center|end, Description: Align tooltip to start/center/end of the target (tooltip-start/center/end parity).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: neutral, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant for tooltip background.
#DesignerProperty: Key: ShowArrow, DisplayName: Show Arrow, FieldType: Boolean, DefaultValue: True, Description: Show the small tail/arrow pointing to target.
#DesignerProperty: Key: ClickToClose, DisplayName: Click To Close, FieldType: Boolean, DefaultValue: True, Description: Hide tooltip when clicked.
#DesignerProperty: Key: TextWrapped, DisplayName: Text Wrapped, FieldType: Boolean, DefaultValue: True, Description: Enable multi-line text wrapping.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Initial visibility.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize tooltip to fit message content.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, Description: Fade animation duration in milliseconds for hide (0 = instant).

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object
	Private mMessage As String = "Tooltip message"
	Private mPosition As String = "top"
	Private mAlignment As String = "center"
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
	Private TailOffset As Float = 8dip
	Private CornerRadius As Float = 6dip
	Private PaddingH As Float = 12dip
	Private PaddingV As Float = 8dip
	Private MaxWidth As Int = 320dip
	
	Private tu As StringUtils
	Private mDuration As Int = 0
	Private miDuration As Int = 300
	Private mbAutoResize As Boolean = True
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
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
	
	ApplyDesignerProps(mProps)
	mBase.Visible = mVisible
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mMessage = B4XDaisyVariants.GetPropString(mProps, "Message", mMessage)
	mPosition = B4XDaisyVariants.GetPropString(mProps, "Position", mPosition).ToLowerCase
	mAlignment = B4XDaisyVariants.GetPropString(mProps, "Alignment", mAlignment).ToLowerCase
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mShowArrow = B4XDaisyVariants.GetPropBool(mProps, "ShowArrow", mShowArrow)
	mClickToClose = B4XDaisyVariants.GetPropBool(mProps, "ClickToClose", mClickToClose)
	mTextWrapped = B4XDaisyVariants.GetPropBool(mProps, "TextWrapped", mTextWrapped)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Message", mMessage)
	props.Put("Position", mPosition)
	props.Put("Alignment", mAlignment)
	props.Put("Variant", mVariant)
	props.Put("ShowArrow", mShowArrow)
	props.Put("ClickToClose", mClickToClose)
	props.Put("TextWrapped", mTextWrapped)
	props.Put("Visible", mVisible)
	props.Put("AutoResize", mbAutoResize)
	props.Put("Duration", miDuration)
	Return props
End Sub


' --- Public Methods ---

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("mBase")
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

Public Sub Refresh
	RefreshToolTip
End Sub

Public Sub AttachTo(vTarget As B4XView)
	mTarget = vTarget
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
	ShowAnimated(miDuration)
End Sub

Public Sub ShowAnimated(iDuration As Int)
	mDuration = iDuration
	Refresh ' Make sure we are aligned with target
	mDuration = 0
	mBase.Visible = True
	BringToFront
	If xui.SubExists(mCallBack, mEventName & "_Shown", 0) Then
		CallSub(mCallBack, mEventName & "_Shown")
	End If
End Sub

Public Sub Hide
	HideAnimated(miDuration)
End Sub

''' Hides the tooltip with an optional fade-out animation, then fires the _Hidden event.
''' DurationMs 0 (or already hidden) hides instantly.
Public Sub HideAnimated(iDurationMs As Int)
	If mBase.IsInitialized = False Then Return
	If iDurationMs > 0 And mBase.Visible Then
		mBase.SetVisibleAnimated(iDurationMs, False)
		Sleep(iDurationMs)
	Else
		mBase.Visible = False
	End If
	If xui.SubExists(mCallBack, mEventName & "_Hidden", 0) Then
		CallSub(mCallBack, mEventName & "_Hidden")
	End If
End Sub

Public Sub getVisible As Boolean
	Return mBase.Visible
End Sub

''' Sets the fade animation duration in milliseconds (0 = instant).
Public Sub setDuration(iValue As Int)
	miDuration = Max(0, iValue)
End Sub

''' Returns the fade animation duration in milliseconds.
Public Sub getDuration As Int
	Return miDuration
End Sub



Public Sub setAutoResize(bValue As Boolean)
	mbAutoResize = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub

Public Sub setVisible(bValue As Boolean)
	If bValue Then Show Else Hide
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized Then Refresh
End Sub


Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setMessage(sValue As String)
	mMessage = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getMessage As String
	Return mMessage
End Sub

Public Sub setPosition(sValue As String)
	mPosition = sValue.ToLowerCase
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPosition As String
	Return mPosition
End Sub

Public Sub setAlignment(sValue As String)
	mAlignment = sValue.ToLowerCase
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAlignment As String
	Return mAlignment
End Sub


Public Sub SetCustomContent(vCustomView As B4XView)
	If CustomContent.IsInitialized Then CustomContent.RemoveViewFromParent
	CustomContent = vCustomView
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
		lblMessage.TextSize = 14
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
	Dim radius As Float = B4XDaisyVariants.GetTokenNumber("--radius-field", CornerRadius)
	pnlTooltip.SetColorAndBorder(backColor, 0, 0, radius)
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

Private Sub PositionTail(iBodyW As Int, iBodyH As Int)
	Dim tailBox As Int = TailSize * 2
	Select Case mPosition
		Case "top"
			pnlTooltip.SetLayoutAnimated(0, 0, 0, iBodyW, iBodyH)
			ivTail.SetLayoutAnimated(0, ResolveTailPos(iBodyW, tailBox), iBodyH - 1dip, tailBox, tailBox) ' overlap 1dip to prevent gaps
		Case "bottom"
			pnlTooltip.SetLayoutAnimated(0, 0, TailSize, iBodyW, iBodyH)
			ivTail.SetLayoutAnimated(0, ResolveTailPos(iBodyW, tailBox), 0, tailBox, tailBox)
		Case "left"
			pnlTooltip.SetLayoutAnimated(0, 0, 0, iBodyW, iBodyH)
			ivTail.SetLayoutAnimated(0, iBodyW - 1dip, ResolveTailPos(iBodyH, tailBox), tailBox, tailBox)
		Case "right"
			pnlTooltip.SetLayoutAnimated(0, TailSize, 0, iBodyW, iBodyH)
			ivTail.SetLayoutAnimated(0, 0, ResolveTailPos(iBodyH, tailBox), tailBox, tailBox)
	End Select
End Sub

' Returns the tail position along the tooltip body, honouring start/center/end alignment.
' bodySize = body dimension along the tail axis; tailBox = ivTail box size.
Private Sub ResolveTailPos(iBodySize As Int, iTailBox As Int) As Int
	Select Case mAlignment
		Case "start"
			Return TailOffset
		Case "end"
			Return iBodySize - iTailBox - TailOffset
		Case Else ' center
			Return (iBodySize - iTailBox) / 2
	End Select
End Sub

Private Sub DrawTail(iColor As Int)
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
	cvsTail.DrawPath(p, iColor, True, 0)
	cvsTail.Invalidate
End Sub

Private Sub SyncToTarget(iBaseW As Int, iBaseH As Int)
	Dim tw As Int = mTarget.Width
	Dim th As Int = mTarget.Height
	Dim tx As Int = mTarget.Left
	Dim ty As Int = mTarget.Top
	
	Dim bx As Int
	Dim by As Int
	
	' Cross-axis alignment (start/center/end) along the target.
	' top/bottom align horizontally; left/right align vertically.
	Dim alignH As Int = ResolveAlignOffset(tw, iBaseW)
	Dim alignV As Int = ResolveAlignOffset(th, iBaseH)
	
	Select Case mPosition
		Case "top"
			bx = tx + alignH
			by = ty - iBaseH
		Case "bottom"
			bx = tx + alignH
			by = ty + th
		Case "left"
			bx = tx - iBaseW
			by = ty + alignV
		Case "right"
			bx = tx + tw
			by = ty + alignV
	End Select
	
	mBase.SetLayoutAnimated(mDuration, bx, by, iBaseW, iBaseH)
	BringToFront
End Sub

' Returns the offset of the tooltip relative to the target's near edge,
' honouring start/center/end alignment. targetSize = target dimension,
' baseSize = tooltip base dimension along the same axis.
Private Sub ResolveAlignOffset(iTargetSize As Int, iBaseSize As Int) As Int
	Select Case mAlignment
		Case "start"
			Return 0
		Case "end"
			Return iTargetSize - iBaseSize
		Case Else ' center
			Return (iTargetSize - iBaseSize) / 2
	End Select
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

Private Sub MeasureSingleLineWidth(vView As B4XView, sText As String) As Int
	If sText.Length = 0 Then Return 0
	Dim l As Label = vView
	Return B4XDaisyVariants.MeasureTextWidthSafe(sText, l.TextSize, l.Typeface, 2dip)
End Sub

Private Sub MeasureSingleLineHeight(vView As B4XView) As Int
	Dim l As Label = vView
	Return tu.MeasureMultilineTextHeight(l, "Ag")
End Sub


Public Sub BringToFront
	#If B4A
	Try
		Dim jo As JavaObject = mBase
		jo.RunMethod("bringToFront", Null)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyTooltip.BringToFront: " & LastException.Message)
	End Try 'ignore
	#End If
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub GetActualHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub GetActualWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
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
Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
Public Sub getClickToClose As Boolean
    Return mClickToClose
End Sub

Public Sub setClickToClose(bValue As Boolean)
    mClickToClose = bValue
End Sub

Public Sub getShowArrow As Boolean
    Return mShowArrow
End Sub

Public Sub setShowArrow(bValue As Boolean)
    mShowArrow = bValue
    ivTail.Visible = bValue
End Sub

Public Sub getTextWrapped As Boolean
    Return mTextWrapped
End Sub

Public Sub setTextWrapped(bValue As Boolean)
    mTextWrapped = bValue
End Sub
