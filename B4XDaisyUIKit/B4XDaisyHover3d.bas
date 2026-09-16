B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: Click (Tag As Object)
#End Region

' Daisy docs token evidence for parity and source traceability:
' hover-3d
' cursor-pointer
' card
' card-body
' bg-black
' text-white
' bg-[radial-gradient(circle_at_bottom_left,#ffffff04_35%,transparent_36%),radial-gradient(circle_at_top_right,#ffffff04_35%,transparent_36%)]
' bg-size-[4.95em_4.95em]
' flex
' justify-between
' max-w-100
' mb-10
' mb-4
' mx-2
' my-12
' font-bold
' opacity-10
' opacity-20
' opacity-40
' rounded-2xl
' size-1/3
' text-5xl
' text-lg
' text-xs
' w-60
' w-96

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enable or disable pointer interaction.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Controls visibility.
#DesignerProperty: Key: MaxTilt, DisplayName: Max Tilt, FieldType: Float, DefaultValue: 10, Description: Maximum tilt angle in degrees for the hover surface.
#DesignerProperty: Key: ScaleOnHover, DisplayName: Scale On Hover, FieldType: Float, DefaultValue: 1.05, Description: Surface scale applied while hovering.
#DesignerProperty: Key: ShineEffect, DisplayName: Shine Effect, FieldType: Boolean, DefaultValue: True, Description: Shows a highlight sheen on hover.
#DesignerProperty: Key: Perspective, DisplayName: Perspective, FieldType: Float, DefaultValue: 1200, Description: 3D camera distance for the surface.
#DesignerProperty: Key: ResetDuration, DisplayName: Reset Duration, FieldType: Int, DefaultValue: 500, Description: Reset animation duration in milliseconds.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Theme variant for the surface background.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-2xl, List: none|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius token for the hover surface.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Hover shadow intensity.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-0, Description: Tailwind-style padding utilities for hosted content.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue: , Description: Tailwind-style margin utilities for the outer host.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind size token or CSS size for the host width.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-content, Description: Tailwind size token or CSS size for the host height. Use h-content or h-auto to fit hosted content.
#DesignerProperty: Key: ContentType, DisplayName: Content Type, FieldType: String, DefaultValue: custom, List: custom|image, Description: Mutually exclusive content mode. Use image for internal image rendering or custom for hosted child content.
#DesignerProperty: Key: Image, DisplayName: Image, FieldType: String, DefaultValue: , Description: Asset name or path used when Content Type is image.
#DesignerProperty: Key: ContentBackgroundColor, DisplayName: Content Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional background override for the custom content shell.
#DesignerProperty: Key: ContentRounded, DisplayName: Content Rounded, FieldType: String, DefaultValue: none, List: none|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Border radius token for the custom content shell.
#DesignerProperty: Key: ContentPadding, DisplayName: Content Padding, FieldType: String, DefaultValue: , Description: Tailwind-style padding utilities for the custom content shell.
#DesignerProperty: Key: ContentShadow, DisplayName: Content Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Shadow intensity for the custom content shell.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Optional explicit surface background override.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private pnlShadow As B4XView
    Private pnlSurface As B4XView
    Private pnlImageHost As B4XView
    Private pnlContentHost As B4XView
    Private pnlContentShadow As B4XView
    Private pnlContentShell As B4XView
    Private pnlCustomContent As B4XView
    Private pnlShine As B4XView
    Private lstZones As List
    Private moImageAvatar As B4XDaisyAvatar

    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private mbShineEffect As Boolean = True
    Private mbHovering As Boolean = False

    Private mfMaxTilt As Float = 10
    Private mfScaleOnHover As Float = 1.05
    Private mfPerspective As Float = 1200

    Private miResetDuration As Int = 500

    Private msVariant As String = "none"
    Private msRounded As String = "rounded-2xl"
    Private msShadow As String = "none"
    Private msPadding As String = "p-0"
    Private msMargin As String = ""
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-content"
    Private msContentType As String = "custom"
    Private msImage As String = ""
    Private msContentRounded As String = "none"
    Private msContentPadding As String = ""
    Private msContentShadow As String = "none"

    Private mcBackgroundColor As Int = 0
    Private mcContentBackgroundColor As Int = 0

    Private mfCurrentTiltX As Float = 0
    Private mfCurrentTiltY As Float = 0
    Private mfCurrentScale As Float = 1
    Private mfCurrentShadowDx As Float = 0
    Private mfCurrentShadowDy As Float = 0
    Private mfCurrentShineX As Float = 0.5
    Private mfCurrentShineY As Float = 0.5
    Private mfCurrentDirX As Float = 0
    Private mfCurrentDirY As Float = 0
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then
        mTag = mBase.Tag
    End If
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    ApplyDesignerProps(mProps)
    EnsureViewHierarchy
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    mbShineEffect = B4XDaisyVariants.GetPropBool(mProps, "ShineEffect", mbShineEffect)

    mfMaxTilt = B4XDaisyVariants.GetPropFloat(mProps, "MaxTilt", 10.0)
    mfScaleOnHover = B4XDaisyVariants.GetPropFloat(mProps, "ScaleOnHover", 1.05)
    mfPerspective = B4XDaisyVariants.GetPropFloat(mProps, "Perspective", 1200.0)
    miResetDuration = B4XDaisyVariants.GetPropInt(mProps, "ResetDuration", 500)

    msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
    msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
    msMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", msMargin)
    msWidth = NormalizeSizeToken(B4XDaisyVariants.GetPropString(mProps, "Width", msWidth), "w-full")
    msHeight = NormalizeSizeToken(B4XDaisyVariants.GetPropString(mProps, "Height", msHeight), "h-content")
    msContentType = NormalizeContentType(B4XDaisyVariants.GetPropString(mProps, "ContentType", msContentType))
    msImage = B4XDaisyVariants.GetPropString(mProps, "Image", msImage)
    mcContentBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "ContentBackgroundColor", mcContentBackgroundColor)
    msContentRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "ContentRounded", msContentRounded))
    msContentPadding = B4XDaisyVariants.GetPropString(mProps, "ContentPadding", msContentPadding)
    msContentShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "ContentShadow", msContentShadow))
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Enabled", mbEnabled)
	props.Put("Visible", mbVisible)
	props.Put("MaxTilt", mfMaxTilt)
	props.Put("ScaleOnHover", mfScaleOnHover)
	props.Put("ShineEffect", mbShineEffect)
	props.Put("Perspective", mfPerspective)
	props.Put("ResetDuration", miResetDuration)
	props.Put("Variant", msVariant)
	props.Put("Rounded", msRounded)
	props.Put("Shadow", msShadow)
	props.Put("Padding", msPadding)
	props.Put("Margin", msMargin)
	props.Put("ContentType", msContentType)
	props.Put("Image", msImage)
	props.Put("ContentBackgroundColor", mcContentBackgroundColor)
	props.Put("ContentRounded", msContentRounded)
	props.Put("ContentPadding", msContentPadding)
	props.Put("ContentShadow", msContentShadow)
	props.Put("BackgroundColor", mcBackgroundColor)
	Return props
End Sub

Private Sub EnsureViewHierarchy
    If pnlSurface.IsInitialized Then Return

    pnlShadow = xui.CreatePanel("")
    pnlShadow.Color = xui.Color_ARGB(0, 0, 0, 0)
    mBase.AddView(pnlShadow, 0, 0, 0, 0)

    pnlSurface = xui.CreatePanel("")
    pnlSurface.Color = xui.Color_Transparent
    mBase.AddView(pnlSurface, 0, 0, 0, 0)

    pnlImageHost = xui.CreatePanel("")
    pnlImageHost.Color = xui.Color_Transparent
    pnlSurface.AddView(pnlImageHost, 0, 0, 0, 0)

    pnlContentHost = xui.CreatePanel("")
    pnlContentHost.Color = xui.Color_Transparent
    pnlSurface.AddView(pnlContentHost, 0, 0, 0, 0)

    pnlContentShadow = xui.CreatePanel("")
    pnlContentShadow.Color = xui.Color_ARGB(0, 0, 0, 0)
    pnlContentHost.AddView(pnlContentShadow, 0, 0, 0, 0)

    pnlContentShell = xui.CreatePanel("")
    pnlContentShell.Color = xui.Color_Transparent
    pnlContentHost.AddView(pnlContentShell, 0, 0, 0, 0)

    pnlCustomContent = xui.CreatePanel("")
    pnlCustomContent.Color = xui.Color_Transparent
    pnlContentShell.AddView(pnlCustomContent, 0, 0, 0, 0)

    moImageAvatar.Initialize(Me, "")
    moImageAvatar.AddToParent(pnlImageHost, 0, 0, 1dip, 1dip)
    moImageAvatar.setWidth("w-full")
    moImageAvatar.setHeight("h-full")
    moImageAvatar.setAvatarType("image")
    moImageAvatar.setShadow("none")
    moImageAvatar.setPadding("")
    moImageAvatar.setMargin("")

    pnlShine = xui.CreatePanel("")
    pnlShine.Color = xui.Color_ARGB(0, 255, 255, 255)
    pnlSurface.AddView(pnlShine, 0, 0, 0, 0)

    lstZones.Initialize
    CreateZone(0, -1, -1)
    CreateZone(1, 0, -1)
    CreateZone(2, 1, -1)
    CreateZone(3, -1, 0)
    CreateZone(4, 0, 0)
    CreateZone(5, 1, 0)
    CreateZone(6, -1, 1)
    CreateZone(7, 0, 1)
    CreateZone(8, 1, 1)
End Sub

Private Sub CreateZone(iIndex As Int, iDirX As Int, iDirY As Int)
    Dim zone As B4XView = xui.CreatePanel("zone")
    zone.Color = xui.Color_Transparent
    Dim info As Map
    info.Initialize
    info.Put("index", iIndex)
    info.Put("dx", iDirX)
    info.Put("dy", iDirY)
    zone.Tag = info
    mBase.AddView(zone, 0, 0, 0, 0)
    lstZones.Add(zone)
End Sub
#End Region

#Region Public API
Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setMaxTilt(fValue As Float)
    mfMaxTilt = Max(0, fValue)
    If mbHovering Then
        ApplyHoverState(mfCurrentDirX, mfCurrentDirY, False)
    End If
End Sub

Public Sub getMaxTilt As Float
    Return mfMaxTilt
End Sub

Public Sub setScaleOnHover(fValue As Float)
    mfScaleOnHover = Max(1, fValue)
    If mbHovering Then UpdateSurfaceTransform(False)
End Sub

Public Sub getScaleOnHover As Float
    Return mfScaleOnHover
End Sub

Public Sub setShineEffect(bValue As Boolean)
    mbShineEffect = bValue
    Refresh
End Sub

Public Sub getShineEffect As Boolean
    Return mbShineEffect
End Sub

Public Sub setPerspective(fValue As Float)
    mfPerspective = Max(1, fValue)
    UpdateSurfacePerspective
End Sub

Public Sub getPerspective As Float
    Return mfPerspective
End Sub

Public Sub setResetDuration(iValue As Int)
    miResetDuration = Max(0, iValue)
End Sub

Public Sub getResetDuration As Int
    Return miResetDuration
End Sub

Public Sub setVariant(sValue As String)
    msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setRounded(sValue As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setPadding(sValue As String)
    If sValue = Null Then
        msPadding = ""
    Else
        msPadding = sValue
    End If
    Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setMargin(sValue As String)
    If sValue = Null Then
        msMargin = ""
    Else
        msMargin = sValue
    End If
    Refresh
End Sub

Public Sub getMargin As String
    Return msMargin
End Sub

Public Sub setWidth(sValue As String)
    msWidth = NormalizeSizeToken(sValue, "w-full")
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(sValue As String)
    msHeight = NormalizeSizeToken(sValue, "h-content")
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setContentType(sValue As String)
    msContentType = NormalizeContentType(sValue)
    Refresh
End Sub

Public Sub getContentType As String
    Return msContentType
End Sub

Public Sub setImage(sValue As String)
    If sValue = Null Then
        msImage = ""
    Else
        msImage = sValue.Trim
    End If
    Refresh
End Sub

Public Sub getImage As String
    Return msImage
End Sub

Public Sub setContentBackgroundColor(iValue As Int)
    mcContentBackgroundColor = iValue
    Refresh
End Sub

Public Sub getContentBackgroundColor As Int
    Return mcContentBackgroundColor
End Sub

Public Sub setContentRounded(sValue As String)
    msContentRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    Refresh
End Sub

Public Sub getContentRounded As String
    Return msContentRounded
End Sub

Public Sub setContentPadding(sValue As String)
    If sValue = Null Then
        msContentPadding = ""
    Else
        msContentPadding = sValue
    End If
    Refresh
End Sub

Public Sub getContentPadding As String
    Return msContentPadding
End Sub

Public Sub setContentShadow(sValue As String)
    msContentShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    Refresh
End Sub

Public Sub getContentShadow As String
    Return msContentShadow
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mcBackgroundColor = iValue
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
    setBackgroundColor(B4XDaisyVariants.ResolveBackgroundColorVariant(sVariantName, mcBackgroundColor))
End Sub

''' <summary>
''' Forces the component to re-resolve theme-aware styling.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Applies the current component state to the UI.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    EnsureViewHierarchy
    ApplyConfiguredHostSize

    mBase.Visible = mbVisible
    LayoutHoverHost(mBase.Width, mBase.Height)
    SyncContentMode
    ApplySurfaceStyle
    UpdateSurfacePerspective
    UpdateZoneEnabledState

    If mbHovering = False Then
        UpdateShinePanel(0)
        UpdateShadowPanel(False)
        UpdateSurfaceTransform(False)
    Else
        UpdateShinePanel(80)
        UpdateShadowPanel(True)
        UpdateSurfaceTransform(False)
    End If
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        DesignerCreateView(p, Null, BuildRuntimeProps(iWidth, iHeight))
    End If
    Dim resolvedWidth As Int = ResolveConfiguredWidth(Max(1dip, iWidth))
    Dim resolvedHeight As Int = ResolveConfiguredHeight(Max(1dip, resolvedWidth), iHeight)
    vParent.AddView(mBase, iLeft, iTop, resolvedWidth, resolvedHeight)
    ApplyConfiguredHostSize
    Return mBase
End Sub

''' <summary>
''' Adds a child view to the hover surface content host.
''' </summary>
Public Sub AddView(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If pnlCustomContent.IsInitialized = False Then Return
    pnlCustomContent.AddView(View, iLeft, iTop, iWidth, iHeight)
    If msContentType = "custom" And IsContentHeightToken Then Refresh
End Sub

''' <summary>
''' Removes all hosted child views from the content host.
''' </summary>
Public Sub RemoveAllViews
    If pnlCustomContent.IsInitialized = False Then Return
    For i = pnlCustomContent.NumberOfViews - 1 To 0 Step -1
        pnlCustomContent.GetView(i).RemoveViewFromParent
    Next
    If msContentType = "custom" And IsContentHeightToken Then Refresh
End Sub

''' <summary>
''' Returns the inner content host panel for composition.
''' </summary>
Public Sub getContentPanel As B4XView
    Return pnlCustomContent
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Left = iValue
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Left
End Sub

Public Sub setTop(iValue As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Top = iValue
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Top
End Sub
#End Region

#Region Layout
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    ApplyConfiguredHostSize
    LayoutHoverHost(dWidth, dHeight)
    SyncContentMode
    ApplySurfaceStyle
    If mbHovering Then
        UpdateShadowPanel(True)
        UpdateShinePanel(0)
    Else
        UpdateShadowPanel(False)
        UpdateShinePanel(0)
    End If
    UpdateSurfacePerspective
    UpdateSurfaceTransform(False)
    inResize = False
End Sub

Private Sub LayoutHoverHost(dWidth As Double, dHeight As Double)
    If pnlSurface.IsInitialized = False Then Return

    Dim hostW As Int = Max(1dip, dWidth)
    Dim hostH As Int = Max(1dip, dHeight)

    Dim box As Map = BuildBoxModel
    Dim hostRect As B4XRect
    hostRect.Initialize(0, 0, hostW, hostH)

    Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(hostRect, box)
    Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    Dim contentLocal As B4XRect = B4XDaisyBoxModel.ToLocalRect(contentRect, outerRect)

    pnlSurface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
    pnlImageHost.SetLayoutAnimated(0, contentLocal.Left, contentLocal.Top, contentLocal.Width, contentLocal.Height)
    pnlContentHost.SetLayoutAnimated(0, contentLocal.Left, contentLocal.Top, contentLocal.Width, contentLocal.Height)
    If B4XDaisyApp.DebugLogs Then Log("[HOVER3DDBG] LayoutHoverHost W=" & dWidth & " H=" & dHeight & " contentHost=" & contentLocal.Width & "x" & contentLocal.Height)
    LayoutCustomContentShell

    LayoutZones(outerRect)
End Sub

Private Sub ApplyConfiguredHostSize
    If mBase.IsInitialized = False Then Return

    Dim availableW As Int = Max(1dip, ResolveAvailableWidth)
    Dim availableH As Int = Max(1dip, ResolveAvailableHeight)
    Dim targetW As Int = ResolveConfiguredWidth(availableW)
    Dim targetH As Int = ResolveConfiguredHeight(targetW, availableH)

    If targetW <> mBase.Width Or targetH <> mBase.Height Then
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
    End If
    If B4XDaisyApp.DebugLogs Then Log("[HOVER3DDBG] ApplyConfiguredHostSize target=" & targetW & "x" & targetH & " mBase=" & mBase.Width & "x" & mBase.Height)
End Sub

Private Sub ResolveAvailableWidth As Int
    If mBase.IsInitialized = False Then Return 1dip
    If mBase.Width > 0 Then Return mBase.Width
    If mBase.Parent.IsInitialized And mBase.Parent.Width > 0 Then Return mBase.Parent.Width
    Return 1dip
End Sub

Private Sub ResolveAvailableHeight As Int
    If mBase.IsInitialized = False Then Return 1dip
    If mBase.Height > 0 Then Return mBase.Height
    If mBase.Parent.IsInitialized And mBase.Parent.Height > 0 Then Return mBase.Parent.Height
    Return 1dip
End Sub

Private Sub ResolveConfiguredWidth(iAvailableWidth As Int) As Int
    Dim fallback As Int = Max(1dip, iAvailableWidth)
    Dim token As String = NormalizeSizeToken(msWidth, "w-full")
    If token = "w-full" Or token = "full" Or token = "100%" Then Return fallback
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, fallback))
End Sub

Private Sub ResolveConfiguredHeight(iAvailableWidth As Int, iAvailableHeight As Int) As Int
    Dim fallback As Int = Max(1dip, iAvailableHeight)
    If IsContentHeightToken Then Return MeasureContentHeight(iAvailableWidth, fallback)
    Dim token As String = NormalizeSizeToken(msHeight, "h-content")
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, fallback))
End Sub

Private Sub IsContentHeightToken As Boolean
    Dim token As String = NormalizeSizeToken(msHeight, "h-content")
    Return token = "h-content" Or token = "content" Or token = "h-auto" Or token = "auto"
End Sub

Private Sub MeasureContentHeight(iAvailableWidth As Int, iFallbackHeight As Int) As Int
    If msContentType = "image" Then
        Dim boxImage As Map = BuildBoxModel
        Dim padTopImage As Int = boxImage.GetDefault("padding_top", 0)
        Dim padBottomImage As Int = boxImage.GetDefault("padding_bottom", 0)
        Dim padLeftImage As Int = boxImage.GetDefault("padding_left", 0)
        Dim padRightImage As Int = boxImage.GetDefault("padding_right", 0)
        Dim marginTopImage As Int = boxImage.GetDefault("margin_top", 0)
        Dim marginBottomImage As Int = boxImage.GetDefault("margin_bottom", 0)
        Dim marginLeftImage As Int = boxImage.GetDefault("margin_left", 0)
        Dim marginRightImage As Int = boxImage.GetDefault("margin_right", 0)
        'Match DaisyUI <figure><img> (width:100%, height:auto): surface height follows the
        'image's native aspect ratio so FILL_NO_DISTORTIONS fills exactly with no crop.
        Dim contentWidth As Int = Max(1dip, iAvailableWidth - marginLeftImage - marginRightImage - padLeftImage - padRightImage)
        Dim imageHeight As Int = ResolveImageAspectHeight(contentWidth)
        If imageHeight > 0 Then
            Return Max(1dip, imageHeight + padTopImage + padBottomImage + marginTopImage + marginBottomImage)
        End If
        Return Max(1dip, iFallbackHeight + padTopImage + padBottomImage + marginTopImage + marginBottomImage)
    End If
    Dim contentBottom As Int = 0
    If pnlCustomContent.IsInitialized Then
        contentBottom = MeasureContentBottomRecursive(pnlCustomContent, 0)
    End If
    If contentBottom <= 0 Then contentBottom = Max(1dip, iFallbackHeight)

    Dim outerBox As Map = BuildBoxModel
    Dim innerBox As Map = BuildContentBoxModel
    Dim padTop As Int = outerBox.GetDefault("padding_top", 0) + innerBox.GetDefault("padding_top", 0)
    Dim padBottom As Int = outerBox.GetDefault("padding_bottom", 0) + innerBox.GetDefault("padding_bottom", 0)
    Dim marginTop As Int = outerBox.GetDefault("margin_top", 0)
    Dim marginBottom As Int = outerBox.GetDefault("margin_bottom", 0)

    Dim ret As Int = Max(1dip, contentBottom + padTop + padBottom + marginTop + marginBottom)
    If B4XDaisyApp.DebugLogs Then Log("[HOVER3DDBG] MeasureContentHeight CUSTOM contentBottom=" & contentBottom & " padTop=" & padTop & " padBottom=" & padBottom & " ret=" & ret & " availW=" & iAvailableWidth & " fallback=" & iFallbackHeight)
    Return ret
End Sub

'Loads the configured image asset and returns the pixel height it would occupy at ContentWidth,
'preserving aspect ratio. Returns 0 when no image is set or it cannot be decoded so callers
'fall back to the supplied fallback height.
'ponytail: loads bitmap per measure pass (Resize/Refresh only, not per-frame). Cache by (image,width) if measure becomes hot.
Private Sub ResolveImageAspectHeight(iContentWidth As Int) As Int
    If msImage = Null Then Return 0
    Dim name As String = msImage.Trim
    If name.Length = 0 Then Return 0
    Dim resolved As String = B4XDaisyVariants.ResolveAssetImage(name, "")
    If resolved.Length = 0 Then Return 0
    Try
        Dim bmp As B4XBitmap = xui.LoadBitmap(File.DirAssets, resolved)
        If bmp.IsInitialized = False Then Return 0
        If bmp.Width <= 0 Then Return 0
        Return Max(1dip, Round(iContentWidth * bmp.Height / bmp.Width))
    Catch
        Return 0
    End Try
End Sub

Private Sub MeasureContentBottomRecursive(vContainer As B4XView, iOffsetTop As Int) As Int
    If vContainer.IsInitialized = False Then Return 0

    Dim maxBottom As Int = 0
    For i = 0 To vContainer.NumberOfViews - 1
        Dim child As B4XView = vContainer.GetView(i)
        Dim childOffsetTop As Int = iOffsetTop + child.Top

        Dim measured As Boolean = ShouldMeasureForAutoHeight(child)
        If B4XDaisyApp.DebugLogs Then Log("[HOVER3DDBG] child idx=" & i & " top=" & child.Top & " h=" & child.Height & " w=" & child.Width & " measured=" & measured & " tag=" & child.Tag)

        If measured Then
            maxBottom = Max(maxBottom, childOffsetTop + child.Height)
        End If

        If IsContainerView(child) And child.NumberOfViews > 0 Then
            maxBottom = Max(maxBottom, MeasureContentBottomRecursive(child, childOffsetTop))
        End If
    Next
    If B4XDaisyApp.DebugLogs Then Log("[HOVER3DDBG] MeasureContentBottomRecursive offset=" & iOffsetTop & " count=" & vContainer.NumberOfViews & " maxBottom=" & maxBottom)
    Return maxBottom
End Sub

Private Sub ShouldMeasureForAutoHeight(vChildView As B4XView) As Boolean
    If vChildView.IsInitialized = False Then Return False
    If View.Tag = Null Then Return True

    If View.Tag Is Boolean Then
        Return View.Tag
    End If

    If View.Tag Is String Then
        Dim s As String = View.Tag
        s = s.ToLowerCase.Trim
        If s = "ignore-auto-height" Or s = "measure=false" Then Return False
        Return True
    End If

    If View.Tag Is Map Then
        Dim m As Map = View.Tag
        If m.ContainsKey("measure") Then
            Return m.GetDefault("measure", True)
        End If
        If m.ContainsKey("ignore_auto_height") Then
            Return Not(m.GetDefault("ignore_auto_height", False))
        End If
    End If

    Return True
End Sub

Private Sub IsContainerView(vChildView As B4XView) As Boolean
    If vChildView.IsInitialized = False Then Return False
    Try
        Dim count As Int = View.NumberOfViews
        Return count >= 0
    Catch
        Return False
    End Try
End Sub

Private Sub NormalizeSizeToken(sValue As String, sDefaultValue As String) As String
    If sValue = Null Then Return sDefaultValue
    Dim token As String = sValue.Trim.ToLowerCase
    If token.Length = 0 Then Return sDefaultValue
    Return token
End Sub

Private Sub NormalizeContentType(sValue As String) As String
    If sValue = Null Then Return "custom"
    Dim token As String = sValue.Trim.ToLowerCase
    If token = "image" Then Return "image"
    Return "custom"
End Sub

Private Sub SyncContentMode
    If pnlImageHost.IsInitialized = False Or pnlContentHost.IsInitialized = False Then Return

    Dim imageMode As Boolean = (msContentType = "image")
    pnlImageHost.Visible = imageMode
    pnlContentHost.Visible = Not(imageMode)

    If moImageAvatar.mBase.IsInitialized = False Then Return

    moImageAvatar.mBase.Visible = imageMode
    If imageMode = False Then Return

    moImageAvatar.mBase.SetLayoutAnimated(0, 0, 0, Max(1dip, pnlImageHost.Width), Max(1dip, pnlImageHost.Height))
    moImageAvatar.setWidth("w-full")
    moImageAvatar.setHeight("h-full")
    moImageAvatar.setAvatarType("image")
    moImageAvatar.setAvatar(msImage)
    moImageAvatar.setShadow("none")
    moImageAvatar.setMask(msRounded)
    moImageAvatar.setRoundedBox(False)
    moImageAvatar.ResizeToParent(pnlImageHost)
End Sub

Private Sub LayoutZones(rcOuterRect As B4XRect)
    If lstZones.IsInitialized = False Then Return

    Dim zoneW As Int = Max(1dip, rcOuterRect.Width / 3)
    Dim zoneH As Int = Max(1dip, rcOuterRect.Height / 3)

    For Each zone As B4XView In lstZones
        Dim info As Map = zone.Tag
        Dim index As Int = info.Get("index")
        Dim col As Int = index Mod 3
        Dim row As Int = Floor(index / 3)
        Dim leftValue As Int = rcOuterRect.Left + (col * zoneW)
        Dim topValue As Int = rcOuterRect.Top + (row * zoneH)
        Dim widthValue As Int = zoneW
        Dim heightValue As Int = zoneH
        If col = 2 Then widthValue = rcOuterRect.Width - (zoneW * 2)
        If row = 2 Then heightValue = rcOuterRect.Height - (zoneH * 2)
        zone.SetLayoutAnimated(0, leftValue, topValue, Max(1dip, widthValue), Max(1dip, heightValue))
    Next
End Sub

Private Sub BuildBoxModel As Map
    Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
    Dim rtl As Boolean = False
    B4XDaisyBoxModel.ApplyPaddingUtilities(box, msPadding, rtl)
    B4XDaisyBoxModel.ApplyMarginUtilities(box, msMargin, rtl)
    box.Put("radius", ResolveRadiusDip)
    Return box
End Sub

Private Sub BuildContentBoxModel As Map
    Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
    Dim rtl As Boolean = False
    B4XDaisyBoxModel.ApplyPaddingUtilities(box, msContentPadding, rtl)
    box.Put("radius", ResolveContentRadiusDip)
    Return box
End Sub

Private Sub ResolveRadiusDip As Float
    Dim fallback As Float = 16dip
    If msRounded = "" Or msRounded = "none" Or msRounded = "rounded-none" Then Return 0
    Return B4XDaisyVariants.TailwindBorderRadiusToDip(msRounded, fallback)
End Sub

Private Sub ResolveContentRadiusDip As Float
    Dim fallback As Float = 16dip
    If msContentRounded = "" Or msContentRounded = "none" Or msContentRounded = "rounded-none" Then Return 0
    Return B4XDaisyVariants.TailwindBorderRadiusToDip(msContentRounded, fallback)
End Sub

Private Sub ResolveSurfaceBackgroundColor As Int
    If mcBackgroundColor <> 0 Then Return mcBackgroundColor
    If msVariant <> "none" Then
        Return B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, xui.Color_Transparent)
    End If
    Return xui.Color_Transparent
End Sub

Private Sub ResolveContentBackgroundColor As Int
    If mcContentBackgroundColor <> 0 Then Return mcContentBackgroundColor
    Return xui.Color_Transparent
End Sub
#End Region

#Region Visuals
Private Sub ApplySurfaceStyle
    If pnlSurface.IsInitialized = False Then Return

    Dim surfaceColor As Int = ResolveSurfaceBackgroundColor
    Dim radius As Float = ResolveRadiusDip
    Dim borderAlpha As Int = 0
    If mbHovering Then borderAlpha = 28
    Dim borderColor As Int = xui.Color_ARGB(borderAlpha, 255, 255, 255)

    pnlSurface.SetColorAndBorder(surfaceColor, 1dip, borderColor, radius)
    pnlContentHost.Color = xui.Color_Transparent
    ApplyContentStyle
End Sub

Private Sub LayoutCustomContentShell
    If pnlContentHost.IsInitialized = False Or pnlContentShadow.IsInitialized = False Or pnlContentShell.IsInitialized = False Or pnlCustomContent.IsInitialized = False Then Return

    Dim hostRect As B4XRect
    hostRect.Initialize(0, 0, Max(1dip, pnlContentHost.Width), Max(1dip, pnlContentHost.Height))
    Dim box As Map = BuildContentBoxModel
    Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(hostRect, box)
    Dim contentLocal As B4XRect = B4XDaisyBoxModel.ToLocalRect(contentRect, hostRect)

    pnlContentShadow.SetLayoutAnimated(0, 0, 0, hostRect.Width, hostRect.Height)
    pnlContentShell.SetLayoutAnimated(0, 0, 0, hostRect.Width, hostRect.Height)
    pnlCustomContent.SetLayoutAnimated(0, contentLocal.Left, contentLocal.Top, contentLocal.Width, contentLocal.Height)
    If B4XDaisyApp.DebugLogs Then Log("[HOVER3DDBG] LayoutCustomContentShell host=" & hostRect.Width & "x" & hostRect.Height & " custom=" & contentLocal.Width & "x" & contentLocal.Height & " L=" & contentLocal.Left & " T=" & contentLocal.Top)
End Sub

Private Sub ApplyContentStyle
    If pnlContentShell.IsInitialized = False Or pnlContentShadow.IsInitialized = False Or pnlCustomContent.IsInitialized = False Then Return

    Dim shellColor As Int = ResolveContentBackgroundColor
    Dim shellRadius As Float = ResolveContentRadiusDip
    pnlContentShell.SetColorAndBorder(shellColor, 0, xui.Color_Transparent, shellRadius)
    pnlCustomContent.Color = xui.Color_Transparent
    UpdateContentShadowPanel
End Sub

Private Sub UpdateSurfacePerspective
    #If B4A
    If pnlSurface.IsInitialized = False Then Return
    Dim jo As JavaObject = pnlSurface
    jo.RunMethod("setCameraDistance", Array(mfPerspective * GetDeviceLayoutValues.Scale * 72))
    #End If
End Sub

Private Sub UpdateSurfaceTransform(bAnimated As Boolean)
    #If B4A
    If pnlSurface.IsInitialized = False Then Return
    Dim jo As JavaObject = pnlSurface
    If bAnimated Then
        Dim animator As JavaObject = jo.RunMethodJO("animate", Null)
        Dim safeDuration As Long = Max(0, miResetDuration)
        animator.RunMethod("rotationX", Array As Object(mfCurrentTiltX))
        animator.RunMethod("rotationY", Array As Object(mfCurrentTiltY))
        animator.RunMethod("scaleX", Array As Object(mfCurrentScale))
        animator.RunMethod("scaleY", Array As Object(mfCurrentScale))
        animator.RunMethod("setDuration", Array As Object(safeDuration))
    Else
        jo.RunMethod("setRotationX", Array As Object(mfCurrentTiltX))
        jo.RunMethod("setRotationY", Array As Object(mfCurrentTiltY))
        jo.RunMethod("setScaleX", Array As Object(mfCurrentScale))
        jo.RunMethod("setScaleY", Array As Object(mfCurrentScale))
    End If
    #End If
End Sub

Private Sub UpdateShadowPanel(bIsHoverState As Boolean)
    If pnlShadow.IsInitialized = False Or pnlSurface.IsInitialized = False Then Return

    Dim alphaValue As Int = 0
    If bIsHoverState Then alphaValue = ResolveShadowAlphaFor(msShadow)
    Dim shadowRadius As Float = ResolveRadiusDip
    Dim surfaceLeft As Int = pnlSurface.Left
    Dim surfaceTop As Int = pnlSurface.Top
    Dim duration As Int = miResetDuration
    If bIsHoverState Then duration = 80

    pnlShadow.SetLayoutAnimated(duration, surfaceLeft + mfCurrentShadowDx, surfaceTop + mfCurrentShadowDy, pnlSurface.Width, pnlSurface.Height)
    pnlShadow.SetColorAndBorder(xui.Color_ARGB(alphaValue, 0, 0, 0), 0, xui.Color_Transparent, shadowRadius)
End Sub

Private Sub UpdateContentShadowPanel
    If pnlContentShadow.IsInitialized = False Or pnlContentShell.IsInitialized = False Then Return

    If msContentType <> "custom" Then
        pnlContentShadow.Visible = False
        Return
    End If

    Dim alphaValue As Int = ResolveShadowAlphaFor(msContentShadow)
    If alphaValue <= 0 Then
        pnlContentShadow.Visible = False
        Return
    End If

    pnlContentShadow.Visible = True
    Dim shadowDistance As Float = ResolveShadowDistanceFor(msContentShadow)
    Dim shellRadius As Float = ResolveContentRadiusDip
    pnlContentShadow.SetLayoutAnimated(0, 0, shadowDistance * 0.5, pnlContentShell.Width, Max(1dip, pnlContentShell.Height - (shadowDistance * 0.5)))
    pnlContentShadow.SetColorAndBorder(xui.Color_ARGB(alphaValue, 0, 0, 0), 0, xui.Color_Transparent, shellRadius)
End Sub

Private Sub UpdateShinePanel(iDuration As Int)
    If pnlShine.IsInitialized = False Or pnlSurface.IsInitialized = False Then Return

    If mbShineEffect = False Then
        pnlShine.Visible = False
        Return
    End If

    pnlShine.Visible = True
    Dim shineW As Int = Max(36dip, pnlSurface.Width * 0.44)
    Dim shineH As Int = Max(36dip, pnlSurface.Height * 0.44)
    Dim leftValue As Int = (pnlSurface.Width - shineW) * mfCurrentShineX
    Dim topValue As Int = (pnlSurface.Height - shineH) * mfCurrentShineY
    Dim alphaValue As Int = 0
    If mbHovering Then alphaValue = 42

    pnlShine.SetLayoutAnimated(iDuration, leftValue, topValue, shineW, shineH)
    pnlShine.SetColorAndBorder(xui.Color_ARGB(alphaValue, 255, 255, 255), 0, xui.Color_Transparent, Max(shineW, shineH))
End Sub

Private Sub ResolveShadowDistance As Float
    Return ResolveShadowDistanceFor(msShadow)
End Sub

Private Sub ResolveShadowDistanceFor(sShadowToken As String) As Float
    Select Case sShadowToken
        Case "xs"
            Return 2dip
        Case "sm"
            Return 4dip
        Case "md"
            Return 6dip
        Case "lg"
            Return 8dip
        Case "xl"
            Return 10dip
        Case "2xl"
            Return 12dip
        Case Else
            Return 0
    End Select
End Sub

Private Sub ResolveShadowAlpha As Int
    Return ResolveShadowAlphaFor(msShadow)
End Sub

Private Sub ResolveShadowAlphaFor(sShadowToken As String) As Int
    Select Case sShadowToken
        Case "xs"
            Return 18
        Case "sm"
            Return 24
        Case "md"
            Return 32
        Case "lg"
            Return 42
        Case "xl"
            Return 54
        Case "2xl"
            Return 68
        Case Else
            Return 0
    End Select
End Sub
#End Region

#Region Interaction
Private Sub UpdateZoneEnabledState
    If lstZones.IsInitialized = False Then Return
    For Each zone As B4XView In lstZones
        zone.Enabled = mbEnabled
        zone.Visible = mbVisible
    Next
End Sub

Private Sub zone_Touch(iAction As Int, fX As Float, fY As Float)
    If mbEnabled = False Then Return

    Dim zone As B4XView = Sender
    Dim info As Map = zone.Tag
    Dim dx As Int = info.Get("dx")
    Dim dy As Int = info.Get("dy")

    Select iAction
        Case 0, 2
            ApplyHoverState(dx, dy, False)
        Case 1
            ApplyHoverState(dx, dy, False)
            RaiseClick
            ResetHoverState
        Case 3
            ResetHoverState
    End Select
End Sub

Private Sub ApplyHoverState(fDirX As Float, fDirY As Float, bAnimated As Boolean)
    mbHovering = True
    mfCurrentDirX = fDirX
    mfCurrentDirY = fDirY
    mfCurrentTiltX = -fDirY * mfMaxTilt
    mfCurrentTiltY = fDirX * mfMaxTilt
    mfCurrentScale = mfScaleOnHover

    Dim shadowDistance As Float = ResolveShadowDistance
    mfCurrentShadowDx = fDirX * shadowDistance
    mfCurrentShadowDy = fDirY * shadowDistance

    mfCurrentShineX = (fDirX + 1) / 2
    mfCurrentShineY = (fDirY + 1) / 2

    ApplySurfaceStyle
    UpdateShadowPanel(True)
    UpdateShinePanel(80)
    UpdateSurfaceTransform(bAnimated)
End Sub

Private Sub ResetHoverState
    mbHovering = False
    mfCurrentDirX = 0
    mfCurrentDirY = 0
    mfCurrentTiltX = 0
    mfCurrentTiltY = 0
    mfCurrentScale = 1
    mfCurrentShadowDx = 0
    mfCurrentShadowDy = 0
    mfCurrentShineX = 0.5
    mfCurrentShineY = 0.5

    ApplySurfaceStyle
    UpdateShadowPanel(False)
    UpdateShinePanel(miResetDuration)
    UpdateSurfaceTransform(True)
End Sub

Private Sub RaiseClick
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
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
