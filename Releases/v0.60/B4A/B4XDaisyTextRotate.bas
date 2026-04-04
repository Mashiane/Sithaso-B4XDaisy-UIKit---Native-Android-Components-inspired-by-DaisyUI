B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

#Region Designer Properties
#DesignerProperty: Key: Items, DisplayName: Items, FieldType: Int, DefaultValue: 1, Description: The number of items to rotate.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: String, DefaultValue: 3s, Description: The duration of the rotation (e.g., 3s).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Internal views
    Private Container As B4XView
    Private ClippingContainer As B4XView
    
    ' Local properties
    Private mItems As List
    Private mDurationMs As Int = 3000
    Private mVariant As String = "none"
    Private mShadow As String = "none"
    
    ' Animation state
    Private RotationTimer As Timer
    Private CurrentIndex As Int = 0
    Private Animating As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mItems.Initialize
    RotationTimer.Initialize("RotationTimer", 3000) ' Default, will be updated in Refresh
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Create clipping container (shows only 1 item at a time)
    Dim p1 As Panel
    p1.Initialize("")
    ClippingContainer = p1
    mBase.AddView(ClippingContainer, 0, 0, mBase.Width, mBase.Height)
    B4XDaisyVariants.SetOverflowHidden(ClippingContainer)
    
    ' Create internal scrolling container
    Dim p2 As Panel
    p2.Initialize("")
    Container = p2
    Container.Color = xui.Color_Transparent
    ClippingContainer.AddView(Container, 0, 0, mBase.Width, mBase.Height)
    
    ' Load properties
    Dim sDur As String = B4XDaisyVariants.GetPropString(Props, "Duration", "3s")
    setDuration(sDur)
    
    Refresh
End Sub
#End Region

#Region Public API
''' <summary>
''' Forces the component to re-evaluate its styling against the currently active global Theme.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Renders/Refreshes the component state.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    ' Apply elevation
    If mShadow <> "none" Then
        B4XDaisyVariants.ApplyElevation(mBase, mShadow)
    End If
    
    ' Reset timer if items exist
    RotationTimer.Enabled = False
    If mItems.Size > 1 Then
        RotationTimer.Interval = mDurationMs
        RotationTimer.Enabled = True
    End If
    
    ' Rebuild container from current item list then trigger layout
    RebuildContainer
    Base_Resize(mBase.Width, mBase.Height)
End Sub

''' <summary>
''' Rebuilds the Container panel from the current mItems list.
''' After all items are rendered, measures the tallest GetComputedHeight
''' and expands mBase/ClippingContainer if any item exceeds the initial height.
''' Called by Refresh whenever items or layout change.
''' </summary>
Private Sub RebuildContainer
    If Container.IsInitialized = False Then Return
    Container.RemoveAllViews
    Dim W As Int = Max(1dip, mBase.Width)
    Dim H As Int = Max(1dip, mBase.Height)
    ' First pass: add and render all items at current height
    For i = 0 To mItems.Size - 1
        Dim dt As B4XDaisyText
        dt = mItems.Get(i)
        dt.AddToParent(Container, 0, 0, W, H)
        dt.RefreshText
    Next
    ' Measure tallest item - expand mBase if any item overflows the slot
    Dim maxH As Int = H
    For i = 0 To mItems.Size - 1
        Dim dt As B4XDaisyText
        dt = mItems.Get(i)
        Dim ch As Int = dt.GetComputedHeight
        If ch > maxH Then maxH = ch
    Next
    If maxH > H Then
        mBase.Height = maxH
        ClippingContainer.Height = maxH
        ' Re-size all items to the expanded slot height
        For i = 0 To mItems.Size - 1
            Dim dt As B4XDaisyText
            dt = mItems.Get(i)
            Dim dtv As B4XView = dt.View
            dtv.Height = maxH
        Next
        H = maxH
    End If
    ' Seamless wrap: copy of first item appended at end for smooth looping.
    ' ALL visual properties must match item[0] exactly or the transition looks wrong.
    If mItems.Size > 1 Then
        Dim first As B4XDaisyText
        first = mItems.Get(0)
        Dim wrap As B4XDaisyText
        wrap.Initialize(mCallBack, "")
        wrap.AddToParent(Container, 0, 0, W, H)
        wrap.Text = first.getText
        wrap.setVariant(first.getVariant)
        wrap.setTextSize(first.getTextSize)
        wrap.setFontBold(first.getFontBold)
        wrap.setSingleLine(first.getSingleLine)
        wrap.setHAlign(first.getHAlign)
        wrap.setTextColor(first.getTextColor)
        wrap.setAutoResize(first.getAutoResize)
        wrap.RefreshText
    End If
End Sub

''' <summary>
''' Convenience method: creates plain B4XDaisyText items from a string list and calls Refresh.
''' For full styling control use AddItem with pre-configured B4XDaisyText objects instead.
''' </summary>
Public Sub SetItems(ItemList As List)
    ClearItems
    If ItemList <> Null Then
        For Each item As String In ItemList
            Dim dt As B4XDaisyText
            dt.Initialize(mCallBack, "")
            dt.Text = item
            dt.setVariant(mVariant)
            dt.setHAlign("CENTER")
            dt.setAutoResize(False)
            AddItem(dt)
        Next
    End If
    Refresh
End Sub

''' <summary>
''' Adds a pre-configured B4XDaisyText item to the rotation list.
''' Call Refresh after adding all items to start rotation.
''' </summary>
Public Sub AddItem(dt As B4XDaisyText)
    mItems.Add(dt)
End Sub

''' <summary>
''' Removes all items from the rotation list and clears the container.
''' </summary>
Public Sub ClearItems
    mItems.Initialize
    CurrentIndex = 0
    If Container.IsInitialized Then Container.RemoveAllViews
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        DesignerCreateView(p, Null, CreateMap())
    End If
    Parent.AddView(mBase, Left, Top, Width, Height)
    Return mBase
End Sub

Public Sub setDuration(Value As String)
    ' Simple parse: "3s" -> 3000, "500ms" -> 500
    Dim v As String = Value.ToLowerCase.Trim
    If v.EndsWith("ms") Then
        mDurationMs = v.Replace("ms", "")
    Else If v.EndsWith("s") Then
        mDurationMs = v.Replace("s", "") * 1000
    Else
        mDurationMs = v
    End If
    If mDurationMs < 100 Then mDurationMs = 100
    Refresh
End Sub

Public Sub getDuration As String
    Return mDurationMs & "ms"
End Sub

Public Sub setVariant(Value As String)
    mVariant = Value
    ' Update children
    If Container.IsInitialized Then
        For i = 0 To Container.NumberOfViews - 1
            Dim v As B4XView = Container.GetView(i)
            If v.Tag <> Null And v.Tag Is B4XDaisyText Then
                Dim txt As B4XDaisyText = v.Tag
                txt.setVariant(mVariant)
            End If
        Next
    End If
End Sub

Public Sub getVariant As String
    Return mVariant
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub getView As B4XView
    Return mBase
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(Width As Double, Height As Double)
    If ClippingContainer.IsInitialized And Height > 0 Then
        ClippingContainer.SetLayoutAnimated(0, 0, 0, Width, Height)
        
        Dim totalItems As Int = Container.NumberOfViews
        Container.SetLayoutAnimated(0, 0, -CurrentIndex * Height, Width, totalItems * Height)
        
        For i = 0 To totalItems - 1
            Dim v As B4XView = Container.GetView(i)
            v.SetLayoutAnimated(0, 0, i * Height, Width, Height)
        Next
    End If
End Sub

Private Sub RotationTimer_Tick
    If mItems.Size <= 1 Or Animating Then Return
    
    ' Detachment safety
    If mBase.IsInitialized = False Or mBase.Parent.IsInitialized = False Then
        RotationTimer.Enabled = False
        Return
    End If
    
    Animating = True
    Dim nextIndex As Int = CurrentIndex + 1
    Dim h As Int = mBase.Height
    
    ' Animate to next item
    Container.SetLayoutAnimated(500, 0, -nextIndex * h, mBase.Width, Container.Height)
    
    Sleep(550) ' Wait for animation
    
    CurrentIndex = nextIndex
    ' seamless wrap check: if we just showed the fake last item (copy of first), reset to 0
    If CurrentIndex >= mItems.Size Then
        CurrentIndex = 0
        Container.SetLayoutAnimated(0, 0, 0, mBase.Width, Container.Height)
    End If
    
    Animating = False
End Sub

#End Region

#Region Cleanup
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region
