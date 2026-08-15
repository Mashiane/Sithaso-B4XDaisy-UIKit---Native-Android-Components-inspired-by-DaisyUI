B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.70
@EndOfDesignText@

#IgnoreWarnings:12,9

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI

	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost   As B4XView
	Private navbar    As B4XDaisyNavbar
	Private card      As B4XDaisyCard
	Private badge     As B4XDaisyBadge
	Private bodyTxt   As B4XDaisyText
	Private btnCart   As B4XDaisyButton
	Private cardView  As B4XView

	Private pad       As Int
	Private gap       As Int
	Private maxW      As Int
	Private y         As Int
	Private NAVBAR_H  As Int
	Private bSkeletonBuilt As Boolean = False

	'Set by ProductList before navigating here.
	Public SelectedId As String
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	NAVBAR_H = 56dip

	BuildScroll
	BuildNavbar
	BuildCardSkeleton
	UpdateContent
End Sub

Private Sub B4XPage_Appear
	UpdateContent
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height - NAVBAR_H)
		If bSkeletonBuilt And card.IsInitialized Then
			pad = pageScroll.PagePadding
			gap = pageScroll.YGap
			maxW = pageScroll.UsableWidth
			card.SetLayoutAnimated(0, pad, pad, maxW, card.GetActualHeight)
			pageScroll.AutoFit
		End If
	End If
End Sub

Private Sub BuildScroll
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, NAVBAR_H, Root.Width, Root.Height - NAVBAR_H)
	pageScroll.SendToBack
	pnlHost = pageScroll.Panel
End Sub

Private Sub BuildNavbar
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
	navbar.BackVisible = True
	navbar.BackSize = 40dip
	navbar.BringToFront
	navbar.Title = "Product"
	navbar.Variant = "primary"
End Sub

Private Sub BuildCardSkeleton
	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	Dim p As Map = GetProduct(SelectedId)
	Dim title As String = p.GetDefault("title", "Product")
	Dim price As String = p.GetDefault("price", "")
	Dim image As String = p.GetDefault("image", "7.jpg")
	Dim desc As String  = p.GetDefault("description", "")

	' 1. Card: Initialize -> AddToParent -> Setters
	card.Initialize(Me, "card")
	cardView = card.AddToParent(pnlHost, pad, y, maxW, 0)
	card.Size = "md"
	card.Style = "border"
	card.LayoutMode = "top"
	card.Shadow = "sm"
	card.BackgroundColorVariant = "base-100"
	card.TextColorVariant = "base-content"
	card.Title = title
	card.ImagePath = image

	' Clear title extras so title isn't crowded
	Dim titleHost As B4XView = card.CardTitle
	If titleHost.IsInitialized Then titleHost.RemoveAllViews

	' 2. Body: Price badge & Description
	Dim body As B4XView = card.CardBody
	body.RemoveAllViews
	Dim bodyW As Int = Max(100dip, maxW - 32dip)

	' Badge: Initialize -> AddToParent (explicit size) -> Setters
	badge.Initialize(Me, "")
	badge.AddToParent(body, 0, 0, 80dip, 28dip)
	badge.Size = "md"
	badge.Variant = "success"
	badge.BadgeStyle = "solid"
	badge.Text = price

	' Description text: Initialize -> AddToParent (explicit size) -> Setters
	bodyTxt.Initialize(Me, "")
	bodyTxt.AddToParent(body, 0, 32dip, bodyW, 40dip)
	bodyTxt.setTextSize(14)
	bodyTxt.setTextColor(xui.Color_RGB(51, 65, 85))
	bodyTxt.SetTextAlignment("TOP", "LEFT")
	bodyTxt.setAutoResize(True)
	bodyTxt.setText(desc)

	' 3. Actions: Add to Cart button (Initialize -> AddToParent with explicit 140dip x 44dip -> Setters)
	Dim actions As B4XView = card.CardActions
	actions.RemoveAllViews
	btnCart.Initialize(Me, "addcart")
	btnCart.AddToParent(actions, 0, 0, 140dip, 44dip)
	btnCart.Size = "md"
	btnCart.Variant = "primary"
	btnCart.Style = "solid"
	btnCart.Text = "Add to Cart"
	btnCart.Tag = title

	bSkeletonBuilt = True
	If card.GetContainer.IsInitialized Then card.Base_Resize(card.GetActualWidth, card.GetActualHeight)
End Sub

Private Sub UpdateContent
	If bSkeletonBuilt = False Then Return

	Dim p As Map = GetProduct(SelectedId)
	Dim title As String = p.GetDefault("title", "Product")
	Dim price As String = p.GetDefault("price", "")
	Dim image As String = p.GetDefault("image", "7.jpg")
	Dim desc As String  = p.GetDefault("description", "")

	navbar.Title = title
	card.Title = title
	card.ImagePath = image
	badge.Text = price
	bodyTxt.setText(desc)
	btnCart.Tag = title

	If card.GetContainer.IsInitialized Then card.Base_Resize(card.GetActualWidth, card.GetActualHeight)
	pageScroll.AutoFit
End Sub

'Returns the product record for the selected id. Falls back to p1.
Private Sub GetProduct(Id As String) As Map
	Select Case Id
		Case "p1"
			Return CreateMap("title": "Wireless Headphones", "price": "$89.00", "image": "7.jpg", "description": "Over-ear Bluetooth headphones with 30h battery and active noise cancelling.")
		Case "p2"
			Return CreateMap("title": "Cotton T-Shirt", "price": "$19.50", "image": "9.jpg", "description": "Soft pre-shrunk cotton tee in a regular fit. Machine washable.")
		Case "p3"
			Return CreateMap("title": "Coffee Maker", "price": "$45.00", "image": "12.jpg", "description": "12-cup drip coffee maker with programmable timer and reusable filter.")
		Case "p4"
			Return CreateMap("title": "Running Shoes", "price": "$72.00", "image": "13.jpg", "description": "Lightweight road running shoes with cushioned midsole and breathable upper.")
		Case "p5"
			Return CreateMap("title": "Backpack", "price": "$38.00", "image": "14.jpg", "description": "20L daypack with padded laptop sleeve and water-resistant fabric.")
		Case "p6"
			Return CreateMap("title": "Smart Watch", "price": "$129.00", "image": "7.jpg", "description": "Fitness tracking smartwatch with heart-rate sensor and 7-day battery life.")
		Case Else
			Return CreateMap("title": "Wireless Headphones", "price": "$89.00", "image": "7.jpg", "description": "Over-ear Bluetooth headphones with 30h battery and active noise cancelling.")
	End Select
End Sub

'Back arrow -> pop this page back to the product list.
Private Sub navbar_Back(Tag As Object)
	B4XPages.MainPage.ClosePageWithLoader(Me)
End Sub

'Add to Cart -> confirm via the global SweetAlert on MainPage, then toast.
Private Sub addcart_Click(Tag As Object)
	Dim productName As String = Tag
	Dim sf As Object = B4XPages.MainPage.ShowSwalConfirm("Add to Cart", "Add " & productName & " to your cart?", "Add", "Cancel")
	Wait For (sf) Complete (Result As B4XDaisySweetAlertResult)
	If Result.IsConfirmed Then
		B4XPages.MainPage.ShowToastSuccess(productName & " added to cart", False)
	End If
End Sub