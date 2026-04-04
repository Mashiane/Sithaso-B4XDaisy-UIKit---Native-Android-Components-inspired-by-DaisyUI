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
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
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

	ApplyDesignerProps(Props)
	Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mText = B4XDaisyVariants.GetPropString(Props, "Text", mText)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", mSize))
	mCentered = B4XDaisyVariants.GetPropBool(Props, "Centered", mCentered)
	mGapDip = Max(0, B4XDaisyVariants.GetPropInt(Props, "Gap", mGapDip))
	mSingleLine = B4XDaisyVariants.GetPropBool(Props, "SingleLine", False)
	msEllipsize = B4XDaisyVariants.GetPropString(Props, "Ellipsize", "none").ToLowerCase.Trim
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
	mbAutoResize = B4XDaisyVariants.GetPropBool(Props, "AutoResize", True)
	ApplySizeMetrics
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

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	LayoutTitleRow(w, h)
	DoAutoResize
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, w, h)
		DesignerCreateView(b, Null, CreateMap("Text": mText, "Size": mSize, "Centered": mCentered, "Gap": mGapDip, "SingleLine": mSingleLine, "Ellipsize": msEllipsize, "Visible": mVisible, "AutoResize": mbAutoResize))
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	Parent.AddView(mBase, Left, Top, w, h)
	Refresh
	Return mBase
End Sub

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub SetLayoutAnimated(Duration As Int, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.SetLayoutAnimated(Duration, Left, Top, Max(1dip, Width), Max(1dip, Height))
	Base_Resize(Width, Height)
End Sub

Public Sub setText(Value As String)
	mText = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setSize(Value As String)
	mSize = B4XDaisyVariants.NormalizeSize(Value)
	ApplySizeMetrics
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setCentered(Value As Boolean)
	mCentered = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getCentered As Boolean
	Return mCentered
End Sub

Public Sub setGapDip(Value As Int)
	mGapDip = Max(0, Value)
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getGapDip As Int
	Return mGapDip
End Sub

Public Sub setGap(Value As Int)
	setGapDip(Value)
End Sub

Public Sub getGap As Int
	Return getGapDip
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setSingleLine(Value As Boolean)
	mSingleLine = Value
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getSingleLine As Boolean
	Return mSingleLine
End Sub

Public Sub setEllipsize(Value As String)
	msEllipsize = Value.ToLowerCase.Trim
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

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setAutoResize(Value As Boolean)
	mbAutoResize = Value
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getAutoResize As Boolean
	Return mbAutoResize
End Sub


Private Sub LayoutTitleRow(AvailableWidth As Int, AvailableHeight As Int)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, AvailableWidth)
	Dim h As Int = Max(1dip, AvailableHeight)
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

Private Sub LayoutExtrasChildren(HostHeight As Int)
	If pnlExtras.IsInitialized = False Then Return
	Dim x As Int = 0
	For i = 0 To pnlExtras.NumberOfViews - 1
		Dim v As B4XView = pnlExtras.GetView(i)
		If v.Visible = False Then Continue
		Dim vw As Int = Max(1dip, v.Width)
		Dim vh As Int = Max(1dip, v.Height)
		Dim y As Int = Max(0, Round((HostHeight - vh) / 2))
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

Private Sub MeasureSingleLineWidth(Text As String, FontSize As Float) As Int
	If Text.Length = 0 Then Return 0
	If lblText.IsInitialized Then
		Try
			Dim l As Label = lblText
			Dim c As Canvas
			c.Initialize(l)
			Dim tw As Float = c.MeasureStringWidth(Text, l.Typeface, FontSize)
			Return Max(1dip, Ceil(tw) + 2dip)
		Catch
		End Try 'ignore
	End If
	Return Max(1dip, Ceil(Text.Length * FontSize * 0.62) + 2dip)
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

