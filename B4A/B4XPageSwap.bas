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
	' Scroll host so all demo samples remain reachable on smaller screens.
	Private svHost As ScrollView
	' Content panel inside the scroll view.
	Private pnlHost As B4XView
	' In-memory list of sample metadata used by the layout routine.
	Private SampleItems As List
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
	B4XPages.SetTitle(Me, "Swap")

	' Create the scroll container with an initial content height.
	svHost.Initialize(Max(1dip, Root.Height))
	' Dock the scroll container to fill the whole page.
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	' Use the internal scroll panel as the parent for all demo controls.
	pnlHost = svHost.Panel
	' Keep panel transparent so only sample controls are visible.
	pnlHost.Color = xui.Color_Transparent

	' Build all sample definitions and layout once on page creation.
	' Initialize the list container before using it.
	SampleItems.Initialize
	' Build the demo controls and register their metadata.
	CreateSamples
	' Position everything based on current page size.
	LayoutSamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	' Keep scroll host in sync with page size changes.
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	' Reflow all samples whenever the page size changes.
	LayoutSamples(Width, Height)
End Sub

Private Sub CreateSamples
	' Rebuild from scratch each time this sub is called.
	' Clear previous sample metadata.
	SampleItems.Clear
	' Remove all previous UI controls from the host panel.
	pnlHost.RemoveAllViews
	' Each map defines one demo sample. Only non-default properties are included.
	' Create the list that will hold all sample definitions.
	Dim defs As List
	' Initialize list instance.
	defs.Initialize
	' Text swap with explicit variant-based on/off colors.
	defs.Add(CreateMap("id":"swap-text","title":"Swap text","w":72dip,"h":40dip, _
		"offColorVariant":"error","onColorVariant":"success"))
	' SVG swap: volume icon pair.
	defs.Add(CreateMap("id":"swap-icons-volume","title":"Swap volume icons","w":64dip,"h":64dip, _
		"swapType":"svg","offText":"volume-xmark-solid.svg","onText":"volume-high-solid.svg"))
	' SVG swap with rotate animation style.
	defs.Add(CreateMap("id":"swap-rotate","title":"Swap icons with rotate effect","w":56dip,"h":56dip, _
		"swapType":"svg","swapStyle":"rotate","offText":"nightmoon.svg","onText":"daysun.svg"))
	' SVG swap for hamburger/close with theme color token.
	defs.Add(CreateMap("id":"swap-hamburger","title":"Hamburger button","w":56dip,"h":56dip, _
		"swapType":"svg","swapStyle":"rotate","offText":"menu.svg","onText":"xmark-solid.svg", _
		"offColorVariant":"primary","onColorVariant":"primary","indColorVariant":"primary"))
	' SVG swap with flip animation (128px x 128px target size).
	defs.Add(CreateMap("id":"swap-flip","title":"Swap icons with flip effect","w":128dip,"h":128dip, _
		"swapType":"svg","swapStyle":"flip","offText":"face-smile-regular.svg","onText":"face-smile-solid.svg"))
	' Text swap with emoji auto-fit inside fixed bounds.
	defs.Add(CreateMap("id":"swap-emoji-fit","title":"Swap emoji auto-fit","w":120dip,"h":120dip, _
		"swapStyle":"flip","textSize":"text-9xl","offText":"😇","onText":"😈"))

	' Materialize each definition into UI controls.
	' Iterate through each definition map.
	For Each def As Map In defs
		' Build label + swap instance from the sample definition.
		AddSwapSample(def)
		' Continue until all definition maps are processed.
	Next
End Sub

Private Sub AddSwapSample(Def As Map)
	' Required identity and display text for one sample.
	' Read stable sample id.
	Dim id As String = Def.Get("id")
	' Read sample title for label text.
	Dim title As String = Def.Get("title")
	' Optional dimensions with safe defaults.
	' Read configured width or use fallback.
	Dim w As Int = Def.GetDefault("w", 72dip)
	' Read configured height or use fallback.
	Dim h As Int = Def.GetDefault("h", 40dip)

	' Create the title label and swap component, then register for layout.
	' Create visual title label.
	Dim lbl As B4XView = CreateDemoLabel(title)
	' Declare swap component instance.
	Dim swap As B4XDaisySwap
	' Subscribe to swap events with the "swap_" event prefix.
	swap.Initialize(Me, "swap")
	Dim swapView As B4XView = swap.AddToParent(pnlHost, 0, 0, w, h)
	' Store logical sample id in the component tag.
	swap.SetTag(id)
	' Apply only the properties declared in this map.
	ApplySwapDef(swap, Def)
	' Create and add the visual instance to the host panel.
'	Dim swapView As B4XView = swap.AddToParent(pnlHost, 0, 0, w, h)
	' Track metadata used by the layout engine.
	AddSampleItem(id, lbl, swap, swapView, w, h)
End Sub

Private Sub ApplySwapDef(Swap As B4XDaisySwap, Def As Map)
	' Apply only keys that exist in the definition map.
	' This keeps defaults inside the component unless overridden by the sample.
	' Optional swap content type: text/svg/avatar.
	If Def.ContainsKey("swapType") Then Swap.SetSwapType(Def.Get("swapType"))
	' Optional visual animation style: none/rotate/flip.
	If Def.ContainsKey("swapStyle") Then Swap.SetSwapStyle(Def.Get("swapStyle"))
	' Optional text size token.
	If Def.ContainsKey("textSize") Then Swap.SetTextSize(Def.Get("textSize"))
	' Optional off slot content (text/icon/image path).
	If Def.ContainsKey("offText") Then Swap.SetOffText(Def.Get("offText"))
	' Optional on slot content (text/icon/image path).
	If Def.ContainsKey("onText") Then Swap.SetOnText(Def.Get("onText"))
	' Optional indeterminate slot content.
	If Def.ContainsKey("indText") Then Swap.SetIndeterminateText(Def.Get("indText"))
	' Optional off slot color.
	If Def.ContainsKey("offColor") Then Swap.SetOffColor(Def.Get("offColor"))
	' Optional off slot color variant.
	If Def.ContainsKey("offColorVariant") Then Swap.SetOffColorVariant(Def.Get("offColorVariant"))
	' Optional off text/content color variant.
	If Def.ContainsKey("offTextColorVariant") Then Swap.SetOffTextColorVariant(Def.Get("offTextColorVariant"))
	' Optional on slot color.
	If Def.ContainsKey("onColor") Then Swap.SetOnColor(Def.Get("onColor"))
	' Optional on slot color variant.
	If Def.ContainsKey("onColorVariant") Then Swap.SetOnColorVariant(Def.Get("onColorVariant"))
	' Optional on text/content color variant.
	If Def.ContainsKey("onTextColorVariant") Then Swap.SetOnTextColorVariant(Def.Get("onTextColorVariant"))
	' Optional indeterminate slot color.
	If Def.ContainsKey("indColor") Then Swap.SetIndeterminateColor(Def.Get("indColor"))
	' Optional indeterminate slot color variant.
	If Def.ContainsKey("indColorVariant") Then Swap.SetIndeterminateColorVariant(Def.Get("indColorVariant"))
	' Optional indeterminate text/content color variant.
	If Def.ContainsKey("indTextColorVariant") Then Swap.SetIndeterminateTextColorVariant(Def.Get("indTextColorVariant"))
	' Optional initial state.
	If Def.ContainsKey("state") Then Swap.SetState(Def.Get("state"))
End Sub

Private Sub CreateDemoLabel(Text As String) As B4XView
	' Shared label styling for all sample captions.
	' Create native label object.
	Dim l As Label
	' Initialize label instance (no event name needed).
	l.Initialize("")
	' Wrap native label as B4XView for cross-platform API.
	Dim x As B4XView = l
	' Caption text.
	x.Text = Text
	' Consistent neutral label color.
	x.TextColor = xui.Color_RGB(51, 65, 85)
	' Small caption size.
	x.TextSize = 12
	' Vertical center, left aligned text.
	x.SetTextAlignment("CENTER", "LEFT")
	' Add now; exact bounds are assigned later by LayoutSamples.
	pnlHost.AddView(x, 0, 0, 1dip, 1dip)
	' Return label view to caller.
	Return x
End Sub

Private Sub AddSampleItem(Id As String, LabelView As B4XView, Swap As B4XDaisySwap, SwapView As B4XView, DefaultW As Int, DefaultH As Int)
	' Store layout metadata so LayoutSamples can position all items consistently.
	' Read live props so stored width/height reflect component logic.
	' Get current component property snapshot.
	Dim w As Int = Max(24dip, Swap.getWidth)
	Dim h As Int = Max(24dip, Swap.getHeight)
	' One item map holds everything needed for layout and runtime access.
	' Build metadata map for this sample.
	Dim item As Map = CreateMap( _
		"id": Id, _
		"label": LabelView, _
		"swap": Swap, _
		"swap_view": SwapView, _
		"w": w, _
		"h": h _
	)
	' Append this sample metadata to the list.
	SampleItems.Add(item)
End Sub

Private Sub ResolveSampleSize(Props As Map, Key As String, DefaultSize As Int) As Int
	' Defensive fallback path if props map is missing/invalid.
	' If properties map was not initialized, use fallback.
	If Props.IsInitialized = False Then Return Max(24dip, DefaultSize)
	' If requested key is missing, use fallback.
	If Props.ContainsKey(Key) = False Then Return Max(24dip, DefaultSize)
	' Read raw value from properties map.
	Dim value As Object = Props.Get(Key)
	' Use numeric values only; otherwise fall back.
	' Convert numeric value to Int while enforcing minimum display size.
	If IsNumber(value) Then Return Max(24dip, Round(value))
	' Return fallback if value is not numeric.
	Return Max(24dip, DefaultSize)
End Sub

Private Sub LayoutSamples(Width As Int, Height As Int)
	' Guard clauses when page is not ready.
	If pnlHost.IsInitialized = False Then Return
	If SampleItems.IsInitialized = False Then Return

	' Shared spacing and line width calculations.
	' Outer spacing around each sample block.
	Dim pad As Int = 12dip
	' Current y cursor used for vertical stacking.
	Dim y As Int = pad
	' Maximum width available inside horizontal padding.
	Dim maxW As Int = Max(1dip, Width - (pad * 2))

	' Vertical stack layout: caption row + component row.
	' Iterate through each sample metadata entry.
	For i = 0 To SampleItems.Size - 1
		' Read current sample metadata map.
		Dim item As Map = SampleItems.Get(i)
		' Read caption label view.
		Dim lbl As B4XView = item.Get("label")
		' Read component reference.
		Dim swap As B4XDaisySwap = item.Get("swap")
		' Read component root view.
		Dim swapView As B4XView = item.Get("swap_view")
		' Cap sample width so it never overflows page content area.
		Dim sw As Int = Min(maxW, item.Get("w"))
		' Read sample height from metadata.
		Dim sh As Int = item.Get("h")

		' Place caption.
		lbl.SetLayoutAnimated(0, pad, y, maxW, 18dip)
		y = y + 22dip
		' Place swap component under caption.
		swapView.SetLayoutAnimated(0, pad, y, sw, sh)
		swapView.SetColorAndBorder(xui.Color_Transparent, 0, xui.Color_Transparent, 0)
		' Notify component of its final size.
		swap.Base_Resize(sw, sh)
		y = y + sh + pad
		' Continue with next sample block.
	Next

	' Ensure panel is at least page height so scrolling behaves correctly.
	svHost.Panel.Height = Max(Height, y)
End Sub

Private Sub swap_Changed(State As String, Checked As Boolean)
End Sub

Private Sub swap_Click(State As String, Checked As Boolean)
End Sub
