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

#IgnoreWarnings:12,9
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
	Private inResize As Boolean = False
End Sub

' /**
'  * Stores callback context for the Click event.
'  */
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

' /**
'  * Called by the B4A designer. Builds the component view tree and applies designer props.
'  */
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim pSurface As Panel
    pSurface.Initialize("surface")
    Surface = pSurface
    Surface.Color = xui.Color_Transparent
    mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

'    mOverlayColor = GetPropColor(Props, "OverlayColor", xui.Color_Black)
'    mOpacity = B4XDaisyVariants.GetPropFloat(Props, "Opacity", mOpacity)
'    mRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", mRounded)
'    mPassThrough = B4XDaisyVariants.GetPropBool(Props, "PassThrough", mPassThrough)
'    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
'    mCloseOnClick = B4XDaisyVariants.GetPropBool(Props, "CloseOnClick", mCloseOnClick)
    ApplyDesignerProps(mProps)
    mIsAttached = True
    mIsOpen = mVisible

    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mOverlayColor = GetPropColor(mProps, "OverlayColor", xui.Color_Black)
    mOpacity = Max(0.0, Min(1.0, B4XDaisyVariants.GetPropFloat(mProps, "Opacity", mOpacity)))
    mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)
    mPassThrough = B4XDaisyVariants.GetPropBool(mProps, "PassThrough", mPassThrough)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
    mCloseOnClick = B4XDaisyVariants.GetPropBool(mProps, "CloseOnClick", mCloseOnClick)
End Sub

' /**
'  * Creates the overlay programmatically at the given size.
'  */
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    Dim props As Map = BuildRuntimeProps
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Return mBase
End Sub

' /**
'  * Creates the overlay and adds it as a positioned child of Parent.
'  */
Public Sub GetComputedHeight As Int
	If mBase = Null Then Return 0
    If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub GetActualHeight As Int
    If mBase.IsInitialized Then Return mBase.Height
    Return 0
End Sub

Public Sub GetActualWidth As Int
    If mBase.IsInitialized Then Return mBase.Width
    Return 0
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    Dim empty As B4XView
    If vParent = Null Then Return empty
    If vParent.IsInitialized = False Then Return empty

    If mBase = Null Or mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim props As Map = BuildRuntimeProps
        DesignerCreateView(p, Null, props)
    End If

    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
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
Public Sub AttachTo(vTarget As B4XView) As B4XView
    Dim empty As B4XView
    If vTarget = Null Then Return empty
    If vTarget.IsInitialized = False Then Return empty

    If mBase = Null Or mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        Dim props As Map = BuildRuntimeProps
        DesignerCreateView(p, Null, props)
    End If

    vTarget.AddView(mBase, 0, 0, vTarget.Width, vTarget.Height)
    Base_Resize(mBase.Width, mBase.Height)
    mIsAttached = True
    mIsOpen = True
    Return mBase
End Sub

' /**
'  * Resizes the Surface to fill mBase. Called on layout changes.
'  */
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase = Null Then Return
    If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    Surface.SetLayoutAnimated(0, 0, 0, Max(1dip, dWidth), Max(1dip, dHeight))
    inResize = False
End Sub

' /**
'  * Resizes mBase and its Surface to the given dimensions.
'  * Call this from the host page's Resize event instead of manipulating mBase directly.
'  */
Public Sub Resize(iWidth As Int, iHeight As Int)
    If mBase = Null Then Return
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    Base_Resize(iWidth, iHeight)
End Sub

' Convenience helper to add a child view directly onto the overlay surface.
Public Sub AddChild(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase <> Null And mBase.IsInitialized Then
        mBase.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
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
    If mBase = Null Then Return
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
Public Sub setOverlayColor(iValue As Int)
    mOverlayColor = iValue
    If mBase = Null Then Return
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getOpacity As Float
    Return mOpacity
End Sub

' /**
'  * Sets opacity in the range 0.0-1.0. Values outside are clamped automatically.
'  */
Public Sub setOpacity(fValue As Float)
    mOpacity = Max(0.0, Min(1.0, fValue))
    If mBase = Null Then Return
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

' /**
'  * Sets the corner radius token, e.g. "rounded-lg" or "none".
'  */
Public Sub setRounded(sValue As String)
    mRounded = sValue
    If mBase = Null Then Return
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPassThrough As Boolean
    Return mPassThrough
End Sub

' /**
'  * When True, the overlay panel is disabled so touches pass through to views below.
'  */
Public Sub setPassThrough(bValue As Boolean)
    mPassThrough = bValue
    If mBase = Null Then Return
    If mBase.IsInitialized = False Then Return
    Surface.Enabled = Not(bValue)
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setVisible(bValue As Boolean)
    mVisible = bValue
    If mBase <> Null And mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getCloseOnClick As Boolean
    Return mCloseOnClick
End Sub

' /**
'  * When True, clicking/tapping the overlay calls Close automatically.
'  */
Public Sub setCloseOnClick(bValue As Boolean)
    mCloseOnClick = bValue
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
    If mBase <> Null And mBase.IsInitialized Then
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
Private Sub GetPropColor(mProps As Map, sKey As String, iDefaultValue As Int) As Int
    If mProps.IsInitialized = False Then Return iDefaultValue
    If mProps.ContainsKey(sKey) = False Then Return iDefaultValue
    Return xui.PaintOrColorToColor(mProps.Get(sKey))
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

#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
