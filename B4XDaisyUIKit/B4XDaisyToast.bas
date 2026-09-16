B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: NotificationClosed (View As B4XView)

#DesignerProperty: Key: HorizontalAlignment, DisplayName: Horizontal Alignment, FieldType: String, DefaultValue: end, List: start|center|end
#DesignerProperty: Key: VerticalAlignment, DisplayName: Vertical Alignment, FieldType: String, DefaultValue: bottom, List: top|middle|bottom
#DesignerProperty: Key: ShowProgress, DisplayName: Show Progress, FieldType: Boolean, DefaultValue: True, Description: Show a progress bar for timed notifications.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	
	Private mHorizontalAlignment As String = "end"
	Private mVerticalAlignment As String = "bottom"
	Private mShowProgress As Boolean = True
	
	Private Items As List
	Private Container As B4XView
	Private RootPanel As B4XView
	
	Type ToastItem (View As B4XView, Progress As B4XDaisyProgress, Timer As Timer, StartTime As Long, Duration As Long)
	Private inResize As Boolean = False
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mEventName = sEventName
	mCallBack = oCallback
	Items.Initialize
End Sub

Public Sub CreateView As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	DesignerCreateView(b, Null, Null)
	Return b
End Sub

Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBase.Color = xui.Color_Transparent
	
	' The toast container itself is often a high-level panel on the Root.
	' We create an internal panel to hold coordinates.
	Dim p As Panel
	p.Initialize("")
	Container = p
	Container.Color = xui.Color_Transparent
	
	ApplyDesignerProps(mProps)
End Sub

Public Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	mHorizontalAlignment = B4XDaisyVariants.GetPropString(mProps, "HorizontalAlignment", mHorizontalAlignment)
	mVerticalAlignment = B4XDaisyVariants.GetPropString(mProps, "VerticalAlignment", mVerticalAlignment)
	mShowProgress = B4XDaisyVariants.GetPropBool(mProps, "ShowProgress", mShowProgress)
End Sub

Private Sub BuildRuntimeProps As Map
	Dim props As Map
	props.Initialize
	props.Put("HorizontalAlignment", mHorizontalAlignment)
	props.Put("VerticalAlignment", mVerticalAlignment)
	props.Put("ShowProgress", mShowProgress)
	Return props
End Sub

' Set where the toast will appear on the screen.

Public Sub getHorizontalAlignment As String
    Return mHorizontalAlignment
End Sub

Public Sub setHorizontalAlignment(sValue As String)
    mHorizontalAlignment = sValue.ToLowerCase
End Sub

Public Sub getVerticalAlignment As String
    Return mVerticalAlignment
End Sub

Public Sub setVerticalAlignment(sValue As String)
    mVerticalAlignment = sValue.ToLowerCase
End Sub

Public Sub SetPosition(sHorizontal As String, sVertical As String)
	mHorizontalAlignment = sHorizontal
	mVerticalAlignment = sVertical
	RefreshLayout
End Sub

Public Sub Show
	If Container.IsInitialized = False Then Return
	If Container.Parent.IsInitialized = False Then
		If RootPanel.IsInitialized Then
			RootPanel.AddView(Container, 0, 0, RootPanel.Width, RootPanel.Height)
		End If
	End If
	If Container.IsInitialized Then
		Container.Visible = True
		Container.BringToFront
	End If
	RefreshLayout
End Sub

Public Sub Hide
	If Container.IsInitialized Then Container.Visible = False
End Sub

' Sets the high-level root panel where the toast container will stay.
Public Sub SetRoot(vRoot1 As B4XView)
	RootPanel = vRoot1
End Sub

Public Sub AttachTo(vHostView As B4XView)
	AttachWithDuration(vHostView, 0)
End Sub

Public Sub Detach(vHostView As B4XView)
	For i = Items.Size - 1 To 0 Step -1
		Dim item As ToastItem = Items.Get(i)
		If item.View = vHostView Then
			RemoveItem(i)
			Return
		End If
	Next
End Sub

Private Sub RemoveItem(iIndex As Int)
	Dim item As ToastItem = Items.Get(iIndex)
	If item.Duration > 0 Then
		If item.Timer.IsInitialized Then item.Timer.Enabled = False
	End If
	item.View.RemoveViewFromParent
	' Safe removal of progress bar
	Try
		If item.Progress.IsInitialized Then
			item.Progress.RemoveViewFromParent
		End If
	Catch
		' Ignore if uninitialized
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyToast.RemoveItem: " & LastException.Message)
	End Try			'ignore
	Items.RemoveAt(iIndex)
	' When the last toast is dismissed, hide the full-screen container so it
	' stops sitting on top of the host page and intercepting scroll/touch events.
	' (Restores v0.61 behaviour where the card demo page had no overlay on Root.)
	If Items.Size = 0 Then
		Hide
	Else
		RefreshLayout
	End If
	
	If xui.SubExists(mCallBack, mEventName & "_NotificationClosed", 1) Then
		CallSub2(mCallBack, mEventName & "_NotificationClosed", item.View)
	End If
End Sub

Public Sub Clear
	For i = Items.Size - 1 To 0 Step -1
		RemoveItem(i)
	Next
End Sub

Private Sub Timer_Tick
	Dim t As Timer = Sender
	Dim now As Long = DateTime.Now
	For i = Items.Size - 1 To 0 Step -1
		Dim item As ToastItem = Items.Get(i)
		' ONLY check timed items to avoid "Object should be initialized" crash
		If item.Duration > 0 Then
			If item.Timer = t Then
				Dim elapsed As Long = now - item.StartTime
				If elapsed >= item.Duration Then
					RemoveItem(i)
				Else
					If item.Progress.IsInitialized Then
						item.Progress.setValue(item.Duration - elapsed)
					End If
				End If
				Return
			End If
		End If
	Next
End Sub

Private Sub RefreshLayout
	If Container.IsInitialized = False Or Container.Visible = False Then Return
	If RootPanel.IsInitialized = False Then Return
	
	Dim w As Int = Max(100dip, RootPanel.Width)
	Dim h As Int = Max(100dip, RootPanel.Height)

	If Items.Size = 0 Then
		' No items: shrink the container so it does not cover the host page and
		' block scrolling/touch while the toast is idle.
		Container.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
		Return
	End If
	
	' DaisyUI Toast Position offsets.
	Dim offset As Int = 16dip
	Dim gap As Int = 8dip
	
	' Measure total height of stack.
	Dim totalH As Int = 0
	Dim maxW As Int = 0
	For Each item As ToastItem In Items
		totalH = totalH + item.View.Height
		' Progress bar height only counts if it's NOT inside the view panel
		If item.Duration > 0 Then
			Try
				If item.Progress <> Null Then
					If item.Progress.IsInitialized And item.Progress.View.Parent = Container Then
						totalH = totalH + item.Progress.View.Height + 2dip
					End If
				End If
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisyToast.RefreshLayout: " & LastException.Message)
			End Try 'ignore
		End If
		totalH = totalH + gap
		Dim vw As Int = item.View.Width
		Dim vh As Int = item.View.Height
		If vw < 0 Or vh < 0 Then
			' Log("Warning: Toast item has invalid dimensions: " & vw & "x" & vh)
		End If
		maxW = Max(maxW, Max(1dip, vw))
	Next
	If totalH > 0 Then totalH = totalH - gap
	
	' Calculate anchor point.
	Dim anchorX As Int
	Dim anchorY As Int
	
	Select Case mHorizontalAlignment.ToLowerCase
		Case "start": anchorX = offset
		Case "center": anchorX = (w - maxW) / 2
		Case "end": anchorX = w - maxW - offset
		Case Else: anchorX = w - maxW - offset
	End Select
	
	Select Case mVerticalAlignment.ToLowerCase
		Case "top": anchorY = offset
		Case "middle": anchorY = (h - totalH) / 2
		Case "bottom": anchorY = h - totalH - offset
		Case Else: anchorY = h - totalH - offset
	End Select
	
	' Size the container to just the toast stack (not the full root) and place it
	' at the anchor, so the rest of the host page keeps receiving scroll/touch.
	Container.SetLayoutAnimated(0, anchorX, anchorY, Max(1dip, maxW), Max(1dip, totalH))

	' Position items relative to the container (0-based).
	Dim currentY As Int = 0
	For Each item As ToastItem In Items
		Dim itemW As Int = Max(1dip, item.View.Width)
		Dim itemH As Int = Max(1dip, item.View.Height)
		item.View.SetLayoutAnimated(200, 0, currentY, itemW, itemH)
		currentY = currentY + item.View.Height
		If item.Duration > 0 Then
			Try
				If item.Progress <> Null Then
					If item.Progress.IsInitialized And item.Progress.View.Parent = Container Then
						currentY = currentY + 2dip
						item.Progress.setLeft(0)
						item.Progress.setTop(currentY)
						item.Progress.Base_Resize(item.View.Width, 4dip)
						currentY = currentY + 4dip
					End If
				End If
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisyToast.RefreshLayout: " & LastException.Message)
			End Try 'ignore
		End If
		currentY = currentY + gap
	Next
End Sub

Public Sub Success(sMessage As String)
	SuccessWithDuration(sMessage, 0)
End Sub

Public Sub SuccessWithDuration(sMessage As String, iDurationMs As Int)
	CreateAlert(sMessage, "success", iDurationMs)
End Sub

Public Sub Info(sMessage As String)
	InfoWithDuration(sMessage, 0)
End Sub

Public Sub InfoWithDuration(sMessage As String, iDurationMs As Int)
	CreateAlert(sMessage, "info", iDurationMs)
End Sub

Public Sub Warning(sMessage As String)
	WarningWithDuration(sMessage, 0)
End Sub

Public Sub WarningWithDuration(sMessage As String, iDurationMs As Int)
	CreateAlert(sMessage, "warning", iDurationMs)
End Sub

Public Sub Error(sMessage As String)
	ErrorWithDuration(sMessage, 0)
End Sub

Public Sub ErrorWithDuration(sMessage As String, iDurationMs As Int)
	CreateAlert(sMessage, "error", iDurationMs)
End Sub

' Internal helper to create and attach a B4XDaisyAlert
Private Sub CreateAlert(sMessage As String, sVariant As String, iDurationMs As Int)
	Dim alert1 As B4XDaisyAlert
	' Use "ToastAlert" as event name so we can handle it here in the class
	alert1.Initialize(Me, "ToastAlert") 
	
	' Create a panel to host the alert
	Dim p As Panel
	p.Initialize("AlertClick") 
	Dim bp As B4XView = p
	' Use setters and AddToParent instead of direct DesignerCreateView
	alert1.Text = sMessage
	alert1.Variant = sVariant
	alert1.AlertStyle = "solid"
	
	' AddToParent with 0 height triggers automatic SizeToFit
	alert1.AddToParent(bp, 0, 0, 260dip, 0)
	' Explicitly size the item panel to match the alert's final height
	bp.SetLayoutAnimated(0, 0, 0, 260dip, alert1.mBase.Height)
	Dim pHeight As Int = Max(48dip, bp.Height)
	
	' Store the alert object in the tag for easy access
	bp.Tag = alert1
	
	If iDurationMs > 0 Then
		If mShowProgress Then
			' Resolve the colors for the alert to use for the progress bar
			Dim clrs As Map = alert1.GetVisualColors
			Dim fg As Int = clrs.GetDefault("text", xui.Color_White)
			
			Dim prg As B4XDaisyProgress
			prg.Initialize(Me, "progress")
			' Inject at the bottom of the alert panel (bp)
			Dim prgView As B4XView = prg.AddToParent(bp, 0, pHeight - 2dip, 260dip, 2dip)
			prg.setMaxValue(iDurationMs)
			prg.setValue(iDurationMs)
			
			' Set the progress bar color to match the layout
			prg.SetValueColor(fg)
			prg.SetTrackColor(xui.Color_Transparent)
		End If
		AttachWithDuration(bp, iDurationMs)
	Else
		AttachWithDuration(bp, 0)
	End If
End Sub

' Handles clicks on the wrapper panel
Private Sub AlertClick_Click
	Dim bp As B4XView = Sender
	Detach(bp)
End Sub

' Handles clicks forwarded by the B4XDaisyAlert component
Private Sub ToastAlert_Click (oTag As Object)
	For Each item As ToastItem In Items
		' If the view itself was clicked, or it's an alert inside a panel
		' Or if the Tag is the B4XDaisyAlert instance stored in item.View.Tag
		If item.View = oTag Or item.View.Tag = oTag Then
			Detach(item.View)
			Return
		End If
	Next
	
	' Last resort: if Tag is the B4XDaisyAlert object, find its base
	If oTag Is B4XDaisyAlert Then
		Dim alert As B4XDaisyAlert = oTag
		For Each item As ToastItem In Items
			If item.View.Tag = alert Then
				Detach(item.View)
				Return
			End If
		Next
	End If
End Sub

' Modify AttachWithDuration to support pre-attached progress bars
Public Sub AttachWithDuration(vHostView As B4XView, iDurationMs As Int)
	If Container.IsInitialized = False Then Return
	Show
	vHostView.RemoveViewFromParent
	
	Dim item As ToastItem
	item.Initialize
	item.View = vHostView
	
	' Check if the view already has a progress bar inside it
	Dim existingProgress As B4XDaisyProgress = Null
	If vHostView.IsInitialized And vHostView.NumberOfViews > 0 Then
		For i = 0 To vHostView.NumberOfViews - 1
			Dim v As B4XView = vHostView.GetView(i)
			If v.Tag Is B4XDaisyProgress Then
				existingProgress = v.Tag
				Exit
			End If
		Next
	End If

	If iDurationMs > 0 Then
		item.Duration = iDurationMs
		item.StartTime = DateTime.Now
		
		If existingProgress <> Null Then
			item.Progress = existingProgress
		Else If mShowProgress Then
			Dim prg As B4XDaisyProgress
			prg.Initialize(Me, "progress")
			Dim prgView As B4XView = prg.AddToParent(Container, 0, 0, vHostView.Width, 4dip)
			prg.setVariant("info") 
			prg.setMaxValue(iDurationMs)
			prg.setValue(iDurationMs)
			item.Progress = prg
		End If
		
		Dim t As Timer
		t.Initialize("Timer", 50)
		item.Timer = t
		item.Timer.Enabled = True
	End If
	
	Items.Add(item)
	Container.AddView(vHostView, 0, 0, vHostView.Width, vHostView.Height)
	RefreshLayout
End Sub

Public Sub Base_Resize (iWidth As Int, iHeight As Int)
	If inResize Then Return
	inResize = True
	RefreshLayout
	inResize = False
End Sub

Public Sub setShowProgress(bValue As Boolean)
	mShowProgress = bValue
End Sub

Public Sub getShowProgress As Boolean
	Return mShowProgress
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
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
