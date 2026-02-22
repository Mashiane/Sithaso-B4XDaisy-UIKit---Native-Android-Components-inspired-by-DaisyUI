B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
Sub Class_Globals
	Private xui As XUI
	Private Root As B4XView
	Private scvContent As ScrollView
	Private pnlContent As B4XView
	Private currentY As Int = 20dip
	Private gap As Int = 40dip
	Private toaster As B4XDaisyToast
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
	
	pnlContent.Height = currentY + 40dip
End Sub

Private Sub AddTitle(Text As String)
	Dim lbl As Label
	lbl.Initialize("")
	Dim xl As B4XView = lbl
	xl.Text = Text
	xl.Font = xui.CreateDefaultBoldFont(18)
	xl.TextColor = xui.Color_DarkGray
	pnlContent.AddView(xl, 20dip, currentY, Root.Width - 40dip, 30dip)
	currentY = currentY + 40dip
End Sub

Private Sub AddNavbarTitleOnly
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb1")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.AddTitleToStart("Anele Mbanga (Mashy)")
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarTitleAndIcon
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb2")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.AddTitleToStart("daisyUI")
	
	' Use a standard button for now or a glyph
	Dim btn As Button
	btn.Initialize("")
	Dim xbtn As B4XView = btn
	xbtn.Text = "MENU"
	nb.AddViewToEnd(xbtn, 80dip, 40dip)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarIconsStartEnd
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb3")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	
	' Start icon (placeholder)
	Dim b1 As Button
	b1.Initialize("")
	Dim xb1 As B4XView = b1
	xb1.Text = "≡"
	nb.AddViewToStart(b1, 44dip, 44dip)
	
	nb.AddTitleToCenter("Middle Title")
	
	' End icon (placeholder)
	Dim b2 As Button
	b2.Initialize("")
	Dim xb2 As B4XView = b2
	xb2.Text = "🔍"
	nb.AddViewToEnd(b2, 44dip, 44dip)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarVariant(VariantName As String)
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_" & VariantName)
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.setVariant(VariantName)
	nb.AddTitleToStart("DaisyUI")
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarGlass
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_glass")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.setGlass(True)
	nb.setVariant("primary")
	nb.AddTitleToStart("Glass Navbar")
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarComplex
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_complex")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	
	' Start: Burger
	Dim b1 As Button
	b1.Initialize("")
	Dim xb1 As B4XView = b1
	xb1.Text = "☰"
	nb.AddViewToStart(b1, 44dip, 44dip)
	
	' Center: Logo
	nb.AddTitleToCenter("daisyUI")
	
	' End: Avatar
	nb.AddAvatarToEnd("face_1.jpg", 40dip)
	
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarInteractive
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_int")
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	
	nb.AddHamburger(48dip)
	nb.AddLogo("wonderperson@192.webp", 40dip, 40dip, "squircle")
	nb.AddTitleToStart("B4XDaisy UIKit")
	
	' Add Bell Icon to End
	Dim bell As B4XDaisySvgIcon
	bell.Initialize(Me, "")
	Dim bellView As B4XView = bell.CreateView(24dip, 24dip)
	bell.setSvgAsset("bell-solid.svg")
	bell.setColor(xui.Color_Black)
	nb.AddViewToEnd(bellView, 24dip, 24dip)
	
	' Add Indicator to Bell
	Dim ind As B4XDaisyIndicator
	ind.Initialize(Me, "")
	ind.CreateView(24dip, 24dip) ' Initialize internal indicator views
	ind.setCounter(True)
	ind.setText("5")
	ind.setVariant("primary")
	ind.setHorizontalPlacement("start")
	ind.AttachToTarget(bellView)
	
	
	currentY = currentY + 64dip + gap
End Sub

' Event handlers for nb_int
Private Sub nb_int_Opened
	' Log used for verification in this specific task as requested
	Log("Navbar Opened")
	toaster.InfoWithDuration("Hamburger: Opened", 1000)
End Sub

Private Sub nb_int_Closed
	Log("Navbar Closed")
	toaster.InfoWithDuration("Hamburger: Closed", 1000)
End Sub

Private Sub AddNavbarRounded(RoundedMode As String)
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_rounded_" & RoundedMode)
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.setVariant("neutral")
	nb.setRounded(RoundedMode)
	nb.AddTitleToStart("Rounded: " & RoundedMode)
	currentY = currentY + 64dip + gap
End Sub

Private Sub AddNavbarShadow(ShadowLevel As String)
	Dim nb As B4XDaisyNavbar
	nb.Initialize(Me, "nb_shadow_" & ShadowLevel)
	Dim nbView As B4XView = nb.AddToParent(pnlContent, 10dip, currentY, Root.Width - 20dip, 64dip)
	nb.setVariant("none") 
	nb.setBackgroundColor(xui.Color_White)
	nb.setShadow(ShadowLevel)
	nb.setRounded("md")
	nb.AddTitleToStart("Shadow: " & ShadowLevel)
	currentY = currentY + 64dip + gap
End Sub
