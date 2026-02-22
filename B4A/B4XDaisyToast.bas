B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: NotificationClosed (View As B4XView)

#DesignerProperty: Key: HorizontalAlignment, DisplayName: Horizontal Alignment, FieldType: String, DefaultValue: end, List: start|center|end
#DesignerProperty: Key: VerticalAlignment, DisplayName: Vertical Alignment, FieldType: String, DefaultValue: bottom, List: top|middle|bottom
#DesignerProperty: Key: ShowProgress, DisplayName: Show Progress, FieldType: Boolean, DefaultValue: True, Description: Show a progress bar for timed notifications.

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
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
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

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mBase.Color = xui.Color_Transparent
	
	' The toast container itself is often a high-level panel on the Root.
	' We create an internal panel to hold coordinates.
	Dim p As Panel
	p.Initialize("")
	Container = p
	Container.Color = xui.Color_Transparent
	
	ApplyDesignerProps(Props)
End Sub

Public Sub ApplyDesignerProps(Props As Map)
	If Props.IsInitialized = False Then Return
	mHorizontalAlignment = Props.GetDefault("HorizontalAlignment", mHorizontalAlignment)
	mVerticalAlignment = Props.GetDefault("VerticalAlignment", mVerticalAlignment)
	mShowProgress = Props.GetDefault("ShowProgress", mShowProgress)
End Sub

' Set where the toast will appear on the screen.
Public Sub SetPosition(Horizontal As String, Vertical As String)
	mHorizontalAlignment = Horizontal
	mVerticalAlignment = Vertical
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
Public Sub SetRoot(Root1 As B4XView)
	RootPanel = Root1
End Sub

Public Sub Attach(View As B4XView)
	AttachWithDuration(View, 0)
End Sub

Public Sub Detach(View As B4XView)
	For i = Items.Size - 1 To 0 Step -1
		Dim item As ToastItem = Items.Get(i)
		If item.View = View Then
			RemoveItem(i)
			Return
		End If
	Next
End Sub

Private Sub RemoveItem(Index As Int)
	Dim item As ToastItem = Items.Get(Index)
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
	End Try
	Items.RemoveAt(Index)
	RefreshLayout
	
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
	Container.SetLayoutAnimated(0, 0, 0, w, h)
	
	If Items.Size = 0 Then Return
	
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
				If item.Progress.IsInitialized And item.Progress.mBase.Parent = Container Then
					totalH = totalH + item.Progress.mBase.Height + 2dip
				End If
			Catch
			End Try
		End If
		totalH = totalH + gap
		maxW = Max(maxW, item.View.Width)
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
	
	' Position items.
	Dim currentY As Int = anchorY
	For Each item As ToastItem In Items
		item.View.SetLayoutAnimated(200, anchorX, currentY, item.View.Width, item.View.Height)
		currentY = currentY + item.View.Height
		If item.Duration > 0 Then
			Try
				If item.Progress.IsInitialized And item.Progress.mBase.Parent = Container Then
					currentY = currentY + 2dip
					item.Progress.setLeft(anchorX)
					item.Progress.setTop(currentY)
					item.Progress.Base_Resize(item.View.Width, 4dip)
					currentY = currentY + 4dip
				End If
			Catch
			End Try
		End If
		currentY = currentY + gap
	Next
End Sub

Public Sub Success(Message As String)
	SuccessWithDuration(Message, 0)
End Sub

Public Sub SuccessWithDuration(Message As String, DurationMs As Int)
	CreateAlert(Message, "success", DurationMs)
End Sub

Public Sub Info(Message As String)
	InfoWithDuration(Message, 0)
End Sub

Public Sub InfoWithDuration(Message As String, DurationMs As Int)
	CreateAlert(Message, "info", DurationMs)
End Sub

Public Sub Warning(Message As String)
	WarningWithDuration(Message, 0)
End Sub

Public Sub WarningWithDuration(Message As String, DurationMs As Int)
	CreateAlert(Message, "warning", DurationMs)
End Sub

Public Sub Error(Message As String)
	ErrorWithDuration(Message, 0)
End Sub

Public Sub ErrorWithDuration(Message As String, DurationMs As Int)
	CreateAlert(Message, "error", DurationMs)
End Sub

' Internal helper to create and attach a B4XDaisyAlert
Private Sub CreateAlert(Message As String, Variant As String, DurationMs As Int)
	Dim alert1 As B4XDaisyAlert
	' Use "ToastAlert" as event name so we can handle it here in the class
	alert1.Initialize(Me, "ToastAlert") 
	
	' Create a panel to host the alert
	Dim p As Panel
	p.Initialize("AlertClick") 
	Dim bp As B4XView = p
	bp.SetLayoutAnimated(0, 0, 0, 260dip, 48dip)
	
	' Initialize the alert view
	alert1.DesignerCreateView(bp, Null, CreateMap("Text": Message, "Variant": Variant, "AlertStyle": "solid"))
	
	' Store the alert object in the tag for easy access
	bp.Tag = alert1
	
	If DurationMs > 0 Then
		If mShowProgress Then
			' Resolve the colors for the alert to use for the progress bar
			Dim clrs As Map = alert1.GetVisualColors
			Dim fg As Int = clrs.GetDefault("text", xui.Color_White)
			
			Dim prg As B4XDaisyProgress
			prg.Initialize(Me, "progress")
			' Inject at the bottom of the alert panel (bp)
			Dim prgView As B4XView = prg.AddToParent(bp, 0, 46dip, 260dip, 2dip)
			prg.setMaxValue(DurationMs)
			prg.setValue(DurationMs)
			
			' Set the progress bar color to match the layout
			prg.SetValueColor(fg)
			prg.SetTrackColor(xui.Color_Transparent)
		End If
		AttachWithDuration(bp, DurationMs)
	Else
		Attach(bp)
	End If
End Sub

' Handles clicks on the wrapper panel
Private Sub AlertClick_Click
	Dim bp As B4XView = Sender
	Detach(bp)
End Sub

' Handles clicks forwarded by the B4XDaisyAlert component
Private Sub ToastAlert_Click (Tag As Object)
	For Each item As ToastItem In Items
		' If the view itself was clicked, or it's an alert inside a panel
		' Or if the Tag is the B4XDaisyAlert instance stored in item.View.Tag
		If item.View = Tag Or item.View.Tag = Tag Then
			Detach(item.View)
			Return
		End If
	Next
	
	' Last resort: if Tag is the B4XDaisyAlert object, find its base
	If Tag Is B4XDaisyAlert Then
		Dim alert As B4XDaisyAlert = Tag
		For Each item As ToastItem In Items
			If item.View.Tag = alert Then
				Detach(item.View)
				Return
			End If
		Next
	End If
End Sub

' Modify AttachWithDuration to support pre-attached progress bars
Public Sub AttachWithDuration(View As B4XView, DurationMs As Int)
	If Container.IsInitialized = False Then Return
	Show
	View.RemoveViewFromParent
	
	Dim item As ToastItem
	item.Initialize
	item.View = View
	
	' Check if the view already has a progress bar inside it
	Dim existingProgress As B4XDaisyProgress = Null
	If View.IsInitialized And View.NumberOfViews > 0 Then
		For i = 0 To View.NumberOfViews - 1
			Dim v As B4XView = View.GetView(i)
			If v.Tag Is B4XDaisyProgress Then
				existingProgress = v.Tag
				Exit
			End If
		Next
	End If

	If DurationMs > 0 Then
		item.Duration = DurationMs
		item.StartTime = DateTime.Now
		
		If existingProgress <> Null Then
			item.Progress = existingProgress
		Else If mShowProgress Then
			Dim prg As B4XDaisyProgress
			prg.Initialize(Me, "progress")
			Dim prgView As B4XView = prg.AddToParent(Container, 0, 0, View.Width, 4dip)
			prg.setVariant("info") 
			prg.setMaxValue(DurationMs)
			prg.setValue(DurationMs)
			item.Progress = prg
		End If
		
		Dim t As Timer
		item.Timer = t
		item.Timer.Initialize("Timer", 50)
		item.Timer.Enabled = True
	End If
	
	Items.Add(item)
	Container.AddView(View, 0, 0, View.Width, View.Height)
	RefreshLayout
End Sub

Public Sub Base_Resize (Width As Int, Height As Int)
	RefreshLayout
End Sub

Public Sub setShowProgress(Value As Boolean)
	mShowProgress = Value
End Sub

Public Sub getShowProgress As Boolean
	Return mShowProgress
End Sub
