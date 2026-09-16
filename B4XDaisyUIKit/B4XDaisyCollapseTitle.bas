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
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic color variant - overrides background and text colors.
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override icon color independently (0 = follow text color).
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide title.

#IgnoreWarnings:12,9
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

	ApplyDesignerProps(mProps)
	Refresh
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mText = B4XDaisyVariants.GetPropString(mProps, "Text", mText)
	mSize = B4XDaisyVariants.NormalizeSize(B4XDaisyVariants.GetPropString(mProps, "Size", mSize))
	mVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mVisible)
	mBackColor = B4XDaisyVariants.GetPropColor(mProps, "BackgroundColor", mBackColor)
	mTextColor = B4XDaisyVariants.GetPropColor(mProps, "TextColor", mTextColor)
	mIconName = B4XDaisyVariants.GetPropString(mProps, "IconName", mIconName)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "Variant", mVariant))
	Dim rawIconColor As Int = B4XDaisyVariants.GetPropColor(mProps, "IconColor", 0)
	mIconColor = IIf(rawIconColor = 0, -1, rawIconColor)
	ApplySizeMetrics
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Text", mText)
	props.Put("Size", mSize)
	props.Put("BackgroundColor", mBackColor)
	props.Put("TextColor", mTextColor)
	props.Put("IconName", mIconName)
	props.Put("Variant", mVariant)
	props.Put("IconColor", IIf(mIconColor = -1, 0, mIconColor))
	props.Put("Visible", mVisible)
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

	' Resolve background and text colors - variant wins over manual overrides
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

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	Dim w As Int = Max(1dip, dWidth)
	Dim h As Int = Max(1dip, dHeight)
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
	inResize = False
End Sub

Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
	Dim empty As B4XView
	If vParent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, iWidth)
	Dim h As Int = Max(1dip, iHeight)
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		Dim b As B4XView = p
		b.SetLayoutAnimated(0, 0, 0, w, h)
		DesignerCreateView(b, Null, BuildRuntimeProps(w, h))
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	vParent.AddView(mBase, iLeft, iTop, w, h)
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
	If lblText.IsInitialized Then Return lblText.TextColor
	Return mTextColor
End Sub

Public Sub setBackgroundColor(iValue As Int)
	mBackColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

Public Sub setSize(sValue As String)
	mSize = B4XDaisyVariants.NormalizeSize(sValue)
	ApplySizeMetrics
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getSize As String
	Return mSize
End Sub

Public Sub setVisible(bValue As Boolean)
	mVisible = bValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setIconName(sValue As String)
	mIconName = sValue
	If mBase.IsInitialized Then
		Refresh
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getIconName As String
	Return mIconName
End Sub

Public Sub setVariant(sValue As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(sValue)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setIconColor(iValue As Int)
	mIconColor = iValue
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getIconColor As Int
	Return mIconColor
End Sub

Private Sub lbl_Click
	CallSub2(mCallBack, mEventName & "_Click", mTag)
End Sub

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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
