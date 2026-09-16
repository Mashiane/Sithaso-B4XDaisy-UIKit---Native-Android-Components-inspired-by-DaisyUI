B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#Event: Result (Result As B4XDaisySweetAlertResult)

#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: Are you sure?, Description: The popup title.
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue:, Description: The popup body text. Blank by default; set explicitly when a prompt needs explanatory copy.
#DesignerProperty: Key: Icon, DisplayName: Icon, FieldType: String, DefaultValue: none, List: none|warning|error|success|info|question|loading, Description: Built-in icon type (loading shows a spinner).
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0xFF545454, Description: Tint color for the SVG icon.
#DesignerProperty: Key: IconSize, DisplayName: Icon Size, FieldType: Int, DefaultValue: 80, Description: Icon width/height in dip.
#DesignerProperty: Key: ShowConfirmButton, DisplayName: Show Confirm, FieldType: Boolean, DefaultValue: True, Description: Show the confirm button.
#DesignerProperty: Key: ConfirmButtonText, DisplayName: Confirm Text, FieldType: String, DefaultValue: OK, Description: Text for the confirm button.
#DesignerProperty: Key: ConfirmButtonColor, DisplayName: Confirm Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color for the confirm button. Transparent derives it from the primary variant.
#DesignerProperty: Key: ConfirmButtonTextColor, DisplayName: Confirm Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Label color for the confirm button. Transparent derives it from the primary variant.
#DesignerProperty: Key: ShowDenyButton, DisplayName: Show Deny, FieldType: Boolean, DefaultValue: False, Description: Show the deny button.
#DesignerProperty: Key: DenyButtonText, DisplayName: Deny Text, FieldType: String, DefaultValue: No, Description: Text for the deny button.
#DesignerProperty: Key: DenyButtonColor, DisplayName: Deny Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color for the deny button. Transparent derives it from the warning variant.
#DesignerProperty: Key: DenyButtonTextColor, DisplayName: Deny Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Label color for the deny button. Transparent derives it from the warning variant.
#DesignerProperty: Key: ShowCancelButton, DisplayName: Show Cancel, FieldType: Boolean, DefaultValue: False, Description: Show the cancel button.
#DesignerProperty: Key: CancelButtonText, DisplayName: Cancel Text, FieldType: String, DefaultValue: Cancel, Description: Text for the cancel button.
#DesignerProperty: Key: CancelButtonColor, DisplayName: Cancel Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color for the cancel button. Transparent derives it from the error variant.
#DesignerProperty: Key: CancelButtonTextColor, DisplayName: Cancel Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Label color for the cancel button. Transparent derives it from the error variant.
#DesignerProperty: Key: ShowCloseButton, DisplayName: Show Close Button, FieldType: Boolean, DefaultValue: False, Description: Show a close button top-right.
#DesignerProperty: Key: AllowOutsideClick, DisplayName: Allow Outside Click, FieldType: Boolean, DefaultValue: True, Description: Close when clicking the backdrop.
#DesignerProperty: Key: ReverseButtons, DisplayName: Reverse Buttons, FieldType: Boolean, DefaultValue: False, Description: Swap confirm/deny/cancel order.
#DesignerProperty: Key: Footer, DisplayName: Footer Text, FieldType: String, DefaultValue: , Description: Optional footer text shown below actions.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Modal background color.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF545454, Description: Title and body text color.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: Int, DefaultValue: 360, Description: Maximum modal width in dip.
#DesignerProperty: Key: TimerMs, DisplayName: Auto Close Timer (ms), FieldType: Int, DefaultValue: 0, Description: Auto close timer in milliseconds. 0 disables.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box, Description: Corner radius style for the alert card

#DesignerProperty: Key: InputType, DisplayName: Input Type, FieldType: String, DefaultValue: none, List: none|text|password|email|number|tel|textarea|select|checkbox|checkboxgroup|radio|radiogroup|toggle|togglegroup|range|rating, Description: Input control type for interactive prompts.
#DesignerProperty: Key: InputPlaceholder, DisplayName: Input Placeholder, FieldType: String, DefaultValue: , Description: Placeholder text for prompt inputs.
#DesignerProperty: Key: InputLabel, DisplayName: Input Label, FieldType: String, DefaultValue: , Description: Label for prompt inputs or checkboxes.
#DesignerProperty: Key: InputRequired, DisplayName: Input Required, FieldType: Boolean, DefaultValue: False, Description: Require non-empty input before confirming.
#DesignerProperty: Key: InputErrorMessage, DisplayName: Input Error Message, FieldType: String, DefaultValue: This field is required., Description: Error message shown when validation fails.
#DesignerProperty: Key: InputVariant, DisplayName: Input Variant, FieldType: String, DefaultValue: primary, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant for option controls (checkbox, radio, toggle).
#DesignerProperty: Key: InputMultiple, DisplayName: Input Multiple, FieldType: Boolean, DefaultValue: False, Description: Allow multiple selections for checkbox/toggle groups. False = single-select (radio-like). Only applies to checkbox and toggle inputs.

#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object

	' UI Layers
	Private mBackdrop As B4XView
	Private mContentBox As B4XView

	' Content Components
	Private mIconPanel As B4XView
	Private mIconComp As B4XDaisySvgIcon
	Private mLoadingSpinner As B4XDaisyLoading
	Private lblTitle As B4XDaisyText
	Private lblText As B4XDaisyText
	Private lblFooter As B4XDaisyText
	Private pnlActions As B4XView
	Private btnConfirm As B4XDaisyButton
	Private btnDeny As B4XDaisyButton
	Private btnCancel As B4XDaisyButton
	Private btnClose As B4XDaisyIconButton

	' Backing Properties
	Private msTitle As String = "Are you sure?"
	Private msText As String = ""
	Private msIcon As String = "none"
	Private mIconColor As Int
	Private mIconSize As Int = 80dip
	Private mbShowConfirmButton As Boolean = True
	Private msConfirmButtonText As String = "OK"
	Private mConfirmButtonColor As Int
	Private mConfirmButtonTextColor As Int
	Private mbShowDenyButton As Boolean = False
	Private msDenyButtonText As String = "No"
	Private mDenyButtonColor As Int
	Private mDenyButtonTextColor As Int
	Private mbShowCancelButton As Boolean = False
	Private msCancelButtonText As String = "Cancel"
	Private mCancelButtonColor As Int
	Private mCancelButtonTextColor As Int
	Private mbShowCloseButton As Boolean = False
	Private mbAllowOutsideClick As Boolean = True
	Private mbReverseButtons As Boolean = False
	Private msFooter As String = ""
	Private mBackgroundColor As Int = 0xFFFFFFFF
	Private mTextColor As Int = 0xFF545454
	Private mModalWidth As Int = 360dip
	Private miTimerMs As Int = 0
	Private msRounded As String = "rounded-box"

	' Input Properties & Controls
	Private msInputType As String = "none"
	Private msInputPlaceholder As String = ""
	Private mInputValue As Object = Null
	Private msInputLabel As String = ""
	Private msInputErrorMessage As String = "This field is required."
	Private mbInputRequired As Boolean = False
	Private mInputOptions As Map
	Private mValidatorCallback As Object = Null
	Private msValidatorSub As String = ""
	Private msCurrentValidationError As String = ""
	Private msInputVariant As String = "primary"
	Private mbInputMultiple As Boolean = False
	Private mOptionItems As List
	' Range input bounds/step (applied when InputType = "range").
	Private miInputMin As Int = 0
	Private miInputMax As Int = 100
	Private miInputStep As Int = 1

	Private mInputHost As B4XView
	Private lblInputError As B4XDaisyText
	Private mInputComp As B4XDaisyInput
	Private mSelectComp As B4XDaisySelect
	Private mCheckboxComp As B4XDaisyCheckbox
	Private mCheckboxGroupComp As B4XDaisyCheckboxGroup
	Private mRadioGroupComp As B4XDaisyRadioGroup
	Private mToggleComp As B4XDaisyToggle
	Private mToggleGroupComp As B4XDaisyToggleGroup
	Private mRangeComp As B4XDaisyRange
	Private mRatingComp As B4XDaisyRating

	Private mAutoCloseTimer As Timer
	Private mResult As B4XDaisySweetAlertResult
	Private mIsOpen As Boolean
	Private mParent As B4XView
	Private mSweetAlertIcon As B4XDaisySweetAlertIcon
	Private mScrollView As ScrollView
	Private mbKeyboardOpen As Boolean
	Private miKeyboardHeight As Int
	Private miPrevRootHeight As Int
	Private mKeyboardTimer As Timer
End Sub

Public Sub Initialize(oCallback As Object, vParent As B4XView, sEventName As String)
	mCallBack = oCallback
	mParent = vParent
	mEventName = sEventName
	mAutoCloseTimer.Initialize("AutoCloseTimer", 1000)
	mAutoCloseTimer.Enabled = False
	mIconColor = xui.Color_RGB(84, 84, 84)
	mConfirmButtonColor = xui.Color_Transparent
	mConfirmButtonTextColor = xui.Color_Transparent
	mDenyButtonColor = xui.Color_Transparent
	mDenyButtonTextColor = xui.Color_Transparent
	mCancelButtonColor = xui.Color_Transparent
	mCancelButtonTextColor = xui.Color_Transparent
	mKeyboardTimer.Initialize("KeyboardTimer", 300)
	mKeyboardTimer.Enabled = False
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' 1. Backdrop
	Dim pBackdrop As Panel
	pBackdrop.Initialize("mBackdrop")
	mBackdrop = pBackdrop
	mBase.AddView(mBackdrop, 0, 0, mBase.Width, mBase.Height)

	' 2. ScrollView (wraps the modal card so it can scroll when keyboard is open)
	Dim sv As ScrollView
	sv.Initialize(Max(1dip, mBase.Height))
	mScrollView = sv
	mBackdrop.AddView(mScrollView, 0, 0, mBase.Width, mBase.Height)

	' 3. Modal Card (inside ScrollView)
	Dim pBox As Panel
	pBox.Initialize("mContentBox")
	mContentBox = pBox
	Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 16dip)
	mContentBox.SetColorAndBorder(mBackgroundColor, 0, 0, radius)
	B4XDaisyVariants.ApplyElevation(mContentBox, "2xl")
	mScrollView.Panel.AddView(mContentBox, 0, 0, 320dip, 240dip)

	' 4. Initialize Icon & Spinner Hosts
	Dim pIcon As Panel
	pIcon.Initialize("")
	mIconPanel = pIcon
	mIconPanel.Color = xui.Color_Transparent
	mContentBox.AddView(mIconPanel, 0, 0, mIconSize, mIconSize)

	Dim iconSvg As B4XDaisySvgIcon
	iconSvg.Initialize(Me, "IconComp")
	mIconComp = iconSvg
	mIconComp.AddToParent(mIconPanel, 0, 0, mIconSize, mIconSize)
	mIconComp.setClickable(False)
	mIconComp.setPreserveOriginalColors(False)

	mLoadingSpinner.Initialize(Me, "mLoadingSpinner")
	mLoadingSpinner.CreateView(mIconSize, mIconSize)
	mLoadingSpinner.setClickable(False)
	mContentBox.AddView(mLoadingSpinner.mBase, 0, 0, mIconSize, mIconSize)

	Dim pSweetIcon As Panel
	pSweetIcon.Initialize("")
	mSweetAlertIcon.Initialize(Me, "mSweetAlertIcon")
	mContentBox.AddView(pSweetIcon, 0, 0, mIconSize, mIconSize)
	mSweetAlertIcon.DesignerCreateView(pSweetIcon, Null, CreateMap("IconType": "success", "Duration": 500))

	' 4. Initialize Texts
	lblTitle.Initialize(Me, "lblTitle")
	lblTitle.AddToParent(mContentBox, 0, 0, 320dip, 30dip)
	lblTitle.FontBold = True
	lblTitle.TextSize = 24
	lblTitle.TextColor = mTextColor
	lblTitle.HAlign = "CENTER"
	lblTitle.AutoResize = True

	lblText.Initialize(Me, "lblText")
	lblText.AddToParent(mContentBox, 0, 0, 320dip, 40dip)
	lblText.TextSize = 16
	lblText.TextColor = mTextColor
	lblText.HAlign = "CENTER"
	lblText.AutoResize = True

	' 5. Input Layer & Error Text
	Dim pInputHost As Panel
	pInputHost.Initialize("")
	mInputHost = pInputHost
	mInputHost.Color = xui.Color_Transparent
	mContentBox.AddView(mInputHost, 0, 0, 320dip, 40dip)

	lblInputError.Initialize(Me, "lblInputError")
	lblInputError.AddToParent(mContentBox, 0, 0, 320dip, 20dip)
	lblInputError.TextSize = 12
	lblInputError.TextColor = xui.Color_RGB(239, 68, 68)
	lblInputError.HAlign = "LEFT"
	lblInputError.AutoResize = True

	' 6. Footer
	lblFooter.Initialize(Me, "lblFooter")
	lblFooter.AddToParent(mContentBox, 0, 0, 320dip, 20dip)
	lblFooter.TextSize = 12
	lblFooter.TextColor = xui.Color_RGB(120, 120, 120)
	lblFooter.HAlign = "CENTER"
	lblFooter.AutoResize = True

	' 7. Actions Footer
	Dim pAct As Panel
	pAct.Initialize("")
	pnlActions = pAct
	pnlActions.Color = xui.Color_Transparent
	mContentBox.AddView(pnlActions, 0, 0, 320dip, 60dip)

	btnConfirm.Initialize(Me, "btnConfirm")
	btnDeny.Initialize(Me, "btnDeny")
	btnCancel.Initialize(Me, "btnCancel")

	btnClose.Initialize(Me, "btnClose")

	ApplyDesignerProps(mProps)
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	If mProps.IsInitialized = False Then Return
	msTitle = B4XDaisyVariants.GetPropString(mProps, "Title", msTitle)
	msText = B4XDaisyVariants.GetPropString(mProps, "Text", msText)
	msIcon = B4XDaisyVariants.GetPropString(mProps, "Icon", msIcon)
	mIconColor = B4XDaisyVariants.GetPropColor(mProps, "IconColor", mIconColor)
	mIconSize = Max(24dip, B4XDaisyVariants.GetPropInt(mProps, "IconSize", mIconSize / 1dip) * 1dip)
	mbShowConfirmButton = B4XDaisyVariants.GetPropBool(mProps, "ShowConfirmButton", mbShowConfirmButton)
	msConfirmButtonText = B4XDaisyVariants.GetPropString(mProps, "ConfirmButtonText", msConfirmButtonText)
	mConfirmButtonColor = B4XDaisyVariants.GetPropColor(mProps, "ConfirmButtonColor", mConfirmButtonColor)
	mConfirmButtonTextColor = B4XDaisyVariants.GetPropColor(mProps, "ConfirmButtonTextColor", mConfirmButtonTextColor)
	mbShowDenyButton = B4XDaisyVariants.GetPropBool(mProps, "ShowDenyButton", mbShowDenyButton)
	msDenyButtonText = B4XDaisyVariants.GetPropString(mProps, "DenyButtonText", msDenyButtonText)
	mDenyButtonColor = B4XDaisyVariants.GetPropColor(mProps, "DenyButtonColor", mDenyButtonColor)
	mDenyButtonTextColor = B4XDaisyVariants.GetPropColor(mProps, "DenyButtonTextColor", mDenyButtonTextColor)
	mbShowCancelButton = B4XDaisyVariants.GetPropBool(mProps, "ShowCancelButton", mbShowCancelButton)
	msCancelButtonText = B4XDaisyVariants.GetPropString(mProps, "CancelButtonText", msCancelButtonText)
	mCancelButtonColor = B4XDaisyVariants.GetPropColor(mProps, "CancelButtonColor", mCancelButtonColor)
	mCancelButtonTextColor = B4XDaisyVariants.GetPropColor(mProps, "CancelButtonTextColor", mCancelButtonTextColor)
	mbShowCloseButton = B4XDaisyVariants.GetPropBool(mProps, "ShowCloseButton", mbShowCloseButton)
	mbAllowOutsideClick = B4XDaisyVariants.GetPropBool(mProps, "AllowOutsideClick", mbAllowOutsideClick)
	mbReverseButtons = B4XDaisyVariants.GetPropBool(mProps, "ReverseButtons", mbReverseButtons)
	msFooter = B4XDaisyVariants.GetPropString(mProps, "Footer", msFooter)
	mBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackgroundColor)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mModalWidth = Max(200dip, B4XDaisyVariants.GetPropInt(mProps, "Width", mModalWidth / 1dip) * 1dip)
	miTimerMs = Max(0, B4XDaisyVariants.GetPropInt(mProps, "TimerMs", miTimerMs))
	msRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", "rounded-box")
	msInputType = B4XDaisyVariants.GetPropString(mProps, "InputType", msInputType)
	msInputPlaceholder = B4XDaisyVariants.GetPropString(mProps, "InputPlaceholder", msInputPlaceholder)
	msInputLabel = B4XDaisyVariants.GetPropString(mProps, "InputLabel", msInputLabel)
	mbInputRequired = B4XDaisyVariants.GetPropBool(mProps, "InputRequired", mbInputRequired)
	msInputErrorMessage = B4XDaisyVariants.GetPropString(mProps, "InputErrorMessage", msInputErrorMessage)
	msInputVariant = B4XDaisyVariants.GetPropString(mProps, "InputVariant", msInputVariant)
	mbInputMultiple = B4XDaisyVariants.GetPropBool(mProps, "InputMultiple", mbInputMultiple)
End Sub

Private Sub BuildRuntimeProps As Map
	Dim props As Map
	props.Initialize
	props.Put("Title", msTitle)
	props.Put("Text", msText)
	props.Put("Icon", msIcon)
	props.Put("IconColor", mIconColor)
	props.Put("IconSize", mIconSize / 1dip)
	props.Put("ShowConfirmButton", mbShowConfirmButton)
	props.Put("ConfirmButtonText", msConfirmButtonText)
	props.Put("ConfirmButtonColor", mConfirmButtonColor)
	props.Put("ConfirmButtonTextColor", mConfirmButtonTextColor)
	props.Put("ShowDenyButton", mbShowDenyButton)
	props.Put("DenyButtonText", msDenyButtonText)
	props.Put("DenyButtonColor", mDenyButtonColor)
	props.Put("DenyButtonTextColor", mDenyButtonTextColor)
	props.Put("ShowCancelButton", mbShowCancelButton)
	props.Put("CancelButtonText", msCancelButtonText)
	props.Put("CancelButtonColor", mCancelButtonColor)
	props.Put("CancelButtonTextColor", mCancelButtonTextColor)
	props.Put("ShowCloseButton", mbShowCloseButton)
	props.Put("AllowOutsideClick", mbAllowOutsideClick)
	props.Put("ReverseButtons", mbReverseButtons)
	props.Put("Footer", msFooter)
	props.Put("BackgroundColor", mBackgroundColor)
	props.Put("TextColor", mTextColor)
	props.Put("Width", mModalWidth / 1dip)
	props.Put("TimerMs", miTimerMs)
	props.Put("Rounded", msRounded)
	props.Put("InputType", msInputType)
	props.Put("InputPlaceholder", msInputPlaceholder)
	props.Put("InputLabel", msInputLabel)
	props.Put("InputRequired", mbInputRequired)
	props.Put("InputErrorMessage", msInputErrorMessage)
	props.Put("InputMultiple", mbInputMultiple)
	Return props
End Sub

Private Sub IconNameToAsset(sIcon As String) As String
	Select Case sIcon.ToLowerCase
		Case "success": Return "check-solid.svg"
		Case "error": Return "circle-xmark-solid.svg"
		Case "warning": Return "triangle-exclamation-solid.svg"
		Case "info": Return "circle-info-solid.svg"
		Case "question": Return "circle-question-regular.svg"
		Case Else: Return ""
	End Select
End Sub

Private Sub IsAnimatedIcon(sIcon As String) As Boolean
	Select Case sIcon.ToLowerCase
		Case "success", "error", "warning", "info", "question", "loading": Return True
		Case Else: Return False
	End Select
End Sub

Public Sub Refresh
	If mBase.IsInitialized = False Then Return

	mBackdrop.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)

	Dim currentY As Int = 20dip
	Dim boxW As Int = Min(mModalWidth, mBase.Width - 32dip)
	Dim iconSpace As Int = mIconSize + 10dip

	' Apply modal colors
	Dim radius As Int = B4XDaisyVariants.ResolveRoundedDip(msRounded, 16dip)
	mContentBox.SetColorAndBorder(mBackgroundColor, 0, 0, radius)
	lblTitle.TextColor = mTextColor
	lblText.TextColor = mTextColor

	' Handle Icon State
	mIconPanel.Visible = False
	mLoadingSpinner.setVisible(False)
	If mSweetAlertIcon.mBase.IsInitialized Then mSweetAlertIcon.mBase.Visible = False
	
	If IsAnimatedIcon(msIcon) Then
		If mSweetAlertIcon.mBase.IsInitialized Then
			mSweetAlertIcon.mBase.Visible = True
			mSweetAlertIcon.mBase.SetLayoutAnimated(0, (boxW - mIconSize) / 2, currentY, mIconSize, mIconSize)
			mSweetAlertIcon.setIconType(msIcon)
			currentY = currentY + iconSpace
		End If
	Else
		Dim asset As String = IconNameToAsset(msIcon)
		If asset <> "" Then
			mIconPanel.Visible = True
			mIconPanel.SetLayoutAnimated(0, (boxW - mIconSize) / 2, currentY, mIconSize, mIconSize)
			mIconComp.mBase.SetLayoutAnimated(0, 0, 0, mIconSize, mIconSize)
			mIconComp.setSvgAsset(asset)
			mIconComp.setColor(mIconColor)
			mIconComp.ResizeToParent(mIconComp.mBase)
			currentY = currentY + iconSpace
		End If
	End If

	' Handle Close Button
	If mbShowCloseButton Then
		If btnClose.mBase.IsInitialized And btnClose.mBase.Parent.IsInitialized Then btnClose.mBase.RemoveViewFromParent
		btnClose.AddToParent(mContentBox, boxW - 40dip, 8dip, 32dip, 32dip)
		btnClose.setIconAsset("close.svg")
		btnClose.setIconColor(mTextColor)
		btnClose.setVariant("neutral")
		btnClose.setStyle("ghost")
		btnClose.setClickable(True)
	Else
		If btnClose.mBase.IsInitialized Then btnClose.mBase.RemoveViewFromParent
	End If

	' Handle Texts
	If msTitle <> "" Then
		lblTitle.Visible = True
		lblTitle.Text = msTitle
		lblTitle.SetLayoutAnimated(0, 20dip, currentY, boxW - 40dip, 30dip)
		currentY = currentY + lblTitle.GetComputedHeight + 10dip
	Else
		lblTitle.Visible = False
	End If

	If msText <> "" Then
		lblText.Visible = True
		lblText.Text = msText
		lblText.SetLayoutAnimated(0, 20dip, currentY, boxW - 40dip, 40dip)
		currentY = currentY + lblText.GetComputedHeight + 20dip
	Else
		lblText.Visible = False
	End If

	' Handle Input Controls
	If msInputType <> "none" And msInputType <> "" Then
		mInputHost.Visible = True
		mInputHost.RemoveAllViews
		
		Dim inputW As Int = boxW - 40dip
		Dim inputH As Int = 40dip
		Dim t As String = msInputType.ToLowerCase
		
		Select Case t
			Case "text", "password", "email", "number", "tel"
				mInputComp.Initialize(Me, "mInputComp")
				mInputComp.AddToParent(mInputHost, 0, 0, inputW, 40dip)
				' B4XDaisyInput uses "phone" for the dialer keyboard; swal exposes it as "tel".
				Dim nativeType As String = t
				If t = "tel" Then nativeType = "phone"
				mInputComp.setInputType(nativeType)
				If msInputPlaceholder <> "" Then mInputComp.setPlaceholder(msInputPlaceholder)
				If mInputValue <> Null Then mInputComp.setText("" & mInputValue)
				inputH = 40dip
				
			Case "textarea"
				mInputComp.Initialize(Me, "mInputComp")
				mInputComp.AddToParent(mInputHost, 0, 0, inputW, 80dip)
				mInputComp.setSingleLine(False)
				If msInputPlaceholder <> "" Then mInputComp.setPlaceholder(msInputPlaceholder)
				If mInputValue <> Null Then mInputComp.setText("" & mInputValue)
				inputH = 80dip
				
			Case "select"
				mSelectComp.Initialize(Me, "mSelectComp")
				mSelectComp.AddToParent(mInputHost, 0, 0, inputW, 40dip)
				If msInputPlaceholder <> "" Then mSelectComp.setPlaceholder(msInputPlaceholder)
				If mInputOptions.IsInitialized Then mSelectComp.setItems(mInputOptions)
				If mInputValue <> Null Then mSelectComp.setValue("" & mInputValue)
				inputH = 40dip
				
			Case "checkbox", "checkboxgroup"
				mOptionItems.Initialize
				Dim itemY As Int = 0
				If mInputOptions.IsInitialized And mInputOptions.Size > 0 Then
					For Each k As String In mInputOptions.Keys
						Dim optText As String = mInputOptions.Get(k)
						Dim cb As B4XDaisyCheckbox
						cb.Initialize(Me, "OptionCheckbox")
						cb.AddToParent(mInputHost, 0, itemY, inputW, 36dip)
						cb.setText(optText)
						cb.setTag(k)
						cb.setValue("" & k)
						cb.setVariant(msInputVariant)
						If mbInputMultiple = False Then cb.setGroupName("swal_checkbox_group")
						If mInputValue <> Null Then
							If mInputValue Is List Then
								Dim lVal As List = mInputValue
								If lVal.IndexOf(k) >= 0 Then cb.setChecked(True)
							Else If "" & mInputValue = "" & k Then
								cb.setChecked(True)
							End If
						End If
						mOptionItems.Add(cb)
						itemY = itemY + 40dip
					Next
					inputH = itemY
				Else
					Dim cb As B4XDaisyCheckbox
					cb.Initialize(Me, "OptionCheckbox")
					cb.AddToParent(mInputHost, 0, 0, inputW, 36dip)
					If msInputLabel <> "" Then cb.setText(msInputLabel)
					cb.setTag("default")
					cb.setValue("default")
					cb.setVariant(msInputVariant)
					If mInputValue <> Null And (mInputValue Is Boolean) Then cb.setChecked(mInputValue)
					mOptionItems.Add(cb)
					inputH = 36dip
				End If

			Case "radio", "radiogroup"
				mOptionItems.Initialize
				Dim itemY As Int = 0
				If mInputOptions.IsInitialized And mInputOptions.Size > 0 Then
					For Each k As String In mInputOptions.Keys
						Dim optText As String = mInputOptions.Get(k)
						Dim rb As B4XDaisyRadio
						rb.Initialize(Me, "OptionRadio")
						rb.AddToParent(mInputHost, 0, itemY, inputW, 36dip)
						rb.setText(optText)
						rb.setValue("" & k)
						rb.setTag(k)
						rb.setGroupName("swal_radio_group")
						rb.setVariant(msInputVariant)
						If mInputValue <> Null And ("" & mInputValue = "" & k) Then
							rb.setChecked(True)
						End If
						mOptionItems.Add(rb)
						itemY = itemY + 40dip
					Next
					inputH = itemY
				Else
					Dim rb As B4XDaisyRadio
					rb.Initialize(Me, "OptionRadio")
					rb.AddToParent(mInputHost, 0, 0, inputW, 36dip)
					If msInputLabel <> "" Then rb.setText(msInputLabel)
					rb.setVariant(msInputVariant)
					mOptionItems.Add(rb)
					inputH = 36dip
				End If

			Case "toggle", "togglegroup"
				mOptionItems.Initialize
				Dim itemY As Int = 0
				If mInputOptions.IsInitialized And mInputOptions.Size > 0 Then
					For Each k As String In mInputOptions.Keys
						Dim optText As String = mInputOptions.Get(k)
						Dim tg As B4XDaisyToggle
						tg.Initialize(Me, "OptionToggle")
						tg.AddToParent(mInputHost, 0, itemY, inputW, 36dip)
						tg.setText(optText)
						tg.setTag(k)
						tg.setValue("" & k)
						If mbInputMultiple = False Then tg.setGroupName("swal_toggle_group")
						tg.setVariant(msInputVariant)
						If mInputValue <> Null Then
							If mInputValue Is List Then
								Dim lVal As List = mInputValue
								If lVal.IndexOf(k) >= 0 Then tg.setChecked(True)
							Else If "" & mInputValue = "" & k Then
								tg.setChecked(True)
							End If
						End If
						mOptionItems.Add(tg)
						itemY = itemY + 40dip
					Next
					inputH = itemY
				Else
					Dim tg As B4XDaisyToggle
					tg.Initialize(Me, "OptionToggle")
					tg.AddToParent(mInputHost, 0, 0, inputW, 36dip)
					If msInputLabel <> "" Then tg.setText(msInputLabel)
					tg.setTag("default")
					tg.setValue("default")
					tg.setVariant(msInputVariant)
					If mInputValue <> Null And (mInputValue Is Boolean) Then tg.setChecked(mInputValue)
					mOptionItems.Add(tg)
					inputH = 36dip
				End If
				
			Case "range"
				mRangeComp.Initialize(Me, "mRangeComp")
				mRangeComp.AddToParent(mInputHost, 0, 0, inputW, 32dip)
				' Range bounds/step forwarded from the swal input config.
				mRangeComp.setMinValue(miInputMin)
				mRangeComp.setMaxValue(miInputMax)
				mRangeComp.setStepValue(miInputStep)
				' Right-aligned live value readout + transient drag tooltip (auto-fades).
				mRangeComp.setShowValue(True)
				mRangeComp.setShowTooltip(True)
				' Prepend (-) / append (+) tap-to-step buttons.
				mRangeComp.setIconLeft("minus-solid.svg")
				mRangeComp.setIconRight("plus-solid.svg")
				If mInputValue <> Null Then mRangeComp.setValue(mInputValue)
				inputH = 40dip

			Case "rating"
				mRatingComp.Initialize(Me, "mRatingComp")
				mRatingComp.AddToParent(mInputHost, 0, 0, inputW, 40dip)
				mRatingComp.setVariant(msInputVariant)
				If mInputValue <> Null Then mRatingComp.setValue(mInputValue)
				inputH = 40dip
		End Select
		
		mInputHost.SetLayoutAnimated(0, 20dip, currentY, inputW, inputH)
		' Range renders a value readout under the thumb; give it more breathing room above the action row.
		Dim bottomGap As Int = 4dip
		If t = "range" Then bottomGap = 20dip
		currentY = currentY + inputH + bottomGap
		
		If msCurrentValidationError <> "" Then
			lblInputError.Visible = True
			lblInputError.Text = msCurrentValidationError
			lblInputError.SetLayoutAnimated(0, 20dip, currentY, inputW, 20dip)
			currentY = currentY + 32dip
		Else
			lblInputError.Visible = False
		End If
		currentY = currentY + 12dip
	Else
		mInputHost.Visible = False
		lblInputError.Visible = False
	End If

	' Handle Actions
	pnlActions.RemoveAllViews
	Dim btnCount As Int = 0
	If mbShowCancelButton Then btnCount = btnCount + 1
	If mbShowDenyButton Then btnCount = btnCount + 1
	If mbShowConfirmButton Then btnCount = btnCount + 1

	If btnCount > 0 Then
		Dim gap As Int = 8dip
		Dim availableW As Int = boxW - 40dip
		
		Dim reqConfirm As Int = 0
		Dim reqDeny As Int = 0
		Dim reqCancel As Int = 0
		If mbShowConfirmButton Then reqConfirm = EstimateButtonWidth(msConfirmButtonText)
		If mbShowDenyButton Then reqDeny = EstimateButtonWidth(msDenyButtonText)
		If mbShowCancelButton Then reqCancel = EstimateButtonWidth(msCancelButtonText)
		
		Dim requestedW As Int = reqConfirm + reqDeny + reqCancel
		If btnCount > 1 Then requestedW = requestedW + (btnCount - 1) * gap
		
		Dim bVertical As Boolean = (requestedW > availableW)
		Dim pnlActionsHeight As Int
		If bVertical Then
			pnlActionsHeight = (btnCount * 40dip) + ((btnCount - 1) * gap)
		Else
			pnlActionsHeight = 40dip
		End If
		
		pnlActions.SetLayoutAnimated(0, 0, currentY, boxW, pnlActionsHeight)
		
		Dim order() As String
		If mbReverseButtons Then
			order = Array As String("cancel", "deny", "confirm")
		Else
			order = Array As String("confirm", "deny", "cancel")
		End If
		
		If bVertical Then
			Dim currentYOfButton As Int = 0
			Dim btnW As Int = availableW
			For Each btnType As String In order
				Select Case btnType
					Case "cancel"
						If mbShowCancelButton Then
							btnCancel.AddToParent(pnlActions, 20dip, currentYOfButton, btnW, 40dip)
							btnCancel.Text = msCancelButtonText
							btnCancel.Variant = "error"
							btnCancel.Style = "outline"
							ApplyButtonColors(btnCancel, mCancelButtonColor, mCancelButtonTextColor)
							currentYOfButton = currentYOfButton + 40dip + gap
						End If
					Case "deny"
						If mbShowDenyButton Then
							btnDeny.AddToParent(pnlActions, 20dip, currentYOfButton, btnW, 40dip)
							btnDeny.Text = msDenyButtonText
							btnDeny.Variant = "warning"
							btnDeny.Style = "outline"
							ApplyButtonColors(btnDeny, mDenyButtonColor, mDenyButtonTextColor)
							currentYOfButton = currentYOfButton + 40dip + gap
						End If
					Case "confirm"
						If mbShowConfirmButton Then
							btnConfirm.AddToParent(pnlActions, 20dip, currentYOfButton, btnW, 40dip)
							btnConfirm.Text = msConfirmButtonText
							btnConfirm.Variant = "primary"
							ApplyButtonColors(btnConfirm, mConfirmButtonColor, mConfirmButtonTextColor)
							currentYOfButton = currentYOfButton + 40dip + gap
						End If
				End Select
			Next
		Else
			Dim totalW As Int = requestedW
			Dim startX As Int = 20dip + (availableW - totalW) / 2
			
			For Each btnType As String In order
				Select Case btnType
					Case "cancel"
						If mbShowCancelButton Then
							Dim w As Int = reqCancel
							btnCancel.AddToParent(pnlActions, startX, 0, w, 40dip)
							btnCancel.Text = msCancelButtonText
							btnCancel.Variant = "error"
							btnCancel.Style = "outline"
							ApplyButtonColors(btnCancel, mCancelButtonColor, mCancelButtonTextColor)
							startX = startX + btnCancel.View.Width + gap
						End If
					Case "deny"
						If mbShowDenyButton Then
							Dim w As Int = reqDeny
							btnDeny.AddToParent(pnlActions, startX, 0, w, 40dip)
							btnDeny.Text = msDenyButtonText
							btnDeny.Variant = "warning"
							btnDeny.Style = "outline"
							ApplyButtonColors(btnDeny, mDenyButtonColor, mDenyButtonTextColor)
							startX = startX + btnDeny.View.Width + gap
						End If
					Case "confirm"
						If mbShowConfirmButton Then
							Dim w As Int = reqConfirm
							btnConfirm.AddToParent(pnlActions, startX, 0, w, 40dip)
							btnConfirm.Text = msConfirmButtonText
							btnConfirm.Variant = "primary"
							ApplyButtonColors(btnConfirm, mConfirmButtonColor, mConfirmButtonTextColor)
							startX = startX + btnConfirm.View.Width + gap
						End If
				End Select
			Next
		End If
		
		currentY = currentY + pnlActionsHeight + 20dip
	End If

	' Handle Footer
	If msFooter <> "" Then
		lblFooter.Visible = True
		lblFooter.Text = msFooter
		lblFooter.SetLayoutAnimated(0, 20dip, currentY, boxW - 40dip, 20dip)
		currentY = currentY + lblFooter.GetComputedHeight + 20dip
	Else
		lblFooter.Visible = False
	End If

	' Center Modal (horizontal only - vertical is managed by RepositionModal when keyboard is open)
	Dim finalH As Int = currentY
	Dim left As Int = Max(0, (mBase.Width - boxW) / 2)
	Dim top As Int = 0
	If mbKeyboardOpen = False Or miKeyboardHeight = 0 Then
		top = Max(0, (mScrollView.Height - finalH) / 2)
	End If
	mContentBox.SetLayoutAnimated(0, left, top, boxW, finalH)
	' Size the ScrollView inner panel to fit the card, else children clip.
	mScrollView.Panel.Height = Max(finalH, mScrollView.Height)
	If mbKeyboardOpen And miKeyboardHeight > 0 Then
		RepositionModal
	End If
End Sub

' Displays the SweetAlert popup without waiting for a result.
Public Sub Show
	ShowAsync
End Sub

' -
' PROMISE / ASYNC RESOLUTION
' -
Public Sub ShowAsync As ResumableSub
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("mBase")
		DesignerCreateView(p, Null, Null)
	End If

	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	mParent.AddView(mBase, 0, 0, mParent.Width, mParent.Height)
	mBase.BringToFront

	mBase.Visible = True
	mIsOpen = True
	' mBase now has its real size: sync backdrop/scrollview before Refresh,
	' else they keep the 0 size from DesignerCreateView time.
	mBackdrop.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
	mScrollView.Width = mBase.Width
	mScrollView.Height = mBase.Height
	#If B4A
	miPrevRootHeight = GetVisibleWindowHeight
	#Else
	miPrevRootHeight = mBase.Height
	#End If
	If miPrevRootHeight = 0 Then miPrevRootHeight = mBase.Height
	mbKeyboardOpen = False
	miKeyboardHeight = 0
	#If B4A
	If mBase.Height > 0 And miPrevRootHeight > 0 And (mBase.Height - miPrevRootHeight >= 100dip) Then
		mbKeyboardOpen = True
		miKeyboardHeight = mBase.Height - miPrevRootHeight
	End If
	#End If
	mKeyboardTimer.Enabled = True
	If msInputType <> "none" And msInputType <> "" Then
		CallSubDelayed(Me, "FocusInput")
	End If

	Refresh

	If IsAnimatedIcon(msIcon) And mSweetAlertIcon.mBase.IsInitialized Then
		mSweetAlertIcon.Play
	End If

	Dim finalLeft As Int = mContentBox.Left
	Dim finalTop As Int = mContentBox.Top
	Dim startTop As Int = finalTop + 50dip
	mContentBox.SetLayoutAnimated(0, finalLeft, startTop, mContentBox.Width, mContentBox.Height)
	mContentBox.SetLayoutAnimated(300, finalLeft, finalTop, mContentBox.Width, mContentBox.Height)

	mBackdrop.Color = xui.Color_Transparent
	mBackdrop.SetColorAnimated(300, xui.Color_Transparent, xui.Color_ARGB(160, 0, 0, 0))

	If miTimerMs > 0 Then
		mAutoCloseTimer.Interval = miTimerMs
		mAutoCloseTimer.Enabled = True
	End If

	Wait For (Me) Result (Res As B4XDaisySweetAlertResult)
	Return Res
End Sub

' Emulates SweetAlert2's showLoading()
Public Sub showLoading
	msIcon = "loading"
	If btnConfirm.IsInitialized Then btnConfirm.Disabled = True
	If btnDeny.IsInitialized Then btnDeny.Disabled = True
	If btnCancel.IsInitialized Then btnCancel.Disabled = True
	Refresh
	If mIsOpen And mSweetAlertIcon.mBase.IsInitialized Then
		mSweetAlertIcon.Play
	End If
End Sub

' Hides loader and re-enables action buttons
Public Sub hideLoading
	If msIcon = "loading" Then
		msIcon = "none"
		If mSweetAlertIcon.mBase.IsInitialized Then mSweetAlertIcon.Stop
	End If
	If btnConfirm.IsInitialized Then btnConfirm.Disabled = False
	If btnDeny.IsInitialized Then btnDeny.Disabled = False
	If btnCancel.IsInitialized Then btnCancel.Disabled = False
	Refresh
End Sub

' Batch-update an open popup (approximates Swal.update())
Public Sub Update(mConfig As Map)
	If mConfig <> Null And mConfig.IsInitialized Then
		ApplyDesignerProps(mConfig)
		Refresh
	End If
End Sub

' -
' PUBLIC CLOSE API
' -
Public Sub Close
	CloseWithReason("close")
End Sub

Public Sub CloseWithReason(sReason As String)
	If mIsOpen Then DismissWithReason(sReason)
End Sub

Public Sub GetDismissReason As Map
	Return CreateMap("backdrop": "backdrop", "cancel": "cancel", "close": "close", "esc": "esc", "timer": "timer")
End Sub

' -
' EVENT HANDLERS
' -
Private Sub AutoCloseTimer_Tick
	mAutoCloseTimer.Enabled = False
	DismissWithReason("timer")
End Sub

Private Sub mContentBox_Click
	' Consume click to prevent pass-through
End Sub

Private Sub mBase_Click
	' Consume click to prevent pass-through to underlying page
End Sub

Private Sub mBackdrop_Click
	If mbAllowOutsideClick Then
		DismissWithReason("backdrop")
	End If
End Sub

Public Sub btnConfirm_Click(oTag As Object)
	If msInputType <> "none" And msInputType <> "" Then
		Dim val As Object = GetActiveInputValue
		Dim err As String = ValidateActiveInput(val)
		If err <> "" Then
			msCurrentValidationError = err
			Refresh
			Return
		End If
	End If
	msCurrentValidationError = ""
	Dim finalVal As Object = GetActiveInputValue
	ResolveResultWithValue(True, False, False, "", finalVal)
End Sub

Public Sub btnDeny_Click(oTag As Object)
	ResolveResult(False, True, False, "")
End Sub

Public Sub btnCancel_Click(oTag As Object)
	DismissWithReason("cancel")
End Sub

Public Sub btnClose_Click(oTag As Object)
	DismissWithReason("close")
End Sub

Private Sub DismissWithReason(sReason As String)
	ResolveResult(False, False, True, sReason)
End Sub

Private Sub ResolveResult(bIsConfirmed As Boolean, bIsDenied As Boolean, bIsDismissed As Boolean, sDismissReason As String)
	ResolveResultWithValue(bIsConfirmed, bIsDenied, bIsDismissed, sDismissReason, Null)
End Sub

Private Sub ResolveResultWithValue(bIsConfirmed As Boolean, bIsDenied As Boolean, bIsDismissed As Boolean, sDismissReason As String, oResultValue As Object)
	If mIsOpen = False Then Return
	#If B4A
	HideSoftKeyboard
	#End If
	mIsOpen = False
	mAutoCloseTimer.Enabled = False
	mKeyboardTimer.Enabled = False
	miPrevRootHeight = 0
	mbKeyboardOpen = False
	miKeyboardHeight = 0
	mResult.Initialize
	mResult.IsConfirmed = bIsConfirmed
	mResult.IsDenied = bIsDenied
	mResult.IsDismissed = bIsDismissed
	mResult.Dismiss = sDismissReason
	mResult.Value = oResultValue

	mBackdrop.SetColorAnimated(200, mBackdrop.Color, xui.Color_Transparent)
	Sleep(200)

	mBase.Visible = False
	mBase.RemoveViewFromParent
	CallSubDelayed2(Me, "Result", mResult)
End Sub

Private Sub mInputComp_EnterPressed (sText As String)
	If msInputType.ToLowerCase <> "textarea" And mbShowConfirmButton Then
		btnConfirm_Click(Null)
	End If
End Sub

Public Sub GetActiveInputValue As Object
	Select Case msInputType.ToLowerCase
		Case "text", "password", "email", "number", "tel", "textarea"
			If mInputComp.IsInitialized Then Return mInputComp.getText
		Case "select"
			If mSelectComp.IsInitialized Then Return mSelectComp.getSelectedValue
		Case "checkbox", "checkboxgroup"
			If mOptionItems.IsInitialized = False Or mOptionItems.Size = 0 Then Return Null
			' Standalone single (no InputOptions): boolean Checked state
			If mInputOptions.IsInitialized = False Or mInputOptions.Size = 0 Then
				Dim cb0 As B4XDaisyCheckbox = mOptionItems.Get(0)
				Return cb0.getChecked
			End If
			If mbInputMultiple Then
				Dim checked As List
				checked.Initialize
				For Each cb As B4XDaisyCheckbox In mOptionItems
					If cb.getChecked Then checked.Add(cb.getValue)
				Next
				Return checked
			Else
				For Each cb As B4XDaisyCheckbox In mOptionItems
					If cb.getChecked Then Return cb.getValue
				Next
			End If
		Case "radio", "radiogroup"
			If mOptionItems.IsInitialized Then
				For Each rb As B4XDaisyRadio In mOptionItems
					If rb.getChecked Then Return rb.getValue
				Next
			End If
		Case "toggle", "togglegroup"
			If mOptionItems.IsInitialized = False Or mOptionItems.Size = 0 Then Return Null
			If mInputOptions.IsInitialized = False Or mInputOptions.Size = 0 Then
				Dim tg0 As B4XDaisyToggle = mOptionItems.Get(0)
				Return tg0.getChecked
			End If
			If mbInputMultiple Then
				Dim checked As List
				checked.Initialize
				For Each tg As B4XDaisyToggle In mOptionItems
					If tg.getChecked Then checked.Add(tg.getValue)
				Next
				Return checked
			Else
				For Each tg As B4XDaisyToggle In mOptionItems
					If tg.getChecked Then Return tg.getValue
				Next
			End If
		Case "range"
			If mRangeComp.IsInitialized Then Return mRangeComp.getValue
		Case "rating"
			If mRatingComp.IsInitialized Then Return mRatingComp.getValue
	End Select
	Return Null
End Sub

Private Sub ValidateActiveInput(oVal As Object) As String
	If mbInputRequired Then
		If oVal = Null Then Return msInputErrorMessage
		' Multi-select returns a List: required means at least one selection
		If oVal Is List Then
			Dim lVal As List = oVal
			If lVal.Size = 0 Then Return msInputErrorMessage
			Return ""
		End If
		Dim sVal As String = oVal
		If sVal.Trim = "" Or sVal.Trim = "false" Then Return msInputErrorMessage
	End If
	If mValidatorCallback <> Null And msValidatorSub <> "" Then
		If xui.SubExists(mValidatorCallback, msValidatorSub, 1) Then
			Dim customErr As String = CallSub2(mValidatorCallback, msValidatorSub, oVal)
			If customErr <> "" Then Return customErr
		End If
	End If
	Return ""
End Sub

' -
' INPUT SETTERS & GETTERS
' -
Public Sub setInputType(sValue As String)
	msInputType = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputType As String
	Return msInputType
End Sub

Public Sub setInputPlaceholder(sValue As String)
	msInputPlaceholder = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputPlaceholder As String
	Return msInputPlaceholder
End Sub

Public Sub setInputValue(oValue As Object)
	mInputValue = oValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputValue As Object
	Return GetActiveInputValue
End Sub

Public Sub setInputMultiple(bValue As Boolean)
	mbInputMultiple = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputMultiple As Boolean
	Return mbInputMultiple
End Sub

' Range-only: minimum slider value.
Public Sub setInputMin(iValue As Int)
	miInputMin = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputMin As Int
	Return miInputMin
End Sub

' Range-only: maximum slider value.
Public Sub setInputMax(iValue As Int)
	miInputMax = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputMax As Int
	Return miInputMax
End Sub

' Range-only: step increment (0 = continuous).
Public Sub setInputStep(iValue As Int)
	miInputStep = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputStep As Int
	Return miInputStep
End Sub

Public Sub setInputLabel(sValue As String)
	msInputLabel = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getInputLabel As String
	Return msInputLabel
End Sub

Public Sub setInputErrorMessage(sValue As String)
	msInputErrorMessage = sValue
End Sub

Public Sub getInputErrorMessage As String
	Return msInputErrorMessage
End Sub

Public Sub setInputRequired(bValue As Boolean)
	mbInputRequired = bValue
End Sub

Public Sub getInputRequired As Boolean
	Return mbInputRequired
End Sub

Public Sub setInputOptions(mOptions As Map)
	mInputOptions = mOptions
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub setInputValidator(oCallback As Object, sSubName As String)
	mValidatorCallback = oCallback
	msValidatorSub = sSubName
End Sub

' -
' SETTERS & GETTERS
' -
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub getView As B4XView
	Return View
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub
Public Sub setParent(vParent As B4XView)
	mParent = vParent
End Sub

Public Sub getParent As B4XView
	Return mParent
End Sub

Public Sub setTitle(sValue As String)
	msTitle = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTitle As String
	Return msTitle
End Sub

Public Sub setText(sValue As String)
	msText = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getText As String
	Return msText
End Sub

Public Sub setIcon(sValue As String)
	msIcon = sValue.ToLowerCase
	If mBase.IsInitialized Then 
		Refresh
		If mIsOpen And IsAnimatedIcon(msIcon) And mSweetAlertIcon.mBase.IsInitialized Then
			mSweetAlertIcon.Play
		End If
	End If
End Sub

Public Sub getIcon As String
	Return msIcon
End Sub

Public Sub setIconColor(iValue As Int)
	mIconColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconColor As Int
	Return mIconColor
End Sub

Public Sub setIconSize(iValue As Int)
	mIconSize = Max(24dip, iValue * 1dip)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconSize As Int
	Return mIconSize / 1dip
End Sub

Public Sub setShowConfirmButton(bValue As Boolean)
	mbShowConfirmButton = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowConfirmButton As Boolean
	Return mbShowConfirmButton
End Sub

Public Sub setConfirmButtonText(sValue As String)
	msConfirmButtonText = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getConfirmButtonText As String
	Return msConfirmButtonText
End Sub

Public Sub setConfirmButtonColor(iValue As Int)
	mConfirmButtonColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getConfirmButtonColor As Int
	Return mConfirmButtonColor
End Sub

Public Sub setConfirmButtonTextColor(iValue As Int)
	mConfirmButtonTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getConfirmButtonTextColor As Int
	Return mConfirmButtonTextColor
End Sub

Public Sub setShowDenyButton(bValue As Boolean)
	mbShowDenyButton = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowDenyButton As Boolean
	Return mbShowDenyButton
End Sub

Public Sub setDenyButtonText(sValue As String)
	msDenyButtonText = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getDenyButtonText As String
	Return msDenyButtonText
End Sub

Public Sub setDenyButtonColor(iValue As Int)
	mDenyButtonColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getDenyButtonColor As Int
	Return mDenyButtonColor
End Sub

Public Sub setDenyButtonTextColor(iValue As Int)
	mDenyButtonTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getDenyButtonTextColor As Int
	Return mDenyButtonTextColor
End Sub

Public Sub setShowCancelButton(bValue As Boolean)
	mbShowCancelButton = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowCancelButton As Boolean
	Return mbShowCancelButton
End Sub

Public Sub setCancelButtonText(sValue As String)
	msCancelButtonText = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCancelButtonText As String
	Return msCancelButtonText
End Sub

Public Sub setCancelButtonColor(iValue As Int)
	mCancelButtonColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCancelButtonColor As Int
	Return mCancelButtonColor
End Sub

Public Sub setCancelButtonTextColor(iValue As Int)
	mCancelButtonTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCancelButtonTextColor As Int
	Return mCancelButtonTextColor
End Sub

Public Sub setShowCloseButton(bValue As Boolean)
	mbShowCloseButton = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShowCloseButton As Boolean
	Return mbShowCloseButton
End Sub

Public Sub setAllowOutsideClick(bValue As Boolean)
	mbAllowOutsideClick = bValue
End Sub

Public Sub getAllowOutsideClick As Boolean
	Return mbAllowOutsideClick
End Sub

Public Sub setReverseButtons(bValue As Boolean)
	mbReverseButtons = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getReverseButtons As Boolean
	Return mbReverseButtons
End Sub

Public Sub setFooter(sValue As String)
	msFooter = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getFooter As String
	Return msFooter
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackgroundColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setWidth(iValue As Int)
	mModalWidth = Max(200dip, iValue * 1dip)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getWidth As Int
	Return mModalWidth / 1dip
End Sub

Public Sub setTimerMs(iValue As Int)
	miTimerMs = Max(0, iValue)
End Sub

Public Sub getTimerMs As Int
	Return miTimerMs
End Sub

Public Sub setRounded(sValue As String)
	msRounded = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Private Sub ApplyButtonColors(btn As B4XDaisyButton, iBackColor As Int, iTextColor As Int)
	' Transparent means "derive from the button variant", so it is safe to pass
	' the raw fields through on every refresh.
	btn.setBackgroundColor(iBackColor)
	btn.setTextColor(iTextColor)
End Sub

Private Sub EstimateButtonWidth(sText As String) As Int
	If sText = "" Then Return 0
	Dim textW As Int = sText.Length * 8dip
	Return Max(80dip, textW + 40dip)
End Sub

' ===== Keyboard detection & modal repositioning =====

#If B4A
Private Sub GetVisibleWindowHeight As Int
	Try
		Dim joBase As JavaObject = mBase
		Dim joRect As JavaObject
		joRect.InitializeNewInstance("android.graphics.Rect", Null)
		joBase.RunMethod("getWindowVisibleDisplayFrame", Array(joRect))
		Dim iBottom As Int = joRect.GetField("bottom")
		Dim iTop As Int = joRect.GetField("top")
		Return iBottom - iTop
	Catch
		Log("B4XDaisySweetAlert.GetVisibleWindowHeight: " & LastException.Message)
		Return 0
	End Try
End Sub
#End If

Private Sub KeyboardTimer_Tick
	If mIsOpen = False Then
		mKeyboardTimer.Enabled = False
		Return
	End If
	#If B4A
	Dim iVisHeight As Int = GetVisibleWindowHeight
	If iVisHeight <= 0 Then Return
	If miPrevRootHeight = 0 Then miPrevRootHeight = iVisHeight
	If iVisHeight > miPrevRootHeight Then miPrevRootHeight = iVisHeight

	Dim iDiff As Int = miPrevRootHeight - iVisHeight
	If mbKeyboardOpen Then
		If iDiff < 100dip Then
			mbKeyboardOpen = False
			miKeyboardHeight = 0
			RepositionModal
		Else If Abs(miKeyboardHeight - iDiff) > 10dip Then
			miKeyboardHeight = iDiff
			RepositionModal
		End If
	Else
		If iDiff >= 100dip Then
			mbKeyboardOpen = True
			miKeyboardHeight = iDiff
			RepositionModal
		End If
	End If
	#End If
End Sub

Private Sub RepositionModal
	If mIsOpen = False Then Return
	Dim iCardW As Int = mContentBox.Width
	If iCardW <= 0 Then iCardW = Min(mModalWidth, mBase.Width - 32dip)
	Dim iCardH As Int = mContentBox.Height
	Dim iAvailH As Int = mBase.Height
	If mbKeyboardOpen And miKeyboardHeight > 0 Then
		iAvailH = Max(120dip, mBase.Height - miKeyboardHeight)
	End If

	' Resize ScrollView viewport so it never extends behind the soft keyboard
	mScrollView.Height = iAvailH

	Dim iLeft As Int = Max(0, (mBase.Width - iCardW) / 2)
	Dim iTop As Int = 0

	If iCardH <= iAvailH Then
		iTop = (iAvailH - iCardH) / 2
		mScrollView.Panel.Height = iAvailH
		mContentBox.SetLayoutAnimated(0, iLeft, iTop, iCardW, iCardH)
		mScrollView.ScrollPosition = 0
	Else
		iTop = 10dip
		Dim iPanelH As Int = iCardH + 30dip
		mScrollView.Panel.Height = iPanelH
		mContentBox.SetLayoutAnimated(0, iLeft, iTop, iCardW, iCardH)
		If mbKeyboardOpen Then
			ScrollToInput
		Else
			mScrollView.ScrollPosition = 0
		End If
	End If
End Sub

Private Sub ScrollToInput
	If mInputHost.IsInitialized = False Then Return
	If mbKeyboardOpen = False Then Return
	Dim iInputTopInCard As Int = mInputHost.Top
	Dim iCardTop As Int = mContentBox.Top
	Dim iSvHeight As Int = mScrollView.Height

	Dim iTargetBottom As Int
	If pnlActions.IsInitialized And pnlActions.Visible And pnlActions.Height > 0 Then
		iTargetBottom = iCardTop + pnlActions.Top + pnlActions.Height + 10dip
	Else
		iTargetBottom = iCardTop + iInputTopInCard + mInputHost.Height + 40dip
	End If

	If iTargetBottom > iSvHeight Then
		Dim iDesiredScroll As Int = iTargetBottom - iSvHeight
		Dim iMaxScrollBeforeInputHidden As Int = Max(0, iCardTop + iInputTopInCard - 10dip)
		mScrollView.ScrollPosition = Min(iDesiredScroll, iMaxScrollBeforeInputHidden)
	Else
		mScrollView.ScrollPosition = 0
	End If
End Sub

' Resize entry point (B4X custom view). Fired when the parent resizes,
' e.g. Activity with adjustResize when the keyboard opens/closes.
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If mBackdrop.IsInitialized Then mBackdrop.SetLayoutAnimated(0, 0, 0, dWidth, dHeight)
	If mScrollView.IsInitialized Then
		mScrollView.Width = dWidth
		mScrollView.Height = dHeight
	End If
	' No Refresh here: it rebuilds input views from mInputValue and would
	' wipe in-progress typing. Reposition only.
	RepositionModal
End Sub

' Direct IME hook. Main forwards IME_HeightChanged to the top B4XPage;
' the host page can forward it here for instant repositioning.
' (Timer polling in KeyboardTimer_Tick remains as autonomous fallback.)
Public Sub IME_HeightChanged(iNewHeight As Int, iOldHeight As Int)
	If mIsOpen = False Then Return
	Dim iKb As Int = iOldHeight - iNewHeight
	If iKb > 100dip Then
		mbKeyboardOpen = True
		miKeyboardHeight = iKb
		miPrevRootHeight = iOldHeight
		RepositionModal
	Else If iNewHeight >= iOldHeight - 50dip Then
		mbKeyboardOpen = False
		miKeyboardHeight = 0
		RepositionModal
	End If
End Sub

Private Sub FocusInput
	If mInputComp.IsInitialized = False Then Return
	Select Case msInputType.ToLowerCase
		Case "text", "password", "email", "number", "tel", "textarea"
			mInputComp.RequestFocus
			#If B4A
			Sleep(150)
			ShowSoftKeyboard
			#End If
	End Select
End Sub

#If B4A
Private Sub ShowSoftKeyboard
	Try
		Dim joContext As JavaObject
		joContext.InitializeContext
		Dim joImm As JavaObject = joContext.RunMethod("getSystemService", Array("input_method"))
		Dim joEdit As JavaObject = FindEditText(mInputHost)
		If joEdit.IsInitialized Then
			joEdit.RunMethod("requestFocus", Null)
			joImm.RunMethod("showSoftInput", Array(joEdit, 1)) ' 1 = SHOW_IMPLICIT
		End If
	Catch
		Log("B4XDaisySweetAlert.ShowSoftKeyboard: " & LastException.Message)
	End Try
End Sub

Private Sub HideSoftKeyboard
	Try
		Dim joContext As JavaObject
		joContext.InitializeContext
		Dim joImm As JavaObject = joContext.RunMethod("getSystemService", Array("input_method"))
		Dim joEdit As JavaObject = FindEditText(mInputHost)
		If joEdit.IsInitialized Then
			Dim oToken As Object = joEdit.RunMethod("getWindowToken", Null)
			If oToken <> Null Then
				joImm.RunMethod("hideSoftInputFromWindow", Array(oToken, 0))
			End If
		Else If mBase.IsInitialized Then
			Dim joBase As JavaObject = mBase
			Dim oBaseToken As Object = joBase.RunMethod("getWindowToken", Null)
			If oBaseToken <> Null Then
				joImm.RunMethod("hideSoftInputFromWindow", Array(oBaseToken, 0))
			End If
		End If
	Catch
		Log("B4XDaisySweetAlert.HideSoftKeyboard: " & LastException.Message)
	End Try
End Sub

Private Sub FindEditText(vParent As B4XView) As JavaObject
	Dim nullJo As JavaObject
	If vParent.IsInitialized = False Then Return nullJo
	Try
		Dim joParent As JavaObject = vParent
		Dim iCount As Int = joParent.RunMethod("getChildCount", Null)
		Dim i As Int
		For i = 0 To iCount - 1
			Dim joChild As JavaObject = joParent.RunMethod("getChildAt", Array(i))
			Dim sChildType As String = GetType(joChild)
			If sChildType.Contains("EditText") Then
				Return joChild
			Else If sChildType.Contains("ViewGroup") Or sChildType.Contains("Panel") Or sChildType.Contains("Layout") Then
				Dim joFound As JavaObject = FindEditTextInViewGroup(joChild)
				If joFound.IsInitialized Then Return joFound
			End If
		Next
	Catch
		Log("B4XDaisySweetAlert.FindEditText: " & LastException.Message)
	End Try
	Return nullJo
End Sub

Private Sub FindEditTextInViewGroup(joGroup As JavaObject) As JavaObject
	Dim nullJo As JavaObject
	Try
		Dim iCount As Int = joGroup.RunMethod("getChildCount", Null)
		Dim i As Int
		For i = 0 To iCount - 1
			Dim joChild As JavaObject = joGroup.RunMethod("getChildAt", Array(i))
			Dim sChildType As String = GetType(joChild)
			If sChildType.Contains("EditText") Then
				Return joChild
			Else If sChildType.Contains("ViewGroup") Or sChildType.Contains("Panel") Or sChildType.Contains("Layout") Then
				Dim joFound As JavaObject = FindEditTextInViewGroup(joChild)
				If joFound.IsInitialized Then Return joFound
			End If
		Next
	Catch
		Log("B4XDaisySweetAlert.FindEditTextInViewGroup: " & LastException.Message)
	End Try
	Return nullJo
End Sub

Private Sub DisallowParentIntercept(iAction As Int)
	If iAction = 0 Or iAction = 2 Then ' ACTION_DOWN or ACTION_MOVE
		Dim joCurrent As JavaObject = mBase
		Do While joCurrent.IsInitialized
			Dim joParentView As JavaObject
			Try
				joParentView = joCurrent.RunMethod("getParent", Null)
			Catch
				Exit
			End Try
			If joParentView.IsInitialized = False Then Exit
			Try
				joParentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
			Catch
			End Try
			
			' Stop climbing at ViewRootImpl to prevent platform exceptions
			Try
				Dim sParentClass As String = GetType(joParentView)
				If sParentClass.Contains("ViewRootImpl") Then Exit
			Catch
				Exit
			End Try
			
			joCurrent = joParentView
		Loop
	End If
End Sub
#End If

#Region Base Properties
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
