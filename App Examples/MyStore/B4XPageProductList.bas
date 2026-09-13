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
	Private list      As B4XDaisyList
	Private pad       As Int
	Private gap       As Int
	Private maxW      As Int
	Private y         As Int
	Private NAVBAR_H  As Int
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
	RenderContent
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height - NAVBAR_H)
		RenderContent
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
	navbar.Title = "Products"
	navbar.Variant = "primary"
End Sub

Private Sub RenderContent
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	list.Clear
	list.Initialize(Me, "list")
	list.Rounded = "rounded-box"
	list.Shadow = "shadow-md"
	list.BackgroundColor = "base-100"
	list.Padding = 0
	list.RowPadding = 16dip
	list.Divider = True
	list.DividerColor = "base-content/5"
	list.RowHeight = 72dip
	list.AutoHeight = True
	list.AddToParent(pnlHost, pad, y, maxW, 360dip)
	list.AddHeader("Featured products")
	AddProduct("p1", "Wireless Headphones", "$89.00",  "7.jpg")
	AddProduct("p2", "Cotton T-Shirt",      "$19.50",  "9.jpg")
	AddProduct("p3", "Coffee Maker",         "$45.00",  "12.jpg")
	AddProduct("p4", "Running Shoes",        "$72.00",  "13.jpg")
	AddProduct("p5", "Backpack",             "$38.00",  "14.jpg")
	AddProduct("p6", "Smart Watch",         "$129.00",  "7.jpg")

	pageScroll.AutoFit
End Sub

Private Sub AddProduct(Id As String, Title As String, Price As String, Image As String)
	list.AddRowData(CreateMap("Tag": Id, "_height": 72, "title": Title, "subtitle": Price, "avatar": Image, "rowType": "product"))
End Sub

'List asks the page to build each row's content.
Private Sub list_CreateRowContent(Index As Int)
	Dim Panel As B4XView = list.GetCurrentRowPanel
	Dim Data As Map = list.GetCurrentRowData
	If Panel = Null Or Panel.IsInitialized = False Or Data = Null Or Data.IsInitialized = False Then Return
	Dim isHeader As Boolean = Data.GetDefault("_header", False)
	If isHeader Then
		CreateHeaderRow(Panel, Data)
		Return
	End If
	CreateProductRow(Panel, Data)
End Sub

Private Sub CreateHeaderRow(Panel As B4XView, Data As Map)
	Dim w As Int = Panel.Width
	Dim h As Int = Panel.Height
	Dim title As String = Data.GetDefault("title", "")
	Dim txt As B4XDaisyText
	txt.Initialize(Me, "")
	txt.AddToParent(Panel, 16dip, 0, Max(1dip, w - 32dip), h)
	txt.Text = title
	txt.TextSize = 11
	txt.TextColor = xui.Color_ARGB(160, 0, 0, 0)
	txt.UpperCase = True
	txt.VAlign = "CENTER"
	txt.HAlign = "LEFT"
	txt.SingleLine = True
End Sub

Private Sub CreateProductRow(Panel As B4XView, Data As Map)
	Dim w As Int = Panel.Width
	Dim h As Int = Panel.Height
	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "")
	av.AddToParent(Panel, 8dip, (h - 48dip) / 2, 48dip, 48dip)
	av.RoundedBox = True
	av.AvatarSize = "size-10"
	av.Image = Data.GetDefault("avatar", "7.jpg")

	Dim textLeft As Int = 64dip
	Dim textW As Int = Max(1dip, w - textLeft - 16dip)
	Dim txtTitle As B4XDaisyText
	txtTitle.Initialize(Me, "")
	txtTitle.AddToParent(Panel, textLeft, 10dip, textW, 24dip)
	txtTitle.Text = Data.GetDefault("title", "")
	txtTitle.TextSize = 15
	txtTitle.TextColor = xui.Color_RGB(17, 24, 39)
	txtTitle.FontBold = True
	txtTitle.SingleLine = True

	Dim txtSub As B4XDaisyText
	txtSub.Initialize(Me, "")
	txtSub.AddToParent(Panel, textLeft, 34dip, textW, 20dip)
	txtSub.Text = Data.GetDefault("subtitle", "")
	txtSub.TextSize = 12
	txtSub.TextColor = xui.Color_ARGB(160, 0, 0, 0)
	txtSub.FontBold = True
	txtSub.SingleLine = True

	av.setClickable(False)
	txtTitle.setClickable(False)
	txtSub.setClickable(False)
End Sub

'Back arrow -> pop this page back to Home.
Private Sub navbar_Back(Tag As Object)
	B4XPages.MainPage.ClosePageWithLoader(Me)
End Sub

'Row tap -> open the detail page for this product.
Private Sub list_ItemClick(Index As Int, Tag As Object)
	B4XPages.MainPage.ProductDetailPage.SelectedId = Tag
	B4XPages.MainPage.ShowPageWithLoader("productdetail")
End Sub