B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#Event: ItemClick (Index As Int, Tag As Object)
#Event: ItemLongClick (Index As Int, Tag As Object)
#Event: CreateRowContent (Index As Int)
#Event: ReachEnd
#Event: ScrollChanged (Offset As Int)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 80%)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 300, Description: Viewport height in dip
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: base-100, Description: DaisyUI background color token
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: String, DefaultValue: , Description: DaisyUI text color token
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field, Description: Border radius mode
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: shadow-md, List: |none|shadow|shadow-md|shadow-lg|shadow-xl, Description: DaisyUI shadow class
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: 0, Description: Container padding in dip
#DesignerProperty: Key: RowPadding, DisplayName: Row Padding, FieldType: String, DefaultValue: 4, Description: Gap around row content in dip
#DesignerProperty: Key: RowGap, DisplayName: Row Gap, FieldType: String, DefaultValue: 4, Description: Gap between row items in dip
#DesignerProperty: Key: DividerColor, DisplayName: Divider Color, FieldType: String, DefaultValue: base-content/5, Description: Divider border color token
#DesignerProperty: Key: Divider, DisplayName: Show Divider, FieldType: Boolean, DefaultValue: True, Description: Show divider line between rows
#DesignerProperty: Key: RowHeight, DisplayName: Row Height, FieldType: Int, DefaultValue: 72, Description: Default row height in dip for recycling
#DesignerProperty: Key: AutoHeight, DisplayName: Auto-Height, FieldType: Boolean, DefaultValue: False, Description: Automatically resize list height to fit all rows

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' Internal xCustomListView engine (replaces hand-rolled ScrollView + recycling)
	Private clv As CustomListView
	Private miListWidth As Int = 0

	' Template system (DaisyList layer on top of xCLV)
	Private mTemplates As Map
	Private mCurrentRowPanel As B4XView
	Private mCurrentRowData As Map

	' Batch mode flag - suppresses VisibleRangeChanged during bulk adds
	Private mbBatchMode As Boolean = False

	' Designer property backing fields
	Private msBackgroundColor As String = "base-100"
	Private msTextColor As String = ""
	Private msRounded As String = "rounded-box"
	Private msShadow As String = "shadow-md"
	Private miPadding As Int = 0
	Private miRowPadding As Int = 4
	Private miRowGap As Int = 4
	Private msDividerColor As String = "base-content/5"
	Private mbShowDivider As Boolean = True
	Private mbEnabled As Boolean = True
	Private mbVisible As Boolean = True
	Private msWidth As String = "full"
	Private msHeight As String = "300"
	Private miDefaultRowHeight As Int = 72dip
	Private mbAutoHeight As Boolean = False
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	' Assign empty wrappers FIRST so .IsInitialized checks do not NPE.
	' Class_Globals fields default to Java null; calling .IsInitialized on
	' a null reference throws NullPointerException. After Dim empty As B4XView,
	' mBase becomes an uninitialized (but non-null) wrapper where
	' .IsInitialized safely returns False.
	Dim empty As B4XView
	mBase = empty
	mCurrentRowPanel = empty
	mCurrentRowData = Null
	miListWidth = 0
	If mTemplates.IsInitialized = False Then mTemplates.Initialize
	mbBatchMode = False
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	ApplyDesignerProps(mProps)
	SetupCustomListView
	ApplyStyles
	Base_Resize(mBase.Width, mBase.Height)
End Sub

'disable click events on child items
Private Sub DisableClickInterception(vRowPanel As B4XView)
    #If B4A
    ' Recursively pass touches through all components to the CLV row panel
    For Each v As B4XView In vRowPanel.GetAllViewsRecursive
        Dim jo As JavaObject = v
        jo.RunMethod("setClickable", Array(False))
    Next
    #End If
End Sub

Public Sub ResizeToFitContent
    If clv.IsInitialized = False Then Return
    
    ' 1. Get the actual total height of all rows inside the list
    Dim contentH As Int = clv.sv.ScrollViewContentHeight
    
    ' 2. Calculate the required height for the main wrapper (mBase)
    Dim targetH As Int = contentH + (miPadding * 2)
    
    ' 3. Update mBase height
    mBase.Height = targetH
    
    ' 4. Update the internal panel that houses the CustomListView (from our earlier fix)
    If mBase.NumberOfViews > 0 Then
        Dim innerPanel As B4XView = mBase.GetView(0)
        innerPanel.SetLayoutAnimated(0, miPadding, miPadding, mBase.Width - (miPadding * 2), contentH)
    End If
    
    ' 5. Notify the CustomListView of its new dimensions
    clv.Base_Resize(mBase.Width - (miPadding * 2), contentH)
End Sub

Private Sub SetupCustomListView
	Dim pad As Int = miPadding
	Dim viewW As Int = Max(1dip, mBase.Width - (pad * 2))
	Dim viewH As Int = Max(1dip, mBase.Height - (pad * 2))
	miListWidth = viewW

	' 1. Initialize the class
	clv.Initialize(Me, "clv")

	' 2. Create the base panel that will house the CustomListView
	Dim pnlBase As B4XView = xui.CreatePanel("")
	pnlBase.SetLayoutAnimated(0, 0, 0, viewW, viewH)
	pnlBase.Color = xui.Color_Transparent

	' 3. Create a dummy label so CLV can extract default text styling
	Dim dummyLbl As Label
	dummyLbl.Initialize("")
	Dim xDummy As B4XView = dummyLbl
	xDummy.TextColor = xui.Color_Black
	xDummy.TextSize = 14

	' 4. Construct the properties Map expected by DesignerCreateView
	Dim props As Map
	props.Initialize
	props.Put("ListOrientation", "Vertical")
	props.Put("DividerColor", xui.Color_Transparent) ' DaisyList handles its own dividers
	props.Put("DividerHeight", 0)
	props.Put("PressedColor", xui.Color_LightGray)
	props.Put("InsertAnimationDuration", 0)
	props.Put("ShowScrollBar", False)

	' 5. Force the internal view creation
	clv.DesignerCreateView(pnlBase, dummyLbl, props)

	' Disable internal animations
	clv.AnimationDuration = 0

	' 6. Add the now-initialized base panel to your host view instead of clv.AsView
	mBase.AddView(pnlBase, pad, pad, viewW, viewH)

    #If B4A
	Dim jo As JavaObject = clv.sv
	jo.RunMethod("setSaveEnabled", Array(False))
	ApplyScrollFix
    #End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim targetW As Int = Max(1dip, dWidth)
	Dim targetH As Int = Max(1dip, dHeight)
	targetW = ResolveWidthDip(targetW)
	targetH = ResolveHeightDip(targetH)
	If targetW <> mBase.Width Or targetH <> mBase.Height Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
	End If
	Dim pad As Int = miPadding
	Dim viewW As Int = Max(1dip, targetW - (pad * 2))
	Dim viewH As Int = Max(1dip, targetH - (pad * 2))
	miListWidth = viewW
	clv.AsView.SetLayoutAnimated(0, pad, pad, viewW, viewH)
	clv.Base_Resize(viewW, viewH)
	inResize = False
End Sub
' - xCLV Event Handlers -

Private Sub clv_VisibleRangeChanged(iFirstIndex As Int, iLastIndex As Int)
	If mbBatchMode Then Return
	If iFirstIndex > 0 And iFirstIndex = iLastIndex Then Return
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	Dim ExtraSize As Int = 5
	Dim fromIdx As Int = Max(0, iFirstIndex - ExtraSize)
	Dim toIdx As Int = Min(clv.Size - 1, iLastIndex + ExtraSize)
	For i = fromIdx To toIdx
		Dim pnl As B4XView = clv.GetPanel(i)
		If pnl = Null Then Continue
		If pnl.IsInitialized = False Then Continue
		If pnl.NumberOfViews = 0 Then
			PopulateRowPanel(pnl, i)
		End If
	Next
End Sub

Private Sub clv_ItemClick(iIndex As Int, oValue As Object)
	If oValue = Null Then Return
	Dim rowData As Map = oValue
	Dim payload As Object = rowData.GetDefault("Tag", Null)
	RaiseEvent(mEventName & "_ItemClick", iIndex, payload)
End Sub

Private Sub clv_ItemLongClick(iIndex As Int, oValue As Object)
	If oValue = Null Then Return
	Dim rowData As Map = oValue
	Dim payload As Object = rowData.GetDefault("Tag", Null)
	RaiseEvent(mEventName & "_ItemLongClick", iIndex, payload)
End Sub

Private Sub clv_ReachEnd
	RaiseEvent0(mEventName & "_ReachEnd")
End Sub

Private Sub clv_ScrollChanged(iOffset As Int)
	RaiseEvent1(mEventName & "_ScrollChanged", iOffset)
End Sub

' - Row Population -

Private Sub PopulateRowPanel(vView As B4XView, iIndex As Int)
	Dim rowValue As Object = clv.GetValue(iIndex)
	If rowValue = Null Then Return
	Dim rowData As Map = rowValue
	If rowData.IsInitialized = False Then Return
	Dim innerData As Map = rowData.GetDefault("Data", rowData)
	If innerData = Null Then innerData = rowData
	mCurrentRowPanel = vView
	mCurrentRowData = innerData
	Dim templateName As String = rowData.GetDefault("_template", "")
	If templateName.Length > 0 And mTemplates.ContainsKey(templateName) Then
		Dim tpl As Map = mTemplates.Get(templateName)
		Dim callback As Object = tpl.Get("callback")
		Dim eventName As String = tpl.Get("event")
		If xui.SubExists(callback, eventName, 1) Then
			CallSub2(callback, eventName, iIndex)
		End If
	Else If xui.SubExists(mCallBack, mEventName & "_CreateRowContent", 1) Then
		CallSub2(mCallBack, mEventName & "_CreateRowContent", iIndex)
	End If
	If mbShowDivider And iIndex < clv.Size - 1 Then
		AddDividerToPanel(vView)
	End If
End Sub

Private Sub AddDividerToPanel(vView As B4XView)
	Dim inset As Int = B4XDaisyVariants.GetRadiusBoxDip(8dip)
	Dim lineW As Float = Max(1dip, vView.Width - (inset * 2))
	Dim lineY As Float = Max(0, vView.Height - 1dip)
	Dim baseDividerColor As Int = B4XDaisyVariants.ResolveBorderColorVariant(msDividerColor, xui.Color_ARGB(13, 0, 0, 0))
	Dim lineColor As Int = B4XDaisyVariants.SetAlpha(baseDividerColor, 22)
	Dim div As B4XView = xui.CreatePanel("")
	div.Color = lineColor
	vView.AddView(div, inset, lineY, lineW, 1dip)
End Sub

' - Public API - Template System -

Public Sub RegisterTemplate(sTemplateName As String, oCallback As Object, sEventName As String)
	If mTemplates.IsInitialized = False Then mTemplates.Initialize
	mTemplates.Put(sTemplateName.ToLowerCase, CreateMap("callback": oCallback, "event": sEventName))
End Sub

Public Sub AddRowDataWithTemplate(mData As Map, sTemplateName As String) As Int
	If clv = Null Then Return -1
	If clv.IsInitialized = False Then Return -1
	If mData.IsInitialized = False Then mData.Initialize
	Dim rowH As Int = mData.GetDefault("_height", miDefaultRowHeight / 1dip) * 1dip
	If rowH <= 0 Then rowH = miDefaultRowHeight
	Dim rowData As Map = CreateMap("Tag": mData.GetDefault("Tag", Null), "Data": mData, "_template": sTemplateName.ToLowerCase, "_height": rowH)
	Dim pnl As B4XView = xui.CreatePanel("")
	Dim itemW As Int = GetItemWidth
	pnl.SetLayoutAnimated(0, 0, 0, itemW, rowH)
	pnl.Color = xui.Color_Transparent
	clv.Add(pnl, rowData)
	If clv <> Null And clv.IsInitialized Then clv.Refresh
	If mbAutoHeight Then ResizeToFitContent
	Return clv.Size - 1
End Sub

' - Public API - Row Data (Primary) -

Public Sub AddRowData(mData As Map) As Int
	If clv = Null Then Return -1
	If clv.IsInitialized = False Then Return -1
	If mData.IsInitialized = False Then mData.Initialize
	Dim rowH As Int = mData.GetDefault("_height", miDefaultRowHeight / 1dip) * 1dip
	If rowH <= 0 Then rowH = miDefaultRowHeight
	Dim rowData As Map = CreateMap("Tag": mData.GetDefault("Tag", Null), "Data": mData, "_template": "", "_height": rowH)
	Dim pnl As B4XView = xui.CreatePanel("")
	Dim itemW As Int = GetItemWidth
	pnl.SetLayoutAnimated(0, 0, 0, itemW, rowH)
	pnl.Color = xui.Color_Transparent
	clv.Add(pnl, rowData)
	If clv <> Null And clv.IsInitialized Then clv.Refresh
	If mbAutoHeight Then ResizeToFitContent
	Return clv.Size - 1
End Sub

Public Sub AddHeader(sTitle As String) As Int
	Dim data As Map = CreateMap("Tag": sTitle, "_header": True, "title": sTitle, "_height": 40dip / 1dip)
	Return AddRowDataWithTemplate(data, "")
End Sub

Public Sub AddRowDataBatch(lstItems As List)
	If lstItems.IsInitialized = False Then Return
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	mbBatchMode = True
	For Each item As Map In lstItems
		If item.IsInitialized = False Then Continue
		Dim rowH As Int = item.GetDefault("_height", miDefaultRowHeight / 1dip) * 1dip
		If rowH <= 0 Then rowH = miDefaultRowHeight
		Dim tplName As String = item.GetDefault("_template", "")
		tplName = tplName.tolowercase
		Dim rowData As Map = CreateMap("Tag": item.GetDefault("Tag", Null), "Data": item, "_template": tplName, "_height": rowH)
		Dim pnl As B4XView = xui.CreatePanel("")
		Dim itemW As Int = GetItemWidth
		pnl.SetLayoutAnimated(0, 0, 0, itemW, rowH)
		pnl.Color = xui.Color_Transparent
		clv.Add(pnl, rowData)
	Next
	mbBatchMode = False
	clv.Refresh
	If mbAutoHeight Then ResizeToFitContent
End Sub

Public Sub SetRowCount(iCount As Int)
	Clear
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	mbBatchMode = True
	For i = 0 To iCount - 1
		Dim rowData As Map = CreateMap("Tag": Null, "Data": Null, "_template": "", "_height": miDefaultRowHeight)
		Dim pnl As B4XView = xui.CreatePanel("")
		Dim itemW As Int = GetItemWidth
		pnl.SetLayoutAnimated(0, 0, 0, itemW, miDefaultRowHeight)
		pnl.Color = xui.Color_Transparent
		clv.Add(pnl, rowData)
	Next
	mbBatchMode = False
	clv.Refresh
	If mbAutoHeight Then ResizeToFitContent
End Sub
' - Public API - Legacy Row -

Public Sub AddRow(mData As Map) As Int
	Dim items As List = mData.Get("items")
	If items.IsInitialized = False Then items.Initialize
	Dim colGrow As Int = mData.GetDefault("colGrow", 0)
	If colGrow > 0 Then
		If colGrow <= items.Size Then
			Dim growItem As Map = items.Get(colGrow - 1)
			growItem.Put("grow", True)
		End If
	End If
	For i = 0 To items.Size - 1
		Dim item As Map = items.Get(i)
		item.Put("grow", item.GetDefault("grow", False))
		item.Put("wrap", item.GetDefault("wrap", False))
	Next
	Dim rowH As Int = mData.GetDefault("height", miDefaultRowHeight)
	If rowH <= 0 Then rowH = miDefaultRowHeight
	Dim rowData As Map = CreateMap("items": items, "height": rowH, "Tag": mData.GetDefault("Tag", Null), "colGrow": colGrow, "colWrap": mData.GetDefault("colWrap", False), "Data": mData, "_template": "", "_height": rowH)
	If clv = Null Then Return -1
	If clv.IsInitialized = False Then Return -1
	Dim pnl As B4XView = xui.CreatePanel("")
	Dim itemW As Int = GetItemWidth
	pnl.SetLayoutAnimated(0, 0, 0, itemW, rowH)
	pnl.Color = xui.Color_Transparent
	clv.Add(pnl, rowData)
	If clv <> Null And clv.IsInitialized Then clv.Refresh
	If mbAutoHeight Then ResizeToFitContent
	Return clv.Size - 1
End Sub

' - Public API - Data Access -

Public Sub Clear
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	clv.Clear
	Dim empty As B4XView
	mCurrentRowPanel = empty
	mCurrentRowData = Null
	mbBatchMode = False
End Sub

Public Sub getRowCount As Int
	If clv = Null Then Return 0
	If clv.IsInitialized = False Then Return 0
	Return clv.Size
End Sub

Public Sub GetRowData(iIndex As Int) As Map
	If clv = Null Then Return Null
	If clv.IsInitialized = False Then Return Null
	If iIndex < 0 Or iIndex >= clv.Size Then Return Null
	Dim rowValue As Object = clv.GetValue(iIndex)
	If rowValue = Null Then Return Null
	Dim rowData As Map = rowValue
	Return rowData.GetDefault("Data", rowData)
End Sub

Public Sub GetRow(iIndex As Int) As Map
	If clv = Null Then Return Null
	If clv.IsInitialized = False Then Return Null
	If iIndex < 0 Or iIndex >= clv.Size Then Return Null
	Dim rowValue As Object = clv.GetValue(iIndex)
	If rowValue = Null Then Return Null
	Return clv.GetValue(iIndex)
End Sub

Public Sub RemoveRow(iIndex As Int)
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	If iIndex < 0 Or iIndex >= clv.Size Then Return
	clv.RemoveAt(iIndex)
	If mbAutoHeight Then ResizeToFitContent
End Sub

Public Sub InsertRowAt(iIndex As Int, mData As Map)
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	If mData.IsInitialized = False Then mData.Initialize
	Dim rowH As Int = mData.GetDefault("_height", miDefaultRowHeight / 1dip) * 1dip
	If rowH <= 0 Then rowH = miDefaultRowHeight
	Dim tplName As String = mData.GetDefault("_template", "")
	tplName = tplName.tolowercase
	Dim rowData As Map = CreateMap("Tag": mData.GetDefault("Tag", Null), "Data": mData, "_template": tplName, "_height": rowH)
	Dim pnl As B4XView = xui.CreatePanel("")
	Dim itemW As Int = GetItemWidth
	pnl.SetLayoutAnimated(0, 0, 0, itemW, rowH)
	pnl.Color = xui.Color_Transparent
	clv.InsertAt(iIndex, pnl, rowData)
	If clv <> Null And clv.IsInitialized Then clv.Refresh
	If mbAutoHeight Then ResizeToFitContent
End Sub

Public Sub RefreshRow(iIndex As Int)
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	If iIndex < 0 Or iIndex >= clv.Size Then Return
	Dim pnl As B4XView = clv.GetPanel(iIndex)
	If pnl = Null Then Return
	If pnl.IsInitialized Then
		If pnl.NumberOfViews > 0 Then pnl.RemoveAllViews
		PopulateRowPanel(pnl, iIndex)
	End If
End Sub

Public Sub RefreshAllRows
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	For i = 0 To clv.Size - 1
		Dim pnl As B4XView = clv.GetPanel(i)
		If pnl = Null Then Continue
		If pnl.IsInitialized Then
			If pnl.NumberOfViews > 0 Then pnl.RemoveAllViews
		End If
	Next
	clv.Refresh
End Sub

Public Sub ScrollToIndex(iIndex As Int)
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	If iIndex < 0 Or iIndex >= clv.Size Then Return
	clv.JumpToItem(iIndex)
End Sub

Public Sub SmoothScrollToIndex(iIndex As Int)
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	If iIndex < 0 Or iIndex >= clv.Size Then Return
	clv.ScrollToItem(iIndex)
End Sub

Public Sub getScrollPosition As Int
	If clv = Null Then Return 0
	If clv.IsInitialized = False Then Return 0
	Try
		Dim jo As JavaObject = clv.sv
		Return jo.RunMethod("getScrollY", Null)
	Catch
		Return 0
	End Try
End Sub

Public Sub getFirstVisibleIndex As Int
	If clv = Null Then Return -1
	If clv.IsInitialized = False Then Return -1
	Return clv.FirstVisibleIndex
End Sub

Public Sub getLastVisibleIndex As Int
	If clv = Null Then Return -1
	If clv.IsInitialized = False Then Return -1
	Return clv.LastVisibleIndex
End Sub

Public Sub GetItemFromView(vView As B4XView) As Int
	If clv = Null Then Return -1
	If clv.IsInitialized = False Then Return -1
	Return clv.GetItemFromView(vView)
End Sub

' - Internal Helpers -

Private Sub GetItemWidth As Int
	Dim w As Int = miListWidth
	If w <= 0 Then
		If clv <> Null And clv.IsInitialized Then w = clv.AsView.Width
	End If
	If w <= 0 Then
		If mBase <> Null And mBase.IsInitialized Then w = mBase.Width - (miPadding * 2)
	End If
	Return Max(1dip, w)
End Sub

Private Sub RaiseEvent(sEventName As String, iIndex As Int, oTag As Object)
	If xui.SubExists(mCallBack, sEventName, 2) Then
		CallSub3(mCallBack, sEventName, iIndex, oTag)
	End If
End Sub

Private Sub RaiseEvent0(sEventName As String)
	If xui.SubExists(mCallBack, sEventName, 0) Then
		CallSub(mCallBack, sEventName)
	End If
End Sub

Private Sub RaiseEvent1(sEventName As String, oArg1 As Object)
	If xui.SubExists(mCallBack, sEventName, 1) Then
		CallSub2(mCallBack, sEventName, oArg1)
	End If
End Sub

Private Sub NormalizeSizeSpec(sValue As String, sDefaultValue As String) As String
	If sValue = Null Then Return sDefaultValue
	Dim s As String = sValue.Trim.ToLowerCase
	If s.Length = 0 Then Return sDefaultValue
	If s = "w-full" Then Return "full"
	If s = "h-auto" Then Return "auto"
	Return s
End Sub

Private Sub ResolveWidthDip(iFallback As Int) As Int
	Dim parentW As Int = iFallback
	If mBase <> Null And mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent <> Null And parent.IsInitialized Then parentW = Max(1dip, parent.Width - mBase.Left)
	End If
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msWidth, parentW))
End Sub

Private Sub ResolveHeightDip(iFallback As Int) As Int
	Dim parentH As Int = iFallback
	If mBase <> Null And mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent <> Null And parent.IsInitialized Then parentH = Max(1dip, parent.Height - mBase.Top)
	End If
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(msHeight, parentH))
End Sub
' - Properties -

Public Sub setBackgroundColor(sValue As String)
	msBackgroundColor = sValue
	ApplyStyles
End Sub
Public Sub getBackgroundColor As String
	Return msBackgroundColor
End Sub

Public Sub setTextColor(sValue As String)
	msTextColor = sValue
	RefreshAllRows
End Sub
Public Sub getTextColor As String
	Return msTextColor
End Sub

Public Sub setRounded(sValue As String)
	msRounded = NormalizeRounded(sValue)
	ApplyStyles
End Sub
Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
		msRounded = "rounded-box"
	Else
		msRounded = "rounded-none"
	End If
	ApplyStyles
End Sub
Public Sub getRoundedBox As Boolean
	Return msRounded <> "rounded-none"
End Sub

Public Sub setShadow(sValue As String)
	msShadow = sValue
	ApplyStyles
End Sub
Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setPadding(iValue As Int)
	miPadding = iValue
	If mBase <> Null And mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub
Public Sub getPadding As Int
	Return miPadding
End Sub

Public Sub setRowPadding(iValue As Int)
	miRowPadding = iValue
	RefreshAllRows
End Sub
Public Sub getRowPadding As Int
	Return miRowPadding
End Sub

Public Sub setRowGap(iValue As Int)
	miRowGap = iValue
	RefreshAllRows
End Sub
Public Sub getRowGap As Int
	Return miRowGap
End Sub

Public Sub setDivider(bValue As Boolean)
	mbShowDivider = bValue
	RefreshAllRows
End Sub
Public Sub getDivider As Boolean
	Return mbShowDivider
End Sub

Public Sub setDividerColor(sValue As String)
	msDividerColor = sValue
	RefreshAllRows
End Sub
Public Sub getDividerColor As String
	Return msDividerColor
End Sub

Public Sub setEnabled(bValue As Boolean)
	mbEnabled = bValue
	ApplyInteractionState
End Sub
Public Sub getEnabled As Boolean
	Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
	mbVisible = bValue
	ApplyInteractionState
End Sub
Public Sub getVisible As Boolean
	Return mbVisible
End Sub

Public Sub setRowHeight(iValue As Int)
	miDefaultRowHeight = Max(1dip, iValue)
End Sub
Public Sub getRowHeight As Int
	Return miDefaultRowHeight
End Sub

Public Sub setWidth(oValue As Object)
	msWidth = NormalizeSizeSpec(B4XDaisyVariants.NormalizeSizeSpec(oValue, "full"), "full")
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	Dim w As Int = ResolveWidthDip(mBase.Width)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, mBase.Height)
	Base_Resize(w, mBase.Height)
End Sub
Public Sub getWidth As Int
	If mBase <> Null And mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(oValue As Object)
	msHeight = NormalizeSizeSpec(B4XDaisyVariants.NormalizeSizeSpec(oValue, "300"), "300")
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	Dim h As Int = ResolveHeightDip(mBase.Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, mBase.Width, h)
	Base_Resize(mBase.Width, h)
End Sub
Public Sub getHeight As Int
	If mBase <> Null And mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub getContentHeight As Int
	If clv = Null Then Return 0
	If clv.IsInitialized = False Then Return 0
	If clv.Size = 0 Then Return Max(1dip, miPadding * 2)
	Try
		Dim lastItem As CLVItem = clv.GetRawListItem(clv.Size - 1)
		Return Max(1dip, lastItem.Offset + lastItem.Size + (miPadding * 2))
	Catch
		Return Max(1dip, miPadding * 2)
	End Try
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub
Public Sub getTag As Object
	Return mTag
End Sub
' - AddToParent -

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent = Null Then Return empty
	If vParent.IsInitialized = False Then Return empty
	Dim widthSpec As String = msWidth
	Dim heightSpec As String = msHeight
	If iWidth > 0 Then widthSpec = B4XDaisyVariants.ResolvePxSizeSpec(iWidth)
	If iHeight > 0 Then heightSpec = B4XDaisyVariants.ResolvePxSizeSpec(iHeight)
	Dim widthBase As Int = Max(1dip, vParent.Width - iLeft)
	Dim heightBase As Int = Max(1dip, vParent.Height - iTop)
	Dim targetW As Int = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(widthSpec, widthBase))
	Dim targetH As Int
	If iHeight > 0 Then
		targetH = iHeight
	Else
		targetH = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(heightSpec, heightBase))
	End If
	Dim p As Panel
	p.Initialize("")
	mBase = p
	vParent.AddView(mBase, iLeft, iTop, targetW, targetH)
	Dim props As Map = BuildRuntimeProps(targetW, targetH)
	Dim dummy As Label
	dummy.Initialize("")
	DesignerCreateView(mBase, dummy, props)
	Return mBase
End Sub

' - Styling -

Private Sub ApplyStyles
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	Dim bgColor As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundColor, xui.Color_White)
	mBase.Color = bgColor
	Dim radius As Float = B4XDaisyVariants.ResolveRoundedDip(msRounded, B4XDaisyVariants.GetRadiusBoxDip(8dip))
	mBase.SetColorAndBorder(bgColor, 0, xui.Color_Transparent, radius)
	Dim shadowToken As String = NormalizeShadowToken(msShadow)
	B4XDaisyVariants.ApplyElevation(mBase, shadowToken)
	ApplyInteractionState
	B4XDaisyVariants.DisableClipping(mBase)
End Sub

Private Sub ApplyInteractionState
	If mBase = Null Then Return
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mbVisible
	mBase.Enabled = mbEnabled
End Sub

Private Sub NormalizeRounded(sValue As String) As String
	If sValue = Null Then Return "rounded-box"
	Dim s As String = sValue.Trim.ToLowerCase
	Select Case s
		Case "", "theme", "box", "rounded-box"
			Return "rounded-box"
		Case "none", "rounded-none"
			Return "rounded-none"
		Case "sm", "rounded-sm"
			Return "rounded-sm"
		Case "default", "rounded"
			Return "rounded"
		Case "md", "rounded-md"
			Return "rounded-md"
		Case "lg", "rounded-lg"
			Return "rounded-lg"
		Case "xl", "rounded-xl"
			Return "rounded-xl"
		Case "2xl", "rounded-2xl"
			Return "rounded-2xl"
		Case "3xl", "rounded-3xl"
			Return "rounded-3xl"
		Case "full", "rounded-full"
			Return "rounded-full"
		Case "field", "rounded-field"
			Return "rounded-field"
		Case "selector", "rounded-selector"
			Return "rounded-selector"
		Case Else
			Return "rounded-box"
	End Select
End Sub

Private Sub NormalizeShadowToken(sValue As String) As String
	If sValue = Null Then Return "none"
	Dim v As String = sValue.Trim.ToLowerCase
	Select Case v
		Case "shadow": Return "sm"
		Case "shadow-sm": Return "sm"
		Case "shadow-md": Return "md"
		Case "shadow-lg": Return "lg"
		Case "shadow-xl": Return "xl"
		Case "shadow-2xl": Return "2xl"
		Case "none", "": Return "none"
		Case Else: Return "none"
	End Select
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	msBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "BackgroundColor", msBackgroundColor)
	msTextColor = B4XDaisyVariants.GetPropString(mProps, "TextColor", msTextColor)
	msRounded = NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
	msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow)
	miPadding = B4XDaisyVariants.GetPropInt(mProps, "Padding", miPadding)
	miRowPadding = B4XDaisyVariants.GetPropInt(mProps, "RowPadding", miRowPadding)
	miRowGap = B4XDaisyVariants.GetPropInt(mProps, "RowGap", miRowGap)
	msDividerColor = B4XDaisyVariants.GetPropString(mProps, "DividerColor", msDividerColor)
	mbShowDivider = B4XDaisyVariants.GetPropBool(mProps, "Divider", mbShowDivider)
	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
	miDefaultRowHeight = B4XDaisyVariants.GetPropInt(mProps, "RowHeight", 72) * 1dip
	mbAutoHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoHeight", mbAutoHeight)
	msWidth = NormalizeSizeSpec(B4XDaisyVariants.GetPropString(mProps, "Width", msWidth), "full")
	msHeight = NormalizeSizeSpec(B4XDaisyVariants.GetPropString(mProps, "Height", msHeight), "300")
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("BackgroundColor", msBackgroundColor)
	props.Put("TextColor", msTextColor)
	props.Put("Rounded", msRounded)
	props.Put("Shadow", msShadow)
	props.Put("Padding", miPadding)
	props.Put("RowPadding", miRowPadding)
	props.Put("RowGap", miRowGap)
	props.Put("DividerColor", msDividerColor)
	props.Put("Divider", mbShowDivider)
	props.Put("Enabled", mbEnabled)
	props.Put("Visible", mbVisible)
	props.Put("RowHeight", miDefaultRowHeight / 1dip)
	props.Put("AutoHeight", mbAutoHeight)
	Return props
End Sub

Public Sub UpdateTheme
	ApplyStyles
	RefreshAllRows
End Sub

Public Sub Refresh
	ApplyStyles
	If clv <> Null And clv.IsInitialized Then clv.Refresh
End Sub

Public Sub GetComputedHeight As Int
	If mBase = Null Then Return 0
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

''' When True, automatically resizes the list height to fit all rows.
''' When False (default), the list uses the designer-specified height.
Public Sub setAutoHeight(bValue As Boolean)
	mbAutoHeight = bValue
	If mbAutoHeight And mBase <> Null And mBase.IsInitialized Then
		ResizeToFitContent
	End If
End Sub

''' Gets whether the list automatically resizes to fit content.
Public Sub getAutoHeight As Boolean
	Return mbAutoHeight
End Sub

Public Sub RemoveViewFromParent
	If mBase <> Null And mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub Release
	If clv <> Null And clv.IsInitialized Then clv.Clear
	mCallBack = Null
	If mTemplates.IsInitialized Then mTemplates.Clear
	Dim empty As B4XView
	mCurrentRowPanel = empty
	mCurrentRowData = Null
End Sub

' - Current Row Context (for template/event callbacks) -

Public Sub GetCurrentRowPanel As B4XView
	Return mCurrentRowPanel
End Sub

Public Sub GetCurrentRowData As Map
	Return mCurrentRowData
End Sub

' - Convenience -

Public Sub AddTextRow(sTitle As String, sOptionalSubtitle As String) As Int
	Dim data As Map = CreateMap("Tag": sTitle, "title": sTitle, "subtitle": sOptionalSubtitle)
	Return AddRowData(data)
End Sub

Public Sub CreateTextItemView(sText As String, iWidth As Int, iHeight As Int, oTextSize As Object, iTextColor As Int, bBold As Boolean, bSingleLine As Boolean) As B4XView
	Dim t As B4XDaisyText
	t.Initialize(Me, "")
	Dim v As B4XView = t.CreateView(Max(1dip, iWidth), Max(1dip, iHeight))
	t.Text = sText
	t.TextSize = oTextSize
	t.TextColor = iTextColor
	t.FontBold = bBold
	t.SingleLine = bSingleLine
	Return v
End Sub

Public Sub CreateStackedTextView(sTitle As String, sSubtitle As String, iWidth As Int, oTitleSize As Object, oSubtitleSize As Object, iTitleColor As Int, iSubtitleColor As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim host As B4XView = p
	Dim totalH As Int = 36dip
	host.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), totalH)
	host.Color = xui.Color_Transparent
	Dim topView As B4XView = CreateTextItemView(sTitle, iWidth, 20dip, oTitleSize, iTitleColor, False, True)
	host.AddView(topView, 0, 0, iWidth, 20dip)
	Dim bottomView As B4XView = CreateTextItemView(sSubtitle, iWidth, 16dip, oSubtitleSize, iSubtitleColor, False, True)
	host.AddView(bottomView, 0, 20dip, iWidth, 16dip)
	Return host
End Sub

' - xCLV Direct Access -

Public Sub GetCLV As CustomListView
	Return clv
End Sub
#Region ScrollFix
    #If B4A
Private Sub ApplyScrollFix
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	Try
		Dim svView As B4XView = clv.sv
		If svView = Null Then Return
		If svView.IsInitialized = False Then Return
		Dim joSV As JavaObject = svView
		joSV.RunMethod("setOnTouchListener", Array(joSV.CreateEvent("android.view.View$OnTouchListener", "clvTouch", False)))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyList.ApplyScrollFix: " & LastException.Message)
		' View may not be attached yet
	End Try
End Sub

Private Sub clvTouch_Event(sMethodName As String, oArgs() As Object) As Object
	If sMethodName = "onTouch" Then
		Dim motionEvent As JavaObject = oArgs(1)
		Dim Action As Int = motionEvent.RunMethod("getAction", Null)
		If Action = 0 Or Action = 2 Then
			RequestDisallowInterceptOnAncestors
		End If
	End If
	Return False
End Sub

Private Sub RequestDisallowInterceptOnAncestors
	If clv = Null Then Return
	If clv.IsInitialized = False Then Return
	Dim svView As B4XView = clv.sv
	If svView = Null Then Return
	If svView.IsInitialized = False Then Return
	Dim current As JavaObject = svView
	Do While current.IsInitialized
		Dim parentView As JavaObject
		Try
			parentView = current.RunMethod("getParent", Null)
		Catch
			Exit
		End Try
		If parentView.IsInitialized = False Then Exit
		Dim isInternal As Boolean = False
		If IsSameViewSafe(parentView, svView) Then isInternal = True
		If mBase <> Null And mBase.IsInitialized Then
			If IsSameViewSafe(parentView, mBase) Then isInternal = True
		End If
		If isInternal = False Then
			Try
				parentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisyList.RequestDisallowInterceptOnAncestors: " & LastException.Message)
			End Try
		End If
		Try
			Dim parentClass As String = GetType(parentView)
			If parentClass.Contains("ViewRootImpl") Then Exit
		Catch
			Exit
		End Try
		current = parentView
	Loop
End Sub

Private Sub IsSameViewSafe(joView1 As JavaObject, vView2 As B4XView) As Boolean
	Try
		If vView2 = Null Then Return False
		If vView2.IsInitialized = False Then Return False
		Dim id1 As Int = joView1.RunMethod("hashCode", Null)
		Dim jo2 As JavaObject = vView2
		Dim id2 As Int = jo2.RunMethod("hashCode", Null)
		Return id1 = id2
	Catch
		Return False
	End Try
End Sub
    #End If
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
