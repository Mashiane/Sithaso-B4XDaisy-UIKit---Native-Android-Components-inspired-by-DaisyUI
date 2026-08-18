B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private Navbar As B4XDaisyNavbar
	Private pdfViewer As B4XDaisyPDFView
	Private PAGE_PAD As Int = 12dip
	Private NAVBAR_HEIGHT As Int = 56dip
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))

	' Top Navbar
	Navbar.Initialize(Me, "Navbar")
	Navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_HEIGHT)
	Navbar.Title = "PDF Viewer Demo"
	Navbar.BackVisible = True

	' B4XDaisyPDFView Component below navbar with padding
	Dim pdfTop As Int = NAVBAR_HEIGHT + PAGE_PAD
	Dim pdfW As Int = Max(10dip, Root.Width - (PAGE_PAD * 2))
	Dim pdfH As Int = Max(10dip, Root.Height - pdfTop - PAGE_PAD)

	pdfViewer.Initialize(Me, "pdfViewer")
	pdfViewer.AddToParent(Root, PAGE_PAD, pdfTop, pdfW, pdfH)

	' Load sample PDF asset
	pdfViewer.LoadAsset("chapter_5.pdf")
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Root.IsInitialized = False Then Return
	If Navbar.View.IsInitialized Then
		Navbar.View.SetLayoutAnimated(0, 0, 0, Width, NAVBAR_HEIGHT)
		Navbar.Base_Resize(Width, NAVBAR_HEIGHT)
	End If

	Dim pdfTop As Int = NAVBAR_HEIGHT + PAGE_PAD
	Dim pdfW As Int = Max(10dip, Width - (PAGE_PAD * 2))
	Dim pdfH As Int = Max(10dip, Height - pdfTop - PAGE_PAD)

	If pdfViewer.View.IsInitialized Then
		pdfViewer.View.SetLayoutAnimated(0, PAGE_PAD, pdfTop, pdfW, pdfH)
		pdfViewer.Base_Resize(pdfW, pdfH)
	End If
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
	If pdfViewer.IsInitialized Then
		pdfViewer.Reload
	End If
End Sub
#End Region

#Region Event Handlers
Private Sub Navbar_Back (Tag As Object)
	B4XPages.MainPage.ClosePageWithLoader(Me)
End Sub

Private Sub Navbar_BackClick (Tag As Object)
	Navbar_Back(Tag)
End Sub

Private Sub pdfViewer_LoadComplete(Pages As Int)
	Log($"PDF Loaded successfully. Total pages: ${Pages}"$)
End Sub

Private Sub pdfViewer_PageChanged(Page As Int, TotalPages As Int)
	Log($"PDF Page Changed: ${Page + 1} / ${TotalPages}"$)
End Sub

Private Sub pdfViewer_OnTap(Target As Object)
	Log("PDF Tapped")
End Sub
#End Region
