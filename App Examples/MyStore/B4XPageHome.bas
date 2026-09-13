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
	Private dock      As B4XDaisyDock
	Private pad       As Int
	Private gap       As Int
	Private maxW      As Int
	Private y         As Int
	Private NAVBAR_H  As Int
	Private DOCK_H    As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews
	NAVBAR_H = 56dip
	DOCK_H   = 64dip

	BuildScroll
	BuildNavbar
	BuildDock
	RenderContent
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	'Reset the dock indicator to this page's own item.
	If dock.IsInitialized Then dock.ActiveIndex = 0
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_H)
	If dock.IsInitialized Then dock.View.SetLayoutAnimated(0, 0, Height - DOCK_H, Width, DOCK_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height - NAVBAR_H - DOCK_H)
		RenderContent
	End If
End Sub

Private Sub BuildScroll
	Dim scrollTop As Int = NAVBAR_H
	Dim scrollH   As Int = Root.Height - NAVBAR_H - DOCK_H
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, scrollTop, Root.Width, scrollH)
	pageScroll.SendToBack
	pnlHost = pageScroll.Panel
End Sub

Private Sub BuildNavbar
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
	navbar.BringToFront
	navbar.Title = "My Store"
	navbar.Variant = "primary"
End Sub

Private Sub BuildDock
	dock.Initialize(Me, "dock")
	dock.Size = "md"
	dock.ActivePosition = "top"
	dock.ActiveIndex = 0
	dock.AddToParent(Root, 0, Root.Height - DOCK_H, Root.Width, DOCK_H)
	dock.AddItem("home",     "Home",     "dock-home.svg")
	dock.AddItem("products",  "Products", "dock-inbox.svg")
End Sub

Private Sub RenderContent
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	y = pageScroll.AddSectionTitle("Shop by Category", y, False) + gap

	'Three category cards. Each is clickable (card_Click) and has a Browse action.
	y = AddCategoryCard("electronics", "Electronics", "Phones, tablets and gadgets.", "7.jpg", y) + gap
	y = AddCategoryCard("clothing",    "Clothing",    "Seasonal apparel and accessories.", "9.jpg", y) + gap
	y = AddCategoryCard("home",        "Home Goods",  "Kitchen, decor and essentials.", "12.jpg", y) + gap

	pageScroll.AutoFit
End Sub

'Builds one category card with image (top), title, body and a Browse action button.
'Returns the y position after the card.
Private Sub AddCategoryCard(Tag As String, Title As String, BodyText As String, Image As String, TopY As Int) As Int
	Dim card As B4XDaisyCard
	card.Initialize(Me, "card")
	Dim v As B4XView = card.AddToParent(pnlHost, pad, TopY, maxW, 0)
	card.Tag = Tag
	card.Title = Title
	card.Size = "md"
	card.Style = "border"
	card.LayoutMode = "top"
	card.Shadow = "sm"
	card.BackgroundColorVariant = "base-100"
	card.TextColorVariant = "base-content"
	card.ImagePath = Image

	'Body text
	Dim body As B4XView = card.CardBody
	body.RemoveAllViews
	Dim bodyTxt As B4XDaisyText
	bodyTxt.Initialize(Me, "")
	Dim bodyW As Int = Max(1dip, body.Width)
	bodyTxt.setText(BodyText)
	bodyTxt.setTextSize(14)
	bodyTxt.setTextColor(xui.Color_RGB(51, 65, 85))
	bodyTxt.SetTextAlignment("TOP", "LEFT")
	bodyTxt.setAutoResize(True)
	bodyTxt.AddToParent(body, 0, 0, bodyW, 20dip)

	'Browse action button
	Dim actions As B4XView = card.CardActions
	actions.RemoveAllViews
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "browse")
	btn.Tag = Tag
	btn.Size = "sm"
	btn.Variant = "primary"
	btn.Style = "outline"
	btn.Text = "Browse"
	btn.AddToParent(actions, 0, 0, 0, 0)

	If card.GetContainer.IsInitialized Then card.Base_Resize(card.GetActualWidth, card.GetActualHeight)
	Return TopY + v.Height
End Sub

Private Sub dock_ItemClick(ItemId As String)
	Select Case ItemId
		Case "products"
			B4XPages.MainPage.ShowPageWithLoader("products")
	End Select
End Sub

'Whole card tap -> product list.
Private Sub card_Click(Tag As Object)
	B4XPages.MainPage.ShowPageWithLoader("products")
End Sub

'Browse action button tap -> product list.
Private Sub browse_Click(Tag As Object)
	B4XPages.MainPage.ShowPageWithLoader("products")
End Sub