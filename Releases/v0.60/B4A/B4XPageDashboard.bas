B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private Dashboard As B4XDaisyDashboard
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

'no action bar
Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(240, 244, 249)
	B4XPages.SetTitle(Me, "Dashboard")

	Dashboard.Initialize(Me, "dash")
	Dashboard.AddToParent(Root)
	Dashboard.setAutoGrid(False)
	Dashboard.setMinCellHeight(96)
	Dashboard.setBackgroundImage("janis-kloter-GipF6xThS6g-unsplash.jpg")
	Dashboard.setPagePadding(12)
	Dashboard.setCellSpacing(6)
	Dashboard.SetButtons(CreateLauncherButtons)
'	B4XPages.MainPage.SetStatusBarState(False)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	Dashboard.Resize(Width, Height)
End Sub

Private Sub CreateLauncherButtons As List
	Dim apps As List
	apps.Initialize

	apps.Add(CreateMap("id":"accordion", "label":"Accordion", "imagePath":"accordion.webp", "svgPath":""))
	apps.Add(CreateMap("id":"alert", "label":"Alert", "imagePath":"alert.webp", "svgPath":""))
	apps.Add(CreateMap("id":"avatar", "label":"Avatar", "imagePath":"avatar.webp", "svgPath":""))
	apps.Add(CreateMap("id":"badge", "label":"Badge", "imagePath":"badge.webp", "svgPath":""))
	apps.Add(CreateMap("id":"breadcrumbs", "label":"Breadcrumbs", "imagePath":"breadcrumbs.webp", "svgPath":""))
	apps.Add(CreateMap("id":"button", "label":"Button", "imagePath":"button.webp", "svgPath":""))
	apps.Add(CreateMap("id":"cspinner", "label":"Canvas Spinner", "imagePath":"canvasspinner.jpeg", "svgPath":""))
	apps.Add(CreateMap("id":"card", "label":"Card", "imagePath":"card.webp", "svgPath":""))
	apps.Add(CreateMap("id":"carousel", "label":"Carousel", "imagePath":"carousel.webp", "svgPath":""))
	apps.Add(CreateMap("id":"chat", "label":"Chat", "imagePath":"chat.webp", "svgPath":""))
	apps.Add(CreateMap("id":"collapse", "label":"Collapse", "imagePath":"collapse.webp", "svgPath":""))
	apps.Add(CreateMap("id":"countdown", "label":"Countdown", "imagePath":"countdown.webp", "svgPath":""))
	apps.Add(CreateMap("id":"diff", "label":"Diff", "imagePath":"diff.webp", "svgPath":""))
	apps.Add(CreateMap("id":"divider", "label":"Divider", "imagePath":"divider.webp", "svgPath":""))
	apps.Add(CreateMap("id":"dock", "label":"Dock", "imagePath":"dock.webp", "svgPath":""))
	apps.Add(CreateMap("id":"dropdown", "label":"Dropdown", "imagePath":"dropdown.webp", "svgPath":""))
	apps.Add(CreateMap("id":"fab", "label":"Fab", "imagePath":"fab.webp", "svgPath":""))
	apps.Add(CreateMap("id":"fab_basic", "label":"Fab Basic", "imagePath":"fab.webp", "svgPath":""))
	apps.Add(CreateMap("id":"fab_flower", "label":"Fab Flower", "imagePath":"fab.webp", "svgPath":""))
	apps.Add(CreateMap("id":"fab_navbar", "label":"Fab Navbar", "imagePath":"navbar.webp", "svgPath":""))
	apps.Add(CreateMap("id":"fieldset", "label":"Fieldset", "imagePath":"fieldset.webp", "svgPath":""))
	apps.Add(CreateMap("id":"hero", "label":"Hero", "imagePath":"hero.webp", "svgPath":""))
	apps.Add(CreateMap("id":"hover3d", "label":"Hover3d", "imagePath":"hover-3d.webp", "svgPath":""))
	apps.Add(CreateMap("id":"indicator", "label":"Indicator", "imagePath":"indicator.webp", "svgPath":""))
	apps.Add(CreateMap("id":"kbd", "label":"Kbd", "imagePath":"kbd.webp", "svgPath":""))
	apps.Add(CreateMap("id":"link", "label":"Link", "imagePath":"link.webp", "svgPath":""))
	apps.Add(CreateMap("id":"list", "label":"List", "imagePath":"list.webp", "svgPath":""))
	apps.Add(CreateMap("id":"loading", "label":"Loading", "imagePath":"loading.webp", "svgPath":""))
	apps.Add(CreateMap("id":"mask", "label":"Mask", "imagePath":"mask.webp", "svgPath":""))
	apps.Add(CreateMap("id":"menu", "label":"Menu", "imagePath":"menu.webp", "svgPath":""))
	apps.Add(CreateMap("id":"menu_runtime2", "label":"Menu Level", "imagePath":"menu.webp", "svgPath":""))
	apps.Add(CreateMap("id":"menu_runtime", "label":"Menu Runtime", "imagePath":"menu.webp", "svgPath":""))
	apps.Add(CreateMap("id":"modal", "label":"Modal", "imagePath":"modal.webp", "svgPath":""))
	apps.Add(CreateMap("id":"navbar", "label":"Navbar", "imagePath":"navbar.webp", "svgPath":""))
	apps.Add(CreateMap("id":"overlay", "label":"Overlay", "imagePath":"", "svgPath":"eye-solid.svg"))
	apps.Add(CreateMap("id":"pagination", "label":"Pagination", "imagePath":"pagination.webp", "svgPath":""))
	apps.Add(CreateMap("id":"progress", "label":"Progress", "imagePath":"progress.webp", "svgPath":""))
	apps.Add(CreateMap("id":"radialprogress", "label":"Radial Progress", "imagePath":"radial-progress.webp", "svgPath":""))
	apps.Add(CreateMap("id":"skeleton", "label":"Skeleton", "imagePath":"skeleton.webp", "svgPath":""))
	apps.Add(CreateMap("id":"stack", "label":"Stack", "imagePath":"stack.webp", "svgPath":""))
	apps.Add(CreateMap("id":"stat", "label":"Stat", "imagePath":"stat.webp", "svgPath":""))
	apps.Add(CreateMap("id":"status", "label":"Status", "imagePath":"status.webp", "svgPath":""))
	apps.Add(CreateMap("id":"steps", "label":"Steps", "imagePath":"steps.webp", "svgPath":""))
	apps.Add(CreateMap("id":"svg_icon", "label":"SVG", "imagePath":"", "svgPath":"bell-solid.svg"))
	apps.Add(CreateMap("id":"swap", "label":"Swap", "imagePath":"swap.webp", "svgPath":""))
	apps.Add(CreateMap("id":"tab", "label":"Tab", "imagePath":"tab.webp", "svgPath":""))
	apps.Add(CreateMap("id":"textrotate", "label":"Text Rotate", "imagePath":"text-rotate.webp", "svgPath":""))
	apps.Add(CreateMap("id":"timeline", "label":"Timeline", "imagePath":"timeline.webp", "svgPath":""))
	apps.Add(CreateMap("id":"toast", "label":"Toast", "imagePath":"alert.webp", "svgPath":""))
	apps.Add(CreateMap("id":"tooltip", "label":"Tooltip", "imagePath":"tooltip.webp", "svgPath":""))
	apps.Add(CreateMap("id":"window", "label":"Window", "imagePath":"mockup-window.webp", "svgPath":""))
	NormalizeDashboardButtonImages(apps)
	Return apps
End Sub

Private Sub NormalizeDashboardButtonImages(Apps As List)
	If Apps.IsInitialized = False Then Return
	For i = 0 To Apps.Size - 1
		Dim raw As Object = Apps.Get(i)
		If raw Is Map Then
			Dim item As Map = raw
			Dim svgPath As String = item.GetDefault("svgPath", "")
			If svgPath.Trim.Length > 0 Then
				item.Put("imagePath", "")
				Continue
			End If
			Dim originalPath As String = item.GetDefault("imagePath", "")
			Dim resolvedPath As String = ResolveDashboardImagePath(originalPath, i)
			If resolvedPath <> originalPath Then
				item.Put("imagePath", resolvedPath)
			End If
		End If
	Next
End Sub

Private Sub ResolveDashboardImagePath(ImagePath As String, Seed As Int) As String
	Dim requested As String = ImagePath.Trim
	If requested.Length > 0 And File.Exists(File.DirAssets, requested) Then Return requested

	Dim fallbackImages() As String = Array As String( _
		"face21.jpg", "face22.jpg", "face23.jpg", "face24.jpg", "face25.jpg", "face26.jpg", "face27.jpg", "angela.jpg", "anna.jpg" _
	)
	If fallbackImages.Length = 0 Then Return requested

	Dim startIndex As Int = Abs(Seed) Mod fallbackImages.Length
	For offset = 0 To fallbackImages.Length - 1
		Dim candidate As String = fallbackImages((startIndex + offset) Mod fallbackImages.Length)
		If File.Exists(File.DirAssets, candidate) Then Return candidate
	Next

	Return requested
End Sub



Private Sub PickRandomDemoImages(Count As Int) As List
	Dim pool As List
	pool.Initialize
	Dim candidates() As String = Array As String( _
		"face21.jpg", "face22.jpg", "face23.jpg", "face24.jpg", "face25.jpg", _
		"face26.jpg", "face27.jpg", "face20.jpg", "face19.jpg", "angela.jpg", "anna.jpg" _
	)
	For Each fileName As String In candidates
		If File.Exists(File.DirAssets, fileName) Then pool.Add(fileName)
	Next

	Dim result As List
	result.Initialize
	If pool.Size = 0 Then
		For i = 0 To Count - 1
			result.Add("face21.jpg")
		Next
		Return result
	End If

	For i = 0 To Count - 1
		If pool.Size = 0 Then Exit
		Dim idx As Int = Rnd(0, pool.Size)
		result.Add(pool.Get(idx))
		pool.RemoveAt(idx)
	Next

	Do While result.Size < Count
		result.Add(result.Get(result.Size Mod Max(1, result.Size)))
	Loop
	Return result
End Sub

Private Sub dash_ButtonClick(ButtonId As String, ButtonDef As Map)
	Select Case ButtonId
		Case "accordion"
			NavigateFromMainPage("Accordion")
			Return
		Case "alert"
			NavigateFromMainPage("Alert")
			Return
		Case "avatar"
			NavigateFromMainPage("Avatar")
			Return
		Case "badge"
			NavigateFromMainPage("Badge")
			Return
		Case "breadcrumbs"
			NavigateFromMainPage("Breadcrumbs")
			Return
		Case "button"
			NavigateFromMainPage("Button")
			Return
		Case "card"
			NavigateFromMainPage("Card")
			Return
		Case "carousel"
			NavigateFromMainPage("Carousel")
			Return
		Case "chat"
			NavigateFromMainPage("Chat")
			Return
		Case "collapse"
			NavigateFromMainPage("Collapse")
			Return
		Case "countdown"
			NavigateFromMainPage("Countdown")
			Return
		Case "cspinner"
			NavigateFromMainPage("CanvasSpinner")
			Return
		Case "diff"
			NavigateFromMainPage("Diff")
			Return
		Case "divider"
			NavigateFromMainPage("Divider")
			Return
		Case "dock"
			NavigateFromMainPage("Dock")
			Return
		Case "dropdown"
			NavigateFromMainPage("Dropdown")
			Return
		Case "fab"
			NavigateFromMainPage("Fab")
			Return
		Case "fab_basic"
			NavigateFromMainPage("Fab Basic")
			Return
		Case "fab_flower"
			NavigateFromMainPage("Fab Flower")
			Return
		Case "fab_navbar"
			NavigateFromMainPage("Fab Navbar")
			Return
		Case "fieldset"
			NavigateFromMainPage("FieldSet")
			Return
		Case "hero"
			NavigateFromMainPage("Hero")
			Return
		Case "hover3d"
			NavigateFromMainPage("Hover3d")
			Return
		Case "indicator"
			NavigateFromMainPage("Indicator")
			Return
		Case "kbd"
			NavigateFromMainPage("Kbd")
			Return
		Case "link"
			NavigateFromMainPage("Link")
			Return
		Case "list"
			NavigateFromMainPage("List")
			Return
		Case "loading"
			NavigateFromMainPage("Loading")
			Return
		Case "mask"
			NavigateFromMainPage("Mask")
			Return
		Case "menu"
			NavigateFromMainPage("Menu")
			Return
		Case "menu_runtime"
			NavigateFromMainPage("Menu Runtime")
			Return
		Case "menu_runtime2"
			NavigateFromMainPage("Menu Runtime 2")
			Return
		Case "modal"
			NavigateFromMainPage("Modal")
			Return
		Case "navbar"
			NavigateFromMainPage("Navbar")
			Return
		Case "overlay"
			NavigateFromMainPage("Overlay")
			Return
		Case "pagination"
			NavigateFromMainPage("Pagination")
			Return
		Case "progress"
			NavigateFromMainPage("Progress")
			Return
		Case "radialprogress"
			NavigateFromMainPage("Radial Progress")
			Return
		Case "skeleton"
			NavigateFromMainPage("Skeleton")
			Return
		Case "stack"
			NavigateFromMainPage("Stack")
			Return
		Case "stat"
			NavigateFromMainPage("Stat")
			Return
		Case "status"
			NavigateFromMainPage("Status")
			Return
		Case "steps"
			NavigateFromMainPage("Steps")
			Return
		Case "svg_icon"
			NavigateFromMainPage("SVG Icon")
			Return
		Case "swap"
			NavigateFromMainPage("Swap")
			Return
		Case "tab"
			NavigateFromMainPage("Tab")
			Return
		Case "textrotate"
			NavigateFromMainPage("TextRotate")
			Return
		Case "timeline"
			NavigateFromMainPage("Timeline")
			Return
		Case "toast"
			NavigateFromMainPage("Toast")
			Return
		Case "tooltip"
			NavigateFromMainPage("Tooltip")
			Return
		Case "window"
			NavigateFromMainPage("Window")
			Return
	End Select
	'#If B4A
	'ToastMessageShow("App: " & ButtonDef.GetDefault("label", ButtonId), False)
	'#End If
End Sub

Private Sub NavigateFromMainPage(PageId As String)
	Dim target As String = PageId.Trim
	If target.Length = 0 Then Return
	Try
		B4XPages.MainPage.ShowPageWithLoader(target)
	Catch
		Log("ERROR: NavigateFromMainPage crashed: " & LastException.Message)
		ToastMessageShow("Navigation error: " & LastException.Message, True)
	End Try
End Sub

Private Sub dash_PageChanged(PageIndex As Int, PageCount As Int)
End Sub