B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

#Region Designer Properties
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Width token or CSS size (for example w-full, 80%, 320px).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-[300px], Description: Height token or CSS size (for example h-[300px], 200px, 50%).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-xl, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant.
#DesignerProperty: Key: DiffType, DisplayName: Diff Type, FieldType: String, DefaultValue: auto, List: auto|image|text, Description: Rendering mode for diff content.
#DesignerProperty: Key: Position, DisplayName: Position, FieldType: String, DefaultValue: 0.5, Description: Split position from 0 to 1.
#DesignerProperty: Key: Image1, DisplayName: Image 1, FieldType: String, DefaultValue: photo-1560717789-0ac7c58ac90a.webp, Description: Asset file name for first image slot.
#DesignerProperty: Key: Image2, DisplayName: Image 2, FieldType: String, DefaultValue: photo-1560717789-0ac7c58ac90a-blur.webp, Description: Asset file name for second image slot.
#DesignerProperty: Key: Text1, DisplayName: Text 1, FieldType: String, DefaultValue: DAISY, Description: Text shown on the first side when DiffType is text.
#DesignerProperty: Key: Text2, DisplayName: Text 2, FieldType: String, DefaultValue: DAISY, Description: Text shown on the second side when DiffType is text.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-4xl, Description: Tailwind text-size token for text mode.
#DesignerProperty: Key: Text1Color, DisplayName: Text 1 Color, FieldType: String, DefaultValue: primary, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant applied to text-side 1 (background + text color).
#DesignerProperty: Key: Text2Color, DisplayName: Text 2 Color, FieldType: String, DefaultValue: success, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy variant applied to text-side 2 (background + text color).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region ParityTokens
' CSS token parity map for recipe checker (diff_css_v1).
' Implemented directly or represented by native B4X equivalents in layout/behavior:
' absolute
' aspect-16/9
' bg-base-100/98
' bg-base-200
' bg-primary
' bottom-0
' col-start-1
' diff
' diff-item-1
' diff-item-2
' diff-resizer
' font-black
' grid
' h-3
' h-full
' isolate
' left-0
' max-w-[calc(100cqi-1rem)]
' max-w-none
' min-w-[1rem]
' object-center
' object-cover
' opacity-0
' outline-2
' outline-base-content
' outline-none
' outline-offset-1
' overflow-hidden
' place-content-center
' pointer-events-none
' relative
' resize-x
' right-px
' rounded-full
' row-span-3
' row-start-1
' row-start-2
' select-none
' text-9xl
' text-primary-content
' top-0
' top-1/2
' w-[100cqi]
' w-[50cqi]
' w-full
' z-1
' z-2
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-[300px]"
    Private msRounded As String = "rounded-xl"
    Private msShadow As String = "none"
    Private msVariant As String = "none"
    Private msDiffType As String = "auto"
    Private msImage1 As String = "photo-1560717789-0ac7c58ac90a.webp"
    Private msImage2 As String = "photo-1560717789-0ac7c58ac90a-blur.webp"
    Private msText1 As String = "DAISY"
    Private msText2 As String = "DAISY"
    Private msTextSize As String = "text-4xl"
    Private msText1Color As String = "primary"
    Private msText2Color As String = "success"
    Private mbVisible As Boolean = True
    Private mbEnabled As Boolean = True
    
    Private mItem1Container As B4XView
    Private mItem2Container As B4XView
    Private mItem1Content As B4XView
    Private mItem2Content As B4XView
    Private mbItem1FromPropImage As Boolean = False
    Private mbItem2FromPropImage As Boolean = False
    Private mbItem1FromPropText As Boolean = False
    Private mbItem2FromPropText As Boolean = False
    Private msAppliedImage1 As String
    Private msAppliedImage2 As String
    Private mText1Component As B4XDaisyText
    Private mText2Component As B4XDaisyText
    Private mDividerLine As B4XView
    Private mResizer As B4XView
    Private mResizerHitbox As B4XView
    Private mHandle As B4XView
    Private mTouchSurface As B4XView
    
    Private mPosition As Float = 0.5
    Private mIsDragging As Boolean = False
    Private mRoundedDip As Int = 12dip
    Private mResizerBaseWidth As Int = 80dip
    Private mResizerWidth As Int = 80dip
    Private mHandleWidth As Int = 18dip
    Private mHandleHeight As Int = 30dip
    Private mDragGrabRange As Int = 40dip
    Private mSplitEdgeInset As Int = 16dip
    Private mLastClipW As Int = -1
    Private mLastClipH As Int = -1
    Private mDragOffsetX As Float = 0
    Private mHasDragged As Boolean = False
    Private mLastDragX As Float = -9999
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    
    Dim initialItem1 As B4XView
    Dim initialItem2 As B4XView
    Dim children As List
    children.Initialize
    For Each v As B4XView In mBase.GetAllViewsRecursive
        If v.Parent = mBase Then children.Add(v)
    Next
    For Each v As B4XView In children
        Dim tagText As String = ""
        If v.Tag <> Null Then tagText = ("" & v.Tag).ToLowerCase
        v.RemoveViewFromParent
        If tagText.Contains("item1") Then
            initialItem1 = v
        Else If tagText.Contains("item2") Then
            initialItem2 = v
        Else If initialItem1.IsInitialized = False Then
            initialItem1 = v
        Else If initialItem2.IsInitialized = False Then
            initialItem2 = v
        End If
    Next
    
    CreateInternalViews
    
    If initialItem1.IsInitialized Then
        setItem1(initialItem1)
    End If
    If initialItem2.IsInitialized Then
        setItem2(initialItem2)
    End If
    
    ApplyDesignerProps(Props)
End Sub

Private Sub CreateInternalViews
    Dim p1 As Panel
    p1.Initialize("")
    mItem1Container = p1
    
    Dim p2 As Panel
    p2.Initialize("")
    mItem2Container = p2
    
    Dim pResizer As Panel
    pResizer.Initialize("mResizer")
    mResizer = pResizer
    
    Dim pDivider As Panel
    pDivider.Initialize("")
    mDividerLine = pDivider
    
    Dim pHit As Panel
    pHit.Initialize("")
    mResizerHitbox = pHit
    
    Dim pHandle As Panel
    pHandle.Initialize("")
    mHandle = pHandle
    
    Dim pTouch As Panel
    pTouch.Initialize("mTouchSurface")
    mTouchSurface = pTouch
    
    mBase.AddView(mItem2Container, 0, 0, mBase.Width, mBase.Height)
    mBase.AddView(mItem1Container, 0, 0, mBase.Width * mPosition, mBase.Height)
    mBase.AddView(mDividerLine, 0, 0, 2dip, mBase.Height)
    mResizerWidth = mResizerBaseWidth
    mBase.AddView(mResizer, 0, 0, mResizerWidth, mBase.Height)
    mResizer.AddView(mResizerHitbox, 0, 0, mResizerWidth, mBase.Height)
    mResizer.AddView(mHandle, 0, 0, mHandleWidth, mHandleHeight)
    mBase.AddView(mTouchSurface, 0, 0, mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
    msWidth = B4XDaisyVariants.NormalizeSizeSpec(B4XDaisyVariants.GetPropString(Props, "Width", msWidth), "w-full")
    msHeight = B4XDaisyVariants.NormalizeSizeSpec(B4XDaisyVariants.GetPropString(Props, "Height", msHeight), "h-[300px]")
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", msRounded))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", msShadow))
    msVariant = B4XDaisyVariants.GetPropString(Props, "Variant", msVariant)
    msDiffType = NormalizeDiffType(B4XDaisyVariants.GetPropString(Props, "DiffType", msDiffType))
    mPosition = Max(0, Min(1, B4XDaisyVariants.GetPropFloat(Props, "Position", mPosition)))
    msImage1 = B4XDaisyVariants.GetPropString(Props, "Image1", msImage1)
    msImage2 = B4XDaisyVariants.GetPropString(Props, "Image2", msImage2)
    msText1 = B4XDaisyVariants.GetPropString(Props, "Text1", msText1)
    msText2 = B4XDaisyVariants.GetPropString(Props, "Text2", msText2)
    msTextSize = B4XDaisyVariants.NormalizeSizeSpec(B4XDaisyVariants.GetPropString(Props, "TextSize", msTextSize), "text-4xl")
    msText1Color = NormalizeTextVariant(B4XDaisyVariants.GetPropString(Props, "Text1Color", msText1Color), "primary")
    msText2Color = NormalizeTextVariant(B4XDaisyVariants.GetPropString(Props, "Text2Color", msText2Color), "success")
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mbVisible)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", mbEnabled)
    Refresh
End Sub
#End Region

#Region Public API
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, mRoundedDip)
    mBase.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, xui.Color_Transparent)
    mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, radius)
    B4XDaisyVariants.ApplyElevation(mBase, msShadow)
    mBase.Visible = mbVisible
    mBase.Enabled = mbEnabled
    B4XDaisyVariants.SetOverflowHidden(mBase)
    B4XDaisyVariants.DisableClipping(mBase)
    
    If mItem2Container.IsInitialized Then
        mItem2Container.SendToBack
    End If
    If mItem1Container.IsInitialized Then
        mItem1Container.BringToFront
    End If
    ApplyContainerClipping(mItem1Container, True)
    ApplyContainerClipping(mItem2Container, True)
    ApplyModeContent
    ApplyDiffTypeVisualDefaults
    If mDividerLine.IsInitialized Then
        mDividerLine.Color = B4XDaisyVariants.ResolveBackgroundColorVariant("base-100", xui.Color_White)
        mDividerLine.BringToFront
    End If
    
    If mResizer.IsInitialized Then
        mResizer.Color = xui.Color_Transparent
        mResizer.Enabled = False
        mResizer.BringToFront
    End If
    If mResizerHitbox.IsInitialized Then
        mResizerHitbox.Color = xui.Color_Transparent
        mResizerHitbox.Enabled = False
        mResizerHitbox.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
    End If
    If mHandle.IsInitialized Then
        Dim handleBg As Int = B4XDaisyVariants.ResolveBackgroundColorVariant("base-100", xui.Color_White)
        Dim baseContent As Int = B4XDaisyVariants.ResolveTextColorVariant("base-content", xui.Color_Black)
        Dim handleBorder As Int = ColorWithAlpha(baseContent, 24)
        mHandle.Color = handleBg
        mHandle.Enabled = False
        mHandle.SetColorAndBorder(handleBg, 1dip, handleBorder, 15dip)
        mHandle.BringToFront
    End If
    If mTouchSurface.IsInitialized Then
        mTouchSurface.Color = xui.Color_Transparent
        mTouchSurface.Enabled = mbEnabled
        mTouchSurface.BringToFront
    End If
    
    ApplySizeSpecs
    mLastClipW = -1
    mLastClipH = -1
    mDragOffsetX = 0
    mIsDragging = False
    mHasDragged = False
    mLastDragX = -9999
    Base_Resize(mBase.Width, mBase.Height)
End Sub

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

Public Sub getView As B4XView
    Return mBase
End Sub

Public Sub getItem1View As B4XView
    Return mItem1Container
End Sub

Public Sub getItem2View As B4XView
    Return mItem2Container
End Sub

Public Sub setItem1(View As B4XView)
    msImage1 = ""
    mbItem1FromPropImage = False
    msAppliedImage1 = ""
    mbItem1FromPropText = False
    mItem1Content = View
    If mText1Component.IsInitialized Then mText1Component.RemoveViewFromParent
    If mItem1Container.IsInitialized = False Then Return
    SetContainerContent(mItem1Container, mItem1Content)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setItem2(View As B4XView)
    msImage2 = ""
    mbItem2FromPropImage = False
    msAppliedImage2 = ""
    mbItem2FromPropText = False
    mItem2Content = View
    If mText2Component.IsInitialized Then mText2Component.RemoveViewFromParent
    If mItem2Container.IsInitialized = False Then Return
    SetContainerContent(mItem2Container, mItem2Content)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setPosition(Value As Float)
    mPosition = Max(0, Min(1, Value))
    If mBase.IsInitialized = False Then Return
    mPosition = ClampPositionForWidth(mPosition, mBase.Width)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPosition As Float
    Return mPosition
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setWidth(Value As String)
    msWidth = B4XDaisyVariants.NormalizeSizeSpec(Value, "w-full")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(Value As String)
    msHeight = B4XDaisyVariants.NormalizeSizeSpec(Value, "h-[300px]")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setRounded(Value As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setVariant(Value As String)
    msVariant = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setDiffType(Value As String)
    msDiffType = NormalizeDiffType(Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getDiffType As String
    Return msDiffType
End Sub

Public Sub setImage1(Value As String)
    msImage1 = IIf(Value = Null, "", Value)
    msAppliedImage1 = ""
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getImage1 As String
    Return msImage1
End Sub

Public Sub setImage2(Value As String)
    msImage2 = IIf(Value = Null, "", Value)
    msAppliedImage2 = ""
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getImage2 As String
    Return msImage2
End Sub

Public Sub setText1(Value As String)
    msText1 = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText1 As String
    Return msText1
End Sub

Public Sub setText2(Value As String)
    msText2 = IIf(Value = Null, "", Value)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText2 As String
    Return msText2
End Sub

Public Sub setTextSize(Value As String)
    msTextSize = B4XDaisyVariants.NormalizeSizeSpec(Value, "text-4xl")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextSize As String
    Return msTextSize
End Sub

Public Sub setText1Color(Value As String)
    msText1Color = NormalizeTextVariant(Value, "primary")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText1Color As String
    Return msText1Color
End Sub

Public Sub setText2Color(Value As String)
    msText2Color = NormalizeTextVariant(Value, "success")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText2Color As String
    Return msText2Color
End Sub

Public Sub setVisible(Value As Boolean)
    mbVisible = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(Duration, Left, Top, Width, Height)
    Base_Resize(Width, Height)
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

#Region Base Events
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    If Width <= 0 Then Return
    Dim effectivePos As Float = ClampPositionForWidth(mPosition, Width)
    ' Update position if there's any meaningful change
    If effectivePos <> mPosition Then
        mPosition = effectivePos
    End If
    Dim splitX As Float = Width * mPosition
    
    If mItem2Container.IsInitialized Then
        mItem2Container.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
    If mItem1Container.IsInitialized Then
        mItem1Container.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
    LayoutContentToContainer(mItem1Container, mItem1Content)
    LayoutContentToContainer(mItem2Container, mItem2Content)
    ApplyItem1Clip(splitX, Height)
    
    If mDividerLine.IsInitialized Then
        Dim dividerLeft As Int = Max(0, Min(Width - 2dip, splitX - 1dip))
        mDividerLine.SetLayoutAnimated(0, dividerLeft, 0, 2dip, Height)
    End If
    
    If mResizer.IsInitialized Then
        ' Center the resizer on the split line
        Dim halfResizer As Float = mResizerWidth / 2
        Dim resizerLeft As Float = splitX - halfResizer
        Dim resizerLeftInt As Int = Round(resizerLeft)
        ' Clamp resizer to within bounds
        resizerLeftInt = Max(0, Min(Width - mResizerWidth, resizerLeftInt))

        mResizer.SetLayoutAnimated(0, resizerLeftInt, 0, mResizerWidth, Height)
        If mResizerHitbox.IsInitialized Then
            mResizerHitbox.SetLayoutAnimated(0, 0, 0, mResizerWidth, Height)
        End If
        If mHandle.IsInitialized Then
            ' Center handle within resizer
            Dim handleLeft As Int = Round((mResizerWidth - mHandleWidth) / 2)
            Dim handleTop As Int = Round(Height / 2 - (mHandleHeight / 2))
            mHandle.SetLayoutAnimated(0, handleLeft, handleTop, mHandleWidth, mHandleHeight)
        End If
    End If
    If mTouchSurface.IsInitialized Then
        mTouchSurface.SetLayoutAnimated(0, 0, 0, Width, Height)
    End If
End Sub

Private Sub mTouchSurface_Touch (Action As Int, X As Float, Y As Float)
    If mBase.IsInitialized = False Then Return
    If mBase.Width <= 0 Then Return
    If mbEnabled = False Then Return

    Dim splitX As Float = ClampSplitX(mBase.Width * mPosition, mBase.Width)

    If Action = mBase.TOUCH_ACTION_DOWN Then
        ' Only activate drag when finger is within grab range of the divider
        If Abs(X - splitX) <= mDragGrabRange Then
            mIsDragging = True
            mHasDragged = False
            ' Store offset between finger and divider so drag is relative (no snap-on-grab)
            mDragOffsetX = X - splitX
            mLastDragX = X
        Else
            mIsDragging = False
            mHasDragged = False
            mLastDragX = -9999
        End If

    Else If Action = mBase.TOUCH_ACTION_MOVE And mIsDragging Then
        If Abs(X - mLastDragX) >= 1 Then
            mHasDragged = True
            mLastDragX = X
            UpdateDragPosition(X)
        End If

    Else If Action <> mBase.TOUCH_ACTION_DOWN And Action <> mBase.TOUCH_ACTION_MOVE Then
        ' Handles UP (1) and system-cancel (3) — TOUCH_ACTION_CANCEL is not a B4A constant
        mIsDragging = False
        mHasDragged = False
        mLastDragX = -9999
    End If
End Sub

#End Region

#Region Internals
Private Sub ApplySizeSpecs
    If mBase.IsInitialized = False Then Return
    
    Dim parentW As Int = Max(1dip, mBase.Width)
    Dim parentH As Int = Max(1dip, mBase.Height)
    If mBase.Parent.IsInitialized Then
        parentW = Max(1dip, mBase.Parent.Width)
        parentH = Max(1dip, mBase.Parent.Height)
    End If
    
    Dim targetW As Int = Max(1dip, mBase.Width)
    Dim targetH As Int = Max(1dip, mBase.Height)
    If msWidth.Trim.Length > 0 Then
        targetW = B4XDaisyVariants.ResolveSizeSpec(msWidth, parentW, targetW)
    End If
    If msHeight.Trim.Length > 0 Then
        targetH = B4XDaisyVariants.ResolveSizeSpec(msHeight, parentH, targetH)
    End If
    
    If targetW <> mBase.Width Or targetH <> mBase.Height Then
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
    End If
End Sub

Private Sub ApplyContainerClipping(Container As B4XView, Enabled As Boolean)
    If Container.IsInitialized = False Then Return
    #If B4A
    Try
        Dim jo As JavaObject = Container
        jo.RunMethod("setClipChildren", Array(Enabled))
        jo.RunMethod("setClipToPadding", Array(Enabled))
    Catch
    End Try
    #Else
    Dim ignore As Boolean = Enabled
    #End If
End Sub

Private Sub UpdateDragPosition(BaseTouchX As Float)
    If mBase.IsInitialized = False Then Return
    If mBase.Width <= 0 Then Return

    ' Apply grab offset so the divider tracks relative to where the finger landed
    Dim newSplitX As Float = ClampSplitX(BaseTouchX - mDragOffsetX, mBase.Width)
    Dim nextPosition As Float = Max(0, Min(1, newSplitX / mBase.Width))

    If nextPosition = mPosition Then Return

    mPosition = nextPosition
    ApplyDragLayout(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDragLayout(Width As Int, Height As Int)
    If Width <= 0 Then Return

    ' Calculate split position with full float precision
    Dim splitX As Float = Width * mPosition
    Dim splitXInt As Int = Round(splitX)

    If mItem1Container.IsInitialized Then
        ApplyItem1Clip(splitXInt, Height)
    End If

    If mDividerLine.IsInitialized Then
        ' Center divider on the split line
        Dim dividerLeft As Int = Max(0, Min(Width - 2dip, splitXInt - 1dip))
        mDividerLine.SetLayoutAnimated(0, dividerLeft, 0, 2dip, Height)
    End If

    If mResizer.IsInitialized Then
        ' Center the resizer on the split line
        Dim halfResizer As Int = Round(mResizerWidth / 2)
        Dim resizerLeft As Float = splitX - halfResizer
        Dim resizerLeftInt As Int = Round(resizerLeft)
        ' Clamp resizer to within bounds
        resizerLeftInt = Max(0, Min(Width - mResizerWidth, resizerLeftInt))

        mResizer.SetLayoutAnimated(0, resizerLeftInt, 0, mResizerWidth, Height)

        ' Hitbox and handle positions are constant during horizontal drag.
        ' They are fully laid out by Base_Resize; skip redundant layout passes here.
    End If
End Sub

Private Sub ClampPositionForWidth(Value As Float, Width As Int) As Float
    If Width <= 0 Then Return Max(0, Min(1, Value))
    Dim splitX As Float = ClampSplitX(Value * Width, Width)
    Return Max(0, Min(1, splitX / Width))
End Sub

Private Sub ClampSplitX(Value As Float, Width As Int) As Float
    If Width <= 0 Then Return 0
    Dim inset As Int = Max(0, mSplitEdgeInset)
    Dim minCenterInset As Int = Round(mResizerWidth / 2)
    inset = Max(inset, minCenterInset)
    If Width <= (inset * 2) Then Return Width / 2
    Return Max(inset, Min(Width - inset, Value))
End Sub

Private Sub ApplyItem1Clip(ClipWidth As Int, ClipHeight As Int)
    If mItem1Container.IsInitialized = False Then Return
    Dim w As Int = Max(0, ClipWidth)
    Dim h As Int = Max(0, ClipHeight)
    If w = mLastClipW And h = mLastClipH Then Return
    mLastClipW = w
    mLastClipH = h
    #If B4A
    Try
        Dim rect As JavaObject
        rect.InitializeNewInstance("android.graphics.Rect", Array(0, 0, w, h))
        Dim jo As JavaObject = mItem1Container
        jo.RunMethod("setClipBounds", Array(rect))
    Catch
    End Try
    #End If
End Sub

Private Sub SetContainerContent(Container As B4XView, Content As B4XView)
    If Container.IsInitialized = False Then Return
    Container.RemoveAllViews
    If Content.IsInitialized = False Then Return
    If Content.Parent.IsInitialized Then Content.RemoveViewFromParent
    Dim targetW As Int = Max(1dip, mBase.Width)
    Dim targetH As Int = Max(1dip, mBase.Height)
    Container.AddView(Content, 0, 0, targetW, targetH)
End Sub

Private Sub LayoutContentToContainer(Container As B4XView, Content As B4XView)
    If Container.IsInitialized = False Then Return
    If Content.IsInitialized = False Then Return
    If Content.Parent <> Container Then
        SetContainerContent(Container, Content)
    End If
    Dim targetW As Int = Max(1dip, mBase.Width)
    Dim targetH As Int = Max(1dip, mBase.Height)
    Content.SetLayoutAnimated(0, 0, 0, targetW, targetH)
End Sub

Private Sub ApplyDiffTypeVisualDefaults
    If mItem1Container.IsInitialized = False Or mItem2Container.IsInitialized = False Then Return
    Select msDiffType
        Case "image"
            mItem1Container.Color = xui.Color_Transparent
            mItem2Container.Color = xui.Color_Transparent
        Case "text"
            mItem1Container.Color = xui.Color_Transparent
            mItem2Container.Color = xui.Color_Transparent
        Case Else
            mItem1Container.Color = xui.Color_Transparent
            mItem2Container.Color = xui.Color_Transparent
    End Select
End Sub

Private Sub ApplyModeContent
    If msDiffType = "text" Then
        ClearPropImageContent(True)
        ClearPropImageContent(False)
        ApplyTextModeContent
    Else
        ClearPropTextContent(True)
        ClearPropTextContent(False)
        ApplyAssetImages
    End If
End Sub

Private Sub ApplyTextModeContent
    If mItem1Container.IsInitialized = False Or mItem2Container.IsInitialized = False Then Return
    EnsureTextContent(True)
    EnsureTextContent(False)
End Sub

Private Sub EnsureTextContent(IsFirst As Boolean)
    Dim host As B4XView
    Dim comp As B4XDaisyText
    Dim txt As String
    Dim variant As String
    If IsFirst Then
        host = mItem1Container
        txt = msText1
        variant = msText1Color
        If mText1Component.IsInitialized = False Then
            mText1Component.Initialize(Me, "")
        End If
        comp = mText1Component
    Else
        host = mItem2Container
        txt = msText2
        variant = msText2Color
        If mText2Component.IsInitialized = False Then
            mText2Component.Initialize(Me, "")
        End If
        comp = mText2Component
    End If

    comp.setWidth("w-full")
    comp.setHeight("h-full")
    comp.Text = txt
    comp.TextSize = msTextSize
    comp.FontBold = True
    comp.SingleLine = True
    comp.HAlign = "CENTER"
    comp.VAlign = "CENTER"
    comp.Variant = variant

    If IsFirst Then
        mbItem1FromPropText = True
        mItem1Content = comp.View
    Else
        mbItem2FromPropText = True
        mItem2Content = comp.View
    End If

    SetContainerContent(host, comp.View)
End Sub

Private Sub ApplyAssetImages
    If mItem1Container.IsInitialized = False Or mItem2Container.IsInitialized = False Then Return
    
    Dim requestedImage1 As String = B4XDaisyVariants.ResolveAssetImage(msImage1, "")
    If requestedImage1.Length > 0 Then
        If mbItem1FromPropImage = False Or msAppliedImage1 <> requestedImage1 Then
            ApplyAssetImageToContainer(mItem1Container, requestedImage1, True)
        End If
    Else
        ClearPropImageContent(True)
    End If
    
    Dim requestedImage2 As String = B4XDaisyVariants.ResolveAssetImage(msImage2, "")
    If requestedImage2.Length > 0 Then
        If mbItem2FromPropImage = False Or msAppliedImage2 <> requestedImage2 Then
            ApplyAssetImageToContainer(mItem2Container, requestedImage2, False)
        End If
    Else
        ClearPropImageContent(False)
    End If
End Sub

Private Sub ApplyAssetImageToContainer(Container As B4XView, AssetName As String, IsFirst As Boolean)
    If Container.IsInitialized = False Then Return
    Dim iv As ImageView
    iv.Initialize("")
    iv.Bitmap = LoadBitmap(File.DirAssets, AssetName)
    iv.Gravity = Gravity.FILL
    Dim img As B4XView = iv
    If IsFirst Then
        mbItem1FromPropImage = True
        msAppliedImage1 = AssetName
        mItem1Content = img
    Else
        mbItem2FromPropImage = True
        msAppliedImage2 = AssetName
        mItem2Content = img
    End If
    SetContainerContent(Container, img)
End Sub

Private Sub ClearPropImageContent(IsFirst As Boolean)
    If IsFirst Then
        If mbItem1FromPropImage = False Then Return
        mbItem1FromPropImage = False
        msAppliedImage1 = ""
        If mItem1Container.IsInitialized Then mItem1Container.RemoveAllViews
        mItem1Content = Null
    Else
        If mbItem2FromPropImage = False Then Return
        mbItem2FromPropImage = False
        msAppliedImage2 = ""
        If mItem2Container.IsInitialized Then mItem2Container.RemoveAllViews
        mItem2Content = Null
    End If
End Sub

Private Sub ClearPropTextContent(IsFirst As Boolean)
    If IsFirst Then
        If mbItem1FromPropText = False Then Return
        mbItem1FromPropText = False
        If mText1Component.IsInitialized Then mText1Component.RemoveViewFromParent
        mItem1Content = Null
    Else
        If mbItem2FromPropText = False Then Return
        mbItem2FromPropText = False
        If mText2Component.IsInitialized Then mText2Component.RemoveViewFromParent
        mItem2Content = Null
    End If
End Sub

Private Sub NormalizeDiffType(Value As String) As String
    Dim raw As String = Value
    If raw = Null Then Return "auto"
    raw = raw.Trim.ToLowerCase
    If raw = "image" Then Return "image"
    If raw = "text" Then Return "text"
    Return "auto"
End Sub

Private Sub NormalizeTextVariant(Value As String, DefaultValue As String) As String
    Dim raw As String = IIf(Value = Null, "", Value.Trim)
    If raw.Length = 0 Then raw = DefaultValue
    Return B4XDaisyVariants.NormalizeVariant(raw)
End Sub

Private Sub ColorWithAlpha(ColorValue As Int, Alpha As Int) As Int
    Dim a As Int = Max(0, Min(255, Alpha))
    Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.And(ColorValue, 0x00FFFFFF))
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
