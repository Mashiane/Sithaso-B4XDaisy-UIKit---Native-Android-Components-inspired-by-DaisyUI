B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#Event: Click (Tag As Object)
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Card width token.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: auto, Description: Card height token (auto, h-64, h-[500px], etc).
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: Card Title, Description: Title text.
#DesignerProperty: Key: ImagePath, DisplayName: Image Path, FieldType: String, DefaultValue:, Description: Asset Or full path.
#DesignerProperty: Key: ImageWidth, DisplayName: Image Width, FieldType: String, DefaultValue: w-full, Description: Image width token.
#DesignerProperty: Key: ImageHeight, DisplayName: Image Height, FieldType: String, DefaultValue: h-full, Description: Image height token.
#DesignerProperty: Key: ImageClasses, DisplayName: Image Classes, FieldType: String, DefaultValue:, Description: Extra image utility classes.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Size token.
#DesignerProperty: Key: Style, DisplayName: Style, FieldType: String, DefaultValue: none, List: none|border|dash, Description: Border style.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic variant For full-card background/text colors.
#DesignerProperty: Key: LayoutMode, DisplayName: Layout Mode, FieldType: String, DefaultValue: top, List: top|bottom|side|overlay|none, Description: Figure placement.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit card background color override (0 uses theme token).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit text color override For all content inside card body (0 uses theme token).
#DesignerProperty: Key: PlaceItemsCenter, DisplayName: Place Items Center, FieldType: Boolean, DefaultValue: False, Description: Centers title/actions content similar To place-items-center.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: sm, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show Or hide card.
#IgnoreWarnings:12,9

Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView
	Private pnlFigure As B4XView
	Private avatarFigure As B4XDaisyAvatar
	Private pnlOverlay As B4XView
	Private pnlBody As B4XView
	Private pnlTitle As B4XView
	Private pnlContent As B4XView
	Private partTitle As B4XDaisyCardTitle
	Private pnlActions As B4XView
	Private partActions As B4XDaisyCardActions
	Private partBody As B4XDaisyCardBody
	Private mWidth As String = "w-full"
	Private mHeight As String = "auto"
	Private mTitle As String = "Card Title"
	Private mImagePath As String = ""
	Private mImageWidth As String = "w-full"
	Private mImageHeight As String = "h-full"
	Private mImageClasses As String = ""
	Private mImageBitmap As B4XBitmap
	Private mSize As String = "md"
	Private mCardStyle As String = "none"
	Private mVariant As String = "none"
	Private mLayoutMode As String = "top"
	Private mRounded As String = "theme"
	Private mShadow As String = "sm"
	Private mVisible As Boolean = True
	Private mPlaceItemsCenter As Boolean = False
	Private mTitleVisible As Boolean = True
	Private mActionsVisible As Boolean = True
	Private mImageVisible As Boolean = True
	Private mBackColor As Int = 0
	Private mTextColor As Int = 0
	Private mApplyingAutoHeight As Boolean = False
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
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
	ApplyDesignerProps(mProps)
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mWidth = B4XDaisyVariants.GetPropString(mProps, "Width", mWidth)
	mHeight = NormalizeHeightSpec(B4XDaisyVariants.GetPropString(mProps, "Height", mHeight))
	mTitle = B4XDaisyVariants.GetPropString(mProps, "Title", mTitle)
	mImagePath = B4XDaisyVariants.GetPropString(mProps, "ImagePath", mImagePath)
	mImageWidth = B4XDaisyVariants.GetPropString(mProps, "ImageWidth", mImageWidth)
	mImageHeight = B4XDaisyVariants.GetPropString(mProps, "ImageHeight", mImageHeight)
	mImageClasses = B4XDaisyVariants.GetPropString(mProps, "ImageClasses", mImageClasses)
	mImageBitmap = LoadBitmapFromPath(mImagePath)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	Dim styleProp As String = B4XDaisyVariants.GetPropString(mProps, "Style", "")
	If styleProp.Trim.Length = 0 Then styleProp = B4XDaisyVariants.GetPropString(mProps, "CardStyle", "none")
	mCardStyle = NormalizeStyle(styleProp)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	mLayoutMode = NormalizeLayout(B4XDaisyVariants.GetPropString(mProps, "LayoutMode", mLayoutMode))
	mBackColor = B4XDaisyVariants.GetPropInt(mProps, "BackgroundColor", mBackColor)
	mTextColor = B4XDaisyVariants.GetPropInt(mProps, "TextColor", mTextColor)
	mPlaceItemsCenter = B4XDaisyVariants.GetPropBool(mProps, "PlaceItemsCenter", mPlaceItemsCenter)
	mRounded = NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded))
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", mShadow))
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
End Sub

Public Sub Refresh
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
	partActions.Justify = IIf(mPlaceItemsCenter, "center", "End")
	partActions.GapDip = partBody.GapDip
	Base_Resize(mBase.Width, mBase.Height)
	ApplyBodyTextColor(txt)
	ApplyBodyContentPlacement
End Sub

Private Sub ApplyBodyTextColor(iColorValue As Int)
	If pnlContent.IsInitialized = False Then Return
	ApplyBodyTextColorRecursive(pnlContent, iColorValue)
End Sub

Private Sub ApplyBodyTextColorRecursive(vParentView As B4XView, iColorValue As Int)
	If vParentView.IsInitialized = False Then Return
	If vParentView.Tag <> Null And vParentView.Tag <> "" Then Return
	ApplyNativeTextColor(vParentView, iColorValue)
	Dim childCount As Int
	Try
		childCount = vParentView.NumberOfViews
	Catch
		Return
	End Try
	For i = 0 To childCount - 1
		Dim child As B4XView = vParentView.GetView(i)
		ApplyBodyTextColorRecursive(child, iColorValue)
	Next
End Sub

Private Sub ApplyNativeTextColor(vTarget As B4XView, iColorValue As Int)
	#If B4A
		Try
			Dim jo As JavaObject = vTarget
			jo.RunMethod("setTextColor", Array(iColorValue))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCard.ApplyNativeTextColor: " & LastException.Message)
		End Try  'ignore
		#Else
		Dim ignore As Int = iColorValue
		Dim viewIgnore As Object = vTarget
	#End If
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	' Resolve auto-height BEFORE laying out children. The old post-layout
	' ApplyAutoHeightIfNeeded re-called Base_Resize, which bailed on the
	' inResize guard, so the body was never re-laid at the final height and
	' the actions row ended up clipped below the card's bottom edge.
	If IsAutoHeightSpec Then
		Dim desired As Int = ComputeAutoHeight(w)
		If Abs(desired - h) > 1dip Then
			h = desired
			mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
		End If
	End If
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
	inResize = False
End Sub

Private Sub ApplyBodyContentPlacement
	If pnlContent.IsInitialized = False Then Return
	ApplyBodyContentPlacementRecursive(pnlContent)
End Sub

Private Sub ApplyBodyContentPlacementRecursive(vParentView As B4XView)
	If vParentView.IsInitialized = False Then Return
	If vParentView.Tag <> Null And vParentView.Tag <> "" Then Return
	Dim childCount As Int
	Try
		childCount = vParentView.NumberOfViews
	Catch
		Return
	End Try
	For i = 0 To childCount - 1
		Dim child As B4XView = vParentView.GetView(i)
		ApplyBodyContentPlacementToView(child)
		ApplyBodyContentPlacementRecursive(child)
	Next
End Sub

Private Sub ApplyBodyContentPlacementToView(vTarget As B4XView)
	If vTarget.IsInitialized = False Then Return
	Try
		If vTarget Is Label Then
			Dim align As String = IIf(mPlaceItemsCenter, "CENTER", "LEFT")
			vTarget.SetTextAlignment("TOP", align)
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCard.ApplyBodyContentPlacementToView: " & LastException.Message)
		' Not a Label - skip
	End Try
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

Private Sub LayoutFigure(iWidth As Int, iHeight As Int, bOverlayMode As Boolean)
	If pnlFigure.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
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
	If bOverlayMode Then
		pnlOverlay.Visible = True
		pnlOverlay.Color = B4XDaisyVariants.SetAlpha(xui.Color_Black, 184)
	Else
		pnlOverlay.Visible = False
		pnlOverlay.Color = xui.Color_Transparent
	End If
End Sub

Private Sub LayoutBody(iWidth As Int, iHeight As Int, iPad As Int, iGap As Int)
	Dim w As Int = Max(1dip, iWidth)
	Dim contentW As Int = Max(1dip, w - (iPad * 2))
	Dim hasActionsRow As Boolean = mActionsVisible And (partActions.getContainer.NumberOfViews > 0)
	Dim actionsH As Int = IIf(hasActionsRow, MeasureActionsHeight(partActions.getContainer, contentW, partActions.GapDip, partActions.Wrap), 0)
	pnlActions.Visible = hasActionsRow
	Dim hasTitle As Boolean = mTitleVisible And (mTitle.Trim.Length > 0)
	Dim titleH As Int = 0
	If hasTitle Then
		titleH = Max(22dip, MeasureTitleHeight(partTitle.TextSize, contentW))
	End If
	Dim contentH As Int = MeasureContentHeight(pnlContent, contentW)
	Dim y As Int = iPad
	If hasTitle Then
		pnlTitle.Visible = True
		pnlTitle.SetLayoutAnimated(0, iPad, y, contentW, titleH)
		partTitle.SetLayoutAnimated(0, 0, 0, contentW, titleH)
		y = y + titleH
		If contentH > 0 Or hasActionsRow Then y = y + iGap
	Else
		pnlTitle.Visible = False
		pnlTitle.SetLayoutAnimated(0, 0, 0, 0, 0)
		partTitle.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
	pnlContent.SetLayoutAnimated(0, iPad, y, contentW, contentH)
	If contentH > 0 Then y = y + contentH
	If hasActionsRow And (hasTitle Or contentH > 0) Then y = y + iGap
	If hasActionsRow Then
		pnlActions.SetLayoutAnimated(0, iPad, y, contentW, actionsH)
		partActions.SetLayoutAnimated(0, 0, 0, contentW, actionsH)
		partActions.Relayout
	Else
		pnlActions.SetLayoutAnimated(0, 0, 0, 0, 0)
		partActions.SetLayoutAnimated(0, 0, 0, 0, 0)
	End If
End Sub

Private Sub MeasureContentHeight(vContainer As B4XView, iAvailableWidth As Int) As Int
	If vContainer.IsInitialized = False Then Return 0
	Dim maxBottom As Int = 0
	For i = 0 To vContainer.NumberOfViews - 1
		Dim v As B4XView = vContainer.GetView(i)
		If v.Visible = False Then Continue
		If v.Left = 0 And v.Width < = 1dip Then
			v.SetLayoutAnimated(0, 0, v.Top, iAvailableWidth, v.Height)
		End If
		maxBottom = Max(maxBottom, v.Top + v.Height)
	Next
	Return Max(0, maxBottom)
End Sub

Private Sub MeasureActionsHeight(vContainer As B4XView, iAvailableWidth As Int, iGapDip As Int, bWrap As Boolean) As Int
	If vContainer.IsInitialized = False Then Return 0
	Dim rowW As Int = 0
	Dim rowH As Int = 0
	Dim totalH As Int = 0
	Dim hasRow As Boolean = False
	For i = 0 To vContainer.NumberOfViews - 1
		Dim v As B4XView = vContainer.GetView(i)
		If v.Visible = False Then Continue
		Dim vw As Int = Max(1dip, Min(iAvailableWidth, v.Width))
		Dim vh As Int = Max(1dip, v.Height)
		Dim addW As Int = vw
		If hasRow Then addW = addW + iGapDip
		If bWrap And hasRow And rowW + addW > iAvailableWidth Then
			totalH = totalH + rowH + iGapDip
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

Private Sub ApplyAutoHeightIfNeeded(iCurrentWidth As Int, iCurrentHeight As Int)
	If mBase.IsInitialized = False Then Return
	If mApplyingAutoHeight Then Return
	If IsAutoHeightSpec = False Then Return
	Dim desired As Int = ComputeAutoHeight(iCurrentWidth)
	If Abs(desired - iCurrentHeight) < = 1dip Then Return
	mApplyingAutoHeight = True
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, Max(1dip, iCurrentWidth), Max(1dip, desired))
	mApplyingAutoHeight = False
	Base_Resize(iCurrentWidth, desired)
End Sub

Private Sub IsAutoHeightSpec As Boolean
	Dim s As String = IIf(mHeight = Null, "", mHeight.ToLowerCase.Trim)
	Return s = "" Or s = "auto"
End Sub

Private Sub MeasureTitleHeight(fFontSize As Float, iContentWidth As Int) As Int
	Try
		Dim lbl As Label = partTitle.getLabel
		If lbl.IsInitialized Then
			Dim tu As StringUtils
			Dim savedW As Int = lbl.Width
			lbl.Width = Max(1dip, iContentWidth)
			Dim h As Int = tu.MeasureMultilineTextHeight(lbl, mTitle)
			lbl.Width = savedW
			If h > 0 Then Return Max(1dip, h)
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCard.MeasureTitleHeight: " & LastException.Message)
	End Try  'ignore
	Return Max(1dip, Ceil(fFontSize * 1.8) + 4dip)
End Sub

Private Sub ComputeAutoHeight(iCardWidth As Int) As Int
	Dim w As Int = Max(1dip, iCardWidth)
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

Private Sub MeasureBodyRequiredHeight(iWidth As Int, iPad As Int, iGap As Int) As Int
	Dim w As Int = Max(1dip, iWidth)
	Dim contentW As Int = Max(1dip, w - (iPad * 2))
	Dim hasActionsRow As Boolean = mActionsVisible And (partActions.getContainer.NumberOfViews > 0)
	Dim actionsH As Int = IIf(hasActionsRow, MeasureActionsHeight(partActions.getContainer, contentW, partActions.GapDip, partActions.Wrap), 0)
	Dim hasTitle As Boolean = mTitleVisible And (mTitle.Trim.Length > 0)
	Dim titleH As Int = 0
	If hasTitle Then
		titleH = Max(22dip, MeasureTitleHeight(partTitle.TextSize, contentW))
	End If
	Dim contentH As Int = MeasureContentHeight(pnlContent, contentW)
	Dim y As Int = iPad
	If hasTitle Then
		y = y + titleH
		If contentH > 0 Or hasActionsRow Then y = y + iGap
	End If
	If contentH > 0 Then y = y + contentH
	If hasActionsRow Then
		If hasTitle Or contentH > 0 Then y = y + iGap
		y = y + actionsH
	End If
	y = y + iPad
	Return Max(1dip, y)
End Sub

Private Sub ResolveImageWidthDip(iContainerWidth As Int) As Int
	Dim token As String = ResolveImageToken("w-", mImageWidth)
	Dim cw As Int = Max(1dip, iContainerWidth)
	Dim s As String = IIf(token = Null, "", token.ToLowerCase.Trim)
	If s = "" Or s = "w-full" Or s = "full" Or s = "100%" Then Return cw
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, cw))
End Sub

Private Sub ResolveImageHeightDip(iContainerHeight As Int) As Int
	Dim token As String = ResolveImageToken("h-", mImageHeight)
	Dim ch As Int = Max(1dip, iContainerHeight)
	Dim s As String = IIf(token = Null, "", token.ToLowerCase.Trim)
	If s = "" Or s = "h-full" Or s = "full" Or s = "100%" Then Return ch
	If s = "auto" Then Return ch
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(token, ch))
End Sub

Private Sub ResolveImageToken(sPrefix As String, sDefaultToken As String) As String
	Dim token As String = sDefaultToken
	Dim cls As String = NormalizeClassList(mImageClasses)
	If cls.Length = 0 Then Return token
	Dim tokens() As String = Regex.Split("\s+", cls)
	For Each t As String In tokens
		If t.StartsWith(sPrefix) Then token = t
	Next
	Return token
End Sub

Private Sub NormalizeClassList(sValue As String) As String
	If sValue = Null Then Return ""
	Return Regex.Replace("\s+", sValue.ToLowerCase.Trim, " ")
End Sub

Private Sub NormalizeHeightSpec(sValue As String) As String
	Dim s As String = IIf(sValue = Null, "", sValue.Trim)
	If s.Length = 0 Then Return "auto"
	Return s
End Sub

Private Sub EffectiveLayout(iCurrentWidth As Int) As String
	Return mLayoutMode
End Sub

Private Sub ResolveRadius As Float
	If mRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(12dip)
	Return B4XDaisyVariants.ResolveRoundedDip(mRounded, B4XDaisyVariants.GetRadiusBoxDip(12dip))
End Sub

Private Sub EnsureImageLoaded As Boolean
	If mImageBitmap.IsInitialized Then Return True
	If mImagePath = Null Or mImagePath.Trim.Length = 0 Then Return False
	mImageBitmap = LoadBitmapFromPath(mImagePath)
	Return mImageBitmap.IsInitialized
End Sub

Private Sub LoadBitmapFromPath(sPath As String) As B4XBitmap
	Dim empty As B4XBitmap
	If sPath = Null Then Return empty
	Dim p As String = sPath.Trim
	If p.Length = 0 Then Return empty
	Try
		Dim slash1 As Int = p.LastIndexOf("/")
		Dim slash2 As Int = p.LastIndexOf("\")
		Dim slash As Int = Max(slash1, slash2)
		If slash > = 0 Then
			Dim dir As String = p.SubString2(0, slash)
			Dim fn As String = p.SubString(slash + 1)
			If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then Return xui.LoadBitmap(dir, fn)
		End If
		If File.Exists(File.DirAssets, p) Then Return xui.LoadBitmap(File.DirAssets, p)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCard.LoadBitmapFromPath: " & LastException.Message)
	End Try  'ignore
	Return empty
End Sub

Private Sub SizePad(sToken As String) As Int
	Select Case sToken
		Case "xs": Return 8dip
		Case "sm": Return 16dip
		Case "lg": Return 32dip
		Case "xl": Return 40dip
		Case Else: Return 24dip
	End Select
End Sub

Private Sub SizeTitleSp(sToken As String) As Float
	Select Case sToken
		Case "xs": Return 14
		Case "sm": Return 16
		Case "lg": Return 20
		Case "xl": Return 22
		Case Else: Return 18
	End Select
End Sub

Private Sub SizeBodySp(sToken As String) As Float
	Select Case sToken
		Case "xs": Return 11
		Case "sm": Return 12
		Case "lg": Return 16
		Case "xl": Return 18
		Case Else: Return 14
	End Select
End Sub

Private Sub NormalizeStyle(sValue As String) As String
	Dim s As String = IIf(sValue = Null, "", sValue.ToLowerCase.Trim)
	If s = "border" Or s = "dash" Then Return s
	Return "none"
End Sub

Private Sub NormalizeLayout(sValue As String) As String
	Dim s As String = IIf(sValue = Null, "", sValue.ToLowerCase.Trim)
	If s = "top" Or s = "bottom" Or s = "side" Or s = "overlay" Or s = "none" Then Return s
	Return "top"
End Sub

Private Sub NormalizeRounded(sValue As String) As String
	Dim s As String = IIf(sValue = Null, "", sValue.ToLowerCase.Trim)
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

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = IIf(iWidth > 0, iWidth, ResolveAutoWidth(vParent))
	Dim useAutoHeight As Boolean = (iHeight < = 0 And IsAutoHeightSpec)
	Dim h As Int
	If iHeight > 0 Then
		h = iHeight
	Else If useAutoHeight Then
		h = 1dip
	Else
		h = ResolveAutoHeight(vParent, w)
	End If
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, Max(1dip, w), Max(1dip, h))
		DesignerCreateView(b, Null, CreateMap())
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, Max(1dip, w), Max(1dip, h))
	Refresh
	Return mBase
End Sub

Private Sub ResolveAutoWidth(vParent As B4XView) As Int
	Dim s As String = IIf(mWidth = Null, "", mWidth.ToLowerCase.Trim)
	If s = "w-full" Or s = "full" Or s = "100%" Or s = "w-screen" Or s = "screen" Then
		If vParent.IsInitialized And vParent.Width > 0 Then Return Max(1dip, vParent.Width)
	End If
	Dim fallback As Int = IIf(vParent.IsInitialized And vParent.Width > 0, vParent.Width, 320dip)
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mWidth, fallback))
End Sub

Private Sub ResolveAutoHeight(vParent As B4XView, iCurrentWidth As Int) As Int
	Dim s As String = IIf(mHeight = Null, "", mHeight.ToLowerCase.Trim)
	If s = "" Or s = "auto" Then
		Return Max(1dip, ComputeAutoHeight(iCurrentWidth))
	End If
	If s = "h-full" Or s = "full" Or s = "100%" Or s = "h-screen" Or s = "screen" Then
		If vParent.IsInitialized And vParent.Height > 0 Then Return Max(1dip, vParent.Height)
	End If
	Dim fallback As Int = IIf(vParent.IsInitialized And vParent.Height > 0, vParent.Height, 360dip)
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mHeight, fallback))
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub GetActualHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub GetActualWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
	Base_Resize(iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
End Sub

Public Sub getFigureContainer As B4XView
	Return pnlFigure
End Sub

Public Sub getCardBody As B4XView
	Return pnlContent
End Sub

Public Sub getBodyPartContainer As B4XView
	Return pnlBody
End Sub

Public Sub getTitleContainer As B4XView
	Return partTitle.getContainer
End Sub

Public Sub getCardTitle As B4XView
	Return partTitle.getExtrasContainer
End Sub

Public Sub getCardActions As B4XView
	Return partActions.getContainer
End Sub

Public Sub getContainer As B4XView
	Return mBase
End Sub

Public Sub getBodyContainer As B4XView
	Return pnlContent
End Sub

Public Sub getTitleExtrasContainer As B4XView
	Return partTitle.getExtrasContainer
End Sub

Public Sub getActionsContainer As B4XView
	Return partActions.getContainer
End Sub

''' Adds a B4XDaisyButton to the card actions footer.
''' The button is created inside the actions slot automatically - no external AddToParent needed.
''' Usage: card.AddAction(btn)
''' Note: Call card.Refresh after adding all actions to trigger layout.
Public Sub AddAction(btn As B4XDaisyButton)
    If mBase.IsInitialized = False Then Return
    If btn.mBase.IsInitialized = False Or btn.mBase.Width < 1dip Then
        btn.AddToParent(partActions.getContainer, 0, 0, 80dip, 32dip)
    Else
        If btn.mBase.Parent <> partActions.getContainer Then
            partActions.getContainer.AddView(btn.mBase, 0, 0, btn.mBase.Width, btn.mBase.Height)
        End If
    End If
End Sub

''' Returns the number of action buttons currently in the footer.
Public Sub getActionsCount As Int
    Return partActions.getContainer.NumberOfViews
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setTitle(sValue As String)
	mTitle = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTitle As String
	Return mTitle
End Sub

Public Sub setHeight(sValue As String)
	mHeight = NormalizeHeightSpec(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getHeight As String
	Return mHeight
End Sub

Public Sub setImagePath(sValue As String)
	mImagePath = sValue
	mImageBitmap = LoadBitmapFromPath(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setImageWidth(sValue As String)
	mImageWidth = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getImageWidth As String
	Return mImageWidth
End Sub

Public Sub setImageHeight(sValue As String)
	mImageHeight = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getImageHeight As String
	Return mImageHeight
End Sub

Public Sub setImageClasses(sValue As String)
	mImageClasses = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getImageClasses As String
	Return mImageClasses
End Sub

Public Sub SetImage(bmpImage As B4XBitmap)
	mImageBitmap = bmpImage
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub ClearImage
	Dim e As B4XBitmap
	mImageBitmap = e
	mImagePath = ""
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setStyle(sValue As String)
	mCardStyle = NormalizeStyle(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setPlaceItemsCenter(bValue As Boolean)
	mPlaceItemsCenter = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getPlaceItemsCenter As Boolean
	Return mPlaceItemsCenter
End Sub

Public Sub ShowTitle
	mTitleVisible = True
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub HideTitle
	mTitleVisible = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub ShowActions
	mActionsVisible = True
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub HideActions
	mActionsVisible = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub ShowImage
	mImageVisible = True
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub HideImage
	mImageVisible = False
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	mBackColor = 0
	mTextColor = 0
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setLayoutMode(sValue As String)
	mLayoutMode = NormalizeLayout(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setRounded(sValue As String)
	mRounded = NormalizeRounded(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setShadow(sValue As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
	mBackColor = B4XDaisyVariants.ResolveBackgroundColorVariant(sVariantName, mBackColor)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	mTextColor = B4XDaisyVariants.ResolveTextColorVariant(sVariantName, mTextColor)
	If mBase.IsInitialized Then Refresh
End Sub

Private Sub surface_Click
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	End If
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
