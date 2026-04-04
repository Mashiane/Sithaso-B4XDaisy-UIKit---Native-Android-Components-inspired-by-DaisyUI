B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' B4XDaisyOverlay
' A translucent surface that can be layered over any B4XView.
' Use AttachTo(target) to cover a target view, or AddToParent for explicit placement.

#Event: Click (Tag As Object)
#Event: Opened (Tag As Object)
#Event: Closed (Tag As Object)

#DesignerProperty: Key: OverlayColor, DisplayName: Overlay Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Base RGB color of the overlay surface. Alpha channel is overridden by Opacity.
#DesignerProperty: Key: Opacity, DisplayName: Opacity, FieldType: Float, DefaultValue: 0.4, Description: Surface opacity from 0.0 (fully transparent) to 1.0 (fully opaque).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius token applied to the overlay surface.
#DesignerProperty: Key: PassThrough, DisplayName: Pass Through Touches, FieldType: Boolean, DefaultValue: False, Description: When True the overlay does not intercept touch events (Enabled = False).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: False, Description: Show or hide the overlay.
#DesignerProperty: Key: CloseOnClick, DisplayName: Close On Click, FieldType: Boolean, DefaultValue: False, Description: When True, clicking the overlay automatically closes it and fires the Closed event.

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    ' Backing properties
    Private mOverlayColor As Int = 0xFF000000
    Private mOpacity As Float = 0.4
    Private mRounded As String = "none"
    Private mPassThrough As Boolean = False
    Private mVisible As Boolean = False
    Private mCloseOnClick As Boolean = False
    ' True once AttachTo / AddToParent / DesignerCreateView has been called.
    ' Callers can check IsAttached instead of maintaining their own ready flag.
    Private mIsAttached As Boolean = False
    ' Tracks whether the overlay is currently considered open (visible).
    Private mIsOpen As Boolean = False

    ' The coloured + clipped surface panel
    Private Surface As B4XView
End Sub

' /**
'  * Stores callback context for the Click event.
'  */
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

' /**
'  * Called by the B4A designer. Builds the component view tree and applies designer props.
'  */
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim pSurface As Panel
    pSurface.Initialize("surface")
    Surface = pSurface
    Surface.Color = xui.Color_Transparent
    mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

    mOverlayColor = GetPropColor(Props, "OverlayColor", xui.Color_Black)
    mOpacity = B4XDaisyVariants.GetPropFloat(Props, "Opacity", 0.4)
    mOpacity = Max(0.0, Min(1.0, mOpacity))
    mRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", "none")
    mPassThrough = B4XDaisyVariants.GetPropBool(Props, "PassThrough", False)
    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    mCloseOnClick = B4XDaisyVariants.GetPropBool(Props, "CloseOnClick", False)
    mIsAttached = True
    mIsOpen = mVisible

    Refresh
End Sub

' /**
'  * Creates the overlay programmatically at the given size.
'  */
Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, Width, Height)
    Dim props As Map = BuildRuntimeProps
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Return mBase
End Sub

' /**
'  * Creates the overlay and adds it as a positioned child of Parent.
'  */
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim props As Map = BuildRuntimeProps
        DesignerCreateView(p, Null, props)
    End If

    Parent.AddView(mBase, Left, Top, Width, Height)
    Base_Resize(mBase.Width, mBase.Height)
    mIsAttached = True
    mIsOpen = True
    Return mBase
End Sub

' /**
'  * Attaches the overlay directly on top of Target, covering it at (0, 0, Target.Width, Target.Height).
'  * The overlay is added as the last child of Target so it renders above existing content.
'  * Returns mBase for chaining or assignment.
'  */
Public Sub AttachTo(Target As B4XView) As B4XView
    Dim empty As B4XView
    If Target.IsInitialized = False Then Return empty

    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim props As Map = BuildRuntimeProps
        DesignerCreateView(p, Null, props)
    End If

    Target.AddView(mBase, 0, 0, Target.Width, Target.Height)
    Base_Resize(mBase.Width, mBase.Height)
    mIsAttached = True
    mIsOpen = True
    Return mBase
End Sub

' /**
'  * Resizes the Surface to fill mBase. Called on layout changes.
'  */
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
    Surface.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
End Sub

' /**
'  * Resizes mBase and its Surface to the given dimensions.
'  * Call this from the host page's Resize event instead of manipulating mBase directly.
'  */
Public Sub Resize(Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(0, 0, 0, Width, Height)
    Base_Resize(Width, Height)
End Sub

' Convenience helper to add a child view directly onto the overlay surface.
Public Sub AddChild(View As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized Then
        mBase.AddView(View, Left, Top, Width, Height)
    End If
End Sub

Public Sub GetHostView As B4XView
    Return mBase
End Sub

' /**
'  * Rebuilds the overlay color and applies it to the Surface panel.
'  * Alpha is computed from Opacity; RGB comes from OverlayColor.
'  */
Private Sub Refresh
    If mBase.IsInitialized = False Then Return

    Dim alpha As Int = Min(255, Max(0, Round(mOpacity * 255)))
    Dim r As Int = Bit.And(Bit.ShiftRight(mOverlayColor, 16), 0xFF)
    Dim g As Int = Bit.And(Bit.ShiftRight(mOverlayColor, 8), 0xFF)
    Dim b4 As Int = Bit.And(mOverlayColor, 0xFF)
    Dim computedColor As Int = xui.Color_ARGB(alpha, r, g, b4)

    Dim radiusDip As Float = B4XDaisyVariants.ResolveRoundedDip(mRounded, 0)
    If radiusDip > 0 Then
        Surface.SetColorAndBorder(computedColor, 0, computedColor, radiusDip)
    Else
        Surface.Color = computedColor
    End If

    Surface.Enabled = Not(mPassThrough)
    mBase.Visible = mVisible
    Base_Resize(mBase.Width, mBase.Height)
End Sub

' -- Getters / Setters --

Public Sub getOverlayColor As Int
    Return mOverlayColor
End Sub

' /**
'  * Sets the overlay base color. Alpha from OverlayColor is ignored; use Opacity instead.
'  */
Public Sub setOverlayColor(Value As Int)
    mOverlayColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getOpacity As Float
    Return mOpacity
End Sub

' /**
'  * Sets opacity in the range 0.0�1.0. Values outside are clamped automatically.
'  */
Public Sub setOpacity(Value As Float)
    mOpacity = Max(0.0, Min(1.0, Value))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

' /**
'  * Sets the corner radius token, e.g. "rounded-lg" or "none".
'  */
Public Sub setRounded(Value As String)
    mRounded = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPassThrough As Boolean
    Return mPassThrough
End Sub

' /**
'  * When True, the overlay panel is disabled so touches pass through to views below.
'  */
Public Sub setPassThrough(Value As Boolean)
    mPassThrough = Value
    If mBase.IsInitialized = False Then Return
    Surface.Enabled = Not(Value)
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setVisible(Value As Boolean)
    mVisible = Value
    If mBase.IsInitialized Then mBase.Visible = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getCloseOnClick As Boolean
    Return mCloseOnClick
End Sub

' /**
'  * When True, clicking/tapping the overlay calls Close automatically.
'  */
Public Sub setCloseOnClick(Value As Boolean)
    mCloseOnClick = Value
End Sub

' /**
'  * Read-only. True once AttachTo / AddToParent has been called.
'  * Use this instead of maintaining an external ready flag.
'  */
Public Sub getIsAttached As Boolean
    Return mIsAttached
End Sub

' /**
'  * Read-only. True while the overlay is currently open (visible).
'  */
Public Sub getIsOpen As Boolean
    Return mIsOpen
End Sub

' /**
'  * Makes the overlay visible and fires the Opened event.
'  */
Public Sub Open
    mIsOpen = True
    setVisible(True)
    ' Raise to top so it renders above any views added after AttachTo.
    If mBase.IsInitialized Then
        Dim jo As JavaObject = mBase
        jo.RunMethod("bringToFront", Null)
    End If
    CallSubDelayed2(mCallBack, mEventName & "_Opened", mTag)
End Sub

' /**
'  * Hides the overlay and fires the Closed event.
'  */
Public Sub Close
    mIsOpen = False
    setVisible(False)
    CallSubDelayed2(mCallBack, mEventName & "_Closed", mTag)
End Sub

' -- Events --

Private Sub Surface_Click
    If mCloseOnClick Then Close
    CallSubDelayed2(mCallBack, mEventName & "_Click", mTag)
End Sub

' -- Helpers --

' /**
'  * Reads a Color (Int) value from Props using the XUI paint-to-color helper.
'  */
Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
    If Props.IsInitialized = False Then Return DefaultValue
    If Props.ContainsKey(Key) = False Then Return DefaultValue
    Return xui.PaintOrColorToColor(Props.Get(Key))
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "OverlayColor": mOverlayColor, _
        "Opacity": mOpacity, _
        "Rounded": mRounded, _
        "PassThrough": mPassThrough, _
        "Visible": mVisible, _
        "CloseOnClick": mCloseOnClick)
End Sub
