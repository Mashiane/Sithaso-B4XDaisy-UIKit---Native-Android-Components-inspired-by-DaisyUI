B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12
#Region Events
#Event: Click (Tag As Object)
#Event: CloseClick (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Auto-generated property for Enabled.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Auto-generated property for Visible.
#DesignerProperty: Key: ClickOutsideToClose, DisplayName: Click Outside To Close, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: FullScreen, DisplayName: Full Screen, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: GlassSize, DisplayName: Glass Size, FieldType: String, DefaultValue: none, List: none|glass-xs|glass-sm|glass-md|glass-lg|glass-xl|glass-2xl
#DesignerProperty: Key: Placement, DisplayName: Placement, FieldType: String, DefaultValue: middle, List: top|middle|bottom
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-[90%]
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: base-100, List: base-100|base-200|base-300|primary|secondary|accent|neutral|info|success|warning|error
#DesignerProperty: Key: BackdropColor, DisplayName: Backdrop Color, FieldType: String, DefaultValue: black, List: black|transparent
#DesignerProperty: Key: BackdropOpacity, DisplayName: Backdrop Opacity, FieldType: Int, DefaultValue: 40, MinRange: 0, MaxRange: 100
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: Modal Title
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-4
#DesignerProperty: Key: ShowCloseButton, DisplayName: Show Close Button, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: Sidebar, DisplayName: Sidebar, FieldType: Boolean, DefaultValue: False, Description: When True the modal slides in as a side panel, ignoring Placement.
#DesignerProperty: Key: SidebarSide, DisplayName: Sidebar Side, FieldType: String, DefaultValue: left, List: left|right
#DesignerProperty: Key: SidebarDuration, DisplayName: Sidebar Duration (ms), FieldType: Int, DefaultValue: 300, MinRange: 0, MaxRange: 2000
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Private mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    Private mContentBox As B4XView
    Private mBackdrop As B4XView
    
    ' Internal Parts
    Private partTitle As B4XDaisyCardTitle
    Private partActions As B4XDaisyCardActions
    Private partClose As B4XDaisyButton
    Private pnlTitle As B4XView
    Private pnlBody As B4XView
    Private pnlActions As B4XView
    Private pnlClose As B4XView
    
    Private mEnabled As Boolean = True
    Private mVisible As Boolean = True
    Private mClickOutsideToClose As Boolean = True
    Private mFullScreen As Boolean = False
    Private msGlassSize As String = "none"
    Private msPlacement As String = "middle"
    Private msWidth As String = "w-[90%]"
    Private msHeight As String = "h-auto"
    Private msRounded As String = "rounded-box"
    Private msBackgroundColor As String = "base-100"
    Private msBackdropColor As String = "black"
    Private miBackdropOpacity As Int = 40
    Private msTitle As String = "Modal Title"
    Private msPadding As String = "p-4"
    Private mShowCloseButton As Boolean = False
    Private mbSidebar As Boolean = False
    Private msSidebarSide As String = "left"
    Private miSidebarDuration As Int = 300
    
    Private mIsRefreshing As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    
    partTitle.Initialize(Me, "partTitle")
    partActions.Initialize(Me, "partActions")
    partClose.Initialize(Me, "partClose")
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    
    mBase.Color = xui.Color_Transparent
    
    mBackdrop = xui.CreatePanel("mBackdrop")
    mBase.AddView(mBackdrop, 0, 0, mBase.Width, mBase.Height)
    
    mContentBox = xui.CreatePanel("mContentBox")
    mBase.AddView(mContentBox, 0, 0, 1dip, 1dip)
    
    ' Internal structure within ContentBox
    pnlTitle = xui.CreatePanel("")
    mContentBox.AddView(pnlTitle, 0, 0, 1dip, 1dip)
    partTitle.AddToParent(pnlTitle, 0, 0, 1dip, 1dip)
    Try
        Dim joTitleLbl As JavaObject = partTitle.getLabel
        joTitleLbl.RunMethod("setSingleLine", Array(True))
        Dim joEllipsize As JavaObject
        joEllipsize.InitializeStatic("android.text.TextUtils$TruncateAt")
        joTitleLbl.RunMethod("setEllipsize", Array As Object(joEllipsize.GetField("END")))
    Catch
    End Try
    
    pnlBody = xui.CreatePanel("")
    mContentBox.AddView(pnlBody, 0, 0, 1dip, 1dip)
    
    pnlActions = xui.CreatePanel("")
    mContentBox.AddView(pnlActions, 0, 0, 1dip, 1dip)
    partActions.AddToParent(pnlActions, 0, 0, 1dip, 1dip)
    
    pnlClose = xui.CreatePanel("pnlClose")
    mContentBox.AddView(pnlClose, 0, 0, 32dip, 32dip)
    partClose.AddToParent(pnlClose, 0, 0, 32dip, 32dip)
    partClose.Variant = "ghost"
    partClose.Circle = True
    partClose.Size = "sm"
    partClose.Text = ""
    partClose.IconName = "xmark-solid.svg"
    
    ApplyDesignerProps(Props)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    mEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    mClickOutsideToClose = B4XDaisyVariants.GetPropBool(Props, "ClickOutsideToClose", True)
    mFullScreen = B4XDaisyVariants.GetPropBool(Props, "FullScreen", False)
    msGlassSize = B4XDaisyVariants.GetPropString(Props, "GlassSize", "none")
    msPlacement = B4XDaisyVariants.GetPropString(Props, "Placement", "middle")
    msWidth = B4XDaisyVariants.GetPropString(Props, "Width", "w-[90%]")
    msHeight = B4XDaisyVariants.GetPropString(Props, "Height", "h-auto")
    msRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", "rounded-box")
    msBackgroundColor = B4XDaisyVariants.GetPropString(Props, "BackgroundColor", "base-100")
    msBackdropColor = B4XDaisyVariants.GetPropString(Props, "BackdropColor", "black")
    miBackdropOpacity = B4XDaisyVariants.GetPropInt(Props, "BackdropOpacity", 40)
    msTitle = B4XDaisyVariants.GetPropString(Props, "Title", "Modal Title")
    msPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "p-4")
    mShowCloseButton = B4XDaisyVariants.GetPropBool(Props, "ShowCloseButton", False)
    mbSidebar = B4XDaisyVariants.GetPropBool(Props, "Sidebar", False)
    msSidebarSide = B4XDaisyVariants.GetPropString(Props, "SidebarSide", "left")
    miSidebarDuration = B4XDaisyVariants.GetPropInt(Props, "SidebarDuration", 300)
    Refresh
End Sub
#End Region

#Region Public API
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    Dim empty As B4XView
    If Parent.IsInitialized = False Then Return empty
    If mBase.IsInitialized = False Then
        ' Usually called if not created via Designer
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.SetLayoutAnimated(0, 0, 0, Width, Height)
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    Parent.AddView(mBase, Left, Top, Width, Height)
    Base_Resize(Width, Height)
    Refresh
    Return mBase
End Sub

Public Sub CreateView(Parent As B4XView, Tag As Object)
    mTag = Tag
    AddToParent(Parent, 0, 0, Parent.Width, Parent.Height)
End Sub

Public Sub getView As B4XView
    Return mBase
End Sub

Private Sub BuildRuntimeProps As Map
    Dim p As Map = CreateMap()
    p.Put("Enabled", mEnabled)
    p.Put("Visible", mVisible)
    p.Put("ClickOutsideToClose", mClickOutsideToClose)
    p.Put("FullScreen", mFullScreen)
    p.Put("GlassSize", msGlassSize)
    p.Put("Placement", msPlacement)
    p.Put("Width", msWidth)
    p.Put("Height", msHeight)
    p.Put("Rounded", msRounded)
    p.Put("BackgroundColor", msBackgroundColor)
    p.Put("BackdropColor", msBackdropColor)
    p.Put("BackdropOpacity", miBackdropOpacity)
    p.Put("Title", msTitle)
    p.Put("Padding", msPadding)
    p.Put("ShowCloseButton", mShowCloseButton)
    p.Put("Sidebar", mbSidebar)
    p.Put("SidebarSide", msSidebarSide)
    p.Put("SidebarDuration", miSidebarDuration)
    Return p
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub getActionsContainer As B4XView
    Return partActions.getContainer
End Sub

Public Sub Show
    If mbSidebar And mBase.IsInitialized Then
        ' Snap box to off-screen start position instantly, then animate in
        Dim boxW As Int = B4XDaisyVariants.ResolveSizeSpec(msWidth, mBase.Width, 320dip)
        Dim boxH As Int = mBase.Height
        Dim targetLeft As Int
        Dim startLeft As Int
        If msSidebarSide.ToLowerCase = "right" Then
            targetLeft = mBase.Width - boxW
            startLeft = mBase.Width
        Else
            targetLeft = 0
            startLeft = -boxW
        End If
        mContentBox.SetLayoutAnimated(0, startLeft, 0, boxW, boxH)
        setVisible(True)
        Sleep(0)
        mContentBox.SetLayoutAnimated(miSidebarDuration, targetLeft, 0, boxW, boxH)
    Else
        setVisible(True)
    End If
End Sub

Public Sub ShowModal
    Show
End Sub

Public Sub Close
    If mbSidebar And mBase.IsInitialized And miSidebarDuration > 0 Then
        ' Slide off-screen before hiding
        Dim offLeft As Int
        If msSidebarSide.ToLowerCase = "right" Then
            offLeft = mBase.Width
        Else
            offLeft = -mContentBox.Width
        End If
        mContentBox.SetLayoutAnimated(miSidebarDuration, offLeft, 0, mContentBox.Width, mContentBox.Height)
        Sleep(miSidebarDuration)
    End If
    setVisible(False)
End Sub

Public Sub setEnabled(Value As Boolean)
    mEnabled = Value
    If mBase.IsInitialized = False Then Return
    mBase.Enabled = Value
End Sub

Public Sub getEnabled As Boolean
    Return mEnabled
End Sub

Public Sub setVisible(Value As Boolean)
    mVisible = Value
    If mBase.IsInitialized = False Then Return
    mBase.Visible = Value
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setFullScreen(Value As Boolean)
    mFullScreen = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getFullScreen As Boolean
    Return mFullScreen
End Sub

Public Sub setGlassSize(Value As String)
    msGlassSize = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getGlassSize As String
    Return msGlassSize
End Sub

Public Sub setRounded(Value As String)
    msRounded = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setClickOutsideToClose(Value As Boolean)
    mClickOutsideToClose = Value
End Sub

Public Sub getClickOutsideToClose As Boolean
    Return mClickOutsideToClose
End Sub

Public Sub setPlacement(Value As String)
    msPlacement = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlacement As String
    Return msPlacement
End Sub

Public Sub setWidth(Value As String)
    msWidth = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(Value As String)
    msHeight = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setBackgroundColor(Value As String)
    msBackgroundColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setBackdropColor(Value As String)
    msBackdropColor = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackdropColor As String
    Return msBackdropColor
End Sub

Public Sub setBackdropOpacity(Value As Int)
    miBackdropOpacity = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackdropOpacity As Int
    Return miBackdropOpacity
End Sub

Public Sub setPadding(Value As String)
    msPadding = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setTitle(Value As String)
    msTitle = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTitle As String
    Return msTitle
End Sub

Public Sub setShowCloseButton(Value As Boolean)
    mShowCloseButton = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShowCloseButton As Boolean
    Return mShowCloseButton
End Sub

Public Sub setSidebar(Value As Boolean)
    mbSidebar = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSidebar As Boolean
    Return mbSidebar
End Sub

Public Sub setSidebarSide(Value As String)
    msSidebarSide = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSidebarSide As String
    Return msSidebarSide
End Sub

Public Sub setSidebarDuration(Value As Int)
    miSidebarDuration = Value
End Sub

Public Sub getSidebarDuration As Int
    Return miSidebarDuration
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Or mIsRefreshing Then Return
    mIsRefreshing = True
    
    ' 1. Backdrop
    Dim bc As Int = xui.Color_Transparent
    If msBackdropColor = "black" Then
        Dim alpha As Int = (miBackdropOpacity * 255) / 100
        bc = Bit.Or(Bit.And(xui.Color_Black, 0x00ffffff), Bit.ShiftLeft(alpha, 24))
    End If
    mBackdrop.Color = bc
    
    ' 2. Content Box
    Dim bgColor As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundColor, xui.Color_White)
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    If mFullScreen Then radius = 0
    
    If mbSidebar And msGlassSize = "none" Then
        ' Zero the radii on the edge that touches the screen border
        Dim side As String = msSidebarSide.ToLowerCase
        Dim tlR As Float = IIf(side = "left", 0, radius)
        Dim trR As Float = IIf(side = "right", 0, radius)
        Dim brR As Float = IIf(side = "right", 0, radius)
        Dim blR As Float = IIf(side = "left", 0, radius)
        B4XDaisyVariants.SetColorPerCornerRadius(mContentBox, bgColor, tlR, trR, brR, blR)
    Else
        mContentBox.SetColorAndBorder(bgColor, 0, 0, radius)
        If msGlassSize <> "none" Then
            B4XDaisyVariants.ApplyGlassStyle(mContentBox, radius, msGlassSize)
        End If
    End If
    
    partTitle.Text = msTitle
    pnlClose.Visible = mShowCloseButton
    
    ' 3. Layout Trigger
    Base_Resize(mBase.Width, mBase.Height)
    
    mBase.Enabled = mEnabled
    mBase.Visible = mVisible
    mIsRefreshing = False
End Sub

Public Sub AddToContent(View As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
    pnlBody.AddView(View, Left, Top, Width, Height)
    Refresh ' Re-calc auto height
End Sub

Public Sub getBodyContainer As B4XView
    Return pnlBody
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
    If mBackdrop.IsInitialized Then mBackdrop.SetLayoutAnimated(0, 0, 0, Width, Height)
    
    If mContentBox.IsInitialized Then
        Dim boxW As Int
        Dim boxH As Int
        
        If mFullScreen Then
            boxW = Width
            boxH = Height
        Else
            ' Resolve Width
            boxW = B4XDaisyVariants.ResolveSizeSpec(msWidth, Width, 320dip)
            
            ' Resolve Height
            If msHeight = "h-auto" Then
                boxH = CalculateAutoHeight(boxW)
            Else
                boxH = B4XDaisyVariants.ResolveSizeSpec(msHeight, Height, 200dip)
            End If
        End If
        
        Dim left As Int = (Width - boxW) / 2
        Dim top As Int = (Height - boxH) / 2
        
        If mFullScreen = False Then
            If mbSidebar Then
                ' Sidebar: full height, anchored to left or right edge
                boxH = Height
                top = 0
                If msSidebarSide.ToLowerCase = "right" Then
                    left = Width - boxW
                Else
                    left = 0
                End If
            Else
                Select Case msPlacement.ToLowerCase
                    Case "top": top = 24dip
                    Case "bottom": top = Height - boxH - 24dip
                    Case "start"
                        left = 0
                        top = 0
                        boxH = Height
                    Case "end"
                        left = Width - boxW
                        top = 0
                        boxH = Height
                End Select
            End If
        End If
        
        mContentBox.SetLayoutAnimated(IIf(mbSidebar, miSidebarDuration, 0), left, top, boxW, boxH)
        
        ' Internal Layout
        LayoutInternal(boxW, boxH)
    End If
End Sub
#End Region

#Region Internal
Private Sub CalculateAutoHeight(ContainerWidth As Int) As Int
    Dim padMap As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtilities(padMap, msPadding, False)
    
    Dim pL As Int = padMap.Get("padding_left")
    Dim pT As Int = padMap.Get("padding_top")
    Dim pR As Int = padMap.Get("padding_right")
    Dim pB As Int = padMap.Get("padding_bottom")
    
    Dim contentW As Int = Max(1dip, ContainerWidth - pL - pR)
    
    Dim titleH As Int = 0
    If msTitle.Length > 0 Then
        titleH = 32dip ' Approx
    End If
    
    Dim bodyH As Int = 0
    For i = 0 To pnlBody.NumberOfViews - 1
        Dim v As B4XView = pnlBody.GetView(i)
        If v.Visible Then bodyH = Max(bodyH, v.Top + v.Height)
    Next
    
    Dim actionsH As Int = 0
    If partActions.getContainer.NumberOfViews > 0 Then
        actionsH = 48dip ' Approx or measured
    End If
    
    Return pT + titleH + bodyH + actionsH + pB + 16dip ' Extra gap
End Sub

Private Sub LayoutInternal(W As Int, H As Int)
    Dim padMap As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtilities(padMap, msPadding, False)
    
    Dim pL As Int = padMap.Get("padding_left")
    Dim pT As Int = padMap.Get("padding_top")
    Dim pR As Int = padMap.Get("padding_right")
    Dim pB As Int = padMap.Get("padding_bottom")
    
    Dim innerW As Int = Max(1dip, W - pL - pR)
    
    ' Title
    Dim titleH As Int = 0
    If msTitle.Length > 0 Then
        titleH = 32dip
        pnlTitle.Visible = True
        pnlTitle.SetLayoutAnimated(0, pL, pT, innerW, titleH)
        partTitle.Base_Resize(innerW, titleH)
        Dim titleLbl As B4XView = partTitle.getLabel
        If titleLbl.IsInitialized Then titleLbl.SetLayoutAnimated(0, 0, 0, innerW, titleH)
    Else
        pnlTitle.Visible = False
    End If
    
    ' Actions at bottom
    Dim actionsH As Int = 0
    If partActions.getContainer.NumberOfViews > 0 Then
        actionsH = 48dip
        pnlActions.Visible = True
        pnlActions.SetLayoutAnimated(0, pL, H - pB - actionsH, innerW, actionsH)
        partActions.Base_Resize(innerW, actionsH)
    Else
        pnlActions.Visible = False
    End If
    
    ' Body fills the rest
    Dim bodyY As Int = pT + titleH
    Dim bodyH As Int = Max(1dip, H - bodyY - actionsH - pB)
    pnlBody.SetLayoutAnimated(0, pL, bodyY, innerW, bodyH)
    
    ' Close Button — centre sits exactly on the top-right corner of the modal box
    If mShowCloseButton Then
        pnlClose.SetLayoutAnimated(0, W - 16dip, -16dip, 32dip, 32dip)
        partClose.Base_Resize(32dip, 32dip)
    End If
End Sub

Private Sub ResolveRadius(RoundedUtility As String) As Int
    Return B4XDaisyVariants.ResolveRoundedDip(RoundedUtility, 0)
End Sub

Private Sub mBackdrop_Click
    If mClickOutsideToClose Then
        Close
    End If
End Sub

Private Sub mContentBox_Click
    ' Consume
End Sub

Private Sub partClose_Click (Tag As Object)
    Close
End Sub
#End Region