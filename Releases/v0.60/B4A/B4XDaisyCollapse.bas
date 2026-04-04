B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'/**
' * B4XDaisyCollapse
' * -----------------------------------------------------------------------------
' * Collapse component for showing and hiding content.
' * Supports arrow/plus icons and daisy variants.
' */

#Event: Click (Tag As Object)
#Event: StateChanged (Open As Boolean)

#DesignerProperty: Key: Open, DisplayName: Open, FieldType: Boolean, DefaultValue: False, Description: Initial expanded state.
#DesignerProperty: Key: Icon, DisplayName: Icon, FieldType: String, DefaultValue: none, List: none|arrow|plus, Description: Expansion indicator icon.
#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic variant.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: theme, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full, Description: Radius mode.
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: none, List: none|xs|sm|md|lg|xl|2xl, Description: Elevation level.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Show or hide component.
#DesignerProperty: Key: TitleText, DisplayName: Title Text, FieldType: String, DefaultValue: Click to expand, Description: Text shown in the collapse title bar.
#DesignerProperty: Key: TitleVariant, DisplayName: Title Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Semantic color variant applied to the title background.
#DesignerProperty: Key: TitleSize, DisplayName: Title Size, FieldType: String, DefaultValue: text-sm, List: text-xs|text-sm|text-base|text-lg|text-xl|text-2xl, Description: Font size token for title text.
#DesignerProperty: Key: TitleIconName, DisplayName: Title Icon, FieldType: String, DefaultValue:, Description: SVG asset filename shown on the left of the title text (e.g. home-solid.svg).
#DesignerProperty: Key: TitleColor, DisplayName: Title Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override title text color (wins over variant and TitleTextColor; 0 = unset).
#DesignerProperty: Key: TitleIconColor, DisplayName: Title Icon Color, FieldType: Color, DefaultValue: 0x00000000, Description: Override title icon color independently (0 = follow text color).
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Component width as Tailwind fraction of parent (w-full = fill parent).
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: String, DefaultValue: border, Description: Tailwind border width utility (e.g. border, border-2, border-0)
#DesignerProperty: Key: BorderStyle, DisplayName: Border Style, FieldType: String, DefaultValue: solid, List: solid|dashed|dotted, Description: The style of the border.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: String, DefaultValue: border-base-300, Description: Tailwind border color utility (e.g. border-primary, border-base-300)
#DesignerProperty: Key: IconPosition, DisplayName: Icon Position, FieldType: String, DefaultValue: right, List: left|right, Description: Position of the expansion indicator (arrow/plus).
#DesignerProperty: Key: GroupName, DisplayName: Group Name, FieldType: String, DefaultValue: , Description: Join multiple collapses into an accordion group.

#IgnoreWarnings:12
Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Public mBase As B4XView
	' reference to accordion class for parent checks
	Private unusedAccordion As B4XDaisyAccordion
	
	' Parts
	Private pnlTitle As B4XView
	Private pnlContent As B4XView
	Public Title As B4XDaisyCollapseTitle
	Public Content As B4XDaisyCollapseContent
	Private cvsIcon As B4XCanvas
	Private pnlIcon As B4XView
	Private pnlTitleIcon As B4XView
	Private titleIconComp As B4XDaisySvgIcon

	' Props
	Private mOpen As Boolean = False
	Private mIcon As String = "none"
	Private mVariant As String = "none"
	Private mRounded As String = "theme"
	Private mShadow As String = "none"
	Private mVisible As Boolean = True
	' Title props
	Private mTitleText As String = "Click to expand"
	Private mTitleVariant As String = "none"
	Private mTitleSize As String = "text-sm"
	Private mTitleBackgroundColor As Int = -1
	Private mTitleTextColor As Int = -1
	Private mTitleColor As Int = -1
	Private mTitleIconName As String = ""
	Private mTitleIconColor As Int = -1
	Private mWidthMode As String = "w-full"
	Private mBorderWidth As String = "border"
	Private mBorderStyle As String = "solid"
	Private mBorderColor As String = "border-base-300"
	Private mIconPosition As String = "right"
	Private mGroupName As String = ""
	
	' Internal state
	Private mIsAnimating As Boolean = False
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

	' Build Title Part
	Dim pt As Panel
	pt.Initialize("pnlTitle")
	pnlTitle = pt
	pnlTitle.Color = xui.Color_Transparent
	mBase.AddView(pnlTitle, 0, 0, 1dip, 1dip)
	
	Title.Initialize(Me, "Title")
	Title.AddToParent(pnlTitle, 0, 0, 1dip, 1dip)
	
	' Build Icon Layer
	Dim pi As Panel
	pi.Initialize("")
	pnlIcon = pi
	pnlTitle.AddView(pnlIcon, 0, 0, 1dip, 1dip)
	cvsIcon.Initialize(pnlIcon)
	pnlIcon.Color = xui.Color_Transparent
	
	' Build Title Left SVG Icon
	Dim pti As Panel
	pti.Initialize("")
	pti.Color = xui.Color_Transparent
	pnlTitleIcon = pti
	pnlTitle.AddView(pnlTitleIcon, 0, 0, 1dip, 1dip)
	Dim svgIcon As B4XDaisySvgIcon
	svgIcon.Initialize(Me, "")
	svgIcon.AddToParent(pnlTitleIcon, 0, 0, 22dip, 22dip)
	titleIconComp = svgIcon
	
	' Build Content Part
	Dim pc As Panel
	pc.Initialize("")
	pnlContent = pc
	pnlContent.Color = xui.Color_Transparent
	mBase.AddView(pnlContent, 0, 0, 1dip, 1dip)
	pnlContent.Visible = False
	
	Content.Initialize(Me, "Content")
	Content.AddToParent(pnlContent, 0, 0, 1dip, 1dip)

	ApplyDesignerProps(Props)
	Refresh
End Sub

''' <summary>
''' Forces the component to re-evaluate its styling against the currently active global Theme.
''' </summary>
Public Sub UpdateTheme
	If mBase.IsInitialized = False Then Return
	Refresh
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mOpen = B4XDaisyVariants.GetPropBool(Props, "Open", mOpen)
	mIcon = B4XDaisyVariants.GetPropString(Props, "Icon", mIcon)
	mVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", "none"))
	mRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", "theme"))
	mShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", "none"))
	mVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
	mTitleText = B4XDaisyVariants.GetPropString(Props, "TitleText", "Click to expand")
	mTitleVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "TitleVariant", "none"))
	mTitleSize = B4XDaisyVariants.GetPropString(Props, "TitleSize", "text-sm")
	mTitleIconName = B4XDaisyVariants.GetPropString(Props, "TitleIconName", "")
	Dim rawTitleColor As Int = B4XDaisyVariants.GetPropColor(Props, "TitleColor", 0)
	mTitleColor = IIf(rawTitleColor = 0, -1, rawTitleColor)
	Dim rawTitleIconColor As Int = B4XDaisyVariants.GetPropColor(Props, "TitleIconColor", 0)
	mTitleIconColor = IIf(rawTitleIconColor = 0, -1, rawTitleIconColor)
	mWidthMode = B4XDaisyVariants.GetPropString(Props, "Width", "w-full")
	mBorderWidth = B4XDaisyVariants.GetPropString(Props, "BorderWidth", "border")
	mBorderStyle = B4XDaisyVariants.GetPropString(Props, "BorderStyle", "solid")
	mBorderColor = B4XDaisyVariants.GetPropString(Props, "BorderColor", "border-base-300")
	mIconPosition = B4XDaisyVariants.GetPropString(Props, "IconPosition", "right").ToLowerCase
	mGroupName = B4XDaisyVariants.GetPropString(Props, "GroupName", "")
End Sub

Private Sub Refresh
	If mBase.IsInitialized = False Then Return
	
	Dim back As Int = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, B4XDaisyVariants.GetTokenColor("--color-base-100", xui.Color_White))
	Dim border As Int = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(226, 232, 240))
	Dim radius As Float = ResolveRadius
	
	Dim bw As Float = B4XDaisyVariants.TailwindBorderWidthToDip(mBorderWidth, 0dip)
	Dim bc As Int = B4XDaisyVariants.TailwindBorderColorToColor(mBorderColor, xui.Color_Transparent)
	B4XDaisyVariants.ApplyDashedBorder(mBase, back, bw, bc, radius, mBorderStyle)
	B4XDaisyVariants.ApplyElevation(mBase, mShadow)
	mBase.Visible = mVisible
	' RefreshTitle
	' Base_Resize(mBase.Width, mBase.Height)

	Dim contentTextColor As Int = B4XDaisyVariants.ResolveTextColorVariant(mVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59)))
	Content.setTextColor(contentTextColor)
	Content.setBackgroundColor(xui.Color_Transparent)
	RefreshTitle
	Base_Resize(mBase.Width, mBase.Height)
	UpdateOpenState(False)
End Sub

Private Sub RefreshTitle
	If Title.mBase.IsInitialized = False Then Return
	Title.setText(mTitleText)
	Title.setSize(mTitleSize)
	Dim resolvedTextColor As Int = -1
	If mTitleVariant <> "none" Then
		Title.setBackgroundColor(B4XDaisyVariants.ResolveBackgroundColorVariant(mTitleVariant, xui.Color_Transparent))
		resolvedTextColor = B4XDaisyVariants.ResolveTextColorVariant(mTitleVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59)))
		Title.setTextColor(resolvedTextColor)
	Else
		' Fallback to main variant for text color if no title variant is set
		' This ensures the expansion icon (which uses Title.getTextColor) gets a valid color
		' even if the title background is transparent.
		resolvedTextColor = B4XDaisyVariants.ResolveTextColorVariant(mVariant, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59)))
		Title.setTextColor(resolvedTextColor)
		
		If mTitleBackgroundColor <> -1 Then
			Title.setBackgroundColor(mTitleBackgroundColor)
		Else
			Title.setBackgroundColor(xui.Color_Transparent)
		End If
		If mTitleTextColor <> -1 Then
			resolvedTextColor = mTitleTextColor
			Title.setTextColor(mTitleTextColor)
		End If
	End If
	' TitleColor is the final text-color override (wins over variant and TitleTextColor)
	If mTitleColor <> -1 Then
		resolvedTextColor = mTitleColor
		Title.setTextColor(mTitleColor)
	End If
	' Update left SVG icon
	If pnlTitleIcon.IsInitialized Then
		If mTitleIconName.Trim.Length > 0 Then
			titleIconComp.setSvgAsset(mTitleIconName)
			Dim iconColor As Int
			If mTitleIconColor <> -1 Then
				iconColor = mTitleIconColor
			Else
				iconColor = IIf(resolvedTextColor <> -1, resolvedTextColor, B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(30, 41, 59)))
			End If
			titleIconComp.setColor(iconColor)
		End If
	End If
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	Dim w As Int = ResolveComponentWidth(Width)
	' Apply resolved width back to self if it differs (e.g. fractional mode)
	If mWidthMode <> "w-full" And mBase.Parent.IsInitialized Then mBase.Width = w
	Dim titleH As Int = 56dip ' Typical DaisyUI height
	Dim titleIconPad As Int = 12dip
	Dim titleIconSize As Int = 22dip
	Dim titleIconGap As Int = 8dip

	Dim bw As Float = B4XDaisyVariants.TailwindBorderWidthToDip(mBorderWidth, 0dip)
	pnlTitle.SetLayoutAnimated(0, bw, bw, w - 2 * bw, titleH)

	' Relative positioning based on IconPosition
	Dim titleInnerW As Int = pnlTitle.Width
	Dim iconSize As Int = 24dip
	Dim titleIconSize As Int = 22dip
	Dim edgePad As Int = 16dip
	Dim itemGap As Int = 8dip
	
	If mIconPosition = "left" Then
		' INDICATOR on LEFT, TITLE ICON on RIGHT
		If mIcon <> "none" Then
			pnlIcon.Visible = True
			pnlIcon.Enabled = True
			pnlIcon.SetLayoutAnimated(0, edgePad, (titleH - iconSize) / 2, iconSize, iconSize)
			cvsIcon.Resize(iconSize, iconSize)
			DrawIcon
			' Visual title starts after indicator (edgePad + iconSize + itemGap)
			' Subtract 16dip because B4XDaisyCollapseTitle has its own internal 16dip padding
			Dim titleStart As Int = (edgePad + iconSize + itemGap) - 16dip
			If mTitleIconName.Trim.Length > 0 Then
				pnlTitleIcon.Visible = True
				pnlTitleIcon.SetLayoutAnimated(0, titleInnerW - edgePad - titleIconSize, (titleH - titleIconSize) / 2, titleIconSize, titleIconSize)
				titleIconComp.ResizeToParent(pnlTitleIcon)
				Title.SetLayoutAnimated(0, titleStart, 0, Max(1dip, titleInnerW - edgePad - titleIconSize - itemGap - (titleStart + 16dip)), titleH)
			Else
				pnlTitleIcon.Visible = False
				Title.SetLayoutAnimated(0, titleStart, 0, Max(1dip, titleInnerW - edgePad - (titleStart + 16dip)), titleH)
			End If
		Else
			pnlIcon.Visible = False
			pnlIcon.Enabled = False
			If mTitleIconName.Trim.Length > 0 Then
				' Title icon on right
				pnlTitleIcon.Visible = True
				pnlTitleIcon.SetLayoutAnimated(0, titleInnerW - edgePad - titleIconSize, (titleH - titleIconSize) / 2, titleIconSize, titleIconSize)
				titleIconComp.ResizeToParent(pnlTitleIcon)
				' Title starts at 0 (internal padding yields 16dip indent)
				Title.SetLayoutAnimated(0, 0, 0, Max(1dip, titleInnerW - edgePad - titleIconSize - itemGap - 16dip), titleH)
			Else
				pnlTitleIcon.Visible = False
				' Full width, indented by internal 16dip padding
				Title.SetLayoutAnimated(0, 0, 0, Max(1dip, titleInnerW), titleH)
			End If
		End If
	Else
		' INDICATOR on RIGHT (Default), TITLE ICON on LEFT
		' Expansion icon on right
		If mIcon <> "none" Then
			pnlIcon.Visible = True
			pnlIcon.Enabled = True
			pnlIcon.SetLayoutAnimated(0, titleInnerW - iconSize - edgePad, (titleH - iconSize) / 2, iconSize, iconSize)
			cvsIcon.Resize(iconSize, iconSize)
			DrawIcon
		Else
			pnlIcon.Visible = False
			pnlIcon.Enabled = False
		End If
		
		' Absolute physical start for the text
		Dim textStart As Int = edgePad
		' Where the component view (Title) should start
		Dim titleStart As Int = 0 
		
		If mTitleIconName.Trim.Length > 0 Then
			pnlTitleIcon.Visible = True
			pnlTitleIcon.SetLayoutAnimated(0, edgePad, (titleH - titleIconSize) / 2, titleIconSize, titleIconSize)
			titleIconComp.ResizeToParent(pnlTitleIcon)
			textStart = edgePad + titleIconSize + itemGap
			titleStart = textStart - 16dip
		Else
			pnlTitleIcon.Visible = False
			titleStart = 0 ' Will indent text at 16dip
		End If
		
		Dim titleEnd As Int = titleInnerW - edgePad
		If mIcon <> "none" Then titleEnd = titleInnerW - edgePad - iconSize - itemGap
		
		Title.SetLayoutAnimated(0, titleStart, 0, Max(1dip, titleEnd - (titleStart + 16dip)), titleH)
	End If
	
	If mOpen Then
		Dim contentDesiredH As Int = MeasureContentHeight
		pnlContent.Visible = True
		pnlContent.SetLayoutAnimated(0, bw, titleH + bw, w - 2 * bw, contentDesiredH)
		Content.SetLayoutAnimated(0, 0, 0, pnlContent.Width, contentDesiredH)
	Else
		pnlContent.Visible = False
		pnlContent.SetLayoutAnimated(0, bw, titleH + bw, w - 2 * bw, 1dip)
		Content.SetLayoutAnimated(0, 0, 0, pnlContent.Width, 1dip)
	End If
End Sub

Private Sub DrawIcon
	cvsIcon.ClearRect(cvsIcon.TargetRect)
	' Strictly follow the title's rendered text color to ensure parity with the title text
	Dim color As Int = Title.getTextColor
	Dim w As Float = cvsIcon.TargetRect.Width
	Dim h As Float = cvsIcon.TargetRect.Height
	Dim stroke As Float = 2dip
	
	Select Case mIcon
		Case "arrow"
			' Draw Chevron
			Dim path As B4XPath
			If mOpen Then
				' Point Up
				path.Initialize(w * 0.2, h * 0.6)
				path.LineTo(w * 0.5, h * 0.3)
				path.LineTo(w * 0.8, h * 0.6)
			Else
				' Point Down
				path.Initialize(w * 0.2, h * 0.4)
				path.LineTo(w * 0.5, h * 0.7)
				path.LineTo(w * 0.8, h * 0.4)
			End If
			cvsIcon.DrawPath(path, color, False, stroke)
		Case "plus"
			' Draw Plus/Minus
			cvsIcon.DrawLine(w * 0.2, h * 0.5, w * 0.8, h * 0.5, color, stroke)
			If mOpen = False Then
				cvsIcon.DrawLine(w * 0.5, h * 0.2, w * 0.5, h * 0.8, color, stroke)
			End If
	End Select
	cvsIcon.Invalidate
End Sub

Private Sub UpdateOpenState(Animated As Boolean)
	If mBase.IsInitialized = False Or mIsAnimating Then Return
	Dim oldH As Int = mBase.Height
	Dim w As Int = Max(1dip, mBase.Width)
	' Do not animate if view has not been laid out yet (width would be 0 ? NaN in animator)
	Dim duration As Int = IIf(Animated And mBase.Width > 0, 200, 0)
	Dim titleH As Int = Max(1dip, pnlTitle.Height)
	
	mIsAnimating = True
	Dim bw As Float = B4XDaisyVariants.TailwindBorderWidthToDip(mBorderWidth, 0dip)
	If mOpen Then
		Dim contentH As Int = Max(1dip, MeasureContentHeight)
		pnlContent.Visible = True
		pnlContent.SetLayoutAnimated(duration, bw, titleH + bw, w - 2 * bw, contentH)
		Content.SetLayoutAnimated(duration, 0, 0, w - 2 * bw, contentH)
		mBase.Height = titleH + contentH + 2 * bw
	Else
		pnlContent.SetLayoutAnimated(duration, bw, titleH + bw, w - 2 * bw, 1dip)
		Content.SetLayoutAnimated(duration, 0, 0, w - 2 * bw, 1dip)
		mBase.Height = titleH + 2 * bw
		If Animated And duration > 0 Then
			Sleep(duration)
			If mOpen = False Then pnlContent.Visible = False
		Else
			pnlContent.Visible = False
		End If
	End If
	mIsAnimating = False
	
	' If standalone (not inside accordion), auto-shift page siblings by the height delta.
	' If inside an accordion, the accordion's Base_Resize handles sibling repositioning.
	Dim parentView As B4XView = mBase.Parent
	If parentView.IsInitialized Then
		If (parentView.Tag Is B4XDaisyAccordion) = False Then
			B4XDaisyVariants.ShiftSiblingsBelow(mBase, mBase.Height - oldH, IIf(Animated, 200, 0))
		End If
	End If
	
	If mIcon <> "none" Then DrawIcon
	
	If xui.SubExists(mCallBack, mEventName & "_StateChanged", 1) Then
		CallSub2(mCallBack, mEventName & "_StateChanged", mOpen)
	End If
	
	If mOpen And mGroupName.Length > 0 Then
		If xui.SubExists(mCallBack, mEventName & "_RequestGroupSelect", 1) Then
			CallSub2(mCallBack, mEventName & "_RequestGroupSelect", mGroupName)
		End If
	End If
	' if we are inside an accordion, let it know so it can reposition siblings
	Dim p As B4XView = mBase.Parent
	If p.IsInitialized Then
		If p.Tag Is B4XDaisyAccordion Then
			Dim acc As B4XDaisyAccordion = p.Tag
			' Always notify the accordion: on open it enforces single-open mode;
			' on close it restacks siblings to remove the gap left by the shrunk item.
			If mOpen Then acc.HandleChildRequestOpen(Me)
			acc.Refresh
		End If
	End If
End Sub

Private Sub MeasureContentHeight As Int
	' Auto-measures height by finding the bottom edge of the lowest visible child
	' plus bottom padding. No explicit height needs to be provided.
	' Align with B4XDaisyCollapseContent padding (16dip * 1.5 bottom)
	Dim pad As Int = 16dip
	Dim total As Int = 0
	Dim container As B4XView = Content.getContainer
	For i = 0 To container.NumberOfViews - 1
		Dim v As B4XView = container.GetView(i)
		If v.Visible Then
			total = Max(total, v.Top + v.Height + (pad * 1.5))
		End If
	Next
	Return Max(48dip, total)
End Sub

Public Sub setOpen(Value As Boolean)
	If mOpen = Value Then Return
	mOpen = Value
	UpdateOpenState(True)
End Sub

Public Sub getOpen As Boolean
	Return mOpen
End Sub

Public Sub Toggle
	setOpen(Not(mOpen))
End Sub

Public Sub setIcon(Value As String)
	mIcon = Value.ToLowerCase
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getIcon As String
	Return mIcon
End Sub

Public Sub setVariant(Value As String)
	mVariant = B4XDaisyVariants.NormalizeVariant(Value)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVariant As String
	Return mVariant
End Sub

Public Sub setRounded(Value As String)
	mRounded = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

'/**
' * Updates elevation shadow token and refreshes the component.
' * @param Value (String) New value to apply.
' */
Public Sub setShadow(Value As String)
	mShadow = B4XDaisyVariants.NormalizeShadow(Value)
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getShadow As String
	Return mShadow
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setTitleText(Value As String)
	mTitleText = Value
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleText As String
	Return mTitleText
End Sub

Public Sub setTitleVariant(Value As String)
	mTitleVariant = B4XDaisyVariants.NormalizeVariant(Value)
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleVariant As String
	Return mTitleVariant
End Sub

Public Sub setTitleSize(Value As String)
	mTitleSize = Value
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleSize As String
	Return mTitleSize
End Sub

Public Sub setTitleBackgroundColor(Value As Int)
	mTitleBackgroundColor = Value
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleBackgroundColor As Int
	Return mTitleBackgroundColor
End Sub

Public Sub setTitleTextColor(Value As Int)
	mTitleTextColor = Value
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleTextColor As Int
	Return mTitleTextColor
End Sub

Public Sub setTitleIconName(Value As String)
	mTitleIconName = Value
	If mBase.IsInitialized Then
		RefreshTitle
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getTitleIconName As String
	Return mTitleIconName
End Sub

Public Sub setTitleColor(Value As Int)
	mTitleColor = Value
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleColor As Int
	Return mTitleColor
End Sub

Public Sub setTitleIconColor(Value As Int)
	mTitleIconColor = Value
	If mBase.IsInitialized Then RefreshTitle
End Sub

Public Sub getTitleIconColor As Int
	Return mTitleIconColor
End Sub

' Resolves the component width from the stored WidthMode token.
' Uses mBase.Parent width when available, otherwise falls back to RequestedWidth.
Private Sub ResolveComponentWidth(RequestedWidth As Double) As Int
	If mWidthMode = "w-full" Or mWidthMode = "" Then Return Max(1dip, RequestedWidth)
	Dim parentW As Int = IIf(mBase.Parent.IsInitialized And mBase.Parent.Width > 0, mBase.Parent.Width, Max(1dip, RequestedWidth))
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mWidthMode, parentW))
End Sub

' Same as ResolveComponentWidth but uses an explicit parent view (for AddToParent before mBase is attached).
Private Sub ResolveComponentWidth2(Parent As B4XView, RequestedWidth As Int) As Int
	If mWidthMode = "w-full" Or mWidthMode = "" Then Return Max(1dip, RequestedWidth)
	Dim parentW As Int = IIf(Parent.IsInitialized And Parent.Width > 0, Parent.Width, Max(1dip, RequestedWidth))
	Return Max(1dip, B4XDaisyVariants.TailwindSizeToDip(mWidthMode, parentW))
End Sub

''' <summary>Forces re-measurement of content height and updates the component size if open.
''' Call this after dynamically adding or removing views from ContentView.</summary>
Public Sub RefreshContent
	If mBase.IsInitialized = False Then Return
	If mOpen Then UpdateOpenState(False)
End Sub

Public Sub setWidth(Value As String)
	mWidthMode = Value
	If mBase.IsInitialized Then
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Public Sub getWidth As String
	Return mWidthMode
End Sub

' Sets the border width using a Tailwind utility string (e.g. "border", "border-2", "border-0").
Public Sub setBorderStyle(Value As String)
	mBorderStyle = Value.ToLowerCase.Trim
	If mBase.IsInitialized Then Refresh
End Sub

Public Sub getBorderStyle As String
	Return mBorderStyle
End Sub

Public Sub setBorderWidth(Value As String)
	mBorderWidth = Value
	If mBase.IsInitialized Then Refresh
End Sub

' Gets the current border width utility string.
Public Sub getBorderWidth As String
	Return mBorderWidth
End Sub

' Sets the border color using a Tailwind utility string (e.g. "border-primary", "border-base-300").
Public Sub setBorderColor(Value As String)
	mBorderColor = Value
	If mBase.IsInitialized Then Refresh
End Sub

' Gets the current border color utility string.
Public Sub getBorderColor As String
	Return mBorderColor
End Sub

' Sets the tag property.
Public Sub setTag(Value As Object)
	mTag = Value
End Sub

' Gets the tag property.
Public Sub getTag As Object
	Return mTag
End Sub

' Sets the icon position ("left" or "right").
Public Sub setIconPosition(Value As String)
	mIconPosition = Value.ToLowerCase
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

' Gets the current icon position.
Public Sub getIconPosition As String
	Return mIconPosition
End Sub

Public Sub setGroupName(Value As String)
	mGroupName = Value
End Sub

Public Sub getGroupName As String
	Return mGroupName
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		DesignerCreateView(p, Null, CreateMap())
	End If
	If mBase.Parent.IsInitialized Then mBase.RemoveViewFromParent
	Dim resolvedW As Int = ResolveComponentWidth2(Parent, Width)
	Parent.AddView(mBase, Left, Top, resolvedW, Height)
	Refresh
	Return mBase
End Sub

''' <summary>
''' Returns the current rendered height of this collapse item.
''' </summary>
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

Public Sub CollapseTitle As B4XDaisyCollapseTitle
	Return Title
End Sub

Public Sub CollapseContent As B4XDaisyCollapseContent
	Return Content
End Sub

' Returns the inner content container view.
' Use this to AddView children or call LoadLayout directly:
'   Dim p As Panel = collapse.ContentView
'   p.LoadLayout("MyLayout")
'   collapse.ContentView.AddView(myLabel, 0, 0, 200dip, 40dip)
Public Sub getContentView As B4XView
	Return Content.getContainer
End Sub

Private Sub ResolveRadius As Float
	If mRounded = "theme" Then Return B4XDaisyVariants.GetRadiusBoxDip(12dip)
	Return B4XDaisyVariants.ResolveRoundedDip(mRounded, B4XDaisyVariants.GetRadiusBoxDip(12dip))
End Sub

Private Sub pnlTitle_Click
	Toggle
	If mEventName.Length > 0 Then
		If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
			CallSub2(mCallBack, mEventName & "_Click", mTag)
		End If
	End If
End Sub

Private Sub Title_Click (Tag As Object)
	pnlTitle_Click
End Sub