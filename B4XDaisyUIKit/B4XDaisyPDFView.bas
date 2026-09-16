B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#Event: LoadComplete (Pages As Int)
#Event: PageChanged (Page As Int, TotalPages As Int)
#Event: OnTap (Target As Object)
#Event: InitiallyRendered (Page As Int)
#Event: PageNum (Page As Int)
#Event: Show ()

#DesignerProperty: Key: AutoSpacing, DisplayName: Auto Spacing, FieldType: Boolean, DefaultValue: True, Description: Automatically space PDF pages.
#DesignerProperty: Key: EnableSwipe, DisplayName: Enable Swipe, FieldType: Boolean, DefaultValue: True, Description: Allow swipe gestures to turn pages.
#DesignerProperty: Key: PageSnap, DisplayName: Page Snap, FieldType: Boolean, DefaultValue: True, Description: Snap pages into view when swiping.
#DesignerProperty: Key: SwipeHorizontal, DisplayName: Swipe Horizontal, FieldType: Boolean, DefaultValue: False, Description: Scroll horizontally instead of vertically.
#DesignerProperty: Key: ShowToolbar, DisplayName: Show Toolbar, FieldType: Boolean, DefaultValue: True, Description: Show bottom navigation toolbar.
#DesignerProperty: Key: ToolbarHeight, DisplayName: Toolbar Height, FieldType: Int, DefaultValue: 48, Description: Height of navigation toolbar in dip.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	' Inner UI Elements
	Private pnlPdfHost As B4XView
	Private pnlToolbar As B4XView
	#If B4A
	Private mPdfCore As PdfiumCore
	Private mPdfView As PDFView
	#End If

	Private btnFirst As B4XDaisyIconButton
	Private btnPrev As B4XDaisyIconButton
	Private lblPages As B4XDaisyText
	Private btnNext As B4XDaisyIconButton
	Private btnLast As B4XDaisyIconButton

	' Properties
	Private mbAutoSpacing As Boolean = True
	Private mbEnableSwipe As Boolean = True
	Private mbPageSnap As Boolean = True
	Private mbSwipeHorizontal As Boolean = False
	Private mbShowToolbar As Boolean = True
	Private miToolbarHeight As Int = 48dip

	' Internal State
	Private miCurrentPage As Int = 0
	Private miTotalPages As Int = 0
	Private msCurrentDir As String = ""
	Private msCurrentFile As String = ""
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me

	ApplyDesignerProps(mProps)
	BuildUI
End Sub

Private Sub ApplyDesignerProps (mProps As Map)
	If mProps.IsInitialized = False Then Return
	mbAutoSpacing = B4XDaisyVariants.GetPropBool(mProps, "AutoSpacing", mbAutoSpacing)
	mbEnableSwipe = B4XDaisyVariants.GetPropBool(mProps, "EnableSwipe", mbEnableSwipe)
	mbPageSnap = B4XDaisyVariants.GetPropBool(mProps, "PageSnap", mbPageSnap)
	mbSwipeHorizontal = B4XDaisyVariants.GetPropBool(mProps, "SwipeHorizontal", mbSwipeHorizontal)
	mbShowToolbar = B4XDaisyVariants.GetPropBool(mProps, "ShowToolbar", mbShowToolbar)
	miToolbarHeight = Max(32dip, B4XDaisyVariants.GetPropInt(mProps, "ToolbarHeight", miToolbarHeight / 1dip) * 1dip)
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If vParent.IsInitialized = False Then Return
	Dim w As Int = Max(10dip, iWidth)
	Dim h As Int = Max(10dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim dummy As Label
	Dim props As Map
	props.Initialize
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
End Sub

Private Sub BuildUI
	mBase.RemoveAllViews
	
	' 1. PDF Host Panel
	Dim pPdf As Panel
	pPdf.Initialize("pnlPdfHost")
	pnlPdfHost = pPdf
	pnlPdfHost.Color = xui.Color_Transparent
	mBase.AddView(pnlPdfHost, 0, 0, mBase.Width, mBase.Height)

	#If B4A
	mPdfCore.Initialize("PDFium")
	mPdfView.Initialize("PDFium")
	pnlPdfHost.AddView(mPdfView, 0, 0, pnlPdfHost.Width, pnlPdfHost.Height)
	#End If

	' 2. Toolbar Panel
	Dim pTool As Panel
	pTool.Initialize("")
	pnlToolbar = pTool
	pnlToolbar.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
	mBase.AddView(pnlToolbar, 0, 0, mBase.Width, miToolbarHeight)

	' Navigation Buttons (Using B4XDaisyIconButton) & Page Label
	btnFirst.Initialize(Me, "btnFirst")
	btnFirst.IconAsset = "angles-left-solid.svg"
	btnFirst.Style = "ghost"
	btnFirst.Size = "md"
	btnFirst.AddToParent(pnlToolbar, 0, 0, 38dip, 36dip)

	btnPrev.Initialize(Me, "btnPrev")
	btnPrev.IconAsset = "chevron-left-solid.svg"
	btnPrev.Style = "ghost"
	btnPrev.Size = "md"
	btnPrev.AddToParent(pnlToolbar, 0, 0, 38dip, 36dip)

	lblPages.Initialize(Me, "lblPages")
	lblPages.AddToParent(pnlToolbar, 0, 0, 80dip, 36dip)
	lblPages.Text = "0 / 0"
	lblPages.HAlign = "CENTER"
	lblPages.VAlign = "CENTER"
	lblPages.TextSize = 14
	lblPages.FontBold = True

	btnNext.Initialize(Me, "btnNext")
	btnNext.IconAsset = "chevron-right-solid.svg"
	btnNext.Style = "ghost"
	btnNext.Size = "md"
	btnNext.AddToParent(pnlToolbar, 0, 0, 38dip, 36dip)

	btnLast.Initialize(Me, "btnLast")
	btnLast.IconAsset = "angles-right-solid.svg"
	btnLast.Style = "ghost"
	btnLast.Size = "md"
	btnLast.AddToParent(pnlToolbar, 0, 0, 38dip, 36dip)

	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize (iWidth As Int, iHeight As Int)
	If iWidth <= 0 Or iHeight <= 0 Then Return
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, iWidth, iHeight)

	Dim tbHeight As Int = 0
	If mbShowToolbar Then tbHeight = miToolbarHeight
	pnlToolbar.Visible = mbShowToolbar

	' Size PDF container
	Dim pdfH As Int = Max(10dip, iHeight - tbHeight)
	pnlPdfHost.SetLayoutAnimated(0, 0, 0, iWidth, pdfH)
	#If B4A
	If mPdfView.IsInitialized Then
		mPdfView.SetLayoutAnimated(0, 0, 0, iWidth, pdfH)
	End If
	#End If

	' Layout Toolbar Controls
	If mbShowToolbar Then
		pnlToolbar.SetLayoutAnimated(0, 0, iHeight - tbHeight, iWidth, tbHeight)
		Dim btnW As Int = 38dip
		Dim btnH As Int = 36dip
		Dim topY As Int = (tbHeight - btnH) / 2
		Dim pad As Int = 8dip
		
		btnFirst.mBase.SetLayoutAnimated(0, pad, topY, btnW, btnH)
		btnPrev.mBase.SetLayoutAnimated(0, pad + btnW + 4dip, topY, btnW, btnH)

		Dim rightEdge As Int = iWidth - pad
		btnLast.mBase.SetLayoutAnimated(0, rightEdge - btnW, topY, btnW, btnH)
		btnNext.mBase.SetLayoutAnimated(0, rightEdge - (btnW * 2) - 4dip, topY, btnW, btnH)

		Dim lblL As Int = pad + (btnW * 2) + 8dip
		Dim lblW As Int = Max(10dip, (rightEdge - (btnW * 2) - 4dip) - lblL)
		lblPages.mBase.SetLayoutAnimated(0, lblL, topY, lblW, btnH)
	End If
End Sub

' Load PDF file from local storage directory
Public Sub LoadFile(sDir As String, sFileName As String)
	msCurrentDir = sDir
	msCurrentFile = sFileName
	#If B4A
	If mPdfView.IsInitialized Then
		Dim cfg As Configurator = mPdfView.fromFile(sDir, sFileName)
		cfg.SetEventname("PDFium")
		cfg.autoSpacing(mbAutoSpacing)
		cfg.enableSwipe(mbEnableSwipe)
		cfg.pageSnap(mbPageSnap)
		cfg.swipeHorizontal(mbSwipeHorizontal)
		cfg.addOnErrorListener
		cfg.addOnLoadCompleteListener
		cfg.addOnPageChangeListener
		cfg.addOnPageErrorListener
		cfg.addOnTapListener
		cfg.load
	End If
	#End If
End Sub

' Load PDF file from File.DirAssets (automatically copies to xui.DefaultFolder)
Public Sub LoadAsset(sFileName As String)
	If File.Exists(File.DirAssets, sFileName) Then
		File.Copy(File.DirAssets, sFileName, xui.DefaultFolder, sFileName)
		LoadFile(xui.DefaultFolder, sFileName)
	Else
		If B4XDaisyApp.DebugLogs Then Log("PDF asset file not found: " & sFileName)
	End If
End Sub

' Reload the current PDF document
Public Sub Reload
	If msCurrentDir.Length > 0 And msCurrentFile.Length > 0 Then
		LoadFile(msCurrentDir, msCurrentFile)
	End If
End Sub

' Jump to 0-based page index
Public Sub JumpToPage(iPage As Int)
	If iPage < 0 Or iPage >= miTotalPages Then Return
	miCurrentPage = iPage
	#If B4A
	If mPdfView.IsInitialized Then
		mPdfView.jumpTo2(iPage, False)
	End If
	#End If
	UpdatePageLabel
End Sub

Public Sub FirstPage
	JumpToPage(0)
End Sub

Public Sub PrevPage
	JumpToPage(miCurrentPage - 1)
End Sub

Public Sub NextPage
	JumpToPage(miCurrentPage + 1)
End Sub

Public Sub LastPage
	JumpToPage(miTotalPages - 1)
End Sub

' Property getters & setters
Public Sub getCurrentPage As Int
	Return miCurrentPage
End Sub

Public Sub getTotalPages As Int
	Return miTotalPages
End Sub

Public Sub setAutoSpacing(bValue As Boolean)
	mbAutoSpacing = bValue
End Sub

Public Sub setEnableSwipe(bValue As Boolean)
	mbEnableSwipe = bValue
End Sub

Public Sub setPageSnap(bValue As Boolean)
	mbPageSnap = bValue
End Sub

Public Sub setSwipeHorizontal(bValue As Boolean)
	mbSwipeHorizontal = bValue
End Sub

Public Sub setShowToolbar(bValue As Boolean)
	mbShowToolbar = bValue
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub UpdatePageLabel
	If miTotalPages > 0 Then
		lblPages.Text = $"${miCurrentPage + 1} / ${miTotalPages}"$
	Else
		lblPages.Text = "0 / 0"
	End If
End Sub

#If B4A
Private Sub PDFium_loadComplete(iPages As Int)
	miTotalPages = iPages
	miCurrentPage = 0
	UpdatePageLabel
	If xui.SubExists(mCallBack, mEventName & "_LoadComplete", 1) Then
		CallSub2(mCallBack, mEventName & "_LoadComplete", iPages)
	End If
End Sub

Private Sub PDFium_onPageChanged(iPage As Int, iTotalPages As Int)
	miCurrentPage = iPage
	If iTotalPages > 0 Then miTotalPages = iTotalPages
	UpdatePageLabel
	If xui.SubExists(mCallBack, mEventName & "_PageChanged", 2) Then
		CallSub3(mCallBack, mEventName & "_PageChanged", iPage, miTotalPages)
	End If
End Sub

Private Sub PDFium_OnTap(oO As Object)
	If xui.SubExists(mCallBack, mEventName & "_OnTap", 1) Then
		CallSub2(mCallBack, mEventName & "_OnTap", oO)
	End If
End Sub

Private Sub PDFium_onInitiallyRendered(iPage As Int)
	If xui.SubExists(mCallBack, mEventName & "_InitiallyRendered", 1) Then
		CallSub2(mCallBack, mEventName & "_InitiallyRendered", iPage)
	End If
End Sub

Private Sub PDFium_PageNum(iPage As Int)
	If xui.SubExists(mCallBack, mEventName & "_PageNum", 1) Then
		CallSub2(mCallBack, mEventName & "_PageNum", iPage)
	End If
End Sub

Private Sub PDFium_Show()
	If xui.SubExists(mCallBack, mEventName & "_Show", 0) Then
		CallSub(mCallBack, mEventName & "_Show")
	End If
End Sub

Private Sub pnlPdfHost_Touch (iAction As Int, fX As Float, fY As Float)
	B4XDaisyVariants.RequestDisallowParentIntercept(mBase, iAction)
End Sub


#End If

' Event handlers for toolbar buttons
Private Sub btnFirst_Click (oTag As Object)
	FirstPage
End Sub

Private Sub btnPrev_Click (oTag As Object)
	PrevPage
End Sub

Private Sub btnNext_Click (oTag As Object)
	NextPage
End Sub

Private Sub btnLast_Click (oTag As Object)
	LastPage
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

#Region Base Properties
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

Public Sub setLeft(iValue As Int)
	If mBase.IsInitialized Then mBase.Left = iValue
End Sub

Public Sub getLeft As Int
	If mBase.IsInitialized Then Return mBase.Left
	Return 0
End Sub

Public Sub setTop(iValue As Int)
	If mBase.IsInitialized Then mBase.Top = iValue
End Sub

Public Sub getTop As Int
	If mBase.IsInitialized Then Return mBase.Top
	Return 0
End Sub

Public Sub setWidth(iValue As Int)
	If mBase.IsInitialized Then mBase.Width = iValue
End Sub

Public Sub getWidth As Int
	If mBase.IsInitialized Then Return mBase.Width
	Return 0
End Sub

Public Sub setHeight(iValue As Int)
	If mBase.IsInitialized Then mBase.Height = iValue
End Sub

Public Sub getHeight As Int
	If mBase.IsInitialized Then Return mBase.Height
	Return 0
End Sub

Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub

Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub

Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub
#End Region
