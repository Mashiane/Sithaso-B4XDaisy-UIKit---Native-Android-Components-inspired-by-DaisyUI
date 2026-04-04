B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

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
    private s as string
    
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
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mItems.Initialize
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Load properties
    mbOpenOnlyOne = B4XDaisyVariants.GetPropBool(Props, "OpenOnlyOne", True)
    msIconPosition = B4XDaisyVariants.GetPropString(Props, "IconPosition", "right").ToLowerCase
    msIcon = B4XDaisyVariants.GetPropString(Props, "Icon", "arrow").ToLowerCase
    If Props.ContainsKey("Visible") Then
        mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    Else
        mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visibility", True)
    End If
    miSpaceY = DipToCurrent(B4XDaisyVariants.GetPropInt(Props, "SpaceY", 2))
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
    msGroupName = B4XDaisyVariants.GetPropString(Props, "GroupName", "")
    
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
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
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
    Parent.AddView(mBase, Left, Top, Width, Height)
    Return mBase
End Sub

Public Sub setOpenOnlyOne(Value As Boolean)
    mbOpenOnlyOne = Value
End Sub

Public Sub getOpenOnlyOne As Boolean
    Return mbOpenOnlyOne
End Sub

Public Sub setIconPosition(Value As String)
    msIconPosition = Value.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconPosition As String
	Return msIconPosition
End Sub

Public Sub setIcon(Value As String)
    msIcon = Value.ToLowerCase
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIcon As String
    Return msIcon
End Sub

Public Sub setSpaceY(Value As Int)
    miSpaceY = DipToCurrent(Value)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSpaceY As Int
    Return miSpaceY
End Sub

Public Sub setShadow(Value As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(Value)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
    Return msShadow
End Sub

Public Sub setRounded(Value As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(Value)
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
    Return msRounded
End Sub

''' <summary>
''' Sets the component tag.
''' </summary>
Public Sub setTag(Value As Object)
    mTag = Value
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
Public Sub setGroupName(Value As String)
    msGroupName = Value
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
Public Sub AddItemBasic(ItemTag As Object, Icon As String, Title As String) As B4XDaisyCollapse
    Dim c As B4XDaisyCollapse
    c.Initialize(mCallBack, mEventName)
    c.setTag(ItemTag)
    c.TitleText = Title
    If Icon.Length > 0 Then c.Icon = Icon
    AddItem(c)
    Return c
End Sub

''' <summary>
''' Finds a child collapse whose tag equals the given value. Returns an uninitialised collapse if not found.
''' </summary>
Private Sub FindItemByTag(ItemTag As Object) As B4XDaisyCollapse
    Dim empty As B4XDaisyCollapse
    For Each item As B4XDaisyCollapse In mItems
        If item.getTag = ItemTag Then Return item
    Next
    Return empty
End Sub

''' <summary>
''' Opens or closes the item identified by ItemTag.
''' </summary>
Public Sub SetItemActive(ItemTag As Object, Value As Boolean)
    Dim item As B4XDaisyCollapse = FindItemByTag(ItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setOpen(Value)
End Sub

''' <summary>
''' Sets the title text of the item identified by ItemTag.
''' </summary>
Public Sub SetItemTitle(ItemTag As Object, Title As String)
    Dim item As B4XDaisyCollapse = FindItemByTag(ItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setTitleText(Title)
End Sub

''' <summary>
''' Sets the variant of the item identified by ItemTag.
''' </summary>
Public Sub SetItemVariant(ItemTag As Object, Variant As String)
    Dim item As B4XDaisyCollapse = FindItemByTag(ItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setVariant(Variant)
End Sub

''' <summary>
''' Sets the title icon (SVG asset name) of the item identified by ItemTag.
''' </summary>
Public Sub SetItemTitleIcon(ItemTag As Object, IconName As String)
    Dim item As B4XDaisyCollapse = FindItemByTag(ItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setTitleIconName(IconName)
End Sub

''' <summary>
''' Shows or hides the item identified by ItemTag.
''' </summary>
Public Sub SetItemVisible(ItemTag As Object, Value As Boolean)
    Dim item As B4XDaisyCollapse = FindItemByTag(ItemTag)
    If item.mBase.IsInitialized = False Then Return
    item.setVisible(Value)
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
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    ' Accordion is a vertical stack of its children.
    ' Ensure they fit the width and auto-size the accordion height.
    Dim currentY As Int = 0
    For i = 0 To mBase.NumberOfViews - 1
        Dim v As B4XView = mBase.GetView(i)
        If v.Tag Is B4XDaisyCollapse Then
            v.SetLayoutAnimated(0, 0, currentY, Width, v.Height)
            ' Programmatic custom views don't auto-fire Base_Resize on SetLayoutAnimated,
            ' so explicitly tell the Collapse to re-render at the new width (draws icons etc.)
            Dim col As B4XDaisyCollapse = v.Tag
            col.Base_Resize(Width, v.Height)
            currentY = currentY + v.Height + miSpaceY
        End If
    Next
    ' Auto-shrink accordion to fit contents and shift page siblings by the delta
    If currentY > 0 Then
        Dim prevH As Int = mBase.Height
        mBase.Height = currentY
        B4XDaisyVariants.ShiftSiblingsBelow(mBase, currentY - prevH, 200)
    End If
End Sub
#End Region

#Region Cleanup
Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

