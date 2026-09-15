B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
    
	' Page Layout
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	' Buttons
	Private btnBasic As B4XDaisyButton
	Private btnIcons As B4XDaisyButton
	Private btnIos As B4XDaisyButton
	Private btnNoBackdrop As B4XDaisyButton
	Private btnGlass As B4XDaisyButton
	Private btnStyled As B4XDaisyButton
	Private btnDarkBackdrop As B4XDaisyButton

	' Action Sheets
	Private asBasic As B4XDaisyActionSheet
	Private asIcons As B4XDaisyActionSheet
	Private asIos As B4XDaisyActionSheet
	Private asNoBackdrop As B4XDaisyActionSheet
	Private asGlass As B4XDaisyActionSheet
	Private asStyled As B4XDaisyActionSheet
	Private asDarkBackdrop As B4XDaisyActionSheet
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	' Initialize PageScroller
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	pageScroll.Clear
    
	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' 1. Basic Action Sheet
	y = pageScroll.AddSectionTitle("1. Basic Action Sheet", y, False)
	btnBasic.Initialize(Me, "btnBasic")
	btnBasic.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnBasic.Text = "Show Basic Action Sheet"
	btnBasic.Variant = "primary"
	y = y + btnBasic.GetComputedHeight + gap

	' 2. Action Sheet With Icons
	y = pageScroll.AddSectionTitle("2. Action Sheet With Icons", y, False)
	btnIcons.Initialize(Me, "btnIcons")
	btnIcons.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnIcons.Text = "Show With Icons"
	btnIcons.Variant = "secondary"
	y = y + btnIcons.GetComputedHeight + gap

	' 3. iOS Mode
	y = pageScroll.AddSectionTitle("3. iOS Mode", y, False)
	btnIos.Initialize(Me, "btnIos")
	btnIos.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnIos.Text = "Show iOS Variant"
	btnIos.Variant = "info"
	y = y + btnIos.GetComputedHeight + gap

	' 4. Prevent Backdrop Dismiss
	y = pageScroll.AddSectionTitle("4. Prevent Backdrop Dismiss", y, False)
	btnNoBackdrop.Initialize(Me, "btnNoBackdrop")
	btnNoBackdrop.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnNoBackdrop.Text = "Show Mandatory Action Sheet"
	btnNoBackdrop.Variant = "error"
	y = y + btnNoBackdrop.GetComputedHeight + gap

	' 5. Translucent Glass
	y = pageScroll.AddSectionTitle("5. Translucent Glass", y, False)
	btnGlass.Initialize(Me, "btnGlass")
	btnGlass.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnGlass.Text = "Show Translucent (MD)"
	btnGlass.Variant = "accent"
	y = y + btnGlass.GetComputedHeight + gap

	' 6. Styled Action Sheet
	y = pageScroll.AddSectionTitle("6. Styled Action Sheet", y, False)
	btnStyled.Initialize(Me, "btnStyled")
	btnStyled.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnStyled.Text = "Show Styled Sheet"
	btnStyled.Variant = "secondary"
	y = y + btnStyled.GetComputedHeight + gap

	' 7. Dark Backdrop
	y = pageScroll.AddSectionTitle("7. Dark Backdrop", y, False)
	btnDarkBackdrop.Initialize(Me, "btnDarkBackdrop")
	btnDarkBackdrop.AddToParent(pnlHost, padding, y, maxW, 40dip)
	btnDarkBackdrop.Text = "Show Dark Backdrop"
	btnDarkBackdrop.Variant = "neutral"
	y = y + btnDarkBackdrop.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub
#End Region

#Region Page Events
Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	RenderExamples(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Action Sheet Triggers & Handlers
' ----------------------------------------------------
' 1. Basic Action Sheet
' ----------------------------------------------------
Private Sub btnBasic_Click(Tag As Object)
	asBasic.Initialize(Me, "asBasic")
	asBasic.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asBasic.Header = "Albums"
	asBasic.SubHeader = "Select an album to play"
	asBasic.Outline = False
	asBasic.TextAlignment = "left"
    
	asBasic.AddButton("delete", "Delete", "destructive", "")
	asBasic.AddButton("share", "Share", "", "")
	asBasic.AddButton("play", "Play", "", "")
	asBasic.AddButton("cancel", "Cancel", "cancel", "")
    
	asBasic.Present
End Sub

Private Sub asBasic_DidDismiss(Data As Object, Role As String)
	HandleDismissData("Basic Action Sheet", Data, Role)
End Sub

' ----------------------------------------------------
' 2. Action Sheet With Icons
' ----------------------------------------------------
Private Sub btnIcons_Click(Tag As Object)
	asIcons.Initialize(Me, "asIcons")
	asIcons.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asIcons.Header = "Media Settings"
	asIcons.Outline = False
	asIcons.TextAlignment = "left"
    
	asIcons.AddButton("camera", "Camera", "", "camera-solid.svg")
	asIcons.AddButton("gallery", "Gallery", "", "image-solid.svg")
	asIcons.AddButton("video", "Video", "", "video-solid.svg")
	asIcons.AddButton("cancel", "Cancel", "cancel", "xmark-solid.svg")

	asIcons.SetButtonIconColor("camera", "primary")
	asIcons.SetButtonIconColor("gallery", "success")
	asIcons.SetButtonIconColor("video", "info")
	asIcons.SetButtonIconColor("cancel", "error")

	asIcons.Present
End Sub

Private Sub asIcons_DidDismiss(Data As Object, Role As String)
	HandleDismissData("Icons Action Sheet", Data, Role)
End Sub

' ----------------------------------------------------
' 3. iOS Mode
' ----------------------------------------------------
Private Sub btnIos_Click(Tag As Object)
	asIos.Initialize(Me, "asIos")
	asIos.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asIos.Header = "iOS Action Sheet"
	asIos.Mode = "ios"
	asIos.Translucent = False
	asIos.Outline = False
	asIos.TextAlignment = "center"
    
	asIos.AddButton("share", "Share", "", "")
	asIos.AddButton("play", "Play", "", "")
	asIos.AddButton("delete", "Delete", "destructive", "")
	asIos.AddButton("cancel", "Cancel", "cancel", "")
    
	asIos.Present
End Sub

Private Sub asIos_DidDismiss(Data As Object, Role As String)
	HandleDismissData("iOS Action Sheet", Data, Role)
End Sub

' ----------------------------------------------------
' 4. Prevent Backdrop Dismiss
' ----------------------------------------------------
Private Sub btnNoBackdrop_Click(Tag As Object)
	asNoBackdrop.Initialize(Me, "asNoBackdrop")
	asNoBackdrop.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asNoBackdrop.Header = "Mandatory Selection"
	asNoBackdrop.BackdropDismiss = False
	asNoBackdrop.Outline = False
	asNoBackdrop.TextAlignment = "left"
    
	asNoBackdrop.AddButton("accept", "Accept Terms", "", "")
	asNoBackdrop.AddButton("decline", "Decline", "destructive", "")
    
	asNoBackdrop.Present
End Sub

Private Sub asNoBackdrop_DidDismiss(Data As Object, Role As String)
	HandleDismissData("No-Backdrop Action Sheet", Data, Role)
End Sub

' ----------------------------------------------------
' 5. Translucent Glass
' ----------------------------------------------------
Private Sub btnGlass_Click(Tag As Object)
	asGlass.Initialize(Me, "asGlass")
	asGlass.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asGlass.Header = "Translucent Glass"
	asGlass.Translucent = True
	asGlass.Outline = False
	asGlass.TextAlignment = "left"

	asGlass.AddButton("share", "Share", "", "")
	asGlass.AddButton("play", "Play", "", "")
	asGlass.AddButton("delete", "Delete", "destructive", "")
	asGlass.AddButton("cancel", "Cancel", "cancel", "")

	asGlass.Present
End Sub

Private Sub asGlass_DidDismiss(Data As Object, Role As String)
	HandleDismissData("Translucent Glass", Data, Role)
End Sub

' ----------------------------------------------------
' 6. Styled Action Sheet
' ----------------------------------------------------
Private Sub btnStyled_Click(Tag As Object)
	asStyled.Initialize(Me, "asStyled")
	asStyled.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asStyled.Header = "Customize Theme"
	asStyled.SubHeader = "Pick a color variant"
	asStyled.BackgroundColor = "secondary"
	asStyled.BackdropOpacity = "0.5"
	asStyled.TextColor = "secondary-content"
	asStyled.HeaderBold = True
	asStyled.ButtonsColor = "neutral"
	asStyled.ButtonGhosted = False
	asStyled.TextAlignment = "left"

	asStyled.AddButton("primary", "Primary Action", "", "")
	asStyled.SetButtonData("primary", "Primary clicked")
	asStyled.AddButton("success", "Success Action", "", "")
	asStyled.SetButtonData("success", "Success clicked")
	asStyled.AddButton("warning", "Warning Action", "", "")
	asStyled.SetButtonData("warning", "Warning clicked")
	asStyled.AddButton("delete", "Delete", "destructive", "")
	asStyled.SetButtonData("delete", "Deleted")
	asStyled.AddButton("cancel", "Cancel", "cancel", "")
	asStyled.SetButtonData("cancel", "Cancelled")

	asStyled.SetButtonColor("primary", "primary")
	asStyled.SetButtonColor("success", "success")
	asStyled.SetButtonColor("warning", "warning")

	asStyled.Present
End Sub

Private Sub asStyled_DidDismiss(Data As Object, Role As String)
	HandleDismissData("Styled Action Sheet", Data, Role)
End Sub

' ----------------------------------------------------
' 7. Dark Backdrop
' ----------------------------------------------------
Private Sub btnDarkBackdrop_Click(Tag As Object)
	asDarkBackdrop.Initialize(Me, "asDarkBackdrop")
	asDarkBackdrop.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	asDarkBackdrop.Header = "Dark Backdrop"
	asDarkBackdrop.SubHeader = "The scrim is set to 0.7"
	asDarkBackdrop.BackdropOpacity = "0.7"
	asDarkBackdrop.TextAlignment = "left"

	asDarkBackdrop.AddButton("open", "Open", "", "")
	asDarkBackdrop.AddButton("save", "Save", "", "")
	asDarkBackdrop.AddButton("delete", "Delete", "destructive", "")
	asDarkBackdrop.AddButton("cancel", "Cancel", "cancel", "")

	asDarkBackdrop.Present
End Sub

Private Sub asDarkBackdrop_DidDismiss(Data As Object, Role As String)
	HandleDismissData("Dark Backdrop", Data, Role)
End Sub

' ----------------------------------------------------
' Shared Feedback Handler
' ----------------------------------------------------
Private Sub HandleDismissData(Context As String, Data As Object, Role As String)
	Dim msg As String
	Dim variant As String
	If Role = "backdrop" Then
		msg = Context & " dismissed via backdrop click."
		variant = "warning"
	Else If Role = "cancel" Then
		msg = Context & " cancelled."
		variant = "info"
	Else If Role = "destructive" Then
		msg = "Destructive Action: " & Data
		variant = "error"
	Else
		msg = "Action Executed: " & Data
		variant = "success"
	End If
	B4XPages.MainPage.ShowToastAlert(Context, msg, variant, 3000, "top-right")
End Sub
#End Region
