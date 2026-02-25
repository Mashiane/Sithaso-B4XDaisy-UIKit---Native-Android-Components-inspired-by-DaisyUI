B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private PAGE_PAD As Int = 12dip
	Private SECTION_GAP As Int = 16dip
	Private currentY As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Card")

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized Then
		svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	End If
	RenderExamples(Width, Height)
End Sub

Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews
	currentY = PAGE_PAD

	Dim maxW As Int = Max(180dip, Width - (PAGE_PAD * 2))
	Dim baseW As Int = Min(maxW, 390dip)
	Dim leftBase As Int = PAGE_PAD + (maxW - baseW) / 2

	AddSectionTitle("User baseline card")
	Dim cBase As B4XDaisyCard
	cBase.Initialize(Me, "card")
	Dim vBase As B4XView = cBase.AddToParent(pnlHost, leftBase, currentY, baseW, 430dip)
	ApplyCardDefaults(cBase, "baseline")
	cBase.ImagePath = "photo-1606107557195-0e29a4b5b4aa.webp"
	SetCardContent(cBase, "Card Title", "A card component has a figure, a body part, and inside body there are title and actions parts", "Buy Now")
	AddTitleBadges(cBase)
	cBase.Size = "md"
	cBase.Style = "none"
	cBase.LayoutMode = "top"
	cBase.Shadow = "sm"
	currentY = currentY + vBase.Height + SECTION_GAP

	AddSectionTitle("Border and dash styles")
	Dim cBorder As B4XDaisyCard
	cBorder.Initialize(Me, "card")
	Dim vBorder As B4XView = cBorder.AddToParent(pnlHost, leftBase, currentY, baseW, 0)
	ApplyCardDefaults(cBorder, "border")
	cBorder.ImagePath = "photo-1606107557195-0e29a4b5b4aa.webp"
	cBorder.Style = "border"
	SetCardContent(cBorder, "Card Title", "A card component has a figure, a body part, and inside body there are title and actions parts", "Buy Now")
	currentY = currentY + vBorder.Height + 10dip

	Dim cDash As B4XDaisyCard
	cDash.Initialize(Me, "card")
	Dim vDash As B4XView = cDash.AddToParent(pnlHost, leftBase, currentY, baseW, 0)
	ApplyCardDefaults(cDash, "dash")
	cDash.ImagePath = "photo-1606107557195-0e29a4b5b4aa.webp"
	cDash.Style = "dash"
	SetCardContent(cDash, "Card Title", "A card component has a figure, a body part, and inside body there are title and actions parts", "Buy Now")
	currentY = currentY + vDash.Height + SECTION_GAP

	AddSectionTitle("Card sizes")
	Dim sizeTokens() As String = Array As String("xs", "sm", "md", "lg", "xl")
	For Each token As String In sizeTokens
		Dim cSize As B4XDaisyCard
		cSize.Initialize(Me, "card")
		Dim vSize As B4XView = cSize.AddToParent(pnlHost, leftBase, currentY, baseW, 220dip)
		ApplyCardDefaults(cSize, "size-" & token)
		cSize.LayoutMode = "none"
		cSize.Style = "border"
		cSize.Size = token
		SetCardContent(cSize, token.ToUpperCase & " Card", "Card size token: " & token, "Buy Now")
		currentY = currentY + vSize.Height + 8dip
	Next
	currentY = currentY + SECTION_GAP

	AddSectionTitle("Card with image overlay")
	Dim cOverlay As B4XDaisyCard
	cOverlay.Initialize(Me, "card")
	Dim vOverlay As B4XView = cOverlay.AddToParent(pnlHost, leftBase, currentY, baseW, 360dip)
	ApplyCardDefaults(cOverlay, "overlay")
	cOverlay.LayoutMode = "overlay"
	cOverlay.ImagePath = "photo-1606107557195-0e29a4b5b4aa.webp"
	cOverlay.TextColorVariant = "neutral-content"
	SetCardContent(cOverlay, "Shoes!", "If a dog chews shoes whose shoes does he choose?", "Buy Now")
	SetBodyTextColor(cOverlay, xui.Color_White)
	currentY = currentY + vOverlay.Height + SECTION_GAP

	AddSectionTitle("Card with custom action row")
	Dim cActionTop As B4XDaisyCard
	cActionTop.Initialize(Me, "card")
	Dim vActionTop As B4XView = cActionTop.AddToParent(pnlHost, leftBase, currentY, baseW, 260dip)
	ApplyCardDefaults(cActionTop, "action-top")
	cActionTop.LayoutMode = "none"
	SetCardContent(cActionTop, "Action first", "Compose actions in CardActions for complete control.", "Primary")
	currentY = currentY + vActionTop.Height + SECTION_GAP

	AddSectionTitle("Card with place-items-center")
	Dim cPlaceItems As B4XDaisyCard
	cPlaceItems.Initialize(Me, "card")
	Dim vPlaceItems As B4XView = cPlaceItems.AddToParent(pnlHost, leftBase, currentY, baseW, 260dip)
	ApplyCardDefaults(cPlaceItems, "place-items-center")
	cPlaceItems.LayoutMode = "none"
	SetCardContent(cPlaceItems, "Action first", "Compose actions in CardActions for complete control.", "Primary")
	cPlaceItems.PlaceItemsCenter = True
	currentY = currentY + vPlaceItems.Height + SECTION_GAP

	AddSectionTitle("Card with custom color")
	Dim cNeutral As B4XDaisyCard
	cNeutral.Initialize(Me, "card")
	Dim vNeutral As B4XView = cNeutral.AddToParent(pnlHost, leftBase, currentY, baseW, 260dip)
	ApplyCardDefaults(cNeutral, "neutral")
	cNeutral.LayoutMode = "none"
	cNeutral.BackgroundColorVariant = "neutral"
	cNeutral.TextColorVariant = "neutral-content"
	SetCardContent(cNeutral, "Cookies!", "We are using cookies for no reason.", "Accept")
	SetBodyTextColor(cNeutral, xui.Color_White)
	currentY = currentY + vNeutral.Height + SECTION_GAP

	AddSectionTitle("Card with image on side")
	Dim cSide As B4XDaisyCard
	cSide.Initialize(Me, "card")
	Dim sideW As Int = Min(maxW, 520dip)
	Dim sideLeft As Int = PAGE_PAD + (maxW - sideW) / 2
	Dim vSide As B4XView = cSide.AddToParent(pnlHost, sideLeft, currentY, sideW, 240dip)
	ApplyCardDefaults(cSide, "side")
	cSide.LayoutMode = "side"
	cSide.ImagePath = "photo-1635805737707-575885ab0820.webp"
	SetCardContent(cSide, "New movie is released!", "Click the button to watch on Jetflix app.", "Watch")
	currentY = currentY + vSide.Height + SECTION_GAP

	AddSectionTitle("Side layout card")
	Dim cResponsive As B4XDaisyCard
	cResponsive.Initialize(Me, "card")
	Dim vResponsive As B4XView = cResponsive.AddToParent(pnlHost, sideLeft, currentY, sideW, 240dip)
	ApplyCardDefaults(cResponsive, "responsive")
	cResponsive.LayoutMode = "side"
	cResponsive.ImagePath = "photo-1494232410401-ad00d5433cfa.webp"
	SetCardContent(cResponsive, "New album is released!", "This card keeps side mode when layout mode is set to side.", "Listen")
	currentY = currentY + vResponsive.Height + SECTION_GAP

	AddSectionTitle("User baseline card (image bottom)")
	Dim cBaseBottom As B4XDaisyCard
	cBaseBottom.Initialize(Me, "card")
	Dim vBaseBottom As B4XView = cBaseBottom.AddToParent(pnlHost, leftBase, currentY, baseW, 430dip)
	ApplyCardDefaults(cBaseBottom, "baseline-bottom")
	cBaseBottom.ImagePath = "photo-1606107557195-0e29a4b5b4aa.webp"
	SetCardContent(cBaseBottom, "Card Title", "A card component has a figure, a body part, and inside body there are title and actions parts", "Buy Now")
	AddTitleBadges(cBaseBottom)
	cBaseBottom.Size = "md"
	cBaseBottom.Style = "none"
	cBaseBottom.LayoutMode = "bottom"
	cBaseBottom.Shadow = "sm"
	currentY = currentY + vBaseBottom.Height + SECTION_GAP

	AddSectionTitle("Action first card variants")
	Dim variantTokens() As String = Array As String("none", "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error")
	For Each token As String In variantTokens
		Dim cVariant As B4XDaisyCard
		cVariant.Initialize(Me, "card")
		Dim vVariant As B4XView = cVariant.AddToParent(pnlHost, leftBase, currentY, baseW, 240dip)
		ApplyCardDefaults(cVariant, "variant-" & token)
		cVariant.LayoutMode = "none"
		SetCardContent(cVariant, "Action first (" & token & ")", "Compose actions in CardActions for complete control.", "Primary")
		cVariant.Variant = token
		currentY = currentY + vVariant.Height + 8dip
	Next
	currentY = currentY + SECTION_GAP

	pnlHost.Height = Max(Height, currentY + PAGE_PAD)
End Sub

Private Sub ApplyCardDefaults(Card As B4XDaisyCard, TagName As String)
	Card.Tag = TagName
	Card.Title = "Card Title"
	Card.Size = "md"
	Card.Style = "none"
	Card.LayoutMode = "top"
	Card.Shadow = "sm"
	Card.BackgroundColorVariant = "base-100"
	Card.TextColorVariant = "base-content"
	ApplyBodyPaddingDebugBorder(Card)
End Sub

Private Sub ApplyBodyPaddingDebugBorder(Card As B4XDaisyCard)
	Return
End Sub

Private Sub FindBodyPaddingMarker(BodyPart As B4XView) As B4XView
	Dim empty As B4XView
	If BodyPart.IsInitialized = False Then Return empty
	For i = 0 To BodyPart.NumberOfViews - 1
		Dim v As B4XView = BodyPart.GetView(i)
		If "__card_body_padding_marker__" = v.Tag Then Return v
	Next
	Return empty
End Sub

Private Sub ResolveCardBodyPaddingDip(SizeToken As String) As Int
	Dim s As String = IIf(SizeToken = Null, "", SizeToken.ToLowerCase.Trim)
	Select Case s
		Case "xs": Return 8dip
		Case "sm": Return 16dip
		Case "lg": Return 32dip
		Case "xl": Return 40dip
		Case Else: Return 24dip
	End Select
End Sub

Private Sub SetCardContent(Card As B4XDaisyCard, Title As String, BodyText As String, ActionText As String)
	Card.Title = Title
	Dim titleExtras As B4XView = Card.CardTitle
	If titleExtras.IsInitialized Then titleExtras.RemoveAllViews

	Dim body As B4XView = Card.CardBody
	body.RemoveAllViews
	If BodyText <> Null And BodyText.Trim.Length > 0 Then
		Dim lbl As Label
		lbl.Initialize("")
		#If B4A
		lbl.SingleLine = False
		#End If
		Dim xl As B4XView = lbl
		xl.Text = BodyText
		xl.TextSize = 14
		xl.TextColor = xui.Color_RGB(51, 65, 85)
		xl.SetTextAlignment("TOP", "LEFT")
		Dim bodyW As Int = Max(1dip, body.Width)
		body.AddView(xl, 0, 0, bodyW, 1dip)
		Dim tu As StringUtils
		Dim bodyH As Int = Max(20dip, tu.MeasureMultilineTextHeight(lbl, BodyText))
		xl.SetLayoutAnimated(0, 0, 0, bodyW, bodyH)
	End If

	Dim actions As B4XView = Card.CardActions
	actions.RemoveAllViews
	If ActionText <> Null And ActionText.Trim.Length > 0 Then
		Dim actionBadge As B4XDaisyBadge
		actionBadge.Initialize(Me, "")
		Dim badgeView As B4XView = actionBadge.AddToParent(actions, 0, 0, 0, 0)
		actionBadge.Size = "sm"
		actionBadge.Variant = "primary"
		actionBadge.BadgeStyle = "outline"
		actionBadge.Text = ActionText
		If badgeView.Width > 0 And badgeView.Height > 0 Then
			badgeView.SetLayoutAnimated(0, 0, 0, badgeView.Width, badgeView.Height)
		End If
	End If

	If Card.mBase.IsInitialized Then Card.Base_Resize(Card.mBase.Width, Card.mBase.Height)
	ApplyBodyPaddingDebugBorder(Card)
End Sub

Private Sub SetBodyTextColor(Card As B4XDaisyCard, ColorValue As Int)
	Dim body As B4XView = Card.CardBody
	If body.IsInitialized = False Then Return
	For i = 0 To body.NumberOfViews - 1
		Dim v As B4XView = body.GetView(i)
		If v Is Label Then v.TextColor = ColorValue
	Next
End Sub

Private Sub AddTitleBadges(Card As B4XDaisyCard)
	Dim host As B4XView = Card.CardTitle
	If host.IsInitialized = False Then Return
	host.RemoveAllViews

	Dim bNew As B4XDaisyBadge
	bNew.Initialize(Me, "")
	bNew.Size = "sm"
	bNew.Variant = "success"
	bNew.BadgeStyle = "solid"
	bNew.Text = "NEW"
	bNew.AddToParent(host, 0, 0, 0, 0)

	Dim bPopular As B4XDaisyBadge
	bPopular.Initialize(Me, "")
	bPopular.Size = "sm"
	bPopular.Variant = "warning"
	bPopular.BadgeStyle = "outline"
	bPopular.Text = "POPULAR"
	bPopular.AddToParent(host, 0, 0, 0, 0)

	If Card.mBase.IsInitialized Then Card.Base_Resize(Card.mBase.Width, Card.mBase.Height)
End Sub

Private Sub AddSectionTitle(Text As String)
	Dim lbl As Label
	lbl.Initialize("")
	Dim xl As B4XView = lbl
	xl.Text = Text
	xl.TextColor = xui.Color_RGB(30, 41, 59)
	xl.Font = xui.CreateDefaultBoldFont(14)
	xl.SetTextAlignment("CENTER", "LEFT")
	pnlHost.AddView(xl, PAGE_PAD, currentY, Root.Width - (PAGE_PAD * 2), 20dip)
	currentY = currentY + 24dip
End Sub

Private Sub card_Click(Tag As Object)
	ToastMessageShow("Card click: " & Tag, False)
End Sub

Private Sub card_ActionClick(ActionId As String, Tag As Object)
	ToastMessageShow("Action click (" & ActionId & "): " & Tag, False)
End Sub
