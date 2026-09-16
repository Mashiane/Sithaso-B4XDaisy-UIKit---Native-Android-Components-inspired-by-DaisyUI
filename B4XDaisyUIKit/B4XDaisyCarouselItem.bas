B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: ItemType, DisplayName: Item Type, FieldType: String, DefaultValue: image, List: image|svg|custom, Description: Type of content to display.
#DesignerProperty: Key: Source, DisplayName: Source, FieldType: String, DefaultValue: , Description: Image file or SVG content/asset.
#DesignerProperty: Key: Snap, DisplayName: Snap Position, FieldType: String, DefaultValue: start, List: start|center|end, Description: Carousel snapping position.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-none, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius variant.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Item width as a Tailwind class: w-full, w-1/2, w-64, w-[150px] etc.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-full, Description: Item height as a Tailwind class: h-full, h-48, h-[200px] etc.
#DesignerProperty: Key: ImageWidth, DisplayName: Image Width, FieldType: String, DefaultValue: w-full, Description: Width of the image/content inside the item frame. w-full = 100% of item width.
#DesignerProperty: Key: ImageHeight, DisplayName: Image Height, FieldType: String, DefaultValue: h-full, Description: Height of the image/content inside the item frame. h-full = 100% of item height.
#DesignerProperty: Key: ImageResizeMode, DisplayName: Image Resize Mode, FieldType: String, List: FIT|FILL|FILL_NO_DISTORTIONS|FILL_WIDTH|FILL_HEIGHT|NONE, DefaultValue: FILL_NO_DISTORTIONS, Description: How to scale the image within the carousel item frame.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region Variables
#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private mVisible As Boolean = True

    
    ' Internal views
    Public mImage As B4XView
    Private mImageComp As B4XDaisyImage
    Private mIcon As B4XDaisySvgIcon
    Private mContainer As B4XView
    
    ' Local properties
    Private msItemType As String = "image"
    Private msSource As String = ""
    Private msSnap As String = "start"
    Private msRounded As String = "rounded-none"
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-full"
    Private msImageWidth As String = "w-full"
    Private msImageHeight As String = "h-full"
    Private msImageResizeMode As String = "FILL_NO_DISTORTIONS"
    
    Private mIsResizing As Boolean = False
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
    mBase.Color = xui.Color_Transparent
    
    ApplyDesignerProps(mProps)
    UpdateContent
    mBase.Visible = mVisible
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    msItemType = B4XDaisyVariants.GetPropString(mProps, "ItemType", msItemType)
    msSource = B4XDaisyVariants.GetPropString(mProps, "Source", msSource)
    msSnap = B4XDaisyVariants.GetPropString(mProps, "Snap", msSnap)
    msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded)
    msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", msWidth)
    msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", msHeight)
    msImageWidth = B4XDaisyVariants.GetPropString(mProps, "ImageWidth", msImageWidth)
    msImageHeight = B4XDaisyVariants.GetPropString(mProps, "ImageHeight", msImageHeight)
    msImageResizeMode = B4XDaisyVariants.GetPropString(mProps, "ImageResizeMode", msImageResizeMode)
    mBase.Enabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mBase.Enabled)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", msWidth)
	props.Put("Height", msHeight)
	props.Put("ItemType", msItemType)
	props.Put("Source", msSource)
	props.Put("Snap", msSnap)
	props.Put("Rounded", msRounded)
	props.Put("ImageWidth", msImageWidth)
	props.Put("ImageHeight", msImageHeight)
	props.Put("ImageResizeMode", msImageResizeMode)
	props.Put("Enabled", getEnabled)
	props.Put("Visible", mVisible)
	Return props
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("mBase")
    ' Pre-size so mBase.Width/Height are correct during DesignerCreateView.
    p.Width = iWidth
    p.Height = iHeight
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    DesignerCreateView(b, Null, BuildRuntimeProps(iWidth, iHeight))
    Return mBase
End Sub
#End Region

#Region Public API
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    ' Apply rounded
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    mBase.SetColorAndBorder(mBase.Color, 0, 0, radius)
    
    ' Clip to outline (simulates overflow-hidden)
    B4XDaisyVariants.SetOverflowHidden(mBase)
    
    ' Snap behavior is handled by the parent Carousel component
    
    ' Guard: only propagate resize when mBase has been measured by Android's layout system.
    ' When Refresh is called from DesignerCreateView, mBase.Width is still 0 (the Panel
    ' hasn't had a layout pass). Calling Base_Resize(0, 0) would zero out mImage.
    ' CreateView and LayoutItems call Base_Resize explicitly with the correct dimensions.
    If mBase.Width > 0 And mBase.Height > 0 Then
        Base_Resize(mBase.Width, mBase.Height)
    End If
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        CreateView(iWidth, iHeight)
    End If
    vParent.AddView(mBase, iLeft, iTop, mBase.Width, mBase.Height)
    Return mBase
End Sub

Private Sub UpdateContent
    If mBase.IsInitialized = False Then Return
    
    ' Clear previous content
    mBase.RemoveAllViews
    
    Select msItemType
        Case "image"
            mImageComp.Initialize(Me, "")
            mImageComp.mBackgroundColor = 0
            mImageComp.setResizeMode(msImageResizeMode)
            mImageComp.AddToParent(mBase, 0, 0, Max(1, mBase.Width), Max(1, mBase.Height))
            mImage = mImageComp.mBase
            If msSource <> "" Then
                Try
                    mImageComp.Load(File.DirAssets, msSource)
                Catch
                    If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCarouselItem.UpdateContent: " & LastException.Message)
                End Try
            End If
            UpdateImageLayout(mBase.Width, mBase.Height)
            
        Case "svg"
            mIcon.Initialize(Me, "")
            mIcon.AddToParent(mBase, 0, 0, mBase.Width, mBase.Height)
            mIcon.SetClickable(False)
            If msSource.ToLowerCase.EndsWith(".svg") Then
                mIcon.setSvgAsset(msSource)
            Else
                mIcon.setSvgContent(msSource)
            End If
            
        Case "custom"
            Dim p As Panel
            p.Initialize("")
            mContainer = p
            mBase.AddView(mContainer, 0, 0, mBase.Width, mBase.Height)
    End Select
End Sub

Public Sub getItemType As String
    Return msItemType
End Sub

Public Sub setItemType(sValue As String)
    msItemType = sValue
    UpdateContent
    Refresh
End Sub

Public Sub getSource As String
    Return msSource
End Sub

Public Sub setSource(sValue As String)
    msSource = sValue
    UpdateContent
    Refresh
End Sub

Public Sub getSnap As String
    Return msSnap
End Sub

Public Sub setSnap(sValue As String)
    msSnap = sValue
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setRounded(sValue As String)
    msRounded = sValue
    Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getContainer As B4XView
    If msItemType <> "custom" Then Return Null
    Return mContainer
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setWidth(sValue As String)
    msWidth = sValue
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setHeight(sValue As String)
    msHeight = sValue
End Sub

Public Sub getImageWidth As String
    Return msImageWidth
End Sub

Public Sub setImageWidth(sValue As String)
    msImageWidth = sValue
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getImageHeight As String
    Return msImageHeight
End Sub

Public Sub setImageHeight(sValue As String)
    msImageHeight = sValue
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getVisible As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Visible
End Sub

Public Sub setVisible(bValue As Boolean)
	    mVisible = bValue
	    If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getEnabled As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Enabled
End Sub

Public Sub setEnabled(bValue As Boolean)
    If mBase.IsInitialized Then mBase.Enabled = bValue
End Sub

Public Sub getImageResizeMode As String
    Return msImageResizeMode
End Sub

Public Sub setImageResizeMode(sValue As String)
    msImageResizeMode = sValue
    If mImageComp.IsInitialized Then mImageComp.setResizeMode(sValue)
    If mBase.IsInitialized Then UpdateImageLayout(mBase.Width, mBase.Height)
End Sub

Private Sub UpdateImageLayout(fWidth As Float, fHeight As Float)
    If mImage.IsInitialized = False Then Return
    
    If msSource = "" Or msItemType <> "image" Then
        mImage.SetLayoutAnimated(0, 0, 0, fWidth, fHeight)
        If mImageComp.IsInitialized Then mImageComp.Base_Resize(fWidth, fHeight)
        Return
    End If
    
    Dim maxW As Float = B4XDaisyVariants.TailwindSizeToDip(msImageWidth, fWidth)
    If maxW < 1 Then maxW = fWidth
    Dim maxH As Float = B4XDaisyVariants.TailwindSizeToDip(msImageHeight, fHeight)
    If maxH < 1 Then maxH = fHeight
    
    Dim Left As Int = Round(fWidth / 2 - maxW / 2)
    Dim Top As Int = Round(fHeight / 2 - maxH / 2)
    
    mImage.SetLayoutAnimated(0, Left, Top, Round(maxW), Round(maxH))
    If mImageComp.IsInitialized Then mImageComp.Base_Resize(Round(maxW), Round(maxH))
End Sub

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mIsResizing Then Return
    mIsResizing = True
    
    Dim imgW As Int = B4XDaisyVariants.TailwindSizeToDip(msImageWidth, dWidth)
    If imgW < 1 Then imgW = dWidth
    Dim imgH As Int = B4XDaisyVariants.TailwindSizeToDip(msImageHeight, dHeight)
    If imgH < 1 Then imgH = dHeight
    
    If mImage.IsInitialized Then UpdateImageLayout(dWidth, dHeight)
    If mIcon.IsInitialized Then mIcon.Base_Resize(imgW, imgH)
    If mContainer.IsInitialized Then mContainer.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
    
    mIsResizing = False
End Sub

Private Sub mBase_Click
    RaiseClick
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
