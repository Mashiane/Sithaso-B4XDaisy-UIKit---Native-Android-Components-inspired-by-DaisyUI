B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: LayoutChanged (ContentHeight As Float)
#Event: ItemPlaced (Info As Map)
#Event: BeforePlace (Key As String, Info As Map)
#Event: AfterPlace (Key As String, Info As Map)
#Event: LayoutDiff (Changes As List)

#DesignerProperty: Key: ClassName, DisplayName: Class Name, FieldType: String, DefaultValue: grid grid-cols-1 gap-4, Description: Tailwind-like grid utility string
#DesignerProperty: Key: Cols, DisplayName: Columns, FieldType: Int, DefaultValue: 1, MinRange: 1, MaxRange: 24, Description: Fallback columns when no class token is set
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: String, DefaultValue: 4, Description: Tailwind spacing token or CSS/dip value
#DesignerProperty: Key: GapX, DisplayName: Gap X, FieldType: String, DefaultValue:, Description: Optional horizontal gap override
#DesignerProperty: Key: GapY, DisplayName: Gap Y, FieldType: String, DefaultValue:, Description: Optional vertical gap override
#DesignerProperty: Key: AutoRows, DisplayName: Auto Rows Height, FieldType: String, DefaultValue: minmax(72dip, auto), Description: Grid auto-rows template
#DesignerProperty: Key: TemplateRows, DisplayName: Template Rows, FieldType: String, DefaultValue:, Description: Explicit row template (e.g., "100dip 1fr 200dip")
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: 0, Description: Padding shorthand
#DesignerProperty: Key: Dense, DisplayName: Dense Packing, FieldType: Boolean, DefaultValue: False, Description: Enable dense packing algorithm
#DesignerProperty: Key: Debug, DisplayName: Debug, FieldType: Boolean, DefaultValue: False, Description: Enable debug logging
#DesignerProperty: Key: DebugOverlay, DisplayName: Debug Overlay, FieldType: Boolean, DefaultValue: False, Description: Draw grid lines and labels
#DesignerProperty: Key: AutoRegisterChildrenFromTag, DisplayName: Auto Register Children From Tag, FieldType: Boolean, DefaultValue: False, Description: Register child views using Tag metadata
#DesignerProperty: Key: EmitLayoutDiff, DisplayName: Emit Layout Diff, FieldType: Boolean, DefaultValue: False, Description: Raise LayoutDiff event with changed items
#DesignerProperty: Key: DefaultAnimMs, DisplayName: Default Anim Ms, FieldType: Int, DefaultValue: 0, MinRange: 0, MaxRange: 2000, Description: Default placement animation in ms

#IgnoreWarnings:12,9
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mLbl As B4XView

    ' Core grid properties
    Private mClassName As String = "grid grid-cols-1 gap-4"
    Private mColsFallback As Int = 1
    Private mGapFallback As Float = 16dip
    Private mGapXFallback As Float = -1
    Private mGapYFallback As Float = -1
    Private mAutoRowsTemplate As String = "minmax(72dip, auto)"
    Private mTemplateRows As String = ""
    Private mPaddingAll As Float = 0
    Private mDense As Boolean = False
    Private mDebug As Boolean = False
    Private mDebugOverlay As Boolean = False
    Private mAutoRegisterChildrenFromTag As Boolean = False
    Private mEmitLayoutDiff As Boolean = False
    Private mDefaultAnimMs As Int = 0

    ' Breakpoints (mobile-first order)
    Private mBreakpoints As Map
    Private mSortedBreakpointsCache As List

    ' Grid state
    Private mItems As List
    Private mItemByKey As Map
    Private mPlacementByKey As Map
    Private mGridCells As List ' 2D array of occupied cells

    ' Parser cache
    Private mParsedContainerBase As Map
    Private mParsedContainerBp As Map
    Private mContainerClassDirty As Boolean = True

    ' Batch updates
    Private mIsUpdating As Boolean = False
    Private mPendingRelayout As Boolean = False

    ' Internal tracking
    Private mInternalKeyCounter As Int = 0
    Private mLastCollisionDiagnostics As List
    Private mLastActiveBreakpoint As String = ""
    Private mLastLayoutSnapshotByKey As Map
    Private mLastResolvedConfig As GridResolvedConfig
    Private mRowHeights As List ' Calculated row heights
    Private mColumnWidths As List ' Calculated column widths
    
    Type GridResolvedConfig (Cols As Int, GapX As Float, GapY As Float, PadL As Float, PadT As Float, PadR As Float, PadB As Float, AutoRowsTemplate As String, AutoColsTemplate As String, TemplateRows As String, Dense As Boolean, GridFlow As String, JustifyItems As String, AlignItems As String)
    Type GridItemResolved (ColSpan As Int, RowSpan As Int, ColStart As Int, RowStart As Int, ColEnd As Int, RowEnd As Int, Order As Int, Hidden As Boolean, JustifySelf As String, AlignSelf As String)
    Type GridPlacement (Col As Int, Row As Int, ColSpan As Int, RowSpan As Int, X As Float, Y As Float, W As Float, H As Float)
    Type GridItemSpec (Key As String, ClassText As String, Visible As Boolean, Order As Int)
    Type GridDiagCollision (Key As String, RequestedCol As Int, RequestedRow As Int, RequestedColSpan As Int, RequestedRowSpan As Int, FallbackCol As Int, FallbackRow As Int, Reason As String)
    Type GridTrackSize (IsFr As Boolean, Value As Float, fMin As Float, fMax As Float)

    ' Debug overlay
    Private mDebugOverlayPanel As B4XView
	Private inResize As Boolean = False
End Sub

' -
' Init / Designer
' -
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName

    ' Initialize breakpoints (mobile-first order)
    mBreakpoints.Initialize
    mBreakpoints.Put("sm", 640dip)
    mBreakpoints.Put("md", 768dip)
    mBreakpoints.Put("lg", 1024dip)
    mBreakpoints.Put("xl", 1280dip)
    mBreakpoints.Put("2xl", 1536dip)

    RebuildBreakpointsCache

    mItems.Initialize
    mItemByKey.Initialize
    mPlacementByKey.Initialize
    mGridCells.Initialize
    mRowHeights.Initialize
    mColumnWidths.Initialize

    mParsedContainerBase.Initialize
    mParsedContainerBp.Initialize

    mLastCollisionDiagnostics.Initialize
    mLastLayoutSnapshotByKey.Initialize
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub getIsInitialized As Boolean
    Return mBase.IsInitialized
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

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    ' the designer sometimes passes Null for the Label when created in code, guard against it
    If lblLbl <> Null And lblLbl.IsInitialized Then
        mLbl = lblLbl
    Else
        mLbl = Null
    End If
    If mBase.Tag = Null Then mBase.Tag = Me

'    ' Load properties
'    If Props.ContainsKey("ClassName") Then mClassName = B4XDaisyVariants.GetPropString(Props, "ClassName", mClassName)
'    If Props.ContainsKey("Cols") Then mColsFallback = Max(1, B4XDaisyVariants.GetPropInt(Props, "Cols", mColsFallback))
'    If Props.ContainsKey("Gap") Then mGapFallback = ParseSpacingValue(B4XDaisyVariants.GetPropString(Props, "Gap", ""), 16dip)
'    If Props.ContainsKey("GapX") Then
'        Dim s1 As String = B4XDaisyVariants.GetPropString(Props, "GapX", "")
'        If s1 <> "" Then mGapXFallback = ParseSpacingValue(s1, -1)
'    End If
'    If Props.ContainsKey("GapY") Then
'        Dim s2 As String = B4XDaisyVariants.GetPropString(Props, "GapY", "")
'        If s2 <> "" Then mGapYFallback = ParseSpacingValue(s2, -1)
'    End If
'    If Props.ContainsKey("AutoRows") Then mAutoRowsTemplate = Props.Get("AutoRows")
'    If Props.ContainsKey("TemplateRows") Then mTemplateRows = Props.Get("TemplateRows")
'    If Props.ContainsKey("Padding") Then mPaddingAll = Max(0, ParseSpacingValue(Props.Get("Padding"), 0))
'    If Props.ContainsKey("Dense") Then mDense = Props.Get("Dense")
'    If Props.ContainsKey("Debug") Then mDebug = Props.Get("Debug")
'    If Props.ContainsKey("DebugOverlay") Then mDebugOverlay = Props.Get("DebugOverlay")
'    If Props.ContainsKey("AutoRegisterChildrenFromTag") Then mAutoRegisterChildrenFromTag = Props.Get("AutoRegisterChildrenFromTag")
'    If Props.ContainsKey("EmitLayoutDiff") Then mEmitLayoutDiff = Props.Get("EmitLayoutDiff")
'    If Props.ContainsKey("DefaultAnimMs") Then mDefaultAnimMs = Max(0, Props.Get("DefaultAnimMs"))

    ApplyDesignerProps(mProps)

    ParseContainerClassIfNeeded
    EnsureDebugOverlayPanel

    If mAutoRegisterChildrenFromTag Then RegisterChildrenFromTag("")

    Relayout
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    If mProps.ContainsKey("ClassName") Then mClassName = B4XDaisyVariants.GetPropString(mProps, "ClassName", mClassName)
    If mProps.ContainsKey("Cols") Then mColsFallback = Max(1, B4XDaisyVariants.GetPropInt(mProps, "Cols", mColsFallback))
    If mProps.ContainsKey("Gap") Then mGapFallback = ParseSpacingValue(B4XDaisyVariants.GetPropString(mProps, "Gap", ""), 16dip)
    If mProps.ContainsKey("GapX") Then
        Dim s1 As String = B4XDaisyVariants.GetPropString(mProps, "GapX", "")
        If s1 <> "" Then mGapXFallback = ParseSpacingValue(s1, -1)
    End If
    If mProps.ContainsKey("GapY") Then
        Dim s2 As String = B4XDaisyVariants.GetPropString(mProps, "GapY", "")
        If s2 <> "" Then mGapYFallback = ParseSpacingValue(s2, -1)
    End If
    If mProps.ContainsKey("AutoRows") Then mAutoRowsTemplate = mProps.Get("AutoRows")
    If mProps.ContainsKey("TemplateRows") Then mTemplateRows = mProps.Get("TemplateRows")
    If mProps.ContainsKey("Padding") Then mPaddingAll = Max(0, ParseSpacingValue(mProps.Get("Padding"), 0))
    If mProps.ContainsKey("Dense") Then mDense = mProps.Get("Dense")
    If mProps.ContainsKey("Debug") Then mDebug = mProps.Get("Debug")
    If mProps.ContainsKey("DebugOverlay") Then mDebugOverlay = mProps.Get("DebugOverlay")
    If mProps.ContainsKey("AutoRegisterChildrenFromTag") Then mAutoRegisterChildrenFromTag = mProps.Get("AutoRegisterChildrenFromTag")
    If mProps.ContainsKey("EmitLayoutDiff") Then mEmitLayoutDiff = mProps.Get("EmitLayoutDiff")
    If mProps.ContainsKey("DefaultAnimMs") Then mDefaultAnimMs = Max(0, mProps.Get("DefaultAnimMs"))
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("ClassName", mClassName)
	props.Put("Cols", mColsFallback)
	props.Put("Gap", B4XDaisyVariants.ResolvePxSizeSpec(mGapFallback))
	props.Put("GapX", B4XDaisyVariants.ResolvePxSizeSpec(mGapXFallback))
	props.Put("GapY", B4XDaisyVariants.ResolvePxSizeSpec(mGapYFallback))
	props.Put("AutoRows", mAutoRowsTemplate)
	props.Put("TemplateRows", mTemplateRows)
	props.Put("Padding", B4XDaisyVariants.ResolvePxSizeSpec(mPaddingAll))
	props.Put("Dense", mDense)
	props.Put("Debug", mDebug)
	props.Put("DebugOverlay", mDebugOverlay)
	props.Put("AutoRegisterChildrenFromTag", mAutoRegisterChildrenFromTag)
	props.Put("EmitLayoutDiff", mEmitLayoutDiff)
	props.Put("DefaultAnimMs", mDefaultAnimMs)
	Return props
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If inResize Then Return
    inResize = True
    Relayout
    inResize = False
End Sub

' -
' Public API - Container
' -
Public Sub setClassName(sClassText As String)
    If sClassText = Null Then sClassText = ""
    If mClassName = sClassText Then Return
    mClassName = sClassText
    mContainerClassDirty = True
    RequestRelayout
End Sub

Public Sub getClassName As String
    Return mClassName
End Sub

Public Sub setCols(iValue As Int)
    mColsFallback = Max(1, iValue)
    RequestRelayout
End Sub

Public Sub getCols As Int
    Return mColsFallback
End Sub

Public Sub setGap(oValue As Object)
    Dim spec As String = ""
    If oValue <> Null Then spec = oValue
    mGapFallback = Max(0, ParseSpacingValue(spec, mGapFallback))
    RequestRelayout
End Sub

Public Sub getGap As Float
    Return mGapFallback
End Sub

Public Sub setGapX(oValue As Object)
    Dim spec As String = ""
    If oValue <> Null Then spec = oValue
    If spec = "" Then
        mGapXFallback = -1
    Else
        mGapXFallback = Max(0, ParseSpacingValue(spec, mGapXFallback))
    End If
    RequestRelayout
End Sub

Public Sub getGapX As Float
    Return mGapXFallback
End Sub

Public Sub setGapY(oValue As Object)
    Dim spec As String = ""
    If oValue <> Null Then spec = oValue
    If spec = "" Then
        mGapYFallback = -1
    Else
        mGapYFallback = Max(0, ParseSpacingValue(spec, mGapYFallback))
    End If
    RequestRelayout
End Sub

Public Sub getGapY As Float
    Return mGapYFallback
End Sub

Public Sub SetGapXY(fValueX As Float, fValueY As Float)
    mGapXFallback = Max(0, fValueX)
    mGapYFallback = Max(0, fValueY)
    RequestRelayout
End Sub

Public Sub SetAutoRowsTemplate(sTemplate As String)
    setAutoRows(sTemplate)
End Sub

Public Sub setAutoRows(sTemplate As String)
    mAutoRowsTemplate = sTemplate
    RequestRelayout
End Sub

Public Sub getAutoRows As String
    Return mAutoRowsTemplate
End Sub

Public Sub setTemplateRows(sTemplate As String)
    mTemplateRows = sTemplate
    RequestRelayout
End Sub

Public Sub getTemplateRows As String
    Return mTemplateRows
End Sub

Public Sub setPadding(oValue As Object)
    Dim spec As String = ""
    If oValue <> Null Then spec = oValue
    mPaddingAll = Max(0, ParseSpacingValue(spec, 0))
    ParseContainerClassIfNeeded
    mParsedContainerBase.Put("_padl", mPaddingAll)
    mParsedContainerBase.Put("_padt", mPaddingAll)
    mParsedContainerBase.Put("_padr", mPaddingAll)
    mParsedContainerBase.Put("_padb", mPaddingAll)
    RequestRelayout
End Sub

Public Sub getPadding As Float
    Return mPaddingAll
End Sub

Public Sub SetPaddingLTRB(fLeft As Float, fTop As Float, fRight As Float, fBottom As Float)
    ParseContainerClassIfNeeded
    mParsedContainerBase.Put("_padl", Max(0, fLeft))
    mParsedContainerBase.Put("_padt", Max(0, fTop))
    mParsedContainerBase.Put("_padr", Max(0, fRight))
    mParsedContainerBase.Put("_padb", Max(0, fBottom))
    RequestRelayout
End Sub

Public Sub SetBreakpoint(sName As String, fMinWidth As Float)
    If sName = Null Or sName.Trim = "" Then Return
    mBreakpoints.Put(sName.Trim.ToLowerCase, fMinWidth)
    RebuildBreakpointsCache
    RequestRelayout
End Sub

Public Sub setDense(bValue As Boolean)
    mDense = bValue
    RequestRelayout
End Sub

Public Sub getDense As Boolean
    Return mDense
End Sub

Public Sub setDebug(bValue As Boolean)
    mDebug = bValue
End Sub

Public Sub getDebug As Boolean
    Return mDebug
End Sub

Public Sub setDebugOverlay(bValue As Boolean)
    mDebugOverlay = bValue
    EnsureDebugOverlayPanel
    RequestRelayout
End Sub

Public Sub getDebugOverlay As Boolean
    Return mDebugOverlay
End Sub

Public Sub setAutoRegisterChildrenFromTag(bValue As Boolean)
    mAutoRegisterChildrenFromTag = bValue
    If bValue And mBase.IsInitialized Then RegisterChildrenFromTag("")
End Sub

Public Sub getAutoRegisterChildrenFromTag As Boolean
    Return mAutoRegisterChildrenFromTag
End Sub

Public Sub setEmitLayoutDiff(bValue As Boolean)
    mEmitLayoutDiff = bValue
End Sub

Public Sub getEmitLayoutDiff As Boolean
    Return mEmitLayoutDiff
End Sub

Public Sub setDefaultAnimMs(iValue As Int)
    mDefaultAnimMs = Max(0, iValue)
End Sub

Public Sub getDefaultAnimMs As Int
    Return mDefaultAnimMs
End Sub

' -
' Public API - Items
' -
Public Sub AddItem(vItemView As B4XView, sClassText As String) As String
    Dim key As String = GenerateKey
    AddItemWithKey(key, vItemView, sClassText)
    Return key
End Sub

Public Sub AddItemWithKey(sKey As String, vItemView As B4XView, sClassText As String)
    If vItemView.IsInitialized = False Then Return
    If sKey = Null Or sKey.Trim = "" Then sKey = GenerateKey
    If mItemByKey.ContainsKey(sKey) Then
        Return
    End If

    Dim rec As Map = CreateItemRecord(sKey, vItemView, sClassText)
    mItems.Add(rec)
    mItemByKey.Put(sKey, mItems.Size - 1)

    Try
        vItemView.RemoveViewFromParent
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyGrid.AddItemWithKey: " & LastException.Message)
        ' Ignore if it has no parent yet
    End Try

    mBase.AddView(vItemView, 0, 0, 0, 0)

    RequestRelayout
End Sub

Public Sub UpdateItemClass(sKey As String, sClassText As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    If sClassText = Null Then sClassText = ""
    rec.Put("ClassText", sClassText)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub RemoveItem(sKey As String)
    Dim idx As Int = GetItemIndex(sKey)
    If idx < 0 Then Return

    Dim rec As Map = mItems.Get(idx)
    Dim v As B4XView = rec.Get("View")
    If v.IsInitialized And v.Parent.IsInitialized Then v.RemoveViewFromParent

    mItems.RemoveAt(idx)
    RebuildItemIndexMap
    mPlacementByKey.Remove(sKey)
    RequestRelayout
End Sub

Public Sub SetItemVisible(sKey As String, bVisible As Boolean)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    rec.Put("Visible", bVisible)
    Dim v As B4XView = rec.Get("View")
    If v.IsInitialized Then v.Visible = bVisible
    RequestRelayout
End Sub

Public Sub SetItemOrder(sKey As String, iOrder As Int)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    rec.Put("Order", iOrder)
    RequestRelayout
End Sub

Public Sub SetItemRowSpan(sKey As String, iRowSpan As Int, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    iRowSpan = Max(1, iRowSpan)
    sBp = NormalizeBp(sBp)

    Dim cls As String = rec.Get("ClassText")
    cls = ReplaceOrAppendUtility(cls, sBp, "row-span-", "row-span-" & iRowSpan)
    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub SetItemColSpan(sKey As String, iColSpan As Int, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    iColSpan = Max(1, iColSpan)
    sBp = NormalizeBp(sBp)

    Dim cls As String = rec.Get("ClassText")
    cls = ReplaceOrAppendUtility(cls, sBp, "col-span-", "col-span-" & iColSpan)
    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub SetItemColStart(sKey As String, iColStart As Int, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    sBp = NormalizeBp(sBp)

    Dim body As String = IIf(iColStart <= 0, "col-start-auto", "col-start-" & iColStart)
    Dim cls As String = rec.Get("ClassText")
    cls = ReplaceOrAppendUtility(cls, sBp, "col-start-", body)
    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub SetItemRowStart(sKey As String, iRowStart As Int, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    sBp = NormalizeBp(sBp)

    Dim body As String = IIf(iRowStart <= 0, "row-start-auto", "row-start-" & iRowStart)
    Dim cls As String = rec.Get("ClassText")
    cls = ReplaceOrAppendUtility(cls, sBp, "row-start-", body)
    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub SetItemJustify(sKey As String, sValue As String, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    sBp = NormalizeBp(sBp)
    
    Dim validValues As Map = CreateMap("start": True, "end": True, "center": True, "stretch": True)
    sValue = sValue.ToLowerCase.Trim
    If validValues.ContainsKey(sValue) = False Then Return
    
    Dim cls As String = rec.Get("ClassText")
    cls = RemoveUtilityPattern(cls, sBp, "justify-self-")
    If sValue <> "stretch" Then
        cls = (cls & IIf(cls = "", "", " ") & JoinBpToken(sBp, "justify-self-" & sValue)).Trim
    End If
    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub SetItemAlign(sKey As String, sValue As String, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    sBp = NormalizeBp(sBp)
    
    Dim validValues As Map = CreateMap("start": True, "end": True, "center": True, "stretch": True)
    sValue = sValue.ToLowerCase.Trim
    If validValues.ContainsKey(sValue) = False Then Return
    
    Dim cls As String = rec.Get("ClassText")
    cls = RemoveUtilityPattern(cls, sBp, "self-")
    If sValue <> "stretch" Then
        cls = (cls & IIf(cls = "", "", " ") & JoinBpToken(sBp, "self-" & sValue)).Trim
    End If
    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub SetItemHidden(sKey As String, bHidden As Boolean, sBp As String)
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return
    sBp = NormalizeBp(sBp)

    Dim cls As String = rec.Get("ClassText")
    cls = RemoveExactUtility(cls, sBp, "hidden")
    cls = RemoveExactUtility(cls, sBp, "block")

    If bHidden Then
        cls = (cls & IIf(cls = "", "", " ") & JoinBpToken(sBp, "hidden")).Trim
    Else
        cls = (cls & IIf(cls = "", "", " ") & JoinBpToken(sBp, "block")).Trim
    End If

    rec.Put("ClassText", cls)
    rec.Put("ClassDirty", True)
    RequestRelayout
End Sub

Public Sub GetItemPlacement(sKey As String) As GridPlacement
    If mPlacementByKey.ContainsKey(sKey) Then Return mPlacementByKey.Get(sKey)
    Dim gp As GridPlacement
    gp.Initialize
    Return gp
End Sub

' -
' Public API - Batch / Layout
' -
Public Sub BeginUpdate
    mIsUpdating = True
End Sub

Public Sub EndUpdate
    mIsUpdating = False
    If mPendingRelayout Then
        mPendingRelayout = False
        Relayout
    End If
End Sub

Public Sub Relayout
    If mBase.IsInitialized = False Then Return

    ' Clear stale diagnostics
    mLastCollisionDiagnostics.Clear

    ' Parse container classes if needed
    ParseContainerClassIfNeeded
    
    ' Get active breakpoint
    mLastActiveBreakpoint = GetActiveBreakpointName(mBase.Width)
    
    ' Resolve container configuration
    Dim rc As GridResolvedConfig = ResolveContainerConfig(mBase.Width)
    mLastResolvedConfig = rc
    
    ' Get sorted visible items
    Dim ordered As List = GetSortedVisibleItems(mBase.Width)
    
    ' Validate and adjust container config
    rc.Cols = Max(1, rc.Cols)
    rc.GapX = Max(0, rc.GapX)
    rc.GapY = Max(0, rc.GapY)
    
    ' Calculate inner dimensions
    Dim innerW As Float = Max(0, mBase.Width - rc.PadL - rc.PadR)
    
    ' Parse and calculate column widths
    mColumnWidths = CalculateColumnWidths(innerW, rc.Cols, rc.GapX)
    
    ' Parse row templates
    Dim rowTracks As List = ParseTrackTemplate(rc.TemplateRows)
    Dim autoRowTracks As List = ParseTrackTemplate(rc.AutoRowsTemplate)
    
    ' Initialize grid state
    InitializeGrid(rc.Cols)
    
    ' Clear previous placements
    mPlacementByKey.Clear
    
    ' -
    ' PASS 1: Determine grid cell assignments
    ' -
    Dim placementRecords As List  ' List of Maps with "rec", "col", "row", "colSpan", "rowSpan", "ir"
    placementRecords.Initialize
    
    ' Separate explicit vs auto items
    Dim explicitItems As List
    explicitItems.Initialize
    Dim autoItems As List
    autoItems.Initialize
    
    For Each rec As Map In ordered
        ParseItemClassIfNeeded(rec)
        Dim ir As GridItemResolved = ResolveItemConfig(rec, mBase.Width, rc.Cols)
        If ir.Hidden Then
            Dim v As B4XView = rec.Get("View")
            v.Visible = False
            Continue
        End If
        
        If ir.ColStart > 0 Or ir.RowStart > 0 Then
            explicitItems.Add(CreateMap("rec": rec, "ir": ir))
        Else
            autoItems.Add(CreateMap("rec": rec, "ir": ir))
        End If
    Next
    
    ' Place explicitly positioned items first (grid cell assignment only)
    For Each entry As Map In explicitItems
        Dim rec As Map = entry.Get("rec")
        Dim ir As GridItemResolved = entry.Get("ir")
        Dim placement As Map = FindItemPlacement(rec, ir, rc)
        If placement.IsInitialized = False Then Continue
        MarkOccupied(placement.Get("col"), placement.Get("row"), placement.Get("colSpan"), placement.Get("rowSpan"))
        placementRecords.Add(CreateMap("rec": rec, "ir": ir, "col": placement.Get("col"), "row": placement.Get("row"), "colSpan": placement.Get("colSpan"), "rowSpan": placement.Get("rowSpan")))
    Next
    
    ' Then auto-positioned items
    For Each entry As Map In autoItems
        Dim rec As Map = entry.Get("rec")
        Dim ir As GridItemResolved = entry.Get("ir")
        Dim placement As Map = FindItemPlacement(rec, ir, rc)
        If placement.IsInitialized = False Then Continue
        MarkOccupied(placement.Get("col"), placement.Get("row"), placement.Get("colSpan"), placement.Get("rowSpan"))
        placementRecords.Add(CreateMap("rec": rec, "ir": ir, "col": placement.Get("col"), "row": placement.Get("row"), "colSpan": placement.Get("colSpan"), "rowSpan": placement.Get("rowSpan")))
    Next
    
    ' -
    ' Calculate row heights (now we know total rows)
    ' -
    Dim gridSize As Map = CalculateGridDimensions(rc, placementRecords)
    Dim totalRows As Int = gridSize.Get("rows")
    Dim contentH As Float = gridSize.Get("height")
    
    ' -
    ' PASS 2: Apply final geometry to views
    ' -
    For Each pr As Map In placementRecords
        Dim rec As Map = pr.Get("rec")
        Dim ir As GridItemResolved = pr.Get("ir")
        Dim v As B4XView = rec.Get("View")
        Dim key As String = rec.Get("Key")
        Dim col As Int = pr.Get("col")
        Dim row As Int = pr.Get("row")
        Dim colSpan As Int = pr.Get("colSpan")
        Dim rowSpan As Int = pr.Get("rowSpan")
        
        ' Calculate position and size using now-valid mRowHeights
        Dim pos As Map = CalculateItemPosition(col, row, colSpan, rowSpan, rc, ir)
        Dim x As Float = pos.Get("x")
        Dim y As Float = pos.Get("y")
        Dim w As Float = pos.Get("w")
        Dim h As Float = pos.Get("h")
        
        ' Apply alignment
        Dim aligned As Map = ApplyItemAlignment(x, y, w, h, ir, pos.Get("cellW"), pos.Get("cellH"))
        x = aligned.Get("x")
        y = aligned.Get("y")
        w = aligned.Get("w")
        h = aligned.Get("h")
        
        ' Apply margin from tag
        Dim marginMap As Map = GetItemMarginFromTag(v)
        Dim withMargin As Map = ApplyMarginShim(x, y, w, h, marginMap)
        x = withMargin.Get("x")
        y = withMargin.Get("y")
        w = withMargin.Get("w")
        h = withMargin.Get("h")
        
        ' Create placement record
        Dim gp As GridPlacement
        gp.Initialize
        gp.Col = col
        gp.Row = row
        gp.ColSpan = colSpan
        gp.RowSpan = rowSpan
        gp.X = x
        gp.Y = y
        gp.W = w
        gp.H = h
        
        Dim placeInfo As Map = BuildPlaceInfo(rec, gp)

        ' Raise before place event
        RaiseBeforePlace(key, placeInfo)
        
        ' Apply layout to view
        v.Visible = True
        v.SetLayoutAnimated(GetItemAnimMsFromTag(v), x, y, w, h)
        
        ' Store placement
        mPlacementByKey.Put(key, gp)
        
        ' Raise after place event
        RaiseAfterPlace(key, placeInfo)
        
        ' Raise ItemPlaced event
        If xui.SubExists(mCallBack, mEventName & "_ItemPlaced", 1) Then
            CallSub2(mCallBack, mEventName & "_ItemPlaced", placeInfo)
        End If
    Next
    
    ' Set container height
    mBase.Height = contentH
    
    ' Update debug overlay
    EnsureDebugOverlayPanel
    UpdateDebugOverlay(rc, totalRows, contentH)
    
    ' Emit layout diff if enabled
    EmitLayoutDiffIfNeeded
    
    ' Raise LayoutChanged event
    If xui.SubExists(mCallBack, mEventName & "_LayoutChanged", 1) Then
        CallSub2(mCallBack, mEventName & "_LayoutChanged", contentH)
    End If
    
End Sub


Private Sub FindItemPlacement(mRec As Map, ir As GridItemResolved, rc As GridResolvedConfig) As Map
    Dim result As Map
    result.Initialize
    
    If ir.ColStart > 0 Or ir.RowStart > 0 Then
        ' Try explicit placement
        Dim col As Int = Max(1, ir.ColStart)
        Dim row As Int = Max(1, ir.RowStart)
        
        ' Adjust column if needed
        If col + ir.ColSpan - 1 > rc.Cols Then
            col = Max(1, rc.Cols - ir.ColSpan + 1)
        End If
        
        ' Check if space is available
        If CanPlace(col, row, ir.ColSpan, ir.RowSpan) Then
            result.Put("col", col)
            result.Put("row", row)
            result.Put("colSpan", ir.ColSpan)
            result.Put("rowSpan", ir.RowSpan)
            Return result
        Else
            ' Record collision
            Dim cd As GridDiagCollision
            cd.Initialize
            cd.Key = mRec.Get("Key")
            cd.RequestedCol = ir.ColStart
            cd.RequestedRow = ir.RowStart
            cd.RequestedColSpan = ir.ColSpan
            cd.RequestedRowSpan = ir.RowSpan
            cd.Reason = "Explicit slot unavailable"

            ' Fall back to auto-placement
            Dim fallback As Map = FindAutoPlacement(mRec, ir, rc)
            If fallback.IsInitialized Then
                cd.FallbackCol = fallback.Get("col")
                cd.FallbackRow = fallback.Get("row")
            End If
            mLastCollisionDiagnostics.Add(cd)
            Return fallback
        End If
    Else
        ' Auto placement
        Return FindAutoPlacement(mRec, ir, rc)
    End If
End Sub

Private Sub FindAutoPlacement(mRec As Map, ir As GridItemResolved, rc As GridResolvedConfig) As Map
    Dim result As Map
    result.Initialize
    
    Dim startRow As Int = 1
    Dim startCol As Int = 1
    
    If rc.Dense = False Then
        ' Find next available position in row-major order
        Dim found As Boolean = False
        Dim maxCheckedRow As Int = 1000 ' Prevent infinite loops
        
        For row = startRow To maxCheckedRow
            EnsureGridRows(row + ir.RowSpan - 1)
            
            For col = startCol To rc.Cols - ir.ColSpan + 1
                If CanPlace(col, row, ir.ColSpan, ir.RowSpan) Then
                    result.Put("col", col)
                    result.Put("row", row)
                    result.Put("colSpan", ir.ColSpan)
                    result.Put("rowSpan", ir.RowSpan)
                    Return result
                End If
            Next
            startCol = 1
        Next
    Else
        ' Dense mode - scan from top-left for each placement
        Dim maxCheckedRow As Int = 1000
        
        For row = 1 To maxCheckedRow
            EnsureGridRows(row + ir.RowSpan - 1)
            
            For col = 1 To rc.Cols - ir.ColSpan + 1
                If CanPlace(col, row, ir.ColSpan, ir.RowSpan) Then
                    result.Put("col", col)
                    result.Put("row", row)
                    result.Put("colSpan", ir.ColSpan)
                    result.Put("rowSpan", ir.RowSpan)
                    Return result
                End If
            Next
        Next
    End If
    
    ' Fallback - place at next available position
    Dim fallbackRow As Int = GetNextAvailableRow(rc.Cols, ir.ColSpan, ir.RowSpan)
    result.Put("col", 1)
    result.Put("row", fallbackRow)
    result.Put("colSpan", ir.ColSpan)
    result.Put("rowSpan", ir.RowSpan)
    
    Return result
End Sub

Private Sub CalculateItemPosition(iCol As Int, iRow As Int, iColSpan As Int, iRowSpan As Int, rc As GridResolvedConfig, ir As GridItemResolved) As Map
    Dim result As Map
    result.Initialize
    
    ' Calculate base position
    Dim x As Float = rc.PadL
    For c = 1 To iCol - 1
        x = x + mColumnWidths.Get(c - 1) + rc.GapX
    Next
    
    Dim y As Float = rc.PadT
    For r = 1 To iRow - 1
        y = y + mRowHeights.Get(r - 1) + rc.GapY
    Next
    
    ' Calculate width and height
    Dim w As Float = 0
    For c = 0 To iColSpan - 1
        w = w + mColumnWidths.Get(iCol - 1 + c)
    Next
    w = w + (iColSpan - 1) * rc.GapX
    
    Dim h As Float = 0
    For r = 0 To iRowSpan - 1
        h = h + mRowHeights.Get(iRow - 1 + r)
    Next
    h = h + (iRowSpan - 1) * rc.GapY
    
    ' Store cell dimensions for alignment
    result.Put("x", x)
    result.Put("y", y)
    result.Put("w", w)
    result.Put("h", h)
    result.Put("cellW", mColumnWidths.Get(iCol - 1))
    result.Put("cellH", mRowHeights.Get(iRow - 1))
    
    Return result
End Sub

Private Sub ApplyItemAlignment(fX As Float, fY As Float, fW As Float, fH As Float, ir As GridItemResolved, fCellW As Float, fCellH As Float) As Map
    Dim result As Map
    result.Initialize

    ' Horizontal alignment
    Select ir.JustifySelf
        Case "start"
            ' Keep original x
        Case "end"
            fX = fX + (fCellW - fW)
        Case "center"
            fX = fX + (fCellW - fW) / 2
        Case "stretch"
            fW = fCellW
    End Select
    
    ' Vertical alignment
    Select ir.AlignSelf
        Case "start"
            ' Keep original y
        Case "end"
            fY = fY + (fCellH - fH)
        Case "center"
            fY = fY + (fCellH - fH) / 2
        Case "stretch"
            fH = fCellH
    End Select

    result.Put("x", fX)
    result.Put("y", fY)
    result.Put("w", fW)
    result.Put("h", fH)
    Return result
End Sub

Private Sub InitializeGrid(iCols As Int)
    mGridCells.Clear
    mRowHeights.Clear
    
    ' Initialize with one empty row
    Dim firstRow(iCols) As Boolean
    mGridCells.Add(firstRow)
End Sub

Private Sub EnsureGridRows(iNeededRows As Int)
    Do While mGridCells.Size < iNeededRows
        Dim newRow(mLastResolvedConfig.Cols) As Boolean
        mGridCells.Add(newRow)
        mRowHeights.Add(0) ' Will be calculated later
    Loop
End Sub

Private Sub CanPlace(iCol As Int, iRow As Int, iColSpan As Int, iRowSpan As Int) As Boolean
    If iRow < 1 Or iCol < 1 Then Return False
    If iCol + iColSpan - 1 > mLastResolvedConfig.Cols Then Return False
    
    EnsureGridRows(iRow + iRowSpan - 1)
    
    For r = iRow - 1 To iRow + iRowSpan - 2
        Dim rowArr() As Boolean = mGridCells.Get(r)
        For c = iCol - 1 To iCol + iColSpan - 2
            If rowArr(c) Then Return False
        Next
    Next
    
    Return True
End Sub

Private Sub MarkOccupied(iCol As Int, iRow As Int, iColSpan As Int, iRowSpan As Int)
    EnsureGridRows(iRow + iRowSpan - 1)
    
    For r = iRow - 1 To iRow + iRowSpan - 2
        Dim rowArr() As Boolean = mGridCells.Get(r)
        For c = iCol - 1 To iCol + iColSpan - 2
            rowArr(c) = True
        Next
        mGridCells.Set(r, rowArr)
    Next
End Sub

Private Sub GetNextAvailableRow(iCols As Int, iColSpan As Int, iRowSpan As Int) As Int
    Dim row As Int = 1
    
    Do While True
        EnsureGridRows(row + iRowSpan - 1)
        
        For c = 1 To iCols - iColSpan + 1
            If CanPlace(c, row, iColSpan, iRowSpan) Then
                Return row
            End If
        Next
        row = row + 1
    Loop
	Return row
End Sub

Private Sub CalculateColumnWidths(fInnerW As Float, iCols As Int, fGapX As Float) As List
    Dim widths As List
    widths.Initialize
    
    If iCols <= 0 Then Return widths
    fInnerW = Max(0, fInnerW)
    fGapX = Max(0, fGapX)
    
    ' Parse column template from class if available
    Dim colTemplate As String = GetColumnTemplate
    If colTemplate <> "" Then
        Dim tracks As List = ParseTrackTemplate(colTemplate)
        If tracks.Size = iCols Then
            Return CalculateTrackSizes(tracks, fInnerW, fGapX, iCols - 1)
        End If
    End If
    
    ' Default to equal columns
    Dim totalGap As Float = (iCols - 1) * fGapX
    Dim usableW As Float = Max(0, fInnerW - totalGap)
    Dim colW As Float = usableW / iCols
    
    For i = 1 To iCols
        widths.Add(colW)
    Next
    
    Return widths
End Sub

Private Sub CalculateTrackSizes(lstTracks As List, fTotalWidth As Float, fGap As Float, iGapCount As Int) As List
    Dim sizes As List
    sizes.Initialize
    fTotalWidth = Max(0, fTotalWidth)
    fGap = Max(0, fGap)
    iGapCount = Max(0, iGapCount)
    
    Dim totalGap As Float = iGapCount * fGap
    Dim availableWidth As Float = Max(0, fTotalWidth - totalGap)
    
    ' First pass - calculate fixed sizes and fr units
    Dim frTotal As Float = 0
    Dim fixedTotal As Float = 0
    
    For Each track As GridTrackSize In lstTracks
        If track.IsFr Then
            frTotal = frTotal + Max(0, track.Value)
        Else
            fixedTotal = fixedTotal + Max(0, track.Value)
        End If
    Next
    
    Dim remainingForFr As Float = Max(0, availableWidth - fixedTotal)
    
    ' Second pass - calculate actual sizes
    For Each track As GridTrackSize In lstTracks
        If track.IsFr Then
            If frTotal > 0 Then
                Dim frSize As Float = (Max(0, track.Value) / frTotal) * remainingForFr
                sizes.Add(Max(track.fMin, Min(track.fMax, frSize)))
            Else
                sizes.Add(0)
            End If
        Else
            sizes.Add(Max(0, track.Value))
        End If
    Next
    
    Return sizes
End Sub

Private Sub ParseTrackTemplate(sTemplate As String) As List
    Dim result As List
    result.Initialize
    
    If sTemplate = "" Then Return result

    Dim parts As List = SplitTrackTemplate(sTemplate)

    For Each part As String In parts
        If part = "" Then Continue
        
        Dim track As GridTrackSize
        track.Initialize
        track.IsFr = False
        track.Value = 0
        track.fMin = 0
        track.fMax = 1000000dip ' Large default max
        
        If part.Contains("minmax(") Then
            ' Parse minmax(min, max)
            Dim inner As String = part.SubString2(7, part.Length - 1)
            Dim minMax() As String = Regex.Split(",", inner)
            If minMax.Length = 2 Then
                Dim minVal As String = minMax(0).Trim
                Dim maxVal As String = minMax(1).Trim
                
                If minVal = "auto" Then
                    track.Value = 0  ' auto min = 0, content will expand
                Else If minVal.EndsWith("fr") Then
                    track.IsFr = True
                    track.Value = ParseFrValue(minVal)
                Else
                    track.Value = ParseSpacingValue(minVal, 0)
                End If
                
                If maxVal = "auto" Then
                    track.fMax = 1000000dip  ' auto max = unbounded (content-sized)
                Else If maxVal.EndsWith("fr") Then
                    track.fMax = ParseFrValue(maxVal) * 1000 ' Approximate
                Else
                    track.fMax = ParseSpacingValue(maxVal, 1000000dip)
                End If
            End If
        Else If part.EndsWith("fr") Then
            track.IsFr = True
            track.Value = ParseFrValue(part)
            track.fMax = 1000000dip
        Else
            track.Value = ParseSpacingValue(part, 0)
        End If
        
        result.Add(track)
    Next
    
    Return result
End Sub

Private Sub SplitTrackTemplate(sTemplate As String) As List
    Dim tokens As List
    tokens.Initialize
    If sTemplate = Null Then Return tokens

    Dim depth As Int = 0
    Dim sb As StringBuilder
    sb.Initialize

    For i = 0 To sTemplate.Length - 1
        Dim ch As String = sTemplate.SubString2(i, i + 1)

        If ch = "(" Then
            depth = depth + 1
            sb.Append(ch)
            Continue
        End If

        If ch = ")" Then
            depth = Max(0, depth - 1)
            sb.Append(ch)
            Continue
        End If

        If depth = 0 And (ch = " " Or ch = Chr(9) Or ch = Chr(13) Or ch = Chr(10)) Then
            Dim token As String = sb.ToString.Trim
            If token <> "" Then tokens.Add(token)
            sb.Initialize
        Else
            sb.Append(ch)
        End If
    Next

    Dim lastToken As String = sb.ToString.Trim
    If lastToken <> "" Then tokens.Add(lastToken)
    Return tokens
End Sub

Private Sub ParseFrValue(sValue As String) As Float
    sValue = sValue.Trim.ToLowerCase
    If sValue.EndsWith("fr") Then
        sValue = sValue.SubString2(0, sValue.Length - 2)
    End If
    
    Try
        Return sValue
    Catch
        Return 1
    End Try
End Sub

Private Sub GetColumnTemplate As String
    ParseContainerClassIfNeeded
    
    Dim activeRules As Map = ResolveMergedRules(mParsedContainerBase, mParsedContainerBp, mBase.Width)
    
    If activeRules.ContainsKey("grid-cols") Then
        Dim cols As Object = activeRules.Get("grid-cols")
        If cols Is String Then
            Return cols
        End If
    End If
    
    Return ""
End Sub

Private Sub CalculateGridDimensions(rc As GridResolvedConfig, lstPlacedItems As List) As Map
    Dim result As Map
    result.Initialize
    
    ' Calculate row heights based on content
    Dim totalRows As Int = mGridCells.Size
    
    ' Parse row templates
    Dim rowTracks As List = ParseTrackTemplate(rc.TemplateRows)
    Dim autoRowTracks As List = ParseTrackTemplate(rc.AutoRowsTemplate)
    
    ' Calculate row heights
    mRowHeights.Clear
    
    For r = 1 To totalRows
        Dim rowHeight As Float
        
        ' Use template if available
        If rowTracks.Size >= r Then
            Dim track As GridTrackSize = rowTracks.Get(r - 1)
            If track.IsFr Then
                ' fr units will be calculated after all rows
                rowHeight = 0
            Else
                rowHeight = track.Value
            End If
        Else
            ' Use auto-rows template
            If autoRowTracks.Size > 0 Then
                Dim autoIndex As Int = (r - rowTracks.Size - 1) Mod autoRowTracks.Size
                Dim track As GridTrackSize = autoRowTracks.Get(autoIndex)
                If track.IsFr Then
                    rowHeight = 0
                Else
                    rowHeight = track.Value
                End If
            Else
                rowHeight = 72dip ' Default
            End If
        End If
        
        mRowHeights.Add(rowHeight)
    Next
    
    ' Calculate total height
    Dim totalH As Float = rc.PadT + rc.PadB
    
    For r = 0 To totalRows - 1
        totalH = totalH + mRowHeights.Get(r)
        If r < totalRows - 1 Then
            totalH = totalH + rc.GapY
        End If
    Next
    
    result.Put("rows", totalRows)
    result.Put("height", totalH)
    
    Return result
End Sub

Private Sub RequestRelayout
    If mIsUpdating Then
        mPendingRelayout = True
        Return
    End If
    Relayout
End Sub

' -
' Registration / Tag metadata
' -
Public Sub RegisterChildrenFromTag(sOptionalDefaultClass As String)
    BeginUpdate
    For i = 0 To mBase.NumberOfViews - 1
        Dim v As B4XView = mBase.GetView(i)
        If v = mDebugOverlayPanel Then Continue
        If IsRegisteredView(v) Then Continue

        Dim meta As Map = ExtractGridMetaFromTag(v.Tag)

        Dim cls As String = sOptionalDefaultClass
        If meta.IsInitialized And meta.ContainsKey("gridClass") Then cls = meta.Get("gridClass")
        If meta.IsInitialized And meta.ContainsKey("gridClassAppend") Then
            Dim app As String = meta.Get("gridClassAppend")
            If app <> "" Then cls = (cls & " " & app).Trim
        End If

        Dim key As String
        If meta.IsInitialized And meta.ContainsKey("gridKey") Then
            key = meta.Get("gridKey")
        Else
            key = GenerateKey
        End If

        AddItemWithKey(key, v, cls)

        If meta.IsInitialized Then
            If meta.ContainsKey("gridOrder") Then SetItemOrder(key, meta.Get("gridOrder"))
            If meta.ContainsKey("gridVisible") Then SetItemVisible(key, meta.Get("gridVisible"))
        End If
    Next
    EndUpdate
End Sub

' -
' Internal - Parsing
' -
Private Sub ParseContainerClassIfNeeded
    If mContainerClassDirty = False Then Return
    mParsedContainerBase.Initialize
    mParsedContainerBp.Initialize
    ParseUtilityClassString(mClassName, mParsedContainerBase, mParsedContainerBp, True)
    mContainerClassDirty = False
End Sub

Private Sub ParseItemClassIfNeeded(mRec As Map)
    If mRec.Get("ClassDirty") = False Then Return
    Dim baseRules As Map
    baseRules.Initialize
    Dim bpRules As Map
    bpRules.Initialize
    ParseUtilityClassString(mRec.Get("ClassText"), baseRules, bpRules, False)
    mRec.Put("BaseRules", baseRules)
    mRec.Put("BpRules", bpRules)
    mRec.Put("ClassDirty", False)
End Sub

Private Sub ParseUtilityClassString(sClassText As String, mBaseRules As Map, mBpRules As Map, bIsContainer As Boolean)
    If sClassText = Null Then Return
    Dim s As String = sClassText.Trim
    If s = "" Then Return

    Dim parts() As String = Regex.Split("\s+", s)
    For Each rawToken As String In parts
        If rawToken = "" Then Continue
        Dim bpName As String = ""
        Dim token As String = rawToken.Trim

        ' Check for breakpoint prefix (mobile-first - min-width)
        Dim p As Int = token.IndexOf(":")
        If p > 0 Then
            Dim pref As String = token.SubString2(0, p).ToLowerCase
            If mBreakpoints.ContainsKey(pref) Then
                bpName = pref
                token = token.SubString(p + 1)
            End If
        End If

        Dim target As Map
        If bpName = "" Then
            target = mBaseRules
        Else
            If mBpRules.ContainsKey(bpName) = False Then
                Dim b As Map
                b.Initialize
                mBpRules.Put(bpName, b)
            End If
            target = mBpRules.Get(bpName)
        End If

        ParseOneUtilityToken(token, target, bIsContainer)
    Next
End Sub

Private Sub ParseOneUtilityToken(sToken As String, mTarget As Map, bIsContainer As Boolean)
    Dim t As String = sToken.ToLowerCase.Trim
    If t = "" Then Return

    ' Grid container
    If t = "grid" Then
        mTarget.Put("display", "grid")
        Return
    End If

    If bIsContainer Then
        ' Column definitions
        If t.StartsWith("grid-cols-") Then
            Dim val As String = t.SubString("grid-cols-".Length)
            If IsNumeric(val) Then
                mTarget.Put("grid-cols", SafeInt(val, 1))
            Else
                mTarget.Put("grid-cols", NormalizeTrackTemplateValue(val)) ' For custom templates like "repeat(3, 1fr)" or "[200px_1fr]"
            End If
            Return
        End If

        ' Grid flow (all variants)
        If t = "grid-flow-row" Then
            mTarget.Put("grid-flow", "row")
            Return
        End If
        If t = "grid-flow-col" Then
            mTarget.Put("grid-flow", "col")
            Return
        End If
        If t = "grid-flow-dense" Then
            mTarget.Put("grid-flow", "row-dense")
            mTarget.Put("dense", True)
            Return
        End If
        If t = "grid-flow-row-dense" Then
            mTarget.Put("grid-flow", "row-dense")
            mTarget.Put("dense", True)
            Return
        End If
        If t = "grid-flow-col-dense" Then
            mTarget.Put("grid-flow", "col-dense")
            mTarget.Put("dense", True)
            Return
        End If

        ' Gaps
        If t.StartsWith("gap-x-") Then
            mTarget.Put("gap-x", ParseSpacingToken(t.SubString("gap-x-".Length), -1))
            Return
        End If
        If t.StartsWith("gap-y-") Then
            mTarget.Put("gap-y", ParseSpacingToken(t.SubString("gap-y-".Length), -1))
            Return
        End If
        If t.StartsWith("gap-") Then
            mTarget.Put("gap", ParseSpacingToken(t.SubString("gap-".Length), -1))
            Return
        End If

        ' Padding
        If t.StartsWith("px-") Then
            mTarget.Put("px", ParseSpacingToken(t.SubString("px-".Length), 0))
            Return
        End If
        If t.StartsWith("py-") Then
            mTarget.Put("py", ParseSpacingToken(t.SubString("py-".Length), 0))
            Return
        End If
        If t.StartsWith("pl-") Then
            mTarget.Put("pl", ParseSpacingToken(t.SubString("pl-".Length), 0))
            Return
        End If
        If t.StartsWith("pt-") Then
            mTarget.Put("pt", ParseSpacingToken(t.SubString("pt-".Length), 0))
            Return
        End If
        If t.StartsWith("pr-") Then
            mTarget.Put("pr", ParseSpacingToken(t.SubString("pr-".Length), 0))
            Return
        End If
        If t.StartsWith("pb-") Then
            mTarget.Put("pb", ParseSpacingToken(t.SubString("pb-".Length), 0))
            Return
        End If
        If t.StartsWith("p-") Then
            mTarget.Put("p", ParseSpacingToken(t.SubString("p-".Length), 0))
            Return
        End If
        
        ' Template rows
        If t.StartsWith("grid-rows-") Then
            Dim rv As String = t.SubString("grid-rows-".Length)
            If rv = "none" Then
                mTarget.Put("grid-rows", "none")
            Else
                mTarget.Put("grid-rows", NormalizeTrackTemplateValue(rv))
            End If
            Return
        End If
        If t.StartsWith("auto-rows-") Then
            mTarget.Put("auto-rows", NormalizeTrackTemplateValue(t.SubString("auto-rows-".Length)))
            Return
        End If
        If t.StartsWith("auto-cols-") Then
            mTarget.Put("auto-cols", NormalizeTrackTemplateValue(t.SubString("auto-cols-".Length)))
            Return
        End If

        ' Container-level alignment
        If t = "justify-items-start" Then
            mTarget.Put("justify-items", "start")
            Return
        End If
        If t = "justify-items-end" Then
            mTarget.Put("justify-items", "end")
            Return
        End If
        If t = "justify-items-center" Then
            mTarget.Put("justify-items", "center")
            Return
        End If
        If t = "justify-items-stretch" Then
            mTarget.Put("justify-items", "stretch")
            Return
        End If

        If t = "items-start" Then
            mTarget.Put("align-items", "start")
            Return
        End If
        If t = "items-end" Then
            mTarget.Put("align-items", "end")
            Return
        End If
        If t = "items-center" Then
            mTarget.Put("align-items", "center")
            Return
        End If
        If t = "items-stretch" Then
            mTarget.Put("align-items", "stretch")
            Return
        End If
        If t = "items-baseline" Then
            mTarget.Put("align-items", "baseline")
            Return
        End If

        ' place-items (shorthand for justify-items + align-items)
        If t = "place-items-start" Then
            mTarget.Put("justify-items", "start")
            mTarget.Put("align-items", "start")
            Return
        End If
        If t = "place-items-end" Then
            mTarget.Put("justify-items", "end")
            mTarget.Put("align-items", "end")
            Return
        End If
        If t = "place-items-center" Then
            mTarget.Put("justify-items", "center")
            mTarget.Put("align-items", "center")
            Return
        End If
        If t = "place-items-stretch" Then
            mTarget.Put("justify-items", "stretch")
            mTarget.Put("align-items", "stretch")
            Return
        End If
    End If

    ' Item properties
    If t = "col-span-full" Then
        mTarget.Put("col-span", -1)  ' -1 = full
        Return
    End If
    If t = "row-span-full" Then
        mTarget.Put("row-span", -1)  ' -1 = full
        Return
    End If
    If t.StartsWith("col-span-") Then
        Dim cs As Int = SafeInt(t.SubString("col-span-".Length), 1)
        If cs > 0 Then mTarget.Put("col-span", cs)
        Return
    End If
    If t.StartsWith("row-span-") Then
        Dim rs As Int = SafeInt(t.SubString("row-span-".Length), 1)
        If rs > 0 Then mTarget.Put("row-span", rs)
        Return
    End If

    If t = "col-auto" Then
        mTarget.Put("col-start", 0)
        mTarget.Put("col-end", 0)
        Return
    End If
    If t = "row-auto" Then
        mTarget.Put("row-start", 0)
        mTarget.Put("row-end", 0)
        Return
    End If
    If t = "col-start-auto" Then
        mTarget.Put("col-start", 0)
        Return
    End If
    If t = "col-end-auto" Then
        mTarget.Put("col-end", 0)
        Return
    End If
    If t = "row-start-auto" Then
        mTarget.Put("row-start", 0)
        Return
    End If
    If t = "row-end-auto" Then
        mTarget.Put("row-end", 0)
        Return
    End If

    If t.StartsWith("col-start-") Then
        Dim cst As Int = SafeInt(t.SubString("col-start-".Length), -1)
        If cst > 0 Then mTarget.Put("col-start", cst)
        Return
    End If
    If t.StartsWith("col-end-") Then
        Dim colEndVal As Int = SafeInt(t.SubString("col-end-".Length), -1)
        If colEndVal > 0 Then mTarget.Put("col-end", colEndVal)
        Return
    End If
    If t.StartsWith("row-start-") Then
        Dim rst As Int = SafeInt(t.SubString("row-start-".Length), -1)
        If rst > 0 Then mTarget.Put("row-start", rst)
        Return
    End If
    If t.StartsWith("row-end-") Then
        Dim re As Int = SafeInt(t.SubString("row-end-".Length), -1)
        If re > 0 Then mTarget.Put("row-end", re)
        Return
    End If

    ' Item alignment
    If t = "justify-self-start" Then
        mTarget.Put("justify-self", "start")
        Return
    End If
    If t = "justify-self-end" Then
        mTarget.Put("justify-self", "end")
        Return
    End If
    If t = "justify-self-center" Then
        mTarget.Put("justify-self", "center")
        Return
    End If
    If t = "justify-self-stretch" Then
        mTarget.Put("justify-self", "stretch")
        Return
    End If
    If t = "justify-self-auto" Then
        mTarget.Put("justify-self", "auto")
        Return
    End If
    
    If t = "self-start" Then
        mTarget.Put("align-self", "start")
        Return
    End If
    If t = "self-end" Then
        mTarget.Put("align-self", "end")
        Return
    End If
    If t = "self-center" Then
        mTarget.Put("align-self", "center")
        Return
    End If
    If t = "self-stretch" Then
        mTarget.Put("align-self", "stretch")
        Return
    End If
    If t = "self-auto" Then
        mTarget.Put("align-self", "auto")
        Return
    End If
    If t = "self-baseline" Then
        mTarget.Put("align-self", "baseline")
        Return
    End If

    ' place-self (shorthand for justify-self + align-self)
    If t = "place-self-start" Then
        mTarget.Put("justify-self", "start")
        mTarget.Put("align-self", "start")
        Return
    End If
    If t = "place-self-end" Then
        mTarget.Put("justify-self", "end")
        mTarget.Put("align-self", "end")
        Return
    End If
    If t = "place-self-center" Then
        mTarget.Put("justify-self", "center")
        mTarget.Put("align-self", "center")
        Return
    End If
    If t = "place-self-stretch" Then
        mTarget.Put("justify-self", "stretch")
        mTarget.Put("align-self", "stretch")
        Return
    End If
    If t = "place-self-auto" Then
        mTarget.Put("justify-self", "auto")
        mTarget.Put("align-self", "auto")
        Return
    End If

    ' Order utilities
    If t = "order-first" Then
        mTarget.Put("order", -9999)
        Return
    End If
    If t = "order-last" Then
        mTarget.Put("order", 9999)
        Return
    End If
    If t = "order-none" Then
        mTarget.Put("order", 0)
        Return
    End If
    If t.StartsWith("order-") Then
        mTarget.Put("order", SafeInt(t.SubString("order-".Length), 0))
        Return
    End If

    ' Visibility
    If t = "hidden" Then
        mTarget.Put("hidden", True)
        Return
    End If
    If t = "block" Then
        mTarget.Put("hidden", False)
        Return
    End If
    If t = "visible" Then
        mTarget.Put("hidden", False)
        Return
    End If
End Sub

Private Sub NormalizeTrackTemplateValue(sV As String) As String
    If sV = Null Then Return ""
    Dim s As String = sV.Trim
    If s = "" Then Return ""

    ' Tailwind arbitrary values can be encoded as: [200px_1fr]
    If s.StartsWith("[") And s.EndsWith("]") And s.Length >= 2 Then
        s = s.SubString2(1, s.Length - 1)
    End If

    ' Tailwind uses underscores to represent spaces inside class tokens
    s = s.Replace("_", " ")
    Return s.Trim
End Sub

Private Sub InferColumnCountFromTemplate(sTemplate As String) As Int
    If sTemplate = Null Then Return 0
    Dim t As String = sTemplate.Trim.ToLowerCase
    If t = "" Or t = "none" Or t = "subgrid" Then Return 0

    ' Handle repeat(n, ...)
    If t.StartsWith("repeat(") And t.EndsWith(")") Then
        Dim inner As String = t.SubString2(7, t.Length - 1)
        Dim commaIndex As Int = FindTopLevelComma(inner)
        If commaIndex > 0 Then
            Dim countPart As String = inner.SubString2(0, commaIndex).Trim
            If IsNumeric(countPart) Then
                Return Max(1, SafeInt(countPart, 0))
            End If
        End If
    End If

    Dim parts As List = SplitTrackTemplate(t)
    Return parts.Size
End Sub

Private Sub FindTopLevelComma(sValue As String) As Int
    Dim depth As Int = 0
    For i = 0 To sValue.Length - 1
        Dim ch As String = sValue.SubString2(i, i + 1)
        If ch = "(" Then
            depth = depth + 1
        Else If ch = ")" Then
            depth = Max(0, depth - 1)
        Else If ch = "," And depth = 0 Then
            Return i
        End If
    Next
    Return -1
End Sub

Private Sub ResolveContainerConfig(fWidth As Float) As GridResolvedConfig
    Dim activeRules As Map = ResolveMergedRules(mParsedContainerBase, mParsedContainerBp, fWidth)

    Dim rc As GridResolvedConfig
    rc.Initialize
    rc.Cols = mColsFallback
    rc.GapX = IIf(mGapXFallback >= 0, mGapXFallback, mGapFallback)
    rc.GapY = IIf(mGapYFallback >= 0, mGapYFallback, mGapFallback)
    rc.PadL = mPaddingAll
    rc.PadT = mPaddingAll
    rc.PadR = mPaddingAll
    rc.PadB = mPaddingAll
    rc.AutoRowsTemplate = mAutoRowsTemplate
    rc.AutoColsTemplate = ""
    rc.TemplateRows = mTemplateRows
    rc.Dense = mDense
    rc.GridFlow = "row"
    rc.JustifyItems = "stretch"
    rc.AlignItems = "stretch"

    ' Apply rules from class
    If activeRules.ContainsKey("grid-cols") Then
        Dim colsVal As Object = activeRules.Get("grid-cols")
        If colsVal Is Int Then
            rc.Cols = Max(1, colsVal)
        Else If colsVal Is String Then
            Dim inferredCols As Int = InferColumnCountFromTemplate(colsVal)
            If inferredCols > 0 Then rc.Cols = inferredCols
        End If
    End If
    
    If activeRules.ContainsKey("gap") Then
        Dim g As Float = activeRules.Get("gap")
        rc.GapX = g
        rc.GapY = g
    End If
    If activeRules.ContainsKey("gap-x") Then rc.GapX = activeRules.Get("gap-x")
    If activeRules.ContainsKey("gap-y") Then rc.GapY = activeRules.Get("gap-y")

    If activeRules.ContainsKey("p") Then
        Dim p As Float = activeRules.Get("p")
        rc.PadL = p
        rc.PadT = p
        rc.PadR = p
        rc.PadB = p
    End If
    If activeRules.ContainsKey("px") Then
        Dim px As Float = activeRules.Get("px")
        rc.PadL = px
        rc.PadR = px
    End If
    If activeRules.ContainsKey("py") Then
        Dim py As Float = activeRules.Get("py")
        rc.PadT = py
        rc.PadB = py
    End If
    If activeRules.ContainsKey("pl") Then rc.PadL = activeRules.Get("pl")
    If activeRules.ContainsKey("pt") Then rc.PadT = activeRules.Get("pt")
    If activeRules.ContainsKey("pr") Then rc.PadR = activeRules.Get("pr")
    If activeRules.ContainsKey("pb") Then rc.PadB = activeRules.Get("pb")
    
    If activeRules.ContainsKey("grid-rows") Then rc.TemplateRows = activeRules.Get("grid-rows")
    If activeRules.ContainsKey("auto-rows") Then rc.AutoRowsTemplate = activeRules.Get("auto-rows")
    If activeRules.ContainsKey("auto-cols") Then rc.AutoColsTemplate = activeRules.Get("auto-cols")
    If activeRules.ContainsKey("grid-flow") Then rc.GridFlow = activeRules.Get("grid-flow")
    If activeRules.ContainsKey("dense") Then rc.Dense = activeRules.Get("dense")
    If activeRules.ContainsKey("justify-items") Then rc.JustifyItems = activeRules.Get("justify-items")
    If activeRules.ContainsKey("align-items") Then rc.AlignItems = activeRules.Get("align-items")

    If activeRules.ContainsKey("_padl") Then rc.PadL = activeRules.Get("_padl")
    If activeRules.ContainsKey("_padt") Then rc.PadT = activeRules.Get("_padt")
    If activeRules.ContainsKey("_padr") Then rc.PadR = activeRules.Get("_padr")
    If activeRules.ContainsKey("_padb") Then rc.PadB = activeRules.Get("_padb")

    Return rc
End Sub

Private Sub ResolveItemConfig(mRec As Map, fWidth As Float, iTotalCols As Int) As GridItemResolved
    Dim merged As Map = ResolveMergedRules(mRec.Get("BaseRules"), mRec.Get("BpRules"), fWidth)

    Dim ir As GridItemResolved
    ir.Initialize
    ir.ColSpan = 1
    ir.RowSpan = 1
    ir.ColStart = 0
    ir.RowStart = 0
    ir.ColEnd = 0
    ir.RowEnd = 0
    ir.Order = mRec.Get("Order")
    ir.Hidden = Not(mRec.Get("Visible"))
    ir.JustifySelf = "stretch"
    ir.AlignSelf = "stretch"

    If merged.ContainsKey("col-span") Then
        Dim csVal As Int = merged.Get("col-span")
        If csVal = -1 Then
            ir.ColSpan = iTotalCols  ' col-span-full
        Else
            ir.ColSpan = Max(1, Min(iTotalCols, csVal))
        End If
    End If
    If merged.ContainsKey("row-span") Then
        Dim rsVal As Int = merged.Get("row-span")
        If rsVal = -1 Then
            ir.RowSpan = 1  ' row-span-full handled at placement time
        Else
            ir.RowSpan = Max(1, rsVal)
        End If
    End If
    If merged.ContainsKey("col-start") Then ir.ColStart = Max(0, merged.Get("col-start"))
    If merged.ContainsKey("row-start") Then ir.RowStart = Max(0, merged.Get("row-start"))
    If merged.ContainsKey("col-end") Then ir.ColEnd = Max(0, merged.Get("col-end"))
    If merged.ContainsKey("row-end") Then ir.RowEnd = Max(0, merged.Get("row-end"))

    ' Derive span from start+end if both specified
    If ir.ColStart > 0 And ir.ColEnd > ir.ColStart Then
        ir.ColSpan = ir.ColEnd - ir.ColStart
    End If
    If ir.RowStart > 0 And ir.RowEnd > ir.RowStart Then
        ir.RowSpan = ir.RowEnd - ir.RowStart
    End If

    If merged.ContainsKey("justify-self") Then ir.JustifySelf = merged.Get("justify-self")
    If merged.ContainsKey("align-self") Then ir.AlignSelf = merged.Get("align-self")
    If merged.ContainsKey("hidden") Then ir.Hidden = merged.Get("hidden")
    If merged.ContainsKey("order") Then ir.Order = merged.Get("order")

    ' Validate and adjust explicit start positions
    If ir.ColStart > 0 Then
        If ir.ColStart > iTotalCols Then ir.ColStart = iTotalCols
        If ir.ColStart + ir.ColSpan - 1 > iTotalCols Then 
            ir.ColStart = Max(1, iTotalCols - ir.ColSpan + 1)
        End If
    End If

    Return ir
End Sub

Private Sub ResolveMergedRules(mBaseRules As Map, mBpRules As Map, fWidth As Float) As Map
    Dim merged As Map
    merged.Initialize

    ' Start with base rules
    For Each k As String In mBaseRules.Keys
        merged.Put(k, mBaseRules.Get(k))
    Next

    ' Apply breakpoint rules in ascending order (mobile-first)
    Dim names As List = GetBreakpointNamesSorted
    For Each bp As String In names
        If fWidth >= mBreakpoints.Get(bp) And mBpRules.ContainsKey(bp) Then
            Dim rm As Map = mBpRules.Get(bp)
            For Each k2 As String In rm.Keys
                merged.Put(k2, rm.Get(k2))
            Next
        End If
    Next

    Return merged
End Sub

Private Sub RebuildBreakpointsCache
    Dim names As List
    names.Initialize
    For Each k As String In mBreakpoints.Keys
        names.Add(k)
    Next

    ' Sort by min-width ascending (mobile-first)
    For i = 1 To names.Size - 1
        Dim cur As String = names.Get(i)
        Dim j As Int = i - 1
        Do While j >= 0
            Dim a As String = names.Get(j)
            If mBreakpoints.Get(a) <= mBreakpoints.Get(cur) Then Exit
            names.Set(j + 1, a)
            j = j - 1
        Loop
        names.Set(j + 1, cur)
    Next
    mSortedBreakpointsCache = names
End Sub

Private Sub GetBreakpointNamesSorted As List
    Return mSortedBreakpointsCache
End Sub

' -
' Internal - Ordering
' -
Private Sub GetSortedVisibleItems(fWidth As Float) As List
    Dim tmp As List
    tmp.Initialize
    For Each rec As Map In mItems
        ParseItemClassIfNeeded(rec)
        tmp.Add(rec)
    Next

    ' Cache cols once for sort comparisons (BUG-3 fix)
    Dim cachedCols As Int = Max(1, ResolveContainerConfig(fWidth).Cols)

    ' Sort by order, then by insertion index
    For i = 1 To tmp.Size - 1
        Dim cur As Map = tmp.Get(i)
        Dim j As Int = i - 1
        Do While j >= 0
            Dim a As Map = tmp.Get(j)
            If CompareItemRecords(a, cur, fWidth, cachedCols) <= 0 Then Exit
            tmp.Set(j + 1, a)
            j = j - 1
        Loop
        tmp.Set(j + 1, cur)
    Next
    Return tmp
End Sub

Private Sub CompareItemRecords(mA As Map, mB As Map, fWidth As Float, iCachedCols As Int) As Int
    Dim ra As GridItemResolved = ResolveItemConfig(mA, fWidth, iCachedCols)
    Dim rb As GridItemResolved = ResolveItemConfig(mB, fWidth, iCachedCols)

    ' Compare order
    If ra.Order <> rb.Order Then Return IIf(ra.Order < rb.Order, -1, 1)

    ' Then by explicit position (items with explicit positions come first)
    Dim aExplicit As Boolean = (ra.ColStart > 0 Or ra.RowStart > 0)
    Dim bExplicit As Boolean = (rb.ColStart > 0 Or rb.RowStart > 0)
    If aExplicit <> bExplicit Then
        Return IIf(aExplicit, -1, 1)
    End If

    ' Finally by insertion index
    Dim ia As Int = mA.Get("InsertIndex")
    Dim ib As Int = mB.Get("InsertIndex")
    If ia <> ib Then Return IIf(ia < ib, -1, 1)
    Return 0
End Sub

' -
' Internal - Item records
' -
Private Sub CreateItemRecord(sKey As String, vItemView As B4XView, sClassText As String) As Map
    Dim rec As Map
    rec.Initialize
    rec.Put("Key", sKey)
    rec.Put("View", vItemView)
    rec.Put("ClassText", IIf(sClassText = Null, "", sClassText))
    rec.Put("Visible", True)
    rec.Put("Order", 0)
    rec.Put("InsertIndex", mItems.Size)
    rec.Put("BaseRules", CreateMap())
    rec.Put("BpRules", CreateMap())
    rec.Put("ClassDirty", True)
    Return rec
End Sub

Private Sub GetItemIndex(sKey As String) As Int
    If mItemByKey.ContainsKey(sKey) = False Then Return -1
    Return mItemByKey.Get(sKey)
End Sub

Private Sub GetItemRecord(sKey As String) As Map
    Dim idx As Int = GetItemIndex(sKey)
    If idx < 0 Then
        Dim mm As Map
        Return mm
    End If
    Return mItems.Get(idx)
End Sub

Private Sub RebuildItemIndexMap
    mItemByKey.Clear
    For i = 0 To mItems.Size - 1
        Dim rec As Map = mItems.Get(i)
        mItemByKey.Put(rec.Get("Key"), i)
        rec.Put("InsertIndex", i)
    Next
End Sub

Private Sub GenerateKey As String
    mInternalKeyCounter = mInternalKeyCounter + 1
    Return "griditem_" & mInternalKeyCounter
End Sub

Private Sub IsRegisteredView(vView As B4XView) As Boolean
    For Each rec As Map In mItems
        If rec.Get("View") = vView Then Return True
    Next
    Return False
End Sub

' -
' Internal - Debug overlay
' -
Private Sub EnsureDebugOverlayPanel
    If mBase.IsInitialized = False Then Return
    If mDebugOverlayPanel.IsInitialized = False Then
        mDebugOverlayPanel = xui.CreatePanel("")
        mDebugOverlayPanel.Color = xui.Color_Transparent
    End If

    If mDebugOverlay Then
        If mDebugOverlayPanel.Parent.IsInitialized = False Then
            mBase.AddView(mDebugOverlayPanel, 0, 0, mBase.Width, mBase.Height)
        End If
        mDebugOverlayPanel.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
        TryBringOverlayToFront
    Else
        If mDebugOverlayPanel.Parent.IsInitialized Then mDebugOverlayPanel.RemoveViewFromParent
    End If
End Sub

Private Sub TryBringOverlayToFront
    Try
        mDebugOverlayPanel.BringToFront
    Catch
    	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyGrid.TryBringOverlayToFront: " & LastException.Message)
    End Try 'ignore
End Sub

Private Sub UpdateDebugOverlay(rc As GridResolvedConfig, iTotalRows As Int, fContentH As Float)
    If mDebugOverlay = False Then Return
    If mDebugOverlayPanel.IsInitialized = False Then Return
    If mDebugOverlayPanel.Parent.IsInitialized = False Then Return

    mDebugOverlayPanel.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
    mDebugOverlayPanel.RemoveAllViews

    ' Draw column lines
    For c = 1 To rc.Cols
        Dim x As Float = rc.PadL
        For i = 1 To c - 1
            x = x + mColumnWidths.Get(i - 1) + rc.GapX
        Next
        
        ' Draw vertical line
        Dim line As B4XView = xui.CreatePanel("")
        line.Color = 0x55FF0000
        mDebugOverlayPanel.AddView(line, x, rc.PadT, 1dip, fContentH - rc.PadT - rc.PadB)
        
        ' Column number
        Dim lbl As Label
        lbl.Initialize("")
        Dim xl As B4XView = lbl
        xl.TextColor = 0xAAFF0000
        xl.Font = xui.CreateDefaultFont(10)
        xl.Text = "C" & c
        mDebugOverlayPanel.AddView(xl, x + 2dip, rc.PadT, 28dip, 12dip)
    Next

    ' Draw row lines
    Dim yPos As Float = rc.PadT
    For r = 1 To iTotalRows
        ' Draw horizontal line
        Dim lineH As B4XView = xui.CreatePanel("")
        lineH.Color = 0x550000FF
        mDebugOverlayPanel.AddView(lineH, rc.PadL, yPos, mBase.Width - rc.PadL - rc.PadR, 1dip)
        
        ' Row number
        Dim lbl2 As Label
        lbl2.Initialize("")
        Dim yl As B4XView = lbl2
        yl.TextColor = 0xAA0000FF
        yl.Font = xui.CreateDefaultFont(10)
        yl.Text = "R" & r
        mDebugOverlayPanel.AddView(yl, rc.PadL + 2dip, yPos + 2dip, 28dip, 12dip)
        
        yPos = yPos + mRowHeights.Get(r - 1) + rc.GapY
    Next

    TryBringOverlayToFront
End Sub

' -
' Internal - Events / snapshots / diff
' -
Private Sub RaiseBeforePlace(sKey As String, mInfo As Map)
    If xui.SubExists(mCallBack, mEventName & "_BeforePlace", 2) Then
        CallSub3(mCallBack, mEventName & "_BeforePlace", sKey, mInfo)
    End If
End Sub

Private Sub RaiseAfterPlace(sKey As String, mInfo As Map)
    If xui.SubExists(mCallBack, mEventName & "_AfterPlace", 2) Then
        CallSub3(mCallBack, mEventName & "_AfterPlace", sKey, mInfo)
    End If
End Sub

Private Sub BuildPlaceInfo(mRec As Map, gp As GridPlacement) As Map
    Dim info As Map
    info.Initialize
    info.Put("Key", mRec.Get("Key"))
    info.Put("ClassText", mRec.Get("ClassText"))
    info.Put("Visible", mRec.Get("Visible"))
    info.Put("Breakpoint", mLastActiveBreakpoint)
    info.Put("Col", gp.Col)
    info.Put("Row", gp.Row)
    info.Put("ColSpan", gp.ColSpan)
    info.Put("RowSpan", gp.RowSpan)
    info.Put("X", gp.X)
    info.Put("Y", gp.Y)
    info.Put("W", gp.W)
    info.Put("H", gp.H)
    Return info
End Sub

Private Sub BuildCurrentLayoutSnapshotByKey As Map
    Dim snap As Map
    snap.Initialize
    For Each rec As Map In mItems
        Dim key As String = rec.Get("Key")
        Dim row As Map
        row.Initialize
        row.Put("Visible", rec.Get("Visible"))
        row.Put("ClassText", rec.Get("ClassText"))

        If mPlacementByKey.ContainsKey(key) Then
            Dim gp As GridPlacement = mPlacementByKey.Get(key)
            row.Put("Placed", True)
            row.Put("X", gp.X)
            row.Put("Y", gp.Y)
            row.Put("W", gp.W)
            row.Put("H", gp.H)
            row.Put("Col", gp.Col)
            row.Put("Row", gp.Row)
            row.Put("ColSpan", gp.ColSpan)
            row.Put("RowSpan", gp.RowSpan)
        Else
            row.Put("Placed", False)
        End If
        snap.Put(key, row)
    Next
    Return snap
End Sub

Private Sub BuildLayoutDiff(mPrevSnap As Map, mCurSnap As Map) As List
    Dim changes As List
    changes.Initialize

    Dim keys As Map
    keys.Initialize
    For Each k As String In mPrevSnap.Keys
        keys.Put(k, True)
    Next
    For Each k As String In mCurSnap.Keys
        keys.Put(k, True)
    Next

    For Each key As String In keys.Keys
        Dim a As Map
        Dim b As Map
        If mPrevSnap.ContainsKey(key) Then a = mPrevSnap.Get(key)
        If mCurSnap.ContainsKey(key) Then b = mCurSnap.Get(key)

        Dim changed As Boolean = False
        Dim reason As String = ""

        If a.IsInitialized = False Then
            changed = True
            reason = "added"
        Else If b.IsInitialized = False Then
            changed = True
            reason = "removed"
        Else
            Dim aPlaced As Boolean = a.GetDefault("Placed", False)
            Dim bPlaced As Boolean = b.GetDefault("Placed", False)

            If aPlaced <> bPlaced Then
                changed = True
                reason = "placed-state"
            Else If aPlaced And bPlaced Then
                If a.Get("X") <> b.Get("X") Or a.Get("Y") <> b.Get("Y") Or _
                   a.Get("W") <> b.Get("W") Or a.Get("H") <> b.Get("H") Then
                    changed = True
                    reason = "geometry"
                Else If a.Get("Row") <> b.Get("Row") Or a.Get("Col") <> b.Get("Col") Or _
                       a.Get("RowSpan") <> b.Get("RowSpan") Or a.Get("ColSpan") <> b.Get("ColSpan") Then
                    changed = True
                    reason = "grid-pos"
                End If
            End If

            If changed = False Then
                If a.GetDefault("Visible", True) <> b.GetDefault("Visible", True) Then
                    changed = True
                    reason = "visibility"
                End If
            End If
        End If

        If changed Then
            Dim ch As Map
            ch.Initialize
            ch.Put("Key", key)
            ch.Put("Reason", reason)
            If a.IsInitialized Then ch.Put("Before", a)
            If b.IsInitialized Then ch.Put("After", b)
            changes.Add(ch)
        End If
    Next

    Return changes
End Sub

Private Sub EmitLayoutDiffIfNeeded
    Dim curSnap As Map = BuildCurrentLayoutSnapshotByKey
    If mEmitLayoutDiff = False Then
        mLastLayoutSnapshotByKey = curSnap
        Return
    End If

    Dim diff As List = BuildLayoutDiff(mLastLayoutSnapshotByKey, curSnap)
    mLastLayoutSnapshotByKey = curSnap

    If diff.Size > 0 And xui.SubExists(mCallBack, mEventName & "_LayoutDiff", 1) Then
        CallSub2(mCallBack, mEventName & "_LayoutDiff", diff)
    End If
End Sub

' -
' Internal - Tag helpers
' -
Private Sub ExtractGridMetaFromTag(oTagObj As Object) As Map
    Dim meta As Map
    If oTagObj = Null Then Return meta
    If oTagObj Is Map Then
        meta = oTagObj
        If meta.IsInitialized Then Return meta
    End If
    Return meta
End Sub

Private Sub ParseMetaFloat(oV As Object, fDefaultValue As Float) As Float
    If oV = Null Then Return fDefaultValue
    Try
        If oV Is String Then
            Return ParseSpacingValue(oV, fDefaultValue)
        Else
            Return oV
        End If
    Catch
        Return fDefaultValue
    End Try
End Sub

Private Sub GetItemAnimMsFromTag(vView As B4XView) As Int
    Dim meta As Map = ExtractGridMetaFromTag(vView.Tag)
    If meta.IsInitialized = False Then Return mDefaultAnimMs
    If meta.ContainsKey("gridAnimMs") Then
        Try
            Return Max(0, meta.Get("gridAnimMs"))
        Catch
        	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyGrid.GetItemAnimMsFromTag: " & LastException.Message)
        End Try 'ignore
    End If
    Return mDefaultAnimMs
End Sub

Private Sub GetItemMarginFromTag(vView As B4XView) As Map
    Dim m As Map = CreateMap("l":0, "t":0, "r":0, "b":0)
    Dim meta As Map = ExtractGridMetaFromTag(vView.Tag)
    If meta.IsInitialized = False Then Return m

    If meta.ContainsKey("gridMargin") Then
        Dim allv As Float = ParseMetaFloat(meta.Get("gridMargin"), 0)
        m.Put("l", allv)
        m.Put("t", allv)
        m.Put("r", allv)
        m.Put("b", allv)
    End If
    If meta.ContainsKey("gridMarginX") Then
        Dim mx As Float = ParseMetaFloat(meta.Get("gridMarginX"), 0)
        m.Put("l", mx)
        m.Put("r", mx)
    End If
    If meta.ContainsKey("gridMarginY") Then
        Dim my As Float = ParseMetaFloat(meta.Get("gridMarginY"), 0)
        m.Put("t", my)
        m.Put("b", my)
    End If

    If meta.ContainsKey("gridMarginL") Then m.Put("l", ParseMetaFloat(meta.Get("gridMarginL"), m.Get("l")))
    If meta.ContainsKey("gridMarginT") Then m.Put("t", ParseMetaFloat(meta.Get("gridMarginT"), m.Get("t")))
    If meta.ContainsKey("gridMarginR") Then m.Put("r", ParseMetaFloat(meta.Get("gridMarginR"), m.Get("r")))
    If meta.ContainsKey("gridMarginB") Then m.Put("b", ParseMetaFloat(meta.Get("gridMarginB"), m.Get("b")))
    Return m
End Sub

Private Sub ApplyMarginShim(fX As Float, fY As Float, fW As Float, fH As Float, mMarginMap As Map) As Map
    Dim result As Map
    result.Initialize

    If mMarginMap.IsInitialized = False Then
        result.Put("x", fX)
        result.Put("y", fY)
        result.Put("w", fW)
        result.Put("h", fH)
        Return result
    End If

    Dim l As Float = mMarginMap.Get("l")
    Dim t As Float = mMarginMap.Get("t")
    Dim r As Float = mMarginMap.Get("r")
    Dim b As Float = mMarginMap.Get("b")

    fX = fX + l
    fY = fY + t
    fW = Max(0, fW - l - r)
    fH = Max(0, fH - t - b)

    result.Put("x", fX)
    result.Put("y", fY)
    result.Put("w", fW)
    result.Put("h", fH)
    Return result
End Sub

' -
' Internal - Utility mutation helpers
' -
Private Sub NormalizeBp(sBp As String) As String
    If sBp = Null Then Return ""
    sBp = sBp.Trim.ToLowerCase
    If sBp = "" Then Return ""
    If mBreakpoints.ContainsKey(sBp) Then Return sBp
    Return ""
End Sub

Private Sub SplitBpToken(sToken As String) As Map
    Dim t As String = sToken.Trim
    If t = "" Then Return CreateMap("bp":"", "body":"")
    Dim p As Int = t.IndexOf(":")
    If p > 0 Then
        Dim pref As String = t.SubString2(0, p).ToLowerCase
        If mBreakpoints.ContainsKey(pref) Then
            Return CreateMap("bp":pref, "body":t.SubString(p + 1))
        End If
    End If
    Return CreateMap("bp":"", "body":t)
End Sub

Private Sub JoinBpToken(sBp As String, sBody As String) As String
    If sBp = "" Then Return sBody
    Return sBp & ":" & sBody
End Sub

Private Sub JoinClassTokens(lstTokens As List) As String
    Dim sb As StringBuilder
    sb.Initialize
    For i = 0 To lstTokens.Size - 1
        Dim t As String = lstTokens.Get(i)
        If t = "" Then Continue
        If sb.Length > 0 Then sb.Append(" ")
        sb.Append(t)
    Next
    Return sb.ToString.Trim
End Sub

Private Sub ReplaceOrAppendUtility(sClassText As String, sBp As String, sUtilityPrefix As String, sNewTokenBody As String) As String
    If sClassText = Null Then sClassText = ""
    Dim parts() As String = Regex.Split("\s+", sClassText.Trim)

    Dim out As List
    out.Initialize
    Dim replaced As Boolean = False

    For Each tok As String In parts
        If tok = "" Then Continue
        Dim info As Map = SplitBpToken(tok)
        Dim tBp As String = info.Get("bp")
        Dim tBody As String = info.Get("body")

        If tBp = sBp And tBody.StartsWith(sUtilityPrefix) Then
            If replaced = False Then
                out.Add(JoinBpToken(sBp, sNewTokenBody))
                replaced = True
            End If
        Else
            out.Add(tok)
        End If
    Next

    If replaced = False Then out.Add(JoinBpToken(sBp, sNewTokenBody))
    Return JoinClassTokens(out)
End Sub

Private Sub RemoveExactUtility(sClassText As String, sBp As String, sExactBody As String) As String
    If sClassText = Null Then sClassText = ""
    Dim parts() As String = Regex.Split("\s+", sClassText.Trim)

    Dim out As List
    out.Initialize

    For Each tok As String In parts
        If tok = "" Then Continue
        Dim info As Map = SplitBpToken(tok)
        If info.Get("bp") = sBp And info.Get("body") = sExactBody Then
            ' skip
        Else
            out.Add(tok)
        End If
    Next

    Return JoinClassTokens(out)
End Sub

Private Sub RemoveUtilityPattern(sClassText As String, sBp As String, sUtilityPrefix As String) As String
    If sClassText = Null Then sClassText = ""
    Dim parts() As String = Regex.Split("\s+", sClassText.Trim)

    Dim out As List
    out.Initialize

    For Each tok As String In parts
        If tok = "" Then Continue
        Dim info As Map = SplitBpToken(tok)
        Dim tBp As String = info.Get("bp")
        Dim tBody As String = info.Get("body")
        If tBp = sBp And tBody.StartsWith(sUtilityPrefix) Then
            ' skip
        Else
            out.Add(tok)
        End If
    Next

    Return JoinClassTokens(out)
End Sub

' -
' Internal - Numeric parsing
' -
Private Sub ParseSpacingToken(sToken As String, fDefaultValue As Float) As Float
    sToken = sToken.Trim.ToLowerCase
    If sToken = "" Then Return fDefaultValue

    ' Handle arbitrary bracket values: [16px], [2rem], [100dip]
    If sToken.StartsWith("[") And sToken.EndsWith("]") Then
        Dim inner As String = sToken.SubString2(1, sToken.Length - 1).Trim
        Return ParseSpacingValue(inner, fDefaultValue)
    End If

    ' Handle Tailwind spacing scale
    Dim spacingMap As Map = CreateMap( _
        "0": 0dip, "px": 1dip, "0.5": 2dip, "1": 4dip, "1.5": 6dip, _
        "2": 8dip, "2.5": 10dip, "3": 12dip, "3.5": 14dip, "4": 16dip, _
        "5": 20dip, "6": 24dip, "7": 28dip, "8": 32dip, "9": 36dip, _
        "10": 40dip, "11": 44dip, "12": 48dip, "14": 56dip, "16": 64dip, _
        "20": 80dip, "24": 96dip, "28": 112dip, "32": 128dip, "36": 144dip, _
        "40": 160dip, "44": 176dip, "48": 192dip, "52": 208dip, "56": 224dip, _
        "60": 240dip, "64": 256dip, "72": 288dip, "80": 320dip, "96": 384dip _
    )
    
    If spacingMap.ContainsKey(sToken) Then
        Return spacingMap.Get(sToken)
    End If

    If sToken.Contains("px") Or sToken.Contains("dip") Or sToken.Contains("rem") Then
        Return ParseSpacingValue(sToken, fDefaultValue)
    End If

    Try
        Dim n As Double = sToken
        Return n * 4dip ' Tailwind default scale
    Catch
        Return fDefaultValue
    End Try
End Sub

Private Sub ParseSpacingValue(sV As String, fDefaultValue As Float) As Float
    If sV = Null Then Return fDefaultValue
    Dim s As String = sV.Trim.ToLowerCase
    If s = "" Then Return fDefaultValue

    Try
        If s.EndsWith("dip") Then
            Return s.SubString2(0, s.Length - 3)
        Else If s.EndsWith("px") Then
            Return s.SubString2(0, s.Length - 2)
        Else If s.EndsWith("rem") Then
            Dim n As Double = s.SubString2(0, s.Length - 3)
            Return n * 16dip
        Else
            ' Try direct numeric (no recursion back to ParseSpacingToken)
            Dim num As Double = s
            Return num
        End If
    Catch
        Return fDefaultValue
    End Try
End Sub

Private Sub SafeInt(sValue As String, iDefaultValue As Int) As Int
    Try
        Return sValue
    Catch
        Return iDefaultValue
    End Try
End Sub

Private Sub IsNumeric(sValue As String) As Boolean
    Try
        Dim d As Double = sValue
        Return True
    Catch
        Return False
    End Try
End Sub

Private Sub GetActiveBreakpointName(fWidth As Float) As String
    Dim best As String = ""
    Dim bestW As Float = -1
    For Each k As String In mBreakpoints.Keys
        Dim w As Float = mBreakpoints.Get(k)
        If fWidth >= w And w > bestW Then
            best = k
            bestW = w
        End If
    Next
    Return best
End Sub

' -
' Public API - Diagnostics
' -
Public Sub GetLayoutSnapshot As List
    Dim lst As List
    lst.Initialize
    For Each rec As Map In mItems
        Dim key As String = rec.Get("Key")
        Dim row As Map
        row.Initialize
        row.Put("Key", key)
        row.Put("ClassText", rec.Get("ClassText"))
        row.Put("Visible", rec.Get("Visible"))
        row.Put("Order", rec.Get("Order"))
        If mPlacementByKey.ContainsKey(key) Then
            Dim gp As GridPlacement = mPlacementByKey.Get(key)
            row.Put("Placed", True)
            row.Put("Col", gp.Col)
            row.Put("Row", gp.Row)
            row.Put("ColSpan", gp.ColSpan)
            row.Put("RowSpan", gp.RowSpan)
            row.Put("X", gp.X)
            row.Put("Y", gp.Y)
            row.Put("W", gp.W)
            row.Put("H", gp.H)
        Else
            row.Put("Placed", False)
        End If
        lst.Add(row)
    Next
    Return lst
End Sub

Public Sub DebugDumpSnapshot As String
    Dim sb As StringBuilder
    sb.Initialize
    sb.Append("Grid Snapshot").Append(CRLF)
    sb.Append("Active BP: ").Append(IIf(mLastActiveBreakpoint = "", "(base)", mLastActiveBreakpoint)).Append(CRLF)
    sb.Append("Columns: ").Append(mLastResolvedConfig.Cols).Append(CRLF)
    sb.Append("Rows: ").Append(mGridCells.Size).Append(CRLF)
    
    For Each m As Map In GetLayoutSnapshot
        sb.Append("- ").Append(m.Get("Key"))
        sb.Append(" | vis=").Append(m.Get("Visible"))
        sb.Append(" | order=").Append(m.Get("Order"))
        If m.Get("Placed") Then
            sb.Append(" | r").Append(m.Get("Row")).Append(" c").Append(m.Get("Col"))
            sb.Append(" | rs").Append(m.Get("RowSpan")).Append(" cs").Append(m.Get("ColSpan"))
            sb.Append(" | ").Append(NumberFormat2(m.Get("W"),1,1,1,False)).Append("x").Append(NumberFormat2(m.Get("H"),1,1,1,False))
        Else
            sb.Append(" | not placed")
        End If
        sb.Append(CRLF)
    Next
    Return sb.ToString
End Sub

Public Sub GetCollisionDiagnostics As List
    Dim lst As List
    lst.Initialize
    For Each c As GridDiagCollision In mLastCollisionDiagnostics
        lst.Add(c)
    Next
    Return lst
End Sub

Public Sub GetCollisionReport As String
    Dim sb As StringBuilder
    sb.Initialize
    sb.Append("Grid collision report").Append(CRLF)
    sb.Append("Active BP: ").Append(IIf(mLastActiveBreakpoint = "", "(base)", mLastActiveBreakpoint)).Append(CRLF)
    If mLastCollisionDiagnostics.Size = 0 Then
        sb.Append("No explicit placement collisions detected.").Append(CRLF)
        Return sb.ToString
    End If
    For Each c As GridDiagCollision In mLastCollisionDiagnostics
        sb.Append("- ").Append(c.Key)
        sb.Append(": requested [r").Append(c.RequestedRow).Append(" c").Append(c.RequestedCol)
        sb.Append(" rs").Append(c.RequestedRowSpan).Append(" cs").Append(c.RequestedColSpan).Append("]")
        sb.Append(" -> fallback [r").Append(c.FallbackRow).Append(" c").Append(c.FallbackCol).Append("]")
        sb.Append(" (").Append(c.Reason).Append(")").Append(CRLF)
    Next
    Return sb.ToString
End Sub

Public Sub GetResolvedItemRules(sKey As String, fWidth As Float) As Map
    Dim rec As Map = GetItemRecord(sKey)
    Dim out As Map
    out.Initialize
    If rec.IsInitialized = False Then Return out
    ParseItemClassIfNeeded(rec)
    Return ResolveMergedRules(rec.Get("BaseRules"), rec.Get("BpRules"), fWidth)
End Sub

Public Sub GetResolvedItemRulesNow(sKey As String) As Map
    Return GetResolvedItemRules(sKey, mBase.Width)
End Sub

Public Sub GetResolvedContainerRulesNow As Map
    ParseContainerClassIfNeeded
    Return ResolveMergedRules(mParsedContainerBase, mParsedContainerBp, mBase.Width)
End Sub

' -
' Specs / Serialization
' -
Public Sub GetItemSpec(sKey As String) As GridItemSpec
    Dim spec As GridItemSpec
    spec.Initialize
    Dim rec As Map = GetItemRecord(sKey)
    If rec.IsInitialized = False Then Return spec
    spec.Key = rec.Get("Key")
    spec.ClassText = rec.Get("ClassText")
    spec.Visible = rec.Get("Visible")
    spec.Order = rec.Get("Order")
    Return spec
End Sub

Public Sub ApplyItemSpec(Spec As GridItemSpec)
    Dim rec As Map = GetItemRecord(Spec.Key)
    If rec.IsInitialized = False Then Return
    BeginUpdate
    UpdateItemClass(Spec.Key, Spec.ClassText)
    SetItemVisible(Spec.Key, Spec.Visible)
    SetItemOrder(Spec.Key, Spec.Order)
    EndUpdate
End Sub

Public Sub GetAllItemSpecs As List
    Dim lst As List
    lst.Initialize
    For Each rec As Map In mItems
        Dim s As GridItemSpec
        s.Initialize
        s.Key = rec.Get("Key")
        s.ClassText = rec.Get("ClassText")
        s.Visible = rec.Get("Visible")
        s.Order = rec.Get("Order")
        lst.Add(s)
    Next
    Return lst
End Sub

Public Sub ExportLayoutSpecs As List
    Dim out As List
    out.Initialize
    For Each rec As Map In mItems
        Dim m As Map
        m.Initialize
        m.Put("Key", rec.Get("Key"))
        m.Put("ClassText", rec.Get("ClassText"))
        m.Put("Visible", rec.Get("Visible"))
        m.Put("Order", rec.Get("Order"))
        out.Add(m)
    Next
    Return out
End Sub

Public Sub ImportLayoutSpecs(lstSpecs As List, bIgnoreMissing As Boolean)
    If lstSpecs.IsInitialized = False Then Return
    BeginUpdate
    For Each m As Map In lstSpecs
        If m.IsInitialized = False Then Continue
        If m.ContainsKey("Key") = False Then Continue
        Dim key As String = m.Get("Key")
        Dim rec As Map = GetItemRecord(key)
        If rec.IsInitialized = False Then
            Continue
        End If
        If m.ContainsKey("ClassText") Then UpdateItemClass(key, m.Get("ClassText"))
        If m.ContainsKey("Visible") Then SetItemVisible(key, m.Get("Visible"))
        If m.ContainsKey("Order") Then SetItemOrder(key, m.Get("Order"))
    Next
    EndUpdate
End Sub

Public Sub ExportLayoutProfile(sProfileName As String) As Map
    Dim m As Map
    m.Initialize
    m.Put("ProfileName", sProfileName)
    m.Put("Specs", ExportLayoutSpecs)
    m.Put("Width", mBase.Width)
    m.Put("Timestamp", DateTime.Now)
    Return m
End Sub

Public Sub ImportLayoutProfile(mProfile As Map, bIgnoreMissing As Boolean)
    If mProfile.IsInitialized = False Then Return
    If mProfile.ContainsKey("Specs") = False Then Return
    ImportLayoutSpecs(mProfile.Get("Specs"), bIgnoreMissing)
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
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
