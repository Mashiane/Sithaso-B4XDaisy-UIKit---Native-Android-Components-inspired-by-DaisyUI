B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

' B4XDaisyAura - daisyUI "aura" wrapper (https://daisyui.com/components/aura/)
'
' A decorative wrapper that draws a rotating conic-gradient "border light"
' around any child (card, button, div). The child sits in a fixed slot on
' top; only the conic ring behind it rotates, so the child never moves.
'
' Styles: default | glow | dual | rainbow | holo | gold | silver
' Sizes : xs | sm | md | lg | xl   (ring thickness + inset)
' Color : optional single-color override (applies to default/dual/glow only;
'         rainbow/holo/gold/silver are multi-color by definition).
' Duration : rotation period in ms (glow ignores it).
'
' Rendering (proven primitives, no shaders - none exist in this repo):
'   - Conic disc drawn as N filled pie wedges on a B4XCanvas (pnlConic).
'   - pnlConic rotates 0->360 via android RotateAnimation INFINITE
'     (cloned from B4XDaisyCanvasSpinner.StartNativeRotation).
'   - A fixed parent panel (pnlClip) carries a rounded-rect outline +
'     setClipToOutline(True) so the rotating disc is clipped to the child's
'     rounded shape. The clip host never rotates, so the rounded outline
'     stays fixed while only the conic colors rotate - the daisyUI look.
'
' Regression safety: this is a brand-new, self-contained class. It edits no
' existing component. The only leak surface is the infinite RotateAnimation;
' Release() clears it and nulls the callback (mirrors CanvasSpinner).

#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: default, List: default|glow|dual|rainbow|holo|gold|silver, Description: Aura color scheme.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Ring thickness / inset token.
#DesignerProperty: Key: Color, DisplayName: Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Optional single-color override (default/dual/glow only). Transparent = use style palette.
#DesignerProperty: Key: TextColor, DisplayName: Text Color (Light Beam), FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Alias for Color (Tailwind text-* light beam color).
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Optional container background color override.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Ring corner radius token.
#DesignerProperty: Key: Duration, DisplayName: Duration (ms), FieldType: Int, DefaultValue: 3000, MinRange: 100, Description: Rotation period in milliseconds. Glow ignores this.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide the aura.
#DesignerProperty: Key: AutoStart, DisplayName: AutoStart, FieldType: Boolean, DefaultValue: True, Description: Start the rotating ring automatically once the aura is attached to the screen.

#IgnoreWarnings:12,9

Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mCallBack As Object
    Private mEventName As String
    Private mTag As Object

    ' child panels
    Private pnlClip As B4XView    ' fixed rounded-rect clip host (never rotates)
    Private pnlConic As B4XView  ' canvas panel that draws the conic disc and rotates
    Private cvsConic As B4XCanvas
    Private pnlSlot As B4XView    ' holds the wrapped child, inset by ring thickness

    ' state
    Private canvasesInitialized As Boolean = False
    Private mRotationRunning As Boolean = False
    Private mAppliedDuration As Int = 0
    Private inResize As Boolean = False
#If B4A
    Private tAuto As Timer
    Private attachAttempts As Int = 0
#End If
    Private mAngle As Float = 0
    Private tAnim As Timer

    ' properties
    Private mStyle As String = "default"
    Private mSize As String = "md"
    Private mColor As Int = xui.Color_Transparent
    Private mBackgroundColor As Int = xui.Color_Transparent
    Private mTextColor As Int = xui.Color_Transparent
    Private mRounded As String = "theme"
    Private mDuration As Int = 3000
    Private mVisible As Boolean = True
    Private mAutoStart As Boolean = True
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mBase = xui.CreatePanel("")
    mBase.SetLayoutAnimated(0, 0, 0, 100dip, 100dip)
    mBase.Color = xui.Color_Transparent
    BuildPanels
    #If B4A
    tAuto.Initialize("tAuto", 100)
    #End If
End Sub

Private Sub BuildPanels
    Dim pc As Panel : pc.Initialize("") : pnlClip = pc
    pnlClip.Color = xui.Color_Transparent
    mBase.AddView(pnlClip, 0, 0, 0, 0)

    Dim pn As Panel : pn.Initialize("") : pnlConic = pn
    pnlConic.Color = xui.Color_Transparent
    pnlClip.AddView(pnlConic, 0, 0, 0, 0)

    Dim ps As Panel : ps.Initialize("") : pnlSlot = ps
    pnlSlot.Color = xui.Color_Transparent
    mBase.AddView(pnlSlot, 0, 0, 0, 0)
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    mBase.RemoveAllViews
    BuildPanels
    ApplyDesignerProps(mProps)
    Base_Resize(mBase.Width, mBase.Height)
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mStyle = NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "Style", mStyle))
    mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
    mColor = B4XDaisyVariants.GetPropColor(mProps, "Color", mColor)
    mColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mColor)
    mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
    mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
    mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)

    ' Backward compatibility: migrate legacy RoundedBox=True designer prop
    If mProps.ContainsKey("RoundedBox") Then
        Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
        If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
            mRounded = "rounded-box"
        End If
    End If
    mDuration = Max(100, B4XDaisyVariants.GetPropInt(mProps, "Duration", mDuration))
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
    mAutoStart = B4XDaisyVariants.GetPropBool(mProps, "AutoStart", mAutoStart)
End Sub

' Width/Height are the intended CHILD size; the wrapper grows by 2*thickness
' on each side so the ring sits outside the child edge (daisyUI semantics).
' Set style/size/color/duration BEFORE AddToParent so the wrapper is sized
' with the right thickness.
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then Return mBase
    Dim thick As Int = ResolveThicknessDip
    Dim wrapW As Int = Max(1dip, iWidth + 2 * thick)
    Dim wrapH As Int = Max(1dip, iHeight + 2 * thick)
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    vParent.AddView(mBase, iLeft, iTop, wrapW, wrapH)
    Refresh
    Return mBase
End Sub

' Reparent an already-created card/button into the aura slot.
' Usage: aura.AddToParent(host, x, y, childW, childH) : aura.Wrap(card.View)
Public Sub Wrap(vChild As B4XView) As B4XView
    If mBase.IsInitialized = False Then Return mBase
    If vChild.IsInitialized = False Then Return mBase
    If vChild.Parent.IsInitialized Then vChild.RemoveViewFromParent
    pnlSlot.AddView(vChild, 0, 0, pnlSlot.Width, pnlSlot.Height)
    Return mBase
End Sub

' Returns the slot panel for manual AddView (Fieldset-style).
Public Sub getContentContainer As B4XView
    Return pnlSlot
End Sub

Public Sub getContainer As B4XView
    Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True

    Dim w As Int = Max(1dip, dWidth)
    Dim h As Int = Max(1dip, dHeight)
    Dim thick As Int = ResolveThicknessDip
    Dim sl As Int = Max(0, thick)

    pnlClip.SetLayoutAnimated(0, 0, 0, w, h)
    ApplyRoundedClip(pnlClip, ResolveRadiusDip)

    pnlConic.SetLayoutAnimated(0, 0, 0, w, h)
    InitCanvasIfNeeded(w, h)
    If canvasesInitialized Then
        Try 
			cvsConic.Resize(w, h) 
		Catch 
		End Try
    End If

    pnlSlot.SetLayoutAnimated(0, sl, sl, Max(1dip, w - 2 * sl), Max(1dip, h - 2 * sl))

    DrawConic
    ' canvas may have just become ready - try to start the ring now / on attach
    #If B4A
    SyncRotation
    #End If
    inResize = False
End Sub

Private Sub InitCanvasIfNeeded(iW As Int, iH As Int)
    If canvasesInitialized Then Return
    If iW <= 0 Or iH <= 0 Then Return
    Try
        cvsConic.Initialize(pnlConic)
        canvasesInitialized = True
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAura.InitCanvasIfNeeded: " & LastException.Message)
    End Try
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    If inResize = False Then Base_Resize(mBase.Width, mBase.Height)
    SyncRotation
    mBase.Visible = mVisible
End Sub

' Restart rotation to pick up a new style or duration. Used by setStyle/setDuration.
Private Sub RestartRotation
    #If B4A
    StopAuraRotation
    StartAuraRotation
    #End If
End Sub

' Start only if needed; never restarts an already-running animation (avoids jumps).
' Public so the demo can call it explicitly after Wrap (proven CanvasSpinner Show() timing).
' AutoStart: when the aura is not yet window-attached (page still appearing), a short
' retry Timer fires on attach and starts the ring - mirrors CanvasSpinner starting in
' Show()/DesignerCreateView once the view is on screen.
Public Sub SyncRotation
    #If B4A
    Dim attached As Boolean = IsAttachedToWindow
    Dim wantRotate As Boolean = (mVisible And mAutoStart And mStyle <> "glow" And canvasesInitialized)
    If wantRotate And attached And mRotationRunning = False Then
        StartAuraRotation
    Else If wantRotate And attached = False And mRotationRunning = False Then
        ' not on screen yet - retry until the view lands on a window
        StartAutoRetry
    Else If wantRotate = False And mRotationRunning Then
        StopAuraRotation
    End If
    #End If
End Sub

#if B4A
' True only when mBase is attached to a real window. mBase.Parent is set as soon as
' AddView runs (often before the page is on screen), so the parent check is not enough;
' RotateAnimation started before window attach does not play.
Private Sub IsAttachedToWindow As Boolean
    Try
        Dim jo As JavaObject = mBase
        Return jo.RunMethod("isAttachedToWindow", Null)
    Catch
        Return False
    End Try
End Sub

Private Sub StartAutoRetry
    If tAuto.IsInitialized = False Then Return
    attachAttempts = 0
    If tAuto.Enabled = False Then tAuto.Enabled = True
End Sub

Private Sub tAuto_Tick
    attachAttempts = attachAttempts + 1
    SyncRotation
    If mRotationRunning Then
        tAuto.Enabled = False
    Else If attachAttempts > 50 Then
        ' ~5s, give up so the timer never leaks if the view never attaches
        tAuto.Enabled = False
    End If
End Sub
#End If

' Convenience: explicit start after the child is wrapped and the view is attached.
Public Sub StartRotation
    If mVisible = False Then Return
    If canvasesInitialized = False And pnlConic.IsInitialized Then
        InitCanvasIfNeeded(pnlConic.Width, pnlConic.Height)
        DrawConic
    End If
    If tAnim.IsInitialized = False Then
        tAnim.Initialize("tAnim", 25)
    End If
    tAnim.Enabled = True
    mRotationRunning = True
    #If B4A
    SyncRotation
    #End If
End Sub

Public Sub StopRotation
    If tAnim.IsInitialized Then tAnim.Enabled = False
    #If B4A
    If tAuto.IsInitialized Then tAuto.Enabled = False
    #End If
    mRotationRunning = False
End Sub

#Region Draw

Private Sub DrawConic
    If canvasesInitialized = False Then Return
    Dim w As Float = pnlConic.Width
    Dim h As Float = pnlConic.Height
    If w <= 0 Or h <= 0 Then Return
    Try
        cvsConic.ClearRect(cvsConic.TargetRect)
        Dim cx As Float = w / 2
        Dim cy As Float = h / 2
        Dim radius As Float = Sqrt(Power(w / 2, 2) + Power(h / 2, 2)) ' half-diagonal covers corners
        Dim palette As List = BuildPalette
        Dim n As Int = palette.Size
        Dim stepAngle As Float = 360.0 / n
        For i = 0 To n - 1
            Dim a0 As Float = -90 + mAngle + i * stepAngle
            Dim a1 As Float = a0 + stepAngle
            Dim col As Int = palette.Get(i)
            Dim p As B4XPath = CreateWedgePath(cx, cy, radius, a0, a1)
            cvsConic.DrawPath(p, col, True, 0)
        Next
        cvsConic.Invalidate
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAura.DrawConic: " & LastException.Message)
    End Try
End Sub

' Filled pie wedge from center between a0 and a1 (degrees, clockwise from top).
Private Sub CreateWedgePath(fCx As Float, fCy As Float, fRadius As Float, fA0 As Float, fA1 As Float) As B4XPath
    #If B4A
    Dim np As JavaObject
    np.InitializeNewInstance("android.graphics.Path", Null)
    Dim rectF As JavaObject
    rectF.InitializeNewInstance("android.graphics.RectF", Array As Object(fCx - fRadius, fCy - fRadius, fCx + fRadius, fCy + fRadius))
    np.RunMethod("addArc", Array As Object(rectF, fA0, fA1 - fA0))
    np.RunMethod("lineTo", Array As Object(fCx, fCy))
    np.RunMethod("close", Null)
    Dim p As B4XPath = np
    Return p
    #Else
    Dim p As B4XPath
    p.InitializeArc(fCx, fCy, fRadius, fA0, fA1 - fA0)
    Return p
    #End If
End Sub

' Returns a List of Int (ARGB) colors, one per wedge.
Private Sub BuildPalette As List
    Dim pal As List : pal.Initialize
    Dim baseColor As Int = ResolveBaseColor
    Select Case mStyle
        Case "glow"
            ' steady uniform ring, no rotation
            Dim n As Int = 12
            Dim c As Int = B4XDaisyVariants.SetAlpha(baseColor, 120)
            For i = 0 To n - 1 : pal.Add(c) : Next
        Case "default"
            AddCometPalette(pal, baseColor, 36, False)
        Case "dual"
            AddCometPalette(pal, baseColor, 36, True)
        Case "rainbow"
            pal.Add(0xFFFF0000) : pal.Add(0xFFFF7F00) : pal.Add(0xFFFFFF00)
            pal.Add(0xFF7FFF00) : pal.Add(0xFF00FF00) : pal.Add(0xFF00FF7F)
            pal.Add(0xFF00FFFF) : pal.Add(0xFF007FFF) : pal.Add(0xFF0000FF)
            pal.Add(0xFF7F00FF) : pal.Add(0xFFFF00FF) : pal.Add(0xFFFF007F)
        Case "holo"
            Dim cols() As Int = Array As Int(0xFF00E5FF, 0xFFFF00AA, 0xFFFFFF00, 0xFFFF66FF, 0xFF00E5FF, 0xFFFF00AA, 0xFFFFFF00, 0xFFFF66FF)
            For Each c As Int In cols : pal.Add(c) : Next
        Case "gold"
            Dim cols2() As Int = Array As Int(0xFFFFD700, 0xFFFFC107, 0xFFFFB300, 0xFFFFA000, 0xFFFFDF80, 0xFFE6B800, 0xFFFFE066, 0xFFFFB820, 0xFFFFD700, 0xFFC9A227, 0xFFFFC933, 0xFFD4AF37)
            For Each c As Int In cols2 : pal.Add(c) : Next
        Case "silver"
            Dim cols3() As Int = Array As Int(0xFFE5E4E2, 0xFFD0D0D0, 0xFFC0C0C0, 0xFFB0B0B0, 0xFFE8E8E8, 0xFFC8C8C8, 0xFFD8D8D8, 0xFFBEBEBE, 0xFFE0E0E0, 0xFFCACACA, 0xFFD3D3D3, 0xFFB8B8B8)
            For Each c As Int In cols3 : pal.Add(c) : Next
    End Select
    If pal.Size = 0 Then pal.Add(baseColor)
    Return pal
End Sub

' Comet palette: N wedges with alpha falling off via cosine.
' Dual = two opposite lobes (abs(cos)); single = one lobe (max(0, cos)).
Private Sub AddCometPalette(lstPal As List, iBaseColor As Int, iN As Int, bDual As Boolean)
    For i = 0 To iN - 1
        Dim ang As Float = i * (360.0 / iN)
        Dim c As Float = CosD(ang)
        Dim a As Float = IIf(bDual, Abs(c), Max(0, c))
        Dim alpha As Int = Max(0, Min(255, Round(255 * a)))
        lstPal.Add(B4XDaisyVariants.SetAlpha(iBaseColor, alpha))
    Next
End Sub

' Base color for single-color styles. Override > primary token > fallback blue.
Private Sub ResolveBaseColor As Int
    If IsTransparentColor(mTextColor) = False Then Return mTextColor
    If IsTransparentColor(mColor) = False Then Return mColor
    Return B4XDaisyVariants.GetTokenColor("--color-primary", 0xFF3B82F6)
End Sub

#End Region

#Region Clip + Rotation (B4A native)

#If B4A
' Give a Panel a transparent rounded-rect background + outline + clipToOutline so
' its children (the rotating conic) are clipped to a FIXED rounded-rect shape.
' Mirrors the outline technique in B4XDaisyVariants.ApplyElevation.
Private Sub ApplyRoundedClip(vTarget As B4XView, fRadiusPx As Float)
    Try
        Dim jo As JavaObject = vTarget
        Dim gd As JavaObject
        gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        gd.RunMethod("setCornerRadius", Array As Object(fRadiusPx))
        If IsTransparentColor(mBackgroundColor) Then
            gd.RunMethod("setColor", Array As Object(0)) ' transparent
        Else
            gd.RunMethod("setColor", Array As Object(mBackgroundColor))
        End If
        jo.RunMethod("setBackground", Array As Object(gd))
        Dim ovp As JavaObject
        ovp.InitializeStatic("android.view.ViewOutlineProvider")
        jo.RunMethod("setOutlineProvider", Array As Object(ovp.GetField("BACKGROUND")))
        jo.RunMethod("setClipToOutline", Array As Object(True))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAura.ApplyRoundedClip: " & LastException.Message)
    End Try
End Sub

Private Sub tAnim_Tick
    If mVisible = False Or canvasesInitialized = False Then Return
    Dim dur As Float = Max(100, mDuration)
    mAngle = (mAngle + (25.0 / dur) * 360.0)
    If mAngle >= 360.0 Then mAngle = mAngle - 360.0
    DrawConic
End Sub

Private Sub StartAuraRotation
    If mBase.IsInitialized = False Then Return
    StopAuraRotation
    If tAnim.IsInitialized = False Then
        tAnim.Initialize("tAnim", 25)
    End If
    tAnim.Enabled = True
    mRotationRunning = True
End Sub

Private Sub StopAuraRotation
    If tAnim.IsInitialized Then tAnim.Enabled = False
    mRotationRunning = False
End Sub
#End If

#End Region

#Region Resolve helpers

Private Sub ResolveThicknessDip As Int
    Select Case B4XDaisyVariants.NormalizeSize(mSize)
        Case "xs" : Return 2dip
        Case "sm" : Return 3dip
        Case "lg" : Return 6dip
        Case "xl" : Return 8dip
        Case Else : Return 4dip ' md
    End Select
End Sub

Private Sub ResolveRadiusDip As Float
    Dim s As String = IIf(mRounded = Null, "theme", mRounded.ToLowerCase.Trim)
    If s = "theme" Or s = "" Then
        If mRounded = "rounded-box" Or mRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(12dip)
        Return B4XDaisyVariants.GetRadiusFieldDip(8dip)
    End If
    Return B4XDaisyVariants.ResolveRoundedDip(s, 12dip)
End Sub

Private Sub NormalizeStyle(sValue As String) As String
    Dim s As String = IIf(sValue = Null, "", sValue.ToLowerCase.Trim)
    Select Case s
        Case "default", "glow", "dual", "rainbow", "holo", "gold", "silver"
            Return s
        Case Else
            Return "default"
    End Select
End Sub

Private Sub IsTransparentColor(iValue As Int) As Boolean
    Return Bit.And(Bit.ShiftRight(iValue, 24), 0xFF) = 0
End Sub

#End Region

#Region Setters / Getters

Public Sub setStyle(sValue As String)
    Dim newStyle As String = NormalizeStyle(sValue)
    If newStyle = mStyle And mBase.IsInitialized Then Return
    mStyle = newStyle
    If mBase.IsInitialized = False Then Return
    Refresh
    #If B4A
    RestartRotation
    #End If
End Sub

Public Sub getStyle As String
    Return mStyle
End Sub

Public Sub setSize(sValue As String)
    mSize = B4XDaisyVariants.NormalizeSize(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSize As String
    Return mSize
End Sub

Public Sub setColor(iValue As Int)
    mColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getColor As Int
    Return mColor
End Sub

Public Sub setRounded(sValue As String)
    mRounded = IIf(sValue = Null, "theme", sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
    If bValue Then
        setRounded("rounded-box")
    Else
        setRounded("rounded-none")
    End If
End Sub

Public Sub getRoundedBox As Boolean
    Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setDuration(iValue As Int)
    mDuration = Max(100, iValue)
    If mBase.IsInitialized = False Then Return
    #If B4A
    RestartRotation
    #End If
End Sub

Public Sub getDuration As Int
    Return mDuration
End Sub

Public Sub setVisible(bValue As Boolean)
    mVisible = bValue
    If mBase.IsInitialized = False Then Return
    mBase.Visible = mVisible
    #If B4A
    If mVisible Then SyncRotation Else StopAuraRotation
    #End If
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setAutoStart(bValue As Boolean)
    mAutoStart = bValue
    If mBase.IsInitialized = False Then Return
    #If B4A
    If mAutoStart Then
        SyncRotation
    Else If mRotationRunning Then
        StopAuraRotation
    End If
    #End If
End Sub

Public Sub getAutoStart As Boolean
    Return mAutoStart
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

#End Region

#Region B4XView wrappers

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    Base_Resize(iWidth, iHeight)
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

Public Sub BringToFront
    If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
    If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub GetComputedHeight As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Height
End Sub

#End Region

' Must be called when the aura is destroyed (page teardown). Stops the infinite
' animation and releases the canvas so it cannot leak or keep running off-screen.
Public Sub Release
    #If B4A
    StopAuraRotation
    If tAuto.IsInitialized Then tAuto.Enabled = False
    If tAnim.IsInitialized Then tAnim.Enabled = False
    #End If
    Try
        If canvasesInitialized Then cvsConic.Release
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyAura.Release: " & LastException.Message)
    End Try
    If pnlSlot.IsInitialized Then pnlSlot.RemoveAllViews
    mCallBack = Null
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mBackgroundColor = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
    setColor(iValue)
End Sub

Public Sub getTextColor As Int
    Return getColor
End Sub

#Region Base Properties
Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Width = iValue
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Height = iValue
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub
#End Region
