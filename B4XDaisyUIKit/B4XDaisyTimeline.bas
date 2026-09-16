B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: ItemClick (Id As String)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: vertical, List: vertical|horizontal, Description: Timeline orientation.
#DesignerProperty: Key: Compact, DisplayName: Compact, FieldType: Boolean, DefaultValue: False, Description: If True, all items are pushed to one side.
#DesignerProperty: Key: SnapIcon, DisplayName: Snap Icon, FieldType: Boolean, DefaultValue: False, Description: If True, snaps the icon to start instead of middle.
#DesignerProperty: Key: LineColor, DisplayName: Line Color, FieldType: String, DefaultValue: base-300, List: base-300|primary|secondary|accent|info|success|warning|error, Description: Color of the connecting lines.
#DesignerProperty: Key: MarkerSize, DisplayName: Marker Size, FieldType: Int, DefaultValue: 20, MinRange: 4, MaxRange: 100, Description: Size of the middle marker.
#DesignerProperty: Key: MarkerColor, DisplayName: Marker Color, FieldType: String, DefaultValue: neutral, List: neutral|base-300|base-100|primary|secondary|accent|info|success|warning|error, Description: Color of the middle marker.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: text-xs, Description: Text size token applied to both start and end content (matches Daisy default for boxes).
#DesignerProperty: Key: BoxShadow, DisplayName: Box Shadow, FieldType: String, DefaultValue: sm, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation token for boxed items (shadow-sm by default).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Local properties
    Private msOrientation As String = "vertical"
    Private mbCompact As Boolean = False
    Private mbSnapIcon As Boolean = False
    Private msLineColor As String = "base-300"
    Private miMarkerSize As Int = 20dip
    Private msMarkerColor As String = "neutral"
    Private msTextSize As String = "text-xs"       ' font size token applied to start/end content
    Private msBoxShadow As String = "sm"              ' default elevation shadow
    Private mbVisible As Boolean = True
    Private mContentHeight As Int = 0        ' last measured vertical content height (sum of item heights)
    
    ' Internal management
    Type TimelineItem ( _
        Id As String, _
        Container As B4XView, _
        StartPart As B4XView, _
        MiddlePart As B4XView, _
        EndPart As B4XView, _
        LineBefore As B4XView, _
        LineAfter As B4XView, _
        StartBox As B4XView, _
        EndBox As B4XView, _
        StartLabel As Object, _
        EndLabel As Object, _
        StartLabelHost As B4XView, _
        EndLabelHost As B4XView, _
        MarkerIcon As Object, _
        IconColor As Int, _
        Variant As String, _
        DashedBorder As Boolean, _
        Done As Boolean, _
        Data As Map _
    )
    Private mItems As List
    Private svVertical As ScrollView
    Private svHorizontal As HorizontalScrollView
    Private pnlItems As B4XView
    
    ' Constants
Private Const DEFAULT_MARKER_SIZE As Int = 20dip
Private Const DEFAULT_PADDING As Int = 8dip
Private Const LABEL_CONTENT_INSET As Int = 4dip
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the Timeline component.
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
    
    ApplyDesignerProps(mProps)
    
    ' Initialize ScrollViews
    svVertical.Initialize(0)
    mBase.AddView(svVertical, 0, 0, mBase.Width, mBase.Height)
    
    svHorizontal.Initialize(0, "")
    mBase.AddView(svHorizontal, 0, 0, mBase.Width, mBase.Height)
    
    If msOrientation = "vertical" Then
        pnlItems = svVertical.Panel
        svHorizontal.Visible = False
        svVertical.Visible = True
    Else
        pnlItems = svHorizontal.Panel
        svVertical.Visible = False
        svHorizontal.Visible = True
    End If
    pnlItems.Color = xui.Color_Transparent
    
    Refresh
End Sub
#End Region

#Region Utility

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
    msOrientation = B4XDaisyVariants.GetPropString(mProps, "Orientation", msOrientation).ToLowerCase
    mbCompact = B4XDaisyVariants.GetPropBool(mProps, "Compact", mbCompact)
    mbSnapIcon = B4XDaisyVariants.GetPropBool(mProps, "SnapIcon", mbSnapIcon)
    msLineColor = B4XDaisyVariants.GetPropString(mProps, "LineColor", msLineColor).ToLowerCase
    miMarkerSize = DipToCurrent(B4XDaisyVariants.GetPropInt(mProps, "MarkerSize", 20))
    msMarkerColor = B4XDaisyVariants.GetPropString(mProps, "MarkerColor", msMarkerColor).ToLowerCase
    msTextSize = B4XDaisyVariants.GetPropString(mProps, "TextSize", msTextSize)
    msBoxShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "BoxShadow", msBoxShadow))
    If mProps.ContainsKey("Visible") Then
        mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    Else
        mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visibility", mbVisible)
    End If
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Orientation", msOrientation)
	props.Put("Compact", mbCompact)
	props.Put("SnapIcon", mbSnapIcon)
	props.Put("LineColor", msLineColor)
	props.Put("MarkerSize", miMarkerSize / 1dip)
	props.Put("MarkerColor", msMarkerColor)
	props.Put("TextSize", msTextSize)
	props.Put("BoxShadow", msBoxShadow)
	props.Put("Visible", mbVisible)
	Return props
End Sub

Private Sub GenerateItemId As String
    Return "item_" & DateTime.Now & "_" & Rnd(0, 100000)
End Sub

' return item reference or Null if not found
Private Sub findItem(sId As String) As TimelineItem
    For i = 0 To mItems.Size - 1
        Dim itm As TimelineItem = mItems.Get(i)
        If itm.Id = sId Then Return itm
    Next
    Return Null
End Sub

#End Region

#Region Public API
''' <summary>
''' Adds a timeline item with start text and end content.  The middle icon is
''' omitted and defaults to `check-solid.svg` (the Daisy standard marker).
''' </summary>
Public Sub AddItem(sId As String, sStartText As String, sEndText As String) As String
    ' caller supplies identifier; if blank generate one internally
    If sId = "" Then sId = GenerateItemId
    Dim defaultIcon As Object = "check-solid.svg"
    ' variant / dashed false by default
    Dim itm As TimelineItem = CreateItem(sStartText, defaultIcon, sEndText, False, False, False, "", False)
    itm.Id = sId
    mItems.Add(itm)
    Refresh
    Return sId
End Sub

''' <summary>
''' Adds a timeline item with optional box styling.
''' </summary>
Public Sub AddItemBox(sId As String, sStartText As String, sEndText As String, bBoxOnStart As Boolean, bBoxOnEnd As Boolean) As String
    If sId = "" Then sId = GenerateItemId
    Dim defaultIcon As Object = "check-solid.svg"
    ' variant / dashed default
    Dim itm As TimelineItem = CreateItem(sStartText, defaultIcon, sEndText, True, bBoxOnStart, bBoxOnEnd, "", False)
    itm.Id = sId
    mItems.Add(itm)
    Refresh
    Return sId
End Sub

''' <summary>
''' Update an existing timeline item identified by its id.  All parameters are
''' applied; if you wish to keep a value use the existing setting (query with
''' GetItem?).  The middle icon and icon color are updated as provided.
''' </summary>
Public Sub UpdateItem(sId As String, sStartText As String, oMiddleIcon As Object, iIconColor As Int, sEndText As String, bIsBox As Boolean, bBoxOnStart As Boolean, bBoxOnEnd As Boolean, sVariant As String, bDashedBorder As Boolean)
    For i = 0 To mItems.Size - 1
        Dim itm As TimelineItem = mItems.Get(i)
        If itm.Id = sId Then
            ' remove old view from panel
            If itm.Container.IsInitialized Then itm.Container.RemoveViewFromParent
            ' create replacement item and keep id/iconcolor
            Dim newIcon As Object = oMiddleIcon
            If newIcon Is String Then
                Dim s As String = newIcon
                If s.Trim.Length = 0 Then newIcon = Null
            End If
            ' when updating, a Null icon means "no icon" (dot); do not default it
            Dim newItm As TimelineItem = CreateItem(sStartText, newIcon, sEndText, bIsBox, bBoxOnStart, bBoxOnEnd, sVariant, bDashedBorder)
            newItm.Id = sId
            newItm.IconColor = iIconColor
            newItm.Done = itm.Done
            mItems.Set(i, newItm)
            Refresh
            Return
        End If
    Next
End Sub
''' <summary>
''' Change only the start text of an item.
''' </summary>
Public Sub SetItemStartText(sId As String, sStartText As String)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    Dim s As String = sStartText
    Dim m As Object = itm.Data.Get("middle")
    Dim ic As Int = itm.IconColor
    Dim e As String = itm.Data.Get("end")
    Dim ib As Boolean = itm.Data.Get("isbox")
    Dim bs As Boolean = itm.Data.Get("boxonstart")
    Dim be As Boolean = itm.Data.Get("boxonend")
    Dim v As String = itm.Variant
    Dim d As Boolean = itm.DashedBorder
    UpdateItem(itm.Id, s, m, ic, e, ib, bs, be, v, d)
End Sub

''' <summary>
''' Change only the middle icon of an item.
''' </summary>
Public Sub SetItemMiddleIcon(sId As String, oMiddleIcon As Object)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    Dim s As String = itm.Data.Get("start")
    Dim m As Object = oMiddleIcon
    Dim ic As Int = itm.IconColor
    Dim e As String = itm.Data.Get("end")
    Dim ib As Boolean = itm.Data.Get("isbox")
    Dim bs As Boolean = itm.Data.Get("boxonstart")
    Dim be As Boolean = itm.Data.Get("boxonend")
    Dim v As String = itm.Variant
    Dim d As Boolean = itm.DashedBorder
    UpdateItem(itm.Id, s, m, ic, e, ib, bs, be, v, d)
End Sub

''' <summary>
''' Change the icon color.
''' </summary>
Public Sub SetItemIconColor(sId As String, iIconColor As Int)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    itm.IconColor = iIconColor
    Refresh
End Sub

''' <summary>
''' Change only the end text of an item.
''' </summary>
Public Sub SetItemEndText(sId As String, sEndText As String)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    Dim s As String = itm.Data.Get("start")
    Dim m As Object = itm.Data.Get("middle")
    Dim ic As Int = itm.IconColor
    Dim e As String = sEndText
    Dim ib As Boolean = itm.Data.Get("isbox")
    Dim bs As Boolean = itm.Data.Get("boxonstart")
    Dim be As Boolean = itm.Data.Get("boxonend")
    Dim v As String = itm.Variant
    Dim d As Boolean = itm.DashedBorder
    UpdateItem(itm.Id, s, m, ic, e, ib, bs, be, v, d)
End Sub

''' <summary>
''' Change the variant of an item.
''' </summary>
Public Sub SetItemVariant(sId As String, sVariant As String)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    Dim s As String = itm.Data.Get("start")
    Dim m As Object = itm.Data.Get("middle")
    Dim ic As Int = itm.IconColor
    Dim e As String = itm.Data.Get("end")
    Dim ib As Boolean = itm.Data.Get("isbox")
    Dim bs As Boolean = itm.Data.Get("boxonstart")
    Dim be As Boolean = itm.Data.Get("boxonend")
    Dim v As String = sVariant
    Dim d As Boolean = itm.DashedBorder
    UpdateItem(itm.Id, s, m, ic, e, ib, bs, be, v, d)
End Sub

''' <summary>
''' Enable or disable dashed border for an item.
''' </summary>
Public Sub SetItemDashedBorder(sId As String, bDashed As Boolean)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    Dim s As String = itm.Data.Get("start")
    Dim m As Object = itm.Data.Get("middle")
    Dim ic As Int = itm.IconColor
    Dim e As String = itm.Data.Get("end")
    Dim ib As Boolean = itm.Data.Get("isbox")
    Dim bs As Boolean = itm.Data.Get("boxonstart")
    Dim be As Boolean = itm.Data.Get("boxonend")
    Dim v As String = itm.Variant
    Dim d As Boolean = bDashed
    UpdateItem(itm.Id, s, m, ic, e, ib, bs, be, v, d)
End Sub

''' <summary>
''' Marks an item done/undone by toggling the middle icon.  When bDone is True
''' the standard check marker is applied; otherwise the icon is removed.
''' </summary>
Public Sub SetItemDone(sId As String, bDone As Boolean)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    itm.Done = bDone
    Dim icon As Object
    If bDone Then
        icon = "check-solid.svg"
    Else
        icon = Null
    End If
    SetItemMiddleIcon(sId, icon)
End Sub

''' <summary>
''' Gets the done state of the item.
''' </summary>
Public Sub GetItemDone(sId As String) As Boolean
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return False
    Return itm.Done
End Sub

''' <summary>
''' Toggles the done state of the item.
''' </summary>
Public Sub ToggleItem(sId As String)
    Dim itm As TimelineItem = findItem(sId)
    If itm = Null Then Return
    SetItemDone(sId, Not(itm.Done))
End Sub

''' <summary>
''' Clears all timeline items.
''' </summary>
Public Sub Clear
    mItems.Clear
    pnlItems.RemoveAllViews
    Refresh
End Sub

''' <summary>
''' Gets the number of items.
''' </summary>
Public Sub getSize As Int
    Return mItems.Size
End Sub

Private Sub CreateItem(sStartText As String, oMiddleIcon As Object, sEndText As String, bIsBox As Boolean, bBoxOnStart As Boolean, bBoxOnEnd As Boolean, sVariant As String, bDashedBorder As Boolean) As TimelineItem
    ' normalize blank string to Null so no svg is created
    If oMiddleIcon Is String Then
        Dim s As String = oMiddleIcon
        If s.Trim.Length = 0 Then oMiddleIcon = Null
    End If
    Dim itm As TimelineItem
    itm.Initialize
    itm.Id = "" ' will be set by caller or Update
    itm.IconColor = xui.Color_White
    itm.Variant = sVariant
    itm.DashedBorder = bDashedBorder
    itm.Done = False
    itm.Data = CreateMap("start": sStartText, "middle": oMiddleIcon, "end": sEndText, "isbox": bIsBox, "boxonstart": bBoxOnStart, "boxonend": bBoxOnEnd)
    
    ' Container for this timeline item
    itm.Container = xui.CreatePanel("itm_container")
    itm.Container.Color = xui.Color_Transparent
    itm.Container.Tag = mItems.Size
    
    ' Create parts
    itm.StartPart = CreatePartPanel("itm_container")
    itm.MiddlePart = CreatePartPanel("itm_container")
    itm.EndPart = CreatePartPanel("itm_container")
    itm.LineBefore = CreateLinePanel("itm_container")
    itm.LineAfter = CreateLinePanel("itm_container")
    
    Dim lColor As Int = B4XDaisyVariants.GetTokenColor("--color-" & msLineColor, xui.Color_Gray)
    If itm.Variant <> "" Then lColor = B4XDaisyVariants.GetTokenColor("--color-" & itm.Variant, lColor)
    itm.LineBefore.Color = lColor
    itm.LineAfter.Color = lColor
    
    ' Create box wrappers if needed
    itm.StartBox = Null
    itm.EndBox = Null
    itm.StartLabel = Null
    itm.EndLabel = Null
    itm.StartLabelHost = Null
    itm.EndLabelHost = Null
    itm.MarkerIcon = Null
    
    ' Add parts to container
    itm.Container.AddView(itm.StartPart, 0, 0, 0, 0)
    itm.Container.AddView(itm.MiddlePart, 0, 0, 0, 0)
    itm.Container.AddView(itm.EndPart, 0, 0, 0, 0)
    itm.Container.AddView(itm.LineBefore, 0, 0, 0, 0)
    itm.Container.AddView(itm.LineAfter, 0, 0, 0, 0)
    
    ' Add start content
    If sStartText <> "" Then
        If bIsBox And bBoxOnStart Then
            ' Create box wrapper
            itm.StartBox = CreateBoxPanel("itm_container")
            itm.Container.AddView(itm.StartBox, 0, 0, 0, 0)
            Dim lbl As B4XDaisyText = CreateContentLabel(itm.StartBox, sStartText)
            lbl.TextSize = msTextSize
            Dim bgColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
            Dim borderColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_LightGray)
            Dim txtColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
            If itm.Variant <> "" Then
                bgColor = B4XDaisyVariants.ResolveBackgroundColorVariant(itm.Variant, bgColor)
                txtColor = B4XDaisyVariants.ResolveTextColorVariant(itm.Variant, txtColor)
                ' For variants, the border is often just the same as background or slightly darker
                borderColor = B4XDaisyVariants.Blend(bgColor, xui.Color_Black, 0.1)
            End If
            
            lbl.TextColor = txtColor
            itm.StartBox.SetColorAndBorder(bgColor, 1dip, borderColor, B4XDaisyVariants.GetRadiusBoxDip(16dip))

            If itm.DashedBorder Then
                B4XDaisyVariants.ApplyDashedBorder(itm.StartBox, bgColor, 1dip, borderColor, B4XDaisyVariants.GetRadiusBoxDip(16dip), "dashed")
            End If
            itm.StartLabel = lbl
            itm.StartLabelHost = itm.StartBox
        Else
            Dim lbl As B4XDaisyText = CreateContentLabel(itm.StartPart, sStartText)
            If itm.Variant <> "" Then lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-" & itm.Variant, xui.Color_Black)
            itm.StartLabel = lbl
            itm.StartLabelHost = itm.StartPart
            lbl.HAlign = "RIGHT"
        End If
    End If
    
    ' Add end content
    If sEndText <> "" Then
        If bIsBox And bBoxOnEnd Then
            ' Create box wrapper
            itm.EndBox = CreateBoxPanel("itm_container")
            itm.Container.AddView(itm.EndBox, 0, 0, 0, 0)
            Dim lbl As B4XDaisyText = CreateContentLabel(itm.EndBox, sEndText)
            lbl.TextSize = msTextSize
            Dim bgColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
            Dim borderColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_LightGray)
            Dim txtColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
            If itm.Variant <> "" Then
                bgColor = B4XDaisyVariants.ResolveBackgroundColorVariant(itm.Variant, bgColor)
                txtColor = B4XDaisyVariants.ResolveTextColorVariant(itm.Variant, txtColor)
                borderColor = B4XDaisyVariants.Blend(bgColor, xui.Color_Black, 0.1)
            End If
            
            lbl.TextColor = txtColor
            itm.EndBox.SetColorAndBorder(bgColor, 1dip, borderColor, B4XDaisyVariants.GetRadiusBoxDip(16dip))

            If itm.DashedBorder Then
                B4XDaisyVariants.ApplyDashedBorder(itm.EndBox, bgColor, 1dip, borderColor, B4XDaisyVariants.GetRadiusBoxDip(16dip), "dashed")
            End If
            itm.EndLabel = lbl
            itm.EndLabelHost = itm.EndBox
            lbl.HAlign = "LEFT"
        Else
            Dim lbl As B4XDaisyText = CreateContentLabel(itm.EndPart, sEndText)
            If itm.Variant <> "" Then lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-" & itm.Variant, xui.Color_Black)
            itm.EndLabel = lbl
            itm.EndLabelHost = itm.EndPart
            lbl.HAlign = "LEFT"
        End If
    End If
    
    ' Add middle marker
    Dim mColor As Int = B4XDaisyVariants.GetTokenColor("--color-" & msMarkerColor, xui.Color_Gray)
    If itm.Variant <> "" Then mColor = B4XDaisyVariants.GetTokenColor("--color-" & itm.Variant, mColor)
    
    If oMiddleIcon <> Null Then
        ' Create marker with icon
        itm.MiddlePart.Color = mColor
        itm.MiddlePart.SetColorAndBorder(itm.MiddlePart.Color, 0, xui.Color_Transparent, 100dip)
        
        ' Add icon if it's a string path or SVG
        If oMiddleIcon Is String Then
            Dim iconText As String = oMiddleIcon
            iconText = iconText.Trim
            Dim iconSize As Int = Max(1dip, miMarkerSize - 8dip)
            Dim iconOffset As Int = Max(0dip, (miMarkerSize - iconSize) / 2)
            Dim svg As B4XDaisySvgIcon
            svg.Initialize(Me, "")
            svg.AddToParent(itm.MiddlePart, iconOffset, iconOffset, iconSize, iconSize)
            If iconText.ToLowerCase.EndsWith(".svg") Then
                svg.setSvgAsset(iconText)
            Else
                svg.setSvgContent(ResolveSvgContent(iconText))
            End If
            svg.Color = xui.Color_White
            svg.Size = iconSize
            svg.Clickable = False
            itm.MarkerIcon = svg
        End If
    Else
        ' Default dot marker
        itm.MiddlePart.Color = mColor
        itm.MiddlePart.SetColorAndBorder(itm.MiddlePart.Color, 0, xui.Color_Transparent, 100dip)
    End If
    
    pnlItems.AddView(itm.Container, 0, 0, pnlItems.Width, 60dip)
    Return itm
End Sub

Private Sub ResolveSvgContent(sValue As String) As String
    If sValue = Null Then Return ""
    Dim s As String = sValue.Trim
    If s.Length = 0 Then Return ""
    If s.StartsWith("<svg") Or s.StartsWith("<?xml") Then Return s
    ' Treat plain path data as Daisy-style "d" path and wrap into SVG markup.
    Return "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'><path d='" & s & "'/></svg>"
End Sub

Private Sub CreateContentLabel(vParent As B4XView, sText As String) As B4XDaisyText
    Dim lbl As B4XDaisyText
    lbl.Initialize(Me, "")
    lbl.AddToParent(vParent, 4dip, 4dip, Max(1dip, mBase.Width - 8dip), 24dip)
    lbl.Text = sText
    ' respect designer text size token for both start and end text
    lbl.TextSize = msTextSize
    lbl.SingleLine = False
    lbl.VAlign = "CENTER"
    lbl.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
    lbl.Clickable = False
    Return lbl
End Sub

Private Sub CreatePartPanel(sName As String) As B4XView
    Dim p As B4XView
    p = xui.CreatePanel(sName)
    p.Color = xui.Color_Transparent
    Return p
End Sub

Private Sub CreateLinePanel(sName As String) As B4XView
    Dim p As B4XView
    p = xui.CreatePanel(sName)
    p.Color = B4XDaisyVariants.GetTokenColor("--color-" & msLineColor, xui.Color_Gray)
    Return p
End Sub

Private Sub CreateBoxPanel(sEventName As String) As B4XView
    Dim p As B4XView
    p = xui.CreatePanel(sEventName)
    ' timeline-box style from DaisyUI
    Dim bgColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
    Dim borderColor As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_LightGray)
    Dim radius As Float = B4XDaisyVariants.GetRadiusBoxDip(16dip)
    p.SetColorAndBorder(bgColor, 1dip, borderColor, radius)
    B4XDaisyVariants.ApplyElevation(p, msBoxShadow)
    ' Ensure clipping is disabled for children if needed (B4XDaisyText handles its own)
    Return p
End Sub

''' <summary>
''' Renders/Refreshes the timeline.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    ' update text size on every label regardless of box state, and shadow on boxes
    For i = 0 To mItems.Size - 1
        Dim itm As TimelineItem = mItems.Get(i)
        If itm.StartLabel <> Null Then
            Dim lbl As B4XDaisyText = itm.StartLabel
            lbl.TextSize = msTextSize
            lbl.Base_Resize(lbl.mBase.Width, lbl.mBase.Height)
        End If
        If itm.StartBox.IsInitialized Then
            B4XDaisyVariants.ApplyElevation(itm.StartBox, msBoxShadow)
        End If
        If itm.EndLabel <> Null Then
            Dim lbl As B4XDaisyText = itm.EndLabel
            lbl.TextSize = msTextSize
            lbl.Base_Resize(lbl.mBase.Width, lbl.mBase.Height)
        End If
        If itm.EndBox.IsInitialized Then
            B4XDaisyVariants.ApplyElevation(itm.EndBox, msBoxShadow)
        End If
    Next
    Base_Resize(mBase.Width, mBase.Height)
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
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

''' <summary>
''' Sets the orientation.
''' </summary>
Public Sub setOrientation(sValue As String)
    msOrientation = sValue.ToLowerCase
    If mBase.IsInitialized Then
        If msOrientation = "vertical" Then
            svVertical.Visible = True
            svHorizontal.Visible = False
            pnlItems = svVertical.Panel
        Else
            svVertical.Visible = False
            svHorizontal.Visible = True
            pnlItems = svHorizontal.Panel
        End If
    End If
    Refresh
End Sub

''' <summary>
''' Gets the orientation.
''' </summary>
Public Sub getOrientation As String
    Return msOrientation
End Sub

''' <summary>
''' Sets compact mode.
''' </summary>
Public Sub setCompact(bValue As Boolean)
    mbCompact = bValue
    Refresh
End Sub

''' <summary>
''' Gets compact mode.
''' </summary>
Public Sub getCompact As Boolean
    Return mbCompact
End Sub

''' <summary>
''' Sets snap icon mode.
''' </summary>
Public Sub setSnapIcon(bValue As Boolean)
    mbSnapIcon = bValue
    Refresh
End Sub

''' <summary>
''' Gets snap icon mode.
''' </summary>
Public Sub getSnapIcon As Boolean
    Return mbSnapIcon
End Sub

''' <summary>
''' Sets the line color.
''' </summary>
Public Sub setLineColor(sValue As String)
    msLineColor = sValue.ToLowerCase
    Refresh
End Sub

''' <summary>
''' Gets the line color.
''' </summary>
Public Sub getLineColor As String
    Return msLineColor
End Sub

''' <summary>
''' Sets the marker size.
''' </summary>
Public Sub setMarkerSize(iValue As Int)
    miMarkerSize = DipToCurrent(iValue)
    Refresh
End Sub

''' <summary>
''' Gets the marker size.
''' </summary>
Public Sub getMarkerSize As Int
    Return miMarkerSize / 1dip
End Sub

''' <summary>
''' Sets the marker color.
''' </summary>
Public Sub setMarkerColor(sValue As String)
    msMarkerColor = sValue.ToLowerCase
    Refresh
End Sub

''' <summary>
''' Gets the marker color.
''' </summary>
Public Sub getMarkerColor As String
    Return msMarkerColor
End Sub

''' <summary>
''' Sets visibility.
''' </summary>
Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized Then mBase.Visible = mbVisible
End Sub

''' <summary>
''' Sets the default text size for start/end content.
''' </summary>
Public Sub setTextSize(sValue As String)
    msTextSize = sValue.Trim
    Refresh
End Sub

''' <summary>
''' Gets the current text size token.
''' </summary>
Public Sub getTextSize As String
    Return msTextSize
End Sub

''' <summary>
''' Sets the elevation/shadow level for boxes.
''' </summary>
Public Sub setBoxShadow(sValue As String)
    msBoxShadow = B4XDaisyVariants.NormalizeShadow(sValue)
    Refresh
End Sub

''' <summary>
''' Gets the box shadow token.
''' </summary>
Public Sub getBoxShadow As String
    Return msBoxShadow
End Sub

''' <summary>
''' Gets visibility.
''' </summary>
Public Sub getVisible As Boolean
    Return mbVisible
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
''' Gets the base view.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
#End Region

#Region Base Events
''' <summary>
''' Handles resize events.
''' </summary>
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    
    If inResize Then Return
    inResize = True
    If msOrientation = "vertical" Then
        svVertical.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
        svVertical.Visible = True
        svHorizontal.Visible = False
        pnlItems = svVertical.Panel
    Else
        svHorizontal.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
        svHorizontal.Visible = True
        svVertical.Visible = False
        pnlItems = svHorizontal.Panel
    End If
    
    Dim currentPos As Int = 0
    
    If msOrientation = "vertical" Then
        ' Vertical timeline layout
        Dim centerTrack As Int = miMarkerSize + DEFAULT_PADDING * 2
        Dim sideTrack As Int = (dWidth - centerTrack) / 2
        
        If mbCompact Then
            sideTrack = 0
        End If
        
        For i = 0 To mItems.Size - 1
            Dim itm As TimelineItem = mItems.Get(i)
            Dim itemH As Int = Max(60dip, CalculateItemHeight(itm, dWidth))
            
            itm.Container.SetLayoutAnimated(0, 0, currentPos, dWidth, itemH)
            
            ' Calculate positions
            Dim centerX As Int
            If mbCompact Then
                If mbSnapIcon Then
                    centerX = miMarkerSize / 2 + DEFAULT_PADDING
                Else
                    centerX = 10dip + miMarkerSize / 2
                End If
            Else
                centerX = sideTrack + centerTrack / 2
            End If
            
            ' Middle marker
            itm.MiddlePart.SetLayoutAnimated(0, centerX - miMarkerSize / 2, (itemH - miMarkerSize) / 2, miMarkerSize, miMarkerSize)
            
            ' Lines
            Dim lineWidth As Int = 2dip
            itm.LineBefore.SetLayoutAnimated(0, centerX - lineWidth / 2, 0, lineWidth, itemH / 2)
            itm.LineBefore.Visible = (i > 0)
            
            itm.LineAfter.SetLayoutAnimated(0, centerX - lineWidth / 2, itemH / 2, lineWidth, itemH / 2)
            itm.LineAfter.Visible = (i < mItems.Size - 1)
            
            ' Content positioning
            Dim contentStart As Int = DEFAULT_PADDING
            Dim contentEnd As Int = dWidth - DEFAULT_PADDING
            
            If mbCompact Then
                ' Compact: content on one side
                If mbSnapIcon Then
                    ' Icon on left, content on right
                    Dim endHostW As Int = dWidth - (centerX + miMarkerSize / 2 + DEFAULT_PADDING * 2)
                    Dim endW As Int = GetLabelRequiredHostWidth(itm.EndLabel, endHostW)
                    Dim endH As Int = GetLabelRequiredHostHeight(itm.EndLabel, endW)
                    
                    itm.StartPart.Visible = False
                    If itm.StartBox.IsInitialized Then itm.StartBox.Visible = False
                    
                    If itm.EndBox.IsInitialized Then
                        itm.EndBox.SetLayoutAnimated(0, centerX + miMarkerSize / 2 + DEFAULT_PADDING, (itemH - endH) / 2, endW, endH)
                        itm.EndPart.Visible = False
                        itm.EndBox.Visible = True
                    Else
                        itm.EndPart.SetLayoutAnimated(0, centerX + miMarkerSize / 2 + DEFAULT_PADDING, (itemH - endH) / 2, endW, endH)
                        itm.EndPart.Visible = (endW > 0)
                        If itm.EndBox.IsInitialized Then itm.EndBox.Visible = False
                    End If
                Else
                    ' Icon on right (default), content on left
                    Dim startHostW As Int = centerX - miMarkerSize / 2 - DEFAULT_PADDING * 2
                    Dim startW As Int = GetLabelRequiredHostWidth(itm.StartLabel, startHostW)
                    Dim startH As Int = GetLabelRequiredHostHeight(itm.StartLabel, startW)
                    
                    itm.EndPart.Visible = False
                    If itm.EndBox.IsInitialized Then itm.EndBox.Visible = False
                    
                    If itm.StartBox.IsInitialized Then
                        itm.StartBox.SetLayoutAnimated(0, centerX - miMarkerSize / 2 - DEFAULT_PADDING - startW, (itemH - startH) / 2, startW, startH)
                        itm.StartPart.Visible = False
                        itm.StartBox.Visible = True
                    Else
                        itm.StartPart.SetLayoutAnimated(0, centerX - miMarkerSize / 2 - DEFAULT_PADDING - startW, (itemH - startH) / 2, startW, startH)
                        itm.StartPart.Visible = (startW > 0)
                        If itm.StartBox.IsInitialized Then itm.StartBox.Visible = False
                    End If
                End If
            Else
                ' Normal: content on both sides
                Dim startHostW As Int = ResolveContentHostWidth(itm, True, dWidth)
                Dim endHostW As Int = ResolveContentHostWidth(itm, False, dWidth)
                
                Dim startW As Int = GetLabelRequiredHostWidth(itm.StartLabel, startHostW)
                Dim endW As Int = GetLabelRequiredHostWidth(itm.EndLabel, endHostW)
                
                Dim startH As Int = GetLabelRequiredHostHeight(itm.StartLabel, startW)
                Dim endH As Int = GetLabelRequiredHostHeight(itm.EndLabel, endW)
                
                If itm.StartBox.IsInitialized Then
                    itm.StartBox.SetLayoutAnimated(0, sideTrack - DEFAULT_PADDING - startW, (itemH - startH) / 2, startW, startH)
                    itm.StartPart.Visible = False
                    itm.StartBox.Visible = True
                Else
                    itm.StartPart.SetLayoutAnimated(0, sideTrack - DEFAULT_PADDING - startW, (itemH - startH) / 2, startW, startH)
                    itm.StartPart.Visible = (startW > 0)
                    If itm.StartBox.IsInitialized Then itm.StartBox.Visible = False
                End If
                
                If itm.EndBox.IsInitialized Then
                    itm.EndBox.SetLayoutAnimated(0, sideTrack + centerTrack + DEFAULT_PADDING, (itemH - endH) / 2, endW, endH)
                    itm.EndPart.Visible = False
                    itm.EndBox.Visible = True
                Else
                    itm.EndPart.SetLayoutAnimated(0, sideTrack + centerTrack + DEFAULT_PADDING, (itemH - endH) / 2, endW, endH)
                    itm.EndPart.Visible = (endW > 0)
                    If itm.EndBox.IsInitialized Then itm.EndBox.Visible = False
                End If
            End If
            If mbCompact Then
                LayoutItemContent(itm, startW, endW, startH, endH)
            Else
                LayoutItemContent(itm, startW, endW, startH, endH)
            End If
            LayoutItemIcon(itm)
            BringMarkerToFront(itm)
            
            currentPos = currentPos + itemH
        Next
        pnlItems.Height = Max(dHeight, currentPos)
        mContentHeight = currentPos
        pnlItems.Width = dWidth
    Else
        ' Horizontal timeline layout (Top-Middle-Bottom)
        Dim centerTrack As Int = miMarkerSize + DEFAULT_PADDING * 2
        Dim sideTrack As Int = (dHeight - centerTrack) / 2
        
        If mbCompact Then
            sideTrack = 0
        End If
        
        For i = 0 To mItems.Size - 1
            Dim itm As TimelineItem = mItems.Get(i)
            ' Horizontal items can be as wide as they need to be, but let's give them some reasonable space
            Dim requiredW As Int = GetLabelRequiredHostWidth(itm.EndLabel, 240dip)
            requiredW = Max(requiredW, GetLabelRequiredHostWidth(itm.StartLabel, 240dip))
            Dim itemW As Int = Max(120dip, requiredW + 2 * DEFAULT_PADDING)
            If itm.StartBox.IsInitialized Or itm.EndBox.IsInitialized Then itemW = Max(itemW, 140dip)
            
            itm.Container.SetLayoutAnimated(0, currentPos, 0, itemW, dHeight)
            
            Dim centerY As Int
            If mbCompact Then
                centerY = 10dip + miMarkerSize / 2
            Else
                centerY = dHeight / 2
            End If
            
            ' Middle marker
            itm.MiddlePart.SetLayoutAnimated(0, (itemW - miMarkerSize) / 2, centerY - miMarkerSize / 2, miMarkerSize, miMarkerSize)
            
            ' Lines (Horizontal)
            Dim lineHeight As Int = 2dip
            itm.LineBefore.SetLayoutAnimated(0, 0, centerY - lineHeight / 2, itemW / 2, lineHeight)
            itm.LineBefore.Visible = (i > 0)
            
            itm.LineAfter.SetLayoutAnimated(0, itemW / 2, centerY - lineHeight / 2, itemW / 2, lineHeight)
            itm.LineAfter.Visible = (i < mItems.Size - 1)
            
            ' Content positioning
            Dim contentW As Int = itemW - DEFAULT_PADDING * 2
            Dim startH As Int = GetLabelRequiredHostHeight(itm.StartLabel, contentW)
            Dim endH As Int = GetLabelRequiredHostHeight(itm.EndLabel, contentW)
            
            If mbCompact Then
                ' Compact: content on bottom usually
                itm.StartPart.Visible = False
                If itm.StartBox.IsInitialized Then itm.StartBox.Visible = False
                
                If itm.EndBox.IsInitialized Then
                    itm.EndBox.SetLayoutAnimated(0, DEFAULT_PADDING, centerY + miMarkerSize / 2 + DEFAULT_PADDING, contentW, endH)
                    itm.EndPart.Visible = False
                    itm.EndBox.Visible = True
                Else
                    itm.EndPart.SetLayoutAnimated(0, DEFAULT_PADDING, centerY + miMarkerSize / 2 + DEFAULT_PADDING, contentW, endH)
                    itm.EndPart.Visible = (endH > 0)
                    If itm.EndBox.IsInitialized Then itm.EndBox.Visible = False
                End If
            Else
                ' Normal: Top and Bottom
                Dim startY As Int = centerY - miMarkerSize / 2 - DEFAULT_PADDING - startH
                Dim endY As Int = centerY + miMarkerSize / 2 + DEFAULT_PADDING
                
                If itm.StartBox.IsInitialized Then
                    itm.StartBox.SetLayoutAnimated(0, DEFAULT_PADDING, startY, contentW, startH)
                    itm.StartPart.Visible = False
                    itm.StartBox.Visible = True
                Else
                    itm.StartPart.SetLayoutAnimated(0, DEFAULT_PADDING, startY, contentW, startH)
                    itm.StartPart.Visible = (startH > 0)
                    If itm.StartBox.IsInitialized Then itm.StartBox.Visible = False
                End If
                
                If itm.EndBox.IsInitialized Then
                    itm.EndBox.SetLayoutAnimated(0, DEFAULT_PADDING, endY, contentW, endH)
                    itm.EndPart.Visible = False
                    itm.EndBox.Visible = True
                Else
                    itm.EndPart.SetLayoutAnimated(0, DEFAULT_PADDING, endY, contentW, endH)
                    itm.EndPart.Visible = (endH > 0)
                    If itm.EndBox.IsInitialized Then itm.EndBox.Visible = False
                End If
            End If
            
            LayoutItemContent(itm, contentW, contentW, startH, endH)
            LayoutItemIcon(itm)
            BringMarkerToFront(itm)
            
            currentPos = currentPos + itemW
        Next
        pnlItems.Width = Max(dWidth, currentPos)
        pnlItems.Height = dHeight
    End If
    inResize = False
End Sub

#Region Item Click Event
Private Sub itm_container_Click
    Dim clickedView As B4XView = Sender
    For Each itm As TimelineItem In mItems
        If itm.Container = clickedView Or _
           itm.StartPart = clickedView Or _
           itm.MiddlePart = clickedView Or _
           itm.EndPart = clickedView Or _
           itm.LineBefore = clickedView Or _
           itm.LineAfter = clickedView Then
            If xui.SubExists(mCallBack, mEventName & "_ItemClick", 1) Then
                CallSub2(mCallBack, mEventName & "_ItemClick", itm.Id)
            End If
            Return
        End If
        If itm.StartBox <> Null Then
            If itm.StartBox = clickedView Then
                If xui.SubExists(mCallBack, mEventName & "_ItemClick", 1) Then
                    CallSub2(mCallBack, mEventName & "_ItemClick", itm.Id)
                End If
                Return
            End If
        End If
        If itm.EndBox <> Null Then
            If itm.EndBox = clickedView Then
                If xui.SubExists(mCallBack, mEventName & "_ItemClick", 1) Then
                    CallSub2(mCallBack, mEventName & "_ItemClick", itm.Id)
                End If
                Return
            End If
        End If
    Next
End Sub
#End Region

Private Sub LayoutItemContent(itm As TimelineItem, iStartHostW As Int, iEndHostW As Int, iStartHostH As Int, iEndHostH As Int)
    If msOrientation = "horizontal" Then
        If itm.StartLabel <> Null Then
            Dim lbl As B4XDaisyText = itm.StartLabel
            lbl.HAlign = "CENTER"
        End If
        If itm.EndLabel <> Null Then
            Dim lbl As B4XDaisyText = itm.EndLabel
            lbl.HAlign = "CENTER"
        End If
    Else
        If itm.StartLabel <> Null Then
            Dim lbl As B4XDaisyText = itm.StartLabel
            lbl.HAlign = "RIGHT"
        End If
        If itm.EndLabel <> Null Then
            Dim lbl As B4XDaisyText = itm.EndLabel
            lbl.HAlign = "LEFT"
        End If
    End If
    LayoutLabelInHost(itm.StartLabel, itm.StartLabelHost, iStartHostW, iStartHostH)
    LayoutLabelInHost(itm.EndLabel, itm.EndLabelHost, iEndHostW, iEndHostH)
End Sub

Private Sub LayoutLabelInHost(oLabelObj As Object, vHost As B4XView, iHostW As Int, iHostH As Int)
    If oLabelObj = Null Or vHost.IsInitialized = False Then Return
    Dim lbl As B4XDaisyText = oLabelObj
    Dim w As Int = Max(1dip, iHostW - LABEL_CONTENT_INSET * 2)
    Dim h As Int = Max(1dip, lbl.GetPreferredHeight(w))
    
    ' Only add to parent if not already there, otherwise just set layout
    ' This prevents the "duplicate text" issue during Resize/Refresh
    If lbl.mBase.Parent <> vHost Then
        Dim topOffset As Int = (iHostH - h) / 2
        lbl.AddToParent(vHost, LABEL_CONTENT_INSET, topOffset, w, h)
    Else
        lbl.mBase.SetLayoutAnimated(0, LABEL_CONTENT_INSET, (iHostH - h) / 2, w, h)
        lbl.Base_Resize(w, h)
    End If
End Sub

Private Sub LayoutItemIcon(itm As TimelineItem)
    If itm.MarkerIcon = Null Then Return
    Dim svg As B4XDaisySvgIcon = itm.MarkerIcon
    Dim iconSize As Int = Max(1dip, miMarkerSize - 8dip)
    Dim iconOffset As Int = Max(0dip, (miMarkerSize - iconSize) / 2)
    svg.View.SetLayoutAnimated(0, iconOffset, iconOffset, iconSize, iconSize)
    svg.Size = iconSize
    svg.View.BringToFront
End Sub

Private Sub BringMarkerToFront(itm As TimelineItem)
    If itm.MiddlePart.IsInitialized Then itm.MiddlePart.BringToFront
    If itm.MarkerIcon <> Null Then
        Dim svg As B4XDaisySvgIcon = itm.MarkerIcon
        If svg.View.IsInitialized Then svg.View.BringToFront
    End If
End Sub

Private Sub CalculateItemHeight(itm As TimelineItem, iWidth As Int) As Int
    Dim minHeight As Int = miMarkerSize + DEFAULT_PADDING * 2

    Dim startHostW As Int = ResolveContentHostWidth(itm, True, iWidth)
    Dim endHostW As Int = ResolveContentHostWidth(itm, False, iWidth)
    Dim startHostNeeded As Int = GetLabelRequiredHostHeight(itm.StartLabel, startHostW)
    Dim endHostNeeded As Int = GetLabelRequiredHostHeight(itm.EndLabel, endHostW)

    Dim contentHeight As Int = Max(startHostNeeded, endHostNeeded)
    If itm.StartBox.IsInitialized And startHostNeeded > 0 Then contentHeight = Max(contentHeight, startHostNeeded + DEFAULT_PADDING * 2)
    If itm.EndBox.IsInitialized And endHostNeeded > 0 Then contentHeight = Max(contentHeight, endHostNeeded + DEFAULT_PADDING * 2)
    contentHeight = Max(contentHeight, DEFAULT_PADDING * 2)

    Return Max(minHeight, contentHeight)
End Sub

Private Sub ResolveContentHostWidth(itm As TimelineItem, bIsStart As Boolean, iWidth As Int) As Int
    Dim centerTrack As Int = miMarkerSize + DEFAULT_PADDING * 2
    Dim sideTrack As Int = (iWidth - centerTrack) / 2
    If mbCompact Then
        If mbSnapIcon Then
            If bIsStart Then Return 0
            Dim centerX As Int = miMarkerSize / 2 + DEFAULT_PADDING
            Return Max(1dip, iWidth - (centerX + miMarkerSize / 2 + DEFAULT_PADDING * 2))
        Else
            If bIsStart = False Then Return 0
            Dim centerX As Int = 10dip + miMarkerSize / 2
            Return Max(1dip, centerX - miMarkerSize / 2 - DEFAULT_PADDING * 2)
        End If
    End If

    If bIsStart Then
        Return Max(1dip, sideTrack - 2 * DEFAULT_PADDING)
    Else
        Return Max(1dip, sideTrack - 2 * DEFAULT_PADDING)
    End If
End Sub

Private Sub GetLabelRequiredHostHeight(oLabelObj As Object, iHostWidth As Int) As Int
    If oLabelObj = Null Then Return 0
    If iHostWidth <= 0 Then Return 0
    Dim lbl As B4XDaisyText = oLabelObj
    Dim contentW As Int = Max(1dip, iHostWidth - LABEL_CONTENT_INSET * 2)
    Dim preferredTextH As Int = Max(1dip, lbl.GetPreferredHeight(contentW))
    Return preferredTextH + LABEL_CONTENT_INSET * 2
End Sub

Private Sub GetLabelRequiredHostWidth(oLabelObj As Object, iMaxHostWidth As Int) As Int
    If oLabelObj = Null Then Return 0
    If iMaxHostWidth <= 0 Then Return 0
    Dim lbl As B4XDaisyText = oLabelObj
    Dim w As Int = lbl.MeasureTextWidth
    Return Min(iMaxHostWidth, w + LABEL_CONTENT_INSET * 2)
End Sub


#End Region

#Region Cleanup
''' <summary>
''' Removes the component from its parent.
''' Returns the measured vertical content height (sum of item heights) from the last Refresh.
''' Use this to size the frame so the timeline does not scroll internally; the page scroll then reveals the rest.
Public Sub GetContentHeight As Int
	Return mContentHeight
End Sub

''' </summary>
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

#End Region
