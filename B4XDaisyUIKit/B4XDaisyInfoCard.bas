B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: Click (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: InforType, DisplayName: Type, FieldType: String, DefaultValue: 1, List: 1|2|3|4|5|6, Description: Info card layout type (infobox 1-5 / badge card 6).
#DesignerProperty: Key: Effect, DisplayName: Effect, FieldType: String, DefaultValue: none, List: none|hover-zoom, Description: Press effect (hover-zoom / parity, mapped to touch press).
#DesignerProperty: Key: Icon, DisplayName: Icon, FieldType: String, DefaultValue: user-solid.svg, Description: SVG icon asset name (B4XDaisySvgIcon).
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0, Description: Icon column / glyph color (0 = use Variant).
#DesignerProperty: Key: IconTextColor, DisplayName: Icon Text Color, FieldType: Color, DefaultValue: 0, Description: Icon glyph color (0 = white).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Theme color variant for the icon accent.
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: Employees, Description: Title text.

#DesignerProperty: Key: Value, DisplayName: Value, FieldType: String, DefaultValue: 1000, Description: Numeric target value for the count-up.
#DesignerProperty: Key: StartFrom, DisplayName: Start From, FieldType: Float, DefaultValue: 0, Description: Count-up start value.
#DesignerProperty: Key: Prefix, DisplayName: Prefix, FieldType: String, DefaultValue:, Description: Text before the value (e.g. $).
#DesignerProperty: Key: Suffix, DisplayName: Suffix, FieldType: String, DefaultValue:, Description: Text after the value (e.g. %, px).
#DesignerProperty: Key: Separator, DisplayName: Separator, FieldType: String, DefaultValue: ,, Description: Thousands grouping separator (used when Use Grouping is on).
#DesignerProperty: Key: Decimal, DisplayName: Decimal, FieldType: String, DefaultValue: ., Description: Decimal separator character.
#DesignerProperty: Key: DecimalPlaces, DisplayName: Decimal Places, FieldType: Int, DefaultValue: 0, Description: Number of decimal places.
#DesignerProperty: Key: UseGrouping, DisplayName: Use Grouping, FieldType: Boolean, DefaultValue: True, Description: Enable thousands grouping separator.
#DesignerProperty: Key: Animated, DisplayName: Animated, FieldType: Boolean, DefaultValue: True, Description: Animate the value from Start From to Value.
#DesignerProperty: Key: Duration, DisplayName: Duration (s), FieldType: Int, DefaultValue: 2, Description: Count-up duration in seconds.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0, Description: Card background (0 = base-100).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0, Description: Title/value text color (0 = base-content).
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: sm, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level.

#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#End Region

#Region Variables
Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String
	Private mCallBack As Object
	Private mTag As Object

	' --- Designer / public state ---
	Private msInforType As String = "1"
	Private msEffect As String = "none"
	Private msIcon As String = "user-solid.svg"
	Private mcIconColor As Int = 0
	Private mcIconTextColor As Int = 0
	Private msVariant As String = "none"
	Private msTitle As String = "Employees"
	Private msValue As String = "1000"
	Private mfStartFrom As Float = 0
	Private msPrefix As String = ""
	Private msSuffix As String = ""
	Private msSeparator As String = ","
	Private msDecimal As String = "."
	Private miDecimalPlaces As Int = 0
	Private mbUseGrouping As Boolean = True
	Private mbAnimated As Boolean = True
	Private miDuration As Int = 2
	Private mcBackgroundColor As Int = 0
	Private mcTextColor As Int = 0
	Private msShadow As String = "sm"
	Private mbEnabled As Boolean = True
	Private mbVisible As Boolean = True

	' --- Internal views ---
	Private pnlIcon As B4XView
	Private svgIcon As B4XDaisySvgIcon
	Private pnlContent As B4XView
	Private lblTitle As B4XDaisyText
	Private lblValue As B4XDaisyText
	Private mbIconCreated As Boolean = False

	' --- Count-up animation ---
	Private CountUpTimer As Timer
	Private AnimIndex As Int = 0
	Private mfStartVal As Float = 0
	Private mfTargetVal As Float = 0
	Private mfCurrentValue As Float = 0
	Private AnimStartTime As Long
	Private AnimDurationMs As Long
	Private Anim As B4XDaisyAnimation

	' --- Press state ---
	Private mbPressed As Boolean = False
	Private mfDownY As Float = 0 ' finger Y at ACTION_DOWN (scroll-vs-tap discrimination)
	Private inResize As Boolean = False
End Sub
#End Region

#Region Initialization
Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	Anim.Initialize
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	' Icon column / badge panel
	Dim pI As Panel
	pI.Initialize("")
	pnlIcon = pI
	pnlIcon.Color = xui.Color_Transparent
	mBase.AddView(pnlIcon, 0, 0, 0, 0)

	' Content panel
	Dim pC As Panel
	pC.Initialize("")
	pnlContent = pC
	pnlContent.Color = xui.Color_Transparent
	mBase.AddView(pnlContent, 0, 0, 0, 0)

	' Mark all child panels as non-clickable/non-focusable so they don't
	' consume touch events before they reach mBase_Touch.
	#If B4A
	Dim joIcon As JavaObject = pnlIcon
	joIcon.RunMethod("setClickable", Array(False))
	joIcon.RunMethod("setFocusable", Array(False))
	Dim joCont As JavaObject = pnlContent
	joCont.RunMethod("setClickable", Array(False))
	joCont.RunMethod("setFocusable", Array(False))
	#End If

	' Labels (B4XDaisyText reuses measurement + theming)
	Dim tp1 As Panel : tp1.Initialize("")
	lblTitle.Initialize(Me, "lblTitle")
	lblTitle.DesignerCreateView(tp1, Null, CreateMap("TextSize": "13"))
	lblTitle.Clickable = False
	mBase.AddView(lblTitle.mBase, 0, 0, 0, 0)

	Dim tp2 As Panel : tp2.Initialize("")
	lblValue.Initialize(Me, "lblValue")
	lblValue.DesignerCreateView(tp2, Null, CreateMap("TextSize": "26"))
	lblValue.Clickable = False
	mBase.AddView(lblValue.mBase, 0, 0, 0, 0)

	' Count-up timer
	CountUpTimer.Initialize("CountUpTimer", 16)
	CountUpTimer.Enabled = False

	ApplyDesignerProps(mProps)
	mBase.Visible = mbVisible
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	msInforType = B4XDaisyVariants.GetPropString(mProps, "InforType", msInforType)
	msEffect = B4XDaisyVariants.GetPropString(mProps, "Effect", msEffect)
	msIcon = B4XDaisyVariants.GetPropString(mProps, "Icon", msIcon)
	mcIconColor = B4XDaisyVariants.GetPropColor(mProps, "IconColor", mcIconColor)
	mcIconTextColor = B4XDaisyVariants.GetPropColor(mProps, "IconTextColor", mcIconTextColor)
	msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", msVariant))
	msTitle = B4XDaisyVariants.GetPropString(mProps, "Title", msTitle)
	msValue = B4XDaisyVariants.GetPropString(mProps, "Value", msValue)
	mfStartFrom = B4XDaisyVariants.GetPropFloat(mProps, "StartFrom", mfStartFrom)
	mfTargetVal = ParseValue(msValue)
	mfCurrentValue = mfStartFrom
	msPrefix = B4XDaisyVariants.GetPropString(mProps, "Prefix", msPrefix)
	msSuffix = B4XDaisyVariants.GetPropString(mProps, "Suffix", msSuffix)
	msSeparator = B4XDaisyVariants.GetPropString(mProps, "Separator", msSeparator)
	msDecimal = B4XDaisyVariants.GetPropString(mProps, "Decimal", msDecimal)
	miDecimalPlaces = B4XDaisyVariants.GetPropInt(mProps, "DecimalPlaces", miDecimalPlaces)
	mbUseGrouping = B4XDaisyVariants.GetPropBool(mProps, "UseGrouping", mbUseGrouping)
	mbAnimated = B4XDaisyVariants.GetPropBool(mProps, "Animated", mbAnimated)
	miDuration = B4XDaisyVariants.GetPropInt(mProps, "Duration", B4XDaisyVariants.GetPropInt(mProps, "AnimationDuration", miDuration))
	mcBackgroundColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mcBackgroundColor)
	mcTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mcTextColor)
	msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(mProps, "Shadow", msShadow))
	mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
	mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("InforType", msInforType)
	props.Put("Effect", msEffect)
	props.Put("Icon", msIcon)
	props.Put("IconColor", mcIconColor)
	props.Put("IconTextColor", mcIconTextColor)
	props.Put("Variant", msVariant)
	props.Put("Title", msTitle)
	props.Put("Value", msValue)
	props.Put("StartFrom", mfStartFrom)
	props.Put("Prefix", msPrefix)
	props.Put("Suffix", msSuffix)
	props.Put("Separator", msSeparator)
	props.Put("Decimal", msDecimal)
	props.Put("DecimalPlaces", miDecimalPlaces)
	props.Put("UseGrouping", mbUseGrouping)
	props.Put("Animated", mbAnimated)
	props.Put("Duration", miDuration)
	props.Put("BackgroundColor", mcBackgroundColor)
	props.Put("TextColor", mcTextColor)
	props.Put("Shadow", msShadow)
	props.Put("Enabled", mbEnabled)
	props.Put("Visible", mbVisible)
	Return props
End Sub
#End Region

#Region Public API
''' <summary>
''' Applies the current state to the UI and (re)runs the count-up if enabled.
''' </summary>
Public Sub Refresh
	If mBase.IsInitialized = False Then Return
	If mbEnabled Then mBase.Alpha = 1.0 Else mBase.Alpha = 0.4
	#If B4A
	B4XDaisyVariants.DisableClippingRecursive(mBase)
	#End If
	Base_Resize(mBase.Width, mBase.Height)
	' Run count-up from current value to target
	If mbAnimated Then
		StartCountUp(mfCurrentValue, mfTargetVal)
	Else
		mfCurrentValue = mfTargetVal
		UpdateValueLabel
	End If
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("mBase")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub getComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub UpdateTheme
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
		Base_Resize(iWidth, iHeight)
	End If
End Sub

' --- Properties: type / effect ---

Public Sub setInforType(sValue As String)
	msInforType = sValue.ToLowerCase.Trim
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getInforType As String
	Return msInforType
End Sub

Public Sub setEffect(sValue As String)
	msEffect = sValue.ToLowerCase.Trim
	' effect is applied on press; no refresh needed
End Sub
Public Sub getEffect As String
	Return msEffect
End Sub

' --- Icon ---

Public Sub setIcon(sValue As String)
	msIcon = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getIcon As String
	Return msIcon
End Sub

Public Sub setIconColor(iValue As Int)
	mcIconColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getIconColor As Int
	Return mcIconColor
End Sub

Public Sub setIconTextColor(iValue As Int)
	mcIconTextColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getIconTextColor As Int
	Return mcIconTextColor
End Sub

Public Sub setVariant(sValue As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getVariant As String
	Return msVariant
End Sub

' --- Text ---

Public Sub setTitle(sValue As String)
	msTitle = sValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getTitle As String
	Return msTitle
End Sub

' --- Value / count-up ---

Public Sub setValue(sValue As String)
	msValue = sValue
	mfTargetVal = ParseValue(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getValue As String
	Return msValue
End Sub

Public Sub setStartFrom(fValue As Float)
	mfStartFrom = fValue
End Sub
Public Sub getStartFrom As Float
	Return mfStartFrom
End Sub

Public Sub setPrefix(sValue As String)
	msPrefix = sValue
	UpdateValueLabel
End Sub
Public Sub getPrefix As String
	Return msPrefix
End Sub

Public Sub setSuffix(sValue As String)
	msSuffix = sValue
	UpdateValueLabel
End Sub
Public Sub getSuffix As String
	Return msSuffix
End Sub

Public Sub setSeparator(sValue As String)
	msSeparator = sValue
	UpdateValueLabel
End Sub
Public Sub getSeparator As String
	Return msSeparator
End Sub

Public Sub setDecimal(sValue As String)
	msDecimal = sValue
	UpdateValueLabel
End Sub
Public Sub getDecimal As String
	Return msDecimal
End Sub

Public Sub setDecimalPlaces(iValue As Int)
	miDecimalPlaces = iValue
	UpdateValueLabel
End Sub
Public Sub getDecimalPlaces As Int
	Return miDecimalPlaces
End Sub

Public Sub setUseGrouping(bValue As Boolean)
	mbUseGrouping = bValue
	UpdateValueLabel
End Sub
Public Sub getUseGrouping As Boolean
	Return mbUseGrouping
End Sub

Public Sub setAnimated(bValue As Boolean)
	mbAnimated = bValue
End Sub
Public Sub getAnimated As Boolean
	Return mbAnimated
End Sub

Public Sub setDuration(iValue As Int)
	miDuration = Max(0, iValue)
End Sub
Public Sub getDuration As Int
	Return miDuration
End Sub

' --- Colors / style ---

Public Sub setBackgroundColor(iValue As Int)
	mcBackgroundColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub setTextColor(iValue As Int)
	mcTextColor = iValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getTextColor As Int
	Return mcTextColor
End Sub

Public Sub setShadow(sValue As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(sValue)
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setEnabled(bValue As Boolean)
	mbEnabled = bValue
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub
Public Sub getEnabled As Boolean
	Return mbEnabled
End Sub

Public Sub setVisible(bValue As Boolean)
	mbVisible = bValue
	If mBase.IsInitialized Then mBase.Visible = bValue
End Sub
Public Sub getVisible As Boolean
	Return mbVisible
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub
Public Sub getTag As Object
	Return mTag
End Sub

Public Sub getRole As String
	Return "infocard"
End Sub
#End Region

#Region Layout
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	Select Case msInforType
		Case "1", "2", "3"
			LayoutIconLeft(w, h)
		Case "4", "5"
			LayoutWatermark(w, h)
		Case Else
			LayoutIconLeft(w, h)
	End Select
	' DisableClipping AFTER layout so child views are already positioned
	#If B4A
	B4XDaisyVariants.DisableClippingRecursive(mBase)
	#End If
	inResize = False
End Sub

' Family A: icon column on the left + content (types 1, 2, 3)
Private Sub LayoutIconLeft(iW As Int, iH As Int)
	Dim cardH As Int = Max(80dip, iH)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, iW, cardH)
	ApplyCardSurface(mBase, ResolveCardBackground, B4XDaisyVariants.GetRadiusBoxDip(16dip))

	Dim iconColW As Int = 80dip
	' Icon column background per type
	Dim colBg As Int
	Select Case msInforType
		Case "1"
			colBg = ResolveIconColor
		Case "2"
			colBg = B4XDaisyVariants.AlphaColor(ResolveContentColor, 0.12)
		Case "3"
			colBg = xui.Color_Transparent
	End Select
	pnlIcon.Visible = (msIcon <> "")
	pnlIcon.SetLayoutAnimated(0, 0, 0, iconColW, cardH)
	pnlIcon.SetColorAndBorder(colBg, 0, 0, 0)

	If msIcon <> "" Then
		EnsureIcon(pnlIcon)
		Dim icSize As Int = 50dip
		svgIcon.mBase.SetLayoutAnimated(0, (iconColW - icSize) / 2, (cardH - icSize) / 2, icSize, icSize)
		svgIcon.SvgAsset = msIcon
		svgIcon.Clickable = False
		' Type 1: icon sits on a colored column -> white glyph. Types 2/3: colored glyph.
		If msInforType = "1" Then
			svgIcon.Color = ResolveIconTextColor
		Else
			svgIcon.Color = ResolveIconColor
		End If
		svgIcon.mBase.Visible = True
	End If

	' Content
	Dim contentX As Int = iconColW
	Dim contentW As Int = Max(1dip, iW - iconColW)
	pnlContent.Visible = True
	pnlContent.SetLayoutAnimated(0, contentX, 0, contentW, cardH)

	Dim padX As Int = 10dip
	Dim titleH As Int = Ceil(lblTitle.MeasureTextHeight)
	Dim valueH As Int = Ceil(lblValue.MeasureTextHeight)
	lblTitle.Text = msTitle
	lblTitle.SetTextColor(ResolveContentColor)
	lblTitle.SetTextAlignment("CENTER", "LEFT")
	lblTitle.mBase.Visible = (msTitle <> "")
	lblTitle.mBase.SetLayoutAnimated(0, contentX + padX, 11dip, Max(1dip, contentW - padX * 2), titleH)

	lblValue.Text = FormatValue(mfCurrentValue)
	lblValue.SetTextColor(ResolveValueColor)
	lblValue.SetTextAlignment("CENTER", "LEFT")
	lblValue.mBase.SetLayoutAnimated(0, contentX + padX, 11dip + titleH - 4dip, Max(1dip, contentW - padX * 2), valueH)

End Sub

' Family B: large faint/colored watermark icon bottom-right + content (types 4, 5)
Private Sub LayoutWatermark(iW As Int, iH As Int)
	Dim cardH As Int = Max(80dip, iH)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, iW, cardH)
	ApplyCardSurface(mBase, ResolveCardBackground, B4XDaisyVariants.GetRadiusBoxDip(16dip))

	pnlIcon.Visible = False
	pnlContent.Visible = True
	Dim padX As Int = 16dip
	pnlContent.SetLayoutAnimated(0, 0, 0, iW, cardH)

	Dim titleH As Int = Ceil(lblTitle.MeasureTextHeight)
	Dim valueH As Int = Ceil(lblValue.MeasureTextHeight)
	lblTitle.Text = msTitle
	lblTitle.SetTextColor(ResolveContentColor)
	lblTitle.SetTextAlignment("CENTER", "LEFT")
	lblTitle.mBase.Visible = (msTitle <> "")
	lblTitle.mBase.SetLayoutAnimated(0, padX, 11dip, iW - padX * 2, titleH)

	lblValue.Text = FormatValue(mfCurrentValue)
	lblValue.SetTextColor(ResolveValueColor)
	lblValue.SetTextAlignment("CENTER", "LEFT")
	lblValue.mBase.SetLayoutAnimated(0, padX, 11dip + titleH - 4dip, iW - padX * 2, valueH)

	' Watermark icon bottom-right
	If msIcon <> "" Then
		EnsureIcon(mBase)
		Dim icSize As Int = 60dip
		Dim ix As Int = iW - icSize - 10dip
		Dim iy As Int = cardH - icSize - 2dip   ' anchored bottom-right (CSS bottom:2px)
		svgIcon.mBase.SetLayoutAnimated(0, ix, iy, icSize, icSize)
		svgIcon.SvgAsset = msIcon
		svgIcon.Clickable = False
		If msInforType = "4" Then
			svgIcon.Color = B4XDaisyVariants.AlphaColor(ResolveContentColor, 0.15)
		Else
			svgIcon.Color = ResolveIconColor
		End If
		svgIcon.mBase.Visible = True
	svgIcon.mBase.SendToBack   ' watermark sits behind the content text
	End If

End Sub



' --- Shared helpers ---

Private Sub ApplyCardSurface(vTarget As B4XView, iBackColor As Int, fRadius As Float)
	vTarget.SetColorAndBorder(iBackColor, 0, 0, fRadius)
	#If B4A
	Try
		Dim jo As JavaObject = vTarget
		jo.RunMethod("setClipToOutline", Array(True))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyInfoCard.ApplyCardSurface: " & LastException.Message)
	End Try
	#End If
	B4XDaisyVariants.ApplyElevation(vTarget, msShadow)
End Sub

Private Sub EnsureIcon(vParent As B4XView)
	If svgIcon.IsInitialized = False Then
		svgIcon.Initialize(Me, "svgIcon")
		svgIcon.setClickable(False)
	End If
	If svgIcon.mBase.IsInitialized = False Then
		svgIcon.AddToParent(vParent, 0, 0, 50dip, 50dip)
		mbIconCreated = True
	Else If svgIcon.mBase.Parent <> vParent Then
		svgIcon.mBase.RemoveViewFromParent
		vParent.AddView(svgIcon.mBase, 0, 0, 50dip, 50dip)
	End If
End Sub

' --- Color / radius resolution ---

Private Sub ResolveCardBackground As Int
	If mcBackgroundColor <> 0 Then Return mcBackgroundColor
	Return B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White)
End Sub

Private Sub ResolveContentColor As Int
	If mcTextColor <> 0 Then Return mcTextColor
	Return B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
End Sub

Private Sub ResolveContentColorMuted As Int
	Dim c As Int = ResolveContentColor
	Return B4XDaisyVariants.AlphaColor(c, 0.55)
End Sub

Private Sub ResolveValueColor As Int
	Return ResolveContentColor
End Sub

Private Sub ResolveIconColor As Int
	If mcIconColor <> 0 Then Return mcIconColor
	If msVariant <> "none" And msVariant <> "" Then
		Return B4XDaisyVariants.ResolveBackgroundColorVariant(msVariant, B4XDaisyVariants.GetTokenColor("--color-primary", xui.Color_RGB(34, 197, 94)))
	End If
	Return xui.Color_RGB(34, 197, 94) ' green-500 default accent
End Sub

Private Sub ResolveIconTextColor As Int
	If mcIconTextColor <> 0 Then Return mcIconTextColor
	Return xui.Color_White
End Sub

Private Sub ParseValue(sValue As String) As Float
	If sValue = Null Then Return 0
	sValue = sValue.Trim
	If sValue = "" Then Return 0
	If IsNumber(sValue) Then Return sValue Else Return 0
End Sub
#End Region

#Region Count-Up
''' <summary>
''' Starts (or restarts) the count-up animation from FromVal to ToVal.
''' </summary>
Private Sub StartCountUp(fFromVal As Float, fToVal As Float)
	If CountUpTimer.IsInitialized Then CountUpTimer.Enabled = False
	mfStartVal = fFromVal
	mfTargetVal = fToVal
	AnimIndex = AnimIndex + 1
	If miDuration <= 0 Or mbAnimated = False Then
		mfCurrentValue = fToVal
		UpdateValueLabel
		Return
	End If
	AnimDurationMs = miDuration * 1000
	AnimStartTime = DateTime.Now
	mfCurrentValue = fFromVal
	UpdateValueLabel
	CountUpTimer.Enabled = True
End Sub

Private Sub CountUpTimer_Tick
	Dim elapsed As Long = DateTime.Now - AnimStartTime
	If elapsed >= AnimDurationMs Then
		mfCurrentValue = mfTargetVal
		UpdateValueLabel
		CountUpTimer.Enabled = False
		Return
	End If
	mfCurrentValue = Anim.easeOutCubic(elapsed, mfStartVal, mfTargetVal - mfStartVal, AnimDurationMs)
	UpdateValueLabel
End Sub

Private Sub UpdateValueLabel
	If lblValue.IsInitialized = False Then Return
	If lblValue.mBase.IsInitialized = False Then Return
	lblValue.Text = FormatValue(mfCurrentValue)
End Sub

''' <summary>
''' Formats the numeric value with prefix / suffix / grouping / decimal places.
''' Replaces countUp.js formatting.
''' </summary>
Private Sub FormatValue(fV As Float) As String
	Dim dp As Int = Max(0, miDecimalPlaces)
	Dim neg As Boolean = (fV < 0)
	Dim absV As Float = Abs(fV)
	Dim intPart As Long = Floor(absV)
	Dim frac As Float = absV - intPart
	Dim pow As Long = Power(10, dp)
	Dim fracScaled As Long = Round(frac * pow)
	If fracScaled >= pow Then
		intPart = intPart + 1
		fracScaled = fracScaled - pow
	End If
	Dim intStr As String = intPart
	If mbUseGrouping And msSeparator <> "" Then
		intStr = GroupDigits(intStr, msSeparator)
	End If
	Dim fracStr As String = ""
	If dp > 0 Then
		fracStr = msDecimal & PadLeft(fracScaled, dp)
	End If
	Dim s As String = intStr & fracStr
	If neg Then s = "-" & s
	Return msPrefix & s & msSuffix
End Sub

Private Sub GroupDigits(sValue As String, sSep As String) As String
	Dim result As String = ""
	Dim len As Int = sValue.Length
	Dim i As Int = 0
	Do While i < len
		Dim take As Int = (len - i) Mod 3
		If take = 0 Then take = 3
		If i > 0 Then result = result & sSep
		result = result & sValue.SubString2(i, i + take)
		i = i + take
	Loop
	Return result
End Sub

Private Sub PadLeft(lNum As Long, iDigits As Int) As String
	Dim s As String = "" & lNum
	Do While s.Length < iDigits
		s = "0" & s
	Loop
	Return s
End Sub
#End Region

#Region Effects
Private Sub ApplyEffectDown
	Select Case msEffect
		Case "hover-zoom"
			If svgIcon.mBase.IsInitialized Then svgIcon.mBase.Alpha = 0.4
	End Select
End Sub

Private Sub ApplyEffectUp
	Select Case msEffect
		Case "hover-zoom"
			If svgIcon.mBase.IsInitialized Then svgIcon.mBase.Alpha = 1.0
	End Select
End Sub

' Material-style ripple (waves) on press - mirrors B4XDaisyButton.
Private Sub TriggerRipple(fX As Float, fY As Float)
	If mBase.IsInitialized = False Then Return
	If mbEnabled = False Then Return
	Dim rippleColor As Int = B4XDaisyVariants.AlphaColor(ResolveContentColor, 0.25)
	B4XDaisyVariants.CreateRipple(mBase, fX, fY, rippleColor, 300, B4XDaisyVariants.GetRadiusBoxDip(16dip))
End Sub
#End Region

#Region Animation
''' <summary>
''' Re-runs the count-up animation from StartFrom to the current Value.
''' </summary>
Public Sub StartAnimation
	If mBase.IsInitialized = False Then Return
	StartCountUp(mfStartFrom, mfTargetVal)
End Sub
#End Region

#Region Touch & Click
' The card never disallows parent interception: an InfoCard is a plain tap
' target, so a vertical drag over it must reach the enclosing ScrollView.
' When the parent takes over we receive ACTION_CANCEL (3) and drop the
' pending click; a drag beyond the slop cancels it as well.
Private Sub mBase_Touch(iAction As Int, fX As Float, fY As Float)
	If mbEnabled = False Then Return
	Select iAction
		Case mBase.TOUCH_ACTION_DOWN
			mbPressed = True
			mfDownY = fY
			TriggerRipple(fX, fY)
			ApplyEffectDown
		Case mBase.TOUCH_ACTION_MOVE
			If fX < 0 Or fX > mBase.Width Or fY < 0 Or fY > mBase.Height Or Abs(fY - mfDownY) > 12dip Then
				mbPressed = False ' finger dragged off the card or is scrolling, cancel
				ApplyEffectUp
			End If
		Case mBase.TOUCH_ACTION_UP
			If mbPressed Then RaiseClick
			mbPressed = False
			ApplyEffectUp
		Case Else ' ACTION_CANCEL: the parent (ScrollView) took the gesture
			mbPressed = False
			ApplyEffectUp
	End Select
End Sub



Private Sub RaiseClick
	Dim payload As Object = mTag
	If payload = Null Then payload = mBase
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", payload)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub
#End Region

#Region Cleanup
Public Sub StopAnimation
	If CountUpTimer.IsInitialized Then CountUpTimer.Enabled = False
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub Release
	StopAnimation
	mCallBack = Null
	svgIcon = Null
	lblTitle = Null
	lblValue = Null
	pnlIcon = Null
	pnlContent = Null
End Sub
#End Region

#Region B4XView Layout Wrapper Methods
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
#End Region

#Region B4XView Z-Order and Visibility Methods
Public Sub BringToFront
	If mBase.IsInitialized Then mBase.BringToFront
End Sub
Public Sub SendToBack
	If mBase.IsInitialized Then mBase.SendToBack
End Sub
#End Region
