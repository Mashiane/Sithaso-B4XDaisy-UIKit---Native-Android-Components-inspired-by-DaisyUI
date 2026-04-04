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
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region Variables
#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Internal views
    Public mImage As B4XView
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
    
    Private mIsResizing As Boolean = False
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
    mBase.Color = xui.Color_Transparent
    
    ' Load properties
    msItemType = B4XDaisyVariants.GetPropString(Props, "ItemType", "image")
    msSource = B4XDaisyVariants.GetPropString(Props, "Source", "")
    msSnap = B4XDaisyVariants.GetPropString(Props, "Snap", "start")
    msRounded = B4XDaisyVariants.GetPropString(Props, "Rounded", "rounded-none")
    msWidth = B4XDaisyVariants.GetPropString(Props, "Width", "w-full")
    msHeight = B4XDaisyVariants.GetPropString(Props, "Height", "h-full")
    msImageWidth = B4XDaisyVariants.GetPropString(Props, "ImageWidth", "w-full")
    msImageHeight = B4XDaisyVariants.GetPropString(Props, "ImageHeight", "h-full")
    
    UpdateContent
    Refresh
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    ' Pre-size so mBase.Width/Height are correct during DesignerCreateView.
    p.Width = Width
    p.Height = Height
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    ' Carry over any properties set before AddToParent so they are not overwritten
    ' by the empty-props defaults in DesignerCreateView.
    Dim props As Map
    props.Initialize
    props.Put("ItemType", msItemType)
    props.Put("Source", msSource)
    props.Put("Snap", msSnap)
    props.Put("Rounded", msRounded)
    props.Put("Width", msWidth)
    props.Put("Height", msHeight)
    props.Put("ImageWidth", msImageWidth)
    props.Put("ImageHeight", msImageHeight)
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Base_Resize(Width, Height)
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
    
    Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    
    ' Resolve actual size from Tailwind tokens; passed W/H are the "full" reference.
    Dim refW As Int = Width
    If refW <= 0 Then refW = Parent.Width
    Dim refH As Int = Height
    If refH <= 0 Then refH = Parent.Height
    Dim actualW As Int = B4XDaisyVariants.TailwindSizeToDip(msWidth, refW)
    Dim actualH As Int = B4XDaisyVariants.TailwindSizeToDip(msHeight, refH)
    If actualW < 1 Then actualW = Max(1, refW)
    If actualH < 1 Then actualH = Max(1, refH)
    
    If mBase.IsInitialized = False Then
        CreateView(actualW, actualH)
    End If
    Parent.AddView(mBase, Left, Top, actualW, actualH)
    Return mBase
End Sub

Private Sub UpdateContent
    If mBase.IsInitialized = False Then Return
    
    ' Clear previous content
    mBase.RemoveAllViews
    
    Select msItemType
        Case "image"
            Dim iv As ImageView
            iv.Initialize("")
            ' bg-cover bg-center: fill the frame and center (object-fit: cover equivalent)
            Dim joIV As JavaObject = iv
            Dim centerCrop As JavaObject
            centerCrop.InitializeStatic("android.widget.ImageView$ScaleType")
            joIV.RunMethod("setScaleType", Array(centerCrop.GetField("CENTER_CROP")))
            mImage = iv
            mBase.AddView(mImage, 0, 0, mBase.Width, mBase.Height)
            If msSource <> "" Then
                Try
                    mImage.SetBitmap(xui.LoadBitmap(File.DirAssets, msSource))
                Catch
                End Try
            End If
            
        Case "svg"
            mIcon.Initialize(Me, "")
            mIcon.AddToParent(mBase, 0, 0, mBase.Width, mBase.Height)
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

Public Sub setItemType(Value As String)
    msItemType = Value
    UpdateContent
    Refresh
End Sub

Public Sub getSource As String
    Return msSource
End Sub

Public Sub setSource(Value As String)
    msSource = Value
    UpdateContent
    Refresh
End Sub

Public Sub getSnap As String
    Return msSnap
End Sub

Public Sub setSnap(Value As String)
    msSnap = Value
    Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setRounded(Value As String)
    msRounded = Value
    Refresh
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getContainer As B4XView
    If msItemType <> "custom" Then Return Null
    Return mContainer
End Sub

Public Sub getWidth As String
    Return msWidth
End Sub

Public Sub setWidth(Value As String)
    msWidth = Value
End Sub

Public Sub getHeight As String
    Return msHeight
End Sub

Public Sub setHeight(Value As String)
    msHeight = Value
End Sub

Public Sub getImageWidth As String
    Return msImageWidth
End Sub

Public Sub setImageWidth(Value As String)
    msImageWidth = Value
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getImageHeight As String
    Return msImageHeight
End Sub

Public Sub setImageHeight(Value As String)
    msImageHeight = Value
    If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getVisible As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Visible
End Sub

Public Sub setVisible(Value As Boolean)
    If mBase.IsInitialized Then mBase.Visible = Value
End Sub

Public Sub getEnabled As Boolean
    If mBase.IsInitialized = False Then Return True
    Return mBase.Enabled
End Sub

Public Sub setEnabled(Value As Boolean)
    If mBase.IsInitialized Then mBase.Enabled = Value
End Sub

#Region Base Events
Public Sub Base_Resize(Width As Double, Height As Double)
    If mIsResizing Then Return
    mIsResizing = True
    
    Dim imgW As Int = B4XDaisyVariants.TailwindSizeToDip(msImageWidth, Width)
    If imgW < 1 Then imgW = Width
    Dim imgH As Int = B4XDaisyVariants.TailwindSizeToDip(msImageHeight, Height)
    If imgH < 1 Then imgH = Height
    ' Center the image within the item frame
    Dim imgLeft As Int = (Width - imgW) / 2
    Dim imgTop As Int = (Height - imgH) / 2
    
    If mImage.IsInitialized Then mImage.SetLayoutAnimated(0, imgLeft, imgTop, imgW, imgH)
    If mIcon.IsInitialized Then mIcon.Base_Resize(imgW, imgH)
    If mContainer.IsInitialized Then mContainer.SetLayoutAnimated(0, 0, 0, Width, Height)
    
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
