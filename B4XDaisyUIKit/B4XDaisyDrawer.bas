B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12, 9
#Region Events
#Event: Closed
#Event: Opened
#Event: CloseClick (Tag As Object)
#Event: StateChanged (Open As Boolean)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables or disables user interaction.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the drawer container.
#DesignerProperty: Key: Opened, DisplayName: Opened, FieldType: Boolean, DefaultValue: False, Description: Initial open state of the primary drawer sidebar.
#DesignerProperty: Key: AlwaysOpen, DisplayName: Always Open, FieldType: Boolean, DefaultValue: False, Description: Forces sidebar to remain permanently open alongside content (drawer-open).
#DesignerProperty: Key: Side, DisplayName: Side, FieldType: String, DefaultValue: left, List: left|right|both, Description: Position of the drawer sidebar (left, right, or dual/both).
#DesignerProperty: Key: LeftSideWidth, DisplayName: Left Side Width, FieldType: String, DefaultValue: 300dip, Description: Custom width for left drawer sidebar.
#DesignerProperty: Key: RightSideWidth, DisplayName: Right Side Width, FieldType: String, DefaultValue: 300dip, Description: Custom width for right drawer sidebar.
#DesignerProperty: Key: CollapseWidth, DisplayName: Collapse Width, FieldType: String, DefaultValue: 60dip, Description: Custom width for sidebar in collapsed rail mode (e.g. 60dip, w-14, 3.5rem).
#DesignerProperty: Key: NormalWidth, DisplayName: Normal Width, FieldType: String, DefaultValue: 300dip, Description: Custom width for sidebar in expanded/normal mode.
#DesignerProperty: Key: IsCollapsed, DisplayName: Is Collapsed, FieldType: Boolean, DefaultValue: False, Description: When True, the drawer left side width is set to CollapseWidth; otherwise NormalWidth.
#DesignerProperty: Key: RailWidth, DisplayName: Rail Width, FieldType: String, DefaultValue: 60dip, Description: Custom width for sidebar in collapsed rail mode (e.g. 60dip, w-14, 3.5rem).
#DesignerProperty: Key: RailMode, DisplayName: Rail Mode, FieldType: Boolean, DefaultValue: False, Description: Collapses drawer sidebar into compact navigation rail mode.
#DesignerProperty: Key: GestureEnabled, DisplayName: Gesture / Swipe Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables swipe gesture detection from edges.
#DesignerProperty: Key: LeftSideBackgroundColor, DisplayName: Left Side Background Color, FieldType: String, DefaultValue: base-200, List: base-100|base-200|base-300|primary|secondary|accent|neutral|info|success|warning|error, Description: Background color variant of the left sidebar panel.
#DesignerProperty: Key: RightSideBackgroundColor, DisplayName: Right Side Background Color, FieldType: String, DefaultValue: base-200, List: base-100|base-200|base-300|primary|secondary|accent|neutral|info|success|warning|error, Description: Background color variant of the right sidebar panel.
#DesignerProperty: Key: ContentBackgroundColor, DisplayName: Content Background Color, FieldType: String, DefaultValue: none, List: none|base-100|base-200|base-300|primary|secondary|accent|neutral|info|success|warning|error, Description: Background color variant of the content panel.
#DesignerProperty: Key: OverlayColor, DisplayName: Overlay Color, FieldType: Color, DefaultValue: 0xFF000000, Description: Base RGB color of the backdrop overlay surface. Alpha channel is adjusted by OverlayOpacity.
#DesignerProperty: Key: OverlayOpacity, DisplayName: Overlay Opacity, FieldType: Int, DefaultValue: 40, MinRange: 0, MaxRange: 100, Description: Opacity percentage for the backdrop overlay.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|none|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box, Description: Corner radius token for the sidebar.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: lg, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation shadow applied to the sidebar.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: p-4, Description: Padding token for the sidebar content.
#DesignerProperty: Key: Animated, DisplayName: Animated, FieldType: Boolean, DefaultValue: True, Description: Enables smooth slide and fade transitions.
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 300, MinRange: 0, MaxRange: 2000, Description: Animation duration in milliseconds.
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' Panels / Containers
	Private mCenterPanel As B4XView
	Private mDarkPanel As B4XView
	Private mLeftPanel As B4XView
	Private mRightPanel As B4XView

	' State
	Private mEnabled As Boolean = True
	Private mVisible As Boolean = True
	Private IsOpenLeft As Boolean = False
	Private IsOpenRight As Boolean = False
	Private mbAlwaysOpen As Boolean = False
	Private mGestureEnabled As Boolean = True

	' Touch & Gesture tracking
	Public ExtraWidth As Int = 30dip
	Private TouchXStart, TouchYStart As Float
	Private HandlingLSwipe As Boolean = False
	Private HandlingRSwipe As Boolean = False

	' Sizing & Styling
	Private msSide As String = "left"
	Private mLeftSideWidth As Int = 300dip
	Private mRightSideWidth As Int = 300dip
	Private msLeftSideWidth As String = "300dip"
	Private msRightSideWidth As String = "300dip"
	Private msRailWidth As String = "60dip"
	Private mRailWidth As Int = 60dip
	Private msNormalWidth As String = "300dip"
	Private msCollapseWidth As String = "60dip"
	Private mbIsCollapsed As Boolean = False
	Private mbRailMode As Boolean = False
	Private msLeftSideBackgroundColor As String = "base-200"
	Private msRightSideBackgroundColor As String = "base-200"
	Private msContentBackgroundColor As String = "none"
	Private miOverlayColor As Int = 0xFF000000
	Private miOverlayOpacity As Int = 40
	Private msRounded As String = "rounded-box"
	Private msShadow As String = "lg"
	Private msPadding As String = "p-4"
	Private mbAnimated As Boolean = True
	Private miDuration As Int = 300
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
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
	BuildViewHierarchy
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", True)
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", True)
	Dim initialOpen As Boolean = B4XDaisyVariants.GetPropBool(mProps, "Opened", B4XDaisyVariants.GetPropBool(mProps, "Open", False))
	mbAlwaysOpen = B4XDaisyVariants.GetPropBool(mProps, "AlwaysOpen", False)
	msSide = B4XDaisyVariants.GetPropString(mProps, "Side", "left")
	msLeftSideWidth = B4XDaisyVariants.GetPropString(mProps, "LeftSideWidth", "300dip")
	msRightSideWidth = B4XDaisyVariants.GetPropString(mProps, "RightSideWidth", "300dip")
	msNormalWidth = B4XDaisyVariants.GetPropString(mProps, "NormalWidth", msLeftSideWidth)
	msCollapseWidth = B4XDaisyVariants.GetPropString(mProps, "CollapseWidth", "60dip")
	msRailWidth = msCollapseWidth
	mbIsCollapsed = B4XDaisyVariants.GetPropBool(mProps, "IsCollapsed", mbIsCollapsed)
	
	mGestureEnabled = B4XDaisyVariants.GetPropBool(mProps, "GestureEnabled", True)
	msLeftSideBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "LeftSideBackgroundColor", "base-200")
	msRightSideBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "RightSideBackgroundColor", "base-200")
	msContentBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "ContentBackgroundColor", "none")
	miOverlayColor = B4XDaisyVariants.GetPropColor(mProps, "OverlayColor", 0xFF000000)
	miOverlayOpacity = B4XDaisyVariants.GetPropInt(mProps, "OverlayOpacity", 40)
	msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", "rounded-box")
	msShadow = B4XDaisyVariants.GetPropString(mProps, "Shadow", "lg")
	msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", "p-4")
	mbAnimated = B4XDaisyVariants.GetPropBool(mProps, "Animated", True)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", 300)

	mLeftSideWidth = B4XDaisyVariants.ResolveSizeSpec(msLeftSideWidth, mBase.Width, 300dip)
	mRightSideWidth = B4XDaisyVariants.ResolveSizeSpec(msRightSideWidth, mBase.Width, 300dip)

	If initialOpen Then
		If msSide.ToLowerCase = "right" Then
			IsOpenRight = True
		Else
			IsOpenLeft = True
		End If
	End If
End Sub

Private Sub BuildViewHierarchy
	mBase.RemoveAllViews

	' 1. Center / Content Panel
	Dim pCenter As Panel
	pCenter.Initialize("mCenterPanel")
	mCenterPanel = pCenter
	mCenterPanel.Color = xui.Color_Transparent
	mBase.AddView(mCenterPanel, 0, 0, mBase.Width, mBase.Height)

	' 2. Dark Overlay Panel
	Dim pDark As Panel
	pDark.Initialize("mDarkPanel")
	mDarkPanel = pDark
	mDarkPanel.Color = xui.Color_Transparent
	mDarkPanel.Visible = False
	mBase.AddView(mDarkPanel, 0, 0, mBase.Width, mBase.Height)

	' 3. Left Panel & Content
	Dim pLeft As Panel
	pLeft.Initialize("mLeftPanel")
	mLeftPanel = pLeft
	mLeftPanel.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msLeftSideBackgroundColor, 0xFFE5E7EB)
	mLeftPanel.Visible = mbAlwaysOpen Or IsOpenLeft
	mBase.AddView(mLeftPanel, -mLeftSideWidth, 0, mLeftSideWidth, mBase.Height)

	' 4. Right Panel & Content
	Dim pRight As Panel
	pRight.Initialize("mRightPanel")
	mRightPanel = pRight
	mRightPanel.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msRightSideBackgroundColor, 0xFFE5E7EB)
	mRightPanel.Visible = mbAlwaysOpen Or IsOpenRight
	mBase.AddView(mRightPanel, mBase.Width, 0, mRightSideWidth, mBase.Height)

End Sub
#End Region

#Region Public Containers & Composition
''' <summary>
''' Gets the central content panel.
''' </summary>
Public Sub CenterPanel As B4XView
	Return mCenterPanel
End Sub

''' <summary>
''' Gets the left drawer panel.
''' </summary>
Public Sub LeftPanel As B4XView
	Return mLeftPanel
End Sub

''' <summary>
''' Gets the right drawer panel.
''' </summary>
Public Sub RightPanel As B4XView
	Return mRightPanel
End Sub

''' <summary>
''' Gets the dark backdrop overlay panel.
''' </summary>
Public Sub DarkPanel As B4XView
	Return mDarkPanel
End Sub

''' <summary>
''' Adds a view to the main drawer content panel.
''' </summary>
Public Sub AddToCenter(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mCenterPanel.IsInitialized Then
		mCenterPanel.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
	End If
End Sub

''' <summary>
''' Adds a view to the left drawer panel.
''' </summary>
Public Sub AddToLeft(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mLeftPanel.IsInitialized Then
		mLeftPanel.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
	End If
End Sub

''' <summary>
''' Adds a view to the right drawer panel.
''' </summary>
Public Sub AddToRight(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mRightPanel.IsInitialized Then
		mRightPanel.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
	End If
End Sub

''' <summary>
''' Clears all views from the main content container.
''' </summary>
Public Sub ClearCenter
	If mCenterPanel.IsInitialized Then mCenterPanel.RemoveAllViews
End Sub

''' <summary>
''' Clears all views from the left sidebar panel.
''' </summary>
Public Sub ClearLeft
	If mLeftPanel.IsInitialized Then mLeftPanel.RemoveAllViews
End Sub

''' <summary>
''' Clears all views from the right sidebar panel.
''' </summary>
Public Sub ClearRight
	If mRightPanel.IsInitialized Then mRightPanel.RemoveAllViews
End Sub

#End Region

#Region Open & Close Control
''' <summary>
''' Gets whether the left drawer is currently open.
''' </summary>
Public Sub getLeftOpen As Boolean
	Return IsOpenLeft
End Sub

''' <summary>
''' Opens or closes the left drawer.
''' </summary>
Public Sub setLeftOpen(bValue As Boolean)
	If HasLeftPanel = False Or mBase.IsInitialized = False Then Return
	If bValue = IsOpenLeft Then Return
	If bValue Then setRightOpen(False)
	Dim x As Float = IIf(bValue, 0, -mLeftSideWidth)
	LeftChangeOffset(x, False, False)
End Sub

''' <summary>
''' Opens the left drawer sidebar.
''' </summary>
Public Sub OpenLeft
	setLeftOpen(True)
End Sub

''' <summary>
''' Closes the left drawer sidebar.
''' </summary>
Public Sub CloseLeft
	setLeftOpen(False)
End Sub

''' <summary>
''' Gets whether the right drawer is currently open.
''' </summary>
Public Sub getRightOpen As Boolean
	Return IsOpenRight
End Sub

''' <summary>
''' Opens or closes the right drawer.
''' </summary>
Public Sub setRightOpen(bValue As Boolean)
	If HasRightPanel = False Or mBase.IsInitialized = False Then Return
	If bValue = IsOpenRight Then Return
	If bValue Then setLeftOpen(False)
	Dim x As Float = IIf(bValue, mBase.Width - mRightSideWidth, mBase.Width)
	RightChangeOffset(x, False, False)
End Sub

''' <summary>
''' Opens the right drawer sidebar.
''' </summary>
Public Sub OpenRight
	setRightOpen(True)
End Sub

''' <summary>
''' Closes the right drawer sidebar.
''' </summary>
Public Sub CloseRight
	setRightOpen(False)
End Sub

''' <summary>
''' Opens the configured primary drawer.
''' </summary>
Public Sub Open
	If msSide.ToLowerCase = "right" Then
		OpenRight
	Else
		OpenLeft
	End If
End Sub

''' <summary>
''' Closes whichever drawer is open.
''' </summary>
Public Sub Close
	If IsOpenLeft Then CloseLeft
	If IsOpenRight Then CloseRight
End Sub

''' <summary>
''' Toggles the primary drawer between open and closed states.
''' </summary>
Public Sub Toggle
	If msSide.ToLowerCase = "right" Then
		setRightOpen(IsOpenRight = False)
	Else
		setLeftOpen(IsOpenLeft = False)
	End If
End Sub

''' <summary>
''' Gets whether the primary drawer is open.
''' </summary>
Public Sub getIsOpen As Boolean
	If msSide.ToLowerCase = "right" Then Return IsOpenRight
	Return IsOpenLeft
End Sub

''' <summary>
''' Sets whether the primary drawer is open.
''' </summary>
Public Sub setIsOpen(bValue As Boolean)
	If bValue Then Open Else Close
End Sub
#End Region

#Region Offset & Animation Engine
Private Sub LeftChangeOffset(fX As Float, bCurrentlyTouching As Boolean, bNoAnimation As Boolean)
	If HasLeftPanel = False Or mBase.IsInitialized = False Then Return
	fX = Max(-mLeftSideWidth, Min(0, fX))
	Dim VisibleOffset As Int = mLeftSideWidth + fX

	If bCurrentlyTouching = False Then
		Dim willBeOpen As Boolean = False
		If (IsOpenLeft And VisibleOffset < 0.8 * mLeftSideWidth) Or (IsOpenLeft = False And VisibleOffset < 0.2 * mLeftSideWidth) Then
			fX = -mLeftSideWidth
			willBeOpen = False
		Else
			fX = 0
			willBeOpen = True
		End If

		VisibleOffset = mLeftSideWidth + fX
		Dim dx As Int = Abs(mLeftPanel.Left - fX)
		Dim duration As Int = IIf(mbAnimated, Max(0, miDuration * dx / Max(1, mLeftSideWidth)), 0)
		If bNoAnimation Then duration = 0

		If willBeOpen Then
			mDarkPanel.Visible = True
			mLeftPanel.Visible = True
			If IsOpenLeft = False Then
				IsOpenLeft = True
				SetInternalIsOpen(True, True)
			End If
		End If

		mLeftPanel.SetLayoutAnimated(duration, fX, 0, mLeftSideWidth, mBase.Height)
		mDarkPanel.SetColorAnimated(duration, mDarkPanel.Color, OffsetToColor(VisibleOffset, True))
		mCenterPanel.SetLayoutAnimated(duration, IIf(willBeOpen, mLeftSideWidth, 0), 0, mBase.Width, mBase.Height)

		If willBeOpen = False Then
			If duration > 0 Then Sleep(duration)
			If willBeOpen = False And IsOpenRight = False Then
				mDarkPanel.Visible = False
				mLeftPanel.Visible = False
			End If
			If IsOpenLeft Then
				IsOpenLeft = False
				SetInternalIsOpen(True, False)
			End If
		End If
	Else
		mDarkPanel.Visible = True
		mLeftPanel.Visible = True
		mDarkPanel.Color = OffsetToColor(VisibleOffset, True)
		mLeftPanel.Left = fX
		mCenterPanel.Left = VisibleOffset
	End If
End Sub

Private Sub RightChangeOffset(fX As Float, bCurrentlyTouching As Boolean, bNoAnimation As Boolean)
	If HasRightPanel = False Or mBase.IsInitialized = False Then Return
	fX = Max(mBase.Width - mRightSideWidth, Min(mBase.Width, fX))
	Dim VisibleOffset As Int = mBase.Width - fX

	If bCurrentlyTouching = False Then
		Dim willBeOpen As Boolean = False
		If (IsOpenRight And VisibleOffset < 0.8 * mRightSideWidth) Or (IsOpenRight = False And VisibleOffset < 0.2 * mRightSideWidth) Then
			fX = mBase.Width
			willBeOpen = False
		Else
			fX = mBase.Width - mRightSideWidth
			willBeOpen = True
		End If

		VisibleOffset = mBase.Width - fX
		Dim dx As Int = Abs(mRightPanel.Left - fX)
		Dim duration As Int = IIf(mbAnimated, Max(0, miDuration * dx / Max(1, mRightSideWidth)), 0)
		If bNoAnimation Then duration = 0

		If willBeOpen Then
			mDarkPanel.Visible = True
			mRightPanel.Visible = True
			If IsOpenRight = False Then
				IsOpenRight = True
				SetInternalIsOpen(False, True)
			End If
		End If

		mRightPanel.SetLayoutAnimated(duration, fX, 0, mRightSideWidth, mBase.Height)
		mDarkPanel.SetColorAnimated(duration, mDarkPanel.Color, OffsetToColor(VisibleOffset, False))
		mCenterPanel.SetLayoutAnimated(duration, IIf(willBeOpen, -mRightSideWidth, 0), 0, mBase.Width, mBase.Height)

		If willBeOpen = False Then
			If duration > 0 Then Sleep(duration)
			If willBeOpen = False And IsOpenLeft = False Then
				mDarkPanel.Visible = False
				mRightPanel.Visible = False
			End If
			If IsOpenRight Then
				IsOpenRight = False
				SetInternalIsOpen(False, False)
			End If
		End If
	Else
		mDarkPanel.Visible = True
		mRightPanel.Visible = True
		mDarkPanel.Color = OffsetToColor(VisibleOffset, False)
		mRightPanel.Left = fX
		mCenterPanel.Left = -(mBase.Width - fX)
	End If
End Sub

Private Sub SetInternalIsOpen(bisLeft As Boolean, bNewState As Boolean)
	Dim payload As Object = mTag
	If payload = Null Then payload = mBase

	If bNewState Then
		If xui.SubExists(mCallBack, mEventName & "_Opened", 0) Then
			CallSub(mCallBack, mEventName & "_Opened")
		Else If xui.SubExists(mCallBack, mEventName & "_Opened", 1) Then
			CallSub2(mCallBack, mEventName & "_Opened", payload)
		End If
	Else
		If xui.SubExists(mCallBack, mEventName & "_Closed", 0) Then
			CallSub(mCallBack, mEventName & "_Closed")
		Else If xui.SubExists(mCallBack, mEventName & "_Closed", 1) Then
			CallSub2(mCallBack, mEventName & "_Closed", payload)
		End If
	End If

	If xui.SubExists(mCallBack, mEventName & "_StateChanged", 1) Then
		CallSub2(mCallBack, mEventName & "_StateChanged", bNewState)
	End If
End Sub

Private Sub OffsetToColor(iX As Int, bisLeft As Boolean) As Int
	Dim maxW As Float = IIf(bisLeft, Max(1, mLeftSideWidth), Max(1, mRightSideWidth))
	Dim visibleFraction As Float = Max(0, Min(1.0, iX / maxW))
	Dim targetAlpha As Float = (miOverlayOpacity / 100.0) * 255.0 * visibleFraction
	Return Bit.Or(Bit.And(miOverlayColor, 0x00FFFFFF), Bit.ShiftLeft(Round(targetAlpha), 24))
End Sub
#End Region

#Region Side Width Controls
''' <summary>
''' Sets the width of both left and right panels with optional smooth animation.
''' </summary>
Public Sub SetSideWidthAnimated(fWidth As Float, bSmooth As Boolean)
	mLeftSideWidth = fWidth
	mRightSideWidth = fWidth
	msLeftSideWidth = B4XDaisyVariants.ResolvePxSizeSpec(fWidth)
	msRightSideWidth = B4XDaisyVariants.ResolvePxSizeSpec(fWidth)
	Dim Duration As Long = IIf(bSmooth, miDuration, 0)
	If mbAlwaysOpen Then
		If msSide.ToLowerCase = "right" Then
			mRightPanel.SetLayoutAnimated(Duration, mBase.Width - mRightSideWidth, 0, mRightSideWidth, mBase.Height)
			mCenterPanel.SetLayoutAnimated(Duration, 0, 0, mBase.Width, mBase.Height)
		Else If msSide.ToLowerCase = "both" Then
			mLeftPanel.SetLayoutAnimated(Duration, 0, 0, mLeftSideWidth, mBase.Height)
			mRightPanel.SetLayoutAnimated(Duration, mBase.Width - mRightSideWidth, 0, mRightSideWidth, mBase.Height)
			mCenterPanel.SetLayoutAnimated(Duration, mLeftSideWidth, 0, mBase.Width, mBase.Height)
		Else
			mLeftPanel.SetLayoutAnimated(Duration, 0, 0, mLeftSideWidth, mBase.Height)
			mCenterPanel.SetLayoutAnimated(Duration, mLeftSideWidth, 0, mBase.Width, mBase.Height)
		End If
	Else
		If IsOpenLeft Then
			mLeftPanel.SetLayoutAnimated(Duration, 0, 0, mLeftSideWidth, mBase.Height)
			mCenterPanel.SetLayoutAnimated(Duration, mLeftSideWidth, 0, mBase.Width, mBase.Height)
		Else
			mLeftPanel.SetLayoutAnimated(0, -mLeftSideWidth, 0, mLeftSideWidth, mBase.Height)
			mCenterPanel.SetLayoutAnimated(Duration, 0, 0, mBase.Width, mBase.Height)
		End If
		If IsOpenRight Then
			mRightPanel.SetLayoutAnimated(Duration, mBase.Width - mRightSideWidth, 0, mRightSideWidth, mBase.Height)
		Else
			mRightPanel.SetLayoutAnimated(0, mBase.Width, 0, mRightSideWidth, mBase.Height)
		End If
	End If
End Sub

Public Sub setSideWidth(sValue As String)
	setLeftSideWidth(sValue)
	setRightSideWidth(sValue)
End Sub

Public Sub getSideWidth As String
	Return msLeftSideWidth
End Sub

Public Sub setLeftSideWidth(sValue As String)
	msLeftSideWidth = sValue
	mLeftSideWidth = B4XDaisyVariants.ResolveSizeSpec(sValue, mBase.Width, 300dip)
	If mbAlwaysOpen Then
		If msSide.ToLowerCase <> "right" Then
			mLeftPanel.SetLayoutAnimated(0, 0, 0, mLeftSideWidth, mBase.Height)
			mCenterPanel.SetLayoutAnimated(0, mLeftSideWidth, 0, mBase.Width, mBase.Height)
		End If
	Else
		If IsOpenLeft Then
			mLeftPanel.SetLayoutAnimated(0, 0, 0, mLeftSideWidth, mBase.Height)
		Else
			mLeftPanel.SetLayoutAnimated(0, -mLeftSideWidth, 0, mLeftSideWidth, mBase.Height)
		End If
	End If
End Sub

Public Sub getLeftSideWidth As String
	Return msLeftSideWidth
End Sub

Public Sub setRightSideWidth(sValue As String)
	msRightSideWidth = sValue
	mRightSideWidth = B4XDaisyVariants.ResolveSizeSpec(sValue, mBase.Width, 300dip)
	If mbAlwaysOpen Then
		If msSide.ToLowerCase <> "left" Then
			mRightPanel.SetLayoutAnimated(0, mBase.Width - mRightSideWidth, 0, mRightSideWidth, mBase.Height)
			Dim leftW As Int = IIf(msSide.ToLowerCase = "both", mLeftSideWidth, 0)
			mCenterPanel.SetLayoutAnimated(0, leftW, 0, mBase.Width, mBase.Height)
		End If
	Else
		If IsOpenRight Then
			mRightPanel.SetLayoutAnimated(0, mBase.Width - mRightSideWidth, 0, mRightSideWidth, mBase.Height)
		Else
			mRightPanel.SetLayoutAnimated(0, mBase.Width, 0, mRightSideWidth, mBase.Height)
		End If
	End If
End Sub

Public Sub getRightSideWidth As String
	Return msRightSideWidth
End Sub

Public Sub setCollapseWidth(sValue As String)
	msCollapseWidth = sValue
	msRailWidth = sValue
	mRailWidth = B4XDaisyVariants.ResolveSizeSpec(sValue, mBase.Width, 60dip)
	If mbIsCollapsed And mBase.IsInitialized Then
		setIsCollapsed(True)
	End If
End Sub

Public Sub getCollapseWidth As String
	Return msCollapseWidth
End Sub

Public Sub setRailWidth(sValue As String)
	setCollapseWidth(sValue)
End Sub

Public Sub getRailWidth As String
	Return msCollapseWidth
End Sub

Public Sub setNormalWidth(sValue As String)
	msNormalWidth = sValue
	Dim side As String = msSide.ToLowerCase
	If side = "right" Then
		msRightSideWidth = sValue
		mRightSideWidth = B4XDaisyVariants.ResolveSizeSpec(sValue, mBase.Width, 240dip)
	Else If side = "both" Then
		msLeftSideWidth = sValue
		msRightSideWidth = sValue
		mLeftSideWidth = B4XDaisyVariants.ResolveSizeSpec(sValue, mBase.Width, 240dip)
		mRightSideWidth = mLeftSideWidth
	Else
		msLeftSideWidth = sValue
		mLeftSideWidth = B4XDaisyVariants.ResolveSizeSpec(sValue, mBase.Width, 240dip)
	End If
	If mbIsCollapsed = False And mBase.IsInitialized Then
		setIsCollapsed(False)
	End If
End Sub

Public Sub getNormalWidth As String
	Return msNormalWidth
End Sub

Public Sub setIsCollapsed(bValue As Boolean)
	mbIsCollapsed = bValue
	Dim targetSpec As String = IIf(mbIsCollapsed, msCollapseWidth, msNormalWidth)
	Dim fallback As Int = IIf(mbIsCollapsed, 60dip, 300dip)
	Dim targetW As Int = B4XDaisyVariants.ResolveSizeSpec(targetSpec, mBase.Width, fallback)
	If mBase.IsInitialized Then
		SetSideWidthAnimated(targetW, mbAnimated)
	Else
		mLeftSideWidth = targetW
		msLeftSideWidth = targetSpec
	End If
End Sub

Public Sub getIsCollapsed As Boolean
	Return mbIsCollapsed
End Sub

Public Sub setCollapsed(bValue As Boolean)
	setIsCollapsed(bValue)
End Sub

Public Sub getCollapsed As Boolean
	Return mbIsCollapsed
End Sub
#End Region

#Region Public Properties
Public Sub getGestureEnabled As Boolean
	Return mGestureEnabled
End Sub

Public Sub setGestureEnabled(bValue As Boolean)
	mGestureEnabled = bValue
End Sub



Public Sub setEnabled(bValue As Boolean)
	mEnabled = bValue
	If mBase.IsInitialized Then mBase.Enabled = bValue
End Sub

Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setAlwaysOpen(bValue As Boolean)
	mbAlwaysOpen = bValue
	Refresh
End Sub

Public Sub getAlwaysOpen As Boolean
	Return mbAlwaysOpen
End Sub

Public Sub setSide(sValue As String)
	msSide = sValue
	
	
	Refresh
End Sub

Public Sub getSide As String
	Return msSide
End Sub

Public Sub setLeftSideBackgroundColor(sValue As String)
	msLeftSideBackgroundColor = sValue
	Refresh
End Sub

Public Sub getLeftSideBackgroundColor As String
	Return msLeftSideBackgroundColor
End Sub

Public Sub setRightSideBackgroundColor(sValue As String)
	msRightSideBackgroundColor = sValue
	Refresh
End Sub

Public Sub getRightSideBackgroundColor As String
	Return msRightSideBackgroundColor
End Sub

Public Sub setSideBackgroundColor(sValue As String)
	msLeftSideBackgroundColor = sValue
	msRightSideBackgroundColor = sValue
	Refresh
End Sub

Public Sub getSideBackgroundColor As String
	Return msLeftSideBackgroundColor
End Sub

Public Sub setContentBackgroundColor(sValue As String)
	msContentBackgroundColor = sValue
	Refresh
End Sub

Public Sub getContentBackgroundColor As String
	Return msContentBackgroundColor
End Sub

Public Sub setOverlayColor(oValue As Object)
	If oValue Is Int Then
		miOverlayColor = oValue
	Else
		miOverlayColor = B4XDaisyVariants.ResolveBackgroundColorVariant(oValue, 0xFF000000)
	End If
	Refresh
End Sub

Public Sub getOverlayColor As Int
	Return miOverlayColor
End Sub

Public Sub setOverlayOpacity(iValue As Int)
	miOverlayOpacity = iValue
	Refresh
End Sub

Public Sub getOverlayOpacity As Int
	Return miOverlayOpacity
End Sub

Public Sub setRounded(sValue As String)
	msRounded = sValue
	Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub setShadow(sValue As String)
	msShadow = sValue
	Refresh
End Sub

Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setPadding(sValue As String)
	msPadding = sValue
	Refresh
End Sub

Public Sub getPadding As String
	Return msPadding
End Sub

Public Sub setAnimated(bValue As Boolean)
	mbAnimated = bValue
End Sub

Public Sub getAnimated As Boolean
	Return mbAnimated
End Sub

Public Sub setDuration(iValue As Int)
	miDuration = iValue
End Sub

Public Sub getDuration As Int
	Return miDuration
End Sub

Public Sub setBackgroundColorVariant(sValue As String)
	setSideBackgroundColor(sValue)
End Sub

Public Sub getBackgroundColorVariant As String
	Return msLeftSideBackgroundColor
End Sub

Public Sub setTextColorVariant(sValue As String)
End Sub

Public Sub getTextColorVariant As String
	Return "none"
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub UpdateTheme
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	mBase.Enabled = mEnabled

	If msContentBackgroundColor <> "none" And msContentBackgroundColor.Length > 0 Then
		mCenterPanel.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msContentBackgroundColor, xui.Color_Transparent)
	Else
		mCenterPanel.Color = xui.Color_Transparent
	End If

	If mLeftPanel.IsInitialized Then mLeftPanel.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msLeftSideBackgroundColor, 0xFFE5E7EB)
	If mRightPanel.IsInitialized Then mRightPanel.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(msRightSideBackgroundColor, 0xFFE5E7EB)

	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
		DesignerCreateView(b, Null, CreateMap())
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Base_Resize(iWidth, iHeight)
	Refresh
	Return mBase
End Sub

Public Sub CreateView(vParent As B4XView, oTag As Object) As B4XView
	mTag = oTag
	Return AddToParent(vParent, 0, 0, vParent.Width, vParent.Height)
End Sub
#End Region

Private Sub HasLeftPanel As Boolean
	Return msSide.ToLowerCase = "left" Or msSide.ToLowerCase = "both"
End Sub

Private Sub HasRightPanel As Boolean
	Return msSide.ToLowerCase = "right" Or msSide.ToLowerCase = "both"
End Sub

#Region Layout and Sizing
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or mCenterPanel.IsInitialized = False Then Return

	Dim w As Int = dWidth
	Dim h As Int = dHeight

	Dim targetSpec As String = IIf(mbIsCollapsed, msCollapseWidth, msNormalWidth)
	Dim fallback As Int = IIf(mbIsCollapsed, 60dip, 240dip)
	If msSide.ToLowerCase = "right" Then
		mRightSideWidth = B4XDaisyVariants.ResolveSizeSpec(targetSpec, w, fallback)
	Else If msSide.ToLowerCase = "both" Then
		mLeftSideWidth = B4XDaisyVariants.ResolveSizeSpec(targetSpec, w, fallback)
		mRightSideWidth = B4XDaisyVariants.ResolveSizeSpec(targetSpec, w, fallback)
	Else
		mLeftSideWidth = B4XDaisyVariants.ResolveSizeSpec(targetSpec, w, fallback)
	End If

	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	mDarkPanel.SetLayoutAnimated(0, 0, 0, w, h)

	If mbAlwaysOpen Then
		mDarkPanel.Visible = False
		If msSide.ToLowerCase = "right" Then
			mRightPanel.Visible = True
			mLeftPanel.Visible = False
			mCenterPanel.SetLayoutAnimated(0, 0, 0, w, h)
			mRightPanel.SetLayoutAnimated(0, w - mRightSideWidth, 0, mRightSideWidth, h)
		Else If msSide.ToLowerCase = "both" Then
			mLeftPanel.Visible = True
			mRightPanel.Visible = True
			mLeftPanel.SetLayoutAnimated(0, 0, 0, mLeftSideWidth, h)
			mRightPanel.SetLayoutAnimated(0, w - mRightSideWidth, 0, mRightSideWidth, h)
			mCenterPanel.SetLayoutAnimated(0, mLeftSideWidth, 0, w, h)
		Else
			mLeftPanel.Visible = True
			mRightPanel.Visible = False
			mLeftPanel.SetLayoutAnimated(0, 0, 0, mLeftSideWidth, h)
			mCenterPanel.SetLayoutAnimated(0, mLeftSideWidth, 0, w, h)
		End If
	Else
		If IsOpenLeft Then
			mLeftPanel.Visible = True
			mLeftPanel.SetLayoutAnimated(0, 0, 0, mLeftSideWidth, h)
			mCenterPanel.SetLayoutAnimated(0, mLeftSideWidth, 0, w, h)
		Else If IsOpenRight Then
			mRightPanel.Visible = True
			mRightPanel.SetLayoutAnimated(0, w - mRightSideWidth, 0, mRightSideWidth, h)
			mCenterPanel.SetLayoutAnimated(0, -mRightSideWidth, 0, w, h)
		Else
			mCenterPanel.SetLayoutAnimated(0, 0, 0, w, h)
			mLeftPanel.Visible = False
			mLeftPanel.SetLayoutAnimated(0, -mLeftSideWidth, 0, mLeftSideWidth, h)
			mRightPanel.Visible = False
			mRightPanel.SetLayoutAnimated(0, w, 0, mRightSideWidth, h)
		End If

		mDarkPanel.Visible = IsOpenLeft Or IsOpenRight
	End If
End Sub

Public Sub Resize(iWidth As Int, iHeight As Int)
	Base_Resize(iWidth, iHeight)
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
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
	If mBase.IsInitialized Then
		mBase.Width = iValue
		Base_Resize(iValue, mBase.Height)
	End If
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then
		mBase.Height = iValue
		Base_Resize(mBase.Width, iValue)
	End If
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub
#End Region

#Region Touch, Gestures, and Intercept
#If B4A
Private Sub DisallowParentIntercept(iAction As Int)
	If iAction = 0 Or iAction = 2 Then ' ACTION_DOWN or ACTION_MOVE
		Dim current As JavaObject = mBase
		Do While current.IsInitialized
			Dim parentView As JavaObject
			Try
				parentView = current.RunMethod("getParent", Null)
			Catch
				Exit
			End Try
			If parentView.IsInitialized = False Then Exit
			Try
				parentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
			Catch
			End Try

			Try
				Dim parentClass As String = GetType(parentView)
				If parentClass.Contains("ViewRootImpl") Then Exit
			Catch
				Exit
			End Try

			current = parentView
		Loop
	End If
End Sub
#End If

Private Sub mDarkPanel_Click
	If IsOpenLeft = False And IsOpenRight = False Then Return
	Dim payload As Object = mTag
	If payload = Null Then payload = mBase
	If xui.SubExists(mCallBack, mEventName & "_CloseClick", 1) Then
		CallSub2(mCallBack, mEventName & "_CloseClick", payload)
	Else If xui.SubExists(mCallBack, mEventName & "_CloseClick", 0) Then
		CallSub(mCallBack, mEventName & "_CloseClick")
	End If
	Close
End Sub

Private Sub mDarkPanel_Touch(iAction As Int, fX As Float, fY As Float)
	#If B4A
	DisallowParentIntercept(iAction)
	#End If
	If iAction = 1 Then ' UP
		mDarkPanel_Click
	End If
End Sub

Private Sub mCenterPanel_Touch(iAction As Int, fX As Float, fY As Float)
	#If B4A
	DisallowParentIntercept(iAction)
	#End If
	If mEnabled = False Or mGestureEnabled = False Or mbAlwaysOpen Then Return

	Select iAction
		Case 0 ' DOWN
			TouchXStart = fX
			TouchYStart = fY
			HandlingLSwipe = False
			HandlingRSwipe = False
		Case 2 ' MOVE
			Dim dx As Float = fX - TouchXStart
			Dim dy As Float = Abs(fY - TouchYStart)
			If dy < 30dip Then
				If HandlingLSwipe Or (TouchXStart <= ExtraWidth And dx > 10dip And HasLeftPanel And Not(IsOpenRight)) Then
					HandlingLSwipe = True
					LeftChangeOffset(mLeftPanel.Left + dx, True, False)
					TouchXStart = fX
				Else If HandlingRSwipe Or (TouchXStart >= mBase.Width - ExtraWidth And dx < -10dip And HasRightPanel And Not(IsOpenLeft)) Then
					HandlingRSwipe = True
					RightChangeOffset(mRightPanel.Left + dx, True, False)
					TouchXStart = fX
				End If
			End If
		Case 1 ' UP
			If HandlingLSwipe Then
				LeftChangeOffset(mLeftPanel.Left, False, False)
			End If
			If HandlingRSwipe Then
				RightChangeOffset(mRightPanel.Left, False, False)
			End If
			HandlingLSwipe = False
			HandlingRSwipe = False
	End Select
End Sub


#End Region

#Region Cleanup
Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region

Public Sub setOpened(bValue As Boolean)
	setIsOpen(bValue)
End Sub

Public Sub getOpened As Boolean
	Return getIsOpen
End Sub
