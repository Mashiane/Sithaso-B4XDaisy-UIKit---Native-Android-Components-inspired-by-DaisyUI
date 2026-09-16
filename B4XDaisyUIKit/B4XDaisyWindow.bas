B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Window width (for example w-full, 320dip, 320).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-220, Description: Window height (for example h-220, 220dip).
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Window background (0 uses bg-base-100).
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Window border color (0 uses border-base-300).
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level.
#DesignerProperty: Key: ShowHeader, DisplayName: Show Header, FieldType: Boolean, DefaultValue: True, Description: Show top header area.
#DesignerProperty: Key: HeaderHeight, DisplayName: Header Height, FieldType: Int, DefaultValue: 24, Description: Header height in dip.
#DesignerProperty: Key: ShowControls, DisplayName: Show Controls, FieldType: Boolean, DefaultValue: True, Description: Show top-left three control dots.
#DesignerProperty: Key: ToolBarTitle, DisplayName: Tool Bar Title, FieldType: String, DefaultValue: , Description: Text shown centred in the header toolbar pill. Leave blank to hide the toolbar.
#DesignerProperty: Key: ContentPadding, DisplayName: Content Padding, FieldType: String, DefaultValue: p-4, Description: Tailwind padding token(s) for the content area (e.g. p-4, px-6 py-3, pl-4).
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: True, Description: Automatically grow/shrink height to fit content panel children.

'/**
' * @module B4XDaisyWindow
' * @description
' *  Reusable Daisy-style window surface for B4X layouts.
' *
' *  Visual structure:
' *  1) Outer container (mBase): rounded, bordered, elevated shell.
' *  2) Header strip (optional): top band that can show three "window control" dots.
' *     Header strip also exposes a composable header-content slot (for browser/address bars).
' *  3) Content panel: host for child views that should live inside the window body.
' *
' *  Runtime model:
' *  - DesignerCreateView wires the internal panel hierarchy and applies designer props.
' *  - Any child views that already existed on mBase are migrated to pnlContent.
' *  - All style/geometry changes funnel into Refresh, which performs a full layout pass.
' *
' *  Sizing model:
' *  - Width/Height properties are stored as string specs (percent, dip-like, px text).
' *  - AddToParent resolves specs against the parent size when explicit size is not provided.
' *  - Optional AutoHeight can derive total height from content children.
' *
' *  Notes for maintainers:
' *  - Backing fields are always m* variables. Public setters mutate m* first, then Refresh.
' *  - BuildRuntimeProps is the canonical snapshot used for programmatic re-creation.
' *  - Keep Refresh idempotent and side-effect free outside visual/layout updates.
' */
#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Private mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	Private mWidthSpec As String = "w-full"
	Private mHeightSpec As String = "h-220"
	Private mBackgroundColor As Int = 0
	Private mBorderColor As Int = 0
	Private mBorderSizeDip As Int = 1dip
	Private mRounded As String = "theme"
	Private mShadow As String = "none"
	Private mShowHeader As Boolean = True
	Private mHeaderHeightDip As Int = 24dip
	Private mCachedW As Int = 0
	Private mCachedH As Int = 0
	Private mShowControls As Boolean = True
	Private mControlSizeDip As Int = 6dip
	Private mControlGapDip As Int = 6dip
	Private msToolBarTitle As String = ""
	Private mContentPaddingSpec As String = "p-4"
	Private mCPLeft As Int = 0
	Private mCPTop As Int = 0
	Private mCPRight As Int = 0
	Private mCPBottom As Int = 0
	Private mAutoHeight As Boolean = True

	Private pnlHeader As B4XView
	Private pnlHeaderRule As B4XView
	Private pnlHeaderContent As B4XView
	Private pnlToolBar As B4XView
	Private lblToolBarTitle As B4XDaisyText
	Private pnlContent As B4XView
	Private dot1 As B4XView
	Private dot2 As B4XView
	Private dot3 As B4XView

	Private mDefaultWidthDip As Int = 320dip
	Private mDefaultHeightDip As Int = 220dip
	Private inResize As Boolean = False
End Sub

'/**
' * @method Initialize
' * @param Callback Owner object that receives component events.
' * @param EventName Event prefix used when raising callbacks.
' * @description Stores callback routing metadata only. No UI objects are created here.
' */
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

'/**
' * @method CreateView
' * @param Width Desired width in dip units.
' * @param Height Desired height in dip units.
' * @returns B4XView Root window view (mBase).
' * @description
' *  Convenience factory for programmatic creation.
' *  Builds a temporary base panel, translates numeric size into px spec strings, and delegates
' *  to DesignerCreateView so designer and runtime creation share the same pipeline.
' */
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps
	props.Put("Width", ResolvePxSizeSpec(iWidth))
	props.Put("Height", ResolvePxSizeSpec(iHeight))
	DesignerCreateView(b, Null, props)
	Return mBase
End Sub

'/**
' * @method DesignerCreateView
' * @param Base Root view supplied by the designer/runtime.
' * @param Lbl Unused label placeholder required by custom-view signature.
' * @param Props Designer properties map.
' * @description
' *  One-time composition entry point.
' *  - Preserves original Tag in mTag, then assigns mBase.Tag = Me for framework access.
' *  - Creates header, header rule, header-content slot, content host, and control dots.
' *  - Applies props to m* state, migrates pre-existing children into content host, and refreshes.
' */
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim existingChildren As List
	existingChildren.Initialize
	For i = 0 To mBase.NumberOfViews - 1
		existingChildren.Add(mBase.GetView(i))
	Next

	Dim pHeader As Panel
	pHeader.Initialize("")
	pnlHeader = pHeader
	pnlHeader.Color = xui.Color_Transparent
	mBase.AddView(pnlHeader, 0, 0, 0, 0)

	Dim pRule As Panel
	pRule.Initialize("")
	pnlHeaderRule = pRule
	pnlHeaderRule.Color = xui.Color_Transparent
	pnlHeader.AddView(pnlHeaderRule, 0, 0, 0, 0)

	Dim pHeaderContent As Panel
	pHeaderContent.Initialize("")
	pnlHeaderContent = pHeaderContent
	pnlHeaderContent.Color = xui.Color_Transparent
	pnlHeader.AddView(pnlHeaderContent, 0, 0, 0, 0)

	Dim pToolBar As Panel
	pToolBar.Initialize("")
	pnlToolBar = pToolBar
	pnlToolBar.Color = xui.Color_Transparent
	pnlHeaderContent.AddView(pnlToolBar, 0, 0, 0, 0)
	lblToolBarTitle.Initialize(Me, "")
	lblToolBarTitle.AddToParent(pnlToolBar, 0, 0, 0, 0)

	Dim pContent As Panel
	pContent.Initialize("")
	pnlContent = pContent
	pnlContent.Color = xui.Color_Transparent
	mBase.AddView(pnlContent, 0, 0, 0, 0)

	dot1 = CreateDot(1)
	dot2 = CreateDot(2)
	dot3 = CreateDot(3)
	pnlHeader.AddView(dot1, 0, 0, 0, 0)
	pnlHeader.AddView(dot2, 0, 0, 0, 0)
	pnlHeader.AddView(dot3, 0, 0, 0, 0)

	ApplyDesignerProps(mProps)
	MoveChildrenToContent(existingChildren)
	Refresh
End Sub

'/**
' * @method CreateDot
' * @param Index Logical control index (1..3).
' * @returns B4XView Dot panel with Tag = Index.
' * @description Creates one header control placeholder.
' */
Private Sub CreateDot(iIndex As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim v As B4XView = p
	v.Color = xui.Color_Transparent
	v.Tag = iIndex
	Return v
End Sub

'/**
' * @method MoveChildrenToContent
' * @param Children List of existing children originally attached to mBase.
' * @description
' *  Re-parents user content into pnlContent so external code can still add controls on the
' *  custom view in the designer without manually targeting the internal content panel.
' */
Private Sub MoveChildrenToContent(lstChildren As List)
	If lstChildren.IsInitialized = False Then Return
	For Each v As B4XView In lstChildren
		If v = Null Then Continue
		If v = pnlHeader Then Continue
		If v = pnlContent Then Continue
		Dim l As Int = v.Left
		Dim t As Int = v.Top
		Dim w As Int = v.Width
		Dim h As Int = v.Height
		v.RemoveViewFromParent
		pnlContent.AddView(v, l, t, w, h)
	Next
End Sub

'/**
' * @method ApplyDesignerProps
' * @param Props Designer/runtime properties map.
' * @description
' *  Maps incoming property values to strongly typed backing fields (m*).
' *  Uses B4XDaisyVariants helpers for token resolution, type coercion, defaults, and normalization.
' *  This routine mutates state only; it does not perform layout by itself.
' */
Private Sub ApplyDesignerProps(mProps As Map)
	mWidthSpec = B4XDaisyVariants.GetPropString(mProps, "Width", mWidthSpec)
	mHeightSpec = B4XDaisyVariants.GetPropString(mProps, "Height", mHeightSpec)
	mBackgroundColor = ResolveColorValue(mProps.Get("BackgroundColor"), B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White))
	mBorderColor = ResolveColorValue(mProps.Get("BorderColor"), B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(224, 224, 228)))
	mBorderSizeDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "BorderSize", 1)) * 1dip
	mRounded = NormalizeRoundedMode(B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded))

	' Backward compatibility: migrate legacy RoundedBox=True designer prop
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
	        mRounded = "rounded-box"
	    End If
	End If
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
	mShowHeader = B4XDaisyVariants.GetPropBool(mProps, "ShowHeader", mShowHeader)
	mHeaderHeightDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "HeaderHeight", 24)) * 1dip
	mShowControls = B4XDaisyVariants.GetPropBool(mProps, "ShowControls", mShowControls)
	msToolBarTitle = B4XDaisyVariants.GetPropString(mProps, "ToolBarTitle", msToolBarTitle)
	mContentPaddingSpec = B4XDaisyVariants.GetPropString(mProps, "ContentPadding", mContentPaddingSpec)
	ResolveContentPadding
	mAutoHeight = B4XDaisyVariants.GetPropBool(mProps, "AutoHeight", mAutoHeight)
End Sub

Sub ResolveColorValue(oValue As Object, iDefaultColor As Int) As Int
	If oValue = Null Then Return iDefaultColor
	If IsNumber(oValue) Then
		Dim c As Int = oValue
		If c = 0 Then Return iDefaultColor
		Return c
	End If
	Dim s As String = oValue
	s = s.Trim
	If s.Length = 0 Then Return iDefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, iDefaultColor)
	Return iDefaultColor
End Sub


'/**
' * @method NormalizeRoundedMode
' * @param Value Arbitrary rounded mode input.
' * @returns String Canonical rounded mode key used by this component.
' * @description Normalizes aliases such as "sm", "default", "full" into supported keys.
' */
Private Sub NormalizeRoundedMode(sValue As String) As String
	If sValue = Null Then Return "theme"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "", "theme", "selector"
			Return "theme"
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
		Case Else
			Return "theme"
	End Select
End Sub

'/**
' * @method ResolveCornerRadiusDip
' * @returns Float Corner radius in dip for SetColorAndBorder.
' * @description
' *  If Rounded="theme", radius comes from Daisy radius token only when RoundedBox=True.
' *  Otherwise returns explicit resolved rounded-* value.
' */
Private Sub ResolveCornerRadiusDip As Float
	Dim mode As String = NormalizeRoundedMode(mRounded)
	If mode = "theme" Then
		If mRounded = "rounded-box" Or mRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
		Return 0
	End If
	Return B4XDaisyVariants.ResolveRoundedDip(mode, B4XDaisyVariants.GetRadiusBoxDip(8dip))
End Sub



'/**
' * @method ResolvePxSizeSpec
' * @param SizeDip Numeric dip size.
' * @returns String px-formatted size spec (e.g. "320px") used in Props maps.
' */
Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

'/**
' * @method MeasureContentBottom
' * @returns Int Bottom-most occupied Y coordinate inside pnlContent.
' * @description Used by AutoHeight to determine required content area height.
' */
Private Sub MeasureContentBottom As Int
	If pnlContent.IsInitialized = False Then Return 0
	Dim m As Int = 0
	For i = 0 To pnlContent.NumberOfViews - 1
		Dim v As B4XView = pnlContent.GetView(i)
		m = Max(m, v.Top + v.Height)
	Next
	Return m
End Sub

'/**
' * @method Refresh
' * @description
' *  Central render/layout pass.
' *  Responsibilities:
' *  - Apply shell visuals (background, border, corner radius, elevation).
' *  - Configure header and divider rule visibility/geometry.
' *  - Position and style control dots.
' *  - Layout optional header-content slot.
' *  - Compute content panel bounds from header height + content padding.
' *  - When AutoHeight is enabled, resize mBase to fit content children.
' *
' *  Called from:
' *  - DesignerCreateView
' *  - Base_Resize
' *  - All public setters after state mutation
' */
Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	Dim w As Int = IIf(mCachedW > 0, mCachedW, mBase.Width)
	w = Max(1dip, w)
	Dim h As Int = IIf(mCachedH > 0, mCachedH, mBase.Height)
	h = Max(1dip, h)

	mBase.SetColorAndBorder(mBackgroundColor, mBorderSizeDip, mBorderColor, ResolveCornerRadiusDip)
	B4XDaisyVariants.ApplyElevation(mBase, mShadow)
	B4XDaisyVariants.DisableClipping(mBase)
	If mBase.Parent.IsInitialized Then B4XDaisyVariants.DisableClipping(mBase.Parent)

	Dim headerH As Int = IIf(mShowHeader, Max(0, mHeaderHeightDip), 0)
	pnlHeader.Visible = (headerH > 0)
	pnlHeader.SetLayoutAnimated(0, 0, 0, w, headerH)

	If headerH > 0 Then
		pnlHeaderRule.Visible = (mBorderSizeDip > 0)
		pnlHeaderRule.Color = B4XDaisyVariants.SetAlpha(mBorderColor, 150)
		pnlHeaderRule.SetLayoutAnimated(0, 0, Max(0, headerH - Max(1dip, mBorderSizeDip)), w, Max(1dip, mBorderSizeDip))
	Else
		pnlHeaderRule.Visible = False
		pnlHeaderRule.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If

	' Compute dotsRight (x-axis only) before header content layout
	Dim ds As Int = Max(4dip, mControlSizeDip)
	Dim dLeftPad As Int = Max(10dip, mCPLeft + 8dip)
	Dim dotsRight As Int = dLeftPad
	If mShowHeader And mShowControls And headerH > 0 Then
		dotsRight = dLeftPad + ds + mControlGapDip + ds + mControlGapDip + ds
	End If
	Dim effectiveHeaderH As Int = LayoutHeaderContent(w, headerH, dotsRight)
	If effectiveHeaderH > headerH Then
		headerH = effectiveHeaderH
		pnlHeader.SetLayoutAnimated(0, 0, 0, w, headerH)
		If mBorderSizeDip > 0 Then
			pnlHeaderRule.SetLayoutAnimated(0, 0, Max(0, headerH - Max(1dip, mBorderSizeDip)), w, Max(1dip, mBorderSizeDip))
		End If
	End If
	' Position dots, aligning vertically with toolbar pill centre when visible
	Dim dotCenterY As Int = 0
	If msToolBarTitle.Length > 0 And mShowControls And pnlToolBar.IsInitialized Then
		If pnlToolBar.Width > 0 Then
			dotCenterY = pnlHeaderContent.Top + pnlToolBar.Top + pnlToolBar.Height / 2
		End If
	End If
	LayoutDots(w, headerH, dotCenterY)

	If mAutoHeight Then
		Dim requiredContentBottom As Int = MeasureContentBottom
		Dim targetH As Int = headerH + mCPTop + requiredContentBottom + mCPBottom
		targetH = Max(1dip, targetH)
		' Compare against both mCachedH and mBase.Height:
		' mBase.Height may still be collapsed (e.g. from an earlier pass with no children)
		' even when targetH - mCachedH, so we must also resize when mBase.Height differs.
		If Abs(targetH - h) > 1dip Or Abs(targetH - mBase.Height) > 1dip Then
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, targetH)
			mCachedH = targetH
			h = targetH
		End If
	End If

	Dim contentLeft As Int = mCPLeft
	Dim contentTop As Int = headerH + mCPTop
	Dim contentW As Int = Max(0, w - mCPLeft - mCPRight)
	Dim contentH As Int = Max(0, h - headerH - mCPTop - mCPBottom)
	pnlContent.SetLayoutAnimated(0, contentLeft, contentTop, contentW, contentH)
End Sub

'/**
' * @method LayoutDots
' * @param Width Header width.
' * @param HeaderHeight Header height.
' * @returns Int Right-most x occupied by control dots.
' * @description
' *  Handles visibility, geometry, and circular styling of the three control dots.
' *  Dots are left-aligned with minimal safe padding for visual balance.
' */
Private Sub LayoutDots(iWidth As Int, iHeaderHeight As Int, iCenterY As Int) As Int
	Dim leftPad As Int = Max(10dip, mCPLeft + 8dip)
	Dim show As Boolean = (mShowHeader And mShowControls And iHeaderHeight > 0)
	dot1.Visible = show
	dot2.Visible = show
	dot3.Visible = show
	If show = False Then
		dot1.SetLayoutAnimated(0, 0, 0, 0, 0)
		dot2.SetLayoutAnimated(0, 0, 0, 0, 0)
		dot3.SetLayoutAnimated(0, 0, 0, 0, 0)
		Return leftPad
	End If

	Dim s As Int = Max(4dip, mControlSizeDip)
	Dim y As Int
	If iCenterY > 0 Then
		y = Max(0, iCenterY - s / 2)
	Else
		y = Max(0, (iHeaderHeight - s) / 2)
	End If
	Dim x1 As Int = leftPad
	Dim x2 As Int = x1 + s + mControlGapDip
	Dim x3 As Int = x2 + s + mControlGapDip

	dot1.SetLayoutAnimated(0, x1, y, s, s)
	dot2.SetLayoutAnimated(0, x2, y, s, s)
	dot3.SetLayoutAnimated(0, x3, y, s, s)

	Dim r As Float = s / 2
	dot1.SetColorAndBorder(0xFFFF5F57, 0, xui.Color_Transparent, r)
	dot2.SetColorAndBorder(0xFFFFBD2E, 0, xui.Color_Transparent, r)
	dot3.SetColorAndBorder(0xFF28C840, 0, xui.Color_Transparent, r)
	Return x3 + s
End Sub

'/**
' * @method LayoutHeaderContent
' * @param Width Header width.
' * @param HeaderHeight Header height.
' * @param DotsRight Right-most x occupied by control dots.
' * @description
' *  Positions the header slot where optional controls (for example an address/input bar)
' *  can be added without overlapping the left control dots.
' */
Private Sub LayoutHeaderContent(iWidth As Int, iHeaderHeight As Int, iDotsRight As Int) As Int
	If pnlHeaderContent.IsInitialized = False Then Return iHeaderHeight
	If iHeaderHeight <= 0 Then
		pnlHeaderContent.Visible = False
		pnlHeaderContent.SetLayoutAnimated(0, 0, 0, 0, 0)
		LayoutToolBar(0, 0)
		Return 0
	End If

	Dim sidePad As Int = Max(10dip, mCPLeft + 8dip)
	Dim left As Int = sidePad
	If mShowControls Then left = Max(left, iDotsRight + Max(8dip, mControlGapDip))
	Dim topPad As Int = Max(2dip, Round(iHeaderHeight * 0.16))
	Dim slotW As Int = Max(0, iWidth - left - sidePad)
	Dim slotH As Int = Max(0, iHeaderHeight - (topPad * 2))

	pnlHeaderContent.Visible = (slotW > 0 And slotH > 0)
	pnlHeaderContent.SetLayoutAnimated(0, left, topPad, slotW, slotH)
	Dim actualBarH As Int = LayoutToolBar(slotW, slotH)
	If actualBarH > slotH Then
		' Pill grew beyond slot - expand pnlHeaderContent and tell Refresh to grow pnlHeader
		pnlHeaderContent.SetLayoutAnimated(0, left, topPad, slotW, actualBarH)
		Return actualBarH + (topPad * 2)
	End If
	Return iHeaderHeight
End Sub

'/**
' * @method LayoutToolBar
' * @param SlotW Available width inside pnlHeaderContent.
' * @param SlotH Available height inside pnlHeaderContent.
' * @description
' *  Shows or hides the built-in toolbar pill. Visible only when msToolBarTitle is non-empty.
' */
Private Sub LayoutToolBar(iSlotW As Int, iSlotH As Int) As Int
	If pnlToolBar.IsInitialized = False Then Return 0
	Dim show As Boolean = (msToolBarTitle.Length > 0 And iSlotW > 0 And iSlotH > 0)
	pnlToolBar.Visible = show
	If show = False Then
		pnlToolBar.SetLayoutAnimated(0, 0, 0, 0, 0)
		Return 0
	End If
	Dim barW As Int = Max(0, iSlotW - 20dip)
	Dim labelW As Int = Max(1dip, barW - 20dip)
	' Disable AutoResize so setters do not shrink mBase during property assignment
	lblToolBarTitle.AutoResize = False
	' Provisional width layout so lblContent has a valid width for GetPreferredHeight
	lblToolBarTitle.mBase.SetLayoutAnimated(0, 10dip, 0, labelW, Max(iSlotH, 60dip))
	lblToolBarTitle.TextSize = 12
	lblToolBarTitle.Text = msToolBarTitle
	lblToolBarTitle.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray)
	lblToolBarTitle.HAlign = "CENTER"
	lblToolBarTitle.VAlign = "CENTER"
	' Measure natural wrap height at labelW and TextSize=12 without touching mBase
	Dim textH As Int = lblToolBarTitle.GetPreferredHeight(labelW)
	Dim barH As Int = Max(Max(18dip, iSlotH), textH)
	Dim barLeft As Int = Max(0, (iSlotW - barW) / 2)
	' Centre pill vertically within pnlHeaderContent
	Dim pillTop As Int = Max(0, (iSlotH - barH) / 2)
	pnlToolBar.SetLayoutAnimated(0, barLeft, pillTop, barW, barH)
	pnlToolBar.SetColorAndBorder(B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White), 1dip, B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(220, 220, 224)), 4dip)
	' Base_Resize calls ApplyVisual (no DoAutoResize) so lblContent is correctly centred at barH
	lblToolBarTitle.Base_Resize(labelW, barH)
	Return barH
End Sub

'/**
' * @method Base_Resize
' * @description B4X resize hook. Delegates to Refresh for full layout recomputation.
' */
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If inResize Then Return
	inResize = True
	If dWidth > 0 Then mCachedW = dWidth
	If dHeight > 0 Then mCachedH = dHeight
	Refresh
	inResize = False
End Sub

'/**
' * @method AddToParent
' * @param Parent Target parent container.
' * @param Left X position in parent.
' * @param Top Y position in parent.
' * @param Width Optional explicit width (<=0 resolves from Width spec).
' * @param Height Optional explicit height (<=0 resolves from Height spec).
' * @returns B4XView The attached root view (mBase), or empty view if Parent is invalid.
' * @description
' *  Programmatic attach entry point.
' *  - Lazily creates mBase when needed using BuildRuntimeProps.
' *  - Reparents existing mBase when moving between containers.
' *  - Always ends with Refresh for deterministic visual state.
' */
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = iWidth
	Dim h As Int = iHeight
	If w <= 0 Then w = B4XDaisyVariants.ResolveSizeSpec(mWidthSpec, vParent.Width, mDefaultWidthDip)
	If h <= 0 Then h = B4XDaisyVariants.ResolveSizeSpec(mHeightSpec, vParent.Height, mDefaultHeightDip)
	w = Max(1dip, w)
	h = Max(1dip, h)

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.Color = xui.Color_Transparent
		b.SetLayoutAnimated(0, 0, 0, w, h)
		Dim props As Map = BuildRuntimeProps
		props.Put("Width", ResolvePxSizeSpec(w))
		props.Put("Height", ResolvePxSizeSpec(h))
		DesignerCreateView(b, Null, props)
	End If

	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, w, h)
	mCachedW = w
	mCachedH = h
	Refresh
	Return mBase
End Sub

'/**
' * @method BuildRuntimeProps
' * @returns Map Snapshot of current public-facing property values.
' * @description
' *  Serialization helper used by programmatic creation/recreation paths.
' *  Keep this map in sync with ApplyDesignerProps and public property names.
' *  Any new configurable property should be added to both methods.
' */
Private Sub BuildRuntimeProps As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", mWidthSpec)
	props.Put("Height", mHeightSpec)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("BorderColor", mBorderColor)
	props.Put("BorderSize", Round(mBorderSizeDip / 1dip))
	props.Put("Rounded", mRounded)
	props.Put("Shadow", mShadow)
	props.Put("ShowHeader", mShowHeader)
	props.Put("HeaderHeight", Round(mHeaderHeightDip / 1dip))
	props.Put("ShowControls", mShowControls)
	props.Put("ToolBarTitle", msToolBarTitle)
	props.Put("ContentPadding", mContentPaddingSpec)
	props.Put("AutoHeight", mAutoHeight)
	Return props
End Sub

'/**
' * @method Content
' * @returns B4XView Internal content host where consumer views should be added.
' * @description Safe accessor that returns an empty view if not initialized.
' */
Public Sub Content As B4XView
	Dim empty As B4XView
	If pnlContent.IsInitialized = False Then Return empty
	Return pnlContent
End Sub
' */
Public Sub ContentWidth As Int
	Dim w As Int = IIf(mCachedW > 0, mCachedW, mBase.Width)
	w = Max(1dip, w)
	Return Max(0, w - mCPLeft - mCPRight)
End Sub

'/**
' * @method ContentHeight
' * @returns Int Computed pixel height of the content area.
' * @description
' *  Computes directly from mBase.Height, mHeaderHeightDip and content padding.
' *  Use this instead of Content.Height for the same layout-timing reason as
' *  ContentWidth.
' */
Public Sub ContentHeight As Int
	Dim h As Int = IIf(mCachedH > 0, mCachedH, mBase.Height)
	h = Max(1dip, h)
	Dim hH As Int = IIf(mShowHeader, Max(0, mHeaderHeightDip), 0)
	Return Max(0, h - hH - mCPTop - mCPBottom)
End Sub

'/**
' * @method GetHeaderPanel
' * @returns B4XView Internal header slot for optional header controls.
' * @description
' *  Use this for browser-like header composition (address bar, search field, actions).
' */
Public Sub GetHeaderPanel As B4XView
	Dim empty As B4XView
	If pnlHeaderContent.IsInitialized = False Then Return empty
	Return pnlHeaderContent
End Sub

'/**
' * @method AddContentView
' * @param v View to add inside the content area.
' * @param Left X position in content panel.
' * @param Top Y position in content panel.
' * @param Width Child width.
' * @param Height Child height.
' * @description Convenience wrapper over pnlContent.AddView.
' */
Public Sub AddContentView(vView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If pnlContent.IsInitialized = False Then Return
	pnlContent.AddView(vView, iLeft, iTop, iWidth, iHeight)
	If mAutoHeight Then Refresh
End Sub

'/**
' * @method AddHeaderView
' * @param v View to add inside header slot.
' * @param Left X position in header slot.
' * @param Top Y position in header slot.
' * @param Width Child width.
' * @param Height Child height.
' * @description Convenience wrapper over header slot AddView.
' */
Public Sub AddHeaderView(vView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If pnlHeaderContent.IsInitialized = False Then Return
	If vView.IsInitialized = False Then Return
	vView.RemoveViewFromParent
	pnlHeaderContent.AddView(vView, iLeft, iTop, iWidth, iHeight)
	Refresh
End Sub

'/**
' * @method ClearContent
' * @description Removes all views currently inside the content panel.
' */
Public Sub ClearContent
	If pnlContent.IsInitialized = False Then Return
	pnlContent.RemoveAllViews
	If mAutoHeight Then Refresh
End Sub

'/**
' * @method RefreshContent
' * @description
' *  Public trigger for a full layout pass.
' *  Call this after manually adding views to GetContentPanel when AutoHeight=True
' *  so MeasureContentBottom can see the new children and resize mBase accordingly.
' */
Public Sub RefreshContent
	Refresh
End Sub

'/**
' * @method ClearHeader
' * @description Removes all views currently inside the header slot.
' */
Public Sub ClearHeader
	If pnlHeaderContent.IsInitialized = False Then Return
	pnlHeaderContent.RemoveAllViews
	Refresh
End Sub

'/**
' * @property Tag
' * @description
' *  Mirrors default B4X custom view tag behavior:
' *  - mTag stores the user tag.
' *  - mBase.Tag is set to Me for framework/internal routing.
' */
Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
	If mBase.IsInitialized Then mBase.Tag = oValue
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

'/**
' * @property Width / Height
' * @description
' *  String-based layout specs, resolved against parent size when needed.
' *  Setter behavior:
' *  - update backing spec
' *  - if attached, resolve new axis size and apply to mBase
' *  - call Refresh
' */
Public Sub setWidth(sValue As String)
	mWidthSpec = sValue
	If mBase.IsInitialized = False Then Return
	If mBase.Parent.IsInitialized Then
		Dim w As Int = B4XDaisyVariants.ResolveSizeSpec(mWidthSpec, mBase.Parent.Width, mBase.Width)
		mBase.Width = w
	End If
	Refresh
End Sub

Public Sub getWidth As String
	Return mWidthSpec
End Sub

Public Sub setHeight(sValue As String)
	mHeightSpec = sValue
	If mBase.IsInitialized = False Then Return
	If mBase.Parent.IsInitialized Then
		Dim h As Int = B4XDaisyVariants.ResolveSizeSpec(mHeightSpec, mBase.Parent.Height, mBase.Height)
		mBase.Height = h
	End If
	Refresh
End Sub

Public Sub getHeight As String
	Return mHeightSpec
End Sub

'/**
' * @property BackgroundColor / BorderColor / BorderSize
' * @description Visual shell styling APIs. Colors accept int or token-like object values.
' */
Public Sub setBackgroundColor(oValue As Object)
	mBackgroundColor = B4XDaisyVariants.ResolveColorValue(oValue, mBackgroundColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setBorderColor(oValue As Object)
	mBorderColor = B4XDaisyVariants.ResolveColorValue(oValue, mBorderColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setBorderSize(iValue As Int)
	mBorderSizeDip = Max(0, iValue) * 1dip
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderSize As Int
	Return Round(mBorderSizeDip / 1dip)
End Sub

'/**
' * @property Rounded / RoundedBox / Shadow
' * @description Corner radius and elevation controls for the outer shell.
' */
Public Sub setRounded(sValue As String)
	mRounded = NormalizeRoundedMode(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setShadow(sValue As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	Return mShadow
End Sub

'/**
' * @property ShowHeader / HeaderHeight / ShowControls
' * @description Controls header visibility and control-dot visibility/height.
' */
Public Sub setShowHeader(bValue As Boolean)
	mShowHeader = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShowHeader As Boolean
	Return mShowHeader
End Sub

Public Sub setHeaderHeight(iValue As Int)
	mHeaderHeightDip = Max(0, iValue) * 1dip
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getHeaderHeight As Int
	Return Round(mHeaderHeightDip / 1dip)
End Sub

Public Sub setShowControls(bValue As Boolean)
	mShowControls = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShowControls As Boolean
	Return mShowControls
End Sub

'/**
' * @property ContentPadding
' * @description Tailwind padding class string applied to the content panel bounds.
' *  Accepts p-*, px-*, py-*, pl-*, pr-*, pt-*, pb-* tokens or a bare number (dip).
' *  Default: "p-4"
' */
Public Sub setContentPadding(sValue As String)
	mContentPaddingSpec = sValue
	ResolveContentPadding
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getContentPadding As String
	Return mContentPaddingSpec
End Sub

'/**
' * @property ToolBarTitle
' * @description Text shown centred in the built-in header toolbar pill.
' *  Set to an empty string (default) to hide the toolbar entirely.
' */
Public Sub setToolBarTitle(sValue As String)
	msToolBarTitle = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getToolBarTitle As String
	Return msToolBarTitle
End Sub

Private Sub ResolveContentPadding
	Dim defaultPad As Int = B4XDaisyVariants.TailwindSpacingToDip(4, 16dip)
	Dim spec As String = mContentPaddingSpec
	If spec = Null Then spec = ""
	spec = spec.Trim
	If spec = "" Then
		mCPLeft = defaultPad
		mCPTop = defaultPad
		mCPRight = defaultPad
		mCPBottom = defaultPad
		Return
	End If
	Dim tokens() As String = Regex.Split("\s+", spec)
	Dim pl As Int = -1
	Dim pt As Int = -1
	Dim pr As Int = -1
	Dim pb As Int = -1
	For Each tok As String In tokens
		Dim t As String = tok.Trim.ToLowerCase
		If t = "" Then Continue
		If t.StartsWith("p-") Then
			Dim v As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(2), defaultPad)
			pl = v : pt = v : pr = v : pb = v
		Else If t.StartsWith("px-") Then
			Dim vx As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), defaultPad)
			pl = vx : pr = vx
		Else If t.StartsWith("py-") Then
			Dim vy As Int = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), defaultPad)
			pt = vy : pb = vy
		Else If t.StartsWith("pt-") Then
			pt = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), defaultPad)
		Else If t.StartsWith("pr-") Then
			pr = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), defaultPad)
		Else If t.StartsWith("pb-") Then
			pb = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), defaultPad)
		Else If t.StartsWith("pl-") Then
			pl = B4XDaisyVariants.TailwindSpacingToDip(t.SubString(3), defaultPad)
		Else
			Dim raw As Int = B4XDaisyVariants.TailwindSpacingToDip(t, -1)
			If raw >= 0 Then
				pl = raw : pt = raw : pr = raw : pb = raw
			End If
		End If
	Next
	mCPLeft   = IIf(pl >= 0, pl, defaultPad)
	mCPTop    = IIf(pt >= 0, pt, defaultPad)
	mCPRight  = IIf(pr >= 0, pr, defaultPad)
	mCPBottom = IIf(pb >= 0, pb, defaultPad)
End Sub

'/**
' * @property AutoHeight
' * @description
' *  When true, total window height follows content children:
' *  header + top padding + max(child bottom) + bottom padding.
' */
Public Sub setAutoHeight(bValue As Boolean)
	mAutoHeight = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAutoHeight As Boolean
	Return mAutoHeight
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