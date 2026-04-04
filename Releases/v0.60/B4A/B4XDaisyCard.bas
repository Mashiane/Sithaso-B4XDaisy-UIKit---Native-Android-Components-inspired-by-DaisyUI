B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'/**
' * B4XDaisyCard
' * -----------------------------------------------------------------------------
' * Lean Daisy card component used by designer and programmatic APIs.
' *
' * Core behavior:
' * - Builds a predictable view tree (figure/body/title/actions).
' * - Maps designer props directly to backing fields.
' * - Resolves theme tokens through B4XDaisyVariants.
' * - Raises Click callback.
' */

#Event: Click (Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Card width token.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Card height token (auto, h-64, h-[500px], etc).
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: Card Title, Description: Title text.
#DesignerProperty: Key: ImagePath, DisplayName: Image Path, FieldType: String, DefaultValue:, Description: Asset or full path.
#DesignerProperty: Key: ImageWidth, DisplayName: Image Width, FieldType: String, DefaultValue: w-full, Description: Image width token.
#DesignerProperty: Key: ImageHeight, DisplayName: Image Height, FieldType: String, DefaultValue: h-full, Description: Image height token.
#DesignerProperty: Key: ImageClasses, DisplayName: Image Classes, FieldType: String, DefaultValue:, Description: Extra image utility classes.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size token.
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: none, List: none|border|dash, Description: Border style.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic variant for full-card background/text colors.
#DesignerProperty: Key: LayoutMode, DisplayName: Layout Mode, FieldType: String, DefaultValue: top, List: top|bottom|side|overlay|none, Description: Figure placement.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit card background color override (0 uses theme token).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit text color override for all content inside card body (0 uses theme token).
#DesignerProperty: Key: PlaceItemsCenter, DisplayName: Place Items Center, FieldType: Boolean, DefaultValue: False, Description: Centers title/actions content similar to place-items-center.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: sm, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide card.

'/**
' * Module runtime state used for rendering, interaction, and designer wiring.
' */
#IgnoreWarnings:12
Sub Class_Globals
	'/** Cross-platform helper facade for colors, bitmap loading, and callback discovery. */
	Private xui As XUI
	'/** Target object that receives raised events from this component. */
	Private mCallBack As Object
	'/** Event prefix used to build callback names like <EventName>_Click. */
	Private mEventName As String
	'/** Opaque caller-owned payload forwarded in raised events. */
	Private mTag As Object

	'/** Root B4XView for the card component. */
	Public mBase As B4XView
	'/** Container for media/figure content. */
	Private pnlFigure As B4XView
	'/** Avatar-based image host inside pnlFigure. */
	Private avatarFigure As B4XDaisyAvatar
	'/** Overlay panel used in overlay layout mode for contrast. */
	Private pnlOverlay As B4XView
	'/** Container that hosts title, body text, and actions. */
	Private pnlBody As B4XView
	'/** Container for the title label. */
	Private pnlTitle As B4XView
	'/** Container for custom body content between title and actions parts. */
	Private pnlContent As B4XView
	'/** Standalone title part component. */
	Private partTitle As B4XDaisyCardTitle
	'/** Container for action buttons. */
	Private pnlActions As B4XView
	'/** Standalone actions part component. */
	Private partActions As B4XDaisyCardActions
	'/** Standalone body part metrics component. */
	Private partBody As B4XDaisyCardBody

	'/** Requested width token/value from designer properties. */
	Private mWidth As String = "w-full"
	'/** Requested height token/value from designer properties. */
	Private mHeight As String = "auto"
	'/** Card title text content. */
	Private mTitle As String = "Card Title"
	'/** Image source path (filesystem or assets). */
	Private mImagePath As String = ""
	'/** Image width token/value from designer properties. */
	Private mImageWidth As String = "w-full"
	'/** Image height token/value from designer properties. */
	Private mImageHeight As String = "h-full"
	'/** Image utility classes used for fit/position behavior. */
	Private mImageClasses As String = ""
	'/** Cached bitmap loaded from mImagePath or set programmatically. */
	Private mImageBitmap As B4XBitmap
	'/** Size token that scales paddings and text sizes. */
	Private mSize As String = "md"
	'/** Border style token: none, border, or dash. */
	Private mCardStyle As String = "none"
	'/** Semantic variant token controlling full-card background/text colors. */
	Private mVariant As String = "none"
	'/** Requested layout mode for figure placement. */
	Private mLayoutMode As String = "top"
	'/** Rounded token controlling corner radius resolution. */
	Private mRounded As String = "theme"
	'/** Shadow/elevation token. */
	Private mShadow As String = "sm"
	'/** Visibility flag mirrored to mBase.Visible during refresh. */
	Private mVisible As Boolean = True
	'/** Align title/actions content to center when True. */
	Private mPlaceItemsCenter As Boolean = False
	'/** Title visibility state used by ShowTitle/HideTitle helpers. */
	Private mTitleVisible As Boolean = True
	'/** Actions visibility state used by ShowActions/HideActions helpers. */
	Private mActionsVisible As Boolean = True
	'/** Figure/image visibility state used by ShowImage/HideImage helpers. */
	Private mImageVisible As Boolean = True

	'/** Optional explicit background color override. */
	Private mBackColor As Int = 0
	'/** Optional explicit text color override. */
	Private mTextColor As Int = 0
	'/** Prevents recursive auto-height relayout loops. */
	Private mApplyingAutoHeight As Boolean = False
End Sub

'/**
' * Stores callback target and event prefix used by this component when raising events.
' * @param Callback (Object) Object that will receive raised events.
' * @param EventName (String) Event name prefix used to build callback method names.
' */
Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

'/**
' * Builds the internal view hierarchy, applies designer properties, and performs initial render.
' * @param Base (Object) Designer-provided root panel object.
' * @param Lbl (Label) Designer label placeholder from custom view contract.
' * @param Props (Map) Designer properties map.
' */
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim pf As Panel
	pf.Initialize("surface")
	pnlFigure = pf
	mBase.AddView(pnlFigure, 0, 0, 1dip, 1dip)

	avatarFigure.Initialize(Me, "")
	avatarFigure.AddToParent(pnlFigure, 0, 0, 1dip, 1dip)
	avatarFigure.setAvatarType("image")
	avatarFigure.setRoundedBox(False)
	avatarFigure.setMask("none")
	avatarFigure.setCenterOnParent(False)
	avatarFigure.setChatImage(False)
	avatarFigure.setShadow("none")

	Dim po As Panel
	po.Initialize("")
	pnlOverlay = po
	pnlOverlay.Color = xui.Color_Transparent
	pnlFigure.AddView(pnlOverlay, 0, 0, 1dip, 1dip)
	
	Dim pb As Panel
	pb.Initialize("surface")
	pnlBody = pb
	mBase.AddView(pnlBody, 0, 0, 1dip, 1dip)
	partBody.Initialize(Me, "")

	Dim pt As Panel
	pt.Initialize("surface")
	pnlTitle = pt
	pnlBody.AddView(pnlTitle, 0, 0, 1dip, 1dip)
	partTitle.Initialize(Me, "")
	partTitle.AddToParent(pnlTitle, 0, 0, 1dip, 1dip)

	Dim pc As Panel
	pc.Initialize("")
	pnlContent = pc
	pnlBody.AddView(pnlContent, 0, 0, 1dip, 1dip)

	Dim pa As Panel
	pa.Initialize("surface")
	pnlActions = pa
	pnlBody.AddView(pnlActions, 0, 0, 1dip, 1dip)
	partActions.Initialize(Me, "")
	partActions.AddToParent(pnlActions, 0, 0, 1dip, 1dip)
	partActions.Wrap = True
	partActions.GapDip = 8dip

	ApplyDesignerProps(Props)
	Refresh
End Sub

'/**
' * Maps designer properties directly into backing fields and normalizes token values.
' * @param Props (Map) Designer properties map.
' */
Private Sub ApplyDesignerProps(Props As Map)
	mWidth = B4XDaisyVariants.GetPropString(Props, "Width", mWidth)
	mHeight = NormalizeHeightSpec(B4XDaisyVariants.GetPropString(Props, "Height", mHeight))
	mTitle = B4XDaisyVariants.GetPropString(Props, "Title", mTitle)
	mImagePath = B4XDaisyVariants.GetPropString(Props, "ImagePath", mImagePath)
	mImageWidth = B4XDaisyVariants.GetPropString(Props, "ImageWidth", mImageWidth)
	mImageHeight = B4XDaisyVariants.GetPropString(Props, "ImageHeight", mImageHeight)
	mImageClasses = B4XDaisyVariants.GetPropString(Props, "ImageClasses", mImageClasses)
	mImageBitmap = LoadBitmapFromPath(mImagePath)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", "md"))
	Dim styleProp As String = B4XDaisyVariants.GetPropString(Props, "Style", "")
	If styleProp.Trim.Length = 0 Then styleProp = B4XDaisyVariants.GetPropString(Props, "CardStyle", "none")
	mCardStyle = NormalizeStyle(styleProp)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "none"))
	mLayoutMode = NormalizeLayout(B4XDaisyVariants.GetPropString(Props, "LayoutMode", "top"))
	mBackColor = B4XDaisyVariants.GetPropInt(Props, "BackgroundColor", mBackColor)
	mTextColor = B4XDaisyVariants.GetPropInt(Props, "TextColor", mTextColor)
	mPlaceItemsCenter = B4XDaisyVariants.GetPropBool(Props, "PlaceItemsCenter", mPlaceItemsCenter)
	mRounded = NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "sm"))
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
End Sub

'/**
' * Recomputes style, text, and layout from current state and applies the final visual output.
' */
Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	Dim defaultBack As Int = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
	Dim defaultText As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	Dim variantBack As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, defaultBack)
	Dim variantText As Int = B4XDaisyVariants.ResolveTextColorVariant(mVariant, defaultText)
	Dim back As Int = IIf(mBackColor <> 0, mBackColor, variantBack)
	Dim txt As Int = IIf(mTextColor <> 0, mTextColor, variantText)
	Dim bdr As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(226, 232, 240))
	Dim borderSize As Int = IIf(mCardStyle = "none", 0, 1dip)

	B4XDaisyVariants.ApplyDashedBorder(mBase, back, borderSize, bdr, ResolveRadius, mCardStyle)
	B4XDaisyVariants.ApplyElevation(mBase, mShadow)
	mBase.Visible = mVisible

	partBody.Size = mSize
	partTitle.Text = mTitle
	partTitle.Size = mSize
	partTitle.Centered = mPlaceItemsCenter
	partTitle.TextColor = txt
	partActions.Justify = IIf(mPlaceItemsCenter, "center", "end")
	partActions.GapDip = partBody.GapDip
	Base_Resize(mBase.Width, mBase.Height)
	ApplyBodyTextColor(txt)
	ApplyBodyContentPlacement
End Sub

Private Sub ApplyBodyTextColor(ColorValue As Int)
	If pnlBody.IsInitialized = False Then Return
	ApplyBodyTextColorRecursive(pnlBody, ColorValue)
End Sub

Private Sub ApplyBodyTextColorRecursive(ParentView As B4XView, ColorValue As Int)
	If ParentView.IsInitialized = False Then Return
	ApplyNativeTextColor(ParentView, ColorValue)
	Dim childCount As Int
	Try
		childCount = ParentView.NumberOfViews
	Catch
		Return
	End Try
	For i = 0 To childCount - 1
		Dim child As B4XView = ParentView.GetView(i)
		ApplyBodyTextColorRecursive(child, ColorValue)
	Next
End Sub

Private Sub ApplyNativeTextColor(Target As B4XView, ColorValue As Int)
	#If B4A
	Try
		Dim jo As JavaObject = Target
		jo.RunMethod("setTextColor", Array(ColorValue))
	Catch
	End Try 'ignore
	#Else
	Dim ignore As Int = ColorValue
	Dim viewIgnore As Object = Target
	#End If
End Sub

'/**
' * Performs responsive layout for figure/body regions and recomputes content geometry.
' * @param Width (Double) Width value in dip.
' * @param Height (Double) Height value in dip.
' */
Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim mode As String = EffectiveLayout(w)
	partBody.Size = mSize
	partTitle.Size = mSize
	Dim pad As Int = partBody.PaddingDip
	Dim gap As Int = partBody.GapDip

	partTitle.Centered = mPlaceItemsCenter

	Dim hasImg As Boolean = EnsureImageLoaded
	Dim showFigure As Boolean = mImageVisible And (mode <> "none") And hasImg

	Select Case mode
		Case "side"
			Dim fw As Int = IIf(showFigure, Max(110dip, Round(w * 0.42)), 0)
			If showFigure Then
				pnlFigure.Visible = True
				pnlFigure.SetLayoutAnimated(0, 0, 0, fw, h)
			Else
				CollapseFigure
			End If
			pnlBody.SetLayoutAnimated(0, fw, 0, Max(1dip, w - fw), h)
			If showFigure Then LayoutFigure(fw, h, False)
		Case "bottom"
			Dim fhBottom As Int = IIf(showFigure, Max(96dip, Min(Round(w * 0.62), Round(h * 0.66))), 0)
			pnlBody.SetLayoutAnimated(0, 0, 0, w, Max(1dip, h - fhBottom))
			If showFigure Then
				pnlFigure.Visible = True
				pnlFigure.SetLayoutAnimated(0, 0, h - fhBottom, w, fhBottom)
				LayoutFigure(w, fhBottom, False)
			Else
				CollapseFigure
			End If
		Case "overlay"
			pnlBody.SetLayoutAnimated(0, 0, 0, w, h)
			If showFigure Then
				pnlFigure.Visible = True
				pnlFigure.SetLayoutAnimated(0, 0, 0, w, h)
				LayoutFigure(w, h, True)
			Else
				CollapseFigure
			End If
		Case Else
			Dim fhTop As Int = IIf(showFigure, Max(96dip, Min(Round(w * 0.62), Round(h * 0.66))), 0)
			If showFigure Then
				pnlFigure.Visible = True
				pnlFigure.SetLayoutAnimated(0, 0, 0, w, fhTop)
			Else
				CollapseFigure
			End If
			pnlBody.SetLayoutAnimated(0, 0, fhTop, w, Max(1dip, h - fhTop))
			If showFigure Then LayoutFigure(w, fhTop, False)
	End Select
	LayoutBody(pnlBody.Width, pnlBody.Height, pad, gap)
	ApplyBodyContentPlacement
	ApplyAutoHeightIfNeeded(w, h)
End Sub

Private Sub ApplyBodyContentPlacement
	If pnlContent.IsInitialized = False Then Return
	ApplyBodyContentPlacementRecursive(pnlContent)
End Sub

Private Sub ApplyBodyContentPlacementRecursive(ParentView As B4XView)
	If ParentView.IsInitialized = False Then Return
	Dim childCount As Int
	Try
		childCount = ParentView.NumberOfViews
	Catch
		Return
	End Try
	For i = 0 To childCount - 1
		Dim child As B4XView = ParentView.GetView(i)
		ApplyBodyContentPlacementToView(child)
		ApplyBodyContentPlacementRecursive(child)
	Next
End Sub

Private Sub ApplyBodyContentPlacementToView(Target As B4XView)
	If Target.IsInitialized = False Then Return
	If Target Is Label Then
		Dim align As String = IIf(mPlaceItemsCenter, "CENTER", "LEFT")
		Target.SetTextAlignment("TOP", align)
	End If
End Sub

Private Sub CollapseFigure
	If pnlFigure.IsInitialized Then
		pnlFigure.Visible = False
		pnlFigure.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
	If pnlOverlay.IsInitialized Then
		pnlOverlay.Visible = False
		pnlOverlay.Color = xui.Color_Transparent
		pnlOverlay.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
	Dim avatarView As B4XView = avatarFigure.View
	If avatarView.IsInitialized Then avatarView.SetLayoutAnimated(0, 0, 0, 0, 0)
End Sub

'/**
' * Lays out and paints the figure/image region, including optional overlay mode.
' * @param Width (Int) Width value in dip.
' * @param Height (Int) Height value in dip.
' * @param OverlayMode (Boolean) True to show contrast overlay over the figure image.
' */
Private Sub LayoutFigure(Width As Int, Height As Int, OverlayMode As Boolean)
	If pnlFigure.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim iw As Int = ResolveImageWidthDip(w)
	Dim ih As Int = ResolveImageHeightDip(h)
	Dim ix As Int = Round((w - iw) / 2)
	Dim iy As Int = Round((h - ih) / 2)
	Dim avatarView As B4XView = avatarFigure.View
	avatarView.SetLayoutAnimated(0, ix, iy, iw, ih)
	avatarFigure.setWidth(iw & "px")
	avatarFigure.setHeight(ih & "px")
	avatarFigure.setCenterOnParent(False)
	avatarFigure.Base_Resize(iw, ih)
	If EnsureImageLoaded Then
		avatarFigure.setAvatarBitmap(mImageBitmap, Null)
		avatarFigure.setBackgroundColor(xui.Color_Transparent)
	Else
		avatarFigure.setAvatar("")
		avatarFigure.setBackgroundColor(B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(233, 238, 245)))
	End If
	pnlOverlay.SetLayoutAnimated(0, 0, 0, w, h)
	If OverlayMode Then
		pnlOverlay.Visible = True
		pnlOverlay.Color = B4XDaisyVariants.SetAlpha(xui.Color_Black, 184)
	Else
		pnlOverlay.Visible = False
		pnlOverlay.Color = xui.Color_Transparent
	End If
End Sub

'/**
' * Lays out title, body text, and action row inside the body container.
' * @param Width (Int) Width value in dip.
' * @param Height (Int) Height value in dip.
' * @param Pad (Int) Content padding value in dip.
' * @param Gap (Int) Vertical spacing value in dip.
' */
Private Sub LayoutBody(Width As Int, Height As Int, Pad As Int, Gap As Int)
	Dim w As Int = Max(1dip, Width)
	Dim contentW As Int = Max(1dip, w - (Pad * 2))
	Dim hasActionsRow As Boolean = mActionsVisible And (partActions.getContainer.NumberOfViews > 0)
	Dim actionsH As Int = IIf(hasActionsRow, MeasureActionsHeight(partActions.getContainer, contentW, partActions.GapDip, partActions.Wrap), 0)
	pnlActions.Visible = hasActionsRow

	Dim hasTitle As Boolean = mTitleVisible And (mTitle.Trim.Length > 0)
	Dim titleH As Int = 0
	If hasTitle Then
		titleH = Max(22dip, MeasureTitleHeight(partTitle.TextSize, contentW))
	End If
	Dim contentH As Int = MeasureContentHeight(pnlContent, contentW)

	Dim y As Int = Pad
	If hasTitle Then
		pnlTitle.Visible = True
		pnlTitle.SetLayoutAnimated(0, Pad, y, contentW, titleH)
		partTitle.SetLayoutAnimated(0, 0, 0, contentW, titleH)
		y = y + titleH
		If contentH > 0 Or hasActionsRow Then y = y + Gap
	Else
		pnlTitle.Visible = False
		pnlTitle.SetLayoutAnimated(0, 0, 0, 0, 0)
		partTitle.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If

	pnlContent.SetLayoutAnimated(0, Pad, y, contentW, contentH)
	If contentH > 0 Then y = y + contentH
	If hasActionsRow And (hasTitle Or contentH > 0) Then y = y + Gap

	If hasActionsRow Then
		pnlActions.SetLayoutAnimated(0, Pad, y, contentW, actionsH)
		partActions.SetLayoutAnimated(0, 0, 0, contentW, actionsH)
		partActions.Relayout
	Else
		pnlActions.SetLayoutAnimated(0, 0, 0, 0, 0)
		partActions.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
End Sub

Private Sub MeasureContentHeight(Container As B4XView, AvailableWidth As Int) As Int
	If Container.IsInitialized = False Then Return 0
	Dim maxBottom As Int = 0
	For i = 0 To Container.NumberOfViews - 1
		Dim v As B4XView = Container.GetView(i)
		If v.Visible = False Then Continue
		If v.Left = 0 And v.Width <= 1dip Then
			v.SetLayoutAnimated(0, 0, v.Top, AvailableWidth, v.Height)
		End If
		maxBottom = Max(maxBottom, v.Top + v.Height)
	Next
	Return Max(0, maxBottom)
End Sub

Private Sub MeasureActionsHeight(Container As B4XView, AvailableWidth As Int, GapDip As Int, Wrap As Boolean) As Int
	If Container.IsInitialized = False Then Return 0
	Dim rowW As Int = 0
	Dim rowH As Int = 0
	Dim totalH As Int = 0
	Dim hasRow As Boolean = False

	For i = 0 To Container.NumberOfViews - 1
		Dim v As B4XView = Container.GetView(i)
		If v.Visible = False Then Continue
		Dim vw As Int = Max(1dip, Min(AvailableWidth, v.Width))
		Dim vh As Int = Max(1dip, v.Height)
		Dim addW As Int = vw
		If hasRow Then addW = addW + GapDip

		If Wrap And hasRow And rowW + addW > AvailableWidth Then
			totalH = totalH + rowH + GapDip
			rowW = vw
			rowH = vh
		Else
			rowW = rowW + addW
			rowH = Max(rowH, vh)
		End If
		hasRow = True
	Next

	If hasRow Then totalH = totalH + rowH
	Return Max(0, totalH)
End Sub

Private Sub ApplyAutoHeightIfNeeded(CurrentWidth As Int, CurrentHeight As Int)
	If mBase.IsInitialized = False Then Return
	If mApplyingAutoHeight Then Return
	If IsAutoHeightSpec = False Then Return
	Dim desired As Int = ComputeAutoHeight(CurrentWidth)
	If Abs(desired - CurrentHeight) <= 1dip Then Return
	mApplyingAutoHeight = True
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, CurrentWidth), Max(1dip, desired))
	mApplyingAutoHeight = False
	Base_Resize(CurrentWidth, desired)
End Sub

Private Sub IsAutoHeightSpec As Boolean
	Dim s As String = IIf(mHeight = Null, "", mHeight.ToLowerCase.Trim)
	Return s = "" Or s = "auto"
End Sub

' Calculates the vertical size of the title row based on font size.
' Mimics the generic MeasureSingleLineHeight logic used elsewhere so that
' the card title container will never look too tall or too cramped compared
' to the Daisy CSS expectations.
Private Sub MeasureTitleHeight(FontSize As Float, ContentWidth As Int) As Int
	Try
		Dim lbl As Label = partTitle.getLabel
		If lbl.IsInitialized Then
			Dim tu As StringUtils
			Dim savedW As Int = lbl.Width
			lbl.Width = Max(1dip, ContentWidth)
			Dim h As Int = tu.MeasureMultilineTextHeight(lbl, mTitle)
			lbl.Width = savedW
			If h > 0 Then Return Max(1dip, h)
		End If
	Catch
	End Try	'ignore
	Return Max(1dip, Ceil(FontSize * 1.8) + 4dip)
End Sub

Private Sub ComputeAutoHeight(CardWidth As Int) As Int
	Dim w As Int = Max(1dip, CardWidth)
	Dim mode As String = EffectiveLayout(w)
	partBody.Size = mSize
	partTitle.Size = mSize
	Dim pad As Int = partBody.PaddingDip
	Dim gap As Int = partBody.GapDip

	Dim hasImg As Boolean = EnsureImageLoaded
	Dim showFigure As Boolean = mImageVisible And (mode <> "none") And hasImg

	Dim bodyW As Int = w
	If mode = "side" Then
		Dim fw As Int = IIf(showFigure, Max(110dip, Round(w * 0.42)), 0)
		bodyW = Max(1dip, w - fw)
	End If
	Dim bodyH As Int = MeasureBodyRequiredHeight(bodyW, pad, gap)

	Select Case mode
		Case "top", "bottom"
			Dim figH As Int = IIf(showFigure, Max(96dip, Round(w * 0.62)), 0)
			Return Max(1dip, figH + bodyH)
		Case "side"
			Dim minFigureH As Int = IIf(showFigure, 96dip, 0)
			Return Max(1dip, Max(bodyH, minFigureH))
		Case "overlay"
			Dim overlayH As Int = IIf(showFigure, Max(96dip, Round(w * 0.62)), 0)
			Return Max(1dip, Max(bodyH, overlayH))
		Case Else
			Return Max(1dip, bodyH)
	End Select
End Sub

Private Sub MeasureBodyRequiredHeight(Width As Int, Pad As Int, Gap As Int) As Int
	Dim w As Int = Max(1dip, Width)
	Dim contentW As Int = Max(1dip, w - (Pad * 2))
	Dim hasActionsRow As Boolean = mActionsVisible And (partActions.getContainer.NumberOfViews > 0)
	Dim actionsH As Int = IIf(hasActionsRow, MeasureActionsHeight(partActions.getContainer, contentW, partActions.GapDip, partActions.Wrap), 0)
	Dim hasTitle As Boolean = mTitleVisible And (mTitle.Trim.Length > 0)
	Dim titleH As Int = 0
	If hasTitle Then
		titleH = Max(22dip, MeasureTitleHeight(partTitle.TextSize, contentW))
	End If
	Dim contentH As Int = MeasureContentHeight(pnlContent, contentW)

	Dim y As Int = Pad
	If hasTitle Then
		y = y + titleH
		If contentH > 0 Or hasActionsRow Then y = y + Gap
	End If
	If contentH > 0 Then y = y + contentH
	If hasActionsRow Then
		If hasTitle Or contentH > 0 Then y = y + Gap
		y = y + actionsH
	End If
	' Match CSS card-body padding behavior by reserving bottom padding.
	y = y + Pad
	Return Max(1dip, y)
End Sub

Private Sub ResolveImageWidthDip(ContainerWidth As Int) As Int
	Dim token As String = ResolveImageToken("w-", mImageWidth)
	Dim cw As Int = Max(1dip, ContainerWidth)
	Dim s As String = IIf(token = Null, "", token.ToLowerCase.Trim)
	If s = "" Or s = "w-full" Or s = "full" Or s = "100%" Then Return cw
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, cw))
End Sub

Private Sub ResolveImageHeightDip(ContainerHeight As Int) As Int
	Dim token As String = ResolveImageToken("h-", mImageHeight)
	Dim ch As Int = Max(1dip, ContainerHeight)
	Dim s As String = IIf(token = Null, "", token.ToLowerCase.Trim)
	If s = "" Or s = "h-full" Or s = "full" Or s = "100%" Then Return ch
	If s = "auto" Then Return ch
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, ch))
End Sub

Private Sub ResolveImageToken(Prefix As String, DefaultToken As String) As String
	Dim token As String = DefaultToken
	Dim cls As String = NormalizeClassList(mImageClasses)
	If cls.Length = 0 Then Return token
	Dim tokens() As String = Regex.Split("\s+", cls)
	For Each t As String In tokens
		If t.StartsWith(Prefix) Then token = t
	Next
	Return token
End Sub

Private Sub NormalizeClassList(Value As String) As String
	If Value = Null Then Return ""
	Return Regex.Replace("\s+", Value.ToLowerCase.Trim, " ")
End Sub

Private Sub NormalizeHeightSpec(Value As String) As String
	Dim s As String = IIf(Value = Null, "", Value.Trim)
	If s.Length = 0 Then Return "auto"
	Return s
End Sub

'/**
' * Returns the effective layout token after responsive side-mode override logic.
' * @param CurrentWidth (Int) Current root width used for responsive decision.
' * @returns (String) Return value produced by EffectiveLayout.
' */
Private Sub EffectiveLayout(CurrentWidth As Int) As String
	Return mLayoutMode
End Sub

'/**
' * Resolves corner radius from rounded token or theme defaults.
' * @returns (Float) Return value produced by ResolveRadius.
' */
Private Sub ResolveRadius As Float
	If mRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(12dip)
	Return B4XDaisyVariants.ResolveRoundedDip(mRounded, B4XDaisyVariants.GetRadiusBoxDip(12dip))
End Sub

'/**
' * Ensures an image bitmap is available from cache or by loading current image path.
' * @returns (Boolean) Return value produced by EnsureImageLoaded.
' */
Private Sub EnsureImageLoaded As Boolean
	If mImageBitmap.IsInitialized Then Return True
	If mImagePath = Null Or mImagePath.Trim.Length = 0 Then Return False
	mImageBitmap = LoadBitmapFromPath(mImagePath)
	Return mImageBitmap.IsInitialized
End Sub

'/**
' * Attempts to load a bitmap from filesystem path first, then assets fallback.
' * @param Path (String) Input path string to resolve into a bitmap.
' * @returns (B4XBitmap) Return value produced by LoadBitmapFromPath.
' */
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
			If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then Return xui.LoadBitmap(dir, fn)
		End If
		If File.Exists(File.DirAssets, p) Then Return xui.LoadBitmap(File.DirAssets, p)
	Catch
	End Try 'ignore
	Return empty
End Sub

'/**
' * Converts size token into content padding.
' * @param Token (String) Size/style token string.
' * @returns (Int) Return value produced by SizePad.
' */
Private Sub SizePad(Token As String) As Int
	Select Case Token
		Case "xs": Return 8dip
		Case "sm": Return 16dip
		Case "lg": Return 32dip
		Case "xl": Return 40dip
		Case Else: Return 24dip
	End Select
End Sub

'/**
' * Converts size token into title font size.
' * @param Token (String) Size/style token string.
' * @returns (Float) Return value produced by SizeTitleSp.
' */
Private Sub SizeTitleSp(Token As String) As Float
	Select Case Token
		Case "xs": Return 14
		Case "sm": Return 16
		Case "lg": Return 20
		Case "xl": Return 22
		Case Else: Return 18
	End Select
End Sub

'/**
' * Converts size token into body font size.
' * @param Token (String) Size/style token string.
' * @returns (Float) Return value produced by SizeBodySp.
' */
Private Sub SizeBodySp(Token As String) As Float
	Select Case Token
		Case "xs": Return 11
		Case "sm": Return 12
		Case "lg": Return 16
		Case "xl": Return 18
		Case Else: Return 14
	End Select
End Sub

'/**
' * Normalizes arbitrary size input into supported size token values.
' * @param Value (String) New value to apply.
' * @returns (String) Return value produced by NormalizeSize.
' */


'/**
' * Normalizes style input into supported border style values.
' * @param Value (String) New value to apply.
' * @returns (String) Return value produced by NormalizeStyle.
' */
Private Sub NormalizeStyle(Value As String) As String
	Dim s As String = IIf(Value = Null, "", Value.ToLowerCase.Trim)
	If s = "border" Or s = "dash" Then Return s
	Return "none"
End Sub

'/**
' * Normalizes layout input into supported layout mode values.
' * @param Value (String) New value to apply.
' * @returns (String) Return value produced by NormalizeLayout.
' */
Private Sub NormalizeLayout(Value As String) As String
	Dim s As String = IIf(Value = Null, "", Value.ToLowerCase.Trim)
	If s = "top" Or s = "bottom" Or s = "side" Or s = "overlay" Or s = "none" Then Return s
	Return "top"
End Sub

'/**
' * Normalizes rounded input and aliases into canonical rounded tokens.
' * @param Value (String) New value to apply.
' * @returns (String) Return value produced by NormalizeRounded.
' */
Private Sub NormalizeRounded(Value As String) As String
	Dim s As String = IIf(Value = Null, "", Value.ToLowerCase.Trim)
	Select Case s
		Case "", "theme": Return "theme"
		Case "rounded-none", "none": Return "rounded-none"
		Case "rounded-sm", "sm": Return "rounded-sm"
		Case "rounded", "default": Return "rounded"
		Case "rounded-md", "md": Return "rounded-md"
		Case "rounded-lg", "lg": Return "rounded-lg"
		Case "rounded-xl", "xl": Return "rounded-xl"
		Case "rounded-2xl", "2xl": Return "rounded-2xl"
		Case "rounded-3xl", "3xl": Return "rounded-3xl"
		Case "rounded-full", "full": Return "rounded-full"
		Case Else: Return "theme"
	End Select
End Sub

'/**
' * Applies dashed border rendering using native GradientDrawable on B4A.
' * @param Target (B4XView) View that receives background drawable updates.

'/**
' * Programmatic creation helper that attaches the component to a parent and refreshes it.
' * @param Parent (B4XView) Parent container where the view should be added.
' * @param Left (Int) Left coordinate in dip.
' * @param Top (Int) Top coordinate in dip.
' * @param Width (Int) Width value in dip.
' * @param Height (Int) Height value in dip.
' * @returns (B4XView) Return value produced by AddToParent.
' */
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = IIf(Width > 0, Width, ResolveAutoWidth(Parent))
	Dim useAutoHeight As Boolean = (Height <= 0 And IsAutoHeightSpec)
	Dim h As Int
	If Height > 0 Then
		h = Height
	Else If useAutoHeight Then
		' For auto-height cards, create the view first with a minimal height.
		' Refresh/Base_Resize will compute and apply the real height after internal parts exist.
		h = 1dip
	Else
		h = ResolveAutoHeight(Parent, w)
	End If
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, Max(1dip, w), Max(1dip, h))
		DesignerCreateView(b, Null, CreateMap())
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	Parent.AddView(mBase, Left, Top, Max(1dip, w), Max(1dip, h))
	Refresh
	Return mBase
End Sub

Private Sub ResolveAutoWidth(Parent As B4XView) As Int
	Dim s As String = IIf(mWidth = Null, "", mWidth.ToLowerCase.Trim)
	If s = "w-full" Or s = "full" Or s = "100%" Or s = "w-screen" Or s = "screen" Then
		If Parent.IsInitialized And Parent.Width > 0 Then Return Max(1dip, Parent.Width)
	End If
	Dim fallback As Int = IIf(Parent.IsInitialized And Parent.Width > 0, Parent.Width, 320dip)
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mWidth, fallback))
End Sub

Private Sub ResolveAutoHeight(Parent As B4XView, CurrentWidth As Int) As Int
	Dim s As String = IIf(mHeight = Null, "", mHeight.ToLowerCase.Trim)
	If s = "" Or s = "auto" Then
		Return Max(1dip, ComputeAutoHeight(CurrentWidth))
	End If
	If s = "h-full" Or s = "full" Or s = "100%" Or s = "h-screen" Or s = "screen" Then
		If Parent.IsInitialized And Parent.Height > 0 Then Return Max(1dip, Parent.Height)
	End If
	Dim fallback As Int = IIf(Parent.IsInitialized And Parent.Height > 0, Parent.Height, 360dip)
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mHeight, fallback))
End Sub

'/**
' * Detaches root view from its parent if currently attached.
' */
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

'/**
' * Sets root layout with animation and then executes component resize pass.
' * @param Duration (Int) Layout animation duration in milliseconds.
' * @param Left (Int) Left coordinate in dip.
' * @param Top (Int) Top coordinate in dip.
' * @param Width (Int) Width value in dip.
' * @param Height (Int) Height value in dip.
' */
Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(Duration, Left, Top, Max(1dip, Width), Max(1dip, Height))
	Base_Resize(Width, Height)
End Sub

'/**
' * Updates root view left position when initialized.
' * @param Value (Int) New value to apply.
' */
Public Sub setLeft(Value As Int)
	If mBase.IsInitialized Then mBase.Left = Value
End Sub

'/**
' * Updates root view top position when initialized.
' * @param Value (Int) New value to apply.
' */
Public Sub setTop(Value As Int)
	If mBase.IsInitialized Then mBase.Top = Value
End Sub

'/**
' * Returns the figure container for advanced composition.
' * @returns (B4XView) Return value produced by getFigureContainer.
' */
Public Sub getFigureContainer As B4XView
	Return pnlFigure
End Sub

'/**
' * Returns the custom body-content container for advanced composition.
' * @returns (B4XView) Return value produced by getCardBody.
' */
Public Sub getCardBody As B4XView
	Return pnlContent
End Sub

'/**
' * Returns the full card-body container (title + content + actions).
' * @returns (B4XView) Return value produced by getBodyPartContainer.
' */
Public Sub getBodyPartContainer As B4XView
	Return pnlBody
End Sub

'/**
' * Returns the title container for advanced composition.
' * @returns (B4XView) Return value produced by getTitleContainer.
' */
Public Sub getTitleContainer As B4XView
	Return partTitle.getContainer
End Sub

'/**
' * Returns the title extras container (right side of card-title row) for badges / components.
' * @returns (B4XView) Return value produced by getCardTitle.
 ' */
Public Sub getCardTitle As B4XView
	Return partTitle.getExtrasContainer
End Sub

'/**
' * Returns the actions container for advanced composition.
' * @returns (B4XView) Return value produced by getCardActions.
 ' */
Public Sub getCardActions As B4XView
	Return partActions.getContainer
End Sub

'/**
' * Provides access to the root view of the card. Used by demos when
' * additional styling or manual border manipulation is required.
' */
Public Sub getContainer As B4XView
	Return mBase
End Sub

'/**
' * Deprecated alias for CardBody.
' * @returns (B4XView) Return value produced by getBodyContainer.
' */
Public Sub getBodyContainer As B4XView
	Return pnlContent
End Sub

'/**
' * Deprecated alias for CardTitle.
' * @returns (B4XView) Return value produced by getTitleExtrasContainer.
' */
Public Sub getTitleExtrasContainer As B4XView
	Return partTitle.getExtrasContainer
End Sub

'/**
' * Deprecated alias for CardActions.
' * @returns (B4XView) Return value produced by getActionsContainer.
' */
Public Sub getActionsContainer As B4XView
	Return partActions.getContainer
End Sub

'/**
' * Stores caller payload that will be echoed in callbacks.
' * @param Value (Object) New value to apply.
' */
Public Sub setTag(Value As Object)
	mTag = Value
End Sub

'/**
' * Returns current caller payload.
' * @returns (Object) Return value produced by getTag.
' */
Public Sub getTag As Object
	Return mTag
End Sub

'/**
' * Updates card title text and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setTitle(Value As String)
	mTitle = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current card title text.
' * @returns (String) Return value produced by getTitle.
' */
Public Sub getTitle As String
	Return mTitle
End Sub

'/**
' * Updates card height token/value (auto, h-64, h-[500px], etc) and refreshes.
' * @param Value (String) New height token/value.
' */
Public Sub setHeight(Value As String)
	mHeight = NormalizeHeightSpec(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current card height token/value.
' * @returns (String) Return value produced by getHeight.
' */
Public Sub getHeight As String
	Return mHeight
End Sub

'/**
' * Updates image path, reloads bitmap cache, and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setImagePath(Value As String)
	mImagePath = Value
	mImageBitmap = LoadBitmapFromPath(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Updates image width token/value (for example w-full, w-64) and refreshes.
' * @param Value (String) New value to apply.
' */
Public Sub setImageWidth(Value As String)
	mImageWidth = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current image width token/value.
' * @returns (String) Return value produced by getImageWidth.
' */
Public Sub getImageWidth As String
	Return mImageWidth
End Sub

'/**
' * Updates image height token/value (for example h-full, h-64) and refreshes.
' * @param Value (String) New value to apply.
' */
Public Sub setImageHeight(Value As String)
	mImageHeight = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current image height token/value.
' * @returns (String) Return value produced by getImageHeight.
' */
Public Sub getImageHeight As String
	Return mImageHeight
End Sub

'/**
' * Updates image classes and reapplies object-fit behavior.
' * @param Value (String) New class list value.
' */
Public Sub setImageClasses(Value As String)
	mImageClasses = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current image class list.
' * @returns (String) Return value produced by getImageClasses.
' */
Public Sub getImageClasses As String
	Return mImageClasses
End Sub

'/**
' * Sets image bitmap directly and refreshes the component.
' * @param Image (B4XBitmap) Bitmap to use for figure content.
' */
Public Sub SetImage(Image As B4XBitmap)
	mImageBitmap = Image
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Clears current image bitmap/path and refreshes the component.
' */
Public Sub ClearImage
	Dim e As B4XBitmap
	mImageBitmap = e
	mImagePath = ""
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Updates size token and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setSize(Value As String)
	mSize = B4XDaisyVariants.NormalizeSize(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current size token.
' * @returns (String) Return value produced by getSize.
' */
Public Sub getSize As String
	Return mSize
End Sub

'/**
' * Updates border style token and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setStyle(Value As String)
	mCardStyle = NormalizeStyle(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Toggles centered placement for title/actions content.
' * @param Value (Boolean) True to center items, False to keep default alignment.
' */
Public Sub setPlaceItemsCenter(Value As Boolean)
	mPlaceItemsCenter = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current place-items-center flag.
' * @returns (Boolean) Return value produced by getPlaceItemsCenter.
' */
Public Sub getPlaceItemsCenter As Boolean
	Return mPlaceItemsCenter
End Sub

'/**
' * Shows the title row and restores its measured layout size.
' */
Public Sub ShowTitle
	mTitleVisible = True
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

'/**
' * Hides the title row by collapsing it to 0x0.
' */
Public Sub HideTitle
	mTitleVisible = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

'/**
' * Shows the actions row and restores its measured layout size.
' */
Public Sub ShowActions
	mActionsVisible = True
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

'/**
' * Hides the actions row by collapsing it to 0x0.
' */
Public Sub HideActions
	mActionsVisible = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

'/**
' * Shows the figure/image region and restores its measured layout size.
' */
Public Sub ShowImage
	mImageVisible = True
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

'/**
' * Hides the figure/image region by collapsing it to 0x0.
' */
Public Sub HideImage
	mImageVisible = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

'/**
' * Updates semantic variant token and refreshes the component.
' * Setting variant clears explicit background/text overrides so the variant is fully applied.
' * @param Value (String) New value to apply.
' */
Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	mBackColor = 0
	mTextColor = 0
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current semantic variant token.
' * @returns (String) Return value produced by getVariant.
' */
Public Sub getVariant As String
	Return mVariant
End Sub

'/**
' * Updates layout mode token and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setLayoutMode(Value As String)
	mLayoutMode = NormalizeLayout(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Updates rounded token and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setRounded(Value As String)
	mRounded = NormalizeRounded(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Updates shadow token and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setShadow(Value As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(Value)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Updates visibility flag and refreshes the component.
' * @param Value (Boolean) New value to apply.
' */
Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Applies an explicit background color override. Set 0 to use theme default.
' * @param Value (Int) ARGB color value.
' */
Public Sub setBackgroundColor(Value As Int)
	mBackColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current explicit background color override (0 means theme default).
' * @returns (Int) Return value produced by getBackgroundColor.
' */
Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

'/**
' * Applies an explicit text color override. Set 0 to use theme default.
' * This affects all text-capable views inside the card body.
' * @param Value (Int) ARGB color value.
' */
Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Returns current explicit text color override (0 means theme default).
' * @returns (Int) Return value produced by getTextColor.
' */
Public Sub getTextColor As Int
	Return mTextColor
End Sub

'/**
' * Resolves and applies background variant override, then refreshes.
' * @param VariantName (String) Variant token used to resolve theme color override.
' */
Public Sub setBackgroundColorVariant(VariantName As String)
	mBackColor = B4XDaisyVariants.ResolveBackgroundColorVariant(VariantName, mBackColor)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Resolves and applies text variant override, then refreshes.
' * @param VariantName (String) Variant token used to resolve theme color override.
' */
Public Sub setTextColorVariant(VariantName As String)
	mTextColor = B4XDaisyVariants.ResolveTextColorVariant(VariantName, mTextColor)
	If mBase.IsInitialized Then Refresh
End Sub

'/**
' * Handles root surface click and dispatches Click callback.
' */
Private Sub surface_Click
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	End If
End Sub
