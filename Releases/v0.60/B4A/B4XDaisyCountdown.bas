B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#End Region

#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Layout orientation for the segments.
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: String, DefaultValue: gap-2, List: gap-0|gap-1|gap-2|gap-3|gap-4|gap-5|gap-6|gap-8, Description: Spacing between segments.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: transparent, List: transparent|base-100|base-200|base-300|neutral|primary|secondary|accent, Description: Background color for the container.
#DesignerProperty: Key: Border, DisplayName: Border, FieldType: Boolean, DefaultValue: False, Description: Show a border around the container (standard base-300 border).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: none|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius token applied to the container and child items.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|shadow|shadow-sm|shadow-md|shadow-lg|shadow-xl|shadow-2xl|shadow-inner, Description: Shadow effect applied to child items.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-0, List: p-0|p-1|p-2|p-3|p-4|p-5|p-6|p-8, Description: Inner padding for the container.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Local properties
    Private msOrientation As String = "horizontal"
    Private msGap As String = "gap-2"
    Private msBackgroundColor As String = "transparent"
    Private mbBorder As Boolean = False
    ' container rounding is now a string token instead of a boolean
    Private msRounded As String = "none"    ' corner radius mode
    Private msPadding As String = "p-0"
    Private msShadow As String = "none"     ' shadow token applied to child items

    ' debug helper: if true we draw a red outline around the whole countdown
    ' (disabled by default in production builds)
    Private DEBUG_BORDER As Boolean = False
    
    Private mItems As List
    Private mIsResizing As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mItems.Initialize
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    
    ' Load properties
    If mItems.IsInitialized = False Then mItems.Initialize
    msOrientation = B4XDaisyVariants.GetPropString(Props, "Orientation", "horizontal")
    msGap = B4XDaisyVariants.GetPropString(Props, "Gap", "gap-2")
    msBackgroundColor = B4XDaisyVariants.GetPropString(Props, "BackgroundColor", "transparent")
    mbBorder = B4XDaisyVariants.GetPropBool(Props, "Border", False)
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "none"))
    msPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "p-0")
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    
    Refresh
End Sub
#End Region

#Region Public API
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    For Each itm As B4XDaisyCountdownItem In mItems
        itm.UpdateTheme
    Next
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    ' Apply styling
    Dim bgColor As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundColor, xui.Color_Transparent)
    Dim borderColor As Int = xui.Color_Transparent
    Dim borderWidth As Int = 0
    If mbBorder Then
        borderColor = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_LightGray)
        borderWidth = B4XDaisyVariants.GetBorderDip(1dip)
    End If
    
    
    ' resolve the container rounding token
    Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
    
    mBase.SetColorAndBorder(bgColor, borderWidth, borderColor, radius)
    B4XDaisyVariants.SetOverflowHidden(mBase)
    
    ' Ensure all items are initialized and added to mBase
    For Each itm As B4XDaisyCountdownItem In mItems
        ' ensure the item itself is ready
        If itm.getIsInitialized = False Then
            itm.CreateView(40dip, 40dip)
        End If
        
        ' propagate rounded/shadow to items (AFTER potential CreateView call)
        itm.setRounded(msRounded)
        itm.setShadow(msShadow)
        
        ' operate on its view only when it's truly initialized
        Dim v As B4XView = itm.getView
        If v.IsInitialized Then
            ' Detach if already has a different parent
            Try
                v.RemoveViewFromParent
            Catch
                ' Ignore if it has no parent yet or other issues
            End Try
            ' Add to our container using its measured size
            mBase.AddView(v, 0, 0, v.Width, v.Height)
        End If
    Next
    
    ' Layout items
    LayoutItems
End Sub

Public Sub AddItem(Item As B4XDaisyCountdownItem)
    If Item = Null Then Return
    If mItems.IndexOf(Item) = -1 Then mItems.Add(Item)
    ' propagate new item style
    Item.setRounded(msRounded)
    Item.setShadow(msShadow)
    ' Detach from previous parent if any to avoid "child already has a parent" crash
    If Item.getIsInitialized And Item.mBase.IsInitialized Then
        Try
            Item.mBase.RemoveViewFromParent
        Catch
            ' Ignore if it has no parent yet
        End Try
    End If
    Refresh
End Sub

Public Sub getView As B4XView
    Return mBase
End Sub

Public Sub getIsInitialized As Boolean
    Return mBase.IsInitialized
End Sub

Public Sub RemoveItem(Item As B4XDaisyCountdownItem)
    Dim idx As Int = mItems.IndexOf(Item)
    If idx > -1 Then
        mItems.RemoveAt(idx)
        Item.View.RemoveViewFromParent
        Refresh
    End If
End Sub

Public Sub ClearItems
    For Each itm As B4XDaisyCountdownItem In mItems
        itm.View.RemoveViewFromParent
    Next
    mItems.Clear
    Refresh
End Sub
Public Sub CreateView(Width As Int, Height As Int) As B4XView
    mBase = xui.CreatePanel("mBase")
    mBase.Color = xui.Color_Transparent
    mBase.SetLayoutAnimated(0, 0, 0, Width, Height)
    Dim props As Map = CreateMap("Orientation": msOrientation, "Gap": msGap, "BackgroundColor": msBackgroundColor, "Border": mbBorder, "Rounded": msRounded, "Shadow": msShadow)
    DesignerCreateView(mBase, Null, props)
    Return mBase
End Sub

'** helper for programmatic insertion **
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        ' create the base panel on demand
        mBase = xui.CreatePanel("mBase")
        mBase.Color = xui.Color_Transparent
        Parent.AddView(mBase, Left, Top, Width, Height)
        
        ' set default size so Refresh/Layout work
        Dim props As Map = CreateMap("Orientation": msOrientation, "Gap": msGap, "BackgroundColor": msBackgroundColor, "Border": mbBorder, "Rounded": msRounded, "Shadow": msShadow)
        DesignerCreateView(mBase, Null, props)
    Else
        mBase.RemoveViewFromParent
        Parent.AddView(mBase, Left, Top, Width, Height)
    End If
    Return mBase
End Sub

#Region Getters/Setters
Public Sub getOrientation As String
    Return msOrientation
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized Then
        For Each itm As B4XDaisyCountdownItem In mItems
            itm.setShadow(msShadow)
        Next
        Refresh
    End If
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setRounded(Value As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(Value)
    If mBase.IsInitialized Then
        For Each itm As B4XDaisyCountdownItem In mItems
            itm.setRounded(msRounded)
        Next
        Refresh
    End If
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

Public Sub setOrientation(Value As String)
    msOrientation = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getGap As String
    Return msGap
End Sub

Public Sub setGap(Value As String)
    msGap = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setBackgroundColor(Value As String)
    msBackgroundColor = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBorder As Boolean
    Return mbBorder
End Sub

Public Sub setBorder(Value As Boolean)
    mbBorder = Value
    If mBase.IsInitialized Then Refresh
End Sub

' already updated above

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setPadding(Value As String)
    msPadding = Value
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub
#End Region
#End Region

#Region Base Events
Public Sub Base_Resize(Width As Double, Height As Double)
    If mIsResizing Then Return
    mIsResizing = True
    LayoutItems
    mIsResizing = False
End Sub
#End Region

#Region Internal Layout
Private Sub LayoutItems
    If mBase.IsInitialized = False Or mItems.Size = 0 Then Return
    
    Dim padding As Int = B4XDaisyVariants.TailwindSpacingToDip(msPadding, 0)
    Dim gap As Int = B4XDaisyVariants.TailwindSpacingToDip(msGap, 8dip)
    
    Dim currentPos As Int = padding
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyCountdownItem = mItems.Get(i)
        itm.Refresh
        
        If msOrientation = "horizontal" Then
            itm.mBase.Left = currentPos
            itm.mBase.Top = padding
            itm.mBase.Height = mBase.Height - padding * 2
            
            Dim itemW As Int = itm.mBase.Width
            If itemW < 10dip Then itemW = 40dip 
            
            currentPos = currentPos + itemW + gap
        Else
            itm.mBase.Left = padding
            itm.mBase.Top = currentPos
            itm.mBase.Width = mBase.Width - padding * 2
            
            Dim itemH As Int = itm.mBase.Height
            if itemH < 10dip Then itemH = 40dip
            
            currentPos = currentPos + itemH + gap
        End If
    Next
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
