B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Payload As Object)
#Event: Opened
#Event: Closed
#Event: Back (Tag As Object)

#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|primary|secondary|accent|neutral|info|success|warning|error, Description: Daisy variant for coloring
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Navbar background color (0 = theme base-100/variant)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Navbar text color (0 = theme base-content/variant)
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: sm, List: none|sm|md|lg|xl|2xl, Description: Shadow level
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: theme|none|sm|rounded|md|lg|xl|2xl|3xl|full, Description: Corner radius style
#DesignerProperty: Key: Glass, DisplayName: Glass, FieldType: Boolean, DefaultValue: False, Description: Enable glass effect
#DesignerProperty: Key: GlassSize, DisplayName: Glass Size, FieldType: String, DefaultValue: none, List: none|glass-xs|glass-sm|glass-md|glass-lg|glass-xl|glass-2xl, Description: Glass opacity scale; overrides Glass when not none
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 8, Description: Internal padding in dip
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 20rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-64, Description: Tailwind size token or CSS size (eg h-64, 4rem, 80px)
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: , Description: Navbar title text
#DesignerProperty: Key: TitlePosition, DisplayName: Title Position, FieldType: String, DefaultValue: start, List: start|center|end, Description: Title position in navbar
#DesignerProperty: Key: TitleVisible, DisplayName: Title Visible, FieldType: Boolean, DefaultValue: True, Description: Show/hide the title
#DesignerProperty: Key: HamburgerVisible, DisplayName: Hamburger Visible, FieldType: Boolean, DefaultValue: False, Description: Show hamburger menu button
#DesignerProperty: Key: HamburgerSize, DisplayName: Hamburger Size, FieldType: Int, DefaultValue: 48, Description: Size of the hamburger menu button in dip
#DesignerProperty: Key: BackVisible, DisplayName: Back Visible, FieldType: Boolean, DefaultValue: False, Description: Show a back button in the start slot
#DesignerProperty: Key: BackSize, DisplayName: Back Size, FieldType: Int, DefaultValue: 48, Description: Size of the back button in dip
#DesignerProperty: Key: BackLabel, DisplayName: Back Label, FieldType: String, DefaultValue: , Description: Label text on the back button; leave empty for icon-only
#DesignerProperty: Key: BackNudge, DisplayName: Back Nudge, FieldType: Int, DefaultValue: 10, Description: Left-offset in dip for the back button (nudges start slot left)
#DesignerProperty: Key: LogoImage, DisplayName: Logo Image, FieldType: String, DefaultValue: , Description: Path to the logo image
#DesignerProperty: Key: LogoWidth, DisplayName: Logo Width, FieldType: Int, DefaultValue: 32, Description: Logo width in dip
#DesignerProperty: Key: LogoHeight, DisplayName: Logo Height, FieldType: Int, DefaultValue: 32, Description: Logo height in dip
#DesignerProperty: Key: LogoMask, DisplayName: Logo Mask, FieldType: String, DefaultValue: none, List: none|mask-circle|mask-squircle|mask-heart|mask-hexagon|mask-decagon|mask-pentagon|mask-diamond|mask-square, Description: Logo mask shape
#DesignerProperty: Key: LogoVisible, DisplayName: Logo Visible, FieldType: Boolean, DefaultValue: True, Description: Show/hide the logo
#DesignerProperty: Key: LogoPosition, DisplayName: Logo Position, FieldType: String, DefaultValue: start, List: start|center|end, Description: Logo slot position

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' Typed Internal Variables (m + b/s/c/i)
	Private msVariant As String = "none"
	Private mcBackgroundColor As Int = 0
	Private mcTextColor As Int = 0
	Private msShadow As String = "sm"
	Private msRounded As String = "none"
	Private mbGlass As Boolean = False
	Private msGlassSize As String = "none"
	Private miPadding As Int = 8dip

	Private msWidth As String = "full"
	Private msHeight As String = "h-64"
	Private mWidthDip As Float = 100%x
	Private mHeightDip As Float = 64dip

	' Internal Panels
	Private Surface As B4XView
	Private mStartSlot As B4XView
	Private mCenterSlot As B4XView
	Private mEndSlot As B4XView
	
	' Standardization fields
	Private VariantPalette As Map
	
	' Measurement fields
	Private cvsMeasure As B4XCanvas
	Private pnlMeasure As B4XView
	Private mbCvsMeasureInitialized As Boolean = False

	' Title fields
	Private msTitle As String = ""
	Private msTitlePosition As String = "start"
	Private mbTitleVisible As Boolean = True
	Private mTitleLabel As B4XView
	Private msTitleSlot As String = "start"

	' Back button fields
	Private mbBackVisible As Boolean = False
	Private miBackSize As Int = 48dip
	Private msBackLabel As String = ""
	Private miBackNudge As Int = 10dip
	Public BackButton As B4XDaisyButton
	Private mBackView As B4XView

	' Hamburger fields
	Private mbHamburgerVisible As Boolean = False
	Private miHamburgerSize As Int = 48dip
	Private mHamburgerSwap As B4XDaisySwap
	Private mHamburgerView As B4XView

	' Logo fields
	Private msLogoImage As String = ""
	Private miLogoWidth As Int = 32dip
	Private miLogoHeight As Int = 32dip
	Private msLogoMask As String = "none"
	Private mbLogoVisible As Boolean = True
	Public LogoAvatar As B4XDaisyAvatar
	Private mLogoView As B4XView
	Private msLogoPosition As String = "start"
	Private mFabLastCreated As B4XDaisyFab
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' Create Surface for styling
	Dim pSurface As Panel
	pSurface.Initialize("surface")
	Surface = pSurface
	Surface.Color = xui.Color_Transparent
	mBase.AddView(Surface, 0, 0, mBase.Width, mBase.Height)

	' Create Slot Panels
	mStartSlot = CreateSlotPanel("start")
	mCenterSlot = CreateSlotPanel("center")
	mEndSlot = CreateSlotPanel("end")
	Surface.AddView(mStartSlot, 0, 0, 1dip, 1dip)
	Surface.AddView(mEndSlot, 0, 0, 1dip, 1dip)
	Surface.AddView(mCenterSlot, 0, 0, 1dip, 1dip)

	' Measurement canvas
	Dim p As Panel
	p.Initialize("")
	pnlMeasure = p
	mBase.AddView(pnlMeasure, 0, 0, 100dip, 100dip)
	pnlMeasure.Visible = False
	cvsMeasure.Initialize(pnlMeasure)
	mbCvsMeasureInitialized = True
	'
	
	' Grab children from the original Base panel that were added in the designer
	GrabDesignerChildren
	
	ApplyDesignerProps(mProps)
	
	' Back and Hamburger are mutually exclusive - back takes priority.
	If mbBackVisible Then
		mbHamburgerVisible = False
		CreateBackView
	Else If mbHamburgerVisible Then
		CreateHamburgerView(miHamburgerSize)
	End If
	
	' Create Logo if specified
	If msLogoImage.Length > 0 Then
		CreateLogoView
	End If
	
	' Create title from designer properties if set
	If msTitle.Length > 0 Then
		CreateTitleFromDesigner
	End If
	
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub CreateSlotPanel(sTag As String) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim v As B4XView = p
	v.Color = xui.Color_Transparent
	v.Tag = sTag
	Return v
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
	mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
	mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
	msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
	msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", msRounded))
	mbGlass = B4XDaisyVariants.GetPropBool(mProps, "Glass", mbGlass)
	msGlassSize = B4XDaisyVariants.GetPropString(mProps, "GlassSize", msGlassSize)
	miPadding = B4XDaisyVariants.GetPropInt(mProps, "Padding", miPadding / 1dip) * 1dip
	
	msWidth = B4XDaisyVariants.GetPropString(mProps, "Width", msWidth)
	msHeight = B4XDaisyVariants.GetPropString(mProps, "Height", msHeight)
	mWidthDip = B4XDaisyVariants.TailwindSizeToDip(msWidth, 100%x)
	mHeightDip = B4XDaisyVariants.TailwindSizeToDip(msHeight, 64dip)
	
	msTitle = B4XDaisyVariants.GetPropString(mProps, "Title", msTitle)
	msTitlePosition = B4XDaisyVariants.GetPropString(mProps, "TitlePosition", msTitlePosition).ToLowerCase.Trim
	mbTitleVisible = B4XDaisyVariants.GetPropBool(mProps, "TitleVisible", mbTitleVisible)
	msTitleSlot = msTitlePosition
	
	mbHamburgerVisible = B4XDaisyVariants.GetPropBool(mProps, "HamburgerVisible", mbHamburgerVisible)
	miHamburgerSize = B4XDaisyVariants.GetPropInt(mProps, "HamburgerSize", miHamburgerSize / 1dip) * 1dip

	mbBackVisible = B4XDaisyVariants.GetPropBool(mProps, "BackVisible", mbBackVisible)
	miBackSize = B4XDaisyVariants.GetPropInt(mProps, "BackSize", miBackSize / 1dip) * 1dip
	msBackLabel = B4XDaisyVariants.GetPropString(mProps, "BackLabel", msBackLabel)
	miBackNudge = B4XDaisyVariants.GetPropInt(mProps, "BackNudge", miBackNudge / 1dip) * 1dip

	msLogoImage = B4XDaisyVariants.GetPropString(mProps, "LogoImage", msLogoImage)
	miLogoWidth = B4XDaisyVariants.GetPropInt(mProps, "LogoWidth", miLogoWidth / 1dip) * 1dip
	miLogoHeight = B4XDaisyVariants.GetPropInt(mProps, "LogoHeight", miLogoHeight / 1dip) * 1dip
	msLogoMask = B4XDaisyVariants.GetPropString(mProps, "LogoMask", msLogoMask)
	mbLogoVisible = B4XDaisyVariants.GetPropBool(mProps, "LogoVisible", mbLogoVisible)
	msLogoPosition = B4XDaisyVariants.GetPropString(mProps, "LogoPosition", msLogoPosition).ToLowerCase.Trim
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Variant", msVariant)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("TextColor", mcTextColor)
	props.Put("Shadow", msShadow)
	props.Put("Rounded", msRounded)
	props.Put("Glass", mbGlass)
	props.Put("GlassSize", msGlassSize)
	props.Put("Padding", miPadding / 1dip)
	props.Put("Title", msTitle)
	props.Put("TitlePosition", msTitlePosition)
	props.Put("TitleVisible", mbTitleVisible)
	props.Put("HamburgerVisible", mbHamburgerVisible)
	props.Put("HamburgerSize", miHamburgerSize / 1dip)
	props.Put("BackVisible", mbBackVisible)
	props.Put("BackSize", miBackSize / 1dip)
	props.Put("BackLabel", msBackLabel)
	props.Put("BackNudge", miBackNudge / 1dip)
	props.Put("LogoImage", msLogoImage)
	props.Put("LogoWidth", miLogoWidth / 1dip)
	props.Put("LogoHeight", miLogoHeight / 1dip)
	props.Put("LogoMask", msLogoMask)
	props.Put("LogoVisible", mbLogoVisible)
	props.Put("LogoPosition", msLogoPosition)
	Return props
End Sub

Private Sub CreateTitleFromDesigner
	Dim targetSlot As B4XView
	Dim align As String = "CENTER"
	Select Case msTitlePosition
		Case "start"
			targetSlot = mStartSlot
			align = "LEFT"
		Case "end"
			targetSlot = mEndSlot
			align = "RIGHT"
		Case Else
			targetSlot = mCenterSlot
			align = "CENTER"
	End Select
	AddTitleToSlot(targetSlot, msTitle, align)
	mTitleLabel.Visible = mbTitleVisible
End Sub

Private Sub MoveTitleToSlot(sNewPosition As String)
	If IsViewInitialized(mTitleLabel) = False Then Return
	
	' Remove from current slot
	Dim currentSlot As B4XView
	Select Case msTitleSlot
		Case "start"
			currentSlot = mStartSlot
		Case "end"
			currentSlot = mEndSlot
		Case Else
			currentSlot = mCenterSlot
	End Select
	
	If currentSlot.IsInitialized Then
		mTitleLabel.RemoveViewFromParent
	End If
	
	msTitleSlot = sNewPosition
	Dim align As String = "CENTER"
	If sNewPosition = "start" Then
		align = "LEFT"
	Else If sNewPosition = "end" Then
		align = "RIGHT"
	End If
	mTitleLabel.SetTextAlignment("CENTER", align)
	
	Refresh
End Sub

Private Sub GrabDesignerChildren
	Dim viewsToMove As List
	viewsToMove.Initialize
	For i = 0 To mBase.NumberOfViews - 1
		Dim v As B4XView = mBase.GetView(i)
		' Exclude internal housekeeping panels
		If v = Surface Or v = pnlMeasure Then Continue
		viewsToMove.Add(v)
	Next
	
	For Each v As B4XView In viewsToMove
		Dim slotTag As String = ""
		If v.Tag <> Null And v.Tag Is String Then
			slotTag = v.Tag.As(String).ToLowerCase.Trim
		End If
		
		v.RemoveViewFromParent
		Select Case slotTag
			Case "start"
				mStartSlot.AddView(v, v.Left, v.Top, v.Width, v.Height)
			Case "center"
				mCenterSlot.AddView(v, v.Left, v.Top, v.Width, v.Height)
			Case "end"
				mEndSlot.AddView(v, v.Left, v.Top, v.Width, v.Height)
			Case Else
				mStartSlot.AddView(v, v.Left, v.Top, v.Width, v.Height)
		End Select
	Next
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	
	Surface.SetLayoutAnimated(0, 0, 0, w, h)
	ApplyVisualStyle
	
	LayoutSlots(w, h)
	inResize = False
End Sub

Private Sub LayoutSlots(iWidth As Int, iHeight As Int)
	Dim startW As Int = MeasureSlotContentWidth(mStartSlot)
	Dim endW As Int = MeasureSlotContentWidth(mEndSlot)
	Dim centerW As Int = MeasureSlotContentWidth(mCenterSlot)
	
	Dim padding As Int = miPadding * 2
	Dim availableW As Int = iWidth - padding
	
	' DaisyUI Pattern: .navbar-start and .navbar-end take 50% each if possible
	' .navbar-center takes only what it needs and is centered.
	
	' Balanced side slots
	Dim sideW As Int = Max(0, (availableW - centerW) / 2)
	
	' We use Max(startW, sideW) to ensure slots are at least sideW wide for centering centerW.
	Dim finalStartW As Int = Max(startW, sideW)
	Dim finalEndW As Int = Max(endW, sideW)
	
	' Pin Start to left padding ? nudge left when back button is visible
	Dim startLeft As Int = miPadding
	If mbBackVisible Then startLeft = startLeft - miBackNudge
	mStartSlot.SetLayoutAnimated(0, startLeft, 0, finalStartW, iHeight)
	LayoutSlotFill(mStartSlot, "LEFT")
	
	' Pin End to right padding
	mEndSlot.SetLayoutAnimated(0, iWidth - finalEndW - miPadding, 0, finalEndW, iHeight)
	LayoutSlotFill(mEndSlot, "RIGHT")
	
	' Center stays exactly in the middle
	mCenterSlot.SetLayoutAnimated(0, (iWidth - centerW) / 2, 0, centerW, iHeight)
	LayoutSlotFill(mCenterSlot, "CENTER")
End Sub

Private Sub LayoutSlotFill(vSlot As B4XView, sAlignment As String)
	If vSlot.NumberOfViews = 0 Then Return
	Dim slotW As Int = vSlot.Width
	Dim slotH As Int = vSlot.Height
	Dim gap As Int = 8dip
	Dim align As String = sAlignment.ToUpperCase.Trim
	
	Select Case align
		Case "RIGHT", "END"
			Dim totalContentW As Int = 0
			For i = 0 To vSlot.NumberOfViews - 1
				totalContentW = totalContentW + vSlot.GetView(i).Width + gap
			Next
			totalContentW = totalContentW - gap
			
			Dim cursorX As Int = slotW - totalContentW
			For i = 0 To vSlot.NumberOfViews - 1
				Dim v As B4XView = vSlot.GetView(i)
				v.SetLayoutAnimated(0, cursorX, (slotH - v.Height) / 2, v.Width, v.Height)
				cursorX = cursorX + v.Width + gap
			Next
		Case "CENTER", "MIDDLE"
			Dim totalContentW As Int = 0
			For i = 0 To vSlot.NumberOfViews - 1
				totalContentW = totalContentW + vSlot.GetView(i).Width + gap
			Next
			totalContentW = totalContentW - gap
			
			Dim cursorX As Int = (slotW - totalContentW) / 2
			For i = 0 To vSlot.NumberOfViews - 1
				Dim v As B4XView = vSlot.GetView(i)
				v.SetLayoutAnimated(0, cursorX, (slotH - v.Height) / 2, v.Width, v.Height)
				cursorX = cursorX + v.Width + gap
			Next
		Case Else ' LEFT / START
			Dim totalContentW As Int = 0
			For i = 0 To vSlot.NumberOfViews - 1
				totalContentW = totalContentW + vSlot.GetView(i).Width + gap
			Next
			totalContentW = totalContentW - gap
			
			' For LEFT, we start at 0 but we could just use cursorX for consistency
			Dim cursorX As Int = 0
			For i = 0 To vSlot.NumberOfViews - 1
				Dim v As B4XView = vSlot.GetView(i)
				Dim viewW As Int = v.Width
				If IsViewInitialized(mTitleLabel) And v = mTitleLabel And (msTitleSlot = "start" Or msTitleSlot = "left") Then
					viewW = Max(viewW, slotW - cursorX)
				End If
				v.SetLayoutAnimated(0, cursorX, (slotH - v.Height) / 2, viewW, v.Height)
				cursorX = cursorX + viewW + gap
			Next
	End Select
End Sub

Private Sub MeasureSlotContentWidth(vSlot As B4XView) As Int
	Dim totalW As Int = 0
	Dim gap As Int = 8dip
	For i = 0 To vSlot.NumberOfViews - 1
		Dim v As B4XView = vSlot.GetView(i)
		totalW = totalW + v.Width + gap
	Next
	If totalW > 0 Then totalW = totalW - gap
	Return Max(1dip, totalW)
End Sub

Private Sub GetActualView(vView As B4XView) As B4XView
	Return vView
End Sub

Private Sub ApplyVisualStyle
	InitializePalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim bgBase100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim fgBaseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))
	
	Dim bg As Int = bgBase100
	Dim fg As Int = fgBaseContent
	
	If msVariant <> "none" Then
		bg = B4XDaisyVariants.ResolveVariantColor(VariantPalette, msVariant, "back", bg)
		fg = B4XDaisyVariants.ResolveVariantColor(VariantPalette, msVariant, "text", fg)
	End If
	
	If mcBackgroundColor <> 0 Then bg = mcBackgroundColor
	If mcTextColor <> 0 Then fg = mcTextColor
	
	If mbGlass Or msGlassSize <> "none" Then
		Dim effectiveSize As String = IIf(msGlassSize <> "none", msGlassSize, "glass-md")
		Dim glassSpec As Map = B4XDaisyVariants.GetGlassSpecForSize(effectiveSize)
		Dim opacity As Float = glassSpec.GetDefault("opacity", 0.3)
		bg = B4XDaisyVariants.SetAlpha(bg, opacity * 255)
	End If
	
	Dim radiusDip As Float = B4XDaisyVariants.ResolveRoundedDip(msRounded, 0)
	Surface.SetColorAndBorder(bg, 0, 0, radiusDip)
	
	ApplyElevation
	SetTextColorRecursive(mStartSlot, fg)
	SetTextColorRecursive(mCenterSlot, fg)
	SetTextColorRecursive(mEndSlot, fg)
End Sub

Private Sub ApplyElevation
	B4XDaisyVariants.ApplyElevation(Surface, msShadow)
End Sub

Private Sub SetTextColorRecursive(vParent As B4XView, iColor As Int)
	If vParent.IsInitialized = False Then Return
	Dim numViews As Int = 0
	Try
		numViews = vParent.NumberOfViews
	Catch
		Return ' Not a container
	End Try
	
	For i = 0 To numViews - 1
		Dim v As B4XView = vParent.GetView(i)
		Try
			If v Is Label Then
				v.TextColor = iColor
			Else
				Dim bHandled As Boolean = False
				If v.Tag <> Null Then
					If (v.Tag Is String) = False Then
						If xui.SubExists(v.Tag, "setTextColor", 1) Then
							' If the child component exposes getVariant and has a non-default
							' variant, it manages its own text color - do not override it.
							Dim bSkipColor As Boolean = False
							If xui.SubExists(v.Tag, "getVariant", 0) Then
								Dim compVariant As String = CallSub(v.Tag, "getVariant")
								compVariant = compVariant.Trim.ToLowerCase
								If compVariant <> "" And compVariant <> "none" And compVariant <> "default" Then
									bSkipColor = True
								End If
							End If
							If bSkipColor = False Then
								CallSub2(v.Tag, "setTextColor", iColor)
							End If
						End If
					End If
				End If
			End If
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyNavbar.SetTextColorRecursive: " & LastException.Message)
			' Not a Label - skip
		End Try
	Next
End Sub

'-
' Public Section API
'-

Public Sub GetStartPanel As B4XView
	Return mStartSlot
End Sub

Public Sub GetCenterPanel As B4XView
	Return mCenterSlot
End Sub

Public Sub GetEndPanel As B4XView
	Return mEndSlot
End Sub

Public Sub AddViewToStart(vView As B4XView, iWidth As Int, iHeight As Int)
	vView.RemoveViewFromParent
	mStartSlot.AddView(vView, 0, (mHeightDip - iHeight) / 2, iWidth, iHeight)
	Refresh
End Sub

Public Sub AddViewToCenter(vView As B4XView, iWidth As Int, iHeight As Int)
	vView.RemoveViewFromParent
	mCenterSlot.AddView(vView, 0, (mHeightDip - iHeight) / 2, iWidth, iHeight)
	Refresh
End Sub

Public Sub AddViewToEnd(vView As B4XView, iWidth As Int, iHeight As Int)
	vView.RemoveViewFromParent
	mEndSlot.AddView(vView, 0, (mHeightDip - iHeight) / 2, iWidth, iHeight)
	Refresh
End Sub

' Clears all views from the start slot, including system items (back, hamburger, logo, title)
' that belong to that slot. Resets tracked state for each removed system item.
Public Sub ClearStartSlot
	' Reset system-item state for start slot
	If mbBackVisible And IsViewInitialized(mBackView) Then
		RemoveBackView
		mbBackVisible = False
	End If
	If mbHamburgerVisible And IsViewInitialized(mHamburgerView) Then
		RemoveHamburgerView
		mbHamburgerVisible = False
	End If
	If msLogoImage.Length > 0 And IsViewInitialized(mLogoView) And (msLogoPosition = "start" Or msLogoPosition = "left") Then
		RemoveLogoView
		msLogoImage = ""
	End If
	If msTitle.Length > 0 And IsViewInitialized(mTitleLabel) And (msTitleSlot = "start" Or msTitleSlot = "left") Then
		mTitleLabel.RemoveViewFromParent
		Dim emptyTL As B4XView
		mTitleLabel = emptyTL
		msTitle = ""
	End If
	' Remove any remaining custom views from the start slot
	For i = mStartSlot.NumberOfViews - 1 To 0 Step -1
		mStartSlot.GetView(i).RemoveViewFromParent
	Next
	Refresh
End Sub

' Clears all views from the center slot, including system items (logo, title)
' that belong to that slot. Resets tracked state for each removed system item.
Public Sub ClearCenterSlot
	' Reset system-item state for center slot
	If msLogoImage.Length > 0 And IsViewInitialized(mLogoView) And msLogoPosition = "center" Then
		RemoveLogoView
		msLogoImage = ""
	End If
	If msTitle.Length > 0 And IsViewInitialized(mTitleLabel) And msTitleSlot = "center" Then
		mTitleLabel.RemoveViewFromParent
		Dim emptyTL As B4XView
		mTitleLabel = emptyTL
		msTitle = ""
	End If
	' Remove any remaining custom views from the center slot
	For i = mCenterSlot.NumberOfViews - 1 To 0 Step -1
		mCenterSlot.GetView(i).RemoveViewFromParent
	Next
	Refresh
End Sub

' Clears all views from the end slot, including system items (logo, title)
' that belong to that slot. Resets tracked state for each removed system item.
Public Sub ClearEndSlot
	' Reset system-item state for end slot
	If msLogoImage.Length > 0 And IsViewInitialized(mLogoView) And (msLogoPosition = "end" Or msLogoPosition = "right") Then
		RemoveLogoView
		msLogoImage = ""
	End If
	If msTitle.Length > 0 And IsViewInitialized(mTitleLabel) And (msTitleSlot = "end" Or msTitleSlot = "right") Then
		mTitleLabel.RemoveViewFromParent
		Dim emptyTL As B4XView
		mTitleLabel = emptyTL
		msTitle = ""
	End If
	' Remove any remaining custom views from the end slot
	For i = mEndSlot.NumberOfViews - 1 To 0 Step -1
		mEndSlot.GetView(i).RemoveViewFromParent
	Next
	Refresh
End Sub

Public Sub AddTitleToCenter(sTitle As String)
	msTitlePosition = "center"
	msTitleSlot = "center"
	AddTitleToSlot(mCenterSlot, sTitle, "CENTER")
End Sub

Public Sub AddTitleToStart(sTitle As String)
	msTitlePosition = "start"
	msTitleSlot = "start"
	AddTitleToSlot(mStartSlot, sTitle, "LEFT")
End Sub

Public Sub AddTitleToEnd(sTitle As String)
	msTitlePosition = "end"
	msTitleSlot = "end"
	AddTitleToSlot(mEndSlot, sTitle, "RIGHT")
End Sub

Private Sub AddTitleToSlot(vSlot As B4XView, sTitle As String, sAlign As String)
	If vSlot.IsInitialized = False Then
		msTitle = sTitle
		Return
	End If
	
	If IsViewInitialized(mTitleLabel) Then
		mTitleLabel.RemoveViewFromParent
	End If

	Dim lbl As Label
	lbl.Initialize("")
	lbl.SingleLine = True
	Dim xl As B4XView = lbl
	xl.Text = sTitle
	xl.SetTextAlignment("CENTER", sAlign)
	
	Dim fontSize As Float = 16
	Dim fnt As B4XFont = xui.CreateDefaultBoldFont(fontSize)
	xl.Font = fnt
	
	Dim tw As Int = MeasureTextWidthDip(sTitle, fnt)
	xl.Width = tw
	xl.Height = 40dip
	
	' Store reference to title label for runtime updates
	mTitleLabel = xl
	msTitle = sTitle
	
	Refresh
End Sub

' Programmatically shows the back button in the start slot.
' SizeDip: height/width for icon-only; height when label is given.
' Label: empty string = icon-only ghost circle; non-empty = icon + text ghost button.
Public Sub AddBackButton(iSizeDip As Int, sLabel As String)
	mbBackVisible = True
	miBackSize = iSizeDip
	msBackLabel = sLabel
	CreateBackView
End Sub

Private Sub CreateBackView
	RemoveBackView
	
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "BackBtn")
	btn.setStyle("ghost")
	btn.setIconName("chevron-left-solid.svg")
	
	Dim hasLabel As Boolean = msBackLabel.Trim.Length > 0
	
	If hasLabel = False Then
		' Icon-only: circle ghost button
		btn.setCircle(True)
		btn.setText("")
		btn.AddToParent(mStartSlot, -2, 0, miBackSize, miBackSize)
	Else
		' Icon + text: regular ghost button - pass 1dip so button auto-sizes to content
		btn.setText(msBackLabel)
		btn.AddToParent(mStartSlot, -2, 0, 1dip, miBackSize)
	End If
	
	BackButton = btn
	mBackView = btn.mBase
	
	Refresh
End Sub

Private Sub RemoveBackView
	If IsViewInitialized(mBackView) Then
		mBackView.RemoveViewFromParent
	End If
	Dim emptyBtn As B4XDaisyButton
	BackButton = emptyBtn
	Dim emptyView As B4XView
	mBackView = emptyView
	Refresh
End Sub

' Internal click handler for the back button; fires EventName_Back on the callback.
Public Sub BackBtn_Click(oTag As Object)
	If xui.SubExists(mCallBack, mEventName & "_Back", 1) Then
		CallSub2(mCallBack, mEventName & "_Back", oTag)
	Else If xui.SubExists(mCallBack, mEventName & "_Back", 0) Then
		CallSub(mCallBack, mEventName & "_Back")
	End If
End Sub

' Adds a hamburger menu (swap component) to the start slot.
' Fires Opened/Closed events when toggled.
Public Sub AddHamburger(iSizeDip As Int)
	mbHamburgerVisible = True
	miHamburgerSize = iSizeDip
	CreateHamburgerView(miHamburgerSize)
End Sub

Private Sub CreateHamburgerView(iSize As Int)
	RemoveHamburgerView
	
	Dim sw As B4XDaisySwap
	sw.Initialize(Me, "Hamburger")
	mHamburgerSwap = sw
	
	Dim swView As B4XView = sw.CreateView(iSize, iSize)
	sw.SwapType = "svg"
	sw.OnText = "xmark-solid.svg"
	sw.OffText = "bars-solid.svg"
	swView.Tag = mHamburgerSwap
	mHamburgerView = swView
	
	Refresh
End Sub

Private Sub RemoveHamburgerView
	If IsViewInitialized(mHamburgerView) Then
		mHamburgerView.RemoveViewFromParent
	End If
	Dim emptySwap As B4XDaisySwap
	mHamburgerSwap = emptySwap
	Dim emptyView As B4XView
	mHamburgerView = emptyView
	
	Refresh
End Sub

Private Sub CreateLogoView
	RemoveLogoView
	
	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "LogoAvatar")
	LogoAvatar = av
	
	Dim avView As B4XView = av.CreateView(miLogoWidth, miLogoHeight)
	av.Mask = msLogoMask
	av.Avatar = msLogoImage
	av.AvatarSize = miLogoWidth & "px"
	
	Dim pnlClick As Panel
	pnlClick.Initialize("LogoClick")
	Dim xClick As B4XView = pnlClick
	xClick.Color = xui.Color_Transparent
	xClick.AddView(avView, 0, 0, miLogoWidth, miLogoHeight)
	xClick.Tag = LogoAvatar
	mLogoView = xClick
	
	Refresh
End Sub

Private Sub RemoveLogoView
	If IsViewInitialized(mLogoView) Then
		mLogoView.RemoveViewFromParent
	End If
	Dim emptyAvatar As B4XDaisyAvatar
	LogoAvatar = emptyAvatar
	Dim emptyView As B4XView
	mLogoView = emptyView
End Sub

Private Sub RebuildSlot(vSlot As B4XView, sSlotName As String)
	If vSlot.IsInitialized = False Then Return
	
	Dim customViews As List
	customViews.Initialize
	
	' 1. Extract custom views safely
	For i = 0 To vSlot.NumberOfViews - 1
		Dim v As B4XView = vSlot.GetView(i)
		Dim isSystem As Boolean = False
		
		' Safely compare using B4XView references to prevent NullPointerException
		If IsViewInitialized(mBackView) And v = mBackView Then
			isSystem = True
		End If
		
		If IsViewInitialized(mHamburgerView) And v = mHamburgerView Then
			isSystem = True
		End If
		
		If IsViewInitialized(mLogoView) And v = mLogoView Then
			isSystem = True
		End If
		
		If IsViewInitialized(mTitleLabel) And v = mTitleLabel Then
			isSystem = True
		End If
		
		If isSystem = False Then
			customViews.Add(v)
		End If
	Next
	
	' 2. Clear all views
	For i = vSlot.NumberOfViews - 1 To 0 Step -1
		vSlot.GetView(i).RemoveViewFromParent
	Next
	
	' 3. Re-add system views in correct order
	If sSlotName = "start" Then
		' Back and Hamburger are mutually exclusive - only one appears in the start slot.
		If mbBackVisible And IsViewInitialized(mBackView) Then
			vSlot.AddView(mBackView, 0, 0, mBackView.Width, mBackView.Height)
		Else If mbHamburgerVisible And IsViewInitialized(mHamburgerView) Then
			vSlot.AddView(mHamburgerView, 0, 0, miHamburgerSize, miHamburgerSize)
		End If
		If mbLogoVisible And msLogoImage.Length > 0 And IsViewInitialized(mLogoView) And (msLogoPosition = "start" Or msLogoPosition = "left") Then
			vSlot.AddView(mLogoView, 0, 0, miLogoWidth, miLogoHeight)
		End If
		If mbTitleVisible And msTitle.Length > 0 And IsViewInitialized(mTitleLabel) And (msTitleSlot = "start" Or msTitleSlot = "left") Then
			vSlot.AddView(mTitleLabel, 0, 0, mTitleLabel.Width, mTitleLabel.Height)
		End If
	Else If sSlotName = "center" Then
		' Order: Logo -> Title
		If mbLogoVisible And msLogoImage.Length > 0 And IsViewInitialized(mLogoView) And msLogoPosition = "center" Then
			vSlot.AddView(mLogoView, 0, 0, miLogoWidth, miLogoHeight)
		End If
		If mbTitleVisible And msTitle.Length > 0 And IsViewInitialized(mTitleLabel) And msTitleSlot = "center" Then
			vSlot.AddView(mTitleLabel, 0, 0, mTitleLabel.Width, mTitleLabel.Height)
		End If
	Else If sSlotName = "end" Then
		' Order: Title -> Logo
		If mbTitleVisible And msTitle.Length > 0 And IsViewInitialized(mTitleLabel) And (msTitleSlot = "end" Or msTitleSlot = "right") Then
			vSlot.AddView(mTitleLabel, 0, 0, mTitleLabel.Width, mTitleLabel.Height)
		End If
		If mbLogoVisible And msLogoImage.Length > 0 And IsViewInitialized(mLogoView) And (msLogoPosition = "end" Or msLogoPosition = "right") Then
			vSlot.AddView(mLogoView, 0, 0, miLogoWidth, miLogoHeight)
		End If
	End If
	
	' 4. Re-add custom views
	For Each v As B4XView In customViews
		vSlot.AddView(v, v.Left, v.Top, v.Width, v.Height)
	Next
End Sub

' Internal handler for hamburger toggle
Public Sub Hamburger_Changed(sState As String, bChecked As Boolean)
	If bChecked Then
		If xui.SubExists(mCallBack, mEventName & "_Opened", 0) Then
			CallSub(mCallBack, mEventName & "_Opened")
		End If
	Else
		If xui.SubExists(mCallBack, mEventName & "_Closed", 0) Then
			CallSub(mCallBack, mEventName & "_Closed")
		End If
	End If
End Sub

Private Sub IconClick_Click
	Dim p As B4XView = Sender
	Dim eventName As String = p.Tag
	If eventName <> "" Then
		If xui.SubExists(mCallBack, eventName & "_Click", 1) Then
			CallSub2(mCallBack, eventName & "_Click", p.Tag)
		Else If xui.SubExists(mCallBack, eventName & "_Click", 0) Then
			CallSub(mCallBack, eventName & "_Click")
		End If
	End If
End Sub

Private Sub LogoClick_Click
	If xui.SubExists(mCallBack, mEventName & "_LogoClick", 1) Then
		CallSub2(mCallBack, mEventName & "_LogoClick", mBase.Tag)
	Else If xui.SubExists(mCallBack, mEventName & "_LogoClick", 0) Then
		CallSub(mCallBack, mEventName & "_LogoClick")
	Else If xui.SubExists(mCallBack, mEventName & "_Logo_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Logo_Click", mBase.Tag)
	Else If xui.SubExists(mCallBack, mEventName & "_Logo_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Logo_Click")
	End If
End Sub

Public Sub LogoAvatar_Click
	LogoClick_Click
End Sub

' Adds a logo (avatar component) to the start slot.
Public Sub AddLogo(sImagePath As String, iWidthDip As Int, iHeightDip As Int, sMask As String) As B4XDaisyAvatar
	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "LogoAvatar")
	Dim avView As B4XView = av.CreateView(iWidthDip, iHeightDip)
	av.Mask = sMask
	av.Avatar = sImagePath
	av.AvatarSize = iWidthDip & "px"
	
	AddViewToStart(avView, iWidthDip, iHeightDip)
	Return av
End Sub

Private Sub MeasureTextWidthDip(sText As String, fntFont As B4XFont) As Int
	Dim t As String = sText
	If t = Null Or t.Trim.Length = 0 Then Return 16dip
	If mbCvsMeasureInitialized = False Then
		' Fallback estimator: average character width (approx 0.6 * Font.Size * length)
		Dim estimatedWidth As Float = t.Trim.Length * fntFont.Size * 0.6
		Return Ceil(estimatedWidth) * 1dip + 24dip
	End If
	Dim r As B4XRect = cvsMeasure.MeasureText(t.Trim, fntFont)
	Return Ceil(r.Width) + 24dip ' Increased buffer to avoid clipping and allow padding
End Sub

Public Sub AddAvatarToEnd(sID As String, sImagePath As String, iSizeDip As Int, sMask As String) As B4XDaisyAvatar
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Avatar ID cannot be blank in AddAvatarToEnd")
		Return Null
	End If
	Return AddAvatarToSlot(mEndSlot, sImagePath, iSizeDip, sMask, sID)
End Sub

Public Sub AddAvatarToStart(sID As String, sImagePath As String, iSizeDip As Int, sMask As String) As B4XDaisyAvatar
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Avatar ID cannot be blank in AddAvatarToStart")
		Return Null
	End If
	Return AddAvatarToSlot(mStartSlot, sImagePath, iSizeDip, sMask, sID)
End Sub

Private Sub AddAvatarToSlot(vSlot As B4XView, sImagePath As String, iSizeDip As Int, sMask As String, sEventName As String) As B4XDaisyAvatar
	Dim av As B4XDaisyAvatar
	av.Initialize(mCallBack, sEventName)
	av.setTag(sEventName)
	' CreateView returns mBase, which handles internal layout
	Dim avView As B4XView = av.CreateView(iSizeDip, iSizeDip)
	av.SetImage(sImagePath)
	av.Mask = sMask
	If sEventName <> "" Then
		Dim pnlClick As Panel
		pnlClick.Initialize("IconClick")
		Dim xClick As B4XView = pnlClick
		xClick.Color = xui.Color_Transparent
		xClick.AddView(avView, 0, 0, iSizeDip, iSizeDip)
		xClick.Tag = sEventName
		vSlot.AddView(xClick, 0, 0, iSizeDip, iSizeDip)
	Else
		vSlot.AddView(avView, 0, 0, iSizeDip, iSizeDip)
	End If
	Refresh
	Return av
End Sub

Public Sub AddSVGIconToEnd(sID As String, sAssetPath As String, iSizeDip As Int, iColor As Int) As B4XDaisySvgIcon
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: SVG Icon ID cannot be blank in AddSVGIconToEnd")
		Return Null
	End If
	Return AddSVGIconToSlot(mEndSlot, sAssetPath, iSizeDip, iColor, sID)
End Sub

Public Sub AddSVGIconToStart(sID As String, sAssetPath As String, iSizeDip As Int, iColor As Int) As B4XDaisySvgIcon
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: SVG Icon ID cannot be blank in AddSVGIconToStart")
		Return Null
	End If
	Return AddSVGIconToSlot(mStartSlot, sAssetPath, iSizeDip, iColor, sID)
End Sub

Private Sub AddSVGIconToSlot(vSlot As B4XView, sAssetPath As String, iSizeDip As Int, iColor As Int, sEventName As String) As B4XDaisySvgIcon
	Dim icon As B4XDaisySvgIcon
	icon.Initialize(mCallBack, sEventName)
	Dim iconView As B4XView = icon.CreateView(iSizeDip, iSizeDip)
	icon.SvgAsset = sAssetPath
	icon.Color = iColor
	If sEventName <> "" Then
		Dim pnlClick As Panel
		pnlClick.Initialize("IconClick")
		Dim xClick As B4XView = pnlClick
		xClick.Color = xui.Color_Transparent
		xClick.AddView(iconView, 0, 0, iSizeDip, iSizeDip)
		xClick.Tag = sEventName
		vSlot.AddView(xClick, 0, 0, iSizeDip, iSizeDip)
	Else
		vSlot.AddView(iconView, 0, 0, iSizeDip, iSizeDip)
	End If
	Refresh
	Return icon
End Sub

Public Sub AddButtonIconToStart(sID As String, iSizeDip As Int, sIcon As String, iColor As Int, bGhost As Boolean) As B4XDaisyButton
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Button ID cannot be blank in AddButtonIconToStart")
		Return Null
	End If
	Return AddButtonIconToSlot(mStartSlot, sIcon, iSizeDip, iColor, bGhost, sID)
End Sub

Public Sub AddButtonIconToEnd(sID As String, iSizeDip As Int, sIcon As String, iColor As Int, bGhost As Boolean) As B4XDaisyButton
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Button ID cannot be blank in AddButtonIconToEnd")
		Return Null
	End If
	Return AddButtonIconToSlot(mEndSlot, sIcon, iSizeDip, iColor, bGhost, sID)
End Sub

Public Sub AddButtonIconToCenter(sID As String, iSizeDip As Int, sIcon As String, iColor As Int, bGhost As Boolean) As B4XDaisyButton
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Button ID cannot be blank in AddButtonIconToCenter")
		Return Null
	End If
	Return AddButtonIconToSlot(mCenterSlot, sIcon, iSizeDip, iColor, bGhost, sID)
End Sub

Private Sub AddButtonIconToSlot(vSlot As B4XView, sIcon As String, iSizeDip As Int, iColor As Int, bGhost As Boolean, sEventName As String) As B4XDaisyButton
	Dim btn As B4XDaisyButton
	btn.Initialize(mCallBack, sEventName)
	btn.setCircle(True)
	btn.setIconName(sIcon)
	btn.setIconColor(iColor)
	btn.setText("")
	If bGhost Then
		btn.setStyle("ghost")
	Else
		btn.setStyle("solid")
	End If
	btn.AddToParent(vSlot, 0, 0, iSizeDip, iSizeDip)
	btn.setTag(sEventName)
	btn.BringToFront
	Refresh
	Return btn
End Sub

' Adds a text button to the start slot.
' ID         ? unique event name prefix (fires ID_Click on callback)
' ButtonText ? label shown on the button
' Variant    ? DaisyUI color variant (none|primary|secondary|accent|neutral|info|success|warning|error)
' WidthDip   ? button width in dip
' HeightDip  ? button height in dip
' Ghost      ? True = ghost style, False = solid style
Public Sub AddButtonToStart(sID As String, sButtonText As String, sVariant As String, iWidthDip As Int, iHeightDip As Int, bGhost As Boolean) As B4XDaisyButton
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Button ID cannot be blank in AddButtonToStart")
		Return Null
	End If
	Return AddButtonToSlot(mStartSlot, sButtonText, sVariant, iWidthDip, iHeightDip, bGhost, sID)
End Sub

' Adds a text button to the center slot.
Public Sub AddButtonToCenter(sID As String, sButtonText As String, sVariant As String, iWidthDip As Int, iHeightDip As Int, bGhost As Boolean) As B4XDaisyButton
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Button ID cannot be blank in AddButtonToCenter")
		Return Null
	End If
	Return AddButtonToSlot(mCenterSlot, sButtonText, sVariant, iWidthDip, iHeightDip, bGhost, sID)
End Sub

' Adds a text button to the end slot.
Public Sub AddButtonToEnd(sID As String, sButtonText As String, sVariant As String, iWidthDip As Int, iHeightDip As Int, bGhost As Boolean) As B4XDaisyButton
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: Button ID cannot be blank in AddButtonToEnd")
		Return Null
	End If
	Return AddButtonToSlot(mEndSlot, sButtonText, sVariant, iWidthDip, iHeightDip, bGhost, sID)
End Sub

' Internal: creates a text button in any slot.
Private Sub AddButtonToSlot(vSlot As B4XView, sButtonText As String, sVariant As String, iWidthDip As Int, iHeightDip As Int, bGhost As Boolean, sEventName As String) As B4XDaisyButton
	Dim btn As B4XDaisyButton
	btn.Initialize(mCallBack, sEventName)
	btn.Text = sButtonText
	btn.Variant = sVariant
	If bGhost Then
		btn.setStyle("ghost")
	Else
		btn.setStyle("solid")
	End If
	btn.AddToParent(vSlot, 0, 0, iWidthDip, iHeightDip)
	btn.setTag(sEventName)
	Refresh
	Return btn
End Sub

' Adds a FAB anchored to the end slot of the navbar.
' The FAB is added to OverlayHost (typically the page Root) so its expandable overlay
' can extend beyond the navbar bounds.
' ID         - unique event name prefix (fires ID_Click, ID_ActionClick, etc.)
' OverlayHost - the parent view for the FAB and its overlay (usually the page Root)
' SizeDip    - FAB trigger size in dip (e.g. 56dip)
' Returns the configured B4XDaisyFab instance. Set trigger/actions/close on the returned object.
Public Sub AddFabToEnd(sID As String, vOverlayHost As B4XView, iSizeDip As Int) As B4XDaisyFab
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: FAB ID cannot be blank in AddFabToEnd")
		Return Null
	End If
	Return AddFabToSlot(mEndSlot, sID, vOverlayHost, iSizeDip, "end")
End Sub

' Adds a FAB anchored to the start slot of the navbar.
Public Sub AddFabToStart(sID As String, vOverlayHost As B4XView, iSizeDip As Int) As B4XDaisyFab
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: FAB ID cannot be blank in AddFabToStart")
		Return Null
	End If
	Return AddFabToSlot(mStartSlot, sID, vOverlayHost, iSizeDip, "start")
End Sub

' Adds a FAB anchored to the center slot of the navbar.
Public Sub AddFabToCenter(sID As String, vOverlayHost As B4XView, iSizeDip As Int) As B4XDaisyFab
	If sID.Trim = "" Then
		If B4XDaisyApp.DebugLogs Then Log("ERROR: FAB ID cannot be blank in AddFabToCenter")
		Return Null
	End If
	Return AddFabToSlot(mCenterSlot, sID, vOverlayHost, iSizeDip, "center")
End Sub

' Internal: creates a FAB anchored to a navbar slot panel.
' AnchorView is set to Slot, PlacementMode to "anchored", Direction to "bottom",
' OnEdge to True, and OverlayHost is configured before AddToParent so
' DesignerCreateView has all required references.
Private Sub AddFabToSlot(vSlot As B4XView, sID As String, vOverlayHost As B4XView, iSizeDip As Int, sAlignment As String) As B4XDaisyFab
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
	Dim fab As B4XDaisyFab
	fab.Initialize(mCallBack, sID)
	fab.PlacementMode = "anchored"
	fab.Direction = "bottom"
	fab.AnchorAlignment = sAlignment
	fab.OnEdge = True
	fab.AnchorView = vSlot
	fab.OverlayHost = vOverlayHost
	fab.AddToParent(vOverlayHost, 0, 0, iSizeDip, iSizeDip)
	Refresh
	' Bring FAB to front AFTER navbar Refresh to ensure it stays above
	' any parent views (e.g. ScrollView) that may re-layout during Refresh.
	fab.BringToFront
	
	' Store the FAB so we can reposition it after the layout cycle completes.
	mFabLastCreated = fab
	CallSubDelayed(Me, "RepositionFabAfterLayout")
	
	Return fab
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	B4XDaisyVariants.DisableClipping(mBase)
	If mBase.Parent.IsInitialized Then B4XDaisyVariants.DisableClipping(mBase.Parent)
	B4XDaisyVariants.DisableClipping(Surface)
	B4XDaisyVariants.DisableClipping(mStartSlot)
	B4XDaisyVariants.DisableClipping(mCenterSlot)
	B4XDaisyVariants.DisableClipping(mEndSlot)
	RebuildSlot(mStartSlot, "start")
	RebuildSlot(mCenterSlot, "center")
	RebuildSlot(mEndSlot, "end")
	Base_Resize(mBase.Width, mBase.Height)
End Sub

' Repositions the last FAB created by AddFabToEnd/Start/Center after the layout
' cycle completes, ensuring anchor coordinates are accurate.
Private Sub RepositionFabAfterLayout
	If mFabLastCreated <> Null Then
		Try
			mFabLastCreated.Refresh
			mFabLastCreated.BringToFront
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyNavbar.RepositionFabAfterLayout: " & LastException.Message)
		End Try
	End If
	mFabLastCreated = Null
End Sub

Private Sub InitializePalette
	VariantPalette = B4XDaisyVariants.GetVariantPalette
End Sub

Private Sub ResolveColorValue(oValue As Object, iDefaultColor As Int) As Int
	If oValue = Null Then Return iDefaultColor
	If IsNumber(oValue) Then Return oValue
	Dim s As String = "" & oValue
	s = s.Trim
	If s.Length = 0 Then Return iDefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, iDefaultColor)
	Return iDefaultColor
End Sub

Private Sub IsViewInitialized(vView As B4XView) As Boolean
	If vView = Null Then Return False
	Return vView.IsInitialized
End Sub

'-
' Standard B4X API Adapters
'-

Public Sub setVariant(sValue As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
	Return msVariant
End Sub

Public Sub setRounded(sValue As String)
	msRounded = B4XDaisyVariants.NormalizeRounded(sValue)
	Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub setShadow(sValue As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	Refresh
End Sub

Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setGlass(bValue As Boolean)
	mbGlass = bValue
	Refresh
End Sub

Public Sub getGlass As Boolean
	Return mbGlass
End Sub

Public Sub setGlassSize(sValue As String)
	msGlassSize = sValue
	Refresh
End Sub

Public Sub getGlassSize As String
	Return msGlassSize
End Sub

Public Sub setPadding(iValue As Int)
	miPadding = Max(0, iValue) * 1dip
	Refresh
End Sub

Public Sub getPadding As Int
	Return miPadding / 1dip
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setLogoImage(sValue As String)
	msLogoImage = sValue
	If mBase.IsInitialized = False Then Return
	If msLogoImage.Length > 0 Then
		CreateLogoView
	Else
		RemoveLogoView
		Refresh
	End If
End Sub

Public Sub getLogoImage As String
	Return msLogoImage
End Sub

Public Sub setLogoWidth(iValue As Int)
	miLogoWidth = iValue * 1dip
	If mBase.IsInitialized = False Then Return
	If msLogoImage.Length > 0 Then
		CreateLogoView
	End If
End Sub

Public Sub getLogoWidth As Int
	Return miLogoWidth / 1dip
End Sub

Public Sub setLogoHeight(iValue As Int)
	miLogoHeight = iValue * 1dip
	If mBase.IsInitialized = False Then Return
	If msLogoImage.Length > 0 Then
		CreateLogoView
	End If
End Sub

Public Sub getLogoHeight As Int
	Return miLogoHeight / 1dip
End Sub

Public Sub setLogoMask(sValue As String)
	msLogoMask = sValue
	If mBase.IsInitialized = False Then Return
	If IsViewInitialized(mLogoView) Then
		LogoAvatar.Mask = sValue
		Refresh
	End If
End Sub

Public Sub getLogoMask As String
	Return msLogoMask
End Sub

Public Sub setLogoVisible(bValue As Boolean)
	mbLogoVisible = bValue
	If mBase.IsInitialized = False Then Return
	If IsViewInitialized(mLogoView) Then
		mLogoView.Visible = bValue
		Refresh
	End If
End Sub

Public Sub getLogoVisible As Boolean
	Return mbLogoVisible
End Sub

Public Sub setLogoPosition(sValue As String)
	Dim newPos As String = sValue.ToLowerCase.Trim
	If newPos = msLogoPosition Then Return
	msLogoPosition = newPos
	If mBase.IsInitialized = False Then Return
	If IsViewInitialized(mLogoView) Then
		Refresh
	End If
End Sub

Public Sub getLogoPosition As String
	Return msLogoPosition
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mcBackgroundColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
	mcTextColor = iValue
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mcTextColor
End Sub

Public Sub setTitle(sValue As String)
	msTitle = sValue
	Dim targetSlot As B4XView
	Dim align As String = "CENTER"
	Select Case msTitlePosition
		Case "start"
			targetSlot = mStartSlot
			align = "LEFT"
		Case "end"
			targetSlot = mEndSlot
			align = "RIGHT"
		Case Else
			targetSlot = mCenterSlot
			align = "CENTER"
	End Select
	AddTitleToSlot(targetSlot, msTitle, align)
	If IsViewInitialized(mTitleLabel) Then
		mTitleLabel.Visible = mbTitleVisible
	End If
End Sub

Public Sub getTitle As String
	Return msTitle
End Sub

Public Sub setTitlePosition(sValue As String)
	Dim newPos As String = sValue.ToLowerCase.Trim
	If newPos = msTitlePosition Then Return
	
	msTitlePosition = newPos
	msTitleSlot = newPos
	
	If IsViewInitialized(mTitleLabel) Then
		MoveTitleToSlot(newPos)
		Refresh
	End If
End Sub

Public Sub getTitlePosition As String
	Return msTitlePosition
End Sub

Public Sub setTitleVisible(bValue As Boolean)
	mbTitleVisible = bValue
	If IsViewInitialized(mTitleLabel) Then
		mTitleLabel.Visible = bValue
		Refresh
	End If
End Sub

Public Sub getTitleVisible As Boolean
	Return mbTitleVisible
End Sub

Public Sub setHamburgerVisible(bValue As Boolean)
	mbHamburgerVisible = bValue
	If mBase.IsInitialized = False Then Return
	If mbHamburgerVisible Then
		' Mutually exclusive with back button
		If mbBackVisible Then
			mbBackVisible = False
			RemoveBackView
		End If
		CreateHamburgerView(miHamburgerSize)
	Else
		RemoveHamburgerView
	End If
End Sub

Public Sub getHamburgerVisible As Boolean
	Return mbHamburgerVisible
End Sub

Public Sub setHamburgerSize(iValue As Int)
	miHamburgerSize = iValue * 1dip
	If mBase.IsInitialized = False Then Return
	If mbHamburgerVisible Then
		CreateHamburgerView(miHamburgerSize)
	End If
End Sub

Public Sub getHamburgerSize As Int
	Return miHamburgerSize / 1dip
End Sub

' Programmatically toggles the hamburger menu icon
Public Sub ToggleHamburger
	If mbHamburgerVisible And mHamburgerSwap.IsInitialized Then
		mHamburgerSwap.Toggle
	End If
End Sub

' Programmatically sets the hamburger toggle checked state (True = open / X icon, False = closed / bars icon)
Public Sub setHamburgerChecked(bValue As Boolean)
	If mbHamburgerVisible And mHamburgerSwap.IsInitialized Then
		mHamburgerSwap.Checked = bValue
	End If
End Sub

Public Sub getHamburgerChecked As Boolean
	If mbHamburgerVisible And mHamburgerSwap.IsInitialized Then
		Return mHamburgerSwap.Checked
	End If
	Return False
End Sub

' Exposes the internal B4XDaisySwap instance for the hamburger icon
Public Sub getHamburgerSwap As B4XDaisySwap
	Return mHamburgerSwap
End Sub

Public Sub setBackVisible(bValue As Boolean)
	mbBackVisible = bValue
	If mBase.IsInitialized = False Then Return
	If mbBackVisible Then
		' Mutually exclusive with hamburger
		If mbHamburgerVisible Then
			mbHamburgerVisible = False
			RemoveHamburgerView
		End If
		If IsViewInitialized(mBackView) = False Then
			CreateBackView
		Else
			Refresh
		End If
	Else
		RemoveBackView
	End If
End Sub

Public Sub getBackVisible As Boolean
	Return mbBackVisible
End Sub

Public Sub setBackSize(iValue As Int)
	miBackSize = iValue * 1dip
	If mBase.IsInitialized = False Then Return
	If mbBackVisible And IsViewInitialized(mBackView) Then
		CreateBackView
	End If
End Sub

Public Sub getBackSize As Int
	Return miBackSize / 1dip
End Sub

Public Sub setBackLabel(sValue As String)
	If msBackLabel = sValue Then Return
	msBackLabel = sValue
	If mBase.IsInitialized = False Then Return
	If mbBackVisible Then
		CreateBackView
	End If
End Sub

Public Sub getBackLabel As String
	Return msBackLabel
End Sub

Public Sub setBackNudge(iValue As Int)
	miBackNudge = Max(0, iValue) * 1dip
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackNudge As Int
	Return miBackNudge / 1dip
End Sub

Public Sub setBackgroundColorVariant(sVariantName As String)
	InitializePalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim bgBase100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(VariantPalette, sVariantName, bgBase100)
	setBackgroundColor(c)
End Sub

Public Sub setTextColorVariant(sVariantName As String)
	InitializePalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim fgBaseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(VariantPalette, sVariantName, fgBaseContent)
	setTextColor(c)
End Sub

Public Sub setWidth(oValue As Object)
	msWidth = "" & oValue
	mWidthDip = B4XDaisyVariants.TailwindSizeToDip(msWidth, 100%x)
	If mBase.IsInitialized Then
		mBase.Width = mWidthDip
		Refresh
	End If
End Sub

Public Sub getWidth As Float
	Return mWidthDip
End Sub

Public Sub setHeight(oValue As Object)
	msHeight = "" & oValue
	mHeightDip = B4XDaisyVariants.TailwindSizeToDip(msHeight, 64dip)
	If mBase.IsInitialized Then
		mBase.Height = mHeightDip
		Refresh
	End If
End Sub

Public Sub getHeight As Float
	Return mHeightDip
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		mBase = p
		mBase.Color = xui.Color_Transparent
		mBase.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
		Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
		DesignerCreateView(mBase, Null, props)
	Else
		Base_Resize(Max(1dip, iWidth), Max(1dip, iHeight))
	End If
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		mBase = p
		mBase.Color = xui.Color_Transparent
		vParent.AddView(mBase, iLeft, iTop, w, h)
		Dim props As Map = BuildRuntimeProps(w, h)
		DesignerCreateView(mBase, Null, props)
	Else
		mBase.RemoveViewFromParent
		vParent.AddView(mBase, iLeft, iTop, w, h)
		Base_Resize(w, h)
	End If
	Return mBase
End Sub


''' <summary>
''' Moves this navbar to the bottom of its parent's stacking order so sibling
''' views render on top of it.
''' </summary>
Public Sub SendToBack
	If mBase.IsInitialized And mBase.Parent.IsInitialized Then mBase.SendToBack
End Sub

''' <summary>
''' Moves this navbar to the top of its parent's stacking order so it renders
''' above its siblings.
''' </summary>
Public Sub BringToFront
	If mBase.IsInitialized And mBase.Parent.IsInitialized Then mBase.BringToFront
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
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

#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub setVisible(bValue As Boolean)
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub

Public Sub getVisible As Boolean
	If mBase.IsInitialized Then Return mBase.Visible
	Return False
End Sub

#End Region
