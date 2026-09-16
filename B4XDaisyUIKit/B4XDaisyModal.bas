B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: Click (Tag As Object)
#Event: CloseClick (Tag As Object)
#Event: YesClick (Tag As Object)
#Event: NoClick (Tag As Object)
#Event: CancelClick (Tag As Object)
#Event: OkClick (Tag As Object)
#Event: RetryClick (Tag As Object)
#Event: AbortClick (Tag As Object)
#Event: IgnoreClick (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Auto-generated property for Enabled.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Auto-generated property for Visible.
#DesignerProperty: Key: ClickOutsideToClose, DisplayName: Click Outside To Close, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: FullScreen, DisplayName: Full Screen, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: GlassSize, DisplayName: Glass Size, FieldType: String, DefaultValue: none, List: none|glass-xs|glass-sm|glass-md|glass-lg|glass-xl|glass-2xl
#DesignerProperty: Key: Placement, DisplayName: Placement, FieldType: String, DefaultValue: middle, List: top|middle|bottom
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-[91.6%]
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: base-100, List: base-100|base-200|base-300|primary|secondary|accent|neutral|info|success|warning|error
#DesignerProperty: Key: BackdropColor, DisplayName: Backdrop Color, FieldType: String, DefaultValue: black, List: black|transparent
#DesignerProperty: Key: BackdropOpacity, DisplayName: Backdrop Opacity, FieldType: Int, DefaultValue: 40, MinRange: 0, MaxRange: 100
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: Modal Title
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-6
#DesignerProperty: Key: ActionsJustify, DisplayName: Actions Justify, FieldType: String, DefaultValue: end, List: start|center|end, Description: Horizontal alignment of action buttons in the footer.
#DesignerProperty: Key: ActionsVariant, DisplayName: Actions Variant, FieldType: String, DefaultValue: primary, List: none|primary|secondary|accent|neutral|ghost|link|outline, Description: Visual variant/style of action buttons.
#DesignerProperty: Key: ShowCloseButton, DisplayName: Show Close Button, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: Sidebar, DisplayName: Sidebar, FieldType: Boolean, DefaultValue: False, Description: When True the modal slides in as a side panel, ignoring Placement.
#DesignerProperty: Key: SidebarSide, DisplayName: Sidebar Side, FieldType: String, DefaultValue: left, List: left|right
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: lg, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow on the modal content box.
#DesignerProperty: Key: Animated, DisplayName: Animated, FieldType: Boolean, DefaultValue: True, Description: Enables or disables modal open/close animations.
#DesignerProperty: Key: Duration, DisplayName: Animation Duration (ms), FieldType: Int, DefaultValue: 300, MinRange: 0, MaxRange: 2000, Description: Duration of standard modal animations.
#DesignerProperty: Key: ActionType, DisplayName: Action Type, FieldType: String, DefaultValue: none, List: none|yes|no|cancel|yes-no|yes-no-cancel|ok-cancel|retry-cancel|abort-retry-ignore, Description: Preset action button configuration for the footer.
#DesignerProperty: Key: YesCaption, DisplayName: Yes/Ok/Retry/Abort Caption, FieldType: String, DefaultValue: Yes
#DesignerProperty: Key: YesVariant, DisplayName: Yes Variant, FieldType: String, DefaultValue: success, List: none|primary|secondary|accent|neutral|ghost|link|outline|success|warning|error
#DesignerProperty: Key: YesVisible, DisplayName: Yes Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: NoCaption, DisplayName: No/Retry Caption, FieldType: String, DefaultValue: No
#DesignerProperty: Key: NoVariant, DisplayName: No Variant, FieldType: String, DefaultValue: error, List: none|primary|secondary|accent|neutral|ghost|link|outline|success|warning|error
#DesignerProperty: Key: NoVisible, DisplayName: No Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: CancelCaption, DisplayName: Cancel/Ignore Caption, FieldType: String, DefaultValue: Cancel
#DesignerProperty: Key: CancelVariant, DisplayName: Cancel Variant, FieldType: String, DefaultValue: ghost, List: none|primary|secondary|accent|neutral|ghost|link|outline|success|warning|error
#DesignerProperty: Key: CancelVisible, DisplayName: Cancel Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: ButtonsWidth, DisplayName: Buttons Width, FieldType: String, DefaultValue: auto, Description: Width for preset action buttons (e.g. auto, 80dip, 100%).
#DesignerProperty: Key: ButtonsSize, DisplayName: Buttons Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg
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
    Private msWidth As String = "w-[91.6%]"
    Private msHeight As String = "h-auto"
    Private msRounded As String = "rounded-box"
    Private msBackgroundColor As String = "base-100"
    Private msBorderColor As String = "none"
    Private msBorderWidth As String = "0"
    Private msBackdropColor As String = "black"
    Private miBackdropOpacity As Int = 40
    Private msTitle As String = "Modal Title"
    Private msTitleColor As String = "none"
    Private msTitleTextColor As String = "none"
    Private msPadding As String = "p-6"
    Private msActionsJustify As String = "end"
    Private msActionsVariant As String = "primary"
    Private mShowCloseButton As Boolean = False
    Private mbSidebar As Boolean = False
    Private msSidebarSide As String = "left"
    ' Timer-driven sidebar slide animation engine (mirrors B4XDaisySheetModal)
    Private Anim As B4XDaisyAnimation
    Private mAnimTimer As Timer
    Private mSlideActive As Boolean = False
    Private mSlideStartMs As Long
    Private mSlideDuration As Int = 1
    Private mSlideEase As String = "easeOutExpo"
    Private mSlideStartLeft As Float
    Private mSlideChangeLeft As Float
    Private mSlideBoxW As Int
    Private mSlideBoxH As Int
    Private mSlideDismiss As Boolean = False
    Private mBackdropStartAlpha As Float
    Private mBackdropChangeAlpha As Float
    Private mBackdropAnim As Boolean = False
    Private msShadow As String = "lg"

    Private mIsRefreshing As Boolean = False
    
    ' Animation configuration
    Private mbAnimated As Boolean = True
    Private miDuration As Int = 300

    ' Action Presets State
    Private msActionType As String = "none"
    Private msYesCaption As String = "Yes"
    Private msYesVariant As String = "success"
    Private mbYesVisible As Boolean = True
    Private msNoCaption As String = "No"
    Private msNoVariant As String = "error"
    Private mbNoVisible As Boolean = True
    Private msCancelCaption As String = "Cancel"
    Private msCancelVariant As String = "ghost"
    Private mbCancelVisible As Boolean = True
    Private msButtonsWidth As String = "auto"
    Private msButtonsSize As String = "md"

    ' Action Presets Button References
    Private btnYes As B4XDaisyButton
    Private btnNo As B4XDaisyButton
    Private btnCancel As B4XDaisyButton
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    
    partTitle.Initialize(Me, "partTitle")
    partActions.Initialize(Me, "partActions")
    partClose.Initialize(Me, "partClose")
    InitAnimation
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    InitAnimation
    
    mBase.Color = xui.Color_Transparent
    
    mBackdrop = xui.CreatePanel("mBackdrop")
    mBase.AddView(mBackdrop, 0, 0, mBase.Width, mBase.Height)
    
    mContentBox = xui.CreatePanel("mContentBox")
    mBase.AddView(mContentBox, 0, 0, 1dip, 1dip)
    
    ' Internal structure within ContentBox
    pnlTitle = xui.CreatePanel("")
    mContentBox.AddView(pnlTitle, 0, 0, 1dip, 1dip)
    partTitle.AddToParent(pnlTitle, 0, 0, 1dip, 1dip)
    
    pnlBody = xui.CreatePanel("")
    mContentBox.AddView(pnlBody, 0, 0, 1dip, 1dip)
    
    pnlActions = xui.CreatePanel("")
    mContentBox.AddView(pnlActions, 0, 0, 1dip, 1dip)
    partActions.AddToParent(pnlActions, 0, 0, 1dip, 1dip)
    partActions.Wrap = True
    partActions.GapDip = 8dip

    pnlClose = xui.CreatePanel("pnlClose")
    mBase.AddView(pnlClose, 0, 0, 32dip, 32dip)
    partClose.AddToParent(pnlClose, 0, 0, 32dip, 32dip)
    partClose.Variant = "ghost"
    partClose.Circle = True
    partClose.Size = "sm"
    partClose.Text = ""
    partClose.IconName = "xmark-solid.svg"
    
    ApplyDesignerProps(mProps)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mEnabled)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
    mClickOutsideToClose = B4XDaisyVariants.GetPropBool(mProps, "ClickOutsideToClose", mClickOutsideToClose)
    mFullScreen = B4XDaisyVariants.GetPropBool(mProps, "FullScreen", mFullScreen)
    msGlassSize = B4XDaisyVariants.GetPropString(mProps, "GlassSize", msGlassSize)
    msPlacement = B4XDaisyVariants.GetPropString(mProps, "Placement", msPlacement)
    msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", msWidth)
    msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", msHeight)
    msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded)
    msBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "BackgroundColor", msBackgroundColor)
    msBackdropColor = B4XDaisyVariants.GetPropString(mProps, "BackdropColor", msBackdropColor)
    miBackdropOpacity = B4XDaisyVariants.GetPropInt(mProps, "BackdropOpacity", miBackdropOpacity)
    msTitle = B4XDaisyVariants.GetPropString(mProps, "Title", msTitle)
    msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
    msActionsJustify = B4XDaisyVariants.GetPropString(mProps, "ActionsJustify", msActionsJustify)
    mShowCloseButton = B4XDaisyVariants.GetPropBool(mProps, "ShowCloseButton", mShowCloseButton)
    mbSidebar = B4XDaisyVariants.GetPropBool(mProps, "Sidebar", mbSidebar)
    msSidebarSide = B4XDaisyVariants.GetPropString(mProps, "SidebarSide", msSidebarSide)
    msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow)
    mbAnimated = B4XDaisyVariants.GetPropBool(mProps, "Animated", mbAnimated)
    miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
    msActionsVariant = B4XDaisyVariants.GetPropString(mProps, "ActionsVariant", msActionsVariant)
    msActionType = B4XDaisyVariants.GetPropString(mProps, "ActionType", msActionType)
    msYesCaption = B4XDaisyVariants.GetPropString(mProps, "YesCaption", msYesCaption)
    msYesVariant = B4XDaisyVariants.GetPropString(mProps, "YesVariant", msYesVariant)
    mbYesVisible = B4XDaisyVariants.GetPropBool(mProps, "YesVisible", mbYesVisible)
    msNoCaption = B4XDaisyVariants.GetPropString(mProps, "NoCaption", msNoCaption)
    msNoVariant = B4XDaisyVariants.GetPropString(mProps, "NoVariant", msNoVariant)
    mbNoVisible = B4XDaisyVariants.GetPropBool(mProps, "NoVisible", mbNoVisible)
    msCancelCaption = B4XDaisyVariants.GetPropString(mProps, "CancelCaption", msCancelCaption)
    msCancelVariant = B4XDaisyVariants.GetPropString(mProps, "CancelVariant", msCancelVariant)
    mbCancelVisible = B4XDaisyVariants.GetPropBool(mProps, "CancelVisible", mbCancelVisible)
    msButtonsWidth = B4XDaisyVariants.GetPropString(mProps, "ButtonsWidth", msButtonsWidth)
    msButtonsSize = B4XDaisyVariants.GetPropString(mProps, "ButtonsSize", msButtonsSize)
    Refresh
End Sub
#End Region

#Region Public API
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    Dim empty As B4XView
    If vParent.IsInitialized = False Then Return empty
    If mBase.IsInitialized = False Then
        ' Usually called if not created via Designer
        Dim p As Panel
        p.Initialize("")
        Dim b As B4XView = p
        b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    Base_Resize(iWidth, iHeight)
    Refresh
    Return mBase
End Sub

Public Sub CreateView(vParent As B4XView, oTag As Object)
    mTag = oTag
    AddToParent(vParent, 0, 0, vParent.Width, vParent.Height)
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
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
    p.Put("ActionsJustify", msActionsJustify)
    p.Put("ShowCloseButton", mShowCloseButton)
    p.Put("Sidebar", mbSidebar)
    p.Put("SidebarSide", msSidebarSide)
    p.Put("Shadow", msShadow)
    p.Put("Animated", mbAnimated)
    p.Put("Duration", miDuration)
    p.Put("ActionType", msActionType)
    p.Put("YesCaption", msYesCaption)
    p.Put("YesVariant", msYesVariant)
    p.Put("YesVisible", mbYesVisible)
    p.Put("NoCaption", msNoCaption)
    p.Put("NoVariant", msNoVariant)
    p.Put("NoVisible", mbNoVisible)
    p.Put("CancelCaption", msCancelCaption)
    p.Put("CancelVariant", msCancelVariant)
    p.Put("CancelVisible", mbCancelVisible)
    p.Put("ButtonsWidth", msButtonsWidth)
    p.Put("ButtonsSize", msButtonsSize)
    Return p
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub getAnimated As Boolean
    Return mbAnimated
End Sub

Public Sub setAnimated(bValue As Boolean)
    mbAnimated = bValue
End Sub

Public Sub getDuration As Int
    Return miDuration
End Sub

Public Sub setDuration(iValue As Int)
    miDuration = iValue
End Sub

Public Sub getActionsContainer As B4XView
    Return partActions.getContainer
End Sub

''' Creates and adds an action button to the modal footer in one call.
''' buttonID   - event name (and Tag) used for the <buttonID>_Click event handler.
''' buttonText - label displayed on the button.
''' buttonColor - DaisyUI variant, e.g. "primary", "ghost", "secondary".
''' Usage: modal.AddActionButton("btnConfirm", "Confirm", "primary")
Public Sub AddActionButton(sButtonID As String, sButtonText As String, sButtonColor As String) As B4XDaisyButton
	Dim btn As B4XDaisyButton
	btn.Initialize(mCallBack, sButtonID)
	btn.Tag = sButtonID
	btn.Text = sButtonText
	btn.Size = "md"
	btn.Variant = sButtonColor
	btn.Shadow = "none"
	AddAction(btn)
	Return btn
End Sub

''' Adds a B4XDaisyButton to the modal actions footer.
''' The button is created inside the actions slot automatically - no external AddToParent needed.
''' Usage: modal.AddAction(btn)
''' Note: Call modal.Refresh after adding all actions to trigger layout.
Public Sub AddAction(btn As B4XDaisyButton)
    If mBase.IsInitialized = False Then Return
    ' Button may not yet have a base view (only Initialize'd, not AddToParent'd).
    ' Use AddToParent which creates the view tree with the given dimensions.
    If btn.mBase.IsInitialized = False Or btn.mBase.Width < 1dip Then
        btn.AddToParent(partActions.getContainer, 0, 0, 80dip, 32dip)
    Else
        If btn.mBase.Parent <> partActions.getContainer Then
            partActions.getContainer.AddView(btn.mBase, 0, 0, btn.mBase.Width, btn.mBase.Height)
        End If
    End If
End Sub

''' Returns the number of action buttons currently in the footer.
Public Sub getActionsCount As Int
    Return partActions.getContainer.NumberOfViews
End Sub

''' Removes all action buttons from the footer.
Public Sub ClearActions
    partActions.getContainer.RemoveAllViews
    If mBase.IsInitialized Then Refresh
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
        If mBackdrop.IsInitialized Then mBackdrop.Alpha = 0
        BeginSlide(startLeft, targetLeft, boxW, boxH, False)
    Else
        If mBase.IsInitialized Then
            setVisible(True)
            
            Dim boxW As Int
            Dim boxH As Int
            If mFullScreen Then
                boxW = mBase.Width
                boxH = mBase.Height
            Else
                boxW = B4XDaisyVariants.ResolveSizeSpec(msWidth, mBase.Width, 320dip)
                If msHeight = "h-auto" Then
                    boxH = CalculateAutoHeight(boxW)
                Else
                    boxH = B4XDaisyVariants.ResolveSizeSpec(msHeight, mBase.Height, 200dip)
                End If
            End If
            
            Dim left As Int = (mBase.Width - boxW) / 2
            Dim top As Int = (mBase.Height - boxH) / 2
            If mFullScreen = False Then
                Select Case msPlacement.ToLowerCase
                    Case "top": top = 24dip
                    Case "bottom": top = mBase.Height - boxH - 24dip
                End Select
            End If
            
            Dim showDuration As Int = IIf(mbAnimated, miDuration, 0)
            
            ' Fade in backdrop
            Dim bc As Int = xui.Color_Transparent
            If msBackdropColor = "black" Then
                Dim alpha As Int = (miBackdropOpacity * 255) / 100
                bc = Bit.Or(Bit.And(xui.Color_Black, 0x00ffffff), Bit.ShiftLeft(alpha, 24))
            End If
            mBackdrop.Color = xui.Color_Transparent
            mBackdrop.SetColorAnimated(showDuration, xui.Color_Transparent, bc)
            
            ' Slide up content box
            Dim startTop As Int = top + 50dip
            mContentBox.SetLayoutAnimated(0, left, startTop, boxW, boxH)
            mContentBox.SetLayoutAnimated(showDuration, left, top, boxW, boxH)
            
            ' Animate close button along with content box
            If mShowCloseButton Then
                pnlClose.Alpha = 1
                Dim closeL As Int = left + boxW - 16dip
                pnlClose.SetLayoutAnimated(0, closeL, startTop - 16dip, 32dip, 32dip)
                pnlClose.SetLayoutAnimated(showDuration, closeL, top - 16dip, 32dip, 32dip)
            End If
        Else
            setVisible(True)
        End If
    End If
End Sub

Public Sub ShowModal
    Show
End Sub

Public Sub Close
    Dim hasSidebarAnimation As Boolean = mbSidebar And mBase.IsInitialized And miDuration > 0 And mbAnimated
    If hasSidebarAnimation Then
        ' Slide off-screen before hiding (timer-driven easing)
        Dim offLeft As Int
        If msSidebarSide.ToLowerCase = "right" Then
            offLeft = mBase.Width
        Else
            offLeft = -mContentBox.Width
        End If
        BeginSlide(mContentBox.Left, offLeft, mContentBox.Width, mContentBox.Height, True)
    Else
        If mBase.IsInitialized Then
            Dim closeDuration As Int = IIf(mbAnimated, miDuration, 0)
            
            ' Fade out backdrop color
            mBackdrop.SetColorAnimated(closeDuration, mBackdrop.Color, xui.Color_Transparent)
            
            ' Slide down content box
            Dim boxW As Int = mContentBox.Width
            Dim boxH As Int = mContentBox.Height
            Dim left As Int = mContentBox.Left
            Dim top As Int = mContentBox.Top
            Dim targetTop As Int = top + 50dip
            mContentBox.SetLayoutAnimated(closeDuration, left, targetTop, boxW, boxH)
            
            ' Animate close button along with content box
            If mShowCloseButton Then
                Dim closeL As Int = left + boxW - 16dip
                pnlClose.SetLayoutAnimated(closeDuration, closeL, targetTop - 16dip, 32dip, 32dip)
                pnlClose.Alpha = 0
            End If
            
            If closeDuration > 0 Then
                Sleep(closeDuration)
            End If
            setVisible(False)
        Else
            setVisible(False)
        End If
    End If
End Sub

Private Sub InitAnimation
    If mAnimTimer.IsInitialized = False Then
        Anim.Initialize
        mAnimTimer.Initialize("mAnimTimer", 16)
        mAnimTimer.Enabled = False
    End If
End Sub

''' <summary>
''' Starts the timer-driven sidebar slide. Mirrors B4XDaisySheetModal: a Timer ticks
''' ~60fps applying an easeOutExpo curve to mContentBox.Left while fading the backdrop
''' alpha. On completion it finalises the position and, for a dismiss, hides the modal.
''' Duration comes from the Duration property (0 = instant snap).
''' </summary>
Private Sub BeginSlide(fStartLeft As Float, fTargetLeft As Float, iBoxW As Int, iBoxH As Int, bDismiss As Boolean)
    If mAnimTimer.IsInitialized = False Then Return
    mAnimTimer.Enabled = False
    mSlideActive = False
    mSlideBoxW = iBoxW
    mSlideBoxH = iBoxH
    mSlideStartLeft = fStartLeft
    mSlideChangeLeft = fTargetLeft - fStartLeft
    mSlideDismiss = bDismiss
    
    Dim duration As Int = miDuration
    If mbAnimated = False Then duration = 0
    
    If duration <= 0 Or mSlideChangeLeft = 0 Then
        mContentBox.SetLayoutAnimated(0, fTargetLeft, 0, iBoxW, iBoxH)
        If mBackdrop.IsInitialized Then mBackdrop.Alpha = IIf(bDismiss, 0, 1)
        CompleteSlide
        Return
    End If
    mSlideDuration = Max(1, miDuration)
    mSlideStartMs = DateTime.Now
    mSlideEase = "easeOutExpo"
    If mBackdrop.IsInitialized Then
        mBackdropStartAlpha = mBackdrop.Alpha
        mBackdropChangeAlpha = IIf(bDismiss, 0, 1) - mBackdrop.Alpha
        mBackdropAnim = True
    Else
        mBackdropAnim = False
    End If
    mSlideActive = True
    mAnimTimer.Enabled = True
    
    ' Snap close button to start position for sidebar animation
    If mShowCloseButton Then
        Dim closeL As Int = fStartLeft + iBoxW - 16dip
        pnlClose.SetLayoutAnimated(0, closeL, -16dip, 32dip, 32dip)
    End If
End Sub

Private Sub mAnimTimer_Tick
    If mSlideActive = False Then Return
    Dim elapsed As Long = DateTime.Now - mSlideStartMs
    If elapsed >= mSlideDuration Then
        mContentBox.SetLayoutAnimated(0, mSlideStartLeft + mSlideChangeLeft, 0, mSlideBoxW, mSlideBoxH)
        If mBackdropAnim And mBackdrop.IsInitialized Then mBackdrop.Alpha = mBackdropStartAlpha + mBackdropChangeAlpha
        mSlideActive = False
        mAnimTimer.Enabled = False
        CompleteSlide
        Return
    End If
    Dim t As Float = elapsed
    mContentBox.Left = EvalEase(mSlideEase, t, mSlideStartLeft, mSlideChangeLeft, mSlideDuration)
    If mBackdropAnim And mBackdrop.IsInitialized Then mBackdrop.Alpha = EvalEase(mSlideEase, t, mBackdropStartAlpha, mBackdropChangeAlpha, mSlideDuration)
    
    ' Keep close button corner-anchored to content box during sidebar slide
    If mShowCloseButton Then
        pnlClose.Left = mContentBox.Left + mContentBox.Width - 16dip
    End If
End Sub

Private Sub CompleteSlide
    If mSlideDismiss Then setVisible(False)
End Sub

Private Sub EvalEase(sEase As String, fT As Float, fStart As Float, fChange As Float, iDuration As Int) As Float
    Select sEase
        Case "linear"
            Return Anim.linearTween(fT, fStart, fChange, iDuration)
        Case "easeOutQuad"
            Return Anim.easeOutQuad(fT, fStart, fChange, iDuration)
        Case "easeOutQuart"
            Return Anim.easeOutQuart(fT, fStart, fChange, iDuration)
        Case "easeOutExpo"
            Return Anim.easeOutExpo(fT, fStart, fChange, iDuration)
        Case Else
            Return Anim.easeOutCubic(fT, fStart, fChange, iDuration)
    End Select
End Sub

Public Sub setEnabled(bValue As Boolean)
    mEnabled = bValue
    If mBase.IsInitialized = False Then Return
    mBase.Enabled = bValue
End Sub

Public Sub getEnabled As Boolean
    Return mEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
    mVisible = bValue
    If mBase.IsInitialized = False Then Return
    mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
    Return mVisible
End Sub

Public Sub setFullScreen(bValue As Boolean)
    mFullScreen = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getFullScreen As Boolean
    Return mFullScreen
End Sub

Public Sub setGlassSize(sValue As String)
    msGlassSize = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getGlassSize As String
    Return msGlassSize
End Sub

Public Sub setRounded(sValue As String)
    msRounded = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setClickOutsideToClose(bValue As Boolean)
    mClickOutsideToClose = bValue
End Sub

Public Sub getClickOutsideToClose As Boolean
    Return mClickOutsideToClose
End Sub

Public Sub setPlacement(sValue As String)
    msPlacement = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPlacement As String
    Return msPlacement
End Sub

Public Sub setWidth(sValue As String)
    msWidth = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(sValue As String)
    msHeight = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setBackgroundColor(sValue As String)
    msBackgroundColor = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setBackdropColor(sValue As String)
    msBackdropColor = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackdropColor As String
    Return msBackdropColor
End Sub

Public Sub setBackdropOpacity(iValue As Int)
    miBackdropOpacity = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBackdropOpacity As Int
    Return miBackdropOpacity
End Sub

Public Sub setPadding(sValue As String)
    msPadding = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setTitle(sValue As String)
    msTitle = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTitle As String
    Return msTitle
End Sub

' Title bar background variant (e.g. "primary"). When a variant is used the
' title text automatically switches to the matching <variant>-content color
' for contrast, unless TitleTextColor is set explicitly.
Public Sub setTitleColor(sValue As String)
    msTitleColor = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTitleColor As String
    Return msTitleColor
End Sub

' Explicit title text color (variant name or color token). Overrides the
' automatic -content color that TitleColor would apply.
Public Sub setTitleTextColor(sValue As String)
    msTitleTextColor = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTitleTextColor As String
    Return msTitleTextColor
End Sub

' Content box border color (variant name or color token, e.g. "primary").
Public Sub setBorderColor(sValue As String)
    msBorderColor = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderColor As String
    Return msBorderColor
End Sub

' Content box border width (Tailwind token or CSS size, e.g. "border-2", "2px").
Public Sub setBorderWidth(sValue As String)
    msBorderWidth = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getBorderWidth As String
    Return msBorderWidth
End Sub
Public Sub setShowCloseButton(bValue As Boolean)
    mShowCloseButton = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShowCloseButton As Boolean
    Return mShowCloseButton
End Sub

Public Sub setSidebar(bValue As Boolean)
    mbSidebar = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSidebar As Boolean
    Return mbSidebar
End Sub

Public Sub setSidebarSide(sValue As String)
    msSidebarSide = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getSidebarSide As String
    Return msSidebarSide
End Sub


Public Sub setActionsJustify(sValue As String)
    msActionsJustify = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getActionsJustify As String
    Return msActionsJustify
End Sub

Public Sub setShadow(sValue As String)
    msShadow = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
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
    
    ' Border (resolved once; applied in the non-sidebar branch below)
    Dim borderW As Int = Max(0, Round(B4XDaisyVariants.TailwindBorderWidthToDip(msBorderWidth, 0)))
    Dim borderC As Int = B4XDaisyVariants.ResolveBorderColorVariant(msBorderColor, xui.Color_Black)
    
    If mbSidebar And msGlassSize = "none" Then
        ' Zero the radii on the edge that touches the screen border
        Dim side As String = msSidebarSide.ToLowerCase
        Dim tlR As Float = IIf(side = "left", 0, radius)
        Dim trR As Float = IIf(side = "right", 0, radius)
        Dim brR As Float = IIf(side = "right", 0, radius)
        Dim blR As Float = IIf(side = "left", 0, radius)
        B4XDaisyVariants.SetColorPerCornerRadius(mContentBox, bgColor, tlR, trR, brR, blR)
    Else
        mContentBox.SetColorAndBorder(bgColor, borderW, borderC, radius)
        If msGlassSize <> "none" Then
            B4XDaisyVariants.ApplyGlassStyle(mContentBox, radius, msGlassSize)
        End If
    End If
    B4XDaisyVariants.ApplyElevation(mContentBox, msShadow)
    
    partTitle.Text = msTitle
    
    ' Title bar background + auto-paired text color.
    ' The title bar uses the same corner radius as the modal box (Rounded property).
    Dim titleBgSpec As String = msTitleColor.Trim
    Dim titleBg As Int
    If titleBgSpec.Length > 0 And titleBgSpec.ToLowerCase <> "none" Then
        titleBg = B4XDaisyVariants.ResolveBackgroundColorVariant(titleBgSpec, xui.Color_Transparent)
    Else
        titleBg = xui.Color_Transparent
    End If
    pnlTitle.SetColorAndBorder(titleBg, 0, 0, radius)
    
    ' Title text color: explicit TitleTextColor wins, else TitleColor variant applies its -content color
    Dim titleFgSpec As String = msTitleTextColor.Trim
    If titleFgSpec.Length > 0 And titleFgSpec.ToLowerCase <> "none" Then
        partTitle.setTextColor(B4XDaisyVariants.ResolveTextColorVariant(titleFgSpec, 0))
    Else If titleBgSpec.Length > 0 And titleBgSpec.ToLowerCase <> "none" Then
        partTitle.setTextColor(B4XDaisyVariants.ResolveTextColorVariant(titleBgSpec & "-content", 0))
    Else
        partTitle.setTextColor(0) ' default (base-content)
    End If
    
    pnlClose.Visible = mShowCloseButton
    
    BuildPresetActions

    ' 3. Layout Trigger
    Base_Resize(mBase.Width, mBase.Height)
    
    mBase.Enabled = mEnabled
    mBase.Visible = mVisible
    mIsRefreshing = False
End Sub

Public Sub AddToContent(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    pnlBody.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
    Refresh ' Re-calc auto height
End Sub

Public Sub getBodyContainer As B4XView
    Return pnlBody
End Sub

' Returns the current width of the body container (in pixels / dip as laid out).
Public Sub BodyWidth As Int
    Return pnlBody.Width
End Sub

' Removes all views from the body container.
Public Sub ClearBody
    pnlBody.RemoveAllViews
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If inResize Then Return
    inResize = True
    If mBackdrop.IsInitialized Then mBackdrop.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    
    If mContentBox.IsInitialized Then
        Dim boxW As Int
        Dim boxH As Int
        
        If mFullScreen Then
            boxW = dWidth
            boxH = dHeight
        Else
            ' Resolve Width
            boxW = B4XDaisyVariants.ResolveSizeSpec(msWidth, dWidth, 320dip)

            ' When close button is visible, ensure enough right-edge margin for the button
            ' (the button center is on the corner, so half its width overflows past the modal)
            If mShowCloseButton Then
                Dim margin As Int = (dWidth - boxW) / 2
                Dim minMargin As Int = 24dip ' 16dip button half-width + 8dip safety
                If margin < minMargin Then
                    boxW = dWidth - 2 * minMargin
                End If
            End If
            
            ' Resolve Height
            If msHeight = "h-auto" Then
                boxH = CalculateAutoHeight(boxW)
            Else
                boxH = B4XDaisyVariants.ResolveSizeSpec(msHeight, dHeight, 200dip)
            End If
        End If
        
        Dim left As Int = (dWidth - boxW) / 2
        Dim top As Int = (dHeight - boxH) / 2
        
        If mFullScreen = False Then
            If mbSidebar Then
                ' Sidebar: full height, anchored to left or right edge
                boxH = dHeight
                top = 0
                If msSidebarSide.ToLowerCase = "right" Then
                    left = dWidth - boxW
                Else
                    left = 0
                End If
            Else
                Select Case msPlacement.ToLowerCase
                    Case "top": top = 24dip
                    Case "bottom": top = dHeight - boxH - 24dip
                    Case "start"
                        left = 0
                        top = 0
                        boxH = dHeight
                    Case "end"
                        left = dWidth - boxW
                        top = 0
                        boxH = dHeight
                End Select
            End If
        End If
        
        mContentBox.SetLayoutAnimated(IIf(mbSidebar, miDuration, 0), left, top, boxW, boxH)
        
        ' Internal Layout
        LayoutInternal(boxW, boxH)
    End If
    inResize = False
End Sub
#End Region

#Region Internal
Private Sub CalculateAutoHeight(iContainerWidth As Int) As Int
    Dim padMap As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtilities(padMap, msPadding, False)

    Dim pL As Int = padMap.Get("padding_left")
    Dim pT As Int = padMap.Get("padding_top")
    Dim pR As Int = padMap.Get("padding_right")
    Dim pB As Int = padMap.Get("padding_bottom")

    Dim contentW As Int = Max(1dip, iContainerWidth - pL - pR)

    Dim titleH As Int = 0
    If msTitle.Length > 0 Then
        partTitle.Base_Resize(contentW, 32dip)
        titleH = partTitle.GetComputedHeight
    End If

    Dim bodyH As Int = 0
    For i = 0 To pnlBody.NumberOfViews - 1
        Dim v As B4XView = pnlBody.GetView(i)
        If v.Visible Then bodyH = Max(bodyH, Max(0, v.Top) + v.Height)
    Next

    Dim actionsH As Int = 0
    If partActions.getContainer.NumberOfViews > 0 Then
        actionsH = MeasureActionsHeight(contentW, partActions.GapDip, partActions.Wrap)
    End If

    Dim gapTB As Int = IIf(titleH > 0, 12dip, 0)
    Dim gapBA As Int = IIf(actionsH > 0, 16dip, 0)

    ' Cap auto height to the parent container height minus minimal margins
    Dim maxAvailable As Int = mBase.Height - 48dip
    Dim calculatedH As Int = pT + titleH + gapTB + bodyH + gapBA + actionsH + pB
    If maxAvailable > 0 Then
        Return Min(calculatedH, Max(100dip, maxAvailable))
    End If
    Return calculatedH
End Sub

Private Sub LayoutInternal(iW As Int, iH As Int)
    Dim padMap As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtilities(padMap, msPadding, False)
    
    Dim pL As Int = padMap.Get("padding_left")
    Dim pT As Int = padMap.Get("padding_top")
    Dim pR As Int = padMap.Get("padding_right")
    Dim pB As Int = padMap.Get("padding_bottom")
    
    Dim innerW As Int = Max(1dip, iW - pL - pR)
    
    ' Title
    Dim titleH As Int = 0
    If msTitle.Length > 0 Then
        pnlTitle.Visible = True
        partTitle.Base_Resize(innerW, 32dip)
        titleH = partTitle.GetComputedHeight
        pnlTitle.SetLayoutAnimated(0, pL, pT, innerW, titleH)
        Dim titleLbl As B4XView = partTitle.getLabel
        If titleLbl.IsInitialized Then titleLbl.SetLayoutAnimated(0, 0, 0, innerW, titleH)
    Else
        pnlTitle.Visible = False
    End If
    
    ' Actions at bottom
    Dim actionsH As Int = 0
    If partActions.getContainer.NumberOfViews > 0 Then
        ' Measure exact height needed for all button children (handles wrapping)
        actionsH = MeasureActionsHeight(innerW, partActions.GapDip, partActions.Wrap)
        pnlActions.Visible = True
        pnlActions.SetLayoutAnimated(0, pL, iH - pB - actionsH, innerW, actionsH)
        ' CRITICAL FIX: Resize partActions.mBase FIRST (without triggering Relayout via Base_Resize),
        ' THEN set Justify which triggers Relayout with the correct container width.
        ' This prevents Relayout from squishing buttons to the old container width (1dip).
        partActions.getContainer.SetLayoutAnimated(0, 0, 0, innerW, actionsH)
        partActions.Justify = msActionsJustify
        ' Vertically center buttons within the actions panel
        Dim totalBtnH As Int = 0
        Dim visibleCount As Int = 0
        For i = 0 To partActions.getContainer.NumberOfViews - 1
            Dim v As B4XView = partActions.getContainer.GetView(i)
            If v.Visible Then
                totalBtnH = Max(totalBtnH, v.Height)
                visibleCount = visibleCount + 1
            End If
        Next
        If visibleCount > 0 Then
            Dim offsetY As Int = Max(0, (actionsH - totalBtnH) / 2)
            For i = 0 To partActions.getContainer.NumberOfViews - 1
                Dim v As B4XView = partActions.getContainer.GetView(i)
                If v.Visible Then
                    v.SetLayoutAnimated(0, v.Left, offsetY, v.Width, v.Height)
                End If
            Next
        End If
    Else
        ' No action buttons - collapse the actions panel to 0 height so body fills the space
        pnlActions.Visible = False
        pnlActions.SetLayoutAnimated(0, 0, 0, 0, 0)
        partActions.getContainer.SetLayoutAnimated(0, 0, 0, 0, 0)
    End If
    
    Dim gapTB As Int = IIf(titleH > 0, 12dip, 0)
    Dim gapBA As Int = IIf(actionsH > 0, 16dip, 0)

    ' Body fills the rest
    Dim bodyY As Int = pT + titleH + gapTB
    Dim bodyH As Int = Max(1dip, iH - bodyY - actionsH - gapBA - pB)
    pnlBody.SetLayoutAnimated(0, pL, bodyY, innerW, bodyH)
    
    ' Re-trigger Base_Resize on custom views in the body so they can align/center to the updated dimensions
    For i = 0 To pnlBody.NumberOfViews - 1
        Dim v As B4XView = pnlBody.GetView(i)
        If v.Visible And v.Tag <> Null Then
            If SubExists(v.Tag, "Base_Resize") Then
                CallSub3(v.Tag, "Base_Resize", v.Width, v.Height)
            Else If SubExists(v.Tag, "Refresh") Then
                CallSub(v.Tag, "Refresh")
            End If
        End If
    Next

    ' Close Button - centre sits exactly on the top-right corner of the modal box
    ' pnlClose is now a sibling of mContentBox (not a child) so it's not clipped by clipToOutline
    If mShowCloseButton Then
        Dim closeLeft As Int = mContentBox.Left + mContentBox.Width - 16dip
        Dim closeTop As Int = mContentBox.Top - 16dip
        pnlClose.SetLayoutAnimated(0, closeLeft, closeTop, 32dip, 32dip)
        partClose.Base_Resize(32dip, 32dip)
        ' Give pnlClose higher elevation than mContentBox so it renders on top
        Try
            Dim joClose As JavaObject = pnlClose
            Dim closeElev As Float = 9999
            joClose.RunMethod("setElevation", Array As Object(closeElev))
            joClose.RunMethod("setTranslationZ", Array As Object(closeElev))
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyModal.LayoutInternal: " & LastException.Message)
        End Try
        pnlClose.BringToFront
    End If

    ' CRITICAL: Bring actions panel to front so buttons are visible above body/title
    If partActions.getContainer.NumberOfViews > 0 Then
        mContentBox.BringToFront
        pnlActions.BringToFront
        ' Also bring individual buttons to front within their container
        For i = 0 To partActions.getContainer.NumberOfViews - 1
            Dim btnV As B4XView = partActions.getContainer.GetView(i)
            If btnV.Visible Then btnV.BringToFront
        Next
    End If
End Sub

''' Measures the exact height needed for all action button children, accounting for wrapping.
Private Sub MeasureActionsHeight(iAvailableWidth As Int, iGapDip As Int, bWrap As Boolean) As Int
    Dim container As B4XView = partActions.getContainer
    If container.IsInitialized = False Then Return 0
    Dim rowW As Int = 0
    Dim rowH As Int = 0
    Dim totalH As Int = 0
    Dim hasRow As Boolean = False
    For i = 0 To container.NumberOfViews - 1
        Dim v As B4XView = container.GetView(i)
        If v.Visible = False Then Continue
        Dim vw As Int = Max(1dip, Min(iAvailableWidth, v.Width))
        Dim vh As Int = Max(1dip, v.Height)
        Dim addW As Int = vw
        If hasRow Then addW = addW + iGapDip
        If bWrap And hasRow And rowW + addW > iAvailableWidth Then
            totalH = totalH + rowH + iGapDip
            rowW = vw
            rowH = vh
        Else
            rowW = rowW + addW
            rowH = Max(rowH, vh)
        End If
        hasRow = True
    Next
    If hasRow Then totalH = totalH + rowH
    Return Max(0, totalH)
End Sub

Private Sub ResolveRadius(sRoundedUtility As String) As Int
    Return B4XDaisyVariants.ResolveRoundedDip(sRoundedUtility, 0)
End Sub

Private Sub mBackdrop_Click
    If mClickOutsideToClose Then
        Close
    End If
End Sub

Private Sub mContentBox_Click
    ' Consume
End Sub

Private Sub partClose_Click (oTag As Object)
    Close
End Sub
#End Region

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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

#End Region
Public Sub getActionsVariant As String
    Return msActionsVariant
End Sub

Public Sub setActionsVariant(sValue As String)
    msActionsVariant = sValue
End Sub

#Region Action Presets Logic and Accessors
Public Sub setActionType(sValue As String)
	msActionType = sValue.ToLowerCase.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getActionType As String
	Return msActionType
End Sub

Public Sub setYesCaption(sValue As String)
	msYesCaption = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getYesCaption As String
	Return msYesCaption
End Sub

Public Sub setYesVariant(sValue As String)
	msYesVariant = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getYesVariant As String
	Return msYesVariant
End Sub

Public Sub setYesVisible(bValue As Boolean)
	mbYesVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getYesVisible As Boolean
	Return mbYesVisible
End Sub

Public Sub setNoCaption(sValue As String)
	msNoCaption = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getNoCaption As String
	Return msNoCaption
End Sub

Public Sub setNoVariant(sValue As String)
	msNoVariant = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getNoVariant As String
	Return msNoVariant
End Sub

Public Sub setNoVisible(bValue As Boolean)
	mbNoVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getNoVisible As Boolean
	Return mbNoVisible
End Sub

Public Sub setCancelCaption(sValue As String)
	msCancelCaption = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCancelCaption As String
	Return msCancelCaption
End Sub

Public Sub setCancelVariant(sValue As String)
	msCancelVariant = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCancelVariant As String
	Return msCancelVariant
End Sub

Public Sub setCancelVisible(bValue As Boolean)
	mbCancelVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCancelVisible As Boolean
	Return mbCancelVisible
End Sub

Public Sub setButtonsWidth(sValue As String)
	msButtonsWidth = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getButtonsWidth As String
	Return msButtonsWidth
End Sub

Public Sub setButtonsSize(sValue As String)
	msButtonsSize = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getButtonsSize As String
	Return msButtonsSize
End Sub

Public Sub getYesButton As B4XDaisyButton
	Return btnYes
End Sub

Public Sub getNoButton As B4XDaisyButton
	Return btnNo
End Sub

Public Sub getCancelButton As B4XDaisyButton
	Return btnCancel
End Sub

Private Sub BuildPresetActions
	If mBase.IsInitialized = False Then Return
	Dim actType As String = msActionType.ToLowerCase.Trim
	If actType = "none" Or actType.Length = 0 Then Return

	' Clear existing views in actions container to build preset buttons
	partActions.getContainer.RemoveAllViews

	Dim btnW As Int = 80dip
	If msButtonsWidth <> "auto" And msButtonsWidth <> "" Then
		btnW = Max(40dip, B4XDaisyVariants.GetPropSizeDip(CreateMap("Width": msButtonsWidth), "Width", "80dip"))
	End If

	' Determine buttons needed
	Dim needYes As Boolean = False
	Dim needNo As Boolean = False
	Dim needCancel As Boolean = False

	Dim yesTag As String = "yes"
	Dim noTag As String = "no"
	Dim cancelTag As String = "cancel"

	Dim defaultYesCaption As String = msYesCaption
	Dim defaultNoCaption As String = msNoCaption
	Dim defaultCancelCaption As String = msCancelCaption

	Select Case actType
		Case "yes"
			needYes = True
		Case "no"
			needNo = True
		Case "cancel"
			needCancel = True
		Case "yes-no"
			needYes = True
			needNo = True
		Case "yes-no-cancel"
			needYes = True
			needNo = True
			needCancel = True
		Case "ok-cancel"
			needYes = True
			needCancel = True
			yesTag = "ok"
			If defaultYesCaption = "Yes" Then defaultYesCaption = "OK"
		Case "retry-cancel"
			needYes = True
			needCancel = True
			yesTag = "retry"
			If defaultYesCaption = "Yes" Then defaultYesCaption = "Retry"
		Case "abort-retry-ignore"
			needYes = True
			needNo = True
			needCancel = True
			yesTag = "abort"
			noTag = "retry"
			cancelTag = "ignore"
			If defaultYesCaption = "Yes" Then defaultYesCaption = "Abort"
			If defaultNoCaption = "No" Then defaultNoCaption = "Retry"
			If defaultCancelCaption = "Cancel" Then defaultCancelCaption = "Ignore"
	End Select

	If needYes And mbYesVisible Then
		Dim bY As B4XDaisyButton
		bY.Initialize(Me, "btnPresetYes")
		btnYes = bY
		btnYes.Tag = yesTag
		btnYes.Text = defaultYesCaption
		btnYes.Variant = msYesVariant
		btnYes.Size = msButtonsSize
		btnYes.Shadow = "none"
		btnYes.AddToParent(partActions.getContainer, 0, 0, btnW, 36dip)
	End If

	If needNo And mbNoVisible Then
		Dim bN As B4XDaisyButton
		bN.Initialize(Me, "btnPresetNo")
		btnNo = bN
		btnNo.Tag = noTag
		btnNo.Text = defaultNoCaption
		btnNo.Variant = msNoVariant
		btnNo.Size = msButtonsSize
		btnNo.Shadow = "none"
		btnNo.AddToParent(partActions.getContainer, 0, 0, btnW, 36dip)
	End If

	If needCancel And mbCancelVisible Then
		Dim bC As B4XDaisyButton
		bC.Initialize(Me, "btnPresetCancel")
		btnCancel = bC
		btnCancel.Tag = cancelTag
		btnCancel.Text = defaultCancelCaption
		btnCancel.Variant = msCancelVariant
		btnCancel.Size = msButtonsSize
		btnCancel.Shadow = "none"
		btnCancel.AddToParent(partActions.getContainer, 0, 0, btnW, 36dip)
	End If
End Sub

Private Sub btnPresetYes_Click(oTag As Object)
	Close
	Dim act As String = oTag
	Select Case act
		Case "ok"
			RaiseEvent("OkClick", oTag)
		Case "retry"
			RaiseEvent("RetryClick", oTag)
		Case "abort"
			RaiseEvent("AbortClick", oTag)
		Case Else
			RaiseEvent("YesClick", oTag)
	End Select
End Sub

Private Sub btnPresetNo_Click(oTag As Object)
	Close
	Dim act As String = oTag
	Select Case act
		Case "retry"
			RaiseEvent("RetryClick", oTag)
		Case Else
			RaiseEvent("NoClick", oTag)
	End Select
End Sub

Private Sub btnPresetCancel_Click(oTag As Object)
	Close
	Dim act As String = oTag
	Select Case act
		Case "ignore"
			RaiseEvent("IgnoreClick", oTag)
		Case Else
			RaiseEvent("CancelClick", oTag)
	End Select
End Sub

Private Sub RaiseEvent(sSuffix As String, oTag As Object)
	If xui.SubExists(mCallBack, mEventName & "_" & sSuffix, 1) Then
		CallSub2(mCallBack, mEventName & "_" & sSuffix, oTag)
	Else If xui.SubExists(mCallBack, mEventName & "_" & sSuffix, 0) Then
		CallSub(mCallBack, mEventName & "_" & sSuffix)
	End If
End Sub
#End Region
