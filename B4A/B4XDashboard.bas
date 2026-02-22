B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: ButtonClick (ButtonId As String, ButtonDef As Map)
#Event: PageChanged (PageIndex As Int, PageCount As Int)

#DesignerProperty: Key: RowsPerPage, DisplayName: Rows Per Page, FieldType: Int, DefaultValue: 6, Description: Number of grid rows per page.
#DesignerProperty: Key: ColumnsPerPage, DisplayName: Columns Per Page, FieldType: Int, DefaultValue: 4, Description: Number of grid columns per page when Auto Grid is False.
#DesignerProperty: Key: AutoGrid, DisplayName: Auto Grid, FieldType: Boolean, DefaultValue: False, Description: Automatically calculate rows and columns from available size.
#DesignerProperty: Key: MinCellWidth, DisplayName: Min Cell Width, FieldType: Int, DefaultValue: 72, Description: Minimum tile width in dip used by Auto Grid.
#DesignerProperty: Key: MinCellHeight, DisplayName: Min Cell Height, FieldType: Int, DefaultValue: 100, Description: Minimum tile height in dip used by Auto Grid.
#DesignerProperty: Key: PagePadding, DisplayName: Page Padding, FieldType: Int, DefaultValue: 16, Description: Outer page padding in dip.
#DesignerProperty: Key: CellSpacing, DisplayName: Cell Spacing X, FieldType: Int, DefaultValue: 12, Description: Spacing between grid cells horizontally in dip.
#DesignerProperty: Key: CellSpacingY, DisplayName: Cell Spacing Y, FieldType: Int, DefaultValue: 0, Description: Spacing between grid cells vertically in dip.
#DesignerProperty: Key: ActiveIndicatorColor, DisplayName: Active Dot Color, FieldType: Color, DefaultValue: 0xFF3B82F6, Description: Active page indicator color.
#DesignerProperty: Key: InactiveIndicatorColor, DisplayName: Inactive Dot Color, FieldType: Color, DefaultValue: 0x553B82F6, Description: Inactive page indicator color.
#DesignerProperty: Key: BackgroundImage, DisplayName: Background Image, FieldType: String, DefaultValue:, Description: Full image path or asset file name used as dashboard wallpaper.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Text color for all button labels.
#DesignerProperty: Key: GridTopOffset, DisplayName: Grid Top Offset, FieldType: Int, DefaultValue: 12, Description: Extra top offset in dip applied before the first dashboard row.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 100%, Description: Dashboard width relative to parent. Examples: 100%, 320dip, 300.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 100%, Description: Dashboard height relative to parent. Examples: 100%, 600dip, 300.

'B4XDashboard
'Launcher-style paged dashboard (4 per row), swipe pages and bottom indicators.
'Button model keys: id, label, imagePath, svgPath, badge / badgeCount / badgeText.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object

	Private hsv As HorizontalScrollView
	Private ivBackground As B4XView
	Private pnlIndicators As B4XView
	Private tmrSnap As Timer

	Private Buttons As List
	Private PagePanels As List
	Private IndicatorDots As List

	Private mColumns As Int = 4
	Private mRowsPerPage As Int = 6
	Private mAutoGrid As Boolean = False
	Private mMinCellWidth As Float = 72dip
	Private mMinCellHeight As Float = 100dip
	Private mPagePadding As Float = 16dip
	Private mCellSpacing As Float = 12dip
	Private mCellSpacingY As Float = 0dip
	Private mGridTopOffset As Float = 12dip
	Private mIndicatorAreaHeight As Float = 26dip
	Private mIndicatorSize As Float = 6dip
	Private mIndicatorGap As Float = 8dip
	Private mActiveIndicatorColor As Int = 0xFF3B82F6
	Private mInactiveIndicatorColor As Int = 0x553B82F6
	Private mBackgroundImagePath As String = ""
	Private mTextColor As Int = 0xFFFFFFFF
	Private mWidthSpec As String = "100%"
	Private mHeightSpec As String = "100%"
	Private mBackgroundBitmap As B4XBitmap
	Private EmptyBitmap As B4XBitmap

	Private mCurrentPage As Int = 0
	Private mPageCount As Int = 1
	Private mLastScrollPosition As Int = 0
	Private mIdleTicks As Int = 0
	Private mIgnoreScroll As Boolean = False
	Private mDebugLayoutBorders As Boolean = False
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	Buttons.Initialize
	PagePanels.Initialize
	IndicatorDots.Initialize
	tmrSnap.Initialize("tmrSnap", 70)
	tmrSnap.Enabled = False
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim dummy As Label
	DesignerCreateView(b, dummy, CreateMap())
	Return mBase
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mBase.Color = xui.Color_Transparent
	If Buttons.IsInitialized = False Then Buttons.Initialize
	If PagePanels.IsInitialized = False Then PagePanels.Initialize
	If IndicatorDots.IsInitialized = False Then IndicatorDots.Initialize
	If tmrSnap.IsInitialized = False Then
		tmrSnap.Initialize("tmrSnap", 70)
		tmrSnap.Enabled = False
	End If

	ApplyDesignerProps(Props)
	CreateInternalViews
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	ApplySizeFromParent
	AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	LayoutContainers(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	BuildPages
End Sub

Public Sub Resize(Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(0, 0, 0, Width, Height)
	Base_Resize(Width, Height)
End Sub

Public Sub AddToParent(Parent As B4XView)
	If Parent.IsInitialized = False Then Return
	Dim w As Int = ResolveSizeSpec(mWidthSpec, Parent.Width, Parent.Width)
	Dim h As Int = ResolveSizeSpec(mHeightSpec, Parent.Height, Parent.Height)
	Dim v As B4XView = CreateView(w, h)
	Parent.AddView(v, 0, 0, w, h)
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And hsv.IsInitialized
End Sub

Public Sub SetButtons(NewButtons As List)
	If Buttons.IsInitialized = False Then Buttons.Initialize
	Buttons.Clear
	If NewButtons.IsInitialized Then
		For i = 0 To NewButtons.Size - 1
			Dim raw As Object = NewButtons.Get(i)
			If raw Is Map Then
				Dim m As Map = raw
				Buttons.Add(NormalizeButton(m, i))
			Else
				Buttons.Add(CreateMap("id": "btn-" & i, "label": raw, "imagePath": "", "svgPath": ""))
			End If
		Next
	End If
	mCurrentPage = 0
	BuildPages
End Sub

Public Sub AddButton(Id As String, Label As String, ImagePath As String, SvgPath As String)
	If Buttons.IsInitialized = False Then Buttons.Initialize
	Dim item As Map = CreateMap("id": Id, "label": Label, "imagePath": ImagePath, "svgPath": SvgPath)
	Buttons.Add(NormalizeButton(item, Buttons.Size))
	BuildPages
End Sub

' Adds a single dashboard button using id, label and a full image file path.
Public Sub AddButtonWithImagePath(Id As String, Label As String, FullImagePath As String) As Boolean
	If Buttons.IsInitialized = False Then Buttons.Initialize
	Dim normalizedId As String = SafeString(Id).Trim
	If normalizedId.Length = 0 Then Return False
	If FindButtonIndexById(normalizedId) >= 0 Then Return False

	Dim item As Map = CreateMap( _
		"id": normalizedId, _
		"label": SafeString(Label), _
		"imagePath": SafeString(FullImagePath).Trim, _
		"svgPath": "" _
	)
	Buttons.Add(NormalizeButton(item, Buttons.Size))
	BuildPages
	Return True
End Sub

Public Sub UpdateButton(ButtonId As String, Updates As Map) As Boolean
	Dim idx As Int = FindButtonIndexById(ButtonId)
	If idx < 0 Then Return False
	If Updates.IsInitialized = False Then Return False

	Dim item As Map = Buttons.Get(idx)
	If item.IsInitialized = False Then Return False

	Dim selectedBadgeKey As String = PickBadgeKeyFromUpdates(Updates)
	If selectedBadgeKey.Length > 0 Then
		ClearBadgeKeys(item)
		Dim badgeValue As Object = Updates.Get(selectedBadgeKey)
		If badgeValue <> Null Then
			Dim badgeText As String = SafeString(badgeValue).Trim
			If badgeText.Length > 0 Then item.Put(selectedBadgeKey, badgeValue)
		End If
	End If

	For Each k As Object In Updates.Keys
		Dim key As String = SafeString(k).Trim
		If key.Length > 0 Then
			If key <> "id" And IsBadgeKey(key) = False Then
				Dim value As Object = Updates.Get(k)
				If value = Null Then
					If item.ContainsKey(key) Then item.Remove(key)
				Else
					If key = "label" Or key = "imagePath" Or key = "svgPath" Then
						item.Put(key, SafeString(value))
					Else
						item.Put(key, value)
					End If
				End If
			End If
		End If
	Next
	BuildPages
	Return True
End Sub

Public Sub RemoveButton(ButtonId As String) As Boolean
	Dim idx As Int = FindButtonIndexById(ButtonId)
	If idx < 0 Then Return False
	Buttons.RemoveAt(idx)
	BuildPages
	Return True
End Sub

Public Sub UpdateButtonLabel(ButtonId As String, NewLabel As String) As Boolean
	Return UpdateButtonValue(ButtonId, "label", SafeString(NewLabel))
End Sub

Public Sub UpdateButtonImage(ButtonId As String, NewImagePath As String) As Boolean
	Return UpdateButtonValue(ButtonId, "imagePath", SafeString(NewImagePath))
End Sub

Public Sub UpdateButtonBadge(ButtonId As String, NewBadgeValue As Object) As Boolean
	Dim idx As Int = FindButtonIndexById(ButtonId)
	If idx < 0 Then Return False
	Dim item As Map = Buttons.Get(idx)
	If item.IsInitialized = False Then Return False

	' Keep a single badge source key to avoid stale precedence collisions.
	ClearBadgeKeys(item)

	If NewBadgeValue <> Null Then
		Dim badgeText As String = SafeString(NewBadgeValue).Trim
		If badgeText.Length > 0 Then item.Put("badge", NewBadgeValue)
	End If
	BuildPages
	Return True
End Sub

Public Sub UpdateButtonValue(ButtonId As String, Key As String, Value As Object) As Boolean
	Dim idx As Int = FindButtonIndexById(ButtonId)
	If idx < 0 Then Return False

	Dim item As Map = Buttons.Get(idx)
	If item.IsInitialized = False Then Return False
	Dim k As String = SafeString(Key).Trim
	If k.Length = 0 Then Return False

	If IsBadgeKey(k) Then
		ClearBadgeKeys(item)
		If Value <> Null Then
			Dim badgeText As String = SafeString(Value).Trim
			If badgeText.Length > 0 Then item.Put(k, Value)
		End If
	Else
		If Value = Null Then
			If item.ContainsKey(k) Then item.Remove(k)
		Else
			item.Put(k, Value)
		End If
	End If
	BuildPages
	Return True
End Sub

Public Sub ClearButtons
	If Buttons.IsInitialized Then Buttons.Clear
	mCurrentPage = 0
	BuildPages
End Sub

Public Sub getButtonCount As Int
	If Buttons.IsInitialized = False Then Return 0
	Return Buttons.Size
End Sub

Public Sub getButtonsPerPage As Int
	Return Max(1, mColumns * Max(1, mRowsPerPage))
End Sub

Public Sub getPageCount As Int
	Return mPageCount
End Sub

Public Sub getCurrentPage As Int
	Return mCurrentPage
End Sub

Public Sub SetCurrentPage(Index As Int)
	ScrollToPage(Index, True)
End Sub

Public Sub setRowsPerPage(Value As Int)
	mRowsPerPage = Max(1, Value)
	BuildPages
End Sub

Public Sub getRowsPerPage As Int
	Return mRowsPerPage
End Sub

Public Sub setColumnsPerPage(Value As Int)
	mColumns = Max(1, Value)
	BuildPages
End Sub

Public Sub getColumnsPerPage As Int
	Return mColumns
End Sub

Public Sub setAutoGrid(Value As Boolean)
	mAutoGrid = Value
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If
	BuildPages
End Sub

Public Sub getAutoGrid As Boolean
	Return mAutoGrid
End Sub

Public Sub setMinCellWidth(Value As Int)
	mMinCellWidth = Max(1dip, Value * 1dip)
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If
	BuildPages
End Sub

Public Sub getMinCellWidth As Float
	Return mMinCellWidth
End Sub

Public Sub setMinCellHeight(Value As Int)
	mMinCellHeight = Max(1dip, Value * 1dip)
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If
	BuildPages
End Sub

Public Sub getMinCellHeight As Float
	Return mMinCellHeight
End Sub

Public Sub setPagePadding(Value As Int)
	mPagePadding = Max(0, Value * 1dip)
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If
	BuildPages
End Sub

Public Sub getPagePadding As Float
	Return mPagePadding
End Sub

Public Sub setCellSpacing(Value As Int)
	mCellSpacing = Max(0, Value * 1dip)
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If
	BuildPages
End Sub

Public Sub getCellSpacing As Float
	Return mCellSpacing
End Sub

Public Sub setGridTopOffset(Value As Int)
	mGridTopOffset = Max(0, Value * 1dip)
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If
	BuildPages
End Sub

Public Sub getGridTopOffset As Float
	Return mGridTopOffset
End Sub

Public Sub setActiveIndicatorColor(Value As Int)
	mActiveIndicatorColor = Value
	UpdateIndicators(mCurrentPage)
End Sub

Public Sub getActiveIndicatorColor As Int
	Return mActiveIndicatorColor
End Sub

Public Sub setActiveIndicatorColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", mActiveIndicatorColor)
	setActiveIndicatorColor(c)
End Sub

Public Sub setInactiveIndicatorColor(Value As Int)
	mInactiveIndicatorColor = Value
	UpdateIndicators(mCurrentPage)
End Sub

Public Sub getInactiveIndicatorColor As Int
	Return mInactiveIndicatorColor
End Sub

Public Sub setInactiveIndicatorColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", mInactiveIndicatorColor)
	setInactiveIndicatorColor(c)
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	BuildPages
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariant(VariantName, mTextColor)
	setTextColor(c)
End Sub

Public Sub setWidth(Value As Object)
	mWidthSpec = NormalizeSizeSpec(Value, "100%")
	ApplySizeFromParent
	BuildPages
End Sub

Public Sub getWidth As String
	Return mWidthSpec
End Sub

Public Sub setHeight(Value As Object)
	mHeightSpec = NormalizeSizeSpec(Value, "100%")
	ApplySizeFromParent
	BuildPages
End Sub

Public Sub getHeight As String
	Return mHeightSpec
End Sub

Public Sub setBackgroundImage(Path As String)
	mBackgroundImagePath = SafeString(Path).Trim
	mBackgroundBitmap = LoadBackgroundBitmapFromPath(mBackgroundImagePath)
	ApplyBackgroundImage
End Sub

Public Sub getBackgroundImage As String
	Return mBackgroundImagePath
End Sub

Private Sub CreateInternalViews
	If ivBackground.IsInitialized Then ivBackground.RemoveViewFromParent
	Dim iv As ImageView
	iv.Initialize("")
	ivBackground = iv
	ivBackground.Enabled = False
	ivBackground.Color = xui.Color_Transparent
	mBase.AddView(ivBackground, 0, 0, 10dip, 10dip)

	If hsv.IsInitialized Then
		Dim oldHsv As B4XView = hsv
		oldHsv.RemoveViewFromParent
	End If
	hsv.Initialize(0, "hsv")
	Dim hsvView As B4XView = hsv
	hsvView.Color = xui.Color_Transparent
	mBase.AddView(hsv, 0, 0, 10dip, 10dip)

	pnlIndicators = xui.CreatePanel("")
	pnlIndicators.Color = xui.Color_Transparent
	mBase.AddView(pnlIndicators, 0, 0, 10dip, 10dip)
End Sub

Private Sub LayoutContainers(Width As Int, Height As Int)
	If hsv.IsInitialized = False Then Return
	If ivBackground.IsInitialized Then
		ivBackground.SetLayoutAnimated(0, 0, 0, Width, Height)
		ApplyBackgroundImage
	End If
	Dim contentH As Int = Max(1dip, Height - mIndicatorAreaHeight)
	Dim hsvView As B4XView = hsv
	hsvView.SetLayoutAnimated(0, 0, 0, Width, contentH)
	pnlIndicators.SetLayoutAnimated(0, 0, contentH, Width, mIndicatorAreaHeight)
End Sub

Private Sub BuildPages
	If hsv.IsInitialized = False Then Return
	If Buttons.IsInitialized = False Then Buttons.Initialize
	If PagePanels.IsInitialized = False Then PagePanels.Initialize
	If mBase.IsInitialized Then
		AutoConfigureGrid(Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	End If

	tmrSnap.Enabled = False
	PagePanels.Clear
	Dim host As B4XView = hsv.Panel
	#If B4A
	' Allow tile children (badges) to overflow across tile bounds.
	Dim joHost As JavaObject = host
	joHost.RunMethod("setClipChildren", Array(False))
	joHost.RunMethod("setClipToPadding", Array(False))
	#End If
	host.RemoveAllViews

	Dim w As Int = Max(1dip, hsv.Width)
	Dim h As Int = Max(1dip, hsv.Height)
	Dim perPage As Int = getButtonsPerPage
	Dim totalButtons As Int = Buttons.Size
	mPageCount = Max(1, Ceil(totalButtons / perPage))

	For pageIndex = 0 To mPageCount - 1
		Dim page As B4XView = xui.CreatePanel("")
		page.Color = xui.Color_Transparent
		#If B4A
		' Keep overflow enabled at page level so badges are not cut.
		Dim joPage As JavaObject = page
		joPage.RunMethod("setClipChildren", Array(False))
		joPage.RunMethod("setClipToPadding", Array(False))
		#End If
		host.AddView(page, pageIndex * w, 0, w, h)
		PagePanels.Add(page)
		LayoutPageButtons(page, pageIndex)
	Next

	host.Width = mPageCount * w
	host.Height = h

	RebuildIndicators
	ScrollToPage(Min(mCurrentPage, mPageCount - 1), False)
End Sub

Private Sub LayoutPageButtons(Page As B4XView, PageIndex As Int)
	Page.RemoveAllViews
	Dim perPage As Int = getButtonsPerPage
	Dim startIndex As Int = PageIndex * perPage
	Dim endIndex As Int = Min(Buttons.Size - 1, startIndex + perPage - 1)
	If startIndex > endIndex Then Return

	Dim cols As Int = Max(1, mColumns)
	Dim rows As Int = Max(1, mRowsPerPage)
	Dim usableW As Float = Max(1dip, Page.Width - (mPagePadding * 2))
	Dim usableH As Float = Max(1dip, Page.Height - (mPagePadding * 2) - mGridTopOffset)
	Dim cellW As Float = Max(44dip, (usableW - (cols - 1) * mCellSpacing) / cols)
	Dim cellH As Float = Max(56dip, (usableH - (rows - 1) * mCellSpacingY) / rows)

	For i = startIndex To endIndex
		Dim slot As Int = i - startIndex
		Dim row As Int = slot / cols
		Dim col As Int = slot Mod cols
		Dim x As Float = mPagePadding + col * (cellW + mCellSpacing)
		Dim y As Float = mPagePadding + mGridTopOffset + row * (cellH + mCellSpacingY)
		Dim buttonDef As Map = Buttons.Get(i)
		CreateButtonTile(Page, buttonDef, x, y, cellW, cellH)
	Next
End Sub

Private Sub CreateButtonTile(Page As B4XView, ButtonDef As Map, Left As Float, Top As Float, Width As Float, Height As Float)
	Dim p As Panel
	p.Initialize("tile")
	Dim tile As B4XView = p
	tile.Tag = ButtonDef
	tile.Color = xui.Color_Transparent
	If mDebugLayoutBorders Then tile.SetColorAndBorder(xui.Color_Transparent, 1dip, xui.Color_Red, 0dip)
	#If B4A
	' Allow badge to render slightly outside tile bounds when nudged upward.
	Dim joTile As JavaObject = tile
	joTile.RunMethod("setClipChildren", Array(False))
	joTile.RunMethod("setClipToPadding", Array(False))
	#End If
	Page.AddView(tile, Left, Top, Width, Height)

	Dim topInset As Float = 2dip
	Dim gap As Float = 4dip
	Dim minLabelH As Float = 34dip
	Dim maxLabelH As Float = Min(42dip, Height * 0.45)
	Dim iconMaxH As Float = Max(20dip, Height - topInset - gap - minLabelH - 2dip)
	Dim iconSize As Float = Min(60dip, Min(Width * 0.75, iconMaxH))
	Dim targetLabelH As Float = Min(maxLabelH, Max(minLabelH, Height * 0.35))
	Dim iconTop As Float = topInset
	Dim iconLeft As Float = (Width - iconSize) / 2
	Dim iconRadius As Float = Min(12dip, iconSize * 0.24)

	Dim iconHost As B4XView = xui.CreatePanel("")
	iconHost.SetColorAndBorder(xui.Color_Transparent, 0dip, xui.Color_Transparent, iconRadius)
	iconHost.Enabled = False
	#If B4A
	Dim joIconHost As JavaObject = iconHost
	joIconHost.RunMethod("setClipToOutline", Array(True))
	#End If
	tile.AddView(iconHost, iconLeft, iconTop, iconSize, iconSize)

	Dim bmp As B4XBitmap = ResolveButtonBitmap(ButtonDef)
	If bmp.IsInitialized Then
		Dim iv As ImageView
		iv.Initialize("")
		Dim xiv As B4XView = iv
		xiv.Enabled = False
		' Calculate "Cover" scaling
		Dim bw As Float = bmp.Width
		Dim bh As Float = bmp.Height
		Dim scale As Float = Max(iconSize / bw, iconSize / bh)
		Dim nw As Float = bw * scale
		Dim nh As Float = bh * scale
		Dim leftOffset As Float = (iconSize - nw) / 2
		Dim topOffset As Float = (iconSize - nh) / 2
		iconHost.AddView(xiv, leftOffset, topOffset, nw, nh)
		xiv.SetBitmap(bmp.Resize(nw, nh, True))
	Else
		Dim lblGlyph As Label
		lblGlyph.Initialize("")
		Dim xlblGlyph As B4XView = lblGlyph
		xlblGlyph.Enabled = False
		xlblGlyph.Text = ResolveFallbackGlyph(ButtonDef)
		xlblGlyph.TextColor = xui.Color_RGB(51, 65, 85)
		xlblGlyph.TextSize = 18
		xlblGlyph.SetTextAlignment("CENTER", "CENTER")
		iconHost.AddView(xlblGlyph, 0, 0, iconHost.Width, iconHost.Height)
	End If

	Dim lbl As Label
	lbl.Initialize("")
	lbl.SingleLine = False
	#If B4A
	' Keep text top-aligned like launcher labels and cap to two lines with ellipsis.
	lbl.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL, Gravity.TOP)
	Dim joLbl As JavaObject = lbl
	joLbl.RunMethod("setIncludeFontPadding", Array(False))
	joLbl.RunMethod("setMaxLines", Array As Object(2))
	Dim trunc As JavaObject
	trunc.InitializeStatic("android.text.TextUtils$TruncateAt")
	joLbl.RunMethod("setEllipsize", Array(trunc.GetField("END")))
	#End If
	Dim xlbl As B4XView = lbl
	xlbl.Enabled = False
	xlbl.Text = SafeString(ButtonDef.Get("label"))
	xlbl.TextColor = mTextColor
	xlbl.TextSize = 12
	#If B4A
	' Avoid overriding native gravity on Android.
	#Else
	xlbl.SetTextAlignment("CENTER", "TOP")
	#End If
	Dim labelTop As Float = iconTop + iconSize + gap
	If labelTop < 0dip Then labelTop = 0dip
	Dim labelH As Float = targetLabelH
	If labelTop + labelH > Height Then labelH = Height - labelTop - 2dip
	labelH = Min(maxLabelH, labelH)
	If labelH < 1dip Then labelH = 1dip
	If mDebugLayoutBorders Then xlbl.SetColorAndBorder(xui.Color_Transparent, 1dip, xui.Color_Red, 2dip)
	tile.AddView(xlbl, 0dip, labelTop, Width, labelH)

	' Add badge last so it stays above icon and label views.
	AddBadgeView(tile, iconLeft, iconTop, iconSize, ButtonDef)
End Sub

Private Sub AddBadgeView(Tile As B4XView, IconLeft As Float, IconTop As Float, IconSize As Float, ButtonDef As Map)
	Dim badgeText As String = ResolveBadgeText(ButtonDef)
	If badgeText.Length = 0 Then Return

	' Match launcher-style badge scale so counts remain readable in real-world use.
	Dim badgeH As Float = 18dip
	Dim badgeW As Float = badgeH
	If badgeText.Length = 2 Then badgeW = 24dip
	If badgeText.Length >= 3 Then badgeW = 30dip

	' Keep badge center on icon top-right corner, then nudge upward.
	Dim badgeLeft As Float = IconLeft + IconSize - (badgeW / 2)
	Dim badgeTop As Float = IconTop - (badgeH / 2) + 1dip
	If badgeLeft < 0dip Then badgeLeft = 0dip
	If badgeLeft + badgeW > Tile.Width Then badgeLeft = Tile.Width - badgeW
	If badgeTop + badgeH > Tile.Height Then badgeTop = Tile.Height - badgeH

	Dim badge As B4XView = xui.CreatePanel("")
	badge.Enabled = False
	Dim badgeBorderWidth As Float = 0dip
	If mDebugLayoutBorders Then badgeBorderWidth = 1dip
	badge.SetColorAndBorder(xui.Color_RGB(239, 68, 68), badgeBorderWidth, xui.Color_Red, badgeH / 2)
	Tile.AddView(badge, badgeLeft, badgeTop, badgeW, badgeH)
	#If B4A
	Dim joBadge As JavaObject = badge
	joBadge.RunMethod("bringToFront", Null)
	#End If

	Dim lblBadge As Label
	lblBadge.Initialize("")
	#If B4A
	lblBadge.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL, Gravity.CENTER_VERTICAL)
	#End If
	Dim xlblBadge As B4XView = lblBadge
	xlblBadge.Enabled = False
	xlblBadge.Text = badgeText
	xlblBadge.TextColor = xui.Color_White
	xlblBadge.TextSize = 10
	If badgeText.Length >= 3 Then xlblBadge.TextSize = 9
	xlblBadge.SetTextAlignment("CENTER", "CENTER")
	badge.AddView(xlblBadge, 0, 0, badgeW, badgeH)
End Sub

Private Sub RebuildIndicators
	If pnlIndicators.IsInitialized = False Then Return
	If IndicatorDots.IsInitialized = False Then IndicatorDots.Initialize

	pnlIndicators.RemoveAllViews
	IndicatorDots.Clear
	If mPageCount <= 1 Then Return

	Dim activeW As Float = mIndicatorSize * 2.6
	Dim slotW As Float = activeW + mIndicatorGap
	Dim totalW As Float = mPageCount * slotW - mIndicatorGap
	Dim startX As Float = (pnlIndicators.Width - totalW) / 2
	Dim y As Float = (pnlIndicators.Height - mIndicatorSize) / 2

	For i = 0 To mPageCount - 1
		Dim dotPanel As Panel
		dotPanel.Initialize("dot")
		Dim dot As B4XView = dotPanel
		dot.Tag = i
		pnlIndicators.AddView(dot, startX + i * slotW, y, activeW, mIndicatorSize)
		IndicatorDots.Add(dot)
	Next

	UpdateIndicators(mCurrentPage)
End Sub

Private Sub UpdateIndicators(ActiveIndex As Int)
	If IndicatorDots.IsInitialized = False Then Return
	If IndicatorDots.Size = 0 Then Return

	Dim activeW As Float = mIndicatorSize * 2.6
	Dim inactiveW As Float = mIndicatorSize
	Dim slotW As Float = activeW + mIndicatorGap
	Dim totalW As Float = IndicatorDots.Size * slotW - mIndicatorGap
	Dim startX As Float = (pnlIndicators.Width - totalW) / 2
	Dim y As Float = (pnlIndicators.Height - mIndicatorSize) / 2

	For i = 0 To IndicatorDots.Size - 1
		Dim dot As B4XView = IndicatorDots.Get(i)
		Dim isActive As Boolean = (i = ActiveIndex)
		Dim w As Float
		Dim c As Int
		If isActive Then
			w = activeW
			c = mActiveIndicatorColor
		Else
			w = inactiveW
			c = mInactiveIndicatorColor
		End If
		Dim x As Float = startX + i * slotW + (activeW - w) / 2
		dot.SetLayoutAnimated(100, x, y, w, mIndicatorSize)
		dot.SetColorAndBorder(c, 0, xui.Color_Transparent, mIndicatorSize / 2)
	Next
End Sub

Private Sub ScrollToPage(Index As Int, RaiseEvent As Boolean)
	If hsv.IsInitialized = False Then Return
	If mPageCount <= 0 Then Return

	Dim clamped As Int = Max(0, Min(mPageCount - 1, Index))
	Dim pageW As Int = Max(1dip, hsv.Width)
	Dim targetPos As Int = clamped * pageW
	Dim changed As Boolean = (clamped <> mCurrentPage)

	mIgnoreScroll = True
	hsv.ScrollPosition = targetPos
	mIgnoreScroll = False

	mCurrentPage = clamped
	UpdateIndicators(mCurrentPage)
	If RaiseEvent And changed Then RaisePageChanged
End Sub

Private Sub SnapToNearestPage
	If hsv.IsInitialized = False Then Return
	If mPageCount <= 1 Then Return
	Dim pageW As Int = Max(1dip, hsv.Width)
	Dim target As Int = Round(hsv.ScrollPosition / pageW)
	ScrollToPage(target, target <> mCurrentPage)
End Sub

Private Sub hsv_ScrollChanged(Position As Int)
	If mIgnoreScroll Then Return
	If mPageCount <= 1 Then Return

	Dim pageW As Int = Max(1dip, hsv.Width)
	Dim nearest As Int = Round(Position / pageW)
	nearest = Max(0, Min(mPageCount - 1, nearest))
	UpdateIndicators(nearest)

	mIdleTicks = 0
	mLastScrollPosition = Position
	tmrSnap.Enabled = True
End Sub

Private Sub tmrSnap_Tick
	If hsv.IsInitialized = False Then
		tmrSnap.Enabled = False
		Return
	End If
	Dim currentPos As Int = hsv.ScrollPosition
	If Abs(currentPos - mLastScrollPosition) <= 1dip Then
		mIdleTicks = mIdleTicks + 1
	Else
		mIdleTicks = 0
		mLastScrollPosition = currentPos
	End If
	If mIdleTicks >= 2 Then
		tmrSnap.Enabled = False
		SnapToNearestPage
	End If
End Sub

Private Sub tile_Click
	Dim v As B4XView = Sender
	If v.IsInitialized = False Then Return
	If v.Tag = Null Then Return
	Dim item As Map = v.Tag
	RaiseButtonClick(item)
End Sub

Private Sub dot_Click
	Dim v As B4XView = Sender
	If v.IsInitialized = False Then Return
	If v.Tag = Null Then Return
	Dim index As Int = v.Tag
	SetCurrentPage(index)
End Sub

Private Sub RaiseButtonClick(ButtonDef As Map)
	Dim id As String = SafeString(ButtonDef.Get("id"))
	If xui.SubExists(mCallBack, mEventName & "_ButtonClick", 2) Then
		CallSub3(mCallBack, mEventName & "_ButtonClick", id, ButtonDef)
	Else If xui.SubExists(mCallBack, mEventName & "_ButtonClick", 1) Then
		CallSub2(mCallBack, mEventName & "_ButtonClick", ButtonDef)
	End If
End Sub

Private Sub RaisePageChanged
	If xui.SubExists(mCallBack, mEventName & "_PageChanged", 2) Then
		CallSub3(mCallBack, mEventName & "_PageChanged", mCurrentPage, mPageCount)
	End If
End Sub

Private Sub ResolveButtonBitmap(ButtonDef As Map) As B4XBitmap
	Dim empty As B4XBitmap
	Dim imagePath As String = SafeString(ButtonDef.Get("imagePath"))
	If imagePath.Length > 0 Then
		Dim bmp As B4XBitmap = LoadBitmapFromPath(imagePath)
		If bmp.IsInitialized Then Return bmp
	End If

	Dim svgPath As String = SafeString(ButtonDef.Get("svgPath"))
	If svgPath.Length > 0 Then
		Dim bmp2 As B4XBitmap = LoadBitmapFromPath(svgPath)
		If bmp2.IsInitialized Then Return bmp2
	End If

	Return empty
End Sub

Private Sub ApplyBackgroundImage
	If ivBackground.IsInitialized = False Then Return
	If ivBackground.Width <= 0 Or ivBackground.Height <= 0 Then Return
	If mBackgroundBitmap.IsInitialized Then
		ivBackground.SetBitmap(mBackgroundBitmap.Resize(ivBackground.Width, ivBackground.Height, False))
	Else
		ivBackground.SetBitmap(GetEmptyBitmap)
	End If
End Sub

Private Sub GetEmptyBitmap As B4XBitmap
	If EmptyBitmap.IsInitialized Then Return EmptyBitmap
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	Dim cvs As B4XCanvas
	cvs.Initialize(p)
	cvs.ClearRect(cvs.TargetRect)
	EmptyBitmap = cvs.CreateBitmap
	cvs.Release
	Return EmptyBitmap
End Sub

Private Sub LoadBitmapFromPath(Path As String) As B4XBitmap
	Dim empty As B4XBitmap
	If Path = Null Then Return empty
	Dim p As String = Path.Trim
	If p.Length = 0 Then Return empty

	Try
		Dim slash1 As Int = p.LastIndexOf("/")
		Dim slash2 As Int = p.LastIndexOf("\")
		Dim slash As Int = Max(slash1, slash2)
		If slash >= 0 Then
			Dim dir As String = p.SubString2(0, slash)
			Dim fn As String = p.SubString(slash + 1)
			If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then
				Return xui.LoadBitmap(dir, fn)
			End If
		End If
		If File.Exists(File.DirAssets, p) Then
			Return xui.LoadBitmap(File.DirAssets, p)
		End If
	Catch
	End Try
	Return empty
End Sub

Private Sub LoadBackgroundBitmapFromPath(Path As String) As B4XBitmap
	Dim empty As B4XBitmap
	If Path = Null Then Return empty
	Dim p As String = Path.Trim
	If p.Length = 0 Then Return empty

	' Decode wallpapers at display-scale on Android to avoid OOM / silent decode failures.
	Dim targetW As Int = 720dip
	Dim targetH As Int = 1280dip
	If mBase.IsInitialized Then
		targetW = Max(targetW, Max(1dip, mBase.Width))
		targetH = Max(targetH, Max(1dip, mBase.Height))
	End If

	Try
		Dim slash1 As Int = p.LastIndexOf("/")
		Dim slash2 As Int = p.LastIndexOf("\")
		Dim slash As Int = Max(slash1, slash2)
		If slash >= 0 Then
			Dim dir As String = p.SubString2(0, slash)
			Dim fn As String = p.SubString(slash + 1)
			If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then
				#If B4A
				Return LoadBitmapSample(dir, fn, targetW, targetH)
				#Else
				Return xui.LoadBitmap(dir, fn)
				#End If
			End If
		End If
		If File.Exists(File.DirAssets, p) Then
			#If B4A
			Return LoadBitmapSample(File.DirAssets, p, targetW, targetH)
			#Else
			Return xui.LoadBitmap(File.DirAssets, p)
			#End If
		End If
	Catch
	End Try
	Return empty
End Sub

Private Sub NormalizeButton(Source As Map, Index As Int) As Map
	Dim id As String = SafeString(Source.Get("id"))
	If id.Length = 0 Then id = "btn-" & Index
	Dim label As String = SafeString(Source.Get("label"))
	If label.Length = 0 Then label = id
	Dim imagePath As String = SafeString(Source.Get("imagePath"))
	Dim svgPath As String = SafeString(Source.Get("svgPath"))

	Dim normalized As Map = CreateMap("id": id, "label": label, "imagePath": imagePath, "svgPath": svgPath)
	For Each k As Object In Source.Keys
		If normalized.ContainsKey(k) = False Then normalized.Put(k, Source.Get(k))
	Next
	Return normalized
End Sub

Private Sub FindButtonIndexById(ButtonId As String) As Int
	If Buttons.IsInitialized = False Then Return -1
	Dim targetId As String = SafeString(ButtonId).Trim
	If targetId.Length = 0 Then Return -1

	For i = 0 To Buttons.Size - 1
		Dim raw As Object = Buttons.Get(i)
		If raw Is Map Then
			Dim m As Map = raw
			If SafeString(m.Get("id")).Trim = targetId Then Return i
		End If
	Next
	Return -1
End Sub

Private Sub PickBadgeKeyFromUpdates(Updates As Map) As String
	If Updates.ContainsKey("badgeText") Then Return "badgeText"
	If Updates.ContainsKey("badgeCount") Then Return "badgeCount"
	If Updates.ContainsKey("badge") Then Return "badge"
	Return ""
End Sub

Private Sub IsBadgeKey(Key As String) As Boolean
	Dim k As String = SafeString(Key).Trim
	Return k = "badge" Or k = "badgeCount" Or k = "badgeText"
End Sub

Private Sub ClearBadgeKeys(Item As Map)
	If Item.ContainsKey("badgeText") Then Item.Remove("badgeText")
	If Item.ContainsKey("badgeCount") Then Item.Remove("badgeCount")
	If Item.ContainsKey("badge") Then Item.Remove("badge")
End Sub

Private Sub ResolveFallbackGlyph(ButtonDef As Map) As String
	Dim label As String = SafeString(ButtonDef.Get("label"))
	If label.Length > 0 Then Return label.SubString2(0, 1)
	Dim id As String = SafeString(ButtonDef.Get("id"))
	If id.Length > 0 Then Return id.SubString2(0, 1)
	Dim svgPath As String = SafeString(ButtonDef.Get("svgPath"))
	If svgPath.Length > 0 Then Return "S"
	Return "?"
End Sub

Private Sub ResolveBadgeText(ButtonDef As Map) As String
	Dim raw As Object = Null
	If ButtonDef.ContainsKey("badgeText") Then
		raw = ButtonDef.Get("badgeText")
	Else If ButtonDef.ContainsKey("badgeCount") Then
		raw = ButtonDef.Get("badgeCount")
	Else If ButtonDef.ContainsKey("badge") Then
		raw = ButtonDef.Get("badge")
	End If
	If raw = Null Then Return ""

	Dim txt As String = SafeString(raw).Trim
	If txt.Length = 0 Then Return ""

	Dim n As Int = 0
	Dim hasNumber As Boolean = False
	Try
		n = txt
		hasNumber = True
	Catch
		hasNumber = False
	End Try

	If hasNumber Then
		If n <= 0 Then Return ""
		If n > 99 Then Return "99+"
		Return n
	End If
	Return txt
End Sub

Private Sub AutoConfigureGrid(Width As Int, Height As Int)
	If mAutoGrid = False Then Return
	Dim usableW As Float = Max(1dip, Width - (mPagePadding * 2))
	Dim usableH As Float = Max(1dip, Height - mIndicatorAreaHeight - (mPagePadding * 2) - mGridTopOffset)
	Dim targetCols As Int = Max(1, Floor((usableW + mCellSpacing) / (mMinCellWidth + mCellSpacing)))
	Dim targetRows As Int = Max(1, Floor((usableH + mCellSpacingY) / (mMinCellHeight + mCellSpacingY)))
	mColumns = targetCols
	mRowsPerPage = targetRows
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	If Props.IsInitialized = False Then Return

	mColumns = Max(1, GetPropInt(Props, "ColumnsPerPage", mColumns))
	mRowsPerPage = Max(1, GetPropInt(Props, "RowsPerPage", mRowsPerPage))
	mAutoGrid = GetPropBoolean(Props, "AutoGrid", mAutoGrid)
	mMinCellWidth = Max(1dip, GetPropInt(Props, "MinCellWidth", Round(mMinCellWidth / 1dip)) * 1dip)
	mMinCellHeight = Max(1dip, GetPropInt(Props, "MinCellHeight", Round(mMinCellHeight / 1dip)) * 1dip)
	mPagePadding = Max(0, GetPropInt(Props, "PagePadding", Round(mPagePadding / 1dip)) * 1dip)
	mCellSpacing = Max(0, GetPropInt(Props, "CellSpacing", Round(mCellSpacing / 1dip)) * 1dip)
	mCellSpacingY = Max(0, GetPropInt(Props, "CellSpacingY", Round(mCellSpacingY / 1dip)) * 1dip)
	mGridTopOffset = Max(0, GetPropInt(Props, "GridTopOffset", Round(mGridTopOffset / 1dip)) * 1dip)
	mActiveIndicatorColor = GetPropColor(Props, "ActiveIndicatorColor", mActiveIndicatorColor)
	mInactiveIndicatorColor = GetPropColor(Props, "InactiveIndicatorColor", mInactiveIndicatorColor)
	mTextColor = GetPropColor(Props, "TextColor", mTextColor)
	mWidthSpec = NormalizeSizeSpec(GetPropString(Props, "Width", mWidthSpec), "100%")
	mHeightSpec = NormalizeSizeSpec(GetPropString(Props, "Height", mHeightSpec), "100%")
	setBackgroundImage(GetPropString(Props, "BackgroundImage", mBackgroundImagePath))
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If IsNumber(o) Then Return o
	Dim s As String = o
	If IsNumber(s) Then Return s
	Return DefaultValue
End Sub

Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If IsNumber(o) Then Return o
	Return DefaultValue
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Return SafeString(Props.Get(Key))
End Sub

Private Sub GetPropBoolean(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim o As Object = Props.Get(Key)
	If o Is Boolean Then Return o
	Dim s As String = SafeString(o).Trim.ToLowerCase
	If s = "true" Then Return True
	If s = "false" Then Return False
	Return DefaultValue
End Sub

Private Sub SafeString(Value As Object) As String
	If Value = Null Then Return ""
	Return Value
End Sub

Private Sub ApplySizeFromParent
	If mBase.IsInitialized = False Then Return
	If mBase.Parent.IsInitialized = False Then Return
	Dim parent As B4XView = mBase.Parent
	Dim targetW As Int = ResolveSizeSpec(mWidthSpec, parent.Width, mBase.Width)
	Dim targetH As Int = ResolveSizeSpec(mHeightSpec, parent.Height, mBase.Height)
	If targetW <= 0 Then targetW = Max(1dip, mBase.Width)
	If targetH <= 0 Then targetH = Max(1dip, mBase.Height)
	If Abs(mBase.Width - targetW) > 1dip Or Abs(mBase.Height - targetH) > 1dip Then
		mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetW, targetH)
	End If
End Sub

Private Sub ResolveSizeSpec(Spec As String, ParentSize As Int, CurrentSize As Int) As Int
	Dim s As String = NormalizeSizeSpec(Spec, "")
	If s.Length = 0 Then Return Max(1dip, CurrentSize)
	Dim sl As String = s.ToLowerCase
	If sl.EndsWith("%") Then
		Dim n As String = s.SubString2(0, s.Length - 1).Trim
		If IsNumber(n) Then
			Dim pct As Float = n
			Return Max(1dip, ParentSize * pct / 100)
		End If
		Return Max(1dip, CurrentSize)
	End If
	If sl.EndsWith("dip") Then
		Dim d As String = s.SubString2(0, s.Length - 3).Trim
		If IsNumber(d) Then Return Max(1dip, d * 1dip)
		Return Max(1dip, CurrentSize)
	End If
	If IsNumber(s) Then Return Max(1dip, s)
	Return Max(1dip, CurrentSize)
End Sub

Private Sub NormalizeSizeSpec(Value As Object, DefaultValue As String) As String
	Dim s As String = SafeString(Value).Trim
	If s.Length = 0 Then Return DefaultValue
	Return s
End Sub
