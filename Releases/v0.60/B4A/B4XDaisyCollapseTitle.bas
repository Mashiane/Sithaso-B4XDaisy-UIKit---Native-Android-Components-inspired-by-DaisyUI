B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'/**
' * B4XDaisyCollapseTitle
' * -----------------------------------------------------------------------------
' * Clickable header part for B4XDaisyCollapse.
' */

#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: Collapse Title, Description: Title text.
#DesignerProperty: Key: Size, DisplayName: Size, FieldType: String, DefaultValue: md, List: xs|sm|md|lg|xl, Description: Title size token.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit background color override (0 uses parent/theme).
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Explicit text color override (0 uses theme token).
#DesignerProperty: Key: IconName, DisplayName: Icon Name, FieldType: String, DefaultValue:, Description: SVG asset filename shown on the left (e.g. home-solid.svg).
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic color variant � overrides background and text colors.
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override icon color independently (0 = follow text color).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide title.

#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView
	Private lblText As B4XView
	Private pnlIcon As B4XView
	Private iconComp As B4XDaisySvgIcon

	Private mText As String = "Collapse Title"
	Private mSize As String = "md"
	Private mVisible As Boolean = True
	Private mTextColor As Int = 0
	Private mBackColor As Int = 0
	Private mTextSize As Float = 18
	Private mIconName As String = ""
	Private mVariant As String = "none"
	Private mIconColor As Int = -1
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
	l.Initialize("lbl")
	lblText = l
	mBase.AddView(lblText, 0, 0, 1dip, 1dip)

	' Build left SVG icon panel
	Dim pi As Panel
	pi.Initialize("")
	pi.Color = xui.Color_Transparent
	pnlIcon = pi
	mBase.AddView(pnlIcon, 0, 0, 1dip, 1dip)
	Dim svgIcon As B4XDaisySvgIcon
	svgIcon.Initialize(Me, "")
	svgIcon.AddToParent(pnlIcon, 0, 0, 22dip, 22dip)
	iconComp = svgIcon

	ApplyDesignerProps(Props)
	Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mText = B4XDaisyVariants.GetPropString(Props, "Text", mText)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(Props, "Size", mSize))
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", mVisible)
	mBackColor = B4XDaisyVariants.GetPropColor(Props, "BackgroundColor", mBackColor)
	mTextColor = B4XDaisyVariants.GetPropColor(Props, "TextColor", mTextColor)
	mIconName = B4XDaisyVariants.GetPropString(Props, "IconName", mIconName)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "none"))
	Dim rawIconColor As Int = B4XDaisyVariants.GetPropColor(Props, "IconColor", 0)
	mIconColor = IIf(rawIconColor = 0, -1, rawIconColor)
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

	' Resolve background and text colors � variant wins over manual overrides
	Dim resolvedBack As Int
	Dim resolvedText As Int
	If mVariant <> "none" Then
		resolvedBack = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, xui.Color_Transparent)
		resolvedText = B4XDaisyVariants.ResolveTextColorVariant(mVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55)))
	Else
		resolvedBack = IIf(mBackColor <> 0, mBackColor, xui.Color_Transparent)
		resolvedText = IIf(mTextColor <> 0, mTextColor, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55)))
	End If
	mBase.Color = resolvedBack

	lblText.Text = mText
	lblText.TextSize = mTextSize
	lblText.Font = xui.CreateDefaultBoldFont(mTextSize)
	lblText.TextColor = resolvedText
	lblText.SetTextAlignment("CENTER", "LEFT")
	' Debug border
	#if DEBUG
	' mBase.SetColorAndBorder(resolvedBack, 1dip, xui.Color_Red, 0)
	#end if

	' Refresh SVG icon asset and color
	If pnlIcon.IsInitialized Then
		If mIconName.Trim.Length > 0 Then
			iconComp.setSvgAsset(mIconName)
			Dim iconFinalColor As Int = IIf(mIconColor <> -1, mIconColor, resolvedText)
			iconComp.setColor(iconFinalColor)
		End If
	End If
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim pad As Int = 16dip
	Dim iconSize As Int = 22dip
	Dim iconGap As Int = 8dip
	If mIconName.Trim.Length > 0 Then
		pnlIcon.Visible = True
		pnlIcon.SetLayoutAnimated(0, pad, (h - iconSize) / 2, iconSize, iconSize)
		iconComp.ResizeToParent(pnlIcon)
		lblText.SetLayoutAnimated(0, pad + iconSize + iconGap, 0, Max(1dip, w - (pad + iconSize + iconGap + pad)), h)
	Else
		pnlIcon.Visible = False
		lblText.SetLayoutAnimated(0, pad, 0, Max(1dip, w - (pad * 2)), h)
	End If
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
		DesignerCreateView(b, Null, CreateMap("Text": mText, "Size": mSize, "Visible": mVisible))
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
	If lblText.IsInitialized Then Return lblText.TextColor
	Return mTextColor
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

Public Sub setSize(Value As String)
	mSize = B4XDaisyVariants.NormalizeSize(Value)
	ApplySizeMetrics
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setIconName(Value As String)
	mIconName = Value
	If mBase.IsInitialized Then
		Refresh
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getIconName As String
	Return mIconName
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setIconColor(Value As Int)
	mIconColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconColor As Int
	Return mIconColor
End Sub

Private Sub lbl_Click
	CallSub2(mCallBack, mEventName & "_Click", mTag)
End Sub
