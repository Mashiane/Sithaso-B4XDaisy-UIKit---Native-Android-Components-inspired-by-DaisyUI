B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

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
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
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
    
    ApplyDesignerProps(mProps)
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

Private Sub ApplyDesignerProps(mProps As Map)
    msWidth = B4XDaisyVariants.NormalizeSizeSpec(B4XDaisyVariants.GetPropString(mProps, "Width", msWidth), "w-full")
    msHeight = B4XDaisyVariants.NormalizeSizeSpec(B4XDaisyVariants.GetPropString(mProps, "Height", msHeight), "h-[300px]")
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
    msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
    msDiffType = NormalizeDiffType(B4XDaisyVariants.GetPropString(mProps, "DiffType", msDiffType))
    mPosition = Max(0, Min(1, B4XDaisyVariants.GetPropFloat(mProps, "Position", mPosition)))
    msImage1 = B4XDaisyVariants.GetPropString(mProps, "Image1", msImage1)
    msImage2 = B4XDaisyVariants.GetPropString(mProps, "Image2", msImage2)
    msText1 = B4XDaisyVariants.GetPropString(mProps, "Text1", msText1)
    msText2 = B4XDaisyVariants.GetPropString(mProps, "Text2", msText2)
    msTextSize = B4XDaisyVariants.NormalizeSizeSpec(B4XDaisyVariants.GetPropString(mProps, "TextSize", msTextSize), "text-4xl")
    msText1Color = NormalizeTextVariant(B4XDaisyVariants.GetPropString(mProps, "Text1Color", msText1Color), "primary")
    msText2Color = NormalizeTextVariant(B4XDaisyVariants.GetPropString(mProps, "Text2Color", msText2Color), "success")
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    Refresh
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Rounded", msRounded)
	props.Put("Shadow", msShadow)
	props.Put("Variant", msVariant)
	props.Put("DiffType", msDiffType)
	props.Put("Position", mPosition)
	props.Put("Image1", msImage1)
	props.Put("Image2", msImage2)
	props.Put("Text1", msText1)
	props.Put("Text2", msText2)
	props.Put("TextSize", msTextSize)
	props.Put("Text1Color", msText1Color)
	props.Put("Text2Color", msText2Color)
	props.Put("Visible", mbVisible)
	props.Put("Enabled", mbEnabled)
	Return props
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
    ' Disabled: dim the comparison so it reads as inactive (drag is already blocked).
    mBase.Alpha = IIf(mbEnabled, 1.0, 0.3)
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
    mIsDragging = False
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("mBase")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    DesignerCreateView(b, Null, BuildRuntimeProps(iWidth, iHeight))
    Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        DesignerCreateView(p, Null, BuildRuntimeProps(iWidth, iHeight))
    End If
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub getItem1View As B4XView
    Return mItem1Container
End Sub

Public Sub getItem2View As B4XView
    Return mItem2Container
End Sub

Public Sub setItem1(vAView As B4XView)
    msImage1 = ""
    mbItem1FromPropImage = False
    msAppliedImage1 = ""
    mbItem1FromPropText = False
    mItem1Content = vAView
    If mText1Component.IsInitialized Then mText1Component.RemoveViewFromParent
    If mItem1Container.IsInitialized = False Then Return
    SetContainerContent(mItem1Container, mItem1Content)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setItem2(vAView As B4XView)
    msImage2 = ""
    mbItem2FromPropImage = False
    msAppliedImage2 = ""
    mbItem2FromPropText = False
    mItem2Content = vAView
    If mText2Component.IsInitialized Then mText2Component.RemoveViewFromParent
    If mItem2Container.IsInitialized = False Then Return
    SetContainerContent(mItem2Container, mItem2Content)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setPosition(fValue As Float)
    mPosition = Max(0, Min(1, fValue))
    If mBase.IsInitialized = False Then Return
    mPosition = ClampPositionForWidth(mPosition, mBase.Width)
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPosition As Float
    Return mPosition
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setWidth(sValue As String)
    msWidth = B4XDaisyVariants.NormalizeSizeSpec(sValue, "w-full")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setHeight(sValue As String)
    msHeight = B4XDaisyVariants.NormalizeSizeSpec(sValue, "h-[300px]")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setRounded(sValue As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setVariant(sValue As String)
    msVariant = sValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub setDiffType(sValue As String)
    msDiffType = NormalizeDiffType(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getDiffType As String
    Return msDiffType
End Sub

Public Sub setImage1(sValue As String)
    msImage1 = IIf(sValue = Null, "", sValue)
    msAppliedImage1 = ""
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getImage1 As String
    Return msImage1
End Sub

Public Sub setImage2(sValue As String)
    msImage2 = IIf(sValue = Null, "", sValue)
    msAppliedImage2 = ""
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getImage2 As String
    Return msImage2
End Sub

Public Sub setText1(sValue As String)
    msText1 = IIf(sValue = Null, "", sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText1 As String
    Return msText1
End Sub

Public Sub setText2(sValue As String)
    msText2 = IIf(sValue = Null, "", sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText2 As String
    Return msText2
End Sub

Public Sub setTextSize(sValue As String)
    msTextSize = B4XDaisyVariants.NormalizeSizeSpec(sValue, "text-4xl")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getTextSize As String
    Return msTextSize
End Sub

Public Sub setText1Color(sValue As String)
    msText1Color = NormalizeTextVariant(sValue, "primary")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText1Color As String
    Return msText1Color
End Sub

Public Sub setText2Color(sValue As String)
    msText2Color = NormalizeTextVariant(sValue, "success")
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getText2Color As String
    Return msText2Color
End Sub

Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getVisible As Boolean
    Return mbVisible
End Sub

Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
    If mBase.IsInitialized = False Then Return
    mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
    Base_Resize(iWidth, iHeight)
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

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If dWidth <= 0 Then Return
    If inResize Then Return
    inResize = True
    Dim effectivePos As Float = ClampPositionForWidth(mPosition, dWidth)
    If Abs(effectivePos - mPosition) > 0.0005 Then
        mPosition = effectivePos
    End If
    Dim splitX As Int = dWidth * mPosition
    
    If mItem2Container.IsInitialized Then
        mItem2Container.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    End If
    If mItem1Container.IsInitialized Then
        mItem1Container.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    End If
    LayoutContentToContainer(mItem1Container, mItem1Content)
    LayoutContentToContainer(mItem2Container, mItem2Content)
    ApplyItem1Clip(splitX, dHeight)
    
    If mDividerLine.IsInitialized Then
        Dim dividerLeft As Int = Max(0, Min(dWidth - 2dip, splitX - 1dip))
        mDividerLine.SetLayoutAnimated(0, dividerLeft, 0, 2dip, dHeight)
    End If
    
    If mResizer.IsInitialized Then
        Dim halfResizer As Int = mResizerWidth / 2
        Dim leftPos As Int = Max(-halfResizer, Min(dWidth - halfResizer, splitX - halfResizer))
        mResizer.SetLayoutAnimated(0, leftPos, 0, mResizerWidth, dHeight)
        If mResizerHitbox.IsInitialized Then
            mResizerHitbox.SetLayoutAnimated(0, 0, 0, mResizerWidth, dHeight)
        End If
        If mHandle.IsInitialized Then
            Dim handleLeft As Int = (mResizerWidth - mHandleWidth) / 2
            mHandle.SetLayoutAnimated(0, handleLeft, dHeight / 2 - (mHandleHeight / 2), mHandleWidth, mHandleHeight)
        End If
    End If
    If mTouchSurface.IsInitialized Then
        mTouchSurface.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    End If
    inResize = False
End Sub

Private Sub mTouchSurface_Touch (iAction As Int, fX As Float, fY As Float)
    #If B4A
    B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
    #End If
    If mBase.IsInitialized = False Then Return
    If mBase.Width <= 0 Then Return
    If mbEnabled = False Then Return
    
    Dim splitX As Float = ClampSplitX(mBase.Width * mPosition, mBase.Width)
    If iAction = mBase.TOUCH_ACTION_DOWN Then
        If Abs(fX - splitX) <= mDragGrabRange Then
            mIsDragging = True
            UpdateDragPosition(fX)
        Else
            mIsDragging = False
        End If
    Else If iAction = mBase.TOUCH_ACTION_MOVE And mIsDragging Then
        UpdateDragPosition(fX)
    Else If iAction = mBase.TOUCH_ACTION_UP Then
        mIsDragging = False
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

Private Sub ApplyContainerClipping(vContainer As B4XView, bEnabled As Boolean)
    If vContainer.IsInitialized = False Then Return
    #If B4A
    Try
        Dim jo As JavaObject = vContainer
        jo.RunMethod("setClipChildren", Array(bEnabled))
        jo.RunMethod("setClipToPadding", Array(bEnabled))
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyDiff.ApplyContainerClipping: " & LastException.Message)
    End Try
    #Else
    Dim ignore As Boolean = bEnabled
    #End If
End Sub

Private Sub UpdateDragPosition(fBaseTouchX As Float)
    If mBase.IsInitialized = False Then Return
    If mBase.Width <= 0 Then Return
    Dim clampedX As Float = ClampSplitX(fBaseTouchX, mBase.Width)
    Dim nextPosition As Float = Max(0, Min(1, clampedX / mBase.Width))
    If Abs(nextPosition - mPosition) < 0.0005 Then Return
    mPosition = nextPosition
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ClampPositionForWidth(fValue As Float, iWidth As Int) As Float
    If iWidth <= 0 Then Return Max(0, Min(1, fValue))
    Dim splitX As Float = ClampSplitX(fValue * iWidth, iWidth)
    Return Max(0, Min(1, splitX / iWidth))
End Sub

Private Sub ClampSplitX(fValue As Float, iWidth As Int) As Float
    If iWidth <= 0 Then Return 0
    Dim inset As Int = Max(0, mSplitEdgeInset)
    Dim minCenterInset As Int = Round(mResizerWidth / 2)
    inset = Max(inset, minCenterInset)
    If iWidth <= (inset * 2) Then Return iWidth / 2
    Return Max(inset, Min(iWidth - inset, fValue))
End Sub

Private Sub ApplyItem1Clip(iClipWidth As Int, iClipHeight As Int)
    If mItem1Container.IsInitialized = False Then Return
    #If B4A
    Try
        Dim w As Int = Max(0, iClipWidth)
        Dim h As Int = Max(0, iClipHeight)
        Dim rect As JavaObject
        rect.InitializeNewInstance("android.graphics.Rect", Array(0, 0, w, h))
        Dim jo As JavaObject = mItem1Container
        jo.RunMethod("setClipBounds", Array(rect))
    Catch
        mItem1Container.SetLayoutAnimated(0, 0, 0, Max(0, iClipWidth), Max(0, iClipHeight))
    End Try
    #Else
    mItem1Container.SetLayoutAnimated(0, 0, 0, Max(0, iClipWidth), Max(0, iClipHeight))
    #End If
End Sub

Private Sub SetContainerContent(vContainer As B4XView, vContent As B4XView)
    If vContainer.IsInitialized = False Then Return
    vContainer.RemoveAllViews
    If vContent.IsInitialized = False Then Return
    If vContent.Parent.IsInitialized Then vContent.RemoveViewFromParent
    Dim targetW As Int = Max(1dip, mBase.Width)
    Dim targetH As Int = Max(1dip, mBase.Height)
    vContainer.AddView(vContent, 0, 0, targetW, targetH)
End Sub

Private Sub LayoutContentToContainer(vContainer As B4XView, vContent As B4XView)
    If vContainer.IsInitialized = False Then Return
    If vContent.IsInitialized = False Then Return
    If vContent.Parent <> vContainer Then
        SetContainerContent(vContainer, vContent)
    End If
    Dim targetW As Int = Max(1dip, mBase.Width)
    Dim targetH As Int = Max(1dip, mBase.Height)
    vContent.SetLayoutAnimated(0, 0, 0, targetW, targetH)
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

Private Sub EnsureTextContent(bIsFirst As Boolean)
    Dim host As B4XView
    Dim comp As B4XDaisyText
    Dim txt As String
    Dim variant As String
    If bIsFirst Then
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

    If comp.IsReady = False Or comp.View.Parent <> host Then
        comp.AddToParent(host, 0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
    End If
    comp.setAutoResize(False)
    comp.setWidth("w-full")
    comp.setHeight("h-full")
    comp.Text = txt
    comp.TextSize = msTextSize
    comp.FontBold = True
    comp.SingleLine = True
    comp.HAlign = "CENTER"
    comp.VAlign = "CENTER"
    ' Apply Text1Color/Text2Color as a Daisy variant: background = variant hue,
    ' text color = the matching {variant}-content (readable on that background).
    comp.Variant = "none"
    comp.BackgroundColor = B4XDaisyVariants.ResolveBackgroundColorVariant(variant, xui.Color_Transparent)
    comp.setTextColorVariant(variant)

    If bIsFirst Then
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

Private Sub ApplyAssetImageToContainer(vContainer As B4XView, sAssetName As String, bIsFirst As Boolean)
    If vContainer.IsInitialized = False Then Return
    Dim iv As ImageView
    iv.Initialize("")
    iv.Bitmap = LoadBitmap(File.DirAssets, sAssetName)
    iv.Gravity = Gravity.FILL
    Dim img As B4XView = iv
    If bIsFirst Then
        mbItem1FromPropImage = True
        msAppliedImage1 = sAssetName
        mItem1Content = img
    Else
        mbItem2FromPropImage = True
        msAppliedImage2 = sAssetName
        mItem2Content = img
    End If
    SetContainerContent(vContainer, img)
End Sub

Private Sub ClearPropImageContent(bIsFirst As Boolean)
    If bIsFirst Then
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

Private Sub ClearPropTextContent(bIsFirst As Boolean)
    If bIsFirst Then
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

Private Sub NormalizeDiffType(sValue As String) As String
    Dim raw As String = sValue
    If raw = Null Then Return "auto"
    raw = raw.Trim.ToLowerCase
    If raw = "image" Then Return "image"
    If raw = "text" Then Return "text"
    Return "auto"
End Sub

Private Sub NormalizeTextVariant(sValue As String, sDefaultValue As String) As String
    Dim raw As String = IIf(sValue = Null, "", sValue.Trim)
    If raw.Length = 0 Then raw = sDefaultValue
    Return B4XDaisyVariants.NormalizeVariant(raw)
End Sub

Private Sub ColorWithAlpha(iColorValue As Int, iAlpha As Int) As Int
    Dim a As Int = Max(0, Min(255, iAlpha))
    Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.And(iColorValue, 0x00FFFFFF))
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
