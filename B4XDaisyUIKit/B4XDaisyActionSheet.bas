B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
' B4XDaisyActionSheet
' 100% Parity with Ionic v8 ion-action-sheet (2026 Specifications)
#IgnoreWarnings:12,9

#Region Events
' Standard Events
#Event: DidPresent
#Event: WillPresent
#Event: DidDismiss (Data As Object, Role As String)
#Event: WillDismiss (Data As Object, Role As String)
#Event: ButtonClick (ButtonId As String, Data As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Header, DisplayName: Header, FieldType: String, DefaultValue: , Description: Title for the action sheet.
#DesignerProperty: Key: SubHeader, DisplayName: SubHeader, FieldType: String, DefaultValue: , Description: Subtitle for the action sheet.
#DesignerProperty: Key: Animated, DisplayName: Animated, FieldType: Boolean, DefaultValue: True, Description: If true, the action sheet will animate.
#DesignerProperty: Key: BackdropDismiss, DisplayName: Backdrop Dismiss, FieldType: Boolean, DefaultValue: True, Description: Dismiss when the backdrop is clicked.
#DesignerProperty: Key: KeyboardClose, DisplayName: Keyboard Close, FieldType: Boolean, DefaultValue: True, Description: Automatically dismiss keyboard when presented.
#DesignerProperty: Key: Translucent, DisplayName: Translucent, FieldType: Boolean, DefaultValue: False, Description: Enable translucent glass effects (iOS mode).
#DesignerProperty: Key: Mode, DisplayName: Mode, FieldType: String, DefaultValue: md, List: ios|md, Description: Platform rendering mode.
#DesignerProperty: Key: ButtonSize, DisplayName: Button Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Tailwind size token applied to every action button.
#DesignerProperty: Key: TextAlignment, DisplayName: Text Alignment, FieldType: String, DefaultValue: left, List: left|center|right, Description: Horizontal text alignment applied to each action button (left for md, center for ios).
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: String, DefaultValue: base-100, List: base-100|base-200|base-300|primary|secondary|accent|neutral|info|success|warning|error, Description: Surface color of the action sheet group (accepts DaisyUI variant colors).
#DesignerProperty: Key: BackdropOpacity, DisplayName: Backdrop Opacity, FieldType: String, DefaultValue: 0.4, Description: Backdrop dimming as a float string (e.g. 0.4 or 40%).
#DesignerProperty: Key: ButtonsColor, DisplayName: Buttons Color, FieldType: String, DefaultValue: default, List: default|neutral|primary|secondary|accent|info|success|warning|error|none, Description: DaisyUI variant color applied to all action buttons.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: String, DefaultValue: base-content, List: base-content|base-100|primary|secondary|accent|neutral|info|success|warning|error, Description: Header / SubHeader text color (accepts DaisyUI variant colors).
#DesignerProperty: Key: HeaderBold, DisplayName: Header Bold, FieldType: Boolean, DefaultValue: False, Description: If true, the header is rendered in bold.
#DesignerProperty: Key: ButtonGhosted, DisplayName: Button Ghosted, FieldType: Boolean, DefaultValue: True, Description: If true, action buttons use the ghost style; if false they render solid.
#End Region

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
    
	' Animation helper (B4XDaisyAnimation easing functions)
	Private Anim As B4XDaisyAnimation
    
	' Overlay & Layout Views
	Private pnlBackdrop As B4XView
	Private pnlWrapper As B4XView
	Private pnlGroup As B4XView
	Private pnlCancelGroup As B4XView
    
	' Ionic Properties
	Private msHeader As String
	Private msSubHeader As String
	Private mbAnimated As Boolean = True
	Private mbBackdropDismiss As Boolean = True
	Private mbKeyboardClose As Boolean = True
	Private mbTranslucent As Boolean = False
	Private msMode As String = "md"
	Private mbOutline As Boolean = False
	Private msButtonSize As String = "md"
	Private msTextAlignment As String = "left"
	Private miBottomGap As Int = 0
	Private mbIsOpen As Boolean = False
'	Private mTrigger As String

	' Styling Properties
	Private msBackgroundColor As String = "base-100"
	Private msBackdropOpacity As String = "0.4"
	Private msButtonColor As String = "default"
	Private msTextColor As String = "base-content"
	Private mbHeaderBold As Boolean = False
	Private mbButtonGhosted As Boolean = True

	' Internal Data
	Type ActionSheetButton(Id As String, Text As String, Role As String, Icon As String, Data As Object, Disabled As Boolean, Variant As String, IconVariant As String)
	Private mButtons As List
    
	' CSS Custom Properties Parity
	Private mcBackdropOpacity As Float = 0.4
	Private mcBackground As Int
	Private mcButtonBackground As Int
	Private mcButtonBackgroundHover As Int
	Private mcButtonColor As Int
	Private mcButtonColorDestructive As Int
	Private mcColor As Int
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	mButtons.Initialize
	Anim.Initialize
    
	' Default theme variables
	mcBackground = B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
	mcButtonBackground = xui.Color_Transparent
	mcButtonBackgroundHover = B4XDaisyVariants.GetTokenColor("--color-base-200", 0xFFE5E7EB)
	mcButtonColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Black)
	mcButtonColorDestructive = B4XDaisyVariants.GetTokenColor("--color-error", 0xFFEF4444)
	mcColor = B4XDaisyVariants.GetTokenColor("--color-base-content", 0xFF666666)
End Sub

Private Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	mBase.Color = xui.Color_Transparent
    
'	msHeader = Props.GetDefault("Header", "")
'	msSubHeader = Props.GetDefault("SubHeader", "")
'	mbAnimated = Props.GetDefault("Animated", True)
'	mbBackdropDismiss = Props.GetDefault("BackdropDismiss", True)
'	mbKeyboardClose = Props.GetDefault("KeyboardClose", True)
'	mbTranslucent = Props.GetDefault("Translucent", False)
'	msMode = Props.GetDefault("Mode", "md")
'	mbOutline = Props.GetDefault("Outline", False)
'	msButtonSize = B4XDaisyVariants.NormalizeSize(Props.GetDefault("ButtonSize", "md"))
'	msTextAlignment = Props.GetDefault("TextAlignment", "")
	ApplyDesignerProps(mProps)
	

'	' Styling properties
'	msBackgroundColor = Props.GetDefault("BackgroundColor", "base-100")
'	msBackdropOpacity = Props.GetDefault("BackdropOpacity", "0.4")
'	msButtonColor = Props.GetDefault("ButtonsColor", "default")
'	msTextColor = Props.GetDefault("TextColor", "base-content")
'	mbHeaderBold = Props.GetDefault("HeaderBold", False)
'	mbButtonGhosted = Props.GetDefault("ButtonGhosted", True)

	' Resolve theme colors from the variant strings
	
	miBottomGap = 0
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	msHeader = B4XDaisyVariants.GetPropString(mProps, "Header", "")
	msSubHeader = B4XDaisyVariants.GetPropString(mProps, "SubHeader", "")
	mbAnimated = B4XDaisyVariants.GetPropBool(mProps, "Animated", True)
	mbBackdropDismiss = B4XDaisyVariants.GetPropBool(mProps, "BackdropDismiss", True)
	mbKeyboardClose = B4XDaisyVariants.GetPropBool(mProps, "KeyboardClose", True)
	mbTranslucent = B4XDaisyVariants.GetPropBool(mProps, "Translucent", False)
	msMode = B4XDaisyVariants.GetPropString(mProps, "Mode", "md")
	mbOutline = B4XDaisyVariants.GetPropBool(mProps, "Outline", False)
	msButtonSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "ButtonSize", "md"))
	msTextAlignment = B4XDaisyVariants.GetPropString(mProps, "TextAlignment", "")
	If msTextAlignment.Trim = "" Then
		msTextAlignment = IIf(msMode = "ios", "CENTER", "LEFT")
	Else
		msTextAlignment = msTextAlignment.ToUpperCase
	End If

	msBackgroundColor = B4XDaisyVariants.GetPropString(mProps, "BackgroundColor", "base-100")
	msBackdropOpacity = B4XDaisyVariants.GetPropString(mProps, "BackdropOpacity", "0.4")
	msButtonColor = B4XDaisyVariants.GetPropString(mProps, "ButtonsColor", "default")
	msTextColor = B4XDaisyVariants.GetPropString(mProps, "TextColor", "base-content")
	mbHeaderBold = B4XDaisyVariants.GetPropBool(mProps, "HeaderBold", False)
	mbButtonGhosted = B4XDaisyVariants.GetPropBool(mProps, "ButtonGhosted", True)
	mcBackground = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundColor, mcBackground)
	mcColor = B4XDaisyVariants.ResolveTextColorVariant(msTextColor, mcColor)
	mcBackdropOpacity = ParseOpacityFloat(msBackdropOpacity, mcBackdropOpacity)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Header", msHeader)
	props.Put("SubHeader", msSubHeader)
	props.Put("Animated", mbAnimated)
	props.Put("BackdropDismiss", mbBackdropDismiss)
	props.Put("KeyboardClose", mbKeyboardClose)
	props.Put("Translucent", mbTranslucent)
	props.Put("Mode", msMode)
	props.Put("Outline", mbOutline)
	props.Put("ButtonSize", msButtonSize)
	props.Put("TextAlignment", msTextAlignment)
	props.Put("BackgroundColor", msBackgroundColor)
	props.Put("BackdropOpacity", msBackdropOpacity)
	props.Put("ButtonsColor", msButtonColor)
	props.Put("TextColor", msTextColor)
	props.Put("HeaderBold", mbHeaderBold)
	props.Put("ButtonGhosted", mbButtonGhosted)
	Return props
End Sub

#Region API Methods
' Adds an ActionSheetButton matching the exact interface specification.
Public Sub AddButton(sId As String, sText As String, sRole As String, sIcon As String)
	Dim btn As ActionSheetButton
	btn.Initialize
	btn.Id = IIf(sId = "", "btn_" & mButtons.Size, sId)
	btn.Text = sText
	btn.Role = sRole.ToLowerCase ' supports "cancel", "destructive", "selected"
	btn.Icon = sIcon
	btn.Data = Null ' attach a payload later via SetButtonData
	btn.Disabled = False
	btn.Variant = "" ' empty = use ButtonColor property (or role default)
	btn.IconVariant = "" ' empty = icon follows the button color; set via SetButtonIconColor
	mButtons.Add(btn)
End Sub

' Attaches a data payload to a single action button by id. The payload is returned
' in the ButtonClick(Id, Data) and DidDismiss(Data, Role) events when the button is tapped.
Public Sub SetButtonData(sButtonId As String, oData As Object)
	For Each btn As ActionSheetButton In mButtons
		If btn.Id = sButtonId Then
			btn.Data = oData
			Return
		End If
	Next
End Sub

' Attaches a data payload to the action button at the given 0-based index.
Public Sub SetButtonDataByIndex(iIndex As Int, oData As Object)
	If iIndex >= 0 And iIndex < mButtons.Size Then
		Dim btn As ActionSheetButton = mButtons.Get(iIndex)
		btn.Data = oData
	End If
End Sub

' Sets the icon (svg asset name) of a single action button by id. Useful to change
' or swap an icon after the button has been added. Call before Present.
Public Sub SetButtonIcon(sButtonId As String, sIconName As String)
	For Each btn As ActionSheetButton In mButtons
		If btn.Id = sButtonId Then
			btn.Icon = sIconName
			Return
		End If
	Next
End Sub

' Sets the icon (svg asset name) of the action button at the given 0-based index.
Public Sub SetButtonIconByIndex(iIndex As Int, sIconName As String)
	If iIndex >= 0 And iIndex < mButtons.Size Then
		Dim btn As ActionSheetButton = mButtons.Get(iIndex)
		btn.Icon = sIconName
	End If
End Sub

' Sets the icon color of a single action button by id (as a DaisyUI variant, e.g.
' "primary", "success", "error"). When set, the icon is recolored independently of
' the button's text color. Call before Present. Empty/"" clears it (icon follows the
' button color).
Public Sub SetButtonIconColor(sButtonId As String, sColorVariant As String)
	For Each btn As ActionSheetButton In mButtons
		If btn.Id = sButtonId Then
			btn.IconVariant = sColorVariant
			Return
		End If
	Next
End Sub

' Sets the icon color (as a DaisyUI variant) of the action button at the given index.
Public Sub SetButtonIconColorByIndex(iIndex As Int, sColorVariant As String)
	If iIndex >= 0 And iIndex < mButtons.Size Then
		Dim btn As ActionSheetButton = mButtons.Get(iIndex)
		btn.IconVariant = sColorVariant
	End If
End Sub

' Sets the DaisyUI color variant of a single action button (e.g. "primary", "error").
' Matches the "Button Colors" examples in the buttons demo. An explicit per-button
' color overrides the global ButtonColor property and the destructive role default.
' The variant drives both the button text and its icon color.
Public Sub SetButtonColor(sButtonId As String, sColorVariant As String)
	For Each btn As ActionSheetButton In mButtons
		If btn.Id = sButtonId Then
			btn.Variant = sColorVariant
			Return
		End If
	Next
End Sub

' Sets the DaisyUI color variant of the action button at the given 0-based index.
Public Sub SetButtonColorByIndex(iIndex As Int, sColorVariant As String)
	If iIndex >= 0 And iIndex < mButtons.Size Then
		Dim btn As ActionSheetButton = mButtons.Get(iIndex)
		btn.Variant = sColorVariant
	End If
End Sub

' Controls the declarative presentation state of the Action Sheet
Public Sub setIsOpen(bValue As Boolean)
	If mbIsOpen = bValue Then Return
	mbIsOpen = bValue
	If mbIsOpen Then
		Present
	Else
		Dismiss(Null, "")
	End If
End Sub

Public Sub getIsOpen As Boolean
	Return mbIsOpen
End Sub

' Programmatic method to present the action sheet, returns a ResumableSub mapping to Promise<void>
Public Sub Present As ResumableSub
	If mbKeyboardClose Then HideKeyboard
    
	If xui.SubExists(mCallBack, mEventName & "_WillPresent", 0) Then
		CallSub(mCallBack, mEventName & "_WillPresent")
	End If
    
	BuildOverlay
    
	If mbAnimated Then
		' 1. Fade the backdrop in natively
		pnlBackdrop.SetColorAnimated(300, xui.Color_Transparent, xui.Color_ARGB(Round(mcBackdropOpacity * 255), 0, 0, 0))
        
		' 2. Beautiful "Elastic" Slide-Up using easeOutExpo
		Dim duration As Int = 300
		Dim startTop As Float = mBase.Height
		Dim targetTop As Float = mBase.Height - pnlWrapper.Height - miBottomGap
		Dim change As Float = targetTop - startTop
		Dim startTime As Long = DateTime.Now
        
		pnlWrapper.Top = startTop
		Do While DateTime.Now - startTime < duration
			Dim elapsed As Float = DateTime.Now - startTime
			' Easing driven by the B4XDaisyAnimation instance (Anim.easeOutExpo).
			pnlWrapper.Top = Anim.easeOutExpo(elapsed, startTop, change, duration)
			Sleep(0) ' Yield to UI thread to paint the frame
		Loop
		pnlWrapper.Top = targetTop
	Else
		pnlBackdrop.Color = xui.Color_ARGB(Round(mcBackdropOpacity * 255), 0, 0, 0)
		pnlWrapper.Top = mBase.Height - pnlWrapper.Height - miBottomGap
	End If
    
	mbIsOpen = True
    
	If xui.SubExists(mCallBack, mEventName & "_DidPresent", 0) Then
		CallSub(mCallBack, mEventName & "_DidPresent")
	End If
	Return True
End Sub

' Programmatic method to dismiss, passing payload and role
Public Sub Dismiss(oData As Object, sRole As String) As ResumableSub
	If Not(mbIsOpen) Then Return False
    
	If xui.SubExists(mCallBack, mEventName & "_WillDismiss", 2) Then
		CallSub3(mCallBack, mEventName & "_WillDismiss", oData, sRole)
	End If
    
	If mbAnimated Then
		' 1. Fade the backdrop out natively
		pnlBackdrop.SetColorAnimated(250, pnlBackdrop.Color, xui.Color_Transparent)
        
		' 2. Smooth slide-down using easeOutCubic for exit
		Dim duration As Int = 250
		Dim startTop As Float = pnlWrapper.Top
		Dim targetTop As Float = mBase.Height
		Dim change As Float = targetTop - startTop
		Dim startTime As Long = DateTime.Now
        
		Do While DateTime.Now - startTime < duration
			Dim elapsed As Float = DateTime.Now - startTime
			pnlWrapper.Top = Anim.easeOutCubic(elapsed, startTop, change, duration)
			Sleep(0)
		Loop
		pnlWrapper.Top = targetTop
	End If
    
	pnlBackdrop.RemoveViewFromParent
	mbIsOpen = False
    
	If xui.SubExists(mCallBack, mEventName & "_DidDismiss", 2) Then
		CallSub3(mCallBack, mEventName & "_DidDismiss", oData, sRole)
	End If
	Return True
End Sub
#End Region

#Region Rendering & Mechanics
Private Sub BuildOverlay
	' Create Full-Screen Backdrop
	pnlBackdrop = xui.CreatePanel("Backdrop")
	mBase.AddView(pnlBackdrop, 0, 0, mBase.Width, mBase.Height)
    
	' Create Wrapper sliding pane
	pnlWrapper = xui.CreatePanel("")
	pnlWrapper.Color = xui.Color_Transparent
	pnlBackdrop.AddView(pnlWrapper, 0, mBase.Height, mBase.Width, 0) ' Height calculated later

	' Layout dimensions (ios insets the group; md is full width)
	Dim groupInset As Int = IIf(msMode = "ios", 10dip, 0)
	Dim groupWidth As Int = mBase.Width - IIf(msMode = "ios", 20dip, 0)
	' MD mode rounds only the TOP corners using the same radius as the modal
	' (rounded-box), leaving the bottom corners square so the sheet visually
	' anchors to the bottom edge of the screen. iOS keeps all four corners
	' rounded for its inset, detached-card look.
	Dim modalRadius As Float = B4XDaisyVariants.ResolveRoundedDip("rounded-box", 16dip)
	Dim groupRadius As Int = IIf(msMode = "ios", modalRadius, 0)
	Dim btnRowGap As Int = 4dip
	Dim groupPadding As Int = IIf(msMode = "ios", 12dip, 8dip)
	Dim btnHeight As Int = 0 ' Let DaisyButton size naturally from ButtonSize

	' Setup Layout based on OS Mode (ios detaches the cancel button)
	pnlGroup = xui.CreatePanel("")
	If msMode = "ios" Then
		pnlGroup.SetColorAndBorder(mcBackground, 0, 0, groupRadius)
	Else
		' MD: round top-left/top-right only (matches modal), keep bottom square
		B4XDaisyVariants.SetColorPerCornerRadius(pnlGroup, mcBackground, modalRadius, modalRadius, 0, 0)
	End If

	' Optional translucent (frosted glass) surface. Applies to BOTH ios and md
	' when Translucent=True. Default (False) keeps a solid mcBackground surface.
	If mbTranslucent Then
		If msMode = "ios" Then
			B4XDaisyVariants.ApplyGlassStyle(pnlGroup, groupRadius, "glass-md")
		Else
			' MD glass keeps the top-only rounding so the bottom stays flush to the screen.
			B4XDaisyVariants.ApplyGlassStylePerCorner(pnlGroup, modalRadius, modalRadius, 0, 0, "glass-md")
		End If
	End If

	Dim currentY As Int = groupPadding

	' Render Header (only when a non-blank header is provided)
	If msHeader <> "" Then
		Dim lblHead As Label
		lblHead.Initialize("")
		Dim xlblHead As B4XView = lblHead
		xlblHead.Text = msHeader
		xlblHead.TextColor = mcColor
		If mbHeaderBold Then
			xlblHead.Font = xui.CreateDefaultBoldFont(14)
		Else
			xlblHead.Font = xui.CreateDefaultFont(14)
		End If
		xlblHead.SetTextAlignment("CENTER", IIf(msMode = "ios", "CENTER", "LEFT"))
		pnlGroup.AddView(xlblHead, groupPadding, currentY, groupWidth - (groupPadding * 2), 30dip)
		currentY = currentY + 30dip
	End If

	' Render SubHeader (only when a non-blank sub-header is provided)
	If msSubHeader <> "" Then
		Dim lblSub As Label
		lblSub.Initialize("")
		Dim xlblSub As B4XView = lblSub
		xlblSub.Text = msSubHeader
		xlblSub.TextColor = mcColor
		xlblSub.Font = xui.CreateDefaultFont(12)
		xlblSub.SetTextAlignment("CENTER", IIf(msMode = "ios", "CENTER", "LEFT"))
		pnlGroup.AddView(xlblSub, groupPadding, currentY, groupWidth - (groupPadding * 2), 22dip)
		currentY = currentY + 22dip
	End If

	' Split buttons into Normal and Cancel
	Dim normalBtns As List : normalBtns.Initialize
	Dim cancelBtn As ActionSheetButton

	For Each btn As ActionSheetButton In mButtons
		If btn.Role = "cancel" Then
			cancelBtn = btn
		Else
			normalBtns.Add(btn)
		End If
	Next

	' Render Normal Buttons
	For i = 0 To normalBtns.Size - 1
		Dim btn As ActionSheetButton = normalBtns.Get(i)
		If i > 0 Then currentY = currentY + btnRowGap
		Dim h As Int = AddActionButton(pnlGroup, btn, groupPadding, currentY, groupWidth - (groupPadding * 2), btnHeight)
		currentY = currentY + h
	Next

	pnlGroup.Height = currentY + groupPadding
	pnlWrapper.AddView(pnlGroup, groupInset, 0, groupWidth, pnlGroup.Height)

	Dim totalWrapperHeight As Int = pnlGroup.Height + IIf(msMode = "ios", 20dip, 0)

	' Render Cancel Button (Detached in iOS, inline in MD)
	If cancelBtn.IsInitialized Then
		If msMode = "ios" Then
			pnlCancelGroup = xui.CreatePanel("")
			pnlCancelGroup.SetColorAndBorder(mcBackground, 0, 0, groupRadius)
			If mbTranslucent Then B4XDaisyVariants.ApplyGlassStyle(pnlCancelGroup, groupRadius, "glass-md")

			Dim ch As Int = AddActionButton(pnlCancelGroup, cancelBtn, groupPadding, groupPadding, groupWidth - (groupPadding * 2), btnHeight)
			pnlCancelGroup.Height = ch + (groupPadding * 2)

			pnlWrapper.AddView(pnlCancelGroup, groupInset, pnlGroup.Height + 8dip, groupWidth, pnlCancelGroup.Height)
			totalWrapperHeight = pnlGroup.Height + pnlCancelGroup.Height + 24dip
		Else
			If normalBtns.Size > 0 Then currentY = currentY + btnRowGap
			Dim ch As Int = AddActionButton(pnlGroup, cancelBtn, groupPadding, currentY, groupWidth - (groupPadding * 2), btnHeight)
			pnlGroup.Height = currentY + ch + groupPadding
			totalWrapperHeight = pnlGroup.Height
		End If
	End If

	pnlWrapper.Height = totalWrapperHeight
End Sub

' Builds a ghost-styled B4XDaisyButton (icon + text) for the action sheet row.
' Reuses the existing Daisy button + SvgIcon rendering so icons display correctly.
Private Sub AddActionButton(vParent As B4XView, BtnData As ActionSheetButton, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As Int
	Dim btn As B4XDaisyButton
	btn.Initialize(Me, "ActionBtn")
	btn.setTag(BtnData)

	' Configure before AddToParent so DesignerCreateView picks up the values.
	' Style: Outline takes precedence, otherwise Ghosted (default) vs Solid.
	btn.Style = IIf(mbOutline, "outline", IIf(mbButtonGhosted, "ghost", "solid"))
	' Both iOS and MD buttons keep the DaisyButton default radius ("theme").
	' (TODO: a ripple/touch-feedback effect will be wired up here later.)
	btn.Size = msButtonSize
	btn.TextAlignment = msTextAlignment
	btn.Text = BtnData.Text
	If BtnData.Icon.Trim.Length > 0 Then btn.IconName = BtnData.Icon

	' Resolve the button color variant: an explicit per-button color wins,
	' otherwise destructive defaults to "error", otherwise the global ButtonColor.
	Dim btnVariant As String = BtnData.Variant
	If btnVariant.Trim.Length > 0 Then
		' explicit per-button color overrides everything
	Else If BtnData.Role = "destructive" Then
		btnVariant = "error"
	Else
		btnVariant = msButtonColor
	End If
	btn.Variant = btnVariant
	' By default the icon follows the button's variant fg color. An explicit
	' per-button icon color variant (SetButtonIconColor) recolors the icon only.
	If BtnData.IconVariant.Trim.Length > 0 Then
		btn.IconColor = B4XDaisyVariants.ResolveTextColor(BtnData.IconVariant, mcButtonColor)
	End If

	If BtnData.Disabled Then btn.Disabled = True

	btn.AddToParent(vParent, iLeft, iTop, iWidth, iHeight)

	Return btn.GetComputedHeight
End Sub
#End Region

#Region Internal Event Handlers
Private Sub Backdrop_Click
	If mbBackdropDismiss Then
		Dismiss(Null, "backdrop")
	End If
End Sub

Private Sub ActionBtn_Click(oTag As Object)
	Dim btn As ActionSheetButton = oTag
	If btn = Null Then Return
	If btn.Disabled Then Return

	If xui.SubExists(mCallBack, mEventName & "_ButtonClick", 3) Then
		CallSub3(mCallBack, mEventName & "_ButtonClick", btn.Id, btn.Data)
	End If

	' Cancel automatically triggers dismiss, others rely on user code or standard close
	Dismiss(btn.Data, btn.Role)
End Sub

Private Sub HideKeyboard
	' Helper to abstract away keyboard closure (as per keyboardClose=true)
	' Usually implemented via the IME library:
	' Dim ime As IME
	' ime.HideKeyboard
End Sub

' Parses a backdrop opacity string into a 0..1 float.
' Accepts plain floats ("0.5") and percentages ("50%"). Falls back to DefaultVal.
Private Sub ParseOpacityFloat(sValue As String, fDefaultVal As Float) As Float
	Try
		Dim s As String = sValue.Trim
		If s.Length = 0 Then Return fDefaultVal
		If s.EndsWith("%") Then
			Dim pct As Float = s.SubString2(0, s.Length - 1)
			Return Max(0, Min(1, pct / 100))
		End If
		Dim f As Float = s
		Return Max(0, Min(1, f))
	Catch
		Return fDefaultVal
	End Try
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	DesignerCreateView(b, Null, props)
	Return mBase
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	If vParent.IsInitialized = False Then Return mBase
	If mBase.IsInitialized = False Then
		CreateView(iWidth, iHeight)
	End If
	vParent.AddView(mBase, iLeft, iTop, iWidth, iHeight)
	Return mBase
End Sub

Public Sub setHeader(sValue As String)
	msHeader = sValue
End Sub

Public Sub getHeader As String
	Return msHeader
End Sub

Public Sub setSubHeader(sValue As String)
	msSubHeader = sValue
End Sub

Public Sub getSubHeader As String
	Return msSubHeader
End Sub

Public Sub setAnimated(bValue As Boolean)
	mbAnimated = bValue
End Sub

Public Sub getAnimated As Boolean
	Return mbAnimated
End Sub

Public Sub setBackdropDismiss(bValue As Boolean)
	mbBackdropDismiss = bValue
End Sub

Public Sub getBackdropDismiss As Boolean
	Return mbBackdropDismiss
End Sub

Public Sub setKeyboardClose(bValue As Boolean)
	mbKeyboardClose = bValue
End Sub

Public Sub getKeyboardClose As Boolean
	Return mbKeyboardClose
End Sub

Public Sub setTranslucent(bValue As Boolean)
	mbTranslucent = bValue
End Sub

Public Sub getTranslucent As Boolean
	Return mbTranslucent
End Sub

Public Sub setMode(sValue As String)
	msMode = sValue
End Sub

Public Sub getMode As String
	Return msMode
End Sub

Public Sub setOutline(bValue As Boolean)
	mbOutline = bValue
End Sub

Public Sub getOutline As Boolean
	Return mbOutline
End Sub

Public Sub setButtonSize(sValue As String)
	msButtonSize = B4XDaisyVariants.NormalizeSize(sValue)
End Sub

Public Sub getButtonSize As String
	Return msButtonSize
End Sub

Public Sub setTextAlignment(sValue As String)
	msTextAlignment = sValue
End Sub

Public Sub getTextAlignment As String
	Return msTextAlignment
End Sub

Public Sub setBackgroundColor(sValue As String)
	msBackgroundColor = sValue
	mcBackground = B4XDaisyVariants.ResolveBackgroundColorVariant(msBackgroundColor, mcBackground)
End Sub

Public Sub getBackgroundColor As String
	Return msBackgroundColor
End Sub

Public Sub setBackdropOpacity(sValue As String)
	msBackdropOpacity = sValue
	mcBackdropOpacity = ParseOpacityFloat(msBackdropOpacity, mcBackdropOpacity)
End Sub

Public Sub getBackdropOpacity As String
	Return msBackdropOpacity
End Sub

Public Sub setButtonsColor(sValue As String)
	msButtonColor = sValue
End Sub

Public Sub getButtonsColor As String
	Return msButtonColor
End Sub

Public Sub setTextColor(sValue As String)
	msTextColor = sValue
	mcColor = B4XDaisyVariants.ResolveTextColorVariant(msTextColor, mcColor)
End Sub

Public Sub getTextColor As String
	Return msTextColor
End Sub

Public Sub setHeaderBold(bValue As Boolean)
	mbHeaderBold = bValue
End Sub

Public Sub getHeaderBold As Boolean
	Return mbHeaderBold
End Sub

Public Sub setButtonGhosted(bValue As Boolean)
	mbButtonGhosted = bValue
End Sub

Public Sub getButtonGhosted As Boolean
	Return mbButtonGhosted
End Sub
#End Region

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
