B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Private Root As B4XView
	Private scvContent As ScrollView
	Private pnlContent As B4XView
	Private currentY As Int = 20dip
	Private gap As Int = 40dip
	Private toaster As B4XDaisyToast
	Private bellIndicator As B4XDaisyIndicator
	Private nbClearStart As B4XDaisyNavbar
	Private nbClearCenter As B4XDaisyNavbar
	Private nbClearEnd As B4XDaisyNavbar
	' FAB shown alongside the first navbar example (fixed bottom-end placement)
	Private nb1Fab As B4XDaisyFab
End Sub

Public Sub Initialize
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	' Create ScrollView programmatically
	scvContent.Initialize(0)
	Root.AddView(scvContent, 0, 0, Root.Width, Root.Height)
	pnlContent = scvContent.Panel
	pnlContent.Color = xui.Color_RGB(242, 242, 242)
	B4XDaisyVariants.DisableClipping(pnlContent)
	
	' Initialize toaster
	toaster.Initialize(Me, "toaster")
	toaster.CreateView
	toaster.SetRoot(Root)
	toaster.SetPosition("end", "top")
	
	AddTitle("Navbar Basics")
	
	' 1. Navbar with title only
	AddNavbarTitleOnly
	
	' 2. Navbar with title and icon
	AddNavbarTitleAndIcon
	
	' 3. Navbar with icon at start and end
	AddNavbarIconsStartEnd
	
	AddTitle("Theming & Variants")
	
	' 9. Navbars with Colors
	AddNavbarVariant("primary")
	AddNavbarVariant("neutral")
	AddNavbarVariant("secondary")
	
	AddTitle("Special Effects")
	
	' 10. Glass effect navbar
	AddNavbarGlass
	
	AddTitle("Complex Layouts")
	
	' 7. Navbar with dropdown/center/end (Simplified)
	AddNavbarComplex
	
	AddTitle("Interactive Navbar")
	
	' 11. Interactive Navbar with Hamburger and Logo
	AddNavbarInteractive
	
	' 12. Center Logo Navbar
	AddNavbarCenterLogo
	
	AddTitle("Rounded Options")
	AddNavbarRounded("none")
	AddNavbarRounded("sm")
	AddNavbarRounded("rounded")
	AddNavbarRounded("md")
	AddNavbarRounded("lg")
	AddNavbarRounded("xl")
	AddNavbarRounded("full")

	AddTitle("Shadow Levels")
	AddNavbarShadow("none")
	AddNavbarShadow("sm")
	AddNavbarShadow("md")
	AddNavbarShadow("lg")
	AddNavbarShadow("xl")
	AddNavbarShadow("2xl")
	
	AddTitle("Navbar with Circle Icon Buttons")
	AddNavbarWithCircleButtons
	
	AddTitle("Navbar with Start, Center, and End Button Icons")
	AddNavbarWithThreeCircleButtons

	AddTitle("Navbar with Text Buttons (AddButtonTo*)")

	' Ghost start button, primary end button
	AddNavbarTextButtons_GhostAndPrimary

	' Secondary and Accent
	AddNavbarTextButtons_SecondaryAndAccent

	' Success, Warning, Error
	AddNavbarTextButtons_StatusVariants

	' Center text button, neutral solid
	AddNavbarTextButtons_CenterNeutral

	AddTitle("Navbar with Back Button")

	' Back button: icon only
	AddNavbarBackIconOnly

	' Back button: icon + text label
	AddNavbarBackWithText

	AddTitle("Slot Clear Demo")

	' Demo 1: Clear Start slot
	AddNavbarClearStartDemo

	' Demo 2: Clear Center slot
	AddNavbarClearCenterDemo

	' Demo 3: Clear End slot
	AddNavbarClearEndDemo

	pnlContent.Height = currentY + 40dip
End Sub

Private Sub AddTitle(Text As String)
        Dim lbl As B4XDaisyText
        lbl.Initialize(Me, "")
        lbl.AddToParent(pnlContent, 20dip, currentY, Root.Width - 40dip, 30dip)
        lbl.Text = Text
        lbl.TextSize = 18
        lbl.FontBold = True
        lbl.TextColor = xui.Color_DarkGray
        currentY = currentY + lbl.GetComputedHeight + 10dip
End Sub

' =======================================================
' AddNavbarTitleOnly
' Demonstrates a basic Navbar with a title only.
' Also shows a fixed FAB (bottom-end) on Root — the simplest
' way to pair a FAB with a Navbar page. The FAB uses fixed
' placement so it always sits at the screen corner, independent
' of the ScrollView content position.
' =======================================================
Private Sub AddNavbarTitleOnly
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb1")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Anele Mbanga (Mashy)"
	currentY = currentY + 64dip + gap

	' --- FAB example: fixed bottom-end placement on Root ---
	' Using PlacementMode=fixed keeps the FAB at a stable screen position
	' regardless of the ScrollView scroll offset. This is the correct
	' approach when the navbar lives inside a scrollable container.
	If nb1Fab.IsInitialized = False Then
		nb1Fab.Initialize(Me, "nb1_fab")
		nb1Fab.PlacementMode = "fixed"
		nb1Fab.Placement = "bottom-end"
		nb1Fab.TriggerText = ""
		nb1Fab.TriggerIconName = "plus-solid.svg"
		nb1Fab.TriggerVariant = "primary"
		nb1Fab.TriggerCircle = True
		nb1Fab.UseCloseAction = True
		nb1Fab.CloseActionText = ""
		nb1Fab.CloseActionVariant = "error"
		nb1Fab.CloseActionIconName = "xmark-solid.svg"
		nb1Fab.AddAction("camera", "neutral", "camera-solid.svg")
		nb1Fab.AddAction("share", "info", "upload-solid.svg")
		nb1Fab.AddToParent(Root, 0, 0, 56dip, 56dip)
		nb1Fab.BringToFront
	End If
End Sub

Private Sub AddNavbarTitleAndIcon
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb2")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "daisyUI"
	
	' Add a primary solid text button to the end slot using the new API
	Dim btn As B4XDaisyButton = nb.AddButtonToEnd("nb2_menu", "MENU", "primary", 80dip, 36dip, False)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub nb2_menu_Click (Tag As Object)
	toaster.InfoWithDuration("MENU button clicked!", 1500)
End Sub

Private Sub AddNavbarIconsStartEnd
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb3")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	
	Dim startIcon As B4XDaisySvgIcon = nb.AddSVGIconToStart("bars", "bars-solid.svg", 24dip, xui.Color_Black)
	
	nb.Title = "Middle Title"
	nb.TitlePosition = "center"
	
	Dim endIcon As B4XDaisySvgIcon = nb.AddSVGIconToEnd("ellipsis", "ellipsis-solid.svg", 24dip, xui.Color_Black)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarVariant(VariantName As String)
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_" & VariantName)
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "DaisyUI"
	nb.Variant = VariantName
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarGlass
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_glass")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Glass Navbar"
	nb.Glass = True
	nb.Variant = "primary"
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarComplex
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_complex")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "daisyUI"
	nb.TitlePosition = "center"
	
	Dim complexIcon As B4XDaisySvgIcon = nb.AddSVGIconToStart("complex_bars", "bars-solid.svg", 24dip, xui.Color_Black)
	
	' End: Avatar
	Dim av As B4XDaisyAvatar = nb.AddAvatarToEnd("avatar", "face_1.jpg", 40dip, "rounded-full")
	
	' Add Indicator to Avatar
	Dim ind As B4XDaisyIndicator
	ind.Initialize(Me, "")
	ind.CreateView(12dip, 12dip)
	ind.Variant = "success"
	ind.HorizontalPlacement = "start"
	ind.VerticalPlacement = "top"
	ind.AttachToTarget(av.mBase)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarInteractive
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_int")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.HamburgerVisible = True
	nb.Title = "B4XDaisy UIKit"
	
	' Set new Logo properties programmatically using idiomatic assignments
	nb.LogoImage = "wonderperson@192.webp"
	nb.LogoWidth = 40
	nb.LogoHeight = 40
	nb.LogoMask = "squircle"
	nb.LogoPosition = "start"
	nb.LogoVisible = True
	
	' Add Bell Icon to End
	Dim bell As B4XDaisySvgIcon = nb.AddSVGIconToEnd("bell", "bell-solid.svg", 24dip, xui.Color_Black)
	
	' Add Indicator to Bell
	bellIndicator.Initialize(Me, "")
	bellIndicator.CreateView(24dip, 24dip) ' Initialize internal indicator views
	bellIndicator.Counter = True
	bellIndicator.Text = "97"
	bellIndicator.setCapValue(99)
	bellIndicator.setRounded("rounded-full")
	bellIndicator.Variant = "primary"
	bellIndicator.HorizontalPlacement = "start"
	bellIndicator.AttachToTarget(bell.mBase)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarCenterLogo
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_center_logo")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Center Logo"
	nb.TitlePosition = "center"
	
	' Set Logo properties to position it in the center slot
	nb.LogoImage = "wonderperson@192.webp"
	nb.LogoWidth = 36
	nb.LogoHeight = 36
	nb.LogoMask = "mask-circle"
	nb.LogoPosition = "center"
	nb.LogoVisible = True
	
	currentY = currentY + 64dip + gap
End Sub

' Event handlers for nb_int
Private Sub nb_int_Opened
	' Log used for verification in this specific task as requested
	'Log("Navbar Opened")
	toaster.InfoWithDuration("Hamburger: Opened", 1000)
End Sub

Private Sub nb_int_Closed
	'Log("Navbar Closed")
	toaster.InfoWithDuration("Hamburger: Closed", 1000)
End Sub

Private Sub nb_int_LogoClick
	toaster.SuccessWithDuration("Logo Clicked!", 1500)
End Sub

Private Sub nb_center_logo_LogoClick
	toaster.SuccessWithDuration("Center Logo Clicked!", 1500)
End Sub

Private Sub bell_Click(Tag As Object)
	bellIndicator.Increment
	toaster.InfoWithDuration("Bell clicked! Count: " & bellIndicator.getValue & " (displays: " & bellIndicator.Text & ")", 1500)
End Sub

Private Sub bars_Click(Tag As Object)
	toaster.InfoWithDuration("Start Icon (bars) Clicked!", 1500)
End Sub

Private Sub ellipsis_Click(Tag As Object)
	toaster.InfoWithDuration("End Icon (ellipsis) Clicked!", 1500)
End Sub

Private Sub complex_bars_Click(Tag As Object)
	toaster.InfoWithDuration("Complex Start Icon (bars) Clicked!", 1500)
End Sub

Private Sub avatar_Click(Tag As Object)
	toaster.InfoWithDuration("Avatar Icon Clicked!", 1500)
End Sub

Private Sub AddNavbarWithCircleButtons
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_buttons")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "daisyUI Buttons"
	
	' Add ghost circle button to start with green icon color
	Dim btnStart As B4XDaisyButton = nb.AddButtonIconToStart("btn_start", 40dip, "bars-solid.svg", xui.Color_RGB(34, 197, 94), True)
	
	' Add solid success variant button to end
	Dim btnEnd As B4XDaisyButton = nb.AddButtonIconToEnd("btn_end", 40dip, "save.svg", xui.Color_White, False)
	btnEnd.Variant = "success"
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub btn_start_Click (Tag As Object)
	toaster.InfoWithDuration("Start Ghost Button Clicked!", 1500)
End Sub

Private Sub btn_end_Click (Tag As Object)
	toaster.InfoWithDuration("End Solid Button Clicked!", 1500)
End Sub

Private Sub AddNavbarWithThreeCircleButtons
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_three_buttons")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	
	' Add ghost circle button to start
	Dim btnLeft As B4XDaisyButton = nb.AddButtonIconToStart("btn_left", 40dip, "bars-solid.svg", xui.Color_Black, True)
	
	' Add ghost circle button to center
	Dim btnMiddle As B4XDaisyButton = nb.AddButtonIconToCenter("btn_middle", 40dip, "search-solid.svg", xui.Color_Black, True)
	
	' Add solid circle button to end
	Dim btnRight As B4XDaisyButton = nb.AddButtonIconToEnd("btn_right", 40dip, "save.svg", xui.Color_Black, True)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub btn_left_Click (Tag As Object)
	toaster.InfoWithDuration("Left Button Clicked!", 1500)
End Sub

Private Sub btn_middle_Click (Tag As Object)
	toaster.InfoWithDuration("Middle Button Clicked!", 1500)
	
	' Automatically increment/decrement to demonstrate
	bellIndicator.Increment
End Sub

Private Sub btn_right_Click (Tag As Object)
	toaster.InfoWithDuration("Right Button Clicked!", 1500)
End Sub

Private Sub AddNavbarRounded(RoundedMode As String)
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_rounded_" & RoundedMode)
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Rounded: " & RoundedMode
	nb.Variant = "neutral"
	nb.Rounded = RoundedMode
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarShadow(ShadowLevel As String)
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_shadow_" & ShadowLevel)
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Shadow: " & ShadowLevel
	nb.Variant = "none"
	nb.BackgroundColor = xui.Color_White
	nb.Shadow = ShadowLevel
	nb.Rounded = "md"
	currentY = currentY + 64dip + gap
End Sub

' =============================================
' Navbar with Text Buttons demos
' =============================================

' Demo: ghost start button + primary solid end button.
' Demonstrates AddButtonToStart (ghost) and AddButtonToEnd (primary).
Private Sub AddNavbarTextButtons_GhostAndPrimary
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_txtbtn_gp")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)

	' Ghost button on the start (left) side
	Dim btnGhost As B4XDaisyButton = nb.AddButtonToStart("nbtxt_ghost", "Menu", "none", 80dip, 36dip, True)

	' Solid primary button on the end (right) side
	Dim btnPrimary As B4XDaisyButton = nb.AddButtonToEnd("nbtxt_primary", "Login", "primary", 80dip, 36dip, False)

	currentY = currentY + 64dip + gap
End Sub

' Demo: secondary start button + accent end button.
Private Sub AddNavbarTextButtons_SecondaryAndAccent
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_txtbtn_sa")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)

	' Solid secondary on start
	Dim btnSec As B4XDaisyButton = nb.AddButtonToStart("nbtxt_secondary", "Back", "secondary", 80dip, 36dip, False)

	' Solid accent on end
	Dim btnAccent As B4XDaisyButton = nb.AddButtonToEnd("nbtxt_accent", "Save", "accent", 80dip, 36dip, False)

	currentY = currentY + 64dip + gap
End Sub

' Demo: success / warning / error - one button each in a single navbar.
' Uses start, center, and end slots to show all three status variants.
Private Sub AddNavbarTextButtons_StatusVariants
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_txtbtn_swer")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)

	' Success on start
	Dim btnOk As B4XDaisyButton = nb.AddButtonToStart("nbtxt_success", "OK", "success", 70dip, 36dip, False)

	' Warning ghost in center
	Dim btnWarn As B4XDaisyButton = nb.AddButtonToCenter("nbtxt_warning", "Warn", "warning", 80dip, 36dip, True)

	' Error solid on end
	Dim btnErr As B4XDaisyButton = nb.AddButtonToEnd("nbtxt_error", "Delete", "error", 90dip, 36dip, False)

	currentY = currentY + 64dip + gap
End Sub

' Demo: neutral solid button placed in the center slot only.
' Demonstrates AddButtonToCenter with a neutral variant.
Private Sub AddNavbarTextButtons_CenterNeutral
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_txtbtn_cn")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)

	' SVG icon on start for visual balance
	Dim startIcon As B4XDaisySvgIcon = nb.AddSVGIconToStart("nbtxt_bars", "bars-solid.svg", 24dip, xui.Color_Black)

	' Neutral text button centered
	Dim btnNeutral As B4XDaisyButton = nb.AddButtonToCenter("nbtxt_neutral", "Actions", "neutral", 100dip, 36dip, False)

	' Ghost end button
	Dim btnGhostEnd As B4XDaisyButton = nb.AddButtonToEnd("nbtxt_ghost_end", "Skip", "none", 80dip, 36dip, True)

	currentY = currentY + 64dip + gap
End Sub

' ---- Click handlers for text-button demos ----

Private Sub nbtxt_ghost_Click (Tag As Object)
	toaster.InfoWithDuration("Ghost Menu button tapped", 1500)
End Sub

Private Sub nbtxt_primary_Click (Tag As Object)
	toaster.SuccessWithDuration("Primary Login button tapped", 1500)
End Sub

Private Sub nbtxt_secondary_Click (Tag As Object)
	toaster.InfoWithDuration("Secondary Back button tapped", 1500)
End Sub

Private Sub nbtxt_accent_Click (Tag As Object)
	toaster.SuccessWithDuration("Accent Save button tapped", 1500)
End Sub

Private Sub nbtxt_success_Click (Tag As Object)
	toaster.SuccessWithDuration("Success OK button tapped", 1500)
End Sub

Private Sub nbtxt_warning_Click (Tag As Object)
	toaster.WarningWithDuration("Warning button tapped", 1500)
End Sub

Private Sub nbtxt_error_Click (Tag As Object)
	toaster.ErrorWithDuration("Error Delete button tapped", 1500)
End Sub

Private Sub nbtxt_neutral_Click (Tag As Object)
	toaster.InfoWithDuration("Neutral Actions button tapped", 1500)
End Sub

Private Sub nbtxt_bars_Click(Tag As Object)
	toaster.InfoWithDuration("Center-neutral navbar: bars clicked", 1500)
End Sub

Private Sub nbtxt_ghost_end_Click (Tag As Object)
	toaster.InfoWithDuration("Ghost Skip button tapped", 1500)
End Sub

' Back button: icon only (no label text)
' BackVisible = True with BackLabel = "" produces a ghost circle icon button.
Private Sub AddNavbarBackIconOnly
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_back_icon")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Page Title"
	nb.TitlePosition = "center"
	nb.BackVisible = True
	nb.BackLabel = ""
	currentY = currentY + 64dip + gap
End Sub

Private Sub nb_back_icon_Back (Tag As Object)
	toaster.InfoWithDuration("Back (icon only) tapped", 1500)
End Sub

' Back button: icon + text label
' BackVisible = True with BackLabel = "Back" produces a ghost icon+text button.
Private Sub AddNavbarBackWithText
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_back_text")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.Title = "Detail View"
	nb.TitlePosition = "center"
	nb.BackVisible = True
	nb.BackLabel = "Back"
	currentY = currentY + 64dip + gap
End Sub

Private Sub nb_back_text_Back (Tag As Object)
	toaster.SuccessWithDuration("Back (with text) tapped", 1500)
End Sub


' =======================================================
' Slot Clear Demo 1: Clear Start Slot
' =======================================================
' Builds a navbar with 3 items in the start slot
' (hamburger button, a bars SVG icon, a ghost text button).
' An external "Clear Start" button removes all of them, then
' adds a fresh "Home" solid primary button to the start slot.
Private Sub AddNavbarClearStartDemo
	nbClearStart.Initialize(Me, "nbcs")
	Dim nbView As B4XView = nbClearStart.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nbClearStart.Variant = "neutral"
	
	' Start slot items that will be cleared
	Dim barsIcon As B4XDaisySvgIcon = nbClearStart.AddSVGIconToStart("nbcs_bars", "bars-solid.svg", 22dip, xui.Color_White)
	Dim menuBtn As B4XDaisyButton = nbClearStart.AddButtonToStart("nbcs_menu", "Menu", "none", 70dip, 34dip, True)
	
	' Center title for reference
	nbClearStart.AddTitleToEnd("Start Slot Demo")
	
	currentY = currentY + 64dip + gap
	
	' External "Clear Start" button below the navbar
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "nbcs_clearBtn")
	btn.AddToParent(pnlContent, 10dip, currentY, 160dip, 40dip)
	btn.Text = "Clear Start Slot"
	btn.Variant = "error"
	
	currentY = currentY + 40dip + gap
End Sub

Private Sub nbcs_clearBtn_Click (Tag As Object)
	' Clear all items from the start slot and add a new "Home" button
	nbClearStart.ClearStartSlot
	Dim homeBtn As B4XDaisyButton = nbClearStart.AddButtonToStart("nbcs_home", "Home", "primary", 90dip, 36dip, False)
	toaster.SuccessWithDuration("Start slot cleared! Added: Home button", 2000)
End Sub

Private Sub nbcs_home_Click (Tag As Object)
	toaster.InfoWithDuration("Home button tapped!", 1500)
End Sub

Private Sub nbcs_bars_Click(Tag As Object)
	toaster.InfoWithDuration("Start bars icon tapped", 1500)
End Sub

Private Sub nbcs_menu_Click (Tag As Object)
	toaster.InfoWithDuration("Start Menu button tapped", 1500)
End Sub

Private Sub nbcs_Opened
	toaster.InfoWithDuration("Hamburger opened", 1000)
End Sub

Private Sub nbcs_Closed
	toaster.InfoWithDuration("Hamburger closed", 1000)
End Sub

' =======================================================
' Slot Clear Demo 2: Clear Center Slot
' =======================================================
' Builds a navbar with 2 items in the center slot
' (title label + a search SVG icon).
' An external "Clear Center" button removes both, then
' adds a "Search" ghost button to the center slot.
Private Sub AddNavbarClearCenterDemo
	nbClearCenter.Initialize(Me, "nbcc")
	Dim nbView As B4XView = nbClearCenter.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nbClearCenter.Variant = "primary"
	
	' Start slot item for visual balance
	Dim barsL As B4XDaisySvgIcon = nbClearCenter.AddSVGIconToStart("nbcc_bars", "bars-solid.svg", 22dip, xui.Color_White)
	
	' Center slot items that will be cleared
	nbClearCenter.AddTitleToCenter("My App")
	Dim searchBtn As B4XDaisyButton = nbClearCenter.AddButtonIconToCenter("nbcc_search", 36dip, "search-solid.svg", xui.Color_White, True)
	
	currentY = currentY + 64dip + gap
	
	' External "Clear Center" button below the navbar
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "nbcc_clearBtn")
	btn.AddToParent(pnlContent, 10dip, currentY, 180dip, 40dip)
	btn.Text = "Clear Center Slot"
	btn.Variant = "error"
	
	currentY = currentY + 40dip + gap
End Sub

Private Sub nbcc_clearBtn_Click (Tag As Object)
	' Clear all items from the center slot and add a new search button
	nbClearCenter.ClearCenterSlot
	Dim searchBtn As B4XDaisyButton = nbClearCenter.AddButtonToCenter("nbcc_newsearch", "Search", "none", 100dip, 36dip, True)
	toaster.SuccessWithDuration("Center slot cleared! Added: Search button", 2000)
End Sub

Private Sub nbcc_newsearch_Click (Tag As Object)
	toaster.InfoWithDuration("New Search button tapped!", 1500)
End Sub

Private Sub nbcc_bars_Click(Tag As Object)
	toaster.InfoWithDuration("Center demo start bars tapped", 1500)
End Sub

Private Sub nbcc_search_Click (Tag As Object)
	toaster.InfoWithDuration("Center search button tapped", 1500)
End Sub

' =======================================================
' Slot Clear Demo 3: Clear End Slot
' =======================================================
' Builds a navbar with 2 items in the end slot
' (a bell SVG icon + a "Login" solid button).
' An external "Clear End" button removes both, then
' adds a "Profile" success button to the end slot.
Private Sub AddNavbarClearEndDemo
	nbClearEnd.Initialize(Me, "nbce")
	Dim nbView As B4XView = nbClearEnd.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nbClearEnd.Variant = "secondary"
	nbClearEnd.AddTitleToStart("End Slot Demo")
	
	' End slot items that will be cleared
	Dim bellIcon As B4XDaisySvgIcon = nbClearEnd.AddSVGIconToEnd("nbce_bell", "bell-solid.svg", 22dip, xui.Color_White)
	Dim loginBtn As B4XDaisyButton = nbClearEnd.AddButtonToEnd("nbce_login", "Login", "primary", 80dip, 36dip, False)
	
	currentY = currentY + 64dip + gap
	
	' External "Clear End" button below the navbar
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "nbce_clearBtn")
	btn.AddToParent(pnlContent, 10dip, currentY, 160dip, 40dip)
	btn.Text = "Clear End Slot"
	btn.Variant = "error"
	
	currentY = currentY + 40dip + gap
End Sub

Private Sub nbce_clearBtn_Click (Tag As Object)
	' Clear all items from the end slot and add a new profile button
	nbClearEnd.ClearEndSlot
	Dim profileBtn As B4XDaisyButton = nbClearEnd.AddButtonToEnd("nbce_profile", "Profile", "success", 90dip, 36dip, False)
	toaster.SuccessWithDuration("End slot cleared! Added: Profile button", 2000)
End Sub

Private Sub nbce_profile_Click (Tag As Object)
	toaster.InfoWithDuration("Profile button tapped!", 1500)
End Sub

Private Sub nbce_bell_Click(Tag As Object)
	toaster.InfoWithDuration("End bell icon tapped", 1500)
End Sub

Private Sub nbce_login_Click (Tag As Object)
	toaster.InfoWithDuration("End Login button tapped", 1500)
End Sub

' --- FAB events for the fixed FAB on the first navbar example ---

Private Sub nb1_fab_Click(Tag As Object)
	toaster.InfoWithDuration("FAB clicked!", 1500)
End Sub

Private Sub nb1_fab_ActionClick(Index As Int, Tag As Object)
	Dim actionName As String = ""
	If Tag <> Null Then actionName = Tag
	toaster.InfoWithDuration("Action " & Index & ": " & actionName, 2000)
End Sub

Private Sub B4XPage_Appear
    ' Bring fixed FAB to front whenever this page becomes visible
    If nb1Fab.IsInitialized Then
        nb1Fab.BringToFront
    End If
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
