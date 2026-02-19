B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	' Begin page-level variable declarations.
	' Root page container provided by B4XPages.
	Private Root As B4XView
	' Cross-platform UI helper.
	Private xui As XUI
	' Scroll host so all samples remain reachable on smaller screens.
	Private svHost As ScrollView
	' Content panel inside the scroll view.
	Private pnlHost As B4XView
	' In-memory list of sample metadata used by the layout routine.
	Private AlertItems As List
	' End page-level variable declarations.
End Sub

Public Sub Initialize As Object
	' Standard B4XPages pattern: return this page instance.
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	' Capture page root.
	Root = Root1
	' Light neutral background for demo readability.
	Root.Color = xui.Color_RGB(245, 247, 250)
	' Page title shown in B4XPages top bar.
	B4XPages.SetTitle(Me, "Alert")

	' Create the scroll container with an initial content height.
	svHost.Initialize(Max(1dip, Root.Height))
	' Dock the scroll container to fill the whole page.
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	' Use the internal scroll panel as the parent for all demo controls.
	pnlHost = svHost.Panel
	' Keep panel transparent so only sample controls are visible.
	pnlHost.Color = xui.Color_Transparent

	' Build all sample definitions and layout once on page creation.
	AlertItems.Initialize
	CreateSamples
	LayoutAlerts(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	' Keep scroll host in sync with page size changes.
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	' Reflow all samples whenever the page size changes.
	LayoutAlerts(Width, Height)
End Sub

Private Sub CreateSamples
	' Rebuild from scratch each time this sub is called.
	AlertItems.Clear
	pnlHost.RemoveAllViews
	' Each map defines one demo sample. Only non-default properties are included.
	Dim defs As List
	defs.Initialize
	' Base neutral alert.
	defs.Add(CreateMap("id":"alert-base","title":"Alert","w":0,"h":56dip,"variant":"none","style":"solid","direction":"horizontal", _
		"text":"12 unread messages. Tap to see.","iconAsset":"circle-question-regular.svg"))
	' Variant color samples: solid.
	defs.Add(CreateMap("id":"alert-info","title":"Info color","w":0,"h":56dip,"variant":"info","style":"solid","direction":"horizontal", _
		"text":"New software update available.","iconAsset":"circle-question-regular.svg"))
	defs.Add(CreateMap("id":"alert-success","title":"Success color","w":0,"h":56dip,"variant":"success","style":"solid","direction":"horizontal", _
		"text":"Your purchase has been confirmed!","iconAsset":"check-solid.svg"))
	defs.Add(CreateMap("id":"alert-warning","title":"Warning color","w":0,"h":56dip,"variant":"warning","style":"solid","direction":"horizontal", _
		"text":"Warning: Invalid email address!","iconAsset":"circle-question-regular.svg"))
	defs.Add(CreateMap("id":"alert-error","title":"Error color","w":0,"h":56dip,"variant":"error","style":"solid","direction":"horizontal", _
		"text":"Error! Task failed successfully.","iconAsset":"xmark-solid.svg"))
	' Variant color samples: soft style.
	defs.Add(CreateMap("id":"alert-soft-info","title":"Alert soft style / info","w":0,"h":56dip,"variant":"info","style":"soft","direction":"horizontal", _
		"text":"12 unread messages. Tap to see.","iconAsset":"circle-question-regular.svg","iconColor":"info"))
	defs.Add(CreateMap("id":"alert-soft-success","title":"Alert soft style / success","w":0,"h":56dip,"variant":"success","style":"soft","direction":"horizontal", _
		"text":"Your purchase has been confirmed!","iconAsset":"check-solid.svg","iconColor":"success"))
	defs.Add(CreateMap("id":"alert-soft-warning","title":"Alert soft style / warning","w":0,"h":56dip,"variant":"warning","style":"soft","direction":"horizontal", _
		"text":"Warning: Invalid email address!","iconAsset":"circle-question-regular.svg","iconColor":"warning"))
	defs.Add(CreateMap("id":"alert-soft-error","title":"Alert soft style / error","w":0,"h":56dip,"variant":"error","style":"soft","direction":"horizontal", _
		"text":"Error! Task failed successfully.","iconAsset":"xmark-solid.svg","iconColor":"error"))
	' Variant color samples: outline style.
	defs.Add(CreateMap("id":"alert-outline-info","title":"Alert outline style / info","w":0,"h":56dip,"variant":"info","style":"outline","direction":"horizontal", _
		"text":"12 unread messages. Tap to see.","iconAsset":"circle-question-regular.svg","iconColor":"info"))
	defs.Add(CreateMap("id":"alert-outline-success","title":"Alert outline style / success","w":0,"h":56dip,"variant":"success","style":"outline","direction":"horizontal", _
		"text":"Your purchase has been confirmed!","iconAsset":"check-solid.svg","iconColor":"success"))
	defs.Add(CreateMap("id":"alert-outline-warning","title":"Alert outline style / warning","w":0,"h":56dip,"variant":"warning","style":"outline","direction":"horizontal", _
		"text":"Warning: Invalid email address!","iconAsset":"circle-question-regular.svg","iconColor":"warning"))
	defs.Add(CreateMap("id":"alert-outline-error","title":"Alert outline style / error","w":0,"h":56dip,"variant":"error","style":"outline","direction":"horizontal", _
		"text":"Error! Task failed successfully.","iconAsset":"xmark-solid.svg","iconColor":"error"))
	' Variant color samples: dash style.
	defs.Add(CreateMap("id":"alert-dash-info","title":"Alert dash style / info","w":0,"h":56dip,"variant":"info","style":"dash","direction":"horizontal", _
		"text":"12 unread messages. Tap to see.","iconAsset":"circle-question-regular.svg","iconColor":"info"))
	defs.Add(CreateMap("id":"alert-dash-success","title":"Alert dash style / success","w":0,"h":56dip,"variant":"success","style":"dash","direction":"horizontal", _
		"text":"Your purchase has been confirmed!","iconAsset":"check-solid.svg","iconColor":"success"))
	defs.Add(CreateMap("id":"alert-dash-warning","title":"Alert dash style / warning","w":0,"h":56dip,"variant":"warning","style":"dash","direction":"horizontal", _
		"text":"Warning: Invalid email address!","iconAsset":"circle-question-regular.svg","iconColor":"warning"))
	defs.Add(CreateMap("id":"alert-dash-error","title":"Alert dash style / error","w":0,"h":56dip,"variant":"error","style":"dash","direction":"horizontal", _
		"text":"Error! Task failed successfully.","iconAsset":"xmark-solid.svg","iconColor":"error"))
	' Vertical/horizontal responsive action button sample.
	defs.Add(CreateMap("id":"alert-buttons","title":"Alert with buttons + responsive","w":0,"h":56dip,"variant":"none","style":"solid","direction":"vertical", _
		"text":"We use cookies for no reason.","iconAsset":"circle-question-regular.svg"))
	' Title + description content sample.
	defs.Add(CreateMap("id":"alert-title-desc","title":"Alert with title and description","w":0,"h":56dip,"variant":"none","style":"solid","direction":"horizontal", _
		"titleText":"New message!","text":"","description":"You have 1 unread message","iconAsset":"circle-question-regular.svg"))

	' Materialize each definition into UI controls.
	For Each def As Map In defs
		AddAlertSample(def)
	Next
End Sub

Private Sub AddAlertSample(Def As Map)
	' Required identity and caption text for one sample.
	Dim id As String = Def.Get("id")
	Dim title As String = Def.Get("title")
	' Optional initial dimensions with safe defaults.
	Dim w As Int = Def.GetDefault("w", 0)
	Dim h As Int = Def.GetDefault("h", 56dip)
	' AddToParent requires a positive size, so seed full-width samples with current page width.
	Dim initialW As Int = IIf(w <= 0, Max(1dip, Root.Width - 24dip), w)

	' Create the title label and alert component, then register for layout.
	Dim lbl As B4XView = CreateAlertLabel(title)
	Dim alert As B4XDaisyAlert
	' Subscribe to alert events with the "alert_" event prefix.
	alert.Initialize(Me, "alert")
	' Store logical sample id in the component tag.
	alert.SetTag(id)
	' Apply only properties declared in this map.
	ApplyAlertDef(alert, Def)
	' Create and add the visual instance to the host panel.
	Dim alertView As B4XView = alert.AddToParent(pnlHost, 0, 0, initialW, h)
	' Add optional sample-specific runtime extras.
	ApplyAlertExtras(id, alert)
	' Track metadata used by the layout engine.
	AddAlertItem(id, lbl, alert, alertView, w, h)
End Sub

Private Sub ApplyAlertDef(Alert As B4XDaisyAlert, Def As Map)
	' Apply only keys that exist in the definition map.
	If Def.ContainsKey("variant") Then Alert.SetVariant(Def.Get("variant"))
	If Def.ContainsKey("style") Then Alert.SetStyle(Def.Get("style"))
	If Def.ContainsKey("direction") Then Alert.SetDirection(Def.Get("direction"))
	If Def.ContainsKey("titleText") Then Alert.SetTitle(Def.Get("titleText")) Else Alert.SetTitle("")
	If Def.ContainsKey("text") Then Alert.SetText(Def.Get("text"))
	If Def.ContainsKey("description") Then Alert.SetDescription(Def.Get("description")) Else Alert.SetDescription("")
	If Def.ContainsKey("iconAsset") Then Alert.SetIconAsset(Def.Get("iconAsset"))
	' Keep icon size and shadow aligned across all samples.
	Alert.SetIconSize("6")
	Alert.SetShadow("none")
	' Apply icon color override only when provided by this sample.
	If Def.ContainsKey("iconColor") Then Alert.SetIconColor(Def.Get("iconColor")) Else Alert.SetIconColor("")
End Sub

Private Sub ApplyAlertExtras(Id As String, Alert As B4XDaisyAlert)
	' Add optional action buttons for samples that require them.
	Select Case Id
		Case "alert-buttons"
			' Secondary action button.
			Dim deny As B4XView = Alert.AddActionButton("Deny", CreateMap("id": Id, "action": "deny"))
			deny.SetColorAndBorder(xui.Color_Transparent, 1dip, xui.Color_RGB(100, 116, 139), 6dip)
			' Primary action button.
			Dim accept As B4XView = Alert.AddActionButton("Accept", CreateMap("id": Id, "action": "accept"))
			accept.SetColorAndBorder(xui.Color_RGB(59, 130, 246), 0, xui.Color_Transparent, 6dip)
			accept.TextColor = xui.Color_White
		Case "alert-title-desc"
			' Single auxiliary action for title/description sample.
			Dim seeBtn As B4XView = Alert.AddActionButton("See", CreateMap("id": Id, "action": "see"))
			seeBtn.SetColorAndBorder(xui.Color_Transparent, 1dip, xui.Color_RGB(100, 116, 139), 6dip)
	End Select
End Sub

Private Sub CreateAlertLabel(Text As String) As B4XView
	' Shared label styling for all sample captions.
	Dim l As Label
	l.Initialize("")
	Dim x As B4XView = l
	x.Text = Text
	x.TextColor = xui.Color_RGB(51, 65, 85)
	x.TextSize = 12
	x.SetTextAlignment("CENTER", "LEFT")
	pnlHost.AddView(x, 0, 0, 10dip, 10dip)
	Return x
End Sub

Private Sub AddAlertItem(Id As String, LabelView As B4XView, Alert As B4XDaisyAlert, AlertView As B4XView, DefaultW As Int, DefaultH As Int)
	' Store layout metadata so LayoutAlerts can position all items consistently.
	' Read live props so stored width/height reflect component logic.
	Dim props As Map = Alert.GetProperties
	Dim w As Int
	If DefaultW <= 0 Then
		' Preserve "full width" sentinel used by LayoutAlerts.
		w = 0
	Else
		w = ResolveAlertSize(props, "Width", DefaultW)
	End If
	Dim h As Int = ResolveAlertSize(props, "Height", DefaultH)
	AlertItems.Add(CreateMap( _
		"id": Id, _
		"label": LabelView, _
		"alert": Alert, _
		"alert_view": AlertView, _
		"w": w, _
		"h": h _
	))
End Sub

Private Sub ResolveAlertSize(Props As Map, Key As String, DefaultSize As Int) As Int
	' Defensive fallback path if props map is missing/invalid.
	If Props.IsInitialized = False Then Return Max(24dip, DefaultSize)
	If Props.ContainsKey(Key) = False Then Return Max(24dip, DefaultSize)
	Dim value As Object = Props.Get(Key)
	' Accept both numeric dip values and Tailwind/CSS size strings.
	If IsNumber(value) Then Return Max(24dip, Round(value))
	If value <> Null Then
		Dim parsed As Float = B4XDaisyVariants.TailwindSizeToDip(value, DefaultSize)
		Return Max(24dip, Round(parsed))
	End If
	Return Max(24dip, DefaultSize)
End Sub

Private Sub LayoutAlerts(Width As Int, Height As Int)
	' Guard clauses when page is not ready.
	If pnlHost.IsInitialized = False Then Return
	If AlertItems.IsInitialized = False Then Return

	' Shared spacing and line width calculations.
	Dim pad As Int = 12dip
	Dim maxW As Int = Max(180dip, Width - (pad * 2))
	Dim y As Int = pad

	' Vertical stack layout: caption row + alert row.
	For i = 0 To AlertItems.Size - 1
		Dim item As Map = AlertItems.Get(i)
		Dim itemId As String = item.GetDefault("id", "")
		Dim xlbl As B4XView = item.Get("label")
		Dim alert As B4XDaisyAlert = item.Get("alert")
		Dim alertView As B4XView = item.Get("alert_view")
		' Cap sample width so it never overflows page content area.
		' Width <= 0 means "use full available width".
		Dim requestedW As Int = item.Get("w")
		Dim aw As Int = IIf(requestedW <= 0, maxW, Min(maxW, requestedW))
		' Keep button sample responsive by direction based on current width.
		If itemId = "alert-buttons" Then
			Dim responsiveDirection As String = IIf(Width >= 640dip, "horizontal", "vertical")
			If alert.getDirection <> responsiveDirection Then alert.SetDirection(responsiveDirection)
		End If
		' Place caption.
		Dim labelH As Int = 18dip
		xlbl.SetLayoutAnimated(0, pad, y, maxW, labelH)
		y = y + labelH + 4dip
		' Place alert with computed preferred height and minimum configured height.
		Dim computedAlertH As Int = Max(48dip, alert.GetPreferredHeight(aw))
		Dim ah As Int = Max(item.Get("h"), computedAlertH)
		alertView.SetLayoutAnimated(0, pad, y, aw, ah)
		' Notify component of its final size.
		alert.Base_Resize(aw, ah)
		y = y + ah + pad
	Next

	' Ensure panel is at least page height so scrolling behaves correctly.
	Dim contentH As Int = y
	svHost.Panel.Height = Max(Height, contentH)
End Sub

Private Sub alert_Click(Tag As Object)
	' Fired when the alert body is clicked.
	Log("Alert click: " & Tag)
End Sub

Private Sub alert_ActionClick(Tag As Object)
	' Fired when a dynamic action button is clicked.
	Dim info As String = "Action"
	If Tag Is Map Then
		Dim m As Map = Tag
		info = m.GetDefault("id", "") & " -> " & m.GetDefault("action", "")
	Else If Tag <> Null Then
		info = Tag
	End If
	Log("Alert action: " & info)
End Sub
