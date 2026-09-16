B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)

#DesignerProperty: Key: BackgroundImage, DisplayName: Background Image, FieldType: String, DefaultValue: , Description: Background image asset name.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|primary|secondary|accent|neutral|info|success|warning|error, Description: DaisyUI semantic color variant.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFF3F4F6, Description: Hero background color (base-200).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Hero text color.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-none, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level.
#DesignerProperty: Key: OverlayVisible, DisplayName: Overlay Visible, FieldType: Boolean, DefaultValue: False, Description: Show/Hide the hero overlay.
#DesignerProperty: Key: OverlayColor, DisplayName: Overlay Color, FieldType: Color, DefaultValue: 0x80000000, Description: Hero overlay color (with alpha).
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind width class (eg 80, full, 500px).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-[320px], Description: Tailwind height class (eg 80, screen, 500px).
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: vertical, List: vertical|horizontal|reverse, Description: Layout direction.
#DesignerProperty: Key: ContentAlignment, DisplayName: Content Alignment, FieldType: String, DefaultValue: center, List: center|left|right, Description: Content alignment.
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: String, DefaultValue: 4, Description: Tailwind gap token (eg 2, 4, 8).
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: 4, Description: Tailwind padding token (eg 4, 8, 12).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: False, Description: Automatically resize height to fit child content.

#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private mVisible As Boolean = True

    
    ' Internal containers
    Private mImageView As B4XView
    Private mOverlay As B4XView
    Private mContent As B4XView
    Private mFlexLayout As B4XDaisyFlexLayout ' Layout engine for content alignment and gap
    
    ' Design properties
    Private mBackgroundImage As String = ""
    Private mVariant As String = "none"
    Private mBackgroundColor As Int = 0xFFF3F4F6 ' overridden by theme in DesignerCreateView
    Private mBackgroundColorVariant As String = ""
    Private mTextColor As Int = 0xFF000000 ' overridden by theme in DesignerCreateView
    Private mTextColorVariant As String = ""
    Private mRounded As String = "rounded-none"
    Private mShadow As String = "none"
    Private mOverlayVisible As Boolean = False
    Private mOverlayColor As Int = 0x80000000
    Private mWidth As String = "w-full"
    Private mHeight As String = "h-[320px]"
    Private mDirection As String = "vertical" ' vertical, horizontal, reverse
    Private mContentAlignment As String = "center" ' center, left, right
    Private mGap As String = "4"
    Private mPadding As String = "4"
    Private mbAutoResize As Boolean = False
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    
    ' Create the image view container
    #If B4A
    Dim pImageView As ImageView
    pImageView.Initialize("")
    pImageView.Gravity = Gravity.FILL
    mImageView = pImageView
    #Else If B4i
    Dim pImageView As ImageView
    pImageView.Initialize("")
    mImageView = pImageView
    #Else If B4J
    Dim pImageView As ImageView
    pImageView.Initialize("")
    mImageView = pImageView
    #End If
    mBase.AddView(mImageView, 0, 0, mBase.Width, mBase.Height)
    
    ' Create the overlay
    mOverlay = xui.CreatePanel("")
    mOverlay.Color = mOverlayColor
    mBase.AddView(mOverlay, 0, 0, mBase.Width, mBase.Height)
    
    ' Create the content container
    mContent = xui.CreatePanel("")
    mContent.Color = xui.Color_Transparent
    mBase.AddView(mContent, 0, 0, mBase.Width, mBase.Height)
    
    ' Initialize flex layout for content
    mFlexLayout.Initialize(mContent)
    
    ApplyDesignerProps(mProps)
    
    GrabDesignerChildren
    
    mBase.Visible = mVisible
    Refresh
End Sub

Private Sub GrabDesignerChildren
    Dim viewsToMove As List
    viewsToMove.Initialize
    For i = 0 To mBase.NumberOfViews - 1
        Dim v As B4XView = mBase.GetView(i)
        ' Exclude internal panels
        If v = mImageView Or v = mOverlay Or v = mContent Then Continue
        viewsToMove.Add(v)
    Next
    
    For Each v As B4XView In viewsToMove
        v.RemoveViewFromParent
        mContent.AddView(v, v.Left, v.Top, v.Width, v.Height)
    Next
End Sub


Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    
    ' Parent containers (hero image and overlay) fill base
    If inResize Then Return
    inResize = True
    mImageView.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    mOverlay.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    
    Dim padDip As Int = B4XDaisyVariants.TailwindSpacingToDip(mPadding, 16dip)
    mContent.SetLayoutAnimated(0, padDip, padDip, dWidth - (2 * padDip), dHeight - (2 * padDip))
    
    ' Configure flex layout for content
    If mFlexLayout.IsInitialized Then
        ' Set direction based on mDirection property
        Select mDirection
            Case "horizontal"
                mFlexLayout.Direction = "row"
            Case "reverse"
                mFlexLayout.Direction = "row-reverse"
            Case Else ' vertical
                mFlexLayout.Direction = "column"
        End Select
        
        ' Set alignment based on mContentAlignment property
        Select mContentAlignment
            Case "left"
                mFlexLayout.JustifyContent = "start"
            Case "right"
                mFlexLayout.JustifyContent = "end"
            Case Else ' center
                mFlexLayout.JustifyContent = "center"
        End Select
        
        ' Always center items perpendicular to main axis
        mFlexLayout.AlignItems = "center"
        
        ' Set gap from mGap property (convert Tailwind token to dips)
        Dim gapDip As Int = B4XDaisyVariants.TailwindSpacingToDip(mGap, 16dip)
        mFlexLayout.SetGap(gapDip, gapDip)
        
        ' Padding is handled by mContent layout bounds, so set flex padding to 0
        mFlexLayout.SetPadding(0)
        
        ' Apply the layout
        mFlexLayout.Relayout
    End If
    DoAutoResize
    inResize = False
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    ' ALWAYS apply background color (useful if image has alpha, fails to load, or is empty)
    If mBackgroundColorVariant.Length > 0 Then
        mBase.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(mBackgroundColorVariant, mBackgroundColor)
    Else
        mBase.Color = mBackgroundColor
    End If
    
    ' Apply background image to dedicated layer
    mImageView.Visible = (mBackgroundImage.Length > 0)
    If mBackgroundImage.Length > 0 Then
        ' Resolve and set background image
        Dim bmp As String = B4XDaisyVariants.ResolveAssetImage(mBackgroundImage, "")
        If bmp.Length > 0 Then
            mImageView.SetBitmap(xui.LoadBitmap(File.DirAssets, bmp))
        End If
    End If
    
    ' Apply rounded and shadow
    ApplyRoundedAndShadow
    
    ' Overlay visibility
    mOverlay.Visible = mOverlayVisible
    mOverlay.Color = mOverlayColor
    
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyRoundedAndShadow
    If mBase.IsInitialized = False Then Return
    
    ' Calculate radius
    Dim radius As Float = B4XDaisyVariants.ResolveRoundedRadiusDip(mRounded, Min(mBase.Width, mBase.Height))
    If mRounded = "rounded-box" Or mRounded = "theme" Then radius = 14dip
    
    ' Apply shadow
    B4XDaisyVariants.ApplyElevation(mBase, mShadow)
    
    ' Apply color and border with radius.
    mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, radius)
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
    mBackgroundImage = B4XDaisyVariants.GetPropString(mProps, "BackgroundImage", mBackgroundImage)
    mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
    mBackgroundColor = B4XDaisyVariants.GetPropInt(mProps, "BackgroundColor", B4XDaisyVariants.GetTokenColor("--color-base-200", 0xFFF3F4F6))
    mBackgroundColorVariant = B4XDaisyVariants.GetPropString(mProps, "BackgroundColorVariant", mBackgroundColorVariant)
    mTextColor = B4XDaisyVariants.GetPropInt(mProps, "TextColor", B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black))
    mTextColorVariant = B4XDaisyVariants.GetPropString(mProps, "TextColorVariant", mTextColorVariant)
    mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)

    ' Backward compatibility: migrate legacy RoundedBox=True designer prop
    If mProps.ContainsKey("RoundedBox") Then
        Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
        If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
            mRounded = "rounded-box"
        End If
    End If
    mShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow)
    mOverlayVisible = B4XDaisyVariants.GetPropBool(mProps, "OverlayVisible", mOverlayVisible)
    mOverlayColor = B4XDaisyVariants.GetPropInt(mProps, "OverlayColor", mOverlayColor)
    mWidth = B4XDaisyVariants.GetPropString(mProps, "Width", mWidth)
    mHeight = B4XDaisyVariants.GetPropString(mProps, "Height", mHeight)
    mDirection = B4XDaisyVariants.GetPropString(mProps, "Direction", mDirection)
    mContentAlignment = B4XDaisyVariants.GetPropString(mProps, "ContentAlignment", mContentAlignment)
    mGap = B4XDaisyVariants.GetPropString(mProps, "Gap", mGap)
    mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
    mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("BackgroundImage", mBackgroundImage)
	props.Put("Variant", mVariant)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("Rounded", mRounded)
	props.Put("Shadow", mShadow)
	props.Put("OverlayVisible", mOverlayVisible)
	props.Put("OverlayColor", mOverlayColor)
	props.Put("Direction", mDirection)
	props.Put("ContentAlignment", mContentAlignment)
	props.Put("Gap", mGap)
	props.Put("Padding", mPadding)
	props.Put("Visible", mVisible)
	props.Put("AutoResize", mbAutoResize)
	Return props
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
		Dim w As Int = Max(1dip, iWidth)
		Dim h As Int = Max(1dip, iHeight)
        Dim p As Panel
        p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, w, h)
		
		Dim props As Map = BuildRuntimeProps(w, h)
		
        DesignerCreateView(b, Null, props)
    End If
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	' Ensure layout is triggered
	Refresh
    Return mBase
End Sub

' Getter/Setters
Public Sub setBackgroundImage(sValue As String)
    mBackgroundImage = sValue
    Refresh
End Sub

Public Sub getBackgroundImage As String
    Return mBackgroundImage
End Sub

Public Sub setVariant(sValue As String)
    mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
    Refresh
End Sub

Public Sub getVariant As String
    Return mVariant
End Sub

Public Sub setBackgroundColor(iValue As Int)
    mBackgroundColor = iValue
    Refresh
End Sub

Public Sub getBackgroundColor As Int
    Return mBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
    mTextColor = iValue
    Refresh
End Sub

Public Sub getTextColor As Int
    Return mTextColor
End Sub

Public Sub setBackgroundColorVariant(sValue As String)
    mBackgroundColorVariant = sValue
    Refresh
End Sub

Public Sub getBackgroundColorVariant As String
    Return mBackgroundColorVariant
End Sub

Public Sub setTextColorVariant(sValue As String)
    mTextColorVariant = sValue
    Refresh
End Sub

Public Sub getTextColorVariant As String
    Return mTextColorVariant
End Sub

Public Sub setRounded(sValue As String)
    mRounded = sValue
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

Public Sub setShadow(sValue As String)
    mShadow = sValue
    Refresh
End Sub

Public Sub getShadow As String
    Return mShadow
End Sub

Public Sub setOverlayVisible(bValue As Boolean)
    mOverlayVisible = bValue
    Refresh
End Sub

Public Sub getOverlayVisible As Boolean
    Return mOverlayVisible
End Sub

Public Sub setOverlayColor(iValue As Int)
    mOverlayColor = iValue
    Refresh
End Sub

Public Sub getOverlayColor As Int
    Return mOverlayColor
End Sub

Public Sub setWidth(sValue As String)
    mWidth = sValue
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As String
    Return mWidth
End Sub

Public Sub setHeight(sValue As String)
    mHeight = sValue
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As String
    Return mHeight
End Sub

Public Sub setDirection(sValue As String)
    mDirection = sValue
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getDirection As String
    Return mDirection
End Sub

Public Sub setContentAlignment(sValue As String)
    mContentAlignment = sValue
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getContentAlignment As String
    Return mContentAlignment
End Sub

Public Sub setGap(sValue As String)
    mGap = sValue
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getGap As String
    Return mGap
End Sub

Public Sub setPadding(sValue As String)
    mPadding = sValue
    If mBase.IsInitialized = False Then Return
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPadding As String
    Return mPadding
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setAutoResize(bValue As Boolean)
    mbAutoResize = bValue
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getAutoResize As Boolean
    Return mbAutoResize
End Sub

' Accessor for the content panel so users can add their own views
Public Sub GetContentPanel As B4XView
    Return mContent
End Sub

Private Sub mBase_Click
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", mTag)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub


Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Private Sub DoAutoResize
    If mbAutoResize = False Then Return
    If mBase.IsInitialized = False Then Return
    If mContent.IsInitialized = False Then Return
    Dim padDip As Int = B4XDaisyVariants.TailwindSpacingToDip(mPadding, 16dip)
    Dim maxBottom As Int = 0
    For i = 0 To mContent.NumberOfViews - 1
        Dim v As B4XView = mContent.GetView(i)
        If v.Visible Then
            maxBottom = Max(maxBottom, v.Top + v.Height)
        End If
    Next
    If maxBottom <= 0 Then Return
    Dim newH As Int = Max(1dip, maxBottom + (2 * padDip))
    If newH <> mBase.Height Then
        mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, newH)
        mImageView.SetLayoutAnimated(0, 0, 0, mBase.Width, newH)
        mOverlay.SetLayoutAnimated(0, 0, 0, mBase.Width, newH)
    End If
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub