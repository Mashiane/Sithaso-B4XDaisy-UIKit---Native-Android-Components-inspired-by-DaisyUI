B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: Card Title, Description: Title text.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Title size token.
#DesignerProperty: Key: Centered, DisplayName: Centered, FieldType: Boolean, DefaultValue: False, Description: Center align title text.
#DesignerProperty: Key: Gap, DisplayName: Gap, FieldType: Int, DefaultValue: 8, Description: Horizontal gap between title text and extra components.
#DesignerProperty: Key: SingleLine, DisplayName: Single Line, FieldType: Boolean, DefaultValue: False, Description: Prevent text wrapping.
#DesignerProperty: Key: Ellipsize, DisplayName: Ellipsize, FieldType: String, DefaultValue: none, List: none|start|middle|end|marquee, Description: Truncate with ellipsis when text overflows.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide title.
#DesignerProperty: Key: AutoResize, DisplayName: Auto Resize, FieldType: Boolean, DefaultValue: True, Description: Automatically resize height to fit text and extra components.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00FFFFFF, Description: Override text color.

#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView
	Private lblText As B4XView
	Private pnlExtras As B4XView

	Private mText As String = "Card Title"
	Private mSize As String = "md"
	Private mCentered As Boolean = False
	Private mGapDip As Int = 8dip
	Private mVisible As Boolean = True
	Private mSingleLine As Boolean = False
	Private msEllipsize As String = "none"
	Private mTextColor As Int = 0
	Private mTextSize As Float = 18
	Private tu As StringUtils
	Private mbAutoResize As Boolean = True
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
	
	Dim l As Label
	l.Initialize("")
	lblText = l
	mBase.AddView(lblText, 0, 0, 1dip, 1dip)

	Dim pe As Panel
	pe.Initialize("")
	pnlExtras = pe
	pnlExtras.Color = xui.Color_Transparent
	mBase.AddView(pnlExtras, 0, 0, 0, 0)

	ApplyDesignerProps(mProps)
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mCentered = B4XDaisyVariants.GetPropBool(mProps, "Centered", mCentered)
	mGapDip = Max(0, B4XDaisyVariants.GetPropInt(mProps, "Gap", mGapDip))
	mSingleLine = B4XDaisyVariants.GetPropBool(mProps, "SingleLine", mSingleLine)
	msEllipsize = B4XDaisyVariants.GetPropString(mProps, "Ellipsize", msEllipsize).ToLowerCase.Trim
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mbAutoResize = B4XDaisyVariants.GetPropBool(mProps, "AutoResize", mbAutoResize)
	ApplySizeMetrics
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Text", mText)
	props.Put("Size", mSize)
	props.Put("Centered", mCentered)
	props.Put("Gap", mGapDip)
	props.Put("SingleLine", mSingleLine)
	props.Put("Ellipsize", msEllipsize)
	props.Put("Visible", mVisible)
	props.Put("AutoResize", mbAutoResize)
	props.Put("TextColor", mTextColor)
	Return props
End Sub

Private Sub ApplySizeMetrics
	Select Case mSize
		Case "xs": mTextSize = 14
		Case "sm": mTextSize = 16
		Case "lg": mTextSize = 20
		Case "xl": mTextSize = 22
		Case Else: mTextSize = 18
	End Select
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	mBase.Visible = mVisible
	lblText.Text = mText
	lblText.TextSize = mTextSize
	lblText.Font = xui.CreateDefaultBoldFont(mTextSize)
	If mTextColor <> 0 Then
		lblText.TextColor = mTextColor
	Else
		lblText.TextColor = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))
	End If
	lblText.SetTextAlignment("CENTER", "LEFT")
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	LayoutTitleRow(w, h)
	DoAutoResize
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map = BuildRuntimeProps(w, h)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	vParent.AddView(mBase, iLeft, iTop, w, h)
	Return mBase
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(iDuration, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
	Base_Resize(iWidth, iHeight)
End Sub

Public Sub setText(sValue As String)
	mText = sValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setTextColor(iValue As Int)
	mTextColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	ApplySizeMetrics
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setCentered(bValue As Boolean)
	mCentered = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCentered As Boolean
	Return mCentered
End Sub

Public Sub setGapDip(iValue As Int)
	mGapDip = Max(0, iValue)
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getGapDip As Int
	Return mGapDip
End Sub

Public Sub setGap(iValue As Int)
	setGapDip(iValue)
End Sub

Public Sub getGap As Int
	Return getGapDip
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setSingleLine(bValue As Boolean)
	mSingleLine = bValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getSingleLine As Boolean
	Return mSingleLine
End Sub

Public Sub setEllipsize(sValue As String)
	msEllipsize = sValue.ToLowerCase.Trim
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getEllipsize As String
	Return msEllipsize
End Sub

Public Sub getTextSize As Float
	Return mTextSize
End Sub

Public Sub getLabel As B4XView
	Return lblText
End Sub

Public Sub getExtrasContainer As B4XView
	Return pnlExtras
End Sub

Public Sub getContainer As B4XView
	Return mBase
End Sub

Public Sub Relayout
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub setTag(oValue As Object)
	mTag = oValue
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setAutoResize(bValue As Boolean)
	mbAutoResize = bValue
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub


Private Sub LayoutTitleRow(iAvailableWidth As Int, iAvailableHeight As Int)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, iAvailableWidth)
	Dim h As Int = Max(1dip, iAvailableHeight)
	Dim extrasW As Int = MeasureExtrasWidth
	Dim extrasH As Int = MeasureExtrasHeight
	Dim hasExtras As Boolean = extrasW > 0
	Dim hasText As Boolean = B4XDaisyVariants.NormalizeSingleLineText(mText).Length > 0
	Dim gap As Int = IIf(hasExtras And hasText, mGapDip, 0)

	Dim textDesired As Int = MeasureSingleLineWidth(B4XDaisyVariants.NormalizeSingleLineText(mText), mTextSize)
	Dim textW As Int = Max(1dip, Min(Max(1dip, w - extrasW - gap), textDesired))
	If hasText = False Then textW = 0

	Dim contentW As Int = textW + extrasW + gap
	Dim startX As Int = 0
	If mCentered Then
		startX = Max(0, Round((w - contentW) / 2))
	End If

	lblText.SetLayoutAnimated(0, startX, 0, textW, h)
	Try
		Dim joLbl As JavaObject = lblText
		Dim l As Label = lblText
		l.SingleLine = mSingleLine
		Dim joTruncate As JavaObject
		joTruncate.InitializeStatic("android.text.TextUtils$TruncateAt")
		Select Case msEllipsize
			Case "start":   joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("START")))
			Case "middle":  joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("MIDDLE")))
			Case "end":     joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("END")))
			Case "marquee": joLbl.RunMethod("setEllipsize", Array As Object(joTruncate.GetField("MARQUEE")))
			Case Else:      joLbl.RunMethod("setEllipsize", Array As Object(Null))
		End Select
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCardTitle.LayoutTitleRow: " & LastException.Message)
	End Try
	If mCentered And hasExtras = False Then
		lblText.SetTextAlignment("CENTER", "CENTER")
	Else
		lblText.SetTextAlignment("CENTER", "LEFT")
	End If

	If hasExtras Then
		' Optical alignment tweak: badges/icons look slightly low when mathematically centered.
		Dim extrasY As Int = Max(0, Round((h - extrasH) / 2) - 2dip)
		pnlExtras.SetLayoutAnimated(0, startX + textW + gap, extrasY, extrasW, extrasH)
		LayoutExtrasChildren(extrasH)
	Else
		pnlExtras.SetLayoutAnimated(0, startX + textW, 0, 0, 0)
	End If
End Sub

Private Sub LayoutExtrasChildren(iHostHeight As Int)
	If pnlExtras.IsInitialized = False Then Return
	Dim x As Int = 0
	For i = 0 To pnlExtras.NumberOfViews - 1
		Dim v As B4XView = pnlExtras.GetView(i)
		If v.Visible = False Then Continue
		Dim vw As Int = Max(1dip, v.Width)
		Dim vh As Int = Max(1dip, v.Height)
		Dim y As Int = Max(0, Round((iHostHeight - vh) / 2))
		v.SetLayoutAnimated(0, x, y, vw, vh)
		x = x + vw + mGapDip
	Next
End Sub

Private Sub MeasureExtrasWidth As Int
	If pnlExtras.IsInitialized = False Then Return 0
	Dim total As Int = 0
	Dim countVisible As Int = 0
	For i = 0 To pnlExtras.NumberOfViews - 1
		Dim v As B4XView = pnlExtras.GetView(i)
		If v.Visible = False Then Continue
		total = total + Max(1dip, v.Width)
		countVisible = countVisible + 1
	Next
	If countVisible > 1 Then total = total + ((countVisible - 1) * mGapDip)
	Return Max(0, total)
End Sub

Private Sub MeasureExtrasHeight As Int
	If pnlExtras.IsInitialized = False Then Return 0
	Dim h As Int = 0
	For i = 0 To pnlExtras.NumberOfViews - 1
		Dim v As B4XView = pnlExtras.GetView(i)
		If v.Visible = False Then Continue
		h = Max(h, Max(1dip, v.Height))
	Next
	Return Max(0, h)
End Sub

Private Sub MeasureSingleLineWidth(sText As String, fFontSize As Float) As Int
	If sText.Length = 0 Then Return 0
	If lblText.IsInitialized Then
		Try
			Dim l As Label = lblText
			Dim c As Canvas
			c.Initialize(l)
			Dim tw As Float = c.MeasureStringWidth(sText, l.Typeface, fFontSize)
			Return Max(1dip, Ceil(tw) + 2dip)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyCardTitle.MeasureSingleLineWidth: " & LastException.Message)
		End Try 'ignore
	End If
	Return Max(1dip, Ceil(sText.Length * fFontSize * 0.62) + 2dip)
End Sub

Private Sub DoAutoResize
	If mbAutoResize = False Then Return
	If mBase.IsInitialized = False Then Return
	If lblText.IsInitialized = False Then Return
	Dim extrasH As Int = MeasureExtrasHeight
	Dim newH As Int
	If mSingleLine Then
		newH = Max(1dip, Round(mTextSize * 1.4))
	Else
		Dim l As Label = lblText
		l.SingleLine = False
		newH = tu.MeasureMultilineTextHeight(lblText, mText)
		If newH <= 0 Then newH = Max(1dip, Round(mTextSize * 1.4))
	End If
	newH = Max(newH, extrasH)
	If newH <> mBase.Height Then
		mBase.Height = newH
	End If
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
