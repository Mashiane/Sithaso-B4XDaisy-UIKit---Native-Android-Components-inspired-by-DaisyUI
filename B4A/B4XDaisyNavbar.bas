B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Payload As Object)
#Event: Opened
#Event: Closed

#DesignerProperty: Key: Variant, DisplayName: Variant, FieldType: String, DefaultValue: none, List: none|primary|secondary|accent|neutral|info|success|warning|error, Description: Daisy variant for coloring
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Navbar background color (0 = theme base-100/variant)
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0x00000000, Description: Navbar text color (0 = theme base-content/variant)
#DesignerProperty: Key: Shadow, DisplayName: Shadow, FieldType: String, DefaultValue: sm, List: none|sm|md|lg|xl|2xl, Description: Shadow level
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: none, List: theme|none|sm|rounded|md|lg|xl|2xl|3xl|full, Description: Corner radius style
#DesignerProperty: Key: Glass, DisplayName: Glass, FieldType: Boolean, DefaultValue: False, Description: Enable glass effect
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 8, Description: Internal padding in dip
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: full, Description: Tailwind size token or CSS size (eg full, 72, 320px, 20rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 64, Description: Tailwind size token or CSS size (eg 64, 4rem, 80px)

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
	Private miPadding As Int = 8dip

	Private msWidth As String = "full"
	Private msHeight As String = "64"
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


	ApplyDesignerProps(Props)
	
	' Grab children from the original Base panel that were added in the designer
	GrabDesignerChildren
	
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub CreateSlotPanel(Tag As String) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim v As B4XView = p
	v.Color = xui.Color_Transparent
	v.Tag = Tag
	Return v
End Sub


Private Sub ApplyDesignerProps(Props As Map)
	msVariant = B4XDaisyVariants.NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "Variant", msVariant))
	mcBackgroundColor = ResolveColorValue(Props.Get("BackgroundColor"), mcBackgroundColor)
	mcTextColor = ResolveColorValue(Props.Get("TextColor"), mcTextColor)
	msShadow = B4XDaisyVariants.NormalizeShadow(B4XDaisyVariants.GetPropString(Props, "Shadow", msShadow))
	msRounded = B4XDaisyVariants.NormalizeRounded(B4XDaisyVariants.GetPropString(Props, "Rounded", msRounded))
	mbGlass = B4XDaisyVariants.GetPropBool(Props, "Glass", mbGlass)
	miPadding = B4XDaisyVariants.GetPropInt(Props, "Padding", 8) * 1dip
	
	msWidth = B4XDaisyVariants.GetPropString(Props, "Width", "full")
	msHeight = B4XDaisyVariants.GetPropString(Props, "Height", "64")
	mWidthDip = B4XDaisyVariants.TailwindSizeToDip(msWidth, 100%x)
	mHeightDip = B4XDaisyVariants.TailwindSizeToDip(msHeight, 64dip)
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

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or Surface.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	
	Surface.SetLayoutAnimated(0, 0, 0, w, h)
	ApplyVisualStyle
	
	LayoutSlots(w, h)
End Sub

Private Sub LayoutSlots(Width As Int, Height As Int)
	Dim startW As Int = MeasureSlotContentWidth(mStartSlot)
	Dim endW As Int = MeasureSlotContentWidth(mEndSlot)
	Dim centerW As Int = MeasureSlotContentWidth(mCenterSlot)
	
	Dim padding As Int = miPadding * 2
	Dim availableW As Int = Width - padding
	
	' DaisyUI Pattern: .navbar-start and .navbar-end take 50% each if possible
	' .navbar-center takes only what it needs and is centered.
	
	' Balanced side slots
	Dim sideW As Int = Max(0, (availableW - centerW) / 2)
	
	' We use Max(startW, sideW) to ensure slots are at least sideW wide for centering centerW.
	Dim finalStartW As Int = Max(startW, sideW)
	Dim finalEndW As Int = Max(endW, sideW)
	
	' Pin Start to left padding
	mStartSlot.SetLayoutAnimated(0, miPadding, 0, finalStartW, Height)
	LayoutSlotFill(mStartSlot, "LEFT")
	
	' Pin End to right padding
	mEndSlot.SetLayoutAnimated(0, Width - finalEndW - miPadding, 0, finalEndW, Height)
	LayoutSlotFill(mEndSlot, "RIGHT")
	
	' Center stays exactly in the middle
	mCenterSlot.SetLayoutAnimated(0, (Width - centerW) / 2, 0, centerW, Height)
	LayoutSlotFill(mCenterSlot, "CENTER")
End Sub

Private Sub LayoutSlotFill(Slot As B4XView, Alignment As String)
	If Slot.NumberOfViews = 0 Then Return
	Dim slotW As Int = Slot.Width
	Dim slotH As Int = Slot.Height
	Dim gap As Int = 8dip
	Dim align As String = Alignment.ToUpperCase.Trim
	
	Select Case align
		Case "RIGHT", "END"
			Dim totalContentW As Int = 0
			For i = 0 To Slot.NumberOfViews - 1
				totalContentW = totalContentW + Slot.GetView(i).Width + gap
			Next
			totalContentW = totalContentW - gap
			
			Dim cursorX As Int = slotW - totalContentW
			For i = 0 To Slot.NumberOfViews - 1
				Dim v As B4XView = Slot.GetView(i)
				v.SetLayoutAnimated(0, cursorX, (slotH - v.Height) / 2, v.Width, v.Height)
				cursorX = cursorX + v.Width + gap
			Next
		Case "CENTER", "MIDDLE"
			Dim totalContentW As Int = 0
			For i = 0 To Slot.NumberOfViews - 1
				totalContentW = totalContentW + Slot.GetView(i).Width + gap
			Next
			totalContentW = totalContentW - gap
			
			Dim cursorX As Int = (slotW - totalContentW) / 2
			For i = 0 To Slot.NumberOfViews - 1
				Dim v As B4XView = Slot.GetView(i)
				v.SetLayoutAnimated(0, cursorX, (slotH - v.Height) / 2, v.Width, v.Height)
				cursorX = cursorX + v.Width + gap
			Next
		Case Else ' LEFT / START
			Dim totalContentW As Int = 0
			For i = 0 To Slot.NumberOfViews - 1
				totalContentW = totalContentW + Slot.GetView(i).Width + gap
			Next
			totalContentW = totalContentW - gap
			
			' For LEFT, we start at 0 but we could just use cursorX for consistency
			Dim cursorX As Int = 0
			For i = 0 To Slot.NumberOfViews - 1
				Dim v As B4XView = Slot.GetView(i)
				v.SetLayoutAnimated(0, cursorX, (slotH - v.Height) / 2, v.Width, v.Height)
				cursorX = cursorX + v.Width + gap
			Next
	End Select
End Sub

Private Sub MeasureSlotContentWidth(Slot As B4XView) As Int
	Dim totalW As Int = 0
	Dim gap As Int = 8dip
	For i = 0 To Slot.NumberOfViews - 1
		Dim v As B4XView = Slot.GetView(i)
		totalW = totalW + v.Width + gap
	Next
	If totalW > 0 Then totalW = totalW - gap
	Return Max(1dip, totalW)
End Sub

Private Sub GetActualView(v As B4XView) As B4XView
	Return v
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
	
	If mbGlass Then
		Dim glassSpec As Map = B4XDaisyVariants.GetGlassSpec
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

Private Sub SetTextColorRecursive(Parent As B4XView, Color As Int)
	If Parent.IsInitialized = False Then Return
	Dim numViews As Int = 0
	Try
		numViews = Parent.NumberOfViews
	Catch
		Return ' Not a container
	End Try
	
	For i = 0 To numViews - 1
		Dim v As B4XView = Parent.GetView(i)
		If v Is Label Then
			v.TextColor = Color
		Else If v.Tag <> Null And xui.SubExists(v.Tag, "setTextColor", 1) Then
			CallSub2(v.Tag, "setTextColor", Color)
		Else
			SetTextColorRecursive(v, Color)
		End If
	Next
End Sub

'========================
' Public Section API
'========================

Public Sub GetStartPanel As B4XView
	Return mStartSlot
End Sub

Public Sub GetCenterPanel As B4XView
	Return mCenterSlot
End Sub

Public Sub GetEndPanel As B4XView
	Return mEndSlot
End Sub

Public Sub AddViewToStart(v As B4XView, Width As Int, Height As Int)
	v.RemoveViewFromParent
	mStartSlot.AddView(v, 0, (mHeightDip - Height) / 2, Width, Height)
	Refresh
End Sub

Public Sub AddViewToCenter(v As B4XView, Width As Int, Height As Int)
	v.RemoveViewFromParent
	mCenterSlot.AddView(v, 0, (mHeightDip - Height) / 2, Width, Height)
	Refresh
End Sub

Public Sub AddViewToEnd(v As B4XView, Width As Int, Height As Int)
	v.RemoveViewFromParent
	mEndSlot.AddView(v, 0, (mHeightDip - Height) / 2, Width, Height)
	Refresh
End Sub

Public Sub AddTitleToCenter(Title As String)
	AddTitleToSlot(mCenterSlot, Title, "CENTER")
End Sub

Public Sub AddTitleToStart(Title As String)
	AddTitleToSlot(mStartSlot, Title, "LEFT")
End Sub

Public Sub AddTitleToEnd(Title As String)
	AddTitleToSlot(mEndSlot, Title, "RIGHT")
End Sub

Private Sub AddTitleToSlot(Slot As B4XView, Title As String, Align As String)
	Dim lbl As Label
	lbl.Initialize("")
	lbl.SingleLine = True
	Dim xl As B4XView = lbl
	xl.Text = Title
	xl.SetTextAlignment("CENTER", Align)
	
	Dim fontSize As Float = 16
	Dim fnt As B4XFont = xui.CreateDefaultBoldFont(fontSize)
	xl.Font = fnt
	
	' Pass explicit alignment to measurement to ensure consistency if needed
	Dim tw As Int = MeasureTextWidthDip(Title, fnt)
	
	Slot.AddView(xl, 0, 0, tw, 40dip)
	Refresh
End Sub

' Adds a hamburger menu (swap component) to the start slot.
' Fires Opened/Closed events when toggled.
Public Sub AddHamburger(SizeDip As Int)
	Dim sw As B4XDaisySwap
	sw.Initialize(Me, "Hamburger")
	Dim swView As B4XView = sw.CreateView(SizeDip, SizeDip)
	sw.setSwapType("svg")
	sw.setOnText("xmark-solid.svg")
	sw.setOffText("bars-solid.svg")
	
	AddViewToStart(swView, SizeDip, SizeDip)
End Sub

' Internal handler for hamburger toggle
Private Sub Hamburger_Changed(State As String, Checked As Boolean)
	If Checked Then
		If xui.SubExists(mCallBack, mEventName & "_Opened", 0) Then
			CallSub(mCallBack, mEventName & "_Opened")
		End If
	Else
		If xui.SubExists(mCallBack, mEventName & "_Closed", 0) Then
			CallSub(mCallBack, mEventName & "_Closed")
		End If
	End If
End Sub

' Adds a logo (avatar component) to the start slot.
Public Sub AddLogo(ImagePath As String, WidthDip As Int, HeightDip As Int, Mask As String)
	Dim av As B4XDaisyAvatar
	av.Initialize(Me, "")
	Dim avView As B4XView = av.CreateView(WidthDip, HeightDip)
	av.setAvatarMask(Mask)
	av.setAvatar(ImagePath)
	av.setAvatarSize(WidthDip & "px")
	
	AddViewToStart(avView, WidthDip, HeightDip)
End Sub

Private Sub MeasureTextWidthDip(Text As String, Font As B4XFont) As Int
	Dim t As String = Text
	If t = Null Or t.Trim.Length = 0 Then Return 16dip
	Dim r As B4XRect = cvsMeasure.MeasureText(t.Trim, Font)
	Return Ceil(r.Width) + 12dip ' Increased buffer to avoid clipping and allow padding
End Sub

Public Sub AddAvatarToEnd(ImagePath As String, SizeDip As Int)
	AddAvatarToSlot(mEndSlot, ImagePath, SizeDip)
End Sub

Public Sub AddAvatarToStart(ImagePath As String, SizeDip As Int)
	AddAvatarToSlot(mStartSlot, ImagePath, SizeDip)
End Sub

Private Sub AddAvatarToSlot(Slot As B4XView, ImagePath As String, SizeDip As Int)
	Dim av As B4XDaisyAvatar
	av.Initialize(mCallBack, "")
	' CreateView returns mBase, which handles internal layout
	Dim avView As B4XView = av.CreateView(SizeDip, SizeDip)
	av.SetImage(ImagePath)
	av.setAvatarMask("rounded-full")
	Slot.AddView(avView, 0, 0, SizeDip, SizeDip)
	Refresh
End Sub

Private Sub Refresh
	If mBase.IsInitialized Then 
		B4XDaisyVariants.DisableClipping(mBase)
		If mBase.Parent.IsInitialized Then B4XDaisyVariants.DisableClipping(mBase.Parent)
		Base_Resize(mBase.Width, mBase.Height)
	End If
End Sub

Private Sub InitializePalette
	VariantPalette = B4XDaisyVariants.GetVariantPalette
End Sub

Private Sub ResolveColorValue(Value As Object, DefaultColor As Int) As Int
	If Value = Null Then Return DefaultColor
	If IsNumber(Value) Then Return Value
	Dim s As String = "" & Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultColor
	Dim token As String = B4XDaisyVariants.ResolveThemeColorTokenName(s)
	If token.Length > 0 Then Return B4XDaisyVariants.GetTokenColor(token, DefaultColor)
	Return DefaultColor
End Sub

'========================
' Standard B4X API Adapters
'========================

Public Sub setVariant(Value As String)
	msVariant = B4XDaisyVariants.NormalizeVariant(Value)
	Refresh
End Sub

Public Sub getVariant As String
	Return msVariant
End Sub

Public Sub setRounded(Value As String)
	msRounded = B4XDaisyVariants.NormalizeRounded(Value)
	Refresh
End Sub

Public Sub getRounded As String
	Return msRounded
End Sub

Public Sub setShadow(Value As String)
	msShadow = B4XDaisyVariants.NormalizeShadow(Value)
	Refresh
End Sub

Public Sub getShadow As String
	Return msShadow
End Sub

Public Sub setGlass(Value As Boolean)
	mbGlass = Value
	Refresh
End Sub

Public Sub getGlass As Boolean
	Return mbGlass
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setBackgroundColor(Value As Int)
	mcBackgroundColor = Value
	Refresh
End Sub

Public Sub getBackgroundColor As Int
	Return mcBackgroundColor
End Sub

Public Sub setTextColor(Value As Int)
	mcTextColor = Value
	Refresh
End Sub

Public Sub getTextColor As Int
	Return mcTextColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
	InitializePalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim bgBase100 As Int = tokens.GetDefault("--color-base-100", xui.Color_White)
	Dim c As Int = B4XDaisyVariants.ResolveBackgroundColorVariantFromPalette(VariantPalette, VariantName, bgBase100)
	setBackgroundColor(c)
End Sub

Public Sub setTextColorVariant(VariantName As String)
	InitializePalette
	Dim tokens As Map = B4XDaisyVariants.GetActiveTokens
	Dim fgBaseContent As Int = tokens.GetDefault("--color-base-content", xui.Color_RGB(31, 41, 55))
	Dim c As Int = B4XDaisyVariants.ResolveTextColorVariantFromPalette(VariantPalette, VariantName, fgBaseContent)
	setTextColor(c)
End Sub

Public Sub setWidth(Value As Object)
	msWidth = "" & Value
	mWidthDip = B4XDaisyVariants.TailwindSizeToDip(msWidth, 100%x)
	If mBase.IsInitialized Then
		mBase.Width = mWidthDip
		Refresh
	End If
End Sub

Public Sub getWidth As Float
	Return mWidthDip
End Sub

Public Sub setHeight(Value As Object)
	msHeight = "" & Value
	mHeightDip = B4XDaisyVariants.TailwindSizeToDip(msHeight, 64dip)
	If mBase.IsInitialized Then
		mBase.Height = mHeightDip
		Refresh
	End If
End Sub

Public Sub getHeight As Float
	Return mHeightDip
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	If Parent.IsInitialized = False Then Return mBase
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	' Create mBase if not initialized (though usually Initialize is called first)
	If mBase.IsInitialized = False Then
		Dim p As Panel
		p.Initialize("")
		mBase = p
		mBase.Color = xui.Color_Transparent
		mBase.SetLayoutAnimated(0, 0, 0, w, h)
		Dim props As Map
		props.Initialize
		' Minimal props for programmatic path
		DesignerCreateView(mBase, Null, props)
	End If
	Parent.AddView(mBase, Left, Top, w, h)
	Base_Resize(w, h)
	Return mBase
End Sub
