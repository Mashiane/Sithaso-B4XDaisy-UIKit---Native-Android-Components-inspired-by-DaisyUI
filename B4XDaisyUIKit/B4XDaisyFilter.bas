B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9
#Region Events
#Event: ResetClick
#Event: Changed (Keys As List)
#Event: ItemChanged (Id As String, Text As String, Checked As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables or disables the component.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the component.
#DesignerProperty: Key: Options, DisplayName: Options, FieldType: String, DefaultValue: svelte:Svelte, vue:Vue, react:React, Description: Comma-separated or pipe-separated key:value pairs.
#DesignerProperty: Key: ActiveKey, DisplayName: Active Key, FieldType: String, DefaultValue: , Description: Key of the active option.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius option.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Daisy color variant.
#DesignerProperty: Key: FilterStyle, DisplayName: Filter Style, FieldType: String, DefaultValue: solid, List: solid|soft|outline|dash|ghost, Description: Styling of choices.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Sizing variant.
#DesignerProperty: Key: ResetPosition, DisplayName: Reset Position, FieldType: String, DefaultValue: left, List: left|right, Description: Position of the reset button.
#DesignerProperty: Key: ResetText, DisplayName: Reset Text, FieldType: String, DefaultValue: x, Description: Text for the reset button.
#DesignerProperty: Key: CloseType, DisplayName: Close Type, FieldType: String, DefaultValue: icon, List: icon|text, Description: Display mode for the close/reset button.
#DesignerProperty: Key: CloseIcon, DisplayName: Close Icon, FieldType: String, DefaultValue: close.svg, Description: SVG icon for the close/reset button when CloseType is icon.
#DesignerProperty: Key: MultiSelect, DisplayName: MultiSelect (Checkboxes), FieldType: Boolean, DefaultValue: False, Description: Allow multiple selection like checkboxes.
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Layout orientation.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, Description: Layout transition duration in milliseconds (0 to disable).
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Sizing width token.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto, Description: Sizing height token.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: , Description: Spacing padding token.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue: , Description: Spacing margin token.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    ' Designer Properties backing fields
    Private mEnabled As Boolean = True
    Private mVisible As Boolean = True
    Private msOptions As String = "svelte:Svelte, vue:Vue, react:React"
    Private msActiveKey As String = ""
    Private msRounded As String = "theme"
    Private msVariant As String = "none"
    Private msFilterStyle As String = "solid"
    Private msSize As String = "md"
    Private msResetPosition As String = "left"
    Private msResetText As String = "x"
    Private msCloseType As String = "icon"
    Private msCloseIcon As String = "close.svg"
    Private mbMultiSelect As Boolean = False
    Private msOrientation As String = "horizontal"
    Private miDuration As Int = 300
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-auto"
    Private msPadding As String = ""
    Private msMargin As String = ""

    ' Views & Child Components
    Private pnlContainer As B4XView
    Private mOptionButtons As List
    Private mResetButton As B4XDaisyButton
    
    ' Key-Value Mappings
    Private mKeys As List
    Private mValues As List
    Private mSelectedKeys As Map

    ' Animation / Layout lifecycle flags
    Private mFirstLayout As Boolean = True
    Private mAnimateNextLayout As Boolean = False
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
    mOptionButtons.Initialize
    mKeys.Initialize
    mValues.Initialize
    mSelectedKeys.Initialize
    mFirstLayout = True
    mAnimateNextLayout = False
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    ' Container Panel
    Dim p As Panel
    p.Initialize("")
    pnlContainer = p
    pnlContainer.Color = xui.Color_Transparent
    mBase.AddView(pnlContainer, 0, 0, mBase.Width, mBase.Height)

    ApplyDesignerProps(mProps)
    RebuildOptions
    Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mEnabled)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
    msOptions = B4XDaisyVariants.GetPropString(mProps, "Options", msOptions)
    msActiveKey = B4XDaisyVariants.GetPropString(mProps, "ActiveKey", msActiveKey)
    msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded)
    msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
    msFilterStyle = B4XDaisyVariants.NormalizeStyle(B4XDaisyVariants.GetPropString(mProps, "FilterStyle", msFilterStyle))
    msSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", msSize))
    msResetPosition = B4XDaisyVariants.GetPropString(mProps, "ResetPosition", msResetPosition)
    msResetText = B4XDaisyVariants.GetPropString(mProps, "ResetText", msResetText)
    If msResetText = "" Or msResetText = Null Then msResetText = "x"
    msCloseType = B4XDaisyVariants.GetPropString(mProps, "CloseType", msCloseType)
    msCloseIcon = B4XDaisyVariants.GetPropString(mProps, "CloseIcon", msCloseIcon)
    mbMultiSelect = B4XDaisyVariants.GetPropBool(mProps, "MultiSelect", mbMultiSelect)
    msOrientation = B4XDaisyVariants.GetPropString(mProps, "Orientation", msOrientation)
    miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
    msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", msWidth)
    msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", msHeight)
    msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
    msMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", msMargin)
End Sub

Private Sub BuildRuntimeProps As Map
    Dim props As Map
    props.Initialize
    props.Put("Enabled", mEnabled)
    props.Put("Visible", mVisible)
    props.Put("Options", msOptions)
    props.Put("ActiveKey", msActiveKey)
    props.Put("Rounded", msRounded)
    props.Put("Variant", msVariant)
    props.Put("FilterStyle", msFilterStyle)
    props.Put("Size", msSize)
    props.Put("ResetPosition", msResetPosition)
    props.Put("ResetText", msResetText)
    props.Put("CloseType", msCloseType)
    props.Put("CloseIcon", msCloseIcon)
    props.Put("MultiSelect", mbMultiSelect)
    props.Put("Orientation", msOrientation)
    props.Put("Duration", miDuration)
    props.Put("Width", msWidth)
    props.Put("Height", msHeight)
    props.Put("Padding", msPadding)
    props.Put("Margin", msMargin)
    Return props
End Sub

''' <summary>
''' Programmatic view creator.
''' </summary>
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
    Dim props As Map = BuildRuntimeProps
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Return mBase
End Sub
#End Region

#Region Public API
''' <summary>
''' Sets the Enabled.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
    mEnabled = bValue
    If mResetButton.IsInitialized Then mResetButton.Enabled = bValue
    For Each btn As B4XDaisyButton In mOptionButtons
        btn.Enabled = bValue
    Next
End Sub

''' <summary>
''' Gets the Enabled.
''' </summary>
Public Sub getEnabled As Boolean
    Return mEnabled
End Sub

''' <summary>
''' Sets the Visible.
''' </summary>
Public Sub setVisible(bValue As Boolean)
    mVisible = bValue
    mBase.Visible = bValue
End Sub

''' <summary>
''' Gets the Visible.
''' </summary>
Public Sub getVisible As Boolean
    Return mVisible
End Sub

''' <summary>
''' Sets options string.
''' </summary>
Public Sub setOptions(sValue As String)
    msOptions = sValue
    If pnlContainer.IsInitialized Then RebuildOptions
    Refresh
End Sub

''' <summary>
''' Gets options string.
''' </summary>
Public Sub getOptions As String
    Return msOptions
End Sub

''' <summary>
''' Sets the active choice key.
''' </summary>
Public Sub setActiveKey(sValue As String)
    msActiveKey = sValue
    Refresh
End Sub

''' <summary>
''' Gets the active choice key.
''' </summary>
Public Sub getActiveKey As String
    If mbMultiSelect Then Return ""
    Return msActiveKey
End Sub

''' <summary>
''' Sets options from B4X Map.
''' </summary>
Public Sub setOptionsMap(mValue As Map)
    Dim sb As StringBuilder
    sb.Initialize
    For Each k As String In mValue.Keys
        Dim v As String = mValue.Get(k)
        If sb.Length > 0 Then sb.Append(", ")
        sb.Append(k).Append(":").Append(v)
    Next
    setOptions(sb.ToString)
End Sub

''' <summary>
''' Gets options as B4X Map.
''' </summary>
Public Sub getOptionsMap As Map
    Dim m As Map
    m.Initialize
    For i = 0 To mKeys.Size - 1
        m.Put(mKeys.Get(i), mValues.Get(i))
    Next
    Return m
End Sub

''' <summary>
''' Sets options from B4X List of key:value strings.
''' </summary>
Public Sub setOptionsList(lstValue As List)
    Dim sb As StringBuilder
    sb.Initialize
    For Each rawItem As Object In lstValue
        Dim s As String = rawItem
        If sb.Length > 0 Then sb.Append(", ")
        sb.Append(s)
    Next
    setOptions(sb.ToString)
End Sub

''' <summary>
''' Gets options as B4X List of key:value strings.
''' </summary>
Public Sub getOptionsList As List
    Dim l As List
    l.Initialize
    For i = 0 To mKeys.Size - 1
        l.Add(mKeys.Get(i) & ":" & mValues.Get(i))
    Next
    Return l
End Sub

''' <summary>
''' Sets corner radius.
''' </summary>
Public Sub setRounded(sValue As String)
    msRounded = sValue
    Refresh
End Sub

''' <summary>
''' Gets corner radius.
''' </summary>
Public Sub getRounded As String
    Return msRounded
End Sub

''' <summary>
''' Sets color variant.
''' </summary>
Public Sub setVariant(sValue As String)
    msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
    Refresh
End Sub

''' <summary>
''' Gets color variant.
''' </summary>
Public Sub getVariant As String
    Return msVariant
End Sub

''' <summary>
''' Sets filter styling.
''' </summary>
Public Sub setFilterStyle(sValue As String)
    msFilterStyle = B4XDaisyVariants.NormalizeStyle(sValue)
    Refresh
End Sub

''' <summary>
''' Gets filter styling.
''' </summary>
Public Sub getFilterStyle As String
    Return msFilterStyle
End Sub

''' <summary>
''' Sets button size.
''' </summary>
Public Sub setSize(sValue As String)
    msSize = B4XDaisyVariants.NormalizeSize(sValue)
    Refresh
End Sub

''' <summary>
''' Gets button size.
''' </summary>
Public Sub getSize As String
    Return msSize
End Sub

''' <summary>
''' Sets reset button position.
''' </summary>
Public Sub setResetPosition(sValue As String)
    msResetPosition = sValue
    Refresh
End Sub

''' <summary>
''' Gets reset button position.
''' </summary>
Public Sub getResetPosition As String
    Return msResetPosition
End Sub

''' <summary>
''' Sets reset button text.
''' </summary>
Public Sub setResetText(sValue As String)
    msResetText = sValue
    If msResetText = "" Or msResetText = Null Then msResetText = "x"
    Refresh
End Sub

''' <summary>
''' Gets reset button text.
''' </summary>
Public Sub getResetText As String
    Return msResetText
End Sub

''' <summary>
''' Sets the close/reset button display mode (icon or text).
''' </summary>
Public Sub setCloseType(sValue As String)
    msCloseType = sValue.ToLowerCase.Trim
    Refresh
End Sub

''' <summary>
''' Gets the close/reset button display mode.
''' </summary>
Public Sub getCloseType As String
    Return msCloseType
End Sub

''' <summary>
''' Sets the SVG icon name for the close/reset button.
''' </summary>
Public Sub setCloseIcon(sValue As String)
    msCloseIcon = sValue
    Refresh
End Sub

''' <summary>
''' Gets the SVG icon name for the close/reset button.
''' </summary>
Public Sub getCloseIcon As String
    Return msCloseIcon
End Sub

''' <summary>
''' Sets multiselect mode.
''' </summary>
Public Sub setMultiSelect(bValue As Boolean)
    mbMultiSelect = bValue
    Refresh
End Sub

''' <summary>
''' Gets multiselect mode.
''' </summary>
Public Sub getMultiSelect As Boolean
    Return mbMultiSelect
End Sub

''' <summary>
''' Sets layout orientation.
''' </summary>
Public Sub setOrientation(sValue As String)
    msOrientation = sValue
    Refresh
End Sub

''' <summary>
''' Gets layout orientation.
''' </summary>
Public Sub getOrientation As String
    Return msOrientation
End Sub

''' <summary>
''' Sets animation transition duration in ms.
''' </summary>
Public Sub setDuration(iValue As Int)
    miDuration = iValue
End Sub

''' <summary>
''' Gets animation transition duration in ms.
''' </summary>
Public Sub getDuration As Int
    Return miDuration
End Sub


''' <summary>
''' Sets layout width.
''' </summary>
Public Sub setWidth(sValue As String)
    msWidth = sValue
    Refresh
End Sub

''' <summary>
''' Gets layout width.
''' </summary>
Public Sub getWidth As String
    Return msWidth
End Sub

''' <summary>
''' Sets layout height.
''' </summary>
Public Sub setHeight(sValue As String)
    msHeight = sValue
    Refresh
End Sub

''' <summary>
''' Gets layout height.
''' </summary>
Public Sub getHeight As String
    Return msHeight
End Sub

''' <summary>
''' Sets layout padding.
''' </summary>
Public Sub setPadding(sValue As String)
    msPadding = sValue
    Refresh
End Sub

''' <summary>
''' Gets layout padding.
''' </summary>
Public Sub getPadding As String
    Return msPadding
End Sub

''' <summary>
''' Sets layout margin.
''' </summary>
Public Sub setMargin(sValue As String)
    msMargin = sValue
    Refresh
End Sub

''' <summary>
''' Gets layout margin.
''' </summary>
Public Sub getMargin As String
    Return msMargin
End Sub

''' <summary>
''' Sets component Tag.
''' </summary>
Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

''' <summary>
''' Gets component Tag.
''' </summary>
Public Sub getTag As Object
    Return mTag
End Sub

''' <summary>
''' Sets checked state of key.
''' </summary>
Public Sub setItemChecked(sKey As String, bChecked As Boolean)
    If mbMultiSelect = False Then
        If bChecked Then
            setActiveKey(sKey)
        Else If msActiveKey = sKey Then
            setActiveKey("")
        End If
    Else
        If bChecked Then
            mSelectedKeys.Put(sKey, True)
        Else
            mSelectedKeys.Remove(sKey)
        End If
        Refresh
    End If
End Sub

''' <summary>
''' Gets checked state of key.
''' </summary>
Public Sub isItemChecked(sKey As String) As Boolean
    If mbMultiSelect = False Then
        Return msActiveKey = sKey
    Else
        Return mSelectedKeys.ContainsKey(sKey)
    End If
End Sub

''' <summary>
''' Gets checked keys as B4X List.
''' </summary>
Public Sub getCheckedKeys As List
    Dim l As List
    l.Initialize
    If mbMultiSelect = False Then
        If msActiveKey <> "" Then l.Add(msActiveKey)
    Else
        For Each k As String In mSelectedKeys.Keys
            l.Add(k)
        Next
    End If
    Return l
End Sub

''' <summary>
''' Sets the checked items from a semicolon-delimited string of keys.
''' For single select, sets the active selection key.
''' Example: "svelte;vue;react"
''' </summary>
Public Sub setChecked(sCheckedKeys As String)
    If mbMultiSelect = False Then
        setActiveKey(sCheckedKeys)
    Else
        mSelectedKeys.Clear
        If sCheckedKeys <> Null And sCheckedKeys.Trim.Length > 0 Then
            Dim parts() As String = Regex.Split(";", sCheckedKeys)
            For Each k As String In parts
                Dim trimmed As String = k.Trim
                If trimmed.Length > 0 And mKeys.IndexOf(trimmed) >= 0 Then
                    mSelectedKeys.Put(trimmed, True)
                End If
            Next
        End If
        Refresh
    End If
End Sub

''' <summary>
''' Gets the checked items as a semicolon-delimited string.
''' Returns empty string if none checked.
''' </summary>
Public Sub getChecked As String
    If mbMultiSelect = False Then
        Return msActiveKey
    Else
        Dim out As List
        out.Initialize
        For Each k As String In mKeys
            If mSelectedKeys.ContainsKey(k) Then out.Add(k)
        Next
        Dim sb As StringBuilder
        sb.Initialize
        For i = 0 To out.Size - 1
            If i > 0 Then sb.Append(";")
            sb.Append(out.Get(i))
        Next
        Return sb.ToString
    End If
End Sub

''' <summary>
''' Sets options from a B4X Map.
''' Alias for compatibility with ToggleGroup / CheckboxGroup.
''' </summary>
Public Sub setItems(mValue As Map)
    setOptionsMap(mValue)
End Sub

''' <summary>
''' Gets options as a B4X Map.
''' Alias for compatibility with ToggleGroup / CheckboxGroup.
''' </summary>
Public Sub getItems As Map
    Return getOptionsMap
End Sub

''' <summary>
''' Sets checked selection using a list of keys.
''' Alias for compatibility with ToggleGroup / CheckboxGroup.
''' </summary>
Public Sub setSelectedIds(lstIds As List)
    mSelectedKeys.Clear
    If lstIds <> Null And lstIds.IsInitialized Then
        For Each id As String In lstIds
            Dim trimmed As String = id.Trim
            If mKeys.IndexOf(trimmed) >= 0 Then
                mSelectedKeys.Put(trimmed, True)
            End If
        Next
    End If
    Refresh
End Sub

''' <summary>
''' Gets checked selection as a list of keys.
''' Alias for compatibility with ToggleGroup / CheckboxGroup.
''' </summary>
Public Sub getSelectedIds As List
    Return getCheckedKeys
End Sub

''' <summary>
''' Rebuilds the underlying options buttons.
''' </summary>
Private Sub RebuildOptions
    If mOptionButtons.IsInitialized = False Then mOptionButtons.Initialize
    If mKeys.IsInitialized = False Then mKeys.Initialize
    If mValues.IsInitialized = False Then mValues.Initialize
    If mSelectedKeys.IsInitialized = False Then mSelectedKeys.Initialize

    mOptionButtons.Clear
    mKeys.Clear
    mValues.Clear
    
    Dim spec As String = msOptions.Trim
    If spec.Length > 0 Then
        Dim parts() As String = Regex.Split("\s*[,|]\s*", spec)
        For Each part As String In parts
            Dim trimmed As String = part.Trim
            If trimmed.Length > 0 Then
                Dim key As String = ""
                Dim val As String = ""
                Dim colonIdx As Int = trimmed.IndexOf(":")
                If colonIdx >= 0 Then
                    key = trimmed.SubString2(0, colonIdx).Trim
                    val = trimmed.SubString(colonIdx + 1).Trim
                Else
                    key = trimmed
                    val = trimmed
                End If
                If key.Length > 0 Then
                    mKeys.Add(key)
                    mValues.Add(val)
                End If
            End If
        Next
    End If

    Dim tempSelected As Map
    tempSelected.Initialize
    For Each k As String In mSelectedKeys.Keys
        if mKeys.IndexOf(k) >= 0 Then
            tempSelected.Put(k, True)
        End If
    Next
    mSelectedKeys = tempSelected
    
    If pnlContainer.IsInitialized Then
        pnlContainer.RemoveAllViews
        
        Dim rbtn As B4XDaisyButton
        rbtn.Initialize(Me, "FilterBtn")
        Dim rView As B4XView = rbtn.AddToParent(pnlContainer, 0, 0, 1dip, 1dip)
        If msCloseType.ToLowerCase = "icon" Then
            rbtn.IconName = msCloseIcon
            rbtn.Text = ""
            rbtn.Square = True
        Else
            rbtn.IconName = ""
            rbtn.Text = msResetText
            rbtn.Square = (msResetText.Length <= 1)
        End If
        rbtn.Variant = "none"
        rbtn.Style = msFilterStyle
        rbtn.Size = msSize
        rbtn.Rounded = msRounded
        rbtn.setTag(-2)
        mResetButton = rbtn
        
        For i = 0 To mKeys.Size - 1
            Dim key As String = mKeys.Get(i)
            Dim label As String = mValues.Get(i)
            
            Dim btn As B4XDaisyButton
            btn.Initialize(Me, "FilterBtn")
            Dim bView As B4XView = btn.AddToParent(pnlContainer, 0, 0, 1dip, 1dip)
            btn.Text = label
            btn.Variant = msVariant
            btn.Style = msFilterStyle
            btn.Size = msSize
            btn.Rounded = msRounded
            btn.setTag(i)
            mOptionButtons.Add(btn)
        Next
    End If
End Sub

''' <summary>
''' Updates styling of the component and child views.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    If mResetButton.IsInitialized Then
        If msCloseType.ToLowerCase = "icon" Then
            mResetButton.IconName = msCloseIcon
            mResetButton.Text = ""
            mResetButton.Square = True
        Else
            mResetButton.IconName = ""
            mResetButton.Text = msResetText
            mResetButton.Square = (msResetText.Length <= 1)
        End If
        mResetButton.Style = msFilterStyle
        mResetButton.Size = msSize
        mResetButton.Rounded = msRounded
        mResetButton.Refresh
    End If
    
    For i = 0 To mOptionButtons.Size - 1
        Dim btn As B4XDaisyButton = mOptionButtons.Get(i)
        Dim key As String = mKeys.Get(i)
        
        btn.Style = msFilterStyle
        btn.Size = msSize
        btn.Rounded = msRounded
        
        Dim isActive As Boolean = False
        If mbMultiSelect = False Then
            isActive = (key = msActiveKey)
        Else
            isActive = mSelectedKeys.ContainsKey(key)
        End If
        
        btn.Active = isActive
        If isActive Then
            btn.Variant = msVariant
        Else
            btn.Variant = "none"
        End If
        btn.Refresh
    Next
    
    Base_Resize(mBase.Width, mBase.Height)
End Sub

''' <summary>
''' Forces the component to re-resolve theme-aware styling.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        DesignerCreateView(p, Null, BuildRuntimeProps)
    End If
    vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
    Return mBase
End Sub

''' <summary>
''' Removes the view from its parent.
''' </summary>
Public Sub RemoveViewFromParent
    If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

''' <summary>
''' Gets the computed height of the filter component.
''' </summary>
Public Sub GetComputedHeight As Int
    If mBase.IsInitialized = False Then Return 0
    Return mBase.Height
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If pnlContainer.IsInitialized = False Then Return

    If inResize Then Return
    inResize = True
    pnlContainer.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)

    Dim duration As Int = 0
    If mFirstLayout = False And mAnimateNextLayout Then
        duration = miDuration
    End If
    mFirstLayout = False
    mAnimateNextLayout = False

    Dim resetVisible As Boolean = False
    If mbMultiSelect = False Then
        resetVisible = (msActiveKey <> "")
    Else
        Dim anyChecked As Boolean = False
        For Each checked As Boolean In mSelectedKeys.Values
            If checked Then anyChecked = True
        Next
        resetVisible = anyChecked
    End If

    Dim allButtons As List
    allButtons.Initialize
    
    If msResetPosition = "left" Then
        allButtons.Add(mResetButton)
    End If
    
    For Each btn As B4XDaisyButton In mOptionButtons
        allButtons.Add(btn)
    Next
    
    If msResetPosition = "right" Then
        allButtons.Add(mResetButton)
    End If

    Dim rowHeight As Int = ResolveButtonHeightDip(msSize)
    Dim gap As Int = 4dip
    Dim x As Int = 0
    Dim y As Int = 0
    Dim hasVisible As Boolean = False

    For Each btn As B4XDaisyButton In allButtons
        Dim isReset As Boolean = (btn.Tag Is Int And btn.Tag = -2)
        Dim targetW As Int = 0
        
        If isReset Then
            If resetVisible Then
                targetW = btn.GetEstimateContentWidth
            End If
        Else
            Dim optIdx As Int = btn.Tag
            Dim key As String = mKeys.Get(optIdx)
            
            If mbMultiSelect = False Then
                If msActiveKey = "" Or key = msActiveKey Then
                    targetW = btn.GetEstimateContentWidth
                End If
            Else
                targetW = btn.GetEstimateContentWidth
            End If
        End If
        
        If targetW > 0 Then
            hasVisible = True
            btn.Visible = True
            If msOrientation = "vertical" Then
                btn.mBase.SetLayoutAnimated(duration, 0, y, dWidth, rowHeight)
                btn.Base_Resize(dWidth, rowHeight)
                y = y + rowHeight + gap
            Else
                If x > 0 And x + targetW > dWidth Then
                    x = 0
                    y = y + rowHeight + gap
                End If
                btn.mBase.SetLayoutAnimated(duration, x, y, targetW, rowHeight)
                btn.Base_Resize(targetW, rowHeight)
                x = x + targetW + gap
            End If
        Else
            btn.mBase.SetLayoutAnimated(duration, x, y, 1dip, rowHeight)
            If duration > 0 Then
                HideButtonDelayed(btn, duration)
            Else
                btn.Visible = False
            End If
        End If
    Next

    Dim computedHeight As Int = 0
    If hasVisible Then
        If msOrientation = "vertical" Then
            computedHeight = y - gap
        Else
            computedHeight = y + rowHeight
        End If
    End If
    computedHeight = Max(1dip, computedHeight)

    If msHeight = "h-auto" Or msHeight = "auto" Then
        If Abs(mBase.Height - computedHeight) > 1dip Then
            mBase.SetLayoutAnimated(duration, mBase.Left, mBase.Top, mBase.Width, computedHeight)
        End If
    End If
    inResize = False
End Sub

Private Sub HideButtonDelayed(btn As B4XDaisyButton, iDelayMs As Int)
    Sleep(iDelayMs)
    If btn.IsInitialized And btn.mBase.IsInitialized Then
        If btn.mBase.Width <= 1dip Then
            btn.Visible = False
        End If
    End If
End Sub

Private Sub FilterBtn_Click (oTag As Object)
    mAnimateNextLayout = True
    Dim idx As Int = oTag
    If idx = -2 Then
        If mbMultiSelect = False Then
            Dim oldActive As String = msActiveKey
            If oldActive <> "" Then
                Dim oldVal As String = ""
                Dim oldIdx As Int = mKeys.IndexOf(oldActive)
                If oldIdx >= 0 Then oldVal = mValues.Get(oldIdx)
                setActiveKey("")
                RaiseItemChanged(oldActive, oldVal, False)
                RaiseChanged
            End If
        Else
            Dim selected As List = getSelectedIds
            mSelectedKeys.Clear
            Refresh
            For Each k As String In selected
                Dim label As String = ""
                Dim kIdx As Int = mKeys.IndexOf(k)
                If kIdx >= 0 Then label = mValues.Get(kIdx)
                RaiseItemChanged(k, label, False)
            Next
            RaiseChanged
        End If
        If xui.SubExists(mCallBack, mEventName & "_ResetClick", 0) Then
            CallSub(mCallBack, mEventName & "_ResetClick")
        End If
    Else
        Dim key As String = mKeys.Get(idx)
        Dim labelText As String = mValues.Get(idx)
        
        If mbMultiSelect = False Then
            Dim oldActive As String = msActiveKey
            If oldActive <> key Then
                setActiveKey(key)
                If oldActive <> "" Then
                    Dim oldVal As String = ""
                    Dim oldIdx As Int = mKeys.IndexOf(oldActive)
                    If oldIdx >= 0 Then oldVal = mValues.Get(oldIdx)
                    RaiseItemChanged(oldActive, oldVal, False)
                End If
                RaiseItemChanged(key, labelText, True)
                RaiseChanged
            End If
        Else
            Dim currentVal As Boolean = mSelectedKeys.ContainsKey(key)
            If currentVal Then
                mSelectedKeys.Remove(key)
            Else
                mSelectedKeys.Put(key, True)
            End If
            Refresh
            RaiseItemChanged(key, labelText, Not(currentVal))
            RaiseChanged
        End If
    End If
End Sub

Private Sub RaiseChanged
    If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
        CallSub2(mCallBack, mEventName & "_Changed", getSelectedIds)
    End If
End Sub

Private Sub RaiseItemChanged(sId As String, sText As String, bChecked As Boolean)
    Dim subName As String = mEventName & "_ItemChanged"
    If xui.SubExists(mCallBack, subName, 3) Then
        #If B4A
        Dim jo As JavaObject = mCallBack
        jo.RunMethod("_" & subName.ToLowerCase, Array(sId, sText, bChecked))
        #Else If B4J
        Dim jo As JavaObject = mCallBack
        jo.RunMethod("_" & subName.ToLowerCase, Array(sId, sText, bChecked))
        #Else If B4i
        Dim no As NativeObject = mCallBack
        no.RunMethod("_" & subName.ToLowerCase & ":::", Array(sId, sText, bChecked))
        #End If
    End If
End Sub
#End Region

#Region Sizing Helpers

Private Sub ResolveButtonHeightDip(sSizeToken As String) As Int
    Select Case B4XDaisyVariants.NormalizeSize(sSizeToken)
        Case "xs"
            Return 24dip
        Case "sm"
            Return 32dip
        Case "md"
            Return 40dip
        Case "lg"
            Return 48dip
        Case "xl"
            Return 56dip
        Case Else
            Return 40dip
    End Select
End Sub
#End Region

' Required class tokens: aspect-square, btn, btn-square, filter, filter-reset, flex, flex-wrap, me-1, mx-0, opacity-0, opacity-100, overflow-hidden, px-0, w-0, w-auto

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
