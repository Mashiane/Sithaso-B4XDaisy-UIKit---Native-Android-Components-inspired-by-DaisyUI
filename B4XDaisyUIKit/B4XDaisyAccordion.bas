B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: Change (ActiveTag As Object, Status As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: OpenOnlyOne, DisplayName: Open Only One, FieldType: Boolean, DefaultValue: True, Description: If True, only one collapse can be open at a time.
#DesignerProperty: Key: IconPosition, DisplayName: Icon Position, FieldType: String, DefaultValue: right, List: left|right, Description: Default icon position for all children.
#DesignerProperty: Key: Icon, DisplayName: Icon, FieldType: String, DefaultValue: arrow, List: none|arrow|plus, Description: Expansion indicator icon for all children.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: SpaceY, DisplayName: Space Y, FieldType: Int, DefaultValue: 2, MinRange: 0, MaxRange: 32, Description: Vertical gap (in dip) between collapse items.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level applied to all children.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Radius mode applied to all children.
#DesignerProperty: Key: GroupName, DisplayName: Group Name, FieldType: String, DefaultValue: , Description: Explicit group name shared by all child collapses (used for single-open enforcement). Leave empty to auto-generate from component tag.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private s As String
    
    ' Local properties
    Private mbOpenOnlyOne As Boolean = True
    Private msIconPosition As String = "right"
    Private msIcon As String = "arrow"
    Private mbVisible As Boolean = True
    Private miSpaceY As Int = 2dip
    Private msShadow As String = "none"
    Private msRounded As String = "theme"
    
    ' Internal management
    Private mItems As List
    Private mIsRefreshing As Boolean = False
    Private msGroupName As String = ""
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
    mItems.Initialize
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Load properties
    mbOpenOnlyOne = B4XDaisyVariants.GetPropBool(mProps, "OpenOnlyOne", mbOpenOnlyOne)
    msIconPosition = B4XDaisyVariants.GetPropString(mProps, "IconPosition", msIconPosition).ToLowerCase
    msIcon = B4XDaisyVariants.GetPropString(mProps, "Icon", msIcon).ToLowerCase
    If mProps.ContainsKey("Visible") Then
        mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    Else
        mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visibility", mbVisible)
    End If
    miSpaceY = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "SpaceY", 2))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
    msGroupName = B4XDaisyVariants.GetPropString(mProps, "GroupName", msGroupName)
    
    Refresh
End Sub
#End Region


#Region Public API
''' <summary>
''' Forces the component to re-evaluate its styling against the currently active global Theme.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    For Each item As B4XDaisyCollapse In mItems
        item.UpdateTheme
    Next
    Refresh
End Sub

''' <summary>
''' Renders/Refreshes the component state.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    ' Guard against re-entry: child setters trigger Collapse.Refresh which
    ' calls acc.Refresh via UpdateOpenState parent detection
    If mIsRefreshing Then Return
    mIsRefreshing = True
    mBase.Visible = mbVisible
    
    ' Apply shared properties to existing children
    For Each item As B4XDaisyCollapse In mItems
        item.setIconPosition(msIconPosition)
        item.setIcon(msIcon)
        item.setShadow(msShadow)
        item.setRounded(msRounded)
    Next
    
    Base_Resize(mBase.Width, mBase.Height)
    mIsRefreshing = False
End Sub

''' <summary>
''' Adds a collapse item to the accordion.
''' </summary>
Public Sub AddItem(Item As B4XDaisyCollapse)
    If mItems.IndexOf(Item) = -1 Then
        mItems.Add(Item)
        Dim gn As String = msGroupName
        If gn.Length = 0 Then gn = "group_" & mBase.Tag
        Item.setGroupName(gn)
        Item.setIconPosition(msIconPosition)
        Item.setIcon(msIcon)
        Item.setShadow(msShadow)
        Item.setRounded(msRounded)
        ' ensure the collapse view is a child of our base panel
        ' Note: the item's internal mBase may not yet be initialized (it happens only when the
        ' component is first added to a parent).  The previous implementation accessed
        ' Item.mBase.Parent.IsInitialized directly which throws when mBase itself is not
        ' initialized.  Guard against that and create the view if needed.
        If Item.mBase.IsInitialized = False Then
            ' first add the item to our base using its public helper which will initialize the
            ' view and respect any width/height specs set on the item.
            Item.AddToParent(mBase, 0, 0, 1dip, 1dip)
        Else
            Dim parent As B4XView = Item.mBase.Parent
            If parent.IsInitialized = False Or parent <> mBase Then
                ' preserve item's width/height if already set
                Dim w As Int = Item.mBase.Width
                Dim h As Int = Item.mBase.Height
                mBase.AddView(Item.mBase, 0, 0, Max(1dip, w), Max(1dip, h))
            End If
        End If
        ' reposition all items
        Refresh
    End If
End Sub

''' <summary>
''' Handles child request to open. If OpenOnlyOne is true, others are closed.
''' </summary>
Public Sub HandleChildRequestOpen(RequestedChild As B4XDaisyCollapse)
    ' ignore requests from children that are closing
    If RequestedChild.getOpen = False Then Return
    If mbOpenOnlyOne Then
        For Each item As B4XDaisyCollapse In mItems
            If item <> RequestedChild Then
                item.setOpen(False)
            End If
        Next
    End If
    ' layout may need updating (opened child height changed)
    Refresh
    If xui.SubExists(mCallBack, mEventName & "_Change", 2) Then
        CallSub3(mCallBack, mEventName & "_Change", RequestedChild.getTag, RequestedChild.getOpen)
    End If
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        DesignerCreateView(p, Null, CreateMap( _
            "OpenOnlyOne": mbOpenOnlyOne, _
            "IconPosition": msIconPosition, _
            "Icon": msIcon, _
            "Visible": mbVisible, _
            "SpaceY": miSpaceY / 1dip, _
            "Shadow": msShadow, _
            "Rounded": msRounded, _
            "GroupName": msGroupName _
        ))
    End If
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    Return mBase
End Sub

Public Sub setOpenOnlyOne(bValue As Boolean)
    mbOpenOnlyOne = bValue
End Sub

Public Sub getOpenOnlyOne As Boolean
    Return mbOpenOnlyOne
End Sub

Public Sub setIconPosition(sValue As String)
    msIconPosition = sValue.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconPosition As String
	Return msIconPosition
End Sub

Public Sub setIcon(sValue As String)
    msIcon = sValue.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIcon As String
    Return msIcon
End Sub

Public Sub setSpaceY(iValue As Int)
    miSpaceY = DipToCurrent(iValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSpaceY As Int
    Return miSpaceY
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setRounded(sValue As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

''' <summary>
''' Sets the component tag.
''' </summary>
Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

''' <summary>
''' Gets the component tag.
''' </summary>
Public Sub getTag As Object
    Return mTag
End Sub

''' <summary>
''' Sets the explicit group name shared by all child collapses.
''' Leave empty to auto-generate from the component tag.
''' </summary>
Public Sub setGroupName(sValue As String)
    msGroupName = sValue
    ' Re-apply group name to all existing items
    If mBase.IsInitialized = False Then Return
    Dim gn As String = msGroupName
    If gn.Length = 0 Then gn = "group_" & mBase.Tag
    For Each item As B4XDaisyCollapse In mItems
        item.setGroupName(gn)
    Next
End Sub

Public Sub getGroupName As String
    Return msGroupName
End Sub

''' <summary>
''' Creates a fully initialised B4XDaisyCollapse, adds it to the accordion and returns it.
''' The returned item can be used to add content via getContentView / RefreshContent.
''' </summary>
Public Sub AddItemBasic(oItemTag As Object, sIcon As String, sTitle As String) As B4XDaisyCollapse
    Dim c As B4XDaisyCollapse
    c.Initialize(mCallBack, mEventName)
    c.setTag(oItemTag)
    c.TitleText = sTitle
    If sIcon.Length > 0 Then c.Icon = sIcon
    AddItem(c)
    Return c
End Sub

''' <summary>
''' Finds a child collapse whose tag equals the given value. Returns an uninitialised collapse if not found.
''' </summary>
Private Sub FindItemByTag(oItemTag As Object) As B4XDaisyCollapse
    Dim empty As B4XDaisyCollapse
    For Each item As B4XDaisyCollapse In mItems
        If item.getTag = oItemTag Then Return item
    Next
    Return empty
End Sub

''' <summary>
''' Opens or closes the item identified by ItemTag.
''' </summary>
Public Sub SetItemActive(oItemTag As Object, bValue As Boolean)
    Dim item As B4XDaisyCollapse = FindItemByTag(oItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setOpen(bValue)
End Sub

''' <summary>
''' Sets the title text of the item identified by ItemTag.
''' </summary>
Public Sub SetItemTitle(oItemTag As Object, sTitle As String)
    Dim item As B4XDaisyCollapse = FindItemByTag(oItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setTitleText(sTitle)
End Sub

''' <summary>
''' Sets the variant of the item identified by ItemTag.
''' </summary>
Public Sub SetItemVariant(oItemTag As Object, sVariant As String)
    Dim item As B4XDaisyCollapse = FindItemByTag(oItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setVariant(sVariant)
End Sub

''' <summary>
''' Sets the title icon (SVG asset name) of the item identified by ItemTag.
''' </summary>
Public Sub SetItemTitleIcon(oItemTag As Object, sIconName As String)
    Dim item As B4XDaisyCollapse = FindItemByTag(oItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setTitleIconName(sIconName)
End Sub

''' <summary>
''' Shows or hides the item identified by ItemTag.
''' </summary>
Public Sub SetItemVisible(oItemTag As Object, bValue As Boolean)
    Dim item As B4XDaisyCollapse = FindItemByTag(oItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setVisible(bValue)
End Sub

''' <summary>
''' Returns the current rendered height of the accordion (sum of all items + spacing).
''' </summary>
Public Sub GetComputedHeight As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Height
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    ' Accordion is a vertical stack of its children.
    ' Ensure they fit the width and auto-size the accordion height.
    If inResize Then Return
    inResize = True
    Dim currentY As Int = 0
    For i = 0 To mBase.NumberOfViews - 1
        Dim v As B4XView = mBase.GetView(i)
        If v.Tag Is B4XDaisyCollapse Then
            v.SetLayoutAnimated(0, 0, currentY, dWidth, v.Height)
            ' Programmatic custom views don't auto-fire Base_Resize on SetLayoutAnimated,
            ' so explicitly tell the Collapse to re-render at the new width (draws icons etc.)
            Dim col As B4XDaisyCollapse = v.Tag
            col.Base_Resize(dWidth, v.Height)
            currentY = currentY + v.Height + miSpaceY
        End If
    Next
    ' Auto-shrink accordion to fit contents and shift page siblings by the delta
    If currentY > 0 Then
        Dim prevH As Int = mBase.Height
        mBase.Height = currentY
        B4XDaisyVariants.ShiftSiblingsBelow(mBase, currentY - prevH, 200)
    End If
    inResize = False
End Sub
#End Region

#Region Cleanup
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

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
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
