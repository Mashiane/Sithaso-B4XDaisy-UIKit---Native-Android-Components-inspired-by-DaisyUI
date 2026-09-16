B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#End Region

#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Layout orientation for the segments.
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: String, DefaultValue: gap-2, List: gap-0|gap-1|gap-2|gap-3|gap-4|gap-5|gap-6|gap-8, Description: Spacing between segments.
#DesignerProperty: Key: AutoWidth, DisplayName: Auto Width, FieldType: Boolean, DefaultValue: True, Description: If true, all countdown elements will have the same width matching the longest item.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: transparent, List: transparent|base-100|base-200|base-300|neutral|primary|secondary|accent, Description: Background color for the container.
#DesignerProperty: Key: Border, DisplayName: Border, FieldType: Boolean, DefaultValue: False, Description: Show a border around the container (standard base-300 border).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-md, List: none|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius token applied to the container and child items.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: shadow-md, List: none|shadow|shadow-sm|shadow-md|shadow-lg|shadow-xl|shadow-2xl|shadow-inner, Description: Shadow effect applied to child items.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-0, List: p-0|p-1|p-2|p-3|p-4|p-5|p-6|p-8, Description: Inner padding for the container.
#DesignerProperty: Key: CountDownType, DisplayName: Count Down Type, FieldType: String, DefaultValue: default, List: default|auto, Description: 'default' = items added manually with AddItem; 'auto' = items auto-generated from Format tokens.
#DesignerProperty: Key: Format, DisplayName: Display Format, FieldType: String, DefaultValue: , Description: Display format with tokens like {d}:{h}:{m}:{s} (d=days, h=hours, m=minutes, s=seconds). Used when CountDownType=auto.
#DesignerProperty: Key: TargetDate, DisplayName: Target Date, FieldType: String, DefaultValue: 2026-12-31, Description: Target date/time as a date string (e.g. "2026-12-31" or "2026-12-31 23:59:59") or ticks (Long).
#DesignerProperty: Key: AutoStart, DisplayName: Auto Start, FieldType: Boolean, DefaultValue: True, Description: Start the countdown timer automatically when the view is created.
#DesignerProperty: Key: Labels, DisplayName: Labels, FieldType: String, DefaultValue: , Description: Pipe-delimited labels for auto mode (e.g. "days|hours|minutes|seconds").
#DesignerProperty: Key: LabelPosition, DisplayName: Label Position, FieldType: String, DefaultValue: none, List: none|bottom|right, Description: Where to place labels relative to the number. 'none' hides labels.
#DesignerProperty: Key: TextSize, DisplayName: Font Size, FieldType: String, DefaultValue: md, List: text-xs|text-sm|md|text-base|text-lg|text-xl|text-2xl|text-3xl|text-4xl|text-5xl|text-6xl|text-7xl|text-8xl|text-9xl, Description: Typography size token for all child items.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: DaisyUI semantic color variant for all child items.
#DesignerProperty: Key: Outline, DisplayName: Outline, FieldType: Boolean, DefaultValue: False, Description: If true, child items will have an outline.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    Private mVisible As Boolean = True

    
    ' Local properties
    Private msOrientation As String = "horizontal"
    Private msGap As String = "gap-2"
    Private mbAutoWidth As Boolean = True
    Private msBackgroundColor As String = "transparent"
    Private mbBorder As Boolean = False
    ' container rounding is now a string token instead of a boolean
    Private msRounded As String = "rounded-md"    ' corner radius mode
    Private msPadding As String = "p-0"
    Private msShadow As String = "shadow-md"     ' shadow token applied to child items
    Private mbOutline As Boolean = False

    ' Auto mode properties
    Private msCountDownType As String = "default"
    Private msFormat As String = ""

    ' Countdown timer properties
    Private mlTargetDate As Long = 0
    Private mbAutoStart As Boolean = True
    Private msLabels As String = ""
    Private msLabelPosition As String = "none"
    Private msTextSize As String = "md"
    Private msVariant As String = "none"
    Private timerCountdown As Timer
    Private mbCountdownRunning As Boolean = False

    ' debug helper: if true we draw a red outline around the whole countdown
    ' (disabled by default in production builds)
    Private DEBUG_BORDER As Boolean = False
    
    Private mItems As List
    Private mIsResizing As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mItems.Initialize
    timerCountdown.Initialize("timerCountdown", 1000)
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    
    ApplyDesignerProps(mProps)
    mBase.Visible = mVisible
    Refresh
    
    ' Auto-start timer if AutoStart is true and TargetDate is set
    If mbAutoStart And mlTargetDate > 0 Then
        Start
    End If
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
    
    ' auto-build items from format when in auto mode and no items yet
    If msCountDownType = "auto" And mItems.Size = 0 And msFormat <> "" Then
        AutoBuildItemsFromFormat
    End If
    
    ' Ensure all items are initialized and added to mBase
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyCountdownItem = mItems.Get(i)
        ' ensure the item itself is ready
        If itm.getIsInitialized = False Then
            itm.CreateView(40dip, 40dip)
        End If
        
        ' propagate rounded/shadow to items (AFTER potential CreateView call)
        itm.setRounded(msRounded)
        itm.setShadow(msShadow)
        itm.setLabelPosition(msLabelPosition)
        itm.setTextSize(msTextSize)
        itm.setVariant(msVariant)
        itm.setOutline(mbOutline)
        
        ' operate on its view only when it's truly initialized
        Dim v As B4XView = itm.View
        If v.IsInitialized Then
            ' Detach if already has a different parent
            Try
                v.RemoveViewFromParent
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCountdown.Refresh: " & LastException.Message)
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
    Item.setLabelPosition(msLabelPosition)
    Item.setTextSize(msTextSize)
    Item.setVariant(msVariant)
    Item.setOutline(mbOutline)
    ' Detach from previous parent if any to avoid "child already has a parent" crash
    If Item.getIsInitialized And Item.mBase.IsInitialized Then
        Try
            Item.mBase.RemoveViewFromParent
        Catch
            If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCountdown.AddItem: " & LastException.Message)
            ' Ignore if it has no parent yet
        End Try
    End If
    Refresh
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
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

Public Sub Clear
    For Each itm As B4XDaisyCountdownItem In mItems
        itm.View.RemoveViewFromParent
    Next
    mItems.Clear
    Refresh
End Sub

Public Sub getItem(iIndex As Int) As B4XDaisyCountdownItem
    If iIndex >= 0 And iIndex < mItems.Size Then
        Return mItems.Get(iIndex)
    End If
    Return Null
End Sub

Public Sub getItemsCount As Int
    Return mItems.Size
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

'** helper for programmatic insertion **
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

#Region Getters/Setters
Public Sub getOrientation As String
    Return msOrientation
End Sub

Public Sub setShadow(sValue As String)
    msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
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

Public Sub setRounded(sValue As String)
    msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
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

Public Sub setOrientation(sValue As String)
    msOrientation = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getGap As String
    Return msGap
End Sub

Public Sub setGap(sValue As String)
    msGap = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getAutoWidth As Boolean
    Return mbAutoWidth
End Sub

Public Sub setAutoWidth(bValue As Boolean)
    mbAutoWidth = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As String
    Return msBackgroundColor
End Sub

Public Sub setBackgroundColor(sValue As String)
    msBackgroundColor = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBorder As Boolean
    Return mbBorder
End Sub

Public Sub setBorder(bValue As Boolean)
    mbBorder = bValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCountDownType As String
    Return msCountDownType
End Sub

Public Sub setCountDownType(sT As String)
    msCountDownType = sT
    If sT = "auto" Then AutoBuildItemsFromFormat
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getFormat As String
    Return msFormat
End Sub

Public Sub setFormat(sF As String)
    msFormat = sF
    If msCountDownType = "auto" Then AutoBuildItemsFromFormat
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPadding As String
    Return msPadding
End Sub

Public Sub setPadding(sValue As String)
    msPadding = sValue
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

' TargetDate as date string (e.g. "2026-12-31")
Public Sub setTargetDate(sValue As String)
    mlTargetDate = ParseDateSafe(sValue)
    If mbCountdownRunning Then
        UpdateItemsValues
    End If
End Sub

Public Sub getTargetDate As String
    If mlTargetDate = 0 Then Return ""
    Return DateTime.Date(mlTargetDate)
End Sub

' AutoStart
Public Sub setAutoStart(bValue As Boolean)
    mbAutoStart = bValue
End Sub

Public Sub getAutoStart As Boolean
    Return mbAutoStart
End Sub

' Labels
Public Sub setLabels(sValue As String)
    msLabels = sValue
    If msCountDownType = "auto" Then AutoBuildItemsFromFormat
    If mBase.IsInitialized Then Refresh
End Sub

Public Sub getLabels As String
    Return msLabels
End Sub

' LabelPosition
Public Sub setLabelPosition(sValue As String)
    If sValue = "right" Or sValue = "bottom" Or sValue = "none" Then
        msLabelPosition = sValue
    Else
        msLabelPosition = "none"
    End If
    If mBase.IsInitialized Then
        For Each itm As B4XDaisyCountdownItem In mItems
            itm.setLabelPosition(msLabelPosition)
        Next
    End If
End Sub

Public Sub getLabelPosition As String
    Return msLabelPosition
End Sub

' TextSize
Public Sub setTextSize(sValue As String)
    msTextSize = sValue
    If mBase.IsInitialized Then
        For Each itm As B4XDaisyCountdownItem In mItems
            itm.setTextSize(msTextSize)
        Next
        Refresh
    End If
End Sub

Public Sub getTextSize As String
    Return msTextSize
End Sub

' Variant
Public Sub setVariant(sValue As String)
    msVariant = sValue
    If mBase.IsInitialized Then
        For Each itm As B4XDaisyCountdownItem In mItems
            itm.setVariant(msVariant)
        Next
        Refresh
    End If
End Sub

Public Sub getVariant As String
    Return msVariant
End Sub

Public Sub getOutline As Boolean
    Return mbOutline
End Sub

Public Sub setOutline(bValue As Boolean)
    mbOutline = bValue
    If mBase.IsInitialized Then
        For Each itm As B4XDaisyCountdownItem In mItems
            itm.setOutline(mbOutline)
        Next
        Refresh
    End If
End Sub
#End Region
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
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
    
    ' First pass: refresh all items so they compute their required widths
    For Each itm As B4XDaisyCountdownItem In mItems
        itm.Refresh
    Next
    
    ' If AutoWidth is enabled, find the maximum width
    Dim finalItemW As Int = -1
    If mbAutoWidth Then
        Dim maxItemW As Int = 0
        For Each itm As B4XDaisyCountdownItem In mItems
            If itm.getRequiredWidth > maxItemW Then
                maxItemW = itm.getRequiredWidth
            End If
        Next
        finalItemW = maxItemW
    End If
    
    Dim currentPos As Int = padding
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyCountdownItem = mItems.Get(i)
        
        If msOrientation = "horizontal" Then
            Dim itemW As Int = itm.getRequiredWidth
            If finalItemW > 0 Then
                itemW = finalItemW
                itm.setTargetWidth(finalItemW)
            Else
                itm.setTargetWidth(-1)
            End If
            If itemW < 10dip Then itemW = 40dip
            Dim itemH As Int = mBase.Height - padding * 2
            If itemH < 10dip Then itemH = 40dip
            
            itm.mBase.SetLayoutAnimated(0, currentPos, padding, itemW, itemH)
            itm.Base_Resize(itemW, itemH)
            
            currentPos = currentPos + itemW + gap
        Else
            itm.setTargetWidth(-1)
            Dim itemW As Int = mBase.Width - padding * 2
            If itemW < 10dip Then itemW = 40dip
            Dim itemH As Int = itm.mBase.Height
            If itemH < 10dip Then itemH = 40dip
            
            itm.mBase.SetLayoutAnimated(0, padding, currentPos, itemW, itemH)
            itm.Base_Resize(itemW, itemH)
            
            currentPos = currentPos + itemH + gap
        End If
    Next
End Sub
#End Region

#Region Auto Build
Private Sub AutoBuildItemsFromFormat
    If msFormat = "" Then Return
    If mItems.IsInitialized = False Then mItems.Initialize
    
    ' Parse format string (e.g. "dd:hh:mm:ss" or "days:hours")
    Dim tokens() As String = Regex.Split(":|=|,|;|\|", msFormat)
    Dim newItems As List
    newItems.Initialize
    Dim i As Int = 0
    
    For Each token As String In tokens
        token = token.Trim
        If token = "" Then Continue
        If IsValidCountdownToken(token) = False Then Continue
        
        Dim label As String = ""
        Dim places As Int = 2
        
        Select token.ToLowerCase
            Case "d", "dd", "days", "day"
                label = "days"
                If token.StartsWith("dd") Or token = "days" Then
                    places = 2
                Else
                    places = 1
                End If
            Case "h", "hh", "hours", "hour"
                label = "hours"
                If token.StartsWith("hh") Or token = "hours" Then
                    places = 2
                Else
                    places = 1
                End If
            Case "m", "mm", "minutes", "minute", "min"
                label = "minutes"
                If token.StartsWith("mm") Or token = "minutes" Or token = "min" Then
                    places = 2
                Else
                    places = 1
                End If
            Case "s", "ss", "seconds", "second", "sec"
                label = "seconds"
                If token.StartsWith("ss") Or token = "seconds" Or token = "sec" Then
                    places = 2
                Else
                    places = 1
                End If
        End Select
        
        Dim itm As B4XDaisyCountdownItem
        itm.Initialize(Me, "")
        itm.setValue(0)
        itm.setDigits(places)
        ' Use Labels pipe-delimited list if provided, else use auto-detected label
        If msLabels <> "" Then
            Dim labelTokens() As String = Regex.Split("\|", msLabels)
            If i < labelTokens.Length Then
                itm.setLabel(labelTokens(i).Trim)
            Else
                itm.setLabel(label)
            End If
        Else
            itm.setLabel(label)
        End If
        itm.setLabelPosition(msLabelPosition)
        itm.setTextSize(msTextSize)
        itm.setVariant(msVariant)
        itm.setOutline(mbOutline)
        newItems.Add(itm)
        i = i + 1
    Next
    
    ' Replace mItems with auto-built items
    For Each itm As B4XDaisyCountdownItem In mItems
        If itm.View.IsInitialized Then itm.View.RemoveViewFromParent
    Next
    mItems.Clear
    
    For i = 0 To newItems.Size - 1
        Dim itm As B4XDaisyCountdownItem = newItems.Get(i)
        mItems.Add(itm)
    Next
End Sub

Private Sub IsValidCountdownToken(sT As String) As Boolean
    Dim valid() As String = Array As String("d", "dd", "days", "day", "h", "hh", "hours", "hour", "m", "mm", "minutes", "minute", "min", "s", "ss", "seconds", "second", "sec")
    For Each v As String In valid
        If sT.ToLowerCase = v Then Return True
    Next
    Return False
End Sub
#End Region

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
    msOrientation = B4XDaisyVariants.GetPropString(mProps, "Orientation", msOrientation)
    msGap = B4XDaisyVariants.GetPropString(mProps, "Gap", msGap)
    mbAutoWidth = B4XDaisyVariants.GetPropBool(mProps, "AutoWidth", mbAutoWidth)
    msBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "BackgroundColor", msBackgroundColor)
    mbBorder = B4XDaisyVariants.GetPropBool(mProps, "Border", mbBorder)
    msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
    msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
    msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
    msCountDownType = B4XDaisyVariants.GetPropString(mProps, "CountDownType", msCountDownType)
    msFormat = B4XDaisyVariants.GetPropString(mProps, "Format", msFormat)
    Dim targetDateStr As String = B4XDaisyVariants.GetPropString(mProps, "TargetDate", "")
    If targetDateStr <> "" Then mlTargetDate = ParseDateSafe(targetDateStr)
    mbAutoStart = B4XDaisyVariants.GetPropBool(mProps, "AutoStart", True)
    msLabels = B4XDaisyVariants.GetPropString(mProps, "Labels", msLabels)
    msLabelPosition = B4XDaisyVariants.GetPropString(mProps, "LabelPosition", msLabelPosition)
    msTextSize = B4XDaisyVariants.GetPropString(mProps, "TextSize", msTextSize)
    msVariant = B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant)
    mbOutline = B4XDaisyVariants.GetPropBool(mProps, "Outline", False)
    mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Orientation", msOrientation)
	props.Put("Gap", msGap)
	props.Put("AutoWidth", mbAutoWidth)
	props.Put("BackgroundColor", msBackgroundColor)
	props.Put("Border", mbBorder)
	props.Put("Rounded", msRounded)
	props.Put("Padding", msPadding)
	props.Put("Shadow", msShadow)
	props.Put("CountDownType", msCountDownType)
	props.Put("Format", msFormat)
	props.Put("TargetDate", mlTargetDate)
	props.Put("AutoStart", mbAutoStart)
	props.Put("Labels", msLabels)
	props.Put("LabelPosition", msLabelPosition)
	props.Put("TextSize", msTextSize)
	props.Put("Variant", msVariant)
	props.Put("Outline", mbOutline)
	props.Put("Visible", mVisible)
	Return props
End Sub
#Region Countdown Timer
Public Sub Start
    If mlTargetDate <= 0 Then Return
    mbCountdownRunning = True
    timerCountdown.Enabled = True
    UpdateItemsValues
End Sub

Public Sub Stop
    mbCountdownRunning = False
    timerCountdown.Enabled = False
End Sub

Public Sub IsRunning As Boolean
    Return mbCountdownRunning
End Sub

Private Sub timerCountdown_Tick
    If mbCountdownRunning = False Then
        timerCountdown.Enabled = False
        Return
    End If
    UpdateItemsValues
End Sub

Private Sub UpdateItemsValues
    If mItems.Size = 0 Then Return
    Dim nowTicks As Long = DateTime.Now
    Dim diff As Long = mlTargetDate - nowTicks
    If diff < 0 Then diff = 0
    
    Dim totalSeconds As Long = diff / 1000
    Dim days As Int = totalSeconds / 86400
    Dim hours As Int = (totalSeconds Mod 86400) / 3600
    Dim minutes As Int = (totalSeconds Mod 3600) / 60
    Dim seconds As Int = totalSeconds Mod 60
    
    For i = 0 To mItems.Size - 1
        Dim itm As B4XDaisyCountdownItem = mItems.Get(i)
        Dim token As String = ""
        If msCountDownType = "auto" Then
            ' derive token from item's label for positional mapping
            token = itm.getLabel.ToLowerCase
        End If
        
        Dim val As Int = 0
        Select token
            Case "days", "day", "d", "dd"
                val = days
            Case "hours", "hour", "h", "hh"
                val = hours
            Case "minutes", "minute", "min", "m", "mm"
                val = minutes
            Case "seconds", "second", "sec", "s", "ss"
                val = seconds
            Case Else
                ' positional fallback: 0=days, 1=hours, 2=minutes, 3=seconds
                Select i
                    Case 0: val = days
                    Case 1: val = hours
                    Case 2: val = minutes
                    Case 3: val = seconds
                End Select
        End Select
        
        itm.setAnimated(True)
        itm.setValue(val)
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

#Region Helpers
Private Sub NumToDateString(lV As Long) As String
    If lV = 0 Then Return ""
    Return DateTime.Date(lV)
End Sub

Private Sub ParseDateSafe(sValue As String) As Long
    If sValue = "" Then Return 0
    If IsNumber(sValue) Then Return sValue
    
    Dim prevDF As String = DateTime.DateFormat
    Dim prevTF As String = DateTime.TimeFormat
    Dim res As Long = 0
    Try
        Dim valClean As String = sValue.Trim
        Dim spaceIdx As Int = valClean.IndexOf(" ")
        If spaceIdx > -1 Then
            Dim datePart As String = valClean.SubString2(0, spaceIdx).Trim
            Dim timePart As String = valClean.SubString(spaceIdx + 1).Trim
            
            ' Set Date Format based on separator
            If datePart.Contains("-") Then
                DateTime.DateFormat = "yyyy-MM-dd"
            Else If datePart.Contains("/") Then
                DateTime.DateFormat = "MM/dd/yyyy"
            End If
            
            ' Set Time Format based on colon count
            Dim timeParts() As String = Regex.Split(":", timePart)
            If timeParts.Length = 3 Then
                DateTime.TimeFormat = "HH:mm:ss"
            Else
                DateTime.TimeFormat = "HH:mm"
            End If
            
            res = DateTime.DateTimeParse(datePart, timePart)
        Else
            If valClean.Contains("-") Then
                DateTime.DateFormat = "yyyy-MM-dd"
            Else If valClean.Contains("/") Then
                DateTime.DateFormat = "MM/dd/yyyy"
            End If
            res = DateTime.DateParse(valClean)
        End If
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCountdown.ParseDateSafe: " & LastException.Message)
        res = 0
    End Try
    DateTime.DateFormat = prevDF
    DateTime.TimeFormat = prevTF
    Return res
End Sub
#End Region
