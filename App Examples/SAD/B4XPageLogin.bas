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

	Private pageScroll    As B4XDaisyPageScroll
	Private pnlHost       As B4XView
	Private inputEmail    As B4XDaisyInput
	Private inputPassword As B4XDaisyInput
	Private chkRemember   As B4XDaisyCheckbox
	Private btnLogin      As B4XDaisyButton
	Private pad           As Int
	Private gap           As Int
	Private maxW          As Int
	Private y             As Int
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.RemoveAllViews

	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	BuildForm
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	If inputEmail.IsInitialized Then inputEmail.Focus = True
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(Width, Height)
		BuildForm
	End If
End Sub

Private Sub BuildForm
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad * 2

	y = pageScroll.AddSectionTitle("SaaS Analytics Portal", y, True) + gap * 2

	inputEmail.Initialize(Me, "inputEmail")
	inputEmail.AddToParent(pnlHost, pad, y, maxW, 60dip)
	inputEmail.LabelAbove = "Work Email"
	inputEmail.Placeholder = "admin@company.com"
	inputEmail.InputType = "email"
	inputEmail.Required = True
	y = y + inputEmail.GetComputedHeight + gap

	inputPassword.Initialize(Me, "inputPassword")
	inputPassword.AddToParent(pnlHost, pad, y, maxW, 60dip)
	inputPassword.LabelAbove = "Password"
	inputPassword.Placeholder = "••••••••"
	inputPassword.InputType = "password"
	inputPassword.Required = True
	y = y + inputPassword.GetComputedHeight + gap

	' Nudge Remember Me down a little for breathing room
	y = y + 8dip

	chkRemember.Initialize(Me, "chkRemember")
	chkRemember.AddToParent(pnlHost, pad, y, maxW, 36dip)
	chkRemember.Text = "Remember me on this device"
	chkRemember.Checked = True
	y = y + chkRemember.GetComputedHeight + gap * 2

	btnLogin.Initialize(Me, "btnLogin")
	btnLogin.AddToParent(pnlHost, pad, y, maxW, 44dip)
	btnLogin.Text = "Sign In to Dashboard"
	btnLogin.Variant = "primary"
	btnLogin.Block = True
	y = y + btnLogin.GetComputedHeight + gap

	pageScroll.AutoFit
End Sub

' Mirrors the B4XPage demo validation methodology: call Validate() on each
' required component directly and branch on its boolean. Do not route through
' B4XDaisyVariants.ValidateControls(List). See B4XPageRange.bas:492-504 and
' B4XPageRating.bas:510-522 — same per-component Validate + branch pattern.
Private Sub btnLogin_Click(Tag As Object)
	Dim okEmail As Boolean = inputEmail.Validate
	Dim okPass  As Boolean = inputPassword.Validate
	If okEmail = False Or okPass = False Then
		pageScroll.AutoFit
		Return
	End If
	B4XPages.MainPage.ShowPageWithLoader("dashboard")
End Sub