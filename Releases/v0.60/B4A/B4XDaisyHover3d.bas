B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12
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
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then
        mTag = mBase.Tag
    End If
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    ApplyDesignerProps(Props)
    EnsureViewHierarchy
    Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    mbShineEffect = B4XDaisyVariants.GetPropBool(Props, "ShineEffect", True)

    mfMaxTilt = Props.GetDefault("MaxTilt", 10.0)
    mfScaleOnHover = Props.GetDefault("ScaleOnHover", 1.05)
    mfPerspective = Props.GetDefault("Perspective", 1200.0)
    miResetDuration = Props.GetDefault("ResetDuration", 500)

    msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "none"))
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "rounded-2xl"))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    msPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "p-0")
    msMargin = B4XDaisyVariants.GetPropString(Props, "Margin", "")
    msWidth = NormalizeSizeToken(B4XDaisyVariants.GetPropString(Props, "Width", "w-full"), "w-full")
    msHeight = NormalizeSizeToken(B4XDaisyVariants.GetPropString(Props, "Height", "h-content"), "h-content")
    msContentType = NormalizeContentType(B4XDaisyVariants.GetPropString(Props, "ContentType", "custom"))
    msImage = B4XDaisyVariants.GetPropString(Props, "Image", "")
    mcContentBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "ContentBackgroundColor", 0)
    msContentRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "ContentRounded", "none"))
    msContentPadding = B4XDaisyVariants.GetPropString(Props, "ContentPadding", "")
    msContentShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "ContentShadow", "none"))
    mcBackgroundColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", 0)
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

Private Sub CreateZone(Index As Int, DirX As Int, DirY As Int)
    Dim zone As B4XView = xui.CreatePanel("zone")
    zone.Color = xui.Color_Transparent
    Dim info As Map
    info.Initialize
    info.Put("index", Index)
    info.Put("dx", DirX)
    info.Put("dy", DirY)
    zone.Tag = info
    mBase.AddView(zone, 0, 0, 0, 0)
    lstZones.Add(zone)
End Sub
#End Region

#Region Public API
Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mbVisible = Value
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setMaxTilt(Value As Float)
    mfMaxTilt = Max(0, Value)
    If mbHovering Then
        ApplyHoverState(mfCurrentDirX, mfCurrentDirY, False)
    End If
End Sub

Public Sub getMaxTilt As Float
    Return mfMaxTilt
End Sub

Public Sub setScaleOnHover(Value As Float)
    mfScaleOnHover = Max(1, Value)
    If mbHovering Then UpdateSurfaceTransform(False)
End Sub

Public Sub getScaleOnHover As Float
    Return mfScaleOnHover
End Sub

Public Sub setShineEffect(Value As Boolean)
    mbShineEffect = Value
    Refresh
End Sub

Public Sub getShineEffect As Boolean
    Return mbShineEffect
End Sub

Public Sub setPerspective(Value As Float)
    mfPerspective = Max(1, Value)
    UpdateSurfacePerspective
End Sub

Public Sub getPerspective As Float
    Return mfPerspective
End Sub

Public Sub setResetDuration(Value As Int)
    miResetDuration = Max(0, Value)
End Sub

Public Sub getResetDuration As Int
    Return miResetDuration
End Sub

Public Sub setVariant(Value As String)
    msVariant = B4XDaisyVariants.NormalizeVariant(Value)
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setRounded(Value As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(Value)
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setPadding(Value As String)
    If Value = Null Then
        msPadding = ""
    Else
        msPadding = Value
    End If
    Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setMargin(Value As String)
    If Value = Null Then
        msMargin = ""
    Else
        msMargin = Value
    End If
    Refresh
End Sub

Public Sub getMargin As String
    Return msMargin
End Sub

Public Sub setWidth(Value As String)
    msWidth = NormalizeSizeToken(Value, "w-full")
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(Value As String)
    msHeight = NormalizeSizeToken(Value, "h-content")
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setContentType(Value As String)
    msContentType = NormalizeContentType(Value)
    Refresh
End Sub

Public Sub getContentType As String
    Return msContentType
End Sub

Public Sub setImage(Value As String)
    If Value = Null Then
        msImage = ""
    Else
        msImage = Value.Trim
    End If
    Refresh
End Sub

Public Sub getImage As String
    Return msImage
End Sub

Public Sub setContentBackgroundColor(Value As Int)
    mcContentBackgroundColor = Value
    Refresh
End Sub

Public Sub getContentBackgroundColor As Int
    Return mcContentBackgroundColor
End Sub

Public Sub setContentRounded(Value As String)
    msContentRounded = B4XDaisyVariants.NormalizeRounded(Value)
    Refresh
End Sub

Public Sub getContentRounded As String
    Return msContentRounded
End Sub

Public Sub setContentPadding(Value As String)
    If Value = Null Then
        msContentPadding = ""
    Else
        msContentPadding = Value
    End If
    Refresh
End Sub

Public Sub getContentPadding As String
    Return msContentPadding
End Sub

Public Sub setContentShadow(Value As String)
    msContentShadow = B4XDaisyVariants.NormalizeShadow(Value)
    Refresh
End Sub

Public Sub getContentShadow As String
    Return msContentShadow
End Sub

Public Sub setBackgroundColor(Value As Int)
    mcBackgroundColor = Value
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mcBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
    setBackgroundColor(B4XDaisyVariants.ResolveBackgroundColorVariant(VariantName, mcBackgroundColor))
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
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("")
        DesignerCreateView(p, Null, CreateMap())
    End If
    Dim resolvedWidth As Int = ResolveConfiguredWidth(Max(1dip, Width))
    Dim resolvedHeight As Int = ResolveConfiguredHeight(Max(1dip, resolvedWidth), Height)
    Parent.AddView(mBase, Left, Top, resolvedWidth, resolvedHeight)
    ApplyConfiguredHostSize
    Return mBase
End Sub

''' <summary>
''' Adds a child view to the hover surface content host.
''' </summary>
Public Sub AddView(View As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    If pnlCustomContent.IsInitialized = False Then Return
    pnlCustomContent.AddView(View, Left, Top, Width, Height)
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

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(Duration, Left, Top, Width, Height)
End Sub

Public Sub setLeft(Value As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Left = Value
End Sub

Public Sub getLeft As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Left
End Sub

Public Sub setTop(Value As Int)
    If mBase.IsInitialized = False Then Return
    mBase.Top = Value
End Sub

Public Sub getTop As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Top
End Sub
#End Region

#Region Layout
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    ApplyConfiguredHostSize
    LayoutHoverHost(Width, Height)
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
End Sub

Private Sub LayoutHoverHost(Width As Double, Height As Double)
    If pnlSurface.IsInitialized = False Then Return

    Dim hostW As Int = Max(1dip, Width)
    Dim hostH As Int = Max(1dip, Height)

    Dim box As Map = BuildBoxModel
    Dim hostRect As B4XRect
    hostRect.Initialize(0, 0, hostW, hostH)

    Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(hostRect, box)
    Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
    Dim contentLocal As B4XRect = B4XDaisyBoxModel.ToLocalRect(contentRect, outerRect)

    pnlSurface.SetLayoutAnimated(0, outerRect.Left, outerRect.Top, outerRect.Width, outerRect.Height)
    pnlImageHost.SetLayoutAnimated(0, contentLocal.Left, contentLocal.Top, contentLocal.Width, contentLocal.Height)
    pnlContentHost.SetLayoutAnimated(0, contentLocal.Left, contentLocal.Top, contentLocal.Width, contentLocal.Height)
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

Private Sub ResolveConfiguredWidth(AvailableWidth As Int) As Int
    Dim fallback As Int = Max(1dip, AvailableWidth)
    Dim token As String = NormalizeSizeToken(msWidth, "w-full")
    If token = "w-full" Or token = "full" Or token = "100%" Then Return fallback
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, fallback))
End Sub

Private Sub ResolveConfiguredHeight(AvailableWidth As Int, AvailableHeight As Int) As Int
    Dim fallback As Int = Max(1dip, AvailableHeight)
    If IsContentHeightToken Then Return MeasureContentHeight(AvailableWidth, fallback)
    Dim token As String = NormalizeSizeToken(msHeight, "h-content")
    Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, fallback))
End Sub

Private Sub IsContentHeightToken As Boolean
    Dim token As String = NormalizeSizeToken(msHeight, "h-content")
    Return token = "h-content" Or token = "content" Or token = "h-auto" Or token = "auto"
End Sub

Private Sub MeasureContentHeight(AvailableWidth As Int, FallbackHeight As Int) As Int
    If msContentType = "image" Then
        Dim boxImage As Map = BuildBoxModel
        Dim padTopImage As Int = boxImage.GetDefault("padding_top", 0)
        Dim padBottomImage As Int = boxImage.GetDefault("padding_bottom", 0)
        Dim marginTopImage As Int = boxImage.GetDefault("margin_top", 0)
        Dim marginBottomImage As Int = boxImage.GetDefault("margin_bottom", 0)
        Return Max(1dip, FallbackHeight + padTopImage + padBottomImage + marginTopImage + marginBottomImage)
    End If
    Dim contentBottom As Int = 0
    If pnlCustomContent.IsInitialized Then
        contentBottom = MeasureContentBottomRecursive(pnlCustomContent, 0)
    End If
    If contentBottom <= 0 Then contentBottom = Max(1dip, FallbackHeight)

    Dim outerBox As Map = BuildBoxModel
    Dim innerBox As Map = BuildContentBoxModel
    Dim padTop As Int = outerBox.GetDefault("padding_top", 0) + innerBox.GetDefault("padding_top", 0)
    Dim padBottom As Int = outerBox.GetDefault("padding_bottom", 0) + innerBox.GetDefault("padding_bottom", 0)
    Dim marginTop As Int = outerBox.GetDefault("margin_top", 0)
    Dim marginBottom As Int = outerBox.GetDefault("margin_bottom", 0)

    Return Max(1dip, contentBottom + padTop + padBottom + marginTop + marginBottom)
End Sub

Private Sub MeasureContentBottomRecursive(Container As B4XView, OffsetTop As Int) As Int
    If Container.IsInitialized = False Then Return 0

    Dim maxBottom As Int = 0
    For i = 0 To Container.NumberOfViews - 1
        Dim child As B4XView = Container.GetView(i)
        Dim childOffsetTop As Int = OffsetTop + child.Top

        If ShouldMeasureForAutoHeight(child) Then
            maxBottom = Max(maxBottom, childOffsetTop + child.Height)
        End If

        If IsContainerView(child) And child.NumberOfViews > 0 Then
            maxBottom = Max(maxBottom, MeasureContentBottomRecursive(child, childOffsetTop))
        End If
    Next
    Return maxBottom
End Sub

Private Sub ShouldMeasureForAutoHeight(View As B4XView) As Boolean
    If View.IsInitialized = False Then Return False
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

Private Sub IsContainerView(View As B4XView) As Boolean
    If View.IsInitialized = False Then Return False
    Try
        Dim count As Int = View.NumberOfViews
        Return count >= 0
    Catch
        Return False
    End Try
End Sub

Private Sub NormalizeSizeToken(Value As String, DefaultValue As String) As String
    If Value = Null Then Return DefaultValue
    Dim token As String = Value.Trim.ToLowerCase
    If token.Length = 0 Then Return DefaultValue
    Return token
End Sub

Private Sub NormalizeContentType(Value As String) As String
    If Value = Null Then Return "custom"
    Dim token As String = Value.Trim.ToLowerCase
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

Private Sub LayoutZones(OuterRect As B4XRect)
    If lstZones.IsInitialized = False Then Return

    Dim zoneW As Int = Max(1dip, OuterRect.Width / 3)
    Dim zoneH As Int = Max(1dip, OuterRect.Height / 3)

    For Each zone As B4XView In lstZones
        Dim info As Map = zone.Tag
        Dim index As Int = info.Get("index")
        Dim col As Int = index Mod 3
        Dim row As Int = Floor(index / 3)
        Dim leftValue As Int = OuterRect.Left + (col * zoneW)
        Dim topValue As Int = OuterRect.Top + (row * zoneH)
        Dim widthValue As Int = zoneW
        Dim heightValue As Int = zoneH
        If col = 2 Then widthValue = OuterRect.Width - (zoneW * 2)
        If row = 2 Then heightValue = OuterRect.Height - (zoneH * 2)
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

Private Sub UpdateSurfaceTransform(Animated As Boolean)
    #If B4A
    If pnlSurface.IsInitialized = False Then Return
    Dim jo As JavaObject = pnlSurface
    If Animated Then
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

Private Sub UpdateShadowPanel(IsHoverState As Boolean)
    If pnlShadow.IsInitialized = False Or pnlSurface.IsInitialized = False Then Return

    Dim alphaValue As Int = 0
    If IsHoverState Then alphaValue = ResolveShadowAlphaFor(msShadow)
    Dim shadowRadius As Float = ResolveRadiusDip
    Dim surfaceLeft As Int = pnlSurface.Left
    Dim surfaceTop As Int = pnlSurface.Top
    Dim duration As Int = miResetDuration
    If IsHoverState Then duration = 80

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

Private Sub UpdateShinePanel(Duration As Int)
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

    pnlShine.SetLayoutAnimated(Duration, leftValue, topValue, shineW, shineH)
    pnlShine.SetColorAndBorder(xui.Color_ARGB(alphaValue, 255, 255, 255), 0, xui.Color_Transparent, Max(shineW, shineH))
End Sub

Private Sub ResolveShadowDistance As Float
    Return ResolveShadowDistanceFor(msShadow)
End Sub

Private Sub ResolveShadowDistanceFor(ShadowToken As String) As Float
    Select Case ShadowToken
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

Private Sub ResolveShadowAlphaFor(ShadowToken As String) As Int
    Select Case ShadowToken
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

Private Sub zone_Touch(Action As Int, X As Float, Y As Float)
    If mbEnabled = False Then Return

    Dim zone As B4XView = Sender
    Dim info As Map = zone.Tag
    Dim dx As Int = info.Get("dx")
    Dim dy As Int = info.Get("dy")

    Select Action
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

Private Sub ApplyHoverState(DirX As Float, DirY As Float, Animated As Boolean)
    mbHovering = True
    mfCurrentDirX = DirX
    mfCurrentDirY = DirY
    mfCurrentTiltX = -DirY * mfMaxTilt
    mfCurrentTiltY = DirX * mfMaxTilt
    mfCurrentScale = mfScaleOnHover

    Dim shadowDistance As Float = ResolveShadowDistance
    mfCurrentShadowDx = DirX * shadowDistance
    mfCurrentShadowDy = DirY * shadowDistance

    mfCurrentShineX = (DirX + 1) / 2
    mfCurrentShineY = (DirY + 1) / 2

    ApplySurfaceStyle
    UpdateShadowPanel(True)
    UpdateShinePanel(80)
    UpdateSurfaceTransform(Animated)
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
