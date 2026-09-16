B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
' B4XDaisySegment
' Emulates the Ionic v8 iOS Segment & Segment Button component styling specs
#IgnoreWarnings:12,9

#Region Events
#Event: Changed (Value As String)
#End Region

#Region Designer Properties
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Background theme variant or custom color.
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Active button text/icon theme variant color.
#DesignerProperty: Key: ButtonLayout, DisplayName: Button Layout, FieldType: String, DefaultValue: icon-start, List: icon-start|icon-end|icon-top|icon-bottom|label-hide|icon-hide, Description: The layout position of icon relative to label.
#DesignerProperty: Key: Scrollable, DisplayName: Scrollable Segment, FieldType: Boolean, DefaultValue: False, Description: Enables horizontal scrolling for buttons.
#DesignerProperty: Key: ButtonSize, DisplayName: Button Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Button size (xs, sm, md, lg, xl).
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: md, List: none|sm|md|lg|xl|2xl|3xl|full, Description: Container corner radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Drop shadow elevation level.
#DesignerProperty: Key: Disabled, DisplayName: Disabled, FieldType: Boolean, DefaultValue: False, Description: Blocks interactions with the control.
#End Region

Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Public mBase As B4XView
	Private mTag As Object

	' iOS Layout Constants
	Private Const mMode As String = "ios"
	Private Const IOS_INSET_TOP As Int = 2dip
	Private Const IOS_INSET_HEIGHT_REDUCTION As Int = 4dip
	Private Const IOS_INDICATOR_RADIUS As Int = 7dip
	Private Const IOS_CONTAINER_RADIUS As Int = 8dip

	' Controller Properties (ion-segment)
	Private mActiveColor As String
	Private mScrollable As Boolean
	Private mDisabled As Boolean
	Private mValue As String
	Private mButtonSize As String
	Private mBackgroundColor As Object
	Private mRounded As String
	Private mShadow As String
	Private mButtonLayout As String

	' Architecture Layers
	Private pnlController As B4XView          ' Maps to ion-segment
	Private svController As HorizontalScrollView        ' Used if Scrollable = True
	Private pnlIndicator As B4XView           ' Maps to ::part(indicator)

	Private mButtons As List                  ' Holds ion-segment-button configs
	Private mDividers As List                 ' iOS thin vertical divider line views

	Type SegmentButtonConfig (Value As String, Text As String, IconPath As String, Layout As String, Disabled As Boolean, ButtonView As B4XView, lblText As Label, svgIcon As B4XDaisySvgIcon, bInitialized As Boolean, MeasuredWidth As Int, HasCustomTextColor As Boolean, CustomTextColor As Int, HasCustomIconColor As Boolean, CustomIconColor As Int, HasCustomButtonColor As Boolean, CustomButtonColor As Int)
	Private inResize As Boolean = False
End Sub

Public Sub Initialize (oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	mButtons.Initialize
	mDividers.Initialize
	mActiveColor = "none"
	mScrollable = False
	mDisabled = False
	mButtonSize = "md"
	mBackgroundColor = "none"
	mRounded = "md"
	mShadow = "none"
	mButtonLayout = "icon-start"
End Sub

Public Sub DesignerCreateView (oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' Parse ion-segment properties
'	mActiveColor = Props.GetDefault("ActiveColor", "none")
'	mScrollable = Props.GetDefault("Scrollable", False)
'	mButtonSize = Props.GetDefault("ButtonSize", "md")
'	mBackgroundColor = Props.GetDefault("BackgroundColor", "none")
'	mDisabled = Props.GetDefault("Disabled", False)
'	mRounded = B4XDaisyVariants.NormalizeRounded(Props.GetDefault("Rounded", "md"))
'	mShadow = B4XDaisyVariants.NormalizeShadow(Props.GetDefault("Shadow", "none"))
'	mButtonLayout = Props.GetDefault("ButtonLayout", "icon-start")
	ApplyDesignerProps(mProps)

	BuildArchitecture
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mActiveColor = B4XDaisyVariants.GetPropString(mProps, "ActiveColor", "none")
	mScrollable = B4XDaisyVariants.GetPropBool(mProps, "Scrollable", False)
	mButtonSize = B4XDaisyVariants.GetPropString(mProps, "ButtonSize", "md")
	mBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "BackgroundColor", "none")
	mDisabled = B4XDaisyVariants.GetPropBool(mProps, "Disabled", False)
	mRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(mProps, "Rounded", "md"))
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", "none"))
	mButtonLayout = B4XDaisyVariants.GetPropString(mProps, "ButtonLayout", "icon-start")
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty

	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		Dim props As Map = BuildRuntimeProps
		DesignerCreateView(p, Null, props)
	End If

	Dim actualHeight As Int = iHeight
	If IsStackedLayout Or iHeight <= 0 Then
		actualHeight = ResolveButtonHeightDip(mButtonSize)
	End If

	vParent.AddView(mBase, iLeft, iTop, iWidth, actualHeight)
	Base_Resize(mBase.Width, actualHeight)
	Return mBase
End Sub

Private Sub BuildArchitecture
	mBase.RemoveAllViews
    
	' 1. The Controller Layer (ion-segment)
	Dim pc As Panel
	pc.Initialize("")
	pnlController = pc
	pnlController.Color = xui.Color_Transparent
    
	' Style base/controller container
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	UpdateContainerStyle(palette)
    
	If mScrollable Then
		Dim hsv As HorizontalScrollView
		hsv.Initialize(0, "svController")
		svController = hsv
		mBase.AddView(svController, 0, 0, mBase.Width, mBase.Height)
		pnlController = svController.Panel
		pnlController.Color = xui.Color_Transparent
	Else
		mBase.AddView(pnlController, 0, 0, mBase.Width, mBase.Height)
	End If
    
	' Selection Indicator (::part(indicator-background))
	Dim pi As Panel
	pi.Initialize("")
	pnlIndicator = pi
	pnlController.AddView(pnlIndicator, 0, 0, 0, 0)
    
	' Add button views of pre-existing buttons to pnlController
	For Each btn As SegmentButtonConfig In mButtons
		pnlController.AddView(btn.ButtonView, 0, 0, 0, mBase.Height)
	Next
End Sub

' Emulates ion-segment-button API with layout, disabled, and ContentId removed
Public Sub AddButton(sValue As String, sText As String, sIconPath As String)
	Dim btn As SegmentButtonConfig
	btn.Initialize
	btn.Value = sValue
	btn.Text = sText
	btn.IconPath = sIconPath
	btn.Layout = mButtonLayout
	btn.Disabled = False
	
	btn.HasCustomTextColor = False
	btn.CustomTextColor = 0
	btn.HasCustomIconColor = False
	btn.CustomIconColor = 0
	btn.HasCustomButtonColor = False
	btn.CustomButtonColor = 0
     
	Dim pBtn As Panel
	pBtn.Initialize("SegmentBtn")
	btn.ButtonView = pBtn
	btn.ButtonView.Tag = sValue
     
	' Initialize Label - registered with click callback to bubble up event clicks
	Dim l As Label
	l.Initialize("SegmentBtn")
	btn.lblText = l
	Dim xl As B4XView = btn.lblText
	xl.Color = xui.Color_Transparent
	xl.TextSize = ResolveFontSizeDip(mButtonSize)
	xl.SetTextAlignment("CENTER", "CENTER")
	xl.Tag = sValue
	pBtn.AddView(xl, 0, 0, 0, 0)
     
	' Initialize SvgIcon with appropriate size
	Dim currentIconSize As Int = ResolveIconSizeDip(mButtonSize)
	Dim svg As B4XDaisySvgIcon
	svg.Initialize(mCallBack, "")
	btn.svgIcon = svg
	Dim xs As B4XView = svg.AddToParent(pBtn, 0, 0, currentIconSize, currentIconSize)
	xs.Tag = sValue
	svg.SetClickable(False)
	svg.SetPreserveOriginalColors(False)
     
	btn.bInitialized = True
	btn.MeasuredWidth = CalculateMeasuredWidth(btn)
     
	mButtons.Add(btn)
	If mBase.IsInitialized And pnlController.IsInitialized Then
		pnlController.AddView(btn.ButtonView, 0, 0, 0, mBase.Height)
		Refresh
	End If
End Sub

' Helper to add icon-only button
Public Sub AddIcon(sValue As String, sIconPath As String)
	AddButton(sValue, "", sIconPath)
End Sub

' Helper to add text-only button
Public Sub AddLabel(sValue As String, sText As String)
	AddButton(sValue, sText, "")
End Sub

' Method to set a custom background color for a specific button
Public Sub SetButtonColor(sValue As String, iColor As Int)
	For Each btn As SegmentButtonConfig In mButtons
		If btn.Value = sValue Then
			btn.HasCustomButtonColor = True
			btn.CustomButtonColor = iColor
			Exit
		End If
	Next
	If mBase.IsInitialized Then Refresh
End Sub

' Method to set a custom text color for a specific button's label
Public Sub SetButtonTextColor(sValue As String, iColor As Int)
	For Each btn As SegmentButtonConfig In mButtons
		If btn.Value = sValue Then
			btn.HasCustomTextColor = True
			btn.CustomTextColor = iColor
			Exit
		End If
	Next
	If mBase.IsInitialized Then Refresh
End Sub

' Method to set a custom icon color for a specific button's SVG
Public Sub SetButtonIconColor(sValue As String, iColor As Int)
	For Each btn As SegmentButtonConfig In mButtons
		If btn.Value = sValue Then
			btn.HasCustomIconColor = True
			btn.CustomIconColor = iColor
			Exit
		End If
	Next
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Enabled = Not(mDisabled)
	mBase.Alpha = IIf(mDisabled, 0.4, 1.0)
    
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
    
	UpdateContainerStyle(palette)
	UpdateControllerHeights
	LayoutButtonsAndScroll
	UpdateSeparatorsAndDividers(palette)
	UpdateIndicatorState
	RefreshButtonStylesOnly
End Sub

Private Sub UpdateContainerStyle(mPalette As Map)
	Dim baseBg As Int = ResolveContainerBgColor(mPalette)
	Dim containerRadius As Int = ResolveRadius
	mBase.SetColorAndBorder(baseBg, 0, 0, containerRadius)
	B4XDaisyVariants.ApplyElevation(mBase, mShadow)
End Sub

Private Sub UpdateControllerHeights
	Dim btnHeight As Int = ResolveButtonHeightDip(mButtonSize)
	mBase.Height = btnHeight
    
	If mScrollable And svController.IsInitialized Then
		svController.Height = btnHeight
		svController.Panel.Height = btnHeight
	Else If pnlController.IsInitialized Then
		pnlController.Height = btnHeight
	End If
End Sub

Private Sub LayoutButtonsAndScroll
	Dim currentX As Int = IOS_INSET_TOP
    
	Dim btnHeight As Int = mBase.Height - IOS_INSET_HEIGHT_REDUCTION
	Dim btnTop As Int = IOS_INSET_TOP
	Dim totalW As Int = mBase.Width - IOS_INSET_HEIGHT_REDUCTION
	Dim btnWidth As Int = totalW / Max(1, mButtons.Size)
    
	For Each btn As SegmentButtonConfig In mButtons
		If mScrollable Then btnWidth = MeasureButtonContent(btn)
		btn.ButtonView.SetLayoutAnimated(0, currentX, btnTop, btnWidth, btnHeight)
		currentX = currentX + btnWidth
        
		LayoutButtonContents(btn, btnWidth, btnHeight)
        
		btn.ButtonView.Enabled = Not(btn.Disabled)
		btn.ButtonView.Alpha = IIf(btn.Disabled, 0.4, 1.0)
	Next
    
	If mScrollable And svController.IsInitialized Then
		svController.Panel.Width = currentX + IOS_INSET_TOP
	End If
End Sub

Private Sub LayoutButtonContents(btn As SegmentButtonConfig, iBtnWidth As Int, iBtnHeight As Int)
	Dim iconVisible As Boolean = (btn.IconPath.Length > 0 And btn.Layout <> "icon-hide")
	Dim labelVisible As Boolean = (btn.Text.Length > 0 And btn.Layout <> "label-hide")
    
	Dim xlbl As B4XView = btn.lblText
	Dim xsvg As B4XView = btn.svgIcon.mBase
    
	xlbl.Visible = labelVisible
	xsvg.Visible = iconVisible
    
	#If B4A
	Dim nativeLabel As Label = xlbl
	nativeLabel.SingleLine = True
	#End If
    
	If iconVisible Then
		btn.svgIcon.SetSvgAsset(btn.IconPath)
	End If
    
	If labelVisible Then
		Dim fSize As Float = ResolveFontSizeDip(mButtonSize)
		xlbl.Text = btn.Text
		If mValue = btn.Value Then
			xlbl.Font = xui.CreateDefaultBoldFont(fSize)
		Else
			xlbl.Font = xui.CreateDefaultFont(fSize)
		End If
	Else
		xlbl.Text = ""
	End If
    
	Dim currentIconSize As Int = ResolveIconSizeDip(mButtonSize)
	Dim spacing As Int = 4dip
    
	If labelVisible And iconVisible Then
		Dim txtH As Int = ResolveTextHeightDip(mButtonSize)
		Select Case btn.Layout
			Case "icon-top"
				Dim totalH As Int = currentIconSize + spacing + txtH
				Dim startY As Int = (iBtnHeight - totalH) / 2
				If startY < 4dip Then startY = 4dip
				xsvg.SetLayoutAnimated(0, (iBtnWidth - currentIconSize) / 2, startY, currentIconSize, currentIconSize)
				xlbl.SetLayoutAnimated(0, 4dip, startY + currentIconSize + spacing, iBtnWidth - 8dip, txtH)
				xlbl.SetTextAlignment("CENTER", "CENTER")
			Case "icon-bottom"
				Dim totalH As Int = currentIconSize + spacing + txtH
				Dim startY As Int = (iBtnHeight - totalH) / 2
				If startY < 4dip Then startY = 4dip
				xlbl.SetLayoutAnimated(0, 4dip, startY, iBtnWidth - 8dip, txtH)
				xsvg.SetLayoutAnimated(0, (iBtnWidth - currentIconSize) / 2, startY + txtH + spacing, currentIconSize, currentIconSize)
				xlbl.SetTextAlignment("CENTER", "CENTER")
			Case "icon-start"
				Dim textW As Int = B4XDaisyVariants.MeasureTextWidthSafe(btn.Text, ResolveFontSizeDip(mButtonSize), Typeface.DEFAULT_BOLD, 0)
				Dim groupW As Int = currentIconSize + spacing + textW
				If groupW > iBtnWidth - 8dip Then groupW = iBtnWidth - 8dip
				Dim startX As Int = (iBtnWidth - groupW) / 2
				xsvg.SetLayoutAnimated(0, startX, (iBtnHeight - currentIconSize) / 2, currentIconSize, currentIconSize)
				xlbl.SetLayoutAnimated(0, startX + currentIconSize + spacing, 0, groupW - currentIconSize - spacing, iBtnHeight)
				xlbl.SetTextAlignment("CENTER", "LEFT")
			Case "icon-end"
				Dim textW As Int = B4XDaisyVariants.MeasureTextWidthSafe(btn.Text, ResolveFontSizeDip(mButtonSize), Typeface.DEFAULT_BOLD, 0)
				Dim groupW As Int = textW + spacing + currentIconSize
				If groupW > iBtnWidth - 8dip Then groupW = iBtnWidth - 8dip
				Dim startX As Int = (iBtnWidth - groupW) / 2
				xlbl.SetLayoutAnimated(0, startX, 0, groupW - currentIconSize - spacing, iBtnHeight)
				xlbl.SetTextAlignment("CENTER", "RIGHT")
				xsvg.SetLayoutAnimated(0, startX + groupW - currentIconSize, (iBtnHeight - currentIconSize) / 2, currentIconSize, currentIconSize)
			Case Else ' Fallback to icon-top
				Dim totalH As Int = currentIconSize + spacing + txtH
				Dim startY As Int = (iBtnHeight - totalH) / 2
				If startY < 4dip Then startY = 4dip
				xsvg.SetLayoutAnimated(0, (iBtnWidth - currentIconSize) / 2, startY, currentIconSize, currentIconSize)
				xlbl.SetLayoutAnimated(0, 4dip, startY + currentIconSize + spacing, iBtnWidth - 8dip, txtH)
				xlbl.SetTextAlignment("CENTER", "CENTER")
		End Select
		btn.svgIcon.Base_Resize(xsvg.Width, xsvg.Height)
	Else If labelVisible Then
		xlbl.SetLayoutAnimated(0, 0, 0, iBtnWidth, iBtnHeight)
		xlbl.SetTextAlignment("CENTER", "CENTER")
	Else If iconVisible Then
		xsvg.SetLayoutAnimated(0, (iBtnWidth - currentIconSize) / 2, (iBtnHeight - currentIconSize) / 2, currentIconSize, currentIconSize)
		btn.svgIcon.Base_Resize(xsvg.Width, xsvg.Height)
	End If
End Sub

Private Sub UpdateSeparatorsAndDividers(mPalette As Map)
	DrawIosDividers
End Sub

Private Sub UpdateIndicatorState
	Dim foundActive As Boolean = False
	For Each btn As SegmentButtonConfig In mButtons
		If mValue = btn.Value Then
			AnimateIndicator(btn.ButtonView.Left, btn.ButtonView.Width)
			foundActive = True
			Exit
		End If
	Next
	pnlIndicator.Visible = foundActive
End Sub

Private Sub SegmentBtn_Click
	If mDisabled Then Return
	Dim v As B4XView = Sender
	Dim clickedValue As String = v.Tag
    
	For Each btn As SegmentButtonConfig In mButtons
		If btn.Value = clickedValue Then
			If btn.Disabled Then Return
			Exit
		End If
	Next
    
	If mValue <> clickedValue Then
		SetValue(clickedValue)
		If xui.SubExists(mCallBack, mEventName & "_Changed", 1) Then
			CallSub2(mCallBack, mEventName & "_Changed", mValue)
		End If
	End If
End Sub

Public Sub SetValue(sNewValue As String)
	mValue = sNewValue
	Refresh
End Sub

Public Sub GetValue As String
	Return mValue
End Sub

Private Sub AnimateIndicator(iLeft As Int, iWidth As Int)
	Dim indRad As Int = Max(0, ResolveRadius - 1dip)
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	Dim indColor As Int = ResolveIndicatorColor(palette)
	pnlIndicator.SetColorAndBorder(indColor, 0, 0, indRad)
	pnlIndicator.SetLayoutAnimated(200, iLeft, IOS_INSET_TOP, iWidth, mBase.Height - IOS_INSET_HEIGHT_REDUCTION)
	pnlIndicator.SendToBack
End Sub

Private Sub MeasureButtonContent(Btn As SegmentButtonConfig) As Int
	Return Btn.MeasuredWidth
End Sub

Private Sub CalculateMeasuredWidth(Btn As SegmentButtonConfig) As Int
	Dim textW As Int = 0
	Dim fSize As Float = ResolveFontSizeDip(mButtonSize)
	If Btn.Text.Length > 0 And Btn.Layout <> "label-hide" Then
		textW = B4XDaisyVariants.MeasureTextWidthSafe(Btn.Text, fSize, Typeface.DEFAULT_BOLD, 0)
	End If
	Dim iconW As Int = 0
	Dim currentIconSize As Int = ResolveIconSizeDip(mButtonSize)
	If Btn.IconPath.Length > 0 And Btn.Layout <> "icon-hide" Then
		iconW = currentIconSize
	End If
    
	Dim spacing As Int = 0
	If textW > 0 And iconW > 0 And (Btn.Layout = "icon-start" Or Btn.Layout = "icon-end") Then
		spacing = 4dip
	End If
    
	If Btn.Layout = "icon-top" Or Btn.Layout = "icon-bottom" Then
		Return Max(textW, iconW) + 32dip
	Else
		Return textW + iconW + spacing + 32dip
	End If
End Sub

Private Sub ResolveTextHeightDip(sSizeToken As String) As Int
	Dim fSize As Float = ResolveFontSizeDip(sSizeToken)
	Return Ceil(fSize * 1.35) * 1dip
End Sub

Private Sub ResolveBase200Color As Int
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	Return B4XDaisyVariants.ResolveVariantColor(palette, "base-200", "back", xui.Color_RGB(229, 231, 235))
End Sub

Private Sub RefreshButtonStylesOnly
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	Dim activeColor As Int = ResolveButtonActiveColor(palette)
	Dim inactiveColor As Int = ResolveButtonInactiveColor(palette)
    
	For Each btn As SegmentButtonConfig In mButtons
		Dim btnColor As Int = inactiveColor
		If mValue = btn.Value Then
			btnColor = activeColor
		End If
        
		If btn.HasCustomTextColor Then
			btn.lblText.TextColor = btn.CustomTextColor
		Else
			btn.lblText.TextColor = btnColor
		End If
		
		If btn.HasCustomIconColor Then
			btn.svgIcon.SetColor(btn.CustomIconColor)
		Else
			btn.svgIcon.SetColor(btnColor)
		End If
		
		If btn.HasCustomButtonColor Then
			btn.ButtonView.Color = btn.CustomButtonColor
		Else
			btn.ButtonView.Color = xui.Color_Transparent
		End If
	Next
End Sub

Private Sub DrawIosDividers
	Dim palette As Map = B4XDaisyVariants.GetVariantPalette
	Dim dividerColor As Int = B4XDaisyVariants.ResolveVariantColor(palette, "base-300", "back", xui.Color_RGB(210, 210, 215))
    
	Dim requiredDividers As Int = Max(0, mButtons.Size - 1)
	' Lazily pre-create divider views if list is smaller
	Do While mDividers.Size < requiredDividers
		Dim divPanel As Panel
		divPanel.Initialize("")
		Dim xdiv As B4XView = divPanel
		xdiv.Visible = False
		pnlController.AddView(xdiv, 0, 0, 0, 0)
		mDividers.Add(xdiv)
	Loop
    
	' Resolve physical button height
	Dim btnHeight As Int = ResolveButtonHeightDip(mButtonSize) - IOS_INSET_HEIGHT_REDUCTION
	Dim divTop As Int = btnHeight * 0.3
	Dim absoluteDivTop As Int = divTop + IOS_INSET_TOP
	Dim divH As Int = btnHeight - (divTop * 2)
	If divH < 2dip Then divH = 2dip
    
	' Update visibility and position
	For i = 0 To mDividers.Size - 1
		Dim xdiv As B4XView = mDividers.Get(i)
		If i < mButtons.Size - 1 Then
			Dim btnLeft As SegmentButtonConfig = mButtons.Get(i)
			Dim btnRight As SegmentButtonConfig = mButtons.Get(i + 1)
			Dim activeAdjacent As Boolean = (mValue = btnLeft.Value Or mValue = btnRight.Value)
            
			If activeAdjacent Then
				xdiv.Visible = False
			Else
				Dim divX As Int = btnLeft.ButtonView.Left + btnLeft.ButtonView.Width
				xdiv.SetLayoutAnimated(0, divX, absoluteDivTop, 1dip, divH)
				xdiv.Color = dividerColor
				xdiv.Visible = True
			End If
		Else
			xdiv.Visible = False
		End If
	Next
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If inResize Then Return
	inResize = True
	If mBase.IsInitialized Then
		Dim actualHeight As Int = dHeight
		If IsStackedLayout Or dHeight <= 0 Then
			actualHeight = ResolveButtonHeightDip(mButtonSize)
		End If
		mBase.Height = actualHeight
		If mScrollable And svController.IsInitialized Then
			svController.SetLayoutAnimated(0, 0, 0, dWidth, actualHeight)
			svController.Panel.Height = actualHeight
		Else
			pnlController.SetLayoutAnimated(0, 0, 0, dWidth, actualHeight)
		End If
		Refresh
	End If
	inResize = False
End Sub

#Region Color Resolvers
Private Sub ResolveContainerBgColor(mPalette As Map) As Int
	If IsNumber(mBackgroundColor) Then
		Dim rawColor As Int = mBackgroundColor
		If rawColor <> 0 Then Return rawColor
	End If
	
	Dim bgStr As String = ""
	If mBackgroundColor <> Null Then bgStr = mBackgroundColor
	
	If bgStr <> "none" And bgStr <> "" Then
		Dim variantColor As Int = B4XDaisyVariants.ResolveVariantColor(mPalette, bgStr, "back", xui.Color_RGB(120, 120, 128))
		Dim r As Int = Bit.And(Bit.ShiftRight(variantColor, 16), 0xFF)
		Dim g As Int = Bit.And(Bit.ShiftRight(variantColor, 8), 0xFF)
		Dim b As Int = Bit.And(variantColor, 0xFF)
		Return xui.Color_ARGB(36, r, g, b)
	Else
		Return ResolveBase200Color
	End If
End Sub

Private Sub ResolveButtonActiveColor(mPalette As Map) As Int
	If mActiveColor <> "none" And mActiveColor <> "" Then
		Return B4XDaisyVariants.ResolveVariantColor(mPalette, mActiveColor, "text", xui.Color_White)
	Else
		Return B4XDaisyVariants.ResolveVariantColor(mPalette, "base-content", "back", xui.Color_RGB(31, 41, 55))
	End If
End Sub

Private Sub ResolveIndicatorColor(mPalette As Map) As Int
	If mActiveColor <> "none" And mActiveColor <> "" Then
		Return B4XDaisyVariants.ResolveVariantColor(mPalette, mActiveColor, "back", xui.Color_White)
	Else
		Return xui.Color_White
	End If
End Sub

Private Sub ResolveButtonInactiveColor(mPalette As Map) As Int
	Return B4XDaisyVariants.ResolveVariantColor(mPalette, "base-content-muted", "back", xui.Color_RGB(107, 114, 128))
End Sub
#End Region

#Region Button Management APIs
' Clears all buttons and dividers from the control
Public Sub Clear
	For Each btn As SegmentButtonConfig In mButtons
		btn.ButtonView.RemoveViewFromParent
	Next
	mButtons.Clear
	For Each div As B4XView In mDividers
		div.RemoveViewFromParent
	Next
	mDividers.Clear
	mValue = ""
	Refresh
End Sub

' Removes a specific button by value
Public Sub RemoveButton(sValue As String)
	For i = mButtons.Size - 1 To 0 Step -1
		Dim btn As SegmentButtonConfig = mButtons.Get(i)
		If btn.Value = sValue Then
			btn.ButtonView.RemoveViewFromParent
			mButtons.RemoveAt(i)
			If mValue = sValue Then mValue = ""
			Exit
		End If
	Next
	Refresh
End Sub

' Sets whether a button is disabled
Public Sub SetButtonEnabled(sValue As String, bEnabled As Boolean)
	For Each btn As SegmentButtonConfig In mButtons
		If btn.Value = sValue Then
			btn.Disabled = Not(bEnabled)
			Exit
		End If
	Next
	Refresh
End Sub

' Gets whether a button is enabled
Public Sub GetButtonEnabled(sValue As String) As Boolean
	For Each btn As SegmentButtonConfig In mButtons
		If btn.Value = sValue Then Return Not(btn.Disabled)
	Next
	Return False
End Sub
#End Region

Private Sub BuildRuntimeProps As Map
	Return CreateMap( _
		"ActiveColor": mActiveColor, _
		"Scrollable": mScrollable, _
		"ButtonSize": mButtonSize, _
		"BackgroundColor": mBackgroundColor, _
		"Disabled": mDisabled, _
		"Rounded": mRounded, _
		"Shadow": mShadow, _
		"ButtonLayout": mButtonLayout _
	)
End Sub

Private Sub ResolveRadius As Int
	Dim rad As Float = B4XDaisyVariants.ResolveRoundedDip(mRounded, 8dip)
	If rad > mBase.Height / 2 Then
		Return mBase.Height / 2
	End If
	Return rad
End Sub

Private Sub ResolveFontSizeDip(sSizeToken As String) As Float
	Select Case sSizeToken.ToLowerCase.Trim
		Case "xs"
			Return 11
		Case "sm"
			Return 12
		Case "md"
			Return 14
		Case "lg"
			Return 18
		Case "xl"
			Return 22
		Case Else
			Return 13 ' default text size
	End Select
End Sub

Private Sub ResolveButtonHeightDip(sSizeToken As String) As Int
	If IsStackedLayout Then
		Dim currentIconSize As Int = ResolveIconSizeDip(sSizeToken)
		Dim spacing As Int = 4dip
		Dim txtH As Int = ResolveTextHeightDip(sSizeToken)
		Return currentIconSize + spacing + txtH + 16dip
	End If
	
	Select Case sSizeToken.ToLowerCase.Trim
		Case "xs"
			Return 24dip
		Case "sm"
			Return 32dip
		Case "md"
			Return 40dip
		Case "lg"
			Return 48dip
		Case "xl"
			Return 56dip
		Case Else
			Return 40dip
	End Select
End Sub

Private Sub IsStackedLayout As Boolean
	If mButtons.IsInitialized Then
		For Each btn As SegmentButtonConfig In mButtons
			If btn.Layout = "icon-top" Or btn.Layout = "icon-bottom" Then Return True
		Next
	End If
	Return mButtonLayout = "icon-top" Or mButtonLayout = "icon-bottom"
End Sub

Private Sub ResolveIconSizeDip(sSizeToken As String) As Int
	Select Case sSizeToken.ToLowerCase.Trim
		Case "xs"
			Return 12dip
		Case "sm"
			Return 14dip
		Case "md"
			Return 16dip
		Case "lg"
			Return 18dip
		Case "xl"
			Return 22dip
		Case Else
			Return 16dip
	End Select
End Sub

Public Sub setActiveColor(sValue As String)
	mActiveColor = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getActiveColor As String
	Return mActiveColor
End Sub

Public Sub setScrollable(bValue As Boolean)
	mScrollable = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getScrollable As Boolean
	Return mScrollable
End Sub

Public Sub setButtonSize(sValue As String)
	mButtonSize = sValue
	If mBase.IsInitialized = False Then Return
	' Re-calculate cached button content widths and resize SVGs
	Dim currentIconSize As Int = ResolveIconSizeDip(mButtonSize)
	For Each btn As SegmentButtonConfig In mButtons
		btn.MeasuredWidth = CalculateMeasuredWidth(btn)
		btn.lblText.TextSize = ResolveFontSizeDip(mButtonSize)
		If btn.svgIcon.IsInitialized And btn.svgIcon.mBase.IsInitialized Then
			btn.svgIcon.mBase.SetLayoutAnimated(0, btn.svgIcon.mBase.Left, btn.svgIcon.mBase.Top, currentIconSize, currentIconSize)
		End If
	Next
	Refresh
End Sub

Public Sub getButtonSize As String
	Return mButtonSize
End Sub

Public Sub setTextSize(sValue As String)
	setButtonSize(sValue)
End Sub

Public Sub getTextSize As String
	Return getButtonSize
End Sub

Public Sub setBackgroundColor(oValue As Object)
	mBackgroundColor = oValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getBackgroundColor As Object
	Return mBackgroundColor
End Sub

Public Sub setDisabled(bValue As Boolean)
	mDisabled = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getDisabled As Boolean
	Return mDisabled
End Sub

Public Sub setRounded(sValue As String)
	mRounded = B4XDaisyVariants.NormalizeRounded(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setShadow(sValue As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getShadow As String
	Return mShadow
End Sub

Public Sub setButtonLayout(sValue As String)
	mButtonLayout = sValue
	If mBase.IsInitialized = False Then Return
	' Update all existing buttons layout value
	For Each btn As SegmentButtonConfig In mButtons
		btn.Layout = mButtonLayout
	Next
	Refresh
End Sub

Public Sub getButtonLayout As String
	Return mButtonLayout
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
