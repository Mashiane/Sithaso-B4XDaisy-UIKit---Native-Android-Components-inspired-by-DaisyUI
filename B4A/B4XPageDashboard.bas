B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private Dashboard As B4XDashboard
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

'no action bar
Private Sub B4XPage_Appear
'    Dim jo As JavaObject = B4XPages.GetManager.ActionBar
'    jo.RunMethod("show", Null)
'    Root.Parent.Height = 100%y
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

	apps.Add(CreateMap("id":"chat", "label":"Chat", "imagePath":"chat.webp", "svgPath":""))
	apps.Add(CreateMap("id":"alert", "label":"Alert", "imagePath":"alert.webp", "svgPath":""))
	apps.Add(CreateMap("id":"avatar", "label":"Avatar", "imagePath":"avatar.webp", "svgPath":""))
	apps.Add(CreateMap("id":"avatar_group", "label":"Avatar Group", "imagePath":"avatar.webp", "svgPath":""))
	apps.Add(CreateMap("id":"badge", "label":"Badge", "imagePath":"badge.webp", "svgPath":""))
	apps.Add(CreateMap("id":"indicator", "label":"Indicator", "imagePath":"indicator.webp", "svgPath":""))
	apps.Add(CreateMap("id":"status", "label":"Status", "imagePath":"status.webp", "svgPath":""))
	apps.Add(CreateMap("id":"stack", "label":"Stack", "imagePath":"stack.webp", "svgPath":""))
	apps.Add(CreateMap("id":"stack_photos", "label":"Stack Photos", "imagePath":"stack.webp", "svgPath":""))
	apps.Add(CreateMap("id":"mask", "label":"Mask", "imagePath":"mask.webp", "svgPath":""))
	apps.Add(CreateMap("id":"svg_icon", "label":"SVG Icon", "imagePath":"face25.jpg", "svgPath":""))
	apps.Add(CreateMap("id":"swap", "label":"Swap", "imagePath":"swap.webp", "svgPath":""))
	apps.Add(CreateMap("id":"loading", "label":"Loading", "imagePath":"loading.webp", "svgPath":""))
	apps.Add(CreateMap("id":"skeleton", "label":"Skeleton", "imagePath":"skeleton.webp", "svgPath":""))
	apps.Add(CreateMap("id":"radialprogress", "label":"Radial Progress", "imagePath":"radial-progress.webp", "svgPath":""))
	apps.Add(CreateMap("id":"progress", "label":"Progress", "imagePath":"progress.webp", "svgPath":""))
	apps.Add(CreateMap("id":"toast", "label":"Toast", "imagePath":"alert.webp", "svgPath":""))
	apps.Add(CreateMap("id":"tooltip", "label":"Tooltip", "imagePath":"tooltip.webp", "svgPath":""))
	apps.Add(CreateMap("id":"navbar", "label":"Navbar", "imagePath":"navbar.webp", "svgPath":""))

	'apps.Add(CreateMap("id":"calendar", "label":"Calendar", "imagePath":"face25.jpg", "svgPath":""))
	'apps.Add(CreateMap("id":"notes", "label":"Notes", "imagePath":"face26.jpg", "svgPath":""))
	'apps.Add(CreateMap("id":"browser", "label":"Browser", "imagePath":"face27.jpg", "svgPath":""))
	'apps.Add(CreateMap("id":"files", "label":"Files", "imagePath":"default.png", "svgPath":""))

	'apps.Add(CreateMap("id":"mail", "label":"Cloud Storage & Drive", "imagePath":"daisywoman1.jpg", "svgPath":""))
	'apps.Add(CreateMap("id":"contacts", "label":"Contacts", "imagePath":"daisywoman2.png", "svgPath":""))
	'apps.Add(CreateMap("id":"music", "label":"Music", "imagePath":"daisywoman3.png", "svgPath":""))
	'apps.Add(CreateMap("id":"store", "label":"Store", "imagePath":"daisywoman4.png", "svgPath":""))

	'apps.Add(CreateMap("id":"maps", "label":"Maps", "imagePath":"angela.jpg", "svgPath":""))
	'apps.Add(CreateMap("id":"weather", "label":"Malware-bytes", "imagePath":"anna.jpg", "svgPath":"", "badgeCount": 1))
	'apps.Add(CreateMap("id":"calculator", "label":"TikTok Lite", "imagePath":"from.png", "svgPath":""))
	'apps.Add(CreateMap("id":"settings", "label":"ESET Mobile Security", "imagePath":"to.png", "svgPath":""))

	Dim extraLabels() As String = Array As String( _
		"Phone", "Files 2", "Gallery 2", "Clock 2", _
		"Wallet", "Translate", "Notes 2", "Browser 2", _
		"Reader", "Tasks", "Recorder", "Voice", _
		"Drive", "Photos", "Maps 2", "Weather 2", _
		"Scanner", "Compass", "Calendar 2", "Store 2", _
		"Music 2", "Mail 2", "Contacts 2", "Settings 2", _
		"Health", "Finance", "News", "Video", _
		"Podcasts", "Travel", "Tickets", "Food", _
		"Ride", "Games", "Books", "Camera 2", _
		"Messages 2", "Tools", "Studio", "Cloud" _
	)
	Dim extraImages() As String = Array As String( _
		"face1.jpg", "face3.jpg", "face4.jpg", "face5.jpg", "face6.jpg", "face7.jpg", "face8.jpg", "face9.jpg", _
		"face10.jpg", "face11.jpg", "face12.jpg", "face13.jpg", "face14.jpg", "face15.jpg", "face16.jpg", "face17.jpg", _
		"face18.jpg", "face19.jpg", "face20.jpg", "face22.jpg", "face23.jpg", "face24.jpg", "face25.jpg", "face26.jpg", _
		"face27.jpg", "daisywoman1.jpg", "daisywoman2.png", "daisywoman3.png", "daisywoman4.png", "daisyman1.png", "default.png", "angela.jpg" _
	)
	For i = 0 To extraLabels.Length - 1
		Dim appLabel As String = extraLabels(i)
		Dim appId As String = appLabel.ToLowerCase.Replace(" ", "_")
		Dim appImage As String = extraImages(i Mod extraImages.Length)
		'apps.Add(CreateMap("id": appId, "label": appLabel, "imagePath": appImage, "svgPath": ""))
	Next

	NormalizeDashboardButtonImages(apps)
	Return apps
End Sub

Private Sub NormalizeDashboardButtonImages(Apps As List)
	If Apps.IsInitialized = False Then Return
	For i = 0 To Apps.Size - 1
		Dim raw As Object = Apps.Get(i)
		If raw Is Map Then
			Dim item As Map = raw
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
		Case "chat"
			NavigateFromMainPage("Chat")
			Return
		Case "alert"
			NavigateFromMainPage("Alert")
			Return
		Case "avatar"
			NavigateFromMainPage("Avatar")
			Return
		Case "avatar_group"
			NavigateFromMainPage("Avatar Group")
			Return
		Case "badge"
			NavigateFromMainPage("Badge")
			Return
		Case "indicator"
			NavigateFromMainPage("Indicator")
			Return
		Case "status"
			NavigateFromMainPage("Status")
			Return
		Case "stack"
			NavigateFromMainPage("Stack")
			Return
		Case "stack_photos"
			NavigateFromMainPage("Stack Photos")
			Return
		Case "mask"
			NavigateFromMainPage("Mask")
			Return
		Case "svg_icon"
			NavigateFromMainPage("SVG Icon")
			Return
		Case "swap"
			NavigateFromMainPage("Swap")
			Return
		Case "loading"
			NavigateFromMainPage("Loading")
			Return
		Case "skeleton"
			NavigateFromMainPage("Skeleton")
			Return
		Case "radialprogress"
			NavigateFromMainPage("Radial Progress")
			Return
		Case "progress"
			NavigateFromMainPage("Progress")
			Return
		Case "toast"
			NavigateFromMainPage("Toast")
			Return
		Case "tooltip"
			NavigateFromMainPage("Tooltip")
			Return
		Case "navbar"
			NavigateFromMainPage("Navbar")
			Return
	End Select
	'#If B4A
	'ToastMessageShow("App: " & ButtonDef.GetDefault("label", ButtonId), False)
	'#End If
End Sub

Private Sub NavigateFromMainPage(PageId As String)
	Dim target As String = PageId.Trim
	If target.Length = 0 Then Return
'	B4XPages.ShowPageAndRemovePreviousPages("MainPage")
	B4XPages.ShowPage(target)
End Sub

Private Sub dash_PageChanged(PageIndex As Int, PageCount As Int)
End Sub

