B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12,9
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

	Dashboard.Initialize(Me, "dash")
	Dashboard.AddToParent(Root)
	Dashboard.setBackgroundImage("janis-kloter-GipF6xThS6g-unsplash.jpg")
	PopulateDashboard
'	B4XPages.MainPage.SetStatusBarState(False)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	Dashboard.Resize(Width, Height)
End Sub

Private Sub PopulateDashboard
	Dashboard.Clear
	
	Dashboard.AddItem("accordion", "Accordion", "accordion.webp")
	Dashboard.AddItem("actionsheet", "Action Sheet", "modal.webp")
	Dashboard.AddItem("sheetmodal", "Sheet Modal", "modal.webp")
	Dashboard.AddItem("alert", "Alert", "alert.webp")
	Dashboard.AddItem("avatar", "Avatar", "avatar.webp")
	Dashboard.AddItem("badge", "Badge", "badge.webp")
	Dashboard.AddItem("breadcrumbs", "Bread Crumbs", "breadcrumbs.webp")
	Dashboard.AddItem("button", "Button", "button.webp")
	Dashboard.AddItem("cspinner", "Canvas Spinner", "canvasspinner.jpeg")
	Dashboard.AddItem("card", "Card", "card.webp")
	Dashboard.AddItem("carousel", "Carousel", "carousel.webp")
	Dashboard.AddItem("chat", "Chat", "chat.webp")
	Dashboard.AddItem("checkbox", "Checkbox", "checkbox.webp")
	Dashboard.AddItem("checkbox-group", "Checkbox Group", "checkbox.webp")
	Dashboard.AddItem("collapse", "Collapse", "collapse.webp")
	Dashboard.AddItem("colorwheel", "Color Wheel", "colorwheel.png")
	Dashboard.AddItem("signaturepad", "Signature Pad", "pencil-solid.svg")
	Dashboard.AddItem("countdown", "Count Down", "countdown.webp")
	Dashboard.AddItem("diff", "Diff", "diff.webp")
	Dashboard.AddItem("divider", "Divider", "diff.webp")
	Dashboard.AddItem("dock", "Dock", "dock.webp")
	Dashboard.AddItem("dropdown", "Drop Down", "dropdown.webp")
	Dashboard.AddItem("fab", "Fab", "fab.webp")
	Dashboard.AddItem("fab_basic", "Fab Basic", "fab.webp")
	Dashboard.AddItem("fab_flower", "Fab Flower", "fab.webp")
	Dashboard.AddItem("fab_navbar", "Fab Navbar", "navbar.webp")
	Dashboard.AddItem("boommenu", "Boom Menu", "fab.webp")
	Dashboard.AddItem("fieldset", "Field Set", "fieldset.webp")
	Dashboard.AddItem("file-input", "File Input", "file-input.webp")
	Dashboard.AddItem("media-picker", "Media & File Pickers", "camera-solid.svg")
	Dashboard.AddItem("filter", "Filter", "filter.webp")
	Dashboard.AddItem("hero", "Hero", "hero.webp")
	Dashboard.AddItem("hover3d", "Hover 3D", "hover-3d.webp")
	Dashboard.AddItem("iconbutton", "Icon Button", "heart-solid.svg")
	Dashboard.AddItem("indicator", "Indicator", "indicator.webp")
	Dashboard.AddItem("input", "Input", "input.webp")
	Dashboard.AddItem("otp", "Input OTP", "input.webp")
	Dashboard.AddItem("kbd", "Kbd", "kbd.webp")
	Dashboard.AddItem("link", "Link", "link.webp")
	Dashboard.AddItem("list", "List", "list.webp")
	Dashboard.AddItem("list1k", "List 1K", "list.webp")
	Dashboard.AddItem("loading", "Loading", "loading.webp")
	Dashboard.AddItem("mask", "Mask", "mask.webp")
	Dashboard.AddItem("menu", "Menu", "menu.webp")
	Dashboard.AddItem("menu_runtime2", "Menu Level", "menu.webp")
	Dashboard.AddItem("menu_runtime", "Menu Runtime", "menu.webp")
	Dashboard.AddItem("modal", "Modal", "modal.webp")
	Dashboard.AddItem("navbar", "Navbar", "navbar.webp")
	Dashboard.AddItem("overlay", "Overlay", "eye-solid.svg")
	Dashboard.AddItem("pagination", "Pagination", "pagination.webp")
	Dashboard.AddItem("progress", "Progress", "progress.webp")
	Dashboard.AddItem("radialprogress", "Radial Progress", "radial-progress.webp")
	Dashboard.AddItem("radio", "Radio", "radio.webp")
	Dashboard.AddItem("radio-group", "Radio Group", "radio.webp")
	Dashboard.AddItem("range", "Range", "range.webp")
	Dashboard.AddItem("rating", "Rating", "rating.webp")
	Dashboard.AddItem("select", "Select", "select.webp")
	Dashboard.AddItem("picker", "Picker", "select.webp")
	Dashboard.AddItem("skeleton", "Skeleton", "skeleton.webp")
	Dashboard.AddItem("segment", "Segment", "divider.webp")
	Dashboard.AddItem("stack", "Stack", "stack.webp")
	Dashboard.AddItem("stat", "Stat", "stat.webp")
	Dashboard.AddItem("infocard", "Info Card", "stat.webp")
	Dashboard.AddItem("status", "Status", "status.webp")
	Dashboard.AddItem("steps", "Steps", "steps.webp")
	Dashboard.AddItem("svg_icon", "SVG", "bell-solid.svg")
	Dashboard.AddItem("swap", "Swap", "swap.webp")
	Dashboard.AddItem("sweetalert", "Sweet Alert", "alert.webp")
	Dashboard.AddItem("tab", "Tab", "tab.webp")
	Dashboard.AddItem("textrotate", "Text Rotate", "text-rotate.webp")
	Dashboard.AddItem("typography", "Typography", "label.webp")
	Dashboard.AddItem("textarea", "Textarea", "textarea.webp")
	Dashboard.AddItem("timeline", "Timeline", "timeline.webp")
	Dashboard.AddItem("toast", "Toast", "alert.webp")
	Dashboard.AddItem("toggle", "Toggle", "toggle.webp")
	Dashboard.AddItem("toggle-group", "Toggle Group", "toggle.webp")
	Dashboard.AddItem("tooltip", "Tooltip", "tooltip.webp")
	Dashboard.AddItem("window", "Window", "mockup-window.webp")
	Dashboard.AddItem("pagescrolldemo", "Page Scroll Demo", "divider.webp")
	Dashboard.AddItem("navscrolldock", "Nav Scroll Doc", "navbar.webp")
	Dashboard.AddItem("enjoyhint", "Enjoy Hint", "alert.webp")
	Dashboard.Refresh(True)
End Sub

Private Sub dash_ButtonClick(ButtonId As String)
	NavigateFromMainPage(ButtonId)
End Sub

Private Sub NavigateFromMainPage(PageId As String)
	Dim target As String = PageId.Trim
	If target.Length = 0 Then Return
	Try
		B4XPages.MainPage.ShowPageWithLoader(target)
	Catch
		Log("B4XPageDashboard.NavigateFromMainPage: " & LastException.Message)
		B4XPages.MainPage.ShowToast("Navigation error: " & LastException.Message, True)
	End Try
End Sub

Private Sub dash_Changed(PageIndex As Int, PageCount As Int)
End Sub
