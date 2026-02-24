B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: ControlClick (Index As Int)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 100%, Description: Window width (for example 100%, 320dip, 320).
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 220, Description: Window height (for example 220, 220dip).
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Window background (0 uses bg-base-100).
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Window border color (0 uses border-base-300).
#DesignerProperty: Key: BorderSize, DisplayName: Border Size, FieldType: Int, DefaultValue: 1, Description: Border width in dip.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Corner radius mode.
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: True, Description: Use rounded-box radius when Rounded is theme.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl, Description: Elevation shadow level.
#DesignerProperty: Key: ShowHeader, DisplayName: Show Header, FieldType: Boolean, DefaultValue: True, Description: Show top header area.
#DesignerProperty: Key: HeaderHeight, DisplayName: Header Height, FieldType: Int, DefaultValue: 24, Description: Header height in dip.
#DesignerProperty: Key: ShowControls, DisplayName: Show Controls, FieldType: Boolean, DefaultValue: True, Description: Show top-left three control dots.
#DesignerProperty: Key: ControlColor, DisplayName: Control Color, FieldType: Color, DefaultValue: 0x00000000, Description: Control dot color (0 uses base-content with alpha).
#DesignerProperty: Key: ControlSize, DisplayName: Control Size, FieldType: Int, DefaultValue: 6, Description: Control dot diameter in dip.
#DesignerProperty: Key: ControlGap, DisplayName: Control Gap, FieldType: Int, DefaultValue: 6, Description: Gap between control dots in dip.
#DesignerProperty: Key: ContentPadding, DisplayName: Content Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in content area.
#DesignerProperty: Key: AutoHeight, DisplayName: Auto Height, FieldType: Boolean, DefaultValue: False, Description: Automatically grow/shrink height to fit content panel children.

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
' *  Event contract:
' *  - Raises <EventName>_ControlClick(Index As Int) when one of the header dots is tapped.
' *  - Dot index mapping is fixed: 1 = left, 2 = middle, 3 = right.
' *
' *  Notes for maintainers:
' *  - Backing fields are always m* variables. Public setters mutate m* first, then Refresh.
' *  - BuildCurrentProps is the canonical snapshot used for programmatic re-creation.
' *  - Keep Refresh idempotent and side-effect free outside visual/layout updates.
' */
Sub Class_Globals
	Private xui As XUI
	Private mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	Private mWidthSpec As String = "100%"
	Private mHeightSpec As String = "220"
	Private mBackgroundColor As Int = 0
	Private mBorderColor As Int = 0
	Private mBorderSizeDip As Int = 1dip
	Private mRounded As String = "theme"
	Private mRoundedBox As Boolean = True
	Private mShadow As String = "none"
	Private mShowHeader As Boolean = True
	Private mHeaderHeightDip As Int = 24dip
	Private mShowControls As Boolean = True
	Private mControlColor As Int = 0
	Private mControlSizeDip As Int = 6dip
	Private mControlGapDip As Int = 6dip
	Private mContentPaddingDip As Int = 0dip
	Private mAutoHeight As Boolean = False

	Private pnlHeader As B4XView
	Private pnlHeaderRule As B4XView
	Private pnlHeaderContent As B4XView
	Private pnlContent As B4XView
	Private dot1 As B4XView
	Private dot2 As B4XView
	Private dot3 As B4XView

	Private mDefaultWidthDip As Int = 320dip
	Private mDefaultHeightDip As Int = 220dip
End Sub

'/**
' * @method Initialize
' * @param Callback Owner object that receives component events.
' * @param EventName Event prefix used when raising callbacks.
' * @description Stores callback routing metadata only. No UI objects are created here.
' */
Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
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
Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map = BuildCurrentProps
	props.Put("Width", ResolvePxSizeSpec(Width))
	props.Put("Height", ResolvePxSizeSpec(Height))
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
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
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

	ApplyDesignerProps(Props)
	MoveChildrenToContent(existingChildren)
	Refresh
End Sub

'/**
' * @method CreateDot
' * @param Index Logical control index (1..3).
' * @returns B4XView Dot panel with Tag = Index.
' * @description Creates one clickable header control placeholder.
' */
Private Sub CreateDot(Index As Int) As B4XView
	Dim p As Panel
	p.Initialize("dot")
	Dim v As B4XView = p
	v.Color = xui.Color_Transparent
	v.Tag = Index
	Return v
End Sub

'/**
' * @method MoveChildrenToContent
' * @param Children List of existing children originally attached to mBase.
' * @description
' *  Re-parents user content into pnlContent so external code can still add controls on the
' *  custom view in the designer without manually targeting the internal content panel.
' */
Private Sub MoveChildrenToContent(Children As List)
	If Children.IsInitialized = False Then Return
	For Each v As B4XView In Children
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
Private Sub ApplyDesignerProps(Props As Map)
	mWidthSpec = B4XDaisyVariants.GetPropString(Props, "Width", "100%")
	mHeightSpec = B4XDaisyVariants.GetPropString(Props, "Height", "220")
	mBackgroundColor = ResolveColorValue(Props.Get("BackgroundColor"), B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White))
	mBorderColor = ResolveColorValue(Props.Get("BorderColor"), B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(224, 224, 228)))
	mBorderSizeDip = Max(0, B4XDaisyVariants.GetPropInt(Props, "BorderSize", 1)) * 1dip
	mRounded = NormalizeRoundedMode(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
	mRoundedBox = B4XDaisyVariants.GetPropBool(Props, "RoundedBox", True)
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
	mShowHeader = B4XDaisyVariants.GetPropBool(Props, "ShowHeader", True)
	mHeaderHeightDip = Max(0, B4XDaisyVariants.GetPropInt(Props, "HeaderHeight", 24)) * 1dip
	mShowControls = B4XDaisyVariants.GetPropBool(Props, "ShowControls", True)
	mControlColor = ResolveColorValue(Props.Get("ControlColor"), B4XDaisyVariants.SetAlpha(B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_DarkGray), 70))
	mControlSizeDip = Max(4dip, B4XDaisyVariants.GetPropInt(Props, "ControlSize", 6) * 1dip)
	mControlGapDip = Max(0, B4XDaisyVariants.GetPropInt(Props, "ControlGap", 6) * 1dip)
	mContentPaddingDip = Max(0, B4XDaisyVariants.GetPropInt(Props, "ContentPadding", 0) * 1dip)
	mAutoHeight = B4XDaisyVariants.GetPropBool(Props, "AutoHeight", False)
End Sub

'/**
' * @method ResolveColorValue
' * @param Value Input value from designer/runtime (Int or token-like text).
' * @param DefaultColor Fallback color when Value is empty/invalid/zero.
' * @returns Int Resolved ARGB color.
' * @description
' *  Accepts:
' *  - Numeric color values.
' *  - Daisy token names that map via ResolveThemeColorTokenName/GetTokenColor.
' *  Treats 0 as "use default" to align with designer property semantics.
' */
Private Sub ResolveColorValue(Value As Object, DefaultColor As Int) As Int
	If Value = Null Then Return DefaultColor
	If IsNumber(Value) Then
		Dim c As Int = Value
		If c = 0 Then Return DefaultColor
		Return c
	End If
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, DefaultColor)
	Return DefaultColor
End Sub

'/**
' * @method NormalizeRoundedMode
' * @param Value Arbitrary rounded mode input.
' * @returns String Canonical rounded mode key used by this component.
' * @description Normalizes aliases such as "sm", "default", "full" into supported keys.
' */
Private Sub NormalizeRoundedMode(Value As String) As String
	If Value = Null Then Return "theme"
	Dim s As String = Value.ToLowerCase.Trim
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
		If mRoundedBox Then Return B4XDaisyVariants.GetRadiusBoxDip(8dip)
		Return 0
	End If
	Return B4XDaisyVariants.ResolveRoundedDip(mode, B4XDaisyVariants.GetRadiusBoxDip(8dip))
End Sub

'/**
' * @method ResolveSizeSpec
' * @param Value Size expression (e.g. "100%", "320", "320dip", "320px").
' * @param ParentSize Parent axis size used for percentage resolution.
' * @param Fallback Fallback size when parsing fails.
' * @returns Int Resolved dip value clamped to at least 1dip.
' */
Private Sub ResolveSizeSpec(Value As String, ParentSize As Int, Fallback As Int) As Int
	Dim s As String = IIf(Value = Null, "", Value.Trim)
	If s.Length = 0 Then Return Max(1dip, Fallback)
	If s.EndsWith("%") Then
		Dim n As Float = s.SubString2(0, s.Length - 1)
		If IsNumber(n) Then
			Dim ref As Int = Max(1dip, ParentSize)
			Return Max(1dip, Round(ref * (n / 100)))
		End If
	End If
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(s, Fallback))
End Sub

'/**
' * @method ResolvePxSizeSpec
' * @param SizeDip Numeric dip size.
' * @returns String px-formatted size spec (e.g. "320px") used in Props maps.
' */
Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
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
	Dim w As Int = Max(1dip, mBase.Width)
	Dim h As Int = Max(1dip, mBase.Height)

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

	Dim dotsRight As Int = LayoutDots(w, headerH)
	LayoutHeaderContent(w, headerH, dotsRight)

	If mAutoHeight Then
		Dim requiredContentBottom As Int = MeasureContentBottom
		Dim targetH As Int = headerH + mContentPaddingDip + requiredContentBottom + mContentPaddingDip
		targetH = Max(1dip, targetH)
		If Abs(targetH - h) > 1dip Then
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, targetH)
			h = targetH
		End If
	End If

	Dim contentLeft As Int = mContentPaddingDip
	Dim contentTop As Int = headerH + mContentPaddingDip
	Dim contentW As Int = Max(0, w - (mContentPaddingDip * 2))
	Dim contentH As Int = Max(0, h - headerH - (mContentPaddingDip * 2))
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
Private Sub LayoutDots(Width As Int, HeaderHeight As Int) As Int
	Dim leftPad As Int = Max(10dip, mContentPaddingDip + 8dip)
	Dim show As Boolean = (mShowHeader And mShowControls And HeaderHeight > 0)
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
	Dim y As Int = Max(0, (HeaderHeight - s) / 2)
	Dim x1 As Int = leftPad
	Dim x2 As Int = x1 + s + mControlGapDip
	Dim x3 As Int = x2 + s + mControlGapDip

	dot1.SetLayoutAnimated(0, x1, y, s, s)
	dot2.SetLayoutAnimated(0, x2, y, s, s)
	dot3.SetLayoutAnimated(0, x3, y, s, s)

	Dim r As Float = s / 2
	dot1.SetColorAndBorder(mControlColor, 0, xui.Color_Transparent, r)
	dot2.SetColorAndBorder(mControlColor, 0, xui.Color_Transparent, r)
	dot3.SetColorAndBorder(mControlColor, 0, xui.Color_Transparent, r)
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
Private Sub LayoutHeaderContent(Width As Int, HeaderHeight As Int, DotsRight As Int)
	If pnlHeaderContent.IsInitialized = False Then Return
	If HeaderHeight <= 0 Then
		pnlHeaderContent.Visible = False
		pnlHeaderContent.SetLayoutAnimated(0, 0, 0, 0, 0)
		Return
	End If

	Dim sidePad As Int = Max(10dip, mContentPaddingDip + 8dip)
	Dim left As Int = sidePad
	If mShowControls Then left = Max(left, DotsRight + Max(8dip, mControlGapDip))
	Dim topPad As Int = Max(2dip, Round(HeaderHeight * 0.16))
	Dim slotW As Int = Max(0, Width - left - sidePad)
	Dim slotH As Int = Max(0, HeaderHeight - (topPad * 2))

	pnlHeaderContent.Visible = (slotW > 0 And slotH > 0)
	pnlHeaderContent.SetLayoutAnimated(0, left, topPad, slotW, slotH)
End Sub

'/**
' * @method dot_Click
' * @description
' *  Internal event bridge for all three control dots.
' *  Raises <EventName>_ControlClick(Index) only if the callback sub exists.
' */
Private Sub dot_Click
	Dim v As B4XView = Sender
	If xui.SubExists(mCallBack, mEventName & "_ControlClick", 1) Then
		CallSub2(mCallBack, mEventName & "_ControlClick", v.Tag)
	End If
End Sub

'/**
' * @method Base_Resize
' * @description B4X resize hook. Delegates to Refresh for full layout recomputation.
' */
Public Sub Base_Resize(Width As Double, Height As Double)
	Refresh
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
' *  - Lazily creates mBase when needed using BuildCurrentProps.
' *  - Reparents existing mBase when moving between containers.
' *  - Always ends with Refresh for deterministic visual state.
' */
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Width
	Dim h As Int = Height
	If w <= 0 Then w = ResolveSizeSpec(mWidthSpec, Parent.Width, mDefaultWidthDip)
	If h <= 0 Then h = ResolveSizeSpec(mHeightSpec, Parent.Height, mDefaultHeightDip)
	w = Max(1dip, w)
	h = Max(1dip, h)

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.Color = xui.Color_Transparent
		b.SetLayoutAnimated(0, 0, 0, w, h)
		Dim props As Map = BuildCurrentProps
		props.Put("Width", ResolvePxSizeSpec(w))
		props.Put("Height", ResolvePxSizeSpec(h))
		DesignerCreateView(b, Null, props)
	End If

	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	Parent.AddView(mBase, Left, Top, w, h)
	Refresh
	Return mBase
End Sub

'/**
' * @method BuildCurrentProps
' * @returns Map Snapshot of current public-facing property values.
' * @description
' *  Serialization helper used by programmatic creation/recreation paths.
' *  Keep this map in sync with ApplyDesignerProps and public property names.
' *  Any new configurable property should be added to both methods.
' */
Private Sub BuildCurrentProps As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", mWidthSpec)
	props.Put("Height", mHeightSpec)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("BorderColor", mBorderColor)
	props.Put("BorderSize", Round(mBorderSizeDip / 1dip))
	props.Put("Rounded", mRounded)
	props.Put("RoundedBox", mRoundedBox)
	props.Put("Shadow", mShadow)
	props.Put("ShowHeader", mShowHeader)
	props.Put("HeaderHeight", Round(mHeaderHeightDip / 1dip))
	props.Put("ShowControls", mShowControls)
	props.Put("ControlColor", mControlColor)
	props.Put("ControlSize", Round(mControlSizeDip / 1dip))
	props.Put("ControlGap", Round(mControlGapDip / 1dip))
	props.Put("ContentPadding", Round(mContentPaddingDip / 1dip))
	props.Put("AutoHeight", mAutoHeight)
	Return props
End Sub

'/**
' * @method GetContentPanel
' * @returns B4XView Internal content host where consumer views should be added.
' * @description Safe accessor that returns an empty view if not initialized.
' */
Public Sub GetContentPanel As B4XView
	Dim empty As B4XView
	If pnlContent.IsInitialized = False Then Return empty
	Return pnlContent
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
Public Sub AddContentView(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If pnlContent.IsInitialized = False Then Return
	pnlContent.AddView(v, Left, Top, Width, Height)
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
Public Sub AddHeaderView(v As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If pnlHeaderContent.IsInitialized = False Then Return
	If v.IsInitialized = False Then Return
	v.RemoveViewFromParent
	pnlHeaderContent.AddView(v, Left, Top, Width, Height)
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

Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized Then mBase.Tag = Value
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
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
Public Sub setWidth(Value As String)
	mWidthSpec = Value
	If mBase.IsInitialized = False Then Return
	If mBase.Parent.IsInitialized Then
		Dim w As Int = ResolveSizeSpec(mWidthSpec, mBase.Parent.Width, mBase.Width)
		mBase.Width = w
	End If
	Refresh
End Sub

Public Sub getWidth As String
	Return mWidthSpec
End Sub

Public Sub setHeight(Value As String)
	mHeightSpec = Value
	If mBase.IsInitialized = False Then Return
	If mBase.Parent.IsInitialized Then
		Dim h As Int = ResolveSizeSpec(mHeightSpec, mBase.Parent.Height, mBase.Height)
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
Public Sub setBackgroundColor(Value As Object)
	mBackgroundColor = ResolveColorValue(Value, mBackgroundColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setBorderColor(Value As Object)
	mBorderColor = ResolveColorValue(Value, mBorderColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setBorderSize(Value As Int)
	mBorderSizeDip = Max(0, Value) * 1dip
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
Public Sub setRounded(Value As String)
	mRounded = NormalizeRoundedMode(Value)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setShadow(Value As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(Value)
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
Public Sub setShowHeader(Value As Boolean)
	mShowHeader = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShowHeader As Boolean
	Return mShowHeader
End Sub

Public Sub setHeaderHeight(Value As Int)
	mHeaderHeightDip = Max(0, Value) * 1dip
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getHeaderHeight As Int
	Return Round(mHeaderHeightDip / 1dip)
End Sub

Public Sub setShowControls(Value As Boolean)
	mShowControls = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShowControls As Boolean
	Return mShowControls
End Sub

'/**
' * @property ControlColor / ControlSize / ControlGap
' * @description Styling and spacing for the three header control dots.
' */
Public Sub setControlColor(Value As Object)
	mControlColor = ResolveColorValue(Value, mControlColor)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getControlColor As Int
	Return mControlColor
End Sub

Public Sub setControlSize(Value As Int)
	mControlSizeDip = Max(4dip, Value * 1dip)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getControlSize As Int
	Return Round(mControlSizeDip / 1dip)
End Sub

Public Sub setControlGap(Value As Int)
	mControlGapDip = Max(0, Value) * 1dip
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getControlGap As Int
	Return Round(mControlGapDip / 1dip)
End Sub

'/**
' * @property ContentPadding
' * @description Uniform inner padding applied to the content panel bounds.
' */
Public Sub setContentPadding(Value As Int)
	mContentPaddingDip = Max(0, Value) * 1dip
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getContentPadding As Int
	Return Round(mContentPaddingDip / 1dip)
End Sub

'/**
' * @property AutoHeight
' * @description
' *  When true, total window height follows content children:
' *  header + top padding + max(child bottom) + bottom padding.
' */
Public Sub setAutoHeight(Value As Boolean)
	mAutoHeight = Value
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getAutoHeight As Boolean
	Return mAutoHeight
End Sub
