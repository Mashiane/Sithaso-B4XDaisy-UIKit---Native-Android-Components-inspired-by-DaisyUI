B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private xui As XUI
	Private Root As B4XView
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private currentY As Int = 16dip
	Private sectionGap As Int = 18dip

	Private singleGroup As B4XDaisyBadgeGroupSelect
	Private multiGroup As B4XDaisyBadgeGroupSelect
	Private lblSingleState As B4XView
	Private lblMultiState As B4XView
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_White
	B4XPages.SetTitle(Me, "Badge Group Select")

	svHost.Initialize(0)
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_White
	pnlHost.Width = Root.Width

	RenderPage
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If svHost.IsInitialized = False Then Return
	svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	pnlHost.Width = Width
	RenderPage
End Sub

Private Sub RenderPage
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews
	currentY = 16dip

	AddTitle("BadgeGroupSelect - Single Select")
	AddSingleSelectExample

	currentY = currentY + sectionGap
	AddTitle("BadgeGroupSelect - Multi Select")
	AddMultiSelectExample

	pnlHost.Height = currentY + 24dip
End Sub

Private Sub AddSingleSelectExample
	singleGroup.Initialize(Me, "singlegroup")
	Dim w As Int = Max(180dip, Root.Width - 24dip)
	Dim left As Int = 12dip
	Dim v As B4XView = singleGroup.AddToParent(pnlHost, left, currentY, w, 1dip)

	singleGroup.setLegend("Priority")
	singleGroup.setBadgeSelectionMode("single")
	singleGroup.setBadgeColor("neutral")
	singleGroup.setBadgeStyle("solid")
	singleGroup.setBadgeCheckedColor(B4XDaisyVariants.ResolveBackgroundColorVariant("success", xui.Color_RGB(34, 197, 94)))
	singleGroup.setBadgeCheckedTextColor(B4XDaisyVariants.ResolveTextColorVariant("success", xui.Color_White))
	singleGroup.setItemsSpec("low:Low|normal:Normal|high:High|urgent:Urgent")

	Dim selected As List
	selected.Initialize
	selected.Add("normal")
	singleGroup.setSelectedIds(selected)

	lblSingleState = CreateStateLabel("Selected: normal")
	pnlHost.AddView(lblSingleState, left, currentY + v.Height + 8dip, w, 18dip)
	currentY = currentY + v.Height + 30dip
End Sub

Private Sub AddMultiSelectExample
	multiGroup.Initialize(Me, "multigroup")
	Dim w As Int = Max(180dip, Root.Width - 24dip)
	Dim left As Int = 12dip
	Dim v As B4XView = multiGroup.AddToParent(pnlHost, left, currentY, w, 1dip)

	multiGroup.setLegend("Skills")
	multiGroup.setBadgeSelectionMode("multi")
	multiGroup.setBadgeColor("neutral")
	multiGroup.setBadgeStyle("solid")
	multiGroup.setBadgeCheckedColor(B4XDaisyVariants.ResolveBackgroundColorVariant("success", xui.Color_RGB(34, 197, 94)))
	multiGroup.setBadgeCheckedTextColor(B4XDaisyVariants.ResolveTextColorVariant("success", xui.Color_White))
	multiGroup.setItemsSpec("ui:UI|api:API|db:Database|qa:QA|ops:Ops|ai:AI")

	Dim selected As List
	selected.Initialize
	selected.Add("ui")
	selected.Add("api")
	multiGroup.setSelectedIds(selected)

	lblMultiState = CreateStateLabel("Selected: ui, api")
	pnlHost.AddView(lblMultiState, left, currentY + v.Height + 8dip, w, 18dip)
	currentY = currentY + v.Height + 30dip
End Sub

Private Sub AddTitle(Text As String)
	Dim lbl As Label
	lbl.Initialize("")
	Dim xl As B4XView = lbl
	xl.Text = Text
	xl.Font = xui.CreateDefaultBoldFont(18)
	xl.TextColor = xui.Color_DarkGray
	pnlHost.AddView(xl, 12dip, currentY, Root.Width - 24dip, 26dip)
	currentY = currentY + 30dip
End Sub

Private Sub CreateStateLabel(Text As String) As B4XView
	Dim lbl As Label
	lbl.Initialize("")
	Dim v As B4XView = lbl
	v.Text = Text
	v.Font = xui.CreateDefaultFont(13)
	v.TextColor = xui.Color_RGB(71, 85, 105)
	Return v
End Sub

Private Sub singlegroup_SelectionChanged(SelectedIds As List)
	Dim txt As String = "Selected: " & JoinIds(SelectedIds)
	If lblSingleState.IsInitialized Then lblSingleState.Text = txt
End Sub

Private Sub multigroup_SelectionChanged(SelectedIds As List)
	Dim txt As String = "Selected: " & JoinIds(SelectedIds)
	If lblMultiState.IsInitialized Then lblMultiState.Text = txt
End Sub

Private Sub singlegroup_ItemChanged(Item As Map)
	Dim id As String = Item.GetDefault("id", "")
	Dim checked As Boolean = Item.GetDefault("checked", False)
	ToastMessageShow("single -> " & id & " = " & checked, False)
End Sub

Private Sub multigroup_ItemChanged(Item As Map)
	Dim id As String = Item.GetDefault("id", "")
	Dim checked As Boolean = Item.GetDefault("checked", False)
	ToastMessageShow("multi -> " & id & " = " & checked, False)
End Sub

Private Sub JoinIds(Ids As List) As String
	If Ids.IsInitialized = False Or Ids.Size = 0 Then Return "(none)"
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To Ids.Size - 1
		If i > 0 Then sb.Append(", ")
		sb.Append(Ids.Get(i))
	Next
	Return sb.ToString
End Sub
